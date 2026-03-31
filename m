Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E62EFF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A581C6B00A0; Tue, 31 Mar 2026 05:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FEA6B00A1; Tue, 31 Mar 2026 05:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D486B00A2; Tue, 31 Mar 2026 05:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 840576B00A0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:51:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6BF813C149
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:51:08 +0000 (UTC)
X-FDA: 84605889816.18.F0DDD93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5693C8000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:51:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNtyMoYn;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DDBlA+u+YDbAua4nmsZ0euWewjZTMT7HLm0BneIPTo=;
	b=Py8eGHFMEh0IOUIdjoxyaBB3FQ+4Vq4px+rWRXF5SgNdrpkbnPv4rqyVC9f+AANt0nig9b
	phrkTQX5Wk60ixz/49Iii9+wlQlWhfTKXOCkRt/ik1dZrHf8OTCEK8yCz1aJteIzgo8LE5
	O1VIZNIdqdVc+VciISQESKscQS7pdTk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNtyMoYn;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950667; a=rsa-sha256;
	cv=none;
	b=FKRmEK6FEhZX7XItBH2mEcu4Lz2h9wWrSTf7B4s3+28r9cfwt9+nSsNTMXFntLO3bzMEPS
	ONgg+/XgTRTayIuzreUUYgK5PpiAcxYHeDE6mP/V8NtDyXFnBonW/cModpp0p1lsbjIyk7
	uiDOhEJPlg4z3NVgfFe/qLAbDTK2YUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C86CA600CB;
	Tue, 31 Mar 2026 09:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBD3C19423;
	Tue, 31 Mar 2026 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950666;
	bh=GUYv48aqnOB+9lrhq/OJxgTDhnzEElBOBOj0aReQt00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KNtyMoYnwvw8y7P34krJLMvPuk9Ug1u22pw5FUadp9aWf/T6utbvWI7nh/NXWnEKC
	 tJ4F3CDEPr3Vha3SMIaiIUgFcrZiDrA98XybSdpl11bHRSaKj+zFJ0+mV+jzp+cwrj
	 jH/QZyrPNiNDzvdpGi2yzAs+H4B/F2ck5wsIPLfe3keXguMAuUV66LjmJftvhp986C
	 Jkt4gDcMMWmboVTTO8L51n5cNQ9BnwU32voSLRWWseQnTdDx3sRt/gggQPu4pccJz2
	 P0dfGFMVwgLdKgJ8TQdJb/4TtC799ap1M3TRT+hlw4zD6oJYTcZrgyemeOPptHjrgP
	 aVIemcS5phjtg==
Date: Tue, 31 Mar 2026 10:51:04 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, willy@infradead.org, 
	david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 0/6] Use killable vma write locking in most places
Message-ID: <f128b795-5577-40f9-8dae-936be4253642@lucifer.local>
References: <20260327205457.604224-1-surenb@google.com>
 <20260327161226.17e680fec33117d67dc8b5f9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327161226.17e680fec33117d67dc8b5f9@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: u7icw8ksuaqje819izgx9abppawz693f
X-Rspamd-Queue-Id: 5693C8000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774950667-74924
X-HE-Meta: U2FsdGVkX19vJ50k79TLGkEz1JQs09QO9KZwxYU7foKg+Sn5RhKOHTbt5HvccvpuNuB8lICAnjU9eI83RMSe9+NZUy4rmBKVfVtoGNprQ7AUu09/RvbYxQtyNC4o+e4/qfp73rm7YVCVQBp+4oO2VhHxWTAtJGf806CJ2p/smeLEcy2SQtwBfqHB5YIDDCu12+3rw0O1QBLvDnfX8NX6DoT9y/P81GU+ff/lMCb1pRmVOf7Hpvuw9D4Suua6QPB7xlLvo/RVS7fZYEoIaizhnsFA8+zLETjMXYUHknP6rA66JRWwtNR9gAeLRbsin4y4z1+up42295POU92H3js9kUOvOnPkOJUq0atFoEUvv87LxnIt/Qnoo5wVh94wwX5c/TRJJ3Hn00zEgMIZZ+oGPvZZ/yAo/Cfmm+3JIKKMgqraNuGVXm7bjU6v4cz7XifIlrYj/RERm7AbOL7uE5yk7IuHSfAlp/7figlefJVhgyh3Mr6W6Z9+jidLsjMWkA/zSoZoNLTc/G9B4WPoezJKUvu4y3VyI6OntHoBrnQc7qKp6HSeIlyiqIuIJ/ENyq9AAFyPgFdKaTbSj/f/ETt1Uuv26Wnd9yhEpdYD28irfW/1Omuel8HkJkS7uKArSex1uJ7Fh/Yygo+WUgIZ4t6894gtB/kxPQ2bfRUq18rQm/DEdIFOzv9I2bIn1c+mHXMTS8GuRNc+j/hqTiHVWv/wG/pIMLRc3zIBUabuvhQkmd1ysQNes5TNKT53MFS8jqsULfN06uei178VQ8KlKP9u9wxs6yZFAj/emCxjpDVaT2teTfzDVk+j0dze+W0mQ6C2YblMsVRkaZ1/IScKX21nS9mVpL2bX8ELNlM8EL1BBBArxUId2Qvve4WwUvqB8IGOjztGPOVEHF2e4eQORHVN9CL4MSYsqwYEPzV+rimiFRrzhtwXEAXRu4/khaL65xAj6YTblGDpLysuoTq3hkQ
 h0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 04:12:26PM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2026 13:54:51 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> >
> > There are several places which are left untouched by this patchset:
> >
> > 1. free_pgtables() because function should free page tables even if a
> > fatal signal is pending.
> >
> > 2. userfaultd code, where some paths calling vma_start_write() can
> > handle EINTR and some can't without a deeper code refactoring.
> >
> > 3. mpol_rebind_mm() which is used by cpusset controller for migrations
> > and operates on a remote mm. Incomplete operations here would result
> > in an inconsistent cgroup state.
> >
> > 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
>
> Updated, thanks.

Andrew - sorry I think we need to yank this and defer to next cycle,
there's too many functional changes here.

(There was not really any way for me to predict this would happen ahead of
time, unfortunately.)

>
> > Changes since v5 [1]:
> > - Added Reviewed-by for unchanged patches, per Lorenzo Stoakes
> >
> > Patch#2:
> > - Fixed locked_vm counter if mlock_vma_pages_range() fails in
> > mlock_fixup(), per Sashiko
> > - Avoid VMA re-locking in madvise_update_vma(), mprotect_fixup() and
> > mseal_apply() when vma_modify_XXX creates a new VMA as it will already be
> > locked. This prevents the possibility of incomplete operation if signal
> > happens after a successful vma_modify_XXX modified the vma tree,
> > per Sashiko

Prevents the possibility of an incomplete operation? But
vma_write_lock_killable() checks to see if you're _already_ write locked
and would make the operation a no-op? So how is this even a delta?

It's a brave new world, arguing with sashiko via a submitter... :)

> > - Removed obsolete comment in madvise_update_vma() and mprotect_fixup()
> >
> > Patch#4:
> > - Added clarifying comment for vma_start_write_killable() when locking a
> > detached VMA
> > - Override VMA_MERGE_NOMERGE in vma_expand() to prevent callers from
> > falling back to a new VMA allocation, per Sashiko
> > - Added a note in the changelog about temporary workaround of using
> > ENOMEM to propagate the error in vma_merge_existing_range() and
> > vma_expand()
> >
> > Patch#5:
> > - Added fatal_signal_pending() check in do_mbind() to detect
> > queue_pages_range() failures due to a pendig fatal signal, per Sashiko
>
> Changes since v5:
>
>
>  mm/madvise.c   |   15 ++++++++++-----
>  mm/mempolicy.c |    9 ++++++++-
>  mm/mlock.c     |    2 ++
>  mm/mprotect.c  |   26 ++++++++++++++++----------
>  mm/mseal.c     |   27 +++++++++++++++++++--------
>  mm/vma.c       |   20 ++++++++++++++++++--
>  6 files changed, 73 insertions(+), 26 deletions(-)
>
> --- a/mm/madvise.c~b
> +++ a/mm/madvise.c
> @@ -172,11 +172,16 @@ static int madvise_update_vma(vm_flags_t
>  	if (IS_ERR(vma))
>  		return PTR_ERR(vma);
>
> -	madv_behavior->vma = vma;
> -
> -	/* vm_flags is protected by the mmap_lock held in write mode. */
> -	if (vma_start_write_killable(vma))
> -		return -EINTR;
> +	/*
> +	 * If a new vma was created during vma_modify_XXX, the resulting
> +	 * vma is already locked. Skip re-locking new vma in this case.
> +	 */
> +	if (vma == madv_behavior->vma) {
> +		if (vma_start_write_killable(vma))
> +			return -EINTR;
> +	} else {
> +		madv_behavior->vma = vma;
> +	}
>
>  	vma->flags = new_vma_flags;
>  	if (set_new_anon_name)
> --- a/mm/mempolicy.c~b
> +++ a/mm/mempolicy.c
> @@ -1546,7 +1546,14 @@ static long do_mbind(unsigned long start
>  			flags | MPOL_MF_INVERT | MPOL_MF_WRLOCK, &pagelist);
>
>  	if (nr_failed < 0) {
> -		err = nr_failed;
> +		/*
> +		 * queue_pages_range() might override the original error with -EFAULT.
> +		 * Confirm that fatal signals are still treated correctly.
> +		 */
> +		if (fatal_signal_pending(current))
> +			err = -EINTR;
> +		else
> +			err = nr_failed;
>  		nr_failed = 0;
>  	} else {
>  		vma_iter_init(&vmi, mm, start);
> --- a/mm/mlock.c~b
> +++ a/mm/mlock.c
> @@ -518,6 +518,8 @@ static int mlock_fixup(struct vma_iterat
>  		vma->flags = new_vma_flags;
>  	} else {
>  		ret = mlock_vma_pages_range(vma, start, end, &new_vma_flags);
> +		if (ret)
> +			mm->locked_vm -= nr_pages;
>  	}
>  out:
>  	*prev = vma;
> --- a/mm/mprotect.c~b
> +++ a/mm/mprotect.c
> @@ -716,6 +716,7 @@ mprotect_fixup(struct vma_iterator *vmi,
>  	const vma_flags_t old_vma_flags = READ_ONCE(vma->flags);
>  	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
>  	long nrpages = (end - start) >> PAGE_SHIFT;
> +	struct vm_area_struct *new_vma;
>  	unsigned int mm_cp_flags = 0;
>  	unsigned long charged = 0;
>  	int error;
> @@ -772,21 +773,26 @@ mprotect_fixup(struct vma_iterator *vmi,
>  		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
>  	}
>
> -	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_flags);
> -	if (IS_ERR(vma)) {
> -		error = PTR_ERR(vma);
> +	new_vma = vma_modify_flags(vmi, *pprev, vma, start, end,
> +				   &new_vma_flags);
> +	if (IS_ERR(new_vma)) {
> +		error = PTR_ERR(new_vma);
>  		goto fail;
>  	}
>
> -	*pprev = vma;
> -
>  	/*
> -	 * vm_flags and vm_page_prot are protected by the mmap_lock
> -	 * held in write mode.
> +	 * If a new vma was created during vma_modify_flags, the resulting
> +	 * vma is already locked. Skip re-locking new vma in this case.
>  	 */
> -	error = vma_start_write_killable(vma);
> -	if (error)
> -		goto fail;
> +	if (new_vma == vma) {
> +		error = vma_start_write_killable(vma);
> +		if (error)
> +			goto fail;
> +	} else {
> +		vma = new_vma;
> +	}
> +
> +	*pprev = vma;
>
>  	vma_flags_reset_once(vma, &new_vma_flags);
>  	if (vma_wants_manual_pte_write_upgrade(vma))
> --- a/mm/mseal.c~b
> +++ a/mm/mseal.c
> @@ -70,17 +70,28 @@ static int mseal_apply(struct mm_struct
>
>  		if (!vma_test(vma, VMA_SEALED_BIT)) {
>  			vma_flags_t vma_flags = vma->flags;
> -			int err;
> +			struct vm_area_struct *new_vma;
>
>  			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
>
> -			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
> -					       curr_end, &vma_flags);
> -			if (IS_ERR(vma))
> -				return PTR_ERR(vma);
> -			err = vma_start_write_killable(vma);
> -			if (err)
> -				return err;
> +			new_vma = vma_modify_flags(&vmi, prev, vma, curr_start,
> +						   curr_end, &vma_flags);
> +			if (IS_ERR(new_vma))
> +				return PTR_ERR(new_vma);
> +
> +			/*
> +			 * If a new vma was created during vma_modify_flags,
> +			 * the resulting vma is already locked.
> +			 * Skip re-locking new vma in this case.
> +			 */
> +			if (new_vma == vma) {
> +				int err = vma_start_write_killable(vma);
> +				if (err)
> +					return err;
> +			} else {
> +				vma = new_vma;
> +			}
> +
>  			vma_set_flags(vma, VMA_SEALED_BIT);
>  		}
>
> --- a/mm/vma.c~b
> +++ a/mm/vma.c
> @@ -531,6 +531,10 @@ __split_vma(struct vma_iterator *vmi, st
>  	err = vma_start_write_killable(vma);
>  	if (err)
>  		goto out_free_vma;
> +	/*
> +	 * Locking a new detached VMA will always succeed but it's just a
> +	 * detail of the current implementation, so handle it all the same.
> +	 */
>  	err = vma_start_write_killable(new);
>  	if (err)
>  		goto out_free_vma;
> @@ -1197,8 +1201,14 @@ int vma_expand(struct vma_merge_struct *
>
>  	mmap_assert_write_locked(vmg->mm);
>  	err = vma_start_write_killable(target);
> -	if (err)
> +	if (err) {
> +		/*
> +		 * Override VMA_MERGE_NOMERGE to prevent callers from
> +		 * falling back to a new VMA allocation.
> +		 */
> +		vmg->state = VMA_MERGE_ERROR_NOMEM;
>  		return err;
> +	}
>
>  	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
>
> @@ -1231,8 +1241,14 @@ int vma_expand(struct vma_merge_struct *
>  		 * is pending.
>  		 */
>  		err = vma_start_write_killable(next);
> -		if (err)
> +		if (err) {
> +			/*
> +			 * Override VMA_MERGE_NOMERGE to prevent callers from
> +			 * falling back to a new VMA allocation.
> +			 */
> +			vmg->state = VMA_MERGE_ERROR_NOMEM;
>  			return err;
> +		}
>  		err = dup_anon_vma(target, next, &anon_dup);
>  		if (err)
>  			return err;
> _
>

