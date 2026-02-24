Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79862EFB7E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63C26B0096; Mon, 23 Feb 2026 21:09:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E796B0099; Mon, 23 Feb 2026 21:09:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31496B009B; Mon, 23 Feb 2026 21:09:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B00B56B0096
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:09:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A2B513AA9D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:09:46 +0000 (UTC)
X-FDA: 84477719172.06.4129E5E
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0A1340003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:09:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r1AsSxEi;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsOHJFJbnSTxPZLSbT4LkMBTkNe2O/zQhx5vUKRpKF4=;
	b=hXhvkLPwgVUj9XeMKFVYxqCXkYztsO4EoMGwU6aVxYxPiLI3qCK0dVXIGEHyvoIZQZqynU
	mGiqMpLXc1k7It7CtpC4IEIJGsEHGZAi20Tptx5NwikNLG9pLqyO/a3KO24/mJc6xEmdKh
	MsMoLytcY2cADYTIaVIRSl+Ngw9xzmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898983; a=rsa-sha256;
	cv=none;
	b=1Zbee7jQw7vLRMLv8GQOZoHywhdFE21NrSoSltusy8c/Z4z00ZoyeBO32ibHfpIBzt8z3K
	lFQbyVw1fwx9Mj8VGayBNQqD81R9sjWe7iIrg/B+J9FJhzj8E+j0XOmn8ixpYYCELg6mbv
	CgyZfU75p7kv2JwGS/jUofYiwqY4G6A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r1AsSxEi;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <f44fac08-771f-4619-b8a4-6ea740df424f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771898979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MsOHJFJbnSTxPZLSbT4LkMBTkNe2O/zQhx5vUKRpKF4=;
	b=r1AsSxEiipWjSEiJDqxsxjbymAD2ieCd5isZWeDQIQEJ4s/D5zIfTHoZQQ18x5YpcHtvJy
	weiniOLhq/1vfl2Tn4Y+zxwjjyGgn0YOreYsPY0MNVI6sw9FE8BrBg4ReKO8tTXUzhmgE2
	vi3pC+gTkxw7dIgPN6pMx8ODLDFtgUc=
Date: Tue, 24 Feb 2026 10:09:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mmu_gather: define RCU version tlb_remove_table_one()
 in CONFIG_MMU_GATHER_RCU_TABLE_FREE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
 "David Hildenbrand (Arm)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, peterz@infradead.org, npiggin@gmail.com
References: <20260222004512.839-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260222004512.839-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: j1wtatf5t1cjh8rdqzgs6j39ks94orbk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0A1340003
X-HE-Tag: 1771898982-384509
X-HE-Meta: U2FsdGVkX18TjtvrscHgP1YpJQP+9iaY5o10tCKG6IT/us1mwU+HE7Wd5uo4hWmGwn0UXhSEUX733kFKooYjp3SVUAPnT6gZPZYv6z76V2+eFIlYmi6Ua+eyEPz+rL4n95oXxwDorv4BN7KDFUoddknnaA/yrWsfQcFdg2nGBACMKFj3AdxUecUWnr4MOwoLlw4whzAH7a3P9FO0ceT9ItzU5l/y3c7zLVcx6r0c6AHHKo5p74nysU7x8c5HxcsRjgqJvZrAMS9bwmfNAtVFtJ/Jx05A6Q2gBk0bI9vsxL6dGQ75YqKWiAFelHJCFQX0LrTgihkDE05dYXKSvct0S8qLfs23PJDAnV4n1A4L4yy9iqjjAOQyFLGxTbvNUh4L/cnYoqDfLXO3snWs1xQQZiDVvC9CNqgy4DD36rCpZYmXJa25oRPPcLjqgyWhmvuzcHwutxwNiDv/MGMkTeG0m0lk35PzHv9pq7dO8peJ7cVAyorMTsz8fwihZ/ASQjQyygEB2AbUcTXERbyEbhtV54ojrNrJ481VFRTC/Flcw4WiRtQ+egEhBETU0hx0zxW8BXg6pF44fHz+jCQPiXUHlTABLJGKWvJzMbKbHGYaGlevtzrxhYDP7LyExEgSPkeDpyxDcxk7GxO3s8FaIQp4f7aYiVHERd9gbEm6UwLqRqZcEn+TOS46hThHNeB2ZCii4r3mUge57yXaGwNK+9QArwf2FByAizGhFWoB6vd9bZk7zKOLed3DxKjqeG96KkTzBFfFYlz0gj3A4KON2rpsxZMF5DCi8Fnu2BDxLpOknrWzAsQEKuJCAT8lRAkTYtYxEKq0GyGrH6HK3cYYDn5KzNp5wjIA9Kw6iIGVY2y20/0ncWhhVD7sypBhcQevo8XZpGTiQ52wiz7nM7gXY/hTUHfULaKcctzygtPr84dHSmga9ZfJRC3iWtZ4duSvjT0M87mn9aSzsT4ZMJkehM6
 u0X73kvl
 kSEzJWzeWTB0wZbw4QT0pa78JL+lDiZ4KrF1tTQZ1QFRsqoK4cFEOLQPtSyXLWcdMho3A0Y14tlpoSVG5yO2QqlQlhV9LCTBC5Zxzc/iarbRz6+aItRurTa8JPo74pjAEemzOaFIvEhD3nXFrn0/jQXgXj/qAZ9WiIh1gTggEo5i8h3njTRhfzDR2VvkOx3aVtxZoRf0Zd8WqgTuMT5locGn0uSKVvfLAZ98w0sPhsxZHUHeDLYA1Ro+z1cLTGuB53iG7sA2Pq0B+FfOG0uL4rg3fzrI3wz/ocNljuzmSPZrNxO1llhvY3bv/by5B5BtLbLBKLyTgAxlnHiCmfYDkMryZw77Xg+Y+SPjH6F4miDvCimnfAsl7uFdxg5IQe1kjxOUhSPGPMiamfADvBR/n4I3U0yXFTodAndT94U3e7YDw/FyIygyxUJOWbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

On 2/22/26 8:45 AM, Wei Yang wrote:
> Before commit 718b13861d22 ("x86: mm: free page table pages by RCU
> instead of semi RCU"), the page table pages will be freed by semi RCU,
> that is:
> 
>    - batch table freeing: asynchronous free by RCU
>    - single table freeing: IPI + synchronous free
> 
> This commit introduce a RCU version for single table freeing to support
> PT_RECLAIM. While it is not necessary to limit the RCU version only in
> CONFIG_PT_RECLAIM. It is reasonable to asynchronous free single table by
> RCU if CONFIG_MMU_GATHER_RCU_TABLE_FREE.
> 
> This patch moves the definition of single table freeing in
> CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version
> batch/single table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

Thank you for doing this, but we can't do it right now.

See the latest version: 
https://github.com/torvalds/linux/commit/9c8c02df3f8742f6db927e787ab971fd0b5ac08a, 
when the
HAVE_ARCH_TLB_REMOVE_TABLE is selected, the pt_rcu_head member
cannot be used.

Thanks,
Qi

> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: "David Hildenbrand (Arm)" <david@kernel.org>
> ---
>   mm/mmu_gather.c | 51 +++++++++++++++++++++----------------------------
>   1 file changed, 22 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..6c1cbd9c717b 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -296,6 +296,22 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>   	call_rcu(&batch->rcu, tlb_remove_table_rcu);
>   }
>   
> +static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
> +{
> +	struct ptdesc *ptdesc;
> +
> +	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
> +	__tlb_remove_table(ptdesc);
> +}
> +
> +static inline void tlb_remove_table_one(void *table)
> +{
> +	struct ptdesc *ptdesc;
> +
> +	ptdesc = table;
> +	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
> +}
> +
>   #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>   
>   static void tlb_remove_table_free(struct mmu_table_batch *batch)
> @@ -303,6 +319,12 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>   	__tlb_remove_table_free(batch);
>   }
>   
> +static inline void tlb_remove_table_one(void *table)
> +{
> +	tlb_remove_table_sync_one();
> +	__tlb_remove_table(table);
> +}
> +
>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>   
>   /*
> @@ -320,35 +342,6 @@ static inline void tlb_table_invalidate(struct mmu_gather *tlb)
>   	}
>   }
>   
> -#ifdef CONFIG_PT_RECLAIM
> -static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
> -{
> -	struct ptdesc *ptdesc;
> -
> -	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
> -	__tlb_remove_table(ptdesc);
> -}
> -
> -static inline void __tlb_remove_table_one(void *table)
> -{
> -	struct ptdesc *ptdesc;
> -
> -	ptdesc = table;
> -	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
> -}
> -#else
> -static inline void __tlb_remove_table_one(void *table)
> -{
> -	tlb_remove_table_sync_one();
> -	__tlb_remove_table(table);
> -}
> -#endif /* CONFIG_PT_RECLAIM */
> -
> -static void tlb_remove_table_one(void *table)
> -{
> -	__tlb_remove_table_one(table);
> -}
> -
>   static void tlb_table_flush(struct mmu_gather *tlb)
>   {
>   	struct mmu_table_batch **batch = &tlb->batch;


