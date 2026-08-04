Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47841C55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2D6B6B007B; Mon,  3 Aug 2026 20:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F054B6B0088; Mon,  3 Aug 2026 20:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41F56B008A; Mon,  3 Aug 2026 20:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C086F6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:08:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2892940884
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:08:42 +0000 (UTC)
X-FDA: 85061650884.14.8CD7F0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6BB4FC0009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:08:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INrp9BoK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785802120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEVPjOd239FULOvZJt9FR49Oi4ffilzOlCFErD9Rzjg=;
	b=4EZ1BE5HRAnkm1C+gO8AAl3JV0yU719zMRXNz/w32CR3t3M1l8RHZZJbSLvmk/JNsSgTQ6
	giFFLAThrlCJptPm4dkOWZDt+y0CPD2NTRC0fVc+NUMUS7STbdNzFdOS/anyffxWXeDQ/1
	4udpVLYF1c6M8mbDBPTgy5zb+A9o6Yg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INrp9BoK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785802120;
	b=Q1SRMJoLYv7g8D6W8HyF4fLGI3wQgUQNpXToBAfa4r8Kg9jyeekzP1qHpXG4WtNU8aXg8u
	5dJTqDszhIW+EE2PLocY0izOoiawWdS6AbNFa6GU/UsZTSVsB5dXdIat4kDlK1XacEfbVb
	3PhXe9rkwyM1AenRE75tJ8OuPQZTo9Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80FF143818;
	Tue,  4 Aug 2026 00:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D501F000E9;
	Tue,  4 Aug 2026 00:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785802119;
	bh=UEVPjOd239FULOvZJt9FR49Oi4ffilzOlCFErD9Rzjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=INrp9BoKCaDD3HljHkktfuaw0iKD8M8iLP8gQ+THjIJjQxWsXpwGwmFSSHjBm2FiG
	 uPPiqgNn6v9t+CORTpzeQ+g7qSaga65SX4V+WvuraWbYXyS5QR9Xu/zGXhmNLIEFpS
	 7LWyLkeFd+dPKLYC8XbZrxZH2xrjrcPiEtGqp8EXLP8pGOfyvRz/+V7/HWvHBYOLQF
	 kKKW8X6xq9+QDLJY/JyUV9Fxdv3HIMmjMurIk64DZ0KtEUXGkKQCCh9vD/cWQ95IMh
	 PRRcZvkVIxeXcZ2xYnvV4YqvNjtG16xoDO3rqoHsNU25hNm8opUirunagcJ3jTu4pk
	 v0mGX89YWJC3Q==
Date: Tue, 4 Aug 2026 00:08:37 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 10/26] mm: Add more flags for __apply_to_page_range()
Message-ID: <anEnO7KbDQg4k5nf@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-10-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-10-6f5729aa9832@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6BB4FC0009
X-Stat-Signature: h456qgntzkh3eggnekmrj9qdrjos77qy
X-Rspam-User: 
X-HE-Tag: 1785802120-131274
X-HE-Meta: U2FsdGVkX1/iOlJExRVG8SkwBFGsR+1btD7JIP0EmIQYpPrkJSbcDEjqNf/v55yC+IIc4gFVDv31gJCIbaaJCmOs6kH5OJdFlNGvevfaYEazdLn8+N7hwpeZS/l3sXZGpflrTO2774J35g0jQh5SNYSolFmeFw9kO53LojB9nzD9rpaqGu7pjYGy8teem8t5gA0wpTY+UJWkHChZ1Q1gfDqzCkZr2kyNpEVl4SXlqR3JqNwQSEQTIxAkcLX3gMIvkRH4MHSoUvmzj6uCvTVXZddEVdjv1hcbe1iyfW5gBSRu5em2czczGMEV7AtBM862ZpWlcPAQ38PeoqiWt8YniJ0VI51oXIZrV8JUmzXEI9AmbbseCnvCnhzR+2MwbA4Kqc/eBZw5VqzuQYhGYDIFboQNuWQ6xw8dGhfuIS4aVRsCnpClwwNYsJE5eCBNDAPiUP1Vglul2d8clGWgKL0xCNVyKP+pwETOKvHrzIi0As3c51owtTw04CAQEaKLnqOv1X/sFafEmXAzYHHOt9oXC+WIO/lmWxWvJs1JPP7U8ufswFSr9dN5ijBPzoUZkVz2ZUvzi+15rf2lJxnqut3JNTMnVxgBtoefcY2g6sJTUA3zrvuwoYGxnUlMg5n1DPUjxD4xXMOzmBvw5iew5/qoqtbQVMDVhTKP8lcAQj0JGkBxah6d9ypyfROjiCKVD84q0S1+aJn3hBlb/A7HcQcN1wqo9J9k2evJt4ifJT1XWo8dtTJDnvsfLhEbZcC31DhJUu6Z26UxCY89A8ptxf3JUt4sX/Y5ySQZmymf0G9Uh3uBrekYdb7qjmKsyY1aEWm9nCkayTIMhXRyvRU9MMyQK1cOwUlppgZE55nToU9qbUlbn7OZ7YqslRliv3kW/YGVH2tUSdr1XqBGYtL62ukcB4e0fSmTCzqp8T6OaIaEERDkQrVvweZ9j7PHxPknbf9U1bzGTywuZ3NUUxnY5tD
 ZX5WsLYE
 WHIyx0X1ha2JZ0Ry8T3OiHZbGAL77zytFJgCRS77/3PbWO+P/RH8JhI4L9RBxeCGbqvCvInE3YjVc6Qws/5Wp9LU0breOFIkB+QkA86kI8Ns7S5ejcXE4Nqg4ej176oQ4hFGFckRY/svWuTCZLCPqMYFr8qr+Pt4zd9rSFVr62Ffj0bdB9NwOF8V3SMfkMbZJceuyGt5ufvPnMqVGzizkLbir6Fqw4mCe28mkG86e4Ki0r4uAg1kzENYd6ZtQzVYZZbAtLyeHYlwa67vyquskyF8dQrAVpj71BLo+Q0nD2Ui0sKfOtFAGuIh62fUULC2wSX57FNqzfFnmDXlggBgCTRe5jT88reRoWZlhh7NNP4feauY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:43PM +0000, Brendan Jackman wrote:
> Add two flags to make this API more generic:
> 
> 1. Separate "create" into two levels - one to allow creating new
>    mappings without allocating pagetables, and one for the current
>    behaviour that allows both of these.
> 
> 2. Create a new flag to report that the caller has taken care of
>    synchronization and no locks are required.
> 
> Both of these will serve to allow calling this API from restricted
> contexts where allocation and pagetable locking are not possible.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/internal.h | 26 +++++++++++++++++++++++++-
>  mm/memory.c   | 59 ++++++++++++++++++++++++++++++++++-------------------------
>  2 files changed, 59 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 395331a12d62d..5a237d9c5fa96 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1662,9 +1662,33 @@ static inline bool can_spin_trylock(void)
>  
>  /*
>   * Create a mapping if it doesn't exist. (Otherwise, skip regions with no
> - * existing mapping, and return an error for regions with no leaf pagetable).
> + * existing mapping). This doesn't allow allocating, most users will want
> + * PGRANGE_ALLOC.
> + *
> + * Do not test this bit directly as it is implied by PGRANGE_ALLOC, use
> + * pgrange_create() instead.
>   */
>  #define PGRANGE_CREATE		(1 << 0)
> +/*
> + * Allocate a pagetable if one is missing. (Otherwise, return an error for
> + * regions with no leaf pagetable). Also implies PGRANGE_CREATE.
> + *
> + * Note that __apply_to_page_range() assumes that pagetables for the area are
> + * already initialised down to PMD level, so this only affects PTEs in practice.
> + */
> +#define PGRANGE_ALLOC		(1 << 1)
> +/*
> + * Do not take any locks. This means the caller has taken care of
> + * synchronisation. This is incompatible with PGRANGE_ALLOC and also with
> + * mm=&init_mm.
> + */
> +#define PGRANGE_NOLOCK		(1 << 2)

I assume this is used by the mermap as locking is not required because
the mappings are per-CPU and migration is disabled while the mermap is
used?

Also, why is this incompatible with init_mm? It actually seems like
apply_to_pte_range() is always lockless for init_mm (uses
pte_offset_kernel()), probably callers are also synchronizing in their
own way (e.g. exclusive access to a vmap area?).

> +
> +
> +static inline bool pgrange_create(unsigned int flags)
> +{
> +	return flags & (PGRANGE_CREATE | PGRANGE_ALLOC);
> +}
>  
>  int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
>  			  unsigned long size, pte_fn_t fn,
> diff --git a/mm/memory.c b/mm/memory.c
> index c4defefea1574..d00508db1021e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3441,30 +3441,35 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  				     pte_fn_t fn, void *data, unsigned int flags,
>  				     pgtbl_mod_mask *mask)
>  {
> -	bool create = flags & PGRANGE_CREATE;
>  	pte_t *pte, *mapped_pte;
>  	int err = 0;
>  	spinlock_t *ptl;
>  
> -	if (create) {
> +	if (flags & PGRANGE_ALLOC) {
> +		VM_WARN_ON(flags & PGRANGE_NOLOCK);
> +
>  		mapped_pte = pte = (mm == &init_mm) ?
>  			pte_alloc_kernel_track(pmd, addr, mask) :
>  			pte_alloc_map_lock(mm, pmd, addr, &ptl);
>  		if (!pte)
>  			return -ENOMEM;
>  	} else {
> -		mapped_pte = pte = (mm == &init_mm) ?
> -			pte_offset_kernel(pmd, addr) :
> -			pte_offset_map_lock(mm, pmd, addr, &ptl);
> +		if (mm == &init_mm)
> +			pte = pte_offset_kernel(pmd, addr);
> +		else if (flags & PGRANGE_NOLOCK)
> +			pte = pte_offset_map(pmd, addr);
> +		else
> +			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>  		if (!pte)
>  			return -EINVAL;
> +		mapped_pte = pte;
>  	}
>  
>  	lazy_mmu_mode_enable();
>  
>  	if (fn) {
>  		do {
> -			if (create || !pte_none(ptep_get(pte))) {
> +			if (pgrange_create(flags) || !pte_none(ptep_get(pte))) {
>  				err = fn(pte, addr, data);
>  				if (err)
>  					break;
> @@ -3475,8 +3480,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  
>  	lazy_mmu_mode_disable();
>  
> -	if (mm != &init_mm)
> -		pte_unmap_unlock(mapped_pte, ptl);
> +	if (mm != &init_mm) {
> +		if (flags & PGRANGE_NOLOCK)
> +			pte_unmap(mapped_pte);
> +		else
> +			pte_unmap_unlock(mapped_pte, ptl);
> +	}
> +
>  	return err;
>  }
[..]

