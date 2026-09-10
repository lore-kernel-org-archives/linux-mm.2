Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E7FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EF16B008A; Thu, 10 Sep 2026 06:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D054B6B008C; Thu, 10 Sep 2026 06:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B636B0096; Thu, 10 Sep 2026 06:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6EB6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:54:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3773AA04C0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:54:22 +0000 (UTC)
X-FDA: 85197543564.01.7C46FE1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6900A100008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:54:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VN6MoQBj;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037660;
	b=VGPrPemzhG1vSmhjpL6yrMz/AL4KdKYJSRN0pxcDtGqC8GPfL1wgjCk9nOjhNslB5PNS/m
	TVaMsP4GALVy46J5ioEyETJ6u3mrB+2e+qyEPOc0H1L/Pr25a8iJRoC7bOLVs/5cftdDqU
	YDr4INHm8PbC7X8NPG57+0jBY3UyNNI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VN6MoQBj;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Syr3CivIpQNe1+9BBRPldS4/S/zsJdsKT46NZN5zftw=;
	b=GZLi8uEQhmzSlEHg0wXVPyv0NyXGmvQ4fGTY6NM9t4rePz84j3oBDxrJCcZ/qCAH77zIAq
	M9eACEJvUj3LFWCC/iCgSmOtDgm3aTuXk3J6f7H/B3Az1jwU+JTnQ6dJBR9Dd578R6drlt
	OETduE65Xe7n0N5fwCTbYaOFNo7CYvY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE2211477;
	Thu, 10 Sep 2026 03:54:15 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19E8E3F7B4;
	Thu, 10 Sep 2026 03:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789037659; bh=LZa/mTe3VR25KHQaR9yMTJp7T+IkVsTbaUvpTI1sUo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VN6MoQBjtpr1/cmo6G/4YZh5bHXuew9SIhpd11l+692psl/N9na3NbHc21NOsAUsU
	 3+TQmValjDyMFstToPCzXuQUZ63eChLMNCBjyW+gx19SIlNi9MqfNzNAp+KP3fHIbQ
	 6G3FQnvZE1lwfmo6X/7iJEX6alz2jYz4JAF7kQnc=
Date: Thu, 10 Sep 2026 11:54:13 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
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
Subject: Re: [PATCH v5 2/3] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <aqKMVUDvN8bBpwVS@e129823.arm.com>
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-2-822b810458bc@arm.com>
 <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <956df69d-8c0a-420f-889e-7df2842605dc@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6900A100008
X-Stat-Signature: tec9censythbeo4cjccuqonbfgwh9wct
X-HE-Tag: 1789037660-189562
X-HE-Meta: U2FsdGVkX1/av0EPbbyWNlXOOSBt/Oh8oiNmvQ21ueiMtIhBvLJf2wITjUa+8thCQScitUmU1hob/boygE/GlXatPN1xembP55RMBL/CwiTCcyGwoRCsY6fC5BejZLcQn2b4NS/wvhC0NLlckFq7trtqVHmQ7MEfRfaO/y4ZVVjnPTGTObmIPsdZJQG9uSOJCtw/XwKbQ0GbHIDISu0LoHmGPn/9Y8oM+Q1zIMqaWJ4ntIwm2eimFo2pX7m5jb/jXElF5CYoWiH84Agh9h9H48UhXBYHpQJGBtuK38kdb018lVDSGflzPV2G4J+AARZ/2zEoBrOnNvx+oQYMhJr954T5ptWM/GovOQioG9I/XlD2GhLMby7MpXPp4TdRa8PdV6vWFEofpdv6bwhUN+qv7n9ADfoK0supOMNPBlWmejRv6ppsh7aCkPFGuEBNhRqmXWn96/IVxedvruGRGOypLEH0HKA6TonnnBfzWAubSZha9dpPEqEUb+QnjQS1cmNevKhyOyI6p3la2ADUMAzcz5jD3Roq92L34WRQMxWvDAT7uQJHt7zQFvY/7BiBaq+9tPgBGDlAX19DCC+YNSn2HSTnbnTF4HCpCDcKNuwAVeV7DzkAq90NaGTrtfBsZUlf6Fmiy7W9aqdG3Dkjl3UxRIsjfFTaly+gdqJfD5N3yc5j7WoDXS2rhm+utZyWnjbqV1SqwWrktFdSW57OfMrzNc+4T6A0D7bcsKakV9UL7Kr4xLc/+gPE2J630TCmoW7ctwOvGkY31dAKpVJeu2m4fWsruQN6iCKqb9QWFp2oIlrK6Xe1G86hpT3L7SqlXSpoOqlzNteIA6qJwpKMpbAesMxnb3KR+LVcJu73as12mcfdsUFLg0v05Jzut/lkmGtwBDOt1jlb7vCrUIRFbgYuuiNx1Ck646MMqV6t0OpzzhHjq0HXJIKHsruL981d8z+Jaf5n9oIQh7umvLDIqk+
 hBBBQvNh
 XGwdL/8t/i5/hdTZwmB0SKRIZS0xBHacu9FosgQv9yDdijD+PT7tzFsYRVfsIJA3QU8lZwgESoAOb1xlxurHLnsY6yBuhQT5ka32pHmIS3ZcKoNBAvz2ntLIoUM0fxsKxSTqxEvxl+XXGjujNLNYnWTinJdHQp419cDvUEjStFQRTXbyRh/EiSGooYku+BOi7o5+Prkl6EZRFS23CzcSm4G/tN4aMa5RBcbuZPETtVlNfEvYDW5CQ2R4zLhKlR+uaOsxTrV3j59MurqNFc5FD4U0jxF3XlZ+tNIM0vJrJg9LorfzJ0ybS5ZgJVFVZSZ5iAiZnD0C9rZqJdlC2MpUu1Pw56OD8n4tJcVacRgzXHoS1cEz7Q2LBtKoiVo5GgM/Fg5M3jBJuh+vnxl9QK3bn7x5kDJWkcyKqO3w2ChQEgBdtCeFtlGC7LdA/4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 9/7/26 10:19, Yeoreum Yun wrote:
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
> > 
> > Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
> > /proc/kpageflags to detect huge-page mappings and large folios:
> > 
> >   1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
> >      using check_large_folios(), since only the mapping type matters.
> >      This identifies PMD-mapped huge pages.
> >   2. Otherwise, use check_large_folios() to detect large folios. This
> >      covers mTHP cases.
> >   3. Check the folio flags according to the type of huge page.
> > 
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Suggested-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/vm_util.c | 145 ++++++++++++++++++++++-------------
> >  tools/testing/selftests/mm/vm_util.h |   1 +
> >  2 files changed, 92 insertions(+), 54 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..dc62ce84e143 100644
> 
> [...]
> 
> >  
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > +static bool check_huge_type(uint64_t categories, uint64_t kpageflags,
> > +			    enum check_huge_type type)
> > +{
> > +	const bool file = categories & PAGE_IS_FILE;
> > +	const bool swapbacked = kpageflags & KPF_SWAPBACKED;
> > +
> > +	switch (type) {
> > +	case CHECK_HUGE_ANON:
> > +		return !file;
> > +	case CHECK_HUGE_FILE:
> > +		return file && !swapbacked;
> > +	case CHECK_HUGE_SHMEM:
> > +		return file & swapbacked;
> > +	}
> 
> Why do we even need CHECK_HUGE_SHMEM?
> 
> That's really just a legacy thing for using smaps to identify huge pages.
> 
> It's sufficient to identify CHECK_HUGE_FILE if you know that you have shmem mapping.
> 
> You will not arbitrarily have non-shmem folios in a shmem mapping :)

Agree. but there seems the case where discern whethr the mapping is
with regular file or shmem like tmpfs -- khugepaged test where using
__shmem_ops. So I think it would be better to keep this as-is.

> 
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
> 
> No need to cleanup when exiting.

Yes, but some test code does clean it up, so I was just confused
about the convention :\

> 
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
> 
> 
> 
> -- 
> Cheers,
> 
> David
> 

-- 
Sincerely,
Yeoreum Yun

