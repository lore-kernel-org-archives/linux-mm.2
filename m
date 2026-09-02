Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58B0C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBB86B0096; Wed,  2 Sep 2026 01:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9DA16B0098; Wed,  2 Sep 2026 01:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C456B0099; Wed,  2 Sep 2026 01:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABBF96B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:08:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EEA2C0717
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:08:49 +0000 (UTC)
X-FDA: 85167642378.24.3DA1F72
Received: from mailgw1.hygon.cn (unknown [101.204.27.37])
	by imf16.hostedemail.com (Postfix) with ESMTP id D8527180002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:08:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf16.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788325727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dKbO5DzKUhouBCeGyArdgjiKn2YtRV2K8pRxip3VtJs=;
	b=R8Q8CXZXshKvis1Qi67gO2pxhPTeUusRLuLKWvl+jdm85deERstnHi8JBgjBq0Yj07l5wp
	D8UKo5m3RGNsPi7m55fB0CvzqtNVdgPBAOp0d/7UIJSKolGMAeTc7zuKdjQmZrxpyiXSCC
	txCrPV0ZWs3AG6GZ9XD3sziDJLX4KqE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=hygon.cn;
	spf=pass (imf16.hostedemail.com: domain of wujianyong@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=wujianyong@hygon.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788325727;
	b=j91qq8XPYzg4GbRWo3t7ewxPXW0I73NoncLWPP4J3rBDghRwUFMd/JlQY3tXD+UN9Zb9Lg
	aOJRJdAPP+YBXXim9kCCZ2FvVtsDO/ksi5PU58mmnYB3PMRmFtXOYvfApSWQ+B8DCcIBQd
	dgDcQc65WVH7n6VqAtrENzO5+ZBRwqA=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZW3F1MxSz9Qqm1;
	Wed,  2 Sep 2026 13:08:41 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw1.hygon.cn (Postfix) with ESMTP id 4hZW3D5W52z9Qqm1;
	Wed,  2 Sep 2026 13:08:40 +0800 (CST)
Received: from cncheex05.Hygon.cn (unknown [172.23.18.115])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 3FFCD4B5D;
	Wed,  2 Sep 2026 13:08:34 +0800 (CST)
Received: from cncheex04.Hygon.cn (172.23.18.114) by cncheex05.Hygon.cn
 (172.23.18.115) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 2 Sep
 2026 13:08:40 +0800
Received: from cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d]) by
 cncheex04.Hygon.cn ([fe80::1b6f:6c58:58a4:430d%10]) with mapi id
 15.02.1544.036; Wed, 2 Sep 2026 13:08:40 +0800
From: Jianyong Wu <wujianyong@hygon.cn>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>, Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>, Dietmar Eggemann
	<dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall
	<bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
	<vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, Phil Auld <pauld@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "jianyong.wu@outlook.com"
	<jianyong.wu@outlook.com>, Yuan Zhong <zhongyuan@hygon.cn>, Huangsj
	<huangsj@hygon.cn>, Fengyu Wang <wangfengyu@hygon.cn>, Zhiwei Ying
	<yingzhiwei@hygon.cn>, "justin.he@arm.com" <justin.he@arm.com>
Subject: RE: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
 migration decisions
Thread-Topic: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
 migration decisions
Thread-Index: AQHdNiBFF6wQCkMonke4aXPvTe8F7La48JyAgAGW6TA=
Date: Wed, 2 Sep 2026 05:08:40 +0000
Message-ID: <226d79fa93a84193aa2507113747d348@hygon.cn>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-12-wujianyong@hygon.cn>
 <20260901090843.GQ4120091@noisy.programming.kicks-ass.net>
In-Reply-To: <20260901090843.GQ4120091@noisy.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.20.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9uedinbqbfe9i5q8egwpun96g4hwrqpx
X-Rspamd-Queue-Id: D8527180002
X-HE-Tag: 1788325725-690989
X-HE-Meta: U2FsdGVkX18strQ978e2+mUP5+T6FdCVorzx/nFCT8/NrjTDf1S+1v66MdmBZLT4TLq9/nVUl3oVVa45g2eq3DIUAExNiHOu3j8O/rZrfUKz6CXgzRxgBuBmme1H87Kjs9Qbzh4rhvDyGUKXtXiSX4RKyZPM1V6aEk2kA8SbMvhQH/7nSrYLXJrA8i1FWyDP4qP3qjXL+6GaoGVf5feqlW78acsA8iUaXXD5o1nL468LUsl0zLD4WrnhS08SLqBxryDUP3xZlFZo6Fmp7g/ywQnKg8hNp6Q+oEFhnBGYc/9sX/RTo99UUkHsUOOhoYYZ+Kd4mhsKTJ0yJP5rJlxqFJmiXaCulNAVxXJzlFfgCpABZlpAULnFMQKticLWSzg4GHHlVnpKlMOXQRK45FKwJmrZBqa2i2jUU8RsjM1eWE8+lw90DCybrfb4eJuRGYv3dYW8Sa1BCuqU17fBod/D14w7sKNtONeHnyiZEJ9JIloiY7cbLtJEa7nlknCbq0LFtCfUttlzSBmqm85bcE45nhCbrsBa78ahdpJNbZnstcZ+53Y4wJb7399y8+qBy2FcY7tNUCPAk893l8fXwaa+lEVwgNGUyaVGfA+50uAIlfFr6D7pocaPsvDC1vnWcoVfacFL1GkCr4hxJgUqBgEZY9v/j2WLytCcBexJMmco4SQpqR5K5WZAgV8s6/PE/dQBeL15CmGZPhjjMz8kNxDCHUxmx9MneUGqPQQqAbzbYxuJzmF0+Whqo1udtLanUpn4q89uiowjhivCmh9ZN+4dFVScvSdrXiM6QYozkHAlpWHXELNn7it0YPx32uo5Tr3XbpkEED9YBDJJOF3O+B6C9rVn5EHJ1N6WCdXJe4DXMEI1hrTDpRU77iasxw4tuFNdU9xBp/2sfqd37EsBsS0YVRVJ1rztG5WSuQHkyeC+mmhPwITVllPNMHAn0jfe/M7mQxYlV7UZ6mSVAxSS6mH
 +DilojVD
 q0qovY/YZ2w1HYDtQSTs6ndWorRJdGkGRZb0ICmGqrUYnzA9GGK5xFL+3BEhgRI0tab+CU9Lgq4/q0AbTZMbVYr7JXsUJ6Xk/SSeWL0ofBD7APoGE56VesW5olJ5cQ3Td1WUOaz3sM3YwrtGizvgkoOcIdoMPh6vnE/PExFyweBgHEqhjeFfyuUe8Veh0p4udpKzFlTABqIlDbPivqdxmH2XHi36IN9FH+MaQvNR91cHb5LUiB2zBxhrSyiV98sXcjHXvHPcKcbPfsrIPE3J43DltCSbLcqyVsCfsWszaHVLpPVqJJhXFK88OZuQhSCl6Znh4a4iXJMsP9XG7c4Vn5fgRvXnZj1XoueI/VAeGR6qY6X4GKuM+xchoQs7E6aYVRYOEZrWK/CZqyqRYhtJi6V+Fgp1v7Tcyhwzx1jaMuGHeEqE8fUuHd/ADhNnUvK0yAzDWMJhRLmdQI1tH+no0bTyk31a2V7C6j+cr4/zl/p+wxgdpMWRcIlbo3+NRUjZ94gmmkP6Dv2FYTH/Cc/n+qUBYzmmQtSeMy4MKDK0DsJWTE+c+4aZVC4u7/ErhKv22FT+wwCMAnb6ggpbzIt8YLihK34cDiq9eoitVPiIA+kTLuV+n7Pgb4Y77LtOy6L1XrD8XNI95hNspLGYg0JkOwkOTrXCD9R62eYz8GK+pZU0Hp8ADmYSNSfn+M2dUQ1UiX73SUhZOIanTtRh4rg/J1mspLEzKr8eRSN1FAbGZ+S9rwnLoHp6wKBE5GKQSpHaDVRLq0QXfIOYdTpuE4Et+FePmTECM7vA1SCX+DvU3tzWI8w6dzix/nUZdzrbD9t88b1BT/drEuEgzgwH5N9mZxEHPcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

> -----Original Message-----
> From: Peter Zijlstra <peterz@infradead.org>
> Sent: Tuesday, September 1, 2026 5:09 PM
> To: Jianyong Wu <wujianyong@hygon.cn>
> Cc: Ingo Molnar <mingo@redhat.com>; Juri Lelli <juri.lelli@redhat.com>;
> Vincent Guittot <vincent.guittot@linaro.org>; Chen Yu
> <yu.c.chen@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Dietmar
> Eggemann <dietmar.eggemann@arm.com>; Steven Rostedt
> <rostedt@goodmis.org>; Ben Segall <bsegall@google.com>; Mel Gorman
> <mgorman@suse.de>; Valentin Schneider <vschneid@redhat.com>; K
> Prateek Nayak <kprateek.nayak@amd.com>; Shrikanth Hegde
> <sshegde@linux.ibm.com>; Phil Auld <pauld@redhat.com>; Andrew
> Morton <akpm@linux-foundation.org>; David Hildenbrand
> <david@kernel.org>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> jianyong.wu@outlook.com; Yuan Zhong <zhongyuan@hygon.cn>; Huangsj
> <huangsj@hygon.cn>; Fengyu Wang <wangfengyu@hygon.cn>; Zhiwei Ying
> <yingzhiwei@hygon.cn>; justin.he@arm.com
> Subject: Re: [RFC PATCH v2 11/23] sched/cache: Introduce helpers for task
> migration decisions
>=20
> On Thu, Aug 27, 2026 at 08:28:04PM +0800, Jianyong Wu wrote:
>=20
> > +/*
> > + * Decide if migration should happen on a specific node.
> > + * The node here is an LLC or a NUMA.
> > + */
> > +static enum llc_mig __maybe_unused can_migrate_node(int src_cpu, int
> dst_cpu,
> > +			struct task_struct *p, bool to_pref)
> > +{
> > +	const struct cpumask *span;
> > +	struct mm_struct *mm;
> > +	unsigned long dst_util, dst_cap, tsk_util =3D 0;
> > +	unsigned long src_util =3D 0, src_cap =3D 0;
> > +	unsigned long acc_util =3D 0, acc_cap =3D 0;
> > +	int node, target_cpu =3D src_cpu;
> > +	int get_src =3D 0;
> > +
> > +	if (!get_llc_stats(dst_cpu, &dst_util, &dst_cap))
> > +		return mig_unrestricted;
> > +
> > +	if (!get_llc_stats(src_cpu, &src_util, &src_cap))
> > +		src_cap =3D 0;
>=20
> Comparing against can_migrate_llc(), that bails with mig_unrestricted
> when !get_llc_stats(src_cpu).
>=20
Agreed.

> > +
> > +	if (p) {
> > +		mm =3D p->mm;
> > +		if (mm) {
> > +			if (mm->sc_stat.cpu >=3D 0)
> > +				target_cpu =3D mm->sc_stat.cpu;
> > +		}
> > +		tsk_util =3D task_util(p);
> > +	}
>=20
> It isn't clear when !p would be valid. migration is always about a task,
> no?
>
This helper is also called by llc_balance which will pass NULL task. So, !p
is valid here, same as can_migrate_llc(). In that case tsk_util is 0 and th=
e
decision is made via the to_pref path.
=20
> > +
> > +	dst_util =3D dst_util + tsk_util;
>=20
> can_migrate_llc() also adjusts src_util by subtracting tsk_util (and
> flooring at 0).

Both the pre- and post-migration utilization are needed here. The current i=
mbalance
check uses the utilization before the move, while the capacity and anti-bou=
nce checks
need the utilization after the move.

I'll introduce explicit src_pre/src_post and dst_pre/dst_post values with t=
he source
subtraction floored to zero.

>=20
> > +	if (to_pref) {
> > +		unsigned long dst_pre =3D dst_util - tsk_util;
> > +
> > +		if (fits_llc_capacity(dst_util, dst_cap))
> > +			return mig_llc;
> > +
> > +		/*
> > +		 * The destination is over the margin. That is a reason to
> > +		 * refuse a task while the margin can still be met, but not
> > +		 * while every LLC of the node is over it: no placement
> > +		 * satisfies the margin then, and refusing every migration
> > +		 * leaves the imbalance in place.
> > +		 *
> > +		 * Let the task through when the move still lowers the peak,
> > +		 * that is when the source is noticeably heavier than the
> > +		 * destination and carries at least two more tasks worth of
> > +		 * utilization. The second condition keeps the destination
> > +		 * from becoming the heavier side, which would bounce the
> > +		 * task straight back.
> > +		 */
> > +		if (src_cap && util_greater(src_util, dst_pre) &&
> > +		    src_util >=3D dst_pre + 2 * tsk_util)
> > +			return mig_llc;
> > +
> > +		return mig_forbid;
> > +	}
> > +
> > +	for_each_sched_node(target_cpu, node) {
>=20
> So this iterates the nodes in the order specific to the node that
> contains target_cpu.

Yes, the node including target_cpu decides the affinity node sequence.

>=20
> > +		unsigned long u =3D 0, c =3D 0, nu, nc;
> > +
> > +		/*
> > +		 * The walk starts at the anchor, so the nodes it crosses before
> > +		 * reaching the source say nothing about this migration: the task
> > +		 * does not live there and is not going there. Judging them only
> > +		 * lets an unrelated node with room refuse the move. Start at
> the
> > +		 * node the task actually sits on.
> > +		 */
> > +		if (!get_src) {
> > +			if (!cpumask_test_cpu(src_cpu, cpumask_of_node(node)))
> > +				continue;
> > +			else
>=20
> Strictly speaking this else is superfluous.
>
Yeah, will remove it.
=20
> > +				get_src =3D 1;
> > +		}
>=20
> And then you skip the nodes between target and src, which are the nodes
> with best locality, confusing, but lets read on..
>=20
> (sometimes target =3D=3D src, and you thus don't skip anything, but other
> times this is the preferred cpu)
>

As this is the "!to-prefer" path, dest cpu is not in the sub-sequence from =
the target_llc to src_llc in the affinity node sequence. That's why we skip=
 them here.=20
=20
> > +		if (cpumask_test_cpu(dst_cpu, cpumask_of_node(node))) {
>=20
> For the node that contains dst_cpu..
>=20
> > +			nu =3D 0;
> > +			nc =3D 0;
> > +			for_each_llc_node_span(node, span) {
>=20
> Iterate the LLCs in this node..
>=20
> > +				get_span_stats(span, &u, &c);
>=20
> Now I'm confused again, @span is the span of the llc, but
> get_span_stats() is a wrapper around get_llc_stats(), and since span is
> just a single llc, why use this rather than get_llc_stats() directly?
>
Oh, it's simpler to use get_llc_stats here. Will change it.
=20
> > +				nu +=3D u;
> > +				nc +=3D c;
> > +				if (cpumask_test_cpu(dst_cpu, span)) {
>=20
> If llc includes dst_cpu
>=20
> (indent is getting a little out of hand here)
>
OK, the nesting got too deep here. I'll refactor these code.

> > +					if (fits_llc_capacity(u + tsk_util, c))
> > +						return mig_llc;
> > +
> > +					/*
> > +					 * The destination is over the margin,
> > +					 * but so may be the source. Refusing
> > +					 * then leaves the peak where it is:
> > +					 * a LLC at seven tasks stays at seven
> > +					 * while a neighbour in the same node
> > +					 * sits at four, because taking one
> > +					 * more would put that neighbour over
> > +					 * the margin as well.
> > +					 *
> > +					 * Let the task through when the move
> > +					 * still lowers the peak, guarded the
> > +					 * same way as the aggregation path:
> > +					 * the source must be noticeably
> > +					 * heavier and carry at least two more
> > +					 * tasks worth of utilization, so the
> > +					 * destination cannot end up the
> > +					 * heavier side and bounce it back.
> > +					 */
> > +					if (src_cap &&
> > +					    util_greater(src_util, u + tsk_util) &&
> > +					    src_util >=3D u + 2 * tsk_util)
> > +						return mig_llc;
> > +
> > +					return mig_forbid;
>=20
> This is an unconditional return..

This unconditional return is intentional. Once the walk reaches the dst llc=
,
we have enough information to make the final decision about whether to
migrate or not. LLCs after the destination llc don't affect this decision.
>=20
> > +				/*
> > +				 * A nearer LLC only justifies vetoing this
> > +				 * migration if the task would actually fit
>=20
> But you just skipped the nodes between target and src, those are nearer,
> no?

Yes, they are nearer. But they don't contain the destination LLC, so they a=
re
irrelevant to this migration.

>=20
> > +				 * there, so account for its utilization the
> > +				 * same way the destination branch above does.
> > +				 * Without it a LLC already holding one task
> > +				 * per core still reads as having room and
> > +				 * vetoes every migration towards a farther,
> > +				 * genuinely idle LLC.
> > +				 */
> > +				} else if (fits_llc_capacity(acc_util + nu + tsk_util,
>=20
> .. which renders this else superfluous, but that won't help with the
> indent because you still have the chained if :-(

Right, this else is unnecessary. It needs some refactoring here to make it =
readable.

>=20
> > +						acc_cap + nc)
> > +						&& fits_llc_capacity(u + tsk_util, c)
> > +						&& !util_greater(u, dst_pre))
>=20
> (logical operators go at the end of the previous line, your patch is
> inconsistent on this point, since that is what you do elsewhere)

OK, I will move the logical operators to the ends of the preceding line.

>=20
> > +					return mig_forbid;
> > +			}
> > +		}
> > +
> > +		/* Don't migrate if this is a good place to live. */
> > +		for_each_llc_node_span(node, span) {
> > +			get_span_stats(span, &u, &c);
>=20
> This is shared with the above loop, meaning you're now duplicating this
> work in case you fell through.

The destination node walk is intended to be terminal: it should find the ll=
c
containing dst_cpu and return a decision.

I will make that explicit by returning mig_unrestricted if the destination =
llc is
unexpectedly not found, so that the generic llc walk is only used for
non-destination nodes. Thus, duplicate scan is avoided.
=20
>=20
> > +			if (cpumask_test_cpu(src_cpu, span)) {
> > +				if (fits_llc_capacity(u, c))
> > +					return mig_forbid;
> > +			} else {
> > +				if (fits_llc_capacity(u + tsk_util, c))
> > +					return mig_forbid;
> > +			}
> > +		}
> > +	}
> > +
> > +	return mig_unrestricted;
> > +}
> > +
> >  /*
> >   * Check if task p can migrate from source LLC to
> >   * destination LLC in terms of cache aware load balance.
> > --
> > 2.34.1
> >
> >



