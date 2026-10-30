Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F1D9606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4mn8dWb
Received: by kanga.kvack.org (Postfix)
	id 5E0EC6B05BB; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B80D6B05BC; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7186B05BD; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12C356B05BB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:05:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1E46160522
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:05 +0000 (UTC)
X-FDA: 85377800970.28.27B8372
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D2ED180003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:05:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4mn8dWb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329504;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0IZ6u1jq1SjDh7kHD4p8VDLm+x3Q5lnbjJd9AFeJ1Y=;
	b=o32froLtYkN/DoyjafLHE08IalkAewZocClay0v85AP6Pn2yslQoAhhPj7yuhJgZdw810A
	jJqRGtiygYpdyJu7BZYOWHTffd2nHppNoc4oZbp3X+9aHpcHMOnJ5Bw7588pqnJLOIjkMO
	FHK6744O0+ljaq65l6iaegGR6pln2OI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4mn8dWb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329504;
	b=24CxEX2JkSmKa+IK2WiwhWYj1SwWWmJVk93oPADF43Are0rA3aftWyFh0ndDTm5G4/6CP5
	InmOAExVEs6Q2jHssAV7n5vR2RKoXTt3OVhxMDOGgualNSANVn0FTONYaUtAj10Le50/Yy
	czZV+gjLuH24Q271tpCvqvomvngcebk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3841444033;
	Fri, 30 Oct 2026 03:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021001F000C1;
	Fri, 30 Oct 2026 03:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793329503;
	bh=U0IZ6u1jq1SjDh7kHD4p8VDLm+x3Q5lnbjJd9AFeJ1Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k4mn8dWb8dnZ3XIZLdwz8fUbrG3jJzIMMc6xhYvd0ZGhxu5cM6X8N/JicAEOV6mjg
	 UrcE2Oz5D4bCAXCODY9rWKPOUPPDv8pzQh5fO6yhMjKnDlXO7NbyQ1SJa8DgJRDa/r
	 cht7iq/BWisFoczOn0rMEA/FrVGv4w28qItaTfIhsKO40wvFk8D//v0N5bfebi/oAt
	 XCz/b8MU3knV/MGmXG8rFhkCJ+gQgn4dVmtCol1xWuw0c9g/24N8ihYtvPrv5Qcav9
	 MVhBkC1thYxlKHQMN/4EaBq2uPFElunKhP5WQw2SoFFsq1BvJW/V39tseQnFvmrxXv
	 rzbCNKAAf01DQ==
Message-ID: <sashiko-outbox-190204@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 10/17] sched/cache: Pick the source rq/group with
 the highest affinity gain
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
In-Reply-To: <20261029022036.4002331-11-wujianyong@hygon.cn>
References: <20261029022036.4002331-1-wujianyong@hygon.cn>
 <20261029022036.4002331-11-wujianyong@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 03:05:01 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D2ED180003
X-Stat-Signature: 5pdqtaqzqf7dw5sris5nc6drhqo7xbiy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793329504-786167
X-HE-Meta: U2FsdGVkX198dFCKUC3C0aOvrBucMScLEKLimKfcrhXI1tgmUrhi/iBymjn0d0FhJTSXevZV1df7Nc1zuq2L+t3ao/V9dF2ZAfp7l9n1DMOQnsDjyoqpV9erST0BwF+nu8wdMgDGzgpaeTK0OrY0DtPbVzWLgIgdzThKnCh444eCAbNkuCTHrK5pJsFRlwz9a1y7hJIpibzCUa5mR/lC+2ZfkJp4Sf26RzH2IWHe4svCOnpPk/dZr2mpR00C/lVud1BEtI46hO/Jkfkg8jT1NLn3NyQyg07aE3U2jx1Hfrhc77CKsWVfy9XJ26UIF28dj0O43Zr9NiasklzZBL4NfJmfT5rA3JhPdtCV0EPnicDtISqi2c5S7jQDgRVD0foeH7OEuQZWwMUtMRQ8HEyWWIPcgF3djbwvgNfNIwfLJZ4nhQIrSquhC7JIp7pEnotPKXRYiqQCR0wHKd460fPcFnRKN6QhNNPvUXryCoVvxh3fsquOwzyYBo3Xlib13SpVKYbNO383INKlGmeuu3ret196ILWwnzeOqdRpbut0J3Wfg905ZtTkp9Fw7xrIDefKh8fqy1BjFu8o0CpNFRV5ZKZgD2ucFN/nucbva2+ag4FoF4kPB/rCJ8SMWuLOF1HoaM0P6G2ySIHRYiKwI6OvMDW9mLtKoGtwWMqhmW55wafy6FDsyroHEB46vrTJHvVroZJlu/apXFzi92btqQGl/PJNctvVIsdbK7dCJvMc4ZIz1JrJCEU6djnacuCbl37E/J67qtiir0Ehl/k0cEr1WjppK94PAmiGSeQ2jE0KnlEh6jP/grfekKR+CO/j/NJ3z7pHHptl4ED2cCTFDl7cGgmnfWLnQLuK8XTP//ON50qYugTLQoY3e4q6jNV9WHs3DkdNleEkUjiScHPypPKisxwDDR9hys5uMKAufPG8hPylxk7za/XXREFYzXFgNTA3VCirAaEyMKdOi2UJL/i
 d3rbUcU7
 Cl2wFYc0oMwf4YbiaHmbQ6PB5ePYeWJAqocQOpzcnZdJp6yJS4VOXubGHgnXXYaKBFUElIS3kNXPjCoSdu4RJ0Z/H0fpa3UqtPPgRCs4ks/exoJOw5oE3MPXRvTt3GtOgyLmVcHq4/64DLb+M28noO2IT93z90Nca3ad1V/Lf2Zj1KKOfu+/JooLb2f6M0Ntb2Gu6tDQHZ2REJVAHLXesYoPCvxb6j4/UfGq3st1UHjixR1dL3Spxrjpe7h6ToPdKFySldjNHhzXfMil67Os6R4fbDY9SnnXxbMijqgJhHRHYTTRz6Lkaxnw3rYcZ2G5MoqYcRa0eHMkVaxQUvHhUIX95/NGClzq1hYWUvreU2gGBD4sOgas+YXlQaZ7ZJZdLOOqf6M382LDGuXSmsV45SMeJneoCGncWharkWvcmrMEMsWMczUAznMXNw5EI0zRwjUNHAdKNyy6w98fecuHB689yYQYO4tsZA8bh8PADFLcTgo+1KmjFcStE51iF1CO4ee2TgAHqf22PRTVJnAwDbPxY8ZXQff8lHT/psGDE2uWrrWnIdFBL4ntVMub9hiFyN60U
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
- [High] sched/fair: unchecked sd_rq->llc_max in calc_affinity_llc_score()
--

commit 706d6b3fdde74f4bc3582ab9ff3b3880647fbae9
Author: Jianyong Wu <wujianyong@hygon.cn>

sched/cache: Pick the source rq/group with the highest affinity gain

This commit updates cache-aware source group and runqueue selection to score
candidates using the affinity gain calculation when llc_aggr_tolerance is
greater than 1, while retaining the destination LLC task count metric when
the tolerance is 1.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index eb08ae66f4650..e9a803433b161 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

[ ... ]

> @@ -12248,6 +12250,12 @@ static inline void update_sg_lb_stats(struct lb_=
env *env,
>  {
>  	int i, nr_running, local_group, sd_flags =3D env->sd->flags;
>  	bool balancing_at_rd =3D !env->sd->parent;
> +#ifdef CONFIG_SCHED_CACHE
> +	int last_node =3D -1, node_num =3D 0, llc_max;
> +	int *cache_data, *affi;
> +
> +	lb_affi_scratch(&cache_data, &affi, &llc_max);
> +#endif
> =20
>  	memset(sgs, 0, sizeof(*sgs));
> =20
> @@ -12276,8 +12284,22 @@ static inline void update_sg_lb_stats(struct lb_=
env *env,
>  			dst_llc =3D llc_id(env->dst_cpu);
>  			if (llc_id(i) !=3D dst_llc) {
>  				sd_tmp =3D rcu_dereference_all(rq->sd);
> -				if (sd_tmp && (unsigned int)dst_llc < sd_tmp->llc_max)
> -					sgs->nr_pref_dst_llc +=3D sd_tmp->llc_counts[dst_llc];
> +				if (sd_tmp && (unsigned int)dst_llc < sd_tmp->llc_max) {
> +					/*
> +					 * At tolerance 1, aggregation is limited to
> +					 * workloads that fit in one LLC. Only count
> +					 * tasks preferring dst_llc, rather than scoring
> +					 * intermediate moves along the affinity order.
> +					 * Migration checks still enforce LLC headroom.
> +					 */
> +					if (env->tol > 1)
> +						sgs->affinity_score +=3D
> +						calc_affinity_score(env->sd, rq, i, env->dst_cpu,
> +								    cache_data, affi, &last_node,
> +								    &node_num, llc_max);
> +					else
> +						sgs->affinity_score +=3D sd_tmp->llc_counts[dst_llc];
> +				}
>  			}
>  		}
>  #endif

[Severity: High]
Can this cause an out-of-bounds read or NULL pointer dereference on
sd_rq->llc_counts[] in calc_affinity_llc_score() (and similarly at the call
site in sched_balance_find_src_rq())?

In update_sg_lb_stats() and sched_balance_find_src_rq(), lb_affi_scratch()
sets llc_max from this_rq()->sd->llc_max:

kernel/sched/fair.c:lb_affi_scratch() {
	struct sched_domain *sd =3D rcu_dereference_all(this_rq()->sd);

	*ids =3D sd ? sd->affi_ids : NULL;
	*weights =3D sd ? sd->affi_weights : NULL;
	*llc_max =3D sd ? sd->llc_max : 0;
}

When env->tol > 1, the callers check dst_llc < sd_tmp->llc_max and pass
llc_max into calc_affinity_score(). That function then re-reads rq->sd into
sd_rq and, for non-NUMA domains, calls calc_affinity_llc_score():

kernel/sched/fair.c:calc_affinity_llc_score() {
	...
	if (src_llc !=3D *last_llc) {
		*last_llc =3D src_llc;
		*num =3D get_affi_llcs(src_llc, dst_llc, affi_llc, llc_max);
	}

	for (int i =3D 0; i < *num; i++) {
		if ((unsigned int)affi_llc[i] < llc_max)
			score +=3D sd_rq->llc_counts[affi_llc[i]];
	}
	...
}

Unlike calc_affinity_numa_score(), which checks if (llc >=3D sd->llc_max)
before indexing sd->llc_counts[llc], calc_affinity_llc_score() only checks
affi_llc[i] < llc_max (the scratch capacity from this_rq()->sd->llc_max)
without checking against sd_rq->llc_max.

Since sd_rq->llc_counts is allocated with sd_rq->llc_max elements in
alloc_sd_llc() (and annotated with __counted_by_ptr(llc_max)),
this_rq()->sd->llc_max can exceed sd_rq->llc_max:

1. During _nohz_idle_balance(), the ILB CPU (this_rq()) in a cpuset partiti=
on
   rebuilt after hotplugging a new LLC (larger max_lid) can balance an idle
   CPU in an unchanged cpuset partition whose CPUs retained their older
   rq->sd (smaller sd_rq->llc_max), after rebuild_llc_node_map() has already
   published the new LLC ID in llc_to_node_map.

2. During concurrent build_sched_domains(), cpu_attach_domain() attaches new
   domains with a larger max_lid + 1 one CPU at a time while load balancing
   can already run on an updated CPU.

3. Because calc_affinity_score() performs a second rcu_dereference_all(rq->=
sd)
   without re-checking sd_rq->llc_max, a concurrent domain update where
   alloc_sd_llc() failed or SD_SHARE_LLC is absent leaves sd_rq->llc_max =
=3D=3D 0
   and sd_rq->llc_counts =3D=3D NULL.

Should calc_affinity_llc_score() check (unsigned int)affi_llc[i] <
sd_rq->llc_max (or pass sd_tmp directly instead of re-reading rq->sd and
bound against min(llc_max, sd_rq->llc_max)) before indexing
sd_rq->llc_counts[]?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029022036.4002=
331-1-wujianyong@hygon.cn?part=3D10

