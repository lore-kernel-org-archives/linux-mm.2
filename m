Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD7CCD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40E56B0088; Fri, 12 Jun 2026 11:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18DC6B008C; Fri, 12 Jun 2026 11:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54B06B0099; Fri, 12 Jun 2026 11:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3C476B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:06:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 633F68B31F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:06:14 +0000 (UTC)
X-FDA: 84871586268.28.E50F3BF
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C4C0A002A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:06:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K1DEFj4I;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYbxVxLJkPeVlJemR6VoxtOTsg3NPDGQmg7k2Z6F9O8=;
	b=sYkz4mjneHuavZV1POpr/gZVohZgaHp4H5+j6ZOxy+TyqdLT9QABwpG35jglLxN8cB1+KE
	CEM1hXt1Pjod1oWJP3ajV4DPVF2orvdA237xuUGr6LJBa3rsKpe/USp6qzQYWpxqYNQDK4
	nar2xkPvDuVIhUmTz5oY2rEJdV8j3cE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K1DEFj4I;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781276772;
	b=Jgl/CV8EDSATF+vDvOfJSAjvYqk6je0uae/XN+hu0lWacf0Or9ACzcVC2y1oYM7SqJcJVe
	0dXSKkkCuY1WH1vN08M2cGUmDcG/Ny4scdJbfd6MaYcNwQJOVTBCLXqfBTABaaWeJgs2+8
	MOV8m8n7bwuUkaHSSinHFxywIkThCSU=
Message-ID: <e99fcf49-c01b-45a1-aecd-c4406ffdf5dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781276769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYbxVxLJkPeVlJemR6VoxtOTsg3NPDGQmg7k2Z6F9O8=;
	b=K1DEFj4I8vun/tIJGxrSH1strQ/FHcGgv+bYplJ7fQHx1/imO6zavfvp5urYX2DRyM+yW/
	AKGuWIk3u6++W+Eu7SJMHGk996Yv+qt4ZTK82bfqRs/B7yWOdDqPgxe5AuiSxm3ryjkjNR
	i5SeaBHFvZnlU/AfzALkg32L1lbCgnM=
Date: Fri, 12 Jun 2026 16:05:57 +0100
MIME-Version: 1.0
Subject: Re: [v2 11/16] mm: handle PMD swap entries in non-present PMD walkers
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 ying.huang@linux.alibaba.com, baoquan.he@linux.dev, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 liam@infradead.org, ryan.roberts@arm.com, vbabka@kernel.org,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, linux-mm@kvack.org
References: <20260602142537.198755-12-usama.arif@linux.dev>
 <20260612064550.54968-1-lance.yang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260612064550.54968-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C4C0A002A
X-Stat-Signature: 65iaq79ebu783m51fh59q6m1js1wqcho
X-Rspam-User: 
X-HE-Tag: 1781276772-913375
X-HE-Meta: U2FsdGVkX18HpuUHMYfGM+QSIk33NDH+2K5PCGzD1+Qs0RmPdiQdihv7SjiG4aIe9xbSlKmNo2GIpHLqMJhv5p80wiFZhRqqjxswzOL3BBYdTeqI4aRFZ2/CmnBItxHS0x9UFSccMUShNeELq1HVKDHtwqiT8+QYmk+P3o3UuNua3+5K1j12JyBNkJrnz5RqMs8jw0X3SYXEOa+u8L2IZYzXmOO5FUIhTBeig4CdDzhkwZ1nmTIEtCUGmjFivX8wmBz55RYs/QYV4twV2jdCdmGEhglnBsnbNBhe0wtNEwAiN29SljCn1hoBOSWwePgKrH6urvXaUNxh5ytihHLRUgzKUwKbfeJh6jntqHL11Y5NPWjMf+GsmwmyfF8M0V94cQz1mDdvSs2dy81daoX/78Q36esFIz4MAW+OwQshiqbbhApkqik4U/Ayq5+HoiFMxSr03WUieEZmnnpkVa55nU2GoZEbjyO+YHDgqvoSEt8BpNVgvUqChZq3/KgJSQECnfAtMrNoodpdozmFOxuK66Sbfi2H2/TfTCF2wcHdbbpag1JeSZe8ADQ8Ux0A549HxmMl482+2Y2FVdjayrX9FpOaC828EgQxZEiqzk4uYqPOBXpiaxUcyIcY6j7cjeXuTKixqJDrqjB1WX9qT8KW6yZKrt8M9osq+Y2G3ghYzXhjmQHrR6Ti9PndVEDft4IFgqQ6pdtpXh4Dp/76ItvBb/mwk4fm3d4AlfLKNL6IyX0hact9FXwJsB4Ztij7RF6MIJVpuvYttCTQUDIEid+413XgsceM7YXzw5F4ZquezWTTnMH4E8EX25Ij4gX0O+jwYDP/1FQFSGboCVx/aQwM1S33BfWDEDBi0Rzq59GKdUmqc1aIdOmBcRE74YVcl/Xl4zJvxqonHu6KKixF/6o864F+6YX5nKGBzRBvQqruG3n5dSomcu9VfAFYcsL2zEJ5dXauVlTsxiUcwJ+F8pg
 YL3wAAN9
 br6D3/YwX+G3VdcNZa0f/2myiHF5FlmB6DJnbq2SxvRxufiEEO3hkSMzPQ6vuHBAbcMvdqF0V9OXHk6Fwo+ZsjruyiKd4rfXkld49aYakkWqH2JZfYHQqZ7vzfE1HyEgcHWUNkjc/VrnvReJlhLQ0naO9nloMVKxuP/Dj94LtMUnvtP1go2Tv9NtwDn+eMS4P6tRrf1tKC8JrbtgoUs0VXsGp9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/06/2026 07:45, Lance Yang wrote:
> +Cc linux-mm
> 
> Please Cc linux-mm next time. Pretty clearly MM work ...

Yes, thanks for this! I forgot, will be careful in v3.

> 
> On Tue, Jun 02, 2026 at 07:24:19AM -0700, Usama Arif wrote:
> [...]
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index e5d13eea9234..3fee8a7b9d9d 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -172,7 +172,19 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>
>> 	ptl = pmd_trans_huge_lock(pmd, vma);
>> 	if (ptl) {
>> -		memset(vec, 1, nr);
>> +		if (pmd_present(*pmd)) {
>> +			memset(vec, 1, nr);
>> +		} else {
>> +			/*
>> +			 * Non-present PMD: migration, device-private, or PMD
>> +			 * swap entry. Route through mincore_swap() the same way
>> +			 * the PTE path does -- the swap entry covers all 512
>> +			 * slots, so the whole vec gets the same answer.
>> +			 */
>> +			softleaf_t entry = softleaf_from_pmd(*pmd);
>> +
>> +			memset(vec, mincore_swap(entry, false), nr);
> 
> Looks buggy ...
> 
> That assumes one swap-cache lookup is enough for whole PMD-sized range.
> I don't think that always holds ...
> 
> See do_huge_pmd_swap_page():
> 
> ---8<---
> 	folio = swap_cache_get_folio(swp_entry);
> [...]
> 	/*
> 	 * Folio should be PMD-sized; if not (e.g. split in swap cache),
> 	 * split the PMD swap entry and retry at PTE level.
> 	 */
> 	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
> 		folio_unlock(folio);
> 		folio_put(folio);
> 		goto split_fallback;
> 	}
> ---
> 
> it handles the case where swap_cache_get_folio() returns a folio that
> is no longer PMD-sized. E.g. because it was split in the swap cache
> while the PMD swap entry was installed. Then it split the PMD swap entry
> and retries at PTE level :)
> 
> unuse_pmd_entry() has the same fallback. Can mincore hit that case?
> 
> Maybe the comment right above should say something like:
> 
> "
> One lookup is enough for a PMD-sized swapcache folio. If the swapcache
> was split, check the per-page swap slots.
> "
> 
> Hopefully, I'm not missing something here :D
> 
> Cheers, Lance

Good catch! Thanks for pointing this out.

I think the below diff over this commit should be ok. I will add
it to the next revision. Its slower, but it shouldn't be an issue
as its just mincore:


diff --git a/mm/mincore.c b/mm/mincore.c
index 3fee8a7b9d9d..975513fff336 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -175,15 +175,42 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
                if (pmd_present(*pmd)) {
                        memset(vec, 1, nr);
                } else {
-                       /*
-                        * Non-present PMD: migration, device-private, or PMD
-                        * swap entry. Route through mincore_swap() the same way
-                        * the PTE path does -- the swap entry covers all 512
-                        * slots, so the whole vec gets the same answer.
-                        */
                        softleaf_t entry = softleaf_from_pmd(*pmd);
 
-                       memset(vec, mincore_swap(entry, false), nr);
+                       /*
+                        * Non-present PMD: migration, device-private, or
+                        * PMD swap entry. Migration / device-private cover
+                        * the whole PMD range with a single answer.
+                        */
+                       if (!softleaf_is_swap(entry)) {
+                               memset(vec, mincore_swap(entry, false), nr);
+                       } else {
+                               struct folio *folio = swap_cache_get_folio(entry);
+
+                               /*
+                                * One lookup is enough for a PMD-sized
+                                * swapcache folio. If the swapcache was split
+                                * (e.g. by deferred_split_scan() or
+                                * memory_failure()) while the PMD swap entry
+                                * was installed, check the per-page swap slots.
+                                */
+                               if (folio && folio_nr_pages(folio) == HPAGE_PMD_NR) {
+                                       memset(vec, folio_test_uptodate(folio), nr);
+                                       folio_put(folio);
+                               } else {
+                                       unsigned long haddr = addr & HPAGE_PMD_MASK;
+                                       pgoff_t off = swp_offset(entry) +
+                                               ((addr - haddr) >> PAGE_SHIFT);
+
+                                       if (folio)
+                                               folio_put(folio);
+                                       for (i = 0; i < nr; i++)
+                                               vec[i] = mincore_swap(
+                                                       swp_entry(swp_type(entry),
+                                                                 off + i),
+                                                       false);
+                               }
+                       }
                }
                spin_unlock(ptl);
                goto out;


