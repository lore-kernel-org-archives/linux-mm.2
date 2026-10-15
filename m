Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10902CCA466
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8166B00AC; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608976B00A7; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3982F6B00AC; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01AC56B00A7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7230E120108
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:01 +0000 (UTC)
X-FDA: 85325664522.29.7136DD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6419110000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kb391yTr;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088159;
	b=FPX164QN86ZTfiJbHaTSHvtNXui2AfTLDiGCBLVcH9xF6t8qdfqE/GA1HitraNQpxiqcJN
	nyaUWPN1rZW2DNe+mT+sf6Rr+7Rmh54VsstZ86xDVgFHTqLXkFEJCvKEf8ypIytnNSoe5Y
	SG7frTodYhsSU1irSvfr/52Z0ZucWyo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kb391yTr;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088159;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6GxkdUo0csQ1ibXcNRYOC5aFewLmme+BPoZQdgUvpQ=;
	b=f6L1PWrJiG8rTLXv0L5G+njM4XmYIHYEjmusUf6TbeqG14jAlCKuT+swepkRNjss6aRufr
	ggx7pWYvZ6lKeXVF30oBhEtc7jTLtlCWMphtmCQK0FZKrBbUzkBIjNUNj5WnJyLv4+x4Kj
	Bbnlee5Gb9904I4kkjsxWa+LDjbedwY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C63EA447CF;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 780E4C2BD05;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=EtFdBNMl7rTc3+2KnBe5NCt6EPdFW/oy5PCsxQTtGYg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Kb391yTrlC4wqc+SJNZmT89MRNc9OEN475jtNUimO8h5z4RHUz40UWiwBPKlRYi4b
	 BRcSx6NPvAB8Bhlt5ggeFbJd3xK9L38LUm4G4HTyfSR/w68wtAyoQN2MQGcX8Sx5yM
	 0Tzhe6wjKtfLxIypH+atxvRH+FYhV4bwU5QatUIhLIIkJaFBuwp7kU8xv2syKolgMA
	 nBpz1R42+F81MXByxQdA0syxQg+mRfgQUnPpXHVpWwkEnqKyALvYHQyt07h/myF/Hl
	 GOXL+pwGG/dQ/W4Zt8jnBZAIU2bzt2POm4pm7L3eZA2X6Ex92zDcXWf6+lAPZcJnr6
	 AuYFDuEDuTu0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F7FCCA469;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:54 +0800
Subject: [PATCH v4 05/17] mm/mglru: make folio lru referenced times count a
 generic API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-5-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=4691;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=pnvvt+TNjTFasMrCaGELLai88pW+DMjr8ivb+8icxYs=;
 b=2pYnsvVBeywNZk/IqxKSwnVGHLJe4YzTLE0xzeBV928nbdHQBo8JVn3nfsIV5SXIAHdB9m5pu
 um1VbmccsnbBUOWooMumSGVyWRDol3yYP5jq8lKdlkvTeYic/0Sa+u4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6419110000E
X-Stat-Signature: dkf69nxrhiu4g349utxjtasbd7tgfxy8
X-HE-Tag: 1792088159-351752
X-HE-Meta: U2FsdGVkX1858tvx1fuYPfuH7hYoOiggIcG1nmzrf0qvsaC8MUaaaT52mSt9NwHimS14EaOAdgp2mH2E/CLL1yOrZdfn2kSYArz9DvmnXb7WNJTaWxYN6fhR4tKCqj2jXKxr6kP9Gxn4C+uRuwpVX9nhDqBhQz1DqPYuguDlEWQNGBPUbomEd2fpLuALRXwQ/6SIwEitUNQRpUL4lBj0dJeR9q1P/aCh9BNfZHzv5j9Z1NadUEwmW9SYXK1vxT6Hj6XrF1MV1SU6KKX3dgCgy8wFjnInsqFqbVOlDvOmkvv5EA+0V7lVmLDLZnpWyrIMLGhvhFJ2lHsdNt7Ik/1k1ODyWQGGP0PyoinIdAJMNixrcmGgPKT5MIIgmIJTvwIvQlYwUCVeJBiVmRVEgUDn18gErfoGLLWaOzzKmgLmqsAbuhgSsDF9QH1T8/mezl2Zpt66ef2wEbBAF8sL3lYBpRY9DIyU6yBOqpBTgCWf7Z8z7KWRUordo0nHWeXW+W05hng7cII38tZSbP60RO3PPTyFW+KcV6uzh72Eb5sVhdWF7oq5Bzr39OUgTjtS1tYNR/ztLLE5sozg56e25dpoACAXh9VUpdS1ZOubU/Q73J8ibQSlUzbcncD+2/ViC0CLOUvc7Q03fyHhbcb0Kayo9ZBXuLzn5PKhNkJ29KCBlMSS2LE5w1eVAIocdSBxuf7K85w4o2H612GpNM6TZuqeCCsLw1ye8t1T2SIFOnyebj3nGRrdV+IsEkWmz8IT25OoOo53k+sKdQW0vM7hMBWncT4Udoa2yuiLfrkCFbmPm7vf8t9Va80HD0iIen3/epdJdeWDr50FuqmWpWCWEKUDC4rEzMY0ZmO/2eFVz+QpjkKHYo5rTBmCCjBMeo1uR1FQ5TPfcUQopL8IMN0EcG6eXbyjjnjORfkWDtrYc02Hdti2fslG006FF4jHn0f3dxc6zwGwEkez7pjuO7NBPpY
 x8ixIC0i
 kCw2SLvWEzil+t6TY8eS4u7lIksdrPs5aqoJFpj2jIVOkBohQ8CmgcozN7OkqSKJqZhl+r9s2fOZU4zXXyua366GCnZtZSk90KkwVsrN0r+hUhm5tGA2n1dQHVzksNRdrNwW1Ps555ATzEeKREPHDneKNt4Z0xxuUuJED4/2c1g82YJOGRjzUdoV0jWDBWUA+89W/+WDkZCWy5Ta1wh7ysnaoesZPolNciam0jbKeqjiT8Y5gNDc5XAYncvYEGS2UHTT8e36rB3YzI3qEqj57NpvICU/NvDc23pnjGfIYpjs9fHQ+dNn39LCRQOCz1kKbjQ8wH0FN1wMbStI2xKJwzJKtMxMy965hEevP8f7wUm+yupDjhI8Y619Y/Yvou3usqvPUYSbY0Rx4kCA5FOCuUfMDziT7w8nwK0eTOWRv8b1TrC4Lw5WFteUWF+aFGFbwZaYQzlwKwY3vGktzsyitBXXxHjA3uXT8TtpyYn3pINgFkjtgDaN7B2yhUR1q+bUE5E4V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Pure code shuffle, no behavior change.

Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
Without MGLRU the refs bits are never set, so they are inert.  Move the
lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
unifying the API for checking folio referenced and workingset status.

folio_migrate_lru_refs() now migrates the complete refs count,
including PG_workingset (bit 1 of the encoding), bitwise identical to
the direct copy dropped from folio_migrate_flags().

lru_set_refs_flags() skips the nonexistent mask bits when
LRU_REFS_WIDTH collapses to 0, keeping the generic helpers inert for
!CONFIG_LRU_GEN builds.

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------
 mm/migrate.c              |  2 --
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 74d1b7a04ca1..cfcbe4a9aa85 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -183,6 +183,12 @@ static inline int lru_get_gen_flags(unsigned long flags)
 	return gen;
 }
 
+static inline int folio_lru_gen(const struct folio *folio)
+{
+	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+}
+#endif
+
 /**
  * lru_set_refs_flags - Set the LRU referenced count to folio flags.
  * @flags: pointer to the folio flags
@@ -205,7 +211,8 @@ static inline void lru_set_refs_flags(unsigned long *flags, unsigned int refs)
 		*flags |= BIT(PG_referenced);
 	if (refs & BIT(1))
 		*flags |= BIT(PG_workingset);
-	*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
+	if (LRU_REFS_WIDTH)
+		*flags |= ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
 }
 
 /**
@@ -240,13 +247,31 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
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
 
-static inline int folio_lru_gen(const struct folio *folio)
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
 {
-	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
+	folio_set_lru_refs(new, folio_lru_refs(old));
 }
 
+#ifdef CONFIG_LRU_GEN
 static inline bool lru_gen_at_tail(struct lruvec *lruvec, int type, int gen)
 {
 	unsigned long min_seq = READ_ONCE(lruvec->lrugen.min_seq[type]);
@@ -401,20 +426,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 
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
@@ -441,16 +452,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
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
2.56.0



