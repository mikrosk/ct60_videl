#include <osbind.h>

void save_videl(void);
void restore_videl(void);

void save_cache(void);
void flush_cache(void);
void restore_cache(void);

void picture_boot(void);

static long old_ssp;

int main(int argc, const char* argv[])
{
	old_ssp = Super(0L);
	save_videl();
	save_cache();
	flush_cache();

	picture_boot();

	restore_cache();
	restore_videl();
	Super(old_ssp);

	return 0;
}
