Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9DCCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 08:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360C86B0304; Sat,  9 May 2026 04:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA636B0305; Sat,  9 May 2026 04:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9956B0306; Sat,  9 May 2026 04:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4B36B0304
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:25:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F39D16057E
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:25:57 +0000 (UTC)
X-FDA: 84747198354.27.6632217
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A50B20007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:25:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pqfGcYRm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778315155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23Ic1o2sOTP5Fai3/nRGKI6fPXu9iGOPioMFP3I9tec=;
	b=FDHIXPM3kpcyq99ocLtRZidVLaQuQUYmw6xakReStaBOf7BFsmiZePCsfjgbZulwWbyqzp
	wBFa2FWEOoNFHx+RxDpQFnJBsQQPEY05VlQuaJGRj4kqpKaTEI3IcCLGngyyEZBsp6eH1X
	r7iCZHaCFQSr5s957vovfMBzvPEQyvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778315155; a=rsa-sha256;
	cv=none;
	b=zVIsmzTPMg5hDx1flZRM3484g1NdE1LElT3IkH3jpwA8lVcK+bo2Sv7JOiSp+jOcKw/2Al
	KuYaRgaj9tqfBz37UDkwkXHHzRWTAMIzkdcZFkPdi9DSYtjuo44+7UxChVRnhTqsZWLf8M
	8w7Ib1N6rUPxg693ocl4YX/VHXgSGFw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pqfGcYRm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778315153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23Ic1o2sOTP5Fai3/nRGKI6fPXu9iGOPioMFP3I9tec=;
	b=pqfGcYRmjUhP7dZH1nWFpE84IGI3gxLxuAq5jBuN1j5p/4J416zvXoAE7UkrmSaaNo+H6l
	XmCO/5oJf5wJitYqCGajwYS2Lecyp4K+u3cNJ76zZPvY2CxYDgJSpPTEJfAfwos9uxyPbr
	PbJh/lORwpnbNjeSBWs24b98EW34pPE=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	npache@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	lance.yang@linux.dev,
	baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	liam@infradead.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
Date: Sat,  9 May 2026 16:25:35 +0800
Message-Id: <20260509082535.16777-1-lance.yang@linux.dev>
In-Reply-To: <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
References: <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A50B20007
X-Rspamd-Server: rspam04
X-Stat-Signature: f1ip66b55s541ftcfs37wjajza4fn8sz
X-HE-Tag: 1778315155-854238
X-HE-Meta: U2FsdGVkX1/wIhUodiX3lfbyZLHjwfTQCP+OWJh469GB3i6RT/rwzFG5Be30PFGnVOiTG9SoXhlEIVm/llU5DWwUNBbKLrb2KK+dmdYSsYp//QuLSDQeiiMkx7uNiSRoZCBfFKgknUDo9yUMvkIrMwc8jbyogG8NROu2DhvTVf10xqiKSt0FJXWSvn3eBDeTlv0g5HK1njE7EGguc6v0vsiiLVREGzxrBEZOa+qC42tJqSU6gFmjSgCFK8utg8J/35vsqotrSWbZST5/3EenFKQjMcTdBpp665x9XTUSXHpIMPljcK4pGHkQueud0XAStSvbPVcTzIn88RrOM6ZDk7N2rxUls3qIrqKcMlDdDsZg/ejVzMSE0SJgtVRZJQ19NWnK391qp9Wz7BPUhqjfUNL8K6TdaLR0xMWOXJGfUAYtYdgrUeWlpdyZzxCXZ2q+fZpNHjl3ABdHtCR6k1r3Bww351jn9uo1LYpflliQYN58dAWCC4eWerg+M4QRmqFs2WZhU3bJ2BAh3BbF37RN2AQhIjLI6h4BXaOt5YME38Kq3WUfVGKICebGjRNSTKe1ZnZkSf6pl/VD5qEqV3RskUBApG6FhqwbCYAfRgnL09sVvP4/Fof7OLNEdkDWvJM01DRxfz5FoDuOHW6BqguH9SMaUOnucq067wIONzqq1rq2VPSpsra8zm1QbfBonWgLlr7sBw4QXOKsNUAzKUF20Es6Ect6M85xIygeEGMZkJXFX5bvZAkozgwbU0NIrDk+7kKav5exn1twI3j+LBjjYtBlUaoJJ/6nIsAj+PwsOjx6O6T9em0EETk6666+Dd42GrDpL1arDfOiOtqbjTTSFz6/ovtZHavMIoQtXsayHIink0rICbJLhYxJcavCSgdbPOlDr3RteGwiCQeM6bmTIp+wxPO9vnI7+Fv1Og7Wn8jU+HrGsd8E+jd1fL7k4/aTsgYoj+oEmaMK7Siar14
 P4/BRnOf
 zldvSfwjzdUqOXiw1OeLbDEx0LQ9n0+uVxOaBsU31U//WXBISJS+6e0ZbH7XcTl1l5iFS5MtJ0CvaKVL+k/nw1655loD+OTKNZten6bS/mHjZZk803Xd2JqK/iX5Trq65d4ampH72wXpb9/fwwmBKCw7kPKaUOO7JRdaaSwhrRxziZs7njUAl/hN67CdqRWoZfQvAo29mTMFdPl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 08, 2026 at 11:32:09PM +0200, David Hildenbrand (Arm) wrote:
>On 5/8/26 19:05, Nico Pache wrote:
>> Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>> when splitting isolated thp"), splitting an anonymous THP remaps all
>> zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>> This flag is set unconditionally for every anonymous folio split,
>> including splits triggered by KSM.
>
>And even when the underused scanner is effectively disabled on a system. Hm.
>
>I don't quite like that we scan for zeropages when nobody even requested us to
>split because of zeropages.
>
>I can see why we would want to scan for zeropages in a setup where the underused
>scanner is active, even when the split was triggered by someone/something else
>(below).
>
>[...]
>
>>  /**
>> @@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned int new_order,
>>  		struct page *split_at, struct list_head *list)
>>  {
>>  	return __folio_split(folio, new_order, split_at, &folio->page, list,
>> -			     SPLIT_TYPE_NON_UNIFORM);
>> +			     SPLIT_TYPE_NON_UNIFORM, false);
>> +}
>> +
>> +int folio_split_underused(struct folio *folio)
>> +{
>> +	return __folio_split(folio, 0, &folio->page, &folio->page,
>> +			     NULL, SPLIT_TYPE_NON_UNIFORM, true);
>>  }
>>  
>>  /**
>> @@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>>  		}
>>  		if (!folio_trylock(folio))
>>  			goto requeue;
>> -		if (!split_folio(folio)) {
>> +		if (!folio_split_underused(folio)) {
>>  			did_split = true;
>>  			if (underused)
>>  				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
>
>In general, this looks clean.
>
>But imagine the following: someone splits the THP for another reason: for
>example, because migration is unable to allocate a 2M THP, or because we have to
>split on swapout etc.
>
>Not freeing the zero-filled pages means that these pages cannot be reclaimed
>anymore easily. We split a possibly underused THP but didn't free the memory.
>
>The only way to free the memory would be to wait for another collapse, and then
>have the new THP be detected as underused.
>
>Hm.
>
>(1) As you say, the alternative is to let KSM say that it wants to handle the
>zero-filled pages itself. I'm not a the biggest fan of that approach. We still
>have two mechanisms interacting to some degree.
>
>(2) Another approach is to just let KSM handle this in VMAs that are marked as
>mergable while KSM is active. That is, we check for VM_MERGABLE and ksm_run ==
>KSM_RUN_MERGE in try_to_map_unused_to_zeropage() to just let KSM do its thing.
>
>That really just stops both mechanisms from interacting.
>
>(3) Yet another approach I could think of (in general) is to disable the
>underused handling in a system where the underused splitting is entirely disabled.
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index e9d499da0ac7..5eca99271957 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -82,6 +82,14 @@ unsigned long huge_anon_orders_madvise __read_mostly;
> unsigned long huge_anon_orders_inherit __read_mostly;
> static bool anon_orders_configured __initdata;
>
>+static bool thp_underused_split_active(void)
>+{
>+       if (!split_underused_thp)
>+               return false;
>+
>+       return khugepaged_max_ptes_none != HPAGE_PMD_NR - 1;
>+}
>+
> static inline bool file_thp_enabled(struct vm_area_struct *vma)
> {
>        struct inode *inode;
>@@ -4188,7 +4196,8 @@ static int __folio_split(struct folio *folio, unsigned int
>new_order,
>        if (nr_shmem_dropped)
>                shmem_uncharge(mapping->host, nr_shmem_dropped);
>
>-       if (!ret && is_anon && !folio_is_device_private(folio))
>+       if (!ret && is_anon && !folio_is_device_private(folio) &&
>+           thp_underused_split_active())
>                ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>
>        remap_page(folio, 1 << old_order, ttu_flags);
>@@ -4497,7 +4506,7 @@ static bool thp_underused(struct folio *folio)
>        int num_zero_pages = 0, num_filled_pages = 0;
>        int i;
>
>-       if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>+       if (!thp_underused_split_active())
>                return false;
>
>        if (folio_contain_hwpoisoned_page(folio))
>
>
>
>I tend to like (2), and maybe (3) on top. Opinions?

Cool! (2) + (3) sounds good to me ;)

For VM_MERGEABLE VMAs while KSM is running, makes sense to let KSM handle
zero-filled pages itself. Without (2), the split path may remap many
zero-filled subpages to the shared zeropage before KSM gets to them ...
With (2), those subpages remain normal anon pages for KSM to process
later, according to its own settings, such as use_zero_pages, and scan
pacing, such as pages_to_scan.

For other VMAs, keeping the opportunistic shared zeropage remap seems
useful while split_underused_thp is active. Once the THP is split, the
underused shrinker cannot find it anymore :)

And, yes, if split_underused_thp is disabled, generic THP splits should
not to do this extra scan/remap work; just leave those zero-filled pages
alone, IMHO :D

Cheers, Lance

