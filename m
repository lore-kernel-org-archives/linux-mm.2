Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4FACA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A59B8E00F3; Tue, 26 Aug 2025 12:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0572B8E00EC; Tue, 26 Aug 2025 12:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E871A8E00F3; Tue, 26 Aug 2025 12:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D331B8E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:57:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 404DF1A0219
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:57:00 +0000 (UTC)
X-FDA: 83819513400.10.969DA03
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 484D7140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QdY8yZUs;
	spf=pass (imf26.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756227418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+KB6d2ii43Z2jE4Sy0ThtTdO5RYn89XqD3QKRElsfk=;
	b=WnJ0GloefuMLn2ulmxTZenALVS3XzsaPsWdaLXN3NYGDH+UR2zx2Y2v3/eXst+cS0gtTUE
	TrzZDyuBr1f1C1ZIYNdVpiytcEX5O8T2nwjcYJ7MqGZlEl2uOiYq/eB2/2U1pZX2zb/Pug
	ln/53H7XxJQP0q3xzJbGw322gL11LhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QdY8yZUs;
	spf=pass (imf26.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756227418; a=rsa-sha256;
	cv=none;
	b=w/8ouxrDyMxCpFUumDkMjtSaU64glNgQvsI1CDXZONLqo6xgjmsRaKERQ/lFJ+//leU97V
	fbdui9uqk65xLpzR8E8fP3WotszFb8fe6lKGhnHobYcZQfYiypTRdkRJGlq2zk4NWVhU33
	bfTnUPpiCGfuoes1uZePL44ZLZjMh/k=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-325195d1b1bso3235915a91.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756227417; x=1756832217; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p+KB6d2ii43Z2jE4Sy0ThtTdO5RYn89XqD3QKRElsfk=;
        b=QdY8yZUswIUHaw5OjMHw1CWZF44NYo3NBpyx/KussWT82lV3bQWAntT3ToLpVlyAsF
         Q6Afmsham/uWIm6SDPivcSN3BNHFj23LtEGZOQxNDMRuQB1kCTKKPiK9tzIsNz45/4UA
         1s10Sy8VrUQt6NImVZ1zvI+RASYdM2mpyFYwzQHfYP38No51oz0LXKvOV/45837pOQ+V
         J3evTwjmrRbjq49AVH3iWuW2gidr2xT18gEcolf+xkr6EvG1SpjgQlPYAiZR0jrrvWhk
         AmCWRqUuJUPIqE5+5UqwhekZcFYAz3e36FJU9ZKp5Vgw2StAb5ummSNLXPJZpY0YHyh6
         04KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756227417; x=1756832217;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+KB6d2ii43Z2jE4Sy0ThtTdO5RYn89XqD3QKRElsfk=;
        b=ltuZGSx4gqv4K73Q7nNW6ecY5u0m0Du7Ipn/YA11rQawLhHkzLV1rfbNcvzzdneVv1
         FRGDyX3ANiMDoFo9+Nza1dgxCciIj6LnUuDU35+f4pp87+NBHjC9Qdbdi+8VsL+rvy7w
         3I228/TUHXxaHZiUhRu7OMGxgbIcceO29rH9cWzYUXsG+a6equ+r2jaaP9zkHxTowms+
         bjdYmmCmmlzFZxVWJJROD8ULIuoA//kTTZsOXsCixhxC6HxgJEHHN+kbv70OG6qLeSv/
         E38M8XKFNAmo3KBvEfWSlCL9i5Nap2MzlkPR1DgQZYRZSEiVVXpGhLnQ5RoUlnfwg90e
         vedA==
X-Forwarded-Encrypted: i=1; AJvYcCWwRJRck6NT2V/jPmHufO39sz9aXpnFoDPhXMtc0s215f1AeIGr9r1KmwZoRcGKP7dAyEEj3zTv+g==@kvack.org
X-Gm-Message-State: AOJu0YzdqKZKVTKOyNQtlczk6AXJ0QnKe89jaXxPiBWi4n3IGWqQ6c9G
	BIigj5jepPEgCfJxYkSVzuX8gBO4MBiu3DYOK2WqggBDotNKvRJ0IvGl2JgWCA==
X-Gm-Gg: ASbGnct93hrU4g3YD5z0c0v05d5IE+fGdIt9nvRM+6hwZnT9UIJClsZHsGes526LuTO
	AHExz2CxJBgC+75S+9ls0M4EKleEiJYQYsBjCX9HVwiVNAHL6/szDIluNxXltqe6FiLZHR3epcA
	IlZTWlbqI1j1NM8IEDM8UQ5a+HaD6YgPn3c14GA6oTVLLILa1LUb7jtsfaebytX4E2axDNHkGGD
	67PNJnYzNc69KW66qlgpBL86+J39UMmBW7CHgfhAoEghcCuhq39JsqOQW0Bl3S5jHGZXRiRVP9i
	J7ASqYIymb1uRKmMchZGMBbVhmV3/2URzBBwdhnLLLXs7mUeT5CQoMeFtqJLVKajahqgwc47jYX
	k/NEDiJyjP/4kirb0gzU6iokJWROOPVXvy5tkT1wkcXGl5gxKtWGwMVD+o5iKPH8WTw==
X-Google-Smtp-Source: AGHT+IEF6Usdfy5vPYS1NMsAOkGzxJUPb0MrhLayywZFySl5xloZmchFdDhutAG5JdegKlPdv7BI2g==
X-Received: by 2002:a17:90a:e704:b0:325:6598:30fe with SMTP id 98e67ed59e1d1-32565983334mr16069137a91.4.1756227416807;
        Tue, 26 Aug 2025 09:56:56 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:a:14b0:ff2b:98c1:659? ([2620:10d:c090:500::4:9299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3274572be3bsm1357878a91.2.2025.08.26.09.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 09:56:56 -0700 (PDT)
Message-ID: <4b715bdf-4f2a-4e82-94a0-3846526f8d59@gmail.com>
Date: Tue, 26 Aug 2025 09:56:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Martin KaFai Lau <martin.lau@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
Content-Language: en-US
From: Amery Hung <ameryhung@gmail.com>
In-Reply-To: <20250818170136.209169-2-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 484D7140003
X-Stat-Signature: z8gmr9bqmnciyc19i77nsybydi3hpu5f
X-Rspam-User: 
X-HE-Tag: 1756227418-920479
X-HE-Meta: U2FsdGVkX19mEut0tYSEjTBTSvtPVSBSsE1HQa1b8Xunk2lrUruU1zj4ZRI1s4xVMU9R84U3e6VPlFGuFQ63hFMM7OkAoonB4E4YJHSPoiFI3YVqq9TgQMfFNkKfbi50XMLmeBaKfnV3gZvvr7LxOA5fUPRTK0uATXL5irkSpgsExXNEM6302+Dw/80WpgAwxNhdJbTWNL6ayg+j4/04Gpdnj+luj+ueJRnlQdmQhgIsiEhB1GSsjMQVJtuPcG7nZnqgvO0biZTs6u0P2hJV50YF94+bkI8Lg9VDuWN4WG2prM4Kqu8HE4Qh2znB+rMloiea6G21dL70ON7XZgZq1zzA1s6Z58gXI6P9vilKqgdDQosDQKlfyRvwPJWSxzn/BdF2PD4dN5YhZRAYm0FEQwOc/wLhc/CI3Iam+xw2pPFrR5H23whfkNSO4OxseXa9TqvvV9jVqEQIZXja2umcXK1NSSCunt7OkF17ab7/Ji5Xs9UTzPQi4YuAOoHsfy13jNlhScm4+TD5drf07T8pNetsrEyb2OGfwLVtI61K1m+bRZwuoXoC7cuiDhmC5MP7XytYQ+pZC/eVJZzWqRDVuKPGG677nrQ9JYSermLBuR912krJb532XgcM4DRFgeDEHtn3N3d4hz51nFoDndjv9ZY+CUEFHLA3k1eYu+IkB3OSfu/C0Aaze/4c4j69V5ejhk5yS+nIjna4CDpzOs7GDvMu/ZFg2sZ8iZrkISmXhXdpIt5i+eoaaa8xIyGWh/o/8f5uUHaNDs8c+daHjOsHjy4cKajgjVsCFjHVZqgbk1J4eCkSfN/JwZQbKgXXIfZ0Gge6QKal+fZMMjQ9Rct4hH9Qdvf57tLhIOY13snqphVI5P6QtYOsgZbM0rkRmn9ZfibSi3nkCs8faoji/7lONY10PpHBN9axPgBMZ2P3hnlbxNd+DI7bDPOdtxuG+ktP9Kbs+H0ptGyVlY4asYH
 6yjucNP+
 tRmmnwixjuGmcVWBb2y4JeVkt0hGc/T32Go//DilwK8lU4WpQyFVm7GNVDMryeVK50mydU6ADFV9m7tBhA6LmkcOmE7VseP7bJ4fNWIbC2/T222+eU3bZ0VugVyLZMlZwmwOg73JcN1ehmOE5jI0vZirOBca3DuKbPLPJeY1lgtXDV9L383yGLRtT4av1LFsJDPjG7sm54poLE5cyMouvr8B8tugZikI2pwj4wK8YOdL/ONVZSEEcEGpMRflA4FZW6qYykjUjCmuA429WxOXG5SUaLpZpYzbXQvSBZSBLvjgCJdR31in/2tj1/3fun6Ov0NYjw0ZkpKCnP4/xzJxJ/c9QCD0r+iqwgTmPv1S0VHWSoHw0lmHbpssEY3zSkJIhkWFdLGMNNTXfXZnFjSPn0y/3obGrIS9MEHa1tDmwCT9WHlbgHjU6LuoBlkNwE0P6wAtbjtcxasrC7LHnZZLIMUIMSi5dKjzz8WpGciN38zO+N7E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/18/25 10:01 AM, Roman Gushchin wrote:
> Introduce a bpf struct ops for implementing custom OOM handling policies.
>
> The struct ops provides the bpf_handle_out_of_memory() callback,
> which expected to return 1 if it was able to free some memory and 0
> otherwise.
>
> In the latter case it's guaranteed that the in-kernel OOM killer will
> be invoked. Otherwise the kernel also checks the bpf_memory_freed
> field of the oom_control structure, which is expected to be set by
> kfuncs suitable for releasing memory. It's a safety mechanism which
> prevents a bpf program to claim forward progress without actually
> releasing memory. The callback program is sleepable to enable using
> iterators, e.g. cgroup iterators.
>
> The callback receives struct oom_control as an argument, so it can
> easily filter out OOM's it doesn't want to handle, e.g. global vs
> memcg OOM's.
>
> The callback is executed just before the kernel victim task selection
> algorithm, so all heuristics and sysctls like panic on oom,
> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> are respected.
>
> The struct ops also has the name field, which allows to define a
> custom name for the implemented policy. It's printed in the OOM report
> in the oom_policy=<policy> format. "default" is printed if bpf is not
> used or policy name is not specified.
>
> [  112.696676] test_progs invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>                 oom_policy=bpf_test_policy
> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
> [  112.698167] Call Trace:
> [  112.698177]  <TASK>
> [  112.698182]  dump_stack_lvl+0x4d/0x70
> [  112.698192]  dump_header+0x59/0x1c6
> [  112.698199]  oom_kill_process.cold+0x8/0xef
> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
> [  112.698250]  out_of_memory+0xab/0x5c0
> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
> [  112.698288]  charge_memcg+0x2f/0xc0
> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
> [  112.698299]  do_anonymous_page+0x40f/0xa50
> [  112.698311]  __handle_mm_fault+0xbba/0x1140
> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  112.698335]  handle_mm_fault+0xe6/0x370
> [  112.698343]  do_user_addr_fault+0x211/0x6a0
> [  112.698354]  exc_page_fault+0x75/0x1d0
> [  112.698363]  asm_exc_page_fault+0x26/0x30
> [  112.698366] RIP: 0033:0x7fa97236db00
>
> It's possible to load multiple bpf struct programs. In the case of
> oom, they will be executed one by one in the same order they been
> loaded until one of them returns 1 and bpf_memory_freed is set to 1
> - an indication that the memory was freed. This allows to have
> multiple bpf programs to focus on different types of OOM's - e.g.
> one program can only handle memcg OOM's in one memory cgroup.
> But the filtering is done in bpf - so it's fully flexible.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>   include/linux/bpf_oom.h |  49 +++++++++++++
>   include/linux/oom.h     |   8 ++
>   mm/Makefile             |   3 +
>   mm/bpf_oom.c            | 157 ++++++++++++++++++++++++++++++++++++++++
>   mm/oom_kill.c           |  22 +++++-
>   5 files changed, 237 insertions(+), 2 deletions(-)
>   create mode 100644 include/linux/bpf_oom.h
>   create mode 100644 mm/bpf_oom.c
>
> diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
> new file mode 100644
> index 000000000000..29cb5ea41d97
> --- /dev/null
> +++ b/include/linux/bpf_oom.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +
> +#ifndef __BPF_OOM_H
> +#define __BPF_OOM_H
> +
> +struct bpf_oom;
> +struct oom_control;
> +
> +#define BPF_OOM_NAME_MAX_LEN 64
> +
> +struct bpf_oom_ops {
> +	/**
> +	 * @handle_out_of_memory: Out of memory bpf handler, called before
> +	 * the in-kernel OOM killer.
> +	 * @oc: OOM control structure
> +	 *
> +	 * Should return 1 if some memory was freed up, otherwise
> +	 * the in-kernel OOM killer is invoked.
> +	 */
> +	int (*handle_out_of_memory)(struct oom_control *oc);

I suggest adding "struct bpf_oom *" as the first argument to all 
bpf_oom_ops to future-proof. It will allow an bpf_oom kfunc or prog to 
refer to the struct_ops instance itself.

Since bpf_oom_ops allows multiple attachment, if a bpf_prog is shared 
between two bpf_oom, it will be able to infer which bpf_oom_ops is 
calling by this extra argument.


> +
> +	/**
> +	 * @name: BPF OOM policy name
> +	 */
> +	char name[BPF_OOM_NAME_MAX_LEN];
> +
> +	/* Private */
> +	struct bpf_oom *bpf_oom;
> +};
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +/**
> + * @bpf_handle_oom: handle out of memory using bpf programs
> + * @oc: OOM control structure
> + *
> + * Returns true if a bpf oom program was executed, returned 1
> + * and some memory was actually freed.
> + */
> +bool bpf_handle_oom(struct oom_control *oc);
> +
> +#else /* CONFIG_BPF_SYSCALL */
> +static inline bool bpf_handle_oom(struct oom_control *oc)
> +{
> +	return false;
> +}
> +
> +#endif /* CONFIG_BPF_SYSCALL */
> +
> +#endif /* __BPF_OOM_H */
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 1e0fc6931ce9..ef453309b7ea 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -51,6 +51,14 @@ struct oom_control {
>   
>   	/* Used to print the constraint info. */
>   	enum oom_constraint constraint;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +	/* Used by the bpf oom implementation to mark the forward progress */
> +	bool bpf_memory_freed;
> +
> +	/* Policy name */
> +	const char *bpf_policy_name;
> +#endif
>   };
>   
>   extern struct mutex oom_lock;
> diff --git a/mm/Makefile b/mm/Makefile
> index 1a7a11d4933d..a714aba03759 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -105,6 +105,9 @@ obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>   ifdef CONFIG_SWAP
>   obj-$(CONFIG_MEMCG) += swap_cgroup.o
>   endif
> +ifdef CONFIG_BPF_SYSCALL
> +obj-y += bpf_oom.o
> +endif
>   obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>   obj-$(CONFIG_GUP_TEST) += gup_test.o
>   obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
> diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
> new file mode 100644
> index 000000000000..47633046819c
> --- /dev/null
> +++ b/mm/bpf_oom.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * BPF-driven OOM killer customization
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/oom.h>
> +#include <linux/bpf_oom.h>
> +#include <linux/srcu.h>
> +
> +DEFINE_STATIC_SRCU(bpf_oom_srcu);
> +static DEFINE_SPINLOCK(bpf_oom_lock);
> +static LIST_HEAD(bpf_oom_handlers);
> +
> +struct bpf_oom {
> +	struct bpf_oom_ops *ops;
> +	struct list_head node;
> +	struct srcu_struct srcu;
> +};
> +
> +bool bpf_handle_oom(struct oom_control *oc)
> +{
> +	struct bpf_oom_ops *ops;
> +	struct bpf_oom *bpf_oom;
> +	int list_idx, idx, ret = 0;
> +
> +	oc->bpf_memory_freed = false;
> +
> +	list_idx = srcu_read_lock(&bpf_oom_srcu);
> +	list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, false) {
> +		ops = READ_ONCE(bpf_oom->ops);
> +		if (!ops || !ops->handle_out_of_memory)
> +			continue;
> +		idx = srcu_read_lock(&bpf_oom->srcu);
> +		oc->bpf_policy_name = ops->name[0] ? &ops->name[0] :
> +			"bpf_defined_policy";
> +		ret = ops->handle_out_of_memory(oc);
> +		oc->bpf_policy_name = NULL;
> +		srcu_read_unlock(&bpf_oom->srcu, idx);
> +
> +		if (ret && oc->bpf_memory_freed)
> +			break;
> +	}
> +	srcu_read_unlock(&bpf_oom_srcu, list_idx);
> +
> +	return ret && oc->bpf_memory_freed;
> +}
> +
> +static int __handle_out_of_memory(struct oom_control *oc)
> +{
> +	return 0;
> +}
> +
> +static struct bpf_oom_ops __bpf_oom_ops = {
> +	.handle_out_of_memory = __handle_out_of_memory,
> +};
> +
> +static const struct bpf_func_proto *
> +bpf_oom_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	return tracing_prog_func_proto(func_id, prog);
> +}
> +
> +static bool bpf_oom_ops_is_valid_access(int off, int size,
> +					enum bpf_access_type type,
> +					const struct bpf_prog *prog,
> +					struct bpf_insn_access_aux *info)
> +{
> +	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> +}
> +
> +static const struct bpf_verifier_ops bpf_oom_verifier_ops = {
> +	.get_func_proto = bpf_oom_func_proto,
> +	.is_valid_access = bpf_oom_ops_is_valid_access,
> +};
> +
> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_oom_ops *ops = kdata;
> +	struct bpf_oom *bpf_oom;
> +	int ret;
> +
> +	bpf_oom = kmalloc(sizeof(*bpf_oom), GFP_KERNEL_ACCOUNT);
> +	if (!bpf_oom)
> +		return -ENOMEM;
> +
> +	ret = init_srcu_struct(&bpf_oom->srcu);
> +	if (ret) {
> +		kfree(bpf_oom);
> +		return ret;
> +	}
> +
> +	WRITE_ONCE(bpf_oom->ops, ops);
> +	ops->bpf_oom = bpf_oom;
> +
> +	spin_lock(&bpf_oom_lock);
> +	list_add_rcu(&bpf_oom->node, &bpf_oom_handlers);
> +	spin_unlock(&bpf_oom_lock);
> +
> +	return 0;
> +}
> +
> +static void bpf_oom_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_oom_ops *ops = kdata;
> +	struct bpf_oom *bpf_oom = ops->bpf_oom;
> +
> +	WRITE_ONCE(bpf_oom->ops, NULL);
> +
> +	spin_lock(&bpf_oom_lock);
> +	list_del_rcu(&bpf_oom->node);
> +	spin_unlock(&bpf_oom_lock);
> +
> +	synchronize_srcu(&bpf_oom->srcu);
> +
> +	kfree(bpf_oom);
> +}
> +
> +static int bpf_oom_ops_init_member(const struct btf_type *t,
> +				   const struct btf_member *member,
> +				   void *kdata, const void *udata)
> +{
> +	const struct bpf_oom_ops *uops = (const struct bpf_oom_ops *)udata;
> +	struct bpf_oom_ops *ops = (struct bpf_oom_ops *)kdata;
> +	u32 moff = __btf_member_bit_offset(t, member) / 8;
> +
> +	switch (moff) {
> +	case offsetof(struct bpf_oom_ops, name):
> +		strscpy_pad(ops->name, uops->name, sizeof(ops->name));
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static int bpf_oom_ops_init(struct btf *btf)
> +{
> +	return 0;
> +}
> +
> +static struct bpf_struct_ops bpf_oom_bpf_ops = {
> +	.verifier_ops = &bpf_oom_verifier_ops,
> +	.reg = bpf_oom_ops_reg,
> +	.unreg = bpf_oom_ops_unreg,
> +	.init_member = bpf_oom_ops_init_member,
> +	.init = bpf_oom_ops_init,
> +	.name = "bpf_oom_ops",
> +	.owner = THIS_MODULE,
> +	.cfi_stubs = &__bpf_oom_ops
> +};
> +
> +static int __init bpf_oom_struct_ops_init(void)
> +{
> +	return register_bpf_struct_ops(&bpf_oom_bpf_ops, bpf_oom_ops);
> +}
> +late_initcall(bpf_oom_struct_ops_init);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..ad7bd65061d6 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -45,6 +45,7 @@
>   #include <linux/mmu_notifier.h>
>   #include <linux/cred.h>
>   #include <linux/nmi.h>
> +#include <linux/bpf_oom.h>
>   
>   #include <asm/tlb.h>
>   #include "internal.h"
> @@ -246,6 +247,15 @@ static const char * const oom_constraint_text[] = {
>   	[CONSTRAINT_MEMCG] = "CONSTRAINT_MEMCG",
>   };
>   
> +static const char *oom_policy_name(struct oom_control *oc)
> +{
> +#ifdef CONFIG_BPF_SYSCALL
> +	if (oc->bpf_policy_name)
> +		return oc->bpf_policy_name;
> +#endif
> +	return "default";
> +}
> +
>   /*
>    * Determine the type of allocation constraint.
>    */
> @@ -458,9 +468,10 @@ static void dump_oom_victim(struct oom_control *oc, struct task_struct *victim)
>   
>   static void dump_header(struct oom_control *oc)
>   {
> -	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
> +	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\noom_policy=%s\n",
>   		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
> -			current->signal->oom_score_adj);
> +		current->signal->oom_score_adj,
> +		oom_policy_name(oc));
>   	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
>   		pr_warn("COMPACTION is disabled!!!\n");
>   
> @@ -1161,6 +1172,13 @@ bool out_of_memory(struct oom_control *oc)
>   		return true;
>   	}
>   
> +	/*
> +	 * Let bpf handle the OOM first. If it was able to free up some memory,
> +	 * bail out. Otherwise fall back to the kernel OOM killer.
> +	 */
> +	if (bpf_handle_oom(oc))
> +		return true;
> +
>   	select_bad_process(oc);
>   	/* Found nothing?!?! */
>   	if (!oc->chosen) {


