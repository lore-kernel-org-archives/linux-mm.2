Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D774CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 14:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA4C6B0088; Sun, 18 Oct 2026 10:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DE56B008C; Sun, 18 Oct 2026 10:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B8E6B0092; Sun, 18 Oct 2026 10:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 085836B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 10:45:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCE66C04CC
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:45:55 +0000 (UTC)
X-FDA: 85336021470.11.FF26A47
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13574120008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:45:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EOtHnJ2X;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792334754;
	b=FfwnXlc8exw8pHCUXg9F6Ceds5hX0PhPQahwpKgqeKE4pYeSyXh2nfiI3N2qnSyfjGmFMz
	qTLPWP8KsHvbpN5gsEg0tpQTWWaK0d+anHQDQtZ2Hzm3h9iljFtSI3OP80io4JDckuW1o7
	+3OLQm+4zKQ7Vt55muFdXu4Ezv3T8QA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EOtHnJ2X;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792334754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFOddHII9QlG0Yo7oJ9Fyf6IJ70eJag/SjOu44LBvf8=;
	b=NXOy1YJ55XF2XO0ZPPi7r5BkOzef1z+tLsA1G6/jIArka6eIO8brZZaBq1Uri/V/sC2pRY
	3fUD4l1YDeN/VzQhoZZ2CyY/R57/bpdgyoLCPFGV0i0JSGGMYEyC8jIOIUTpSw3A+qzEjA
	NMKM8SzV8Y5CD4tBDpRGjODVJAbpDro=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5e519c39196so385480e0c.3
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 07:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792334753; x=1792939553; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vFOddHII9QlG0Yo7oJ9Fyf6IJ70eJag/SjOu44LBvf8=;
        b=EOtHnJ2XfdoK5Rm101WzWZJF26BcLAMC7cLfmwmonbYSXN9C6BQlzCBDQfi/faz/kX
         WLzhxbfPHMSy/5TIiE74zDMfwSvboUj8nH5ux7rxaVZ7XCKBBqvlqgZtE+UkdRNowWcD
         KIeKhP7PIPRZ4iUnsrHlUyI3Eep0JnsB90AViCzI7heD4+hd/fGtLFg+JZwmhfy+K0h9
         96XdYo52vh6cMmbPmdg4la8ohbCAoRBjG6xRmaN8A+RzMVdOOe+LQweOzgZZafAlNORd
         spRIaJr2unZEl2PeJHph2jYyOEasO+JsqSC/tVpMCBuvPmXmMjngZpxW2z6VMDdT+cy7
         Qu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792334753; x=1792939553;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vFOddHII9QlG0Yo7oJ9Fyf6IJ70eJag/SjOu44LBvf8=;
        b=Y1wZhYZ4o5/52lRfEnzAJMguot4mlZvkjliPXk29mmr7zbNFXBVobDE2OXxO+FYYuk
         x9J6QAxc5pwu0njExwynyFplJIyg+0/Ux0YHaW5cJ/vZIy6X8KHEMzfskU/VvNATAtbQ
         ZtH5B8I4K0strKPxKB2OOOyy6No2QQtYILdKERPUvOzrNZFyx2da3L6gp619MuOErNKG
         IjQK1IXWoDqgivGBPd5IR24qMDcOp3vwd+cKoxZoIa1DxeQrN+/JA5Fo1hH7SoXbj9wo
         eGwgO4vInkg8E2ZvQwPFJitWIEm+sAW1P8AXOjN4xMR+7K7cO9pwFQD7tpnySmiDYK3k
         4aXA==
X-Forwarded-Encrypted: i=1; AKwUvBzgVcTdGHRFaNMgOaSevoQ691KxTQkVDN/jvvnFAxdrEmidaOV2xApDvwHII2xCHsV/MWc2goOkFQ==@kvack.org
X-Gm-Message-State: AFq9FYIfJ7b+H3uCj4auIYlrfciDib7gbmeqM9xm0sdmpeDpHyWP2wZT
	qh4G69fjC48MY/njZ0MBRky7jM6u8cr3dy2xNUrc7ByZxmiBdVBtJCv7bzGez0u+5D8=
X-Gm-Gg: AYBFou1l1hzXQZjDfyOZ0hwOP6uGHK+u11aFCS6/5U3JY83NRJHF0KM7aygMzWzBDOt
	dPLFhORXo3Ju00bP2fLcdOsiebtbTyOt7iXAtC2AhSqLOPYTnKUeS7RVVsuQd2M8DER/UbIL5yY
	FD3LfrX/4dTVKJHr2TKwmek4n6tPaQ9LhFIovNn0Pi3R9Pkc89bsO1dF/RUlyaGLTdIT2mkQ1br
	y2zyqGo0I8mgGV1goFPSEIhPGufIv9rCW5/Y027e+2c/r8LY2XzeGCYYE2Kp80GVbSnwvNJMHsT
	Wb2BZHwxey0Yqw6ZyKmVuTKNj0lzPwpgvJwKBPeq5tfep8rs5QmPbtmWIAHfC3pYVYWVQhoMV7g
	3oJWev20BbAJNLOmInm7Mp8Z0sPTq4hzibY6l4d/PH9FP8q1JSL0ZMJORBjO8dfSR2u0wiWUs1y
	qbbPTjr+bdj1oryuhCF9/VOu+4/rFDcheieo/r1z+B02QCOX6QkFS4AgCNyv2c1NYtXYWXiIPBp
	z6GH2tD2wx/7XI79HalJpAsZIuUmUslaBp+l38893L8KuMowF+zuzANdVQiAdKkwT3S9N6ZX6Y=
X-Received: by 2002:a05:6122:548:b0:5ea:c6c1:8dd4 with SMTP id 71dfb90a1353d-5eac6c19257mr145098e0c.5.1792334752976;
        Sun, 18 Oct 2026 07:45:52 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eaca7cc59asm244808e0c.5.2026.10.18.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:45:52 -0700 (PDT)
Date: Sun, 18 Oct 2026 10:45:51 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kees@kernel.org,
	rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com,
	tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com,
	vincent.guittot@linaro.org, bp@alien8.de, thorsten.blum@linux.dev,
	cgroups@vger.kernel.org, tony.luck@intel.com, david@kernel.org,
	mingo@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
	seanjc@google.com, ljs@kernel.org, zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com, mhocko@suse.com, vinicius.gomes@intel.com,
	tj@kernel.org, vbabka@kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, surenb@google.com, hpa@zytor.com,
	x86@kernel.org, dmatlack@google.com, kexec@lists.infradead.org,
	pratyush@kernel.org, dave.hansen@linux.intel.com,
	rostedt@goodmis.org, gmonaco@redhat.com, jgross@suse.com,
	mgorman@suse.de, graf@amazon.com, linux-edac@vger.kernel.org,
	liam@infradead.org, ridong.chen@linux.dev, longman@redhat.com,
	bsegall@google.com
Subject: Re: [PATCH v1 7/8] sched/topology: Avoid redundant percpu
 allocations and bitmap walks in build_sched_domains()
Message-ID: <atTbn7WhHtK52vCi@google.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
 <20261015153331.1872641-8-pasha.tatashin@soleen.com>
 <1ec1aab8eabdad173ddef7483a940bfa3f6c3238.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ec1aab8eabdad173ddef7483a940bfa3f6c3238.camel@linux.intel.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 13574120008
X-Stat-Signature: ixox7g8z6xguzt8n9wdggn4czjicrwxh
X-HE-Tag: 1792334753-96030
X-HE-Meta: U2FsdGVkX1+R3vldUsbYZx1v/oXwPN8TeTJzzMAOa2LyWmUTWxFn15cSM8V8ARME9lo9usvwn7lMS73qFhg7U5B97Z5wehnULK2nlY1Xt5RsCCUREvZ+vdhHYRqpgAZ0YVS0z49kTnpfGIdRj1e/uoiBEvKDzXwQwcHJDjiU2t3BcQdHckfDTTNb1q0uzeNhVo9HCsW/nIgjJYCbC2I0fB9e16RB3pfUdD++qxJ+dsWTGbWeSTom/9Vv85OAN8GbVmZt/1NWcwe1fBNhC9dWay/sq5fd6pv7GuaXrQmfOOsn3lnPzbubva79PX+wIFTPR09n0xwYI55TIi6u+5ZcaxID2BNC/bIwT6lWdq7MLS3XUgK8mjvrTxJB4sVhnVEuxz9Is41jX1xQ6XU8fpDFbrq9j5IdgzV3nflBBvAI6L8/H+NmGwc0tYO4gVfWQCISkCI46SHnR4+Dt7rODsEI0MqLiMKMfh9XQ6gSvklwOJoGNc1vLIEbpi+H7/E3EU1z/JlswB4R+1c/BIpvrd8YjYKVigGeQPGsHGwjMZjGgazYY0EYdLdoMdCjPdHKf5ayF7DF2UiNfZ6daxWl3Rd9Ht3OVdkzjCdH2ymRt343WFHTMM2+Im5z2WXe3QaMIXBUFu1TnPgNyyM6ktUlNUPJ6PUgu+lbDPuYis0jNYSY/93hnwQgPDxZUIKmjtB4ACfzDIHnQ+ORXYyI0sH1bFh+w6CUAwMjvQIDbBe2TkOD/sQI5llq8IqxGCJhxJEXU7ELuQjdmWyFtN5/5bBK1rD/TMjcqnlLlpHb56dyNGJKsvcRseHg41zPIvzc2jIwKx1aFmbl+Wh4VqdxCtVr/1mkKTuijtzEma1i0FaB+tYJjBim4QYNOJHQCrNUTAhZi1orB6sft+usshpUpK/Dnocj8r7LttJiXk2NsOcqV+6Ppku2+tGPnvkCzTwu1FEdjnVE8ww4HP7Ptg7LO6Qju3b
 FmgRUcTU
 DhQS0KKSfSQ6YMeJn/6MO5kjGbuOeT2Xjxnq4wdsHRxfPT6fdEG2Wvj/WpK+alqDtbSAd1hEQM+xXHzEuBx2NSr2PCgMGp3vY4GrLLfzo+W5pm9KpzAKGNeeA4XDwkiZ7hGkqSBCvG1XeBNxZ4/FWlY4cumbE5fGx9sfOQdak4zpv+Gtgn+5RriNrrTpPhcv1Oc2uULqveFp1/PZoSFkgTfFLOHFPct4snfI8/rI+U/SL8CXxiZzoafnOq6ywUjCzOektA8ugPWgMIY8k74XO+tFTFtRk3YyxX0rABvXzqWbwl5N43GbYupeLo9qKI/rOKDxIDDOQYUoCmAImSEIXBsy9GNYaLcLsKHwZysi/dIOwg9ahGOYStvYRz/YdWQFg1F15TEv1ndv6ot5YTxdxw+lNIp8A1JpGqOVocUJA1bH21mE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-15 16:17, Tim Chen wrote:
> On Thu, 2026-10-15 at 11:33 -0400, Pasha Tatashin wrote:
> > During CPU hotplug, build_sched_domains() is invoked on every CPU
> > activation and deactivation. Profiling build_sched_domains() on a
> > 480-CPU Intel Xeon 6985P-C and a 512-CPU AMD EPYC 9B45 shows several
> > sources of avoidable O(N^2) and O(N) work per step:
> > 
> > 1. build_sched_groups() and build_overlap_sched_groups() iterate over
> >    every bit of sched_domain_span(sd) via for_each_cpu_wrap(i, span, cpu)
> >    and check cpumask_test_cpu(i, covered) one CPU at a time, even after
> >    entire child groups (e.g., 120-CPU NUMA nodes) have been added to
> >    covered. Instead, track the remaining uncovered CPUs
> >    (cpumask_copy(uncovered, span)), clear each built group's span with
> >    cpumask_andnot(), and advance directly to the next uncovered CPU.
> > 
> > 2. __visit_domain_allocation_hell() and __free_domain_allocs() allocate
> >    and free 3 * nr_levels + 2 temporary per-CPU pointer arrays via
> >    alloc_percpu() / free_percpu() on every domain rebuild. Reuse the
> >    per-CPU pointer arrays across domain rebuilds under
> >    sched_domains_mutex, clearing entries in __free_domain_allocs() and
> >    only freeing the topology-level arrays when sched_domain_topology is
> >    replaced in sched_init_numa() / sched_reset_numa().
> 
> sched_domains_mutex does not protect the free:
> 
> [snip]
> 
> >  #ifdef CONFIG_NUMA
> > +static void __sdt_free_percpu(void)
> > +{
> > +	struct sched_domain_topology_level *tl;
> > +
> > +	for_each_sd_topology(tl) {
> > +		struct sd_data *sdd = &tl->data;
> > +
> 
> sched_init_numa() and sched_reset_numa() are called from
> sched_update_numa(), which runs from sched_cpu_activate() and
> sched_cpu_deactivate() without sched_domains_mutex. The free is safe
> because every domain builder holds at least cpus_read_lock(), and
> sched_update_numa() runs under the hotplug write lock. 
> 
> Please fix the changelog and add lockdep_assert_cpus_held()
> in __sdt_free_percpu(), so a future caller cannot break this without a warning.

I will update the changelog to note that __sdt_free_percpu() is serialized 
against domain rebuilds by the CPU hotplug lock, and add
lockdep_assert_cpus_held() to __sdt_free_percpu().

> > +		free_percpu(sdd->sd);
> > +		sdd->sd = NULL;
> > +		free_percpu(sdd->sg);
> > +		sdd->sg = NULL;
> > +		free_percpu(sdd->sgc);
> > +		sdd->sgc = NULL;
> > +	}
> > +}
> > +
> >  static int cpu_numa_flags(void)
> >  {
> >  	return SD_NUMA;
> > @@ -2449,6 +2483,7 @@ void sched_init_numa(int offline_node)
> >  	/*
> >  	 * Copy the default topology bits..
> >  	 */
> > +	__sdt_free_percpu();
> >  	for (i = 0; sched_domain_topology[i].mask; i++)
> >  		tl[i] = sched_domain_topology[i];
> >  
> > @@ -2507,6 +2542,7 @@ static void sched_reset_numa(void)
> >  		kfree(masks);
> >  	}
> >  	if (sched_domain_topology_saved) {
> > +		__sdt_free_percpu();
> >  		kfree(sched_domain_topology);
> >  		sched_domain_topology = sched_domain_topology_saved;
> >  		sched_domain_topology_saved = NULL;
> > @@ -2708,17 +2744,23 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
> >  	for_each_sd_topology(tl) {
> >  		struct sd_data *sdd = &tl->data;
> >  
> > -		sdd->sd = alloc_percpu(struct sched_domain *);
> > -		if (!sdd->sd)
> > -			return -ENOMEM;
> > +		if (!sdd->sd) {
> > +			sdd->sd = alloc_percpu(struct sched_domain *);
> > +			if (!sdd->sd)
> > +				return -ENOMEM;
> > +		}
> >  
> > -		sdd->sg = alloc_percpu(struct sched_group *);
> > -		if (!sdd->sg)
> > -			return -ENOMEM;
> > +		if (!sdd->sg) {
> > +			sdd->sg = alloc_percpu(struct sched_group *);
> > +			if (!sdd->sg)
> > +				return -ENOMEM;
> > +		}
> >  
> > -		sdd->sgc = alloc_percpu(struct sched_group_capacity *);
> > -		if (!sdd->sgc)
> > -			return -ENOMEM;
> > +		if (!sdd->sgc) {
> > +			sdd->sgc = alloc_percpu(struct sched_group_capacity *);
> > +			if (!sdd->sgc)
> > +				return -ENOMEM;
> > +		}
> >  
> 
> Keeping the arrays also means every slot must be NULL when a build 
> starts. Patch 5 depends on that: get_group(), 
> init_overlap_sched_group() and init_sched_domain_shared() treat a NULL 
> slot as "not allocated yet", and the overlap fast path treats 
> "sgc->ref > 0" as "set up in this build". An old pointer would pass
> these checks and be used without a warning.
> 
> The rule holds today, but nothing says so. It also depends on builds
> never filling a slot outside cpu_map, because the clearing loops only
> visit cpu_map. Please write this down and check it, for example in
> __sdt_alloc():
> 
> 
> >  		for_each_cpu(j, cpu_map) {
> >  			struct sched_domain *sd;
> 
> Maybe add
> 
>         /*
>          * The slot arrays are kept between builds. Every slot for a CPU
>          * in cpu_map must be NULL here; lazy allocation treats NULL as
>          * "not allocated in this build". claim_allocations() and
>          * __sdt_free()/__sds_free() clear the slots, but only for
>          * cpu_map, so a build must not fill slots outside cpu_map.
>          */
>                 for_each_cpu(j, cpu_map) {
>                         struct sched_domain *sd;
> 
>                         WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, j) ||
>                                      *per_cpu_ptr(sdd->sg, j) ||
>                                      *per_cpu_ptr(sdd->sgc, j));
> 

Sure, I will add the comment, and WARN_ON_ONCE.

> > @@ -2748,30 +2790,36 @@ static void __sdt_free(const struct cpumask *cpu_map)
> >  
> >  			if (sdd->sd) {
> >  				sd = *per_cpu_ptr(sdd->sd, j);
> > -				if (sd && (sd->flags & SD_NUMA))
> > -					free_sched_groups(sd->groups, 0);
> > -				kfree(*per_cpu_ptr(sdd->sd, j));
> > +				if (sd) {
> > +					if (sd->flags & SD_NUMA)
> > +						free_sched_groups(sd->groups, 0);
> > +					kfree(sd);
> > +					*per_cpu_ptr(sdd->sd, j) = NULL;
> > +				}
> >  			}
> >  
> > -			if (sdd->sg)
> > +			if (sdd->sg) {
> >  				kfree(*per_cpu_ptr(sdd->sg, j));
> > -			if (sdd->sgc)
> > +				*per_cpu_ptr(sdd->sg, j) = NULL;
> > +			}
> > +			if (sdd->sgc) {
> >  				kfree(*per_cpu_ptr(sdd->sgc, j));
> > +				*per_cpu_ptr(sdd->sgc, j) = NULL;
> > +			}
> >  		}
> > -		free_percpu(sdd->sd);
> > -		sdd->sd = NULL;
> > -		free_percpu(sdd->sg);
> > -		sdd->sg = NULL;
> > -		free_percpu(sdd->sgc);
> > -		sdd->sgc = NULL;
> >  	}
> >  }
> >  
> > +static struct sched_domain_shared * __percpu *sched_domains_sds;
> > +
> >  static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map)
> >  {
> 
> and maybe similar check 
> 
>         for_each_cpu(j, cpu_map)
>                 WARN_ON_ONCE(*per_cpu_ptr(d->sds, j));

I will add the comment and the WARN_ON_ONCE() checks in
both __sdt_alloc() and __sds_alloc() for v2.

Thanks,
Pasha

