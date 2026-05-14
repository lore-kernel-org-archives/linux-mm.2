Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDD4CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 16:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2EE6B0005; Thu, 14 May 2026 12:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73CB6B0088; Thu, 14 May 2026 12:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989B76B008A; Thu, 14 May 2026 12:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0666B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:16:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AFD8A05C8
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:16:19 +0000 (UTC)
X-FDA: 84766527678.17.D5E4CB4
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by imf29.hostedemail.com (Postfix) with ESMTP id ED2C0120008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:16:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=I1DFGUpg;
	spf=pass (imf29.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778775377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPZytYVcITmzGo0US1ov+HlfGbo1AmCL7iCHd1B5f9M=;
	b=RAJ5FvYhj5XoLUIqfwFCQz5WK1M2VzfzI/iShccFj/kIaqqhrukwXWPXgs0Atw+2EXWw48
	NsRdtZcaPn47sjXcbKsqHVxOPaHF1tjVlhPyWXURrO9jnucIs0uNMQJm+KOKI/hxdElxW5
	kCcv/57LFT2CABkmFzexgccN4u6kJwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778775377; a=rsa-sha256;
	cv=none;
	b=daOaUKxFniGBsXLNOlmz6NdXSchzytcpSSpCRP2cZHIecSg/2Roezf8Y7mLi6HtfdC9uyZ
	8HGDWTWwAg1tA3mKDGvoOs4zIaA/lOamg42/GMa9CuMWdM+tB9+jw+/aLSJ8go8oismD0e
	9xftKskxL1Kf83hRxPyWO4J+ArWO5HM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=I1DFGUpg;
	spf=pass (imf29.hostedemail.com: domain of niecheng1@uniontech.com designates 54.206.16.166 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778775353;
	bh=vPZytYVcITmzGo0US1ov+HlfGbo1AmCL7iCHd1B5f9M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=I1DFGUpguoC/ELgW9YTjAucqIJ2l8m4mGLTA7ZwamWBgWaI5bf5gyPEJScG4Y9JL6
	 emCayLrB31yvcjMGm9censcdCWa/gdUhBUSF8ix8Uyffm3v39eCTcdv6HqYeaOQ1VH
	 rjMq4L3u5j4s6qDgyUOZ4QILxYbwGeqbAU1Vrwbk=
X-QQ-mid: esmtpsz17t1778775343t6ca3eb4f
X-QQ-Originating-IP: vrWW6BuSRxD9TSZH8skV7QWrQbN1BOvy3B87NDGtOOY=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 15 May 2026 00:15:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15235211266130383440
EX-QQ-RecipientCnt: 7
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com,
	kernel@uniontech.com
Subject: Re: [PATCH] mm/damon/core: recalculate intervals tuning deadline on attrs update
Date: Fri, 15 May 2026 00:15:11 +0800
Message-ID: <B5D4AFF20A1D18D9+20260514161511.3391771-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260514144102.120203-1-sj@kernel.org>
References: <7946CE4E0773AEF7+20260514074846.3258908-1-niecheng1@uniontech.com> <20260514144102.120203-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OJP+M+4ND1xCNlU6XS5SFqp7/1oRyKDql50I3o6oIcT/itS6sOQhmsG/
	FYyAvK+MBVAc5wn3iUBmIVn0epHl5Ot+S5WA2lle5oSCyKTjLjRU3GMwAs8UiGyrJ2UOzcA
	iQfl+rpi0V4SPQbKLFHy4ZUhm8a0AxvR7FH8rNKziDj37kDOTviG3nRxW8oPCCCM9QC8p6Z
	ka+WecUHJjU9WPzMjMLdbSohVLAjCKRI4X+Q1sLi1noT6UEOHxS8Taues9C00xWO1xuQ6+j
	Xns6D/QlWMhOTgniOJC7llBckbrkKzSeWty/ZIy2I2iwgNvlLqf+ojgrrh07++yDe/hlwrS
	v/O7PAwPLPj82jykYkdp3klrHOWcrMDdO7jgilaU+laEEW9Vj0Bz3A5oFl9aSNcNrfe8aQ8
	veF1+kU7vw5xOPNimd3Ge4jOSjAW9tqXNrNQ6YvWKH/KcKmMSnLAt3HhwCZBSVuMMtXS5V5
	lM3NZZjXvMzmynSnXXTqR8eK/UosDF0ZijnDWg9T3/bSZc2UZPaV8MWJ75yFdDmGRX830AB
	LwHS6pduocBm/24sWTkhW4zXIT+FD6pkxeq9jiOwIqy8gtUo1m0ybAYRnIJ++6K/bV2SbGP
	BvqqpgyeEImksKqjS/hFavfso+Vu31hDDsB7fUQvwjYiovsdZIdz3YO+USBm2+WGfD++Wfr
	GFnPH8g6u7Mx+jo4HHpxb31Vd26JDGRsIPnWDMq8tf9RNncyYLOYYzTOIiUrK783a+OY14z
	Jh2k9NApKi2h3GC0Ox5gdnzFuzqH4N6KBrIvmpi1uCX9YZHVC+uDFLSHeKgMve3OCLhjq9b
	7DN44s8fVI3su2ca2VdL8hgMoxkMy64oVzfVLqXikaNvzp1qY8xDXZ/d7/X5ddgeSkmdQ1u
	cIbnCbDL1MHBOfcWmlxjhWoBf8tNu5Q6i0bsS4AliGaCFzB9Yz+2g7un75Wc7mlsv8r1Zrh
	g/uKiPupPFt7pfeSKST4mqwSCknSXbK6LMWVaU+j2ibQcZ4oN6OKKLQ90CoZzTlVvPIo=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ED2C0120008
X-Rspam-User: 
X-Stat-Signature: df3nxhmef9sqrede64egetnhc95wo4et
X-HE-Tag: 1778775375-591658
X-HE-Meta: U2FsdGVkX19RiJs+nDN1IxS8i9GUYXEeaTyddRRFOZcu9hMWLbEAGGcoX95m8MI2M6guypQ9zz1If7I4TPkh5UVFLmcO7THTOYLl0dD7cZMIN1FOCRjcl9oVQa1nV4GZpT1u6p9yEBqD8M4MkTU+0WM86MatvVPiObA06Hf29grf+p2K3HWBfwLbmpXkSbS/Bc8IqIONCw08uXO1aZyNMXZvJiBUl++dpRaYceywLQPBCuPKwJB1WGoEkRyKaCuJvqMwqsLZ3VCIvEzuVFqcvWwRaqxwFgvHptt4+HUO1DqufO1/Ci2qLYR9sRnajg5JkzE7cEUVlUPSQw87MGIRnf3+QHXxK1bslGVz51AQiIVThmHY1B5jQD2KDZ8uphmrqNtBECwNfl72thNe2G/jkB2mggLUUIRf0JAsaz5zafr5w1g1in2TGc0yO36XTITXdxgAv2nEJHLP0lnY2IMc5Cw1E3MIJCuN9H3Qk0Q6Km7cUyo5dlApRO1iJN13EOOl81N5mJar4eIRLJVzmjAinog/SxOz0wHMImgASwoRBaB3a0tKzaBOCVdDkKJN6DY91I1DoXUfRTWoVtb0I51A8aJMAZnjfMqfcjxh+3gbs5A/tsdpPevnaJLyLDZZFdvOAU84yTnaDObD38wtz74t+yBRYtGGXDOwR8ZhdWba3ygrL8QIh/rP8nWR9GFYxKOUHJYXTv7IY4U+qAqsk1glU+H7HZSeDySGho+wytBlkTc5va0azNMZdkmsZFQ/Tj0hiuLhgeTWNthAWYdywwRV1oF8klQERn9raf9DE4XJFmcvilVD4LXO81fPZPFwcUDssYedfrqmEtz2uIt6sAf4wfxEDWwjKqq/elPlOO5j+c/KIjXBd0DuA7j4zoNsPfL3vRF4MW+6WLJFJX6bi2xrtlzl1ZBW5qzCH8r0/OJf9wyGxjnaaUsEsOErn7bPEycTEd5CXZW7n+IcI3FQD/h
 bsa7qACZ
 defENwqEkxVnsdIbz2n6M8XXSPENtvJ5MqzYYx6f2uel3rKW/wNUb2x8D8P7iTe/FfP1AOR4Km/UDOvC1XnbUOJ5K17snHC2LtR3oP9NoqS+zI4/H1HiauVFy9m7KmMzA91K5Ezzun70eOMjpXaBq7oiMJmoQmSY1WxR+FM1T6Xnad41DU8KQPW2Hup2o9cz9FnYAiE5yy1zK9/oEJBD5dQWqLK47+A+6IdgG7IXvtg7CJnbTxZtK/iFhYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

You are right.

I rechecked kdamond_fn(), and what I observed is a one-shot earlier
intervals tuning after the online update, rather than a persistent
stale-deadline bug.

So I will drop my previous patch and send a small follow-up comment
patch for this subtle behavior.

Thanks,
Niecheng

