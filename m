Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB63F0182F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD3D6B0089; Fri,  6 Mar 2026 07:26:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5AA36B008A; Fri,  6 Mar 2026 07:26:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C866B008C; Fri,  6 Mar 2026 07:26:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B50356B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:26:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 620631A0581
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:26:38 +0000 (UTC)
X-FDA: 84515561676.10.6348B36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CF64212000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:26:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TpY6K6f3;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYE4ZcOFvQQLvIxLcTOHQY7oY5ckRUcsZZi3R4n60ec=;
	b=RAlYKTrDaBM6B6xmIFdGNn6U+K4+HRCEN0a3ktPQOWv9dxbkK81YeCcYwW9jaLBmV4AbBV
	rmGyrJL/nNaSTU5cgFykJeQsKyWKdU+4LVqLVn11HdxSDH2zZDzD9i+MvZVmdgJ5HLocjo
	Ff+6U17rwYszQP+bjgifMrVPdV0RsHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772799996; a=rsa-sha256;
	cv=none;
	b=lkr63a24t4pv/S/MVHlW7rx2BQUgKTpAU7b5KJ4Ii+Hj2wJfJCDkl4akCu94WWnvP3IKv9
	M09AKD5CfyvCFwQB+wiL5/AdajNBdpbVb15dBrJYi8Yz9+Y8ExjJxoDyAv2ATYqC6ZfeF+
	RskF47qmqurqn6zYVf9zie2UDb8oNGQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TpY6K6f3;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB15241A00;
	Fri,  6 Mar 2026 12:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3469DC4CEF7;
	Fri,  6 Mar 2026 12:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772799994;
	bh=2P0FvPHpjsAhaxOTJ42bBLcCaRl4aaXZ5kIUOMNVWG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TpY6K6f3dvGsTTghQkD02tTChA2EwqMp/TpQHYfK66zjyTbZ8MiJAmvnb4buPO2Ol
	 ASVRmYPmWBmFSlqURChzwTNJTonaTuZGs5/EHFxAeEK+JJM37rDxeHbP+7uPAPbDNB
	 ZJH6y/sj2SwJrkrFUmj4U4BCckhgnUnVgGUpwh2dSE34XG3Ns9Rv8SqsanNsG90lqE
	 qDOiPmqQr5aqOlEJ3hzzDS0y2SX/ydi84zZQWgo/w3iX/S4bMLqQGcMFP6NoojCwMK
	 m9eF4QgqmVkNoXqv/RAre6ur7cbDQLHMeE6WwwrH+FV41xx9ytsuDVQOKxlgtAVRGn
	 vdR8q0SNanDlA==
Date: Fri, 6 Mar 2026 12:26:31 +0000
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
Subject: Re: [PATCH v1 10/16] mm/memory: use __zap_vma_range() in
 zap_vma_for_reaping()
Message-ID: <c03e1ced-6fa5-4d66-9c91-66693193383f@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-11-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-11-david@kernel.org>
X-Stat-Signature: zi79czi46f9p9ap451bef76n3nnz8jfh
X-Rspam-User: 
X-Rspamd-Queue-Id: CF64212000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772799995-35888
X-HE-Meta: U2FsdGVkX18ketJqwlchf1x0afHAgpxFhFtWO+kYDk3+QFQ95Fcv+fnM8AuR2MkyULAhF2G2IyQ8OsLmyt2mpASoo7WcJlnl41V0IMhlH0PBz+OryM/dPDpUsFCUpdUR1jDWXFFpV1mQsBlUIRiryrHqzdJnxivfgnV3rnc94Lh4LvxfnvTKfoUI94YEhbS7IyRR1atSNPN3btrXGte+c1GCTB8xN16cnf/p8iHe7HxDSGt19nLXcqI0yA3tpTqSwlQ51mar1NH4vvu9RJElchJGL69YvhvSJeQYfGYXtaBGpnD/SnLIFmLBMzNLtKEMGX2j4PhCetrDYQ3x6sNf34BlU7FYRb9/z1WdJrFCSPxe8ntl7VOyKh9vIriSw4u0M98omVYq7aZ8ryb6LJ8gDmX9CyoBm9tstxlBwkUdY/g5hWUr1WIUl/uqAX5hNt0RyGu6HjBDQrBJCR+R3J0nzBz+UWfWeFWhOnPNc35s87DU8D3zPdxZAEGMCYxhNt1xBqd7ycurPvnoaHkT6FG2EaDj779YycFABUFc39jkO0MgevWFxs/g8A42BL6PVGynwxK5FYdhXWvRS1syvXQ7sTyIw4jVQDqFqz7JCctFSrCpYCfYCzrbGSiPl+0dxXJ6GRN3NHaFtXSj0ENKC3UnxZpSZxdWgkResjqfon0YbWgRBowX7w3aJ3B4qpjx5vyUB00xzTD6eC92KnSCNe+//RwhHeE77JKC9muo5uLRHzhcdJxxl6pHSzz4F/e3jj40Ae44jz1hRQjE/ftrgZ8pN+L3RmnQoZgPcAzr/ftWah3SQca6JOU4/w0hJokG/oQ1ySc0T6Xocyw5OedyDnOcv/9l4k35ehCPxhWFVry7QBbQLe4dBze9TlKmo19mrjH0wweWkbeOZYVWB2e0RTtDJF/oHjI6uU6pB8+21/KdKWojiNZcqK83CyDD97x0gXlwi7Z2x0gWRi9XNGKT5Dm
 L1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:41PM +0100, David Hildenbrand (Arm) wrote:
> Let's call __zap_vma_range() instead of unmap_page_range() to prepare
> for further cleanups.
>
> To keep the existing behavior, whereby we do not call uprobe_munmap()
> which could block, add a new "reaping" member to zap_details and use it.

I am always in favour of making further use of helper structs :)

>
> Likely we should handle the possible blocking in uprobe_munmap()
> differently, but for now keep it unchanged.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

OK this looks like it's doing the equivalent of what was there before, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/mm.h |  1 +
>  mm/memory.c        | 13 +++++++++----
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 21b67c203e62..4710f7c7495a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2800,6 +2800,7 @@ struct zap_details {
>  	struct folio *single_folio;	/* Locked folio to be unmapped */
>  	bool skip_cows;			/* Do not zap COWed private pages */
>  	bool reclaim_pt;		/* Need reclaim page tables? */
> +	bool reaping;			/* Reaping, do not block. */
>  	zap_flags_t zap_flags;		/* Extra flags for zapping */
>  };
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 7d7c24c6917c..394b2e931974 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2079,14 +2079,18 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		unsigned long start, unsigned long end,
>  		struct zap_details *details)
>  {
> +	const bool reaping = details && details->reaping;
> +
>  	VM_WARN_ON_ONCE(start >= end || !range_in_vma(vma, start, end));
>
> -	if (vma->vm_file)
> +	/* uprobe_munmap() might sleep, so skip it when reaping. */
> +	if (vma->vm_file && !reaping)
>  		uprobe_munmap(vma, start, end);
>
>  	if (unlikely(is_vm_hugetlb_page(vma))) {
>  		zap_flags_t zap_flags = details ? details->zap_flags : 0;
>
> +		VM_WARN_ON_ONCE(reaping);
>  		/*
>  		 * vm_file will be NULL when we fail early while instantiating
>  		 * a new mapping. In this case, no pages were mapped yet and
> @@ -2111,11 +2115,12 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   */
>  int zap_vma_for_reaping(struct vm_area_struct *vma)
>  {
> +	struct zap_details details = {
> +		.reaping = true,
> +	};
>  	struct mmu_notifier_range range;
>  	struct mmu_gather tlb;
>
> -	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
> -

I guess because you've moved this safety check into __zap_vma_range()?

>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>  				vma->vm_start, vma->vm_end);
>  	tlb_gather_mmu(&tlb, vma->vm_mm);
> @@ -2123,7 +2128,7 @@ int zap_vma_for_reaping(struct vm_area_struct *vma)
>  		tlb_finish_mmu(&tlb);
>  		return -EBUSY;
>  	}
> -	unmap_page_range(&tlb, vma, range.start, range.end, NULL);
> +	__zap_vma_range(&tlb, vma, range.start, range.end, &details);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_finish_mmu(&tlb);
>  	return 0;
> --
> 2.43.0
>

