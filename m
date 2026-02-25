Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0AB9FD3764
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456146B008C; Wed, 25 Feb 2026 09:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E526B0096; Wed, 25 Feb 2026 09:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231676B0098; Wed, 25 Feb 2026 09:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2B7C6B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA9B01604E6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:18 +0000 (UTC)
X-FDA: 84483249396.13.4AE9FA4
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf02.hostedemail.com (Postfix) with ESMTP id E14F080010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kMtaTYHl;
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772030657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTtbvJ++bwhhe7M/mQwQ3ureU9ZQDF6UDHCC9y1Yr2g=;
	b=FNhp9m502YgESSkkfa9JgPBHf4zKz8zxVl3i6GtvpFLY9yvSa4CXIUHa2yLlB0QfR+wHgn
	3S4rDIJlMbeiMzvaWFOZuczZxFppM61xfm2Woi/cSCt2uY1tE/cWHol9dWauVYLfHgaqkM
	GMij+c4JeEuv16iOQmbvDMATGl8XB0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772030657; a=rsa-sha256;
	cv=none;
	b=Z3hMJc5gxk+TS/H9FAiw39ivlDkl7/dS8FC0gqz8BRb+2a2ySJB+VTj7Zry9LCDcn/gZzr
	zz9C0EcwPGBHcu+m7okbFJWUB8Sh27OmCDMvb64RlLVsAEITGUSWEAs7eub9rjNM3CElWA
	+/VLjal/7m9OvwU3PdDadqXoW+ZXfbc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kMtaTYHl;
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E0213B2C2F;
	Wed, 25 Feb 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772030655;
	bh=vTtbvJ++bwhhe7M/mQwQ3ureU9ZQDF6UDHCC9y1Yr2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMtaTYHlxSqZitW5RYngNMzxYFgLX8N2ZTzu2pqsy0AaCh3VwKjW3FD21ZoWAhcBE
	 eZdbnxruMRgCzzoj47HlfY0hN3RyRrxw7fMObHfoN3GbBxXyjTF19QWm0iCcnBDmsD
	 x22IVfyoUiMBmZ2EyVhIqlv8byVNiExkhd5GzFjQ=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 3/4] mm: convert compaction to zone lock wrappers
Date: Wed, 25 Feb 2026 14:43:05 +0000
Message-ID: <9710c3448c6c984164c93d7c6c0283e06ff987bf.1772030186.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772030186.git.d@ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1obamda3remihdkiu4aqkyn645fe8abx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E14F080010
X-HE-Tag: 1772030656-988561
X-HE-Meta: U2FsdGVkX1/uz9FrsGT1OPWuc1V1Ra+uIqxjf0m/8kOWZeZTvtgYeXMRXyy/W+Aocv5q30CVaOUTxcHPNVxO2l53RWXmgRMvkopSb+vh4cUZ3D6qqeh8VpnirtKqFh3LxsqFaoew+FrgZwNnD95+iytNwNZ7yiN5sQn5RBv12v5vGXHkE9hJSZojsdAPv76tOTX+ACSypJqVbtm78/t4Z//GvetiSU4ZW46fH8ipVPsxg+RY7s9cG1uGu6MbJ59TfPyLFPeOtDA3JszYRFjVxXmUfgT3z/9xTld6EknT5bXrJhx1TZAHhfx+UuRCDc45e3D5giqbXmVG8fkR6VqSvSLs00nNdtTDvm2FkLe/gqTqaDQZbBsD0prr8UMDUdtgBayN0Q8EZgVaQhbaEUfz0O6D7cjCN8IbwwFJ7YlgrnJUw7HRWiECtDKCgbahGmaBCKpIxYG5pFOZdvrtlrFjh0v5G33ZEF3vlBKM0sUQj1QpJtj/2Rmy6lUU1WBrGAchBMl4qOmgXDf0LrY4sWs9Zjzvaq/C1ru3OfTQceiusLiaw7F+Z5/zQX4XyRFrqzM9/Ex297vYcQG6UfT5ytsFdkoggKNe1u10FgCFKW2zT5LKSzEQT+iTwtFbETw78tn3j6dOMTz0bJlOTbfckePWqV3pileFdaSvKHWVejW8+eKriJTKfgurKwV6dB6QZnIvHNVOPCiiLmCfv/4oIBlbdVG1Z5ATDN8sqcy/rkAAKLlQ+1OiPPg5i6n8RhcrY+/9JOqGsxsj/KnqOA8r9l6unL16K/QKcrteIO3WaN/E8OdX7iM1KOTGMSVnJIeqwDlYiMaXzxdmrw/SSXLW+L5hUfbgxxqhf/PR2I5MzIGl8N1YT7v5Ahrly5QkdE1T00gIktwBZorQ3exq1FBb7enVl6NoNm6EtbPwZDPfGhHz9AU4TWRkAR5KP0QTPiX50/EatyVZzroSAlO8Pi8pHk/
 2R5c6aqK
 DqN4ZqRd1p+WBHP3qq0T1eArlYRQgFJLR2fXVsHIvo+eH7BJ2/z7HATL+oF3xePYUPo1/zqq/JV+ZS0DquSxSoRji7avcIIme+zqX9dUa9IXSbQmRwNQQ0RIvcbYJbHo77sijRyrAUYFTkFKZag57VlohcnbVs74ktsd3EiHFC9CPIMQtpNScMvMXCcBk0GQwOg4O+Mll3OT/N6TQX5r3vT2i7fZaFMnLLV43X7z/CIEh+c6Xb37XIvSdAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compaction uses compact_lock_irqsave(), which currently operates
on a raw spinlock_t pointer so that it can be used for both
zone->lock and lru_lock. Since zone lock operations are now wrapped,
compact_lock_irqsave() can no longer operate directly on a spinlock_t
when the lock belongs to a zone.

Introduce struct compact_lock to abstract the underlying lock type. The
structure carries a lock type enum and a union holding either a zone
pointer or a raw spinlock_t pointer, and dispatches to the appropriate
lock/unlock helper.

No functional change intended.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/compaction.c | 73 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 47b26187a5df..c3b97379a963 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -494,6 +494,53 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
 }
 #endif /* CONFIG_COMPACTION */
 
+enum compact_lock_type {
+	COMPACT_LOCK_ZONE,
+	COMPACT_LOCK_RAW_SPINLOCK,
+};
+
+struct compact_lock {
+	enum compact_lock_type type;
+	union {
+		struct zone *zone;
+		spinlock_t *lock; /* Reference to lru lock */
+	};
+};
+
+static bool compact_do_trylock_irqsave(struct compact_lock lock,
+				       unsigned long *flags)
+{
+	if (lock.type == COMPACT_LOCK_ZONE)
+		return zone_trylock_irqsave(lock.zone, *flags);
+
+	return spin_trylock_irqsave(lock.lock, *flags);
+}
+
+static void compact_do_zone_lock_irqsave(struct zone *zone,
+					 unsigned long *flags)
+__acquires(zone->lock)
+{
+	zone_lock_irqsave(zone, *flags);
+}
+
+static void compact_do_raw_lock_irqsave(spinlock_t *lock,
+					unsigned long *flags)
+__acquires(lock)
+{
+	spin_lock_irqsave(lock, *flags);
+}
+
+static void compact_do_lock_irqsave(struct compact_lock lock,
+				    unsigned long *flags)
+{
+	if (lock.type == COMPACT_LOCK_ZONE) {
+		compact_do_zone_lock_irqsave(lock.zone, flags);
+		return;
+	}
+
+	compact_do_raw_lock_irqsave(lock.lock, flags);
+}
+
 /*
  * Compaction requires the taking of some coarse locks that are potentially
  * very heavily contended. For async compaction, trylock and record if the
@@ -503,19 +550,19 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
  *
  * Always returns true which makes it easier to track lock state in callers.
  */
-static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
-						struct compact_control *cc)
-	__acquires(lock)
+static bool compact_lock_irqsave(struct compact_lock lock,
+				 unsigned long *flags,
+				 struct compact_control *cc)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
-		if (spin_trylock_irqsave(lock, *flags))
+		if (compact_do_trylock_irqsave(lock, flags))
 			return true;
 
 		cc->contended = true;
 	}
 
-	spin_lock_irqsave(lock, *flags);
+	compact_do_lock_irqsave(lock, flags);
 	return true;
 }
 
@@ -531,7 +578,6 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
  * Returns true if compaction should abort due to fatal signal pending.
  * Returns false when compaction can continue.
  */
-
 static bool compact_unlock_should_abort(struct zone *zone,
 					unsigned long flags,
 					bool *locked,
@@ -616,8 +662,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 		/* If we already hold the lock, we can skip some rechecking. */
 		if (!locked) {
-			locked = compact_lock_irqsave(&cc->zone->lock,
-								&flags, cc);
+			struct compact_lock zol = {
+				.type = COMPACT_LOCK_ZONE,
+				.zone = cc->zone,
+			};
+
+			locked = compact_lock_irqsave(zol, &flags, cc);
 
 			/* Recheck this is a buddy page under lock */
 			if (!PageBuddy(page))
@@ -1160,10 +1210,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
+			struct compact_lock zol = {
+				.type = COMPACT_LOCK_RAW_SPINLOCK,
+				.lock = &lruvec->lru_lock,
+			};
+
 			if (locked)
 				unlock_page_lruvec_irqrestore(locked, flags);
 
-			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			compact_lock_irqsave(zol, &flags, cc);
 			locked = lruvec;
 
 			lruvec_memcg_debug(lruvec, folio);
-- 
2.47.3


