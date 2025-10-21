Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610A9CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 19:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B378E0006; Tue, 21 Oct 2025 15:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42C38E0002; Tue, 21 Oct 2025 15:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9583E8E0006; Tue, 21 Oct 2025 15:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 854D58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:16:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2687313B1FD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:16:56 +0000 (UTC)
X-FDA: 84023078832.13.4208146
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90C19160010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:16:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZRa1ReN;
	spf=pass (imf08.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761074213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Av2zs3MEbcbLC7aMwacLFVSODjPRb5hpuHHxAZIybWo=;
	b=TF5HA2KS1IM+AZlBuTSmzn/M2a++JhPeG4D3hXdLF6qRdqWwe8S9Blv3xhpCHqHRVQdXnL
	FRtXGjgVH+8lud+KIXStdZyRMaQ0zO1srL3Xp1rALMt1DCEPlmL6YimcACej/L/tgKyjy8
	DE0E2yo1S01A2UVcGNTyP+E1m4/8igg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZRa1ReN;
	spf=pass (imf08.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761074213; a=rsa-sha256;
	cv=none;
	b=13yTCvmmvuIH/BUAeBHezLgCOgEU0D8oJiPv/429QZ+JczME9bgS0/5NPth4EIwqwgR+ah
	fAHqWtfLGdwSrK/k3B+21JEGxxnLNfEyyebCFp5u1sD4gJ+iJpVIRb75hUkrw6gJ1BH219
	uHJPpNzmV6vTf5vmtZNPG31s2eHrl3Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761074213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Av2zs3MEbcbLC7aMwacLFVSODjPRb5hpuHHxAZIybWo=;
	b=HZRa1ReNbhDfZrPah/o+D4GJ0PRHjwngJYdUAGraqVRa/bHqxVPk5peX5pNffKDp6x8h4U
	aVqA8WLGpxKoHiTKR7xW2w7EQdN0uEnU+v8nR8Xm0rwA2gBQl7BGRerJ2bT4kfFGH3eDf/
	DqO/p49nwJMRHR5RbIR2hoXNvJPdXbU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-3Kb-C-lbOviqWouu3Q_4gA-1; Tue, 21 Oct 2025 15:16:51 -0400
X-MC-Unique: 3Kb-C-lbOviqWouu3Q_4gA-1
X-Mimecast-MFC-AGG-ID: 3Kb-C-lbOviqWouu3Q_4gA_1761074211
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-79e48b76f68so297309416d6.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:16:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761074211; x=1761679011;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Av2zs3MEbcbLC7aMwacLFVSODjPRb5hpuHHxAZIybWo=;
        b=o9+wLXnI5QMgLBuSZ+62glKsFTKZE+oEB4hNGSGGuWJXITMYJLLAt/Rtz21QSsNgt/
         vSb9cLYu1Nz2dz1Oy/mE7I08T/3B4Efp1MwZ3j4oFk/VBx669N+eufFlUW2kx9DWJr43
         xZtEevsgdSGpeZrlH5Ia5z9Wk+gEwhI4Zj4y9zPVEzi1pmcxzc2QXkFbnrAMzhvm6prt
         INBEcozGEtD894l2IgzhmokFT8xSB8OlZo0JkQPeTehXjG2NhnzsN144OR22N7d4p9Bj
         u5ctXF2dPT+mBtj62kdLR98VYjVNmIVYFDYkXXJ6rYiv/mgC86MHplAwKYfmikGwx7N6
         M1Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVeVg/Cufcy9KVnmp7oTr7idCdtEg5//QHs3AE6rVFo8nxiQ85qR+d6DzZDU8FBuhxSS5pT2BBEKA==@kvack.org
X-Gm-Message-State: AOJu0YzxQTXDg4PW9Kif3CzglOF4UFRMFUrh9R0D1vsC6Yz7o3AnexT9
	DjnRTGZJ5ZBXpKiHFVhKmYZio49Hj48cgK5bEwgbvz6mUm3SKGZu2/0XPppJDQWEXIIc8Z5tpjT
	ZOapj5z6VRlpcvvCMBC7pPvymMWz6iecoXHV8e+yTfuJLH/BHc/js
X-Gm-Gg: ASbGncu0S76UMtg9szV+KOtE066i+8C+/QDlIrmMfjvE3ADzbGK46i7T+C46Ekdb/h7
	fzwiEr+XYDBoMpWMOGNCa5b2AHQilf0LeFm2wquW95mHD8w28Wa7WnwHXDyzpAiFRLMPyW7H8ja
	7BQTlzMbfPMngljz8v5G4r3Bp3Tl2lC9WxSXCkmyyhUJCb03f6i4QoqMxbw2653+HIuIt1EC6SN
	yZgmtxJNUiH4YW3J0a3ddGHAV1IFvjN4t22jeJ2Y7zXvygOT4xDNTEgO2lDN0qfkFotZG4VHgo2
	ZNEz1nH2Opmn3EQSUyWtTulcKpMs4i7H5gFwAc/Wzma73QPrtzlhTWKhljKeowI23d+b1VsyEfB
	2iK/McDEuRKS5CMHzdMsOKWEsvOX2EWg/fboolyZ4jfXRgQ==
X-Received: by 2002:a05:6214:4012:b0:87d:8fa7:d29e with SMTP id 6a1803df08f44-87d8fa7d3a7mr172807686d6.35.1761074211049;
        Tue, 21 Oct 2025 12:16:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMN3DCL5z77zrF4an/kPQngsHh4Dl7HI0jLtCtPSfq0EP/4XoCKRGCEKlYnjWxZgcz1y0y9w==
X-Received: by 2002:a05:6214:4012:b0:87d:8fa7:d29e with SMTP id 6a1803df08f44-87d8fa7d3a7mr172807136d6.35.1761074210482;
        Tue, 21 Oct 2025 12:16:50 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87cf521c2c7sm74369666d6.19.2025.10.21.12.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 12:16:49 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <364e084a-ef37-42ab-a2ae-5f103f1eb212@redhat.com>
Date: Tue, 21 Oct 2025 15:16:45 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/33] sched/isolation: Flush memcg workqueues on cpuset
 isolated partition change
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-15-frederic@kernel.org>
In-Reply-To: <20251013203146.10162-15-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LDLCIh1ryB9GFoWGiP4lo0TB90fQcBn5xKAC6wut5DE_1761074211
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90C19160010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: opfokri74c4zr9ay9kzyo439uzn4gdu3
X-HE-Tag: 1761074213-81110
X-HE-Meta: U2FsdGVkX19D+wBMjUUDFfrTQmHnxZzZlxJ9YRS6YQexl4b3jpBCnO4CUx5vD0JVClTMGLbFD3qil1VKZinz2F16886YP6/8gY6jRjlngpZgpLIJi3bp+NOFZB8clwc758+W7j//vdU/P39ke3ijK7iAJoPuAtGmTZcMrEj5eDQZMESkH5Eb+TsS/Drb/fAPYShZKHKJNt5xFY8CA4mnMK+H/URWjlny5Z5n+iaqKYzBsm3Hbx3GP8lGUmba4uEnu1nTAUYfi0CN4wTLdhnSMkvAX/XEuQXE0VH1xZn3h5FaZ2O9vTlzNLXxyhyWa2+ebWLnKPk5KgOnRHQTdwuG3uDilL8L72Z5ELQ3nlaLMf9vBv2wWQUKCSCIM0mCKtZ4hy51BizN+HZzupCpaPaIcm7tTfiv0pXZg5M0I0MR8f8CVda/4kr8US/Rto4GjOr+keHzOivfqRxJl7jjJRFcZ/b9JgP/0praxeNyTL/i36Qh/jakeN22luq06T9Oc2Fnb1gbQFZfIDJTmXCEzep/ZUmizOgwAK2+dAh5xdqHZJQCG4rrqpuZhS17Ry9QKTOX/z0wzjWOGLSSLrj9jx7IXRD06HF2Xd+1VLyoMXl/Mj1StL8ucZyA4pMONkbi/7cJbk1iPldupAb7IFIvi3K+/1fzLGfMe2oh0xeXkd7tZrO6w2eEoJDvDnmDUnHwd1p2xQTcQkC2kIPdq+ruCgDfOfqX+5pZBHHKc0lgZ0nQwb2zidmfnii93ml8WDMRojq5xStJ6bPnJYqQF3c6DWw5L7SdxGWwWfFWouiOV7BGe74Rl5nx/awgbGBVTFXA9MPtwy/JOpRmmbGwVwC26MTmy9EQeHwNxWm1xoAn3OZcYT4Ya84T1yt59CR0wDpPWX3y89U33ljD/xBXbHK32BPbErz9yn0NvHboupjl1bTqsI/2eEkMinuT8YnLdeljv7E0qwktdsGZaxaa8tNipom
 T+rEfMHl
 VCiEoMA5y3CY2mafztk3acUDa7kmhP2LlGoX1y1IbHhGZ2D6trZ3sCgQ5ITIybM33gD3NfPj5o83PahP21DOrmJngE00so8+S/Ji1I1VU85u2vdf8jBp3iOcIBr+SHo3zacYYMNWpebk5n2AEL6OSGd5jUq5n1lBYHV5qYwaKCSe6zxqc01LBgYkgQzBYEzpTB9evlYyr3roUB84URgmgc4U2ctRZM4nvUN6nl71CIsljJWJ2kE1cbYsyF+PEJZoergJ/itDUNTX5vz+30qFeSWbmwuVdhdIciY3G/A7VLohU9Jg/pB96YoL9kynJ4Lmytlqcff7Ugz+sY7RnTCZvY+eCKPzIRo35KAlgWhEwcdkTL9NfHl1XIMA1C1SwcPJYlv2myWL50zVUx1ZY4XJYqEvIY/t4/IR+798EApcg75GA+KHL6jh5Y7OiLYaIpvROCS/MUESkiIVmb52DxKmopW0VV06pcj+/xd1GmwKvV9TH32yCNLz69cYE183PlyhkD668yNz72nWoV8v1D6Sf8WQCGfQrvYH25uRBZkdZwza/T8S1JaLbIxLzFoutBKNn+BXbAUBsf3ly7v4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime. In
> order to synchronize against memcg workqueue to make sure that no
> asynchronous draining is still pending or executing on a newly made
> isolated CPU, the housekeeping susbsystem must flush the memcg
> workqueues.
>
> However the memcg workqueues can't be flushed easily since they are
> queued to the main per-CPU workqueue pool.
>
> Solve this with creating a memcg specific pool and provide and use the
> appropriate flushing API.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/memcontrol.h |  4 ++++
>   kernel/sched/isolation.c   |  2 ++
>   kernel/sched/sched.h       |  1 +
>   mm/memcontrol.c            | 12 +++++++++++-
>   4 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 873e510d6f8d..001200df63cf 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1074,6 +1074,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
>   	return id;
>   }
>   
> +void mem_cgroup_flush_workqueue(void);
> +
>   extern int mem_cgroup_init(void);
>   #else /* CONFIG_MEMCG */
>   
> @@ -1481,6 +1483,8 @@ static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
>   	return 0;
>   }
>   
> +static inline void mem_cgroup_flush_workqueue(void) { }
> +
>   static inline int mem_cgroup_init(void) { return 0; }
>   #endif /* CONFIG_MEMCG */
>   
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 95d69c2102f6..9ec365dea921 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -144,6 +144,8 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
>   
>   	synchronize_rcu();
>   
> +	mem_cgroup_flush_workqueue();
> +
>   	kfree(old);
>   
>   	return 0;
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 8fac8aa451c6..8bfc0b4b133f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -44,6 +44,7 @@
>   #include <linux/lockdep_api.h>
>   #include <linux/lockdep.h>
>   #include <linux/memblock.h>
> +#include <linux/memcontrol.h>
>   #include <linux/minmax.h>
>   #include <linux/mm.h>
>   #include <linux/module.h>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1033e52ab6cf..1aa14e543f35 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -95,6 +95,8 @@ static bool cgroup_memory_nokmem __ro_after_init;
>   /* BPF memory accounting disabled? */
>   static bool cgroup_memory_nobpf __ro_after_init;
>   
> +static struct workqueue_struct *memcg_wq __ro_after_init;
> +
>   static struct kmem_cache *memcg_cachep;
>   static struct kmem_cache *memcg_pn_cachep;
>   
> @@ -1975,7 +1977,7 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>   {
>   	guard(rcu)();
>   	if (!cpu_is_isolated(cpu))
> -		schedule_work_on(cpu, work);
> +		queue_work_on(cpu, memcg_wq, work);
>   }
>   
>   /*
> @@ -5092,6 +5094,11 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
>   	refill_stock(memcg, nr_pages);
>   }
>   
> +void mem_cgroup_flush_workqueue(void)
> +{
> +	flush_workqueue(memcg_wq);
> +}
> +
>   static int __init cgroup_memory(char *s)
>   {
>   	char *token;
> @@ -5134,6 +5141,9 @@ int __init mem_cgroup_init(void)
>   	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
>   				  memcg_hotplug_cpu_dead);
>   
> +	memcg_wq = alloc_workqueue("memcg", 0, 0);

Should we explicitly mark the memcg_wq as WQ_PERCPU even though I think 
percpu is the default. The schedule_work_on() schedules work on the 
system_percpu_wq.

Cheers,
Longman

> +	WARN_ON(!memcg_wq);
> +
>   	for_each_possible_cpu(cpu) {
>   		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
>   			  drain_local_memcg_stock);


