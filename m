Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B9010987AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:38:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9216B00B6; Fri, 20 Mar 2026 12:38:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D08A6B00B8; Fri, 20 Mar 2026 12:38:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498696B00D9; Fri, 20 Mar 2026 12:38:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3280C6B00B6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:38:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ECB4BB7C6D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:38:51 +0000 (UTC)
X-FDA: 84567000462.05.640F1E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5803518000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:38:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/OfmVcP";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HO9cO3R1impdEosu2LKruSjtd9ozLd1JQp6jnHMa/MI=;
	b=VoyMyc+MkNdwFt4sqYXdOJGpAFLMY5nyA/iq4WIKoHt9A7ctrPKBeqc8BQa45HGR9lZ4Su
	2Z1EUvpHxxpaCK3xZnhYMpEBHtuHV6va09hydcE8bdOg5FEYZc9C88pC9xZaNaPZAuX6Cs
	OX2uZ9/O1jyZ4rKX8DN5CBwhmmAvY+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774024730; a=rsa-sha256;
	cv=none;
	b=TM8zBbLwrl5WT6PSeMtiihdnp4seLQemqMkXd6b3cikHzgPIGLJ2AVIG5Hvm7Rf0Bc1wUK
	cvuKZTNzKvKLQYZO5lIofPbL6xikRPFJxxeOqaENPy9aW1dwbn03QVUPERZlBVTqp/yc5L
	16/Nzikju1EGp29VGdS66jWby5GTbrw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/OfmVcP";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 847CE60126;
	Fri, 20 Mar 2026 16:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDAC6C19425;
	Fri, 20 Mar 2026 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774024729;
	bh=Ksk0/Cy+7k9g8VSMuw5OALSCZ2GB9qpziu6Wa5P0d+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I/OfmVcP71NX/eXv6rVA2H8uavbrfsew5pTj2wiVU5s+aHz5rN91R2Pz36DoL2+Fo
	 rANmKpvbZV7cOFQK+lP7oYlsRq/4paUxujz4rezTBqKA66bwYPVNNBhzhmCr6J4xbi
	 vjtP4kZEQ3amGKczLKy0m9YptVW35xq5Lm0Uxk2IG2Ler/6ijJ1G8YxCbmrxkSEC7Y
	 M29VqGltRdx6Sm1ifElpqV0bL0Tm8oltBzYTbPzaR+3rGw9s9CGPX7CR94ZjYtEyJX
	 jNLGM6YhVKgZpqntE0j9rerpK2JQejQf6CXMtXpXIuBddKssqb6KupwcU8OClk6p8E
	 qhsKSOvDUiIBg==
Date: Fri, 20 Mar 2026 16:38:34 +0000
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
Subject: Re: [PATCH v3 17/23] mm: convert do_brk_flags() to use vma_flags_t
Message-ID: <366b74cf-b569-4004-bd12-dfbcefc25e56@lucifer.local>
References: <cover.1773846935.git.ljs@kernel.org>
 <981ed1afcd19115432e61778e7d226a36f8f5c2b.1773846935.git.ljs@kernel.org>
 <1d300b3b-2476-4381-b8df-a680f486b284@kernel.org>
 <f47e24c4-3a11-4a58-96f5-871443660246@lucifer.local>
 <7e2aea13-e047-4891-bd6f-ff6705c4fc28@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e2aea13-e047-4891-bd6f-ff6705c4fc28@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5803518000C
X-Stat-Signature: eq775ryf4h1twyn4aksjj7bs3hndn4qt
X-Rspam-User: 
X-HE-Tag: 1774024730-153406
X-HE-Meta: U2FsdGVkX18yke319mK7DJoxY2ia++pex7MaOlI03bo5GgIFTZEDOgZkpQei0np1Gax7DbH1e5ZpY2oZVO443LcOLSuiuwSB9FEINqoOutl4/ZM8ETHGDFD3mDXGFv8uNayYqwm1bT9l8EDHbp1znwzC8Chhjpf3XDMe2bsZImReEYUDJHXteT4ScFADMb3lZdsxzNOVk7EXR2Mz7N6t1G0ZGXdK2Po6INNIr/pYSEymFH1J1E55vjYkd5Pg3OZGRLguuQq/RBaI9OIrt+LaYS0lQKiGrjRvVGlxYF7Hz5vHYLUGDaFIjyqzstbk1tUZ9TU8qVzFAXzgbLZ+ESCy9fevhi6QJC0tkTTN6NHhXENrNKmislxzAM3QrbpN8U88cKygJMuO2DoGAPyK2GV+I2322gf65uPxkSMRKEN9BRfXa2Edm+d318oNlQCJLZcXTmcebELXHhJh56E3RhUG5KRWBKNhsUE4fdMjErO4WxDWSjHgVBfk5cQZLJexL/DadhTX1mvf4nCz6X2KYNz27W7FZD+gyzQ7L8W16EPmhdWYq2JV3a7sr8f2KxjUQA/4LvqoE+qMR8Tt3Qd06OILr7F6PdWvfLHe+khNVopj1UP4pkOVevjDrAlaI/fnocQ12cyK9KdCokLMog0DqFkOFH7oJNxGB4X90QrouSNa64TJAk2rovTyOwtXUjPawDXpyRGRAxBPwfuGX4Ur74jHoqHfnIc2tgqFiZFFV76f3LJ6FZZoe4Axi1Kv9FW+Tif+V8TqUREw+C8Oy0Ye/8SfQ0RwD8P97olhMi0m5PaXn/dD/Mbjq+YvkyKiCjHKVuR4O+rAnwXHK/tE1BClyraGOCKlaB10pTRBotiwnWQUhwFQvVTSpSP8YbwVyS06R5NJkemXOemHZSOLT1UOygyNXSDZDZpBojUtYrJZ5iK/4GzjAhzWxsludtyz8Ek+hyXC7jkqszKzhu2g9MXToL7
 YLCMzhDO
 VfT55weZGhfbg6ZDVL5C5cCArfZntdmNnytZ4o/Q+Boh/bF4NHJRPz4PQevGUTD/OuxmdnxorAPO2lrHcAUzA3uZtpPH7sWD3tin1XpVyCPJnH+byGNsOsNQB8sK7ftQrru4XjN71xIOJ576cEJQsmz9T/h7MI2DzRrzkZY+W67q1AQUGC2sdR+gomFHqnMflCwu7ww+Vc2X5VpnnSrzQ00eQSB6Kru/Uv4PM+s0xABpvRcgNA+KzrlUADQ5iuQx8nVtNFqQpHhrdqc2gZzbumUimt9uK9Hqfnju+mLwD9S+eb/PL/nmKuHWjQd6ldYZKxDS0+Ifuhb5PZUz+WaFq5nAaBxtPCVM8au1ZYHrreC3+PyM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:06:15PM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 14:42, Lorenzo Stoakes (Oracle) wrote:
> >>
> >> More nits below:
> >>
> >> > diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> >> > index b39cc1127e1f..e25d0d18f6d7 100644
> >> > --- a/arch/arm64/include/asm/page.h
> >> > +++ b/arch/arm64/include/asm/page.h
> >> > @@ -46,7 +46,12 @@ int pfn_is_map_memory(unsigned long pfn);
> >> >
> >> >  #endif /* !__ASSEMBLER__ */
> >> >
> >> > -#define VM_DATA_DEFAULT_FLAGS	(VM_DATA_FLAGS_TSK_EXEC | VM_MTE_ALLOWED)
> >> > +#ifdef CONFIG_ARM64_MTE
> >> > +#define VMA_DATA_DEFAULT_FLAGS	append_vma_flags(VMA_DATA_FLAGS_TSK_EXEC, \
> >> > +						 VMA_MTE_ALLOWED_BIT)
> >>
> >> I wonder what's the bloat-o-meter impact of these #define's (this
> >> arm64-specific one isn't the only one) being no longer compile-time-constants?
> >
> > I mean there's a precedent for this, but the compiler _should_ figure out this
> > as a constant value, I have repeatedly confirmed that it's good at that in
> > godbolt, via make foo/bar.S etc.
>
> Great, thanks!
>
> >
> >>
> >> >   */
> >> >  #define vma_desc_set_flags(desc, ...) \
> >> >  	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
> >> > @@ -4059,7 +4071,6 @@ extern int replace_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
> >> >  extern struct file *get_mm_exe_file(struct mm_struct *mm);
> >> >  extern struct file *get_task_exe_file(struct task_struct *task);
> >> >
> >> > -extern bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long npages);
> >> >  extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
> >> >
> >> >  extern bool vma_is_special_mapping(const struct vm_area_struct *vma,
> >> > diff --git a/mm/internal.h b/mm/internal.h
> >> > index f98f4746ac41..80d8651441a7 100644
> >>
> >> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> >> > index 9681f055b9fc..eaa724b99908 100644
> >> > --- a/mm/mprotect.c
> >> > +++ b/mm/mprotect.c
> >>
> >> > @@ -773,19 +778,24 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> >> >
> >> >  	change_protection(tlb, vma, start, end, mm_cp_flags);
> >> >
> >> > -	if ((oldflags & VM_ACCOUNT) && !(newflags & VM_ACCOUNT))
> >> > +	if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
> >> > +	    !vma_flags_test(&new_vma_flags, VMA_ACCOUNT_BIT))
> >> >  		vm_unacct_memory(nrpages);
> >> >
> >> >  	/*
> >> >  	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
> >> >  	 * fault on access.
> >> >  	 */
> >> > -	if ((oldflags & (VM_WRITE | VM_SHARED | VM_LOCKED)) == VM_LOCKED &&
> >> > -			(newflags & VM_WRITE)) {
> >> > -		populate_vma_page_range(vma, start, end, NULL);
> >> > +	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
> >> > +		const vma_flags_t mask =
> >> > +			vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
> >> > +				      VMA_SHARED_BIT, VMA_LOCKED_BIT);
> >> > +
> >> > +		if (vma_flags_same(&mask, VMA_LOCKED_BIT))
> >>
> >> That converts the original logic 1:1, but I wonder if it's now feasible to
> >> write it more obviously as "VMA_LOCKED_BIT must be set, VM_WRITE_BIT and
> >> VM_SHARED_BIT must not" ?
> >
> > Hmm, I'm not sure if I can express this more clearly, it's a pain either
> > way. Could do:
> >
> > 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
> > 	    !vma_flags_test_any(&old_vma_flags, VMA_WRITE_BIT, VMA_SHARED_BIT))
> > 		populate_vma_page_range(vma, start, end, NULL);
>
> It would be a bit more:
>
> 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
> 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
>  	    !vma_flags_test_any(&old_vma_flags, VMA_WRITE_BIT, VMA_SHARED_BIT))
>  		populate_vma_page_range(vma, start, end, NULL);

Right yeah sorry :)

That is clearer but still pretty verbose. Will think about how to do it but I
think as a follow up still makes more sense.

>
> (or reordered in whatever way the short circuting works best here, the original
> code tested oldflags first).
>
> But yeah, at least to me it's more clear what that's testing and doesn't need to
> set up the intermediate mask variable, and VMA_LOCKED_BIT is there only once
> in the code now. The number of vma_flags_* operations is the same.
>
> >>
> >> > +			populate_vma_page_range(vma, start, end, NULL);
> >> >  	}
> >> >
> >> > -	vm_stat_account(mm, oldflags, -nrpages);
> >> > +	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
> >> >  	vm_stat_account(mm, newflags, nrpages);
> >> >  	perf_event_mmap(vma);
> >> >  	return 0;
> >>
> >> > diff --git a/mm/vma.h b/mm/vma.h
> >> > index cf8926558bf6..1f2de6cb3b97 100644
> >> > --- a/mm/vma.h
> >> > +++ b/mm/vma.h
> >>
> >> > +static inline bool is_data_mapping_vma_flags(const vma_flags_t *vma_flags)
> >> > +{
> >> > +	const vma_flags_t mask = vma_flags_and(vma_flags,
> >> > +			VMA_WRITE_BIT, VMA_SHARED_BIT, VMA_STACK_BIT);
> >> > +
> >> > +	return vma_flags_same(&mask, VMA_WRITE_BIT);
> >>
> >> Ditto?
> >
> > I may do both as a follow up patch given the series is a pain to rework at this point
> > and I want at least the first version to be like-for-like intentionally.
>
> OK sure.

Cheers!

>
> >>
> >> > +}
> >> >
> >> >  static inline void vma_iter_config(struct vma_iterator *vmi,
> >> >  		unsigned long index, unsigned long last)
> >> > diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> >> > index 8134e1afca68..5cee8b7efa0f 100644
> >
> > Thanks, Lorenzo
>

