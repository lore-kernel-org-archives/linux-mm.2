Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0122E606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kEkEa4e0
Received: by kanga.kvack.org (Postfix)
	id C11096B05C0; Thu,  5 Nov 2026 13:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CC36B05C1; Thu,  5 Nov 2026 13:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88A16B05C2; Thu,  5 Nov 2026 13:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA6E6B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE9A8140B9F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:54 +0000 (UTC)
X-FDA: 85401932028.26.816714D
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf29.hostedemail.com (Postfix) with ESMTP id 934A112000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kEkEa4e0;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRke9NofnhxA5cWbmrI5yg/rv7Nj7oxJrxp6jL0TGAs=;
	b=tRzRNbC7/HnqEtto8KnEnWNOdFXrMuCZfKiy7DZfpSj+Al69/I5sgFWifzoFJmPPCyQ+3K
	V6fj/d9DcV8f1zDHRD80IANgwnBhECjVrqIvDhEU3bTv4QgPtDAT5yjVYj5syeOiwoT8Tc
	wFXUQhE+JA5thrQF+ohM3jx7x7LBsPs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kEkEa4e0;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904052;
	b=rRLfPsl0kOaVt+RevYxUFHkS51+jyM5raqAvfbfd/Ey+Ekf1VS+EVFYQe/b3Yt9auGCoVx
	xYauWgVSx8Twt9ktSUrljdqAZrQCKUyC/hGmmOsUMIL9Bi09OfY9ZG4vHvYIDB1Xelcuuw
	1q0KO8iebmC4ybFEQNWKI1hCRqk4n6s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yqbRrj0HaVb260zeFB00lA2k9XcFopb5uVZAXfw5cDE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904051; v=1; x=1794508851;
 b=kEkEa4e0TJzyUbWGYi8NB8qbuIWhtdcSBs3Oa9p0cjHGocGK5bOAb/92aQuDwYsqCKUlSMlb
 x4dLB1/+y/vpu+819EN4qzbMmtK8QPIfD5Dc1+cNzDSArzdPLoOVvGnGCeUSjeeA5yG2huyMCcX
 s3DrfgBOQS7kfDDssysRAn9g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 607661fc4bafeccc;
	Thu, 05 Nov 2026 18:40:51 +0000
X-Mizu-Trace-ID: 607661fc4bafeccc
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 08/32] mm: recognize PMD swap entries in the softleaf layer
Date: Thu,  5 Nov 2026 10:38:52 -0800
Message-ID: <20261105183940.2236717-9-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xwqnmfotf1fgwwh3y5nx5stgo6izwipp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 934A112000C
X-HE-Tag: 1793904052-451767
X-HE-Meta: U2FsdGVkX18m0vEYnfuEOCDZkSCwR+oMD/eyfJs5jRDJQiBAsvt6rwhqgEr0ixdQ1ipvpZwhnJbWMdmzH2GEgeoAMetRfPFKXsRHM1Zzcjy3qVG10961+jOQkdJQkh6RgQTgiN7a692QaUQSF8WmvXACuT/DfVdTt/Y09S0Saj5rn+CbsG8oV+h1Pc+63TK9En6WQlcwSoAmCuFiZiQFZxnVATizPIE5gUo/4VgA8XBZrWh/fih7LZFByU3JX3uV5lj/VKiGHi/GLW6vD8t+hLbyPwsGYfuBpzMCo/7wUEYZJZgQZMiQHIhhmwSsL31qJnX9+r/V4fHItJIsCqGKRmQebfCTRspUhwiu73zmZV58JTapoDj4F6EXuvoCQNhsXZqFv4ls8OUSxXHuKhFARaMGgXI1p4LTv+HP5mei9vBI8PhACzZ8665K95atoHES6BHlWdho1fpx5TexOdDBANG9EyTEmwzKRoFTgSRVDkrHGeQ/osHNujgOxtsOQYPEJTb+YYqgmch0uBft8oKJFwxmN2evniE6kBsgPdpAB1bSe+xsJmDLJq0LHFi1S1OnQupXe7rw/ZpgSxDR/6/OPG+MEVhWtqWZgKho1XFVgR/DP1TwVHCWhsFD72OftJdaEXDsjCuFMeD0kljoUgUN3c5W9Y1sUX4x9NdPzjz3zG3OB4gE4VHUng3NJcvLPosp4lgVI/aO+UPWNC1PNbdteb/LThVQQFqdN9GN0BAxnaL5sh2BQYt5gD7dg4rAiPIkMLOSruh0vz8Ta50uuhMHKo2uNfoxMZY3TdcMwXLVo2SAqPHm21xmhAyrhXIhbSKJOXe3aM7llEPbs7Ytuk+ccQIKXAOpdFJukU5qQSmaprVY525hS0DEHf3RiBhoswzzULm6E7GDTtB6s/nlAZutCQyc/ysgsB09mHBPtMatbi2qO0c/piLnjvvatsg5EThqzJEKTBFqsojsBll/YLV
 c5JPjLyD
 BMLY5Wf5UpYSzSm7p5URXj38C0TaIgegdd6N8is3S7FDRfivWr6WEdrgs6hKBdD8qnxTXMNt5ygQrDB+neDzNjz6QuHw3jNQdMwk2Mf6BH7GLNS3T5RXVyPBnvEVIpF/L6sDmGVT44wezNsoTw2Ymg0LPv2f47o706k/AB8WHL8CUXciWxaKv7lLFTMC8qIWD1DTYMkfrCXkNmLDU6oLvpI1xE4UOU90B7yCzMorhHG7Uy8fkTkVhRWH+LxZzXiuZuUXo5iUntBOdKBc9E2AH3Bjd9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
before unmapping it, so an ordinary swap entry has never had to appear in a
PMD. Prepare for installing one there instead: the softleaf layer is where
every consumer decodes non-present PMDs.

Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
return NULL rather than interpret a swap offset as a page frame number.

Unlike migration and device-private entries, a PMD swap entry can also
carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
before decoding. Strip all three overlays unconditionally while we are
here: each clear is a plain bit clear, so testing first only buys a branch.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/leafops.h | 38 ++++++++++++++++++++++++++------------
 include/linux/pgtable.h | 17 +++++++++++++++++
 include/linux/swapops.h | 10 ++++++++++
 3 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 7c13c58a5e218..2871dabcf667d 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -98,10 +98,7 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 	if (pmd_present(pmd) || pmd_none(pmd))
 		return softleaf_mk_none();
 
-	if (pmd_swp_soft_dirty(pmd))
-		pmd = pmd_swp_clear_soft_dirty(pmd);
-	if (pmd_swp_uffd(pmd))
-		pmd = pmd_swp_clear_uffd(pmd);
+	pmd = pmd_swp_clear_flags(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 
 	/* Temporary until swp_entry_t eliminated. */
@@ -634,18 +631,29 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
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
@@ -660,10 +668,12 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
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
@@ -673,6 +683,10 @@ static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
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
index 780fe849ff8b7..70a302e6768e0 100644
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
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 603f9e3f909cd..1742074d60100 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -79,6 +79,16 @@ static inline pte_t pte_swp_clear_flags(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_clear_flags(pmd_t pmd)
+{
+	pmd = pmd_swp_clear_soft_dirty(pmd);
+	pmd = pmd_swp_clear_uffd(pmd);
+	pmd = pmd_swp_clear_exclusive(pmd);
+	return pmd;
+}
+#endif
+
 /*
  * Store a type+offset into a swp_entry_t in an arch-independent format
  */
-- 
2.53.0-Meta


