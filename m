Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72041606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B0I5l02K
Received: by kanga.kvack.org (Postfix)
	id 8376F6B0879; Tue, 27 Oct 2026 13:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80EE16B087B; Tue, 27 Oct 2026 13:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E376B087C; Tue, 27 Oct 2026 13:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AFAF6B0879
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:49:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D57BA160ADF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:49:05 +0000 (UTC)
X-FDA: 85369142250.23.A0AF3C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 200451C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:49:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0I5l02K;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793123344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKKkLGPvy7oc9Cj7oiHBn7WJYL3F1vQJtw5e9araRYA=;
	b=CekWj+pfWPf2r7su5jceRQpaY4dSSVrEErli0TuNUlDktyaHwdXTurgLvxYB1L/NBLEJlU
	KG5rJ8NN7eNajY6e+boHEuLMANtZ2KIUmTZi3yg3f+jLeCPdK7BQlAoNe+1oKPnXj6MY0B
	4w6Zgs6cVcXobnd5rHt4wd84yGuH+5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793123344;
	b=1luboPineXcOAjb2lM54GBOnDvft8kzS9csOuHSQuenJo0zIHP+aM7DsLuN8MvyZlKc9Jo
	RKWYK1GVa++glL/ap1O1Huvu0m2plA5S2SPM1H5eegWIP+gKUbLQ/F+GKAAmv7cv22Q/tY
	FAGbQnWVi1iFyipnx5XtbtBRzao81fk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0I5l02K;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47A5943A8B;
	Tue, 27 Oct 2026 17:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4131F01828;
	Tue, 27 Oct 2026 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793123343;
	bh=oKKkLGPvy7oc9Cj7oiHBn7WJYL3F1vQJtw5e9araRYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B0I5l02KTGM/aT2NqPpE5PbeJiJ01nypwLlxR9g+urCcjWDkTQRH5b9WLq+xorRHu
	 gaHVsq+vWVVMMVgZJj99P7VPUK56MX+SN5GmhJeNjFsPHBhIfOxQxTHwfg8Yl55QBo
	 h2+L7k6uI8QSS0xnmDEwj1elvxOzwFVUmYIy2Z3V5FQ6jl7won1m4EuaQPtTHj+P6r
	 QKvr8WKDY3sWTZY8M7J0IgM6r+wZtuZ6OJmUoZFNowvnukVmofi17p6T84GYeCEfdh
	 y1I8cpLTJP+bHaVGZHux+dq7p9gdyGATdM7FGfT81kBiDIHHxo/fuqdDZDS0KSVFCy
	 fYw0ZMg7MIAXg==
Date: Tue, 27 Oct 2026 17:48:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, SJ Park <sj@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH v2] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
Message-ID: <auDEn8GmB0H7zj99@gremlin>
References: <20261027-fix-proc-pid-maps-missing-vmas-v2-1-2791cc9fc95f@kernel.org>
 <CAJuCfpELhxhyVQANspX14OBLbghiAqndYcfv1hnmh4Nvo=1vAQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpELhxhyVQANspX14OBLbghiAqndYcfv1hnmh4Nvo=1vAQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 200451C0005
X-Stat-Signature: jhgywwfr8yzw9z5goq8mhz9rq3smpype
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793123343-416968
X-HE-Meta: U2FsdGVkX18DzBupWL1NaN6QUf38TSWJ/UnwRo7xHaVwLXIOYpWdt65CIoe43LnwXAi4kPvlgjFbCCldpD3mLer+ssc9OUO1J7YgObO4nifRc7BlXGFj0IBaGwIDndWcm7GNbLByFlCKpHWa/wEze8LvzSbT99/bw+eyGsAong5uUkaD/aPH0/Ao/NVp3XZEy3xE8NjngjughjJImojcSTtD45N2ZqLUqRnvGcFWsFcn35DBkVnkArPzqwiFABDIc3nmc74fodLj8WB5PByod+o15Zl8oGqes/1Ds0QBle4FfF5AnIf0/JYoUVeWRML8Xb6Ax2ikfwCVmmyh2efO+GdQUN879O2OOfjVssIINIwAQ1dqvEWNkjZPp+VQZ0FIicg16eaF/IoGhCiF8Bf2Rjj1IZVbtEG3cFrOrGCcGnsRRJpao80aqGKdATSajfA5rDZzbEu3kX+/HqoBeeD0erXzqHNYLpNgc+UnDorwNR47yt22N9NdKAO1q0U/fzH7QWeCLz2c/RQWemg0Gmc8Ww5R+GPg77Zt6+hFlFXVulqnZk9T/fUi3nLmZyiUb4urnhtMP8JrLxeDeLDeuuENmcgMoGS01u7y+6udphp7up/eVqzf24pCUwmfs8ilZOuBsfG9k5wj3tAL2/WgNxkXP1GE7kGulqIa1bi7qG84e+p2v43JHNFdS2vwP25MSgM/vdm8r9FX9VE5RfbPtQSPkVMrd3j70lt8TFuqt5kE29rVjbctI8hbBy1mFePmN7b+MdhX3anzMwN2IzdeAnFJwEJAMUvGAs3koP1YM+kQrI5kzj9cBq6kzioxkDEO4egPYW8rppLy2NJa9KUWsxZRxxvL7hbvU78ZucFpuxY8sHlN8rCs/jStTT2zc9Nabgm9ION+3wOfZrh0UrVZWmWsg9M4kDGk+Z7HZBBZXORbXsnTJyVd64VM1t39WGUmlK2wO8ljGXWyg/QzjH/9RML
 dzcWccpI
 FPONzDWJ6zt47HHcrJ+7B3TDU4VNF/+uTD8i/pF3stuHy8mgHEtxE8QU5MIiYe+AEhOnIDKyGcMJy1WHjevMyuNZUPnHFYbcd6bs0ROM8sQULgLbdZad9vFzYOrCO5UNwFl6IGrHP0nkscMgFCWWk4hTrMDjGJ0dYgP/15kCW+sfFajxWhYCgZGFYZRMTaPNfZpg+IydYEryJyaJjGB57NfWJy91JGH6YrzqfBqmjdFjbTbqKYrFrUUFqYheMxNOUfosyq2MgK6CzKpLOYa+ijCtdhc0nMlALlFfNA3B1WmCHNjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 08:34:10AM -0700, Suren Baghdasaryan wrote:
> Overall the code looks correct bit I have a couple of questions below.

Thanks!

>
> > ---
> > Note that I decided it's best to defer any VMA iterator stuff to a
> > follow-up - with the abstractions added it's clear what's going on and
> > easier for backporting.
>
> Ok. But once we get VMA iterator validation routine implemented, we
> won't need vma_rcu_iter and its helpers, I think. Are you ok with the
> fact that most of this change will have to be removed later?

No, I don't think this is correct.

The iterator can't validate itself - the failure case is invisible to it,
something changed in the tree and it has no way of knowing, it has to be
prompted to re-init etc.

I tried a version of the code with vma_iter_next_before() and it really didn't
provide much delta.

So I think any version of this has to have the rvmi stuff.

In any case, I am happy to replace all this with whatever makes most sense
going forwards.

Key here is to fix the bug + get it backported :) [ before moving on to the
N other AI-reported bugs ;) ]

> > +static inline void vma_rcu_iter_init(struct vma_rcu_iter *rvmi,
> > +               struct mm_struct *mm, struct vma_iterator *vmi,
> > +               unsigned long addr)
> > +{
> > +       vma_iter_init(vmi, mm, addr);
> > +       rvmi->mm = mm;
> > +       rvmi->vmi = vmi;
> > +       rvmi->mm_wr_seq = UINT_MAX; /* Start odd so changed by default. */
>
> Why not initialize mm_wr_seq correctly using
> mmap_lock_speculate_try_begin(mm, &rvmi->mm_wr_seq)? That way on the
> first call to lock_next_vma() you won't be resetting vmi
> unnecessarily.

It doesn't really save anything, the init already sets you up in start state
where you need to do a traversal anyway, and vma_next() will trigger a walk
either way.

What's useful about it is it makes it such that only lock_next_vma() does the
speculation (and thus sampling of mm_wr_seq).

> > @@ -471,14 +505,9 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
> >          * installed ahead of it. Otherwise we might observe a gap that should
> >          * not be there.
> >          */
> > -       if (from_addr < vma->vm_start) {
> > -               /* Verify only if the address space might have changed since vma lookup. */
> > -               if (!mmap_unlocked || mmap_lock_speculate_retry(mm, mm_wr_seq)) {
> > -                       vma_iter_set(vmi, from_addr);
> > -                       if (vma != vma_next(vmi))
> > -                               goto fallback_unlock;
> > -               }
> > -       }
> > +       if (from_addr < vma->vm_start &&
> > +           vma_rcu_iter_may_have_skipped(rvmi, from_addr, vma->vm_start - 1))
> > +               goto fallback_unlock;
>
> Before this change we fell back only if the new search yielded a
> different VMA (the vma != vma_next(vmi) condition) while now we
> fallback unconditionally. Note that the VMA that we are rechecking is
> already locked, so it can't change. Was the previous logic invalid?

It's not unconditional - it requires that we have progressed and we may have
skipped a VMA change.

The 'we have progressed' bit was there before (from_addr < vma->vm_start), and
vma_rcu_iter_may_have_skipped() wraps the previous check plus actually walks to
check if something is there to traverse,

So this is strictly an improvement.

And yes the previous logic was invalid - the issue is with an unlocked VMA
in the range [from_addr, vma->vm_start - 1].

It's really the gap that's the problem AND a race against node replacement,
which means that 'X' is skipped by vma_next().

vma_next() is a walk to from_addr, then runs mas_next_slot() which advances
to the next entry. If a gap, then the walk assigns mas->last to the end of
the gap, and if a node is killed before that happens, due to a VMA
expanding _backwards_ like:

vma_iter_set(vmi, from_addr), then mas_walk() from mas_find():

        from_addr
           |
           v
 |---------|      |-----|   |---------|
 |    A    |      |  X  |   |    B    |
 |---------|      |-----|   |---------|
           ^     ^
           |     |
     mas->index  mas->last

The walk lands in the gap. mas_next_slot() saves mas->last as its
rewalk point.

X expands backwards, the node containing the gap is replaced:

        from_addr
           |
           v
 |---------|  |---------|   |---------|
 |    A    |  |    X    |   |    B    |
 |---------|  |---------|   |---------|
                 ^
                 |
             mas->last

mas_next_slot() finds the node dead and calls mas_rewalk(mas->last),
which now lands inside X:

        from_addr
           |
           v
 |---------|  |---------|   |---------|
 |    A    |  |    X    |   |    B    |
 |---------|  |---------|   |---------|
               ^        ^
               |        |
         mas->index  mas->last

mas_next_slot() then advances past the entry it is on, which is X:

        from_addr           vmi
           |                |
           v                v
 |---------|  |---------|   |---------|
 |    A    |  |    X    |   |    B    |
 |---------|  |---------|   |---------|

So vma_next() returns B, having stepped over X. We lock B:

        from_addr           vmi
           |                |
           v                v
 |---------|  |---------|   |---------|
 |    A    |  |    X    |   |    B    |
 |---------|  |---------|   |---------|
                              locked

Then if you get (really) unlucky, the same race happens again for the
existing code:

vma_iter_set(vmi, from_addr);
if (vma != vma_next(vmi))
    goto fallback_unlock;

The walk lands in the gap before X, something else is merged into X from
below, the rewalk lands inside X and the advance steps over it again:

        from_addr           vmi
           |                |
           v                v
 |---------| |----------|   |---------|
 |    A    | |     X    |   |    B    |
 |---------| |----------|   |---------|
                              locked

And suddenly vma == vma_next(vmi), no fallback, and X is never reported.

With the new approach you simply can't miss it, as
vma_rcu_iter_maybe_changed() will see a change could have happened, and
vma_range_is_empty() tells you explicitly, with a brand new separate walk,
whether e.g. X is there.

It's finnicky, finnicky stuff, which is probably why AI found it :))

--
Cheers, Lorenzo

