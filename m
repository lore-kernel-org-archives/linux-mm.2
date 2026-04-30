Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AE1CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B1F6B008C; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071326B0095; Thu, 30 Apr 2026 16:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52566B0093; Thu, 30 Apr 2026 16:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0DD56B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6974AC0833
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
X-FDA: 84716345952.14.266CB52
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id D185540010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=gXGZwp4K;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQ9ZjVUjJdulwp5CywrMTqgaKr9X/NboSU89d42rSsw=;
	b=tBJxYBynHA2fF98kAiW/L8e2B+Vy1/OUsQUR7raEJlcm+n/CHws7TiZYjbw/oEEogQZEm1
	S00a1RZbKOFYL9MgDfUotL0WxVVgVXxiWWlzvzWH7bf4pZ5dsevJ86pT5o7qdAJJAnWzOH
	osJNUtmAm1+CMRABazxqXaprnOTWk7o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=gXGZwp4K;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580574; a=rsa-sha256;
	cv=none;
	b=houJvHwF/Cs1POQJKCs0f0grTGaMU8yhVkzwDLRfYCUUPeG84AzpYnL8zknD8YC0jcFbpp
	2h8CmsZmcApTRrUwzSUaoSTyYtgCLXUwukbTR6FNQizDm28fBPM0u8tVv1PBLkq/wuDqQu
	B59UyEuabFcODynyZC5RhxskdwbJi0w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LQ9ZjVUjJdulwp5CywrMTqgaKr9X/NboSU89d42rSsw=; b=gXGZwp4K7I2gHlQnT4jTt9SKFK
	JycJ0g3DqjdSmDkP69kIKg+gSdBygfPePlERrKRZHVChoUpU1mWspF3NTBEpLE0ooUvyGz9GXyxdC
	rlqIo0zPWtvv8YH80hIPhhJremXxwa16mR3z4Idr2gdHwXKh7zj4pAkb7u9SU+D78SY/L5bKE59wT
	34E+plZ3XYBNM6f1viBU1P6GoAG3D3c5fQPXdIPFa/491io/kwbnSiv3v1z4oDkvoHL9PyXhGvi0f
	edKOJ47HeUVpfZLCj1b2MFXUSmGlk5Ko+uuh0U3N/wnxXCb7f7sJ3+ZLV8puluHEmk7EEXcaHbIbv
	qcHc/hjw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1R9a;
	Thu, 30 Apr 2026 16:22:41 -0400
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
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 35/45] mm: show_mem: collect migratetype letters from per-superpageblock lists
Date: Thu, 30 Apr 2026 16:21:04 -0400
Message-ID: <20260430202233.111010-36-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oqsdzjitda1wuwzo1my8yawtr3gz8ztk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D185540010
X-Rspam-User: 
X-HE-Tag: 1777580574-844538
X-HE-Meta: U2FsdGVkX1+HOyhBhblniwCToKx6sRc8OEKe4eWD4VGFkQ1w7xk5pQttWFMmUYEb4AiAs5EXdNljfqMTg0jAf8+aeuSpH6wAd40BcVnnzvjannHaiOSsThE/yPEOwVenueIXLnTWSYKlImhAOaNzCxrRtrtsieHDhdHCjENPehBm4y9ruV3kFDgJacCZT5uFlB8BjSVaLETIzefHppFNMM6Bmy28PZX34A+qyj3CTc+HHoRzZs+qWpTSIhPyoG002uui3/FpUaw3OGGtljGwQiF1B+h/x2C0jLi0uSJ/3M44cagQUcvTjKFgZ2olqF0WMsLpF4diLsHcQQ+unSJj2T8ogdgj2Q/SorD6JRhvTeK6eakLsRMh7j5/7IhU9JumeJpLEM5waLE9sd65+yUdL5Va4ggNFq3nJdGX/3Epo55aU7GTu6cSyAIqFvRnHBNS6fqsxQgQV8TJIj4HG24/WoRfrY7hoxBiRKJN9IjspJwO3vugCGyhCk1fti/d0ZvNPb32sonz5rff+Vgrhqss3azCir+6ZKDNV+sPzhjX8R4wdQldOMIR/SnY1sh0EsIz91V14LZR2EI33yQkn9LXol66brWk5dtiBBG2d024epEnyr+zqhPTXHQQVQmJEUCfbhb1c0sBs9q3189p0ooxpvevaD5AHikMx8NKUVYqSnCkT/zvM7pkP2M35LiGDCCncax2l0w0ZdVgD2MRhWIjiMmb0sI2a+WPTFYmO9W5MWTfbtJritc2DzAH/JtV5iPqqYlyY9ZHd6dBrxZN1nLYv9qxyYzhZ3CZxcqUyok3AL9joMHdoCu0dlObaVjKhz78/a4HSgZwiEjIa4Q7DsF0GGXVCgJqP4JxR5Yc8YRyLYL8gynRdIa30J5vCWQeNhHm6tk/XYIzSQ5mSx02kba/8eprmkMLn13pTcfPqLn9WfjnbwK6BuqCPc5IFJ9qhZgBoq92tegh+j7/wW5FSmc
 uuc4YeWn
 gq0Epsj9ga0wbXBiAjyc/Y4b2Ay1XzSLH+4M0+2dNIMujwmmStvXQF2Mhej4dFPavXVvjHlF/QT0NitPrXsorgJyeKOCSMqalQ/tt8b4Xmvp+P4zEzDcjJvexg4iWLJArXKBM5oGkSW3jKLN/BCuFuNOLD7yXuW4J2J8OHxDAMplbOAfDKVnU5YN70qU8ExjM0y8K7s42ODjXmhkrA3hISZa54YyC87F4rG1bDhv5X1hZNFvM/as6UWrW+sZzMKz7Iv0StenK5vW5oOVV5SJpMxFyRW38fsMDUXrDGzFDugrB9lP4f5lVmtBBbM3id5mYFGQBmGGclewgeS16Blh3hg0yBzeo2q4jnW5+/Ktz/81Kktq+LeREystwi6VQv6g20BytpReILcpQaNWBPfxHMa2WmEOOunFmHXNM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

show_mem()'s per-order line includes a parenthesized set of letters
(UME, etc.) indicating which migratetypes have free pages at that
order. This was computed by checking free_area_empty() on
zone->free_area[order].free_list[type]. After the SPB rework, those
zone-level list heads are always empty -- free pages live on per-
superpageblock lists -- so the migratetype letters never appeared.

Iterate every SPB in the zone for each order, OR'ing in any non-empty
migratetype lists, with an early exit once all migratetypes have been
seen. The shadow nr_free count remains correct (zone->free_area[].
nr_free is updated by __add_to_free_list / __del_page_from_free_list
to sum across all SPBs).

Falls back to the zone-level free_area for zones whose SPB array has
not yet been allocated.

The whole loop runs under spin_lock_irqsave(&zone->lock) without
drops, so no hotplug race. Worst case work is bounded
(NR_PAGE_ORDERS * MIGRATE_TYPES * nr_superpageblocks list_empty
pointer compares per zone) and acceptable for a diagnostic path.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/show_mem.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index bbbbef5baed7..a80076fe6165 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -363,16 +363,31 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
-			struct free_area *area = &zone->free_area[order];
+			unsigned long sb_idx;
+			unsigned long nr_lists = zone->nr_superpageblocks ? : 1;
 			int type;
 
-			nr[order] = area->nr_free;
+			nr[order] = zone->free_area[order].nr_free;
 			total += nr[order] << order;
 
+			/*
+			 * Collect the migratetypes present at this order. After
+			 * the SPB rework, free pages live on per-superpageblock
+			 * free lists, so check each SPB. Stop early once all
+			 * migratetypes have been observed.
+			 */
 			types[order] = 0;
-			for (type = 0; type < MIGRATE_TYPES; type++) {
-				if (!free_area_empty(area, type))
-					types[order] |= 1 << type;
+			for (sb_idx = 0; sb_idx < nr_lists; sb_idx++) {
+				struct free_area *area = zone->nr_superpageblocks ?
+					&zone->superpageblocks[sb_idx].free_area[order] :
+					&zone->free_area[order];
+
+				for (type = 0; type < MIGRATE_TYPES; type++) {
+					if (!free_area_empty(area, type))
+						types[order] |= 1 << type;
+				}
+				if (types[order] == (1 << MIGRATE_TYPES) - 1)
+					break;
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
-- 
2.52.0


