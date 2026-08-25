Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8CFC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415D46B009E; Tue, 25 Aug 2026 11:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECBC6B009F; Tue, 25 Aug 2026 11:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4E26B00A0; Tue, 25 Aug 2026 11:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 034876B009E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 983DBA3A2D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:55 +0000 (UTC)
X-FDA: 85140184710.15.92CDF33
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id C346F140004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rTKQJW3V;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+Xifm4yMHmmJc4W3PmSLP73v1OoKmGISMUVeCn1vQA=;
	b=UEYHefyew4hdblspAoGXvJTbcqrCUQS2cZFIyfXfA66L/tX27Qj8qgBlTUwdbkONP2EYM+
	aUhn935NEYrrmHTY17eeZUJBvYSy/OnKCFbHdiHsqco2f+assj9f9yFWJ/C+cgPdskHMws
	lg5jzH/WdL/2A3tVeKbnme3tH82eZ08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671973;
	b=WbgLQkpn/mssj7OCejNY1KVugJb+omRQk2Tr4J9lt8BAA/tadqDhpCdws6l4rj4IIJCwjJ
	4dxqoNPxjRI2Nr2CoMTTHfnlL/nauP0R7rPkrY+oAu5Zv+TFvtjn5MVXPnJGclcgmJ+S1l
	HVmo+KzcjPBIWdSYMszFNmwPmy+PBug=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rTKQJW3V;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7eb4d532e65so2765217a34.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671973; x=1788276773; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8+Xifm4yMHmmJc4W3PmSLP73v1OoKmGISMUVeCn1vQA=;
        b=rTKQJW3VWchC/bPaw6qNAMouHaMh7UguURjWXt9KIkZ+P3LwiWWsq8E691mGChqpNW
         yztaxFPAsohOef35Y1neGU04B3l7exbxCYXhL7DYXL+dCgTLmGH6ekHYcc2X389P1rZ9
         LpgBsVtjWMsEDP3dOZiMiJZ6Q12BO8+iADofcuzqDQDwsc8gYaeIB2XFYsH6nNi7934F
         PTcdsw2VkRbIcGljV6/SzAX/F3gf7xkbpaw2/c1rbVI9D5gTnLvNVY4gq9HMXlN7gsq9
         6jjViDWxfugJyd1bbgBoLGyAW9Ticpp7sDk1eI7Fs6rAAPN5zuCsfgGhvInJePXQsynz
         ZHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671973; x=1788276773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8+Xifm4yMHmmJc4W3PmSLP73v1OoKmGISMUVeCn1vQA=;
        b=U4T17FtZy9WcEiptb4NlLjQ51RaMsydzTJDeHk+2J/h7EPk868Ha3u05+R0la6wAZu
         Pxid6oHSdnHFSLaoUkuDGE8j2sJqFKYZoP/L+RWKbinHpu9hDhs84sE2sqhNlWmEOq+w
         1hzh4OfODMpwwg8johetuSi2I4+9XGygZgCD+fYy+d+YElNFiBz+sI9ayxUuOn3DtwcA
         LOeuMA52vREwy27mY+5bL5RN6tJNMX8tvbVw+hWrGWXprsYXsKa0+FAzVhbFRuofGNAw
         j15MSOKgB7G4q6gcH2m5cej5odkhwZEu6gqP16J9YFi+D8XAjYZ8d12N5aXZU3zsSLuB
         Ea+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpm2G+Sh91/cytu8NfKy8VmM7PFEOA1mJQw1pImxqFzL+3Zt+/+AQlfhMiI4bF/WQ+Vh0uvsIxneg==@kvack.org
X-Gm-Message-State: AFuF++nf2dtlj+YgRKl+yXOAQTyoJj/MJB+YQAjPnRRWmzyUGmw3dKKm
	MGkrZBh1ojroeHxheHh3/xScXAO7YDYsQVKmmpFTAv9vpCOifKnsqBmL
X-Gm-Gg: AR+sD10HX0XIJiAsuxU4O/UiRK9iLGCcisZdBPN4h7nDBWkZ6u3dgV6dBrc4Kjm9N9+
	zdW9zdDHXeN1yZqwpckseI2KfgwCz6MANy9DkkHGQdYoe4kOr1hSvbCnRytOcV77jUlLY+pG5sJ
	QyFVkp/DQudyyJ77tHD96osz7dKDhXAHlmyHUPXP9AB9ssnsP4e0+ln262mnhR0zRVcrJ2y5rUd
	u6tIeWKcan5StLYjXZSlPDXNI04hMstL5IhcHGGbJmxN1p6e78HQxhMuZOWjDqEmOTQuzqwCltH
	DKGPWHvXsf4cnrJhHt6nbz49VPGrUjOBSTmvh9uaqfrUYhVM/sM5iPtTDe42CZudjxzQjHVX6Wr
	mnudhLs+aadq/sCtnl55w8qUNjAyYVG+WQyAzOLn0MHJL44JCDwEzCLlvKF0Zw5uWBLXsmNvPiU
	2wymBSga+OOxZxM9885013S5GGuhHIgW7oHa1B4ePPLyA5ITFr+ZIQRqPZM1xMojEx6Ec4FbFt9
	ykVXeCI94RhV5Rcqc+dVSE=
X-Received: by 2002:a05:6830:6af8:b0:7e9:e313:4fdb with SMTP id 46e09a7af769-7f47639d520mr29228026a34.2.1787671972520;
        Tue, 25 Aug 2026 08:32:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm8021692a34.12.2026.08.25.08.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:52 -0700 (PDT)
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
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
Date: Tue, 25 Aug 2026 08:32:33 -0700
Message-ID: <20260825153238.2695446-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zy7oxa73yjatyoyeka7gfea8pzountf1
X-Rspamd-Queue-Id: C346F140004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787671973-19531
X-HE-Meta: U2FsdGVkX1/xXX56yQSZDEHrDWcxh9VOMdlQ4zFrND+3hjRV7pEoj5LE66fOmHQArlvmg19X3kxBWdHq8UJidbDoD5Xgzn15ZnYX1UjcptzAmaAVcRMqFGEprFUo1QiMleJrqvbJQDQZede/khkQTFsEvfTblJCfAqfrB3esG6TZlkC2z4S2h3QHhcy4HpA/YdBmy532bf6OkhOlCZdnEGmFCwxI9rcrXjam6+/EE2bg/KSZScic0L/JuXb21emYHb4dZ/IabwQ3GqpYdvItjmx98HfcJMKOPCgdP+xON4E9NO3xsNSATkJnBim4Ezp7capY9FyZA3ww5/8c7PJlo0h6ggTYfCSKfLZVGSfCCavNcn7o3Lc1GaH6uxo+m8QMNSsSXkrp3KlJsUpNvgHvXqZY8knD3UFhQHhcRdVFQuypNrzZmjAIIPfzV1BLocVuGoGJzxrDi9+TaFt4YSWaPij4jAIaKbMX9omRGGgYkCktWgm4JpZOFoVoJK+sdAvXVhrgBcklZWaKnbNsWuW0hFnvlPqB8InUZJb/FWEeRF+S/3kuCr0e2tiHZ7i0D3zKhl7yWFwOHTJZuBnsLe5jPvFx8hz1jM2wg7AMtbrYrO/IZel2uNmR2t0yfyOP6g55BRBXXoRYw2a+tQtuSV8yCQMGb9qctjEnbvsnP386gxy3cEV64ZT24G+0jaVqEiMZGs0GzlpRNp0PB83zS9yV8bcXpZAVcdH5ekINgVxz+kYixoVmTQRFp+8dD9hQPZH93XbK6AmMgpAvMAxCKTPR5WFl5EZhh+RgD7n4MrMmKsr2CgKui7LOfAiSXfGjF3jF7gM9PxNLCeXMyKk95nAeHs8HNrP8Al0q3xdKa0wODPKjXdwp5+gPaDsz0Kn2JolMt3IZeFZmD8CC0EcL57SgGiR8aBIw0MGngTPXfLT+IR5pdfT89K/Y2nTYLro10VpwTCiktUBUC9ThrCAjeaU
 LY0a77cF
 dNeYOjmYra8zxAcNRCjuXvVir13z2pexfZHsFDbl4nn06aY3Ofz98xDO5uW5cpdVoTIDivdzdem/k2vBBWdgmp+FetVXK2lHcX9uk8ct9q+HkgzutqM4gd0G5ULJnhezZLESQcOuUYuW6EPZleCsfDdA9+3VcMDSmUsVOPzNO/vBllssakao7x/FE1ni1xCMGwxZ1k34h7CQug4dExY8nnXjE/VxYPySEJHziOXoe38v7XUqQFwbkjXRg/apecDYhFmhDx9Tj3R3sjJaHS12CuBnDxAVElZViK9KDjLIMJyRdNHg/lD4bws4qHByr2LMkyUsUrejyIKevdEAviOCrv4VH47bd3EBpKr3YDQBaLZ+kWM/wWF87PO6FZX7t1HhXDoFVuMAWnFdPOVB4t1LZs06R71jHztSomi9CtHiyiBYAoc5iH0Qb8XmAnQV39IgpN+TV461HlAry7VUtK3/3z2rSuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a vswap entry's swap_count drops to 0 while its folio is still in
the swap cache, the entry is cache-only and its physical slot is
redundant. Until now such a slot was only freed when the vswap entry
itself was freed, pinning otherwise reclaimable physical capacity.

Reclaim such slots from the physical reclaim scanner, once swap is more
than half used (vm_swap_full()), to free physical capacity for new
allocations.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap_table.h |  12 +++--
 mm/swapfile.c   | 115 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vswap.h      |  31 +++++++++++++
 3 files changed, 154 insertions(+), 4 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index 08d2494a8ee6..b614b1989fd9 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -31,7 +31,7 @@ struct swap_memcg_table {
  * NULL:     |---------------- 0 ---------------| - Free slot
  * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
  * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
- * Pointer:  |-------- vswap offset --------|100| - vswap rmap
+ * Pointer:  |C|------- vswap offset -------|100| - vswap rmap
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
  * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_FLAG` bit,
@@ -376,14 +376,18 @@ static inline unsigned short __swap_cgroup_clear(struct swap_cluster_info *ci,
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
+ *              C = SWP_RMAP_CACHE_ONLY (bit 63)
  */
 #define SWP_TB_PTR_MARK_BITS	3
 #define SWP_TB_PTR_MARK		0b100UL
 #define SWP_TB_PTR_MARK_MASK	((1UL << SWP_TB_PTR_MARK_BITS) - 1)
-#define SWP_RMAP_ENTRY_MASK	(~SWP_TB_PTR_MARK_MASK)
+#define SWP_RMAP_CACHE_ONLY	(1UL << (BITS_PER_LONG - 1))
+#define SWP_RMAP_ENTRY_MASK	(~(SWP_RMAP_CACHE_ONLY | SWP_TB_PTR_MARK_MASK))
 
 static inline bool swp_tb_is_pointer(unsigned long swp_tb)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 66bcbb112142..6ec439462490 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -142,6 +142,10 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 };
 
 static bool vswap_alloc(struct folio *folio);
+static void vswap_mark_cache_only(struct swap_cluster_info *ci,
+				  unsigned int ci_off);
+static void vswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr);
 
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
@@ -867,6 +871,54 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	return ret;
 }
 
+/*
+ * Try to reclaim a Pointer-tagged physical slot backing a vswap entry.
+ * The physical cluster lock must NOT be held. Returns the backing folio's
+ * page count, negated if the slots could not be reclaimed, or 0 if the
+ * folio could not be shown to own @offset (i.e. there is a race).
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
+		return 0;
+
+	if (!folio_trylock(folio)) {
+		folio_put(folio);
+		return 0;
+	}
+
+	if (!folio_matches_swap_entry(folio, vswap_entry)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	i = vswap_entry.val - folio->swap.val;
+	phys_base = vswap_to_phys(folio->swap);
+	if (!phys_base.val || swp_type(phys_base) != si->type ||
+	    swp_offset(phys_base) + i != offset) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return 0;
+	}
+
+	/* The run is ours: skip it all, whether or not the free succeeds. */
+	ret = folio_nr_pages(folio);
+	if (!folio_free_swap(folio))
+		ret = -ret;
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+}
+
 /*
  * Reclaim drops the ci lock, so the cluster may become unusable (freed or
  * stolen by a lower order). @usable will be set to false if that happens.
@@ -1148,6 +1200,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 	long to_scan = 1;
 	unsigned long offset, end;
 	struct swap_cluster_info *ci;
+	swp_entry_t vswap_entry;
 	unsigned long swp_tb;
 	int nr_reclaim;
 
@@ -1172,6 +1225,19 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
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
+				if (nr_reclaim) {
+					offset += abs(nr_reclaim);
+					continue;
+				}
 			}
 			offset++;
 		}
@@ -1748,6 +1814,8 @@ static void swap_put_entries_cluster(struct swap_info_struct *si,
 			}
 			/* count will be 0 after put, slot can be reclaimed */
 			need_reclaim = true;
+			if (swap_is_vswap(si))
+				vswap_mark_cache_only(ci, ci_off);
 		}
 		/*
 		 * A count != 1 or cached slot can't be freed. Put its swap
@@ -1854,6 +1922,8 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 			goto failed;
 		}
 	} while (++ci_off < ci_end);
+	if (swap_is_vswap(si))
+		vswap_clear_cache_only(ci, ci_start, nr);
 	swap_cluster_unlock(ci);
 	return 0;
 failed:
@@ -1981,6 +2051,51 @@ int folio_alloc_swap(struct folio *folio)
 	return 0;
 }
 
+static void vswap_mark_cache_only(struct swap_cluster_info *ci,
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
+static void vswap_clear_cache_only(struct swap_cluster_info *ci,
+				   unsigned int ci_start, int nr)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *pci;
+	unsigned long swp_tb, vt;
+	swp_entry_t phys;
+	unsigned int off;
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
+
 static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 					     struct swap_cluster_info *pci,
 					     unsigned int ci_start,
diff --git a/mm/vswap.h b/mm/vswap.h
index ce35a8381ca0..c66fa34e2e60 100644
--- a/mm/vswap.h
+++ b/mm/vswap.h
@@ -44,6 +44,37 @@ static inline bool is_vswap_entry(swp_entry_t entry)
 	return swap_is_vswap(__swap_entry_to_info(entry));
 }
 
+/*
+ * Rmap cache-only helpers for physical cluster Pointer-tagged entries.
+ * SWP_RMAP_CACHE_ONLY records, inline on the physical swap_table entry,
+ * that the backing vswap entry has swap_count == 0 (swap-cache-only, so
+ * reclaimable). The physical reclaim scanner reads it directly instead of
+ * chasing the rmap into the vswap layer and paying the cluster-lookup
+ * indirection.
+ *
+ * Callers hold the vswap cluster lock, not the physical one. The rmap is
+ * only touched while the vtable holds the slot as SWAPFILE, and that
+ * window is opened and closed under the vswap cluster lock, so the
+ * allocator has finished writing the entry by then.
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


