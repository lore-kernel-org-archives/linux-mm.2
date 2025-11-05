Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E0EECCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 19:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BF78E000A; Wed,  5 Nov 2025 14:34:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C368E0002; Wed,  5 Nov 2025 14:34:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3998E000A; Wed,  5 Nov 2025 14:34:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87D608E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:34:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4865D16020E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:34:06 +0000 (UTC)
X-FDA: 84077554092.05.6F7D18A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8F353180017
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:34:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N5UIYZQZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762371243; a=rsa-sha256;
	cv=none;
	b=OVQP/FFOZqAkFXGp0T5/qbVMwBbD+63FBqoloxUfZDl5dCeEWpus3JdFcJVUJoSqv+SkQJ
	wX5bh/yYc4sh88Bzj2mBwafQAfKu3P1brDEm/KQO+VRiZ/XN3NFIq9Np6JznHs1jAeGnCr
	WPZ6HVI5lmXVolDm+0Si/pnJYuiuhes=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N5UIYZQZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762371243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2I3VQegSFx+o1eosI30+XZ8D9IOQq1JJdeZxqs+aI0=;
	b=v7Cogg/Q/TTTDixS86VgTZTPviQiNdQL90dCerEKtPZiSV/JgH9vwyNiPC+ZNlcGzF3Wgi
	ifwIWhxP/STymeFjPTq7/k+yjfPIUH2TnAJVsC479zmGUkgtJiWKZb1QqQcaxExo8lKZvx
	MEBEA5/oLDhzrSDIwz3MuxqShiSnv2o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762371242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W2I3VQegSFx+o1eosI30+XZ8D9IOQq1JJdeZxqs+aI0=;
	b=N5UIYZQZPf3NdxHWQ3qX2EljS91f8WJ6hHlX0KrQ9zp98Yy76QvIUCaaPiuC1BLS0fzLAR
	EEd757ub4R2HDmTJJ0tD83n47C8VjYo8X/lVppVGanjb5V9j+XPXr5Web6e0XJbQloX0N3
	zldmZIkQNGOVwvT17HCnfTHRHzw82dY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-wT0Ri1haN5muXfQm4tS3lA-1; Wed, 05 Nov 2025 14:34:01 -0500
X-MC-Unique: wT0Ri1haN5muXfQm4tS3lA-1
X-Mimecast-MFC-AGG-ID: wT0Ri1haN5muXfQm4tS3lA_1762371241
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-89eb8ee2a79so97247285a.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 11:34:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762371241; x=1762976041;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W2I3VQegSFx+o1eosI30+XZ8D9IOQq1JJdeZxqs+aI0=;
        b=DhE0nDXs/3gGEqjgqLFfMcjay6BSZNDMUNH6tMXAMVapjFa3Q0Q+0ktZN6YYSQpSVi
         eCOGDWLlm7Ne+I3IOY8V7nxeKplbmj6ArBTvurgmYGElpVYjvFJxD3ckDBE/ABXuIcCl
         28WQE02npQPae7rh/cgiUjN9VUPhgrZgYqEIBvZyIKWp3O6KSuUe2mej1ceLQYpDL3sn
         nCeIcCgyaiIs5++fc579Od7jFJQJR87S0ywORnaxGzQ54k1X5coFs4oCQApGKvV/TSZg
         1LlTfkO0Ueqz4t3SXI19E4Uexi6/GOcOhHFAIb532BX05k8S7Ekl3aXDisPtoPp4t6a6
         j1cw==
X-Forwarded-Encrypted: i=1; AJvYcCUDBgCGHnGQceAy6Jd45HDSbTbzlzTrk1jBR08SxFZYcuYSZ4Ta2EDmT1FRc8KXhOFzUB198pXpKA==@kvack.org
X-Gm-Message-State: AOJu0Yx2iO0KHLIUVhGWznK4e/p0COhtfgHRFfg3ATK+wjDUKqDRNefo
	GSyPIfDPGvadzp5sCDj5gU+3+9Jvjj7O09B5UKBFhbE1VOtOOeyHzcs9CYezv5p+78xEwX+JYhn
	vSrJbr8S/xlIVu9+lpVXtiUJTB/uvROEqBs7tXDwNnTAEZYdMHipc
X-Gm-Gg: ASbGnctnAiVH7YXcVYVzvc2MrQB09+LppzL5ZiVB+m6I0S4mx/ifiR81KT+2Oc6AreD
	5p0a7BGuqI510i2/yR8So2jB1rRVjWiGrhYWtjk6JE5l4Dju3a/NAP/kAMIhIjGWe0AAmKDYgHd
	oT+VvSK3dDtmBciphK9Gdl5qsdprAR1pVFWu86ZaqVfS9LJxuBmteZEsHTrVKf8oEKcpFbT7DlG
	gmWzUx4GRPXgyFTBLANO6EFWTM4gSMxr5tUg1mvqyyTyhHn2JX2pmwxrcDvzEyckrccFxitEQUL
	Y1tvX9qVYP8B8QBowknap8qM2Kqdk93qcTWUlAy9nThLzWFuHIiyuMUcAKwFECqg+Ma8HWydYR6
	4n97+EWK47BPsRnFFRZM+Ec/KENS9vWYgqFjIwni8HVBvKw==
X-Received: by 2002:a05:620a:4807:b0:8a2:e35f:90 with SMTP id af79cd13be357-8b220b1d46emr570525485a.30.1762371241163;
        Wed, 05 Nov 2025 11:34:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiRwB16QATLm26IUQJMPlOrIcZC/Pp82bOb2D9HMznRcFkSivER3LckBzG5MspPvf0gexFmQ==
X-Received: by 2002:a05:620a:4807:b0:8a2:e35f:90 with SMTP id af79cd13be357-8b220b1d46emr570517185a.30.1762371240407;
        Wed, 05 Nov 2025 11:34:00 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2357dbcc5sm28762885a.35.2025.11.05.11.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 11:33:59 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <a5e3294b-4d37-4e98-9442-e35ca1949c17@redhat.com>
Date: Wed, 5 Nov 2025 14:33:57 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
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
 <20251013203146.10162-14-frederic@kernel.org>
 <0e02915f-bde7-4b04-b760-89f34fb0a436@redhat.com>
 <aQtwbRrFBCUoQ2Yj@localhost.localdomain>
In-Reply-To: <aQtwbRrFBCUoQ2Yj@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ai2A1Q24EdgyifRrx8rJRzZlUaeD2fDd-Yrpu6t1k9M_1762371241
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F353180017
X-Rspamd-Server: rspam07
X-Stat-Signature: cjje4ryazjzq4x61be4onodh1ehazsgf
X-Rspam-User: 
X-HE-Tag: 1762371243-357776
X-HE-Meta: U2FsdGVkX198Pj2muMjDKn6IJDEYPe/6ZouEjokQ2WmBe0dZMrj5uhdGz0T0vsRl1dI4RqLaHMbv098bi9jJkVYRoeRNFpWpqHHZRz8vQZaHOLwiWF48NvAtRnA6X2VTnW/3uvStJvAxjKT2zdxhguxQNTLNCUI9679ADMkqr2ErQ9t3b7J9ePtmkl82OWlRMtDy4bQ+uVybbbHJ/XOyBfZA0UuhpwV2R1iLLk76gD0F/P4LMY5IknBRWmLpMr9tivHf4hdEUJYG1m+IanWoNonuMVS7lC/1p22u4AxQeZ54PnwJXbbLdPEDFI1j2cz69KpYCjRNnfPMlVKcsBELZuHfcPv/EUeLocDhfLyeotLpijBYgfwGeobAcUp1qWI6OABYr7aysusN/8B6Lp8kWfw5TwZJ+JZ8D+rD/4Ejn/DR8sw4EbhYNmWLqfFkPX3hjAk/pn74iuvleYRZyv8srQEmbpk0hx41f5qs2VGRw8HguA+pp7hiasr6i5W360S1QMFt52SoIpPFd/acJq1Za+eDG9eF1x5r5/pQ0BcYy/8KSGkvunKFkPJ/QYl7xEsxFh0Bv5dQVK8sfKP/WfJXxyTfEeLpTFZ4d4LyurWhDaS57wMcLUNglOiQ31My3LEohdN+m9y2y7oDz6jveDGskbXB4cbvzNbZ/PyjCQ3NbnRGTEGGHFNLknIBJMM+fMu3WCJ1XcrvwC4fYE84gW1iG/mkSJjDFDhvPycDPH39eiZIdE7B9fTgf3Nz93mrUlfe3Nzdsv85/Jamxm6aRUM08lrpgK4oXdpyYKmCc6LoVP3Kb4te0v1dTEOZgGaiq+hpXKXK7pU3xlEOjoGlKaKHo9aJU8k3Ty2iBeai9PN/Bxwc1AdKMjwNLx6dYsxkA0ZW3M04cutN68358W0jsnufez2WqM+UTZOIPRMqOjGdsJ57ATrsHyeOOXI5QGpnxpwbpP3NarF7yupeRZ3myQv
 LGlMuxyU
 kQBoSqgmVQCZZQ+xOAVnsS1kRQ5BWc0+KWjqbsqAMjBri/KzEdFGsRGTVsildbtfFFaK25yTHYyqnISVz4lMzk6wSwd0MsSpS+TvcDqRguCS6I2uOuX/7FgEe88cfH/5DfncJ4BCqIMAc//PD2Dp99jVg6GWd359249zTaQmVGCMVIl3BGUUDZhNwxonQTMjycx2KQHM96B+Ey/5jAyAR2ke1k8UM2VGtNcoa4615ZdfRy1gdck+iC3/7BOvjDxChq4OvCBP9stavGdVEM7Eh+dNFDbf4Y9qiM8pfdfLd6E1ohVKIudg0+1iHfq/qBSR9U59f3HhhHnGbfwvA++8K1PXCGs9/s9aBuHPhiu+yxfHxHLstckHmvzyBsKlDq5DZIp7OAAHNsdBOb5gFzky6SEaebzi0UZ9FX4/vSqFzq4iSsL/7da+xqcvvTvkgGRGura5OEVPL6vSTfxjudVjN9zDlPjjWQ2BFaB3u8iN8lsTAVSedCFKRKzTJDXdfOEaH8KQl4t2MjHfFdveq/q9JygXfJDawobSGS8lK7MnBfxWIH0V2IDxnjnVxRNfPdnQnoQKPykkvSF7Z84Ecj4ZUbihI3T9sevynzK3DAciek9kjpn0d84V1Ee72hA3EupNBKixoTQ/Sr3nCiLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/5/25 10:42 AM, Frederic Weisbecker wrote:
> Le Tue, Oct 21, 2025 at 12:10:16AM -0400, Waiman Long a écrit :
>> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
>>> Until now, HK_TYPE_DOMAIN used to only include boot defined isolated
>>> CPUs passed through isolcpus= boot option. Users interested in also
>>> knowing the runtime defined isolated CPUs through cpuset must use
>>> different APIs: cpuset_cpu_is_isolated(), cpu_is_isolated(), etc...
>>>
>>> There are many drawbacks to that approach:
>>>
>>> 1) Most interested subsystems want to know about all isolated CPUs, not
>>>     just those defined on boot time.
>>>
>>> 2) cpuset_cpu_is_isolated() / cpu_is_isolated() are not synchronized with
>>>     concurrent cpuset changes.
>>>
>>> 3) Further cpuset modifications are not propagated to subsystems
>>>
>>> Solve 1) and 2) and centralize all isolated CPUs within the
>>> HK_TYPE_DOMAIN housekeeping cpumask.
>>>
>>> Subsystems can rely on RCU to synchronize against concurrent changes.
>>>
>>> The propagation mentioned in 3) will be handled in further patches.
>>>
>>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>> ---
>>>    include/linux/sched/isolation.h |  2 +
>>>    kernel/cgroup/cpuset.c          |  2 +
>>>    kernel/sched/isolation.c        | 75 ++++++++++++++++++++++++++++++---
>>>    kernel/sched/sched.h            |  1 +
>>>    4 files changed, 74 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
>>> index da22b038942a..94d5c835121b 100644
>>> --- a/include/linux/sched/isolation.h
>>> +++ b/include/linux/sched/isolation.h
>>> @@ -32,6 +32,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
>>>    extern bool housekeeping_enabled(enum hk_type type);
>>>    extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>>>    extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
>>> +extern int housekeeping_update(struct cpumask *mask, enum hk_type type);
>>>    extern void __init housekeeping_init(void);
>>>    #else
>>> @@ -59,6 +60,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>>>    	return true;
>>>    }
>>> +static inline int housekeeping_update(struct cpumask *mask, enum hk_type type) { return 0; }
>>>    static inline void housekeeping_init(void) { }
>>>    #endif /* CONFIG_CPU_ISOLATION */
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index aa1ac7bcf2ea..b04a4242f2fa 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1403,6 +1403,8 @@ static void update_unbound_workqueue_cpumask(bool isolcpus_updated)
>>>    	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
>>>    	WARN_ON_ONCE(ret < 0);
>>> +	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
>>> +	WARN_ON_ONCE(ret < 0);
>>>    }
>>>    /**
>>> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
>>> index b46c20b5437f..95d69c2102f6 100644
>>> --- a/kernel/sched/isolation.c
>>> +++ b/kernel/sched/isolation.c
>>> @@ -29,18 +29,48 @@ static struct housekeeping housekeeping;
>>>    bool housekeeping_enabled(enum hk_type type)
>>>    {
>>> -	return !!(housekeeping.flags & BIT(type));
>>> +	return !!(READ_ONCE(housekeeping.flags) & BIT(type));
>>>    }
>>>    EXPORT_SYMBOL_GPL(housekeeping_enabled);
>>> +static bool housekeeping_dereference_check(enum hk_type type)
>>> +{
>>> +	if (IS_ENABLED(CONFIG_LOCKDEP) && type == HK_TYPE_DOMAIN) {
>>> +		/* Cpuset isn't even writable yet? */
>>> +		if (system_state <= SYSTEM_SCHEDULING)
>>> +			return true;
>>> +
>>> +		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
>>> +		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
>>> +			return true;
>>> +
>>> +		/* Cpuset lock held, partitions not writable */
>>> +		if (IS_ENABLED(CONFIG_CPUSETS) && lockdep_is_cpuset_held())
>>> +			return true;
>> I have some doubt about this condition as the cpuset_mutex may be held in
>> the process of making changes to an isolated partition that will impact
>> HK_TYPE_DOMAIN cpumask.
> Indeed and therefore if the current process is holding the cpuset mutex,
> it is guaranteed that no other process will update the housekeeping cpumask
> concurrently.
>
> So the housekeeping mask is guaranteed to be stable, right? Of course
> the current task may be changing it but while it is changing it, it is
> not reading it.

Right. The lockdep check is for the current task, not other tasks that 
holding the lock.

Thanks,
Longman


