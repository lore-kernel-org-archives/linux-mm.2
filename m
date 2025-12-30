Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B878BEE49B4
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2489E6B0088; Tue, 30 Dec 2025 15:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CBFF6B0089; Tue, 30 Dec 2025 15:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEF66B008A; Tue, 30 Dec 2025 15:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3A8D6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:32:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C9D91AEF3
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:32:04 +0000 (UTC)
X-FDA: 84277284168.02.7414D7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C6BF1140004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:32:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RFImDH+K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767126722; a=rsa-sha256;
	cv=none;
	b=nwRD+7w/Shly+BU5QEuoj5/EXp31VNJKCM3ipohCUrTALyGXv2H+AbVkFBj5ZWRvFSePtg
	Sd6gfKFGRyEOyYySSOWQKeJ/v8hBX0W7CYblqPHjLT6nOKtpQGkJlVnCUweKh1o6V54g6x
	bORB1riFmBINRb5LufVAc35j+BL2jPs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RFImDH+K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767126722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1x7fIpOg2y0mjOcKCE55ce3Dx6ueRBGLk5DeTPxsvd0=;
	b=YlFdhcowVKnwycEFYBUyRa2vGGFIXX3yf9bC3Pjwx6V/yEIwSLJC6LO8NBxZJj4kPVfMdL
	Ojjslwx9fEtXQVBh7M0+Rn43XFaiCzkaCuHr8ucqAP7GYfNfM0T0sHUqmR7bEKQyoYp4wB
	kI2RjLDbb5aCTKtA4yIkjW257UuOjr0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50EB9433B9;
	Tue, 30 Dec 2025 20:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB22C4CEFB;
	Tue, 30 Dec 2025 20:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767126721;
	bh=cndBsIdqWaO0mAWgypNK8SdnZmIn09dB7jgukNbm22w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RFImDH+KE8o0n4QR10H4g03pXnoFVlnXi95t2jkVwzBvm3iUyPAFFUDsKjAGKDS6O
	 1384jK4bXsTUKQREFbHc8T14YsyjZ+5+N8hJOzl4uztvoAtlBb3DmFTDK6k9t9bzqf
	 ZJEBD9PvLpA5IArOlpb5q2+k+IMGVc11Rw89kMQbSOPhEt7RAZUMFXt8wVmNpDEzR+
	 1c2TTUYBxQn4PU1f477EIXkUnOabLBlYBPHtygvfN3TT098hZXv+M8VvSEg+q82w0L
	 Lyje7kaCTXZXIiAkmhIbGXmDPlFCtiuzom3Hy4MBH5P6HZtutqAiPtkJM6DqHmd2LZ
	 zJ4zf1lkPnAhw==
Message-ID: <725b85bf-ff5e-45d6-991e-d92598779f98@kernel.org>
Date: Tue, 30 Dec 2025 21:31:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/tlb: allow architectures to skip redundant TLB
 sync IPIs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <20251229145245.85452-2-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251229145245.85452-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6BF1140004
X-Stat-Signature: nfd8eirn7kjzyy9tr7iy9romoybimby7
X-HE-Tag: 1767126722-286727
X-HE-Meta: U2FsdGVkX1/r3yt3wVP0SDQq/d7EeU/FfrQErfifZ4rU4CYW5YttEwkl+/4wLHZP1rAekEWQNFIPt2CnAoMcoKRh61ycaTcYmplUmL6ViHQ7+VWOYmzYpl1ZjE0hIqgatXPpQx8c8UJQqvRMT91PNMaPJhg7Qk0VvRRHDP5Ok2iJ0cQtRYcPWa49jd/9P2/K/J6raeQxitIlN9YfEHtWk9QJV21/+ZEujpWU+5PQXVZXU3rt4ozuphV+o9uHfpOsUj+TQEIRaRM/IM2h65xdJuXSA9L02lx+0VKVLcPsn5Dn+1MTuLwUMWo88SdPcmbrv6eZjOS5P/j9EKT/A0wecow7L0+kZa1lzPjy2x2zwcMlWCC7Tlf0Rg9T/e8DLmCuky1mmUDDLWZonxEa78XdvHBnLUxQN0TqdT8uBsM5chaDHiR+KBpm/IFyCahT205GyWjK7xlpLIRnFy1UtqfOtOOKiq4+CsxrJGxnEvoDnMOFudorZBfJJOxLyTwkRvshi/mJjoHAfYVT+do4uTQ3fN4Lv4r03nMhol8zpy92Ei0YSmRa5E3XcCM4K3kFWPleU2qqUhfZJOAbVJuYsQkASAOTPxmz0v7GqdSZJ6DDAWFRMg+raMFmFRTMq+ChLyaelWj36zGKyMrJRGZcQdxxxvh7qx/YKE9Mnk6rAP3A9eK25neuWtsBaZm3Pw8AZ7AFs3V/DjUzDvN4F04ilDfFuBJjB6eweMWoL5o66CFe0BK6XNOup1lvzdOqD99kyXZez0Mt2C4f6vXlocoK+1AcJTCwf6/jJZLQQYY/rMz2tB6eApMjrg19JgZ1VJSSsto3thl7vszguabqjIVaAGDP+fvUCeDXmuYpkNFKc97Jro5ULlxAKnffrqdPHYTyNnTjOhnaJFksX/rbLhVHuofeByo2cfAtYhpq+zqHXNWfD9wCZ4UIC/Pa7PbUd43rAAloY6wvqC81PDvyqdJLy44
 wvdiBWu/
 zztZuT91M3QhN/Hh69booAMaIbDfJfYfUnTb7kiwurIqW2EOvyvIrbPELiI76m0ToQv6O2hQOuzFtRci6F7+Yj7hcHD/LmLur5Ad3vlKJ1a6fFQFOobIB2W6Xz4RwX7LXqht2reiwqXM/a/4wkDiex81495FW/MoWtBKwpJLgN806AjAPpV1rfBQlJkZYWhbgMmCN5Rm1l2FZm8JuExSC1W7uYf2kYXOvF03OwSJUc5lRY9sKlvMIgXXhsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 15:52, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When unsharing hugetlb PMD page tables, we currently send two IPIs: one
> for TLB invalidation, and another to synchronize with concurrent GUP-fast
> walkers.
> 
> However, if the TLB flush already reaches all CPUs, the second IPI is
> redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
> completes, any concurrent GUP-fast must have finished.
> 
> Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
> their TLB flush provides full synchronization, enabling the redundant IPI
> to be skipped.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   include/asm-generic/tlb.h | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 4d679d2a206b..e8d99b5e831f 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -261,6 +261,20 @@ static inline void tlb_remove_table_sync_one(void) { }
>   
>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>   
> +/*
> + * Architectures can override if their TLB flush already broadcasts IPIs to all
> + * CPUs when freeing or unsharing page tables.
> + *
> + * Return true only when the flush guarantees:
> + * - IPIs reach all CPUs with potentially stale paging-structure cache entries
> + * - Synchronization with IRQ-disabled code like GUP-fast
> + */
> +#ifndef tlb_table_flush_implies_ipi_broadcast
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> +{
> +	return false;
> +}
> +#endif
>   
>   #ifndef CONFIG_MMU_GATHER_NO_GATHER
>   /*


This should likely get squashed into patch #3. Patch #1 itself does not 
add a lot of value to be had separately.

So best to squash both and have them as #1, to then implement it in #2 
for x86.

-- 
Cheers

David

