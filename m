Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B932CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE142800C6; Mon, 27 Oct 2025 19:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8E38009B; Mon, 27 Oct 2025 19:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE9B800C6; Mon, 27 Oct 2025 19:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD6658009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CD2A580C3
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:18 +0000 (UTC)
X-FDA: 84045535476.04.99C66E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DC77D140006
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vCY9C8dt;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpJ3eEm7MlKuRgAvIETJw/4Xu9T5zI07U0O7V0+uMYM=;
	b=Flbf//ZF/9OILMZCxFh9tnMn2h7iLaLJFM6z98vgjZGaV85iUDsEoh2180pomAZoRWZK90
	LFQVqaimSVpkTPrf9tNVndy7dBD18bioFDH8EGnVAECIafget8Qvr4z8RLQy9S8Bm7i3Ks
	XN9BryDtb603+gA2ktWbXN0eI6pMES4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vCY9C8dt;
	spf=pass (imf26.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608897; a=rsa-sha256;
	cv=none;
	b=P49Gnq42uljlv2W7hOUof8XDMgAifomXtciG57zHQidPrgI0cG1CC9ScrDipdksPO6fsRE
	ePihDfpPDr+Xb3QwWVQV7JryOx38B2TiFYuqztBuAqV0xW+efdl96xHVRhdmkpJ5ThVgK1
	iG6UYPLd6P6YqrtHcg+Vjd//6BQ7iPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AC974069B;
	Mon, 27 Oct 2025 23:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3774AC116B1;
	Mon, 27 Oct 2025 23:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608896;
	bh=v0Afzzp0700/IjRTUynv8g5JufTRMVUbnyZY3s2z8vU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=vCY9C8dt540K8vmYo7odHS4QKxuyLr1FxOMp1bgGYYl1z641c7M+KDsvgTU8VuzYN
	 0vUvEhm0EcWPix1RKYtdLlhC9kC7RzxNAbUdmLpuQVfqccXZFi45Mw1hgTIiEeP9Ua
	 wXDtLN97hepJZn3owJSm9gmsAREe8RKv5d5JAgKmEvbtVzJUIkmo5hdWobzLKWmdHS
	 250aqXzPPKoYx8YaC9IL0JO13y3eJL4E3S5U3jmBmeWExKczW7UNOiaxmaX+H1X/kn
	 zaifLKQPy03sG29dKdowCGKYQwXIlP6vqCel/peFS4+wSLzsctch3ANCx10/IaRYtX
	 84nIPWGC/3pKQ==
Content-Type: multipart/mixed; boundary="===============4920457427699144756=="
MIME-Version: 1.0
Message-Id: <45ee5e2e857a2e4022eb380f854d2a7cf27f3ec97d75a0200b46be95ae921d3b@mail.kernel.org>
In-Reply-To: <20251027231727.472628-11-roman.gushchin@linux.dev>
References: <20251027231727.472628-11-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 10/23] mm: introduce BPF kfuncs to access memcg statistics and events
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:14 +0000 (UTC)
X-Stat-Signature: yzeq7xtdghgts9oz64n9k8r4rmo51zxz
X-Rspamd-Queue-Id: DC77D140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761608896-447865
X-HE-Meta: U2FsdGVkX1+hsDFNW4zemknPO8g0pwsqxNJXEuYu/pYc1FH5DR/RvkbU0ikfeBL0d2AsCF/gE796cQmOtXcFO9BwyvrwB10UdLm7v/mGpCHcG8+xjqsWLy6K223nrg/jmg/QggmX8I4aIkrKdQDVuBgX31HTsdun4IivgHIYn+MkcgCxFM04g7K7JwXW8IPn6C0W2Q2H3Qfe+MRNd3R+Q6jo7fDoS9QPHYlVx1nypqsX16K43WQvlWyAZY9kMvSM2hWENC2ZLp1lOqK1AdmWoCYQyy4hffOxjFIP1O0Y+WAKcNcd0cQ/xJScoO6yK19rdZOm+JjoJthRZaBoLTJGaF01HTD9oeoe/a+9ey7NLZyVHaCBGiR7Y2zwRJUMO8YhO1sy4PqPjBkC3YJ1wf+tCMOFmGXBOT1jaaql1vwoYeVnjcattrU7ZUQWvIKYiK4WtDuTLFh4NhLRKSNKpp8YHgoFhBzhSkQMJ1Ya0i2lqEyYlJLijXzTuTX2jMnguPtMGFpH2h1viuZbKkTELlmWeW6LBgnKvmNo3bPgWEjlGhOGzwNZ+yHkKNH9pG2CdScyB2YecmI8Fg8kbhKEmvMWBiOk0+g+odJPRZ5s2yWShVNFH75fOcq0fZwyTCakzBWUpvaY1L7Ioy+6BoJgBTMW9CfHTZqjCFM3T1IEXAWQbJPEgvkDzMJA1EIx+pMRTbt7hkai3bJdWxFX+N8WGXwdekUK8TU2EfftGuuSVbl8BPne1WfeDbtDKV3pA3n9VfrN7/9lK3FH5B+KSkRE1nVVo2vJP4/mhwLird2IJEAAFDqDRgSRJMJT1ZnA4EEDeIWhe40vpyoYx9T5oP8spG+jRIDalJlYl2AlNESAKl+R9hst7iOwVut6xxfzU1uDE8l6v1vGI7vK7blbNSyOo//r4Ad0LG7Qkz080cbzX/bngdY9A0f8B2B3DX4EHqjib5DNtv2uU1kRG3CobZ95ETy
 nXFnUAJI
 4gmr68W81bZGL+doJNlaVo4B2xTftggZb9pqKcac4eHg7GMGig5evZqSpkc8ZOj1wNvspAh3ZypVJ4TRC6BGhl6ZUswSbMgHn16AJ2lzt4kxtygPTyb1MUV1VMau7cNMYMhttSvv4bYdZx6oLp0ucXO2fV62U7DZxVuHSJ1jeoQOjj1UUPEChxDC8Kwd49Aqixcuc/aM30oEovBkr21nb2TFqekshrQGqqFSkOUaYH78KD3kUClbAXaYRpEo4YRWYJlwBZ2zHcjVkcXl7wffJGXiDjdMXUkatsv6G9wEE0chs1lySp7U13vL8S4EZ9Hdy1jHNvSKqtxExulDwxNfdnVwQ9mnbndRbEqER9Yl/PvWfQw2s/GSlqRFCPAqPvk+WC4I3Y1uPkcXZiLs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4920457427699144756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit 96abfe0549713749f00e32bff919a759db284a58
Author: Roman Gushchin <roman.gushchin@linux.dev>

mm: introduce BPF kfuncs to access memcg statistics and events

This patch adds four new BPF kfuncs for accessing memory cgroup statistics
and events, making them available to all BPF program types for implementing
OOM policies and accelerating memcg data access.

> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 39a6c7c87..b9e08dddd 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h

[ ... ]

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 76c342318..387255b8a 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> @@ -75,6 +75,56 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>  	css_put(&memcg->css);
>  }
>
> +/**
> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
> + * @memcg: memory cgroup
> + * @event: event id
> + *
> + * Allows to read memory cgroup event counters.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
> +						enum vm_event_item event)
> +{
> +	return memcg_events(memcg, event);
> +}
> +
> +/**
> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
> + * @memcg: memory cgroup
> + *
> + * Returns current memory cgroup size in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
> +{
> +	return page_counter_read(&memcg->memory);
> +}
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The documentation says this returns bytes, but page_counter_read() returns
pages. In mm/memcontrol-v1.c, the existing mem_cgroup_usage() function's
return value is multiplied by PAGE_SIZE to convert to bytes:

    return (u64)mem_cgroup_usage(memcg, false) * PAGE_SIZE;

Should this function multiply the result by PAGE_SIZE to match its
documentation, or should the documentation be updated to say it returns
pages?

> +
> +/**
> + * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
> + * @memcg: memory cgroup
> + * @idx: counter idx
> + *
> + * Allows to read memory cgroup statistics. The output is in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
> +{
> +	if (idx < 0 || idx >= MEMCG_NR_STAT)
> +		return (unsigned long)-1;
> +
> +	return memcg_page_state_output(memcg, idx);
> +}

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `mm: introduce BPF kfuncs to access memcg statistics and events`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============4920457427699144756==--

