Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8018606D2DA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oyWNj3a1
Received: by kanga.kvack.org (Postfix)
	id E52FC6B05CA; Tue,  3 Nov 2026 09:54:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B196B05CB; Tue,  3 Nov 2026 09:54:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68936B05CC; Tue,  3 Nov 2026 09:54:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B47CD6B05CA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:54:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FE6C40451
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:54:41 +0000 (UTC)
X-FDA: 85394104362.06.01910D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92E88A0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:54:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oyWNj3a1;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOY8crhkUmo/P2M0E7e/arrqNxJQQuOOJdNxg87jljQ=;
	b=Pxpj9ADJKlT5/lJDZ67NzuxpvWhjA8d7KFHlnpKqLjOpXnWQhN2/2XATavG+YJsz588zvu
	hHnfoKriwHBc+A9HwHjRTwdk3B+7FPDeWgIh7rxIMq0lP4ghQVU4utQ3lJKGuiLH6rytwU
	n9FGfRj00wY3d+DEDOzrpprnZlQG33o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oyWNj3a1;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717679;
	b=p92ZRh1BROLpnyERWgkbWsXdoZ0O6Gh1OBNh0OdNyfGshRlYq3z/3H7OENJPIhOdU8tzwc
	pp7wjcMpmgfI3WDLNCCbL2W885o2Mfe8LAqaLRuLLetENzwg6Uaujz9DRqhZFigdlw9rhL
	sXOPftpgx85DtpKkWNngJTkvbQb4J6U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7A5B41650;
	Tue,  3 Nov 2026 14:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8FD1F000C1;
	Tue,  3 Nov 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717678;
	bh=qOY8crhkUmo/P2M0E7e/arrqNxJQQuOOJdNxg87jljQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oyWNj3a1vVxuIaAVTUBnHRDIMKYpXa1HPYC0kYU52fKugBKYDBoEpGgu1FOg5S2nE
	 HknINThy2NsIwEGZPkkcQaxa8AurBfZBaio4B6QqlNwqmjH6yX9jgEPE0+N6GF22I1
	 OqQpcPNmz8/GNuFd+bwEB37DAzcA7IbFNo2r24XMQ8/ZCkeWrXUcUaiyeDAtnoKiG/
	 vy+O0FeEBAsB3znZI35TWlV2rOmHRbhqOWgP8dKJcoEfsh10aNP2CbaR2BSz3+0pFA
	 jN7p/RDuVIz41iQVj/ZjD0jKh4uUA5hg1ZYjK2XDuScMiXZjWzFX8Jx/QtzX/DcDK+
	 KzrG84uQHXIrw==
Date: Tue, 3 Nov 2026 14:54:36 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] mm/memcontrol: do not drain objcg stock when
 spinning is not allowed
Message-ID: <aun1FofGFtjPjQHy@thinkstation>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <20260624-kmalloc-nolock-fixes-v1-1-fdf4d17351dd@kernel.org>
 <104794ff-9f04-48be-91e8-89d5d2269f95@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <104794ff-9f04-48be-91e8-89d5d2269f95@kernel.org>
X-Stat-Signature: xnxwctjjupfxsfqgimeaysnky8uk6c4b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 92E88A0009
X-HE-Tag: 1793717679-627393
X-HE-Meta: U2FsdGVkX18/ogZ+R+IBOvJSAdQaXQzdrhhH9X0pLDU5w9V0tCtse/H5F2m0mPqTcqa2ApXdO884H6GjXJhFe+L/VnXHCOyRCoEhHgncMMT/RXsJIpEU/0Iem2PEdJwQDx3Nkfm3M0vxXwHmXyQ89U1dz0HNmeC/RczM8HJa9WND6sGQGg5AqV2jUrQhFg251injODCsYkcchW3xenzqoB1wQDvxhNaxr0Lks7MVNcAt+YnZB5H6hZzL/lzrw6ukUu1CfDPg8+A63MBbP7qJkMSoLMpVY64uMy72iFStVfpdz9+o8dOoCbpGVmgjKlOXPsjmjhcmhVY6Ei2bBbNi1PghaL0ONB/Y1by+HXSR382aqcjI6/nvC1MdYni/MVCNP8QWvfZ+vYMRCdiaBX00WR9MxRa5PXxT28oRtcdqwEc5Dpm9o8cI/+McNF2rQUf53ao2ibbprdn9eM5JKaNmDfsPDpbCjf+Un9j4DRxrH7ZBOjodfNkVXaqgL9ZVV+/MlI2gV+NDR6JyG0I+gz54++kDnOitAdWvImqDTPPwhT7THNI/mVjDAXBgmgP1lbL+G2mtd4Hgb3KWRprRSfsLoPHSJ3N2BfhWHW2eYoCYlZoHT8gYjVAnATSdi54AZlrpK52mszK1rCFjvB6egMQFu8GjNuPqNhHdBg5O3j4LthlPBorFY4FV5auKUru6I0KBaX8sQYMBKSx2oKf8EbibRaxB1d3hsT/DgTKZ5MJhx4pN15oikRIUq1gmeQ0fgcj4zAto2B4KiO+FnxhMR5udHMCZct67/U7be6+Fsgt3bzJRgWYQ9W0ua8qFYvbVdcZBfOix8/lSA9zgGZ+c5c4vvoD78NQJHawsKABc/RlwV/N2ha5tryy5wdddqs3m/PC0veAJ/mJpL//qFlWDfADT9IlK+CELNitcHBjYpS6WHu+bL6VwvrovzG2oNDD24B/TaQomdahNt0KZDlm8yBE
 Dr64NSQi
 5A5gM2hzkHnyodXh6nnatu69HSKSDhRzIHsnkUk/lb8PZp1+GhFS0UqsICog+7mqsyQDbkQQqVKhOG2YJV8vm/TRM7ofC3P93nvzDCoLn0Wb1q6khLB3vzPMKrO7D2/Skv7BW6APW4saAp0cmk5dZ6BakF88gTF5/+C7mXgKToMagBjY7Wakmgv0KoBagEgfSN+Q8BcaO1l7bVpC6HIXJqCSl+boZ1nIK7ljq53FpFduK6vx2M7QpFSbwLjK/+/Mj9YVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Jun 26, 2026 at 04:30:48PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/24/26 15:11, Harry Yoo (Oracle) wrote:
> > When kmalloc_nolock() drains objcg stock, the stock might be holding
> > the last reference to the objcg. Since obj_cgroup_release() is a
> > callback for percpu refcount and does not know whether spinning is
> > allowed, it is not safe to invoke obj_cgroup_put().
> > 
> > This was caught by lockdep on PREEMPT_RT because acquiring
> > a sleeping lock (objcg_lock) violates lock nesting rules:
> > 
> >   kernel: BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
> >   kernel: in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1267, name: systemd-resolve
> >   preempt_count: 1, expected: 0
> >   RCU nest depth: 3, expected: 3
> >   6 locks held by systemd-resolve/1267:
> >    #0: ffff888a8165fa20 ((&pcs->lock)){+.+.}-{3:3}, at: kmem_cache_alloc_noprof+0x185/0xa20
> >    #1: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_trylock+0x74/0x2a0
> >    #2: ffff888a81648598 ((lock)#4){+.+.}-{3:3}, at: trylock_stock+0x118/0x380
> >    #3: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: rt_spin_trylock+0x74/0x2a0
> >    #4: ffffffff9658a4c0 (rcu_read_lock){....}-{1:3}, at: percpu_ref_put_many.constprop.0+0x40/0x270
> >    #5: ffffffff96af11d8 (objcg_lock){+.+.}-{3:3}, at: obj_cgroup_release+0x8a/0x410
> >   [...]
> >   Call Trace:
> >    <TASK>
> >    dump_stack_lvl+0x8a/0xe0
> >    dump_stack+0x14/0x1c
> >    __might_resched.cold+0x233/0x2bb
> >    rt_spin_lock+0xd3/0x410
> >    obj_cgroup_release+0x8a/0x410
> >    percpu_ref_put_many.constprop.0+0x226/0x270
> >    drain_obj_stock_slot+0x27e/0x8d0
> >    __refill_obj_stock+0x409/0x6d0
> >    __memcg_slab_post_alloc_hook+0xa45/0x1500
> >    __kmalloc_nolock_noprof+0x988/0xc40
> >    [...]
> > 
> > However, this is illegal in !RT kernels too because the objcg release
> > callback acquires a spinlock even when spinning is not allowed.
> > 
> > To fix this issue, fall back to atomics when the cached objcg doesn't
> > match, but it is unsafe to drain because spinning is not allowed.
> > 
> > This is expected to affect performance of kmalloc_nolock() since
> > it can no longer drain and refill the stock and falls back to a
> > per-objcg atomic counter (objcg->nr_charged_bytes).
> 
> Maybe it's not bad that the constrained operation will not do a drain? Could
> we say it's likely that both _nolock() and normal operations will likely be
> happening on the same cpu for the same memcg, so a normal one will soon
> handle it?

I ended up making obj_cgroup_put() and obj_cgroup_release()
safe to call from any context as in RFC it's easy to overlook that
obj_cgroup_put() is not allowed if !allow_spin.

-- 
Cheers,
Harry / Hyeonggon

