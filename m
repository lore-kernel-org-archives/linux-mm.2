Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBB8C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC43D6B00A2; Tue, 22 Jul 2025 11:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BE76B00A4; Tue, 22 Jul 2025 11:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD88A8E0001; Tue, 22 Jul 2025 11:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE25F6B00A2
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:14:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 764BD57ABB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:14:18 +0000 (UTC)
X-FDA: 83692246596.10.AC5196B
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7EF46A001C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:14:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zvt0v6RD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197256; a=rsa-sha256;
	cv=none;
	b=yZ2iwAdsfa6/uca1O8J2gue09++JnKR81yEtiGSEhEw1XYwZFYhUqITuXE7NmG3kO5x1eb
	BovO8jhSJdD+mB33EHUnNK10ZsPawSJeASTo46n1N9TRvkuI8upjGbVGfYWZfsVV6dknbv
	j6CoE7nmaWy9WQLdWbaCivorzlmROI0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zvt0v6RD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Psl5Y/9bUJeBsPoDosmVrMSfhPKG5hDAg1aFzOBXGww=;
	b=AOyiWMconRHL9r1YnfN68kDB7jtAzBc7zYZr2zCMuHcTI6bByojKW/42f0brRl88aFWb+T
	cr/Ey1YJfWY8aveChf5eF7cet3kIB2za9U88BJz95W8vIAw257r5TAgY9OhNmN45qtoIqm
	S91arPwpZrKpoBGkTFMzkrus2cPoYpQ=
Date: Tue, 22 Jul 2025 08:14:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753197254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Psl5Y/9bUJeBsPoDosmVrMSfhPKG5hDAg1aFzOBXGww=;
	b=Zvt0v6RD+IhEjk1WZytAl7n8cjVrmEOouubCgf1ZruOuUfFpVflxV0Ne9+ECjRbCcv72Lv
	z4wu3bBJT9wwqB8NvRIIPMEQVhDJLD1n53p6X4SaiSi5M8Fy5yx5B/Lwl+/K69lUWfiE12
	1MVQmmpdxmdZDER9HH4m0MSUXENKVEk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
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
Message-ID: <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721203624.3807041-14-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EF46A001C
X-Stat-Signature: u1xfuosfebhztm6iukmcnjsyqdwixnax
X-Rspam-User: 
X-HE-Tag: 1753197256-620947
X-HE-Meta: U2FsdGVkX1+zh012qD201p36LT6hPN4t3PEfRvxh1/55R2lvq8uekWLkk10CylpPbwIwKbTNZ8eNuH8M7FcOatDxGnkZ8SOmDNGv4VdYNPhLT/VBsfh9vu7L1pIzMCS8g4C2oXoKYQxb3plxwWF2roQU2mlsAzOIVLPhYSA0+gvNW5+cso9iOHXVhiqZdp6WMTDwfnhdMS+HmpiF3JweoL7+XsIAGHD/vqAvx9rqRiD4NoYc2WlLhf96DMBT00LCdl7QWmV/IJ4802vgx9Tvk45o+kuCzIL6iOjwIEpS0Zryj9CRTVyCoe3OXf40wDudM6IW1GV2ZwixW3e9NrPj4OlJCUpdVCOd8HEnRYLdmcAH8DiG4dkJFxHffqMztYV8dn9VxvqcsTmwaxAqyptwz+0Tcj9JXV86mauI+oHvhMHO2A7lo6lif2pJCdVylEn+Cdpg+hlgp5SIDVvciE6Kabth2ornmL5zSLSu9XJ/OsjBK1CXflRpLqJkEK/G5/J2l5qlXZG1NqFnPsYMZI0KzAzyQ+yMRvvurl1kCw+AL+sTS+SbvWBBuvLBn3dBU46lxdtJ/EH5kv7N8hB6w2gaNV9aNaIDZmzgSazimvN7vze6pkVCCMUfGojuf3ZwT9szsAU347IUiaXPD6uLfEnE9Rndxzl4gEHZRQhPIjqwzc+g6bnI0qozAvThQWq4T2XQLMik24vxGHTebADjB7Jh7I2tKM07ksYmKo6dWc3//8wlrhNkfr2F9WdKqidtlCpIOK5I+zGbHmqYwRXiZq5w2aPXa3Wg+GpUXnquIp27DFpMjQsiOvxFof5jF6MD7r7450rOElY0q4Fd6jMFGpIQBs2GprcrtfDON96AZKcWkRJ4YPE9qQtl2XBOPPGBdKdlvrr434RT04y9PMcF7qbsVUZvL7UBSOdYPCNNxJcP0NezbLplGIkSOG8hWWdCe1bBYL/ijMsMbMPHCyMJyiU
 TrsMRCZQ
 756lyh8DWeCizlXq1eOReiLXvu5AdpnVi+FJ3+f8b5O5rk8wymBd70CXkehHiVMSkdCI3ikMtoEVszhx//BATCN4sy35E0JWMP762LtyNvYpQxCmeowrltU9LKuN84qQLR/yMGrgsF0vmi3EuxeVsk/GFcHqZdMgu7vv+eQ+3VHipfrf50Or57j2+iuKNBvnWiwqTvF8fMdqEty+gBnmPdHe6Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
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

Sorry but the above is not reasonable. On a multi-tenant system no
workload should be able to opt out of memcg accounting if isolation is
needed. If a workload can opt out then there is no guarantee.

In addition please avoid adding a per-memcg knob. Why not have system
level setting for the decoupling. I would say start with a build time
config setting or boot parameter then if really needed we can discuss if
system level setting is needed which can be toggled at runtime though
there might be challenges there.

