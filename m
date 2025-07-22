Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A767C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4D16B0098; Tue, 22 Jul 2025 11:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC916B009B; Tue, 22 Jul 2025 11:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2986B009C; Tue, 22 Jul 2025 11:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABDEB6B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:52:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A0A8B980B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:52:38 +0000 (UTC)
X-FDA: 83692343196.18.948DDD0
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8576A1C0014
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:52:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ljxgpn9A;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753199556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3XocA49nvohXItD3mzL5WPudh9EWNp7gI9bByeR0sQ=;
	b=lViLLB0ZMdgkEtyXDiUoULy9pFX3cQ82aTv8Q6NL+rDFZ4I1NCSZwMCvm77gVBhbRPSZxf
	drnkixmwzFeT8IZAnjVEdH/M2JfFEq4I6kO9mdZju6ZYNJGydR1F/XOanBxtGBvOxAIUKf
	WETebvIddFnUFQbDkRx1w6MRZd3AJyI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ljxgpn9A;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753199556; a=rsa-sha256;
	cv=none;
	b=wENKrYzwTQdqk4JlyTQuIOTMXCVAipIDBRbFjm9BcbBqoImH16vzJWsyA3fthL1530OcvJ
	JmGybKNn0dXkWe6SICmB4aRllbSjQYLCGbNtdiC7mTCuxsM3HlDodQpa5aKUOrrziMFJc9
	4MNLQ3u0G+Q8niKxE4dy/pXBgMEwpgM=
Date: Tue, 22 Jul 2025 08:52:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753199554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c3XocA49nvohXItD3mzL5WPudh9EWNp7gI9bByeR0sQ=;
	b=Ljxgpn9AGU0hD67ioPTX6Wihgl2buBotwbluc/8RHH3rd1Bffik+N1YJ7tgTdUxM5u+pmV
	N1YRZmLvBRdjDW+LNf/fJEUgtgOUIJFW5q6OTGSye3qVuNaHdB28buqAJKgnPY5kUY9B64
	0UKNcb59Rvn+QH/FM3LtF/KDSQWr8Zg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 65ap95fowznzwqw4mmhrf8osdonifqbc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8576A1C0014
X-Rspam-User: 
X-HE-Tag: 1753199556-176348
X-HE-Meta: U2FsdGVkX18VKLgZT6Yt62Nf9yhEi8qA3hd3DbutQKXYflqLxHUhOP0wHG1bY12v829E64K/hMAA/Lr7isHjuSdqed6NcCh45ZI4XQUvX3fmzWQg+t6m+6ZZ2DqG4kJOko4NaPsfUc/7rQrSsCOS5SSZzmonkDtVK+ZSr61+YyYvKUki+hPZEZbhXuUJQej4jBo3x0DO+2lhXH1zjc9IqODcpytUsM3uc6tQaM2QAk9cVDY/YgfCbyFzNd/B8fZRx7brBrUjYPyJKdaih1LI8MJHVJETOw42no9GwlbybQJ6xGmRtXjyVBD6/CbRbeFfwgfvJXGrnTaRKidRqvmYaO87DaoK6uMYJjrK/3wxryqWC3dXjGnTNScgcgkCfC6XEZyGGW21g+3UzSC8vtOgZ3xd17cye/SQfJLxiwbbyVltFnIh4XU7PO1C9uIsZW7vmf3UGuS31kwChJ1gaFbdhRqU6fYMPIiTu/lhcBUuAQqNJDZelxLNrlbsp5YRn7jcmWl7VrNs0X3S8GoW/WRz/ekJDgu0ddtx7LbgZZvBHvV2ujC/OrfvXfIOu05nuKm8y8stV/+8cDAEZAAmw+92Nj7/GWamJXzV9ZLtnDjg5YDfgcTZTUJxiIj8aq89AxE1+s8XeRT1k54cnn5ltvVlerZB5a4iVcmM9u3QMQ+HB5YnCZ5FO2pcohqtTxs6ddRrbfh1nY4pmApCdQn2iQLc2CfyiYAdNu+kYtxea0vF8NxAiuRJAusXTZv/hgTVkwvg+sGSsH1Vvbv9oyUwNutOSMF1eK9M/ybXrcEgeS39/q8mPDkImMqJtn+fBY+iCVXVIHbHzIdNg+6ZH1cjTws8mRqGHMUVxN05eY2Cq3gb7TP74EiFaaHgnDrgGYMNhhwelZU2p26hCwVvtZIz7xNS+VAuSUlhsJqchE9Cpe9QgMAW1yKpk+pRBFtfdJ84bWrAYuu61QXQ80vP9snBtgP
 LHDMSm84
 S4OOaK6R6Oe7OoLSq4ZsZlYLE6VhnPkSX3QgVyIJiElhbLMrAnvWRQFat4gQWddi/CiVNh99bG3+GyMbgibU3oHiQFCpff+mRJ+FU2Q8Tby63pz2I1ttHAuZ5iUJKegxIvhkmu3KrSB32+PrNyIskM5BbdMMv1NqncG8DAkIqprZWGVAUZa/4DisSMcKIth4JRRQ/8fOCIBaSNJVbGFLACqd2+OS/GxdullTMiwAw8Llyj7pgU4ib9U12yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 08:24:23AM -0700, Eric Dumazet wrote:
> On Tue, Jul 22, 2025 at 8:14 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> > > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > > buffers and charge memory to per-protocol global counters pointed to by
> > > sk->sk_proto->memory_allocated.
> > >
> > > When running under a non-root cgroup, this memory is also charged to the
> > > memcg as sock in memory.stat.
> > >
> > > Even when memory usage is controlled by memcg, sockets using such protocols
> > > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> > >
> > > This makes it difficult to accurately estimate and configure appropriate
> > > global limits, especially in multi-tenant environments.
> > >
> > > If all workloads were guaranteed to be controlled under memcg, the issue
> > > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> > >
> > > In reality, this assumption does not always hold, and a single workload
> > > that opts out of memcg can consume memory up to the global limit,
> > > becoming a noisy neighbour.
> > >
> >
> > Sorry but the above is not reasonable. On a multi-tenant system no
> > workload should be able to opt out of memcg accounting if isolation is
> > needed. If a workload can opt out then there is no guarantee.
> 
> Deployment issue ?
> 
> In a multi-tenant system you can not suddenly force all workloads to
> be TCP memcg charged. This has caused many OMG.

Let's discuss the above at the end.

> 
> Also, the current situation of maintaining two limits (memcg one, plus
> global tcp_memory_allocated) is very inefficient.

Agree.

> 
> If we trust memcg, then why have an expensive safety belt ?
> 
> With this series, we can finally use one or the other limit. This
> should have been done from day-0 really.

Same, I agree.

> 
> >
> > In addition please avoid adding a per-memcg knob. Why not have system
> > level setting for the decoupling. I would say start with a build time
> > config setting or boot parameter then if really needed we can discuss if
> > system level setting is needed which can be toggled at runtime though
> > there might be challenges there.
> 
> Built time or boot parameter ? I fail to see how it can be more convenient.

I think we agree on decoupling the global and memcg accounting of
network memory. I am still not clear on the need of per-memcg knob. From
the earlier comment, it seems like you want mix of jobs with memcg
limited network memory accounting and with global network accounting
running concurrently on a system. Is that correct?

I expect this state of jobs with different network accounting config
running concurrently is temporary while the migrationg from one to other
is happening. Please correct me if I am wrong.

My main concern with the memcg knob is that it is permanent and it
requires a hierarchical semantics. No need to add a permanent interface
for a temporary need and I don't see a clear hierarchical semantic for
this interface.

I am wondering if alternative approches for per-workload settings are
explore starting with BPF.




