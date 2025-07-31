Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528D9C87FCB
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 02:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65E26B0095; Wed, 30 Jul 2025 22:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0FB6B0096; Wed, 30 Jul 2025 22:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C5D6B0098; Wed, 30 Jul 2025 22:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEA206B0095
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:58:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FA57C0519
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:58:45 +0000 (UTC)
X-FDA: 83723052210.14.2EFB5AD
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70635C000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:58:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qODRXZlu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753930723; a=rsa-sha256;
	cv=none;
	b=MCFgBzDEsOSeIQAGGnI5xlXb8e773NAfIlTfskvwuTnFu/BIUrW1AWQJuIkJgelx/18pto
	KXYcx+yeZJVMa9b9672kjOxHLg35UeIZNGh6QEJKmDDvmu5WIPMwQVaDv73WU6os4g0MrR
	xA0VXXKk2mglJFjqLo5fGfnMXEFlMpo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qODRXZlu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753930723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hO4jQq8PLpE3srsD0rPnbC1MtEeo3jkBhYPUfq1jFi8=;
	b=M8P3gL1VLL7Huv4KrHoa9E5rOYi1pxtpzKunRGoqd5nsRX3kITj42KDRb8dLra4g6KeFsB
	3Jbbop9qlAtB11BTrdQ6KpAm5LuZKib1xOU0rO+YAxjC4CX4j+ssUTI3TTSpfI4sBh6ajy
	JKV4nomFtOKJw2fZvl0LnS4OIDiyjAY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753930720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hO4jQq8PLpE3srsD0rPnbC1MtEeo3jkBhYPUfq1jFi8=;
	b=qODRXZluoTdZwsqIuRfPB+EmJlGTteKL3nnL/Ucebe10AjPqn+1D455FmrTHJPFgnZI0Jh
	JMNnJ6aM2zKV+49b9RReayHJAoHS8GgGkLFGaAFI3DdlOr+/X3+3i7whoAoR7V9v4nUV5l
	Lb4LEniPT+7zzehE3Z3mfWCDC1JYkBE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,  Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Neal Cardwell
 <ncardwell@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Willem de
 Bruijn <willemb@google.com>,  Matthieu Baerts <matttbe@kernel.org>,  Mat
 Martineau <martineau@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Andrew Morton <akpm@linux-foundation.org>,  Simon Horman
 <horms@kernel.org>,  Geliang Tang <geliang@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Kuniyuki Iwashima <kuni1840@gmail.com>,
  netdev@vger.kernel.org,  mptcp@lists.linux.dev,  cgroups@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg
 from global protocol memory accounting.
In-Reply-To: <20250721203624.3807041-14-kuniyu@google.com> (Kuniyuki
	Iwashima's message of "Mon, 21 Jul 2025 20:35:32 +0000")
References: <20250721203624.3807041-1-kuniyu@google.com>
	<20250721203624.3807041-14-kuniyu@google.com>
Date: Wed, 30 Jul 2025 19:58:32 -0700
Message-ID: <87pldhf4mf.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70635C000B
X-Stat-Signature: yoq4fgwt951ogitmngj6aia6manzfdi5
X-Rspam-User: 
X-HE-Tag: 1753930723-390505
X-HE-Meta: U2FsdGVkX18pv5C+XGlx8C6BgmsxbqzC/ZpvCBYQDCA++gHfF/lmTvZt+UUvg9lx/gP/LM8vpi+a5DcR8y54MXvz1BxW7cBNKLGTU7WtDeeAZ6eD21FDdx10gO6tDjsOOoLBufAH9nJn0n37+nKAAWHrwCjZQ03ktN+L2ga6yzRhFLAU1MPI9fGclDAU2Yzsd4DxNDA/83yuEHwx+lEWGoCqL+28s1JXnqNUVGl1QBu7bTDLhhUZ5BBUWCM9PFsW21CzdWeqrHnsqvVekSDQ8L3YRW6s5Yu4LBq3Pgb09TRvnQkxfTnawg88O7E+HgWexRWMn22HsXyFdGET4Jad1L9Y0MWxJnNbABOwl3Zh3lpDr4RWshZ/ar7a7rzuKDF8nyHi0k7ZzckUDWlYjBquZcVZXd3cX3tnETpZDEgE4l/sYHrbXUNMclE3iDPICZBc92jyqDNvGuM5+0x/idl5LNibIsp7KdJxYU5BtpWaM2hYFRssrltVHgwlT8BrpZms65kCCTXKgD0MiOXHwzRTCdP7dah4V1HmtjC5mkHgwJsBNNoCx6AvcMIWr3ExVM8wupFH3M2jkJmIGfW4DEVoRMry6YqogynMTlFK8m8cNHCrFZfd57Zz8Bl8P5swG8pdOUhvrIm37MTANEpHlGVrLAejF+iOe/qm6tpRES64dmx4AVez1s0/HOCqHqXfcTdT1xj692AesKwbPi5TqqBY+oRPTluoxDInyatFEiVJDIbtf84ugqUWIQmsGSyJusbGrrOjNbU/WhZM3lv5ob1DhrLedJHw28L+PPd6an2ktXQ+apKfm3/us8G15yNvEqfdvMkTHDjjPqqEUQuIJFSMp6aWcdR0p4d5tNALI1S1/2olFNaaaOJYHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kuniyuki Iwashima <kuniyu@google.com> writes:

> Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> buffers and charge memory to per-protocol global counters pointed to by
> sk->sk_proto->memory_allocated.
>
> When running under a non-root cgroup, this memory is also charged to the
> memcg as sock in memory.stat.
>
> Even when memory usage is controlled by memcg, sockets using such protocols
> are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
>
> This makes it difficult to accurately estimate and configure appropriate
> global limits, especially in multi-tenant environments.
>
> If all workloads were guaranteed to be controlled under memcg, the issue
> could be worked around by setting tcp_mem[0~2] to UINT_MAX.
>
> In reality, this assumption does not always hold, and a single workload
> that opts out of memcg can consume memory up to the global limit,
> becoming a noisy neighbour.
>
> Let's decouple memcg from the global per-protocol memory accounting.
>
> This simplifies memcg configuration while keeping the global limits
> within a reasonable range.

I don't think it should be a memcg feature. In fact, it doesn't have
much to do with cgroups at all (it's not hierarchical, it doesn't
control the resource allocation, and in the end it controls an
alternative to memory cgroups memory accounting system).

Instead, it can be a per-process prctl option.

(Assuming the feature is really needed - I'm also curious why some
processes have to be excluded from the memcg accounting - it sounds like
generally a bad idea).

Thanks

