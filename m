Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703C5606A895
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SO5iDSsd
Received: by kanga.kvack.org (Postfix)
	id 7A5006B05CC; Fri, 13 Nov 2026 01:25:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D0F6B05D5; Fri, 13 Nov 2026 01:25:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6955F6B05E1; Fri, 13 Nov 2026 01:25:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDEF6B05CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:25:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37EDA160515
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:25:16 +0000 (UTC)
X-FDA: 85429108632.22.1B70649
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5941B40002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:25:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SO5iDSsd;
	spf=pass (imf17.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794551114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tlK4/UTFCYCg7fMWH6nOmeYXoGJRxWoGIF/cCb+vIs=;
	b=b729LPzoUrCa2uONy2hpbWf4v/zBYHC2NXfqnT/2a0kXVP+sxtOn7+QNskA6v87ofE9Esj
	jeg84Df6OjXna8kVO/KqvATDS7Ph+8bi1NmNgwI3wUv3kAgSZ7nD0UiIBvHM+4o19yBYue
	URiHJYEOhN7BXZYE6Xrl1HvypjCeo4M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SO5iDSsd;
	spf=pass (imf17.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794551114;
	b=a+VBGo3798ToWFeBLagTQvY+CB+rjMyPv8fudAmkkq4af/iuCigRr8AlyQG1iro39hUGEp
	FPvRJUbszWsUr3A2llIoeKFB/b80zxLg1qYVGN9PvcLvW08igGzwmwaKRMbJuAsIhq8LG7
	jaDCsJLlTzqpXKZjuqxHjEZ2LS5M81o=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36dbde64409so1010963eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794551113; x=1795155913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3tlK4/UTFCYCg7fMWH6nOmeYXoGJRxWoGIF/cCb+vIs=;
        b=SO5iDSsdJDDtoODQ26EEhqHyB5yG8/pwi2WpI7Nd8ECKTl9na++tmCeU7UR4U43CHy
         7EQlhARvIdFAVR2acWgnR3fKQevr5ZdzjVJLt2fGc1KgkMZV6ZobRcNTKFFWcgGKklVG
         OJeECz1VMym9xqZaN3zdmyg3NQZAwEgt37sGEjk6uFeIY35i/f68j5JbVS1WuokRQkN6
         l9Zt+QbFUsIOxSOQwN+GQObXbukbaSmpz39/Eq2mU7WLTbwzPyHdKi4UXy/f/7xTVSHA
         KIauMyap9SFL9UGfdPBK0Cp8WUcHCSHdIuV0AU2xNaD13xouKmJQZQat9oOMFQgWAJci
         35Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794551113; x=1795155913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3tlK4/UTFCYCg7fMWH6nOmeYXoGJRxWoGIF/cCb+vIs=;
        b=UjP+Ud1moreT9XyVFxGmrIVv5x3sblE5MxLEl//Jvg5lxLj2CcQyuzzWakKiFTE5n3
         IWIl2ld1chTF/Ikl7McgW8IhUrEfoOeKvqtjhw9Vv7YN+RCgY+2n7mx+LJAlZIjycLsr
         rtUYIabhSrvg3VhxVKsAdcxflOW5/vzYiiJjnhsQOI5s7FcqbHzW8uULD0fz3+w8y6tT
         jMrvgmpQRzEJd6KuEmHHjjIIcwIQl2eM2YM2JoLVdJm1nblNHOatUUDnWEPw2SkpXdkC
         0MLjBDokfq3j0vUK96lLRp4fvCgBz1XXZUXn25URDh8Oi3kA8vlAkkttZ5zMzBjjWzpf
         Y/Pw==
X-Forwarded-Encrypted: i=1; AL+hErFdj5X4JgBleDn7LEIyYMnwpd/h6m9gRp8q4i/RzYVm+75WKl7lEqeLa7RbT+VkGy4FHLOQbN4sFw==@kvack.org
X-Gm-Message-State: APuU4Z8YKdVhFWZ14R/qCxhWjLlYYWNu+DYYG11VzefN5nXrenOoBMCH
	t0yEIMZLiS9tp9nHvpRCantwblLic8nAMv5JpEsqnmr5EpfkZ8w81ses
X-Gm-Gg: AYBFou2c4YbgDidhvD/7cBGECxX92uoXcB24tldfTeptoOvOfqkwTmFn/M+VnRJHvyq
	xKvc/sjg5fLte26/du6w+yJDPW4ORw1ruawE1vKKR4TuhiP8AbFL2n69UfjSbGQ8HU7r+TyRZjV
	Q+2O7mY3LETFiUMaI/kbxfjJ5qXvinmecp2cX4ZWAaT3/jys771M7NSKlD8+TuIBK2S1zAtwGM3
	YiG8z3jcldxkft8uUqyDu8xpbYWsp948EYlPglrlil2/TXCklBjRIvlF9yilYJTjM3JzJGFJXx6
	N6L/tCg/qL6kI0Hx1BUdWACnexXm2rzoMrW6m2JlDpyHhC6P0tzPtIn2nUr7+4oaQR9EJfgMdpD
	HztjPDDbav4mjOrO1R1639wiiyRtPDfj9eyxBqxc9zBKufIAGXSqowsCqVP+y157P4p3VG9arzR
	gMHFVVZI868d2RAcLY4C89KczwGZBVFmnFc3xGgODEJa16etuxpETKrUG6nrzBxbY8kEDeaanCd
	2QJrkcBGdl3SrAcmrz9c7EKGvosR89z0CUTxeJZIya52G6EhP00BeCbWACGPeAh2X5eAv6xIBbT
	l03YJIEcz8fpyNELLee9bZaJ8B/SrvtpwRWrrGkm6PUHN/72qudTjfN9x+ZWtoS1shc=
X-Received: by 2002:a05:693c:894f:20b0:36d:5102:9974 with SMTP id 5a478bee46e88-379636607famr1340509eec.2.1794551112863;
        Thu, 12 Nov 2026 22:25:12 -0800 (PST)
Received: from LAPTOP-KD1TH5BD.tail375eb4.ts.net ([47.11.114.36])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795533170csm4309715eec.7.2026.11.12.22.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 22:25:12 -0800 (PST)
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
To: alireza.haddadi@it.uu.se
Cc: jack@suse.cz,
	willy@infradead.org,
	akpm@linux-foundation.org,
	vishal.moola@gmail.com,
	fujunjie1@qq.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	tracekotae@gmail.com
Subject: Re: [PATCH] mm/filemap: let sequential faults restart mmap readahead
Date: Fri, 13 Nov 2026 06:24:46 +0000
Message-ID: <20261113062446.193820-1-gopalmalaviya53@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <26E03EC6-F37C-4350-B2A9-1F354217F469@it.uu.se>
References: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se> <20261111042310.191979-1-gopalmalaviya53@gmail.com> <26E03EC6-F37C-4350-B2A9-1F354217F469@it.uu.se>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wx3m3q5eropyuuqdk3zc43j4xkd137i7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5941B40002
X-HE-Tag: 1794551114-205128
X-HE-Meta: U2FsdGVkX19f3p5rRhmuUCYhiLMRrZ5QmM0OpEzRAEU5ihkyzi/LmOp1Z1cnfLFi/ruMGPhT+Diab3XSqEh/sorH3xXvNINXZUu3B/0w1EudHlr6zH3EybG8TmBE1x3VxetD2Bwgfuv0u3RCJS51Pfj5dR6ZZBFC2vKjgmCppsL4g4ELoMgmYbczI0GwKRYHMSafYXad4kegmiX7STNumobgM5JnVcYRv4dkBn/T5c1+Kgta2ICduy7PunNoU459y0VXAoPgtUcqyqjCl4bjxofjBJ5nHmQb8z30TIC7JCB8xKTVARhZXDBUiebPXJNNl4GdjLgAUndy/lSCEnbeqpoUl+Kc7aP3HZ6bodCycodJJq1W3TViVsbvAOrxPj3Zxx9YlTmnYQ8SIFWlj97vAEFX94jEzcuPPh/AplIwI85b5bmwlUFPPw3R9pSlUev328qXdCDsmRlLzQQuv5moqOO5dJnGz+AFURPvKHnyO6R8OPBrMcAwtIwmc7qAubZSQK/C7d5NZp72roXmaQhPLW4SJryuAHvTNpvvuutdt1PMqvUcLMKyz6Jq5gqEQuPdw1FCUA11j690fQxNhVRH0S3z9vPD+mUsJKcYzR7KzN1PhnsbaBrHufXaJ+wChKa8YZOHcQgp/y+RhRE8U621FLYe5iADhstm/Ru7epmlY0FIUe+Jc8cpqbmnwQ4NwkPMh303Ic2u2JIQ8vlm3GTM1nz0cnYIW9P5zGRz0uSy0ARwvVRAGcYEXv0ejVOelcKCTOkeN/k2CqjnJgZy6/AB9AePViX8XxX0w8MBmh2tPdA/qY5nXMv2Zip2VQe+G4sQcSzLic4p0laXD6g5BZkzJOpGiQ61RlAFXNNHm+p9WecKNREyiofetd1ngyngTGQtAmmBatUgdkmdNvz8GgWBcZ2Qi3qtd9ikGrf8pwumnIgZES9C0VbsDs7W0W8X5338h5Povy7xYcijtQWWUUu
 CTjH+38o
 9tqaXe0Y38H/KOEysEXVgbFwKKvnuf+XHjrNQ7/tTVAEEjffn+rgpzlYKOWWTRvg8nS6ZP0PEkVxn9MnsbkOD5JiOcger4MnX3H6wzWtM9TmT6gNmRNTdIf0a0QuV9Hza8aal0XaIpHijbkXwWw5gk6HEWCeGIEUPvaD6Py4h7wkX5jFBnh1PsJG2B2c7DCiWtSoj8P3vNJcYAF17gdgSfrfENyLuF4CZVb4xtMcZDCXxk7xle2q9FHbQ4xtodhfWHdcX5LVadUTzBP6OYwyVJvgqJlw0G4BmzLXP81xsT3VqN/wSfJ/ABYjiUkQpFf1Fa/ZnNUdxG7wEI+pAXbyVu2Cff3uRh6S/cT4cZnQMM5h31PeFPfluodeuwm//KS0q8Xhza7zb4EGEOVoeFaUKz23qmMDEP4AmodXmquMxypreUHJaKeetkzX7I6/EnbGaagCwEdE8hFj6ZHS/trfKbyJIqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 07:43:54AM +0000, Alireza Haddadi wrote:
> That would be great, thank you. Could you share the short-run test,
> So I can run the same here while working on it?

Sure, it is below. It writes the file (or reuses it with "keep"),
drops it from the page cache with POSIX_FADV_DONTNEED, touches 1% of
its pages through a MAP_PRIVATE mapping and prints the MiB read
(pgpgin in /proc/vmstat) and the major faults for each pattern:

  ./mmap-rand FILE               2600 MiB file, removed at the end
  ./mmap-rand FILE 20480 keep    20 GiB file, kept for the next run

The tables came from the second form in a 3 GiB guest, with
"echo 128 > /sys/block/vda/queue/read_ahead_kb" (or 8192) before each
run. "random 4-page recs" is the short-run case. Like the earlier
tests, the program was written with the help of an AI assistant.

Thanks,
Gopal

---8<--- mmap-rand.c
/*
 * mmap-rand.c: how much does the kernel read from disk for sparse
 * mmap access (random, and fixed stride) on a cold file?
 * Reports disk input (pgpgin from /proc/vmstat) and major faults.
 *
 *   ./mmap-rand FILE        (FILE must not exist; removed at the end)
 *   ./mmap-rand FILE SIZE_MIB keep   (reuse FILE if it exists, keep it)
 */
#define _GNU_SOURCE
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>

#define MIB	(1UL << 20)
static unsigned long SIZE = 2600 * MIB;

static long pgpgin_kib(void)
{
	char name[64];
	long val;
	FILE *f = fopen("/proc/vmstat", "r");

	if (!f)
		err(1, "/proc/vmstat");
	while (fscanf(f, "%63s %ld", name, &val) == 2)
		if (!strcmp(name, "pgpgin")) {
			fclose(f);
			return val;
		}
	errx(1, "no pgpgin");
}

static long majflt(void)
{
	struct rusage ru;

	getrusage(RUSAGE_SELF, &ru);
	return ru.ru_majflt;
}

static void run(const char *path, const char *name, unsigned long stride,
		unsigned long rec)
{
	unsigned long page = sysconf(_SC_PAGESIZE), npages = SIZE / page;
	unsigned long n = npages / 100, i, idx;	/* touch 1% of the pages */
	long in0, mf0;
	volatile char sink;
	char *m;
	int fd;

	fd = open(path, O_RDONLY);
	if (fd < 0)
		err(1, "open");
	if (posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED))
		errx(1, "posix_fadvise");
	m = mmap(NULL, SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
	if (m == MAP_FAILED)
		err(1, "mmap");

	srandom(1);
	in0 = pgpgin_kib();
	mf0 = majflt();
	for (i = 0; i < n; i += rec) {
		unsigned long j;

		idx = stride ? (i * stride) % npages : random() % (npages - rec);
		for (j = 0; j < rec; j++)	/* a record of rec adjacent pages */
			sink = m[(idx + j) * page];
	}
	printf("%-20s %6lu touches %8ld MiB read %6ld major faults\n", name, n,
	       (pgpgin_kib() - in0) / 1024, majflt() - mf0);

	(void)sink;
	munmap(m, SIZE);
	close(fd);
}

int main(int argc, char **argv)
{
	static char buf[MIB];
	unsigned long i;
	int fd;

	if (argc != 2 && argc != 4)
		errx(2, "usage: %s FILE [SIZE_MIB keep]", argv[0]);
	if (argc == 4)
		SIZE = strtoul(argv[2], NULL, 0) * MIB;
	fd = open(argv[1], O_WRONLY | O_CREAT | O_EXCL, 0600);
	if (fd >= 0) {
		memset(buf, 0x5a, sizeof(buf));
		for (i = 0; i < SIZE / MIB; i++)
			if (write(fd, buf, MIB) != (ssize_t)MIB)
				err(1, "write");
		if (fsync(fd))
			err(1, "fsync");
		close(fd);
	} else if (argc != 4) {
		err(1, "create");
	}

	setvbuf(stdout, NULL, _IOLBF, 0);
	run(argv[1], "random", 0, 1);
	run(argv[1], "stride 2053 pages", 2053, 1);
	run(argv[1], "random 2-page recs", 0, 2);
	run(argv[1], "random 4-page recs", 0, 4);
	if (argc != 4)
		unlink(argv[1]);
	return 0;
}

