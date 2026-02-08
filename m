Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70180EF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6F26B009F; Sun,  8 Feb 2026 16:59:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CFE6B00A0; Sun,  8 Feb 2026 16:59:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD096B00A1; Sun,  8 Feb 2026 16:59:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E86F06B009F
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD94FBA410
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:05 +0000 (UTC)
X-FDA: 84422655450.15.D6E0EF6
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9ACAA0006
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IlujDS/P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU6FG/1ImjDgjh8K5anzkahxddqp677D6NQQqJ3zZIs=;
	b=ZKNFw7Q1rBjltitXOkYG8Gg3e4vR7kBbO1ee2COt9OthGcqeUMWoR4++/B3gvoOC1dk9or
	mOWoB6T8drp1XemfqQexYo5V5JWOsozgMEc+S5PxgXiL7W4/XJfU7hVwknE/H9XLaYD4H1
	yGdMEPulYyfbodDg/f6fVE2ZbbgyFDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587943; a=rsa-sha256;
	cv=none;
	b=0+LXyzJPmXHNxyDKkz7UTq0LT+tdYY/rLxMNFwMhNh3WyGQPZJNIgJYG6hYnZPO0sLCLz8
	QWvcy6v8u2Sfu1mLFNyakfhcvnCuIeHqAuOB9HhunsNQhE6PsNpIbK/A7/BRq57ATGMMkK
	PWULoMy1MH1BI9kYka7nvqC8lEIIS4g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="IlujDS/P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfccba483eso1261922a34.0
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587943; x=1771192743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OU6FG/1ImjDgjh8K5anzkahxddqp677D6NQQqJ3zZIs=;
        b=IlujDS/PWocjuunYnj8a5jpfZP6kTNrlhppf052afVs0EwFaUYP1Ancu9gj8O2RuQT
         +N7jBtzFIn/RlcfgalkhuP96bKJzTHIH5fX0djWTI6NWJNDaflM+5XVDg8OpxIt8M8ie
         l7Z5ymGvz18bDcBO/bfSyPOd1DlPV1QwkcLNO/cZJR1+/18Jy2FJWuGFJsEAJE+1iQPg
         mHtlKucCA/9PjQn2tw5XEMqvrlff/3RnoqAcT+ypnUPMuTNGtfpU5ImTvGQ2mCT5npZP
         n59/alR9I4R844I/2gyoF04T4yhhurngsOq77q1OkTh2ZknaEs+gzkN1I5qBfu6AJ5CU
         kBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587943; x=1771192743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OU6FG/1ImjDgjh8K5anzkahxddqp677D6NQQqJ3zZIs=;
        b=P5Svj42NfgnnBWOf0YKl4/OszNHdKNLfYMg/MAkfLL9iJZ+U/99MymH3kqO44JZYJY
         ekW+7ShwzESPI6d+NGgqdk9tdPVq6N3TVQEGiLOD8IQq9ko7g5jUQSlxjzKB+C2qteLt
         iiGsxBw0uQGc6MvbDlOYqyxZw/AvbkCibWHQ2IVmTUDjJcYBS7yuiDgotcUpgkon/oH1
         AfoRJ4U0rGDMvAlRtD5yZRDUUmBm0zDbYPO1/Tgu7NIqojx/m0dHwMwpi8JMsI98OtFX
         IcKTc6IjBqNF7d83mcPCKBGLOnuEE++3W1OfjO71432UpCf+Go/LNdjavFikt38qJS5A
         /IMA==
X-Gm-Message-State: AOJu0YyuMq6oK8/QfCBdCB/C9YPaVZL0lkA8TTaqk22ZGvbEiV5RWWrc
	SVKP2Cs/RNwaTNYdlzZlmMXqPEiE7aA6rSmctgUOTvSbKklx8QdC1/Uc7GEJ61wgC0Ml6A==
X-Gm-Gg: AZuq6aKzdPwBr1ypAE1XAj/Ke/Gb/9qWYHbkuXqcmgiYVNZoB8YVlC2Gg8eiol53ekH
	xGjKyrdNf5T8TTZDTw/o9gw1Sn7lFILD4DG17qw2lu4x1rtDNdLWoRXS+34YSgld3Cu3qw4yqM4
	xJ14pKujSX232P6Het2NTgZv6qVcqFFHFyoVZHnGDC1SSJDM+0P58BI/dizUqjoudpycq/XtRdN
	+LBDCnDTVzINXBlr46Hrwqy4c2eAfsYEpk8Q47+tEsgN3IeqCnkS4hmZ6snytldiJO5NTAUfQ9f
	zWOEaCMprrtm6CWuyufYiiylQqEbI/nW0k37XryT0gtGfeQDSvwX0zQ0LIlScQQtFjW4DqOok5p
	MiirjBazlvNcpDy//AtLKI3UAWPHgfjataqZ4rNuqzHIeSkzbZ02cbR6qZgGN8cegeTc02lK8h+
	L9wS5kAsnjI9ZnEiJKGrVp7GY1GI8R5aT2vQ==
X-Received: by 2002:a05:6830:6518:b0:7c7:8280:9207 with SMTP id 46e09a7af769-7d464689b0amr5463329a34.37.1770587942713;
        Sun, 08 Feb 2026 13:59:02 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d464785f68sm6051602a34.16.2026.02.08.13.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:02 -0800 (PST)
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
Subject: [PATCH v3 10/20] swap: move swap cache to virtual swap descriptor
Date: Sun,  8 Feb 2026 13:58:23 -0800
Message-ID: <20260208215839.87595-11-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9ACAA0006
X-Stat-Signature: bee3dedp56keb1h8snocr4iyeo6z9m9z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770587943-651932
X-HE-Meta: U2FsdGVkX19VISVtj49V+zjtj2KFu387NWiCIN9f40NHxY+yoEtUIPEuwk3RL39NX0E0GQVTo7azVjsiNgbDycR/w/L4xbfWN6cIE1lqkFUKA29SWqEoGuhmzBhxjaub0GrBAZt/9FmzoGQt7OTORkuSJEDPQLPZVgS+R9ZKiRMG1lbcZFB3VvyJ6m57x5oPHakUpzhU6XOFIF3SYgSlSvdT12lBXPsHmJ//YUiitJimB6JRvBDov1I9bI2BLv4gFb9SCJwDdg6t2dIkK56/xFXsinUtJLdVMh/YDSOlZTb4NfL1gmiurd80+y8mdMdcKAUbJc0J/nNKczGqNBZoIgTOzkGUpNi3X+dwu7M/Au3NNc6MDwXq6NZ+As6a6OH6T0A9ojEO8w4CfCum2mN55Gt8lPrWq9qLKwvrsq/EimfozyC5c7Q4Xug/+FdMMoc65kgCiVIvJH0z720hGelCKxQOv+HzLG37wZIF6x1z3/bvMpbCDQMqyAgPmhAE94sHgnVtBxprJoM5HIxKAAxbFFYLKhVvzHogfoQN00rpBB/yMahQ7dPUxEddkKt174J6v1GPoAlvaAzhaobyz2p7eJ2wppF21IOPcvvI7IptlWo8gtT5WnEmWd2Xb6db1t1hcBSEQt1Rqgfn40SHogLddDMqo8TkusG0vvbJW2ca5oB0EN+sBbt85OGy9OfXSTMnNXGTPwLgAYycH+6DiuKyfslBBCHbg+yhBEvNq1V5O4V4vFzfvB0QvygapRRT/5MddFjHHk07k1DTuS+RFodEM4XXK0JVMgOKqzjf30p6+G9OyLER2R8CzAHdlPpGyOS6Incq+/kIqtATd2c2ldW92vEbjgfPdBLmKDlOr5F2PDLvL1n+l8ZUm1MuPIgH+sVnHxu04Nq10IELFmNRoZfz8BfxwALFXihhAB8UecScInunMvWGAIcdrIW1eFRCgjDorhYGMSLx/31bNk5B1Ju
 cY1lDHTD
 cg8AjXIj6NbHJaS3eF3/HLKXE9Qqulbs1TiJiJysVGnqytSZeLoelcovQBUhpGJWEuhK8DFQpOtAteGuifbZFMifS6+FP7+LPnLwRk9wwhEJZRwWbU0I9bEM/oJFkNdbKJB9mIAsOs6NElChCVpykeV/yKuWopk3D2ZXpQqQd4Hqbto4Ir+PiTTDLI5Ilchg2/vBCh4b6yRyPDipLqBp03uHdKLycF535HrpdSIwL2xLWqhV20J0dA4/EyycM5ymw/kdCX8sECf29o51MPQhDXdVaP9oDp/LXvwpsGEjx65Nomp6m0/cTubeKPdSdUtQXkLOksfpqtkXTgVf3gRzNMZoHTAAVZNNAD/n0hiD9/ts2oqiZ0Y19T0zlpqVVwNPDnPSpbgakzmaPkq9ux6Y7WgS5eg+ygaQSAtXrahfzESsS3U8zkOiGQirgZ30sqF418jHLlc6dPIWSHcCKWjcipX9o1DLQzAtyiTqGFvELSPVA8wykCpAiKBnEeP0MBKakg1gbPK3Vr0Rx8dkZUaiMuzd3a6chRJZneSO4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the swap cache (and workingset shadow for anonymous pages) to the
virtual swap descriptor. This effectively range-partitions the swap
cache by virtual swap clusters (of PMD sized), eliminate swap cache lock
contention.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/huge_memory.c |   4 +-
 mm/migrate.c     |   6 +-
 mm/shmem.c       |   4 +-
 mm/swap.h        |  16 +--
 mm/swap_state.c  | 251 +--------------------------------
 mm/vmscan.c      |   6 +-
 mm/vswap.c       | 350 ++++++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 364 insertions(+), 273 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 21215ac870144..dcbd3821d6178 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3825,7 +3825,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				return -EINVAL;
 			}
 
-			swap_cache_lock();
+			swap_cache_lock(folio->swap);
 		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
@@ -3901,7 +3901,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			unlock_page_lruvec(lruvec);
 
 		if (folio_test_swapcache(folio))
-			swap_cache_unlock();
+			swap_cache_unlock(folio->swap);
 	} else {
 		split_queue_unlock(ds_queue);
 		return -EAGAIN;
diff --git a/mm/migrate.c b/mm/migrate.c
index 11d9b43dff5d8..e850b05a232de 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -600,13 +600,13 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	newzone = folio_zone(newfolio);
 
 	if (folio_test_swapcache(folio))
-		swap_cache_lock_irq();
+		swap_cache_lock_irq(folio->swap);
 	else
 		xas_lock_irq(&xas);
 
 	if (!folio_ref_freeze(folio, expected_count)) {
 		if (folio_test_swapcache(folio))
-			swap_cache_unlock_irq();
+			swap_cache_unlock_irq(folio->swap);
 		else
 			xas_unlock_irq(&xas);
 		return -EAGAIN;
@@ -652,7 +652,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 
 	/* Leave irq disabled to prevent preemption while updating stats */
 	if (folio_test_swapcache(folio))
-		swap_cache_unlock();
+		swap_cache_unlock(folio->swap);
 	else
 		xas_unlock(&xas);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 13f7469a04c8a..66cf8af6779ca 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2168,12 +2168,12 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	new->swap = entry;
 	folio_set_swapcache(new);
 
-	swap_cache_lock_irq();
+	swap_cache_lock_irq(entry);
 	__swap_cache_replace_folio(old, new);
 	mem_cgroup_replace_folio(old, new);
 	shmem_update_stats(new, nr_pages);
 	shmem_update_stats(old, -nr_pages);
-	swap_cache_unlock_irq();
+	swap_cache_unlock_irq(entry);
 
 	folio_add_lru(new);
 	*foliop = new;
diff --git a/mm/swap.h b/mm/swap.h
index 5eb53758bbd5d..57ed24a2d6356 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -205,10 +205,12 @@ void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
-void swap_cache_lock_irq(void);
-void swap_cache_unlock_irq(void);
-void swap_cache_lock(void);
-void swap_cache_unlock(void);
+
+/* linux/mm/vswap.c */
+void swap_cache_lock_irq(swp_entry_t entry);
+void swap_cache_unlock_irq(swp_entry_t entry);
+void swap_cache_lock(swp_entry_t entry);
+void swap_cache_unlock(swp_entry_t entry);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
@@ -256,12 +258,11 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry, gfp_t gfp, void **shadow);
+void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow);
 void swap_cache_del_folio(struct folio *folio);
 /* Below helpers require the caller to lock the swap cache. */
 void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct folio *old, struct folio *new);
-void swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
@@ -422,9 +423,8 @@ static inline void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static inline int swap_cache_add_folio(struct folio *folio, swp_entry_t entry, gfp_t gfp, void **shadow)
+static inline void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadow)
 {
-	return 0;
 }
 
 static inline void swap_cache_del_folio(struct folio *folio)
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c5ceccd756699..00fa3e76a5c19 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -41,28 +41,6 @@ struct address_space swap_space __read_mostly = {
 	.a_ops = &swap_aops,
 };
 
-static DEFINE_XARRAY(swap_cache);
-
-void swap_cache_lock_irq(void)
-{
-	xa_lock_irq(&swap_cache);
-}
-
-void swap_cache_unlock_irq(void)
-{
-	xa_unlock_irq(&swap_cache);
-}
-
-void swap_cache_lock(void)
-{
-	xa_lock(&swap_cache);
-}
-
-void swap_cache_unlock(void)
-{
-	xa_unlock(&swap_cache);
-}
-
 static bool enable_vma_readahead __read_mostly = true;
 
 #define SWAP_RA_ORDER_CEILING	5
@@ -94,231 +72,6 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", K(total_swap_pages));
 }
 
-/**
- * swap_cache_get_folio - Looks up a folio in the swap cache.
- * @entry: swap entry used for the lookup.
- *
- * A found folio will be returned unlocked and with its refcount increased.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * Return: Returns the found folio on success, NULL otherwise. The caller
- * must lock nd check if the folio still matches the swap entry before
- * use (e.g., folio_matches_swap_entry).
- */
-struct folio *swap_cache_get_folio(swp_entry_t entry)
-{
-	void *entry_val;
-	struct folio *folio;
-
-	for (;;) {
-		rcu_read_lock();
-		entry_val = xa_load(&swap_cache, entry.val);
-		if (!entry_val || xa_is_value(entry_val)) {
-			rcu_read_unlock();
-			return NULL;
-		}
-		folio = entry_val;
-		if (likely(folio_try_get(folio))) {
-			rcu_read_unlock();
-			return folio;
-		}
-		rcu_read_unlock();
-	}
-
-	return NULL;
-}
-
-/**
- * swap_cache_get_shadow - Looks up a shadow in the swap cache.
- * @entry: swap entry used for the lookup.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * Return: Returns either NULL or an XA_VALUE (shadow).
- */
-void *swap_cache_get_shadow(swp_entry_t entry)
-{
-	void *entry_val;
-
-	rcu_read_lock();
-	entry_val = xa_load(&swap_cache, entry.val);
-	rcu_read_unlock();
-
-	if (xa_is_value(entry_val))
-		return entry_val;
-	return NULL;
-}
-
-/**
- * swap_cache_add_folio - Add a folio into the swap cache.
- * @folio: The folio to be added.
- * @entry: The swap entry corresponding to the folio.
- * @gfp: gfp_mask for XArray node allocation.
- * @shadowp: If a shadow is found, return the shadow.
- *
- * Context: Caller must ensure @entry is valid and protect the swap device
- * with reference count or locks.
- * The caller also needs to update the corresponding swap_map slots with
- * SWAP_HAS_CACHE bit to avoid race or conflict.
- *
- * Return: 0 on success, negative error code on failure.
- */
-int swap_cache_add_folio(struct folio *folio, swp_entry_t entry, gfp_t gfp, void **shadowp)
-{
-	XA_STATE_ORDER(xas, &swap_cache, entry.val, folio_order(folio));
-	unsigned long nr_pages = folio_nr_pages(folio);
-	unsigned long i;
-	void *old;
-
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
-
-	folio_ref_add(folio, nr_pages);
-	folio_set_swapcache(folio);
-	folio->swap = entry;
-
-	do {
-		xas_lock_irq(&xas);
-		xas_create_range(&xas);
-		if (xas_error(&xas))
-			goto unlock;
-		for (i = 0; i < nr_pages; i++) {
-			VM_BUG_ON_FOLIO(xas.xa_index != entry.val + i, folio);
-			old = xas_load(&xas);
-			if (old && !xa_is_value(old)) {
-				VM_WARN_ON_ONCE_FOLIO(1, folio);
-				xas_set_err(&xas, -EEXIST);
-				goto unlock;
-			}
-			if (shadowp && xa_is_value(old) && !*shadowp)
-				*shadowp = old;
-			xas_store(&xas, folio);
-			xas_next(&xas);
-		}
-		node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-		lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
-unlock:
-		xas_unlock_irq(&xas);
-	} while (xas_nomem(&xas, gfp));
-
-	if (!xas_error(&xas))
-		return 0;
-
-	folio_clear_swapcache(folio);
-	folio_ref_sub(folio, nr_pages);
-	return xas_error(&xas);
-}
-
-/**
- * __swap_cache_del_folio - Removes a folio from the swap cache.
- * @folio: The folio.
- * @entry: The first swap entry that the folio corresponds to.
- * @shadow: shadow value to be filled in the swap cache.
- *
- * Removes a folio from the swap cache and fills a shadow in place.
- * This won't put the folio's refcount. The caller has to do that.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache
- * using the index of @entry, and lock the swap cache xarray.
- */
-void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
-{
-	long nr_pages = folio_nr_pages(folio);
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
-
-	for (i = 0; i < nr_pages; i++) {
-		void *old = xas_store(&xas, shadow);
-		VM_WARN_ON_FOLIO(old != folio, folio);
-		xas_next(&xas);
-	}
-
-	folio->swap.val = 0;
-	folio_clear_swapcache(folio);
-	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
-	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
-}
-
-/**
- * swap_cache_del_folio - Removes a folio from the swap cache.
- * @folio: The folio.
- *
- * Same as __swap_cache_del_folio, but handles lock and refcount. The
- * caller must ensure the folio is either clean or has a swap count
- * equal to zero, or it may cause data loss.
- *
- * Context: Caller must ensure the folio is locked and in the swap cache.
- */
-void swap_cache_del_folio(struct folio *folio)
-{
-	swp_entry_t entry = folio->swap;
-
-	xa_lock_irq(&swap_cache);
-	__swap_cache_del_folio(folio, entry, NULL);
-	xa_unlock_irq(&swap_cache);
-
-	put_swap_folio(folio, entry);
-	folio_ref_sub(folio, folio_nr_pages(folio));
-}
-
-/**
- * __swap_cache_replace_folio - Replace a folio in the swap cache.
- * @old: The old folio to be replaced.
- * @new: The new folio.
- *
- * Replace an existing folio in the swap cache with a new folio. The
- * caller is responsible for setting up the new folio's flag and swap
- * entries. Replacement will take the new folio's swap entry value as
- * the starting offset to override all slots covered by the new folio.
- *
- * Context: Caller must ensure both folios are locked, and lock the
- * swap cache xarray.
- */
-void __swap_cache_replace_folio(struct folio *old, struct folio *new)
-{
-	swp_entry_t entry = new->swap;
-	unsigned long nr_pages = folio_nr_pages(new);
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
-	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
-	VM_WARN_ON_ONCE(!entry.val);
-
-	for (i = 0; i < nr_pages; i++) {
-		void *old_entry = xas_store(&xas, new);
-		WARN_ON_ONCE(!old_entry || xa_is_value(old_entry) || old_entry != old);
-		xas_next(&xas);
-	}
-}
-
-/**
- * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid and all in one single cluster,
- * not occupied by any folio.
- */
-void swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	XA_STATE(xas, &swap_cache, entry.val);
-	int i;
-
-	xas_lock(&xas);
-	for (i = 0; i < nr_ents; i++) {
-		xas_store(&xas, NULL);
-		xas_next(&xas);
-	}
-	xas_unlock(&xas);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
@@ -497,9 +250,7 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 	if (mem_cgroup_swapin_charge_folio(new_folio, NULL, gfp_mask, entry))
 		goto fail_unlock;
 
-	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (swap_cache_add_folio(new_folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
-		goto fail_unlock;
+	swap_cache_add_folio(new_folio, entry, &shadow);
 
 	memcg1_swapin(entry, 1);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 558ff7f413786..c9ec1a1458b4e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -712,7 +712,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	BUG_ON(mapping != folio_mapping(folio));
 
 	if (folio_test_swapcache(folio)) {
-		swap_cache_lock_irq();
+		swap_cache_lock_irq(folio->swap);
 	} else {
 		spin_lock(&mapping->host->i_lock);
 		xa_lock_irq(&mapping->i_pages);
@@ -759,7 +759,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 			shadow = workingset_eviction(folio, target_memcg);
 		__swap_cache_del_folio(folio, swap, shadow);
 		memcg1_swapout(folio, swap);
-		swap_cache_unlock_irq();
+		swap_cache_unlock_irq(swap);
 		put_swap_folio(folio, swap);
 	} else {
 		void (*free_folio)(struct folio *);
@@ -798,7 +798,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 cannot_free:
 	if (folio_test_swapcache(folio)) {
-		swap_cache_unlock_irq();
+		swap_cache_unlock_irq(folio->swap);
 	} else {
 		xa_unlock_irq(&mapping->i_pages);
 		spin_unlock(&mapping->host->i_lock);
diff --git a/mm/vswap.c b/mm/vswap.c
index 9aa95558f320a..d44199dc059a3 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -37,9 +37,15 @@
  * Swap descriptor - metadata of a swapped out page.
  *
  * @slot: The handle to the physical swap slot backing this page.
+ * @swap_cache: The folio in swap cache.
+ * @shadow: The shadow entry.
  */
 struct swp_desc {
 	swp_slot_t slot;
+	union {
+		struct folio *swap_cache;
+		void *shadow;
+	};
 };
 
 #define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
@@ -170,6 +176,24 @@ static int vswap_debug_fs_init(void)
 }
 #endif
 
+/*
+ * Lockless version of vswap_iter - assumes caller holds cluster lock.
+ * Used when iterating within the same cluster with the lock already held.
+ */
+static struct swp_desc *__vswap_iter(struct vswap_cluster *cluster, unsigned long i)
+{
+	unsigned long slot_index;
+
+	lockdep_assert_held(&cluster->lock);
+	VM_WARN_ON(cluster->id != VSWAP_VAL_CLUSTER_IDX(i));
+
+	slot_index = VSWAP_IDX_WITHIN_CLUSTER_VAL(i);
+	if (test_bit(slot_index, cluster->bitmap))
+		return &cluster->descriptors[slot_index];
+
+	return NULL;
+}
+
 static struct swp_desc *vswap_iter(struct vswap_cluster **clusterp, unsigned long i)
 {
 	unsigned long cluster_id = VSWAP_VAL_CLUSTER_IDX(i);
@@ -448,7 +472,6 @@ void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
 	if (!entry.val)
 		return;
 
-	swap_cache_clear_shadow(entry, 1);
 	zswap_invalidate(entry);
 	mem_cgroup_uncharge_swap(entry, 1);
 
@@ -460,6 +483,10 @@ void vswap_free(swp_entry_t entry, struct swap_cluster_info *ci)
 		return;
 	}
 
+	/* Clear shadow if present */
+	if (xa_is_value(desc->shadow))
+		desc->shadow = NULL;
+
 	if (desc->slot.val)
 		vswap_rmap_set(ci, desc->slot, 0, 1);
 
@@ -480,7 +507,7 @@ int folio_alloc_swap(struct folio *folio)
 	struct vswap_cluster *cluster = NULL;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci;
-	int i, err, nr = folio_nr_pages(folio), order = folio_order(folio);
+	int i, nr = folio_nr_pages(folio), order = folio_order(folio);
 	struct swp_desc *desc;
 	swp_entry_t entry;
 	swp_slot_t slot;
@@ -533,9 +560,7 @@ int folio_alloc_swap(struct folio *folio)
 	if (mem_cgroup_try_charge_swap(folio, entry))
 		goto out_free;
 
-	err = swap_cache_add_folio(folio, entry, __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN, NULL);
-	if (err)
-		goto out_free;
+	swap_cache_add_folio(folio, entry, NULL);
 
 	return 0;
 
@@ -668,6 +693,321 @@ static int vswap_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
+/**
+ * swap_cache_lock - lock the swap cache for a swap entry
+ * @entry: the swap entry
+ *
+ * Locks the vswap cluster spinlock for the given swap entry.
+ */
+void swap_cache_lock(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_unlock - unlock the swap cache for a swap entry
+ * @entry: the swap entry
+ *
+ * Unlocks the vswap cluster spinlock for the given swap entry.
+ */
+void swap_cache_unlock(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_lock_irq - lock the swap cache with interrupts disabled
+ * @entry: the swap entry
+ *
+ * Locks the vswap cluster spinlock and disables interrupts for the given swap entry.
+ */
+void swap_cache_lock_irq(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock_irq(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_unlock_irq - unlock the swap cache with interrupts enabled
+ * @entry: the swap entry
+ *
+ * Unlocks the vswap cluster spinlock and enables interrupts for the given swap entry.
+ */
+void swap_cache_unlock_irq(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_unlock_irq(&cluster->lock);
+	rcu_read_unlock();
+}
+
+/**
+ * swap_cache_get_folio - Looks up a folio in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * A found folio will be returned unlocked and with its refcount increased.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * Return: Returns the found folio on success, NULL otherwise. The caller
+ * must lock and check if the folio still matches the swap entry before
+ * use (e.g., folio_matches_swap_entry).
+ */
+struct folio *swap_cache_get_folio(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	struct folio *folio;
+
+	for (;;) {
+		rcu_read_lock();
+		desc = vswap_iter(&cluster, entry.val);
+		if (!desc) {
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		/* Check if this is a shadow value (xa_is_value equivalent) */
+		if (xa_is_value(desc->shadow)) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		folio = desc->swap_cache;
+		if (!folio) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return NULL;
+		}
+
+		if (likely(folio_try_get(folio))) {
+			spin_unlock(&cluster->lock);
+			rcu_read_unlock();
+			return folio;
+		}
+		spin_unlock(&cluster->lock);
+		rcu_read_unlock();
+	}
+
+	return NULL;
+}
+
+/**
+ * swap_cache_get_shadow - Looks up a shadow in the swap cache.
+ * @entry: swap entry used for the lookup.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * Return: Returns either NULL or an XA_VALUE (shadow).
+ */
+void *swap_cache_get_shadow(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	void *shadow;
+
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	if (!desc) {
+		rcu_read_unlock();
+		return NULL;
+	}
+
+	shadow = desc->shadow;
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	if (xa_is_value(shadow))
+		return shadow;
+	return NULL;
+}
+
+/**
+ * swap_cache_add_folio - Add a folio into the swap cache.
+ * @folio: The folio to be added.
+ * @entry: The swap entry corresponding to the folio.
+ * @shadowp: If a shadow is found, return the shadow.
+ *
+ * Context: Caller must ensure @entry is valid and protect the cluster with
+ * reference count or locks.
+ *
+ * The caller also needs to update the corresponding swap_map slots with
+ * SWAP_HAS_CACHE bit to avoid race or conflict.
+ */
+void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void **shadowp)
+{
+	struct vswap_cluster *cluster;
+	unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	unsigned long i;
+	struct swp_desc *desc;
+	void *old;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
+
+	folio_ref_add(folio, nr_pages);
+	folio_set_swapcache(folio);
+	folio->swap = entry;
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+	spin_lock_irq(&cluster->lock);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		old = desc->shadow;
+
+		/* Warn if slot is already occupied by a folio */
+		VM_WARN_ON_FOLIO(old && !xa_is_value(old), folio);
+
+		/* Save shadow if found and not yet saved */
+		if (shadowp && xa_is_value(old) && !*shadowp)
+			*shadowp = old;
+
+		desc->swap_cache = folio;
+	}
+
+	spin_unlock_irq(&cluster->lock);
+	rcu_read_unlock();
+
+	node_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr_pages);
+}
+
+/**
+ * __swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ * @entry: The first swap entry that the folio corresponds to.
+ * @shadow: shadow value to be filled in the swap cache.
+ *
+ * Removes a folio from the swap cache and fills a shadow in place.
+ * This won't put the folio's refcount. The caller has to do that.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache
+ * using the index of @entry, and lock the swap cache.
+ */
+void __swap_cache_del_folio(struct folio *folio, swp_entry_t entry, void *shadow)
+{
+	long nr_pages = folio_nr_pages(folio);
+	struct vswap_cluster *cluster;
+	struct swp_desc *desc;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	int i;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_writeback(folio), folio);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON_FOLIO(!desc || desc->swap_cache != folio, folio);
+		desc->shadow = shadow;
+	}
+	rcu_read_unlock();
+
+	folio->swap.val = 0;
+	folio_clear_swapcache(folio);
+	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+}
+
+/**
+ * swap_cache_del_folio - Removes a folio from the swap cache.
+ * @folio: The folio.
+ *
+ * Same as __swap_cache_del_folio, but handles lock and refcount. The
+ * caller must ensure the folio is either clean or has a swap count
+ * equal to zero, or it may cause data loss.
+ *
+ * Context: Caller must ensure the folio is locked and in the swap cache.
+ */
+void swap_cache_del_folio(struct folio *folio)
+{
+	swp_entry_t entry = folio->swap;
+
+	swap_cache_lock_irq(entry);
+	__swap_cache_del_folio(folio, entry, NULL);
+	swap_cache_unlock_irq(entry);
+
+	put_swap_folio(folio, entry);
+	folio_ref_sub(folio, folio_nr_pages(folio));
+}
+
+/**
+ * __swap_cache_replace_folio - Replace a folio in the swap cache.
+ * @old: The old folio to be replaced.
+ * @new: The new folio.
+ *
+ * Replace an existing folio in the swap cache with a new folio. The
+ * caller is responsible for setting up the new folio's flag and swap
+ * entries. Replacement will take the new folio's swap entry value as
+ * the starting offset to override all slots covered by the new folio.
+ *
+ * Context: Caller must ensure both folios are locked, and lock the
+ * swap cache.
+ */
+void __swap_cache_replace_folio(struct folio *old, struct folio *new)
+{
+	swp_entry_t entry = new->swap;
+	unsigned long nr_pages = folio_nr_pages(new);
+	struct vswap_cluster *cluster;
+	struct swp_desc *desc;
+	unsigned long cluster_id = VSWAP_CLUSTER_IDX(entry);
+	void *old_entry;
+	int i;
+
+	VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swapcache(new));
+	VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked(new));
+	VM_WARN_ON_ONCE(!entry.val);
+
+	rcu_read_lock();
+	cluster = xa_load(&vswap_cluster_map, cluster_id);
+	VM_WARN_ON(!cluster);
+
+	for (i = 0; i < nr_pages; i++) {
+		desc = __vswap_iter(cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		old_entry = desc->swap_cache;
+		VM_WARN_ON(!old_entry || xa_is_value(old_entry) || old_entry != old);
+		desc->swap_cache = new;
+	}
+	rcu_read_unlock();
+}
 
 int vswap_init(void)
 {
-- 
2.47.3


