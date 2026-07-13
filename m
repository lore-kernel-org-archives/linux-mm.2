Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C3BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE616B0005; Sun, 12 Jul 2026 22:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6736B0088; Sun, 12 Jul 2026 22:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD866B008A; Sun, 12 Jul 2026 22:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A54E6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:38:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE2449366B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:38:56 +0000 (UTC)
X-FDA: 84982195872.18.62C039F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id E783F1C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:38:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783910334;
	b=xlBMbQFBMj9mjdAeNlXt0AT7KYGOZJKazUpUps92ppDcK48Mm1DD2E2WUvcmvitOplkD+p
	/NOiuUX+xY3p00V1zUFPin58nHFgMjrHsOIC/blv/ji5wBCyJ1fi8BNLqZs4b8ZPpta23d
	lrwbenyFZii8cjX5qZPfnKrg3HxCDzA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783910334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=reGdW4GIsMG3hXOZXCkiZVvgj8dwSNlnJOL8jlW/q9k=;
	b=6rNw3JQDoIla3yQGykyxJBWaz/z+2pzmYUtEj8UdfGMpgzvF90iJPD0j5ByY4sepRh8bax
	/hCsE4H6RnF+5g9sHnqrw67/C2CmMQkHh/4/JHt4nzGohfYSKH+LcqUlz5njwQJe+Vh/LD
	2vB4EXDMuZXHulGDGYXtIUkHnUDuZDE=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gz67t6B6Fz5B12j;
	Mon, 13 Jul 2026 10:38:50 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 66D2chC1064193;
	Mon, 13 Jul 2026 10:38:43 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Jul 2026 10:38:44 +0800 (CST)
X-Zmail-TransId: 2af96a544fb4856-fd9b1
X-Mailer: Zmail v1.0
Message-ID: <202607131038442429GlPO4g2vt4skkmMC6RNn@zte.com.cn>
In-Reply-To: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
References: 20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org
Date: Mon, 13 Jul 2026 10:38:44 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <pfalcato@suse.de>
Cc: <harry@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <vbabka@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBzbGFiL2Zvci1uZXh0XSBtbS9zbGFiOiBzaW1wbGlmeSBmcmVlaW5nIHJlbW90ZSBvYmplY3RzIGluIGZyZWVfdG9fcGNzX2J1bGsoKQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66D2chC1064193
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Jul 2026 10:38:50 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A544FBA.002/4gz67t6B6Fz5B12j
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E783F1C0004
X-Stat-Signature: iz8gjd1p9jmbztpnyjsgj6fpp8k6qj1w
X-HE-Tag: 1783910333-293441
X-HE-Meta: U2FsdGVkX1+wZ/8jUPi4IQsqjEpm6ISQuyh0x/+ZhU1v4RWlePApkT6amGASAAX4doWDI1/GISmPNJPUL52ektNW+LNy+SmL5qcuk+SkG8fxndHxbRbt4zLslG3nGB0F+vhOsDWTMLobZVNCaAVsSEAaGUhtRstE2UqGSz8a3QO4OuAG1spQeiyqbjpCN65IZN8aoYyvH+wQFwhVX4N1kjvKEqqRmt85ZmuRBkBH+z7/sS45W7hFOYrRsc4y1ZPHuSmaiR2UNlehWLnr+nbxgN/ff2X6SDUL5mTZQmLFrmN8CQuEsusAaNwGa54cxJE0BP0qfHAxH9pJRdJfC/KQbLkwqgl2MJA3Cj46EaNLYrgbsfwRFbqgE4IHUDrB2nL9lsCxZquYqOp5vPF9w+EfcLhQ81jplMlwYPWU58BdnIv5twD3UgUvpG8u5rDt2khbLngjRw0AWKhf/RvSftPtvo2FVC7+sEsXRkcD18Ghk91havTbRv8Yqz5XSynxDX9w03apHrmrD7wwqDtzaxz0lmJ2VecNLJt/Mj0FDzr989m9BOqfE5UHithvlVJrtEfLyaAbRln1F+ad4KSoWhmq2EOkfKPNaERVrlOdsc7krevStXxAM3+Ur1SYSnQx53MAM9+xw2mTAjS4Ku/9huxkskaml4AsMBRKFTHX38oHfgGXZG6pofWpZuPdr3eC06gNonEW+YCH7B0ahAeyUbM1fHUOSz4bzD8p3WeRxdjRVYqtI2Ddi8kvZHR+4frg0m7QAXp2rlVpKmGuyQUtYzCOAr/KG+gsY6+BDpq/IYzWbFYctssAPr+3zBdSyBs9ObPd0RG8dNlSyRh624XEA6xoyrxss4Jb0IjJCcwveRRxgUD3epumEUUh680OAZQl5Kg3bHRFJIAXkc+k/wzrARs3JQJFdIY76VxK3Ff+5BECIYCQQ1qro6NbmP3bMINRoWKOHHna6agjA/PWNggktXU
 9FnFHH9H
 NHX0r9/4MWBvW6cgYjZN0c/Pbtv9yWmRhOBc/hS8Od8wDY3akrM7DMAprBKqbOiy5rBYG7dmsUub8pBThhrhztcwlnCYCObJQBnaQ9DYc1iSNdYDVz0l6dFyMUeM4Gqcz0FWxJkAM4OZ6ZUWC9atjvz+8O5+NdR7E8Ye/UCyl3S09gGAV9I2tc3Lu1hKJFVHXb7SAU0TWsbZFEgxtxlQXTyDFIahKx0iU64UmC9kJZcYjds8/SRz4x2YLzGdXTJlRX3xXnZFWZ7GwNDBoca0+d7WDRpBg/K/5SeYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil wrote:
> We have been moving remote objects to an on-stack array and flushing it
> when full. Instead, we can swap them towards the beginning of the
> supplied array and bulk-free it just once.
> 
> Also add a comment to explain the rationale of freeing remote objects
> last, because now it would appear to be simpler to free them first.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Good idea!

> ---
> One more cleanup I realized it's possible when processing feedback to
> the previous one [1]
> 
> [1] https://lore.kernel.org/all/20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org/
> ---
>  mm/slub.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 22045dc919ef..966d2fb114e8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6255,7 +6255,7 @@ static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void
>  static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  {
>      bool init = slab_want_init_on_free(s);
> -    void *remote_objects[PCS_BATCH_MAX];
> +    void **remote_objects = p;
>      unsigned int remote_nr = 0;
>  
>      for (unsigned int i = 0; i < size;) {
> @@ -6270,19 +6270,17 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>          }
>  
>          if (unlikely(!can_free_to_pcs(slab))) {
> -            remote_objects[remote_nr] = p[i];
> -            p[i] = p[--size];
> -            if (++remote_nr >= PCS_BATCH_MAX) {
> -                __kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> -                stat_add(s, FREE_SLOWPATH, remote_nr);
> -                remote_nr = 0;
> -            }
> -            continue;
> +            if (i != remote_nr)
> +                swap(remote_objects[remote_nr], p[i]);
> +            remote_nr++;
>          }
>  

I had the same thought as Pedro: the in-place partitioning is correct, but
the partitioning logic is not immediately obvious. A short comment documenting
the layout would make the code easier to understand and maintain, for example:

/*
 * Partition the array in place:
 * [0, remote_nr) contains processed non-PCS objects,
 * [remote_nr, i) contains processed PCS candidates, and
 * [i, size) contains unprocessed objects.
 */

With that tiny nit, the patch looks good to me.
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>

--
With Best Regards,
Shengming

>          i++;
>      }
>  
> +    p += remote_nr;
> +    size -= remote_nr;
> +
>      while (size) {
>          unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
>  
> @@ -6296,8 +6294,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>          size -= batch_freed;
>      }
>  
> +    /*
> +     * Processing remote objects last decreases the chances of cpu migration
> +     * while freeing to sheaves and compromising object locality
> +     */
>      if (remote_nr) {
> -        __kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +        __kmem_cache_free_bulk(s, remote_nr, remote_objects);
>          stat_add(s, FREE_SLOWPATH, remote_nr);
>      }
>  }
> 
> ---
> base-commit: e1fa26489025d6deac76d1dbfe2e0720a3ad84b1
> change-id: 20260710-bulk_free_remote-7fbe6f3abf5d
> 
> Best regards to everyone but Pedro (btw this is not hard-coded,
> there's a config option for this),
> --
> Vlastimil Babka (SUSE) <vbabka@kernel.org>

