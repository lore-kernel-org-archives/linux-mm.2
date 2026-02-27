Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F4AFD9E2D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCE06B0089; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EFA6B0095; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF506B008C; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8B256B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:57:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A2D413B00A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:24 +0000 (UTC)
X-FDA: 84488725608.11.8548851
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id D04C02000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772161042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y8Kk2H99GVDbUAwq3LLKwdcGKGrE0VVxjcfTB4dplMY=;
	b=5ac3p2oDUOFivtCkkdn8QUiTmwI602eRsDHEceupFndmD5Y3riivkSk6A6G5DUW5eD0T/V
	qFru+fz8caWoPNUS0uHuIn990yt/DpXp/dZKTmlQYbaHAQrsYNlFMnDIkpTVvhWcQe3qy4
	hgNTooykPTyRZ8RhdUuEJvNXQOUUhBg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772161042; a=rsa-sha256;
	cv=none;
	b=auMrUUE/d8yTgwk2HqgGP28ZicXABmzPxI2Yk9RVPhXYcng6iaGfLebjm3jVSfSeGSYdBf
	BiDI4JPLMn/2y3l1GlfXMHwFKMUOVqRakHTVcNRTA6qD02N5nqTxjDdsSqoLjO6/PPM3sf
	IFyf1TqUvVthBtK9h4L937VQCmBUZls=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fMXzN3xcvzYQtLh
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:56:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EF2E640591
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:57:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPgJCKFpsEGdIw--.32070S5;
	Fri, 27 Feb 2026 10:57:14 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@fromorbit.com,
	zhengqi.arch@bytedance.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	yebin10@huawei.com
Subject: [PATCH v3 1/3] mm/vmscan: introduce drop_sb_dentry_inode() helper
Date: Fri, 27 Feb 2026 10:55:46 +0800
Message-Id: <20260227025548.2252380-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227025548.2252380-1-yebin@huaweicloud.com>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPgJCKFpsEGdIw--.32070S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1fGFW7JFy3Cw4DGw4fuFg_yoW5ZFWfpF
	ZxG34fJrWrZrnFgryfZFWUZa43t3y0yayxGrZ7W34Yy3Waqa45Xr12yr45tFyUCayrWFy7
	trWaqr1Uur1UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7mLv
	DUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D04C02000C
X-Stat-Signature: sj6chxjyc9xkbtyu5m1buxdw59wy9fe5
X-Rspam-User: 
X-HE-Tag: 1772161040-482204
X-HE-Meta: U2FsdGVkX1+y3r2IQuxdzR/Vdvx2LQNSf/FV9hgZIgeHwzIBIK4yq4N6IAWA/MkGqwUgT0em2CiGr7dnuc88NQcLqr+fucw6/FnoYe4nIJg9BMVFW6wRXqP/KhWzsD+22A1kzIekQiygJwuV4H5X8/GtjWRpVeGTENka8oIBzVJ3+XzszJRaUylV+R4UdU+VoQ486i9fxVb18s4WmtMR3M14I39qs4gGtYnLcjPacYLpydO53CUGOUsIPpjgpW4T7PnUlH+1uKjxl4OuzYho9pat5AkP6ijdK0MkXQ3Rv5kG3jRoYCsukRGAJJIH7mIGS5+0pSevrSUe9UisUcIiCVnBc73N3CoFnCpOCjU4adGUqkgYC+R+hTAgJiGRmJipfTO7RYVEBRFMXw1qZG0MXG8m3rrUGwnZFH1bstzbtOXCuPTrNEmh2nQ+83Ea0npiGQ5aJs+/zBtRSiMRbJwUseY2MWVJqxG2gmKtje7Uvr8phj4mv31W4qG0BpphvTTTZB3KtXmyXUmZmyNDZv00iBUJY6I94vymjEWKgA+nu9EUF2/HGmEmBNAInR5Qq8lN3NlQrOUlpgFHArWI19Z0i+tmncI+UbRUVVVlDQk/8slM1EDBf5M06nxTu71o7J9bS8CrmdYALoZx/cX3WsCpQzDSAbUikD1GDsuBFTWnjjvGQGJXgrY8uWiXtr/RX32Vco7SwLsebd8mzjkAMfL+drM7zJJmFO52m2p6T3YzP7H3Zv5bZ3deMH7brfcLZUS0NsbK+94TF2UHw8KmnJXUpBepqsZDCEsAD9P2WUNBexdED6F/I9orVa8l2r+h5VGWp3FeJAXCch8w4ZD7LGmaYaOOgtaePLqjFeBSswGiq8+QgnPC15y+n1CF+SHecXrp7Wzqmji0prKR5Vq1dokQyBNTVlsYAFAvNCe80kyAR+aJ7FKr1ha3vxT+9LBChI1G1dchPrmiQDSc0ahdNrp
 8zadYYpI
 NkOVsM4bWsZ4CDKDqYywugXnlsNoEIJh4H3Xsdc5Oz+iWLJqGDU02uooJgEWmI7I0G1+Emk9afEEgy6EkPQL0FZxP7ptCMqjSy+B7LuUWDj+cxI8mbvc4iQ2iesxmaTa4vP5Mnvzn+hEe2NJIx6UvGUumkRMyQy2NQ4Sk7HHJvQ5HtPYyPy6K/I7HKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Bin <yebin10@huawei.com>

This patch is prepare for support drop_caches for specify file system.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 include/linux/mm.h |  1 +
 mm/internal.h      |  3 +++
 mm/shrinker.c      |  4 ++--
 mm/vmscan.c        | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..5bab9472a758 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4470,6 +4470,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm);
 
 void drop_slab(void);
+void drop_sb_dentry_inode(struct super_block *sb);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..4690a58c4820 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1662,6 +1662,9 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
+			     struct shrinker *shrinker, int priority);
+
 int shmem_add_to_page_cache(struct folio *folio,
 			    struct address_space *mapping,
 			    pgoff_t index, void *expected, gfp_t gfp);
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 4a93fd433689..075e4393da9c 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -368,8 +368,8 @@ static long add_nr_deferred(long nr, struct shrinker *shrinker,
 
 #define SHRINK_BATCH 128
 
-static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
-				    struct shrinker *shrinker, int priority)
+unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
+			     struct shrinker *shrinker, int priority)
 {
 	unsigned long freed = 0;
 	unsigned long long delta;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 01d3364fe506..310bed25df78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -455,6 +455,56 @@ void drop_slab(void)
 	} while ((freed >> shift++) > 1);
 }
 
+static unsigned long drop_shrinker_node(int nid, struct shrinker *shrinker)
+{
+	unsigned long freed = 0;
+	struct mem_cgroup *memcg = NULL;
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		unsigned long ret;
+
+		struct shrink_control sc = {
+			.gfp_mask = GFP_KERNEL,
+			.nid = nid,
+			.memcg = memcg,
+		};
+
+		if (!mem_cgroup_disabled() &&
+		    !mem_cgroup_is_root(memcg) &&
+		    !mem_cgroup_online(memcg))
+			continue;
+
+		ret = do_shrink_slab(&sc, shrinker, 0);
+		if (ret == SHRINK_EMPTY)
+			ret = 0;
+		freed += ret;
+		cond_resched();
+	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
+
+	return freed;
+}
+
+void drop_sb_dentry_inode(struct super_block *sb)
+{
+	int nid;
+	int shift = 0;
+	unsigned long freed;
+
+	if (!sb || !sb->s_shrink)
+		return;
+
+	do {
+		freed = 0;
+
+		for_each_online_node(nid) {
+			if (fatal_signal_pending(current))
+				return;
+			freed += drop_shrinker_node(nid, sb->s_shrink);
+		}
+	} while ((freed >> shift++) > 1);
+}
+
 #define CHECK_RECLAIMER_OFFSET(type)					\
 	do {								\
 		BUILD_BUG_ON(PGSTEAL_##type - PGSTEAL_KSWAPD !=		\
-- 
2.34.1


