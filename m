Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B38DCCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 19:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B5C8E0006; Tue, 21 Oct 2025 15:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C5A8E0002; Tue, 21 Oct 2025 15:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861D98E0006; Tue, 21 Oct 2025 15:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7457A8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:28:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12C7588954
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:28:54 +0000 (UTC)
X-FDA: 84023108988.13.1A2FD39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8AF71140004
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:28:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PgrniAbq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761074931; a=rsa-sha256;
	cv=none;
	b=UrhS5pn0lJTuympMUloDmyXWm78Br7LeknW13AyfdIIgLxAm/rK87iKKsPFiOQ5h5Og+UX
	J/LCPD9z91ZRxovLnrD1CC/z9jTjZgwSWMlc56irwLT2hrHo5mC612sxyrbY2KcVHjq5rb
	qk2doifaJiBYAvYfT/bKOcFL/CePBj8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PgrniAbq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761074931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAcllF9nVIfCniwCIoLGKjAXFJuJdiDQqFfGC/k/Yfk=;
	b=JuTe/+T+ZQUNbfwPDDCZOPg7s59vBgf+qUbWC6ezu2fcgcVgZVFQp/lV4QmJQpmLdPu7xn
	+lCqKOOGEyFTf9BYUW5whU7P7QkQT0X852paH5lbrPwH90yKy3c02bOFtrWShE8BS5MxE7
	4euSDEbkmiTuMlYw7e7EdRCtN4YBATY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761074930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAcllF9nVIfCniwCIoLGKjAXFJuJdiDQqFfGC/k/Yfk=;
	b=PgrniAbq6A8Ta+KQ1dpnmaF1fFvTyAjBLjGFPcaTqIBLTWMMgeaQdpZAkqqb2iNY5flQMR
	T/S+JYIv9pRdQJILeM/Fsig91O9lAB8JddQ9mHbVQ/mKMi8ewWA3hFJY1CC3Rc+RX3bLjc
	1YtZodE2nJ8+vYDkX28nwfsfCI+2yzU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-4JVRHp3uMlGFGK57OEDxRA-1; Tue, 21 Oct 2025 15:28:47 -0400
X-MC-Unique: 4JVRHp3uMlGFGK57OEDxRA-1
X-Mimecast-MFC-AGG-ID: 4JVRHp3uMlGFGK57OEDxRA_1761074927
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-88ea6169a96so403234585a.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761074927; x=1761679727;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAcllF9nVIfCniwCIoLGKjAXFJuJdiDQqFfGC/k/Yfk=;
        b=ZRgn+UBgx77MJir5sCNb0gcbLpMPyj4ru3Xjjtmqbe3Wok4u5RcT328dfb7TvMOKLz
         WLG4KSPqI/fY+nQOHBMBhG+qrcUps3XnBkyOHwzFHjYPsY6WpkVfhEtGqy59DlATjlOx
         BeyMD5wsaPJRZZ09iPN6W1qIctRWcboSbdeglMAzOaxIaunVPhMGRwy6v0NinTmU5jfv
         i9XGMOHSi8xGKqcVCsGNISTY4G2TQdopfoAHJSWPzWli7MfyyDujyfToxW4DCwW4P6iw
         InhYn8ksviuwc8adp9xIPA2VngrxzzQtv4Joomd+uurcWy7qy5tAYfzi8u2RwDHY+eeO
         jNOA==
X-Forwarded-Encrypted: i=1; AJvYcCUNclK83Y+6D4SG8tk7NAr06Kir1FAlGPAR6e5QPbVHwHy9InZ9Ax/r5M3SQcg93VueYCKGX8frXg==@kvack.org
X-Gm-Message-State: AOJu0YxNi+o1alfdx4fiiJ7s/GLSDrTNwLAwk15TEgzv242ZeMX4iOyP
	VIO70DhPE/BvqDejBMDgGT6tOZZ9l7lB9/3RtClf4+Od0VrXuOmA6zw4awOQDx6+KhEWd4DDffT
	ydByb74psp61HZOxROeBaH+e9/IxRMHUYzzfV//Q0LQ6kTkK6p66t
X-Gm-Gg: ASbGnctFAad7BllN6jU+WMayCZb86Zo7hJL8LIfMhAMBHU298misqoPeHrD1y8vmvW7
	m8/dJCNgVnQb94IIeqVyTu+d1tSGeFBpMMmIxUb1k/E6ttpFOn0fW46NNZg8qwG8H5yG+7ZgCM6
	9VtdmCXZKVlbfuewLe0Rl4e9Ip1YBolbLoimBknZokCflkMbsx+Q+iJLTQS2B8UJ2NLHZ651Vkf
	Mqxbx0UsNI5GKAfLkgMArDR4ldBZ6yKgqECCxOQLQLERUq1GSVy4+SHFrbey3M8ghDllJhf10f+
	IhzV3br+GCBivubVD7tjiiM6u9iNgxXK/1U9j3aTR+0HoUBIyCFNWNbiBm9nOwX0+Y2VJNKC4q7
	aF1oktkvJEYTLXO4nobRmBNh9OQR4q0hrgwlHPxWmQFbeDg==
X-Received: by 2002:a05:620a:488e:b0:7e8:67b8:476 with SMTP id af79cd13be357-89070114f94mr2346435585a.57.1761074927202;
        Tue, 21 Oct 2025 12:28:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+u+8bH+lrXiYca/LtZ13ni/QSfiNRKtdF54+j0jtBiSwDvm50yRps0a3A4dxIJsM4iefKKw==
X-Received: by 2002:a05:620a:488e:b0:7e8:67b8:476 with SMTP id af79cd13be357-89070114f94mr2346432285a.57.1761074926666;
        Tue, 21 Oct 2025 12:28:46 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cefba8f0sm817018785a.40.2025.10.21.12.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 12:28:46 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <a01172d1-d902-4d55-bc1e-c8234985e65a@redhat.com>
Date: Tue, 21 Oct 2025 15:28:42 -0400
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
 <364e084a-ef37-42ab-a2ae-5f103f1eb212@redhat.com>
In-Reply-To: <364e084a-ef37-42ab-a2ae-5f103f1eb212@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wyZ8_6XQQpgYEkazefKG42DXC6a9J4f1y8cO4WnSPZ8_1761074927
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8AF71140004
X-Stat-Signature: 7g6zetnnxawqbr16onza7ppu9yg9gf35
X-HE-Tag: 1761074931-321824
X-HE-Meta: U2FsdGVkX19f/Gp0Hfld/gANpCboENJ5cqVXSoHfuxs/CiG0EA3w1bRGoacfbC0+/fIdFmrGcfs5fof9pvDInEWzDvPtgpFioUyBbO3oCKVMmP/ncjJcHNbjszEw+lbKlTN45+foQpBJai3K0rrwfqsjqO4rrYFKPSBwbAqalGltbrwlkPtSXlpz7HyuGMJIo1yey8G8Vhqx6gItEvzSU0AJQ0dq9TyN1BBANh/VF1iI68bPoSPTBC77hQ0lxsc/yUSLi8hoRlj4GwTa0qdjz/MFamXxpbrK1PgYPBrmpUkeV5rKxUfcmURjZbh4PCdlbqzHSlhuhFq2NxYVsQNzcC9TxElvZ26xlf7YXbMz/s8NbbkZ02YMyInhl8mSe3HkNLKE8KSq6aVPBpdxuTSHnJi6sA+R5h9rg2MlJMzisdMXuCqYyTt3Od5vFHbCpWOa5Y63OxDocTmGU/WV2c51u/+igOmCasGiZ5SwNJ+8oC2KBrQoXHEytVROtP2Cegl9Wmsp4pZwX35f7RgRGVI8sHiUv9BzkPa4K1iDkHsRKd1rBWsPkqHHXQvhK0hEKDK2mj+z0g9iSu9N0Nwl+vcn3/pO1k+gVtunrH2BcTAmxbrjopDoFFmWX3RbyZHLHL1lTYhj+jlEgWs3CT26vh4K7/+Wegb6hlyMLr9sWFU/ruQaqsGkE2pu8/ubHXBym3N18cXoYrpVzdOpFjj8lE3X9xwFuuAEGbxajJ+636uWYWfK5vo665YdC/9hDVbU1GaLXsm2LUiO7Hx1OCiJE3TlisdND+muLIWMy5aTWXbXs39Z6v1Fix2ds1DtJETWOzNH///Aegjwf3h83f22YGQ55AN9IctXHy0lv0oTvB96U38D564JtHDb/jqU4/0zuKFa5/BeWNVEnYSANYErk8Ooqtj6460D80Z/GMt4LThgdmmJQC1x7FrFD58JNkWHbN2/XRD+f3/9j3qPccbhH2P
 uqO/CAVV
 Mi9wcqNSekEYEcLvhhuPKb5nLG3bhYfRjL1jnNHKCJaJBbF9J/NsW0Q7pEKgLOMof8b8+8fyQUltg2umdS86Vo8nGdBJ2I8e2+8KxmkmnhNSnYk8zU/xE7DxErIyc1SLTQJ2gBopa+qbNIwaovxm8WzpSIHXTF5F0oiM3RBlUmTAYy/kFCVfUR5CANA/xn4q6kweE6Pe6CR1tI2psn+36xU0HxrtgPEgO7/6T4SAxbu8DGmee5s/ZRtCSUfCmEM+45d7EPEwSXCX+2wylTkach1MGVDzqF2fJuZs5gPjbn2F/Z+pdk6XClYYbjJTkwFN/Q0ss2z3aibvW8SyNVtVB2I087FmzTn6oMwHAY8RqnHXsJJlWjY16a8FYweF+IaexYDcBYeAbCbZlXMh3HRQdd7vz/799ruYlKMCXe1MzuW23lgNDq8h7nA8cSoM2g5RiCRoFayFcrh7S+g3nE6bRhHagr9Ody61JQEo9oYQunMwUxgTExXr3fsOt+b9BFUOtBkZ8hz/S4Q3p6dvSEoSuPX6JXtgYacsv11y+UXEUH6pjD9AmUCA+u5PjoUmz9sAUKbkqR+l4JARisDn+aHLvuLe0BQbIH4j3CdfCl04olpkbWJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 3:16 PM, Waiman Long wrote:
> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
>> The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime. In
>> order to synchronize against memcg workqueue to make sure that no
>> asynchronous draining is still pending or executing on a newly made
>> isolated CPU, the housekeeping susbsystem must flush the memcg
>> workqueues.
>>
>> However the memcg workqueues can't be flushed easily since they are
>> queued to the main per-CPU workqueue pool.
>>
>> Solve this with creating a memcg specific pool and provide and use the
>> appropriate flushing API.
>>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>   include/linux/memcontrol.h |  4 ++++
>>   kernel/sched/isolation.c   |  2 ++
>>   kernel/sched/sched.h       |  1 +
>>   mm/memcontrol.c            | 12 +++++++++++-
>>   4 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 873e510d6f8d..001200df63cf 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -1074,6 +1074,8 @@ static inline u64 cgroup_id_from_mm(struct 
>> mm_struct *mm)
>>       return id;
>>   }
>>   +void mem_cgroup_flush_workqueue(void);
>> +
>>   extern int mem_cgroup_init(void);
>>   #else /* CONFIG_MEMCG */
>>   @@ -1481,6 +1483,8 @@ static inline u64 cgroup_id_from_mm(struct 
>> mm_struct *mm)
>>       return 0;
>>   }
>>   +static inline void mem_cgroup_flush_workqueue(void) { }
>> +
>>   static inline int mem_cgroup_init(void) { return 0; }
>>   #endif /* CONFIG_MEMCG */
>>   diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 95d69c2102f6..9ec365dea921 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -144,6 +144,8 @@ int housekeeping_update(struct cpumask *mask, 
>> enum hk_type type)
>>         synchronize_rcu();
>>   +    mem_cgroup_flush_workqueue();
>> +
>>       kfree(old);
>>         return 0;
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index 8fac8aa451c6..8bfc0b4b133f 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -44,6 +44,7 @@
>>   #include <linux/lockdep_api.h>
>>   #include <linux/lockdep.h>
>>   #include <linux/memblock.h>
>> +#include <linux/memcontrol.h>
>>   #include <linux/minmax.h>
>>   #include <linux/mm.h>
>>   #include <linux/module.h>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 1033e52ab6cf..1aa14e543f35 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -95,6 +95,8 @@ static bool cgroup_memory_nokmem __ro_after_init;
>>   /* BPF memory accounting disabled? */
>>   static bool cgroup_memory_nobpf __ro_after_init;
>>   +static struct workqueue_struct *memcg_wq __ro_after_init;
>> +
>>   static struct kmem_cache *memcg_cachep;
>>   static struct kmem_cache *memcg_pn_cachep;
>>   @@ -1975,7 +1977,7 @@ static void schedule_drain_work(int cpu, 
>> struct work_struct *work)
>>   {
>>       guard(rcu)();
>>       if (!cpu_is_isolated(cpu))
>> -        schedule_work_on(cpu, work);
>> +        queue_work_on(cpu, memcg_wq, work);
>>   }
>>     /*
>> @@ -5092,6 +5094,11 @@ void mem_cgroup_sk_uncharge(const struct sock 
>> *sk, unsigned int nr_pages)
>>       refill_stock(memcg, nr_pages);
>>   }
>>   +void mem_cgroup_flush_workqueue(void)
>> +{
>> +    flush_workqueue(memcg_wq);
>> +}
>> +
>>   static int __init cgroup_memory(char *s)
>>   {
>>       char *token;
>> @@ -5134,6 +5141,9 @@ int __init mem_cgroup_init(void)
>>       cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, 
>> "mm/memctrl:dead", NULL,
>>                     memcg_hotplug_cpu_dead);
>>   +    memcg_wq = alloc_workqueue("memcg", 0, 0);
>
> Should we explicitly mark the memcg_wq as WQ_PERCPU even though I 
> think percpu is the default. The schedule_work_on() schedules work on 
> the system_percpu_wq. 

According to commit dadb3ebcf39 ("workqueue: WQ_PERCPU added to 
alloc_workqueue users"), the default may be changed to WQ_UNBOUND in the 
future.

Cheers,
Longman


