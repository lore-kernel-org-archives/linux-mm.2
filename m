Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EE8F419BA
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 13:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED6C6B0088; Wed, 15 Apr 2026 09:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C51C6B0089; Wed, 15 Apr 2026 09:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402346B008C; Wed, 15 Apr 2026 09:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32C606B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:49:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C98251A0484
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:49:09 +0000 (UTC)
X-FDA: 84660921618.27.0BD3749
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2DB56A0004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 13:49:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lb0B9D7V;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776260948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/tU1okJVzaxXTViQ/3laOZYd2h/NA0JuaB4Pnl9NHM=;
	b=KN0Z8lTG9dBCMPTekhoRzxpxWKo9Ri+3nHxqnB0Lyc5BeQQFBPIFxK4S1QAATz2Z2W9HhL
	xUR9fXZtGJa3ejSqjMfFnl2ugVtuh9x4djXoTMOpL2XMKQj/AeRgQbDhIE48FzUHdy2YxT
	PqiFwvCl85DO2xpiIm7somQ3JVyFN3E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lb0B9D7V;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776260948; a=rsa-sha256;
	cv=none;
	b=TBHzQpTMPjXXGoU6j4BA3zW90JGcc+Zn/jS3ygK7gris0ju6DhlrJz+d9cVNFV3rm8TjKE
	uyll2EmXBSfUGgYmFi2wjVmeY1oydROqXiIXOF5h4g42je4gH8jPuZm5e6Jy0fKdfhyJhm
	6wtTWDTfMc+KjjEqTvTLO2YueHIbZWE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q/tU1okJVzaxXTViQ/3laOZYd2h/NA0JuaB4Pnl9NHM=; b=lb0B9D7V07a6Yw+bcTZqmmrDFJ
	lXWjdJyO3ZLv61ZMHjRSc82OiBm9pKpvsLdw2RvAp8aIR3JKFhzrdXodD7Hc5ZHbDSJRD+8tAyXxV
	KmGtqHMQGtDhXo+ndb40yI+PwhPTRbxf8RHkAijA4g5RDr3cET0xK1J7zFY9AsBAWR4HLRS3J/b2l
	shixh241cHbr0fYPMWzoN6AiaNSV3jYrtTxFlzXcoF9iMORPH373DvJ3D/zo3g6Me/VgCCZh4Lg/a
	dNSuI0QMIOmNgxM5BpnbmdimzUPW6p8pjCPn8I1V+VZd2P3IiLYtR18gZOKWgLwzaMN7rNFYQdIAz
	7JhpEc7w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD0c5-0000000HW1d-0xZ5;
	Wed, 15 Apr 2026 13:49:05 +0000
Date: Wed, 15 Apr 2026 14:49:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mingyu He <mingyu.he@shopee.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hannes@cmpxchg.org,
	clm@meta.com, linux-kernel@vger.kernel.org, kirill@shutemov.name,
	bfoster@redhat.com, Jens Axboe <axboe@kernel.dk>,
	littleswimmingwhale@gmail.com
Subject: Re: [ISSUE] Read performance regression when using RWF_DONTCACHE
 form 8026e49 "mm/filemap: add read support for RWF_DONTCACHE"
Message-ID: <ad-XUOoN3wj-PnRC@casper.infradead.org>
References: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2DB56A0004
X-Stat-Signature: zwbrdpg5nsfpkem3scpdw49zootm9zjf
X-HE-Tag: 1776260947-65043
X-HE-Meta: U2FsdGVkX1+UNXgwMz2xdbN0x+nas5O4uVS/Bua5cNoqklzGlNiuw154lFlDbnyaYvRZ1S2UUXYsZi2dC8jUIgB36iRr352Y6u24MHcxQbbzAWWevhD2Hu2fPdQE86jxeGEg8V3dLY3Tn1CyZdj2sACglCcPy5YHJBYg/wUVEI24jVPe6cOveiXcXHrDZCCXlGjBa6Ik5agOgNKMWBodlzF9qdsAYgcZL2kDbvii5BslpK7HYZHWmvRXeKyGkyZCKSJR1a7EgxGF7GUXjO2wdsACxYMlV5ekWnZ+MDOVsB6Wht24z3EroZSzUdozilDUxbDLWZChfdfPKW7CdqhgaGSGXC50X80s4/nyekElvb843oY5q4mbUHjPPnmLLkIodlUviRKMHsY/Lr0j8fW7QOY3TnsAOVfMWs/ARgYGeyaSXNajCsoW/m2rsKTg18Jx8N1hP+M05+5e7UPV/IETYzvlvMElnRByT9mLg+0k9fTaqjoWli4br6qpLT0Zy1U3pb87R2pLivRxEPDdhCgykcIsmxr4sh0dUZ/+YJ/9CqqL5pmKTxBZY36VhCel4s7lKkhN2KMPwmzfMYZQSqnLvV/8pdHsnykuES4URJqkEEaOBxF/qBAkB6QScMUcLm5JDqTfH0A3xQ9gtVJzKZZlGF1o6QQr0ZMlG1spawReHrEx0oVweBUUEO+Ii70goTgddg+yrJ/EusZqL78iaG8N2SYFB9l9sGl9cADP0UX87lBDQJcmc0/S1Jp/NYgXzCl2wsyyblmnh1NT+zuRap/Odu0ZvPhWz9TkEm53EFUAl/v4QhOisSTyxZ0GG4V86Dngs2YDxGVmYqfnpdcMZaYvkvp8UGQ0GiGtaIBxipPdjeKNFtDVBXREcHIe48GicAE6yofB2rA+P+iUTdG+tulb7Ipc0srWgVU/skyZa/mwgz7qcNLY0YLphCbg9tvtQgdgfmP3AFAJu/R50606wz3
 CAzEcz6a
 maEjb9a/UnyZOEE/X5t/cTp7vkifRF1qYqBSSuOuaMHaUq7H1kFnsakc9Ji1bdi7EwKIUG7QbgHylmWp2lWZwqUZ5arYau/pugauLui0PLXgk6DG5cGMLRGyww1PrvvMMKcejkNfQSlCLKX68U8pTBIQU42aevcN5Zx0bi9ZHohhRCMiaHsdXumZ6IalqUa59F5mVEMhJDGFEQpysHPw1TNhyN08gjFzUy/6ri+ry+BlX8lODYwu18EUpgAdRZbAFxTUPpVcnXHmj6aANHoEos8gTZWByaqr7VZLDZK01OqIiTfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 03:28:27PM +0800, Mingyu He wrote:
> I found this feature quite useful because in many scenarios, files
> only need to be read once and then discarded. Keeping them in the page
> cache can lead to a drop in read performance during cache reclaim.
> Therefore, I conducted functional tests after the official release of
> v7.0.0. I found that in normal preadv2 read scenarios (write has not
> been tested yet), the read performance actually has a significant
> regression. I would like to discuss whether this is expected, or if my
> usage or application scenario is incorrect.

Your entire premise is wrong.  This is not a magic "make I/O go faster" 
flag.  Comparing it to cached I/O is entirely wrong; your workload
clearly benefits from readahead and you've asked to not do readahead
by specifying RWF_DONTCACHE.

Rather you should compare against O_DIRECT reads.

