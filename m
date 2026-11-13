Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6206071039
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XlQHgXxB
Received: by kanga.kvack.org (Postfix)
	id B44676B05B7; Fri, 13 Nov 2026 13:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD4D6B05B8; Fri, 13 Nov 2026 13:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F26E6B05B9; Fri, 13 Nov 2026 13:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75C766B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:39:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 073BF4025D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:39:44 +0000 (UTC)
X-FDA: 85430959488.20.421381D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5111C160013
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:39:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XlQHgXxB;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnUq4ElnHsxRnOIjFta6Y04mbJFNlBGZVOzsVi3X2B0=;
	b=H2L4BgZXaHxUZD3HsFBgew7PhcseouT+/RUBYhXknvSJ/Ztz7qjcqgydEGNfcJOfirvqjW
	LRWtB6yOQzYO5Ypws1X/JxfzDeR1Kl1whAV0k4OtVBL4UkZF4hEJ8rTufu0coSXJrkJjPH
	e+cqWckus8jAXd35hP9HB30wad8562I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595182;
	b=bKboYW0o5ARbogI+HHKFN4BuSoMr3uisQ2JPoHG/j/oNGGAgRe5toSU8fVQYsTDlriLhp9
	dhI8TYlgq4Z8965MFYtanGCW/gYLcqbq5pu5BYYmIKtR2LjPbeoOv9VTFnmfLtvDSD+l69
	T99vYKPu0V4hcvQ826a3OQxkQLczca8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XlQHgXxB;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7144E60D9B;
	Fri, 13 Nov 2026 18:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120801F000C5;
	Fri, 13 Nov 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595181;
	bh=vnUq4ElnHsxRnOIjFta6Y04mbJFNlBGZVOzsVi3X2B0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XlQHgXxByB6xl8SZ2zgJrv2a4VJwpuAx3QYWCYpSU55j5VJ3BMLi/P5uiYZSahMS/
	 /vM7T9DYqwzbDLY+z/BTxiyepi4vgfEs7J/lKzU2fxQKfPZf0TZQUw0j3Tmtnd18dS
	 7FdNz5zU4duliWfFLor6rTP3n4vGKpCn27hoEpHVMTq++WbChyE5JwdctSUeZ3LSXt
	 yNUdmwAvENyLuWY5f6EyxFaSLqVqFFUihIBEHGENBSokpPyNj2ZQqXbuQT7u+nBoN5
	 wvXRWmE5JX94kSJClQjbLR4SWgfOnefI26H7hjvQbs0R9aBh61i6k8SsFtOayKT3ed
	 4M/AFVStJB+IA==
Date: Fri, 13 Nov 2026 18:39:34 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Matthew Wilcox <willy@infradead.org>, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 2/6] mm: remove ARCH_NEEDS_KMAP_HIGH_GET
Message-ID: <avdXERQgqgJ3P_Sd@gremlin>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-3-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-3-arnd@kernel.org>
X-Stat-Signature: gn3xfa7cbufzw7ic6pyjzkqrh9o6ipc9
X-Rspamd-Queue-Id: 5111C160013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794595182-486403
X-HE-Meta: U2FsdGVkX18LxGF8guCJA5gOFoGvdChqXeL6ICwSmsj3jZs6EJ9+Hs6X4i+FcSunwjDzWyS/GoITQhIDhRPW1y/9DZ10q9pg5976A+wxwcFbE/szm1KeZLCQqKKHjFNTLkLXKqrZDCpI6QTsuorU8WlMt+UMjV0tSzXaPoZasmjBn5w8SoXKEAc7KNjfNo0dyhDsgk6R5weg70kN69yzffi+uLPg4QI13EGfYys4NNmfRa49Y7+meb9ozOULTVfiLYAve3iwcsoB/Rwz6EX7dTZlFJ2mstrlaHYgNBwG81csvtH7JdC0as6wZkvy91KQP47nLbzGv60Zo3AOkIIsjreJlujE3KjzR8IU7pXSoVMVIrZTiw4bTLhFvDffTdIgoiVHPqnmt0PmvCqg4nP7udEujVAih7Mk8hmx2UNlebCXONNEnPyaUqFSo1281oaiM+TE3ui/Y/7VjzFl5yAR6THhZoM/oEtrpSZoYirlUR75l7oak2qeQQVPDgD4s2wv9TQQ0Kol0UxPtXMoRLxk/Nk9DxWb+6uFkUlG8oQG8XmrRTgD6Caf68abzhqorROla2V40e0airDDQgKWLJ4XxSxkIf164S8B92btidZtqoC1kg+a2z0Kymgx4Yt0T+OnRPqAbq999LqsxaIu0mD53RNf00hd+Zao9WP89aDibwpz2mqtuAAdGpZcf81So362wphwNi130qK38SpejEUGhCVRAVZQ5DzMApDswXKa2tT0xlMMq7linhpgWx6gkMiH44yVyy4zGBFTDq+SE0x5Rw5tzPAVMiJzMjMFbR/D/l5W3IupCXNlExMCr20cVJG7bUzrMK6ZRs0CG0I/S1N1oCuBDEyLb8C/OE+11bXPK0ycjoXobcXHg+a69peURSjGG+614guBexlQzqh4twty/Tz5yEsbWWN7U9HLcEXaCw6ue9QSu1jD03I/XhRpmT9dpwm5EVVYmLABAyWUhmi
 uOfhODpA
 ZYcAXYdhv7dtKXYykzZK94tHXebDGZ841ShjYHQle67MWVm3T+XaSxDEQ+PYHGNNtxBC18LPh5ONTiDguD2P2eTa+LkhHLnnyWG0dhDHXb9dvSBYzPg5pIF1VT1dPstRyPqQ4+06IuwCQsjXnqXE2xCEYzUQptNcf97BrWrqA19Cawre/3oZSToPr484lw26hr3mBH2YdBZ0nIP3CNzO0ryf2LPtIcZXifHj6ypS1gYgz+o26DiEyw4xTG1XR2h7Uvkl42AR6diBXJXd4zPVPYeBPuIMJ08fA/osCnOsGinigbXaeCdFQF8BallRDm+pmdSmEGJR23cf8Q9/eqDUZ2HVSiVCfXOGd09M9eejgJPAZtEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:24PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Arm has stopped setting ARCH_NEEDS_KMAP_HIGH_GET, so this
> is handled using the same wrappers across all architectures
> now, which leaves room for simplification.
>
> Replace lock_kmap()/unlock_kmap() with open-coded spinlocks
> and drop the now empty arch_kmap_local_high_get() and
> kmap_high_unmap_local() helpers.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Lovely :)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/highmem.c | 100 ++++++---------------------------------------------
>  1 file changed, 10 insertions(+), 90 deletions(-)
>
> diff --git a/mm/highmem.c b/mm/highmem.c
> index a33e41183951..214164f9172b 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -143,25 +143,6 @@ static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kmap_lock);
>
>  pte_t *pkmap_page_table;
>
> -/*
> - * Most architectures have no use for kmap_high_get(), so let's abstract
> - * the disabling of IRQ out of the locking in that case to save on a
> - * potential useless overhead.
> - */
> -#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> -#define lock_kmap()             spin_lock_irq(&kmap_lock)
> -#define unlock_kmap()           spin_unlock_irq(&kmap_lock)
> -#define lock_kmap_any(flags)    spin_lock_irqsave(&kmap_lock, flags)
> -#define unlock_kmap_any(flags)  spin_unlock_irqrestore(&kmap_lock, flags)
> -#else
> -#define lock_kmap()             spin_lock(&kmap_lock)
> -#define unlock_kmap()           spin_unlock(&kmap_lock)
> -#define lock_kmap_any(flags)    \
> -		do { spin_lock(&kmap_lock); (void)(flags); } while (0)
> -#define unlock_kmap_any(flags)  \
> -		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
> -#endif
> -
>  struct page *__kmap_to_page(void *vaddr)
>  {
>  	unsigned long base = (unsigned long) vaddr & PAGE_MASK;
> @@ -238,9 +219,9 @@ static void flush_all_zero_pkmaps(void)
>
>  void __kmap_flush_unused(void)
>  {
> -	lock_kmap();
> +	spin_lock(&kmap_lock);
>  	flush_all_zero_pkmaps();
> -	unlock_kmap();
> +	spin_unlock(&kmap_lock);
>  }
>
>  static inline unsigned long map_new_virtual(struct page *page)
> @@ -274,10 +255,10 @@ static inline unsigned long map_new_virtual(struct page *page)
>
>  			__set_current_state(TASK_UNINTERRUPTIBLE);
>  			add_wait_queue(pkmap_map_wait, &wait);
> -			unlock_kmap();
> +			spin_unlock(&kmap_lock);
>  			schedule();
>  			remove_wait_queue(pkmap_map_wait, &wait);
> -			lock_kmap();
> +			spin_lock(&kmap_lock);
>
>  			/* Somebody else might have mapped it while we slept */
>  			if (page_address(page))
> @@ -313,60 +294,32 @@ void *kmap_high(struct page *page)
>  	 * For highmem pages, we can't trust "virtual" until
>  	 * after we have the lock.
>  	 */
> -	lock_kmap();
> +	spin_lock(&kmap_lock);
>  	vaddr = (unsigned long)page_address(page);
>  	if (!vaddr)
>  		vaddr = map_new_virtual(page);
>  	pkmap_count[PKMAP_NR(vaddr)]++;
>  	BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
> -	unlock_kmap();
> +	spin_unlock(&kmap_lock);
>  	return (void *) vaddr;
>  }
>  EXPORT_SYMBOL(kmap_high);
>
> -#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> -/**
> - * kmap_high_get - pin a highmem page into memory
> - * @page: &struct page to pin
> - *
> - * Returns the page's current virtual memory address, or NULL if no mapping
> - * exists.  If and only if a non null address is returned then a
> - * matching call to kunmap_high() is necessary.
> - *
> - * This can be called from any context.
> - */
> -void *kmap_high_get(const struct page *page)
> -{
> -	unsigned long vaddr, flags;
> -
> -	lock_kmap_any(flags);
> -	vaddr = (unsigned long)page_address(page);
> -	if (vaddr) {
> -		BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 1);
> -		pkmap_count[PKMAP_NR(vaddr)]++;
> -	}
> -	unlock_kmap_any(flags);
> -	return (void *) vaddr;
> -}
> -#endif
> -
>  /**
>   * kunmap_high - unmap a highmem page into memory
>   * @page: &struct page to unmap
>   *
> - * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
> - * only from user context.
> + * This may be called only from user context.
>   */
>  void kunmap_high(const struct page *page)
>  {
>  	unsigned long vaddr;
>  	unsigned long nr;
> -	unsigned long flags;
>  	int need_wakeup;
>  	unsigned int color = get_pkmap_color(page);
>  	wait_queue_head_t *pkmap_map_wait;
>
> -	lock_kmap_any(flags);
> +	spin_lock(&kmap_lock);
>  	vaddr = (unsigned long)page_address(page);
>  	BUG_ON(!vaddr);
>  	nr = PKMAP_NR(vaddr);
> @@ -393,7 +346,7 @@ void kunmap_high(const struct page *page)
>  		pkmap_map_wait = get_pkmap_wait_queue_head(color);
>  		need_wakeup = waitqueue_active(pkmap_map_wait);
>  	}
> -	unlock_kmap_any(flags);
> +	spin_unlock(&kmap_lock);
>
>  	/* do wake-up, if needed, race-free outside of the spin lock */
>  	if (need_wakeup)
> @@ -508,30 +461,11 @@ static inline void kmap_local_idx_pop(void)
>  #define arch_kmap_local_unmap_idx(idx, vaddr)	kmap_local_calc_idx(idx)
>  #endif
>
> -#ifndef arch_kmap_local_high_get
> -static inline void *arch_kmap_local_high_get(const struct page *page)
> -{
> -	return NULL;
> -}
> -#endif
> -
>  #ifndef arch_kmap_local_set_pte
>  #define arch_kmap_local_set_pte(mm, vaddr, ptep, ptev)	\
>  	set_pte_at(mm, vaddr, ptep, ptev)
>  #endif
>
> -/* Unmap a local mapping which was obtained by kmap_high_get() */
> -static inline bool kmap_high_unmap_local(unsigned long vaddr)
> -{
> -#ifdef ARCH_NEEDS_KMAP_HIGH_GET
> -	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
> -		kunmap_high(pte_page(ptep_get(&pkmap_page_table[PKMAP_NR(vaddr)])));
> -		return true;
> -	}
> -#endif
> -	return false;
> -}
> -
>  static pte_t *__kmap_pte;
>
>  static pte_t *kmap_get_pte(unsigned long vaddr, int idx)
> @@ -575,8 +509,6 @@ EXPORT_SYMBOL_GPL(__kmap_local_pfn_prot);
>
>  void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
>  {
> -	void *kmap;
> -
>  	/*
>  	 * To broaden the usage of the actual kmap_local() machinery always map
>  	 * pages when debugging is enabled and the architecture has no problems
> @@ -585,11 +517,6 @@ void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
>  	if (!IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) && !PageHighMem(page))
>  		return page_address(page);
>
> -	/* Try kmap_high_get() if architecture has it enabled */
> -	kmap = arch_kmap_local_high_get(page);
> -	if (kmap)
> -		return kmap;
> -
>  	return __kmap_local_pfn_prot(page_to_pfn(page), prot);
>  }
>  EXPORT_SYMBOL(__kmap_local_page_prot);
> @@ -607,14 +534,7 @@ void kunmap_local_indexed(const void *vaddr)
>  			WARN_ON_ONCE(1);
>  			return;
>  		}
> -		/*
> -		 * Handle mappings which were obtained by kmap_high_get()
> -		 * first as the virtual address of such mappings is below
> -		 * PAGE_OFFSET. Warn for all other addresses which are in
> -		 * the user space part of the virtual address space.
> -		 */
> -		if (!kmap_high_unmap_local(addr))
> -			WARN_ON_ONCE(addr < PAGE_OFFSET);
> +		WARN_ON_ONCE(addr < PAGE_OFFSET);
>  		return;
>  	}
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

