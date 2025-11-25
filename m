Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D02ECFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E356B002D; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC546B0030; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B94F6B002E; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6116B002D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:57:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9720897BF
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:57:08 +0000 (UTC)
X-FDA: 84147315336.17.F22C3C1
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf19.hostedemail.com (Postfix) with ESMTP id B094A1A0007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:57:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="W/gr+dld";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764032226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXtn3K8Eq0WVSir81qSgpoCSJ7ob/sT7KbPkVXVRj10=;
	b=djhYNYVZzOqWSXsP7OWX9sBThG2SeUEtCDmUsztsoBQG81E4xS3/RPsgZ6MvidkKNrVyzw
	k8eOKgyyZkSYV/FzhwsxpejB2T/X95JZhaEv+zvMSfzAN8ifLzQZnYpf0/NXtIQ8MqUuvp
	3+MEaDzpIhAGiFUlgkCAt/iP88jF36Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764032226; a=rsa-sha256;
	cv=none;
	b=CMhTHhuzT74KBXolCxKcO1dxt6fa23Ma2+QOrk9FuI3HDxTVwe7OZO1RlQifZ1to+j1Qgg
	Z9blAKC3fPSP9GG3n74yXnKAnMn/aNprHUCDMtKXqpS3E8hLRVHhzDOfkn/huVy7lcxsT4
	TZaOxmJhvyvMdc7FGNf44F8JmRrkmdY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="W/gr+dld";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764032222; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=OXtn3K8Eq0WVSir81qSgpoCSJ7ob/sT7KbPkVXVRj10=;
	b=W/gr+dldUaOPMMYCmgKdfMICk6Hymdi/2eRiSi9Xwb4k2fS5Y4JdVfwPu65gsj+klUXUFgs6VOXgnhAZdtcyDpGI47lZyMb/wgMkPtF9G5ktAwyftqdaKwkQ/LMAzYt1ecxwtjAd4wfdEZXF0chL06sNwrI9fZTtDjjdhXlUwjM=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtL74.V_1764032220 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 08:57:01 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: rmap: support batched checks of the references for large folios
Date: Tue, 25 Nov 2025 08:56:51 +0800
Message-ID: <dde5a9135710d8d883e30e0acadcbf1ae754bf7a.1763976541.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
References: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B094A1A0007
X-Stat-Signature: busrymer1yum89f3zqne1kkycrn9pd8n
X-HE-Tag: 1764032225-392308
X-HE-Meta: U2FsdGVkX1+00nYBVygqs+EYZyZVn3T1u30xFtrgoTozjJVim752hWeZ6AUvaCOoknG6mMeNtNPnbtpxCmDHi8KJb5O2p7oN9KEQ6jI7aGpQjgSwwyEINL8bW1+5ov+OIqdnVD4j2N2o+tVwPNYC6DcXgvuqhQ92A0af2AeigLp8wtAIujwJv1xSE9cGpG1tQkmJKibTW8vKMqmy/R3qdVBU1HMuhqklzwL1yEss2POmb+VDcm63zbS3L2Zd02qYQOmt65aNwnDeBQvQMvy2QYl1AJnq91YMWDSjoHw1ZifAZVrR5jA9eZxMTgEVeqAjlY9uwfrRjBoaCeUPIqiMWAGgRfRZJrIxfrnlCIaIZhQjV9FrbWbT4W3STNQqrt9gjwzvvMYPWsyGgCPKu4oqL6q/1vFRU/kqmc1os3GOjJRME8D3TtBCl/5taRVUK/D7l5AlzsyjZ9E7ACB8yFcaDNRAiTkwlkONLKz/Bc974BP4subpqeUZs+zSpSPFO331gZdsgSipAiIZKjUwnBhNx2Rd1HywUxEb2Hx64Gt34ukJFX4GGNXcPzBO/ohl/KelnxyTdNuHsgvB1TSuiWgsR5BQd+jTQuQ5LZ8W0H5zrgxNgG9F3oMJrN6myOPcVhxZvipr3EE5AfoZEkweQleH9m+0dItJj7OKLhThCLOyzZfhNZcjdNSzmJ/IopqCkf53+kBJqvVJS2yDHjI4AyWvix/Nf/LraqtN4JAz7/ItV605Yoq9HHLXOzhwKy+uwWAIVXu7zF1KZ54GeAjLCCz8sOKvszveO4lg1XH3SDYPni1ek9AIMhZvmzEQtGdI3nsHXVxVcCCbj/Wso/G5LMkAHWF6GNArO+vA2t0nFyWYvw8LaD7unl10/xaqSHTA5+3ORkBtLt6BcdnAeOZHfc7S9gXD71GyPo2qk8lrQvmH1FIWzqSQqkkb5CLYAJLICIMbu0p/YD++3ftND1Pw3UB
 3uWR/kin
 4o9Mqq2u9ZUoLQT49e2rbplZOfnMnF6BfqWxRaALzX6Hq02GVhVZoplFAKksAmZS1TLJ7vq0Ta+sRB9RcJNlNcautUErGfo9P/SoX6LMTqrhTlTVETc1hhVUCXvRMap5ao5v8eS0H3Xx4RxmlyuTDcE3HNyeZTCA+KidSUSiyn1MkISk8l9HFsvnSBSMs53/m7KluK19/SEkU1+D9U6CrY4+E8eTQTnUGFVrBt3qmBoFQdCvQ9+CldYVXy4Dl5O8qpB0fhBAPQClLkRedTVUiKsc61RIar8XGgRVy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_referenced_one() always checks the young flag for each PTE
sequentially, which is inefficient for large folios. This inefficiency is
especially noticeable when reclaiming clean file-backed large folios, where
folio_referenced() is observed as a significant performance hotspot.

Moreover, on Arm architecture, which supports contiguous PTEs, there is already
an optimization to clear the young flags for PTEs within a contiguous range.
However, this is not sufficient. We can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).

Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
of the young flags and flushing TLB entries, thereby improving performance
during large folio reclamation.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
33% performance improvement on my Arm64 32-core server (and 10%+ improvement
on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
from approximately 35% to around 5%.

W/o patchset:
real	0m1.518s
user	0m0.000s
sys	0m1.518s

W/ patchset:
real	0m1.018s
user	0m0.000s
sys	0m1.018s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/include/asm/pgtable.h | 11 +++++++++++
 include/linux/mmu_notifier.h     |  9 +++++----
 include/linux/pgtable.h          | 19 +++++++++++++++++++
 mm/rmap.c                        | 22 ++++++++++++++++++++--
 4 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e03034683156..a865bd8c46a3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
 }
 
+#define clear_flush_young_ptes clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
+{
+	if (likely(nr == 1))
+		return __ptep_clear_flush_young(vma, addr, ptep);
+
+	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
+}
+
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
 				unsigned long addr, pte_t *ptep, unsigned int nr)
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index d1094c2d5fb6..be594b274729 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
 	range->owner = owner;
 }
 
-#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
+#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
 ({									\
 	int __young;							\
 	struct vm_area_struct *___vma = __vma;				\
 	unsigned long ___address = __address;				\
-	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
+	unsigned int ___nr = __nr;					\
+	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
 	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
 						  ___address,		\
 						  ___address +		\
-							PAGE_SIZE);	\
+						nr * PAGE_SIZE);	\
 	__young;							\
 })
 
@@ -650,7 +651,7 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 
 #define mmu_notifier_range_update_to_read_only(r) false
 
-#define ptep_clear_flush_young_notify ptep_clear_flush_young
+#define ptep_clear_flush_young_notify clear_flush_young_ptes
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define ptep_clear_young_notify ptep_test_and_clear_young
 #define pmdp_clear_young_notify pmdp_test_and_clear_young
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b13b6f42be3c..c7d0fd228cb7 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -947,6 +947,25 @@ static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 }
 #endif
 
+#ifndef clear_flush_young_ptes
+static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep,
+					 unsigned int nr)
+{
+	int young = 0;
+
+	for (;;) {
+		young |= ptep_clear_flush_young(vma, addr, ptep);
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
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..3833b8557a6f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -827,9 +827,11 @@ static bool folio_referenced_one(struct folio *folio,
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
+	unsigned int nr;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
+		nr = 1;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			ptes++;
@@ -874,9 +876,21 @@ static bool folio_referenced_one(struct folio *folio,
 			if (lru_gen_look_around(&pvmw))
 				referenced++;
 		} else if (pvmw.pte) {
+			if (folio_test_large(folio)) {
+				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+				pte_t pteval = ptep_get(pvmw.pte);
+
+				nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
+			}
+
+			ptes += nr;
 			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte))
+						pvmw.pte, nr))
 				referenced++;
+			/* Skip the batched PTEs */
+			pvmw.pte += nr - 1;
+			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -886,7 +900,11 @@ static bool folio_referenced_one(struct folio *folio,
 			WARN_ON_ONCE(1);
 		}
 
-		pra->mapcount--;
+		pra->mapcount -= nr;
+		if (ptes == pvmw.nr_pages) {
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
 	}
 
 	if (referenced)
-- 
2.47.3


