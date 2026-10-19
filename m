Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078E4CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2E26B015D; Mon, 19 Oct 2026 03:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1947B6B015E; Mon, 19 Oct 2026 03:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB566B015F; Mon, 19 Oct 2026 03:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E174D6B015D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:14:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74B31140333
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:14:39 +0000 (UTC)
X-FDA: 85338513078.08.FBD1EC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D779E40007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:14:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TO3/piPO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792394077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjfAc2gny8dQsYPeC3CuZrupUfIwRcHCXU8B21O53cM=;
	b=SsJptScdi7bau0p6LKNHqHLfMik4cGSMAe55qrfrrBRbkgIUZdvdf9VhOfVgXvk0wfprH8
	6M88eprWig0yDwx9wBwExjR4eidXclVbZqb1tOW5/qmYZFnv261IidzfZqU3VPFo1B8vuY
	JGvTAJiKA4dCGRt/SZ/WLFLYpsmMSrA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TO3/piPO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792394077;
	b=hrgFl7is36GTBkEwmkTCoe9XzqbMajektUuM4sZaBIuetuz7V894TYPN17CdMBNZJJ+OXb
	NKE2R8mKJFlK2FNjdbjluaHrDyGsqkNYxxt/2jONqM0v0hcANQIN5gfCxit4d+e399NxUF
	sNpqEXK+rsTT099FYht/MPjBunL0cOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A104601FB;
	Mon, 19 Oct 2026 07:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFDF1F000C4;
	Mon, 19 Oct 2026 07:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792394076;
	bh=bjfAc2gny8dQsYPeC3CuZrupUfIwRcHCXU8B21O53cM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TO3/piPOM3x60PNpztvZMRu22lNm4l7few6eRCSKB1FrHx2knOjeG/Oa7F0Fc0C9l
	 UmVkO/ZWa6oeP5/zf9/BfXFxg6KQZVuewNvTgb5BCC8Hu2DA+Ev+FT2wz0lYRiBgk+
	 YUWS+niNabITtQe/7d75LLWlDjywICF7JaYnSOfaXlG35XFHF50Ntf2bSz2MA4GbjS
	 Vv7kT71/ONlhp0fLiEnQngyIR1ijOewuz9jel3TNNWJblNpyaAryXAoorWX1neL5rK
	 OpFJJQv3VFTlWthXwOa84cWgk77PrwZ9YGGMTuK9Ee6YY6g9j8J+Z1dkU7WBqOe9QC
	 y6oZG6pgkOJXg==
Content-Type: multipart/mixed; boundary="===============4079140705519087332=="
MIME-Version: 1.0
Message-Id: <03f6cc15036fbecfd577d878d80d7b182b1cc6574e8bb7daabf6ad8e44fd59dd@mail.kernel.org>
In-Reply-To: <20261019064157.29885-4-laoar.shao@gmail.com>
References: <20261019064157.29885-4-laoar.shao@gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 3/5] sched: add helpers for numa balancing
From: bot+bpf-ci@kernel.org
To: laoar.shao@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,akpm@linux-foundation.org,david@kernel.org,gourry@gourry.net,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,yu.c.chen@intel.com,zhao1.liu@intel.com,tim.c.chen@linux.intel.com,lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kernel@vger.kernel.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 19 Oct 2026 07:14:36 +0000 (UTC)
X-Rspamd-Queue-Id: D779E40007
X-Stat-Signature: 5854umwargp3k6k6p5rurfnssqti53r4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792394077-278039
X-HE-Meta: U2FsdGVkX19I/EeVI/COzsBKaXRZQLXT108aXxLkTeEHd54TRGTCA+/DrC/MTN/bjj/kbPeaV2vO8xgCdSHTt+HkwnypRLYIMASJOmkzN9lgGvqkJuu2uEPAxlktrlFg+ztbN2KJdnkIR6xPlSWF8t7GYMXMWUglHRc2vmyFPL/9soyNjzI1aHa6J57L0Rjrbve2C07AOnjwphkkXZkZvacwaup57fftZ0ThpYEkH54I3++kZoGheVqZpzD82mBkYaoM0BsgMnY6JjF4z2s30yBy4bKTsUaJo2kJhfgkcFlK6tnCODY0YItOVoekOwnQyzZUmBAoxpd+Gx7IkwqywhQCNIvo/Iz96Y3IdZM6cjs5J0LSiZmq90ZJH5LHj9mNVfwRwzFsURhN95DjbDTvjY4NVGtXdmNUDVApSY8Ibzh3j7rmen+PSW9g7ymmvCYR1sdenTLNeM/cGQTUqGt6f3PckCBRTlKwudh4k+GT7AdUjcMgMiP0AFgl2PiSIzanEfqQ3a2mfF7TcxAC98OdcsG3t+OH1wxoQhpspLJUFJP/frJGAYOvGKyPGJycEcuqjdASuyljShynuGap/dDlV98k752Iy+n5bZTg7DxqL9HSuCBI80kxDu46UUimiRzJwognZb6wSRfo/UzJzspWm0Dc/ILCqEdt0rWyE1EUYic9AziXmNIGMXh8UHD+V14l0/T0eLZN3WE0a3GykPgXLnqbQUiwPuLWnX7Q8fJJCCqZgp7tjzWP6fng6IIoLjmgZOEMoEJrULB7SuMEc12oyR1wKEJX2753DUTfZcxAWnCC4FvH5l/9RN3bmlGZMT1nrnOdK4baDVJGvfQNbb6e9HgBWLfDWu+85Et++xaRQ2gH380a6ZznPPe8Xrwez9Uf6Pv8ayVQAExkTwJn7Nf8lkxgN2Gh53pbBrWosEU396gcXMvdR2DxCYHtJb6FOKTc5xmc93kot6iseOqKJAY
 lePliNfB
 ShR6W8nGtiqq5CDJ6ChtJAwRxe9pHKuh439e5Yg6+/iPvkns18VHi50lqaZ7LdxwX1kWFLORqk1SGFMrG10eIIbl+CYkYL4Vld44tTl3m1gdDb2JS0W+KdoOvXHWO+qgEFWQc4K8QDBzNm5IvpNnifNJVMGeZVnzUG6s/slTCKiFp/pqJyhEoE88RWmsYnvUKhKxtaq0mVvzNCfIPXsQwUmAH4ORz0UQ5SRP6rdiGhd11+c+YBK3hJyYuuWh6Nk2ec1RdRz0h/TCOUoAZHoiShLJzqfNTxDdxF06He1QrCJKjpD+SUPRUtwTrSSc8y4n9ncVGypCSGpxTv0LUe7o+jhEPJXfocsDry2B+ftEUJdJ0VOWYO6GxZCiLxGRXG/DTW26QjQohs7wDGOb4BMkZE2+dEYOWbaDXJvzmoFcQ+uOxT69W1zNhxqzBXYcycSjTV9FGiAU9vup48S5oXekpV6NKL7DdSGp2ZRm/q97t6+GZY4CQ6xCXHKNunw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4079140705519087332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched: add helpers for numa balancing

TL;DR: Nits only: redundant parentheses around the new numab_in_tiering_mode()
helper calls in should_numa_migrate_memory() and migrate_misplaced_folio()
could be dropped.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 71dc47d6114d..066818498c76 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c

[ ... ]

> @@ -2963,8 +2965,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>  	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>  
> -	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
> +	if (!(numab_in_tiering_mode()) && !node_is_toptier(src_nid) &&
> +	    !cpupid_valid(last_cpupid))
>  		return false;

this isn't a bug, but could the extra parentheses in
!(numab_in_tiering_mode()) be dropped here?  They were needed around the
old bitwise test, and the other converted sites such as
task_numa_fault() call the helper without them.

[ ... ]

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..a622df9a9b42 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c

[ ... ]

> @@ -2770,7 +2771,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>  	if (nr_succeeded) {
>  		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
>  		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
> -		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		if ((numab_in_tiering_mode())
>  		    && !node_is_toptier(folio_nid(folio))
>  		    && node_is_toptier(node))
>  			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);

The same applies to the parentheses in
if ((numab_in_tiering_mode()) here.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39213018427
--===============4079140705519087332==--

