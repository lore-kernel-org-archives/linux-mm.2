Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF8EC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65AC6B00AB; Wed,  2 Sep 2026 06:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16996B00AC; Wed,  2 Sep 2026 06:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9533C6B00AD; Wed,  2 Sep 2026 06:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76A8E6B00AB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:05:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00F5840159
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:05:23 +0000 (UTC)
X-FDA: 85168389768.10.AC03748
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 73B6D4000E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:05:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XuUW4AFU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788343522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vWQxrJHayrwwhMkde5WNO4SONhqD9HgJXyCKA+9EN4=;
	b=E2IK9M1v0fzZTcppVB3KFSYDVNYBhCVrTTvVbEqyEs48YI20b9EylsIOOlgPrgjP9Kqt9P
	3DSahF27IFBzJUXagPQEj2dHhncCsBeFYCUxDvSWZAGx4acpzvHXQBWL6LqQGus8spIB2A
	0D0rB9aVJJ6Hwgr9lam7BFAy8K89t/4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XuUW4AFU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788343522;
	b=bWBkztGJ0BBP/aA86om/WCJwecG9KRHY1n7/h+b7ZUdlkr8DjT9BjEAITubplWki5b2+sv
	q85RTuTNcEbe4j3MPYBD0dMggfa12EhbYxKAU2mRnNEG5vAfyM9OHvmRL0wRAbq+aI5QmK
	WUGHxyK5SV5nLvlmUuWjEBgaYPac2X0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99757602A8;
	Wed,  2 Sep 2026 10:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14B21F000E9;
	Wed,  2 Sep 2026 10:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788343521;
	bh=8vWQxrJHayrwwhMkde5WNO4SONhqD9HgJXyCKA+9EN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XuUW4AFUy2dwHWVZf12krJbN9Ni/p6KdoXKlSOpUg42W5KpGAQwTxfimPF3TPllJ0
	 6uQbZkh5TYAx0j228akBJyGcEcPjzkmp2GTnDZHYNqte5BnL/vW/TMKAlYjGHiWbEp
	 WhDPsiiQ5uSkyp4oHeUlhrwstVsEpTthDvbp0zO8pH78F88UsyGBxMtb+W2PUD2+0V
	 9A65BzsNs8wr7gvoFG/bUken5QZPbXpZtnQSwSokJZ1IEHFG4E4IvIkCIJa6FyV8LL
	 tAvxNarFvgv6cuOrMyxT8vzFGOmEegIyQCAA3s1DR5VmOrZqwYu4GFmf9KOIemEDsV
	 y9R2aBMcHi6BA==
Date: Wed, 2 Sep 2026 11:05:18 +0100
From: Harry Yoo <harry@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: ThangNN99 <ngocthang2710.1999@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, syzbot+acf142088e0182172e58@syzkaller.appspotmail.com, 
	ast@kernel.org, puranjay@kernel.org
Subject: Re: [PATCH v3] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in
 kvfree_call_rcu()
Message-ID: <apfyeYF8IE03aazT@nixos>
References: <20260831130057.HLukQ-zm@linutronix.de>
 <20260831133222.8637-1-ngocthang2710.1999@gmail.com>
 <20260831143500.x-saxdAs@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831143500.x-saxdAs@linutronix.de>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 73B6D4000E
X-Stat-Signature: 87eiohhe1cwx1h9jje7roz5ncq7w4t98
X-Rspam-User: 
X-HE-Tag: 1788343522-43663
X-HE-Meta: U2FsdGVkX1+EfKzLxiEW70eRbDWQVL2nTtGylXNrPDHp7k/ecHnIH870O0CvGqAWEn7gqqCRByDePbkwNk/SZxGyrWFFi0wPw9YXojl9rWb0BKSBLs9z8oqvKCQnyknQ5eKrYy7dxiSh1kBfSe5bSZ7PoIqH+wMEkFt76HOleqVPAMuwEbZOR0G7ug7PqNgpyJJb57aGBheuYMdFERuE1Zfpn1uv4CrmREx6Fgg6xYBfUwH57GI85Z1iR8TAunvgKSEdf5JAsXSiESL0cC7X1O7/nmOgFxc8OPZHhyHZGsJR/IC0+n6k7BHgziI00T+VzUdKFOOUHUijXBICj8IvwC9yAACJmNQ8hs4pb7iX8u6gfe+cBSuD/UegKt3VHRIHbrBD9/HTAoIYeoc2ODl8ag3Vha5sRM54Gac6LG4BIHOPBZpQzwnmYuYGFkaAxiA2mHfvNmI/ZBuIlhmY/e0YXnBy2Jz4Y9Bp2kmg3xo4p3Aroe2T80C4tUBCK7/ODZE2psty8oheFpGIh4u3OYZd04EsKWquQHrsAZQuQKEUZ42QdbpY5l7T1MlgAzy7d7LBVsUDjl7uSuS8cF3k0miVTeoxl7o0IKWNmJXozykueIK7MFiXutaH5hi65fLzseTpNi7uDuQu2MxJjNtwhhtbvEMmiQDihEZN/RvngRX3c+e7ELOdVPMFU/y46SDn1FpsJi9fn1k+DyOdBQnK5B5I/KvU/jCfG8IgYqPZy1tRO5JpCFXvLAbc9N5WdamEheHfTPj+Ox6Aca07qeWWi8EOYsCZzAKeWbIf5r7s4DJ5PeYBdGS6LiQBfxmMJ1xQahI0PWXyV2tmcU9QtM7PNeWSJQsbT2JYwK1J9Hvh+/clQrB0WtJh+2oMeiKIQxNtBsoj7+pIgcu/MgJ5Uk6iFS7A/r6N/BfV4hqp6uBqVIvLuNzNlm3tTyGZ4eUQ+hsk5GpLsRgyrtcwrkxmthpNvxA
 /ru6/t2C
 1Nr/CEU8DBfUVPqKTfDgHBUw+DAue2BpNPW4BYWtMSa0Mz2TxTbJTcdePh2AokGA5XqvuKe1U9SDJe7J/grM8fSoIzYWtMfKl583qvypHmhzj/RSNgeQCaPvudHRJSTDaByaeySecI8WUtwp22uglzrvRX8ov2sQh2PGPg4IGaW9nXI3VSl+ipQbY0kjqLtmmRjfieS1IUktViNQN7DhkV44dvo6B02F34yMpBHscNmN6Ko+veNZOrR8J8pWR17ak5viI3Gg9haJRMVxl1lW7KYcFnqQvgEI8wWAMWllxChPT8eMH7wiJcVeRnuDxr85db2DUxdTYHDiRdTR2rZQiLXdbt+OlPn3py//k7qPe4R+U3vzEzQ1jzhXLm61mmi5CuM861pluhjvQZ30mwrnNQCyIHVYu9zfoyWin1C349BtAYjhSCm5GbPSlPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 04:35:00PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-08-31 20:32:22 [+0700], ThangNN99 wrote:
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -2034,7 +2027,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
> >  	if (!head)
> >  		might_sleep();
> >  
> > -	if (kfree_rcu_sheaf(ptr))
> > +	/*
> > +	 * Callers may hold a raw_spinlock_t here on PREEMPT_RT (e.g.
> > +	 * set_cpus_allowed_force(), whose callers all hold
> > +	 * task_struct::pi_lock), and the sheaf/barn locks are also taken
> > +	 * as blocking locks elsewhere, so trying them here creates a
> > +	 * lockdep-visible ordering conflict. Skip sheaves on PREEMPT_RT.
> > +	 */
> 
> You mix up things. A raw_spinlock_t should work in general and should
> not cause a problem. The task_struct::pi_lock is special: It used during
> wakes and the inner waitlock of the rtmutex acquires it even during a
> trylock. For PREEMPT_RT we don't want to acquire any locks while the
> pi_lock is held.

So... even can_spin_trylock() is not enough handle the pi_lock's
special case.

Probably we should make can_spin_trylock() check if current tasks's
pi_lock is acquired, to determine if it's safe to call _trylock()?

> What about
>   
>     kvfree_rcu() is called by set_cpus_allowed_force() with
>     task_struct::pi_lock acquired. On PREEMPT_RT the local_trylock()
>     usage below will acquire the waitlock which must be avoided.
>     Therefore avoid it on PREEMPT_RT.

-- 
Cheers,
Harry / Hyeonggon

