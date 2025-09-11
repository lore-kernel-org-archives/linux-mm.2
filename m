Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633FCCA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6F58E000F; Wed, 10 Sep 2025 22:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87108E0001; Wed, 10 Sep 2025 22:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D198E000F; Wed, 10 Sep 2025 22:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 957268E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:52:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52DF413A3B6
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:52:33 +0000 (UTC)
X-FDA: 83875446186.05.063F9BB
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 88AFB1A0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:52:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D85w678k;
	spf=pass (imf19.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757559151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpMjHp2LWdB4AWDkPscdVaO0VRTcuWiIT22FTu9B1MU=;
	b=EGSbarlHTMG6TYSQB+erSPcg02oGt8hY0bMAiexIjZ7kNblfVt/QPf+PwifTADDGIxUU/Q
	2dnXOb9eECHj9in/9ByOienXCmRrew++R48T58cVgZAYubyifH6d72CzXl0FJiZm51iDJj
	nHSRhatOBwwG0OqgyUXIS00KT8qAibI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D85w678k;
	spf=pass (imf19.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757559151; a=rsa-sha256;
	cv=none;
	b=K75Ej3cSfys4pKPies/woYot+xrWeIkrkRxZ9cqXZ3Ti+ktPU16LogqX6tTkSbsOHkJGUW
	gsgU2kdgC9lRG0c5CCc09wnUjBJXFC2V09yWIjVySFbJH88rAjWPtn46d2JTqVlguQdZFZ
	EQrbihCqYJRh91+gPdfP4IPGZje+1nM=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-3257a70c221so176983fac.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757559150; x=1758163950; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bpMjHp2LWdB4AWDkPscdVaO0VRTcuWiIT22FTu9B1MU=;
        b=D85w678k7ZBbPzJJI+88kQaVPvglKiZg+XU9LvWD90tioHRumoF0gUy7VOj/5VUEZO
         hndAVHFahH7B4VpSLQ97+63+F+Cnq4niMxB+ywkdtwxNk4FiRGDCAzyqSSRsnNF9l+Vz
         DXMl4aQxIypJpagp8ZIOko0D5BeE9q8NtMSI/K88l6Mpz9GBC7A2mES7LFWp+edDn3wO
         ZX80dI9XpWE/Y3cOaRWnHUjq4BXv96Wx9n4GCfpYorVMHeyOFzG53sh0HE5VsnfsCSGP
         NDIgG4+pf8+BWMBHLRJnw/eKNMPo7I8lxFE4I+FOSuATq4uqIqaI2i4M6r7wfzYnhMDZ
         vtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757559150; x=1758163950;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bpMjHp2LWdB4AWDkPscdVaO0VRTcuWiIT22FTu9B1MU=;
        b=V9ivEkgLh92DDZukl7LXFPt6IxBo2al8PcJweXm2foDmxYJhh2Uqs8NHPbPOyv4/kj
         yr36p4JCzwBPjsCNTh8Jgj6av2O5CKlT4XYg6fcg6bedzkrN2tg66U4A9bTJ28l2WizN
         f8TUpY2O7RE4n1AE9iu2NEVd+0wdNRrXYYXXuRQbyVbqERCfIaQzMiSrYdTNh6g4ZVtT
         t0LJoxIzkmYLuMt+R8ZVpzk1p8nrnW3/+HefMCuFB/1+tdz8lyEVfpwbxfREXjig81Kq
         F4GWQHlIc8FhPppiY9SXOLUMzGRYSrGrJvu/e+ftwFEhJIUYS3RGtnGXHoENP5jCT8QI
         rlxA==
X-Forwarded-Encrypted: i=1; AJvYcCVSg4fsd4+Si+I4iznjsobChKalh/Z3sYRKy4xjWvTZolfZ1iiEzErD+UwkFJUJxR2NWWA7mAfKfg==@kvack.org
X-Gm-Message-State: AOJu0YwCmf6g8Lo6TLwW6NWhIyvTgIZPlFSQDw8FtfuiSIGR15dtEXDW
	MpobqOoqMb8/pxGfJ3ER5AEttrsNuR7oZ8npepJCeQ5OpIjpTLF+W52PvH8SUN4OViwIt0Nry4r
	K6GKdLj1DZUpcEyvSPkMt1mnVLAiXXnw=
X-Gm-Gg: ASbGncuZ8E1kDKvmvNcBLMgaRN2sAxLFsfEIw3AahGA5tu7J/QVDpggVBS4KTrHc3Yp
	4CJgg34hadcFwNhbRFU7rdhtUXVZ6EmZhYMahiogKQt2OuqMm0RvtVmO8DAooynbOtaDyHA65+z
	zH/7sRtbQuqZi2w1D/sm2Fgf+mz7Fmhi2el/CQiOBsXcDXDoKfdfLU66c1sCkWwh4BkdYbW69oE
	HobKQ43Ee/3vVPSHE9ol92AUpQUVFJKezyMhKc=
X-Google-Smtp-Source: AGHT+IFv2XibXXypOlqv0RILHKkLaMk/1jc9mR92t82jtZp+Vm0vVDQ6eAhrLbih1UZ+0wzcwt9/oVQRFlYGSifHFZw=
X-Received: by 2002:a05:6870:524d:b0:321:2680:2f84 with SMTP id
 586e51a60fabf-3226284cc7bmr8304474fac.3.1757559150312; Wed, 10 Sep 2025
 19:52:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
 <20250909095611.803898-2-zhangchunyan@iscas.ac.cn> <6b2f12aa-8ed9-476d-a69d-f05ea526f16a@redhat.com>
 <CAAfSe-vbvGQy9JozQY3vsqrrPrTaWYMcNw+NaDf3nReWz8ynZg@mail.gmail.com> <8f9a4a13-2881-4baf-ab62-3d0d79e0cd3c@redhat.com>
In-Reply-To: <8f9a4a13-2881-4baf-ab62-3d0d79e0cd3c@redhat.com>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Thu, 11 Sep 2025 10:51:54 +0800
X-Gm-Features: Ac12FXw931KhRWiAwZHuKU_RVXZ29toqGSbWPbkJSujEUI17HyVR0UbdKmmlFK4
Message-ID: <CAAfSe-snV-XZ3xGmK6gXNXw-D3ECWbyQgG+WG3c5gAsREz4ccQ@mail.gmail.com>
Subject: Re: [PATCH V10 1/5] mm: softdirty: Add pte_soft_dirty_available()
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88AFB1A0002
X-Stat-Signature: fxkmca88kxtrrg7r75cz89a831z4enj1
X-HE-Tag: 1757559151-473140
X-HE-Meta: U2FsdGVkX1/YsOf2ikTidJDDmh0Q4cS4JR68CK21aIU1eXfXXJO0yLuFYtB6gsct/QEW8q9/shCc65EBr49Wylb1EvQ7y/44TqETu1Aw23Fu09dk1D5x47xb+aONPB5TsLoSB3j7/kVDNx3FYxjuiVBinCsgoS5bZpLSWhWOGAKbaBlinKtIJ+r9Wm3jxwFXKiLzY4DwuQuIQVh4nXv2+C7hHg7k6tWEjoMUyXEj3oZI7eSUBmfs21F8ltxeNoN1hRgcaBnLZDCDpmV2sqUpQpAV6/0ZwfHZMb2FGPuYpd8OtvcdKsDWVnob+casBCViZVzD7CnOxzNJjxshK/JFO8cK3g/fVzuoHnJoZqy8xx41qDBHYa1x1EDEZ+f1SDnRmEuZf1WoZkxMyxmFIWE1yXIOGveDwbtNlQ72bhiYQ8LzWKo/qA1guQT3PSXuVrw7KczG5NKTTXnHFy2cFYbMBs3GVgeDgmFQvvqF0ZPEQfVbMMSLLHh+WKCWVcrS7dBkUox96YQjoJA4s5dWqh8C2JgDeA265tVFEUQT/l3gkpecVV9ObnB3+NEoGzmrWb+FsDLD4bHc7ABdNjke6KZN8GA6RrGiS6u0AVAXgHWUECc3zsA0yIjF/AB01lq91nGrkgMy8iJSTlVFeX4Q7x6COpV25HNaw9QGk1Qr3b7UFc67z4W2+6Cjp4qIBtpeWBlsIQ5DYRp7QS+ozHLeXy73+FUqm0hsUnIqAwLGQsParItACo5c0trI6KU0LJ16wd7xoo8KqNR7qvFb5zVaiHurEklbXCmcRItFBHkA6laF+Ran+GhneAaFIy3DNymr2+SVStYIpJBtG358e3LsX6PWdf79YdpXvCh/hiikxgjp2WIrn3YR8uN1THfqLwBAWPWerN7wV2G5TQvLKnGEif/pH0EZ19bzYp5uGyMXSvZwHfmlxDRsl2DRQ4oSWksazScREpfz6EWaSGeNaR0hehA
 RuTXsCzv
 wqFSR9Gj9mFHRhFeQjtSydmuXIQcrnV5nXmGWj0PRdFVWsFDH6CqYX39iALzcdJ0Uqa+70z1LlaWDxzdjJtuOVVwav9AcgN5nLI4W6paRr6NFH6jYlgMYe3lwwrk8shyOURGfDgoCLfbDfaCGkJ0eTK6WPC8BLvhqAF19DvCRYf5DdEa6FOyAZvrpJTnbLv24fwyc81BuFvKPhoDlD0bHf88T0qFx65jCvZ4gp3QXHE1yJUVK/H0pmSojvGanQS2uTBFFvDHgEowux3gA1uejrvm2KYY4h26CB0DdmE9cBlFCHbmChDzQU6qWE8hhntViLLKWSEeuP+xPZty/OJfwEo3lrPzzNNuuvdrHupFW+sQNuNAMhMuYjfOfWDQe6Ut/YBIA6vOkMF6jcBbWGfJOw3L6/RjEzbjcLGfav1eux341Y+kso2G2VYDxFddD7THUiakHS0o5R/4LhK8dZIjL1k5sS3WxYcWf+2Yl+pdgp3gCtCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sept 2025 at 16:51, David Hildenbrand <david@redhat.com> wrote:
>
> On 10.09.25 10:25, Chunyan Zhang wrote:
> > Hi David,
> >
> > On Tue, 9 Sept 2025 at 19:42, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 09.09.25 11:56, Chunyan Zhang wrote:
> >>> Some platforms can customize the PTE soft dirty bit and make it unavailable
> >>> even if the architecture allows providing the PTE resource.
> >>>
> >>> Add an API which architectures can define their specific implementations
> >>> to detect if the PTE soft-dirty bit is available, on which the kernel
> >>> is running.
> >>>
> >>> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> >>> ---
> >>>    fs/proc/task_mmu.c      | 17 ++++++++++++++++-
> >>>    include/linux/pgtable.h | 10 ++++++++++
> >>>    mm/debug_vm_pgtable.c   |  9 +++++----
> >>>    mm/huge_memory.c        | 10 ++++++----
> >>>    mm/internal.h           |  2 +-
> >>>    mm/mremap.c             | 10 ++++++----
> >>>    mm/userfaultfd.c        |  6 ++++--
> >>>    7 files changed, 48 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >>> index 29cca0e6d0ff..20a609ec1ba6 100644
> >>> --- a/fs/proc/task_mmu.c
> >>> +++ b/fs/proc/task_mmu.c
> >>> @@ -1058,7 +1058,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >>>         * -Werror=unterminated-string-initialization warning
> >>>         *  with GCC 15
> >>>         */
> >>> -     static const char mnemonics[BITS_PER_LONG][3] = {
> >>> +     static char mnemonics[BITS_PER_LONG][3] = {
> >>>                /*
> >>>                 * In case if we meet a flag we don't know about.
> >>>                 */
> >>> @@ -1129,6 +1129,16 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >>>                [ilog2(VM_SEALED)] = "sl",
> >>>    #endif
> >>>        };
> >>> +/*
> >>> + * We should remove the VM_SOFTDIRTY flag if the PTE soft-dirty bit is
> >>> + * unavailable on which the kernel is running, even if the architecture
> >>> + * allows providing the PTE resource and soft-dirty is compiled in.
> >>> + */
> >>> +#ifdef CONFIG_MEM_SOFT_DIRTY
> >>> +     if (!pte_soft_dirty_available())
> >>> +             mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
> >>> +#endif
> >>> +
> >>>        size_t i;
> >>>
> >>>        seq_puts(m, "VmFlags: ");
> >>> @@ -1531,6 +1541,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
> >>>    static inline void clear_soft_dirty(struct vm_area_struct *vma,
> >>>                unsigned long addr, pte_t *pte)
> >>>    {
> >>> +     if (!pte_soft_dirty_available())
> >>> +             return;
> >>>        /*
> >>>         * The soft-dirty tracker uses #PF-s to catch writes
> >>>         * to pages, so write-protect the pte as well. See the
> >>> @@ -1566,6 +1578,9 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> >>>    {
> >>>        pmd_t old, pmd = *pmdp;
> >>>
> >>> +     if (!pte_soft_dirty_available())
> >>> +             return;
> >>> +
> >>>        if (pmd_present(pmd)) {
> >>>                /* See comment in change_huge_pmd() */
> >>>                old = pmdp_invalidate(vma, addr, pmdp);
> >>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >>> index 4c035637eeb7..c0e2a6dc69f4 100644
> >>> --- a/include/linux/pgtable.h
> >>> +++ b/include/linux/pgtable.h
> >>> @@ -1538,6 +1538,15 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> >>>    #endif
> >>>
> >>>    #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> >>> +
> >>> +/*
> >>> + * Some platforms can customize the PTE soft dirty bit and make it unavailable
> >>> + * even if the architecture allows providing the PTE resource.
> >>> + */
> >>> +#ifndef pte_soft_dirty_available
> >>> +#define pte_soft_dirty_available()   (true)
> >>> +#endif
> >>> +
> >>>    #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
> >>>    static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
> >>>    {
> >>> @@ -1555,6 +1564,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
> >>>    }
> >>>    #endif
> >>>    #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
> >>> +#define pte_soft_dirty_available()   (false)
> >>>    static inline int pte_soft_dirty(pte_t pte)
> >>>    {
> >>>        return 0;
> >>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> >>> index 830107b6dd08..98ed7e22ccec 100644
> >>> --- a/mm/debug_vm_pgtable.c
> >>> +++ b/mm/debug_vm_pgtable.c
> >>> @@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
> >>>    {
> >>>        pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
> >>>
> >>> -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> >>> +     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
> >>
> >> I suggest that you instead make pte_soft_dirty_available() be false without CONFIG_MEM_SOFT_DIRTY.
> >>
> >> e.g., for the default implementation
> >>
> >> define pte_soft_dirty_available()       IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
> >>
> >> That way you can avoid some ifefs and cleanup these checks.
> >
> > Do you mean something like this:
> >
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -1538,6 +1538,16 @@ static inline pgprot_t pgprot_modify(pgprot_t
> > oldprot, pgprot_t newprot)
> >   #endif
> >
> >   #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> > +#ifndef arch_soft_dirty_available
> > +#define arch_soft_dirty_available()     (true)
> > +#endif
> > +#define pgtable_soft_dirty_supported()
> > (IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && arch_soft_dirty_available())
> > +
> >   #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
> >   static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
> >   {
> > @@ -1555,6 +1565,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
> >   }
> >   #endif
> >   #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
> > +#define pgtable_soft_dirty_supported() (false)
>
> Maybe we can simplify to
>
> #ifndef pgtable_soft_dirty_supported
> #define pgtable_soft_dirty_supported()  IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
> #endif
>
> And then just let the arch that overrides this function just make it
> respect IS_ENABLED(CONFIG_MEM_SOFT_DIRTY).

Ok, got you, I will address it.

Thanks for your review,
Chunyan


>
> --
> Cheers
>
> David / dhildenb
>

