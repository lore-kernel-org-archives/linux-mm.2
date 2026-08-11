Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13787C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7196B0098; Tue, 11 Aug 2026 12:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E036B0099; Tue, 11 Aug 2026 12:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC1F6B009B; Tue, 11 Aug 2026 12:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA5606B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:34:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D4E414011D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:34:00 +0000 (UTC)
X-FDA: 85089535440.08.9A05083
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BAB1D1C0012
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:33:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYdo2HBc;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466038;
	b=CKLBw2F0jvzU8J1uC2XxkZYHFnnsZUiTVaMz7d2c5aAAO9W1jB43ZEEDlmdujsfYTmy7mP
	MRx5Hfj0ulwSfn9Bus16LJzQkcyG02jODUKSLOoGCTgMrH/vukAzNzAGHzCqkhM0oteO/o
	ejLkKm90cPRauDX/65WAyIjcPhhW/Gw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYdo2HBc;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HDgErYQDmdr05DqedPNMQR+msppQCpKIH/GoZML93g=;
	b=38UzP9mxT8ybLsWT/kevSeKmO3Q16Q5roYNXvVuxAAk95sqHPp3ureVGeT1PwUAvCOB4q7
	os2qASqcVMdkaBaKlrafzBT5I9i91aJa9AAkGXzR+WLzXrFppumFwvBZobQZURj6TdiGuF
	ElbX/F7Oc/YA+ZJAp1pj2E1XY5D13R8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 585FF600AF;
	Tue, 11 Aug 2026 16:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240901F000E9;
	Tue, 11 Aug 2026 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466038;
	bh=2HDgErYQDmdr05DqedPNMQR+msppQCpKIH/GoZML93g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gYdo2HBczC71rASFezPtjO+KwmcjWDw4sGDUhLke9COwKepUTb3DmojGGbXYIJ6s+
	 2ioWm7RhJpC5XhsnkHFd1zHCa4TL5HtMLxnYq/aCY4/USAS6Iac0IOFoHSLIgKv3nN
	 37trmGeng2+O8oeQWpjOZxCDAlmTEWOdgstDbqV736QZMHDUwNweUzOkkmqeh1xafk
	 wC8maUuCCyHFNPOzOHPhTRdrM5KA7MT7hzfjoIV9Dn7mKXfnDMjn3KDrQrheG2h8wW
	 mdLZz5vlatLZZ/GE5D1RoAjqmYP1OA5JdXTGuSKiSdgKGZqYxKYspvLF49nHPA8ZH5
	 3KAJfI91qoeXA==
Date: Tue, 11 Aug 2026 17:33:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: add stale walk->action race test
Message-ID: <antM5eWXxbKbdiKy@gremlin>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-3-imv4bel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811161949.3879321-3-imv4bel@gmail.com>
X-Rspamd-Queue-Id: BAB1D1C0012
X-Rspam-User: 
X-Stat-Signature: jji6de5dpjk345e8putoukk7rseee6t5
X-Rspamd-Server: rspam06
X-HE-Tag: 1786466038-236713
X-HE-Meta: U2FsdGVkX18Asdmiq5t+L5kjzFMdd79N4+xRVWCDT3CFu3XANe3amCLkWMtq9ZQ+DG2vwF6fEjlcV4MgESwtFRdLQL3i/qoE1uhfVZOKs4YUV+kBs5i421PEoSsV4OUkI4HP8aVHLr1D5rs6SqvOSFyTVxFW4zq/3o2H4TqvsY5mdjgCdAqokSCQyD1QwNxc5R32pLB5WB6yUlc+rJ4wlOF0Vn9d567siLp4OihgPY0Tuy/B/2XapFiCjIbokjhJEgT3bOf1oENx1Yzt01qcgCN961j3E2jMu03AcmsHvu26VIHrUX58p5d0kP7ZWuSj+b7HDsj7sGs00VDZ02/1YTvEb9IG3re3AddkX/rPya3F3z/EclSq68ZcoJyjHD1f4GoKpIYfMoSK1by19CwdJWYYj1UJKzXDhIi4CK6/xRboz63f3LgYZtkQ1Z07ClGsQl3TbFNH0a1Tk5jqqvqGxT/1OJakIxSFiIAaLKV7kWBRVHLxsUC2iyha5oLaiTbsDNnovwBSTcvGkvJFt0tOOapvvkkTYSanftSt+nXOikh4eR7rApqdq43zaHTECXfCMFcfKFxqJnVfDmlRActUQ6hP8UlLiftNczj3ciBzg4NW1CTvD9jQdBWWjiXG4jH8sPlBT0ZjzhqMpJyWV1UI9iazwNKoXjQPin8T/id2AjNhmced+H2isEIbLtZJGdFfjEbnaAtJbBluhZzQneWYoZPO8noMmQUid92WtU+ilIz1/TObiO55n3V47/5cVzcriRG5C3R//8GseJYrZNU53iHk31yt1kXwDY7JlRjGiKlEiPc1Zb8CN47AjzGmqsTJ8GwEEUkrkyC6Z0yIqMLjnwaCu/DEymk2LDn2EAsCr323xNa3cDPGYCBNmpByBqZWHODVCfp5aPo8BYnWaicLDZUDMypJ4fOekNZv4fpQWu28aiiTJQC2ClpOi4C6aRXLoIeoYYXPbQFvmkdX4JQ
 t6D/A7ZU
 SQZD9HhLbYCnMfJUPur7tveru2avnlwCrAAdYexEV4cuWyBOo/rFm3whpsooaFo5FIHjo7Y9/kieeTAaO4UFkn9yPHiFz2c+eB3VJ4k47xNBqFeZOijpbZRQmFEmXXLv1Qt3GrMLEjCymGqVyl8WfNt9qHOUqRegX/6xVeHAZGf/giHYpBCCuGg+GSCcwcvV0RmgUbyWJSUg99wvN/h3pT59DV/IUF+7kM7Gcjefir2JGYvYn85vkYHqGx8L3tyXr0/m5q2uZ/unTPh3GixVSM0l7HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:18:58AM +0900, Hyunwoo Kim wrote:
> The added pagewalk_race_test maps two PMDs and faults in 2MB of the first
> one.  A second thread then faults in the second PMD and drops it again with
> MADV_DONTNEED in a loop, while the main thread reads Rss for the mapping
> from /proc/self/smaps.
>
> Clearing the second PMD while smaps_pte_range() runs leaves walk->action
> erroneously set to ACTION_AGAIN, which causes the PUD walk to be retried,
> so the first PMD is counted twice and Rss comes out twice as large as what
> was faulted in.
>
> mincore() is the caller named in the fix, but the second walk writes past
> the length mincore() copies back, so it cannot be seen from userspace
> there.  smaps reports what the callbacks counted, so the duplicate shows up
> in Rss.
>
> A failure can only come from the kernel counting the same page twice, so
> missing the race is harmless.  On an unfixed kernel the test fails after a
> few hundred reads at most and takes about half a second.
>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  tools/testing/selftests/mm/.gitignore         |   1 +
>  tools/testing/selftests/mm/Makefile           |   2 +
>  tools/testing/selftests/mm/ksft_pagewalk.sh   |   4 +
>  .../testing/selftests/mm/pagewalk_race_test.c | 138 ++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  tools/testing/selftests/mm/vm_util.h          |   1 +
>  6 files changed, 148 insertions(+)
>  create mode 100755 tools/testing/selftests/mm/ksft_pagewalk.sh
>  create mode 100644 tools/testing/selftests/mm/pagewalk_race_test.c
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index 9ccd9e1447e66b..92f981f97740fd 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -66,3 +66,4 @@ merge
>  prctl_thp_disable
>  rmap
>  folio_split_race_test
> +pagewalk_race_test
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index e6df968f0971c8..cde9b22f121d4b 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -105,6 +105,7 @@ TEST_GEN_FILES += guard-regions
>  TEST_GEN_FILES += merge
>  TEST_GEN_FILES += rmap
>  TEST_GEN_FILES += folio_split_race_test
> +TEST_GEN_FILES += pagewalk_race_test
>
>  ifneq ($(ARCH),arm64)
>  TEST_GEN_FILES += soft-dirty
> @@ -163,6 +164,7 @@ TEST_PROGS += ksft_mlock.sh
>  TEST_PROGS += ksft_mmap.sh
>  TEST_PROGS += ksft_mremap.sh
>  TEST_PROGS += ksft_pagemap.sh
> +TEST_PROGS += ksft_pagewalk.sh
>  TEST_PROGS += ksft_pfnmap.sh
>  TEST_PROGS += ksft_pkey.sh
>  TEST_PROGS += ksft_process_madv.sh
> diff --git a/tools/testing/selftests/mm/ksft_pagewalk.sh b/tools/testing/selftests/mm/ksft_pagewalk.sh
> new file mode 100755
> index 00000000000000..6f6c3ee1c13ef4
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pagewalk.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pagewalk
> diff --git a/tools/testing/selftests/mm/pagewalk_race_test.c b/tools/testing/selftests/mm/pagewalk_race_test.c
> new file mode 100644
> index 00000000000000..42fd6e75e821ed
> --- /dev/null
> +++ b/tools/testing/selftests/mm/pagewalk_race_test.c
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Regression test for a stale walk->action escaping walk_pmd_range() and
> + * making walk_pud_range() walk the same range twice.
> + *
> + * The mapping is two PMDs inside one PUD. PMD 0 is populated once and left
> + * alone, PMD 1 is faulted in and dropped again by a second thread. Clearing
> + * PMD 1 under smaps_pte_range() makes it raise ACTION_AGAIN, and since it is
> + * the last entry the stale value leaves walk_pmd_range(), so smaps accounts
> + * PMD 0 twice. A kernel that does not reclaim the emptied page table never
> + * clears PMD 1 and so never hits the race.
> + *
> + * A hit can only come from the kernel counting the same page twice, so the
> + * test cannot fail spuriously.
> + */
> +#define _GNU_SOURCE
> +
> +#include <pthread.h>
> +#include <stdatomic.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +
> +#include "vm_util.h"
> +#include "kselftest.h"
> +
> +#define NR_PMDS		2
> +#define NR_ROUNDS	20000

I did say please don't let this be slow :) if the test takes longer than say
200ms then just let it be less reliably repro maybe?

> +/* Cap on how much of PMD 0 to fault in, so that a large PMD stays cheap. */
> +#define POP_MAX		(2 * 1024 * 1024)
> +
> +static char *area;
> +static size_t pmd_size;
> +static atomic_int stop;
> +
> +static void *racer(void *arg)
> +{
> +	char *pmd1 = area + pmd_size;
> +
> +	while (atomic_load_explicit(&stop, memory_order_acquire) == 0) {
> +		/* madvise() below keeps the compiler from lifting this out. */

Err what? :) this seems crazy? You are using an madvise to prevent a compiler
optinisation how? :) isn't atomic_load_explicit() a compiler barrier anyway?

I think you can probably do this better... see FORCE_READ() for use of volatile
to achieve the same thing for a read.

But why would zapping a PMD achieve anything for the compiler? So confused

> +		*pmd1 = 1;
> +		madvise(pmd1, pmd_size, MADV_DONTNEED);
> +	}
> +	return NULL;
> +}
> +
> +static unsigned long smaps_rss_kb(void)
> +{
> +	char buf[1024];
> +	char *entry;
> +
> +	entry = __get_smap_entry(area, "Rss:", buf, sizeof(buf));
> +	if (!entry)
> +		ksft_exit_fail_msg("no Rss: entry for the test mapping\n");
> +
> +	return strtoul(entry, NULL, 10);
> +}
> +
> +int main(void)
> +{
> +	unsigned long max_rss_kb, rss_kb = 0;
> +	size_t size, pop_size, i;
> +	pthread_t thread;
> +	char *raw;
> +
> +	ksft_print_header();
> +
> +	pmd_size = read_pmd_pagesize();
> +	if (!pmd_size)
> +		ksft_exit_skip("Cannot determine PMD size\n");
> +
> +	if (sysconf(_SC_NPROCESSORS_ONLN) < 2)
> +		ksft_exit_skip("Need at least 2 CPUs to race\n");
> +
> +	size = NR_PMDS * pmd_size;
> +
> +	/*
> +	 * Align to the mapping size to stay inside one PUD, then trim the
> +	 * slack so that smaps has exactly one VMA to report.
> +	 */
> +	raw = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
> +		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);

Why MAP_NORESERVE?

> +	if (raw == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap failed\n");
> +
> +	area = (char *)(((unsigned long)raw + size - 1) & ~(size - 1));

This is horrible, break it out into a sensible helper. Magical bitwise stuff all
compressed into one is not something we want.

> +	if (area != raw)
> +		munmap(raw, area - raw);
> +	if (raw + 2 * size != area + size)
> +		munmap(area + size, raw + 2 * size - (area + size));

Again you're compressing things too much. Keep it simple.

> +
> +	/* A huge PMD never reaches pte_offset_map_lock(), so keep them out. */
> +	if (madvise(area, size, MADV_NOHUGEPAGE))
> +		ksft_exit_skip("MADV_NOHUGEPAGE failed\n");

No idea why you'd skip on this.

This is another reason why you should use the kselftest harness, ASSERT_EQ(...,
0) is much easier... and it has sensible skipping stuff too.

> +
> +	pop_size = pmd_size < POP_MAX ? pmd_size : POP_MAX;
> +	memset(area, 1, pop_size);
> +
> +	max_rss_kb = (pop_size >> 10) + 256;
> +
> +	/* Over the limit before racing means this is not our own mapping. */
> +	rss_kb = smaps_rss_kb();
> +	if (rss_kb > max_rss_kb)
> +		ksft_exit_fail_msg("Rss is %lu kB before racing, expected at most %lu kB\n",
> +				   rss_kb, max_rss_kb);
> +
> +	ksft_set_plan(1);
> +	ksft_print_msg("racing smaps against MADV_DONTNEED, %d rounds\n",
> +		       NR_ROUNDS);
> +
> +	if (pthread_create(&thread, NULL, racer, NULL))
> +		ksft_exit_fail_msg("pthread_create failed\n");
> +
> +	for (i = 0; i < NR_ROUNDS; i++) {
> +		rss_kb = smaps_rss_kb();
> +		if (rss_kb > max_rss_kb)
> +			break;
> +	}
> +
> +	atomic_store_explicit(&stop, 1, memory_order_release);
> +	pthread_join(thread, NULL);
> +
> +	if (i < NR_ROUNDS) {
> +		ksft_print_msg("walk ran twice over the same range\n");
> +		ksft_test_result_fail("Rss %lu kB exceeds %lu kB, round %zu\n",
> +				      rss_kb, max_rss_kb, i);
> +	} else {
> +		ksft_test_result_pass("Rss within %lu kB over %d rounds\n",
> +				      max_rss_kb, NR_ROUNDS);
> +	}
> +
> +	ksft_exit(i == NR_ROUNDS);
> +
> +	return 0;

Putting this all into one function is disgusting. It might be test code but
that's new excuse for being schloppy. Separate things out into functions please and....

> +}

...use the kselftest_harness, see guard_regions.c for an example of how it's
used.

I know it's just 1 test but it avoids all the stupid plan and manual
ksft_test_*() invocations and gets you ASSERT_*() etc.

> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 8c296dedf0474d..d90c6370814f7a 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -398,6 +398,8 @@ fi
>
>  CATEGORY="pagemap" run_test ./pagemap_ioctl
>
> +CATEGORY="pagewalk" run_test ./pagewalk_race_test
> +
>  CATEGORY="pfnmap" run_test ./pfnmap
>
>  # COW tests
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index ea8fc8fdf0eb0b..62292e2417d162 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -88,6 +88,7 @@ bool pagemap_is_populated(int fd, char *start);
>  unsigned long pagemap_get_pfn(int fd, char *start);
>  void clear_softdirty(void);
>  bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
> +char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len);
>  uint64_t read_pmd_pagesize(void);
>  unsigned long rss_anon(void);
>  bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
> --
> 2.43.0
>

--
Cheers, Lorenzo

