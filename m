Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF49EC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37186B008A; Wed, 19 Aug 2026 10:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E6E6B008C; Wed, 19 Aug 2026 10:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E272D6B0092; Wed, 19 Aug 2026 10:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C00966B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:39:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58DEE16010F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:39:36 +0000 (UTC)
X-FDA: 85118277552.21.AE1BCDB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 344D916000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:39:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2TYirFOk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787150374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=04HyOFHHNIy+tEMDSCtDuwnA0lHzo8CsHYHPpfp7LqHdcuvyQrvm7ZZRkIvlrMct/HGtYW
	ix3oDuUK6u2VE6cDuhthHJuy2dtCdWekPmCXfi1fTND+TncuS4v2VDbZF31mrf6iuqIDDY
	lfw/lm86W1DCQJ6EewkOH17XjYy4YRw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2TYirFOk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a1be12ea4fa2434960b+8396+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787150374;
	b=RQz2bWEV3Dx+EJ9C956R+2agI2L9uYf27tEKOTi+8vYBhUYLTcch48F+acdQs4mrNFta7p
	ribbiL+15ixiLKQ2RDnakMW3iuXwDrF4K/a4N+2ZkND1CaiPQcEpW8fxWKG4ZFsZg1ZvH0
	vKVbVYvyLyNTS08qwjGFJkP2SAtkJVE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=2TYirFOkCzvSlrZUBMm/DEJ3Q5
	yCtfRoTqXMPfpCY20VycF4bauDCCyXNanpemH5dyOKAxiG74EKrhLmfdOD/yrYuuvkKWdskmWZAmK
	ZLi0wuRQnzNry7moPCcaeGjoqBXpfUhuYxYvqKfFO3GRBPni43vhg1Flh5ETeYGgZn9gAx9+RKGQ9
	JFniURqcxuG2Bf09U+VGy7q9zUobPf12JPb9tEU6uM4f8+AUirrwTPh8ALK57o1+qriqtcb4aVDtS
	OieCX6Ky/KJROd6sG48Hdx/jj8ExcllXzkVJ4hP+y7NjqjdwB0QCmn6DUgAdIAQymL5SHD/Hx58j5
	U3+JP+Sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwhRx-0000000A06F-3ge6;
	Wed, 19 Aug 2026 14:39:29 +0000
Date: Wed, 19 Aug 2026 07:39:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page-writeback: document folio_mark_dirty()
 locking more explicitly
Message-ID: <aoXAIToVFbw9vxLd@infradead.org>
References: <20260810-set-page-dirty-warnings-v2-1-1bd40fadfacd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-set-page-dirty-warnings-v2-1-1bd40fadfacd@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: cugdkggjhxky315g48azu9kf3dqi99hm
X-Rspamd-Queue-Id: 344D916000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787150373-128981
X-HE-Meta: U2FsdGVkX1/vkuinX8ivsFfcax4dlEy+7YIgAQXVCNM44kiMGTHg/bxcBzRJCSR7/BTuQxRzbvd82mOczr468+ryBwq8MtrJX7aRjbS0SxQFUSTW1ILoFDumhf5yrfjM+cwX3wc06wsyBF8OiKdBKDbVlbT58tAoKmw+nLJrtPJUI8hBt0grICMC/TZCKw7G6yjp8PtPdIM1j3lwpIkAvpnn9NeBwz5/vFWVxjzeGpdfLgoAGf0JOA7q3UtF7WnIUqOcd5Kf1HR5s0FoHWP8hxxXcJpeO4LNJXbbvtF/FgNMYN5w2S9vIQYNZMlORfg7kkR3HRGrbtCYSneh4Yr94EdR3ALZ9B5VRfBaSHXh24FG6GzwV2lqpbtdR8lZIn84otjLIDTNEJmiFgNs3co/BpEjMTilPKi2GIZHI6gd12sG3sbASy8ho9b/aAdHZIKTr/0AK5DJJOWtmtAoRtvjoOlUz7Mzak+KK2186OxV9jaf9k0EtnJv95ffXcfvJmRZz2zHpsS7pFkTGwIcOcf4PHB4YL0tfWxMYmbW6txLOMEWFfRU9Y+7LgNXP11AOkMfOtfMN5Ngbl8KnKpPeuNeV2cbNckcd+QjBBKQqxN4YFWFC0rhXSGD8J8MJOFrW+mhl9Stg1leIu4j9b8+rYAOCUYqUPCNpUXiuzbrF7+OultS4a+qK6s0tsRo1GEm5ao6RvjcPWuYMQX1ObOiUshRjf9kEy0IpRWkb4HIS27eYZRMzxQf0KHM6DeXxPN3pEcMYKeUM9M/rHz7K1/ZdwSJPxmd2yxPijGyL3MHK3re8Oy+M9P/LmA3Xck6Rkk+/5R36eIJsYYvUNS+TtxhqSOgOb8XJOuPowJvadovgAFyDWMvoNu4paL7MCSJLLs/OoLgl3ao6SxDdlc6HA2bozlQJc+v4u040psqU1QIezQO7LNdhb7uauFbJuLOA2/SgKgjQ09ObgWtNlRJ/OEHpAt
 Ch0eigD5
 E7++T65FCHYosQe5YOTMhLTaPRrcUi1JJwQG16EjSyogRXbFhFkuCd+YQW4KVAf1YN2wbpdjEgVy+5KpHeF3rSgMsmg6H9nkM5V4ZBYCmNdn/geMutJBn5yUFIVo55Un7oRnmeeYbYfOPwsPk8oa8dD2JuXB9dZKEyAltwz6v9OGu49I0+KydVTXfNCOWpBZephipMfovcgvxbZL8lKjDYwH6PyH13KFKy1DkcG/Un9WG5TtWZR9bYMmTbsXTkgHOILKQzC1GJA/N4hPpjAtvd9wV7vBW5aoddoI/OLHJsJYQrRDsVYc1+3FqVmuq6zo6WmGX6LAU87Qc+83XFDZKICOgMGoEjy4r80LNu6OIoNH3zKA3EWQeQp3Nov26DNYD7AMnehPuXGeebyGLzKPVSclfwDtHucPD4I2ue5cAvirR+/MMb373k0sg0g/PCDftcccMpq0abzgVGz8LmudJnI0OgI3svfrurBxOPK1myaMQaEOxo870Ny8S4KzKoklB8panInuGYhmBEK34iDRmK8qPxFnpNbKV5RWybdwDr5X7chcuM0x0jF55zw5AfDCgz1+THYQTxIJth8glDxAoz+IzC309ZsG0L/ASE+aAKQ43kWt6AfnfO8YPCf8WT+07cnqopOEokh0HUlZqlZMe3xUXRHxQklnAaQRvC8geSyQxb+8G1TDWkCrMHi2FsBDD6T8jS3uDaD7K9ofySNdvmhp/0KDyE0WLeC2SLlizZtsf4yYyh4OPP2e3cuQlLNiOXVF0komT7Mwf7ZEjPjbxyzmUYDtBj8h/ZHGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


