Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDF9C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7189E6B008A; Wed,  9 Sep 2026 17:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2836B008C; Wed,  9 Sep 2026 17:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56AA76B0092; Wed,  9 Sep 2026 17:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 270EB6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:46:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBFE716037F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:46:57 +0000 (UTC)
X-FDA: 85195559274.08.FBF1FEA
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id E60A118000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:46:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Bfg77qhx;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788990416;
	b=pOOdWEP2WqT8EOEspCvqmDyLamTozFXE1YtB8BAx1Ws/ppdgE24bKv70CXw6zx9hF0bSvd
	NipmOMXBmNL5jlRUGTk+zPGAGh7Zz0vqSFncBFgE4WK3bItYz5ZdvsvrHphHQxbnirNCxR
	gs527I+qaB9bvgsfA1zQeaiFAczlHd0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=Bfg77qhx;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6WNUc7+ccLtCGhgxedehU0mIM9y5RDc0/iE/jkmqtI=;
	b=TLp1+ik0u3ChE8PuXog3JB3qHCL2ZMcjZQYDLLvTi+mSucDrc5a7v7ZNE0TJV3m9nneGvL
	nEmmhGMEKs/SbtlSPonJ/1OH9w4F9e674tDpft/fafardxVBML/e9rNzPvAiT+rugF304I
	vaJeRPTIRhhnRslr2WTQb8mwEruF5FE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f6WNUc7+ccLtCGhgxedehU0mIM9y5RDc0/iE/jkmqtI=; b=Bfg77qhxtGC5hNL12v7G11D26v
	PcgN347bttFKmlJs3saw2LMy5Dm9HZ05mQKT4Vs6Ewcvz/Ja6XyCuqW7bnmza0oHiIiUquT49JFek
	UNZgChWp72DD5/QTWqEPXZg4k5HYipU+4t6dPPCfT61eCUjWZFeXAz8nBGnuzKRKqxgV9bq8rKVnl
	SYZnDvMQXYlvoeSqpnTB9MCP5IJX1mfyOWWn64+h0dEMVcs2OUCEUS2ozbF65MZw5fMy4NWQPCTds
	VIBdAjzRtxCqZHgpDwoJARhg2Nwetd3qJ2h0mCP5IVnKGjlksK8muVBthSusdvJBPwpXSeWHmYSof
	c3f14PAA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x4Q7n-00000001iSG-37xT;
	Wed, 09 Sep 2026 21:46:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2D25F300A9A; Wed, 09 Sep 2026 23:46:33 +0200 (CEST)
Date: Wed, 9 Sep 2026 23:46:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, oleg@redhat.com,
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org,
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, tony.luck@intel.com,
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <20260909214633.GN776954@noisy.programming.kicks-ass.net>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <20260908074228.GW4120091@noisy.programming.kicks-ass.net>
 <20260909120911.39032d13@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909120911.39032d13@gandalf.local.home>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E60A118000B
X-Stat-Signature: ob4ozp7omsatz7juumrq833qdbjfutut
X-HE-Tag: 1788990414-339968
X-HE-Meta: U2FsdGVkX18TVdX4FQABjDxmX5zlDy6s70VDxyaeRPalw7mdCdXRO4pemmc2GhYkzUgdQokE4WuNv5ou2ZA8P3t5hQ/MSTawht4j3U/BtypM0U9caJFfKYGLp5cHidGs3MYEKnybjnEehawt3LspFsxwzuxhpwpuRrV2EbmEZ7XgtuZIVkI+JPeahsy+7W9adAC5H/YjDnCt2N7rPeD2ix5eb+2mYcmUb/F2X5rZDSNEXxYkD6pnC8UwnEOCchDHxj8hpYtXlNuXp5JPdik/gkvfm8VPROidtG3zDWlz8y0ba28BYa+jbJpFVR7+ofR2wuZEixjUJBV9fSW+1h8UD7QVHKvfLayc+aNQ6aPd+lh75ky92UBiLrQc1689+T5Cm7vhipGp4vHIh6xs1iKMJwAsYpHk9Mkw1WqgBFiqP7Av6Wqn40IUwg9c7Jo3BtXgARhuvuWGDzfXoDm//H7+7nUWl1+5KW8/R0TOlMfadq0sBVWqa8MmiNUJE7hAX+JlxWHAN8S4Nn4rTkDdIp77mU1eE2xLY72naLGHndIBU2bXOagwT1s+gW6+7N1NKl0YyzjV0e8I+C/2JcIfyih0pXM3YznOmnNNa4UAHWIRAzxsDOGvQqolbvrslQl1pVmlj/BpvVTIZuInSh9Mr8NQpCDXTcUIETYSgfQebH2jl+tRxMCTqETeBmgs/4ExJUByB3XrP1+bCoRBWG0cn5MsALZxsQobMz7x2uQT77oyCENETzgC5c7/ULGjmM1YD4c6B0a79AphBup+zXW7vD1opxZGuknVmLmVxw+Ai/TknTu/CWub6mTdrVva7j6n4egD2BMpDARnx1PLn/tb0ULSBFRlVii9PgcVa4WDODiQJLitN3pNIpjg5A1SLjzordTS/BIsNMeFyrEbHp8FYeiEb3bJtbIEqPzLa2GrDsVMAdkRI/ap1SHZhNFKSpqWnPTvwzbo9aADR1jrS5HBFgr
 O6+48b8D
 ScNOgwcXezHRtR+CUCTKEa3TbeMDQ7jzOAujbmGFyVjRWlgFckkG5gksPuebBoMJ0sP3u2rIyLuKGTlVOYbm7yX9abhWUQZHPpAJJuTvtXcDey/vtGxDUVO8x1HKAy4aDRuCpvu5SV24L7P7sQ5uZRF9fdGZ7CFkFgu8YDfMkKiD8ITKm/FepSOCsXZ9FBbnzRbhMX9tntAp6pVFlvbgM/mF1nWM+I/cfyRVY4+gkKm3WvGM/xkROHfX/S/my1kBK/QZVUr2dKfZg5QCvOObWXahnMRvHBCDEvLP6G2gTCv2IYAmP8r/nD/Kq6cBsOpKyoCj1RYo8/+XTIgopsUojX8QEHPDWw6B6RcFedfxAo2p72yj4YpH8LCxtHG+SVxLeahAmNDh43tRcZN3PqYG68bGtbju7jJb1G16u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 12:09:11PM -0400, Steven Rostedt wrote:
> On Tue, 8 Sep 2026 09:42:28 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > >  kernel/cpu.c             |  4 +---
> > >  kernel/freezer.c         |  4 +---
> > >  kernel/hung_task.c       | 11 ++++-------
> > >  kernel/locking/lockdep.c |  4 +---
> > >  kernel/rcu/update.c      |  4 +---
> > >  kernel/sched/core.c      |  3 +--
> > >  kernel/sched/debug.c     |  4 +---
> > >  kernel/trace/fgraph.c    |  8 ++------
> > >  kernel/unwind/deferred.c |  3 +--
> > >  9 files changed, 13 insertions(+), 32 deletions(-)  
> > 
> > This is not something that can be applied.
> 
> I believe you mean to break it up into individual subsystems. kernel/ is
> not its own subsystem, it contains many different ones.

Just so.

