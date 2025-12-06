Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D50D339BC
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 15:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0396B0006; Sat,  6 Dec 2025 10:55:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6911F6B0007; Sat,  6 Dec 2025 10:55:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F4F6B0008; Sat,  6 Dec 2025 10:55:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1356B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:55:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7ED21405D5
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 15:55:37 +0000 (UTC)
X-FDA: 84189496314.21.50607E2
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 31CD414000C
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 15:55:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6McB2IO;
	spf=pass (imf23.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765036536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8svgkf5k9hykANPOqA4bu5CMkkqiRkEaY+OOQpE+1tM=;
	b=RUTmkXCWmuYMxsWJjFHQ9lAVj8nUJlcrLKad/z1GEc+6WU5s1MJkYuYKeebkeMAlonjx2G
	fYXQRAHD53Pu63ngJh1wB8Mp9kfcCRkMdUzm9mrzd0+n5L5lPy9NspZZin/fcRwNxzTw40
	Tw7tupZUOU1Xzch8ff63poxpfK4n9KI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765036536; a=rsa-sha256;
	cv=none;
	b=NFsdP0b7xqW2QlKUPjIrv75kqWrzTiyQ9E0ch7fkzk2z5c2HvxgTsfpBN1nfLlffOZxRGy
	ja4yihUuYAfqtKxmzFlhLaaXbuCRYLaXTiRpz25LUKJp5xnRNiAaywf5b1VcXfEXjJT/aG
	JzDwN9R8hivm71AZjOxHuqH8IZXprF0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W6McB2IO;
	spf=pass (imf23.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-298456bb53aso42090645ad.0
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 07:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765036535; x=1765641335; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8svgkf5k9hykANPOqA4bu5CMkkqiRkEaY+OOQpE+1tM=;
        b=W6McB2IOlA5lWJzc49Cz9DmZK45AG9pHWW4jnBSFlWnsefcF9h3O7KpjQcOYWj8fNp
         84XcghQzA8cVK7ZvopLo9srYheh1Md0q0G8E53YqM80IdPoIixTzft/DWbqAkjS1lV3z
         wYnW6R5D8iPChNQKXwKzb6NmnhIJgDLayyp19c4LSDwAo6MPziP8d7YEJTyT3JkRf6pp
         ZqPJFVgP+KT3jR/PIpeLCIw5QpN9mvutAxV0th34iljkSY4kC4W7R0mw2tYK3iRETi2c
         ytg4bQMht3d6Qfmx+0PVEFqgm/I/wt1QeTKTk5qgdZ01FysA9Y8euqdVqt+64c1hXYLb
         p00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765036535; x=1765641335;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8svgkf5k9hykANPOqA4bu5CMkkqiRkEaY+OOQpE+1tM=;
        b=nfeloevk6LBLyJYlJ3i7j5UHz109gXim2DbzyG7y3s39hs/6zXQZNb2RHjFhmqL0es
         EVHg/snOwGRK3rhQJboXPd8VhbdSmeSOPq1K4bPzSymROxNiVv++77biPfwOVJtcFv7S
         oQro+zP3y13yuCe4SFdMg7j8dLO2S1MiIFdBq2m3OBOWT112RPgBSAOCokxVXj8LsPms
         JloPQT5f9Fq9OpNfX4tksD5LQsJCMaEJaER8/emB0zQ7rofk8ibRQCpTo1E33+FVNiMj
         aoqZMBlBV4A6Q2RSbS9+yAPmada4Z4Uxj0twFuVFL1PiUEy916NwxYqMomrR0WyrckGZ
         XRcw==
X-Forwarded-Encrypted: i=1; AJvYcCUUjMfBYVmaSM3IZBAUxOUUuYbb++szSwLS6zSLvH9D361RbsKThtX33nPUSrVYobd9Bh6Nl2rKvA==@kvack.org
X-Gm-Message-State: AOJu0YwutCUPRS2GE0sYMby56Xw1BFfeqIvr4oQHQDKU1TUAH3abQgfA
	bxD8gemDn1T9TS28+paQhsnT3xdjC3lnofEIop09G8Be1d+H/fGB4BIJ
X-Gm-Gg: ASbGncv+ozhJrRK9vk0TxCzxjysdHsVtfuKcDkycgavX2nFmdFr1ewkkcX9Y6Hj+z1F
	0XVXDTVgYwOpzsrWaAMZSzal6cToP26SmKpI4yXeSjZPZL2/Ce2E+pulygBQecCuNFoeenZsPhm
	vXUJNTCae8a+zBgMbjBmlqFJTDbmON9/zQOK7kYKn5D5MwLlehl88DQpDsb5sf+TLyK0taX4ilo
	XdeT+kQUhVMcxG2hhT8cnQNWEgFQG3zibjRZmbe/OelEMN5wTHKUI9niMW1/CFve8Az66rmPmkT
	yH8Dh8H4SRkN0Cu9kLSeqq696tbeBR6vpEdF+InlpM7wkBGFC89AcFvyzhfAcuEVtY9ub2F7lDL
	A/KLj//J+Exy5dW/w62o9QU304Aufp/kSkuILXMDsyjwYD6z+HFyWCVDuY5nez8d0iKABhYTWYo
	k6pHMdS7OOOlmS/0nyc7c=
X-Google-Smtp-Source: AGHT+IGcibiXjgN3pirHA6BiALCM8gpyUnD/IO4wpVviy21vWvLy9TTW9ZXgimz2WY8dDzOrXdKk2g==
X-Received: by 2002:a17:902:d48f:b0:295:62d:5004 with SMTP id d9443c01a7336-29df5695ff4mr24346885ad.26.1765036534848;
        Sat, 06 Dec 2025 07:55:34 -0800 (PST)
Received: from LilGuy ([2409:40c2:1158:3276:f6f5:8cbb:933c:2c2d])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29dae49caa4sm80281445ad.15.2025.12.06.07.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 07:55:34 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org (open list:MEMORY HOT(UN)PLUG),
	linux-kernel@vger.kernel.org (open list)
Cc: skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize online check
Date: Sat,  6 Dec 2025 21:25:06 +0000
Message-ID: <20251206212507.135503-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 31CD414000C
X-Stat-Signature: razebjto4axdap8j6tk1bizeccnf6u8g
X-Rspam-User: 
X-HE-Tag: 1765036535-925917
X-HE-Meta: U2FsdGVkX19Z1s0Pl6T5KafkPSQDBMFavucIFnqqglivouklVkYa5dEunDpOcJOsP/gaT+uhiwoSFKxIjAGQ/1Lp35SWIvAVxFd4tUn8aNpO1332VnbcBgPbz9Y6h20l1YXyiNDAacTigPEsY/wfahqLWpeqKcMQc+VpietDrQTUgv2APy3EY907j50DG7jBXI5gfhCK2daY6mHSvPlh/pTMUuDlXDyuX2NlKXyopQP6yhSjG6gF2eYtiL3S0TYA5x4iKJUdqeJyp/0aWyLIY6xVxwiWOKC4+SiTMEY/Qh8OgrnzLcKNyXDhcG1Fcucn2Voifc/OiPWTguFLmz7tZXj6Gz4I5yiYb8cH2Wl27C24P7hRsVD4SRHVeHLQzp3P3vrxVX8Lq4i6MiyaGsmBB7YnQi0rtPSpzcx7c1q0n1SiGKiKlIlhsxYdXCpvTTyc6rBvcR0GFNUV2souJ1DN42zxXGyIrH/axd5IQ6sXzkW+w8AiCGEYBHzRnz8wVKGcw7mOsHlxm7vzCfuITXmsGyOo/Ytsns7nyNBGsoI1/epSnwclVckfVX4j8VGkWrcTzVJ2iJvLlq/T34hS0lwZRJrl5lFLq0LSKFvPYSSGVtAa+7LIi7hlaYrP1GeCdd9lNxBOpNf7ykAqKBw/z7uGYOR5wYdfZQJNxRJWR185uX8GUwMjl5iLBWDFPgp1c5IHg1HIEwCOCgh8g3uWQiF49lBTxHJEbRQ75Lskb5UHPvQwY0ShZFH/k5wyOC79EcFsa14jzmhYuIIWMUE3ymIXwltlE9Y5se2BwzO8RpsygBL8BDNCxJwpzl6mgxgKGtRyluZZcKN8wCwBjjNuz/8QCAX7v/86WCjtN/w7H6EORY3K7h3d4+a+RvfVxBcTs+a9g7WhS5uBzkg5ORjqyiIShoqYZjd5grtViSSvUSO5KAhPW3uN65g4KR37DlM1uoRa0Zizv8j62Wh1LoGgkIE
 BXOuGhvR
 IK0wQK7pti6AqYXwnI9dhxNRfT14aQ1l7ssJ5daNTkzgn/hHAZ1n7sJO5lSf1s0XPNcLvAuYTzgu+lEC/ZvCVtogYjYEq7KBMBc9dTCBNVLKIalYXmi246l9xGUZBQYq/wMj3BDvnvuW2MZ1qvTEboo43UqUrkxrkwbKlKEQ23pUeCWuJ0+RETf56WTz+hfN6hxrLaGAnoDZZtt+I3Kt3zFByWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The auto_movable_can_online_movable() function currently walks all
populated zones when nid == NUMA_NO_NODE,

Since adjust_present_page_count() is called every time memory is
onlined/offlined and already updates present page counts, we can
maintain cached global statistics that are updated incrementally. This
eliminates the need to walk all zones for the NUMA_NO_NODE case.

This patch introduces a static global_auto_movable_stats structure that
caches kernel_early_pages and movable_pages counts. The cache is updated
in adjust_present_page_count() whenever pages are onlined/offlined, and
is read directly in auto_movable_can_online_movable() when
nid == NUMA_NO_NODE.

Testing: Built and booted the kernel successfully. Ran the memory
management test suite in tools/testing/selftests/mm/ with
./run_vmtests.sh - all tests passed.

Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
---
 mm/memory_hotplug.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 63b9d500ec6c..ba43edba8c92 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -50,6 +50,8 @@ enum {
 
 static int memmap_mode __read_mostly = MEMMAP_ON_MEMORY_DISABLE;
 
+static struct auto_movable_stats global_auto_movable_stats;
+
 static inline unsigned long memory_block_memmap_size(void)
 {
 	return PHYS_PFN(memory_block_size_bytes()) * sizeof(struct page);
@@ -851,9 +853,7 @@ static bool auto_movable_can_online_movable(int nid, struct memory_group *group,
 
 	/* Walk all relevant zones and collect MOVABLE vs. KERNEL stats. */
 	if (nid == NUMA_NO_NODE) {
-		/* TODO: cache values */
-		for_each_populated_zone(zone)
-			auto_movable_stats_account_zone(&stats, zone);
+		stats = global_auto_movable_stats;
 	} else {
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			pg_data_t *pgdat = NODE_DATA(nid);
@@ -1071,12 +1071,13 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 {
 	struct zone *zone = page_zone(page);
 	const bool movable = zone_idx(zone) == ZONE_MOVABLE;
+	const bool early = early_section(__pfn_to_section(page_to_pfn(page)));
 
 	/*
 	 * We only support onlining/offlining/adding/removing of complete
 	 * memory blocks; therefore, either all is either early or hotplugged.
 	 */
-	if (early_section(__pfn_to_section(page_to_pfn(page))))
+	if (early)
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
@@ -1085,6 +1086,12 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 		group->present_movable_pages += nr_pages;
 	else if (group && !movable)
 		group->present_kernel_pages += nr_pages;
+
+	if (movable) {
+		global_auto_movable_stats.movable_pages += nr_pages;
+	} else if (early) {
+		global_auto_movable_stats.kernel_early_pages += nr_pages;
+	}
 }
 
 int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,

base-commit: 3cfeff1d2304237b1c14628d695a6df44daff48f
-- 
2.52.0


