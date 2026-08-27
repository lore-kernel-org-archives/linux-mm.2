Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF75C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53296B008A; Thu, 27 Aug 2026 11:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A045F6B0096; Thu, 27 Aug 2026 11:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB5B6B0098; Thu, 27 Aug 2026 11:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45B226B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:24:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5BB6C0484
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:24:02 +0000 (UTC)
X-FDA: 85147419924.28.515F2D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D32CA14000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:24:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glnJ0K3D;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787844240;
	b=aXaOEq93Bxhemb69bowG5kaoRSaRf0TV/Js1QQhxqJGON97baSplEsCV+A9Jy2K0sHuQEg
	JgVTLXTlKUjIotXWI88E74KIJVdnem2cI60Io2z9J2BdGkUumNwMb6jl68KGQ8xwUAW67n
	LplXz0lH/HKOjBDDijyDyayC0tQ7Lvc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=glnJ0K3D;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787844240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QV9O0kb5nHnYqHl1na5pYG1wtKPWpi2bl7NpiLwLaVA=;
	b=qlo1y2+Rj0/r/eEjejttrkUqwyDYQsdb0T68lbZ6E8ZxirDJ1EkR7AojOhwDQHJ5nttiwu
	zLr4GWtbsyKPMwssixNRimzm/ZktDTsEGbcWiYVl5T6opJfJhYFfT1TOq1UoNcQXMm0SxQ
	LzFIHbsRqvlKSZzQb/nmzl0vlcz7guo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A63640A43;
	Thu, 27 Aug 2026 15:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17F91F000E9;
	Thu, 27 Aug 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787844239;
	bh=QV9O0kb5nHnYqHl1na5pYG1wtKPWpi2bl7NpiLwLaVA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=glnJ0K3D/Jl9fJ+YhlA14ou55XsbF4GhVDB1Yl7QH0VQvegQU1X3LI77lIO+y1VTG
	 ZAa2hOzkfLp11XeCjXvefQSY2jlcjurJnofU+++Bg4+xi6oLc84aagJQ+wX4qPoAJI
	 YoZcExlpukUNNuKIsU6j4uhlUhwy4LRFQlDYiiV3odguGbPs10zmDbsJM1sY82V0uV
	 DP570GSsjfqsYADXKCgmYYKiW2kj14NrFfnQESMbGcBzInx1yLuCrTsfYROgbPzTf8
	 PNEwwKGmLtmyDPpxYQYw1DUcm290n4JiPiqquRTb8az3iwbLUjblzxmxXK5nVEmjbt
	 iDIzNyWamSOZQ==
Message-ID: <c3f16d64-ffe3-46aa-9596-b233f9294fcb@kernel.org>
Date: Thu, 27 Aug 2026 17:23:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 ljs@kernel.org, hannes@cmpxchg.org, usama.arif@linux.dev
Cc: lance.yang@linux.dev, ziy@nvidia.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, liam@infradead.org,
 nico.pache@linux.dev, dev.jain@arm.com, ryan.roberts@arm.com,
 balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-2-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260826162101.1314941-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D32CA14000C
X-Stat-Signature: 1tzqou9sd1fwqub58jmwyos1drkk5atr
X-Rspam-User: 
X-HE-Tag: 1787844240-295892
X-HE-Meta: U2FsdGVkX198cu9xkaVcF2/iB2YzvpAxxVnS/OOcC/4AiO3UYl9ncBNHp57+kYSCB4+2QlZXyQRlbET4EZjlVfrH0bx6hxV7BlKRDk7Nn/Z2lWrhtrt48ikvtssXz4we39NDvoUxy3C/RW6U74eGTZ9fWcE0Z74hlXjHMCEIOjqbp3JDOw3Sz5LNFYmc78o9Q8iyKjsF6j39HDj8HCODenXmZWAbGpVO0/EKJC4exXC87jDjsF2BFRZVq8VTGMPx7u4p6Yj2eV8ROIL/RmCROnqRJW/NEZpyM2X+VCmmi4ufTf6v8J1mvsic9V+HItW/M1UPSil40ZqG2jAOsZtjbOuPwu8BRKXB0f89ugVOXLFg8zocnMRfIi0+dE85y+89r6EKzwBXZWli1B1uH2WO05h3pU4Buh6/gLJdrNWEUP6/5dcKzptkuDH9reCsgSSU1EhbxO2uXmEWmqzFg1w5c6+Jv+DadQinYniaIeeGFVumbyUK4vyLaTH0jVL1dedJKsdtxm21FrYKBRvezwZmDK8SXL6tgPA8njwzMWpAnEgHZ5ONSZHhLg4M+3MyFLlzN06EUiuRzoaFQL3aLjgUh+vUPrmnZTcDlunzKBTHPP+hT5muZCdGKxSHbYp2HkVeWkwblkT89ll9R8jOdpMzsu3OxKVIUuCm6rY1n6etlG/MB6MQZl/oXchzb5WhKSu2GNfnwUZyWMIku6U+eg1C2aTDSgEJnlSwCgNrtruFzBS5TGIHhG51hACfih0EGczV//9q2X7AQ+vcEk6ocYAnh28irMCrfRzcUsnuw/XLBETxM0PzmIvo/kRQzaUF1oR01RJuXI/pqRylykCUAOiX3+NLumXb6FNZ9fre/onBfKiZJlEHRa3wmN2+cUIB3NZvoasS8bjyzvP0rXO4X+RVBIP3YmL45UrX371YmrEGzayAnGn2seAzlwFXNayLbq2dD1bk/1/4zMgtWr34aNC
 dwoUGiJf
 wzwfxBDeeuDv4mCDhXMr8cyCaFEP1hL5V19XhSHN0sg0lZYPiQixgw7R0l478rWMW97t4Jg2xBuuGZVNUz3Yi/WjmU8M4HWiJheE2IJKDfYhVsbA6Fo3sl0dUHKvyXjwfXDE5/TlLJTquD02gAYSKGQKfr3yKrDH5T6jLPI5PkfSaD+9VU2QFHEmrmmHjAigtHP8/2pQEuz9hJviMC6Zm5Obdf5QvNQnwfkRuWwxPNtIKiKCQp+2NohW7qTma3rQ0m1nYWH48VgyyjdeqSfqksFHSstBtAediPJKeFI/q4CIJ5ustqm3UIOr31Sv1tKx2KVkhl4Qy+kgo69Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 18:20, Kiryl Shutsemau wrote:
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

Yes.

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

Fixes?

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

Who will clean up the stats that we used to clean up? That should be mentioned
in the commit log, otherwise it looks like some piece of the puzzle is missing.

-- 
Cheers,

David

