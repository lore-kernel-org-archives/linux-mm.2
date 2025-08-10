Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38474C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 06:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C614D6B009B; Sun, 10 Aug 2025 02:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36FB6B009C; Sun, 10 Aug 2025 02:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CDE6B009D; Sun, 10 Aug 2025 02:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4A566B009B
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 02:31:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E7DE1DC856
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 06:31:38 +0000 (UTC)
X-FDA: 83759876676.03.CA72AB6
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0DB041C000C
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 06:31:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tTypgfZI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754807496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXi5ucQB+R4RXrYdM/FFE3o3KgvXJZDz39jZn9JOrRw=;
	b=6n9p/wZuPe05EU85yxfyMbY7jKPwFRKKbr/Yh4sQUBB8PUwGYwQZJpIlZ5cU7Wu7AqKJby
	f4K1FL5qmVIn/y1AReC+bIYeWV3UvCgTbEj2w7CQgCa/59umi96ggUIPidYS24KHBnvZuE
	NH5qgGYWv6X591/M9GjUN26Gc6mmELA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754807496; a=rsa-sha256;
	cv=none;
	b=WsuFhkyVdwQsE572E+ykRDoCM5yESgQl226wqhB55YgUC1H8c+1p1klPBAaCMCr4dm236Q
	3Bu3J5omttSd/5CmKXBlhbuyS1lGKV8A/CGPrh7dsD0aXEaxKtQpsSH5/R5F9EhMHf14zD
	lcrUgbwNorW87Rgvze2H+A9sGonaYH0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tTypgfZI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-617ff2cb07cso6331a12.0
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 23:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754807494; x=1755412294; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXi5ucQB+R4RXrYdM/FFE3o3KgvXJZDz39jZn9JOrRw=;
        b=tTypgfZIRzByZU68RymzurtzUksAq0y0Z0ZWcPrJDLuQB3paZQmbeDoQRk1onAB0vu
         E82BgL9eEfoT0qFkoec4H2LqoxyibTxzuhXHJLcmehin5X0CLWUuFlrsTubM3EkMn38F
         svt8v8trf3Tr+099cZxs1+QMAyW+U1RibWTYHtEyGiWrFV2VSx4T+D99IDEfFlf9NQsC
         QeZc/pqb+JeGjerOUOCgp1Onp+C9Ux74QUwMDcw92e2KB7EOYj2t2DAYV2vjuqn4fzQE
         nDl3LTiY6zAQFv0re35UvWXrBMzPtfG59RBr/yslKG3PNVtHtzn1/0/J4NOzdjTLRX0Z
         JIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754807494; x=1755412294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kXi5ucQB+R4RXrYdM/FFE3o3KgvXJZDz39jZn9JOrRw=;
        b=eS/G5JBqaGtnQl2BPjt0+8RQzDCsG8tfef/9jEbm5vpvAhP+LUYPcqg9h+IzX1uplX
         fBk5Hoe8T4pVc9HgZGkE2NIPFai3kJY8At13z0BnpgBhWu50E+Q6Woxjb7nJzkhHTw/T
         M+PSYpsd4LJdqFTsjx0kyDrEq9RcmWYxchi7dp/pmzPd5b2lySSt1d0tzsQ2g7AYa1/o
         IALnwzU64KIubM0pVkpZqnIAz7/oANDKdRQ+SGpWdugLHe/eqExVsJvZ8N3+MqWHkfSF
         nUmKY4m+kO3IbF1v+lmDcAWq/ZW2YljIWBIAtRBiOV2DR2zkAWysEyC3Y0PuKcBxgYB5
         pwug==
X-Forwarded-Encrypted: i=1; AJvYcCUuvE7YrpyMfwV7R2+VbB/0vAkiGMaQ21CSGlRW5DhXi4hxeP/h0f6Mg0gaEdHMh+c3xyLvIy74yA==@kvack.org
X-Gm-Message-State: AOJu0YxNYZQIKyiWlF3lQetiR2/912PmVB5Y6e30CnSvabbf1f789Qv3
	IuzlOGVq8SFoh1G40kk16D0OY57qHSC4A5ugYDVO9CyQXR2IkmaQFh9wjokUgPH03yNOuRPdd4B
	hpIyFw0x4tBNVEVteXJmBXm+01zlK+HKyQU/I9UyA
X-Gm-Gg: ASbGncuYsOZMFSdWaMEM6uESqhPy9Oe3ViX9HlkVLHXF6pYBz14OvNdu4f+1RxMREdT
	0YRer1IEBBev7DfGARelyB8HM1txyMtCLE36lqda35xDIsoyZyRdFkjac0foal7lv6JybXjprrD
	UO+e0MIGVNI6vrbUgjPyjTN9Mf9YbPq5Kuhzm3fNc7OAkvvTnoNSyFIqKzH9lkmtIq/enp64VyS
	qIn+JIjPS/oDhBYUOwdyjd8zrVmEq54WZVbWrVDGQI2U1Auq1G7
X-Google-Smtp-Source: AGHT+IFGC2cCebIbpoCTpzqZIFDhhtklzc2HSYV90zaHkP/thj1IoeN05dKyVtizFsMr1wyY7HZx8k+LLuPgy+ZGTq8=
X-Received: by 2002:a05:6402:52c9:b0:618:1799:5baa with SMTP id
 4fb4d7f45d1cf-61817995bc2mr21649a12.7.1754807493960; Sat, 09 Aug 2025
 23:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250807103902.2242717-1-lokeshgidra@google.com>
 <aJT7qQzEs_p36yfI@x1.local> <CA+EESO64MOZaJHyY_mTy6Gqvaz=CkPLHgc-UZ1rg8FXcPyh0aA@mail.gmail.com>
In-Reply-To: <CA+EESO64MOZaJHyY_mTy6Gqvaz=CkPLHgc-UZ1rg8FXcPyh0aA@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Sat, 9 Aug 2025 23:31:20 -0700
X-Gm-Features: Ac12FXwWIpWpRcdgTyU_Cxa9yDyWl24_SkIbmVCa98KMH3_AzRy7yCt8WGp4b7o
Message-ID: <CA+EESO6vm6Qs+ZiYFPyXXV6C981U10qo2V7P-OvkaJL2P_0Xvg@mail.gmail.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mpfsurm9rnsz5a6ugk6m13kwwnjtotr7
X-Rspamd-Queue-Id: 0DB041C000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754807495-269921
X-HE-Meta: U2FsdGVkX18iXg20ip+EZh43PZvxldbnOIKTyBiPlzroF9VSHXLBWbZIZ8DFEtOI+hWtAFbAC5IjfEV9aKi472IxShFfqPFcip9ubWUokTqdmRZb0iR0wdNHwLY/8yl9EgOBzwhfyy1OBFR3jX90SsIv1CBLVgYOTnE3wBMsQrcvmxNCQqMKknZGt1vKSa+RsdhtcLT1iiMD2CEE+Jy/chwCekR/Ip5EL585a1a6ETq+bHiLmcLrf/8ZalVfbsrLxUcBMWu9XEC4UTHux65VjhxmU7WOhCEtR7sAf6zozXZ0YUMkPfdWtj3bwTuNl7We3naNBsvcMi+8cpAqj5d6Nx7I9N4kaDf5xb2DghGKq7XLfexztgLetHQS4n77hgEcuN5DLNddBVF1I2+/ampa3+ghmGGIxNngXvQlHXkyrLBFONLncVu0I2cVkxFWH8THS2/OUrA7PpCvV8AOBW0G50lNweTNxlOWoufr66+9rfoZlXxKEJY693Pk8tmNXJ/VK1DTIbyh2mk1lwExm+yZhY4hN3m/mC0g9TERwculWx+MnC6L4LrRjo2o/6zlCFT29LcyZPZUA0Wyq2H/At8k4DTqoEjZqvUz1VoDNgTdH/pZyaCjwVUt3CLqKNaJRC4nkyXqEuWPBndWYP9Wyc/AVGrUKGLfo/7Wf2NZSh2OyzLgMqZiVt44ZXgu+WRGnnluFRiOiQGXpNIzPsCGvtxkyTB3V4azmWU58IJxTIAZPK1J9fVvxQLIcnkQt51a0PqmaNVwFEuL4UvpXLRJlDiWDN/zwMNksR8Hh79xoQds/3smtgp/Fp+PRtBt5+AdGR4Xk/1xRTffXhj4+PtPYueegiJ5gSyLknlKDcQ2fBS3yLTYTqVJQZlsdxcZKVileNONmEYSV4YPt0HvRXzUH4p4Vvy1fadO9H4V8tqccJ5xoXJ+KYTUqjd76C+Uuo+UeFDAB71dlinF8UjX+swjz80
 eNesQhZp
 b3a5UMSo9H+QX8cw2otMGJgFlb5AyfGiSPL0DWHZ7DfIu2Hb5lQKC/hXK+Y6Ch/rgeLaha091/4JC6b9GSaMEMddyUHvO0NfXPL8KRemHgbkWrOZTOFncNHp0cD8trd5+u1xhIU2QEzgnQ+X62Dq3oAcmnkPD0Ry6nhQbjilFbOhDNKH2hinMdNANz1xGV5tLLFFlkdu/Rz/klmPL0rx0NIbZPAKeTXSZ6uTMbYOL3r7gTEdHD4+hWeuVpXwfod4wnm0tnukZy3OsX0uDkY14gjWiJbm4A9YoFQ1w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 9:29=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.com=
> wrote:
>
> On Thu, Aug 7, 2025 at 12:17=E2=80=AFPM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > Hi, Lokesh,
> >
> > On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is require=
d
> > > for moving present pages. Mitigate this cost by opportunistically
> > > batching present contiguous pages for TLB flushing.
> > >
> > > Without batching, in our testing on an arm64 Android device with UFFD=
 GC,
> > > which uses MOVE ioctl for compaction, we observed that out of the tot=
al
> > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), an=
d
> > > ~20% in vm_normal_folio().
> > >
> > > With batching, the proportion of vm_normal_folio() increases to over
> > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> >
> > Do you know why vm_normal_folio() could be expensive? I still see quite
> > some other things this path needs to do.
> >
> Let's discuss this in Andrew's reply thread.
>
> > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > includes TLB-flush overhead.
> >
> > Indeed this should already prove the optimization, I'm just curious whe=
ther
> > you've run some benchmark on the GC app to show the real world benefit.
> >
> I did! The same benchmark through which I gathered these numbers, when
> run on cuttlefish (qemu android instance on x86_64), the completion
> time of the benchmark went down from ~45mins to ~20mins. The benchmark
> is very GC intensive and the overhead of IPI on vCPUs seems to be
> enormous leading to this drastic improvement.
>
> In another instance, system_server, one of the most critical system
> processes on android, saw over 50% reduction in GC compaction time on
> an arm64 android device.
>
> > >
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > ---
> > > Changes since v2 [1]
> > > - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> > > - Added check to ensure all batched pages share the same anon_vma
> > >
> > > Changes since v1 [2]
> > > - Removed flush_tlb_batched_pending(), per Barry Song
> > > - Unified single and multi page case, per Barry Song
> > >
> > > [1] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@=
google.com/
> > > [2] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@g=
oogle.com/
> > >
> > >  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++------------=
--
> > >  1 file changed, 128 insertions(+), 51 deletions(-)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index cbed91b09640..78c732100aec 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t =
*dst_pte, pte_t *src_pte,
> > >              pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> > >  }
> > >
> > > -static int move_present_pte(struct mm_struct *mm,
> > > -                         struct vm_area_struct *dst_vma,
> > > -                         struct vm_area_struct *src_vma,
> > > -                         unsigned long dst_addr, unsigned long src_a=
ddr,
> > > -                         pte_t *dst_pte, pte_t *src_pte,
> > > -                         pte_t orig_dst_pte, pte_t orig_src_pte,
> > > -                         pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > -                         spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > > -                         struct folio *src_folio)
> > > +/*
> > > + * Checks if the two ptes and the corresponding folio are eligible f=
or batched
> > > + * move. If so, then returns pointer to the folio, after locking it.=
 Otherwise,
> > > + * returns NULL.
> > > + */
> > > +static struct folio *check_ptes_for_batched_move(struct vm_area_stru=
ct *src_vma,
> > > +                                              unsigned long src_addr=
,
> > > +                                              pte_t *src_pte, pte_t =
*dst_pte,
> > > +                                              struct anon_vma *src_a=
non_vma)
> > > +{
> > > +     pte_t orig_dst_pte, orig_src_pte;
> > > +     struct folio *folio;
> > > +
> > > +     orig_dst_pte =3D ptep_get(dst_pte);
> > > +     if (!pte_none(orig_dst_pte))
> > > +             return NULL;
> > > +
> > > +     orig_src_pte =3D ptep_get(src_pte);
> > > +     if (pte_none(orig_src_pte) || !pte_present(orig_src_pte) ||
> >
> > pte_none() check could be removed - the pte_present() check should make
> > sure it's !none.
> >
> Makes sense. I'll make the change in the next version of the patch.
>
> > > +         is_zero_pfn(pte_pfn(orig_src_pte)))
> > > +             return NULL;
> > > +
> > > +     folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > > +     if (!folio || !folio_trylock(folio))
> > > +             return NULL;
> >
> > So here we don't take a refcount anymore, while the 1st folio that got
> > passed in will still has the refcount boosted.  IMHO it would still be
> > better to keep the behavior the same on the 1st and continuous folios..
> >
> > Or if this is intentional, maybe worth some comment.  More below on thi=
s..
> >
> This is indeed intentional, and I'll add a comment in the next
> version. But let me explain:
>
> The first folio needed the refcount as we need to pin the page before
> releasing the src ptl. Also, because split_folio(), if called, expects
> the caller to hold the lock as well as reference on the folio.
>
> The subsequent folios in the batch are always within the ptl critical
> section and neither the splits are required. Therefore, I didn't want
> to unnecessarily increase the work done within the critical section.
> But, please correct me if I'm misunderstanding something.
>
> > > +     if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)=
 ||
> > > +         folio_anon_vma(folio) !=3D src_anon_vma) {
> > > +             folio_unlock(folio);
> > > +             return NULL;
> > > +     }
> > > +     return folio;
> > > +}
> > > +
> > > +static long move_present_ptes(struct mm_struct *mm,
> > > +                           struct vm_area_struct *dst_vma,
> > > +                           struct vm_area_struct *src_vma,
> > > +                           unsigned long dst_addr, unsigned long src=
_addr,
> > > +                           pte_t *dst_pte, pte_t *src_pte,
> > > +                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > > +                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > +                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > > +                           struct folio *src_folio, unsigned long le=
n,
> > > +                           struct anon_vma *src_anon_vma)
> >
> > (Not an immediate concern, but this function has potential to win the
> >  max-num-of-parameters kernel function.. :)
>
> I noticed the same when I made the change :) Maybe in a subsequent
> patch if we inline is_pte_pages_stable() and PTL acquire/release in
> move_pages_ptes(), then quite a few parameters can be reduced. But
> then, IMO, even move_pages_ptes() refactoring is required as well.
> >
> > >  {
> > >       int err =3D 0;
> > > +     unsigned long src_start =3D src_addr;
> > > +     unsigned long addr_end;
> > >
> > > +     if (len > PAGE_SIZE) {
> > > +             addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > > +             if (dst_addr + len > addr_end)
> > > +                     len =3D addr_end - dst_addr;
> >
> > Use something like ALIGN() and MIN()?
>
> Will do in the next version.
> >
> > > +
> > > +             addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > > +             if (src_addr + len > addr_end)
> > > +                     len =3D addr_end - src_addr;
> >
> > Same here.
> >
> Will do.
>
> > > +     }
> > > +     flush_cache_range(src_vma, src_addr, src_addr + len);
> > >       double_pt_lock(dst_ptl, src_ptl);
> > >
> > >       if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_s=
rc_pte,
> > > @@ -1051,31 +1097,54 @@ static int move_present_pte(struct mm_struct =
*mm,
> > >               err =3D -EBUSY;
> > >               goto out;
> > >       }
> > > +     arch_enter_lazy_mmu_mode();
> > > +
> > > +     addr_end =3D src_start + len;
> > > +     while (true) {
> > > +             orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src_p=
te);
> > > +             /* Folio got pinned from under us. Put it back and fail=
 the move. */
> > > +             if (folio_maybe_dma_pinned(src_folio)) {
> > > +                     set_pte_at(mm, src_addr, src_pte, orig_src_pte)=
;
> > > +                     err =3D -EBUSY;
> > > +                     break;
> > > +             }
> > >
> > > -     orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_pte);
> > > -     /* Folio got pinned from under us. Put it back and fail the mov=
e. */
> > > -     if (folio_maybe_dma_pinned(src_folio)) {
> > > -             set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> > > -             err =3D -EBUSY;
> > > -             goto out;
> > > -     }
> > > -
> > > -     folio_move_anon_rmap(src_folio, dst_vma);
> > > -     src_folio->index =3D linear_page_index(dst_vma, dst_addr);
> > > +             folio_move_anon_rmap(src_folio, dst_vma);
> > > +             src_folio->index =3D linear_page_index(dst_vma, dst_add=
r);
> > >
> > > -     orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_prot)=
;
> > > -     /* Set soft dirty bit so userspace can notice the pte was moved=
 */
> > > +             orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_pa=
ge_prot);
> > > +             /* Set soft dirty bit so userspace can notice the pte w=
as moved */
> > >  #ifdef CONFIG_MEM_SOFT_DIRTY
> > > -     orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > > +             orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > >  #endif
> > > -     if (pte_dirty(orig_src_pte))
> > > -             orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > > -     orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > > +             if (pte_dirty(orig_src_pte))
> > > +                     orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > > +             orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > > +             set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > > +
> > > +             src_addr +=3D PAGE_SIZE;
> > > +             if (src_addr =3D=3D addr_end)
> > > +                     break;
> > > +             src_pte++;
> > > +             dst_pte++;
> > > +
> > > +             folio_unlock(src_folio);
> > > +             src_folio =3D check_ptes_for_batched_move(src_vma, src_=
addr, src_pte,
> > > +                                                     dst_pte, src_an=
on_vma);
> > > +             if (!src_folio)
> > > +                     break;
> > > +             dst_addr +=3D PAGE_SIZE;
> > > +     }
> > > +
> > > +     arch_leave_lazy_mmu_mode();
> > > +     if (src_addr > src_start)
> > > +             flush_tlb_range(src_vma, src_start, src_addr);
> > >
> > > -     set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > >  out:
> > >       double_pt_unlock(dst_ptl, src_ptl);
> > > -     return err;
> > > +     if (src_folio)
> > > +             folio_unlock(src_folio);
> > > +     return src_addr > src_start ? src_addr - src_start : err;
> > >  }
> > >
> > >  static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct=
 *dst_vma,
> > > @@ -1140,7 +1209,7 @@ static int move_swap_pte(struct mm_struct *mm, =
struct vm_area_struct *dst_vma,
> > >       set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
> > >       double_pt_unlock(dst_ptl, src_ptl);
> > >
> > > -     return 0;
> > > +     return PAGE_SIZE;
> > >  }
> > >
> > >  static int move_zeropage_pte(struct mm_struct *mm,
> > > @@ -1154,6 +1223,7 @@ static int move_zeropage_pte(struct mm_struct *=
mm,
> > >  {
> > >       pte_t zero_pte;
> > >
> > > +     flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
> >
> > If it's a zero page hence not writtable, do we still need to flush cach=
e at
> > all?  Looks harmless, but looks like not needed either.
> >
> I just realized when reading your comment that it is indeed not
> required. There is no cacheline to be flushed for the zero-page :)
>
> > >       double_pt_lock(dst_ptl, src_ptl);
> > >       if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_s=
rc_pte,
> > >                                dst_pmd, dst_pmdval)) {
> > > @@ -1167,20 +1237,19 @@ static int move_zeropage_pte(struct mm_struct=
 *mm,
> > >       set_pte_at(mm, dst_addr, dst_pte, zero_pte);
> > >       double_pt_unlock(dst_ptl, src_ptl);
> > >
> > > -     return 0;
> > > +     return PAGE_SIZE;
> > >  }
> > >
> > >
> > >  /*
> > > - * The mmap_lock for reading is held by the caller. Just move the pa=
ge
> > > - * from src_pmd to dst_pmd if possible, and return true if succeeded
> > > - * in moving the page.
> > > + * The mmap_lock for reading is held by the caller. Just move the pa=
ge(s)
> > > + * from src_pmd to dst_pmd if possible, and return number of bytes m=
oved.
> > >   */
> > > -static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_=
t *src_pmd,
> > > -                       struct vm_area_struct *dst_vma,
> > > -                       struct vm_area_struct *src_vma,
> > > -                       unsigned long dst_addr, unsigned long src_add=
r,
> > > -                       __u64 mode)
> > > +static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pm=
d_t *src_pmd,
> > > +                         struct vm_area_struct *dst_vma,
> > > +                         struct vm_area_struct *src_vma,
> > > +                         unsigned long dst_addr, unsigned long src_a=
ddr,
> > > +                         unsigned long len, __u64 mode)
> > >  {
> > >       swp_entry_t entry;
> > >       struct swap_info_struct *si =3D NULL;
> > > @@ -1196,9 +1265,8 @@ static int move_pages_pte(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd,
> > >       struct mmu_notifier_range range;
> > >       int err =3D 0;
> > >
> > > -     flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
> > >       mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
> > > -                             src_addr, src_addr + PAGE_SIZE);
> > > +                             src_addr, src_addr + len);
> > >       mmu_notifier_invalidate_range_start(&range);
> > >  retry:
> > >       /*
> > > @@ -1257,7 +1325,7 @@ static int move_pages_pte(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd,
> > >               if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
> > >                       err =3D -ENOENT;
> > >               else /* nothing to do to move a hole */
> > > -                     err =3D 0;
> > > +                     err =3D PAGE_SIZE;
> > >               goto out;
> > >       }
> > >
> > > @@ -1375,10 +1443,14 @@ static int move_pages_pte(struct mm_struct *m=
m, pmd_t *dst_pmd, pmd_t *src_pmd,
> > >                       }
> > >               }
> > >
> > > -             err =3D move_present_pte(mm,  dst_vma, src_vma,
> > > -                                    dst_addr, src_addr, dst_pte, src=
_pte,
> > > -                                    orig_dst_pte, orig_src_pte, dst_=
pmd,
> > > -                                    dst_pmdval, dst_ptl, src_ptl, sr=
c_folio);
> > > +             err =3D move_present_ptes(mm, dst_vma, src_vma,
> > > +                                     dst_addr, src_addr, dst_pte, sr=
c_pte,
> > > +                                     orig_dst_pte, orig_src_pte, dst=
_pmd,
> > > +                                     dst_pmdval, dst_ptl, src_ptl, s=
rc_folio,
> > > +                                     len, src_anon_vma);
> > > +             /* folio is already unlocked by move_present_ptes() */
> > > +             folio_put(src_folio);
> > > +             src_folio =3D NULL;
> >
> > So the function above now can move multiple folios but keep holding the
> > 1st's refcount..  This still smells error prone, sooner or later.
> >
> > Would it be slightly better if we take a folio pointer in
> > move_present_ptes(), and releae everything there (including reset the
> > pointer)?
> >
> Yeah this seems cleaner. I'll do so in the next version.
>
Uploaded v4 addressing all the comments here:
https://lore.kernel.org/all/20250810062912.1096815-1-lokeshgidra@google.com=
/

Thanks.
> > Thanks,
> >
> > >       } else {
> > >               struct folio *folio =3D NULL;
> > >
> > > @@ -1732,7 +1804,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> > >  {
> > >       struct mm_struct *mm =3D ctx->mm;
> > >       struct vm_area_struct *src_vma, *dst_vma;
> > > -     unsigned long src_addr, dst_addr;
> > > +     unsigned long src_addr, dst_addr, src_end;
> > >       pmd_t *src_pmd, *dst_pmd;
> > >       long err =3D -EINVAL;
> > >       ssize_t moved =3D 0;
> > > @@ -1775,8 +1847,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> > >       if (err)
> > >               goto out_unlock;
> > >
> > > -     for (src_addr =3D src_start, dst_addr =3D dst_start;
> > > -          src_addr < src_start + len;) {
> > > +     for (src_addr =3D src_start, dst_addr =3D dst_start, src_end =
=3D src_start + len;
> > > +          src_addr < src_end;) {
> > >               spinlock_t *ptl;
> > >               pmd_t dst_pmdval;
> > >               unsigned long step_size;
> > > @@ -1841,6 +1913,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> > >                                                 dst_addr, src_addr);
> > >                       step_size =3D HPAGE_PMD_SIZE;
> > >               } else {
> > > +                     long ret;
> > > +
> > >                       if (pmd_none(*src_pmd)) {
> > >                               if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC=
_HOLES)) {
> > >                                       err =3D -ENOENT;
> > > @@ -1857,10 +1931,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ct=
x, unsigned long dst_start,
> > >                               break;
> > >                       }
> > >
> > > -                     err =3D move_pages_pte(mm, dst_pmd, src_pmd,
> > > -                                          dst_vma, src_vma,
> > > -                                          dst_addr, src_addr, mode);
> > > -                     step_size =3D PAGE_SIZE;
> > > +                     ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> > > +                                           dst_vma, src_vma, dst_add=
r,
> > > +                                           src_addr, src_end - src_a=
ddr, mode);
> > > +                     if (ret > 0)
> > > +                             step_size =3D ret;
> > > +                     else
> > > +                             err =3D ret;
> > >               }
> > >
> > >               cond_resched();
> > >
> > > base-commit: 6e64f4580381e32c06ee146ca807c555b8f73e24
> > > --
> > > 2.50.1.565.gc32cd1483b-goog
> > >
> >
> > --
> > Peter Xu
> >

