Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50096C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 10:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7576B0095; Fri, 28 Aug 2026 06:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE826B0096; Fri, 28 Aug 2026 06:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C57D6B0098; Fri, 28 Aug 2026 06:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 238CF6B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:18:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A4181A02A4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:18:07 +0000 (UTC)
X-FDA: 85150277814.10.1D701C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 93178180004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:18:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bMZFE1/1";
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787912285;
	b=8C2B9j7RPxLB9pZ/yUXLAMUXPum7NbDpmZM3GqGOhoaog0TmF4XHQnOppZhGDCIEtn49jj
	8XpgsEASPJWCUTo2xks3xY1YvdM0e4GK9ZgHTGfmI7lufIPIhVFWUYvCAAc4E6RfC+pA1Y
	7ZSIRYqsvCV0JWqamHPHZH9IIA5aNcM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="bMZFE1/1";
	spf=pass (imf16.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787912285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2fkaaqGv4jqvtf5VExvyoyogLt5ptiPT4Y4qS0ASCg=;
	b=NW1sTF+dFbJQ1zlsgjlk5lCoT5NmhQfMXl6dp5EMQh7t6j5ABpx8KPXqokmc2a2U25FWq0
	Ub4dJUJdclY7gaetlsvUPXKSlcFmdnVjBuOVdIx3eo5X6yYIZC2jEri4C3svnOR+YGUZSa
	ZciS/keKJy8ZW/x7QKMyw4+d7Zgzx94=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE7E91595;
	Fri, 28 Aug 2026 03:18:00 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68DD33F85F;
	Fri, 28 Aug 2026 03:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787912284; bh=CbvGFJ8kVQrPI9Yko5peo2qMenVmZkwC+Zh1/r4h2U8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bMZFE1/1z8AVA8xhpYECfzD4QVHxXm0hOZNwfBMEIkoVqdVV54QK5VEbseJwq2taY
	 Nnl9QRby91uujpgwEW9ayikWFw3hUD3HdJhev3z/0hMSlCWHISuId7xNu/5cTrix+p
	 cXAmeO1lWARTCDflsiMZza9YmDOKtPTEsoZ9jN5w=
Date: Fri, 28 Aug 2026 11:17:58 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apFgVvNMbdhYnu6p@e129823.arm.com>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
 <apFMvo8pCzaGKope@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apFMvo8pCzaGKope@gremlin>
X-Rspam-User: 
X-Stat-Signature: gn65pood7ct7zwubtnyr3kiwzk6tzc9a
X-Rspamd-Queue-Id: 93178180004
X-Rspamd-Server: rspam06
X-HE-Tag: 1787912285-346669
X-HE-Meta: U2FsdGVkX19+cesdLPKdnhev8+yHXKq3h3zsrGQkoFMG6i8rWqegQrvNayekpPEemwZh5w/Lv02UyWN7/OXU8+YRt/nzZ+HD6oM+vs0FvgM98ZtRnYUY+Is7h+x6VCri/5mN/lIWLER/6U3q2A7b201WwXqq7ZOhvKDXqlgs7mUqBmssaB+6zLDphF6O6XWO8vTN+MGqvmKY6ZtbGqDePa1mfa6OA4Zppjtsd6DqXyTQ0LjTGi7q06KBbb69NSrbe2MvXUPDEEqg1OrHkX+TUPfS8dbu9ZUTnRX4oFIctoEvOpaO1k64eZkBTHvV/hm1aStJFBag/HSqUntK7AKPiRWydLNRZHlzt64KydyYpQh0J4DrFwCHIcSgFbQcAuM26evGgZuqLoo9fZ3ZfSFrvl3J3w/EUE7HqQXs9KqBzPPFj346PIajKS0/YQ8lSG5kIkxXI5A+E0p+W5ccI2tp/xl8yisuh3E8Njv+sL1nhFfaQkDpkhVZbK1GICUMUOeaF1cZ6DGi2f2muU+nE1vHMMWzjySLwtg9Z19MlqYbqGZxmNYEnCuPQUQexB79JfsnqHrGvuVqbkGzx86UqEGT7x4mu3fOaWOi81ztYIS7RpM2vT9U8SdH+x6LyIkfZf1qKJ0X4ng6HbFp9Wa0mf6LqaDbGNOcA4KMqK+gKWbz9H2gT3Jc3a1F7IF0bH0AMKcDldi4SZcGRK70mfs6BZauoRHdE75iLoppnvNN8+a0gVy/81rJ/V7bQPL95mKrCLBneMca/TJgvtbs2pfx5mZ27ALaq6pUrDAjCAkQtjZ480P8ByRPXf8yDj0QbIR5sdCgnY9J1exP3wUL8EFBO+DzbZaUmoqxAV2YCFqc8MbnYGzZRYvkDRYEr+3ytyrsoMZzUyFuSGQzuu504PR28Oh95b4DwO3SATkoBrnwSVYORWTivgRxzmh2qq23RGhhF49fQUVA7H16rde/3Ve/ale
 W+nc5hso
 tEsdcU7Xm5hFgqJktJTWeBVeQsSzE2XG7lMCyBjJR1GEntj9DYiH2e1fxLpnrZuXOMASHkdCQ8pbU78RCO2036SfJ1o4lC789XsUM2nLv8kH/5MuqgTxAc3pn6aFHPfFhD0a9UCmMiazMNQ38gAVawlYUVf5/N6IcIcVlS/8SHpmifckXvVgxdr6BOzutklqVssIuc6FSHsDEhmRl478UNFCfLL9ClAQdggw1tbROoZ0AUeXcXK6+QIjvgJ/7TBuwfpB0TlN735LxrTFLoIa0hdB1RnnuzSfaJ+lJp+DrRPGu88A5cOSeibdMQW3cJgQKUhkyTb77BuOdAodK/WX/Zfi/T6gapT+NY3E+pRhd+9p+wL2H5J0x6ixbzY2vn/l+eA+s5msJQvNP9IUEZJP8V8F/r/IW8ZJsfm5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Aug 28, 2026 at 09:11:34AM +0100, Yeoreum Yun wrote:
> > Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> > glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> > made by memalign().
> >
> > The underlying VMA may start at a different address from the aligned
> > address returned by memalign(). Furthermore, a subsequent
> > madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> > already set.
> >
> > This causes split_huge_page_test to fail because the check_huge_xxx()
> > helpers incorrectly require the address returned by memalign() to
> > match the VMA start address reported in /proc/self/smaps.
> 
> Hmm, is the test correctly putting sentinels either side of the VMA? Any test
> that doesn't risks flaking due to unwanted VMA merges.

I believe that with this change, we don’t need to worry about unwanted
VMA merges when checking for huge pages, since the test no longer relies
on VMA sentinels but directly checks whether the mapping is huge or not.

Also, this flaky failure was not caused by a VMA merge, but by a change
in glibc’s behavior that sets HUGEPAGE for sufficiently large areas.

Might for the *NO_HUGEPAGE* setup, there would be a chance to merge
VMA area, But since it seraches the mapping directly, it's fine.

> 
> >
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages.
> 
> You should probably call out the fact you're doing some refactoring here
> also!

Okay. I'll spell out with some detail. Thanks!

> 
> >
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Should always have a Closes: tag if Reported-by: ideally.

Yes. but talked with personally nothing to close. So Reported-by tag
only. Would it be better to remove?

> 
> > Suggested-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> 
> Generally looks reasonable to me, some nits above and below though :)
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
> >  tools/testing/selftests/mm/vm_util.h |   1 +
> >  2 files changed, 92 insertions(+), 54 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..083b72d92b14 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
> >  	return entry;
> >  }
> >
> > -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
> > -		  uint64_t hpage_size)
> > -{
> > -	char buffer[MAX_LINE_LENGTH];
> > -	uint64_t thp = -1;
> > -	char *entry;
> > -
> > -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> > -	if (!entry)
> > -		goto err_out;
> > -
> > -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> > -		ksft_exit_fail_msg("Reading smap error\n");
> > -
> > -err_out:
> > -	return thp == (nr_hpages * (hpage_size >> 10));
> > -}
> > -
> > -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> > -		uint64_t hpage_size)
> > +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
> > +			       void *addr, size_t len, int nr_hpages,
> > +			       uint64_t hpage_size)
> >  {
> >  	int order = 0, pagesize = getpagesize();
> >  	unsigned int nr_pages = hpage_size / pagesize;
> >  	int orders[MAX_NR_ORDERS], status;
> > -	int pagemap_fd, kpageflags_fd;
> >  	bool ret = false;
> >
> >  	if (!nr_pages)
> > @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >  		ksft_exit_fail_msg("invalid order\n");
> >
> >  	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
> > -	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > -	if (pagemap_fd == -1)
> > -		ksft_exit_fail_msg("read pagemap fail\n");
> > -
> > -	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > -	if (kpageflags_fd == -1) {
> > -		close(pagemap_fd);
> > -		ksft_exit_fail_msg("read kpageflags fail\n");
> > -	}
> >
> >  	status = gather_folio_orders(addr, len, pagemap_fd,
> >  			kpageflags_fd, orders, MAX_NR_ORDERS);
> > @@ -405,48 +378,112 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >  		ret = true;
> >
> >  out:
> > -	close(pagemap_fd);
> > -	close(kpageflags_fd);
> >  	return ret;
> >  }
> >
> > -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > -{
> > -	uint64_t pmd_pagesize = read_pmd_pagesize();
> > -
> > -	if (!pmd_pagesize)
> > -		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > +enum check_huge_type {
> > +	CHECK_HUGE_ANON,
> > +	CHECK_HUGE_FILE,
> > +	CHECK_HUGE_SHMEM,
> > +};
> >
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> > +			    enum check_huge_type type)
> > +{
> > +	bool file = categories & PAGE_IS_FILE;
> > +	bool swapbacked = kpageflags & KPF_SWAPBACKED;
> 
> NIT: nice to const these :)
> 
> > +
> > +	switch (type) {
> > +	case CHECK_HUGE_ANON:
> > +		return !file;
> > +	case CHECK_HUGE_FILE:
> > +		return file && !swapbacked;
> > +	case CHECK_HUGE_SHMEM:
> > +		return file & swapbacked;
> > +	}
> >
> > -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> > +	return false;
> >  }
> >
> > -bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> > +			 uint64_t hpage_size, enum check_huge_type type)
> >  {
> > -	uint64_t pmd_pagesize = read_pmd_pagesize();
> > +	bool ret = false;
> > +	int pagemap_fd, kpageflags_fd;
> > +	int nr_pmd_mappings = 0;
> > +	uint64_t pmd_pagesize, scan_mapping_size;
> > +	uint64_t categories, kpf;
> > +	unsigned long pfn;
> > +	bool check_pmd_mapping, allow_nonpresent;
> > +	char *start = addr;
> > +	char *end = start + len;
> >
> > +	pmd_pagesize = read_pmd_pagesize();
> >  	if (!pmd_pagesize)
> >  		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> >
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> > +	check_pmd_mapping = (hpage_size == pmd_pagesize);
> > +	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> > +	/* Some mTHP tests check a partially populated PMD-sized range. */
> > +	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
> >
> > -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> > +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > +	if (pagemap_fd < 0)
> > +		ksft_exit_fail_msg("open pagemap fail\n");
> > +
> > +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > +	if (kpageflags_fd < 0) {
> > +		close(pagemap_fd);
> > +		ksft_exit_fail_msg("open kpageflags fail\n");
> > +	}
> > +
> > +	if (!check_pmd_mapping &&
> > +	    !check_large_folios(pagemap_fd, kpageflags_fd,
> > +				addr, len, nr_hpages, hpage_size))
> > +		goto out;
> > +
> > +	for (; start < end; start += scan_mapping_size) {
> > +		categories = pagemap_scan_get_categories(pagemap_fd, start);
> > +		pfn = pagemap_get_pfn(pagemap_fd, start);
> > +		if (pfn == -1UL) {
> > +			if (!allow_nonpresent)
> > +				goto out;
> > +			else
> > +				continue;
> > +		}
> > +		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> > +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> > +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> > +			nr_pmd_mappings++;
> > +		if (kpf & KPF_COMPOUND_TAIL)
> > +			continue;
> > +		if (!check_huge_type(categories, kpf, type))
> > +			goto out;
> > +	}
> > +
> > +	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
> > +		goto out;
> > +	ret = true;
> > +
> > +out:
> > +	close(pagemap_fd);
> > +	close(kpageflags_fd);
> > +	return ret;
> >  }
> >
> > -bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > +bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> >  {
> > -	uint64_t pmd_pagesize = read_pmd_pagesize();
> > -
> > -	if (!pmd_pagesize)
> > -		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > +	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
> > +}
> >
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> > +bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > +{
> > +	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
> > +}
> >
> > -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> > +bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > +{
> > +	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
> >  }
> >
> >  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> > diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> > index 9a49af88702e..f19bd17817e5 100644
> > --- a/tools/testing/selftests/mm/vm_util.h
> > +++ b/tools/testing/selftests/mm/vm_util.h
> > @@ -18,6 +18,7 @@
> >  #define PM_SWAP                       BIT_ULL(62)
> >  #define PM_PRESENT                    BIT_ULL(63)
> >
> > +#define KPF_SWAPBACKED                BIT_ULL(14)
> >  #define KPF_COMPOUND_HEAD             BIT_ULL(15)
> >  #define KPF_COMPOUND_TAIL             BIT_ULL(16)
> >  #define KPF_HWPOISON                  BIT_ULL(19)
> >
> > --
> > 2.43.0
> >
> 
> --
> Cheers, Lorenzo

-- 
Sincerely,
Yeoreum Yun

