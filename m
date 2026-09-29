Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D8FCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531246B00A4; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D0A6B00A5; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333886B00A6; Tue, 29 Sep 2026 17:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC4D96B00A4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77BB3140619
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:39 +0000 (UTC)
X-FDA: 85268152158.13.A2AEAC6
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FE9E10000F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JMNYrNey;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718817;
	b=uu3M8TjM5Im8+Ewr3UGM61x4bHKmJfI1KRBw150+Xl7cfl+2wVXKLodVr0AyD+jGE0Be9d
	4exuKzjD31UgnyjyYl/Go6IGLbPMl+Ik01h+tFiu3jYXOGoUKnK88nFtlgZ38xLrwQGGoN
	67dW910KqxF2fu2MX9LcHnIrltLT5Xc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JMNYrNey;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgKrYRp1LUFL5AjUxrX6ynT54MDLIAH2HK7aof3Aabc=;
	b=JbCAtMvu4q2EJm2lu7/+jMnZhyNDqGluOP8GL6qjE3zcURe+KUw6apgzWVZzyugib7W9OF
	z/hO2C3zABnLcI+oDN6pb40AjqZPDOlLK+fUNLNA4FEfA524UcCWp76vK2jNwXtIHzNLef
	9+IxW77u3o5VWpM9W/4GSwlt/tOc5CE=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49fff6f0f87so22089025e9.3
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790718816; x=1791323616; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SgKrYRp1LUFL5AjUxrX6ynT54MDLIAH2HK7aof3Aabc=;
        b=JMNYrNeyry6brsK0ryKzEFvbljhdsMMU6uUHqyDLq1ZToXkZkBb5KQ9Vm/FH14Ij6D
         MBAMeaK9WKeXnDAerShH0djHDUuvaqCi+n6wKeyuQ8HwBlHPmtbM9bCsgA+25FdTtsAf
         hovilr4TP6Btyup7ZEy8A26gFTmLEJufrjuzkHreNyO/Uf6p/1DrsNRdM/vqvPQJ0OO7
         eeaG+DH58CFIUoAeHmo0t8RQQ/6PxvyluTVQOvht3mEg0Na0cH6K2A+lZMzpl/fCmYCp
         M6Qb4I+d5qZq0V4P6YK5BzE41++mWE2W32d3ROev/caKYH8QNH0vJyHvyLy60qlnaolr
         SQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718816; x=1791323616;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SgKrYRp1LUFL5AjUxrX6ynT54MDLIAH2HK7aof3Aabc=;
        b=TrP7tpLTLkrsDrhy6spNO0l5/9k8olB+8h5TSwxkgsromFjqAb06jmVpa+smEsMvZq
         wLDWZwhYeWXnrMRRQILKr9HoBlvU9JgbQyurPfmeeoHrdKEDrt05Z2gM/CX/Ci7jV4/j
         AX6Ey91cDjdeOLWbPjrjmlpcdqkL6zHPrrIc5+2ee5bod1WtJNmCboSh/KxmiWaEZnJB
         bivOUuqnenOMSDs02eoqD2+7DtnLHT8JdJsnzbCi8sgzPMmcFtEzU1YgpPmdTQIxU/Oc
         1dHsbqMW84IsdMc9tOWg0Ufv8/yhC8vjstywZNMYqaePeqb+SONFkTMxzTM0NmeEq0k+
         o9hg==
X-Forwarded-Encrypted: i=1; AKwUvBz7OmIsyuDOrhgDiOAzUwI+uOu37BiKKFNgfgcZ6QyDBUYrBm2cxwJZhoGdULtQkgoQQERktqYGvQ==@kvack.org
X-Gm-Message-State: AFuF++mtAPT8u9fKwCkNYoEOkVQaBgN+uKmnmYAhaRZYHp9WgPPw1XQl
	1eWICJK+jz9Nt7cMfAIU1w7lHod1YKBTVGbRMIQVYLPDNzXnWZFtTyS+
X-Gm-Gg: AYBFou0fhf1Oe69r5291O8GvQbo8EJ5Cq40R2zdvlOMYORZW+r0rGhN+vLqH7ZiFRmg
	7gqB1fjHX6HJDmqW7aCKGrAA3E1t/s+ze5SUTlkVt5fbOQXsU9FpCjVk2fPTPqUy6fWXPEaVnSZ
	5lQQAlV1BRsOKWEMCVFmW2dV0LQWGJtvVtowBVZvwKOzZLZCZdEUmIXPgmhNTCVk1Jz5SfKZQV0
	F5AGGw8MDLFueX+JHkv+YkIO9Y/23qFcBr7sebC2EJ4wM0oNVjqmmQMwSfWOCYS76wwmu/PgSkh
	2mPZJOEfokW2xtkdXNJQG6PfAcFdk13/gTIn+b30fWWraenNaxHaKcvfpePrJqOICU5kRIRzJb5
	B0vBQP1LBdn9iQvRDTXtq9svSBcHv4/UcL6zRviW2X0trQi44PG0eubUegOVqEJQOBju0fHWqHt
	jImiEW8ZB2lAlpqyi4/sazNTbRCogvF7TzgArJvtPkx1VTQM/5I6SMEw7hQrTYHKIKtp4uJA==
X-Received: by 2002:a05:600c:3e0a:b0:4a0:bc9:28c6 with SMTP id 5b1f17b1804b1-4a01515947dmr6697455e9.34.1790718815951;
        Tue, 29 Sep 2026 14:53:35 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48afe61c982sm1850885f8f.5.2026.09.29.14.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 14:53:35 -0700 (PDT)
Date: Tue, 29 Sep 2026 23:53:33 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/memory: remove unused vmf_insert_mixed_mkwrite()
Message-ID: <arwuOBkR_VpZZ7fI@gmail.com>
References: <20260929143707.450805-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929143707.450805-1-ekffu200098@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: pqemu3h9gqin7j7uk7kf5j7yor7sqf6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FE9E10000F
X-HE-Tag: 1790718817-929800
X-HE-Meta: U2FsdGVkX186WSwT4GvlRPs+vcZSS1bk/QKT2Y45ZAkHQqZVlpdu7pkBY/NqKF9OAwZ3P+OVci6oL54ivD9E9EjHephvWyUwjNSxSuB18PfU7CMRj8320ejUUP7UA0wIkwmDtH6mfE3a5VfkJhwldgXHITgoa96wxMANfTZihBer0Gplbbt7d1+1iX83F02Nd1sDIuvrVwoG+3TT6i2X/85kH+joCfuLKNRoIW/BWW2XHzMrFjxa2oDlurjwasbJF59Sjtz9k+wxBe0+cBlyq24Y+Pw7DpOhQQb2p1ooMvFHzUEb/QoUKPkirLPtCSWP9HbHUDbT2pqukHlKUMbbn6I/J26sjpXD+c5g1TeQiCVsQgppGkNyW+bMbCRwHk4wYtWB+yb2OxWBeRqBhd0AzzRRNULJF27AHXZAxMMgUn8BYvo8uwDSy9bZ/QboYKaF2/bJQ9fxcY9i5la3iCuQkqZvF2dE1XfXohe3LTBVDgwtrAW+msfk110U7eaUAAuYFcVHmUIB3VE91DZs50ViaihC+0CSEP2WT7d2ObBsGpmwIozF6jBmJ6lHC/92ko5D3TGoPl1lREhTD6bt+Vys9ypj1A5lpXvQDu7MhTCRn5pahtqBQgMmBoN8PYOXQAznVuG6krOqtSeWZ4gFo2+10lnrX8oRYwlr36X/8yyb5ZaTUV6v6aQxABT7OeSZ5PHfu5mBQdtPZhemTew2LqZWTHKWZ2I8OjRP/Ab1ERLTWr2FvWKn/7Ltqu1xrmATiI/+kd5HaIbEIeyjmbxuTK8T57Z2AtyD2L2gAiffH/KF6gijx+1QFGHvIML/cSEz0/SOxqwDpEuLNOz4bJXXw6Q/YMgETzXT8038uxEGcTcpaUJQrQwnkNA0SCEqg4fcchCjB0oP8gdmLOTuEIALlLdqS8pAO9ViqY8EWDkfwLYeU0igw3uT1VScUoq7JaCTw6S8fyLus99Qdgz/oJ2+SKp
 d5cdf5dT
 ibdJtvRJNBSHgOCoQkTuIQySt/LbacdOSTTZRraJWPvqC06qyhgFu8KOBcF9UBUzPuphC9NizIHYfI6VnDACtiWRLt0uT3HkwhJ8M0RScFfbyo2WMew2BHidQIdi8UoIuXpALmVrKWpvkelGM/iMHUtWv0FGhqsGWSrCfKEO/DIG6sjmhBOrpZ16S6W58iBiNFq8vAFr0u6Ya97K9pUG1l+QK1Cl5zXVDIe5LVUUdHeckc7GhRd/0ltcw/3QkmGeiDDHLSXw/V2bnB0mylOzT9XAoPzWm+r7vjnmqkhZ0yuxvUo6iMCGA3S313T3gOlMSugK07S39BmbaJHx10Rl5BTTpt9OLfCQ5mcJL1wxWWp0XKFAwMLHxzY57f1jlwLoyZFWaG92Eo+IHgv3OLZBnckDt3BSn8qak8GyhT/Xr9zajHIzs/aiS0ic/gf52OX5XjGSCYrxFcmUKQhAi2L6UR8FcHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 11:37:06PM +0900, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers, so the mkwrite argument of
> __vm_insert_mixed() and insert_pfn() is always false.
>
> So remove the function, the mkwrite argument and the unreachable
> mkwrite branches. Also merge __vm_insert_mixed() into vmf_insert_mixed().
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  include/linux/mm.h |  2 --
>  mm/memory.c        | 76 ++++++++++++----------------------------------
>  2 files changed, 19 insertions(+), 59 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c038d06825c3..2ac734efd4ec 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn, pgprot_t pgprot);
>  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn);
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>
>  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index 330cde31bf8b..1f83a26f8733 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		if (!mkwrite)
>  			return -EBUSY;
>
> -		/* see insert_pfn(). */
> +		/*
> +		 * For read faults on private mappings the PFN passed in may
> +		 * not match the PFN we have mapped if the mapped PFN is a
> +		 * writeable COW page.  In the mkwrite case we are creating a
> +		 * writable PTE for a shared mapping and we expect the PFNs to
> +		 * match. If they don't match, we are likely racing with block
> +		 * allocation and mapping invalidation.
> +		 */
>  		if (pte_pfn(pteval) != page_to_pfn(page)) {
>  			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
>  			return -EFAULT;
> @@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
>  EXPORT_SYMBOL(vm_map_pages_zero);
>
>  static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> -			unsigned long pfn, pgprot_t prot, bool mkwrite)
> +			unsigned long pfn, pgprot_t prot)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	pte_t *pte, entry;
> @@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  	if (!pte)
>  		return VM_FAULT_OOM;
>  	entry = ptep_get(pte);
> -	if (!pte_none(entry)) {
> -		if (mkwrite) {
> -			/*
> -			 * For read faults on private mappings the PFN passed
> -			 * in may not match the PFN we have mapped if the
> -			 * mapped PFN is a writeable COW page.  In the mkwrite
> -			 * case we are creating a writable PTE for a shared
> -			 * mapping and we expect the PFNs to match. If they
> -			 * don't match, we are likely racing with block
> -			 * allocation and mapping invalidation so just skip the
> -			 * update.
> -			 */
> -			if (pte_pfn(entry) != pfn) {
> -				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
> -				goto out_unlock;
> -			}
> -			entry = pte_mkyoung(entry);
> -			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> -				update_mmu_cache(vma, addr, pte);
> -		}
> +	if (!pte_none(entry))
>  		goto out_unlock;
> -	}
>
>  	/* Ok, finally just insert the thing.. */
>  	entry = pte_mkspecial(pfn_pte(pfn, prot));
>
> -	if (mkwrite) {
> -		entry = pte_mkyoung(entry);
> -		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -	}
> -
>  	set_pte_at(mm, addr, pte, entry);
>  	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
>
> @@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>
>  	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
>
> -	return insert_pfn(vma, addr, pfn, pgprot, false);
> +	return insert_pfn(vma, addr, pfn, pgprot);
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn_prot);
>
> @@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn);
>
> -static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
> -			bool mkwrite)
> +static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
>  {
> -	if (unlikely(is_zero_pfn(pfn)) &&
> -	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
> +	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
>  		return false;
>  	/* these checks mirror the abort conditions in vm_normal_page */
>  	if (vma->vm_flags & VM_MIXEDMAP)
> @@ -3012,13 +2991,13 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
>  	return false;
>  }
>
> -static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn, bool mkwrite)
> +vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pfn)
>  {
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	int err;
>
> -	if (!vm_mixed_ok(vma, pfn, mkwrite))
> +	if (!vm_mixed_ok(vma, pfn))
>  		return VM_FAULT_SIGBUS;
>
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
> @@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>  		 * result in pfn_t_has_page() == false.
>  		 */
>  		page = pfn_to_page(pfn);
> -		err = insert_page(vma, addr, page, pgprot, mkwrite);
> +		err = insert_page(vma, addr, page, pgprot, false);
>  	} else {
> -		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
> +		return insert_pfn(vma, addr, pfn, pgprot);
>  	}
>
>  	if (err == -ENOMEM)
> @@ -3057,6 +3036,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>
>  	return VM_FAULT_NOPAGE;
>  }
> +EXPORT_SYMBOL(vmf_insert_mixed);
>
>  vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  			bool write)
> @@ -3078,24 +3058,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  }
>  EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
>
> -vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn, false);
> -}
> -EXPORT_SYMBOL(vmf_insert_mixed);
> -
> -/*
> - *  If the insertion of PTE failed because someone else already added a
> - *  different entry in the mean time, we treat that as success as we assume
> - *  the same entry was actually inserted.
> - */

it reads to me like it describes the -EBUSY handling rather than
vmf_insert_mixed_mkwrite() itself, and that handling is still there in
__vm_insert_mixed(), which this patch renames to vmf_insert_mixed(). so
I would have expected it to move above the "if (err < 0 && err != -EBUSY)"
there rather than go away with the wrapper.

am I missing a reason to drop it? because, if not, moving it would keep
one explanation we have for why -EBUSY is not treated as an error there.

> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn, true);
> -}
> -
>  /*
>   * maps a range of physical memory into the requested pages. the old
>   * mappings are removed. any references to nonexistent pages results
>
> base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
> --
> 2.43.0
>
>

overall, looks good to me. but I want to know about the comment.

--
cheers,
jose a. p-a

