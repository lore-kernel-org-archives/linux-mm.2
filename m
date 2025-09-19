Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACB1CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 06:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EE628000F; Fri, 19 Sep 2025 02:31:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F614940009; Fri, 19 Sep 2025 02:31:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C0F28000F; Fri, 19 Sep 2025 02:31:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297F9940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:31:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC6A5597CD
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:31:04 +0000 (UTC)
X-FDA: 83905027248.21.ED45FEC
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id CDBCA1C000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:31:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=w7h8KWZz;
	spf=pass (imf18.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758263463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06eCENoQeXcRvzCWhgnDcxDuvj+0/jcxqcFbXPfuQm4=;
	b=sW1/BFQfd9GhT0SL1runUwMxnGUOrU7eW1U3cbum+lXDhmYlRrTYfR/nqTQeLxqW66AJWn
	otjdItEWIGCRTMoY/51W8PmB2HTyFLXY20pnb8nU/HnbRtbK5pf70czwcF+KaDLxkBkqLR
	SGCS6EubdL/mZ5RcCynMsplop8jnV/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758263463; a=rsa-sha256;
	cv=none;
	b=s05dcgwwpJ8ouvyJdchOkJKGhS+Yg9k+dmVqz8SlII2LKbq/6MfS9yZ4nvYgmAy75kQowF
	SM/i9JfQ+coqaG6EogyQKmCoIFZrhu7bnf0rr3djZ2rEhifMIbtphyfk5+UG8EHV/8p+vb
	+bsCzZzIbkkbnWq5AQkrfiGkAIJCqC0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=w7h8KWZz;
	spf=pass (imf18.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-62efe182eb8so8990a12.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758263461; x=1758868261; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06eCENoQeXcRvzCWhgnDcxDuvj+0/jcxqcFbXPfuQm4=;
        b=w7h8KWZzvmj9Ao3ytOUt2i4tW4uxFNxm5DkHFh5qTYBCAiADaw4/RGUJxa0REHUGb1
         HKUD80KZQ1VwcONJX+7JR1a+P2qgIGHjjTm/OV7iy5/Xfm2XVOyddWnBzyWi6jUgpGo/
         7OKxtZfCAT8O/0FnAUaujgn9dG6yJjVPMTEsqLXQ22/+832Y4cQwEjYU5W/7pi8uL7lo
         4FxnfdK0b+fOZzIu8tIIMfJ9f1JBUkubiBDJPXN9XFoUQnljz/06JLey7mOoUA1dQJ3h
         Ga0DbN4F4ZCNm/1B9HMSgZ1IRuTESuDuKCwdLZflLWGAMKbCZEDzilrAducFzkyKR0wE
         +ZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758263461; x=1758868261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06eCENoQeXcRvzCWhgnDcxDuvj+0/jcxqcFbXPfuQm4=;
        b=fcs8BWFFetngdt0/BqgwlKq/fkFAe0G/G84C/PsH1uIQpnEP5Fi2zKzUeLsBPhW8dS
         kXhA+P5/tuqqnur9sfFxWe9yfm60xi0WzmD9qJTaLoxvrg+XXAcZqDbldfn7s5aqt+Dn
         gyDJCVnOJ6hXGe0TdnX1wkMsFXFzSewllVoBHKetx6JScHCUfpPS/wQE4yVTPkdoS5jl
         qmLxZ28cmW4sFNrtNCwBFeu85AOCFFnwoBt3InHz6ZpJ/+6dAp7d6IgPVH9Zn/eQRwWb
         Pk9sw4B86a1EWc0ilTlLBHDbLhJpcgznhXKk7za18ba5IO1zgneAIurtVVUYE3zzy2B1
         ct4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQKAI4m1Y4PQhsLMsxSwIlftnzNSI7UBrZJJG50Q7lrwjsDG4auhbkrzvNlSkQ5RquU8EMHhjR2Q==@kvack.org
X-Gm-Message-State: AOJu0YyJ65arjj5Za21SVUX43zsPR0QyBdBHP/IcRkIlAKdx9AvBqUFD
	7b3IXaiXDFNYBJyWjBwIVz56mxNt126mTFYk740AbOGltB6Suqq7rOiNL+GqUG6kvhDh3jCJ0Ru
	oqY8+OgASh5xzKA+VibafMAtZNl7nFFOcuozPk2EQ
X-Gm-Gg: ASbGncvD1hw8k4dLdHoi/8cLxqbsB5Fv/OiBE59e4MSr98MwCD7AlyE2Irs46FykW6v
	qi0gyYZ2YuBPQs62ZMoGPOdX88Qj6wlJcDbhZOD8y7KtcRf7/G33vqivaa5A1nxuUNrZMVhR4r0
	lZUVtWnv3VZJWo7bDeUHdOKYAQUq5mFRXlUI56MnEQYrIZJTbggJFDnm1aAOuWIFAes8e2Kp8O4
	UkHww81Yzt6kRFTF5dX6aA2nB8qrozydg3iGExEQhaRng==
X-Google-Smtp-Source: AGHT+IHBFf4W+Jt0eC88FFrleKI6p4GPsAdxkrBPkxd51uqOZL/IYVgW6jk+KQl9v18M3NDmvtNsRyaxDkKUEyinqO0=
X-Received: by 2002:a50:a699:0:b0:62f:bc3f:94de with SMTP id
 4fb4d7f45d1cf-62fbc3f9752mr80189a12.7.1758263460972; Thu, 18 Sep 2025
 23:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-3-lokeshgidra@google.com> <4e4bee5c-c2d9-4467-b7b8-d3586a5cd6e4@lucifer.local>
In-Reply-To: <4e4bee5c-c2d9-4467-b7b8-d3586a5cd6e4@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 18 Sep 2025 23:30:48 -0700
X-Gm-Features: AS18NWCgXl9oozL9OG_svyATYsrSPxJ6tFRrhrIdNJEzjcA71k9dHet8kka3SWg
Message-ID: <CA+EESO6B04FQ9pxmf6n1Up+r-a4yGYO6N_HakiYj0hLVvhs2ig@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, David Hildenbrand <david@redhat.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDBCA1C000F
X-Stat-Signature: kdtkzickt6yhi7k3zbit1r6exsrgmedg
X-Rspam-User: 
X-HE-Tag: 1758263462-795310
X-HE-Meta: U2FsdGVkX19zPBxbeLDlxdgn1hzTUbn1XRx0U5eNPI3VTk57PNz0TUA2vXqgNsq0iu67qoqvmS96MxOIuHL9lIEmRRUa+jn3HQFt3ERfR97omH4TnSH2/FJHwZMNVhqzNo60ye+LyyOuaN3KwKQOVRIkrl1zcGix0xEoZ6nk7mH8CwKZMVXqQj6DgfAnnn4tKeP3Mz/N3b4r6vedx5KKVt0zgW5SbiM8j0gUdM8bGcjF3cTrXmT95VAkIPYSqsUOq1UqCPnsk+B4VCiStxNix4EmsQlorwnsHoJrT+f+i/xe6joP0/3bgRX3dIxCQJHvvKaCdWpeiNODuJzzWfmn0YXQPYUc0q/3/5qmODThzsVdxyEiE1eOCdPQZ2Dz7rH+J+mpJp/LeXEfCWLqKeN60ZChlB0am8H+EW0rSTs9QVPtikX4S7HoSRvog+qD3Qp6fJcLmADt9u2WBcBGZW9rDxPsAHQ4JhMVIO9S0yhpi12obhh4kgczvICfl1gR8xky9GL0GIH1rfNpbZjpyn2fwIMvh4rwoHuP/GTaXanPywPNuSTxJsU3McH3Q9NaMew6ScrJZ/X6vSc0lYMwQ1sTkUMPXPao1x2/UduDr1lHNqbh7IWhRnhZGDGj6qvGVhKWqxAlZGLZZ4njaMuUA4WskR1JlY5o6AJyZDYLCKeiFPNCkvc/2MiCFyRnnCIDPo+/jAC4U6ztj1Xx+YWCmnJWa43afAheA3fKwAnb2Z6mcojz+pfFqTdibvvEdT91rI9huLEkS1Y48W2Aeqw+x5qg/Ynakgwr6+JbKMmvf1VvMkQDA8Kjetp4v7e6n39HkSfi3lHu1enH/fpWPqW0WBhpB0ItIZTaNXHI92G/EXZFm2nPkf6ZCiFKdhAhXrefE5Dgb/lzGWZGWgVgYDLU0zLn7SluncNKTlRQVdLd8M1BkP4C2xUBbkOv9Y8p79ao2em4mEkb3MAYcbX00KLm5KG
 soq4ToR2
 sWe5zeZt+WW1bg6sUMSlx13cK4ayNvjh70R7P2JQJWIU1nyX5ZpWP9uNcTn1t26CkndJnD2Y1A72H/o1bmnUUMik3s+N98Eoim9BnY2y8x1kBLcOBIgMANo1aQnjIFjusoV3pqR1cJwznQwEXh1RhsCtwISMEW+zMSAZH/eVC2ZbY0bIox9vXkPdujSKjpvTUf+LlymX3HaxcR11aK056i996TQ+kl++xc+81OxwEwk5g8VM3ZSa4o8K44kpMO/aT9ihqLWvnwDDS0HA1Uo6ahzDCEysKu7PQdJAbzrtpNj/N1kfbmBvhsAX5F/dBYFxqi7M3AtApaFQiR2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 5:38=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 17, 2025 at 10:51:35PM -0700, Lokesh Gidra wrote:
> > Now that rmap_walk() is guaranteed to be called with the folio lock
> > held, we can stop serializing on the src VMA anon_vma lock when moving
> > an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.
> >
> > When moving a folio, we modify folio->mapping through
> > folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
> > while we could have concurrent RMAP walks would be dangerous. Therefore=
,
> > to avoid that, we had to acquire anon_vma of src VMA in write-mode. Tha=
t
> > meant that when multiple threads called UFFDIO_MOVE concurrently on
> > distinct pages of the same src VMA, they would serialize on it, hurting
> > scalability.
> >
> > In addition to avoiding the scalability bottleneck, this patch also
> > simplifies the complicated lock dance that UFFDIO_MOVE has to go throug=
h
> > between RCU, folio-lock, ptl, and anon_vma.
> >
> > folio_move_anon_rmap() already enforces that the folio is locked. So
> > when we have the folio locked we can no longer race with concurrent
> > rmap_walk() as used by folio_referenced() and hence the anon_vma lock
>
> And other rmap callers right?
Right. Will fix it in the next version.
>
> > is no longer required.
> >
> > Note that this handling is now the same as for other
> > folio_move_anon_rmap() users that also do not hold the anon_vma lock --
> > namely COW reuse handling. These users never required the anon_vma lock
> > as they are only moving the anon VMA closer to the anon_vma leaf of the
> > VMA, for example, from an anon_vma root to a leaf of that root. rmap
> > walks were always able to tolerate that scenario.
>
> Which users?

The COW reusers, namely:
do_wp_page()->wp_can_reuse_anon_folio()
do_huge_pmd_wp_page()
hugetlb_wp()

>
> >
> > CC: David Hildenbrand <david@redhat.com>
> > CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > CC: Peter Xu <peterx@redhat.com>
> > CC: Suren Baghdasaryan <surenb@google.com>
> > CC: Barry Song <baohua@kernel.org>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> >  mm/huge_memory.c | 22 +----------------
> >  mm/userfaultfd.c | 62 +++++++++---------------------------------------
> >  2 files changed, 12 insertions(+), 72 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 5acca24bbabb..f444c142a8be 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd=
_t *dst_pmd, pmd_t *src_pmd, pm
> >       pmd_t _dst_pmd, src_pmdval;
> >       struct page *src_page;
> >       struct folio *src_folio;
> > -     struct anon_vma *src_anon_vma;
> >       spinlock_t *src_ptl, *dst_ptl;
> >       pgtable_t src_pgtable;
> >       struct mmu_notifier_range range;
> > @@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pm=
d_t *dst_pmd, pmd_t *src_pmd, pm
> >                               src_addr + HPAGE_PMD_SIZE);
> >       mmu_notifier_invalidate_range_start(&range);
> >
> > -     if (src_folio) {
> > +     if (src_folio)
> >               folio_lock(src_folio);
> >
> > -             /*
> > -              * split_huge_page walks the anon_vma chain without the p=
age
> > -              * lock. Serialize against it with the anon_vma lock, the=
 page
> > -              * lock is not enough.
> > -              */
> > -             src_anon_vma =3D folio_get_anon_vma(src_folio);
> > -             if (!src_anon_vma) {
> > -                     err =3D -EAGAIN;
> > -                     goto unlock_folio;
> > -             }
> > -             anon_vma_lock_write(src_anon_vma);
> > -     } else
> > -             src_anon_vma =3D NULL;
> > -
>
> Hmm this seems an odd thing to include in the uffd change. Why not just i=
nclude
> it in the last commit or as a separate commit?

I'm not sure I follow. What am I including here?

BTW, IMHO, the comment is wrong here. folio split code already
acquires folio lock. The anon_vma lock is required here for the same
reason as non-large page case - to avoid concurrent rmap walks.
>
> >       dst_ptl =3D pmd_lockptr(mm, dst_pmd);
> >       double_pt_lock(src_ptl, dst_ptl);
> >       if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
> > @@ -2643,11 +2628,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pm=
d_t *dst_pmd, pmd_t *src_pmd, pm
> >       pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
> >  unlock_ptls:
> >       double_pt_unlock(src_ptl, dst_ptl);
> > -     if (src_anon_vma) {
> > -             anon_vma_unlock_write(src_anon_vma);
> > -             put_anon_vma(src_anon_vma);
> > -     }
> > -unlock_folio:
> >       /* unblock rmap walks */
> >       if (src_folio)
> >               folio_unlock(src_folio);
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index af61b95c89e4..6be65089085e 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1035,8 +1035,7 @@ static inline bool is_pte_pages_stable(pte_t *dst=
_pte, pte_t *src_pte,
> >   */
> >  static struct folio *check_ptes_for_batched_move(struct vm_area_struct=
 *src_vma,
> >                                                unsigned long src_addr,
> > -                                              pte_t *src_pte, pte_t *d=
st_pte,
> > -                                              struct anon_vma *src_ano=
n_vma)
> > +                                              pte_t *src_pte, pte_t *d=
st_pte)
> >  {
> >       pte_t orig_dst_pte, orig_src_pte;
> >       struct folio *folio;
> > @@ -1052,8 +1051,7 @@ static struct folio *check_ptes_for_batched_move(=
struct vm_area_struct *src_vma,
> >       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> >       if (!folio || !folio_trylock(folio))
> >               return NULL;
> > -     if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) |=
|
> > -         folio_anon_vma(folio) !=3D src_anon_vma) {
> > +     if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) =
{
> >               folio_unlock(folio);
> >               return NULL;
> >       }
>
> It's good to unwind this obviously, though god I hate all these open code=
d checks.
>
> Let me also rant about how we seem to duplicate half of mm in uffd
> code. Yuck. This is really not how this should have been done AT ALL.
>
> > @@ -1061,9 +1059,8 @@ static struct folio *check_ptes_for_batched_move(=
struct vm_area_struct *src_vma,
> >  }
> >
> >  /*
> > - * Moves src folios to dst in a batch as long as they share the same
> > - * anon_vma as the first folio, are not large, and can successfully
> > - * take the lock via folio_trylock().
> > + * Moves src folios to dst in a batch as long as they are not large, a=
nd can
> > + * successfully take the lock via folio_trylock().
> >   */
> >  static long move_present_ptes(struct mm_struct *mm,
> >                             struct vm_area_struct *dst_vma,
> > @@ -1073,8 +1070,7 @@ static long move_present_ptes(struct mm_struct *m=
m,
> >                             pte_t orig_dst_pte, pte_t orig_src_pte,
> >                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> >                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > -                           struct folio **first_src_folio, unsigned lo=
ng len,
> > -                           struct anon_vma *src_anon_vma)
> > +                           struct folio **first_src_folio, unsigned lo=
ng len)
> >  {
> >       int err =3D 0;
> >       struct folio *src_folio =3D *first_src_folio;
> > @@ -1132,8 +1128,8 @@ static long move_present_ptes(struct mm_struct *m=
m,
> >               src_pte++;
> >
> >               folio_unlock(src_folio);
> > -             src_folio =3D check_ptes_for_batched_move(src_vma, src_ad=
dr, src_pte,
> > -                                                     dst_pte, src_anon=
_vma);
> > +             src_folio =3D check_ptes_for_batched_move(src_vma, src_ad=
dr,
> > +                                                     src_pte, dst_pte)=
;
> >               if (!src_folio)
> >                       break;
> >       }
> > @@ -1263,7 +1259,6 @@ static long move_pages_ptes(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd
> >       pmd_t dummy_pmdval;
> >       pmd_t dst_pmdval;
> >       struct folio *src_folio =3D NULL;
> > -     struct anon_vma *src_anon_vma =3D NULL;
> >       struct mmu_notifier_range range;
> >       long ret =3D 0;
> >
> > @@ -1347,9 +1342,9 @@ static long move_pages_ptes(struct mm_struct *mm,=
 pmd_t *dst_pmd, pmd_t *src_pmd
> >               }
> >
> >               /*
> > -              * Pin and lock both source folio and anon_vma. Since we =
are in
> > -              * RCU read section, we can't block, so on contention hav=
e to
> > -              * unmap the ptes, obtain the lock and retry.
> > +              * Pin and lock source folio. Since we are in RCU read se=
ction,
> > +              * we can't block, so on contention have to unmap the pte=
s,
> > +              * obtain the lock and retry.
>
> Not sure what pinning the anon_vma meant anyway :)
>
> >                */
> >               if (!src_folio) {
> >                       struct folio *folio;
> > @@ -1423,33 +1418,11 @@ static long move_pages_ptes(struct mm_struct *m=
m, pmd_t *dst_pmd, pmd_t *src_pmd
> >                       goto retry;
> >               }
> >
> > -             if (!src_anon_vma) {
> > -                     /*
> > -                      * folio_referenced walks the anon_vma chain
> > -                      * without the folio lock. Serialize against it w=
ith
> > -                      * the anon_vma lock, the folio lock is not enoug=
h.
> > -                      */
> > -                     src_anon_vma =3D folio_get_anon_vma(src_folio);
> > -                     if (!src_anon_vma) {
> > -                             /* page was unmapped from under us */
> > -                             ret =3D -EAGAIN;
> > -                             goto out;
> > -                     }
> > -                     if (!anon_vma_trylock_write(src_anon_vma)) {
> > -                             pte_unmap(src_pte);
> > -                             pte_unmap(dst_pte);
> > -                             src_pte =3D dst_pte =3D NULL;
> > -                             /* now we can block and wait */
> > -                             anon_vma_lock_write(src_anon_vma);
> > -                             goto retry;
> > -                     }
> > -             }
> > -
> >               ret =3D move_present_ptes(mm, dst_vma, src_vma,
> >                                       dst_addr, src_addr, dst_pte, src_=
pte,
> >                                       orig_dst_pte, orig_src_pte, dst_p=
md,
> >                                       dst_pmdval, dst_ptl, src_ptl, &sr=
c_folio,
> > -                                     len, src_anon_vma);
> > +                                     len);
> >       } else {
> >               struct folio *folio =3D NULL;
> >
> > @@ -1515,10 +1488,6 @@ static long move_pages_ptes(struct mm_struct *mm=
, pmd_t *dst_pmd, pmd_t *src_pmd
> >       }
> >
> >  out:
> > -     if (src_anon_vma) {
> > -             anon_vma_unlock_write(src_anon_vma);
> > -             put_anon_vma(src_anon_vma);
> > -     }
> >       if (src_folio) {
> >               folio_unlock(src_folio);
> >               folio_put(src_folio);
> > @@ -1792,15 +1761,6 @@ static void uffd_move_unlock(struct vm_area_stru=
ct *dst_vma,
> >   * virtual regions without knowing if there are transparent hugepage
> >   * in the regions or not, but preventing the risk of having to split
> >   * the hugepmd during the remap.
> > - *
> > - * If there's any rmap walk that is taking the anon_vma locks without
> > - * first obtaining the folio lock (the only current instance is
> > - * folio_referenced), they will have to verify if the folio->mapping
> > - * has changed after taking the anon_vma lock. If it changed they
> > - * should release the lock and retry obtaining a new anon_vma, because
> > - * it means the anon_vma was changed by move_pages() before the lock
> > - * could be obtained. This is the only additional complexity added to
> > - * the rmap code to provide this anonymous page remapping functionalit=
y.
> >   */
> >  ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_star=
t,
> >                  unsigned long src_start, unsigned long len, __u64 mode=
)
> > --
> > 2.51.0.384.g4c02a37b29-goog
> >
> >
>
> Rest of logic looks OK to me!

