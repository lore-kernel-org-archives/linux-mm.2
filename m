Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A85CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 03:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218A98E0005; Mon, 20 Oct 2025 23:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1A38E0002; Mon, 20 Oct 2025 23:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108098E0005; Mon, 20 Oct 2025 23:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3D908E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:50:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E64E1A03A1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:50:05 +0000 (UTC)
X-FDA: 84020743170.28.C9D3F6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id D9D2D4000A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:50:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R2JOUsMf;
	spf=pass (imf12.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761018603; a=rsa-sha256;
	cv=none;
	b=qt4jt1WCYqCVISn+uzIpeYdlylU8Egrt4FYHsCiyTLcyQ/hgIO7Qb7EuscEdlzcDG7qdX7
	hb5Zba3gXyUHM0MPQ8SOYQxHrgMSTDEvet4MaQNb9Y9aku8XGhBse3+sEnppknqiUGsKDU
	djBmCVaXA+z+CK0rOsh2aV3wsCs6w/8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R2JOUsMf;
	spf=pass (imf12.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761018603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvtwqFSdwBIJ1DhFupvj6yUOG7znXFLvI8hL6gZ8038=;
	b=qnF1os5t5+aSYXL59oT/TrWCx7A56KcoBkfP6O8M5yR/BouQNUxX9v2x1yS05Jhcn29rBz
	Hj1W8wl6eUFn7UF84z3cFV96CyfGA/CZh5sSMW2QJSAVLLxzfkCAAv6olidevigzqdJNq4
	GCg9meVsxxnCqbz84GWnMD7nIHLqOsg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761018602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YvtwqFSdwBIJ1DhFupvj6yUOG7znXFLvI8hL6gZ8038=;
	b=R2JOUsMfJ9GVz8tOB8Ndii3xncaHOvn3QUmEO9Yi2bC/B0uPv9CVvsa4rzO9lGbAYo3IHr
	yVEw3L9qgr4wtChmaeaK2edEbYrpoBv3GUMhg07IulW/Af4V4ba8sYXVGzfsg9MZOyBntN
	f9a96vLNtLocMw5WtmZZbhRAXv+U0UY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-QOWjyXV_Oe2pFNp0GWcikA-1; Mon, 20 Oct 2025 23:49:59 -0400
X-MC-Unique: QOWjyXV_Oe2pFNp0GWcikA-1
X-Mimecast-MFC-AGG-ID: QOWjyXV_Oe2pFNp0GWcikA_1761018599
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-81a8065daf4so93658576d6.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761018599; x=1761623399;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YvtwqFSdwBIJ1DhFupvj6yUOG7znXFLvI8hL6gZ8038=;
        b=lSRTuvDrzlzGdQQCH0agXaL5DxTd3hxQ2kBbFZT1z2DDN0fSItRmK5CHV6C2l0xxVd
         nuw2p55J2dmLOFz9tEGNNrBuiG1l+uibeY16HLpmm8eGUGH5lWBAQgQd9/sqAANimQ4P
         J/9PLWNr/N/b/131MU9w3wGUYHGJKCaxjFZuOIZdODUNpit+c0J1SnKiXLte4zizZEB5
         Uz8n5/PHpyVU6Z+jNTY9jy5RQgPqoo8kU4gLf9MFoFh54tfQUy7tes7PLbfCQHD0Gmzj
         9J5GcLRFHPzMWfRPul1JFtXWavmqf/Bua360WaFhyQJekP5ptxyOK1jPZdhdIcmOC+bk
         qo9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWeUA2VWX3pFbzW0ig0MMgzGsm+m0aWzmqAhINb2T5Mpq7fBRJUDw+3nvM41CQbYqC6fMK4DB9d9Q==@kvack.org
X-Gm-Message-State: AOJu0YzaCBOHhj/gt/+9QPe/Vq1Mx2h2ih0kZJYxzVb2ebpVHF926G/h
	7N+dM37Gt77pj2uymIoCRpeXI+CqzIq2eRJCz0ckSxmiX62g++P5JMNsXpKXcNkAIW348L/Sai5
	bmzDJUqpL64ZvB07w1w/ubXgRkrKIkJrEqBxlIs4wf4CCLg0UFpie
X-Gm-Gg: ASbGncuf3H/t6mbwv1LbNP9BwimrdKrK2cU9jZ97JLqsnn1YuPKZHHimyBUcEiTD/pR
	RsWAmP3N5QzfUihW/paBh2UqJf70YMRN8pJMiERWTUMSBzsRx0SSgpnD/ASjN9pHVVvDXmfKGMP
	zNY7GSSd/Pb2OU8fv5htmnz1ZxeD8vzPmFR/Y4B7yUgc67Ls6U4BR9QkM7MkAVOpJMeP2bLtptD
	tRWJejg9VDk3IuYGU2qB9ESL72HaMM9/GxeXtO8irPxK5k7bfzw7XrvqNRJHXTdd1XkcpuwRfHr
	4YH3pbsxSmXj0bpNciNCzcTCF9gmgDatYH3wYIkyk+qBvlEtyVVKElcAFGG+53xUNrXDJAs9Ja/
	Awmzl9L0orXyn3SEvNduGfsdTC8fIWR4Y+NY8AA+2Nb1cmA==
X-Received: by 2002:a05:622a:14d1:b0:4e8:ac66:ee45 with SMTP id d75a77b69052e-4e8ac66f422mr138856431cf.43.1761018598793;
        Mon, 20 Oct 2025 20:49:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzYxTQpPj871EoIMw1y246oGNNWS2hGT92x0DCSyPVsnjuqhhKKjEAvaY7EAUAoH4h5eayPQ==
X-Received: by 2002:a05:622a:14d1:b0:4e8:ac66:ee45 with SMTP id d75a77b69052e-4e8ac66f422mr138856231cf.43.1761018598358;
        Mon, 20 Oct 2025 20:49:58 -0700 (PDT)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cd6717desm684147885a.26.2025.10.20.20.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 20:49:57 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <083388fb-3240-4329-ad49-b81cd89acffd@redhat.com>
Date: Mon, 20 Oct 2025 23:49:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/33] sched/isolation: Convert housekeeping cpumasks to
 rcu pointers
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
 <20251013203146.10162-13-frederic@kernel.org>
In-Reply-To: <20251013203146.10162-13-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5WvckI1Wrqg7fet70fNGHnsYUM5zOpjx6X83-YZV1o4_1761018599
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 6zeex3e59b7ndpgskxfi37o4w1y8dsyk
X-Rspamd-Queue-Id: D9D2D4000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761018602-580707
X-HE-Meta: U2FsdGVkX193QZjNjjn/YPrc8X/yR+iO/28zwehMNFlGbTsWc5uuULLqyrtFF2fFmuqoZxLktboE85cKKzrtDphmDv0q98QQjsrGpKiJbUBTy7MNQajHpci1WwJoDfrjs0Q5e0Ncthgo0dGwuSz/nDRgDtrUhMQxJ35J2lgmLIJUQiRi56HCDq58Ty+s9nTMJR5COKNPAAIBsKU/2G5miLG2ya+XJQbsHFvNrk1WLQqkLWw2+Zos3Xet4b6nnOzlgyLqJsWBQRV+GT5Jnuu2EVuqI7SOwjxqaNdZkWROE3opcSWVlh4XiXGSjtPyyUmZuP+BcxPhkpsBmq6XySceCWVhLxHaDO3p10LwmPhELASkv1kmVtI+WgnufzkImDwYsGtx9jVNkX4LbPBdNKhlYu65dyPXjego5xxa+Xqkbwpui3RzjnagzvBWPt74oGQThKJl1egYK9zXCYKgfS/JQ2IozNQKRe1jAngBET3czqfwITA5KMYRrLm1xVeAICn3g1FeFAscgiTFM9w/9J+wowV6E6gE3xYs8g3v43QMfui6y4u2t1PZ8VaCiJGSEicA/DB58zJPoTCctzSNCWip4zmzxeTIOX9QTchRK7zQfDHB90CYbAhgudvGjUxOt7wP5PWkGSJa6lpWLvXHrKYOIPTCoWVHrDguGfojFEPFsCZbfCdkCnw8nL+f0RouJSnMqNoocdw2fOQYq/1BO1uiwnxT5mscFdIaS4rKFaLIfn/Gr/HitGLRQU26/IWwHm5CbvauLGSLBAWaI2nMfyF/KGyP7Y0pko8EinzOteUCtljReAiXiN/xoe7zRND7Wv+y74W0RCD/hK1p7d8GxWbiE0LGmp74M4cG/fjw9o0BtYEN7fT1kGKpL3O2uRNIltfTDRUsabfyZvhIB4SDNiefn22GnHW+ncESuvlokL+ainilXDwBRWREOkR8sMLwyCXq9WBDSZxQg61XOPx0Dab
 QCZ8wP2r
 t1ruuyuEid2NVQyY+FM9JDP6gktw4MpFAtRmyKjHpVH5+OZV5yT0I+NkcPyEC9Gb8aqJNDaC7WEFSPnyktHt0Up9y3hsPDJBoN5nXiYQTv3L3hkPbKBl4O6ljWQlBOMR2HR0eTQQvWDTVT7Y9FeWEeI0My/1OKyyfOZgUSsWvr4wwhAVFd/MVVNqlyNEII5gZ+YHJK3TqZYY3FCnuNL1y1TahTq7/SHKrfsb8oGkL/m0AZ7MCpyNLBLN/ZcKtbRaYskzUNSnAL6X/2Mno81Z3xNOt2HBHTO6KVWH85aIK3ZgBRnCZ6ltc3X6xsTjKDQA9VsfLKONZzfWbbSOp6SKhJif86C5lAmtig3ZwtKnEnCG6dOon2bHD4EMH4aQ9r+FLshVFxwlHwLA4K1LhmUijJg9VUTN+VtD978Ut3aZKAUtik2JYG/qRWEfJldv7xcEq6mkNFL1U9fKF5rNh6L82uUTz07vp5c9wHe/h9OHOSkZINJqFTL6o1Ez05Gi7gyJakcJdYtBffNOeu2qhFd1w1T/dsY+BYqHQ2oXh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN's cpumask will soon be made modifyable by cpuset.
> A synchronization mechanism is then needed to synchronize the updates
> with the housekeeping cpumask readers.
>
> Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
> cpumask will be modified, the update side will wait for an RCU grace
> period and propagate the change to interested subsystem when deemed
> necessary.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   kernel/sched/isolation.c | 58 +++++++++++++++++++++++++---------------
>   kernel/sched/sched.h     |  1 +
>   2 files changed, 37 insertions(+), 22 deletions(-)
>
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 8690fb705089..b46c20b5437f 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>   
>   struct housekeeping {
> -	cpumask_var_t cpumasks[HK_TYPE_MAX];
> +	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
>   	unsigned long flags;
>   };
>   
> @@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_enabled);
>   
> +const struct cpumask *housekeeping_cpumask(enum hk_type type)
> +{
> +	if (static_branch_unlikely(&housekeeping_overridden)) {
> +		if (housekeeping.flags & BIT(type)) {
> +			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
> +		}
> +	}
> +	return cpu_possible_mask;
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_cpumask);
> +
>   int housekeeping_any_cpu(enum hk_type type)
>   {
>   	int cpu;
>   
>   	if (static_branch_unlikely(&housekeeping_overridden)) {
>   		if (housekeeping.flags & BIT(type)) {
> -			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
> +			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
>   			if (cpu < nr_cpu_ids)
>   				return cpu;
>   
> -			cpu = cpumask_any_and_distribute(housekeeping.cpumasks[type], cpu_online_mask);
> +			cpu = cpumask_any_and_distribute(housekeeping_cpumask(type), cpu_online_mask);
>   			if (likely(cpu < nr_cpu_ids))
>   				return cpu;
>   			/*
> @@ -59,28 +70,18 @@ int housekeeping_any_cpu(enum hk_type type)
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
>   
> -const struct cpumask *housekeeping_cpumask(enum hk_type type)
> -{
> -	if (static_branch_unlikely(&housekeeping_overridden))
> -		if (housekeeping.flags & BIT(type))
> -			return housekeeping.cpumasks[type];
> -	return cpu_possible_mask;
> -}
> -EXPORT_SYMBOL_GPL(housekeeping_cpumask);
> -
>   void housekeeping_affine(struct task_struct *t, enum hk_type type)
>   {
>   	if (static_branch_unlikely(&housekeeping_overridden))
>   		if (housekeeping.flags & BIT(type))
> -			set_cpus_allowed_ptr(t, housekeeping.cpumasks[type]);
> +			set_cpus_allowed_ptr(t, housekeeping_cpumask(type));
>   }
>   EXPORT_SYMBOL_GPL(housekeeping_affine);
>   
>   bool housekeeping_test_cpu(int cpu, enum hk_type type)
>   {
> -	if (static_branch_unlikely(&housekeeping_overridden))
> -		if (housekeeping.flags & BIT(type))
> -			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
> +	if (housekeeping.flags & BIT(type))
> +		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
>   	return true;
>   }

The housekeeping_overridden static key check is kept in other places 
except this one. Should we keep it for consistency?

Cheers,
Longman


