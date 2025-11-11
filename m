Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672B2CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AC58E000A; Tue, 11 Nov 2025 08:53:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B858E0002; Tue, 11 Nov 2025 08:53:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B561D8E000A; Tue, 11 Nov 2025 08:53:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A45468E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47212C059E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:24 +0000 (UTC)
X-FDA: 84098468328.15.84C3A15
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id A92C980009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=259CjJXP;
	spf=none (imf30.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArUALhhnnFb4xiAkoDnrGF2IGhkIYQ7lLR2WNnAtJAA=;
	b=3usXOzxhUvQwGA/Vbz1jnf8ICZ71zgaN48uq+I8cwvuBAz0swlXTUj5qDAsX8tVauvRQ1X
	Lfx2UCzMsjdyqW3qtpapNmn/LdMLsM4t6yjPcyT47v0yEMpNCChNElGS/odAR9RL8FgpBl
	mFEPAJZjR9clpdPuISkqSmlEQIXMXZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869202; a=rsa-sha256;
	cv=none;
	b=kxoQd0FMS6KK8qL/1wps/8XfpI7Bsa9f5zrCM8uWH8Uc+VZl8IZVq/OofxGB/UyOFCdjxd
	bXfpD9IU6kWUUy1FrF9xWr+Nmv8Y2HAdYRdKxi03zr/tSxFw+2+YdGTx88DjL65AyuR5FB
	uDpWvBar29uhVIRSyeNfkqbE8q+bv7I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=259CjJXP;
	spf=none (imf30.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ArUALhhnnFb4xiAkoDnrGF2IGhkIYQ7lLR2WNnAtJAA=; b=259CjJXPMHPnTFJE3SN3W5RJz2
	MGZ9QBB2T4Lt/+BnG7+hzvjlHNezLqLVmiUpGzyC/yKmCA1wBStH1etDAxaEkuJr/UI8U7AKyF8Sp
	yS4s/mxfV3NkZj+OMFthIg6mjDa3XLNu959JAdbzn942QuNkn6Fe2ugQyq09Mgq1kBOku56luBqgf
	uO5cSQitNIxS6t09gYaq0VZhir2qpVmq6Kp1pNC7yy0G0BIHB59DsKiZ5r+bMuf0QMovXzFlSMifc
	l4mrI1gCFeI7uzioa8OMXEnIwc/YYzsF9vRNl71a/Wo8MXj4mRNI1uNdb6vTPwSGlJwzMFTmVWPpp
	gJK31OPQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIooB-00000007Gah-1yuh;
	Tue, 11 Nov 2025 13:53:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] mempool: add error injection support
Date: Tue, 11 Nov 2025 14:52:31 +0100
Message-ID: <20251111135300.752962-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A92C980009
X-Stat-Signature: y4qaeex3eyccimhaj9te8f9r9yqmupqu
X-HE-Tag: 1762869202-636667
X-HE-Meta: U2FsdGVkX18cU6J2SBWyK76njHgaalYhwPMU8hLng4krsNmGlaw+ZnzjqH5rxLAt/9GJaBpEzcYv7IZMvKK/59nLE61DSWlBsWrI9a9RzQw+be2vC1MOZ3jh5ZInXGg5KqH2OYOtmY9srx+PpuOF2OM/Vu4CZwMzoDaZSEqfuelxetz8ZEarwlta3n7XRuDNXvjnIrgag2I+uL641huMaVoHPDrlX8vscTD2qBcHW3N22GFWkQautnemj034V2B42fTaweN9afszVTHge52EWHXA5BUKmT20hB5YRWvvmDPhIJwwiL37GvH/+H51Vv8NQQbmWBtjmHCLlvBsZDcqF4hGbyALBpX3nOk+b5exomB+g6JDLfh5ELKeX9I24f3QePE5o+WmlgHxxznwViAOnkaRjuXewH0UfBrxH9nGrmkWuzhW6GjP8P1NjAiedNVLSsLTy2nXGCYo9OIV5dxMl4kYZLmQ2RKOz0YTJqeEKhp7ex3eAhjh6Up+UDoJmZPlFWvsVcELNw7opp/+B0WEUP6VH7KWO94EfbLpWc4yqoXznqH/k00WS7x/h3ZNo31FoPuhynnVBmCqnzBEOX2ry1xfDxyo2eKscvzYvwm2t2zcPXjo6C4mu9AVG9fCPjggTtH35eOtrmVNMw2m97YeomdAcMSO1QAXBaHDaGiG7YcQZqSdbx9m7SSJcygC2ToHWcp5b6jCi0reXdNHrsP9yKKlyPt6KlQA5SEAq19+ogle7IJqNJSdAVXQk6vu1gKlf/riW1U7hoOyTUwP9XOHWHNjlg9FO0bhk7Guc1wMW4sP0Ux3sTEkY7ohdcfmSytFYopdaT8j/yo94JsJjXb/Vv8saAnTQatdtibr4gW/lK0qZCfgY3BvPKKlfsAEkDYQOQydPvcZR0fI7fbFcXdBwHA/q5yWKj8Kyk3vsRmDxaKgooNhNa5C893e+C48yqFk+wcAe8rY0hKi3CQ7Si0
 jr3ZHdOT
 oeUISIqUCqPEBuyP8mKd4wvjsJ2N++5VP7T8P47Mfbpix+TsUa8uoqxfuoZeSwmhLLQQNZSVQEsxJox9IWBkMl324b1i0vkCKUu6p1vuZwlu33xDkmPA9Sj9V9S9mBDaYfASNQpZQH9UOQRU4mqLuumPaITpaNI47vhH1WLFNtkdwJ2YRZoMS9USAYyKUblV9npoTPjaQFzp4a7EDeazuTYyBflHt4HKvb1/s6FlkPplW0IvCYMcEirBtJt6/tWWRUwQnAIn0iMpvX6nRmPRXdtWOymaG/vUZaeSBfwMB51I3q3F38lER73tGBTK7P9fv2vZoFYQuSlyIp5mqJVEHpqC2U9ZJKoxx+LtK8wFDtElt603UPwZTDQ1MOq0XBT1n6XT4SgiGpglYrJPu0TGTt79n9mjD20QEE6to/ceIAi8AAGV19YPtTdK8EsXso0VHQPh+lMdED1AmkoKQDKrt41LgAPjIzdLZiAygibFGPVrtp2d2XxSLkpcN9aQtKv9ksE5oi9VAJ4ICY1Wwlvl7UNUfq4C2InBqofYtdjhFk1ftk+PbgMbQAwmSc8YhDz36Hq2S0f1Tq81ARJNUoyiefvaOjQ==
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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mempool.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1f4701713203..76ba4d5e656f 100644
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
@@ -404,9 +413,15 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
+	if (should_fail_ex(&fail_mempool_alloc, 1, FAULT_NOWARN)) {
+		pr_info("forcing mempool usage for pool %pS\n",
+				(void *)_RET_IP_);
+		element = NULL;
+	} else {
+		element = pool->alloc(gfp_temp, pool->pool_data);
+	}
 
-	element = pool->alloc(gfp_temp, pool->pool_data);
-	if (likely(element != NULL))
+	if (likely(element))
 		return element;
 
 	spin_lock_irqsave(&pool->lock, flags);
-- 
2.47.3


