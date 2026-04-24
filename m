Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1428DFED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5539E6B00AF; Fri, 24 Apr 2026 15:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506D76B00B1; Fri, 24 Apr 2026 15:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F42D6B00B2; Fri, 24 Apr 2026 15:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1136B00AF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:29:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1F471402A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:29:30 +0000 (UTC)
X-FDA: 84694438500.24.C12A4F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0A11C1C0008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:29:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kz/F3IYP";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPDBEMMgmDfTV/OJSjXDo/CYCBkEdX9MSnfA3+/UEzk=;
	b=Rdqqlg3ABQCyuZ1VHuz/Dm9bER54YG4L3GFJA52Tq43/ZkuMusRJLRPJxn/8Yi+16/LkJA
	Wuvv9gtvcjcW2c8PY0JqIWmw/mvoZrV6nTFLsMKA7K4dJtzayOJQDkmGJ6yiGQEK+unvlp
	wWuZxQ+LvhnLLKyucGo844luDJ2iJJU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kz/F3IYP";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058969; a=rsa-sha256;
	cv=none;
	b=dF8zfEfrVZwjiXJU3/angGnjIAtXM3b8Dn+jGi2SBrlVEzTbjJkOyKR5XY5bMbB9WMWK1l
	84VQIh2HFrnvMeG3tmRJiFU3VaCoI7FIitf7Nc1YkO94uoJDCNOdeqtmgPn21zZrTWK11M
	Ks4xdbSRMPdOJq7pn6DWlZzrcX1eYfk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64EA7600AE;
	Fri, 24 Apr 2026 19:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A49C19425;
	Fri, 24 Apr 2026 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777058968;
	bh=kavgWFCSVJr+yXjb86gLc2o7iHJh/J0BL1U0+J76Rro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kz/F3IYPrZp1IphSARmdw8OPZ1EBmXc7nvbl6gA+sEJEd4zwGa7pdXqtsyWgefZ4F
	 ts21+WQctCKyn6Ab7rJ2vTVFBlFfrMF5Gq3lA5H7YdJvzq6zY+edPITRNZT8QDg/2c
	 Phf9LxvN3lIcI4ki3zhu8uA136wUT9w+VTrHN2t/btS7SueVPOtIlfAKkj3bC8zziZ
	 xHWskCpOOdjTqLmLz9sN/FF2Bzx2SJltQ65pgcg3b41K69lmGIckmpoLwm4CCPVHKj
	 vnJvan5pooE5GYvAUYSjW/KiQ50SueL3Wfy94DD2zMsyHlG4pH5I399HCL9IPFnYxL
	 froKodkU+B30w==
Message-ID: <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
Date: Fri, 24 Apr 2026 21:29:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, Gavin Guo <gavinguo@igalia.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260415010839.20124-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nex6g7rbwcrrw5t9jgz8tdt7su7cw83d
X-Rspamd-Queue-Id: 0A11C1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777058968-981257
X-HE-Meta: U2FsdGVkX18D9RRvqfJOsBeVLMbiyLNf3sSKd5SllQvtkjLXMc9LhYhroj8bfaBx0Jle/Dcwzj5boCibaUrTQml+7G0dqKWfZCN5l2ceqe9zb5PsAw775EmP8Q9yVaQEftz3sMXh0qbRSDsKQlFDjuyC297dAFoFet9R2/5lCFyo+4IznsAPNhyllMnCyv9decA0Q49gZRYMOh2wX0rx+rf9+3kcALvk9EtAgpB/FG4FhoDatjgOCLJy0Re+a0VWvz3HAZAjOQMPIjK5fOmXXDDmszbzP81FlNL/KCQ7qp78d0M7Zpk9yHCl9LVkM6LIQsFqy2QWCvt56R/oX7/kr6rZGkA95uQyBO4D2OYvGvyQvSbzaDoZXlP8yW1frd4+mqGM4biAFlSq5froOTg7hpsN4O33mozjjW/VQ518C5ZDVVYEBh8jYG7ZvQhdTB/2OfwSis1TN6laA6wHYhaao9dS0PsV49EU89fCyMW5RVe59cfXcQT67XdKmZ72nFhc5D0qX2t5vPVhheAdcUbKY+/ujkcvJMyRxAjcgbl3SxnyECHM+JXE+4kahXIsLFiyi8V55rjV0E+D10Rt6kDzHyPw6w1XpKSKeEuHflCp5iFWbF9rGbLYvL6G5bWPoY2fJrWm2ivxb0LsmNi1/zKPdFjLzbqHetCmSz8FUsxXjAz0kir1dlVpU6KKk1sbd5NC71YOkUKt4ypDV1vU93kwIKs56l5vNDzY2W2U8jdJmdN2IRvhi71u3Xrh4w0sP9T/xPjrN25+H87CwuvfC4o1oo5sCduaPkkBUXmvFRf6v5eYzUUNrqUD6Lka0QCzFEZTrNVVt7IMWhZXwiPunZIgL9yStrnhOD5UkRCMZ2pi449OOWvFeEvJyuPcIrGJp/yZv1/FjvSlzWUpwYoE69Mu9HJNPu5sG6GwKEZcBObHXA55DdVW710F1CR4LSLX7eXMkkmf4ZmOpD5hzu/pkNY
 3THkylt0
 7mupEpWioxwEnrwt4mfvL/qivj6uwJiKIK1drvOEZmaPkqH7Q81VGH2F402KyzhJVV7/8Ck0DdkS2eIkMdYWfgAxRfZPlb8GXhvWYjB32phxgUPv2U0viDofjkJY4CVkqpZOFxAMWfColst4eUP6lG4j2bgi1ssdEeyLNn4ZuB1yVjJzIzLeMJmKxCiTbJtnR8hI7QPEexyL+lke6h1zhpqPT8GjRZA2y41KhjuX3mjWsI6rL/4zxlGxnBn/hJ5GTxtjmIewV+a4cU9lFTKKjv6zCUXu53Gq1pgAOJaedFnoJQcrcS9pD+mgQF99gNtZeqx7tDCelPY+VobKzM1E2P5HTUyvvLZoKkB5FkyfWzf94EMAd+MEXI1ZBcqSl5iq/Ld82hYlL+cG+L5hwFFwE9f9l9+WwaR3NjoRZk+XWL3wS8rynxXXwxCyF42CzhreJW4B9Zr1Cd5r5TvtTYoEZa/M0Z1WZ31bqXyR/YwZTF5pmwYzTEw6tLFCsUWDSboc5nB6NG4HYUT4qZC8fNYov4jzHMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 03:08, Wei Yang wrote:
> When @freeze is set to true, split_huge_pmd_locked() is intended to
> split the PMD to migration entry. But if it doesn't manage to clear
> PageAnonExclusive(), it just split PMD and leave the folio mapped
> through PTE.
> 
> This patch let split_huge_pmd_locked() return true to indicate it does
> split PMD to migration entry. With this knowledge, we can return
> directly in try_to_migrate_one() if it does.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> ---

[...]

>  static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>  					 unsigned long addr, pmd_t *pmdp,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..ec84bb4a0cc3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3087,7 +3087,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>  	pmd_populate(mm, pmd, pgtable);
>  }
>  
> -static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
> +static bool __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long haddr, bool freeze)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
> @@ -3096,7 +3096,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  	pgtable_t pgtable;
>  	pmd_t old_pmd, _pmd;
>  	bool soft_dirty, uffd_wp = false, young = false, write = false;
> -	bool anon_exclusive = false, dirty = false;
> +	bool anon_exclusive = false, dirty = false, ret = false;
>  	unsigned long addr;
>  	pte_t *pte;
>  	int i;
> @@ -3118,13 +3118,13 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		if (arch_needs_pgtable_deposit())
>  			zap_deposited_table(mm, pmd);
>  		if (vma_is_special_huge(vma))
> -			return;
> +			return ret;

Why not "return false" in these cases where it really can always only false?

>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>  
>  			folio = softleaf_to_folio(old_entry);
>  		} else if (is_huge_zero_pmd(old_pmd)) {
> -			return;
> +			return ret;
>  		} else {
>  			page = pmd_page(old_pmd);
>  			folio = page_folio(page);
> @@ -3136,7 +3136,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			folio_put(folio);
>  		}
>  		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
> -		return;
> +		return ret;
>  	}
>  
>  	if (is_huge_zero_pmd(*pmd)) {
> @@ -3149,7 +3149,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		 * small page also write protected so it does not seems useful
>  		 * to invalidate secondary mmu at this time.
>  		 */
> -		return __split_huge_zero_page_pmd(vma, haddr, pmd);
> +		__split_huge_zero_page_pmd(vma, haddr, pmd);
> +		return ret;
>  	}
>  
>  	if (pmd_is_migration_entry(*pmd)) {
> @@ -3309,6 +3310,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>  			set_pte_at(mm, addr, pte + i, entry);
>  		}
> +		ret = true;
>  	} else if (pmd_is_device_private_entry(old_pmd)) {
>  		pte_t entry;
>  		swp_entry_t swp_entry;
> @@ -3366,14 +3368,17 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  
>  	smp_wmb(); /* make pte visible before pmd */
>  	pmd_populate(mm, pmd, pgtable);
> +	return ret;
>  }
>  
> -void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
> +bool split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>  			   pmd_t *pmd, bool freeze)
>  {
>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>  	if (pmd_trans_huge(*pmd) || pmd_is_valid_softleaf(*pmd))
> -		__split_huge_pmd_locked(vma, pmd, address, freeze);
> +		return __split_huge_pmd_locked(vma, pmd, address, freeze);
> +	else
> +		return false;

No need for the "else".

>  }
>  
>  void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 78b7fb5f367c..91fb495bebbe 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2464,13 +2464,18 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>  				/*
> -				 * split_huge_pmd_locked() might leave the
> +				 * If split_huge_pmd_locked() does split PMD
> +				 * to migration entry, we are done.
> +				 * If split_huge_pmd_locked() leave the
>  				 * folio mapped through PTEs. Retry the walk
>  				 * so we can detect this scenario and properly
>  				 * abort the walk.

Couldn't we just abort right away, based on the return value?

-- 
Cheers,

David

