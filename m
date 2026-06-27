Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88276C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D7A6B008A; Fri, 26 Jun 2026 20:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164BA6B0092; Fri, 26 Jun 2026 20:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056096B0093; Fri, 26 Jun 2026 20:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0EB66B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:04:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52BEA167B12
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:04:23 +0000 (UTC)
X-FDA: 84923745606.18.93ED2EF
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 56EFE40007
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:04:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnrxbXz9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782518661;
	b=Ricb5j6tcb/9+UlCoeHKCfdzR6i0IpRJe3s16BokCV+wF01eNPX/N4aZNmDGzfHvpS6zO3
	8KZh6IaDnfsS/yE8jFnqP31bM2wyeCueQaAdR3A5w3ZKgcl6/0EWpkI6jtcly44iYalp1D
	R0qdupiAP8+OKyenyxMRohJ/pj4YzYg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782518661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aBtjyBhRXO4wcOB3SrA5AZCE73f5ZU7Ka9JtMA+a/E=;
	b=3OtPpC6VsExqcstBbmT7JYHCK7ZFSafLj/Ua8TDpig0tsEjvN+uSANN+aNYw4ggRJet18m
	Ysyf1B0rGHUHAz9CyYpzGKxF4l6hCU0QAcyz6slOXuaQ1NTQR88Dwn1HGFwmyEoNyamY5+
	cTaSk7KiMRHY4IsCvKS8FdhPBIq88NE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnrxbXz9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-697f3af8749so2353289a12.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782518660; x=1783123460; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aBtjyBhRXO4wcOB3SrA5AZCE73f5ZU7Ka9JtMA+a/E=;
        b=cnrxbXz9EHPmlbsBG4leHv+QTsBzn1MUH2BWXJSM/th7OTDI74IkHxt7J+TsZ5Cd4e
         Ee3DkA22o8FWZUHpC7GEZPwencSdirk0rS6ip1N0+5YGcLVRFfMwmIn5RTxUQM4xt3aS
         gRrbXAzELnYYy0TGIw3xyFMnAQef2l2AJGCFvbNRuNppOe73LyFJSMdAVxDH75be6//y
         e1lsFjuZJ7CKbM/Nl95jPmXIfhwYz7Dv7IrRSEv/2pBRSow2erpeV+CI1hsa+isQXII6
         djGxfcJ1eFPPzhjBZgeXG+TV6daVjq91T+gDf2OHJZy7xoY02gOTNl0zxYUgA4d6K3w+
         ztRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782518660; x=1783123460;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9aBtjyBhRXO4wcOB3SrA5AZCE73f5ZU7Ka9JtMA+a/E=;
        b=FSxwnv1CA1x0Ya5jqHTqjYuWDKu7a8ZOmS/2Fqhe+tL40pFkcb1Eg1VbrmO/SipiKi
         Y2j7di7AQFD+/N/8UEmSrGGVhwSNVpRBpp/1sYodKixQ65/ZjP5Y0SXcJ0iV9s07B2sC
         qv0rherWf+gbneDnAH2GjtzNJsnE4eQC1s7k1+0hlK2/XT14qpaN4r+rHdKs1/aI++o+
         WfddVffA7yzzTXD5OhN7+LPSUCANiE78U5Kuo4H9O2uV2lgGAuZkqlpRsWNSTpYb6mKS
         jE9jACPhtjHfJtkiAuPuqP2xOahlN2PhoLOl76jE+ag5KMTjX9xa9ZB1rcm0+wTg+IDu
         /RAA==
X-Forwarded-Encrypted: i=1; AHgh+Rq/CtJ58Ay/4HFDt8P0CRHSScYz2y+V/EkI5mI1pGu1EfAqbk8tjxxlTXy6BYMc6Sb9D4/FvN9tbQ==@kvack.org
X-Gm-Message-State: AOJu0YyDf0nqdRnLXUnXj8sb2ncof823X6VNqZFg3QAMYDBZXhWx43C6
	0bccgCTFI92vs46SOE8KYl7QawlZTc+5l6KNjkDvmIJeh2t9hI2BrB9t
X-Gm-Gg: AfdE7cnivsI+N4hWqFr2fpQBHdwpe2z7hsksQv8uMlaM1U23F7g8YeA6E0gooBrVzhe
	Y2bIJcNgiNPZchPjTkWJ9aQtWYmI1PcUf3bccsC9O85iAbyDsNVxcQLsEJtK3TevoXcEB/QS9WI
	6IoF0OoAX+3uuHEu4JrmJKIw41pup9RHUnHVf50xKpaD0AspZpBmb1wHuFNhMIj2lEcglJewF6v
	PrhEiB66t3+MrMaT57j6XjnAbv33/+pXBhRqeofepmN2gdUaRssHngZRPXFQsO1RehlcUlfNxb4
	pN9Jx/9wRNAJgYgMBR2Pp1tDhc0U1+xHl44AUK0IrJ9WYLIVkx8MudcjqOSiUiN845tfVXZ/eYl
	JNzhIm2Almm/2GFUONXp9wwQYnL3Gi48M/nk+7GOtrTyRtBKocJ4OatlPBmSIbXFGrjhCPAz3zd
	0SKdlgpX/nA3Y=
X-Received: by 2002:a17:907:94c1:b0:c12:2ce7:a5a8 with SMTP id a640c23a62f3a-c122ce7fcf6mr214659666b.25.1782518659316;
        Fri, 26 Jun 2026 17:04:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbba8b61sm387627266b.4.2026.06.26.17.04.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jun 2026 17:04:17 -0700 (PDT)
Date: Sat, 27 Jun 2026 00:04:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <20260627000415.xm4w3zzpithptv4i@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 56EFE40007
X-Rspam-User: 
X-Stat-Signature: zxtgdx6fpn9598wp16yxbwxa3qfpbu3u
X-HE-Tag: 1782518661-819872
X-HE-Meta: U2FsdGVkX19tkrwEm77G5bPNr/ts4RYoSJdlMxA4xykpyuxEZTM2NhdpVyUn/7IHd2KN+HxzG92tCIJ+b2Jjb6Crmu0sh/AXDVRfYhhKPijWEs/6T9eh9rzljx17TEc2Kc3nr29Supk2tFE6NKEDFE+ZT7Q2OdvbeqrCEUgenNI/CTnhwkGHPb/JT4xNr72SOO/QnPT+BHvV3NHqM4ULxfXYc58k7SaGD5oxbHAZYCfnId06lIUNjlg023ifSmTNEZhBuy6FZtBARLiS+6UjtUrHUPutS3WL5uDsMoUL+Zftsoo5oVLSqZcVwDMrCVJn+MjKOwXdJhvkrAXmNOdqloo3bXIhtjKo7CmybUZorDkFR7DZ9E4G380uJKiWDrug54/sg9jesVb6qVmNxRyeWSfXT3hHbOTOSWFs9oq7rqAwCz3TSqLcSweRciD8jHHxJJw443ZHO/FJi7W7UNgqRrTlvysKtsgY1YIJefeKST8b24cPsN+TF3Bz2+SjX+SiSZNNclrqOsWeMfZ9q+5Om1PsmTFz/s8qceNw0dz3RPLEwhmEaLl3Z/d3mi4kj2Il87ijkOF7+CH85I0FqHsxVPqfDTVIDcv7cPDc+IN2/0bF6K2ra5ono/o1efZYPkbe2Bfay/s6s7FMvkNnnv7cmSsYQ10+zOnMo9wPJ3bDpM6iXeUFPRVHRPD4u/GK4CdbtPDJshTwOjWka1OCTnGUm6yaYKBckiFIQadlZ0s1Yda5nwMGnuMZNgz/peLTu5lprgbRjr5h3Lb/gmk+syhLPEqizvrXD9qkx+2sNBoj5wxFJe1W/TO+mQ8KvW4tTp/2vuRz96uJb/FvXcd+8QyfPgzi//8olKtVKbBpcHDgFRXM+PvkrlHanGvi/Y9ufr2UZDSVrnhTRRgoEzZvYuQBEyE10xzymhxQA/2kZAHnUicgaHNtYOGhDBC5lLBGwGFaJoh55jud4FSvYBJSK5P
 rZ+rXKgM
 ZgIE+M2LV6DjlofnijhQdzHV/RlHH0M9LjFF2aU6w2xWZWkohdPkVi6A1Iw6XQ6LhYuqfUI27xtONlU1yROJtfaViop15hg6PRElIJ5M6wO/vxuoxFEiHRynlMs15qy0U9HXc5dw2QXdcrArKy6Jx1m46xS9GHrpO4wO0YZfQewINiFLlkQNmd8lYxm+T0Sp6axERvqArEqvOn7KDVOrUTgJfFZsNnpBevo+ZCFeGlSPpl+fAD32GlllLeOkBB6PaS4T+4kVjhpfZRSeiRfvzBHr5BLkke2aYk2khJ0DZYTc+c1ScE07wulkeCDzi68hzk8TeqOgfDtsDNfjQhQbo2HH8OvdSQ7ZXArX1bqZeIBqULeW02xO8stUGgsWqW2QFvAcZoFmFERKOyAmy6CzA7xeL546LCO8Y5fRddW6/B6ejf5OzhzqgPkxsv6ZXW1bwBD5J30+okUpMujz6GY910+DuziTTzL+X4Sz4SSj62x5gD2J62eGrvsf6MsI7xvB5ZMKZeoZlK+7GY7U3+TquGKRiPzWGpE5erjNkAP4WLpqeb42YvZa5IYgIQOZQo8+PWB1fRV848feaBU4su2VEOARgHkkdWoTJJ5GqPVvzQWi5PQVhjcm6eK3LVVRaFIQFYSLHaQvgINbOcgbkL89fX4LhGYU4mV9rkz0NlWShYdMhFgumtTtmLZkjqQkorXihd1EefR3jPklTwUAkYvDugzSi1kkyd3uCbCmdc0rfoPNPKmUHjkeQuzaWUpsc0LIBwnLc+gefjLZ6c+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrote:
>On 6/24/26 08:53, Wei Yang wrote:
>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>> device-private entries") introduced the concept of device-private
>> PMD entries, but did not correctly update the rmap walk code to
>> account for them.
>> 
>> As a result, when page_vma_mapped_walk() encounters device-private
>> PMD entries, it takes no action other than to acquire the PMD lock
>> and exit.
>> 
>> However this is highly problematic for two reasons - firstly,
>> device private entries possess a PFN so check_pmd() needs to be
>> called to ensure an overlapping PFN range.
>> 
>> Secondly, and more importantly, if PVMW_MIGRATION is set the
>> caller assumes the returned entry is a migration entry, resulting
>> in memory corruption when the caller tries to interpret the device
>> private entry as such.
>> 
>> In addition, commit 146287290023 ("mm/huge_memory: implement
>> device-private THP splitting") allowed device private PMDs to be
>> split like THP mappings, but again did not update this code path.
>> 
>> As a result, we might race a PMD split prior to acquiring the PMD
>> lock.
>> 
>> This patch addresses all of these issues by invoking check_pmd(),
>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
>> us we do for PMD THP and migration entries.
>> 
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> 
>> ---
>> v4:
>>   * refine subject and commit log based on Lorenzo's suggestion
>>   * put pmd device-private entry handling in its own if branch,
>>     suggested by Lorenzo
>> 
>> v3:
>>   * remove cleanup part, only fix the issue for device-private entry
>>   * refine user effect description based on Lorenzo's suggestion
>> 
>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>   * specify the possible error case of current code and user visible effect
>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>> 
>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>> ---
>>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
>>  1 file changed, 15 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index 2ccbabfb2cc1..17dff8aab9f9 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  			/* THP pmd was split under us: handle on pte level */
>>  			spin_unlock(pvmw->ptl);
>>  			pvmw->ptl = NULL;
>> -		} else if (!pmd_present(pmde)) {
>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>> +		} else if (pmd_is_device_private_entry(pmde)) {
>> +			softleaf_t entry;
>> +
>> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> +			pmde = *pvmw->pmd;
>> +			entry = softleaf_from_pmd(pmde);
>>  
>> -			if (softleaf_is_device_private(entry)) {
>> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> +			if (likely(softleaf_is_device_private(entry))) {
>> +				if (pvmw->flags & PVMW_MIGRATION)
>> +					return not_found(pvmw);
>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> +					return not_found(pvmw);
>>  				return true;
>>  			}
>> -
>> +			/* device-private pmd was split under us: handle on pte level */
>> +			spin_unlock(pvmw->ptl);
>> +			pvmw->ptl = NULL;
>> +		} else if (!pmd_present(pmde)) {
>>  			if ((pvmw->flags & PVMW_SYNC) &&
>>  			    thp_vma_suitable_order(vma, pvmw->address,
>>  						   PMD_ORDER) &&
>
>This is extremely hard to review given the existing crap handling here. I'm
>really sorry, but it makes my head hurt (I'm not kidding :) ).
>
>It's completely unclear why we only have to check for a subset of the cases
>after taking the lock.
>
>Could we simply extend the existing migration pmd handling and leave the
>!pmd_present() case for pmd_none()?
>
>That leaves no question to "which transitions are actually allowed", including
>"could we accidentally assume something is a page table when really it isn't".
>

Consolidate all the cases in one place looks reasonable.

And make the logic clearer.

>
>So what about something like the following?
>
>The "thp_migration_supported()" is not required when checking for
>pmd_is_migration_entry(), as that defaults to "false" when not compiled in.
>
>Untested:
>
>
>>From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>Date: Fri, 26 Jun 2026 12:03:40 +0200
>Subject: [PATCH] tmp
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/page_vma_mapped.c | 29 +++++++++++++++++------------
> 1 file changed, 17 insertions(+), 12 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 		 */
> 		pmde = pmdp_get_lockless(pvmw->pmd);
>
>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>+		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>+		    pmd_is_device_private_entry(pmde)) {
> 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> 			pmde = *pvmw->pmd;
>-			if (!pmd_present(pmde)) {
>+			if (pmd_is_migration_entry(pmde)) {
> 				softleaf_t entry;
>
>-				if (!thp_migration_supported() ||
>-				    !(pvmw->flags & PVMW_MIGRATION))
>+				if (!(pvmw->flags & PVMW_MIGRATION))
> 					return not_found(pvmw);
> 				entry = softleaf_from_pmd(pmde);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+					return not_found(pvmw);
>+				return true;
>+			} else if (pmd_is_device_private_entry(pmde)) {
>+				softleaf_t entry;
>
>-				if (!softleaf_is_migration(entry) ||
>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>+				if (pvmw->flags & PVMW_MIGRATION)
>+					return not_found(pvmw);
>+				entry = softleaf_from_pmd(pmde);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> 					return not_found(pvmw);
> 				return true;
>+			} else if (!pmd_present(pmde) ){
>+				return not_found(pvmw);
> 			}
> 			if (likely(pmd_trans_huge(pmde))) {
> 				if (pvmw->flags & PVMW_MIGRATION)
>@@ -270,12 +280,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
> 		} else if (!pmd_present(pmde)) {
>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>-
>-			if (softleaf_is_device_private(entry)) {
>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>-				return true;
>-			}
>
> 			if ((pvmw->flags & PVMW_SYNC) &&
> 			    thp_vma_suitable_order(vma, pvmw->address,
>-- 
>2.43.0
>

Will prepare v5 based one this.

Thanks.

>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

