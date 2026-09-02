Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7CCC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61DD6B008A; Tue,  1 Sep 2026 22:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14C76B0095; Tue,  1 Sep 2026 22:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB266B0096; Tue,  1 Sep 2026 22:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 843D66B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:29:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0837BC06A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:29:55 +0000 (UTC)
X-FDA: 85167241950.10.F504704
Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 07327160002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:29:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7sdpu0s;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788316193;
	b=zbRsK97diHsEvFQK+/lI4FQXg07qmk0sJVmJRt9VJNqUzS5N9/xlEVVCY3auvCOBi65grU
	7AvjorXHOpvfLLw3EZOEIzE0fJIllyF+nWMiizSOHp3o5UviJCWgZYe15ANF9+Cm7um8c1
	VSZju1ZnMRtvncmM76xwHfxWX/nZVOc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7sdpu0s;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788316193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nexLiz4rfXN7fI5LGD2V01alUNtBIdIec95f+/YvB0o=;
	b=zwDTEB3hecV3atDBst5M++m95Xa5izNbGRtpm6zE6i9t0o8oZdRICsWlG5AWZkRiTU1i8Z
	/t+vU9bDDHXCzrHJ0tnmfI1AT1qjkCTHpXbzQRTdRzDv9w8Ph+rSSVStAOTCxEKwO3Bb5V
	f+4GDgpFKmCOqiPacquNaYkhxzzMVVg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Zln3qeJFlu5tVf/s/qZrMQOVT2ydcffaRFGbk94Wi+E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788316191; v=1; x=1788920991;
 b=w7sdpu0s57FJw2c/QqICgJY4tGbqoFIoTb8mpEreTjExSHPoxVCgBxNUbGkjPkxZKHCS4WoC
 lDvqK0+1p/YPyt/5/uX/4t7SX19H0H6Ur9xXQMB9oiRp2/Nx6vULZxX5HHWvv608WLDbUP9MZqu
 6dwetgejPF/2WpuPhwSk3888=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id df2715bc0385cdcf;
	Wed, 02 Sep 2026 02:29:51 +0000
X-Mizu-Trace-ID: df2715bc0385cdcf
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 10:29:47 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <apeKG1-N0JBGl70b@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn>
 <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 07327160002
X-Stat-Signature: io33x9t7m9cpt8a5fikp75sd3aipmqes
X-Rspam-User: 
X-HE-Tag: 1788316192-303638
X-HE-Meta: U2FsdGVkX18YcqCY9QtnbSYzzPGYckVNqwTnORmWCblUDMmg6hZICtiUEdVm1/k77QsN5ivQWksabYI9rF/rBcne34KRx4SANoGtBwVTclSmc/a3yPFKOtTrD9iARFEvJ9vt98Y3NAu0k6EfXPssABgQ1o6LIiNDbtSEqecJM8lvhQGgL5+5bjtr1Ovek/0Qx1aVOycRZKOsQd3GWsyVutJZkGJtP5h5HBPtqcnN3qbMzjCfmg3ygOylaYg1G6n83FT6Ue5ysTqq5piaTKLvGEiVrlJ1jzr+wE2QkbRTt8ujmGa7EKCpBj00yJblwOrXAybFQN/oxUgA60boMWtpKh5gCI2m7Qy0QWmMipCAqzWOjqV7pinf5WjP1OTuc5HvTrbU/Ka4oPb4U3ZJ8ZHzQ2DUgr60ZvAvLtlqc805/6aXHvCiSilWrxId5nQkUPMSpULP9p9pliAxHA3iGfsMt+VoPielTUZmtcRvwNclkbcfVs7WFUcfi8+Uk5zIGXAsu+isSoc81jDYenYLSzBB7uevzuJvFvnJFvPRt39bIQIbvkr4dAHdH3VvbDDNfQca2cbQKnhKEDoa/ljuHM2FR4AtItWcs49Ozpl53FxfZZTzI7wMvwbxzfO2VdeDIY33FrfTgSDif3uaJEvFf4aIqnh5+ycCfudqI3vK1tootOhun7gqxoFyHrg9Zhagdv/o1BMPbgP8IL4G/wX1P02+rOfuN19T9SO3x/I1mejpHeH3cOvGkvYfDyUA/9PDoxbKIzthVk7lVnvf+lmT37JIRmSv7cGGBAWJmChwD8OJZ7Qn4MFpwUVgWpFVtKUQyYcv9mDYYY2CkgdlcHri1w9pOFu+FXj5A43K2VKvimHvK/HLU4OAq+1iOXAarHL0mJMNrygp9CTMsuzg8MaLS9D3+n5SSJk9j9vUfHAk1GofKuDaB337sdCUYPYieIIZZ2vxFrtUWZODD48ZJo3o/ze
 3rg27HxY
 7YiinJPW5WxA1Dk9V1fCiTi17L4Rdg+5H1tpP5q+1EBF4AJnNWjCmmRaVjwADEi4giHrqx12YZdUYlKhZIn0tWzITYhk9du5648YmLpWV0tIBJT7X4qSWlQXVVELu3bR6IO1/99YAr7AXAyPyo6D+JvtZpYOYavLGcN40v4x9BISPVJUeArNYQJzcq7N1WMrpODWDAEa7mZzqy4kN/9eTxLIvNo/DTywr6B+NUJu5uro33IDUOPzEvm9yxj83tgS328f9u8EO+ViFKOlnVIKHJsLhf1C6RlyizaucDloXe6uhox4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 07:53am, Barry Song wrote:
> On Tue, Sep 1, 2026 at 2:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > The aging walks into every PUD and runs the PMD-level Bloom filter
> > on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> > up:
> >  - walk_pmd_range() now reports whether it found any young leaf entries,
> >  - walk_pud_range() records that in the PUD filter, and
> >  - on subsequent generations, skips the whole 1GB subtree when the filter
> >    says it had none last generation.
> >
> > The double-buffered filter flips with each new iteration, so newly hot or
> > migrated-in pages are re-checked promptly rather than suppressed
> > indefinitely. force_scan walks bypass the PUD test, so manual aging and
> > newly added mm's always rescan and re-populate the filter.
> >
> > To keep hot regions marked, also report the covering PUD from the rmap
> > feedback path (lru_gen_look_around()), so regions whose hotness is only
> > observed by eviction will be re-scanned.
> >
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 47 insertions(+), 5 deletions(-)
> [...]
> > @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> >         lazy_mmu_mode_disable();
> >
> >         /* feedback from rmap walkers to page table walkers */
> > -       if (mm_state && suitable_to_scan(i, young))
> > +       if (mm_state && suitable_to_scan(i, young)) {
> > +               /* the PUD entry covering the young PTEs scanned above */
> > +               pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
> > +                                                    pvmw->address), pvmw->address);
> > +
> >                 update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> > +               update_pud_bloom_filter(mm_state, max_seq, pud_p);
> > +       }
> 
> 
> Hi Baoquan,
> 
> I am really not against this idea, and I believe it can benefit
> NUMA cases.
> 
> That said, I might be being overly cautious, but I'm a bit concerned
> that this re-walk of the page tables could slightly hurt machines that
> don't benefit from the PUD filter at all. For example, Android devices
> typically have relatively small amounts of memory, so a PUD covers a
> really large range of their address space, which is unlikely to be
> useful on an 8 GB Android device. Also, `lru_gen_look_around()` is a
> really hot path. On Android, we've observed that it can consume a
> significant amount of CPU.
> 
> Is there any possibility of implementing this in a low-cost way?

Hi Barry,

Thanks for the careful review, and both concerns are fair. Let me address
them separately.

(1) Aging walker overhead

The added cost in the aging walker is one PUD-level bloom test (2 bit
lookups) before walk_pmd_range(), plus a bool return from walk_pmd_range()
and a bloom update when young. This runs once per PUD per aging pass, not
per page fault, and is a tiny fraction of what the aging already does per
PUD. The test is also what lets the filter discover cold subtrees, so it
cannot simply be disabled.

(2) lru_gen_look_around() hot path

Agreed - this is the genuinely hot path (every fault), and on a
small-memory system where the PUD granularity is too coarse to be useful,
the pud_offset() + bloom update would be pure overhead. So I'll gate it
on a per-lruvec flag that tracks whether the aging walker is currently
skipping PUDs:

    /* iterate_mm_list(), at the start of a new generation's walk: */
    WRITE_ONCE(mm_state->pud_filter_used, false);

    /* walk_pud_range(), when a PUD is actually skipped: */
    WRITE_ONCE(mm_state->pud_filter_used, true);

    /* lru_gen_look_around(): */
    if (mm_state && suitable_to_scan(i, young) &&
        READ_ONCE(mm_state->pud_filter_used)) {
        pud_t *pud_p = pud_offset(...);
        update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
        update_pud_bloom_filter(mm_state, max_seq, pud_p);
    }

The flag is per-generation: cleared at the start of each aging generation
and set again when a PUD is skipped, so the feedback tracks whether the
filter is currently engaging. Before any PUD is skipped in a generation,
look_around() pays only a single flag loading.

I'll measure both on the 8GB test VM with a clean (fully unpatched)
baseline vs the patched kernel, and on a 3-node / 1.1TiB bare-metal
machine.

Thanks
Baoquan

