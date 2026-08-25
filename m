Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD51BC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 06:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98A36B0095; Tue, 25 Aug 2026 02:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49666B0096; Tue, 25 Aug 2026 02:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9860C6B0099; Tue, 25 Aug 2026 02:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 722896B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:00:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF4A514032B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:59:45 +0000 (UTC)
X-FDA: 85138740330.09.48418A4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17823160006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:59:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SiuYedWA;
	spf=none (imf08.hostedemail.com: domain of BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787637583;
	b=wlT5N8cTiXZeuawkGagz1n8XK4fe/oKFtu7A45RxHUyyomCK5Ywrbv6TYmn+Ot9eWSZm13
	fCNazoVz6kusZO/oseuteFBCULA5AFiQkIR0jZ0b0gcAb+Ou3ywVxbXLuXbfQnd0ZghK2n
	GAPwmS4rRwjRxvc/Pksu5KIzS0EwcAQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SiuYedWA;
	spf=none (imf08.hostedemail.com: domain of BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787637583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IR3Zm75E3ko+jggu/rLc8YgY9r9WUIC+1cB4Z43RoXQ=;
	b=1EvmL7Tdoqlv9eGsZ8UDDxkzw4Jv0jzgpFgkB/I6MKhjhcdONmrcnKKMyfDenbP6xynhoh
	iYzgazLe+UNNabpprVERJfSor3A4iHgmrcf8TlJQhoAETdWazthrreLkfYlhLI09q3bN6w
	iggcJh43kaUfElR5Kb2jaMt5Tsx1bFg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IR3Zm75E3ko+jggu/rLc8YgY9r9WUIC+1cB4Z43RoXQ=; b=SiuYedWA31qkaLMP1orR0Kj7/0
	ACtAFA9hestsD4rtRCzNOADP6T9vEIix2ZLj8kiCPTcLfRAYuYIkZ4vqC1f0KwzVSitnXrRpgnjJk
	/YCVdiKjhYrwIjF2I8ce1xZDP3+86zsoR6K/cXDG2C2UhsV81FBU3BNexqLmSgLp3OO9cfiRuhEMZ
	6X/82ARyhospkcDFbUcXnyEliSjqbt9XQ+uBt0B8MqebP6bbeL/aSN1m+kj58w4b9N9C0tjGLg9o4
	KRhi1jcZskQB+MJW2loiCd9Mf7lt1iuGG8bOxB6EoPayybY5WNveGmx1l8qBaPlHWEfSw0M9e10Eq
	TAZVZXAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wykC9-00000000CuF-3J2W;
	Tue, 25 Aug 2026 05:59:37 +0000
Date: Mon, 24 Aug 2026 22:59:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	usama.arif@linux.dev, hughd@google.com, akpm@linux-foundation.org,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org,
	dev.jain@arm.com, liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev,
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	kernel-team@meta.com, stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <ao0vSde26_Qar0IZ@infradead.org>
References: <aoXYh9EPF6QnlvIK@pedro-suse.lan>
 <20260820061337.24669-1-lance.yang@linux.dev>
 <aobp2CtWZBlw4w7E@pedro-suse.lan>
 <aob9PF_H6CCJMdkk@thinkstation>
 <aocFPRgqieScf_yo@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aocFPRgqieScf_yo@pedro-suse.lan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 17823160006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: w5ebxx6wtahun1ey4a9n5gw11oh8osqn
X-HE-Tag: 1787637582-374699
X-HE-Meta: U2FsdGVkX18vuwr3TABn0LTebLyHYI/7iUsn98T+uPXVeRSSZ9CVwPcbqZcQ5c5XnMINm/RXjZZLtgT2Kbgqg4UcR32ma6VBG7o485TrHZ3Tchgh0hu7J98g5N4Ozoetihe+ejpsKVvtUTLgYWXbU5Ufa4hQ0cl875qnTg2XfXeSeDgfazBHv6xsOnc2yiDZewi+f0UxcDQZsEZMxH0uX5iKoKxhoj4iohdqa6PT1MNHGsSq5uullvQvBpPCXwhEw26gFpP+4DHTbbwsPGB4F7XhuaSh0MnnP+SG2QDrnhMI1+rbF1LUOwLxxzVlJDJ+Qe5trrSiJU93BW9OGFRrA+Rvu6A7wGJShyEMQxHWzoQgDWZtRHZPhn/i96AqiOoMx/B3vdPGl3c8JRX4Ak4/37el+nskJOf+AJHwd39fgeG7qzL0PVrcFXLFIJo4cCU8woisZdztWKDgoygacuZPX0sEU87RsJ0/j1eNPjl3DbbN07/lOokA9laCwmg5lR2cyi4WSJvV2+oMEcXIXXmukizdkhrnM9wgiIAPUrC82X9fEGsSYinDJPJOIzhgYEZdscK2G5RGD02D5SPs5ONx8wwW6eFBqQ2nxvbaUNLEGYIG7HBjd6SaBCQyIj2cR7cGu1NI42CRrbcbpU6MH1AkcWtc03zY93d/K2fPR5YVFbffrouaNfkXirX3r7YVIrU730zRyRCouJHAqn/5E8VkkJ6dPRthF4CZHcPTIQgRZo9GOK8HM1mT+yzRTDB+UdOjOax78BQ3e618D6eEo4HNnF7ZTGKd/orOfVDECumq6oabELdqZYCmhZ/5Nem4cO6l36vQKY10PEM4zoXLPT88CeT2NVaJSfKXNjlCW9pcsKqSkM8oyjaU2d8xnSbWkOhYyJ8ZnsnU8mUcIlXxiM4pTKxvZFLOgoRbGhx9wX3hIwUjG6w/D6H3UoZpIz+CiD4aJm3niNYDh9bEMUJDHsq
 n6JkHsLd
 3euyB+zgmOIsGYwLVrKtUeiV+dRpwauQ9rcBsGunuLgBDMqMsGQ+CVH4z5qYeNPFQH6xG1yu9MBNLF15gQGL+1kJUktVxgoiHchNTY4DceF+L7ZTuhTUYdflS3KlBsccN+1FiHBn0c/NUC4Juk1pNDEpHWnxLAMbLXazr+KDTlWJKhWlzI7raxcnZz531Mag7o8u2Bkrvc6EFCoy40sl4fCB0/RJ179O7QFF/JK4gfDaD22jE36U/SKDxwRtc6OHFSiWdrEx3PkEptnM5xCUxWmTd5kOwSrmAKbh7KRnHca7AzdF2//3UDCAwpdRq2pSyZJLf2DyL8UBssGXsZhGuRG33fKbj+TyOlCGcWECFFmE5ActB40hOGCml9D4zsWA0VyPsflwClfoLT4gUwtK+I2nu+9hXIhIP2t+OmzACjRVZYn0t0O6xjM1E7kwPsbMBwRJia+7hviu+n+yhEdvtN6yuc39pps0ubWOaEMowQ8yum04LSt3o91bZS3O70Xj6yZWQeshFc66dLCAvLpBiKMsflyrlumyRSKU8hlNb4ZWSG1BEHYqdhiBnwVR4VSxstLCSpR6FpTOBFNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 03:10:11PM +0100, Pedro Falcato wrote:
> > Why? Write batching from large folios is a win.
> 
> For some context: we were discussing (off-list) the recent report that
> systemd-journald had horrible write amplification, worsed quite a bit
> by large folios. At the moment, there is quite a lot of write amplification,
> but _only_ on mmap writes (if you look at the write(2) paths, you'll see
> write_begin and write_end which tactically only dirty what you actually wrote
> to, block-wise in the BHs or iomap IFS). This doesn't need to be true.

So don't use mmap to write to storage.  That is always a bad idea for
many, many reasons.  We should not work around broken applications that
do this, but change them.  It only took about 10 years of bad reputation
for MongoDB to finally fix their act, so it should be possible for
systemd as well.

