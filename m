Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FA9CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262B48E00C2; Wed, 29 Oct 2025 14:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A7B8E00B2; Wed, 29 Oct 2025 14:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150E78E00C2; Wed, 29 Oct 2025 14:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 04DD78E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:05:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C60849E09
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:05:25 +0000 (UTC)
X-FDA: 84051929010.06.3D4CD6F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A64D4000B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:05:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CzK6rvVX;
	spf=pass (imf04.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761761123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNxXxUzXoqQQT9w5Yf9S20ddLNixsnFzdxWTN/CN8Uk=;
	b=Ql5wWGrSEa8EqxJ6vskHeATPUjLSKrgIyABf56OnX59LWwhHPnEA4l/gLxpdqyw1Ildycx
	tDaOQrl/52/RJXDwyJLgFCHVk7qyMVh2MJUjuEU+z/l8nqNjEUKG/PwGXuHvftiIf+IfyP
	ZDkoGiw9Li491UYe7uzKY00YhfYtSxk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CzK6rvVX;
	spf=pass (imf04.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761761123; a=rsa-sha256;
	cv=none;
	b=1D71KRs3ZHm8gtjFBOwh9RF/t7jZSGBDxAHCTFmpv5d61mHj6dJByuifO03q07Cce4v2oY
	K2BOITTe5sADKEz5fW/SNW1voafCLuFwFzHXHSfk/Gdnugnn39kcIv3WqfcOXp8PUYX0TU
	FeCb9cqLv/Wk+W6LWwldnxFTibe5yeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761761122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lNxXxUzXoqQQT9w5Yf9S20ddLNixsnFzdxWTN/CN8Uk=;
	b=CzK6rvVXkHLPs7sH+Hs7gaX+eOZgHfh505gYz7jLU19UnA6WTL5TNrE/vVDQwDy+Gg3b+w
	o+RaIoH53mI6VMFQfViqwYhri6xex71+J3fg2vyXMdasWSkM4QVvk0avDOzjcliKUeeadE
	OOLOTjlM3EoGxJBgSowNNFQtBRMBYOc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-myVDJ_foNLC6Tfy_yzxxVQ-1; Wed, 29 Oct 2025 14:05:21 -0400
X-MC-Unique: myVDJ_foNLC6Tfy_yzxxVQ-1
X-Mimecast-MFC-AGG-ID: myVDJ_foNLC6Tfy_yzxxVQ_1761761121
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-890801794b9so35015285a.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761120; x=1762365920;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNxXxUzXoqQQT9w5Yf9S20ddLNixsnFzdxWTN/CN8Uk=;
        b=VYoCzb/Mvae1fEdAtUs72uTjXW7y2NBWjk0HlqOvyDvaxFEUgtwpzR8CZYaIPlpenJ
         O6Ds0Gnq+lQWYtAeIqyuK1U+kuTjRLACQvbgEJMGjZWLRMfGkE+PX2shVxxtyVS2ayT0
         gyGJVqhDLfimEyKDZpzH88LQMHlBrcZd9cd6B686KVVaiIvkaSf/YM+IugIPCax1ExK+
         Cqm0RrEFc8l8ILIl1rMiGsn/0UfC/773LtKYRf8Y/xaDec6NqsXwCfd8egWPNZw7vP2x
         nflWwhkCy2kEN1GcWvJPgGuKRqnjiQht6HjIb0fdubhFbuCGqLxbu3NZdePZTcP6moKe
         y5zA==
X-Forwarded-Encrypted: i=1; AJvYcCUzG2xGbugRsW1L3oDk0NoNABAxCpqBIPzKSIKV/8V4fdVXAGrbtFy1IfgqYi2+3KBxIAG4JYzjFA==@kvack.org
X-Gm-Message-State: AOJu0Yyif2h0+4rTm4o4aJCQgDhuj1mpfSFEFg1itzmuHZKmsFJL79KR
	5kNRkUqQaxFznedrz3sIgtGMzNyw3+XkpllAwZLiP9Lw9s+KuraFM3LWPKc4Ri7203f2UnLnXIJ
	qeA0dgo8oY2tsEN3q4zB9XBFJYuc12GIp+NHEyRL6mXU/peAN6Cnu
X-Gm-Gg: ASbGncuHhZ853ysVjLeiLpDBGKB6FPaADSfmeCUFb3LCjUa+orfSfFhVLLs6JygQaWS
	S5h1w1Bt9iZJKIvMS9fN1fMcZubOjh8IAbbAimH7MZsVpS/fFjAE/Tujpd1dK99mA+U2UMRfp73
	UwuZvQeU8iN1pC49G4CM4dU3005RVMBUJRveT/TmIjrZNe1sJ4K1sr5fK+ttQQ5yNOO9XQYTmod
	DSlWYwP+PZ4vADpZ23BKn16Tkhzgbuyh1GHxPYxgwkRkNMlMQkCJotKHtQ9s356pjJM8NkXcEvT
	u93DaqKh/yKbAlCUraP4M8TnnY/ZspcUtDcFbmfcazrUiC+GK5X+i6QRpIfiY8/HT4/xDN+IyUG
	xL4Xs05jaV0nhI7ANPttW4EsXnOuubbtLN8Pf6TU1FzQJgg==
X-Received: by 2002:a05:620a:29cd:b0:8a6:92d1:2db5 with SMTP id af79cd13be357-8a8e473a6e6mr573643885a.24.1761761120464;
        Wed, 29 Oct 2025 11:05:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEE6iTF4BqCkm725oJpB//2W/KjYfs5LBPrMdbtexGrXjP/dhJ17Z6sn/BKCKYXRH3K32fmkA==
X-Received: by 2002:a05:620a:29cd:b0:8a6:92d1:2db5 with SMTP id af79cd13be357-8a8e473a6e6mr573635985a.24.1761761119960;
        Wed, 29 Oct 2025 11:05:19 -0700 (PDT)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f2421f6a5sm1111574885a.5.2025.10.29.11.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:05:19 -0700 (PDT)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <7821fb40-5082-4d11-b539-4c5abc2e572c@redhat.com>
Date: Wed, 29 Oct 2025 14:05:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/33] cpuset: Remove cpuset_cpu_is_isolated()
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
 <20251013203146.10162-19-frederic@kernel.org>
In-Reply-To: <20251013203146.10162-19-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pSf6_fUuzklQawVWvLOXhDkisTlVKMx6RGaqbConNho_1761761121
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yjxnpczygzg8c6juxmmt1dm8p43a1efm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A64D4000B
X-HE-Tag: 1761761122-244384
X-HE-Meta: U2FsdGVkX1+3ujwVFpdZmHZSIwYLa+oacF4WKT3hsQz8JGK4rqnSWEokR9p1s9p0UeOW5Y5tLCyKXh54lGBzObKbQICpxYsROQ09VckCsSzphG2nmLezVppbKWCITwZKbRYjEhRNkk1KmyKe9B1xQHdwKQLTmsVcZoxbAtYog9nAT4mU/fdOMMm+SMJfbl/F4wvLuAsc8amJ4B5AwEqWEHLn1fY4q0tSs24NjrdOkjsgdmQ0hVfGA9tiNubd33S3lERVSPIbC9Sz0Wd9sr1M9scHcDIDxAjMcx0S3tp8rE80RazdX35ZA1dJnKX6ViZNZ7jk/zzd0GvJPX/bayeMQSVgj8qVJ7jHAvIlt+YGw0jxN0Cf+Av+izm+hJgXuRjk7FApYeW4WJdWtsidNkDY89koLmFNBEs18FzeMr/myFEq/Xx5rywLHsNx3uSuxH+cd9a07b17UaGtYPkASjLihwIEBtnIASTAvo3aTOBf+lP8HBNSeZZkEGj7hysS9bsvIzUjpjo5gEPQvDz/Zm03BK6mXJiOrrYBF9+Z3t3/+9qnt5fk+DoJMcBaZfFDTLZCeGjI2PF6MdvYtDZojAcTc11xjmDccxRvElLzSsacACAg9fZCDApE6eVlpfZECOaOPF1Heoa8HJjYWlkRY7prSA+MzcICJIVAJKVn7UGMfxaE8KF/NMhHrgIFUa/gaI6wO2EZeC+PZ9yRkHupsUo6gW10AoPLpGah1wNQQGuSoKx40WBRxrJPpzhmFGFCN+9KvCC/f1kahQ7zNr0k0fQJQ5XRqg6FtmrEGcdgVSYt0R5cp8NlBpUSti/AnYulprdlFPFs1uOhXi1sABHgCEJ+JPt1/4/80zGWdVfudZCUshCyyogmkrWp/XPusP8UGOI9llkrpu2BtUVBCiLH7zaxPdvU0oPXJTavEQTMl4s8pBC0ZAuW3/Ievy/fuSOoJf5NgcboUA3yzM/eW2EiYDM
 ftJclLND
 nWupqBHBK6jONUhEGYjfxM46kS+vvjXiql0608L0ECs3kzba+MQ2xt68sxM6j+4OwEMNW4tW7aZANKpSnABQgPHohb8+6un6i/dhV2544zfLfAnoJbyaFSvwksIPO1WfrlS4iT3oyRgeZFeg4aCHEzY9s/QbK6QtGq7d8ftznwQpdslPJfJSUIAXQc0j9gEoPvWysO5RqXCdkFneOGsFEjf5dGE2uDkB9dsttvvlikX+50Bl9vj6oD6Hl+RR3EJmD+ZLRWTfDHHT6tiXYRSUYYtjPJBceovfTm7CPg4XbRtEiblnaypSvqWKKn7Sy4BEpjFX13WBUvGNI94E2SirWxeLKPmAi3fEDoXZUWj9Cntb531otbshDlHHy6/z3GuGz2W+JTr+73D4XBvXiRQ/agDONVLPZP3XtE578tGnhZN++ifEaH5APwE4xEsZ7d+RRd7CMdymSUVARl1uY2k4zhGN3e8ngczyxW68QnzdKmU97gipmnXkaqz3bxXgzEi5hPcFvCaWh6DZzZ+3hXHIcThqq03YBaRuD84wMIjRuc74R7o6xGrO2XM9miq4xD5yGOmOODQEHxl29l/qwHatRX5bMl7vlIcPkkvfmNVHB35mJbNtYW22SWag+RA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> The set of cpuset isolated CPUs is now included in HK_TYPE_DOMAIN
> housekeeping cpumask. There is no usecase left interested in just
> checking what is isolated by cpuset and not by the isolcpus= kernel
> boot parameter.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/cpuset.h          |  6 ------
>   include/linux/sched/isolation.h |  3 +--
>   kernel/cgroup/cpuset.c          | 12 ------------
>   3 files changed, 1 insertion(+), 20 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 051d36fec578..a10775a4f702 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -78,7 +78,6 @@ extern void cpuset_lock(void);
>   extern void cpuset_unlock(void);
>   extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
>   extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
> -extern bool cpuset_cpu_is_isolated(int cpu);
>   extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
>   #define cpuset_current_mems_allowed (current->mems_allowed)
>   void cpuset_init_current_mems_allowed(void);
> @@ -208,11 +207,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
>   	return false;
>   }
>   
> -static inline bool cpuset_cpu_is_isolated(int cpu)
> -{
> -	return false;
> -}
> -
>   static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
>   {
>   	return node_possible_map;
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index 94d5c835121b..0f50c152cf68 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -76,8 +76,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
>   static inline bool cpu_is_isolated(int cpu)
>   {
>   	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> -	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK) ||
> -	       cpuset_cpu_is_isolated(cpu);
> +	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
>   }
>   

You can also remove the "<linux/cpuset.h>" include from isolation.h 
which was added by commit 3232e7aad11e5 ("cgroup/cpuset: Include 
isolated cpuset CPUs in cpu_is_isolated() check") which introduces 
cpuset_cpu_is_isolated().

Cheers,
Longman



