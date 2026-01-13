Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398E7D2D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D076B0089; Tue, 13 Jan 2026 07:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854E36B008A; Tue, 13 Jan 2026 07:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E006B008C; Tue, 13 Jan 2026 07:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 693F86B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:42:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A1E3C0127
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:42:44 +0000 (UTC)
X-FDA: 84326904648.04.6CC6E08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A785340013
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:42:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SsPwlrXZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768308162; a=rsa-sha256;
	cv=none;
	b=MZ4KYKHzc59+YvZ2zOSGLNaEHHlqD95M+243ghowNWJl5AfQCOz6ZySY2r/kxHscSdK6bS
	SGJ65kBBhA4bG0nNjyoJFwQYs/GKEqXB7nK+9WFruX3fmQ0brE+GGh1ZPlCGqG2gnrGH/a
	LY79wSzNAAqIQ6Sf/hcRCq75UppOhR4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SsPwlrXZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768308162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQcacqrw9PkPTszSvJv2a8vhIENGtAbvN1PGGL1C87w=;
	b=fYY2TxVavgf1RWV42KseESFheV/j3d6G4M7+HkFZM/YDlt3A4+xMSxexLxW26HNN30U1XB
	52rTSoZ8pNzIHmj3xtWLJhQ7FItPyFMprKhUJjuteLIuO40si2tsYBJ/05tHdbSPQWSNr+
	ZR43t28YrfvNAXGCVG0w9eE7IwfyCQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B75E46000A;
	Tue, 13 Jan 2026 12:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B28C116C6;
	Tue, 13 Jan 2026 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768308161;
	bh=/rhdd0wg985rvZA9gm6N7N3iXKw1yrmZh8uRIqjK0qo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=SsPwlrXZcHLRfd87zRrnL+Q21oqGj51gsGYWaR52R/vOCEaLJfgENJEQiEn3DO7WS
	 S4yQCnT/jsxWr80b+rpcgHtDmuloJ4sePU1DLwEsMllM01BVOYCpTbe4Lki9yozr+j
	 4AhMXgP6IUBOZ7IkTIZzPErwQx1RVjGkDJZnOUKrgvesq+2u76+ejE/EFrgN9VCje3
	 0UNXkRW+nMdY6gskOYLPYwnWn2Yt/lK9wIl4iyt0QkyW3pO/YDue3cE41R/FSNY+XC
	 XuT9OrN3+apsA1n2ctlWm9EPeTqeVUmRpuxaJ7QAxLd/O4tdwJvpsWhc+zZiBojR8b
	 epVhr8xC9APWg==
Content-Type: multipart/mixed; boundary="===============4672709832961997223=="
MIME-Version: 1.0
Message-Id: <8496feb711aed72644504926d9ff358550c011e3144dea088833ad723f4fe852@mail.kernel.org>
In-Reply-To: <20260113121238.11300-2-laoar.shao@gmail.com>
References: <20260113121238.11300-2-laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/3] sched: add helpers for numa balancing
From: bot+bpf-ci@kernel.org
To: laoar.shao@gmail.com,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,mkoutny@suse.com,yu.c.chen@intel.com,zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 13 Jan 2026 12:42:41 +0000 (UTC)
X-Rspam-User: 
X-Stat-Signature: x5gm61whqfudbaedt183ddb6wjb8stqk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A785340013
X-HE-Tag: 1768308162-849978
X-HE-Meta: U2FsdGVkX19Eyb2EpsIwQ7G1qACx/mw625Rvtzrf2tduF+Hfmn3+T2dvg64jJG61jSc0+NV5UMGRm8N9kiy13iK6OISr2ZrKyb+BeDBJXcGwK+WR7Yi2WbNDJGT5LSKVcxoprHTrdYXEfuuTD1azmgeImYck2W0GFvRFJcZjCTMP9XoKnyfi9kEJ8rGjv3POBfU3oO3NZ5NaYmRjq1kF0vNgn+VzolZ3+CEiH95bKjzcyPy7gADJqpn9mPSoPm9c35s0UOxXemjakhZzkKldpdsqX2mHzgkwGg0tD+lediRwzdhhzB0Q/NXlei4M7fwcTReX+wZ0BUh3kmI1ULMiHGg7KI6NeVnizVBUp3FXIalK60fKdXtQaGQmL/2TeWItxk17m+JZarJup2ZP6tqu9vYuGkUav7KwZTYk6l3FOx7+hm32Q86f2IjP1t2PJpLTu0u/91KkOsNGFz3WIWoegXun85yLtrmzH3UiOOBI6DJtrOfS7JKbXP15ysVeJ8rB6YUGM4FneZ65/6bjisEqmmMm51BztSHkNWd1aimod2uW8I7vWL8YJ+RCx+wOcK+5YNysx0+J/shtLyGjFvYVmKoNwlKNfsQ+McMeCJ3bWFP1h9KJxXZcNuRhvU5ASiXCN6MSiRTIWUFF0ItIvWsMkYUSR8d/sq4iJBbAwPsPB4CHdVEWFpSyI/cjNRD+aFOpz10TzKYtFr9oXA65VXTNEjMrpKjEdOvfIEFVRGVz0jqDOD2j+SCeP9q4uFO45bj9AIKfTReig1Cv7uPbG9L7KD/zxTmyur3gre+cZgSy5ZO+McJBfH9Erci6MCiIFOcluHnTGd3eKxUWwcn2Pb3A0g8cBq/pTpFe5PEEIDhI6u/YQ6BtVXlANO2Wqa9JjjzJP287Kc3Gsa+wsOO1iGNHNaQpp60UsK3732IxocoYWyDncdFA+dVXcGQXGvOVKEqFYWEJZdvqh59zcVMDCVA
 S8toreqY
 beTlb9FfXFTIoSgFggH6Ah1atnXWtHLDqZjoXjzY/HHNhyMPCuslkTR/akiv4H7JhmPoGpdDwBNduWjCFc8ZUzWknwgW+aryanbSs0OF/aJEt2V0ze5PjuZOkYzBLlqEzbOLZRY7VoOiiX54gfuJuJLcEuwhIHBp6YHY+0AsLXCUOp3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4672709832961997223==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
> index 52b22c5c396d..792b6665f476 100644
> --- a/include/linux/sched/numa_balancing.h
> +++ b/include/linux/sched/numa_balancing.h

[ ... ]

> @@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
> extern void task_numa_free(struct task_struct *p, bool final);
> bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
> 				int src_nid, int dst_cpu);
> +
> +extern struct static_key_false sched_numa_balancing;
> +static inline bool task_numab_enabled(struct task_struct *p)
> +{
> +	if (static_branch_unlikely(&sched_numa_balancing))
> +		return true;
> +	return false;
> +}
> +
> +static inline bool task_numab_mode_normal(void)
> +{
> +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)
> +		return true;
> +	return false;
> +}
> +
> +static inline bool task_numab_mode_tiering(void)
> +{
> +	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		return true;
> +	return false;
> +}
>  #else
>  static inline void task_numa_fault(int last_node, int node, int pages,
> 				   int flags)

[ ... ]

> @@ -52,6 +75,10 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
>  {
>  	return true;
>  }
> +static inline bool task_numab_enabled(struct task_struct *p)
> +{
> +	return false;
> +}
>  #endif

The #else block adds a stub for task_numab_enabled(), but task_numab_mode_normal()
and task_numab_mode_tiering() are missing from this section. These helpers are
defined when CONFIG_NUMA_BALANCING is enabled, but have no stubs when it is
disabled.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..7ee5695326e3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -4843,9 +4844,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	if (!current_is_kswapd() || sc->order)
>  		return false;
>
> -	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
> -	       WMARK_PROMO : WMARK_HIGH;
> -
> +	mark = task_numab_mode_tiering() ? WMARK_PROMO : WMARK_HIGH;

[ ... ]

> @@ -6774,7 +6773,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		enum zone_stat_item item;
>  		unsigned long free_pages;
>
> -		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
> +		if (task_numab_mode_tiering())
>  			mark = promo_wmark_pages(zone);

The original sysctl_numa_balancing_mode is defined to 0 when CONFIG_NUMA_BALANCING
is disabled (see include/linux/sched/sysctl.h), allowing this code to compile and
work correctly in both configurations. The new task_numab_mode_tiering() helper
lacks a stub in the #else block, so should_abort_scan() and pgdat_balanced() in
mm/vmscan.c will fail to compile when CONFIG_NUMA_BALANCING is not enabled.

Would it make sense to add stubs for task_numab_mode_normal() and
task_numab_mode_tiering() to the #else block, returning false to match the
original behavior when sysctl_numa_balancing_mode is defined as 0?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/20956455529

--===============4672709832961997223==--

