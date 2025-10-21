Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E40FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 04:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A5C8E0009; Tue, 21 Oct 2025 00:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701988E0002; Tue, 21 Oct 2025 00:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617318E0009; Tue, 21 Oct 2025 00:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 501048E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:10:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0107E13AABD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:10:26 +0000 (UTC)
X-FDA: 84020794452.13.005D1E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57E0D20003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:10:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EFgCUByo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761019824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9OupL1guxMQZzERaZQ5HIFJ+HTh+MX5SgUIo3LTaUY=;
	b=yUoHyiaGkbPinyDdeNTCaoYJ/uxiPXB39c1wvIGEMwHDOwmZD3QSYT+oLmXCVspHFc50bF
	eX6V6G+QiPx+ozxyQ+LbI8Qktsq6NRIbAORDh8Zq+S9NOzqSVdQNw5+/H5WfPj0cwiBnf8
	kXho+l0YbbnJeRR7D5MDmolOUr6vbrU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EFgCUByo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761019824; a=rsa-sha256;
	cv=none;
	b=AIfaQ+Jv0Ovok9sDAsu75R7npA4pMs6GvTDSGPvhtoUAj1vB0au37ODi1qddXbLue1n92l
	8Y6Uc10I6ndvSlCVi23mRgHMdSrV3s9lNXIB37pAghkhin1SMgbcv/fG32hipuiMHKLGyN
	sH8tKMbmj0DSHtxali/LH2jUgx3NvJc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761019823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9OupL1guxMQZzERaZQ5HIFJ+HTh+MX5SgUIo3LTaUY=;
	b=EFgCUByoM4QfmSq0a5kM72QLaW+qAi03T14bhkOSK4dFQbUyfcSeVLyLdeRhTkRe7L3Nx1
	T1Ch37UbLAp2JYx1a0JOUJ1hawISVoyLefHKSiwciYgWYKKCppkZqwHeEPouFcgGYB5w8P
	uBUQwBTq/+vYXhTkrK8upAhEEPP5SVw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-Rz7CtpqfNcO4L34wTUDeZw-1; Tue, 21 Oct 2025 00:10:22 -0400
X-MC-Unique: Rz7CtpqfNcO4L34wTUDeZw-1
X-Mimecast-MFC-AGG-ID: Rz7CtpqfNcO4L34wTUDeZw_1761019822
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-87bf4ed75beso195635156d6.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761019822; x=1761624622;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r9OupL1guxMQZzERaZQ5HIFJ+HTh+MX5SgUIo3LTaUY=;
        b=Kyi5ZWQxVMW7evo8E4rpFFetKkkFGHrV9/IQrju3XIFwNP5OSbpbIO/P/rgJIFbf+E
         8t3L1Wx6lBL4NTmfXk+P6UQxieN0khxIYFggPQjE7R8d/P+Uqz+ziiKTnGScxkGF+MIJ
         68PS64RIF0CGQkztGOGbFHkXU192CyuMDEdt+1BSlGpyr5Ko+VbBuvR31q29SPpu2UTN
         li2a0uTgFAhvXKhnKNzfpUbMB44nz93L/Uxwchj92ZQkvKdFHxbfywivI/+KvJkIko8E
         11VcbiiOOUVWylAviC7bPmC/Uswjm6NNOrLYDeva0AyFKbaLdRhLeOeAuKbzAIKRFxEW
         rFjg==
X-Forwarded-Encrypted: i=1; AJvYcCU3txEnba8Hvu3trt2HnYe/XW+Jt11F/xu2tVJwRayOwX0uMo5/jH4mX1WePwn4+EBm5eDu2TW61Q==@kvack.org
X-Gm-Message-State: AOJu0YxhImCsP2IMwqHxrYetKjFd9+y9irVRU9Ns13d+0YMtnzHtaJQ9
	rq659d0hEtT8f0DcaXXubTMI18aBB6DXBnNheDrE8B2zD6WuvHmds2vj4tRvNpxW2uc0IyocS7i
	Ua5fiOWzxYL2RrWoBccwDoUjJW5luB4ot8dXmZWe0mYg0S+fI/ccP
X-Gm-Gg: ASbGncu2VI+WUVEnogpNw+VYddNCyXHJ6L7GaoSZaVWKL8HWnr21E0BC+7kU/bPcRwU
	vPMcXWj/EbMckO2rkInfGDdJwK0/2hCIKLXUyUoLFoH0DJLxFeXjg3kKNkNy1pDBfN83QW1KPjZ
	UIRM3AxwCEjxHurG/p/l0kzkFJUMzdYuwCDRZqC3BC9BkITE0/1QryZYEc3ENMed86CTW8/JS4u
	JahVva7+veWuKnnCybB083qQsfuz2NZ9n6QbRoxFKadUhqnhqg1uP/L5iAnYD2d5XjyK+RsaDKj
	bYzFu2U1t3+lpqqfalD6wGVlpzxNeebj7k2LvNrryfhdfNXzqZi6j3+8mSGE35VPTwzO7D7uCh+
	ibWAOzuhGnuizAwD6YFa3ghBT3OmOzWX0Prt2aUzue660Mw==
X-Received: by 2002:a05:6214:808f:b0:87c:223c:c5c8 with SMTP id 6a1803df08f44-87c223cc6b8mr152673886d6.20.1761019821867;
        Mon, 20 Oct 2025 21:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdm2hwRLRcjdAJaN67gocvEQv/ytDjJvvxgQlCm7/W761K2ldQ2/8L5ftdru4g+9p/5t/b/A==
X-Received: by 2002:a05:6214:808f:b0:87c:223c:c5c8 with SMTP id 6a1803df08f44-87c223cc6b8mr152673626d6.20.1761019821460;
        Mon, 20 Oct 2025 21:10:21 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d028af525sm62600596d6.51.2025.10.20.21.10.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 21:10:20 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <0e02915f-bde7-4b04-b760-89f34fb0a436@redhat.com>
Date: Tue, 21 Oct 2025 00:10:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
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
 <20251013203146.10162-14-frederic@kernel.org>
In-Reply-To: <20251013203146.10162-14-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 46Ek6uxx-NHuZMqQjx7HNJVASFOqp6Ril1u9m5e2OhE_1761019822
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57E0D20003
X-Rspamd-Server: rspam03
X-Stat-Signature: oapezzt91kz933yh4qtee8sn6xa1f7pz
X-HE-Tag: 1761019824-278022
X-HE-Meta: U2FsdGVkX18F9U4L/Gwp1b5I0KmiXF0E9M7CE1AAN+Zg9TV48bh+6wpt59vi8OmlYT+ez6sWx5nrnPiXr/bvy0ts2UPs85Y75QvTr+G+9C/sLbKg7fOF7W8cQigaFHqQpsO2knqOl6srQ22cZHB7rzymn4aP6XW4VOn2PQJzjObcx4g0oFwLGLoj9Yj4qbkz8abzm2NZEWA4kBAONy64R7ruc/67CBEWfQAplUofiTPIsimcHOic+Tg554u94p/9f909CByzcc6OJL2be1lHsvBua4M/bG343VrVs5y4xT2AAGyjw+tMcAgBJ3tnfziuaEsHfZZj20L4yDSoF4rQ0ng+pyHcgvom+v7EEbNnBY3eJT7HFQ5eKoEo79K0lIubALDfu3iFmih2XXObzfmhhGekEoBqdJ72CVhbK/bYyamDRFW2XPu+525ILMej1930S0wNrfxASysURJX9b7VDnjTof+mofaRGFYHkWEcEaNDMuXu73y01tiX98pwLeKmZSOi9LKNXk+dAvtgKcmcCR/fDARMH8VQLBYUufDPdlv9clF4tuiTweUQuT2RzYtAZfAe9OnfCWu/0FZWAqKNgZ/coz8GqQG8P3KrKBeEZ5TiOENc2T05zokY7sVlE2Rq4/oRuCZ35XNOpr24M60NA4rHm0CBLCi2uWskRwAG3l7bQpC02htMxgQzv2UbTPb9vkkcYx4vKkFdZzSWYVLY6PmyysWj3uSArb2dwScT2Wt1X7Kx6eKmzY7pmKETj7YXWhH5mSTqyXwdt1HmD6UMbClqmTRTCwEgcYND24tBQI+PcWAGN7cbN87GLM0cRPsFZMuZU5U7qAd3zTibX6w+on9ArDG71VLfZZBtUT60x7KO5imLR9hUcihTQL3FE/4fbiMrNcIK59f4xEH/qCj7C7w/tET/8e6taHf3dvqZHwh9Cu3QkOJ/MCMFeTbivM3+Dm2xtO6BfjCrC/9JZCEH
 AsP92IE6
 x9xLCZnZ52wMCbfBN+K6CUQWdLeIuISfq3wHsAJYR+4lyCE0+Hzab3u/P93SsKDSYVXRvATji7RNlPEnQJNre45EsSXpkfMJ2FkZ+tnE8x9C0DPbj8aTPIUGcMgdxNQZxFjs3JQzJqyh/ZD5+MWBWwE5SvSvWlogxPKKmlgO/7BKo4H85Ay2RiRz700EhCWlPspC5kUxs0Pozuoh7JP7Hhd7R/KcgY761U74ouQIdSX4ccKPD5mlgjGbJW+NpYJGGNGKHJv3YGMG719EqdvBuY5/z04muuZPRhHDdNLBhYeI30nOcMUz13/8EaHzu5uKmGw4FKBulcJqVUk5TA43nDbB4Xrz+DfGJpzFy6ibgycHYwjWljvInnj5fYIBjn9RyoQd/0108gfLt/Va+5/CPQrZFiD67taf+SMQcTaDnjBys4ctEeuh3+bbdNA496NhVMf7IywXIG4JCYBwg85fJckIcVDzkyOTYYP6kL6CUFfkgJg1FH0EomKmqaLigaDngsVX9V3eYsD0WalO6lH0hO1yUFk2tlY06HBbKOhOhrnkp4QviAarI5d0Hni/2TzI93ovwlKSEIpTHIGPM5ukn7zlGusnCghodQrSMcMPgt7BapdaF2F4GwkiXmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
> CPUs passed through isolcpus= boot option. Users interested in also
> knowing the runtime defined isolated CPUs through cpuset must use
> different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...
>
> There are many drawbacks to that approach:
>
> 1) Most interested subsystems want to know about all isolated CPUs, not
>    just those defined on boot time.
>
> 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
>    concurrent cpuset changes.
>
> 3) Further cpuset modifications are not propagated to subsystems
>
> Solve 1) and 2) and centralize all isolated CPUs within the
> HK_TYPE_DOMAIN housekeeping cpumask.
>
> Subsystems can rely on RCU to synchronize against concurrent changes.
>
> The propagation mentioned in 3) will be handled in further patches.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/sched/isolation.h |  2 +
>   kernel/cgroup/cpuset.c          |  2 +
>   kernel/sched/isolation.c        | 75 ++++++++++++++++++++++++++++++---
>   kernel/sched/sched.h            |  1 +
>   4 files changed, 74 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index da22b038942a..94d5c835121b 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -32,6 +32,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>   extern bool housekeeping_enabled(enum hk_type type);
>   extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
> +extern int housekeeping_update(struct cpumask *mask, enum hk_type type);
>   extern void __init housekeeping_init(void);
>   
>   #else
> @@ -59,6 +60,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>   	return true;
>   }
>   
> +static inline int housekeeping_update(struct cpumask *mask, enum hk_type type) { return 0; }
>   static inline void housekeeping_init(void) { }
>   #endif /* CONFIG_CPU_ISOLATION */
>   
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index aa1ac7bcf2ea..b04a4242f2fa 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1403,6 +1403,8 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
>   
>   	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
>   	WARN_ON_ONCE(ret < 0);
> +	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
> +	WARN_ON_ONCE(ret < 0);
>   }
>   
>   /**
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index b46c20b5437f..95d69c2102f6 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
>   
>   bool housekeeping_enabled(enum hk_type type)
>   {
> -	return !!(housekeeping.flags & BIT(type));
> +	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>   
> +static bool housekeeping_dereference_check(enum hk_type type)
> +{
> +	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
> +		/* Cpuset isn't even writable yet? */
> +		if (system_state <= SYSTEM_SCHEDULING)
> +			return true;
> +
> +		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
> +		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
> +			return true;
> +
> +		/* Cpuset lock held, partitions not writable */
> +		if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
> +			return true;

I have some doubt about this condition as the cpuset_mutex may be held 
in the process of making changes to an isolated partition that will 
impact HK_TYPE_DOMAIN cpumask.

Cheers,
Longman


