Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C80CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CB38E0025; Wed, 15 Oct 2025 14:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D618E001D; Wed, 15 Oct 2025 14:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C508E0025; Wed, 15 Oct 2025 14:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90C3E8E001D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:36:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 481A613A3EA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:36:14 +0000 (UTC)
X-FDA: 84001203468.17.7CF8A18
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7290A4000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:36:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s9kHS2f+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uk3MP3pS+gPT2tihmTeblANXv366efmN7AcXHGrPOtY=;
	b=0aT8hxdEsmfj/zguvrCIbUT4ntM44OIhpQ7CjHBh7sUZ+PTteXY0vgj8V/fooYWsuaM4Cv
	zJuMP73tZ8SFk7q/tUdg4ZCMbwAChHHTPmogL5k7B60la68QCZGs1b0hQvKFNm7d4nV5YO
	p/A5Gc46c/Ul9dP+f6wN30sRkIcYhRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553372; a=rsa-sha256;
	cv=none;
	b=mtUdzkTaDHlgf2jnfH9UOXfTqnPxa6tHlbOX59MRslLveBudxAh824CFQ8A+kIe8f0uQeJ
	lH6XDh9BRrZSrD/jyYOqNFcOewjRgLk86zG6Gurm2fU2iqa5sKjOyotGY+9opVxfk6/t0T
	BC1fsOhI77jCapL7U6iGGkHqn+1RuAo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s9kHS2f+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 15 Oct 2025 11:36:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760553370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uk3MP3pS+gPT2tihmTeblANXv366efmN7AcXHGrPOtY=;
	b=s9kHS2f+k/PNc+fE4JKbXrv3jOMar+OiymkJ5MXwoiaCapJXLGkeyEkkVJC2qcVNdc9X/e
	oWrjUpyMZBSmuB1pO/8/WU8bpR6pkPv/vC+rZN3IwGTnLNPYOC7kfe3MPAEmnf41RqwBP1
	FQ66pVe3ZLXCkQkcegJFiri8n2RBS98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
Message-ID: <xfvvlbicyui22lhwptmdxtjfmcyei3m2bhhie7l2vjw4xa23cf@lhuh5q7vhwt4>
References: <87qzvdqkyh.fsf@linux.dev>
 <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
 <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev>
 <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev>
 <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
 <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
 <5e603850-2cfc-4eb6-a5cc-da5282525b0d@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e603850-2cfc-4eb6-a5cc-da5282525b0d@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: go3fmfpcfqturw16wmk4q97as5tx1z6k
X-Rspam-User: 
X-Rspamd-Queue-Id: 7290A4000F
X-HE-Tag: 1760553372-431595
X-HE-Meta: U2FsdGVkX1+FI+fdA8E6RJ8jBIuk4y/DUF5JpH5SfHLo8ywQ3gxgnG4HelNy8QlZCKshvue9OMjvOn7UXZ2FIs0EU/7TkZUoaZgj6UykjVNOQ8MP3qi6gWlld8gRe+LF16IxWcwEnXt+CBubC/TOPo1rf0OcPGmPndfS/CoEpLTkLz0m1oKlFNO9iu0Vk5KUPaYfHtgJoqwBBSkkt+Yz1dZH8TJEWl6qM6ATiBKVrkHn5tCFkYXKryLiPNaH7rAUDG6IN/rxELFMVNxRzPyIkRC6w0JY5WbDZJR76HuFVYjyovUrLB5SxHYltRc/9VYZJ9Dt3fqcptFjpvv7eeB1S51//62e+vgib9v7WBuaQtiMwgiJFEPazVHMcnpDhdaMKejsFiIcAPMobWMA2fYliRwP5TPNtCESzf5hCAxVevwhG4FoCRI3n5fr7KfZM+L14tewPKKa2U6EO98Hhuuiqlk5f4Em6CqZXcIvYTfEBUcksLtZcyITFfpDvEmeeoPqLEIV8GY/Jt4o2jz533lwTtFnn6LPEfgpG67cdBNQw4/QtbG0DgWKrKcbr0hAZcDIRLdJ1TyRq9MS/uMZO6deDbbPTNM08js0gnMnlmmnUzz1jhJ+Ek4GGFmIVbaMr3sX2qo3hsAHl8yM5juMBFuD00Rnu9AfhJa7EG3oM6LzxFD49QFTixi1i1XTzLC2dw7gjmQZRqGkGgdLf/bn8Jak2hy55uIhpJLP5EfQyEAQhXqp7xSyX9upI7j8Qiqf4q/yfN+tI+uPlFqdgZqy5Kk/B4MiMQOSPAL6LCw6rQVa4APViw53Bj1w8nkNncxsjipQ684C+BuVeZRa3Gfy6oYRf5v0fvE8cL/ioZz0sFJXDnWiovu9BcTBImg3HwD7vKoPmMOrImk9x1PEjbeE++snwNKyugMf7TX5d8q+tWVfnQwO6fKrjbcIW8G9y50JNRVKvgz5Q4wMO5Z1NDlNUcg
 jCt9dja5
 iv8R3IDeTYiKP4COtWwkqvOjH3MzAOGc+Yu93m+bziWhoP51QtIuT2aPx8zxjEDGZIR+W13TFBNBhYwsUPmFFXOC3mxrGLOuAM6i4O9IyiXWOU1LzWXctMJJeIoB0+CDIqdHtUtay0L9EVM8Oq0qvusJW84prXff8IX0BIeWhhv2/WXt7+Kk/sEmQGdbsjWWRhsLUHKqTtE6giaY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:57:29PM +0200, Daniel Sedlak wrote:
> On 10/14/25 10:32 PM, Shakeel Butt wrote:
> > On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
> > [...]
> > > > > > > How about we track the actions taken by the callers of
> > > > > > > mem_cgroup_sk_under_memory_pressure()? Basically if network stack
> > > > > > > reduces the buffer size or whatever the other actions it may take when
> > > > > > > mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
> > > > > > > is what I think is needed here, at least for the debugging use-case.
> > > 
> > > I am not against it, but I feel that conveying those tracked actions (or how
> > > to represent them) to the user will be much harder. Are there already
> > > existing APIs to push this information to the user?
> > > 
> > 
> > I discussed with Wei Wang and she suggested we should start tracking the
> > calls to tcp_adjust_rcv_ssthresh() first. So, something like the
> > following. I would like feedback frm networking folks as well:
> 
> Looks like a good start. Are you planning on sending this patch separately,
> or can we include it in our v6 (with maybe slight modifications)?

What else you are planning to add in v6?

> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 873e510d6f8d..5fe254813123 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -52,6 +52,7 @@ enum memcg_memory_event {
> >   	MEMCG_SWAP_HIGH,
> >   	MEMCG_SWAP_MAX,
> >   	MEMCG_SWAP_FAIL,
> > +	MEMCG_SOCK_THROTTLED,
> 
> This probably should be MEMCG_TCP_SOCK_THROTTLED, because it checks only
> tcp_under_memory_pressure, however there is also the
> sk_under_memory_pressure used in net/sctp/sm_statefuns.c:6597 to also reduce
> the sending rate. Or also add the counter there and keep the name?

Yeah makes sense to add the counter in sctp as well.

