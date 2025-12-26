Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C228E8FDB5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C1A6B0005; Fri, 26 Dec 2025 15:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549B66B0089; Fri, 26 Dec 2025 15:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401176B008A; Fri, 26 Dec 2025 15:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3AC6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:48:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAA48138AF7
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:48:17 +0000 (UTC)
X-FDA: 84262809834.08.A4F3E16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8238C40005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:48:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UL7mCRwv;
	spf=pass (imf11.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766782095; a=rsa-sha256;
	cv=none;
	b=nerHK5h1fHoSO29NfRw4OrLWpERhdlp1sUc+b2jarVLWS2ZlXYRjUbO6iWAQ9YOtxY6Aab
	KCjc+/JnogDFH5bQmSkwY/OwLPr0pD5bnt8nfe3AQ0C4knhHP0HBA8pyvh9sYuJMIl0ppI
	js0bwTbUNmhl+2UZJc3a2FJItznZKiE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UL7mCRwv;
	spf=pass (imf11.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766782095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RM8xUWiPB1W0MgA0qXcU7NgXtzuyc/5Zx2MgNVttglw=;
	b=6B3ztqdEtifbqPtwVi67EbZMAg9w4CE5IaCjCmSFcMo9GKVu+7joatpKJEyJ46FYslEAVS
	oGOD26SfKv6kEmop/Tghh8kFbZDWfUdruuGJ9pwMrOLxog0LuAD9ju5sc3mH87qMmY2f0U
	N3hoMOuTLMG2s8xLjpMw2c7LjDV3E5Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766782094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RM8xUWiPB1W0MgA0qXcU7NgXtzuyc/5Zx2MgNVttglw=;
	b=UL7mCRwvXajXTM3u8Gta/Lx9ZUxFGRdcPjC/VpyvHcIbIpHcWF+xQgS6kqcblM5dWuXIDM
	KxwrAQhNKVjPP9BxAftlPnEBcvaL0+aOPfCk6f+y3zrZ3Ot3oK5rkztGqS+RTrOhsRlIVl
	JgXTSa9kPhCambZdfFzoGJBW6M5GHpg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-tzQgWnlOO9GBbEYzXO598g-1; Fri, 26 Dec 2025 15:48:13 -0500
X-MC-Unique: tzQgWnlOO9GBbEYzXO598g-1
X-Mimecast-MFC-AGG-ID: tzQgWnlOO9GBbEYzXO598g_1766782093
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8bbe16e0a34so1828357485a.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766782093; x=1767386893;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RM8xUWiPB1W0MgA0qXcU7NgXtzuyc/5Zx2MgNVttglw=;
        b=o45dX7WEZe/ave5ZddXb94D88vX9qBoH6b6lJlsJ1D/4pVNidV9iDGVSj8mGn6Jv6h
         NvDHllQhUW/yru0x8GwzBSge9ig/dRyjbwRnqjYOJwsoJxv6tBEm/O6T8IBBaLcJYBRr
         tkFJIPKulIcO5S2a3OtSFPRLgOEJBguRKk4Yx9XegjysrRTs24MaGHNrGDnl2y12vyO7
         rsR58NyidE1RAVquNDT3pa43NnvhnWD+h0kSMDcMeeRC2NdDMSfWuLMNIagumG/Z6xoA
         nOP42g0LDEMVFwcFKTQtA4IW568mYJqPuWWumY8Dvo12R3hqIi9M3tXrsFfnnVlvVlOf
         kjzw==
X-Forwarded-Encrypted: i=1; AJvYcCVzZAgqO/UVDnDFPkgYyaESpxr8wJ/O+3DQyEVRkXFtNnFAe6OkkqFfU27HastO2KKLq5iv9zkJjA==@kvack.org
X-Gm-Message-State: AOJu0YwlBwxL5w6f6mYJPQSyTjjLejUSdjMup8Oe5XN+IMk3LOq/+GCF
	82vnUfJa47GUDZ23U8lAEqfOWsF78yQgseL+2cM2Q1y9SwUwt15VnoUbPwz4FQ75MqDR3cUh9A/
	apJNIK0EZ5R2emPEJj+7OTdQJc9sgLcLsf7kc4fVrSBxEhMVJkeUS
X-Gm-Gg: AY/fxX5iqA38ohNBTCOe9q/tlTYtXYFxzbAJ/5lYcktxYfwUTQ7ihonpnZzMyZApJeF
	jSz0154dN4IIDdlvSG+qloSAE06CT4aIWnWAuUWn/og5x8aaC8Dx5DiFvPcPOT1X7PI3EsWziyn
	5eFe6VUF9gz50fnPcAk+/b/2QfFjboCR9WT1U6wcosGOawE6wgMhaEoEm4ZChp718ZWoH5P3fTY
	DnjH2KTJU8N/+/TWRRzKS7WG2rS1BcoLWFRgAKzsklQsTtgQLEp0C0lIDUBq2zx+RRpGyiw9Oop
	eZK5GsFfOHwFX4K+wAPoQslBttV7vQU7F/cjL+nTAhw9o49F9VzgzEW0WKNyr643+9xtXPfOwB5
	fp7DCrcXJHwMz5x2B2WRCq9YzpbXP3Rb06Iw6PkQj+hxft/4aIlUJkjUs
X-Received: by 2002:a05:620a:4450:b0:8b2:f5b5:c9bf with SMTP id af79cd13be357-8bee76c8ecdmr4098089685a.22.1766782093292;
        Fri, 26 Dec 2025 12:48:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH5vt35jXazmAlmHnLRQK7CDf0928bdO3E07iE5exs1VnuKt+dhmYfT9Sq8ULHkPw+Z5ZFmhA==
X-Received: by 2002:a05:620a:4450:b0:8b2:f5b5:c9bf with SMTP id af79cd13be357-8bee76c8ecdmr4098087085a.22.1766782092880;
        Fri, 26 Dec 2025 12:48:12 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d96ce4e23sm205030136d6.19.2025.12.26.12.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 12:48:12 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <eb7920d4-bca6-4692-9b8f-7feb715a6ec2@redhat.com>
Date: Fri, 26 Dec 2025 15:48:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/33] cpuset: Remove cpuset_cpu_is_isolated()
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
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
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-22-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-22-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sptOH8syP-DNq_pVa_9SaHrjQxCXBjIXGMXtTT_45NM_1766782093
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8238C40005
X-Rspamd-Server: rspam04
X-Stat-Signature: xg8y77ttmc46hehemoy9q8p1bm1z3cdb
X-HE-Tag: 1766782095-252400
X-HE-Meta: U2FsdGVkX19Lc82j8MiQ6AtW/rq6hhyWVWr+YtpngVTNu4gAFULSCjOTLqXmDONPVEmcVrEbccyqgNnJCLIbYs1GtFmuASry2EWts7n+em5Qj/c0nbd2F16eVc8vBD6deHkd040vB0FW4HxcYLNG2Uv9U5PPwhjj77etBGHCo37qOSUC+rKe24fjFx5WCiXuw2zGDJu+NtUf/ZJV49l+Z4FbZkqH3/pKauJRNFR4avBWF+rFnFtW/N/MFH+TmiB7BmOWCKucAAjyV4mKm1NTjUgf57XeMyGAuYO7XCybUjuUYx8P5hvCwCVFe0nDarSvu15h2IOiqsYH69YWubRCjCdj4SpfXUWi9SjPwtPzCeC9ehMF1y0g87YoCIKzPf//LbuuuVDMiaaSVQu2vaEyCJfyWfV0UShdWLs1VJrVAmNHV5L/sqyQC9gruLuui6vuXA9SmTyxOcOB4HQTW6zkVh3lPu7dcqFRJA8kt/EcLuP0NE9Zsu7C4JskdWxK7MiCQBj31QMow8HR0x7rSZVNggZ88C6/P8pDxnrJyJKmXZylnt6i6U0SxHT3sICFLU5RdtjtlfdgUVDhTc5SsXDGDPmHnC8IeYS+GGF7RZefQHkoqQz2ZDeklzT+e4WSA1j9XlDUlbCG0Rmy/vuAwdj3drxSYfyOIYK8CMc2pzngmHNVsJIbRdeGgHyOeFMq+6rgMGA31xz/DdNzemcdWYMkN5HFFrZF+7/ARlKvSn2BBa5GpPLPOpV/bxB096Xm1uL1Utwg5ukkkSh4LmMKnrBv/EBtDDwtLR2IZQU/o11F5q5LwFi71zitRlyOX8x2TU9QiwuFKMma83q5PQa9/cqbualXXreGlLM1QaSSU4S6lBvYKMPMnAmglomx7/KkuDPXsDCdTCSHcMBa8OR/8sBNGcIUwZguwqwdBUPMmLTvMnNGGolSMuupIvU4tyQ/sa10DNx9GY0n8p1rzogBZmO
 qGPUDejt
 4+2PUMTKrWv6DTj1gFt6guTmFyjnoHrzTOggOOaCmrxufdiMcuFVS+K1qVQbQoNuaGukexUc+y9pd7cGlEkPuI0cP/BSCCZmJn1l/dGP2kpV+bS5Sj/Eq0WVTzEikYYbjGK4jPPHe3BhjFkml9o9zkB822Os0t987Bln+Oz/xMfJaqUWPu192U5T2rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> The set of cpuset isolated CPUs is now included in HK_TYPE_DOMAIN
> housekeeping cpumask. There is no usecase left interested in just
> checking what is isolated by cpuset and not by the isolcpus= kernel
> boot parameter.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/cpuset.h          |  6 ------
>   include/linux/sched/isolation.h |  4 +---
>   kernel/cgroup/cpuset.c          | 12 ------------
>   3 files changed, 1 insertion(+), 21 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 1c49ffd2ca9b..a4aa2f1767d0 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -79,7 +79,6 @@ extern void cpuset_unlock(void);
>   extern void cpuset_cpus_allowed_locked(struct task_struct *p, struct cpumask *mask);
>   extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
>   extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
> -extern bool cpuset_cpu_is_isolated(int cpu);
>   extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>   #define cpuset_current_mems_allowed (current->mems_allowed)
>   void cpuset_init_current_mems_allowed(void);
> @@ -215,11 +214,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
>   	return false;
>   }
>   
> -static inline bool cpuset_cpu_is_isolated(int cpu)
> -{
> -	return false;
> -}
> -
>   static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
>   {
>   	return node_possible_map;
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 6842a1ba4d13..19905adbb705 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -2,7 +2,6 @@
>   #define _LINUX_SCHED_ISOLATION_H
>   
>   #include <linux/cpumask.h>
> -#include <linux/cpuset.h>
>   #include <linux/init.h>
>   #include <linux/tick.h>
>   
> @@ -84,8 +83,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
>   static inline bool cpu_is_isolated(int cpu)
>   {
>   	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> -	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK) ||
> -	       cpuset_cpu_is_isolated(cpu);
> +	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
>   }
>   
>   #endif /* _LINUX_SCHED_ISOLATION_H */
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 25ac6c98113c..cd6119c02beb 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -29,7 +29,6 @@
>   #include <linux/mempolicy.h>
>   #include <linux/mm.h>
>   #include <linux/memory.h>
> -#include <linux/export.h>
>   #include <linux/rcupdate.h>
>   #include <linux/sched.h>
>   #include <linux/sched/deadline.h>
> @@ -1490,17 +1489,6 @@ static void update_isolation_cpumasks(void)
>   	isolated_cpus_updating = false;
>   }
>   
> -/**
> - * cpuset_cpu_is_isolated - Check if the given CPU is isolated
> - * @cpu: the CPU number to be checked
> - * Return: true if CPU is used in an isolated partition, false otherwise
> - */
> -bool cpuset_cpu_is_isolated(int cpu)
> -{
> -	return cpumask_test_cpu(cpu, isolated_cpus);
> -}
> -EXPORT_SYMBOL_GPL(cpuset_cpu_is_isolated);
> -
>   /**
>    * rm_siblings_excl_cpus - Remove exclusive CPUs that are used by sibling cpusets
>    * @parent: Parent cpuset containing all siblings
Reviewed-by: Waiman Long <longman@redhat.com>


