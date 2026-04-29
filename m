Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051C0FF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 02:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DE66B008A; Tue, 28 Apr 2026 22:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41EB66B0092; Tue, 28 Apr 2026 22:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C9C6B0093; Tue, 28 Apr 2026 22:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2008A6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:49:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA6891B9D5C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:49:18 +0000 (UTC)
X-FDA: 84710061996.13.5A450D6
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB646180004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:49:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jDAZSUwS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777430956;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVhIUE6vLQiE3ZEYrR77MvhMrAn8IFG5TLTj/E1ieyA=;
	b=R4T7biLo7gTYwjULwdFUTpCr+KGOeSOC2Vd3hHXE/mwYVMcBnVAf4bXIQY70pqH09E5mss
	8hffR/Z1iaYa1mFvozBlOSoIvXLfxivr8cKN4Dd0DuVxJ2n+KV/A/m1MAA5VxcqoZyUptt
	2v3P+82C7KhEKRQ88hzP+WEjlB+FhQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777430956; a=rsa-sha256;
	cv=none;
	b=u6O749ZVCiJsNi3HvXufuRskz7XGLtPsetSDbI1pUY8xiW2JGya2SbE/6LD0Z25QOWy8DP
	pvQAV2xTP9R9y0RQ2/LyN7SK4gKszpg6D8cYLAWLZm+AYf8X8yrstywjyMBiMEpYftf6aD
	RBiAHz/3+nh1GvKaHHZHPsJ5mOlih5k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jDAZSUwS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8f9568e074so1990365866b.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777430955; x=1778035755; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVhIUE6vLQiE3ZEYrR77MvhMrAn8IFG5TLTj/E1ieyA=;
        b=jDAZSUwS1lIq0LMghLtIAjfeQFprFhoCea7IUljpHmOOV0PWgjHs+P54LVzLPqgTMS
         Tk3YoDYUfqigM7JIBfd2XTofjGj07CAyemoDoI+65aZAcZ0iW+Z4b0QkUg3jF+q7Lxxe
         hDkw+tgMX2QTQEZEwnxEewtE3FKjKKBvxlBkFdAVj6jQCOyL9oP4H6XKq3qouuXWZ9sE
         CNImyT+B5dwWWxeBu96NwiVJm9X4ADWZ7EIy/Q7T9t5rn/6sPcq9Vzc9pTYNkBOhZXGg
         7XUZRPI4477ll0MHWv37EokS01SPNjydc+adxa+KBNxgUkEOq3bBHQJOScDAwY5+jLsZ
         ZnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777430955; x=1778035755;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVhIUE6vLQiE3ZEYrR77MvhMrAn8IFG5TLTj/E1ieyA=;
        b=rydF45xsnfAEVvH/w/iRuVmoaeYs9AmMy6DgeK2ezbG+3y7CEfo6z10D5O4Cy1+lCx
         FSH3fKhXTXL8Aw4sCfFXcZ1qnJGWDFNPaTkeWP+rnWzrDKuMMlQvSeDmFOQ70wmIXEK7
         bB5EtNsLbO5b6s1jku9O2LSciPt6F9dKy3C+tC6qApUgmqbRPom3MXKqEYy2xSGgQSUG
         yL3edCRWk1laW3qI7Icx87TIqDOCsSItJ6a1gPwFf5RNYVGPO0fVZe7NCjUJLkERnC8C
         T7xesfDHxGgusL6cRABrQ2+wWOu/n42kVT5sw7Rj8/UPd7w+fSpHCTiLxgjTgFM84EGr
         UE9A==
X-Forwarded-Encrypted: i=1; AFNElJ+xu7PC9uQ8+uz3kEWDS8nraQTgpkaknKll1d8L+1bib99l56Haq3GmrH9hMuvQSI63XizzuRvk3g==@kvack.org
X-Gm-Message-State: AOJu0YwKVQFH7gcLC/01XsqRLjJZyoT5iiP5SnxlaUikbnB0mFxIyTQf
	K8GN8oBgsefDQmyKO4+Hu0CYMDDGy1kPBbT84bJEi7s8xMXP5/9K1MR6
X-Gm-Gg: AeBDieuiCGUecCxZIKJgHqRk4bU9upV4ZIGh+FfMkYxnE86XQ+k6pCWiG0JBGUEYUH8
	q7Q8Dtat0w0vi/Z1QFoKyJZmzpY3b58+UNssbPYEJ/OnjfYazwZxV8jJ3IlytNTMpGtWVVUWuj6
	7egz7pTN2+pHqM1LWnwOe7/TvsjSNADI1vYrtUxCiSb554OIBYJ8VS4Okvk4jdEVyRv2hdbEHSY
	l76mwID3f5H/ZtU9aNQczJgdRSQ25tHlZsp7+Oc4A+HuY8Jugcd2Cfqop0Fm5NbPgrquJf32q0C
	RDW5c4lou1k+ZxiJbzj76osan8/03E6eR+pTOjcOOw0R5YNvgrEApwITz1zPwQJ9eCVMffku8gO
	Xudv06zR65KFAFlHbsqGFeO0SPkerCM2bksblDtvRt93eY9hC7RgJI0qr5UzJSQ0HLbH6DXLbwG
	8We32A5FiAmWdTxfvWyTkZN1IGjJXFdNvL
X-Received: by 2002:a17:906:7306:b0:b98:2462:959d with SMTP id a640c23a62f3a-bb803778b89mr360849366b.31.1777430954827;
        Tue, 28 Apr 2026 19:49:14 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb98543bf48sm22393666b.41.2026.04.28.19.49.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2026 19:49:13 -0700 (PDT)
Date: Wed, 29 Apr 2026 02:49:13 +0000
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
Message-ID: <20260429024913.iepoi7cit3xnwca2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
 <20260426091957.a227zxgkqapibtud@master>
 <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB646180004
X-Stat-Signature: y6sjdr1thdhouhn39e9w87e5sjcebgkc
X-Rspam-User: 
X-HE-Tag: 1777430956-645056
X-HE-Meta: U2FsdGVkX1/XvZyu2kN4VB3HLoP6uGy5E72MnjXti7YbarVxdFd1KO38Du3mGVX3R3Wpr0ya310nh+IzjyZH7yPB3nqVZ8v2TL0gZOKI9d0n/FSRCBN+6BwFx3sq0VXQawKJ37sR9l1Zhym0LrSBPSnNs9a35gaoZl40u/rvdNX//bucGWUFh+zSH2ZQlKFpICN+SOcM7kCnAUZU/gKW6ZY902CcCMMixFPgZ8NIDwQ+Yan/OrN2EDP4z8OfbTGOjvU+F/hsd3UuETLdl/Xte8w1Ii9pIp2LkllSx0JPbY0An8b7u7VtadD7jRv+Z2DGzMBe2Y7TS2EyAqasHFooeLs0joYJlyaw2r71sl6Q6lujNcGkbuIEisaOAJMMc+Os6uz4EqdpXkkxY4y5hTb0qmn/5t6JwfYwD2Un/OD64dCeFswUFu0ea73YI2ippoUU0uzyJYShL5ThcEKQX1kO/q+NytmpkeJmi0xYNlOJIm9yQPAPKpEAS+txunY4OjoeBC/oUtHZhRdlTbbuItoOgAKeu1OmVSUyhMdokAKOSPDIgyyZGsiJ44JFq01kVxEtZ07F2s/KNoe73ghDMz45eQo0AQmyFbw5sOh2hYctPsyj5P+HIBnMee7YHd4rwRjk5AzN2P/rP29v54kVTxSsaUEbn1JqMJW9S3+1+7xLDzaEihrf/F4urvJWE32uEjdtuMPaBWafLT4/RHi/mxdJ+n4xABYQhFhXWvbU7kcZelCf2y+Qe/b1+sWwV7dyfmBzXSDP1DFSngyMx9b/AbsSUJY9cYguHkDpn6RcQ8UL2vp89fF+OsDO1/c1W47dM+LLSf4MFWzJptbDfNtgP/szWxrLfVuuYCAx7Dg5VeVy3FXL2ukx9ZOn//L6rZ+pXPG66cruMpRCzgjLoB2kxiTfF8FlHn1MsbDLod91kdv4izEMNzQAlpzfGzcIl77QW2T9iM13w/mcmzVBgtWyMTC
 VVC6+GuC
 9InuFYAllFjqVH/FheaHkOXhKQCSY1DEpMiPeRlLPIWWV5DtiykHXcVFQ6egc4iLbVcf6ce5KZkPLr3B8BlHvrikuMe4gK/p9mKEau1tbCFFFzukUp1OFFQnHko4/+b9iZ9fwkHxlkvMGEi1/k3PyhkI4JoRAxqsXfHR8LRyAPOEM0nHrU0nrdw7q+WnaFep9fMKCPXgDyrNQThljZHLq5XP//C1YAwURBdp/zajjnhMmyBhB7ri7K/6PO4QhPJBdKbmkw916m5wNZSmbvL4lrHDo45vKif7hW62oUDZrXgxejVGMEdAOoKbVpWqcjjVosg3Or4Py9HPpyGKmF2UsA/FphoIyz6ndXg+0yc2Rzu76AjqoaeA30ONouI6/iC1oQLh7Kufpf7CflLrXfDAIfzgGiArkpI6xVjLKdBBmmdTnuwXgaL/ntp7s4E2Es2laPnBLB6W9azZkpw9m+Nzu0TiG67K+lw2ae5ImFuET1sfsHtrZED7A91zl3+lTZ4xQKASxC5M+yysYa4kPBofHSEPOkERskdkjmtk9V3m47C3/kds8wYCMHraT6X0JnH/qnqNeWWjyL9E0NGDYbcFYOdzi3qew6k3XQXgwfCwHp4uO2aZGpuX3gLCd+bhHCd4FEbgO44ZjOoqDqyFbA4LvHoePidt5Hd+mGNDxueljx4rS9x0D1e5T7yRRgQng0TmWpOyAmkrmSImZEVAS64qpjdwTZecfevCt7Lz1tCUdaw/ZLcAIiuYbJh2011QcHZR5b27cbzvBV2/Lb0FdUXgiKTkDKeyobfQXuFvb7hY8aylS3cCW2oF2DZIWmfFMAGFM9cWdVXq9p9yZNmmyUxzdBJGA4Uj2onpRt+Jh3Te8ec4pgSTypASLeYfOXdpGvHfyqY/P6HocayqFCnM1R3xj+2JvrEACZVW5LQPb5mNxPJ4iNufzk0RwBi9iBiomt8BNjSSwF7YYN72AKEJf4mjM2EGbVAMA
 cFCacrSZ
 Pas/qdNDiur+4f6LZEBB7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 10:24:42AM +0200, David Hildenbrand (Arm) wrote:
>On 4/26/26 11:19, Wei Yang wrote:
>> On Fri, Apr 24, 2026 at 09:29:18PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/15/26 03:08, Wei Yang wrote:
>>>> When @freeze is set to true, split_huge_pmd_locked() is intended to
>>>> split the PMD to migration entry. But if it doesn't manage to clear
>>>> PageAnonExclusive(), it just split PMD and leave the folio mapped
>>>> through PTE.
>>>>
>>>> This patch let split_huge_pmd_locked() return true to indicate it does
>>>> split PMD to migration entry. With this knowledge, we can return
>>>> directly in try_to_migrate_one() if it does.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>
>>> [...]
>>>
>>>>  static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>>>>  					 unsigned long addr, pmd_t *pmdp,
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 970e077019b7..ec84bb4a0cc3 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3087,7 +3087,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>>>>  	pmd_populate(mm, pmd, pgtable);
>>>>  }
>>>>  
>>>> -static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>> +static bool __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  		unsigned long haddr, bool freeze)
>>>>  {
>>>>  	struct mm_struct *mm = vma->vm_mm;
>>>> @@ -3096,7 +3096,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  	pgtable_t pgtable;
>>>>  	pmd_t old_pmd, _pmd;
>>>>  	bool soft_dirty, uffd_wp = false, young = false, write = false;
>>>> -	bool anon_exclusive = false, dirty = false;
>>>> +	bool anon_exclusive = false, dirty = false, ret = false;
>>>>  	unsigned long addr;
>>>>  	pte_t *pte;
>>>>  	int i;
>>>> @@ -3118,13 +3118,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  		if (arch_needs_pgtable_deposit())
>>>>  			zap_deposited_table(mm, pmd);
>>>>  		if (vma_is_special_huge(vma))
>>>> -			return;
>>>> +			return ret;
>>>
>>> Why not "return false" in these cases where it really can always only false?
>>>
>> 
>> Will adjust related places.
>> 
>>>>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>>>>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>>>>  
>>>>  			folio = softleaf_to_folio(old_entry);
>>>>  		} else if (is_huge_zero_pmd(old_pmd)) {
>>>> -			return;
>>>> +			return ret;
>>>>  		} else {
>>>>  			page = pmd_page(old_pmd);
>>>>  			folio = page_folio(page);
>>>> @@ -3136,7 +3136,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  			folio_put(folio);
>>>>  		}
>>>>  		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
>>>> -		return;
>>>> +		return ret;
>>>>  	}
>>>>  
>>>>  	if (is_huge_zero_pmd(*pmd)) {
>>>> @@ -3149,7 +3149,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  		 * small page also write protected so it does not seems useful
>>>>  		 * to invalidate secondary mmu at this time.
>>>>  		 */
>>>> -		return __split_huge_zero_page_pmd(vma, haddr, pmd);
>>>> +		__split_huge_zero_page_pmd(vma, haddr, pmd);
>>>> +		return ret;
>>>>  	}
>>>>  
>>>>  	if (pmd_is_migration_entry(*pmd)) {
>>>> @@ -3309,6 +3310,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>>>  			set_pte_at(mm, addr, pte + i, entry);
>>>>  		}
>>>> +		ret = true;
>>>>  	} else if (pmd_is_device_private_entry(old_pmd)) {
>>>>  		pte_t entry;
>>>>  		swp_entry_t swp_entry;
>>>> @@ -3366,14 +3368,17 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>>  
>>>>  	smp_wmb(); /* make pte visible before pmd */
>>>>  	pmd_populate(mm, pmd, pgtable);
>>>> +	return ret;
>>>>  }
>>>>  
>>>> -void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>>> +bool split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>>>  			   pmd_t *pmd, bool freeze)
>>>>  {
>>>>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>>>>  	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
>>>> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
>>>> +		return __split_huge_pmd_locked(vma, pmd, address, freeze);
>>>> +	else
>>>> +		return false;
>>>
>>> No need for the "else".
>>>
>> 
>> Got it.
>> 
>>>>  }
>>>>  
>>>>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 78b7fb5f367c..91fb495bebbe 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2464,13 +2464,18 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>  
>>>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>  				/*
>>>> -				 * split_huge_pmd_locked() might leave the
>>>> +				 * If split_huge_pmd_locked() does split PMD
>>>> +				 * to migration entry, we are done.
>>>> +				 * If split_huge_pmd_locked() leave the
>>>>  				 * folio mapped through PTEs. Retry the walk
>>>>  				 * so we can detect this scenario and properly
>>>>  				 * abort the walk.
>>>
>>> Couldn't we just abort right away, based on the return value?
>>>
>> 
>> Here is my understanding.
>> 
>> We get here when page_vma_mapped_walk() touch a pmd entry, with three cases:
>> 
>>   * pmd_trans_huge()
>>   * pmd_is_migration_entry()
>>   * pmd_is_device_private_entry()
>> 
>> For the first two cases, we grab pmd_lock() and then check the condition is
>> still valid before return. But for case 3, after grab pmd_lock(), it return
>> directly.
>> 
>> This may give chance for another thread to split pmd_is_device_private_entry()
>> to pte mapped, IIUC. For this case, we should restart the walk here.
>
>
>So what you are saying is that we should re-validate in page_vma_mapped_walk()
>that we indeed still have a device-private entry after grabbing the lock?
>
>That's what we do in map_pte() through pmd_same() check.
>
>Likely we should apply the same model here!
>

Below is my proposed change:

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a4d52fdb3056..6e915d35ae54 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -273,17 +273,21 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 
 			if (softleaf_is_device_private(entry)) {
 				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
-				return true;
+				if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))
+					return true;
+				/* THP pmd was split under us: handle on pte level */
+				spin_unlock(pvmw->ptl);
+				pvmw->ptl = NULL;
+			} else {
+				if ((pvmw->flags & PVMW_SYNC) &&
+				    thp_vma_suitable_order(vma, pvmw->address,
+							   PMD_ORDER) &&
+				    (pvmw->nr_pages >= HPAGE_PMD_NR))
+					sync_with_folio_pmd_zap(mm, pvmw->pmd);
+
+				step_forward(pvmw, PMD_SIZE);
+				continue;
 			}
-
-			if ((pvmw->flags & PVMW_SYNC) &&
-			    thp_vma_suitable_order(vma, pvmw->address,
-						   PMD_ORDER) &&
-			    (pvmw->nr_pages >= HPAGE_PMD_NR))
-				sync_with_folio_pmd_zap(mm, pvmw->pmd);
-
-			step_forward(pvmw, PMD_SIZE);
-			continue;
 		}
 		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)

After this, we could simplify the logic in try_to_migrate_one() as:

@@ -2471,14 +2471,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
                                 * so we can detect this scenario and properly
                                 * abort the walk.
                                 */
-                               if (split_huge_pmd_locked(vma, pvmw.address,
-                                                     pvmw.pmd, true)) {
-                                       page_vma_mapped_walk_done(&pvmw);
-                                       break;
-                               }
-                               flags &= ~TTU_SPLIT_HUGE_PMD;
-                               page_vma_mapped_walk_restart(&pvmw);
-                               continue;
+                               ret = split_huge_pmd_locked(vma, pvmw.address,
+                                                     pvmw.pmd, true);
+                               page_vma_mapped_walk_done(&pvmw);
+                               break;
                        }
-- 
Wei Yang
Help you, Help me

