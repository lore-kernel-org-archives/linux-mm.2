Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77312CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F118E0222; Fri, 15 Aug 2025 19:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F071B8E020B; Fri, 15 Aug 2025 19:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C3A8E0222; Fri, 15 Aug 2025 19:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE6808E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:50:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 733AC140305
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:50:04 +0000 (UTC)
X-FDA: 83780637528.23.ED077DB
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id D3D5120013
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:50:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IegLU5zL;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AStwkjtYPFPs1losmNujuyfgT/P/Bko56FEl6sEmJLE=;
	b=a2pw7CaDpFeMja92UEnmJ+qC6ij4vADNJxkwr4WVtEZ8gYGBtERwX8JMUKX/XzKoT2EW48
	28gJTgdaPThDWFvBFMdR8TIU3k5q//8RNqk5E+1cwFQ0CXPWw5vHhRvzhEbUke88IG8Z5e
	FTItf+7wCzcS6dxlhGYdk5tKSeCSsoY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IegLU5zL;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301803; a=rsa-sha256;
	cv=none;
	b=FspLS/mWIzJjy30gqf79hfslTZPHhCgFB6gA+VMuftLJ4NkYN1edisQm3T3qKN7cjgsK/a
	Pl8VIYSQ+ODq0BsbSlR4srDXS9JRdKof16GJWSVGhcOHGGDIRqxmwG47AVXlAAQUeETzCW
	x85jqY6QtpfFrJ42Zm0LQda6fjXRiD4=
Date: Fri, 15 Aug 2025 16:49:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755301800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AStwkjtYPFPs1losmNujuyfgT/P/Bko56FEl6sEmJLE=;
	b=IegLU5zL8xqeUevd5W/ZUhA7+P0SoQWo7A3zgD9QHDVTKAOuGgz2faXZ+MVoaRs4rsFHBE
	+UT12MZslTrYzjw9xGeBxraKE859jeYtIwU/Cbz66QXlM3LFo+xlBY2ccazs0qnujoTiOa
	oXsDvKyCz0YyomNTrTSxQonC6Oyhdlo=
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
Subject: Re: [PATCH v5 net-next 04/10] net: Call
 trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Message-ID: <pnlok4z77uygki2roci4sn32fosakjyciahfmtg5rnzj5vlkmy@u7jogibgoybx>
References: <20250815201712.1745332-1-kuniyu@google.com>
 <20250815201712.1745332-5-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815201712.1745332-5-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D3D5120013
X-Stat-Signature: rp7ungugt7uhz15ppkjj8ayhdgy4tsik
X-Rspam-User: 
X-HE-Tag: 1755301802-885424
X-HE-Meta: U2FsdGVkX1/5DtnfWvA5hF3qgNAk5Z4OmkETSAYtgD1s6WmZvdzS1N9XUK2UcxvBX3lY17F7BIZCVq105ydiWBlgNAavLAtOSTq4eXcKRbizVlkZCTPlnG6sPltO2vbHMeZlvxaaqM85ffl9ny7ZvS4sN0UKTsQmqBmwmmMjnUGY8thsSNPSlCt0w3OPU5O9zzfgdTAtfN+DpJZkZkTCg/fecbgZ5ev+ntS+H73zATO0DIGUcjP1g59x/bIulq2AB1hcDtKZtzYHq/HYbY4/n16JXUdWrE0esR3ySmAOM3+Mu73vRGCDqOtbdaspSepO4jp2czmfXjLWGu3EAj2dZ2S67n9TMNW9f2GujPnA4kh/Tg/qdwsMVM8WGw8DUmOEjEy9wBXPhVpQbmIbIYjtjXos8/rz5/4CdQb1bdLj3OQRCBp0TLqD0YmZ7hJpZldnN1VNvzPdci3HoqDARltNM+8CsTiPZysjYNsVPZ/tezMYrDZ9nCIkiCQEL+FR0/JI52IvLbgzVgOW6MOWM43YF6Xjxvx9o6ZOsjWhfWLsaHgWmOTUVOeVsLKSaBO706hVfCgIK20qP/ujRL4OEDGeGQsARWpxm1ECa3Ldzcwe7mX9Uf7Sz8xkCI/S2i/VSNSFtjoGd5b4QOufxY/QvtFxx5k5ULIi5GAeVVkHbVuuoVZcbIOdYK6ViEJdASSjiOMszvyaSCT38xKqpc92PA0Ag8eZje+cYN6GluuY/7xann4LIBLH3Buda+wufmKc1A4kPZcrQOCLZJXRUXPgt/0M73EH/s0h3SxhTUEX3l8VVkKZyiNEsevYV+wl0PmbmqD00da/1nnarSGnoQ9oIgWpT1A/rKZJ26vim1jea3FQHj5wRt3cG/3k3W8Ob4BP9aTddTQL2VmNW14hKLEOK6iJfUcWFlBw4ggE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:16:12PM +0000, Kuniyuki Iwashima wrote:
> Initially, trace_sock_exceed_buf_limit() was invoked when
> __sk_mem_raise_allocated() failed due to the memcg limit or the
> global limit.
> 
> However, commit d6f19938eb031 ("net: expose sk wmem in
> sock_exceed_buf_limit tracepoint") somehow suppressed the event
> only when memcg failed to charge for SK_MEM_RECV, although the
> memcg failure for SK_MEM_SEND still triggers the event.
> 
> Let's restore the event for SK_MEM_RECV.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

