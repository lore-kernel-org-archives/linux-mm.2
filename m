Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD82606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=gHYDC540
Received: by kanga.kvack.org (Postfix)
	id D19EC6B05B7; Sun, 22 Nov 2026 22:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3C36B05B8; Sun, 22 Nov 2026 22:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9176B05B9; Sun, 22 Nov 2026 22:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87C886B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:11:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB24740672
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:11:30 +0000 (UTC)
X-FDA: 85464908340.03.3E1BCA0
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 25B9F1C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:11:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gHYDC540;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403489;
	b=r8yrkQZrAdT+3JEUgRL8W4lWU/K5roCsNqbFAidC5UlAFEnzm26IpwY+70D4c1Di3RbUg2
	ZSlgeWaKJwWjMMqV6ciu5fwcNTzJQTZfA+rcJiL2lFBSlXuTIQkmsbfgoERWrw4VuCDtjJ
	JS3IUrjnb81w3t/tA+4e5gg5kXT2eVE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5xwbvs9dbFOKA8I/2QnQJ3qTyNUOhR9OO7JyO6aGPgk=;
	b=kuDMX0a1V9AkDB3d+763SpAdDxAuHI+1g3gm+PxTwlAfJGUyTJc8vn6T+vjOoJwW3b++wJ
	QVPD7Id94Vv6xlxarxjPmRS/NtCUBu7812Iokti6qH40XS/bsKKmgnYhpV2G8yZUZTw6fA
	HHSOLmDWleCtpxxYZd9CP7cxjiZjT3g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gHYDC540;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso1972950a91.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795403488; x=1796008288; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5xwbvs9dbFOKA8I/2QnQJ3qTyNUOhR9OO7JyO6aGPgk=;
        b=gHYDC540hgFVojd9VlgQBp0F7mccQQW/B0g+C/mI7FFUDMfLrVWEX3hXMlqNoC1S28
         F8q6OEgWsF+E9A1E8F/8YtBWArgrOBsz1r5aJQ+/I+j54DUSQ4vL5PwhhyvIQmPvNc6X
         KkbEo0hC812umsBiuMQJX3Gd97qgZU3Z0LRXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795403488; x=1796008288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5xwbvs9dbFOKA8I/2QnQJ3qTyNUOhR9OO7JyO6aGPgk=;
        b=eohcO1u8GKSgjf5LKxAs/HVOhuRLb3Lyq7SmHmtZRL5JLLhQZvvkJcVq6+CFMuao1r
         /9gP+yxPW8PKHHFUjwCXVqhRX9YSLuw74DViC2DpD9TgTUfiCQq96aqgwnmjwJY8J2o6
         USUonh/x+GAxFlsSJaTilAhR6REkp/MGKH0ILmbLzTtylWIh/wA1NMKON/m2FANPeK24
         DqWHm4DSJFCFZdarJt8PDO0A64hJl8eMg3wc4ZVhIsCOe4bM4LRkeO+2PdHxYpn9Y19H
         bKn7qJ8S9WZXUTAD84j8/MAd0GmNWclcFmHEGbPTOTssC1sywMQAYzI1zjqen2RwOfpe
         SSTw==
X-Forwarded-Encrypted: i=1; AL+hErHDOx1BCHuXACsQAANiwnMKU2x8IVE5m/rGFpSlJ5tLijGZSGeC5CwFqK92dphlxYEpyCsNgCxnAg==@kvack.org
X-Gm-Message-State: APuU4Z8xFwnyzpQwte6DB4vqQ+StjyIyg/2ZJolpchmiFJmJPADKyqSw
	aVZMrSdkEfzJNktkLSCyqJ3LNjxD8ExJ5lLDX4t1wik7h18bzrncN8T0sBhTB7DaXA==
X-Gm-Gg: AZFdTZcJqmLZF6xjc8LSsEk5fzuxT0F1mNdB7WUzTH+HtIrnE79I6Fu+ZuFMQ7zydZD
	9V9bTholjMNXvTBdkQB33LeIJXI3SgIOpVaBmyBy8UicWHzebELXLq57KRg8u95+rNJ9WLqAGkM
	QKo2mKrXgBEely6ntEWU4mNrfpyI4DDt8ujvv1Swv6VRHPP6l0PI5pph9TCi52Dq9QXgfy1q8Bf
	VPz7eLDupplQb5pZjiKBAXZdRqo3RarF4fw7Lb3IN8tYpmvKW9HL1FDs0Nc9SsBXwcK1dr+EobJ
	YkXCcLu66+qHFNzpnspusw1sAr+MUz+tCZHp99aGIlFHxdchEpE4fQ2XCMWMVHVVzAPzmIEIDtS
	/y0Wz3ZI9588Bx0CBAsRpic0Wx7pN66Syg+NKuui/IOz/G0wwnsZ+jFsYPewKpjoCoZh99t0/HN
	0YyGOcX7/GXKs7RBjh4VWJDIuQxI08ZViJV7LaVj4P/wISJB3Uv+Pk8TdU4fLT0t6zqb0RCfZBq
	QxtslpZRwwt/hnLOSC6H4imUTGMj66akV9vbdXgDVhhSsP9hIW3QbR2P3doTCa0EKa4U8G21Ou6
	HvSKO6H1qjeeU6UbzY/TTnEKongCnG1M8zW2h/7XnJPY0hqGdtlPcrxRRaGLQoU/x4/KIvnxbk7
	gvZEVVnPszabI0I/xWw==
X-Received: by 2002:a17:90b:3b52:b0:3b3:b9e4:e3f5 with SMTP id 98e67ed59e1d1-3b41c92a524mr9488083a91.30.1795403487780;
        Sun, 22 Nov 2026 19:11:27 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c13sm15330240a91.14.2026.11.22.19.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:11:27 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Hongfeng Chen <hongfengchen@xiaomi.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/2] zsmalloc: free a zspage's pages in one batch
Date: Mon, 23 Nov 2026 12:10:58 +0900
Message-ID: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fg81htu1g4whtp4bs4mf4e5dbp91bcdc
X-Rspamd-Queue-Id: 25B9F1C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795403489-115573
X-HE-Meta: U2FsdGVkX1+d/LalcJm468NirjYgMe2l11sGapwqyqXFEANlPBL5JOVySYF8Qg7oMHGmG4bg4I7bfpQGoQi4I2zqVYRICAJyjR06VoU+xl7MjeqyZ7GPQl3hiqr1MKRZrtjePuoVuFdwm/ymDTXS/Ranh27x4IBLQ9Xl5QDH8pgVhQSpqBCbNoS5O5RNXRrUh0WJNg1BS7oqYEi4hK8XkQlS5XixYqrQf6NMfAgmA4457Geidu7pAH3UTYM3yHZEqSCFObQsiDBtnYfqLJE2ikAiLANHPYBBIP+7t/MFzx0U0+Hj0HiDycOfZDttlDhi7PUGJoxtoo21s+0r1zTeeULeRCf7cqENC3Czoe1fC2fB8g4Fy7B2/sbDtF008AsLgTGV4MbvH42fNt+hzz/X1WC/AgkTb/mIwmtOeMpcLWiGe+xK7HX1g0Yr+T51chvWM6HRZqNETMV4SSzjcVgLWEn26V8t9XdhxmZs/kEbWs3obwF7NUheJRGuIcBJcv7vuEHGQaxMamvQCDEXKOgctfEYWaVMOT3VhgP1D2NzqfTXIR9zI6q+8VBDRZOqo4VV9CdbdirJ33OEdNgx4PrnkENd3Wk7waLVEd0SFNilzfWym9486X8Cjs003Xqxg46VM1PfmM1m/KZvaP3u0gtamtfM+RSmyBbwxigltVL3oGt1vIUX8aSOM4jGqRDYUgwawlPW55cFCY5IbB59Ln16cFLjvD79ShkIE+cdL8t6/9IeERr42rHCf6Z3XeI4OoTax03PNpUTZVcfLAN7glDtPO5yXs/hF7KcejLwxQtZKePaHU2mS+0WmPpijqVOmPcmO3dk8bmWx6pktCyGz4i/8cz8LpIxb6/1yo16R+eCivJI8J4OOaYBiQJwuWt0UAOTvo5lUTa1WF9SSZ6eqeWFU9G46brNZDqXDbAotHsVUBimcbcglMRHkz2kaETZ7X3wuGD0e9NTaiGYzsYiViG
 7QSmLW69
 cYyP2QDY+SDAGrBKY708unshmPN/EO1mbpQ7Y/2nXDgYYpi8x+Dy9fmPJDpbz5sm7KQoyfoXMS41WVvx34u5Kka4JBS1iODjxuA+YU/PURR4h0Ru/Q3Ivk3pSgXWVDgYRod7RFfMUYBLKSooRxRWrl1dpfgT9tfECpGHMtSgFUAa9lQZqG6Dx/ykHddAmQSn2dSKbone/nCNJaQRi2UzmrPnU5666unkiBPA631S2ja0Ua5hRRoJIrHxyBe6ErlHfwegVTcb9ukY1OzrTeIihjDxCF3GTEkHjW3SDb3ndfWeG8ssnZcus1y2G5jrjlgrT6PNrHyBxSdrWA2kBlrMmqZhugVIZMzn4pX1TkDgkupHAMqdkb95LCNnKncOaDTw75f/aTi11RFJH7XMBZVLrBI6C8U3zeXsXrLwX9fumMEcSlGSomuhJog4n/3zFS1e1WVhCEQ/q4j8oOQyXEUGUyT9U/DKrFa3+LstSrbTrY+uoEFLc/l2bMR+1yLpiM5+GFoBFvXiQ8JguJkLcEcbHurEEc+JMStfRx4VjcBN6huncJdHmc/4FCvOCEnVq7NrEccOO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__free_frozen_pages() and dec_zone_page_state() take about 22% of the
profile [1].

Collect the pages of a multi-page zspage in a folio_batch and free
them with folios_put(), which takes the pcp lock once per run of
same-zone pages, and update NR_ZSPAGES once per such run as well
A zspage never has more pages than a folio_batch holds.

Single-page zspages, incompressible or power of 2 size classes, use
the current inline path.  There is nothing to batch there, and
folio_batch is not free.  The batch lives in its own noinline
function, which also keeps.

munmap() test:
                    next-20261119      v7.4-rc3
  256 MiB           -2.0% .. -4.1%     -4.4%
  1 GiB             -2.8% .. -4.4%     -3.8%

Link: https://lore.kernel.org/20261109105957.2577351-1-chenhongfeng0212@gmail.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f571b3c9e9ca..9dcd1549c2fb 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -37,6 +37,7 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
+#include <linux/folio_batch.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
 
@@ -866,6 +867,44 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
+/*
+ * Free the pages of a multi-page zspage in one go, see folios_put().
+ * Not inlined, so that the folio_batch is only set up (and, with
+ * CONFIG_INIT_STACK_ALL_ZERO, zero-filled) when there is something
+ * to batch.
+ */
+static noinline void free_page_chain(struct zpdesc *zpdesc)
+{
+	struct zone *zone = zpdesc_zone(zpdesc);
+	struct folio_batch fbatch;
+	int nr = 0;
+
+	static_assert(ZS_MAX_PAGES_PER_ZSPAGE <= FOLIO_BATCH_SIZE);
+
+	folio_batch_init(&fbatch);
+	do {
+		struct zpdesc *next = get_next_zpdesc(zpdesc);
+
+		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
+		reset_zpdesc(zpdesc);
+		zpdesc_unlock(zpdesc);
+
+		/* NR_ZSPAGES is per zone: one update per same-zone run */
+		if (unlikely(zpdesc_zone(zpdesc) != zone)) {
+			mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+			zone = zpdesc_zone(zpdesc);
+			nr = 0;
+		}
+		nr++;
+
+		folio_batch_add(&fbatch, zpdesc_folio(zpdesc));
+		zpdesc = next;
+	} while (zpdesc);
+
+	mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+	folios_put(&fbatch);
+}
+
 /*
  * Three free helpers, kept apart here:
  *
@@ -884,21 +923,22 @@ static int trylock_zspage(struct zspage *zspage)
  */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
-	struct zpdesc *zpdesc, *next;
+	struct zpdesc *zpdesc;
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
-	next = zpdesc = get_first_zpdesc(zspage);
-	do {
+	zpdesc = get_first_zpdesc(zspage);
+	if (get_next_zpdesc(zpdesc)) {
+		free_page_chain(zpdesc);
+	} else {
+		/* Single-page zspage, e.g. a huge object: nothing to batch */
 		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
-		next = get_next_zpdesc(zpdesc);
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
 		zpdesc_dec_zone_page_state(zpdesc);
 		zpdesc_put(zpdesc);
-		zpdesc = next;
-	} while (zpdesc != NULL);
+	}
 
 	cache_free_zspage(zspage);
 }
-- 
2.56.1.750.gf70dc682cf-goog


