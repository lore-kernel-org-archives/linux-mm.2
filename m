Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7B5606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k9EFhRVC
Received: by kanga.kvack.org (Postfix)
	id 7A6B46B05B3; Mon, 16 Nov 2026 10:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E1A6B05B4; Mon, 16 Nov 2026 10:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693C66B05B5; Mon, 16 Nov 2026 10:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 444CE6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:47:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD018160170
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:47:01 +0000 (UTC)
X-FDA: 85441410642.21.5C3F5BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20A50C0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:46:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9EFhRVC;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0uElAV1NvKu0ZyMFHxeUG860eoK8aGVGyT8VR+T67Y=;
	b=YVczjEMId9skgnTJ8ref5p8k3jAxCqNjb87j7ghwIXdQcq7bVbaberri+LOgGHzBixHR+e
	LHOgVoSfyT5SNsOIUWCG/Ton+bKuRNCaG+HHQfqZMpHU7iA9uO92+yWmqfyt2jdRFOfTuy
	JMo4arB5HomeCFfK2Ia3Pdh+ikFz6x4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k9EFhRVC;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844020;
	b=Hp8jqc4mwQidR0iSHoxSlqDsoaUUkcUIcPdSlOHlJylnYeLRlHxmEYcy/M9eiz49/btkWv
	Q+u8NbtIERD1paPOGfeGM4c96/Ts4dLg6oEt/wD91AHDeU1agCtlDv+MqODdVYiNpOV4oy
	M87fykOoKFBD21zdzI7/IPkabOjhy3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46B3843AD5;
	Mon, 16 Nov 2026 15:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19E31F000C4;
	Mon, 16 Nov 2026 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844019;
	bh=f0uElAV1NvKu0ZyMFHxeUG860eoK8aGVGyT8VR+T67Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k9EFhRVCzCfcnffZdkuJZogTdgJRJu/ey5dgGOWDFuZz+pg2opk7vf1J/7XjdvNlL
	 FgDSvPGP96+a7H8NxW+UdZhmP3SOFRkpdEU2FhzKaNmAIF4g0QD1JZQR/w9PMWGDDz
	 pJ+55b41SuSDypTZmj0sMYHMitgnUSfZrHdCmOLnzaGcAhPQJvuc3V8i9tg/XKs9yH
	 eUhb54z/N7uhUmVofEctqQHxi7r+DpSpexGjPD704xRrWUA3Iv+bC6EeoUj8AeywWG
	 rPVw1hO6pHy5UIDxOCyN0UdIqZN6Ts+QTyaS7YPQK1IL08QYBqHLdHmE0Vr1cdTQjP
	 h4xZOAyLTBeJg==
Date: Mon, 16 Nov 2026 15:46:54 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Li Jinyue <jinyue.li@linux.alibaba.com>
Subject: Re: [PATCH] mm/vma: update VMA iterator state on error in new VMA
 merge
Message-ID: <avskacTjLUyz4D_c@gremlin>
References: <20261027-fix-new-merge-bug-v1-1-7023a787e6b9@kernel.org>
 <gp4huj53rndmngvzajdfelalmh5gkhzqv73t2v6rotmr37hgpb@g4a33cixtylu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gp4huj53rndmngvzajdfelalmh5gkhzqv73t2v6rotmr37hgpb@g4a33cixtylu>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20A50C0007
X-Stat-Signature: c6ur39fs3aoacumahucz1iyaryg85rcm
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794844019-619293
X-HE-Meta: U2FsdGVkX19ghMLnUo05QQYLUGYLQzGbZGxMSmbAVZfqI3wQRLZ+AXdKEEZ9vZR/SOw4ha4kbBxiDtYad5Yr9eBLdcc38Fduuex0dw9Z1uXHDcc1c9UqsAqDloB5c1SAW5jSk97n4+oaHQAb01FW25i5YoFgpyrwYwIsl8amTi2b/d4o1jYtm5tJjaUgObjJQWwumq5A9W+gf7leF1dRFAfwKiPbmr6LmpxBWOqHutJLn0mhnV2qH3EosdbIjOnIEWRQJKmgxFTYlfaI/PfEJ2uUuf3yzonYq7OLB9RAlP0czFUKPhbQm7z5TIXHH5VVua7aGEha/Ptd9wWLLGXgkj9BVVKa3W8mx5PB6sflYi9FlEdA7+qYiMdcvtAQzKZO60L6mxiQmfpiJjfGLUi4Vit4XxppQfp6HBLlsl3S2bUIZH0g7v22RisfTDxZ05lzFmnBmxLCFQvCwxEZFGbE3KoVzkh/dA0zAr3SSamSy0AwsNAtoGAbwtN3ShdiNMWuxXGz3ixV1X2jSNBqezCIk7cSo7/b7v86YSSbbq7z83yu/aVzab8EqpHorWBZgxrbQfmHi5eHxw8C+htSYtYR4LXvL/ALvYHSxLssHR7sqq47sXdmY8Fz7/iGnQZ3i/xwkAI78wC/f1x76pxWKihG7qVfGxLbB0PToR4bsakYjZEr/3rwHN66KdEgIFulqaxH/RemHmfKHc0LPGL7FVqmHoK4EC9fm6a7qJSwD0vRu5B7no3AqsmAKuwQQWczF0MeYKihSefk28n9cpBsHuQk3/fq/q6MclpxrLRcZCAMZ/xTvFoRtBDLQ0pFicgu14+UjlfZqjsh8LfWZyJBsRmEeXKSNWpOPasA1XNYxPfvjjE9PUiWTYrYfSzRR7P+B444z553o8QBpJTuOz5oSA2NohPtJfG2+1dtFCswuQJBIBvuKDMZsFHl9Alt8x/ydrHengi3NkkdhPF7dDT60RL
 VGO1Q/h6
 E4Why+OsKGws54j6A6na9VDGb6sSg35KCpTze8CzMTUOULMVT6Pp81hyJ2ybGdDh1pcQt1BExt+8EYhrSRsuM7E7nHvgMzjqZXqFzfDy2IY+HcMiCLIDkmYP29SNo4spqjEUoMB2BWbsoExDAxbC0WUJ+Hx5LQPz3ZFVqDgX911uN4KtN3oK8W+AaQro0OD1OGjV6csnXBe/rfbfK66F/G64lDpPN+2Rq3/E648eiEAEjuS9FdFovcKxpLHF4RTh6aXqn7QCeP1Dy0V/gjOjGr27KpoETCO+ZCkaAOlbeBIq0CCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 05:01:34PM -0500, Liam R. Howlett wrote:
> On 26/10/27 11:25AM, Lorenzo Stoakes (ARM) wrote:
>
> I'm a bit late on this one..
>
> > Commit cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs") shared
> > code between vma_merge_new_range() and vma_expand().
> >
> > However in doing so, it failed to correctly restore the VMA iterator when
> > vma_expand() errors out.
> >
> > This is a problem when the immediately preceding VMA is mergeable and
> > vmg->just_expand isn't specified, at which point the VMA iterator is moved
> > to the previous VMA.
> >
> > (Note that vmg->just_expand is a special case for brk(), where the
> > iterator will already be positioned at the VMA to be expanded.)
> >
> > Resolve things by restoring the VMA iterator on error. Use
> > vma_iter_next_range() to do this, so it will correctly stop on the gap
> > after the previous VMA, rather than skip to the next VMA after it (this is
> > a new VMA merge, so is being applied at a gap).
> >
> > To isolate the error handling, return early when a merge isn't
> > possible (what the vmg->target check was doing before), then handle the
> > merge success/failure case explicitly.
> >
> > While here, update vma_expand() to jump to the nomem case when
> > dup_anon_vma() fails, so vmg->state is correctly updated.
> >
> > This doesn't impact anything in practice, but is the correct course and
> > since it's part of the error path that this patch addresses, it makes sense
> > to update it also.
> >
> > Users are very unlikely to have observed the issue this patch addresses in
> > practice, as it is near-impossible to fail an allocation for an anon_vma,
> > but a process under memory pressure that receives a fatal signal could
> > trigger it.
> >
> > This issue was originally reported by Li Jinyue for which I am grateful. He
> > indicated this was uncovered by a private syzkaller instance.
> >
> > Fixes: cacded5e42b9 ("mm: avoid using vma_merge() for new VMAs")
> > Cc: stable@vger.kernel.org
> > Reported-by: Li Jinyue <jinyue.li@linux.alibaba.com>
> > Closes: https://lore.kernel.org/all/20261025093921.1011927-1-jinyue.li@linux.alibaba.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index af8e65ada23b..d416ba58eb4c 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1141,6 +1141,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
> >  	struct vm_area_struct *next = vmg->next;
> >  	unsigned long end = vmg->end;
> >  	bool can_merge_left, can_merge_right;
> > +	bool move_iter_back = false;
>
> The name move_iter_back is a bit confusing because you use it to move it
> to the next entry.  I get what you mean, move it back to where it was, not
> go to prev, but the name is a bit off when used to go to the next entry.
>
> reposition_iter, maybe?

Ahh too late this is merged :P

I think it's hard to get this quite right.

So in the first instance move_iter_back = do a vma_prev() i.e. literally move
the iterator backwards.

Then, if the iterator was moved back, we want to restore it on error, I hoped
that the comment would make that clear.

So it's just separating noting that it needs doing (move_iter_back = true) and
the actual action (vma_prev()) + the restore.

So I think arguably OK as-is? But could obviously also follow up if needed.

>
> >
> >  	mmap_assert_write_locked(vmg->mm);
> >  	VM_WARN_ON_VMG(vmg->middle, vmg);
> > @@ -1182,23 +1183,30 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
> >  			vmg->end = end;
> >
> >  		/* In expand-only case we are already positioned at prev. */
> > -		if (!vmg->just_expand) {
> > -			/* Equivalent to going to the previous range. */
> > -			vma_prev(vmg->vmi);
> > -		}
> > +		if (!vmg->just_expand)
> > +			move_iter_back = true;
> >  	}
> >
> > +	if (!can_merge_left && !can_merge_right)
> > +		return NULL;
> > +
> > +	if (move_iter_back)
> > +		vma_prev(vmg->vmi);
> > +
> >  	/*
> >  	 * Now try to expand adjacent VMA(s). This takes care of removing the
> >  	 * following VMA if we have VMAs on both sides.
> >  	 */
> > -	if (vmg->target && !vma_expand(vmg)) {
> > -		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> > -		vmg->state = VMA_MERGE_SUCCESS;
> > -		return vmg->target;
> > +	if (vma_expand(vmg)) {
> > +		/* Error occurred, restore iterator. */
> > +		if (move_iter_back)
> > +			vma_iter_next_range(vmg->vmi);
> > +		return NULL;
> >  	}
> >
> > -	return NULL;
> > +	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
> > +	vmg->state = VMA_MERGE_SUCCESS;
> > +	return vmg->target;
> >  }
> >
> >  /*
> > @@ -1288,7 +1296,7 @@ int vma_expand(struct vma_merge_struct *vmg)
> >  	if (!ret && vmg->copied_from)
> >  		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
> >  	if (ret)
> > -		return ret;
> > +		goto nomem;
> >
> >  	if (remove_next) {
> >  		vma_start_write(next);
> >
> > ---
> > base-commit: 1eb36316305767b54fac2cd40b88b3499791bdf2
> > change-id: 20261027-fix-new-merge-bug-71c2200d40fb
> >
> > Cheers,
> > --
> > Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >

--
Cheers, Lorenzo

