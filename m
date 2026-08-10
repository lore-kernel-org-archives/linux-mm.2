Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1953FC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA6B6B008C; Mon, 10 Aug 2026 13:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B336B0092; Mon, 10 Aug 2026 13:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1716B0093; Mon, 10 Aug 2026 13:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 384A26B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:36:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B19B3A1D3B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:36:57 +0000 (UTC)
X-FDA: 85086065274.04.CCF6C5D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E0D7A000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:36:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HTMKTmrB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786383415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=td/Ywf2pair9AI/oS1fM5P5312l8ol5DkJBkL1WbGdA=;
	b=IUJAJprhLGQemq21MlEbwrwfmCa30qUsOpNwO1oyZrEAHD0iXLBCQVuOYanGWJAVg/PhHE
	pgmmlqocSG6KiRMuhtBJls4i0BK05qCk0PRafarEK/AzbfvSPRg1XRjPhiCr4l+bXuEAs+
	IdKRotvwcC5Gyl8VOgrCUC8jIwvXjx4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=HTMKTmrB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786383415;
	b=ZpXmykV5mVbKzhX8/xMeA+1ogk5pqtNawNOJq6KXgLgX+mcj3b62jMlYGqjHhvLl75EuVq
	mepTwxxy+riUhtd3BFcFqJnTpYBmZPqIDex4QKpdn2ulyyh9VBmI12vmWou+Sdj1Rehf6I
	H/Q0v1qskwaW+If6JcRnnzVzLo2R2Fk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=td/Ywf2pair9AI/oS1fM5P5312l8ol5DkJBkL1WbGdA=; b=HTMKTmrByhqE4dP2zF++KyGzmR
	dlftD2bzy/cjr1MXcgNkUHD9jhpsGZxGfjVA465yrF67SJ1Q7NCqaL46LGfZFxGg5XX/Ad+vb9S2Q
	Jsp2Erz+pigdYa8djEcQGKNBpYrw7ks955wIgI+jtlqEBIcFY9Gl2Ecl9s1Cm43LzcYwjmqDIQeUO
	yCptljuWi0qLcZ7eDBlSR8/YMHihH5tTCfTC3rV7V+brZFpmW1o5svPQYzZBHukJt+gSuSQ0pUIFL
	bHQcy3TtB0DP9G3BepFuN9Ivl2bFG0UnAD6tI9nhel7zplVKrKJknIvlCxEFYbp7zswNMmjTqL8nF
	lF+ZmZGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtTvh-0000000CXW1-0n5U;
	Mon, 10 Aug 2026 17:36:53 +0000
Date: Mon, 10 Aug 2026 10:36:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: document folio_mark_dirty() locking
 more explicitly
Message-ID: <anoMNezqJ10YgcoN@infradead.org>
References: <20260810-set-page-dirty-warnings-v1-1-53cad4890808@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-set-page-dirty-warnings-v1-1-53cad4890808@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E0D7A000E
X-Stat-Signature: rm5h3trj185mkhi1b3ebhiqi6gwgu4ky
X-Rspam-User: 
X-HE-Tag: 1786383415-986746
X-HE-Meta: U2FsdGVkX191PhYhQ5y/eEcYM3/U6K1mW65pxW8OiEWLYS24VxsGmmSOdVkLwnUjw0YDSj6eY23Qt98gESY3tMeRow3Aj2p9JX6roYP0zBo1LeTI0oOQWZd2tzA1Nr3xG73BO41lIgYbuBhztN1/v1ZHoMDjXzhC8v1yd6/wM1HHBX/4zZXMIngbFrjghievhdVphzqwaqEslB6YOIZP5oym4LA03XJ7Mew30i+IEn3ukFuy2vM/HtBm9VA/NF1dFx8Rasu3rf32a5HCJ4lH3ER1wFO3rIhSCTZ/vCskbORFysmKkjobmzqfMO604/A+nZ7zj9mQHBT/NIq3Xd4TO6n2jijCgiPDrKcKCIvB96DEYIk/fUiQQiPVB89Ka8HBwoQ3saRiH7kasUeZrrPKNrcYjqLvZ3ig8SQ0NwTAbFXVGbgRTQIGvZ0qfd5/LPQe12NVGs59QGIalekX3YK8mB9ErrD+CXuhtZ6ErMYY6mHqX3PJ+bv1Ujj1Mu5W61cs92hb0r9r/s8vkVOnkrGz08oZBSPchzagrqOftz3hpwwfrfoFoVDfEwG0671GvtkYZXVPZqYhczxt4YDHW5SmUTYsNE4r1hTNxojQA3eOQnNzGXyAyInRx5bTRh8YIJGKiV+Mhg9teFUuKNVW7OnIFbnelL/dvYwC1+ZkQhAw/RUN5wYAIRCzX17HPg3A575AdDo4KIrDeH5OYhml+JG3P+X7iBXVSZNyjlzTJhshWOXjiAf6G+HiXM+D/WLFx2Atn+AQlKYrzugzBpg/os5Oh1muh3624Ldy/eaOB0Wjjt7a3vZ4Q+/vqJG7SiQdAMH2Uf8FBrvRb+wx39Ynjm1Da0GcdoNZR+HVkrEVYFbtL9bRjA/NYu5WAKTlsb2kl4sTcKAZTL5j4GO/xbvpZl6fJdPxoB5athQ48NkVTR0PYFgLLCiEmNdHPrq/Ct71XNd1wpYaPDrnqRL1rlfqm+i
 FR3jh06b
 3oYEHUbp4XBWcCaigPpplqQyrxTWa5ZAQMuwfwx+k6+dAtNSHOA7kwG+FwtUo7s20XYLZ/QYNTX17zaxMBmsbTwLU5wjgtwP4j3UjAyK5+fkfLhZH3Kp2QGnPXt3+2GHu9Aq4GVRi06rfe/3GsAnzDOaMAys9JF0B8uidEZVo0P+81KgeJY65LthXnQokiidiVbMtHIVkWP17i9eC65K+iHl0rI7WNZkLP4GREG0RMyTgs45ZG3+cXT3/0DPCR7iqnAGsmVRsZB/U8asK4Cq7nbAYNfXWstqzZCHW3nOizDyCEjJS/YDYMoB3UmWeo0bu5Y0EP8dPiGY8dFKbofB93w1OomPQ1vxUNLsbz6ZkJ9MjeKWa1+daGnkwaM4qxdXs0RXevmKrzVEVJ5nWgzE8BAUJkDor6XYSFrg3rMbEa3RCyVs/vdXqCu2mSCUQ+3EWsmZPTviyNqOLpp1hm8cBBGfGC7cm7zXCziDc0jL6sRRs+CZpXi/w+xxHBIicTGplhLNaxkgOb3F2iJFuWChSEZf/DGabTj+wXpG7PnHb/jZsJaWI0Jr5mmdTup0NglD7t3SXYi4YAL5hing=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 06:02:36PM +0200, Jann Horn wrote:
> I have found two out-of-tree driver bugs in the past where set_page_dirty()
> was used on a page from GUP without appropriate locking, leading to UAF:

More documentation is always good, but out of tree drivers are totally
irrelevant for upstream, so please reword your commit message to be
relevant for the kernel itself and drop these references.


