Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064DBD1A631
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9E76B0088; Fri,  9 Jan 2026 09:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64DD36B0089; Fri,  9 Jan 2026 09:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F2D6B008A; Fri,  9 Jan 2026 09:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 446A66B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:11:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D2A1D1BF35
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:11:53 +0000 (UTC)
X-FDA: 84312614106.22.1563DE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1DE8B40015
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:11:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FH//Tu3D";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767967912; a=rsa-sha256;
	cv=none;
	b=O9kS7DwrM8xuzT86lhzx1UkaXvztoTOXksRr/YS1KAGttTfo9UbcE9Q6s3kMjC+ImBA0BX
	hg3BTMUeCReTrj/xwObNXrLT/O4BPAmW/bjXBb2oROrJS4Aix21s6k7RQWiKprVLppR8jU
	9SQRZC4Y7gh6UAXJWMpZRd+4q7oL5a4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FH//Tu3D";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767967912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGFOKSLKPC0nFB5ssRyzydPpi+vE1fgiQbSa+3mBKC0=;
	b=fXp4kbT3u2atNvLOKubUWDiRNUB88Z9QnwDey9SJ7x5zD9DQSvWInA5hMlpkujbLeHd9Gl
	dQ3YESSchd0eRTox2AHMrwwIqv+IKIy/1UL1eG+vUX2YQwYwvddErsbLcDtpWWJ7HWuMp3
	qWG62rH57QarK3pioUNK+NmndmVsKKA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18F9543B7A;
	Fri,  9 Jan 2026 14:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7695C4CEF1;
	Fri,  9 Jan 2026 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767967911;
	bh=CdGScel+GqgAXknTQg/2/WjRhWNPeJQzkNl75YgQGmk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FH//Tu3DNmjALm9gWWlfNBdkLe455FVzeLixSksG8giXEOXMPuhYyrfm2Wbx8fzud
	 qE54HHMhjm0yb7vQAwMKbx07D6NX3pFJDjezm1taKkwgnKZaAMCfF4e17RIKnwiac+
	 DrjxTNlUcwV2tDrXqXydinJyPXU6jm0L/VAOq8KQlS/SAzwsP91VPBk9KyQb1v0Igj
	 ATLVeu5ttie+rfclDmQCnmegLLbaShWERe3T19ODmVhAOHUz1WW2Yr1SThfNa7CysB
	 U67T8zGku2JgOrCv6S4TrMQY8g2SSgAwMQqyIbDEKnBMlnGGoB2H7ULorOVdCJFm+n
	 Ei7WBzkYC52EA==
Message-ID: <253140b0-c9b9-4ef0-8b36-af307296519b@kernel.org>
Date: Fri, 9 Jan 2026 15:11:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@intel.com, dave.hansen@linux.intel.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
 <7472056a-3919-429a-845d-c2076496d537@linux.dev>
 <9b1cb571-99df-44f8-8c0e-8e9bc3f6e8d5@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <9b1cb571-99df-44f8-8c0e-8e9bc3f6e8d5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1DE8B40015
X-Stat-Signature: re53fa551g4y53hen835hha87gkmu44t
X-Rspam-User: 
X-HE-Tag: 1767967911-590882
X-HE-Meta: U2FsdGVkX19lMpkwdI1ljJhDIi+KpMjBkqGVPtoOTiQsqL1/h/vwl9q1jTJJ8nC9Mrk2earcyG/HLDzXfE3rGonO3uCJNfq2tuu5FmXdlA8ZvFBDhs0xL+0Q8rSjNctlsR2PqalwWbFx/sptjva7fQ2Iz3gV0aF+XoHNRk5m/yE1cbPsfWIj+C/qYmq0KHdcsVDG2aBDnejkf5nqsyg9qrZ/KnmV+r18LzMibkFcoIqCEMuKV9Figd9CVJYeQqTliN1spMH4YYqKKxvzN8xn7pB8qK5BcNNl6swbwMXnmjnxgfCBJw+LtZiNwW9+X/IB8tQSGQ7aAxvkeZYLuBwLt9R1AxNdvu/t/Xfk+KxzTVdIhUqzdecLsyExyqbsMHPZbTZW6queNdwjTXn3WIWRbBlXJ7kBpRj8qxiIl099Hg7iKj2B4P1IDW1np8uXMRp83H6K+2yVPxWNaKksO875WTI3awK8I6xtXqz+QE2Q68HqZdiuql0A3Rp150hGLgvREaq8565FpyTn8dCWqTdavR4opaWcil+5hoJtqPotuC0AslGQ6HJXFW5so4PjH7+ftox5JzLzyxZTlJp8LPzw9hO72hLj09bacT9aEZjEupgd7KwFZrD/co0ENLnGAU5DJWFxC/4KwGwCYID1alUQxexsrOZpxqS/T0Q8YR77uQgO99hEG4r3aq+GjRDArFfi/butk8AaXFCn48wKon/RAobxVjR6HyAnAx3Jek/z31GRfq1Nk39ieIZBJ8KqgVMjRivP1cb4lPGXuWtn6PabSrFY97lZ2lvm9afQxRUirjiW93t5qqJGrk22JHY6g9Ij1mEkmprWJdJyRTZbFwgi0KN6bq5GUo5XO5ubzNMnUatBfuKRCb+eJN5AWQS5LOibgjAM2EaWAvMH1Y9pTQhOye7Tdckby2GmCjeaNS8useA2m+Xw8iseLV9x8kvILBaBrfRp2TThHjrxdP5hL4w
 Jqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 07:37, Lance Yang wrote:
> Hi David,
> 
> On 2026/1/7 00:10, Lance Yang wrote:
> [..]
>>> What could work is tracking "tlb_table_flush_sent_ipi" really when we
>>> are flushing the TLB for removed/unshared tables, and maybe resetting
>>> it ... I don't know when from the top of my head.
>>
> 
> Seems like we could fix the issue that the flag lifetime was broken
> if the MMU gather gets reused by splitting the flush and reset. This
> ensures the flag stays valid between flush and sync.
> 
> Now tlb_flush_unshared_tables() does:
>     1) __tlb_flush_mmu_tlbonly() - flush only, keeps flags alive
>     2) tlb_gather_remove_table_sync_one() - can check the flag
>     3) __tlb_reset_range() - reset everything after sync
> 
> Something like this:
> 
> ---8<---
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 3975f7d11553..a95b054dfcca 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -415,6 +415,7 @@ static inline void __tlb_reset_range(struct
> mmu_gather *tlb)
>    	tlb->cleared_puds = 0;
>    	tlb->cleared_p4ds = 0;
>    	tlb->unshared_tables = 0;
> +	tlb->tlb_flush_sent_ipi = 0;


As raised, the "tlb_flush_sent_ipi" is confusing when we sent to 
different CPUs based on whether we are removing page tables or not.

I think you would really want to track that explicitly 
"tlb_table_flush_sent_ipi" ?

>    	/*
>    	 * Do not reset mmu_gather::vma_* fields here, we do not
>    	 * call into tlb_start_vma() again to set them if there is an
> @@ -492,7 +493,7 @@ tlb_update_vma_flags(struct mmu_gather *tlb, struct
> vm_area_struct *vma)
>    	tlb->vma_pfn |= !!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP));
>    }
> 
> -static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
> +static inline void __tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
>    {
>    	/*
>    	 * Anything calling __tlb_adjust_range() also sets at least one of
> @@ -503,6 +504,11 @@ static inline void tlb_flush_mmu_tlbonly(struct
> mmu_gather *tlb)
>    		return;
> 
>    	tlb_flush(tlb);
> +}
> +
> +static inline void tlb_flush_mmu_tlbonly(struct mmu_gather *tlb)
> +{
> +	__tlb_flush_mmu_tlbonly(tlb);
>    	__tlb_reset_range(tlb);
>    }
> 
> @@ -824,7 +830,7 @@ static inline void tlb_flush_unshared_tables(struct
> mmu_gather *tlb)
>    	 * flush the TLB for the unsharer now.
>    	 */
>    	if (tlb->unshared_tables)
> -		tlb_flush_mmu_tlbonly(tlb);
> +		__tlb_flush_mmu_tlbonly(tlb);
> 
>    	/*
>    	 * Similarly, we must make sure that concurrent GUP-fast will not
> @@ -834,14 +840,16 @@ static inline void
> tlb_flush_unshared_tables(struct mmu_gather *tlb)
>    	 * We only perform this when we are the last sharer of a page table,
>    	 * as the IPI will reach all CPUs: any GUP-fast.
>    	 *
> -	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
> -	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
> -	 * required IPIs already for us.
> +	 * Use tlb_gather_remove_table_sync_one() instead of
> +	 * tlb_remove_table_sync_one() to skip the redundant IPI if the
> +	 * TLB flush above already sent one.
>    	 */
>    	if (tlb->fully_unshared_tables) {
> -		tlb_remove_table_sync_one();
> +		tlb_gather_remove_table_sync_one(tlb);
>    		tlb->fully_unshared_tables = false;
>    	}
> +
> +	__tlb_reset_range(tlb);
>    }
>    #endif /* CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING */
> ---
> 
> For khugepaged, it should be fine - it uses a local mmu_gather that
> doesn't get reused. The lifetime is simply:
> 
>     tlb_gather_mmu() → flush → sync → tlb_finish_mmu()
> 
> Let me know if this addresses your concern :)

I'll probably have to see the full picture. But this lifetime stuff in 
core-mm ends up getting more complicated than v2 without a clear benefit 
to me (except maybe handling some x86 oddities better ;) )

-- 
Cheers

David

