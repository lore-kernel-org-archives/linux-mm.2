Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26CC2606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Km+hHmE1
Received: by kanga.kvack.org (Postfix)
	id 469F16B05B7; Thu, 12 Nov 2026 10:51:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AAB6B05B8; Thu, 12 Nov 2026 10:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C226B05B9; Thu, 12 Nov 2026 10:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 109BE6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:51:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2F591C3E38
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:51:22 +0000 (UTC)
X-FDA: 85426906404.27.2FD8472
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id B508180005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:51:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Km+hHmE1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794498680;
	b=U9B5x/a4VbVcJkeJWvnFwVrFnE2HmXxEzwVK32sbRLBtbH8TLeweWwe91s6DuU3YWfNOcv
	OgTfWIhmihN/Er+k6/Yg4mntjXTlguo00dCcqSAG9yZaEX7M30i3XT7ncpL82ah1cIM6JZ
	cVVqRvF0ZtzAXeyvYP+i/pr2mZMaTdo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794498680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHdxAN7HZz6R7h3iP2OmBErMKSektM89NlydJ5odNjM=;
	b=w0069uXHYiB25rRZz9uyeAe6bBNtwW5QClzwVWF4amaa8I51NcHkFO1TDm2Z6cZ8ZDb8lc
	q1LuV+HsJHd37eUlcBmYkz0QY+jn68W30lFSESuW8IR7Xp3V8ylH+49J+eN3IOvzYqsDwU
	EpZbCkx/X8QXFC490hfwRklpQK26uq4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Km+hHmE1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a39e5161c1so3380413b3a.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794498679; cv=none;
        d=google.com; s=arc-20260327;
        b=WmzW1+YVVCwhz6z/Qf5mpI6Djlbom92o+RobOCqCDamqIsC8ARlWj4LJdMMmiPybfI
         5+bAVNXHfl34qQLrE6pGC0J7BJkQmzrYSJVgwTbRWI+/oL57uYylWQ3hQ71AUJvStwC2
         a8ee5z80/srThxWPQj3fjV7nllIa7AJ7q1ALGtUBLYDuefVUj/v5HUlAq4wy2MZ3eE7i
         sTwO3ZEky1ygbLkp8A3M6+74RGGxqAKA90H0qT5bugkMgFViiC4zxFxzGbXOojAHjSTm
         l1jNhTBhMEjh/hcOo/mMb8WoLdUFNEMtXKwUE23sf8UI7N5rGeoN1MkxrUlt+zsX0vez
         0nWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SHdxAN7HZz6R7h3iP2OmBErMKSektM89NlydJ5odNjM=;
        fh=X5t8rxpZSUbnIfYt0bFkP1JTuyNXWqqvD67HxFlq7h8=;
        b=ocJxDCf3rLOPWxfbyF3gi2eR8xq4eeAgQbsHUMOLiOShTvcJq259w8VUCu/f9J6UFW
         2JruNuswXjlX7pHkDB7+wXMXtgiCKerJrpGZ00hv+6kWDKKdNGYnrp6isLDxB3qoM1bW
         I48HKWiHWeoFWGTMP5w/Gfe4VLwA63wEwS2/doxUBv9gfApmCwRsGOxE5VPD7BWXfcgH
         5G3BE1wHQMfnf7J9NtXpw+y5lwuaDHLXyxITS+6momwH/aaLrmQpmi9nPoNopXAY7DGM
         Zz4544VhWkH7jVI+5uc8E1p4G9ifS3Yx/T4r8jSAUfGDKuXV5wRzXgi7sP022Np/Iv3k
         9Czw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498679; x=1795103479; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SHdxAN7HZz6R7h3iP2OmBErMKSektM89NlydJ5odNjM=;
        b=Km+hHmE12h0xUR9fxge6XWf97sHzAG0MnQ+N2/I/IH+Qg7frfYhwcH3r79nh6ivJlJ
         4ZZ/D+mhyciT1WrMNVL5K26UwcZt04JKG2Kvtol/TjFWe2ZnySyw/JMy+Czp1FYsrDGh
         DndL5KknJIyAmW9sdCZxUSqLSDUYGCjZ611hI+stsmiaChIDUcEZcYVvXe3jIoq0IXIu
         ltL5ugfUAVmtY2l4m4UTN2zRSqBo1/nPvcQun8srVuXVhiK6D5d4vB51ORCQHqBLizzj
         MucAsaosIW64xYJ7Q9M+6ZlD3KKL39SlppUqAYYrMLBrm5mmFl6tSpwAfLAHFK5o6ojA
         WjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498679; x=1795103479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SHdxAN7HZz6R7h3iP2OmBErMKSektM89NlydJ5odNjM=;
        b=ArBwnMPgoQNFe6o9FFu7H/e+irKc6rkmKr2QfQ1fAfwXdBQbLxGEmvqmINSNZ/C3cE
         RN7l9cqoTEiNlgXfSWrCxjJTKYiZ/YfaL8QmleKyv0tD+mQe7OBiNnx16kng9OdO6O3d
         CBaQYkEctd8HBgSBb7rXtHT2WUDUmwZN/W8YXfRQbnUudVGHEdStV/tGCNDkd+EdSd82
         9cqgrbUom7jnG/NlP6j400IZXe2UI/abpXB9kcipREdcqyqAsh/LUxi+j4udcux5S7Il
         T4B4aArDdgG7I86e/lCBRPBhnXLvvMZRUgSj4HEjcFcmcbNuxqe72iRaGvVk5rVOow0o
         qMvg==
X-Forwarded-Encrypted: i=1; AL+hErGENS9kcIl3dcsdKDJemN46I3LcZ/n6xjW2hpwcfa1YX73PHXzfyU+esnIMMJjdxSWFS6svOmYRKw==@kvack.org
X-Gm-Message-State: APuU4Z/fIb+hxcax59AV6+JY8q34LfV53xL4kq0n+RywxXm+OdAfNDdk
	sZ2D/nJ4scVvjVDwGZW3VLg9y7s2LQHAwTPxOVdnMtRf0oQHv1EGu8qPIeWmBX1zWcVCEK6uQN+
	uQJ2GCEESA7pVIrPNiEQ6AkGVW43qrDs=
X-Gm-Gg: AYBFou2aoZUm8h5NgFt1JY95RdD+ddmw37Uvlc0viw0lLaq1Tp5eW9klXaCypP0xlfY
	yyZiodlI+gYOidh3x7G+U9XjPUec6ZCTbDuJV5elxHvBsje76zvIRERnl72EW0Ar3A5tWAA0K8M
	kZirA3j4j/FECdLcLLTk86/w/lldIa/k9tozoZKHtw4BgEIOUvTJo+cEL1qeV0sjs2sCC11iJvg
	XZJTNGpsYvFN5+cSRrpKnocQ6Nzs7d5UURouh9iKUZQ2CN453UwH3QoW969VpIiyQNd/8KkQhJW
	C2YgDoTSknx1TpWsZbEbpbrX3OJglvc9IqaF+lTPmRK8cbuwKVMVni7mpUXoFTKFIb04veogths
	7DZZfEFNa6NRijK6Bemu1y/x4vqHFs+QvqQt5wC9hiVcFPTTpqFISX1lAINA/7pbnJ86U9w==
X-Received: by 2002:a05:6a00:4f90:b0:8a0:4493:50b3 with SMTP id
 d2e1a72fcca58-8beb1fd9e3cmr15135b3a.2.1794498679329; Thu, 12 Nov 2026
 07:51:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112075827.255602-1-hui.zhu@linux.dev> <avVx_1BEP7fIzGDK@KASONG-MC4>
 <avV0IbvSx4iuv0tF@tiehlicka> <7718d4d0-58bf-4281-8256-fa726f753159@linux.dev>
In-Reply-To: <7718d4d0-58bf-4281-8256-fa726f753159@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 12 Nov 2026 23:50:41 +0800
X-Gm-Features: AclHuK-DauIlr6X0qTL4R9gghp2Up-lZkVCGGgcBB0M_Z_UKEKTL-VonoqZxN1c
Message-ID: <CAMgjq7CUMuNSdCXZ7_kDdo9+0BFvPNHuO=mq=ct_Q5YUyyckvQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B508180005
X-Rspamd-Server: rspam12
X-Stat-Signature: ucc87pij5usy8g9jcphrb53b4ii71qh7
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794498680-608581
X-HE-Meta: U2FsdGVkX18aethuNXdchVD3yq7K4LpR0WXGWtH5oaZSlAv6aZGlRsevWvBrcz66zqcDWH7qjHzMb5W5gzolnfeLlll/EzyPRq/R/ONaIKLmg2GJR5LUfO9YzUMEbORZjvM9Ts1Kr6JY73xv6ezWIDan0W9gqzDEOoJwW6EpX5kTI5xj0y8sEivIjZBtdc6myA6n79LXfY/nFaIbApwBqGXeWiJOsFNm+3Qvu39Plb6s0NJUMp84b2KtHL8fM/ZCj1f9qdLQ8r+DGyPQSFG2E7KbNW+grADaurVxG5q+tim1I8mJkRy3cIeKevinrS6WgffI06te6VmXbuMpOP4Scsb6xq4YEaDrvGOUmyX3nnlIH4f5PLx2i6WoWKwMsWhBjfogfaLJzGtCsWMbaDML1FQ0S7xGzU0a6xnf6yaNccmc39kMl+TvJfacuBcuU5qL1E+5RpZ5dj9dPVyPc+bflWun2TQ7bsitdBtMjJKza+tr9hQ2kLzMf5wavu8TCnDojhGm8r5AW4k8++RLAC0veDe7ZdPQeJqsyiEc+P9xg0dRzYogZgOhDKeWKFTSR8Yp2nAlsWXfzcPbdN5M95S10qSN4K/QEwtyAZ78/aXcP2FR7NdRd33xQYGopnvjDu00kkkN5U+YChxQgNPqE03ynjYqB2KOC7voTjUbDIj3qh2eLeBKEuYI7zLKOrYrsbMvLCLWyj436c8TegoRM9gPLIw7joFDTIlFVAiajAUiVqPgDraG/X5vLsnvEQC+OB3j7idULThDIEk36WHZU4EVcDKEryWT8EYqTDrENwTlkjMIK0At2axeusA6EU/+UR+MMEDred6Z9A7M5MInhgMBn6Fio+iCRj8s15ukMOnoSUJssWwnL8u8IysEs6Y5d7BiaVGc0M5xZsnV2YNt9R/y5bZdYb9CV8SQwcNQveiPpY6Nn7VF8XG14mYev0sKHhVVp884vkHVWyoDddGuv8M
 5Q1GlDrQ
 aEEMxOVfkN4Wp+luZlbtDqtma3GI+KOxoTVcEMxQ+PwUfdp4u1nXET3mC1Z1utUDmpbfPuqXrjMiZlwjUkAVi6gnjqWxeeKNJX5MbarR6FD6J+aKeA2HwtzGe5NH69WMWdoVqVtZBMgoErh7vJe+PUITmytbIvedlfwb/HEvkZ9BfmlzDH0M6XEjHGnNRSgl6PkjwWdP3MClKD2zRviGqgf0L+9RgLkYFkN97gzG7uhTWtTPS3i2XwK/CLDRHdEQFqpNKaRf25zntX9A3UX2OU2DSLma1DOWdSOa5Aw4J3EAMBFBPCqKse0z3QozOSE7m4jSO7XYFiwJT0X67fbn0lcHkV+mJDW0kyCV8jJswaNtpggCKRDxyc21zdsYPp8B+dYvmUvBGKcw1JysSFEZu2nn9pzYn2QGJheJIJfuwZvxYR0JKpLEx0tEsIVwN0+K8ZvBdpZKxyAeCfkXJUXsZfHKNKJnmrCZggQDuf4UVax1WVELv/RmZ3GnfxCzoQsogFtdyK86fg5HIkWq/wadGCO3X79CLZGXBKT7wmOzbp3AuXVieOhjQfW7Eqke/ENaUx/gp5dyrLJpQU3/4Z8hQB67AeW9xbOakECK+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 5:01=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> Hi Michal and Kairui,
>
> 2026/11/12 16:09, Michal Hocko:
> > On Thu 12-11-26 16:03:54, Kairui Song wrote:
> >> On Thu, Nov 12, 2026 at 03:58:27PM +0800, Hui Zhu wrote:
> >>> From: Hui Zhu <zhuhui@kylinos.cn>
> >>>
> >>> lru_gen_change_state() migrates folios in batches of up to
> >>> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> >>> keeps local interrupts off for up to about a millisecond, and CPUs
> >>> contending for the same lru_lock spin with interrupts disabled for
> >>> that long.
> >>>
> >>> The caller already reschedules between batches, but a batch itself
> >>> only ends after 4096 folios.  Stop it early when a resched is
> >>> pending; the caller restarts the migration where it left off.  A
> >>> remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
> >>> thread_info, so the flag can still be set with interrupts off.
> >>>
> >>> This follows walk_pud_range(), which already pairs need_resched()
> >>> with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
> >>> smaller batch for reclaim").
> >>>
> >>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >>> ---
> >>>   mm/vmscan.c | 6 ++++--
> >>>   1 file changed, 4 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 6a1af9b92349..47f2cb25eb46 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruve=
c)
> >>>                     success =3D lru_gen_add_folio(lruvec, folio, !act=
ive);
> >>>                     VM_WARN_ON_ONCE(!success);
> >>>
> >>> -                   if (!--remaining)
> >>> +                   /* stop early to shorten the irq-off section */
> >>> +                   if (!--remaining || need_resched())
> >> Hi Hui,
> >>
> >> I've been thinking about a different design, what if we just
> >> delete the `--remaining` check completely, and check
> >> spin_is_contended on the lruvec and need_resched()?
> >>
> >> In the optimal case we don't need to keep lock/unlock the lruvec
> >> at all so this is faster. And it still avoids lock contention or
> >> blocked schedule, and it might be even more responsive as we are
> >> release the lock earlier on contention.
> I like the spin_is_contended() idea and will add it.  This file
> already uses it (lru_gen_look_around() bails out if the PTL is
> contended), and security/keys/gc.c uses exactly this combination in a
> long list walk under a spinlock.
> > Wouldn't this result in too much lock bouncing in the end? Would it mak=
e
> > sense to reduce the batch instead?
> >
> This worry is fair.  Under sustained contention each yield costs an
> unlock, a requeue and a restart (microseconds), while one folio move
> costs a few hundred nanoseconds, so the migration could slow down by
> tens of times, with cgroup_lock and cpus_read_lock held for all of it.
> Requiring a minimum of work per hold bounds this: only honor
> spin_is_contended() after MIN_LRU_BATCH folios in the current hold.
> Each hold then moves at least ~64 folios (~15us), and a waiter still
> waits only ~15us instead of the ~1ms of a full MAX_LRU_BATCH batch.
>
> I'd still keep the batch cap itself as a backstop, though.  Both
> triggers are event driven: with interrupts off the local tick cannot
> set TIF_NEED_RESCHED, so it takes a remote wakeup targeting this CPU,
> and spin_is_contended() takes somebody grabbing this lru_lock.  On a
> quiet system neither may ever fire, and one batch becomes the whole
> lruvec: 100GB of 4K folios is ~25M of them, i.e. seconds of irq-off
> inside a single rcu_read_lock() section, enough for an RCU stall. And
> toggling MGLRU on a quiet machine is a common case.
>
> Reducing the batch alone would also work and is simpler, but it pays
> the unlock/relock round trip even when nobody is waiting, and on a
> loaded machine the unconditional cond_resched() every small batch
> stretches the whole switch more than yielding only when somebody
> actually wants the lock or the CPU.
>
> So how about all three combined, like jbd2_log_do_checkpoint() does
> (batch cap || need_resched() || spin_needbreak()):
>
>      if (!--remaining || need_resched() ||
>          (moved >=3D MIN_LRU_BATCH && spin_is_contended(&lruvec->lru_lock=
)))
>          return false;

Do we really need the `moved` counter? Other than that it looks good
to me. Thanks!

