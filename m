Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0BDCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946C58E0152; Tue, 12 Aug 2025 11:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E7D8E00B0; Tue, 12 Aug 2025 11:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C0A8E0152; Tue, 12 Aug 2025 11:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76E8C8E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:45:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4381EB8E8C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:45:01 +0000 (UTC)
X-FDA: 83768528802.19.0033AF7
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46C7A180010
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:44:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Dk8OBr+1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755013499; a=rsa-sha256;
	cv=none;
	b=LUQoriRDMHVmPeb9c47JPYz2atTv1hiCINHIBcDBdF8NtPxDzLtwfReuEl2AKYAue9AGgb
	FaeKS7r7OsFy2ej9IOUFmu8VghhoSSq2aODPq+Efqq4Vtk17G2OLEPxOCUW5R9j7KPESbi
	rckE5D3t1Bzfk1Xwi6CmNRhS3FiY9ro=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Dk8OBr+1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755013499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsK293MmHf8pse6HN2BuJU8GIQNvtZ8jhqFCWJgRy+I=;
	b=hvOToXRehFaGwBTDrMF9IsQJd8N2WJjx2b0o29x6jYBH6A7n67rpnLiNRtyhL5qXAosgbf
	DA9hKJh59IHHckBBGZz3vqC/otY0MeResuY1eVrZ15SdpFT6pjGNeYHo/ia9LfuEIJ7KCp
	wq3+aJQTC/m5i+lU+wdv8vJ3ZOy2p6g=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-618660b684fso2325a12.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755013497; x=1755618297; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsK293MmHf8pse6HN2BuJU8GIQNvtZ8jhqFCWJgRy+I=;
        b=Dk8OBr+1TWq3C3lywVUHrJCqPsPf3J6GgbPEWlLcdkX0iAZl+Axqy1oijQpdS7Jmm+
         +NpP2y5nx25da8UPeo0+dOt/UOwcpShe/y+2ooLXeAZCGdiUiuYFslA3bsb59Lq+9UOQ
         qt52BUyZ+9WzC+RtEHLDbJNvZprxUWu2F+5rcEEwkeFJXuH7l/tiwakVK88WeTwCMaTM
         x5KL+H64wttaZVPmtKkSmLbnoHjcUrD+AJ69RyKG6eqRjMVP9jpVdOSFojCtDRr8lwmE
         TQnmhcwsqmO8zcW/0kIDDEvgDr+6LlJSzQouZCxIUkSxAwntyj4ZOasE+DpZkwb0FDrw
         e51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755013497; x=1755618297;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RsK293MmHf8pse6HN2BuJU8GIQNvtZ8jhqFCWJgRy+I=;
        b=NPGk1fTCdkcQI+lsJjijE01GEAHCRAjraElKSOzaVUV/7f3Rqwfog/7eMe7mQ53fNR
         k0lhOYDtpN3fPgZXa4HULJcl7YfsABHBz8rGBTj0/59uHR5jMhmPJ9PyDCtDisDCMd6K
         IVHw/frYk5L0pK4ZykiSytfskL1QbFc/XIYXAiojh28R0CEOzkZTcohjblbKij7T3cRp
         y79EBrKV/wFZY2oKMfYVjekxOnUmSkykRbnHkH7sYiXMmOgnugOBltiMawf/+RlFTbcs
         B2tjj1CBeLAw/N2Uq/zRo9YKWT3ENE4In0ESfmNfcy85iq+dAKTEoMlU5nF8RGHmqdf0
         e4CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLvrGmcXSsPjBiATWcFoxiwIzXSGE6utUxpFYhxDL3SzyIWv4TaKWKv7hGJF0r1VLZURL/mlzJUQ==@kvack.org
X-Gm-Message-State: AOJu0YwHhVvx1Q3DGtEWNa/XrQ3zFYiroZ7Dm7bwNH8kEneOuWLBRC5k
	+GudlzmuTMpnzUEzmRtHO0jPeY6WonItviMe2Uqpe6DdHyEsSIbK3pRZuVzuZWNWA1iHybxNWA9
	lOsh9hV3aeV8kTCscupwCR6aaCj+82HvWsTfoW2Jz
X-Gm-Gg: ASbGnct5IuZketI4tTZgpfPHxK3KckeAQu58Tq0+oUUpPmQEbgmy1DJnTbgBjv/dBPP
	TRaNGBlhKLqGJRoDA3lSbSA3yBORs7uP5uo2TUe1Fxs2hvFKz8CK0AKPY9pWM1U+gwY0H1Cl1RK
	KRzOun0VnUby00XYLlts7vtAjJt7/tLBAuYC6HoagDOIRrdmt0n9OLTsg36cIxyscdtExj1lRSS
	VZ0KsuM/qIT9Gg7qZsqlgYMhw3W3G9Z6zNrtKaa
X-Google-Smtp-Source: AGHT+IHmN1t9Ow7j1HNO/tSwEsAAgRPZFDsfEauZe3ao3LGyM8hJQlwtkpJACn0tgu3202KbNvXn1eiPTrCsNP+bcKU=
X-Received: by 2002:a50:c309:0:b0:618:527d:633d with SMTP id
 4fb4d7f45d1cf-618527d6397mr70467a12.5.1755013497120; Tue, 12 Aug 2025
 08:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com>
 <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com> <aJtTPkenKeFuFFNQ@x1.local>
In-Reply-To: <aJtTPkenKeFuFFNQ@x1.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Tue, 12 Aug 2025 08:44:44 -0700
X-Gm-Features: Ac12FXyU0NQ9L3LCZ3v7S5pHOgaGIENanOTtEMEbC_428PvXJZ_y6RAyNUzVtBo
Message-ID: <CA+EESO763JtY3jjmgGGbJjSQcnJJFNpDs2iPaUwjP44VpyyzdQ@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Peter Xu <peterx@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, aarcange@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eax5uhq18mebn57is3r93y6mi3kar9hg
X-Rspam-User: 
X-Rspamd-Queue-Id: 46C7A180010
X-Rspamd-Server: rspam02
X-HE-Tag: 1755013499-505880
X-HE-Meta: U2FsdGVkX187rDLUGY7hipIq7KwLF82U+MorRUM2hSQMMvOY4cJx6hIo3SD8mZtwXKFGD6XSBpMmQ2aaBrGn08+3ciM7j8JSZNHFZwGPp3DOTwuJteIjsVvaJme64AUbK6uIWMzb9vNZbxBf9ap2aoUgl0LYbyJ3IZS0di82Z0I/YcsM2fc6QaMQ9PKZf+f3rXTrHDU98K/+KKpoSdojsmC/1FckEOyXMFAeULaLnSloCqzskC9twoBL6Z928ROFoWNlISTjQlh95sqA67sCpHjlpHVsOBu5edWF1FmMGpk5y1OBEunNh9MzoAO5ZjxiBFWTfD2JzRmkWW9elVVuJR/td08O3xHdsIbaXc5M15+ZCX5/6nknIEcH84z4EwJX+dOUQdrjNZTi4nKqWDBeQrDhQymx0H7PAj/bWTAD6KXVcjGZ7EWVTNlWRtDzSNbI6T64cHH5y8Coc2HPjiWRqOszqchGBuybDQfBIQiXIrTlc0kvyOQutJ3c6EMfiSprYwWvMgQAUR8Dxzu1GctiIcFM6cT+CL3INB+liiSI66IfuNxNmA1FyZAyISwh9hurJARxjSJsuicLaxHmfdx7bND/j2n0k7Pil7aiJx0BAu6AcfrhZAXK6XOn4PUR/cnpKxGaJYvJpWvoN/KUXcfDAVDea6MT/tJ+VFIFaJdehZxyzmMo+xIfBvhs8e95rScMpwDEiBx0MAxnrhwvqtwQAIcsyzC8h94GTTesTJWHHWQ3ODF1bL8otfWX1yev9rplMmFQPp3M2sG9A2llidUnJhMt4RkLkFitAl0QwHkQphTaj/Yr5uUoisL44hhgaPvQVBNtlLq5xt+FgiiEWLXr41WJcvab3+hIVZf6eANwvaFJJ7Zp8f2n3MA+cdP/QqyEIFn0HAUeCae5KtN9zdwLqE/G2QAvDtUP6WwM95BSKnxVy3EAZ3QoSnaZeb/j7ZVjskrZboYdiIMmwdG6KQE
 Vzo4+fAt
 b9srM7qWD9txQ3XeQe+mue9AQFRlJFYCP86mfen33sEF1jzFTPHPmuY70aWeTT1lh9u9wahN9YPKCksFalGJ3CnLhS1ojSwdneNGv4YI8AY83BgRyRVrufC1+q0BBR+9ZWQVvDNzFmISXqn5YCMqPSlxYOEL9klnnVhtytRrwxxvRTkpoWjjQEe0YcyYe+j838Y7YuP3jyZ73+r1zsbLUTlKU02MeNo3CKKbWJmJTapkpX+Ar14zhz+DTwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 7:44=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Aug 11, 2025 at 11:55:36AM +0800, Barry Song wrote:
> > Hi Lokesh,
> >
> >
> > On Sun, Aug 10, 2025 at 2:29=E2=80=AFPM Lokesh Gidra <lokeshgidra@googl=
e.com> wrote:
> > >
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
> > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > includes TLB-flush overhead.
> > >
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > ---
> > > Changes since v3 [1]
> > > - Fix unintialized 'step_size' warning, per Dan Carpenter
> > > - Removed pmd_none() from check_ptes_for_batched_move(), per Peter Xu
> > > - Removed flush_cache_range() in zero-page case, per Peter Xu
> > > - Added comment to explain why folio reference for batched pages is n=
ot
> > >   required, per Peter Xu
> > > - Use MIN() in calculation of largest extent that can be batched unde=
r
> > >   the same src and dst PTLs, per Peter Xu
> > > - Release first folio's reference in move_present_ptes(), per Peter X=
u
> > >
> > > Changes since v2 [2]
> > > - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> > > - Added check to ensure all batched pages share the same anon_vma
> > >
> > > Changes since v1 [3]
> > > - Removed flush_tlb_batched_pending(), per Barry Song
> > > - Unified single and multi page case, per Barry Song
> > >
> > > [1] https://lore.kernel.org/all/20250807103902.2242717-1-lokeshgidra@=
google.com/
> > > [2] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@=
google.com/
> > > [3] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@g=
oogle.com/
> > >
> > >  mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++------------=
--
> > >  1 file changed, 127 insertions(+), 51 deletions(-)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index cbed91b09640..39d81d2972db 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t =
*dst_pte, pte_t *src_pte,
> > >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> > >  }
> > >
> > > -static int move_present_pte(struct mm_struct *mm,
> > > -                           struct vm_area_struct *dst_vma,
> > > -                           struct vm_area_struct *src_vma,
> > > -                           unsigned long dst_addr, unsigned long src=
_addr,
> > > -                           pte_t *dst_pte, pte_t *src_pte,
> > > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > -                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > > -                           struct folio *src_folio)
> > > +/*
> > > + * Checks if the two ptes and the corresponding folio are eligible f=
or batched
> > > + * move. If so, then returns pointer to the locked folio. Otherwise,=
 returns NULL.
> > > + *
> > > + * NOTE: folio's reference is not required as the whole operation is=
 within
> > > + * PTL's critical section.
> > > + */
> > > +static struct folio *check_ptes_for_batched_move(struct vm_area_stru=
ct *src_vma,
> > > +                                                unsigned long src_ad=
dr,
> > > +                                                pte_t *src_pte, pte_=
t *dst_pte,
> > > +                                                struct anon_vma *src=
_anon_vma)
> > > +{
> > > +       pte_t orig_dst_pte, orig_src_pte;
> > > +       struct folio *folio;
> > > +
> > > +       orig_dst_pte =3D ptep_get(dst_pte);
> > > +       if (!pte_none(orig_dst_pte))
> > > +               return NULL;
> > > +
> > > +       orig_src_pte =3D ptep_get(src_pte);
> > > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_sr=
c_pte)))
> > > +               return NULL;
> > > +
> > > +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > > +       if (!folio || !folio_trylock(folio))
> > > +               return NULL;
> > > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(foli=
o) ||
> > > +           folio_anon_vma(folio) !=3D src_anon_vma) {
> > > +               folio_unlock(folio);
> > > +               return NULL;
> > > +       }
> > > +       return folio;
> > > +}
> > > +
> >
> > I=E2=80=99m still quite confused by the code. Before move_present_ptes(=
), we=E2=80=99ve
> > already performed all the checks=E2=80=94pte_same(), vm_normal_folio(),
> > folio_trylock(), folio_test_large(), folio_get_anon_vma(),
> > and anon_vma_lock_write()=E2=80=94at least for the first PTE. Now we=E2=
=80=99re
> > duplicating them again for all PTEs. Does this mean we=E2=80=99re doing=
 those
> > operations for the first PTE twice? It feels like the old non-batch che=
ck
> > code should be removed?
>
> This function should only start to work on the 2nd (or more) continuous
> ptes to move within the same pgtable lock held.  We'll still need the
> original path because that was sleepable, this one isn't, and it's only
> best-effort fast path only. E.g. if trylock() fails above, it would
> fallback to the slow path.
>
Thanks Peter. I was about to give exactly the same reasoning :)
> >
> > > +static long move_present_ptes(struct mm_struct *mm,
> > > +                             struct vm_area_struct *dst_vma,
> > > +                             struct vm_area_struct *src_vma,
> > > +                             unsigned long dst_addr, unsigned long s=
rc_addr,
> > > +                             pte_t *dst_pte, pte_t *src_pte,
> > > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > +                             spinlock_t *dst_ptl, spinlock_t *src_pt=
l,
> > > +                             struct folio **first_src_folio, unsigne=
d long len,
> > > +                             struct anon_vma *src_anon_vma)
> > >  {
> > >         int err =3D 0;
> > > +       struct folio *src_folio =3D *first_src_folio;
> > > +       unsigned long src_start =3D src_addr;
> > > +       unsigned long addr_end;
> > > +
> > > +       if (len > PAGE_SIZE) {
> > > +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> > > +               len =3D MIN(addr_end - dst_addr, len);
> > >
> > > +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> > > +               len =3D MIN(addr_end - src_addr, len);
> > > +       }
> >
> > We already have a pmd_addr_end() helper=E2=80=94can we reuse it?
>
> I agree with Barry; I wante to say this version didn't use ALIGN() that I
> suggested but pmd_addr_end() looks better.

ALIGN() couldn't be used as we are calculating "how many bytes to the
next PMD" and not just align it. Anyways, pmd_addr_end() is definitely
better. Will do it in the next patch.
>
> Other than that this version looks good to me (plus the higher level
> performance results updated to the commit message, per requested in v3),
> thanks Lokesh.

Thanks Peter. I'll update the commit message in v5.
>
> --
> Peter Xu
>

