Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98704606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gcvXoDzo
Received: by kanga.kvack.org (Postfix)
	id B50266B02D2; Mon, 19 Oct 2026 21:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00B66B03D4; Mon, 19 Oct 2026 21:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8E46B03D5; Mon, 19 Oct 2026 21:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A654B6B02D2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:16:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D4784088E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:16:04 +0000 (UTC)
X-FDA: 85341238248.02.DB746D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9CFCB1C0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:16:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcvXoDzo;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792458962;
	b=MQtB6Rm5QiXo8zpmFL+o2X9EljRKDhTw9yfPqOmpKvGoDwffKk/nYGLLW43UjuOUydkE7h
	JffRQal3y7fagM14soLbcSjO40rHh8TN99Kmlzc7sXW/bTrfekq+X4i2S8tfPUuBLRWYez
	CylLIOP04PAkEv3Tuqw78Dua3rMfrwA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcvXoDzo;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792458962;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGOjQkp5UPWqrBjqLOWLwe3QJCJgQPlac2zzWkh+ag8=;
	b=lW47/c0QmANHZ0B2l7NMkya0Apz66cTuceNDs6+t8r+28WVmPIeAF8/BArWCAJF1usAB17
	YOn6ZJxlXW25DKjuSqA4tJdXHMSbydLdPjfJqvs/xzpQW1tjinwF0bmL8+fy2Nbk8YsqoY
	1VPLKhqL/Yb84zR+9hjrYaGiXlIHMPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F12EB40C13;
	Tue, 20 Oct 2026 01:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359971F000C4;
	Tue, 20 Oct 2026 01:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792458961;
	bh=jGOjQkp5UPWqrBjqLOWLwe3QJCJgQPlac2zzWkh+ag8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gcvXoDzoCkU0QueRlnrG4nX3LPL+JQIya2CuFYz8cbHyPIKeKaTJULAFdNfLG2a1A
	 ac5jC67cN7Qv+k8uqHjTv/W5f7jh3KsQ/zUbOfl0TDCyv9wuWEhLO/KYk0ms7Nj2pg
	 mGGVjFA/CKUdZtoyZZ/AXwczfQaoKM8Nev3M5ZUnknjA0kI2IXkmDZjWTGu1F2mYDJ
	 9kQv/mVpHnwGNiDBcXLpynyY6GdAQfXICLOjY7y1nh1hnS9tsxoJQZ8wFaCl4XJZNI
	 yQTZJ+NDwNGUPIo18J7r64DRSrHyOwDhsvubT1oc7jA9bZ5JNqMm8OZWCD77ECDsrz
	 euMO1u/KFD4mg==
Message-ID: <sashiko-outbox-178408@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] sched/topology: Avoid redundant percpu
 allocations and bitmap walks in build_sched_domains()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, kees@kernel.org, rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com, tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, vincent.guittot@linaro.org, bp@alien8.de, jpoimboe@kernel.org, tony.luck@intel.com, david@kernel.org, mingo@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com, ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com, mhocko@suse.com, vinicius.gomes@intel.com, vbabka@kernel.org, peterz@infradead.org, surenb@google.com, hpa@zytor.com, x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com, kexec@lists.infradead.org, pratyush@kernel.org, dave.hansen@linux.intel.com, rostedt@goodmis.org, gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de, graf@amazon.com, liam@infradead.org, ridong.chen@linux.dev, blum@kernel.org, longman@redhat.com, bsegall@google.com
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
In-Reply-To: <20261019011446.834487-8-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
 <20261019011446.834487-8-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 01:15:58 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CFCB1C0005
X-Stat-Signature: 3kq8mdw3fyof8q1jd334u1g4ua9pwh1q
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792458962-165568
X-HE-Meta: U2FsdGVkX1+mjIysQ/nJ42spxjvxDSiGIOHr5Y+fejS+BxVFg7F5MlAYc/rIiZSo2fiJlSQvgNRi7jbfKFsxU/1/VwJNY2UXHQbstyzNS0OrFbHPk2WvWF1TgeIGiEr6S7wxddsbP4j+vt3oXSqZF/ZqCzMj7XLh6XFVGIvrp4KvT8AigdL7z+QFKvwN10W1T5ooGyW7Nd6SbqCmVGcwSV6PtR+iYJ/tK0knGmtizIrMKcNsFJxicc5QrLyc3XExpcU+RX5jIc0SZ74qoSPMXt+XXu0W8uo8W97G9OOQSMWlQLfHz4fH/B7O36lk/bN/XAAkNhAYFj/UI7NXr6uWkJxZ8m4/OX3J/pQuQuPP8xtw8VqyyRGmhbKILOdrOM1PvZaEJNq5fZfbmLP+pgVjJghpfGVeg+09RS4gTNzICH3WDbnsa9kJ6/XHQbz/CO7mK1LC4c1i5E+avT+5Kndlb6JPmzLkYscTSMvz9Jg8KAe78VqYlMRyga7HGLgr/EhdTqtqxe2tJ+KbwizalevRbBYA2V7/CysAOS5IvPwxbr+4+5K21rNOL/49EFrvNpIPs6llsDoqbXVKeXE4XrKAJP0gq74s/sCG0pkwqsUgRP2isVEAyHdf2PrisNtF+yof92bhB4xk/uLLVH91IfhzaGVGW27f9SI5PjO3wA+iUqyzstCjbvYB6RgPnS0XpMezKM/sltMvu83VlExEUFBeowfKMZe99TMjONBAHdR1m0B5Hg6yKS8+dNSopEbsulYfvmakBfZejQPtHHXHX4eewzN9kusSu6A1DRbR/btAp0pflkNvIIZAnig1WVJmmva1rwTwUNOgjMCpRpmYBUEt8Mjh5LONMX5pfLi8TuXhaSa+CIBQ79E4/k1hvkPWxNAq4cxYhBTreUkg1MUV5Vfbod+SnAJevgA0W3lyzazCX3DqPZC7xuR18zOzpq8pjPV4AOu1Gof32Qcs7CIQOje
 spJBJb1U
 lJcfd5SOe4J93eAlgUQr7Zufz/+kRyykHoUw1KuTUgYS2f4f0tUWaNK1TTisTzRV3SS3hoYN+9QDoWUKMIldggJLMWcaw/06q6RU1X37nHW8l8CEfiHhCqJ3fIP6p6QIncTzCzW0xNAPjiSjeQunYhbrDvks9G0zHsvX5Ry4sruuTESJ7dudDIcvWuIVYJEW/mT1XHKDHq9Y3wvawU6y9CGFM+10vLIZKA4aa6sztzYFHF9az3huCe5QnMkzSIbqbFi+vsa3mGwd8FH2eb5lRXZ2IjwvUiEU15M+jBifgB2ccfQWYE192w9hZi5D5ZiwFWo144z0SkSzkZ7dY8Dl740YkXZLw58NN+ddlNxAyGFhDAjBODCohD0MlHOsBeyV5aGjKSQ40lAOuMmgJHfAcwUm28uzL+29S3VSfzd8Rfil5Jur3B9RIXmtoBwZJrpIcZmq/nDc40ci3FYbNa5eBR15Hhtq+gq76LyO8sO967uTDIqFeKQHuGLalCScnwAN1oScQ/GhgfBTOSXgC1F+c0EqE3hFUlgV/ps3NdBW7rAw/tYyQ8ktEqBE75E6PLuMslAgfRhMhWsf2nkbfDQuUGp5c/7sacRLq4Hx+PgPfpDsvOEke8MvJUSF7iORwLjUuBahsrvP8hGLJygiYTRhkMRNk1WK6ES4tB1098Xymj+e++ik=
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
- [Medium] sched/topology: sched_update_llc_bytes() reuses llc_bytes outsid=
e cpus
--

commit d95533f0e2e71e5e08ee625a1ea2afb7ecbe1b86
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

sched/topology: Avoid redundant percpu allocations and bitmap walks in buil=
d_sched_domains()

This commit optimizes build_sched_domains() during CPU hotplug by tracking
uncovered CPUs during sched_group construction, reusing temporary per-CPU
pointer arrays across rebuilds, initializing sd->span_weight in sd_init(),
and reusing the first LLC sibling's computed llc_bytes in alloc_sd_llc()
and sched_update_llc_bytes().

> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index b5dec7f486b5c..33210fd9dc2c6 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -917,9 +917,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_m=
ap,
>  			top_llc =3D parent;
> =20
>  		if (top_llc->flags & SD_SHARE_LLC) {
> +			int first =3D cpumask_first(sched_domain_span(top_llc));
> +
>  			sd->llc_max =3D max_lid + 1;
>  			sd->llc_counts =3D p;
> -			sd->llc_bytes =3D get_effective_llc_bytes(i, top_llc);
> +			/* All CPUs in top_llc share the same LLC size and weight. */
> +			if (first < i)
> +				sd->llc_bytes =3D (*per_cpu_ptr(d->sd, first))->llc_bytes;
> +			else
> +				sd->llc_bytes =3D get_effective_llc_bytes(i, top_llc);
>  		} else {
>  			/* avoid memory leak */
>  			kfree(p);
> @@ -1018,12 +1024,20 @@ void sched_update_llc_bytes(const struct cpumask =
*cpus)
>  	 * own LLC domain to scale its share of the physical cache.
>  	 */
>  	for_each_cpu(i, cpus) {
> +		int first;
> +
>  		sdp =3D rcu_dereference_sched_domain(per_cpu(sd_llc, i));
>  		if (!sdp)
>  			continue;
> =20
>  		sd =3D rcu_dereference_sched_domain(cpu_rq(i)->sd);
> -		if (sd)
> +		if (!sd)
> +			continue;
> +
> +		first =3D cpumask_first(sched_domain_span(sdp));
> +		if (first < i)
> +			sd->llc_bytes =3D rcu_dereference_sched_domain(cpu_rq(first)->sd)->ll=
c_bytes;
> +		else
>  			sd->llc_bytes =3D get_effective_llc_bytes(i, sdp);
>  	}

[Severity: Medium]
Can sched_update_llc_bytes() and alloc_sd_llc() copy an un-updated or
mismatched llc_bytes value when the topmost SD_SHARE_LLC domain spans
multiple cacheinfo LLC leaves?

When cacheinfo_cpu_online() or cacheinfo_cpu_pre_down() calls
sched_update_llc_bytes(cpus), cpus is a single cacheinfo leaf's
&llc->shared_cpu_map, whereas sdp (and top_llc in alloc_sd_llc()) is the
highest sched_domain with SD_SHARE_LLC, whose span comes from
cpu_coregroup_mask().

On topologies where cpu_coregroup_mask() is wider than the cacheinfo LLC
leaf's shared_cpu_map, sched_domain_span(sdp) spans multiple physical
cacheinfo LLCs:

1. On ARM64/RISC-V systems with clusters and per-core L2 caches (no shared
   L3), cpu_coregroup_mask() in drivers/base/arch_topology.c extends the MC
   domain to cluster_sibling:

   if (IS_ENABLED(CONFIG_SCHED_CLUSTER) &&
       cpumask_subset(core_mask, &cpu_topology[cpu].cluster_sibling))
           core_mask =3D &cpu_topology[cpu].cluster_sibling;

2. On AMD/Hygon x86 systems without an L3 cache, legacy_set_llc() in
   arch/x86/kernel/cpu/topology_amd.c sets llc_id to the die ID while
   get_cpu_cacheinfo_llc() returns the per-core L2 cache leaf:

   /* If none of the parsers set LLC ID then use the die ID for it. */
   if (tscan->c->topo.llc_id =3D=3D BAD_APICID)
           tscan->c->topo.llc_id =3D apicid >> tscan->dom_shifts[TOPO_CORE_=
DOMAIN];

When sched_update_llc_bytes(cpus) is invoked for any core other than the
first core in sdp, first =3D cpumask_first(sched_domain_span(sdp)) is not in
cpus, so cpu_rq(first)->sd->llc_bytes is not updated by the
for_each_cpu(i, cpus) loop. Because first < i holds for every CPU i in cpus,
get_effective_llc_bytes() is skipped and sd->llc_bytes copies the un-updated
value from cpu_rq(first)->sd.

Similarly, in alloc_sd_llc(), copying (*per_cpu_ptr(d->sd, first))->llc_byt=
es
across all CPUs in top_llc reuses the first CPU's L2 cache calculation even
when other cores in top_llc have different cacheinfo shared_cpu_map weights
(for example, partially online SMT siblings) or cache sizes, which can cause
exceed_llc_capacity() in kernel/sched/fair.c to use the wrong capacity.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019011446.8344=
87-1-pasha.tatashin@soleen.com?part=3D7

