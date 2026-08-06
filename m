Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A28C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514A96B008A; Thu,  6 Aug 2026 12:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5966B0092; Thu,  6 Aug 2026 12:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD4E6B0093; Thu,  6 Aug 2026 12:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00F7F6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DA5A1C00D6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:24 +0000 (UTC)
X-FDA: 85071359688.11.3B512F3
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id ABF1D100009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fjrHJSZC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OV2ia1JQIR9t4BY0Y1KbMPnG4hxTayzchKqwFyoORUg=;
	b=YFAmyrYV4UrytFhsRt5ouyTAoYd/DiYzJMzRqXPPMxlDdWZeaZi1y0aPNLE9abOO8k8d4C
	OdfAUpFkOfcZSiXrHuSzZZ9/FMS5mfJn8U9r99hOSaPqubLzxNyulDasi8xzuY8N8+x/qo
	e811g7zdt4PUKNYDeYVPqBM051G4uoA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fjrHJSZC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033282;
	b=hTCH+bQogK16qI86nk1kwFN1KVXj5ej/3wx8fObOBWYHyTyGPzqyXu+2csdJUnQRGHNKli
	I30ZFqYSit8sAeFU89R11EuDqajLnzaX2gAGirjULsboclqZJ8Hhp86jEluphHO8Kuxjfk
	nCZLCBHf2HHJrfieb6gSDICjjJFn3jk=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso2848604b3a.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786033282; x=1786638082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OV2ia1JQIR9t4BY0Y1KbMPnG4hxTayzchKqwFyoORUg=;
        b=fjrHJSZCsqv4y7W6h2deJDU+qX0EjwZmT1MIBIpJHlUdhlnME1PyroZkrwh0cDxFVR
         +ARensLndCSCvaiq0ynd2kbuDxiiA9M5AyTq26jMieE8mcWYiTYudzqbUO2VZXnPdPJ9
         qC44QS6n37z7yS6Im9dShMmft4mbQQkbijJKo0fYXB9RUavM8iYLzjjJApeNC+9qyoay
         7kUo6cqkGZVCyq6Lr1W9yw7jctELn8KPMb3ucImNuUBTrn03w7vw8+vVd3lVGr/Wm6FF
         VM595zy4tq0Ph/dPyP+b/ZGG0wznI9FlNTeoA5lxDEhRLbvV8h74gnu/Clv8CNilGIsM
         W8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786033282; x=1786638082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OV2ia1JQIR9t4BY0Y1KbMPnG4hxTayzchKqwFyoORUg=;
        b=hScqDezd3hsWyAbKpLeSEdxumF1aFfbAgrItKzLc4nWB3T8EyZsH2uH+uQV4VIDnEU
         E/+N42TTsdTwGtFWHDSmE1QppT0h4Wfb5q0a5pX65428gGfFrqBb5TxscEqhNF76y+ql
         KRueKZvmLYdETP+tuzm/gGvHESSQF6IpDl2+Ws1K2VFd5vFtq/ZjTSLh4HinN3L+tHLN
         WuhOlXWibCVZUEM5ryqVK/uoSiwNIU2hZi6MjUC0Z3TQI/tUqtatjEqzfVcvA+uPFpIj
         Cl1M4VuIWBYNxb0Flvv5jrf3JDY24kPUb21DiPZsanXBuLFEPONTrZtnpCNucBEm2n7l
         w4Iw==
X-Forwarded-Encrypted: i=1; AHgh+Rr2rpIF/kYHq9/Orn/+Kn/0W/zDhVsp43sreXchxNChi2xVC0FbZeoOy28cRwj/txWAkmW0Q1ns8A==@kvack.org
X-Gm-Message-State: AOJu0YzUXJ+BUBL42FNS4gb+cIqpOiIQ5dVDxMHLWZwVGrCDnYQxcbKy
	rSLX9Uio0yYfEF88DGE9rSGhHx+B0j6XM9m/7Q14ozwZwbozWlSLZcue
X-Gm-Gg: AR+sD118CUVAmmV+60gDc7i9BzwQPfT9GVuHIgkOZWcPhxIGzNLY1qRRU8DLX0C1lvP
	ZiJ+pNHJgTT5L9bGYo9+WsqZTPgYzWnLcL2P0505q0z3e2cDDhTGvyJNPt5RC6elTMifgE9rLGU
	s/EjsTGwZANudc7Q7bA3BZ6BZf8yPHpA1Hdbp4N86BXSKDxMX+K6Zndfuap8zmyYIT++WZ6gPd/
	zOPXGmY98GTxShN8Cozyru420szPlF1r39UQbpCGJ/qIGaoejvLXVOzXx6n30IyADmhVI19xCUM
	AvGUF+0dlsR005TM3B/MG/W+sctRbqLm67Fe+1aF9moaY/5XzZJeenz/yV5BEvhd5dh1OIO1V9Z
	JHnkWX4NxNzwf8+MjxSIp5Jr8SHOLUAVcJPnB1ZzGhc5ZAxdgFBePKQHktDliqKtbTjPr1WUGoc
	OefhBYfY3kSYMWlbaywg9dU+rQthcGLPGl4QHXKFnCwAga8ee06REzwao=
X-Received: by 2002:a05:6a00:2d0b:b0:848:4d1a:9554 with SMTP id d2e1a72fcca58-84f2e0ed972mr17580183b3a.38.1786033281571;
        Thu, 06 Aug 2026 09:21:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459b66e6sm1662739b3a.40.2026.08.06.09.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:21:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/5] mm/mm_init: fold adjust_zone_range_for_zone_movable() into its only caller
Date: Fri,  7 Aug 2026 01:20:52 +0900
Message-ID: <20260806162100.313965-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806162100.313965-1-ekffu200098@gmail.com>
References: <20260806162100.313965-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABF1D100009
X-Stat-Signature: 1uph68edyahtabikm7xgkhxnucgmhjug
X-Rspam-User: 
X-HE-Tag: 1786033282-784178
X-HE-Meta: U2FsdGVkX18KzjR5aEAXbZ1UzvDwt0KYG7rJD3VvGzw7ssAkR2GujANvJEo2qYJLLIOtXvjwHA1737epbiiLdizM5VEu0nQPhKQkpBw5poH9x7inqxRRjqoKPNaa6FgtwzRNvqAckM0maikpUn4bATWqHdLS0lMJMqlJ6Sb9cD0mictLzJo1UHMXM6MGXhAwZimnY5d/19TxVBo1yXhQmHdrYH59a0xUcaGcKrsuXLAzYZgvX/+ZiXDStMe2ESN2cBuuERmwZHDtuUEt/PCgNUaA9k1RwADulNkaWfF7zPYBH/MBPhXVmkRvf7F1+7NmiDwvl8gMqkHr/55nWsKoJFX+sLLtqV8+KIM8FiQnEriihPFxuUxSk73FFTM8LrI6PkKMYoo7pa8LpHZ/B06fTyOi477Lp1f6/zi1uLFuFourQMH76Rb2pX8w7XNWACruOIkEjwFRu1CYl5ild3VrJzkrX84PTbLWCcCVNJ02yPJTzigypiuznWL5Os/70j9YEw6G7gPQXrxd04/67f+bqzKsB1HCplGMtI4Czq1JkR5O4xHJogCTff70zkA4yCVUXDEmGBj51A0OvcN1PsttI+ydfi+JUrxVYQLJLqb9STuLDJggUUAwNdPgex8J9GQ2P1ZKdOP7vOPAjRSaV4FD15V/0PBY4Krna6pWxNyYSEKykHhX4qVI+8Y39srQUu2deE0dKy+SQVBXEU5/dYSTOIMu9h/apBizRAxlto6/rGSqSuu3IiR4eZbVm84Kp6F6NPaUjZhLDLMlJ/LO5MykVXHVD1gk5zVBQTWaahVGfztDDC+6H3MpLl+6safxvwgMVD6c8WylTKMEDK9TpDAV82nUoZa/k8cwHQeC5QLh4EqP49F73hZ/T3yF6++H8elbqugCV0uKCpmWB50MTa+9hYHh1m2F1IeEKWEgebMXmnh1kc1JT4keJZ5lmNCEJfenCxA9nrwp/Ef3LeR2ZX7
 gqQ7hnVV
 0wxGqPt5XvthDs24TdON20aI/CazzazFNmBzn65bgah6ZhtVP3hHwFkU/AtVqI2abxOJ4s1fPYuk/+qq8WgQGoyxEz6E9SvB7mW9VMhiFGhQMXhFYJtDEnRi7oyATZziie0OXZn+ritTiCLa/PWaJcfp7GY/3+NSEPfjqMRHst3QbGEO3u6RqRDbs8fVZsWRSKj7mzHu3Yqy2utuKH2ddb+9N2iB+KljX5XAAUz5/Aq7Sb4JSaQKjIxFEfxFxwVATyR9ZB3o+SHUGZtJcsNjor9ETEb7U5nDqkiDIF2qXwvT28RYAZZc7oLGRZDhxE2sanFbjmIo4a8lJHw1GCX2hnACl5MUZ2bur+ix3PvijJAffyq5L/FaN5aIWwEH0VoMU7K/cBABODMD6lZXv67f3gCSx49n2t913eOPvNnCkX/kEVrfV3MyTsdbf7pZRwGeKheOsWAll5iXEkeW40J6S/vroCX49vg1Eak6vRUi1+lowS1C0A3HtApsEag==
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
 mm/mm_init.c | 64 ++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index eb53c327210b..30d3125951f0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1124,41 +1124,6 @@ void __ref memmap_init_zone_device(struct zone *zone,
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
-		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
-			   *zone_end_pfn > zone_movable_pfn[nid]) {
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
@@ -1208,6 +1173,15 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
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
@@ -1222,8 +1196,24 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
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
+		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
+			   *zone_end_pfn > zone_movable_pfn[nid]) {
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


