Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F055C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6C66B00E4; Tue,  4 Aug 2026 15:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41816B00E5; Tue,  4 Aug 2026 15:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2956B00E8; Tue,  4 Aug 2026 15:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67D506B00E4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:53:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6BC18022C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:53:08 +0000 (UTC)
X-FDA: 85064635656.06.107C143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2995214000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:53:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieZEMC+h;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785873187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW/LLuOUzOOUBhOG6+e5fvCUb0cMEOKn7NiWBNsaufQ=;
	b=ptw4goUzSzbxQF6NHBFmIEpd3ZdMQ5vPSp/M/4Gi/Oj5yN3zUetOVnZv1IcaBHrnnjq63f
	w1VFxwuXnz6iF2MIc2faSrajbHt5iCQEhDChBPMHie6Uq5mUoZy7p+0fNq81XlRzzsmEdD
	pyNlbYhXin7BdsEQjtuOPYpqi5j+TsE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieZEMC+h;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785873187;
	b=zULEzshKdq2QLiu9s9McsHU+0tlj6BHo3qNL203N7hzck0FZ5qUDln1CXRqzpsxAvwrXWi
	creT9xIqKn0lr+IpA3OWe+v8UwJ02pt56jNgAzptxLmHwX1A1pJpMJ70cbIeMThQf4S1g+
	oOhpEFzPFybMMtWA4rt1FWILNA4NTw0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 459344072C;
	Tue,  4 Aug 2026 19:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391C31F00A3D;
	Tue,  4 Aug 2026 19:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785873186;
	bh=TW/LLuOUzOOUBhOG6+e5fvCUb0cMEOKn7NiWBNsaufQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ieZEMC+hAGqRVORA6npYIFDeuowUzn7cK5IkbtDF7ZHzXeIS+jDIrASfAv62HOmxf
	 KH4VTpo1InUlSP4vMvYRwHzdASUG+P6tdUn+LI4nokI5Kbb1gn5Yg6VEnwEQUqyXDS
	 QUVii700M49Q7wbWpQmxpMQNicsnbDy8VJnZ/LPFA1zyWeJVwVnXF2ja86zh2sQtaA
	 hRSdAG1YhrqoifWX94hZduTaBA3HcsOl5EZvQIBCXe4gEPuR+gtBdmwcXB0dkkoUeg
	 0xVhITBUmu6JPSBUv0c2Vez7HFdN4kicY/IYlbkw0YmNr0EODpZUiB8/D8uQYvng/U
	 Fw8hegZQXa9Dw==
Date: Tue, 4 Aug 2026 19:53:03 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 16/26] mm: add definitions for allocating unmapped
 pages
Message-ID: <anJB2jaBWwE1mSWN@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-16-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-16-6f5729aa9832@google.com>
X-Stat-Signature: 56k1jjjzwswny93tm47cafehsdwj4kwp
X-Rspamd-Queue-Id: 2995214000F
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785873187-9466
X-HE-Meta: U2FsdGVkX1/ofbPMQBs83CGBxLutBZpPJxBmxCQTZhUx0z/8AIGoaL/vwXjK2Mf0J9YtQY1hN5vDA4J2Rg/EXoSbw5r/rYA0CGHq/BIAKyYqK3bDtdblgYnoOBpVkzaVawPowpJhBhJSrW8ZjdJNrNo0EwhwsyQsmMR4nyPakw42W6Ad1ICMVpcD3xixTJTxUUtxYSWLuVatqfXPjegbnW9lStphkv0Pzo6rW5Er1E8n40qp+2XWC00M/oTxuZY3YBwIbnyFKCQAChXeWmkfiz/RsKMz+DCRxOk7v1B+OqKZbFddWptev29Tz4CoshBwFID/q3TlkDZLleBNG4O8vw3QrZBtduJSZvuwycm9tWmwKKpsqIaEzBlV48jPe2c4zvzX3xnj1rOT5ubxyX5K29jgZNdOyBhrO74LcULQ9bPnB2BuN/hjKJ9UnB4Hjlf935pawft1FZJJ4xyr4cBG4FZeHIM19eUzR90Xyshf51f2lus+9Lreim1X9VA3C97XCVtzpNX2suOufWotrrN+GOcSU1FJGVAepc9POPmXRQr+iHX/G1lpjvWj7wyvGGl+fOkJM2k28ba5gtHnZ6NvuGdauyebdNfF2QrGh2ysolZ8MfMFwl8lpm8ST7nEpmnt47aGZ2z2+u9x6bjulnDF1ZfukOizOFdlw782i6b96TCHyy6SXUaVHjKI+/ipS/ILIxKRJ1Q5iht4K/mNqxz90b1vMCy4NJ8c/toCxsyFUYolxDylLcgig1F8FredhPAjmltCPcLHsaX082xBQapWKzx7sx5ChIZz7DeUG517IxuubZhC8CY/mjOFCwn0dF9FAY/DFNYHptPymjCIYeuELhEgBcUn0PLnUhl/kgtbnld58a/Ogg/ONC/OzpulsSIVFoQ2aWhtaDOtKA5H0an+j809y++yYrVXcLUwNdxkLZQdvl4rgsOEi69Plnz1aZQykIrurPUesPF4cH3qiT1
 XxMaLIhn
 z9KIibyXWI0J2dvPA2DN/KsZT+7m3EWTfi5nEcuvoNfb6IWgvI2Uz7qb9feyxCVKOO07hv/yAgMNEv8gN6AupOjCVKbYO9Dksz+IdTudvvQFz6JlpBa6fhieamDX/TBdOQ8Q+a5z4OX0GRSV58LWp7x4Ngno90t4D/5A2WaTXVXwDLCSS+boEF+Qq00fToJygZHyYMJUnMyFKM2ePfYleWPSH/MWCvb8/Hu/9XRR3Y/xkk6785UcYuv8guar2Nfeb8JB+n0jHLJw2TH+wYH8NYd2JIx+uzL9mIMjosBSdFT+xW5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:49PM +0000, Brendan Jackman wrote:
> Create ALLOC_UNMAPPED, which requests pages that are not present in the
> direct map. Since this feature has a cost (e.g. more freelists), it's
> behind a kconfig. Unlike other conditionally-defined alloc flags, it
> doesn't fall back to being 0. This prevents building code that uses
> ALLOC_UNMAPPED but doesn't depend on the necessary kconfig, since that
> would lead to invisible security issues.
> 
> Create a freetype flag to record that pages on the freelists with this
> flag are unmapped. This is currently only needed for MIGRATE_UNMOVABLE
> pages, so the freetype encoding remains trivial.
> 
> Also create the corresponding pageblock flag to record the same thing.
> 
> To keep patches from being too overwhelming, the actual implementation
> is added separately, this is just types, Kconfig boilerplate, etc.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  include/linux/freetype.h | 70 ++++++++++++++++++++++++++++++++++++++++--------
>  mm/Kconfig               |  3 +++
>  mm/page_alloc.h          | 18 +++++++++++++
>  3 files changed, 80 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/freetype.h b/include/linux/freetype.h
> index 3b0d44023b6a1..37e88dcccdecc 100644
> --- a/include/linux/freetype.h
> +++ b/include/linux/freetype.h
> @@ -2,6 +2,7 @@
>  #ifndef _LINUX_FREETYPE_H
>  #define _LINUX_FREETYPE_H
>  
> +#include <linux/log2.h>
>  #include <linux/types.h>
>  #include <linux/mmdebug.h>
>  
> @@ -64,20 +65,47 @@ static inline bool migratetype_is_mergeable(int mt)
>  	return mt < MIGRATE_PCPTYPES;
>  }
>  
> +enum {
> +	/* Defined unconditionally as a hack to avoid a zero-width bitfield. */
> +	FREETYPE_UNMAPPED_BIT,
> +	NUM_FREETYPE_FLAGS,
> +};
> +
>  /*
>   * A freetype is the identifier for a page freelist. This consists of a
>   * migratetype, and other bits which encode orthogonal properties of memory.
>   */
>  typedef struct {
> -	int migratetype;
> +	unsigned int migratetype : order_base_2(MIGRATE_TYPES);
> +	unsigned int flags : NUM_FREETYPE_FLAGS;
>  } freetype_t;
>  
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +#define FREETYPE_UNMAPPED			BIT(FREETYPE_UNMAPPED_BIT)
> +#define NUM_UNMAPPED_FREETYPES			1
> +#else
> +#define FREETYPE_UNMAPPED			0
> +#define NUM_UNMAPPED_FREETYPES			0
> +#endif
> +
> +#define FREETYPE_FLAGS_MASK FREETYPE_UNMAPPED
> +
>  /*
>   * Return a dense linear index for freetypes that have lists in the free area.
>   * Return -1 for other freetypes.
>   */
>  static inline int freetype_idx(freetype_t freetype)
>  {
> +	/* For FREETYPE_UNMAPPED, only MIGRATE_UNMOVABLE has an index. */
> +	if (freetype.flags & FREETYPE_UNMAPPED) {
> +		VM_WARN_ON_ONCE(freetype.flags & ~FREETYPE_UNMAPPED);

If we move this to the beginning of the function we can drop the
VM_WARN_ON_ONCE() below, right?

> +		if (freetype.migratetype != MIGRATE_UNMOVABLE)
> +			return -1;
> +		return MIGRATE_TYPES;
> +	}
> +	/* No other flags are supported. */
> +	VM_WARN_ON_ONCE(freetype.flags);
> +
>  	return freetype.migratetype;
>  }
>  
> @@ -85,33 +113,53 @@ static inline freetype_t freetype_from_idx(unsigned int idx)
>  {
>  	freetype_t freetype;
>  
> -	freetype.migratetype = idx;

Do we need a comment here? Something like this maybe:

	/*
	 * There is one freetype per migratetype, as well as one extra
	 * free type for unmovable unmapped pages.
	 */

> +	if (idx == MIGRATE_TYPES) {


> +		freetype.flags = FREETYPE_UNMAPPED;
> +		freetype.migratetype = MIGRATE_UNMOVABLE;
> +	} else {
> +		VM_WARN_ON_ONCE(idx < 0 || idx > MIGRATE_TYPES);
> +		freetype.flags = 0;
> +		freetype.migratetype = idx;
> +	}
>  	return freetype;
>  }
[..]
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index 9928aa9012588..fac8e5304bb03 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -56,6 +56,24 @@
>   * alloc_tag_sub_check().
>   */
>  #define ALLOC_NO_CODETAG       0x1000
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +/*
> + * Allocate pages that aren't present in the direct map. If the caller changes
> + * direct map presence, it must be restored to the previous state before freeing
> + * the page. (This is true regardless of ALLOC_UNMAPPED).
> + *
> + * This uses the mermap (when __GFP_ZERO), so it's only valid to allocate with
> + * this flag where that's valid, namely from process context after the mermap
> + * has been initialised for that process. This also means that the allocator
> + * leaves behind stale TLB entries in the mermap region. The caller is
> + * responsible for ensuring they are flushed as needed.

I think this is no longer true as the allocator does not use the mermap
with __GFP_ZERO anymore?

> + *
> + * This is currently incompatible with __GFP_MOVABLE and __GFP_RECLAIMABLE, but
> + * only because of allocator implementation details, if a usecase arises this
> + * restriction could be dropped.

It would help to explain why it's incompatible with __GFP_MOVABLE and
__GFP_RECLAIMABLE, here or in the changelog. I assume mainly because we
only have one freetype for unmapped unmovable, but there are also some
more interesting details like compaction needing to support copying
unmapped pages (e.g. via the mermap)?

> + */
> +#define ALLOC_UNMAPPED	       0x2000
> +#endif
>  
>  /* Flags that allow allocations below the min watermark. */
>  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> 
> -- 
> 2.54.0
> 
> 

