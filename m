Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05DC3E8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6824B6B0005; Fri, 26 Dec 2025 15:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605CA6B0089; Fri, 26 Dec 2025 15:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7206B008A; Fri, 26 Dec 2025 15:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 395DD6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:31:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D60A789951
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:31:38 +0000 (UTC)
X-FDA: 84262767876.19.9AA9546
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4659C40004
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:31:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RWXKu/Y9";
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766781096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4Pa3h61jDk0Wr5hXqPBHwFAVT2TML944c0BxtSWzHU=;
	b=Smpoc3qbD8BEC3NkUeB4PO82liht8HEph1QMczXHP275lEV9w6alRhhEIFywc5CXgK8j1C
	dDb7VwE9JPRoS9b16p21sP/VAw0m0WaOWiljlyQYMQG9T71eNwtFJ3pFC0VYMWFAnmtA52
	iZ0eA+Nl2+3MYR4L/p/BqH2NzObJLvM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RWXKu/Y9";
	spf=pass (imf27.hostedemail.com: domain of llong@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=llong@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766781096; a=rsa-sha256;
	cv=none;
	b=wKyZfRDLzWRwSi+cdOLj4WmYOzSmJuoFuS2rPuxakJFSU1CIfrQjEaVry0r9Pwd1tBXQF4
	4MVzfFr5OW2A952/euxRZVBE2zjh3uVX/Ox1HXfv3JeVRwjuYJLhFkl9Qz+NbrawN+T5qJ
	6ddpzS0Y7n+j2PEIFpebLIv3M6h9rGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766781095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4Pa3h61jDk0Wr5hXqPBHwFAVT2TML944c0BxtSWzHU=;
	b=RWXKu/Y9W8D4LntEoXwgv89QOeggZ6JD8fpTQwOsg8Bdvf7hx2Z6MldAJ3z1hGZKBZn5u+
	GmY2gQzEr9mzfRAZegJ1cw+f5qh5wM+5zAnyjBvV6Vk2sMGG2/Q2KtuY5iwz+WBVO4Bb2Y
	raqkoPMBzFeN/5vcbPxcNMALZ0PFNMg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-q2w0q7xdNYi-tone9StcfA-1; Fri, 26 Dec 2025 15:31:34 -0500
X-MC-Unique: q2w0q7xdNYi-tone9StcfA-1
X-Mimecast-MFC-AGG-ID: q2w0q7xdNYi-tone9StcfA_1766781094
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8bb9f029f31so1986979485a.2
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:31:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766781093; x=1767385893;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w4Pa3h61jDk0Wr5hXqPBHwFAVT2TML944c0BxtSWzHU=;
        b=CXu3IvWwsde2iSMMd06/nJilWnzBJJxZqaDHvDOf24mlIk+qtOC853BEsVGLNPOtIw
         MTWUBTY8rGO4l3xoZ+ZHr/PU2vleWkBn9Gtysb5UaEdmAJzjeZf2KkC8ykH7gfLGwQYL
         Em8dbC5+RoyO9VD9HmE4yEePPT0kCOFvzp7rBcmmvFM34pmb97tWPtwZtniGySK4Qs0u
         0zqsBK9MzUu7belH/xa7ePvwBIPPoPLKw7Fb7Jqi26Zw+MYf9RvtbZS1yLr7TssBNe5I
         0QrHzBdnSNMmMgP61yH1WBZD0BJJqWXXw4JlAVctIkSSCm9Ej0JXJzboebAkZWRqbgxJ
         yc3g==
X-Forwarded-Encrypted: i=1; AJvYcCWcWk2BTVXv5L0JFrqzAjkl0EWoEGyxv+MfYUovLNJZTiw9Si16jzqS9vDiRkBFMrXoqpy53d/nqQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2FGSjH1TmS0R0Jlt8dche7HkSW8/1dGVh8CpQaaVJnKynIl5o
	pw3ze3kuIpbobTokBD6xrp6xANxgtf75j/FMqGORP7w8bHpWppk5ldqEMXNzxnkOJ3mK/0JJnAB
	mY5Qj4OFy04QnZ7p2Tl1AUv/qWS0fV3Yu2MMam8egppMhT2KJ4e9v
X-Gm-Gg: AY/fxX5XT4vkGfF//MN9664PqZQjqAnD/uZCi/tSRXus0eVJaTOszHyaeLoy0FIDCn+
	9WC6P2wHGIEp6YVBKBA7/6Gbv1XMoGSoU3GR0OORQ3vttibrcewS0XpDEVIHXP93fVSKAZ4VeJz
	fKS37mz2zEPt4wjn2xX807WxjFM7yDeD0EpH34F6380Wv/+oi+PzUH2GxakMczydBxcxU7FbsPF
	WY2lP9LmaBJe4IueJsdbbdRT2aFxZSGucyZzvatUWM/Wno4ACFDyKhHvB+81/8yXkH24o3G4jXR
	+vuOy9WMA97r8F32ZVL3xkKxUHm3QH2L+iHuVDzyCn4SOQhCvYF1FVL2LxkC87DFrz98xQPjr28
	ruLeGMFPi3UgsEY3Ez16D7yQJjErD+eEbIvgkk+X7/BN91IRY8MWOzOC7
X-Received: by 2002:a05:620a:269c:b0:8c0:d341:9cef with SMTP id af79cd13be357-8c0d341a826mr2546757485a.73.1766781093497;
        Fri, 26 Dec 2025 12:31:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFNP3JRzuVA9e5lA05jSGh3cLVd3H4bpw8DYevvFoq9EfnIojwqlL0tzjDHUY8cAliBoVsvtA==
X-Received: by 2002:a05:620a:269c:b0:8c0:d341:9cef with SMTP id af79cd13be357-8c0d341a826mr2546753385a.73.1766781092994;
        Fri, 26 Dec 2025 12:31:32 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0970f5fa6sm1797460785a.28.2025.12.26.12.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 12:31:32 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <a9aa92b5-5e5a-4e9f-bfa3-31033d190457@redhat.com>
Date: Fri, 26 Dec 2025 15:31:26 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/33] cpuset: Propagate cpuset isolation update to
 workqueue through housekeeping
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
 <20251224134520.33231-19-frederic@kernel.org>
In-Reply-To: <20251224134520.33231-19-frederic@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6sWWJTQxa_Hxyej0xMx6uIhVO-ibShscgbvLfOGPmSU_1766781094
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4659C40004
X-Stat-Signature: 115uzcgq18cuo3rosonu1tqggyp1x1ns
X-HE-Tag: 1766781096-393436
X-HE-Meta: U2FsdGVkX1+t/O6UCU2biZsYmDCT0e16OZ7k0RxCg6yZHv0Vo9rusF7y5WDO+RFF45UtImV7Z50vfC6GLVHIOIhPDE4Cw2Fkk+cWhkqDPDDuNZ6u8DCOcF44Ic1mtOcEjKCnjMago6EfCr8FQ9gHVzongQaSVOAEsJ09sR6IsUScOWZi/tAbCE39V0gHNevLQXKB6pvDgOP0HKTHoQIbaso5Yl7FBOMqzuWDVLHZ+gr01oISrVCkegdWPanQbiglBfgdA4ADnm8sEu+wMr+ThFP59y2NQcgUGbN3u4MwrMqOYQ2A5zg0aiwp9sC9cYEhYjeJwh6xFjvsO1N+pGmORjx7JuJSWQfEUU4Ym1b7Hnr/Z81QlIZwd8DzPfw+KuPX8VtPeBflB1UgHbvn+ZyUz+Lw3LFNuf1NDtUPfcMEGtS3XAGP6YRjjY7dXA7oGShEYGofx9CcyzZOLK1YOWRdTVrFjQeN/N17CZPy2A8k3XxbYc17bnu3hvp3gz6wcjI7lTflPwhlM+wHlX1XFA0zPvoUSziiQohNa7I44+KNSR14IrVOfF/KoZ9WOZZlvnE9Q6IiysfJChMJvGdFRO/hsA3QU9xbdMjTETR3BNQylh7OnWmKbHrax/FW1m/GhKs4vS4lBxrmLFmS6PkXN6Z3MKN21OuA3nSdW+TL0OxXAZ7oxuSkBeGqOJfonEAzYNt679eeMgVQ4tPeu09VGh+ibtUHorFe5BbUCuS7/+SkqFw+cP01Q4uRGXUZkpQ/hGbDs2zxluz4z+OuLAfxMxKcUNpLAmE/ovwxY6fDvvBsYpndFrvtHdsASMwCxybpXNy34C1aQMCbuSe1knlc1jdgvpZD3XHOHx0Cu3horkn65OPlEI0OVRlztYi6hYOgCYxk8xJy//8M8igKDDYDnNFSLz6A940uoF9BX8EFphgnROPh5hKnc9bdcEkHJsXBwMp044g8sJvKj9wHouyP8tM
 VmPVnSqr
 BI5nbEPyTxozu+rgS5rsg/UmWzfPruNvBz07KbP4ua8DWkABUzFHz0DBqJfQ9D5Siv413D6V9s/VW1LV78r2JKecQu+LxMWSAnVHsFayKH27gE2oyZYxcUBr6eufd0u0aLNQAVmj3P4DQfzqvH2YF/byaLhbtSVx7dRnSf+zEgHm0kopuUzQokd1a3z3rtfJSwmWMlNmNb8u3AGHLayn9KunQml6HM3hnml2gL6uxGiAgWFNXRZpHvQXG81hCcMwzGIpL2VdnD3HDAQP3V+4KxFRFvF9NkL9ll+qtcCCw1SSmlf4qoIqqPbUdksO1u6B1fjpe9L4i7Gepqc+jtTv39diW/ezki1k9bGdVp0O1Qb1AhSQ18wbO7JvYepMGGV7yaBq+bfoo4n7RjJ3Sd2Ll5QkM6ZW66LyAF7FUNvVKzuwEHaKgAFrPL+ljDJ0DtQxxSpHmepN45g/Lxc2R1Hk8bCjj+HFPkQX1Y75HXEkbIZTqOvUX4gHe0CCF/4utCYchRGr+0pZqljL3XCv+Q0N6PjHHv8XXu0hixIAlqGU0K2qqgjhH5YIcsa3zOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 8:45 AM, Frederic Weisbecker wrote:
> Until now, cpuset would propagate isolated partition changes to
> workqueues so that unbound workers get properly reaffined.
>
> Since housekeeping now centralizes, synchronize and propagates isolation
> cpumask changes, perform the work from that subsystem for consolidation
> and consistency purposes.
>
> For simplification purpose, the target function is adapted to take the
> new housekeeping mask instead of the isolated mask.
>
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/workqueue.h |  2 +-
>   init/Kconfig              |  1 +
>   kernel/cgroup/cpuset.c    |  9 +++------
>   kernel/sched/isolation.c  |  4 +++-
>   kernel/workqueue.c        | 17 ++++++++++-------
>   5 files changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index dabc351cc127..a4749f56398f 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -588,7 +588,7 @@ struct workqueue_attrs *alloc_workqueue_attrs_noprof(void);
>   void free_workqueue_attrs(struct workqueue_attrs *attrs);
>   int apply_workqueue_attrs(struct workqueue_struct *wq,
>   			  const struct workqueue_attrs *attrs);
> -extern int workqueue_unbound_exclude_cpumask(cpumask_var_t cpumask);
> +extern int workqueue_unbound_housekeeping_update(const struct cpumask *hk);
>   
>   extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
>   			struct work_struct *work);
> diff --git a/init/Kconfig b/init/Kconfig
> index fa79feb8fe57..518830fb812f 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1254,6 +1254,7 @@ config CPUSETS
>   	bool "Cpuset controller"
>   	depends on SMP
>   	select UNION_FIND
> +	select CPU_ISOLATION
>   	help
>   	  This option will let you create and manage CPUSETs which
>   	  allow dynamically partitioning a system into sets of CPUs and
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index e13e32491ebf..a492d23dd622 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1484,15 +1484,12 @@ static void update_isolation_cpumasks(void)
>   
>   	lockdep_assert_cpus_held();
>   
> -	ret = workqueue_unbound_exclude_cpumask(isolated_cpus);
> -	WARN_ON_ONCE(ret < 0);
> -
> -	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
> -	WARN_ON_ONCE(ret < 0);
> -
>   	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
>   	WARN_ON_ONCE(ret < 0);
>   
> +	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
> +	WARN_ON_ONCE(ret < 0);
> +
>   	isolated_cpus_updating = false;
>   }
>   
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 7dbe037ea8df..d224bca299ed 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -121,6 +121,7 @@ EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>   int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
>   {
>   	struct cpumask *trial, *old = NULL;
> +	int err;
>   
>   	if (type != HK_TYPE_DOMAIN)
>   		return -ENOTSUPP;
> @@ -149,10 +150,11 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
>   	pci_probe_flush_workqueue();
>   	mem_cgroup_flush_workqueue();
>   	vmstat_flush_workqueue();
> +	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
>   
>   	kfree(old);
>   
> -	return 0;
> +	return err;
>   }
>   
>   void __init housekeeping_init(void)
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 253311af47c6..eb5660013222 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -6959,13 +6959,16 @@ static int workqueue_apply_unbound_cpumask(const cpumask_var_t unbound_cpumask)
>   }
>   
>   /**
> - * workqueue_unbound_exclude_cpumask - Exclude given CPUs from unbound cpumask
> - * @exclude_cpumask: the cpumask to be excluded from wq_unbound_cpumask
> + * workqueue_unbound_housekeeping_update - Propagate housekeeping cpumask update
> + * @hk: the new housekeeping cpumask
>    *
> - * This function can be called from cpuset code to provide a set of isolated
> - * CPUs that should be excluded from wq_unbound_cpumask.
> + * Update the unbound workqueue cpumask on top of the new housekeeping cpumask such
> + * that the effective unbound affinity is the intersection of the new housekeeping
> + * with the requested affinity set via nohz_full=/isolcpus= or sysfs.
> + *
> + * Return: 0 on success and -errno on failure.
>    */
> -int workqueue_unbound_exclude_cpumask(cpumask_var_t exclude_cpumask)
> +int workqueue_unbound_housekeeping_update(const struct cpumask *hk)
>   {
>   	cpumask_var_t cpumask;
>   	int ret = 0;
> @@ -6981,14 +6984,14 @@ int workqueue_unbound_exclude_cpumask(cpumask_var_t exclude_cpumask)
>   	 * (HK_TYPE_WQ ∩ HK_TYPE_DOMAIN) house keeping mask and rewritten
>   	 * by any subsequent write to workqueue/cpumask sysfs file.
>   	 */
> -	if (!cpumask_andnot(cpumask, wq_requested_unbound_cpumask, exclude_cpumask))
> +	if (!cpumask_and(cpumask, wq_requested_unbound_cpumask, hk))
>   		cpumask_copy(cpumask, wq_requested_unbound_cpumask);
>   	if (!cpumask_equal(cpumask, wq_unbound_cpumask))
>   		ret = workqueue_apply_unbound_cpumask(cpumask);
>   
>   	/* Save the current isolated cpumask & export it via sysfs */
>   	if (!ret)
> -		cpumask_copy(wq_isolated_cpumask, exclude_cpumask);
> +		cpumask_andnot(wq_isolated_cpumask, cpu_possible_mask, hk);
>   
>   	mutex_unlock(&wq_pool_mutex);
>   	free_cpumask_var(cpumask);
Reviewed-by: Waiman Long <longman@redhat.com>


