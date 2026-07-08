Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC7BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26E76B0005; Wed,  8 Jul 2026 07:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8B36B0088; Wed,  8 Jul 2026 07:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0A66B008A; Wed,  8 Jul 2026 07:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89BD26B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:59:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B6361C8110
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:59:00 +0000 (UTC)
X-FDA: 84965463240.20.F636B09
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E222140005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:58:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CUwyF+Sd;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783511938;
	b=TM1JfE8GjTkqibTi66JsJiJbFJeRvdBzSlcBVMMrziNvJdfWExZaPI2amxf+d+E4tfdORq
	xf5kIJX9BGtNp/fiRQ8Hve9S25KeK9qarAOT6edHrAvvNIl8Y7bUfkVXaHimGHfdL0emal
	5PXyol8rHurJZUtvTCKWhu3x2PNkW6U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CUwyF+Sd;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783511938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Kf3EofRDITTaRJwm6sW4nnfT4qFNk7C4XIMhYPG6Vs=;
	b=f98ASIW74jWxPVbKW+VcMLY/L4hF7YRfbkcPHGYl1nG8Jon113dUjLPV1DcJF1wO3XToR3
	dYF8QyTf4A+yJH63kOzZKySwogjxt0zYhf9G+gJkgzJaGVQqc8nnQ8DgOfG7Q9p99Q2X7O
	Zn1OYSNxP8whWye8i3b2stuoMtr8xnI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Kf3EofRDITTaRJwm6sW4nnfT4qFNk7C4XIMhYPG6Vs=; b=CUwyF+SdxF25bXCDrLcrFgyyyR
	v6U3S3r9IUzd4lXJmS8eY85l7huJukUQlsaJXjUh81DKpfl/fdWOjtsdtCOvlnx0SwcJIaKB7e6Pi
	DdgW5P78XU5Arbpw85d77jbbcogHEw58jKz0ol75zO+fLGWdutWVisEiCfAXHNuAm2pjNh8iran1P
	3pysIttD3I4lvB59Az3PaxKY0Mlb5KfyIy5XJZD1bP9S2xC7Om/NF4u3H9dlfFho3Ah+Bav1QhvCX
	tcltfz5uYhrGIXB6eeJCZ+Ys40kQqMqenEjmJzUfq6xku7x2Jc90OrRkwXLg4iXhGww2xY8H4V6io
	f6nufLaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whQvW-00000002Gc6-0lZF;
	Wed, 08 Jul 2026 11:58:54 +0000
Date: Wed, 8 Jul 2026 12:58:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, jiayuan.chen@shopee.com,
	yingfu.zhou@shopee.com, Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15.y 6.1.y 6.6.y 1/1] mm/vmscan: flush deferred TLB
 before freeing large folios
Message-ID: <ak47fZui1es8Lobz@casper.infradead.org>
References: <20260708041237.289026-1-jiayuan.chen@linux.dev>
 <20260708041237.289026-2-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708041237.289026-2-jiayuan.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E222140005
X-Stat-Signature: mnjdk81a7g5trd6so4pbf3n79z1s7wgx
X-HE-Tag: 1783511937-3196
X-HE-Meta: U2FsdGVkX1/Tw8fiPsVOepdDkSxQCM5bIqjlW2jN/mBIxEEU4eGbyQc38f29WU+Yd+sbYDWkCwUP7FPfZh7aroUddTnFspDmZvQWI6YV2M0UoEb8NwJTtQ0NZMFApI0ZPcKgS8B8+Rl+3BygQGmQBwxUNv2UDI+dvek2NtA1+ZaRaFWn/yfTQ2bQejfaez/nxIm6oTFNymvF9n4+z1HuZUfmcklThiGLIJ+7o/g0XlYGUdssT/LB00zrHpr4Q0QsvDmj29oCfiPGz97aV16GEpF5+i/9z/HCTHC18TpkZNpMas9aeXMbknA96/K0fhEVvJ6OPQKKE2meWkDY0gOEsGm8t5gKK1KuU8XxxC4pozo9SD/KGU5L0T4CIBTrHp9NQUNc04EBDE/6l9+QUS6JYA6jZOZjM8yO++eE8TSkOdgt6RsagZbdZQM9A4JpqPMVTyphMJrPrevEAT541UOuJCoy5c7EOKNokLBN/EL9XogWtTo/nXuWZokqwLxHNKENyRq/KyaEyNBVPMRyL27SRSwUECl86uJpw3a855Phftewrd7h/K6e/RAtg0peRlDedm32JWFjDD/I3GMKEdauPNhw1murPsMHz64ckFxuvlulJeg+zD0ABY5YMM6kHjPhEPD1nVT/UtjhdUo2gK5u8tb94NnxZV9lk0Up0TEhEwfxNvTHST8YsED3GiJnj4xNS4BOzrp/2TbphpRj0Ok2VItX4oOGYoOYUis58gMEMHl5tFm+DVDBfSJWltRWitiWaMPjs8e4LX2nAujqC4nhW/WJmpBBTUqz7bOJQYWZs4j7OZNrwwODyTTFeI9hStHvyt2y5wKjfn5gPyyG6MIbqx/vB5CSoMOdkO/CxlLophY+uupVtaxc0lf2bXVj2geSG9m9H9SVcTlUc+GRdrfFz5f5UQe4Wt33p10ROZcg7+QRBPHC3sa7wy/U3LeK8jqQ7EpgH16p/U/ZW4YxhlK
 VOTUnBD9
 sXFwEQ5pYqCus4vy4h/UwiYHEvYWTYLEmSdNuMCQs6cqLoEabS0Keo58qXI/T3pVZw4H1WPopPA3Y5asmm6C187c1KIZuWctZ3JoLXdUxu6tt9I/5aWdoZtnMsIHmzWlpyhiX3clI/pQyD8/lQrEPQWpEhejICtajhiiQ31/APnt5zeZa+3Wrs31S2zwZ44wrvrQHhLaXRQkR6tHoOjcDtQ80bLOBEWvs6leGICx+JyptcSu3vX6IWrxDcfJGbLNQD85m5n8nZKCTSibgpVllOIXp3YetCwtMLkxXJjjUoOit1AQw/rxtxvefPnLE+psFhej1oq0Lkh7I4kIzrJHwvfrVIjsXe3Y/nG8ugFvL+wl8c20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 12:12:36PM +0800, Jiayuan Chen wrote:
> In reclaim, shrink_folio_list() unmaps PTEs with a deferred, batched TLB
> flush. The batch is only flushed by try_to_unmap_flush() near the end of
> the function, just before the order-0 folios collected in @free_folios are
> handed back to the allocator.
> 
> Large folios don't go through @free_folios -- they're freed inline at the
> free_it label via destroy_large_folio(), which runs before that flush. So
> a large folio's pages can be returned to the buddy allocator and reused
> while another CPU still holds a stale TLB entry for them, and that CPU then
> reads or executes through the stale translation into the reused page. For
> file-backed large folios (e.g. executable text) this shows up as random
> SIGSEGV/SIGILL in user space, with fault addresses that don't match the
> code being run.
> 
> Flush the deferred batch before freeing a large folio inline, the same way
> the order-0 path already waits for the flush.
> 
> Upstream this is fixed as a side effect of commit bc2ff4cbc329 ("mm: free
> folios in a batch in shrink_folio_list()"), which is a larger change; this
> is the minimal fix for -stable.

I agree that it would be wrong to backport bc2ff4cbc329 and all its
dependencies.  And free_unref_page_list() only handles order-0 folios,
so we can't do this:

-		if (unlikely(folio_test_large(folio)))
-			destroy_large_folio(folio);
-		else
-			list_add(&folio->lru, &free_folios);
+		list_add(&folio->lru, &free_folios);
 		continue;

I think this is the right fix.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> Reported-by: Yingfu Zhou <yingfu.zhou@shopee.com>
> Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
> destroy_compound_page was recently renamed to destroy_large_folio.
> So it would be conflict when this patch was applied to 5.15/6.1
> ---
>  mm/vmscan.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index aba757e5c597..8eb498351d9b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2123,10 +2123,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>  		 * Is there need to periodically free_folio_list? It would
>  		 * appear not as the counts should be low
>  		 */
> -		if (unlikely(folio_test_large(folio)))
> +		if (unlikely(folio_test_large(folio))) {
> +			try_to_unmap_flush();
>  			destroy_large_folio(folio);
> -		else
> +		} else {
>  			list_add(&folio->lru, &free_folios);
> +		}
>  		continue;
>  
>  activate_locked_split:
> -- 
> 2.43.0
> 

