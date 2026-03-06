Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B679AFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70056B0005; Fri,  6 Mar 2026 10:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47066B008A; Fri,  6 Mar 2026 10:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1BF36B009D; Fri,  6 Mar 2026 10:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF1DB6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:35:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6770559A93
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:35:43 +0000 (UTC)
X-FDA: 84516038166.29.F75564C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CE43180009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:35:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jix8/CU1";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zCRnEDyp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jix8/CU1";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zCRnEDyp;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772811341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1H8eA+/Khh3IEN8ZUNAeQ7pBDdV5DwaIi9yEt/3FUA=;
	b=liIESVJ9ooRE9HM/8JEYAQM6yy+YRoTsGfk5OvWd79J6YdM+fx2Jv8zeP6Z+8XJ91S2yv5
	26YRM8lwKJIsMSDf0tks5xMX34BTtvNWfbzsze9Rq9Es5IvU2wXnylHk3+1RP8MpPS+6o8
	4/3GUHq5elwXz8Lh+EB7TEssUgW57oU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772811341; a=rsa-sha256;
	cv=none;
	b=WmjgOkOlyQNX8YIvB9XUHBx6qCOAVt0mBt9E7YYvF1prLChf8pf5FLHwXo6aXj+Miod8O2
	cWc9G6f6dEW2FNBYNOeECuTHu0W14st6B1H2RRJoL55dgMJtMSlIpT2v6/vlYItnxhI9wu
	HyFrGw4XGi+kJ8mRVe9EMakowgzanis=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jix8/CU1";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zCRnEDyp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jix8/CU1";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zCRnEDyp;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 361905BD83;
	Fri,  6 Mar 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772811339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/1H8eA+/Khh3IEN8ZUNAeQ7pBDdV5DwaIi9yEt/3FUA=;
	b=Jix8/CU1HkPlSuU4p3pB/WFzKsIDNA2b++7JMgoj8JW1IXjjH4EPlzTLpVE32k7nHwR7he
	pg2XZDIYiw7kIKBLUqKp9OI/bsMTFKS8gHuRXLErcMluCQ1ztn2FZwDZlbkh2bvIxdqXO3
	uYZaIjxL2oLIJYqlyUModKwIOfktujY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772811339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/1H8eA+/Khh3IEN8ZUNAeQ7pBDdV5DwaIi9yEt/3FUA=;
	b=zCRnEDypJpE14k4vi13pMFiU1XWtJ25LaE2IMVZSWUaZ+FqIfXU1ZmA5vJAJHwwu6bZQTY
	mwnmrVy/fETQe3DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772811339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/1H8eA+/Khh3IEN8ZUNAeQ7pBDdV5DwaIi9yEt/3FUA=;
	b=Jix8/CU1HkPlSuU4p3pB/WFzKsIDNA2b++7JMgoj8JW1IXjjH4EPlzTLpVE32k7nHwR7he
	pg2XZDIYiw7kIKBLUqKp9OI/bsMTFKS8gHuRXLErcMluCQ1ztn2FZwDZlbkh2bvIxdqXO3
	uYZaIjxL2oLIJYqlyUModKwIOfktujY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772811339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/1H8eA+/Khh3IEN8ZUNAeQ7pBDdV5DwaIi9yEt/3FUA=;
	b=zCRnEDypJpE14k4vi13pMFiU1XWtJ25LaE2IMVZSWUaZ+FqIfXU1ZmA5vJAJHwwu6bZQTY
	mwnmrVy/fETQe3DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 611AA3EA75;
	Fri,  6 Mar 2026 15:35:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Yak4E0r0qmkOBwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 06 Mar 2026 15:35:38 +0000
Date: Fri, 6 Mar 2026 15:35:36 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	lsf-pc@lists.linux-foundation.org, Mateusz Guzik <mjguzik@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Gabriel Krisman Bertazi <krisman@suse.de>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Dennis Zhou <dennis@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Hao Li <hao.li@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu memory
 allocator
Message-ID: <qz3f4p2ra6nq5cx3vlacmwif2ih5ojbf7s3ydzw6d7tgqn24lj@pnynq4l6oovc>
References: <aaE8rkGzxlB6wCTt@hyeyoo>
 <ji4ddtoo7mebygmytprcp5kpnu5y2ddthk5zhacshods37xij2@fs2sizuagdvz>
 <z7bjxfk7jah6zgyikhiz6eqxd3xwywxp745bykcr3sm3p525yi@4diwkjsoyckl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z7bjxfk7jah6zgyikhiz6eqxd3xwywxp745bykcr3sm3p525yi@4diwkjsoyckl>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: rnfwattccxcint5wzndk8s6i9xwynjx1
X-Rspamd-Queue-Id: 0CE43180009
X-Rspamd-Server: rspam03
X-HE-Tag: 1772811340-811568
X-HE-Meta: U2FsdGVkX19GZDMdbeuouUiJJccoHo3q9AJ1raKdV96FgfyXdlqp2rKvSVUnKpBEO8/CUlVZGMElgVxTTs+Jg0R91yqBXJAddk2VNqTYvfkeJRLYrgf0xaGmzMeagJgYBkyhzO2/ygPl8+AnGmpujUzxyBnAXRWJAS0suVaSFEw3PuLmD+je1gwk1okRHXOV4dpwLKJ855D4ltaVwFTSkSl9IlZqsRc2cZzyTHziJx9FL7DYJgcUcbOOWzA+z2mOXmAp3Hnc+peZ42HdJPMPruoC78K/blw/CKIRp0oXlNt1FuU1NDczY5UoGoITUT5TY0uGqd+9UdyH7uyfpxy885XFAewhaa+E/XVWO+PLavyqMNSj8v/ljL1RGnpcJTKyWbK8obQ0+Sef6ECfQ5P21UsyIT2M/F9vfUbA/ojoXQRaeW5INFGahBv0ccWN8ZGFk+Cqd6UshX4//hBnV1GMBsu161GPxbsrX8LiGTb7gnCciTxgB9nc1lEk6N+k52RpEb42TX0s0OgsJfSKp2IGeG2zqGNyuZujkS5EmaJt6141B5nCr11pbOh2Zth+YOAacF6uqT9iv/2SBpjOyJL7F9McOBrCEaidTzHlfkkcbuo2okKULKjE0tv3+sLbhOYBFcYgRCjsodE6sjBfLdcJoPVEaL/7JE1s/w7tULmnP1uVnuEjx4MYek3+NNHpP3VyLKHo/GNdYwn+VTPmQkYbY3+QNUOxaS9k3+B5e0zMOIn8qbM3Gyg0Fc+DzzcLFvSv73P4oxjFE3BqMB9V07UYziyv1NnGfHr7uUkUI0Ln7pP24ZqdRGV2jIrKLTkfIkGFI4HbKuSxqg7xYQnRFshKLvW84fcVaoAMiK1+MBcVpxSofDd2Ubyrjk2VOK3w8FnyG/QLZyf7HTnGHILPN1m12kOid7MX54WO5RjD/RukfxrLFNfxNXF7en6FuMFfEP+td6EKXQFCg/HYQkTJcxo
 VKWeWjlM
 ixr0N1SAAgTeY4L8o2EaQPTPN5A+9qg2ip/lGx/f29ATWDQ9LXv/+WUbenDBjLkS8ne4cndvbkpMtY96bLN1usCxkQkYsYBXqJhVpbpriCsf/JjLQ9oRcmKNgZbo/fykv8j135zLzSdwAKPS+Z03tvsoZ0QtDzoRd36qZE3/WonhbfrJDYmkQFEXpaT5deT/9Nld8tz/IZ4/IV0xPW7UaNTbEnHjQJW/6GwFnF7a5q7COx3bLcGPVWooCY/IOLMThYRsdtK+jooIdv3wb7rQZfziusJKABKffA/F6rtfcDOkNGKvxEPDIzcemlF4O1yr/8GTT3YfRi8HnFlABicnKyDUuGlQSOTk5tT2DnTQRxW9lJ2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 12:48:21PM +0100, Jan Kara wrote:
> On Thu 05-03-26 11:33:21, Pedro Falcato wrote:
> > On Fri, Feb 27, 2026 at 03:41:50PM +0900, Harry Yoo wrote:
> > > Hi folks, I'd like to discuss ways to mitigate limitations of
> > > percpu memory allocator. 
> > > 
> > > While the percpu memory allocator has served its role well,
> > > it has a few problems: 1) its global lock contention, and
> > > 2) lack of features to avoid high initialization cost of percpu memory.
> > > 
> > > Global lock contention
> > > =======================
> > > 
> > > Percpu allocator has a global lock when allocating or freeing memory.
> > > Of course, caching percpu memory is not always worth it, because
> > > it would meaningfully increase memory usage.
> > > 
> > > However, some users (e.g., fork+exec, tc filter) suffer from
> > > the lock contention when many CPUs allocate / free percpu memory
> > > concurrently.
> > > 
> > > That said, we need a way to cache percpu memory per cpu, in a selective
> > > way. As an opt-in approach, Mateusz Guzik proposed [1] keeping percpu
> > > memory in slab objects and letting slab cache them per cpu,
> > > with slab ctor+dtor pair: allocate percpu memory and
> > > associate it with slab object in constructor, and free it when
> > > deallocating slabs (with resurrecting slab destructor feature).
> > > 
> > > This only works when percpu memory is associated with slab objects.
> > > I would like to hear if anybody thinks it's still worth redesigning
> > > percpu memory allocator for better scalability.
> > 
> > I think this (make alloc_percpu actually scale) is the obvious suggestion.
> > Everything else is just papering over the cracks.
> 
> I disagree. There are two separate (although related) issues that need
> solving. One issue is certainly scalability of the percpu allocator.
> Another issue (which is also visible in singlethreaded workloads) is that
> a percpu counter creation has a rather large cost even if the allocator is
> totally uncontended - this is because of the initialization (and final
> summarization) cost. And this is very visible e.g. in the fork() intensive
> loads such as shell scripts where we currently allocate several percpu
> arrays for each fork() and significant part of the fork() cost is currently
> the initialization of percpu arrays on larger machines. Reducing this
> overhead is a separate goal.

I agree that it's a separate issue. But it's as much of an issue for
single-threaded processes as much as multi-threaded. Say you have a 64 core
CPU. Why should you pay for 64 separate cores when you only spawned 2 threads?
(and, yes, this is a not-so-rare situation, like lld which spawns up to 16
threads (https://reviews.llvm.org/D147493), even if you have hundreds of CPUs)

So perhaps the best way to go about this problem would be to go back to
per-task RSS accounting. This one had problems with many-task RSS accuracy,
but the current one has problems for many-cpu RSS accuracy. A single-threaded
optimization could patch over the problem for the vast majority of programs,
but exceptions exist.

Or another possible idea: lazily initialize these cpu counters somehow,
on task switch.

I'm afraid that while the solution presented by Mathieu fixes a problem with
the current scheme (insane inaccuracy on large-cpu-count), it might also add
to the percpu allocation + init problem (this might not be true, I have not
paid too much attention).

-- 
Pedro

