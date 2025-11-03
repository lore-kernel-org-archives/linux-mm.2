Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D6ECCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 02:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73118E0017; Sun,  2 Nov 2025 21:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B236F8E0015; Sun,  2 Nov 2025 21:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A126E8E0017; Sun,  2 Nov 2025 21:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 895EA8E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:23:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 177D414025E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:23:00 +0000 (UTC)
X-FDA: 84067698120.29.7A0B3F1
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94B6310000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:22:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762136578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ucqkRwzrfBsenxemOARzaMa+BGX7n61tqLj1pLVa8L0=;
	b=rL7IAq7MwNI8As2N5XCNS3WC1inQTEo5ofyAWrDziYcn/26PzIuaggQDfxiQp+coIXRgap
	9CNe74vdKLgpV7QFyd4fS2bh+h4ANH8sSaoC3u+XVR4MhpqI0Moxevg9cQhOBHA18m1mA+
	pADEIZ1CWiTDy8C2tq/8QGrMhk8O95I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762136578; a=rsa-sha256;
	cv=none;
	b=hWMqTbka+c0MvmzLdcQJPWkTudBr8Kw5BFk06Ug8ihafDhNHroeAObS649DSC5PVOTCLOC
	bqYqiQ5BmbczSu1HZ9mAU1iY2QgGKAAdEzyRmjoPbmzROYEax/IDgYweRM+Q3fRQnAy/eV
	h43m4NB/E9aVMICjAm/NBKuQUMt/pw0=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d0FjV2tl7zYQtgj
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:22:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 154581A01A1
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:22:51 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgAHmt74EQhp69jiCQ--.60304S2;
	Mon, 03 Nov 2025 10:22:50 +0800 (CST)
Message-ID: <14cd347c-42c9-4134-9c1c-1a222b553c2f@huaweicloud.com>
Date: Mon, 3 Nov 2025 10:22:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
To: Frederic Weisbecker <frederic@kernel.org>, Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
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
 <20251013203146.10162-13-frederic@kernel.org>
 <bb9a75dc-8c34-41da-b064-e31bf5fe6cb2@huaweicloud.com>
 <510b0185-51d6-44e6-8c39-dfc4c1721e03@redhat.com>
 <aQThLsnmqu8Lor6c@localhost.localdomain>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aQThLsnmqu8Lor6c@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHmt74EQhp69jiCQ--.60304S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JF4xAr48tryrCw1kZr4kXrb_yoWfCrWfpr
	WDGFW7GF4kXr15G3yYvwnFyr90gwn7AFn2yr93Gw4rGF9F93WkJry09F13Wrykur97Cr1U
	ZF1Dtw4fua48A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
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
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j6a0PUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94B6310000A
X-Stat-Signature: dbw9y4xjuk1qjk3gs5x8bi4qwfpexos3
X-Rspam-User: 
X-HE-Tag: 1762136575-3114
X-HE-Meta: U2FsdGVkX1+4VXnNrt1vbQKcYr3y0mg+gf76y3BDCp1mdSwpIsoocq81mmNunx8bSZv+oDVQdWR4jW1JhWI7WSdty83ETu9PilWyD46Jt+KXwOOENm2RohyB8lDYy0u57P/HiEUzW4a7DANj/zU58VparcXx+7/spYIx7cBwapX/A/Eo8BxxanC4rG2gAXGTCyNoCyCEoXlmm9zQGGEeWVSlpevWQpzOYT/YV6uM6mGoTfHVbbMTNbKJRcSj48ihnp73bG7vhLhsGEG8G79zcW/A0la3IhDrYfmq6dh5t0/3f5bOwfWDBb7qlCTQmdOY2IRV2+etSODNaj9XK/KGsr3Lp7PeVVaLEy9cnJdyMRQzY+vmpBes7VcWOxHAPSkaGpa6RaJTtDbtVVUJR+B/dINcxHFgaBL0yVqZTIyiw66O5vEeY171nLclY29SourVvekz79ivLZRqQ4CZa9hEhNIQCUyYXfPa3UcsQykag44Ab+Vppz4SqFAQU0gvOlXyGdnA5TYljks6+R3IqKBijloWah3kBf+iLt5RwOWZiqMwOJpruy9yvxuCd6sKJYLTmLFWvCasPmW7aWoVGk6JBChQHhuCRfv0Vgn/+F8dKeqBF8Ouq62LqwsRpowBYL864kR3yHtvpNkNl9y6IvwdVFcKA9ScbLHO0MbXZZi0xo3oO0axr3DE4EZUHh9yTUxwOcoBKQ7KTOjEF9qqm98vJ6ITnwfZ62xFoFgG6tEcm9Hiyf50XWz7pPgqT0gL39eOlSAuL+JoZa8ol1m7DGt9jmYj7SYAUcmTcMPR6WO8jlj01Xn1S5bqMZ2sahYWihM1MEUYfhBQIoX2lxY8HJ6B1MkBAo6FSdhhPTaGRavdNds0uygZeCqIG++ePqPR5kdJUnIYlbx1tZwcRE/PSYaskmKYESb4oOrcRxCuoLQ9kyFZFU7fJTOxS8TsKIYyn/widLfwJkCs8d+orK43x7N
 5zZKVr/m
 +zBPhQGL8SWrNpIiEoDYEPjntaRNGuChJ+w4Eo3/qAonNmARkMqFyS4O7z4uEF6xoUnzeJirdkPWS+ToJfkiSZO1D8SNnWIz/UesFKJ6AVa3Qb92oC2oqWU2Bmyhh47EWJn+TmMlGKhtudPAonHdKlHD7mg5vrLXgGx7FCRg4bjsEj0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/1 0:17, Frederic Weisbecker wrote:
> Le Tue, Oct 21, 2025 at 12:03:05AM -0400, Waiman Long a écrit :
>> On 10/20/25 9:46 PM, Chen Ridong wrote:
>>>
>>> On 2025/10/14 4:31, Frederic Weisbecker wrote:
>>>> HK_TYPE_DOMAIN's cpumask will soon be made modifyable by cpuset.
>>>> A synchronization mechanism is then needed to synchronize the updates
>>>> with the housekeeping cpumask readers.
>>>>
>>>> Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
>>>> cpumask will be modified, the update side will wait for an RCU grace
>>>> period and propagate the change to interested subsystem when deemed
>>>> necessary.
>>>>
>>>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>>> ---
>>>>   kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
>>>>   kernel/sched/sched.h     |  1 +
>>>>   2 files changed, 37 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>>>> index 8690fb705089..b46c20b5437f 100644
>>>> --- a/kernel/sched/isolation.c
>>>> +++ b/kernel/sched/isolation.c
>>>> @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>>>>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>>>>   struct housekeeping {
>>>> -	cpumask_var_t cpumasks[HK_TYPE_MAX];
>>>> +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
>>>>   	unsigned long flags;
>>>>   };
>>>> @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>>>> +const struct cpumask *housekeeping_cpumask(enum hk_type type)
>>>> +{
>>>> +	if (static_branch_unlikely(&housekeeping_overridden)) {
>>>> +		if (housekeeping.flags & BIT(type)) {
>>>> +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
>>>> +		}
>>>> +	}
>>>> +	return cpu_possible_mask;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
>>>> +
>>>>   int housekeeping_any_cpu(enum hk_type type)
>>>>   {
>>>>   	int cpu;
>>>>   	if (static_branch_unlikely(&housekeeping_overridden)) {
>>>>   		if (housekeeping.flags & BIT(type)) {
>>>> -			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
>>>> +			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
>>>>   			if (cpu < nr_cpu_ids)
>>>>   				return cpu;
>>>> -			cpu = cpumask_any_and_distribute(housekeeping.cpumasks[type], cpu_online_mask);
>>>> +			cpu = cpumask_any_and_distribute(housekeeping_cpumask(type), cpu_online_mask);
>>>>   			if (likely(cpu < nr_cpu_ids))
>>>>   				return cpu;
>>>>   			/*
>>>> @@ -59,28 +70,18 @@ int housekeeping_any_cpu(enum hk_type type)
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
>>>> -const struct cpumask *housekeeping_cpumask(enum hk_type type)
>>>> -{
>>>> -	if (static_branch_unlikely(&housekeeping_overridden))
>>>> -		if (housekeeping.flags & BIT(type))
>>>> -			return housekeeping.cpumasks[type];
>>>> -	return cpu_possible_mask;
>>>> -}
>>>> -EXPORT_SYMBOL_GPL(housekeeping_cpumask);
>>>> -
>>>>   void housekeeping_affine(struct task_struct *t, enum hk_type type)
>>>>   {
>>>>   	if (static_branch_unlikely(&housekeeping_overridden))
>>>>   		if (housekeeping.flags & BIT(type))
>>>> -			set_cpus_allowed_ptr(t, housekeeping.cpumasks[type]);
>>>> +			set_cpus_allowed_ptr(t, housekeeping_cpumask(type));
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(housekeeping_affine);
>>>>   bool housekeeping_test_cpu(int cpu, enum hk_type type)
>>>>   {
>>>> -	if (static_branch_unlikely(&housekeeping_overridden))
>>>> -		if (housekeeping.flags & BIT(type))
>>>> -			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
>>>> +	if (housekeeping.flags & BIT(type))
>>>> +		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
>>>>   	return true;
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>>>> @@ -96,20 +97,33 @@ void __init housekeeping_init(void)
>>>>   	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
>>>>   		sched_tick_offload_init();
>>>> -
>>>> +	/*
>>>> +	 * Realloc with a proper allocator so that any cpumask update
>>>> +	 * can indifferently free the old version with kfree().
>>>> +	 */
>>>>   	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
>>>> +		struct cpumask *omask, *nmask = kmalloc(cpumask_size(), GFP_KERNEL);
>>>> +
>>>> +		if (WARN_ON_ONCE(!nmask))
>>>> +			return;
>>>> +
>>>> +		omask = rcu_dereference(housekeeping.cpumasks[type]);
>>>> +
>>>>   		/* We need at least one CPU to handle housekeeping work */
>>>> -		WARN_ON_ONCE(cpumask_empty(housekeeping.cpumasks[type]));
>>>> +		WARN_ON_ONCE(cpumask_empty(omask));
>>>> +		cpumask_copy(nmask, omask);
>>>> +		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
>>>> +		memblock_free(omask, cpumask_size());
>>>>   	}
>>>>   }
>>>>   static void __init housekeeping_setup_type(enum hk_type type,
>>>>   					   cpumask_var_t housekeeping_staging)
>>>>   {
>>>> +	struct cpumask *mask = memblock_alloc_or_panic(cpumask_size(), SMP_CACHE_BYTES);
>>>> -	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
>>>> -	cpumask_copy(housekeeping.cpumasks[type],
>>>> -		     housekeeping_staging);
>>>> +	cpumask_copy(mask, housekeeping_staging);
>>>> +	RCU_INIT_POINTER(housekeeping.cpumasks[type], mask);
>>>>   }
>>>>   static int __init housekeeping_setup(char *str, unsigned long flags)
>>>> @@ -162,7 +176,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>>>>   		for_each_set_bit(type, &iter_flags, HK_TYPE_MAX) {
>>>>   			if (!cpumask_equal(housekeeping_staging,
>>>> -					   housekeeping.cpumasks[type])) {
>>>> +					   housekeeping_cpumask(type))) {
>>>>   				pr_warn("Housekeeping: nohz_full= must match isolcpus=\n");
>>>>   				goto free_housekeeping_staging;
>>>>   			}
>>>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>>>> index 1f5d07067f60..0c0ef8999fd6 100644
>>>> --- a/kernel/sched/sched.h
>>>> +++ b/kernel/sched/sched.h
>>>> @@ -42,6 +42,7 @@
>>>>   #include <linux/ktime_api.h>
>>>>   #include <linux/lockdep_api.h>
>>>>   #include <linux/lockdep.h>
>>>> +#include <linux/memblock.h>
>>>>   #include <linux/minmax.h>
>>>>   #include <linux/mm.h>
>>>>   #include <linux/module.h>
>>> A warning was detected:
>>>
>>> =============================
>>> WARNING: suspicious RCU usage
>>> 6.17.0-next-20251009-00033-g4444da88969b #808 Not tainted
>>> -----------------------------
>>> kernel/sched/isolation.c:60 suspicious rcu_dereference_check() usage!
>>>
>>> other info that might help us debug this:
>>>
>>>
>>> rcu_scheduler_active = 2, debug_locks = 1
>>> 1 lock held by swapper/0/1:
>>>   #0: ffff888100600ce0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: walk_compone
>>>
>>> stack backtrace:
>>> CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-next-20251009-00033-g4
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239
>>> Call Trace:
>>>   <TASK>
>>>   dump_stack_lvl+0x68/0xa0
>>>   lockdep_rcu_suspicious+0x148/0x1b0
>>>   housekeeping_cpumask+0xaa/0xb0
>>>   housekeeping_test_cpu+0x25/0x40
>>>   find_get_block_common+0x41/0x3e0
>>>   bdev_getblk+0x28/0xa0
>>>   ext4_getblk+0xba/0x2d0
>>>   ext4_bread_batch+0x56/0x170
>>>   __ext4_find_entry+0x17c/0x410
>>>   ? lock_release+0xc6/0x290
>>>   ext4_lookup+0x7a/0x1d0
>>>   __lookup_slow+0xf9/0x1b0
>>>   walk_component+0xe0/0x150
>>>   link_path_walk+0x201/0x3e0
>>>   path_openat+0xb1/0xb30
>>>   ? stack_depot_save_flags+0x41e/0xa00
>>>   do_filp_open+0xbc/0x170
>>>   ? _raw_spin_unlock_irqrestore+0x2c/0x50
>>>   ? __create_object+0x59/0x80
>>>   ? trace_kmem_cache_alloc+0x1d/0xa0
>>>   ? vprintk_emit+0x2b2/0x360
>>>   do_open_execat+0x56/0x100
>>>   alloc_bprm+0x1a/0x200
>>>   ? __pfx_kernel_init+0x10/0x10
>>>   kernel_execve+0x4b/0x160
>>>   kernel_init+0xe5/0x1c0
>>>   ret_from_fork+0x185/0x1d0
>>>   ? __pfx_kernel_init+0x10/0x10
>>>   ret_from_fork_asm+0x1a/0x30
>>>   </TASK>
>>> random: crng init done
>>>
>> It is because bh_lru_install() of fs/buffer.c calls cpu_is_isolated()
>> without holding a rcu_read_lock. Will need to add a rcu_read_lock() there.
> 
> But this is called within bh_lru_lock() which should have either disabled
> IRQs or preemption off. I would expect rcu_dereference_check() to automatically
> verify those implied RCU read-side critical sections.
> 
> Let's see, lockdep_assert_in_rcu_reader() checks preemptible(), which is:
> 
> #define preemptible()	(preempt_count() == 0 && !irqs_disabled())
> 
> Ah but if !CONFIG_PREEMPT_COUNT:
> 
> #define preemptible()	0
> 
> Chen did you have !CONFIG_PREEMPT_COUNT ?
> 
> Probably lockdep_assert_in_rcu_reader() should be fixed accordingly and consider
> preemption always disabled whenever !CONFIG_PREEMPT_COUNT. Let me check that...
> 
> Thanks.
> 

I compiled with CONFIG_PREEMPT_COUNT=y and CONFIG_SMP=y.

-- 
Best regards,
Ridong


