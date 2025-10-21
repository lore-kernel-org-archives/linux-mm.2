Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9518CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 04:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3964C8E0006; Tue, 21 Oct 2025 00:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E0F8E0002; Tue, 21 Oct 2025 00:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25ED38E0006; Tue, 21 Oct 2025 00:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7BF8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:03:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B55A1602FB
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:03:18 +0000 (UTC)
X-FDA: 84020776476.02.2E231E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06DC61C0007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:03:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMMZ7uHD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761019396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypGPB2dMjd5AmXxY6vdW8x1rXEojijwfr4yyazjH+Dk=;
	b=vHx764JHAMGqTG+Z5WYFSANkzHsOJm1CxthRlESygPRU+eQDoY3t2c/aDvs82JSWingrUQ
	8lfKYNp1sPNrTHcAcTDyl5OQe3TZ68wQh9bubmsIOhXX/MlxpNr+cTpBsUEr8j6ENYcrGI
	OL1yJW41sD2TzAmTbts60lEgeX4SCOM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dMMZ7uHD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761019396; a=rsa-sha256;
	cv=none;
	b=TYPR5G490vCLTJj+FIop6pmcTYvb8awRb0xRV9b6ukFuasCvWvzERPNmjEN+diOCv748KL
	gdthTB7qmpbJwd0BeSpoLlKyRewv8h2OUNMM9VUbkQZtNsGxnTW0h3SQvnIy9fVj/eUAdz
	2pgWzGDKMF+ZIf17zvNKj7KXYwT8LxM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761019395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypGPB2dMjd5AmXxY6vdW8x1rXEojijwfr4yyazjH+Dk=;
	b=dMMZ7uHDHXRPNU0DsFqlsRdzCkuNvQ9bLXeHQQZ/BtW2UQ54/YJiSHmXmK3DMY8/wV2hvq
	4H+mA/uzGM5jMUXv8JP1lPaKTl4s85LledVU7+NLtk4ubrZ85QIwUVeGtP3iQXNOEKLHa1
	MEEfyqdWT6jNYEQhXdgzTituLCue7VM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-Khamhqg4Ojui1AXm8s4-eQ-1; Tue, 21 Oct 2025 00:03:13 -0400
X-MC-Unique: Khamhqg4Ojui1AXm8s4-eQ-1
X-Mimecast-MFC-AGG-ID: Khamhqg4Ojui1AXm8s4-eQ_1761019393
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-88375756116so2780765685a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761019393; x=1761624193;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ypGPB2dMjd5AmXxY6vdW8x1rXEojijwfr4yyazjH+Dk=;
        b=Z9NDjheQgQFYDPuRgXud1Y+7xLd7ViUYM4Ht89seSsZNSFvQ2yuI/c2bx9q4O7qU/X
         3BvgigUUzc5RSgB2hm0/Zn9DpnGcFyRADEH9Cm9hLwYDhacbm4IkfCsbUra5iKbKbEAB
         DWiCZ9/z9jy7m1c0YA6XkEV4Lwys5/7okSAybJeZ0eMzf0hsGU9yec5Di/9+Q6DS9jgc
         Y/M4Vu7xjvvOFACW82DVDTLFDdEE8lyN0T/ugdQvvHf15XKkAmcPLmBa/JDq03qfF7Wj
         Uu9ME1gtuvq0z5hYy1sCiRJnToNANidmovbpBDmRLjgUMLtkn/eckwouidNwo4R/+Rcp
         3pSA==
X-Forwarded-Encrypted: i=1; AJvYcCWzk3ZUzvuRRzs+DaUROqAmMLyB63Jw5F8vZzYLOdUJ9cTSzjP3sTr9aJuOds0zPqojPWKApSDc6g==@kvack.org
X-Gm-Message-State: AOJu0YyRRv+JFbzJlTwK4EEIBCBYW4rjYnJ2foAuqqsDaOlbc6kOckYK
	uEGFG8A6SI5/2z3SfNEZcK2FzXXu26RGz/Hx57u3pJA4Gp6HT+hE+7d6ATy7RQrdGzzWOhMfneV
	oy9q0JlCZiz3O/vV/fTVV12gW/7AYeZGl/kk5357cALhyNPd7m8xl
X-Gm-Gg: ASbGncsRkB4unUtfCArE2rLYZ8cGdkBfaM/wNzdcX2xdGIfM55TzvqtlCjuQB7EM8zO
	zj4rGUI7KqKfxoX+9McTfXXphOTz6XVvTjGwPhUbhiIo/1Agc8rFRIRDtH7rfnUk51ey4FgIP02
	m14cWOdrY+hgR/FO/YBLylbYd7nz/Zb6GSJGib5XLU51xGEshC329sJn2hwMzFyXecyul9Wvpnf
	jdS+AnIyHUiTQ3DB3CxtrdYujzCrkfitFo/XnFGAXBQcVhOiqMNkdK8qD+HTfYnn5mhPB2M1urg
	YCe+BEfgHuCUE8bqFCit/1a6m9LSjlIT5XDv9RvmzRHuCNdAXE+ISC7pC6Um6esJ5N5QDG9LThF
	15BoC7ExX1+i8lxDpk+Rh0NZniEq88zOBP6LkqM4fZucN9A==
X-Received: by 2002:a05:620a:199c:b0:7e8:3fbd:4190 with SMTP id af79cd13be357-8906e0da740mr1877059685a.2.1761019392959;
        Mon, 20 Oct 2025 21:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3urjAuZAgtdR076zL6t7beitaw+yMAlWxDfIl37cvi1zbenzxv5j5J3/VNyalxK0zDSKr8w==
X-Received: by 2002:a05:620a:199c:b0:7e8:3fbd:4190 with SMTP id af79cd13be357-8906e0da740mr1877055485a.2.1761019392392;
        Mon, 20 Oct 2025 21:03:12 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cf58e67esm686026885a.47.2025.10.20.21.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 21:03:11 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <510b0185-51d6-44e6-8c39-dfc4c1721e03@redhat.com>
Date: Tue, 21 Oct 2025 00:03:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
To: Chen Ridong <chenridong@huaweicloud.com>,
 Frederic Weisbecker <frederic@kernel.org>,
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
 <20251013203146.10162-13-frederic@kernel.org>
 <bb9a75dc-8c34-41da-b064-e31bf5fe6cb2@huaweicloud.com>
In-Reply-To: <bb9a75dc-8c34-41da-b064-e31bf5fe6cb2@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rBk65FlphCguLVTBM3qB3Bt6p6GMs5Vk-aolZ-CFdN4_1761019393
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06DC61C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: k4b6ui33tupjna6hjw1bpur7qcuyajoj
X-HE-Tag: 1761019395-446932
X-HE-Meta: U2FsdGVkX1/HMz1MVZhQQ5pYVjZnjdtKBMtQ3Zej9Zp3jLOv4fqVyWWwwDuusoqPMQ5hXDg/DtY1fnNevcJ7T6TV6af2YQqsm20QWHS5m0X+eirc/SCs8PgPwJhPH//+lgM5HdsP0l+ZA0AzZcfQ1yHcgxLeL5chOP0HWJUHVrO+Lpv8kdTMMw5zKBXumqr+OAGat/NfztNARG0/n1CPDQ0sDiIsMOvkku/WLgjEA9u0dCYFTUu6ltku44boOMTUEzCgTnRl6G9olay/XrqoVSKeY8Y7sWuWYPAhlJaome+cxe8QQj+GjQpefGMXHnlUzatmQguK8NPqSxTCaxaGmU9yOuCIoGyBpLTyPZwlC7tTosYmRqHOy6d1FqW1LODhpTR6Pznd01Rx779JdRf5iv2nLoaFLIF9q6XkBKS/sBEDR0pKszno0LV8ES+Z/P6SbNSG0oYtSQPuVcqhALNPyegDSHAL6jNtyhVKWDaRwi6jHCoqKvnXgsLGSd2z4cRuAn6NgL1alDsgevzlR3lThc5n/g+J8BURqlx6OylzlxFlrvI6h2ajGJyvWW7jhIhGFeGA2nP6QyKGqil1SHprxlwUYBgUVGA0vOPBK2GgWVyo+uALUYD6N8Pn67cZ1Xk/xF/2xIQnbhVzO0lVOBcqJXbb19H7Hd37QytXSFGKmUxjbqfoZTniv33UCq59/JRn9BXLPtvMmsp7UBRX1eVX1Jj/CzFwggY/dlF5NMHcAyMiU2IQOCsGt4vTHsliaWl+fx4jPfxRrubFy3N42vrMTgNGeE2rPguXVicAaR4lbFpach3mjIDYiddyK5ocajXZcNfz1MOh8ypQbYi64DBiv/BYM2CE6ELfXTa1EC+IhfRDAfxS8Ow+iyih3pAUy2gc0IX12tuktQ7rkovcqGcT3AvqND52psm7SrNaa+O4c1dzdP3nJzrQ1n5oaY5yehmqQzV5fwW2PqGVN7g8bDq
 6ILYY2D3
 fls3skrD8+3UNXFwyEUQA3MUfw0JIKL2RDebSqW9UElZR77cermdqs2aaVJZkiUXPK+ZSo58HGOKlKQkn54IS0CNsH/PzGDj35KqtkjDKOJcJ1ploOZh1i3vcaDf1eN2Aley92nQYnIh/ch76bloNJskshC0WOeNClhf6blxuCH0l6vsPU3KYoHB2wSqz9oJWaDTgClw1qtx5wgM3bYLm9VYYf/ofZhc2Crxi9gSyWzbZYcBV8kHMIz6hfoVX7vJ5vzsb3f04iDhkWC1os1VX/2oJZL+3cwGgcJvf+Ikbm0Xb4F7mFyVZHvd6nmC3WbCJyBRUiJmsmMY7n4VDsonF9FzsHqAKeopQWhcW9SxFg+jm8FwZ4Nh504f1WNEvNmBhJCLkQkuf2dsVXtOT2P2/vCCfqoh8lxCAsu1ufydcAIcugeCU6zp34cfAIfJDbeH6HaTcJANhNq8Tu1vC8SOgePpu2bKimcOV/kcL++PhV6/bDlmyx6JqhtkgLCXPYm8ScgybIza+qxKi3JQtA8xeEX3Ytygn7xdmJDec92sfPLIfhDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/20/25 9:46 PM, Chen Ridong wrote:
>
> On 2025/10/14 4:31, Frederic Weisbecker wrote:
>> HK_TYPE_DOMAIN's cpumask will soon be made modifyable by cpuset.
>> A synchronization mechanism is then needed to synchronize the updates
>> with the housekeeping cpumask readers.
>>
>> Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
>> cpumask will be modified, the update side will wait for an RCU grace
>> period and propagate the change to interested subsystem when deemed
>> necessary.
>>
>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>> ---
>>   kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
>>   kernel/sched/sched.h     |  1 +
>>   2 files changed, 37 insertions(+), 22 deletions(-)
>>
>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 8690fb705089..b46c20b5437f 100644
>> --- a/kernel/sched/isolation.c
>> +++ b/kernel/sched/isolation.c
>> @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>>   
>>   struct housekeeping {
>> -	cpumask_var_t cpumasks[HK_TYPE_MAX];
>> +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
>>   	unsigned long flags;
>>   };
>>   
>> @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>>   
>> +const struct cpumask *housekeeping_cpumask(enum hk_type type)
>> +{
>> +	if (static_branch_unlikely(&housekeeping_overridden)) {
>> +		if (housekeeping.flags & BIT(type)) {
>> +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
>> +		}
>> +	}
>> +	return cpu_possible_mask;
>> +}
>> +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
>> +
>>   int housekeeping_any_cpu(enum hk_type type)
>>   {
>>   	int cpu;
>>   
>>   	if (static_branch_unlikely(&housekeeping_overridden)) {
>>   		if (housekeeping.flags & BIT(type)) {
>> -			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
>> +			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
>>   			if (cpu < nr_cpu_ids)
>>   				return cpu;
>>   
>> -			cpu = cpumask_any_and_distribute(housekeeping.cpumasks[type], cpu_online_mask);
>> +			cpu = cpumask_any_and_distribute(housekeeping_cpumask(type), cpu_online_mask);
>>   			if (likely(cpu < nr_cpu_ids))
>>   				return cpu;
>>   			/*
>> @@ -59,28 +70,18 @@ int housekeeping_any_cpu(enum hk_type type)
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
>>   
>> -const struct cpumask *housekeeping_cpumask(enum hk_type type)
>> -{
>> -	if (static_branch_unlikely(&housekeeping_overridden))
>> -		if (housekeeping.flags & BIT(type))
>> -			return housekeeping.cpumasks[type];
>> -	return cpu_possible_mask;
>> -}
>> -EXPORT_SYMBOL_GPL(housekeeping_cpumask);
>> -
>>   void housekeeping_affine(struct task_struct *t, enum hk_type type)
>>   {
>>   	if (static_branch_unlikely(&housekeeping_overridden))
>>   		if (housekeeping.flags & BIT(type))
>> -			set_cpus_allowed_ptr(t, housekeeping.cpumasks[type]);
>> +			set_cpus_allowed_ptr(t, housekeeping_cpumask(type));
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_affine);
>>   
>>   bool housekeeping_test_cpu(int cpu, enum hk_type type)
>>   {
>> -	if (static_branch_unlikely(&housekeeping_overridden))
>> -		if (housekeeping.flags & BIT(type))
>> -			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
>> +	if (housekeeping.flags & BIT(type))
>> +		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
>>   	return true;
>>   }
>>   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>> @@ -96,20 +97,33 @@ void __init housekeeping_init(void)
>>   
>>   	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
>>   		sched_tick_offload_init();
>> -
>> +	/*
>> +	 * Realloc with a proper allocator so that any cpumask update
>> +	 * can indifferently free the old version with kfree().
>> +	 */
>>   	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
>> +		struct cpumask *omask, *nmask = kmalloc(cpumask_size(), GFP_KERNEL);
>> +
>> +		if (WARN_ON_ONCE(!nmask))
>> +			return;
>> +
>> +		omask = rcu_dereference(housekeeping.cpumasks[type]);
>> +
>>   		/* We need at least one CPU to handle housekeeping work */
>> -		WARN_ON_ONCE(cpumask_empty(housekeeping.cpumasks[type]));
>> +		WARN_ON_ONCE(cpumask_empty(omask));
>> +		cpumask_copy(nmask, omask);
>> +		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
>> +		memblock_free(omask, cpumask_size());
>>   	}
>>   }
>>   
>>   static void __init housekeeping_setup_type(enum hk_type type,
>>   					   cpumask_var_t housekeeping_staging)
>>   {
>> +	struct cpumask *mask = memblock_alloc_or_panic(cpumask_size(), SMP_CACHE_BYTES);
>>   
>> -	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
>> -	cpumask_copy(housekeeping.cpumasks[type],
>> -		     housekeeping_staging);
>> +	cpumask_copy(mask, housekeeping_staging);
>> +	RCU_INIT_POINTER(housekeeping.cpumasks[type], mask);
>>   }
>>   
>>   static int __init housekeeping_setup(char *str, unsigned long flags)
>> @@ -162,7 +176,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>>   
>>   		for_each_set_bit(type, &iter_flags, HK_TYPE_MAX) {
>>   			if (!cpumask_equal(housekeeping_staging,
>> -					   housekeeping.cpumasks[type])) {
>> +					   housekeeping_cpumask(type))) {
>>   				pr_warn("Housekeeping: nohz_full= must match isolcpus=\n");
>>   				goto free_housekeeping_staging;
>>   			}
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index 1f5d07067f60..0c0ef8999fd6 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -42,6 +42,7 @@
>>   #include <linux/ktime_api.h>
>>   #include <linux/lockdep_api.h>
>>   #include <linux/lockdep.h>
>> +#include <linux/memblock.h>
>>   #include <linux/minmax.h>
>>   #include <linux/mm.h>
>>   #include <linux/module.h>
> A warning was detected:
>
> =============================
> WARNING: suspicious RCU usage
> 6.17.0-next-20251009-00033-g4444da88969b #808 Not tainted
> -----------------------------
> kernel/sched/isolation.c:60 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by swapper/0/1:
>   #0: ffff888100600ce0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at: walk_compone
>
> stack backtrace:
> CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.17.0-next-20251009-00033-g4
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x68/0xa0
>   lockdep_rcu_suspicious+0x148/0x1b0
>   housekeeping_cpumask+0xaa/0xb0
>   housekeeping_test_cpu+0x25/0x40
>   find_get_block_common+0x41/0x3e0
>   bdev_getblk+0x28/0xa0
>   ext4_getblk+0xba/0x2d0
>   ext4_bread_batch+0x56/0x170
>   __ext4_find_entry+0x17c/0x410
>   ? lock_release+0xc6/0x290
>   ext4_lookup+0x7a/0x1d0
>   __lookup_slow+0xf9/0x1b0
>   walk_component+0xe0/0x150
>   link_path_walk+0x201/0x3e0
>   path_openat+0xb1/0xb30
>   ? stack_depot_save_flags+0x41e/0xa00
>   do_filp_open+0xbc/0x170
>   ? _raw_spin_unlock_irqrestore+0x2c/0x50
>   ? __create_object+0x59/0x80
>   ? trace_kmem_cache_alloc+0x1d/0xa0
>   ? vprintk_emit+0x2b2/0x360
>   do_open_execat+0x56/0x100
>   alloc_bprm+0x1a/0x200
>   ? __pfx_kernel_init+0x10/0x10
>   kernel_execve+0x4b/0x160
>   kernel_init+0xe5/0x1c0
>   ret_from_fork+0x185/0x1d0
>   ? __pfx_kernel_init+0x10/0x10
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
> random: crng init done
>
It is because bh_lru_install() of fs/buffer.c calls cpu_is_isolated() 
without holding a rcu_read_lock. Will need to add a rcu_read_lock() there.

Cheers,
Longman


