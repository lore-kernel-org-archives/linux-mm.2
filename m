Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C2DCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2668E6B0005; Wed, 17 Jun 2026 09:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217666B0088; Wed, 17 Jun 2026 09:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DDA6B008C; Wed, 17 Jun 2026 09:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC7EA6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:41:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D7CC12042B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:41:08 +0000 (UTC)
X-FDA: 84889515816.29.AADDF24
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id E43622000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:41:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RgBXEC5b;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781703666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hBjq2NlYtroVOLHciz0ZE6O1tPAQl7C3N/Jp7cP9o8=;
	b=KgP8akOfOkIV96wuQJwQ89RuT8S07JYrZRVSSTrM2S6R7C1sHilYJw21ewB6Ijm/zmojbW
	DVmq3mOWCDk3L7a59sTWXWVX7mWQ90/9TSGF5hzJzPT4wQISvAbbzIpbIFhaMZ4i6B8w8v
	KTtrcEeXA+I9H78/Xo/brVky+91lhZA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RgBXEC5b;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781703666;
	b=e+jT+iiV079/SuTirMqPFHwi7B70t7gQwP3p9ihWBXYmONLNtYJM31rJHUhuewE2U9lLD3
	u4b79l+TDIuhID2dV9kppR6XNBaugucHWL69fgO56yw8jAKejTucvJSywljQnsGWHVxQS+
	Xjx+ocnl4efdBNGkrK+voBRwkr1xW6E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5hBjq2NlYtroVOLHciz0ZE6O1tPAQl7C3N/Jp7cP9o8=; b=RgBXEC5b0phsN/6tgDE7vodN6G
	2TQEwUiFseSvUJgej7s3xKJPEPUghoWnqQN8WaSC14U//mzXq6jyMryT7RSfGRkZ/6hFjGtjfue31
	6hG3xTCs6JgBUBjYMTjnvJYKOk4hvAZoFjk1qelUNLiqtHnc7Js7V14kzE2INOA3LPs4aALpCFfxA
	hq4wzxNLAEUg2XTDnDOpeVVmk2dSAS0kuzOckcG++alG7lU91DcPDkOTu++LA1xkVtI8M60vV2AUL
	tFXZNMTIIvf52/3W7TTlkaZHMb/AXCjDaYAUCIyKsliSRa/whP3H2HBUbmsKfb0PrwrUY1DUiKPdT
	JFFzMz6g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZqVr-0000000CiHR-3Ert;
	Wed, 17 Jun 2026 13:41:04 +0000
Date: Wed, 17 Jun 2026 14:41:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Remove mentions of PageWriteback
Message-ID: <ajKj71cXOZMf6mK9@casper.infradead.org>
References: <20260526195650.353196-1-willy@infradead.org>
 <849ad1f8-973f-4742-b56b-7d31570d93fc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <849ad1f8-973f-4742-b56b-7d31570d93fc@kernel.org>
X-Rspamd-Queue-Id: E43622000E
X-Rspam-User: 
X-Stat-Signature: srfsp4j5pxtk8xnhy118bt871dxb9om4
X-Rspamd-Server: rspam09
X-HE-Tag: 1781703665-502535
X-HE-Meta: U2FsdGVkX1/AmZDjRemoLiu0edVjrrhL/1ZsoY0+6CjH3DexG+BH97J4sZshF2fhgL4E+a5sc5C8ExG187aP6aEli421Kq7JhfgFc9VM6eC9LEd0G7a2Rcw+ru6fk2e7rsBPEwwAQG6jAsKhfItEvxZzv3u19yj0cdm67XfnkS5altodIEKR//ljFTt4ypOPzAvt/YvPonocbRquhF8zsdCm3MG8Ubvl7uhZoFLRZbfMnjKQ26r/VIr9H2O9K+Ok/TRadKyYrUlO7heQ7Q0XmseKN/ilqxWRcrcaP9Uh8OyoaGHgDK4ybiXgOicUyn0apx6wdl4WU9iEN59sWrpycoTfUv3S8/4Lo7HC52vEOu+VGMWorT7m8DjDKTEaSIJYB02R+Ii9qfgEuZR/pSzrKXMPHEMsjLBuBdqFTyylBy6GKQO5KObFWWB10eXFrzJnS/PNJBqLVHAP/9lh4rxUUjsr7QmDcU0z9WAIS87wV5wKm2U50lIToBNgHSZM/PEHueG3YnE3c9XX0YKvVOgFgg44/9TODU9pWgPxWflBMv3pFAnvEG9ekLU2DjbTe0Ou1Az/Wgy/Ogzx92w/EqrVNfKwZeSzpNgQKHTDtdQMTJLqD70UPxYUiK2rssMhGT+9MtC0BLxTWs1JYxDTGo+Wk6+4PZIfvZpG9Ljas92iv/EvwLTV8MFGV1+sFJDFVD2TihNQzxHeDUJYLT9RuPiHU0VydExZqie7j2t+nsUvg26/b0ue85CrZFWuvfJ46Ogax21R2DtjWbdJ15nXNoSgNHDuzlO+df4PuC1bt9oXvU3xBbiKfWm7NHT/31y1xP59p8OWBzLw5DhTxM5UrWzLFPzwQcwaUtGjD0Js3odxLDo9MK4alusV7YXbEDW4lbM7WVxHQA6eeKRJTIyDkrzwFPYLlLV+4BLtyW9UXQ7E7WqdipaLwuGJk2f726wsKd5HAHeiwNI+7jm6wXAIObZ
 AQes3gVH
 fr9uwewhFw/HB8TRAXG/vYLAWX6r+lFddG+qtRskZEkGLBuieD192sg5ua2N3AhwHo4kseYUO0Oq7kxUFMFQtGbnjEJL/3/cOebTRxGLcUbfgts62raw5L2qyq0j3pVBt8p361/tXmNRlKvl46xESfqSbYFS2jZZAD/GDzzONHO8BEZs8aPT5Yp+Xib5HIpeeVp9gFyK3ZVAFScHneEgR/qv8w4cw9XoPyIgEILU1pMIXqm+B1M7rbmqB295FaeGMOdt6uGREU4vDgeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 01:15:42PM +0200, David Hildenbrand (Arm) wrote:
> On 5/26/26 21:56, Matthew Wilcox (Oracle) wrote:
> > Update two comments to refer to writeback in general instead of the
> > specific flag.  Convert the large comment in memory.c to be entirely
> > folio-based.
> 
> How could I tempt you into using checkpatch.pl or similar tooling to pick up
> people to CC from MAINTAINERS? :)

Honestly, better tooling.  I don't think checkpatch checks for "have you
cc'd the right people".  I presume you mean get_maintainer.pl, but it's a
pain to copy-and-paste from.  Particularly when it wants me to cc Ted Ts'o
(shell quoting rules are bothersome).

There's git send-email --cc-cmd, but that doesn't work for my workflow
where I generate the patches on machine A then scp them to machine
B where I run git send-email, but don't have a current kernel tree.
git format-patch doesn't have a --cc-cmd option.

So it depends how I'm feeling whether I can be bothered to cc absoluetly
everybody that get_maintainers.pl suggests, or whether I pick and choose.
And for documentation fixes, I often just to: Andrew, cc: linux-mm.

