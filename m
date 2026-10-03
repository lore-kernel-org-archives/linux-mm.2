Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B623CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA766B0093; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A776B0096; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610D96B0095; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBD96B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94D13C0151
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
X-FDA: 85281310842.16.AFB0371
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94E67160005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qzz0VRRV;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxNA8fNcEAE+jJpgJbcRasLZHBPn1JnIaEZe0ikGRAc=;
	b=hXDj8i0II2h1k0jmpK5FPcf31r9REaccHrTR3yoGAZ8C4Muy5WYzu4cG6eIyMQrFWu9W6G
	oC9HgqM+vKKCOrQsV/zgT0OcQg6eKq9vpTlRmrFLXIau7CCckG1B4J2sag/uAEZBetM+xw
	GVfJaMHG+Uiu90WfUbV4fg5MjWu47Hk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032119;
	b=19o+PUH+mdME5Yy2Nf4pq/tl6RHurOo5o/bxIOQHD/5tfoPPvHFWOL4iAp664LL8d1Plci
	/DjdRpjT7yJPvOZ47TvEo9HnGYAOKcAZLnLXJgdnOJp6fGe8/SmaKJutASWxQSE5NMOXh1
	fToDMtgTWl+lV9Hf0xsZM0zF/gr6gDg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qzz0VRRV;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 416FF44839;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD44CC4AF54;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032117;
	bh=2zunL8OA4bqhlAxynm8ZqlaDuyjOEMxQ68aHk6i8y6Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qzz0VRRVdoJodYa5sj2MXSacVyxCx+PhXyat7e9Ttve6CDItSekHtXX1y8Kv4TEmQ
	 kQFdOPfJuJ9+KoUo0JqGWEzadstjEhqdLfQpF9qUJQ3me6/tlbEx3QuBzNwRQnTxbn
	 P9b8hIFWE0nWDRDzG1XZQkGIEJyhDDyYy1K8BzfcVH79/LfkRbCZCKAe3SkI6hbAcZ
	 Z6zboRmOS7oIaxsoPG7ZJkzf+hxP+Ukkh000lSKUBRNwm9Wqjq3WkKHFF4OX60gaSh
	 f0BIYBqRHVjIs4KkQLRPy/EvtxkoYC3aFHiG7M43lyMkQ16Nn2ddxX1WsFS+wp89Nx
	 0Rk5P1TzZxK5g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B580BCA5FEC;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:16 +0800
Subject: [PATCH RFC v3 05/17] mm/mglru: make folio lru referenced times
 count a generic API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-5-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=6566;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cg7am3pYrERrVRp2yR7TavrhY0e+r4J/BlDibD33qso=;
 b=7cMXfxkEkULl4hluTeEC58U+XNBxBY9l0HeXPGm5HSJc9NlN1xH98NwJwLHYMvt28Irppr+7W
 f+E5g4kJseaD8CDHpgCFluXvv9tbwufnW6hmEH9bL80NA/yC/vDiTLO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: fjbcxupdwpa8tx4szarbfmi9csrps4jc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 94E67160005
X-HE-Tag: 1791032119-795587
X-HE-Meta: U2FsdGVkX1/IM0c227AFfQURPb72MM0MeI1NnEUBte1BOjaD+mBI6SnHjEBqUNUPaHsz9HOOpDFMn4lOUstnILCfNd0CrLaKoAt42Rc4mTiRdygFsCFzwGvuRV3hVUpqxfWZdcOV8StrXYH3T+5AgEGADH1Z3tol3iVV3vRyYlJfDgPkT1Smoqyq5jszBKUB41Z2q8x/rGef1gIiQcLwLvKf4+/vKLZzVzQg70IsJoNJRqW93ULpRF16FxPbMGY2T+qo6VQQsuBdvncUenxJ8SrU7e4uR2d3k4xfGF3CWnj3H38XMgPY97e0ULrLfvBSHF/N3wd4vhiKX2BqVIEE1UvwVHUEW/o7OGlv0PMhit5bp1OqoRfoMF5lNzktQFsB9+115Bf6jFAgrr5puU7GZT2/FVqmvoHVOZN0kpHB8u837wplf464I2lCha6YH5qQu0QWxLrfkVJwUWaVw1n1E9H5LNQz4gGdJMmiP+ts4cLvXmL0MLLhqzZkpjFJSm7I9WkOTy+nNbWEHHvNqRoDvjXrvDQ1mi1kyguKo/T4KzHabsN2GqU0YOZSvilr1Hb2a4BeOb98M4H/xnqdE0I0v6ER+I0oUoWmJ2VyZEdawivtdQz6tGb9TTyZUBqC4/Fnp6/IGP1CpIB2Bk8aGGeUyS8hS5AHzfQvxBM/TDWMYRWq3/XFzljTK8mt9s+DxVZJ1TW8cc+OOzVy1LF2Ro2AyhKveNamAq/Y1x75EK25oE6JMcVNaaOpc7AZt2QS6aBHO8QCZ3WIU9eC4AOyXmUc38dnPxLcjDokrCx/5vrxOoWJ+746I0UiFxoLeyXsLIIo4BJmdHEYWuUDwnzQ+MHN7MbRWhAttIBPwaICaaAyPoluHRsfI/6uyanFIqsIT1+XrAj4c2vk5BU1zuHVXDNZdPuX237v9j8M3xCozTBWyn7xelX5lHR/3oWDaLVVSP3ueiyoJo8z157zpjH6ZBO
 5d5urJK/
 CgGb3VFjQpSnEa8AUXarmmLIcc5puhJuf8w6kq3LmIUbdjnhIjfPBNRhPOJSjW7frGxRyWrGlhCd1VruHQ32xDrwVRms+1MzT2b1oRJo4xA8B7jtLY4QkGzZWwO4AIlmguF43Ay34WQfBEVxJlG5q7dZ+TfZCfLvAwSgUAj78re/TI/OmzhaSiSPBXrsNv6sv/cKRFawVpSSAnTcoW64AcVh+EMvY9P/dwD9yX2wAuZZo/B/YQOpK68mIKr0h2UGMIoKD1GnXXyrgLEcDHs0YVWYrRPZCTtd+EZB1u11IIXNJPENLSQc91PToQJXLxyKvx2CaTrXI6Z7T2DBsLa3yLEA0Dm0FK+N6DCmEdMB8A/AwUYoEMU/MySE8ViL1GUVfUjGkjhQcyA3d7XMFsK0PhLp2scN1ucVCTBf8wTj7IH3C7/ZiVE+9ndop+HgYtzJ28+WA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.  Make the folio LRU refs helpers
available regardless of CONFIG_LRU_GEN; without MGLRU the refs bits are
never set, so they are inert.  Move the lru_gen_* helpers into the
CONFIG_LRU_GEN section unchanged.  This prepares for unifying the API
for checking folio referenced and workingset status.

folio_migrate_lru_refs() now migrates the complete refs count,
including PG_workingset (bit 1 of the encoding), bitwise identical to
the direct copy dropped from folio_migrate_flags().  It also gains
off-LRU VM_WARN_ON_ONCE checks, compiled out unless CONFIG_DEBUG_VM.

lru_set_refs_flags() skips the nonexistent mask bits when
LRU_REFS_WIDTH collapses to 0, keeping the generic helpers inert for
!CONFIG_LRU_GEN builds.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 145 +++++++++++++++++++++++-----------------------
 mm/migrate.c              |   2 -
 2 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f778e4056fbe..a3a302e22a47 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -105,54 +105,6 @@ static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 	return lru;
 }
 
-#ifdef CONFIG_LRU_GEN
-
-static inline bool lru_gen_switching(void)
-{
-	DECLARE_STATIC_KEY_FALSE(lru_switch);
-
-	return static_branch_unlikely(&lru_switch);
-}
-#ifdef CONFIG_LRU_GEN_ENABLED
-static inline bool lru_gen_enabled(void)
-{
-	DECLARE_STATIC_KEY_TRUE(lru_gen_caps[NR_LRU_GEN_CAPS]);
-
-	return static_branch_likely(&lru_gen_caps[LRU_GEN_CORE]);
-}
-#else
-static inline bool lru_gen_enabled(void)
-{
-	DECLARE_STATIC_KEY_FALSE(lru_gen_caps[NR_LRU_GEN_CAPS]);
-
-	return static_branch_unlikely(&lru_gen_caps[LRU_GEN_CORE]);
-}
-#endif
-
-static inline bool lru_gen_in_fault(void)
-{
-	return current->in_lru_fault;
-}
-
-static inline int lru_gen_from_seq(unsigned long seq)
-{
-	return seq % MAX_NR_GENS;
-}
-
-static inline int lru_hist_from_seq(unsigned long seq)
-{
-	return seq % NR_HIST_GENS;
-}
-
-static inline int lru_tier_from_refs(unsigned int refs)
-{
-	BUILD_BUG_ON(fls(LRU_REFS_MAX - 1) > MAX_NR_TIERS - 1);
-	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
-	if (refs < LRU_REFS_WORKINGSET)
-		return 0;
-	return fls(refs - 1);
-}
-
 /**
  * lru_set_gen_flags - Set the LRU generation number to specified folio flags.
  * @flags: pointer to the folio flags
@@ -205,7 +157,8 @@ static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
 		*flags |= BIT(PG_referenced);
 	if (refs & BIT(1))
 		*flags |= BIT(PG_workingset);
-	*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
+	if (LRU_REFS_WIDTH)
+		*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
 }
 
 /**
@@ -240,7 +193,77 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
+#ifdef CONFIG_LRU_GEN
 void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
+#else
+static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
+{
+	/* Should not be called with !CONFIG_LRU_GEN */
+	WARN_ON_ONCE(1);
+}
+#endif
+
+/**
+ * folio_migrate_lru_refs - copy the reference state to a new folio
+ * @new: the destination folio
+ * @old: the source folio
+ *
+ * Transfer the reference state to @new during migration: the MGLRU
+ * refs count, or PG_referenced and PG_workingset (bits 0-1 of the
+ * encoding) for the active/inactive LRU.
+ */
+static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
+{
+	folio_set_lru_refs(new, folio_lru_refs(old));
+}
+
+#ifdef CONFIG_LRU_GEN
+
+static inline bool lru_gen_switching(void)
+{
+	DECLARE_STATIC_KEY_FALSE(lru_switch);
+
+	return static_branch_unlikely(&lru_switch);
+}
+#ifdef CONFIG_LRU_GEN_ENABLED
+static inline bool lru_gen_enabled(void)
+{
+	DECLARE_STATIC_KEY_TRUE(lru_gen_caps[NR_LRU_GEN_CAPS]);
+
+	return static_branch_likely(&lru_gen_caps[LRU_GEN_CORE]);
+}
+#else
+static inline bool lru_gen_enabled(void)
+{
+	DECLARE_STATIC_KEY_FALSE(lru_gen_caps[NR_LRU_GEN_CAPS]);
+
+	return static_branch_unlikely(&lru_gen_caps[LRU_GEN_CORE]);
+}
+#endif
+
+static inline bool lru_gen_in_fault(void)
+{
+	return current->in_lru_fault;
+}
+
+static inline int lru_gen_from_seq(unsigned long seq)
+{
+	return seq % MAX_NR_GENS;
+}
+
+static inline int lru_hist_from_seq(unsigned long seq)
+{
+	return seq % NR_HIST_GENS;
+}
+
+static inline int lru_tier_from_refs(unsigned int refs)
+{
+	BUILD_BUG_ON(fls(LRU_REFS_MAX - 1) > MAX_NR_TIERS - 1);
+	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
+	if (refs < LRU_REFS_WORKINGSET)
+		return 0;
+	return fls(refs - 1);
+}
 
 static inline int folio_lru_gen(const struct folio *folio)
 {
@@ -388,20 +411,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
 	return true;
 }
-
-/**
- * folio_migrate_lru_refs - copy the reference state to a new folio
- * @new: the destination folio
- * @old: the source folio
- *
- * Transfer the reference state to @new during migration: the MGLRU
- * refs count, including PG_referenced, or just PG_referenced for the
- * active/inactive LRU.
- */
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	folio_set_lru_refs(new, folio_lru_refs(old));
-}
 #else /* !CONFIG_LRU_GEN */
 
 static inline bool lru_gen_enabled(void)
@@ -428,16 +437,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	return false;
 }
-
-static inline void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
-{
-}
-
-static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
-{
-	if (folio_test_referenced(old))
-		folio_set_referenced(new);
-}
 #endif /* CONFIG_LRU_GEN */
 
 static __always_inline
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..5eefd8547f70 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -786,8 +786,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 		folio_set_active(newfolio);
 	} else if (folio_test_clear_unevictable(folio))
 		folio_set_unevictable(newfolio);
-	if (folio_test_workingset(folio))
-		folio_set_workingset(newfolio);
 	if (folio_test_checked(folio))
 		folio_set_checked(newfolio);
 	/*

-- 
2.55.0



