Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61135606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmuXpDWj
Received: by kanga.kvack.org (Postfix)
	id 173436B05BA; Thu, 29 Oct 2026 23:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C5A6B05BB; Thu, 29 Oct 2026 23:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061986B05BC; Thu, 29 Oct 2026 23:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D12816B05BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D334120569
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:04 +0000 (UTC)
X-FDA: 85377800928.08.9916CAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7500140005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmuXpDWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329502;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmyrgsSenIdKWvsMt+vzAqLnlcY3j2BDDn00tzyT64o=;
	b=DdKqu5ezJ7080BAeTofiwzdfH/SRssPh9U91smREephAAsJKnpCX13JZqDsjwlKL9hWT4Z
	X8Y4OO8RVdrgBrJxzAe2rKRdlsWWktykF8mORJBg4UpLu5w1MmBLovjrV4iC6PvDcU3DFs
	uofQVBZDWNNYvL1ECxyig3TicWMEMjg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmuXpDWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329502;
	b=zdDpNjO8CG1aHvXZrqEdRQXdYyg35JzCXK4J/pgN8JqI6X+HoBOx9RVMykZ8EOiRk2aiVQ
	f+HCad8uU0a22bVYHhTsoovrul6rg5bQzCdP/PEg2cTfXhO9kyr8oCucxgIoDa22jIYgSq
	rbn3xGkzsFER22Tu4Ik6hS0iI7uTv54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0EF540B01;
	Fri, 30 Oct 2026 03:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EE71F000C1;
	Fri, 30 Oct 2026 03:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329501;
	bh=KmyrgsSenIdKWvsMt+vzAqLnlcY3j2BDDn00tzyT64o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VmuXpDWjxp+eASQ/+9COf9pmjHsqLEJm8dsALMaqwIhAMTtKzyvlkFhRTwMTfRQlJ
	 c0TwHlv2bc1Eh/8fyU2/sU/ABBUTZYN7wrTFWLLkuu/3dKYdcoE6j8UOnawGnDIYuG
	 fZiWnYRHhQ1EVUKxlPtr/NJy7ZCjemE8lAsjvyuf8ZlYj9gPrfCLCBAIlypvzPOYhG
	 3CX1CHnL2z6V64+kiXEkuq5mYrZLbIS0AOlge2K2ma6KCpvm1acV7VoWj6EGZRpWMT
	 zo7n0PHAbBhNV+8hwNSvkJ+t61z6jCOODj/yYupCRTD8WKKTsY0Q0nkMY9L6RGzvXX
	 05atI34ML1GvQ==
Message-ID: <sashiko-outbox-190203@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 09/17] sched/cache: Introduce rq affinity gain
 calculation
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
In-Reply-To: <20261029022036.4002331-10-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029022036.4002331-10-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:05:00 +0000
X-Rspamd-Queue-Id: 7500140005
X-Stat-Signature: dx6r9fkbj1ecxhiyomgob9qaoq5jioaz
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793329502-79879
X-HE-Meta: U2FsdGVkX18JrHP6+fzyu4j3ZxVX+173h5rsS6Hpmd+OcIrHGJDfCheZQYRvcVweNtqPmIfxPa7qQ/FjDNAPC4jc/PFTrBrySFo5guq4QUOCPWUo33tDr/aMEllzZgSGHbVQrjwJFw5RiAZF8wznaw6knWHHTcU+EYTftpeX1pdxAehQTabaWmhhlkxOgVfaMANLcY4nQHbPS2G0kXpvY/J5oHCR0/yvWn3yLY9R7WromqR6vXsPml51GRwtbgwSjog1YWrDnxutRoKuFFd2T/CdLjSPbG/qM6x6up5QIGOmueJTgRgNLWlH0CqTaB8HKhpxlt4SYDjcxWsq6zXK3lRBI8HL9lAmLApDcUvlY/tOSwusJlkyCMTaKRXsszBzOe0VejkSKt8WRZRWv1xaYg98jcCYzpfUxZlI0vc1Qw9XEl93dG+wNf5ne27aeQEqJ1txTjPtWo88SXEhhpYtdO24d06Eo8onwbPz9zQ6HjsUrCvyW7WLj70m7GqHEQ+pc4eUYEW+O56KLkPOb+E2H7ts/87eQKrhZAoC5/RPpl233ciOrcJam9J2fHDoD0168MeQntuaeCbALd68Tc7Kz7Hs4mpIFR+8otnM5FaHIEXXkEC3y5Xc2fxSrKSjrKsxsAP5SQ9hf/f7hd75l0HHEYAvCFMsAjf58JIqKo7i34R+I5khyUwG1O2+1sE6zcuUCYVqDOB6JyyNdq1m2llHqFFxaEkd1aXyZ2TVgJXJP3MnBmD/Y6gfXTm/su4SCJKQdOFBM7Mc7CCmhgVScEPV5j+23RECUlWVlggow01D4uDD5rEiQ7rhC9PwF3Wx5Adgnh3FP0/b5zamG8nhzsnVu8qF0NIDpE3gXlwAgrUG6Asd1wE6wjRDoNfvmDThxS6oC7Wh7UxeWEmJDyde43ha7W746M+QSUHfy0W2KpeL5J6wOm/0HgZV1dnYgBMGU3G/hMIxCNvxypKB0ANKSoG
 K2ljSp1o
 0VraSoPcC7HUOgCDHdag+Y3vwHHyu3lLBY6Kkc7HXyzSX/gbpUxeVCWjvIBEIOmusmKsrYd8OEFCSkkN0hoQsukGZj1l8PUV6sSy74NlDEyhZ9U6lve2JeEa70y67MQVIFEwWev5EcVFQHBotYH4AAJhWf1MgM66WjwWX0HSQWBuZYTkprSSbOFOQHCQfYZnJyR2KgqBIOX4sNlOK8aQMss5H02tIJDzjCZK1EBzusUQkNMGfpKPrEgitkpKeM0aOFDWtFpk4+cAURXTEIJU4l5xCFMteXIPnFRaAg2IAExM7ELQyo/fqrMJsOfaW4fTUIFcm0fT1zTca6iEII4iO97YXSJGSLEL5QKnyI4SRQfB33EvSPseFoHtG82R5KkTf10peSiAJG4Lvv6yOKLa4djuF21aq5wVirVpSRN9QlqzN2x3uTAbPsEni2JiTb+QMDvZd/u0K0ctDf4syk0SrYuY/ZiRO+1XjKvTXzQMI4+S95z0ud3mRiIuL7gt6xnCUYE08J8di0v2px9VuwubSh5CT9oe8XIVuvtOdzlFgktwdEx6si3sJb3l5uEYosFYFqvhC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] sched/fair: unbounded affi_llcs write in get_affi_llcs()
- [High] sched/fair: wrong llc_max bound in calc_affinity_llc_score()
- [Medium] sched/fair: missing negative node check in get_affi_llcs()
- [Medium] sched/fair: missing negative rank check in get_affi_numas()
- [Medium] sched/fair: LLC-less nodes truncate NUMA list in get_affi_numas()
--

commit c22c2cf580aaca6a95248753109bc427527a2a88
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Introduce rq affinity gain calculation

This commit introduces helper functions to compute NUMA and LLC affinity
gain scores for candidate source runqueues during cache-aware load
balancing.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4eb7cede9080f..eb08ae66f4650 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -11999,6 +11999,219 @@ static bool update_llc_busiest(struct lb_env *e=
nv,
>  	 */
>  	return sgs->nr_pref_dst_llc > busiest->nr_pref_dst_llc;
>  }
> +
> +/*
> + * Get preferred LLCs for which the destination precedes the source in
> + * that LLC's intra-node affinity order. For preferred LLCs outside the
> + * source/destination node, include them only when src_llc > dst_llc,
> + * following ascending LLC ID order within that node.
> + */
> +static int get_affi_llcs(int src_llc, int dst_llc,
> +			 int *affi_llcs, int llc_max)
> +{
> +	int j =3D 0, src_rank, dst_rank, cur_node, node, llc;
> +
> +	if (src_llc =3D=3D dst_llc)
> +		return 0;
> +
> +	cur_node =3D llc_to_node(src_llc);
> +	if (cur_node !=3D llc_to_node(dst_llc))
> +		return 0;

[Severity: Medium]
What happens in get_affi_llcs() when llc_to_node(src_llc) and
llc_to_node(dst_llc) both return -1 (NUMA_NO_NODE) while src_llc !=3D dst_l=
lc?

In kernel/sched/topology.c, llc_to_node() returns -1 if llc < 0, if
llc_to_node_map is NULL, or if llc >=3D map->nr_llc (for instance during
build_sched_domains() between cpu_attach_domain() attaching newly allocated
sd_llc_id values and rebuild_llc_node_map() publishing the updated map, or
when sched_domains_free_llc_id() resets sd_llc_id to -1).

If both calls return -1, cur_node !=3D llc_to_node(dst_llc) is false, and in
the loop below node =3D=3D cur_node is false for every valid node, so every=
 LLC
across all nodes takes the remote-node else branch and is added whenever
src_llc > dst_llc. Should get_affi_llcs() return 0 when cur_node < 0?

> +
> +	for_each_node(node) {
> +		for_each_llc_of_node(llc, node) {
> +			if (llc >=3D llc_max)
> +				continue;
> +			if (node =3D=3D cur_node) {
> +				src_rank =3D affi_llc_rank_of(llc, src_llc, cur_node);
> +				dst_rank =3D affi_llc_rank_of(llc, dst_llc, cur_node);
> +				if (src_rank < 0 || dst_rank < 0)
> +					continue;
> +				if (src_rank > dst_rank)
> +					affi_llcs[j++] =3D llc;
> +			} else {
> +				if (src_llc > dst_llc)
> +					affi_llcs[j++] =3D llc;
> +			}
> +		}
> +	}

[Severity: Critical]
Can get_affi_llcs() overflow affi_llcs[] (which points to sd->affi_ids,
allocated with llc_max entries in alloc_sd_llc()) if llc_to_node_map is
updated concurrently?

Unlike get_affi_numas(), which checks if (j >=3D max) break, get_affi_llcs()
only checks if (llc >=3D llc_max) continue and does not bound j against
llc_max. However, for_each_llc_of_node() in kernel/sched/sched.h enters a
separate RCU read-side section on each node iteration:

    #define for_each_llc_of_node(llc, node) \
        scoped_guard(rcu) \
            for (struct llc_node_iter __ln_iter =3D \
                     llc_node_iter_begin(node); \
                 ((llc) =3D llc_node_iter_next(&__ln_iter)) >=3D 0;)

If rebuild_llc_node_map() publishes a new llc_to_node_map during CPU hotplug
or sched_domain rebuilds where an LLC ID freed on a lower-numbered node is
reallocated to a higher-numbered node, get_affi_llcs() can observe the same
LLC ID (< llc_max) in multiple node iterations and increment j past llc_max,
writing past the end of sd->affi_ids and causing calc_affinity_llc_score() =
to
read out of bounds as well. Should get_affi_llcs() check j >=3D llc_max (or
hold a single RCU read lock across the entire node scan)?

> +
> +	return j;
> +}
> +
> +static int get_affi_numas(int src_node, int dst_node, int *affi_nodes, i=
nt *affi, int max)
> +{
> +	int j =3D 0, src_dist, dst_dist, node;
> +
> +	for_each_node(node) {
> +		if (j >=3D max)
> +			break;
> +		src_dist =3D node_distance(src_node, node);
> +		dst_dist =3D node_distance(dst_node, node);
> +		if (src_dist < 0 || dst_dist < 0)
> +			continue;
> +		if (src_dist =3D=3D dst_dist) {
> +			src_dist =3D affi_node_rank_of(node, src_node);
> +			dst_dist =3D affi_node_rank_of(node, dst_node);
> +			if (src_dist > dst_dist) {
> +				affi[j] =3D 1;
> +				affi_nodes[j++] =3D node;
> +			}
> +			continue;
> +		}

[Severity: Medium]
Should get_affi_numas() verify that src_dist and dst_dist are non-negative
after calling affi_node_rank_of(), and bail out early when
src_node =3D=3D dst_node?

In kernel/sched/topology.c, affi_node_rank_of() takes its own RCU lock per
call and returns -1 if affi_node_order is NULL (for example if
rebuild_node_order() fails allocation and publishes NULL) or if a node ID is
out of bounds.

If affi_node_rank_of(node, src_node) returns a valid rank (>=3D 0) and a
concurrent update causes affi_node_rank_of(node, dst_node) to return -1,
src_dist > dst_dist evaluates to true (even when src_node =3D=3D dst_node) =
and
adds the node with weight 1. By comparison, get_affi_llcs() checks
if (src_rank < 0 || dst_rank < 0) continue before comparing ranks.

[ ... ]

> +static int calc_affinity_numa_score(struct sched_domain *sd, int src_cpu=
, int dst_cpu,
> +			int *affi_node, int *affi, int *last_node, int *num, int llc_max)
> +{
> +	int llc, src_node, dst_node, tmp_node, score =3D 0, numa_count, node_ma=
x;
> +
> +	src_node =3D cpu_to_node(src_cpu);
> +	dst_node =3D cpu_to_node(dst_cpu);
> +	node_max =3D min_t(int, nr_node_ids, llc_max);
> +	/*
> +	 * The destination stays fixed during this source-rq scan. Reuse the
> +	 * eligible node list and weights for consecutive source CPUs in the
> +	 * same node; each rq's task counts are applied below.
> +	 */
> +	if (src_node !=3D *last_node) {
> +		*last_node =3D src_node;
> +		*num =3D get_affi_numas(src_node, dst_node, affi_node,
> +				      affi, node_max);
> +	}

[Severity: Medium]
Can CPU-less or offline NUMA nodes cause get_affi_numas() to drop active
cache-preferred nodes when nr_node_ids > llc_max?

In alloc_sd_llc(), sd->affi_ids and sd->affi_weights are sized to llc_max
(the number of LLC IDs for online CPUs), so calc_affinity_numa_score() caps
node_max at min_t(int, nr_node_ids, llc_max).

However, get_affi_numas() iterates over for_each_node(node) (all possible
nodes in node_possible_map, including CPU-less HBM/CXL memory nodes or
offline nodes that have no LLCs) and stops once j >=3D max. Any lower-numbe=
red
node without LLCs takes a slot in affi_node[] while always producing
numa_count =3D=3D 0 in the for_each_llc_of_node(llc, tmp_node) loop below, =
which
can truncate higher-numbered NUMA nodes that actually have LLCs and tasks.

[ ... ]

> +static int calc_affinity_llc_score(struct sched_domain *sd, struct sched=
_domain *sd_rq,
> +			int src_cpu, int dst_cpu, int *affi_llc,
> +			int *last_llc, int *num, int llc_max)
> +{
> +	int src_llc, dst_llc, score =3D 0;
> +
> +	if (sd->flags & (SD_NUMA | SD_SHARE_LLC))
> +		return 0;
> +
> +	src_llc =3D llc_id(src_cpu);
> +	dst_llc =3D llc_id(dst_cpu);
> +
> +	/*
> +	 * The destination stays fixed during this source-rq scan. Reuse the
> +	 * eligible LLC list for consecutive source CPUs in the same LLC;
> +	 * each rq's task counts are applied below.
> +	 */
> +	if (src_llc !=3D *last_llc) {
> +		*last_llc =3D src_llc;
> +		*num =3D get_affi_llcs(src_llc, dst_llc, affi_llc, llc_max);
> +	}
> +
> +	for (int i =3D 0; i < *num; i++) {
> +		if ((unsigned int)affi_llc[i] < llc_max)
> +			score +=3D sd_rq->llc_counts[affi_llc[i]];
> +	}

[Severity: High]
Does calc_affinity_llc_score() check the wrong llc_max bound before indexing
sd_rq->llc_counts[]?

In lb_affi_scratch(), llc_max is read from this_rq()->sd->llc_max (the
balancing CPU's bottom sched_domain), whereas sd_rq is
rcu_dereference_all(rq->sd) for the candidate source runqueue, whose
sd_rq->llc_counts array is sized by sd_rq->llc_max (and annotated with
__counted_by_ptr(llc_max) in struct sched_domain).

While calc_affinity_numa_score() checks if (llc >=3D sd->llc_max) against
sd_rq->llc_max, calc_affinity_llc_score() checks
if ((unsigned int)affi_llc[i] < llc_max) against the balancing CPU's llc_ma=
x.
If sd_rq->llc_max < llc_max (for example while build_sched_domains() attach=
es
updated domains one CPU at a time under RCU, across reused vs. rebuilt cpus=
et
partitions during NOHZ balance, or if alloc_sd_llc() failed on sd_rq leaving
sd_rq->llc_max =3D=3D 0 and sd_rq->llc_counts =3D=3D NULL), indexing
sd_rq->llc_counts[affi_llc[i]] can read out of bounds or dereference NULL.
Should this check against sd_rq->llc_max as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D9

