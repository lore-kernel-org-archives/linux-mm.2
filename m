Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA19FC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1136B0088; Wed, 16 Sep 2026 08:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789DD6B008C; Wed, 16 Sep 2026 08:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7346B0092; Wed, 16 Sep 2026 08:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDD36B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:31:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6106E1A06CB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:31:01 +0000 (UTC)
X-FDA: 85219559922.26.1330CD4
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id B826D2000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:30:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=e3922R9P;
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789561859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CZTXTXBpkYDLkHM3H81KdkEWF4+imO91qZpPhQs9rg=;
	b=Q9jawZeWVBLTm96DrwADjWIZWj4yHaio9n+/0UBpJSyUtVBvhmy18BUyGlO4skDf/CT0kr
	BQP7Np4ZJ+XNkhAmJRFgI7FHtsJr3xai/JExfRttA5WyoYrnvvA0/893ucbdhNfHrwpEyn
	qUf834sgk1K2hoaUhPq7c2DD0omk+3s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=e3922R9P;
	spf=pass (imf13.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789561859;
	b=tJq6CxTpU8EvdLcn54VlvldmCh8Jo+Vex19IwP1bIC6Hidp4rqOIcXcwE/ibSIub3Rum5F
	cu0Vxhww44bJIL31YZE2o+5maJAOgYeVcSUbcn5RFw7Rb92qsV6y4w/h5lzVBbLtrhPkgh
	0DRRJ9Qw40nWTlkX5uSO82r0KwMSX/w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+CZTXTXBpkYDLkHM3H81KdkEWF4+imO91qZpPhQs9rg=; b=e3922R9Pa3dJE7oen76mKNw5N9
	VvvvvkZYZHayIVSaAf2fw5Y85QIsPxqoxncNxhYKbbYc/gBmOrkfvy94nCoOB3K07i9LOTw4imPzu
	GQharzpSZp8Z+zqgJcb0faYKZRQwYFUEoqS/8F89QlYzkIzciXbP1wI2X8VPmISOKl1lMN11dNi/c
	bxFi4JcEU03WNANXH6GLhcuY0tQLqM9P4HrIZuEh9kE99hGKVfBHX8qcXC93g2ArUQ2CiszmqYYqw
	a6XWwn6v/9F0F3Ggw4SKBTheZzdKObS5mCEEBg7Ia3vSVpAozwjCPPfnYDtBG0xqtGTXZRyQGubsh
	2oIcEM2A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x6omm-00000007qXL-1y4b;
	Wed, 16 Sep 2026 12:30:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CB3503012C6; Wed, 16 Sep 2026 14:30:46 +0200 (CEST)
Date: Wed, 16 Sep 2026 14:30:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>, Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
Message-ID: <20260916123046.GE776954@noisy.programming.kicks-ass.net>
References: <cover.1789061845.git.tim.c.chen@linux.intel.com>
 <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82736e1329bf8ed195bbbc4990486c87094e6789.1789061845.git.tim.c.chen@linux.intel.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B826D2000A
X-Stat-Signature: 7hzu9y45dbdwr9naigrn1ghgwgggwbpy
X-Rspam-User: 
X-HE-Tag: 1789561858-719012
X-HE-Meta: U2FsdGVkX18SEpincax1l45zgiaCKuVrtWAN//DyQD6W3Eoa1U8+41s++t3Wrl2zRa5N9NQjAdGadMIa6TKW0BCAJfEBKgkWQUrqNrT7xGp2hj3Te0f3BiYOQs4jrk+dS0S7pUyqubOq1lnWQl3XDpi+F3DIkgmZDl8cFHpaRPjHob3T1x55O2UQf4pQuGO6p8E1Jv/7lYU9gHBQkykzVcQLZ/5tGC76p2HuoUEVddhwX9e6e3awImVlSVLXpdxwh0mTBuX1x9Y7glzt+v0wgMLLFiq4vVDi2x2NwAeXxh4H0O4t9b4rstuWCMKu+kj1BanAOihPng/4yFuV7afPaIVfpcIT0RNgY/rTOpdEjXJBtABTChj+HnK3UwxkCO5DP0tlPC7veq2Zwdq0r+OmT42vcDfMB9EHGei303802ISilTU2VpC9qEqwYOuoN445+fPvd2aCl91vSp7soptIGf8V2WKvb+yXk37tuKGoBJSGRPk+aXQ1k66gaLpKohVqwk6H1kMV7o+Ar0kH/hGtyZ+P86Bd4TeAWpY9OSGANFQsnrFs/kFWqKm7tXPHBCaSMdMxV9FfumWBe/x6ACQ2PrMRcLATv1wCeqwafIFw3++VpdXcxOpMJhpSt+cDALrDAkdmHGD2rlBlUSfuazADrRD6jr/vETotVHZGbsSTSTCB4uHtfPc9QKLgNGpytaXrYHZXr+bEh70V4Tsx39LcNkA7xAwsUijA4Bd0DXbu2EINcM0fWAtyG0aFszHAqwS+VY/hzQ7kL/UGILKTBWQlvKfEb+MYdEs7nrWT1jiOgavtH6GYU1R3DzAiMDTfTDCDYRz6aUaTE1zuQ5h+tNNYrRZ9GRcouUf5+CoI9lqesjPCd6pQWFHwzWUZQZXbMCtPH1J6DbqTPKEvYdrXV5tDusLs9dF9zeEj/RfkDfSBNWlQQJEo+S7GKMLPRSWRuBa9cGaMgNk6sNfBn+9Ye1l
 cgZRTI7Z
 MXR2XL68m5V61NyLj8uDbRWRO8vmLm6gV2Gr+YeefPnXv3pEtfK6PKOSCVAw3vUh1L5yE0NHYDxgThthQQDcrQJClkBiAZUzevARjQuUOuyibnYM7+5oDgK2Y8AAXRCAY7KfczpJTY3ldTZavAbTVW1eQ9JcF18RTodNT7NM+vMtz2VewTK6xgH04viTdXQ5wm/KJ9Dpronmr+yMkB5hn9o/kT0bTm3q2ESa/dH8CYDPn9Zo+NfJ+5dOOZWVjbeaEKDHCVk1lTrOlvLyPde4FKnISVYJWeqqrvztWh5juVNfYQiBV01TnDl9jqpYyJuIG1+9WABbS+v3PLQj1jH2+m1U3R3qkkpj5xzE887RvBG84l24CmKYW91WFTRhK3CUpcsBkmopB3YDAlVCGlKTiqEONVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 10:46:09AM -0700, Tim Chen wrote:
> alb_break_llc() decides whether to break LLC preference during active
> load balance. It does so by testing that every runnable fair task on the
> source rq prefers its LLC:
> 
> 	env->src_rq->nr_pref_llc_running == env->src_rq->cfs.h_nr_runnable
> 
> But the two counters cover different sets. nr_pref_llc_running is updated
> in account_llc_enqueue()/account_llc_dequeue(), next to cfs_rq->nr_queued,
> so it follows queued tasks. h_nr_runnable is updated in set_delayed()/
> clear_delayed() and drops delay-dequeued tasks.
> 
> So under DELAY_DEQUEUE, a preferring task that goes to sleep stays counted
> in nr_pref_llc_running while h_nr_runnable falls. The equality then breaks,
> alb_break_llc() returns false, and active balance is free to pull a task
> off its preferred LLC. Active balance only moves runnable tasks, and this
> is the only LLC check it consults: once the stopper runs, LBF_ACTIVE_LB
> skips the per-task test in can_migrate_task(). The runnable set is the one
> we want.
> 
> Fix it on the counter side. A task should be counted in
> nr_pref_llc_running exactly while it is both queued on its preferred LLC
> (pref_llc_queued) and runnable (!sched_delayed). Define that membership
> once in task_pref_llc_runnable(), and adjust the counter only through
> pref_llc_running_inc()/pref_llc_running_dec() from the four sites that
> change either input: account_llc_enqueue(), account_llc_dequeue(),
> set_delayed() and clear_delayed(). Gating every update on the same
> predicate keeps the delay, wake and dequeue paths from double-counting
> or underflowing; see the comments at those sites for the ordering.
> 
> nr_llc_running and sd->llc_counts are not touched and stay on queued
> semantics.

Needs a fixes tag.

> Reported-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Closes: https://lore.kernel.org/lkml/20260827135000.735138-1-zhanxusheng@xiaomi.com/
> Suggested-by: Chen Yu <yu.c.chen@intel.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---

> @@ -6395,6 +6428,14 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
>  
>  static void set_delayed(struct sched_entity *se)
>  {
> +	/*
> +	 * Drop a task leaving the runnable set. Must run before sched_delayed
> +	 * is set, or task_pref_llc_runnable() would already exclude it;
> +	 * clear_delayed() mirrors this after clearing the flag.
> +	 */
> +	if (entity_is_task(se))
> +		pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
> +
>  	se->sched_delayed = 1;
>  
>  	/*

With flat pick stuff only task can get delayed. Now, I think we merged
the cache aware stuff last cycle, so it we backport this (see that Fixes
thing) then this must stay. But then also please make a note to take out
this condition again later.

