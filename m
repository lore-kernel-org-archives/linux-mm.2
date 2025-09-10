Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DABCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECCC8E0013; Wed, 10 Sep 2025 04:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4278E0003; Wed, 10 Sep 2025 04:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFDF8E0013; Wed, 10 Sep 2025 04:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B22D8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:26:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A89FB86E9A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:26:07 +0000 (UTC)
X-FDA: 83872657974.22.DC52C30
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id D35EB140002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:26:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T/wO6psB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757492765; a=rsa-sha256;
	cv=none;
	b=pQMJCZUHd1YiQi11/3YJLB69ZZ5u3JcJNuh3giNdeVMsH1yeDEQ5rxTSJTdQGOI3CTqSEn
	W3GP9agV2424FVVSxRmDhDIJ1tK8jz/LgDcZDWkH1xCoW1r5Osm1InZ1DqPEODcHGCqyDs
	ywOsrsQDRrWeI2GMANtDRPAchAPpThA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T/wO6psB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757492765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQH7snnNQnRZRbg0xLLdaSxYnYx9rFgR1u9eFyrWIv8=;
	b=HiQXxpJ62IlvJamYBdey+HS2YJaOxLAI4Lk87OMmXN1f2CGSEx2EFl9NGo8IyaPMAbBAZM
	ut1ru4VXBtdzBBnqvktr6peimneD7/PPzUu6w12wqVOyC9GwILklXKVbNRgHembGdImHnG
	ROQ2qLoseNUjN1EWJQ9JEx+ZOdHmAtM=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-31db571a432so3401525fac.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757492765; x=1758097565; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nQH7snnNQnRZRbg0xLLdaSxYnYx9rFgR1u9eFyrWIv8=;
        b=T/wO6psBBR3R/JF5jJiE+5awt6+bABYCygtbFz5pxbxd7iBpSEz1nqHupdDVzPrugH
         5EC6wh/dRvlfsxtc9ImISClWfZtPy5qAwyEdxXNikni6k2wRDDZ4P2mWVttyf6+bBbeC
         4TO1uczFxlxvkUMKnuo7fQrwPrxDweaePX3jLkxmNSbj1ezJfN65n/U83LQ/NO7BGrZd
         AxIuHJ3DEr1HcY1OE0R2U6I4kdMSuhzemXD1VCW+EaxOwI9/8GZ4XcOgbU9HziThqjqk
         C5jCF+D/4OGzIcdMQxuy1WmArCH88hRRiSyc1kFzmJl6R05rBRnU0yinmwpDeqbvzFuz
         ROLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757492765; x=1758097565;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQH7snnNQnRZRbg0xLLdaSxYnYx9rFgR1u9eFyrWIv8=;
        b=U8gv1Fbe9ZInP3IW8ffW+PaODRBLrVPjE36M9Jb/msiRH1227PahgF8qw9FpWfKkCb
         CTKf7RxbLPFL9LPvEG0h4Kgnw1KnoymIQbr8i8EJImyYT45Qdx+my+kwc/dDiNL5eoXt
         qVgLFR+gTmNiugfJg6x4l4bnS/m+seWpbe0vltBlp4AWW5SQ/FpsIlKjl7IbGgAIbpAg
         bxB0Ck+GDDnlBI8Y3BcZq88jzgG6w5rylVmYozZowsvHz9siuyJ6bssPk1/vLwP3KxdB
         a/1RQamDXjxdplPYvU6wdlnS2X8C1MhxgsiaqUauFpHv0UUAu4KskpyK2TjQyoRPQtZG
         JAjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZyVWtzg/lh+OXrKz0fwF2FJRIcSBAgLjNesmjPjdPHEOcOEjtdLih1azM6XXd20W/jNjLgwesug==@kvack.org
X-Gm-Message-State: AOJu0YwfjBLIGppHBUlWz/jZOlYbor6gKMIoDH9gZubY7lW9TjL/3UmJ
	HH/oqps9i6QD7JlvB+zsRi/aAC1ubmfiK7g5VBXv4pDb/RWlpJr2qrPrG/jwxsKK8v1T5YWAvoQ
	ge3Pf2ofG38wiGn9JCis3SOZVzzJipR0=
X-Gm-Gg: ASbGnctCVq1uec4zH22En4uuPhtV6mjrdgvkI0m9B+pcJgiNXLRQNxm6ISdXai7xXqO
	RXGJdzjT3nzRXzho98lA9k0a+fVi+G6CyML91FSYxbbG7okjXQsnDiABsiNplLB14gn+61+aH5C
	DSe/2XT9LnQMp5DL3eVSuhkDD2dXKBfGP9REiWmmzKhfz15qdiVB3tkxbxMwLh5db6jTjdEQ2WR
	etBEQ==
X-Google-Smtp-Source: AGHT+IG8+X4z7lWHsoiDJ8ey4B9KiZeLoM8QTORaK4x4ttFg5WhTeM8qOcmzY4k1bJV831pksGGd1X5634WxyYNLQpo=
X-Received: by 2002:a05:6871:4b10:b0:31d:6b5b:6b57 with SMTP id
 586e51a60fabf-32264c16755mr7048854fac.30.1757492764639; Wed, 10 Sep 2025
 01:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250909095611.803898-1-zhangchunyan@iscas.ac.cn>
 <20250909095611.803898-2-zhangchunyan@iscas.ac.cn> <6b2f12aa-8ed9-476d-a69d-f05ea526f16a@redhat.com>
In-Reply-To: <6b2f12aa-8ed9-476d-a69d-f05ea526f16a@redhat.com>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Wed, 10 Sep 2025 16:25:28 +0800
X-Gm-Features: Ac12FXx-v6pjQQB1q-gdPDWGiaVNDNxmW_UZ1a0xUB3t-SaqR__1RTrhpm4oqiU
Message-ID: <CAAfSe-vbvGQy9JozQY3vsqrrPrTaWYMcNw+NaDf3nReWz8ynZg@mail.gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D35EB140002
X-Stat-Signature: wpauggxe5gmhn8u4u61maxjkxaugy1tw
X-Rspam-User: 
X-HE-Tag: 1757492765-289675
X-HE-Meta: U2FsdGVkX1+K4FWGvHfuBejjsiZ9YEjpt2Sr2NlpQtgIKeq54cs9tsNW0DGz/CDsLCG6vUiEpY/VIVWARL6u1iUD6rRRkwflkwaNE+XLMQQ1ynYcyuD8qzDXFz3owWE+T0LAsi61Q7h7e1cmb8ZK3Mn8HCgN/sYE0UlgsPHQ69tPidhQ7DxZl1jdBonkvi/0u2KaV6af3xt0euXxPRC7rZX+RFCIF0Ph2J29zCqg7aXMaupnVH24cL/diKQ8cTgATdCa2Z4SFeKIH7QLm0BmXjlCFjObPP+16uAQc9fTX8H+fVj37PzrWfuUm7Ayi1foF4opbbNKGJBnA8EhNyd2SP9XlSFrYOlU3KzfMwci/zPHpghlpYDaSs0SiHnl9GtygB3PmKiV/g2uXhLrUdeuHYty8Qi3vLVyAT2FLO88RlqVK7+SYHqMH0JJ/HdfDiIDmMOr1RE5jFVW+YaPyw6udHdUuYqemxxRcXhCKAHkHsnaS1i6F8MWWed3Gf0km3JJcJquNiIb+aUx0r8QGlTm8D4ERn74oOH3cW5d7zryiFqM6QDOyL9BDa3v6ivATZTvGFNEj4/NeBtc15opHX60EROKmJq6pc0G0u7FFODkVAL7csE4QJ9Zn3/MIWC2MVmNvYpjOKPJ0878atqWX0vaEvyUvY5mQ99Rs3EldJaOVUky8NuJeIZBs14i7Eddg3QNcpT23Uf7epdt5GxiDOz1EqyNUIDogBUDiyVDw+brY2XcECIapHO/FbCLbIogXFAKd3NgiyclxHwSBE4RMVjtFnHyM4azhcPyG6YR6S0JH2qfl1QUy7j6NwU9BF9f5Y+12X4fgPgKGMFsKt/cWF2UERz/tuc48wIJRjmaEy+QJc9mg7tXDtHO6V6rL1McwVkDLKZqfHcnQB98Fl/nhgfIFjhPoPW+10X7pttd+SIvdLTI9tR90mhKsIsF8qIh/2avemlGKrHyflCHBrsdBLB
 O2T9Jkir
 K+i6bj0soJrmB+Y/hXtzCC7Abl/HedST5p/QSNz72D3RhncVQhbhTLFg1ax2ACnOBGJJA72hm96KLI/a073NauKpoBbc9lDpvKkY/vXU0sJ098oZN/lt6VYNofv9U3Kc8uNsVpZgK7DA0ereLrOzkPrAJHZWfCGmqasphbRThIbRgVOreBD7tJsspUss0Uu4XMv7jjcNJM5TmB84LYWTr2iZXhLeZvjL5DPplPpw9XLdSwGkCnBpamyUpy/s6Ta0PSZZxZWdntVuitcjnHY/qmUhiorErH67bIOnfJm3CozUPpPo4K4CS5ZviC5NVgt0dyV8oAnsHQe+cafg2hhGvGJ5HeU7xv2lbMuB5S/VoU5Ddvjrc+rpQXwshM+JU8jiHn7KETr8GVFcpHP/WtmEz5qp6m+2h9XVIpefMT3a4It3uNR0VIY3pLAPAN5fe3OK2ysLDP/azZ3t6rEr5NaCdXyDNCVus0Qeov1U5fKNA14R5v/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Tue, 9 Sept 2025 at 19:42, David Hildenbrand <david@redhat.com> wrote:
>
> On 09.09.25 11:56, Chunyan Zhang wrote:
> > Some platforms can customize the PTE soft dirty bit and make it unavailable
> > even if the architecture allows providing the PTE resource.
> >
> > Add an API which architectures can define their specific implementations
> > to detect if the PTE soft-dirty bit is available, on which the kernel
> > is running.
> >
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
> >   fs/proc/task_mmu.c      | 17 ++++++++++++++++-
> >   include/linux/pgtable.h | 10 ++++++++++
> >   mm/debug_vm_pgtable.c   |  9 +++++----
> >   mm/huge_memory.c        | 10 ++++++----
> >   mm/internal.h           |  2 +-
> >   mm/mremap.c             | 10 ++++++----
> >   mm/userfaultfd.c        |  6 ++++--
> >   7 files changed, 48 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 29cca0e6d0ff..20a609ec1ba6 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1058,7 +1058,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >        * -Werror=unterminated-string-initialization warning
> >        *  with GCC 15
> >        */
> > -     static const char mnemonics[BITS_PER_LONG][3] = {
> > +     static char mnemonics[BITS_PER_LONG][3] = {
> >               /*
> >                * In case if we meet a flag we don't know about.
> >                */
> > @@ -1129,6 +1129,16 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> >               [ilog2(VM_SEALED)] = "sl",
> >   #endif
> >       };
> > +/*
> > + * We should remove the VM_SOFTDIRTY flag if the PTE soft-dirty bit is
> > + * unavailable on which the kernel is running, even if the architecture
> > + * allows providing the PTE resource and soft-dirty is compiled in.
> > + */
> > +#ifdef CONFIG_MEM_SOFT_DIRTY
> > +     if (!pte_soft_dirty_available())
> > +             mnemonics[ilog2(VM_SOFTDIRTY)][0] = 0;
> > +#endif
> > +
> >       size_t i;
> >
> >       seq_puts(m, "VmFlags: ");
> > @@ -1531,6 +1541,8 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
> >   static inline void clear_soft_dirty(struct vm_area_struct *vma,
> >               unsigned long addr, pte_t *pte)
> >   {
> > +     if (!pte_soft_dirty_available())
> > +             return;
> >       /*
> >        * The soft-dirty tracker uses #PF-s to catch writes
> >        * to pages, so write-protect the pte as well. See the
> > @@ -1566,6 +1578,9 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
> >   {
> >       pmd_t old, pmd = *pmdp;
> >
> > +     if (!pte_soft_dirty_available())
> > +             return;
> > +
> >       if (pmd_present(pmd)) {
> >               /* See comment in change_huge_pmd() */
> >               old = pmdp_invalidate(vma, addr, pmdp);
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index 4c035637eeb7..c0e2a6dc69f4 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -1538,6 +1538,15 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
> >   #endif
> >
> >   #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> > +
> > +/*
> > + * Some platforms can customize the PTE soft dirty bit and make it unavailable
> > + * even if the architecture allows providing the PTE resource.
> > + */
> > +#ifndef pte_soft_dirty_available
> > +#define pte_soft_dirty_available()   (true)
> > +#endif
> > +
> >   #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
> >   static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
> >   {
> > @@ -1555,6 +1564,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
> >   }
> >   #endif
> >   #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
> > +#define pte_soft_dirty_available()   (false)
> >   static inline int pte_soft_dirty(pte_t pte)
> >   {
> >       return 0;
> > diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> > index 830107b6dd08..98ed7e22ccec 100644
> > --- a/mm/debug_vm_pgtable.c
> > +++ b/mm/debug_vm_pgtable.c
> > @@ -690,7 +690,7 @@ static void __init pte_soft_dirty_tests(struct pgtable_debug_args *args)
> >   {
> >       pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
> >
> > -     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
> > +     if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) || !pte_soft_dirty_available())
>
> I suggest that you instead make pte_soft_dirty_available() be false without CONFIG_MEM_SOFT_DIRTY.
>
> e.g., for the default implementation
>
> define pte_soft_dirty_available()       IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
>
> That way you can avoid some ifefs and cleanup these checks.

Do you mean something like this:

--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1538,6 +1538,16 @@ static inline pgprot_t pgprot_modify(pgprot_t
oldprot, pgprot_t newprot)
 #endif

 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#ifndef arch_soft_dirty_available
+#define arch_soft_dirty_available()     (true)
+#endif
+#define pgtable_soft_dirty_supported()
(IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) && arch_soft_dirty_available())
+
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
 {
@@ -1555,6 +1565,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
+#define pgtable_soft_dirty_supported() (false)

>
>
> But as we do also have PMD soft-dirty support, I guess we would want to call this
> something more abstract "pgtable_soft_dirty_available" or "pgtable_soft_dirty_supported"
>
> --
> Cheers
>
> David / dhildenb
>

