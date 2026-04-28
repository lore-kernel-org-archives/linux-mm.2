Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEF0FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4396B0096; Tue, 28 Apr 2026 04:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75516B0099; Tue, 28 Apr 2026 04:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64A26B009B; Tue, 28 Apr 2026 04:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1CA16B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:24:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48A0440421
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:24:53 +0000 (UTC)
X-FDA: 84707278866.17.96D4AD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8EAD3C000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:24:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rq2g6itF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kl9plSYya29YBeTxwNBrUzw/z6Exv/Si0DhUaCe5cI8=;
	b=IgrbyKU+56rH783Uzjh0tCnZPYQxusAzgTXYjOy3WopOudTLRbPUknI/sx2R3MjAuJZlvQ
	GYwW6c7qhpXdli7UrazsJKa0+9rUtQ9/14Au8ct0K7VgTiTdNXL49KdfPnrBI+lX3GWG4u
	bscC8/8TGaNBESgvOY21uRUEZ/pOD4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364691; a=rsa-sha256;
	cv=none;
	b=X9p/zZBigLmE+j8IUz9QYuivsEyIVnC38nlkknhdyrrw/sMTifYX4gXvPjkSxmTYam2OyH
	dMIe1kCcJaEkBtFiSUyIfG6Ec98OIOBjvFS35NwJVpfQfmlf6XVpaesPM2IY1EPzi1HfFg
	6Rz0Rq1AiOHO5OEn39F96XUju8WI/NY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rq2g6itF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA29060142;
	Tue, 28 Apr 2026 08:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C45C2BCAF;
	Tue, 28 Apr 2026 08:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777364690;
	bh=BuBD+B3KjaLGM+cuwGM0YX6GxNQ9f7gGmlxYjNR9YHU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rq2g6itFGPzC5B/NbC48GPVPtOm2DxQsOPeqABJmdCwIsyRcQuLqv50l8MEg1gPjz
	 oykmS98fvUsS96ls4vuvf45GMeFTCR+HI9XIl3F4TT+to+GutI+XBk/DKnA2mR81Sm
	 2qHWdk2ipcoXcmZmPgcPH6grudsHXLMWJAto+I/cJJYlYZcl81Cunf1EwWdVSd//H1
	 oM7xbbubKjFOz2Jwzo7Q1Rm0ym9KwIaK7dB8hLtuz/QcMqeYIZEH7tgxhX190x2gkD
	 ZFw0OV0FmTYEHhZS5Hu2YqRMMMw46MK71MVbB9I4RaOb0MK2RFuidPjJkHn3xo/dyk
	 GbGtenqhrZZoQ==
Message-ID: <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
Date: Tue, 28 Apr 2026 10:24:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, Gavin Guo <gavinguo@igalia.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
 <20260426091957.a227zxgkqapibtud@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260426091957.a227zxgkqapibtud@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8EAD3C000D
X-Stat-Signature: 34hggp9a13rhtxgz9h7drnftj7uhkm5u
X-Rspam-User: 
X-HE-Tag: 1777364691-586071
X-HE-Meta: U2FsdGVkX1/LSkd/ykNQH1zm0NHSnjcJYGL2NPj3qm/0CkIqte+dZXX7V5zlinICMiubueYY/h4hJqTqF/0VrPlKtfmNlpFAMt8EzPLhy7t9n4Ntz44zmK7Y7soqLtPhWrV7nyqoZ6HJAXsAMg34FZiAeDHmyG4g44DJS+A+uo2/8culJ9QDBKgHg5+K7f7vBnrt42RJFYebdnmoR123qv4xOFUVFMPnv2X+EeA6HyPloh/GC48R7ozT4tChoQgDZC1YZOL+faB1Hwpe2kac4+1nQ9CJpRRYbvIe7rOHr/dRt+s8R3XRRFeXOoYS4FBHvyv0+8vERW0Z4/Tv392YMkvgTudoKes12tHSuIgwLDR+1ZMCeZ8aolB4d4qaXpfTLXLQZlrbECBAKMwTvgnUT1B0Rv+EYpeacHXWGugco13XCakjUMHFnUcq26ELdRjRL0Qoq8p+1MHFy4RgWmaPM6ETKx4914TodYrdk8H4WgKgk94wn/o6k68XHjrfmbBNhXZKxI6VXYLNBuDZAeO/4E1HdM0xGJDmKEc/qgcjvttmaNQznfSmzvvrer2Ebo93MwEgrqFUAWLvh4QsUyrBw+zwd/+HECTlYOQc/wHpU/UFYFpByLOp2xwQO5q+vHeTgfUJx9LSpLXf15FZCoOqtwZDMGFuqR/02Ncyb6xCQzbbcr0BH2kQMdOhnZ1uc+yXOxqU4dLQF9ExoGGdu5TuahWYDXK+WQ9BOW5bBvVtXpebrWo+MUUdGUpNzAw/Br+WwPrFnayldGKrweUL9rWNsEQUElAjMESk5HB3A+a7POX4DCk9VAevQxlcD+i8TFxV8QqXYmSfLvngADRAwhSFgew77USRJPA9cN1ZF5ccplcv6WpX2SmMElW2Ppy2+6LTajcvXxJHVaCS7zrrAMVmPPM90EjfnsYgCeW+ipwQJPPf2hfj2BkPFjQM8R6X0pdsmhUU+kKKoA8lHOy/Sq8
 hrGXiWIc
 xifACvTNsLhiqUXfuae0nQ9c4tjiF8PJ3V9rb6IFU9vOT6gWz67bgD1FHQ2KwmYsw5/YuB1OOQPBKlqXl8h4TJky57Was3ZduMXHvcvDx0/ceMnFd0fiiHQOjqI9XaR80NO9Za/3j6/dH+3iQCdN7nUnTn0OrK4mS2AruebhtqgcYB/KrzrW3M3vlUvTvMsvnwB6+bZ5H+oEAo1Z8haw45z23VytEEyZqFWuJ3V5CBEd4xqF4gGMCuCVOz7/cF6sVGXWmsqBBcFkx61+hsGXfptsMswHtaMuz3gtT6pAKaUU13RwKdOanIpqgFZcz5F8FdLL0gcCm9frNUAU8B86xW+H8oCMjXtSwKBHWf0o8wHOx5Ei9n6NItTkG3caSt/DnRsLq/aqzSWoevty8aTwJlyO+zPOB/ohRub5HOwZd1Ni+7h+sQW5yFYOKcQkJWzaH9vKacyiJqZPpQFOJuFrrJNC06euXQILs4NB+A4dCKLJKM1DFrov+pZGtSoqKoO7l5bD7qATd0j1ZY1g5fMfo4GO0PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/26/26 11:19, Wei Yang wrote:
> On Fri, Apr 24, 2026 at 09:29:18PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/15/26 03:08, Wei Yang wrote:
>>> When @freeze is set to true, split_huge_pmd_locked() is intended to
>>> split the PMD to migration entry. But if it doesn't manage to clear
>>> PageAnonExclusive(), it just split PMD and leave the folio mapped
>>> through PTE.
>>>
>>> This patch let split_huge_pmd_locked() return true to indicate it does
>>> split PMD to migration entry. With this knowledge, we can return
>>> directly in try_to_migrate_one() if it does.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: Lance Yang <lance.yang@linux.dev>
>>> ---
>>
>> [...]
>>
>>>  static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>>>  					 unsigned long addr, pmd_t *pmdp,
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 970e077019b7..ec84bb4a0cc3 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3087,7 +3087,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>  	pmd_populate(mm, pmd, pgtable);
>>>  }
>>>  
>>> -static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>> +static bool __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  		unsigned long haddr, bool freeze)
>>>  {
>>>  	struct mm_struct *mm = vma->vm_mm;
>>> @@ -3096,7 +3096,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  	pgtable_t pgtable;
>>>  	pmd_t old_pmd, _pmd;
>>>  	bool soft_dirty, uffd_wp = false, young = false, write = false;
>>> -	bool anon_exclusive = false, dirty = false;
>>> +	bool anon_exclusive = false, dirty = false, ret = false;
>>>  	unsigned long addr;
>>>  	pte_t *pte;
>>>  	int i;
>>> @@ -3118,13 +3118,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  		if (arch_needs_pgtable_deposit())
>>>  			zap_deposited_table(mm, pmd);
>>>  		if (vma_is_special_huge(vma))
>>> -			return;
>>> +			return ret;
>>
>> Why not "return false" in these cases where it really can always only false?
>>
> 
> Will adjust related places.
> 
>>>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>>>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>>>  
>>>  			folio = softleaf_to_folio(old_entry);
>>>  		} else if (is_huge_zero_pmd(old_pmd)) {
>>> -			return;
>>> +			return ret;
>>>  		} else {
>>>  			page = pmd_page(old_pmd);
>>>  			folio = page_folio(page);
>>> @@ -3136,7 +3136,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  			folio_put(folio);
>>>  		}
>>>  		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>>> -		return;
>>> +		return ret;
>>>  	}
>>>  
>>>  	if (is_huge_zero_pmd(*pmd)) {
>>> @@ -3149,7 +3149,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  		 * small page also write protected so it does not seems useful
>>>  		 * to invalidate secondary mmu at this time.
>>>  		 */
>>> -		return __split_huge_zero_page_pmd(vma, haddr, pmd);
>>> +		__split_huge_zero_page_pmd(vma, haddr, pmd);
>>> +		return ret;
>>>  	}
>>>  
>>>  	if (pmd_is_migration_entry(*pmd)) {
>>> @@ -3309,6 +3310,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>>  			set_pte_at(mm, addr, pte + i, entry);
>>>  		}
>>> +		ret = true;
>>>  	} else if (pmd_is_device_private_entry(old_pmd)) {
>>>  		pte_t entry;
>>>  		swp_entry_t swp_entry;
>>> @@ -3366,14 +3368,17 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  
>>>  	smp_wmb(); /* make pte visible before pmd */
>>>  	pmd_populate(mm, pmd, pgtable);
>>> +	return ret;
>>>  }
>>>  
>>> -void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>> +bool split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>>  			   pmd_t *pmd, bool freeze)
>>>  {
>>>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>>>  	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
>>> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
>>> +		return __split_huge_pmd_locked(vma, pmd, address, freeze);
>>> +	else
>>> +		return false;
>>
>> No need for the "else".
>>
> 
> Got it.
> 
>>>  }
>>>  
>>>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 78b7fb5f367c..91fb495bebbe 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2464,13 +2464,18 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>  
>>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>  				/*
>>> -				 * split_huge_pmd_locked() might leave the
>>> +				 * If split_huge_pmd_locked() does split PMD
>>> +				 * to migration entry, we are done.
>>> +				 * If split_huge_pmd_locked() leave the
>>>  				 * folio mapped through PTEs. Retry the walk
>>>  				 * so we can detect this scenario and properly
>>>  				 * abort the walk.
>>
>> Couldn't we just abort right away, based on the return value?
>>
> 
> Here is my understanding.
> 
> We get here when page_vma_mapped_walk() touch a pmd entry, with three cases:
> 
>   * pmd_trans_huge()
>   * pmd_is_migration_entry()
>   * pmd_is_device_private_entry()
> 
> For the first two cases, we grab pmd_lock() and then check the condition is
> still valid before return. But for case 3, after grab pmd_lock(), it return
> directly.
> 
> This may give chance for another thread to split pmd_is_device_private_entry()
> to pte mapped, IIUC. For this case, we should restart the walk here.


So what you are saying is that we should re-validate in page_vma_mapped_walk()
that we indeed still have a device-private entry after grabbing the lock?

That's what we do in map_pte() through pmd_same() check.

Likely we should apply the same model here!


-- 
Cheers,

David

