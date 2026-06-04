Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF34CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 09:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634E66B0092; Thu,  4 Jun 2026 05:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5606B0093; Thu,  4 Jun 2026 05:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522C16B0095; Thu,  4 Jun 2026 05:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4055E6B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:45:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC33090A1C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:45:01 +0000 (UTC)
X-FDA: 84841746402.04.C938FD2
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 046A34000B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:44:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sEx0isCn;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780566300;
	b=C5342CpPW3h28quaeQAxV2i4IBv8IjYyEr3qzEszcuxdWlpMCx1gakUkuitLuIT4ogLejt
	Jroa5fxiI6kOqHrHYwoItGQ4pmwxl2FrigGt/gEYITCqhXcS011T2/7imMsK/LYx4/eCe4
	VoldI5JOrG+MvlJGvI2qkpF1nGPsD6k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sEx0isCn;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780566300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZW7uRdn455LkQBQ/QFRnbuVcpCXTAOlnN1QZRWZkKZI=;
	b=NGjY9tW/92GLrsvum1e34qyqNar0+EgsLKdrZkKYYX01VTRl7j85njlIT3ZxfsyJ3D1AuP
	sxAoLlXvVrAuzbxWA+d1+4omANaPARtU0eSjCYv0MnglNLRHbod5+Yy8qenKeyK0aUuzh2
	KAia5NRgQvR62iGEpf71qKx2cMgF6I0=
Date: Thu, 4 Jun 2026 17:44:44 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780566297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZW7uRdn455LkQBQ/QFRnbuVcpCXTAOlnN1QZRWZkKZI=;
	b=sEx0isCn8JIIkaDam2RxSE51KFR8M9ApBRUB5/23aiqjnTxTdo/kSghNlj0k3hN3mNaXwQ
	tWX0mna5d/rPD8z3EZOMQRgFQRK4yyUEc5KnqzvmDGYUb5Ibutiuc9scjBFmyXGlMQWDOw
	KYIKSbllnouFzABWle4Rmaq3oVVnXZE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/8] mm: merge writeout into pageout
Message-ID: <aiFJDCUydGS9Q1YB@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-3-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 046A34000B
X-Rspam-User: 
X-Stat-Signature: phdk4dexxisbactz75ax3np91h6dqjyf
X-HE-Tag: 1780566299-134947
X-HE-Meta: U2FsdGVkX18v6aIe9x3rm4kYvqHx69SPFJUUxn0fiPhftLWNticjPJcsmqogYoZWOFKGkdwinupNaZ4UdFi2LzU/mtF1L54EAkWg3WQGkOoV4tPuluFbiL/UP8n6cvorP+0rc7AFJ7GGr9fVLMVRQWy1JMJoCxVBNpDFdJCG3IEaqMqbk36FlvCmy0ZqaR8fPT6kZeIZhYWbopeX7wUOIRULSB3qydGbpwRExLG5gylNgyDgGOH5uZ2Xrt6zdU56o5ont4fihcSv0nEcHm1bl4d83VDOznY8JaRPHcAC7wW2DdZ8R49SA7+gDZSy3f97hISWZttKrCrRTJXVzur6x1sANTg6pTNHmJF3nkQQ7YOSe2A9fj5DY64sCBIv3I+Q55AhweoLSYyWLWRF06PqiZInjNSrmza+CUxtB+7fUqZc+fDOW1e2yppdAv4K/7/aahwTQE27tx7h6Ry87jsSqYBA6eoNcr/HsB9CWtCuFsBxCG3Blbpd+okKGkSKAbLkOv64sM/PApp3C5YnQHY/VjXZs3H7Ym0GsRCDH5VX+ApCKhALO1/s0xBQ2DuK8XJgudwElEqbLAyabNvRRN6ETbaSm4K6M5RBd6Q2tWy73IXAOGCxQLvGv+8jxqsC+JVBx8FCNEcWri570Wl84fe9zAF16/qvLaBkYpWurv9DjUt3USUNZzqoosHGhHF8Q0x89o5N/bX5LTZeOPncvrm62SgB8OFnc2VO3VR8NR2T/ivvvg67jitUTQB7DqLnRjtGRYDkDst4Zyu+iBIlg39bY96sW1fRQYfeGsgTxbN+XjFFx571xdYlmunuZrHMZOAByt9751snUGAbvAzumvMEAtK9mH/3491kUZ56QiglMtABppU+hpthA6VbvhxI+C3j1qfBa+oViM492sbHEwCPQdS4eIAijYYeZ7A4/0eFxJwYAb7j5+C2bPJxu8p66JDAhMqsxUUAoGNOfcjPSB/
 CBP6S4P4
 OjTpr9Pf0y48M49mBJZrZKq8AbyPg0nZrQ/CVRmzdimP9/tezM3u5bSlA9I0K3jmasMb1lF/z7yTdPrORvTN1eZNibv5w+j9msJz1U+5YWJxn6VsbckSiCNIGNArZ+Pm7gnKuiQC5FQlK77moo1z1AMGa1+RitgcdiaIJQJnWgzfG2fg3B6nIzElvZDcbuvGpNlgU6vFfYr+kc2fyUmUB6ccO1yXK6XO4s2/no3fGlO8cTXa9Zjk1tql6gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> writeout is only called from pageout, and a straight flow at the end, so
> merge the two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/vmscan.c | 63 ++++++++++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 34 deletions(-)

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e8a90911bf88..d7303eea1265 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -612,45 +612,14 @@ typedef enum {
>  	PAGE_CLEAN,
>  } pageout_t;
>  
> -static pageout_t writeout(struct folio *folio, struct address_space *mapping,
> -		struct swap_iocb **plug, struct list_head *folio_list)
> -{
> -	int res;
> -
> -	folio_set_reclaim(folio);
> -
> -	/*
> -	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
> -	 * or we failed to allocate contiguous swap entries, in which case
> -	 * the split out folios get added back to folio_list.
> -	 */
> -	if (shmem_mapping(mapping))
> -		res = shmem_writeout(folio, plug, folio_list);
> -	else
> -		res = swap_writeout(folio, plug);
> -
> -	if (res < 0)
> -		handle_write_error(mapping, folio, res);
> -	if (res == AOP_WRITEPAGE_ACTIVATE) {
> -		folio_clear_reclaim(folio);
> -		return PAGE_ACTIVATE;
> -	}
> -
> -	/* synchronous write? */
> -	if (!folio_test_writeback(folio))
> -		folio_clear_reclaim(folio);
> -
> -	trace_mm_vmscan_write_folio(folio);
> -	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
> -	return PAGE_SUCCESS;
> -}
> -
>  /*
>   * pageout is called by shrink_folio_list() for each dirty folio.
>   */
>  static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  			 struct swap_iocb **plug, struct list_head *folio_list)
>  {
> +	int res;
> +
>  	/*
>  	 * We no longer attempt to writeback filesystem folios here, other
>  	 * than tmpfs/shmem.  That's taken care of in page-writeback.
> @@ -674,7 +643,33 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>  		return PAGE_ACTIVATE;
>  	if (!folio_clear_dirty_for_io(folio))
>  		return PAGE_CLEAN;
> -	return writeout(folio, mapping, plug, folio_list);
> +
> +	folio_set_reclaim(folio);
> +
> +	/*
> +	 * The large shmem folio can be split if CONFIG_THP_SWAP is not enabled
> +	 * or we failed to allocate contiguous swap entries, in which case
> +	 * the split out folios get added back to folio_list.
> +	 */
> +	if (shmem_mapping(mapping))
> +		res = shmem_writeout(folio, plug, folio_list);
> +	else
> +		res = swap_writeout(folio, plug);
> +
> +	if (res < 0)
> +		handle_write_error(mapping, folio, res);
> +	if (res == AOP_WRITEPAGE_ACTIVATE) {
> +		folio_clear_reclaim(folio);
> +		return PAGE_ACTIVATE;
> +	}
> +
> +	/* synchronous write? */
> +	if (!folio_test_writeback(folio))
> +		folio_clear_reclaim(folio);
> +
> +	trace_mm_vmscan_write_folio(folio);
> +	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
> +	return PAGE_SUCCESS;
>  }
>  
>  /*
> -- 
> 2.53.0
> 

