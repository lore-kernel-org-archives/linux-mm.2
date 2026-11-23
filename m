Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AC6606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=YP9ffkaZ
Received: by kanga.kvack.org (Postfix)
	id 513D66B05C4; Mon, 23 Nov 2026 00:47:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4236A6B05C6; Mon, 23 Nov 2026 00:47:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3137C6B05C7; Mon, 23 Nov 2026 00:47:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27D66B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:47:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 753EEA7C6E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:47:58 +0000 (UTC)
X-FDA: 85465302636.06.75400D5
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 917E41C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:47:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YP9ffkaZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412876;
	b=dges4diO1V7alsgs5w0yafB96buEyg+jON0c+Zv0IB4GXn3PvUPOz3B9giDxM6QoDYajr9
	RFtBzAuhiMuRgW56ouuKhUVfss8LI4E6e/QL6zDPIXXF14+nMeZIUYCLgEbjC5nP1Nixe3
	+pbDdMhomiRcKQynnHKCbXneyewieK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnMxzhHOEHpbsDB95jN4ZokxNKIXrj2a5/W65iB8kpI=;
	b=EbXydBpSPsGORJgklZ73Q1MOAEcEgy6n5kjJQ4Gi3Zd4cgWq66ZQdqWQ9P0T/CmiUh2/BZ
	FOiHBpxYUDyB2xwckTh6rHwl9uHctmtR6kOB+ID7+Vuk1t1yoaIv5vK1jL1jsj47WXqEYZ
	WOMFVUXNlmniCF4JHbTcEnLf4JfSnaI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YP9ffkaZ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso1127183a12.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795412875; x=1796017675; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KnMxzhHOEHpbsDB95jN4ZokxNKIXrj2a5/W65iB8kpI=;
        b=YP9ffkaZVp5iQTcPZI1XbtAw8A8kX3aiGmtQOdpKhmxr24pMCyjDRwJp9UwH/c4AgY
         YRz6CxRrvUddYV1HkgCsdcz6Ex8dFw4IossL2gqaSak+Q67oLl4K4oSUmxfAs13tUTLv
         KbMw0N2iSG9CTKY9XPH7CebGex7k8uc8HiDAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412875; x=1796017675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KnMxzhHOEHpbsDB95jN4ZokxNKIXrj2a5/W65iB8kpI=;
        b=U2HFGBEvVAdJ0CnXMe56/VGX03xRhbNzDhwb3jxoGOkdmUsSqt4f55w2YOYZVFyOcG
         6BgQvr5asEjjWs4g0FQlI21bt+TttGXbUVD9KoqTpkmODvc57iEQ48pyl1ac49CZ9bdi
         WSd+uviGORUONjvVUtvPJ3gu5CLn226fzoXhnOcQU3HILlpe5MHlpyUpE+Jsa1/ihhjW
         r/8ZaTRy/MMJMLF70RC7uGSohXCeNVG/BteL65qawkImUpttF/jK7Z9sm+xbLdPxubKX
         sQC0DlNgwX9Odc+aJxzz+SXL5pR5Go+JtOHJzNghzQlK9KxPnGsmp3wssXk8OyJQG1A4
         72QA==
X-Forwarded-Encrypted: i=1; AL+hErGASiZpTkhqPJu882GrZqUvkgJBP30nJsI2p0iw4e1ZSYW8vTPj6Ov/Iy9RGkQ76cPPAkmWEew16A==@kvack.org
X-Gm-Message-State: APuU4Z+6zsY9+E8hAucvfdTjo5TUhNmk67/6j+C0SAfDhTKL0ekbwRhw
	YW4x2dmat1Wv2e/JM0R5qn3auLkt3E97G4K0zXABAeuzT9qjd5UAmRQkO6mNzazjCA==
X-Gm-Gg: AZFdTZc+IEpEOUwbznDf4iAA4W/TzWz5HSVb3dCmW69Iuv0rTIWT6c5VGYxd9JHPEvM
	JjgajG3xOCLVeX6yM5G4LP0CVHGrAeT2uXEyJudFPXm0vVZGvr7XOapDQXuAei1kENvzy5VaS++
	WeA9c0tM16vXwf9+vaODQCHqMdTS2iBND0GscKjlC0Mtqn98pnDmFSn6roCjNW2YRxlalAVhBCR
	4jCvj+wvjiY5eAEAdIpId/rKIYCf19lRJr5OuXOd9d9J4sszxVjwnA5i4fqDi8cXYrSqg6Nfydl
	dMfAslWpkKYsEZepDl4TMOhOvx1xz02aHOISJA5MmDBWfEyXMhd+7lvJtlSBxzYLfggNcR5sZyO
	izk0Q2vWuy3JfE2z6xmNX7LToZgcOB+NAux1rDPtWIZT85e3Uxqh/15hOyWLNOAeuO+KCW/IwdL
	KWKdmfmPXqLtB66lnzWlk1eFmyN89KwCUgSZvCQjdqznGZH1z7VAgiu5I8Pbw5PFnA+oUv1Qtxs
	1v0Hq9mnbnZmhYJ8YBY8jrKAYiVTN5I21Rzlv+jaZ5p5zrkfUrOBNl6Od40SS3kPF5XcfmHtMU9
	6TaVtHdNLqR5hBXw2lA2dnB6g7T8mH9Mu+6ZMsNtE1JORl1ZE34KRr6Q2ZbUBK/4RHcobz8nJ8g
	LdR8FRDXwBsPN+ZQRdg==
X-Received: by 2002:a17:90b:3f0e:b0:3ab:1481:69e5 with SMTP id 98e67ed59e1d1-3b41c8ffb06mr9953948a91.11.1795412875450;
        Sun, 22 Nov 2026 21:47:55 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c07sm16240267a91.13.2026.11.22.21.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:47:55 -0800 (PST)
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
Subject: [PATCH v3 1/2] zsmalloc: free a zspage's pages in one batch
Date: Mon, 23 Nov 2026 14:47:36 +0900
Message-ID: <20261123054746.2579253-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123054746.2579253-1-senozhatsky@chromium.org>
References: <20261123054746.2579253-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 917E41C0004
X-Rspam-User:
X-Stat-Signature: a1y3tfakiezmphd6yixymucg65h5g6iz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795412876-925694
X-HE-Meta: U2FsdGVkX18PNXiD3n4UUg6w/gUTk8cD8ErRo7AH8ACQUFSJErOc8uk3lFsw0ko1h52DrulBF7KVAzmfoeUZ6NDr+/6522YZ7XlWQHhM/sCIikxQF8HCCaQ9td9exe3EURCrv8mZufBU3mlySol8+QoNEXVHfE5gaepkuDk+vd78kXULJEJ5v+qc//SZ1lXChPZDelIPQhZzNgG/BLjh5fu/uaHm192/OWS+1xgNSmiy/dkRiqmDZdig/F3lAWb5PCIUX0lIrgqu41DcUFBMTBqH64zMQAlGaZQi3hdjLsF8WJroagEvI20kITAwg8cA/3q1oMQ6nO2Zjb7hPLapp//IwpuxDGMLRxWCXD/+jVgY5Th094BzC2zBs0P+8aik1VwXzKPNAxnK4gYfMBM0FmWAQpTp5paeaMGWBJYe0atHJrzQQzUivwSOCqjWdmd5xTW5UvJq+0/0QlCx3kTVGKM2T7lMb2/l5gKTbSftpYp6S/nHDlmhbQEOuVsARj2luLk7EZyYjUJMK5qZxqE7bmDpRPoIxM/zNliIsr0PYnnGjHBhe9v5i60JJkExB48yIi9o2q4Hv0Duuk9b/YrCdw4kuRxRSWOov0Qk6WRT3zZ8i32L0FR4KlfhG0D5obZlhOJ8dl58P49w0IfHf3rV49f0NMueqHqM1y1peAJLYUWuQE2QA3d07pIsXMDVHU97RPy3+I66o3j7GvDMLDE84RhJb2ixYau5fT4hiacFll7kR5jd7yoMzlEp7cuKf6prypD6Y/d44zti+VU9EnN/nMLjTK9KLDh+kP0oGAU5eQ2tb5xRKzJmTTMf0bD+YI7R/JL/e1ztbEmiQmjSRKHGAGn01yjruGcnGGlEAHYnZ5yq3zR41KK5OsLK6bJxiqEsOhpPzjx4I1U+oaya5E3Qbtw3HdxmFYZIDHwOpGf1vl6ArdTOkVzBVm9WwwT8/lImM2FFuFdjobx2LG/D2Zn
 0lZD9eZx
 MqC0myr5UbpNhTDFbvTKJHiBKIwlPvw3t08p8c85mJYMSHG2XpgEUyZGB9u9xQ+OOFzo0+ZoIGRoz2f6ycadpXzzfsLsaWwOv/NAqbxDnKMAPhEPtU7gr9XlqljuBLDXvarSMdDPyCQpCkscjVzJCV0LgEZGMxmZReZxP1tvqDy9Oy5CrZ7jPu8VALV0PgdBYy0tVPpAf41FLjCZS/AaMCISH1ueeZyXEd2OqjPQj7Jmn92VLlopQVPisJTYc7jP+7xUJ5wxtQtNyoydjrED+HDOALbDCcV3MajG5MkYtTgm8qidFkz6jTU/mI+aTa0u9cDxwZJ0k9AF8MY56IX785GUWe4MO2KVO1vl1BYUCmHO864Ppbj8OyLNMVRsDJo85uUwrx3i3sMerk4PmUuZXTVTWEAThv06NUmRE0R83BL3394GuGhQ518G2wa7vIz/nVqTwdFUW+FtoTa5OUtSb0X8y4zkcZDCCS1jy85SRruUIEcPww5HyrWC17yI5sjjZLurHtEChq+56wWL1Np+izPhcjxgagbFyYaTjnUresInb8VUFkUvrBvCGYjCJ9pxHhOfkRUxMfbyEVe/HZOe9KXNI0BrVGKP2KcFE
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
folio_batch is not free, hence the batch path lives in its own
noinline function.

munmap() test:
                    next-20261119      v7.4-rc3
  256 MiB           -2.0% .. -4.1%     -4.4%
  1 GiB             -2.8% .. -4.4%     -3.8%

[1] https://lore.kernel.org/20261109105957.2577351-1-chenhongfeng0212@gmail.com

Reported-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index d5f313754934..a1b6161fd237 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -37,6 +37,7 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
+#include <linux/folio_batch.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
 
@@ -837,6 +838,44 @@ static int trylock_zspage(struct zspage *zspage)
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
@@ -855,21 +894,22 @@ static int trylock_zspage(struct zspage *zspage)
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


