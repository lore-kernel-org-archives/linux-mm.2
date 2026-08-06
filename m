Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1F7C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC416B0096; Thu,  6 Aug 2026 14:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD41E6B0098; Thu,  6 Aug 2026 14:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9740D6B0099; Thu,  6 Aug 2026 14:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 671F76B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62064C01C3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:09 +0000 (UTC)
X-FDA: 85071716898.25.612D043
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 894F6A0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DqUVpnFe;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jkqf0E4cj9fQT5qd3L4w2YuapP3ELsmfSVpofHj8EA=;
	b=dAg1e9lkB4uVY4GgL0KGRkvu+bhDVg3IjvvdvLE7sXPGwl6LoiQsldVyataC58Q8+O4kMO
	BHoZSXijJAROx2UW3CjEgCx4FW9AgnPUpF2ZADdzon1/Ht4AP3QwWVryqMb7RNk2fYOudv
	hqueqHfASMYJlztw9GS4aBzaPIV3BUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041787;
	b=A4UlZ5gKQxrrFF/IqluU5jLZqzct+QeSqj+yOi5GFQdhiXhBvmOLezQhu5lzhYiZ0BFsBM
	tzaGRyccfMbnxqgSPThoZCP0O9jcSjQtblbTqeagoxXEVsxsG5oI8N4/+ZRbfdky0ZpwfG
	GtrDeOkt4yiUWK3XyYsugu7BhGErePI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DqUVpnFe;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6acc2a10023so938586eaf.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041786; x=1786646586; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2jkqf0E4cj9fQT5qd3L4w2YuapP3ELsmfSVpofHj8EA=;
        b=DqUVpnFe50IJERDN/LDbnBuUk1Ys4mi4eJASldX7KlIByn+txcLnucEOEpryvQQafP
         cZeDAuWBD9UgPlIwSpouLE0r6IVhdk6Adk1oal9YL93xTVNHwl8sfyVNeYp2/6xrvFa/
         eSLgnfT2IZMu4EGC5G+kQcSS8hrbCSSdh77JpCjrPPWlcM4jrQoO3wZLK+cIbu32DYLt
         zQBMw1w4g6IOFt/bMzE0Z1qTvgJYxzZmU03FxzvmeLsL1IG/DVKEUrAFq89XwCaU6F80
         +GeOr4iPk2Hk9hx8WXJQIx9HFOlAYaxNNx6LRenTqJ3YDCg1Jvz+f82EVfGkAM3qfdVf
         BYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041786; x=1786646586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2jkqf0E4cj9fQT5qd3L4w2YuapP3ELsmfSVpofHj8EA=;
        b=o8Q3XmheArJlXIOaE9ndeKnSCsbujHEMKkrg8aQyeeCZ6Vavacxy+2hJLL51b+4bL7
         RgLYL+0lS/py2HSez8L5txjwFBCEnqn9FI0D0xuTlcM0yF1nCh/srKQ+Vrq50iympEpH
         OyB6YgwbidEdc8cE8EQIaZ0wBts+m63DITWqRXz0A/uKK4xqCr1vtXtJlUaWLcGvHHrm
         D7gQWdC/HHpZo14aDR9IPGCda5oYcl3tT/8m5KBPGzQpUbGDuQTYT1rZ0uDlxNCM4syV
         axQiuOpBAU7UvN3jZTr89VPTYsVqUFBdGlOZ9m1wuYDSGQ+97v704MKauSMlsACXIH/d
         +2fA==
X-Forwarded-Encrypted: i=1; AHgh+RoFWx3enChIkrIt49wr3patiehEXTVPPbjV6wbWGqaU8NvHOr4EwUoChFRAiXySWc9j3mKv89LfCQ==@kvack.org
X-Gm-Message-State: AOJu0Yze5OSKOqmCc/RKAAKuavMX0sesonyftukho/H3GzzqLGY5Lh6l
	wNg67mEhfYUG9/Cs1MsI+iox1Y54RX/EsXdZt45bGNaEHqkZCe4vXyU8
X-Gm-Gg: AR+sD10sLr8sDny9Hq30MWQHlN8XLQzpQEZw8n290Da9kzQYcBBxDzONnho0jpkEO+m
	xIDGLz7uy1fTfay3QoinqgOKAaQzs5FkNK8JnxcUgJtpBulteN+nfbyViN+rqcAq3q+qjybJc0L
	8V82oVptMUllU8MY6FhJxaFwBStEMcuq0aJSjViWFFgIg9hDYAKQMwrlT/Kk2HXAYm/xAJNXQnn
	kPKFFl7XDgZAReIYJOoXWbfaNAlPcnq8HHWAFq79C/nQCwMp7Bx9C1GD6vnXlrcOKH0T5B9oWIf
	z1egEQRqoiI8a7W75gaBYnaBE8dhZANhd1Ye5hj7nS253Fsl10rroMVvoT1KSb35OSjwAYnayiX
	DqzxBQK/xzw2gT6PHITrZ+CQA6dI5VoYVA8xoLse9ybMPOPNwAyjD8LLnyJQafXzx2FKftfNm6d
	/KhCQIYeKeOZ93N5Rnx8N58XY3wa+c+pGr+AVAYraN4jegTp79jbS9by156IFmX9AITDKNzAjp8
	Kr/HairxvA=
X-Received: by 2002:a05:6820:4c14:b0:6ac:a9c6:92c with SMTP id 006d021491bc7-6ae96c8868bmr8744138eaf.10.1786041786572;
        Thu, 06 Aug 2026 11:43:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bfa6379sm144245eaf.14.2026.08.06.11.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:06 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
Date: Thu,  6 Aug 2026 11:42:50 -0700
Message-ID: <20260806184254.3790858-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: tcnsdexzm4aojchz6qwk196cqgut8c6y
X-Rspamd-Queue-Id: 894F6A0003
X-HE-Tag: 1786041787-328005
X-HE-Meta: U2FsdGVkX18qvcryYDRV+fw1zwdczQJ+Tkdu3stAYYy3dwaQMxc/9lAQn/Z0WCWAq/WGV2GdURVYr9qOfGp6XR4uz++MORSJnPPsB6teDTFqLcg8ZV3QO3AaVkBeSa3wD5/xUGux3dnKB9bihcmbTswxXvxpVxoFF993zUC1WqKp4RPQLEbZtTLUkY7rip3Bx5+BtTovvnMPeNF12ErtxxKKcpqyNDTE49erizbGO05rNcpZWVux9w5WB3sOkGFBAFn9Hd7tzdWXWHmXQgLKo072tc/Uw4gQkBIe0ptJLI1Aks+ioHmgecQuWTkNcUAvwkVEyhx8Zyxgcua5V9SqfNc+QqSxLiV9S8Js3JxT5qCYJnonb0CRqmDsEn+JGe82fD44H+tEzfRUH1YAqjvycOsOnoEqLM3nywJYL2oSCcBzNHFFPRcqdzHric88qYf4Y6ug07mqllMNHOzM1gy+hN2kAVf+XUzfIG5ECi2ZVRDnDAgl/B/K0zhZEjvCooTH+FW5X5wGfcPWccP3B91jFpTuYtRDLgdW+fQM34exeQwmIEMaXF3wytJCM8Q8pDUPMyFWtdcfb9bVsqsQYwDbBIC/I4OURssUE2DMzoBuEummuvQltdyXfNz/cbqLpVrZ49O9n9P5a2UJCY9PI123zmahVgAqOudLpB3g5QLM6nbqXGmCVform3hoJZM+8oVQu1aTu1t5afPURrRg8jpMsu+U2wwuCJ6cDw7Oc8fo43jG3saqqug2l7Cf0beHdxmnWN1Hv/2wo8H6cu+Q+JLWNHA0R7GVAZab7OvlyD1h2KSM7keHlmVD6FYoJtn5M2ATEcreZS/nCLsInOthjhn2zAuoLCPiky+28P9CCvBUwIegeq/e2DRXYv+k+GLSzaEuC043aIVhtQC6+jmsUlIIk/zV9kK9qr08DFMaPeRbnk7iFHt5ztw4dSRMCkrhnXjuC1lVGgzIsF+cA2qnmEG
 a5zWc3Wv
 voLCkzTC/5NQNi3ZkPTw2EprgIfqeJeX3923U9YRS0PyVjKH5M9KTaK4Lq+LpS42GF3OQWHHVewNL/uEx2hrIIu+lsHq4oFHN7wUlPWvXTTw6hO6qWdqSQ1VEnfL7bxkm9Otz8T44OrgYJNoTqfFY5noTknimypgZ6SJOqgZSIfqY6223iRNs2RjkFiEVmiqVAVdPcqHZLuDjXVd3Rwt2QrIhY9YOTegb+IbW/mH0Jn0mi5KOHElIfVezjXzhDH8bwwYiaWhRu1n/7RmbFqfts+Nkl+tVj+radSs2OdwUTdDGUmoSjjtV4NRIBOPWXJQ3yVG8udKQKjQQ06BPdob1Wl8MBZRCMxyQVf8nQ4mHiotXlzuMbh8+ZmzNvn8EMKDGemEKaLJZHCWU4dknF32AnZ72TW+hKQ/VqdD0AKxDiOHAKh7Cci8xqa9pzTNTa/oJOvPv0bu7WZEH2lg1zVkwgWtZRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A vswap entry backed by a physical slot can become cache-only: its
swap_count drops to 0 while the folio is still in the swap cache, so the
physical slot is redundant and reclaimable. Until now such a slot was
only freed when the vswap entry itself was freed, pinning otherwise
reclaimable physical capacity.

Reclaim such slots from the physical reclaim scanner, once swap is more
than half used (vm_swap_full()), to free physical capacity for new
allocations.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap_table.h |  11 +++-
 mm/swapfile.c   | 142 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vswap.h      |  26 +++++++++
 3 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 5b0eca07a821..b50ebcd9e4de 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -377,9 +377,12 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
  * On physical clusters, a Pointer-tagged entry stores the offset of the
  * vswap entry that owns this physical slot (the reverse map). Only the
  * offset is stored; the swap type is implicit (always vswap_si->type,
- * since there is exactly one vswap device).
+ * since there is exactly one vswap device). The top bit is reserved as
+ * a cache-only flag, set when vswap swap_count drops to 0 but the folio
+ * is still in swap cache.
  *
- *   Pointer:  |---- vswap offset ----|100|
+ *   Pointer:  |C|---- vswap offset ----|100|
+ *             C = SWP_RMAP_CACHE_ONLY (bit 63)
  */
 #ifdef CONFIG_VSWAP
 extern struct swap_info_struct *vswap_si;
@@ -387,7 +390,8 @@ extern struct swap_info_struct *vswap_si;
 #define SWP_TB_PTR_MARK_BITS	3
 #define SWP_TB_PTR_MARK		0b100UL
 #define SWP_TB_PTR_MARK_MASK	((1UL << SWP_TB_PTR_MARK_BITS) - 1)
-#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_PTR_MARK_MASK)
+#define SWP_RMAP_CACHE_ONLY	(1UL << (BITS_PER_LONG - 1))
+#define SWP_RMAP_ENTRY_MASK	(~(SWP_RMAP_CACHE_ONLY | SWP_TB_PTR_MARK_MASK))
 
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
@@ -408,6 +412,7 @@ static inline swp_entry_t swp_tb_ptr_to_swp_entry(unsigned long swp_tb)
 	return swp_entry(vswap_si->type, offset);
 }
 #else
+#define SWP_RMAP_CACHE_ONLY	0UL
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
 	return false;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0874f57d3124..ab4bb57707e6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -151,8 +151,20 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 };
 
 static bool vswap_alloc(struct folio *folio);
+static void vswap_mark_cache_only(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned int ci_off);
+static void vswap_clear_cache_only(struct swap_info_struct *si,
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr);
 #else
 static inline bool vswap_alloc(struct folio *folio) { return false; }
+static inline void vswap_mark_cache_only(struct swap_info_struct *si,
+					 struct swap_cluster_info *ci,
+					 unsigned int ci_off) {}
+static inline void vswap_clear_cache_only(struct swap_info_struct *si,
+					  struct swap_cluster_info *ci,
+					  unsigned int ci_start, int nr) {}
 #endif
 
 /* May return NULL on invalid type, caller must check for NULL return */
@@ -912,6 +924,59 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Pointer-tagged physical slot backing a vswap entry.
+ * The physical cluster lock must NOT be held. Returns the number of physical
+ * slots reclaimed (the backing folio's page count), or < 0 on failure.
+ */
+static int try_to_reclaim_vswap_backing(struct swap_info_struct *si,
+					unsigned long offset,
+					swp_entry_t vswap_entry)
+{
+	swp_entry_t phys_base;
+	struct folio *folio;
+	unsigned int i;
+	int ret;
+
+	folio = swap_cache_get_folio(vswap_entry);
+	if (!folio)
+		return -1;
+
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return -1;
+	}
+
+	if (!folio_matches_swap_entry(folio, vswap_entry)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -1;
+	}
+
+	/*
+	 * Re-validate under folio lock. The folio's first vswap entry is
+	 * folio->swap; the rmap value we just read is folio->swap + i for
+	 * some i in [0, nr_pages). Check the folio's first entry still maps
+	 * to the contiguous physical run that includes our target offset.
+	 */
+	i = vswap_entry.val - folio->swap.val;
+	phys_base = vswap_to_phys(folio->swap);
+	if (!phys_base.val || swp_type(phys_base) != si->type ||
+	    swp_offset(phys_base) + i != offset ||
+	    i >= folio_nr_pages(folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return -1;
+	}
+
+	ret = folio_nr_pages(folio);
+	if (!folio_free_swap(folio))
+		ret = -1;
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
 /*
  * Reclaim drops the ci lock, so the cluster may become unusable (freed or
  * stolen by a lower order). @usable will be set to false if that happens.
@@ -935,6 +1000,16 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+		if (swp_tb_is_pointer(swp_tb)) {
+			rcu_read_unlock();
+			if (!(swp_tb & SWP_RMAP_CACHE_ONLY))
+				goto relock;
+			if (try_to_reclaim_vswap_backing(si, offset,
+							 swp_tb_ptr_to_swp_entry(swp_tb)) < 0)
+				goto relock;
+			rcu_read_lock();
+			continue;
+		}
 		if (swp_tb_get_count(swp_tb))
 			break;
 		if (swp_tb_is_folio(swp_tb))
@@ -942,6 +1017,7 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 				break;
 	} while (++offset < end);
 	rcu_read_unlock();
+relock:
 
 	/* Re-lookup: dynamic cluster may have been freed while lock was dropped */
 	ci = swap_cluster_lock(si, start);
@@ -1209,6 +1285,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry;
 	unsigned long swp_tb;
 	int nr_reclaim;
 
@@ -1233,6 +1310,19 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 					offset += abs(nr_reclaim);
 					continue;
 				}
+			} else if (swp_tb_is_pointer(swp_tb) &&
+				   (swp_tb & SWP_RMAP_CACHE_ONLY)) {
+				vswap_entry = swp_tb_ptr_to_swp_entry(swp_tb);
+				spin_unlock(&ci->lock);
+				nr_reclaim = try_to_reclaim_vswap_backing(si, offset,
+									  vswap_entry);
+				ci = swap_cluster_lock(si, offset);
+				if (!ci)
+					goto next;
+				if (nr_reclaim > 0) {
+					offset += nr_reclaim;
+					continue;
+				}
 			}
 			offset++;
 		}
@@ -1812,6 +1902,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(si, ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1918,6 +2010,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	vswap_clear_cache_only(si, ci, ci_start, nr);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -2034,6 +2127,55 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 #ifdef CONFIG_VSWAP
+static void vswap_mark_cache_only(struct swap_info_struct *si,
+				  struct swap_cluster_info *ci,
+				  unsigned int ci_off)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	swp_entry_t phys;
+	unsigned long vt;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	vt = __vtable_get(ci_dyn, ci_off);
+
+	if (vtable_type(vt) == VSWAP_SWAPFILE) {
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_mark_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
+
+/*
+ * Clear the cache-only rmap hint for entries re-referenced from count 0 to 1
+ * (no longer reclaimable), so the physical reclaim scanner skips them.
+ */
+static void vswap_clear_cache_only(struct swap_info_struct *si,
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	unsigned long swp_tb, vt;
+	swp_entry_t phys;
+	unsigned int off;
+
+	if (!swap_is_vswap(si))
+		return;
+
+	ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+	for (off = ci_start; off < ci_start + nr; off++) {
+		swp_tb = __swap_table_get(ci, off);
+		if (!swp_tb_is_folio(swp_tb) || swp_tb_get_count(swp_tb) != 1)
+			continue;
+		vt = __vtable_get(ci_dyn, off);
+		if (vtable_type(vt) != VSWAP_SWAPFILE)
+			continue;
+		phys = vtable_to_phys(vt);
+		pci = __swap_entry_to_cluster(phys);
+		swap_rmap_clear_cache_only(pci, swp_cluster_offset(phys));
+	}
+}
 
 static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     struct swap_cluster_info *pci,
diff --git a/mm/vswap.h b/mm/vswap.h
index a921620f08be..803e9a3271fe 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -35,6 +35,32 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 
 bool vswap_is_enabled(void);
 
+/*
+ * Rmap cache-only helpers for physical cluster Pointer-tagged entries.
+ * SWP_RMAP_CACHE_ONLY records, inline on the physical swap_table entry,
+ * that the backing vswap entry has swap_count == 0 (swap-cache-only, so
+ * reclaimable). The physical reclaim scanner reads it directly instead of
+ * chasing the rmap into the vswap layer and paying the cluster-lookup
+ * indirection.
+ */
+static inline void swap_rmap_mark_cache_only(struct swap_cluster_info *ci,
+					     unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_check(ci->table, true);
+	atomic_long_or(SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
+static inline void swap_rmap_clear_cache_only(struct swap_cluster_info *ci,
+					      unsigned int off)
+{
+	atomic_long_t *table;
+
+	table = rcu_dereference_check(ci->table, true);
+	atomic_long_and(~SWP_RMAP_CACHE_ONLY, &table[off]);
+}
+
 /*
  * Virtual table entry encoding for vswap clusters.
  *
-- 
2.53.0-Meta


