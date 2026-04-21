Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F702F94CB6
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 23:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F986B0089; Tue, 21 Apr 2026 19:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF8D6B0092; Tue, 21 Apr 2026 19:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CED16B0093; Tue, 21 Apr 2026 19:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 576A96B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:10:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 065F2C2BB0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:10:45 +0000 (UTC)
X-FDA: 84684109650.12.4E12CE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 48E78100016
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:10:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yy5hv4Ym;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=abfs=CU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=abfs=CU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776813043;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjY3hAcPIAFNv9KeU2YR0lxnwI1m/+rgQL2KwUm/QRo=;
	b=6sDg+ZTQ5+IO6H0VvRAjU6SZt028p9qEazQ8ODg2XHvoWISp+WRD6UDR2To0lyzsdFmc+E
	bcqCHROa8N7euEml3YRW9kinir6PD8HSSQXjrLHvp/FTAehIGVOgD5xUMrQifrJdZAJ1At
	1UszlzWq12GXU9TLFJm64lZAgu09tAw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yy5hv4Ym;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=abfs=CU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=abfs=CU=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776813043; a=rsa-sha256;
	cv=none;
	b=56l97QKj9h25SVl+/a0v94PU5uzYjKUYmOMwu+9bcX7ZanAbb6GxBcBE6CsyBxQnfgaXd8
	8ZumKfkDBDk5NAHXY55abkGdXhZvg7+4nK+VXhJmmQsUVp5U78SdueKKfDJQ83+yBG0Mif
	hwU5gbUHEaa1ZR4i+mmap/GA3SB6Pqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6602C600CB;
	Tue, 21 Apr 2026 23:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FACC2BCB0;
	Tue, 21 Apr 2026 23:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776813041;
	bh=uWFGKbNF+jvCnJvLU7bV2fXPTdB62h78thExsjJWKSo=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=Yy5hv4YmmcgAI82jCQraYYf5vDilMpQRVB61ZB03JtSBqLmUEK2zz+nNiR3JTMT7I
	 kcmkeeBgL7nMrU57E/S9EWIRivKvhpoQXon/miiKn3YSgyAOD0HRo94fvSfRgfJIDL
	 1tLNXXxiLMBlyvAp257ITERNKS0XSCGQ+cdlG+D0ze9cKeCnAu0NAbk76PMugRl7qD
	 nNNEIFY2A9qCg9QrltZef577/7KmG2/oGr3i0keM9Y4YCh/7NambeftK1mtAaiLF1q
	 Tn/n+/Uk7IlvVi0Wdh96CrD6K81DZFXlrpmV9cTXvzxiIr6y5PvOkjLBXr4uYyXwbS
	 6fGP3gb6xuX9w==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 488D2CE0C56; Tue, 21 Apr 2026 16:10:41 -0700 (PDT)
Date: Tue, 21 Apr 2026 16:10:41 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <805c33d7-3a7b-470c-bd9d-065717a3e3e2@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <DHZ7543VMYIQ.1US6BY7G0AUJK@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DHZ7543VMYIQ.1US6BY7G0AUJK@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48E78100016
X-Stat-Signature: 1u6c16qrzxgpis567tf4spmrwpjrzz9a
X-Rspam-User: 
X-HE-Tag: 1776813043-636526
X-HE-Meta: U2FsdGVkX19iRcI3dXjWYRa1rzDT2b8dz/Hml6P6xo8noOQETvRckXIVCwi8X1/FFZYtDJyqyzS4tHq8J9Owid3aBk94V+91ZJNL0Ri9YKCfpAfLYtpf1IZziE+QEILkwZyjDSLRL1HCMP0jxIzcS7KLp4Mr0Wv1OhdpjACiqcevIe3QaDopfdSz64p5J2gIrGI/bwadvHQj5VIZ5+AdrLpJk8aMcTJIiXZHa6oZorfnV/F07LtcsAOvcFYjsjSJDevQpvMEC44XbDHj2wI2ZtEznFfAbS4HQT/5PjX2dSLeHiReYRTmUEMl6hJQB/TlkS94KiMxPy0nN8VoSIXmYp6x8J5V/wPn5e8IQsAumV8okzg3WxZQo4YYwjQbKTONb/mmSVrP4zFaZ3IQ232jqITh+P7+DXpw9rNvSqdzVI1JDo/NgZ9xG6fkybKvbfdj8BGZ7oCDncRa7yliQLZbRRnztJx/5E1ob89wn8YEQTr3ooWmMQZQUfoXzMAXxj4z4MBbLRds4LPgZwViiG6RjDyeKFM/f5rk44S9gSpWJaJkQnyWulOyF9jxkrzEYfSiYoxCGLfbTRZkmRgKgFx7Kfu9B2fegeluCeTxnFgc68FS6cBUv0Cc3oDwHa6ux2UEOLT5F2c/XO0hGGHSxSsYsEKWDluCjY7+g4SFPJ3PxvkaxaLAAp3OgyjUnedeiU9uDYLq3AyXV/5j+BxEzyPcHRCoa3xq5hW/tPFxAIEsW5aH+QcyB9COj6QSHqq2M6F+rmI3fK9sQYO7Ax1Zk68Wk10m3BPpg6/69lx+ICvXJE5tdEI0zN0dm/x1Ah9d9AVbuMCykqoefOk6ZRZlulcB3OGPaGR+iOOl4DSwqsplqkxeXE4KjgoJzCNayC7EmuXnaBm3A/JEe9qeDfOg+o9aYTEdS6qQHqEiw7oLkjtbqqaep/Tc91e7dW5Brl6Xn7cz9RFXWzsHbHeEkCQMypr
 bnssA9Yk
 1IM3M14kQGKpJ7ulrjy/RyyvXBSWQyVgc4uSRWJByERg+7xXU+3Qpsr4qkUu+5Z146aysnfH/zmbFZZiZe/jBwl80LjDUCuuU/hOgtW75PCjeH9uj6CSBLFhd48IWr3HGfPOEbw6T7BGUbM1P1I6bYNXQ84CX/blhFCaFZtPG1boByHa61U44ewAYtjPDAxvWM5KaXw+F2Qyc6n9yzfc7aqjY34UcajRsGLK5nS5Y4yfLrv4601BuED8UevEuSX60TAw/pK1F8BaNelq/ydeGZT9n3/Tp9xl0hIGXxSIM0n7HPtJRslc9BlrWLp942qXIYDzm1Tz6GusA5jSkk2UoHlnqsCFUXGrVwgqF54JPRGZysYgZk9tGFFlDsYFDcJWwI0GflrHxrNkzdqTahqMH19OmpOGbqoTAAlLljQixAueFX5lNOFum5y3F8r0XkDK3opJIPH83PrGjO6PBdY3MRKiSpW+H1fSE67Z9aGAPOLayx3Ibz7bqdsznmUqZHfWNohNEaWZIv5qmzv1eAaTT7zX0ZNX8zlRRHWkoe5dwNn52bNikDOwdoI186YN1sa37+Srf55hcm0NBm7r/rmYSuJh+Q4Plplfx6b6rAai7ZMahim19NiGdpDqy5Orx9rmAcTuj9GZ+kCq83yRzYAY/Wmq+h7eMYFn+51Xf904pJkUlD91o8n20daGl9cfsYcklmOOVIoTtaodXfQA9N8bzHLT+Dd/gfzldIWVxhmHnZj9X/vUtIOT7BDwMZJlhiglQhjfw2sJcGSpfvVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 03:46:30PM -0700, Alexei Starovoitov wrote:
> On Thu Apr 16, 2026 at 2:10 AM PDT, Harry Yoo (Oracle) wrote:
> >  struct kfree_rcu_cpu {
> > +	// Objects queued on a lockless linked list, used to free objects
> > +	// in unknown contexts when trylock fails.
> > +	struct llist_head defer_head;
> > +
> > +	struct irq_work defer_free;
> > +	struct irq_work sched_delayed_monitor;
> > +	struct irq_work run_page_cache_worker;
> > +
> >  	// Objects queued on a linked list
> >  	struct rcu_ptr *head;
> >  	unsigned long head_gp_snap;
> > @@ -1333,12 +1341,99 @@ struct kfree_rcu_cpu {
> >  	struct llist_head bkvcache;
> >  	int nr_bkv_objs;
> >  };
> > +
> > +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
> > +static void sched_delayed_monitor_irq_work_fn(struct irq_work *work);
> > +static void run_page_cache_worker_irq_work_fn(struct irq_work *work);
> > +
> > +static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> > +	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
> > +	.defer_head = LLIST_HEAD_INIT(defer_head),
> > +	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
> > +	.sched_delayed_monitor =
> > +		IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
> > +	.run_page_cache_worker =
> > +		IRQ_WORK_INIT_LAZY(run_page_cache_worker_irq_work_fn),
> > +};
> 
> I think kfree_rcu_cpu doesn't need to be per-cpu.
> It can be global llist with single irq_work for them all.

I would be quite nervous about that, but you might well be right, given
that this is a trylock-acquisition failure path.  Give or take people
and/or machines analyzing the code for potential denial-of-service
attacks.  :-/

> Not sure about sched_delayed_monitor/run_page_cache_worker.
> Do they have to be per-cpu ? Can all 3 share single irq_work?

On the other hand, if all CPUs are doing kfree_rcu() in even a semi-tight
loop, having them all unconditionally use global state is not going to
make for a fun time on large systems.  And there already are situations
where user code can make all CPUs to call_rcu() in a semi-tight loop,
so even if that is not yet the case for kfree_rcu(), past experience
indicates that it soon will be.

And noted on the desirability of call_rcu_nolock(), apologies for being
slow.

							Thanx, Paul

