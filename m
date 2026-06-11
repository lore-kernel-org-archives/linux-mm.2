Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C22CCD98D4
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCDF66B008C; Thu, 11 Jun 2026 05:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E1C6B0092; Thu, 11 Jun 2026 05:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6CC06B0093; Thu, 11 Jun 2026 05:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A511F6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:48:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E60DC1E83
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:13 +0000 (UTC)
X-FDA: 84867156066.27.48387B6
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81867180002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnRp+4rV;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171291;
	b=y3D0PnvmKCLheFmSoZceb4FBdBYHDn+PK5OQx8bRE8i5x7GHDDs0ckQiLku0IY+u7JmLpk
	/TyoyEMxqhyB202Iy7XoIGHyFXESaUR5kQLlHZHT5uuifUYCJxXLRYORpx2+gR8+cGzmly
	lEUMv6C/q1LsP0hXaa0Tb+uLt5ztUd4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnRp+4rV;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgDnCy/Lqt4KlSBPy89Hrdxm/Zy1/HrZbOMvwPuOqc8=;
	b=WzFmthJe3Z2mvNg9OhAjyFTmWc7jiJ6A50Yp8hj+0APrsR3VG8+bKgb0ZFgIVcAQD2WC6P
	4KfvTX+uaZBjs0E1ulQAFMjV+Y8aJ5flwYQy0VtYuHZ8YDo66wx1mPBhNDfcuW8bG/XYqc
	SuGvw6K427xEFqC0e7KRB1tM3XJpJ8A=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf1f074a12so79142635ad.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781171290; x=1781776090; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RgDnCy/Lqt4KlSBPy89Hrdxm/Zy1/HrZbOMvwPuOqc8=;
        b=cnRp+4rVMpiSaaIMlYZLsj6yca1PsPNcTV9TLceVGUopNWxM26vFm4KT0/Mlq4JJDN
         cuzVPg40/VLptZAGRumwZIGXrNxmaVx43xPCePSdI/Iyo+TUqBtAjisn4YPvMI/RjBAO
         5l20iFrH36kvI8gqDLrN9eUG4RRgz3MrAicFm8Ef/EIO1uqOkO7RQCPLpBCdo/LSZyOf
         pFGgwbDOACqkt7Oc96MrQupA3UW1rLZV4kq8+x0od1f3wRhNdsTy47EbQ0rHeVMhSE0h
         WEpFxZmGNLAqc6BEkqfJD1pxeOn091oo/WRmqIsc1N3ekEaEDkn/xdbnV2e+bjA5P2Y0
         E73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171290; x=1781776090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RgDnCy/Lqt4KlSBPy89Hrdxm/Zy1/HrZbOMvwPuOqc8=;
        b=D2Ovylya5WtRkLhkONRTdQpkEnAC1YQzQhWfa+UxWZNdyS/Ny9OzJtbjYrzIQgk+fI
         hOXpUKXs51JD4E8U1wPlCe0lyiqex7jLnYmnavCcLE8cmhLrJRYf5dk5nVAQXRd/COOp
         AVHd44ioAqTnAmLNKlLxVJUKzL+X9qaahBDYCFHQReAYmSdL6JM8+eBrhuuwWFKkAcxI
         jZ2gDiyGMX3l8zdA584U0dVK5usVwwus3J2z4TwVbMyl9r0Nx8Ca8bDCwLWs2XsdYP9N
         4kEvSkEzIrPmZmFob5Dtjo694jHJRl6+/0r3gJmORD4utwo4vPR9T0Km5zVX+eV8k+zy
         CZBg==
X-Gm-Message-State: AOJu0YzPbS++2WrMkIm5KwAnLM/5qLS1wdHEfjoCvs1EN1wiJ4r42JLk
	5wmqeJpZ0LatI1cGkw529aiSoejm7EKTtoutpmibp+cU4Ou9rwYserDAbGTSNTzD
X-Gm-Gg: Acq92OFlhupO7m3nrx74zarnTpu5sP4CiuB2iG+o8aEPn56VQy7SjfJjkujy6afEVbA
	C1E+f5TmBjU7PIWzrB3+hcteow1qAiLakrXPRAZqU58WzWA6By7mvZ4St2Sg6tY76xko4wz0tau
	yfvSgkfpoqaG3pALXNbs+Ts7jKtEHYWTYUlybKaWI4qVq/dTaIlZ4FKMpRldadOkjfBYiWVXri5
	3TtZiIzeMkKydPqg+eBcR+Z6wZT2m69ZlqqT8md3rCKwQIDDJalFzra8KZ0O/QSJ62KrfKX5AHP
	dPtlsuCzh0Thnrmfc3eGpbH7iD9R+oy8tmvEmEaXzSuPMfv45xL3kpbCFgDZRtoZkyoHK/Tap4Q
	EnNuBnfEt6e3Pi9uUvbffdUAYe8yzaJXWIv2iDfKCrVgiPUrotYr7J8zByPGKBXvheRCjXSiyJt
	Oc3Du75aNmryPQW4/KNkR3N8OBGZTbMAXvvSeAU2Echt8=
X-Received: by 2002:a17:903:38c4:b0:2ba:4e84:966 with SMTP id d9443c01a7336-2c2f2a77a19mr24838595ad.36.1781171290236;
        Thu, 11 Jun 2026 02:48:10 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629d042sm283324905ad.60.2026.06.11.02.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:48:09 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 1/3] mm, swap: make SWAPFILE_CLUSTER runtime
Date: Thu, 11 Jun 2026 15:17:51 +0530
Message-Id: <442a71907f1dddf12c55a74c0aa24fb70e3fb412.1781170904.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781170904.git.ritesh.list@gmail.com>
References: <cover.1781170904.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81867180002
X-Stat-Signature: ohn4qxh1c5geob66fyciazcgwbiejdo9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781171291-678527
X-HE-Meta: U2FsdGVkX18HsDzEyLkNPmcGdSX/FutrkXO6G+Xpbqg+PHHkEcedYhQQDY+Wh2trWtJJJ5kka2TZBIpaXOoU8lARMOqx6zPFwI4VrHTyCaI6+MxK3GKd7Y1CyxRjopEOoMTHtBdFNUBHPzEwM3OyN3dUik4WiXC/XbAUpTQXRSxdszeEhw3yXcSDOAbtSu2Dwtw9/OUGb0aHa9F/Q55As+4gcXLMupUAH781rK2l8rfMexsQAVN0f0xD48YUiucnMUhTtjI0cbPhDM77cO6zFw4UcFChxsCZLhx2lmJC1F1bRUOoGz3+tgb9ikwt+sI22vJ1IBaVAQcxduD2UXQak005/lmrlwpchD5t6jeVEMb5bUOSLirH9wdLjdjX9d+Y1hukDAZncM7LSPkzIWwOqiImCjKUyjjK5DJwvfsXr8+tUSF07ZmoXRBQey1/A2acbgqk/itoCjHLM6lbWNgM4y9K2vL9HDLcC3gafZ4m0Im0+VSq/NFX9Aa4JpKNN1FgjdCRdmTw908vMUBYYWJQpMdiCQFmw+zq5pNCJnKxozKyj25EuIBuHBonwROK1RRE68/CS3LLxN+2gikMEA8Wgf1/8Zj1+zrKmA608JwHTfbT3XN1HpP144zU9ZdI8jFDogJiNVrQbxJGntcH/zAXaYbYQT5wjfB5Hu8EK+/vt5h98ty4QNzWNRw8yPUiarbB5Y0Hk/OcYHfcySjhpwbw8BbePfNJ/UGSpStRSmgTs9fxbIK1Dvb/M71x/vUhQTlez09p7rsd0YkFqVicpq0fuC8ffc0fUDiCXaNwgIhMT0FyDWB5NIk02i0cTzGZHeSKoCA3M341kUXNTXYOQDnvxEPPDnzgYsd+zZhk8sAIBPWgNe9upVoox/jTzJ/b5MsXGx4DrosmyNmilCXTeRzfnD++CddsoL3ltd2myzK/X2XO7ysoB9yn8AvoxFAGI+4URUplz93N1HSvI6Ja6Nq
 4iwS3VsK
 fVy2Y787xMfo7QQyQuq0VL95wm9AMyP4sUFeW1FABvvLDcrB3vWK7DEHvVR55JvqsAW5mqByKcNdQwym16Ta3XOwt3mkxnsusbaLu8F1S3wZsMnkWl3aNikbhuaKk6ESuaKUc7uPXJ44ahl37uLeVCRrt+i6OQl1Y9ahCbSCCyCa4gwm/SiY0wh15P0B1tAMTKU1DloqC4uYpyQuxEPdeYLQE4p9fOKw8SipnJTlnPyo3pVtJ1apgD0Sw+J2UTeNCCwEDHY2f8FvfB2iD0yKf2g+8o+SOYBSuAiKi2HkNwLyuu49Ls49oeExN3evLozo4goFGPp14vNBAI5vahTinAULpiD+ioAQ9eBMt1+Hk3JJxT20X5zHipL2FvxfhYu8u3g+W+rNnKNkJMt+nOyOHoy1w8RqwpFTJfI+jVpOE8RdKFiJgwUuaiBGhOunuclX8qGER+DuhGsC07BdQVxD9ENEVjBa+RFC/QKuD/seBuRZ6BPbf2XJuDXsqup3ltp4K+KzBF4Ac4ksBmKAyuqMcjwYTH75BTsLn9bGZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PowerPC Book3S64, MMU is selected at runtime, so macros like
PMD_SHIFT are effectively runtime variables in the Book3S64 code. THP
swap code uses these macros to size some of its array data structures
based on PMD_ORDER e.g. SWAPFILE_CLUSTER macro is used for this very
purpose.
Hence this patch initializes SWAPFILE_CLUSTER at runtime and also
modifies swap_table and swap_memcg_table which were earlier using this
macro for defining the number of table entries.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 mm/swap.h       |  5 +++--
 mm/swap_table.h |  6 ++----
 mm/swapfile.c   | 27 ++++++++++++++++++++++-----
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..956879a69ddd 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -26,11 +26,12 @@ extern int page_cluster;
 #define SWAP_TABLE_HAS_ZEROFLAG		((BITS_PER_LONG - SWAP_CACHE_PFN_MARK_BITS - \
 					  SWAP_CACHE_PFN_BITS) > SWAP_COUNT_MIN_BITS)
 
+extern unsigned int swap_slots_in_cluster __read_mostly;
+#define SWAPFILE_CLUSTER	swap_slots_in_cluster
+
 #ifdef CONFIG_THP_SWAP
-#define SWAPFILE_CLUSTER	HPAGE_PMD_NR
 #define swap_entry_order(order)	(order)
 #else
-#define SWAPFILE_CLUSTER	256
 #define swap_entry_order(order)	0
 #endif
 
diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..90e2a7852300 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -8,16 +8,14 @@
 
 /* A typical flat array in each cluster as swap table */
 struct swap_table {
-	atomic_long_t entries[SWAPFILE_CLUSTER];
+	DECLARE_FLEX_ARRAY(atomic_long_t, entries);
 };
 
 /* For storing memcg private id */
 struct swap_memcg_table {
-	unsigned short id[SWAPFILE_CLUSTER];
+	DECLARE_FLEX_ARRAY(unsigned short, id);
 };
 
-#define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
-
 /*
  * A swap table entry represents the status of a swap slot on a swap
  * (physical or virtual) device. The swap table in each cluster is a
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..016a5aa0cb93 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -129,6 +129,17 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+unsigned int swap_slots_in_cluster __read_mostly;
+bool swap_table_use_page __read_mostly;
+
+static unsigned int generic_swap_slots_in_clusters(void)
+{
+	if (IS_ENABLED(CONFIG_THP_SWAP))
+		return HPAGE_PMD_NR;
+	else
+		return 256;
+}
+
 /* May return NULL on invalid type, caller must check for NULL return */
 static struct swap_info_struct *swap_type_to_info(int type)
 {
@@ -437,7 +448,7 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 		return;
 
 	rcu_assign_pointer(ci->table, NULL);
-	if (!SWP_TABLE_USE_PAGE) {
+	if (!swap_table_use_page) {
 		kmem_cache_free(swap_table_cachep, table);
 		return;
 	}
@@ -456,7 +467,7 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 	if (rcu_access_pointer(ci->table))
 		return 0;
 
-	if (SWP_TABLE_USE_PAGE) {
+	if (swap_table_use_page) {
 		folio = folio_alloc(gfp | __GFP_ZERO, 0);
 		if (folio)
 			table = folio_address(folio);
@@ -471,7 +482,8 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
-		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
+		ci->memcg_table = kzalloc_flex(*ci->memcg_table, id,
+					       SWAPFILE_CLUSTER, gfp);
 		if (!ci->memcg_table) {
 			swap_cluster_free_table(ci);
 			return -ENOMEM;
@@ -3912,14 +3924,19 @@ static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
 
+	swap_slots_in_cluster = generic_swap_slots_in_clusters();
+	swap_table_use_page =
+		(swap_slots_in_cluster * sizeof(atomic_long_t) == PAGE_SIZE);
+
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
 	 * the content before use. So it's safe to use RCU slab here.
 	 */
-	if (!SWP_TABLE_USE_PAGE)
+	if (!swap_table_use_page)
 		swap_table_cachep = kmem_cache_create("swap_table",
-				    sizeof(struct swap_table),
+				    struct_size_t(struct swap_table, entries,
+					    SWAPFILE_CLUSTER),
 				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
 
 #ifdef CONFIG_MIGRATION
-- 
2.39.5


