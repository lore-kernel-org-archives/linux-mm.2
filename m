Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18454FCB61E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821E96B00B4; Fri,  6 Mar 2026 11:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8E26B00BA; Fri,  6 Mar 2026 11:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71BF56B00BC; Fri,  6 Mar 2026 11:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 60C3D6B00B4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:26:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05BCE59CA9
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:26:44 +0000 (UTC)
X-FDA: 84516166728.19.543AD98
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEF06180006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:26:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C0lE9u11;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yfBfVmuF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C0lE9u11;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yfBfVmuF;
	spf=pass (imf24.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772814402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnB0cI/1Z9yFMXe1fwshp/hNLux77/ZYEtoheQAsyw8=;
	b=Ux2v2LC/NyDsoAim84EHVPj1rDl0iNgdPQdJ+L2j/fLnLCHzxmdIo3hKEa5Xc59HIuNh0/
	1kC/9k3B1aF8xdu7WPamJHwD5ORMbmyCClJZXAl6jv1VHCiJTDzxEcxBIu+JMaWJkW09ka
	ERHIsYLmLm8YKfphTYkP4zaytq8SJKU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C0lE9u11;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yfBfVmuF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C0lE9u11;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yfBfVmuF;
	spf=pass (imf24.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772814402; a=rsa-sha256;
	cv=none;
	b=PVNbyDCsP2r2VfTtoERHCjcQHCtbwB39BuFP+fALCmg7qBW3ie728cAZp2nblg7ZeRc4Oq
	9B02oUCdp75qI2ZSaDo04qE28UZ4/vJ7jsEKN1+zXmdNFUWcOul8edIiip1uBsYM2R29mK
	I/cCpioYtRi5hT2GXcXA+/i75yoQEOs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 080823E7C1;
	Fri,  6 Mar 2026 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772814400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QnB0cI/1Z9yFMXe1fwshp/hNLux77/ZYEtoheQAsyw8=;
	b=C0lE9u11SBNDqYxDgb/EqKR7uwISO3ypiiKeAJxFN2i4UdAfpGE9C/jGsl0yhn06QG/x0D
	ev/FWgDC+2Aq6sBjsP0t2vPgFeIQczWGxx3fJ+kiD66bTDWoE5JxAyCceC6K8ivLB24v9l
	SZ/Fbjf1Kevg5PE5Wdh/gIxxAufx17Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772814400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QnB0cI/1Z9yFMXe1fwshp/hNLux77/ZYEtoheQAsyw8=;
	b=yfBfVmuFoScw2vvIggW9H1TkQ9xlggRJK+5m1zw9FygwxH7lW1litkNUI2Ax0UD62E6Pp2
	gk1tnPdMEE5K45CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1772814400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QnB0cI/1Z9yFMXe1fwshp/hNLux77/ZYEtoheQAsyw8=;
	b=C0lE9u11SBNDqYxDgb/EqKR7uwISO3ypiiKeAJxFN2i4UdAfpGE9C/jGsl0yhn06QG/x0D
	ev/FWgDC+2Aq6sBjsP0t2vPgFeIQczWGxx3fJ+kiD66bTDWoE5JxAyCceC6K8ivLB24v9l
	SZ/Fbjf1Kevg5PE5Wdh/gIxxAufx17Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1772814400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QnB0cI/1Z9yFMXe1fwshp/hNLux77/ZYEtoheQAsyw8=;
	b=yfBfVmuFoScw2vvIggW9H1TkQ9xlggRJK+5m1zw9FygwxH7lW1litkNUI2Ax0UD62E6Pp2
	gk1tnPdMEE5K45CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9ABF3EA75;
	Fri,  6 Mar 2026 16:26:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RHGCHT8Aq2mjOwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 06 Mar 2026 16:26:39 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jan Kara <jack@suse.cz>,  Harry Yoo <harry.yoo@oracle.com>,
  linux-mm@kvack.org,  lsf-pc@lists.linux-foundation.org,  Mateusz Guzik
 <mjguzik@gmail.com>,  Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
  Tejun Heo <tj@kernel.org>,  Christoph Lameter <cl@gentwo.org>,  Dennis
 Zhou <dennis@kernel.org>,  Vlastimil Babka <vbabka@suse.cz>,  Hao Li
 <hao.li@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] Ways to mitigate limitations of percpu
 memory allocator
In-Reply-To: <qz3f4p2ra6nq5cx3vlacmwif2ih5ojbf7s3ydzw6d7tgqn24lj@pnynq4l6oovc>
	(Pedro Falcato's message of "Fri, 6 Mar 2026 15:35:36 +0000")
Organization: SUSE
References: <aaE8rkGzxlB6wCTt@hyeyoo>
	<ji4ddtoo7mebygmytprcp5kpnu5y2ddthk5zhacshods37xij2@fs2sizuagdvz>
	<z7bjxfk7jah6zgyikhiz6eqxd3xwywxp745bykcr3sm3p525yi@4diwkjsoyckl>
	<qz3f4p2ra6nq5cx3vlacmwif2ih5ojbf7s3ydzw6d7tgqn24lj@pnynq4l6oovc>
Date: Fri, 06 Mar 2026 11:26:22 -0500
Message-ID: <87seaczzyp.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AEF06180006
X-Stat-Signature: udc5njsoa6dfebbux7p6n9qwqxsuupmy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772814401-994266
X-HE-Meta: U2FsdGVkX195CfNJYHsDSC8EP04e+XeU/4PNCe5k9PQux0adlfrru0ROh01GCTsCn5XveoLy8kLJMnxPHiuouqTohKX/KRnOqEVbcosnwcpeypMQ3JM0sdaKOqCxFerla2xBXbcn0ImjdgIW9GwJesIHXLJCFwgOsNDx4QQcRVD41CcRABwZVVWNc04GO547rqeL0jC1pkPK7hVYo6lJ0qx6UgNCyMa1XJBrrQZk9g0eEuJ2mXR6erjIWgDrUm1NNUB22auph9mNsOQxjsNGMipbNaMS4EvlhajgwqUyrm/kVj8/hTwX/UyX+c5UO8/7JniLwKn7zhcpIMOl7IQJQL4WF647goUrRTbpDxK414nwVTvApQD7ozhROYac+TbqC5izh6rFNwI645C/KqEEtUZ/osK/oZUs33wLSBblY5RQ9aOGIXRhIa43jFu4d0IdmnUwdfEp2oevXJod0Z0+0HkzvaqNCC/prgy8Gio9vsnLLQMwUydq41CdqPBxHU14B3aKF2qMhDwRbkBZgxa8ESJ9MaMLQNEXhAH3MvmWZX3rmmo1SJ00Q11c6bvDkPStOV/lLWdU1uc43YgwB1L7+Gtjb/mjBicwggYCYNfjUTHVFOEhD4UUnmPojGJwmtPWLtQ7Z2+whLWVB0AUXv8ervhZpJdPz+zjSvydw3HDDhYbMjYw+ZmemdNtts0qQg7dBVcuz5jpROmnMm1nP2AhH+Vp+lnh7fXiNgeVSpfl89npZwOtSU7Nr3HJsc0iG9IVX9YWmlYLfojFqoWmFgfXlzAeyyMs9QSmlEnma85JT9hp+QTq9cAQw8iawJ1dpeezEQgWlqTf0vWhr+u7OsnJ/8Pqzr9A4nJ/aNn+YgAgGmYhbpr+nQjrTb3JAQ/4GVmePLqDl9u3Mav2WGYn5mshr0mWqcp6ix/QUnKD9B5DmQHZ26k6NdiOxrLGA2emePYO4F4xve8XPtRf0ryc7m6
 zOa3j14s
 eSm2/DpUCGinWbvZl6fH165L2Fx1AZrMSPXkpybvVAL7D+Z8Y0BzT5x5vagk0peruj//IKA9+xh01dZ9V/r8ElAYem7u6vGL2zh515NiGfs1frokOnxe9RbIIkldpqxWC96mZnSjEWfG3zRxFnWRgYsSgXpMq/ish+2f4MhSmsXDIO8JGysqwq1Al6LhSoaXO/m0wEY8ED5Ca88c/dzpO7/gMZDONhGTT5GTF5bNrVfSdFw7bEFDuBtidhvz4/ZBX9wwWrYVYPhtKJGmpNmDlsYriL5Q0o+wCgQ+rIH3LA6tBfDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pedro Falcato <pfalcato@suse.de> writes:

> On Thu, Mar 05, 2026 at 12:48:21PM +0100, Jan Kara wrote:
>
>> On Thu 05-03-26 11:33:21, Pedro Falcato wrote:
>> > On Fri, Feb 27, 2026 at 03:41:50PM +0900, Harry Yoo wrote:
>> > > Hi folks, I'd like to discuss ways to mitigate limitations of
>> > > percpu memory allocator. 
>> > > 
>> > > While the percpu memory allocator has served its role well,
>> > > it has a few problems: 1) its global lock contention, and
>> > > 2) lack of features to avoid high initialization cost of percpu memory.
>> > > 
>> > > Global lock contention
>> > > =======================
>> > > 
>> > > Percpu allocator has a global lock when allocating or freeing memory.
>> > > Of course, caching percpu memory is not always worth it, because
>> > > it would meaningfully increase memory usage.
>> > > 
>> > > However, some users (e.g., fork+exec, tc filter) suffer from
>> > > the lock contention when many CPUs allocate / free percpu memory
>> > > concurrently.
>> > > 
>> > > That said, we need a way to cache percpu memory per cpu, in a selective
>> > > way. As an opt-in approach, Mateusz Guzik proposed [1] keeping percpu
>> > > memory in slab objects and letting slab cache them per cpu,
>> > > with slab ctor+dtor pair: allocate percpu memory and
>> > > associate it with slab object in constructor, and free it when
>> > > deallocating slabs (with resurrecting slab destructor feature).
>> > > 
>> > > This only works when percpu memory is associated with slab objects.
>> > > I would like to hear if anybody thinks it's still worth redesigning
>> > > percpu memory allocator for better scalability.
>> > 
>> > I think this (make alloc_percpu actually scale) is the obvious suggestion.
>> > Everything else is just papering over the cracks.
>> 
>> I disagree. There are two separate (although related) issues that need
>> solving. One issue is certainly scalability of the percpu allocator.
>> Another issue (which is also visible in singlethreaded workloads) is that
>> a percpu counter creation has a rather large cost even if the allocator is
>> totally uncontended - this is because of the initialization (and final
>> summarization) cost. And this is very visible e.g. in the fork() intensive
>> loads such as shell scripts where we currently allocate several percpu
>> arrays for each fork() and significant part of the fork() cost is currently
>> the initialization of percpu arrays on larger machines. Reducing this
>> overhead is a separate goal.
>
> I agree that it's a separate issue. But it's as much of an issue for
> single-threaded processes as much as multi-threaded. Say you have a 64 core
> CPU. Why should you pay for 64 separate cores when you only spawned 2 threads?
> (and, yes, this is a not-so-rare situation, like lld which spawns up to 16
> threads (https://reviews.llvm.org/D147493), even if you have hundreds
> of CPUs)

True.  Still, being an up-front initialization cost, it is the most
relevant the shortest the task lives.  I'd imagine that even for
something as lld doing 16 clone syscalls, the overhead of a single
percpu counter initialization is a very small blip in the profile, not
worth special-casing for.  The single-threaded case is the obvious
optimizable-case in this sense.

> So perhaps the best way to go about this problem would be to go back to
> per-task RSS accounting. This one had problems with many-task RSS accuracy,
> but the current one has problems for many-cpu RSS accuracy.

The current pcpu one has a much smaller accuracy error than per-task,
which justified its inclusion in the first place, no?  IIRC, there was a
real use case where the worse accuracy mattered for process selection
during OOM.

> A single-threaded
> optimization could patch over the problem for the vast majority of programs,
> but exceptions exist.

>
> Or another possible idea: lazily initialize these cpu counters somehow,
> on task switch.

>
> I'm afraid that while the solution presented by Mathieu fixes a problem with
> the current scheme (insane inaccuracy on large-cpu-count), it might also add
> to the percpu allocation + init problem (this might not be true, I have not
> paid too much attention).

-- 
Gabriel Krisman Bertazi

