Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 443EDE8FDB8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 23:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934EF6B0005; Fri, 26 Dec 2025 18:59:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8286B0089; Fri, 26 Dec 2025 18:59:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A936B008A; Fri, 26 Dec 2025 18:59:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 670D36B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:59:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17C1B1391D2
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:59:45 +0000 (UTC)
X-FDA: 84263292330.21.8293925
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C66D1C0002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:59:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iy6GinHx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766793582; a=rsa-sha256;
	cv=none;
	b=HtG1JEFlvt7NBAFCQ6U0lMwdipacpM5S4EKyWk74OtCsrWupcts0Od6trcM9jd++6huFab
	4TM1zDTVjxsx4AjqOJpyoj4iTbbUmDFHLML2AwqlRKMWJor+RdbaYZnGfMctTcIOkjvg0k
	gbRNtfzBsHDyqNKuMYkeAMjXF5pIGfQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iy6GinHx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766793582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=865A7519wiN2/j/d36TzZexT5dCdrH361yDIN6aF4EQ=;
	b=twMRwHHqnT6jLU18FHVNVn1yWdUP46ledA/qgR3IfVxRCflr7dGl9lk+xU8x8PWs080V4N
	GD2FCJCgQe523kQP7PrpQeHR8UzhCL9djfMbLyacCSfX2Xd86MvaBrhhABZDqaCiDALPJu
	01ImEbyGxssEghBeZF3Fb3KXfz6OdMo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766793581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=865A7519wiN2/j/d36TzZexT5dCdrH361yDIN6aF4EQ=;
	b=Iy6GinHx2MJh6OO5k7SeTj7ZaOOtC2+QV+AvwjOx93VNx079uRE3YwXMl/KLdbITaMb0G2
	D2kyBRsvN8O7EZWf8CCa9lax5osGiYfRXdWsIAEohBen2+Aols4SWFg516Jeo13UvD59oj
	OWThu6/mWm1DGmUJn9T1rasFoTHuqcs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-ih-4nLLWNBebDBcp6XTm1g-1; Fri, 26 Dec 2025 18:59:40 -0500
X-MC-Unique: ih-4nLLWNBebDBcp6XTm1g-1
X-Mimecast-MFC-AGG-ID: ih-4nLLWNBebDBcp6XTm1g_1766793580
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4f1b39d7ed2so164687941cf.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:59:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766793580; x=1767398380;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=865A7519wiN2/j/d36TzZexT5dCdrH361yDIN6aF4EQ=;
        b=LY0Xff98K4lVB3kGbyLA232Dj3Vr985zrEGLPflOSBNGfFu3XZu6jmK+HbBJT+3G0+
         ap9Zq5i9uzXqDriMzpgONO+mrglSYFZ/QpktB1XezPitISIAAPtr/Vhz1G99w28RZYdd
         VEhG+ARWj4Egex60h1ACI5CaY9JVyQy03N+LXXXMOOFR4K8yipV5s7sCevgm1QqnNeWf
         5Fowx9GuQMv6gpVXT0KJYAT8Ci/N8b8LbdnkL1eQbs3m7U/TmFIkDrlK+s1PcZJBpwUX
         L3PzsAm31b+m/1ozJIih7EZcToTQIaOzr440ePvrBNXcrsWTNri8JHpoJIm8Uk1w3WzV
         UVxA==
X-Forwarded-Encrypted: i=1; AJvYcCV8ChDTByykzRpBJNAsTj2XpAQA/SJRTxZMcn2bD0rserIM6JAwiNuO31NCJpO9ygFBT2tjlJ2nHg==@kvack.org
X-Gm-Message-State: AOJu0YzWktd/xnK7L2hBLKvHCXtyfdtV4o+iW96zcfQVtooZGKRgb9Bu
	dh3iqIlwz4kCbzJ/bXGq0E9x2ADvsAnm0JHCZ8Dx/u0+IigwozksDsdN8dA0Uz71iJaqsQ7Otll
	Tcd6RlSSHtXjjZtqSlX94EtXal0motFVxcy91MHgqyfvoP8dv1bMf
X-Gm-Gg: AY/fxX7ltcU7xAJsNF6KPDXZ3U8/Y6pBM9SPbVh+zwlMEJGck93JxJqLwa6fa2/cfUg
	H1ZTmr1FSHm3LzsgT5r6ZWmfkbqgudTFcAecWV6ZTiEPBZMeRSuG80Sn5UJMFYFdE5nA+STCznZ
	NiHaCiNskM2IhchMZNjxs6uS01ywGjZ+KG/iArluRw5F/LWFvnUSrDNt/pxjytKs9U5+AAfkyGd
	tO2sxO+CHufbwQXFgLIqLEYiHCIOE6Js5uImdkdBOqdQm8Q09OKT/Y5cCgaBmJb8X/+f1DDoCWb
	dySPxgsM1j82LZibemdph2uaSlqJ1NgP3rvANEVR31jtZ3Scq5DSKb3aXl8swJL6E1i367HZUHI
	xfZRicsJ9+Z774qIL62Wki7DB7YEO0j5Cb/jpHcBqiKmSgIimGtajZvoP
X-Received: by 2002:a05:622a:198b:b0:4ee:1bc7:9d7b with SMTP id d75a77b69052e-4f4abd8cc1fmr323812761cf.39.1766793580120;
        Fri, 26 Dec 2025 15:59:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IERH4Oby4w37LQow9PPp6jIctRZ9vYsC7ux3H2yEqxLfgye1sWzIlcBk2jF/qfYV4D0shjHTw==
X-Received: by 2002:a05:622a:198b:b0:4ee:1bc7:9d7b with SMTP id d75a77b69052e-4f4abd8cc1fmr323812481cf.39.1766793579691;
        Fri, 26 Dec 2025 15:59:39 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac55fde7sm165334981cf.12.2025.12.26.15.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 15:59:38 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <a8968902-7fc3-4dec-9a53-e9685a5705b9@redhat.com>
Date: Fri, 26 Dec 2025 18:59:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 30/33] kthread: Honour kthreads preferred affinity after
 cpuset changes
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
 <20251224134520.33231-31-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-31-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sx7MwsDFHU4LeUtJ5_fGaUoucF_5nAyM5PUl7lKsUfY_1766793580
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C66D1C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: jhm4uefxnhrghywac41e5qch7usnzkze
X-Rspam-User: 
X-HE-Tag: 1766793582-892437
X-HE-Meta: U2FsdGVkX1/4fb5lVFQwR1Oka2zCFf8XHzOKXNatHS/XUzzKKUKTCxQm6W3czqGUnxnzaCKju2pjpYpB2xsCkI5hkDQWkelBNk4tPRAatN0NSi6L0y3OxjcbyRvfTJDwTjFTqXL+sp9jrJFO/VaF9NIPuLQIJ4rszhxu+V7u61HTXijmhk4/umbL7JyymVkClnzW9OaMjIBX5NUxdoHh1eNDoNF/Hn52yvDyK0a0n8IOKR6HuZEsA4987+Ad6IVaTp0ZiAZbULUDM05+e8gjFFe532ySZgmEjrKmlmAX1mB192/8psCqqeEouzzIlgpVCkjcIVR1rZhbh5crCiBZ7K12dov2u/UeYROZoR7Eo4jqJc+0lJAzQ4Wxngfa+wus8eeMc5LneAiIvqfj6dj7Sl+VRNTRb51k/JF6MATmgNFEkJ4fThNDqd+MLtz5rFNrQMfV5RoGbJHVcUUHbexiTbHOVOjuGI78okHiQ0sdCO4Ery71IfN2KqIaFDRd08s7ubdjJtaQ3hZ2qQ8AZuXzFLxrYCWMzhJ22kvipqnMIHJ6MsR+3y7C6I1NHmeUI071AvyUrHGAoSUquy/afB6yXw2GR+R0DlrBFFYW94pzhDXqWKI+SFzC9YL3c4EjXQD6HM5l6+hhJYLint95PecqN1BDEZOVxiEpeHIc1LmxLB/tMHXJuIV1fjP+7Jon/Nx5Elbc94yCa8sUh56sQEQHDUjGI0NboNWql0/ZiUWUKf8u5BUvIDX75kX95mBT6+V5DFz3WkMa9Pu5uHdReARzpBG3qkvhDaGR9V8Jc/3ikIootFtnGijEuxpj7D28fKWUz1m9cx8h3XF8Bqcgx4IRs83I17aYXL4dSaR1yJhC3Ic9LzeyuiiSc8L7T/DT8ZCGi86pgiPxzGJln0qkinmQbCMqeIDbdhMTKgv/D1xuNVyeR9vL7rGmNCDt/5OrVkwiI1XODpSJ4xmZVzmLyH6
 veqR48OY
 XVfSVjbMQ8p1kH0XuKSo57qHg1d2RJ28VReZltwEf1j7C8tkLnNa1euFLLjRXdcOmZ9Vu39NBC7JlXE1DVgGxmAX5Kv8Kra3I1o8/oZtuYXQVDW9E/oPIfQ0kIedgoo+ayIvUrdovAv2i1UEeEVbiGaAaWz3tR7u1iMMPYeo8rIDV81fiwiALIXv6aJyDg+1FAFWA6RtqIxZ4/JfIrx/inaWDaEBijfe8AdzwtDXLjiR0t4Pnr6vAQ1Vpsw1o/tGlcWIQEXtTXKxLJhT+kudnb2IDPIYW/UduwCiCuGIPZBuOuVo90DpNs79eTBOrqQDemRPEGo5lDzl+CXK9p6NouGgznHG3K+ioCQsbPfuOuRamWvXT2dEtAfgEbpBVBDI9tS/oBxEz2wzA7VHexlz6sDWZ+yvqcJnklhDVOamSqcfJqwcgkKsn69BxYRKAUH85YdepnkY1D7ZbshKr3EuIYC4T2Hmvg+4p0Qpgy8B90Zkz/Abzd0ql5HwADXdjQ3LtEdsHe2S6vM0mH7HGM5Q7bdR43Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> When cpuset isolated partitions get updated, unbound kthreads get
> indifferently affine to all non isolated CPUs, regardless of their
> individual affinity preferences.
>
> For example kswapd is a per-node kthread that prefers to be affine to
> the node it refers to. Whenever an isolated partition is created,
> updated or deleted, kswapd's node affinity is going to be broken if any
> CPU in the related node is not isolated because kswapd will be affine
> globally.
>
> Fix this with letting the consolidated kthread managed affinity code do
> the affinity update on behalf of cpuset.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/kthread.h  |  1 +
>   kernel/cgroup/cpuset.c   |  5 ++---
>   kernel/kthread.c         | 41 ++++++++++++++++++++++++++++++----------
>   kernel/sched/isolation.c |  3 +++
>   4 files changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
> index 8d27403888ce..c92c1149ee6e 100644
> --- a/include/linux/kthread.h
> +++ b/include/linux/kthread.h
> @@ -100,6 +100,7 @@ void kthread_unpark(struct task_struct *k);
>   void kthread_parkme(void);
>   void kthread_exit(long result) __noreturn;
>   void kthread_complete_and_exit(struct completion *, long) __noreturn;
> +int kthreads_update_housekeeping(void);
>   
>   int kthreadd(void *unused);
>   extern struct task_struct *kthreadd_task;
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 1cc83a3c25f6..c8cfaf5cd4a1 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1208,11 +1208,10 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
>   
>   		if (top_cs) {
>   			/*
> +			 * PF_KTHREAD tasks are handled by housekeeping.
>   			 * PF_NO_SETAFFINITY tasks are ignored.
> -			 * All per cpu kthreads should have PF_NO_SETAFFINITY
> -			 * flag set, see kthread_set_per_cpu().
>   			 */
> -			if (task->flags & PF_NO_SETAFFINITY)
> +			if (task->flags & (PF_KTHREAD | PF_NO_SETAFFINITY))
>   				continue;
>   			cpumask_andnot(new_cpus, possible_mask, subpartitions_cpus);
>   		} else {
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 968fa5868d21..03008154249c 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -891,14 +891,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
>   }
>   EXPORT_SYMBOL_GPL(kthread_affine_preferred);
>   
> -/*
> - * Re-affine kthreads according to their preferences
> - * and the newly online CPU. The CPU down part is handled
> - * by select_fallback_rq() which default re-affines to
> - * housekeepers from other nodes in case the preferred
> - * affinity doesn't apply anymore.
> - */
> -static int kthreads_online_cpu(unsigned int cpu)
> +static int kthreads_update_affinity(bool force)
>   {
>   	cpumask_var_t affinity;
>   	struct kthread *k;
> @@ -924,7 +917,8 @@ static int kthreads_online_cpu(unsigned int cpu)
>   		/*
>   		 * Unbound kthreads without preferred affinity are already affine
>   		 * to housekeeping, whether those CPUs are online or not. So no need
> -		 * to handle newly online CPUs for them.
> +		 * to handle newly online CPUs for them. However housekeeping changes
> +		 * have to be applied.
>   		 *
>   		 * But kthreads with a preferred affinity or node are different:
>   		 * if none of their preferred CPUs are online and part of
> @@ -932,7 +926,7 @@ static int kthreads_online_cpu(unsigned int cpu)
>   		 * But as soon as one of their preferred CPU becomes online, they must
>   		 * be affine to them.
>   		 */
> -		if (k->preferred_affinity || k->node != NUMA_NO_NODE) {
> +		if (force || k->preferred_affinity || k->node != NUMA_NO_NODE) {
>   			kthread_fetch_affinity(k, affinity);
>   			set_cpus_allowed_ptr(k->task, affinity);
>   		}
> @@ -943,6 +937,33 @@ static int kthreads_online_cpu(unsigned int cpu)
>   	return ret;
>   }
>   
> +/**
> + * kthreads_update_housekeeping - Update kthreads affinity on cpuset change
> + *
> + * When cpuset changes a partition type to/from "isolated" or updates related
> + * cpumasks, propagate the housekeeping cpumask change to preferred kthreads
> + * affinity.
> + *
> + * Returns 0 if successful, -ENOMEM if temporary mask couldn't
> + * be allocated or -EINVAL in case of internal error.
> + */
> +int kthreads_update_housekeeping(void)
> +{
> +	return kthreads_update_affinity(true);
> +}
> +
> +/*
> + * Re-affine kthreads according to their preferences
> + * and the newly online CPU. The CPU down part is handled
> + * by select_fallback_rq() which default re-affines to
> + * housekeepers from other nodes in case the preferred
> + * affinity doesn't apply anymore.
> + */
> +static int kthreads_online_cpu(unsigned int cpu)
> +{
> +	return kthreads_update_affinity(false);
> +}
> +
>   static int kthreads_init(void)
>   {
>   	return cpuhp_setup_state(CPUHP_AP_KTHREADS_ONLINE, "kthreads:online",
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 84a257d05918..c499474866b8 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -157,6 +157,9 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
>   	err = tmigr_isolated_exclude_cpumask(isol_mask);
>   	WARN_ON_ONCE(err < 0);
>   
> +	err = kthreads_update_housekeeping();
> +	WARN_ON_ONCE(err < 0);
> +
>   	kfree(old);
>   
>   	return err;
Reviewed-by: Waiman Long <longman@redhat.com>


