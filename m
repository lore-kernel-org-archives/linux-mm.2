Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA634CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 07:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4285B8E01C6; Wed, 13 Aug 2025 03:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE488E01B6; Wed, 13 Aug 2025 03:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314BB8E01C6; Wed, 13 Aug 2025 03:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2321A8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:11:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C556CB7E32
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:11:41 +0000 (UTC)
X-FDA: 83770864002.02.C2DF88C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0469040002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:11:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gG4+WM5I;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755069100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZFsYJiyB1fvxRtIFfJFidT6INioyMRvmFKceuBeMbE=;
	b=v+6w/6xHyXHFWHGyD/yntDcFqmv1KLgoUOwb4qgqke+NGarqO7t3K6c49v3ccmL3A9QKZ3
	EoxAH7ZUTO9zmHYYj7cqiAFbfJJZyc/E/4DU1DtfR0H/o4E4VofWYjWs7v3E5D+2E6SXTG
	nlXKYMul3w/nnagmIEffAfqEY6AdCDQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gG4+WM5I;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755069100; a=rsa-sha256;
	cv=none;
	b=KR4qhN/07nK8WMoQgbnigdxz0UR4gRnf6PMt+QMCXL1dVP4pe1lf9in2SyAngHJJvBIGwg
	Y+BUMi1bD4sAiuu2AUechJCvondJAYuSXNhwzgt8olR+Pd7epYFEIkKngH5af8xBwRisF3
	4As3FPQeq5FNh7Y9m/6Nd118eWI6Tzk=
Date: Wed, 13 Aug 2025 00:11:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755069097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wZFsYJiyB1fvxRtIFfJFidT6INioyMRvmFKceuBeMbE=;
	b=gG4+WM5IZTev5FDHmnVkWiRF1CQo6nK2IILnadjEoI9rVXYIWj5lqRHGRPWSTwTu/MyN1z
	pTwxSpKzCwmyNqhJ3fP1/velQ2CJGQd8gNXMYsF7mK5SHPjDHm8PvczlF7tQireXlSgce/
	ApBgrQ6UG9VPQre3jLqz44suXJwDq8M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
Message-ID: <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-13-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812175848.512446-13-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0469040002
X-Stat-Signature: o456a9h31t9yrjig5yq9uz5uhsyod9ma
X-Rspam-User: 
X-HE-Tag: 1755069099-905423
X-HE-Meta: U2FsdGVkX1/vRdYAplSV3nhqJfzQE5z+xS+G83uhdMrIpkUYW1mFxT4csITBCjD0muv97QYiXmtuD432/3l52pEvn+S5JV1QF2mWVmWHvFOJqwShVDP5IugZ7wJTKNXT8/CUtE7IEwEyouX3OqLgFwdzw3h+IDi8ywl8nI2rvks8GIRRgS6XQZ6T7NdLOdgt+zE9JSWWNP1SqScICp+I4oKJhhOSR2WHqebWBX9TYoW9/FiWNbe7bR7DO/lShZ9DwAvUcElUdEK31pl7pR1pJmvTjlHB7+hZ8tOdQUHsTH1WqH0n8aAgb1K6R/Ng2D+UYLAxctT/cV242naKUjcNfitkNiNabrN5gezGtkGmt85us9xuWvxoHo2uH3PX/Evth8wHwID73C5rwa1UUFOH1/Gweb41T1tbDcEPYn4LAr+mwzgvcdTOwMMA5K1E5XOKRFxZJMAvR9gR+yKjIvHvDnolL3E5DW2F08tvYX1PgL5nmngbvlfxUWCP081zH2orViMLa016q62LBqf2uC9PZAS5rLOt642HUs1xYYM3ymv3pJXTMKco5LCRRMqo8XPqtS+J3byzMJ7ZanoexZdBtNHRCbDiHMZvERez9AH+2SfuufV7GfvMAAc4IIec1gWzLzfNoJby1v2Cq9ly1hkoZB26aOCr5vbwTFJCngsJZR6ZD1LLjs0vScLhEb9ZVekCexld73mpsrjtgzjUwdKbtI7TCOvP+gAwII46zTKhXgtsbgz1mQKAs6aEIdzUXXzDqDh02RehhQoKVOdpGkhmHfiEVDkrfYts7g8HJO4paqE2pKol3a5zfZaJQLVoFcF9/XjbQB6Yk1URHCss5l/+27EfQVHEIFzyocxfDeunxJV6+VVzheQi7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 05:58:30PM +0000, Kuniyuki Iwashima wrote:
> Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> buffers and charge memory to per-protocol global counters pointed to by
> sk->sk_proto->memory_allocated.
> 
> When running under a non-root cgroup, this memory is also charged to the
> memcg as "sock" in memory.stat.
> 
> Even when a memcg controls memory usage, sockets of such protocols are
> still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> 
> This makes it difficult to accurately estimate and configure appropriate
> global limits, especially in multi-tenant environments.
> 
> If all workloads were guaranteed to be controlled under memcg, the issue
> could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> 
> In reality, this assumption does not always hold, and processes that
> belong to the root cgroup or opt out of memcg can consume memory up to
> the global limit, becoming a noisy neighbour.

Processes running in root memcg (I am not sure what does 'opt out of
memcg means') means admin has intentionally allowed scenarios where
noisy neighbour situation can happen, so I am not really following your
argument here.

> 
> Let's decouple memcg from the global per-protocol memory accounting if
> it has a finite memory.max (!= "max").

Why decouple only for some? (Also if you really want to check memcg
limits, you need to check limits for all ancestors and not just the
given memcg).

Why not start with just two global options (maybe start with boot
parameter)?

Option 1: Existing behavior where memcg and global TCP accounting are
coupled.

Option 2: Completely decouple memcg and global TCP accounting i.e. use
mem_cgroup_sockets_enabled to either do global TCP accounting or memcg
accounting.

Keep the option 1 default.

I assume you want third option where a mix of these options can happen
i.e. some sockets are only accounted to a memcg and some are accounted
to both memcg and global TCP. I would recommend to make that a followup
patch series. Keep this series simple and non-controversial.


