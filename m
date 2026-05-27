Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6770CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0DCD6B0005; Wed, 27 May 2026 02:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD8C6B008A; Wed, 27 May 2026 02:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3E66B008C; Wed, 27 May 2026 02:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD38E6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:22:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A51DA053B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:22:35 +0000 (UTC)
X-FDA: 84812205870.13.1C56BCE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC12C180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:22:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="RCtA/4X1";
	spf=none (imf16.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779862952; a=rsa-sha256;
	cv=none;
	b=xiw5Rmjc1Nc2kxCpWDmfoAqkWoIYGb1pomJm0sFcjch+Q1LV+wufeM8h5n0XbReroauTeh
	S5jRqiyMY4+6+IRZBWaRuYmulyr1rFoiN6DBfTFm2R0VqftSZ7GJGe/IU5nkALtg3Lyyiv
	3FW0Bre1RVMkFtmPQNqqRR3jaKUaYcc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="RCtA/4X1";
	spf=none (imf16.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779862952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIgn2pTb2lMuNpwxC9YljPb7qAqonpElKjgih7wuKeA=;
	b=JItrOguuPLgWBM3+QNTEmQNN787q5s2W5D+Lb5p1pKWYmp45Ij0S14Vnj6qu0DKJ4aATS7
	2MSDQdVL0JhoJp+5QlkTRaV3WNNNJflzZjnNb3uzwGkgPu3Dz2Z31HSpE+3VH3IM2Y4Vu/
	6mpBA/39VbtMNTKT1QUVlCCpf/TucKk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sIgn2pTb2lMuNpwxC9YljPb7qAqonpElKjgih7wuKeA=; b=RCtA/4X1G26+BLIr7I/PYFUdTY
	8uwJSaRlcCbSxn5XSr8N3Lm5+OkQnR/gXCK2Y3Ci/F0aRBZJmf+XF/eobnpq3pSiRdqITeARtvojH
	n1WpNWosatSSsRkpQ0+gSgqLNTKZIyRQ0jgsvvLCiQABS8wGJRm+BpILb4o2JYoPE07e3rHohQAMY
	HJoHTan4Tyn8ET+0TQe9K7K+V9XbTPCaCrprD0U6vrgPJCpHsnk0WB69CWV+AuF6YzlC6/B5ib7v/
	EfMuLlBdUbzrvw3rFuAm7EVsmJsqVDQfg6Te1WX7VlhRLIM+PPs4vqi4NeCGgjrl1UpSRMYGm2K8F
	hquiZvTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7ev-00000003OVG-3fl4;
	Wed, 27 May 2026 06:22:29 +0000
Date: Tue, 26 May 2026 23:22:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahaNpbG15d6StT9d@infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
 <ahVBCtsodsM2FHis@infradead.org>
 <ahXcsrxUFfzoVCOr@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahXcsrxUFfzoVCOr@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC12C180006
X-Stat-Signature: 1675ntawu1qu9j9o4hhu81spdriykpmz
X-HE-Tag: 1779862951-102222
X-HE-Meta: U2FsdGVkX1+jcDzlQQlmedF1HufbS9Eu5qlqmtST1PsX8msjOa6ZSwryoJzs63mOxQ+vc+yDpa62CmSqJwCezzsnXU34oZXnvAUtN7gjUunHauY16Fy1f7JQTplp59M8sjVhQi9gm5X5GLJbP3rI6DejuxM0VkU+J4/8npUEJDTUFbA3b/rstEOaqHfdyUoFmyIYnKSDaLCi9Hnfk5PMe6nzcKD/glMY7Z2rClZGbDfxj0EC4FBIKM30/XZwgS9ecelA74if17xwX9qilT2ooPdMYmoxO5MbhKHJph2qMYRP8SXU6ESANrW/D2kQF0Ic794X8EQoK54fe9+l9tYt76UIWacl5B1avaVf12b+4DCHzcQjAowo3IUfNgfqxX6ELkebu0RxV4sUw7cLTd7Q+mM6mAwpNAF0Wyhy9r/T3J99snW7ow+T6oI5Wezb8swJ3qCHDwdP/6oc9AQoMN52bvnTTEiQ3QU69X9se+mZixtM+4PLjSoqdNAUVe9HH1v1S0R3HMtpVUX9bE9rx9S98u4u1+JSelevwyUJC1EWDpZ5AzNAawMparXg4zgSIXSiN2toqMXzf/rivpAyQxe18TZSVU+rDnSMHGNqR9E+cqM5OYVkQ3OI7qUlFZCXD43ZrSIJ8Dg74bAZYYM/NXRd2VXHBBNWYMBZVYf1AVKR3hKYr1exD3Wnr39FO0SxwGARTUi3lq69f5+nY1cEqQSI517YgP7ten/1grnqLQR6vH0tkO4yHPfZZS4PHFMXTvTkpPKLvtMDvL6IB4A1kc+MjsXfxUv35y8QX8Tv7BRBwqwoJK01LPuWgC3YxdavnGvEFYGoEcZW0y6Q9aDhAg3tktD7dUGskCesWn9cxsNQqdm4URctfK9zV2PAAoF8xugOOeBzfIobSEIQulBsvQ0NB8ASdfuhrBXmUXGVsN+ZLr6LVArl0gF4Y2ZtGjUoUOCXAq1f1RPo0pmygeWfXJs
 BMGYaFAs
 ruQ/bhb1EC7oPCLhElhTwi7zCW5u4ymxpgmkADa3AoWZhpr3OAqAVpKCt1buN8vNvZMrF7hFTlDARso3B1auEToS/9E1KqKcsspGlszo6cOZ2gXf4b1kHupiEzCeyx9IxxR9X/FalAI1oIGZBUwwAXzQkP80fmEzZ3WlLUAihAbtrbe4052e4O1Ub5OMU1uu+tsi//GUPjfCpA9gevbUad9vdqrj5eK06x0Kv6VYqWjhLzbLRWZI1paMUDxpldr1D+m13ue1NDBEIthXNVQXInh+4w4WDk96XmUDChf143jZxQR467qZgi1Re7e+aY5GeIiGwE566wEORWEBbdAlyH4P8Tme2giCn60on6K1qxH2rgBWFRg2d0q1fFNaoOh8duCvu1OepC4xVv/QxZfiei63GthtY2I9j8s1ueLLTxGDyJ/kbUJHFuAyn/DjNzEz59HpZXi5IuFof5UvyrTeISpl1fETTnP+FZqn15EKH0RbNdMiYK5XcLeqW+pndhJF6zJV6Da7kFGj2LUyYpof6y5ySqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:47:30PM +0100, Matthew Wilcox wrote:
> How about:
> 
> /**
>  * bvec_folio - Return the first folio referenced by this bvec
>  * @bv: bvec to access
>  *
>  * bvecs can contain non-folio memory, so this should only be called by
>  * the creator of the bvec; drivers have no business looking at the owner
>  * of the memory.  It may not even be the right interface for the caller
>  * to use as bvecs can span multiple folios.  You may be better off using
>  * something like bio_for_each_folio_all() which iterates over all folios.
>  */

Sounds good, although I'd captialize the first word in the sentence.
(Not that anyone should follow my spelling advice in general)


