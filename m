Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D47F8A142
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30FB6B008A; Thu, 16 Apr 2026 04:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08076B008C; Thu, 16 Apr 2026 04:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44F46B0092; Thu, 16 Apr 2026 04:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEDE56B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:10:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48D9D14073A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:10:16 +0000 (UTC)
X-FDA: 84663696432.25.4957417
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id 550FB18000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:10:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=o5nNKC8L;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=g4gWjQ5y;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776327014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=er7vZbJm0ZYM6q0ZXrYoh6LIB6r018Yma2LhfiIlGek=;
	b=05QDVexqgAodsrAvJM+HtuX6eBaIfKHdGMVWN3oeQ0sQXXaMb1snlRhMoDyDKCnWeErcgq
	wVP4OcGWTrLKizwylYgg2HqMK3HxPs6CYuOqd9FVlaE7znsNdXG7vwC04HjY5JYAeqN3st
	YumVFhcQHranASZYSq4XTfEYbtQVgUM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=o5nNKC8L;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=g4gWjQ5y;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776327014; a=rsa-sha256;
	cv=none;
	b=kEOxzJPmVkdsUBtggHXRqXGoISTOlBWF8Vr8YaVgtdNYyE+vWAzJItYAg7R58O3V+kfQHg
	4IzB+1VAMQ3ZB26ZZax+bm+3UPiX813FSsxngSqR+GbZd4OzV3nENBxQ0gZi8RqPuWHPXf
	cQW+TRrvNTclec4QH//vCVOnZPzakTc=
Date: Thu, 16 Apr 2026 10:10:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1776327011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=er7vZbJm0ZYM6q0ZXrYoh6LIB6r018Yma2LhfiIlGek=;
	b=o5nNKC8LJKPE34sFNjKrYUTrgatUmZpwyzIdMfVgOXerYuwOETULW01H1sh9dq1IkLAXoK
	LMG51nzhS67JG6krNZVWS/ki1tni5P4F75UNo70+HIv875yXzG855q/BS1loERNx1pj6XL
	OczSJYhs0WUt2L0P4OX+cI+EK64zJnreVuA5kMVYB/+kLcDBnY4T/++h0Q4d0IhsFksH7F
	eVp/m8bctx17Qd4fJ04OsLD9KJ9juTEJhnaycl2odC5dwRxbLIizReKb1c5FRRYxpWlW9V
	0/3cDkRD0MXfA2JR0kqnTE45xViDrGYL9qARirhiBVdwAno8tV+FWU8TjyqAKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1776327011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=er7vZbJm0ZYM6q0ZXrYoh6LIB6r018Yma2LhfiIlGek=;
	b=g4gWjQ5y1WR9OhVJ2/iH82sndAB47SOqEWhyZKOYWQE/ySeEGTIvGpseS4lGcbUiKEXB7t
	kTMhZ77DIILacZDw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Mike Rapoport <rppt@kernel.org>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 3/4] arch, mm: consolidate empty_zero_page
Message-ID: <20260416100221-57063053-1c9e-4450-8b0c-d9783657fa47@linutronix.de>
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-4-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211103141.3215197-4-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 550FB18000E
X-Stat-Signature: hsoabz43t4ofumhgc1j4x8wb9imd8omz
X-HE-Tag: 1776327014-863579
X-HE-Meta: U2FsdGVkX18DZ6Hc51x7XDEDt3lgzC7NmNithObaX0sA1g5Q1Lbuf9cSrKTqryg3gCdoDFRjyjiKWY3XPhianJFa19mRdMa3cLMnFRWeqXkHci6Td3VDX2cMqa0Htdh2d+7G9TdpDFMRY66TdqdglLYk4OzycpdFLy307zXM0f4nTYSNLyz9LB1saPZLGwqzToSwdGGbncq/S3U12LenBCUZbN6Y1bzfai7XKGQdbM+GR3F/czw+LpgymEfdYTJnib7SqGqeDQd1yab6N4RzT07xvSU+XY3CKLKUu0pQQ8rlCj8WkV5dzr//RzO/mV/pRzfMF0UN1hdtkzjcwSYe3hRD82/iGCWR1G+AYpqsJbD5ZXlr43qibeL6D97x2P49U2h35uIKTaz7/fpoGVmy7uUcbambjC/jFsz3c/JGXD6/vzubG8N97cfOYylSqEvYbFwr7pwZOD5R1F5R+VKpgPQycDt9NEuzarzQA/Y5hQHjZHJONhudsitxQCXKUT8JWfrZvYqfst50CIWwRBcvO3iUyFSL8tBMG1hVj2HyUkgRanzJQvZXdutcQVefST3GToJfMHqHycUvuNYFwRMXYumZyDEdJy06GrgPor5WaLyK+kkr5UTcDVE+3pCSashIuuxtQ7EpKs3g4/SCmgbGGmbz4nb0JQWfVj/oav2Wz8Ii2NKfi2g+dKZzydUjtEEKcZtebi+MlBnQqB53uj6cqoISH+g8jAUEzfPrUL/yRHO8I9wTKCTcC2ntXcjL0BPA+CMVyYGwPv7gpoykjYOmg4/vuFcKA5Y5gL0mrNqRBd2K074axgGoD1pchLWTc6TcQhCmvQ1RYX+sHXXo7PhlxGvW0b9vOYrh53rYfQdF1QUC4Cs2737Pbo7A/tAEAyVryDmCIaYKh/zHlMIZu5mG89Tr8Rzvg243b8gj5uqx8/MrlEyr86wbJmTX9u4X92BeNm3r42AyZTD0MpZDXTA
 kX8/5ACF
 +23gIA5lr6nQLRtHLufD2kw+R9za9S7uqmP/K/DSSH2gJ2iHH0dtZ9yqZM/wEG6cFA6OY+J++Wabl5NdDaU4f33E2mnY40aHK3ShiH8hCE70Ze2QR72GF6JegHaQthobYcSs5TjbCBzPQ1lRKWIKuc5Ag46ItHDCBLSMV9m58mdv0cDraVGucFHCU7E5KKJB8G7zMWMkmRuZ7bsmw7I6YXdTDSowtAKHXskubx/645uIdnkaeZ4B6rMrhN5hNU6ljUjLsZZFCubGP85r4XvpX5ilI7TVX96cllwCLd3WnFXDau0AgKbPRu0sA9/8BTx6Ya93oIWY+n/GBuSDXmR18cTQaSEIaHkFtyVrA2Whr3/v/9GaaRoE7V/2wLR7uwbUqKZwaaZho9J78RCj4PlJ+EbF5tJ798tgMV94uUForNTuOsq8cAF6vAQF6zXjnm3QgSbSrt6dxhoi+fdZ6GKHjQyWvjCdvpeFQ1OqN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Wed, Feb 11, 2026 at 12:31:40PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
> 
> Every architecture defines empty_zero_page that way or another, but for the
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
> 
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.
> 
> For the most part the change is mechanical, with these being noteworthy:
> 
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
>   parameters. Switching to a generic empty_zero_page removes the aliasing
>   and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>   ZERO_PAGE() is kept intact.
> * m68k/parisc/um: allocated empty_zero_page from memblock,
>   although they do not support zero page coloring and having it in BSS
>   will work fine.
> * sparc64 can have empty_zero_page in BSS rather allocate it, but it
>   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
>   but instead of allocating it, make mem_map_zero point to
>   empty_zero_page.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>   Rename the parameters page to boot_params_page and let sh use the generic
>   empty_zero_page.

With this in mainline as commit 6215d9f4470f ("arch, mm: consolidate
empty_zero_page") booting sh on QEMU is now broken.
The machine hangs before any output.

Reproducer:
./tools/testing/kunit/kunit.py run --arch sh --cross_compile sh4-linux- --raw_output=all example

> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>   that unfortunately had to go :)

(...)


Thomas

