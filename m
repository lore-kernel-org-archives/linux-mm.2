Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59931E8FDBE
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 00:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5DB46B0005; Fri, 26 Dec 2025 19:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A149A6B0089; Fri, 26 Dec 2025 19:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9168A6B008A; Fri, 26 Dec 2025 19:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC3C6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 19:39:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2ACE016085F
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 00:39:47 +0000 (UTC)
X-FDA: 84263393214.24.75371E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95364140003
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 00:39:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CALR7v4X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766795984; a=rsa-sha256;
	cv=none;
	b=MX1coOSkfHBQixCq3ReK5aOgLG63FFsxKglrHh54edJiyCF4qlv9GHu4wMzULv64J1NLTY
	pZnI9hJXfjpVPgTex+qkd41yzCOSbLaGiEJFbZRim8VNedBmS9tj5G2pcDhfmuuu0eQ2md
	mN6uBaTaFV2fnLs0TxdvZAh+VcqEo7Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CALR7v4X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766795984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pERT9koOQ435TwRjMEJhS6iFHKSf3ugdix7KpFMpVgE=;
	b=aO4tqnwcwpIhi/XAm8lu8vgla+78zEm4JANLdlovoA830eydgta8WP4wXMbsPNsHmWE9C8
	bRqaY56SV59o+jHx+IGBgrh07cCCNrgbAoNlM+QQZFVrBMGkLC965OxeaOhX9a/wQriGDG
	nZYc4X8smbDNlxzQtK3LMg/ZyC1666A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766795984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pERT9koOQ435TwRjMEJhS6iFHKSf3ugdix7KpFMpVgE=;
	b=CALR7v4XUscPCQ8bYSOzM680vVtmAlbCmMZTMn3C6UPLBFhGQ1OJgt/tF+92D6fISZ5yRz
	WczxCvDzIzajFAMcXLUy40smos4wCufAIrcTwzY4lG1LmuU29u1D7fHiaF4SclDzRjBi//
	HPlEne4pq1KjVdEKTZSoJ5Lw1Db1cz0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-GuGVNmdEOhS0nB00TR7lEA-1; Fri, 26 Dec 2025 19:39:43 -0500
X-MC-Unique: GuGVNmdEOhS0nB00TR7lEA-1
X-Mimecast-MFC-AGG-ID: GuGVNmdEOhS0nB00TR7lEA_1766795982
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8888447ffebso186222286d6.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:39:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766795974; x=1767400774;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pERT9koOQ435TwRjMEJhS6iFHKSf3ugdix7KpFMpVgE=;
        b=DixOScr2P/05gICKTXX3nCKK5zwlFFDGN+oUR+2FV4UY73Pq2lJ5U+bVkSguX6/+6z
         SzoN0I82grHWk8IKGEf6n39iOAh0GKfDGS7/2RxqMqxDLhAWgAplAK6RoBmtr//r80o3
         leR9DIN17hZkaFleEL0CKlklNukTHnrYc0Ao7WRL4XxJf0V/B9iUWJo8R+vXFpgedWpa
         2JvBaj22rjyZKjFmkqXKRzxLHbbtbc/gpUnHABiVm/ryPXYMwG665xMEyRfKb0vytO7y
         1ZsdHrNQI0bqZYiNHwBe657fPtX9kG11erpwMWPG7V3cIYFgjuvY/0hOTRSATpys/Jfl
         +1tg==
X-Forwarded-Encrypted: i=1; AJvYcCVzKnI7EpPWpAIfhafsQgFhjlJPmr8QbVV50o/xz5w/ugrYERlbL54H+30pc+LT5XzL+RwXpVU08w==@kvack.org
X-Gm-Message-State: AOJu0YwtvMEUoqQZKuJ3S0A50gl03U86nIueziliGEcyZkvDGmbgviR6
	IQk8WimlLbK0iXN1+IaCk+HaWDDw9MZfqqsIeLOR0gPtFYuZ9ansh9wFXhIX+wEOicwm7JvvPSB
	yxYQ36TV5RIc5hPTL2y2/bM0vjbUqp341TT99o0awnFI1BvZ2K+kL
X-Gm-Gg: AY/fxX5rA2sDOFwCi43OSh2mvP1bfcY7XtzvDOc1R8VOa5is3KaDIL7R2TAXnqK9Lyv
	dVx8FcaDfb+Q/CsJOaBojeELZphuTurGD6DdTgzPsd+c/xTt2xjRTgNVdamRjxCG/xRuOECRCz5
	aKzoA4RHWZYkZBd4WuoN7zMSsV9N8bSDCp+NN8qJ2yL3JFdxuZOUs/uN/QbM8EVfbtlmTD0k8lp
	+80uxitFaVjAbkApafxJXBceRLmfnnHD4Hxhkezuih1Cs0o+CUyeUI/UTNO3cXxGbIwgjbaY03F
	Tv9J3jDo93dYi8PX9B3vK8fD+qiQPvZGICJtMiFQj987+TD4HeT1f9M3TAq5lY9B9Xc3rBVL106
	+BAS/L9jqPlVQkEeJClKiWSspJFHBEvCxYAVu8Hw9w9wUsr8Ajhs2RSPy
X-Received: by 2002:ac8:1283:0:b0:4ed:43fe:f51e with SMTP id d75a77b69052e-4f4d96611cbmr138083441cf.39.1766795974381;
        Fri, 26 Dec 2025 16:39:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxBDI7wuXFeJvOL182RfGJ72MAWyQzGy7wYDnXaQodt5PgGkJkP10V4g9eH2qnu2LfLMUFPQ==
X-Received: by 2002:ac8:1283:0:b0:4ed:43fe:f51e with SMTP id d75a77b69052e-4f4d96611cbmr138083091cf.39.1766795973951;
        Fri, 26 Dec 2025 16:39:33 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4d5b4c975sm118077431cf.1.2025.12.26.16.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 16:39:33 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <370149fc-1624-4a16-ac47-dd9b2dd0ed29@redhat.com>
Date: Fri, 26 Dec 2025 19:39:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 33/33] doc: Add housekeeping documentation
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
 <20251224134520.33231-34-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-34-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A7j5s0F69Y2ms3oRWuP8oRfGGDXTH0vkOuAVDFyUodY_1766795982
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95364140003
X-Stat-Signature: hnzctqeernefc868e9zj533zcoyxenbe
X-Rspam-User: 
X-HE-Tag: 1766795984-814476
X-HE-Meta: U2FsdGVkX19xDjG2SlzNX4LnLGdIJVyh27tUOe0IzNcIJyhvqnwZR94dJ8PfeN7dMvTjcV3dNZe2OOh3Jo9uqdvu/WgF3/u5hOfdGk0vdnkBVcpaSpJTV4FZxRcB6TslSn2rENt7cauN4Q15LGWvdn6EKcV0cuWjZw+IABU8mdA1crDcs96irbRZV6BgOHxPCEKTu8O//WmaFOXxyBvg5X4qtdXFawuEQlZR49yb8WJA9lIXtI9IXCzcfQvtR/uvFo3lyC0LIocVsU8FSQ/F9SJsLA2zP+WjIuOMJ0TX2wGkovzfz2VE9kKpI9tO1ab9Ll72N0EsXifIdemsZ+3cxGQplSxmKmukQNjlQ0fz86i0GgAyCpqeUuvpbxtACqD63wgME6wyy64ZwntNak1uFCgxvxELsV1iTgRIZKzmfNvUH4lGzUgjv1GVtihw4K3CU49BjxXzDALXlQIHrYfxPL/WkJQfSL1RXi1uFwXh/CHcYY/ZP5+Ow4d1olHEnDjNrX1XNkqhvUCv0uPmvldY9h6HXEfojfjGdoI4fKFI1Tni/lugFixGJTnLZSdv71ktXJu16/ORn/e5jRpfcQo9B/9HgTTlgAk2gUWUAPImGf6871K5E+/N99ynTBAKbOhh5HUWvnvPsHnXxDIGoXf5uScqTZRmR0QP0JmHqxzUPUEadQQP+0hq0MUQ4zdk1YTNla1R5F7bMxF7ZQWVh0cBXGNNZ1VFCjP0kc5ihTO3z7ZseNGdUYJZWv0BkS/57UN/xqHK6A8Cl/M5UWIPF/uAtB6uQX9zwZBvgTi7xmaHE/iyco4kKFelp1xvRdunVecw2ANKtLYJdIpekP6myYG2CTRoFxWg44KBTbPiuy8aHhrdWaewjWrgvnmVfx/UWZ19E7nuI6AiJmmKyUYWKht8dtt7omriwreeBz3WQmHmt+dj07g9YRnZo+Yuq/QDXo3NPT/NXuXX77jHTIBxftj
 gbSype6X
 ilcWHiZ9wn49Gbuo9Zh6D3sk2kcI3rOC5ESMxEVkyKOM/d/+iQH3T7U94Ui5AYYQ4A+/0sn+mwmAMz8i+JM+Vqdr99VdepVcQqvQakJE+aIwwsKRlZ+E2/jFhjvUzjSpAcKOd+pUBeFrGsnN5XY6U81WWf5jUv8p8Cd5CLXwuN/JRPlEKFoMDdQLzO531cKqwsbKCUZMo7bTIAGfI2Gc+tZPBvU3xxFT6ywedzA40KoNET1yxmGYolVfFuSQot7dmRrjEbm81baAg8NY9w/zVZkLjsAsRHlos9O8Zs7kfJwZco+rJ/bHHhfKH3V8Rhdi9dCxjm6zIsE70iDu4o7dwNRSqzOsROdX0r9rH3LvEuKR3qd1IrEiGSCM4ciivrP+XKQgPmLCrne5MWTv7KFFhpbezixYO3+4DVz9NDskK62/G7dd3N1UGejwZboWS7ylvGbpCaZFGKe7a2K6DQFZxeyd+6A5nGHjhcZtnImzF4QPaihNsvJUWHQL1Bz/UN+OmbNIe9Wmsbs8oasan5n2nCU+4Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   Documentation/core-api/housekeeping.rst | 111 ++++++++++++++++++++++++
>   Documentation/core-api/index.rst        |   1 +
>   2 files changed, 112 insertions(+)
>   create mode 100644 Documentation/core-api/housekeeping.rst
>
> diff --git a/Documentation/core-api/housekeeping.rst b/Documentation/core-api/housekeeping.rst
> new file mode 100644
> index 000000000000..e5417302774c
> --- /dev/null
> +++ b/Documentation/core-api/housekeeping.rst
> @@ -0,0 +1,111 @@
> +======================================
> +Housekeeping
> +======================================
> +
> +
> +CPU Isolation moves away kernel work that may otherwise run on any CPU.
> +The purpose of its related features is to reduce the OS jitter that some
> +extreme workloads can't stand, such as in some DPDK usecases.
Nit: "usecases" => "use cases"
> +
> +The kernel work moved away by CPU isolation is commonly described as
> +"housekeeping" because it includes ground work that performs cleanups,
> +statistics maintainance and actions relying on them, memory release,
> +various deferrals etc...
> +
> +Sometimes housekeeping is just some unbound work (unbound workqueues,
> +unbound timers, ...) that gets easily assigned to non-isolated CPUs.
> +But sometimes housekeeping is tied to a specific CPU and requires
> +elaborated tricks to be offloaded to non-isolated CPUs (RCU_NOCB, remote
> +scheduler tick, etc...).
> +
> +Thus, a housekeeping CPU can be considered as the reverse of an isolated
> +CPU. It is simply a CPU that can execute housekeeping work. There must
> +always be at least one online housekeeping CPU at any time. The CPUs that
> +are not	isolated are automatically assigned as housekeeping.
Nit: extra white spaces between "not" and "isolated".
> +
> +Housekeeping is currently divided in four features described
> +by the ``enum hk_type type``:
> +
> +1.	HK_TYPE_DOMAIN matches the work moved away by scheduler domain
> +	isolation performed through ``isolcpus=domain`` boot parameter or
> +	isolated cpuset partitions in cgroup v2. This includes scheduler
> +	load balancing, unbound workqueues and timers.
> +
> +2.	HK_TYPE_KERNEL_NOISE matches the work moved away by tick isolation
> +	performed through ``nohz_full=`` or ``isolcpus=nohz`` boot
> +	parameters. This includes remote scheduler tick, vmstat and lockup
> +	watchdog.
> +
> +3.	HK_TYPE_MANAGED_IRQ matches the IRQ handlers moved away by managed
> +	IRQ isolation performed through ``isolcpus=managed_irq``.
> +
> +4.	HK_TYPE_DOMAIN_BOOT matches the work moved away by scheduler domain
> +	isolation performed through ``isolcpus=domain`` only. It is similar
> +	to HK_TYPE_DOMAIN except it ignores the isolation performed by
> +	cpusets.
> +
> +
> +Housekeeping cpumasks
> +=================================
> +
> +Housekeeping cpumasks include the CPUs that can execute the work moved
> +away by the matching isolation feature. These cpumasks are returned by
> +the following function::
> +
> +	const struct cpumask *housekeeping_cpumask(enum hk_type type)
> +
> +By default, if neither ``nohz_full=``, nor ``isolcpus``, nor cpuset's
> +isolated partitions are used, which covers most usecases, this function
> +returns the cpu_possible_mask.
> +
> +Otherwise the function returns the cpumask complement of the isolation
> +feature. For example:
> +
> +With isolcpus=domain,7 the following will return a mask with all possible
> +CPUs except 7::
> +
> +	housekeeping_cpumask(HK_TYPE_DOMAIN)
> +
> +Similarly with nohz_full=5,6 the following will return a mask with all
> +possible CPUs except 5,6::
> +
> +	housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
> +
> +
> +Synchronization against cpusets
> +=================================
> +
> +Cpuset can modify the HK_TYPE_DOMAIN housekeeping cpumask while creating,
> +modifying or deleting an isolated partition.
> +
> +The users of HK_TYPE_DOMAIN cpumask must then make sure to synchronize
> +properly against cpuset in order to make sure that:
> +
> +1.	The cpumask snapshot stays coherent.
> +
> +2.	No housekeeping work is queued on a newly made isolated CPU.
> +
> +3.	Pending housekeeping work that was queued to a non isolated
> +	CPU which just turned isolated through cpuset must be flushed
> +	before the related created/modified isolated partition is made
> +	available to userspace.
> +
> +This synchronization is maintained by an RCU based scheme. The cpuset update
> +side waits for an RCU grace period after updating the HK_TYPE_DOMAIN
> +cpumask and before flushing pending works. On the read side, care must be
> +taken to gather the housekeeping target election and the work enqueue within
> +the same RCU read side critical section.
> +
> +A typical layout example would look like this on the update side
> +(``housekeeping_update()``)::
> +
> +	rcu_assign_pointer(housekeeping_cpumasks[type], trial);
> +	synchronize_rcu();
> +	flush_workqueue(example_workqueue);
> +
> +And then on the read side::
> +
> +	rcu_read_lock();
> +	cpu = housekeeping_any_cpu(HK_TYPE_DOMAIN);
> +	queue_work_on(cpu, example_workqueue, work);
> +	rcu_read_unlock();
> diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
> index 5eb0fbbbc323..79fe7735692e 100644
> --- a/Documentation/core-api/index.rst
> +++ b/Documentation/core-api/index.rst
> @@ -25,6 +25,7 @@ it.
>      symbol-namespaces
>      asm-annotations
>      real-time/index
> +   housekeeping.rst
>   
>   Data structures and low-level utilities
>   =======================================
Acked-by: Waiman Long <longman@redhat.com>


