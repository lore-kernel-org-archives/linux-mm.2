Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33BDBC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AEA6B00A4; Wed,  5 Aug 2026 21:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432D06B00A6; Wed,  5 Aug 2026 21:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347E66B00A5; Wed,  5 Aug 2026 21:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADF346B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE7681C11B9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:08 +0000 (UTC)
X-FDA: 85069068336.17.C8D56BC
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id 017782000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XqvAW1gu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3Zd9zagcKCE4zEu8sq8w44w1u.s421y3AD-220Bqs0.47w@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Zd9zagcKCE4zEu8sq8w44w1u.s421y3AD-220Bqs0.47w@flex--jyescas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8g9EMe09F+Ayx5LYmfEKiyWcm3g2pLNQKJ+H2xPNgqI=;
	b=z3pm2anqtK6oV0m0UKAPnfZFz0afatQHPLhC2mrw7eHN0rTF3EwuMxuqilgUACICaZNTQ0
	woIz1VTkg20fVY6XGF/7ww2XCzC/F28Ld2B2X5lFaAMqFkPBm28MgvZ30tqD4Ol0zXNgYL
	IwELTnD4Tdp9MtoD7OgcjmKTJpD9Qkc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XqvAW1gu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3Zd9zagcKCE4zEu8sq8w44w1u.s421y3AD-220Bqs0.47w@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Zd9zagcKCE4zEu8sq8w44w1u.s421y3AD-220Bqs0.47w@flex--jyescas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978727;
	b=oYCLqIz+P47rwHLOKIbchioMNuIpf/iLlUlDoNFiigEd+2pxUPNo844GagRprnQkh+5cle
	nZ7vbQ+2GdH5maQtok+fM9TgjgrA/AcCMYt3i/YCqxIUO5/c3NCbO/aGIIAR5O9OH31JBc
	ZIRGMCyyOjsSLDETh/4NLFNi44t3z1c=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e7b87ce77so845496a91.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978726; x=1786583526; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8g9EMe09F+Ayx5LYmfEKiyWcm3g2pLNQKJ+H2xPNgqI=;
        b=XqvAW1guVWqXnFhHAembTKpr5Pp+Glo9cghZngk/kviXJItyW/gp7E4LkTpMbRHbjv
         ENcxGR0pIFGiBLdPVqzAuHTA0lG9pLd+MpyX+8NQHxbPKFYQ1XGEzsZVaCYynP41glkD
         L0btUOThjAsBRuxoC6jXBySxHKMadq8+QQmZCV/J+lsjMmXXdbX7qcDJ52yHWFtFsyNN
         j10lC7atW18taCM/d0W0+vOGXCqUcNTgmBEGTZltmKSKDiMxyB0Gkwk1WBRMYrTFju/I
         2AcpBVcyXstHxszpq93KJ+tMa81Uzyo70IX9IV0j3QtxC1tS6Zq/uao4debgqoAIBv7D
         i4Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978726; x=1786583526;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8g9EMe09F+Ayx5LYmfEKiyWcm3g2pLNQKJ+H2xPNgqI=;
        b=ZCVIFnAIKAtL3HzUTgSogSkQGNGeHDHf7/YNMK9a87vRvwZmfzfSpGZiiD5X4oaE/u
         WxYGgMVidjsTtOowUTHh0AfIf5E9RA8ahVXPb+LnoNj6v0afbE5cs4WFKkuNzXSZnwID
         1R98nkAKb2zl+dgN2wWq538s6kPPwqJ0IBxHU67LLhwnonRBfaxz4ouH86LnegEKiLdx
         ljICYAunalsQL4cu9TSq+K9r+WacpB9mXXGO27GQZiavTRukAzvS5Bu0LuodFAQ8HzTl
         19djMgvj6+sPLD1IQ9kSBF1ee0FXH+HfzzAUglYpCQepBkw8iV8tgPg3nxCOPo8neyXF
         m64g==
X-Forwarded-Encrypted: i=1; AHgh+RrUcasaV99s5baREfoGynMsb35fHnBvknWNK1CDcwNzwcn8JJd6drC9TDcR79pQAyb75C1A3U12Uw==@kvack.org
X-Gm-Message-State: AOJu0YxReBYk08YPdO+0o3QZC17xxK/cGJk+Gdgl8zczWTf5na2JUsyW
	o8Y3UizOR0yK0fbYDkhNy9fJzWwIYFz2/hZK9b8AzPEB8xjdjeDoF936ODz0UgXveyA4WgKlkpN
	4gTmEMu5Pcg==
X-Received: from dlah18.prod.google.com ([2002:a05:701b:2612:b0:13f:a0ee:666f])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c88e:b0:38e:488f:7068
 with SMTP id 98e67ed59e1d1-3903c5373b4mr12668555a91.2.1785978725605; Wed, 05
 Aug 2026 18:12:05 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:06 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-6-jyescas@google.com>
Subject: [RFC PATCH v2 05/16] mm: Define function to create a dir for
 populated zone
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 017782000F
X-Stat-Signature: 6rmh4ka3mng8oryook5ou4h1e38zgwr1
X-Rspam-User: 
X-HE-Tag: 1785978726-648527
X-HE-Meta: U2FsdGVkX1+QqTrV5DjsC9/IER7G2EOwYFoD1A99AjkfUflFxMKsdIluhaxfGZeQhJFmpYyJCV5Xg8190imi9QQiLpVLXUTvePRGHCwrh4hqUBIRUdIsYAyVVyBcxvn0FJkKQ3BS+kTLwvnvNHy3Wh0Z7rE2nODaGRChvR3y1DKOoPg05W6yY6XrnNIhYi+b4eDjcecDwUXD7pSLvCvakamq6tlEerYVH3X3Skh/2+cMuHxs+Qm/1ThPZ/WfG1M6m9dBjQkOOdchr9Dgi0oIAQslGiVKa3aIQTYK9HQrdChRrbukqgnqncn/beO4THYbUdyQdLwpCahldQjntEbqkF+k3T4bV1yRDk7qWZItS97X6rNItzYddTLngbNM1Hw/M+aTEFbhitcyPV4OdrdiJhInh3UuOpsHGFP/b9Kq4e08lLW5X1uQmpd2GpawYznlSEGZf0uNTJcy+lTLGj/KQWUtaQzpSxJnImLQMJHETFD40EERF41wOgCRxfmfoi9V0oznRB4A4/YZ1MW0LwlS6+KQ7EARmUhl4XnNY3j2+dJLKxjUgddQE8EQdZu5b7m9nyj1a5ud7AyakWxKbI4AHWI0Lnl2Z10YGS8pQsOsjbN8ieIzRUX7AZxIpFQhfPmbMGAzv7yJ96yTabKLMEJuOoZPsWugajGKui3jtI5IeGPCRQBI2Yj1r5/zyzZ7PfvPRCwrcH3hPDh+LavTc4LB7BK6HIzKAV16DHBhSbBiO8dC+99R8iAManate00JyrOmZ+2kWo1BSKodTyzgQVhQxP7caPpB/mo+nhK3xSBB9tlCK4iHT7f7CLPCqJOMLtrWssYeUOWHILLqkWqaHGze4DDnt4/r3mBunBoeEphUlhJCmRvOoadIgZYghxf3DXkZSBc2VuxlUahitwPH0e8h76eIm2rGQ8aQGjqL15ggdSvpiUgSQPzhOvuhgyCz5ArRYrSFRRhWOvUTYUdyQad
 /yY6UxeG
 CScStJSjroiYh24GLo5uqXbN0sikqTwvCHriXfwNY8s7kSFMSoAULqxwhvottilwN8hjrOi/zcqDLDdDqc8d7zLinVuNx5VgyqGYbIzsDKRqNMZYTsA/P1uNQO+CAB4KKmUxWwTnVI4XjSK7VbnSwJTxUBRzHtOq/AyL1g59L6q66XtZeHLtLoLXS8J4kcjNE5icGBcrGj4I1VmIFpAzbtfxXDNc5lG9hYwF/3JS2oiCMyx3aAuesz0xcXJ0vS32xc/zHKIiwtZ/Nc7x4hEC40Agl5nNuyYw0WIwHbR52HdHdvcK/4zZibBaa0jdET4Bm7oNocGH+kZtd6fERHDZvwyYRL4KXf+R6Bvuy74aKdX2/9vhmOCib4UQkdnTNtsAML7IQ3s8ldhDBtCY9sjQWhQO5GAtP1jQWOoLqJXvxOphT3eKogHe6If33Ww88kg0VYQyBK1YGR12gETrSyNMgdhw/Z9T/Dtx+AEzVaE7PYqMWejwC5sh4vCqyzGCoa4JrGxZOFhKqfhqjcTniGMoNyQupMh8SNzFjmBMB81lFNQlhuh8SbH5iFCKVfT3kogwrQg+eT2xX8NtfWP5YYH7EDdHsEOp+PZD6eQt482920rd8PXHAjoroq6xHfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each populated zone
in the node.

Note: ZONE_DEVICE pages won't be exposed in this driver
due they are not managed by the Buddy Allocator.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Update comments.
	- Remove unused variables.

 mm/page_alloc_hogger.c | 46 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 5765ecc43567..e8944080e82e 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -88,6 +88,7 @@
 #include <linux/gfp.h>
 #include <linux/gfp_types.h>
 #include <linux/kernel.h>
+#include <linux/mmzone.h>
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/printk.h>
@@ -126,21 +127,62 @@ struct page_alloc {
 static struct kmem_cache *req_alloc_cache;
 static struct kmem_cache *page_alloc_cache;
 
+
+/**
+ * create_zones_subdirs() - Creates a directory for each populated zone in the
+ * node.
+ *
+ * Note: ZONE_DEVICE pages won't be allocated using this driver. The main reason
+ * is because they are not managed by the Buddy Allocator or CMA allocator.
+ */
+static inline int create_zones_subdirs(struct dentry *nodedir,
+					struct pglist_data *pgdata)
+{
+	struct dentry *zonedir;
+	struct zone *zone;
+	struct zone *node_zones = pgdata->node_zones;
+	char dirname[24];
+
+	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
+		if (!populated_zone(zone))
+			continue;
+
+		/* ZONE_DEVICE pages won't be allocated using this driver. */
+		if (zone_is_zone_device(zone))
+			continue;
+
+		snprintf(dirname, sizeof(dirname), "zone-%s", zone->name);
+		zonedir = debugfs_create_dir(dirname, nodedir);
+		if (IS_ERR(zonedir))
+			return PTR_ERR(zonedir);
+	}
+
+	return 0;
+}
+
 /**
  * create_nodes_subdirs() - Creates a directory for each node that contains
- * memory.
+ * memory. Once that the node directory is created, it creates a directory for
+ * each zone in the node.
  */
 static inline int create_nodes_subdirs(struct dentry *mmdir)
 {
 	struct dentry *nodedir;
-	int nid;
 	char dirname[12];
+	int nid;
+	int ret;
 
 	for_each_node_state(nid, N_MEMORY) {
+		struct pglist_data *pgdata = NODE_DATA(nid);
+
 		snprintf(dirname, sizeof(dirname), "node-%d", nid);
 		nodedir = debugfs_create_dir(dirname, mmdir);
 		if (IS_ERR(nodedir))
 			return PTR_ERR(nodedir);
+
+		ret = create_zones_subdirs(nodedir, pgdata);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.629.g250fe7f194-goog


