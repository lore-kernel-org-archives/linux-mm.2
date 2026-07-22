Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BD8C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D280E6B00B4; Wed, 22 Jul 2026 11:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFD06B00B6; Wed, 22 Jul 2026 11:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16636B00B7; Wed, 22 Jul 2026 11:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 905BC6B00B4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:21:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DF5E140201
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:05 +0000 (UTC)
X-FDA: 85016775690.19.A58AA72
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B54220009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vX9ZWHby;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXeSIWtkM/kfdDv3rv9KmOo8d2B0SJHeaQyRm6ZxnXo=;
	b=gDppSWVyxCVAmftdzcVkRcSZjKyfjFxGb2AGWHKdGPLZuFgwnMr5WpHl8mHDKZKJmnwg7v
	ah45W95rEMgoRNU5U00/dsyhrcazqh8oTwq9Kgi1zfJQPl53giO8l8F4OS42EUXWz4vGQA
	QqoTOURm0Kr5j7jdN+EG76/jJbRlHxo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vX9ZWHby;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733663;
	b=ITBbiey5SxBTraLBKsepYvSowEgCRBjo1NrFW8KREhHoLxlp8x6VGglSub0kWEr9FNqg/i
	w9istoCfWqzSDn9QHBvbzaC+GSrLGaDVLuLNmXltw688OTAtLfPSpI1JaPX3hit2z8kmQR
	pKUDAn/aR80wnAEG3ls8fXnqA7DAuZg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OXeSIWtkM/kfdDv3rv9KmOo8d2B0SJHeaQyRm6ZxnXo=;
	b=vX9ZWHbyb1mpc03XhXxL4NDWlAxJgqQPsEoz2zMHu9nKCwEP/XguIwrHEwommUeVzNunZB
	o2OlO8wxZH55p6lmS3EMTTeFgitBKsvjVEsjlbGAdgkS3ryXRi/T7dpxMvfcV46MntwNV6
	iSql8VFpAo27dTShwVEzL92uUQ99rO0=
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
Subject: [PATCH v5 01/11] mm: add PMD swap entry detection support
Date: Wed, 22 Jul 2026 08:19:32 -0700
Message-ID: <20260722152043.2273289-2-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B54220009
X-Stat-Signature: abhr5w7s1pniebfhe7bthdx36fa38a1g
X-HE-Tag: 1784733663-267237
X-HE-Meta: U2FsdGVkX1+VFwJ2MeR2mUvA0LPKrTbrXzLEJGQh1pr1rr8A8/2A47xpDk/ccJViT6m8yguOF0vogjjNk8JWOM9zXJKQSrK6B1NhzZqEia6OdK3UtqIjTZOloTTNcqW7vliCzzuartP4j8yOlwLVNWEKxwoCCtNx0itjVlXyQVIqFBIzhyS8/f84fZiKwhtDre/a3SXRV/yw+ge2jZr/hUOQSEnFt0k3+ewPMhks5BEUWupbj9PbBnkN9O4Ezk0A+OLPJ/P6dQnKS094tTndH9bD6LOSldqf/E17zChMLSEXaPpkajYu3y/kWErWFXFKQWTAnQga6fV11kIIBLiJQR3O2EsjWdmnK+xEE1/IKccCsKUCQ++phD5FdqTVyotcq4Ca1vOIZsHvr4ZwwLmBcRHWr+H+9j9V40jSs7cYSbTUhAzqSVUtaZNJwnnV60YgBfVCJw1Xrd6MenIFvW2ssOLmFIs5fqWBa+0AM8E5Kg8JPPBAoh6EaiaHfowdXkL/QVIiA67wo6rf7H8NAPWPnRbNAd0ASPX9vt0M0izcOaXLH5CAKnp7Jh2UzisAc7w3YqZu3HTshG9WAk/IWLlKmot8qjh0vu9niGv2so8h+xTRaYXPphJx1NTIF1g3RR1CgQCvZtBJwzmwUtkkms8CPGHcSAdtED0utkTmXsZcjS+Sj2LQ8zC3HFWkDNZ/14ZTOXT/Fi4yYMxLGyuQ0jG6YA8z0EheJfbiWENhcWBDDfN19dg/vm+LxbojdVj1iIwNQspmy0XpisMi8i/NZVcLgq7s500LqmXck/rbpttqadwNM5dHOa66FYvIKyMlJGs4O/8qPZYg2h4bGeFMgVJDXvqvdtwE40onSuGCW3dA/t6tWh/vWblkXRNIjf5O/5wiY749KjaeuwsJcHfE6uAkAh8ep37goFpl+vzGERdXa7KgMVJcAkODXKGZOnBd+b9CoEEcAdiIprNH2vM0n1O
 HJmMhWiM
 a7zKsnKBbgAEx351UWOGe+RIsDb6a0LKbZTynjkcTEC6MC16Zukc/ahynDGoNUkDTX15CEW0ZKhGZv0WtQ3dQMApLXuclV3wcZLEABY2ks7ellCmER3RaarNFl6vgAPGW/H0u0DhMIBXf7n9YiQI3qKglBpx3iakc4BN0IGtg4hpQXXNMpHAsn/LLduehTnXpr2MPUmkij5Ssxb6kYNF5dlPYYgKXXdYcw3YN
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
accepts them as a valid non-present type. Because swap entries do
not encode a PFN, make pmd_to_softleaf_folio() return NULL for them
instead of passing the swap offset to softleaf_to_folio(). Clear
the exclusive overlay bit in softleaf_from_pmd() before decoding,
matching how soft_dirty and uffd bits are already stripped.

Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and
pmd_swp_clear_exclusive() helpers to each architecture that supports
PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc),
mirroring the existing PTE swap exclusive helpers in each arch's
pgtable.h.  Provide generic no-op PMD swap exclusive fallbacks for
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
index a2681d755358..860f95573d1f 100644
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
index 1952e34bc8ee..aa8e1223d397 100644
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
index f4db7d7fbd5c..6a899d0793b3 100644
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
index 7f21742b2b6a..5f53b158a95c 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1206,6 +1206,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
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
index e882663a58e7..490e4a3464b1 100644
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
index 8e0018fadd14..b5da5447e83d 100644
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
index 4c1476ae3234..8397193ba399 100644
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
@@ -673,6 +687,8 @@ static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
 		VM_WARN_ON_ONCE(true);
 		return NULL;
 	}
+	if (!softleaf_has_pfn(entry))
+		return NULL;
 	return softleaf_to_folio(entry);
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..e10a7e91e426 100644
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


