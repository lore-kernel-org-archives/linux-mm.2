Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3F0FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8ADD6B0099; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E143A6B009D; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB966B009F; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE8B36B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA738401D9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:32 +0000 (UTC)
X-FDA: 84711456144.23.2213640
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8E0114001D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=pvdDAmKU;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rMpxXZ2kmfsNrHNEchsSi+oQqPx6tnYYZ6CyNQq+xQ=;
	b=BDprx+bzK0JmRfEMHZ8kpIs+GAR3/PJlPrDEyVcchW5pcY9p/YU+QKbLkYtehdMEk6dPJ3
	h4rudk3NZkPe4ws2VPYcjjzk/mmPd/dk/AFPQB9kM0iNU5exlPCmurChg8xWDF6kW0EMHY
	yhPylEoqDxPI7elx4MgSaBmRt8KzoVE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=pvdDAmKU;
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464151; a=rsa-sha256;
	cv=none;
	b=iEqk/46pFwbx6DMpww1qaLrcTORlwLP8jL755/56rLnt1GI02P3w7SoAV7iPx/QFBiHVIX
	6BBg41VSwonvHA5E819ClTjMalr+FXQft/jn7AmMArE+Ak5hcBCFx7CUIMhJUVyeaV4Q/B
	VGFT0Fu07HMtAhMTDPPy0QIQAVrFt1I=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 32D86C7A88;
	Wed, 29 Apr 2026 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464147;
	bh=1rMpxXZ2kmfsNrHNEchsSi+oQqPx6tnYYZ6CyNQq+xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvdDAmKUu/YCvsyoE1HRsKfb/N26oCI7ZJNxFesIJIg8E/1zCqe3TywNd2UGc12XJ
	 +2ljZJlFbPgMk+ub69xTw+lnniU/Liut8L95hOFVXr34L6pHb2lj7hDowDdC9IXjIR
	 lFAFAeJsvKENstEEWyxLWYYsNhcvDfN8AOxi+K+I=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 4/8] mm: use zone lock guard in set_migratetype_isolate()
Date: Wed, 29 Apr 2026 12:02:09 +0000
Message-ID: <6883351ad7f74d20875fff30e0e3214a089cea97.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5xzcgdeq1yszxxgcs3gdnr8ck576maz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8E0114001D
X-Rspam-User: 
X-HE-Tag: 1777464150-571950
X-HE-Meta: U2FsdGVkX18RlKDslVV3tCW6lt1SgjdBAlyGESS0brprbcIu/i+HrdH5Wkd1OXRlrwtx/na3beb0+QFSPbNJcFYGv8d/fpfvBHbU+42G1Dps94ku1VFqz6acRK2OhP/bQ0bJe7FMJnUfIegPwfXPuMhe/7Qhh6tj2QZSAfYb/SHpuwHfl4BO/4V9ZojHEuNQkbBakgcu2viFtvWPcKxpU6D5vY38NqZ2pul3BV68LT0N6as1KA+5sg2MKN2thNI3dVa6EtHlZK5tYHMWZhuv0C+LMd6xkityU8c+OfgcntXeMUfNSoyaMC7elg42TAyY2HMxDziP43yBR5Qi039Nfki/ZPVouD0W3Lk9SuTgklBxWhBr4grHsOmyiuJdRi+T8ZdWnGhH72xEpc/4qKWA68QkW6jG+WRueSbai6Pz2JxUwlQRN3weiww/z+REmFdoWzL7w08aNOFr7/ZbJkjXbMI994/PAvAXfbITay/QdNJu8j5BMsKS3/4t1FPdJ6gEy/cOAu+segZQZZhYfHF7GB3oBxUMvp7Njlg/vkS1sBgXBTjKPOWEmQN2nJHIQp+aQHIvGLyE3g7cRz6u+HiMUR0mpvD52Up3aR3HswWWU1U1o29SmCaMPK6lzpoN6m/JmuPbH2PfsRbMpe/NcV5F/c/Hc50S7ME+Tmj/8xiQcHXi7xglLzq35tJyA4BNS7Oll40J1kQWAQMGhykTuUJYIq1uUveDmM1OyntVmGeAKPwROMLU8oXOLalUGUb0beOpqF08EAc4gobs9jpRR6dak6lxyfOhc0iV9CWfuqEgK6c2FtiYw1mlYNQQ9pgtt3Ts5J0JICskLPyyjvlczVYS/6hOZGg3GYVJKY6D2iWK8UOiY/xVhSCE0vxbN8ZJbVHBG/CDkdvCvla0vsloItRYPfsmAnk/ZfQdXigEFmEgDcEWG2c9GF9d+fbuA9Pfpa/5kYTDKF3VnmgzfX1TlWn
 vQXeSSBG
 TIPN4NsXXRHAyVWGun1cZvdxl7O9+w3oBkCESkTSBeI1fuAqOSy9p1fwItPMqtj6Smi87+gBGiis5hUX7TbjxJFrY5yevF0mzO2M9TyX79FhUYwX+xfqhIf69hDVvO9GQ8ayvaGXEPapHrctfTWlQvzKgpepeM4raEmf6mT/OW+OSg2LjAmoryC8xZ77U68DmEL//mAcYkSW4zVBENmIx0bF8hslVONWMOnofXI52wht6FxXJ56RhiKdBEYOdwUnPVB3zLZmFeqVHT5TYz5WyDyVj9q8MBHiDzll+HS2CkHSp7FbtQqQty1t/ONRxkXgjakPTSEp3xaTBzUlfLCM3FwY9sOMotc8f+DzyJEHeb0U00LDjgC7IGAzYes39hBxN2FHJl4vztL351yQ1+78xQdk3gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave scoped lock guard in set_migratetype_isolate() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup. The scoped variant is used to keep dump_page() outside the
locked section to avoid a lockdep splat.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_isolation.c | 60 ++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 9d606052dd80..7a9d631945a3 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -167,48 +167,40 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
-	unsigned long flags;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
 	if (PageUnaccepted(page))
 		accept_page(page);
 
-	spin_lock_irqsave(&zone->lock, flags);
-
-	/*
-	 * We assume the caller intended to SET migrate type to isolate.
-	 * If it is already set, then someone else must have raced and
-	 * set it before us.
-	 */
-	if (is_migrate_isolate_page(page)) {
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return -EBUSY;
-	}
-
-	/*
-	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
-	 *
-	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
-	 */
-	check_unmovable_start = max(page_to_pfn(page), start_pfn);
-	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
-				  end_pfn);
-
-	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
-			mode);
-	if (!unmovable) {
-		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
-			spin_unlock_irqrestore(&zone->lock, flags);
+	scoped_guard(spinlock_irqsave, &zone->lock) {
+		/*
+		 * We assume the caller intended to SET migrate type to
+		 * isolate. If it is already set, then someone else must have
+		 * raced and set it before us.
+		 */
+		if (is_migrate_isolate_page(page))
 			return -EBUSY;
+
+		/*
+		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
+		 * itself. We just check MOVABLE pages.
+		 *
+		 * Pass the intersection of [start_pfn, end_pfn) and the page's
+		 * pageblock to avoid redundant checks.
+		 */
+		check_unmovable_start = max(page_to_pfn(page), start_pfn);
+		check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
+					  end_pfn);
+
+		unmovable = has_unmovable_pages(check_unmovable_start,
+				check_unmovable_end, mode);
+		if (!unmovable) {
+			if (!pageblock_isolate_and_move_free_pages(zone, page))
+				return -EBUSY;
+			zone->nr_isolate_pageblock++;
+			return 0;
 		}
-		zone->nr_isolate_pageblock++;
-		spin_unlock_irqrestore(&zone->lock, flags);
-		return 0;
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
 		 * printk() with zone->lock held will likely trigger a
-- 
2.52.0


