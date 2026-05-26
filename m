Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48B0CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181FC6B0005; Tue, 26 May 2026 02:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AAB6B008A; Tue, 26 May 2026 02:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 098806B0095; Tue, 26 May 2026 02:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7D26B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:43:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6B181C101D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:43:24 +0000 (UTC)
X-FDA: 84808629528.17.8D9EFAD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35BEB1A0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:43:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="1xssw/2q";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hq/B9MyNzIjDWjlOiji7GymTvUxjiro9ybF2gAh0PIo=;
	b=xoH3gdIuEeNiDBlw6kl+a2ZQbWlKVNbO5fRGSClo2nK/r/dnMlEg3ojltshtZfW4XD2aRd
	TOcBn4bQFgM15F3ZFmIf+eCWMnvcoU8VEu4qTwiCDQ5V3CzZeIb8nxylQ4TQHNOc06n73Y
	sazhmWDwldV2T/jmPGRTMhc5eaFGt1M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="1xssw/2q";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3e1857ac9913d0bcd7ef+8311+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777803; a=rsa-sha256;
	cv=none;
	b=T+tO3DW9R0YlUaDkbUb6SalsrJJ8QDwgomaf1WZ4wU3OSA/wMGUxVnl7aC7JiWr3l8dJC9
	Yi/shFZzpUBfnExF2Qk+a0t98jgXYO211eOADW+nnkgoBUIco3A6J2vyYhhqmRgU977ZXg
	UIhrYVMaIcjhc1LIyAHtAU1Se+Imncc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Hq/B9MyNzIjDWjlOiji7GymTvUxjiro9ybF2gAh0PIo=; b=1xssw/2qxfIsqC1gECtA4jqJVw
	bTUQbS1P9ouQw2xLP9TXBNt0HN93OyVk6QEwcUNY03CQ4NTIBH8SLpka1g0F7LBH5Do0LqZo6xYsQ
	WMO8OeogR24+t/fclC7A+kHpFCBtIwFTl6YAp5Yd5ppUdRe+Hh5X00e916FmV6FIdmiGU+rz+z7yZ
	LiITmu0pNh1GqKtUOmiq8Aeu1rPBnPjch1wloUe62V7I2FuFK2+7dRs8MBh+vztsTfHTCAmuicgSY
	arVsEzUodlJuZIW/OBUP2r3BGjiVTCEQsNwTCg/MHfIig0lJ/pxN8e97IozqSgtiZ52gUXImTgUAp
	ekuKYa1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRlVa-00000001Bzg-0NLS;
	Tue, 26 May 2026 06:43:22 +0000
Date: Mon, 25 May 2026 23:43:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahVBCtsodsM2FHis@infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahROtyLcr567wM8l@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35BEB1A0002
X-Stat-Signature: p6krqn8m3ffo7hfk9iwa14roebsu3waw
X-Rspam-User: 
X-HE-Tag: 1779777803-754419
X-HE-Meta: U2FsdGVkX1+6ttZpZTHoyqLpgTydiYjg7Y8yKfIVhB8JL7u9oJ8DhbBoWvSXY5tRqBLKPxTWkVeD0pj7HeSt60K+aHBIpY1LiyVPtsfdPygwkOfn41OYwHgCJO0n4C14qPlnZVSarGR45wxEWxkl4e9Tc31G6/jmMTTraS68rIScxcUZPixHXbMGSGYJJvFTCO59HgwRKtfy1AmtDQA75mmexoobYOOU4XP3izFZJumeE9KQNAYojcpDG4pfspJ3yHf1Q6zqPK8LrzS1JRO5X2Ikc+sJ9KojqqwG5OVQEYMjsW6IG17LVzqh18eRlHSNUIGYnTKdKlKF6YUGFOp6QTTynnh3PAxMMtzRPLo7didEa3dUT0Qb+KJMBN+6jKOZPwc6vlpnw7zSuDYh184eLrA2Ij4lUsyR0GnoWHKe8RHMMs8Xf0vhWyTwTUJYp+T8g2HsTabPvNFEQswrW7eyKCIR/z21tXu9wY/+93Pad9NZyUSAfk+PrffjKSOogw8j8o4HTQdUOwd3Ff61ZDtyJZqFUwFv2Jcrf8EatCctU+NNIqO9DxKqxiQzAkR/tLEumFbQpvlGi+HIqCtoMHqc+80bF2ED9cIR5fIOrJT3KkVcP5o2EJWvSfNQLGSLnS0ZWdnZHfKd965+C5r6YhIoIFVWMV7IinbmWcSy7PwoL2g5YNYGJSoRQIvNyTdOgltxmz3orj8LbppHsXDsb+CetvkFUGo5jDvpyOeEIiBBhofZMsSXgPVpY34gkA0m37+3QQBY9wfSX/ibRK4Wr9B3idNyDR+pFiVYpp92mqVguJDvUH3nhnlcIdc1FVImxHDATa7fj1fXo1oKKoo9yxMqx9flkhznEO4zKoy55xj+cK8od1q4bpL/qGXG1INX4hwMTsbsSpV1hofIlLlPqBkTA8MYXzi+/aGCcQhTZOgaTBWh3FBS84KWvcfa1vU10bqaUBKG7LYzy1pfLpNR/H0
 QgUMKwvh
 XyhXewEae45qo+cDPPrINUgAUx9/m6ib9WelMsaKQ4/voJCZEN6OVUX/YJDd4Fh1NIDf++axFUgtOKeUq23YObhv/xTmquMDkRaga1E3zoLazWaC2zOMwMWFI9y1H/KC0vdXolB56HQJqHlPyphdPuUoe0mAHeifR6lhfwV1vJKG3LlbjWJonsT85lz8v2RJOwMVBg02t+CaJHwtro79W9Fgf7TDdHYFn+HkaNOJh8H0lrJzN93ZutFtpvVpObycpF9vj/NtW5HesygWcboYGJqYbOWQF5Ua0rjBkBuSqyDR1SilfRjAOpr5F6xOjMGh9YDxrpVS2jBMI/d5Qzm2xhyXq21Tmc/EMi0IdshUeQn0dH2I4yJzmBBP8RcQbnbKqbO/JdtxEiKHEmO/3Jd+gjSRXtN2liuwnH9EcWHK4Er/bFWD4W+dtX6urC/hLzd2GoGxrGwEvnIsppmL2hQrhh2dsJWX0VLBusnBGniBIHuRK4wJcdvdgWBZIiOimPLjjYqCtC6vlTXFCPfosqrzFvNxRGKacFD0APRB6owctGzof0Fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 02:29:27PM +0100, Matthew Wilcox wrote:
> > So I'm not against the function per se, but the documentation must
> > explain the minefields it is stepping into a bit better.
> 
> Lower level drivers shouldn't be concerning themselves with folios.
> For a start, we can put non-folios (eg slab memory) into bvecs.

Well, that is a very good thing to put into the comment.  We can also
put them into high-level bvecs, so framing this as 'only use if you
know the memory is folios, which you can't unless you are the entity
who filled the bio' might be a good choice.


