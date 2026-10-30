Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5775606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IScF66ZB
Received: by kanga.kvack.org (Postfix)
	id 287846B05BF; Thu, 29 Oct 2026 23:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D006B05C0; Thu, 29 Oct 2026 23:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A7F6B05C1; Thu, 29 Oct 2026 23:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFD626B05BF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 681381A05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:10 +0000 (UTC)
X-FDA: 85377801180.29.9D8398E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6F7140006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IScF66ZB;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329508;
	b=aVP9qLrLR1thoVdgFG+hWC1sKZOVSIkupa+Z3rL/GN2r5gucTZuzenLmGIAInVnmIqrK8m
	0+wBfCV0qH3cyP3Kq4A5fQ3r5wUBHMdT13C3+W2X258VINndn0Tzr+3Qb2t4pyRgtR8yWe
	1TbMClY/RzNwCrZ3VtzijxaO+w8RAEQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IScF66ZB;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329508;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TL2hnKrhb2zL2O+ZtY4/+qBDU9dE+NoLIxuE6e9RH7A=;
	b=G/BBSk9G3EwFgfoHBgjlWq1x0/LL30rq7E2jns17+aFElW+kh1hdFw01p/q6swvDXgRwBk
	XHdEUkzD+nFwlJCvHDMgcBiw/++GGNpGKgMzrd2gUEMzWrlB3IpgefkgxTu7sMqx0tcecB
	FTTZumIXBrKA10eLRs9JrSdpN3TgrbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0861443853;
	Fri, 30 Oct 2026 03:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E781F000C1;
	Fri, 30 Oct 2026 03:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329507;
	bh=TL2hnKrhb2zL2O+ZtY4/+qBDU9dE+NoLIxuE6e9RH7A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IScF66ZBi+3UVSTF4fMUxJic3uHl9dcbeiv/GOsF1TW7TJQibr4rU0XghCysI+Ydi
	 1HK5S59PuC9TTxy+hZ5YRqhlq894L8UBrYQm6oDfYhQ8Q4/mwXliaejEfDYXRGuIWB
	 gN2wNd1o+EkqeYCGaCtg+sYy/+5Hf0m8Qo1laLXthMZ8uKYQb3HBzZhVnCFJWYWePi
	 F1Tdecglpb8JqpJ5Xzvahoa5e4lS3iLVnkzYVFt22QKY0CulWqgkHj3sW9KlNwjnKr
	 87cuKZoiSYYk4SEWArYZ4it0fy4yXiy41nfeFHHC5MnZDcwv6H7E6iFYbMWbRfQAsK
	 6iaiz5aOJP73g==
Message-ID: <sashiko-outbox-190209@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 15/17] sched/cache: Include recently used
 preferred nodes in LLC scans
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
In-Reply-To: <20261029025614.4004884-1-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029025614.4004884-1-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:05:06 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: B6F7140006
X-Stat-Signature: 6fx5xdhddamsdis7498sao8aq4hwzgry
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793329508-229778
X-HE-Meta: U2FsdGVkX18FZDP+oFQPbX4muH5y9XmFT6JI05OzKW74RY6ZIjf82yRBi8Vm+PR9AErjK0qnekiWyQztJ3FvB+em/TDETZ5Ol8JjZGZHOMwgDhzKoo0LxyC/6RpJuesgJZCbvgeRU9k9A55uFw9iecRd6ydoe05GmzTaa/uk1045s1gH9t/Mvcf/IsOIhGlpW8ESmgcsKflL2xgKUwVTWo5i/uTE+xTdh3mMIiLG0ODn+PU/DvTLZoF5MrFqTTBwRvLL1n2MfGOSY8vGV4TD0rtnew5WKvBYYPwwLn9s8hZaTZXWY2CWUH9vE5bELy4JhMlSyjSFseQpX8P5oexS273cfLThRj1sr22NSbmda2XQLB6LpiGxzgcLbBzT6aSWTq11ZXsKjyv7Jy+sOWiTCH2SBs90UGNP6IeCrIZzO9W3bW1tw00eYLYMb6SzyZ/x4sxUUzF1g4ypcbeI+P+OtXN0cWYov2at3ZaLiwSlOw6jS4C2fGeFRS7wD0d7Aw4nm2LqddQLKo0I4M1a6vxRSqm0lsajB44mjKeC+MfGuw4MHl790MMDsoVMBs4O2AVbt52ZWQMAT6RG8W1LJ00ebq0d/B8ir1zHhi3vSrL9a8UeWeyz0bkT54d2VI+zh2GwsebLt55A4qRgmKjpHUPlRqPqCy2GQZ5qEZohNKWx4VOJKh2i/Q2799b4t2a9w4altYKUYWi5nk7xYbc/FroI5aTbBG0RPIIfiwet1t+Hju+sASmG2j9uHj8QPW7992xhmznMlX7JbVQh8xUkS6Byn/hnuD1pIN3TTKFIK58jUDCxBDC+dTbLujv3+bs7HbnPMJM2nOREfvvBiie1UNqZOrTU/oFEO0uWOKGpKnF8LaNTYHi7F1q71kDTt0mkvU1ENJODfV7mLUgQlXoGUdCzsrl/xcCCFQdFdtIoytgEno3DQZ8cNr7/m69IDvQzp6qBjz+hSwSt8sHrZGG38Bc
 Cjzd3rDu
 gLrUFjGpOIVsQgMnr3MVs9qY7omcimx+yUR73oFLnfy1zXLTi60t0wMSgd0A/cwtHaw5NTKSF6OWxqI/Yd2trlA5P/FiB8vGplUd2MrtOm7R8KuSV9GPEl/e4/52mXrjsFKR1pDHzV7H0BA1bSXRWM7799C0xEiYCXlzC07Di3iVzPm06BfCyiGhIMbvEtkOH7qsIMv2M9jX3kMCLJrIKJZvzMhzPzqjvUSneTUlcsD2TukfroIDxLcf3NzfzRk91RYd+hHy6fv+5NWjtJZMKew/0lH0lm5goj8DCFuv65S3Dw0205dpqigNCkkBVTIgh6mYlg3/420ZqNeDgBB8QN8XxRE2bm/UXGUV6Ef+qI6oU4OdOf9H+8w1PBaKMVMOueNU8sFWO9IxPdLGjRDmGaMu8r2ndShiOz36VyNCX8LuVgqTx4VwmOil31u47sjc5Nk7fn+B4f/3yR6Vh7R/sM5X4xDpxdKrtASZe1+dQ9du0QlchrmPxt+kWeS54MSSAGe9HYGilkUPBRrZtNFbn/CLwX14U8Tq+Nt1VD3HG5QkC46lXcCI1Z4mLPu59VCu8gwnU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] sched/fair: out-of-bounds access on node_epoch due to num_poss=
ible_nodes()
- [Medium] sched/cache: premature invalidation and repeated stores on node_=
epoch in account_mm_sched()
--

commit 75dca431c1e296ff78c3df14b7869d56e2b49b4e
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Include recently used preferred nodes in LLC scans

This commit records preferred NUMA nodes observed while accounting tasks
that share an mm in a per-mm node_epoch array and includes recently
observed nodes in the LLC scan mask in get_scan_cpumasks(). Stale node
records are expired using the LLC affinity timeout or cleared when the
preferred cache state of the mm is invalidated.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 20a6a7f5c2f74..b93b6e6c9deae 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1594,6 +1594,9 @@ void mm_init_sched(struct mm_struct *mm,
>  	mm->sc_stat.next_scan =3D jiffies;
>  	mm->sc_stat.nr_running_avg =3D 0;
>  	mm->sc_stat.footprint =3D 0;
> +	mm->sc_stat.node_epoch =3D kcalloc(num_possible_nodes(),
> +					 sizeof(*mm->sc_stat.node_epoch),
> +					 GFP_KERNEL);

[Severity: Critical]
Can this overflow mm->sc_stat.node_epoch[] on systems with sparse NUMA node
IDs?

In mm_init_sched(), mm->sc_stat.node_epoch is allocated with
num_possible_nodes() elements, which expands to num_node_state(N_POSSIBLE)
and returns the population count of possible nodes rather than the maximum
possible node ID plus one (nr_node_ids).

Later, account_mm_sched() and get_scan_cpumasks() index node_epoch[]
directly by raw node ID via pref_nid and for_each_node(node), which can
yield node IDs up to nr_node_ids - 1:

    if (pref_nid !=3D NUMA_NO_NODE && mm->sc_stat.node_epoch)
        mm->sc_stat.node_epoch[pref_nid] =3D epoch;
    ...
    for_each_node(node) {
        if ((long)(epoch - READ_ONCE(node_epoch[node])) >
            llc_epoch_affinity_timeout)
            WRITE_ONCE(node_epoch[node], 0);
    }

and in get_scan_cpumasks():

    for_each_node(node) {
        if (node =3D=3D pref_nid)
            continue;

        if (node_epoch[node] > 0)
            cpumask_or(cpus, cpus, cpumask_of_node(node));
    }

When possible NUMA node IDs are discontiguous (for example, nodes 0 and 2
are possible while node 1 is not, giving num_possible_nodes() =3D=3D 2 and
nr_node_ids =3D=3D 3), any node ID >=3D num_possible_nodes() reads or write=
s past
the end of the slab buffer, and the memset() in account_mm_sched() only
clears num_possible_nodes() entries.

Should the kcalloc() in mm_init_sched() and the memset() in
account_mm_sched() use nr_node_ids instead of num_possible_nodes()?

[ ... ]

> @@ -1713,6 +1726,13 @@ void account_mm_sched(struct rq *rq, struct task_s=
truct *p, s64 delta_exec)
>  		epoch =3D rq->cpu_epoch;
>  	}
> =20
> +	node_epoch =3D mm->sc_stat.node_epoch;
> +#ifdef CONFIG_NUMA_BALANCING
> +	pref_nid =3D READ_ONCE(p->numa_preferred_nid);
> +#endif
> +	if (pref_nid !=3D NUMA_NO_NODE && mm->sc_stat.node_epoch)
> +		mm->sc_stat.node_epoch[pref_nid] =3D epoch;
> +
>  	/*
>  	 * If this process hasn't hit task_cache_work() for a while invalidate
>  	 * its preferred state.
> @@ -1722,6 +1742,16 @@ void account_mm_sched(struct rq *rq, struct task_s=
truct *p, s64 delta_exec)
>  	    exceed_llc_capacity(mm, cpu_of(rq))) {
>  		if (READ_ONCE(mm->sc_stat.cpu) !=3D -1)
>  			WRITE_ONCE(mm->sc_stat.cpu, -1);
> +
> +		if (node_epoch)
> +			memset(mm->sc_stat.node_epoch, 0,
> +				sizeof(*node_epoch) * num_possible_nodes());
> +	} else if (node_epoch) {
> +		for_each_node(node) {
> +			if ((long)(epoch - READ_ONCE(node_epoch[node])) >
> +			    llc_epoch_affinity_timeout)
> +				WRITE_ONCE(node_epoch[node], 0);
> +		}
>  	}

[Severity: Medium]
Does updating and expiring mm->sc_stat.node_epoch[] here in
account_mm_sched() prematurely wipe out recorded preferred nodes and cause
repeated stores to the shared array on every update_se() call?

First, in task_tick_fair(), entity_tick() runs before task_tick_cache():

task_tick_fair()
  entity_tick()
    update_curr()
      update_se()
        account_mm_sched()
  task_tick_cache()

When a process has not run task_tick_cache() for more than
llc_epoch_affinity_timeout epochs, account_mm_sched() writes
mm->sc_stat.node_epoch[pref_nid] =3D epoch and immediately hits
(long)(epoch - READ_ONCE(mm->sc_stat.epoch)) > llc_epoch_affinity_timeout,
zeroing the entire node_epoch[] array with memset() right before
task_tick_cache() updates mm->sc_stat.epoch and queues task_cache_work() ->
get_scan_cpumasks().

Second, when invalid_llc_nr() or exceed_llc_capacity() holds (such as for
single-threaded tasks or processes exceeding LLC capacity),
account_mm_sched() writes node_epoch[pref_nid] =3D epoch and then
unconditionally zeroes the array via memset() on every update_se() call
(ticks, wakeups, and context switches), unlike mm->sc_stat.cpu which checks
READ_ONCE(mm->sc_stat.cpu) !=3D -1 before writing.

Third, in the else branch:

    for_each_node(node) {
        if ((long)(epoch - READ_ONCE(node_epoch[node])) >
            llc_epoch_affinity_timeout)
            WRITE_ONCE(node_epoch[node], 0);
    }

when node_epoch[node] is already 0, (long)(epoch - 0) >
llc_epoch_affinity_timeout is always true once rq->cpu_epoch exceeds
llc_epoch_affinity_timeout, so every CPU running a thread of the mm
repeatedly executes WRITE_ONCE(node_epoch[node], 0) for every unused node on
every update_se() call.

Should node_epoch[pref_nid] only be updated after the invalidation check
when the value actually changes, and should the expiration loop check that
node_epoch[node] is non-zero before writing 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D15

