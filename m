Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDA5BC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F01B6B007B; Tue, 28 Jul 2026 00:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0C46B0088; Tue, 28 Jul 2026 00:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8156B008A; Tue, 28 Jul 2026 00:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 462506B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:10:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3038180275
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:10:52 +0000 (UTC)
X-FDA: 85036859544.17.B6B373A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 751CA100006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:10:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k6YB7qml;
	spf=none (imf14.hostedemail.com: domain of BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Td1vC0tbHFijfIC/tIoxinpG9AEVL47fpXhtFq4dESg=;
	b=3avZ+m1fWhir5W3jW2mMXOc43tHIBfBwPJ9jHtab9bYXWJCYOjWJKPtUKHHrC+ESTLa39g
	P2djfvmBzD+kTsQWcj2tS5dDrpHFmTxnsL9hyoclIgeT9zcVAYdb7CBOFVwr0BhhVe1qRU
	Dh5cwJyG/SFx/uoA8wd8MRAm3bPK47A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211850;
	b=luHytqsu43f1+5p92ayTpTyQQja7h7mChLvqbPwE+6I9DjOyd84A4hCdB4+Lbmpq7WX3g0
	1Of8ohyK3y3sffkjnVthgwojvEUvFVTtMQDd2eA96Cel3w4unncavIUA9YGJN1kIknelbR
	rgbRX2Qgy+sjBpMJXars91N7CAXl28Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=k6YB7qml;
	spf=none (imf14.hostedemail.com: domain of BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+695790e2dd2d1c4e9532+8374+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Td1vC0tbHFijfIC/tIoxinpG9AEVL47fpXhtFq4dESg=; b=k6YB7qmlMdueiRDklF60uxMx7R
	iYmCdKpjv7aBKd2uSTtPEPvzdVmgw5PyYWv71UZ+yZsayPAhu1tkf7iGwuvzV9EScn6VYRQt1NRBx
	cAvsx9qrqqlfc3I/8t3cAnMH4I3jQVjnZrkQUontuRxHcFx9Xp39bcQbCPhoKx1hrwn9s3apFuh80
	+aiPFUCuCWaJdy3r2pSWrsNqLerpBezTOlvjA116cNB2fz2nIKYkgz15axexTOv7J7e7a7v0G/jjv
	hNgsaAupIIFurp6o6GOwalIQ7zMOz3xHZxq6qpJgQ1/VRdg1xHXvPGevGzzIhBvdzmBLfUAkOyiPv
	sS2o1Drw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woZ9O-00000004Mtr-0p5b;
	Tue, 28 Jul 2026 04:10:42 +0000
Date: Mon, 27 Jul 2026 21:10:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <amgrwn0yQoFvJP4u@infradead.org>
References: <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
 <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
 <4jtsjd2sbsn2w7fzfwb7wwowz72r4kc6345ckkkcjoxjbbwjwn@rkl44x3o3sgy>
 <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc58a101-6d09-4e42-b99d-673271934c29@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 751CA100006
X-Stat-Signature: xowxfp4pxuqkerb75er31qsenxgxo6m7
X-Rspam-User: 
X-HE-Tag: 1785211849-90963
X-HE-Meta: U2FsdGVkX1/KA1fXXI6usbrbQDPmiwg9fUkuJEbpOl9qTR/iNE8pSK5Zm82HMjITpMwhmZnylFYDAU8Yt+7EBRRIOrknZGFKPG85wzj1kZZA0c8ezDSs/jaAu00OCP8PmLKz8qebkGabu3BacazwQu9RhvvFvMQS5KPzq+/SPLMyf4NVfkeoYT+zR+WfRWUsraKy7kwn6ujFzk0LWDe0DeFF0aYlgQK810dBx1rvxXInXGtWBZnBOf8FioOE+elaaILHoWo8xKO9mqMKfgz1GzYcenMEiHxW5VZtlJw4z3zld64/VzZVvpNQBosmaW73MUaMt6WP78pkS/R8ep5xd+3WNj9qBFPzKf6zv9iPMxzebcDmAe5vqH1kzh+S0G2bFgZvgdgClWsM+fLABdJy32qDHwQzUvMULpjd/b4w+ScBUAHV6vxa2V5OwAXH88z8x3Qp//WyA8gGATGfcYsYZ8TvdEbPKk9/jtekh3uEPt5ACizJEAccMUxvtaKLbp88+5qQtC+CrfKXjqLNzDC2NLXZ+/DI3uv2viFlLZmeZR9MAVKzNgsGEEs4CqCrC3qMKRHvm/4+V0L1PEyrsitW/p3kw/5NnNQ7n/jpEm2zmjAl5CVCTiL5wvzC3wMmhY2UAfMAJK4AGvxi4ixnwKqHSkEIbn+T6lP8P0GZ1NP59VwafAAk0E4YRMaY/2h3t4o8VV9Lg6nGHIuqCG6DnRGy2j0KK0bKWcgjMHOr5C/6p7Sw7OuOKU0JVdxBAaZZw4hIkA33YjgK/Cob5o2DQNHc6iD6Q1aiPBpTxYtZJbKziF3iuvInd4Jql77BHCBlj/dC7dBvA/4gGhdHnvJX/M695HZL3rOuClxX6tdQybZIiyvzaqYhD7IsQEvyvEa/ZBnpShVgnoV5kQctAgdpuLwMH3yD/Xhpjm6e0nakwYQT1WZje6izpnbdGkQAcm58UhKJ5C7qc7WhFmzbhsP2H0T
 Hsup2bCG
 hJGfG5UqsvAo9Ot91emGgxxlQM5NnTiygE70v4aHmFMLi7fKog6POYkiT2RwSRvc5dVRNl1mjpySPGX2KSDYwXWyM89/Lb+fACDOiBjZpBnKYvvZZA4Ydz4R0m/kAYtcoyb/dLI9R3ACeg2F68CfkyIHJ8NE4txwZeNIG7ImRtQK3dYE/TXLA0lmh4QOVBkd4JqvuqT01GJaRyrLdIoJINHSaJqw2SD4Q42JKvPiYXFXEwESykpzwkkGMa1WqIcgxlaon+fM0JBEFoYsoGg+04C6V0kOr7oh+4ZsjKK8cTFemFFVPfPytXmQOyK4bLzf/XKAzfvg+3r3XA8r4BkyEoF+mGaMhIsx8gFMro7oVFXjXVFLR1LdB9I3yTChptqgWNqc1E9t+BU6pcVsqZevmRrye4+ihhs/BE49+gz74OYWFPLOqvTG/89tfC3oCB69zK+iKXVzWysRDuoLN+7BkOVtqoU9sBfw2D4sSgN4sxBfa2nrZtMQ7NZHF/Dh+rymOqAK7SrsdRcgKIzU5ocpISQ7X11HI3HpkV8F39fb4viwnD107ZTlf+6Ad/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 12:45:25PM -0400, Tal Zussman wrote:
> > 
> > Any progress here? The patchset looks really promising so I'd love to have
> > it completed :)
> > 
> Sorry for the delay - got caught up with some other work and had to set this
> aside for a couple weeks, but haven't forgotten about this. Planning to pick
> it back up some time this week.

Sorry for another ping, but we have a lot of code waiting on this
kind of infrastructure now, it would be great to get a version in.


