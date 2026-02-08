Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D659EF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99C46B00BA; Sun,  8 Feb 2026 16:59:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45956B00BD; Sun,  8 Feb 2026 16:59:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850CA6B00BA; Sun,  8 Feb 2026 16:59:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC606B00BA
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3390C14067C
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:28 +0000 (UTC)
X-FDA: 84422656416.12.673BD8F
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6425B40006
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jm5pEtiR;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c90iUpuT0uTrBpR1ziQiggNR562GhjEZFfLgw7gtP4Q=;
	b=OZLffzWNWk/+EBExMYYM6cEzFYs5u6xxBz8GxH7y/nq2itgqoO3V2sheOswnzeQxQU9Hnu
	qQvzO+Gp1aysG6PwDT6jEmxfecBK5q56Ema4Ns2rW5LqgWgs8k3IBiPqbC1Yt4DrvqyfI/
	Of1CNeVKHgjSfT4QZH5/wpW0AxMXhxE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jm5pEtiR;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587966; a=rsa-sha256;
	cv=none;
	b=fCW/ADG1vCX9UeRsdiNj+YMIT8XOs0GTryjMt2PG2ZFrabX1aTmXHIvwUw3x5KP1NTBqRJ
	kopStcTBbuyd3z9R5hhiJLICg3GukaZN/mkM3nrZWNsNRJuTsVEVzTLeKpzIVQSPSxMfwi
	iHmb2Mh5nY03CzjtgRl80WyaHXi1kWc=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d122733808so909713a34.2
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587965; x=1771192765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c90iUpuT0uTrBpR1ziQiggNR562GhjEZFfLgw7gtP4Q=;
        b=jm5pEtiRFLCGzj2h+bOZuUHouHbE7SLkpEgGio1W/ddPmXhjonSuY/kNZhD/Oco5Q/
         I+2fWyoJYye7MKauu82cg8s3WcLeQ6k0YrgyuP5QuRbXfdzpxJkVAfv6HHVTXeeuxkQa
         Sa/oiNevrVMtkKXBMC3miZQhSUSi7+WWT32Ok4ieQq25m0LIXpqBha8be0s5G4w4kz4y
         8LLTCgetkFr3mPVzUHKixKyGiLfppgKoinM33Pdz5PTZQmK+aA9APncMIMIczx4URxAp
         zbC8kK8m2g8Rex6i9XeVVUHs10dIIT0JuI7FXtXTyIXnWOYwJnTDbf8mAwy3uR4NIlvw
         GbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587965; x=1771192765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c90iUpuT0uTrBpR1ziQiggNR562GhjEZFfLgw7gtP4Q=;
        b=bgZIOaxYeG2k9IpSvIxKzsmNbMNbuH7bUj9wnebIZhm5xbO+/cfwrhKia357x7vw+z
         jtQ6FijZ+c9JaX7EUynp6xTTSBKzXXD8GL2P3vgIq6tUrtMuRwgXsMiFuEgnjEFg5m/f
         Q43msGRwAuDk397gW6ITROFhm8yLuIKdPAuTxvyIEv0HNWhcg79Mh3n2ZaYyf9U8he0g
         ar0KR7GqjD5ZNAgsMm1KoGn49HJaEqTUYjltZAFO/msVfp1tY9YYeYgVHZnhCrmbHTpK
         77ANQ0FGAxbFNK4+PtV1VqMxoqryfw/s9Mm/oTLxaRoYjMb4ZDZecCSKwurQRSYnqDu8
         3qxg==
X-Gm-Message-State: AOJu0Yy21S/Rr3bsI7rf0eoDSx79HLQQe2K6uaoHZ40kW8rGu5t4ifwX
	8sIgQ8rzhP/NpiGlncOxoMNeLZzJj+Pf7p1ZpiwAk3dbzuVadKjVzY7i1X0PRFfxaU0I+g==
X-Gm-Gg: AZuq6aIq35MjRS6Lq+YeQuU6qOOIPLZ8oYG+IL0Ut0PjzHbW7bZd/I5EAtwSbnKrCgJ
	yheYprq/n4mTLi9x8YFw0CP7yOzm+oQ6u4H7Lu6cIroOiN6C3/WuszUKCO7g/cDBX2+SAH1iJT9
	JnuLzE7kXl42DTMMfE6OIxIQRu8//D/IZyj+yvJuRo7dH32/lmO+MsXChP+zACXSk3gK8R99wKz
	WtZzOXfioAwmrLr9TZJAEsyn/aMjZxz3Pc0ioSEedGQY/PKQr+ToOw4QSbRhoY/mALAWoL8Vq70
	jHadaglR/EPqllgkWIqdQajP195jW10/B7EmKIyFeqlD3IBlJBTnsz0U/XyTIpSTyKOgFoONMjJ
	TdTeje618ZI+CfnMQ2D1Ulr4WgZxGDJAkv9+krbmf1oWoLwnJaoKLvcB7r6Qkm4xyQKkl9wg0SJ
	h5eH4IJiEtnxdDHxhc8aGmhtAHy16WM4kPnA==
X-Received: by 2002:a05:6830:6f47:b0:7d1:8ad3:ce7 with SMTP id 46e09a7af769-7d4643e7eb1mr4865896a34.1.1770587965213;
        Sun, 08 Feb 2026 13:59:25 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d46479954bsm6335454a34.21.2026.02.08.13.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:24 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 20/20] swapfile: replace the swap map with bitmaps
Date: Sun,  8 Feb 2026 13:58:33 -0800
Message-ID: <20260208215839.87595-21-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6425B40006
X-Stat-Signature: 6dacqs393rxwc4wdfgz9wah9cjhquij7
X-Rspam-User: 
X-HE-Tag: 1770587966-957784
X-HE-Meta: U2FsdGVkX1+++OW0YCe9O6WnlmdmugsyHby4y43OlKhc0t+v6/2Ni0+l0asTdN3dbO9GEplI8YTWtJd9WgG3yGDnDLI7W736zPUfCNwE8TbQuwJ7+4zl+n+kwzHdGJd1n3pfnPmIvUvwl9E0Nybrpb/eYyYdk6VhE7VdN+78z8T/xqcqlPqnp8wzCwhD9WtBoHJvhqrHiF31O89YDxB/rUVFNJUUOWfIJ1f7KlCns4JzQtC5DNDzgJKG2kTtVNEMJZh5Ot1Pq7nYRefMvQRw8bBvqQf/jcI8p14vXQBFb9PuUHrIYBI9uAcVo+YDeLIpjv6GlxM2/TxUCUbxuYYZgheZHsGpCj4XRHO+UWWLLWPq7qDqWFcyYyM9ZGsEkafN+tqQ2hpgE9GbgUv3zsFGS2CbSIaV9lBkNxs7AZmNIX9UeDeZTtoonF80m2prSBsu7giXt8LLnGPMw/zXebsSJHp6erWZLPBQSZF8+d34mcF1ItfVCXEpMnbXCkvyYwnTnxx8s4ANlShG3vEHXuxhJB0/d1tIiJlCXXW3NyOA4t5MPjiBRrYM/gkKifJjBG9vA6nTz4rQDo1sNdcOPEPzLEQuha4NRU/QOTvh8EbgLJnWAnKUso4iQPFJhYzmvxf3rDv9asyk3KI6WCngP3gfESRrwOBg3LDjo/qNrczYa0YsfUdUdvY9T9IgjYXIjIcDkigpNd5Ov4hy6E5RKQmiS3jrOSIZpK4QcyDBmFsDeA9ENiuJnnCvISK/sVhaQQwJVyv4vytz/ah03sprjte8ooXY7+40xpYT1I0hRtbO0kBDdQT3QnVaZcFWUeUaiV+9NN1YmyEfHxIdeYNciAgoMLOxamDkkgaBGdbvPvsflSMRP2theVH8DTSkm+9MO5mjMK6UD+mnOxqkL9kLiiq9i7lBGJ/1fcXOEjG1khu8lpLWhE+7hTtcd4iyJRRawZC8pnF9H4s+kuQKzeTA5PS
 aUKbez0W
 rtP6E1NOzCpAmi0WOhBj5A+YCCB6G/x3OjhSQ6unVJ+aHSSY6VAmIoVhWbFeqQGJckLX0FwOpXBvpEvmqt0o9RD9wFItv59nGHNVUjpLkA98Gp6zRQk1FyxHW/o5yFhreVdcyhPyn0eFWqAze1VTZnn6D2+GpK8MPgIb69qybIYgmMTXZgqV7YSxlNd0RDy6y2VMQZ6S02e/3Pj1sQuQ4ByxxrL4ZDyGv7cjQzzT6Ve0B3i9Sf+JVSHTxQUzE7bwakq5Ci/bq+AVPOcLX0DdpiEVcwBGRqXWHP6t6EKQ9TZMD3qpKtoed4uJh3s1qRiPPW4e91BIsqC7HQI469CIsfr85RBEaojCJKkYsJZYOfW36hlHGvUM0W1Fx+J83sziLUKZ41ckqIuMr+ncJKkdiQy7cf7ZaQN3lkl2VM0Gs40zlb1XtaBanv9Kl7Z2hynFUUTY0s8A5pBe5AgA7geRvMOnbFAehvQDgO3GhBC7OIGMJayK3OGGqhSbfgUI1DOwgNxoEue+Y3FskHflMSlW7DibVwpXUdlcVPUwi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have moved the swap count state to virtual swap layer, each
swap map entry only has 3 possible states: free, allocated, and bad.
Replace the swap map with 2 bitmaps (one for allocated state and one for
bad state), saving 6 bits per swap entry.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h |  3 +-
 mm/swapfile.c        | 81 +++++++++++++++++++++++---------------------
 2 files changed, 44 insertions(+), 40 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a30d382fb5ee1..a02ce3fb2358b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -259,7 +259,8 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
-	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
+	unsigned long *swap_map;	/* bitmap for allocated state */
+	unsigned long *bad_map;		/* bitmap for bad state */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9478707ce3ffa..b7661ffa312be 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -760,25 +760,19 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long start, unsigned long end)
 {
-	unsigned char *map = si->swap_map;
 	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
-		switch (READ_ONCE(map[offset])) {
-		case 0:
+		if (!test_bit(offset, si->swap_map)) {
 			offset++;
-			break;
-		case SWAP_MAP_ALLOCATED:
+		} else {
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 			if (nr_reclaim > 0)
 				offset += nr_reclaim;
 			else
 				goto out;
-			break;
-		default:
-			goto out;
 		}
 	} while (offset < end);
 out:
@@ -787,11 +781,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
 	 */
-	for (offset = start; offset < end; offset++)
-		if (READ_ONCE(map[offset]))
-			return false;
-
-	return true;
+	return find_next_bit(si->swap_map, end, start) >= end;
 }
 
 static bool cluster_scan_range(struct swap_info_struct *si,
@@ -800,15 +790,16 @@ static bool cluster_scan_range(struct swap_info_struct *si,
 			       bool *need_reclaim)
 {
 	unsigned long offset, end = start + nr_pages;
-	unsigned char *map = si->swap_map;
-	unsigned char count;
 
 	if (cluster_is_empty(ci))
 		return true;
 
 	for (offset = start; offset < end; offset++) {
-		count = READ_ONCE(map[offset]);
-		if (!count)
+		/* Bad slots cannot be used for allocation */
+		if (test_bit(offset, si->bad_map))
+			return false;
+
+		if (!test_bit(offset, si->swap_map))
 			continue;
 
 		if (swap_cache_only(si, offset)) {
@@ -841,7 +832,7 @@ static bool cluster_alloc_range(struct swap_info_struct *si, struct swap_cluster
 	if (cluster_is_empty(ci))
 		ci->order = order;
 
-	memset(si->swap_map + start, usage, nr_pages);
+	bitmap_set(si->swap_map, start, nr_pages);
 	swap_range_alloc(si, nr_pages);
 	ci->count += nr_pages;
 
@@ -1404,7 +1395,7 @@ static struct swap_info_struct *_swap_info_get(swp_slot_t slot)
 	offset = swp_slot_offset(slot);
 	if (offset >= si->max)
 		goto bad_offset;
-	if (data_race(!si->swap_map[swp_slot_offset(slot)]))
+	if (data_race(!test_bit(offset, si->swap_map)))
 		goto bad_free;
 	return si;
 
@@ -1518,8 +1509,7 @@ static void swap_slots_free(struct swap_info_struct *si,
 			      swp_slot_t slot, unsigned int nr_pages)
 {
 	unsigned long offset = swp_slot_offset(slot);
-	unsigned char *map = si->swap_map + offset;
-	unsigned char *map_end = map + nr_pages;
+	unsigned long end = offset + nr_pages;
 
 	/* It should never free entries across different clusters */
 	VM_BUG_ON(ci != __swap_offset_to_cluster(si, offset + nr_pages - 1));
@@ -1527,10 +1517,8 @@ static void swap_slots_free(struct swap_info_struct *si,
 	VM_BUG_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
-	do {
-		VM_BUG_ON(!swap_is_last_ref(*map));
-		*map = 0;
-	} while (++map < map_end);
+	VM_BUG_ON(find_next_zero_bit(si->swap_map, end, offset) < end);
+	bitmap_clear(si->swap_map, offset, nr_pages);
 
 	swap_range_free(si, offset, nr_pages);
 
@@ -1741,9 +1729,7 @@ unsigned int count_swap_pages(int type, int free)
 static bool swap_slot_allocated(struct swap_info_struct *si,
 		unsigned long offset)
 {
-	unsigned char count = READ_ONCE(si->swap_map[offset]);
-
-	return count && swap_count(count) != SWAP_MAP_BAD;
+	return test_bit(offset, si->swap_map);
 }
 
 /*
@@ -2064,7 +2050,7 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 }
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned char *swap_map,
+			    unsigned long *swap_map,
 			    struct swap_cluster_info *cluster_info)
 {
 	si->prio = prio;
@@ -2092,7 +2078,7 @@ static void _enable_swap_info(struct swap_info_struct *si)
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-				unsigned char *swap_map,
+				unsigned long *swap_map,
 				struct swap_cluster_info *cluster_info)
 {
 	spin_lock(&swap_lock);
@@ -2185,7 +2171,8 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	unsigned char *swap_map;
+	unsigned long *swap_map;
+	unsigned long *bad_map;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -2280,6 +2267,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->swap_file = NULL;
 	swap_map = p->swap_map;
 	p->swap_map = NULL;
+	bad_map = p->bad_map;
+	p->bad_map = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -2290,7 +2279,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	vfree(swap_map);
+	kvfree(swap_map);
+	kvfree(bad_map);
 	free_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -2638,18 +2628,20 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
-			  unsigned char *swap_map,
+			  unsigned long *swap_map,
+			  unsigned long *bad_map,
 			  unsigned long maxpages)
 {
 	unsigned long i;
 
-	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
+	set_bit(0, bad_map); /* omit header page */
+
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 		if (page_nr == 0 || page_nr > swap_header->info.last_page)
 			return -EINVAL;
 		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
+			set_bit(page_nr, bad_map);
 			si->pages--;
 		}
 	}
@@ -2753,7 +2745,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned char *swap_map = NULL;
+	unsigned long *swap_map = NULL, *bad_map = NULL;
 	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
@@ -2849,16 +2841,24 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	maxpages = si->max;
 
 	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vzalloc(maxpages);
+	swap_map = kvcalloc(BITS_TO_LONGS(maxpages), sizeof(long), GFP_KERNEL);
 	if (!swap_map) {
 		error = -ENOMEM;
 		goto bad_swap_unlock_inode;
 	}
 
-	error = setup_swap_map(si, swap_header, swap_map, maxpages);
+	bad_map = kvcalloc(BITS_TO_LONGS(maxpages), sizeof(long), GFP_KERNEL);
+	if (!bad_map) {
+		error = -ENOMEM;
+		goto bad_swap_unlock_inode;
+	}
+
+	error = setup_swap_map(si, swap_header, swap_map, bad_map, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
+	si->bad_map = bad_map;
+
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -2952,7 +2952,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->swap_file = NULL;
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	vfree(swap_map);
+	if (swap_map)
+		kvfree(swap_map);
+	if (bad_map)
+		kvfree(bad_map);
 	if (cluster_info)
 		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
-- 
2.47.3


