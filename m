Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6A0C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312E16B011E; Tue,  4 Aug 2026 10:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9926B0120; Tue,  4 Aug 2026 10:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1E26B0121; Tue,  4 Aug 2026 10:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E58A56B011E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:48:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BA361401C3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:32 +0000 (UTC)
X-FDA: 85063868064.04.6C6079F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 91681180009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:48:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KOfv4M7d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sj33KclCgI00dDNyPZb2XVJG6r1tXN3Oit5qoG8xUoc=;
	b=38zTtjfPk4vMUHztOaKIejM+C31/h9QmoRisSVyPOdaHFZHesPA78C3jtkyUlPkkj4ZPqI
	SOhSaV241XzEPgAtITb1OfbXk59qVUCVZpE5gmS0ItCD3vboyEIGO27Njcfp+Zq5LLUESv
	lULWps63txuA5T5Mhf5r0Zj6/HAXjwc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KOfv4M7d;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854910;
	b=ZlKT3j2MZZxS6mPawKyXxPaEhU3MlnkzzWQ+ttWkbZ5Os1U5N5SNX0eu+kVpx/+imyn97v
	nCOOWpCUOlU7v+osXp79QxM6u6uwoRHos9+orgBA9e3oqnPf0twbmD4mCdqDB1e2FeJvDN
	jhi5MEQigzbvaKZXRX2rDjNDg+Mvc2k=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cab973140bso59228015ad.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785854909; x=1786459709; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sj33KclCgI00dDNyPZb2XVJG6r1tXN3Oit5qoG8xUoc=;
        b=KOfv4M7d8rb7ZrNZnxM4deGQfd1QLESkqA91nVuUobRM7LAKHRyOY5sjmXatG79Svb
         sb+cX+IZWJaoMMUN2rFHpS7hpQLaw1Lsjarjaq4lcInWq0KL5ZL2CNULJbVVJ7PZIqcG
         DB17nk3qgVrVRLAmzRaFrfItIZBV0pimd2dskgwaA/GQ74LwSXxDC//sAgnMdojxsQQr
         mInFqCXPNaJLvbZViogJ1+Q2ADln7at5jS16gDVeAIKrWnoDDnYAKD3AJ0l07VS8bYle
         KxOIjMnBW1fPQ0yrPJbk79aLl5TeRjT3g71Bsf1B2azv31uDZwrPqJY2aDFdILWHY+1v
         /FiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854909; x=1786459709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sj33KclCgI00dDNyPZb2XVJG6r1tXN3Oit5qoG8xUoc=;
        b=FWPdWQGnoLgXTrMsvDKIYgUX2sxs0jHEe6Jwy8yI4XSiNQjBAyjRufYQON/HIE7h/l
         bAYJnv4ETtXwASHpJaFvZwZ/LzdbS4HxI6KGnuaiYO1dmBBRB4Yq++8biVr5fFs+38zu
         SRq27OhZpNtMiVJZnpoFDvX7bDPhFNprbrnkMoYZ8S0h/gon04LtH9uSs2q656jXkvRF
         gMy/rCGE6nsQKNZ3usW2EredkDhXQzEBvdP3dKBgRx9AdMd5Q4Ho3D96N6S1xIJ2yv8C
         5yAQbjhG6BLDJPK3ZTiO+5MmvxN1SmSSesXuwoX9kJh33qE+W5ZGVLbyLJBNcz12DVTe
         7Xuw==
X-Forwarded-Encrypted: i=1; AHgh+Ro2W8okxEckABMWt33zcrwOcAlHRiLa4elQs/NTkLQW+1p7b0lwIPLR/TzsrPeacp6vevMaESv4+Q==@kvack.org
X-Gm-Message-State: AOJu0YzTwTdxJx1KlfKGmn09nGXNiRf0p7hxNHJXXTJkzHDFn04ZSA1Y
	5dKjB1zYT0qFBvSkLDVThc8ZJov0xmsdE6Xj4PyBi6QzNFZaDmtoeiLinzIRxhIx
X-Gm-Gg: AR+sD101XJWa8E/ZFP9uPmflWOe3xeAr7XVxb9SRJQuQzZ7wPVAoS3eMc2E9akBxFPy
	S6slLEB1kDvLDS3KRN7krHd6niQ+WQqA4GhG0sbJ0JkCQi4NZr19iymMXmMZKk75kf3hC3hKDVB
	QmmAu4Kr2g3zjC4w49l8KXEFnTxqFULiwrnm4SAUj98CYYTYubZgVLE0M8CP4oL+OIdemn8HqTg
	xu/MRR546sn5+hiyHkYyyrQIp6pl5IN7/Cxv3MFc1E3xSf8SFe6dFD1R8NlN/YMnR9v8gLeRreY
	0Vibp0tCEH5XFx+KFSUpZYbwcy/pfhTV8zJysKFU1/fHoziFAaN4dKzBtM75VHeol0XiVdBw14P
	U34c6nEuZJ36K9pek9yndN//9P1609ju5dYqPMZpmcsy8j4klizW32xi07Kn8De1lNFpQb4Gvi7
	19t4a2JvtV3AbxOeWT5MRc6i4xtVZBL1wdVpuDs5/Ztv8v8AC4HP1441I=
X-Received: by 2002:a17:902:e950:b0:2c6:90ec:f601 with SMTP id d9443c01a7336-2d05219d40emr150964835ad.8.1785854909443;
        Tue, 04 Aug 2026 07:48:29 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4930e1sm8784175ad.41.2026.08.04.07.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 07:48:28 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] mm/mm_init: clean up zone_spanned_pages_in_node()
Date: Tue,  4 Aug 2026 23:48:01 +0900
Message-ID: <20260804144803.3290255-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260804144803.3290255-1-ekffu200098@gmail.com>
References: <20260804144803.3290255-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dp9hqbwruxb4o1y3694h4719ycydu48z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91681180009
X-HE-Tag: 1785854910-284205
X-HE-Meta: U2FsdGVkX1/g3hIbHIlfaqbJZVpI+JYTd3mP0K6qtMDh0VXHnoVnaH9ub5ZTRJZMA7vSU+I6MShUlmd1JvFlyeBj+cxTqMJncPu2eCEVHM7TjqNvHu0gPlynatyvbPTglUvkZDB2lB4+N05zSPph4Whfz2WFGCt2zhtjUMpyurtvi/9NadOxTFg9IwB5MuQrl/toiTkPAswOd6J3RXkAm/IvFb08KtkWvoqZRkwVeC/qBt3SKE7u8fAspGwCftH32baAw6JHPm/PRgasU7RtBOR9W/yOx4JyY/LImNAw5RuusSf6GJ01e4poBTxy4RB86LLS6R4iv0wjNBAa6qvsb05S+gERUrqqiAcVqOLbOKC9e9c4NZlFcV+CKAjeEmmJAhys34+VNwYUuRCvifY9NV2CNaYAwcRghqMcDUNSttv98gZ7A/uR3/XLD5vR+ZlOu4uCRW/HowWB5ZAW6hYfKkbStflXFAo5k9P3qBbCjv2uDiW8P2xN1bEa/4VD4iUcuwg/XwZ84xPj3oPwWHQ54gRC6XqG9XC18XpfXo/1fxX7AQcffj/3iDp6MLh3v+iXvN7bJrcVtoyv0px+ynRYXCRNuZMoMvQkUk6bd7qRymwAZJgZS+LVzTQ1EWvKdQFKc5etxSEey/nPFkrLlZTxAvtsifewJHIxbZZ76LKvG7WjnJx3QEpO6vHUGqpiw+V61VfHS7aVP2MNb+MGmrZCb01nSGpwaC0yWxgW88idj1PZ76j8X6/yGf4hcsT5v0+4qXnXJNv1tUaMBor6LfdR1K5h465Jh0t1q7Yb7CVkrQs+kNMMrX4im+orkGpH7Hn9Ssjd/R4KabHYlZON/KLCa2U4h7SFGQ/E6D3H5i2/AFoiuiOf4TUrSnu3TBswVFwwGc4TDmwC6oPGJe2OGJGIWROEaXdETROKvoNvu9o4UAhhtNcQMQRMwA3dHf/ucHEi83o+kbGDL+ZSggAtDLu
 TwYiXiDz
 EampU2xvGstLJro33RCiqxOhHwKwtlksBk7WMUrIieo2s42i2F0+OX53eMFv3XtXX4sgCvoj5fDbvmhDItAgr4PyXxOjiDMfKC/2nfT4jgIQcoWtQW4GCrpopGV7I9nQCTHeJM6vpvtT5HaB6IxqsJoCH+XSFP4cr0yJmLwzG27jZobgf+SAvzcWvQsXpW1MfKhBXTFPB1pZNOtN3dUI1Htm8Y1+D71hUJf90y3dvbddycaMyE83+aDhetm6u1o3xIImuRYJM+Ik386xGM0j93zFVMyozLUJmIlwEVERB0zP2i4NcfFjtVxVWadAtdLpj7t1tv0iBzkKQKxJuUhbyqbqfWfisprMDOlG8amq6vcjcrYFGhSMoMTVLex/49WBsSujLx9yvsSbDoJjcZWldYh5nEIpjfebsP9u5cdEIZFQJAz8+dbGgFUjYQHJkNm8TLpQBuCzKnbfbRLNsUuHrE3UZXO+ghLjNZ4SWr+7T2+20l6KVVXuOaRnwgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract zone_movable_pfn[nid], which is used six times, into a local
variable, and return early to reduce the indentation level.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1190a27ed0fb..d544eed2f173 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1240,41 +1240,41 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
+	unsigned long movable_pfn = zone_movable_pfn[nid];
 
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
-	/* Only adjust if ZONE_MOVABLE is on this node */
-	if (zone_movable_pfn[nid]) {
-		/* Size ZONE_MOVABLE */
-		if (zone_type == ZONE_MOVABLE) {
-			*zone_start_pfn = zone_movable_pfn[nid];
-			*zone_end_pfn = min(node_end_pfn,
-				arch_zone_highest_possible_pfn[movable_zone]);
+	/* Nothing to adjust if ZONE_MOVABLE is not on this node */
+	if (!movable_pfn)
+		goto out;
 
-			/*
-			 * Check that this node has pages within the
-			 * zone's required range
-			 */
-			if (*zone_end_pfn < node_start_pfn ||
-			    *zone_start_pfn > node_end_pfn)
-				return 0;
+	/* Size ZONE_MOVABLE */
+	if (zone_type == ZONE_MOVABLE) {
+		*zone_start_pfn = movable_pfn;
+		*zone_end_pfn = min(node_end_pfn,
+			arch_zone_highest_possible_pfn[movable_zone]);
 
-			/* Move the zone start inside the node if necessary */
-			*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
+		/* Check that this node has pages within the zone's required range */
+		if (*zone_end_pfn < node_start_pfn ||
+		    *zone_start_pfn > node_end_pfn)
+			return 0;
 
-		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (!mirrored_kernelcore &&
-			*zone_start_pfn < zone_movable_pfn[nid] &&
-			*zone_end_pfn > zone_movable_pfn[nid]) {
-			*zone_end_pfn = zone_movable_pfn[nid];
+		/* Move the zone start inside the node if necessary */
+		*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
 
-		/* Check if this whole range is within ZONE_MOVABLE */
-		} else if (*zone_start_pfn >= zone_movable_pfn[nid])
-			*zone_start_pfn = *zone_end_pfn;
+	/* Adjust for ZONE_MOVABLE starting within this range */
+	} else if (!mirrored_kernelcore && *zone_start_pfn < movable_pfn &&
+		   *zone_end_pfn > movable_pfn) {
+		*zone_end_pfn = movable_pfn;
+
+	/* Check if this whole range is within ZONE_MOVABLE */
+	} else if (*zone_start_pfn >= movable_pfn) {
+		*zone_start_pfn = *zone_end_pfn;
 	}
 
+out:
 	/* Return the spanned pages */
 	return *zone_end_pfn - *zone_start_pfn;
 }
-- 
2.43.0


