Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A8AC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 16:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2396B0095; Fri,  8 Aug 2025 12:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879A46B0096; Fri,  8 Aug 2025 12:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F696B0099; Fri,  8 Aug 2025 12:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6526C6B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:30:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBD7D115B1F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:30:16 +0000 (UTC)
X-FDA: 83754127632.30.08AC08A
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id A5BB540004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:30:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DedCgHKf;
	spf=pass (imf27.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754670614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWV9QwkXPZK1Qghst1uCIV4QuYfeCzvomcNngf/dKhQ=;
	b=wIXQGTsNi561BsZGXyuUX6Ak0EGDv/UwI2GPWWRMNWNfQUuHdFII6pmppQKtAfsVVHZEfb
	8FOP/ngd+RU011fYKzs0wRUfCZ58ii6Qfsj4Qz8S1E9yNH0eRWOqzcE2Oar61J+zJe8zIK
	tOy09fic5hN7dJ9pVfuMmuwSqDGpdN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754670614; a=rsa-sha256;
	cv=none;
	b=nliWqn9stY6kb+NZzT1/vNpMNC+reWSvM1Gb1l/vW9TvU2EQ4kmVYVloPWILWKkmFTbu2O
	Zi8GHiCdHnMa3Wj9jxgafVsLLDLy8KsVj0+MbYpiwwOtx+bOJelb/mA3bsYUruTOW5l1RS
	s8tjf2c9a8+YOnv/4Og68F7tWKc+0Bk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DedCgHKf;
	spf=pass (imf27.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-617ff2c8e5dso63a12.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 09:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754670613; x=1755275413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWV9QwkXPZK1Qghst1uCIV4QuYfeCzvomcNngf/dKhQ=;
        b=DedCgHKft+VJh21CAv+aluYP2YDedVwmnK2ooyKjdt5ksrX5NtCasm0zphD9ePSC5P
         uSPrJ0OAyk7Ucu2J52KFlEmToPdqt3IHZpwLL0oqvoGYx0J4CWuA/rD+PTsA6mQwKUgy
         JWU6Lwh6Bhmv0YyKheG6K+RIyjdpmi44vf64dEe3dAvxB9O3wpPTRHkuvLdStMBJzgw4
         HAFoKZEbEycjv8bKf0z6FDbGa9Wa6PFm5ZsguTaRGrXa1+VMCQXqVUArcEW1+eDHrS/M
         5VDSbcx3apgquvGZSdRVHM+voO9wf/gSUQm0z02XSnxPifiyx+3g8fH5jiPRHYhpxA+L
         iSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754670613; x=1755275413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWV9QwkXPZK1Qghst1uCIV4QuYfeCzvomcNngf/dKhQ=;
        b=fA9qC4tL5XJBijabNYaTciiwJO08UiyG2rmZF6TdcBjRba6FPD/8wh0/K4Dp2rrkUa
         /CffGpZD/ld3DyHbonbCU89N0aMq3ST1j1BQLwltKHSF1IY91inSQMsq/PAwA97LterP
         x5kQazy1uI19JeeyXNqNYm8+WiQU1UIvD1ukv0eKa3NyMP6OyPrcT9dtbiaYpIglEM/A
         w0OVXVUmG2EoxuMQbLfgUFp++TpYFsHox7XvpxxlQK/MsWSCqsniLiYBeNt1DQNFTiGY
         NtbaDm6Eavqr0xTcOvUEMckDippeDclLMIpgVjghqo8u09oXOFzg5IEPStvXxiDB6AY+
         5ToQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtlFYqyncaOBmLCW+f/76W1Mlh8Lh5BWtNqclr9MnINHkB8SnphoHT/IS6ZxlixV5AWvIXS0NUHg==@kvack.org
X-Gm-Message-State: AOJu0YxUnuTea/gyu3VqxDlJFRSFgyLXa8YRiJAoHPmTvyPFnvw4EGSc
	H6hwycdTk48TjrO6pMoJLPCNkkpX8lXfvLtw/UFQky1DvnvESCvbvtkal79a3X03qCsPKdB3V9X
	uZJ2gnxvFUnvz+nfWLbi9JUHhD1nG9Y2pi4XQ3W9S
X-Gm-Gg: ASbGncu2eQoGOqGSXdUbVf9JAC2sNmrvc4sNdd8kfQo5CHRYODi8yDy/waUjUdl7MN/
	QFGrv/21qgj6EHwHHtVoMxS+sokyB63undcFp8qALlHhONZoEcsBP4F0RpYV4qfaT2shzocVIWL
	586s67L61lArxGU+w0KDOAj8LbmXOGccs9JwSqodoikhckWy5oPRApuaXhlVH3vXDFXvyruR0i5
	VoTmmMYjMlKC7Nx+cCE3/0ZacGA5RYl3HUXCmZplg==
X-Google-Smtp-Source: AGHT+IHdaRzqv6KSEiv7U1HgWpOv1AKdGvvGjyCHn8b0cDtVtz+uvaVh4JfUcQLJcE6lfwfpxVea51BO8uxympmKKog=
X-Received: by 2002:a05:6402:454c:b0:615:8f13:631c with SMTP id
 4fb4d7f45d1cf-617f97cd75dmr21044a12.6.1754670612646; Fri, 08 Aug 2025
 09:30:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250807103902.2242717-1-lokeshgidra@google.com> <aJT7qQzEs_p36yfI@x1.local>
In-Reply-To: <aJT7qQzEs_p36yfI@x1.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 8 Aug 2025 09:29:58 -0700
X-Gm-Features: Ac12FXzqRi15F68wnnO-I1R5kEwpb0zFIawNui9NvknJboGfTBscByADew0UZGU
Message-ID: <CA+EESO64MOZaJHyY_mTy6Gqvaz=CkPLHgc-UZ1rg8FXcPyh0aA@mail.gmail.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A5BB540004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: rbjnrzucm17d6ym8kozercqxc8xsihqm
X-HE-Tag: 1754670614-930582
X-HE-Meta: U2FsdGVkX1+LwHDbsBvbVjB7gDW0hhdjVf1Awk2iRKyF3Tqtqst0ElxYEQB3tNWT4ZSSCXeb8U5l03NjSexT+C5njFTvwXr2GXdCtpxpPl3Y+K9AcQZ7SwOZhmvJhpXBm1DszsNzTxytVWF9fMypfb17CWA1poCGn/k/PYsjAFUGzlkckf+bJdh7HDfimR+Di7uY08gSXR7RLXSKBVKCaOX3tUOx6toPNoQKrmMmuZcvaWYfuuaYoLrfzLnD3Rdvh9MCU2FPPUkIWowqTKNMc4V2fkDN7sWDPwdJpxPS9LCd34Wf5lh+U4eHTDPXXVWIhuMhPs6nB8K0ZOMImviIeQeny8ldyjuK5vvAhZ73ozgeDOQeS6eIUFy60d0TRwnHMPpXfHZY9UB9EtY9ReAE0zUJ///FAhwifBK/Wq+7L7aAIWLeBNXr6nwJptSQem5XqJdVXtq8BniX+bXeyIbPP/ihOvOr6ptm8P0UvFJdUEkZX0/YjAiuSOEhnX7ddge7NEkDyKgSpeMo/A/PwULWLduuJdrCEag25YgkMwmomWBw9I2lyT3OnyN+XhxuoVWSdC9JCetTVicPTd40f0GzhzBstw4LRv7RwL7KHwnX485ujV2rdw6CLj3KNQSc108fKidOx7m4pl27o6LYt+GZLnZSAEw3W7Mi3rWUUU+y8DQkCsrgDOahBRIEiEvjCXQw9JciHgGoDZhWvoAiX+UEu2jNiugxcxpwqUBmql/9Q4O0gCIW97q8T9FQGvhzP4HRYkblzN695tYK18ELMDPV29hJCbP5wT4f97ycTjS2a7rpvYcH1ujYubKyARuG/Mid3HRxKY24nO9UtMnwfZ6/h++s772Tyik6tYhLriUVnpL35Fye8oY8kar7QSb11WtE3Tz1i789TRjju11T5iax1DUSkIntqysUEiX2mrgVd2/uoW+BoBNHJZSxnlA5gwa38id1peKMMQpAFthahoB
 SzKlotTm
 0gVDoepn1q/ESXxVJV++bOtZw4EzbjUhuAwM3uQeh7HLq49zWmF+dSdHC2yHB8Aa5xfmN9Z9Bc1bAolbVCUoUignCB7xI6C6/SIcxg+zcHwJrGBon8T5HQjh3tKD4g4c6N/ZodDwCp/KuDog9cqkbNLW7H+ObMl9uor5AtjgjdkUOmcb31n4w4fAzbOJ31Fs/797P+K9wemy32oe1KheiQ6ghfPHfAUg49uDPm09oEDg8uTAoAoO1jBnlimq9PyT9+s4urUgM1ee5/+rOKiA3HyxhSJq3fEGOxApr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 12:17=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, Lokesh,
>
> On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD G=
C,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
>
> Do you know why vm_normal_folio() could be expensive? I still see quite
> some other things this path needs to do.
>
Let's discuss this in Andrew's reply thread.

> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
>
> Indeed this should already prove the optimization, I'm just curious wheth=
er
> you've run some benchmark on the GC app to show the real world benefit.
>
I did! The same benchmark through which I gathered these numbers, when
run on cuttlefish (qemu android instance on x86_64), the completion
time of the benchmark went down from ~45mins to ~20mins. The benchmark
is very GC intensive and the overhead of IPI on vCPUs seems to be
enormous leading to this drastic improvement.

In another instance, system_server, one of the most critical system
processes on android, saw over 50% reduction in GC compaction time on
an arm64 android device.

> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Barry Song <v-songbaohua@oppo.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> > Changes since v2 [1]
> > - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> > - Added check to ensure all batched pages share the same anon_vma
> >
> > Changes since v1 [2]
> > - Removed flush_tlb_batched_pending(), per Barry Song
> > - Unified single and multi page case, per Barry Song
> >
> > [1] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@go=
ogle.com/
> > [2] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@goo=
gle.com/
> >
> >  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 128 insertions(+), 51 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index cbed91b09640..78c732100aec 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *d=
st_pte, pte_t *src_pte,
> >              pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> >  }
> >
> > -static int move_present_pte(struct mm_struct *mm,
> > -                         struct vm_area_struct *dst_vma,
> > -                         struct vm_area_struct *src_vma,
> > -                         unsigned long dst_addr, unsigned long src_add=
r,
> > -                         pte_t *dst_pte, pte_t *src_pte,
> > -                         pte_t orig_dst_pte, pte_t orig_src_pte,
> > -                         pmd_t *dst_pmd, pmd_t dst_pmdval,
> > -                         spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > -                         struct folio *src_folio)
> > +/*
> > + * Checks if the two ptes and the corresponding folio are eligible for=
 batched
> > + * move. If so, then returns pointer to the folio, after locking it. O=
therwise,
> > + * returns NULL.
> > + */
> > +static struct folio *check_ptes_for_batched_move(struct vm_area_struct=
 *src_vma,
> > +                                              unsigned long src_addr,
> > +                                              pte_t *src_pte, pte_t *d=
st_pte,
> > +                                              struct anon_vma *src_ano=
n_vma)
> > +{
> > +     pte_t orig_dst_pte, orig_src_pte;
> > +     struct folio *folio;
> > +
> > +     orig_dst_pte =3D ptep_get(dst_pte);
> > +     if (!pte_none(orig_dst_pte))
> > +             return NULL;
> > +
> > +     orig_src_pte =3D ptep_get(src_pte);
> > +     if (pte_none(orig_src_pte) || !pte_present(orig_src_pte) ||
>
> pte_none() check could be removed - the pte_present() check should make
> sure it's !none.
>
Makes sense. I'll make the change in the next version of the patch.

> > +         is_zero_pfn(pte_pfn(orig_src_pte)))
> > +             return NULL;
> > +
> > +     folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > +     if (!folio || !folio_trylock(folio))
> > +             return NULL;
>
> So here we don't take a refcount anymore, while the 1st folio that got
> passed in will still has the refcount boosted.  IMHO it would still be
> better to keep the behavior the same on the 1st and continuous folios..
>
> Or if this is intentional, maybe worth some comment.  More below on this.=
.
>
This is indeed intentional, and I'll add a comment in the next
version. But let me explain:

The first folio needed the refcount as we need to pin the page before
releasing the src ptl. Also, because split_folio(), if called, expects
the caller to hold the lock as well as reference on the folio.

The subsequent folios in the batch are always within the ptl critical
section and neither the splits are required. Therefore, I didn't want
to unnecessarily increase the work done within the critical section.
But, please correct me if I'm misunderstanding something.

> > +     if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) |=
|
> > +         folio_anon_vma(folio) !=3D src_anon_vma) {
> > +             folio_unlock(folio);
> > +             return NULL;
> > +     }
> > +     return folio;
> > +}
> > +
> > +static long move_present_ptes(struct mm_struct *mm,
> > +                           struct vm_area_struct *dst_vma,
> > +                           struct vm_area_struct *src_vma,
> > +                           unsigned long dst_addr, unsigned long src_a=
ddr,
> > +                           pte_t *dst_pte, pte_t *src_pte,
> > +                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > +                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > +                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > +                           struct folio *src_folio, unsigned long len,
> > +                           struct anon_vma *src_anon_vma)
>
> (Not an immediate concern, but this function has potential to win the
>  max-num-of-parameters kernel function.. :)

I noticed the same when I made the change :) Maybe in a subsequent
patch if we inline is_pte_pages_stable() and PTL acquire/release in
move_pages_ptes(), then quite a few parameters can be reduced. But
then, IMO, even move_pages_ptes() refactoring is required as well.
>
> >  {
> >       int err =3D 0;
> > +     unsigned long src_start =3D src_addr;
> > +     unsigned long addr_end;
> >
> > +     if (len > PAGE_SIZE) {
> > +             addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > +             if (dst_addr + len > addr_end)
> > +                     len =3D addr_end - dst_addr;
>
> Use something like ALIGN() and MIN()?

Will do in the next version.
>
> > +
> > +             addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > +             if (src_addr + len > addr_end)
> > +                     len =3D addr_end - src_addr;
>
> Same here.
>
Will do.

> > +     }
> > +     flush_cache_range(src_vma, src_addr, src_addr + len);
> >       double_pt_lock(dst_ptl, src_ptl);
> >
> >       if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src=
_pte,
> > @@ -1051,31 +1097,54 @@ static int move_present_pte(struct mm_struct *m=
m,
> >               err =3D -EBUSY;
> >               goto out;
> >       }
> > +     arch_enter_lazy_mmu_mode();
> > +
> > +     addr_end =3D src_start + len;
> > +     while (true) {
> > +             orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src_pte=
);
> > +             /* Folio got pinned from under us. Put it back and fail t=
he move. */
> > +             if (folio_maybe_dma_pinned(src_folio)) {
> > +                     set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> > +                     err =3D -EBUSY;
> > +                     break;
> > +             }
> >
> > -     orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_pte);
> > -     /* Folio got pinned from under us. Put it back and fail the move.=
 */
> > -     if (folio_maybe_dma_pinned(src_folio)) {
> > -             set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> > -             err =3D -EBUSY;
> > -             goto out;
> > -     }
> > -
> > -     folio_move_anon_rmap(src_folio, dst_vma);
> > -     src_folio->index =3D linear_page_index(dst_vma, dst_addr);
> > +             folio_move_anon_rmap(src_folio, dst_vma);
> > +             src_folio->index =3D linear_page_index(dst_vma, dst_addr)=
;
> >
> > -     orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_prot);
> > -     /* Set soft dirty bit so userspace can notice the pte was moved *=
/
> > +             orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page=
_prot);
> > +             /* Set soft dirty bit so userspace can notice the pte was=
 moved */
> >  #ifdef CONFIG_MEM_SOFT_DIRTY
> > -     orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> > +             orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> >  #endif
> > -     if (pte_dirty(orig_src_pte))
> > -             orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > -     orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > +             if (pte_dirty(orig_src_pte))
> > +                     orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> > +             orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> > +             set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> > +
> > +             src_addr +=3D PAGE_SIZE;
> > +             if (src_addr =3D=3D addr_end)
> > +                     break;
> > +             src_pte++;
> > +             dst_pte++;
> > +
> > +             folio_unlock(src_folio);
> > +             src_folio =3D check_ptes_for_batched_move(src_vma, src_ad=
dr, src_pte,
> > +                                                     dst_pte, src_anon=
_vma);
> > +             if (!src_folio)
> > +                     break;
> > +             dst_addr +=3D PAGE_SIZE;
> > +     }
> > +
> > +     arch_leave_lazy_mmu_mode();
> > +     if (src_addr > src_start)
> > +             flush_tlb_range(src_vma, src_start, src_addr);
> >
> > -     set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> >  out:
> >       double_pt_unlock(dst_ptl, src_ptl);
> > -     return err;
> > +     if (src_folio)
> > +             folio_unlock(src_folio);
> > +     return src_addr > src_start ? src_addr - src_start : err;
> >  }
> >
> >  static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *=
dst_vma,
> > @@ -1140,7 +1209,7 @@ static int move_swap_pte(struct mm_struct *mm, st=
ruct vm_area_struct *dst_vma,
> >       set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
> >       double_pt_unlock(dst_ptl, src_ptl);
> >
> > -     return 0;
> > +     return PAGE_SIZE;
> >  }
> >
> >  static int move_zeropage_pte(struct mm_struct *mm,
> > @@ -1154,6 +1223,7 @@ static int move_zeropage_pte(struct mm_struct *mm=
,
> >  {
> >       pte_t zero_pte;
> >
> > +     flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
>
> If it's a zero page hence not writtable, do we still need to flush cache =
at
> all?  Looks harmless, but looks like not needed either.
>
I just realized when reading your comment that it is indeed not
required. There is no cacheline to be flushed for the zero-page :)

> >       double_pt_lock(dst_ptl, src_ptl);
> >       if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src=
_pte,
> >                                dst_pmd, dst_pmdval)) {
> > @@ -1167,20 +1237,19 @@ static int move_zeropage_pte(struct mm_struct *=
mm,
> >       set_pte_at(mm, dst_addr, dst_pte, zero_pte);
> >       double_pt_unlock(dst_ptl, src_ptl);
> >
> > -     return 0;
> > +     return PAGE_SIZE;
> >  }
> >
> >
> >  /*
> > - * The mmap_lock for reading is held by the caller. Just move the page
> > - * from src_pmd to dst_pmd if possible, and return true if succeeded
> > - * in moving the page.
> > + * The mmap_lock for reading is held by the caller. Just move the page=
(s)
> > + * from src_pmd to dst_pmd if possible, and return number of bytes mov=
ed.
> >   */
> > -static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t =
*src_pmd,
> > -                       struct vm_area_struct *dst_vma,
> > -                       struct vm_area_struct *src_vma,
> > -                       unsigned long dst_addr, unsigned long src_addr,
> > -                       __u64 mode)
> > +static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_=
t *src_pmd,
> > +                         struct vm_area_struct *dst_vma,
> > +                         struct vm_area_struct *src_vma,
> > +                         unsigned long dst_addr, unsigned long src_add=
r,
> > +                         unsigned long len, __u64 mode)
> >  {
> >       swp_entry_t entry;
> >       struct swap_info_struct *si =3D NULL;
> > @@ -1196,9 +1265,8 @@ static int move_pages_pte(struct mm_struct *mm, p=
md_t *dst_pmd, pmd_t *src_pmd,
> >       struct mmu_notifier_range range;
> >       int err =3D 0;
> >
> > -     flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
> >       mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
> > -                             src_addr, src_addr + PAGE_SIZE);
> > +                             src_addr, src_addr + len);
> >       mmu_notifier_invalidate_range_start(&range);
> >  retry:
> >       /*
> > @@ -1257,7 +1325,7 @@ static int move_pages_pte(struct mm_struct *mm, p=
md_t *dst_pmd, pmd_t *src_pmd,
> >               if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
> >                       err =3D -ENOENT;
> >               else /* nothing to do to move a hole */
> > -                     err =3D 0;
> > +                     err =3D PAGE_SIZE;
> >               goto out;
> >       }
> >
> > @@ -1375,10 +1443,14 @@ static int move_pages_pte(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd,
> >                       }
> >               }
> >
> > -             err =3D move_present_pte(mm,  dst_vma, src_vma,
> > -                                    dst_addr, src_addr, dst_pte, src_p=
te,
> > -                                    orig_dst_pte, orig_src_pte, dst_pm=
d,
> > -                                    dst_pmdval, dst_ptl, src_ptl, src_=
folio);
> > +             err =3D move_present_ptes(mm, dst_vma, src_vma,
> > +                                     dst_addr, src_addr, dst_pte, src_=
pte,
> > +                                     orig_dst_pte, orig_src_pte, dst_p=
md,
> > +                                     dst_pmdval, dst_ptl, src_ptl, src=
_folio,
> > +                                     len, src_anon_vma);
> > +             /* folio is already unlocked by move_present_ptes() */
> > +             folio_put(src_folio);
> > +             src_folio =3D NULL;
>
> So the function above now can move multiple folios but keep holding the
> 1st's refcount..  This still smells error prone, sooner or later.
>
> Would it be slightly better if we take a folio pointer in
> move_present_ptes(), and releae everything there (including reset the
> pointer)?
>
Yeah this seems cleaner. I'll do so in the next version.

> Thanks,
>
> >       } else {
> >               struct folio *folio =3D NULL;
> >
> > @@ -1732,7 +1804,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
> >  {
> >       struct mm_struct *mm =3D ctx->mm;
> >       struct vm_area_struct *src_vma, *dst_vma;
> > -     unsigned long src_addr, dst_addr;
> > +     unsigned long src_addr, dst_addr, src_end;
> >       pmd_t *src_pmd, *dst_pmd;
> >       long err =3D -EINVAL;
> >       ssize_t moved =3D 0;
> > @@ -1775,8 +1847,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
> >       if (err)
> >               goto out_unlock;
> >
> > -     for (src_addr =3D src_start, dst_addr =3D dst_start;
> > -          src_addr < src_start + len;) {
> > +     for (src_addr =3D src_start, dst_addr =3D dst_start, src_end =3D =
src_start + len;
> > +          src_addr < src_end;) {
> >               spinlock_t *ptl;
> >               pmd_t dst_pmdval;
> >               unsigned long step_size;
> > @@ -1841,6 +1913,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
> >                                                 dst_addr, src_addr);
> >                       step_size =3D HPAGE_PMD_SIZE;
> >               } else {
> > +                     long ret;
> > +
> >                       if (pmd_none(*src_pmd)) {
> >                               if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_H=
OLES)) {
> >                                       err =3D -ENOENT;
> > @@ -1857,10 +1931,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx,=
 unsigned long dst_start,
> >                               break;
> >                       }
> >
> > -                     err =3D move_pages_pte(mm, dst_pmd, src_pmd,
> > -                                          dst_vma, src_vma,
> > -                                          dst_addr, src_addr, mode);
> > -                     step_size =3D PAGE_SIZE;
> > +                     ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> > +                                           dst_vma, src_vma, dst_addr,
> > +                                           src_addr, src_end - src_add=
r, mode);
> > +                     if (ret > 0)
> > +                             step_size =3D ret;
> > +                     else
> > +                             err =3D ret;
> >               }
> >
> >               cond_resched();
> >
> > base-commit: 6e64f4580381e32c06ee146ca807c555b8f73e24
> > --
> > 2.50.1.565.gc32cd1483b-goog
> >
>
> --
> Peter Xu
>

