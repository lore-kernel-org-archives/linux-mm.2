Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E73CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F738E0009; Wed,  5 Nov 2025 10:18:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876F68E0008; Wed,  5 Nov 2025 10:18:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D248E0009; Wed,  5 Nov 2025 10:18:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6723E8E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:18:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2809140391
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:18:10 +0000 (UTC)
X-FDA: 84076909140.06.4F2D8BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3CB864000D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:18:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlA6UEYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762355889; a=rsa-sha256;
	cv=none;
	b=xjgcfO0ziUhpxBxl3FuUXdEBC3KatQ5i0Prlh4MpBmjGtJGsLtrflWtqJfvavqbwi6+Wyn
	FdtkNaq44ysWTvISJ3wQD7rfyEAb+0zFLjKSyFKGdkwWsqdGfJML9vXhtEHrE2M9K86P5g
	8pJTWE8/lUk5BOM20EBsop7tSj5aNUU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlA6UEYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762355889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQ3dfkBlGHO9v9rqbnjdOgO0YfSQlNFm7epapPtn++k=;
	b=BesLXjLWgsGawKw0NkyjRswD/snCNKWWkD4XCp3/XPdB/7NJMbkvzguziwLz67qy85jzgv
	QepZDndqRLSZ673gBcXA+Zcq+oFawPPcwKfgTTRFgONuIrvN2B8eNC8i3b26E96gjZw7zj
	PV9qupl3iC4lXt+Ob+VJH++AhByPtT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7120D601DD;
	Wed,  5 Nov 2025 15:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B230C4CEF5;
	Wed,  5 Nov 2025 15:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762355888;
	bh=KrTmSd/KLHnmJp6uY5VjqlnOzYc3oRuRzLcvqn1keFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VlA6UEYiwYN0luQ/4V7V5KntlUFeIZMU+NmpkL7d+M3N2iUQ1IOTeflqlF+lIm90q
	 HiYedRgVi60NobljBr8hiMWKlKYaC0H2qpqcbgA62caHhlCZRV0lAw+K6rG/pGXCdM
	 v2fUWpgA1cuUl7tJFOCWW5vd5SlcBeqwuZxogThAgO6JWjnfivWSGwf1FZmVbvLp51
	 DXvXopX+g369NCQ/HianrAkrAREQeoj/7Y3X5e7jN/22+bQDoRUOUhUSyljHri7cDD
	 BYyWmWicrYUBAv0SObOJUefhS668cWVoSkzNKG1fBJO8d3jvGpTEthtLNQuTTZy+9f
	 X1oSJavknulag==
Date: Wed, 5 Nov 2025 16:18:05 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Waiman Long <llong@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
Message-ID: <aQtqrYlvMsjX91Vn@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-13-frederic@kernel.org>
 <bb9a75dc-8c34-41da-b064-e31bf5fe6cb2@huaweicloud.com>
 <510b0185-51d6-44e6-8c39-dfc4c1721e03@redhat.com>
 <aQThLsnmqu8Lor6c@localhost.localdomain>
 <14cd347c-42c9-4134-9c1c-1a222b553c2f@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14cd347c-42c9-4134-9c1c-1a222b553c2f@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3CB864000D
X-Stat-Signature: r3qzupqycz76c696bsqpiquyub8j586c
X-HE-Tag: 1762355889-286128
X-HE-Meta: U2FsdGVkX19RlSRBGvHh79nV1KGddTUXum1QHLTCerXsp9M/gOkQBtuNDzTpXVNMIKGTV0WmQOikBedovW5ghnui8HYcybBdQSvXX+pVoihOLnJLLBcgsnpmWGTRF/kBNh2mTN/kInW9Y331md3UoggR/HnTxv0z4j9fpeD17EFPMCRj1I0GV0uMt0Rk+8pm9gPQGhC+bu5KNPIdeo6bP+UyZXVx8/JVMtS/d1s0v7r0mlr3xCIW3sA1cTgKf8THETMrSHPgVhJ400fk/q3/N2w3Qrzm+7S1lyouejq19yoQQiJaIFijQXidN3kVRe9CfxE83DQRF+n4NhV2JRTMMoZTa/nqWIJYtmbQlY9ht5+5Bcrs7UkH79ZAJG1ns7qepYatgTKsvRGlopswypLoQWdoNbfOPJt0KgGesnyIFOhymahdMCSGyYNqX2yaZINAeYJObVfNyGmMwStHTczghILmFM9ResLrCnnIXlbqOb2F79Noj3GmYwjUU3ueTXxn+K29GpVvn+1onNIJeczhPTOOlrAG5zejH+UMg5kJ2gK+MOCAHapyT+UPyVGt1iqmcyO3mQdLDWicEJ5WlyuD+J15Hd0zpAYFEyvVsDw04evR2JyOgzbliakwC1qFSbyRcuxZAkpfT5FSYC0VDdBeiLi8B0L54KAyem9z0l6IJByHc3yepE0/WF6fjzQpNHaJGLi1B17nutUzrZnuYGZbSDmUgnhtHJKo2FTvhWyThvBs6ODePzV83cv/0kizCRM7B59r7nj2jvLB8kTVLBbNlHwmNaPuUqz1uDadOjE4oX12jDBv6WddFjCXez0u6VYmWJ8uKXJLh8kHIVFWfwK/3so2iYAmx08s9VownQqzu60qwALdBpFRw71aSnuCpqURcQPXy8ranMinjtFLJS02xnQzRU8UZ1weO5Wk94vUW+j7tc/3SME/hP0aQWaZbOpjHhLZhkkd2T6WZNZGY4H
 EJ0zxdWk
 gbt0rdeh90Emk1V6GQ9vCknOjhBe4ELD+Ia9J1XEtGF90ckxL17FNwV7/X7XV0yPaTYQvRhGTs7qp3F4ytX3GBA39h10PE1hRmxg3KDDuwGrc9NxS3pnVfTGA35ZskxnhA+1XOAvzyT6jcJ+vF4WUPiSM/sGsEXd1Rso+QioTcXyneB0az+r5w84GeRvOUjDhIsSEu3GE5Z25qPbcIiAUwGYagTR3IMNAlw13HuZRa4sb8RLjT4hGrGGsKpgkugZJCBPi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Nov 03, 2025 at 10:22:47AM +0800, Chen Ridong a écrit :
> 
> 
> On 2025/11/1 0:17, Frederic Weisbecker wrote:
> > Le Tue, Oct 21, 2025 at 12:03:05AM -0400, Waiman Long a écrit :
> >> On 10/20/25 9:46 PM, Chen Ridong wrote:
> >>>
> >>> On 2025/10/14 4:31, Frederic Weisbecker wrote:
> >>>> HK_TYPE_DOMAIN's cpumask will soon be made modifyable by cpuset.
> >>>> A synchronization mechanism is then needed to synchronize the updates
> >>>> with the housekeeping cpumask readers.
> >>>>
> >>>> Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
> >>>> cpumask will be modified, the update side will wait for an RCU grace
> >>>> period and propagate the change to interested subsystem when deemed
> >>>> necessary.
> >>>>
> >>>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> >>>> ---
> >>>>   kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
> >>>>   kernel/sched/sched.h     |  1 +
> >>>>   2 files changed, 37 insertions(+), 22 deletions(-)
> >>>>
> >>>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> >>>> index 8690fb705089..b46c20b5437f 100644
> >>>> --- a/kernel/sched/isolation.c
> >>>> +++ b/kernel/sched/isolation.c
> >>>> @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
> >>>>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
> >>>>   struct housekeeping {
> >>>> -	cpumask_var_t cpumasks[HK_TYPE_MAX];
> >>>> +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
> >>>>   	unsigned long flags;
> >>>>   };
> >>>> @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
> >>>>   }
> >>>>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
> >>>> +const struct cpumask *housekeeping_cpumask(enum hk_type type)
> >>>> +{
> >>>> +	if (static_branch_unlikely(&housekeeping_overridden)) {
> >>>> +		if (housekeeping.flags & BIT(type)) {
> >>>> +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
> >>>> +		}
> >>>> +	}
> >>>> +	return cpu_possible_mask;
> >>>> +}
> >>>> +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
> >>>> +
> >>>>   int housekeeping_any_cpu(enum hk_type type)
> >>>>   {
> >>>>   	int cpu;
> >>>>   	if (static_branch_unlikely(&housekeeping_overridden)) {
> >>>>   		if (housekeeping.flags & BIT(type)) {
> >>>> -			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
> >>>> +			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
> >>>>   			if (cpu < nr_cpu_ids)
> >>>>   				return cpu;
> >>>> -			cpu = cpumask_any_and_distribute(housekeeping.cpumasks[type], cpu_online_mask);
> >>>> +			cpu = cpumask_any_and_distribute(housekeeping_cpumask(type), cpu_online_mask);
> >>>>   			if (likely(cpu < nr_cpu_ids))
> >>>>   				return cpu;
> >>>>   			/*
> >>>> @@ -59,28 +70,18 @@ int housekeeping_any_cpu(enum hk_type type)
> >>>>   }
> >>>>   EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
> >>>> -const struct cpumask *housekeeping_cpumask(enum hk_type type)
> >>>> -{
> >>>> -	if (static_branch_unlikely(&housekeeping_overridden))
> >>>> -		if (housekeeping.flags & BIT(type))
> >>>> -			return housekeeping.cpumasks[type];
> >>>> -	return cpu_possible_mask;
> >>>> -}
> >>>> -EXPORT_SYMBOL_GPL(housekeeping_cpumask);
> >>>> -
> >>>>   void housekeeping_affine(struct task_struct *t, enum hk_type type)
> >>>>   {
> >>>>   	if (static_branch_unlikely(&housekeeping_overridden))
> >>>>   		if (housekeeping.flags & BIT(type))
> >>>> -			set_cpus_allowed_ptr(t, housekeeping.cpumasks[type]);
> >>>> +			set_cpus_allowed_ptr(t, housekeeping_cpumask(type));
> >>>>   }
> >>>>   EXPORT_SYMBOL_GPL(housekeeping_affine);
> >>>>   bool housekeeping_test_cpu(int cpu, enum hk_type type)
> >>>>   {
> >>>> -	if (static_branch_unlikely(&housekeeping_overridden))
> >>>> -		if (housekeeping.flags & BIT(type))
> >>>> -			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
> >>>> +	if (housekeeping.flags & BIT(type))
> >>>> +		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
> >>>>   	return true;
> >>>>   }
> >>>>   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
> >>>> @@ -96,20 +97,33 @@ void __init housekeeping_init(void)
> >>>>   	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
> >>>>   		sched_tick_offload_init();
> >>>> -
> >>>> +	/*
> >>>> +	 * Realloc with a proper allocator so that any cpumask update
> >>>> +	 * can indifferently free the old version with kfree().
> >>>> +	 */
> >>>>   	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
> >>>> +		struct cpumask *omask, *nmask = kmalloc(cpumask_size(), GFP_KERNEL);
> >>>> +
> >>>> +		if (WARN_ON_ONCE(!nmask))
> >>>> +			return;
> >>>> +
> >>>> +		omask = rcu_dereference(housekeeping.cpumasks[type]);
> >>>> +
> >>>>   		/* We need at least one CPU to handle housekeeping work */
> >>>> -		WARN_ON_ONCE(cpumask_empty(housekeeping.cpumasks[type]));
> >>>> +		WARN_ON_ONCE(cpumask_empty(omask));
> >>>> +		cpumask_copy(nmask, omask);
> >>>> +		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
> >>>> +		memblock_free(omask, cpumask_size());
> >>>>   	}
> >>>>   }
> >>>>   static void __init housekeeping_setup_type(enum hk_type type,
> >>>>   					   cpumask_var_t housekeeping_staging)
> >>>>   {
> >>>> +	struct cpumask *mask = memblock_alloc_or_panic(cpumask_size(), SMP_CACHE_BYTES);
> >>>> -	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
> >>>> -	cpumask_copy(housekeeping.cpumasks[type],
> >>>> -		     housekeeping_staging);
> >>>> +	cpumask_copy(mask, housekeeping_staging);
> >>>> +	RCU_INIT_POINTER(housekeeping.cpumasks[type], mask);
> >>>>   }
> >>>>   static int __init housekeeping_setup(char *str, unsigned long flags)
> >>>> @@ -162,7 +176,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
> >>>>   		for_each_set_bit(type, &iter_flags, HK_TYPE_MAX) {
> >>>>   			if (!cpumask_equal(housekeeping_staging,
> >>>> -					   housekeeping.cpumasks[type])) {
> >>>> +					   housekeeping_cpumask(type))) {
> >>>>   				pr_warn("Housekeeping: nohz_full= must match isolcpus=\n");
> >>>>   				goto free_housekeeping_staging;
> >>>>   			}
> >>>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> >>>> index 1f5d07067f60..0c0ef8999fd6 100644
> >>>> --- a/kernel/sched/sched.h
> >>>> +++ b/kernel/sched/sched.h
> >>>> @@ -42,6 +42,7 @@
> >>>>   #include <linux/ktime_api.h>
> >>>>   #include <linux/lockdep_api.h>
> >>>>   #include <linux/lockdep.h>
> >>>> +#include <linux/memblock.h>
> >>>>   #include <linux/minmax.h>
> >>>>   #include <linux/mm.h>
> >>>>   #include <linux/module.h>
> >>> A warning was detected:
> >>>
> >>> =============================
> >>> WARNING: suspicious RCU usage
> >>> 6.17.0-next-20251009-00033-g4444da88969b #808 Not tainted
> >>> -----------------------------
> >>> kernel/sched/isolation.c:60 suspicious rcu_dereference_check() usage!
> >>>
> >>> other info that might help us debug this:
> >>>
> >>>
> >>> rcu_scheduler_active = 2, debug_locks = 1
> >>> 1 lock held by swapper/0/1:
> >>>   #0: ffff888100600ce0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: walk_compone
> >>>
> >>> stack backtrace:
> >>> CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-next-20251009-00033-g4
> >>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239
> >>> Call Trace:
> >>>   <TASK>
> >>>   dump_stack_lvl+0x68/0xa0
> >>>   lockdep_rcu_suspicious+0x148/0x1b0
> >>>   housekeeping_cpumask+0xaa/0xb0
> >>>   housekeeping_test_cpu+0x25/0x40
> >>>   find_get_block_common+0x41/0x3e0
> >>>   bdev_getblk+0x28/0xa0
> >>>   ext4_getblk+0xba/0x2d0
> >>>   ext4_bread_batch+0x56/0x170
> >>>   __ext4_find_entry+0x17c/0x410
> >>>   ? lock_release+0xc6/0x290
> >>>   ext4_lookup+0x7a/0x1d0
> >>>   __lookup_slow+0xf9/0x1b0
> >>>   walk_component+0xe0/0x150
> >>>   link_path_walk+0x201/0x3e0
> >>>   path_openat+0xb1/0xb30
> >>>   ? stack_depot_save_flags+0x41e/0xa00
> >>>   do_filp_open+0xbc/0x170
> >>>   ? _raw_spin_unlock_irqrestore+0x2c/0x50
> >>>   ? __create_object+0x59/0x80
> >>>   ? trace_kmem_cache_alloc+0x1d/0xa0
> >>>   ? vprintk_emit+0x2b2/0x360
> >>>   do_open_execat+0x56/0x100
> >>>   alloc_bprm+0x1a/0x200
> >>>   ? __pfx_kernel_init+0x10/0x10
> >>>   kernel_execve+0x4b/0x160
> >>>   kernel_init+0xe5/0x1c0
> >>>   ret_from_fork+0x185/0x1d0
> >>>   ? __pfx_kernel_init+0x10/0x10
> >>>   ret_from_fork_asm+0x1a/0x30
> >>>   </TASK>
> >>> random: crng init done
> >>>
> >> It is because bh_lru_install() of fs/buffer.c calls cpu_is_isolated()
> >> without holding a rcu_read_lock. Will need to add a rcu_read_lock() there.
> > 
> > But this is called within bh_lru_lock() which should have either disabled
> > IRQs or preemption off. I would expect rcu_dereference_check() to automatically
> > verify those implied RCU read-side critical sections.
> > 
> > Let's see, lockdep_assert_in_rcu_reader() checks preemptible(), which is:
> > 
> > #define preemptible()	(preempt_count() == 0 && !irqs_disabled())
> > 
> > Ah but if !CONFIG_PREEMPT_COUNT:
> > 
> > #define preemptible()	0
> > 
> > Chen did you have !CONFIG_PREEMPT_COUNT ?
> > 
> > Probably lockdep_assert_in_rcu_reader() should be fixed accordingly and consider
> > preemption always disabled whenever !CONFIG_PREEMPT_COUNT. Let me check that...
> > 
> > Thanks.
> > 
> 
> I compiled with CONFIG_PREEMPT_COUNT=y and CONFIG_SMP=y.

Oh actually I think it's my fault. This should be fixed with this:

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 95d69c2102f6..b2cb75513336 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -56,8 +56,8 @@ static bool housekeeping_dereference_check(enum hk_type type)
 
 static inline struct cpumask *housekeeping_cpumask_dereference(enum hk_type type)
 {
-	return rcu_dereference_check(housekeeping.cpumasks[type],
-				     housekeeping_dereference_check(type));
+	return rcu_dereference_all_check(housekeeping.cpumasks[type],
+					 housekeeping_dereference_check(type));
 }
 
 const struct cpumask *housekeeping_cpumask(enum hk_type type)

