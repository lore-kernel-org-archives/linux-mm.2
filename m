Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23247CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC24890021C; Fri, 15 Aug 2025 04:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73058E0002; Fri, 15 Aug 2025 04:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB26490021C; Fri, 15 Aug 2025 04:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 917EE8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5045983A1F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:17 +0000 (UTC)
X-FDA: 83778385194.17.A7BB75F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B6E538000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eDMLq40IQIK4A1/29IQR2+cU8CquAMdkzYmfVx5fV9A=;
	b=jPxR4erivQBWgLRMQYBZ428Q2dBxNKbIb2HiNRjvJ5vU8TrhI30P6sakUUhiET3rMpfqF/
	teM6qDKBFTkr3wIes39JZngmqZp3x0SVApAWTaJGk9rwVUd4//lYiV8/n/Qs2RCb/t3GzO
	0LtEaGOSG7jU/j8bwjnYt213hFFOWs0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248175; a=rsa-sha256;
	cv=none;
	b=w934//uYloEAfloMKrkY8rm6wwWCc274kAqiEMFndZUb6ryK9BVdNoQaY39KyVDTTtKDTE
	iixZ5FmHWEENsHMAPs+Z541Ow6/OmNvBrco59msg9gyjoH2Gdj45Ah1oynVjnszeko3zXC
	rjN8sV8wwRJllggJW3dykC8VgHrQXsA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C99AA1688;
	Fri, 15 Aug 2025 01:56:06 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6ED623F63F;
	Fri, 15 Aug 2025 01:56:10 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 10/18] mm: Introduce kernel_pgtables_set_pkey()
Date: Fri, 15 Aug 2025 09:55:04 +0100
Message-ID: <20250815085512.2182322-11-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yea1qbe8r7dgkp6h48fxs73uwn83xeg8
X-Rspam-User: 
X-Rspamd-Queue-Id: B6E538000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755248175-645567
X-HE-Meta: U2FsdGVkX19rAXEUwFLVLDCZiDBeNA3yNafQ3DVFq9uOiHWoDeqUtGocMQgokDp+Xj5FdVYgbm542mtT7UCX+ubhn5MiRqHcU3QfXe9Mi4/Z2rxta/JLWydDi4E81Z+YTsskVpXhGifYdDe5vcPulg1yFNFS5TV/KD6WKZ4MXtUEAmEBhsqnlNqVSpiY31TUQxEtcPr97Q+FZ6MeYpzecdG3DVYspio436NF7FMF9u2jOvDgKkv97FKe0nKOI5FbB/dFR9F/RTZduMP7WrMlKdf4bQ3qqdm1eIG5M0FkWO9cGBFvqwgN7lNGyHDSslDItKMOL/brsCGoV4Gi7lQ9R1YVbJCw1/05E1dgBuHFvbyso+EcdNMuCC0rRD5fQdbEqVYqG825C535P+j01k0SSQAx+AbR9Gwkhv8P+gYDLfkry8C+D1b2EwUK7cYwUGdTIggOx9ZpEraWpVYapKKtSWDLmyzYueFqs5IFUuv8FteoSaIMXvsY7cv+/OxbFIJPU086Tofj1OIbEyyXXaCNOwzGKbnJ/dweGWTaXP4FpfR/fYRPxzGnk3vH1BbBXdWoU+ND03/3Z2AJrZCkSukFByEZQi4zZ3TirBTmOH+XCnP+Snq08ENUanqfvj4qs8H7fZkohIxtzKOzNS8wOMCIounp+lxHm1x3jNQwkePqqDvHr28yEtMKp1IHmqjJBu0YxOFjbLtCyVyusjx0C2cv01M+bH9P8MyZA0u9VvGk3UWdzUG5a5p0L1IbdVYYADX+uSCVLJuN+zsU3nvUy5Q7EyIS8hN/mVqF/n7ZaJ/23OZP/6QMae7ZKwaxHqDpIv2ghTe03vnHj7DahTPJoByRIlfMe7Av0EMMDp+CaR3FCfFR7dL3gmqDgZTRjVNqRKDL3Eain1ui8DePUpPEljPVfo2UuUeIWx7CEMR2GfIkCMQn/qbxlTcMKRyH4+gAv9NUQe8wbNde83y2UZfG2r5
 mHK/xucK
 6n6nUWi6bgfQpWY8sECkUt6GXFunIi7dE9UD9bxJaVw5FG67kiktkH+0be1Q6HnSHdjmFUwj0zxG6s56DORnaW0YbaqADBGzyTyFKRV0u3x3fpNKmfzv7aAXL3o97wLxFp4GzsiysEDuU/dB83F1MY/jwekdVkc2fXd8zll+WeOzEhd2gJi+QPvpw7exmUf3JOo0+6RZANR4aeNpt77hzFtIuO1c0tOteBE4UE7StgsZAtHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kernel_pgtables_set_pkey() allows setting the pkey of all page table
pages in swapper_pg_dir, recursively. This will be needed by
kpkeys_hardened_pgtables, as it relies on all PTPs being mapped with
a non-default pkey. Those initial kernel page tables cannot
practically be assigned a non-default pkey right when they are
allocated, so mutating them during (early) boot is required.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm.h |   2 +
 mm/memory.c        | 137 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..f4dd96f3db91 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4134,6 +4134,8 @@ int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *st
 int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status);
 int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
 
+int kernel_pgtables_set_pkey(int pkey);
+
 
 /*
  * mseal of userspace process's system mappings.
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..4f144abf5fc3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -75,6 +75,8 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/kpkeys.h>
+#include <linux/set_memory.h>
 
 #include <trace/events/kmem.h>
 
@@ -7183,3 +7185,138 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
 	if (is_vm_hugetlb_page(vma))
 		hugetlb_vma_unlock_read(vma);
 }
+
+static int __init set_page_pkey(void *p, int pkey)
+{
+	unsigned long addr = (unsigned long)p;
+
+	/*
+	 * swapper_pg_dir itself will be made read-only by mark_rodata_ro()
+	 * so there is no point in changing its pkey.
+	 */
+	if (p == swapper_pg_dir)
+		return 0;
+
+	return set_memory_pkey(addr, 1, pkey);
+}
+
+static int __init set_pkey_pte(pmd_t *pmd, int pkey)
+{
+	pte_t *pte;
+	int err;
+
+	pte = pte_offset_kernel(pmd, 0);
+	err = set_page_pkey(pte, pkey);
+
+	return err;
+}
+
+static int __init set_pkey_pmd(pud_t *pud, int pkey)
+{
+	pmd_t *pmd;
+	int i, err = 0;
+
+	pmd = pmd_offset(pud, 0);
+
+	err = set_page_pkey(pmd, pkey);
+	if (err)
+		return err;
+
+	for (i = 0; i < PTRS_PER_PMD; i++) {
+		if (pmd_none(pmd[i]) || pmd_bad(pmd[i]) || pmd_leaf(pmd[i]))
+			continue;
+		err = set_pkey_pte(&pmd[i], pkey);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+static int __init set_pkey_pud(p4d_t *p4d, int pkey)
+{
+	pud_t *pud;
+	int i, err = 0;
+
+	if (mm_pmd_folded(&init_mm))
+		return set_pkey_pmd((pud_t *)p4d, pkey);
+
+	pud = pud_offset(p4d, 0);
+
+	err = set_page_pkey(pud, pkey);
+	if (err)
+		return err;
+
+	for (i = 0; i < PTRS_PER_PUD; i++) {
+		if (pud_none(pud[i]) || pud_bad(pud[i]) || pud_leaf(pud[i]))
+			continue;
+		err = set_pkey_pmd(&pud[i], pkey);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+static int __init set_pkey_p4d(pgd_t *pgd, int pkey)
+{
+	p4d_t *p4d;
+	int i, err = 0;
+
+	if (mm_pud_folded(&init_mm))
+		return set_pkey_pud((p4d_t *)pgd, pkey);
+
+	p4d = p4d_offset(pgd, 0);
+
+	err = set_page_pkey(p4d, pkey);
+	if (err)
+		return err;
+
+	for (i = 0; i < PTRS_PER_P4D; i++) {
+		if (p4d_none(p4d[i]) || p4d_bad(p4d[i]) || p4d_leaf(p4d[i]))
+			continue;
+		err = set_pkey_pud(&p4d[i], pkey);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+/**
+ * kernel_pgtables_set_pkey - set pkey for all kernel page table pages
+ * @pkey: pkey to set the page table pages to
+ *
+ * Walks swapper_pg_dir setting the protection key of every page table page (at
+ * all levels) to @pkey. swapper_pg_dir itself is left untouched as it is
+ * expected to be mapped read-only by mark_rodata_ro().
+ *
+ * No-op if the architecture does not support kpkeys.
+ */
+int __init kernel_pgtables_set_pkey(int pkey)
+{
+	pgd_t *pgd = swapper_pg_dir;
+	int i, err = 0;
+
+	if (!arch_kpkeys_enabled())
+		return 0;
+
+	spin_lock(&init_mm.page_table_lock);
+
+	if (mm_p4d_folded(&init_mm)) {
+		err = set_pkey_p4d(pgd, pkey);
+		goto out;
+	}
+
+	for (i = 0; i < PTRS_PER_PGD; i++) {
+		if (pgd_none(pgd[i]) || pgd_bad(pgd[i]) || pgd_leaf(pgd[i]))
+			continue;
+		err = set_pkey_p4d(&pgd[i], pkey);
+		if (err)
+			break;
+	}
+
+out:
+	spin_unlock(&init_mm.page_table_lock);
+	return err;
+}
-- 
2.47.0


