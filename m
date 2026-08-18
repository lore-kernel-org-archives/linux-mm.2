Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32490C5DF85
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E1D6B0199; Tue, 18 Aug 2026 09:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EA66B019A; Tue, 18 Aug 2026 09:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6616B019B; Tue, 18 Aug 2026 09:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 796C46B0199
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B3E3160110
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:18 +0000 (UTC)
X-FDA: 85114428756.30.D691A80
Received: from mta1.migadu.com (out-145.mta1.migadu.com [95.215.58.145])
	by imf01.hostedemail.com (Postfix) with ESMTP id 13FC640003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=euJIxsHV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/afzYIQ1idbepgMzCZluw1hZdgpbQH0G9iWXIy9+Es=;
	b=4jS2YWKFGXbRDgg5v6JLTKuRiFeg03zJk8tk/56xtyoVraCJz/iieGCIGv6VOAcVpeRrTR
	0lvAe5sZvdAfKvA73V+IV+y2glrhUhCwyHkhiCjKoHHP+1MHauH8XCATY4VAwXwotnhxP0
	ZPQTYp13Zeqh3LidR9qQiUReEqRyjTk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=euJIxsHV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.145 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058736;
	b=7XN2q3JVQLbEWiasTsvCDGI4dHxQekGf/KsojiD2gpQMgh/jbsdljSZxILMHPE8PMpZ6H9
	QRFHCwI885ltrHKM3Jt+Z1+GmhoWsfW42judx/WIlGvi0VOjtKsrhw8x1S7oj8oYCDckiU
	0wFkbfAQ2MvcogBEmN6hM9PWZmJdky8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Zq+Ctczt2l05WWIcApO8BE7BxqptNyjFszeHYSoNb5Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058734; v=1; x=1787663534;
 b=euJIxsHVul8bRimE6+4nWu8fcxcXYKZMepyukjoBHaygAiw0945awiAEU7FddXuwkwG8+jwR
 CSRMK9ejFUwbGA3AaMlaOxOCYVKz0xgXyjM2Kh4sNcHoBWQE5pHM1Pa3cyjFDlTiPL8h4ewfQ6x
 cz1Y1KQ3a2IM5Bg4JpcqeQA8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:42::)
	by mta10.migadu.com with ESMTPS id 2117379505cae7b9;
	Tue, 18 Aug 2026 13:12:14 +0000
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 02/12] mm: add PMD swap entry detection support
Date: Tue, 18 Aug 2026 06:09:43 -0700
Message-ID: <20260818131202.494754-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 13FC640003
X-Rspamd-Server: rspam07
X-Stat-Signature: uuek5m8pns9qwpkrbyxkkwhrwhkefkef
X-HE-Tag: 1787058735-230407
X-HE-Meta: U2FsdGVkX18cFpIYw9c7PD8LSw5G3iF6OMubb4MpuiLc3kBuhUJ+NkHkVZXXZEb7RQh1IHE4FZ/529wXsMqPPHo7G9Pue7OXDTfPnHxfizU2TfZtZMqMmYw0k/+TZ/Gl401OvaXFoNRkhA2rOdQkSiSXBqQXlUFVbcExv/zaw0jn76u6YTJy3dp6ktxHA+UtdRuaxTVxDA/tynnFc6/vTzjSRF+DlakgeXzglCwcNyFXWT1VrU+hxPs47M9sBfD5C3+LyVA58qZF23P7zKaECBs2MdXuJDbLpnNM5Kwz81sQfqq4dzDjXXfggxh6bloF4h0s+8FjsMQeV102vUv2ZxcpDBA7DB4YuGkx2RMhjalmyuHsP1Ib9x/RFYAWpdA0KR7CSFFy1Z09i2Lqz5wtnu7ddl6nrFwfyXtYMQCbLZ9t0uVqfvj21o1dEc8QjoOZlxhfs1HgEbkNCerbZ7OY0pGf9AatBqhICVcaFyCkb7ODvZ0zAVEI8wodtVhQRUKYXdEM0MksEHlclM+cWLvQ9baACF/dGha93OwnShS8ZMKRW3LqoMZI4UdfWU9uz//a0DTTGdofzCNunX+YmVah+Uh5w2Bbf4P09l9cKJw2JQcq40KZPIb9Jwx08AQzhKEZ8Zw+yLSufgJu4OSSjGQqTcp3+7+YJZ50s5iRhzC6IaMKSzx8s4qCqaVi+ipvJ669JR+3pOZ0yHzQnlE/dAywLQ+AnLe8+8HZeY0fXPW9Gn1w+3mx8dmIlBCJzEEEfcuFuE6SSSKiuyydcecXGMAmbFCsxA9JqPfJky+t/Qwhqtg9503m5JVImpKqi7fMHGcavlDM0s+G7hrolrKvJh0od3ND7xKQFwdAcbf+Qv0/jEoSWUlfI3rnqk8MOuhAvFYtxQxGr6pc3uGBxDb4WWp5auLnt45gXQErHwWiWZYoDoVmUnmiFsWuPuyTgrAiqIbU3W1+NDfQEJheTy9NS5U
 auVRgu7w
 +hA2o3lH+y8AUdopW3PB872U7wz0PgXnQlifB76Tcf1upPhGYNEoj94rDnu3igGNmt4iawtUSxZdLxwkg2mu5HQ61slIHJt6tipCb39uVka9IZ46+7Z/R+mamFJ7mz/PUZuMiKR5IJ3u0T43SUv5NQsPshZZIscRvTuxmibSWp5dr9nCU8xdr0U1ZoHsS/zdF09XkqNFPJwlaEfvReIFPrg0n/qvajiOyJH7UJnlQDiolmztIaDGmoE2w6uWxL4vuUFDE0H0u2zFD5MutYWELOvrUjyFlfZlygUMdBbyLDcd3Qw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently when a PMD-mapped THP is swapped out, the PMD is always
split into HPAGE_PMD_NR PTE-level swap entries. To preserve huge
page information across swap cycles, later patches will install a
single PMD-level swap entry instead. Add the infrastructure to detect
those entries.

Teach the softleaf layer to recognise PMD swap entries:
pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry()
accepts them as a valid non-present type. Because swap entries do not
encode a PFN, make pmd_softleaf_to_folio() warn and return NULL for them
instead of passing the swap offset to softleaf_to_folio(). Clear the
exclusive overlay bit in softleaf_from_pmd() before decoding, matching
how soft_dirty and uffd bits are already stripped.

Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and
pmd_swp_clear_exclusive() helpers to each architecture that supports
PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc),
mirroring the existing PTE swap exclusive helpers in each arch's
pgtable.h. Provide generic no-op PMD swap exclusive fallbacks for
architectures without PMD softleaf support, matching the generic PMD
swap soft-dirty fallbacks.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h             |  6 +++++
 arch/loongarch/include/asm/pgtable.h         | 19 ++++++++++++++
 arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++
 arch/riscv/include/asm/pgtable.h             | 15 +++++++++++
 arch/s390/include/asm/pgtable.h              | 17 +++++++++++++
 arch/x86/include/asm/pgtable.h               | 17 +++++++++++++
 include/linux/leafops.h                      | 26 ++++++++++++++++----
 include/linux/pgtable.h                      | 17 +++++++++++++
 8 files changed, 129 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a2681d7553584..860f95573d1fb 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -598,6 +598,12 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_swp_clear_uffd(pmd) \
 				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_clear_exclusive(pmd) \
+				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
+#endif
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 1952e34bc8ee0..aa8e1223d3973 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -357,6 +357,25 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	pmd_val(pmd) |= _PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+#endif
+
 #define pte_none(pte)		(!(pte_val(pte) & ~_PAGE_GLOBAL))
 #define pte_present(pte)	(pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 #define pte_no_exec(pte)	(pte_val(pte) & _PAGE_NO_EXEC)
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index f4db7d7fbd5c6..6a899d0793b3b 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -699,6 +699,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
+}
+#endif
+
 static inline bool check_pte_access(unsigned long access, unsigned long ptev)
 {
 	/*
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 1225cf05696a2..65b4181c62d9a 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1213,6 +1213,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pte_swp_exclusive(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
+}
+
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
 #endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e882663a58e77..490e4a3464b19 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -870,6 +870,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return clear_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return set_pmd_bit(pmd, __pgprot(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return clear_pmd_bit(pmd, __pgprot(_PAGE_SWP_EXCLUSIVE));
+}
+#endif
+
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_SOFT_DIRTY;
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8e0018fadd14e..b5da5447e83d0 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1525,6 +1525,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline int pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 7c13c58a5e218..4a6c52974b305 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 	if (pmd_swp_uffd(pmd))
 		pmd = pmd_swp_clear_uffd(pmd);
+	if (pmd_swp_exclusive(pmd))
+		pmd = pmd_swp_clear_exclusive(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 
 	/* Temporary until swp_entry_t eliminated. */
@@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
  */
 static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
 {
-	/* Only device private, migration entries valid for PMD. */
+	/* Device private, migration, and swap entries valid for PMD. */
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
@@ -673,6 +687,8 @@ static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 		VM_WARN_ON_ONCE(true);
 		return NULL;
 	}
+	if (WARN_ON_ONCE(!softleaf_has_pfn(entry)))
+		return NULL;
 	return softleaf_to_folio(entry);
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a8..e10a7e91e4260 100644
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


