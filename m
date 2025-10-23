Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F1AECCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA6B8E000B; Thu, 23 Oct 2025 04:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0608E0002; Thu, 23 Oct 2025 04:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDB18E000B; Thu, 23 Oct 2025 04:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBCB8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:09:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3320D5C410
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:40 +0000 (UTC)
X-FDA: 84028654920.11.36AF6EB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9161C80004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kV16myGL;
	spf=none (imf02.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761206978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAMKm+7bDXxhjSF5naz/L3X2AhxzM7SMNuu5TaNOAXc=;
	b=cv4LJpez4XBfWUiIB0cTIOrIe++K3qPcYZWyfCQV6r33OfN2ma66H1Ibb9TWoRSt+iqW6A
	Yxur9JgntNdOc9O7zSTjUIJMfIsUpUsMWE7ijRcYDWcu44P3syV5lLVBbsSwy/I3kSc2cS
	PkpBdgeKKAAh5HAtGY4c86C5NDIY9Uo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761206978; a=rsa-sha256;
	cv=none;
	b=euau9AOjbUPO/Rs/Ovux65ojFCIoHE1vrnlRbbAqKQ3pBP+MGr65bv5qW7YCK5xz/38qyZ
	Tx6bds8t61Iky8VCfbBXSw31O4Aj52ME/edb8hAmIqcPizc1/mbCUE8srw/DcnokdPMwmi
	C3m0G3jOmaNcpLyyWLfSbAFc36/O77w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kV16myGL;
	spf=none (imf02.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aAMKm+7bDXxhjSF5naz/L3X2AhxzM7SMNuu5TaNOAXc=; b=kV16myGLCrGCuAwJ0iylxpdMe3
	awstSqDvkibiB4VkiwoH+rothfdpso3zRLR8yfzC+jY+AXAWuqHh4hGHcGaKBF95s8KPbrogFEiGY
	tfvlBXO9iMxGOpZMwnSZc2gotBRnP+jb2tVrrrHezqUX3fl8LVDCdhziXQsfPYOQx/WWdN07bP9Ve
	tMmElJ2YFclax0NjZyAc51m9GIUBkXKvEmPmIhioD3TMDN6IW/Wag9a6AsBTOBuc4Ufl6RvmkL6FB
	ISLDDqsbHJv4QQF8z0sCHxFQrLP+vzu/xwo/GwdCTmt4HibXN7cRZxAJglaGD4bDVPu+4emhazRYN
	czU4Jj1A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBqO6-00000005Tns-0eWC;
	Thu, 23 Oct 2025 08:09:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] block: blocking mempool_alloc doesn't fail
Date: Thu, 23 Oct 2025 10:08:55 +0200
Message-ID: <20251023080919.9209-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023080919.9209-1-hch@lst.de>
References: <20251023080919.9209-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: 4x1hw7cpgnybdnpeqr6748zy5dnumm31
X-Rspam-User: 
X-Rspamd-Queue-Id: 9161C80004
X-HE-Tag: 1761206978-312155
X-HE-Meta: U2FsdGVkX1+pC7QC9EOMP2/bVkFhgnIEAx+sgv74jmGS07S9xJGUf0wmim9U4hj64RHTxI2lEdcS/DWRWI58oTJ+XPYucArkNjHAtwDI4FdrkCvmrP5O9/39dqclHXP0+DoZbL/yzYcWD9mijBwLSZpREUHpyeFn8XEgG6Gi74nWwGVtB7BvK483vbQqzdf+58pjvyDrverO/jVPo94TKPxHh4d1+Hz6whowAwzXnY1vJcOKRP3usyY1b/WCftuT93CQpjsoHbjFRrlyOFMvFp01XocQqxy+AOaMCaDb2uNTOjpDguBZNYW7r1AYLJ5rUmOGI5//NfWVi8jQm+E9DiEbmuDU6G6B4uFoKc3vif7SnGG4iSYwiI1iAXw5rmB2+h56NhV4ZfzLcQMJD7CZf+tPOTX1eGlJ7PcsB7lzYsdXlcF6RmjtnRV4FkU2Nzk/+tB2vt9H+DfuUWCwfjou3ZgH7s6iOE2dLL+ykfvyRNkwJHN6lZPRw7iXmbyCcMTdkBZgWsM6cBoHqNCOdLre7PYwb8YPZUjobzOmEa4rBSn+8d9X0QmSk6DW4Y1olnu3TRlY298fqkQFxWQM6zW89qVgo22l2uyMWMD7607lnP92LunaoUEHEvN6lDW6BO2TXrAKC56FrWf5dydg75v/K+h6wX6xVjYSQcEmSpDrfpO7NLRJFG1dyEnBhWePDqXmbDFq/uqIoygDWZE/t4yBu1rFt4DJC4Sz5NlRB+uTeZQZgxjJMBmRKOZyXczLtweEg462AzZtFDv9olPxO7GE7cWAC7L6GZkOKiGu9Ut0YchIcHhc1Syos7zXu+eFXsWqqBzQgcUDHQpUlIZCZWzAr74A1/mSDi/QBkCjOad3Qj5X+Dgt8u4ktet+q32RkN0TrI6YuqJOao+w5V3Mm/+v/2CzjcY2H2gIwPB/Ew5mDdB3ARKM2hFveKgS2x1Y3xqGBb4OROBGzOw7jnBl/aH
 QG6hOksQ
 JyW+t5uWl+OnOpNakwhgu9hoM+0RUxLNmHCAGIvnvnMMU4PFWKKzrLdm8kTQYVCOQIGsDxyMckm0dRo8Hg8b0Gr+UyMV8CfzR2sVauZoNSKYs9AB/HNC/sQkAoeeO13mBgow3s6xuuzymx3GffgFwNMsHbdsgfLml6aBoACowXJp8Jgf9qOp8msSCHAjxbXnqGclj/UShynhoyoVWVBG732EAeAsYqgIIcp2gHZcE/Dp5IQrB0bnjldA3tR3RkoUJBk/CzjzdQQFgxtuPkJK7uNmOc4ytuMUqYuiCP8lharx9dLaNzhncTeqCa9pL1tQeXvBXHL5NB6GUET8cMTaaRGwNbiK27czxdcIBLYo8Awkp8GQK84LBHdKmZG5i6YxVyNjR3KWbLkYUTSfDlceNNZOs7tmxfx0Dq7POwNZMdrjdjsq83lF0UtJmZmZr+eYrDq/V/CAwZy6aWgkH6zihcjMvGekaXvpm+oE7CmEulweLJBQ2PjhaClGbg9ZUvF+wE7A8dvJE3CExwNufqUPHEj7y3d74Lym1H7niJoSzvLECeS6spvywr0oNNWnbwLwQ2zVjf0I8tGl9qgchouap8uFsTAli0xG7khmK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So remove the error check for it in bio_integrity_prep.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-auto.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 687952f63bbb..2f4a244749ac 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -158,8 +158,6 @@ bool bio_integrity_prep(struct bio *bio)
 	if (!buf)
 		goto err_end_io;
 	bid = mempool_alloc(&bid_pool, GFP_NOIO);
-	if (!bid)
-		goto err_free_buf;
 	bio_integrity_init(bio, &bid->bip, &bid->bvec, 1);
 
 	bid->bio = bio;
@@ -187,8 +185,6 @@ bool bio_integrity_prep(struct bio *bio)
 		bid->saved_bio_iter = bio->bi_iter;
 	return true;
 
-err_free_buf:
-	kfree(buf);
 err_end_io:
 	bio->bi_status = BLK_STS_RESOURCE;
 	bio_endio(bio);
-- 
2.47.3


