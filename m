Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2573CA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 17:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263D08E00F5; Tue, 26 Aug 2025 13:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B0D8E00EC; Tue, 26 Aug 2025 13:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1511B8E00F5; Tue, 26 Aug 2025 13:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3F3A8E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:03:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9495160230
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:03:51 +0000 (UTC)
X-FDA: 83819530662.20.14E1CA0
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6EA0C20014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:03:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDVis8LW;
	spf=pass (imf13.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756227829; a=rsa-sha256;
	cv=none;
	b=3tBnl5TtG6Dj1DHbjacy/RcWmytDkqNpR4PabCLP60eqP+fSqQnE6Pgw8lWGCcljalLML8
	xco368IpAcw4KpiNOP4U7j7iPozqkueFvUv2vcKh12xOLc3THJRjm4uYxdzX+SfBKfEACV
	In8WEZYH1j7lFLF9E26Vdsibq6VP02Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZDVis8LW;
	spf=pass (imf13.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756227829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=be7/Z3SiFls/KOFclEltpt7b/iLTreHhRFZ0mSEiEbY=;
	b=6XXdOQ5/VMjQlSIPhX6jYDeD72lsk+dUFqNYFVwr1nbB3P0wyFdT73iuG77ThRz0ijbsQo
	WmF6v2v4iq8dUHwT9UmfjL69udXBIxErgq1HfczjqW4K8ZUxivg5k7nX7Iv9G/ylXrUvgH
	aB8/8N1+HaVH7qPIYBALjpj+ORzu8YY=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b471756592cso3718341a12.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756227828; x=1756832628; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=be7/Z3SiFls/KOFclEltpt7b/iLTreHhRFZ0mSEiEbY=;
        b=ZDVis8LWBkz7+HcLasoyZcsotOFF2oYcRxYURCPtp0rjQTfA5V0wID2i9NDtevbkxL
         u/jrrzDl8Zv8mzBPlJ9nbI0bupppxurnWIV/SMc6JFvjBEI4nTPNSUwq2mZ5DmzovHWp
         55ZuQLpUDCwkJQfRup0lhPMi/vLYRBd87lY06brtgX3eHtc2UnFiuToQBqK85Ih4HfVs
         pl9boGOKWgoiZK3MHxx9XAKdorOfXBdVFUsZCXjqig9/ZS1QbBxTxFEY2/LiXgUlFDc4
         Y37aJ2Kn+FQBkPegNdgw6wzIl4ab+DUNy/KQRcbM/8L2NTw4Xi93IviFRwZFPxtRuSa/
         Wt7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756227828; x=1756832628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=be7/Z3SiFls/KOFclEltpt7b/iLTreHhRFZ0mSEiEbY=;
        b=gELKNMHge2A+qTF8aJQ3ZXgD9n602SRuOv/awZDhxuQRAsvEr8ZvpBRH+2lQGYdEW4
         Q+yolcOZJVzWIbq7y/6VkSZ4AodPPQB8OMrteLosVwj25x+fHQCctgEWx2+jpqhwY20H
         pGKVzeJ4YTwJlZYCbRLXNEPZ8E6f2rQ4v2hGJZxtqEBXWz7iy3RHW0XqDi+OhMKWYSrr
         M9NuewLWV4C8t1D7l9k63t7+VQuhZ3+cqOgJs85TkJiuYBQs0uKqkO/r06n8Pagsb6RW
         rBJRqSyI2fGqMtcnk+Ja9nYKsufDD0RnSFxHz/bnqhUVg6NJQpfbMzpdWEmQQmi3A+zq
         8gEA==
X-Forwarded-Encrypted: i=1; AJvYcCV95wOV94xTBBODk73CZtKKdlO74hd0hMYceqSDSu9LfqqC643+bAX8KmsNeErgqvov81BqbMA8AA==@kvack.org
X-Gm-Message-State: AOJu0YxtCk79Ay+3pCPZh+9RE9YCp+cQBucQRwNTH96D1WfGGtHSxhDh
	EF0t8S0apSeHSEOnXwcshDq/M/7BYTLaH7nqg/mrbCsHqHDPf3PQten/
X-Gm-Gg: ASbGnctym9rKV6ntYxUGbm2X14Ca7S+pRRSdb+AZVt2IvYlfsCwn7nIiVcx1Xod5lvS
	jcOiy7C0Mvski4DH63EAl6iFZ2IsWj1fTWTmCi6UGkzrmIXitp5vVE2Lg1Er8eDn2uKjRYwtALR
	yHwG/bRMrJ36atHpXz+wEiRSzayoc33se9XR0JNle+4pw/6scv/rf+iPhvBTE4Sjq1qc3rDWCqq
	dF2bhZJaix8SjI3aIclpmFPHOsel8BE6yDsxihCpZpBh2eoqBpzSdEEn3GZro+tTNJ9l0W88XDi
	9ajL1e2Dn4doYXpZMPirgsSXAAtCkr/zgASy1ak7UmGEiSssjpBTUZj2wqWrT8yj1BXuUST0V8Q
	rxPZBNVOZPqVrevIV3byIZ/36MrVDI64E+nXtz0+dtUwl747BHHddIqZ19wpsDvqq88ZhQl7RIO
	wl
X-Google-Smtp-Source: AGHT+IHkG4Tliiwa8QwL7c8MbURACHJkfXxhlG19+nw/+TwIF0tJ5O+BCO60BDUscNO/xgk332QVbA==
X-Received: by 2002:a17:903:124c:b0:245:f818:70c1 with SMTP id d9443c01a7336-2462efc9c8emr190264405ad.57.1756227827836;
        Tue, 26 Aug 2025 10:03:47 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:a:14b0:ff2b:98c1:659? ([2620:10d:c090:500::4:9299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466885f2c1sm100859075ad.73.2025.08.26.10.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 10:03:47 -0700 (PDT)
Message-ID: <185ae195-9aea-4116-adf9-c1766b6703ec@gmail.com>
Date: Tue, 26 Aug 2025 10:03:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/14] sched: psi: implement psi trigger handling using
 bpf
To: Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-13-roman.gushchin@linux.dev>
Content-Language: en-US
From: Amery Hung <ameryhung@gmail.com>
In-Reply-To: <20250818170136.209169-13-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EA0C20014
X-Stat-Signature: 7dfnix9xga91yeukd1m1kzctt6uycfcs
X-Rspam-User: 
X-HE-Tag: 1756227829-749426
X-HE-Meta: U2FsdGVkX19u1lW1e20/fO3FXsaWu/UuiliCXGqwgBeYOHJJLT8NZmU+JAqyYdEpaJxj3U5Aj/400RD3j+72qrfYMElxP+1le2hZ/Lu+Tc+b8Z0h82OeSvLIhIFh2FyKLLAu5KfmBhGvA/kMvsw48j34EkJ7IAlZ/CeiTgoWq6nuxfQ08apZ83mcvtCgS/xUGVpYIHLuOHq+htaUewhwC5l+6NQ9Fc5VOJ9Xp09p4vTfugfucr/oHSN3laD0T8KWXoJzLA1Tv9N5GOrEG6XgPYhzdBl6AbUDWx0PlWJBqK6VxevPTbEsB1e6HDxhqp46Z4v41yD2L+/Csc5YkB/wVRR1lC3v0JeqFZVdjDsM0Dfhh9rkWlgEJErWQNQ7traafII+PeY7/GVKIUKmKz9ivAbP+SG/zD+1jDVbNAzfmknumX0y3h6de9MTB1qqMoDhkSZh4xTX3QDhejboW5MZIRsrLuSd8drmg5fFT9Jui/3vgFEXHNPGgBKRsDvZrK2tZXEkd7Vci1Gsy81i9eth2gm6CuR3In7IYxRcp9Ap9QM40BkTDkmNEJW0l6MDUNL/P1A8AqM82KmIPckK2s4DouykvOeW1VlaOEDDM/osUgM/3EAKW2D48GZkkud3CL+ay0v3ob2PCyJNgOimTV8+TLhpKqrNMhkj9wiZHXDPvtCSt5T4COo7JgQim+ZqA229gsuq4i/+QpEtT+XacuUt0IPOanzKLrqpAgTBr29RiKSk/paiq52QmLK6e5rXRdY79bH+jN1KYo7qIOBAMdJxGH9BEZn8GmqDzwVbJQZoR6bCt24GCNxmqiMV2GMRCnJZoBja5bBwJq5jY0UenbIECdUio1N9rm0SeLcdn2h2PcLJBYY4/wy2s+Kzd4ell23Csf0jmk5T3+X3MeEEHPz7dLKtRV+QhvT0MDeYvL58v5X/GTLsHHtQoXKm0ZHKhCjNkk6MyBzmaR7x2jz4IDx
 HB2n8xP9
 THFDRjeFPW1LmV6pnI+qmqzXaGxnnCnazJSAx/JDxN39YWkb+4ebBMkjQKEC9xhuEbs4SFPKrDFRnY1caR/IvezxKWexGMMlTPHBac3rooD6oi4UGi9vsNFJCk/kLQyjMEPf70ds+fHj02J0Ybun4J8rT2ioBjCZFCIWDkiB+raWMZeA3dnFITFO6jpkOh67WY0JCZCxBn85rHfYIWLpAkj0/kgqFr3cG5g2Ku7XoMbgyreo8XbYxWGFcBIJj2eS1k/tKmiTi3NIorh7zF3IeGXDneeiYQpqlt9Lw+FAgseF5bfLt0gUYK1iw6uXzH/LI11/rAyGVCNmnSBHXL3mhXU75G5VnvJXU0Lv6LERXsFlNGaUXWTfs05GIN8qOxzgWlUM1NqnU5Fj8tWvrIhXSUrpL6TBB7jHohCzykI6SPw+h4jEABfv3qFOg6AobbIO/WQwSxfsiY23nKXQysZ1ML959BLKvv5/gH+6cAbPRuz+hkf2wpmLW54tdXXs7MfOs0VQk8Jfx7tu0YTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/25 10:01 AM, Roman Gushchin wrote:
> This patch implements a bpf struct ops-based mechanism to create
> psi triggers, attach them to cgroups or system wide and handle
> psi events in bpf.
>
> The struct ops provides 3 callbacks:
>    - init() called once at load, handy for creating psi triggers
>    - handle_psi_event() called every time a psi trigger fires
>    - handle_cgroup_free() called if a cgroup with an attached
>      trigger is being freed
>
> A single struct ops can create a number of psi triggers, both
> cgroup-scoped and system-wide.
>
> All 3 struct ops callbacks can be sleepable. handle_psi_event()
> handlers are executed using a separate workqueue, so it won't
> affect the latency of other psi triggers.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>   include/linux/bpf_psi.h      |  71 ++++++++++
>   include/linux/psi_types.h    |  43 +++++-
>   kernel/sched/bpf_psi.c       | 253 +++++++++++++++++++++++++++++++++++
>   kernel/sched/build_utility.c |   4 +
>   kernel/sched/psi.c           |  49 +++++--
>   5 files changed, 408 insertions(+), 12 deletions(-)
>   create mode 100644 include/linux/bpf_psi.h
>   create mode 100644 kernel/sched/bpf_psi.c
>
> diff --git a/include/linux/bpf_psi.h b/include/linux/bpf_psi.h
> new file mode 100644
> index 000000000000..826ab89ac11c
> --- /dev/null
> +++ b/include/linux/bpf_psi.h
> @@ -0,0 +1,71 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +
> +#ifndef __BPF_PSI_H
> +#define __BPF_PSI_H
> +
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/srcu.h>
> +#include <linux/psi_types.h>
> +
> +struct cgroup;
> +struct bpf_psi;
> +struct psi_trigger;
> +struct psi_trigger_params;
> +
> +#define BPF_PSI_FULL 0x80000000
> +
> +struct bpf_psi_ops {
> +	/**
> +	 * @init: Initialization callback, suited for creating psi triggers.
> +	 * @bpf_psi: bpf_psi pointer, can be passed to bpf_psi_create_trigger().
> +	 *
> +	 * A non-0 return value means the initialization has been failed.
> +	 */
> +	int (*init)(struct bpf_psi *bpf_psi);
> +
> +	/**
> +	 * @handle_psi_event: PSI event callback
> +	 * @t: psi_trigger pointer
> +	 */
> +	void (*handle_psi_event)(struct psi_trigger *t);
> +

[...]

> +	/**
> +	 * @handle_cgroup_free: Cgroup free callback
> +	 * @cgroup_id: Id of freed cgroup
> +	 *
> +	 * Called every time a cgroup with an attached bpf psi trigger is freed.
> +	 * No psi events can be raised after handle_cgroup_free().
> +	 */
> +	void (*handle_cgroup_free)(u64 cgroup_id);

For the same reason mentioned in patch 1, I'd add bpf_psi_ops as an 
argument to the operations.

> +
> +	/* private */
> +	struct bpf_psi *bpf_psi;
> +};
> +
> +struct bpf_psi {
> +	spinlock_t lock;
> +	struct list_head triggers;
> +	struct bpf_psi_ops *ops;
> +	struct srcu_struct srcu;
> +};
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +void bpf_psi_add_trigger(struct psi_trigger *t,
> +			 const struct psi_trigger_params *params);
> +void bpf_psi_remove_trigger(struct psi_trigger *t);
> +void bpf_psi_handle_event(struct psi_trigger *t);
> +#ifdef CONFIG_CGROUPS
> +void bpf_psi_cgroup_free(struct cgroup *cgroup);
> +#endif
> +
> +#else /* CONFIG_BPF_SYSCALL */
> +static inline void bpf_psi_add_trigger(struct psi_trigger *t,
> +			const struct psi_trigger_params *params) {}
> +static inline void bpf_psi_remove_trigger(struct psi_trigger *t) {}
> +static inline void bpf_psi_handle_event(struct psi_trigger *t) {}
> +static inline void bpf_psi_cgroup_free(struct cgroup *cgroup) {}
> +
> +#endif /* CONFIG_BPF_SYSCALL */
> +
> +#endif /* __BPF_PSI_H */
> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
> index cea54121d9b9..f695cc34cfd4 100644
> --- a/include/linux/psi_types.h
> +++ b/include/linux/psi_types.h
> @@ -124,6 +124,7 @@ struct psi_window {
>   enum psi_trigger_type {
>   	PSI_SYSTEM,
>   	PSI_CGROUP,
> +	PSI_BPF,
>   };
>   
>   struct psi_trigger_params {
> @@ -145,8 +146,15 @@ struct psi_trigger_params {
>   	/* Privileged triggers are treated differently */
>   	bool privileged;
>   
> -	/* Link to kernfs open file, only for PSI_CGROUP */
> -	struct kernfs_open_file *of;
> +	union {
> +		/* Link to kernfs open file, only for PSI_CGROUP */
> +		struct kernfs_open_file *of;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +		/* Link to bpf_psi structure, only for BPF_PSI */
> +		struct bpf_psi *bpf_psi;
> +#endif
> +	};
>   };
>   
>   struct psi_trigger {
> @@ -188,6 +196,31 @@ struct psi_trigger {
>   
>   	/* Trigger type - PSI_AVGS for unprivileged, PSI_POLL for RT */
>   	enum psi_aggregators aggregator;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +	/* Fields specific to PSI_BPF triggers */
> +
> +	/* Bpf psi structure for events handling */
> +	struct bpf_psi *bpf_psi;
> +
> +	/* List node inside bpf_psi->triggers list */
> +	struct list_head bpf_psi_node;
> +
> +	/* List node inside group->bpf_triggers list */
> +	struct list_head bpf_group_node;
> +
> +	/* Work structure, used to execute event handlers */
> +	struct work_struct bpf_work;
> +
> +	/*
> +	 * Whether the trigger is being pinned in memory.
> +	 * Protected by group->bpf_triggers_lock.
> +	 */
> +	bool pinned;
> +
> +	/* Cgroup Id */
> +	u64 cgroup_id;
> +#endif
>   };
>   
>   struct psi_group {
> @@ -236,6 +269,12 @@ struct psi_group {
>   	u64 rtpoll_total[NR_PSI_STATES - 1];
>   	u64 rtpoll_next_update;
>   	u64 rtpoll_until;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +	/* List of triggers owned by bpf and corresponding lock */
> +	spinlock_t bpf_triggers_lock;
> +	struct list_head bpf_triggers;
> +#endif
>   };
>   
>   #else /* CONFIG_PSI */
> diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
> new file mode 100644
> index 000000000000..2ea9d7276b21
> --- /dev/null
> +++ b/kernel/sched/bpf_psi.c
> @@ -0,0 +1,253 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * BPF PSI event handlers
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/bpf_psi.h>
> +#include <linux/cgroup-defs.h>
> +
> +static struct workqueue_struct *bpf_psi_wq;
> +
> +static struct bpf_psi *bpf_psi_create(struct bpf_psi_ops *ops)
> +{
> +	struct bpf_psi *bpf_psi;
> +
> +	bpf_psi = kzalloc(sizeof(*bpf_psi), GFP_KERNEL);
> +	if (!bpf_psi)
> +		return NULL;
> +
> +	if (init_srcu_struct(&bpf_psi->srcu)) {
> +		kfree(bpf_psi);
> +		return NULL;
> +	}
> +
> +	spin_lock_init(&bpf_psi->lock);
> +	bpf_psi->ops = ops;
> +	INIT_LIST_HEAD(&bpf_psi->triggers);
> +	ops->bpf_psi = bpf_psi;
> +
> +	return bpf_psi;
> +}
> +
> +static void bpf_psi_free(struct bpf_psi *bpf_psi)
> +{
> +	cleanup_srcu_struct(&bpf_psi->srcu);
> +	kfree(bpf_psi);
> +}
> +
> +static void bpf_psi_handle_event_fn(struct work_struct *work)
> +{
> +	struct psi_trigger *t;
> +	struct bpf_psi *bpf_psi;
> +	int idx;
> +
> +	t = container_of(work, struct psi_trigger, bpf_work);
> +	bpf_psi = READ_ONCE(t->bpf_psi);
> +
> +	if (likely(bpf_psi)) {
> +		idx = srcu_read_lock(&bpf_psi->srcu);
> +		if (bpf_psi->ops->handle_psi_event)
> +			bpf_psi->ops->handle_psi_event(t);
> +		srcu_read_unlock(&bpf_psi->srcu, idx);
> +	}
> +}
> +
> +void bpf_psi_add_trigger(struct psi_trigger *t,
> +			 const struct psi_trigger_params *params)
> +{
> +	t->bpf_psi = params->bpf_psi;
> +	t->pinned = false;
> +	INIT_WORK(&t->bpf_work, bpf_psi_handle_event_fn);
> +
> +	spin_lock(&t->bpf_psi->lock);
> +	list_add(&t->bpf_psi_node, &t->bpf_psi->triggers);
> +	spin_unlock(&t->bpf_psi->lock);
> +
> +	spin_lock(&t->group->bpf_triggers_lock);
> +	list_add(&t->bpf_group_node, &t->group->bpf_triggers);
> +	spin_unlock(&t->group->bpf_triggers_lock);
> +}
> +
> +void bpf_psi_remove_trigger(struct psi_trigger *t)
> +{
> +	spin_lock(&t->group->bpf_triggers_lock);
> +	list_del(&t->bpf_group_node);
> +	spin_unlock(&t->group->bpf_triggers_lock);
> +
> +	spin_lock(&t->bpf_psi->lock);
> +	list_del(&t->bpf_psi_node);
> +	spin_unlock(&t->bpf_psi->lock);
> +}
> +
> +#ifdef CONFIG_CGROUPS
> +void bpf_psi_cgroup_free(struct cgroup *cgroup)
> +{
> +	struct psi_group *group = cgroup->psi;
> +	u64 cgrp_id = cgroup_id(cgroup);
> +	struct psi_trigger *t, *p;
> +	struct bpf_psi *bpf_psi;
> +	LIST_HEAD(to_destroy);
> +	int idx;
> +
> +	spin_lock(&group->bpf_triggers_lock);
> +	list_for_each_entry_safe(t, p, &group->bpf_triggers, bpf_group_node) {
> +		if (!t->pinned) {
> +			t->pinned = true;
> +			list_move(&t->bpf_group_node, &to_destroy);
> +		}
> +	}
> +	spin_unlock(&group->bpf_triggers_lock);
> +
> +	list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node) {
> +		bpf_psi = READ_ONCE(t->bpf_psi);
> +
> +		idx = srcu_read_lock(&bpf_psi->srcu);
> +		if (bpf_psi->ops->handle_cgroup_free)
> +			bpf_psi->ops->handle_cgroup_free(cgrp_id);
> +		srcu_read_unlock(&bpf_psi->srcu, idx);
> +
> +		spin_lock(&bpf_psi->lock);
> +		list_del(&t->bpf_psi_node);
> +		spin_unlock(&bpf_psi->lock);
> +
> +		WRITE_ONCE(t->bpf_psi, NULL);
> +		flush_workqueue(bpf_psi_wq);
> +		synchronize_srcu(&bpf_psi->srcu);
> +		psi_trigger_destroy(t);
> +	}
> +}
> +#endif
> +
> +void bpf_psi_handle_event(struct psi_trigger *t)
> +{
> +	queue_work(bpf_psi_wq, &t->bpf_work);
> +}
> +
> +// bpf struct ops
> +
> +static int __bpf_psi_init(struct bpf_psi *bpf_psi) { return 0; }
> +static void __bpf_psi_handle_psi_event(struct psi_trigger *t) {}
> +static void __bpf_psi_handle_cgroup_free(u64 cgroup_id) {}
> +
> +static struct bpf_psi_ops __bpf_psi_ops = {
> +	.init = __bpf_psi_init,
> +	.handle_psi_event = __bpf_psi_handle_psi_event,
> +	.handle_cgroup_free = __bpf_psi_handle_cgroup_free,
> +};
> +
> +static const struct bpf_func_proto *
> +bpf_psi_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	return tracing_prog_func_proto(func_id, prog);
> +}
> +
> +static bool bpf_psi_ops_is_valid_access(int off, int size,
> +					enum bpf_access_type type,
> +					const struct bpf_prog *prog,
> +					struct bpf_insn_access_aux *info)
> +{
> +	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> +}
> +
> +static const struct bpf_verifier_ops bpf_psi_verifier_ops = {
> +	.get_func_proto = bpf_psi_func_proto,
> +	.is_valid_access = bpf_psi_ops_is_valid_access,
> +};
> +
> +static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_psi_ops *ops = kdata;
> +	struct bpf_psi *bpf_psi;
> +
> +	bpf_psi = bpf_psi_create(ops);
> +	if (!bpf_psi)
> +		return -ENOMEM;
> +
> +	return ops->init(bpf_psi);
> +}
> +
> +static void bpf_psi_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_psi_ops *ops = kdata;
> +	struct bpf_psi *bpf_psi = ops->bpf_psi;
> +	struct psi_trigger *t, *p;
> +	LIST_HEAD(to_destroy);
> +
> +	spin_lock(&bpf_psi->lock);
> +	list_for_each_entry_safe(t, p, &bpf_psi->triggers, bpf_psi_node) {
> +		spin_lock(&t->group->bpf_triggers_lock);
> +		if (!t->pinned) {
> +			t->pinned = true;
> +			list_move(&t->bpf_group_node, &to_destroy);
> +			list_del(&t->bpf_psi_node);
> +
> +			WRITE_ONCE(t->bpf_psi, NULL);
> +		}
> +		spin_unlock(&t->group->bpf_triggers_lock);
> +	}
> +	spin_unlock(&bpf_psi->lock);
> +
> +	flush_workqueue(bpf_psi_wq);
> +	synchronize_srcu(&bpf_psi->srcu);
> +
> +	list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node)
> +		psi_trigger_destroy(t);
> +
> +	bpf_psi_free(bpf_psi);
> +}
> +
> +static int bpf_psi_ops_check_member(const struct btf_type *t,
> +				    const struct btf_member *member,
> +				    const struct bpf_prog *prog)
> +{
> +	return 0;
> +}
> +
> +static int bpf_psi_ops_init_member(const struct btf_type *t,
> +				   const struct btf_member *member,
> +				   void *kdata, const void *udata)
> +{
> +	return 0;
> +}
> +
> +static int bpf_psi_ops_init(struct btf *btf)
> +{
> +	return 0;
> +}
> +
> +static struct bpf_struct_ops bpf_psi_bpf_ops = {
> +	.verifier_ops = &bpf_psi_verifier_ops,
> +	.reg = bpf_psi_ops_reg,
> +	.unreg = bpf_psi_ops_unreg,
> +	.check_member = bpf_psi_ops_check_member,
> +	.init_member = bpf_psi_ops_init_member,
> +	.init = bpf_psi_ops_init,
> +	.name = "bpf_psi_ops",
> +	.owner = THIS_MODULE,
> +	.cfi_stubs = &__bpf_psi_ops
> +};
> +
> +static int __init bpf_psi_struct_ops_init(void)
> +{
> +	int wq_flags = WQ_MEM_RECLAIM | WQ_UNBOUND | WQ_HIGHPRI;
> +	int err;
> +
> +	bpf_psi_wq = alloc_workqueue("bpf_psi_wq", wq_flags, 0);
> +	if (!bpf_psi_wq)
> +		return -ENOMEM;
> +
> +	err = register_bpf_struct_ops(&bpf_psi_bpf_ops, bpf_psi_ops);
> +	if (err) {
> +		pr_warn("error while registering bpf psi struct ops: %d", err);
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	destroy_workqueue(bpf_psi_wq);
> +	return err;
> +}
> +late_initcall(bpf_psi_struct_ops_init);
> diff --git a/kernel/sched/build_utility.c b/kernel/sched/build_utility.c
> index bf9d8db94b70..80f3799a2fa6 100644
> --- a/kernel/sched/build_utility.c
> +++ b/kernel/sched/build_utility.c
> @@ -19,6 +19,7 @@
>   #include <linux/sched/rseq_api.h>
>   #include <linux/sched/task_stack.h>
>   
> +#include <linux/bpf_psi.h>
>   #include <linux/cpufreq.h>
>   #include <linux/cpumask_api.h>
>   #include <linux/cpuset.h>
> @@ -92,6 +93,9 @@
>   
>   #ifdef CONFIG_PSI
>   # include "psi.c"
> +# ifdef CONFIG_BPF_SYSCALL
> +#  include "bpf_psi.c"
> +# endif
>   #endif
>   
>   #ifdef CONFIG_MEMBARRIER
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index e1d8eaeeff17..e10fbbc34099 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -201,6 +201,10 @@ static void group_init(struct psi_group *group)
>   	init_waitqueue_head(&group->rtpoll_wait);
>   	timer_setup(&group->rtpoll_timer, poll_timer_fn, 0);
>   	rcu_assign_pointer(group->rtpoll_task, NULL);
> +#ifdef CONFIG_BPF_SYSCALL
> +	spin_lock_init(&group->bpf_triggers_lock);
> +	INIT_LIST_HEAD(&group->bpf_triggers);
> +#endif
>   }
>   
>   void __init psi_init(void)
> @@ -489,10 +493,17 @@ static void update_triggers(struct psi_group *group, u64 now,
>   
>   		/* Generate an event */
>   		if (cmpxchg(&t->event, 0, 1) == 0) {
> -			if (t->type == PSI_CGROUP)
> -				kernfs_notify(t->of->kn);
> -			else
> +			switch (t->type) {
> +			case PSI_SYSTEM:
>   				wake_up_interruptible(&t->event_wait);
> +				break;
> +			case PSI_CGROUP:
> +				kernfs_notify(t->of->kn);
> +				break;
> +			case PSI_BPF:
> +				bpf_psi_handle_event(t);
> +				break;
> +			}
>   		}
>   		t->last_event_time = now;
>   		/* Reset threshold breach flag once event got generated */
> @@ -1125,6 +1136,7 @@ void psi_cgroup_free(struct cgroup *cgroup)
>   		return;
>   
>   	cancel_delayed_work_sync(&cgroup->psi->avgs_work);
> +	bpf_psi_cgroup_free(cgroup);
>   	free_percpu(cgroup->psi->pcpu);
>   	/* All triggers must be removed by now */
>   	WARN_ONCE(cgroup->psi->rtpoll_states, "psi: trigger leak\n");
> @@ -1356,6 +1368,9 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>   	case PSI_CGROUP:
>   		t->of = params->of;
>   		break;
> +	case PSI_BPF:
> +		bpf_psi_add_trigger(t, params);
> +		break;
>   	}
>   
>   	t->pending_event = false;
> @@ -1369,8 +1384,10 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
>   
>   			task = kthread_create(psi_rtpoll_worker, group, "psimon");
>   			if (IS_ERR(task)) {
> -				kfree(t);
>   				mutex_unlock(&group->rtpoll_trigger_lock);
> +				if (t->type == PSI_BPF)
> +					bpf_psi_remove_trigger(t);
> +				kfree(t);
>   				return ERR_CAST(task);
>   			}
>   			atomic_set(&group->rtpoll_wakeup, 0);
> @@ -1414,10 +1431,16 @@ void psi_trigger_destroy(struct psi_trigger *t)
>   	 * being accessed later. Can happen if cgroup is deleted from under a
>   	 * polling process.
>   	 */
> -	if (t->type == PSI_CGROUP)
> -		kernfs_notify(t->of->kn);
> -	else
> +	switch (t->type) {
> +	case PSI_SYSTEM:
>   		wake_up_interruptible(&t->event_wait);
> +		break;
> +	case PSI_CGROUP:
> +		kernfs_notify(t->of->kn);
> +		break;
> +	case PSI_BPF:
> +		break;
> +	}
>   
>   	if (t->aggregator == PSI_AVGS) {
>   		mutex_lock(&group->avgs_lock);
> @@ -1494,10 +1517,16 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
>   	if (!t)
>   		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
>   
> -	if (t->type == PSI_CGROUP)
> -		kernfs_generic_poll(t->of, wait);
> -	else
> +	switch (t->type) {
> +	case PSI_SYSTEM:
>   		poll_wait(file, &t->event_wait, wait);
> +		break;
> +	case PSI_CGROUP:
> +		kernfs_generic_poll(t->of, wait);
> +		break;
> +	case PSI_BPF:
> +		break;
> +	}
>   
>   	if (cmpxchg(&t->event, 1, 0) == 1)
>   		ret |= EPOLLPRI;


