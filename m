Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249ABC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCAB6B00A4; Sun, 20 Sep 2026 05:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4B06B00A5; Sun, 20 Sep 2026 05:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33956B00A6; Sun, 20 Sep 2026 05:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D121C6B00A4
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:29:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A6C74039F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:31 +0000 (UTC)
X-FDA: 85233617742.26.249D246
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 845E240007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:29:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M7hgrQYD;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896569;
	b=0qAL84YrbDfzitYEFJv/7+PhA3qZTbI3PGmUw89X/VqSYdr7N8iWN8EJmaDUsPFSWsT58Q
	L0osN7nn/rv05KeBgvNvJrcKnWZxZ87DbKgJQROreoNp/1fhstWzmIIwh7D/Os2sCmQjxg
	XkLdP+p9PAwHhmzLHLcvEyQhoer5RL4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M7hgrQYD;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxtCD6SnNu1NDzEpQGETPXmjrPB6bmHGJKpCRbMz92Y=;
	b=TCRr442mFc/UMOYEPXWe/fPGgF/P0YcFURUJ3APLGfJsdNCHOUg6ABjMyfMo3h46AldwQ9
	3aYapqykIpn2hi2KHS5n1xLdAtnqXtq6UkrXQzQCqWynLAMThZS3m7ebdHKw7Q/FfTlW3N
	plupu85mY7S57CoposmXFQ7Kf7xDF/Q=
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-39b2ad83680so915728a91.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789896568; x=1790501368; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SxtCD6SnNu1NDzEpQGETPXmjrPB6bmHGJKpCRbMz92Y=;
        b=M7hgrQYD53SEHIrCjiM6QoAx3b6n9coUqKAkYNHu7Mw9gCklyUHlm+pNaq+/jsZWKN
         xhWV/mpDbprhyghdTL5mwLgiYZmw0tApLMpqiOEVlR4Y+hkpng2bEtoQ677qM1tHAt6n
         SYnhAR6Q8Hrns/6YkitLoM3nwNKTpLN3/KYWfcbx+v5rdFq2YgixCzmvJw6m2rJhUBVk
         dmBC4zCrvz715Bn5Xbqr2ID3H5EuaGcMiY8Zap0I+4RC5wQWl3N5pwvE1OQTddsDCc6s
         KFZZNgCPioxykXq+1A53e3FFAgj04MUJVudiKYzQSOKkaPdzQ3gFL7WtQczz0g/XjVlz
         e9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896568; x=1790501368;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SxtCD6SnNu1NDzEpQGETPXmjrPB6bmHGJKpCRbMz92Y=;
        b=PnOSVyM+uiIxx94c/z71dIqbXwr6l7jK9AsWoWAbM2WmhlfTw7YPTdgeYMaGARiWkD
         hWKsTvSfM2CwDbNYFfduIb3vViwDFwI6vqbEbBflgg0NK2an3YZ5d7wB6q42AHA5CTmX
         8bVVXwLOrvm+Sy2/DVQ6MA3LAAHMCSGYqBMRKv71DbDem1JqOf0mc/k6k/0Oes0AJdNd
         LVNTTp+cCvp3J77MWJPs6PrDuIHHiwMpqoWHAj79u4ysch3nQ1bpbzXKR8Vo5e9ufeby
         fKJYmE81NbupJLxzF0o8gmskyu/3QtF6vQ6ODsqWtQI2Dwl1pf9P5rl8QWU3khEQdSMj
         C1mA==
X-Forwarded-Encrypted: i=1; AKwUvBzHxFgNaeXjTq19BM8lPt9imabS4960maY0TuRata6DNrd6/vON4xqIEB/5+08dFFUn/vQkW/UMuQ==@kvack.org
X-Gm-Message-State: AFuF++mDKxMrIs9GVPtSkUqHIMlF8Jzq1h20bNj725UB4gMdcRHrPkMn
	F0HaZUUFxKgYuFsJpQRa4gRBkKlRVuNF9Jl1h3fn5chI1zu6olFu6iO4
X-Gm-Gg: AYBFou1Hw+Hf3RVBjxt11ziIDRigdqMIh41TcCRcqJ5aFj/+JRKnxxe9dcML723NTGH
	9rssGLuea3B6mejXtnsl3DC/1R9fdDjhOx9O9dNQZVN65elACfa9qxjfNTha/OU2/9jyFEGbkeZ
	m3P99axsBwcUHrUPObYi94OwYnVcPFrQS6i3ox84wHBcgdc1ggiLVUhkia1if2mTfwKEEOm/nL6
	nb2eOpKeWQdRkAp+lGkrFSN87WXcTNC0Gym8ZC7RwrSiG4E48ZXcnzv/kum0rFbbeX9sieOTSqz
	zNM/r5ZyTcRd8fZP7wxpUWASoiKbQRHwJsv/UdIX6ukJZ1oWPsXt74zz98fA1T/VVHS3yqIJIpa
	7mst20k5TzpsZIxEtHreOqnV6EItO+uXDthrLho8SiNTz5lQ9heYV6ogIiEMJPIH5n5pbKerqM9
	/rPLOUllQTlGbxkUM9v92zD1pPCBd8dg8c+//C5ngGqgkcRitb86o5culBpPRoU1ha5bydsvbr8
	1d9sYNAfSE=
X-Received: by 2002:a17:90b:5787:b0:398:a145:5d3d with SMTP id 98e67ed59e1d1-39e54ce45c2mr19449286a91.6.1789896568224;
        Sun, 20 Sep 2026 02:29:28 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c64csm8154917a91.10.2026.09.20.02.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:29:27 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	m.szyprowski@samsung.com,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Subject: [PATCH v3 4/5] of: reserved_mem: reject static regions overlapping no-map memory
Date: Sun, 20 Sep 2026 17:28:51 +0800
Message-ID: <20260920092852.614973-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920092852.614973-1-chenwandun1@gmail.com>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 845E240007
X-Rspam-User: 
X-Stat-Signature: w69q9az1ue9y414wozuao6qujm3kccgu
X-HE-Tag: 1789896569-508567
X-HE-Meta: U2FsdGVkX1+FrFcQtE/c5mRxLJTGfGfGU2ey0E2JCAlGp1B+03xGKTDt9PLOkhbGx6Ki0G22eEbdJOgtll5YJK01dfPuKwXMvxz5A1rc4BPbSR1rVjWuzJZADykhufpG85hgn+Iimfmt0IK66e7kPn7GyvwHyMUHjHTnj9050ZUrKFjlgYXhTi70NAWvyGr2P8WityhpBvszygsa+S+8t05hFB5jEUEHbKwZ/TCKNBjnpK2FZJM1u+ieTJjyRPXR8+dZn4NM9xOW24cEnYGLWZ0uLJVVzvryJoafBH7xyuolTN4JC82lTB3uNC5hrU3kZvD9hlIrKXH3ZEX0NBcz7r26kUIY9zmMWrz52jCMldEtF8BA+1PbaXjElla0KIVnVIfPHILc0A9tQ6bqm9qfs3BugU7jC6CqHqcp6jHQxCKcvsh39g5/q1rHfNwv5i/kwLdAGyN7RjhWJzGmHrPTNlhPthG1oXwi4h/qUg/vbv2BFnZROzvhhlWIs35lZwh1H1FfuDA/Ls3dTKwgt2ZIIN6njtwxLTtxG40jVhZNQd6jObbGlek2oI8oyc2mAHOp+n4+zu94DXkFmpyA3NXtGwD1XOJI46r2BgZDZsiNjmJjg/CL4bkWbwR05WOhFKO2D+xKtKrcRxeuZd5FU0+jho9ENdBSko9B8yzyEe5cwPNu+PM3Py0g/RWMp9DKDuC4QUUVVDlTWi0eOYYCMG0awG8zIKeujx6wLT6GCylE8CHRBembz9t0mJY6e+hkjPvQsbqb5lYglvXFLG1UnlWEelQ7cb6SW6dU705a70UzVZRElBzhD1abWss2AeKo66UmF8ifB+2KWTxRA5B9ZfHotN6WSzAgXAUanz/Z6JjXN2ZbH9LlqDST0FzDltkyjR5qrNosdMT+8z+rT29xrKIoNHeazbxD3/ysW0vRGLIzv9b6vjJ8lMIz3VmA0x1cciIP3Jmx14VQeq3Vq1g6BK2
 HFtN6Tvn
 vJ94dL7zkM1sn1A6gKkXTV51xl3AsO6Qob67masscCyR5W5llHOPPR/4n1td3fLMOjQ3u6mtDFCi7B9PplKasSgHjuVKcwvDxSzJdbK3VMGxGUq/EKCt8xkaYcgcI8nXlPq84RYZww5owqBaPAKqvO2e07H8zXADoMqchd1oXPRov+x+NkoRzI3HwR895JqSPFzFAN5OCrqug5lCspGp82kggFzzqUYqOIlYwqLIn3veHWMMMz6S1vCQ70slv1ydEI28MGzAWWjMsks1CZi9KeXWTYM5qLKkvB415BGger2gOfCBOx1JJ1NxAB5McOD5g0Bkqwik4LU5+V6mVA/gIbPl0czf+LOYrODu4DyojnbYnxlDWxaWGoKt58MKl7nOa5fV71jgqNsVhPfCQIXYObgSBEGul94nYjAt8eTM+Y0sDC836QbUR8pSE7HldG/080DCx28t0/tmGEtIxw3CONKyWEz74Hm5UjPe7nf6XB1eOKwGOT6SrofeM0XZIgevxyuOGhxHm81w/2SWrXXUB4W2ntz3R0f2DOVHqG0+WVX0wUviilp/kGA5vKnC58vJx+N8j4xvV30zmYc0nQ1UrEmBQGHTbRlulDoEp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Static no-map reserved-memory regions are marked in memblock.memory rather
than memblock.reserved. So the reservation overlap check does not reject a
static region that overlaps existing no-map memory.

Both regions can then be initialized and hand the same physical memory to
different reserved-memory drivers. So reject a static no-map region that
overlaps existing reserved no-map memory, and skip a no-map region in
the late scan that overlaps one already reserved.

Sashiko found this issue in [1].

Fixes: 86588296acbf ("fdt: Properly handle "no-map" field in the memory region")
Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260814084718.29C341F000E9%40smtp.kernel.org [1]
---
 drivers/of/of_reserved_mem.c | 23 +++++++++++++++++++++--
 include/linux/memblock.h     |  1 +
 mm/memblock.c                | 26 ++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 3a6c6dbfd7b1..8d2057f2ac12 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -131,7 +131,8 @@ static int __init early_init_dt_reserve_memory(phys_addr_t base,
 		 * if the region isn't memory as it won't be mapped.
 		 */
 		if (memblock_overlaps_region(&memblock.memory, base, size) &&
-		    memblock_is_region_reserved(base, size))
+		    (memblock_is_region_reserved(base, size) ||
+		     memblock_overlaps_nomap_region(base, size)))
 			return -EBUSY;
 
 		ret = memblock_mark_nomap(base, size);
@@ -266,6 +267,20 @@ static void __init __rmem_check_for_overlap(void)
 	}
 }
 
+static bool __init rmem_overlaps_check(phys_addr_t base, phys_addr_t size,
+				       int start)
+{
+	int i;
+
+	for (i = start; i < reserved_mem_count; i++) {
+		struct reserved_mem *r = &reserved_mem[i];
+
+		if (memblock_addrs_overlap(base, size, r->base, r->size))
+			return true;
+	}
+	return false;
+}
+
 /**
  * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
  * memory regions.
@@ -279,7 +294,7 @@ void __init fdt_scan_reserved_mem_late(void)
 {
 	const void *fdt = initial_boot_params;
 	phys_addr_t base, size;
-	int node, child;
+	int node, child, static_reserved_start;
 
 	if (!fdt)
 		return;
@@ -299,6 +314,8 @@ void __init fdt_scan_reserved_mem_late(void)
 		return;
 	}
 
+	static_reserved_start = reserved_mem_count;
+
 	fdt_for_each_subnode(child, fdt, node) {
 		const __be32 *prop;
 		const char *uname;
@@ -326,6 +343,8 @@ void __init fdt_scan_reserved_mem_late(void)
 			continue;
 
 		nomap = of_get_flat_dt_prop(child, "no-map", NULL) != NULL;
+		if (nomap && rmem_overlaps_check(base, size, static_reserved_start))
+			continue;
 		if (!memblock_is_region_rsrv_rmem(base, size, nomap))
 			continue;
 
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 03613fa0c894..34a695542ab1 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -504,6 +504,7 @@ bool memblock_is_map_memory(phys_addr_t addr);
 bool memblock_is_region_memory(phys_addr_t base, phys_addr_t size);
 bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
+bool memblock_overlaps_nomap_region(phys_addr_t base, phys_addr_t size);
 
 void memblock_dump_all(void);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index d88e926e2ea5..58c9281e729e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2222,6 +2222,32 @@ bool __init_memblock memblock_is_region_rsrv_rmem(phys_addr_t base,
 	return true;
 }
 
+/**
+ * memblock_overlaps_nomap_region - check if a region intersects no-map memory
+ * @base: base of region to check
+ * @size: size of region to check
+ *
+ * Check if the region [@base, @base + @size) intersects a memory block
+ * marked %MEMBLOCK_NOMAP.
+ *
+ * Return:
+ * True if they intersect, false if not.
+ */
+bool __init_memblock memblock_overlaps_nomap_region(phys_addr_t base,
+						    phys_addr_t size)
+{
+	struct memblock_region *region;
+
+	memblock_cap_size(base, &size);
+	for_each_mem_region(region) {
+		if (memblock_is_nomap(region) &&
+		    memblock_addrs_overlap(base, size, region->base, region->size))
+			return true;
+	}
+
+	return false;
+}
+
 void __init_memblock memblock_trim_memory(phys_addr_t align)
 {
 	phys_addr_t start, end, orig_start, orig_end;
-- 
2.43.0


