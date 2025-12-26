Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E46E8FDA0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 08:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6C76B0088; Fri, 26 Dec 2025 03:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85966B0089; Fri, 26 Dec 2025 03:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83CF6B008A; Fri, 26 Dec 2025 03:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7E626B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:08:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 532CC140D0F
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:08:17 +0000 (UTC)
X-FDA: 84260894634.24.BEADBEE
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B98416000D
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:08:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766736495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MpJckKNv2j56gJFGymtcEtW3GfgdYb7KZdYSWwFtx7c=;
	b=0064qa7CnUmiHEMAnJmTwfpkDTWLs95XX6xuNSwb4jVVhkt8tNOap65qROgU6m++XSkKVG
	79TjqAfRQ1ijz+OY8P1JVaYOrrRekZsM56olaaOC6MjAVQr4V7zRC49/s4dGbD30Gydxdw
	4b9d8rWbpWmcs9QfLHe9vYojyG/oPWQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766736495; a=rsa-sha256;
	cv=none;
	b=gZt+XEdNNmC9o4G63wsbxiusIuSSwssb1hHGfp2jhRPOupf0krbhuDbre456uj37IdtEV2
	rkMvwDYZDvpjC4HpGinWJb9+QqvsR6MsYTEEOZVf5vmQUXw2HrlDhnIDpwh/6MVrCYo8oQ
	eGYDS+9q5TxeoMmmv/jbxciXV+t96lc=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcysC53RZzKHMS0
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:07:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4272D40573
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:08:06 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgC3F_hkQk5pH4QgBg--.51308S2;
	Fri, 26 Dec 2025 16:08:06 +0800 (CST)
Message-ID: <8ecb22ab-d719-44b4-ad40-5af0a185682a@huaweicloud.com>
Date: Fri, 26 Dec 2025 16:08:04 +0800
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
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-15-frederic@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251224134520.33231-15-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC3F_hkQk5pH4QgBg--.51308S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WrW7Gw15Xr43ury3Gr4rXwb_yoWxKw4fpF
	WDWrWfGF4DJr13G3s8Zw1DAr4rWwn3Cr1kK3sxWw4rJFyIg3Wvvry09FnxXr1ku3s7Cry7
	ZFWY9w4S93WjyrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUVZ2-UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam02
X-Stat-Signature: d5drqbkjc3yfmar3d5pwzbq18o1i55s8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B98416000D
X-HE-Tag: 1766736492-64609
X-HE-Meta: U2FsdGVkX1/tWUYcGnCue+L49tVlpYs4gONx35Q3qlV9DCf7c0NxIFk16q9fOSQ55TrDdQQtJosrFKSFbNpJ6XZzgztNqGgpUd8oFXpNLlzWuRQovdqYysp6OxEqB1sZCqr5tt7DVl0EqILkp4zc+nVelNV2ddXwJUhIoMZSVWJhE2a2wy0MT8SNAmkWA3QU8OMrB4i+PmZKEI1EKOcnNHmGBBvqMpS/cK6nOJwijcrzQ+oWeWEqmKIBDU+JH74igQ/kxYmz0nuf3LI8yH1njYL74/tEekrZbmp/bECgs+6UO6R+VIDz9fPDPh55auXsW+GPYa96oGmjJ2av4aZRj1sV7BtzTg1iJ6dJr1JqcqFRxLwFDEBw1KTL3snwIvvNEAAjzgoTgSvnJaGBhOLseJMsKVkqehySJlTTwXGTseN8+yroMmTzrCpoYrIC3WXkRhSgXGR+u/YlOuJgPYQpqrDcDa1IF9MZsvIHNn+qZ1w39yRAb3j/+Jn05rB6PC5ctKJ0LA25r4VRJMHNa5Eeo/TOH8gier/h9KMQ8ej1x2l7aHKCUAi5zvDfLxa5ToxdoY5B5jkgGxdhzgsuC/3lp/AqTrd/S0EwKPHf186XJnjnD1qKtAKA7Bq2FTyI8TarMj1/MVfU69GV97zuD3aMxP+qG6qGvuF/tmn+zTsbsTRbkmbls66OElJgnL03mNqXQ1TJPGV55Vdjvf1JgUdPfxvTViY/0Lujtrj6tCIztSiIFKBNCQ3g2oJMlRqVDEgyvKA3SmN9YKTV6PKxsQ4f01lurPT0M4w14K48cCSiDRC5StSzSYIDqr6fbRGY76NscOr5cTcC1IVIHiUlm2UPjYylNNY9s+8Y79tdDaIUFDibjnPg4CweWMIF77RAQWOC66dGeMKYbAHOFqX74lA+YiSoMccTVWQ5bzdyyBysmjDsRClMNxE/F7xb5S/sQ11axPUgdoc+6rvdEjfjPtV
 1Aa+mqX8
 KSzQqA5uKEFtGwxO6CE0JG7QUdLvC+RuKq+l8Ek4SDn3HL7KcZSwWgDYxHm6yjdMhAq/4FuaEwxdsbNCX0vcfBB2iSysZPR+FYYWnNfPrfi1ZYgEiKgdAfXZkLDi48G+xmH3tsBPs9os//AyBqPR5dK+lIwO0DGWm+vZoq0J/y3wwsdnTgc1cpZElDh0cPNyjzqh6YPXoEMZPEgSlovJgBhQTgXsIDHQ1l9ykBBvcRHJdldZkFtRfiU3GwehabL1W9YNb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 21:45, Frederic Weisbecker wrote:
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
> ---
>  include/linux/sched/isolation.h |  7 +++
>  kernel/cgroup/cpuset.c          |  3 ++
>  kernel/sched/isolation.c        | 76 ++++++++++++++++++++++++++++++---
>  kernel/sched/sched.h            |  1 +
>  4 files changed, 81 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 109a2149e21a..6842a1ba4d13 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -9,6 +9,11 @@
>  enum hk_type {
>  	/* Revert of boot-time isolcpus= argument */
>  	HK_TYPE_DOMAIN_BOOT,
> +	/*
> +	 * Same as HK_TYPE_DOMAIN_BOOT but also includes the
> +	 * revert of cpuset isolated partitions. As such it
> +	 * is always a subset of HK_TYPE_DOMAIN_BOOT.
> +	 */
>  	HK_TYPE_DOMAIN,
>  	/* Revert of boot-time isolcpus=managed_irq argument */
>  	HK_TYPE_MANAGED_IRQ,
> @@ -35,6 +40,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>  extern bool housekeeping_enabled(enum hk_type type);
>  extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>  extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
> +extern int housekeeping_update(struct cpumask *isol_mask, enum hk_type type);
>  extern void __init housekeeping_init(void);
>  
>  #else
> @@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  	return true;
>  }
>  
> +static inline int housekeeping_update(struct cpumask *isol_mask, enum hk_type type) { return 0; }
>  static inline void housekeeping_init(void) { }
>  #endif /* CONFIG_CPU_ISOLATION */
>  
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 5e2e3514c22e..e13e32491ebf 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1490,6 +1490,9 @@ static void update_isolation_cpumasks(void)
>  	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
>  	WARN_ON_ONCE(ret < 0);
>  
> +	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
> +	WARN_ON_ONCE(ret < 0);
> +
>  	isolated_cpus_updating = false;
>  }
>  
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 83be49ec2b06..a124f1119f2e 100644
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
> @@ -80,12 +110,46 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
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
> +int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
> +{
> +	struct cpumask *trial, *old = NULL;
> +
> +	if (type != HK_TYPE_DOMAIN)
> +		return -ENOTSUPP;
> +

Nit:

The current if statement indicates that we only support modifying the cpumask for HK_TYPE_DOMAIN,
which makes the type argument seem unnecessary. This seems to be designed for better scalability.
However, when a new type needs to be supported in the future, this statement would have to be
removed. Also, the use of cpumask_andnot below is not a general operation.

Anyway, looks good to me.

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
> +	if (housekeeping.flags & BIT(type))
> +		old = housekeeping_cpumask_dereference(type);
> +	else
> +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
> +	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
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

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


