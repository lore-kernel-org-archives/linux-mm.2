Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423C2C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C386B0118; Tue,  4 Aug 2026 10:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCC86B011A; Tue,  4 Aug 2026 10:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819A86B011B; Tue,  4 Aug 2026 10:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56FAA6B0118
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:48:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C440E1C00CA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:26 +0000 (UTC)
X-FDA: 85063867812.05.980E689
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0B95BC0009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g4eWYHwv;
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854905;
	b=4SPo89C1bpR9gG4TMZvAf4z6g2cUUgR+OGiaqUZrZ9rVKRabgyMquAwUrJ5vphfxxWwsYE
	U+1MG7NbxR4HtNqhAqq82/ZVDQe7T7/9vJU6O5xM9bfGD62Pfuc/aIkuiH5ADGA90S/4PC
	ZphS7YOHk3A3e7iyid/MXBxqNMslapY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g4eWYHwv;
	spf=pass (imf28.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mR23Xel4iQAWEJiRA5QZMmGqrf9trThRl4S8g3S4noE=;
	b=6aYsjNQiL8LVOx3Wu9jCY2LkKE2bF7XAQ1EI1ohpZlVn49nwfdjzuyGK9hgxyO7s7lsotK
	Di2/KCBYpuob7/JNNtLKqbPaPFKJifh8+Pheh+64tKQYW8h560rs+FC3fBtDgUYYqF0GP6
	nAI4b0731qiTGuhl+Aoy6i9+vn7Gr8Y=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d01663d816so37304435ad.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785854904; x=1786459704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mR23Xel4iQAWEJiRA5QZMmGqrf9trThRl4S8g3S4noE=;
        b=g4eWYHwvPvofbbyprt1eIDVVX4+Z2EHK+tc37VQkj6yVVpxGHNm4fqomGihy4v4y/X
         XIur6m0B1d2FMUX4EWaZG/7KWSA3chpW86XrAIB8fgkilJqxt/CngcBa2phGQJXYDZC7
         iQDNB4jZuQOFsTGZgHPsV6h59sB/hVXmu5F9sQ1L39hf1e7magal3eGLwWHxLS0TCoH/
         eThb5ZilNVxHiS8/fiz1glPNxOj5VkLsE5JBTCwBZyl6U43QcI2hullVWtwDSuON0QgD
         YNQ6uDW/MyCAN22tQG2fQiDsv9KM7exSxQdiWNmYoU1Br1jfnPvYuSnBCCg3pjrsf3Rl
         NPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854904; x=1786459704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mR23Xel4iQAWEJiRA5QZMmGqrf9trThRl4S8g3S4noE=;
        b=WECvSQa5oaOW5/6QNSajMrePhfmWs3bvD7VCUZdC1LNbN7ycDN/FN1ZVJEmAUWyOBz
         41rZCrfmIOC03YHlcj5LCwuCULiD41Gy6wKQ4BX9e9k2uAPTNFEQN5PI2Twg2gRXKBEp
         FU2X0oCuVwKL1fRWpwSZtx4MaAn87pOw/RhtODUuIu+WNeuJnMj0nwsBKC+BYizhij7+
         iAOJQih8xKbORPHYobXArGCfRYEqndnDqW+WFQkTUE3ARlbPyRYIyH6A3IvawGy+i2I3
         hFmHBIpIQofc14/cXJnlA1ulhdAYGdawS/gnH9/9U/uqL+H7PlPn0hOW7KPReDfxz28a
         Z5lw==
X-Forwarded-Encrypted: i=1; AHgh+RoHAIqcTp3550fLfFSPpaOqisv/5NitdzWrvzc2ESh/GZRDUFFlw362/0JJPod2LznS806HCCtJVQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5ijjLuKr7+cOc93VlqII55B+iZJc3GwaX4+x4pIiPAsshb18D
	cMwQdw7FEfOGLqt1awNid60AG9eOodF0hidVVMw0vtVl3DQrthmmsqEc
X-Gm-Gg: AR+sD10AMVHuBE/aDOpPaXUcwLm8/IxX/VkybwGaPExmrhYt3dPKnQhYTbxkQY4g6LT
	c4TH4fOTdaHhs7ul1/0rE0MtveNzsjr/FQBakUdJv3Ov1EVV+TSHhrU33uGZqIw3HUZAeyCJvsn
	28H5atCYVebFywxRb8FEJ0dzreweOCZnJHw7rZSnxhg5B4U4X98ikKRRmFFmwf7SLwGx+eneTTX
	df4N/GIjb0ssv7vVr7w8Qc/Up6ko+AnjFGtO8JhkrF33W+yQg2I6DoQDfiNuznLV0cra9InfXMm
	oiLlt0/ukQAGLFPb/Zx2iwb2z3GQFZFedK7Szx4SmyMQwCkMnwoiqvZI2nNHxa7YH4oknogGrK2
	D9qos3TJQbmhK1ACoe2rDECZpvXp5AxwVEL/iDxbFrqxzc7g8gsRpr04kylTAQEK7D/TQUFIfqm
	5LOoshshwxLveyF9Vsot9l8m9wtHxrULSlxoEtRimV3qZx+A7pZE7o6Wk=
X-Received: by 2002:a17:902:e945:b0:2ca:b4b9:4586 with SMTP id d9443c01a7336-2d0521e5d6cmr148874165ad.19.1785854903753;
        Tue, 04 Aug 2026 07:48:23 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4930e1sm8784175ad.41.2026.08.04.07.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:48:23 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/4] mm/mm_init: fold adjust_zone_range_for_zone_movable() into its sole caller
Date: Tue,  4 Aug 2026 23:47:58 +0900
Message-ID: <20260804144803.3290255-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804144803.3290255-1-ekffu200098@gmail.com>
References: <20260804144803.3290255-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o5gsa6akufi1om1nww7dhfxfu86gmupf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B95BC0009
X-HE-Tag: 1785854904-53263
X-HE-Meta: U2FsdGVkX1/DKVcMx+EXhUbSsP1LL2/qLzjb6ma1ZykzD49Ueb1Slk6yInfVGxrb8ImtKhbk88LYHyJ5+xO6b+4zjt4MkLw7MvEI0oQskOyYjJMTHZckS4UaKiMg0xytFEMgBXKY5cd4qCgc1hTKz7fyqd0kXvrdAo66l3/xWoBaMHiBnBUzW0MDgQOVt3kRVXTZlzRSQVMhb+t9fMcFqH48lhWsvvAfforQCPGWrzVBdOnwYXzia/UWelorsRePDMPpeoRPM+e0Zi30fqcZ6E7jgVZJCpbZhA6bD+qDDB2DQGsKyqAjFNVn5oE0iYW1s95+08Gr49ZzxYxQazsoXYvPFpG1dMNtJZRidSAMdwwob6iBQCKlpFVaa/1cIX8n2GbC8j4Hz6IJLa3FSevPww3zmjiMlhXCbKKxeJPTYAjR2tHtzO4P2D1JXnT0jZQl9OvM8K8ilVEaamox+gq8mPh0QHTQrFXJqJNsOy9P64MNmPM7SlCpHiWAA4YFWwwCRxwq+brxunxUr9QLUmCvQyURjdoDkGtVipDSyWt1kIJTVgcdTmnceu4Xrgnih6XGE1JXteB8MRzR7ZL0fDhedFHv2j6a9YuMXXd5ZKUEq1OWS7pebE4+BqGGg0xK546PmW84mO8TKLtuvGyYTFsuUZPz+YMTSk2329L65UUkt/LLiaqdoFYylGSJCsqJznFl8Ptc7eo3zb5mHIQ4UY8Kx5SeFZF8Pwt5ujyIAV1Sv0+NI7tqODPO8sQ6ngHXD7kWADHCKD/MymXb5zHpiH4Qn7UlD4AABkqG9PbgRMsyJ8k5iBK04eZb0CObCCWbujc+Wddtu1fnOiAZo63+1kmvqorWcJo427AGONmJF0ROc6aiK8mPq/fRoqIIITdf9ajR9GxR5yVf4AVY4O5VpvhuInyCnI5OAqGp7J+fBV/qB6/X3CqxK/7sx7Rhe14GBOCC3tgvFXKCILY0mXBQdHt
 rM74yS/B
 cBrLLjFReYg8RWrzBXLJXj2dK27/we8m4bFLD+Tv0EahuH25bs/ssEDrF/6Ri2xAWN9PnYPIXesUAR7HyKvcHHO35LTn/z1ZmD9Edxccn1ZdWTFXnd1cez+TNJsdg7R7zqUOr0zzDQv+g/vwcIS5ZZGE8cT6JjlZMV6PExc3W+ZJr70wC2m06gN3ULaMfLabUfyXVUxSsQ87X7ClGn/o8JBIzDn0CV9ElsYAt6TZnkXk4XXpniEjsJxZInTKf6U8xQKeG5rEC1v/30qTUz+7KaDEiFbFvAPLHDPCEQ10VQAaXej46g7uDunZ+0uO28KjyfP6Nx8fu1tUnF3OWrHm4Xfz7mxyJIZcGkuqpfrvjJjfuJmuGsD48uXgmsN2o/yirOVLg53CcbIM3ixvMs9PQoTkJvKSvu2PDC7YrrInUGJrHKaPHthEH8gNXvSLivqEoXMJDE3txA4OnacIM13/u9kh1SibEf/qIxQ90lvRF7fmF3t7hcpjwJ3g9gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

adjust_zone_range_for_zone_movable() adjusts zone_start_pfn and
zone_end_pfn. It is only called from zone_spanned_pages_in_node(), which
adjusts the same two values before and after the call. This makes the
code harder to follow.

Fold the helper into the caller to make the code clearer.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 66 ++++++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 38 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c..ddff06467239 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1143,42 +1143,6 @@ void __ref memmap_init_zone_device(struct zone *zone,
 }
 #endif
 
-/*
- * The zone ranges provided by the architecture do not include ZONE_MOVABLE
- * because it is sized independent of architecture. Unlike the other zones,
- * the starting point for ZONE_MOVABLE is not fixed. It may be different
- * in each node depending on the size of each node and how evenly kernelcore
- * is distributed. This helper function adjusts the zone ranges
- * provided by the architecture for a given node by using the end of the
- * highest usable zone for ZONE_MOVABLE. This preserves the assumption that
- * zones within a node are in order of monotonic increases memory addresses
- */
-static void __init adjust_zone_range_for_zone_movable(int nid,
-					unsigned long zone_type,
-					unsigned long node_end_pfn,
-					unsigned long *zone_start_pfn,
-					unsigned long *zone_end_pfn)
-{
-	/* Only adjust if ZONE_MOVABLE is on this node */
-	if (zone_movable_pfn[nid]) {
-		/* Size ZONE_MOVABLE */
-		if (zone_type == ZONE_MOVABLE) {
-			*zone_start_pfn = zone_movable_pfn[nid];
-			*zone_end_pfn = min(node_end_pfn,
-				arch_zone_highest_possible_pfn[movable_zone]);
-
-		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (!mirrored_kernelcore &&
-			*zone_start_pfn < zone_movable_pfn[nid] &&
-			*zone_end_pfn > zone_movable_pfn[nid]) {
-			*zone_end_pfn = zone_movable_pfn[nid];
-
-		/* Check if this whole range is within ZONE_MOVABLE */
-		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
-			*zone_start_pfn = *zone_end_pfn;
-	}
-}
-
 /*
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
@@ -1257,6 +1221,15 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
 /*
  * Return the number of pages a zone spans in a node, including holes
  * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
+ *
+ * The zone ranges provided by the architecture do not include ZONE_MOVABLE
+ * because it is sized independent of architecture. Unlike the other zones,
+ * the starting point for ZONE_MOVABLE is not fixed. It may be different
+ * in each node depending on the size of each node and how evenly kernelcore
+ * is distributed. The zone ranges provided by the architecture are adjusted
+ * for a given node by using the end of the highest usable zone for
+ * ZONE_MOVABLE. This preserves the assumption that zones within a node are
+ * in order of monotonic increases memory addresses
  */
 static unsigned long __init zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -1271,8 +1244,25 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
-	adjust_zone_range_for_zone_movable(nid, zone_type, node_end_pfn,
-					   zone_start_pfn, zone_end_pfn);
+
+	/* Only adjust if ZONE_MOVABLE is on this node */
+	if (zone_movable_pfn[nid]) {
+		/* Size ZONE_MOVABLE */
+		if (zone_type == ZONE_MOVABLE) {
+			*zone_start_pfn = zone_movable_pfn[nid];
+			*zone_end_pfn = min(node_end_pfn,
+				arch_zone_highest_possible_pfn[movable_zone]);
+
+		/* Adjust for ZONE_MOVABLE starting within this range */
+		} else if (!mirrored_kernelcore &&
+			*zone_start_pfn < zone_movable_pfn[nid] &&
+			*zone_end_pfn > zone_movable_pfn[nid]) {
+			*zone_end_pfn = zone_movable_pfn[nid];
+
+		/* Check if this whole range is within ZONE_MOVABLE */
+		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
+			*zone_start_pfn = *zone_end_pfn;
+	}
 
 	/* Check that this node has pages within the zone's required range */
 	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
-- 
2.43.0


