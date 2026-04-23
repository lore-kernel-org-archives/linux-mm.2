Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F4BF99370
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B6F6B0005; Thu, 23 Apr 2026 07:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC2B6B008A; Thu, 23 Apr 2026 07:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB2F6B008C; Thu, 23 Apr 2026 07:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE6A6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:35:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D3911A0113
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:35:33 +0000 (UTC)
X-FDA: 84689615346.07.75351B4
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2587A160008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:35:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OPCW9p4r;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776944131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iscWRn4jKN3kB/fAMJ/YC6wowWsWoekdUPD+h4UIdhI=;
	b=Z4E4NPDGmrMwJMBZPVpH3K3tIPbTWNAWoAyUmdbNi69Cl/vFz6ujByuB02bL1enAr5HU1m
	fD65EN/gEVEJg6cCY/A+ScRPpkj3W8yyXnq909InagBNq3PQJrXfayvLLzGcfHUKANbbri
	H4YjG1Es8+PDokhSWsFgJ5FN69BPBTM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776944131; a=rsa-sha256;
	cv=none;
	b=vjoylsBy+9yfjy4D/IiFimO5P90asw8kXWszVJYKVDN3Pv0aVnzRJtjyLjYKjY9608i5oT
	U/ZkVWBlYqKmltmkKHTLEXdnMQmPrs/WuzeOpKVliUnOY+FrkhyWlBqM6V2vXnDkscSDPE
	8ZaVBRjZDeTyV5XtC9auz4qt1qq+/Tw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OPCW9p4r;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38e68e4389cso69297691fa.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776944129; x=1777548929; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iscWRn4jKN3kB/fAMJ/YC6wowWsWoekdUPD+h4UIdhI=;
        b=OPCW9p4rma93TacWmxmHhOoEQomKy7hqlYensERV15P1UPlPWF/iZH4ovup8LtcVck
         jmMYfemqhChK8dMJr2NC6XdRHXs2Smg0l5WmTc3LU32Ig0NHD8OsInmTKT+gZ334D2QD
         I+S6ENKi+OSXvfYR64UiLrNVaJWiJcdq5tv7+PyW9UMZiaSD+Gc15JbzWGciKBiyGAk2
         0BChVpaYv3Lv0pFJ4abHwEECuImiZuI9/YUf2+AJ+Gk8fnBvE+2kdxNvenGe99312fCZ
         jgoTo5m1ITLs9YE8Z6/oRe++NFtcVPW0bknEasIKM597nA1R8xodLnZ6RJk+v23Ec5xf
         ak/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776944129; x=1777548929;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iscWRn4jKN3kB/fAMJ/YC6wowWsWoekdUPD+h4UIdhI=;
        b=TOp4Q4dvmUr408OXTHPPEgY3TDxAm/o/ss0kXZqPV9JiWpYB4OzOdNPCdNCdPhz/Yj
         AAuknabi2bbRzGest3wjLDk3KLn1pg4/PjrV4lGzMkmrGhXpeYSmxslwFg5SUA9BVWgY
         hfDPGCCQBmarrQVaskjok2FMMKjJe2QAcl87rax5vbZx1SYFlHZKVpDap0l/iBD4maED
         5z1p+vSuGzuIHreIBA53xLTL741gTA/ZKUzwjeP0WleV3K4Kv8eegQvUshAZYM4nQULX
         7z9KPHj+d0hzCKf9M7eK85QN5P0dEiAd/NsKZC2sOS8yXeUKgjduTjbgp917saepp/0k
         6HUw==
X-Forwarded-Encrypted: i=1; AFNElJ+2J8F1ox20Oye5bOxdJOXa1AGVKs5uYI00OPIcPTsetPzGLs6YgMgjpLq7az6M5EJOwRZgln49/A==@kvack.org
X-Gm-Message-State: AOJu0YwozkLGy1oE3FKVtvGXDTzoGtYIqsibpBf6PcFFTtKW96B34O7Q
	Ts1SNdgAQyme2eqMAugcRHA69sKmPalk2IRggGEQx9A1Z+u2pS/bwrqG
X-Gm-Gg: AeBDies4ET2qerqgslnDn/+Rs6Iw8tlJjVjdvBdPRITdTy7fyFz6Fx4Mln2Q7Tdwu4S
	U9dg0OxHstJDuIWZCO471u3UtUIPk0L64CMwE9CIQDLKN3Ns+ybfAYzM+FDDv7qwyXoilvVs0Tw
	C2sue6BjsO9CuBif85+1y///Ql7NxyCJPeY9LZL/Ea6tpJXuvJWf+lKmd7igHYHiuF0cVSHS92n
	tnb5a8HcAKCuSoCwXzQGn+PD5oV8n8omb79PPMnCa07b6nMQEps8ElEx6zI3+rK794jta6dzBKr
	4+Ej5IJRZbRYoFCOhokJRU5zKTmNDYAqcgNWRNnhUkMmRCap7Bkx6O9Z1SOxRGwDcXrAtJUCvM7
	bZZ+qiym7WKeRmz+OgOM2TIVrHpJaiRsVpOCJJXTP8rLC6/iE3bKk3Jebsb+ouAEOju/vsxAtBh
	fiSELNrUDV2eHwkPfpzXhqbSqmiQnEcJ2sbbaY48tE2CLAu5xFKthPdKpQqA==
X-Received: by 2002:a2e:bc14:0:b0:38c:4b14:144e with SMTP id 38308e7fff4ca-38ec780993bmr91273391fa.5.1776944128799;
        Thu, 23 Apr 2026 04:35:28 -0700 (PDT)
Received: from pc636 (host-95-203-26-80.mobileonline.telia.com. [95.203.26.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38ecb6f3a30sm40716001fa.24.2026.04.23.04.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 04:35:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 23 Apr 2026 13:35:25 +0200
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aeoD_Ts6hLsgNc9-@pc636>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aemevSofweaUSx0n@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aemevSofweaUSx0n@hyeyoo>
X-Rspamd-Queue-Id: 2587A160008
X-Rspamd-Server: rspam07
X-Stat-Signature: iu93u11qqgof91hcns1fomoxdok8kge1
X-Rspam-User: 
X-HE-Tag: 1776944130-320721
X-HE-Meta: U2FsdGVkX1/8jpQEASlPKVzIDVZCzoMa5HGxK4yR6FJdZyWsQMo18RK4Wm1mvlqK333w4KXdclzdn8PtAJ582YglYZxifvaeyuLPtWfjMI7JvhKNO3icK6m78M+9t+tasoWMeSgdMa33+Zzl3W8+piV9mphjKtTP5ZD2QK5W+/4dOMuJMmd1HZwNE9Lb77S+RB2H0jMP/FOnmCudYseDAEUZKH/8xh0SPaaOiL6DgMT3fqAzf6W/5phzXHdKC+4KIEAL1zI0QTvZDLS32R3gdT6BvhKi7CayUSz28QxLgbrbrgiWjv+P+04yCzP85MflyACFKT26F7qNAo0rLQ2WuumQaCvEmGwAzbbMWNjvD6z7y/RUKnJsEcnF4mEDIRwoJOATkVkJk3jSc28Ixd5QLxcEMoDiCYJRYJ9WGbn3jPKluxQ8WSkEKGj0i4JgQ/qNUTG6BLk1t436zeNe0enyemcp89WK4aOF9fHQnXk0YqaQHMpGPZ+iZfAcT7I1JMpW5/8cPGUiiQUkcBjXgc6x0rwdFRSeSG/27+tkIGsPWTwCcpsB64Pj8uTcN+7XF9lyU+Putw1p/yzGOC1RxIzZU1yEhoL8pAMG/2JjbkN6kqbLjvSYLBiHG+R332u7FLC6OKEPCBNI9Z6quj7XU/E7m3lMWiwZvGlptD2DvZgzqY8egEtXIUUrjRkjIbp/4tTIJ4J4CYX61DLnkXWKg3NBpC48TGVF2KMyg9LanvdONoSX/+0FpTZP+z1ztAkBlvC3TdSa6aspZ2hEGpAuBnPmEbpPExBVEtEZxk1B6NZYYldx0le9yCmtDJmXi7WsCe9D6PNFRL+/6c8J5D8sjGkCOXPFDQVHJOFZRbCgTYYTIf+CfwLSxllxvqpqHIqLok4hlw9Jw0227B4vsiOF9BkQ53RoWKr5XnoLOd5SQj4t1f7lx0JbdgGtgy7YchhAz9K6NkXoYFNFkVpwWH1FX5R
 bbh4MBCm
 isGngrVhiDslmAqke+fytSEeUKZZ7okKv0mqWZAk9VsaseodG9C+PGhltEb2S74UERLVEpoJlEAiFaAwiTaMQ3zuYxxD9y5WY1/s5o7S1TLGPPAiS6r16gubq3usrpb8M0O8XFKBM3YXS2bo0UF2cQ9oycxXr2MSjTDehz0aNd+Jalz7Kr6zPKt5/eyQWLdcwcaDKc2loNb0H7fq0yRKBW2MovWwWKjMfzFKa2TAbZDnfCTnF3tlrGpHRzmJjHVzZROJGc54smQr9ven7ciIjj4A3MCQ3h8JBVAkauOHsLrTuhLvyI3zA34+mgPFBbbUqF+uMNoJ5edZstb2nbWXuF8LKjLX29CaeL1x/P7dPrOdp7pYV7z7DsivvRj3to9U5qavlk3B4TcOaHj/02P5H0R1c1B3YuNwvdIXMTZN4Hoz9aCAKLJKT2nnscEUVRhGqkJy452xMGyk7Crh5KVLtbQCxQ70DXzuJXM96
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 01:23:25PM +0900, Harry Yoo (Oracle) wrote:
> On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> > I think a better option is to add a separate kvfree_rcu_nmi() helper,
> > or similar, and avoid complicating the generic implementation. Otherwise,
> > the common path risks becoming harder to maintain.
> > 
> > Below is a simple implementation.
> 
> I'm happy to keep things simple as long as that doesn't mean
> compromising performance.
> 
> We can discuss that.
> 
> > <patch>
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index d5a70a831a2a..f6ae3795ec6c 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1402,6 +1402,14 @@ struct kfree_rcu_cpu {
> >  
> >  	struct llist_head bkvcache;
> >  	int nr_bkv_objs;
> > +
> > +	/* For NMI context. */
> 
> I think "unknown context" is a better term since it includes
> NMI context as well as other contexts.
> (I'm also slightly moving towards the term, :D)
> 
> > +	struct llist_head drain_list;
> > +	struct llist_node *pending_list;
> > +
> > +	struct rcu_work drain_rcu_work;
> > +	struct irq_work drain_irqwork;
> > +	atomic_t drain_in_progress;
> >  };
> 
> [... changing the order of functions a little bit to help review ...]
> 
> >  static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> > @@ -1926,6 +1934,69 @@ void __init kfree_rcu_scheduler_running(void)
> >  	}
> >  }
> > +
> > +/*
> > + * Queue a request for lazy invocation.
> > + * Context: For NMI contexts or unknown contexts only.
> > + */
> > +void
> > +kvfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
> > +{
> > +	struct kfree_rcu_cpu *krcp = this_cpu_ptr(&krc);
> > +
> > +	head->func = ptr;
> > +	llist_add((struct llist_node *) head, &krcp->drain_list);
> > +
> 
> So it inserts objects to the list,
> 
> > +	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING) {
> > +		/* Only first(and only one) user rings the bell. */
> > +		if (!atomic_cmpxchg(&krcp->drain_in_progress, 0, 1))
> > +			irq_work_queue(&krcp->drain_irqwork);
> 
> and only the task that succeeds cmpxchg queues the IRQ work.
> The IRQ work queues an RCU work which iterates over the
> list of objects and frees them.
> 
> Draining will be performed a little bit more frequently
> (every call_rcu_hurry() + work queue delay) compared to the ordinary
> kvfree_rcu path (every 1-5 seconds)
> 
> The question is how frequent is too frequent, when it comes to
> additional IRQ/RCU work invocations affecting performance.
> 
> > +static void
> > +kvfree_rcu_nolock_irqwork(struct irq_work *irqwork)
> > +{
> > +	struct kfree_rcu_cpu *krcp =
> > +		container_of(irqwork, struct kfree_rcu_cpu, drain_irqwork); > +	bool queued;
> > +
> > +	krcp->pending_list = llist_del_all(&krcp->drain_list);
> > +	ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
> > +	queued = queue_rcu_work(rcu_reclaim_wq, &krcp->drain_rcu_work);
> > +	WARN_ON_ONCE(!queued);
> > +}
> >
> > +static void
> > +kvfree_rcu_nolock_work(struct work_struct *work)
> > +{
> > +	struct kfree_rcu_cpu *krcp = container_of(to_rcu_work(work),
> > +		struct kfree_rcu_cpu, drain_rcu_work);
> > +	struct llist_node *pos, *n, *pending;
> > +	bool queued;
> > +
> > +	pending = krcp->pending_list;
> > +	krcp->pending_list = NULL;
> > +	ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
> > +
> > +	llist_for_each_safe(pos, n, pending) {
> > +		struct rcu_head *rcu = (struct rcu_head *) pos;
> > +		void *ptr = (void *) rcu->func;
> > +		kvfree(ptr);
> > +	}
> 
> This is pretty similar to what a kvfree_rcu(two_arg) call does
> in the slowpath (kvfree_rcu_list), except that we don't maintain
> RCU state explicitly.
> 
> How much performance do we sacrifice compared to
> letting them go through the kvfree_rcu() fastpath?
> 
I think we may be focusing too much on performance here. In fact it depends
on use cases which we try to improve or fix. Freeing an object over RCU from
NMI context is a corner case. It is __not_ generic. We even do not have(now
in mainline) users because we never support it from NMI, just like call_rcu().

From the other hand, if you heavily reclaim from NMI, this is likely not a
common or intended usage pattern this is how i understand it. If BPF needs
it, then the first question which comes to mind is not about performance.
It is how to support this case in kfree_rcu() without adding noticeable
complexity or overhead or hacks to the generic path without making it harder
to maintain.

Performance wise you noted, you mean:

a) call latency(this is probably the most important for NMI)?
b) memory footprint?
c) pointer-chasing overhead?

Please note, when we are talking about NMI support, we are in a special
conditions thus we should no overthinking here. This is how i look at it.

--
Uladzislau Rezki

