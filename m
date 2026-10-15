Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583EFCCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E366B0096; Thu, 15 Oct 2026 19:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0775B6B0098; Thu, 15 Oct 2026 19:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE9B6B0099; Thu, 15 Oct 2026 19:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C14496B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:17:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F59216026E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:17:54 +0000 (UTC)
X-FDA: 85326425268.08.1BFB581
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4CE7100007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:17:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JIhFkpTb;
	spf=pass (imf05.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792106272;
	b=vM4An3mhgqfm4k2uhlyBLb9BrTWF8a1/DzYnln3oJduC8Ry48doisiN++HkzF4nIMpdZks
	OOAJWmBSMVCeb1EKF6dkTk1Og7b0Fzxd0IoeZ24iXdc2mu6uPxlA53CuULyiSpoEYOmX65
	1NOn2dD915/TZx5xV20Hs++t91757AM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JIhFkpTb;
	spf=pass (imf05.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792106272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dU4UV7b10jQWXzZAx1LzF2HZTCcoK87Yy3TYJNTLgy0=;
	b=1a1ystVXT/jDA+EyY1xRLzKRejrnp7E9jRZ7rDY/31p2DMjI1u3+DMoRTeDj+REkqWc0oc
	JNaBNsvH8QQIneSH1kVKCJSL5HG2jheDr0Xad1xgvwxiwS/BrueCTULRgUYnfrmXRqK597
	J2U0DVIYAZUSKRi/hTfupfJ4H6W8YqY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792106272; x=1823642272;
  h=message-id:subject:from:to:date:in-reply-to:references:
   content-transfer-encoding:mime-version;
  bh=Iich2VyA9Yl56RfAzD+pgFuU2K921AKcJLk7Up8k2OQ=;
  b=JIhFkpTb0AdC8QP7jU5Fsu7GpYJ8UbvBX49SxVa/nlbpcPvXpG2DCCyK
   9NM44/Y8ToReSFahy/dkhDfMrPaLDruOR4Umz4/LDhkrK/Te0aXZTbXbT
   z3/ITogwGlQHGeG9PYrRyPHvhBAeK+rOjkHSZidmBnEExSeD9YM1ojCRU
   93BMaEiXi4+ZQvVwhrzHO16MfKlRo9JqcmyL88AMF11h1bR/kOQpQPLjh
   lLizr3Ryf8PWQjL+ZH/NR4VYHDE8X7PgqsPDVqeimpgwn4dljzBrcms3C
   rXRDrQ+NbRoAjn1D7GP4Z0OsN/k+YGDxb+eHOlI74rOeUpM+aXxwHnF7G
   g==;
X-CSE-ConnectionGUID: Z5B9OSPVTXyLTJl5+R1Jiw==
X-CSE-MsgGUID: z20LWbJgS3C5O7wlbOno9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="781051"
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="781051"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 16:17:51 -0700
X-CSE-ConnectionGUID: QPDXIi4JQEuXWbbkvfN5YQ==
X-CSE-MsgGUID: KujZTx+hRAChXpirRYufLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,160,1787036400"; 
   d="scan'208";a="1904693"
Received: from unknown (HELO [10.241.242.105]) ([10.241.242.105])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 16:17:49 -0700
Message-ID: <1ec1aab8eabdad173ddef7483a940bfa3f6c3238.camel@linux.intel.com>
Subject: Re: [PATCH v1 7/8] sched/topology: Avoid redundant percpu
 allocations and bitmap walks in build_sched_domains()
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, kees@kernel.org, 
	rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com,
 tglx@kernel.org, 	vschneid@redhat.com, kprateek.nayak@amd.com,
 vincent.guittot@linaro.org, 	bp@alien8.de, thorsten.blum@linux.dev,
 cgroups@vger.kernel.org, 	tony.luck@intel.com, david@kernel.org,
 mingo@redhat.com, akpm@linux-foundation.org, 	linux-mm@kvack.org,
 seanjc@google.com, ljs@kernel.org, zhangguopeng@kylinos.cn, 
	dietmar.eggemann@arm.com, mhocko@suse.com, vinicius.gomes@intel.com,
 tj@kernel.org, 	vbabka@kernel.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, 	surenb@google.com, hpa@zytor.com, x86@kernel.org,
 dmatlack@google.com, 	kexec@lists.infradead.org, pratyush@kernel.org,
 dave.hansen@linux.intel.com, 	rostedt@goodmis.org, gmonaco@redhat.com,
 jgross@suse.com, mgorman@suse.de, 	graf@amazon.com,
 linux-edac@vger.kernel.org, liam@infradead.org, 	ridong.chen@linux.dev,
 longman@redhat.com, bsegall@google.com
Date: Thu, 15 Oct 2026 16:17:48 -0700
In-Reply-To: <20261015153331.1872641-8-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
	 <20261015153331.1872641-8-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 (3.58.1-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4CE7100007
X-Rspam-User: 
X-Stat-Signature: hhrt9mtubjeuutfqw7h9ngp8qfb71pua
X-HE-Tag: 1792106271-434951
X-HE-Meta: U2FsdGVkX1+95seqmvoBYb1cBDYuwwtNmNaGFEBha0ZObKHeChh86aYfV34ls+aAylMB8Wv3aAPblKWzrFgC0i0mjeicwl41vPjk0UCv4xcV4jA+2r311vkMTmiLNW2PTW6iK9p2r1ZXgDQnJTbzsJIIPmk/SUVY15BCmrsCGCUsIBatni9TmvJMwJX6kr7ZQ11Tvb8uBJ9kmFfYeHcMmXZvBgKZThxmkN8LHms1mTFHOiaIcQxWEBQK7DT3Rg2LemcQCo/+PrHIgTmPHFHvSBFyjZiKJAtKCpfeolt7OSTWu8gdL8Od/Af/XmKwKS/aBgxuqgBKSnfCMhtAVHeqiuCJboZAXHbkyyAh1o+saJcAIfYnHp4bL7ZZNL4+drybfRYlfQEAXE5waBJ87b6KsJAQfniP4ZC5FFqyWFUXaoBrm5ZicC0rSvolgIlP383OnPgF22w+qfsmUQxsCjEG9a2oMp7FIvpnuT0iRTy2balsbY9h+JQWQsUKpR2r2CCoWQH8tmKqGSliHkAqIsOEAAiDk+3D3VgEfymxfLUTfRxpYLtATqxP0ocG1ijSXdSUY9/CXfmXtFgXCKEeBLJ+jvTIR1Vnb2BVa9hmEnWvABR6MCFXYi5rF+VZaqaAixs4/m3SCVuPV8kAiEdC+l9B3MsVUKSoDoM7UH4nj/1Eu1kjduzO3XwqB9RkbFQLZiW8Xs148R1gsTFkqJXxyTC0LFbPCUWcBnIOF9uJ1Y6mabs2/B7OQSAD3BCxYDP2+EuRRmhGnwvpwf6ltrNUSWcTNMgGTbLy35XQmJEMYbYo9ROPrYmQO+/iyJKDexREy5vn78bgvQpH86k7+pYqJiAkevspEFsMp5PmMcBrf9Kw4ULP/JW4MT2Emc1YSflTaSuTbYDoHkzX16F0LQHNAlbjusGpKK1PME0WnmzvqgSsOG8bXFcsIG/S7NOLXEKHgEqhxrg265uV/hmmMcIkwLz
 cnoCrQa1
 YYQ6vbZF0R40kXpzQDJZlOlWbC8vA+W0v2ltUf4mgzP43Xl9OEN6GSBJ6ReFHqHKPhsIrwExiDkcSZpg1zMpQWQ+3bzNpaiB3CV/wIylhYZMowjmMNzxLrKc4v7ymbegq/9knizBJ+d1S+R2ZWYWZcpHLI8a8K1N7dviWr9HC1ePrdbDEJxQjcScyFx+/Vy0Qs+jzVQMF1JT7znLgTGmIrkvUmdHaK9kYWo3+p0/2xpFlz3PTGH3NwBCH7Z+THQdbJzcV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-15 at 11:33 -0400, Pasha Tatashin wrote:
> During CPU hotplug, build_sched_domains() is invoked on every CPU
> activation and deactivation. Profiling build_sched_domains() on a
> 480-CPU Intel Xeon 6985P-C and a 512-CPU AMD EPYC 9B45 shows several
> sources of avoidable O(N^2) and O(N) work per step:
>=20
> 1. build_sched_groups() and build_overlap_sched_groups() iterate over
>    every bit of sched_domain_span(sd) via for_each_cpu_wrap(i, span, cpu)
>    and check cpumask_test_cpu(i, covered) one CPU at a time, even after
>    entire child groups (e.g., 120-CPU NUMA nodes) have been added to
>    covered. Instead, track the remaining uncovered CPUs
>    (cpumask_copy(uncovered, span)), clear each built group's span with
>    cpumask_andnot(), and advance directly to the next uncovered CPU.
>=20
> 2. __visit_domain_allocation_hell() and __free_domain_allocs() allocate
>    and free 3 * nr_levels + 2 temporary per-CPU pointer arrays via
>    alloc_percpu() / free_percpu() on every domain rebuild. Reuse the
>    per-CPU pointer arrays across domain rebuilds under
>    sched_domains_mutex, clearing entries in __free_domain_allocs() and
>    only freeing the topology-level arrays when sched_domain_topology is
>    replaced in sched_init_numa() / sched_reset_numa().

sched_domains_mutex does not protect the free:

[snip]

>  #ifdef CONFIG_NUMA
> +static void __sdt_free_percpu(void)
> +{
> +	struct sched_domain_topology_level *tl;
> +
> +	for_each_sd_topology(tl) {
> +		struct sd_data *sdd =3D &tl->data;
> +

sched_init_numa() and sched_reset_numa() are called from
sched_update_numa(), which runs from sched_cpu_activate() and
sched_cpu_deactivate() without sched_domains_mutex. The free is safe
because every domain builder holds at least cpus_read_lock(), and
sched_update_numa() runs under the hotplug write lock.=C2=A0

Please fix the changelog and add lockdep_assert_cpus_held()
in __sdt_free_percpu(), so a future caller cannot break this without a warn=
ing.



> +		free_percpu(sdd->sd);
> +		sdd->sd =3D NULL;
> +		free_percpu(sdd->sg);
> +		sdd->sg =3D NULL;
> +		free_percpu(sdd->sgc);
> +		sdd->sgc =3D NULL;
> +	}
> +}
> +
>  static int cpu_numa_flags(void)
>  {
>  	return SD_NUMA;
> @@ -2449,6 +2483,7 @@ void sched_init_numa(int offline_node)
>  	/*
>  	 * Copy the default topology bits..
>  	 */
> +	__sdt_free_percpu();
>  	for (i =3D 0; sched_domain_topology[i].mask; i++)
>  		tl[i] =3D sched_domain_topology[i];
> =20
> @@ -2507,6 +2542,7 @@ static void sched_reset_numa(void)
>  		kfree(masks);
>  	}
>  	if (sched_domain_topology_saved) {
> +		__sdt_free_percpu();
>  		kfree(sched_domain_topology);
>  		sched_domain_topology =3D sched_domain_topology_saved;
>  		sched_domain_topology_saved =3D NULL;
> @@ -2708,17 +2744,23 @@ static int __sdt_alloc(const struct cpumask *cpu_=
map)
>  	for_each_sd_topology(tl) {
>  		struct sd_data *sdd =3D &tl->data;
> =20
> -		sdd->sd =3D alloc_percpu(struct sched_domain *);
> -		if (!sdd->sd)
> -			return -ENOMEM;
> +		if (!sdd->sd) {
> +			sdd->sd =3D alloc_percpu(struct sched_domain *);
> +			if (!sdd->sd)
> +				return -ENOMEM;
> +		}
> =20
> -		sdd->sg =3D alloc_percpu(struct sched_group *);
> -		if (!sdd->sg)
> -			return -ENOMEM;
> +		if (!sdd->sg) {
> +			sdd->sg =3D alloc_percpu(struct sched_group *);
> +			if (!sdd->sg)
> +				return -ENOMEM;
> +		}
> =20
> -		sdd->sgc =3D alloc_percpu(struct sched_group_capacity *);
> -		if (!sdd->sgc)
> -			return -ENOMEM;
> +		if (!sdd->sgc) {
> +			sdd->sgc =3D alloc_percpu(struct sched_group_capacity *);
> +			if (!sdd->sgc)
> +				return -ENOMEM;
> +		}
> =20

Keeping the arrays also means every slot must be NULL when a build=20
starts. Patch 5 depends on that: get_group(),=20
init_overlap_sched_group() and init_sched_domain_shared() treat a NULL=20
slot as "not allocated yet", and the overlap fast path treats=20
"sgc->ref > 0" as "set up in this build". An old pointer would pass
these checks and be used without a warning.

The rule holds today, but nothing says so. It also depends on builds
never filling a slot outside cpu_map, because the clearing loops only
visit cpu_map. Please write this down and check it, for example in
__sdt_alloc():


>  		for_each_cpu(j, cpu_map) {
>  			struct sched_domain *sd;

Maybe add

        /*
         * The slot arrays are kept between builds. Every slot for a CPU
         * in cpu_map must be NULL here; lazy allocation treats NULL as
         * "not allocated in this build". claim_allocations() and
         * __sdt_free()/__sds_free() clear the slots, but only for
         * cpu_map, so a build must not fill slots outside cpu_map.
         */
                for_each_cpu(j, cpu_map) {
                        struct sched_domain *sd;

                        WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, j) ||
                                     *per_cpu_ptr(sdd->sg, j) ||
                                     *per_cpu_ptr(sdd->sgc, j));



> @@ -2748,30 +2790,36 @@ static void __sdt_free(const struct cpumask *cpu_=
map)
> =20
>  			if (sdd->sd) {
>  				sd =3D *per_cpu_ptr(sdd->sd, j);
> -				if (sd && (sd->flags & SD_NUMA))
> -					free_sched_groups(sd->groups, 0);
> -				kfree(*per_cpu_ptr(sdd->sd, j));
> +				if (sd) {
> +					if (sd->flags & SD_NUMA)
> +						free_sched_groups(sd->groups, 0);
> +					kfree(sd);
> +					*per_cpu_ptr(sdd->sd, j) =3D NULL;
> +				}
>  			}
> =20
> -			if (sdd->sg)
> +			if (sdd->sg) {
>  				kfree(*per_cpu_ptr(sdd->sg, j));
> -			if (sdd->sgc)
> +				*per_cpu_ptr(sdd->sg, j) =3D NULL;
> +			}
> +			if (sdd->sgc) {
>  				kfree(*per_cpu_ptr(sdd->sgc, j));
> +				*per_cpu_ptr(sdd->sgc, j) =3D NULL;
> +			}
>  		}
> -		free_percpu(sdd->sd);
> -		sdd->sd =3D NULL;
> -		free_percpu(sdd->sg);
> -		sdd->sg =3D NULL;
> -		free_percpu(sdd->sgc);
> -		sdd->sgc =3D NULL;
>  	}
>  }
> =20
> +static struct sched_domain_shared * __percpu *sched_domains_sds;
> +
>  static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map)
>  {

and maybe similar check=20

        for_each_cpu(j, cpu_map)
                WARN_ON_ONCE(*per_cpu_ptr(d->sds, j));

> -	d->sds =3D alloc_percpu(struct sched_domain_shared *);
> -	if (!d->sds)
> -		return -ENOMEM;
> +	if (!sched_domains_sds) {
> +		sched_domains_sds =3D alloc_percpu(struct sched_domain_shared *);
> +		if (!sched_domains_sds)
> +			return -ENOMEM;
> +	}
> +	d->sds =3D sched_domains_sds;
> =20
>  	return 0;
>  }


Thanks.

Tim

