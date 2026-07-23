Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26142C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA286B0104; Thu, 23 Jul 2026 03:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A9E6B0108; Thu, 23 Jul 2026 03:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096D96B0109; Thu, 23 Jul 2026 03:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D28866B0104
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51E66C014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:07 +0000 (UTC)
X-FDA: 85019268054.17.62B002E
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BD30C000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=InFd2Wy3;
	spf=pass (imf10.hostedemail.com: domain of 3rMdhagcKCB0CR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3rMdhagcKCB0CR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IEwjjGUSei6Ojejw9AeCmT16n0CwbrOZSGJzNcMlIs=;
	b=T0EnfrabPOp30N3OuG0ZW1IR1ZsLatfKSBvsWPajxNX3SlZ1690zQ1ylS7LXNHi5s2/v5A
	yzD9fX94Q6agGzPHejqxA9TqbBILu5icvU2lm5I1ht9EG2tzE0OSpfpFlaz3GcTQxQPapa
	Lj1l5qxT3UDqrcyqZmzf10lww6bZy7Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=InFd2Wy3;
	spf=pass (imf10.hostedemail.com: domain of 3rMdhagcKCB0CR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3rMdhagcKCB0CR7L53L9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793005;
	b=VN+dvWMBJ+jHuGCVE2+EbxHETSQAOA7RuHeKO0rDw4HW1OIkkbntcJWXZ45Vb192YCMo3M
	KW5Eolf9fmVwKjP7NuV74DB5+uoB9p/p6p9EIJmxsz+rPJCl7X43918/pchQlXP0ZopOOZ
	KYLVrepLdLPC7wgsfBfzau1U5sVrYC0=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-381250979d5so470313a91.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793004; x=1785397804; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4IEwjjGUSei6Ojejw9AeCmT16n0CwbrOZSGJzNcMlIs=;
        b=InFd2Wy3YEVwv4utTLSYTlzMYTu5uBOIEa9FXPUME5KgWgv53kH4xHDhSukTfzALA+
         oV+stY3o8Zl7jnX5mLlQWuNHTFG0rgvoT1mdRJKp3nZMuAA+UKJdgTB8u2mIrPbw+Yta
         /4eQ0wLz08Hj9q51EQNmnRkyctmqMdA//cN51w0aep4vj2BhVL9O4kym/1KqveWAr7Lo
         GDM0hGQjChnr7A3w25n4aBSPkEE0omAp90jwA9YFQg1d8ZiBEA2IqOki8riXcHPcHyhO
         w8cFnMwM/ibGT9vgvAyQlHSnYDxvsYa6roYOH4oieppwJ2VEWBpoQeCA6OpRkn/T1YgO
         p1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793004; x=1785397804;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4IEwjjGUSei6Ojejw9AeCmT16n0CwbrOZSGJzNcMlIs=;
        b=fCFV5B6XbCeWbzXPuAMWg8emjXnnIUjTwnCaUnCzBOTASRtKbYCuBP6B/dPUJIU9l8
         C5SKhAoIIMNY4jvYzhVZuKoM0llkh0IYiO4K9pKUEKu2iT7ppLaAqw9jX+sKhqVCgSkQ
         OcbAhtDG48ZixdeyO0n/S1TBSCbG99jzMI8puJHz6OSHk8nwvjRM++YchhJ5JapVu3VA
         B5+Qrt3G5MdpKSrTUeurlXQ+TqbcdBDd0PyK20oLRom4WJtDL0k2OLNcPIc4GrP0Sgiy
         gKz1P7+3XG0ACTN6o2Kg+34AwA+qxS9ULIggbL+xr8YMYb1C9S/nXOxZUecb/jP8Jco1
         +q/w==
X-Forwarded-Encrypted: i=1; AHgh+RoYmyf1gLgJ6l2TATjLYTDWN5BC6M0kbvWlwa9KzQ3bLsheqAtHTWXbGuJHAhbYCFYUbYGD0IfSmg==@kvack.org
X-Gm-Message-State: AOJu0YzM39M3gqwzFtHz6eCXgyK9jTFk3fO3Cw2gZ6OZexsmOIYJ1NMr
	M5w35fmUnAtM51ZDPsm1yD5tiCc1R2EgJIn65klBOxRADAbnxFBoZY3Y8iOIN0eTY+q8aWv0L1R
	VItH0YAkJNQ==
X-Received: from dlyy29.prod.google.com ([2002:a05:7022:69d:b0:13c:e9f1:794])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc6:b0:38e:5ac1:9517
 with SMTP id 98e67ed59e1d1-38ec6495a0amr2170050a91.3.1784793004352; Thu, 23
 Jul 2026 00:50:04 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:10 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-7-jyescas@google.com>
Subject: [RFC PATCH 06/16] mm: Define function to create a dir for each page order
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BD30C000B
X-Stat-Signature: fzns3k3gp5pe38pcny36rnkdmu5xb8n1
X-HE-Tag: 1784793005-17954
X-HE-Meta: U2FsdGVkX19Z0lTKUj5yvoM9NNgDjh3htpQzXe0y43q0b50E2EKuVQ9yCsPg9hhKiNJDUT9XAzR0ZTNFpA8oLqClvz/XT0ntdyQBeeraMTOgO5/hd77skf20CpYwlE9//N8Y1Euwf6RgLtlTxtjwtzXeqUxEoKnQR9GE0IJW7nppBbUOST6SyiGsF6Us6h655PXspbcnieZp4qOHkF6zXYVgQkv5aMgAVCBYZmfDND1FnNlmYcTLnsaORZxaE3qgzVTVnKT5c86/MWZH57imGp02K1DUMK3xtn14iZqrM6uInCXL3ylNH1U1a+VVmWlIhpb5+3YnC/mtIdyWE97Lqt5CJjvBW/+qQOniKI8ha8WSEpGSD4qEg9Er96j9BMszvVHIAQqQxejvSnpkPWWHTc1E9P1FgW2j4mYHQJvSXowY/TZO7YCU/v+Grx5wpuxTx5Uxu3iOWx7+7HLSxRFXVTxU3SjICDqzkh4t77N0ECpQAn9MdGyUrTDAUutQyFWzCDfM2QHnu0196D5ap9JDgOpf6vZCkmm0I9HUnyM7NthZ/ikhlUMpT1aCwltRcf98hC+1jrRwfs5PZFcz/r2gvBN0bZ8VwWO3oYCBU0I/p2V3H39eTXk4xyBv9LCJgM+xPWpdPHEQxHU3iHv8ZVP8gQeBQftGTwm+Bfrm3D/iMBetSDOOe2996sDMyiSE6VYhN4TstYeUpUs8ajIzACmq5e6bdA9iTGgkYbm7izA4TeotGBhr8vGMu0XOcp6IfKTKHFFM9GP8Dha/73UURkSTJZCKTHyDvN7+S7XzvpnSXsGJPYrmnlO68bZvW3EzwK2m6XxwFoncPGesduudBPufjGuGb2jOj9RkNiB8RGnTJmHs0LK48kwHJ//K+OjdSkUaqOFB/y1ARi6ucuseEzWyuVGHCDnCB7CbmLWaGkgL/k69HbEuIQSJseKDOzhD6nvft4XHihN+8/xQrVkSZVk
 Rl9eqO62
 uYdJT8sddq9Fu4gGdicHCr99K3IXpF2xxpUWiqj/wOwCyaNobblVewQq01Ktx9RiVyguiL0JmCJRfjB5DAYIQSVH+mvJG+vfbYSC/L8MmHJO6JONX4v8UTPdIMziREkeUVxUIJx9JueD9q2MxuFD0vO5TBN58X8m7hgHA/5qKBmPpQBFOWEPQExwmtabsDa98L1GtNEKe5ZsK6z5wWc1hzCvGfogKBUtbj/WY4wuocmZ/tlaPw9rQWM+8mXBx2r3X4AgxRCuvqQV/6fK1fJ0XKdykKcYSlpm2zS8N++DPtOMcPcTucmuFbJvlBBxVBVBFw/WNwOHrgS//0SRUCi9KauMb4ke5ejr3ehMtB/Abk4CHPpk38HlDFSFUn/DOzfP6f2HLEZxHl6s4VBr5IQw6A0Lf2s9qxUxAuy5ZWIihYsTtDQd38WcJ6krxLgpBeHXdF2BvpFI3yLMuECXVVvnm1rXmLHHSmKhud5/kBn3IvNnMnHyH/hUHlR4kmaAVGjwUb1E6ssPbDh9xNQqbW7fTBDDGme9Z28Y5qm3+sUIFfW7OZ3pmVOwznwekarGsgKDWucjGwPylB3XEjzaCXHobNFACwZBT16bBTC44yJL+G6whaFhF0eIuo9hRIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each page order inside
the zone directory.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 1cec9ec5e35e..de86b8526338 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,6 +127,28 @@ struct page_alloc {
 struct kmem_cache *req_alloc_cache;
 struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_page_orders_subdirs() - Creates a directory for each page order inside
+ * the zone directory. Once that the page order directory is created, it creates
+ * a directory for each migrate type.
+ */
+static inline int create_page_orders_subdirs(struct dentry *zonedir,
+					     int node_idx, int zone_idx,
+					     struct zone *zone)
+{
+	struct dentry *orderdir;
+	char dirname[12];
+
+	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
+		snprintf(dirname, sizeof(dirname), "order-%d", order);
+		orderdir = debugfs_create_dir(dirname, zonedir);
+		if (IS_ERR(orderdir))
+			return PTR_ERR(orderdir);
+	}
+
+	return 0;
+}
+
 /**
  * create_zones_subdirs() - Creates a directory for each populated zone in the
  * node. Once that the zone directory is created, it creates a directory for
@@ -143,6 +165,7 @@ static inline int create_zones_subdirs(struct dentry *nodedir, int node_idx,
 	struct zone *node_zones = pgdata->node_zones;
 	int zone_idx;
 	char dirname[24];
+	int ret;
 
 	for (zone = node_zones, zone_idx = 0; zone - node_zones < MAX_NR_ZONES;
 	     ++zone, ++zone_idx) {
@@ -157,6 +180,11 @@ static inline int create_zones_subdirs(struct dentry *nodedir, int node_idx,
 		zonedir = debugfs_create_dir(dirname, nodedir);
 		if (IS_ERR(zonedir))
 			return PTR_ERR(zonedir);
+
+		ret = create_page_orders_subdirs(zonedir, node_idx, zone_idx,
+						 zone);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.229.g6434b31f56-goog


