Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4A7CA600E
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED206B0093; Thu,  8 Oct 2026 05:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FCC6B0095; Thu,  8 Oct 2026 05:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3DE76B0096; Thu,  8 Oct 2026 05:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7362F6B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:41:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED001A7A80
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:33 +0000 (UTC)
X-FDA: 85298966466.25.0D6A440
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id 741F240009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GeqxQN6S;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791452492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=wpwoa+wB+1TwvajASi7GkY/ToWaRcPTLqjGEGZXvFQA=;
	b=S1AChXCNK+gFZAkjMbzHAvB1wW+Zio93zafgPKu71AOCMgwOD6V8T3ewujk+xNUs/7X1SV
	bdz79T/wIfSl6kHj1Kzfg2Y1W92sbz+SxDd8EVi969Hf9Fb5yZWHcm2MYa9UOu8b50/Tj7
	WCWwKGnGjV6cA7jABtJ5uXqHVS3qbCw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791452492;
	b=7/f+siIjx0avArzlJQSPoL4uqzpw+/EuEnQwMa2E4viqy+uF2dS0WCjzflClMkgKn/ZcnH
	5k4h6AuXyjDKbiD7Zz4n3h3ig51RWEvdnCH85A9ZTyusKxqkWV4I1IWxuVkS1ULSCxD3NO
	8ao3LDaV5OYLhTbDMl8miNjMNG7uk2M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GeqxQN6S;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261008094129euoutp0173960db2cd9ebcfae0ded0ea84d886ce~chIwmrPmz2292122921euoutp01K
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261008094129euoutp0173960db2cd9ebcfae0ded0ea84d886ce~chIwmrPmz2292122921euoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791452489;
	bh=wpwoa+wB+1TwvajASi7GkY/ToWaRcPTLqjGEGZXvFQA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=GeqxQN6SOWeUNrNOGAE1eIdyWDpfDU4G+Jvr4ojnBYxzxhbC9WeDBXGWz0xL9lUfv
	 Gdp7nIii9eYC+PhO4vDgFbkW6dEIunDDmuz3+RDTIfbpAyYBDJ3M5DSvlIM2+t6yI2
	 WqogX+XEgjPtj8CyJl0ZzZDFChHp1wYq1A3wC8CE=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261008094129eucas1p2c89032b43a7491f200a703da1a224c2c~chIwZr9Q21840818408eucas1p2W;
	Thu,  8 Oct 2026 09:41:29 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261008094128eusmtip26a612e51616606f5aaeb597377c8f1db~chIv7WNzK0972409724eusmtip2E;
	Thu,  8 Oct 2026 09:41:28 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Wandun <chenwandun1@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
Date: Thu,  8 Oct 2026 11:41:21 +0200
Message-ID: <20261008094125.3197971-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261008094129eucas1p2c89032b43a7491f200a703da1a224c2c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008094129eucas1p2c89032b43a7491f200a703da1a224c2c
X-EPHeader: CA
X-CMS-RootMailID: 20261008094129eucas1p2c89032b43a7491f200a703da1a224c2c
References: <CGME20261008094129eucas1p2c89032b43a7491f200a703da1a224c2c@eucas1p2.samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 741F240009
X-Stat-Signature: rh84yrdqmsrewyuiktqfwmfds8b6c7bg
X-HE-Tag: 1791452491-739862
X-HE-Meta: U2FsdGVkX1+dzRX3Da8A/TyUD7rBtrgkJjuNYahDp1iCiKaib5xIU/3vuI9UsuafEopm/VHSUEXMdy7Bm+z7NXiswtX8X1LT6B5UwLVvKg/PC6luNaoNLu/6G8Z3MnuF4ZIfB7Nj+BG6cKO0irwHA0vrJApHw8cmMoAQflz3Ft1RLifaSdHEGOmNY8axgB4eaikPWa+sQLOLseOvhigU3m/CzvOCsbapwUupoDQZ55l4nJvZ1h55P1f7kFY8zjBpFUCXgtMSw9YgXyEcOmfNO5bNHBBIBvuu/SW0jsdiBMY0Ntx1XWxt7kRoFrgyZRdVC3DwRlSx7zcmZMYMKKlVaFSRDe2FHoCeBYJJ65o7F8Ux8NkAXpQL5/eyNVzk22bQnurMfRCuzL41m0niUKZ26Z/mBKzp9oWGlzBDdeM2rVafZSs+LJ8SZ/DqC1rqFzmodGzM0g8ROrQtP3RuTNnExAWEipY67zmv6fJXoWB3DXo+KUTXYOr307gR8uif8jjVHxJWKwYVKbCOFgI+2lxAuHdY7ZKqlT2rBNX9XULeSgW/4fqhzTQNR0Jdqba0cEyauwnvw5/UxbPSddD0uprniqMYITESA1RBGvht5LzhC4zNZ44bJkBw567jF/s8iP6jsfH81GOyWnMRlvRa1BsijsTb/C5xO04TnvPKflPqYp6BA6+uaT4aMD+wROuSzu5ybM7ICkx5kfxiibriVHOZwVLRWwYa5XeaIqDH+g/os63T+av+wo0L5dLFJHhyxmpaMDLBjBiK0t+x6rqJjADxyao7FifczkHfhiXGwTqf+6DZ/W3/E38SsGYvKyFjkVJUpjCLt/P/1eWokY3jjLNxkMYbe7X5rqdmJPMBkgF/7VoKRncrV7D+HREG7WP0dZB3X83OYsmd/as8rvDwoeQq9xqShsh0iLB8J0KVXDSjtr4AtiVSS06+lvVqG5r556HXEGa57uwyEldviHmu8+h
 K1iRnQKo
 WrFBnC5TFGD6erjAySYp562x5bA/Ym++w6Z4jJhqe7l3wc9TmIJO2cSusUe0qXs4ooDLAEtkmPU389iArvKeWzXH1X0pLNKszs9jaJisB30OpqIuNBZdyWvh/bHReL3UPd9GeOOYJwjLy05I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport suggested [1] how to properly use dynamically allocated
arrays during early boot.

Use this approach for reserved_mem array during early scan of the
reserved regions. Having all the reserved regions in a single array
removes the need of the two pass initialization introduced by commit
8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
regions are processed"), so implement it to make the code simpler,
easier to understand and ready for adding proper error checking.

Tested on ARM32, ARM64 and RiscV64 based boards.

[1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/


Best regards
Marek Szyprowski, PhD
Samsung R&D Institute Poland


Patch summary:

Marek Szyprowski (2):
  of: reserved_mem: group allocation helpers together
  of: reserved_mem: allocate and map the reserved_mem array early

 drivers/of/fdt.c             |   3 -
 drivers/of/of_private.h      |   2 -
 drivers/of/of_reserved_mem.c | 459 +++++++++++++++--------------------
 3 files changed, 199 insertions(+), 265 deletions(-)

-- 
2.43.0


