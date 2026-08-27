Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61863C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C916B0095; Thu, 27 Aug 2026 05:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7029C6B0096; Thu, 27 Aug 2026 05:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618F46B009B; Thu, 27 Aug 2026 05:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF786B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:11:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2702A0363
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:11:26 +0000 (UTC)
X-FDA: 85146480972.28.51DA6A6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BC04C000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:11:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B78f3fUn;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787821885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYcmrLIRNXUMVWzZqQ2R2MQuJslRHFwtrCwv/X5ogGo=;
	b=IjLtVvWGGDpRaq6aus9D1S5dWEM+ziMNv8bIP0H1Nz4DaM0dYQGQiR93sp5uuCaHKbOtkI
	H0539tNwws8Vfa7HQgnwSqE/nVRWJlNsS9tfY4HBpX7HM98ZZsu9BLA4BewevUzLNAe5B6
	PofNLAFuvRLY5zjRdldfEeHmGFRAGgQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787821885;
	b=8Z1BdYcBHvnuyIVFIVg3UtSB3LEmXJ3WNM+VYSRCYwpT23BYKyrcJoqGe8RsKu3h8tV+Aa
	KEjEejTJJBnA2otOT2BYkzorNIR2uiq7p2KD1+elQGgIhkwnoDxqDfi3briRHXJrAtIX/4
	SyY+y05lKZ5jP0yHpqA/oJ9wFwRdi+I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=B78f3fUn;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAA691691;
	Thu, 27 Aug 2026 02:11:19 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F04703F66F;
	Thu, 27 Aug 2026 02:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787821883; bh=QKU+9q4pENcnompvJW0fhnGbUV8ZmvmR3+gMvGi7I0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B78f3fUnTn4z7rhLL+do+CgyE8kOHsCC7k1NgDAp1/gfwIIO8Nh6AzoSw8HaJGJhM
	 Fyq5N3VpBFcpwtbtozzYzAIyDnvbzPrNyZ30ZkXOdOKNLF7++7wUcq7q8tgo2022sl
	 pMbahu2ZxtcFvFBT7bMpwqg4cTC1U5HPz+Vv0L/E=
Date: Thu, 27 Aug 2026 10:11:18 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
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
Subject: Re: [PATCH v2 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Message-ID: <ao__Noj3IkhfHVRE@e129823.arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-2-71153c7f579a@arm.com>
 <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BC04C000D
X-Stat-Signature: ui7yk3ddmyxhsmpwsfe5rdruc54in1hq
X-HE-Tag: 1787821884-947124
X-HE-Meta: U2FsdGVkX19TDAbrRiFKe+gqDIpPX6nzCGxmbNxnj6rQKaFTZnnv31awJi5eNGZZVbaARcA/kndkbfkHNZnuSFrEbdjHUtv/2dMUHhR6Sgww1JtTj6rwg0pAanNbvZbp/lVXPAwBPgWUX9zfSDlXncLNydxvTolMi0vCx4L+jnFpNUOZSDfYSoShmipEFjyeZ8sREhOmorCTEFemBq3zl2CQVis6JJ2Buu5pF/F9C6I912xuKTIu0D6dx8asOCNTBSKbuoh3+fJTeAbYdU8E2QImzQpvGkvehYrnJDBYI722ktlIpV4Aq2QDJYN4xO9qteE8rZE6vIX8g+vPMUNHF+Q8TAQ5Jx/AUe/mrd8uZHtoGEy9ZpS7MZwKaAFN02bEnE/h+nAOaotE+g0a3WYMjkdiOrDoiyhNTFpBW3XQ3cwC6OENtSvD131TbMsV5LiRG50SHBo9UsTVVCCKdjhf5uGfHMaOVWv08IHqGNFC1c61r6ZF8axeJd9oD8MvX3mnzLxsVS8Npzb8Yqk0UegAXBQv3eJJWesj+RJ2tP7du1/YPv7odyKvEgsWKwYroT92fq6+ojyaJxtEHGS3CpobuhXAJ6bKJCijMp200ADHv1W7YF/O9thbck5Qcef7HlkSczNZVgbd/X4M8sY9cdR8pPv4+SnEG/EvVxfyMeh27x8265VKLzgRX+QuvMMu5qFvsznkn17IXR7qbfeJ4XS5i/TVlSk21vhsLBaQswmfWONHFQT3h4eTDBznGmopquAuv2PCv98k4dAdDYgqkOleLKmDSGeglUxMTvkjLjHbYNyF3RcP/4TXivNhRgzHsEmCgBxaKlsz68pg1667p2ZdNZXAS2E4ZSpYZj2YeGkFFGh28xxPvg5+6f11iDVgnQnnxeZ2xHUVE5jkS+QhSjbyNTh9aPjk1S70bJZTmSrKoYE53tpqIHZ9HESxpeCWd32qSWW5a422VCKyg7nebNn
 ydOOLvUM
 VKC6avW+dTcnB2kR2Ury73luqpXpwZFTYPdO38KYWz16Jdahz92G4hqUkj275WKgbKtytZal1LZcMFwZmdJc/lVciSMmcDn7WLBnAGd6fpdEB3zvGxiQRIBL+VGdz1cKbfgZvBcqfO5O6Sh3BNnsn3MiCjThwEaFVvRps2XrSvKOrZ9ATjTP4M/HtR6/d+n+GqmC1e3oeAEhkWrajOHl/u5kFnvdHBZENUc9MZAh2Ou70sMiPNBZSxcQOZnH/AZK9Gc/dBHpA7GSKCXscsuA08WbPs1HUOkVquNaTjy/UqHSxEy5Z0uiRDJjaG+eVCVtTwM3Lm3GUPGr4gD5eVGgYnDuOyOx9/NVter2gyvrKYVS9wSiOPaSBMeNL4OOuodiUTZWl5F4DPmW5+qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 04:28:01PM +0800, Baolin Wang wrote:
> 
> 
> On 8/26/26 8:24 PM, Yeoreum Yun wrote:
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
> > Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> > /proc/self/smaps to detect huge pages.
> > 
> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >   tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++---------------
> >   tools/testing/selftests/mm/vm_util.h |   1 +
> >   2 files changed, 77 insertions(+), 54 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 4821a3563036..1d0959b3b9e8 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
> >   	return entry;
> >   }
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
> >   {
> >   	int order = 0, pagesize = getpagesize();
> >   	unsigned int nr_pages = hpage_size / pagesize;
> >   	int orders[MAX_NR_ORDERS], status;
> > -	int pagemap_fd, kpageflags_fd;
> >   	bool ret = false;
> >   	if (!nr_pages)
> > @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >   		ksft_exit_fail_msg("invalid order\n");
> >   	memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
> > -	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> > -	if (pagemap_fd == -1)
> > -		ksft_exit_fail_msg("read pagemap fail\n");
> > -
> > -	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> > -	if (kpageflags_fd == -1) {
> > -		close(pagemap_fd);
> > -		ksft_exit_fail_msg("read kpageflags fail\n");
> > -	}
> >   	status = gather_folio_orders(addr, len, pagemap_fd,
> >   			kpageflags_fd, orders, MAX_NR_ORDERS);
> > @@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >   		ret = true;
> >   out:
> > -	close(pagemap_fd);
> > -	close(kpageflags_fd);
> >   	return ret;
> >   }
> > -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
> > +enum check_huge_type {
> > +	CHECK_HUGE_ANON,
> > +	CHECK_HUGE_FILE,
> > +	CHECK_HUGE_SHMEM,
> > +};
> > +
> > +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> > +			     uint64_t hpage_size, enum check_huge_type type)
> 
> The original __check_pmd_huge() is only for PMD-sized large folios, but now
> it not only checks PMD-sized large folios but also mTHP large folios, which
> I find confusing. Please keep its original semantics, and only check
> PMD-sized large folios.

Okay. thanks!

> >   {
> > -	uint64_t pmd_pagesize = read_pmd_pagesize();
> > +	int pagemap_fd, kpageflags_fd;
> > +	uint64_t pmd_pagesize, granule;
> > +	uint64_t categories, kpf;
> > +	unsigned long pfn;
> > +	bool check_large, huge_mapped;
> > +	char *start = addr;
> > +	char *end = start + len;
> > +	pmd_pagesize = read_pmd_pagesize();
> >   	if (!pmd_pagesize)
> >   		ksft_exit_fail_msg("reading PMD pagesize failed\n");
> > -	if (hpage_size == pmd_pagesize)
> > -		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> > +	if (nr_hpages > 0) {
> > +		check_large = true;
> > +		granule = hpage_size;
> > +	} else {
> > +		check_large = false;
> > +		granule = psize();
> > +	}
> 
> This is incorrect for the mTHP large folio check. I already hit a selftest
> failure. Please test your patches before sending them out.
> 
> [root@]./khugepaged -c 4 mthp_khugepaged:anon
> TAP version 13
> # Save THP and khugepaged settings... OK
> 1..4
> # Allocate huge page on fault... OK
> # Split huge PMD on MADV_DONTNEED... OK
> ok 1 allocate on fault and split
> #
> # Run test: collapse_full (mthp_khugepaged:anon)
> # Collapse multiple fully populated PTE table.... OK
> ok 2 collapse_full
> #
> # Run test: collapse_empty (mthp_khugepaged:anon)
> # Do not collapse empty PTE table.... OK
> ok 3 collapse_empty
> #
> # Run test: collapse_single_mthp (mthp_khugepaged:anon)
> # Collapse PTE table with half PTE entries present.... Fail
> not ok 4 collapse_single_mthp
> # Totals: pass:3 fail:1 xfail:0 xpass:0 skip:0 error:0

Oh sorry. I've forgotten to this case to test.

Thanks!

 

-- 
Sincerely,
Yeoreum Yun

