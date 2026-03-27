Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7518510F284A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42E86B009D; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19FA6B009E; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D4C6B009F; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 968726B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 636ECBE5EB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:10 +0000 (UTC)
X-FDA: 84592342380.19.57BD324
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E55E80012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=emO7SczW;
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LpytnOc5QnLYuuG5kgtGtzHAwZXxVYcBS5MJBOR4yE=;
	b=ZdNdFpDpRJ7IXrRA8Yo1pNnnNv2IUzJd4fO/PM6k9R6Zr0oAJ5An0Q9J/8U2VoSZz/z6//
	xbhbjDGAz/WA3WXnCcVxpI01ieb6WJTr+YUGGWrcjfyerlp4pHoKLo2rgys5CRYHZNArZW
	owo8V8EAyY0htjn6bc22xtfDfGpPnaY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=emO7SczW;
	spf=pass (imf02.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628108; a=rsa-sha256;
	cv=none;
	b=UGIe/PZrvLndFvgEdY+dfPgCO/eSVIWn4kwINgS2VSrRKSF8z9SSdXOPSuFF7zOSNqdlMQ
	5v4mSazn6YYrcWxKBTjBykd2XgPROHRjVSMYBSCwTj1y14xlOiAOo70Dl4tGTH3dj1bEgJ
	bOpzxonv4woz8Ot/ARjLk8q5cT3rKms=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A93BBBDFFC;
	Fri, 27 Mar 2026 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628106;
	bh=3LpytnOc5QnLYuuG5kgtGtzHAwZXxVYcBS5MJBOR4yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emO7SczW8t/0nVeRik7ewArnH8FGmtAuYwyu6Nq69WiY29mHcbRKWx1iBuBmwEnEv
	 uRZTERD4v1Vr89VdVX4yzVQ47pXOK3NDR5VbpbCG2bJ+kgY0hW8EnmlndY3iH8p6Mv
	 pNrDcraxnpxxrLoUDfdp0QkwJNIavds/QsR/jx4I=
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
Subject: [PATCH v2 4/8] mm: use zone lock guard in set_migratetype_isolate()
Date: Fri, 27 Mar 2026 16:14:44 +0000
Message-ID: <80377691336ce978dbfcac17ebaa6de9837a0b8f.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E55E80012
X-Stat-Signature: yacbz5wjgjrz5jzbbsnhpis48zjz6tdw
X-Rspam-User: 
X-HE-Tag: 1774628108-454669
X-HE-Meta: U2FsdGVkX1+dEwQ+3wNq6YBHASxWVHgz2PdecNZS5gM2wqqU4Jf52YdWcWWtNleH9t3jkhl9UQ1q6ZwrdJcyR4B9su9iYrhaLps6L8kGPHkBjMLvAp7e2g0ctZ3wzXDa/UKCZqu0SeAitAopy4wDbhfx3xc9drUJk1B4aX3if3JqUFbL+ugtLia50yKIpAto/16fk9ig+4i2pfn+H5nMcCXalSyfQ6mPdf8L9FjH9Jfg6juj/rKVqlXjHEB4QDJw8DLqCC/5z9pk+E4bX3q+5pFcW9Wr4w/T4AZuRN0OeDCihn+/0f7jaiW6Y0T0HlHumTS2I0GHlyFjERxJsqxJg+CdW1JWLh9RQRK/CAfBmAXjCX1o0r5MQoLgLw5UXVIpZMorq4wvh0Bh+lauOMjCMtFjgi0dF1StZjRXWLHyYMJNrnb3f3pzR7RV8ExFL12ddVhUR2KOZDfpldNhJJo1tXALhQs3uw/qbX5+IljqVCLw5fYWH93tFdKoDWjj73E+KPM789Y9J4x63cW1H8cNhMz9hAhFJdP4o2UIevDWeuJ6rjK1LhIE0LTPbXq5sZcJTP/gd9nVh8DtMHu/SopfPGDppavbgjDiwv1uqYCV1IJIpClJVMRj2MpxZZw2iiS6PtB+4eJLsv2FtSo4FjTO8W/W9JIC6BvP58k/m0o5oxZD5qAr6ATw4uHMETv9wOB0vXB4Vn3IEIcLIXcdyi2pAYnK+45+LayLYyZaLvw4YkETZNCNW8rz7EXRMwKAVbTqHPD8td6J3xDsjfr2qsGP44i9esh2pO8v2pZQmdGUUEK1cdUTb9aJoW1zHEIGilu6js77DJ0F0gScfG5KweMtWWL7vIgZXl2Ht/Zu0x+Pe6jhxAuULFbfPtyiTXuXZFobiD2PsZKCC9qtvkqpyl3Xr4SiKHDDyZJgKV0xWddck70xYG3I2BTg4dtKbiTo5QD8EeMD54vtbtfXZvmgqNo
 9FPHKIGN
 OY/BYMrTrrd6a/DgVLnOQ+xJIg92Hk14E8cBkqtSGActwlbAja0yK1w5SEwhNF+Tyr04rfYML2VIiGgei/QP1O6Q1uqLDm6Ptavi5uIIaCIQnYHDuy00/NxQUFmPd3Md9kX5JBizWPPgTPsVyt0xCCUQMFG7lWNj8g+Ok1qq0a/8V+WRSrbI4z1Kiypy+L8bHBouTsTa4P5HE+fsnOOX+bji50L6qx0PAcdydnrbnw8u32egxN8A32q4K8K4QKYJ7JY1wUE9q2ST8h1SP4K8ri1KwC+pXOQ5KloNy4VndJdlhzVVxNzzCR9V2ta5i9XwDJWXyqnBRQahKj00Q3LA9IF91RXUcHKDF+0d7
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


