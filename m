Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018DCC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B64C6B008A; Mon, 31 Aug 2026 07:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040606B008C; Mon, 31 Aug 2026 07:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D7B6B0092; Mon, 31 Aug 2026 07:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD22A6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:23:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3564A1404AA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:23:16 +0000 (UTC)
X-FDA: 85161328392.09.2029FC0
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13454C0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:23:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7TqchhN;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175394;
	b=pkG87Audsf7bNq0HXSGmR1QrytoG+ipUQw4fTY4+rcnxZ2JMZe+Jm9bkdSTPiGoYmIc6Pb
	3BZiYpOaT3DV52s2WDI8SpFiF7wLmWCHmNQtVwh4FaaCP8Qz0y4Es8F1WfJWxNDseOZRAG
	Vew0aom1i1Q4gzamIz859OPmnrsFyGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1qVb+9t1maPSDo/3bRtsMghftgqht+jlYThRGRjj8c=;
	b=CAVN/j1m1tatqcXscyG5LAwL8zHFfCcDa3ioa60kyKZSJ2VY+sb/otWBrLVq6R8iJIJWTL
	TvedioO60x1jGpOxSfRkQLhQwwopVOTqqzQHehccCX80niJbSNhAMC+7AiWeylDz71fKbg
	pDKS3rIZgbictylAHchpBRzmUHtous4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o7TqchhN;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2FGAuKBAnVuvrfl8BpuL8kcvxiiWdtByJuqPiUkCZuM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788175392; v=1; x=1788780192;
 b=o7TqchhNCUQPemqRNT2gvBRZmZK0ygz944LWsDMvlsrvIx0pEYBlNb8wwtxCcugBieAYzmhv
 D/Te9edx8V3nBipXDANvuJCHqfd2GgN7pdXfDUMqTGpiuu2bh3WpXhg3D6Rw76onlwJitkSKpzh
 xfuWM6zLRG7lWg1LpepcLfhQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 18fcbf994d3f25d8;
	Mon, 31 Aug 2026 11:23:12 +0000
X-Mizu-Trace-ID: 18fcbf994d3f25d8
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
	kasong@tencent.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: do not touch frozen folios in deferred_split_isolate()
Date: Mon, 31 Aug 2026 04:23:03 -0700
Message-ID: <20260831112305.466147-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831091514.1879786-2-kirill@shutemov.name>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 13454C0006
X-Stat-Signature: is4k4o3m58zf1dak71txko8h9soqb77k
X-HE-Tag: 1788175393-275509
X-HE-Meta: U2FsdGVkX1+4YqQd4fJD5/JPdVh9V4O85nB56h9wOGpsw9VLvWpHoVz7Bpm5Leg+gUxoo2kqjkQM6R7wUksVHj50lEjUcTgMZiPi8TYyAp1GakqOX2NAPXgX29ng3dUm2RrFZ2uYR/Ab1S2yHaE2b+PYu1TlJ4XRC/TBH2/qViuj8GUGTwoXsP5CEPARg4DlD4hvTi/QDSvDo5cNR8fQuaNvWIVMJ/U2O8SPEILoliB8CRuz3dUIyVpbPCfhTM8HS3V4mKPjhtB1B1mlZUwmnWTBzoF14YswKfHDjZweZNW0r4NPgUYxJbfWEPJcSb2vFUCA9HwpbNsZSEhFJfsMri/tB5LlEMsHJ8uOT+lN8kW5XAGGtQn6EjglBLvdHB+SZnPOHKzo6rYRBiuOnvLlnvsbXn30kWF+VNAgo8mVuGn2/QSQiELL30MF2u7Y1UY5dVIVEXf9xFkYjoYzRudldByWV//hLrQp6DkopqhnrKBboYNWB6SvbPCQtUnh4qVlY6m8tg7vO1cMKNES3FErRhhDoqiduXkxbQIo6coAQkIQ8Gp0IEi859QqYnDMMsJAnioyCb6+hBkULPRrBOdteD5loaqMc27kWRyRN+wOCquMdnZDENHPb2xLrfHf/ztqW9brxWlvEQjsrXK0gOj25XtIBJRmb9W0LodED5bE5neabbM2cpMk6AEJyywvEJmn95Bf44YyKlTRkQy1OWoVQKj1mBEXkfmSEAvcfgiOp412c8TKsTaxi3fqVjEPBIoAfSbnKOUzYejs5/9VALz+4EAaigGhExNHTqPOY1O2u+xqmiPYJTP2GRTKw1GdSjD6VmnEjuxdTkhOOnaHZcjmbwO4lD/Ux+jWeL8BLFheO/TjZFVrwRpwqfj74wkhLgIne8dzXf2/X1CrpGzNiqeDIibrDw1Vw7TlU7CPC3GEP/akyUfdJ46aPqO3yKvs4oM3XCmehrhb4qrgoAGSDL3
 Xn/y/rnM
 WmAgmlJA3tEjPS5+1uCqrxtaqitjik/dEekkopUxkY0SDrEbbDpEOPSYKhYmh6C+mDawnnPLSnbf3RIApXMULjL1fcjgOlFduzjUnrATw1I1MdBkWQCRc8pDnqfbjfJ+RqELfy3aonV51aTnmXCg9E4y7J0/9Zs6k3bEB8PvB22mfUhCxXjpKRUJBXw38Il9T6BaLAz9hu+dRLz+YSSRxmkEcVcYVq+uPUZbznyFb2SVRTSMmDCUJ9tNH2SrZh2xhvmTQFWU9xXnShwRB8J5m2p9xmWXN6qbriR41B3AJYxpuf7BR6BdxDJHL6TAujTI4Ek//yXMQfQhEu9QPUKTTagYmgmrQLG7hZkbnngsOrn0FR6kx9kWuztMikGIlvlVE9LLn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 10:15:13 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

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
> Nothing is lost by skipping.  Everything that frees a queued folio
> unqueues it first, and folio_unqueue_deferred_split() clears
> PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down
> on the way:
> 
>     __folio_put(), folios_put_refs()   mm/folio.c
>     __folio_migrate_mapping()          mm/migrate.c
>     shrink_folio_list()                mm/vmscan.c
> 
> __folio_freeze_and_split_unmapped() does the same by hand, under the
> list_lru lock it holds across the freeze.  A freeze that ends in
> folio_ref_unfreeze() leaves a folio that is still partially mapped and
> still belongs on the queue.
> 
> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
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

Acked-by: Usama Arif <usama.arif@linux.dev>

>  
> -- 
> 2.54.0
> 
> 

