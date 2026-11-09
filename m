Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9E3606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TRmNFR5N
Received: by kanga.kvack.org (Postfix)
	id 407EA6B00EF; Mon,  9 Nov 2026 06:33:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8216B05B1; Mon,  9 Nov 2026 06:33:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5676B05B3; Mon,  9 Nov 2026 06:33:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8026B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:33:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 810C016063F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:33:50 +0000 (UTC)
X-FDA: 85415371020.11.C3CDE41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B91A214000C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:33:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRmNFR5N;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794224028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkT4fe5CJwp7XAtvSBn0G3WSLvL/1VCPfATmUEKUqdc=;
	b=WX4u6I1RliWFbsEb9NLvljUIEY0brb35XY+fyZfqnoE+oA1sUiYvSjF2cFXrhRfOXBtGYD
	cu+KePPZmAIiHI0CfXt2K+AcpTxS/WEtVLnm0HgWfrYlpuE3WW7j9ePi5EdN5bD/6OXTNI
	2eW8CSnfvUtdeVi03a3kkANCEBrlWnw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TRmNFR5N;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794224028;
	b=divivBW6L5W+8C5BHmrqskaOU3SWlJs4q2cr8pNXpW13/PrkHjrgYlHhL8gylgSNfp2vQR
	07d8LFv8BtbBrKtPXvrkHx/lFhmQz4AfQi9VB8UieKuUksBbC2/hM0cXBgZs/dpCkcvON7
	+4yte0lw9bCeXHeXa0w4WaMribSkkdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EDD540BE1;
	Mon,  9 Nov 2026 11:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F0D1F0089F;
	Mon,  9 Nov 2026 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794224027;
	bh=gkT4fe5CJwp7XAtvSBn0G3WSLvL/1VCPfATmUEKUqdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TRmNFR5NGdiaeT/EJyT5AIJBFybSfvC+RFqnrxtntPEiIYgXBWWSdY0ZXLbH3u8k2
	 LM9cUR88CfTS0kd+K+MIADUPeNj8ViurK4Xvt/R0YEXGxmr35td8HjnHvSc9daasPB
	 vfDsmiS6OXLgcp1GMOQmO9CmLfTBry1jFzABLuITSP2N3h7PBqD8u3RyPLCK7+YvyC
	 0pOBDNKL9jZLrNm1ICAkZBYP+bg+uv6SyGJ1dDfjvtxthMX9sOaRVOsNhCJMWcTuED
	 aMNRMX06EaGfcsXVT0f+LOkJeo1AHoXwfcNSR6KpeG3/S2XKWkvDw8G4wNk6PeJ3Hs
	 ywEmGQB1o6sqg==
Date: Mon, 9 Nov 2026 13:33:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Balbir Singh <balbirs@nvidia.com>, muchun.song@linux.dev,
	osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
	apopple@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap
 init
Message-ID: <avGvlDENwtgUWv-4@kernel.org>
References: <20261105120615.16817-1-lizhe.67@bytedance.com>
 <20261105120615.16817-3-lizhe.67@bytedance.com>
 <au2qhlsxQt3SRwIu@parvat>
 <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com>
 <3e5a9f27-ea35-4557-95d1-70ce359e4c92@bytedance.com>
 <avGVNISvj-v8IN3g@kernel.org>
 <ea9b76c1-ced7-4ef7-a428-7fb3db5c7f4c@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea9b76c1-ced7-4ef7-a428-7fb3db5c7f4c@bytedance.com>
X-Stat-Signature: 6635j88xrcrh6pgg6erudhftqgq4jmqk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B91A214000C
X-HE-Tag: 1794224028-659385
X-HE-Meta: U2FsdGVkX1+n4A+RhlcxZ0Mz6OIEJGbFo2+yV+VWMFP08vqJBppERMzKNiAr9a5VF6z2O1M7AwsPO8vnEQ2dDvyQTNop4yl52DCw2nwQ06Q8dsmakgfJ0Lnx8Yfd6pH9ERzkjuIu64GwRvMLBPQQUl0RmEhIETCReTRWBDXX9g2Qc69cMVAytGYlaxnamgV2NT3kdc2aiTdqO4TD9sqBSsrfGRHWPefnSESuA8TOmbsx35CYbvIsLhHRHBwjbgzZqFFFBlUKtAL+cs1L35DA4cLrQZi5KrcPCt0/K8U7Enux3x7Wbn0k57dTj6gbK7Z3zslFHaw52nJLsS5LNeCy13y1boHnKUhVeVgPh8pPigR3CZoXm0SCYOuxaCU2zqTb6LXWzJiDPlx7bJKZmBFsgIKqnbxhuPdcC/ORIOu9oi7FeWlFY1gObtHEtbQAxzdEBRKiJOCN89gEXi4v/7AVPfd4nctF0ecf0A9CN3SXYnZ6g58OmLhb2aaowY9gt88n3uPbHGmp78iWZBozqzlYAOttSq3ohHcuszle9+zVEE1TLqS8wOs3JJuXsv0FlL3rb7Hqekgu6wzjfnMc1v/APjAiMNBhADkjugEbvGdAJjs5KqkNbjcLPZCQ24+XUNy21nDSfNGglZris6/LFaGRIMu6K6P+ZF3dSlTdDVL8OqWe13UnR2ogR3Tc4Kyb0fBe3ceOHo6QOvczdulsVXHV/3SjGrdyk+VJz/Jtjj+DRBSwd44NUbyDWIVD6Cd0kWxSBllP0+Jhf2LcElTBoFbqKFHa53Iqu0RF/3EdP7oB256OQhr2JsRHbQZQVnrlAZ81YEdMguS8AKl9CBFNm5aH7ipA7pMNfktW/+2GM09Swxky62x6665rU4jJ1QyJCNlSfKx+dAQu7lysueu7JX8RSlgJD14XrsluzPL3D9GQZ1ATKMqzNmJdmd7B7kh715R6vf60l551twgxQZYOyhQ
 DfhNFfLW
 jmysn2mFYTBYTJc/mjAhEvRBUtm/gCVVK/tzeWHq891mrzwMrPBIRlVrzpQ16kquLYisbeMmmbngcCK1ej9bTOUxxJhKZc17t8/3O62jBWZyfNuG4jv+pmUqjMl6L8EkBkKa8YXpTxfxtAMcjexsCWCcO3Z4tPnEBPfQhvLEOY4ugl5cCPstLafKghAEdWY3ASnemkHjCf1HT5rDlKl/sjN/q084Y0CxmPchNUEh5bq5M9GqX+O8YIw7qHGhIgFVQLRQurDjO/hIcfn1RuY6xDXlKVRw/KGiGeF1G1Bz7piwUTO/Ylk5hlj9bSwkII0HUr97YvRWb8m3Un4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 05:52:19PM +0800, Li Zhe wrote:
> On 11/9/26 5:41 PM, Mike Rapoport wrote:
> > Hi,
> >
> > On Mon, Nov 09, 2026 at 05:22:24PM +0800, Li Zhe wrote:
> >> On 11/9/26 11:01 AM, Li Zhe wrote:
> >>> On 11/6/26 6:23 PM, Balbir Singh wrote:
> >>>> On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
> >>>>> Boot-time HugeTLB allocation has to initialize tail struct pages itself
> >>>>> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
> >>>>> gigantic pages, this can cover a large number of tail pages. Most state
> >>>>> installed by __init_single_page() and prep_compound_tail() is identical
> >>>>> for every tail page in the same huge page; only PFN-dependent fields
> >>>>> need refreshing.
> >>>>>
> >>>>> Initialize the first tail page normally, copy it into a local template,
> >>>>> then initialize the remaining tails from that template with
> >>>>> memmap_init_page_from_template().  This avoids repeatedly doing the
> >>>>> full
> >>>>> __init_single_page() and prep_compound_tail() sequence for state
> >>>>> that is
> >>>>> identical across tail pages in the same huge page.
> >>>>>
> >>>>> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
> >>>>> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
> >>>>> initialization time improved by 36.43%, measured with a temporary
> >>>>> jiffies-based printk modeled after the existing timing in
> >>>>> memmap_init_zone_device():
> >>>>>
> >>>>>     base:             318.4 ms
> >>>>>     with this patch:  202.4 ms
> >>>>>
> >>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> >>>>> ---
> >>>>>    mm/hugetlb.c | 23 ++++++++++++++++++-----
> >>>>>    1 file changed, 18 insertions(+), 5 deletions(-)
> >>>>>
> >>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >>>>> index da5d04edf7c1..987f16a5ea27 100644
> >>>>> --- a/mm/hugetlb.c
> >>>>> +++ b/mm/hugetlb.c
> >>>>> @@ -3219,19 +3219,32 @@ static void __init
> >>>>> hugetlb_folio_init_tail_vmemmap(struct folio *folio,
> >>>>>        enum zone_type zone = folio_zonenum(folio);
> >>>>>        int nid = folio_nid(folio);
> >>>>>        struct page *page = folio_page(folio, start_page_number);
> >>>>> +    struct page template;
> >>>>>        unsigned long head_pfn = folio_pfn(folio);
> >>>>>        unsigned long pfn, end_pfn = head_pfn + end_page_number;
> >>>>>        unsigned int order = huge_page_order(h);
> >>>>>    +    if (start_page_number >= end_page_number)
> >>>>> +        return;
> >>>>> +
> >>>> Can this actually happen?
> >>>
> >>> No, current callers always pass a non-empty range. I kept this to
> >>> preserve the old for-loop no-op semantics for an empty range, but it is
> >>> not needed here. I will remove it in v2.
> >>
> >> I need to correct this. A local Sashiko run pointed out that the bootmem
> >> fallback caller can pass an empty range on SuperH.
> >>
> >> SuperH supports a 64M HugeTLB page size, and with 64K base pages
> >> pages_per_huge_page(h) is 1024. HUGETLB_VMEMMAP_RESERVE_PAGES is
> >> PAGE_SIZE / sizeof(struct page), which can also be 1024 or larger on a
> >> 32-bit SuperH configuration.
> > If the only difference is unnecessary initialization of the template on SuperH,
> > we don't care and you can drop that if.
> 
> It is not only initializing the local template. The code first
> initializes one page with __init_single_page(), prep_compound_tail(),
> and set_page_count(), and then copies that page into the template.
> 
> So if start_page_number == end_page_number == pages_per_huge_page(h),
> the old loop is a no-op, but without the check the new code would update
> folio_page(folio, start_page_number), which is outside the HugeTLB
> folio.

A recent patch to arch/sh indicated that hugetlb is never used on sh:

https://lore.kernel.org/linux-mm/auJI2blzfpFD9yLe@kernel.org/

And it seems none of upstream sh defconfigs can hit it.
 
> Thanks,
> Zhe
> 
> >   
> >> In that case the old for loop is a no-op. So I will keep the empty-range
> >> check in v2, before creating the seed template.
> >>
> >> Thanks,
> >> Zhe
> 

-- 
Sincerely yours,
Mike.

