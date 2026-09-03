Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15ABC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 08:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E456B008A; Thu,  3 Sep 2026 04:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEEB6B008C; Thu,  3 Sep 2026 04:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04E26B0092; Thu,  3 Sep 2026 04:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B56EE6B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:56:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CF0214047B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:56:50 +0000 (UTC)
X-FDA: 85171845780.09.323AFF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99143C0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:56:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZJm0Nlp;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788425808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02Mp9uiZ68zR1+hJOqkaY67SDX1dZpFZicQbRabXLyE=;
	b=Bdmr/w9DDn8NrI0mEX63wwAxCSbOvudVQXkXpawPmXPFtO938ShyM29dWXzRgvHb02gHZi
	tLOLYS8U6ML3iff/NK6tUNMOw/ht3rV5Y9eH4s8B5VFhJHoMaXURb7A/Yyle6KJvYZbBRI
	H2FP+KslE5us2m19wudr/0mIKWjBcyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788425808;
	b=VnQjXgf4MtbXBLG1Q0fZT4JT5lLlaIYP8jm+F8m3srbu833WBDBe4SKy/+nEuc6bAwuUcZ
	ynbyTgKNU1nmLkmgiwtUqL5Po3ng/ThpdvH+/skA4EiQKzv7atiGJXckBbJKnIcEOYxHcV
	b6OO++HRHXqASs4f8OhKov6ZHaxA+xM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZJm0Nlp;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85B4441669;
	Thu,  3 Sep 2026 08:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB67B1F000E9;
	Thu,  3 Sep 2026 08:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788425807;
	bh=02Mp9uiZ68zR1+hJOqkaY67SDX1dZpFZicQbRabXLyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gZJm0NlpxGy1opG5c/XRYPPveJhKB2Lg52PUFQl0Ch1+jBlY0kPOwgZsUafGfx64b
	 omQplvqURVBceUvkV8g8uNXBazVtt0w7uRdGxFWWTp5AaYdRatk7IlC2evYL7g9n2e
	 1KRzwR9D6Nj9/SNLplHbhioGVjF0jWqAiQNsJd8t6EHvW2SsU4JMu/TtPqnefecaJM
	 yINtjvlgEC0GT3DzZvhMqoVopcj1hnktZhePnlUSdCI+MVfdr4at/JP6onOz4Gzpbs
	 CS62PkOczfZJko7S1UbGi87Dulpor0EEg886CfVkCoXNQzgVuS/YdJfV4SyxKLfp9v
	 zpvT3DR6abX/Q==
Date: Thu, 3 Sep 2026 09:56:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <apk1WVEDYtQhRxWR@gremlin>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902175611.1241118-1-yeoreum.yun@arm.com>
X-Stat-Signature: g5ybqo9xk36k1eqe36eyhnhisccnuyds
X-Rspamd-Queue-Id: 99143C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788425808-928653
X-HE-Meta: U2FsdGVkX18nCxDw3U+kjMselOgJfDmHBlt23N+rcZ1EFVCdK1/2iPyDP6Hmfgs+0hLZkrkw5ktzzSQp7B+VL3xy/WUoHIx7QhiTh47sqnOtwQdlSAZH1ZqBjlmtzEgPJF9nTDU+hL+/1ouhWtcgSXCaQ/cyGC2JiOuUDUHy/KuRING5KQZa/byySkfA0IRmaA0glZkva1iGmwRXmIAQeUxPVPTGgjY9nYywtzoiMpnH1D76EjcI6fxrFpSqzYx0vRshi5J0Q612Rh8hFAuVSuozWv5+Ad8eKMQOEZK93peaPv1dKnEmHs5Almo/5GFwb3IzqPu+yY0SV3C8S1/m+05QcC7oOdEirck4fYEdu456J5vqqFl+zrJsNVLZ5YrAsEVX4gU/6UuM9+904Fizgl8IsUlXaYNi3BsoX2zWS/05BRxqLOnYWaBR7fVLMD9/o0X5x9Wgf8TeIO4oUEWyP1bWpeF0vtybI7pyI3GwQkF8ZX8U2tbKTTXPBhL2Z/9EAnp0E1yvPvSi/oENlwAjfir7+T5RyRC57W9xlPTC3kx52k3irYqhmw5agRD5ZLLAjsSmCmmy8yMoLoNnejFwdj1G2eku9F0d19/r8ylFWYSFPBnnvdcVJd1AiRP0AtCfvgLOSz5f1IMz7WYLEoxx/OOVQq7dcCjsOXvtT596zKxMfcao9lJeVzGLS+7H+95emkhY30rPsgvybA2w4+/DjpH967fXspxt6xlHoYyK7T1IEqG2Cdw5Gg1+CkgrxFsOKVCDGzMQ0y1nmunkfYCO5bATqBQv528ne22YiD4+nFiATRFY1ErH8OEAB+oflrloNJx6cH7WPnI9Deny/F4Uk/1hxLsWroPi5CpdCHcvpv2w/HiBj8CeRZz6HE+kny7+QGQ3NBZac/sLcm0zpRlCxcuMBpYKroSJB8X6Z5cQDRP9RQFkNUoWciTB9r/SbJzNmDzGVI6+UoZcL8fsuAl
 CLHAQZBf
 er5Wy9o2mxPS1menVPX3POpJLpwPAuWbZMUlEvp7+Rk9ZCBrHduYXjWgXWQoVKF+gEVddJ4W6yCb/bUfPhw+cw2zFZaUQSV/NvZwLRz8GG0Pf0P93N78UXDO5tJrxHWtIHKRRFFKieBWccrHF0z+jqnV1Iyo97EguBnZc8mE+HMhQfr4Je4bVQ8a8ztIhJG6i3Mzss1OCY0aK8ho+DxX9nk51e7M5zEupXEbcOOySUQhx1QvxV1wjQL+I2miYsSZpei0nJ5UfgmuW6NF437GH//W7y1clG0eotebBOYv0/0HR0vTE4tBgSjMNd18P8KuI9pn/mjjnSIdZlSeZ09mteAJCEVB6aHE8T1XU9WnQc06GQgjObyepoQtzxf8HfnBMAPP4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 06:56:11PM +0100, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more than 4KB.
>
> Here is example with transhuge-stress test with 16KB PAGE_SIZE:
>
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     ...
>   ok 1 Completed
>
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> helper, read_pmd_pagesize().
>
> Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> is the LCD pmd_size among 4KB, 16KB and 64KB page_size.

Probably worth spelling out Least Common Denominator for those who might
mistaken this for a kind of display panel :P

I also wonder if it's worth pulling that out as a separate patch in a series for
better bisectability?

>
> After this patch, output of transhuge-stress:
>
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>     ...
>   ok 1 Completed
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Firstly THANK YOU for doing this :) hugely appreciated.

Also thank you again for the birthday cakes ;)

And apologies for the nitpicks :P

> ---
>  tools/testing/selftests/mm/guard-regions.c    | 12 +++++--
>  tools/testing/selftests/mm/ksm_tests.c        | 17 ++++++----
>  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
>  tools/testing/selftests/mm/transhuge-stress.c | 22 +++++++------
>  tools/testing/selftests/mm/vm_util.c          | 32 ++++++++++++++++---
>  tools/testing/selftests/mm/vm_util.h          |  9 ++----
>  6 files changed, 66 insertions(+), 30 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 5c8ec3ca75d7..d370592b291f 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2195,14 +2195,22 @@ TEST_F(guard_regions, pagemap_scan)
>  TEST_F(guard_regions, collapse)
>  {
>  	const unsigned long page_size = self->page_size;
> -	const unsigned long size = 2 * HPAGE_SIZE;
> -	const unsigned long num_pages = size / page_size;
> +	uint64_t hpage_size;
> +	unsigned long size;
> +	unsigned long num_pages;
>  	char *ptr;
>  	int i;
>
>  	if (!thp_available())
>  		SKIP(return, "Transparent Hugepages not available\n");
>
> +	hpage_size = read_pmd_pagesize();
> +	if (!hpage_size)
> +		ksft_exit_fail_msg("reading hpage_size failed\n");
> +
> +	size = 2 * hpage_size;
> +	num_pages = size / page_size;
> +
>  	/* Need file to be correct size for tests for non-anon. */
>  	if (variant->backing != ANON_BACKED)
>  		ASSERT_EQ(ftruncate(self->fd, size), 0);
> diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> index 5fd7792a0d47..278e77055007 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -521,6 +521,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
>  	struct timespec start_time, end_time;
>  	unsigned long scan_time_ns;
>  	int pagemap_fd, n_normal_pages, n_huge_pages;
> +	uint64_t hpage_size = read_pmd_pagesize();

NIT: can this be const?

> +
> +	if (!hpage_size) {
> +		ksft_exit_fail_msg("reading hpage_size failed\n");
> +	}

NIT: can drop the {}

>
>  	if (!thp_is_enabled()) {
>  		ksft_print_msg("Transparent Hugepages not available\n");
> @@ -530,10 +535,10 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
>  	map_size *= MB;
>  	size_t len = map_size;
>
> -	len -= len % HPAGE_SIZE;
> -	map_ptr_orig = mmap(NULL, len + HPAGE_SIZE, PROT_READ | PROT_WRITE,
> +	len -= len % hpage_size;
> +	map_ptr_orig = mmap(NULL, len + hpage_size, PROT_READ | PROT_WRITE,
>  			MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE, -1, 0);
> -	map_ptr = map_ptr_orig + HPAGE_SIZE - (uintptr_t)map_ptr_orig % HPAGE_SIZE;
> +	map_ptr = map_ptr_orig + hpage_size - (uintptr_t)map_ptr_orig % hpage_size;
>
>  	if (map_ptr_orig == MAP_FAILED)
>  		err(2, "initial mmap");
> @@ -547,7 +552,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
>
>  	n_normal_pages = 0;
>  	n_huge_pages = 0;
> -	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
> +	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
>  		if (allocate_transhuge(p, pagemap_fd) < 0)
>  			n_normal_pages++;
>  		else
> @@ -578,11 +583,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
>  	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
>  					       ((double)scan_time_ns / NSEC_PER_SEC));
>
> -	munmap(map_ptr_orig, len + HPAGE_SIZE);
> +	munmap(map_ptr_orig, len + hpage_size);
>  	return KSFT_PASS;
>
>  err_out:
> -	munmap(map_ptr_orig, len + HPAGE_SIZE);
> +	munmap(map_ptr_orig, len + hpage_size);
>  	return KSFT_FAIL;
>  }
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384e..24aa1de27c25 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -360,8 +360,8 @@ fi
>  CATEGORY="memfd_secret" run_test ./memfd_secret
>  fi
>
> -# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
> -CATEGORY="ksm" run_test ./ksm_tests -H -s 100
> +# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
> +CATEGORY="ksm" run_test ./ksm_tests -H -s 512

See above re: splitting out.

>  # KSM KSM_MERGE_TIME test with size of 100
>  CATEGORY="ksm" run_test ./ksm_tests -P -s 100
>  # KSM MADV_MERGEABLE test with 10 identical pages
> diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> index 8eb0c5630e7e..66ae94afaf8d 100644
> --- a/tools/testing/selftests/mm/transhuge-stress.c
> +++ b/tools/testing/selftests/mm/transhuge-stress.c
> @@ -35,6 +35,8 @@ int main(int argc, char **argv)
>  	size_t map_len;
>  	int pagemap_fd;
>  	int duration = 0;
> +	uint64_t hpage_size = read_pmd_pagesize();
> +	uint64_t hpage_shift = hpshift();

NIT: could be consts?

>
>  	ksft_print_header();
>
> @@ -70,23 +72,23 @@ int main(int argc, char **argv)
>  	}
>
>  	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
> -	      " and %zd MiB of ram", len >> HPAGE_SHIFT, len >> 20,
> -	      ram >> (20 + HPAGE_SHIFT - pshift() - 1));
> +	      " and %zd MiB of ram", len >> hpage_shift, len >> 20,
> +	      ram >> (20 + hpage_shift - pshift() - 1));
>
>  	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>  	if (pagemap_fd < 0)
>  		ksft_exit_fail_msg("open pagemap\n");
>
> -	len -= len % HPAGE_SIZE;
> -	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
> +	len -= len % hpage_size;
> +	ptr = mmap(NULL, len + hpage_size, PROT_RW, mmap_flags, backing_fd, 0);
>  	if (ptr == MAP_FAILED)
>  		ksft_exit_fail_msg("initial mmap");
> -	ptr += HPAGE_SIZE - (uintptr_t)ptr % HPAGE_SIZE;
> +	ptr += hpage_size - (uintptr_t)ptr % hpage_size;
>
>  	if (madvise(ptr, len, MADV_HUGEPAGE))
>  		ksft_exit_fail_msg("MADV_HUGEPAGE");
>
> -	map_len = ram >> (HPAGE_SHIFT - 1);
> +	map_len = ram >> (hpage_shift - 1);
>  	map = malloc(map_len);
>  	if (!map)
>  		ksft_exit_fail_msg("map malloc\n");
> @@ -99,7 +101,7 @@ int main(int argc, char **argv)
>  		memset(map, 0, map_len);
>
>  		clock_gettime(CLOCK_MONOTONIC, &a);
> -		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
> +		for (p = ptr; p < ptr + len; p += hpage_size) {
>  			int64_t pfn;
>
>  			pfn = allocate_transhuge(p, pagemap_fd);
> @@ -107,7 +109,7 @@ int main(int argc, char **argv)
>  			if (pfn < 0) {
>  				nr_failed++;
>  			} else {
> -				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
> +				size_t idx = pfn >> (hpage_shift - pshift());
>
>  				nr_succeed++;
>  				if (idx >= map_len) {
> @@ -123,7 +125,7 @@ int main(int argc, char **argv)
>  			}
>
>  			/* split transhuge page, keep last page */
> -			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
> +			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
>  				ksft_exit_fail_msg("MADV_DONTNEED");
>  		}
>  		clock_gettime(CLOCK_MONOTONIC, &b);
> @@ -131,7 +133,7 @@ int main(int argc, char **argv)
>
>  		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
>  			       "%4d succeed, %4d failed, %4d different pages\n",
> -			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
> +			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
>  			       nr_succeed, nr_failed, nr_pages);
>
>  		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 4821a3563036..4332f8fb2104 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -21,6 +21,8 @@
>
>  unsigned int __page_size;
>  unsigned int __page_shift;
> +uint64_t __hpage_size;
> +uint64_t __hpage_shift;
>
>  uint64_t pagemap_get_entry(int fd, char *start)
>  {
> @@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
>  	char buf[20];
>  	ssize_t num_read;
>
> +	if (__hpage_size)
> +		return __hpage_size;
> +
>  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
>  	if (fd == -1)
>  		return 0;
> @@ -173,7 +178,24 @@ uint64_t read_pmd_pagesize(void)
>  	buf[num_read] = '\0';
>  	close(fd);
>
> -	return strtoul(buf, NULL, 10);
> +	__hpage_size = strtoul(buf, NULL, 10);
> +
> +	return __hpage_size;
> +}
> +
> +uint64_t hpshift(void)
> +{
> +	if (!__hpage_shift) {
> +		if (!__hpage_size) {
> +			__hpage_size = read_pmd_pagesize();
> +			if (!__hpage_size)
> +				ksft_exit_fail_msg("reading __hpage_size failed\n");
> +		}

This nesting is a bit horrifying :P

Maybe:

	if (__hpage_shift && __hpage_size)
		return;

	if (!__hpage_size) {
		...
	}

	if (!__hpage_shift) {
		...
	}

?

> +
> +		__hpage_shift = (ffsl(__hpage_size) - 1);
> +	}
> +
> +	return __hpage_shift;
>  }
>
>  unsigned long rss_anon(void)
> @@ -452,14 +474,16 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
>  {
>  	uint64_t ent[2];
> +	uint64_t hpage_size = read_pmd_pagesize();
> +	uint64_t hpage_shift = hpshift();

NIT: could be const?

>
>  	/* drop pmd */
> -	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
> +	if (mmap(ptr, hpage_size, PROT_READ | PROT_WRITE,
>  		 MAP_FIXED | MAP_ANONYMOUS |
>  		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
>  		ksft_exit_fail_msg("mmap transhuge\n");
>
> -	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
> +	if (madvise(ptr, hpage_size, MADV_HUGEPAGE))
>  		ksft_exit_fail_msg("MADV_HUGEPAGE\n");
>
>  	/* allocate transparent huge page */
> @@ -471,7 +495,7 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
>
>  	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
>  	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
> -	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
> +	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
>  		return PAGEMAP_PFN(ent[0]);
>
>  	return -1;
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 9a49af88702e..20a6334605c7 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -31,6 +31,8 @@
>
>  extern unsigned int __page_size;
>  extern unsigned int __page_shift;
> +extern uint64_t __hpage_size;
> +extern uint64_t __hpage_shift;
>
>  /*
>   * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
> @@ -89,6 +91,7 @@ unsigned long pagemap_get_pfn(int fd, char *start);
>  void clear_softdirty(void);
>  bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
>  uint64_t read_pmd_pagesize(void);
> +uint64_t hpshift(void);
>  unsigned long rss_anon(void);
>  bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>  bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
> @@ -157,12 +160,6 @@ int ksm_stop(void);
>  int get_hardware_corrupted_size(unsigned long *val);
>  int unpoison_memory(unsigned long pfn);
>
> -/*
> - * On ppc64 this will only work with radix 2M hugepage size
> - */
> -#define HPAGE_SHIFT 21
> -#define HPAGE_SIZE (1 << HPAGE_SHIFT)
> -

Worth calling this change out in commit msg also?

>  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
>  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
>
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Cheers, Lorenzo

