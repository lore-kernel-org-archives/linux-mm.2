Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE984108B914
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1726B0088; Fri, 20 Mar 2026 08:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62616B0089; Fri, 20 Mar 2026 08:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950E26B008A; Fri, 20 Mar 2026 08:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FABA6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:15:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 245C7B66F2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:15:54 +0000 (UTC)
X-FDA: 84566337828.29.A05F3FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 79A8BC000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:15:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jDZF/FE9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774008952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vkxPrMnmuyLw1Eyq1ncBeYNT01Y5cOahr0vxpRfkaE=;
	b=lV1ouvWOP5o+cVFzTulv8O5mex9BAhQVOmRbNTzZGOT8IS9roLwDLk3Zf/b+k02iqowojx
	1nmMMRGmQ6x7JDesQoQA1bu4gzM5cYFnkKibqkXj/vMVsUfnG+rs4EIvgKYzS5Jqo7uk10
	XORjDWSSw+NjD30mEGFfQa+pJxTbn/4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jDZF/FE9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774008952; a=rsa-sha256;
	cv=none;
	b=ssGpHg6xPRYarLgPRkwiT0X/qvRJiphXU2xJBYs8mnqoloztlc+7Xlq/N26dPgpC1cIa8p
	lf4yn++dtJXVWJV8N0kDrloxv2KWaWrTDxWy1Trl+4dnfRQfWiZkaPyZEtZOr0u0HNdsvO
	iyg4K134rxOx4WzVFUQ1yhOKD8JhtjU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77D2A6013E;
	Fri, 20 Mar 2026 12:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EB0C2BC9E;
	Fri, 20 Mar 2026 12:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774008951;
	bh=0a8d+i8ryZ8Qz2/DM7FqnFIwG0FqrZAF/wmekpBJUaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jDZF/FE9fX6C3+vM+jJy47M0EDpEvblTPV5F0Pl123V3O1jJPY6CxVfUvr5772OF0
	 EwbFrRgFOMZ/HpYb4NZEpUGSYrLQi87HZkE7NRk6+fuun1vK7QZuwtpGT0RqYSRfFH
	 5A+oXBXOcTOMiGae8q5ZIN2KC7PLnZqyLH2l646xGPAqU8LagVo4pd9PlFVH4c+EtA
	 Pqh2ZXu7DwvuAuAEDFJDwB4KfEyqaegNTwQce0W+FDPQbl/idWlRYA3HUwornsKTMQ
	 d8qWBnaA8QJH2RCt0j8JFUq9AuSv7rIJ6MBBUmVUq3PURFTUDPrFIxk7cw9pFtcgs7
	 R5z9kb3c/HG6A==
Date: Fri, 20 Mar 2026 12:15:36 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh Nguyen <dinguyen@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH v3 22/23] mm/vma: convert vma_modify_flags[_uffd]() to
 use vma_flags_t
Message-ID: <7ce8bdb6-f6f9-42fc-9464-ba0eaac9cd13@lucifer.local>
References: <cover.1773846935.git.ljs@kernel.org>
 <98a004bf89227ea9abaef5fef06ea7e584f77bcf.1773846935.git.ljs@kernel.org>
 <0b5765da-67e9-4e2e-99d8-08501730bf76@kernel.org>
 <7e22cc48-aa04-406d-b4d0-8ebb182b34b9@lucifer.local>
 <373186fb-5000-47ba-85a3-4085658a7101@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <373186fb-5000-47ba-85a3-4085658a7101@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 79A8BC000F
X-Stat-Signature: ehxj8rofy961mu9gnykq8pbenc7gpgh8
X-Rspam-User: 
X-HE-Tag: 1774008952-91578
X-HE-Meta: U2FsdGVkX1+zwCd9QBt6AThOdXgr2z2K4YE1xrWunqh/caBDc0fZmpWwKD6AQNDkPzykMTjONeTeeYGzhtXNq2eK1Qea79WnkcV3PxrSNllh1cJcLeAx4JndZZmGTbG03+E1ZC1f8HY5K2qu+sEaqGoNpypiD0Qmb+b92Ap6K85P2ql53pLDMQXxZz+jJjmgcNDbmQGtRwbRE0G4q8uAxpzclbXKXdYR1hEQcgJs04PvbcsoKuXOxnHRM9NtH52IxrUE33cSECun+SfhWN8LQfZKKTOF+Z6vBLzCEnYfsZJDwSJxQcekdGIJ4axIbTKEjtEVIXSxTIuHbv9DPkBo4HNIvHTmYXqNLJXxGzF0jjwn7G57xNex0PWnXCtLmAAp6MZ0ddf1X+RHEnj2QqwJKDeQyXeWYc9DxmhqIg8uBwhpLM3Ff+eRVN2mCQqc1UHbyuk3XZSYsptsJ451wF1gnQyecGfn32QEwHEdtlX6FR4IsfSoHHH7EIF1dGnGC1pxFh5Acp9l4bDyBP2z2isCKH8EE/CmFxWNWM6YVchaUxrZEhlu0xFVTh0IF1VDwb/38MMcIxXG6mDGg61eASWVA/JbrT8kHp6wMXB97vvX+8tByQle2E+QO2pW+Ve0I5ys/1ovadTe0qKP35Kz1BoIij4TwAvTzD6l1W1SKJMKLSt4WO1t6Hymv85QMZU5j7Mc7ERUcNXthfn2qEP5h7501qRZzQFFIDFBaFa2dHPGya0TFnyS+vOyoJTUrMwjpRj+JFTB20Z5oPkwIBpYIBMc6jMov1HXPeo/7J4tu0JL8SjCihmVV8IJWE9Niwl+bJtYTjx8QG5TasvYxWjV8/8d/WgpkBdmNN9x4gwgBdMzWaz9hLpVXgRoN2vIvDJeSV4scyqLPkPrUqLKzTvkppOpBh0fA69S8Q+nz1025fkWT0XuLiqmbMST3X/LT2mq237wA9gu4jhPapNkHv7dcmf
 1j5uqyoJ
 AyIBl+vHfCJywW0sVVAWjPwNK5SVUfGCG5Ot5NBurLJw1HZLypYA23iKp7fh8MZURtGIWot4Fz/rvDHaAVmOlw2aAgv2/GwI4XojrzBRVdUfep3LXpfIoUV2h0DqMmyyKVz3PlsJfvOJhVW2mcYOa/Zz8zFAnN/lSn9SMqksCNGrNZagPct25SfFjVWcDwBhakvpLFb5HBUQL5T6utX9FyXcKOahvgCS+r5P2hvesKuh3OVY3lrBLU2IY1inULkW1pn/xFObLWW0wjensHyrTYH76JMfE+vcC5qSzqtvSV5iAAOZPO92uxevSu0/pUVS/kPhtXKVmN9OnoNGHKtKHa+iqkDtshu1Vy636
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:56:56PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 12:08, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 20, 2026 at 11:39:58AM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> >> > Update the vma_modify_flags() and vma_modify_flags_uffd() functions to
> >> > accept a vma_flags_t parameter rather than a vm_flags_t one, and propagate
> >> > the changes as needed to implement this change.
> >> >
> >> > Finally, update the VMA tests to reflect this.
> >> >
> >> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >>
> >> > --- a/mm/mlock.c
> >> > +++ b/mm/mlock.c
> >> > @@ -415,13 +415,14 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
> >> >   * @vma - vma containing range to be mlock()ed or munlock()ed
> >> >   * @start - start address in @vma of the range
> >> >   * @end - end of range in @vma
> >> > - * @newflags - the new set of flags for @vma.
> >> > + * @new_vma_flags - the new set of flags for @vma.
> >> >   *
> >> >   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
> >> >   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
> >> >   */
> >> >  static void mlock_vma_pages_range(struct vm_area_struct *vma,
> >> > -	unsigned long start, unsigned long end, vm_flags_t newflags)
> >> > +	unsigned long start, unsigned long end,
> >> > +	vma_flags_t *new_vma_flags)
> >> >  {
> >> >  	static const struct mm_walk_ops mlock_walk_ops = {
> >> >  		.pmd_entry = mlock_pte_range,
> >> > @@ -439,18 +440,18 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
> >> >  	 * combination should not be visible to other mmap_lock users;
> >> >  	 * but WRITE_ONCE so rmap walkers must see VM_IO if VM_LOCKED.
> >> >  	 */
> >> > -	if (newflags & VM_LOCKED)
> >> > -		newflags |= VM_IO;
> >> > +	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> >> > +		vma_flags_set(new_vma_flags, VMA_IO_BIT);
> >> >  	vma_start_write(vma);
> >> > -	vm_flags_reset_once(vma, newflags);
> >> > +	WRITE_ONCE(vma->flags, *new_vma_flags);
> >>
> >> It's not clear to me, how is switching from vm_flags_t to vma_flags_t
> >> allowing us to simply do WRITE_ONCE() instead of the full logic of
> >> vm_flags_reset_once()? Won't it fail to compile once once flags are more
> >> than single word? Or worse, will compile but silently allow tearing?
> >
> > We only care about tearing in the flags that can be contained within a
> > system word, but true we should probably do this more carefully, as I did
> > for vm_flags_reset_once().
> >
> > I will reimplement this as a new, hideous, helper function.
> >
> > I am not a fan of this being a thing to handle races, it's a hack. But I
> > guess that should be addressed separately.
>
> Right, thanks!

No problem. I might be able to avoid it being too hideous let's see :)

>
> >>
> >> >  	}
> >> >  }
> >> >
> >> > @@ -467,20 +468,22 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >> >  	       struct vm_area_struct **prev, unsigned long start,
> >> >  	       unsigned long end, vm_flags_t newflags)
> >> >  {
> >> > +	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
> >> > +	const vma_flags_t old_vma_flags = vma->flags;
> >> >  	struct mm_struct *mm = vma->vm_mm;
> >> >  	int nr_pages;
> >> >  	int ret = 0;
> >> > -	vm_flags_t oldflags = vma->vm_flags;
> >> >
> >> > -	if (newflags == oldflags || vma_is_secretmem(vma) ||
> >> > -	    !vma_supports_mlock(vma))
> >> > +	if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags) ||
> >> > +	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
> >> >  		/*
> >> >  		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
> >> >  		 * For secretmem, don't allow the memory to be unlocked.
> >> >  		 */
> >> >  		goto out;
> >> > +	}
> >> >
> >> > -	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
> >> > +	vma = vma_modify_flags(vmi, *prev, vma, start, end, &new_vma_flags);
> >> >  	if (IS_ERR(vma)) {
> >> >  		ret = PTR_ERR(vma);
> >> >  		goto out;
> >> > @@ -490,9 +493,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >> >  	 * Keep track of amount of locked VM.
> >> >  	 */
> >> >  	nr_pages = (end - start) >> PAGE_SHIFT;
> >> > -	if (!(newflags & VM_LOCKED))
> >> > +	if (!vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT))
> >> >  		nr_pages = -nr_pages;
> >> > -	else if (oldflags & VM_LOCKED)
> >> > +	else if (vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT))
> >> >  		nr_pages = 0;
> >> >  	mm->locked_vm += nr_pages;
> >> >
> >> > @@ -501,12 +504,13 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >> >  	 * It's okay if try_to_unmap_one unmaps a page just after we
> >> >  	 * set VM_LOCKED, populate_vma_page_range will bring it back.
> >> >  	 */
> >> > -	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
> >> > +	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
> >> > +	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
> >> >  		/* No work to do, and mlocking twice would be wrong */
> >> >  		vma_start_write(vma);
> >> > -		vm_flags_reset(vma, newflags);
> >> > +		vma->flags = new_vma_flags;
> >>
> >> This also does lot less than vm_flags_reset()?
> >
> > Well let's look:
> >
> > 	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
> >
> > Are we really at a point where this is problematic? Do we hit this? Why are
> > we specifically checking only this case on every single instance of
> > resetting VMA flags?
>
> I'll admit I don't know, but sounds like we can stop being so paranoid when
> converting code to the new API.

Yeah I think so. I think Suren is ok with it, probably :P

>
> >
> > 	vma_assert_write_locked(vma);
> >
> > Note the vma_start_write() line above. I want to separate vma_flags_t
> > helpers from asserts like that, because:
> >
> > 1. We might be operating on a VMA that is not yet added to the tree
> > 2. We might be operating on a VMA that is now detached
> > 3. Really in all but core code, you should be using vma_desc_xxx().
> > 4. Other VMA fields are manipulated with no such checks.
> > 5. It'd be egregious to have to add variants of flag functions just to
> >    account for cases such as the above, especially when we don't do so for
> >    other VMA fields. Drivers are the problematic cases and why it was
> >    especially important (and also for debug as VMA locks were introduced),
> >    the mmap_prepare work is solving this generally.
>
> Perfectly reasonable!
>
> > 	vm_flags_init(vma, flags);
> >
> > Analysing what's in this function:
> >
> > 	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
> >
> > Duplicated.
> >
> > 	vma_flags_clear_all(&vma->flags);
> >
> > Only necessary while you're only setting the first system word of
> > vma->flags.
> >
> > 	vma_flags_overwrite_word(&vma->flags, flags);
> >
> > Again only necessary when you're only setting the first system word.
> >
> > So yeah it's doing the equivalent and (intentionally) eliminating some
> > noise.
>
> Ack.
>
> > But I'll add the S/D check back I guess.
>
> Thanks for the detailed explanation. It's fine to drop legacy stuff, it just
> wasn't obvious if intentional or by mistake. Maybe just mention the
> intention in the changelog?

Yeah that's a fair point will do!

>
> Thanks!
>
> >>
> >> >  	} else {
> >> > -		mlock_vma_pages_range(vma, start, end, newflags);
> >> > +		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
> >> >  	}
> >> >  out:
> >> >  	*prev = vma;
> >> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> >> > index eaa724b99908..2b8a85689ab7 100644
> >> > --- a/mm/mprotect.c
> >> > +++ b/mm/mprotect.c
> >> > @@ -756,13 +756,11 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >> >  		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
> >> >  	}
> >> >
> >> > -	newflags = vma_flags_to_legacy(new_vma_flags);
> >> > -	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
> >> > +	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_flags);
> >> >  	if (IS_ERR(vma)) {
> >> >  		error = PTR_ERR(vma);
> >> >  		goto fail;
> >> >  	}
> >> > -	new_vma_flags = legacy_to_vma_flags(newflags);
> >> >
> >> >  	*pprev = vma;
> >> >
> >> > @@ -771,7 +769,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >> >  	 * held in write mode.
> >> >  	 */
> >> >  	vma_start_write(vma);
> >> > -	vm_flags_reset_once(vma, newflags);
> >> > +	WRITE_ONCE(vma->flags, new_vma_flags);
> >>
> >> Ditto.
> >
> > I mean overall these cases are hacks in my opinion to work around code that
> > should have solved their problem another way.
> >
> > But sure, as above I'll add a helper function or such.
>
> Great.
>
> >>
> >> >  	if (vma_wants_manual_pte_write_upgrade(vma))
> >> >  		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> >> >  	vma_set_page_prot(vma);
> >> > @@ -796,6 +794,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >> >  	}
> >> >
> >> >  	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
> >> > +	newflags = vma_flags_to_legacy(new_vma_flags);
> >> >  	vm_stat_account(mm, newflags, nrpages);
> >> >  	perf_event_mmap(vma);
> >> >  	return 0;
> >> > diff --git a/mm/mseal.c b/mm/mseal.c
> >> > index 316b5e1dec78..603df53ad267 100644
>

Cheers, Lorenzo

