Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3126710F284D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7886E6B009B; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737B76B009D; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8AB6B009E; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8DA6B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2AF213C59B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:09 +0000 (UTC)
X-FDA: 84592342338.19.EE667B0
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 25F1340010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=BQylBdA8;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArU+MbvPpoFkKDvCEB2tIeK2zHviaq/MDLrCwpLr79g=;
	b=emT85szUO2nD1g5L5iKv8fequ9DJLNkHbvYjW8H+tVBHw6XjW1SImFGKUTYdL2ioFh/a/n
	ML626NOOEbtaoMfX6EBd6W8nkTfdYaTy6uPr0lIfL+cIEKtnvNT2daqf1CB/j53MVKTBCu
	qH7tqDxN8E2pRW9TyWSO3b64n9b5klg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=BQylBdA8;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628108; a=rsa-sha256;
	cv=none;
	b=0NpthEpLjACMm+3iYw+XYWg69jb9eJe+APuXJ6tpIZ5Dc8nH0URyYb6q46ECemIrybDySe
	eargQmC/8FIEI1pM6OUAUH/M56S9Fiwxacrlnz+wbJOD//ixNCIXvHCoA2PwWLrP+8fzWa
	4hov2h/MNP/g2TJO4JBEGYNxQ45PSwc=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6916ABDFF7;
	Fri, 27 Mar 2026 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628106;
	bh=ArU+MbvPpoFkKDvCEB2tIeK2zHviaq/MDLrCwpLr79g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQylBdA82DK3qa/LV7ggfzcm3OuLgwGoZuvwiUEGDnO0WlhtLZkobZfClPSbCx+/4
	 CiHDWBd+bFkguhjyIynKQ87Mg6yUxwLDiI5QWFLukxLQnN/RYa8uGaJGo/jHxEnMfw
	 6rb5h/gn5ukO5OFwqkkfnZEZiPNswCuUCldNWREg=
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
Subject: [PATCH v2 3/8] mm: use zone lock guard in unreserve_highatomic_pageblock()
Date: Fri, 27 Mar 2026 16:14:43 +0000
Message-ID: <3fec3cca1eb90a4295f73055514502228ec0e9a1.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 25F1340010
X-Stat-Signature: t1zmme7wsbi96ghqxwz9qjj8kjpaf4wz
X-Rspam-User: 
X-HE-Tag: 1774628107-184087
X-HE-Meta: U2FsdGVkX19Amlzm8A7R+mi+YX72hwlHJsgiX5FuRxAzqlhQdIYH1At62+TFp8vtec1FtEwtnzLESZTbw6eyKPO6ODPEqUGX3Cd3I8bCQ22wVmeiSRYB5SmhtNCIretP++a2w/GL8u4tbMmfKkQMvbi0CD+SnzipSrVTLmOtcjWGklEtwyc9AfdmcL0gKsSw6afNS85KtD6O+NNx2NonkeDGapkQPBpCDV6nTku91W7Ldwtc3OlZoj9f67VIDarRrOjHNurlT/9gFJ5Ehh6Tp+UMtWk2wcXSuC+aiIRUcK/z5iZAg3oqQaTcxzg1X2td2v0PYZ8jqkZyL0QBpVxBhrMUMCiumIBaQt1dsFGCJ2o6o0gdpCIidkttHnJ8CizqX++58axqRZz8hERvLJCJTZZW7PXoTCa1/qLlKb2Pep+1yhggb0sGmRb+/zkHpVCu1QgxKQjr5s9hpdy2oAWLXDPwWrGdR8N5X87fGkS4wegKTloOjJ0vEOFF5e4mIgowpIRcDBrbyrfOV83NOKa89peqUbwmpho2MoLUZ0KqH4kL2diUoUP77zcGiSSen++dZFuYShOEzU6uAyw9VM6q9/6k7zNv2WMcv+lDS/wQLa81rrV2CrhAsBFdTf184L8ZnJU95NVKP8OjzW/Rx9A+A/3XYDQ0rCannSmjCtb2ePnua9CrWcsYNx9oBnT68Hwq6A4rYPpRDg+bBboy31A1K6evqVDanmU0Ch/YFJ32yLEo/XpPQfwl4Pl0LM/H7xSrnH3vCbKk4mMU0jylkbMS2hGPFD2uDxQENmYyB1GAwZi5qw43xkebhAnfSwmFTngB/g+7nNQejqOqYVenF7vubw42kcI02L2IkyjvliPYav3emQxn7x0icCH8PcOSlPrdIX8GWh2Gd6tCnytNkxKj61OBsOlRNoFstsaj/Upd71Y0vP85YKb+XmV2Y4qctCDYzKVeBnWXoB0SQ5/UjCe
 P8DPavAI
 i8mdrrMOlka8COm0TbJPYYRkuENCMp3CHstRdX1fnzeDWxgYGJDmo/Dj4yLCj5nuodh+8jvyv3tDMzDCVZWzMbl9fK0yQuG84d6hgJKR4cheR0a9keoRQFiXWGJaDrYvVNXHeV9aa9mtwKg/PbGLyEZL33BydA6oPUrObZKutgKxXkMR2RIMS+M2O24wcJ+CfbYhZiZSPh+dPGvKMmPasF+jFfwU83bHlwRDgeEaO1hNKD8cMAdS2rGK49R4u9VzdaUN/dwFiIYgGQfFrU7FioVa0RNHgxhQiVWKMzQvbfIwRDvk91AX8lFhQx6Z9i3bxRUj0qz31aqqFgqaeCmVIP7Rtt+Xf+ngCXrTP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in unreserve_highatomic_pageblock()
to replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c7b9b82b5956..f06d8b5ffc88 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3452,7 +3452,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
 	struct zoneref *z;
 	struct zone *zone;
 	struct page *page;
@@ -3469,7 +3468,7 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		guard(spinlock_irqsave)(&zone->lock);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3516,12 +3515,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 			 * so this should not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+			if (ret > 0)
 				return ret;
-			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	return false;
-- 
2.52.0


