Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D3ACD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA20A8E0007; Thu, 13 Nov 2025 03:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52538E0016; Thu, 13 Nov 2025 03:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42258E0007; Thu, 13 Nov 2025 03:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6BB8E0016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27FA75BA8F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:29 +0000 (UTC)
X-FDA: 84104939898.20.458F9DB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D5B1180017
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bB++egwp;
	spf=none (imf24.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wv3HCqsjDlROSfh3qFKfMEjvIOFbgb+wEhBDViNDSVU=;
	b=2SOj9+YWFwhGYh/4AIq5k4Fwat73ebuzR/f7j2WXwsjENCCDePMzpUZW5NBFF7KQmJRlVy
	ClC2DDPYKGy+CXVbbIiUIpoNGHMWEAIVxkjwLyYKvZl4zxHfq0Iy7zKSgRG/4UhGPbfPvM
	COEPrEVjvJiK7c1UNyQLrotcOu/Tez4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bB++egwp;
	spf=none (imf24.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023287; a=rsa-sha256;
	cv=none;
	b=koLV9++hnYq546J1y1S0Qkb2PGc4t66EfqS9rUeVmoFLY1aMLQyQUVtOXAeGllBkie2Sf9
	bQnTYw+tGic6ntFPygM6h2CLBuEPhfI/PFF57R7mSUalgq6VZRZE8G4uwCWFDRxY8o2jcF
	QEO65wlNL4v15w3TxnpQnsZO2RreqpY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wv3HCqsjDlROSfh3qFKfMEjvIOFbgb+wEhBDViNDSVU=; b=bB++egwpiRKUKmLxNd2AqHSuSa
	EhVTmmCUdIHmoYKiA43YkRKTS3KYZgrJHmrw8zgSju/rGkhquBjOHv8T0A0Rhx6iui8YKIN8QAoNs
	u+V746V5lpuOURzFaNF7b26L7RJePz5wTO+7XjWnf7RqbCHMeUB8VklSTW+qsiwS8am634jbSdk2w
	nTrXNLUnspdA1h+fUoHNXMKfhbahgZXzZs+HJPY0ivreNBIPGxcZ71PDK6k3fIdsEYyj4fmg0RWOe
	m3GDJl8sUEb9H+GvGVHOdzXATA6ib0uOnnE7/hP+wD76Fg002h3uyFdRelNpoxBGLE9CE4dFMa6MP
	siEnuWOQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJStP-0000000A7Tt-3uUz;
	Thu, 13 Nov 2025 08:41:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] mempool: legitimize the io_schedule_timeout in mempool_alloc_from_pool
Date: Thu, 13 Nov 2025 09:39:49 +0100
Message-ID: <20251113084022.1255121-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D5B1180017
X-Stat-Signature: 5c9k1f44enmum4rd4bguz8xb93ku3byt
X-Rspam-User: 
X-HE-Tag: 1763023287-107422
X-HE-Meta: U2FsdGVkX1/F03KGj/afLbs7Ka3NuEzFyZowjq1ofv0vNTZAFIV5+gt6nb1ijc5OaL97YqrhnQ10xGSLQdRA7XBsBC42sUSlYs5QDUnGFLCyMGHo7Ct2vL7CB4DV2sZKCo5T0hHfYVwaDvxuf+D+1UT6EQXUxEm47wcUjYzZ++3YFXZFsPnvagC8IjD4HpVXCK04LnlD0tNiEPS1rUxizuYguyixf4cxAVaqdO3prE3PptdjipSbV6OBydkke7yb0uPMY1OUQDmvpO0FrBh2SVN8Si7QDumXaF/zheYiwuHmGMzofXgLshgyjQUmP9UVbo3PKzGgEquZpTVMBwVYtAbHXzTEBVpTs3EheuolO7K2kbIpVWMMnl+eeZ0YhJtIFzqjSj44z8msRfVi9ap4cghA0vFojOHpyNLD7xH7t9t6ztPU1b2s5UxScdqaHWzOSITZ74yuK8rRWUJDY9F/1VG9uBqwDbFR8TDWJBOJGJebLEreiWtWw7tIsptt9o7sxtM3lu4NH0TFON6/cFYiRjJr+Mwb1jZiUyV6ad8u26Qss3c+N2wJ/pf+Hmwc6CkTz9QHOAhL+rxNsYUfZxDDEs2FR+VA6S63G04+KQB2nAQ5JyIfAT2KJvTVxN367mdWzxSwo2RZq9QdyZREWW2yQMhhBnsIDx9DuGIpiyvv9beChoaHl0kAxQsW5EaToEKvplocI0YDnGCgcQSfPkfOxh+D1eg9lnOcbNUMl+deZ9qt8MXNMVdlCcdlL7W2aBHfBuIx5nnQYjJsvi6CviFy5haT5tMV5MX2ox7jUPX8pHD65jLRU+7TzuJy9s96Tls6Nlp2c8swLQxTU0W52jbUv0L3y7eM/Sy8+Jr4MFukXKaFGlEDTrXc4oXXa/RlUUUWXMPNlKoos4xY2RUjyF97OiGU4OZ/DNkWg+EuCW0wpdd3521da6UTE8zWP5AF0XBLHUYwaNZMX4mfiBwvLCh
 V33jX9Rv
 X0/1iojszwH816I/ZzlkYb05j2lqZK6XkOxcluuLU4SJs3ovZgXjTvuXCES7Ty7ZbSACklr0N8fZuvatcJ7r2pvrdlVvqMqW4fE3h6W7MR1YXnfYjFXGXId4dUw6V2SOe6F+htxo0SKSJuj7bt2Bcq9qkgZI64VXaEZaU55kFVUZ+TEfBAjSxLPmK8rVaxmgDLP6r6IQq1vUyosYsLlj9W2UiKVKPbSAuU5nFTapG18uu+B9dckYQp5VKz/cfdm39eQUW/oRziuDjcsTbIiwF8mYx8XiDqBDCiv5Pcwk6XZGJiyy4b7RleIpoQ8jTkCT6OlLRUK89e/NMrdFF54YuCEqqn1ZU8MXuQ9QQ1VpPiptzSVpsjSFggxm4V+lMVpyW7G2+uzTzM/x5clpQmnMN3nWvjxe1Ips+TQBq3QZUJTuhzuBP83OV2zc0pZeP9dhkSWEckFm0VL1CGEWdmF6jIUolBw1D+vJ/3RgB4b7okfxoITxNm7Sj7qi/Z+gSCMf5iRSTLNLJsk3LPTxPf93UYNia6h9hxqnj90uhRA9PDgHkmuMpm929DZFNbIeAqc3AFotZOMn+zE5KAyvSzFOpN7U/XdXF8WCKryK/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The timeout here is and old workaround with a Fixme comment.  But
thinking about it, it makes sense to keep it, so reword the comment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 88b9a8476d31..ea2f4f9bcfa1 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -427,10 +427,10 @@ static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
 		spin_unlock_irqrestore(&pool->lock, flags);
 
 		/*
-		 * Wait for someone else to return an element to @pool.
-		 *
-		 * FIXME: this should be io_schedule().  The timeout is there as
-		 * a workaround for some DM problems in 2.6.18.
+		 * Wait for someone else to return an element to @pool, but wake
+		 * up occasionally as memory pressure might have reduced even
+		 * and the normal allocation in alloc_fn could succeed even if
+		 * no element was returned.
 		 */
 		io_schedule_timeout(5 * HZ);
 		finish_wait(&pool->wait, &wait);
-- 
2.47.3


