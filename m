Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98B9CCF9E2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 08:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6EF58E000A; Thu, 23 Oct 2025 04:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49508E0002; Thu, 23 Oct 2025 04:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE72C8E000A; Thu, 23 Oct 2025 04:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB6EE8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 04:09:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6688C88ECE
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:34 +0000 (UTC)
X-FDA: 84028654668.19.4A9E5B1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id EB8D418000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:09:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kYYFswem;
	spf=none (imf16.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761206973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDGB5IxL53rt1Dr2ri0tGGZPsBM0MXiOrsmsKajWVtY=;
	b=rlC2T0J08ary5ln3pJNAmj0V0SlIeqS6qH2J6DMcczJlIzvrUX/xN4UiiO/8U+NSspNZd5
	vq5kysOceK/r9aATGbGmLByKLBOADOadS910uYNlgHSR89guqks6K837sUBSMsGIxZ+/Pr
	4B2JIdmTk5mIWLCSDTgcPo7wh3SwilU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kYYFswem;
	spf=none (imf16.hostedemail.com: domain of BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+253124156df135ae580b+8096+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761206973; a=rsa-sha256;
	cv=none;
	b=Rz86HlFxmxzOnu3EY3z8vMxfwlznISktxwJjLiitWg3QVK3TbBAJ/ADO3b3FiUXyln2GWN
	35dt4Jib+LhIt6veJy1yG5LDDk7SMF82MAwbGk8nkmANqKIeXdQqqokjL6yhWt3uQvDOX/
	YUkIS564kKlDjTjqDH2Q01HZloBk9pk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UDGB5IxL53rt1Dr2ri0tGGZPsBM0MXiOrsmsKajWVtY=; b=kYYFswemG3TCRweSSZtSl+JdiM
	bBfH9Q9teacyuXl/ATlEQdSFVEtQEqTXQPCide7mVX1Y97knaqWvVQqZuK8nNjTj3C/4ghalxK9Mg
	e+AEcfuVuxPIU7L/eM+iyjwjA1O+mbioI0KhZLoB5Jv6YrApVx1+sMG2I35L/mBsYsUIeDFK/FsM9
	y0zqVkAxYA9zs2fcsPJfUJUh6eaKF/TxdgRRdsLd26pqDe6XyWXCKlVfwTsTemBSob6wRlAin9o35
	EiUKhjAKXyiqEV+V4njQRXdWSCNBDPiKBuOGEakc1r3pwaFTFoIpJna7qg7R4Vm+usBgS1HaskcXn
	9lTx5jxA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBqO1-00000005Tna-39ms;
	Thu, 23 Oct 2025 08:09:30 +0000
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
Subject: [PATCH 1/3] slab, block: generalize bvec_alloc_gfp
Date: Thu, 23 Oct 2025 10:08:54 +0200
Message-ID: <20251023080919.9209-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023080919.9209-1-hch@lst.de>
References: <20251023080919.9209-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB8D418000A
X-Stat-Signature: zo4poxmrh1wtfje9g6psuiek5jc48bjb
X-Rspam-User: 
X-HE-Tag: 1761206972-260831
X-HE-Meta: U2FsdGVkX1/DYbuMG+CfY2lzvdMEcAm+PFY9SPDi0/MG0MQ2809rZ11SIjSlxmQw0ZHw+h+z9aBlIsadD2nsykDbyWbGxGYxe63+TULpLhBHeBoqU8CR9ocrC7+uEsoyR/CfkOA8VbiQnfzjo9Y/Bm7NV/1I4hrubyD1lS2he8rAdcVhlUBhUrtvqW+6lqOhzdV7y3ZLtlqfa46ZHX+Z10qkKJF3CMj5pfxMkmW7k5gd0sVbqJZlUWoa1G4tod8xHZTqQeTYbZwZm0kudXmlNIPY3UXhMJumkaofDrRYXZgc/WBmAGUgiNyS5rltdTi32ll34EpmAF4hF5LiqO5scYFBzMGSa7AVAQsNW4QUhvV76VbhlFp5+xCZo5xiUWnzrGVM+iJLxfMq3n6N3zfOqrOf4xrnw+KbULGZfkjLM0ECXeaArsAftTCIG4KVFm+7aq7RY/lm9g41cNJJ4gA5uov7/snULZ6SMpGsZpDqqv/8pHuvl62htc+Z34nWabXh4PdlGuN91fIK3q6eEm9STatgwFNrVikDrvnaLnUgVnrM8+xtGfEHqeC5xvd3kuTYM8rnJHLof8gUcvnRppex+X6kSnW4VsqIQKJ7fwugNM9UN9dy4n8MxcNLeXVIc1kiX5DxtqOCb6XRE1TFQG5XcCKWe80MQwktRI6S2ihCBWdTuGK6PQQjb+fU1PZ5lxcc4IIbgp55WPaIpDAh2dszmiM+NVF699LVefZhLZ2VszdUTLgW2ou4rnGK7Cbyv52lzdoK6z0v90gJ9fNRk8HkXZQyZnhvzsoOGSXUo8PqgLQsvby61ZjJ5mLnN/6H/zZMQchMuY65zXbUSDr/XYMzRVuWB1DvyzyGjH4QxUYJ4Hw8GsNiwHoGZPbNL+ThlKXtAyHR229p6LmXdrDjz//KB4weP78irT0+jxyojiPq+FmOlIuoW9TQbfBtrn0fGqWRoW0vKLrijKn5bFh1CbP
 ct2hoPkN
 6Xz4DeM1J61L7KuY+yU2RtyMLZ7lH+nih/c+t2CqWChpH4BoppMUoRlkhhDm+o9j6qS4n0Lm0uk5QLnjHvS9LaGYx4+rjGe90L/b1B3lcdyp6SDqAhEAdnSl3mtYtj6CxXy7vv/dk0K3IhnROA4huxvzKzMJO6hjXUQUignp06JyznMaYYpXGFfr21Hw9cr37b2oxeLL/a9tHlBU6/htlK6IwduPSl7XNA+f7nDhXO1/FobEGOmpsz6Xsaol5aoUarP5lkaukaxGoyODarXNiwb6WxP8j8uz2mP+rUnkW01EwcJPr4Mkjcv9EK0sv+5lvwBxBaYTOFoCBlbzQlog9e4f9UNcPcKmZX9MBHJUJURhjUFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bvec_alloc_gfp is useful for any place that tries to kmalloc first and
then fall back to a mempool.  Rename it and move it to blk.h to prepare
for using it to allocate the default integrity buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c          | 13 ++-----------
 include/linux/slab.h | 10 ++++++++++
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c278..4ea5833a7637 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -169,16 +169,6 @@ void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned short nr_vecs)
 		kmem_cache_free(biovec_slab(nr_vecs)->slab, bv);
 }
 
-/*
- * Make the first allocation restricted and don't dump info on allocation
- * failures, since we'll fall back to the mempool in case of failure.
- */
-static inline gfp_t bvec_alloc_gfp(gfp_t gfp)
-{
-	return (gfp & ~(__GFP_DIRECT_RECLAIM | __GFP_IO)) |
-		__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
-}
-
 struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 		gfp_t gfp_mask)
 {
@@ -201,7 +191,8 @@ struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
 	if (*nr_vecs < BIO_MAX_VECS) {
 		struct bio_vec *bvl;
 
-		bvl = kmem_cache_alloc(bvs->slab, bvec_alloc_gfp(gfp_mask));
+		bvl = kmem_cache_alloc(bvs->slab,
+				try_alloc_gfp(gfp_mask & ~__GFP_IO));
 		if (likely(bvl) || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 			return bvl;
 		*nr_vecs = BIO_MAX_VECS;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index d5a8ab98035c..a6672cead03e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1113,6 +1113,16 @@ void kfree_rcu_scheduler_running(void);
  */
 size_t kmalloc_size_roundup(size_t size);
 
+/*
+ * Make the first allocation restricted and don't dump info on allocation
+ * failures, for callers that will fall back to a mempool in case of failure.
+ */
+static inline gfp_t try_alloc_gfp(gfp_t gfp)
+{
+	return (gfp & ~__GFP_DIRECT_RECLAIM) |
+		__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+}
+
 void __init kmem_cache_init_late(void);
 void __init kvfree_rcu_init(void);
 
-- 
2.47.3


