Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7836E10F6FCD
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D811D6B0088; Wed,  1 Apr 2026 11:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58D76B008A; Wed,  1 Apr 2026 11:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E5A6B008C; Wed,  1 Apr 2026 11:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B59876B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:13:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CFD4140928
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:13:21 +0000 (UTC)
X-FDA: 84610330602.10.DCF4345
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id E0CBC4000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:13:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dBLaPMBW;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775056399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7V8NwxjJKMOpltZaIZFZoGhOg5tW8DUtEYCSg58hw0M=;
	b=P6LLxkprVHScvaTf6s27l+UgMKXkPUmU6nDMWQPJu4m4NMS7RQdTLefdkwTBskIrIg5c+Z
	op7k/DFCyj6ODtTx4V27YGBeuJbBZ8ALXS/EauFNNyWUL3J8HzrvSCNBzZkyFse6YLeRkH
	4xQW/IiRgB5xgprffe5cdLlHFZVRPqg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dBLaPMBW;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775056399; a=rsa-sha256;
	cv=none;
	b=S7j/nlY+Wlha6aY28dZK4dBJBGMOlHQ3IeRo/d9pzAmpJfWPeeJnu+CF88X7MiRC0xAYDP
	Qt8W0sy6TgZPiRRmYkt+NUfrrHqlEaOUtN2QAT35JJNx/0eG5xoI8PSq/lja/82agNYoDD
	S4+2jLi3qxCoZWjWVepM785VBKWxAuQ=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a1443780c4so1137054e87.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 08:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775056397; x=1775661197; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7V8NwxjJKMOpltZaIZFZoGhOg5tW8DUtEYCSg58hw0M=;
        b=dBLaPMBWp7OSmDZHA1il+CZEO1PJxvxzGAqj/ShfY+yzutZX3xqueQjPHqFTkyYHeR
         6aj8wZML+BlyRvdx0GjPND4uBJtzhhfiohJ+MKm/wpBqOh3FfFv5Mw7i16XioaUqXiq8
         VvEmJmpFePbk6fyg7JxlBa/RRIqUgIKUWquTB2SnSmKsc+bjh5Ue5MakWNGitYpuP6+r
         1O9mToV8GV1tuZWg0+sO7ckBoEFEHbJYEM9kseYrK3i/Y8B+Cn0EAAXUyXh6enSNKx7P
         TGyuokdC46+Xy2I/aWUDcdkakF20kmVz4Z5BAq+xHSZelRJLK1VzAqUF0qaMAIQkADZc
         aEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775056397; x=1775661197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7V8NwxjJKMOpltZaIZFZoGhOg5tW8DUtEYCSg58hw0M=;
        b=ZtTA1EyxJEC2OJTMLmF9MORvOABY2Tl6P5/sNueQJOtSOt8+cheearMwHEm4Lor3WD
         VL//rrvUk1RGPnSTis/4xNXWJqmu+EWUxqY2j3QTNYusWuRye6vC2XCw/LFu/41hy0vp
         KO+nboS6qzZ3lrZYJ9k1IFxKqZuNQQxFPDbnRw1KiD4YkiJEhEkKaGGwOWrf2QAKm3EI
         ujjsA+oINp0LmY/Qy2clfc5xOmAZUnKmamGZX4kCtIHUSm6MCYXKL05wjZ3wUdvtuHes
         FYw8dIWMPn5D+a7TnsN7e42BV8t5Sq3L8zUioX3gMkbXT8qYkV1eQg87cR5rP1Irt0D2
         Pvlw==
X-Forwarded-Encrypted: i=1; AJvYcCUERSNUiry4odI/Ns8vV1UW/1Kk9xydgOjhNqt0prFaCDoTTUlucM0rSfXl1Pwlk9UvO/JrCReEGQ==@kvack.org
X-Gm-Message-State: AOJu0YwJsRWiIBOn3Rxg/zGUSG5z0a7aPq+iLFDKAhb12r9nFRg1tXWK
	C4x3XNneauFc4AC79gcScy8YYjDiL23PLUBwumSOLHYLPPGZaho+f+74
X-Gm-Gg: ATEYQzxNVmqQN7iTUuH8dfWFSLD1B4onIrGQckMcFScYLlhL8Pyf36fXvqSFmfZp3YH
	vyMZH5EzxgiXxCUxWjo8XXNceCNJwIWMaUukb/9Ygrw4Kyrx6MprWTE77vrjfv6ioLfqtCNeayR
	+ayxWHBAxBLuJxQ/Nn6FNgvw2swZwscT9/1wz11yM56Q5Ugl7+fvixL8YGK80FqwQArEMd8QFd3
	IaNqk7a9LSMXVY4zx3g4NDRvWO31F73AVzO6Iirtb2UH336Nvijwkj5uEm23FhREAAzz6BWYceN
	BVJxk2Nk1Aj5vWlHfwUkKSQv0+NLub6IoVbMY3yUxK8dfs9Xf/7TMC2Uwm+KCCTAEvTRXRMAToi
	2/2JPRheBQ7dzqznt73UoVcySFY2w4x7/hEbjzR6pVp+W76Kv1VRh2N841VZUqW7i
X-Received: by 2002:a05:6512:4023:b0:5a2:c0b8:26e with SMTP id 2adb3069b0e04-5a2c220b4afmr1279512e87.21.1775056396314;
        Wed, 01 Apr 2026 08:13:16 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c6cc5f90sm4157e87.49.2026.04.01.08.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 08:13:10 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 1 Apr 2026 17:13:07 +0200
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v6 2/3] vmalloc: Optimize vfree with free_pages_bulk()
Message-ID: <ac02A4ntuPKT7eyp@milan>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <20260401101634.2868165-3-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401101634.2868165-3-usama.anjum@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E0CBC4000B
X-Stat-Signature: ipexe19wya15o5wydni3664qdoa5ria1
X-Rspamd-Server: rspam06
X-HE-Tag: 1775056398-262663
X-HE-Meta: U2FsdGVkX18BsrmxPRwzvZ9NjhxcAZEnh7uyBHt49W1VbHq4VNyzDBTp6t0cT5HmlFnaRemgxTO9vJGQhSBgjdr4PxGE9CXpQMtWIFBgvtHpu49dCF1HZ5eLsrb9yCajnNldKRogMkJp9H9o4M41hj2y6Ast2e+4u4rerKyF91l5g1xc4mKVvy1aUZ8TQpmgn1ZFzgTFlK38cHB6KFFsHSovkSoUjIba8o9Wkg4QTExIwI4ZmIRiD5+ZDeWbYFShDKTAfPnIiSy8y21shF+Igu+KzsgoI5MngZxe31TJmWKTPsuOu2l9GRrN26EwaaBZDNkv968CXT8r2tqj2qUrqWzsQTEAsIob3a7uhRATCLkASTwu1/4w4NLrueUkeNsw/RCtdfItaTd6/ZMSLnBhvtloX5Q96XtdNQm4xyqqrTda/HLr/IXAGKxQAnRd8Wq5Q038ZmSrDlPNFSWhV51OHeuKn/SFv9YSAFcq1LasrlH/yMdjxUZTN9ml8UFlVLCsO55fLmwxXdlYBfaEGtktAO2puoKkuZR4zKw32mJYKr4B1PTXH3QC/Uzj1rBk01YoqmtZ4sbAJhRzRkllcGWR3xGmN8hDM/7NYT38Nj6z9341F/iSfC4LWXGWaRw1XDxYGXb1zQLxRlIVAZz2T7OgSV6bMDIx2n8oRBUEU9twpybzVelgUqxfZUa5k45WHyYkY5133PWMvgyhUNafFu3YXEtJ0ttmB0dAfPZ2Y5LUkl2Ml6p14iYbNccwceNU7RFFdyz7ZpOOfkZCa/G7dS9AjZtCmMv8hA3rYyiAB5+orJxNufzj8aowG4YbA0L3kwPWqfEulEKC3JRwVICANxUYc+O+VzjSj5BNQl2HrDE0eK/h9ZWMJzERVJHhXbgdD7XZORITyBZI/QiaOJX2xlOF8dDxJSgufzIg18l5O3HRdGxqsb2w+3/EunavdhhH9pXbW/cIYBE/mxTa25YCRe2
 MZ7QBGHj
 eXtnNm+kwVXBh77xMBfkuto6Ia344OPxD2tHs0VZhw1uxfamP+hhofAFLSl9sDi2FC5ePoyLe9S7FS7mkz1w4irRFgZxIUAIa8prI9o73Hn9BTGrY4/3MdeEm47Q0sLhkADY3dLaNGztAt6bEsV3OfFKkqjnMF0dPd+GnPcDL+TOg69zH4pvEmZajLcQdQm0qOp490suL90fBgEJik8teX8/2yedIG65EKqz4Q1e9xYfM9GffvuFbawJ15WCOGXu0vPA9jqt/MO9nx9D0UJQBoH55kLaUn4IMULaHbNzIc5x8vNtuDL99WsD2P4WcH4UklthdXQAA4pfL5R7c0pmu0MQTL32TKQOy6PtUlrz99bAd1zf6+5fTkfjWOJ11hjS5MskyuVFRVs5mn1amcZzcQGwYmh97SWiwehXn+6XYvdXKDF3Qprqx1vVAo5H9FxhCtAlZbXm3WrW/JorEgH/E6Xs3IVwI317S97rO37mICwp9LefGHTLCPme/AKkixgfHwcGZJXjs7Wr8+yDdc0EhnZB8IhzjEtxNSLEh9AOUEOUYxNaSNn2UYHR0HjR/fv03MD/Ud944fJ+QeILhlhfD+er1B0b5pW1tkRfXqAXW99Vci0yskpPfp75L6zqfr+g3SXbcQatU1VAjSUf33tkiepO4NOeXiPtejCJJIkm/iV/zakoOTw6O7tQzpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 11:16:20AM +0100, Muhammad Usama Anjum wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
> must immediately split_page() to order-0 so that it remains compatible
> with users that want to access the underlying struct page.
> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
> allocator") recently made it much more likely for vmalloc to allocate
> high order pages which are subsequently split to order-0.
> 
> Unfortunately this had the side effect of causing performance
> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
> benchmarks). See Closes: tag. This happens because the high order pages
> must be gotten from the buddy but then because they are split to
> order-0, when they are freed they are freed to the order-0 pcp.
> Previously allocation was for order-0 pages so they were recycled from
> the pcp.
> 
> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
> that it also frees that order-3 page to the order-3 pcp, then the
> regression could be removed.
> 
> So let's do exactly that; update stats separately first as coalescing is
> hard to do correctly without complexity. Use free_pages_bulk() which uses
> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
> This not only removes the regression, but significantly improves
> performance of vfree beyond the baseline.
> 
> A selection of test_vmalloc benchmarks running on arm64 server class
> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
> large order pages from buddy allocator") was added in v6.19-rc1 where we
> see regressions. Then with this change performance is much better. (>0
> is faster, <0 is slower, (R)/(I) = statistically significant
> Regression/Improvement):
> 
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
> +=================+==========================================================+===================+====================+
> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
> +-----------------+----------------------------------------------------------+-------------------+--------------------+
> 
> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v5:
> - Change subject
> 
> Changes since v4:
> - Use num_pages_contiguous() instead of raw loop
> 
> Changes since v3:
> - Add kerneldoc comment and update description
> - Add tag
> 
> Changes since v2:
> - Remove BUG_ON in favour of simple implementation as this has never
>   been seen to output any bug in the past as well
> - Move the free loop to separate function, free_pages_bulk()
> - Update stats, lruvec_stat in separate loop
> 
> Changes since v1:
> - Rebase on mm-new
> - Rerun benchmarks
> ---
>  include/linux/gfp.h |  2 ++
>  mm/page_alloc.c     | 28 ++++++++++++++++++++++++++++
>  mm/vmalloc.c        | 16 +++++-----------
>  3 files changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 7c1f9da7c8e56..71f9097ab99a0 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  				struct page **page_array);
>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>  
> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
> +
>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>  				unsigned long nr_pages,
>  				struct page **page_array);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fb4522ba51faf..6568af69b5cdb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5175,6 +5175,34 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  }
>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>  
> +/*
> + * free_pages_bulk - Free an array of order-0 pages
> + * @page_array: Array of pages to free
> + * @nr_pages: The number of pages in the array
> + *
> + * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
> + * run are released with a single __free_contig_range() call.
> + *
> + * This assumes page_array is sorted in ascending PFN order. Without that,
> + * the function still frees all pages, but contiguous runs may not be
> + * detected and the freeing pattern can degrade to freeing one page at a
> + * time.
> + *
> + * Context: Sleepable process context only; calls cond_resched()
> + */
> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned long nr_contig = num_pages_contiguous(page_array, nr_pages);
> +
> +		__free_contig_range(page_to_pfn(*page_array), nr_contig);
> +
> +		nr_pages -= nr_contig;
> +		page_array += nr_contig;
> +		cond_resched();
> +	}
> +}
> +
>  /*
>   * This is the 'heart' of the zoned buddy allocator.
>   */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..e9b3d6451e48b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3459,19 +3459,13 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
>  
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
> +		for (i = 0; i < vm->nr_pages; i++)
> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>  	}
> +	free_pages_bulk(vm->pages, vm->nr_pages);
> +
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> -- 
> 2.47.3
>

LGTM: At least vmalloc change

I do not see any concern(mentioned by AI) if mod_lruvec_page_state();
is invoked in loop without cond_resched(). The operation is light and
nr_pages can not be millions of pages.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

