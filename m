Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D328EC1133
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1727A6B008C; Mon, 23 Feb 2026 20:56:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8106B0092; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97396B0093; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAE346B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 859AE8B674
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:34 +0000 (UTC)
X-FDA: 84477685908.11.08BD4D5
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38AE6140008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A9tpmETH;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4d1KkxuixEJPZL7S77r0HMbd94GuLo9p14SF+rl+Gpc=;
	b=CtfBj/jCEME15PRZbLlnVsRohDEeWw5blSmy24tJbn78t2Af8ckWZmZZ4roMGH2wl0PSzV
	/k44BpG39KrSeUadrDQHFwX87KQx/cDJUmmMB+8ZFwWl/M2BuXak6Yyl+5TulBXmHo0RIC
	7gAbs75rvIaiJudQ2OBVS9a6374bqQs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A9tpmETH;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898193; a=rsa-sha256;
	cv=none;
	b=qy0D6D+EIEQ9TySWihB/LCHeFIW4mtf8uXdyViTqVFPij7pT4WUcJE/AHnFSMFS7XAzweC
	h9hN/ZMdgkW5BquttMd+aJujgBn7pmyC8dR4bByy7WWew2nafYQucY2oKum6L7wjNQ0G5j
	2gqxBLI/6kOUPY/CqnnqskELtl4MDzA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771898188; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4d1KkxuixEJPZL7S77r0HMbd94GuLo9p14SF+rl+Gpc=;
	b=A9tpmETHY2m/qzZsU3HfTuvFhiJHo+ZZKf4s/v4W4pdZChople01/ZEJeOz83j2hr7lUA5kNKKFsZ0x/tt9n2hh+3yoG4cnEqgGe2B4e8cIFrfHlc3RlUoLZM6wC9sTeoyUZmi7Ex+hhvaptM4IN/6AKjPVu7PlP2EgQY0yI8Vc=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzhqZSC_1771898186 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 09:56:27 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] mm: add a batched helper to clear the young flag for large folios
Date: Tue, 24 Feb 2026 09:56:06 +0800
Message-ID: <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38AE6140008
X-Rspamd-Server: rspam02
X-Stat-Signature: 7fh3xfkucn3sez4k64tsc59tcpaize4y
X-HE-Tag: 1771898191-208582
X-HE-Meta: U2FsdGVkX18j7o1ze79QJJSfyQ9+LaCebXNAECn0bEEAsRTsj0gA1mXn/Up/R5pEbdp2h8L5iVf3EwuUjAR09FiNu36JCji96QWFLu10Gm+gvk/VgTonxKUls3A4AcUvApaS+LQwC4vZQF5ELrbWPJdMuZIkuL0romoIPWhJzuaza9jd0mF0R2ev7E0C7lksVcowwjqGrGIkwa+9BJGDC9NUJ28ZPknF3i/BwTGQs44sR2yIZ8+hF9pD5oiW8VGGJkgzhQoqFwI6j4QVXwXaVLdWLuPkyL91EFIoe6LI2jLWhei6T1UOCEH7KIo3/C16FpRtedkBz1ZLJIjxBKkuEvcowF1PVQ0UXUDWddhVKx4luQmzfiO32HmO3h5Zr8/Yq5HYHZ1y3WuQkRkSqpEIy89BAs7Lp0wz9ENvM+6vdkzT76YX91//SkDZ/9kdwKKionOMFR0Apw8iqkAuKBbyztdbkwdmjKvcOc8FBkLUfIZ7notmnureVjn6jYzdJkn1wMHEgNStAC2j2AME48uI2/FJi7OATj7VnZHVhriTvVRaVAqMXEKtE44r97uQMO41CTGh247RC5xeKPG8BOcLoQMBzpjwIMhOvuO2Sbs0Os8PUOigBe7w+GPVzVCXDC2pWhORb0ociTjKbCP/0V2kQLT4FIfk9C5wUJNufxJueMC4E3sCuJftOoX1ay4iQuxej3l6O90ysmHayx5FRhRMRpuG46HPiOxZ57TP1kHPwqGcHL1iW3qtUiGFEa0dEPeKrPEA6Gmjow9D+xsWGSicZU/hO9Roi0k8BMWqu8ar5XetuqHQAv+fmj4+/4JY21NhCdDupXk4N4bxMI/IgOZ9BhqvkbMQvak6+KkYn4T19sfWCcdM7UZ8lsqJevH7Ou/XexIdlQKUWuFHG7jfsAjM6s72UJvlzJdvGv5vZvCmw9zwI6JgFl1MJtGkx0Je2RWbbXlcPHavfW2TpYyyz9l
 tqj2JKwq
 TV59g+fvNwif3zcLJj42WjP9xHjcshEnqv4IMeZMYHDSP5QD4yIEO1xr6n6tb4dRq7Zz1sAHW+6vEezRkbhwbYNjdTWfbNmYYU2bl0rNt4qOxuVSuhbU0UNf5cWgwHBR5rioE/uhXVMkvAqfx1K0rmwY06CgZDhMULpFuv/z4S1+mcE8ZHp3qISFkTRehdjcmorjvJFPcD4aAHK5KcYvm0tbWTqX7W56gEonItStdpkSLYHfxKo8WU6sUsstglR28bS10cWXQNUt2Bq60C4aldxIMEer3hSLmoFZkg2UDb5CPHwyR9A6zJOWNikIO5xGFFzKm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, MGLRU will call ptep_clear_young_notify() to check and clear the
young flag for each PTE sequentially, which is inefficient for large folios
reclamation.

Moreover, on Arm64 architecture, which supports contiguous PTEs, the Arm64-
specific ptep_test_and_clear_young() already implements an optimization to
clear the young flags for PTEs within a contiguous range. However, this is not
sufficient. Similar to the Arm64 specific clear_flush_young_ptes(), we can
extend this to perform batched operations for the entire large folio (which
might exceed the contiguous range: CONT_PTE_SIZE).

Thus, we can introduce a new batched helper: test_and_clear_young_ptes() and
its wrapper clear_young_ptes_notify(), to perform batched checking of the young
flags for large folios, which can help improve performance during large folio
reclamation when MGLRU is enabled. And it will be overridden by the architecture
that implements a more efficient batch operation in the following patches.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/pgtable.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/internal.h           | 23 ++++++++++++++++++-----
 2 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 776993d4567b..0bcd3be524d3 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1103,6 +1103,42 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
 }
 #endif
 
+#ifndef test_and_clear_young_ptes
+/**
+ * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
+ *			       folio as old
+ * @vma: The virtual memory area the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear access bit.
+ *
+ * May be overridden by the architecture; otherwise, implemented as a simple
+ * loop over ptep_test_and_clear_young().
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_test_and_clear_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+
+	return young;
+}
+#endif
+
 /*
  * On some architectures hardware does not set page access bit when accessing
  * memory page, it is responsibility of software setting this bit. It brings
diff --git a/mm/internal.h b/mm/internal.h
index 1ba175b8d4f1..1b59be99dc3f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1813,16 +1813,23 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
 	return young;
 }
 
-static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep)
+static inline int clear_young_ptes_notify(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep,
+					  unsigned int nr)
 {
 	int young;
 
-	young = ptep_test_and_clear_young(vma, addr, ptep);
-	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
+	young = test_and_clear_young_ptes(vma, addr, ptep, nr);
+	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + nr * PAGE_SIZE);
 	return young;
 }
 
+static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
+{
+	return clear_young_ptes_notify(vma, addr, ptep, 1);
+}
+
 static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
 					  unsigned long addr, pmd_t *pmdp)
 {
@@ -1837,9 +1844,15 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
 
 #define clear_flush_young_ptes_notify	clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
-#define ptep_clear_young_notify	ptep_test_and_clear_young
+#define clear_young_ptes_notify	test_and_clear_young_ptes
 #define pmdp_clear_young_notify	pmdp_test_and_clear_young
 
+static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep)
+{
+	return test_and_clear_young_ptes(vma, addr, ptep, 1);
+}
+
 #endif /* CONFIG_MMU_NOTIFIER */
 
 #endif	/* __MM_INTERNAL_H */
-- 
2.47.3


