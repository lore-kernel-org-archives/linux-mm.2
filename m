Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA766CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 14:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857CE6B0088; Sun, 18 Oct 2026 10:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808836B008C; Sun, 18 Oct 2026 10:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F75C6B0092; Sun, 18 Oct 2026 10:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED896B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 10:35:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B334740521
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:35:24 +0000 (UTC)
X-FDA: 85335994968.01.8B95506
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id E387B40002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:35:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jkIqZUcj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792334122;
	b=RycGaE7RCenZd+StwY5XpisvAZI3QjJiWGik3mUmZsOY/ruzAuJWFQIjLWDySfmH0INLBp
	cs0u1Ic/xkvxakFIKo4EIq/0hwuvBILAkG1kWWljdZSnI5ITPpGoNXkCX1eSguzTP3r4fD
	fWtKzmqoX0sditc3SEzg8tTmVT9fOlo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jkIqZUcj;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792334122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=briTVmjslxeUx0FiA5Z2sKc9bXZYk9yUUpEJ168UtpQ=;
	b=WNeHljjWyKZGp2e2kWDpebZ9kpe8KV3/iBI4UgdQ/9x5I8I8T6bAVMYSH1gV38bkLVQo0q
	lmgA7EqcQeHxretiMUMRZAt54Tdf2RTaxZiPaIxhuQp/bGVhVQaRM5T7qwqu02+QjYlili
	jzYnpW6tLieYVy8NBEQ2JGc1f5ncXN4=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5df34e70a50so1716100e0c.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792334122; x=1792938922; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=briTVmjslxeUx0FiA5Z2sKc9bXZYk9yUUpEJ168UtpQ=;
        b=jkIqZUcjlzIMhlq7DoM6WkASKVozac1gE1sFz29Q1XZ8HNyQS665vzG8UlwvaEdF2A
         8nAiEdw5M0vqcxjVr4Dzls3ZyfXILfpXh+Qh/4uE/ka3cm4vLAmDXhYXqhVuS74pyyBi
         Z1t65zYuT31JzV1Xnbfu0xP5O6kAMGgN0Aqkghf+hMWBCcJkz7emaeWCUmWARspMulAg
         y11EMMyH8sfCWxCfbzMBx+imn0ILoePq5vfbZjrbGa0vOpQtmOCa5ygJDQJ2jb6PLsAN
         Y5ezS0enfyDvlCtfdaYuVVK/ZM4O0C0REYoRRHw94YwQd0rxj50JghYWpmQbEdHeIUTM
         sEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792334122; x=1792938922;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=briTVmjslxeUx0FiA5Z2sKc9bXZYk9yUUpEJ168UtpQ=;
        b=0fvRAonOoefHPBjH8FbrbfYQwArY+JRuDlcwZ0aP+13t0ZDVCLHzXznD58DxFpPono
         Nlcx2/wQW2w4cJo10lg3DpY3ZNBU9KR56P8sOa6JgQgdSuZVgHOeQZrBAoWCtgJfqOVy
         F2lxszjwfvTL3qkMKfKtIwBFb31YK+zqyWonAIEwTx7QSI1l+zNxBkfaLNUnQTt3SzQN
         xn7j1PGC6dWtUT4lt221d9ciUAOI5U1YAwDX8++zC2/ApR9KJjtJWa27+67GdEqdLgEg
         Uxl0re+kFQhgqcJWHxBY0ig6aZ3KCvo3lE7ZaFAdEKozTnhSMY/1pSsJ2sp0U3uASRs3
         S+eg==
X-Forwarded-Encrypted: i=1; AKwUvBw7PF4uwvF158y5+LSAuzBPihEKf2CUM78hiDq5X2EVuiR+kOxnxzwIRGp8vhYY9+w158w9MiKBzg==@kvack.org
X-Gm-Message-State: AFq9FYLVSj/xvNwcEVcooDrhxvys9atQjlY0jfu9bg6Yr1AivrlkMF3R
	VeZIhXitZsnSJP2GinXdc1Tv7W0QTAad7v0jLNxSzCDpUiHJzTZPUtV6Uda2oE0WQ+k=
X-Gm-Gg: AYBFou1yh7uZj3Cq9Jt9yDxl3Uexcl/0MqEa9BHjQ7ZR2jIGRgAclleglEFwR5iJEET
	yj/q7VmhFkN3dQ03nutmadTWn7sL3RQxTLbvKjz4jVYjN0nbjbeGAT0kOu6ugPgbw4rIuhf91e2
	XgAE8xyDohplxfGHCsYrDzR4s73aJatkl8H+3byZUgtLf2aQPtYdDSKZ3cfON0RngUGC975W1AU
	E+jYqFMDC3VZjn+WLFUIVkJU2vfR7sz/V7A94pbMl9i9unvFGtIa+6K3vAwe/9MjO0mm0pQKmK5
	/t0M6oFDzqUTf8yFzHoXmdl2El3nBW88Pwb05UQi+xD72ACh3clxTjR+HtDF6O+98gl7FFovMrJ
	TEfTvB3uO9FUISeuMBuch+KpEfSrsmeqjS/25qJx/00itZ0lY1THaNvLkoVeyzNnCCnvDuiHHch
	aerd7KgNgZYSJvMN6c3kr0ZH2wlPBjlD3XmBuguLrZtYKwpRnex0L6X8pU2CLhPZkT4G+KYwlHB
	eX3nKjSYQ3iXYCXNE0vOPOrnly4AcI71ehR1DRrZMiS0WxS4NFzZUgNuQ4iHAm+v3zNaieCtPs=
X-Received: by 2002:ac5:c64e:0:b0:5ea:ca0a:374d with SMTP id 71dfb90a1353d-5eaca0a3bd0mr42477e0c.17.1792334122018;
        Sun, 18 Oct 2026 07:35:22 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eac20d6aa6sm1663781e0c.7.2026.10.18.07.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 07:35:20 -0700 (PDT)
Date: Sun, 18 Oct 2026 10:35:19 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kees@kernel.org,
	rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com,
	tglx@kernel.org, vschneid@redhat.com, vincent.guittot@linaro.org,
	bp@alien8.de, thorsten.blum@linux.dev, cgroups@vger.kernel.org,
	tony.luck@intel.com, david@kernel.org, mingo@redhat.com,
	akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com,
	ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com,
	mhocko@suse.com, vinicius.gomes@intel.com, tj@kernel.org,
	vbabka@kernel.org, linux-kernel@vger.kernel.org,
	peterz@infradead.org, surenb@google.com, hpa@zytor.com,
	x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org, pratyush@kernel.org,
	dave.hansen@linux.intel.com, rostedt@goodmis.org,
	gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de,
	graf@amazon.com, linux-edac@vger.kernel.org, liam@infradead.org,
	ridong.chen@linux.dev, longman@redhat.com, bsegall@google.com
Subject: Re: [PATCH v1 5/8] sched/topology: Avoid redundant O(N^3) group
 capacity walks and unused allocations in build_sched_domains()
Message-ID: <atTZJ6Q3vTjvDjgG@google.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
 <20261015153331.1872641-6-pasha.tatashin@soleen.com>
 <b618f528-ba35-4fb3-881b-e0ca12bc9558@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b618f528-ba35-4fb3-881b-e0ca12bc9558@amd.com>
X-Rspamd-Queue-Id: E387B40002
X-Stat-Signature: ttrrfffyikfrtkys8w6yfz8k6bpkkuos
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792334122-900428
X-HE-Meta: U2FsdGVkX1+yeHT4xyAciQjYx2CYNFwxisBog+5MXRRj7s6owKjcZbQtFYMYJGOlma5oSsEUaXmEeo6RDNKYasyPX7ca3zA2bDZBkxkTzR4zKlNpuAj40J86ZaT2FirQf9eGcz1gXvi4QPg0nmp5ctDqJ5RJK26wQXOTMUIeyEF8/iA/7QKVgKU7phgANbpY52sR84//b66yKjtztB5Yz92APQtjBJ9AoiM2APm1NUYveMBv3QniqjgiYER/oWhkynuAP/zAsGNukccLTjY4udUqiHSthSOQYT8zmzE77vcOe+E9EReFUXB03auD0go+cRIa8oWmAXB1puYw79wsE3Bs+26PnrUeukZ07gDQgUQYCKoL5AlTs/QZuj7qogIsP5tBfcsN9/8yDdv6dm9eEx/qRU0uznrOcAd/QCcyKxa0i6fkQMHp2Ul++srUCE6wvItuO8ioKp0VArzYGJ5oBEZCy6+oQd+DNopXLfoI9IGlgIRw4a4hTIAj3uXjRTpyOZFiy/iEzcMn1G3obZSkZjc9RHxgQ/Dm2ZZPz2LYCFZXXEtsTpOQzzms/8ekrugGF2JY3khEQUuqpz4KdnUOvgQSn8pOkdhSupPm2mPdpgd1KmFkCSx8tSR+17JG5d6I6RjDDi0k7ATZNJ5sSI1JLCo7AVKqKplo+6M00Xw04cTXCnHlHgByOJr3VwA2BnnShrDYqWoSVYo3O71ebvRGHw7LlfsReLhTm7OqT6ncBUd1epFIP0sNjaJYFXcMgLQ1m5LCDRYaK6KPXMyFwdoYpzy86kkNwsklggscsAZp2N+7QqWgP780U9ZLFUzcleHc63we8PTVKbWlgFScxL2cZ5/i+hbV8Zy9hAncQvadWz8tnlYyMuJSVekIumSmn1ygUQiZx35xxQDkRO27I7MNuxcVQnhPzZXuTZ5d/xh90BVZOU+VIodXEhNnUI4hfOwX3fmtjHF6vDSg3EPyE5+
 igDt9SGM
 BNEbGRGbTLUgaL/tcYEPJcfvTTm8DajmzOWMdbTvyW/MAiayTKjBls2y6rr2HwqJOal5FSj1+cFJaB45U0CnKxbhq0l1+Qmaw9pJ+NPAynEhXZt0YqqQCqxHTH/KvpUytzKpmui6MtKrsTlAiO9DgrGftRaUcTPNM04b25kT2smguLRzZYipb37eUFyvtLeg3gk137mfvDQ0+ArHqHkgDBbX2ZVYFHYIRTMqEu6eCru8bsm5XEgk7CBdhuwFYJ8ShwEJpW7NC63D3gfEX/nSdgJg9b1aAan8APhq+M4ZxR85vOeCWnAmKhjt1wlfg5jo4taZJZBJobY8N+1Zb7wqfrQW2eMlmP/ehYlT+fgJSdaXbDNvGLYgld687DfpZW6wD6bz2PMITtkn2lFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-16 11:53, K Prateek Nayak wrote:
> Hello Pasha,
> 
> On 10/15/2026 9:03 PM, Pasha Tatashin wrote:
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> > index 0248227d983a7..02c38089a80c9 100644
> > --- a/kernel/sched/topology.c
> > +++ b/kernel/sched/topology.c
> > @@ -1259,32 +1259,49 @@ build_group_from_child_sched_domain(struct sched_domain *sd, int cpu)
> >         return sg;
> >  }
> > 
> > -static void init_overlap_sched_group(struct sched_domain *sd,
> > -                                    struct sched_group *sg)
> > +static int init_overlap_sched_group(struct sched_domain *sd,
> > +                                   struct sched_group *sg)
> >  {
> >         struct cpumask *mask = sched_domains_tmpmask2;
> >         struct sd_data *sdd = sd->private;
> > -       struct cpumask *sg_span;
> > -       int cpu;
> > +       struct cpumask *sg_span = sched_group_span(sg);
> > +       struct sched_group_capacity *sgc;
> > +       int cpu = cpumask_first(sg_span);
> > +       struct sched_domain *first_sd = *per_cpu_ptr(sdd->sd, cpu);
> > +
> > +       sgc = *per_cpu_ptr(sdd->sgc, cpu);
> > +       if (sgc && atomic_read(&sgc->ref) > 0 &&
> > +           first_sd && first_sd->child &&
> > +           cpumask_equal(sg_span, sched_domain_span(first_sd->child))) {
> > +               atomic_inc(&sgc->ref);
> > +               sg->sgc = sgc;
> > +               return 0;
> > +       }
> 
> 
> This insanely specific check perhaps can be something like:
> 
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 06cc9f6397bd..a7d7a3b51c71 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -1203,6 +1203,33 @@ int group_balance_cpu(struct sched_group *sg)
>   */
>  
>  
> +/* Find the group_balance_cpu() */
> +static int find_group_balance_cpu(struct sched_domain *sd, struct sched_group *sg)
> +{
> +	const struct cpumask *sg_span = sched_group_span(sg);
> +	struct sd_data *sdd = sd->private;
> +	struct sched_domain *sibling;
> +	int i;
> +
> +	for_each_cpu(i, sg_span) {
> +		sibling = *per_cpu_ptr(sdd->sd, i);
> +
> +		/*
> +		 * Can happen in the asymmetric case, where these siblings are
> +		 * unused. The mask will not be empty because those CPUs that
> +		 * do have the top domain _should_ span the domain.
> +		 */
> +		if (!sibling->child)
> +			continue;
> +
> +		/* If we would not end up here, we can't continue from here */
> +		if (cpumask_equal(sg_span, sched_domain_span(sibling->child)))
> +			return i;
> +	}
> +
> +	return nr_cpu_ids;
> +}
> +
>  /*
>   * Build the balance mask; it contains only those CPUs that can arrive at this
>   * group and should be considered to continue balancing.
> @@ -1212,17 +1239,19 @@ int group_balance_cpu(struct sched_group *sg)
>   * can fully construct this using the sched_domain bits (which are already
>   * complete).
>   */
> -static void
> -build_balance_mask(struct sched_domain *sd, struct sched_group *sg, struct cpumask *mask)
> +static void build_balance_mask(int group_balance_cpu,
> +			       struct sched_domain *sd,
> +			       struct sched_group *sg,
> +			       struct cpumask *mask)
>  {
>  	const struct cpumask *sg_span = sched_group_span(sg);
>  	struct sd_data *sdd = sd->private;
>  	struct sched_domain *sibling;
> -	int i;
> +	int i = group_balance_cpu;
>  
>  	cpumask_clear(mask);
>  
> -	for_each_cpu(i, sg_span) {
> +	for_each_cpu_from(i, sg_span) {
>  		sibling = *per_cpu_ptr(sdd->sd, i);
>  
>  		/*
> @@ -1281,7 +1310,17 @@ static int init_overlap_sched_group(struct sched_domain *sd,
>  	struct cpumask *sg_span;
>  	int cpu;
>  
> -	build_balance_mask(sd, sg, mask);
> +	cpu = find_group_balance_cpu(sd, sg);
> +	if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
> +		return -ENOENT;
> +
> +	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> +	if (sg->sgc && atomic_read(&sg->sgc->ref)) {
> +		atomic_inc(&sg->sgc->ref);
> +		return 0;
> +	}
> +
> +	build_balance_mask(cpu, sd, sg, mask);
>  	cpu = cpumask_first(mask);
>  
>  	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> ---
> 
> We just find the first CPU and reuse the scg. Otherwise, build the
> balance mask.

Yes, this is cleaner, thank you.

> 
> With those changes ...
> 
> > 
> >         build_balance_mask(sd, sg, mask);
> >         cpu = cpumask_first(mask);
> > 
> > -       sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
> > -       if (atomic_inc_return(&sg->sgc->ref) == 1)
> > +       sgc = *per_cpu_ptr(sdd->sgc, cpu);
> > +       if (!sgc) {
> > +               sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
> > +                                  GFP_KERNEL, cpu_to_node(cpu));
> > +               if (!sgc)
> > +                       return -ENOMEM;
> > +               sgc->id = cpu;
> > +               *per_cpu_ptr(sdd->sgc, cpu) = sgc;
> > +       }
> > +
> > +       sg->sgc = sgc;
> > +       if (atomic_inc_return(&sg->sgc->ref) == 1) {
> 
> ... we can be sure this is a new sgc and just do an
> atomic_set(&sg->sgc->ref, 1) here and initialize the rest of the
> fields.
> 
> Thoughts?

+1, Since sgc is lazily allocated on demand in this patch, reaching 
the slow path guarantees we are initializing it for the first time.

> >                 cpumask_copy(group_balance_mask(sg), mask);
> > -       else
> > +               sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
> > +               sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
> > +               sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
> > +       } else {
> >                 WARN_ON_ONCE(!cpumask_equal(group_balance_mask(sg), mask));
> 
> Do note this check will be lost with the optimization for the
> fast-path case but that should be okay(?)

Yes, that is fine: find_group_balance_cpu() already verifies that 
sg_span equals sched_domain_span(sibling->child) for cpu.

I will fold this into v2.

Thanks,
Pasha

> 
> > +       }
> > 
> > -       /*
> > -        * Initialize sgc->capacity such that even if we mess up the
> > -        * domains and no possible iteration will get us here, we won't
> > -        * die on a /0 trap.
> > -        */
> > -       sg_span = sched_group_span(sg);
> > -       sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
> > -       sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
> > -       sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
> > +       return 0;
> >  }
> -- 
> Thanks and Regards,
> Prateek
> 

