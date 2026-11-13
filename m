Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84D9606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qwj4zsEb
Received: by kanga.kvack.org (Postfix)
	id 4551F6B05B4; Fri, 13 Nov 2026 18:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DAA6B05B5; Fri, 13 Nov 2026 18:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C746B05B6; Fri, 13 Nov 2026 18:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02D216B05B4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:52:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF275402C3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:43 +0000 (UTC)
X-FDA: 85431748206.05.75D678E
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id EC3AFA0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Qwj4zsEb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794613962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3p/H7+3mLYBSagCd63fdFoeAPEOAgkODxSqUC7rZWUE=;
	b=TyoUFvCcmv72YdMq52XP5NU9mvuIflu+O0qf4JxLHYASnEHjU2/84npWpKsY5EtaUUtHE0
	Q2xF0Xdwf4aFYmDmK4AyW9QYxvIER02WldpcndRTSb9U6+COAuhfKdl3uRhTCneOPvjXLP
	efcH7jJEMiCIb5oLmbtOA5rphKKYAJo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Qwj4zsEb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794613962;
	b=t1Q/WiAjYNDm6C52AU9PUuZi/DrAFAvvAo+PMKOmafx8y6of9iQ7MM7Ks1GhA0ENBn+PGT
	Q4M25VQgAnagxZYxzRZFBegddPCeVxDHIElc+TaCO7lygAJ4ymFevVqqWldbReFNWq+11r
	pUn6tdtmr2Z6neVPX6LkQXDZz77Fwns=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-679a2b5fe87so1799861d50.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794613961; x=1795218761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3p/H7+3mLYBSagCd63fdFoeAPEOAgkODxSqUC7rZWUE=;
        b=Qwj4zsEbfFfC4E8BseXYMadseh1yTxeTEQYbCH7vLhyvwImdkYKKTq3Elxin18D+6+
         rP6t7b5Y7QX+PfctWZGLaC+H4BVN7XSth56zQdUpywDlpOI2wCIy7IrKX8+A+mjmLS34
         BjWJtfG8N8Go5uJPaL9pYiZsE1Ldw5kILCUkLtL0FRwEc9rV1cUyfUABZF0ZNYuQg7Px
         lAQBxU3uXqoijMjuhJ+rkNdq/UNDHTzo+qX8YaI46M8ILg9aV2nVS3gWrtOms8C6FOc2
         u9XtdCwXc92jFGl8zO1k8Aj4uOQe0o+BVpoJV/tfvOq6NwscmEHBjRHUliAPv5rrTGYf
         0VYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613961; x=1795218761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3p/H7+3mLYBSagCd63fdFoeAPEOAgkODxSqUC7rZWUE=;
        b=x97rwd9YYhgNs287LO1IM/NF+bDFoz3Lcq+KRG9wqxtxZBnebfJxnHq6yW0iUSYVQ1
         5vfk5y/CBfA/946nhtJlRDPilFHiHSQBxTCGQEW4Apez1k+eJlytECR/x5AAbw9zNa9P
         nf7Sezy8fjN/GdV7mLxy0//716GjEBZWSSl6So+/FI4x/baTQ5TpVIJTUVacbJryaGDa
         SjGK5j5LfBCOxjJxDLtsJEovO+C4pQJRS+KL8C804QPPYXgppbnzX4/wQwG3o3wn5lEN
         yu0nIY8M2NRjYnKWPT07ShBJ0Psnl0UXHpUdqYBPb3Cvnm/610qxv74hW1rp3xhNr3ez
         IAbQ==
X-Forwarded-Encrypted: i=1; AL+hErHz5CwRBTw0gMGjHr3BlW3sg+2AInxSe5nRa6kOlL8gz6tvBr+QllYsNR8QpetQYwSv/f3HXCeVmw==@kvack.org
X-Gm-Message-State: APuU4Z/JGIcN/2eJMmOO9M7H0h9NL3jlSf8TxJdwhmkfEidMYtGNOp8m
	Gj4C18zz9hjx4IwuqY+AgNJ2Cg3JlNS9UlVttXotyLciUoQgmnXnRhob
X-Gm-Gg: AYBFou2blWov/csbJHaIbueFLCL6MgkbkZdhY90M3gvmAOmCLiynW69dNCQZDDByK+6
	vph6dE7FRh8cRoTBsfpPA9j5skxa5781mKntQBoHgmpwFD/WMEQeV25A+iJ2klw6Dqwy0xeCLCF
	8wjhKm1opjTUbkuAqwnb4Xjt5W8exMvB80F4eYuQcBnuG+ijGHFNCbbSVJj7XGPQ2H1twVUU4Z1
	RJ9x8FTdQwTIxrYjeFoiK58lphyOYNZQ2z0n+Ys3PDyq1/wfWt0hndwXvlv6g+nmSjO+yD/dCp0
	8h7Pp6eMevU6WP45KxwGLaQH/dt7R1HxPnss7lQaoTT9O3u+unlD8J7HJ9NJHzYQ4CUEpvLfjg0
	zZnZV99tfyMJthpOqJ+Qjm02LOzfDCbNMiQZUPFLgIHASbwp002Aq3mX/Exef1F+/MGm5qbNhf+
	lhbyLFcs9ZgPyTWEp5/JdugohSyVuyhFta9usLummXXbFie5f8HTMGkrouc587yPLkBeUR0tPpu
	BI37Xb0Nj+BQ/9SY1CiP8aMk9tuz4Wj5NqFdZxxghOdbhwiEQ7sTLzkGQa1nN5VaRyCJ3YH3F9C
	feFpwFm44VP7b08LC7jnh+hlc2lnikDzur6aCIE8kMdDtTJBYVtzWCX/ag01
X-Received: by 2002:a05:690e:168e:b0:679:ba40:efab with SMTP id 956f58d0204a3-67d895e5acfmr2112919d50.29.1794613961145;
        Fri, 13 Nov 2026 15:52:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a5cac43sm3428687d50.14.2026.11.13.15.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:52:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/3] mm/page_alloc: move the kswapd node skip check into a helper
Date: Fri, 13 Nov 2026 15:52:35 -0800
Message-ID: <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC3AFA0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ioteweemw4s7bawarqwbe61d1t4ts98z
X-HE-Tag: 1794613961-885158
X-HE-Meta: U2FsdGVkX19mjCbaDVIIzGt9nAN5nBAxWVSHiE9/Oi+OA9li/ClFOk/xoMgkRafh6BmzT9DYWl5RZlP6sALxlqD1EPi/E3IkblJIvZe8IX9xcQ34an915PTR3E9hQcYThqG3PEpF66vGJug9A+ZmnAHjE34SG41TioVGG81sgNQkqCwYIPJGZi9VZKe25fpocDHDkIuQLz/LD+pyBZ1XpQ51JW/uKs2NvNIQbadCSW4lRXxfta/gIPgy/HxGOR3Ko/u0tpiSu9y+JWv7tTj55sNU0GvZee0dbLsjud5A6dVUkTe7CcJ50Xdx/ROh/UePt5wW2PGpxp9MQxcMyoRwGyWex/B3fUR+uKJJeLXBq3WGLBcjg/5+FaIUVSuGaAl84GtAsEk/utYAAsabuFkWI3405lFlMxGtuzFK9xdixFR8x27lOtDwelp1bzpn4GXPhVDRm1N4mTaQuD2QSofhaTeBBkYE75KkhrAGy6lyWJCw5ysV24Sn4PtZSuTEwWMdVZp348Int06JB9ksota54CU0pj4GV1/ms533m4/49ciVozDjEp+YIyU5xP3pksw3ISwvXQlbYgI/hs9L5st7xwL1azuYav7RLx43SLi8/CS/JXoHdEz3kKHg9Q5JO12ScQtCBC7f1KDBnfFIKs6eaWd1xQEPDUdC+vYbET4LhAL9/1bu3M2eNCE/jB4ClYdjiAZPNeqUUEj60vJXsiJ7uWADeoHnZtvYzOh8+G8A5Ru327mQoTliChl4TV4ojgKfzum6EmEUby0szXNDjq2dCctyLz7RVUs0ehIbIUWvPnGhveyOcKkKRP4mAi8mcPDndKo+SDU4Zy35LmVEcy73jYO+ZW/sdFZbXy8800W81Lu5USjbur23qrbgbl2beBMU/PN6Q/FKivWrFB2faMQC2X8rC5LS39K3sZDZOrw8zqnpN2r8wB5Qiw2BIEqOoX0Ayj9lCDmxtUkTZuBpjv1
 RdIp5KuR
 qFc6eSrCPItiazX1RDMf1BKQ41xVZI/OPkUQxpIMm2TckOkFBxz/bSyICTMMBOTAXtn7Q6SWWFTEP6GwjCqr4VwE9VRZeaL98yYUBTjpQ6kv3m8TTCGFLC/+rwWhOph2yjPJPrMChHHwwdiNldugIr4O4WN75qTok36UIqdeINvqjqGKQolfR5KNyPHT3zgX0kNbEGeCD6npxJwpaeUzP43l2WU82WtxskVm6XmDQSS8MVggu3Ob7VVvQBKff4sAcoLeqNoC10PR7tZH8QHFsrPRUkgm2NjQzYGj6leR+NVfEkOyb8h7NzAvF5onV/ux1yXncIzOPRYaElrCAko0FD6o99FNj1rOjCkQEs5HOs9NUHEdnJe78GUvs5E1B+LJzhE9rkHvjn+NJhJxa5iEuIWFpmjwOoeH9DQqzXg7O36RkVzhIxQ5jOeAlkuvKV76tQEVYxBtlfbCxrx1Zg1i10gaMAakxCpOf0AF23AW3WG/DkvR6V1B45Rdh6PVZBcxHdGgtgi4xvMf0qD5wHLPk4pl6wlatUSepeKr4nlXTSRTsSeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_page_from_freelist() checks many conditions for each zone, often
with a big comment block explaining the conditions.

Move the kswapd check and its comment into should_skip_kswapd_zone() to
make the zone iteration cleaner to read.

While moving this, also resolve a checkpatch warning which complains of
a waitqueue_active() call with no corresponding comment explaining why
the lockless use is OK in this case.

No functional change intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4d829e5eac49d..2fe49f3c0de13 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3785,6 +3785,29 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 	return ALLOC_DEFAULT;
 }
 
+/*
+ * If kswapd is already active on a node and the zone is below its kswapd
+ * watermark for this request, keep looking for other nodes that might be idle.
+ * This can happen if another process has NUMA bindings and is causing kswapd
+ * wakeups on only some nodes. Avoid accidental "node_reclaim_mode"-like
+ * behavior in this case.
+ */
+static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
+				    const struct alloc_context *ac)
+{
+	unsigned long mark;
+
+	/* Lockless check, a stale result only affects zone selection */
+	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
+		return false;
+
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		mark = promo_wmark_pages(zone);
+	else
+		mark = high_wmark_pages(zone);
+	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3796,9 +3819,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct zoneref *z;
 	struct zone *zone;
 	struct pglist_data *last_pgdat = NULL;
-	enum zone_watermarks kswapd_watermark =
-		sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-		WMARK_PROMO : WMARK_HIGH;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
@@ -3865,22 +3885,10 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			}
 		}
 
-		/*
-		 * If kswapd is already active on a node and the zone is below
-		 * its kswapd watermark for this request, keep looking for
-		 * other nodes that might be idle. This can happen if another
-		 * process has NUMA bindings and is causing kswapd wakeups on
-		 * only some nodes. Avoid accidental "node_reclaim_mode"-like
-		 * behavior in this case.
-		 */
 		if (skip_kswapd_nodes &&
-		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
-			mark = wmark_pages(zone, kswapd_watermark);
-			if (!zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, 0)) {
-				skipped_kswapd_nodes = true;
-				continue;
-			}
+		    should_skip_kswapd_zone(zone, order, ac)) {
+			skipped_kswapd_nodes = true;
+			continue;
 		}
 
 		cond_accept_memory(zone, order, alloc_flags);
-- 
2.53.1-Meta


