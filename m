Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA24C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 04:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED8B6B0088; Mon, 14 Sep 2026 00:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA06A6B008C; Mon, 14 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6CD6B0092; Mon, 14 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82D7D6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:18:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF3DF408CA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:18:40 +0000 (UTC)
X-FDA: 85211061600.06.F45E82C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5ABC6140002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:18:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lfJqfYVL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789359519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0QS+yRZerwS7r9ZIT395XGB5TnODXn+M6COboka6d4=;
	b=ChiDPzXOvpTiTH9mUhk7PB3muploUHvB40pgTagtZnY2f8lx2/z/v1nk5TNvUV4IL4NRJX
	+Iz3zvA8S8kOdRKS2+YAEH43Bxih20kRY3CWitbeD29nzFJKDO0hOSzdEvMcsJZdeJTb7W
	2VasObQpMxkd5c9JP/YK9q+YGnG0V88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789359519;
	b=UXW5m7Ls8iFYphgyoZZKoIGnxVF78t5MaKL0oWKheh/+dpoF9nth/fqXYqXJbL/1GRD6SH
	HrBM1sBF6HR6tg6twcXa1y93EMfNgmQr2vyn9lAT9DZW8WD0fN1GUMXcdotyZpbKi/q6xz
	rqE6R9oqolS+QK2ukHJxf9apAJW40zQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lfJqfYVL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=w0QS+yRZerwS7r9ZIT395XGB5TnODXn+M6COboka6d4=; b=lfJqfYVLFkWoSh58tWNEgYZIqq
	8rxttqf5ZrcVCZ27NcR3Wxir1GQoSuAfmjin4m9PShwqeELFxRYmi6L5V60xShOfHLRy9X2DEgu7r
	JO7o1JB9b+1TlelvxXOOoE4Y6EqwTQ491IajOmpVc1ki42H96H0F2vt+YPtUZwLdPcL/fDQHOfCH/
	4+ggBPJrAdfQsklSfuAonJ3Qnge89yGsK9TKmVwi+hOfmMXSgXbkgc0qVNUtH+xG6JmxIdsuWhjSA
	l2If62jmvafz8G/IUhehE49wq8xdYmI/qyaLr8o5QbPhVTqm78WXkIEfKIYMS2LX9TIfxL99MkP8L
	JICnt6ug==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5y9K-00000008hGE-1YlF;
	Mon, 14 Sep 2026 04:18:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-raid@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] md: Use folio_alloc_buffers()
Date: Mon, 14 Sep 2026 05:18:08 +0100
Message-ID: <20260914041830.2072626-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5ABC6140002
X-Stat-Signature: mzc1brmymwn665p9ghh6fq9sfdknmim3
X-HE-Tag: 1789359518-152823
X-HE-Meta: U2FsdGVkX18bgg+NOxQA+p5xkE66qzihfNjByLL59kxnPMFypxVaM3pKs95IRSw+bh1J97ORCd9rgC1osxXlAPigKJHmhu87RTz1+5Bc4bGqGu1hQ8ZtiycoYr+n+0Mq5pWX/KDJPiGbm1x2WOYTjei8LrIDrPuM9x/VXRj5AYOpG8Usw+zltRKhlrtH/D6Fm40SyMf4uYJE9c84+NjKzOvlsbynoOvZ8fj0e0xpIhivsyv6ID4sGMBe6DpPxO1OPfeL/LXD490Mi/weEoPnJpsxjnZ6K0EiDOac7Yz72ryHnqUQl2aeTdkobq2ZY6LatVYRF4mAZhjvz4+o60u5I8qbn7c3WlIoqlRdDEf/mgaKZBerAcSMLCGWjHdgyHb81b/wCiq882DDP2+0Y/nfrR5b9TlIjbz9akjJgpjn4A9bH+FExLK3N3XS+dJTrRjHF0QqeMY9t3SKstS6HaD5DueTdvYO/3gXJjGuSpeTMoo19qef7f9vvbT7Pq9NBO3AIvl2/VMzaq21dPfFGwWYKi2madqPkfR21ikpll10yBbvyMYqlYdQtpr0byOiJE/vCTGpbPLQpOHlWp8E+fn7kaVRiVlarr97PXNLMUeFiDoUEvdDdd711HBo4ymHw7aSHIJg2FV5OLqMj9Ik4E8K8fENa6PJykLAuAxxs/YPfxXsTGhj/+j0MzjFnO4Ex2dzM+m7g9InpoMELInBOfQ8WQs2nHHCN/E/TU1X73Jhn2t8R36PCF6YA+mEaOOn0HkT5lVhlGRb9luCq2A/P/tWf/MqSaC1MdatcIbFKTIV/78aiV0WnIMxRx685aUVUJoBHjL0e5gAsljRBpBgExOMuZaYI81cdie3ghKornHyBJQMRMPXP0PIKMaZPWe3yd6cj3yCyM94764rq3n0na0vqXnm1Gxsl8/93CQyij6JbJpsKBqHYoNIJuheG7RlXPRVwZ+n22aH79SIL8DNB2J
 o/3jTSCo
 HLFSvXQTNNl20Hemc0U3EJ+THT+IkLUCRYMDa/J+AjWRAvXHSHuA3WOgwjmAPRDaMOfE2k1UBYcFDu7SxzZrW6LPfF/oC81hnmXqjj0MAJlW/Q4+swWi6F+N7X4t8Zz3bHCj0eyvt/wVjiLr7VLlgkHWR7EOX/fq8vJTSqtEqZPyyRWKkC6kfdXYC3W2IU8u2zeBpkgUCLl7O6CmkSaVSEOMe1/ACLAbWjy/KA+t/Tc8kzYrErEVRXo0LxwVcxgUgnzcZJhgAQT13ShCcZt7/9kZAJmQVXBpyoCgVAPwYnlCE4mI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the last user of alloc_page_buffers().  This isn't _great_,
but prevents new callers of alloc_page_buffers() existing.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/md-bitmap.c      | 5 +++--
 fs/buffer.c                 | 8 --------
 include/linux/buffer_head.h | 1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a37..5f1637f974c1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -560,6 +560,7 @@ static int read_file_page(struct file *file, unsigned long index,
 {
 	int ret = 0;
 	struct inode *inode = file_inode(file);
+	struct folio *folio = page_folio(page);
 	struct buffer_head *bh;
 	sector_t block, blk_cur;
 	unsigned long blocksize = i_blocksize(inode);
@@ -567,12 +568,12 @@ static int read_file_page(struct file *file, unsigned long index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, blocksize);
+	bh = folio_alloc_buffers(folio, blocksize, GFP_NOFS | __GFP_ACCOUNT);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_private(page, bh);
+	folio_attach_private(folio, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
diff --git a/fs/buffer.c b/fs/buffer.c
index c9342aeb8cdf..367be053d07b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -781,14 +781,6 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 }
 EXPORT_SYMBOL_GPL(folio_alloc_buffers);
 
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size)
-{
-	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
-
-	return folio_alloc_buffers(page_folio(page), size, gfp);
-}
-EXPORT_SYMBOL_GPL(alloc_page_buffers);
-
 static inline void link_dev_buffers(struct folio *folio,
 		struct buffer_head *head)
 {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 1d55f7770cad..c9918176adaa 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -197,7 +197,6 @@ void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset);
 struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 					gfp_t gfp);
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size);
 struct buffer_head *create_empty_buffers(struct folio *folio,
 		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
-- 
2.47.3


