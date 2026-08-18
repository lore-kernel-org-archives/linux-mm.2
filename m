Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5349BC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558BB6B0195; Tue, 18 Aug 2026 12:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FBE6B0197; Tue, 18 Aug 2026 12:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D796B0199; Tue, 18 Aug 2026 12:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23A046B0195
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:33:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92D7C16018B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:33:39 +0000 (UTC)
X-FDA: 85114936158.13.104F796
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8ADF7A0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:33:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9c3EQDrXE3vRM1RVbiW2GeEHFsdgfcqVsnF8TLnbg18=;
	b=FDFFNRvydJU3pI2evzEvH9uPl7xXL+6mYgbvekJvSXEhp76xPz7fCzO92duSFonjJsGWG9
	H2bvsdEfvYg1GdEGjnR4QhJ7FgOZZYklpa4vKiPXIXkeUiy+Oz1zdJKkEnt9xI/RCKf3Mm
	nGE4rax8vhmok+UYI2Ak5dXws5Tw9Xk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070817;
	b=Xh7yEKhW2Ogj25XKc3xEju+34/PidH9ja+NpPBPz55gL+TNBjG67/gOMNlPPPVPmoMBgau
	t8B8HCmPqwVopr3+71JLuSIJHbMNB5iLjFAg0CoJoIA+V7wrp3TNoyuTBq2YqvROy5y1Lq
	mo7MY/IfufohgtYmAFoHhqL/ixGZDvc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 381DC3EBF7;
	Tue, 18 Aug 2026 16:33:31 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v3 1/3] mm: swap: move LRU insertion out of the swap cache allocator
Date: Tue, 18 Aug 2026 18:31:58 +0200
Message-ID: <20260818163221.589352-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818163221.589352-1-alex@ghiti.fr>
References: <20260818163221.589352-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGzrKpFiQBWE7jgSHm1B1Tss7glDJyAkTzxEeU9OQiAYLawgzwDOBgG4iPHXBy0aKy4gQs+Ii2DffjaqtZZ3LfS2SN6SCJX4qvU3oLM6xcGLJvZwuz8vkVC2ewjODx91iGrkNSLZjyN/VJW2tqin5q/g3k16OwrEROcI29Apn3xbp05vSrNeYi1pgROYXjy0swRSrWCVTnVLY1Yg/xCEO8awK9CQbNMOaFadSahMwM5U3sAwNaWfbsaO1QKd5xlasV/tuiA8uJI3GcUI20RjyAFVHgxsZHxfEWjYXYziIlbqulL0jiGS5jDCrzfEayJECOOcEzJHML8LjYL+HQjOSTkH7GRIlB0E2bgDeZGD+0pyv0aoNtKnf/1LUSazvw4Io8O7CULSv85bC/6S0LHpDYUPS8LDRIsuCdd2W8IIjkbPPm0iMYhX9ulIEI9l6Kbp09dMFTIEYXWrxSevbAmCLZqil6Y0U47/RVFrlPVRNr6RwlPSKNguL6m9ndNHv/Bj6xU+frpvwDoabs6BXg8Wm992OI2oLE/SnfjykVharSpiuHxFJiJI89RdItABOEuejSuQ4s3zcq+aRDAACP4BaPSYgAiDnqZXuZJBcluynJLQUpWZZ8gCFsMuCDahZOPrL53jyr69A82DwzXlc9D8fTzTDsJ5i8k7XARi/iZOKOPLg
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Stat-Signature: p6861mkn1zttpm4cs87qz4b8isqk5mar
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8ADF7A0007
X-HE-Tag: 1787070817-837770
X-HE-Meta: U2FsdGVkX18vRSB6MqptCUirKkhSxa/xbI8qQnbKF9Kxyek4dTZu/v/WtmJIaDSZJeUxRNuzl6g4I168DZThvgpZ4FfE5WdqYOyrtYuAogGuCCkcbScaCN7rhy5SyRVmeTavOxArNVFwhcfR+fAZlvCLwh3YrKeoxcReo8PEwb+LqBmQImDD1OGmpKMLLAnjx3wx5hDFmhm69roRYgwL6eHIoSipI5vXRfcib1nJqPqpDwssXFVal2M3855ub3iMK8DooqRGgm8jaqW8yDj2Q/hgSjtXBlGokHqsrekpnp8xxgHptjawyZu5798Hlt+o4dph+7LMOjL4aJPn3HR25Oyn/28yPOZtfy4DAKReHj9tc9DOqDknYkpt4bUcY6FEkKzvlaeynqq8VbyIB8JDrh2Xk69pl7Ag4Hn+hNU6lU2XAXdjgTyPsnxkASItxjLT6B7T266HNmUcEAQG9ZNn6c+0jfk7hOGWJAh4XaJ/kPjZF6UC51HB78dKmH+/YOG4/84gK/jfjx6Ux7tjbfkerOZT1NCjpKbkC4XW1p6/zDkTKP37227OaU7uSp1VzZXX1aefNVWNlJva80O2rHSLWz+wLrqX3slxzloF9pB5uJbKM+9joC9c5mmcVFDIhk1T/ECVsix5rCxWwam0fpwecBq0W6ztXMuKV8/dAlEl4Zd3LYel7+rHvKJSwVZub5gbNAY2LkB8a7BcfJe3hiiYjp8AZnVNMOYl16ae2+LuD7hlsJog+D+1bhdKh1vYN45fm6UqMH9dcZSXYUrteH7XwVnK4HN36Jckgz83oYeYnZoyuCCjdrJzk4vPq6WfLJGFElrIeWL+yyrIilAwg7shKr2QVmx8RPqfV+hZuiKeKI2pADgiD2u38GqOfWew3FUl7CalecYaZFyw01Lx+aLF5SpXAuhbWoOjP9lhxy8pvUr3H272eynvEQk+3f5jYUEojR4GppjTHQoHEixWA1E
 SSCf8KXm
 JbDSPnu5KejL8RU4uab3wDL5k3ni1ANcX4/FE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback wants a swap cache folio it can free directly once
writeback completes, i.e. one that is not on the LRU (dropping the last
reference on an LRU folio would trip the free-time page-flag checks).

So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
no functional change intended.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swap.h       |  6 +++---
 mm/swap_state.c | 20 ++++++++++++--------
 mm/zswap.c      |  5 +++--
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..fc44daae1de1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -304,9 +304,9 @@ bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx);
+struct folio *__swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..90638a8d7232 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -483,13 +483,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
 
-	/* Caller will initiate read into locked new_folio */
-	folio_add_lru(folio);
 	return folio;
 }
 
 /**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * __swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
  * @targ_entry: swap entry indicating the target slot
  * @gfp: memory allocation flags
  * @orders: allocation orders, must be non zero
@@ -501,13 +499,17 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
  * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
  * @targ_entry must have a non-zero swap count (swapped out).
  *
+ * The returned folio is locked and is NOT on the LRU. The caller must either
+ * add it to the LRU with folio_add_lru() so page reclaim can find it, or free
+ * it directly once done; a folio left off the LRU is unreclaimable and leaks.
+ *
  * Context: Caller must protect the swap device with reference count or locks.
  * Return: Returns the folio if allocation succeeded and folio is in the swap
  * cache. Returns error code if failed due to race, OOM or invalid arguments.
  */
-struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
-				     unsigned long orders, struct vm_fault *vmf,
-				     struct mempolicy *mpol, pgoff_t ilx)
+struct folio *__swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
+				       unsigned long orders, struct vm_fault *vmf,
+				       struct mempolicy *mpol, pgoff_t ilx)
 {
 	int order, err;
 	struct folio *ret;
@@ -643,12 +645,13 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, BIT(0), NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
 		return NULL;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, plug);
 	if (readahead) {
 		folio_set_readahead(folio);
@@ -683,12 +686,13 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orders,
 		folio = swap_cache_get_folio(entry);
 		if (folio)
 			return folio;
-		folio = swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
+		folio = __swap_cache_alloc_folio(entry, gfp, orders, vmf, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR(folio))
 		return folio;
 
+	folio_add_lru(folio);
 	swap_read_folio(folio, NULL);
 	return folio;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..8163e6c5f76c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,8 +1000,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
-				       NO_INTERLEAVE_INDEX);
+	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
+					 NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 
 	/*
@@ -1013,6 +1013,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
+	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
-- 
2.53.0-Meta


