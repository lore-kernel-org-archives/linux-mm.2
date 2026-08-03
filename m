Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AEDC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260916B00B5; Mon,  3 Aug 2026 08:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210B76B00B6; Mon,  3 Aug 2026 08:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8846B00B7; Mon,  3 Aug 2026 08:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD1B86B00B5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:57:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D2861A065D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:08 +0000 (UTC)
X-FDA: 85059409176.07.074B38F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 987DF20006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SoVb+i+B;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785748746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NLzFDn/DIDYnKuFtRjjdVsbfvke595vqQGCR+hV60w=;
	b=16vRJL0j6JxmDtJ97DMSRhX2tXh/TmhG8gXzHaZJvtSP2Xp2nzzdcLQ2q9+TJa9jJfSWh9
	6vqAAJ+RA3+k8NngAdmUd1rHjZhTDXrPW9hNpv+a0QeNoVMtqvtRFPHOYcAPTbahjY6s8/
	i51wBCY01G8yTYA+pjvw7LyyWtm25vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785748746;
	b=45+xRA/erK704xDNwT7NC/auuWJI6NimOD73MgVCINvw8jilENw8QoAEq0ZXFjHISdO2GD
	jluw7JmU2Y+uDNbp8eM17cE4WKkk4ELSUdZ8XAmoLmO0OlYbi0F4WigxDSZp5Vy37z92ca
	T+hOKQPZXCFyoXYiRAJXTwlVD/JzXo0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SoVb+i+B;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2A8043B27;
	Mon,  3 Aug 2026 09:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AE1F000E9;
	Mon,  3 Aug 2026 09:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785748745;
	bh=5NLzFDn/DIDYnKuFtRjjdVsbfvke595vqQGCR+hV60w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SoVb+i+BWfxBsK9hIBTWcdEhCUza72DRdfmxdWPqDZaXCntv5d2pXvlMMihf4dJ8C
	 tVuX/WqtRM/X50+M2IyYy9p3p26rzqBS7Nb2IsI56aoiXDbrJ+9N/kfQokcenLrJDX
	 0YXrahvVbN34EjchyxMxNyuBtu9Ef0qAtmAU7H5OpEbXkxrAfQ4bZ+a/GqN59ScdqF
	 NIdDtypnnVFWMtzJjEAqmN0/9TpnfDjl4WdpZuJD9tS+/R96bO0MOtqa8BJ4dsCwZ1
	 7oDtMd3y8erfmlm9Xm3IcbQL0Db3nOuiP51EU7fZ6h/IAIO6+H5rI3VHvh29EDmuG4
	 U7wCXvN1fjr+w==
Message-ID: <f29c4d91-5a6b-4949-8051-debe8c6fbffd@kernel.org>
Date: Mon, 3 Aug 2026 11:18:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>,
 Sean Christopherson <seanjc@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o7bz9o67banbm5bn1o51fnoqsk3dgfym
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 987DF20006
X-HE-Tag: 1785748746-167127
X-HE-Meta: U2FsdGVkX18Cg5Hp6k4bETo3xTk8kdK5coLjhMaAWHQmS+/+0ymcmee3bapfngfq5kJTN/K2JLi1X9HGQNucg5P2yPFPd8DCcmM5xaRWK8s6kmm9eNqP9zCYAZ2SSbY5F38cRLtmCuIUTjmHJgZpfUeUfNKoHM7lLB5cdqcuPGZfKxbIIFTrlBi4A2lhJFNjVdPviIkmt+DKhTcSvq4hp6N88RbVGgM4J1Yg3NOIjHFMkps4bdwaztARU3kZkLx7ijwFVi7MOl46loYzsgCC24wScUAaxdFcAMDYisS7c2cqTMonodGTmuwNh1zz0Px0ez7Y42NmsOGgbVtjOqfVu3ZJnM9pjemgcJ4B9cEhtzE7/yPntyoZ1x0b/Hm8AsWFUvBFB9VPO1F9rA+eXslfK7g8vgvpJGOonDC1WswgqeScZHWsNJVBM59gKN423w1pRRso1aksG9Pfra5G5Oq0HVcqGn1qB8+Qr3QHlfviUxEXXNp5N6Qj1XAjmKUTiaVKjFDfqpXGiEfo+xlddHQFrHnmRK3i/F8Ow7EoEmxAfEtrILtDcox2xmpIVdhoxFoptAbVhUVa3/OkfrY3kUota39R/r7DBp0Zfc1Ey0mYv/+ltb5gC3r4RhMar2H9zM8SugJ5MSHTfxxynr+1DJ5wFRZ5bpYWlaTNQm3VXPER16/PLTx8PvlvmSW2khKLeMUeMEq83g6DYuqLrokW3iKuYTEmeAo55r4po4iPUUiOKaBmrJpyctYgEBi17MByjCbpy8tvwftD3ZlM8zpg2aG/qosL10UhSqH9dEB7r1owoJspdVsWMs8EZczaNp10IagRTH7pa8biUX/Q9xTi3VLnm8p0T0sBt/M83qaCnik1f+8ils0FLaOeC3Meus08s2ExTsb2KjvxvgqqgoElzidv12yRh9B9WRsIvbl2eTPTcj6GnOyFvm6/MoeQ65fU6g+ItE+y4llpcDprEBANCCQ
 z1YAMknb
 KsrS8G0K6dhaVbb7kvhmVIG0JQmd0fAM7joTAkqhR8JlKJX9OuvWATRsFGL6VM+oDuUGWIEjNEq9QV2J8Z3soTm4xwZeVrWL+oeFFvjPnU0fT57Xri+nqlsHzQaewE+5WzDcSlLT1XeFKw2xFlowVTz5Z0Adn1oTiCz0yUFt1QiAVTzd5fnygDKB15k4Gck7qk3W+B/i9RIlBDrYTYT9qHvR4EKhcB1PDHd/jJ+SQPQbLAxbQ2dffN0I4szp9DUFH50lUm/yCyGz6WVLttX47RF37CauTgkdkXb4DbpofLEc+kP9FijTsGpai9sgOt+gZwVTz90IeyQobR3jw7UceMuIilwacBI2tOVhE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 00:22, Brendan Jackman wrote:
> Currently FREETYPE_UNMAPPED allocs will always fail because, although the
> lists exist to hold them, there is no way to actually create an unmapped
> page block. This commit adds one, and also the logic to map it back
> again when that's needed.
> 
> Doing this at pageblock granularity ensures that the pageblock flags can
> be used to infer which freetype a page belongs to. It also provides nice
> batching of TLB flushes, and also avoids creating too much unnecessary
> TLB fragmentation in the physmap.
> 
> There are some functional requirements for flipping a block:
> 
>  - Unmapping requires a TLB shootdown, meaning IRQs must be enabled.
> 
>  - Updating the pagetables might require allocating a pagetable to break
>    down a huge page. This would deadlock if the zone lock was held.
> 
> This makes allocations that need to change sensitivity _somewhat_
> similar to those that need to fallback to a different migratetype. But,
> the locking requirements mean that this can't just be squashed into the
> existing "fallback" allocator logic, instead a new allocator path just
> for this purpose is needed.
> 
> The new path is assumed to be much cheaper than the really heavyweight
> stuff like compaction and reclaim. But at present it is treated as less
> desirable than the mobility-related "fallback" and "stealing" logic.
> This might turn out to need revision (in particular, maybe it's a
> problem that __rmqueue_steal(), which causes fragmentation, happens
> before __rmqueue_direct_map()), but that should be treated as a subsequent
> optimisation project.
> 
> Adding alloc_flags to gfp_freetype() requires moving it to
> mm/page_alloc.h so it can refer to ALLOC_UNMAPPED. It was already only
> used in internal mm code.
> 
> Now that unmapped pageblocks actually exist, exclude them from
> migration. Migrating unmapped pages via the mermap should be possible
> but that's something to be added later when needed.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

A nit below:

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -34,6 +34,7 @@
>  #include <linux/folio_batch.h>
>  #include <linux/memory_hotplug.h>
>  #include <linux/nodemask.h>
> +#include <linux/set_memory.h>
>  #include <linux/vmstat.h>
>  #include <linux/fault-inject.h>
>  #include <linux/compaction.h>
> @@ -1001,6 +1002,26 @@ static void change_pageblock_range(struct page *pageblock_page,
>  	}
>  }
>  
> +/*
> + * Can pages of these two freetypes be combined into a single higher-order free
> + * page?
> + */
> +static inline bool can_merge_freetypes(freetype_t a, freetype_t b)
> +{
> +	if (freetypes_equal(a, b))
> +		return true;
> +
> +	if (!migratetype_is_mergeable(free_to_migratetype(a)) ||
> +	    !migratetype_is_mergeable(free_to_migratetype(b)))
> +		return false;
> +
> +	/*
> +	 * Mustn't "just" merge pages with different freetype flags, changing
> +	 * those requires updating pagetables.
> +	 */
> +	return freetype_flags(a) == freetype_flags(b);
> +}
> +
>  /*
>   * Freeing function for a buddy system allocator.
>   *
> @@ -1069,9 +1090,7 @@ static inline void __free_one_page(struct page *page,
>  			buddy_ft = get_pfnblock_freetype(buddy, buddy_pfn);
>  			buddy_mt = free_to_migratetype(buddy_ft);

There's a comment above this that should probably be moved to
can_merge_freetypes() as well?


