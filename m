Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640F0C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7A46B0088; Thu, 27 Aug 2026 12:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6700E6B008A; Thu, 27 Aug 2026 12:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F5A6B00A4; Thu, 27 Aug 2026 12:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE576B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:38:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9DC9C011F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:38:48 +0000 (UTC)
X-FDA: 85147608336.13.F64597D
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 947A540002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:38:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HGGHVbnD;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848727;
	b=Od8mfAQGUgp1FG9RUIUNaLvNqxDjuuSAvSJcmmA3eyTiNqRWALKw/fruIFhHcirAiwOT3m
	HxlnK+spdZCvD4+Eu1Kku4TGtxeF/lnlQUd2vDfrUnejlHxgjN8Xui841ktsi41r0e5YIw
	CvkIsczVedxkoW0Kj0WJx3jBNqses7c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HGGHVbnD;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Anz7FeCTF9+ppKxvxT53AfUR7ZEcBr5uDbAaJJNclE=;
	b=gnao8R50krZzaTjlmnJG+Ai/P/c6PmovJ4f5SK1zYj1Fo1/AJHIxxVWb3w1E7bIn8g9OOr
	cAKgfl9gAZujGot9qYWi5OUwiyg+vyaTB2NZPG8xQuynSLE7WTBXPoK+2VimG3PH0Thelp
	F3XOkXDBk9rR7pqo2MdTLmwdTIBuXM8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=47ud2sjFvuwpCPT/8aoyQa7HTi3PcHWzDdeGQYgymmk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787848725; v=1; x=1788453525;
 b=HGGHVbnDULrs21MEFB0ma2yHI6gjOYP6M7ldh9IgI7aYf7UayFJPpbR3Xbw0+YTZOB/1Fiwp
 jjO4jDHo7WhJC9zR4gn/574XjO+0oC1RctTdF+X3pEh0jw8H6Mq8Uh44RaFDTQa9ECCIfxsA59g
 kkTz4kn+ReSUjAuzT3PnqyLc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 5f895ce9d536e3b4;
	Thu, 27 Aug 2026 16:38:45 +0000
X-Mizu-Trace-ID: 5f895ce9d536e3b4
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Thu, 27 Aug 2026 09:38:37 -0700
Message-ID: <20260827163838.1813081-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260826162101.1314941-2-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wqxgjd74uu4jko9qnd7kfe1wrmp8aio4
X-Rspamd-Queue-Id: 947A540002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787848726-499594
X-HE-Meta: U2FsdGVkX1+oJUK6rd1Z9zOGj76lK0fXufSNGkLhGadpZWntLn+S75lwHJh7F9IEy9fpejt2IdWHYIM5K2I5S1cWUsFzroJzgk1zYpbIUcq8euImTQW0Pe2aiI4udIHj/z755nXIpnISD4T3pq+RNcASB8MA1paNNS4htVo01GjcnaXsuzjOdozCKknKPgfxmqctuVxOtpGy1nl09oTXioXyV0KeTpYqgAO8lCq7JWIHxXZxcwxFCVwvLk0YQ5WKR3o4focEe4cWEpul6w7j0JKs+w1AAOHunXTs315pL2nxQLHFGtLcgAhVyxOseggN7fTDLkVRpplo22JUi6V7T45Doa6OX/sJuGZN27+mBCWQsX0Nmd63PbMDyZUJA0Vp0XyPtfMPfGIrMzwZ2X6+/W1kGt3tyQgfeV5E+nvct1LCiibxSPdBGP2qVLj68SphI1/BgOtWWdm2WhHgWAGRxZbSBDT6o659/HjFtdK5ceR8RO+AF+r+NsPDZIjwcEVHOhc5SNRXbuhnaFWxt2COCM69l0YhERQgNehiyFvpUrsjYePWURNpAK4MvFkWHKwnYIZEu2rpRNoAaC/lvqM7fze/9UEdqtgHWwol2Awq5/DNFaXQsnfkZWrChSEm4M5CLMctmWTYh7nt6ngk3XjYJEEYG0AlqyE2rP4vG0IkBaUoPDHEkEMPGWl1gFq67AQYS6NB5TzBqBhc8ParidIOBIwxiI3l0anfmLC72MBZrrL+ZBIDGwLX9+bbHnAA6ct3feeDqg038zB8/S3lAL7ZbX8RIfhlgDcVG6vGnvVa2t3R6FKvN3RASnnsZMLRsOc4ihBaww4AkQcIYhSba+JQhslRVxh4NWYZiVQ/0nBb6mJfm8MX4CsymTTQfXI2V57VTpvUU/7E6IBdVAAh/WaQYr2HrVquFOQL/eAKlWZk9wEJApiLAUSs/SURZOAu7wcbT6r5/vTXRGX310STIb1
 H2mQ7EaU
 y9bkJIQjSzq5zPRgQ20CqZHEziI6QjKpaG10G3AA0kSGIn5/P2bZZ+caW++BtlYAkelLKBomTpzA/zDFqN55GfjSh/XUVVrbFd0UL5TEZ/x1VwS2lmZnGpKMdtR7QcowuR3BEictgycz01z7cBVxfLjPdf3WiphaOgiljwRXEnhzrGmzsbrdPdD4V0in15U85gJuMtcOCQNYaZ5SQh3S57KngKHW5uk4D8WNQICb/Fq4kt2TnUAEL20Gcdo4kEcleBETstoqS84kLGhGugd8Kln8huGNtXw6x9u2bTXFkAPxGMHBSdhf7hCqeFls1MVKk9ez0fO/LaWAK/mDXF8J+AwNY7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 17:20:57 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> deferred_split_isolate() probes each queued folio with folio_try_get().
> folio_try_get() failure is treated as a lost race with folio_put(): clear
> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
> the folio off the queue.
> 
> The folio_put() race is the most common case for !folio_try_get(), but
> it is not the only option. Another scenario is folio_ref_freeze().
> 
> A zero refcount in such cases does not mean the folio is going away.  It
> means "don't touch me" and current deferred_split_isolate() doesn't
> respect it. It can lead to unqueueing folios from the deferred list for
> no reason:
> 
>     CPU 0                            CPU 1
>     ---------------------------      ------------------------------
>     freeze a mapped folio            deferred_split_scan()
>       folio_ref_freeze()               folio_try_get() fails
>                                        folio_clear_partially_mapped()
>                                        NR_ANON_PARTIALLY_MAPPED--
>                                        folio off the queue
>     give up, put it back
>       folio_ref_unfreeze()
> 
> The folio is still partially mapped, but it is no longer a split candidate.
> Nothing queues it again until part of it is unmapped once more.
> 
> Skip the folio instead: whoever freezes the folio, owns it and owner is
> responsible for its fate. It also covers the folio_put() case:
> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
> 
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/huge_memory.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..6281ed993243 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4590,22 +4590,11 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
>  	struct folio *folio = container_of(item, struct folio, _deferred_list);
>  	struct list_head *freeable = cb_arg;
>  
> -	if (folio_try_get(folio)) {
> -		list_lru_isolate_move(lru, item, freeable);
> -		return LRU_REMOVED;
> -	}
> +	/* Lost race to folio_put() or the folio is under folio_ref_freeze() */
> +	if (!folio_try_get(folio))
> +		return LRU_SKIP;

I think we might have a problem here for ZONE_DEVICE folios?

This assumes the final put always dequeues the folio, but ZONE_DEVICE folios
bypass the generic folio_unqueue_deferred_split() path.
With memcg disabled, this can leave a recycled folio linked on the
deferred-split list?

Should we dequeue folios in free_zone_device_folio()?
>  
> -	/*
> -	 * We lost race with folio_put(). Read folio state before the
> -	 * isolate: folio_unqueue_deferred_split() checks list_empty()
> -	 * locklessly, so once removed the folio can be freed any time.
> -	 */
> -	if (folio_test_partially_mapped(folio)) {
> -		folio_clear_partially_mapped(folio);
> -		mod_mthp_stat(folio_order(folio),
> -			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -	}
> -	list_lru_isolate(lru, item);
> +	list_lru_isolate_move(lru, item, freeable);
>  	return LRU_REMOVED;
>  }
>  
> -- 
> 2.54.0
> 
> 

