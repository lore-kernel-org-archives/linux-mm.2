Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08B0D72341
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 07:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355C06B0422; Fri, 23 Jan 2026 02:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302D76B0424; Fri, 23 Jan 2026 02:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F4A6B0425; Fri, 23 Jan 2026 02:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12D8B6B0422
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:24:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A14021AF82E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:24:28 +0000 (UTC)
X-FDA: 84362390616.15.4708ADF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id C43AD140006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:24:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3WbxfbyT;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kB2MOVUl;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769153067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4MUMTb3XXhX/yciJz7LL83W3UZO7NWvMgDqd4qfBws=;
	b=v+09CJp2S37xR6vFULP/OjEqKV+3+xG59dNk/qxUaR/Q5BEn7WidKw3rNU5cS79AXbAXSY
	2ybTASJ5nmRJafi1NwC97phghu1EIPdjxNPjK3g4ppUVTPqplEPK5h/1l7hS3AzsAp/Q8F
	wJeJ9BJ2kYYBwWHgep19TNO6hvo7byc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3WbxfbyT;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=kB2MOVUl;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769153067; a=rsa-sha256;
	cv=none;
	b=Ls1kkRFMCs1Lyh2iuVlyi5VqPuen2vxzahuue65yxTRvahx7JybeTegR5uRwj+rDeVlWwm
	N7CGz7smueo5YngKBUvDip5XCerl8MmE7youbf5+eCExm803WXoWnnzb1RTKtnZYJwo8gL
	CQCpfRuFkyIYdRm7PjML0wIN16kQFqU=
Date: Fri, 23 Jan 2026 08:24:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769153063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R4MUMTb3XXhX/yciJz7LL83W3UZO7NWvMgDqd4qfBws=;
	b=3WbxfbyTmiztwcKhnMODVHtZeRqV4gRKWO1umT+5CsMFKSXcxkLDM0+pZkdF9ySjAyUC4O
	De4LdDswKqE2b0VrqzwX5jQ32v7hPabANwSifZP+sGFE271+6KAYrAgwjEsW8qQrn5C6YW
	BaBWf2ChoA1botrkU2Wo6RBb9jRIKnlG1KCeHloT88gBhtlpliw8RR67ELCeSSv5pWXYtW
	f0Ns2t+MJZlUzWLzdCGdfVx6XOe5grh8N+T9wHrBj9DkOTT8RIIEzC8uAxKy2xgpbcBYel
	ws6kjE9/ha8/ejw3o6FuErFaqo+Tve4hIEmawNmMBbBi6mdOtxZpsM8y7ZHu1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769153063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R4MUMTb3XXhX/yciJz7LL83W3UZO7NWvMgDqd4qfBws=;
	b=kB2MOVUldDCaZTJnLL6KOZbU3RWpF2z05UNS7tgoehKTetvmqDyQS3hCo+jiIDi/ZU7D6H
	iewUTqk5//JDACBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Waiman Long <longman@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v3] mm/mm_init: Don't cond_resched() in
 deferred_init_memmap_chunk() if called from deferred_grow_zone()
Message-ID: <20260123072422.rOwJDb5K@linutronix.de>
References: <20260122184343.546627-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260122184343.546627-1-longman@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C43AD140006
X-Rspamd-Server: rspam07
X-Stat-Signature: so9s36um6rje4yfx6hhys1hkd9ohj3zs
X-HE-Tag: 1769153066-998536
X-HE-Meta: U2FsdGVkX18AO0zutjgFVIl9XiCvPa4lhgDVAFM88+A9cH5B5sFf/iZpTh0NiYxLdJlBLcqsja8O2s98GfnQBpGyQJOiE4oX9KlsQCp2z/1GEyiQSMALAdb1Nb4OM0Tv7pR8ImuCK7MZFIoo3zfe+m3Eppx1DezHtE7ceXyGm1uFyhLukY4Z+Vm38bLpe0FSwpPkJONNbYHMnYuuDnecheWPfOOIeRFuoyxK2DG4/udlRgG6XR2ERjZ2O+/HguuGciKsSVa7ezx7Mr0jEp6CH3uVCr6o8fxYudh32PI+r87YnRjeu5wmYUVpHcDl5h10colh+bgXRidnDpDxbNK7Vx0hVcbWS33nbJjf2vB8xLaB5tTS98TIX/XI3NLJihCapi4PbzzAJDcUjiMfARLFwQ056Ap+HCciLO4DSDoENPCGjf1vBLL+obU0q9mShLdYmNuTDZmlMzL6sG3PggROTGLTZ9K1nJ4EWosrABDe09H9P3NFJsIlq3OExKzxW4raTHijG5yhKiokkLmgNmU34K7PI+ybM2BTev7a3I+8lFl+lXutDSI+UgVLNF2SqBfnLggkkl21e/e50vepCO6VQCJneEZtjVHnUHDHV2GhHsBGxd/kPdjBuYeoOgGra0hOsWCNQazVfqvzNsRU3uz4OWe63BnRaEAWptUEOx4BtqiRyckv/yybeGNLddlM+baeQwXUwULhQOAfG28d3g80OJYXJ4CHuO3NbYZHiIAGgMaSMb1PQ1520IZRVaXGqA7Gogh6r0d2uWLmYoe0JfBHo9Yw/suQrbYz80srfWNitzVUqMYtA3Du+69dC8SjNaAyKSZhgqI6TyQ02uvvaa4U5JhlFucpiPY9oe5CXcLoW5PNYnY4ul56QqPyRQFhNZabj4hhwbcGXgNtC/yURoRYNszlJYKroezoEiLk0tFyWmHMgv3T8qWFKkSY04JAxhTEUTJ//k4HIJsYfu7PhxF
 5ppRVriW
 TcVqd0rH18IIQkqaRZ83aGVsbwZnu0UYLnqgIdegZrkffPkps5XVsilssrUn8BNlrAKe6/q6zVoVNSBJLAnJdxZproL2t6MWwFWcrz3QVYycahnURcwa7F4Oa4yTk29VT2cPudafynvTbNBUS9s3kXpCGdqnI+FvxSD75TblfQCA1ZSxnrhYHFr1xV3XKcK0xKXVxjIlxw5AeB7gX+CFMvrgVb3+OPQfGESqldVipm+c6B6XYb4toNjIriApEKTYMCzvT7nbxf8kMlXB6alxuTKIEPPO3Omqekiz/3N9tpq5QtP4MXPp9jXQ80XzUzYn9ZHHLfdaxcoOvXAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-22 13:43:43 [-0500], Waiman Long wrote:
=E2=80=A6
> bug report.
>=20
>   BUG: sleeping function called from invalid context at mm/mm_init.c:2091
>   in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper=
/0
>   preempt_count: 0, expected: 0
>   RCU nest depth: 1, expected: 0
>   3 locks held by swapper/0/1:
>    #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_doma=
ins_mutex_lock+0x28/0x40
>    #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferre=
d_grow_zone+0x140/0x278
>    #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1=
b4/0x408
>   CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19=
=2E0-rc6-test #1 PREEMPT_{RT,(full)
> }
>   Tainted: [W]=3DWARN
>   Call trace:
>    show_stack+0x20/0x38 (C)
>    dump_stack_lvl+0xdc/0xf8
>    dump_stack+0x1c/0x28
>    __might_resched+0x384/0x530
>    deferred_init_memmap_chunk+0x560/0x688
>    deferred_grow_zone+0x190/0x278
>    _deferred_grow_zone+0x18/0x30
>    get_page_from_freelist+0x780/0xf78
>    __alloc_frozen_pages_noprof+0x1dc/0x348
>    alloc_slab_page+0x30/0x110
>    allocate_slab+0x98/0x2a0
>    new_slab+0x4c/0x80
>    ___slab_alloc+0x5a4/0x770
>    __slab_alloc.constprop.0+0x88/0x1e0
>    __kmalloc_node_noprof+0x2c0/0x598
>    __sdt_alloc+0x3b8/0x728
>    build_sched_domains+0xe0/0x1260
>    sched_init_domains+0x14c/0x1c8
>    sched_init_smp+0x9c/0x1d0
>    kernel_init_freeable+0x218/0x358
>    kernel_init+0x28/0x208
>    ret_from_fork+0x10/0x20

I would strip this report because the call chain is simple and there
just one so it is not one of many and hard to find.=20

=E2=80=A6
>=20
> Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in def=
erred_grow_zone()")
> Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

