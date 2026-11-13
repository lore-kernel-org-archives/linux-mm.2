Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC262606A881
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kt6+iD3k
Received: by kanga.kvack.org (Postfix)
	id 13D166B00EF; Fri, 13 Nov 2026 15:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE336B05B1; Fri, 13 Nov 2026 15:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004686B05BB; Fri, 13 Nov 2026 15:47:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22BB6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:47:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C269B4024B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:47:12 +0000 (UTC)
X-FDA: 85431280704.29.342AC24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1302414000D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:47:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kt6+iD3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794602831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpuCbiqHWI22jSKEai65DFEmOF/zcUZ3fQHI3h+jGcY=;
	b=lisxzhN9DQAUEX9LnbmwTjh9XEu7Sswg7UxsELV/pom2g4Vh3zmeukwozb2Gyu8oJ9euDJ
	6NDh2KMSxtnwBc54JuL7WCyKh4i/DChzWa4Rvwou5GYhXxlTniywIFzRpGN8Axr0VNsNvP
	Xs6Y5J7voGxApllsVdedTgREwfkSPU4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kt6+iD3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794602831;
	b=Nar6YQkTLnm+W7UY2Bkmm2B0HCHEg0HHGsMGbtwRZ6E63et8Hyt9quw64mYAGznE8eQXnD
	+rPqcfVDHBSOY7D6PjXPmkq+xTIaYrrgvUKF9KnAsaruTeT63muF+j3kNzVeRPDC6VD1JX
	J79NCRwHL94r1XIfM9QUwbhLroUw6po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48D1A44750;
	Fri, 13 Nov 2026 20:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D781F000C4;
	Fri, 13 Nov 2026 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794602830;
	bh=kpuCbiqHWI22jSKEai65DFEmOF/zcUZ3fQHI3h+jGcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kt6+iD3kp33fAUiGtW76c1GSpii1p1VDfXhRdlDU3CsFPxJAsgoPl0sBkAqvej0I+
	 ohh1q/Rtzqd5XQ8L4QZhuZDHwSj9xEZlSnPEHenDFWwufhl2aw3NE6nZaI2MziW2Nx
	 9Y6/YI808p2Yh/KlQvrxkzUSfSUA/Ia6b1GvttzhslG9fZ6Qj4GPnNYS+07c7K0wNU
	 8kkzMUs3yw6GTu2bp7DMAIABUCS8aPaUrGuemktnBP8+/z2Zd0AffjGkS4l7bivqNn
	 /78CICqNX9bQ5gtxyE1N5u2o6u6dDb7bzZdRqWVegNlwCj4shP7odI+5R4w3A3uIax
	 a2hQAGC5UypPg==
Date: Fri, 13 Nov 2026 20:47:03 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, akpm@linux-foundation.org, david@kernel.org, peterx@redhat.com, 
	imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 1/9] mm: fix eager write-bit restore for
 write-notified shared mappings
Message-ID: <avd12eMWaTl87uL0@gremlin>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-3-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261112142039.907090-3-clopez@suse.de>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1302414000D
X-Stat-Signature: rxb5tyxk8rsdi56mt5wr1zzahuge7drb
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794602830-978657
X-HE-Meta: U2FsdGVkX1/A/FcZbW6Gv0EObPE80eCJST53XpFn83u7hu0qLlR1CW0aG3RTG0U78mp+UKYB8BaMRY84Do9/uhbfQhtlvewBSm5lJNByLOC+fttagN6l9hxkZKTfwF0bo/rdMl4qdEAg+/T+5ESzOm0KrpADUttiFRvdm+NPEVqqcdBtQ1YEDn+4O1YsUQ6kB3/QTKqrAWRprQXChB3k8WUgFiSauZ9x7OdKJ3HACtXbY5V1/MNd6tcv9d+hmkzJhXunPMg6UkM92W/JbXs7DEcSGFDkpaHrMU8lI1r9cFvi/PofR9pd86ShpOcaXjqfbDKkdlIRkiT3YOobe1af00RS81ZyM3O9UyqMX89si2t+Rtx7V9R5YxgsupB63vFw/g/j8XUjsos25wl2gouzo5qcdFsFv4FKlk/3F0gnqfUxwb/xfPp9bjsRT/sKeultRW96bxev2v4849mqNu/fqxkkxEEmtWHX2ujPTYL9etbaqVujGCwCTxaGhBziL0ku2yDkpfYKnbEct/x0ZpMtN2osCna1Dp4Una8S+Lqv3jf3aOalmy2Hm/8xpNpZwyUv5GwGbAA7o6J7YUobFKJmEb4oKqLB1ifda0wm5HyeD0ftVI5n9PBJWltkTf7pUcYv08IZLG2jXSvw0FDmFfkdVUiEcIfq9+U2BYmMFVkupl4FC2xPhql2oTztmzljFrpRUa7UobtHZagzPGUrBZfDbcjsSWRYm4AEUxcOG6eBMZHee8rwGqJbiHlg3zYUU/pWL4IqINAFgPovmHJlCS/0/DGxUWvQ22+NKTnGiVbgPqbqdGzTbzKSsACssdgCahkJWYVMzqJqtDwD+taMvtxbppBjtGCcr17JTDtICUPUohuHcF4fhx1ZOQ0EFmftTFU1MCXxeCmlQEYA5z17JcVf9KgBuv4DVHRtZ0Dd3/V6vzcxVjdPXdUwJLkkKHNDyF7EqWu7SVCErzZeMd614gE
 dj079I3m
 2woMIuRmtphfsSciT8+bomDURDLxTThKm8r3huNPrIe2mh0SIhcy9QJ19dHfSodTD0fQmlnVAqaDIC6xHDulfzuT0HBJEcUCDbnB4agteR3XGazLRYRbPc68yngIj9pzLCbORY61rX2gxV4VwRNrIJ8p8sD+J0K2s6KA5he+i4sCAOu6fqu86Uctzbn5EWxtEKlHPARElBJ43mrBXKSVxzg9d2/Q6K6FqG2x/hVp5Y5gatgcRjXBfSE21YeBErIPcQrvAyQNAJCj40rqIzTM31gwT+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 03:20:30PM +0100, Carlos López wrote:
> change_protection() applies vma->vm_page_prot, which lacks the write bit
> for CoW and write-notified mappings. Callers set
> MM_CP_TRY_CHANGE_WRITABLE when vma_wants_manual_pte_write_upgrade()
> returns true, so that entries that can be written without a fault, such
> as dirty PTEs in a shared mapping, are made writable right away.
>
> For shared mappings, that function passes vma->vm_page_prot to
> vma_wants_writenotify(). Once writenotify is enabled, this protection
> lacks the write bit, while the vma_pgprot_modify() result it is compared
> against adds it back. The two never match, so vma_wants_writenotify()
> returns false before checking for soft-dirty, uffd-wp and writeback.
>
> As a result, write-notified shmem mappings never get
> MM_CP_TRY_CHANGE_WRITABLE. For example, commit 931298e103c2
> ("mm/userfaultfd: rely on vma->vm_page_prot in uffd_wp_range()") made
> uffd-wp unprotect set the flag so that dirty shmem PTEs become writable
> again, but this never takes effect. Unprotecting N dirty shmem pages
> still leads to N faults that only set the write bit.
>
> This dates back to the commit in the Fixes tag, which moved the
> equivalent check in mprotect_fixup() before vma_set_page_prot().
>
> Fix this by passing the protection recomputed from the VMA flags, as
> vma_set_page_prot() does.
>
> Note: this only affects performance, as the next write fault restores
> the write bit anyway.
>
> Fixes: 64e455079e1b ("mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared")
> Signed-off-by: Carlos López <clopez@suse.de>
> ---
>  mm/vma.h | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/mm/vma.h b/mm/vma.h
> index 3fc3b47a954b..e83700e248e4 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -589,6 +589,14 @@ int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	      unsigned long addr, int new_below);
>  #endif
>
> +#ifdef CONFIG_MMU
> +static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
> +{
> +	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
> +
> +	return pgprot_modify(oldprot, prot);
> +}
> +
>  static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
>  {
>  	/*
> @@ -596,19 +604,16 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
>  	 * if we can't do that automatically for all PTEs in a mapping. For
>  	 * private mappings, that's always the case when we have write
>  	 * permissions as we properly have to handle COW.
> +	 *
> +	 * vma->vm_page_prot lacks the write bit if writenotify is already
> +	 * enabled, so pass it with the bits restored, as vma_set_page_prot()
> +	 * does.

We don't write code in comments.

>  	 */
>  	if (vma->vm_flags & VM_SHARED)
> -		return vma_wants_writenotify(vma, vma->vm_page_prot);
> +		return vma_wants_writenotify(vma,
> +		       vma_pgprot_modify(vma->vm_page_prot, vma->flags));

You mention vma_set_page_prot() but then implement it differently from there and
make no effort to abstract it?

And so both callers now do the same thing, and both open code it... you should
abstract that.

>  	return !!(vma->vm_flags & VM_WRITE);
>  }
> -
> -#ifdef CONFIG_MMU
> -static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
> -{
> -	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
> -
> -	return pgprot_modify(oldprot, prot);
> -}
>  #endif
>
>  static inline struct vm_area_struct *vma_prev_limit(struct vma_iterator *vmi,
> --
> 2.51.0
>

--
Cheers, Lorenzo

