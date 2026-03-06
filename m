Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C1EEF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867EF6B0005; Fri,  6 Mar 2026 07:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829106B00A4; Fri,  6 Mar 2026 07:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721DB6B00A5; Fri,  6 Mar 2026 07:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6011B6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:41:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 237BD8BDD7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:41:17 +0000 (UTC)
X-FDA: 84515598594.24.6D71B72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5ED4F1C000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:41:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PpKc6rDA;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UR8CfjV1tUrpLDvSF5b3+Dv//Kr4G++1kk561g+r+8A=;
	b=SDrj8KjmSLp/LNY+1FBrkShN9Rj0RQ7lkrWXjWBXb40if61aiYA6e0O/bE5/xdATUE9ZaC
	Wb/qMR1fLmlavBfCGocupPdkWdxLQaou/TXDQqlhLbISNI0xB7sItstUUzedLTWgDrUC66
	T7ii0UjjVb12MkLyr1oVfVjeGdyAoXQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800875; a=rsa-sha256;
	cv=none;
	b=n2y0YeIgK+3Y2C3WFapND2GehSRSiU43OJOiGVTnxnub9MJpeME+sFsvLyWAEuKJZkm42s
	mSBxB5b2xYgRQWgyxRGKx6+7LZ+hQm5YL9353vmLqD0TMmPMSKhfXe5tKdyD7iqkzuxTsF
	D6KJiwEEAyBljtOGubT3FKLbX8VzDuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PpKc6rDA;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D83B44204;
	Fri,  6 Mar 2026 12:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964FFC4CEF7;
	Fri,  6 Mar 2026 12:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772800874;
	bh=lq+50juxWpZTD6H0V77Zyv6OGyq7pL6MoSFSgCZf0CQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PpKc6rDA59KGYIRFwtyM9Sadr3C/wX3fkFV3gIPSOjYDFuYBwWa3LLeEUMWZvdUF/
	 3G8BuvDsxyOn2WfkGJ83plefNiGw3aWzaX9FsviZQvjodMO4vhRQjPb/3a5QaHhww+
	 S2tDdIhK/WCnvNQyRu8Yz57kR9mVFrOxIG8qMWl67LGh9WILqiJV1HThKPDwhyxgZD
	 5N7vrK4zWbwHpmUbYWwGrY8KJ1KlCFzx5cMVqwe83rI13dEt/fd3J3VgWWNyc66R4Y
	 YdYvrCSktLxQzE/goRvNKT5ONqH1zXpLdBdwAe1BCtmd1nNFbiMMpRVKGpP+LFmrGQ
	 kQaNSV2mvY+qA==
Date: Fri, 6 Mar 2026 12:41:11 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 15/16] mm: rename zap_vma_ptes() to
 zap_special_vma_range()
Message-ID: <c77c1bed-f04e-4f21-87d9-6c5da3f0ad69@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-16-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-16-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 3y8zuwsde9b8csdmpwq6kem8mt8s1s1w
X-Rspamd-Queue-Id: 5ED4F1C000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1772800875-860749
X-HE-Meta: U2FsdGVkX19FqsV9wrixJVC/E8TDu97yNoHHrG+dyllD+f+ipIgQgUeeCUG1+VDqk6QMy9e1HvnJdqUuuzobn9f0eTq+qEqm98u6gSIhn8YQ6mapJF/Pgoi/C39bMdDEoTRNxy2zFnZXkb9ihMzH66c8eFTqryR8nJKl4KoNZUa7+cSI+sA8b8QjRaHPxGs6Ee+VI6wWtSDxIhxXcGU7ToT2Qx1dsr0Zz+94H71RaN1K0AUR7UYgwYJ6+0U8OCYsq6k5ZGiOT7P3ALFuEP2aSVCMf8RpoY6cRdOCWVpwIvZ1/KmDqzFVnPbdgaOqkuW0qYX1XKNWEWDHPJvyhoqwdsKTc6wAVpoqsWVhYSo65Fawxajmi2OhhpVZ/zfVq8utp7m8uq+KKPKNcYkq78Ueltu5iqWroUJFFF+y0BsH2AIkZh0oZ5k7n3IGxlkKJKQbVoe6K/+T+QSfA//+xVV/odbSyvofMj5OnzY/AiEjFH71nzkpos8hmBMg61gN40X4AkcPq1X8IPpJDC92axENUwh5QZ2nqT7HSKGoddgJQfwx+It+WxuFh6GuEXguZaEyVrsnCB4YCcb/vDEoPxlrgu4rXAjt5WdbldlQUboTUzTuu2ziKgJ0aIckTpbTrExfZ1UjkmQJHwf2trwfiUgtQbmefq4lEwchNtAXRF9yLjvisckcTdOUWEgDzc+47vMNlUfcmuFpsvasHmg+xR95vOytkqD+1SkARhTlzBsBLDPy0mTDErsPqA33eCvZA+Yco7+sdb4S0zN4jUIlB5H/vHTn5Wo/8OY2lZ73sR6LL+dLa4BvP2t1gq2dUNWjTCMjVChXsgJ8GmsCKJUwFCBlOPm6S+2t7lAesrbE/QqmBubI1xZBbY4X7fSrYrnuaNAnQZb6MHfE/IjE1Fj21teFow+0WBfz1W1Gu0QwYM76nLtzu9FHKwLQM+77v4RmJjVDQy71lPotthg4xTBmQES
 +BcXOe09
 P4FoGUJHWzTevUfJYYziTEfpq6u0/n12akVO44ZiYBJVVXpsAViDIf5X6Vbqtq7zF+wSroMEDtop2CkqCrLMmrTUlqObjaWSYpCiuNSYkMvH5ZHSKcFqnBWx6bxxpr6CNUGp4Op3G6yFfcF3pH0TT6cwDsb5B5HzJlwBqq5+ib492svFVItATII+rLwPggiJbvy4qZ24PreHL0jzUddtSr7vP1shLE1PDRvCu/AAuu0dIlszg8wtprV6/F7+iOPy422/mL5HYg8i80ZEgdBM4QJ3sFHS6Zg5Bu3Sy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:46PM +0100, David Hildenbrand (Arm) wrote:
> zap_vma_ptes() is the only zapping function we export to modules.
>
> It's essentially a wrapper around zap_vma_range(), however, with some
> safety checks:
> * That the passed range fits fully into the VMA
> * That it's only used for VM_PFNMAP
>
> We might want to support VM_MIXEDMAP soon as well, so use the

I think you should say we _are_ going to since patch 16/16 does that :)

> more-generic term "special vma", although "special" is a bit overloaded.
> Maybe we'll later just support any VM_SPECIAL flag.

Yeah I hate the name, but I guess it's probably the best we can manage
because VM_SPECIAL and both VM_PFNMAP and VM_MIXEDMAP _are_ 'special' in
this sense so meh I guess it's the best we can do.

>
> While at it, improve the kerneldoc.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/x86/kernel/cpu/sgx/encl.c        |  2 +-
>  drivers/comedi/comedi_fops.c          |  2 +-
>  drivers/gpu/drm/i915/i915_mm.c        |  4 ++--
>  drivers/infiniband/core/uverbs_main.c |  6 +++---
>  drivers/misc/sgi-gru/grumain.c        |  2 +-
>  include/linux/mm.h                    |  2 +-
>  mm/memory.c                           | 16 +++++++---------
>  7 files changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index ac60ebde5d9b..3f0222d10f6e 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -1220,7 +1220,7 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
>
>  			ret = sgx_encl_find(encl_mm->mm, addr, &vma);
>  			if (!ret && encl == vma->vm_private_data)
> -				zap_vma_ptes(vma, addr, PAGE_SIZE);
> +				zap_special_vma_range(vma, addr, PAGE_SIZE);
>
>  			mmap_read_unlock(encl_mm->mm);
>
> diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
> index 48a8a607a84c..b91e0b5ac394 100644
> --- a/drivers/comedi/comedi_fops.c
> +++ b/drivers/comedi/comedi_fops.c
> @@ -2588,7 +2588,7 @@ static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
>  	 * remap_pfn_range() because we call remap_pfn_range() in a loop.
>  	 */
>  	if (retval)
> -		zap_vma_ptes(vma, vma->vm_start, size);
> +		zap_special_vma_range(vma, vma->vm_start, size);
>  #endif
>
>  	if (retval == 0) {
> diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
> index c33bd3d83069..fd89e7c7d8d6 100644
> --- a/drivers/gpu/drm/i915/i915_mm.c
> +++ b/drivers/gpu/drm/i915/i915_mm.c
> @@ -108,7 +108,7 @@ int remap_io_mapping(struct vm_area_struct *vma,
>
>  	err = apply_to_page_range(r.mm, addr, size, remap_pfn, &r);
>  	if (unlikely(err)) {
> -		zap_vma_ptes(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
> +		zap_special_vma_range(vma, addr, (r.pfn - pfn) << PAGE_SHIFT);
>  		return err;
>  	}
>
> @@ -156,7 +156,7 @@ int remap_io_sg(struct vm_area_struct *vma,
>
>  	err = apply_to_page_range(r.mm, addr, size, remap_sg, &r);
>  	if (unlikely(err)) {
> -		zap_vma_ptes(vma, addr, r.pfn << PAGE_SHIFT);
> +		zap_special_vma_range(vma, addr, r.pfn << PAGE_SHIFT);
>  		return err;
>  	}
>
> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index 7b68967a6301..f5837da47299 100644
> --- a/drivers/infiniband/core/uverbs_main.c
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -756,7 +756,7 @@ static void rdma_umap_open(struct vm_area_struct *vma)
>  	 * point, so zap it.
>  	 */
>  	vma->vm_private_data = NULL;
> -	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
> +	zap_special_vma_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
>  }
>
>  static void rdma_umap_close(struct vm_area_struct *vma)
> @@ -782,7 +782,7 @@ static void rdma_umap_close(struct vm_area_struct *vma)
>  }
>
>  /*
> - * Once the zap_vma_ptes has been called touches to the VMA will come here and
> + * Once the zap_special_vma_range has been called touches to the VMA will come here and
>   * we return a dummy writable zero page for all the pfns.
>   */
>  static vm_fault_t rdma_umap_fault(struct vm_fault *vmf)
> @@ -878,7 +878,7 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
>  				continue;
>  			list_del_init(&priv->list);
>
> -			zap_vma_ptes(vma, vma->vm_start,
> +			zap_special_vma_range(vma, vma->vm_start,
>  				     vma->vm_end - vma->vm_start);
>
>  			if (priv->entry) {
> diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
> index 8d749f345246..278b76cbd281 100644
> --- a/drivers/misc/sgi-gru/grumain.c
> +++ b/drivers/misc/sgi-gru/grumain.c
> @@ -542,7 +542,7 @@ void gru_unload_context(struct gru_thread_state *gts, int savestate)
>  	int ctxnum = gts->ts_ctxnum;
>
>  	if (!is_kernel_context(gts))
> -		zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
> +		zap_special_vma_range(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
>  	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
>
>  	gru_dbg(grudev, "gts %p, cbrmap 0x%lx, dsrmap 0x%lx\n",
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 833bedd3f739..07f6819db02d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2833,7 +2833,7 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
>  struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
>  		pud_t pud);
>
> -void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
> +void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
>  		  unsigned long size);
>  void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
>  			   unsigned long size);
> diff --git a/mm/memory.c b/mm/memory.c
> index dd737b6d28c0..f3b7b7e16138 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2233,17 +2233,15 @@ void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
>  }
>
>  /**
> - * zap_vma_ptes - remove ptes mapping the vma
> - * @vma: vm_area_struct holding ptes to be zapped
> - * @address: starting address of pages to zap
> + * zap_special_vma_range - zap all page table entries in a special vma range
> + * @vma: the vma covering the range to zap
> + * @address: starting address of the range to zap
>   * @size: number of bytes to zap
>   *
> - * This function only unmaps ptes assigned to VM_PFNMAP vmas.
> - *
> - * The entire address range must be fully contained within the vma.
> - *
> + * This function does nothing when the provided address range is not fully
> + * contained in @vma, or when the @vma is not VM_PFNMAP.
>   */
> -void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
> +void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
>  		unsigned long size)
>  {
>  	if (!range_in_vma(vma, address, address + size) ||
> @@ -2252,7 +2250,7 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>
>  	zap_vma_range(vma, address, size);
>  }
> -EXPORT_SYMBOL_GPL(zap_vma_ptes);
> +EXPORT_SYMBOL_GPL(zap_special_vma_range);
>
>  static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
>  {
> --
> 2.43.0
>

