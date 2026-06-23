Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDDCCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B186E6B008C; Tue, 23 Jun 2026 10:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACADC6B0092; Tue, 23 Jun 2026 10:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA636B0093; Tue, 23 Jun 2026 10:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62D566B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:58:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D24561A0546
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:58:57 +0000 (UTC)
X-FDA: 84911484714.11.A52657E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7C09218000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:58:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="fagR+/a5";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782226736;
	b=x/BC2JOlQv8Je2XioNwWdkcocmAge6gU/OlDOq7XfVCDUwA92zy7192hFNu1fRd+yhd8IE
	wh27CNdPzUfjgIIFZ+6rRoqZqs0mo0MzB27T/SodpqQmkqmvnF4PldAyP6Q59zaRS15+ox
	i5TUc7aDFIzvCtKAyugFAyQT1mPGaJ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782226736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyg0qh7XOpC8lOYRF7Xo/yr2AiNxQblM/WH0eoKVCJg=;
	b=1x+2FFe+Mmm5ymo+wL+RuhtDO0MwprgwnVYd/6kpPWATJYvcJdtD1IoxOKxEiufpNd6lfU
	bSLMy/Rpdtlh++DSp0wxpxjuVta7fyAa2x7Ow7SSpAR5XUhQGocVnMwR0uGvrQcZYwvp6D
	H9m2alYYaSTluPp2yJgOF/r6DTbuSZE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="fagR+/a5";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yyg0qh7XOpC8lOYRF7Xo/yr2AiNxQblM/WH0eoKVCJg=; b=fagR+/a5Irb76NQJFtQeP77wjP
	TmETWr6hOVQN2P6yo8xF9TGFvWoS2cAWugpo5wWSuIHj1JQrUu72/yUreEGQKjo+G2Y+/VTkb6zj3
	0NRU5ZSRD4wNMSLJ9u6Uv0y5rKSpQfYg+9OpIlsnntRVM0BK8jND/gs2Lo+doipcfhuOr8iqGtmXv
	X7IBkY2ZnFyOw6SUwjDzOneoSxMWM1ImfFNm4p2xkO5ddLJLSUb6UuAJUiZjznc9GJM8ygovT4+1r
	n4e15m9UylIGcP0XKdXUzSnhkv+Fj5hIwiLT7FEYHTbKStetELbR1+zDaNpxNX/hoGxvqO37gceJ/
	zSNK0GUw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc2aQ-00000006UW3-0OWc;
	Tue, 23 Jun 2026 14:58:50 +0000
Date: Tue, 23 Jun 2026 10:58:48 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH][v2] mm/dmapool: Untangle CONFIG_SLUB_DEBUG_ON abuse and
 switch to static key
Message-ID: <nyjuexzizb4ujlwovorpqxc3o5yujckluqxojjgjns73qobddt@afnj6minfw5n>
References: <20260623121245.2221-1-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623121245.2221-1-lirongqing@baidu.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C09218000B
X-Rspam-User: 
X-Stat-Signature: 8bskoo6eh5nsdbe9roeopsyetzhbcikk
X-HE-Tag: 1782226735-734418
X-HE-Meta: U2FsdGVkX1/xbqHQUgrkdtHnVgcSeZV56Mm4m8qFdV5NetO3geP23I+htPLrOxrvsK4BBTygRkqXOCnw/QcDwi3K4GFIY3/vko7+RwzlGMWcu/AjpMCu2oRsn40ynpFWCSdDcK2kMg1vp5MC6nEkjmaESUejjuK6LJLIdcuKeMtFM/GSf5vvCoUiTeyMAGVl9oA39jIX9bL/BUvYGXdnx/qB01UrJNTE+fu1YZDEbyrxgFYHcejUoeYgSy6VdEGBidtUITWySuL5EnEx2VrBTFK0uZi3zNB4P6bvqFY4oBNeDBATYmwSZspJW92urmxU94ay5MgHJ7SCmzf95LDJR40Njn6O7qV+rjc+pzkBSAStiNdzkI1Pyxo+Bb7gMriJPu30oJN4ul87pOgqiRt1mk+geFjNXdRlK5BuaKEz8oY8pOkQij4SJBsiW/0/a04DZbWcmuNju++XcDZEMoT/+WotfRBdgkMvW4zRCNjf82pW/lJK372g5qi06KoPFB1tIqzXotqbpmYILquJjlcZ3ukhQ4j8XFw1SHaxkfmvKEpnu0rGfy4EyIgMbWW7ZaJLY2okDuy/bbPEI6gz4DQKpcikHDlQB5Da55oo3hp92woqupdQ79Uht9AHFaPIXVRG1qW16Ab4gthdnmyHouN+BSsJILqCEtQKAIhZql6E+j0+IbNjpMRubQ8vSzl0vpd/TL/EDACbihnThG/PX+1fQFDVIuAaHq7IQ8SalHD5G8tYV1MT6HjDPvWXtKLFpnGdnq86pHzb+aykWi5vr5lVlXeB8eyd4Wx2r5C0bljNMpdaQYdQz2Dkh+TPL91iZQ5b4+JZfOd8LvL/ucsY4iUd5QojuW2zV+YT+VfyJ7bHmKaOs8danPNDs/xQliYU6szjOrovjjE7eBNqDhw65ljGyHinMOxz/FjQiV3a5wyJAfs/kWUZy+fzw4G0JmK1miMaPXPvwYi+wxTFcVSZYO5
 5a3AwHjw
 erfTCtT28XylnQ/krq3fwX6zsUbAmQ9N3m8Gn2yu2XOC0CBOXmSgxYtRlWdeSk9PvIlLgr4GJgPl9ieJfqm2n/mnHG2SThDl0U+B8dh2EGw4Hlj+3m8fjvCvWAMPs/2ea/PXAqw6JUjxZzCBonktkL5yewvLw9m8AAuWPtoGhE9YwFY1ee0phvQPuUav/F5qGeZ4pPdpolsffjyT36thSr8ZVw+6l2CXt9Mj8khTfain72zgdTwH81ddqa2eyvKPcg8FiCpyP99uRJs3SDkes2tPYlIZYWp7rnZlN7ftr/ULdbbAUY+LJ5/dAZHrieUW+UzoJtaHVXN08y16jhYKHeXPeYn67o2hgKSPMcqyql+GeUsszWL03xy4CEiKYfGfm/Qqc4kTA677P7Yi0UVs/TBWu9Y4mPNzz+MnJAWUgkccoDL5adEmGQ5gG7kNbRoXCwexhvTTm18ZRCKSeXoz0YyrLwTSFtLYNBRUTgiiRxiir9xFYlI8te+raOHtGLMCnork+5w1Te+kGJPwUcXiTS0GTHgVS8AX/dP1HU1ZDeaNCyahnYvJjZWJgMmQP4Jyh/jPOyiDycjsmUp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


When generating new versions of a patch, using git format-patch -v[#]
will make the subject [PATCH v2] as apposed to appending v2 after the
[PATCH] like it looks like you did.

On 26/06/23 08:12PM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The dmapool subsystem historically wrapped its debugging logic inside an
> This approach is fundamentally flawed because CONFIG_SLUB_DEBUG_ON
> merely defines compile-time defaults for SLUB and caused two flaws:

This looks truncated? "inside an This approach.."

> 
> On production kernels where CONFIG_SLUB_DEBUG=y but
> CONFIG_SLUB_DEBUG_ON=n, dmapool debugging was completely compiled out
> at compile time, leaving no way to enable it without rebuilding the
> kernel.
> 
> On kernels with CONFIG_SLUB_DEBUG_ON=y, dmapool debugging stayed
> unconditionally active even if a user explicitly disabled slub debugging
> at boot time.
> 
> Clean up this mess by removing the #ifdef and switching to a runtime
> static key (dmapool_debug_enabled), allowing dmapool debugging to be
> toggled cleanly via its own boot parameter: dmapool_debug
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> ---
> Diff with v1:  Move the static key check out of pool_init_page etc 

Link to v1 here is a good idea so that people can see the diff and the
conversation.

> 
>  Documentation/admin-guide/kernel-parameters.txt |  5 +++
>  mm/dmapool.c                                    | 57 ++++++++++++++-----------
>  2 files changed, 38 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 19c9a19..66d853c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1304,6 +1304,11 @@ Kernel parameters
>  
>  	dis_ucode_ldr	[X86] Disable the microcode loader.
>  
> +	dmapool_debug	[MM]
> +			Enable DMA pool debugging. This enables memory
> +			poisoning and validation for DMA pool allocations.
> +			Useful for debugging DMA API misuse.
> +
>  	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
>  			this option disables the debugging code at boot.
>  
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index 5d8af6e..7bd037a 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -35,10 +35,23 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/wait.h>
> +#include <linux/static_key.h>
> +#include <linux/init.h>
>  
> -#ifdef CONFIG_SLUB_DEBUG_ON
> -#define DMAPOOL_DEBUG 1
> -#endif
> +/*
> + * Debugging support for dmapool using static key.
> + *
> + * This allows enabling dmapool debug at boot time via:
> + *   dmapool_debug
> + */
> +static DEFINE_STATIC_KEY_FALSE(dmapool_debug_enabled);
> +
> +static int __init dmapool_debug_setup(char *str)
> +{
> +	static_branch_enable(&dmapool_debug_enabled);
> +	return 1;
> +}
> +__setup("dmapool_debug", dmapool_debug_setup);
>  
>  struct dma_block {
>  	struct dma_block *next_block;
> @@ -92,7 +105,6 @@ static ssize_t pools_show(struct device *dev, struct device_attribute *attr, cha
>  
>  static DEVICE_ATTR_RO(pools);
>  
> -#ifdef DMAPOOL_DEBUG
>  static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
>  			     gfp_t mem_flags)
>  {
> @@ -161,23 +173,6 @@ static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
>  {
>  	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
>  }
> -#else
> -static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
> -			     gfp_t mem_flags)
> -{
> -}
> -
> -static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
> -{
> -	if (want_init_on_free())
> -		memset(vaddr, 0, pool->size);
> -	return false;
> -}
> -
> -static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
> -{
> -}
> -#endif
>  
>  static struct dma_block *pool_block_pop(struct dma_pool *pool)
>  {
> @@ -305,7 +300,9 @@ static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
>  	unsigned int next_boundary = pool->boundary, offset = 0;
>  	struct dma_block *block, *first = NULL, *last = NULL;
>  
> -	pool_init_page(pool, page);
> +	if (static_branch_unlikely(&dmapool_debug_enabled))
> +		pool_init_page(pool, page);
> +
>  	while (offset + pool->size <= pool->allocation) {
>  		if (offset + pool->size > next_boundary) {
>  			offset = next_boundary;
> @@ -433,7 +430,10 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
>  	*handle = block->dma;
> -	pool_check_block(pool, block, mem_flags);
> +
> +	if (static_branch_unlikely(&dmapool_debug_enabled))
> +		pool_check_block(pool, block, mem_flags);
> +
>  	if (want_init_on_alloc(mem_flags))
>  		memset(block, 0, pool->size);
>  
> @@ -454,9 +454,18 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
>  {
>  	struct dma_block *block = vaddr;
>  	unsigned long flags;
> +	bool err = false;
>  
>  	spin_lock_irqsave(&pool->lock, flags);
> -	if (!pool_block_err(pool, vaddr, dma)) {
> +
> +	if (static_branch_unlikely(&dmapool_debug_enabled))
> +		err = pool_block_err(pool, vaddr, dma);
> +	else {
> +		if (want_init_on_free())
> +			memset(vaddr, 0, pool->size);
> +	}
> +
> +	if (!err) {
>  		pool_block_push(pool, block, dma);
>  		pool->nr_active--;
>  	}
> -- 
> 2.9.4
> 
> 

