Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001DBCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60CE36B0029; Mon, 24 Nov 2025 09:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596CC6B002B; Mon, 24 Nov 2025 09:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD136B002C; Mon, 24 Nov 2025 09:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30EA16B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:12:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F18D512B84
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:12:22 +0000 (UTC)
X-FDA: 84145690524.02.E52B406
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18F46140007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:12:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ds+OwBMN;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763993541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xLp8kMMXDgoR0l2xfKWNkKZqzE7V4zLpt688TlFoHw=;
	b=WJbyFqj4hBGT0YDcktnS6HX2SD1+VIKPhwdOwGhWEKlrGK7ZPpWBED5B/QMbwx6QPhuxAe
	D7kWOrB2P1jao9uNx8sbHfqw7yWEERLhOwbd4kFWNnZymmXNcz2eKYh7aUHw6YZuGxWWUy
	umqUKq5RsGZnXsXbj8FjJxFJ7hj9zLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ds+OwBMN;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763993541; a=rsa-sha256;
	cv=none;
	b=6kwX3GiM+ky/dqAtoPLa0t0EAUn0creMHKYSM1R+8owL2tATtrUwORHXGpr5wAng8I2N3F
	MdhgA8PdPOHn3bLyMZTjTsD1YbjiijVIa1sfONWfldcrnk/49ALZ5p9t39Q+PpWNrLortD
	OdCaoxBIhGXTfLm5RM9Om9SXN5Ls/a0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2xLp8kMMXDgoR0l2xfKWNkKZqzE7V4zLpt688TlFoHw=; b=Ds+OwBMNb+i7pxMGZKtgZpA21R
	SajfQTbZDpJwwLTIDOlfgaBumLuVOJy0588kSbjR8F3LP2N1eyPONncdKVSND9JwyuzSO7mTXmQ6R
	LbEsohiHHpd/nlXxCrJOJPnWYgGyVto322C/1SrU0ZRD2NGaZH8nDRMPqRAS7GGwH+gBUb46SpxVu
	2sUmcLJpKXvBAJRX4A2gu5Zfg0okIVrYHAhAAASqGAvQAlThFgIwhU7klTlwTBNZ2iotuA0mSct0B
	p5upXFt5qXD+Tm+npcJa6bu9CW/mgZDyMNc7YMz9AagwZVHPFFNQF6et68QQIYpAICDwZbCTat6LS
	bbZIuLhA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNXIf-000000075NS-1PRu;
	Mon, 24 Nov 2025 14:12:17 +0000
Date: Mon, 24 Nov 2025 14:12:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 16/16] slab: Remove references to folios from
 virt_to_slab()
Message-ID: <aSRnwXiY5cP6zs5Y@casper.infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-17-willy@infradead.org>
 <aSQErJNLLev2CDPa@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSQErJNLLev2CDPa@hyeyoo>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18F46140007
X-Stat-Signature: ir3uc3jsbbc34rub48qgm1aine9i36dp
X-Rspam-User: 
X-HE-Tag: 1763993540-977071
X-HE-Meta: U2FsdGVkX1/cuY/6Jlkd+6PMZIIFLs/kkAI9beFXNwm6nJpqdTfIb6YYctCTFxO3LQmsfV6DujG1UpT52pwph/y4i2W5NRSNO5B47haK05V3MfePtA/iaDHL3eDUFQqx/CuQyY/Y/S2bFpcQtIX/Y9x7rUKm8yQK6PZcNzO8aUZZKHkxmaVZgTC4VDEtQ++dka+WVrsoqWQyv+0mWnXAwVrshXIwtCuc1eeTg1kDj0H8FXfQjRZzUm42vGi3zxZniJgTVJCyrBUVmhHcg1SPTmtp5IrPkIfpvibXbqwvPUdjII1wJWWUmO43KNkROYD9EYDF7RSanXzpvNjC4TpF3y5Y5FvLDnZDuBwzuQcFClw5HjDBRbeRbJh7J0WVulctEWWVdeXx51ZghufS7P2Uk9zV2YH6bJo8J1OFVI2UFuxwt3VQiqqig1Yn6gn1DM+9mxDvujyMtTcxM8gsc75gsMQzfo3NprbuA7LEjRxa2hlP616iOAp/PJ7HnyXXinj3gzaBddubV/xbyHefG1D2leSTt8XYTNcirJrxMAuwnOcFMBN75z0EuJzX+FtEFV3NtzLJVDyqxJvsRDVL/ZaHLhY/LFKLbHHPvvDu6xaNV+nbVLwuSFc5AAK3nXl5QDRx7zMw53WU/9+qKBG057WyHdc4YzNz7UNVGQ+ZjHtrkE7c8gxRcgZbDbhqrWcf+ayUfq7AwUNvLM8YMbWPDLuXYZlHyWam6ThmryDHvHNPmaaZUFzB1up1g3fo/UP6QMTfuqrsmzq6+NqW0z91vMR7JQcQYJ625D56xy7G9vzw68xIO5W5mmPWq5GVGDEDbsnQpMBeivoT1qGuFvkOwviTg2wqyoGgWGySyk42BX2zluu/KOAW+PeSvdeJSBoMIWtRurrzWKNuumbmWBflAoVk7aBuZRHCwEhP5LEk1eBt8MvVQBNcdNC5IO6J79sgNnyDgerSLHkP/K5k2MhbnSV
 BrA7ycO3
 GhdJccm6EyRIs72YlCXkmc8FX+h8SGJNM1aCny66S0KqsyVO5YR01kl2oWeSQ6flmeypNPMACXUL+px1XSRAIf3joz/cP/icnOUZnrpFGJ2hGJNFtBJHPVIdN3sme1nXa6EvRikSzs8EpkKfDKuR51wkg5bfNT8pVm7VCM0FVD/ffGy6PHWUlQ7fqgTzU+YIboo4smuNqetZJU4RXpDXeDfE9peHgrLtqmOEWfEOglht6U8IK19F4ip8Ze9YGGlJ+oGtcJ9rhAVD5g0YQdO072Ij4d2Z2aEODqxs2+/xIu0kF4EU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 04:09:32PM +0900, Harry Yoo wrote:
> By the way, there is one remaining code snippet that references folio in
> alloc_from_pcs():
> 
>   if (folio_nid(virt_to_folio(object)) != node)
> 
> which won't work after separating struct slab from struct folio :)

Oh, thank you!  This is a fairly silly thing to do today as there's
an unnecessary use of compound_head() to go from page to folio.
Each page knows which node it belongs to (and that's going to continue
to be true until we get to an 8-byte struct page) so there's no need
to do page_to_memdesc().  It'll be worth it once we do get to an 8 byte
struct page as we'll know what kind of memdesc this is rather than
having page_to_nid() figure it out.

Patch soon.

