Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C09C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891966B0088; Fri, 26 Jun 2026 20:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842DE6B008A; Fri, 26 Jun 2026 20:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733526B0092; Fri, 26 Jun 2026 20:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455106B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:38:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3AE61C666E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:38:19 +0000 (UTC)
X-FDA: 84923831118.03.2784BB4
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id C3C11140003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:38:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fONAOD/q";
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782520697;
	b=bUzOPHRZZD9pAW4zUKnxuVTz3/bD2TYWwGtLUQQqxDzndvaiezUn6vNGi1j5IXjtjrQgz/
	0Rhc6b2zz9lqYsHTtn3JFoAU3oJRqz/nInZYesqmMZksQS3enBogOyoC7GsCj6Sl/gC4oy
	eINrdfwQJqNZyWeX0f4lqgtqwbiEk6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782520697;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPFVIV5ffTTrKYQTZc202v1RiHOXGlAXpe39g4o238E=;
	b=TCMSHr+7WAoWp+Z3j3d9EOtXneFcMv7PAzqjYRe6ttnrhT8QnXSESy+FKelbZf7lKAkvAC
	TBIHUmp+e4bcKzwppsptGi2lnml3TonRSs/whV7mlWfyKRrSdjiY7Kpw4chhLD1pgoy5/C
	nKlxYr5lx9VQBULYphtK+ag3oVShYws=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fONAOD/q";
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-697e96dd8d2so2591562a12.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782520696; x=1783125496; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPFVIV5ffTTrKYQTZc202v1RiHOXGlAXpe39g4o238E=;
        b=fONAOD/qKRAip0CZHOGkMATxCPvrE/wv11mKgeRhu3k2Mm2Tu6qbKCYcyJ/gU2rDFZ
         039xwisXu8NnwlVof4RRg8/+tsbB3pZAbq0QsdWayqQ9xPu7tMymqGboRez2pgQPDbcB
         svpbZxyrXRoZ0tHy47uh2H9o8h7Zke9ualb+IZy8rH5FOxEYqyufoBhLGz5eUWeVbBIs
         EE2iK42knoDPtdhPqZf8pEmiaBlUFvG+/1tV8sPV14RInTuD64QcJTvkxYEQnWltU0AQ
         QbV0MDbxSQtWa8f3V9YYPD685tlgvvt2V7SsIMXsjPequHxgehPLM4Nnm0Vn9QmPJLnA
         gj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782520696; x=1783125496;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPFVIV5ffTTrKYQTZc202v1RiHOXGlAXpe39g4o238E=;
        b=o2dwMTPeJjzyvziBAvpQrqnCTapjrZkBKXwnVXBnE327RdYZ/MnL8EATa1K4lD9SGH
         ITeR73aBAA3T5W+Agt02/PGEBdiTV4IVtJGXKk4EvCRC1IxZe3OAUnDF3h8aLQwYkNsQ
         ZfchvyXqBDMOfil6S/Jbp9+nCX7HE4UPskdjIOxLBauKn2kqGKS4u3OdeD9W5xlR1H9w
         6OHJBR/lHfpTSoGxTY6nOUYzAZ5xUO+M1EJrSF2OR3Rr1YPDNwx645ISFKf+iyzdADGI
         ynYrlc00ZRE8PDH6uwuX1xozitUMnyTF/q/5seCH2CJahFyU2iDq+z9LG2yxAK+1O9ZU
         7U5g==
X-Forwarded-Encrypted: i=1; AHgh+RrpCwEOVT44prbHAsOwBC6v3vh13snS9+rANVgjH8OY4DkjrQ1wvhdU9Au+aNG8FeVMuUm+WUBbBg==@kvack.org
X-Gm-Message-State: AOJu0YzG3P9XRwbgYfNivS8diHGFbzGi2zBr6nT0cM/9Z7DYsBmCV+4i
	yCaf6cK84gZZZweZqhx+CC8jK1IFCSRWbKc5742bdhqJwy48BJJVyYZQ
X-Gm-Gg: AfdE7clkA5wGzO10x/T+xYLKmFUj7HUFR2BSSJk7ON8c7gp1M7G57SogRHQ0XRaMZ69
	O9zfkTNOfHpKK5c6zrb9Mz3kFdXFvjGOUoMoJg+P2EQemwTcMLc0RBwKsshC4hToNMgjvTKVoht
	O5jpjfqbkEBor3erJN6PaK83V1WUUPbIXikUK4qu8GkGuSE8h0TX21YtNmj8uoyY5FEdwDcXSaT
	PzZP4WC4GyAmofmm2yFlRx+xgmCgVt4Y6eVo+WZ5ReBu/KTbTUtEpOUGWrTVKrjhPnZh2CLTXk5
	91luA74OM/NlduK+8hUtMwca/WZFWnnhyvLTJuf5XAEO0kNq0RkywEe+nSmRnmUd2Z5kRiRbPV1
	ILqJqwk5C0H8g78McdlWpO5YNiWu5bUnZ6jxqrtpq6Q5cwxSJ93JjxnwalQo7JW4o6OWGhQyMXj
	aixYKizb1BXtc=
X-Received: by 2002:a17:907:a2cd:b0:c12:c69:ba0 with SMTP id a640c23a62f3a-c120c691824mr448756566b.20.1782520695919;
        Fri, 26 Jun 2026 17:38:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05ed6sm394276766b.30.2026.06.26.17.38.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jun 2026 17:38:14 -0700 (PDT)
Date: Sat, 27 Jun 2026 00:38:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, richard.weiyang@gmail.com, akpm@linux-foundation.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <20260627003813.ktpya35fx5doaz36@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
 <20260626132728.77436-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626132728.77436-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: joszt9wxo9417fw5u5q8z177inkt3w1g
X-Rspamd-Queue-Id: C3C11140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782520697-155885
X-HE-Meta: U2FsdGVkX1+B7NgHJRzAXWcHsMokIUOEsd8avfc0284oCmBPLwEM8AZQbe8A69Z+AjCGJV3bTPRDSgaMv8Hf5JCnh1BbfRFexPF+EZzlHreMIP+aatiAOIHuhzVnybuLX/4aUP7k34n9TF7hpKoJN0HFySPo4Ovdr9CqvSq9soLzIb8r/yspzXovqc+WTnQGPpZOkaXBPcjQlNalPnHoubCYl4oTonbDUBCUaCa06xrFgNyKHmS5xdb9h4cfiwomkmfza80iU33HpA/bn7fAK6byzA3QLyAbsxLBc3J7AZ0UPw6mgsG3ZEvbXZEwkFLau/ppvvED0+pnIq80CvZKebEjw4cpYo44N1CaGqPnHk+U1yrOA+e5rnN0KulLYwTjABTmYbBaXP5ITVaEeWJp0G2tNo7KAskrra3KzO3o0KvmYcD6RJ8ASgseCH/mFMCqiJwlENlixEID9fIrGbxy11i4/xNvpeBj2XgvQcEvvaYyuCeQvTRgnKj9IuGnK2u/uBrP02SL55x08OYQHD8NUy/A67TlcFqsCyTo9+LbjzSCx2HrU9ITnX0Ib/ZM+DLzpXTEMI861zGPJike/VRZYsw88W624Ft+Y71nqoh47uN9Eid3SNjRZp8BTEe3V4NgoxNx9oYaVcZ1cXv4KVtI8WnmFMoMiDZph3V2/BoGZ6ybscuXJqUxxlF0ZiphLN+GSZDgzL2TqtpkTKdcRS8i9S+dk0miagSOhrAi6Qp5CMEIR5LkCoep5OlSXCIHE6OYUlgAqsHoh0VB44Z1PKPUORrp7wke8BPXzoby6JuvPUGtGWXLo6W80qE38VdSywnpSGOwSN+8nbFDkA2tyNnma6VwNO1zVXT7UUGfHyn9TD73axMsRHz96rpGGdC6zxDKFzltxXmZlNeu6cYZzNAfIDvsYdlQlfXkesjjHbKTTGBs0tno5Oh3tFvZnel1J4b3laQMoUXfQ5byfZZaELo
 0/k8Wp65
 Y8cLpM3eHyfTC+Vv9kakZmCkuSHu8ywokDWWLYqZogVp87hn0fFVBZ4R/2zaDck1s4C4gpf4iUlSBH3E7BEZpNPTO+4L4TyXlXBq+xyMA4qlRWoGr20Sx0bI+qVXXZmTUcJuRwCvpghgb3Mjc5RRHipDJDincOMOQFOGlew2Rod7BKnXe8h69pdUwvboI0k8Zpu2n4jVb4ArUMD6+bET+iXNErYdxa22krS8WRM+wVC13Ca38PZ/0dZ3ZG5qFqG9fvOVdkbmKfaZzE0GB4pwFTQiYelnWFMZZssPOeYX/HWjV8pQMIkxbfyCRP4twM6S5K6XbCHgGMjY4DzSUKYPwBUhpnng5++5Vm3D+ES2wGioZBG8LKnJo+17isYUjKxi5pNsoa4wBfdB6PCZDLRsdJAYA1uATpYcD6f+S8dfnWmH4uEF5kMTTgR4+XD46dgPSjM/1lb4u1AU10AncjiGs8xTrzV1W+KidHVasuDRY92hyjEhISAJIItGd0nvSIHSDWw751Wgc7oJ4XuLPoYX3e3aEI2OMS0RVCgmJK+Z9P+s71PZipLxk03bWe9tERDZ5EtMLgypLgVr/3l6PpbD7f/JBa6USQU48aciqkq8iD3RgtFEmnkvZMvxQlXwVU8nQ0L+CSnIg8hg1wYzqi9AR06r296+PT70xiLPuhbAd7498kFh7FHRN8JoUKg92/S2Mgi3IPfGNrEfhs1J5CNfaZzsEhHn23lwjVNKHi5XbkmPyjkNm7eM+C2TzPRsPyLl7Dv68RS26vR5u2L4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 09:27:28PM +0800, Lance Yang wrote:
>
>On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrote:
>>On 6/24/26 08:53, Wei Yang wrote:
>>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>>> device-private entries") introduced the concept of device-private
>>> PMD entries, but did not correctly update the rmap walk code to
>>> account for them.
>>> 
>>> As a result, when page_vma_mapped_walk() encounters device-private
>>> PMD entries, it takes no action other than to acquire the PMD lock
>>> and exit.
>>> 
>>> However this is highly problematic for two reasons - firstly,
>>> device private entries possess a PFN so check_pmd() needs to be
>>> called to ensure an overlapping PFN range.
>>> 
>>> Secondly, and more importantly, if PVMW_MIGRATION is set the
>>> caller assumes the returned entry is a migration entry, resulting
>>> in memory corruption when the caller tries to interpret the device
>>> private entry as such.
>>> 
>>> In addition, commit 146287290023 ("mm/huge_memory: implement
>>> device-private THP splitting") allowed device private PMDs to be
>>> split like THP mappings, but again did not update this code path.
>>> 
>>> As a result, we might race a PMD split prior to acquiring the PMD
>>> lock.
>>> 
>>> This patch addresses all of these issues by invoking check_pmd(),
>>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
>>> us we do for PMD THP and migration entries.
>>> 
>>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>> Cc: SeongJae Park <sj@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>> 
>>> ---
>>> v4:
>>>   * refine subject and commit log based on Lorenzo's suggestion
>>>   * put pmd device-private entry handling in its own if branch,
>>>     suggested by Lorenzo
>>> 
>>> v3:
>>>   * remove cleanup part, only fix the issue for device-private entry
>>>   * refine user effect description based on Lorenzo's suggestion
>>> 
>>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>>>   * specify the possible error case of current code and user visible effect
>>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
>>> 
>>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>>> ---
>>>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index 2ccbabfb2cc1..17dff8aab9f9 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>  			/* THP pmd was split under us: handle on pte level */
>>>  			spin_unlock(pvmw->ptl);
>>>  			pvmw->ptl = NULL;
>>> -		} else if (!pmd_present(pmde)) {
>>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>>> +		} else if (pmd_is_device_private_entry(pmde)) {
>>> +			softleaf_t entry;
>>> +
>>> +			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> +			pmde = *pvmw->pmd;
>>> +			entry = softleaf_from_pmd(pmde);
>>>  
>>> -			if (softleaf_is_device_private(entry)) {
>>> -				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> +			if (likely(softleaf_is_device_private(entry))) {
>>> +				if (pvmw->flags & PVMW_MIGRATION)
>>> +					return not_found(pvmw);
>>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>> +					return not_found(pvmw);
>>>  				return true;
>>>  			}
>>> -
>>> +			/* device-private pmd was split under us: handle on pte level */
>>> +			spin_unlock(pvmw->ptl);
>>> +			pvmw->ptl = NULL;
>>> +		} else if (!pmd_present(pmde)) {
>>>  			if ((pvmw->flags & PVMW_SYNC) &&
>>>  			    thp_vma_suitable_order(vma, pvmw->address,
>>>  						   PMD_ORDER) &&
>>
>>This is extremely hard to review given the existing crap handling here. I'm
>>really sorry, but it makes my head hurt (I'm not kidding :) ).
>>
>>It's completely unclear why we only have to check for a subset of the cases
>>after taking the lock.
>>
>>Could we simply extend the existing migration pmd handling and leave the
>>!pmd_present() case for pmd_none()?
>>
>>That leaves no question to "which transitions are actually allowed", including
>>"could we accidentally assume something is a page table when really it isn't".
>>
>>
>>So what about something like the following?
>>
>>The "thp_migration_supported()" is not required when checking for
>>pmd_is_migration_entry(), as that defaults to "false" when not compiled in.
>>
>>Untested:
>>
>>
>>>From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 2001
>>From: "David Hildenbrand (Arm)" <david@kernel.org>
>>Date: Fri, 26 Jun 2026 12:03:40 +0200
>>Subject: [PATCH] tmp
>>
>>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>---
>> mm/page_vma_mapped.c | 29 +++++++++++++++++------------
>> 1 file changed, 17 insertions(+), 12 deletions(-)
>>
>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>>--- a/mm/page_vma_mapped.c
>>+++ b/mm/page_vma_mapped.c
>>@@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 		 */
>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>
>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>+		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>>+		    pmd_is_device_private_entry(pmde)) {
>> 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>> 			pmde = *pvmw->pmd;
>>-			if (!pmd_present(pmde)) {
>>+			if (pmd_is_migration_entry(pmde)) {
>> 				softleaf_t entry;
>>
>>-				if (!thp_migration_supported() ||
>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>+				if (!(pvmw->flags & PVMW_MIGRATION))
>> 					return not_found(pvmw);
>> 				entry = softleaf_from_pmd(pmde);
>>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>+					return not_found(pvmw);
>>+				return true;
>>+			} else if (pmd_is_device_private_entry(pmde)) {
>>+				softleaf_t entry;
>>
>>-				if (!softleaf_is_migration(entry) ||
>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>+				if (pvmw->flags & PVMW_MIGRATION)
>>+					return not_found(pvmw);
>>+				entry = softleaf_from_pmd(pmde);
>>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>> 					return not_found(pvmw);
>> 				return true;
>>+			} else if (!pmd_present(pmde) ){
>>+				return not_found(pvmw);
>> 			}
>> 			if (likely(pmd_trans_huge(pmde))) {
>> 				if (pvmw->flags & PVMW_MIGRATION)
>>@@ -270,12 +280,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 			spin_unlock(pvmw->ptl);
>> 			pvmw->ptl = NULL;
>> 		} else if (!pmd_present(pmde)) {
>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>-
>>-			if (softleaf_is_device_private(entry)) {
>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>-				return true;
>>-			}
>>
>> 			if ((pvmw->flags & PVMW_SYNC) &&
>> 			    thp_vma_suitable_order(vma, pvmw->address,
>>-- 
>
>Might be good with this on top:
>
>---8<---
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index cfa1230c87bb..8b7c062bd81d 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -281,7 +281,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 					return not_found(pvmw);
> 				return true;
> 			}
>-			/* THP pmd was split under us: handle on pte level */
>+			/* THP/device-private pmd was split under us: handle on pte level */

As the comment in commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
support device-private entries") says:

  Add device-private THP support...

Per my understanding, we first already setup mapping and "migrate" to device
memory. This looks a kind of place holder.

Not familiar with this. Just want to clarify, we want to treat device-private
pmd as some sort of THP or not?

> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
> 		} else if (!pmd_present(pmde)) {
>--
>
>Looks good to me as well, thanks!

-- 
Wei Yang
Help you, Help me

