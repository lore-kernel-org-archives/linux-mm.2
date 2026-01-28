Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12133D35699
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A846B008A; Wed, 28 Jan 2026 04:30:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708816B008C; Wed, 28 Jan 2026 04:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621286B0092; Wed, 28 Jan 2026 04:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 520F06B008A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A73ED3CCE
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:42 +0000 (UTC)
X-FDA: 84380852724.16.24FC562
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C913100005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TLbbKaV2;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHlSAs5DuvtfLFcO72y/SZVl/BNUOfJD+/3/mENU6eI=;
	b=BcTBJ6yl8zbACojmlhE/NHuwNSTGq0DT55eLPGb0oDQSNv+HohSgBYQ623zlqpuDqRfQP2
	eMEdGb+ZV68c24LvuzS3LrbJ68ylAcsYElyLC+j+gJ7OxPop/ANbNaCwTi6jUqJDfXFicC
	e9XYe2lQ8M2M9LZjl9GKRtOvIazVKNU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TLbbKaV2;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592640; a=rsa-sha256;
	cv=none;
	b=lKVprgT3CC8Wc65+zlT+S/7d+y8+pdIAAYQnBuWglHZQ55m/bBKH0Wfvd/nSNB9oi6CNB0
	UJOV4giSGwZwouFx73wnuOecdSK6+pExgEauwA+Tfia/KDpgyEQLCr7PFmRe1L1llNdQA+
	4PNJtsLUYuLHs+JnpOVe8ZgyoYGNj0U=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34b75fba315so3933256a91.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592639; x=1770197439; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHlSAs5DuvtfLFcO72y/SZVl/BNUOfJD+/3/mENU6eI=;
        b=TLbbKaV2Ngrq3spM0uOVYZqkJoMGC2MQSdxEYA3MBZIUQ55h4kLEHY0rxqdm7VSK9z
         4vj4h0TSDv8YWIjWksrT/gURzxQRSVVkL5nmp9OmKWHd6VJhvZ9+oDdKb2bdo4wHksFZ
         8Plyo2e0LJ76Ngg83JNNvJDfTAyVZpQrEfd2ep4OjhKsbfF3MqasgrARfw75DoyyJefl
         wCTkwTNo8GSaSrGqOe66AU1Bvt9yzusPeV9DGzenGCksPjQ35aLvYttxmcJ7oV32awt0
         CgnmC867dah/ld1+VYPG5jhqlHtuj3itifgfrDfDMAl40UYKUKu8+Ymarkk/+fSybWdl
         XfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592639; x=1770197439;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jHlSAs5DuvtfLFcO72y/SZVl/BNUOfJD+/3/mENU6eI=;
        b=dJiDd7tUjUZdS3xsXr2BNWnwlBlYSz9flBTqEvwmtmdSK/vYc8ghCWPjY9tlhAQCFY
         Xe6drHFpiHiyJ+2nT/ENR2Haj7a51HnlLqAN2wcEQs7L1kBa2TTL5ZqEH90Iee8f2CvI
         d1KQPoouAoFBl3+VsPrhYJUdgOd3uhogUZZEMnUlxDfU4seh2FPba+s2XqKQN/7OfnAo
         bdaPAVZ0p4X1ndfBlYH1O1ncdarnuGxtPRe3w9mQsGDl/HVasu+J5HvzfTJHgvH0mVIk
         JxfqvRltinhpD26TFE7ReHiweVthY4Qu+wb8S0+3rHfR7fqpwskIRwM3FzOnCavo4Kjo
         ph7g==
X-Gm-Message-State: AOJu0Yzzn3Ay3y/XLBfSl6udOqeWRp59nsLU1Y4vslGq9EDJX+HlE6xO
	bZx8OsImzNgqUaQsfDVk91LOKzq2hoVCsK15jAUDBBljeBvPQVi+23/R
X-Gm-Gg: AZuq6aLHE2gvrU/crkqG/g1p+HbuVDBhrm0d7ELHnBkjl+gYnL13d/qWoTYOl7oWqJS
	OMu4kQvobTPveinHp8zGgBzEADKLqE1h33MG4UpCZCDss0+xfjaPm1JZWD5hSu3U9uqSCCFi2Ly
	jxf0QSfhQz1iE7bPDyoAJugSXv+Z4IaYms3wJAcePjQFDyqSg0WdpZVSCg7Adnr4ZRyC/eRqA7G
	3kdStdMNU5D1T2MehwcKPzOQZNJsGEmXKQNgrfML0kycxlEZDv3rQrdLh0ObSLuYD0x4ZST+9BE
	IRN4kT/oaHniw8r9nn87T6vzZfpLAKhl6b1iKphWBh/+hgm4rdhxiHrZijmj84c1UM/33b29qI+
	6HgfYrBNCD+Y5sDLoYQ9NP1bSVcrXKiHTAuw8awV10QHBlLXBBkH1Tb5XYoFrKtCTOukUjzk4uk
	9KL2pD9AoniJsib4mydKSBZgqtCqgyIMpy7ve+ilQ2hIJIMyQ0aZmso+WqHUIXTMkyFOcA
X-Received: by 2002:a17:90b:3901:b0:32d:f352:f764 with SMTP id 98e67ed59e1d1-353fecd08edmr3956834a91.2.1769592638870;
        Wed, 28 Jan 2026 01:30:38 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:38 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:26 +0800
Subject: [PATCH v2 02/12] mm, swap: clean up swapon process and locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-2-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=8467;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GJOWST4EwFrMORO0TdNo6OHVZqB7RqYtXfEdQQZxN/s=;
 b=eaBaKJzF46kjkypZP4nFMY/8qkGRIc2eKS5aNa/7z8CfPJ2+q5TnR7L2qpYC5Tg4uFLC0vwP6
 y1nyymxOE7tDzhppZ04ZedNIJwRp+gsO1r1jLBx2C6FJ81WxLUiledA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam11
X-Stat-Signature: fmoieejmqeojzjjon1thiotqqdb8mitq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C913100005
X-HE-Tag: 1769592639-871687
X-HE-Meta: U2FsdGVkX18notdoiO94ZixciTAu+/AT8aHQzAu7Q7hUiLnqy4wzKfW4C+4S4MbFt25lgtixgm8H9iHP7PyrNNJHg7E1KVMSge559wxHsOUBeFvbMAc6S/guTa55A8YAUwYlD2eA7zO1IYr8IA3S9AKt6J8k2mQxTUbbBMvoWjhLRWfvX3kGCJ7y+3irv33D7bP+33lP+AazYgizEu4/CccHTDRvAt0ltChTLQw+36PYCCL1QuibLDyYU0PCPRPV+evCG6WN5B0cV/CQeKtxIb4LxXhp79lc70FTUEY6YOR1EC4wcTQ5ADahwUzcYsVZZYxkEf+kzGxv4cq/+0R/7ltfnET7KdJp7O942EGrZn35R0UUbKHjzedBf8yFZYnnwa3QJBJqvQTRTdVki3C88UK4pifaszhwgUORNwxS8FjEerT0hq/0phILi14466oqREpfoRj306dEzGcyEMhGdaD9/FXp+ZaMioGK13sw9LY0ZYibQSfWmBEyW86TSapb89HoTglGvALff9IRL66rw/CVHFcqj1ysP7sFvUTPMdFRX8C1robLS/vABFtqvy4RztotYKR/N40mTI/i9QaCSrcwse184Uw+ESkP9DEmUHB44GpIORSAGrRnfQ0NVG5oxGiLGTVTTBpfyX1TosZSvD4aPZP5UZlKHc0uXHgnRsFzRrO/XVsBafwxPC/rKZvDKjoTTRH3yyCVK/ISkC6991X6MfnElJo23WS4rVlERBapyGynwgCAxs7zVtuj5PZ3aVhXWIpoy+3R9TILrBesG2KzNGTn3vnpmNC4LQ8i1dNhZM2/DxSUZjEAvLbTE8KA4ZfruuQ2tFJbZo68ndH0a6EPClu1dmxUuk3pHHl+1Uecaa4CiVLHJXoj/8mTGwh0wLBvzZe6USJxMwB58qEPrxNvnBj6ovwLa2CTH2tgnGtkwWPyow7bFXifvtKiXEOaJ4+hBMoMUiQzrOtOFiw
 rPw0RpUT
 4K2/uXIOeLlr0O0gltHj0boS8Zkx2kDqsIMBKFbrr0GiCq2tPeRDeuGYnxqGxJkoXF/a6gP7xnsI06blMz6pHgmNb8LZhIngM8AXorzYHbDc2llgIUdxXIyvAM6k/QY8Weu/8cWPpfBe8zcKxPLhmwVPY1k1EgPwqaR8KXH8Hd7ms1uUO4r6NNm1S3yURW36Eo/xodubiNRWg5CSZAdDNS9p+N68TRHrSitRERbizKKP5Hs9XOqQNR9mjCa3+k333ITv3qPQO6gFkpuP0oKBEBKJWHaV2AlDgnJJ2AibfM721cQrOGkNelH8ZKKyYAnDkNVYN9WOMF0hoNth7BhD0SP8qPAy4OA9XceDq+69hn+NiCnGABOMwUXWS/0w1c1u6/LS9m0qpftnpnd1h96Fp8DMqxfQtmNmv+ANIFyYAX5dYJjdOdr90qFqLIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Slightly clean up the swapon process. Add comments about what swap_lock
protects, introduce and rename helpers that wrap swap_map and
cluster_info setup, and do it outside of the swap_lock lock.

This lock protection is not needed for swap_map and cluster_info setup
because all swap users must either hold the percpu ref or hold a stable
allocated swap entry (e.g., locking a folio in the swap cache) before
accessing. So before the swap device is exposed by enable_swap_info,
nothing would use the swap device's map or cluster.

So we are safe to allocate and set up swap data freely first, then
expose the swap device and set the SWP_WRITEOK flag.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 87 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 521f7713a7c3..53ce222c3aba 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -65,6 +65,13 @@ static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
 			 enum swap_cluster_flags new_flags);
 
+/*
+ * Protects the swap_info array, and the SWP_USED flag. swap_info contains
+ * lazily allocated & freed swap device info struts, and SWP_USED indicates
+ * which device is used, ~SWP_USED devices and can be reused.
+ *
+ * Also protects swap_active_head total_swap_pages, and the SWP_WRITEOK flag.
+ */
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
 atomic_long_t nr_swap_pages;
@@ -2646,8 +2653,6 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 }
 
 static void setup_swap_info(struct swap_info_struct *si, int prio,
-			    unsigned char *swap_map,
-			    struct swap_cluster_info *cluster_info,
 			    unsigned long *zeromap)
 {
 	si->prio = prio;
@@ -2657,8 +2662,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	 */
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
-	si->swap_map = swap_map;
-	si->cluster_info = cluster_info;
 	si->zeromap = zeromap;
 }
 
@@ -2676,13 +2679,11 @@ static void _enable_swap_info(struct swap_info_struct *si)
 }
 
 static void enable_swap_info(struct swap_info_struct *si, int prio,
-				unsigned char *swap_map,
-				struct swap_cluster_info *cluster_info,
-				unsigned long *zeromap)
+			     unsigned long *zeromap)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, prio, swap_map, cluster_info, zeromap);
+	setup_swap_info(si, prio, zeromap);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
 	/*
@@ -2700,7 +2701,7 @@ static void reinsert_swap_info(struct swap_info_struct *si)
 {
 	spin_lock(&swap_lock);
 	spin_lock(&si->lock);
-	setup_swap_info(si, si->prio, si->swap_map, si->cluster_info, si->zeromap);
+	setup_swap_info(si, si->prio, si->zeromap);
 	_enable_swap_info(si);
 	spin_unlock(&si->lock);
 	spin_unlock(&swap_lock);
@@ -2724,8 +2725,8 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }
 
-static void free_cluster_info(struct swap_cluster_info *cluster_info,
-			      unsigned long maxpages)
+static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
+				   unsigned long maxpages)
 {
 	struct swap_cluster_info *ci;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
@@ -2883,7 +2884,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	vfree(swap_map);
 	kvfree(zeromap);
-	free_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(cluster_info, maxpages);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 
@@ -3232,10 +3233,15 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 
 static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
-			  unsigned char *swap_map,
 			  unsigned long maxpages)
 {
 	unsigned long i;
+	unsigned char *swap_map;
+
+	swap_map = vzalloc(maxpages);
+	si->swap_map = swap_map;
+	if (!swap_map)
+		return -ENOMEM;
 
 	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
@@ -3256,9 +3262,9 @@ static int setup_swap_map(struct swap_info_struct *si,
 	return 0;
 }
 
-static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
-						union swap_header *swap_header,
-						unsigned long maxpages)
+static int setup_swap_clusters_info(struct swap_info_struct *si,
+				    union swap_header *swap_header,
+				    unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
@@ -3328,10 +3334,11 @@ static struct swap_cluster_info *setup_clusters(struct swap_info_struct *si,
 		}
 	}
 
-	return cluster_info;
+	si->cluster_info = cluster_info;
+	return 0;
 err:
-	free_cluster_info(cluster_info, maxpages);
-	return ERR_PTR(err);
+	free_swap_cluster_info(cluster_info, maxpages);
+	return err;
 }
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
@@ -3347,9 +3354,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	int nr_extents;
 	sector_t span;
 	unsigned long maxpages;
-	unsigned char *swap_map = NULL;
 	unsigned long *zeromap = NULL;
-	struct swap_cluster_info *cluster_info = NULL;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3360,6 +3365,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/*
+	 * Allocate or reuse existing !SWP_USED swap_info. The returned
+	 * si will stay in a dying status, so nothing will access its content
+	 * until enable_swap_info resurrects its percpu ref and expose it.
+	 */
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -3442,18 +3452,17 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* OK, set up the swap map and apply the bad block list */
-	swap_map = vzalloc(maxpages);
-	if (!swap_map) {
-		error = -ENOMEM;
+	/* Setup the swap map and apply bad block */
+	error = setup_swap_map(si, swap_header, maxpages);
+	if (error)
 		goto bad_swap_unlock_inode;
-	}
 
-	error = swap_cgroup_swapon(si->type, maxpages);
+	/* Set up the swap cluster info */
+	error = setup_swap_clusters_info(si, swap_header, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = setup_swap_map(si, swap_header, swap_map, maxpages);
+	error = swap_cgroup_swapon(si->type, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
 
@@ -3481,13 +3490,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		inced_nr_rotate_swap = true;
 	}
 
-	cluster_info = setup_clusters(si, swap_header, maxpages);
-	if (IS_ERR(cluster_info)) {
-		error = PTR_ERR(cluster_info);
-		cluster_info = NULL;
-		goto bad_swap_unlock_inode;
-	}
-
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
@@ -3540,7 +3542,9 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
 	si->swap_file = swap_file;
-	enable_swap_info(si, prio, swap_map, cluster_info, zeromap);
+
+	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
+	enable_swap_info(si, prio, zeromap);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3566,13 +3570,18 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
 	swap_cgroup_swapoff(si->type);
+	vfree(si->swap_map);
+	si->swap_map = NULL;
+	free_swap_cluster_info(si->cluster_info, si->max);
+	si->cluster_info = NULL;
+	/*
+	 * Clear the SWP_USED flag after all resources are freed so
+	 * alloc_swap_info can reuse this si safely.
+	 */
 	spin_lock(&swap_lock);
 	si->flags = 0;
 	spin_unlock(&swap_lock);
-	vfree(swap_map);
 	kvfree(zeromap);
-	if (cluster_info)
-		free_cluster_info(cluster_info, maxpages);
 	if (inced_nr_rotate_swap)
 		atomic_dec(&nr_rotate_swap);
 	if (swap_file)

-- 
2.52.0


