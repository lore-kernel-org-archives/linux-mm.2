Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E93FF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B7B6B0005; Sun, 26 Apr 2026 05:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBD36B008A; Sun, 26 Apr 2026 05:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAC36B008C; Sun, 26 Apr 2026 05:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A00D6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:20:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 737A88B7EE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:20:03 +0000 (UTC)
X-FDA: 84700160286.16.AA250BB
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 65CD61A0006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:20:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AsFNnJ95;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jlVpbxntJc7aQq4cpVkGSzYqQF/N/lt+WU2PsPuvKo=;
	b=MmaRFDmlooN8QSQkxJImETqvgDFnFuTZoUl6n3KJDtRvMzgWGU63ymAmx1BvUlSqkPnWUS
	O4QxfX86+hx/t+Q30UvaS10UemDxqiYpHhzk4QABUbwi5S6ZJvgd84n9XaJCTy9G1D8ZUK
	u5eoObzQ3sLQVRmFTHCqSKeAQYIh7nM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195201; a=rsa-sha256;
	cv=none;
	b=4FftuXWuiopKC5jUbS5QE8vQfQhFDob5OBkEaNygLcl0uIlm/XWhRKVr3Jgh4tfuMxCyJQ
	Yb00MX3msHfBfn+PJ+N53m9ZMVhkK18NYdF+oLG8ibMEgHMR4yFAOatTjBzqxBwJQOhHGd
	eSe271FK1AbJSrT2MEH/2IjLojnqxC0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AsFNnJ95;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8f97c626aaso579879566b.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777195200; x=1777800000; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jlVpbxntJc7aQq4cpVkGSzYqQF/N/lt+WU2PsPuvKo=;
        b=AsFNnJ955CTwyUDJqpk0urvARdJDYaQ7ck+6iqRAz9jC2WZjBMGJVGT0sOlTCTXuDh
         FN+3lP/1ioOo7gVpYsErh2/jduRdjy1SW8OIMjdqWcobX1uVGW3LIlnqsPNPHC4Bp9ZP
         1Gpv9/EPDmfEe1xdOS9XtYvH1IY8OAWs263eWALtOlgc2ttc4GCz9m0uIO4KpuC4AHB0
         8plgp7tRg45dKz9ryek42LqFV8Skdprxaf4VBMT0ky3dFZVH9CA+ypfN8ooIegiMGdyd
         YQtuEXFNXNgpHBpmjgy7v0gE5Ynn/41+tUEU+UtH2HPvta+kj1v40uxyuMa+p9619y+n
         TWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195200; x=1777800000;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/jlVpbxntJc7aQq4cpVkGSzYqQF/N/lt+WU2PsPuvKo=;
        b=nJqxbtRadLGJ0+lTjLAEv2JOzyt9bde0MMi29fKuNVButSU1cTv92ZPoK9F+XfXYRV
         DrZFuOxh7gnLp0thjMCUQvWUKB7+ZyUeKy6oALWY67DnNK9LtiwdzesadVlC+I5YxfDo
         z0J0rIjbXDdFBBj8+Tn3FnG/Fw627vQwLSCeVvNbaDDG/LJHiAWnQMx1wE4aslTXk36N
         hVOXcgnHRMzNMGTTMfKcwjT5uZBVZCmx5o0+n19BZl0EXWWwYET/VqXrmrXjIE4tP9qc
         4C6AcEsPQV2b7bQ5oS+vEPo5R5i34z0Zw0q8HxmRoHaDShocuz7jYGs2Bre6jz6YoY/V
         e8NA==
X-Forwarded-Encrypted: i=1; AFNElJ9R62g6Ady/41Rnn51f/TWNDZKMQtxrRg/HFsHAv6cyWHJeqMCctclBtH3axuBV392HCIOhARWoOw==@kvack.org
X-Gm-Message-State: AOJu0Yw0JgfW12ZUI+vjWVbA9H3D3FctuSn5XEAlB3fWbXGrMHHJkpuQ
	1y4qP5h0GUkxwwPsOMxC1iM7p2NZ4Do+1AKJ9suNxSsjx2zWi2c8RaUh
X-Gm-Gg: AeBDieu06TwMo0hdLjKPq29BsZIOl4Y4e/5Ycypj69S0xcOGfVKHf7QbIYzjzpNGAZ0
	S3RWWuva6fD3ntnxPG6PwctwtFETZYVe/7EJZ7CO0RArysdbZ61smkJSrabbgZPxg3qNJ3O2s74
	lxonIagbHw8bXKoRtaT/kkKRJLZzRMAL/GpMnzE/oTHwzHj/LdyFlyI+fCpvrwSueGrO2bkgTuw
	7E+WGxdURwBP01nBxlfiZUUpp8wiZnBVx7xrv5PNAEUdU5f4iipgVzBEYHPXbhckA0aswwMs/58
	R50IO3cwWfHjhjI3DO9lZ6QtKqJ7FVQpBjMmXVXZLLrqOKR9MhW+BXH6E5uk1lNiprDuDW9xS+v
	c2KedEd58NNTHWClXEuCA3aYn9feCzUUF++ThKqyoX01E1qYpixToIgR2j9kxrtoFtiSoOic9G4
	EYpC9LqcjunWXCiivkPCGLftdHKdZ0Jaj5
X-Received: by 2002:a17:907:1584:b0:ba8:cad1:f6e2 with SMTP id a640c23a62f3a-ba8cad1f7abmr926756266b.23.1777195199306;
        Sun, 26 Apr 2026 02:19:59 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba454d1bbb1sm956759666b.38.2026.04.26.02.19.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 26 Apr 2026 02:19:58 -0700 (PDT)
Date: Sun, 26 Apr 2026 09:19:57 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	Gavin Guo <gavinguo@igalia.com>
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
Message-ID: <20260426091957.a227zxgkqapibtud@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65CD61A0006
X-Stat-Signature: j37t7kredi847waauq5tkahw1ckkk7rh
X-Rspam-User: 
X-HE-Tag: 1777195201-789294
X-HE-Meta: U2FsdGVkX1+gN2AZfBBei7OXJ+3c2dohxwZx07nQnUqoHof69lgr21UsyPUAE65240rQsUe80MXNX/linzsXjVOA4mrQmNp5btTs1I3wP5+WAsZbl/qrsTj/GxXbSqmwlJIiMy5nm+IjH4rBNAfUblDwgwAkLaeYTgJiep3fmNzI4WB7wAth/UduoU7m9T+kr9p4KGq6B1MR0XgwVOPZTypYXZUIbjrYDUaPrAJwltmO4AlHjzqgr53wO9U9G2cH/V9Vj3MrN8niWFdYiRDw3mrcO9z6CO4TC6e+bsyMWrIOh8xDZfChOJpWhCITTP6b/3rALW/2x8hcVjIwovtt3A/v31ZqQMKfx8EDvc8+4Knav3agmPZ70qkJHmB9GJDozNOeXaxscwykbsDP1tNmHbf/rvi7g1zHbL/RfWHwPNBfDqkxkUR8JHKTUrczRlfCZrdMeOa52Ve2c3lsXb9R6gMWKWZaDeCxApqEhPNOBG1Pz9Os5/BQAus9LTYy406tjdkF1C4i1BtR5FbtDQziWJxE67b4b5kQrp4gc1/4RM29bxpvq1FRQc1yI39R0YQzmFvxh06vK90FZQk5T6y2Ibqo1PPQ/d9qUZ0h3ueTA0K3pymoXZZVOXO+u06RuxsfPUi/cDloa7AAQt00w3Sz/Pza384tTKP0jNU6guhZLypyozt0GPjZMptd2OLltjuMaE0OFXuHLdZGhy8LKGtWMsKfGW/M8T2619DiJYrSjBTc89NFOsE9EeWlpiJQH+sJMWEaoGbRY60uGBIrYw3z37Ev5l+YDfAcCszuds1JbVN2KRRg1/EWy+y9g3d/pDKmWfTiqxwlkBWwdhBZi+Um20RPya2BoZ29QVunDyE2cX9lD7oLYVJLR+4NVBQSwKlxCYkcOc/PfehnQNB91342pLmRk26nzOAYwg3GTFtQzehgWXOrKfMpB/H41axDdxpKmVqh8biKBxz7ccB+GO5
 TZp3tI0h
 eIkaXMjd4yGXXDL9tWJoEkJNAGvvT5uO6LhybtbV0Lvip9mCVk7yHBmv/QHAg6iCAVllKSkV7fIqH9OlBqaMLx6fxIHXeSgdudqQs8yYfsC0b4YzXsyEx72nf28k6BjWXq23iCHAvBuX+i1pTvP56CEc7uKi5FNDqZLx51/KCZMQ+7msHWt3jAX2LADQobmq9TLXtRoogSJzOUSuuIHEk2pxy1DAKdXSheaCL8IE6vuKO3XfKVAdxnyhs3iKz5Q28bs121d1oDRpRx/nFn10seHvZAEgQeCsC9C5RA7+x6s1/1m/j4N0u3Z89ED2phzveAo020/YGIDAvCrFN2yl0oO49Q150tOFxL/TFlIcqRvGA+er4h/Ey5lUR9TBDggDkdF7oiwrAWGCYR0sQjQvNSJifjcKmj37PQKroWpAokEvkyVz5KJLtSVyPNyGpuMZbzq7B8j519eE+hRXmKOPntq+oC+vcMcTP2GS78hnkgMYRckJwawNIl8LS8ReeL81Q5u7FfNkxO9hYyTkXw58BTumcD26xj0EPWVLhpamIw8hELF3l3TuCa92N+kJU2+kCNC1gzM+ZtMlurbGryEUM1vxfodSz22eC9F86Gusk5Jf8yZW3OoSzb/BP39qoE6EG9gL4gr6SthuIUrsJzNtwUlWIuPyBkWYFPejZfWwjjgLtvLia6ikPfMO8+tFfV4G64hxKsM/+WDUc8oEVIOSHy1fJp8hMKfbj90cDpH4mB6u4nAEYZXIZ1VSQ+QrVXTnx/6WyjYhusq73tWVDFP5qWRT5g6jVf/WoBso/+UYEYWOMTRJhpG2SNaqfW/VbZYnE1FE0T7j0n3m4jLZNFRbVvRB509Gpn9v6Rvshnmm//S4K1N2PZgbkhp/ATRw8HR6HaEDIQprapJhvuNHMH6lmNltSMuZA5ABDxqzOrqF4ZZlGnlfEqI7ypZq/niysXVIw4PjYs0zYe77iknHRzjHWmi8z7DDW
 PcSNCFpv
 /Et8HFCwz2zM/0djS5yZSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:29:18PM +0200, David Hildenbrand (Arm) wrote:
>On 4/15/26 03:08, Wei Yang wrote:
>> When @freeze is set to true, split_huge_pmd_locked() is intended to
>> split the PMD to migration entry. But if it doesn't manage to clear
>> PageAnonExclusive(), it just split PMD and leave the folio mapped
>> through PTE.
>> 
>> This patch let split_huge_pmd_locked() return true to indicate it does
>> split PMD to migration entry. With this knowledge, we can return
>> directly in try_to_migrate_one() if it does.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Gavin Guo <gavinguo@igalia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> ---
>
>[...]
>
>>  static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>>  					 unsigned long addr, pmd_t *pmdp,
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..ec84bb4a0cc3 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3087,7 +3087,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>  	pmd_populate(mm, pmd, pgtable);
>>  }
>>  
>> -static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>> +static bool __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		unsigned long haddr, bool freeze)
>>  {
>>  	struct mm_struct *mm = vma->vm_mm;
>> @@ -3096,7 +3096,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  	pgtable_t pgtable;
>>  	pmd_t old_pmd, _pmd;
>>  	bool soft_dirty, uffd_wp = false, young = false, write = false;
>> -	bool anon_exclusive = false, dirty = false;
>> +	bool anon_exclusive = false, dirty = false, ret = false;
>>  	unsigned long addr;
>>  	pte_t *pte;
>>  	int i;
>> @@ -3118,13 +3118,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		if (arch_needs_pgtable_deposit())
>>  			zap_deposited_table(mm, pmd);
>>  		if (vma_is_special_huge(vma))
>> -			return;
>> +			return ret;
>
>Why not "return false" in these cases where it really can always only false?
>

Will adjust related places.

>>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>>  
>>  			folio = softleaf_to_folio(old_entry);
>>  		} else if (is_huge_zero_pmd(old_pmd)) {
>> -			return;
>> +			return ret;
>>  		} else {
>>  			page = pmd_page(old_pmd);
>>  			folio = page_folio(page);
>> @@ -3136,7 +3136,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			folio_put(folio);
>>  		}
>>  		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>> -		return;
>> +		return ret;
>>  	}
>>  
>>  	if (is_huge_zero_pmd(*pmd)) {
>> @@ -3149,7 +3149,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		 * small page also write protected so it does not seems useful
>>  		 * to invalidate secondary mmu at this time.
>>  		 */
>> -		return __split_huge_zero_page_pmd(vma, haddr, pmd);
>> +		__split_huge_zero_page_pmd(vma, haddr, pmd);
>> +		return ret;
>>  	}
>>  
>>  	if (pmd_is_migration_entry(*pmd)) {
>> @@ -3309,6 +3310,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>  			set_pte_at(mm, addr, pte + i, entry);
>>  		}
>> +		ret = true;
>>  	} else if (pmd_is_device_private_entry(old_pmd)) {
>>  		pte_t entry;
>>  		swp_entry_t swp_entry;
>> @@ -3366,14 +3368,17 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  
>>  	smp_wmb(); /* make pte visible before pmd */
>>  	pmd_populate(mm, pmd, pgtable);
>> +	return ret;
>>  }
>>  
>> -void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>> +bool split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>  			   pmd_t *pmd, bool freeze)
>>  {
>>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>>  	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
>> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
>> +		return __split_huge_pmd_locked(vma, pmd, address, freeze);
>> +	else
>> +		return false;
>
>No need for the "else".
>

Got it.

>>  }
>>  
>>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 78b7fb5f367c..91fb495bebbe 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2464,13 +2464,18 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>  
>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>  				/*
>> -				 * split_huge_pmd_locked() might leave the
>> +				 * If split_huge_pmd_locked() does split PMD
>> +				 * to migration entry, we are done.
>> +				 * If split_huge_pmd_locked() leave the
>>  				 * folio mapped through PTEs. Retry the walk
>>  				 * so we can detect this scenario and properly
>>  				 * abort the walk.
>
>Couldn't we just abort right away, based on the return value?
>

Here is my understanding.

We get here when page_vma_mapped_walk() touch a pmd entry, with three cases:

  * pmd_trans_huge()
  * pmd_is_migration_entry()
  * pmd_is_device_private_entry()

For the first two cases, we grab pmd_lock() and then check the condition is
still valid before return. But for case 3, after grab pmd_lock(), it return
directly.

This may give chance for another thread to split pmd_is_device_private_entry()
to pte mapped, IIUC. For this case, we should restart the walk here.

Not sure I got it correctly.

-- 
Wei Yang
Help you, Help me

