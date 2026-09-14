Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEE4C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E8A76B00A3; Mon, 14 Sep 2026 07:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699E26B00A4; Mon, 14 Sep 2026 07:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563336B00A5; Mon, 14 Sep 2026 07:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 201726B00A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:44:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A88D9A035C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:08 +0000 (UTC)
X-FDA: 85212184176.29.4721CF3
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	by imf01.hostedemail.com (Postfix) with ESMTP id BB33E40009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbYpd23A;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTvWoIy2DhT7OiAQacP6glx1Nqi6P+EO8bbCbeQM85E=;
	b=Px0p7UnlGNh4Ax81K5Xun+VyCtJJzC9LGS+1i5RngKgMyNO3djwNaG5l1znFMiNzZQI1Ie
	H2GA93RHHEGxeFtFzB1UGjrIVogBFGYuB+h8HTnAj8GvsRmuhmjp793sKmDs8ml9jbJLdQ
	DXBdAy/yGMeM9qFbBC6uxadx0TSIED4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbYpd23A;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386247;
	b=i1GC+K+De3/s31ah2FhHoTAE23Ui8P+F3i3/+B6kPSMw64JmrQcwmof6ctNYdzDgYVVDNg
	dCR8WZjTt6nP3W3LjA3tTx7WUEnZinuCC4IhGHmi6LbcKb/7eUpof7iD37YeHqDhNJEufT
	doDFD63673WtvJt3LEAbKehSnWhPPDk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GA4gtvHV/+JkGd0QoK3boOJtdQKcFFleMRDfJWwQDhk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386245; v=1; x=1789991045;
 b=sbYpd23AJ10EIinCmE1j6N7OToX0BrigvCU2D4vaA2swUzJel3SE6Syrf7vh6fQSiznE7Uwf
 VKeiMkbJFumu10vWgN6asowc45BthXc8DAeM0N/apKRerDENUtOCnfimplvsNkAiyreeq9/KeuX
 Xsc6MlUmFcYoFAie3xtICwl0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 22fdb36f8cd0ef39;
	Mon, 14 Sep 2026 11:44:05 +0000
X-Mizu-Trace-ID: 22fdb36f8cd0ef39
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 08/29] mm: recognize PMD swap entries in the softleaf layer
Date: Mon, 14 Sep 2026 04:42:00 -0700
Message-ID: <20260914114320.12988-9-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BB33E40009
X-Stat-Signature: iuqoonki9oopbgruqdcijspjzds7pjky
X-Rspam-User: 
X-HE-Tag: 1789386246-209379
X-HE-Meta: U2FsdGVkX18Xs/MWWtkX6MBq538JvhYXLiu2gI9mMZ8pPKXkKJnxub5ttnt+EDgXvjDbcCIIgTyTuPDZfdY2ZK+dLKpH4vsG9m7fp3xphMANl/mfuf79QyfeSdJPzGmVe+/0o9JKtwDicwmqF8uq25fQgFdjChua1lLY5VukiBXe/1Q37HTiuYJL5VDattwgHMjQqtSzSovoGdb+yqVIjDFRGohZDQlgANM+PFTwfAmCFsCCS9gmUSk5BnJhmls6/LEqjXs7QN5fCJMZ0CoKSsKfiY95l6d9P6O5WiSjvmkTiJCdabnaz5SUZUlIT2lHfV19SFvjHvDQDvIjjU43Wj4qPe+NwC8SPKI7PAQy6mu3UNIZj6mvwmZFqK1udSKmpfR9eEXXavSzGObx3pwzfA+18KxKZuyVPqi8wVgm7QA86XFAeKIgP7a53TwfyZjw2MGUFayXbREgzwODM0OIzcl1mVYiHPH32nY765OD/quKrMOeRTSp7hdP6xvSJNcjQ82JzVkcdVi2hXOu1DhqNqRL0Z+JZ8pZC99M5e2LYa9tf/PxZbus4spAoGvAqIhgh/cQAZUb4dcdQy37BwemlyQIWK0K5Av84ViWTBbbo0ZDeqESJ2O/U8BQvrRK6Qrke0mbsu2/dDf1vMNZgBEgjXUB1V5YxVesTdrvfid1DP6IkczrUeRrABwwQBfnjzBmpWaQRch4I7f5BovWqDgbm5LqVpjhSGQ3HJ/H2stUsn0pEJqe0TFrPxU5Q527OxJK+o4B9tFkQ4zgrIIQayOllkGRlGvIQ2pt8jzs9PuD+uJBqUo5WtiMBUJuGLlndD2j2hw6Yw0KhTRre6T8DvR5Cgj8bWTbY3Y/aPoOft09opwkndwFYgVPfH5EJNPS921gsjk4K0QLeehBOwxpmV9UfAS6EPOpTwjzmCkVdaGqyUfQggnCKUVPfqkgBpcQa7LcHp32Y+rwrFy38zc96M2
 6G0qhmda
 f8lNvddvGzbJgf9x63nQlIesh7Vda0byIm8GylQVff/wjrQExa8mwRmYgYBM/5PgGcGh+cYRJMC7jvxWqnyCrt5IX5/careo0pOHAH6clCE8scUtCa39GT6N/b02F3UJC1Bm/MAyyV6KCr4Co/vQ1oqbqOSpUaD399WSZibJiqkttoganxCGsohJMYC+lYExXLnlESM4GwD4lVlfjE2yhNIZTwrj73vyoER6jeIaAMtAisGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
before unmapping it, so an ordinary swap entry has never had to appear in a
PMD. Later patches install one there instead, and the softleaf layer is
where every consumer decodes non-present PMDs.

Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
return NULL rather than interpret a swap offset as a page frame number.

Unlike migration and device-private entries, a PMD swap entry can also
carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
before decoding. Strip all three overlays unconditionally while we are
here: each clear is a plain bit clear, so testing first only buys a branch.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/leafops.h | 40 ++++++++++++++++++++++++++++------------
 include/linux/pgtable.h | 17 +++++++++++++++++
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 7c13c58a5e218..ce176c78cefd4 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -98,10 +98,9 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 	if (pmd_present(pmd) || pmd_none(pmd))
 		return softleaf_mk_none();
 
-	if (pmd_swp_soft_dirty(pmd))
-		pmd = pmd_swp_clear_soft_dirty(pmd);
-	if (pmd_swp_uffd(pmd))
-		pmd = pmd_swp_clear_uffd(pmd);
+	pmd = pmd_swp_clear_soft_dirty(pmd);
+	pmd = pmd_swp_clear_uffd(pmd);
+	pmd = pmd_swp_clear_exclusive(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 
 	/* Temporary until swp_entry_t eliminated. */
@@ -634,18 +633,29 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
  */
 static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
 {
-	/* Only device private, migration entries valid for PMD. */
 	return softleaf_is_device_private(entry) ||
-		softleaf_is_migration(entry);
+		softleaf_is_migration(entry) ||
+		softleaf_is_swap(entry);
+}
+
+/**
+ * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
+ * @pmd: PMD entry.
+ *
+ * Returns: true if the PMD encodes a swap entry, otherwise false.
+ */
+static inline bool pmd_is_swap_entry(pmd_t pmd)
+{
+	return softleaf_is_swap(softleaf_from_pmd(pmd));
 }
 
 /**
  * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
  * @pmd: PMD entry.
  *
- * PMD leaf entries are valid only if they are device private or migration
- * entries. This function asserts that a PMD leaf entry is valid in this
- * respect.
+ * PMD leaf entries are valid only if they are device private, migration,
+ * or swap entries. This function asserts that a PMD leaf entry is valid
+ * in this respect.
  *
  * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
  */
@@ -660,10 +670,12 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
  * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
  * @pmd: PMD entry.
  *
- * The PMD entry is expected to be a valid PMD softleaf entry.
+ * The PMD entry is expected to be a valid PMD softleaf entry that references a
+ * PFN, that is a migration or device private entry. A PMD swap entry is a valid
+ * softleaf entry but encodes swap slots rather than a PFN, so it has no folio.
  *
- * Returns: the folio the softleaf entry references if this is a valid softleaf
- * entry, otherwise NULL.
+ * Returns: the folio the softleaf entry references, or NULL if the entry is not
+ * a valid PMD softleaf entry or does not reference a PFN.
  */
 static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 {
@@ -673,6 +685,10 @@ static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 		VM_WARN_ON_ONCE(true);
 		return NULL;
 	}
+	if (!softleaf_has_pfn(entry)) {
+		VM_WARN_ON_ONCE(true);
+		return NULL;
+	}
 	return softleaf_to_folio(entry);
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c5..3f955f836abfe 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1917,6 +1917,23 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return false;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
  * Interfaces that can be used by architecture code to keep track of
-- 
2.53.0-Meta


