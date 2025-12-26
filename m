Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A294E8FDB8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 23:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864DF6B0005; Fri, 26 Dec 2025 18:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BED6B0089; Fri, 26 Dec 2025 18:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745A56B008A; Fri, 26 Dec 2025 18:46:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 620D96B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:46:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1BAF5B5B8
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:46:15 +0000 (UTC)
X-FDA: 84263258310.14.5942DF0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48AAC1A0018
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:46:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GlHf+eut;
	spf=pass (imf19.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766792773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShTe7n4oL4bSFMstIf8qKgFQ8pgH2Te4INGSKID7CCk=;
	b=MMt9aCZ13ouCmowqkIvRnXJ2gVUXSiO5emFV+yYHvkjpTMICFThbUUKzGfrFGZ6C6LeLQc
	T54QBbm7Z6Nmv6H2iHv3EhO4FwKgHBZgvIot5zNGj846ffv81eZDH7aT4dSJgIq6ftDEpb
	6oqIsbrZbfN1SMkUnxRkl3MS/3oiBUA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GlHf+eut;
	spf=pass (imf19.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766792773; a=rsa-sha256;
	cv=none;
	b=HkdFExEa//ret8rYWpk5YJjXWeO86iGxI/QoWxMkW89+Ib3+VklhQAH4Px1jubeUCRTxqf
	Yq0LzkC5jN/bCV6jtew7RFB6eHH9kcXz/aFAbvm/0NvqlfBYKq16bX2hmq4E7AnHllHhS3
	DQk/IiO+cubZq9ECyoSyjG8Piz/uoI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766792772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ShTe7n4oL4bSFMstIf8qKgFQ8pgH2Te4INGSKID7CCk=;
	b=GlHf+eutlOjxN3/ITV2c+2mgU9hRwZu/aPJkOBi/RfAlUz3ExmJRuZHc/D/gm8U4vLuIWl
	nSPTXMw2/yVYHgOGUYW/nqWImJxzMlH9tcnIRXOKdChBmt9dzWISqT6bIbro9/M9lR9SKt
	kagMaXe2vJFXo9ESVHEj7t37GgBiM4I=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-TPbe4jKLNXmFjMnsL1VAdg-1; Fri, 26 Dec 2025 18:46:08 -0500
X-MC-Unique: TPbe4jKLNXmFjMnsL1VAdg-1
X-Mimecast-MFC-AGG-ID: TPbe4jKLNXmFjMnsL1VAdg_1766792768
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8823f4666abso184530856d6.0
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:46:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766792768; x=1767397568;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ShTe7n4oL4bSFMstIf8qKgFQ8pgH2Te4INGSKID7CCk=;
        b=n9S4EOmvCa6Xnye2Dbs3MQS6TGqilKfuWEYUiKngck3oYEH9e05/2QxxfLisGMk2T7
         kvqf8zhqXEAC27SsIxX9OI1GXLITzvwZxIJNDnaWht4JLiVJmhJSUxdhJ/Q9XInll2SK
         vpuuNLexKKVtp1iHWEnxnabEac7crcxtP1NHxqEZaMml9ebzRoS9DkuKiWfFK53EZQc5
         ght0LbubAOOZhvKFS1GTDGyy7MZkAEfdD8jCI9D6KiSpsLziZca9cF1ePhWeM4FKiQKj
         fjqrqvtzMf9zQmOdv1W+6ZV/d3fh6MsV+H09Dkrc0lNaGnZ0qglOphPNt+gsdgvOB2iV
         KJ+w==
X-Forwarded-Encrypted: i=1; AJvYcCWG+qFHmUd8+NKvwRs+9eUY4FNjwOaP7j9kxMsJ6cxNmtMgDOJITFqsQmq1tMXZWeWUx/uLhwAEfw==@kvack.org
X-Gm-Message-State: AOJu0Yz6GIsVj8gMWr+bVjvTbxepiBosRWqaVo0XBjvdQ8td39ivBduc
	zbqctYkT8DvX0X/xoxEDGhTzC1LhqcMLYEF3ldOmyu1axUrexG3WsuZKWfDI0bEVikSQJsKiG41
	2YBc3D3i9VJubvKZe0U1rAap5JWnsRknN0WJEIeIM2BfPMzuw0Hp1
X-Gm-Gg: AY/fxX7GovZEFNp2Kgw0fFb5imL2auFyjwaglIT+E7UzXKYvAV0MI7kiRdRgXu1TVL/
	vJ7QgZHGGM5vTo+xVNzzZq4ml6hBWzINRT4i08FFKvxt1omZFmV/xhPLOopaYIIpSVN4A08UaVG
	bxCWN0aw18H1sSYVAo2iY3H8Bc1glECCiR9jGiozVwobS2OGeI/aDvbvs7RemnHJkGlhVaQZlDJ
	w3LrJGIy0/p6VDSGZD3roN2IeNrdga1SQww311X0NI3o9Dctajcjvuk69BXTo6wTvXGz52YkKxu
	3Ug0vTtjv7IzAa7had/Zir5M2YByrUGG0MaqaVvM2zTnozzenhwUxYlu1OO2DKXQGa93kEjqrqy
	CHM4LHwSntjEysUoxheY+pd89EH8aXXCCu+XgEifPmxWed6jkQydh7Q5D
X-Received: by 2002:a0c:d783:0:b0:88a:28b0:9192 with SMTP id 6a1803df08f44-88d8379509fmr260893986d6.33.1766792768268;
        Fri, 26 Dec 2025 15:46:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHI+6C/nsqBk+pm7eqUDmS5eTPjEpCYiybmbNsgHAySbpZ0KGnAPETFvs9s0xhCfd6CKDIFSA==
X-Received: by 2002:a0c:d783:0:b0:88a:28b0:9192 with SMTP id 6a1803df08f44-88d8379509fmr260893766d6.33.1766792767734;
        Fri, 26 Dec 2025 15:46:07 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d997aedafsm176932106d6.31.2025.12.26.15.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 15:46:06 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <19b001a4-0696-4efd-aaa3-902ffa42ff9e@redhat.com>
Date: Fri, 26 Dec 2025 18:46:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 29/33] sched/arm64: Move fallback task cpumask to
 HK_TYPE_DOMAIN
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
 <20251224134520.33231-30-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-30-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fsA50UDoUR8PaDhoVUcOdXv5iaAM9u-NU6WxHKnXJOQ_1766792768
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cabfmqqggzdhdj3hs3t4ad1s85pbyb1f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48AAC1A0018
X-HE-Tag: 1766792773-205393
X-HE-Meta: U2FsdGVkX1/Eq33za0tLINzev4c1omql1ZPGwzNgTo4ltNm2QvIEu6jLPyq4KIvGXypb0oKZp3+ubtSF1SAdyhuHXdVZHhJ+0u6ipWVUBjQT/3TM6uvNVoeEwqy1uLL9whsBxWZTtOC5w/jlMgFoNEGpoiQpUpxPKEw8aiNJFevUeq5u8CnCYFvL+Cf8G/XomDUVK87of9CNP3fFHTaN9vF+TXFcdo1p17ZLTFMUtvLVI2qmVkSNranQGyMdDTsdmxegEFqMiuy6gnk8JO0Ftea9P/+TL27ix8c7zLMb1s1YBv2HFCQ5KlOVDHPJKiyjdlqwDhqGo/F+iLoiUZNQ0wtxbVBqG9V0zkNjCxD7JHgKur/sbZ8LuSA/9tgNwFusAXOJW2RMwaawTRj1WF11+SyC7jBcqIefhnaAzU2dNheGSfXpdyxu5mG8zMB53G5qYGgLe2W3FFNdjoPGLNm5JQ2p28XTP3Y4+6V85JaUd+L78m4UZ/0J/ZCTqpWrKf/VgUiY3tfJntNgfpEHc6KHId3ejozey8Dqhi5lM6Tmc28yQ4j1GWaJZF6UMF25wDWbLzV/TKQrUtcV+47RsdO5Ce34NjD0rDuUHKQjlur+UrVmfJVVCMRHwX8ULWZX15a91mu6Ez5qBhJPjUa6d8D8hy+TmTSB5f1bVWierlbTOTsZU8JHGfR6d2kH07DtUmvZd08zZYchGVBI+sZAaiMN3xZYFmg5aCjUy2SxC4MLgUDRd+TFEKF9B6/JoRYZiBcYpdjKgIA2/4sMppf/itXyNNWaFPUh/jvM6tOJS+PkResfBCbHgW9HQTVzR95tzUNAMr9xBv3HrYv/LKFi60OrA9WfaeTHWgmx9QpGP4vU7Ec3GCyAdVMyQBtJ41wV9sU//vdUUw5AeTpbxPj8IxLT3ZAyzFLEWkN2KHAJ1J4Z2y4SHShKXN8u3HnCp5Fq2ex0ebZe/nZOLprJcFYeusQ
 OcQliLij
 oXqxPJP4o4AYZwMaOEzkdjn4oP83wBPk8k1aepDygsHtaOFF0Jd9nxch/edlrDpDTmmMAwW/0JJ9JPT/irnndYEG0rrnikci3r7EDCbvmqu8hFIkpiKQUq+QVgXvK0BZ6AYYEHcn5mj3DfRfHqjyfyZ6DMBSthtaksimj7bSVvhQ7jqr+38+VcdjA/I3tVGckupbzIIzCTdn5MwvFgjkr7NUhn4yZKlAYv/nkIBxjKpYjhPiSDfBbRfP5u9aO780RdXu75wC5ga1qmf2boOVkruSz1DEXWdwqj7STtrCfDBTcrooie/d/gRta2f1k9U7CD/jK1hDvA/cNycmzHU7PjdVkmZ/5MuefwPPkcALpQaRojuTNo+koiU9gbyPCUlYl2EgrwaJURG9Kf/FUcnwasYgT2uRZ/IH24daBsu/AqrDeZT5wmoJCVDzVAflpTqhVyZdy8kOVG4ZS7LjHgKzPrvzqdfjaPrh0RjCjNhI3cRG6M5RS3mwS1dhyxWhBXhIcAGGq5k5CeU+0qPjjW4QFr5tQSA6QYa+GWnSHFR9NfxQZGMnMXc6wRwAo4Ix/ZJcMsT1KqRtqo+LZ8m9tP0sUHfMt4hUe7aUA4JiGZvoDb5L0HWCHUhl41bsm3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> When none of the allowed CPUs of a task are online, it gets migrated
> to the fallback cpumask which is all the non nohz_full CPUs.
>
> However just like nohz_full CPUs, domain isolated CPUs don't want to be
> disturbed by tasks that have lost their CPU affinities.
>
> And since nohz_full rely on domain isolation to work correctly, the
> housekeeping mask of domain isolated CPUs should always be a superset of
> the housekeeping mask of nohz_full CPUs (there can be CPUs that are
> domain isolated but not nohz_full, OTOH there shouldn't be nohz_full
> CPUs that are not domain isolated):
>
> 	HK_TYPE_DOMAIN | HK_TYPE_KERNEL_NOISE == HK_TYPE_DOMAIN
>
> Therefore use HK_TYPE_DOMAIN as the appropriate fallback target for
> tasks and since this cpumask can be modified at runtime, make sure
> that 32 bits support CPUs on ARM64 mismatched systems are not isolated
> by cpusets.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   arch/arm64/kernel/cpufeature.c | 18 +++++++++++++++---
>   include/linux/cpu.h            |  4 ++++
>   kernel/cgroup/cpuset.c         | 17 ++++++++++++++---
>   3 files changed, 33 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index c840a93b9ef9..70b0e45e299a 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1656,6 +1656,18 @@ has_cpuid_feature(const struct arm64_cpu_capabilities *entry, int scope)
>   	return feature_matches(val, entry);
>   }
>   
> +/*
> + * 32 bits support CPUs can't be isolated because tasks may be
> + * arbitrarily affine to them, defeating the purpose of isolation.
> + */
> +bool arch_isolated_cpus_can_update(struct cpumask *new_cpus)
> +{
> +	if (static_branch_unlikely(&arm64_mismatched_32bit_el0))
> +		return !cpumask_intersects(cpu_32bit_el0_mask, new_cpus);
> +	else
> +		return true;
> +}
> +
>   const struct cpumask *system_32bit_el0_cpumask(void)
>   {
>   	if (!system_supports_32bit_el0())
> @@ -1669,7 +1681,7 @@ const struct cpumask *system_32bit_el0_cpumask(void)
>   
>   const struct cpumask *task_cpu_fallback_mask(struct task_struct *p)
>   {
> -	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_TICK));
> +	return __task_cpu_possible_mask(p, housekeeping_cpumask(HK_TYPE_DOMAIN));
>   }
>   
>   static int __init parse_32bit_el0_param(char *str)
> @@ -3987,8 +3999,8 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
>   	bool cpu_32bit = false;
>   
>   	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0)) {
> -		if (!housekeeping_cpu(cpu, HK_TYPE_TICK))
> -			pr_info("Treating adaptive-ticks CPU %u as 64-bit only\n", cpu);
> +		if (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN))
> +			pr_info("Treating domain isolated CPU %u as 64-bit only\n", cpu);
>   		else
>   			cpu_32bit = true;
>   	}
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 487b3bf2e1ea..0b48af25ab5c 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -229,4 +229,8 @@ static inline bool cpu_attack_vector_mitigated(enum cpu_attack_vectors v)
>   #define smt_mitigations SMT_MITIGATIONS_OFF
>   #endif
>   
> +struct cpumask;
> +
> +bool arch_isolated_cpus_can_update(struct cpumask *new_cpus);
> +
>   #endif /* _LINUX_CPU_H_ */
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index cd6119c02beb..1cc83a3c25f6 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1408,14 +1408,22 @@ static void partition_xcpus_del(int old_prs, struct cpuset *parent,
>   	cpumask_or(parent->effective_cpus, parent->effective_cpus, xcpus);
>   }
>   
> +bool __weak arch_isolated_cpus_can_update(struct cpumask *new_cpus)
> +{
> +	return true;
> +}
> +
>   /*
> - * isolated_cpus_can_update - check for isolated & nohz_full conflicts
> + * isolated_cpus_can_update - check for conflicts against housekeeping and
> + *                            CPUs capabilities.
>    * @add_cpus: cpu mask for cpus that are going to be isolated
>    * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
>    * Return: false if there is conflict, true otherwise
>    *
> - * If nohz_full is enabled and we have isolated CPUs, their combination must
> - * still leave housekeeping CPUs.
> + * Check for conflicts:
> + * - If nohz_full is enabled and there are isolated CPUs, their combination must
> + *   still leave housekeeping CPUs.
> + * - Architecture has CPU capabilities incompatible with being isolated
>    *
>    * TBD: Should consider merging this function into
>    *      prstate_housekeeping_conflict().
> @@ -1426,6 +1434,9 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
>   	cpumask_var_t full_hk_cpus;
>   	int res = true;
>   
> +	if (!arch_isolated_cpus_can_update(add_cpus))
> +		return false;
> +
>   	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
>   		return true;
>   
Reviewed-by: Waiman Long <longman@redhat.com>


