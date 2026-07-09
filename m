Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F2BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73496B008C; Thu,  9 Jul 2026 09:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A396B0092; Thu,  9 Jul 2026 09:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88746B0096; Thu,  9 Jul 2026 09:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A42446B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:39:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3269C1A0196
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:16 +0000 (UTC)
X-FDA: 84969344712.15.E78BFDD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B2691A0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PZNre4gv;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783604354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJkp2meVgiaKUciwcMMfkTIIvQAi/N+Fon05ZdxSoEI=;
	b=RZXwCAEsp/9/vU1szj7OqQisCWrzlge1syT0MZ95IYGXNitiEOhSJoGppT6QJQxpOivC05
	4peTvJuPq+zKfGtKKDRaLopRj0xpqZH76y4C+SwN2rmCuyvyqcL6l4bDBphDl6az5W3tWK
	OvJuOWr9Wu/MsYzuAB4TgZ5+y5J7UaI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PZNre4gv;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783604354;
	b=wSBirscTC2+wN+iO/Up1pdP8q1SeDJDgezm51EbPG7UOvK11IqVNjDQhM1hPquOGRYCL3F
	CzuF4lQYGksQzNFFHWIImpTo1+oH7Ea/R0hQxrmnd/kC6m8elj73WvoQIwsQixa5SWQMl8
	NkqQhmfWRBKxd819M7fn2dC0J0UTfR4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE0831684;
	Thu,  9 Jul 2026 06:39:08 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24C2F3F85F;
	Thu,  9 Jul 2026 06:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783604353; bh=SDJoeU8Reac6famvfbS1+RPrRYH1qwGUWY3op31U2FU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PZNre4gvmYW3bEFLr803+SQHvfsQuLzp1wwpgpIQ35IKVZdDq3mGMUqmeZIz8Tl7b
	 LxyhJUm6A3NbLHZs1yn6eJJZ05V0EnPIvBku48ZURTMmMgxCDUQOsFb7HHP7/H3Xem
	 62huO4i/sIEOCuZh5GM9f18Cl40WhTLJu+p9+85w=
Message-ID: <994e2971-c764-45ab-914d-5c265c263b9b@arm.com>
Date: Thu, 9 Jul 2026 19:09:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/rmap: refactor anon swapbacked folio unmap in
 try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260707121128.373192-1-dev.jain@arm.com>
 <20260707121128.373192-5-dev.jain@arm.com>
 <1221180d-6217-401f-a479-3a5d9684659e@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <1221180d-6217-401f-a479-3a5d9684659e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B2691A0002
X-Stat-Signature: 4mugikzjfxykp1cgq8t3rnbwd5uy798i
X-HE-Tag: 1783604354-222667
X-HE-Meta: U2FsdGVkX19FpRarEg3gOzOLJ/HNGLqZ+m3PX0kasmNno5WCBXuQVpwdNl+4R18bukWmRmStl2SzlAUTjlM8m4DtDrTmqbfMt4uC6bFfWwtOIhgOwmj/yjiX4DG55//GnB3YUreZZAMZdO+XZxzqoKdC2nVSDWA8yITXTjfM6vp6WbiiMnTMFktGi4Dutpa55quj0v/e9JhsnFloFobAefsHvxR52y60osYlN0vyv/a3OuJyESSJnzjpvT0x1zt9cdO7sVwWABVksE0gp1BzNJPQ+SWB0ewT/rz4xs0VFSBi59U3gRNYPpUPfrZG6rgKCW76fLzljur7mnRold1szBMmUAJJGpWF2bKAXTPmBQ+pKXy2E4x1WwPAah4Ptuuqtv5IZYDZBvJNsRONGbNl+WyVwP9o8n/9moe3iTlpWFp4PKPnQ0Lj0lmRIF+5B/aDVe9u51O6k8a8sdM1S8L9LX9MB9B8Ls7hVg+S+OuQu5GN1Y58zPKx/Wir6ZGo7hYi9CFee227nVk/K+Jr3vADMo3r21np6OYPujOH1ujG4k6PrDrwELZLooveN3XKQ7NkIAxmRKc6ZgIaeo207g/wg+FXMUVmB3XFAevlL3EyyE9atuWput1YH5bS9FeMGxciBci3UfpxbDo8K/SFUntM0jzAgyL+WWn73Gvq0HxAC8omgebIPr1bgxTBQHPx4q0ch8p4alVgd7GAxXa/6n/5jxvctbqYTuegboD+jQidaE4jInlBv1nxptKv5B+R5C8grqEB69wL7opkFClbXrsCyV54KVNqWRSwzjewDrk1I+UA7GjcLZaS9oP4sXXDGXtkq41XaHL67ivFPE5g5LIoBKOfqqXZVwcyi+ShKCQAeySwfSxlATgEsbnH0D/bXFyY3NVofeLrheMWRIyinGeKHCJrgXjT9CCkJ5TBFfwozv3vnf1be7hBvW5wJiGDIb17MsBy5+B67fUVIjL3s0g
 SHnwkK8h
 qQIYKGMRIFd6E3JoUt7rijvMwX4vXfpY01/NdCL3L7AeEYQa+NTuPRW13ZzMb/qaDGrbim9recSQQltD2iYKcZbkRX7altowW7cYvcI4aVU+wp2io5YewwZ+Z5VqpUdJTACH9njaWgbLMGU9TQOjt/Vpw0DIdPK7jpOwKBxPFSzLj4KQC9XNMKZ0d74qcX+57gdCefO1XbrG7G3BDZjrXpJJVLNiRC4MqZBzl0xw4JXfVR7jHbhPs7Nwsrn/TekBdGxBNJ/bO6pxELiAYc5gWDNpJQAcTImij8z8oBnT//kKEkqtrPAkN6+d7vA1veMqRE5WuB3ftdNhS1L92QufDEgrBKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/26 7:56 pm, David Hildenbrand (Arm) wrote:
> On 7/7/26 14:11, Dev Jain wrote:
>> Refactor anonymous swapbacked folio unmap to ttu_anon_swapbacked_folio().
>>
>> No functional change intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 105 ++++++++++++++++++++++++++++++++----------------------
>>  1 file changed, 62 insertions(+), 43 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 00b571c2a1bab..ade78df5be2bd 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2113,6 +2113,64 @@ static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
>>  	return true;
>>  }
>>  
> 
> BTW, no need for the "inline" for most of these functions (applies to other
> patches as well).

Okay

> 
>> +static inline void set_swp_pte_at(struct mm_struct *mm, unsigned long address,
>> +		pte_t *ptep, swp_entry_t entry, pte_t pteval, bool anon_exclusive)
> 
> It's confusing that we say "set_swp_pte_at", but the pte_t we was is actually
> the old pte.
> 
> Can we instead have a function that creates us a swap_pte from the other data,
> and then do the set_pte_at() in the caller?
> 
> static pte_t swp_pte_prepare(...)
> {
> 	...
> 	return swp_pte;
> }

Okay


> 
>> +{
>> +	pte_t swp_pte = swp_entry_to_pte(entry);
>> +
>> +	if (anon_exclusive)
>> +		swp_pte = pte_swp_mkexclusive(swp_pte);
>> +
>> +	if (likely(pte_present(pteval))) {
>> +		if (pte_soft_dirty(pteval))
>> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +		if (pte_uffd_wp(pteval))
>> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +	} else {
>> +		/* Device-exclusive entry */
>> +		if (pte_swp_soft_dirty(pteval))
>> +			swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +		if (pte_swp_uffd_wp(pteval))
>> +			swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +	}
>> +
>> +	set_pte_at(mm, address, ptep, swp_pte);
>> +}
>> +
>> +static inline bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma, struct folio *folio,
>> +		struct page *subpage, unsigned long address, pte_t *ptep,
> 
> Subpages do not exist :)

Ack

> 
>> +		pte_t pteval)
>> +{
>> +	bool anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(subpage);
> 
> const?

Okay
> 
>> +	swp_entry_t entry = page_swap_entry(subpage);
>> +	struct mm_struct *mm = vma->vm_mm;
>> +
>> +	if (folio_dup_swap(folio, subpage) < 0)
>> +		return false;
>> +
>> +	/*
>> +	 * arch_unmap_one() is expected to be a NOP on
>> +	 * architectures where we could have PFN swap PTEs,
>> +	 * so we'll not check/care.
>> +	 */
>> +	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>> +		folio_put_swap(folio, subpage);
>> +		return false;
>> +	}
>> +
>> +	/* See folio_try_share_anon_rmap(): clear PTE first. */
>> +	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, subpage)) {
>> +		folio_put_swap(folio, subpage);
> 
> I recall I stumbled over this before, but there is no way to undo the
> arch_unmap_one(), right?

arch_unmap_one -> adi_save_tags is saving tags in an mm related structure. So
I don't think there is any need to have a reverse operation in case of
unmap failure, since the ADI tags are still there on the page.

> 
>> +		return false;
>> +	}
>> +
>> +	mm_prepare_for_swap_entries(mm);
>> +	dec_mm_counter(mm, MM_ANONPAGES);
>> +	inc_mm_counter(mm, MM_SWAPENTS);
>> +	set_swp_pte_at(mm, address, ptep, entry, pteval, anon_exclusive);
>> +	return true;
>> +}
>> +
> 


