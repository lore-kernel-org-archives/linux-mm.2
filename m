Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F29CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91986B0095; Thu, 15 Oct 2026 22:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67A86B0096; Thu, 15 Oct 2026 22:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9577D6B0098; Thu, 15 Oct 2026 22:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8086B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:06:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E40548027A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:06:22 +0000 (UTC)
X-FDA: 85326849804.13.9805C5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F504140007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:06:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="w1NWNG1/";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792116381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DM0j1Lbrqa60NRLPaBXB4br70YXcjW6a6D01KGA6+1U=;
	b=63tQOd2HoXW6cBbO8vFqil9SAEvEtQ/acDzSx+youvTWC3qFgcGPEYLvI2c/TF9ogkmDKu
	cPiR4PTNtyficSgrQm4tzoFWJuIUmsy7ltYYIqZkQzQZJSz5snj5wmu3ErqV8sLIUeRCL2
	DBTJyPQV2q5wBbk1EYWZfUmPuMBDpq4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="w1NWNG1/";
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792116381;
	b=qQXsLP1zrKqVAsVKD9J9r60DyRJv2YhPvDsbYV741gzesZpBOnku3CrWa2aT4KyR6P+SkX
	0ywjndwzvmtVLr7oIEaQgzIe1Oll4hbaD4vJNuyrIUbA2y+27zqnefLhuHOZbUrfqafegE
	Rrhxfa82ax/QHPzW7tFzULpJkViEmQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 396DD437B1;
	Fri, 16 Oct 2026 02:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3C41F000C4;
	Fri, 16 Oct 2026 02:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792116380;
	bh=DM0j1Lbrqa60NRLPaBXB4br70YXcjW6a6D01KGA6+1U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=w1NWNG1/Nv/RNrG5uBWWmwMExbnwtzifIlyv6TQ0kAf/uEO8IyRlZsZYXiNqM1muQ
	 JSMD14czXOQgKshHnpMqJIjkLRFUTiii/pLf5MEvIkBJKN97WMLLVwrn69KcRd+fFk
	 VPJZk8Xten6/BZECrSMloHVqh6IYiTXgpoCum2kU=
Date: Thu, 15 Oct 2026 19:06:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Chris Li
 <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
Message-Id: <20261015190619.deccb92624e356bf81084a24@linux-foundation.org>
In-Reply-To: <20261015060528.302634-1-jiayuan.chen@linux.dev>
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1F504140007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: zjk1c654bmtjmw5rtzihy9ugkydtdgwa
X-HE-Tag: 1792116380-981922
X-HE-Meta: U2FsdGVkX18pPwOGtemb8ESWpMyRwuaCNriwGbcPVxtU/0RhmwtNamGubaVvtfU4wU3yqZsYwFgiDu+wJA+7+VxCIcWNZ5nkGlTuX/K38cp8aI/jXCi8mA6bbsQw3AeuvN5BvmqTfB9u7Vgmx7IQ13CLnro0SE0nha0knISpO2JrKg0xpmCG7nzulFWNW9AQ2kTjrWmsYBJNIv1pGnKBx6L9xP2ZQBPMTDyHA+rlPH4QRpoM99YkN+AcS5sfN8/02xaDJ8FYy5Bt86x5rGhnrS4BVJxGrSf8ib8/hjPro+w+aB3ncKl4U1aQH2pdYEpoYjJVE31C5BaeJtboCWWIdLZ0/yYCRvbRvwivn2f1lKqhgFeXFRK7URR2hVQuYpeYB61WsX99Dc6GPJneKlwcyQppzu42fBtOJ5b7kvXb9DgjImG5o+3gNGCVt0dN6qyPyydngVuQE8W4jvNKmx9deO4JciNvRNd7SVBXaMHKFWUvk+srpH93jvbCTwr1IkghM4SX+41kk4W/kUE4rlPGwqRH5weu1PnigfWWjrlRGcDRFfUpojwd8xByzPMaeiQGPbh7Xsh6HWU8/S430k0RyyxXQ+d7QbFE3OjhB5Ltkxtz3nox12iGX0239vLHXl69LWtvbzx0ptv2wGv4l3hshbSxPgmEsaaslv+Y+/SQL/zYQAs6nry1507BXRyfmM4wi40ohEx8jkVJ2O5u44A09vxztJyuU2VCaX+16BwJ/jNiDWeezoMSbfBy4dVUDf+NCz0mZqvdXDi/jsfSwUjvdJEN7JXdt1cVrFN5NaUG4zuPgOnq1rQbs3ifwbh4Uv38SI133X6PJ1hEpk68tXX6nT9l806VDHsVdTTklEJmbOkM5rQro1RFBsW/VbJ44tFA3gjZd7KjL+Ul4L8WaCNIcWbnemkjZ+7KQII2gB8oXJDSOyQvk7sDvTZJj4b3MZI0lB8b6JEK96vohWwfaRr
 OAVGTLTE
 MAIZWKgHhE0S4iawdvjNyn8rdoxfKchhJ/dJze0PglgdUGGG9TcAcm394Oyul7yVnUjAuLMrHoYcFYUoirnciVNEFclVMiNNtYDaJnSreSLZvR29Awsz+6gHIUxZAMQfVA4tN2/RoTxR4+Nf17QPXpVYrws9x5WSoSAnPWz49tHp/BJ5wcxSwz6TEpHO0yBEqEir0pP55H5Jsoi6HQedIvalypvj+sCQ9DW0A3yjAQgH0GgGtD2Aq7DgnAZvD/JLQ2dcJVOaVny1j24FxPswmWImmeTcF7Fay6iPguF5BVfDX8wJX7IYviD61G/3WY/Sq15n8M4mVlu+U6e88isJY+u8tdw3p6bfe9eSbV+18PJ4A2JEUySd2aDMocIsHt6h7td2lgpZXfuClMIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> swap_cache_get_folio() reads the folio from the swap table and takes a
> reference with folio_try_get(), without any lock. If the folio is
> removed from the swap cache and freed in between, and its memory gets
> reused, folio_try_get() still succeeds and we return a page that has
> nothing to do with the swap entry:
> 
>   CPU 0                                  CPU 1
>   do_swap_page()
>     swap_cache_get_folio()
>       swp_tb = swap_table_get()
>       folio = swp_tb_to_folio(swp_tb)
>                                          madvise(MADV_DONTNEED)
>                                            zap_nonpresent_ptes()
>                                              swap_put_entries_direct()
>                                                swap_put_entries_cluster()
>                                                  __try_to_reclaim_swap()
>                                                    swap_cache_del_folio()
>                                                    folio_put()   <- freed
>                                          page reused, e.g. as an anon
>                                          folio of another task
>       folio_try_get(folio)               <- succeeds
>       return folio
>     swap_update_readahead()              <- may clear PG_readahead on it
>     folio_lock_or_retry()                <- locks it
>     folio_matches_swap_entry() fails, unlock and put
> 
> filemap_get_entry() does the same lockless lookup for the page cache,
> and after folio_try_get() it rechecks the xarray, because the folio may
> have been freed and reused in between. swap_cache_get_folio() lost
> that recheck when the swap cache moved to the swap table.
> 
> So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
> takes the folio lock of someone else's page, before
> folio_matches_swap_entry() finds out the folio is not ours.
> 
> Recheck the slot after folio_try_get() and retry if it no longer holds
> this folio.

LLM says to me:

: The original folio could conceivably be freed, its physical page
: reused, and the same PFN inserted into the same swap-table slot before
: the second lookup.  That would pass the check.  However, the returned
: reference would then belong to the newly inserted folio, and the later
: swap-entry validation would still be required.  I don't see that as
: invalidating this fix.

> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -92,17 +92,27 @@ void show_swap_cache_info(void)
>   */
>  struct folio *swap_cache_get_folio(swp_entry_t entry)
>  {
> +	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
> +	unsigned int ci_off = swp_cluster_offset(entry);
>  	unsigned long swp_tb;
>  	struct folio *folio;
>  
>  	for (;;) {
> -		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
> -					swp_cluster_offset(entry));
> +		swp_tb = swap_table_get(ci, ci_off);
>  		if (!swp_tb_is_folio(swp_tb))
>  			return NULL;
>  		folio = swp_tb_to_folio(swp_tb);
> -		if (likely(folio_try_get(folio)))
> +		if (!folio_try_get(folio))
> +			continue;
> +		/*
> +		 * The folio may have been freed and its memory reused before
> +		 * we got the reference. Make sure it is still in the slot.
> +		 */
> +		swp_tb = swap_table_get(ci, ci_off);
> +		if (likely(swp_tb_is_folio(swp_tb) &&
> +			   swp_tb_to_folio(swp_tb) == folio))
>  			return folio;
> +		folio_put(folio);
>  	}
>  
>  	return NULL;

This return is now unreachable...

