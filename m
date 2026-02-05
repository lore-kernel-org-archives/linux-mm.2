Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5905EC1EB2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972C06B0093; Thu,  5 Feb 2026 08:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9206B6B0098; Thu,  5 Feb 2026 08:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801A96B0099; Thu,  5 Feb 2026 08:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0B16B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:57:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36B7086E0C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:57:35 +0000 (UTC)
X-FDA: 84410555670.07.14FF7D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8586D100003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:57:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q39m7elV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/LOV/QfWvNfYtskQwsk6ZnLQC55NeUu2nzBjgWGFB4=;
	b=vRpv/bwxgKVMzAjG/rXPzAHFpWtXy8v2aMwxxgOfLLCWerfg+31hj/tUS0U8w3NZIHAGI8
	XvWJ8lY1Et5wGI1zN3Atlc8VXJhqtHBXJtx5yGNiyR1KkIwo6n22XlW5INZeyMBg9o8LSt
	X0N5n0tndSkPLY8elS1ZhSY7kXayEKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q39m7elV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299853; a=rsa-sha256;
	cv=none;
	b=iTs0xiHe5eb4ZNPg62kb9PPqE6CEnC5KmL3xScM9EcGEIEp7UIkKAk5TCvdbC2gKO3F1gL
	UMPJQXTYqTH7KK2rE/2Qr4jZxm8Yan0SE1VjjwDFMVQFw8on/iG0XZTyThi6IoTtArb4gs
	XS84oq7IX0A/6fW/KIqEU3ITJPbAI2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78EA640E4F;
	Thu,  5 Feb 2026 13:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF58C19423;
	Thu,  5 Feb 2026 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299852;
	bh=YgSQhIBpOA3HW8EbEt3blJrVqZkel/jdRwOh/YYBIUk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q39m7elVTMOdAUZ3gtFOs84ev6K57RNMhUYJsVToLHZKCvAnQvtp3+zEz+a/b+SI/
	 RnXBXUojJPAjWQqk/htBWeP+19oL76zfpyK/nNWFsUHY6FeKTYPBBYAtVsLIj/OWnG
	 dfvIqfHFiHcKlC3K/xrgWrki9QloCOii0ElF3y618geSEZBcavKzu3wW4lcytA5ZuS
	 36BliToUO4iSE7eUV/TVdVEFtblvdYpy50YwGu1h8DJ6eW+bYXBj+SoMl8+/NAshwV
	 kUjoFY9XRy7YIYt/ldP3ct+JgHKzsFLxuurXIk26EvCGXZSkiDzjq2uONRCBjwNb0Z
	 cSl8TM7e9oy0w==
Message-ID: <45b8ab60-8721-414b-a54c-008269e28a90@kernel.org>
Date: Thu, 5 Feb 2026 14:57:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 06/17] LoongArch/mm: Align vmemmap to maximal folio size
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-7-kas@kernel.org>
 <2ce0e684-de54-43ec-be7d-c58bbffb3f4e@kernel.org>
 <aYSgQknBNs5r-Tf5@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYSgQknBNs5r-Tf5@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8586D100003
X-Stat-Signature: y3jgqzqwto9m3ig6ujid4oxw9kftjzh5
X-Rspam-User: 
X-HE-Tag: 1770299853-9123
X-HE-Meta: U2FsdGVkX19j7ExI72qXZ4/h991jRzDKkaLSK6dEIccZMGiLZ5Mm+whnRS0K/L7cbOZjDhtbibJIjLRnzC4Sro4E9PauWM9+wf9v0qZg67BxyjzwUJb0h00Te6V1A0EqzYzczDafO7TYkF2Ky1vrrkue7ffO0IYiiqzxq+qTj+OA0gsa5elWQbZATP6u0vGHEuu5x0kV0atWhGeiPoD6ZziSBWofnBfcyjbk6F9A8QgYRX+W4bKTA0IXq8DEDgiv7OwkCW0GS/fKWg17/QXSzuzmwxjBHM81IzStPiqSrntQXCLfS5UleJ9TN7hq8zc/mvY6R+lZznQqRMZUxDt+dnYvQl1eMVa3aqCh8fatzUp3BmUYBnsYHM03vKNbb75gxhlnzi4pFH3OhthQxdRN+YRk5dfriU6ia9LgKeIcNT0fviVK6y+zljWHO1G36EBNmX5N8qZIDn9l3p+saBQO0ms4fpefqEYBGCPIjnhoEDRUzyRcqrVpecTM7IQ2QxMvMsGuzb3hGShy85BqhgZushPpT4hBltXr6kOq/C8DUoCdBrmuaDu1zOSC4R3TzbWBsc6c2T7CgOf+2F51Cn8rTQAAw9QSIU6oyfAUbVhVkl9VLS4pAJPImEUio+ZBKllRr8ZD3A0GP+vREbbrh7Ywvjvqcbm8mEHplSdvn+Fm3RwTLQZycHFM8jyn5USeFqT4zchVmXVPo9eCU/dEoukh438s6grHs8NGVrAqJGRYvA2oBxpxN39b/5CJO6+EeqcayadpeLhIq3CD0oi+9TZqLu52jUBj7ErOAd1J6Yl6vQAMADvNbktZc85ehYA7WZJYlnQAJwgewm7mzVRebfUsskvcKyscapoiyBbeXWA+9MgTgX0iG2czDoAOcDwYgddjLKJUBtf2wD4evTkSMuHcZqqftfOSTz9dD2FoSdwwwKeV0WubAXn9Bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 14:52, Kiryl Shutsemau wrote:
> On Wed, Feb 04, 2026 at 05:56:45PM +0100, David Hildenbrand (arm) wrote:
>> On 2/2/26 16:56, Kiryl Shutsemau wrote:
>>> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
>>> struct pages of the head page to be naturally aligned with regard to the
>>> folio size.
>>>
>>> Align vmemmap to MAX_FOLIO_NR_PAGES.
>>>
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>>    arch/loongarch/include/asm/pgtable.h | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
>>> index c33b3bcb733e..f9416acb9156 100644
>>> --- a/arch/loongarch/include/asm/pgtable.h
>>> +++ b/arch/loongarch/include/asm/pgtable.h
>>> @@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
>>>    	 min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - KFENCE_AREA_SIZE)
>>>    #endif
>>> -#define vmemmap		((struct page *)((VMALLOC_END + PMD_SIZE) & PMD_MASK))
>>> +#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_NR_PAGES * sizeof(struct page))
>>> +#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))
>>
>>
>> Same comment, the "MAX_FOLIO_NR_PAGES * sizeof(struct page)" is just black magic here
>> and the description of the situation is wrong.
>>
>> Maybe you want to pull the magic "MAX_FOLIO_NR_PAGES * sizeof(struct page)" into the core and call it
>>
>> #define MAX_FOLIO_VMEMMAP_ALIGN	(MAX_FOLIO_NR_PAGES * sizeof(struct page))
>>
>> But then special case it base on (a) HVO being configured in an (b) HVO being possible
>>
>> #ifdef HUGETLB_PAGE_OPTIMIZE_VMEMMAP && is_power_of_2(sizeof(struct page)
> 
> This would require some kind of asm-offsets.c/bounds.c magic to pull the
> struct page size condition to the preprocessor level.
> 

Right.

I guess you could move that into the macro and let the compiler handle it.

-- 
Cheers,

David

