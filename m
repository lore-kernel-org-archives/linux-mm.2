Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39FD1C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B34B6B008C; Mon, 24 Aug 2026 11:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364466B0092; Mon, 24 Aug 2026 11:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253196B0095; Mon, 24 Aug 2026 11:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F10706B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:42:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7827B801A5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:42:22 +0000 (UTC)
X-FDA: 85136579724.30.D11664C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7E5D1C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:42:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGTNyzaq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787586140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDJOsrRKqI5xL2B6uMXlAlzziTORMVR8F6b3csb1Z5A=;
	b=0URA9Or5JvsUoRI7Ne9x396d5RSMoJMzJUlpKO/fA2SiUY4c4h0Q5GGPNfku1UcTTzxEgc
	xij8kcwppf+X+h/uoHBdP/Cd0WDV5HMqXTdWCIZsccAV09h8DTZR1zQQ3xYYFhIwlg2sG4
	HQXDg3nN7tQEcRBOaio+Vm0EZiIrOus=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dGTNyzaq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787586140;
	b=pzOwzjgnqBV0DEMzkHqhjBTJOYR3Yx5FY3mOpn/WZF/2Z9PHfvFoAu9G19tB61sbcpQrvv
	qbpb8nZ0zjoNcTq6ArBHN6JxkZqdO9FExnJrW6bJsl7tnGeszDV0XPr+LT7OvMtzf4X+Ew
	hRLBRlaTdY/EcV5WV4tUHbOKJ6QMlEg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C949843CB4;
	Mon, 24 Aug 2026 15:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77131F000E9;
	Mon, 24 Aug 2026 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787586139;
	bh=gDJOsrRKqI5xL2B6uMXlAlzziTORMVR8F6b3csb1Z5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dGTNyzaqagflzAHTgeexZXKKH+KVWAo5nC/pFnlYNZ56RSlS9nB43umegx0wHMJmS
	 hq9kMpzb4o38N0DTS9FFszdrlLkfpCVu81gw1ujGJPJ653xo7L8Ep6QtjNntzjNw4N
	 1f+xSwgrw+26Q3/gyUV+xfei3oASh97D1mDkSv7mviskBn7aV22SLBKMZwqeve2Ij0
	 dOYroJJJZHVEAX0e8z6IWMD3X4CwWvVc+HpA9JyQ9YMQX5Ijq6JCwe6ViRtcjjiS5x
	 4KagaCGikFM7wBeMmeZJjOlg3BkE5ZnoB5Pxscja+rzKQgZDGrjGHvOObGVSyGKbtT
	 uck17MVQs6PXg==
Date: Mon, 24 Aug 2026 16:42:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] userfaultfd: rename vm_userfaultfd_ctx to
 vm_uffd_state
Message-ID: <aoxl7W2wAqW_SYkI@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-4-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-4-3086981b33cf@kernel.org>
X-Rspamd-Queue-Id: B7E5D1C0003
X-Stat-Signature: m86wgoac44c6i7in5tiddzk3y83nse1b
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787586140-93200
X-HE-Meta: U2FsdGVkX1/YTE5aUPcVVgglzVcb4cPcG5YdyLgLg332nXQJ7//OLz5Qoy0QYVx/gb8hwWKGvmU8uloVAWoGpulG8fY/jtrE5o66H0o47p3CfNI2oGGVAfam2e6dIOrGnnunt1fXWP7Rmkm4uG6ZxjFO76PAcxH3MhAAd+s2GnvrTOnMhNln+tLEB8t+yWdtEl5JPW7+M14UQ/5fpRrHSTLmATe8PdOfTfm7CsfePxXpy91eFZuEyGosuojGR37AzfkhN+x99qDFz3Ua0rl/VhwHOPCi2J8M8ruZcscm4hFuLilaP0UUKeAjPMOfatDsSVHuBxmklIK9aIwmryk0XjalSsPDtIKQ8BwJ0gj6s+WSveZCA/D+eCQpRLn5izFjHJceoT9YKvscmBHBu0eIK9chN/yWx3ODgkRiRHWVWu/MoseS2uaVTxknbNSJ0C5qGD1aw+OxE5Zlns2ljOOEgjY3R60mU4KuY9bfRK1rtaKyMw1PM+/9zz1l9trnOCFlhiwVBfF8sCUKp1tmqcFb+oj4JF80moesWcSCozPNC+USl3LdID1HuroTMvTsSMZvNPLi271IXNm2yfqUSLrdJhwLThU2R5GzylQ3p1jnhsHedevy9eSy1Y6eKT6A+WYMYxSRGuek3tkM3ofk3xGV42STIbCqO5xIZ6RguFQvVgAT2HoXokbsTD3xdfhMQeE9WO1YojSvZUlTnJ25lq/IZPH9SHW01Mm7DvNW8esmKeFkdAm+Z3KS6TB1lo84S7Esqf1l+ZMrVVtOVTtISK8IB/qZFaXlot3PAhE+vfhYzV61YZsJn7WcSbAixixBavUwdEacQCxCD/flJiozkpj1HHFfTd0NF9xqPGZT8sEL9XpmIQSRhinyVSbc/pO1IN6JVu2gjRG5TkXDitx1NG+i13Af1QzYM+6jdppIKkz5doZBpv9oN+z/GfRcs8iPk1s2H4yFpmGTOjcwdJcllsZ
 bbruZzFk
 +6lPJOiTWUQBFoKdPv+ImlVWH21vJ50Fkh9E0ShTceGLjaunIZxBzxhukn1GFRR+vbpaNAhbRBQOCHE14uDcxasD2MReCVBNIWWBDL1Dw53UqWo3Ac2VZvJzXysj7BDyvaVguntmY2HAZfgFq6o1eFzow8bpyjreMK6YMp7xoRXVmRWGJgtkUyAJ3DR5BC7KkbY7pt2MeBWJUwr330+5ecBB+0MW5zPmQ8kT4rYNnmCojFo+aJTvfZsWse3nVr15IbyLxkpdUQacU0TZLkML/ZbTwo2gSk6C0iZzTjFM5xWt2Cqe91n4XPJugiV5+ZPMdaWUC6oF1ALrvTVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 03:17:41PM +0300, Mike Rapoport (Microsoft) wrote:
> Rename struct vm_userfaultfd_ctx to vm_uffd_state to better reflect that
> it will represent the userfaultfd state for a VMA rather than just a
> context pointer.
>
> This is a preparatory step for extending the struct with a mode field.
>
> Mechanical rename, no functional change.
>
> Assisted-by: copilot:claude-opus-4.6
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM and compiles GTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  Documentation/mm/process_addrs.rst |  4 +--
>  include/linux/mm_types.h           | 10 +++---
>  include/linux/userfaultfd_k.h      | 24 ++++++-------
>  mm/mremap.c                        |  4 +--
>  mm/userfaultfd.c                   | 74 +++++++++++++++++++-------------------
>  mm/vma.c                           |  4 +--
>  mm/vma.h                           |  6 ++--
>  mm/vma_init.c                      |  4 +--
>  tools/testing/vma/include/dup.h    |  2 +-
>  tools/testing/vma/include/stubs.h  |  6 ++--
>  10 files changed, 69 insertions(+), 69 deletions(-)
>
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index a7296f251799..481e9435e4e8 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -229,8 +229,8 @@ These are the core fields which describe the MM the VMA belongs to and its attri
>                                                             NUMA balancing in relation to this VMA.  lock.
>                                                             Updated under mmap read lock by
>                                                             :c:func:`!task_numa_work`.
> -   :c:member:`!vm_userfaultfd_ctx`   CONFIG_USERFAULTFD    Userfaultfd context wrapper object of    mmap write,
> -                                                           type :c:type:`!vm_userfaultfd_ctx`,      VMA write.
> +   :c:member:`!vm_uffd_state`        CONFIG_USERFAULTFD    Userfaultfd context wrapper object of    mmap write,
> +                                                           type :c:type:`!vm_uffd_state`,           VMA write.
>                                                             either of zero size if userfaultfd is
>                                                             disabled, or containing a pointer
>                                                             to an underlying
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6d815f6440c9..d6deb655d82e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -720,13 +720,13 @@ struct vm_region {
>  };
>
>  #ifdef CONFIG_USERFAULTFD
> -#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) { NULL, })
> -struct vm_userfaultfd_ctx {
> +#define NULL_VM_UFFD_STATE ((struct vm_uffd_state) { NULL, })
> +struct vm_uffd_state {
>  	struct userfaultfd_ctx *ctx;
>  };
>  #else /* CONFIG_USERFAULTFD */
> -#define NULL_VM_UFFD_CTX ((struct vm_userfaultfd_ctx) {})
> -struct vm_userfaultfd_ctx {};
> +#define NULL_VM_UFFD_STATE ((struct vm_uffd_state) {})
> +struct vm_uffd_state {};
>  #endif /* CONFIG_USERFAULTFD */
>
>  struct anon_vma_name {
> @@ -1071,7 +1071,7 @@ struct vm_area_struct {
>  	 */
>  	struct anon_vma_name *anon_name;
>  #endif
> -	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
> +	struct vm_uffd_state vm_uffd_state;
>  #ifdef __HAVE_PFNMAP_TRACKING
>  	struct pfnmap_track_ctx *pfnmap_track_ctx;
>  #endif
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index d8262e3dc134..45355bdb4ec7 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -162,10 +162,10 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  			unsigned long dst_addr, unsigned long src_addr);
>
>  /* mm helpers */
> -static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> -					struct vm_userfaultfd_ctx vm_ctx)
> +static inline bool is_mergeable_vm_uffd_state(struct vm_area_struct *vma,
> +					struct vm_uffd_state vm_ctx)
>  {
> -	return vma->vm_userfaultfd_ctx.ctx == vm_ctx.ctx;
> +	return vma->vm_uffd_state.ctx == vm_ctx.ctx;
>  }
>
>  static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> @@ -264,7 +264,7 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
>
>  static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
>  {
> -	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
> +	struct userfaultfd_ctx *uffd_ctx = vma->vm_uffd_state.ctx;
>
>  	return uffd_ctx && (uffd_ctx->features & UFFD_FEATURE_EVENT_REMAP) == 0;
>  }
> @@ -274,11 +274,11 @@ extern void dup_userfaultfd_complete(struct list_head *);
>  void dup_userfaultfd_fail(struct list_head *);
>
>  extern void mremap_userfaultfd_prep(struct vm_area_struct *,
> -				    struct vm_userfaultfd_ctx *);
> -extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *,
> +				    struct vm_uffd_state *);
> +extern void mremap_userfaultfd_complete(struct vm_uffd_state *,
>  					unsigned long from, unsigned long to,
>  					unsigned long len);
> -void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *);
> +void mremap_userfaultfd_fail(struct vm_uffd_state *);
>
>  extern bool userfaultfd_remove(struct vm_area_struct *vma,
>  			       unsigned long start,
> @@ -345,8 +345,8 @@ static inline long uffd_wp_range(struct vm_area_struct *vma,
>  	return false;
>  }
>
> -static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> -					struct vm_userfaultfd_ctx vm_ctx)
> +static inline bool is_mergeable_vm_uffd_state(struct vm_area_struct *vma,
> +					struct vm_uffd_state vm_ctx)
>  {
>  	return true;
>  }
> @@ -420,18 +420,18 @@ static inline void dup_userfaultfd_fail(struct list_head *l)
>  }
>
>  static inline void mremap_userfaultfd_prep(struct vm_area_struct *vma,
> -					   struct vm_userfaultfd_ctx *ctx)
> +					   struct vm_uffd_state *ctx)
>  {
>  }
>
> -static inline void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *ctx,
> +static inline void mremap_userfaultfd_complete(struct vm_uffd_state *ctx,
>  					       unsigned long from,
>  					       unsigned long to,
>  					       unsigned long len)
>  {
>  }
>
> -static inline void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *ctx)
> +static inline void mremap_userfaultfd_fail(struct vm_uffd_state *ctx)
>  {
>  }
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e8df5cdb0ac9..a4a38f30b255 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -56,7 +56,7 @@ struct vma_remap_struct {
>  	unsigned long new_addr;	/* Optionally, desired new address. */
>
>  	/* uffd state. */
> -	struct vm_userfaultfd_ctx *uf;
> +	struct vm_uffd_state *uf;
>  	struct list_head *uf_unmap_early;
>  	struct list_head *uf_unmap;
>
> @@ -2033,7 +2033,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
>  		unsigned long, new_len, unsigned long, flags,
>  		unsigned long, new_addr)
>  {
> -	struct vm_userfaultfd_ctx uf = NULL_VM_UFFD_CTX;
> +	struct vm_uffd_state uf = NULL_VM_UFFD_STATE;
>  	LIST_HEAD(uf_unmap_early);
>  	LIST_HEAD(uf_unmap);
>  	/*
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 32003aa04943..119304547230 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -99,7 +99,7 @@ bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  	 * enforce the VM_MAYWRITE check done at uffd registration
>  	 * time.
>  	 */
> -	if (!dst_vma->vm_userfaultfd_ctx.ctx)
> +	if (!dst_vma->vm_uffd_state.ctx)
>  		return false;
>
>  	return true;
> @@ -1812,8 +1812,8 @@ static int validate_move_areas(struct userfaultfd_ctx *ctx,
>  		return -EINVAL;
>
>  	/* Ensure dst_vma is registered in uffd we are operating on */
> -	if (!dst_vma->vm_userfaultfd_ctx.ctx ||
> -	    dst_vma->vm_userfaultfd_ctx.ctx != ctx)
> +	if (!dst_vma->vm_uffd_state.ctx ||
> +	    dst_vma->vm_uffd_state.ctx != ctx)
>  		return -EINVAL;
>
>  	/* Only allow moving across anonymous vmas */
> @@ -2249,7 +2249,7 @@ static void userfaultfd_set_ctx(struct vm_area_struct *vma,
>  				vm_flags_t vm_flags)
>  {
>  	vma_start_write(vma);
> -	vma->vm_userfaultfd_ctx = (struct vm_userfaultfd_ctx){ctx};
> +	vma->vm_uffd_state = (struct vm_uffd_state){ctx};
>  	userfaultfd_set_vm_flags(vma,
>  				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags);
>  }
> @@ -2296,7 +2296,7 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
>  	}
>
>  	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
> -				    &new_vma_flags, NULL_VM_UFFD_CTX,
> +				    &new_vma_flags, NULL_VM_UFFD_STATE,
>  				    give_up_on_oom);
>
>  	/*
> @@ -2330,15 +2330,15 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		cond_resched();
>
>  		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
> -		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx &&
> -				vma->vm_userfaultfd_ctx.ctx != ctx);
> +		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx &&
> +				vma->vm_uffd_state.ctx != ctx);
>  		VM_WARN_ON_ONCE(!vma_test(vma, VMA_MAYWRITE_BIT));
>
>  		/*
>  		 * Nothing to do: this vma is already registered into this
>  		 * userfaultfd and with the right tracking mode too.
>  		 */
> -		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
> +		if (vma->vm_uffd_state.ctx == ctx &&
>  		    vma_test_all_mask(vma, vma_flags))
>  			goto skip;
>
> @@ -2347,7 +2347,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 * switches that would drop VM_UFFD_WP or VM_UFFD_RWP, so a
>  		 * stray bit here is a bug.
>  		 */
> -		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx == ctx &&
> +		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx == ctx &&
>  				vma->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags);
>
>  		if (vma->vm_start > start)
> @@ -2360,7 +2360,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>
>  		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
>  					    &new_vma_flags,
> -					    (struct vm_userfaultfd_ctx){ctx},
> +					    (struct vm_uffd_state){ctx},
>  					    /* give_up_on_oom = */false);
>  		if (IS_ERR(vma))
>  			return PTR_ERR(vma);
> @@ -2389,10 +2389,10 @@ static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
>  	struct vm_area_struct *vma;
>  	VMA_ITERATOR(vmi, mm, 0);
>
> -	/* the various vma->vm_userfaultfd_ctx still points to it */
> +	/* the various vma->vm_uffd_state still points to it */
>  	mmap_write_lock(mm);
>  	for_each_vma(vmi, vma) {
> -		if (vma->vm_userfaultfd_ctx.ctx == ctx)
> +		if (vma->vm_uffd_state.ctx == ctx)
>  			userfaultfd_reset_ctx(vma);
>  	}
>  	mmap_write_unlock(mm);
> @@ -2419,9 +2419,9 @@ static void userfaultfd_release_all(struct mm_struct *mm,
>  	prev = NULL;
>  	for_each_vma(vmi, vma) {
>  		cond_resched();
> -		VM_WARN_ON_ONCE(!!vma->vm_userfaultfd_ctx.ctx ^
> +		VM_WARN_ON_ONCE(!!vma->vm_uffd_state.ctx ^
>  				!!(vma->vm_flags & __VM_UFFD_FLAGS));
> -		if (vma->vm_userfaultfd_ctx.ctx != ctx) {
> +		if (vma->vm_uffd_state.ctx != ctx) {
>  			prev = vma;
>  			continue;
>  		}
> @@ -2512,7 +2512,7 @@ static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
>   */
>  bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
>  {
> -	struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
> +	struct userfaultfd_ctx *ctx = vma->vm_uffd_state.ctx;
>
>  	if (!ctx)
>  		return false;
> @@ -2854,7 +2854,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>
>  	assert_fault_locked(vmf);
>
> -	ctx = vma->vm_userfaultfd_ctx.ctx;
> +	ctx = vma->vm_uffd_state.ctx;
>  	if (!ctx)
>  		goto out;
>
> @@ -3094,7 +3094,7 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
>  	struct userfaultfd_ctx *ctx = NULL, *octx;
>  	struct userfaultfd_fork_ctx *fctx;
>
> -	octx = vma->vm_userfaultfd_ctx.ctx;
> +	octx = vma->vm_uffd_state.ctx;
>  	if (!octx)
>  		return 0;
>
> @@ -3138,7 +3138,7 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
>  		list_add_tail(&fctx->list, fcs);
>  	}
>
> -	vma->vm_userfaultfd_ctx.ctx = ctx;
> +	vma->vm_uffd_state.ctx = ctx;
>  	return 0;
>  }
>
> @@ -3195,11 +3195,11 @@ void dup_userfaultfd_fail(struct list_head *fcs)
>  }
>
>  void mremap_userfaultfd_prep(struct vm_area_struct *vma,
> -			     struct vm_userfaultfd_ctx *vm_ctx)
> +			     struct vm_uffd_state *vm_ctx)
>  {
>  	struct userfaultfd_ctx *ctx;
>
> -	ctx = vma->vm_userfaultfd_ctx.ctx;
> +	ctx = vma->vm_uffd_state.ctx;
>
>  	if (!ctx)
>  		return;
> @@ -3216,7 +3216,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
>  	}
>  }
>
> -void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *vm_ctx,
> +void mremap_userfaultfd_complete(struct vm_uffd_state *vm_ctx,
>  				 unsigned long from, unsigned long to,
>  				 unsigned long len)
>  {
> @@ -3236,7 +3236,7 @@ void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *vm_ctx,
>  	userfaultfd_event_wait_completion(ctx, &ewq);
>  }
>
> -void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
> +void mremap_userfaultfd_fail(struct vm_uffd_state *vm_ctx)
>  {
>  	struct userfaultfd_ctx *ctx = vm_ctx->ctx;
>
> @@ -3255,7 +3255,7 @@ bool userfaultfd_remove(struct vm_area_struct *vma,
>  	struct userfaultfd_ctx *ctx;
>  	struct userfaultfd_wait_queue ewq;
>
> -	ctx = vma->vm_userfaultfd_ctx.ctx;
> +	ctx = vma->vm_uffd_state.ctx;
>  	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE))
>  		return true;
>
> @@ -3293,7 +3293,7 @@ int userfaultfd_unmap_prep(struct vm_area_struct *vma, unsigned long start,
>  			   unsigned long end, struct list_head *unmaps)
>  {
>  	struct userfaultfd_unmap_ctx *unmap_ctx;
> -	struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
> +	struct userfaultfd_ctx *ctx = vma->vm_uffd_state.ctx;
>
>  	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
>  	    has_unmap_ctx(ctx, unmaps, start, end))
> @@ -3813,7 +3813,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  	do {
>  		cond_resched();
>
> -		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
> +		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
>  				!!(cur->vm_flags & __VM_UFFD_FLAGS));
>
>  		/* check not compatible vmas */
> @@ -3867,8 +3867,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 * wouldn't know which one to deliver the userfaults to.
>  		 */
>  		ret = -EBUSY;
> -		if (cur->vm_userfaultfd_ctx.ctx &&
> -		    cur->vm_userfaultfd_ctx.ctx != ctx)
> +		if (cur->vm_uffd_state.ctx &&
> +		    cur->vm_uffd_state.ctx != ctx)
>  			goto out_unlock;
>
>  		/*
> @@ -3877,7 +3877,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 * subsequent mprotect() would then promote stale markers
>  		 * into the other mode. Require an unregister first.
>  		 */
> -		if (cur->vm_userfaultfd_ctx.ctx == ctx &&
> +		if (cur->vm_uffd_state.ctx == ctx &&
>  		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
>  			goto out_unlock;
>
> @@ -3985,15 +3985,15 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  	do {
>  		cond_resched();
>
> -		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
> +		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
>  				!!(cur->vm_flags & __VM_UFFD_FLAGS));
>
>  		/*
>  		 * Prevent unregistering through a different userfaultfd than
>  		 * the one used for registration.
>  		 */
> -		if (cur->vm_userfaultfd_ctx.ctx &&
> -		    cur->vm_userfaultfd_ctx.ctx != ctx)
> +		if (cur->vm_uffd_state.ctx &&
> +		    cur->vm_uffd_state.ctx != ctx)
>  			goto out_unlock;
>
>  		/*
> @@ -4020,10 +4020,10 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		cond_resched();
>
>  		/* VMA not registered with userfaultfd. */
> -		if (!vma->vm_userfaultfd_ctx.ctx)
> +		if (!vma->vm_uffd_state.ctx)
>  			goto skip;
>
> -		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx != ctx);
> +		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx != ctx);
>  		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
>  		VM_WARN_ON_ONCE(!(vma->vm_flags & VM_MAYWRITE));
>
> @@ -4041,7 +4041,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  			struct userfaultfd_wake_range range;
>  			range.start = start;
>  			range.len = vma_end - start;
> -			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
> +			wake_userfault(vma->vm_uffd_state.ctx, &range);
>  		}
>
>  		vma = userfaultfd_clear_vma(&vmi, prev, vma,
> @@ -4382,7 +4382,7 @@ static int userfaultfd_set_mode(struct userfaultfd_ctx *ctx,
>  		VMA_ITERATOR(vmi, mm, 0);
>
>  		for_each_vma(vmi, vma) {
> -			if (vma->vm_userfaultfd_ctx.ctx == ctx)
> +			if (vma->vm_uffd_state.ctx == ctx)
>  				vma_start_write(vma);
>  		}
>  	}
> @@ -4537,12 +4537,12 @@ static inline int userfaultfd_poison(struct userfaultfd_ctx *ctx, unsigned long
>
>  bool userfaultfd_wp_async(struct vm_area_struct *vma)
>  {
> -	return userfaultfd_wp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
> +	return userfaultfd_wp_async_ctx(vma->vm_uffd_state.ctx);
>  }
>
>  bool userfaultfd_rwp_async(struct vm_area_struct *vma)
>  {
> -	return userfaultfd_rwp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
> +	return userfaultfd_rwp_async_ctx(vma->vm_uffd_state.ctx);
>  }
>
>  static inline unsigned int uffd_ctx_features(__u64 user_features)
> diff --git a/mm/vma.c b/mm/vma.c
> index 35e7a64855fa..f2c65d148498 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -118,7 +118,7 @@ static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_nex
>  		return false;
>  	if (vma->vm_file != vmg->file)
>  		return false;
> -	if (!is_mergeable_vm_userfaultfd_ctx(vma, vmg->uffd_ctx))
> +	if (!is_mergeable_vm_uffd_state(vma, vmg->uffd_ctx))
>  		return false;
>  	if (!anon_vma_name_eq(anon_vma_name(vma), vmg->anon_name))
>  		return false;
> @@ -1837,7 +1837,7 @@ struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
>  struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
>  		struct vm_area_struct *prev, struct vm_area_struct *vma,
>  		unsigned long start, unsigned long end,
> -		const vma_flags_t *vma_flags, struct vm_userfaultfd_ctx new_ctx,
> +		const vma_flags_t *vma_flags, struct vm_uffd_state new_ctx,
>  		bool give_up_on_oom)
>  {
>  	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
> diff --git a/mm/vma.h b/mm/vma.h
> index 024fabe63560..ab23a65750de 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -114,7 +114,7 @@ struct vma_merge_struct {
>  	struct file *file;
>  	struct anon_vma *anon_vma;
>  	struct mempolicy *policy;
> -	struct vm_userfaultfd_ctx uffd_ctx;
> +	struct vm_uffd_state uffd_ctx;
>  	struct anon_vma_name *anon_name;
>  	enum vma_merge_state state;
>
> @@ -349,7 +349,7 @@ static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
>  		.file = vma_->vm_file,					\
>  		.anon_vma = vma_->anon_vma,				\
>  		.policy = vma_policy(vma_),				\
> -		.uffd_ctx = vma_->vm_userfaultfd_ctx,			\
> +		.uffd_ctx = vma_->vm_uffd_state,			\
>  		.anon_name = anon_vma_name(vma_),			\
>  		.state = VMA_MERGE_START,				\
>  	}
> @@ -519,7 +519,7 @@ __must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
>  __must_check struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
>  		struct vm_area_struct *prev, struct vm_area_struct *vma,
>  		unsigned long start, unsigned long end, const vma_flags_t *vma_flags,
> -		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom);
> +		struct vm_uffd_state new_ctx, bool give_up_on_oom);
>
>  __must_check struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
>
> diff --git a/mm/vma_init.c b/mm/vma_init.c
> index baa7e82f47e3..61ddb31318bb 100644
> --- a/mm/vma_init.c
> +++ b/mm/vma_init.c
> @@ -62,8 +62,8 @@ static void vm_area_init_from(const struct vm_area_struct *src,
>  	 * dup_mmap(), but the clone will reinitialize it.
>  	 */
>  	data_race(memcpy(&dest->shared, &src->shared, sizeof(dest->shared)));
> -	memcpy(&dest->vm_userfaultfd_ctx, &src->vm_userfaultfd_ctx,
> -	       sizeof(dest->vm_userfaultfd_ctx));
> +	memcpy(&dest->vm_uffd_state, &src->vm_uffd_state,
> +	       sizeof(dest->vm_uffd_state));
>  #ifdef CONFIG_ANON_VMA_NAME
>  	dest->anon_name = src->anon_name;
>  #endif
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index 4c58487b764e..1a01c3529d22 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -634,7 +634,7 @@ struct vm_area_struct {
>  	 */
>  	struct anon_vma_name *anon_name;
>  #endif
> -	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
> +	struct vm_uffd_state vm_uffd_state;
>  } __randomize_layout;
>
>  struct vm_operations_struct {
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index d6136e19a8af..dcd1b1719928 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -33,7 +33,7 @@ struct unmap_desc;
>
>  #define ASSERT_EXCLUSIVE_WRITER(x)
>
> -struct vm_userfaultfd_ctx {};
> +struct vm_uffd_state {};
>  struct mempolicy {};
>  struct mmu_gather {};
>  struct mutex {};
> @@ -350,8 +350,8 @@ static inline struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
>  	return NULL;
>  }
>
> -static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
> -					struct vm_userfaultfd_ctx vm_ctx)
> +static inline bool is_mergeable_vm_uffd_state(struct vm_area_struct *vma,
> +					struct vm_uffd_state vm_ctx)
>  {
>  	return true;
>  }
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

