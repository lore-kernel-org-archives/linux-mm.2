Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B9CAC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 173BC6B0088; Thu, 27 Aug 2026 07:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124406B008C; Thu, 27 Aug 2026 07:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012746B0092; Thu, 27 Aug 2026 07:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCFFD6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:07:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50C69A3BF3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:07:32 +0000 (UTC)
X-FDA: 85146773544.21.A3C87EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74AE5100008
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:07:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LMFKcVhA;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787828850;
	b=cFE7JtDtBLIqoS99u8c3hmIbOgEgamuy192mJy893O6GbOgf+O6c8ayEtueoPerI7k3QIK
	bqc222aptnrcJRmdXxqkImEtc3V6wIZYWoc9ECtAVfOSDGYF5/AnMtgP5AiZhhqVh2SgYe
	Bq/H18VWDxmjN4WEpInD7GrbrXi9zdE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LMFKcVhA;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787828850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rxye36hbiNyf2JHZ5OS89mTSdxPqWyGUMpm7kLepGmM=;
	b=xtQwG5Yj3kb6+BGgEIbnnOGGW3vUOwUBs0CT2Me9Gsol8nC4MUlD2htWSuPE5B9h804ptl
	V6YrcKEZgBbNm2pk5aTNq1jJJvb+7uKwGmAhJVAlxbGbPHub+1Ag206Rfui2XBRc6kgL8Q
	vwVAd8079+wxs6kLyLXboRVAYZEJphs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8B5F1688;
	Thu, 27 Aug 2026 04:07:25 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87D9F3F66F;
	Thu, 27 Aug 2026 04:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787828849; bh=Bb6IpuhdEkbgnnxFzFYvwpnFto7goaBHSkROsm2tLck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LMFKcVhAoW7tMilIOZ+sY7RpXhT2S/bEff6fX2Sf+5qk8vGMKPUTxdJ/zbWJuyt+U
	 +mbEnz3OQBj2jNL6rHpLBTdnjTdM1A0Ul2MzvwS0VUhVuEwpfF/n6dxHMNGHipsgRW
	 IiR5tFgMAuUcERVDOswGYT34SS0ppdpkDFmjtYro=
Date: Thu, 27 Aug 2026 12:07:24 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <apAabBIpmyH6lsgs@e129823.arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-2-71153c7f579a@arm.com>
 <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
 <44d36fb6-fdf4-4a8b-8e74-084a4b4f802e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44d36fb6-fdf4-4a8b-8e74-084a4b4f802e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74AE5100008
X-Stat-Signature: n9y5futc5obx63ierndhgheyckcfmaso
X-HE-Tag: 1787828850-147690
X-HE-Meta: U2FsdGVkX1+REyYv5Q8LV4Y2OGseVv7hfPIx7PGP9NZ6rM4EhqNeHbq4Iq960xy+A8bzI77qIPiJr6Q1lYI1YnV4y7EMi1EUssHB2kcvKxdWWFchzcelxuDtakhIKwbfk75XlX8WbXkqFmUKfRZUg7t4A5lcXClm3SRK8LT3xVszHxCNdZm+6WGE328PFb2VOb6JB98x9+h3xnIuOL6HQqXkkZ0EWHt4p9I7LZdNktarQqQ0YFSGbE5N1lG26dDXKNt0W5anRTdRwt0YSBUEchBMdCqSXu7DsPZOvLV0r3JKL1i0cI4II2DJ/7tMyHuP3RFkt40mpKkl8UViOmq0oDgRtsqHog/1PfBWdCnBQ0mvST9HD8nCgBt1b41GNk38Ab2fTkbdt00pwh1E1ZOM5ereCgJSvw8sykcu5PaPpI8uDMIWPw17aOz2Q62mKkpJjEKiPtZ7922UNA3hWD8KxROptVP2vJ+2J2fUuR+CGCMj7zRgCGum2eJ8smYP1bjdOyevWZbVnjxFWgmJGDdViGyga/92s53Kkd1lQsA/AiDzoDmY6nxWKZ5lgmrNH2aJykf3ONHPS2kmenCX2F2ohUjx1DwdhdWX+GVA0EL6fLO91Hu2Pb8/s/v+cQy9gKx+yaB2dE4Vr73VB/ZxYMQQrlA3sq6nmLy/JvJT2G0tjsBxoBzcv113G9Yxy/UNtByrs92UIGLy1/ZssZUbcAzRoP4caJDQXD+VsZ92NgozsaD4P68sxWumGgmtsKpRpczDWlA6Q/s4zc/9GY8i5Voj9xkYT5RhRpgT5dCniub7kQWAVWkZitsHpODtj7hovW9KStLRaWqX/b3kCMTdR69EYV7gm+vmDqj9oKZdONLRfPY/Ae3cT7FaNHV/lc3KJ535stRQa9zdmBwEXLlgCRQB4MUvsAxs+VZzBxjMWNwxhn7TAgLXOp3L6eJmBav5bt+n9BWUfkOUIDO/KExekbc
 hTSv4K6+
 SDaRzS2FHZBQx3ZSU26WXD2dZvQGuj8x9lsyJTLn/9tWXc+gS0ybxTvpUbifAoBFNCMens8rOIrzmoU4SuB/lNlBo24HhIDdw/aMkRRFAVt7+1WZdBNt6NDVDVcLRJQbltgoRM5PG0WFoJuKn1F4mM6J/9iGYpMQ5Y17ARJ9fATvAWwhyckWlw4kaCCBvca8+6+GrhTA3GFm+S3Kd7tCVNpKshdZzwrbXzBAfMYQsr63HB/MDi5ELBWKaI14Llxui7emqLNgIBR12ymlov1y8X/qi+qWd4FvYME9G4jZdee0f6ww0Xj3GIIV/cLoZ8udTiuue0Xr3IpPId29hAXiifMfEtSRmHQjgC5zCPkG6g3waf1sOhBOe3yqwJnSNRzOUOgKKNqowsQXg5VYPXkR5u2S2PPLeQl9fU1nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:56:20PM +0200, David Hildenbrand (Arm) wrote:
> On 8/27/26 10:28, Baolin Wang wrote:
> > 
> > 
> > On 8/26/26 8:24 PM, Yeoreum Yun wrote:
> >> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
> >> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> >> made by memalign().
> >>
> >> The underlying VMA may start at a different address from the aligned
> >> address returned by memalign(). Furthermore, a subsequent
> >> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> >> already set.
> >>
> >> This causes split_huge_page_test to fail because the check_huge_xxx()
> >> helpers incorrectly require the address returned by memalign() to
> >> match the VMA start address reported in /proc/self/smaps.
> >>
> >> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> >> /proc/self/smaps to detect huge pages.
> >>
> >> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> >> ---
> >>   tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++---------------
> >>   tools/testing/selftests/mm/vm_util.h |   1 +
> >>   2 files changed, 77 insertions(+), 54 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/
> >> mm/vm_util.c
> >> index 4821a3563036..1d0959b3b9e8 100644
> >> --- a/tools/testing/selftests/mm/vm_util.c
> >> +++ b/tools/testing/selftests/mm/vm_util.c
> >> @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern,
> >> char *buf, size_t len)
> >>       return entry;
> >>   }
> >>   -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
> >> -          uint64_t hpage_size)
> >> -{
> >> -    char buffer[MAX_LINE_LENGTH];
> >> -    uint64_t thp = -1;
> >> -    char *entry;
> >> -
> >> -    entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
> >> -    if (!entry)
> >> -        goto err_out;
> >> -
> >> -    if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
> >> -        ksft_exit_fail_msg("Reading smap error\n");
> >> -
> >> -err_out:
> >> -    return thp == (nr_hpages * (hpage_size >> 10));
> >> -}
> >> -
> >> -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
> >> -        uint64_t hpage_size)
> >> +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
> >> +                   void *addr, size_t len, int nr_hpages,
> >> +                   uint64_t hpage_size)
> >>   {
> >>       int order = 0, pagesize = getpagesize();
> >>       unsigned int nr_pages = hpage_size / pagesize;
> >>       int orders[MAX_NR_ORDERS], status;
> >> -    int pagemap_fd, kpageflags_fd;
> >>       bool ret = false;
> >>         if (!nr_pages)
> >> @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len,
> >> int nr_hpages,
> >>           ksft_exit_fail_msg("invalid order\n");
> >>         memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
> >> -    pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> >> -    if (pagemap_fd == -1)
> >> -        ksft_exit_fail_msg("read pagemap fail\n");
> >> -
> >> -    kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> >> -    if (kpageflags_fd == -1) {
> >> -        close(pagemap_fd);
> >> -        ksft_exit_fail_msg("read kpageflags fail\n");
> >> -    }
> >>         status = gather_folio_orders(addr, len, pagemap_fd,
> >>               kpageflags_fd, orders, MAX_NR_ORDERS);
> >> @@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_t len,
> >> int nr_hpages,
> >>           ret = true;
> >>     out:
> >> -    close(pagemap_fd);
> >> -    close(kpageflags_fd);
> >>       return ret;
> >>   }
> >>   -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t
> >> hpage_size)
> >> +enum check_huge_type {
> >> +    CHECK_HUGE_ANON,
> >> +    CHECK_HUGE_FILE,
> >> +    CHECK_HUGE_SHMEM,
> >> +};
> >> +
> >> +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
> >> +                 uint64_t hpage_size, enum check_huge_type type)
> > 
> > The original __check_pmd_huge() is only for PMD-sized large folios, but now it
> > not only checks PMD-sized large folios but also mTHP large folios, which I find
> > confusing. Please keep its original semantics, and only check PMD-sized large
> > folios.
> > 
> >>   {
> >> -    uint64_t pmd_pagesize = read_pmd_pagesize();
> >> +    int pagemap_fd, kpageflags_fd;
> >> +    uint64_t pmd_pagesize, granule;
> >> +    uint64_t categories, kpf;
> >> +    unsigned long pfn;
> >> +    bool check_large, huge_mapped;
> >> +    char *start = addr;
> >> +    char *end = start + len;
> >>   +    pmd_pagesize = read_pmd_pagesize();
> >>       if (!pmd_pagesize)
> >>           ksft_exit_fail_msg("reading PMD pagesize failed\n");
> >>   -    if (hpage_size == pmd_pagesize)
> >> -        return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> >> +    if (nr_hpages > 0) {
> >> +        check_large = true;
> >> +        granule = hpage_size;
> >> +    } else {
> >> +        check_large = false;
> >> +        granule = psize();
> >> +    }
> > 
> > This is incorrect for the mTHP large folio check. I already hit a selftest
> > failure. Please test your patches before sending them out.
> > 
> > [root@]./khugepaged -c 4 mthp_khugepaged:anon
> > TAP version 13
> > # Save THP and khugepaged settings... OK
> > 1..4
> > # Allocate huge page on fault... OK
> > # Split huge PMD on MADV_DONTNEED... OK
> > ok 1 allocate on fault and split
> > #
> > # Run test: collapse_full (mthp_khugepaged:anon)
> > # Collapse multiple fully populated PTE table.... OK
> > ok 2 collapse_full
> > #
> > # Run test: collapse_empty (mthp_khugepaged:anon)
> > # Do not collapse empty PTE table.... OK
> > ok 3 collapse_empty
> > #
> > # Run test: collapse_single_mthp (mthp_khugepaged:anon)
> > # Collapse PTE table with half PTE entries present.... Fail
> > not ok 4 collapse_single_mthp
> > # Totals: pass:3 fail:1 xfail:0 xpass:0 skip:0 error:0
> 
> FWIW, the CI flags this as well:
> 
> https://github.com/linux-mm/linux-mm/actions/runs/33028595020/job/98375618491

Yeap. I've overlooked that case and here is the fix:
  - https://lore.kernel.org/all/apAVAvfxZSeEvf50@e129823.arm.com/
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

