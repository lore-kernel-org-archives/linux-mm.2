Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C355CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578F86B00AC; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDAA6B00AD; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295006B00AF; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 060B26B00B0
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C867A1C0559
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:07 +0000 (UTC)
X-FDA: 84716346414.16.226F8FF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4757A1C001B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=K2Xu+q0t;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwbYmQVONNFpRoy+LHkanYVTDHsfJ9bQknKONF3uXUc=;
	b=vf0H8G0ubUS+zlF/cZoowD9juHnk0P29Gbn7bkhLTYNqD3/1xPx3m0fKF3RW/oyBGhDWkT
	LazSv6/euh1Pcy39Fe7GLawvbnJuotCqUfBc9o/lC5NxklS6kroPDa0iJdOOp41E4F8HuJ
	fJr63JJ2aZHCKm41MQBssE1vdPxob6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580586; a=rsa-sha256;
	cv=none;
	b=dkVd90tTR0kld2Pi3d0Th4yG2qE5/BwFmJUsrU4fyD+B9fBQFFvDi5OPv98yDpL6Ay/R+I
	d9S4vH7v/X6Co9gkbERqEb7F0rK4iVpCcIuyOFadTPJtaGzTBg3NURzydvGVyLOofdLQ2R
	t1HOaFrnHW0pIPoslgtpomXaiR8CGNY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=K2Xu+q0t;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bwbYmQVONNFpRoy+LHkanYVTDHsfJ9bQknKONF3uXUc=; b=K2Xu+q0t/1gTbY57QvJ6yUbQk0
	uWSz2Wt0MWjd3Xo7TqN6ZNWzFQRibo5tG6vNnRNhcpyFGM/ALsgQK1HP4OH2zxfL1JOFT2ULrWg1+
	Rvf3o8uGCi/T50BgoClLgdnLkq5I/rAHnrcgk6i84F2hC/W4D4fycnaaWD2uMuLRh8AURRzIOGHbI
	xb8ooNhZJTi/0eUAkkJcyohq0Oo892yLrRJyPsPBP7L+VrTPckbHbCQoorPafdfd2jMnURjQXPl1F
	18twvp/TrWKV5BiDSfVcCbPOUcOK/o1r5L4XTT+/DhhWW7Ma2lcYJfPPC8Bgs9qkM3MS5c4bdiA2O
	72tGySBA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1tn0;
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
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	linux-pm@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 40/45] PM: hibernate: walk per-superpageblock free lists in mark_free_pages
Date: Thu, 30 Apr 2026 16:21:09 -0400
Message-ID: <20260430202233.111010-41-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4757A1C001B
X-Rspamd-Server: rspam04
X-Stat-Signature: pdmfdtwdisd9yn51mubdi8maex67u47t
X-HE-Tag: 1777580586-196803
X-HE-Meta: U2FsdGVkX1+fmdFYh7445h1vTLPAgKurklxaiYkHBy0GSnmHw9e79SwYKBd/SvTgxqdzhw6Qbqygp8FMpBxrTgBUxzr+5n2W8fST0V56915yLsE1VDheTAKzhqGwriRyFt45v6CDoZJoTB0J/T0CMfIE2uRaX33KVDlnFdwk4AJjKLHeiMbqYxzADp0HHOJ744hDN32BxIANl3Q5Ptya2iDaqz+hTnor3dMn+kCHQyL8p7ftATxrOw0c91kSDpyoPxj7APQneXTFHhxTDGd22YpPqzgx6v31/BpcX2RkVulfsSxdx6e4FGp73lqJPktI86xXuHu6qpW+fpkXhza7447cGdASrhMGGgX/YcWLb6+qowAZaDT63l68IPop4M/x4sEFzJbDcrj9ladZyMjjEgzKba46kW1n+oVbqN1kZaoDNkPaLAfkduemkprzru89tBpLZkaatypUN7KZ/bvVigi7Gjqjr8sjZYAkb5Ig+G4ZFEf/YJzYlWJvQMHx3HEwOLXVx0BasT1DEk+Wkt+3am+k6d4hElSEQgiFr5f9QNTDA4JuAoDHE4RzsshR7t/ruF85yNrrqnSyO3SaIcB1odgzq+dPViPQXPg0ApCetbWqzhDzevSVKi7hf2zz6JG4cIH745EHVl+43V89pObIqBIWWT1GJ4dSSxfVMVs9G/3jA9VmWmiHF03clNZVdBfsVL8pHxdi2o22dFKMiDLWq1q9eNZHlElx5ZlenlBjB5caELdjwccPQ+NwyTFaMmCn1/bMTueQkUliI5a8r5iCxYCT2KZ6hhTqS/kuY5LxVW06t8peoKGm5wgUncseIq+LXiZvK41YIp799ZRoadcJfKG3QxEP+Zt7xJtKoQkSVJV9mgahvP0sYh0or1dwyhkNalZU7jNc0DCrkvlYDmC9PiTy2xgjZGiy09vRAzee4t1hGwN8TZO/8XjvkRS4jUhDvbDwx0ZiCj/mLst6NFy
 qpIbFpe3
 vknNN2VevbCWmRmRbi9OtVgVXIzxboZ9PNSJ1khv5CHW1EQ5ASXQG3BKIlya1hkUr/NJ0sue0Gy3TF2Idk7PsCw6XyC0movq91q36qlBrlt/8FfoeTbbuDu7Kdvs4hO2BMb+zN0orZqvd7BNCnc5kL1yjEGdL0hP/P0w4Fo9u1/mE5p7TNqNbQy0SIeg+9y2ca7znyEI3GKuRJObokovibl+fwkfCQJOUeesatutb8QjW1CnQVYfrAc1yob124h5fx6okiK/OBfAV+mMKRa74gVQi2PbrFX390bLjSGYqu5HziIjw5ZoX/SBVC48H7wkpif2yzH/THiOIgDyyPZ6EW5hxqCUmuah9iyfNqX2M1QzHbH0O1uqveycRr6HyTU2DPtnztsZWMTMauaopErrJecwzPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

mark_free_pages() walks the buddy allocator's free lists and calls
swsusp_set_page_free() on each free page so it is omitted from the
hibernation image. After the SPB rework, free pages live on per-
superpageblock free lists rather than the zone-level free list, so
the existing list_for_each_entry() walk over zone->free_area[order]
.free_list[t] found nothing. The hibernation snapshot then treated
every free page as needing to be saved, wasting image space and risking
OOM during the snapshot.

Wrap the existing per-page walk in an SPB iteration loop. When the
zone has no SPBs (e.g. an unpopulated hotplug zone), fall back to the
zone-level free list. The whole function still runs under
spin_lock_irqsave(&zone->lock) without drops, so there are no lock-
order or hotplug concerns.

Note: kernel/power/snapshot.o currently fails to build with
-Werror=return-type due to an unrelated pre-existing warning in
enough_free_mem(). This patch was reviewed but not build-tested in
isolation; the change itself is mechanical.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 kernel/power/snapshot.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 6e1321837c66..682c3bf2ba8b 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1270,17 +1270,32 @@ static void mark_free_pages(struct zone *zone)
 	}
 
 	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
-			unsigned long i;
-
-			pfn = page_to_pfn(page);
-			for (i = 0; i < (1UL << order); i++) {
-				if (!--page_count) {
-					touch_nmi_watchdog();
-					page_count = WD_PAGE_COUNT;
+		unsigned long sb_idx;
+		unsigned long nr_lists = zone->nr_superpageblocks ? : 1;
+
+		/*
+		 * After the SPB rework, free pages live on per-superpageblock
+		 * free lists. Walk every SPB's list for this (order, mt) cell.
+		 * If the zone has no SPBs (unpopulated zone), fall back to the
+		 * zone-level list head so that any pre-SPB pages are still
+		 * marked.
+		 */
+		for (sb_idx = 0; sb_idx < nr_lists; sb_idx++) {
+			struct list_head *list = zone->nr_superpageblocks ?
+				&zone->superpageblocks[sb_idx].free_area[order].free_list[t] :
+				&zone->free_area[order].free_list[t];
+
+			list_for_each_entry(page, list, buddy_list) {
+				unsigned long i;
+
+				pfn = page_to_pfn(page);
+				for (i = 0; i < (1UL << order); i++) {
+					if (!--page_count) {
+						touch_nmi_watchdog();
+						page_count = WD_PAGE_COUNT;
+					}
+					swsusp_set_page_free(pfn_to_page(pfn + i));
 				}
-				swsusp_set_page_free(pfn_to_page(pfn + i));
 			}
 		}
 	}
-- 
2.52.0


