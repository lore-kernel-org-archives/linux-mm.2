Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F75CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2F29001E3; Thu, 14 Aug 2025 17:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4912B9001D5; Thu, 14 Aug 2025 17:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC8E9001E3; Thu, 14 Aug 2025 17:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14E609001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:51:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B447C1DD976
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:51:17 +0000 (UTC)
X-FDA: 83776709394.25.5A6F0D4
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5F6C1A0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:51:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cEDXn7WY;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755208276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFRVQUUs9c39FN0bau/fEfOu6gLqtTA31f+AF65Xi8g=;
	b=zoRUopYX77rpy61avnBSM56lIRAY/c/OmtUqFJ50ex0C5xhcQ677gFkxQjQ3g8KK3kLjnD
	QwUYW0wwr7/bRSDph5logNK+/4lG+2XlD4S63BhmsVfQgL/zxXpxJFymI8cnBWZXhF1vbl
	p4K5GO00R/zT1d4jKXCh0bll7MnpY3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755208276; a=rsa-sha256;
	cv=none;
	b=CJ6QlIqUFb3OCnMYXUDeo5tPV1wsdYvjksCdlT7zk3hHRoFl7aGLWT3TOLpVKqfFNf2wxs
	viKiGlR6MquM5L6ACFgObCJihTBHkFquwg6Jal7juOGvVZDA9zC/5D6TaMCbKOkJxJhXvx
	zS753igW6xVcYoAtc+a4mDoZXUwGMPg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cEDXn7WY;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 14 Aug 2025 14:51:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755208273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NFRVQUUs9c39FN0bau/fEfOu6gLqtTA31f+AF65Xi8g=;
	b=cEDXn7WYmz3adjgl8K9+j7MUS3BpjExjj4/2Wvq5fB8rljL6y2EotLQy7s1S6y81j6XHSU
	vxGNLQ1U7dZC3PADsPBXTtzOdmoRlQuswEVOf8phOkOjl/YvN/OXmWCO0o6hhF9kk2Ie4f
	ANYAM7/5GxYduANX2ISMKvkT9lVZ1Vg=
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
Subject: Re: [PATCH v4 net-next 06/10] net-memcg: Introduce
 mem_cgroup_from_sk().
Message-ID: <yaxx7v7ftzhaivt36qy7ov32u2su5anv6eoqk6f4dspgf57ttu@6ab2n4cp5hbi>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-7-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814200912.1040628-7-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E5F6C1A0002
X-Stat-Signature: gazyop5z7rq9ff59rqzbdbgjq4y93ket
X-Rspam-User: 
X-HE-Tag: 1755208275-375003
X-HE-Meta: U2FsdGVkX1+0tm+UEkxhFddCtUVqWwF+twhkSFr+cNGaj7viKk66D9VF+6a36dynA0uwjrjdrJSi2+3GG+m6SVAJUo1jozCqv9vuVamdPdn2zFlMteVbgtw4IQ1+SoSmglX4GTYcSMzGucrg+2ZbWjP8K0PYNxyVVlFdK6U7B9nhJfcU9AVKZf7L7ycmpX95vH7AEoof5yirMwPIy1Q3yNBslYPxkvc6HLsCLUKW3OQEYW75vhkqzrYcUaXiT4QFNR/Yj0yUHOBTGrYUPbkuMhqJ3AoBtIHGV6EKTFF3nCyrzQlZ6u62xyCKPCpqNS9cHHVYlfrpXdO6pcHMrxdCDgBPUqNPG+cY/2tUtsb8b9I58IvBmBJ2dAgFHnPvBnnZezKsTrXeRJ5Z5FCObcWa11QEAzAa6l3ZqzRQN61s29HF0neVhoHtKw0RdrH7sj6Hh3l18kjHprcHXECFir1vxiT2dr1yq3KyJJND5R3cPugkK2EIEPnbrPiF/aAtqh3PUlPGfLHdrQKIhfmTzqOjk88ne++Sse6O0pYbXZC3IGqqS06/bQts2N26uEGhlmhaL1q03qBrwwT25riPYW1CwEmZlHBuejxg9xFvrNGRKZ8JZxF4HyRbmbyrnQHgQhZ8VkEAPrCPIUqJdQCYJW+J7AoxK2lrGKxHQH/oeQPSnQrcYl38nZRtYs05e6e+P3FrHBUIPXZjuz0CFvCI3t/pXVJCaVlZsUJGHncusEd/9aLJZP9hH5FvN0zLvhiwtFeC79hvStGbrrESWH5lAwIxQHhkoSSPYgccorT9NybWe/kZkclBoTDnxm0CeHT+8ixwegM9LOUKwLfm07+ZfrRfmRKxUvUcN0Mk45FYgBCkwAE/OJIZgiplUSvJ/R3eQIlspa2Ibt55UUbozbxtmxEKn2RmZiBmPOn9f+VX6tspcA59yKlUsh+lG+hM/ApHR8nObYTzjxrHx+x3LX/L0wX
 qUdo9T8e
 aAmx+gL9ir2+rS56jFocn2nfa4aA5sa2IaLjxJ8F252DDpDnAEQzzPP2JYqW6PJ6PnApfq/9JV+2jI0ws+wPhOxypk0S1MFkwQqMaWZtdBxt1EG8s9d8axUjFZ2Od04LN+03HPg6rrv9YocTBPU+AcyhXikXm/v0P85mDJYnSaxA8Z6kdg320Ed2F1rwH52naBsBlaphdpc9UEjSbvyriyfOcHhksOOGbrBNySkU5J6L8tVCO1bMnD94JRdlAEqN/72UrZnBBNK4n80Xbzg0Ni01o62jgM+vPlhBYsayAHyARUn4QquCf7mKyGjBxPCom20fCNko/7Y8sWSZ2XgNFYd5/nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:08:38PM +0000, Kuniyuki Iwashima wrote:
> We will store a flag in the lowest bit of sk->sk_memcg.
> 
> Then, directly dereferencing sk->sk_memcg will be illegal, and we
> do not want to allow touching the raw sk->sk_memcg in many places.
> 
> Let's introduce mem_cgroup_from_sk().
> 
> Other places accessing the raw sk->sk_memcg will be converted later.
> 
> Note that we cannot define the helper as an inline function in
> memcontrol.h as we cannot access any fields of struct sock there
> due to circular dependency, so it is placed in sock.h.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

