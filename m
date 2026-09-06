Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2733C624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 02:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A156B00B8; Sat,  5 Sep 2026 22:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3B76B00C0; Sat,  5 Sep 2026 22:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B38F6B00C1; Sat,  5 Sep 2026 22:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE7E6B00B8
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 22:46:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E700B8043E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:46:05 +0000 (UTC)
X-FDA: 85181797890.10.6599C86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E1551C0003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 02:46:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rvUVpcRn;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788662764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDfNzBmxZzshjfLtQ92GgYPQBtbWM97n8wzTZoEhKU0=;
	b=ymW1DCY1PKr1InFGiP8hngdIFz5xODKW4RzxczHsbKQ4twmTuOoJiexIjInqu55qu1rhyc
	+7YKrceC46K/2FYKh+6pHBQpqrKZ/ZOERloTa2l7GQPf8o+Cr/lYkEm3LuOkoNiq13r5tI
	i7IeYPhb8nGIBs3eB82KhSyo1Zq6cbY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rvUVpcRn;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788662764;
	b=4MWs70m29cRVKq3wwMgnoz+FqQy1xzux2hBRDoL4r+eEVRjaryZ59jzwLxRzrkwHeiiHxg
	V8NKucCqdbQt2l1BKxM2HNhINddZb/ZkUZzKJ+oGu9PjphZT24rmyv8UtUGxA9Ff7Eujbc
	CIJ89KapWT4r85949OAYr4zP0P0N3dI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0929543E2F;
	Sun,  6 Sep 2026 02:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806DA1F00A3A;
	Sun,  6 Sep 2026 02:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788662762;
	bh=hDfNzBmxZzshjfLtQ92GgYPQBtbWM97n8wzTZoEhKU0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rvUVpcRn29obM+0a72bypDmDA+R7gP9dNd38ca1FRe0Swd6tP2RM8NlusqCnjSxGA
	 gwi97AuATg7Ge7O1xq6jjEAbgoTY0d9r+mRt9Z14zJthiL8u/m+fl5FV/nEKFDAU3b
	 N3YpPS7zNIL7TNLO5HM5VRsjWKLd3Q81dWqqH4qM=
Date: Sat, 5 Sep 2026 19:46:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: hannes@cmpxchg.org, baohua@kernel.org, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org,
 mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache
Message-Id: <20260905194602.b88f549b9462033e40336db6@linux-foundation.org>
In-Reply-To: <20260906011820.382381-1-zhangbo56@xiaomi.com>
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
	<20260906011820.382381-1-zhangbo56@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tiiejg8xob8wauihhzrgomyor74t916n
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E1551C0003
X-Rspam-User: 
X-HE-Tag: 1788662764-498969
X-HE-Meta: U2FsdGVkX19RM2FF/vyATnKESVvg+KiFAfEAdTFDq0d9r8PnSC42suEitzsWq8zhGzUhtwhi2iV+iRPjE4Ma3gD0EeRTDCilBbDckZujHWAW+dPYFko6cdiAmvRry2hUpnmRNY42Z+B3ObWBsg3bCfVFJa2IuxmREC65QgebKmlY5cN6oS0y0uy8SRhDgq61w33/m8eqz/dTpYcrZCnXg5VgPm4HgfNXRZhMxMLgWw+L8oKTCsqje1buWxmNV6T5HGWEBRRGokaCZNhGVZTVSMTFSu/ZvRyJXervyoGSGroRPQrguwumEf9g0Lrd8sQo9nZz9rbJ8cc8pw8+yqoH9Cup8gBanS1kWAUrHdSS5TbJ9KCEhaBHpWUqpT9iqCkIc9k/6inXNc6HzIU0gyAszjG3qvDz9Oe1DNJ5UyvC+zdoLUKkhLyBL15/4Nx2ec9jhOD8cHIwTuSjEr1sl3hXPoE2egMXhZR5qsgjMSfktTWep2XqFyqBxSkkFNlSWRdO+TstCrubdzQmyrINZOql1j28AeA1URyJ9lLGcOcBhrXr/oyUfFcUeCTovzZzJDE9en2rILGs8LvXnDRGwFr5iGERXNF02wsL/+F2Zh0VRYKzxnzgce7/7ZPSFnJZUXe0sQgceUrY9xCbn5sFjW2iGIw9JIAqyI75KWxJk4fXs6iM1NLBdxhhMvvG/gIKyIN7drUFxpyzYJTbtOP93jzyACMGuR9VwbP1dVzZoKEmCAWkVwUeqyc3q5jeosHN7UIAY1/SHYm8cYVuHHBQjL3602OWZ/Xah7u3O7kHVCspGSpSkMixMaA4apft1ux+9eSiHaTtg5q9q7VnZGc9+U0wVFpzNlmR/dORG164++dp6DoY1diZHcnh85GyaUvpK5dV/c1pV3IX2STNtel1qwCLKVUdZ3leR5euNJxL+RwnAFty+XFIwXD5dXayzCfMsr0SThF8Trh1Jt5Ad8OMNct
 YDncZX3K
 5gbwAOUDmsBgnVam2eXJOt2ljmdY/waCSR0fHgEgdaHpaQuig6tkABpQ8124T/FJlCYTcbRdJEE5t/iLmWjeT2eIHjdSv2u6kUklP25hzpP2a8FS6WC5t2JlvXNHscweclZq7riiLcEEpaRo5uwYYpBRHYNyCNm4JvDhLRTD65rVudwkCiAUzpwsnZ4/95+WDg+HMkSclASXpgrteeY7OoS7Cx5vhl/rJ4DVgo+Keaheg0KbkqJsdCEMQCTFALBRUuBLEMxlU6GW5w/Wao2JQnexASkScZPLJe29N/BOVCUeBTgYPYCcI7CRAcxEJPUsDwmUWuU/kP6gI/61U0sYduHgW1Cj7GYwCSvcKoNBKs8DoKIcJNekQt5EsbM45tDN6KU9jNiK8lKreu8ObQSmOLRlTzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  6 Sep 2026 09:18:20 +0800 Bo Zhang <zhangbo0325@gmail.com> wrote:

> We have observed some cases where memory is allocated with GFP_NOIO, so
> we cannot reclaim any anon folios unless they are in swapcache. We can
> end up spending more than 150 ms looping in `shrink_folio_list()` scanning
> non-swapcache folios without reclaiming a single folio. This is pure
> overhead.
> 
> This is particularly true on systems using zRAM, where swapcache is
> relatively rare. So let's check whether anon reclaim is allowed by
> GFP_IO and whether there is enough swapcache to make it worthwhile. If
> the swapcache is extremely low, we're essentially searching for a
> needle in a haystack, so let's avoid scanning anon in the first place.
> 
> On Android this is triggered by dm-verity hash-block reads through
> dm-bufio, which use GFP_NOIO:
> 
>   verity_verify_io -> verity_hash_for_block -> verity_verify_level
>     -> dm_bufio_read_with_ioprio -> new_read -> __bufio_new
>       -> alloc_buffer
>          gfp: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN
> 
> Such a reclaimer can land on a memcg with a large, unswapped anon LRU and
> a tiny file LRU (e.g. inactive_anon ~335 MB vs inactive_file ~4 MB, with
> negligible swapcache). shrink_lruvec() then keeps feeding that huge anon
> list into shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000
> anon folios scanned - where every folio is kept because it needs IO. The
> 150+ ms above is one such single shrink_lruvec() pass (not accumulated
> across a reclaim cycle), and it reclaims nothing; the actual progress
> comes entirely from the file side.
> 
> Aging anon alongside file does have some value for a later __GFP_IO
> reclaimer, so it is not strictly pure overhead. But that aging is only
> deferred, not lost: kswapd and other __GFP_IO reclaimers still walk and
> age anon. Spending ~168 ms aging memory that this context cannot reclaim
> is not a worthwhile trade-off in a latency-sensitive path.

Thanks. That sounds like something we want to fix.

> To stay conservative, this only skips anon when the swapcache is really
> tiny - below 1/64 of the anon LRU - i.e. when essentially no anon on the
> list can be reclaimed without IO. Whenever there is a meaningful amount of
> swapcached anon, the normal path is used and anon is scanned and aged as
> before.

Argh.  The thing about magic numbers is that they're always suboptimal
for everyone.  But I understand that a full-on dynamic tuning setup is
a big project and hopefully not worthwhile.  And yet another /proc knob
would require quite some justification.

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -362,6 +362,23 @@ static bool can_demote(int nid, struct scan_control *sc,
>  	return !nodes_empty(allowed_mask);
>  }
>  
> +static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
> +		int nid, struct scan_control *sc)
> +{
> +	struct lruvec *lruvec;
> +	unsigned long anon_pages, swapcache;
> +
> +	if (!sc || (sc->gfp_mask & __GFP_IO))
> +		return false;
> +
> +	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +	anon_pages = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
> +		     lruvec_page_state(lruvec, NR_ACTIVE_ANON);
> +	swapcache = lruvec_page_state(lruvec, NR_SWAPCACHE);
> +
> +	return swapcache < (anon_pages >> 6);
> +}

I think this function deserves a comment.  One which explains why isn't
doing what it does rather than what it does.  That comment would
highlight the heuristic and explain the thinking behind it.

Also, AI review asks "does reclaimable_anon_is_low() incorrectly use
root memcg statistics instead of node-wide statistics during global
memory reclaim?".

	https://sashiko.dev/#/patchset/20260906011820.382381-1-zhangbo56@xiaomi.com

