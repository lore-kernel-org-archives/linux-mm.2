Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5FFD262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6306B0005; Wed, 21 Jan 2026 01:49:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54036B0088; Wed, 21 Jan 2026 01:49:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36026B0089; Wed, 21 Jan 2026 01:49:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0F86B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:49:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 492765AE3D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:49:00 +0000 (UTC)
X-FDA: 84355043640.11.9FC380D
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf09.hostedemail.com (Postfix) with ESMTP id 737BB140003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:48:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XjjTNHFX;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768978138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QfNI6YqTs0cYKPLMD89dgBVnDvHEsK2S5AP6RZaGePE=;
	b=LGBWbohn+WgGvr/i3+GND23xphil533TfMPXuUIp+IU4ho1xzVi6OJRT6oChoDzARSwfs1
	4usTebZoO5bAlGZRjRy4JpSAhONK1++wPHzaD1mJXcBVzulmX/c9T5Hc1Q/aNCd+2JgeDy
	miLRpFT6uxEZnGy8dmnSd9bu1c+zhTg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XjjTNHFX;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768978138; a=rsa-sha256;
	cv=none;
	b=6jRDAVd7QdIYnt90Td9CORxkMEvEUtn0gU158fZdgtxq44QqV5/cXKcrviF9Xy7bEEPbOh
	HW8aPYLB1PBubnJd+ff2pbfJkfv+5SJbHKGruk1BGVGKRRXxFnQPgzkqxc+TJCD+v6r4pN
	kxfVVTTKyU0cheb6Ca+Mt0bDr6rcvbE=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b6fd5bec41so3046922eec.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 22:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768978137; x=1769582937; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QfNI6YqTs0cYKPLMD89dgBVnDvHEsK2S5AP6RZaGePE=;
        b=XjjTNHFXI0veS5pfWq4y5gvN1zSHIS45BvFCMSlMST1SuCZmZGjdGt4twolbBQgMlI
         1UbciaTerU/px3u+k2lkmOrBhQIJtB5DSzuTnhMfxVV/d8TR8+sn/3xrAlR3NdCLTHVU
         i/lPOX3UZnSBR4ZyScCG4Oe5GnSZDzTW7fq9Q2uWChFhXou1zSGdk2+ylLxDG7te4R6m
         7y3vxCRZhgvK015+mJ2gG1/5FvIBVMn7jgFCdiVN5yuIxIAo4uY4zB7zPWw6F5ST6D1k
         TWngRJYtxMibw2XU5jFbbKbWTAMK9gcrX8nOdxLH6x4TDP7VhNLwxgdNCBwrDLPqKl4H
         w89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768978137; x=1769582937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfNI6YqTs0cYKPLMD89dgBVnDvHEsK2S5AP6RZaGePE=;
        b=PfWtV1s/AXMvA5aUSF4t1VhwCKjohLWMcElVO6vgn08dxpG1v4B+Tkl4gdiuDGLqhG
         HS6q1LVWTGQxxqwjyrY9FpoB/6+qVhECYGFjYEPeo5BjRLm26G/FMNIAKnygV9H6TthH
         vOhelfw4VuXoxk53A/bP0vVD0lPIHufvja5bFqYwuxm7d5mllpcnsYJ9OfxXHU5sefCt
         t1VpUD62o2yCOZF9u3W6LYLf99Us61AIwH7lv/iGOP8YNaLre63/GwahgxKQPSjMz/ni
         muB4omWlcSPTkXL1yXaS2SYwRiOctY1Yq9IBtnhBKcVUayCB63JmlZ7SaZONRqd18pVb
         95nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmANQUICfQ6HENQ6m2p47f2Tsrnc5neihcpAHzartvtCM2jmqr17fWVTg/BLChLo7yQL0gYU0QjA==@kvack.org
X-Gm-Message-State: AOJu0YxqVjIc91S+jo4QHmSUqfGdMHCVv8Tsfimv4nz01P/dFmghbCAz
	B0/XOPniMwxxK1FXCtAvjIKa0QzcQp1yZ6Z1sd06hvhyKZUaVpu8xJdR
X-Gm-Gg: AZuq6aK3IlSJkZXvXVPlvYzluJMjWEVGdThslUTNXljXxEKmBC7plN4xr1aitBGavRX
	kB6/7f+CRkamr7pQcw4OcD0ivepKR4/D9OL/F4ecQ6JzwIq5EcC7L9CsL0RZEAG87efnIVhAFbv
	yqSZY50cJey+q+1UXIMueKuBKilMSD5OFZER+ZKcppIGgs8iDbohOel63TQCzq2yuIC0exZuMgN
	cP1iaTg/U6LO/8f7Dnhz39qtYcxKhNUGQn03pC9M533Ra6mgbPUXU21v8NeiMQLRi+DHQfJxjeL
	8OJMiGX+UEYroYF6lJhhNCrIQahuWH2bWaT3+s1sEz/XdLnZ50CaydWZWSWvVw8DiPFfliWDewM
	vlP6/wvRo2KZ5lQ+PD386V2dc4BLFaRsHMLYv1H++nWULlWAa487a0b171ZaNswxLv6+N32PZCe
	o7vCI=
X-Received: by 2002:a05:7301:6086:b0:2af:674e:bc73 with SMTP id 5a478bee46e88-2b6b3f13902mr16692503eec.7.1768978137041;
        Tue, 20 Jan 2026 22:48:57 -0800 (PST)
Received: from debian ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b34c0e22sm19517053eec.6.2026.01.20.22.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 22:48:56 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	mhocko@suse.com,
	vbabka@suse.cz,
	hannes@cmpxchg.org,
	weixugc@google.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiliang Yuan <realwujing@gmail.com>
Subject: [PATCH v5] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Wed, 21 Jan 2026 01:48:49 -0500
Message-ID: <20260121064849.34497-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 737BB140003
X-Stat-Signature: cgtmmxek83w1ypa976gezmq4fpj43hkt
X-Rspam-User: 
X-HE-Tag: 1768978138-443436
X-HE-Meta: U2FsdGVkX18M1+5ylrQVmjzakZT6D5mB0cRC37OSVaFXLh25ObZTsYr7nNRHiBfcsYxhVXZ2CASGNAqpzT8/G7nUXAZtSeDL0DOPS6yQQrKUZv06iVYNxQQk2b/guvAl6AE4NIyGSMxCmiRNn68d0KbjGcPVzXcB4vOE37/99nkiFZOccnNyDsKg/Nl9nrCzGa79njvZM73IaFcPjyo0ytkzulnHEMZGG4KmCatPaSPHj/XLe8EsolVuhT6RiciTgyZqXfZhgR42lWSB9y+XUTq7wIU30J7Xdp1Ee2a9jqfbdfsXtvekXq+1harQjjuuqbnTlaotVKJtavNwwqh/l8mkq40fTWi7E67uih625Yh6sGgxc6l20BfPul/IyiXXDZP9QNBPOBLzsb1/2wdCtjPE75w7vz/nYKXkfu7S+KamkQCcou1trJcTAQg3TkP+SoBk3/HXj+ohcOcVnuP58H6ga+eBLqEiGdv7NHfNJtBZn4nqZLooSYG/EUOTyZ3/PCVxtXA/6Vl55teUFLZGek+uWdugzidShfqkU0FTVLYc3eYcW/bV77a9/rsAvt93ZCyamxNECU3HBkis6ls27I13oBg+2fBCi908XsZXWuZpA4for66OuZhXwY6NIwVviL56xCwegsbhEbfxbbCLrrHngvK7MMX5Gn0z8bhB30fpXgkkbKQ448+2q+mzYZioNYEcRx2EF9LyaeRxMr9AqfSTVWXZq5QsLOhLXjDrm/iRr/LhiX0jj0KSUMkvOb0UKXZlwfRLLekn1VjHxQUuofovx+9j+iCHTrnamGkXB2Udv5ylV2xZusvy2MX8IU0ru8xaN9eaL8t3wsEIFZdViZCCqmlgbCryYVCkvIYoBNg78RZW30By/0iuLvDYr7GM2eew+gCaia/yCvwZ/jmbdGMZ+N7hRE6+yHNxhN9ihb0q5MMVYnw5MH0LBWgWDEORwoclc9UHwqv07wT4atX
 62CQYTzv
 sXWXmQUB04grGbudUC5wzqRLYkFrPzq9qtTCfCjKTug18ePtQDoMbV+5AGX2frXghngpjqy9xTioYZRoHIfNuK9HC6BltZEvd5Sl9Q5AavMytKEIhnvbUSdKXDmfXlVNiTECp+usAvXiPvcJ+OslfkzClWtiG2FrgSzZdK3+iBRVI4Hd+Llsxk/vTG560kLNF8QTU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
pressure as they cannot enter direct reclaim. This patch introduces a
'Soft Boost' mechanism to mitigate this.

When a GFP_ATOMIC request fails or enters the slowpath, the preferred
zone's watermark_boost is increased. This triggers kswapd to proactively
reclaim memory, creating a safety buffer for future atomic bursts.

To prevent excessive reclaim during packet storms, a 1-second debounce
timer (last_boost_jiffies) is added to each zone to rate-limit boosts.

This approach reuses existing watermark_boost infrastructure, ensuring
minimal overhead and asynchronous background reclaim via kswapd.

Allocation failure logs:
[38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
[38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
[38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
[38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
[38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
[38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
[38535649.655523] warn_alloc: 59 callbacks suppressed
[38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
[38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
v5:
  - Replaced custom watermark_scale_boost and manual recomputations with 
    native boost_watermark reuse.
  - Simplified logic to use existing 'boost' architecture for better 
    community acceptability.
v4:
  - Introduced watermark_scale_boost and gradual decay via balance_pgdat.
  - Added proactive soft-boosting when entering slowpath.
v3:
  - Moved debounce timer to per-zone to avoid cross-node interference.
  - Optimized candidate zone selection to reduce global reclaim pressure.
v2:
  - Added basic debounce logic and scaled boosting strength based on zone size.
v1:
  - Initial proposal: Basic watermark boost on atomic allocation failure.
---
 include/linux/mmzone.h |  1 +
 mm/page_alloc.c        | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..8e37e4e6765b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -882,6 +882,7 @@ struct zone {
 	/* zone watermarks, access with *_wmark_pages(zone) macros */
 	unsigned long _watermark[NR_WMARK];
 	unsigned long watermark_boost;
+	unsigned long last_boost_jiffies;
 
 	unsigned long nr_reserved_highatomic;
 	unsigned long nr_free_highatomic;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..1faace9e2dc5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2189,12 +2189,31 @@ static inline bool boost_watermark(struct zone *zone)
 
 	max_boost = max(pageblock_nr_pages, max_boost);
 
-	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
+	zone->watermark_boost = min(zone->watermark_boost +
+		max(pageblock_nr_pages, zone_managed_pages(zone) >> 10),
 		max_boost);
 
 	return true;
 }
 
+static void boost_zones_for_atomic(struct alloc_context *ac, gfp_t gfp_mask)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	unsigned long now = jiffies;
+
+	for_each_zone_zonelist(zone, z, ac->zonelist, ac->highest_zoneidx) {
+		/* 1 second debounce to avoid spamming boosts in a burst */
+		if (time_after(now, zone->last_boost_jiffies + HZ)) {
+			zone->last_boost_jiffies = now;
+			if (boost_watermark(zone))
+				wakeup_kswapd(zone, gfp_mask, 0, ac->highest_zoneidx);
+			/* Only boost the preferred zone to be precise */
+			break;
+		}
+	}
+}
+
 /*
  * When we are falling back to another migratetype during allocation, should we
  * try to claim an entire block to satisfy further allocations, instead of
@@ -4742,6 +4761,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	/* Proactively boost for atomic requests entering slowpath */
+	if ((gfp_mask & GFP_ATOMIC) && order == 0)
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	/*
 	 * For costly allocations, try direct compaction first, as it's likely
 	 * that we have enough base pages and don't need to reclaim. For non-
@@ -4947,6 +4970,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto retry;
 	}
 fail:
+	/* Boost watermarks on atomic allocation failure to trigger kswapd */
+	if (unlikely(page == NULL && (gfp_mask & GFP_ATOMIC) && order == 0))
+		boost_zones_for_atomic(ac, gfp_mask);
+
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
-- 
2.51.0


