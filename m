Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A48CA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A313D6B0099; Fri,  2 Oct 2026 21:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA166B009B; Fri,  2 Oct 2026 21:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1BE6B009D; Fri,  2 Oct 2026 21:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67D5C6B0099
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:11:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E84C1140846
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:39 +0000 (UTC)
X-FDA: 85279537518.06.9F14554
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0FB3F20007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nhK3nJVhaqCxZzWSecqIzI7wzUreUVGr8GUe639FgM=;
	b=h0q9xryvw/EK/Kz9PyfgkrcrzBq5hrf6X1pRBeeGvinEFZPPr88EYQEtpLhhD0FzwGI+ZP
	VBYY9qoQlvQX6JxxPPwtWrLYES9rUiMpAEQWLOl075YD1r2Yux/Znlon5U6eThTTexE05k
	y8lVqaRiYLtupzYyJGQsHbzwah1mV9s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989898;
	b=5Pe8qos3w1zKs+TttirV9/ozzOYiKKi/N1txmNY1tHctze+8qI1mOZ283Tzev5Zyty4+i+
	nrOvT+IEpokJYDa9BLSwxAPyN0koO7byJdisIOPujm1Jw/IuidFleoP15MGGyN+TWB9xb8
	D4ziLtOSUysRu6LjKR8H+62aLwVnjXU=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d81cff4ff6dbfbf7;
	Sat, 03 Oct 2026 01:11:36 +0000
X-Mizu-Trace-ID: d81cff4ff6dbfbf7
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	tj@kernel.org,
	mkoutny@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 3/6] mm, swap: charge an xswap entry when it gets physical backing
Date: Sat,  3 Oct 2026 09:11:08 +0800
Message-ID: <20261003011111.1003090-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
References: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ypfbnrmfipxyq6kg5xmj54hwqmhhzdcw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0FB3F20007
X-HE-Tag: 1790989897-636790
X-HE-Meta: U2FsdGVkX199/dVuJSdcm7weizxIFq0czLnHkv8RCIw2WMhLRLj5/zpHyk+PiOFYBjAInGqhQsPV12moABqy8uZYCCJEXj6CagQV+5sQEbDY9ejiJFg7qMpk9AwRt6adj4gl2oEzBx+yDhske0Semh3mrbzsBKyv7raBGiqV/UP3cnl16Lmhj+UP56GFfHvBpDMD0PfcVuZdtJiPcE2aXqYtV7RIsYu6Htv/d+aNaSnW5NliYSg9cxy/UF/L0BaMbSGFi4IRVTuuCAEBVPlEG/HU+NsbzzKDPf/KGxZxLMmRvudpCIDOu/Rv1IIQzM+ii2OGTo2Wt/05RZ3BTfyamwUYJaBXSHjizvSZ24qD+6gi17dPWvQLqDLZnv/eN9z1rEN63tEDqmFdMmea+xpliQz6Kem8CURaXBiPhsx9115BCxbV4AIF9gBeOUSUtOdRwbJCT2Vlhgwi/1XjU+aChA/uxlTgkQ+Z51HuN7ChvLYt6aEGtX/5n6lHi3V0LZqy3xxMf6EaGe4PIXuP4WAymUza46XRCOL06w0mWrE24Q1iRtWZ7n+3w57Ythh1Qy0UoafbMnCIN/zvHRQRveTE2xwUnhzYvbe7ojhBZtArf81Uwd85tnPHehejDQMdA0Th53WWp932A3EgO5BIiDZHruGVlzJjvyJ7gYJnDVB3Ne5iMJQiXo5F5q3Q4Mz/Eim4nGovU1IpIXORCi/8oVKgw3JGK2VUmkiNMDx5my8F7hUkwADOZ8aDxxZljKbW/YbHpS1gBKAPy2CFPUEkjygWQnK540PMZLkE0gK4JH5I6KzRjt5Oh0a+J9sbQ8bXp/PGbW77fG3SRMTiSR+SjS9RX37BGbOo0GW1LjxTc0VavHth/FhvScVKlgeJJBPKMPg8dU4yFJY5vUmqkr0WntTL2Z5VqOwSdrERtKB7UGSgjF5bZTNBJi2wxWW5paIyPXD2b3YrErZwzqt+xlooUtz
 unYIp6Cy
 dxGa3JjnPkHEd/5/yJu0pDPwrBzjCIFqqhdW1BffU3be9ifyNb0TQrfqUYAKVU/SzIbVe+UPovuc3shPxBFfTF4cpM4YgNUv6/SVmPQyJo3Zq7v0Zpd0x9m6IlZHu0gTjpSWquefHaKAFOLvj4ZWWcXDDEgYIEUrLDEJ6GlX+yX8UHTAfIORD/TQbzH9s1qzbQxPQwUsc2aV8vDfnNp3Kda4eju9VR6Lszf1/lXnXB39gNmA8jp9M74wo/MNN038DcKdTosAlPcQX7LedxFYLNeLTYB7lUEIvrnwUeheKaqs+4izwlhkm/3Hb4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap entry is recorded but not charged at allocation.  Charge
memcg->swap when the entry takes a physical backend slot, in
xswap_backend_alloc(), and uncharge it when the backend is released.

memory.swap.current therefore still counts the pages that do reach the
disk, and memory.swap.max is still enforced on them.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0310b474f08d..86ab4a86857a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -115,6 +115,11 @@ static void xswap_clear_cache_only(struct swap_cluster_info *ci,
 				   unsigned int start, unsigned int nr);
 static int xswap_reclaim_backing(struct swap_info_struct *si,
 				 unsigned long offset, swp_entry_t xentry);
+static unsigned short xswap_entry_id(struct swap_cluster_info *ci,
+				     unsigned long off);
+static void xswap_backend_uncharge(swp_entry_t entry, unsigned int nr);
+static void __xswap_backend_unlink(swp_entry_t entry, swp_entry_t phys,
+				   unsigned int order);
 
 static int xswap_create(int prio);
 static int xswap_destroy(int type);
@@ -3315,6 +3320,8 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 	psi = swap_type_to_info(swp_type(phys));
 	if (psi)
 		xswap_free_phys_slot(psi, entry, phys);
+
+	xswap_backend_uncharge(entry, 1);
 }
 
 /*
@@ -4651,6 +4658,7 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
 	struct swap_cluster_info *ci;
 	unsigned long nr = 1UL << order;
 	unsigned long off = swp_offset(entry);
+	unsigned short id = 0;
 	swp_entry_t phys;
 	unsigned int i;
 
@@ -4671,6 +4679,21 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
 	if (!phys.val)
 		return phys;
 
+	/*
+	 * The xswap entry was only recorded at allocation, so charge the
+	 * physical swap here.  On failure, drop the physical run without
+	 * uncharging it.
+	 */
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		id = xswap_entry_id(ci, off);
+		swap_cluster_unlock(ci);
+	}
+	if (mem_cgroup_swap_charge(id, nr)) {
+		__xswap_backend_unlink(entry, phys, order);
+		return (swp_entry_t){};
+	}
+
 	/* One IO reads a large folio, so its range has to be contiguous. */
 	VM_WARN_ON_ONCE(swp_offset(phys) % nr);
 	VM_WARN_ON_ONCE(off % SWAPFILE_CLUSTER + nr > SWAPFILE_CLUSTER);
@@ -4688,8 +4711,32 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
 	return phys;
 }
 
-/* Undo xswap_backend_alloc(): the zswap copy is still in place. */
-void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
+/* The ID that owns an xswap entry, or 0 if it has no owner recorded. */
+static unsigned short xswap_entry_id(struct swap_cluster_info *ci,
+				     unsigned long off)
+{
+	return __swap_cgroup_get(ci, off % SWAPFILE_CLUSTER);
+}
+
+static void xswap_backend_uncharge(swp_entry_t entry, unsigned int nr)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_cluster_info *ci;
+	unsigned long off = swp_offset(entry);
+	unsigned short id = 0;
+
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		id = xswap_entry_id(ci, off);
+		swap_cluster_unlock(ci);
+	}
+	if (id)
+		mem_cgroup_swap_uncharge(id, nr);
+}
+
+/* Drop the physical run and the reverse mapping, without any charging. */
+static void __xswap_backend_unlink(swp_entry_t entry, swp_entry_t phys,
+				   unsigned int order)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_info_struct *psi = swap_type_to_info(swp_type(phys));
@@ -4718,6 +4765,13 @@ void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
 	}
 }
 
+/* Undo xswap_backend_alloc(): the zswap copy is still in place. */
+void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
+{
+	__xswap_backend_unlink(entry, phys, order);
+	xswap_backend_uncharge(entry, 1UL << order);
+}
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr)
 {
-- 
2.54.0


