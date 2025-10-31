Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF0CCCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57DBA8E00D4; Fri, 31 Oct 2025 05:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E228E0042; Fri, 31 Oct 2025 05:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BCC8E00D4; Fri, 31 Oct 2025 05:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 335788E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:35:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2EC4B955C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:37 +0000 (UTC)
X-FDA: 84057901914.20.06FD024
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 618731C000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:35:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GWyXIJXV;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf21.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761903336; a=rsa-sha256;
	cv=none;
	b=nu2BRbDeFWAPFSSjLGIRCTLU1DRDaqZ+8soeG9kaRtcEtvBMsYqVCnI4SJZfY0Ys38NOxq
	IQqfJ4eLGkFOmbPeGnZPc0uaabrAbg6OHZVuC8NX/1H6qT4q3CtRZW9j6w2CsFUSrWQOst
	IvcNnD3CWxC5nWK/ixkATgWf+hQ61T8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GWyXIJXV;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf21.hostedemail.com: domain of BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f7946cdf28fe74239a26+8104+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761903336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQcOvR002YBJLomweC4BY3LAL0acld9iJ19aX/ran84=;
	b=5NldGN4jmrukdhi/MO0uKTM3M73uhq+DG6C1FvUENmopZbBBbBsxu5S76qR/YWmgvavjcW
	a1czG3a/ZxC5jlv8Hki94zcgr7MfDh/g5TOvkOI2Gc+ffz5YDiDnnn8R8hxa+KoXCAIuDd
	Beljwxlh0rxbcg2SuC7Kn4e9CheZ8So=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SQcOvR002YBJLomweC4BY3LAL0acld9iJ19aX/ran84=; b=GWyXIJXVjzGfpONv6rx+3Zedht
	Q8fXnuaOXitXgCoQ4omWD8Yp36eBz4GvkA0gJ8HrL+KDQxNu5bLfjZQtOGdolRzn2qczErqgB9qZa
	S7B+4MAsMEe+Wme1p9YQyq9cvUYoL2hvxCDxKt+9uY8mEj0tmQFVf58EX1xhl+ChTbJnREiKsY2a7
	wWGCnUzcmPnMB7ZOFtGKhq9TX46kORy3Q751zOT537q7A7t45RgC+hFvRmvLn3esdZbbU842Q5pv+
	KxIkYfrhtPc1GVSvKgfYsj7HTeOyp9XOKGvnOQHCei01ziYMoCRVCayBYRaT5+Sn8ulTu7he4Xvcy
	aFImWsQg==;
Received: from [2001:4bb8:2dc:1001:a959:25cf:98e9:329b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vElXg-00000005opk-1qyJ;
	Fri, 31 Oct 2025 09:35:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/9] mempool: add error injection support
Date: Fri, 31 Oct 2025 10:34:32 +0100
Message-ID: <20251031093517.1603379-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251031093517.1603379-1-hch@lst.de>
References: <20251031093517.1603379-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: hduzk1h86noatp9nofaqtpjf6qds4rub
X-Rspamd-Queue-Id: 618731C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761903336-766803
X-HE-Meta: U2FsdGVkX18iIz8qppRexKpBQ4DoNdDvYPLxirtlOUMoFe9rV759TTJs0Am2s5CtMxitr6yTF2XsSJewaJ8RKTkASxpqfJLZ59IOzDdpegqP3slzKZeBi2V+QqEK6T2jpLIbr2IjlKA5XonT7TorEBDy68mqwZhz9fXQHThqnopHIWyjctg4Bj1Sff5DVLXF0LHLs1f3wb3Tk632Km00bckP94zgjLnc1moZoAw38ROUpHy2OwoIrPf7ccLhZU4jM1Nz+yUEvRCuDbSaapyJyjGqDrLbuUlk7/OLb6YLuRHSO6tkUOuWxb9R7tuTrvRy+j3eTOIURMvy2JBSdffx7ukNFWefqqEY2yJtQtZvkNAQ5pKeCME2/zidDHKpgFOlhYagzGu+BNWQ0wGMpRMgLlg2dQm8w/vHBPBIjcL+MA9pQr6RZLJhrBXOJfsJHHpLogd6vouhibnNPqZaGt/8ywxhUEh+0DVsrfnoqmffvnH3FCPqKOKGiVigwKFNEqwTAH3an9/CojsVvLt3ARKM0be61qh07Qx/2gE1c1rfWkDYLbekY5lJZk4NXfv+wOtU28rEVXmyXLenDt3tNp+OMGx4x1v1j1c7tC/zu6aO4TytExhb8b9/lhgg/G3t8GB4Go/KZ571yrMBWUH5fHIYIzKyhBf4EIKIENQL7YvPuB3Cv6o2lIzG94FUAAK1y0P7qPAiNVfO0J4sY0wzMQ8JtcMqNTrEaE/qizD5ZcMzDZHcW7pvBcZ6H2ucnUNqWal3Xo2T07E6vVz5S0eu9apIk+YFcnVwPTkOtotd9VXV1eN3eFFoPthpEu4BH97DJIob+2bfzuUrAKmUCycaVmLT5RDksPUy+uYuGxc9NXt683W3eYD+P7SY2f+tZuA371VtRMouXhKybqVi5ZF3o9oYl1zIHNKe6ZpdivihVhUH24ZXyDYNv4TvFd1xajg/GuHlFe+T5taCiec0irPAeRl
 Cjy+jcjC
 duPBC102y8gRLnFoPBILmEXs30gm8UtNB/p3Wo+HpO2REI9tCCa8D6fZjoYc1MVGshpIaGAofwlKKBuxDstB+0y+Zktavi1AV9MEhU3gLDa22pqRpYyg9hKZBclJH3tYJYD3NuqdjAIMGwGAt4faIaWA6mvFjFgZuisbt99YDQt9BviZKPiMVz55wNmrExiiCBvLorSfj6gxQ4Sp8+NwLPv+hmaeas2VGRwPmu1/k7pI4UHDFOC7Hw206YIvVd9NLCy1qKhpnx9IrYqN5yejFTFxojATWcPzJci0qP07HmJ6mFpaaKmybtL8+gYO7kTJiKPm4lkb+ViYjCM1mrOu5QQ1jiLlc5P91sr9crSEZ+WuNHpjv2WhNU9Ak8GbIrNrzzKJ4t3u8LRuEZw6Pzou0iMUPU002wQb4pdwMQ1EuQsIbsv+sGwN9HNfASaSaZ0dsXd2EyUQJsFFUTU72kKi5r4PrPKqocm74SdAHaV/7aQiIdJAkavdXbj7Ggrnh882lUnBfhgfN4StkpSK+12jbDMDggi+F6COjoh+qOfS8M5eMhsy6wbNGuM6vp/u9jymzQ6cm0g4ivFage95GHW8cTIzaWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a call to should_fail_ex that forces mempool to actually allocate
from the pool to stress the mempool implementation when enabled through
debugfs.  By default should_fail{,_ex} prints a very verbose stack trace
that clutters the kernel log, slows down execution and triggers the
kernel bug detection in xfstests.  Pass FAULT_NOWARN and print a
single-line message notating the caller instead so that full tests
can be run with fault injection.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index d7c55a98c2be..15581179c8b9 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -9,7 +9,7 @@
  *  started by Ingo Molnar, Copyright (C) 2001
  *  debugging by David Rientjes, Copyright (C) 2015
  */
-
+#include <linux/fault-inject.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -20,6 +20,15 @@
 #include <linux/writeback.h>
 #include "slab.h"
 
+static DECLARE_FAULT_ATTR(fail_mempool_alloc);
+
+static int __init mempool_faul_inject_init(void)
+{
+	return PTR_ERR_OR_ZERO(fault_create_debugfs_attr("fail_mempool_alloc",
+			NULL, &fail_mempool_alloc));
+}
+late_initcall(mempool_faul_inject_init);
+
 #ifdef CONFIG_SLUB_DEBUG_ON
 static void poison_error(mempool_t *pool, void *element, size_t size,
 			 size_t byte)
@@ -399,10 +408,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
-
-	element = pool->alloc(gfp_temp, pool->pool_data);
-	if (likely(element != NULL))
-		return element;
+	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
+		pr_info("forcing mempool usage for pool %pS\n",
+				(void *)_RET_IP_);
+		element = NULL;
+	} else {
+		element = pool->alloc(gfp_temp, pool->pool_data);
+		if (likely(element != NULL))
+			return element;
+	}
 
 	spin_lock_irqsave(&pool->lock, flags);
 	if (likely(pool->curr_nr)) {
-- 
2.47.3


