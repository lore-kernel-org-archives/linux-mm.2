Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D23CAD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4717B6B0089; Tue, 16 Dec 2025 02:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BA36B008A; Tue, 16 Dec 2025 02:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C3D6B008C; Tue, 16 Dec 2025 02:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20D626B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:41:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB51EC0512
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:41:16 +0000 (UTC)
X-FDA: 84224538552.01.1770B4A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C2531C000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:41:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=A2mK+WJB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+43c1afaed0c1d876ce79+8150+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+43c1afaed0c1d876ce79+8150+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765870875; a=rsa-sha256;
	cv=none;
	b=C4SP1FyJEmbNJlRBr6n3picgFpTdxSkQ/tp8C2hHD3CBQfWrLvQoh1q5zjIWkQGDag460U
	LBuZ8Cxh/7ybb0M9pm+g2y62YtyZiB2hc3Y9o7VFY2VNrkmPysYRFmQ1JsFDgfYirQ9age
	3lY805uSnAdEdjQGhKreN0CKCnXPTxQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=A2mK+WJB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+43c1afaed0c1d876ce79+8150+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+43c1afaed0c1d876ce79+8150+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765870875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ef+/dRUWrEoAF52eKGXOIPSj0Dz2pVFYZysJHDl8loo=;
	b=wOaZ/RpbASmaZ3+e/PcD0ImDdwMf+PVIjiF6+N59GrM0eqYSqWDCsuCgWwar23Ggk07Bm0
	K4wg4L9rBiiAfAd98wDrTxMo6JDEUctpecccrpIBaE2eFR66hRT/6eJT+eHSmMjZfza3nG
	etS7NT7bzutch9qKKy4FPmLPJkGnJ54=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ef+/dRUWrEoAF52eKGXOIPSj0Dz2pVFYZysJHDl8loo=; b=A2mK+WJB1oecfFaavv+XJXaRX0
	AZPTOoctOvi4Gvp/7+MBhe0545EF01s9ezgAvVJrVMwMKr0r6J5CJT+KxXCjdaBygRs26XIY9DG+i
	sZUqDwdFhh/XN0UkLIFWzBOzx6/IAul46/gKDVeCcUNqTwAUlDIGr/0j/Pnasj/6gCX98Fi4vtYSu
	KLCIk7hoWkKkfeOvPzaPS5RVBORjxGxrbTygdh+4VGcttF6PocJPx2Hzw6jLQPOjDo68hAyzq7Z3l
	WewsU6+iL0MP3mfZ3/Fs3c7YTip1pxfYjpOv/yBE+vKz8kiIjaNzbRFSaJnND2YZw/y82MLVrrwkm
	inJHBApA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVPgB-00000004s5V-0YDj;
	Tue, 16 Dec 2025 07:41:07 +0000
Date: Mon, 15 Dec 2025 23:41:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <aUENEydFvVvxZK8r@infradead.org>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215200838.GC905277@cmpxchg.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 9C2531C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 83q88nbsc6ud6h6myyqt5gxdx4pp7sga
X-Rspam-User: 
X-HE-Tag: 1765870874-866300
X-HE-Meta: U2FsdGVkX1/xQPw2wdkjTDOM9/wHbU06qiOfZKic/Aj4quZlxkWWebWrnPdIsUMLQjEut4aOiDFjQogP5m91K7FYHY42cIeDFe8IC9aiWWw3NQ7bPkbzdLMXZol3UMbQJx7AYVWJnArGdwZOhh37sygEvoGOyhcprUOgRCSVKmROANx8BqQGNIuYoELA28CEix6NRaictJhwM/zGF3KI+Y5MbI3XlkM63/HuAClKWWT8zacXlTYTbh2CeOEipg00TJE0e7DJHccB7zuWkuH0TgTaBCPtYI3MkjWK7uCu+0eX52g67atMMcMmn6s0PuJoCJQiiielb60owulbQLIIRec9VRPZTPiKesB7znJVOVkcTfQQJ7etevwY8HgT7h46RTPGojfNf+QjDQy3j1q8ddCPd1l1fxj+AftjfykHgZze3RBWMKqjKIQQcSU9cpXBbZvJ5p/zMBFomo8suEw9bG1fvBGJ3NsUBEg6ZhoB/0jm0imwTHiWpgKXxSB9AQyhG9nPiEj2QZARaDVWo9kvwZ0fszpXjpL75GgouulWNlrwq/hP1Uul3TeFBc4ZvMnUtkyphETAtsJ7i+ykNAA/uciBBLsIhe1dBfYStC5EB0zlwp8zjvvlRdMurK2dclc8JtKhNzxNZ18nb+DcPH3rNRPY93Enw3y4GtfEBo2UomnazsqTvX6vJ+USZl397+IPR+6M46/llhV9SQGTjsR+igJiHKcE0bHrYRVXwAYzotzJAhcQ8XmHesEDumdgFucwZLHavlnibcTrhnoY/4eFOLXv+IDmHPz6DdOW4ocAfmmTnIg397j4jh0F1yl8yv+2UZJpBxbNq8FeHcO3owUYxghMOAna5/dWjg2JruMJIeGnjTidK2GkWm3wq2WDTgcy4D8CdND3YLiMQfRpjPDWsNZGkjl4l2xNplkb8TrkbwaBGuXOtDKoD+5TYfDOmvH8I17/iY60u7kHQhvjv7O
 U3ABa3Pz
 iQhCrvwTLjP3z0HHxyEdQ47ruJWvyzddLl4oLiB8UO9e27CFJDNmnkfn51cu4hi7TaW/H0xysds+clcTDY4Ff/C9qpNNbnGIrwe63vWc9AFSJtWF47WVG3dq5BYW1qrJFBS/N1MHs8pBoo8e0TWr9KzGt5WnL7pF+CAHHVzXkGFwSVkARKA7CW7fA6IGm/4jNf2pkBRI4bzNbzh9MaIegQ0Qu6xf7Djj+2byc78/GVvE822haZgH4Njo4maExDnUqZgRVI5S19UtydOVMkuXUjpxy8wNx/oR55MjlrXA6S7biJZtQ1vXSt4mZ1Y3wUgDPplKpsl8MzxaW3fRojOOUIwywXX7Hp6V5oojJbIBjl9qj2a0SJNp3T0vvqna2znqLDgw/4mnyhBZ5/8h8Y7KlByFIXv1j/1+cMGLDeBBGXYdls+yyWtedw4JyOqBNHaRk5VM9Jal/wHLLA6H9kBPvtuKiaQE7nHmpY5uFPQH854r3D6vhbOGbtLKkagZbYWk6r2IMe1s9K2WY1tKPmEmGgc0FXtxk8BT6K+XY1oVC2bu5DU/HOJJDa/3bQw+B8JbSilBvkb37vUTlHH4rdWkdBlI+tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 03:08:38PM -0500, Johannes Weiner wrote:
> Debated whether to add some sort of deprecation sysctl handler, but at
> least systemd-sysctl just prints a warning and still applies other
> settings from the same config file.

In general dropping sysctl will break things.  So I think we'll need
a stub, at which point it might as well warn for a while.

> Laptop mode was introduced to save battery, by delaying and
> consolidating writes and maximize the time rotating hard drives
> wouldn't have to spin. Needless to say, this is a scenario of the
> (in)glorious past.

Maybe expand on this a bit by mentioning that reclaim now never does
file system writeback, and fs writeback is already very lumpy by
design.  And of cours that hard disk with their high spinup latency
and extra power draw are a thing of the past in laptops or other mobile
devices.

Otherwise this looks good to me.

