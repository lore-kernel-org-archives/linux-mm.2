Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5D4C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF54C6B008C; Wed, 16 Sep 2026 00:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD9C6B0092; Wed, 16 Sep 2026 00:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E46F6B0093; Wed, 16 Sep 2026 00:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71E4C6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:49:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB683405EF
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:49:44 +0000 (UTC)
X-FDA: 85218397488.30.698542B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id E9694120009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:49:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gcpjFB6E;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789534183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RUOBa122ZNJj5/X0WINzcWwj/ntpZyO5WrRr2TxrBE=;
	b=M2oafDLpjrxB2NrclJ9cp9aSj1/0v1jANtRYg6Qg7Vn3SoOc3Jw1SW7UY2ZQwaRKMCufcO
	8/aBYfBq1N2+0Jhkn/B9Hm/2vnTJ/wZFfz8kD0gfRZiT/lzmjweWquz6M+245EEOolB05X
	Dzj+VxRamLFU6OszVCEvWo9yjLDprD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789534183;
	b=Z5kAMkOWSc5suuXWhbNV3lmcZQi6c0nIcQUbg6ebir0rMU0U/YH29yVB0qZ2w8RFCc41CV
	p3J96HcrX15KKu23R3ScxOM4cIAvEf0gqpPi+1gYe3gWvyfhA/pr9R2td/HYky49oskaXx
	V8UVk4tK+vg4b1tWiQNf0Box7NLJVzw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gcpjFB6E;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5423D152B;
	Tue, 15 Sep 2026 21:49:38 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33D933F86F;
	Tue, 15 Sep 2026 21:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789534181; bh=/pynzF0A3gZILFAu4wuFpsBCz7QyOd1/gAxCI9UIRGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcpjFB6EgLvQQVAFiWJc8GHNZZgIW6kwwYhOxBKre7nN2mtyeWpyRg+BCImi50PGh
	 HfHu0/cnEG81lfmENos4pw2ekoatxNvdJtd035uvXlaYXjm2xhWLAYVijOMiyv38ZT
	 RyFeLq/DuiBES1nv+O5LXQOwfxWnF+hNe4FK8FzU=
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
Subject: [PATCH V3 1/2] arm64/mm: Move __check_safe_pte_update()
Date: Wed, 16 Sep 2026 10:19:32 +0530
Message-ID: <20260916044933.2689426-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916044933.2689426-1-anshuman.khandual@arm.com>
References: <20260916044933.2689426-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9694120009
X-Stat-Signature: fh4nj9ttoo6uu7gp4xuscksi53nhwj1p
X-Rspam-User: 
X-HE-Tag: 1789534182-219036
X-HE-Meta: U2FsdGVkX1/dLIUXtQ338uyvVExNVeK7fXFfMGytQOmQRV2gAZrBpGiQ34xhTNKQFRUu2IOZR6hklBtUGofPRdotgEe6JVKenEKBweXkcVy7+Z6pUflp/xyb8I8jlRNTcQAI4dokTD7iGb4YaZgE+Y7knKWD8I0BDDNt6JP48Be9CvqFE9qUjCx5h4cV+/Y2qkMB101a+tmcYgVRrT+1LRl5LI9ENUezJhmISJHV+Ky9f+W/edKHWvciPzsVMmZLtX2zDuCWhQSgx8AREARkCzcyXSX2t8YiP6ePiqxYYRKfxBSP189ABF2AyzvDJyMxmTpgNSF6GxqqNa9uAzOiyldFi1Ll7RRJU6+kpuJ9neIqtFXGyp5KI5ambrYipozzEsyh1a6dDMKed+m45iOPhkzx/X604yhrjq33hE3UVkE2SbXAqDi9QHq+NXG9tC0zble597ERRqTNHWW+oCGitErq6aOZlNbcCGoXbWDvHB4Kh99A73DhuPdCHvksSgFjePGIz/KfuM1JAcfNAqR3rXjXzI3T2X1MJDDFtWytEkUD2xjSm1WLg5T2hK8r/QK3419CBCWwagoWRvQPHFOBHr9eRvlgtvAQ8nKpxz8l1DMbrY4ngemx2FVsdLZclpIuyhHLf+YGmcI4d6w2Wi3CDHjngP+z4vRC/vosstNxotgQ4Lvn0599sspqG5+szeqK9CLPzPGbRb0ltgkDBnRkzU0b05TgDyvvwir7JZuQrEUPpqr5Gvrhz/WZ0myMJ4oyzZQJvDHim77qyPdAS/SuEC3j0Ld3BalhwATx/4Xj9qmj2RU+KT2AZVMKyc4lF+PJCjoEtap0UtdXiAQCJs5N9OILEoVUO1mXuTHEtpL9PbHadJPwfRX+CuU59o2CLtXiiEBrNbsNURIVL+T0/vi8Lj+W+ChrJOcRm1r8s4+mslwX13S605fQUNiQcqKiyV9KMFvfZi5/vZUAY3bP+Fz
 Cy2mw0po
 x3zOVCvT3k6bi8uOYxApxSxbiHuuin1nIUelLO1Rvc+UBqSI1b5g7BSpaQxsKg2p2zHmLzX+n1+gFQz0gRAzcfyHwx0sb1Nscq3sbdwbm4kf/3EBAQdNy2N+olY3ZXmWbQCEdLLBltYYhhbbZ+lND4EjmW3M2tWg/cZMT1I2aNVMeGZ4J6crHsoxMb7qRJm98OsIx8n1mBPDYaZNnYauvhpJJTGPwTiitDG9qevaGFh6aampLCA+XsC/2Q1a+zykLbNQhBVAlFTE7CeRLcwXM4l6bdm3kaVtLlxPa0ZXZz7mePS8AHzgQIg+6eQjUebqdOI9dbyi2dptCV7W54HvQ5HWmX4mpoxV3t11WmTWIM60jhw+/R/yT8g2xySr4Muf3g8PQKbqXklqhFFHJJfNknxC/lIUVQkkWKjLU/Jb77Ni3oi4=
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
 arch/arm64/mm/mmu.c              | 44 ++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b..763c5a411d64 100644
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
+#endif /* CONFIG_DEBUG_VM */
 
 static inline void __sync_cache_and_tags(pte_t pte, unsigned int nr_pages)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5d..cb49469707a8 100644
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
+#endif /* CONFIG_DEBUG_VM */
 #endif
-- 
2.43.0


