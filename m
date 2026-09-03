Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E7FC624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410A96B0099; Thu,  3 Sep 2026 06:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E81F6B009B; Thu,  3 Sep 2026 06:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3286A6B009D; Thu,  3 Sep 2026 06:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ADB86B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:56:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E809A049D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:56:23 +0000 (UTC)
X-FDA: 85172147046.10.DF6DCA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD15F100002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:56:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nE25zrDk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788432982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIWveMhOAoHYAD0EUwg0iSZcCXQHKJJVLy7Pa9YbeDo=;
	b=2YWiAjJeCkYYnkODFvBJxpP+ckQvWq2QUqbqRmV4x9f8snZcPysRuwLuyFyFG6VrqKHeyZ
	JnY6a0zOY7/9XGWXt3jh3nYAS5VWa3QGu+IYV/cdzc/NvdZLrdTh4cvr9YCOkSVmYPbnTh
	h0vNTjD/fBxzpuE1UeYwQpUOZbtkpS4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nE25zrDk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788432982;
	b=E5xyDiolmGDc6/XlFvppferViQyhky1hV/XgybzxR7kB8p7GEovEz0/SQ4lWLfebqzN7gU
	W0LKQNswZifKEydh9hGOY9lE+h6GNPiG0lTqTwyx10RshpCRuQ2W23AUv9meLYtFx5OrmN
	5fiqpz4rLmWs9hSgNCw2i2xsdeqZFzk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17762401AC;
	Thu,  3 Sep 2026 10:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD961F000E9;
	Thu,  3 Sep 2026 10:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788432981;
	bh=JIWveMhOAoHYAD0EUwg0iSZcCXQHKJJVLy7Pa9YbeDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nE25zrDkEckyWuT3vwLQsJeReMmcAf/bRxyofcE5mdga5EtNZHwqWEr/AoIIa4Xfy
	 LB9cJGXOheduuQXaEw1urrWpCwgZpfrHUa0ddVqnae+LblvwVpobWbtmq81NaLg2Q7
	 pIDUG9Tgz6EYEqZYhXEboP9FaigUBaO1KUIv1ZE8e8Oo99fWytzoCliKnnpCeQN9qs
	 P8qjqSHGdCGEAo/TS02CDm4Qg/u+tX6R1H4RMzepfNAnSWt9fTU5hldmygkm60xgHf
	 C2sUBBz7sjUAXtNOePkQO9AuhWwB9uLzPYuc9T6KINyIKLXou5Gekmff1MV2dWpIfA
	 FkCiLVUhC+qsw==
Date: Thu, 3 Sep 2026 11:56:18 +0100
From: Harry Yoo <harry@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulmck@kernel.org, 
	rcu@vger.kernel.org, xialonglong@kylinos.cn
Subject: Re: [PATCH v2] mm/slab_common: fix shrink budget underflow in
 kfree_rcu_shrink_scan
Message-ID: <aplKpZt3r57_7_yX@nixos>
References: <20260826075653.3304251-1-xialonglong2025@163.com>
 <apQsbGJDPPyXcn8R@dev>
 <baa22f03-e553-46cc-8c35-436363546605@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baa22f03-e553-46cc-8c35-436363546605@163.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9rwgx3qctrkwo1y4m5pwoe3ax18tf7cs
X-Rspamd-Queue-Id: DD15F100002
X-HE-Tag: 1788432981-191917
X-HE-Meta: U2FsdGVkX18+nBM/8Nk5d9+2GiFBop5KbZYNEeGrTn/eWBrjY0uyvKpathoaNWXeAptQRkG7JJC20PyjATwaWLAct0q25pCIeDDbQzRpUYAa0eeKUhjMRXrniZC0/3uRIQ0iGVgY+dwoptc+AzfLHTt/w8Ah5QZW5JTAErpgR1bftijKBq1YCgawk1SLtmp8rp3jjlhJT4MdT9rbP3aHJbAFHChR0eAh/iroV5SO2+3qBs0ZabcmjU5Li/tG1YBrFEzFqRKE/SlEBSTnso0+hnl4V1yspTGdblY0QboTURKKis9x3Ytun8tazQf/mgn2HaPSM8+PEumFbj7PQgAHDbcl5h/nrZtfEH3Gcl5BH/uYHU/d411w0+eRCZleMRrJvPbHz4aKiZgztu+wvFeyu1AicPhEd7nZ5cZ6e1dNA2kA4yPFxPoubqJvngxq+DlbLIZK/CN2Qikr9K+9Sd39tH5xAi3FtEXub6E6WuqI/ax9uvJNbGSYM+fMGL22lsrUy0UTLXNsByVB92lYHvE5dtFMlu1usQdAqORFxwyjeeV82mud9Q60EvcM4bga4ky3fwRTjdB37hLXeiGFGCdwbEWrL07Gzc/s2Rf8ZjyEf6GQiA6UOsCh2bCWdNBPFwcUxA6KY5EDP88TE4GiSmFHDwZcVnWvuXvqi0Ioo6lz2XCWUHCQtqfWLUEqvdeh8qeINGI0rss6OpcXALCxjnnMeQewmw0uFPNBMjIPMUlORb8kpvtAqv04063fxtP0poJUGTWE+DtToIuA5q1oi1oKPjXJNyNa+isr5S3tDXMY5ydsE700UUL/po7rKNBUGetESzjJPjnhYTlMJcqhBHHtGtQ+lyV4e1wHs7C733KQu0NwfZyjFUMguyr/97IFOhDW3URi5rdzyYC3noR770ERY5HX1wP651BXULGSJOxwv8gCtRFkfbTCxLvtQIJ1Y86Q45Y3l5iIECLYmkW6U81
 TXEAB8+V
 yRjjxEXeEFDYxTPbgz8mFbzPzWwQ85Xg1fyeyZrvkzGCAQQvVh9ZPqFgydP/l9cImZ+aAl+PghCbEG+pTpMT1nAfxXaMIDox2qin298eE8r+s8N0JCqpeQB7XAr7V5hvU5Vu+G3F8djX1DhUEzibgu6tG9gMzGrI+RB2LlqMCgqJUIAzJGwIjQ54ZO+KiZz6nxOc/vi8Ytisv9uZ+ut7kCfle2XlWBaUEnQQMPCbMrrljiBnwnottM4VWTX5eBuPGLrVGnguVa7WZl3DQYBiv/MY+/NXkQlEp8dyAHk5o9X1Zk4A4T98UCeKMVKEvQPFJrvGpyDLM9DGuPJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 05:13:15PM +0800, Longlong Xia wrote:
> Thanks for the reply.
> 
> 在 2026/8/30 22:22, Harry Yoo 写道:
> > On Wed, Aug 26, 2026 at 03:56:53PM +0800, Longlong Xia wrote:
> > > From: Longlong Xia <xialonglong@kylinos.cn>
> > Hi Longlong, I have a few questions.
> > 
> > > The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
> > > and then tested the result with <= 0. When a single CPU's object
> > > count exceeds the remaining budget, the subtraction wraps to a large
> > > positive value and the <= 0 comparison, which is equivalent to == 0
> > > for an unsigned type, never fires again.
> > Since when (which commit) has it been broken?
> > If it has been undiscovered for a very long time, why is that so?
> 
> Since the shrinker was first added: 9154244c1ab6 ("rcu/tree: Add a
> shrinker to prevent OOM due to kfree_rcu() batching", v5.8);
> 

I see.

> > And how did you discover this?
> 
> While reviewing the kvfree_rcu() batching paths with the help of AI
> tooling (hence the Assisted-by: tag in the patch), which flagged the
> unsigned subtraction feeding a "<= 0" test.

Okay.

> > > The scan loop then iterates
> > > through every possible CPU instead of honouring the reclaim budget.
> > Did you confirm this actually does happen? If so, how often does the
> > kernel end up iterating through every possible CPUs, very rarely or
> > almost always?
> 
> Yes, in two ways.
> 
> Experiment 1 -- deterministic, instrumented loop.  Per-CPU pr_info()
> plus a test entry invoking kfree_rcu_shrink_scan() with a controlled
> budget; 4-CPU QEMU guest, 400 objects queued on CPU0, budget 50:
>   buggy:   cpu=0 count=400 nr_to_scan_after_sub=18446744073709551266
>                 visits all 4 CPUs
>   patched: cpu=0 count=400 nr_to_scan=50 BREAK
> 
>                stops at CPU0
> 
> Experiment 2 -- natural trigger, no kernel modification at all
> (kprobes only).  Setup: 1 GiB QEMU guest, 4 possible CPUs, no swap.
> 
>   1. Observation: three kprobes.  Scan entry/exit record nr_to_scan
>      and the return value; each kfree_rcu_monitor() hit inside a
>      scan is one CPU the loop processed.
> 
>   2. Memory pressure: ~650 MiB of anonymous memory.
> 
>   3. krc backlog: loaded the in-tree test_vmalloc module ,
> 
>      which repeatedly vmalloc()s one page and frees it via kvfree_rcu();
> 
>     10 million iterations over ~70s kept the per-CPU queues populated.
> 
> Result within ~70s: 262 natural invocations, all from kswapd0;
> 171 of the 261 scans that found a backlog (66%) overshot the budget
> (nr_to_scan = 128, freed up to 4479) and visited all 4 possible CPUs.

Thanks for confirming with the experiment.

> > Would this affect the kernel's reclamation behavior in some way?
> 
> The break was meant to cap the scan at the reclaim budget; once
> the subtraction wraps, the cap is gone and one scan processes
> every possible CPU, draining the whole backlog instead of a
> budget-sized slice.

The fix logically makes sense to me. But I'm being cautious to
introduce a functional change even when it was unintentional and
'accidentally' worked. Especially when it has been like this from
the beginning.

IIUC it will almost always end up visiting all CPUs
unless sum of objects exactly matches nr_to_scan at some point.

In most cases it will visit all CPUs because either 1) the counter
overflows or 2) the number of objects was smaller than the budget.

While I agree that the code doesn't work as intended, I don't think
you have enough justification to change the behavior. I'd rather fix
the code to match the current behavior rather than changing the
behavior.

-- 
Cheers,
Harry / Hyeonggon

