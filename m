Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AE90FEDA0D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254DC6B0088; Tue, 17 Mar 2026 15:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2058F6B008A; Tue, 17 Mar 2026 15:45:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11BC06B008C; Tue, 17 Mar 2026 15:45:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 018D16B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:45:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DB0E1C8B9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:45:32 +0000 (UTC)
X-FDA: 84556584504.22.A9D86DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DBA031C0015
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:45:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yYQ7HO0g;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773776731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mi0Ta7P74QaAEs3XoolFkoHHwvqt6JLTuNUIqiVViMM=;
	b=Bb+8sJD6H0491qhBsz7wYI3/tisr1WvHSVwLcHP86Fk0Nliav0Lyf6N/oyeolbGzlwwBGG
	JfzffgMGSmEo7giHOY5yL3ZtO0xSwAU1zqJHiyksLBk1vqGJwBreOKhziNk18s1PtWhJML
	Bbx7Y86lRVwnFNxYNMcdvm+0DeRne3g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yYQ7HO0g;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773776731; a=rsa-sha256;
	cv=none;
	b=1fIDOqJGyRFzwU9iEQl2xdXg+19tGD3kv14xxvFaxAP/G0HfaJWqB3KYO6m6ff65TEA3xf
	A1yOfW8wue6sD9VUemvS/lPELYSEKyAMFpxBb/y0Ch3aJVq4DEmzj9KxXVFHp90XZEUC+/
	UeljPQF+7Kts/pxxCkLPymIVp/1CDzc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE37643C94;
	Tue, 17 Mar 2026 19:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676B1C4CEF7;
	Tue, 17 Mar 2026 19:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773776729;
	bh=v6YL1YyMV662ZbfchqvmlhuiuJL0pVwqFzh6HccbzKI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yYQ7HO0gn0KuSl2BgQ2sVKWaYpPEDkQaCA3L73jq12yD4nNzESfQ0hYE7FtewMhVM
	 jiNBPTWZfLqg/jCXILiKDgmltxTjTUSn2rkCk9OlsMwBxxjUMTg+/KzqY1z5Goj7iu
	 2zyTzW0YYt3kE6hZQoAbyReSPH1cMWyzcYU5ZQCc=
Date: Tue, 17 Mar 2026 12:45:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH v2 0/2] zswap pool per-CPU acomp_ctx simplifications
Message-Id: <20260317124528.961ebeaac03f69e65cb767e8@linux-foundation.org>
In-Reply-To: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBA031C0015
X-Stat-Signature: okgx7idjcidwcc3cckg7168fikknwdwb
X-Rspam-User: 
X-HE-Tag: 1773776730-162264
X-HE-Meta: U2FsdGVkX19hAipgZiscCp+T3NnSRy2IRHkFdbXM7CwKqMGSrFv4HoYf2zjXSSQ3xZ0wYl5XjiLEPAWHSY9cwYNneTOugr9yIb6SGUeVJu1xYcBQthlpnk94ZmVdb0vA3ivI5GJDXh/cdRmjpNSoFirSWp6EsQlBKbPpRHBEBY3j/qYAu41nwqsw4o2zH2AQ4JyCYXGGL9s7VGliJMHdJkoaiTega3YEjPMUVZRoODGP6UbGyGojPsdm0j2G99hXV8hb8SK+wfgKlyPGNRubKdQu05rOyq0GNZFGFmAStTt7fX+At+/IH6evzuFgU2QOZUSH37KMqq03o8Dbe5boK39v4gOBkKXD7HrC3Xpz7OxDzMSv4JO2wBlVR20D6Gw6B4LVWcZF3HNb53TmncvUng6VTqq3uEohmIr/pW/L5IgK1W+GdzF/QCg8or+WEdhI/GoSDT5L92vg7B3cI7kshewDs1JQ2uiwKV6PKA8WiJdbXPOSpIrBDTik4GuvRXHuqPo274AC0iAtz2IHAQZrbfkgebmN7vVDm8aozynOJ0hA3icu/Mi0Zg4XP0aEcZqw2QaTd/OQoOEEzQ0ifcoucNn/fKB2UA1slHUAEybWYO4LwamgKFtT/6b/RC1i4SDxiMyfUNUHWwf9B6gAyXohN1hCT0ByK9i73oU2WfM2YW9jj2Zi2jLhb5hPmp2SMTVEoc7j0qDTYHCFY4jaYiG801YpPTZJVtjwvBOTm4h6qNwitfXL30dtlr5/CLhpA165hCqq0qyXPPGgmN9Calc7uBKGh/OdBmmr0M0ZKWGdMEQ1ZtwllU8G57fYt1u/+/W5n6UVN0Mp4TsUGZHukDALtV882YSJ1n+ljQ7FxqH4T6Z3z+2vNeMXEfijDC7BsTDJ3hFMkxEdoEQ/j9AfbpvJx8a5Ntj4VrAhZ8nlBXHnXNPbNurKkicVCfthl0HE1GFhzlfmPrO7i77yjDo1ghX
 I9rtaTVA
 hIt+hJOLqYDnR+RK3p+L4W77Jc2l7DUtzqlTcnCEH6FSiVvRTJna5YEdntHoNNbUvpSpBeIK1F/JC5pUG32VGdLJgbrwdnSy2UlyMtledwVzniXLtnJnbAz9mfGS0ob5XT2PpQuUtx8wG+syp2aAbKT6IUDMpr9UT58byV96Rg1iIZsf6HKUNbTbP/KM8xIJzSadCtUQcOESqqlYbfKACYLmR2Oiy+rewrVcV9KhYAeuria2QP9NQ2WkXMKaFtNNcB8Wit3VxdmBREbyWBvlGbhAPH/K9FKQRgvUrXY3Litu6qrnTXRaL6R5hxgVngFqK0SASzX0RG+G62okPTwZD4c+dsIn6kTa7ddRVqrmeLlve/hOjL6RcU0LFtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 18:48:00 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> This patchset first removes redundant checks on the acomp_ctx and its
> "req" member in zswap_cpu_comp_dead().
> 
> Next, it persists the zswap pool's per-CPU acomp_ctx resources to
> last until the pool is destroyed. It then simplifies the per-CPU
> acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> 
> Code comments added after allocation and before checking to deallocate
> the per-CPU acomp_ctx's members, based on expected crypto API return
> values and zswap changes this patchset makes.
> 
> Patch 2 is an independent submission of patch 23 from [1], to
> facilitate merging.

Thanks.

What happened with "mm: zswap: Consistently use IS_ERR_OR_NULL() to
check acomp_ctx resources"?  Still relevant?

https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar2026@gmail.com

