Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A9F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=R5FD+nm+
Received: by kanga.kvack.org (Postfix)
	id 33B596B05B1; Thu, 29 Oct 2026 16:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312356B05B2; Thu, 29 Oct 2026 16:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24FB56B05B3; Thu, 29 Oct 2026 16:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1266B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:02:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8521940507
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:02:14 +0000 (UTC)
X-FDA: 85376735388.01.F24DDA0
Received: from mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	by imf21.hostedemail.com (Postfix) with ESMTP id 872651C0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:02:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R5FD+nm+;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.59 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793304132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7QbBREQ+MMItXZrHv3jRMCCfzMElbblNplhpdNrQEw=;
	b=cRkxcYiBhqSCLysFLzk0wM2XHF3wY1EgOisnzgY9kmWLMArwurQ8+bUf4TYmn9/x6R0Y+H
	0btoTgTQxtSVe7ucHYKrjbmVtlwnkw3QkfMeO1YTyr1aQohI8wx5J4XbV5x4Y7wN854Rdv
	a9nLjLIfOyeNfhMLrFPqowXgo9SuZfY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R5FD+nm+;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.59 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793304132;
	b=iHOa4P0FWyO2DIiCFrpOsnHL1VZFNQNH9kxnVFXNt7MCixI/1SyUeND77a3Zk9OURs4zhI
	L/xvkqIjQeRpka0rQLGFoS055kONWOl9lCe9f6/oUGsk6wWsVotYFhaHJ2PFwnR4YWSck9
	rCn4ZRZcyhGDdqQPRUYgg1vnVHkS/rA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ndNJf7YwM/TOx7eJIWnPNAnZdeI6PTLMRtwC3Ga2kgc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793304131; v=1; x=1793908931;
 b=R5FD+nm+ES2GqGAlLDYIr0noOaiHbufDhLblkQV44EE+o8ja81HoIrWU4ks+9oGUijr15gz1
 PBUbnW4lPU/2YR7GEIPbqSR754lS2Qk4kV9E506Za2bQl05RSWQUkBB6FndvNbiFnSGK5OgNsKH
 LjZicVPL9z9uz1M0cQshoQhI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1426dea9613e2433;
	Thu, 29 Oct 2026 20:02:10 +0000
X-Mizu-Trace-ID: 1426dea9613e2433
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 13:02:08 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, yosry@kernel.org, 
	joannelkoong@gmail.com
Subject: Re: [PATCH v2 0/6] memcg: Batch mod_memcg_state() for MEMCG_SOCK.
Message-ID: <auOlmxtQ5-EZTj62@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <auKSeCFvsWzP-XYy@linux.dev>
 <auKYs_ucslI-tdar@linux.dev>
 <auKcNvAizn-B92xB@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auKcNvAizn-B92xB@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 872651C0009
X-Stat-Signature: dmyegrtwnhcb9caq3ftme9gzzebumn4w
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793304132-322638
X-HE-Meta: U2FsdGVkX1+NIDo/tGAbj3TF7YhGrWH++FYTLVulQVTZ8+tHA0HzLUZ6stRQLYIDuzh1XXKFbSGFTp5EHX82GwBTHnex6p7Vtu4uM8mHor2wIVlE+jv184P7KR2yOhy/NSpMsjdy0jHO7aXjCZX1ClPFMJeTcYnni0eoYqJR26vMW0xbIINSNXiToNvUKpIjgyE1BCayxsPUJ427IsDOpCYcm1umnqiP5Ub3QqGcoHq/IlUOpoacjJD2Zc4xkUFFlxI5Z3EanYsv6iiRnVQXg7V7GRjdvyoDQqv9KgyohxdUVOcqdEb6FjDGOGkr4JKDCQ6UWXE8+8RZ0UyPMMvbZ8zpUASlqSjWm8x9SKMzCsN1At9zXFXgWIjFeVXS+UnXdeuht0IURrfmiserGpV+j3fAei0N5kmfFE3OHoTS4tW7iTzlefznodquDjAGgPLJSfbw861PYeJJCRK6EnF8qcAHnYgv9PMG/TqT7hoR6XMuAqY83BZ4pGzPX9xs7ZVWhsm2BRBHCDdNkOH6VAJ3spvVLLTw2msp5tQWMauq8T390l9gx3uEp65ZwkrGdDsy+D5YfBaTN0WSWDJPSMleq34CO5JmhNv1aa+V3w9q9SDbjk4D4rENjEaTrY9n1rql2ywWJP8MNKNeI9bjA0pNAgsP/HM1Y7BKO0/WDtQNNhgViDOjexyAIvzvUMnavdCRWNRA8gHcIahbqrI8oSjTK3zD3HQk5UfawLCPJQg2pc67bzQmYgXTUwb1N+bak2peYYXNfMialPkdMtNtLeN3BHXEIrXuP2QcSL7ZoYgvPpJUGURIWRjRLRG35/Oih2UI5/guAKBv3JVYLss+RSiXLOq1T8yf6Ojar8h15DZJfWeEBXRWRMZ7cmU5BMluK/1kyN+A5XNKpkN+PGpzUkTf5F6aVuSyt7wtrP/OezBgJVJOpVaeUcKq0docHSL+iHH7oBoeC6qRLZNHh0TFGin
 BNADQJnz
 UOJVDbcLG2nxAUhaAD+H4IXVFkoWiqSJWbxxyKwDvGjm2nzoRuB9qMxL7NwFnzOFcg5eOnf0dwYSN+F6hSKhy4PvgvFYDAhuKU5oZeHczkV37yxDlCMhedIuX1O4/oFTeKq+PQ0ZDG6vfjq9ttzelHfTSQJUsmKah3pxbvMQN54phe9Q7g0/rvy+juxTLO9LUUeHaBIJLW4546eZwiCKP0E8/rDVdB+MMIUi0o+60gdOvTOae36EnZcW/UxvwIGfJUvtYHyV24cmySTmN3oNjw8Sy3M6E2i1stdIP6ytdKrEBBO5MJ9A23R5SRwHxgEujEQGt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 01:35:18AM +0000, Kuniyuki Iwashima wrote:
> On Wed, 28 Oct 2026 17:52:32 -0700, Shakeel Butt wrote:
[...]
> > > 
> > > For the 4th patch, I would prefer we first try to move the network sockets
> > > from memcg to objcg path.
> 
> sk_forward_alloc is already batched per page, and I think
> migrating to objcg would just add an indirect layer and some
> costs for css_tryget() / css_put(), and still inlining
> __consume_stock() or batching in memcg_stock would be crucial.
> 

We are over time moving kernel objects holding direct reference to memcg to the
objcg infra and the reason is such objects can become source of zombie memcgs.
There is no urgency for the network sockets but eventually it will happen. We
will see if indirection is really measurable at that time.

