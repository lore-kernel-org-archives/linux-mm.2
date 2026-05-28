Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB70CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577906B0005; Thu, 28 May 2026 13:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54E9A6B008A; Thu, 28 May 2026 13:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B7A6B008C; Thu, 28 May 2026 13:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3906B6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:59:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 996051408B4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:12 +0000 (UTC)
X-FDA: 84817590144.28.2355F24
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5C61A40008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dxXupcRA;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779991151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eyENAjnk2aJwSde2nbPfN2ywHeMCCavPgJObBpyXFM0=;
	b=MQq6TQcRhquQfThxfqM3IiYAssGtKwEvpm9XJk5Dd3AH+M/kHo0vH9Z4FaXEojbzKRZFjy
	RMW2Jfb97oJ9wT/ebbO7JVTM6eW82qZ/DXsMYcrTM+SAf6iWj1W7SISYdPb5sa2ZrKupIx
	uY1xMLOsDEutehm6KdEKHfoPQASjSAQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dxXupcRA;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779991151; a=rsa-sha256;
	cv=none;
	b=PWLl8uAEOj7NHxBXOJoF+Gi9S+inMuoC8kp+aLhwaWbPPBmYbzgT2/EQPlar/yStFoHL+Z
	MKRr5KLAxyIUw3fTjmFMq0EqOG/5VRXPH88LCCNs7B/tSSoLk+Uf4dzRZfW/OiS2XQKbVd
	F4uhPSmhVb9XXrySqnz7DTO3In32y28=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=eyENAjnk2aJwSde2nbPfN2ywHeMCCavPgJObBpyXFM0=; b=dxXupcRAnbMiSHF/aR4483vLNC
	0XZRti9N6De3tJeOrzt8jgd7qjnPxPSjFzTVOhDyYHLm2cxIT7COBYR2aPF1IsYaZN7+NKXiFeihu
	Tf8W9ic5rc0a/ERE45RycMwCoQE4GPQQPZ8DCZ2wjNXWcmOYHfkw5aExNv1u1oRcD3/kDfZGAvDyl
	U4byuvX7LxJmNd0wiXQm7/0z3NsQ8PiwMdpOT+WjaykS7lHjCToiLxjZECWwMeWOgIJ/y87ITizii
	oD1htBO6tCkjhRPd8KXG8pKDE/4n6XheUE4ACEQX0CvhHL4ri5Xj6LIs0eUIFSfn+7pWIkX9ny4yt
	IOhodNNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSf0d-00000004clZ-21QA;
	Thu, 28 May 2026 17:59:07 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 0/2] Add bvec_folio and its kernel-doc
Date: Thu, 28 May 2026 18:59:02 +0100
Message-ID: <20260528175905.1102280-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C61A40008
X-Stat-Signature: 8pou6o33jtkjgz8b3dwnen9863asfcn7
X-HE-Tag: 1779991150-948720
X-HE-Meta: U2FsdGVkX19iYca3JOQN88g9BTkG5VTzHXL7wBxz5NFXHCMgYe+5Dl2CqqLFZPk0oyDz4VaaAtnY+SGFFxNryGY0b7918YfMmHUZSS+u1G7ug3cD+Xoru9anjhVtmooP8HDUNuUahbdOOPVMig2ISG3v9abbQ5NzAwVZjU3iPB/zD69sGrymZ8Y1gzpW9qhVJL5SD9hQ5y6sPmBvDGfq2t8hp35rIbfoB/JWSItpwaw3QDTwRJrZMiw/PPH0CCKkbsfnbmU5ZoiP2i5xbxQe89dNveGOByxg3O/EjwJQOdNvEVG3OYCTfE3Z4t08h03jXodw2D5INi1avn40BOYkCUAtZ9aZP/8HlP4v9P1DkPcVibIXua7ZfaUlgHCRqA5P/n5IiRYjjc3v04eNVqSmE+esHcw6sgALJKUb7R811m/vG57x2TXciXRcl2EAaz5wNPF3GCDezL7BhzAOuFEONiiRbKpzECEOt1aVgNe3qwzCJ0cb6UL81h9acOJXSpTmx15ewakvIbShCSGB7JUlZ6PYdDc8vZ9vJSOEyL0YJn+7EzmV79jq5w9wfwOe5OHU7AVEKxJIyDhGx5j+F3YKk5b5iAS21xHMX5wFWAXmkvbz2Z7Si52Pcu3AJEuhqrF+ic8waiGUnosqCzTnYl5SUVKFoEnLmYlVo3VAIsGO5lbYP6/lNksV2nONbHXOG7mf9FEq4OrotndoABO97xxk7YCdzu6xYKOeiEVleHS2tRP/KIFgbC/SV4za0byLYY8t714qdtPDVnW1YDSgTj/VCbyfAV2WXZLY3kObMNblhyoDczGq8BdPjMGpALhoJJtxyJdEpoBFZuhr7sJHC0lQp56QDYOV8FGULvyJ0M+W0SYp5L7wegG9Mf4r9yNlwm3uE3wkpfsmF0UoB90bAyJYK656J9woxoDMn2lpeBPy12/s3FQNgtC7ou0Rx2J4F6GICYpnnu2nHT/IQ+hcMqP
 Yaxm9Z1/
 ac/ud/SCOVGvLDiCke4/sU06tXnGgUDYwDUSiKVZH4DsqdqntZCknBgSrjFUcl2Xd1zgtgr5Oi46X3JjqhcNM0CaJpB+7/a2gun033bsa3Z1aySQU0NiLuSBpyorohPc63qjNcOghf1VGyOwoepBGuAEewSm/THgeH9hY39CuVfVaw2npOXb11YgUEY0l0IvJ7AyPf4KO7oywnh4cTsFL65WgrfwE88Yrt0HZRYBW5avI0BlekdFRNa3vilETV3QNXevKI6EqC72DzruGj6x/LcUNT+G7nO/FLPIuYd5TZ0Qxd71lsRpOKSGLhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the convenience helper bvec_folio() to avoid references to bv_page.
Convert a few of the obvious users.

v2:
 - Tweak the kernel-doc (Christoph)
 - Add the bvec kerneldoc to the documentation build

Matthew Wilcox (Oracle) (2):
  block: Add bvec_folio()
  block: Include bvec.h kernel-doc in the htmldocs

 Documentation/core-api/kernel-api.rst |  1 +
 block/bio.c                           |  6 +++---
 include/linux/bio.h                   |  2 +-
 include/linux/bvec.h                  | 17 +++++++++++++++++
 io_uring/rsrc.c                       |  2 +-
 mm/page_io.c                          |  4 ++--
 6 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.47.3


