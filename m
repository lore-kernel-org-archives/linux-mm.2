Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BC0F531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9718E6B00C8; Mon, 13 Apr 2026 15:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949026B00C9; Mon, 13 Apr 2026 15:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EC46B00CA; Mon, 13 Apr 2026 15:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EDBE6B00C8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:26:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 329765798E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:26:10 +0000 (UTC)
X-FDA: 84654513300.01.CA60A97
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB18220009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:26:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YobZ4JGt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BWr/5AY8ZAqufMs3TADs0Xu7j+z3NdjM/f4VibM9b8=;
	b=mURMLf6O/+7CSYE9haC7k9ufjE9rGbxrXmvFnkgkxjNzHmo4/7fml7iIMSSBfRa2RDw8A8
	Dhy0VYiHHYNTMeil/i2ZLhxdECVuAftY9oChID4XBOfwlpCr+gpp6Ww8YK7az1doBYMBsE
	VfYMMEVON5WOv9wOTjO2T+TUpZeXvc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776108368; a=rsa-sha256;
	cv=none;
	b=MFCegyuCPxP2MaOw3p8PqkzEmHi+4NUPc3hX97INpwH7ybJBs9cgBJykM9hY1iQx48GAWB
	1Wtk4cyVBDUxuZMRnPEhD77+JJgt4vUm1zLg1r+xdTQBVJj4CYV7r+VNaedDaA3hnWbzdI
	K9BH1U7+1oMal3UpDdxg5UwkbLBhpLk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YobZ4JGt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776108367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4BWr/5AY8ZAqufMs3TADs0Xu7j+z3NdjM/f4VibM9b8=;
	b=YobZ4JGtn/c9NKH38eU4+GVGqRlWANCu2rwOqjyyyzN06sHrTtkiirWcsaDiSLc6bnvyfZ
	EZ+NBCmT0K7WNphMQEipX4lmurWeZSjvG+usOcUgqyqb18nNI4nYDkVL+99i5iARG8MHIw
	BQxcuuVwztUgDpDDxuq0/o0+4XyULfQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-Uxe0wUrkPlijpBHtUceyPQ-1; Mon,
 13 Apr 2026 15:26:02 -0400
X-MC-Unique: Uxe0wUrkPlijpBHtUceyPQ-1
X-Mimecast-MFC-AGG-ID: Uxe0wUrkPlijpBHtUceyPQ_1776108358
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 546391800372;
	Mon, 13 Apr 2026 19:25:57 +0000 (UTC)
Received: from [10.22.65.13] (unknown [10.22.65.13])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 53FA31800357;
	Mon, 13 Apr 2026 19:25:47 +0000 (UTC)
Message-ID: <fd77bca8-bee8-4997-a11a-932a1693edf7@redhat.com>
Date: Mon, 13 Apr 2026 15:25:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] sched/isolation: Separate housekeeping types in
 enum hk_type
To: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Ingo Molnar
 <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chen Ridong <chenridong@huaweicloud.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-1-06df21caba5d@gmail.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260413-wujing-dhm-v2-1-06df21caba5d@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: mJb2Uk6rX73RYbC7XuHIaUGnya4d1J2f7YXItzkhanI_1776108358
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EB18220009
X-Stat-Signature: hdanu96q3ei78dcmqjihjdzddtc9ubbd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776108367-99548
X-HE-Meta: U2FsdGVkX1+hd1TBPKdZuxlUH5n+UPLax8v5XVY5tK/sEW6gcprE6TBnfhfRVMzuzwyVhpdljDZTXRC+VUy2J5pJ31+mfxQ4GboIfAgP4VNzwDYVBLvM85713WHFrjpTvsYUoE93q0W+0tTom47kpziEC0dhqaNemGT3F17YxtukDd/fRIDPUjVSuy2hU3kqBfzHi80f/ciOti9C4LYa4PV1A3O7ox/VtDPs6tSXk6OKkeCtcrhcyKR4IB3253EoNIm+uQjMbIMGULekMXMubID9HDlcA/pb+YfIe6z0h1kbXyjvAPkVH+G71e6jIRhpBCOFtl0hh5Z9d88kjSd5PGCuul/jbxsRJWBF3oEhxmM/YrHoZKguG1l/u03Ze+TvlVS8l7n8L708SC2BeyBO6o2U18qg2h1hJ8IrWfxG2iYZwzlCb6inkg9f6BFPvQBhCs8RU/ObztPSio8HSZhlenEB3m88zLgsH/D1x7hiWXbmxiy8V4hboR/7dcaPgjePG5jRfFsMI3otnFtCwNSVZ+4msA7TSP/tpibvA+GxWmwwLiJCRNZhKOgCDucL8smIzXTbRltOXZ9e7EWtckp4r+KfeTjX7peantPJ2v7Y/EwYGDb0gJIxBrgjLm93VQHuVkZA1C3t9QA+4Ym1szPM/5oPxpGotlRXxOWx0CKgPkGUSMnJ658MBUas3cpVASkp1Eq5hcTlRBSIPYqOn3xVPQToI8bYhT1A00xtIC9gwfuZGFC4ausyphUbhHp0j6ZKKusFMkbW24HrRiCRX5WHm4ySH7lL7wuBRefibxyC+PiPSCTSqlUqLN2LrBSqcg/1C/URIh0wQ/4Mvx7Sbrgv8m1mHuo4fjQQGjdlGO3LrZPR/4hCtkkI3PtKB91OLn33KwFxJJOcAM8nvXkwsj+DcY+uYXHnZX1fcK9BpwdQXm0OFueRmEPFbHMad0bC1OjtPPk+W3FHog8ZGUqvUn4
 LbwXzSUU
 suSkyXzRNyaeWqqEgAyguQQWwvOeIYPd7iZoevjs4DNu7kA4LzNA6eXSqIfQxGayzvpsTzqOU0Iq5/oVTHDcDwy8hjR1smiuZsJgRSNhT21SPeBlX05jGlw6gLwv4N6mu9tNzzeBSGrXXnTMuR3KYc++9gH7IU0NzT7Dn8JHxBhe6/gy8Fhza6zc/35ZESte67w7eO53/dhy8vdE+BwhJt3aj2pyutihqgLC2dyUn5wXyCmy+2voRZqVym6CaAClCTJ3+JuOWI1xbr01eADfY0qe/iNTe07KukpAZH8FZQXH1MHKX1TiN9BbSq+w99RCJl/S3grWparqJArNe2Poi2OrK/In1RMZIcQ36
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 3:43 AM, Qiliang Yuan wrote:
> Most kernel noise types (TICK, TIMER, RCU, etc.) are currently aliased
> to a single HK_TYPE_KERNEL_NOISE enum value. This prevents fine-grained
> runtime isolation control as all masks are forced to be identical.
>
> Un-alias service-specific housekeeping types in enum hk_type. This
> separation provides the necessary granularity for DHM subsystems to
> subscribe to and maintain independent affinity masks.

Usually, if we want to run a latency sensitive workload like DPDK, we 
try to minimize all sorts of kernel noises or interference as much as 
possible. Do you have a good use case where it is advantageous to remove 
some types of kernel noises from a given set of CPUs but not the others?

Cheers,
Longman

> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>   include/linux/sched/isolation.h | 20 ++++++++------------
>   kernel/sched/isolation.c        | 10 +++++++++-
>   2 files changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index dc3975ff1b2e1..b9a041247565c 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -17,21 +17,17 @@ enum hk_type {
>   	/* Inverse of boot-time isolcpus=managed_irq argument */
>   	HK_TYPE_MANAGED_IRQ,
>   	/* Inverse of boot-time nohz_full= or isolcpus=nohz arguments */
> -	HK_TYPE_KERNEL_NOISE,
> +	HK_TYPE_TICK,
> +	HK_TYPE_TIMER,
> +	HK_TYPE_RCU,
> +	HK_TYPE_MISC,
> +	HK_TYPE_WQ,
> +	HK_TYPE_KTHREAD,
>   	HK_TYPE_MAX,
> -
> -	/*
> -	 * The following housekeeping types are only set by the nohz_full
> -	 * boot commandline option. So they can share the same value.
> -	 */
> -	HK_TYPE_TICK    = HK_TYPE_KERNEL_NOISE,
> -	HK_TYPE_TIMER   = HK_TYPE_KERNEL_NOISE,
> -	HK_TYPE_RCU     = HK_TYPE_KERNEL_NOISE,
> -	HK_TYPE_MISC    = HK_TYPE_KERNEL_NOISE,
> -	HK_TYPE_WQ      = HK_TYPE_KERNEL_NOISE,
> -	HK_TYPE_KTHREAD = HK_TYPE_KERNEL_NOISE
>   };
>   
> +#define HK_TYPE_KERNEL_NOISE HK_TYPE_TICK
> +
>   #ifdef CONFIG_CPU_ISOLATION
>   DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
>   extern int housekeeping_any_cpu(enum hk_type type);
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index ef152d401fe20..e05ed5118e651 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -15,9 +15,17 @@ enum hk_flags {
>   	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
>   	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
>   	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
> -	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
> +	HK_FLAG_TICK		= BIT(HK_TYPE_TICK),
> +	HK_FLAG_TIMER		= BIT(HK_TYPE_TIMER),
> +	HK_FLAG_RCU		= BIT(HK_TYPE_RCU),
> +	HK_FLAG_MISC		= BIT(HK_TYPE_MISC),
> +	HK_FLAG_WQ		= BIT(HK_TYPE_WQ),
> +	HK_FLAG_KTHREAD		= BIT(HK_TYPE_KTHREAD),
>   };
>   
> +#define HK_FLAG_KERNEL_NOISE (HK_FLAG_TICK | HK_FLAG_TIMER | HK_FLAG_RCU | \
> +			      HK_FLAG_MISC | HK_FLAG_WQ | HK_FLAG_KTHREAD)
> +
>   DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>   EXPORT_SYMBOL_GPL(housekeeping_overridden);
>   
>


