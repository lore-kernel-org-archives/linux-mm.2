Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0161DF94CBB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C19D6B0088; Tue, 21 Apr 2026 23:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A106B0089; Tue, 21 Apr 2026 23:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF046B008A; Tue, 21 Apr 2026 23:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB05E6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:02:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99F65C517D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:02:08 +0000 (UTC)
X-FDA: 84684692736.06.B951455
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15B9810000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:02:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cLiP4ZEn;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776826927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uViov+sTrnceF5eDz9yvlMB8S2cP2phH+ea+oiFqAKM=;
	b=JWyVdn4pYu8yIDX77kFmlMC6JbHh+xBazVDkGPblSLFhZs6c5VNV1g28llFCabR2aSM95Z
	/jNW/aCtp3zdqI8d2kUV4fg0JO2/qyKrpisSg//lxFEGlqCoTFPap0AEkOeybAxezN4oPf
	1YAJPDxI2TNLpCqZGIMZqs6IaoEnpZ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cLiP4ZEn;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776826927; a=rsa-sha256;
	cv=none;
	b=itmTmLdgPNGjGD44jibEn7ki+XQA/PWg6vgHU5GjWKq0A7QS1haH2P58O2J6ad1WA/DEJ2
	PROhnep4iEU9ADfFs3/ZsZh87ojocO1wDBeqiXH7wiYmA9MpnUTspIFBWrfjgvvaNV6Obm
	F5Go2kUpwR8qtAjYgHHmAYdWxjjTCK8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D67160018;
	Wed, 22 Apr 2026 03:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D429C2BCB0;
	Wed, 22 Apr 2026 03:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776826925;
	bh=sd4O6bp9bJ6/CkpIBKSx3gBRzusegphBjTuUq0STAQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cLiP4ZEnUe7HRV+QaodZGpD/1YTHkLAj6H+vbGJmFwrXaauLuOTvX+QWd2+TVDbwa
	 thHLX39Cp6IDLUfKSUcZ0sSc4Eh0jO1Lj0eZxLMrbmWHJmlBZhWfKuvjBVt2h58UvC
	 ifBU+FUGg21SKDQuWb4vYCi/P57VJJ9WR0fpYpceU3c7sOIKGhCMnhYMOKN+mw9cVV
	 KfIgaXMe8wWlgDouuSa2ObFEI9PUIzcDZ7AVsKWIay9j7ZS46EwqWZHRsf7YSWlNds
	 5QKGBxwFERxA/UqXIU6Hj24S4uSOnxEteFHvygjp2HfivQp2Ei0+u8Edc2aCX84GtS
	 uVPWJnPV+IwsA==
Date: Wed, 22 Apr 2026 12:02:03 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <aeg6K-NcvFHZ02bk@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <DHZ7543VMYIQ.1US6BY7G0AUJK@gmail.com>
 <805c33d7-3a7b-470c-bd9d-065717a3e3e2@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805c33d7-3a7b-470c-bd9d-065717a3e3e2@paulmck-laptop>
X-Stat-Signature: wh888drq8bipadru7wsswox3k695czt9
X-Rspamd-Queue-Id: 15B9810000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776826926-72470
X-HE-Meta: U2FsdGVkX18sclwotH3hBYTuR5TSDsJ68+4xQmne7FSiXvkytgP6/J1uaxTNWsdPHVFpLbhgw+Jlwk2FvHNIYfzKqJ0VnDhT5VEDwUahNeAWQfEYbORlIA3p7qBmlfFajMkm5hEvGS+6wHABd4atMx9x3r0dKUPkRGNyuFoT3meuR0tLqyV76BMYzJMkNi5atO6CrXZ+vSzbltvS+Tm9TUbwejBKzx7qlKOwd8Pl7ZUTM6Fzex3mO8sWAx+l4lgRMcm1otZGFABl3UPStqNypxm7kM/L7ZRKWgMJjtpawsZiJf6K8wd8o/piPZlvjKiykn9XnVyGtXJltC+ILRJ6+r8hx3nSmdeC77YeAtnmjmcxqIDtmYi8CPm3vEQi75c6M3uxS4IisMS648GsqVsjb9CzN4WrwPKOWOdJsdBztVX6g63Z/CSFEBXfwtbA1qqBFHKnv3pRWNRZMbCymG0Cu6NB1pvxqe1zdAKaajAINMdzERQ88R7xfy00mkzgZrb9wSb52rVX2CWAb0ShVSg/ju0nkqm0Zv6nHEewScGKkULHAjfn/fsn7ZKSYwHU0LFyeK6yE/SHUbNN4OTcM9ecg6S6TLB1m1VVrKfqMC6G4tWw+RzCv4gVR3KUchflu0xZ3VXM+VPtRXjCiqmdSQejehzjGseJetdTaXA142/Bx47jCaKT1XHspmyKdRe5hMqrG4v0pelAnCmlRd1VcnIM8jBbWp3UD8UUg9SFbZZh42GJtu367+iaul0yrTDHl5g0c1r02cOLfHL9YyZnM6RtVwnpuyKGv92X5wvvZHgwPEXhPnlmCHQolFVawr2Cdzy/RPIYIlyNsoeZ0pFbMg1xNZqYqJwhO90VYPApxqf2gFjFy6i9+IVFTf8NQ1vC/lT1S0GnDgil77V8jtRjcERmN6HhnnEcbEj50QYAN7ElJFlDPUU9nOPN8Sv7pfuhWvVWPMWZqMdR3iSNHQ9qKM0
 CNp4PbRT
 l6wxbIA1XiuF1TVLeDMQoiseJ95YIjY1mJ/HAVBF68tSQFWzqxW3TEZEEbIk3HYG2xLrtBvRXLHOwOZLpC8VCHFkFLldhqLxFLXjqmPbEQlC8qN8H5pZiLHi6Z8E9ySBCZWpyq9FltOZezYB0HQi71lo3CAj5ZDvu2H76gEV2knCt2BHGKR6VKp3APTdkzsKPlsEJkLzIHiWD26ZlX/scW+TaleIJgVxBLhPmel1UEMZqtT8mgMCTmwwWwJ89gaD2tLnGO0h9iSORSLKchLUNCLiojmk5RDdSsoT2jnHgl/QMLobS3sXJiXINCU363xANSGi9h84aDi3ngYFvrnNtqtR3/k9qiH7VqZah334MLfAJ/ubIYo1FABVCPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 04:10:41PM -0700, Paul E. McKenney wrote:
> On Tue, Apr 21, 2026 at 03:46:30PM -0700, Alexei Starovoitov wrote:
> > On Thu Apr 16, 2026 at 2:10 AM PDT, Harry Yoo (Oracle) wrote:
> > >  struct kfree_rcu_cpu {
> > > +	// Objects queued on a lockless linked list, used to free objects
> > > +	// in unknown contexts when trylock fails.
> > > +	struct llist_head defer_head;
> > > +
> > > +	struct irq_work defer_free;
> > > +	struct irq_work sched_delayed_monitor;
> > > +	struct irq_work run_page_cache_worker;
> > > +
> > >  	// Objects queued on a linked list
> > >  	struct rcu_ptr *head;
> > >  	unsigned long head_gp_snap;
> > > @@ -1333,12 +1341,99 @@ struct kfree_rcu_cpu {
> > >  	struct llist_head bkvcache;
> > >  	int nr_bkv_objs;
> > >  };
> > > +
> > > +static void defer_kfree_rcu_irq_work_fn(struct irq_work *work);
> > > +static void sched_delayed_monitor_irq_work_fn(struct irq_work *work);
> > > +static void run_page_cache_worker_irq_work_fn(struct irq_work *work);
> > > +
> > > +static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> > > +	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
> > > +	.defer_head = LLIST_HEAD_INIT(defer_head),
> > > +	.defer_free = IRQ_WORK_INIT(defer_kfree_rcu_irq_work_fn),
> > > +	.sched_delayed_monitor =
> > > +		IRQ_WORK_INIT_LAZY(sched_delayed_monitor_irq_work_fn),
> > > +	.run_page_cache_worker =
> > > +		IRQ_WORK_INIT_LAZY(run_page_cache_worker_irq_work_fn),
> > > +};
> > 
> > I think kfree_rcu_cpu doesn't need to be per-cpu.

After reading this, I was like "Oh, that's quite a drastic change?",
but looks like I misread it. I didn't create a new percpu structure,
but extended the existing one.

I guess you meant the new fields added (defer_head, and irq works)
to struct kfree_rcu_cpu, not the whole structure.

> > It can be global llist with single irq_work for them all.

It could be, but what is the benefit of separating them from
existing kfree_rcu_cpu and making them global?

> I would be quite nervous about that, but you might well be right, given
> that this is a trylock-acquisition failure path.  Give or take people
> and/or machines analyzing the code for potential denial-of-service
> attacks.  :-/

It'll probably not that bad because it's trylock-acquisiion failure path
of per-cpu lock; IIRC during my test, falling back to defer_free
happened only a few times (< 10) when the kunit test is calling
kfree_rcu() in a tight loop (100k calls) while concurrently invoking
kfree_rcu_nolock() ~10k times on the same CPU.

> > Not sure about sched_delayed_monitor/run_page_cache_worker.
> > Do they have to be per-cpu ?

Since existing sched_delayed_monitor/run_page_cache_worker works are
per-cpu, I think it's better to keep those irq_works per-cpu as well.

> > Can all 3 share single irq_work?

I thought defer_free and defer_call_rcu should be non-lazy irq work
and others should be lazy irq work. And I was thinking of having
one lazy and one non-lazy IRQ work (two instead of four).

But given that sched_delayed_monitor and run_page_cache_worker should
not triggered that frequently anyway, it'll probably be okay for all of
them to share a single non-lazy IRQ work.

> On the other hand, if all CPUs are doing kfree_rcu() in even a semi-tight
> loop, having them all unconditionally use global state is not going to
> make for a fun time on large systems.  And there already are situations
> where user code can make all CPUs to call_rcu() in a semi-tight loop,
> so even if that is not yet the case for kfree_rcu(), past experience
> indicates that it soon will be.

A tight loop for kfree_rcu() should be fine.

I think the question is "Can a malicious user can make all CPUs to
kfree_rcu() in a tight loop AND concurrently trigger kfree_rcu_nolock()
on those CPUs, so that trylock will mostly fail"

> And noted on the desirability of call_rcu_nolock(), apologies for being
> slow.

No problem. Really appreciate looking into it, Alexei and Paul!

-- 
Cheers,
Harry / Hyeonggon

