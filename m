Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF229F8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DA86B00A7; Thu, 16 Apr 2026 14:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1846B00A9; Thu, 16 Apr 2026 14:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570346B00AC; Thu, 16 Apr 2026 14:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF716B00A9
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 757D9160983
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:47 +0000 (UTC)
X-FDA: 84665270214.16.0846197
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63DA5160008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZaEZ0XbJ;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364485;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAT0Zdi0A3L7jcOEjFT02mp4Si5ENKXv86uu3IbJfq0=;
	b=8SqIrcoBZqBNpiuA1b7DmdLwb6HIaKm7s43o5bipSZeafqya86GecRPtJ7lBuGqVj1E1ZP
	IpSfrZngUkmz1nlc5fjXoyazT82PMgBx4yxtdPq8Us1YGsdHPO8JME4n7tgkH5606SHvwK
	EwTtrTE5JsiAw0zhEcDGhBoaqaGqMkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364485; a=rsa-sha256;
	cv=none;
	b=T4cEjdIJ3FDVgISrnz41NQ3JeAWqsDnlXbY5KFnO+uutlgW6VDsb5weoS+y5KSHzyWvQ13
	NXj3jFZZnKdekPb9iB97qgy+igSIKJMhCp60JKIp/+k3GgE/yeXO/E0LWnObs+R7cKoG27
	82y1qyHrQhxhlluIHvO/BWtNMyT1Eok=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZaEZ0XbJ;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E1B9445B1;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3ED60C2BCC9;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=9uUJ5ZnhzVcRroGJtWh+PmTiaF0DxXOB9t/m6eZEc80=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZaEZ0XbJEumKLxVc1H9xC+yfsyN5xZ9bsT9w1O7wTJEoaO+fkKWsaQRFcpTp05Ip7
	 QhalfryuOXOcz6iD0FP9/Xr4pgCZ25AkQaQiYxtpKfycMTE5TngKyhoKiEgaJrBrme
	 a47A09XclA2REDH7r+86rmgCvfvoPm7niaf3cekAM/wdlmGRKmU1aexUq+cjSVXk8/
	 cX2Ir9eoM6QvxivW4Ah4eg5UBkQPZUTi+64eeKHvRLktx/OaoRWCQgD51Txw0cQwKQ
	 7IJbjDrzof2IxVMdd27izddIPxYGRO7VEWH0TCZ0rgpk//zbGWr2uDizPZcg6udAWk
	 MuxzWkQJeNRvA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D52F8D762;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 17 Apr 2026 02:34:33 +0800
Subject: [PATCH v2 03/11] mm/huge_memory: move THP gfp limit helper into
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-swap-table-p4-v2-3-17f5d1015428@tencent.com>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
In-Reply-To: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=4259;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=tNStPcbhu28x3vCRrCUXOyfb3dS9dfh2od9kzNLsOpI=;
 b=BS6cZ/T106dgH6DLMjDENOEw0SeMKv/MGI8DBrZ6Bb1kxRThc1p+xh2XD0Qhjh/RFU/UK23TP
 hXc7azdvKd5DNdWhiXOfcdnZL47jBOVZtmGTMhhOCD7DfU0ZN6m7V2X
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: ct56g3h6omchj19purpqia61g7cnjc6p
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63DA5160008
X-Rspam-User: 
X-HE-Tag: 1776364485-498415
X-HE-Meta: U2FsdGVkX1+CNpNHntlbEXfl7hTbZaSMcgOLZnEm6FKc4I/3/BP36TlPBxtHWxJDXc8x5Ja1pbi3ysHqz23a9i4th3RpWK4efM/drAVKSetrm3f/XOuZJB9itKOPV+/hMF8W45EAxgRJmQO/GD954iCvUvDzOfgQZIf04nMJm1E1Np1bverx76SvOeoQl6z51iQAaIVgOMiEyt48CdGukw4EcOQVToBujK/6+V2eeahnY3VrYiz439qpcrhK20jirGa/L+hL4MVLaOzU0yWtbFJXxO+IM7FKItKO8GBKBI7Tl+gb2IN+nRM9Yzj3oayAy1OjVa40iRoGg1HQ9b09A6Kk0R7vvPKsm/FbqNmn5REXHLMIYF/OViUCMBbU6Z0XbXO0km4hUhQ0Sagpx8eBkzwmwdGXpqpxiCPdhI23jXtswppUpJCIAJJWCspVwRpeqfw25zzar9lgVUKROVQy34WYIeI7pzghryZ+ArZsx2bENZoeobPFLILO2yJy/LiugEIShOwAkyYmQTdcP5XeZrVCnltX2HgwaP1JgR+ZBrRRyUBhRlwXob7Dd6kVAJ0pD0UoHZLE+2B+EsZ5KxS2MBjlmIa5donoAvcdj2Ym0LnPxcNGR9nvRUfYd5JYwm6M9YzO3NQ3Lr7/hqaxXbQu7szGjllia/ecO2soGaUgzudP4PUBObnGYzP7Cr/x2yTQBP9ie7H4RpiG+BB7TnUfxNLIzjBr0IW0MK+6uuIeslY72CLfyKBkylzUkY7sABWK27vLiFeEMM+q7KfNxn7f9OoLJzijZ515t6hovffoUs611X8t7xqFisoqKNo/EWftkd4b9xkpV5GDHK1E0cEvsD8iAVnhGQoUd1hywKoMQAGo+mcip2hVsusPMG+qIsJMGdp5Ru2FvwNvOsF8Y8EYRj0Q/R7ymGZrIo/50emi268uijOOOzR7NkTsNX7ciLC+Lir4URLnkgb7f7BAQIP
 Npd05N5I
 Vjuy07Vif+hbiN1RE1Fw4UaZyz1kjFjhd38XKSvLSEKTFX3KFt/2ODhqPnGXPHqvWjoPHixf50ulE03Zpq15r7YeYYJ90Qs6ZnSZJkIHz3wiqiR4KLpJRw9WoDZPeXk2+vymmZfupQOLxetQ1zoScB54dUaPxeVOl4VdfZQWtdw2MgHZBqRguDAUFz/WmkW9xjeu01zjXpotT8gs9bwSCW3nm3rAevQnxOLDMd+jNUWYoIJKflKXTwhDRkZDQTWa3mXmRwlPNPn0TawIHRuFs8j0qYLl5kg+bNUu1E9N97QbQhEeMSHUgMF94dvLMPqvuX4zWjEFWWBqR+9wtYWenaq9nNMBbZb3GluowcjmW0JRavwIaBLatuhjzlez5y46xcDbOl5FzK3PovoEBKudkoDtNSG8PezByjPoF2lMDngmoVfsIyB581EoA+yJ16VVx/1S4i6i1a3aYBcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem has some special requirements for THP GFP and has to limit it in
certain zones or more lenient fallback.

We'll use this helper for generic swap THP allocation, which needs to
support shmem. For typical GFP_HIGHUSER_MOVABLE swap in this helper is
basically a noop but it's necessary for certain shmem users, mostly
drivers.

No feature change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/huge_mm.h | 30 ++++++++++++++++++++++++++++++
 mm/shmem.c              | 30 +++---------------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..4c16e5d9756f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -237,6 +237,31 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return true;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some shmem users want THP allocation to be done less aggresively
+ * and only in certain zone.
+ */
+static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
 /*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
@@ -581,6 +606,11 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	return huge_gfp;
+}
+
 static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long orders)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index 5aa43657886c..62473ec6928d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1788,30 +1788,6 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2062,7 +2038,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2138,7 +2114,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2545,7 +2521,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {

-- 
2.53.0



