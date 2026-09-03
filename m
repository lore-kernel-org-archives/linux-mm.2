Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF92C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857826B0092; Thu,  3 Sep 2026 07:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F616B0096; Thu,  3 Sep 2026 07:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E0F6B0099; Thu,  3 Sep 2026 07:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DABB6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:39:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF0EA43FB
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:39:51 +0000 (UTC)
X-FDA: 85172256582.14.B49F89C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5F2B160003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:39:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="m/AgxERz";
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788435590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uVCTy4xLzdMuJQFYC3IqXAJAavi6+fdD1TUYH/Z+IEE=;
	b=cmv6M1M/mmPNebPHK2EDAru1XOkjqlEqlfl+unHhJWbdDa0AG4B1Clr+qV8cNGq4iba/v8
	yvXMFQTjLUiyJLDIqx6KUbTgw4zF8+uEyga7OK1TOIFITG/YxHjPSEOqQSPr93WomPT9dh
	+4entTwXMyN+fCFfxqlsisSTATNNXDU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788435590;
	b=kTe0lvpHLiyRZj5CBtOMfIkeETNVdXlXzKGqlRnmydCt/Vtt6TSbQn4CU9JH0WaDtdGh03
	JTJww1AoLI7iTmp+ED1788B35ifbHy9Bor1cYUMqIraOqlkmPJNxtlEPAh3fhzZaQr+p4D
	W5RHUeh7j5kNZrsMvOoYfWE9PWRHvhE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="m/AgxERz";
	spf=pass (imf08.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 013681596;
	Thu,  3 Sep 2026 04:39:45 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3287D3F7D8;
	Thu,  3 Sep 2026 04:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788435588; bh=UT7qnUAwfdCLtiIsF+1GlDoXzT4DQEmYGGQwGd1qW5o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m/AgxERz0hQ52wjckwnuY7V8PjKsj/GwclXyeJlUPcoQqI3AT83BM0pFrOVgxlTjB
	 FuvUGjI3KQugJ/Df3bb5VdOs2DqpqPJoUDZESzx0dYUGRl5J+8r7im83dx2jcFGDtd
	 6UP+3+N3gXyttGYiFhslIK5po5Z5E6iyB09LF1KI=
Date: Thu, 3 Sep 2026 12:39:43 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org
Subject: Re: [PATCH] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
Message-ID: <aplcf7sDnfKQTYo0@e129823.arm.com>
References: <20260902175611.1241118-1-yeoreum.yun@arm.com>
 <apk1WVEDYtQhRxWR@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apk1WVEDYtQhRxWR@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D5F2B160003
X-Stat-Signature: kyzxtt67rug1fjw5aqpi3dubzie635x6
X-HE-Tag: 1788435589-136617
X-HE-Meta: U2FsdGVkX18gDpYXTr2adgUh8m+M+7mE+AQOAPh9lcCE0kHVSm2vFXxTOfMdZPZnh+4u9yQdNILcim6T/yFPPW9Yv3mwblRC6dBE7vfOupU+5+zq24APx1mCTj784Uctf9qQzU9MeJMkjYJ5WDyx2rDP+CelN4sEcLwOBK+5nNOfOAS3m7cQVfJf7ao1DQpix2jiO1l4zLreOuPKkR2sIZn9mih+u+ZGjZ90r4IQrZoRptQe7N0l0HXLbknUiKgetzO9xaxLMWiyVpeBsu1pxWt7qKoBoAOGfibMgvs+qu17bYHwsSo4up7OStOC6MnNygkUWa5Dez4DOUfI4EXrVPb9TJNebTKG6iM4yHNX75hLQ3eMCqXol04RAtAVEd4G6oq/a7cE03dld634BAv+guUrwgpFhbApRr4zJlwpax9Xudo0NXTlDWsivZlve+zdnDO2R63RNMTarmsvgwEmlLjNklEYVnTKsLKtFspHi720BvjdrqcKoqewWaqCAdK27qP4oINrNXnAtyPIunr9cvB7eSuGi/4ktVxd7lD8ypXDQFU3DlL/N64Voww2h+VU+rif1hizNYjGQzWDWXAuKZExFGO6fET3pz30yRP1wvkT6ZubC+fib0MaE/qUCy5q0f/G3sJrazarfZy6gxiuBQdsFl4QkvlmUZF4oohpxfE09iWuS5WK63juNPzb2nyhjGV5lFpvf1ByjbvnIYklfRG1uqm4UjxOFoh8KRYcjGcPxLSLk7KxbJqALJsc/+BBzxXzbUzjgfDpgPuskRJM4JQi6FJ2vQ5DPisrvzgQSKh9ejwQI7vDYE4EEKW0e8vnFqwSpKZtow+nJBKaHf/FOjKe0YC/BSO3X+z756CMEoJcI9VFThMfjnNqWL3pYahhMeRicDXPUrsg+rbp1hlzZL1qTS8xMOH/U4PUXxFbZjY15e1VQQ3e+lCb1xbgiLVMHQNcTkYHmY8LWFXkAPo
 7kMVFQ5l
 vIJPKvEkw2aECpoD4oJi1EMZ71+P/64dKufPjsr/Uh+9w+kQxR6LtsgnZLpA4OvlqyrVEg7SZNcuKDjeU9eNySh6t5U0XWENgZZmQlMGGuCQqhjIUOSJp9f/z8MO601/gd/mAAIMr+WMbUGDRhVarkaFSoc5tm2ZZbXxXHvM3DxJpD+hJOk4TRU3uOsEcY+2B4VSwvzZtE1ro+AU2hsb5aDh3wBzwJatOMj/O/GcV46G2VJ+8DT+f8mp2CScN1SkDXzlN2Uuq07644ixi2u01tHtaRCUwRh20rNYOfl5VRWaVNQbkV3p3n3zVmPLuB31TX83Gny3v3Yad0e7g63zxp0MiZWLrVOqL37XTs0HHuU1d1+zD/N0UBl0jNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed, Sep 02, 2026 at 06:56:11PM +0100, Yeoreum Yun wrote:
> > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > When this macro is used in some test, test result would be strange in
> > the system where PAGE_SIZE is more than 4KB.
> >
> > Here is example with transhuge-stress test with 16KB PAGE_SIZE:
> >
> >   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> >     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> >     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     ...
> >   ok 1 Completed
> >
> > Remove the HPAGE_SIZE and HPAGE_SHIFT macro. and introduce hpshift()
> > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-exist
> > helper, read_pmd_pagesize().
> >
> > Also, do KSM_MERGE_TIME_HUGE_PAGES test with size of 512 MiB which
> > is the LCD pmd_size among 4KB, 16KB and 64KB page_size.
> 
> Probably worth spelling out Least Common Denominator for those who might
> mistaken this for a kind of display panel :P

Bad typo :( LCM (least common multiple) :(

> 
> I also wonder if it's worth pulling that out as a separate patch in a series for
> better bisectability?

Okay. I'll separate it.

> 
> >
> > After this patch, output of transhuge-stress:
> >
> >   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
> >     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
> >     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
> >     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
> >     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
> >     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
> >     ...
> >   ok 1 Completed
> >
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> Firstly THANK YOU for doing this :) hugely appreciated.
> 
> Also thank you again for the birthday cakes ;)
> 
> And apologies for the nitpicks :P

No worries! Thanks for your comment ;)

> 
> > ---
> >  tools/testing/selftests/mm/guard-regions.c    | 12 +++++--
> >  tools/testing/selftests/mm/ksm_tests.c        | 17 ++++++----
> >  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
> >  tools/testing/selftests/mm/transhuge-stress.c | 22 +++++++------
> >  tools/testing/selftests/mm/vm_util.c          | 32 ++++++++++++++++---
> >  tools/testing/selftests/mm/vm_util.h          |  9 ++----
> >  6 files changed, 66 insertions(+), 30 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index 5c8ec3ca75d7..d370592b291f 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -2195,14 +2195,22 @@ TEST_F(guard_regions, pagemap_scan)
> >  TEST_F(guard_regions, collapse)
> >  {
> >  	const unsigned long page_size = self->page_size;
> > -	const unsigned long size = 2 * HPAGE_SIZE;
> > -	const unsigned long num_pages = size / page_size;
> > +	uint64_t hpage_size;
> > +	unsigned long size;
> > +	unsigned long num_pages;
> >  	char *ptr;
> >  	int i;
> >
> >  	if (!thp_available())
> >  		SKIP(return, "Transparent Hugepages not available\n");
> >
> > +	hpage_size = read_pmd_pagesize();
> > +	if (!hpage_size)
> > +		ksft_exit_fail_msg("reading hpage_size failed\n");
> > +
> > +	size = 2 * hpage_size;
> > +	num_pages = size / page_size;
> > +
> >  	/* Need file to be correct size for tests for non-anon. */
> >  	if (variant->backing != ANON_BACKED)
> >  		ASSERT_EQ(ftruncate(self->fd, size), 0);
> > diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> > index 5fd7792a0d47..278e77055007 100644
> > --- a/tools/testing/selftests/mm/ksm_tests.c
> > +++ b/tools/testing/selftests/mm/ksm_tests.c
> > @@ -521,6 +521,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
> >  	struct timespec start_time, end_time;
> >  	unsigned long scan_time_ns;
> >  	int pagemap_fd, n_normal_pages, n_huge_pages;
> > +	uint64_t hpage_size = read_pmd_pagesize();
> 
> NIT: can this be const?

Acked.

> 
> > +
> > +	if (!hpage_size) {
> > +		ksft_exit_fail_msg("reading hpage_size failed\n");
> > +	}
> 
> NIT: can drop the {}

Acked.
> 
> >
> >  	if (!thp_is_enabled()) {
> >  		ksft_print_msg("Transparent Hugepages not available\n");
> > @@ -530,10 +535,10 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
> >  	map_size *= MB;
> >  	size_t len = map_size;
> >
> > -	len -= len % HPAGE_SIZE;
> > -	map_ptr_orig = mmap(NULL, len + HPAGE_SIZE, PROT_READ | PROT_WRITE,
> > +	len -= len % hpage_size;
> > +	map_ptr_orig = mmap(NULL, len + hpage_size, PROT_READ | PROT_WRITE,
> >  			MAP_ANONYMOUS | MAP_NORESERVE | MAP_PRIVATE, -1, 0);
> > -	map_ptr = map_ptr_orig + HPAGE_SIZE - (uintptr_t)map_ptr_orig % HPAGE_SIZE;
> > +	map_ptr = map_ptr_orig + hpage_size - (uintptr_t)map_ptr_orig % hpage_size;
> >
> >  	if (map_ptr_orig == MAP_FAILED)
> >  		err(2, "initial mmap");
> > @@ -547,7 +552,7 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
> >
> >  	n_normal_pages = 0;
> >  	n_huge_pages = 0;
> > -	for (void *p = map_ptr; p < map_ptr + len; p += HPAGE_SIZE) {
> > +	for (void *p = map_ptr; p < map_ptr + len; p += hpage_size) {
> >  		if (allocate_transhuge(p, pagemap_fd) < 0)
> >  			n_normal_pages++;
> >  		else
> > @@ -578,11 +583,11 @@ static int ksm_merge_hugepages_time(int merge_type, int mapping, int prot,
> >  	ksft_print_msg("Average speed:  %.3f MiB/s\n", (map_size / MB) /
> >  					       ((double)scan_time_ns / NSEC_PER_SEC));
> >
> > -	munmap(map_ptr_orig, len + HPAGE_SIZE);
> > +	munmap(map_ptr_orig, len + hpage_size);
> >  	return KSFT_PASS;
> >
> >  err_out:
> > -	munmap(map_ptr_orig, len + HPAGE_SIZE);
> > +	munmap(map_ptr_orig, len + hpage_size);
> >  	return KSFT_FAIL;
> >  }
> >
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> > index d09f9f6a384e..24aa1de27c25 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -360,8 +360,8 @@ fi
> >  CATEGORY="memfd_secret" run_test ./memfd_secret
> >  fi
> >
> > -# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
> > -CATEGORY="ksm" run_test ./ksm_tests -H -s 100
> > +# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
> > +CATEGORY="ksm" run_test ./ksm_tests -H -s 512
> 
> See above re: splitting out.

Okay. I'll split!

> 
> >  # KSM KSM_MERGE_TIME test with size of 100
> >  CATEGORY="ksm" run_test ./ksm_tests -P -s 100
> >  # KSM MADV_MERGEABLE test with 10 identical pages
> > diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
> > index 8eb0c5630e7e..66ae94afaf8d 100644
> > --- a/tools/testing/selftests/mm/transhuge-stress.c
> > +++ b/tools/testing/selftests/mm/transhuge-stress.c
> > @@ -35,6 +35,8 @@ int main(int argc, char **argv)
> >  	size_t map_len;
> >  	int pagemap_fd;
> >  	int duration = 0;
> > +	uint64_t hpage_size = read_pmd_pagesize();
> > +	uint64_t hpage_shift = hpshift();
> 
> NIT: could be consts?

Okay.

> 
> >
> >  	ksft_print_header();
> >
> > @@ -70,23 +72,23 @@ int main(int argc, char **argv)
> >  	}
> >
> >  	warnx("allocate %zd transhuge pages, using %zd MiB virtual memory"
> > -	      " and %zd MiB of ram", len >> HPAGE_SHIFT, len >> 20,
> > -	      ram >> (20 + HPAGE_SHIFT - pshift() - 1));
> > +	      " and %zd MiB of ram", len >> hpage_shift, len >> 20,
> > +	      ram >> (20 + hpage_shift - pshift() - 1));
> >
> >  	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> >  	if (pagemap_fd < 0)
> >  		ksft_exit_fail_msg("open pagemap\n");
> >
> > -	len -= len % HPAGE_SIZE;
> > -	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
> > +	len -= len % hpage_size;
> > +	ptr = mmap(NULL, len + hpage_size, PROT_RW, mmap_flags, backing_fd, 0);
> >  	if (ptr == MAP_FAILED)
> >  		ksft_exit_fail_msg("initial mmap");
> > -	ptr += HPAGE_SIZE - (uintptr_t)ptr % HPAGE_SIZE;
> > +	ptr += hpage_size - (uintptr_t)ptr % hpage_size;
> >
> >  	if (madvise(ptr, len, MADV_HUGEPAGE))
> >  		ksft_exit_fail_msg("MADV_HUGEPAGE");
> >
> > -	map_len = ram >> (HPAGE_SHIFT - 1);
> > +	map_len = ram >> (hpage_shift - 1);
> >  	map = malloc(map_len);
> >  	if (!map)
> >  		ksft_exit_fail_msg("map malloc\n");
> > @@ -99,7 +101,7 @@ int main(int argc, char **argv)
> >  		memset(map, 0, map_len);
> >
> >  		clock_gettime(CLOCK_MONOTONIC, &a);
> > -		for (p = ptr; p < ptr + len; p += HPAGE_SIZE) {
> > +		for (p = ptr; p < ptr + len; p += hpage_size) {
> >  			int64_t pfn;
> >
> >  			pfn = allocate_transhuge(p, pagemap_fd);
> > @@ -107,7 +109,7 @@ int main(int argc, char **argv)
> >  			if (pfn < 0) {
> >  				nr_failed++;
> >  			} else {
> > -				size_t idx = pfn >> (HPAGE_SHIFT - pshift());
> > +				size_t idx = pfn >> (hpage_shift - pshift());
> >
> >  				nr_succeed++;
> >  				if (idx >= map_len) {
> > @@ -123,7 +125,7 @@ int main(int argc, char **argv)
> >  			}
> >
> >  			/* split transhuge page, keep last page */
> > -			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
> > +			if (madvise(p, hpage_size - psize(), MADV_DONTNEED))
> >  				ksft_exit_fail_msg("MADV_DONTNEED");
> >  		}
> >  		clock_gettime(CLOCK_MONOTONIC, &b);
> > @@ -131,7 +133,7 @@ int main(int argc, char **argv)
> >
> >  		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
> >  			       "%4d succeed, %4d failed, %4d different pages\n",
> > -			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
> > +			       s, s * 1000 / (len >> hpage_shift), len / s / (1 << 20),
> >  			       nr_succeed, nr_failed, nr_pages);
> >
> >  		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..4332f8fb2104 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -21,6 +21,8 @@
> >
> >  unsigned int __page_size;
> >  unsigned int __page_shift;
> > +uint64_t __hpage_size;
> > +uint64_t __hpage_shift;
> >
> >  uint64_t pagemap_get_entry(int fd, char *start)
> >  {
> > @@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
> >  	char buf[20];
> >  	ssize_t num_read;
> >
> > +	if (__hpage_size)
> > +		return __hpage_size;
> > +
> >  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> >  	if (fd == -1)
> >  		return 0;
> > @@ -173,7 +178,24 @@ uint64_t read_pmd_pagesize(void)
> >  	buf[num_read] = '\0';
> >  	close(fd);
> >
> > -	return strtoul(buf, NULL, 10);
> > +	__hpage_size = strtoul(buf, NULL, 10);
> > +
> > +	return __hpage_size;
> > +}
> > +
> > +uint64_t hpshift(void)
> > +{
> > +	if (!__hpage_shift) {
> > +		if (!__hpage_size) {
> > +			__hpage_size = read_pmd_pagesize();
> > +			if (!__hpage_size)
> > +				ksft_exit_fail_msg("reading __hpage_size failed\n");
> > +		}
> 
> This nesting is a bit horrifying :P
> 
> Maybe:
> 
> 	if (__hpage_shift && __hpage_size)
> 		return;
> 
> 	if (!__hpage_size) {
> 		...
> 	}
> 
> 	if (!__hpage_shift) {
> 		...
> 	}
> 
> ?

I see. I'll untie the nesting.

> 
> > +
> > +		__hpage_shift = (ffsl(__hpage_size) - 1);
> > +	}
> > +
> > +	return __hpage_shift;
> >  }
> >
> >  unsigned long rss_anon(void)
> > @@ -452,14 +474,16 @@ bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size
> >  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> >  {
> >  	uint64_t ent[2];
> > +	uint64_t hpage_size = read_pmd_pagesize();
> > +	uint64_t hpage_shift = hpshift();
> 
> NIT: could be const?

Okay ;)

> 
> >
> >  	/* drop pmd */
> > -	if (mmap(ptr, HPAGE_SIZE, PROT_READ | PROT_WRITE,
> > +	if (mmap(ptr, hpage_size, PROT_READ | PROT_WRITE,
> >  		 MAP_FIXED | MAP_ANONYMOUS |
> >  		 MAP_NORESERVE | MAP_PRIVATE, -1, 0) != ptr)
> >  		ksft_exit_fail_msg("mmap transhuge\n");
> >
> > -	if (madvise(ptr, HPAGE_SIZE, MADV_HUGEPAGE))
> > +	if (madvise(ptr, hpage_size, MADV_HUGEPAGE))
> >  		ksft_exit_fail_msg("MADV_HUGEPAGE\n");
> >
> >  	/* allocate transparent huge page */
> > @@ -471,7 +495,7 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> >
> >  	if (PAGEMAP_PRESENT(ent[0]) && PAGEMAP_PRESENT(ent[1]) &&
> >  	    PAGEMAP_PFN(ent[0]) + 1 == PAGEMAP_PFN(ent[1]) &&
> > -	    !(PAGEMAP_PFN(ent[0]) & ((1 << (HPAGE_SHIFT - pshift())) - 1)))
> > +	    !(PAGEMAP_PFN(ent[0]) & ((1 << (hpage_shift - pshift())) - 1)))
> >  		return PAGEMAP_PFN(ent[0]);
> >
> >  	return -1;
> > diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > index 9a49af88702e..20a6334605c7 100644
> > --- a/tools/testing/selftests/mm/vm_util.h
> > +++ b/tools/testing/selftests/mm/vm_util.h
> > @@ -31,6 +31,8 @@
> >
> >  extern unsigned int __page_size;
> >  extern unsigned int __page_shift;
> > +extern uint64_t __hpage_size;
> > +extern uint64_t __hpage_shift;
> >
> >  /*
> >   * Represents an open fd and PROCMAP_QUERY state for binary (via ioctl)
> > @@ -89,6 +91,7 @@ unsigned long pagemap_get_pfn(int fd, char *start);
> >  void clear_softdirty(void);
> >  bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
> >  uint64_t read_pmd_pagesize(void);
> > +uint64_t hpshift(void);
> >  unsigned long rss_anon(void);
> >  bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
> >  bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
> > @@ -157,12 +160,6 @@ int ksm_stop(void);
> >  int get_hardware_corrupted_size(unsigned long *val);
> >  int unpoison_memory(unsigned long pfn);
> >
> > -/*
> > - * On ppc64 this will only work with radix 2M hugepage size
> > - */
> > -#define HPAGE_SHIFT 21
> > -#define HPAGE_SIZE (1 << HPAGE_SHIFT)
> > -
> 
> Worth calling this change out in commit msg also?

It was spelled out as They're removed ;).

> 
> >  #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
> >  #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
> >
> > --
> > LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> >
> 
> --

Thanks!

-- 
Sincerely,
Yeoreum Yun

