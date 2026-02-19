Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7785DC531E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BCE6B0005; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF946B0089; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB9A6B008A; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A74A66B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C16613BE84
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:10 +0000 (UTC)
X-FDA: 84462832020.03.1E1C400
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5DB9640007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RX0imueN;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544528;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSCrOMAJAnvRfX+pGlm+u+gNwgbUcZ8Y/JH5xIO0ej8=;
	b=p8F8SIHJwue5H0mwNwMT6LgMB15py1eJWbTscM/3QMHH6AApG08q9C5+zxiTW+Mvm3ZpiJ
	jYi3jKkg2E98ln6C9wB1RqFimRM2ffN/hdcl7QGcI8GBELVE0re/zrf/awtiL66wJCRpjS
	mpSO40jncDT9zGKuIpygX4TeV205iSk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RX0imueN;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544528; a=rsa-sha256;
	cv=none;
	b=bwBMoflCCZz7ogb1/CElCS/VtUZf5L4PYao4K5cmvFLUW8yr5NDaCHf1MTeBSDu+/JRVV2
	w/PGOtHKu20N2zOnSZeh1sZln7sIspNgpxISpFzYilm0k6Z+362r7Jz8DJacVQM29XejsK
	ZyweIp07YED6/Ew7EZLQtvSVTM+vYrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BA6860130;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A7D0C19423;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=ob6VrZobjIxhJd1syjRnD0Fz6UDbLx7k9+0T35c5Ifk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RX0imueNLxnKo6rUXkF0FvQ104tNzT+RDIgI3/9VpHbGhPl5ylP02acqwECdl9lIi
	 csDtkTmVwrUdMm5ocEnx0KSqrFsH/NreFVdyX+OZz4oV8nTO/fXJ36uuqx+Q90OLqj
	 QtHAv2ozRZVQlO8EJXfZhrov9EzaOU6DtSnvEkEfSoNOFrDO2rl3il4T2iEK1xPhdM
	 29LcWXU+gcudZkW0wUMrsTxx4l6WtZfZQ1NcX7b3Hh9Jg0JurM3DDaBiyeaCNZlvq4
	 MbrubBu3OlOc0PTIHbGKHerkilSmMx8S+PT5KLNpXaFyRD3kgWmbMEqZZtvNd24yTF
	 3WbmjOcRZVPJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185FBC531EA;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:02 +0800
Subject: [PATCH RFC 01/15] mm: move thp_limit_gfp_mask to header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-1-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=3548;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EsaDsTDGqRS39tj8l8nvpBNRy9miEhNym6TC8RjJmDw=;
 b=wZakvnnlS13do00sOlIWHX8u8pD1P7hONi6OwqAIkTyXNu+BQg7Edjqh/iZMYuGM58ZYbJdRG
 6jgP9IrnMLJDt6qpU2w2ZuSjAyEz0NYHpKdYslZ4KSCbENbjAT0krGo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DB9640007
X-Rspamd-Server: rspam02
X-Stat-Signature: pbjnhnyugq6fk4b94k3pi8thub7bwadd
X-HE-Tag: 1771544528-373612
X-HE-Meta: U2FsdGVkX1+MxRM+EDRALnybejlvhb/+36IaHhNVaZJiHsdyfalmTh8q9P5FOdMnzrUoTOlpQTmUFXepM2wxhlfsYmTASCuY7HEUHH2RKLHFoZPc6LpwvYelJoFSXXuHdm7Z4oxmIxNY6BpPRGdTSloai6elVA40lGqRWdj2odfmpTouQAdrjFdyfE2XS7rt+QHwld1M+dXpH8g81HKZ0X0a7TdfNx9aRDHbrS7xBd1IS5fAmTkVpEpeSYmouMhSXVHz1AxneX3IQ3AoUhRtyMkqXz/mtNb3Tpp3AO81l0urLvLDB0HMJ0l324BNp6x8FZ2Rk4XdhNI1mPEOHJNQVMdaQYkYVTcAyHYeNg0HrhO6ynra7+j30iyaOSVzgsHNUHxeHZpBuHbS7Er5dVtLOXuYHLgaOs7YO+YcpHf3eJg93prvjcJRPXRkO8F3YRIjcDD2o2d8ohmjwA7CWl8XGb3W9OiWwMG45c9uxLkNK4slOPgensknuMfBgw4Q1+puGBQLWGJWegSoi/c/Cs2OkJX3cekdF6AkO9Vj5JfL5BlQbGEOT9GYhqOXvNK25waCrcXW4OP3wATGXC2mP+FH23vnJOKrTUsqje9uX7i7otES4dDein2DmarKcNIgOZx5wkCXpQmF2wDSxU168NfeNJlnzkzhsfVVl0w9TKQ8frtAScEUobvFpZKA1JZoKlGWhaHZJpQ4DRC4Wp6TbsqxIKEoLsKsD0wmFbkWAH7GLKNQIcEkzrVRsOLJVfpa+xTU5NE23ClJb3hp35UbEbioZyaSvpVPRQ42dlGwKOkRuEXChpkJpGVUd0LNT2bGG1iMW/kMogyS6hJeU6VE1lZ2l9A8g5N3NsvokSt9gAsywtdCA8tuud3Uw6N0OAu5bNkGiedhkcx8LrB6EZOEDAuC2AZOLcYOKtkOycEvozmz5poOVJBoLRKdCSPgVQmYuuCbVPDjVo9bVkvgjSewb1j
 RCtK4rYL
 +AFk2/eV4HZDf3yr36px+ZOS66HQJhW/OY5j9aOdJkuIYpmUO1sd8oAsdBpGDCQsu0SgzZJgqdGQndFtAcxuEKZUaXN46B22DdbgvmqCqF+2lRyIm507i2FqDlYlnVTL3kMWkBbTfqAR0JChSn7kU+gsripPLHtFok8vV5dLskOKXgofBUg0Y3852HbFIPhOdkJNUrR9ife6dGBb/PXS7/IBRbOIdEdOTpV+fqlr2aLQVzI3FdwLuVc9dS71QBGzj9EE17jtdXzw8FJClEwH4HwJodqIimRMsTGay1jhYddzSTd7gFpzx4+iNVkM0Me319UynvNSN1RsPiDLdfr+t4LvThKA6wjYX1x+cIjpW3Tcl3pW2DQtEf+ZxjbUaNo0uRRVIZee+Er7wrGGXGIl6BKD4X0KF9gbloEYN5VIk1vQ6wSj5fscOQqYej0cMoA75UdaK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, to be used later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/huge_mm.h | 24 ++++++++++++++++++++++++
 mm/shmem.c              | 30 +++---------------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..d522e798822d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -237,6 +237,30 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return true;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some of the flags set permissions, while others set limitations.
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
diff --git a/mm/shmem.c b/mm/shmem.c
index b976b40fd442..9f054b5aae8e 100644
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



