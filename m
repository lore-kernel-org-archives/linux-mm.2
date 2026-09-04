Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC18C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 07:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD7E6B0088; Fri,  4 Sep 2026 03:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695C96B008A; Fri,  4 Sep 2026 03:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABC76B008C; Fri,  4 Sep 2026 03:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 340B76B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:57:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0FCC1A0818
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:57:18 +0000 (UTC)
X-FDA: 85175324556.23.5946AA5
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A61714000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:57:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VrI86WOg;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788508636;
	b=reT0sRn+6ULBTGsAp0aqklvGPSMt7yhRC/sSJjn96Nu9kfFNZHjUy2rZ8UrWcJn86ab9TH
	j/4w3QSs45EFncDFDY3nWnhHZnOFoGisqSmSFwI812rxcjJh/BCDcy7TulzTcWZCTC1Zfk
	IFW7qu+eHKAGaKE0NTBslyBkZmipxqM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VrI86WOg;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788508636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmT7OlNcE4l1rFmFGpSOXlaCfNFPCRnyiYpJaccmNYk=;
	b=Qs+NnLNsH6Hp4Y6ZTDpfDsDsyc3oiqUr900/MpJhYsoQilOiNzjWiwjGSgva+kl+8NPNqX
	CbIavveQLSovE2wco1z20neWss8kBjK6JkQWc3jSpUDQrT1CPcFgNRStDS19f53QplPrZl
	eLxNmRFXkRz+oc5aRmxRK9ge3EkPZ3U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mofboeBHEKPxM47nwHB8XlxHXL2t2jru+ee6kaJSofs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788508634; v=1; x=1789113434;
 b=VrI86WOgcsw4VJIek7PZlS9k4DOocTvIKSLjNUiagzUpS0RgP0cTq7yjf9//7VXOS87jIPlc
 8HsYhU5KlkSi1ilF+oemSA1jlU3S2AN+roOVwXJ1+ddHNE+AT4qMGevMrCNf6KQLLANiVAVXWig
 y8PRkLua8j4VVWyZ7JMaxImw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 85c4279ad02e47cd;
	Fri, 04 Sep 2026 07:57:14 +0000
X-Mizu-Trace-ID: 85c4279ad02e47cd
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 15:57:11 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, baohua@kernel.org, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] mm, swap: require zswap for xswap devices
Message-ID: <app513BgZmP8vgGe@fedora>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <20260827094509.1016740-16-hebaoquan@kylinos.cn>
 <apkZNEe8/YAwygbA@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apkZNEe8/YAwygbA@yjaykim-PowerEdge-T330>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A61714000C
X-Stat-Signature: 9amngscfb7d1ue4oohhsmgypcm3mgyut
X-HE-Tag: 1788508636-866075
X-HE-Meta: U2FsdGVkX19VlSwdAXriEo+3niumhGzd8VlTn9+9r/9NRPc7+DW8TKwwFUCCdwYkhUr4lEhcsv39Cak1BRE2ZNdOT6t9jWJjdkSymbzgWqF5THwnXeFHl+oq8b4bO707lpTILHeagGQ1HqFaync1hUbNudc84JlGxIUAidFo73xf2FGNjX5R9CD+s11ysBKipttXZcZWbVY3+gsWoOUoZAsHp9jNG0CyqFea1fPRDXldGIVO6YzA4HOHG8+CCGDKcDfQ+5Pkbi5GijkZdaADpm2OWUexI6SnyMf8JNwtOS4VDVGg42G0fC8PqRH6rEWEjQB5u0yCzKsgse5Xl1+gxiVXkJOthNguzbr7vXnHRYr2kLxM98v1u/vrF95iH+Fzn0ZMs+t8xlI02jUDf9mEh0FaG7mdzyqk9PbeyRizVSlRppKuSYR7YxNlC1NM5ybyG5iWPYxfVP/d385m6XVuv31MvRJX/x42o3+LyManPxTbJ6X2AX86RGXRIcyC3jtGMA7nfDPeR9RM3DfwQ9aqS44CEMK+QMkAh+IckhMIIYxrdAo72lxp15tuwCec6EIifSVZV6rGUbSTbhTVg0s2StofR1vd48uvneoc6tFYYItOSpQmmOM73v+EL1uel9iIbAywiEzdnB+mw86eXO5h1Z+66qHWLptc2x+thbis5TM50+w5xtgXRqGEqUGl1Z35qD34apkVeQx4UWL8/oUE4nTYpEOadc6OQTLjd/v59lp45aiwSf1jTQ7IkWIIRy6hoEDJVQNNfjlmbpgkQV68jWI/f7Iu4fsP0M7hFW417yGSz5iL7ZBupW2hDCcjXv1LMq9Oz8HCnBjlC7+WwrSU9ymU1bgTMeT50skHwnh2bIe4beY08qNncxgngiBFcNUW7KqDT/k3KoYHNhspYiDTi4KAX1yH5MM5Rx+UOJDrozBN20B3gKgkJiysuCuCmeXXawLmwMessxl9wrJUtjE
 rJ4RAF4X
 xMMcc5akNiClFRT6hsZ2i6i5j5zx30qG+eiV9QiIE9Bi5Rd+eoAZvDjhwY+0Tjf2Bee5VT52NWZ2NoapyCAAqt+Wu43vQi+ScH6l+dnG1VDZiuoq0JJcXPfAnQEa5yrIQUzlPwgvgYIHUxoZM3Bp4FvG1DbALkI6sPNuLONMWogUXqTbLdrh8eS+RSx1h7MAxO7+2OwXdweug9I8nWhBocKvf3RkKyJVHt4kNVeCjwKaOuqOztAIBKEW/6KZoAShBWHOnJ/jxOZ5Itig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/26 at 03:52pm, Youngjun Park wrote:
> On Thu, Aug 27, 2026 at 05:45:05PM +0800, Baoquan He wrote:
> > xswap has no backing storage: swapped-out pages live only in zswap.
> > Without zswap, swapout always bounces back, so the device would
> > consume swap entry space without ever freeing memory.  Refuse to
> > create a device when zswap is unavailable.
> > 
> > Runtime disabling of zswap after creation is safe: existing entries
> > stay loadable (zswap_load() gates on zswap_never_enabled(), not the
> > runtime zswap_enabled flag) and new swapouts merely bounce back to
> > memory without freeing it.
> 
> Hello Boaquan.
> 
> If xswap is used alongside another swap device, wouldn't runtime
> disabling of zswap cause a problem? 
> User assumes other remained swap device used right afte zswap disabled.
> 
> Once a device is allocated as xswap and zswap gets runtime disabled,
> xswap keeps receiving new swap entry allocations, and every swapout
> to it just bounces back without freeing memory . until xswap's
> entries are exhausted. Meanwhile the other swap device sits unused.
> 
> If my point is right...
> A few ways to handle this come to mind.
> 
> 1. Once xswap has started accepting writes, refuse to runtime disable zswap.
> 2. If zswap is runtime disabled, stop handing out new entries from
>    xswap (drop it from the available list, or gate on an XSWAP flag).
>    This would also need nr_swap_pages, the visible swap count to be
>    reduced accordingly, and unused cluster memory reclaimed.
>    behave as if xswap had been swapoff'd.
> 3. Support falling back to another swap device once zswap becomes
>    unavailable. 

Agreed. 2) sounds better. Thanks for the detailed analysis.

