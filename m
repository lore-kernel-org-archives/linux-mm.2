Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C0C7C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047CC6B0093; Mon, 10 Aug 2026 12:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B596B0096; Mon, 10 Aug 2026 12:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FD16B0098; Mon, 10 Aug 2026 12:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8DE96B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:00:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03FC9801E8
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:00:16 +0000 (UTC)
X-FDA: 85085821674.28.C9BA903
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C720100007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:00:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pSFqQ1IK;
	spf=none (imf14.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786377615;
	b=zDILOXN2PBYp/ayb0bClQn3To9ASRuSNSDQnvAtOZXnlB8IqsnreKgUS+eG1DTcuy9V/LJ
	MVTfeMqrcrUQ3Ar/LRMNHSTkDOI7c7YROwwZhykvDbXU62iBXbhptXHKjl9v3xQZsUIFgF
	IZFTl9/7ekU6Z/i7eBhPmojf9Jbh8Rk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pSFqQ1IK;
	spf=none (imf14.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786377615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fM1TmwL+V6afntTWcbDSTRYQvzGnvPI5cULUs8c5LhA=;
	b=HJJthi/O0kbNAQconDsV16jKuCAvRgc9uXKaGwyu/P+a3eTzxI+yVVoXU/1Ep5gJ87IDFM
	FRUqSMrCzTheFiQB8c4Uz1wdP2D5tLjtgCSe71qXWjYzQNFm9ALdV0kAXT/lLd17mrXl1K
	R7sVCoAB1JdO2gJzYvv4H6XYZs4zkP0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fM1TmwL+V6afntTWcbDSTRYQvzGnvPI5cULUs8c5LhA=; b=pSFqQ1IKQaxnP5/zrtrDlgaL1e
	yB42zQ70EPHn0xvIxANDJF0HL6Fo29/IHA+ehHzvFAflZDSpVaXw5tlLZc+Z4I2KDnaXNygIbZdg8
	YxQPls9GmlbnMcE+/DSJLIdj5I3X+QpMzbCXEU2le7e/lylqahd5QagvZOFArxXDhBHKwpX1r0dne
	q5gLD+gVrfFiJWdFVSYsr6HYoM3JcqtKlNd69o8rhrErGiZhnKAT1sqcVOlYr68+fegUzHXNsGoFS
	6andjJc4az9aRVoQpoh51/AY6y3pkUOgO3lL7N89+Lsy90qrvWMeoZtFsHA5VNvndKl0a2dH4EPER
	rM2szIGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtSQ7-0000000CKMy-3kRJ;
	Mon, 10 Aug 2026 16:00:11 +0000
Date: Mon, 10 Aug 2026 09:00:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <ann1i5VjTmgChjs7@infradead.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806221031.79050-3-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C720100007
X-Stat-Signature: 6f3se7uc1zj1m9nsq3hzytbzw68mqmwu
X-Rspam-User: 
X-HE-Tag: 1786377613-81984
X-HE-Meta: U2FsdGVkX19zqGbf8sAaMEmy0pkI5vF9b1BUN3rGKnPTGHnDvs4LjENIkyJCCfrApBeqJHkaASghxTcWew3V78GgW4y9csM+iDssYizLITXVtP0yPBsrQKJ2L2zCsgJlvEw0XI1PVjzxkblruGe4uV/RClHoPzsGFfEfCLcxlHVVbcXH1ZyMZKwmh4YxTYdpkJHYHCxHbdtZWT7QASUCqZmqw3oivykk2KmqC3OUu/UGpU0BN2tXcjO66cWroRJmeiWME8n1RnK/aD1PzQBvU68+sHKrPoXeAiJjvSYJg0WwN/T9tYDFoKl5eOtv9imGPVpO/+4cqLiuOe1Xo3izVudzlGZ7SJQ045Ae5Opja3Z3CI3xT66ppcqwm87zsz5QQqrgCrVokIFbLxM/QNUW9KgmgG3IBYYZAGaOKbJH/fZMImG4bhwn5qL4dlZruMs6ejiEiX+2tNEZ/y6uV8gA7wWXZBVPyNGl3xkl+CsoGW9KSHdTkAiFAC07TJHjcv8B8rzGx/Ml84aKl/Lzu6Kkzujo7qMA+o5ATxSu7IDeXE4x0fAdEX4AuwybRX2z4ENf0GuSujCk9m9yvW65rRxN6mAQYLEUE2W3O0RmmNhqx+VHJDdiAzEgajTWkZbj4K4JHzbPfn8osAHpGEs7+PLQ31OIJgoU55IIrTCrHIVyHgj0fYwiedWhRYlMgME7CaJ+ZCopvGN0AL5kDMuwSmrRiDNtVIxWFwK247lgB/2ZJrsHH7mXg7kRGcwy8p7Q+6lLLMpbXAB0rCgFpIbOEmDlXartRMJNyfN0ThYIN01KIEOMwYw3moC2/jjf+14E4OqVjlObyLNf/EYZseo0zTssFPpTxLfmMTPZtxNE/9DYcslHUBqvTt+pDwWShIMB8wFga/fAsQtFhbfzEq1U7LnPDAobWYCVkyMhww9fYnIWkMesqrv290v6q5K8IkNHFayrjWxkAbNjuXdEaoamitP
 dyLgfWzR
 2D7YOprcHhGGTG/X1nIFREKpCFPhX5sqn/hMTfKzxV5bLN6nTnuqsOoo89gVbkP1Zwgnq2sdMEABm5hX8ufEBV1DuGKUkmA2ma9rwr6qktzGuErSGIaWS9+i3l4wnrGiGhX+Oge9/WbvWjwBWDEgyyC36L1kvu5O0uT1/J2Kaw4h47w5verJZgC4u05C59cHOgs6Dn+ElEP2Dyu2nM1feUV7PLof7hdpBZ+S79Rpvy3mLR/FJsuf/X/JBgdWRmYUfRKLux8LV26aMDwbcamOCJo/eEVM+y0cdfHR6F8ZyVtbMZnkj96y4gtzeGlDsOWvhwHJnDPJUCvqixO9N6kWrFv+0jSQbxdjvgrQNxE33+0Lw+qUiKnRjlc8jQTaRqiLHBpwz9eXCdWPAfM+D76HAQNTOCVyZl/3dQSx6EKKcoQGqkTMWl+JBk8CSYwnZKrMEL39vnzmYsDfvc3jGgJT4vN/zNQQ5r/cLE5Jb7aaFcVNsJzo32sY2Eovphe3OKkKZ23Y9eowpMzuBL/6yyH7n6SNv3QIYlYLQxZ9aAfpJGzklruiMKKP6kE2YmXc/CXtEkf0McRUEqNPjxfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:10:30PM -0700, Eric Biggers wrote:
> To fix a deadlock, blk-crypto-fallback needs to be able to make fallible
> mempool_alloc_bulk() allocations.

It doesn't.  fallible mempool allocations are a concept that doesn't
make much sense.  Please just go straight to the backing page allocator
instead for callers that do not need the mempool guarantees.


