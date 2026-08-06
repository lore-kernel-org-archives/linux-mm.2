Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843A7C55ABA
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 04:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E38C6B007B; Thu,  6 Aug 2026 00:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C756B0088; Thu,  6 Aug 2026 00:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233FF6B008A; Thu,  6 Aug 2026 00:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 005156B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 00:34:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96424A226E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:34:19 +0000 (UTC)
X-FDA: 85069577838.24.6B94996
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1D4B1C000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:34:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GtZtHLE0;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785990858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dq4/C1vxz/RKFi4+i8bt0MGZ8jbut/19qhgFjo+N2w=;
	b=gzheiPdGe8bOM+p1BjKEUvPCVYMeJeXWUII/q5go4WUeuOsgrSQ3GXw8WOvh/D6ujXPrsi
	YD3A2fTTu+t2G+d9XniAeA9Tum+ZFKWXnA5gi7EhvXHttV8wsQwigHmckRvREuSmFKgZYL
	w31jZYP7T3KoOsvL6YMWFuQAaRXL21A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785990858;
	b=kmslwy6Sv55NVsjUgbM0yASBO7244qdydLMJ1RqIgDp0lAQBPSbwSFC5cFm3JjkZaPHkQ/
	CTwTR/bzALBByINPCnW8rm/OogYO8HGpWDpJ79ySqozqKQ22fQAJ0Icjnd3VDL32nB0alA
	hNNSYgT085jdpzb1dDs1ZnRq6OyoB6k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GtZtHLE0;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAA9943B85;
	Thu,  6 Aug 2026 04:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3AE1F000E9;
	Thu,  6 Aug 2026 04:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785990855;
	bh=1dq4/C1vxz/RKFi4+i8bt0MGZ8jbut/19qhgFjo+N2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GtZtHLE0eyqqX9CWs2yHAVq/GVvHL5JN15JcCLpKmf7IBn7mY86hiwXPtZEvgtrl3
	 X5jOFP4ohBhykKaFbiMKbYnIV2erW8ETsMeEeqk/kCgUTGi4eTFurtVf1hlJ8B4EcR
	 0538qBXSTam/djPl/VeCit5C7aZLruO1V8+rwQYM=
Date: Wed, 5 Aug 2026 21:34:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dayou5941@163.com
Cc: linmiaohe@huawei.com, david@kernel.org, ljs@kernel.org,
 nao.horiguchi@gmail.com, linux-mm@kvack.org, ziy@nvidia.com, Li Youhong
 <liyouhong@kylinos.cn>, Sashiko <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/memory-failure: fix folio refcount leak and
 locking in soft/hard offline
Message-Id: <20260805213415.002dc67766271d21c232910b@linux-foundation.org>
In-Reply-To: <20260806031958.677935-1-dayou5941@163.com>
References: <20260806031958.677935-1-dayou5941@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1D4B1C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: muhis55jpdyufwo1t8a399s7taiupooo
X-HE-Tag: 1785990857-611386
X-HE-Meta: U2FsdGVkX1+TagJEOZKRD0WOwbEKE1eo/Ud4ErbCg4x6YhxuqDJTuqFUzhpor9MZrIJupGmQpw9T8//hVYlflItC6pTdIKxsT60FYgs14iSEsltB6MrQ/30TUBHcQBE3LgOHrJw6woK4H32/lSecB5M9KEVyWJ8f4AncOlwGrXx5xO+OM0EfrWaLg7zVMSPiraZL3fp70lyenHld8XW674eqIhPebH4U2JgA8R8DD8LuFxXIm+uQxTAQ/cG9Gj7PNeJTw7sTQYkz2lo53UrVEBQ+vv99Gdy5ka6uayk/uLEyoSLOOqE8w0jk8nLEiCOL28MODGgaHdU4rRwQo61DQEFwXZLgkpUp9hcZPJ6O2O45FYRvbkLNBwFJ7Rl897oSPD6GPENY+IojSsl2g/MFF8SWZJ64Ur5iQ4/DrDkcgMm8ly4ZYa0uR1G/eIAF+OSAYnXjMUi/AEl+sJvvOOiqkb3gvXmDZvj7+oHbenqHghZIMN42AT+gtasBUcTlM2bVSiS0VSbPn5qPvzT48LFGJvOlPSc9Hx0n+U7aKVpIFwdSJN+KSr93kf5JQYrxYe+ujv0h52zi/lMyMtADyItMZU1pY45+GJVsdHKyb7Jm8DNpNvCyh4CDLQnjcOICUaD+isfHPGFn92OpDEcNXDKlJWEE0ygFCuxC3YYK7UBkImTWkhYHp9cHPDnuadMLrsdsN0BT56Og2wLrzqO8lQyXgLPTf0aW5ad/MHbD/LynOd6I3NWzMJwMdEbOySMBGq0JvV5LQngcoQ9MJ/vq0CQrBBnN8PWShqOlX4gZLplYTTPDex0nI+uzkky5TdC4uxZxY1u7p5jYSxgluEy83/pm8Ndo9TaLccjwEANcRMlMOj/vYiHJXHwqO9Lf/9xNc6kvE7Ls77QHiK2q5vSG2CS5u3YZEVMt57g8tbxPOt6koOpgivsodYrkCCjPpe/dhVS5o8QTNGSLAL5q+5JuisG
 McHscH2I
 k4Ru/NE1/WOk0Je2YLh1aO7TSNWF1A5oU7ky2sQvI1ta8Ub8Oi+HxxCkxVoJ4+i8t1OWcAcM8elK13v8wToY/2kXiyEVFukWIXwV2594Qoczm/jZPi81A+udmF+EwCfrhc8uUkUp6intJQRxpH6BnW0BJ3ZN+Ewa/aI89FFiKjnXiL0XlaadWzRm0cK5/lMOlX3npCdsafC9WnXA+euN0elROAKYcnKuVnvQgoSQluGEHq4MD+EfZlURcQX6C+W6l2xHqX1BUhJgTh0hEMJeYZyg4RVhezMj7d8xv3LG48jkqUjqcivHM5e4DCYmllDgz3UF41mN8hNiFCGQWpZFJScjs+WiB+Pa/eb0P5u+JqX0FH8VOQXbU19Y8pDMKSUTzHeDWOE4BNx3tNUETAVop++oFiM7/Sdm4Ot1/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 11:19:58 +0800 dayou5941@163.com wrote:

> From: Li Youhong <liyouhong@kylinos.cn>
> 
> The min_order_for_split() function accesses folio->mapping without proper
> synchronization. In memory_failure(), the folio lock is dropped before the
> call, and in soft_offline_in_use_page(), the lock is not held at all. This
> means that while min_order_for_split() is executing, the value of
> folio->mapping may be modified by a truncate or invalidate operation,
> leading to a torn read or use of a stale mapping value.
> 
> Additionally, the soft_offline_in_use_page() path fails to release the
> folio reference taken by get_hwpoison_page() when new_order != 0, causing a
> reference leak.
> 
> Fix these issues by:
> - Moving the split operation logic into the callers and holding the folio
>   lock around min_order_for_split() and split_huge_page_to_order().
> - Removing the try_to_split_thp_page() helper to simplify refcount
>   handling.
> - Ensuring the folio reference is always dropped before returning on the
>   soft-offline error path.
> 
> This refactors the code to be more maintainable, fixes the locking issue
> reported by Sashiko, and also addresses the folio reference leak on the
> soft-offline error path.
> 
> ...
>
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
>  static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>  		struct address_space *mapping, pgoff_t index, int flags)
>  {
> @@ -2440,7 +2420,6 @@ int memory_failure(unsigned long pfn, int flags)
>  	folio_unlock(folio);
>  
>  	if (folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
>  		int err;
>  
>  		/*
> @@ -2457,24 +2436,24 @@ int memory_failure(unsigned long pfn, int flags)
>  		 * page is a valid handlable page.
>  		 */
>  		folio_set_has_hwpoisoned(folio);
> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);

AI review asks (effectively) why the try_to_split_thp_page() return value
never gets used

	https://sashiko.dev/#/patchset/20260806031958.677935-1-dayou5941@163.com

> +
> +		lock_page(p);

This code is a maddening mixture of `pages' and `folios'.  I assume
that migrating it over is a work in progress.

> +		err = split_huge_page_to_order(p, min_order_for_split(folio));
> +		unlock_page(p);
>  		/*
>  		 * If splitting a folio to order-0 fails, kill the process.
>  		 * Split the folio regardless to minimize unusable pages.
>  		 * Because the memory failure code cannot handle large
>  		 * folios, this split is always treated as if it failed.
>  		 */
> -		if (err || new_order) {
> -			/* get folio again in case the original one is split */
> -			folio = page_folio(p);
> +		folio = page_folio(p);

We did that 40 lines earlier?

	folio = page_folio(p);

	/* filter pages that are protected from hwpoison test by users */
	folio_lock(folio);




