Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E497FCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A7F88E0010; Fri,  7 Nov 2025 07:06:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 259258E0002; Fri,  7 Nov 2025 07:06:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD5E8E0010; Fri,  7 Nov 2025 07:06:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DCF78E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:06:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B113D4B942
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:06:44 +0000 (UTC)
X-FDA: 84083684328.03.CBFCDBA
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0140D40012
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:06:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517203; a=rsa-sha256;
	cv=none;
	b=LQ+A8tpnUkvxBWmusD5FQz/XjgNOrc4dUITUx1DXez7FZx+t/6sCobc5zO7w4IVZTiq1pg
	EgZZVY0FHZ4jzVvdlfujiUPeGimT4/cNJNm6+R7wLjf6/qjc0MJZ0hXmWgj/aZS84YkUE6
	7cwm9/vAKGjTdH3EkGcoIbaH1coZCfQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Z9OqNev9/6JMFESBK25MmK6tzbam6/1o5mL0L9/6tQ=;
	b=uqH4rDoPgRb/DZYg9wEjXvu6sYXpTWa+PBWwhMrzAQd6dVmOhPtmCPbpsWIrJy8eI9IXuO
	MjqJLqxxa5ljDwmGelM5ToVomtzoIXg7mmhGbuAy+xqYNQZHY6gp+RmH9hKWcw77RhATYQ
	Z8U362W++7JRk/hFcuulMFzf3xTiqU0=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 101D4227AAE; Fri,  7 Nov 2025 13:06:38 +0100 (CET)
Date: Fri, 7 Nov 2025 13:06:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mempool: add mempool_{alloc,free}_bulk
Message-ID: <20251107120637.GC30551@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-4-hch@lst.de> <20251107035207.GA47797@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107035207.GA47797@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0140D40012
X-Stat-Signature: mgokyqs7juft8knonhuqk6fm4fyfb4tx
X-HE-Tag: 1762517202-744514
X-HE-Meta: U2FsdGVkX1+0DczK1+L+QO1FH1uKLlab1zVjGmsTy5EwwfzXGvU2DrVj0WcdDYg9Tviv76aN5zKq4W8OWyKXm8T3fT4/tMGjfxjXdP0C2C4z7zOJaD/2vraoQIKJI5U0ueFD4VEHqXPWNHPx7Ux5h5att+kkgh+CV5kJ/P2SbBxlx5s/RXsUmaua5CysBeYmSnaRILGc5KK+zor2+qa4Vn1DLGVc9SHWiPESaGeYVixlOWo5WB8k50ZSTgSty8aANeHijXX3Ce11ZN3ZQrtdv4CU51jsgJSTwQJw+03iUK5/Dwk219BBeZ5ILl9jRnSGxkHQjKpsQg6G/L+M0018BwG9dHoYtLlAJnyylQUAcogrLD7dUe97Etb14z1r62k4yUfpiI7K+kHbaDsM/jKgmJZP+EcyA3iIqId/GyXYDK/r5p6yroZsevqEpSyWm1AhtEtRTPMVqUwZHz+0zd+2y8mG0/i1kDYnoBgoVswEqDjLwX5IixmAFDyhKrU2wwYKLj1bSjYGUVQrLEd+GXSSe1OLKWe8IyGETY5m7LOGbCFg3C2tXT+dFQM+CQ8LWQq3PlxHCD31qOIaJqZBwsVeaizBrGAlKehnNQd3rjMCUUL0rQGEtkZognuzxjpMli9/daZ8nRn0hsjVukFGJ1SqbstpE5d8Ei9OSniUl+yS/PlIFWOwRZ4Ex1qdZC8bV8T97ZzCZjKTvmGBm29Xl0MQCl5gEJeuF72AYwuLOqRK1ZHbjwR8Rl/i1ZJxoxetDQdzhi7hhhG6L7VCDHGPKgNvFPYqvnf6Q1zBFpHwjKl1OlPjRKgrBJlGOgu7MTBWrazjdxtvmizTqwbd8E8t/CqEclMEJbjVv2xsWx9lIPzZAsQw0zna8adDmNR0DwwxpQyPQ9eX2HVqu0Cwj56b8xHxoEMAvKvlFczPlQnmIAEZokSYyEcFI9IwABRLDOjJN9L2tQ3LM68nOt5HIef2Aob
 jF10p+a6
 JwmL/2Zh9udvdu4TUGeP34QOy5U2TzZGTFe1YtED9pAgVMFQnsGROqLsnHk1F6NNFBmy+ePfS+xWyWT78uM+j4tb+ybZQB5gAyRoB9ob0lVECRj++r9QsvuQAxZlQ9NVfSvoVblGStfrijqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:52:07PM -0800, Eric Biggers wrote:
> > +int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
> > +		unsigned int count, gfp_t gfp_mask, unsigned long caller_ip)
> 
> What exactly is the behavior on partial failures?  Is the return value 0
> or is it -ENOMEM, and is the array restored to its original state or
> might some elements have been allocated?

Right now it frees everything.  But as per the discussion with Vlastimil
I'll move to not allowing non-blocking allocations for multiple elements,
at which point the failure case just can't happen and that is sorted out.

> > +}
> >  EXPORT_SYMBOL(mempool_alloc_noprof);
> 
> How much overhead does this add to mempool_alloc(), which will continue
> to be the common case?  I wonder if it would be worthwhile to
> force-inline the bulk allocation function into it, so that it will get
> generate about the same code as before.

It's about 10 extra instructions looking at my profiles.  So I don't
think it matters, but if the maintainers prefer force inlining I
can do that.


