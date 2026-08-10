Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B93C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798706B0092; Mon, 10 Aug 2026 11:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748C26B0093; Mon, 10 Aug 2026 11:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660FD6B0096; Mon, 10 Aug 2026 11:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D06D6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:59:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFF07140203
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:59:08 +0000 (UTC)
X-FDA: 85085818776.20.A4A3EFA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id B139610000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:59:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZJ3qN0ej;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786377547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fk75NUD/BmoiB1CyVr2P7UQ2xkUj1UE45Y6IWow9sxo=;
	b=diKG6Cjga0ntDTq6zrOaCnhOrnbsdVnFMRCL4gqcK85HkOAXwBaqCHnNgWprBKm69ExG8M
	lzPF0Q4t3Oat6WtmuaCy4KcTZPaUoYDr9dSIESfHwBjgrYb50Zw+77YqZ8kTkIuaaRn7J5
	rcbL33oJnq50qUy4OSx1vxVlMDIL+mg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZJ3qN0ej;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786377547;
	b=uHnp875jLo7dmR2x0Wkln+LsSNlOf/LoXPPZ2NVjPWmgf3RisfA0ecyd/mlnqnDU4oTj1O
	guhQfrqsGFFxxQ8sQaj+5m9Qt6uM6ngEUkgWufo9zoJqzf22btLjvbbAjjQ3TFpyZrp75q
	X10VdWmIdMZ5k7qkr7YTpnPREZiQjS4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fk75NUD/BmoiB1CyVr2P7UQ2xkUj1UE45Y6IWow9sxo=; b=ZJ3qN0ejtXFSKHlhFx934iM4Mc
	NVQuNBntP9qwBdLgfzWCZ0K1a4LCDWTQVcLlW4GR8N2CQXWq8GB8ONYKMBfAN8+2O+725VzA7YCYE
	QkfoiSrDe5P7CocJOj3zxI7aRR1Wcm/Efb1NCHQlRLn1w7HOpZ3gE5jk75om9tkj1spkhMfWhdGgv
	kgEwBmnPZsYCaLb8nvky3FizzWwqoCfJRJ1PyhERMQBiaICMuT/6KxoM3DkQM0/vbyrYtsD/Erlgs
	vtoIY5EkkMxBzet3M4Bd8/LDDf66I0mQPXwHoAXowOuG1bivYa98kO7QV8MuvvuLIQpjfJV18eE3b
	KkGdZqNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtSP3-0000000CKCT-2eON;
	Mon, 10 Aug 2026 15:59:05 +0000
Date: Mon, 10 Aug 2026 08:59:05 -0700
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
Subject: Re: [PATCH 1/3] mm: make mempool_alloc_from_pool() return bool
Message-ID: <ann1SXYaljourJMP@infradead.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806221031.79050-2-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B139610000E
X-Stat-Signature: 636yrbbtskgodxkb3b76rqjm6dd8xj6u
X-Rspam-User: 
X-HE-Tag: 1786377546-710940
X-HE-Meta: U2FsdGVkX18wLjTLNGqNn1keI42jhPvjXunj5FIa7EL3Pc6ataJ/2T5K39ha4JGoL77VIvhWYXIHgz5mzkW57lvPruocrDGjSMUoeJoHyaZSJkHX3BDvmkUD2rkcn4wl/0BqlNsrUvvQlcuRdSqpQWsfow45l88/EgZAsUsYyJobkztJOg8jxyazwuYtXx4NG6kQWnupR2mIeNOFAJYcucrIHUAgQX3d4iV9umP4/ECXj+2BiZLdTIwXao+rqODkOtDAbK4VpS8+XH/dZEy+8aiixBf7WiJWCBRr4zC/16+wzWO2s1b/VhWlc5PM14QMv0F3UBtUgZCGvJ5jc3e+Q4WeqRjdz4YEYul8lo0fww0KcQao2bOMIMtZ4tDRMAhn8myRky/Gr6r5SYeB3b9PIrNS3AkIXOxzJtyzt/k5MBd6hTia5r6HYq3JQdx2f//ajIs3N/rA61qN1blb6pedWah7Ezg1AVgh0Rz2EId0gO5yAXB7RnTjaTeK5cbDR+CHd3rDC6PHP+6do47+s5oyCb4NJtcCquV3fdTopRkPvTZU/snb9p+M+9Kac7IJhHtFyAF7Et/cHPF0SLB9Y/k/h6e+JE0X6P/n+1+Df3FLHIkTSjRfpyjLz+PiyTBFoO1FIubkyiN4iP1gGm54uZsHUSC8Gls0VWMF4JwsmsDNdnFu8GcwmKBUHpMBcya1qPs5wdALz5Sh0q29LOzD1/q7AJpaixSF9vajV5FcEyRq/mTHAS3yawONka1nwruY1VwGw+4uUlUpvO9C3arHLB8MEEdrko6LKuzHOTvebx1G+8pRGKJky13o4bgbCFnqXk89BcI/qwhPesBuH+pxJnlT+gq2UeOgKvhEIW/B0tfYTAjaJxCYt9iJ2EhGsSgjts9btN1MT3qVu65q4joS9Yr6HPyS0PEEkbMVfw6E7HmbicGg3f0FwuAejTnlk5RhEenSaKQsUQuY/F5ptxLdDZt
 asmLFf62
 SZ5aauvIcB6rf5SFjkEA/ChiQpaTNXRW432gZ30LvH0dNhyoDL1FgzEBkbQNg/q4i1qF/EEZ3Sk2i+q/eGWK+4PMS5xLPUV29MTLjeEYgQmtrDGPLxsIS3hK2DJs7zkJ8AJVZakdTSlJtDWPFHlksuozk+hFw+Ibh8SPJRPn3unn8InJL0svKE+NylkWnRrxnUOSxfettOZnfiuQkRXHZ68HUJ4Ij0ZafczgDbXthUrdtobepGKCKKoCcMTOASlSCTHKuP8bf9mlZ/pCfN2FFLLfrgCI7h60DbqUvDLqnSwDtFvnJ4NNYRBya+cnqZ7aGwN93BK2gllwx4m5HcGtCbBDSsnrnbNarGlYxmQ+PN8VUeATX0i0nZKAPO0Evgpv8p4ts06fPH4I5Oh3w8CxR7XOkSPtING/EURcJBH/GAa37OnSl+pgRQLSTCF6XSOOo8/Zkj8ojTVsCjhMGYjl8YMuxWMUopc/d/M4IEDRPzTUcCUfvZbqU1uWIfaT/aPAOyHNXjNFoezlzjV5zF/kcHZc07AsvL+JRo617oOWy+NNMx2nfXg9BPusWKuCWBdYwgDVC56NgPVO7CZ9FAPGigwqxXf/Rx0y07hL9PPxFrO8eeJmhU9W5zmbRoQUJMvkXdzkZzsbY4ywLBqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good and matches what I recently did on the slab side:

Reviewed-by: Christoph Hellwig <hch@lst.de>


