Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A87CDE98FCD
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38196B0005; Thu,  9 Apr 2026 02:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8CA6B0088; Thu,  9 Apr 2026 02:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE606B008A; Thu,  9 Apr 2026 02:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A40AE6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:53:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51381B8F5E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:53:39 +0000 (UTC)
X-FDA: 84638101758.06.025B3C4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id D36DF40003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:53:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RElT7W5v;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775717617; a=rsa-sha256;
	cv=none;
	b=XYaD3gOAOxr0DSVnjOz7tQuqROVryuYvtWQ25quoX/GxGJ/CNX9dfnnx8YiMdVIvxfo59w
	UaDSr7zLTQ+rBS9uB1qqH8lSBKxVuJNib870UdJ3UbEGxrKGSV3bxwuGdq5kOJrNDmZR1c
	kdk8wnXSoj/NBugebZGfP5L4okne1s8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RElT7W5v;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775717617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awI3HxktvHX0X5JFb+ssDeojgiSz+qfk8i/fUaGh0ms=;
	b=xHyFt4RX+wA7Eoy8qi08MeDZlBxPOuMx0eL6JJCmosWY+4iyOSY0H4s1gNw9+Kuuf5TosH
	fOuaZ1Oajyvs+v967E8pMEmhkUugK9ifWYEH1zGcGioNotozhSnfo9STMIifyqiqVr3BwK
	qSgGAYndJxggLP8+V5IepgKAhmrC3mg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=awI3HxktvHX0X5JFb+ssDeojgiSz+qfk8i/fUaGh0ms=; b=RElT7W5v/P5dXLnSR2pjDxKJXg
	2mfHJZXMnkMqkFX+l1BRM020vGT82OolnrWBoJdZy8I1vOBe5UmumVFgxUq0afMh/9OyvDToFE6df
	K+HDWKWi6A53qrbB2A/Ot8hpsvkH4UAwNy70GMJslSU3uXNGRze8LyuAvmeLb97UW0IlhXj1jsQu3
	ol7sAnZaRiWvzs6LujLL9L0ONUsVWvsPaOenjOvXjteicORYxlSIjQto3puH2TObnjYEq36KWS6hi
	FLxFxRqwZkt0BRmtfmuGurGuY36YZF+Ej9P4D+dBLf/eMkmWnmK1tHHCeENj8rBJv8y9uRilVhy7U
	zoO/Rb9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAjGb-00000009nGI-1ANh;
	Thu, 09 Apr 2026 06:53:29 +0000
Date: Wed, 8 Apr 2026 23:53:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices
Message-ID: <addM6bkKKtoMvDIG@infradead.org>
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: b1heo19p46oep8ud61ntj9mif9fh6mdr
X-Rspamd-Queue-Id: D36DF40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775717616-253078
X-HE-Meta: U2FsdGVkX1+hCyG3yKxqCWmqCy9AocmfU6AEcwZH0Mx523q7MxXG4zQdpSxvy5wv02digjJctSE2D+bKKxIBgztVS+//jwok6coGFZO3Au803i1Ah/ULCBkiq1IH7uNguteKqofJzbH+y3ruM2/RDCaR/IAeHA+qzY+KbIKK324TqN2s4RqvrLpRc3E7A9PL0ZNCkZy+hCAXm1/wh5YGTKlN+yF6P45GvmgTuYbn21Nu7qZSAZZnh510tk9ZEabg66+1218GhkpsmkqX0rGxd7EWbcD1Z8aZdhfieSyCmmz5Efbarcq88d3BWPifTUU9V+R+Snd1KawX72OfVG+uOMcPBWISjo+19bAneZijxP+WL7BylaDSIscTsyVbNrK0VyWJR+jxgclpCRSjm8zHoZS5JgRY4QjvBm652vaXrxXM5kBBT5U3NyqVbygQuvfodMMKGLmsEdohHC4lvrIacvxk4aBZ7W0BMofZBoZNXUhxxp1R5tIa+YNB0L7pHUT/C1nUHfJEWvWDCYgWueDk3ukNrgTKxu8imtcgDTH2TWSKLA1FIKChV9HRMsRcIu6fsYlU2nMhDvg4dfNur7LUAnf/IgxfbdkQFwPEVSs7tHZMg7X56qrKrx5k7v8a9XnmI3KtVJrsNpbnzTQnjOwj5FtAvNlxfKdW7FfIlxY/xU7p0mI9DnUzh9piTb94OadX8sK8RryibBS/YC74el1VWEFJaASg8PLYnEiQSgE10ncsxWm03pLPFm4714qhzFOimu2BCjoXimirPTHATfee2We9LV55wsFegvk6Pm1D6/vjwgVgd/LDPCaeNb+GWy6hBYMRxT7ai6ys3sC1BUGq1hiG0e0cknq2YsjwO17rHDjK+EmNW1wHJjToRFFrqsGTXzDi2kYuGun9yc1O0Gf4BTVmmyEKNdywwbkXqWZ5qo5u1lEPTP2atRe3pssVyxZYW1C1zZSqs3aVwcb2UBy
 Myhr/6VW
 rnypXWduyHJK0UZpMhWS2UNyN2r41WbR69kPmdxGLs1tvP9mxFJl4Es9EZbkcl1TtcF+fAZanhCTF0GcOM/IMIR19qnq8b7ehsgFw4VeCUcyb3Nlz2It9ueDlrRJtYIlTkP3TXMDCGJGDlInC+NcODHXemjfGfPc9xoNusU0kYyLQ23g2xedbnROdLQCn+v9bJhMfGxq/SgKbm/TqxUZWbDWsvwkJPpX8QylFlqPGykQybQ81Av1Vh7DBR/Bcmik+JQBxs5YkzFD16PbT9StbWuHWCcDSvv+wBJHn4PLoAMfkJaihP0Gyynp7lzDunST+BI6kHr/Ke0ndPjYxRCH0LbGB6TPlLYi22GXibyCz6WyHdRiNtUxrBkjdJ71crXFdO4u0CBqxidD8Mk9n+rNSr8JFt6DTJaYDlyZ2AtwgnlX7PUMsmHQ/3MicJNYKWLofVqFfQ3sgjmar6kQnYL1QakkJPXXax1sN1NDofbRFplTTPZi3Uc0MJ6LtKcOWbu0RC8QZtmfcbBGHRI4Il0vdXbxClfou44CtbIkxgfO6SMg8jRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

What tree is this against?  I tried Jens' for-next and for-7.1/block
trees, linux-next and current mainline and it does not apply to any
of them.

