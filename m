Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D08EE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296F86B0088; Thu, 12 Feb 2026 10:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244306B0089; Thu, 12 Feb 2026 10:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1192E6B008A; Thu, 12 Feb 2026 10:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25946B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:55:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B94E1601D4
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:55:44 +0000 (UTC)
X-FDA: 84436255008.06.09A8C7B
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id AACAEC000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:55:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J5hRBPsT;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770911742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80BMXqYZnRP+l4Whym0ERcqzOxVWFsGz4LdhGlNuIrs=;
	b=bl23Uso8hwhJDX0n0fBzlbZ0390Kd3JTnvgtqwpouxwYBaOhqjjAw5PGUm+O/r4gp/Be5X
	9FfDniJlHKXNFZWsC02gEgTb2jbrXPvthxmGRRar1qJqcnKRof3RF6Q++tYtUcYVjOAn9+
	IoyL7mDmJjuHgWQhLQjkmi9t9Ht/u4U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J5hRBPsT;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770911742; a=rsa-sha256;
	cv=none;
	b=qS6W3PG5divIdCpEER8SNVMxcqiCJrgQAR1bv2KN9WFTzjhc1bRLyX3+fUclNGs7NwKjmL
	fogYjr9LAVUJfPGGS12a4ZbhZoFmqolBFrAh86THtw7ScS7T1IeDRNQDPAqI8m/LN7COcq
	ZoX3VYQTwb8yKUELjk7Wl16ZuMcy2Bo=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d4be94eeacso130846a34.2
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770911741; x=1771516541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80BMXqYZnRP+l4Whym0ERcqzOxVWFsGz4LdhGlNuIrs=;
        b=J5hRBPsTt42KusXjjjDSWJHAa2YFjA4Lq2rt4zkIzEJlIhifLq1KNb8zFG5qZl9sak
         gbD7g4y+XiFoUpGCUJ4MMJj3sBAi3JlRvQjJxdzFki6sLbIhmsSLiRoEtIdCivfN+h/Q
         ah3X4jh8aZNn9Ltd+vbuoEe4piI5yokZbjLlfEMgT2WfJl0m5lcJOxMwPU65w/Ug9CL4
         ffBWJrkWr08VLFXSCojrYjRhmS2m6mQL0AflrLILLUUaXWyIE/LoShKKqk3nOqjgNLak
         jDtPj2R6GRr8f0N/9xPvdQSo0UvCdnU1etuVQNRl5Nr2pTwwTPLCGCbJc1qW8JXgOlRR
         DiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770911741; x=1771516541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=80BMXqYZnRP+l4Whym0ERcqzOxVWFsGz4LdhGlNuIrs=;
        b=Pv/IM8w9d0gqr6Gd88SAP440x/kQ6JExN+PbEwlaENLybQHACPe1mx9x10KPCHO5wa
         GOoF1eIlAIdd1HZr+00oCsXSfSj+ZaYGTfGDBY2/uTSB9Es4b5idHZzNTbOC0toRFTdp
         xVyyCis7759S6F3mT05h7LfFklHiZZ/kKxQaQil4ITy69WDeo/rlrWdrKOh5OUY+eaYB
         liWY3wxcuO5mdiuSNSKoEtJw97ERs0ijeOWk/lpDJUS36+HEJJZs8KAjnGJD5905Vald
         4XNCbC0sFMJKkeexjhbj9I+7wmeYiDGrXVojcybh4/xG3MMAjlFU+6M1fpXGnw9DL2Xm
         17EA==
X-Forwarded-Encrypted: i=1; AJvYcCUZhXpiAgZmakLeyFrPMAzPp1EW7LnLL0hXp3s+7EjXL9i/FYofKUQyV1F6S8wlCsyrJhOlMjQZlQ==@kvack.org
X-Gm-Message-State: AOJu0YzJh19SAnDplPB6b/WfbFnUThsK4w03sMR+asM653WSxrNEjnl/
	JI4FtJkefwOLKyfD1KwRa9Z9aCMNa+17IhIqJcW+Uh5sl+i+V1Z+a/iF
X-Gm-Gg: AZuq6aIleTX+H/e8OqPB4PA9iKQcvEnwUCc/6z4dzAHyf9oI/IwF/D6WUqkkwDhjv7+
	53j80dlNf8It1WWAr0lWeFE3WDBIdymbwvVaBJCdzBPQsFdct9L01DNHQsxXiuv5g8aVY8SWKWG
	jCZwUWq+C7hRS3PDJugRRNNtUgRSr16QiBMdgr9nbQ7b3uEi1VnUmcNkZG7tGzPPDpgxD839Bx2
	wDItXocWrAk2qZH83sfsKfGjR9Eq1hL8v4/rFd73s96nMYjHD9dZT7uxIJIWLvL9I+mzdGBJ/Sj
	0NrqOh+JN9PPivag8CpzBNnYyjbyAYGhAwJYN8EWqkZRJRmuU31UVOR945VsdCM++R/gtGpqeTV
	OU56+Lb5TxWO7tT1xDPG+w5rg1BJ6GnRPbAI+fPkurH6Dq5iGb38bncKc+SWaXiQum+J4qr5th+
	JlIGMNHKALSo33IbXPt+korZvLyVV5Qtfz
X-Received: by 2002:a05:6830:470a:b0:7c7:2c63:f2d6 with SMTP id 46e09a7af769-7d4b3fd76d9mr1758721a34.11.1770911741509;
        Thu, 12 Feb 2026 07:55:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a7547bfbsm4001881a34.8.2026.02.12.07.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 07:55:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE mapping into helpers
Date: Thu, 12 Feb 2026 07:55:38 -0800
Message-ID: <20260212155539.2083102-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212021835.17755-2-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ywp5ytb7e75oui1i4ysbhdthg1fsmiz8
X-Rspamd-Queue-Id: AACAEC000C
X-Rspam-User: 
X-HE-Tag: 1770911742-105085
X-HE-Meta: U2FsdGVkX181bgt5i/QjFDBi+7z7g9OW7lyEe7ubHftX6Ih/HwNQv85BAtbtq5/YxknzQBsEwWs3zHtsLmYJRxxkhaRqmydOmar/Ko/WfiEcDo58X9Q+QUiuUvQ0kJ0hMXlWrf21gMXAHAOY8TV6lrkLhnA0mnZN6QPYdK3PQsCjDkfPXuohLISZVNA2gnsRS2j6hNICi/1FY9D9tHuZmAObngApcdGpJM6tTrVTPEhuC93T8KJZzggU2GKQd5hsfA/w1lQFwbjT2kYV0TDIgYeT3z0roSI5H0N48ADmFhKqJppPYVnmwPNZNH3b0eaDUhjDihw+o1X1xDnWO5xtbnj+9UD3icHCQq0MexLvtZKUXgVT6Dujrff026Jk7qd3kuH5wsYrFUvZnxEKT5862GE6b8uPtT1d75dvhKzrYJe8+5MZFFYO2e7YHV+8LBcLgYdnLtUGNNWxpb56kyDJr6yPDtoEUd/+TMLemjildhMi5CLDcSh5UneVnx2GQWrHiYBgqkmI4fGUgdn54IlgBY1Ug5iF6Al0BbUAc5wUVmY/wqOTm3kkj/8UkC3EKRK86Udf1+QY45T/vgDm9S7+MNxKIFJX27a2c2z8jb3MhN4B+MGOnib/vfz/WzqM0pdBzIz8JbjF7mWIPRKM3XuB6o/DRy/Pp5j74BaDwo58Ez22Y25isqJ6ffYhjRt8WdiOZmOAym7JMVQcv4Txu8ZiAfBgr1A2e/RgHWrOU6m8j33jFVuq/PcBWEGCU7pKU86DT6zjClbblQpSjgmLB5/KD43HziY2ezKPNNhvINWRz5PFTJ1fefLtcbVkMwkxAYQ9F0a6+bODByK3rPpGAcYmOmY3KaNT4qknSLm0G9BMSOQB4roc2b29u2vQjQznNhkaMCRr2to8kxgXAV3UzW+j7OXdpvXx5IFNzE0LpJMJi7MaX/ampeOmkwwrZkJt0eAXPzIUCd5B7UgJ9uXuVrW
 7RNEnRz+
 dUvSirdpIo6/0cCUm3OTeZa+nwVXzQr0VcjoM2hu9m2pFtWcCyjxCkVhIfHZe0QWw5Pq6mJ83gQt249VjkDwHbLfSkcNE5kHcIFBMMb4lQxpvD8cVpkMdcnx0Gn22Lj2BcTiZIZJQsZRIyc0glpthdKl34/kojbgzf0PgQ4B//2usxLU6gLD303Nw+C8wP+dMQUVQvscl73xUPocsoD+28wZ/rW4JlDT8Up1VuVpQitEzqQioLO8I42+wwIIpuwW9flCuv7uVTknFW/1AI1DYQ8TgQ3PgOG+0NUsOZsijWp08PUKHUD5k5TXnt5WRGc2pmVUJY6JAxbF7QKNS03x3sBBUXmGixiuiScd0CEZZb/+6ei2Znca4w3qhpmEttfCFxgkLf8djaswUt8xzWz1VTZCldCngXqu6OeOW7EoDH4Q08LCyTKFThpylXpPjWlql1ndv8v8BAn2wkDgblQ2qaLNtVDFpEq6o5Y2gpqziA+ca1Jn2a29tewg5MjtlzqroaIgfeweJtY07M9vx5i8D1jg8frxhp0ZmbP7MKqeGaQK8Ij+tiImNmGphAmuEkR7ufeT2+QXl9X17WP9FVCSZEJG8WD7bqj5LuUK9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 19:18:31 -0700 Nico Pache <npache@redhat.com> wrote:

Hello Nico,

Thank you for the patch! I hope you are having a good day.

> The anonymous page fault handler in do_anonymous_page() open-codes the
> sequence to map a newly allocated anonymous folio at the PTE level:
> 	- construct the PTE entry
> 	- add rmap
> 	- add to LRU
> 	- set the PTEs
> 	- update the MMU cache.
> 
> Introduce a two helpers to consolidate this duplicated logic, mirroring the
> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
> 
> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> 	references, adds anon rmap and LRU. This function also handles the
> 	uffd_wp that can occur in the pf variant.
> 
> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
> 	counter updates, and mTHP fault allocation statistics for the page fault
> 	path.
> 
> The zero-page read path in do_anonymous_page() is also untangled from the
> shared setpte label, since it does not allocate a folio and should not
> share the same mapping sequence as the write path. Make nr_pages = 1
> rather than relying on the variable. This makes it more clear that we
> are operating on the zero page only.
> 
> This refactoring will also help reduce code duplication between mm/memory.c
> and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
> mapping that can be reused by future callers.

It seems that based on this description, there should be no functional change
in the code below. Is that correct?

> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  include/linux/mm.h |  4 ++++
>  mm/memory.c        | 56 ++++++++++++++++++++++++++++++----------------
>  2 files changed, 41 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f8a8fd47399c..c3aa1f51e020 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4916,4 +4916,8 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
>  
>  void snapshot_page(struct page_snapshot *ps, const struct page *page);
>  
> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp);
> +
>  #endif /* _LINUX_MM_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 8c19af97f0a0..61c2277c9d9f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5211,6 +5211,35 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  	return folio_prealloc(vma->vm_mm, vma, vmf->address, true);
>  }
>  
> +

^^^ extra newline?

> +void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		bool uffd_wp)
> +{
> +	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
> +	unsigned int nr_pages = folio_nr_pages(folio);

Just reading through the code below on what was deleted and what was added,
Maybe we are missing a pte_sw_mkyoung(entry) here? Seems like this would
matter for MIPS systmes, but I couldn't find this change in the changelog.

> +	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> +	if (uffd_wp)
> +		entry = pte_mkuffd_wp(entry);

The ordering here was also changed, but it wasn't immediately obvious to me
why it was changed.

> +
> +	folio_ref_add(folio, nr_pages - 1);
> +	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> +	folio_add_lru_vma(folio, vma);
> +	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> +	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> +}
> +
> +static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
> +		struct vm_area_struct *vma, unsigned long addr,
> +		unsigned int nr_pages, bool uffd_wp)
> +{
> +	map_anon_folio_pte_nopf(folio, pte, vma, addr, uffd_wp);
> +	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> +	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> +}
> +
> +

^^^ extra newline?

>  /*
>   * We enter with non-exclusive mmap_lock (to exclude vma changes,
>   * but allow concurrent faults), and pte mapped but not yet locked.
> @@ -5257,7 +5286,13 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  			pte_unmap_unlock(vmf->pte, vmf->ptl);
>  			return handle_userfault(vmf, VM_UFFD_MISSING);
>  		}
> -		goto setpte;
> +		if (vmf_orig_pte_uffd_wp(vmf))
> +			entry = pte_mkuffd_wp(entry);
> +		set_pte_at(vma->vm_mm, addr, vmf->pte, entry);
> +
> +		/* No need to invalidate - it was non-present before */
> +		update_mmu_cache_range(vmf, vma, addr, vmf->pte, /*nr_pages=*/ 1);

NIT: Should we try to keep the line under 80 columns? ; -)

> +		goto unlock;
>  	}
>  
>  	/* Allocate our own private page. */
> @@ -5281,11 +5316,6 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	 */
>  	__folio_mark_uptodate(folio);
>  
> -	entry = folio_mk_pte(folio, vma->vm_page_prot);
> -	entry = pte_sw_mkyoung(entry);
> -	if (vma->vm_flags & VM_WRITE)
> -		entry = pte_mkwrite(pte_mkdirty(entry), vma);
> -
>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
>  	if (!vmf->pte)
>  		goto release;
> @@ -5307,19 +5337,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  		folio_put(folio);
>  		return handle_userfault(vmf, VM_UFFD_MISSING);
>  	}
> -
> -	folio_ref_add(folio, nr_pages - 1);
> -	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> -	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
> -	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> -	folio_add_lru_vma(folio, vma);
> -setpte:
> -	if (vmf_orig_pte_uffd_wp(vmf))
> -		entry = pte_mkuffd_wp(entry);
> -	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
> -
> -	/* No need to invalidate - it was non-present before */
> -	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
> +	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr, nr_pages, vmf_orig_pte_uffd_wp(vmf));

NIT: Maybe here as well?

>  unlock:
>  	if (vmf->pte)
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
> -- 
> 2.53.0

Thank you for the patch again. I hope you have a great day!
Joshua

