Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C54CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21BF8E019F; Tue, 12 Aug 2025 21:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1708E019E; Tue, 12 Aug 2025 21:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E1F8E019F; Tue, 12 Aug 2025 21:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D41C38E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:58:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6754356F00
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:58:09 +0000 (UTC)
X-FDA: 83770073898.20.E5874C9
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86B8840007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:58:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b19C3ZI4;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755050287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfD3nlYZmda+fmVBH+ZVr3UweVz63/j+5hOxerpkJRM=;
	b=I4I5UBNfgtbdSMDPZRtmKNqSGhT/ObzoMxTZ/1PigSKYzQkStelc47cheeo504sUMHkAER
	Gpy3CE3JdrBVK4z8ytzosrxuQWV0L0cA4b6kttTd+lKZI2zkmp06aIjYpn7IanrZGQ643a
	kyeTHXD8kQ1s2NpxS2Lb34U3h/TQQn0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b19C3ZI4;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755050287; a=rsa-sha256;
	cv=none;
	b=OYwo0WxP61J5lJaKF3VIjB8nYXUy12nyv7FvnzdHpYKa9ckLaxJfPpunD8FJnC8nBCtgXu
	yAkpZujxRGlQB0iwtEEEcy3ScP50Fk9TwEYSN1d8FzD9nX/Guds3Rem6WHQfejd98tAv5V
	E8jGq1XTRBTNE8nUSlx+R+0i88X+/DI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755050283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zfD3nlYZmda+fmVBH+ZVr3UweVz63/j+5hOxerpkJRM=;
	b=b19C3ZI45eU9CsKS6W3M7BSUx5OnTlbb/tM3WLPlW06jtKgYmEyV2HjadKqkdJ3Et1Q3NY
	3+edrvJ0V9oUkrqMqx5IW5xtDQpqd5K70mnW2Rn4vJj8uMMfBfFJC8vd294TZXLMx1uyk/
	nmdKcABr6WF8PtoemF+njSNYCP6Jh8A=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,  Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Neal Cardwell
 <ncardwell@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Willem de
 Bruijn <willemb@google.com>,  Matthieu Baerts <matttbe@kernel.org>,  Mat
 Martineau <martineau@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Andrew Morton <akpm@linux-foundation.org>,  =?utf-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,  Tejun Heo <tj@kernel.org>,  Simon Horman
 <horms@kernel.org>,  Geliang Tang <geliang@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Mina Almasry <almasrymina@google.com>,  Kuniyuki
 Iwashima <kuni1840@gmail.com>,  netdev@vger.kernel.org,
  mptcp@lists.linux.dev,  cgroups@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
In-Reply-To: <20250812175848.512446-13-kuniyu@google.com> (Kuniyuki Iwashima's
	message of "Tue, 12 Aug 2025 17:58:30 +0000")
References: <20250812175848.512446-1-kuniyu@google.com>
	<20250812175848.512446-13-kuniyu@google.com>
Date: Tue, 12 Aug 2025 18:57:55 -0700
Message-ID: <87ldnooue4.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 86B8840007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kri65k1f8gkqr7dtjsken5stdg1e5pw9
X-HE-Tag: 1755050287-53907
X-HE-Meta: U2FsdGVkX1++AA7IdT60wBwSUWfbjUbhdkVmhwuvz371TZgRXJDO+E6dqGogNckhS2ZaO84fb00C5+mWeRwd4Z0cZmm/U6j5Rf2oKLmmrtGCLrYnLh2jistuLuhAVwIJ/a7oFP3OVj1XN6FWB1FM2DEqi0MErKaUq9PIyL6rzzL4C/5qR4hnqbuFslUH+w582aiWt5xS2qNBif7+b7CQopDgnvwNIzoy4yR3kkrDxhHwpQyrXZvNZ2Ymx0lZAq3Zxdp9wpx9CVVbvof8z1S7MrQbM1kgbCkGTa5FjmLyQ+8lQ9p3WCBS9yJOGJnUpd9qrfIWAXZjD7SKIxDkeLmwudZT4gZRijapJ8mfc4YqMMUHsK/yyEerdXDPNv+fKTu+HTzT96v93KNdoxxw6BdyiJAy8yqV8ggJDvN9buGBipTwfmZ00NiAmkx9r5OBYeiSf42BpgOwNtCjZIgL1P57fyuDBgqkfI+8e3SILz1M9sHY5SsnPwzYzozubGbzD7l/th1vnOky7jhzV9awtxP8d5yeyzJcDEGpm9iJNBy9reDJLVPQ2MUuxC42/80kbVq5913Pe8L1J8P7k1BkfkqxfupIt6aqOf7fNJL2ndzc01pDqqkyvi4m1O+XZVye9NceRXjtreG0WXoZMLeIiu3K+P7rWoygn2QeLOCUOhDzVAumXVkpljxBKE7VXsbBQGjjrU0PTOSlQnffXRsRbYKrlWZ6s0nyQfz8IMk3GgPslPkut/weooOtZBFOwQBzPUZg8ZiEml9/QiFOlYVGv48sCgK4aWOQSybxa00kXPdt67pG64SEi8OEQme8SCFSUIxJ6OBiZilAWKojz94fM7bD6KI3dP46TjuhflX0QP7GKXLJB+sNXEmPwjXl1OLb4GTWq1IKaZbpcXXJG4xuS2PCymqjLxRw1Y32vfx1XoYbMTwihv4rB4aEmXN4TXAnffgfWXjCWadfLU7sCCAdSJz
 uP/lcQxS
 8F/4VwwTw7r8qPG4J2h+C69S2fNIbqBEdSkBE9IGaUD1h/Otr4NYPsUl6KfFTnA3je9lSqvz9EKR1F3Fd59Gdkt5OArYtKBPAeSNBbgtqVqvLzsV3oI2llkxUlJkg/bhHM9zVsGx2n3bHa6J9wSnzlFXtq1FPXtTBKC03t8ya6IPxiRKXq9HQ+ropjg==
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
>
> Let's decouple memcg from the global per-protocol memory accounting if
> it has a finite memory.max (!= "max").

I think you can't make the new behavior as the new default, simple because
it might break existing setups. Basically anyone who is using memory.max
will suddenly have their processes being opted out of the net memory
accounting. Idk how many users are actually relying on the network
memory accounting, but I believe way more than 0.

So I guess a net sysctl/some other knob is warranted here, with the old
behavior being the default.

Thanks

