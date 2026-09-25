Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82FABC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 11:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857716B0099; Fri, 25 Sep 2026 07:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F916B009B; Fri, 25 Sep 2026 07:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744E26B009D; Fri, 25 Sep 2026 07:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 501B46B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:05:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C498FC0573
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:05:54 +0000 (UTC)
X-FDA: 85252004628.11.5B1D763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 380A5C0008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:05:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=meYS47Io;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790334353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27mmdRe0c97tdgwqbWs0K9g6YrSbSDeo1umZRUDrFfU=;
	b=dswRzePxoWqT3XmyJMSARzgp0fUij7bRko3BqI5XfYzzSducsuJBfgt4IULwAU1aXzKdp2
	BElrzxL/4NmnuyjMBCyJOSnlQO0+iZF8siIrvXlBWQaRwAf4WqHlJAlfuFq43ob9n/MpSE
	lRx8puVOqgIutcRsqx6auXSIk8Ws40g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=meYS47Io;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790334353;
	b=KUGWj1SJBhQioyiFhkzhlf5frUxBEIZbmrNxFuRixFwtoAIsJYCTLpEybGHrxxON8wKXNt
	pDdaiu3R203FER9R6GFm6sn54C59XY20GHqjYfB98Y+SU0OsQ3c8t2f6F7XOftBzDWrejj
	eU90jMDy0hs6ehf9XgtySu6RJ2p4wQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4F3B60136;
	Fri, 25 Sep 2026 11:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCDF1F000FF;
	Fri, 25 Sep 2026 11:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790334352;
	bh=27mmdRe0c97tdgwqbWs0K9g6YrSbSDeo1umZRUDrFfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=meYS47IoTaFKQc6f4C/nVr4qaaju9aGhhYFXiJo0fHDir4+QAKlQsl+Egv4c7OSwd
	 umEFQlktLCJ9Mwq0ZCKOjdVV2tEzaNMeOHrMj+i547WlbrgYNnNVZy5JeWrcjz0qF3
	 M/N8n/arCSZHAzNQeG6baKscn3Ks/tPyCb8RSu41N3X+o/8SOnSqM/DabrT+iRJyrI
	 VmEWktPKlPeuRkJ9YQDThxJ/fa2OZW+ESpzcIQ5I0YT7ElW8xfsEWzR5dwRjTP0zdK
	 Rt3rY/Y4YAk09pJ7knDgd9SpSJDN3n3+J2w81RCNBkosK/8uPN1rq0P8PZSoG+Vf7N
	 O7epnMVRcYjgA==
Date: Fri, 25 Sep 2026 12:05:50 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Amery Hung <ameryhung@gmail.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible
 context on PREEMPT_RT
Message-ID: <arZVV6Vq-ZJuCyun@thinkstation>
References: <20260919171443.90512-1-kmehltretter@gmail.com>
 <DLJHZEZMLW0F.27OPPS218CX9Q@gmail.com>
 <arIY0wMQjCCsqidI@gmail.com>
 <DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com>
 <c2f8eb01-7a10-4ccb-92f1-eece29c06cd4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2f8eb01-7a10-4ccb-92f1-eece29c06cd4@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ikey4fkarpuigiw6xh83i87d7aoabw6p
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 380A5C0008
X-HE-Tag: 1790334353-968762
X-HE-Meta: U2FsdGVkX19XWhkzL5Kdwvf0bqIKzBWq5blPtFUn0kzhYZSletmu4pKoTf2BBm1uOWKPsUN5hs1NhlWbpyTIBNUpt220eQyJ4CvEZUyMWa2uNWyqClDJsOAW9vvRR5wzGLxD0/AjS0YB61k+2Se8W5h0s4vvu0fWjcBa6/CWIFtqKjiZiPZ6P+gSEUxgQocU0ovc/Qr49EVT+1Px58JuoqArh+NVXRqGAhP9P5TcXqs2j0Tc6tA9EDLm6LdTYFQa3xdYxNxd2kCE4UCYJMh7WnkUX3RaxZaBbR/SlQ8SD1Lc2+4gtPjbyImaEGmt5Ta/D6y69RbAJYGYbbovZu+HNlvuhKR/WNvK1d/h1y2incsQN3PtqV4HHX+ljpJzomscou2JwQMkaOWrSHxGSea1UWzkd4lyevsIYlzDZSIW2saUhDu6J/SRRsT/H4DFnHtJ01w8XEuJPSM2KRjRXYT0gCF/jCz4bkDi5IKY2r3nCwA1B3HUEQyIwLVJ6wZVJKcmCBOAAQdMn1EMxtBfo6bee0x8OadxlNYYf6/ODoljzpSq5DWlPcViYqIqwuxqmstLWzUCqFTKPOFc4zlBLYwyyNBVfE8okagQz9eBIZkRfxIpggfIR8sx/YQy5icNswcZRH/EUwv9uEejyeIhM0o187kQcM8fstuo9833dgc/twvDTsKlolGAUjvzbI4QPA+nisckn+wSDSKaaIIEJCv8UqUBGt3SX/3XCpWb1GwAUcbNBHauGvTarZC/1xUeexOmsvWWYXBxyJQjJb8pFYHt9rcasB0EDGwoTSGenjGt+EQBLKfgNIGvT53Bzo32knDSRinP6LSXu/2dww0NYpgHxSdJEojHeIpggBihBvzEWmVfmFTlTSWf99UvLUVjnqwuElMWH5ucqI8AecQ6vwk5SZKHY85R5izXM9S/DDTyfYW2q/iFQrqpcpXCVCV0s6es7mUZtGgMw4pN+Upe0bS
 g2XwW072
 hUTukdY4YrrUp/7/biTplt4hMJIYfIaJ6oxSHUdoXACdgYsEGsqXzOn9yz6A//MXeWfd1dwdWvQHHQxIsk+nIoV2J+6pvnW1LDH/svMk+oIIfQ8/klZBZRkdClE7kcSHk6K71mCGBJfLrXs/anQNqH4122DUz74UPLhOffcTtzFEE30Hyqi4Ua7p3E5wMsO0A53JGsmFQk8WDMW61opj1FVIJ2XWCue+G3vLc4nfsrST6Sje1qRaD2ZAHkeGVQXXElvNNmCipeRSJTCUU+gqAs0ComItUHM1m8CjtZT3my1p4+cTmFf+5+pYuLYLDjCAUmpQubjop8uRHu9nnd44Q3DnwjPZCdc4mgWFV76MR373lDuEEpmgUy3SYGJXq5oEmJ7azDs0NtdiV+Do=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:29:16AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/25/26 06:12, Alexei Starovoitov wrote:
> > On Tue, Sep 22, 2026 at 08:04 AM Karl Mehltretter <kmehltretter@gmail.com> wrote:
> >> a) Change MM so _nolock() allocation remains safe and can still succeed
> >>    while pi_lock or an rq lock is held. Existing BPF behavior would
> >>    remain unchanged. Is this feasible, or would it require substantial
> >>    allocator changes?
> > 
> > I don't think it's feasible. On RT the sheaves lock, n->list_lock and
> > zone->lock are all rtmutex based. When trylock succeeded and a waiter
> > showed up rt_spin_unlock() has to wake it.
> > 
> >> b) Restore BPF local storage's dedicated allocator, and document, with
> >>    debug checks if possible, that _nolock() must not be used in those
> >>    scheduler-lock contexts.
> > 
> > No. Local storage is not the only one. bpf_arena_alloc_pages(),
> > bpf_stream_vprintk(), bpf_task_work_schedule_*() call kmalloc_nolock()
> > as well and the same sched_waking prog can call them.
> > bpf_mem_alloc was removed from local storage, because it wastes memory
> > on preallocation. Same answer for d).
> > 
> >> c) Have MM detect those contexts and return NULL. This prevents the
> >>    deadlock while preserving ordinary raw-lock callers such as arena,
> >>    but task-storage creation from scheduler tracepoints then fails
> >>    deterministically.
> > 
> > This one.
> 
> Yeah, but how exactly to do that detection :)
> 
> > bpf_task_storage_get() with F_CREATE can return NULL and the progs
> > have to check for it anyway.
> 
> e) Introduce raw_local_trylock_t...

+1 on this :)

> >> Are these the right alternatives? In particular, what behavior is
> >> intended from the _nolock() API in these scheduler-lock contexts?
> > 
> > It can be called from any context and it can return NULL.
> > That's what it does from NMI and hardirq on RT already.

-- 
Cheers,
Harry / Hyeonggon

