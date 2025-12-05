Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94A8D2CE1F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 04:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B516B009B; Thu,  4 Dec 2025 23:35:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503016B00FE; Thu,  4 Dec 2025 23:35:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467C36B0100; Thu,  4 Dec 2025 23:35:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 391EC6B009B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:35:11 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B32A6568CE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:35:10 +0000 (UTC)
X-FDA: 84184152780.21.318B34A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF7E6A0006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:35:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YhV6zJf9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764909309; a=rsa-sha256;
	cv=none;
	b=hUiezkMcbb83C4bNdMS41/6ZAWyBllU7III2Z9c3crV9ateNHs0d8XQjWrjNa4KQA2BwEX
	Wr9av2UsxZbE/mB2HtI9OZw+dzgeFhuC6lHixkvViXF0a15cmacwbHG5CZZ+df/SmNkKSQ
	lXG5rUvon44ZhjqKEK4CDfkepJ7vfes=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YhV6zJf9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764909309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gK01jioExk9QgqqKJWuj0nW12vKsCLoPguQ+woKkLDE=;
	b=m3Wq5m2KM+yIetlmnV8xcxU8Y8KuE1T6g7mV0R6oyX2YPn6syI5uaJGbEcJp6eymBcRWKl
	qHIaGugFespxcYphkF3BZUFP3Gy83VrcDY9UmH4q+rIgNmp/ugTi4/DkLbVvuSYhQ9gg7j
	liHxnMxqzY11O3NV017sa/KIAb7pCto=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gK01jioExk9QgqqKJWuj0nW12vKsCLoPguQ+woKkLDE=; b=YhV6zJf9UwxxQfXPraH5u8Zr0A
	EUtovP42SQHEcoP4rCDrTQezaxtICdjr5GB67zDW09lfUnzCwlSHonY82uU8gauwMyL9rgEYR2nPI
	PuFgp3jL5EsEms8rDPNmLrHAvUaPlu5zMLtf/HtlkvQBF8CMNEJ65isd5j39Tu7y2NRRRdpk8wgcN
	iQfMl4TDDdzzQlz9lnYQTWDPUPiHh0YzCecUv6jMrf6KxAww71ec6+NyO5RRZBrnBNjZsp3qIi93l
	N/pB2x+KGPO2uY3YAZhUWDGiV79M2qPCHgfzKXsuFNMsQE9JcC27gOIJFRTjElLgkRzcHqGboYHGr
	rc6p0MQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRNX5-00000005A2T-0Xng;
	Fri, 05 Dec 2025 04:35:03 +0000
Date: Fri, 5 Dec 2025 04:35:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	Song Liu <songliubraving@fb.com>
Subject: Removal of CONFIG_READ_ONLY_THP_FOR_FS
Message-ID: <aTJg9vOijOGVTnVt@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF7E6A0006
X-Stat-Signature: 9518f18z7yj3z84j6bwa7zefqj3sthd7
X-Rspam-User: 
X-HE-Tag: 1764909307-413754
X-HE-Meta: U2FsdGVkX18Kpfjac7IHaOdqx35WsKIn3fa17O6gJDLf1mgKmyTkrv8yRu3P8I2hyfO9NbsTl6lpRMd407HKloncgak/7IYAxUM8PH4HVATVsrpd155yaoSkh1rrmM6p60D0LBx7J4olZEfkxHclnPY5qDCxSMuv3pf8m+s3enXsaptHnKuXqCf0Cih5RDFzCTNf/wNuHJndPyghSrteE64u4vyOL/BNVAn0hwmcVrWfJ6js4yEV6QeXSAAG4jksckDMO47v7reT6xTNfxsWs4bEcCk6cb8lIk1JF8QeMUaOQsRLt6dDHg9vybQZURAOxbxdoyhrC5bLGPwc0IwzTUshJ4I1H9812fWV6qsgpdSn+oxBgkbFjUi94AuvrbzGlGgitcqCkbkOLjYZ9R+bTVCy4Pj0j1ns6K+8jrZibkDwoJKnI8z8MduQKiaoIGi/lrqbaKuBmnZRsRjPUhG14u/i8LGnDpGfu7ekYzxoWx4QnlseLC3TXI14ldrYBK1NrId2EffY7tVZD/M2InpfgR6GhxdN1amNS7W7KIqGsN+M9/iSPjwwYWZuzsZpTJuC0VqOh/rbfpSV08BLbkq2TLooTVNBxGSqeWQ2tQHW8sN0xKL6IlfMGGxT7JcqeSr4BXf/PoZqHHRyWXZbLkQtmFOg//KDrIA+qdwB8p+M6eq4Q7P+7CXfb4b77dFtupWtXFluiiLWs9v5uYPJDQG6/UnaIl2/iMr+a2leVB6YdoXa9dfhDTbwRMFrV0vZguVGSv7lcHVtO1RNZdZh3aZNlQETu5mN1gzPtqzkbs2n02eEp0+95m4ghE4Wm/I8gm6Ps0HIT3uaiGnOO5hKGajydcOrWgrbiAY1pEwAD4jnug6pF6B/pglmBi5Z5Q+wqlz5k5ccxjAEE1lqmrNYGuf62qBayiEbCn7r+v5eA88TxtAFy4urNNtXBibHEZ9aA1F+SNY3MCX2O2oJp+uSVad
 LaF1j8bv
 8qIM2kKnLdCNn5GCEMyVbX4PG4NRhoSbbzk8Bh4FxGVs061EOKx20PXwFHmUziF1ZlZjHJKpqjFY5MGYvMdTmXPe/eyzvgl6O0VUmLK9MHpD+3d8dIMOhs+r5mtWqfDlnV8wMZY91ppwMOGYHoaRmESGgKwSKJNE/OtJjw283/c4XtCFdGNP1zDMW6LQSNan7/6acnDMrVCQQrZbPGBn4HpkZmmMLdep5fpHA6Dq93grIctbuWPjVT99+52A+7sjJIUOL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a heads-up that CONFIG_READ_ONLY_THP_FOR_FS is going to be removed
during the next merge window.  When it was merged in 2019, it was always
intended as a temporary step towards the more general solution which ended
up being merged as large folios.  It has been a good feature which helped
a lot, both as a way to develop other code which was eeded for large
folios and it provided an immediate solution for improved performance.

Now the majority of filesystems where performance is relevant have been
converted to support large folios (afs, btrfs, erofs, ext4, nfs, smb,
tmpfs, xfs, zonefs) with f2fs in progress.  It's time to get rid of
CONFIG_READ_ONLY_THP_FOR_FS.  It unnecessarily bloats struct inode and
it's now getting in the way of removing the old uniform split behaviour
of split_huge_page_to_list_to_order().

If more work needs to be done to your filesystem to support PMD-sized
folios, this would be a great time to do it ;-)  There's lots of examples
to learn from now; the infrastructure should all be in place, and I'll
be available to help after Plumbers (December 15th).

[note: all relevant filesystem mailing lists are on the bcc so as not to
alarm mailing list managers]

