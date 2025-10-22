Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57290CCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64B48E0013; Tue, 21 Oct 2025 20:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15CB8E0002; Tue, 21 Oct 2025 20:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52CE8E0013; Tue, 21 Oct 2025 20:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9835E8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:58:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E7C611AB38
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:58:06 +0000 (UTC)
X-FDA: 84023938572.29.A4BB324
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BC64A20005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:58:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHYoAxeX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+NK81ogvu0TojLdasUdGfkhQOJ55IOtvthUfq6Kgc0=;
	b=yboWLJyrx70pKhyloLntmQ7ILj4ucYR+g/YoqrJcwR2hC3zwn2+LfTYs14S3v5JucRqYcp
	3u0O+yJBuBXBI+EZd357kemBY0aH/8Dt7+f6X4b/4OzFFxDDulRWodz55H1GMiLza3lgv/
	shisDmgPaGpxpitpx9+TpzTQOZTNyFE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHYoAxeX;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094684; a=rsa-sha256;
	cv=none;
	b=ox3AmCN2Fsddq98lbTe1x2JV/iccRQxhKFIpt6Jt3s9Ec69sH7CtByB1Ar8EhPOiV3sP1y
	/I8I7qfEFiPfpZrmAsJlkzS/HFXMirwEEpaRHjnI5MNmP4TzpQJLBjwolTsmuFdEXAE2ao
	iJtHO7DRA89REOhs9HNpzLXmrU09aqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8DF144CAF;
	Wed, 22 Oct 2025 00:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1652C4CEF1;
	Wed, 22 Oct 2025 00:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761094683;
	bh=uMDPju61XWbh4c9f5TQ4DN2PgD9sxPz1PbXcXRPEvn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cHYoAxeX1mBsM50GUoTBiKQA0EvY5sgw4FRV4RoYjanT4dnftwTWcoJd/MQn7mHxb
	 EFJioz5CpR6TTmatbSnDRZMfwmwlKRZboL4ApGZum8p7WeInD8+6g9nZrFPO08e4So
	 lFdwfyccMQQq/7+KnJfYk4jfngER+mFgWj2NabWwEr3TKpfm+Z7Oiv0rcfejulsZ1n
	 lOCACY/UzkQxNDuxLqLIDN96/KcYtidFwzGseIW013jN9PWY4FxgK1mWd3uT7sGaW2
	 bDfqn8bQImUsukgBSx3CtG6hBr/Q/by+u7x3NK7mJ0Cu8I51Mx6qzJdUsIRlOCl3YF
	 dkOJESLGxtkSQ==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
Date: Tue, 21 Oct 2025 17:58:00 -0700
Message-ID: <20251022005801.120250-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021234425.1885471-1-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nw3kzqt9rg7cziosbitmj4p31mn435uz
X-Rspamd-Queue-Id: BC64A20005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761094684-914423
X-HE-Meta: U2FsdGVkX19oDneK8YEbBkHNA9jg+KbPLExj1Id6DuQb92nZjGzEVcgra6oXJjzng1ZUeSQSfOCAm4ICr31tJ4xaMwVEB+a2x2PRYCWTdAKcHzh6G6lRqfH0YXYpDqPCfMqptcOhpmBzRAczBl0j37LSOV3HBWupvJ3FKsF2WwrRMOurmSwWw6GseB3w37+coQae21uRO424rEknBMWhZO2ja6UkIY7ZrXl0o/JtMT+7TYoC/TzWkeccSrd3ZMwCYLThinr1BijjvxHoxFcbg4MOi75rhDLLmXZE7G6Zswe4/vh2/RvbaXYmVlB7HX637XwZ/Y5ymyvTIJKhsB+FsN+GY3WUy16xEjWhVz0KZFCGmCFqCMxt3VwI4G2hogORwzA2X/DMWwdt6ApImGGUh47sHLPCktHq6I43hZoGa06uIJC0n1jTWkf5McUzTR7JoWqCR0H5eDyI/eH9NpH2PDLbvcj467n+gT0/O2KMd8sj9TZfNfZGpCLq/ZAvN225myTt7AAlA1oU8+rsrQszwm5R35eQ09qgjlMnjw3C6Er1uqXmxfK7Moa+qAntrMM3Io2gh1MHlmPcTgt1OGPhIK6hx4Fg23EhsgIpHilJU0UZyPG09sne0+uQxU7IbRcPHNnrf7m5zrdygaVaJ+uyAEi69OJfdTA2xLP/hX7MD4fiwbTJ1zKGQnkWqOg6Bgz0n2XbOxLwrJ1ioCZ5drv1wMkYAKXngyCVemT7gzB3tnO8JyE2LibDXIZOEyz5eiOYEeyXLX/BE6T49BwTNN/kedz9vnL+GG6Kg2k9UHkKI6xm96pLIy7iW+bci+R+HfKmBCqeQNRRKOrOxBysefQ/EuPPr/id8NTEKA/CwVF5C5zdw30/qAIHVkFWUHTCB2fG+2YUG9dqJqM1XseN0ckZfqxdND7T5HRHHpFqtQ95fp1D/gay80oueekNW77iGdeRM02Bb27NBHsLSCvCJ+L
 HhelFfnT
 Mo7proB8r+jgsKaKj5pQ3hUDFPmp2v9jhZn7+lxg1ZVAdcDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 16:44:25 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The function __memcg_memory_event has been unnecessarily marked inline
> even when it is not really performance critical. It is usually called
> to track extreme conditions. Over the time, it has evolved to include
> more functionality and inlining it is causing more harm.
> 
> Before the patch:
> $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
>    text    data     bss     dec     hex filename
>   35645   10574    4192   50411    c4eb mm/memcontrol.o
>   54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
>   34644    1065       0   35709    8b7d net/ipv4/tcp_output.o
> 
> After the patch:
> $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
>    text    data     bss     dec     hex filename
>   35137   10446    4192   49775    c26f mm/memcontrol.o
>   54322    1562       0   55884    da4c net/ipv4/tcp_input.o
>   34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/memcontrol.h | 32 ++------------------------------
>  mm/memcontrol.c            | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d37e7c93bb8c..8d2e250535a8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1002,36 +1002,8 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
>  	count_memcg_events_mm(mm, idx, 1);
>  }
>  
> -static inline void __memcg_memory_event(struct mem_cgroup *memcg,
> -					enum memcg_memory_event event,
> -					bool allow_spinning)
> -{
> -	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> -			  event == MEMCG_SWAP_FAIL;
> -
> -	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
> -	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
> -
> -	atomic_long_inc(&memcg->memory_events_local[event]);
> -	if (!swap_event && allow_spinning)
> -		cgroup_file_notify(&memcg->events_local_file);
> -
> -	do {
> -		atomic_long_inc(&memcg->memory_events[event]);
> -		if (allow_spinning) {
> -			if (swap_event)
> -				cgroup_file_notify(&memcg->swap_events_file);
> -			else
> -				cgroup_file_notify(&memcg->events_file);
> -		}
> -
> -		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> -			break;
> -		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> -			break;
> -	} while ((memcg = parent_mem_cgroup(memcg)) &&
> -		 !mem_cgroup_is_root(memcg));
> -}
> +void __memcg_memory_event(struct mem_cgroup *memcg,
> +			  enum memcg_memory_event event, bool allow_spinning);
>  
>  static inline void memcg_memory_event(struct mem_cgroup *memcg,
>  				      enum memcg_memory_event event)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1a95049d8b88..93f7c76f0ce9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1626,6 +1626,37 @@ unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
>  	return page_counter_read(&memcg->memory);
>  }
>  
> +void __memcg_memory_event(struct mem_cgroup *memcg,
> +			  enum memcg_memory_event event, bool allow_spinning)

Seems this function is called only from memcontrol.c.  Why not making it a
static function?

> +{
> +	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> +			  event == MEMCG_SWAP_FAIL;
> +
> +	/* For now only MEMCG_MAX can happen with !allow_spinning context. */
> +	VM_WARN_ON_ONCE(!allow_spinning && event != MEMCG_MAX);
> +
> +	atomic_long_inc(&memcg->memory_events_local[event]);
> +	if (!swap_event && allow_spinning)
> +		cgroup_file_notify(&memcg->events_local_file);
> +
> +	do {
> +		atomic_long_inc(&memcg->memory_events[event]);
> +		if (allow_spinning) {
> +			if (swap_event)
> +				cgroup_file_notify(&memcg->swap_events_file);
> +			else
> +				cgroup_file_notify(&memcg->events_file);
> +		}
> +
> +		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +			break;
> +		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> +			break;
> +	} while ((memcg = parent_mem_cgroup(memcg)) &&
> +		 !mem_cgroup_is_root(memcg));
> +}
> +EXPORT_SYMBOL(__memcg_memory_event);

Also, seems there is no reason to export this symbol?


Thanks,
SJ

[...]

