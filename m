Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59C0CCA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49CC06B00A0; Fri,  2 Oct 2026 20:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CE46B00A1; Fri,  2 Oct 2026 20:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314E56B00A2; Fri,  2 Oct 2026 20:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF3956B00A0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76ACC1C3C0B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:58 +0000 (UTC)
X-FDA: 85279508076.02.2CDE657
Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C22640005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989196;
	b=G3ym5yWSWPmGAM+FzHEHOo8NuwIZrYVuSuTSHZQI+kAWAXXZ2DRkiiyHqEhDyzDOvlK9zp
	Ya4jfHDFAHxispanpsNa+LXv+AFgeFZFWl+Hgej7kuyRYmik5IXk3b09Q2ejJTgPGlSCI0
	m06zsEDxIFFjwvp596oSDA8Bw2A5Wic=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.216 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cshInsm79iEdsrgHbfAOTrQPUHoSkeiha9zda4sR3+Y=;
	b=nlqXXCYUiYVM0L683n/K4YxMGKLr6f5dnWWw6aF7QbwX+DnmitS5EWox6mkqxcK0qwpvGD
	caGF/NQ5WEKB/oolhzd5D+zfg/ligQPyYg5Sci/zvA8n/sXVTIDc5yxO2TSQm2eh9UdGJ+
	OqAuGVjaiQpsFmMBbBlgBa+oVNxT5R8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 3ae090c413809f34;
	Sat, 03 Oct 2026 00:59:55 +0000
X-Mizu-Trace-ID: 3ae090c413809f34
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 06/12] mm, swap: fall back to disk when zswap refuses an xswap page
Date: Sat,  3 Oct 2026 08:58:54 +0800
Message-ID: <20261003005900.909710-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 3fk5xdwccswynmnerm6tboe94z9o8gax
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C22640005
X-HE-Tag: 1790989196-231130
X-HE-Meta: U2FsdGVkX18Yhpvbo9M6mixOBS9oIgo1dUiwhP3nf8UA4vkl6kfV/PT1xnlIUfVltvl86WFWEh/YpMai8D/V9B91jklMJoVGEu0E8OG5gO1rr7WF3B6lsoIcND0tDYlflqEg5h5sGLmu0GF04XB1S7DGwPh0fGHJru3y54gYl8S1MGbOQemKZGvop2j7Ky33xw15rDBRfOAVF5GhAGVdClkWebgT7uX3/X/pupeWNVCNgSi/qRfKNtexUlqzOiBUDtXbTas8dVVSkmUKIPttvUu4riUUgWmDoEUUu8xViOP/YsxQtjZ1rOFZ1+DS01cC4MoaEJ5wrn9EPSdrYUM0LateynAqaS9tv7BdKcPOpvPr8GCovW5eixPaIn7ZW6BLzfadsIqa7+7m9MDYZ4CemvPHk47lPPGWvztIzS8PhH4zoOqH/mewCrjKWz+ujV2Pq8jvg/pYVcjQHVTyAN+/GlWaQ6UOJS2Zv0Z6lafCX//L53OIbC6yG/yB3+SjsWS4Zbc3RvZmyMp9/gKmUlAWKcft5nQ8kZCEjxKjg33w/HoCJRPyq2zWq59hHQ9RQUnNgqiYT1DwJsdDYUq9rfTAC9oF6DxJGxQGdAGBGUmLGyrv/GxOX/EUde+Oo8jZWU9nyT9YY4p+BF1DStP5mtZT3Do0q1eZBWsX/qf0KDBU3Oh0t2Fsye+JW5d/JMpAdF6iWbmkV4x3aKdajBtBVIarlc8cuZrnou3+o16ZIWAicFEBxM3gpVyEUBOu1QxwKXG3lruoSuJRYRyOYjx7jp5z8jpXw/JNmjwg19DuX+gFqExyR0PmAmUEmZ3e8Gc4mic+H7fryvM/nURPMHVhEtYhB/QpM3YnFepdmkEWvhPP6wWI9RL0u25z2qG2dQxjyZm2ZI66F7+qqhh7JTSV0BhlrlPgrP5eWWVOj7nIRLVZIi2xS8NEqQt7aQlr2qL7fA4o0vSO8T4Rk65mAzjbLTH
 ZuMRHc+l
 MDkM8ofqvdw4snFpKk3D90+18EM3xAKzBIarQsm2UNijMIfMIVORjUwFiUTQs3FnXZ8Nb6+PCL4gHwR/kfNStknyposVriI8J/eC3irotKLd1J8DEUFDoqsAUqni3FfhiG1F4trW+n7vKSCA7srF/inqCWiGWLk9VjsN3WkLVSzNPPXGsBzigJP8uTYx0YNcWk6P3POvAlxEHOui5JxlVROUg8ZgCMM9d+ivrTnTpwtmT8tVgMyS56Ij67LfvvDSPq3yJ01YlXP27z7XyO0X3YX2ktOU5Bv0S30ErbQHiGK0Nm3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store() can refuse a page if the pool may be at its limit, or
the page may not compress well enough. For an xswap device there was
no way to store it, so swap_writeout() put the page back on the LRU.
Under memory pressure that turns into a livelock: reclaim keeps picking
the same page and the pool keeps refusing it.

Now that xswap slots have a physical backend, write the page out
instead. If no backend can be reserved, keep the old behaviour.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/page_io.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 6dc90182f761..7a7b7eecb2a8 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -253,8 +253,18 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 * yet, so look the device up from the entry.
 	 */
 	if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP)) {
-		folio_mark_dirty(folio);
-		return AOP_WRITEPAGE_ACTIVATE;
+		swp_entry_t entry = folio->swap;
+		swp_entry_t phys;
+
+		/* The pool refused it: fall back to a real swap device. */
+		phys = xswap_backend_alloc(entry);
+		if (!phys.val) {
+			folio_mark_dirty(folio);
+			return AOP_WRITEPAGE_ACTIVATE;
+		}
+
+		__swap_writeout(ctx, folio, phys);
+		return 0;
 	}
 
 	__swap_writeout(ctx, folio, folio->swap);
-- 
2.54.0


