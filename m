Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD3CCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82168E0003; Tue, 21 Oct 2025 21:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59B08E0002; Tue, 21 Oct 2025 21:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48718E0003; Tue, 21 Oct 2025 21:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1E78E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:37:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C93113B965
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:37:08 +0000 (UTC)
X-FDA: 84024036936.24.A031B2C
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8DA004000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:37:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761097026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LD0qWl5xilwc1SKYsjsXg5N2GPcM85/d8wvl37r2abw=;
	b=eLXNcKdkvyvXVgT8YXUVhOzhA40YOuJqDd0N02SzVR0vvDiXXfXetW4FarYeLEjfJWQfz8
	ArEAKP5p15nuumNx9Dgm06fAuR/gr3gH+ElxOhkNizMZEub5t+sogWecxQSNfVzdnMK7hB
	tVasiaJgsRRE38jH+5ULl98I//xwDII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761097026; a=rsa-sha256;
	cv=none;
	b=pLFdsgUXDIKwxNvE3fKahKZ/KGMuhPBLEmbawMHz9crXhJiVHFBorAvM9Lnx/+LkY7FPBY
	OYnk6K2W8vgr1ApeSXYjXccCiUwDV0J/R4ejM34b/McwBLpyX2tjC0tRoS5N2qiIDwl6eC
	q3/GKWXKusTQKwExHJJLeli89HU0LqU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4crsFS2ZDvzKHLvK
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:36:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8A0671A0ACF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:36:59 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgDnWk45NfhooJirBA--.61559S2;
	Wed, 22 Oct 2025 09:36:59 +0800 (CST)
Message-ID: <6d046d0a-30d4-429e-8ae3-f00b6149c397@huaweicloud.com>
Date: Wed, 22 Oct 2025 09:36:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
To: Waiman Long <llong@redhat.com>, Frederic Weisbecker
 <frederic@kernel.org>, LKML <linux-kernel@vger.kernel.org>
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
 <0e02915f-bde7-4b04-b760-89f34fb0a436@redhat.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <0e02915f-bde7-4b04-b760-89f34fb0a436@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDnWk45NfhooJirBA--.61559S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAr1kGF15JryxWFy5KrWruFg_yoWrurW7pF
	WkWFWxWFWUGwn3G3s8Jw1DZry5Wws7Cw1UGrn2ga15AF17WF1jq34j9rnIgr18Zw4xCr12
	vFn0v39a93W7ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam05
X-Stat-Signature: 1nm9bhmd6q5znwfhuz1hzechao59jhac
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DA004000D
X-HE-Tag: 1761097023-150572
X-HE-Meta: U2FsdGVkX1+iqTMTODCiplx08/3GPWVnVERB4U08J3QBlDjA31nLYCGfq4MHFNHpsj7L/gnGcIc3KFPQQwivOeo8zB5uHe7AgEUU+PZj9k2dZe3GAWXorj2zawLNJlM1qE6kON0tToi9CRHKeUazlImylTWCtYZMaQJiC2+H2klH3XkXwCzaks72QrquGWzn+YIQmhDiNb+DAuqF+UEDHXjCcPs4OXQtQy+XrM5Nnpuq4Njdf8B6Y3FcTpMbZh4SLtKg5aDqTkHhFz+MazIqz0ebPAJOZqsPTb+LL6x3jGnicUQ6mBruTl9CIGFOt4fUZhlXZhQtuLvwcJp3OvkF8X1hslZQZjMsOickV9EnH+waxK1VrjOuIE54SMuf+1FlUK6q5r7g7Zar+2wDtBIPgJHidZg9ruhl70Fh8+7y61dEcfQSFmg4Y0teIIuEPvvaOe5LM2zN6MTsaLu4oQTECdG+JqQVUOHFbKZ/INk4xr7TX+q/DBmbCMvWzKtMF647SSGGxS41KVN9Mr5VB+M8FT8B51Z3X5tUvmwFRpyD4O5+YDJ+layjCCMFYT4/azzvHjbENiVNk+b+NZ0ELUPh3A1ixbqVvmPmbWINszW+5Xboen8ovU3Y4xuiYUPQzRzLInDA1+dT06VvTbuDQfCvFFUakZni3WWOWbC1dv2pt/hvbHzOn76NuTwcmHxmH4YwnKrAniFUvuzrIClNxL6cohgTuPMash/sOtWPwUxV2KwvDSeVnvvoSLVLSMaUXU6rjqeNBM6S4eYpDghR+EJOPNrYyNjlT74IsnikEX6cG19a94+50g/MSHriNKl4nz8yiWqVXQJeRVQ1jxiQ6MKQQQf3Uaw5asLetqRkvYkxtmMr3mTsHMZmHnwwLzTaEikE8OG1zgn6OtHPyYzd1VfzHNMzBEddE+sdKD4s5aY4DopvZYIWbPEPz0acKrSkImNm2GGDtbOJe4mGmhPqQuK
 Q4Z5cZVu
 ngXbTUirOnon3eIRCjPwkMDqHO7L07gdD0sF1ZyiQglOu6wTM+WAmJr22YxP0pDPML241jEvwsvthj7rnh9OeKJVHGE7Je/pt4gognNufViQvhnAKdi7uMXGL8vGbf69gNodSF6AT+jIS83A3wM/WRL+52/pUZRGAAfCl5zaG0ynrqkCen/J7i1HGY5Q7odRRozkygSEI86qvOUUQnMZTxjdzdrcRPxmq5xjw1NgKmpTFDo/KR6NyT0tBmTEaTaZU55+j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/21 12:10, Waiman Long wrote:
> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
>> Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
>> CPUs passed through isolcpus= boot option. Users interested in also
>> knowing the runtime defined isolated CPUs through cpuset must use
>> different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...
>>
>> There are many drawbacks to that approach:
>>
>> 1) Most interested subsystems want to know about all isolated CPUs, not
>>    just those defined on boot time.
>>
>> 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
>>    concurrent cpuset changes.
>>
>> 3) Further cpuset modifications are not propagated to subsystems
>>
>> Solve 1) and 2) and centralize all isolated CPUs within the
>> HK_TYPE_DOMAIN housekeeping cpumask.
>>
>> Subsystems can rely on RCU to synchronize against concurrent changes.
>>
>> The propagation mentioned in 3) will be handled in further patches.
>>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>   include/linux/sched/isolation.h |  2 +
>>   kernel/cgroup/cpuset.c          |  2 +
>>   kernel/sched/isolation.c        | 75 ++++++++++++++++++++++++++++++---
>>   kernel/sched/sched.h            |  1 +
>>   4 files changed, 74 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
>> index da22b038942a..94d5c835121b 100644
>> --- a/include/linux/sched/isolation.h
>> +++ b/include/linux/sched/isolation.h
>> @@ -32,6 +32,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>>   extern bool housekeeping_enabled(enum hk_type type);
>>   extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>>   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
>> +extern int housekeeping_update(struct cpumask *mask, enum hk_type type);
>>   extern void __init housekeeping_init(void);
>>     #else
>> @@ -59,6 +60,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>>       return true;
>>   }
>>   +static inline int housekeeping_update(struct cpumask *mask, enum hk_type type) { return 0; }
>>   static inline void housekeeping_init(void) { }
>>   #endif /* CONFIG_CPU_ISOLATION */
>>   diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index aa1ac7bcf2ea..b04a4242f2fa 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1403,6 +1403,8 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
>>         ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
>>       WARN_ON_ONCE(ret < 0);
>> +    ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
>> +    WARN_ON_ONCE(ret < 0);
>>   }
>>     /**
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index b46c20b5437f..95d69c2102f6 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
>>     bool housekeeping_enabled(enum hk_type type)
>>   {
>> -    return !!(housekeeping.flags & BIT(type));
>> +    return !!(READ_ONCE(housekeeping.flags) & BIT(type));
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>>   +static bool housekeeping_dereference_check(enum hk_type type)
>> +{
>> +    if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
>> +        /* Cpuset isn't even writable yet? */
>> +        if (system_state <= SYSTEM_SCHEDULING)
>> +            return true;
>> +
>> +        /* CPU hotplug write locked, so cpuset partition can't be overwritten */
>> +        if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
>> +            return true;
>> +
>> +        /* Cpuset lock held, partitions not writable */
>> +        if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
>> +            return true;
> 
> I have some doubt about this condition as the cpuset_mutex may be held in the process of making
> changes to an isolated partition that will impact HK_TYPE_DOMAIN cpumask.
> 
> Cheers,
> Longman
> 

+1

ie. 'echo isolate > cpuset.cpus.partition'

-- 
Best regards,
Ridong


