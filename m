Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 087F1C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 04:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44046B0093; Wed,  9 Sep 2026 00:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AF56B0095; Wed,  9 Sep 2026 00:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31246B0096; Wed,  9 Sep 2026 00:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2EA6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:00:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1580C14081C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:00:17 +0000 (UTC)
X-FDA: 85192871274.15.92DB17F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22382140002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:00:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="BK1r/nZO";
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788926415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+a6rlb50aAxLqEMKIGitLoU0CpaDNBbutuIXiIUreBw=;
	b=wyoqfXZk1KML2eWgABxePt1vM9ztYE2SWgGq8LuIDwlOBoI80D6LGilqEYzgl2u/n25bjA
	I9cjPDyyA6Hj+rQOFCVsjQowt4bkF0W/VOeAHcUoDHmKOSXWw0S5Hry6jxKK5FcdUguXME
	OUrm9kb64zeAX5TwUzjWMaW4gpDFyfg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="BK1r/nZO";
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788926415;
	b=OlQO55yUXX76xlv9jF0E2swIGDLuij1CRb5CQPe2TosPx/DAc3kgcIW3q4cdiowr0ZV9/t
	rpmWAUIGpS3mFs7w318r3EQpbufbUttPeoLQ22KFEz7hSrth98OzIyN+JMavHdKMO0b8P1
	zJm7RZh9WnIWmhKjVeEINnbiR9kBvWA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39DEF1CDD;
	Tue,  8 Sep 2026 21:00:10 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2CA863F528;
	Tue,  8 Sep 2026 21:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788926413; bh=p1pm1d0/ykppLNUYpZykAVnZ9mf+hCneD8UXO1pbkTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK1r/nZOWumKhp01NvJaIOvAke6/uWN7AKuIc2lKbEKvgjJQ4E/iDqW0rzeM2ri22
	 SVz1SVyp3OdpFAZmK1r3EptEcXTuE/M4EhYZ/3OujVAzKSZczu9YQz3upKIndTR+UJ
	 +LQIu5yTabYFIydvi9zFkLedoS/VoWie77P8uerg=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 1/2] arm64/mm: Move __check_safe_pte_update()
Date: Wed,  9 Sep 2026 09:30:04 +0530
Message-ID: <20260909040005.4148136-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909040005.4148136-1-anshuman.khandual@arm.com>
References: <20260909040005.4148136-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 22382140002
X-Stat-Signature: mfcu71tnwqnne9wik5u8p3ye7zz5i3oq
X-Rspam-User: 
X-HE-Tag: 1788926414-115620
X-HE-Meta: U2FsdGVkX1+wkZ1RzTi50t7uOaHgRTj8toT/I7kUvnXsPLlKqsKTC+UHbU2efd5/MQll7qqSRIGv2aCUtiPUtvXhuV6vUdkpm9nxezUhmU0ao6wYrwFCkCmuEAaOz171qy3tTn4528uVzxZYM3TuenWZJWz2lQ8zw/ZiTCq3Eqb3X7b54hIEqzjjHOOZqGa2gVddQ7TdxdV9mI+Qzk7XKG/YAMOXEwPDSWCd9R/zoXVDywmBvBG3vcSWoNdJEMdx2Jx77ilHZUNL2EJtdiSXBTZzExFDMrId0FbDy07jOex68Dk1JUGAWiOxRevoV7U9XmiVBJPqXjiSScIzUFI8cllG/WBGIy7oh6u6Pq/f6bke5O+vapRLWK3DypYmURTf9MlHIkv3X4K3cdK3lDe4ilWoMrTSi7AZWbnowK+0oyEHM3VsURpt82+I5Fpdu9ANXV7r6yRDrfdaJ+LIu28cyieDPyOI69npaHHb8IhxXrf6HtfM32FciPSo/emMdPBi9al7/eHZRf1TOD0OqSatAjRVZbbQO8zUI6aR07aDS+qMh796Cu0e10rUr98PbT+tL9NnpB7eeldSN8qTM2vYgh33rjaUkW+jvH74QQbW7KxpP23IIKc5o5zLLY8OKiXhSWZ4NMzWe0I3I4xwCH/E3dhHZYN9dlRtzHiykYsfkWkHdM8vVJN77JhwfEj/R+xr8ZAS71Zz6liHYQu12tuOJAia9HPNbkBmj3KPff80eaUDVDLVCIPcxe3lgw2D8y/Sr1qIaz1xbq8xOA9BgKpeDwUya2tDFze27032Zpd1JY3GllHuCq5UtDN730xeMCDgkNLVDuUwhLXefHBRnvYqK/5HdCKK/HIEJFNXuYaDs/tKyUJotIrfjTJ2nxi1ahyglJBtBRTF6MGXjwAjcXeAtxWojRAlnPWboETXV0zRNHlaIAlKs9pDMR4fti/IX3X551mvzr/vPJa3ugsX9T3
 tIVVsgwa
 x5uG5IpsES7lnVDF72hffAYgXrXkdltz7lNI/AJKBaSrULo5kbr4KB4umLlac3JWqKkrz6VUNl5yP7qcDzSMLahXExacgYDonpMG6mvjErmloRrhDyWhFfCZVLA4M0KpwJTXfseWtxd8h8fT18LUwsHOc8uQ/iZIx+JV7Fj/Oye9EKVzMCajxe+ZKWfn22WQwU20Qv5FIUBUH6HcwkdOplSF2EDUb0Hv5VW7vjQ2nqt//A4kZi+PXiycqIEDHNPDwk5rKz99v64Ld0L/0VaLQD+qAwD+4dBFK4PFqYdhI9/huaDZ18EmqZqtmVCK2/nMCmr/UtLbgXnFBKGye+N/0HQL8770pLlCyG+2eE5QxuuQC6VZS4TvPUy2JLhyaHfnsEUDyMlVCynaG37JDE2RSqh1rMVy9AmBTIPcEHRg4EFl1fOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page table entry print helpers and related macros which are defined in
<linux/pgtable.h> will not be accessible in platform <asm/pgtable.h> which
is basically caused by cycling dependency.

Move __check_safe_pte_update() inside arch/arm64/mm/mmu.c as a preparation
for subsequent usage of the afore mentioned generic MM helpers. While here
drop IS_ENABLED(CONFIG_DEBUG_VM), although wrap __check_safe_pte_update()
inside #ifdef CONFIG_DEBUG_VM that preserves the current code optimization
which is achieved via the static inline functions.

This does not cause any functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V2:

- Moved __check_safe_pte_update() inside #ifdef CONFIG_DEBUG_VM
- Added empty stub for __check_safe_pte_update() when !CONFIG_DEBUG_VM
- Dropped IS_ENABLED(CONFIG_DEBUG_VM) from __check_safe_pte_update()

 arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
 arch/arm64/mm/mmu.c              | 44 ++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b..281a512f1fc6 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -387,52 +387,13 @@ static inline pte_t __ptep_get(pte_t *ptep)
 extern void __sync_icache_dcache(pte_t pteval);
 bool pgattr_change_is_safe(pteval_t old, pteval_t new);
 
-/*
- * PTE bits configuration in the presence of hardware Dirty Bit Management
- * (PTE_WRITE == PTE_DBM):
- *
- * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
- *   0      0      |   1           0          0
- *   0      1      |   1           1          0
- *   1      0      |   1           0          1
- *   1      1      |   0           1          x
- *
- * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
- * the page fault mechanism. Checking the dirty status of a pte becomes:
- *
- *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
- */
-
-static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
-					   pte_t pte)
+#ifdef CONFIG_DEBUG_VM
+void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
+#else
+static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
-	pte_t old_pte;
-
-	if (!IS_ENABLED(CONFIG_DEBUG_VM))
-		return;
-
-	old_pte = __ptep_get(ptep);
-
-	if (!pte_valid(old_pte) || !pte_valid(pte))
-		return;
-	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
-		return;
-
-	/*
-	 * Check for potential race with hardware updates of the pte
-	 * (__ptep_set_access_flags safely changes valid ptes without going
-	 * through an invalid entry).
-	 */
-	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
-	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
-	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
 }
+#endif
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..0b2d190d62c3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2392,4 +2392,48 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 
 	return 0;
 }
+
+/*
+ * PTE bits configuration in the presence of hardware Dirty Bit Management
+ * (PTE_WRITE == PTE_DBM):
+ *
+ * Dirty  Writable | PTE_RDONLY  PTE_WRITE  PTE_DIRTY (sw)
+ *   0      0      |   1           0          0
+ *   0      1      |   1           1          0
+ *   1      0      |   1           0          1
+ *   1      1      |   0           1          x
+ *
+ * When hardware DBM is not present, the software PTE_DIRTY bit is updated via
+ * the page fault mechanism. Checking the dirty status of a pte becomes:
+ *
+ *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
+ */
+#ifdef CONFIG_DEBUG_VM
+void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
+{
+	pte_t old_pte;
+
+	old_pte = __ptep_get(ptep);
+
+	if (!pte_valid(old_pte) || !pte_valid(pte))
+		return;
+	if (mm != current->active_mm && atomic_read(&mm->mm_users) <= 1)
+		return;
+
+	/*
+	 * Check for potential race with hardware updates of the pte
+	 * (__ptep_set_access_flags safely changes valid ptes without going
+	 * through an invalid entry).
+	 */
+	VM_WARN_ONCE(!pte_young(pte),
+		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
+		     __func__, pte_val(old_pte), pte_val(pte));
+	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
+		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
+		     __func__, pte_val(old_pte), pte_val(pte));
+	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
+		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
+		     __func__, pte_val(old_pte), pte_val(pte));
+}
+#endif
 #endif
-- 
2.43.0


