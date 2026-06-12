Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D487FCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBFF6B0092; Fri, 12 Jun 2026 11:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2DC6B0093; Fri, 12 Jun 2026 11:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10FBE6B0095; Fri, 12 Jun 2026 11:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 007A96B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:21:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94D54A015A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:21:53 +0000 (UTC)
X-FDA: 84871625706.24.9515C20
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8248B4001B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:21:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nnd7OEnc;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781277711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CP/ACqUrsN+vZNBxbVQZ0F5oAZ6jzKbJcdO1MIKShNA=;
	b=M2t/5bc01VidPmj06Hwdff4ealkB1O4W5VsUapFXyO+1j+wHoxR188xn3e36OuWB4Bwtfb
	WapF/L3vLrYHOPiRAwRmL4sbZaOH7zqvjyfFBojjoHG1v6h6RnhvWOR0CEuNrU0kJqmyhF
	qdwhoM2OAJJByxNGzh+lp3I5madOK0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781277711;
	b=DtVyoc6X+iWOytbNZTim2X+ZeB+Vnp34w4tmL2CnxkSthJr+R21P3RKRONsa9qdJ9d+T0W
	WPiXTknby14QAiosEw2GVE8fB4uTjYTkYXYcl7EOf5MQob+xkox2gbUgLcOlHOzuRdm0ZK
	6J6GXXFU2HIl49jiX7KYtvme85AlQW4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nnd7OEnc;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c25fba1a-97fa-4d06-a129-2d0949eac95b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781277707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CP/ACqUrsN+vZNBxbVQZ0F5oAZ6jzKbJcdO1MIKShNA=;
	b=nnd7OEnc1hRa7QOfAG9NJnAYLlCmiR8N8ms8Wpwg49RKxp2/4Ln9J5XO5hwDz0UkgmEWdj
	qFGtJxZhvPvHbVoeE45Ihef4/N9pPVDZyAmWpKCGY6hcBubKQz/qRnhLIgF0wRjcSCAoaG
	53S9KtpP4EctX/kY5Ny+HGKFwvGDc4Q=
Date: Fri, 12 Jun 2026 23:21:22 +0800
MIME-Version: 1.0
Subject: Re: [v2 11/16] mm: handle PMD swap entries in non-present PMD walkers
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>
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
 <e99fcf49-c01b-45a1-aecd-c4406ffdf5dc@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <e99fcf49-c01b-45a1-aecd-c4406ffdf5dc@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8248B4001B
X-Rspam-User: 
X-Stat-Signature: srk6mngqkwtdb8icn6sy5gz4sku6drqu
X-Rspamd-Server: rspam08
X-HE-Tag: 1781277711-602637
X-HE-Meta: U2FsdGVkX19VqjGRGW6Ans8N2RiBpPkiDpbIJ+8aFZ0KWBFVCwY4eWDKArZSSA0ChxbeTGHqEbbQSkxMnmMwqDzoWGKu1yPfT69+UQ1lrPc/athaMYEkdcJEHML1RpyK+HlBpsEwgc8yWHd6dSrH5LwouKnCU3KiG2NzDKqYAX+3gEgrayEXoRLRVdDyBUMPPoBHSJJ7GyLu3gcBxqSDUiLp1X2NU/hzfv90BuRV2+z2zp6vV1U6uHiN8L5Nc+t0uL5ZQML8Il5PMa1lmicp2mbMETsfQJYQJjJYRmXIj2lWzXCwby3ejBY1GKaXF7C0IhjCaGB/awY8dBLXGFuofZkHAAICBCUS0Xkj7VgKSNVIVn8fFmTOx/z/g9wxm2rZ0W5pc2nlWtpM7iV8XKFRhc59HINf38iFi2zTSw8Pkn6IyofwqHG4pi4VnvPnu/UYp0r/tlYRZBdWsoHaPm0BRA+VZeSx/dbAj7QjkXt55xKzdNuYbsy9WZdsT1HIafT8+Qk9aYhlX0ebUVMkLFaDNbosCXmEomSYMMRQdEvz+YfZu2PTGSf0q3ZMz5tWWkjXGgiMkgj95XClMntdIv1ai1uZ2c2Ada4rNOK2p1BD42Rp5/liI3xZJ19GTW/0AqxTDetQOz7YCrIVDMgcfpgVYiWEV4SwrVagXeEdfMBIe/X4P95NIvyjB7uJg+5u1refmVNTC0Sfse3ta8DI0/MmQeGFyA6htV547Tb6fci/FE+T+ESPjoOtZ6DawiQx1mWGmRPJIUreLVgDB+P9ISzALc5bbzsVRaBW8gepoGyCFJUvLX9SBoN4JwjiXrPNRESCWhFV6fCBNOqXs//AvEFv/I3DNClIZyO0xjD00552C+mwX2M9zB7q7/SSJoCgm9ZlSeBEVr2pmXGf6mxYADraMovLnB/qONzxXR6S5kFyy+nOyHnNVFeOEQkyAtgjx0B/NLhZ3Y39Gn9xEutVixt
 N6smnBSx
 ZmmOOqPSPElkdY/pIZkVGVVhT/jzfJ4V5D7xI4SkBpOkaDvjzATk+GLUEJASVqmMo40BczyY892wtaS5CAXp9+9pfe+FrJJ3wA34GOIHoih6j2pv1cjuNkK1gBH/B0Tse2S6EuAN7yr77dEf7Hz0zgwz+L2Dk5Sy0BJx11w7urqON99/zlqAyC9L6WfpvCRVhxoFIOY7RrLC+EFAMryc1j3jFOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/12 23:05, Usama Arif wrote:
> 
> 
> On 12/06/2026 07:45, Lance Yang wrote:
>> +Cc linux-mm
>>
>> Please Cc linux-mm next time. Pretty clearly MM work ...
> 
> Yes, thanks for this! I forgot, will be careful in v3.

Cool.

>>
>> On Tue, Jun 02, 2026 at 07:24:19AM -0700, Usama Arif wrote:
>> [...]
>>> diff --git a/mm/mincore.c b/mm/mincore.c
>>> index e5d13eea9234..3fee8a7b9d9d 100644
>>> --- a/mm/mincore.c
>>> +++ b/mm/mincore.c
>>> @@ -172,7 +172,19 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>
>>> 	ptl = pmd_trans_huge_lock(pmd, vma);
>>> 	if (ptl) {
>>> -		memset(vec, 1, nr);
>>> +		if (pmd_present(*pmd)) {
>>> +			memset(vec, 1, nr);
>>> +		} else {
>>> +			/*
>>> +			 * Non-present PMD: migration, device-private, or PMD
>>> +			 * swap entry. Route through mincore_swap() the same way
>>> +			 * the PTE path does -- the swap entry covers all 512
>>> +			 * slots, so the whole vec gets the same answer.
>>> +			 */
>>> +			softleaf_t entry = softleaf_from_pmd(*pmd);
>>> +
>>> +			memset(vec, mincore_swap(entry, false), nr);
>>
>> Looks buggy ...
>>
>> That assumes one swap-cache lookup is enough for whole PMD-sized range.
>> I don't think that always holds ...
>>
>> See do_huge_pmd_swap_page():
>>
>> ---8<---
>> 	folio = swap_cache_get_folio(swp_entry);
>> [...]
>> 	/*
>> 	 * Folio should be PMD-sized; if not (e.g. split in swap cache),
>> 	 * split the PMD swap entry and retry at PTE level.
>> 	 */
>> 	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
>> 		folio_unlock(folio);
>> 		folio_put(folio);
>> 		goto split_fallback;
>> 	}
>> ---
>>
>> it handles the case where swap_cache_get_folio() returns a folio that
>> is no longer PMD-sized. E.g. because it was split in the swap cache
>> while the PMD swap entry was installed. Then it split the PMD swap entry
>> and retries at PTE level :)
>>
>> unuse_pmd_entry() has the same fallback. Can mincore hit that case?
>>
>> Maybe the comment right above should say something like:
>>
>> "
>> One lookup is enough for a PMD-sized swapcache folio. If the swapcache
>> was split, check the per-page swap slots.
>> "
>>
>> Hopefully, I'm not missing something here :D
>>
>> Cheers, Lance
> 
> Good catch! Thanks for pointing this out.
> 
> I think the below diff over this commit should be ok. I will add
> it to the next revision. Its slower, but it shouldn't be an issue
> as its just mincore:

Just skimmed it. That should do the trick. Will go through it
properly in v3 :)

Thanks, Lance

> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 3fee8a7b9d9d..975513fff336 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -175,15 +175,42 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>                  if (pmd_present(*pmd)) {
>                          memset(vec, 1, nr);
>                  } else {
> -                       /*
> -                        * Non-present PMD: migration, device-private, or PMD
> -                        * swap entry. Route through mincore_swap() the same way
> -                        * the PTE path does -- the swap entry covers all 512
> -                        * slots, so the whole vec gets the same answer.
> -                        */
>                          softleaf_t entry = softleaf_from_pmd(*pmd);
>   
> -                       memset(vec, mincore_swap(entry, false), nr);
> +                       /*
> +                        * Non-present PMD: migration, device-private, or
> +                        * PMD swap entry. Migration / device-private cover
> +                        * the whole PMD range with a single answer.
> +                        */
> +                       if (!softleaf_is_swap(entry)) {
> +                               memset(vec, mincore_swap(entry, false), nr);
> +                       } else {
> +                               struct folio *folio = swap_cache_get_folio(entry);
> +
> +                               /*
> +                                * One lookup is enough for a PMD-sized
> +                                * swapcache folio. If the swapcache was split
> +                                * (e.g. by deferred_split_scan() or
> +                                * memory_failure()) while the PMD swap entry
> +                                * was installed, check the per-page swap slots.
> +                                */
> +                               if (folio && folio_nr_pages(folio) == HPAGE_PMD_NR) {
> +                                       memset(vec, folio_test_uptodate(folio), nr);
> +                                       folio_put(folio);
> +                               } else {
> +                                       unsigned long haddr = addr & HPAGE_PMD_MASK;
> +                                       pgoff_t off = swp_offset(entry) +
> +                                               ((addr - haddr) >> PAGE_SHIFT);
> +
> +                                       if (folio)
> +                                               folio_put(folio);
> +                                       for (i = 0; i < nr; i++)
> +                                               vec[i] = mincore_swap(
> +                                                       swp_entry(swp_type(entry),
> +                                                                 off + i),
> +                                                       false);
> +                               }
> +                       }
>                  }
>                  spin_unlock(ptl);
>                  goto out;
> 


