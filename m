Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D52CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FDF8E001D; Fri, 12 Sep 2025 05:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF53F8E0006; Fri, 12 Sep 2025 05:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C198E001D; Fri, 12 Sep 2025 05:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7488E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:21:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A65613BA6B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:21:51 +0000 (UTC)
X-FDA: 83880056022.27.8B2578C
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 881B6180007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:21:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxZ47Gdj;
	spf=pass (imf06.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUZ7obya3Sr5RFpCVfRbeOTL3de87o7Xbr0uUEJlIJc=;
	b=0oiM4NRi1Yb86kb5cDhg4pG+xDr7bcUTs5Nra3uDBrbtRutJAK2axO8BjTHcu5n1XHuCX2
	c8jHo4vxvNuER8MnBh8L2Vs7AbKGbm/tJcWRgb4SINTUPnIhbFNmfAGESutSeaLizehzF4
	Rp96xMyHBg/tpC55qcO8rIWoqUlSSrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668909; a=rsa-sha256;
	cv=none;
	b=pZwlJe+fkqzRBasVmmHlfGW/37yv1HZ2FXGfeLigW9GarY/PxgNT0377fV0f3vyG8AjXA8
	ROHjtCQpnt+/oZpsfMA+tFcs7NBWx04zIbPauUnwwbJm2KjW68Z3eu9OQLp1NTsOwVaAhy
	+38VNTUVpLe5oAcYBUpgGVnIwpHRTeM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SxZ47Gdj;
	spf=pass (imf06.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7459d088020so848093a34.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757668908; x=1758273708; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WUZ7obya3Sr5RFpCVfRbeOTL3de87o7Xbr0uUEJlIJc=;
        b=SxZ47GdjQzX4apM5G87VbQz4yWYeY7wVQyC3LeiB1wIBNts0U8P6wujIKVvVtWRTmh
         x5YuxgBPKZ3ceN/hFw4CKZrCVFVlJ9mOtzAPSyKPoqq96MoivRrIe47yzhiA8OnajVoy
         mWAtdlyovYYNJAvco6Z6H1Ja8m/MHB8FkGE8YLFrmdByI+AZtWCYAqVp2faGCadQMlOz
         ut0BOdv53kPx5BtKAr7QgOSOCkxiBGKRPu/r/C3Cy3SBjjwrv+IW9zKcRwlC/Dri+p2/
         RRxsmLHXX61gYwysFq51Rsr/SVLTqeUHrWlc2m43Eoh503zu2Fn7XIHpiFhMhtYpHBxs
         xg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757668908; x=1758273708;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WUZ7obya3Sr5RFpCVfRbeOTL3de87o7Xbr0uUEJlIJc=;
        b=sC6XSVQ0d6R42RCmSUUbf/j6+0p1mmJ72zCVrE3jU+5GDOCUzHWrhNiS5UGKbbaZrA
         7AKa8Tyblv9xdTWcO1IQIL7C1uRQjfvAV6D79xCKTMjJpmr4dHHcOsREoSPjSr4i61S8
         XZOZErBHgGBR4IUvY6IDFmuLsqqddp5IXNAzHI2t0ojbOW/pLWcsjkNYF7GIEL/D9tKG
         nvT53kMfSqC5FmbQ5pv3pDUnve4KFtaAasstDVlrE8vBq/qZQ4y20lkHcGeGjXMrytuR
         ejPvvarJW2Md09avS5QJl6LJQ5Ic8FvRSfcOHPe/i6QFV7vzSTDBsL3G4aEftLFHD/oC
         sBYA==
X-Forwarded-Encrypted: i=1; AJvYcCX8X+Xw5YIAUebS0tZxlMoQpm5VPq1ygpJ8wOZeUaORgLNiyeRwtL/GxTmtjfBiN9HBqU4GahEXVw==@kvack.org
X-Gm-Message-State: AOJu0YyQ+7LiipiLekn8IEeSqg09S/WUsWjzS9NfYb1lGdTVgccNc32H
	+fc4Wu3zuPgkny4mxtRW2ngycY5t0nPx3VCVU7XPzuvUd8XTH64Vo/oxddFcgfMaKQICqj/QqCL
	JMZgcBgBgFLMfnGpm+LDXx4007m7LCI4=
X-Gm-Gg: ASbGncvuaAYK0RZItYtNiU+/E0pHAjX6xRpWW/d5k8L8g78LBOogTUInt/x3W1h4QIa
	IHykYUjkk1w8AdCf4VT4HkWrakdGY7WqJk2BSeYQtS8iTw7iNbzZp7HlSkiWgUsTNrpssEYbk2t
	hR/3vRsPBW/oPu2oejYCOpA03WUmWfJKrh1vrcF5xxZWGFHA+90S8dKw0ykPOMfLH4cKEDILfgP
	ENpTQ==
X-Google-Smtp-Source: AGHT+IHKdOD0sav1pzLGsvexIHlR11xBcySbkJsNI1i4E1d/USdK7pecHfX7/WogNjy7HJPcnksQEcW2rH2s9qtPrgk=
X-Received: by 2002:a05:6871:204:b0:31d:8a1e:78ce with SMTP id
 586e51a60fabf-32e554a2f38mr945748fac.16.1757668908198; Fri, 12 Sep 2025
 02:21:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250911095602.1130290-1-zhangchunyan@iscas.ac.cn>
 <20250911095602.1130290-2-zhangchunyan@iscas.ac.cn> <9bcaf3ec-c0a1-4ca5-87aa-f84e297d1e42@redhat.com>
 <CAAfSe-sAru+FuhVWRa+i5_sj6m4318pLFrgP0Gsd0DVWzjE-hg@mail.gmail.com> <04d2d781-fd5e-4778-b042-d4dbeb8c5d49@redhat.com>
In-Reply-To: <04d2d781-fd5e-4778-b042-d4dbeb8c5d49@redhat.com>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Fri, 12 Sep 2025 17:21:11 +0800
X-Gm-Features: Ac12FXyFflHnf_JBI4i9hH9jqdgSKY4ieN6Zsx6mGzkigco15IPWhOrDoEo2gdw
Message-ID: <CAAfSe-tQgmBm=RS2gCi7VaRW1XZhS_sJ9rHbvqJ0w=KwTf+m3g@mail.gmail.com>
Subject: Re: [PATCH v11 1/5] mm: softdirty: Add pgtable_soft_dirty_supported()
To: David Hildenbrand <david@redhat.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue <ved@rivosinc.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
	Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8s34ojw9qh58ekiikq117bfog3apziwb
X-Rspamd-Queue-Id: 881B6180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757668909-615752
X-HE-Meta: U2FsdGVkX18pkAQyVuG3WePuXG+g5Rp8SfPq4V8eKEjZiHwJUmVy0KKJKrZtlSUJ4B5Ked10ADGDyZDwNyFJUUS67wuleVj53HfTRDhHnxtRaCMGXICWpB+MoIMOUg2Ve9uOP5rxrZPfF8EVT+8TiWv5WWK6okrAkyY+Lh58Dn3ZXXr90l/lXVaSKpwgM5UyEO6taLxakYZeMzBG1xe+no7Fn6/e6WN9Evxg/6tTnbTbeP9tInpf9WPxUqLeLmZj0x3y/Wz0srctaolrmpp9xC0IcdXPgxcwG2VGjde0naCdwpwSzb+HHkP9OmDW3qyB1RA4OuZ9iBwDABtwm+3fhAqXtR9OwZ84z+So1NpDkaQbyD/XJd9au8UxEPFFnRRjA7hOoGxKAHXI2yn9lKvs6tV0Z/knBijh8Tw6+itENmHELAUIFnRjxysep6XIO7xon5gDwk72HNCVtx69D+E3l0OqwKFF5T3W9mVauNhZMODTYL8CKMpuD0jQuuOl/+8Yck28mnKVLf1WQ1EZWa8CfKTlZ8tedAua3/7HWP9puG1IOg1cZFxlYJHuLQ5v4HXpR6jThJ7+Po1YPNtnOJaqOeGMgZ7SM+dSQHuc3aCCb2bnL/ZdqlogACDSbijGWR7nbiZv17KsJiOG9cbRXuEhIMPFlMd0OvjOYu69gav1yfGdywjpQPZqr1sSqK4EYOB+j9k3uNhT9MNlp002D+ZzUrxdqRpZLTh+d4Id/MhREQxCzi6CXqc1NheXMgCrCkF6bncz4LfGzke0qCNd5OkFe+g51B8ISpoF0pgjBMzGm7gWzuZpn4t44ch6ljtv/svwGP3d3jFjgfzN3w87IZFq1RbcY2EKxCIYzrNaMgLbX6JlbFQP3sRoimJ7pQNjsIjAX370MeNp6+yphBRpACxT/v+oaZdfB36ouqOkRM/ae+IES4+R9OO2cCCf1zTU/uLUBujeZDjP8OtebltQC9p
 163B422P
 VDrRjbVgrCL1rRt+cL2qcUMjHUW0avYV5WGk0RA5qDrwRlUJQCYtYaFPiOrHdWk1PlfSMAvlahQ4UDdu/EBONoY7haoUIAa7HWIDMsLkMGHyifktFNqdxZBpNCi+1d677s9xSnp//n8FbOCuTi6vLkZJlWv+ts5UGUVTXxbEsXrWXGmRLqkK57XmSUYfJRCAvCHWwrQiD8JCctN268yju+y2tkEm6n8DcRiuccXm5PDBxuskxbzGEhYKS4biALDwod7bs4dTjno4AuVV32/9SOyil7hZ2iv5iYWWCZY5d7+zH1lpkukwVcOTxYvxKKO6NKu4s8HFs/yuE6UxolInEgTjS2p1buTW9DQdmAKtRX765T3u1y9oNUQGIVAnPKbavoDZh5W7T4GyPOwwr+S5ExFBKedKcmo1m4gFxhcB3kq6i9b3zmWXcAVQwEX2nydTK9iafY0+SQezkqIwHyDpZVlV3vJMrYF8LQ6NnivSHXsA+P/Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Sept 2025 at 16:41, David Hildenbrand <david@redhat.com> wrote:
>
> [...]
>
> >>> +/*
> >>> + * We should remove the VM_SOFTDIRTY flag if the soft-dirty bit is
> >>> + * unavailable on which the kernel is running, even if the architecture
> >>> + * provides the resource and soft-dirty is compiled in.
> >>> + */
> >>> +#ifdef CONFIG_MEM_SOFT_DIRTY
> >>> +     if (!pgtable_soft_dirty_supported())
> >>> +             mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
> >>> +#endif
> >>
> >> You can now drop the ifdef.
> >
> > Ok, you mean define VM_SOFTDIRTY 0x08000000 no matter if
> > MEM_SOFT_DIRTY is compiled in, right?
> >
> > Then I need memcpy() to set mnemonics[ilog2(VM_SOFTDIRTY)] here.
>
> The whole hunk will not be required when we make sure VM_SOFTDIRTY never
> gets set, correct?

Oh no, this hunk code does not set vmflag.
The mnemonics[ilog2(VM_SOFTDIRTY)] is for show_smap_vma_flags(),
something like below:
# cat /proc/1/smaps
5555605c7000-555560680000 r-xp 00000000 fe:00 19
  /bin/busybox
...
VmFlags: rd ex mr mw me sd

'sd' is for soft-dirty

I think this is still needed, right?

>
> >
> >>
> >> But, I wonder if could we instead just stop setting the flag. Then we don't
> >> have to worry about any VM_SOFTDIRTY checks.
> >>
> >> Something like the following
> >>
> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index 892fe5dbf9de0..8b8bf63a32ef7 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h
> >> @@ -783,6 +783,7 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
> >>    static inline void vm_flags_init(struct vm_area_struct *vma,
> >>                                   vm_flags_t flags)
> >>    {
> >> +       VM_WARN_ON_ONCE(!pgtable_soft_dirty_supported() && (flags & VM_SOFTDIRTY));
> >>          ACCESS_PRIVATE(vma, __vm_flags) = flags;
> >>    }
> >>
> >> @@ -801,6 +802,7 @@ static inline void vm_flags_reset(struct vm_area_struct *vma,
> >>    static inline void vm_flags_reset_once(struct vm_area_struct *vma,
> >>                                         vm_flags_t flags)
> >>    {
> >> +       VM_WARN_ON_ONCE(!pgtable_soft_dirty_supported() && (flags & VM_SOFTDIRTY));
> >>          vma_assert_write_locked(vma);
> >>          WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
> >>    }
> >> @@ -808,6 +810,7 @@ static inline void vm_flags_reset_once(struct vm_area_struct *vma,
> >>    static inline void vm_flags_set(struct vm_area_struct *vma,
> >>                                  vm_flags_t flags)
> >>    {
> >> +       VM_WARN_ON_ONCE(!pgtable_soft_dirty_supported() && (flags & VM_SOFTDIRTY));
> >>          vma_start_write(vma);
> >>          ACCESS_PRIVATE(vma, __vm_flags) |= flags;
> >>    }
> >> diff --git a/mm/mmap.c b/mm/mmap.c
> >> index 5fd3b80fda1d5..40cb3fbf9a247 100644
> >> --- a/mm/mmap.c
> >> +++ b/mm/mmap.c
> >> @@ -1451,8 +1451,10 @@ static struct vm_area_struct *__install_special_mapping(
> >>                  return ERR_PTR(-ENOMEM);
> >>
> >>          vma_set_range(vma, addr, addr + len, 0);
> >> -       vm_flags_init(vma, (vm_flags | mm->def_flags |
> >> -                     VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
> >> +       vm_flags |= mm->def_flags | VM_DONTEXPAND;
> >
> > Why use '|=' rather than not directly setting vm_flags which is an
> > uninitialized variable?
>
> vm_flags is passed in by the caller?
>

Then the original code seems wrong.

> But just to clarify: this code was just a quick hack, adjust it as you need.

Got it.

>
> [...]
>
> >>>
> >>> +     if (!pgtable_soft_dirty_supported())
> >>> +             return;
> >>> +
> >>>        if (pmd_present(pmd)) {
> >>>                /* See comment in change_huge_pmd() */
> >>>                old = pmdp_invalidate(vma, addr, pmdp);
> >>
> >> That would all be handled with the above never-set-VM_SOFTDIRTY.
>
> I meant that there is no need to add the pgtable_soft_dirty_supported()
> check.

Ok I will take a look.

>
> >
> > Sorry I'm not sure I understand here, you mean no longer need #ifdef
> > CONFIG_MEM_SOFT_DIRTY for these function definitions, right?
>
> Likely we could drop them. VM_SOFTDIRTY will never be set so the code
> will not be invoked.

The relationship of VM_SOFTDIRTY and clear_soft_dirty_pmd() is not
very direct from the first sight, let me take a further look.

>
> And for architectures where VM_SOFTDIRTY is never even possible
> (!CONFIG_MEM_SOFT_DIRTY) we keep it as 0.

Ok.

>
> That way, the compiler can even optimize out all of that code because
>
> "vma->vm_flags & VM_SOFTDIRTY" -> "vma->vm_flags & 0"
>
> will never be true.
>
> >
> >>
> >>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >>> index 4c035637eeb7..2a3578a4ae4c 100644
> >>> --- a/include/linux/pgtable.h
> >>> +++ b/include/linux/pgtable.h
> >>> @@ -1537,6 +1537,18 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> >>>    #define arch_start_context_switch(prev)     do {} while (0)
> >>>    #endif
> >>>
> >>> +/*
> >>> + * Some platforms can customize the PTE soft-dirty bit making it unavailable
> >>> + * even if the architecture provides the resource.
> >>> + * Adding this API allows architectures to add their own checks for the
> >>> + * devices on which the kernel is running.
> >>> + * Note: When overiding it, please make sure the CONFIG_MEM_SOFT_DIRTY
> >>> + * is part of this macro.
> >>> + */
> >>> +#ifndef pgtable_soft_dirty_supported
> >>> +#define pgtable_soft_dirty_supported()       IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
> >>> +#endif
> >>> +
> >>>    #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> >>>    #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
> >>>    static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
> >>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> >>> index 830107b6dd08..b32ce2b0b998 100644
> >>> --- a/mm/debug_vm_pgtable.c
> >>> +++ b/mm/debug_vm_pgtable.c
> >>> @@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
> >>>    {
> >>>        pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
> >>>
> >>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> >>> +     if (!pgtable_soft_dirty_supported())
> >>>                return;
> >>>
> >>>        pr_debug("Validating PTE soft dirty\n");
> >>> @@ -702,7 +702,7 @@ static void __init pte_swap_soft_dirty_tests(struct pgtable_debug_args *args)
> >>>    {
> >>>        pte_t pte;
> >>>
> >>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> >>> +     if (!pgtable_soft_dirty_supported())
> >>>                return;
> >>>
> >>>        pr_debug("Validating PTE swap soft dirty\n");
> >>> @@ -718,7 +718,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
> >>>    {
> >>>        pmd_t pmd;
> >>>
> >>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> >>> +     if (!pgtable_soft_dirty_supported())
> >>>                return;
> >>>
> >>>        if (!has_transparent_hugepage())
> >>> @@ -734,8 +734,8 @@ static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
> >>>    {
> >>>        pmd_t pmd;
> >>>
> >>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
> >>> -             !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
> >>> +     if (!pgtable_soft_dirty_supported() ||
> >>> +         !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
> >>>                return;
> >>>
> >>>        if (!has_transparent_hugepage())
> >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>> index 9c38a95e9f09..218d430a2ec6 100644
> >>> --- a/mm/huge_memory.c
> >>> +++ b/mm/huge_memory.c
> >>> @@ -2271,12 +2271,13 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
> >>>
> >>>    static pmd_t move_soft_dirty_pmd(pmd_t pmd)
> >>>    {
> >>> -#ifdef CONFIG_MEM_SOFT_DIRTY
> >>> -     if (unlikely(is_pmd_migration_entry(pmd)))
> >>> -             pmd = pmd_swp_mksoft_dirty(pmd);
> >>> -     else if (pmd_present(pmd))
> >>> -             pmd = pmd_mksoft_dirty(pmd);
> >>> -#endif
> >>> +     if (pgtable_soft_dirty_supported()) {
> >>> +             if (unlikely(is_pmd_migration_entry(pmd)))
> >>> +                     pmd = pmd_swp_mksoft_dirty(pmd);
> >>> +             else if (pmd_present(pmd))
> >>> +                     pmd = pmd_mksoft_dirty(pmd);
> >>> +     }
> >>> +
> >>
> >> Wondering, should simply the arch take care of that and we can just clal
> >> pmd_swp_mksoft_dirty / pmd_mksoft_dirty?
> >
>
> I think we have that already in include/linux/pgtable.h:
>
> We have stubs that just don't do anything.
>
> For riscv support you would handle runtime-enablement in these helpers.
>
> >
> >>
> >>>        return pmd;
> >>>    }
> >>>
> >>> diff --git a/mm/internal.h b/mm/internal.h
> >>> index 45b725c3dc03..c6ca62f8ecf3 100644
> >>> --- a/mm/internal.h
> >>> +++ b/mm/internal.h
> >>> @@ -1538,7 +1538,7 @@ static inline bool vma_soft_dirty_enabled(struct vm_area_struct *vma)
> >>>         * VM_SOFTDIRTY is defined as 0x0, then !(vm_flags & VM_SOFTDIRTY)
> >>>         * will be constantly true.
> >>>         */
> >>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> >>> +     if (!pgtable_soft_dirty_supported())
> >>>                return false;
> >>>
> >>
> >> That should be handled with the above never-set-VM_SOFTDIRTY.
> >
> > We don't need to check if (!pgtable_soft_dirty_supported()) if I
> > understand correctly.
> Hm, let me think about that. No, I think this has to stay as the comment
> says, so this case here is special.

I will cook a new version and then we can discuss further based on the
new patch.

Thanks for your review,
Chunyan

