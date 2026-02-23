Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E90EEA4FB8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5246B008C; Mon, 23 Feb 2026 08:02:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F156B0092; Mon, 23 Feb 2026 08:02:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423BF6B0093; Mon, 23 Feb 2026 08:02:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31B6A6B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:02:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8E27140143
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:02:58 +0000 (UTC)
X-FDA: 84475736436.23.41FBEE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 077FC4000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:02:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jkG6/V+6";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771851777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a53a4jiZX+4siH/+N7ov7PbqbJocA0mCy0U0f6hjhgY=;
	b=QY+6uMDfU6OcyFWW2WHEDL/xKszu4eaXraQBU5AWMbpD7Dkdfo98FzRdkrG4dedTQCJJtp
	akVpGMcwnLqDqvd/8jZcKq7QDoRKfRxikvQkobi6ZStGSay8TQtYYFKZepKlm4zbCwiib6
	xfL+t8U2b65qfJBhUMKKlYxk4au4LAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771851777; a=rsa-sha256;
	cv=none;
	b=2cZsAXErYTRS6g8OqqKQTGmPDAeWoPFxrceLhurLJ48EcyYZejdzb9c41ralkz8BCQBC4m
	5KE5UvsxP1RhHjb1fhse6jEpyDQlYnhujHxJAzfwxH3rHUv0XZXDSzP4dZmcBGHdgVJ2Fq
	V8SNoa7NLqg08yFhbtmkeshexJqvqgI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jkG6/V+6";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14D5544454;
	Mon, 23 Feb 2026 13:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE70C116C6;
	Mon, 23 Feb 2026 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771851775;
	bh=ptRUSre2ZAhwCRyTmqafxxaRaPN+lKYGNkEB7a3hP9U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jkG6/V+6CCoPx7QwGGY9LjtWnT3Cx0CYRQlMmmzR0dlwY85ydB5NBfBqJVlsQ8Jvo
	 XnmHrTgR0m8vGgr7+JNzCaSi7tYRFoi2oP8HfTjyNa3gBkJawjebb3bfRm0zwDUaYq
	 xUGP4O3sa5d5ql/2minx/yt1S8tJRHns70MApU30iiXLsCH6Rt+b1hgtq3AfvYdqmM
	 139yVFJe9vUKEZZDk0wYn9uf4oc1GUhfL5cMWtOI0bz/qu5KGof0Ftw8khjLBb5TJz
	 T33weFbOYqqoVo0JDNfsSX6DzyOPSuqG/eY48ouFCRQgSM/94O5XwTwCKK68kDPNb9
	 snkjHk91pLUaA==
Message-ID: <b7570a41-9bad-403c-b2c8-108393589079@kernel.org>
Date: Mon, 23 Feb 2026 14:02:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, aneesh.kumar@kernel.org,
 dave.hansen@intel.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@gmail.com,
 peterz@infradead.org, will@kernel.org
References: <2a6c4e62-1663-4a98-9adc-406a6a1ebfd3@kernel.org>
 <20260223125826.28207-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260223125826.28207-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: sbw1njftibmjm6xdmtwto16e6f777c34
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 077FC4000A
X-HE-Tag: 1771851776-116651
X-HE-Meta: U2FsdGVkX1/TzJslM9D/LNe8WnyLbaVsVk3pEF4MgnXCYw7vNaWF3ci/xTBkLswZv0Ej0lSKtBvZsqx/JJY6IueoMAuMF7YQUpXLkP2vlhCP/9e/XN6rrF50bDkBGPROt55m9WX73+3MBB6S42+6Qj+Y8TUIiXybOr3HTw672RBQcMQc8f0ImsLJdX8r+jKxEpzhlC4Jre2VOl2dyyeuDESW/BovSvtGvDRWarMeZ6/ctLtMpRzdvb7I62Z+am3oIm4mzqvduC2tK9IZlSJ66ISesot9xxJZtoPIaDG/yyKQXCqXJVKBjeJBlAl2ehgxopN6kRkqruONG7Eqzl9Udf+3Ou/+qudnlbhK4nrCMI1n3UNVZDqLA5GG90o874HUR90Un2QSfzYoe6Vr3+PalBQZZFf7yMRQEmxIah6JL46JtTzoPoypVTe/S8ERbLSeeMyyij63fRCwzY4KcWqT1w2l9PSWsmMY0RRGVImQy8St/CG0PTEf5Fc72I9a7yLPIIzI7LU20u+a/rrGE9DJYTSOJJ8sfRjzWa9qJrgYfXjZkOjI2+ZYI7G816lUGtKV+q5crEQ+UGBefB/EjFsjsJEUHmY0LCYW1iPoJvMoLVr+UlGNL8uLl8NFhNPKv4uhcj/Pa2lNRHKa515Ejl+5SfWNKepjOBSvekcITsRdNwS9OFebNThjZDayHqbYt7P2UMCs7Gi/k5/qxXkrAlJGZEuFuN42bP2nusc6NVPfQyHb4JxxmaikH3QMeZQ1CnM1VVi6JzZNwJSPLmEGtD2yWOHoTguqDG44zN7jEnyvVVph7w6r/MLh13anJ9f/7PaZYOD/koeZdInXDaL5YbybzOAEn36Jmgds/GPXyR15Vr41drSWDF0SLXy149cjalGFbj1wKEPZMLgVjlmUW5nCYMwoFh5jk4994j0WGP6W64vh2h7HeQW1J9QwMpgRTe/0ena1EuRyWezA+q98iMJ
 uezprIxr
 6CWPz5yEd8FcGr41MaZUkdDpFLCuSkEWuayY7WsLZl5rlriEF8SdcaLYVU4onUH5mAz4b4qLrQnWLCkvpvcsolqxTHjHSXW8LtEaFGDgHHFuvn/gv44zSj+CxdaqD1o/7mvkOi0LiK+yqvEp7tLYN2n8uoksh9VqUbdbRzgAzA/5dPaYl39IF2Bp+xEgwuiXkhM94C6J2C0/1fj5CffxDXM2/357h0jHtJsKYX05L5/9yfaE7vb39RMjIMkwCqdIFoniA5d1ebFOHSqzQCOdcZ+MOvv5zSNviKGhCCT0rBNcfiVftfBUHhcG3IB5V6nM45YfSs6nMolYvY1sCaIR1964j7XvPBoOj6fz83BOy8zXiT9JsbMnYychfFwbDNvzVzOONOVPtxThpCZKHmfUK+F+Y+lyMfinv6VNhBBoolPwEhxk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 13:58, Lance Yang wrote:
> 
> On Mon, Feb 23, 2026 at 10:29:56AM +0100, David Hildenbrand (Arm) wrote:
>> On 2/23/26 04:36, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> When freeing page tables, we try to batch them. If batch allocation fails
>>> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
>>> batching.
>>>
>>> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
>>> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
>>> process is unmapping memory. IPI broadcast was reported to hurt RT
>>> workloads[1].
>>>
>>> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
>>> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
>>> local_irq_disable(), which is also an RCU read-side critical section.
>>> synchronize_rcu() waits for all such sections to complete, providing the
>>> same guarantee as IPI but without disrupting all CPUs.
>>>
>>> Since batch allocation already failed, we are in a way slow path, so
>>> replacing the IPI with synchronize_rcu() is fine.
>>>
>>> We are in process context (unmap_region, exit_mmap) with only mmap_lock
>>> held, a sleeping lock. synchronize_rcu() will catch any invalid context
>>> via might_sleep().
>>>
>>> [1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
>>>
>>> Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
>>> Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
>>> Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
>>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> I think it was primarily Peter and Dave suggesting that :)
> 
> :)
> 
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    mm/mmu_gather.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>>> index fe5b6a031717..df670c219260 100644
>>> --- a/mm/mmu_gather.c
>>> +++ b/mm/mmu_gather.c
>>> @@ -339,7 +339,8 @@ static inline void __tlb_remove_table_one(void *table)
>>>    #else
>>>    static inline void __tlb_remove_table_one(void *table)
>>>    {
>>> -	tlb_remove_table_sync_one();
>>> +	if (IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE))
>>> +		synchronize_rcu();
>>
>> That should work.
>>
>> Reading all the comments for tlb_remove_table_smp_sync(), I wonder
>> whether we should wrap that in a tlb_remove_table_sync_rcu() function,
>> with a proper kerneldoc for the CONFIG_MMU_GATHER_RCU_TABLE_FREE variant
>> where we discuss how this relates to tlb_remove_table_sync_one (and
>> tlb_remove_table_smp_sync() .
> 
> Good point! That would be cleaner and better ;)
> 
> How about the following:
> 
> ---8<---
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..ea5503d3e650 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -296,6 +296,24 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>   	call_rcu(&batch->rcu, tlb_remove_table_rcu);
>   }
> 
> +/**
> + * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
> + *
> + * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
> + * broadcast. Should be used in slow paths where sleeping is acceptable.
> + *
> + * Software/Lockless page-table walkers use local_irq_disable(), which is also
> + * an RCU read-side critical section. synchronize_rcu() waits for all such
> + * sections, providing the same guarantee as tlb_remove_table_sync_one() but
> + * without disrupting all CPUs with IPIs.
> + *
> + * Context: Can sleep/block. Cannot be called from any atomic context.
> + */
> +static void tlb_remove_table_sync_rcu(void)
> +{
> +	synchronize_rcu();
> +}
> +
>   #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> 
>   static void tlb_remove_table_free(struct mmu_table_batch *batch)
> @@ -303,6 +321,10 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>   	__tlb_remove_table_free(batch);
>   }
> 
> +static void tlb_remove_table_sync_rcu(void)
> +{
> +}
> +
>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> 
>   /*
> @@ -339,7 +361,7 @@ static inline void __tlb_remove_table_one(void *table)
>   #else
>   static inline void __tlb_remove_table_one(void *table)
>   {
> -	tlb_remove_table_sync_one();
> +	tlb_remove_table_sync_rcu();
>   	__tlb_remove_table(table);
>   }
>   #endif /* CONFIG_PT_RECLAIM */
> ---
> 
> Thanks for the suggestion!
> Lance

LGTM, but let's hear other options.


-- 
Cheers,

David

