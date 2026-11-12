Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADABE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=Apt7oOvV
Received: by kanga.kvack.org (Postfix)
	id B19F56B05EE; Thu, 12 Nov 2026 17:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0B16B05EF; Thu, 12 Nov 2026 17:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06726B05F0; Thu, 12 Nov 2026 17:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74E066B05EE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:01:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0846D81C3E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:01:40 +0000 (UTC)
X-FDA: 85427839560.12.E7D88FB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id DDC66C0009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:01:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Apt7oOvV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794520898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYAvoSz1A76P7GMxxUw4ni69cJw2k++GQ4cfCIGFRUU=;
	b=THPwvuge3U1yhOS1dmmyyyutZEYzk895gB3EO9Z0Vr2brrm3WIKw+4P9tDMCi86A2X41x4
	d6q9vJPC9Na1Gw27XAdWQDeJtFEdRUJFNyQnNd96JWdK3zmnZVSmVikluKmpHv58s9QA2A
	/MMhXdX7fqXhEVkhxukSkct3rtmyOkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794520898;
	b=JOrQ9Ta5rUzHN8fvr95DWMXh+en8A6bFDw0xA624q4V4R2JCURnjafGQrLO/+mpfM/jx0k
	Elh7uJs4PCYwu11Q+MH84JCpE+SofBKNh7OgsEn3F1RXcwzdDrtqi41w2p60j5WxsDfeuL
	iCa+ZDDGTz8nfa742eh+hYeP5KFMwxQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Apt7oOvV;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nYAvoSz1A76P7GMxxUw4ni69cJw2k++GQ4cfCIGFRUU=; b=Apt7oOvVaHX4TicoqGSGBkX1xh
	BHtbNZyS50r5CpIeV3U1BsRvrpzJqArlV/4d0yz+S8HnDMPjS0XZC54MSwtmNxRT2HJfnvPsww+4C
	suCFcgRwSliM8e9YVKk8u+N+3YEW5Rd/w8b3oCsOSKnvA6M8C4bz6jDQsFZ884Pk1nwvwsI1A2N3n
	f+xrWkbK7qPUP+JmYRq45tq8YFBKDQRduspc6JARQPWlHSv+j52wx5eVS/gOg1H7347fjZmjN7ln4
	bOBI+JbeYHPsd96SzSym3Sc+NB/D6Hl6L7poxSBh9DBshwpDfDAjzepc6pTJbxbLIcdWsmj9ezIf8
	V5iVBaWQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRcrQ-0000000B8jr-0gBG;
	Thu, 12 Nov 2026 22:01:36 +0000
Date: Thu, 12 Nov 2026 17:01:34 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Li Jinyue <jinyue.li@linux.alibaba.com>
Subject: Re: [PATCH] mm/vma: update VMA iterator state on error in new VMA
 merge
Message-ID: <gp4huj53rndmngvzajdfelalmh5gkhzqv73t2v6rotmr37hgpb@g4a33cixtylu>
References: <20261027-fix-new-merge-bug-v1-1-7023a787e6b9@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fix-new-merge-bug-v1-1-7023a787e6b9@kernel.org>
X-Stat-Signature: gbxdmun3dnykam44emumi38soccoqk1b
X-Rspam-User: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDC66C0009
X-HE-Tag: 1794520897-693191
X-HE-Meta: U2FsdGVkX18AAsJadujQg8tnTQuJDvN90JTXjiW2VqaGC0XfslOm3NiJR8mLc1mhgPGPce0pYoyuwcz/qLg9G8inQdm504Fc7bNo8P+utW5/yAhclkuh57cSoc5hwMxSIbagVEU83srUqbgsMOutVLJDYRweoScPDp33GBmPW2g/GD8ybcDfAb77WwHH4LICHtHlFfhLt6a09ukALD3i16JlpIQtLOpStuHSzECVhNWHCi3iil5d6PrA8Tl85Ach2Naa9YoBWfdBSWJSvXvlbwyQUW0f2ErIW7thqF/l5NqQNTAgbhiQmS0RQJWkMoN1NeFqI+28+7dULZrlWiv4/O9E3Bu6BCGq9+CRkH06J+/E1Zg6ovORfEYLD/lx5RE9LVm+3B1lmHduSTJwnifoeAELq+cwh9h2RBNSKU7KNkJNg6+p9pR4t9Qf4iBy0a5yVeh68bVWgKgSYzfhrXYERb8MnygfnEYnm/1Lw8+vgYg2oJMNYpKKqw2/6Xnr033ovYGJiW6XFF+waHJ4JaX1LHvuHis6zFH0JGupflmHJwBQYfe3D/DOmSJj9fmC3bhz3qeZnEEbp3BLDXyySVGojGdEIZeYVdCeIe/kYtV4lNCvfFs+/IP8mIQwYdpbLHpcgLBuSNBVSOYiLYeEBUB+d3EqbmUNuMxdYIAuEVtSW+Osj7dpt0AZs8O4wWDUXi9z3Cg5Zlm9rhbLz1vB93uPRvefEDJTAMn6wK1Hj4f1i265Xa1Ybvq/mmjkw2MPzQskQn7D+xVylNiZ8n7pDU2fVxWmzsgCBfwQfgVexQoYNswO8nTfDcpkWDFWXtUjauo/38b93xwJxcXt220QEoi8UlXAtmpjI5yLPuG0IIhbGX6GQVGlE21PM/y+RFL5Y7Zzp0EwbcUJk0YV0MQBXFcRi7M9qAr2YZ8/hzZ4O0BqRSCjdU4FUgppcXkkessKV7OEKukpKXV1rfw6lmPyN5J
 LYk+IYzp
 9BnzOa5enbyGN8LkKt4MA9nl3VzGf27RnLlutnxPDZYeX5hQed9vCzm1ZcwgOAk1/4FVispBXfnl78oUQHhyKUZmoUi1IHaAI0DeJz8ExX4oufaQHQ2rCIF37Zzwn9IZEXWmyNztdKnayH0eBYdsu02vNc6xg4kX2EBP67a/I5abjNQ9DblT17LDbPkxgnprJ898XtmFy/BqmI3TxOWtzgXAeuf6t+2feJefER/xeIXoEX6vtvoFF9117fq0Udpt2KtFjfS5mY92wcyumWGkVHe5z5aLSxoerbdOiBmSR+xgDKHtnsVXihz+A1DNxPK+7gPl/Wk5Uxb2GdR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/27 11:25AM, Lorenzo Stoakes (ARM) wrote:

I'm a bit late on this one..

> Commit cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs") shared
> code between vma_merge_new_range() and vma_expand().
> 
> However in doing so, it failed to correctly restore the VMA iterator when
> vma_expand() errors out.
> 
> This is a problem when the immediately preceding VMA is mergeable and
> vmg->just_expand isn't specified, at which point the VMA iterator is moved
> to the previous VMA.
> 
> (Note that vmg->just_expand is a special case for brk(), where the
> iterator will already be positioned at the VMA to be expanded.)
> 
> Resolve things by restoring the VMA iterator on error. Use
> vma_iter_next_range() to do this, so it will correctly stop on the gap
> after the previous VMA, rather than skip to the next VMA after it (this is
> a new VMA merge, so is being applied at a gap).
> 
> To isolate the error handling, return early when a merge isn't
> possible (what the vmg->target check was doing before), then handle the
> merge success/failure case explicitly.
> 
> While here, update vma_expand() to jump to the nomem case when
> dup_anon_vma() fails, so vmg->state is correctly updated.
> 
> This doesn't impact anything in practice, but is the correct course and
> since it's part of the error path that this patch addresses, it makes sense
> to update it also.
> 
> Users are very unlikely to have observed the issue this patch addresses in
> practice, as it is near-impossible to fail an allocation for an anon_vma,
> but a process under memory pressure that receives a fatal signal could
> trigger it.
> 
> This issue was originally reported by Li Jinyue for which I am grateful. He
> indicated this was uncovered by a private syzkaller instance.
> 
> Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
> Cc: stable@vger.kernel.org
> Reported-by: Li Jinyue <jinyue.li@linux.alibaba.com>
> Closes: https://lore.kernel.org/all/20261025093921.1011927-1-jinyue.li@linux.alibaba.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/vma.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index af8e65ada23b..d416ba58eb4c 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1141,6 +1141,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  	struct vm_area_struct *next = vmg->next;
>  	unsigned long end = vmg->end;
>  	bool can_merge_left, can_merge_right;
> +	bool move_iter_back = false;

The name move_iter_back is a bit confusing because you use it to move it
to the next entry.  I get what you mean, move it back to where it was, not
go to prev, but the name is a bit off when used to go to the next entry.

reposition_iter, maybe?

>  
>  	mmap_assert_write_locked(vmg->mm);
>  	VM_WARN_ON_VMG(vmg->middle, vmg);
> @@ -1182,23 +1183,30 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  			vmg->end = end;
>  
>  		/* In expand-only case we are already positioned at prev. */
> -		if (!vmg->just_expand) {
> -			/* Equivalent to going to the previous range. */
> -			vma_prev(vmg->vmi);
> -		}
> +		if (!vmg->just_expand)
> +			move_iter_back = true;
>  	}
>  
> +	if (!can_merge_left && !can_merge_right)
> +		return NULL;
> +
> +	if (move_iter_back)
> +		vma_prev(vmg->vmi);
> +
>  	/*
>  	 * Now try to expand adjacent VMA(s). This takes care of removing the
>  	 * following VMA if we have VMAs on both sides.
>  	 */
> -	if (vmg->target && !vma_expand(vmg)) {
> -		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> -		vmg->state = VMA_MERGE_SUCCESS;
> -		return vmg->target;
> +	if (vma_expand(vmg)) {
> +		/* Error occurred, restore iterator. */
> +		if (move_iter_back)
> +			vma_iter_next_range(vmg->vmi);
> +		return NULL;
>  	}
>  
> -	return NULL;
> +	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> +	vmg->state = VMA_MERGE_SUCCESS;
> +	return vmg->target;
>  }
>  
>  /*
> @@ -1288,7 +1296,7 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	if (!ret && vmg->copied_from)
>  		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
>  	if (ret)
> -		return ret;
> +		goto nomem;
>  
>  	if (remove_next) {
>  		vma_start_write(next);
> 
> ---
> base-commit: 1eb36316305767b54fac2cd40b88b3499791bdf2
> change-id: 20261027-fix-new-merge-bug-71c2200d40fb
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

