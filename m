Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E3F2CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22ECC6B0005; Tue, 26 May 2026 02:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF7D6B0088; Tue, 26 May 2026 02:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F5D66B008A; Tue, 26 May 2026 02:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01EF46B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:27:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D89BC15AD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:27:37 +0000 (UTC)
X-FDA: 84808589754.29.6BAC026
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC2F51A0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:27:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NaA+mXD9;
	spf=none (imf19.hostedemail.com: domain of BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779776855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtttO4w0Ny6Z+XbNsM5i4+9hfhHRdRMxhnyuFgaQ2TA=;
	b=TFoHDJot4v+ZVZubjwJtF3nyVBBLO6oCGIuCXvjuP0RGScwlXNDMIoRq/KhQXM7DJVSPNt
	5z8sWCsBIjO49RcRoFV6Q+HPL/avXEFg3xKiPrVzNV7jt6SbNMNUe8sSOxP9mF2eEmpRTk
	O5NZ90x8IAuh7V8XPIAfRxa9zdt6kFM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NaA+mXD9;
	spf=none (imf19.hostedemail.com: domain of BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779776855; a=rsa-sha256;
	cv=none;
	b=il9LOLOsELe2rvQObmdNaL4mwCHOWhXVVpkT+qT7Hi5Ta6Q/8aaQ8kGMTDLjWrLu4p5RUU
	93HpuTKTPdsN6Tpes9hOuiv3Em1KE0UJeWnRmOFUSAPEPLp+tIrhFOGoia1UqSklRmucFo
	rKzdIOOjPTrQGTcwT8wwUBSbeQGmznY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AtttO4w0Ny6Z+XbNsM5i4+9hfhHRdRMxhnyuFgaQ2TA=; b=NaA+mXD9nHpYj0k802Ap/0C/t7
	XOGO2ve1EkLOdt9Pog0eglVcIxyTXNa6c5s0lqcxiZ9rfZ8Ncppi0cpNLcsUGKjXgahfpEjpi3Bb/
	vQdVdC0sfuhVgToeBHEtAqvl9wjKY5s9N+B7+MRNxY1L6xSu2V/2s/agmIDvuE8S9NX4/aGWzMv8y
	xnZTz04iDpbnTDsAc5U5zxPLrTuhqj3yYmwcaXCOoqHiVWo4CaOBIlFDvyaajGentI6AhTYsjS6pS
	tyWFk5knvZGDd6o8Rvobepdce6PQPDTVEo5TggbAr5+bh4ihSiWowBwJw/161lfDm6cgZiS0UO392
	JKhWlbsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRlGH-00000001AFD-0INz;
	Tue, 26 May 2026 06:27:33 +0000
Date: Mon, 25 May 2026 23:27:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahU9VQAxZE_jXi28@infradead.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org>
 <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org>
 <ahQX_JCgS9JWIhY-@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahQX_JCgS9JWIhY-@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC2F51A0005
X-Stat-Signature: cskgqme5mwhp1maoxncoismajki6ogr3
X-HE-Tag: 1779776854-686028
X-HE-Meta: U2FsdGVkX1+VOVJletA7R36Z3leajLiG1dERcY+Q+G0xo5+TjRAxGJT1A6Ta5lkzPw0tFVcHO3qfL12fy0gI+i2/bdc4cbT6/3k4rXZ41/cVG6rhHmRlVllLdoCkHfuoh7alxeHj+xfr54f4HmmbS4TP7XNu83pWStNzQRrl/TYzgmyrJMYSaKidyAU/kNa4JO4/aCJrI87m6q2G7A3iUj63tXB4v47sEsKZpkXCRN6SD/PVTV+4F4yxfRYylU92QAlgRKPOedpuVm0AT5WHfEx/+WxKts8x6BRU+cfNIfYTcNDUu/of7iip/2Ge8cfFJm8F8fWuyONkqg+HOlagDtlwtLouwMIIZWHA+eXTbKm36Kvey81pIMk45Msmi6mIVnBALqgqi8SqOhPJwNQCb/adMGgtu3dM763FUBN+2c+/Nnqv3qYUsr6+Cy6xkF6SQnxwZBvQusX0cJZKWSoHuVjErkMvD48d/t66hjNEOUz61R+2EhS59sUIU4sCEIUuNNVNg0KCfUN4ouugJDrxkPOWeeEQ3fdwX8nHPHOI9jBlY7zb0Xy5wV0/LYqfKtRCESadnYwmARTEEKr6NjyHFpLkmGt0kUMYT8cVQ3+VFmE5YIC6nueW5ZJ34E5ZcfQnVnTnPELlOlr375aejrViRKqDEjA2boRNv9oVZ5Py0FWJXrKLoRFh3iEFh7Glju/CY1i+R7ZKpN45rX4abNG4bJptgfEcvegYkbLuBu4UL5io65HWVXGVIeUZ5weYeeU+46/UsPu+K5zb+MQj9E5WTTeFTSpuJHNxiXPz9QKGTXTM5vGPn8+iPVSUnbTB63XiM4vmL/pQbZt3BK0ASX3XFHTuWGCxpjN6uLMXFFz1iFV0Ezo5rrfU9C0zQS9TMnAptDudNvTBM9ftjdFCkaKXJFNTNCC16+ZvEcOXACdO27HcEmeeLuF3MXVBU4u2sr8bWmYHfC0yFW84WwgdV4e
 v04jflvs
 Q7eYzSXUNs8UudMv/QSaVi10OiiK/Yjk+2u3Pk0PS5+6/U0L4xtdi9wPavgwa5LsjGdIaacNIRbcKDGLsc09uCUlCT5DDimKq58ijIlFaAf3QDXGO5bgZXZnLuPHaT+bKyjB9RkE0nz4YWSEnJeFqlkvHOnMXIDNNbGJmCo1TlHfRpUAPBq21ejmfCRfDOiVu5NqMqukYixL2mzmp+rCNTCgSF+1bPPa4SltB41K6I3cAvRrOCxTbQFAjyP4SJEYKUiniJSC/3OiisxIRCED/UyHtAv6lzC5k02+w384zrArfvNuSWAr+lEsqDNnfmPvw61p2oCS3FmtSRlN5vJfYkUKD44Oxs8h5hPYuREYFdRkY494OFmfQlJazGgPwdpTsNvtLRwAWpg2XPuWTzotXzKcqtvL0pEivZF7xo1Pte6Mqyt1TArw243GneGtAYGK/wsERH8OlRj/zC1VzLOjOTTMM9jj5DZ8T7WVjOC1kmviT1PnAL6aIL0kITiJYlmYxwfF4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:35:56PM +0300, Mike Rapoport wrote:
> > This does, but it still fails to explain why kmalloc performs just as
> > well as __get_free_page(s) these days.
> 
> I don't think that in this case - a single allocation on the cold path -
> the performance difference is even measurable.

Well, please state that.

> Nevertheless allocations from slab caches are way faster than
> __get_free_page() (i.e.  alloc_pages()) as it's essentially lockless
> cmpxchg. Allocations that need to refill the cache do alloc_pages() with a
> little of slab bookkeeping overhead.

Please state that too.


