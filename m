Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9564108B8F5
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95DF6B0005; Fri, 20 Mar 2026 07:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46FD6B0088; Fri, 20 Mar 2026 07:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B352B6B0089; Fri, 20 Mar 2026 07:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6386B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:08:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51B921A0170
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:08:26 +0000 (UTC)
X-FDA: 84566167812.09.67D9D31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AABB8140007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:08:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lM0U/sma";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/82aNgfvf4YFc1fjX6IqLmObJKB/FevM1+RgKnik5U=;
	b=Xn45E3AwoLWabbNbltgIXE1KwY9wvLpQWLtO0omVQIe2tmemvt4LVsmUXKKrc1tCRTt5EV
	+Od/v/AJx4WNAHCCP9Z/vh7BxJBe+HV+HKCGgbaieTXPGqSH7oSNKk2LlYeT7q852u968n
	R3dR355C8NmAncvljkFcgNjTWEiKCII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004904; a=rsa-sha256;
	cv=none;
	b=hmduP2Ko/DMUTAr+7XFopHEDHIYnngJbRnmLnBwuP0J/CppCgW3iNsvGgZYWdOira7Nnna
	7tAYm1qGZzuStS0f4TsGDdv+5u8bZhxcldBFCFUOH3ztzsZPAP04ZlXqVMEZN7EVlu0p7L
	DIFYiOHDXcpv/HU6Pnte9ckNyNIZBOE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lM0U/sma";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB41D60121;
	Fri, 20 Mar 2026 11:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E98DC4CEF7;
	Fri, 20 Mar 2026 11:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774004903;
	bh=IubUj+jqwRzKoQPj58xDc4nZfpvuDGr1R52SQV2ZLLA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lM0U/smadkBEflGyTvmy4GTZW1CFk/3otou6bjFy+dQmA00CHj/ypWe+e73C+zMZQ
	 jhmmO/CjnbFULEMKZS8VBpTbomAMt/cjPAVKyMfPOEREZs8pQlH04qTV/9MvL9x8YN
	 TrPExLO4WzXOykz6o15XYE3r5fRQKyGZ8l0sR0R7p7noB+1Xlz9xivuUpaESQBfpJp
	 Uyof/p8lwb2nc+aKhxOi6BQIC0quLodlIc6P0Iz2eYTTYq69lyrHX9jDbzPea2sYop
	 DmVdpjbcONP/eCN6f1cRlmFQAT+Qh0Z77PP3l/hk1KZKNUaP6VaiRb7tSkfT2VopkI
	 oaRAH25ZcMSnA==
Date: Fri, 20 Mar 2026 11:08:08 +0000
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
Message-ID: <7e22cc48-aa04-406d-b4d0-8ebb182b34b9@lucifer.local>
References: <cover.1773846935.git.ljs@kernel.org>
 <98a004bf89227ea9abaef5fef06ea7e584f77bcf.1773846935.git.ljs@kernel.org>
 <0b5765da-67e9-4e2e-99d8-08501730bf76@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b5765da-67e9-4e2e-99d8-08501730bf76@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AABB8140007
X-Stat-Signature: 94a5cjqzwwa6fqpx59c6j187gs9c1odw
X-Rspam-User: 
X-HE-Tag: 1774004904-907458
X-HE-Meta: U2FsdGVkX1/OjBqXyxU4QhKQ1MIqWDEwJ46yK1QYi0oD3aXB3rXQ5NtbMIr9JNiDmLwlI/ecIVIZi46ypl63gAl2iwsQCy2NjY3zA8LKko93XAScYoP9UE1+TIHSaenPga7LF0jqnHg7WdPpRQMmFBWsoriVDFpzZI4wUskHWqHTYU+B27DbAAE8KPd2B01OLSEkRXOGbmGtGEe9u6Im7jHhexVdAGlvsl+mZfCMOXaHZuxCap+izO/YaJJQV1Mrxp9Ld7qf0B5LwXEkYD6vQgxH8Z97Qmq8xAJl6zIIuSS1Np6x995CEd+mhacU7ARbfagLfCNAuC6Zd1AhxDSryfE668M4AmMlGekQolDfJqTtCeM6SxWCBAOzjtTiG5ySfny+7ymA6T14p198Z34SmNjiuh/Kq6Qsgv8Mdv6uhAK+Lw8cPVxwgKjVKnmjSME7KAiOyc6vPZSPiN2HdkWWxyHMqYnEaYHVB6qrSBP+fxnxGrNTZYBCz8sYzVHMxQ+xEc1bsaxkG7xdqqb+w6VyJ+5GvPwPPo70Rww/N4uVhOm/jRGMuxV7q23/l+weNrGZbY0ajTnOjcBk8voOaKGKgc8xg6H6kHczJF2Wo/1ELY5WuiFH4aQkEtXfyM0S0gIrMu5+DTaC6Ps73L6C7mLrs9A+Z/x7kQyfl/IxMbwrBy6xPREFbmEKRVxoe/Tlk7dilQsjoLLxCjArNQz/xkRYaCskHHVSREHDtByYAj/SkjdnIXXmzTFp+RIxMWBy7isCWOzwyoZbYped/xx8VKy6Osb2JY4Oa7oIbxjxhM+SG4sLX3LgaEKrWOlpbpW2nCcmrjljr4snSjie/yzs/j4zfkAqEXQeK/xYX8xfBkkzfA+YlmQ/aOEgCpmwW1uZLnJW9hSMNU/ixP0JMrXVkTlOPqFlzcNFArjF8xnL456hu9DZA83bFoETX4uIV/+Pqa0dndh9hVj+XtJzCj7envn
 3xUKK7K1
 OqaNXTMzBEBL5FmbEDu78G6FITX5U9wjTnXiG0abIGwxTUkiDgq7VKUEfaGNna5nyCpNznkagjir27qxBO8U0h0aQtL2C37g2j1BhomGtyZk8YmCHVDAcMr9xFNqsg/8vF9rUbodq6dQanCRCiZRC2TtPEhI+AwNXPqljQfvKNDTvUbXMlhG+Dh5h+VMMRJ0fwHAq2rzW7OFOHbQfxQ1S5RopGqbN+sFscxmw5tLbwIsZ+Eewh4YmJa8u9k76eWDlWXmCbh5MuYvtz+khqTfXrLdjWgfL/nrfBzVEc/XjdKRFFLHhxO4FnXEnsQLD8UfCM3VmxWEW9syZss/0u82xS/55nHvbMJ2QSmN4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:39:58AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> > Update the vma_modify_flags() and vma_modify_flags_uffd() functions to
> > accept a vma_flags_t parameter rather than a vm_flags_t one, and propagate
> > the changes as needed to implement this change.
> >
> > Finally, update the VMA tests to reflect this.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -415,13 +415,14 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
> >   * @vma - vma containing range to be mlock()ed or munlock()ed
> >   * @start - start address in @vma of the range
> >   * @end - end of range in @vma
> > - * @newflags - the new set of flags for @vma.
> > + * @new_vma_flags - the new set of flags for @vma.
> >   *
> >   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
> >   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
> >   */
> >  static void mlock_vma_pages_range(struct vm_area_struct *vma,
> > -	unsigned long start, unsigned long end, vm_flags_t newflags)
> > +	unsigned long start, unsigned long end,
> > +	vma_flags_t *new_vma_flags)
> >  {
> >  	static const struct mm_walk_ops mlock_walk_ops = {
> >  		.pmd_entry = mlock_pte_range,
> > @@ -439,18 +440,18 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
> >  	 * combination should not be visible to other mmap_lock users;
> >  	 * but WRITE_ONCE so rmap walkers must see VM_IO if VM_LOCKED.
> >  	 */
> > -	if (newflags & VM_LOCKED)
> > -		newflags |= VM_IO;
> > +	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
> > +		vma_flags_set(new_vma_flags, VMA_IO_BIT);
> >  	vma_start_write(vma);
> > -	vm_flags_reset_once(vma, newflags);
> > +	WRITE_ONCE(vma->flags, *new_vma_flags);
>
> It's not clear to me, how is switching from vm_flags_t to vma_flags_t
> allowing us to simply do WRITE_ONCE() instead of the full logic of
> vm_flags_reset_once()? Won't it fail to compile once once flags are more
> than single word? Or worse, will compile but silently allow tearing?

We only care about tearing in the flags that can be contained within a
system word, but true we should probably do this more carefully, as I did
for vm_flags_reset_once().

I will reimplement this as a new, hideous, helper function.

I am not a fan of this being a thing to handle races, it's a hack. But I
guess that should be addressed separately.

>
> >
> >  	lru_add_drain();
> >  	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
> >  	lru_add_drain();
> >
> > -	if (newflags & VM_IO) {
> > -		newflags &= ~VM_IO;
> > -		vm_flags_reset_once(vma, newflags);
> > +	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
> > +		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
> > +		WRITE_ONCE(vma->flags, *new_vma_flags);
>
> Ditto.

Yup.

>
> >  	}
> >  }
> >
> > @@ -467,20 +468,22 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	       struct vm_area_struct **prev, unsigned long start,
> >  	       unsigned long end, vm_flags_t newflags)
> >  {
> > +	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
> > +	const vma_flags_t old_vma_flags = vma->flags;
> >  	struct mm_struct *mm = vma->vm_mm;
> >  	int nr_pages;
> >  	int ret = 0;
> > -	vm_flags_t oldflags = vma->vm_flags;
> >
> > -	if (newflags == oldflags || vma_is_secretmem(vma) ||
> > -	    !vma_supports_mlock(vma))
> > +	if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags) ||
> > +	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
> >  		/*
> >  		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
> >  		 * For secretmem, don't allow the memory to be unlocked.
> >  		 */
> >  		goto out;
> > +	}
> >
> > -	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
> > +	vma = vma_modify_flags(vmi, *prev, vma, start, end, &new_vma_flags);
> >  	if (IS_ERR(vma)) {
> >  		ret = PTR_ERR(vma);
> >  		goto out;
> > @@ -490,9 +493,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	 * Keep track of amount of locked VM.
> >  	 */
> >  	nr_pages = (end - start) >> PAGE_SHIFT;
> > -	if (!(newflags & VM_LOCKED))
> > +	if (!vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT))
> >  		nr_pages = -nr_pages;
> > -	else if (oldflags & VM_LOCKED)
> > +	else if (vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT))
> >  		nr_pages = 0;
> >  	mm->locked_vm += nr_pages;
> >
> > @@ -501,12 +504,13 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	 * It's okay if try_to_unmap_one unmaps a page just after we
> >  	 * set VM_LOCKED, populate_vma_page_range will bring it back.
> >  	 */
> > -	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
> > +	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
> > +	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
> >  		/* No work to do, and mlocking twice would be wrong */
> >  		vma_start_write(vma);
> > -		vm_flags_reset(vma, newflags);
> > +		vma->flags = new_vma_flags;
>
> This also does lot less than vm_flags_reset()?

Well let's look:

	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));

Are we really at a point where this is problematic? Do we hit this? Why are
we specifically checking only this case on every single instance of
resetting VMA flags?

	vma_assert_write_locked(vma);

Note the vma_start_write() line above. I want to separate vma_flags_t
helpers from asserts like that, because:

1. We might be operating on a VMA that is not yet added to the tree
2. We might be operating on a VMA that is now detached
3. Really in all but core code, you should be using vma_desc_xxx().
4. Other VMA fields are manipulated with no such checks.
5. It'd be egregious to have to add variants of flag functions just to
   account for cases such as the above, especially when we don't do so for
   other VMA fields. Drivers are the problematic cases and why it was
   especially important (and also for debug as VMA locks were introduced),
   the mmap_prepare work is solving this generally.

	vm_flags_init(vma, flags);

Analysing what's in this function:

	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));

Duplicated.

	vma_flags_clear_all(&vma->flags);

Only necessary while you're only setting the first system word of
vma->flags.

	vma_flags_overwrite_word(&vma->flags, flags);

Again only necessary when you're only setting the first system word.

So yeah it's doing the equivalent and (intentionally) eliminating some
noise.

But I'll add the S/D check back I guess.

>
> >  	} else {
> > -		mlock_vma_pages_range(vma, start, end, newflags);
> > +		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
> >  	}
> >  out:
> >  	*prev = vma;
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index eaa724b99908..2b8a85689ab7 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -756,13 +756,11 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >  		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
> >  	}
> >
> > -	newflags = vma_flags_to_legacy(new_vma_flags);
> > -	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
> > +	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_flags);
> >  	if (IS_ERR(vma)) {
> >  		error = PTR_ERR(vma);
> >  		goto fail;
> >  	}
> > -	new_vma_flags = legacy_to_vma_flags(newflags);
> >
> >  	*pprev = vma;
> >
> > @@ -771,7 +769,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >  	 * held in write mode.
> >  	 */
> >  	vma_start_write(vma);
> > -	vm_flags_reset_once(vma, newflags);
> > +	WRITE_ONCE(vma->flags, new_vma_flags);
>
> Ditto.

I mean overall these cases are hacks in my opinion to work around code that
should have solved their problem another way.

But sure, as above I'll add a helper function or such.

>
> >  	if (vma_wants_manual_pte_write_upgrade(vma))
> >  		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> >  	vma_set_page_prot(vma);
> > @@ -796,6 +794,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >  	}
> >
> >  	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
> > +	newflags = vma_flags_to_legacy(new_vma_flags);
> >  	vm_stat_account(mm, newflags, nrpages);
> >  	perf_event_mmap(vma);
> >  	return 0;
> > diff --git a/mm/mseal.c b/mm/mseal.c
> > index 316b5e1dec78..603df53ad267 100644

