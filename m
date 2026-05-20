Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4BFCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41746B00B2; Wed, 20 May 2026 11:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E215C6B00B3; Wed, 20 May 2026 11:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E606B00B4; Wed, 20 May 2026 11:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA7AA6B00B2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D769160AFF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:59 +0000 (UTC)
X-FDA: 84788110638.07.E001963
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id D097020007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ik8r2kWH;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwVqkzhkrdkV2AHWI0B8Z//Qg+XaJB1kiB31HcDYG68=;
	b=FakwL3aLIVJIjI2fLz5u2JvtGGx/HL5uJZbNFhlaofdXirntFAiegO63NQ9gJNM2Clc4b+
	5RKbjtLxpgsDxUD+UNQFk+g23mW1wbz0m9BMTHgrBH/vwpZfi0AdqLGQSJvIxNIAbW28yE
	elVfmOUbP2KBykLrqd/DEH68uTaORPs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ik8r2kWH;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289257; a=rsa-sha256;
	cv=none;
	b=qac6zd+lOPiuY6y8mxqKQ7Zs2r2+phZbKVe4IYm9X1/BVZFA4vtVvdf3qDd10nauPXrm8M
	+/6tNtW9PR6OApF/ih6R7pC7f5DeQCN89ATdhAkdwfNLg7nS8uILU7+0fTCxvjohbRXeQF
	y4n9Xok7lhFfQH3zbqr/njKFJYi91Fk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NwVqkzhkrdkV2AHWI0B8Z//Qg+XaJB1kiB31HcDYG68=; b=Ik8r2kWHczdta/uHFI6arjJ/fs
	Nuxve6+zYFQbMfUKTwu96aIJ4bsaeE+6DUs44cnubs5qsxKw0aaAWtMR0RHAAFTSPt+KdvWwU5s6B
	gnf+YgRFfElKUeUymHTUeVN8Vynvnt13z0GRYwsqZbu0FaP3v5XKzANik0nY4Gu6oJW7Fo04gHXCd
	DN5h4lZkinXbZtGOmbw0HCC0Vw3FPiGZ6SDDwlOGRQu7H4L0OGaA82V8zYj66iPDt03r1pfQPiRrU
	Lary9QMc44z5C8lN3kzxld/zd1Ypydi8z59mKk300kVFrVi+gd906D4rfRDAU3KMMjgfyX5Siv24Q
	IDUUEwWw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-2iBW;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 22/40] mm: page_alloc: add CONFIG_DEBUG_VM sanity checks for SPB counters
Date: Wed, 20 May 2026 10:59:28 -0400
Message-ID: <20260520150018.2491267-23-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D097020007
X-Rspamd-Server: rspam06
X-Stat-Signature: zh3thji3srm3fapqrzekzut5zbzjo1wa
X-HE-Tag: 1779289257-677037
X-HE-Meta: U2FsdGVkX1859rAp0Amf5JJj7DFRILgfNuiqH1nAzmstTXh98r8UKhUbrgjbmvWd+KFLXhxm3Y5uouwZWfDRxsbVUjK9cpMwQnlFj07GwRGkub0qF47h5WR6WdYZg4maXYiZePKCRV/3kK2QVmeTa57gqtrMu9CXhCqNTS71j7sLMHW4S6NBi2JKPazl511G8boGFBcCvY1eLKVfgN9fWxatKTSS/aQHvGQUOgjwPLhrvycJbpPM7ld+jEjPyfFXMp3bIirMRaI51uhfQ08QyPErKyfyM7Hngrjos0SJEci0gn/uV922Me+jtDHkFQR7VFf9hciVayHlkNW1CZfhxoql+gZ+omKVkapaO+ne7lIliitXIU4avPXyFiIy32ak4eiq5x+EuLrjSw9tSb0ay4Xr6bpHZ6v7mAwjToEsNvF+TARqs80Pc9Jr410AuRpqdVFXR5zH1XsTpGw6u2XuSVvOOaG3DcGacFuO1rkqet3bUGH94MZ7vM/wHmI6IMUABjS480ELzYSM9zldJbj48JwbIYK7J7AjajtbU0LI7hnkm8fP+MpP9+JV6FsKwgKB+DgEidRddGLq/14KZ6Y0rg6uyDs0PPBcOHw3CXxmgQEcw9Nv0gcbBCdac1YmOgjfw62qNb7McY7OnzI4BUfHDTsIiMeK/x1CFM0rG0W/F+S2DWhJGdJgnOyLs9VOcQCfT/ZvHo5c5xR3jTZ5+o2oZ56dU5qbZrVxpQr6WorS8bvM31dMRoW/Rp6HWolxpnckO8gNm5+ovR+eALOhjNCZY3xT+6XupFHIsJ5IEqjRnTh7TKIyu4xePQTLzvw7lEiDA+eU3CYswQ6h4XPbWb4rE9CINSccBFp8PQZdt0i7UYAhkqWbNVPl2bJbdDqIo2lvxb/G7tBU/PE4vAd/JJbCmerNCny6M2TaBTm8edSlMvDoyGsSjiA7i+bSTjcDBD/I0pkzo1EoMKrWLyl1xfB
 YQEKN3lZ
 AgLBDrakqGtk8FLPL0OrWLwcH4OMBVKJdUmGtBARrqPJl4zDL4RDNs4SwlQbdkOpDmZK0PU92ckZUGGA1hvXhUnKBF72hCOv1II/o5yQpaT9BPyluKMyeVFAcGqh6sNNRaWx43XZkhBYt/1+zAaUKI8JBnzEy5H/Pwp3zaiq+aaRC2o/TIqO8uwkYXP15zgPDWfzmqk899bC2Eu8ShLcfaRABfJg/SDNvbMZ4PY9n5tB7uHMZdZNBAbOyOV1dsm+Z4uvdo/3cs6LC5b92yzzcEkq0o81cj3Q+abeCka8iEgkST/97AXR3EPR8iAnqollgDuvk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add spb_debug_check() and call it after every site that mutates the
per-superpageblock type counters (nr_free / nr_unmovable / nr_reclaimable
/ nr_movable). Each counter must be <= total_pageblocks; a violation
indicates that a PB_has_<mt> bit transition was missed by one of the
allocation, free, claim, or evacuation paths and the counter has drifted
out of sync with the bits.

VM_WARN_ONCE keeps the production cost zero (CONFIG_DEBUG_VM only) while
giving us a single place to catch counter drift early during stress
testing instead of debugging it from a much later misaccounting symptom.

Relax three pre-existing VM_WARN_ONCE checks in __add_to_free_list,
move_to_free_list, and __del_page_from_free_list so they no longer warn
for MIGRATE_ISOLATE / MIGRATE_CMA pageblocks. Those legitimately carry
stale per-type counters from the isolation/un-isolation flow, and the
warnings would fire spuriously once spb_debug_check() exposes that path
under load.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8027412da866..e267390a5948 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -477,6 +477,32 @@ static inline int migratetype_to_has_bit(int migratetype)
 	}
 }
 
+#ifdef CONFIG_DEBUG_VM
+static void spb_debug_check(struct superpageblock *sb, const char *caller)
+{
+	u16 total = sb->total_pageblocks;
+
+	VM_WARN_ONCE(sb->nr_free > total,
+		     "%s: nr_free %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_free, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+	VM_WARN_ONCE(sb->nr_unmovable > total,
+		     "%s: nr_unmovable %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_unmovable, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+	VM_WARN_ONCE(sb->nr_reclaimable > total,
+		     "%s: nr_reclaimable %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_reclaimable, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+	VM_WARN_ONCE(sb->nr_movable > total,
+		     "%s: nr_movable %u > total %u (zone=%s sb=%lu)\n",
+		     caller, sb->nr_movable, total, sb->zone->name,
+		     (unsigned long)(sb - sb->zone->superpageblocks));
+}
+#else
+static inline void spb_debug_check(struct superpageblock *sb, const char *caller) {}
+#endif
+
 /*
  * __spb_set_has_type - set PB_has_* and increment type counter
  *
@@ -508,6 +534,7 @@ static void __spb_set_has_type(struct page *page, int migratetype)
 			sb->nr_movable++;
 			break;
 		}
+		spb_debug_check(sb, "__spb_set_has_type");
 	}
 }
 
@@ -545,6 +572,7 @@ static void __spb_clear_has_type(struct page *page, int migratetype)
 				sb->nr_movable--;
 			break;
 		}
+		spb_debug_check(sb, "__spb_clear_has_type");
 	}
 }
 
@@ -778,6 +806,7 @@ static void superpageblock_pb_now_free(struct page *page)
 		return;
 
 	sb->nr_free++;
+	spb_debug_check(sb, "pb_now_free");
 
 	spb_update_list(sb);
 }
@@ -800,6 +829,7 @@ static void superpageblock_pb_now_used(struct page *page)
 
 	if (sb->nr_free)
 		sb->nr_free--;
+	spb_debug_check(sb, "pb_now_used");
 
 	spb_update_list(sb);
 }
@@ -1265,7 +1295,9 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype &&
+		     !is_migrate_isolate(get_pageblock_migratetype(page)) &&
+		     !is_migrate_cma(get_pageblock_migratetype(page)),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -1299,7 +1331,8 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 	int nr_pages = 1 << order;
 
 	/* Free page moving can fail, so it happens before the type update */
-	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt &&
+		     !is_migrate_cma(get_pageblock_migratetype(page)),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), old_mt, nr_pages);
 
@@ -1324,7 +1357,9 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	struct free_area *area = pfn_sb_free_area(zone, pfn, order, &sb);
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype &&
+		     !is_migrate_isolate(get_pageblock_migratetype(page)) &&
+		     !is_migrate_cma(get_pageblock_migratetype(page)),
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
-- 
2.54.0


