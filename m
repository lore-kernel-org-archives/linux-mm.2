Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC1CCA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 997BA90002A; Tue, 12 Aug 2025 21:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9400E8E0196; Tue, 12 Aug 2025 21:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F8090002A; Tue, 12 Aug 2025 21:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71FB68E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:49:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4160116020D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:49:45 +0000 (UTC)
X-FDA: 83770052730.15.85AF35A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AE288000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:49:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dF5AdvKR;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755049783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8eBs0fHI7CmVwCx02H3JMhe4sR4fjcsdxnZfKRbvCM=;
	b=5OC0kqEnMN0gq5tSP/9eXOeGQjGpk0tctTWvxdSPJt4h8+Zybf9zuwQTQAz2gS47yakYgr
	QoG0MFA9IcnTwgTzviUOGArCi06Y5cIxQotYuWcKB/uE4EU5Kx8jkb6jS++iAKf3MucOEn
	qTJCTaPcSxDBr9xjQrTEv8l9tqXKNXg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dF5AdvKR;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755049783; a=rsa-sha256;
	cv=none;
	b=rJ3fMH6+RZN6q6Ax0z07UOsNLrqbIwcPS0gQZBwRn1vp0YsgGifMhasFLApCsLdxbSZPmr
	iDg1oikgvMbpv62Dh8TLwqGa+N/ciKjLoYihD4Iui9XWfzkgxYvpdGDXYhsLk+0iLZylPR
	NjDpo0kFuSG5aBBs6UmzUZ0wuBonplM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755049780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y8eBs0fHI7CmVwCx02H3JMhe4sR4fjcsdxnZfKRbvCM=;
	b=dF5AdvKR2ca/0Id6PcyQBrt5ubWxMZGHTzaPtosUH84mRPw/rz0ZtN0RXNgT+qna999apu
	RBTv6rLYEKBdLApJ1ypjDqATumzw0aXP/UyfSY5X9mPvS8YQph8ScVbB7RyO0vyJbiQD2t
	oCWzMrZeb/bNRLTfrs79xT2u9H5kJAs=
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
Subject: Re: [PATCH v3 net-next 09/12] net-memcg: Pass struct sock to
 mem_cgroup_sk_under_memory_pressure().
In-Reply-To: <20250812175848.512446-10-kuniyu@google.com> (Kuniyuki Iwashima's
	message of "Tue, 12 Aug 2025 17:58:27 +0000")
References: <20250812175848.512446-1-kuniyu@google.com>
	<20250812175848.512446-10-kuniyu@google.com>
Date: Tue, 12 Aug 2025 18:49:28 -0700
Message-ID: <87ms84q9cn.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nq5qbzk37815ebhpwf1zbereb5c5x85k
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AE288000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755049783-621556
X-HE-Meta: U2FsdGVkX1/xAppXOyLtXtX5XZM4PCi/TmBOHWhBFSRvFWjbp4AbBpfghuPounhnzBWY8p4FlUgcYXBI/bHfXk06RvRcIauH7G3Od84m2DopVF+ta2lwCA9+T8w+SDrnwFccRur9zt6An3J3N7KriT3uOvhgEgFnCWcBhi7lAF08cA0LTxFigqpfzkxv4mcd3rUJ+wHt8hjw53wGUofDz5jd6nF7ZFF9tOeRIMvSshLvU5X971gV4iA9vl/nk09F5CRSjBix+8twiTx6YHer7mneTFO9ToRZI1TO78fnplhDLSURJ6co0fnTvHbR0VslE3TQfE8dXf6uku3Z01OgJE4pwTvYB6UQKOQXv4T149jYWKgYqzMrTAhz7M7jHjPNRQq6jC7DmesuakNgOD3Wykp58nLv3czBKFUllWtaGKsKIgeHdn59O7uqxzZTW7TArqZjNdB6hfJqc2SEFVh71+PpkyI8YxVfPE0tqqNh1JQzOUZFIsHSRw/oJ5+GrdS4IcZPUKHWS1UDVGGw93RQvsfe+e3abzlzs+c7FtjSr0pUopm4NGh9aRTMMk8olocCvsK07f+BoRyEY3IWvaj4WqdLtxw/bLwj5+HuX3SD9/Nj0NQ3aSO0hwMZoTB7WaeSOTCsLsRijOOLwUNQuSL5NrB0TtYDFdPTFHVx0ZFJp2MR5/PkdHM8AdGjNMXuDHqJSAzQJ+geA0pzZzvQw+6TYlzgDAYDgdSm0WgcQJs5jQbZGXXPP9h9TlPpXiI65GKpaTsgHa+nM9wUqjIHQ+rSTHBJ6y+mkiZYWO+ATl4RaaoLW13MtuVJfM18IT3mhzd7nqgVmbw7F6egtYqsfNbLdxabrz2i9MH/wizGmXDC4+fehd1tNgcZ4rsfBxVY9d3az+ckI4939A1yRi3RMdN/G8FmjkKja95unhT8NRM9/2FlgIvQSbCL4FUKJLlKp56+AgjniZ/MFrvfaYOflqD
 OtSiQwf3
 pjloSxyYGkkYKpgez/fUIHT5OTitV1L1wozD/Yjwa36J4NJYeeb76DaNYM1L83fmp8ne05PNzXIRurTRI/1jxrsM6mzMupKyGYdFAMpoUHsCiS26YzxXkQl16M/AKhlbeZ1vaKg+XJiSP3Rf9kzqm0A5/LlWbI8FvT6Fm2x8WnYgYVqLMIvZIgnzle1z9OHphbIUfJD9eZkNXvATOlK/e3v7MHnViNvLOKH/Jy9xYnvpZAhn7fLPszalFvg2Bec6sbL7O6WsoLgPv1iA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kuniyuki Iwashima <kuniyu@google.com> writes:

> We will store a flag in the lowest bit of sk->sk_memcg.
>
> Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().
>
> Let's pass struct sock to it and rename the function to match other
> functions starting with mem_cgroup_sk_.
>
> Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

