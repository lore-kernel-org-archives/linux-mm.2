Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C9FC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CEB6B008A; Fri, 28 Aug 2026 05:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7066B008C; Fri, 28 Aug 2026 05:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E1F6B009B; Fri, 28 Aug 2026 05:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECDC16B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:30:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 779FE14028E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:30:30 +0000 (UTC)
X-FDA: 85150157820.30.D3BB439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98E0018000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:30:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UE+56Yl6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9o8Kq8i/SkkJT21MegjxpzJj6woYmqf+dtso+F8rDM=;
	b=OyrQPWNDy8gj8WBv4J0EoA9E6lVIZwo8dhCcvKsWweDF+KDeN0pyzJwpxnPkROD8Khyltp
	F2SWjCLYD9U9WSEh0K9XZ0rDz7AFvUzyuZYZ1wYSgg1KsPQAiaGlgdPbs7e9yUhbJGZ1x9
	VRkWP4Xqmhx7pRzkrjthuD4u+74SqDs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UE+56Yl6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909428;
	b=k2cBgjHTVBuXdweczZB5vCgcKgC0Uf4XKGinhf41ITwy3XU/2cMJtmlQTKy73jwr9gnEJw
	MKJsbx0zB/VC2g00OUi78IKXwgYLsLj6WAHjAAPkjlaKCPh+FwNJTbXz2oLYj3is9TM8aw
	+6GPcQ2i3awTud9Q33iEx5FzvBC/w6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F1E941595;
	Fri, 28 Aug 2026 09:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B267E1F000E9;
	Fri, 28 Aug 2026 09:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787909427;
	bh=r9o8Kq8i/SkkJT21MegjxpzJj6woYmqf+dtso+F8rDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UE+56Yl69Eql8i4QNGQz9CX9k5QgFeXTsmif4zrkUzvDrdnmVS2JPDqgW/5etvnlU
	 +GCsKRZYYuBZMCbrqER2Ot+y5nkNmQfvX4jCVRK273mxe+ecaPgfPt95C/LmlTD1T0
	 12nudhHl24g44E1QB2VuoQj/z3T8XRUViCDGiVS+LSkva4Y4d2C9/v96kXXL1Cn1wX
	 qvXvesAhC/lKJ5FGzMJ/uR+CjiDaSEa9AEC2e9deunz+Rv90939F7vkl3MIbLUip2i
	 RxSVUMJflcRl4iR4b5fsrY06A1WF88bCH5yU0scGxtn0rers0peTKu1hpEK8MV+/vY
	 WdgyYInXdmftA==
Date: Fri, 28 Aug 2026 10:30:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <apFMvo8pCzaGKope@gremlin>
References: <20260828-fix_split-v3-0-374022586a4b@arm.com>
 <20260828-fix_split-v3-2-374022586a4b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260828-fix_split-v3-2-374022586a4b@arm.com>
X-Stat-Signature: ejziq39gh8ess47szxa4ixrnizgidpbp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98E0018000C
X-Rspam-User: 
X-HE-Tag: 1787909428-905855
X-HE-Meta: U2FsdGVkX1+/dc9aG0YthnrOsB6krmKPJXp46fRpdrlO2oQRARv4MA4Fax8RtfeUFfmLIID162rpz74do7fb3ZDP2nShe+Dr8OKP462LUlJmGMh0BVL84zkjwPP0Zv9qDNKWXcCqxX3X2ZDDVpfTvV/NBxX83hNSzlXKCd1CyfLGZhPdWx15/thvsEQqrJ+HTYjYbmf0GdyWmP4X95qir6Wp/Rbmytc1ac+VE/1mm5uWTCkCZz52OnQHemlQV6OyWrfus7ktlEnJgYWPCwUR/k3HbjohfkBki1ZtEPKoELSBoux78nULgdoWapfo1Fz4WC3RcMiWzTu/iBUVqUwHHcXQfSxhF/hYQCW32u85cRIesEqf9uXLg0Suj45PqL0qNYs3gyU79VSbwnsLgxcK0fcBsQqXfyj3PD4PChuRAFkLqOVzi250tJotUsuN2LXcS+x4Ee+CU7fMRzD6+61XDzWxCYTa3JHM4XHCRKGZH0a6UM4bITUclxd2cE/j0KumPLmpYD93R1G2HV+F10UnA1KGYeyoRRDDmwn8Hh90AXn80EntvYOkNP/lNPMJBLBY+I5ZSnY2FGPRuR/WfPTAvsJlafn/kEuIDRlEF1SriJFLF91Tf7+cvOO5ga8SLKJe5woV0nGo9DaZP6XbbOR8CniH8UWczz3hAUARtZLcKN1B5rA20AcVFXBlb1KWBFxSddMdRCznyA3Tdc7QFrfjEUlySWnOZNTzEKNG67WZKVueQB7O5vp9HMXY+4x7LoyUiOov2wVoyVN05Qhvj8r905XcLVrbH8ifVfW3hAjg+zdJVhm2VRPhnRiC6LeCirdX+n3gOg/KqKiMoHNNCAN+ZFK6LmTq2I/CYj2R/2UAoV9npbtBfx8nz+wUvCKBDmW64RMuuJfIe388Rmem4Dcc0ADDOQCtQDx9+hRI0bYcRuaEoUFYh/ljHLb3IXGNtkH40cBgyAzSQBCyQgcpIXR
 k7m6fIui
 AgLyjZHYb0M/RrVeGgUWjHzTwLxBkp0uvlAWki7H+znXt45FRbymXQZcKZt0FxfJ8lnxlM/uUHNtY+Z3BbIwYFvtVwHZEd3++Ij+Jg8/4NRQVZ5QuV9oWNqZUn7Mjg5EtaekyHHy/5JtAW6xOlr3s0Qr4jYhAZFlXDeWrrS7CFBI7isHdVTBPcHVlkD+aOGeefJBdoULppvqC/BKr2FKplgF5rqM0lp39NDok332QR9mPkeS0PSWTzoR/3reJjdySyRZ2gPISDj9I9+Gvchbj8ZU2h0YVhZtEzDsosCK8Z9r3WNSnzeVWZGlIJKi8YQ2FTYAlmuLMudn6cI2Qwixn/+32LkWUVZefxouy5eQV7oqhCd23FMuq3GRhWr+LASl4+5H9fO90beCPei90pnWqmNknLtGjlZece4QRcOcypgIV76PK84kJqziDgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 09:11:34AM +0100, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
>
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
>
> This causes split_huge_page_test to fail because the check_huge_xxx()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.

Hmm, is the test correctly putting sentinels either side of the VMA? Any test
that doesn't risks flaking due to unwanted VMA merges.

>
> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> /proc/self/smaps to detect huge pages.

You should probably call out the fact you're doing some refactoring here
also!

>
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>

Should always have a Closes: tag if Reported-by: ideally.

> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Generally looks reasonable to me, some nits above and below though :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
>  tools/testing/selftests/mm/vm_util.h |   1 +
>  2 files changed, 92 insertions(+), 54 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 4821a3563036..083b72d92b14 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
>  	return entry;
>  }
>
> -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
> -		  uint64_t hpage_size)
> -{
> -	char buffer[MAX_LINE_LENGTH];
> -	uint64_t thp = -1;
> -	char *entry;
> -
> -	entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> -	if (!entry)
> -		goto err_out;
> -
> -	if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> -		ksft_exit_fail_msg("Reading smap error\n");
> -
> -err_out:
> -	return thp == (nr_hpages * (hpage_size >> 10));
> -}
> -
> -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> -		uint64_t hpage_size)
> +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
> +			       void *addr, size_t len, int nr_hpages,
> +			       uint64_t hpage_size)
>  {
>  	int order = 0, pagesize = getpagesize();
>  	unsigned int nr_pages = hpage_size / pagesize;
>  	int orders[MAX_NR_ORDERS], status;
> -	int pagemap_fd, kpageflags_fd;
>  	bool ret = false;
>
>  	if (!nr_pages)
> @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
>  		ksft_exit_fail_msg("invalid order\n");
>
>  	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
> -	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> -	if (pagemap_fd == -1)
> -		ksft_exit_fail_msg("read pagemap fail\n");
> -
> -	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> -	if (kpageflags_fd == -1) {
> -		close(pagemap_fd);
> -		ksft_exit_fail_msg("read kpageflags fail\n");
> -	}
>
>  	status = gather_folio_orders(addr, len, pagemap_fd,
>  			kpageflags_fd, orders, MAX_NR_ORDERS);
> @@ -405,48 +378,112 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
>  		ret = true;
>
>  out:
> -	close(pagemap_fd);
> -	close(kpageflags_fd);
>  	return ret;
>  }
>
> -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> -{
> -	uint64_t pmd_pagesize = read_pmd_pagesize();
> -
> -	if (!pmd_pagesize)
> -		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> +enum check_huge_type {
> +	CHECK_HUGE_ANON,
> +	CHECK_HUGE_FILE,
> +	CHECK_HUGE_SHMEM,
> +};
>
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> +			    enum check_huge_type type)
> +{
> +	bool file = categories & PAGE_IS_FILE;
> +	bool swapbacked = kpageflags & KPF_SWAPBACKED;

NIT: nice to const these :)

> +
> +	switch (type) {
> +	case CHECK_HUGE_ANON:
> +		return !file;
> +	case CHECK_HUGE_FILE:
> +		return file && !swapbacked;
> +	case CHECK_HUGE_SHMEM:
> +		return file & swapbacked;
> +	}
>
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +	return false;
>  }
>
> -bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +static bool __check_huge(void *addr, size_t len, int nr_hpages,
> +			 uint64_t hpage_size, enum check_huge_type type)
>  {
> -	uint64_t pmd_pagesize = read_pmd_pagesize();
> +	bool ret = false;
> +	int pagemap_fd, kpageflags_fd;
> +	int nr_pmd_mappings = 0;
> +	uint64_t pmd_pagesize, scan_mapping_size;
> +	uint64_t categories, kpf;
> +	unsigned long pfn;
> +	bool check_pmd_mapping, allow_nonpresent;
> +	char *start = addr;
> +	char *end = start + len;
>
> +	pmd_pagesize = read_pmd_pagesize();
>  	if (!pmd_pagesize)
>  		ksft_exit_fail_msg("reading PMD pagesize failed\n");
>
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> +	check_pmd_mapping = (hpage_size == pmd_pagesize);
> +	scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
> +	/* Some mTHP tests check a partially populated PMD-sized range. */
> +	allow_nonpresent = (uint64_t)nr_hpages * hpage_size < len;
>
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_msg("open pagemap fail\n");
> +
> +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> +	if (kpageflags_fd < 0) {
> +		close(pagemap_fd);
> +		ksft_exit_fail_msg("open kpageflags fail\n");
> +	}
> +
> +	if (!check_pmd_mapping &&
> +	    !check_large_folios(pagemap_fd, kpageflags_fd,
> +				addr, len, nr_hpages, hpage_size))
> +		goto out;
> +
> +	for (; start < end; start += scan_mapping_size) {
> +		categories = pagemap_scan_get_categories(pagemap_fd, start);
> +		pfn = pagemap_get_pfn(pagemap_fd, start);
> +		if (pfn == -1UL) {
> +			if (!allow_nonpresent)
> +				goto out;
> +			else
> +				continue;
> +		}
> +		if (pageflags_get(pfn, kpageflags_fd, &kpf))
> +			ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> +		if (check_pmd_mapping && (categories & PAGE_IS_HUGE))
> +			nr_pmd_mappings++;
> +		if (kpf & KPF_COMPOUND_TAIL)
> +			continue;
> +		if (!check_huge_type(categories, kpf, type))
> +			goto out;
> +	}
> +
> +	if (check_pmd_mapping && (nr_pmd_mappings != nr_hpages))
> +		goto out;
> +	ret = true;
> +
> +out:
> +	close(pagemap_fd);
> +	close(kpageflags_fd);
> +	return ret;
>  }
>
> -bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
>  {
> -	uint64_t pmd_pagesize = read_pmd_pagesize();
> -
> -	if (!pmd_pagesize)
> -		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> +	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_ANON);
> +}
>
> -	if (hpage_size == pmd_pagesize)
> -		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> +bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +{
> +	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_FILE);
> +}
>
> -	return check_large_folios(addr, len, nr_hpages, hpage_size);
> +bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> +{
> +	return __check_huge(addr, len, nr_hpages, hpage_size, CHECK_HUGE_SHMEM);
>  }
>
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd)
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 9a49af88702e..f19bd17817e5 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -18,6 +18,7 @@
>  #define PM_SWAP                       BIT_ULL(62)
>  #define PM_PRESENT                    BIT_ULL(63)
>
> +#define KPF_SWAPBACKED                BIT_ULL(14)
>  #define KPF_COMPOUND_HEAD             BIT_ULL(15)
>  #define KPF_COMPOUND_TAIL             BIT_ULL(16)
>  #define KPF_HWPOISON                  BIT_ULL(19)
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

