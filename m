Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B66BC5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 13:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6EF36B0311; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45C96B0312; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D344C6B0313; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB5466B0311
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:38:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 344A080112
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:38:03 +0000 (UTC)
X-FDA: 85099978446.14.42FE6E6
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E0EBC0003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:38:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SFgxG3lB;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786714681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/JrFNgP7KAnnpbgz8+ogMO9rc4uMT0klBiW388KiSg=;
	b=d4vO7CBnTqbF1Vwt58eGo7Prn5qR7kLzlY37OPj0Uqbp/7//f76W3YlOSgSVbpQ86hx/SB
	xx2in5rU5q6nBCveInlngL/qo7miIKGSB9dYNrRpJetkVjPLJYjnCT8nkJDI88z5bOAm9e
	MJDZPaZIoe7stJVfO3CJqYmzoaITl/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786714681;
	b=iqAkJhHxtLr2e9mU+UroEDDiZ7a0PFRztPSnW4EPAtLwtjUn8eNKxgIRVcQUrNw2sIuena
	Mr3Ubas7Va2Hfy1iVqPlqYs/VSj4ltCoe5+cCEPim5fKx+DN8lCoC9xVEOA4ICID8MSD48
	gaEimBSelfndBO6xblc+YL9j/oJipas=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SFgxG3lB;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d004f135b1so13349535ad.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714680; x=1787319480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/JrFNgP7KAnnpbgz8+ogMO9rc4uMT0klBiW388KiSg=;
        b=SFgxG3lBp8c+SSVL+qjehewG97aSZ1bHx7A91gx3GEww4k8vAgRmzxtIkKAPlMJnL/
         v+323dyqWCHu/9FgRp5y5m8/KfGoDbwcQ3oVelCmjySxkUghkiN8kgbDadvGXlHoP1t/
         7fxhhhMbIOoD6ONNpDNn/58ZgLrqWOpERJgaIoquYEi2z6Ly4GrXKTWNfQDKHHSYlIpK
         jH+IahcFXDjARF4bOZ04+Hv47pTVl0yCRIvgSfFtnOCEMvwdoIFZ+9Y8K1Q1qZX05nzB
         kNJSGYfZ2siBOzoUXCfEV9CdAiMZ+5cxeWiDHBGUaLKGuk3eoRDRe/f4Fc3I2RLkKvUu
         /JWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714680; x=1787319480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/JrFNgP7KAnnpbgz8+ogMO9rc4uMT0klBiW388KiSg=;
        b=VExcthTpSA1oyz3VMuJ2zI2AKc4qu8o9dlSSV57MIau8tb6Q9IiY7AkErSMqQXqaWU
         SEJIsmVzFl5bsNxBSzfyEIPOimKYykek/K/3rButNr2eG7dKDg72cCgsf48X7ujUoWiG
         2zDaKaHb6iamJMWH6wUD3ivM1I7Vn9psqjt/YtdlvjkQstOLdwMKN7l2aTPMZi2QuGPL
         MeyduOoBldo1+WKeBtZRWLTW8VLwGesI7tV9RiiDbXnFLltBl+Mz0T/xjWip1cpBgpKk
         x665upafam+P5wsRh/n2aHx5cfkDryIa9LXHofvEQkQRgSJ8Jov2usTvg40oys8iyqGf
         O5pw==
X-Forwarded-Encrypted: i=1; AHgh+RqlBBIXLAyuxi12kjeHHm5AXN7XPJMVnTkia0lP7CzjFYP0BfnJpNKZyDnUyZ97cIU8PFAmsiyIxw==@kvack.org
X-Gm-Message-State: AOJu0YxM424yjynyeWrXMtk54kWUyVo0apcuwUj/7KlXecVY4/iSoSFU
	Xl2hQsdd+hBZxSM0IVHOhfWj4T4N83g7H/F0QFhcchC2+xX7mqJWQxJc
X-Gm-Gg: AR+sD12D4AOigAyirpmZFl1Frpd5ktpAWQcM727jfBkdh041GMisSh1m2IO3OTvXuC+
	BJtnoYi6YRgcQzXdh8DgD+w/Yb01HMPRPHe88NDgEh+l5jg73dGsxqaLZS1ZeYG7Fh4q939+RRl
	0LiUx82+leXcxL2Kmfwy9uTMf0kDNLGcUNhVVA+A8Np7b455EaKJhk7uV8AgLHQ/CjKG5VoWoln
	f8QP17bFlQZSzX7QWwuuw7wFv2F8sSW/fRUc6msbDLNhig3wbKFiUxx0q0YdI81HUWUy/IrFv+k
	+2otyuFa34hws70+2YhYeY9SWfP4JyiCf1kSv6x3lZoBjrZognuKTs0zdOsdE335m4g0HzRmpk+
	q3dhfdUKYVMeZ5Fm6ZkYZqpWLSnhj+HzwQ/PwvQ4gN9HO2ajNlIk5SbRprjOhRL6r/lGBMF7Q8h
	ZNW1dclq45Nl8KYSm62gtlymP8eeZjN0Z2wwP/aFrxP4scqHiEPukE8Bo=
X-Received: by 2002:a17:903:37c7:b0:2c7:f2c6:89e0 with SMTP id d9443c01a7336-2d3b08053b6mr72313705ad.4.1786714679940;
        Fri, 14 Aug 2026 06:37:59 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3ae79f0cesm10029415ad.18.2026.08.14.06.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:37:59 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/2] mm/mm_init: fold adjust_zone_range_for_zone_movable() into its only caller
Date: Fri, 14 Aug 2026 22:37:38 +0900
Message-ID: <20260814133744.2746782-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260814133744.2746782-1-ekffu200098@gmail.com>
References: <20260814133744.2746782-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w39wrkmc66eiuch4ssexswfw9u73ah59
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E0EBC0003
X-HE-Tag: 1786714681-511346
X-HE-Meta: U2FsdGVkX1/faaXDF5+nTLqgynTOz3BL4OHvtOPBTPiOdYMtFW2jXNkEg46bh9oiiMM78km6XhI9+0udQ1A7icuOhp/sr4pYhd6SaMk2ceJWiAgM4BAaiNyeWhvTa7k9CeWGNlQS82speGKxCDXa/o7wV4dU06+JtkO2l2lzvwLXxGhg3UUMj61yOLtzyUaXJr3PQ8KrF1B0rvpL4puSv2H91Z++IALaUKYbbYUmnW1w91K127WG54CXFzQjZ1PesuujJZJs3svzeEgHgDlx9+CMaPmEIYyD/jtIRpr1xHpyNibNtBKK8dFhfu2Ed6liGgckeAmsrRgwjRvALqGuypx5on8nX/7bnHPcwcs5chqUcQuJfglYr4VULTLYnFM3kiRlKgH4+hz/xCYbwaCoLHd7QDndNmLyn2IzqW76fsOJJN2m9KLe/BElcki5FTxUK27mmIGYah298surodiBRakVr0xwAEgETaNo1jeF3IZtItY5FWQ0sjl9Xj4OSRlgZCU/ph68bV+qKoaQKir6LktQF5swgvCs0tPnvtR8mO3R32B7gFIIJacKzOh5cHwH5ukEPw+bnodsXKVOl+DdvvCPffiQlIzFU/w2XUXIefPu+o9n5hyNBalsEBFScsRZb/SSzCAkbiBKgjGiwx0TyCpv5C3N00+w0NGlqSgmfUFcZ+At3Eax+vNXHK81EbuPqJP3AajRa0E5jSqbhRmC8sV+mVrq11MEMQyDiXH6Fm2nfV+C7QBhpMB07VU/us430RukdEgNE1tQcCrIZCuWH6zIBcw6chRmKAPzICeRPDee6CKzpSKUC7jWIJICtoFwnroe+XOxInfAUeX3Nqm47qfXaKMzKDhj2FHdUllU91tVnx10btBoqmleYq1UkGWuCeNlO/0mhmyIv5k2vGFaO3CnSoIDvvCFms/2jDtQz3mHlXzoSTi32XRrU4eFejIXXWWMzjDUeEHVd6flw8J
 1w7uWmQb
 OMfSRtcPD82szdhlnrV06UUzSk/iDV7EZX2mlqsv+iNOQ7ftSC2I9yPqtqDV+9+1GQYdZm3ysakE6ttFv/h/atYjwmFzwdXaZ8UYNS5z5VG23DOzmOd18TPYLXDxh2TTnUNTkucGUfxZvIBLuwyrGv+3ynR7jcT7KuvnFPWWoHOkspAed6qKvrXdsed10fIObVnp4njsLrmHCTWD72973FfmCn2XCfpamsnV/9eeDxjanE2WqpduPJ+cRom32SUl84/y5I8iwdDZg0eSgK4Hz2wvdavFF5fj3Xwe9EOu2G80pMs1lUburkRIsJijC2B3oGHcs7rhnnIBxPjSaVNTSDn7M7OYBUok9o4fAOsL30wBpzAXMlfNn1FBBhU0zlAzuUDVKy7XduJdfxH3gvC/1CPmkELTiYGNm8txet6nvzF1ydEE94StEwpRk5dZbsYaYvRIPdux7c9LHea9nmdBp7snLfjJtuCILiEmLKcPkbAHPrpCOWM5AaANZmQ==
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

Fold the helper into the caller to make the code clearer. Also extract
zone_movable_pfn[nid], which is used four times, into a local variable
and skip the adjustment early to reduce the indentation level.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 68 ++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index eb53c327210b..df67d4e6f646 100644
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
@@ -1218,13 +1192,33 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
+	unsigned long movable_pfn = zone_movable_pfn[nid];
 
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
-	adjust_zone_range_for_zone_movable(nid, zone_type, node_end_pfn,
-					   zone_start_pfn, zone_end_pfn);
 
+	/* Nothing to adjust if ZONE_MOVABLE is not on this node */
+	if (!movable_pfn)
+		goto out;
+
+	/* Size ZONE_MOVABLE */
+	if (zone_type == ZONE_MOVABLE) {
+		*zone_start_pfn = movable_pfn;
+		*zone_end_pfn = min(node_end_pfn,
+			arch_zone_highest_possible_pfn[movable_zone]);
+
+	/* Adjust for ZONE_MOVABLE starting within this range */
+	} else if (*zone_start_pfn < movable_pfn &&
+		   *zone_end_pfn > movable_pfn) {
+		*zone_end_pfn = movable_pfn;
+
+	/* Check if this whole range is within ZONE_MOVABLE */
+	} else if (*zone_start_pfn >= movable_pfn) {
+		*zone_start_pfn = *zone_end_pfn;
+	}
+
+out:
 	/* Check that this node has pages within the zone's required range */
 	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
 		return 0;
-- 
2.43.0


