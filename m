Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A69D10FCAE6
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7E96B0088; Wed,  1 Apr 2026 17:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988876B0089; Wed,  1 Apr 2026 17:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8772B6B008A; Wed,  1 Apr 2026 17:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 717C46B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:19:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1188CC106D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:19:28 +0000 (UTC)
X-FDA: 84611253216.04.F1AC435
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 44F3A14000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:19:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UwfluGsJ;
	spf=pass (imf09.hostedemail.com: domain of 33IvNaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33IvNaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775078366; a=rsa-sha256;
	cv=none;
	b=IHTC33w75jYT4DpiLAEHHsJEJkyg2EFraGWcibc+qaKsPnAINcsUp89Mv+7syQKLiwJdP6
	EHIDAxmsvKdgBjIAiLzxIvF3Ylv6AydiXAiQEEGI1eSO0g0lqxiVAztvrVLD9K4dvwZcQF
	bEtHJ0NVwa00hDb8b2rp/FmwJd8ZhbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775078366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuPQyGyuWKxEs8V1iwj2Rv9xmDEoESFNVmV4eOpaK8A=;
	b=yJtLA8kUcRA+TC7b+4UAKVS1ce7ynNh3T5LyJjJfvXSyZTcesnDcQw3GFeF2401o45q7CJ
	V8PrMiuCwr6eMjkzLEhi4UE4Z1xmzUJKUkyJ/rL3zf3HMGwBwrOA87d1KIxwNYpeJoicsE
	QPpwVRiZ0BB0scu1P7X6aEwz+MhjKeQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UwfluGsJ;
	spf=pass (imf09.hostedemail.com: domain of 33IvNaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33IvNaQkKCH8dolfhu1kojrrjoh.frpolqx0-ppnydfn.ruj@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485c45885e6so1263885e9.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775078364; x=1775683164; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EuPQyGyuWKxEs8V1iwj2Rv9xmDEoESFNVmV4eOpaK8A=;
        b=UwfluGsJ7dovhzNfNQeTJK+YPKiq7FPWAkUAQYUNyTSqmsUB4oAJkgdVKS90vEuwij
         fAaloIA6YDvmErq9IOFoHtxaKv737iOWBcbdLEhY6LSdc7ZQ/qKgxNJ9LOKy0KQLpOSw
         rTHjQh38SuyL8K4YHBMrF5QWrbOsSAcwDSDjMw2Sx8YRXRspUdyyjcfVOfhKDmXqiMuf
         SJPzBg7Qb9rKz0rOuwMkcGarqcFyyUykv6VgryOTkCyT876VJLBTK6EQC4ViqU4zPING
         /DmMHzRRDMSQtm56UWKaoH65/RwtnOZeKNSAiHXPYWEEFbyv2pbxL0o8Gw0qXVshw+Y0
         RkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775078364; x=1775683164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuPQyGyuWKxEs8V1iwj2Rv9xmDEoESFNVmV4eOpaK8A=;
        b=lNjUTJYKn5RSF9mGxhq0+j3KPlKSiZFwTcDOryZv/5onP3hE9E9dxyXWXGgEWL3FiK
         YysgRJy4uHAxxERUra9+i//5uSaVNUZ4YHRiTb5EVfV+dQjhrVWtBisvgfpFjn2XD4wO
         weMsUcch46HNu2l9ngSjLOEczqLNhxUlNpI/ib/zwJWo+zZcl1tdnF769Lkf1vr3pylw
         Nwgwou20YZ9Se5xPDpiMPcWXFKHWj6yYtq57gUBfYvVcuF8gLUN7m0HaHXiJVZVBmMJQ
         nNJzTRmI6a7uNuJT59V3Mx5fQm/Q/B7axkdEHvQyHKntgAI1waqh6ECHO97u7aNnvq63
         xJ8A==
X-Forwarded-Encrypted: i=1; AJvYcCU5BaZxPaNko2pYi58G8OpRZZx1bfEAVci3Xnptp9TYXz2Ha6quZTtw9XuSkrq04o3T+Nwdzrq0YQ==@kvack.org
X-Gm-Message-State: AOJu0Yya8N/ukvRiwcCNOwAEFGyzKFgj+RJWr+XHVUMAXEPGEL/NB8UI
	jOQwv3bZkyZS8dhFH1n/Tdwk0NM4LiXjipf7n4hOQTpF+fo/eLKeEQMetOrrNDLFtnYo9w3ShXn
	HItrnd7kdbuVJigDIBQ==
X-Received: from wmjt1.prod.google.com ([2002:a7b:c3c1:0:b0:485:318b:96c6])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8115:b0:486:f8d6:5dea with SMTP id 5b1f17b1804b1-488835997d6mr84594845e9.19.1775078364368;
 Wed, 01 Apr 2026 14:19:24 -0700 (PDT)
Date: Wed, 1 Apr 2026 21:19:21 +0000
In-Reply-To: <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in>
Mime-Version: 1.0
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in> <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in>
Message-ID: <ac2L2VNExpp8t7oF@google.com>
Subject: Re: [PATCH v9 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
From: Alice Ryhl <aliceryhl@google.com>
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44F3A14000D
X-Stat-Signature: wjiyjh63or5p4a4e6kj7s7nptwim6z3g
X-HE-Tag: 1775078366-103078
X-HE-Meta: U2FsdGVkX1+Ge4HepVpL+hciRTOL9JK+XZyEdb8McOeawH+VQ9ZreaAaCK4pjHGUnanD2YNBlHzYut3NCX4+frCtXcF4jq5bwaevmwhkQJaQ+dDX1LQmp1+LySfV0gsf2l+0qtwpOudbjVWt4kSW9rHa6FpnroAAcj6Bk1B3c4cfGyZdeX9ihRUyZlETowz684wm0C7j3bzZn6WOqwXLV4RVZxqsnAwu68iWfmzwO6fcVhjrjLAJzjtr9m0sRgfA/YfSoXtB+WqC56643s4ScfkSnnZFnQN+YI/alXBXhIqsp6yy0RSuvvpLO4g8d5bnN2aF2IoirEgtJoOfQmOBfB6eZtt4e4L6c7uECylpvanoqYwsuVpz6UxzLpKFknPa6cXTKiFXtrld0EpanEhn7ieD9ZxuePbBu/x3SKrfrbamjmqZBiZxWL7QcevKQz1SxY8ymTYHXc59b8QoiIGVNcT5vz4q06bx8CSei/hJSBVWCKyBVtVvQOKG+nVlxFICWkK4Hu30u8vUg/Y5J8dS08+eZgGmhZl1N0mvadlpL4B6HFtCn3WZJZKigVrcYc564SLeV13JfRwQbOQ0zeFs6Z/WA02laNjX+sCkDrKoYC3fJRggpe8cFUHyMURne3APbZW3csx2C7Cf33DTyZgaWqu+U9nSXFc2UwDvbJmtf7/QPabbrZFNW+1GJfRlijUU02u0+WiocF9o4JYkJp/nOBL9rTOCJFH9DhBOJ0ANpHZCt5wyHBzNqM+V7fbjy7l/nRP/bkug/IBZdyY4r2WhTHJGkUYvA73ZfmBQxRxzJxKl+bHUsas85ycdjwJGwJ63rffE2bliwyCWyaR/5wNuymtXhQn46j6o9+pa5pJZMiJ6RnhgpXfLtYp423jmjuErVzEP/mIxWxUPSYYEiq4ngcMyOSNiDijSFnez/WtyDeud/Yz6of6/G+CONLoqn7ZHsNj4+fgqVu9osJfGW5A
 FgcloCgD
 DtKno94tCaDPWiO+aQSRJhNGW9TIkQiNcWNA79YH5paMOGJk5panbvRkb1C/08H7zxe4jg9Oc8WkKTsLXe8i+KPRhJiaMUxlpc4LUBYP6HjyE36GFLHosRYXi98VOY3LqY3QZne97FYz2bU7AfWYfgmcAAU9nzzQlzUHrOjrBAopXHRxPakawBxLMlf2rbonlNb7m9I+IKweobpg0LrLzBY9Q/qHPjjGQOuq/1SMdbN22wZNN5HSlAhIiGydW+czcQ5xPxyY+euu7L/I/FhaPfGxCGN5wYH4lhSB2P54beEiMhXmcrSsnPihx/YLtRLX+KVVblXQYiFdKSXN4EcKnwjPNMJafWMPKnI7Z+oZrBROj6W+z0E8JsHnsK1pZNjqacK5k+xnzNOGxjQHZMJwlZ9DE9+yiDYsoebciEZrpTQd+aZcPg1ZPdMRtm01N+YNzLxSx1TAiF8v/OGFfJLyPUGrBWs2CSN3gTWJZ5Eip8vgjg5ksdrVmnlkYeaQCk+ew1SHPYeIaeGAUUa8Ij1iUGyrq56wux6OiEkCsRVGCGfDMdnJ4wF9rvtZm7PGqtfMVIXop3qdSnpVCUEjBYC2rHh+f0xq/tj0glmwZvC8ptqR5oZV5ODvk1qj8TKtwAsUIRqahoTOgZNQHNVflO8WD3PnMuTvbSqpaTXXjVj1SmeaRzcTUVT0mvtoyDH7HdlzQhC7eo16Zw+Ww8wiBoXJk4AUBog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 10:46:35PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> When vrealloc() shrinks an allocation and the new size crosses a page
> boundary, unmap and free the tail pages that are no longer needed. This
> reclaims physical memory that was previously wasted for the lifetime
> of the allocation.
> 
> The heuristic is simple: always free when at least one full page becomes
> unused. Huge page allocations (page_order > 0) are skipped, as partial
> freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
> are also skipped, as their direct-map permissions must be reset before
> pages are returned to the page allocator, which is handled by
> vm_reset_perms() during vfree().
> 
> Additionally, allocations with VM_USERMAP are skipped because
> remap_vmalloc_range_partial() validates mapping requests against the
> unchanged vm->size; freeing tail pages would cause vmalloc_to_page()
> to return NULL for the unmapped range.
> 
> To protect concurrent readers, the shrink path uses Node lock to
> synchronize before freeing the pages.
> 
> Finally, we notify kmemleak of the reduced allocation size using
> kmemleak_free_part() to prevent the kmemleak scanner from faulting on
> the newly unmapped virtual addresses.
> 
> The virtual address reservation (vm->size / vmap_area) is intentionally
> kept unchanged, preserving the address for potential future grow-in-place
> support.
> 
> Suggested-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1c6d747220ce..a7731e54560b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4359,14 +4359,62 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		goto need_realloc;
>  	}
>  
> -	/*
> -	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
> -	 * would be a good heuristic for when to shrink the vm_area?
> -	 */
>  	if (size <= old_size) {
> +		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +
>  		/* Zero out "freed" memory, potentially for future realloc. */
>  		if (want_init_on_free() || want_init_on_alloc(flags))
>  			memset((void *)p + size, 0, old_size - size);
> +
> +		/*
> +		 * Free tail pages when shrink crosses a page boundary.
> +		 *
> +		 * Skip huge page allocations (page_order > 0) as partial
> +		 * freeing would require splitting.
> +		 *
> +		 * Skip VM_FLUSH_RESET_PERMS, as direct-map permissions must
> +		 * be reset before pages are returned to the allocator.
> +		 *
> +		 * Skip VM_USERMAP, as remap_vmalloc_range_partial() validates
> +		 * mapping requests against the unchanged vm->size; freeing
> +		 * tail pages would cause vmalloc_to_page() to return NULL for
> +		 * the unmapped range.
> +		 *
> +		 * Skip if either GFP_NOFS or GFP_NOIO are used.
> +		 * kmemleak_free_part() internally allocates with
> +		 * GFP_KERNEL, which could trigger a recursive deadlock
> +		 * if we are under filesystem or I/O reclaim.
> +		 */
> +		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
> +		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
> +		    gfp_has_io_fs(flags)) {
> +			unsigned long addr = (unsigned long)kasan_reset_tag(p);
> +			unsigned int old_nr_pages = vm->nr_pages;
> +
> +			/* Notify kmemleak of the reduced allocation size before unmapping. */
> +			kmemleak_free_part(
> +				(void *)addr + ((unsigned long)new_nr_pages
> +						<< PAGE_SHIFT),
> +				(unsigned long)(old_nr_pages - new_nr_pages)
> +					<< PAGE_SHIFT);
> +
> +			vunmap_range(addr + ((unsigned long)new_nr_pages
> +					     << PAGE_SHIFT),
> +				     addr + ((unsigned long)old_nr_pages
> +					     << PAGE_SHIFT));
> +
> +			/*
> +			 * Use the node lock to synchronize with concurrent
> +			 * readers (vmalloc_info_show).
> +			 */
> +			struct vmap_node *vn = addr_to_node(addr);
> +
> +			spin_lock(&vn->busy.lock);
> +			vm->nr_pages = new_nr_pages;
> +			spin_unlock(&vn->busy.lock);

Should we set nr_pages first? Right now, another thread may observe the
range being unmapped but still see the old nr_pages value.

> +			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
> +		}
>  		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
>  		return (void *)p;
> 
> -- 
> 2.43.0
> 
> 

