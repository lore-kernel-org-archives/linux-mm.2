Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D751073CB6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14DD6B0096; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9186B0099; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7D86B0098; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5AB6B0093
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED3E414015A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:44 +0000 (UTC)
X-FDA: 84635481168.12.DC82F61
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40BE6100010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=JNHJhFgp;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=JNHJhFgp;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655223; a=rsa-sha256;
	cv=none;
	b=rLJfG4AYnnAKXzhQl+MSnP2g6d1ZF4edKD39TIKCXphT0DdztjjpO4cXXKPXAAbP6KApJv
	EVcq4zKg0/Vrn90pjVQ+la1RInwNY8MPacQxy20Phrcie6sQsxnlYolbmlpw7ggDlidTlG
	oTxL7RGe5lzAhlV4Zgh6GtzZfgMEBdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb8yz/8C0x2vEUJ8dQHQ8wlORe7yLUnRitFaqcKnbr0=;
	b=htc2QOsw3PV2cZ/pGBARP6o+bOr2djP0ryb0OHXmdKISZkB8u4uHyaoJGjeDgq5jiJ9A9u
	sOXpVKm3UmcTBUHZPX1vb4G3uo03+B6aKmQSbUCkzfjFpx0L/WQKWf9ro2ZPbYjI+DczPi
	h+tmJz2vgR6d/ek5WnRTZYZz6lquf50=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 5FFEBBE723;
	Wed, 08 Apr 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655220;
	bh=vb8yz/8C0x2vEUJ8dQHQ8wlORe7yLUnRitFaqcKnbr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JNHJhFgpmQDQ3XbI1JgHGCVwTZ3lfnD7gc7BILslBjP6TLGSLswWUM8MsnW4WzzIX
	 dHkUVcpFX+l3yilRCmFA0kI5mJkuIyKp0rPSiEifAvd61yCwCaET+kobh6LOY1E7I6
	 cuOkdXLEYQkPOHlirvfQEmSvoDfEkQVRO93jFbHQ=
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
Subject: [RESEND PATCH v2 7/8] mm: use zone lock guard in free_pcppages_bulk()
Date: Wed,  8 Apr 2026 13:33:22 +0000
Message-ID: <1d51d445a2c4b2c8b7b9d65a86414633a222837c.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40BE6100010
X-Stat-Signature: 7j1h8ohqxmykc437pkztkan3m7njpmzu
X-Rspam-User: 
X-HE-Tag: 1775655223-985465
X-HE-Meta: U2FsdGVkX19tgTa2P2IDUhFlmvKoyqjSfyWMT43lBHpcThAxET98e8zPs+d2zu7y1UWpnvvHW6+4XN1Lil+wjqD7BkKJjnXSvF3EZjIk5bPa/Xsb966HdmrxQpqm0e9DVJDyCG45dQPDYun7Rok9nqFT75GGv3EVQ8loQ9idAuMQ4dVbvLsjmM+93aFKw4085ock6EgBgtqTbajCaW7toRnOSGap4xe3EDQXG7a7oX97KksoTfGDsg+5BzXt5fuGU8mn9kGzavCsO8d+NiMIfZn7uCNqTy8RkD3zE2+aNJ064Pgx0lMqtcNbOc9fg1JrmO45kDmEKDlZ/rI0OSInEYLs3p82lsZS/tZ7SZCBfv+Xi5eB1K5LncMhVeB2rDbYBSjty6dyHNDFf3EmOnxKg0nnuS1NmMCjxAI4gAqWuzkkxNoM+ZOAxbuTBSeqE72nMCiXjKQZQT0Uj9TbHaCOmQWnGgCnlltF+jsMCNT2PebLkRRedQH9cvcv5hNVzhrGHpI4oGevj+GUIw7sXjPlnbOA0hfQfPCER5sejETtU/BXMwomIMQxdrDwQHIeON2b8wcyI9Dy2UqpMCYc+7FsJqt3l+SJ/kkKjYXTOwKb4a5j63hYCMTSWCp2Zyu7Gvi2xdKIYwRheyQ0C+sVPKIAh4odyYvAhY2uRxiCUAblm1uf/sstCmDkk1UQS2KXV8GXxpupTn18WJX1s3ssO7Hi2y5jHQjGG1agxP49U1ucOjZO+UwH/dlL27pjHXmlbldD8DjZT7n3YtgwnHzinH4tKSuzbfgsW2FNG1VYZdynSnmbLXTIWTcx/Zn1FHsfk/f73xRsPcangga+9C3TDmE3ZOZt30i4qeENONEIw1nxmLkNj6eQt6fP/GRLB47aiAH187wC6MLp0ZWwxmWiwvEmnVDauGTt8Wv95U2NofRfJTSoEh96KtwFeky4EPLzJYK3nPtGzodva86+Lxz6sfR
 HzwcBqgk
 acaIhe8nm+KZVHqWI1uFXaVLmm4ao9/wtSwEd2G6gnVRS/VKY5LGqg1amJVGWGpKllEXZbaJzfeRJjN/17VS2vEZIQHr0ITX9Tdweh02nvTMelGq+weotws1aBRLv/IS/zMP8ITjMmhNiTxEdJq+uj9iNQXEbsL1hEhV4y7Qd5+rx0t22BL3lUKjV4UX8oWDzQR/fjhcNmOgidr9ucNungVTmStg3QiJ7KT15pQgKfn8I1KWbZ5DuVmIOsoGXwihREfbyljjkMQSvGn0oL5UP3Y9NGrJ4wehPRalkFVrby0j8RKUc/16KmvoN2WQ0puU1gUfH33tX7eSZ5yj3OouDEJF0pzvQF7+kJ00Ho1Ge2dxIc9aYRKonafHnvEdM5159wFjO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in free_pcppages_bulk() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 096f5fef0eb5..6a7c548a7406 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1458,7 +1458,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp,
 					int pindex)
 {
-	unsigned long flags;
 	unsigned int order;
 	struct page *page;
 
@@ -1471,7 +1470,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1503,8 +1502,6 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 			trace_mm_page_pcpu_drain(page, order, mt);
 		} while (count > 0 && !list_empty(list));
 	}
-
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
-- 
2.52.0


