Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D96E98FAF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 05:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353AD6B0005; Thu,  9 Apr 2026 01:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304456B0088; Thu,  9 Apr 2026 01:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219AE6B008A; Thu,  9 Apr 2026 01:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05F1C6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:40:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 945281B7C1F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:40:30 +0000 (UTC)
X-FDA: 84637917420.17.B787A05
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id E86D68000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:40:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4edJFwxs;
	spf=none (imf02.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775713229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0ScfNlJGSA2uAJMI4ulU1pLyWdBug8Lf8guz+qT7sY=;
	b=yOb4AdMshz5MCVBtITt6Rb5Vx8vnaCTJ7WkY0x4JsNZdUQj1vLtdbzmStrWs/apqKdEpdC
	N6Dd5AMC33wJxk/dQeu8R57Nc7Su8oWZieir0NUyEPxD7L4JkdXaLWw7GMHa/r1i6ZCOOj
	unBMJ2fn++TXKci6ebOHNY0IM75jHKw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4edJFwxs;
	spf=none (imf02.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775713229; a=rsa-sha256;
	cv=none;
	b=4eIE21rmMilx1PpHb6hb85i6qHHhcEzJNMlzfQyD2c+noOzJJKEEVjQ38QSQ4ZdnL9gPvR
	xfEoregdWFbU617gLbo5vXTNyWndOzb/V9lsuySUk3uHjMzQOjWSOfh0ih/9Cnpr/uxhlm
	9/S6C4pEuj0hmd/blL5L6JLXlAEw7x8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o0ScfNlJGSA2uAJMI4ulU1pLyWdBug8Lf8guz+qT7sY=; b=4edJFwxsbyJkPqyn1XaMjCDdSC
	FlJdc1layEXP+v7Bc2DUT78tlL2tMpEQhzr+g6u7TDB1lpdV4g2ptYtaNmR0IxILvz7kv4ix348K1
	uNyP3t9DRWiyviPTTydvWMvAMXtodrCA9szonPWUyLmrJTF2zQ/O6koGmwppKavXVt0HE5ZsWy91N
	vqSKoWtyS0HwFYqXcu345tgJGIeqvR0MlM9eOUGlttvMcq9nnZ8c7LmlKHquJloOJMU7S4CIoNFPg
	cxwyYH4tgGgBWNt8y9CmG1B2vkuN98d9XXsUKAnLFzbvg8I9PwHtYf0gNE0QXt4LUi7Nui/3cTqwq
	WmfrJCWw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAi7u-00000009jBY-0Up6;
	Thu, 09 Apr 2026 05:40:26 +0000
Date: Wed, 8 Apr 2026 22:40:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] f2fs: do not support mmap write for large folio
Message-ID: <adc7yo1_sr_eeV33@infradead.org>
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adaasm42rLxRY2GN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaasm42rLxRY2GN@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E86D68000B
X-Stat-Signature: 416xn7neu8anyug6dzmkw9ehm69hkj47
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775713227-846919
X-HE-Meta: U2FsdGVkX1+Kicx7gCMwKCazJoxHRVQfuFty56Sgzh6IgeWx6y4VqnB1wvOQhsIk0AgQ3YIKH1CMwWhe0of0Zr39OGGjuItlFvDQEgdgWVl0ae9+EXnihqshriHsYlVwGhRirjN/eoLple+Co/11UAH9W6GYUYUHuxPEh7yPlg2Fup+tTiSS+iBvpdmxD+7flzVb4hwdPULBgixWNmq2ccSLAUi98CJIYwVmMocpU46Fabs//S0ptuiqt2T0VQc9EGIct2YHr3ZGikNKtKh5l7HbCsnu+FukS12148pkhxXtcICWKgsNPrpwlLCTBZ0VnyXhE1HQ9iTfRtzfG/38TGhQG0dlWVIR1FmOGG2tG7UOAlWAPwHqBA6j2SuqaOF2j40PVi7KC2BR5IwbnQg7TAgec2VuvAvb+nospEGRErIe4gPiUiPVxRaFejNjnaClcqEIxiZSjEYQLeJqi0WyktII/gqxxfqpof4ZIsfPXqOdDEkAWt19/xFrMUHR3A3GO+/FszCQ7irEAv0mES8g4ozKZno0m9brNXeoGzBjaRW2ZRbflG4bdDz5JqZW6IT4NEYCVhr3ZXWK37E7mE84O9faXWJB4NRu9moG2hjmItDH9TFfgQlB9H3jEuoISLKUJFsT4WUfzfrnLoOw/Lqv6OXlTcU5MxwXADHwdzwBp6fHweyoS+IqRVsHrC7Nf6R70SUTXtDzb/GLwiO06IyWXW4F3SjDvrQ3Q67a6enWGwYo5op5As6t/v47ak/fniJn4REFqy0zycjpXNsxScj61slDQiQRFMzhTuPHtq6S4gy7UI9kZAb4JaD+n9qafozf4d7SO0oB/VHvMZk5iTFLHcoeXXndcw94UEUINWoRBQ/KCCstogyi0f3XWeuZ8mXVQm6kP8+pMv6H8wgaU+a2gJdVFImvhbDhb00P0BDyMC15iwACZDgE5jl/tvGTaIClWzzzX62bpoeioskCm3s
 0DyjcCFo
 4OlVYKGAFbBb9SCCG71/cSYjzfz+g7ASNOpKCa6p6BghDG8qZUp62G72Dyl/tD9xNIOdK9jRWAm756GnbwXxJBCLHT93fZ9iH0qm2OXDHY5PeYqCkd+aYsfmt0+5HmSq5gBB1QqxZThXk1gG2ezKZ4+HDw/Cm3xde+ayOlfP1fti0fkEPnJ19W1Yno7HXuFuORHxdc+J/SyHXgYxkKRnyCHdJkJydWR1KYzwgD4aL4eMXCSpG0aqXpF1XETJdqtTjw8uRBwN9XTRZWTkcY2Vd1pPZss2550OzzL8Vp8zy+Z9nJU4F5TqQOIwN2zAA+V6qdPdEw/BeOsKAy49LqY2AV/UeOYWbCpFjrquObVsXaLebbBrZwwbryZPxfLj/8zOoujohpFNN3mrnFFC6C/fUXhQ+5NkxuWeAR+KjHtptXAN4AO61dm+FJpgVIFKYP4/CCHsRcdIQXKWocFXdmomhYnBxS4PNIah1Z+xWK3126pyfTPwLIu8e+OoZvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[adding back fsdevel and mm to the discussion]

On Wed, Apr 08, 2026 at 06:13:06PM +0000, Jaegeuk Kim wrote:
> Let's check mmap writes onto the large folio, since we don't support writing
> large folios.

What does this fix?  As state in the previous round of discussion f2fs
only support large folios for immutable files, how do you get ->mkwrite
called for them.

The only way I can think of that is when clearing the immutable flag,
but simply rejecting writes with SIGBUS after that seems like it's
breaking the expected API, and I don't see handling for normal writes
after that either.

