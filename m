Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE7CCC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246A66B014B; Thu, 22 Jan 2026 06:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21ABD6B014D; Thu, 22 Jan 2026 06:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D576B014E; Thu, 22 Jan 2026 06:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F309E6B014B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:24:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58BB5B6B6A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:24:27 +0000 (UTC)
X-FDA: 84359366574.21.E9CF46B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5AA2920010
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:24:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ssCR9rekeOFHqHIas+Lv4pWQ7j/xMygJZgQfWbqcXY=;
	b=Ve+RoWLJHQELpjDWLQWWIpOifreKC0Qu6BEPVsvvCZjE3GHetNzdwcNmMQb0EN/JK8+oN0
	3W2SRJ0wELI+A6xtw8ihtLxqthIQWZ+4VbEaX0OcM6z4ft+mcXHQUPpO7fLM5Tzy1IfUSX
	MZ2NTMJbOHy7hNjfrU4ZdF00QtAUF1M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081065; a=rsa-sha256;
	cv=none;
	b=Wiqu3U22cyCiPd+Rq5tJml1y3mL+OkedkOTCc/BCnhXAJtOpe/Fk954OV9QCDe8nCYSHnP
	7V40A+US6M5sWXdf8WuSjzD6Ab4sUjMgg80zZXoxg5kPjJ4t0L3YWREgKixMCTyHDN/C4L
	zI6iQBO0sNEahf56Iw4NXNyaKHlDI3E=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dxdxR72tMzKHMZ5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:24:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2FF634058D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:24:15 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBH9fXaCHJpzfXUEg--.64027S2;
	Thu, 22 Jan 2026 19:24:12 +0800 (CST)
Message-ID: <fa4764db-430b-403c-a085-b71e3777ac5e@huaweicloud.com>
Date: Thu, 22 Jan 2026 19:24:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
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
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20260101221359.22298-1-frederic@kernel.org>
 <20260101221359.22298-15-frederic@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260101221359.22298-15-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBH9fXaCHJpzfXUEg--.64027S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WrWxAw4kJF4DJr1kCF1Dtrb_yoWxtFWfpF
	WDWrWfGF4DJr13G3s8Zw1DArWrWwn3Cw18K3sxKw4rAFy2ga4vv3409FnxXrykZr97Cr17
	ZF1Y9w4S93WjyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j6a0PUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam11
X-Stat-Signature: o3jbx9h6m84q1csjbhw5kae4k7nyodzb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AA2920010
X-HE-Tag: 1769081060-483797
X-HE-Meta: U2FsdGVkX1+a9kSSya/6wF9nHUxH1zoeNKP3TyH4DFQ4gro0QGff7TinUR3SyQBpAdDyLzMLhXnIM2ILWksHyydqid9LfMp/7+7bg98bQ9nXyAPv0rmejbvMfUvoYQPGLheFpYAZCiVa0R8mQV1bO8IIabwVU/1TDmQkksNrhUFtW6LFDoVFA1WqNNWd8JX0/uwZn3CfqkVjBscPySR7JjVfyFSmvKM23fYE5dTyUABMzHy7m8Gj970ewXOESn+GZOuQT0BCdndyH/kr1HLhTrm+VmYtf+dWdyB48cVX/T1la7rATt8SXGXae/nWXrOSvBvpoYNo5nV2fAS/HCQwEWHFVnyXlvYNkUrB/MdTNLT+/K1D+IF3ceIc+5mhwzrL0EbU/ANVFFb4c0eYg6v08YureH1oT3UWLh7NI+MbwU9sOTrNMY3z4STL0A3Kz5LIba+om7Ch62UenzAFSkgF28zh+jUHk/ZvZHW0PKkh7g7+7ZsDho8+NPmgQ6L+wiTlpSFnv/c/cBOGZ7+RrorCj6Eqt2ZM6iAVUmhq80F0gpsOmO9qSEF/mgG8pYUE7MpAYQMs3YXxcprh3wVvh8oXzFcYhVa58hbNGNG176I+eAQrlEUDz7t/l5lGlJ8+RF1f9vCrNoVWchW6EEdFyufX04BvG1xwyVRrq0LPNrKqCZqloO7DFzgjRV55e/snROs+G4pBGb3EKuBA1osgTylzn14qoJ5i1P74kQCcBCv9tC/VaArhTLmJF2SslEDkI3AWUx4uJl5CQo0R+pqqKiO5RTiewt/agiUuCnb24SFqfacWSuOJgpUcFhZBKQ9jwVsQSaTZjs85oe5wsle1BUwaWB/5oxz2O+tWd1KkuarOEvRGNpke7d+3HXxB3kfxuyFcL73rWG4S207wpS4Q2y4heUNHB7ezKqlsvuNTan01M6f9hP1Ac3i6iGWr3RLFHqm4lSTpti4yBDUjmShY91R
 PLLWfsX+
 yQMQzWSC25tE0Plyxj3G9KQr98LACK7TlbtD2/duyC8cHnfwlvjqPciuNbPSRKT/XZ/jN0CpjIYfve9B0koGzR1ufyDzH0ZXzOpGgDQBKxjde6DILLjx+imINFxZxYfaclG+E0eDxML/irSfMsgamMF/ggglv+TSU6QwJQWec6RlVjDaLS8Gkwlmf5bVL22AFm8K5c12WCEpk3cTWjWO6hfVughFiU5+linxzci0S4/bZ9FWnnx0bojNETOgbTlx9ghJC/PsKcIvlD8eyRS0+SBmEhaDKJXls76pJImSRkTI6LmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/2 6:13, Frederic Weisbecker wrote:
> Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
> CPUs passed through isolcpus= boot option. Users interested in also
> knowing the runtime defined isolated CPUs through cpuset must use
> different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...
> 
> There are many drawbacks to that approach:
> 
> 1) Most interested subsystems want to know about all isolated CPUs, not
>   just those defined on boot time.
> 
> 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
>   concurrent cpuset changes.
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
> Reviewed-by: Waiman Long <longman@redhat.com>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>
> ---
>  include/linux/sched/isolation.h |  7 ++++
>  kernel/cgroup/cpuset.c          |  3 ++
>  kernel/sched/isolation.c        | 73 ++++++++++++++++++++++++++++++---
>  kernel/sched/sched.h            |  1 +
>  4 files changed, 78 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index c7cf6934489c..d8d9baf44516 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -9,6 +9,11 @@
>  enum hk_type {
>  	/* Inverse of boot-time isolcpus= argument */
>  	HK_TYPE_DOMAIN_BOOT,
> +	/*
> +	 * Same as HK_TYPE_DOMAIN_BOOT but also includes the
> +	 * inverse of cpuset isolated partitions. As such it
> +	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
> +	 */
>  	HK_TYPE_DOMAIN,
>  	/* Inverse of boot-time isolcpus=managed_irq argument */
>  	HK_TYPE_MANAGED_IRQ,
> @@ -35,6 +40,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>  extern bool housekeeping_enabled(enum hk_type type);
>  extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>  extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
> +extern int housekeeping_update(struct cpumask *isol_mask);
>  extern void __init housekeeping_init(void);
>  
>  #else
> @@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  	return true;
>  }
>  
> +static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
>  static inline void housekeeping_init(void) { }
>  #endif /* CONFIG_CPU_ISOLATION */
>  
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5e2e3514c22e..1c0475e384dc 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1490,6 +1490,9 @@ static void update_isolation_cpumasks(void)
>  	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
>  	WARN_ON_ONCE(ret < 0);
>  
> +	ret = housekeeping_update(isolated_cpus);
> +	WARN_ON_ONCE(ret < 0);
> +
>  	isolated_cpus_updating = false;
>  }
>  
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 83be49ec2b06..c61b7ef3e98e 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
>  
>  bool housekeeping_enabled(enum hk_type type)
>  {
> -	return !!(housekeeping.flags & BIT(type));
> +	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_enabled);
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
> +
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static inline struct cpumask *housekeeping_cpumask_dereference(enum hk_type type)
> +{
> +	return rcu_dereference_all_check(housekeeping.cpumasks[type],
> +					 housekeeping_dereference_check(type));
> +}
> +
>  const struct cpumask *housekeeping_cpumask(enum hk_type type)
>  {
> +	const struct cpumask *mask = NULL;
> +
>  	if (static_branch_unlikely(&housekeeping_overridden)) {
> -		if (housekeeping.flags & BIT(type)) {
> -			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
> -		}
> +		if (READ_ONCE(housekeeping.flags) & BIT(type))
> +			mask = housekeeping_cpumask_dereference(type);
>  	}
> -	return cpu_possible_mask;
> +	if (!mask)
> +		mask = cpu_possible_mask;
> +	return mask;
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_cpumask);
>  
> @@ -80,12 +110,43 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
>  
>  bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  {
> -	if (static_branch_unlikely(&housekeeping_overridden) && housekeeping.flags & BIT(type))
> +	if (static_branch_unlikely(&housekeeping_overridden) &&
> +	    READ_ONCE(housekeeping.flags) & BIT(type))
>  		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>  
> +int housekeeping_update(struct cpumask *isol_mask)
> +{
> +	struct cpumask *trial, *old = NULL;
> +
> +	trial = kmalloc(cpumask_size(), GFP_KERNEL);
> +	if (!trial)
> +		return -ENOMEM;
> +
> +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), isol_mask);
> +	if (!cpumask_intersects(trial, cpu_online_mask)) {
> +		kfree(trial);
> +		return -EINVAL;
> +	}
> +
> +	if (!housekeeping.flags)
> +		static_branch_enable(&housekeeping_overridden);
> +

The cpu_read_lock is held outside, we should use static_branch_enable_cpuslocked
here, since static_branch_enable acquires cpu_read_lock.

I have sent out a patch to fix this issue.

https://lore.kernel.org/cgroups/20260122080902.2312721-1-chenridong@huaweicloud.com/T/#u

> +	if (housekeeping.flags & HK_FLAG_DOMAIN)
> +		old = housekeeping_cpumask_dereference(HK_TYPE_DOMAIN);
> +	else
> +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | HK_FLAG_DOMAIN);
> +	rcu_assign_pointer(housekeeping.cpumasks[HK_TYPE_DOMAIN], trial);
> +
> +	synchronize_rcu();
> +
> +	kfree(old);
> +
> +	return 0;
> +}
> +
>  void __init housekeeping_init(void)
>  {
>  	enum hk_type type;
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 475bdab3b8db..653e898a996a 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -30,6 +30,7 @@
>  #include <linux/context_tracking.h>
>  #include <linux/cpufreq.h>
>  #include <linux/cpumask_api.h>
> +#include <linux/cpuset.h>
>  #include <linux/ctype.h>
>  #include <linux/file.h>
>  #include <linux/fs_api.h>

-- 
Best regards,
Ridong


