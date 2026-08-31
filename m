Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10865C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1819C6B0088; Mon, 31 Aug 2026 13:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133136B008A; Mon, 31 Aug 2026 13:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3CBB6B008C; Mon, 31 Aug 2026 13:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9C446B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:44:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 543181201E5
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:44:45 +0000 (UTC)
X-FDA: 85162289730.24.DC3F9B7
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5FA2F4000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:44:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mDEYuHvM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of stevensd@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788198283;
	b=0I1dVW+r448fDIzhytQIonV7FKjWLZFCAFaTEdJ7YMfHGpRef2Rh5pmM586SDtkM/BjEUQ
	RruDJf1+/V7yhhaGW12YfuMNpXT+HMXNfDoVAOauiP3DZHyyErY+o8wMu5IKsUca2V3oo2
	laMIpfCHwO28Hkw1P/Cl6EZqJcSqNKw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mDEYuHvM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of stevensd@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788198283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISAzL6GuJopoRMWQpQWk2e7HTJAN8rWZ7VQ5HvwdBSw=;
	b=RveqhOG9ghvYHXj/POVKv6QhZ52/75qVlPAQrqyiC3XrE9MmuzU6Oi5yU5YSchRIL04q7M
	JuSOLfvEBhvQMZZ7AgZkP0M+k63hutDDVLhX3U34PChJrHr9aCBsrnMGQpYvP/fmbBmPBE
	AiuK/kKN8ZycXxpQ97IsEoheBmmCAtE=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49ccf12bed0so2095e9.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788198282; cv=none;
        d=google.com; s=arc-20260327;
        b=IrrDT01jNouw75oYCesBVd/vH7x0s1NPpCip1czDh5UOWO8BkKpTjFB/3t3AS+VtHt
         g9DXjdjN5EvFa7M6zqBto3wpCIglvXQaadz203xgIifn/g+qfDUzOjuGruFKrxbS8ypC
         mRdNGZLVRvzRvzMYVU67Js4e+XHJVWzx+DD5eK/m5aoPkKVruZJIG4CcDKbD2BpjyM0d
         fGtu8r3bAzSPCV7YUJBmvAesLjAubgppBRMwqvc+ilav8P/n+IGKaCnopZNhuhu6Uaqn
         rPwGNcPHgd8o/Gjodd/DA80oGQLq7grNEgvMw1uwO6/tMbZy5gm5BmEk35QsWQdRUSJm
         HXHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ISAzL6GuJopoRMWQpQWk2e7HTJAN8rWZ7VQ5HvwdBSw=;
        fh=R8n5oyan+/Wjzqx/Pr8p34ijn1YeYfxUlQ6BWeVB3d4=;
        b=NetSCVuZkyXF2szb7eOcJ5jZgtin8KQtJpzzULqkv+EIeZi+r4059imYGYKTbttmsD
         StR7kTtN0l0dh8l6c6dqCqi4I7e+EJSSyXKrplreVG3pwZN4KbPX1X4mkUT9rxS17Hk6
         6NlsexTod/rUWFVUyBezKnJKM2YbehKS5Lm05SoJWrSJBvK9f+hrTWz/3v6VcA87g/H8
         JW8ZilZyySzsSdg98Sa2YNC7bglM2n9Y7r9nObsNVz8FSMfn29mnVK0bBgrkx5Rn/Erj
         QNHKkh5T3QUCQHTSCTLkC89KrclyKSe/cKE8xscaXC+t5EFCCke7m9F7Kr/Ki25mNUPi
         huHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788198282; x=1788803082; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ISAzL6GuJopoRMWQpQWk2e7HTJAN8rWZ7VQ5HvwdBSw=;
        b=mDEYuHvMJD8+e2t35b1HGYCqOgYU9XT0ZlzTT2BySRHh8AyxKcK76c9Ve9NzrN423Q
         2DxLsD8sx3381YrUWEqRxZc7/uGUBsWQi/P/zJkRfEoHdp/3PFuhcsPrEY7Ex8Ntwal6
         5Si3J74hK3HSlj/8zjCftML/sC3ESJnztyWGPPJSFpDJgX/gOl0T6+yrZ6LzdvcZuo4S
         Zk5CRXHZ9qj25CukkTdG0UWFasssA+SdsuVQLs77hWx2n1/qO7srnxfNcTfozqhWHM66
         I+mdz9WyaaRHwFkqRZyShAsM92VUEaOl+0m+oIVjgkD4xuyUwn5eVP28gLM468J98NUA
         /xZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198282; x=1788803082;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ISAzL6GuJopoRMWQpQWk2e7HTJAN8rWZ7VQ5HvwdBSw=;
        b=E5mwZglb/qFEEYq7YxXRZ+xfY6Ma/dzeKiQqYwChnKhTueiCGgDLJH68aI0dyR7eUO
         EtRHyVnFzr6/0YKr1PkcacXXEhA6yEsVQe7JsZCLvRuzVmfHMEujlIwwVkW1QI0DTb6/
         FF+hgkI47bJk4AiY2yoORsNIpwko1CbkWirLsAWPDojjCY9bi7iMSKmzLhioVnlnggXG
         5Opq/hOZxsMF5hTH5kNRT3SiJ8kug8feWx/PBVvucuTmqZB1FCazoQiuczO29GERGEd/
         8icKm/Y9l9e4ezg/fh7bhtyl02IVmegq+TwF3szjG4plhAAZJXpidBxIc/3Fif4li9mg
         2R3A==
X-Forwarded-Encrypted: i=1; AHgh+RpLW8o4hveEL0G/1+XyPJVMdqzlsOMjkA9xCHMg/WDHS/8bX0m5IbLGyDTxUf3GoY7pXjDxzMxZ5A==@kvack.org
X-Gm-Message-State: AFuF++lhlmjolSrILJzURyPucnY0WXRnK2aVMALB3BLE4mGfZLRb6Gut
	ps11pbk3oeOsInoN45f2owkVleFBANQcWLv8WOlD6P838tjrIInGWer5UmRGyAPBdqDt67hp7tl
	kyR9zW2NpYEpBu1BYYAFqZ5UvPkTgkbgDFTYlgiNy
X-Gm-Gg: AR+sD11G9S+WF67vn5R7y0o5q1fuoMRsLqGJeqXzHWv64O0i4UnwQNww8IfwGNXyHQM
	olnj4nCiLMzwtVHDlA9ctM0jkONVUHoj9h5HaMahrGFo5v50Q1HUE+PPPCxXQZu+oNAVj6q3pqF
	c0ttqxkxFygd1njxkr7zdE1HD1ZM8BjyD+EgVWnUQcEQxVCRl43bUrsCaU12+Y3sCMCZqiQK04B
	6QpXUfHiaqkALJ0C36dqJndAZSqB7NUsykTi7jmiViFL9Ie2s/6jqBNjd7b61v3FHKZicRQ30bW
	w+k/KzZ0ayJmJKWZ1+rwlQSH9CfFBSk8midMbS80r03A0YCUzChFg5YLznCBghCsFU8cnwaQJO7
	9/DSFNDpr8ZtdweQh9Jdn8COisy9kdVIVbLguZHUPtSs=
X-Received: by 2002:a05:600c:6d8a:b0:49b:8eb7:4a7d with SMTP id
 5b1f17b1804b1-49cdd243062mr28165e9.4.1788198281222; Mon, 31 Aug 2026 10:44:41
 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-7-stevensd@google.com>
 <20260828120408.GN687043@noisy.programming.kicks-ass.net> <CAOiLmNHWGSwAqH815X3JWMrQCc2nh-fRNsNZ0hjQGv8JvFndag@mail.gmail.com>
 <20260829083929.GZ776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260829083929.GZ776954@noisy.programming.kicks-ass.net>
From: David Stevens <stevensd@google.com>
Date: Mon, 31 Aug 2026 10:44:29 -0700
X-Gm-Features: AcwNN1WpmAgjgQmF9GpDiXzg08-hj-z0i4rUlR_td_jtRLd8aXHDJ1pfdit0KWY
Message-ID: <CAOiLmNFsuaBf4C9=d5xrdi8SXYgFbjjD7ZnK1+G1=RaHquVinw@mail.gmail.com>
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
To: Peter Zijlstra <peterz@infradead.org>, shakeel.butt@linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5FA2F4000B
X-Stat-Signature: wt1y45wqankaea4nrcof5rgou3p71khx
X-Rspam-User: 
X-HE-Tag: 1788198283-374141
X-HE-Meta: U2FsdGVkX1+LQq28F5kZWTfIIo+xxtOcTr26m+eB9IC50KURYlMIQ5KRaUYJKibLKQlkr4evIZCj2hVtuOIYHYC8BtI0+M4YMfRsbmFsr3CYkpHhGMCWsn7ocTaFTuwDofXi+epqsmS5gAqw1Jz0MmPq4vPjbtoL5sFaOwkHhwyqh/lY4upcRQPPDD4UOMLv+W+4osAKx5LBKKw8c2RDjxdb5ucMVMemj0TH8d98gIDXfyvRzrFcRpIWXwuM+5JfzuDqjl57g8zsg6ID5x0cKzlr/XCZh0q0hr1oLNjL+js7aJEzaO4m/STloEeVdTE2xc6fO40WKjHjzFngqBRnDfZ8vwn+A4wMa18kgo65V5E0uXDpaub3MzlocshipgFiCm7SxQU8+PVxImxXe0OD8XA5rICDISrfie2GKWbRD+U+7slknzUUZx6hULXuXmOzj8xyYWgYs7DZf3jzPZvJhyfgmjwK/tgamNUijScFyM4BWuS1Rw/FR9y+SAIuTMyaSm08uAGzELIrPT/S5LHYdVxCArbOf6MyeQOs0huRbwXNH+8zAjSglLDHKMLP5es8tmeP/xKNSn3BQF01E7MEgXA4s4q3U+Pw9ALzdw+kT9IiEzRTPWIE7JZlNYh4FZyw4i2CciPYTHSzq2WQUpy9xXRjwLBzNzKy/ZvRYWfv52Nuz2tRgTmJzJpXaEFr6M2+mmYxAmLAoDiRhIPCd6fxioANCPeDZmlpOBrhOm3ytETQX3whEiFS0+6FS7YblGEooz00T/6TiD6gz225mSgCpzZpO8URGlbGDDNDK6eOwbtkd2fuJG+rTbFc12b3qGduPCNOfV4eev1iCCznaU+ISwT5Xv0FKi8+s9M6g+qjvqYVt5K8H8yprAxfb3ZvgD0oaZkqZ6fCDXsTcGf0N6JnyHAd94NCrTJwHZaYwBE4qoOoLOY+ERxCB3ulYxC8bIi4CRVrYs4LKysLpKvWFer
 tBzoet7U
 Yh4KsNiVOXapfqXZf5UrhrGDt4zK4Zm7BCSgiBijJ6BfvfJNJZwsc++4frgS0v6vadbDb4dbwIURxnYfO+UKt85FPhIY8uqaA/ml+BI/OFMRP8dl3q/Mxl11Pna6GjIgUj3fKwmaXz4IHoZU9w86zgVG931lVTaJ9GsM8jKfd3SdJOOXDV2EW6qACX/GRES/woJIgV7RCvs0gmkccmVXWQacqmVqqIKTuAoPlyk+9gyouf+ZsPstEIrJjOg9ZXAUeZUTb1eV6FMRdu6xglBr58i3hh4GEjXw3gTNvr+UUDj3Rwb8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 1:39=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Fri, Aug 28, 2026 at 05:18:05PM -0700, David Stevens wrote:
> > On Fri, Aug 28, 2026 at 5:04=E2=80=AFAM Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > >
> > > On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> > > > @@ -4320,8 +4319,18 @@ int try_to_wake_up(struct task_struct *p, un=
signed int state, int wake_flags)
> > > >                * A similar smp_rmb() lives in __task_needs_rq_lock(=
).
> > > >                */
> > > >               smp_rmb();
> > > > -             if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flag=
s))
> > > > +             if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flag=
s)) {
> > > > +                     trace_sched_waking(p);
> > > > +                     break;
> > > > +             }
> > > > +
> > > > +             if (!ensure_stack_is_present(p, &need_deferred_repopu=
late)) {
> > > > +                     WRITE_ONCE(p->__state, TASK_STACK_RECLAIM);
> > > > +                     do_deferred_repopulate_wake =3D need_deferred=
_repopulate;
> > > >                       break;
> > > > +             }
> > > > +
> > > > +             trace_sched_waking(p);
> > >
> > > Absolutely not; ensure_stack_is_present() must not call
> > > repopulate_stack() while holding ->pi_lock. Not happening.
> >
> > The optimistic fast path for repopulate_stack() could be modified to
> > try pulling from a pre-allocated pool of zero'ed pages. That would
> > reduce the function to a couple of memcg_kmem_charge_page() calls and
>
> Afaict memcg_kmem_charge_page() ends up in a local_lock, which is a
> spinlock, so that cannot be.
>
> Most, if not everything, in mm/ is build around being preemptible and
> thus not suitable for use under raw_spinlock_t.

With the recent work to make memcg charging NMI safe, I had thought
that charging from within the scheduler would be safe. However, you're
right that the fast path does call local_trylock(). I didn't realize
that only works because of an in_nmi() check inside local_trylock().

Given that NMI safe charging requires only using trylock and handling
the !trylock case, it's not infeasible to have an implementation that
always skips the trylocks.

The alternatives to that would be either not uncharging on unmap, as
suggested further down the thread, or using deferred charging.
However, both of those approaches would make memcg charging less
accurate, which is not desirable.

> > then vmap_pages_range() to repopulate the stack's page tables. That
>
> vmap_page_range() can end up in the allocator, which I suppose is ruled
> out by the vmap having been populated before, but it still has a
> might_sleep() that will scream AFAICT.

It looks like when we go through vmap_small_pages_range_noflush(), the
might_sleep() check is missing. That would explain why I haven't been
seeing errors.

We wouldn't want to remove that might_sleep(), so I guess this would
require either a new function or flag to support mapping into existing
page tables.


-David

