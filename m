Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 512411073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A0F6B008C; Wed,  8 Apr 2026 09:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB696B0092; Wed,  8 Apr 2026 09:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D046B0093; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1B1B6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CDE8B5C8C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:43 +0000 (UTC)
X-FDA: 84635481126.03.9990A65
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id C4A7C1C0012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=g1E2+sOR;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LpytnOc5QnLYuuG5kgtGtzHAwZXxVYcBS5MJBOR4yE=;
	b=YPCvMgUJl5AUzB/11CNZXqkDIffUccD3KT/sk0pn+T97vVwPep6F0UYLJMFpis8T3cVxyo
	UUlAeILICx07BmspjaFNIQSSAuyeKfTkw6nrtxVB8O3cF1bOkxOfgHji61xgOsqeV4oKQY
	EHkW8+d6p6pUo/oxaq6+QMR/W8KFl1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655222; a=rsa-sha256;
	cv=none;
	b=d1GzuNO95QSKZfkZ4clBvV9LPXOo1odq6nsWmFngD9XFxSMXJcxv42lpie/MkBRGfVVXRD
	1/NUzbN7IlES11XsPEK0jY9zuKOiExhyrR+Tmt4DZQqXyDf/OoXJc3754cFJHxRKkUkm/M
	VI7Q3ZxqQpwLSKcYBJG/ZR8nBtpYDV0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=g1E2+sOR;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 96308BE719;
	Wed, 08 Apr 2026 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655219;
	bh=3LpytnOc5QnLYuuG5kgtGtzHAwZXxVYcBS5MJBOR4yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1E2+sORFrsWyXcMpW/xI3OK8vS/IL7O6mqDUHmGeV4tpEHh854ICn7bayGZmS2B2
	 65TJbXtCEP/a8dQaSsPWTAa8++gMYq9P+cO6U/Gvjh5sZEz4yhtgMFWeXmCT1Tzzvc
	 4iqbeo1eTBKBIK5n3keQ1iP3gxD9E7WEjLutBnE4=
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
Subject: [RESEND PATCH v2 4/8] mm: use zone lock guard in set_migratetype_isolate()
Date: Wed,  8 Apr 2026 13:33:19 +0000
Message-ID: <266d19019bdbfef4b26e7b98e94bb536c6cae398.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4A7C1C0012
X-Stat-Signature: epok5rfsyhac16zgwj7bxbybr1b9j1e1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775655221-432425
X-HE-Meta: U2FsdGVkX1+WlZP9ccofIU2R4GjLhNTmzHRLbO8v5NFtx092KpqSoibT4M34MfjFlke4ksDAepf4n1075n4ieLvHjVnfUKgz8VuGYz4WyVhx17Gtd5BFBsYLjMGgX6Y/e7sQjpTunnm3IV14+ffsE2iiFWEvaA9Ux0zM5aaVUMyHOQLZq6z/3LrG2RabELnI8N2ytjRHZ0pb9Nb7aGZTWqNN+6kiTF47Pc0A+QJXjnJTfAnXOzFz/9opQt2YfY1aRWQOKdV3xYOo5uwPQln+0d301UT+Y9D4HNfkKzR+XYHs4uBiwPTtLocfBtfXVxEPHlLGQmo9BWcDsQcWKUxjrWCx1IA7DY6+tiURzO79xb0klGA7zrY3H9Py5tKGfGO+GOGm6tBEhI3ievNB8xZ56mO+vEXyRIaHPd9OOinZndzpqbMBj6hqVd2pvu2EXrjt78Un+42DOolC4ySelqWRyFcKelstqd665yIigXJCvmbJDoGyxPAzuJvwTQ/f8yEGYOllwCHoq2Z+2RS4uGvhCNbI8DSyL358RMrFRDbUE4XW4TLovYapH8gG8VQ4gyLsGgwm7tFWs9oEZb+jP2XoH4OG4C8Y0tQaEyoQgUoxPh4FIg9lnamfDxWAzddXtmpYKX9/dPkzx35DcXp28hfpfAd+FhOcIRYqAuOUka5siBcX7tY5jcsk+EIqzgdGa1RDwv4oZOCRe1aMeE7FqBOzsdy0Xq8sKlpoc+yId6HzN/Ww/c518ZI+kiZcZXWl/L+JvejdxMnHruAtqrwGab6BrCH9+A9Gfzt5HAthyU5eEyWUv9OVQkV8rxxMigW/x88rTelX65xPWrST8frdoyBmvgOY37O0KYLa9lW2P0/bS1rdKnek2MhmVl7TXZbgcmHRlZBKqqXXtfuL6Ziu8RvlZzCSc3fyKgbKip3uFSZORpmnn0eay/E6CgHTQghT8l+MDCrZ0uaKDZoizOScohY
 u9RzxHEP
 CSsYCBp3sxZQ1wQkceNo6iIffhmvhC3GMoWtZRRgaej5M4DfaIJdaJ7QchaB46kEJq23xvah3XXUNkLfgJdWwAjn2GLgazwIcqtafS4i4xJd2/aeU5YnkHqk1gfBTlbI5ADqo24o+Q0LoS+JEt1htK/a68fsP0CJqJiGw+3pVp0SVxLerzOa5loAOourbVZSlpmQlMVvZdYeWZqXCKO/40MZyLYs5PYVMmzIkRwo5F+M0z1+1kOSow/0qM7JTM38pPGmnd8HpKjkHHcy5M1EbgqilWGO7y0STdw2tvxTfR9f5lAsQfBysJiBiOIOiqaNIMhajyTBBj8JYg3MuOxZjhWaSmz2dUmvyO233
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


