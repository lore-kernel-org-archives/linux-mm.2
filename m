Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F197D2F35C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563BB6B0088; Tue, 13 Jan 2026 18:55:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5315D6B0089; Tue, 13 Jan 2026 18:55:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413386B008A; Tue, 13 Jan 2026 18:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D42F6B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:55:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D5EA5C0D8C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:55:45 +0000 (UTC)
X-FDA: 84328600650.22.15AAD71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61ECD160003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:55:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oNDPTWg3;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768348544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sW18U4u7ahcJhf29zduRteUt8EvqsdiQdD1TMYcLXkM=;
	b=fpnBF0IpZwqkzf6ty1MqQaMqyAUx21/UTC3gK+/JEoM9IUTs6rQlPaLzRmJQ6URNBIn7Ej
	9psAiGFnxI0MzC6qeTt8DkF2mzJLOWMlG8BrmmOL5jflfGmzOGHnGdYbLfrFNJN6GM4ETa
	Zj0X8xm46oxL70GYnkVnIc9g02LvZiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768348544; a=rsa-sha256;
	cv=none;
	b=5r8e5/C8yBAXO3gaxUtQyVYpJwmUa9Fx6dulRp2wndbBoNVJTJ4zWnNRpd1jfTXSglJ353
	dJn+MUuajkpy86nE3a9ymssI1UWiZTVLLduOHb8sVzXboMHNnRxtJmnvELv5wnQQiPAL1z
	YA7FrrHWhmXwxkWpLSQiWZMPYa8FjnE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oNDPTWg3;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AD7660018;
	Tue, 13 Jan 2026 23:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48ADC116C6;
	Tue, 13 Jan 2026 23:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768348542;
	bh=wFoCy9Y9KpIUogkM2AHajucOyerXJdtm/9lw1BUwhns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oNDPTWg3As9b4/IoWoDYObKJbmE2BB/hi0wmGKS5YwB53tgMgdYTyaqeZRLCuXEHq
	 GJjdm0tTbmUSA8x/ZOXB59//Cnpt/kq7KUphyJ80w+zEVXgFISjYFt4Fx/JbcRJTnd
	 yvESKNRQiaSKpc9jZoqeV61AmDuB6ASSj+30c9zk=
Date: Tue, 13 Jan 2026 15:55:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on
 large many-core systems
Message-Id: <20260113155541.1da4b93e2acbb2b4f2cda758@linux-foundation.org>
In-Reply-To: <c5d48b86-6b8e-4695-bbfa-a308d59eba52@efficios.com>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
	<20260113194734.28983-2-mathieu.desnoyers@efficios.com>
	<20260113134644.9030ba1504b8ea41ec91a3be@linux-foundation.org>
	<c5d48b86-6b8e-4695-bbfa-a308d59eba52@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61ECD160003
X-Rspam-User: 
X-Stat-Signature: tzxey9gi63xoaz3qkx9tyui1wgte1nih
X-HE-Tag: 1768348544-5647
X-HE-Meta: U2FsdGVkX188ZXgTExN8EzFfNwQCxb1I62nWpSn9jpYq/5MLRgQmfQ4619TYWubYcdR2L9BTUZNBtjto0s2GJmgWpGLaskPdd/kWhnixu+a9MYslYYroApyzCVh8/a9oMf3/gBLQz+z+heFZHkTEnhHYsXFLYiQyMulhkKlzZ4HltH205jXTzykO6r6oVQuJyl9BftTxg2j4E2jVihK9Yt6SlECuTP3ILTs/oXWYYS/DZNiY11VFafWafFpc/w8cvB3x1/Rxq1v0XOzJKio9/luD/oNRgbWPckWC51lmffIjpmG+VlzS9D/XzSOkaBQxLm0hecRofoESf1C2diD3jr0KJz62EmneRCDw+x10yZxT49B1eSuYxW/8HV5AkxgeAf93qaf25kz8X+PEbnPu9zTM2LcWMzJ3+O/rpXkfdEge22uJTjenMBoCn8WaDV9Xisd1kOxvXgxBje+YcNFzcK8iwn7OXFbSsfuW17Yl0PJbqJqVVeCU5rPwxLrr2FYTGJlYioKiKgwhEci6CNcfSG7wOkA3xQcJNtRi5vuUm1t9NpGmY3RRH8RIqtItL1vBs2nhOlKm5eI9Aa+cs5mea1zUxNmNRBWS0cWfEmb89gAn+6qDOhd7u4WpF42ms7XoXr8fZeVZ6yw78yXVIIZlRvnh3+zdDKCV1wKlq84ofPSi3rCyPjurAVNsq16yB1hlZZjSQ+YpeDDmxtfU275uNb2D86i6nndELg9gM1OFYaLqKC3PFm0EsnZPRas6+nHezqAFxECn74u+dRDVgzpNmxLs8yPZPvMIgdSYS1e92/bdjCWO08Cc3pyRMNPZD08+5+feIOBZ7jBaeIC+1fYaufJB3AfMBA7HPm3XAzctM4EDQh+WRvWZ9HD5n3evT/Q1fXuHD80gQ/N31Hl+zsVGDMuUSs3uymKWHm56p9edRJb4syB+tm55thzGwwAIysQY8mg3AQI5P/60sRQ9uSI
 fq8vWP04
 /8MIe6ACFfkDuYcv4bZ7jRgIbKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 17:16:16 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2026-01-13 16:46, Andrew Morton wrote:
> > On Tue, 13 Jan 2026 14:47:34 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> >> Use the precise, albeit slower, precise RSS counter sums for the OOM
> >> killer task selection and proc statistics. The approximated value is
> >> too imprecise on large many-core systems.
> > 
> > Thanks.
> > 
> > Problem: if I also queue your "mm: Reduce latency of OOM killer task
> > selection" series then this single patch won't get tested, because the
> > larger series erases this patch, yes?
> 
> That's a good point.
> 
> > 
> > Obvious solution: aim this patch at next-merge-window and let's look at
> > the larger series for the next -rc cycle.  Thoughts?
> 
> Yes, that works for me. Does it mean I should re-submit the hpcc
> series after the next merge window closes, or do you keep a queue of
> stuff waiting for the next -rc cycle somewhere ?

I do keep such a queue, but I rarely use it - things go stale quickly. 
So a fresh version would be best please.

> >> Note that commit 82241a83cd15 ("mm: fix the inaccurate memory statistics
> >> issue for users") introduced get_mm_counter_sum() for precise proc
> >> memory status queries for _some_ proc files. This change renames
> >> get_mm_counter_sum() to get_mm_counter(), thus moving the rest of the
> >> proc files to the precise sum.
> > 
> > Please confirm - switching /proc functions from get_mm_counter_sum() to
> > get_mm_counter_sum() doesn't actually change anything, right?  It would
> > be concerning to add possible overhead to things like task_statm().
> 
> The approach proposed by this patch is to switch all proc ABIs which
> query RSS to the precise sum to eliminate any discrepancy caused by too
> imprecise approximate sums. It's a big hammer, and it can slow down
> those proc interfaces, including task_statm().

Oh, so I misunderstood.

> Is it an issue ?

Well it might be - there are a lot of users out there and they do the
weirdest stuff.

> The hpcc series introduces an approximation which provides accuracy
> limits on the approximation that make the result is still somewhat
> meaninful on large many core systems.

Can we leave the non-oom related parts of procfs as-is for now, then
migrate them over to hpcc when that is available?  Safer that way.

> The overall approach here would be to move back those proc interfaces
> which care about low overhead to the hpcc approximate sum when it lands
> upstream. But in order to learn that, we need to know which proc
> interface files are performance-sensitive. How can we get that data ?

Gee.  Wait for the unhappy emails :(

People do sometimes search all-of-open-source for API changes, but that
doesn't cover in-house things, and tools which whack away at /proc
files are often in-house-only.


