Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C99DF94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443F16B0088; Tue, 21 Apr 2026 22:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B916B0089; Tue, 21 Apr 2026 22:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 358546B008A; Tue, 21 Apr 2026 22:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234F66B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:47:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FF815EC1A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:47:52 +0000 (UTC)
X-FDA: 84684656784.30.119D7D8
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B1FC180006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:47:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGZM44r4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776826070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZQT0s2wUO2WZ6VaxUd4q0Cex0JTnd7JiwzgE6NWCYE=;
	b=iG6hAIgIWw/TNUWsTx2BF64ktkyH3MySW3/o699oukevz98ayYA0tOhEIuggIxnVJJWEAU
	7BQoswF8OkmTqAxNfHlMjjONwGmMwpdtHlJaVBPv1HlPWv9oBcn5ZM0njx7YRfI8ZKypHv
	AkS+U5SstcRwsn3aHZ13yNmiKaILGEU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGZM44r4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776826070; a=rsa-sha256;
	cv=none;
	b=Iqa9PBsbWYuOuheLxCe/iBBfBQO4XxhndcGYAvuRJVKSnzHnsOQ36E+ttWOFVMUPEB0xJs
	lKpNbPAKIrPkG11X5WQDu1Bnn2SYQP3mO0Xq+N7733XDMfwduy5f4x9anh95KV9czAlCbK
	7cz9fp6ykaq2jN8S64hKqJYoXBTTxxw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776826068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GZQT0s2wUO2WZ6VaxUd4q0Cex0JTnd7JiwzgE6NWCYE=;
	b=cGZM44r49NJUlLAuQ8Aw4WQthcwoCIfYOTdFUY/tOEqlyLmYeIQaniKeQUZ40a4/uPKL23
	ZKmWPRhyBQ0+zHs2xqUsv61Pg9+2NPLCnnWS80pkxlYxtLKg1D7OSRkW9qy6+8zhbw9Pg9
	vOmcRT9UVY5pER/ELSwk++RheXdwOfk=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	broonie@kernel.org,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: fix initialization of tags of the huge zero folio with init_on_free
Date: Wed, 22 Apr 2026 10:47:33 +0800
Message-Id: <20260422024733.70662-1-lance.yang@linux.dev>
In-Reply-To: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
References: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B1FC180006
X-Stat-Signature: mh1srjeif438o5m9uhra6ybxtrzxosrp
X-Rspam-User: 
X-HE-Tag: 1776826070-713334
X-HE-Meta: U2FsdGVkX18qf+zEBiOtQYuzPC0g2UogwplxnrX6syBukh+k3hdaghsR61LOEe5HSd0hLtxsp1ju/vWBvG1TsI0GEZa1HNJdnzWjij60SwyfM1G+69AhBM3mw6jto7hkMqxnr5TbMLDTjdo0zZ+M2WANjYGPkkewTBtxNmJ9vF45bqqWQokEpIKfxwMzEU7AuDj8w008M2WkA+u05d8au7fHPgEAtOtbLUoa4EXW7f+/AchlcyeZoVIXW9qe3W1m+empc4RvaOUhgtXerx5YhkwI86e3cCS47QqBQ/oTD7YgrXcLJPkmAk5akSbwHFhc/U6+MxkWyPqU/225JRhyQJYSNXyV924qWZ9aFyspGogBeCmMgT/eZ1fEwGPABuiSytjCrnNUz8us3jk69VCoIaUg4Et4P1b4oGwiTCM6DaqzBVywmMXwDTTW98FDTg3Nk2YSjjpCB7oX+VEUJ6suSFBQLMdSisGR1r8xhgCT1yDWyredcaoyjhmYov80RI8cTnrM19cXZqOFxP2I+2j7sdY/HKJ4Wn2asPWxnLzKjWUFQy7Zrlbdh7on1Dl9Wuo/ONAAiIj/6caZfoVH7b+UDBKGW9HPwVDTSwqKJHw0erFr6puVNDvnkmPYiDN0wWxHLRXsQYlB3tC6VEA/SJE7hd6vBSfpv8FzIazWTnn1UEPwIqPduyF9CuPM0+VgsA6vXtj6h+bFglzCM9oW4oNDP9QYn2F/1S9IHerlheAN4aWBiLGr/O5n5vrxSfmQGNdSbWHc45T2f9gs/ShTdpuW9y7gb8KrtpBU07civP5AEILTRaMMXu9VVc4WH9xiekbhadMCLZVgUkMqx0wy1nAtQ/+Mj9upOdLQiLQgZzpFgfdK+EaIQeZ2zm56GPX67WxRdun5roWp2bp7KMMOIjM81yhxM6iwNeK0HsarDq51dl19205S5ryvJIYeu8/Dd3jYD5Xccv/cH0/b/+S0T9B
 peBgrecL
 fnsDujrHkXpYdksHocrHGhlMRkAlfry1yglv1GCxJDnS2x4ru9opr7oMQmcVThX/xx2J8I9LXHrGy+XTPguxd7mVT0wMhkkYXxI/p99KbyvIxRXz0f/c1bFmH8ZWER9Og/F/gFcJHOICMhbWdooFs0XERu+CAQRUwKq0g1rZUhk+EJaX6dmOHPTvUCcu8pKKxOgL+eWefLVzamQWm/ysVsdClnpvgDZfNyiucAZYVYtRlyZlX7Ho94BDHtISWNhDRGvAZTsvf5rfHQpZfALrQf5TW0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Apr 21, 2026 at 05:39:07PM +0200, David Hildenbrand (Arm) wrote:
>__GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
>flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.
>
>If we run with init_on_free, we will zero out pages during
>__free_pages_prepare(), to skip zeroing on the allocation path.
>
>However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
>consequently not only skip clearing page content, but also skip
>clearing tag memory.
>
>Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
>will get mapped to user space through set_pte_at() later: set_pte_at() and
>friends will detect that the tags have not been initialized yet
>(PG_mte_tagged not set), and initialize them.
>
>However, for the huge zero folio, which will be mapped through a PMD
>marked as special, this initialization will not be performed, ending up
>exposing whatever tags were still set for the pages.
>
>The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
>that allocation tags are set to 0 when a page is first mapped to user
>space. That no longer holds with the huge zero folio when init_on_free
>is enabled.
>
>Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
>tag_clear_highpages() whether we want to also clear page content.
>
>Invert the meaning of the tag_clear_highpages() return value to have
>clearer semantics.
>
>Reproduced with the huge zero folio by modifying the check_buffer_fill
>arm64/mte selftest to use a 2 MiB area, after making sure that pages have
>a non-0 tag set when freeing (note that, during boot, we will not
>actually initialize tags, but only set KASAN_TAG_KERNEL in the page
>flags).
>
>	$ ./check_buffer_fill
>	1..20
>	...
>	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
>	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
>	...
>
>This code needs more cleanups; we'll tackle that next, like
>decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN.
>
>Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Tested this fix on MTE with both kasan=on and kasan=off. Works as
expected in both cases.

Nothing jumped out at me, LGTM!

Tested-by: Lance Yang <lance.yang@linux.dev>

