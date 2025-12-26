Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52781E7AD77
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 03:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFDB6B0088; Thu, 25 Dec 2025 22:21:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA226B0089; Thu, 25 Dec 2025 22:21:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1CB6B008A; Thu, 25 Dec 2025 22:21:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3EA6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 22:21:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB5A8134C1
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:21:20 +0000 (UTC)
X-FDA: 84260171520.06.C2773F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2518B140003
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:21:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SQKBLgM6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766719278; a=rsa-sha256;
	cv=none;
	b=k/KobfuxCqxAkPCJO+Cssb7MzODXwEWkDxAqGza6m293GOAXx1D3NjndjN9/nDOcOzb+Tm
	taSiEU+dmwATLSU4zbTahiwHZj2S9XaorDloK1OGL4LlBkMkJ3RBrv64ZiAkKOc1QZRN3q
	kKeZBJeGG2Lpnz2SgPogSia0qBxXeoU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SQKBLgM6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766719278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKHp6uC5zNb3gZSMB9BQPFV3o9H0iVs2RJyYgnJbrKc=;
	b=LFna5QR3xH4GBhnLJfNJ+k86RfTXkP2/gC9PuFhk1Wh0OQNPBg4Jzn71vHo6OzCySH0aiO
	L7Mb4HemvAmUR1UxIJP8ZMZ4e6jbKomR2fFJVrEC1a7ZhaRKUpeqrqq5d4czYA9yn8wR/q
	0qOvG5kIQEeOqkNdd0HND0RL2x/5Amc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766719277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dKHp6uC5zNb3gZSMB9BQPFV3o9H0iVs2RJyYgnJbrKc=;
	b=SQKBLgM6bKLYePxUlnJJS61R+Ob/e76i8C5+xTjJmXm43xJ1Ohx/HBC/iP7t9KBJTWTXhl
	U2ARbSZrwzh5kLIN6xxb+UO6Ezo8mGlWOvU1xCX5GhaEgDAVQVZOlye5xkHuGUITtJ2iNN
	2q3cjoDHQnzUv4I+XW4ougj1IICB3yE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-XHhbJsgPPqCQZxv-PXjh0Q-1; Thu, 25 Dec 2025 22:21:15 -0500
X-MC-Unique: XHhbJsgPPqCQZxv-PXjh0Q-1
X-Mimecast-MFC-AGG-ID: XHhbJsgPPqCQZxv-PXjh0Q_1766719274
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a0d43fcb2fso227697075ad.3
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 19:21:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766719274; x=1767324074;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dKHp6uC5zNb3gZSMB9BQPFV3o9H0iVs2RJyYgnJbrKc=;
        b=KpNJJ2d7J0/EHRdWIAJT5syprtjucfgfhBB9wcb1KPGhdold9cqptvxeygKoytcwYx
         S8FKCF+YqonootrTCOynC6ojw5XCSxROoswAsWtSf2bEvaKSmH+K6h+gCectvtkf2JBn
         measm6SCuPXx853yCu5kGFVJsUkXN76km7ZhDHsgCqxh7+S0v/fBMfmfGPvT4bgGdGKS
         nvWfrKY8KNA18UsONa+3rzfcv7FxW0U2A9z470nUu94AAkvmXqcrraUPMFWRMN4J/9XB
         Rna2Y7J2uG+l3ckJeHBWJiOR2HTIjyBrfjMQQDVw7TapLduW1MnYxsArd7dosvLyXKts
         XJuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoKsj+J9V7r2/18StVuBQ3nFkMQBP1qEzG7vFay72snFDcnGx8hi+TB7Y/7Iju/MXIvkVrscHtFQ==@kvack.org
X-Gm-Message-State: AOJu0YyaNdT1exYHRlFPu1HNBgYw6r7GQ+lLDaL8oJuy4r0VBz2WDRyO
	02WnBWlwNqYf7zhb3XiZXrfh2kWYDToJqf5Rv95OT9xvwiIWyITyPnKWr2plzOta/j9r2abIKmi
	A1zp41mjfPL5HWgfU0KLkUvHryHm3oFGTHSFqGGZGxcgtQk1bMKi7
X-Gm-Gg: AY/fxX7QR/DiuZYL7fKauKhkEadzKFOFatEEIFvNvC+dV4oVFP37HAQSWnRnYUTGsQ6
	IvopISgqLI4eb7XopYQwujq9eW44g4d8bbXIPrDti0pZQR1GkDma0r/tpb+pPe4gApi5yXQF9/W
	kOjyZbVTyUc8NOXyACOMR9/87dcWn5QchX8D0jmpqSQ+pIQJQgU6dGIQjYlA99pKlrakJuH0n+y
	ivvn/gDreyyKwNowj//FpfBJkfSv6KTs61+c9L/9JPdiRXIUW5CWQYNB8NhgpiOw8xiK1+gU/ab
	Fl2LAn8fcAldfhz4drNAUFLNlQP6TIODjuHm+VkCa1DjBUmFSvOczmkeJGx/iUTEWHVFaxnL+IW
	5P9VE/2sf+7+YjRkNVDfMQkwp9qjFBgAjllrrUXEdg9vhpHLObk0nqTiF
X-Received: by 2002:a05:7022:f902:20b0:11c:b3ad:1fe1 with SMTP id a92af1059eb24-121722b1a7bmr20901018c88.11.1766719274282;
        Thu, 25 Dec 2025 19:21:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrRbO/uTv2AgLdwLaHgNpsWrHMXpzUWqpTKYvMicj4UtKVHtP6aAiwD9wbO4xGgVHronC7tQ==
X-Received: by 2002:a05:7022:f902:20b0:11c:b3ad:1fe1 with SMTP id a92af1059eb24-121722b1a7bmr20900963c88.11.1766719273695;
        Thu, 25 Dec 2025 19:21:13 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm80252105c88.1.2025.12.25.19.21.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Dec 2025 19:21:13 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <5b019a5c-1db4-41d9-aca9-2e3eaf1cece9@redhat.com>
Date: Thu, 25 Dec 2025 22:20:59 -0500
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
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-15-frederic@kernel.org>
 <17aadc7e-7dd6-4335-a748-e66f0239df85@redhat.com>
In-Reply-To: <17aadc7e-7dd6-4335-a748-e66f0239df85@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NF2bDgNDp-rRrhIchRoD0u7JsQrx4LadhZJq4pxHBkk_1766719274
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2518B140003
X-Rspamd-Server: rspam03
X-Stat-Signature: i4gxauiipybx5t4yaf5aa4x3ao89cgds
X-Rspam-User: 
X-HE-Tag: 1766719277-589777
X-HE-Meta: U2FsdGVkX1+MacpOBmbDBiI69RSXgx60jocWHzUjvaAtT+bASQ2AYjvUzSWq3Kj6Mb7LiENE9SlZ0dqcCTa+wvks0AHv1MTdQ9yg+w/CLK+4SrFMydHImN3w2L+2vmQNsLSMOapp2cLbHqfmf2AxZ393tKMxxkgtkQKxWhLOdkSwlkidzQfH9Xsmno/xgMHoQ+C53FHdYWfgW1+Rg3go9U2XEk87EET7LOh1bErzleHKIMtlW646bkzySR8xLDk1L4Xwc9Fgh67bDwnnpGdHwHLSawCyNggfR+1ZZ7c7o0LQJDgTS6lbV5iFISjaFCCofIYEcutA1LfXIYxFrZXJun2si8alLuE+aeDPEiqzVa3XV8/lMP7NGaxkW6GhfO2+W0jRKRzN4OoLvSKPYdqWlDrOqSHvRLI7GBxEm0U5PU2gGwylHcqXvlQD3Xd+3kYityqbrz0CyVLed27wnnboddgrhdhhlTLTaBpM/Yk8U44wFrU5AjQTysySqc5qc6Ishr8qOfx86OZOiyfHawRoAP2Ptq+NBGap7eyl2vSEYK9to1eWPaJo3sHZvXWYxyg15KY4mIeYfhL3F3ppEef+L3QursycLbWeVZV6BS/kovJtaJ+dH4UYxhJ9Aa33Y4gY6xzuEiCqLwEycQybGjJrNec1BJFsRXzx9fUg7sNcIcTxgcTPPFQSyGIsDSSltVsRbU8ZKGYw3ZVdRvQZnDaBVFmj9qC7zhXcDJqotKzK0LehO6W9rW765ikyMu9yoYl36rkRt4JNCjiuYO0extHqOS2oTByCPKvzcNgXUhKzHqSZkyMPazi4XJgboum0VxcPgfYl/Feu6PLRhBq/dyPpTGtV6aWvkPgxoz988t9+USMfdXq3flQhoZwkCN1UgCU8p4gqwMrYpHO/nWyYhdi9xBpfyN5M7BvNgZ81q3HYPT5+eziR0wIIMlux5yWYGdaVQ2SuDPkjjDAN8bdnTaS
 7FH1ibNw
 yL9Wa8yyiS0C+AklGNYUYlo492saW6wRvC1L6lzWmRHiTzkq8ZCvwaIZBICmTI5c1eisRxbaV0CMzx5gYnx6zeQhvzfydrloLupX7/wnWJ5aXKMbVjiFlrSoH0yjM3Jfdv+CEut2d2tu6J50aS0ZPkZu2pWud1wEMDbGULbC5pDhOC0eppYKaFDnrVMjIFrXyKQQ8fe56aNtDcgspTV2RrkZz0fJ+jN8WyMGUEYlpM2k3AbdPWLij5lgawS4mNDXwflv74hp/ftbOEyCJOQxTefTSES5pt9z2zwon/35ursECKkAU1sFOWpHuwE6XQt7Wb/tsth37TbVRWRjLO11J0r+pCP8l29pg4YpuQEQ9jI5tStjl4lmXKjYDf5iAaOgO0+jaNsNFE4HkspnvYtjcCT99WHW+L2wNYG6hyPIt95jIqOZISRt1lBYEbMbNuIOYyE0vYz2DeyCNmjw/Mxdj/4owhU8cim6Wut/2ZwpwjP/en7ZyBPzyL5+Q/8enwqgGW83zjxaZ/zHjLiNm6JscHXQ3Ou4f1i0rWCz8XzZkwF3YP+Fn7wsLKEqucD422srW3h6eSTQFnmtpSsivol6PAFyHcdCM/QhoSh0H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/25/25 9:24 PM, Waiman Long wrote:
> On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
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
>> 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized 
>> with
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
>>   include/linux/sched/isolation.h |  7 +++
>>   kernel/cgroup/cpuset.c          |  3 ++
>>   kernel/sched/isolation.c        | 76 ++++++++++++++++++++++++++++++---
>>   kernel/sched/sched.h            |  1 +
>>   4 files changed, 81 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/sched/isolation.h 
>> b/include/linux/sched/isolation.h
>> index 109a2149e21a..6842a1ba4d13 100644
>> --- a/include/linux/sched/isolation.h
>> +++ b/include/linux/sched/isolation.h
>> @@ -9,6 +9,11 @@
>>   enum hk_type {
>>       /* Revert of boot-time isolcpus= argument */
>>       HK_TYPE_DOMAIN_BOOT,
>> +    /*
>> +     * Same as HK_TYPE_DOMAIN_BOOT but also includes the
>> +     * revert of cpuset isolated partitions. As such it
>> +     * is always a subset of HK_TYPE_DOMAIN_BOOT.
>> +     */
>>       HK_TYPE_DOMAIN,
>>       /* Revert of boot-time isolcpus=managed_irq argument */
>>       HK_TYPE_MANAGED_IRQ,
>> @@ -35,6 +40,7 @@ extern const struct cpumask 
>> *housekeeping_cpumask(enum hk_type type);
>>   extern bool housekeeping_enabled(enum hk_type type);
>>   extern void housekeeping_affine(struct task_struct *t, enum hk_type 
>> type);
>>   extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
>> +extern int housekeeping_update(struct cpumask *isol_mask, enum 
>> hk_type type);
>>   extern void __init housekeeping_init(void);
>>     #else
>> @@ -62,6 +68,7 @@ static inline bool housekeeping_test_cpu(int cpu, 
>> enum hk_type type)
>>       return true;
>>   }
>>   +static inline int housekeeping_update(struct cpumask *isol_mask, 
>> enum hk_type type) { return 0; }
>>   static inline void housekeeping_init(void) { }
>>   #endif /* CONFIG_CPU_ISOLATION */
>>   diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 5e2e3514c22e..e13e32491ebf 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1490,6 +1490,9 @@ static void update_isolation_cpumasks(void)
>>       ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
>>       WARN_ON_ONCE(ret < 0);
>>   +    ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
>> +    WARN_ON_ONCE(ret < 0);
>> +
>>       isolated_cpus_updating = false;
>>   }
>>   diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>> index 83be49ec2b06..a124f1119f2e 100644
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
>
> To be more correct, we should use IS_ENABLED(CONFIG_PROVE_LOCKING) as 
> this is the real kconfig that enables most of the lockdep checking. 
> PROVE_LOCKING selects LOCKDEP but not vice versa. So for some weird 
> configs that set LOCKDEP but not PROVE_LOCKING, it can cause 
> compilation problem. 

I think I get confused too. The various lockdep* helpers should be 
defined when CONFIG_LOCKDEP is enabled even if they may not do anything 
useful. So using IS_ENABLED(CONFIG_LOCKDEP) should be fine. Sorry for 
the noise.

Reviewed-by: Waiman Long <longman@redhat.com>


