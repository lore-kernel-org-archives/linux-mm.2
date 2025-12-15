Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F94D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 05:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94C86B0006; Mon, 15 Dec 2025 00:48:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45276B000D; Mon, 15 Dec 2025 00:48:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34806B000E; Mon, 15 Dec 2025 00:48:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA39A6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:48:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B469BE4AE
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:48:40 +0000 (UTC)
X-FDA: 84220626000.09.D726BC0
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53A391C0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:48:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GHlnuLzp;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765777718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXBFQTQkWArDGCGQE3Qb4WRg56aochoyiuY4gkYroaU=;
	b=VRPQ+udhgDjcCmjBLeDCICEpfAfO774U+fzuq4La0NI1xjIe/2PsG3O4WdFXWcvHTNHDcS
	C1t59ZqBJkiBo+NPyKN65hdCa42ilqSjNP2Wxscc3XIN3I/xMkTvWX73kWBWCMFLhfxKfy
	ZF/19UessASWaF/HWeG5ap2ScTsnctg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GHlnuLzp;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765777718; a=rsa-sha256;
	cv=none;
	b=YxvMYB3Wq8rKLTd+2O3jF7tTxsnKMOY5KNAZb6HVPS2Y0dsoXJbprs9ArHaaTTb/3zTVoI
	ELnMXvEDLXKjQ5Lotq7RXtyIF/mpOP5hW52iTImhH2vL9PO41oRbp/m+gFhlJXfcnDn7pv
	h7u7M/MfffRIQbdi5iW/Ht2rNrm2M6E=
Message-ID: <4ff8abad-186a-41b7-a269-70e9b1dc61e5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765777711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pXBFQTQkWArDGCGQE3Qb4WRg56aochoyiuY4gkYroaU=;
	b=GHlnuLzp2XpmhCe7oRyppfHdyNfxGKYqQfvQfWKjYPAn57gO0JVV0fnA+AE3r0S0T4/GjV
	BR+ndZZ1ouw40aLma2uks6FFuAGjhdDsi29MQhXZERTN8qxw6Pc0+YzqGS8n7MPEhNqNSB
	gqbmALHgoIL0bLQmi+6vAqrgT2OxvXo=
Date: Mon, 15 Dec 2025 13:48:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/3] mm/tlb: allow architectures to skip redundant TLB
 sync IPIs
To: akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251213080038.10917-1-lance.yang@linux.dev>
 <20251213080038.10917-2-lance.yang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251213080038.10917-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53A391C0006
X-Stat-Signature: 6g5xzs36u843i3egupt59qx63pe8hb57
X-HE-Tag: 1765777718-782987
X-HE-Meta: U2FsdGVkX1+PRaYh67nlzUjumDzpj1fuphF6SPLWWxPjG2rOnJjOgx1RiwFg6rRUZvTceBJVVjdyWINCZU+HaGbWmDhvZ/5a34X4yXvY6sSdph7fkUdH5F/6v7CdrqABtIdSZZ0fWKVYxMCeIzHXvXVZ/ovuAmVi2uXup5r58pz2jdGEYfQyAzRwk8UnrTUNy8Y0BZZbWP9XfGJ6IUbtEALYmZeyubSha6rebPEq+//FrZIVPFlTFvIzYnBd/JXyRc8fq4rzgt6I3XF2RR+BOJJLqZX6+/wHLyKkmNkjEhtruRZe3I328x+t615JitexxxzjW9X0wYIXEvMYqP3iVoj0HR+VStBbQEn1/mtpTBAw3cEIc3sUN4whEUgUpLoneljzRx5fJb8O2+oGgqaJdblGdhJr8vXfUFGl1VoWOlTEyh/4IEIurRu5Rl4TdvVdNOnznNFd0HvyJmx/ZVB1oIasOis7UZqi7Pi/KS/zQxJ+UpJgRbPZS8H862emCT544dn+voZNC/XOTDrTPw85qXML05QmmWjHvCSy8bvEXtXna3f6A7ih6zfZNstRqzbUGyQTFdHlWoXZTpNuFIn2kG0woJMIDxJYABTWjZZJsTY/QW0VWM6f/1OYAYKZkqfkkp49eUBJRx+bjrj1/NeoBuIvPhn3tgdib8FR2V7uwZkqA9wnPuRbObSsWgFWgTUVbvXKMDUZmtNhcv7Ucr0Sr1yEY9EysJ4KKvlga8B8ZY9VGYmoPxen7mIX0gWaZ1dB1H4vKClptqEPfs0sjC1lOeEcLpoK6dcl6ge0hPCDb8s4WlUo9G2DxrlLuEXU78ag8qUl2Wap4Bm3fI78TsIkTky36ntiKdkVxeKkT7+LQo0/lr7FLAT7D/CNXBa9ixwbQzs24HYlbQb2CP5fLGPhLjTTAWRGk1xc8S3yUitml0rtyJYmPn94YlUURyY5nqy5e9EdsDvvJx1S36ESDzO
 5VnvA+oe
 Ys6j6R3CaKQXlqYUZtDhoBn7578N7ZUIR6S+RAQd4RqMb2Sx20ZTCCB92h9kZyRlAM/e9OZMfrafJb6iG7wfpg7zV+Z1hTwzvZu3Fura8sz+HHnh/KxOnMUapqDJauUb7WDLwx2egTp7pwxCZpIACP20Zoe6O4Xleewpc7LLayQpqmYAOSKUqx/ZnuJfddQ9pRz2fPNWubY8Baev7xp6Etlw7/iAJqq2w8S8iHWLQDErYOdekOKgXkNYEgawAgg89h/Z9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/13 16:00, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When unsharing hugetlb PMD page tables, we currently send two IPIs:
> one for TLB invalidation, and another to synchronize with concurrent
> GUP-fast walkers.
> 
> However, if the TLB flush already reaches all CPUs, the second IPI is
> redundant. GUP-fast runs with IRQs disabled, so when the TLB flush IPI
> completes, any concurrent GUP-fast must have finished.
> 
> Add tlb_table_flush_implies_ipi_broadcast() to let architectures indicate
> their TLB flush provides full synchronization, enabling the redundant IPI
> to be skipped.
> 
> The default implementation returns false to maintain current behavior.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   include/asm-generic/tlb.h | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 324a21f53b64..3f0add95604f 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -248,6 +248,21 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
>   #define tlb_needs_table_invalidate() (true)
>   #endif
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

As the kernel test robot reported[1][2], the compiler is unhappy with
patch #3:

```
    mm/khugepaged.c: In function 'collapse_huge_page':
>> >> mm/khugepaged.c:1185:14: error: implicit declaration of function 'tlb_table_flush_implies_ipi_broadcast' [-Werror=implicit-function-declaration]
     1185 |         if (!tlb_table_flush_implies_ipi_broadcast())
          |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    cc1: some warnings being treated as errors
```

I'll move tlb_table_flush_implies_ipi_broadcast() outside of
CONFIG_MMU_GATHER_RCU_TABLE_FREE in next version, making the complier
happy on architectures that don't enable that config ;)

[1] 
https://lore.kernel.org/oe-kbuild-all/202512142105.NXwq6dfP-lkp@intel.com/

[2] 
https://lore.kernel.org/oe-kbuild-all/202512142156.cShiu6PU-lkp@intel.com/
> +
>   void tlb_remove_table_sync_one(void);
>   
>   #else
> @@ -829,12 +844,17 @@ static inline void tlb_flush_unshared_tables(struct mmu_gather *tlb)
>   	 * We only perform this when we are the last sharer of a page table,
>   	 * as the IPI will reach all CPUs: any GUP-fast.
>   	 *
> +	 * However, if the TLB flush already synchronized with other CPUs
> +	 * (indicated by tlb_table_flush_implies_ipi_broadcast()), we can skip
> +	 * the additional IPI.
> +	 *
>   	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
>   	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
>   	 * required IPIs already for us.
>   	 */
>   	if (tlb->fully_unshared_tables) {
> -		tlb_remove_table_sync_one();
> +		if (!tlb_table_flush_implies_ipi_broadcast())
> +			tlb_remove_table_sync_one();
>   		tlb->fully_unshared_tables = false;
>   	}
>   }


