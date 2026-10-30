Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D778606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lov3wwM7
Received: by kanga.kvack.org (Postfix)
	id 34FD46B00EF; Thu, 29 Oct 2026 23:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F6C6B05BA; Thu, 29 Oct 2026 23:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D526B05BB; Thu, 29 Oct 2026 23:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34246B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BCE9A81CC
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:02 +0000 (UTC)
X-FDA: 85377800844.10.1838FE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4E9C100003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lov3wwM7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329500;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfHAHSNRL+veLqDifQqTOPeVYrNLCBIFXSw17lpPyPI=;
	b=E1mv8x05eU9v5uqPPz9kzBpIDHOKEM6e8DFs+df81w7jCBS6NmEKrXnEy4kK3nN+YoMQt3
	cFX4m7E0On1DEBMNiWh4gRbHggv9XQzInmKj9HUp9WYQvyZx4HNaxvZ8ILLjskq4BYHzSi
	la/q0RV3wIINbx2IYKBSaBFJ90p3fLM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lov3wwM7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329500;
	b=vaeoTpwpqEhU4SQYF5kGiHGVpBzkZHVNO+wTEzLnCeMFQ0B0jlni6y0ENl+qL+VNH9lp1W
	ubbD4znKVMAIjqIWB05KqKVfU7Gx3dbR6H8cPgSk9/XuVsz/InViUUaj1UHa5DMfWYwIJa
	6jE0FnkelYrAeNxoLnAAKevAC/r0Tps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D398600E4;
	Fri, 30 Oct 2026 03:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C807D1F000C1;
	Fri, 30 Oct 2026 03:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329499;
	bh=MfHAHSNRL+veLqDifQqTOPeVYrNLCBIFXSw17lpPyPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lov3wwM73hqgQQHhnik4G+4ajxYBrQ+4+tcD29b0l9qka5rILuGtK/QZJScJS+QRC
	 8NGXWbx3X3gnDZsQlruVI0rSyqpib6ktefqk9MrOdyQJ/8DdTobTg0ASW+wifNKZ/1
	 4nWRQUKkVZA3v2eDSQ0zbQB9cNXGbffzzbwVUdkP+G0OEvXc+gppYJ2wBO4ioljRrr
	 cOdyjuwjMIMWkhzZYuEysFnpuUTnJ48e15YnoJuUmxfBDuW/2N8nbmKr7ZhyjXl7HL
	 2x9ytQqMMWtWCl/Zca/4N4j/bx+fRWLLYibdWxce1JVLkYb+sQtQ+wLssHwUr4G8es
	 XaFAa7J0EVJ6w==
Message-ID: <sashiko-outbox-190202@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 08/17] sched/cache: Introduce helpers for task
 migration decisions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jianyong Wu" <wujianyong@hygon.cn>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Chen Yu" <yu.c.chen@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>
Cc: "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Ben
 Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>, "Valentin
 Schneider" <vschneid@redhat.com>, "K Prateek Nayak" <kprateek.nayak@amd.com>, "Shrikanth
 Hegde" <sshegde@linux.ibm.com>, "Phil Auld" <pauld@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, maddy@linux.ibm.com, "Michael
 Ellerman" <mpe@ellerman.id.au>, ljs@kernel.org, linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn, huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn
In-Reply-To: <20261029022036.4002331-9-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029022036.4002331-9-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:04:58 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C4E9C100003
X-Stat-Signature: tufnnk5akicbkun4pew1t1xbqcjq4udj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793329500-202995
X-HE-Meta: U2FsdGVkX193cyAimL23adVxYdAj+cLz4iSdtxwXkvjdXqNRcU3/d4Wya+5vn8Vt2klfJL5ypuouOLinXCNsxONbAPeDpDmzPFs1Lpn1xbjaSZPGDYZE+CYQ/6FJem/Vn3LT9xJ9NKAvregUb++VxhCzwu5gp36bScQePqCfLGbDWSHguBk8MxOAG0rs1nyZUEtmFgXYfLjRFvFyYJKRYVEo9NrQEyO1iw/7TBBi/FEM96YZgjB8V9G2haUx2vZkYiMyNTv0gv7FqaifQDCM/WcKqawrFQBqeabADV1RzvRB3O50n3aODlgmoFFx7BfmGOp3/sFfFN1qg+38ciDww0vTKk3JclaCVgPrXRTyspN039SK06xP5xgOvU8pw2VZkibijrtm7KazOmF3MO9uoFRRAkdVXn9PKI3GvxbgaosQJ21tFBE39FjAIUQ4/y6T1vCgqybxa7+IkxXlgQg1V3sLtCoh9NtmFQEyglpHbsZGaloZy711Vj/Ggd3is3BAkARuhHkGCsRPEvKJVEBRLqSwOne2Fq48sXbC8IuHBUHpzkObR1rTAH1G94qw7jP0ImQIIhBjC5uaFlFncpNxb5kTiV/aY6x/QZ8FSqW8GT8BTWKuoBY8Tt9DQ1x0Yca28kky4ONpjwbjawLIyDAFye09SZgdsYgH/bSBTQJyaHKaDu8OfWVc1y6vJ3cmZbN8v8rL/wyMrsUCYucchSr+zScGEbpg9QvtzNb4P2oX6pSXKrrxCfhfl9bUReeIDnpDCl3CN9tE1ACNlezfQhg/Z1MFuuG/kkB0ahALd7WiuAsbSVswKvLvq+dA0i5SeEWctulxEcBhnh+EbBAsYVgDg2AQPfSRCzfoUHNTpijN/DM9mqaCzt+/VRKJMDp2hFtRWluCBewPMy17DOlYj+JxdcdIiCzFSEhvysvCKH4kKP6hhCU+Htg1DlH+QN67DsPrtBZdhLLI3NPvyR7ZRXt
 +uxnhGP2
 ZvwRglSEEZWOmHKN32Pa78cKAp9e/sVAuZC+nWR18evRlHan0enbBpJaHNKevibXV+3pfPnqE7bZSH6d3p34wNMRGH7hvNgYgkhE8nOoqjX3Hs6l+4v9l+Nol1ZrK6d11FgUYCVytN88iZw87sh8kclXXeSDnOEuAPpEOZVgzTHHfDFJP9q9y6HUkL0hO3JUxk73h3TUOLIZ1aN8F4xMKMYEwz4UL1G8eCuxrq+BD7gbKBs6FZFpBKcJOlFqTknrKuQdGj5xJUqnU0eVYeICfj6zQ7FU5/+afoKy3avbffwsGS6Hs/jN3l7tz62MQCqhGVkM3xGG4N7ctW63RtuRnsd4qEuaiG8G0jRDenGKze9ywh+0VQaK38cbCsySPjcUncyT9daTb9A3yQAS/kMq+E4PiiAoqS4F3dwsbrOvuW0OCzuzO1nvzn5A+c+5SbMAGxMuRanNCD2QmUz2xTtSTxNOVVZrJckIH9ElWhLU28O40VImHp0us13xajp3cv2EADwGkG5Ml+694bC4yI/oN44K6SEgFufyZ/JFNzNF0txmmGbnuGBIfTp0JSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] sched/cache: can_migrate_llcs() misapplies node walk when dst pr=
ecedes src
--

commit c7cd924467c2448429791ac003c69c23764da05a
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Introduce helpers for task migration decisions

This commit introduces get_node_stats(), can_migrate_llcs(), and
if_to_prefer(), and extends fits_llc_capacity() to support cache-aware task
migration decisions across multiple LLCs and NUMA nodes.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fe357d79b6e06..4eb7cede9080f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

[ ... ]

> @@ -10614,13 +10617,185 @@ static enum llc_mig can_migrate_llc(int src_cp=
u, int dst_cpu,

[ ... ]

> +static enum llc_mig __maybe_unused can_migrate_llcs(int src_cpu, int dst=
_cpu,
> +				     struct task_struct *p, bool to_pref)
> +{
> +	unsigned long src_util, src_pre, src_cap, dst_util, dst_cap, dst_pre;
> +	int target_node, src_node, dst_node, dst_distance;
> +	int node, target_cpu =3D src_cpu, n_llc;
> +	unsigned long tsk_util =3D 0;
> +	bool got_src =3D false;
> +
> +	if (!get_llc_stats(src_cpu, &src_util, &src_cap) ||
> +	    !get_llc_stats(dst_cpu, &dst_util, &dst_cap))
> +		return mig_unrestricted;
> +
> +	if (p) {
> +		struct mm_struct *mm =3D p->mm;
> +
> +		if (mm)
> +			target_cpu =3D READ_ONCE(mm->sc_stat.cpu);
> +		target_cpu =3D target_cpu >=3D 0 ? target_cpu : src_cpu;
> +
> +		tsk_util =3D task_util(p);
> +	}

[ ... ]

> +	src_node =3D cpu_to_node(src_cpu);
> +	dst_node =3D cpu_to_node(dst_cpu);
> +	target_node =3D cpu_to_node(target_cpu);
> +	dst_distance =3D node_distance(target_node, dst_node);
> +
> +	/*
> +	 * For moves away from the cache preferred node, examine the source,
> +	 * intervening nodes and destination in the cached affinity order.
> +	 */
> +	for_each_affi_node(target_cpu, node) {
> +		unsigned long nu =3D 0, nc =3D 0;
> +
> +		if (!got_src) {
> +			if (node !=3D src_node)
> +				continue;
> +			got_src =3D true;

[ ... ]

> +			/* Cross-node moves must leave the source node filled. */
> +			if (get_node_stats(src_node, &nu, &nc, &n_llc) && n_llc) {
> +				nu =3D nu < tsk_util ? 0 : nu - tsk_util;
> +				if (fits_llc_capacity(nu, nc, false))
> +					return mig_forbid;
> +			}
> +			continue;
> +		}
> +
> +		if (node !=3D dst_node) {
> +			if (!get_node_stats(node, &nu, &nc, &n_llc) || !n_llc)
> +				continue;
> +
> +			/*
> +			 * Estimate average LLC headroom in intervening nodes.
> +			 * Charge one task per LLC, or per pair of LLCs when
> +			 * this node is closer to the target than the destination.
> +			 */
> +			if (node_distance(target_node, node) < dst_distance)
> +				nu +=3D DIV_ROUND_UP(n_llc, 2) * tsk_util;
> +			else
> +				nu +=3D n_llc * tsk_util;
> +
> +			if (fits_llc_capacity(nu, nc, true))
> +				return mig_forbid;
> +			continue;
> +		}
> +
> +		if (fits_llc_capacity(dst_util, dst_cap, true))
> +			return mig_llc;
> +
> +		if (util_greater(src_pre, dst_pre) && src_util >=3D dst_util)
> +			return mig_llc;
> +
> +		break;
> +	}

[Severity: Medium]
In kernel/sched/fair.c, what happens in can_migrate_llcs() when to_pref is
false and src_node !=3D dst_node, yet dst_node precedes src_node in the
for_each_affi_node(target_cpu, node) walk?

The loop skips every node before src_node while got_src is false, so
dst_node is passed before got_src becomes true. Once node =3D=3D src_node s=
ets
got_src =3D true, every subsequent node in the affinity sequence satisfies
node !=3D dst_node. Those trailing nodes are then evaluated as intervening
nodes and can veto the move with mig_forbid, while the destination checks at
node =3D=3D dst_node are never reached, contrary to the commit message guar=
antee
that nodes following the destination do not participate in the decision.

When wired up to can_migrate_llc_task() and alb_break_llc() in the
subsequent commit ("sched/cache: Apply multi-LLC aggregation policy to task
migration"), dst_node can precede src_node in target_cpu's affinity order
even when to_pref is false in several cases:

1. Both can_migrate_llc_task() and alb_break_llc() read mm->sc_stat.cpu once
   to compute pref_llc for if_to_prefer(), and can_migrate_llcs() reads
   mm->sc_stat.cpu a second time via READ_ONCE(mm->sc_stat.cpu). A
   concurrent update in task_cache_work() or account_mm_sched() can cause
   if_to_prefer() to return false for the old CPU while can_migrate_llcs()
   reads a new target_cpu whose target_node ranks dst_node before src_node.

2. In alb_break_llc(), pref_llc is only derived from mm->sc_stat.cpu when
   cur->sched_class =3D=3D &fair_sched_class (otherwise remaining -1 so
   if_to_prefer() returns false), whereas can_migrate_llcs() unconditionally
   reads target_cpu =3D READ_ONCE(p->mm->sc_stat.cpu).

3. In if_to_prefer(), llc_to_node(pref_llc) can return -1 (for example, if
   rebuild_llc_node_map() failed allocation), causing if_to_prefer() to
   return false while can_migrate_llcs() resolves target_node via
   cpu_to_node(target_cpu) and walks for_each_affi_node(target_cpu, node).

Should the caller pass a single consistent target_cpu or preferred node to
both helpers, or should can_migrate_llcs() handle encountering dst_node
before src_node during the affinity walk?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D8

