Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9E660A2612
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgheBFY3
Received: by kanga.kvack.org (Postfix)
	id 6DCEB6B05BB; Tue, 10 Nov 2026 10:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DAA6B05BE; Tue, 10 Nov 2026 10:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555AB6B05C9; Tue, 10 Nov 2026 10:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDDB6B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:15:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34AFB140922
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:15:25 +0000 (UTC)
X-FDA: 85419558210.22.BB39E97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7A3EB80014
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:15:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgheBFY3;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDKPQGe+tcB83Gs3w6L12JnJZcjoeeHi9cz6bG12yVY=;
	b=cJH5aXyzqTCScZSWj6qvWQdBd43r8M2/79Y/gNOXDLGpwUboIbymVpYalq8pe1WL89NYVw
	EZ4RFJSh/ht0F1TdIevSmgkMkrR/u2928+Liq23CIqp129vTCMj3FGH6+ZRFiGEQ+bhuqk
	MY0vkGx0Jq4MDgm3np5VZQRvhCCl1xs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323723;
	b=V1E1Xgf6hVTok5NVVauA403b4Dz07I5ukg0VsRMj5ykrqCDyITIVsxgwSc6yTvqauM1/Ki
	LMUyR5PqUobiVR4DNT0ow5lBErnwCsC511nNiiEGb/tjtEvs5m97CrW9IIaPToGfge6zTk
	fO+6rEy69DlIQ+1ibYD3QEZvsjBFmF4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FgheBFY3;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F93C44842;
	Tue, 10 Nov 2026 15:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7AE1F0089F;
	Tue, 10 Nov 2026 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794323722;
	bh=EDKPQGe+tcB83Gs3w6L12JnJZcjoeeHi9cz6bG12yVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FgheBFY3GQOc/VIc4WFDSA+6EXBzYHSGFEpP2p9ihpidCpJN1y1AGj3uWpUGA2atu
	 LjVtZg5CrpOdgJgxaI1HSlchN3kJIeZxl4qAbVDtpZmqVvq/kDbGsBRAkp0LnanRaH
	 d0YlnHjI9Eq8DFMW4nFOY9naqiPWRetATDUUK9KkKVi93MJzjfAY9g8aDOXvZ7pyfJ
	 ndYnyFpUyKD84G63bnGdwAnGS+HxAg+aHiTsAa8M2RmgDV6nGNDJSC2GV0KlCUsN86
	 GlpeEG1Bv09QsznI0CtSahkW+zo+z0IrlchZUgwm4l1oB+DTtw3w7PiYSm4Jrlhrc4
	 AHOO47KqfLGrQ==
Date: Tue, 10 Nov 2026 15:15:09 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, 
	rostedt@goodmis.org, bsegall@google.com, mgorman@techsingularity.net, 
	mingo@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, jannh@google.com, 
	pfalcato@suse.de, hannes@cmpxchg.org, osalvador@suse.de, raghavendra.kt@amd.com
Subject: Re: [PATCH v5 7/7] mm: use VMA flag helpers in NUMA balancing
Message-ID: <avM0EbXsE7WyIPJE@gremlin>
References: <20261110150446.2452975-1-gourry@gourry.net>
 <20261110150446.2452975-8-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110150446.2452975-8-gourry@gourry.net>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7A3EB80014
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qz6moeg9wzyhsg6s317jim1dffxfyjuj
X-Rspam-User: 
X-HE-Tag: 1794323723-896175
X-HE-Meta: U2FsdGVkX1+hFwrgSEZP/+raPNJRPfKSG/nAA5ABWmyRV21Cyeq4U3Py9yKQK7g3E7jMWQQ9ZFkYoTtZSSiBDYKPuCwULOdHCkC3lQ95aLAt2zbN/LP5aD3Dwt7tMYP0F2bsfauiSAjWIjTC6yV43xxv9MdOw+zZ0AAiHrS+LcZn2CglQ/sOnGjOD6mbX8G3LB19HhZPO0rlLCkIx7v3ohkglBEKSUP2RqxvHAGEmnQXjDipAyxy4XGBoo7CJZcAupxOhJWXtE9ZhwXgpy0Sw+WWcHAuXKFSumnNmKEE4HO1UpjtuPzW1kiCfSAh9D4j0d6WwBCIbHAJW57b9/5qO6eU94O3Ifgugllwv58Z5mWySd8jjppHKZwZLWZh4PsTgQ3PC6mbt1XsFu0uLCarXqGHXliJXzydXFmuTdWNaxa3BhFdFLKjVq4kczMqM0Kk3W7aPIb+HIYEFE7puEUAyRR5D0R8qTcwfZI0Uu/x9ufzhTEEug77tgJd+PGsw6gnu9wLxGQ/wjJ3kJ2lRBxvGlCbw1juxUUQNBO3sZjH84eRmQzsMpEPYjLuKZWVa/I2ZBtOXqoo4PaUJvXpiVFCVS0zGVAh9ipFasf2prgnqVqzkzVLdzrq4a4/JzFt0FVSp2G/brSUrlgml9YZx5OaLe7LI638DMQ6em2JIJnXfSnEq4b0oQPPPdrHq2rklAKe4T+3a86kpa1MgIQc9lldR9fsuFq9T2B/dVPdhRE7XM2EcqTR1SZvVJ/0Xa8iCnOYWWxARJNMnphCRX4Ko6v0a5w1HruRU712tfU4Bvtf4+5GvLFkpnaA7sqP46eTz79sxEfEFCypHUTEgzshvoMHM7T/q4NS6wdG4KdR5QZIHn+/rMrImA4zGpaekk3MHNAiMHJV+dLWssHQycYtN+FqL6/civODpIZaqdPAUPoVFIE3dK1K+QkeNg118zxynFwwUAZOVPh2I+pe8isIHPX
 BCtPQFSQ
 jYFvganN6uidYKrLZ38wIipXu2wMfefjjBQDavWGUV3w8kU/A9vM5sYAB7TW7d9MEXLZY8Uj5TxTsp0JifUEpv2It4Ro0R7B7ZWKRwe0EvWeHvVAolNYjtLrZOq232CJLOHtxWwVbGRetzpP3nwxVG7/0Fv95J1xhq7e+5socuqt8C36qje6e5hD6HMPntbiLd1/dClndvJTvRO6HHIpFfk2CxTA7u6p+WwBtBZ+EkuD7c+riwq2v5E3ViTuhUieDUzchTdiF4NoJ0ySwg7HSt9A6YdaZv6A5UeySHHIbVitWhEr/6pT3o5wjbeC9FtARg15hBswF1eM1FgXAHjyPRDkr7f/7EZPfHFkt9apfglaN28E6jcnPSJJP9HMHdTtAx5H9Ewvz743nkLBHSIEMZgRavGL1oM75n1ZI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:04:46AM -0500, Gregory Price (Meta) wrote:
> Use vma_test() instead of accessing vm_flags directly in the NUMA
> balancing code touched by the preceding fixes. Keep the existing flag
> predicates unchanged.
>
> No functional change intended.
>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>

What a legend! :P

> Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
> Assisted-by: LLM

This tag is no longer required, in fact I think checkpatch should moan about it
now.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Of course, LGTM ;)

This clashes with my latest VMA flags series, but the resolutions should be
trivial.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  kernel/sched/fair.c | 2 +-
>  mm/internal.h       | 2 +-
>  mm/migrate.c        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 279bf12b74b64..cf3e3657e9533 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4378,7 +4378,7 @@ static void task_numa_work(struct callback_head *work)
>  		 */
>  		placement_scan = balancing;
>  		if (placement_scan && vma->vm_file) {
> -			if ((vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ)
> +			if (vma_test(vma, VMA_READ_BIT) && !vma_test(vma, VMA_WRITE_BIT))
>  				placement_scan = false;
>  		}
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 6e7c247781a16..7fc34d084697e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1248,7 +1248,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
>
>  static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
>  {
> -	if (vma->vm_flags & VM_SHARED)
> +	if (vma_test(vma, VMA_SHARED_BIT))
>  		return false;
>
>  	return atomic_read(&vma->vm_mm->mm_users) == 1;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 50a0a2e11a353..796d98d1c116c 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2715,7 +2715,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>  		 * See folio_maybe_mapped_shared() on possible imprecision
>  		 * when we cannot easily detect if a folio is shared.
>  		 */
> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio) &&
> +		if (vma_test(vma, VMA_EXEC_BIT) && folio_maybe_mapped_shared(folio) &&
>  		    (!folio_numab_promotable(folio) || !node_is_toptier(node)))
>  			return -EACCES;
>
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

