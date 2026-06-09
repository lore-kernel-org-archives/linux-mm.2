Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4896CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8866B0005; Tue,  9 Jun 2026 05:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C02B6B0088; Tue,  9 Jun 2026 05:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCC26B00A5; Tue,  9 Jun 2026 05:30:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA3C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:30:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6A321C27DD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:30:06 +0000 (UTC)
X-FDA: 84859852812.09.EF4EBBB
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id D2136140011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:30:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X3PZat8M;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780997405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgCcb7AhIQHYCoo8iDRMB/0s0Gf7iyuIsikHPn5X6m8=;
	b=rCqWmzcP5n3OkxRAx5OIdX/I+j6lidqA/vloHYhREJAmtF/1qLyWAK51LB1pZraLmiuSer
	r/hxgHm6ygP2F/wGcS1hwpuahu6wNU+LPTjpWLkGYk4HOPML+cXwe6kQCdKw/zp4MFsvSZ
	+haSTVcfgn+JR12P12iAkJ2J8QbSASc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X3PZat8M;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780997405;
	b=z3ainSocsz8WbI+GXwfOp4mkuoEPD/5Dbh7d2Jb8TdFWQO+k++eeYy5F7bOy3sg7DWm0Ru
	cW/TWwyLo4jprsZg9WxwcrF9UvnXkF39Q1wcpvSj1WGG2T9ChGoQMu4r/zhAZJbyHc6Y7E
	t6f9trjdxsKop4QdIDppaBizhZd5ykE=
Message-ID: <50c03b64-1809-4000-88dd-ab147ddc6620@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780997402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qgCcb7AhIQHYCoo8iDRMB/0s0Gf7iyuIsikHPn5X6m8=;
	b=X3PZat8M7hFldYur1Ma629htXlwfI6xa08IXWGJwEg4G0ZQIxm4Ol9cgTxY1mHqFGB8Vv2
	hiskl2bnYOWG4d6ZimWRu4D0dVDvQK0/j0vfuGZoBBdCcGQZ0bB9zQQbkQ9k4Dzr/RGR6G
	ZrP8NwLFC8WmsOgbGUyuxoyHP2RAtSc=
Date: Tue, 9 Jun 2026 10:29:53 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from
 readahead
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@surriel.com,
 david@kernel.org, baoquan.he@linux.dev, chrisl@kernel.org,
 kasong@tencent.com, linux-mm@kvack.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 youngjun.park@lge.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260608143242.2869392-1-usama.arif@linux.dev>
 <CAGsJ_4xOcTTkpVnno9RgTAkj5-62dLASUa9YnJYSLOEiU1ULww@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAGsJ_4xOcTTkpVnno9RgTAkj5-62dLASUa9YnJYSLOEiU1ULww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D2136140011
X-Stat-Signature: 6itt4iutr88g7szxetij6wihmm9tw7jj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780997404-449715
X-HE-Meta: U2FsdGVkX18eA6wU+8YVRWW8h6sMBMvCEn00vDFeM/CvtBIeQVzbx1Q9pMAqzj6RA04vzbqER5Rrfvy6/3iZP+RacEtyVAz5Rq6ZkHO/SHhkCMvBf/lb5Aqq33WjHqFkDhnqGzsK4AW2TYE9XDYfQ7WAky68ZToGlIGvP8H97KpdpIKQWi0kkmhDsPIzgk1lr6/zN+XYBNXZz3zoyFkSSfqrjsYfoOHZ/GFwdWy8CGq6QfcFJSCNusJlzjXoTN5/NAKc6oAuy2jXmrrVD6x4oRs4IrMss5bJsDHi4k9JYbOv9AGSydERcSHZiMzoIiONDoCLW5keRRB7NOi1OfnCbUEuS0EIXBsCL1W8Xj9SjSzyHQm/cL/4SQ2xlIIhQxAI3F1Yz6fTwre9JtK7b1ZJ2YLOfvekem1Ydg1VDtszr0QLVJ3E/fAfYZ5yQkfsGHgA4BKGKfjoUBMue8PUqd8uDMzaLB7BWOhVx+XsPF/Y6sjz9GLEfqI7Ffl0tKVZL89WpYQ4w5TaUnMP6F5UhVEzbWs6XGXG9PvWtRVDobmJOwRagK78hqYahsRwQOWITHIcEfrZeuP2/PPZm92/sR8lX2d1zckKvocOfIUH/5HsHRtJ+/fpBK0e2Vt5eb5njtB1eG8AswNdnuzxrt6TvB7SgdThznMhodnj2dlabgpAOn1tFLP6PK0tSxCe/iBzmmo+KM9VwvtiG76uL4hoPWMOle/IhKLCab3wWDQFI54Ms/MxmAdYPCvlL2vZf/iFw+E+F36EoMb0M8TYnHjy3x+bPG7OLOtLDnHvyRaKKbFLBDpEvtw8RjtJcv8+nfQkeV89KBt1ERnCfubjm+8On0seqGiX3pQ0//E7hBxKMZc5ZJsMr1nlDZDjSQYiuNb8RW5laSpSD8bbs+iVgvSYJ7THqQaPc1SebAItaM4zCin5E3kv0od/9+LCr2WYZ32MKVOmsDwHZ4Xfsz3CeUtmf6Q
 EY+C87yR
 oaMLlbkLhc0iEm361feXDWjFWVyKsB6uq9EgcTj/NkOQX5pUk+E82sq3svv/xAB1WlsH+66vSOmzTrv2lW8jR7BUhUE5RCROVEbc8bi6iT1EY49CWGOQ5/p5BSxSEKzSqB7rv0+/IU4XYUKYKr1fHhj53KZyY7lyGH4VsI2ezfWqCbu3kSp5jJDTenKeL64lz5YNCg356fTEpEohoCmNmSJhonG/FwQrG3mCWFakTO3R7dGCWzw7xqV2hweqtnKSjt4OWIuyEpsZ01BuwzKI1iDwkGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/2026 09:01, Barry Song wrote:
> On Mon, Jun 8, 2026 at 10:33 PM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> swap_cluster_readahead() and swap_vma_readahead() end the readahead
>> loop with an explicit lru_add_drain() call. That drain is a leftover
>> from 2.6.12 era code and serves no functional purpose for the callers:
>>
>> - do_swap_page() ignores LRU residency for the readahead folios;
>>   it only needs the target folio it called swapin_readahead() for,
>>   and if the write-fault path needs the target folio on the LRU to count
>>   references accurately, it runs its own lru_add_drain() at the
>>   wp_can_reuse_anon_folio() and do_swap_page() sites.
> 
> right. as i can see the below in do_swap_page():
> 
>         /*
>          * If we want to map a page that's in the swapcache writable, we
>          * have to detect via the refcount if we're really the exclusive
>          * owner. Try removing the extra reference from the local LRU
>          * caches if required.
>          */
>         if ((vmf->flags & FAULT_FLAG_WRITE) &&
>             !folio_test_ksm(folio) && !folio_test_lru(folio))
>                 lru_add_drain();
> 
> and the below in wp_can_reuse_anon_folio():
> 
>         if (!folio_test_lru(folio))
>                 /*
>                  * We cannot easily detect+handle references from
>                  * remote LRU caches or references to LRU folios.
>                  */
>                 lru_add_drain();
> 
>>
>> - shmem_swapin_cluster() immediately locks the  returned folio, waits
>>   for writeback, then operates on it - LRU residency of either the target
>>   or the readahead folios is irrelevant.
>>
>> - try_to_unuse() likewise locks the folio and calls unuse_pte() without
>>   depending on LRU presence.
>>
>> Folios newly added to the swap cache by the readahead loop sit in
>> the per-CPU LRU folio_batch and will be drained naturally as the
>> batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
>> lru_add_drain_all() and so on.  The unconditional drain only
>> synchronously flushes a partial batch and forces contention on
>> lruvec_lock.
>>
>> On a 176-CPU production host running a memory-pressured workload, this
>> path was observed to call folio_batch_move_lru() from
>> swap_cluster_readahead() ~28K/min, a very large source of LRU lock
>> traffic.
>>
> 
> Do we see a workload improvement? If yes, can we put the data?
> 

Hello Barry!

So lru lock contention is a source of issue in the meta fleet.

This problem was specifically seen when I ran `perf lock contention -a -b`
in production on a workload that has a really big anon heap and heavy swap
activity.

When I tried to trace with bpftrace who was the biggest consumer, it was
readahead.

It is easy to run perf and bpftrace on prod on this specific workload, but
more difficult to flash a new kernel and see results. The easiest would be
when kernel upgrade happens and this patch lands to see the difference and
I can report back.

Thanks,
Usama

> Thanks
> Barry


