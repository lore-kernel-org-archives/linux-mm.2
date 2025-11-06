Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487F2CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 00:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798058E000A; Wed,  5 Nov 2025 19:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748A68E0002; Wed,  5 Nov 2025 19:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6381B8E000A; Wed,  5 Nov 2025 19:55:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52E628E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:55:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0360E160501
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:55:53 +0000 (UTC)
X-FDA: 84078365028.04.9F970DB
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id BAFDF120010
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:55:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762390552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fdud6Af6QFa80GpoOe7qsT4fksOHxjr5FcjBbY6W6m0=;
	b=3mMGJWxJHm0kIi65SfdvCEONai2NZsvRmnwPHj/RRWT2X9Xg1m1i6IXW/CzILVDyFQ63KS
	pEmECZtkIEmCTsHeGh1zUZewlYHMjebCT18HJxWNH1BPp2yPYCd9LZW+CXbBIgPg8Urycu
	AmwvvZYpuzY1OwBhzIpi5Gc9ovYsAfc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762390552; a=rsa-sha256;
	cv=none;
	b=apI9yW2nWVgB7naYlA1gy/49MHVgV9nZtLvVaUH/y+1zf0qMOen7FpCPRqHCzsP1r2N7AG
	FzQ2yVJEs0vcx8me3N69Z+rWQk71IDX+neBnF549F2ZjrHsquQKHscXDX0nzwxGgU8YRQV
	+nOY3MKA9vsdPK0+USpWxmno5FYfkzs=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d23dW5vWRzYQtld
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:55:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5ECC71A01A2
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:55:45 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgDXR0sO8gtpxr9CCw--.11206S2;
	Thu, 06 Nov 2025 08:55:44 +0800 (CST)
Message-ID: <e0b3f050-ef2e-478e-9e22-5f800b86ee42@huaweicloud.com>
Date: Thu, 6 Nov 2025 08:55:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/31] cpuset: Propagate cpuset isolation update to
 workqueue through housekeeping
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
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20251105210348.35256-1-frederic@kernel.org>
 <20251105210348.35256-18-frederic@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251105210348.35256-18-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgDXR0sO8gtpxr9CCw--.11206S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXw47CFWUurWDGFyfZFWfAFb_yoW7Jw17pF
	Z8CFW8Kay0q3y5u3s8Jws2kr47Kw4kKF17Kwn7Ww1Fyryaqwn7Zw1jgrZIvryFqr98Gr15
	ZFZ0g39rGF40kwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAFDF120010
X-Stat-Signature: bherjmcc7dizu8mju49fsckie38gu6xi
X-Rspam-User: 
X-HE-Tag: 1762390549-997844
X-HE-Meta: U2FsdGVkX19/+DrZLKBowTJAK0MWWEgT0pi4Xs7d1rDyZndEz5Pdjbju2nvg6LcJ49cXOf5Lg40dbw2zYok8Wkuyw4OLkJLDLDbXv7TIcZBb+Il+pF5/WMYM4YEPAuwSDwFNPZgxdJGHzT+IrXSvdoFUT8zj28imvsFx8Oex6l+r3pFiulvY//8oWiXSY2eZQANujoDwWQ6P1jKliPNIlhdKRcV3Winn3vlKJmed98BeRtJ0ZD5103bdvAoyGnPoq3uBD2aams95ZzcbAT5GwrIr5f5TYsgC5St26hOgR+6oeMcC0HGxgiHdPZ7D5AeznKMN4+vAERJK+0iKkCRouElyR0zTSQ3vkqdxe1haoKiI8duEZYvop0SlkBNaQx06Q6Nowj+3zxxpVSAtTKwHX8d9xxO8CqpWOEej2Qi6cP7KnyJnkqA6s/9uZUcai5Z1v59V48gGWSz8Rzn0maqh3rQLp6U6FkDNhyBy4sOlj1rsbXKORbdSa269YU5DsHtya7AMqg4PfN0ai4sNttGC5pPZPRgSufGQ+kPabb63l6TXx45+u0oHHdtiFEUPW4nI0tLTAfRlSsjyIN67NAYfFe8qkg8H9x6tg9gpId4VWrTV58YYmL5fYO81ckygxu9IzhBl6Z2Aeh79pLxEd0JpoaMwU8zkjbKZhdPP8JGYQFWKOuuW03UMprUyiGJJu2rxnfLCw1CK57WXl+CFZ9sATkTW9tUomnuFcv16p04uvJJ9/G581fUgS9syKts2hYXAvNRMar7A0rhKOBCGBK8UkENEnPF4iVLAMu/v14p8+2/5GnfjqHcDf23a1GEx95J8Tq6FnWYGTVjCjt60kw9k2xdBwGdfm2WndTDE59n0Dr1WSwJWhNMlahDHuGwmzsTZqXIYnYSyQdJ+LfgT63rRIDhrF6skQgo8S8ZZEx+NJQ0+wDuGThtUzjS2ZbGYqRkatkYu0pMNlD6Pm8SFTA0
 h354MOLz
 cxL6BjNEplCU7EQcgmKtG8BSd1eJw9F80g46c0sH44YfX0XAsMIJXKjIfWrC1T7h4IWzKxERmMKc5tbdZpvad3M4kR4klBIFy112hUvU5bRHPViq95BEB4GvkxMk7AMxN+5I10piiobjAGsKysmBGnltF7t/YQfpoaHJ7DwD0ePUDiIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/6 5:03, Frederic Weisbecker wrote:
> Until now, cpuset would propagate isolated partition changes to
> workqueues so that unbound workers get properly reaffined.
> 
> Since housekeeping now centralizes, synchronize and propagates isolation
> cpumask changes, perform the work from that subsystem for consolidation
> and consistency purposes.
> 
> For simplification purpose, the target function is adapted to take the
> new housekeeping mask instead of the isolated mask.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  include/linux/workqueue.h |  2 +-
>  init/Kconfig              |  1 +
>  kernel/cgroup/cpuset.c    | 14 ++++++--------
>  kernel/sched/isolation.c  |  4 +++-
>  kernel/workqueue.c        | 17 ++++++++++-------
>  5 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index dabc351cc127..a4749f56398f 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -588,7 +588,7 @@ struct workqueue_attrs *alloc_workqueue_attrs_noprof(void);
>  void free_workqueue_attrs(struct workqueue_attrs *attrs);
>  int apply_workqueue_attrs(struct workqueue_struct *wq,
>  			  const struct workqueue_attrs *attrs);
> -extern int workqueue_unbound_exclude_cpumask(cpumask_var_t cpumask);
> +extern int workqueue_unbound_housekeeping_update(const struct cpumask *hk);
>  
>  extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
>  			struct work_struct *work);
> diff --git a/init/Kconfig b/init/Kconfig
> index cab3ad28ca49..a1b3a3b66bfc 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1247,6 +1247,7 @@ config CPUSETS
>  	bool "Cpuset controller"
>  	depends on SMP
>  	select UNION_FIND
> +	select CPU_ISOLATION
>  	help
>  	  This option will let you create and manage CPUSETs which
>  	  allow dynamically partitioning a system into sets of CPUs and
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b04a4242f2fa..ea102e4695a5 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1392,7 +1392,7 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
>  	return isolcpus_updated;
>  }
>  
> -static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
> +static void update_housekeeping_cpumask(bool isolcpus_updated)
>  {
>  	int ret;
>  
> @@ -1401,8 +1401,6 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
>  	if (!isolcpus_updated)
>  		return;
>  
> -	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
> -	WARN_ON_ONCE(ret < 0);
>  	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
>  	WARN_ON_ONCE(ret < 0);
>  }
> @@ -1558,7 +1556,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
>  	list_add(&cs->remote_sibling, &remote_children);
>  	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
>  	spin_unlock_irq(&callback_lock);
> -	update_unbound_workqueue_cpumask(isolcpus_updated);
> +	update_housekeeping_cpumask(isolcpus_updated);
>  	cpuset_force_rebuild();
>  	cs->prs_err = 0;
>  
> @@ -1599,7 +1597,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
>  	compute_excpus(cs, cs->effective_xcpus);
>  	reset_partition_data(cs);
>  	spin_unlock_irq(&callback_lock);
> -	update_unbound_workqueue_cpumask(isolcpus_updated);
> +	update_housekeeping_cpumask(isolcpus_updated);
>  	cpuset_force_rebuild();
>  
>  	/*
> @@ -1668,7 +1666,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
>  	if (xcpus)
>  		cpumask_copy(cs->exclusive_cpus, xcpus);
>  	spin_unlock_irq(&callback_lock);
> -	update_unbound_workqueue_cpumask(isolcpus_updated);
> +	update_housekeeping_cpumask(isolcpus_updated);
>  	if (adding || deleting)
>  		cpuset_force_rebuild();
>  
> @@ -2027,7 +2025,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
>  		WARN_ON_ONCE(parent->nr_subparts < 0);
>  	}
>  	spin_unlock_irq(&callback_lock);
> -	update_unbound_workqueue_cpumask(isolcpus_updated);
> +	update_housekeeping_cpumask(isolcpus_updated);
>  
>  	if ((old_prs != new_prs) && (cmd == partcmd_update))
>  		update_partition_exclusive_flag(cs, new_prs);
> @@ -3047,7 +3045,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
>  	else if (isolcpus_updated)
>  		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
>  	spin_unlock_irq(&callback_lock);
> -	update_unbound_workqueue_cpumask(isolcpus_updated);
> +	update_housekeeping_cpumask(isolcpus_updated);
>  

The patch [1] has been applied to cgroup/for-next, you may have to adapt it.

[1]: https://lore.kernel.org/cgroups/20251105043848.382703-6-longman@redhat.com/T/#u

-- 
Best regards,
Ridong


