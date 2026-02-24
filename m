Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E12E9B252
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB47B6B008C; Tue, 24 Feb 2026 06:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81D26B0092; Tue, 24 Feb 2026 06:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2246B0095; Tue, 24 Feb 2026 06:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA9C6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:41:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB4B7C1F5B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:41:58 +0000 (UTC)
X-FDA: 84479161116.07.FA529E5
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7F82CC000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:41:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JdOZ20r4;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771933317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTft1lZXxmebOkNzKC0YEuK2LVQvuuq00qby+pSHF1Q=;
	b=gR60g3j5syKeH4sXJQh2tuakqpnl2OwI2m/mUEwRs7BjAasEEhKcid/TtC4KqyjhAcInRA
	/5qf3XqshnVdS2DsYnIYE1xtd1ZtDBd/n885XP+J2rNs1OR4/ZbIjcisswKOCxSKitmgFo
	yukLo0GqGpP73HWsYWMaVDHflMevqBU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JdOZ20r4;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771933317; a=rsa-sha256;
	cv=none;
	b=FoSBM24MLp51LNaOJWzowrEO77VLxShsgAfl/uPgzcb1HzyOxL6chlEkGaJsxz2iM5snw+
	GTEtK3Bo4OOKAqVJgSgicnyXghrVjcVqQ902yMKkMP3xHNDIBeTqaQ50VjnzEdsbzzQRwo
	bRPwqcsuKR9m5cp+wy8devfr+VNZ/3g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qTft1lZXxmebOkNzKC0YEuK2LVQvuuq00qby+pSHF1Q=; b=JdOZ20r4MlSjK7rMTiMJ2OxC+7
	L2QAHh/fh5IduAwQCQBSIHDC4lkRFmoJtRPLftyP7wBq8snDn8UwnlNuKsagN+6NMw/G1GbmIRh76
	heIKGuT8XwFLv9n/nkI0nyt+dThDtZ5QAl8dsAsyKmjNV7sJub48t1ABxAx15PvgGNb6XfROkaAOk
	n7g4vh2ej0iMT1alyh4Ilo4rsdVo97S6+AdJt718qtB7Uiv6ZGeLwLN58Cq1tCkZiIpot84xL9cjh
	XubLC1xIzTucthiO94ACfjipcj5A16oT9qO+GiiPqARxSzJNhDTWkixK9HTOKTG9FdtWg9e0+V1Hz
	xu33W8Dg==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuqnZ-000000071Hd-2rZQ;
	Tue, 24 Feb 2026 11:41:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3DEC9300BDE; Tue, 24 Feb 2026 12:41:52 +0100 (CET)
Date: Tue, 24 Feb 2026 12:41:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Message-ID: <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
References: <20260224030700.35857-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224030700.35857-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F82CC000D
X-Stat-Signature: 4ao8as5tkzq6many31d1ty3jcnftrsbk
X-HE-Tag: 1771933316-662192
X-HE-Meta: U2FsdGVkX1/3E2ivu8dBTN/g+6R4qKPtZDv0PSBZnaXpX5TRaqvdTWdXLSC3qNuM09OY3w5roZIkXy1jKgCMZl1JYgNoB9CLGWoTBkMtWyUgDTcaRgsU1Com2R7TI2z7U9Xw9W3EEaCRTpSg9/0ElsgHQ59yD3Aa+o6F+ZeosuJU7UGbUL7wsavZfN8C3Aqawk6r1n0JiBWVPrAjH777Ee3L4VxpElLwSUAbhSwxd+09lwxZuVpRLAJa3jZhAb2BeDMa3WZoVr0bVUZkwo3h9c8oaN9WH6x1ERf//ph7oui+hF1xg4nFcSicutqd7G5ADtD0cZcxrI0J8oPo1AN1mD6H8i0ssiSxUcq6ibIPa4oPd7EnsZfyjQh+wrwAeqSB1YTuAFznOOozOueuRW/Q/uzXPyB/2NGvx929B8BDCvi1h0dCeS5MQwuane9E5xf5KbsYEhFWrdxuUQCCN1aas8xkEibTB5onm5ZiVuH0Yo3tC8a87RwrAi+WWoNrfVvSTg+ge7ZmcxWjWWwIi/C6cKT+Uy0+lyBvvu5Tt9TVZIXKmDs/bSmMk6777ADuKhrbg1SLM4FZsAg4PphGo93Ai35Dt9wiqk9/adeshhs4v/LUViz3hmXUEVsBolNKBQ+HbQhQC0omGYd6IahLHFvh42n4fsSdD0w44hMctPVD+Ep+hbz8IbPG6zW7sZw4MUdj0mqZIXdDqNqBC5rnFnEypEVglMGaO6TN7arjf06MnQnrHYgnkMvO5NAaDkJWDLqnzeSSb9WNfBD9qlhvhNXVl8NN1VxO2jRi8fGXoVzwgj0GDyO3qBkAzIvxog1VUs/duK8olKwonpBR60JpfdxRL/pyuysmUItxvvlA0BxrT6Y0F+SNnV5y1oRnRMpXjo9JomgfRDQqzmboXT56m7FrBgM4gF0AYDuuzlqrNOoo5qvrO1GuIgs4Yk2JgfuimVPto88f2AVakOpIQjU/nvt
 hjw7YGB1
 yNyXo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:07:00AM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When freeing page tables, we try to batch them. If batch allocation fails
> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
> batching.
> 
> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
> process is unmapping memory. IPI broadcast was reported to hurt RT
> workloads[1].
> 
> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
> local_irq_disable(), which is also an RCU read-side critical section.
> 
> This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
> period (synchronize_rcu()) instead of IPI broadcast. This provides the
> same guarantee as IPI but without disrupting all CPUs. Since batch
> allocation already failed, we are in a way slow path where sleeping is
> acceptable - we are in process context (unmap_region, exit_mmap) with only
> mmap_lock held. might_sleep() will catch any invalid context.

So sending the IPIs also requires non-atomic context, so change there.

What isn't explained, and very much not clear to me, is why
tlb_remove_table_sync_one() is retained?


> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 4aeac0c3d3f0..bdcc2778ac64 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -251,6 +251,8 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
>  
>  void tlb_remove_table_sync_one(void);
>  
> +void tlb_remove_table_sync_rcu(void);
> +
>  #else
>  
>  #ifdef tlb_needs_table_invalidate
> @@ -259,6 +261,8 @@ void tlb_remove_table_sync_one(void);
>  
>  static inline void tlb_remove_table_sync_one(void) { }
>  
> +static inline void tlb_remove_table_sync_rcu(void) { }
> +
>  #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>  
>  
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..2c6fa8db55df 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -296,6 +296,26 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>  	call_rcu(&batch->rcu, tlb_remove_table_rcu);
>  }
>  
> +/**
> + * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
> + *
> + * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
> + * broadcast. Use in slow paths where sleeping is acceptable.
> + *
> + * Software/Lockless page-table walkers use local_irq_disable(), which is also
> + * an RCU read-side critical section. synchronize_rcu() waits for all such
> + * sections, providing the same guarantee as tlb_remove_table_sync_one() but
> + * without disrupting all CPUs with IPIs.
> + *
> + * Do not use for freeing memory. Use RCU callbacks instead to avoid latency
> + * spikes. Cannot be called from any atomic context.
> + */
> +void tlb_remove_table_sync_rcu(void)
> +{
> +	might_sleep();
> +	synchronize_rcu();

synchronize_rcu() should end up in a might_sleep() at some point if it
blocks (which it typically will).

> +}
> +
>  #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>  
>  static void tlb_remove_table_free(struct mmu_table_batch *batch)
> @@ -339,7 +359,7 @@ static inline void __tlb_remove_table_one(void *table)
>  #else
>  static inline void __tlb_remove_table_one(void *table)
>  {
> -	tlb_remove_table_sync_one();
> +	tlb_remove_table_sync_rcu();
>  	__tlb_remove_table(table);
>  }
>  #endif /* CONFIG_PT_RECLAIM */
> -- 
> 2.49.0
> 

