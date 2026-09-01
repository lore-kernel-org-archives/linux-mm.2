Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07B7C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40506B0088; Tue,  1 Sep 2026 02:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17B36B0092; Tue,  1 Sep 2026 02:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D916B0096; Tue,  1 Sep 2026 02:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB6906B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:55:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A2B612012D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:55:06 +0000 (UTC)
X-FDA: 85164281412.01.0A1D627
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5ED4C20007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:55:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D8VzCyXQ;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245704;
	b=K/zbqoic9qnG+O9VnPPIyAcESI/U5Vj2ikAYZtdXVWg/P/sdmy4btKJtrJynu3lHRj2sXm
	QSu+BoyyP1JGwLZSZ3T5u7DLiWHWhEOYt41pv8eBQY3l1U0E5RKL9+HQbjamecFZVokK/Z
	gsnHtfBgMVDXLUeVxITnAS/0hXArLCE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D8VzCyXQ;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqK9HEQqgYxMaiv/dCQgnMMYaXllk6u0l0T8DENOTXk=;
	b=Q3Cmh8WcdzVQSmqhiO5ZVq9p5ygJLfXSixu1+u1S8HmIQ5qZ7nOhFrPzYTu78KbGw7E4qY
	7QFADrTVO5Nj7qaBcmulBKM50SAKC7MIoYNI6YKRzxY05g/BV1Ff+X04fCkFmJpMBB/xqz
	cA6CgkS6oPkMRxeaQ6H0bg++oTS5riE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BBBF1BD0;
	Mon, 31 Aug 2026 23:54:59 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F35E3F85F;
	Mon, 31 Aug 2026 23:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788245703; bh=azovFHyuoM3M1QIKlu9UrG4EHV9CqavEpXrZmiNGkU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8VzCyXQSX+7dZrHhOE9ruOuTTvVRHuCsBZT4IBYETdjEN5AUxk4hf97bBbfq44i6
	 c81fpEHWqkkoFgJebUuaxtqbXrlleRNOMTq1hHOKQny5lC8f4bZ212nNNJxmQ3vxR1
	 eNDWhuP0YWkeTVNMjzpIn/zyLe0t0bw6nrxVxvcg=
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
Subject: [PATCH 1/2] arm64/mm: Move __check_safe_pte_update()
Date: Tue,  1 Sep 2026 12:24:53 +0530
Message-ID: <20260901065454.1906343-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901065454.1906343-1-anshuman.khandual@arm.com>
References: <20260901065454.1906343-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: di5puu5nuonezxurfa68jmxcqd4sf9kq
X-Rspamd-Queue-Id: 5ED4C20007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788245704-404638
X-HE-Meta: U2FsdGVkX1/UEi2kkvnZU3iKRQfSvh9sNW86NGU80WKhNWuAnsX51pm3fMPNAYae1CpY1ymgB4hEgoziElJnpcd4m+rZM96bbqyCpO0uNpL2kb+jamQTh7tFKKiLqzcMfaZHdoWp3Gdt3xhyqnwyt8parDwDiQBNfaH2hz4qU4z6lFJddWPCAfHvg3mxHWeU+4VDGU7wKpl9s829V5FHm6jISufU6BSdJEi1x8DFIbl+rkk4zvzwp69932fWd2jeAxOYREbVEYvmlmQERwp0OTCqizqHWbMECzdJSz4qyXjVTLVl3Nt18sXn7KfCjNvcHUslpxHKEGNCTzTB3d0BiAc4Rl43AvXQXnUyiTG/W6iK4XI9CVQpkgS7SGFYqjcehKMTRhqOs5AiaGJKNvN7R2D6ltmZmSF9LwsAYr7pa6OnICvk0/MSjsgTJSbdPPBTh1SwBHpgPVFDFdlQpqIfBsHsTThAkHJuUhFwd5NUr0u0ZThMBcG6vXM0MvflYN/umfHz1nzGaOrYAvxNQ4cT3PpCnd6foFVbRnf0K0eLNtTkQdzZBt/sX8YnlzoRitL9hGnLUIt8f6Oszv8AXaDT8hmbYxeHHliw+rM0LZzXxX8eJoBoCWufZZ55Zaf3MPEUd6GsJuc3zFkvzBx47icrj6k6IGhXN/Xuh9aJUDt6RrUikIx6QjjspRFh9huiD18CRc+FUADHbJkhx1pq8gHXV1zBcadPuBC3XrnQ2DJ2N2G1mFd6qRM9TfB+bczuQOuDQ2yajjFswh0qZIXFGRpk8l6KonbjQP6h7WDjGKzMNsHwPRFeTnKxJ1pF8G/P+/vKFZx1yXN+CdOeIAuxZEykyFMNuEZDpYCkeclyISOiagY0DW/gBvMdHeXYoxC8Fm/XboBOKiOKDySVhTwBupCNuYMwYYugD8xpeTE1NIbPJR6YWKVUzo16Naxg5IAwM054OsHayQ5DnuLfq4IlLho
 vRyUws8m
 aSNkiSzFMsBslJ9PWzjssaEMdfwYE86zLuat5OOOy7kNtH7K92/W7LXCDNaQQlZv4828KfhUHvSSuGCGgiYaE0TsLtDuqceFV7GEqki0qPGMOv2jfC8w5H7jlSE/y+gqAvlYLQfP/PJjto5cTvzjrWTsm+ERMd0HGWGcBDtU3oaPMAcEnBpZkJ0UofEhgPUimTSsgyzBfVRrKg6uFizxltw666kVkuYCszUA9LbSCnH6PYeeRPMJwavaFl/MGw9xdGtIoNs5R0tOTXpZ1YxhJvgYaR4d2LbRRItefGilZNVdjZ9Zd+AZaYtdHTRZfl2Moi6N1McGOvB7tkKrxvM7usRe6FWmUOuqGkOk86todD2yEBVSYBa3wFaOW7eGb11tAM4zUAXMZjK6H2Mw+YE8gV2e//pd6arAzi90/14N9RYK02qs=
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
for subsequent usage of the afore mentioned generic MM helpers.

This does not cause any functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Should __check_safe_pte_update() be wrapped in #ifdef CONFIG_DEBUG_VM
along with dropping off current IS_ENABLED() test. That would ensure
the function never gets called when CONFIG_DEBUG_VM is disabled. That
will preserve current behaviour as the inline function gets dropped
when CONFIG_DEBUG_VM remains disabled.

 arch/arm64/include/asm/pgtable.h | 47 +-------------------------------
 arch/arm64/mm/mmu.c              | 45 ++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b..61fbfab3e06e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -387,52 +387,7 @@ static inline pte_t __ptep_get(pte_t *ptep)
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
-{
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
-}
+void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte);
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..e9c66d26bc0a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2392,4 +2392,49 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 
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
+void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
+{
+	pte_t old_pte;
+
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
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
 #endif
-- 
2.43.0


