Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2082CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B596C6B00B5; Wed, 27 May 2026 09:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A716B00B6; Wed, 27 May 2026 09:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20CE6B00B7; Wed, 27 May 2026 09:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 946106B00B5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:11:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EA5E902DA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:11:44 +0000 (UTC)
X-FDA: 84813236928.26.702CD3A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 27570C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:11:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gQsiIwZf;
	spf=none (imf22.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779887502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKdKxKK/XLyDZgjYlRAOMdbXKe9G4yc7L87Z59l45+I=;
	b=z7oDmJ9F3Fb6XrNUzoy+jxiGFih5ozG5FCAXxSkzQ1SWW8TEWzA1xWH3dGq/cwYCVLU5Ps
	EQscHQJ2YV4NwccL1CPvjMhIFvUpF/tp4mxDoVpPrOOSkOA7yPV+3M7zDJwYbwFgfTIaDU
	HeIrJlkQS+epyRpvTk9vHnxi7aE2o8A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=gQsiIwZf;
	spf=none (imf22.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779887502; a=rsa-sha256;
	cv=none;
	b=pV23vzrGlsryZD+7MHJe4tMAHNMxullzqQsL+QBaNPpXSSqdLUverKsWh0Oc+Eoso1n8/H
	U754kroyBiOoMJSAwNeKuYcwENHnOGMKwY23VO6H8uoUu8+hLHLgWxtb93dyxPBunnaCE+
	pZ8mvyfMuOk8u8eibZ5oJV5NwYd/ho4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lKdKxKK/XLyDZgjYlRAOMdbXKe9G4yc7L87Z59l45+I=; b=gQsiIwZfpnwpCOlrDJk/DJmUCJ
	tBGAp1b4xqu9IOlVIRm3yQ7Du2CSS/4R6c+dC4dGREdVbyxiNzDsuf+qv3F0J3epwa0L8P25C8IFg
	TpSvsQM2ZQc9Z13KqKstR9Lzj0d8m9MnzqJPQwgcaKLqel7YD+IPalb1CXf7hejnN2oPuBNsYyizc
	GxU4ZC9YSkodOqCX/ktDejbSE2xni0IDFcSwV0sDksJrkpsiSaUvPrS+KFnTOoBlOo5ySzFXz1DHT
	AFDgseiiNiHZYc9LgT0R1RnvRNm9LQAnN1SE2Prh+IwZ6UI8MwiunkGTKeRLxrGruxujoSb3WozvN
	LeMTza8w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSE2t-00000004A1i-2QpC;
	Wed, 27 May 2026 13:11:39 +0000
Date: Wed, 27 May 2026 06:11:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Vlastimil Babka <vbabka@suse.com>, Matthew Wilcox <willy@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
Message-ID: <ahbti6M8zRWR1oGa@infradead.org>
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org>
 <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org>
 <ahQX_JCgS9JWIhY-@kernel.org>
 <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
 <ahWwD0eqj3cUgaKn@casper.infradead.org>
 <8b780901-8184-4908-8bda-56fac42fe6b3@suse.com>
 <17258981-d5b3-4ed1-9b3d-56a0b6ecb3f9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17258981-d5b3-4ed1-9b3d-56a0b6ecb3f9@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 6s771osssnricnhustu4oijshc79f9uz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27570C000A
X-HE-Tag: 1779887502-766115
X-HE-Meta: U2FsdGVkX1+2hK6GsGlREa0KrGFt4tA1FA1GBPvG/nyTjPVXRoDkfpizkBFz8jn6tGPPdUmtL/Wzhb3SnNSP2z3CnQNaoPUwzzE/Zm2sz2w0+kK0s4Ka3LXR5VUFjqkkbXaOE849Ys93M1zf8dezGmMiSsibziH3ERo/9S2/o6idztAXKSTxGHW+C5X+LGhdEydiIDk6BOAye8WcWdgkzOUpO4k6ANfpzJZhs+saIzGdv5Ss8/r8x65Uf9mVY/6haVAu8WB7YIjqjGGmY7FwMDkKCxOTBG6a946RgtA201yeehxu6FaKDGaPf2IfIf1Ih0mdMYjUmr0nWzvF2olxvWxZqLmPuu+hPYY0IZ2tGqgZ8y3GFFOhc2GZL3EA2DLG+j5JOXZw672Jb1shWPWtMqR+fmCTz8PpLd6VJVR842/twpGSYz4J0D41Ye4tbefx0Xiu7MmIGQru02CgMRHWRqNm9J+1lR1PxstY3qUZMbxdlllpFhAI9zVjBwoZCV5TpGDiKzNMyOIuz8jFi6B0iK9kJvqldgw2toPKL11sVcjIZJwNQPNLnwtSLnYUE6oKpb8MHSX6vpC83i81tBD8FoXEoFPeNzdvl4HbRzg3MKg/4XCkoomuVbJJUwPyhLT/kkrYR0jvV/hpxp1GiKAcI0e3LdWxuAEP8m+lGLoP8RLYOH6IMB+t8U1emueZ3VI08SyOd/r2Y/Y2THdYV6kW7pQJ1GrMRxLei6kfEeJlo9bTbkW2OLgtHRhxAVNOy1VZtBWfwVg6MntJQZB3x/8pdgjBlLcDQb9MdGwnVtSJinw3wsJUiig+xgEsSglF0jmnSnW/anQhaK9Xp6nqQwexPQ8x0T+tPBuAw/gCqjvzaObIpuooS9zLvmJ6n0caIQVa9sZVlt/0X/ershLNoO2/uL9OjACiOP2e5mXodH2UAO4yFpDLW/pMw9NL3QxjC+QnyBT3U9NZmQ5HyC11yYA
 J8MZ1NAE
 owVXn9rMBSJpv09nqPXoVOTWdPGfyY96OMwZ0QFj8JvcxrF2v9mevXm1Dv+D7hJqYCr8V/6C5OMTHZa/8RUug863BvF1xBI3FVesnppM3XteBrXXa5eKohCWxy6II6VjUEOVLDBMrdvb5Rs/XvuS7HFanTWUED0AujQQxOqPv7ATuXls1wvl7QiNFZzR3wpFwsfi8dTerzeVKPKA1Z31HnO+FM3jWEShd9O8heT+af1kpbQs2dml3AILFH9GLGNTiq31M0Ifr4C15xUphIbOay5TQkyAbc7WUkzBwN0nwLtUr9vTK550NiRKRU6vvD5HH03q9cp269HeNpQ+j2LgFzjY84khuHSK1O9jIco6CYmSfbwU5Y5V5heh5NCau8myf4ISLqmpXnF049XQg0wKFbL42L0TUsxdtbyK5hQfA/VKzk4j2/Yf6wm68OSiV4ZiZarmQsYvxY+IF8wXr9q7cqmdMeht/Sk8HTdHgTGtpyl09MhJE6WeRA0OIeJYzcZAj5VtB+zuC1QM5eFQPixQUeg12KMxjuiU50IHGiIioWlYKdUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 12:04:29PM +0200, Hannes Reinecke wrote:
> Precisely my reasoning. In most cases, __get_free_page() is just a
> lazy way of saying "I need some memory and the allocation should not fail".

Huh?  __get_free_page and kmalloc can and should fail.


