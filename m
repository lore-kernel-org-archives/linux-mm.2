Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D9CC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695776B0096; Mon, 20 Jul 2026 13:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F146B0098; Mon, 20 Jul 2026 13:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF016B0099; Mon, 20 Jul 2026 13:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14E776B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:42:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8647EC025E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:42:20 +0000 (UTC)
X-FDA: 85009874040.26.1D88BED
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE1BA180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:42:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j1pacumg;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784569337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEiCtTnsRTKK1dIfrBs2bZV/1x4AsbAJwsKiFa/5Flg=;
	b=zCJz4gcG0hUfIXjJWkbjxAWmqoFAeIRdDU5wla9T+b9k3WGahpU1NIC4JN7C7jFDbMBl7r
	R1+5Bp03JSRFPh4rZZK80bTsEFIWHqiy1JdsadMFmfQb4JpFMsyKSRJFLkpvWt/tb1L/qE
	nYz5JIgK6G7NH2kkOhuSrImPx96gXu8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784569337;
	b=xFkPvnfipHcZDT2+lEQeV/xvT4FOpQz7wlkdVLglewMJCaYmVcxcBeQCetYvAM8I6BATyU
	TQqDGsLwJlTlcsclsoAONPZuXA00+66SdYeTETAiDAq888t1x0AI7RtnccFnnuhy6j1JWC
	HmuT1nU1cyYuUq7aZFfP/EDus1E2SN8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j1pacumg;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f23e851626so111968456d6.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784569337; x=1785174137; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEiCtTnsRTKK1dIfrBs2bZV/1x4AsbAJwsKiFa/5Flg=;
        b=j1pacumgL0Au+ty9/lJ/k1nPxVFqkHaaIDCEAXwReWtv4ZMEnHK7CV4Kxjh2CrVhjo
         uBxADcB6p2h4tXREs6o561XT29Mf/jAnjXrh+x0s3GWyMCBDTRLXpgZaGKWhl7Kfq5b0
         HFS+VeCrYpvh0v+9WrMSztMvHLOlmuVJFEqbgCLiWlZGy/WrulrvCZ9wMMi1knT+iH+b
         NyZuoIplXvTlVFRM3PYSlyqu9Oe6B2BiBdBeXk3I0KyBVx87+O2v2cCpMvkI0Woed5qh
         pyjfj9JKD3o24v9wxphQzaBm6wLD659ShRNGy3F04fUg/p//PyI1YkQMMDpUyuN+hQOJ
         /2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784569337; x=1785174137;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEiCtTnsRTKK1dIfrBs2bZV/1x4AsbAJwsKiFa/5Flg=;
        b=rZ6DoR5XFD4dMmLN0GT/koscrJSWk/89OrXYGTd7qQ3lBkP8ErPxH2+nCnL/eMzkOl
         ZjaNfd8WO6pNjnqwdXMUUhb5vmitFhH88fiqaVZ9xCIakl3Hv5TMzTPYI5rSetjB3mtR
         uSI4SqkAyVVv6YOI7/1no2iMCMMrM/FPoqZS5N2Swn4GGAckzUxng5JoPEV310eJWJK4
         UFH6OksVL4IR0I69tNrVWSTq5WTg9urFJpRHwE+opY90/9vWU7sySe2ER+rMDA/OiM0X
         PINfhc8VeclsMo9K5WmouBmpLzBwwClK15RlDDreRWc+jU2a63xzIAaftttyryv5fq4Z
         7SeA==
X-Forwarded-Encrypted: i=1; AHgh+RoQmq7CrNH+EArjlwFhfTFmZDubk9qkddDvUXaumPyf4bbDCLxHzsgzckF2KVoX/lU7vFQwv07G5w==@kvack.org
X-Gm-Message-State: AOJu0YxjiUr+Aly2EbWlG8bs1dXaHpRq5kRZbLYr/yF+N1AgC9Eujxhj
	UxcjbGQlMIE0ymyUpCX9oMmPKv6P0FLE8VCx1lQH6/M11wu3ko3oernIjVm5Fz0wBLk=
X-Gm-Gg: AR+sD10OguXpHCGMFp+r9lVAEBmSRAb+cRu6c+2rq4zwCbCeyg79PLydic9R/Fs/yi3
	rpX8oKXON33Tu2K8yrp2wS+RozgfZhcMtEnWHOXrwz+0YQN73crHghQ/BrYONbkfFbIyQ1huNrL
	X6HrUOnH8pajzq/PRtBPahxqoy9BsjIHcNIklOvyGB+38tqJbtRS5FQEUQZP8CozixHh9tljuzt
	wPwl3mwr+nqvQCm6ixkxzNcJ1M6EpVQKKWSdz+cJD4akmsChrmZxYP8qq/udn2MqBvNuGg6aJSK
	JNE4AHMx8Ue9LAlks4XvLMqMtMNaRl1Dek6CSJ0CuCevXqbEv+qGuEmrBSPQxlhS2HMuPr4nrl2
	dsrZo+BcyBinFkBAvlYKWr+KcTVe3BABy/ronr7snyPKk5Bu4mIEF+lMO5W4nXhCcttuhJ+aKUK
	bxS7RuiiT553EcT59ykmwa9V3PtRCyvs9MUPoBu3ixYxfjt5E/8cetVEY4hg==
X-Received: by 2002:a05:6214:2349:b0:8ef:6b06:44c8 with SMTP id 6a1803df08f44-907783d1d3fmr150837746d6.48.1784569336788;
        Mon, 20 Jul 2026 10:42:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90778567f09sm95835516d6.15.2026.07.20.10.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 10:42:16 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:42:11 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] mm, treewide: replace __folio_alloc_node() with
 folio_alloc_node()
Message-ID: <al5d1K9yHhT2-yVX@gourry-fedora-PF4VCD3F>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-2-5363b8e92d33@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-folio-alloc-cleanups-v1-2-5363b8e92d33@google.com>
X-Rspamd-Queue-Id: CE1BA180003
X-Stat-Signature: t4befa4egqtsq1zjrr4w413ofrp4qipu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784569337-911321
X-HE-Meta: U2FsdGVkX19tTDbuMzEQMpm5CmVtcrZ1iKYZn/LXT19cVzGYOYktsG6I6NdEFJmdnntV2K4GcK+lgqTH26zph0l8klWzwY2Z4hLof8H8LHFVf21uBkYnAhlQv3X3ALuiELRePLm8Iq5G03lLzHiU/KluDJ6dqR4HE9cP5a6Sj8azJl7an/FmljmdbBd/gh/4RS2n2LLACWtcJZyKubKD88EP7QT4FIFX1mVuHGTHPDdBgXFxM9ikM4ykNBEmPaAqJq89VWoYVdxvqkvWwzsOGLMaUa1GPxGYqpjESWabJXLzdk8/u2Bj0D0ZyUqBL3C61Hab2G1x9tPX9ardFzXwhTH6YvUra9I9/k6SCNsw0rczhxQu2MBqiT9sroIF88ByUHJ4mDeFX9O2gJASDpYLnii3cOT0M1kUMYfw4QOUWsT0sPjHVwVsmgd7m2dgjwVpnJKHVCLYnaTrBrBWJtAnLUh+ny8jsGjhKGustROmM7jwCEmNX5uCurf0nIRzu+MnlD9iVM0jDOqupoU4rFbHQLU7gEzirb60V55m3HniR1KH2jzjqbP9F9NMO+AfV6katM+KUpy36IhIxvY+ueEbKq16zLCdlNxaoPKdxkIwuhZbbMx2xL8HLRMcQ/afz5tTIa2kfH0BYjFv7/beB5edDFmSlM2pABz9RoHztXTbd20L0IqdF+1zrQiSiEaEI8jozq18VbqfI1jsyyC1meDkpLsPsrudhbDcvYQOpUzOpap84OwnO74Zmu9yHw1lK3xeuFX206YGAx/eCJQQPFArKYqjxYFyj+Pqi5WYZj9zwnB2pjukd1+3x0+xemOduVs3rYwQTanj9TdlEOddilsH7vePKd8/fZ4BQaavrDcwd3agE+1j9BejcYQ70b8Lz/rD/80V7LnLQOHz9T+8E3hZuF0kV/P+HMZtb2BR5NsFx8ACONtmUxBM7RU6GQlv6SNfSYQab0QLYF4cxxkjX2u
 8uGnR6+Q
 bca/IYg6meWgvnOYkL8hSMbge/UFtUiv0+GXB+xoTqe4I59NaYOdXLYpGKzOePzlC9XfFh3cNvvTj2RG0OtWIdz1F0an8Sq6T0p8YAFYUAE2JgpCtjRuECEsEGgGWLAR+az5XbhmIdiMaYmxpZLTUBiLB0EnkroMwK5bMiEZn1a2luqfEweGEh0VjDZN3IDumXwreAA/ZG36d+eXDwSi834cyQI3borNkdZtlyGYcEJzmwCZrg7Gpovk0pWs8yiWKg21+hNnfObvj6oSnxoGNI3IXGutA1/hyIDghpYf2ykASu/96hrZqV7jvVD01xDPEKJGlchY6zPVdho3h0PG2rtr/kipoW5k1idd0EmANkN5NyZMreO47C4QRTtkH6Z+04y+PEn1lEPzKAdCFPMyhsz8kAcn+maPkCcjRekIn7S9y3+vxx/fZ/GJ4AscU6K5XBfWHnGB8ziaaKQT1u5Vsi2mAsB2EZjSj12qWqI38PqJUiW5mbtfikP/M7H7OcT1p4TFDi6PNIAfe8YGC5xzMnvM6YD7rFhA8IbSIqFfDZQdhgIswkEtcFFayPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:30:11PM +0000, Brendan Jackman wrote:
> Commit 5b584d2d22dca ("mm: remove __alloc_pages_node()") removed the __
> variant of alloc_pages_node(), after users had been migrated off it,
> since it just complicates the API (requiring users to handle
> NUMA_NO_NODE, or risking hotplug bugs) for no real benefit.
> 
> This patch brings __folio_alloc_node() into line too for exactly the
> same reasons (including the ulterior motive of freeing up the __ variant
> for use as an internal API).
> 
> This time, it's done as a single patch because A) the users are fewer
> and B) folio_alloc_node() does not already exist like
> alloc_pages_node() did.
> 
> No functional change intended.
> 
> Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  drivers/iommu/iommu-pages.c        |  9 +--------
>  drivers/irqchip/irq-loongarch-ir.c |  4 ++--
>  include/linux/gfp.h                | 12 +++---------
>  mm/filemap.c                       |  2 +-
>  mm/migrate.c                       |  2 +-
>  mm/page_alloc.c                    | 17 +++++++++++++++--
>  net/sunrpc/svc.c                   |  2 +-
>  7 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
> index 3bab175d85571..47e0759f0e0ae 100644
> --- a/drivers/iommu/iommu-pages.c
> +++ b/drivers/iommu/iommu-pages.c
> @@ -56,14 +56,7 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
>  	 */
>  	order = get_order(size);
>  
> -	/*
> -	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
> -	 * alloc_pages_node() did.
> -	 */
> -	if (nid == NUMA_NO_NODE)
> -		nid = numa_mem_id();
> -
> -	folio = __folio_alloc_node(gfp | __GFP_ZERO, order, nid);
> +	folio = folio_alloc_node(gfp | __GFP_ZERO, order, nid);
>  	if (unlikely(!folio))
>  		return NULL;
>  
> diff --git a/drivers/irqchip/irq-loongarch-ir.c b/drivers/irqchip/irq-loongarch-ir.c
> index 21c649a89a706..427f7fd3cad42 100644
> --- a/drivers/irqchip/irq-loongarch-ir.c
> +++ b/drivers/irqchip/irq-loongarch-ir.c
> @@ -384,7 +384,7 @@ static int redirect_table_init(struct redirect_desc *irde)
>  	unsigned long *bitmap;
>  	struct folio *folio;
>  
> -	folio = __folio_alloc_node(GFP_KERNEL | __GFP_ZERO, IRD_TABLE_PAGE_ORDER, irde->node);
> +	folio = folio_alloc_node(GFP_KERNEL | __GFP_ZERO, IRD_TABLE_PAGE_ORDER, irde->node);
>  	if (!folio) {
>  		pr_err("Node [%d] redirect table alloc pages failed!\n", irde->node);
>  		return -ENOMEM;
> @@ -410,7 +410,7 @@ static int redirect_queue_init(struct redirect_desc *irde)
>  	struct redirect_queue *inv_queue = &irde->inv_queue;
>  	struct folio *folio;
>  
> -	folio = __folio_alloc_node(GFP_KERNEL | __GFP_ZERO, INV_QUEUE_PAGE_ORDER, irde->node);
> +	folio = folio_alloc_node(GFP_KERNEL | __GFP_ZERO, INV_QUEUE_PAGE_ORDER, irde->node);
>  	if (!folio) {
>  		pr_err("Node [%d] invalid queue alloc pages failed!\n", irde->node);
>  		return -ENOMEM;
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index e4e974a6e5f90..572605d84e30e 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -251,15 +251,9 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
>  	dump_stack();
>  }
>  
> -static inline
> -struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
> -{
> -	warn_if_node_offline(nid, gfp);
> +struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid);
>  
> -	return __folio_alloc_noprof(gfp, order, nid, NULL);
> -}
> -
> -#define  __folio_alloc_node(...)		alloc_hooks(__folio_alloc_node_noprof(__VA_ARGS__))
> +#define  folio_alloc_node(...)		alloc_hooks(folio_alloc_node_noprof(__VA_ARGS__))
>  
>  /*
>   * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
> @@ -282,7 +276,7 @@ static inline struct page *alloc_pages_noprof(gfp_t gfp_mask, unsigned int order
>  }
>  static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
>  {
> -	return __folio_alloc_node_noprof(gfp, order, numa_node_id());
> +	return folio_alloc_node_noprof(gfp, order, numa_node_id());
>  }
>  static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
>  		struct vm_area_struct *vma, unsigned long addr)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 0dd8e2a15d746..1cf91970a6850 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1007,7 +1007,7 @@ struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
>  		do {
>  			cpuset_mems_cookie = read_mems_allowed_begin();
>  			n = cpuset_mem_spread_node();
> -			folio = __folio_alloc_node_noprof(gfp, order, n);
> +			folio = folio_alloc_node_noprof(gfp, order, n);
>  		} while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
>  
>  		return folio;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 222c8c15f782f..b7836b02f32db 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2682,7 +2682,7 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
>  			__GFP_NOWARN;
>  		gfp &= ~__GFP_RECLAIM;
>  	}
> -	return __folio_alloc_node(gfp, order, nid);
> +	return folio_alloc_node(gfp, order, nid);
>  }
>  
>  /*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 37a3c1c00e169..86922270df157 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5435,12 +5435,25 @@ EXPORT_SYMBOL(alloc_pages_node_noprof);
>  struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
>  		nodemask_t *nodemask)
>  {
> -	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> -					preferred_nid, nodemask, ALLOC_DEFAULT);
> +	struct page *page;
> +
> +	if (preferred_nid == NUMA_NO_NODE)
> +		preferred_nid = numa_mem_id();
> +
> +	warn_if_node_offline(preferred_nid, gfp);
> +
> +	page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> +				    preferred_nid, nodemask, ALLOC_DEFAULT);
>  	return page_rmappable_folio(page);
>  }
>  EXPORT_SYMBOL(__folio_alloc_noprof);
>  
> +struct folio *folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
> +{
> +	return __folio_alloc_noprof(gfp, order, nid, NULL);
> +}
> +EXPORT_SYMBOL(folio_alloc_node_noprof);
> +
>  /*
>   * Common helper functions. Never use with __GFP_HIGHMEM because the returned
>   * address cannot represent highmem pages. Use alloc_pages and then kmap if
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index ae9ec4bf34f72..74350a2e07036 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -711,7 +711,7 @@ svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
>  	rqstp->rq_server = serv;
>  	rqstp->rq_pool = pool;
>  
> -	rqstp->rq_scratch_folio = __folio_alloc_node(GFP_KERNEL, 0, node);
> +	rqstp->rq_scratch_folio = folio_alloc_node(GFP_KERNEL, 0, node);
>  	if (!rqstp->rq_scratch_folio)
>  		goto out_enomem;
>  
> 
> -- 
> 2.54.0
> 
> 

