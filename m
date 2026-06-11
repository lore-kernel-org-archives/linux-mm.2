Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEA1CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD376B0005; Thu, 11 Jun 2026 14:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789936B0088; Thu, 11 Jun 2026 14:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0E76B008C; Thu, 11 Jun 2026 14:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59FE66B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:38:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D51ED4073D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:38:38 +0000 (UTC)
X-FDA: 84868492716.22.584A034
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7326540013
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:38:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rF23bd60;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781203117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUdlGkzKFN7o/rC9cZiInRzDt5Z1+4QcE47ldQflma4=;
	b=ZyzsuLuRZAe4ie/VhVjHIirmL8SWq/H6GhkuU7pERM6mX38QD5T0jJeGdB3ZV1KK03FCvl
	tcXBTidQFxHYzJTL1ZblrvmOwguoO4P4tPcxTahBhu8j1KilS5w064YKDEliH3MmdL5oeM
	9/6/Q6JGsSd7Xk43LElK/8Bm/5L5lpw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rF23bd60;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781203117;
	b=Hn5emKtLNS2kKXpd39utFHlaFc3RWatlEe+SJECyDCyUv9/uHwvNKmuJs6xR8nQN54J7sg
	t7FHhzUtsBekpFYdAYin33NC1p/n+2W8aG2Tkwhhk7ICHbjk/ftMyjhAvvj8Gu8GnvlnD0
	QBnXSdKyFcXkxVbU/Jj+GR0RsFQkXjE=
Date: Thu, 11 Jun 2026 11:38:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781203115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gUdlGkzKFN7o/rC9cZiInRzDt5Z1+4QcE47ldQflma4=;
	b=rF23bd60ZymsK5QOFQeX7MnNX9bdth8T6ddsuGmNrpuRK07hAhUClZLhpD16pW9c5+ANCw
	UY3F8hf2W29QRlhdO8MfG+il1dJX0ssI5Wa7kHCPYP8deIXdz/2RJF2TVvg4tAi/zfuI2l
	nXv/P+CGt+oeMjL2ab+/xIeQZTdb3Cs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Zenghui Yu <zenghui.yu@linux.dev>, 
	linux-mm@kvack.org, hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	qi.zheng@linux.dev
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at
 kernel/cgroup/rstat.c:421
Message-ID: <aisAd7IGVtCCEbF4@linux.dev>
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
 <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
 <aimbPCBloe0Dqk7t@linux.dev>
 <CAKEwX=PyHr+9wiuohixv4PHEtyvt8uD2j45JGQdN8dzn7UgkXA@mail.gmail.com>
 <ainb3W_-i5ish_K6@linux.dev>
 <7ia4tsr9lye0.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ia4tsr9lye0.fsf@castle.c.googlers.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7326540013
X-Rspam-User: 
X-Stat-Signature: 7m3tttq9n1mey87wyszftzo4auhw1u96
X-Rspamd-Server: rspam09
X-HE-Tag: 1781203116-907267
X-HE-Meta: U2FsdGVkX19p75Hu4PHugHeQPbLFwDFcR1z5oyW/j1chlzsXueWDKYIvuy1iTOMqM01zyhA5dSFnumM6TzoEC1K3LW2gGVjb2Hw3FtDbNKkJN66msxpyX5b0k0gGyxeU7rpM14+PQ4K5JWey6Ib4cSlrvyDx6FJ7JXWjH1UxNSBh1mmuSm8Bu5Lma5rCd2gGbzIHE0A0EBGrYqYEyCH4e9Mrzb9O9NIYmOVqqxw6dS0myVEJ0ekw06UY3QFqBKwfuzDDVhBBaeZgNBpOaLZTj1wFWk/zP/OMfcvJMhfTF4ZExXiT8fZydnX7Uq5ze2QH0HbLavbSIYFXWTtY+PNYmVKnI+1ljR8L2VxQ7wk41aRHiRQLaJusx69g/zI5mW9wZOuZxxnbGlDQ/kmV+xwuiS4W6j2ME4TMgLmThG40oc9unnSuUp+CwgykpWLu/sOgrKEpQcAIHnqzFs/BDLqtuFOz73l7yRnDDIdfCfb2wdDEd561633yVLNCX55yip33f33aIOJ4wRp8clzlDtjGArvqlks8LolqKcZ5Upzm98V4KBiNotzyegxFhpHiB/sSZzSwPA5KwpgSucNPz+S2X6qBJAILE2CEIuFpr7tFvV7vT0brbtpk8neixTE/3unUPJZZdZ9JdPTe0PlX+AQmdeTaz5AbEvo3loRqC7UiX/rXy7i1mG8T2CTRQ5pVw4muYoGKfnmLTqpdLcYujJfkl4xDDyVAqvdTNIYGQK6Q5jm66ei0GAxfN/0JLM+872M8umRN11XwQ+rhZn9TEj2siYUWLWLx4KiuLQQvIhxCux9c65tTpxHXtBZILUjWeiE2vPPmqFvFrjy3WTXuAMY72f8xGSlLdTtEGonkLxzZ/KOYkmi4ATzwYIoINX7d71X5qbOJL3zAaZBAl0B+6w1WVmp3C6BknCQrpLXsch1NjfQgoVi+Y7lY6M5Reqp7Z7lxAX+Z+MdVu+Dp7vPiU3G
 3pT5t6LH
 wi6/b0xYo0WqT43Mk+bouSZr0RCBmtpMC7fjVQXJYROW5yT3B4OWsQgfqLld8B6qqli6063rH4ywzRL85Uzc7Ep6yHvOK6dKkWjcWZU64z/xMhWsnS+NM6KbB+RMnBAC1fFgWRJApLBGgALQOYj/KknzgmPPz7PEz9AOvPg8YdYUFnB7Z1AWc7kuxLl/NX/kRe0Hn16TTwp75qRgwsDeZ+DDkUOfQeBeAuEBU5WS0xgfjweva8N1qDttqcKu9oHN/bu4mlRkeR7IuHygW5hCoKHcmHceVc4rTvC0zjqctBuFxynDy9k8FJg0uXWFyH0m427n7VofzNgrZKdoAAAbJzFE52isWFQGAFDGKvo8yGWHTX+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:34:15PM +0000, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
> > On Wed, Jun 10, 2026 at 11:38:29AM -0700, Nhat Pham wrote:
> >> On Wed, Jun 10, 2026 at 10:31 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >> >
> >> > +Roman, Qi
> >> >
> >> > On Wed, Jun 10, 2026 at 09:38:03AM -0700, Nhat Pham wrote:
> >> > > On Wed, Jun 10, 2026 at 9:05 AM Zenghui Yu <zenghui.yu@linux.dev> wrote:
> >> > >
> >> > > Thanks for reporting, Zenghui.
> >> > >
> >> > >
> >> > > >
> >> > > > Hi all,
> >> > > >
> >> > > > The following splat was triggered on the mainline kernel:
> >> > > >
> >> > > >  BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
> >> > > >  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
> >> > > >  preempt_count: 0, expected: 0
> >> > > >  RCU nest depth: 1, expected: 0
> >> > > >  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-00056-gacb7500801e9-dirty #304 PREEMPT
> >> > > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
> >> > > >  Call trace:
> >> > > >   show_stack+0x18/0x24 (C)
> >> > > >   dump_stack_lvl+0x78/0x90
> >> > > >   dump_stack+0x18/0x24
> >> > > >   __might_resched+0x114/0x170
> >> > > >   __might_sleep+0x48/0x98
> >> > > >   css_rstat_flush+0x54/0x564
> >> > > >   mem_cgroup_flush_stats+0x9c/0xb0
> >> > > >   zswap_shrinker_count+0xe4/0x1e4
> >> > > >   shrinker_debugfs_count_show+0xd8/0x268
> >> > >
> >> > > Ah, this seems a bit tricky.
> >> > >
> >> > > Seems like shrinker_debugfs_count_show() is invoking
> >> > > zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
> >> > > triggers a stats flushing, which might sleep. Not ideal.
> >> > >
> >> > > Is the rcu_read_section() here to protect memcg or shrinker? For
> >> > > memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
> >> > > memcg before returning.
> >> > >
> >> > > (memcg maintainers please fact check me).
> >> >
> >> > mem_cgroup_iter() handles the lifetime of memcg, so there is no need for rcu
> >> > read section for memcg.
> >> >
> >> > >
> >> > > If this is for the shrinker think this needs to follow shrink_slab()'s pattern.:
> >> > >
> >> > > rcu_read_lock();
> >> > > list_for_each_entry_rcu(shrinker, &shrinker_list, list)
> >> > > {
> >> > >     if (!shrinker_try_get(shrinker))
> >> > >         continue;
> >> > >     rcu_read_unlock();
> >> > > }
> >> > >
> >> > > But OTOH, doesn't seem like rcu_read_section() is what keeping it safe:
> >> >
> >> > Shouldn't the caller already holds the reference to the shrinker which it is
> >> > giving to this function? Does debugfs file entry holds a reference to the
> >> > shrinker which it is giving.
> >> >
> >> > After looking at shrinker_free(), it has call_rcu(&shrinker->rcu,
> >> > shrinker_free_rcu_cb), so this rcu read section is against that.
> >> >
> >> > I think we can simply use shrinker_try_get() here as Nhat said.
> >> 
> >> Hmm, so is this unsafe even with the current rcu shennanigans? What's
> >> stopping shrinker to be freed by that callback before we enter
> >> rcu_read_section()?
> >> 
> >> Seems like this is just implicitly correct - shrinker_debugfs_detach()
> >> and shrinker_debugfs_remove() happens before call_rcu(&shrinker->rcu,
> >> shrinker_free_rcu_cb);, so if you're reading this file, then it's
> >> before shrinker_free_rcu_cb() is even registered?
> >> 
> >> Do we still need rcu or shrinker_try_get() here?
> >
> > I think you are right that we don't need rcu or shrinker_try_get() but it is
> > more about an active debugfs file reader. Suppose we are sleeping within rstat
> > flush from shrinker_debugfs_count_show() and there is a parallel
> > shrinker_debugfs_remove() call.
> >
> > shrinker_debugfs_remove calls debugfs_remove_recursive and deep in the stack
> > there is a call wait_for_completion(&fsd->active_users_drained) which will wait
> > for active users, one of which is sleeping within rstat flush.
> >
> > So, let's simply remove rcu read here.
> 
> +1 to this. How about this version?
> 

Thanks, Andrew already picked up
https://lore.kernel.org/all/20260610232048.62930-1-shakeel.butt@linux.dev/


