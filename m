Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E85BC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017746B008A; Fri, 11 Sep 2026 07:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31BB6B008C; Fri, 11 Sep 2026 07:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48516B0093; Fri, 11 Sep 2026 07:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADB336B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:55:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 399C91201CB
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:55:13 +0000 (UTC)
X-FDA: 85201325706.13.5DF3717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DBF020007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:55:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deeqH56z;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127711;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaEE2m98VxsAIpBLTzOMtwe4jDMgF++Z84ekkzKeswk=;
	b=f8MzMI8wrq5Khs6kAXo7m2dVZnqfTidep+EqG0RjjhYtENLxgVdxx0Et0ywplghwW1FdGW
	epyU9Rpv//18a/aKgKntOu/W7mvKl0fXe/jF3p38rALaKKlFaqRjgHHFaPuDyQaICQAnb3
	qIBnRABN7bWwE2L34kuhtvQ4963MBMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127711;
	b=Jjj84KDs3q9EF07/p1mKVB+zYn0A5zaLru0p15VUYlr7qVLjE7W5v1SUPQQVajH9o/Houq
	Gi976cWLZET27bcmdPaY3anMeCkTUu0w7G8tmlfpZ58+QBd8ALnInMDpMhO94/FRxj0Q1j
	f98Adr53iU13rebpjsP3zJoKSAAtzhg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deeqH56z;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7097A44817;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D918C4AF19;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=812lZgP0nZKQzPW/829pcJ1XpzeFnqWVerOb/wTWmZM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=deeqH56zH18qjNrMcC7DOd2Ovphz86ITvjiBudQUXCv3I1uXWHHOS9NBdX2GCGgyQ
	 DaKkXaM5R8k8upQZlU/yQm73skqXo4i+Uq38Byy4y57J2BaiNFwuY16MnbL5n6GQuc
	 MfehUZqBjuPWUA8Si4M1tcens4lsndcYgn3jKtuzWFopF1pz/j8XboGKpCtewqDUaq
	 CU7iY9gegzUz+fnmAhH0uwSNOJR4SwG2gYegYVRs1M7S3D32az5GErhAiKfJ7KbJMF
	 klh85B6puEL17VK/88s85zAkFS5tlMb/hGOlG79CvG20DrL8m0lXG36duMA13Aa9RJ
	 JQxkS5cL7Nh/w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A051C88E54;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:08 +0800
Subject: [PATCH RFC v2 05/15] mm/mglru: make folio lru referenced times
 count a generic API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-5-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
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
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=6566;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sl9oGI385dpNBKTnFrEsaoQodEeUL5C6uVYMyQKT218=;
 b=WnnrsfQJcZ207GAQreMw8xwJIEDcbjputonZZn9uY0Xj4u54Z2w1nZD7H+WibPnYVffHJ8JUV
 O/jQuRtOoevAWuq0845ed2pYiVoEs2AX+SEsXwsKaVDZxc0kOZ71PXx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: ssjd3psous7mcpzrj3zpkhckcop1tmqf
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DBF020007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789127711-445096
X-HE-Meta: U2FsdGVkX18xqqULM+AFqiteP4VXOsLfWLcuGrVCUSsopzSLOwqiQejBH0vaGSUszZXEY1AGPAExvjIt4KJwEXGtUsoLq/i1Uha03+tU+TAmaF97PMrJb5eKkdW7AzJCnpHZDHq9+5WSPsZry/FuaiMNo0Bq/V16iNc+x+ZkMSZL7PoIez/QwAUiyrXMPCRAm2hSbtevR6M+QLtOINzoo8VHGa3fUFb3TxlknbeNRtSET3mU7hXH76Lci5l7eMWAKjwrWGGwN+n77VDzBi3lBmMZnBuwT/6gYEil78PiUPcHy4Q1uIMyTYAsn2RFZgmZbLpXoHjGaARkzjBBspxsJ6JR7NIrse0Mva/fSU4hNNLSlNKNz+ZPVol5T8m5VxGymNhhIPgNiif5oj8aZ5jwcf9cpZirY7jDptbb/GYKGaVKEzwfaeF52ihcKpX2XsCF6Fx0FJKeVJfsadqWIszr0zPzrTmP9fmtH8ASFhzD1riZ4q6YJDSHPlKsKsx1EzMgiidVOgXkMNo2xY3veuatsUqJtotQSjrVrhUReckLmzfIx2DLnPAibEaMBSzST7hOm4ONx68bnAhmJbBmiv6YjNkO+isX3TUbp6ZFI4IbKZaTkGRI3E2LtZNIML40Kqdnid4sVh2KJTKfaiwuSwejcXbko4CcON2BBYdwEkrqb7mGT4jZ3YZlh1sdBr29MuCeMWZ/J7+EDHn/AyS1bmNYqPjZ0YW/PcysX8Yqjq7qsp5TVvCq1393oAT371DQyb6RgNWD/3lOTOYel8DclKOWA1Vj4yN1vUTDTi9Hj5XfahyoFfxZclhtmK2Bz06/ONKO/j+FP9xvz6D9MAP2x6AH0QMWzICpHpnPAAig/+6E7lLjhHsecZ8/CJqUcg/worOwosC7GsQWk/Z60ygqWc5oV18hPJIZggnkL+ynBtkVhEhCRUpz8y8wCxCf84lObSofypjQg35Uh7nykLwqB5b
 yiViKu6S
 hSF/BFWclRG/ahSfybh4mTycAyatcFdM/4l0aNS8HHaWUjVCTDi0v4iTyHIHyS4Ek3QVzDdQLnBf6XLJXjJeytOM23oJxznK1NfZGEhuipIFW8QImuvTTphM03VfspmBeI78cUzy65jGjzjoVVVRqyFLTwoj45odU/M1xe34md+8BFKW8OyysQuzMxzGWnazrZgHYkQmv6VVOXtVfMUNifSl6JRZAZezhrkvSXIgrovmxXucPYFAbIqhouIVvVaC3QC3V1W5k3Hbjxmpr6uPx3y+m2envmrpFNadYT0T1Qr+q4Ph1ogtjWlPhJv2ECCmyfldM09U9XKGmAaEe3zP+imrGa7M0uF5ahF7Fp99Kx52JqoPXkLUE8Ue1GB50UmtiGfZAmmQsdTO4kzptn0khu+VZTg==
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
index 7c8288661edd..5a62b83b4168 100644
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
index a369d0c95c38..b1ccffc4e7cd 100644
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



