Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01B38606A330
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VKfhZrgx
Received: by kanga.kvack.org (Postfix)
	id 25A5B6B00EF; Sat, 31 Oct 2026 11:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231696B05B1; Sat, 31 Oct 2026 11:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147FB6B05B2; Sat, 31 Oct 2026 11:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E44C46B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:09:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58B05A85D3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:09:12 +0000 (UTC)
X-FDA: 85383254544.07.0C487ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BA75EA0010
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:09:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKfhZrgx;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793459350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEiiDSLjjFPAJPMOepk6Di3HsdgbKPWIFvft4zsU7q0=;
	b=8H9MKQSApZdk7hZrHVc/mVx+nRyzt5oUNV+6DZNLsLjcR7bgQwPB8xaP3yeiPiweQB5a+p
	3iS4HJildy+V7vAlkpQjY2sSgRNSXlKT1FLuIQ2qv0s3rcqTy+pszHHGTCmSbhEccWQPtO
	44On46TrtWDZqOuROf+Ie1qR/Knzs94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793459350;
	b=2M9s4iqbblMiS/OjA6E1l8FaOlZb+zTezKB7lu/k37jnkyXsCZkz2+b8tQ2R3Q95qyS00V
	AvTnn4NSUtfKOadXYNWs6vdNRzhKpFNQfqKo0e9EbCQr2XSDWYCrHYcVL/UBRth3q+a2mU
	S7FDD6PBNxVnVUondK3Uy+nqTCznGg0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKfhZrgx;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38E37601EE;
	Sat, 31 Oct 2026 15:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D721F000C1;
	Sat, 31 Oct 2026 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793459348;
	bh=KEiiDSLjjFPAJPMOepk6Di3HsdgbKPWIFvft4zsU7q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VKfhZrgxSWRq3VCoZ2mexfnQLDoTPcegmBRky1wljKL0NKPaHvdHk8fwKTIhzKzVH
	 WjwTBfRmzvbxD3MZsOysy6VznpiJ1P7puPzzBMlqIFM10Lx5Ksx4zSTKJTrxEFfrzi
	 6o7jUhey0ae+Ak+T7VrJDEhgExO7PhyXQZ6CgEWnJeW/t/qz6odxfbrVDuakAXg8/B
	 cXCu5Ch6CqrP0RDbvG4lhDhVspX96BD3sd0dKEVa0bk3+TXxpPZMCZVJCUJEwuapzp
	 DSAxMSeJQJcvzq0wyodPzjKUE+f4qEP+DEEerYIbst1v9K4Bc8RXgjHxhLwAOCtKyO
	 5NdkpWUinG0dQ==
Date: Sat, 31 Oct 2026 17:09:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: clear uffd state in child PTEs if uffd is
 released during fork
Message-ID: <auYEjnY0LrwjbL5T@kernel.org>
References: <20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org>
 <20261031145835.960656-1-tz2294@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031145835.960656-1-tz2294@columbia.edu>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA75EA0010
X-Stat-Signature: 36341ofku5jkifdi65okg4nahpom4urc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793459350-587929
X-HE-Meta: U2FsdGVkX1/5gT9d+12wXotpNgwYTjZr15neZtKRf1QVN9lwPL5IBSMVzcWyPfi2h2sjUouiwT8XepBstRwOBaFkJ/UMtpXVi5Hl+rw2au2UiZxhbEiNIsWhsQwkfIAFhkGe/gicu6T9ZGWOJFTuNI/COn2YYYGE0bH9hnefSl5p1Gc435V/5umwDNV1ovyJmnOdCd19Uf5MdSjnK9TvvmziQ4sbR7/FQCjc9EXXfBLFVkdujI34TWigF9hcmMU/eZMopalBanrNyu8D7dOefBxmpjVMzdBmpBjCLZa5cDG/hjhn9/p5Wved2U0BPXYE/w2nSn6k2awriob0W/uYxFga64RWYk75oJ0k6weDeEcPvvrvXKh9WwlrrTmOk6aO8hVr8pKl4D+GBEP+8TxB1+r8TJnFwYzwGhBVeoyZobvq9wqDRs9PdPuF85crpraCuZ4DPcFlb+sODeMXo1nZ/Rzy32+GvCkXtF8IyFiFCT1cNxk/pIk7+7Rlvbz+HuXyzBEmjGSPGOkgqnA4nm35Hb4AR5YwNrMfywW2/rQGgw+58vdT0698KQwcEbMhwTr318k/AJhwUrBGLcTazmlXD1o+/gZxsxGDO3dvEem91/VscsYZ4meht0ztH/c/pH9vLVhE6v4N8on6XkrLRXWreovk/lHlbhBXIhJH1vlbSMUuItUReBNnzJM8h/4imAPtF+e/Sjnvz6zXEbEUbTFRCOlz5xCd9UCaS4gQAK54NJxnj/sGtGHwzKB0hB4AOv/xYUV266uMpTlNeUwel0q/s7GQPGIF+18UvZUOkxFPHKQd1wCZOqYoIDTYcWqqQsdEr2cdAm/3kzeHr4i8CV5WPuwhutyskH89mTnucG/iOB5G+X2HQLVV2Bzj6RoJSeFOSq745OWbz736bTE1UH3N4EVTbNcdtP08mtAOzNGkwcXqMFsBvlMWkBE4KBDCVeMi56yn/+AMrSMjYr+OiEl
 YFUZdhRA
 En/Nc/XesCHDB9JzCXqI6pcy/cBfgREczt5GV8akg+gYwoXzzZ6ut+HldvmJVPxpiRLYSfkuzYvQU3VlLkpOcjrIwFZ7vGpkJFxJbQ4DetuW6ju4f+t7NXIpcUi5nMtHZxvZckultkkWl95t9Q9GRKSscOW6lN2mmxdtA02d6nV6zJ0LUEzVGD6jI/JlfNTIw+FK65Nj1Jyx9oNJ5UOYsTHxqhPfAPti6L46BW2+lkMZwYA7EMcd2aTdp5bxNDwfa8OiP/dijjcWUmSD5mwnQp6U4FnA8ZKrxm0hFCH3k5DpidjywxY0vQ2b3Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 10:58:35AM -0400, Tal Zussman wrote:
> On Sat, Oct 31, 2026 at 02:35:05PM +0200, Mike Rapoport (Microsoft) wrote:
> > With UFFD_FEATURE_EVENT_FORK the userfaultfd context is duplicated for the
> > child process, the child VMAs are registered with the new context, and uffd
> > protection state from the parent PTEs is copied into the child.
> >
> > If the parent's userfaultfd is released before the fork event is read,
> > userfaultfd_release_new() resets the VMA flags but keeps uffd state in the
> > child PTEs.
> >
> > This leaves the child's VMAs in an inconsistent state: they are not
> > registered with userfaultfd but their mappings carry uffd protection state.
> >
> > If the child registers the range with userfaultfd again, the stale state
> > turns into protection the child never asked for.
> >
> > When a write fault makes such a PTE writable without copying the page, the
> > uffd bit remains set and page_table_check_pte_flags() warns about it.
> >
> > Split resolving of the uffd PTE state out of userfaultfd_clear_vma() and
> > call it from userfaultfd_release_new() before resetting the VMA.
> >
> > Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Hi Mike,
> 
> I managed to trigger a warning without this patch too by using an
> mprotect(PROT_READ | PROT_WRITE) in the child with CONFIG_PAGE_TABLE_CHECK:
> 
>   WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x181/0x2f0
>   Call Trace:
>    change_pte_range+0x1ef7/0x29b0
>    change_protection+0xd2b/0x1560
>    mprotect_fixup+0x4cb/0x1040
>    do_mprotect_pkey+0x7c2/0xac0
>    __x64_sys_mprotect+0x78/0xc0
> 
> No warning with the patch, so:
> 
> Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> Tested-by: Tal Zussman <tz2294@columbia.edu>
> 
> With a couple comments about comments below.
> 
> > ---
> >  mm/userfaultfd.c | 43 ++++++++++++++++++++++++++-----------------
> >  1 file changed, 26 insertions(+), 17 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 3b71712edab4c..2c11ac5dad3d5 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2220,6 +2220,28 @@ static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
> >  	userfaultfd_set_ctx(vma, NULL, 0);
> >  }
> >  
> 
> I think uffd is woefully under-commented considering how many edge cases and
> races are associated with it... so how about the following instead:
> 
> /*
>  * Clear uffd state from a WP or RWP range: the uffd bit, WP markers and
>  * RWP PAGE_NONE entries. Call this before dropping the registration, as it
>  * needs the VMA flags to know what to resolve.
>  */

Yeah, I'll add it to v2, thanks!
 
> > +/* Clear the uffd bit and/or restore protnone PTEs */
> > +static void userfaultfd_clear_ptes(struct vm_area_struct *vma,
> > +		unsigned long start, unsigned long end)
> > +{
> > +	unsigned int mm_cp_flags = 0;
> > +	struct mmu_gather tlb;
> > +
> > +	if (!userfaultfd_protected(vma))
> > +		return;
> > +
> > +	if (userfaultfd_wp(vma))
> > +		mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
> > +	if (userfaultfd_rwp(vma))
> > +		mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
> > +	if (vma_wants_manual_pte_write_upgrade(vma))
> > +		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> > +
> > +	tlb_gather_mmu(&tlb, vma->vm_mm);
> > +	change_protection(&tlb, vma, start, end, mm_cp_flags);
> > +	tlb_finish_mmu(&tlb);
> > +}
> 
> I think it may also be helpful to comment the fork release path that
> triggers this bug for clarity, so how about the below on top? Happy to send
> it separately.

Let's make it a separate patch, it's not really a part of the fix and it's
not needed for backport IMO.
 
> That ewq->msg.arg.reserved.reserved1 at the end is horrific too... I'll send
> a patch to clean that up.
> 
> ---8<---
> From: Tal Zussman <tz2294@columbia.edu>
> Subject: [PATCH] mm/userfaultfd: comment the fork event release path
> 
> Document what userfaultfd_reset_ctx() expects from its callers, and why
> the fork event release path has to unregister the child.
> 
> Link: https://lore.kernel.org/lkml/20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org/
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/userfaultfd.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 3b71712edab4..249f3b4444ab 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2215,6 +2215,13 @@ static void userfaultfd_set_ctx(struct vm_area_struct *vma,
>  				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags);
>  }
>  
> +/*
> + * Drops the registration from the VMA.
> + *
> + * Page tables are left alone. Callers must make sure no uffd state is
> + * left behind in them, either by calling userfaultfd_clear_ptes() first
> + * or because none was ever installed in the range.
> + */
>  static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
>  {
>  	userfaultfd_set_ctx(vma, NULL, 0);
> @@ -2997,6 +3004,10 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
>  		set_current_state(TASK_KILLABLE);
>  		if (ewq->msg.event == 0)
>  			break;
> +		/*
> +		 * The fd is gone or we are being killed, so the event
> +		 * will never be read.
> +		 */
>  		if (READ_ONCE(ctx->released) ||
>  		    fatal_signal_pending(current)) {
>  			/*
> @@ -3009,6 +3020,10 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
>  			if (ewq->msg.event == UFFD_EVENT_FORK) {
>  				struct userfaultfd_ctx *new;
>  
> +				/*
> +				 * Nobody will get an fd for the new context,
> +				 * so unregister the child.
> +				 */
>  				new = (struct userfaultfd_ctx *)
>  					(unsigned long)
>  					ewq->msg.arg.reserved.reserved1;
> -- 
> 2.39.5
> 

-- 
Sincerely yours,
Mike.

