Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B72C60A261D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=HaM7i9GC
Received: by kanga.kvack.org (Postfix)
	id F40AF6B05D9; Wed, 11 Nov 2026 04:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF11E6B05DA; Wed, 11 Nov 2026 04:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E076E6B05DB; Wed, 11 Nov 2026 04:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0C156B05D9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D138B4025A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:03 +0000 (UTC)
X-FDA: 85422336846.29.B57ABB1
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 977DF1A000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HaM7i9GC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389882;
	b=buI8+B/2uZlNNG55casXKoMjderUvoXj4QxyhqY1IBIpWpsK05DUn8eIH8/qniPZpcRSMz
	yvhgBxpQ6IxaOnolj+Wj8+84P/D/bEM0KvbIH6sT/0BZ5o+U6vCoVweg9ieDrStd8/jxsZ
	G94snEPoJS/S9EPyIj3n/pWjcSPy7Ks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/lAuxNghYAit4d32b2tzmDG6oe5SfeXzLViO4wF0VE=;
	b=BAFiLNN02tgVmH4UMUFIRVo6ihmREA+DiOUS2CJICZsP2k3+2mq+/UusNTMHmFCwNq7h52
	H6shMV/Qe21yPfDJOvyt2HJLixib9zA1kJQX3MzWgLbqZM3hsRTcAnn+Czs0NhDdexLBEE
	XbbW6+L+s4jagusCB0yym8q6LIr8DDM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HaM7i9GC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso6134737eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794389880; x=1794994680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J/lAuxNghYAit4d32b2tzmDG6oe5SfeXzLViO4wF0VE=;
        b=HaM7i9GCogkEbNdp4ws1D24PtJCwgZX8/Be62urD3B3b2zAqEr0+Q3C9NdjaQDsG3a
         2lgfNrGL7FIS55vB0+lnYXIbHQoE536Uc9sPrNLUkLttxA9rp+ed3UOWQfVNch1siby7
         XuEoXQH+OdstZehT/AkDw0eRZw4uSryCx248VHn0uklKcQOgyyDISgFwb3tDySfvpyBR
         x+YNAHmDh4HpHXEgeGL0TwIPoXqz9HoNOLOpuRbhNPUYqN80R7N2QK78vm9ewS5nAEWE
         QQ1eQTlbEIdnznMKhBelXEd9+AAyii2NrO0Adh6MBHYki3Ra34DdfMMERWnZFlxoOXF1
         j0Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794389880; x=1794994680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J/lAuxNghYAit4d32b2tzmDG6oe5SfeXzLViO4wF0VE=;
        b=ObR71b9gfnNeMA5RRpaBwsxTxtxuZB9XxVV77wqUn3tnXjIJrnKOMuE8Ld60Hjg+oh
         E+LXZz4mV97CHFSaRMyp5x+I/xZAMlvSHraY4VdBPqkyuvDSQqCIxfU5tHA3RpPU1wMF
         u4Kesd/ZKs4EfecN2NMA59TRb0ffEuNxSN2hjQ7HjyonWbSjhyF/Bqbnnz7TjFiC2/FP
         75DOkiYnhq5y2XiI9r2YOxZNlu1yYqDOaDEqOCMm6UUupvCaUskWs/Cwh/Kvz1NY1Ztz
         yRTHw7iiJ0fD4KBC4wSBPUlPsXqY3bZIO9rmAy9hBftWRSX/zU2JrA1VuQxIiyh+AxIg
         N8Qg==
X-Forwarded-Encrypted: i=1; AL+hErGmPUeFqRRYej6ooi2ZgraH5jV9YUXvQhBeNflEQmS5hUhQRkvY1rgUzMrn6OXmBwryHobIqQsw8w==@kvack.org
X-Gm-Message-State: APuU4Z+rWLczvm19pNu8lkXqPmgkjOlmaMEMCPTkU9vx/CJ3wGHTlugd
	92SKrGBc7m7YAqalWjcYxYFvyomLuvSHNaIGbJyoba1DxsDcPWNq3fxy9r9UczxIogU=
X-Gm-Gg: AYBFou2iKtvkyTKHVq+p4GJd+LyKuaxU10QmoT8bN4IFQXij7UjqumUgBXQMcMcg1s1
	xC78B6TqXXOgPqZPp7sW1g6qheiA8Ej0deT6CodeULF6OOdWgsa370Psct+okPYoaBASAK6QPMS
	O/muUqf5DEBeJdm4aYTd0yAZA7higjqDjtw32/tLdsNMLyzvdY2JMx+6QCKP5BDZILB75n4qkHR
	2f8SQpfHpp7yIZP+18FiB9yfWE2pftv01synEc++clUVr+OiIayyKl0OKEjuC27w/Tdnwekw8BT
	xn43uVAoikHhLuDjhG7j7n4rs8Iuimpo52grtkRC3rHZki007ZUhTCNhboxoqh1hjZuxaOToULL
	ARDTXTknEe4GD+/uN9NC7/uA7EfEtxTU4yK4IGOpSfvpi3UN46LRe0KENXHcJy7jH28UQCv0hSP
	Yua4LMfaVV7nLucL1E0UT3zGspQREurYANfAbRW4wF/efH2z37/i8FxDuEteTc0w/U2t8ovHAOg
	Wilddhs7z/QEg+7148fFg+nKEo2fZr1mZXwzmMF8MpmInti6KGXZ6Gv2P2xx0185Sr0pvWDonlq
	Rd8NSfOJCJeJ0nfT9JS63GsI/gtPTwb8evNo1HHAwrlZoNc8iIVWlYwgqnO0uQ==
X-Received: by 2002:a05:7301:2907:b0:369:fdae:c9fd with SMTP id 5a478bee46e88-376850ce224mr3460636eec.13.1794389880052;
        Wed, 11 Nov 2026 01:38:00 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e9e03sm29016749eec.23.2026.11.11.01.37.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 01:37:59 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/hugetlb_vmemmap: fix lost HWPoison state during optimization
Date: Wed, 11 Nov 2026 17:37:44 +0800
Message-ID: <20261111093747.50048-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111093747.50048-1-songmuchun@bytedance.com>
References: <20261111093747.50048-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 977DF1A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: htppki6f5f4wd154nxkn4bq3n5jm696m
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794389881-741291
X-HE-Meta: U2FsdGVkX18mv7rVNjytwOHe2XRRau5wwm4CJvh8MlJmkjRn/d05ekZtKcvItie2aFasOlbMzm4Ujmjho4Xl8kCMY+GU9nVwQ3u7odLaTnZ4UGw49ZDS7R0ISLf4wD0ns50+5hLmu/fc3YEdTWWgmYjJd4BaiAAq5rH1gjcgO53HoUEIT0rHFG5TtS/jCmerlRa2IWkINYRf2yvkhLhLFMxlpx6qCCxJNeY+UK30r3fXv4G4BFLDPD6iKJvqJURgtgOv8BUufFsSb3/Y74dMqomXkx0atAWlSE1rX20BOH44dYlrjsbO4vRkaDUeg+pPSgeQIlprpMqTnWSYgzI75SJ/91GrjEJHS4qyTrFZUbsmFaalyf8K/+q1flJa0SuCRv8tx+UKfPKxUTIuFuwocwWavpG6ainRVtC+xr4YSrVNvUBl0M1fLvP0FbIUVoQfJDD7/9Q6K7phXon9FgkXgK5aES3Zxcq/SQlGzjzQ1usmuHjlGlPrjbK5Dx6kMdTVCGW4krKr7u7copyPk0aKcYgredgjDEullx0VEDKP4gRoR0VyqVj14UueiF7BD2M1sFv99HAUFUyI8a4tyjrDj1Zh6w7g8p7z+jdPaU0AHS5LZEsIafDQPLHU+wheLho9Mdk0y40G0yEljXwKk53z5Qty1+dAiEslp4K54SHmaPZrLkctq1G4lDL2ESC35o5/9vMvH5UICxdbJ801PVwpmVUP9y1DBKyH5gJ5s0oCKJLlxF+ZWgDfqwc09z8iieOPl/qCBevkyUvhQMDIln4g9FOwBUT6tl2iZfI+NF8Xdc0+nqTnUb0vNugjKIwGnCUga8XeeZB3GYhH2rGRER+po6yxJZYk3DrRsQsCyvr3iNBzpq9A8ktAVr5NADn1D++peDVAo261IKTqC8YnH25K7DUpXnNt1o5I4wxSx4y7nPhdpohS5St3UxfStLXXS8OQX/Q7Ed02WVdGPXL2d9T
 W4g0Nz0m
 WfQi6rqj9eNNFDcw6cX9X2CZQWw6BTI12q3QRFBrotZeB4LenMosJ4qukT9DXLKdAQ3PZvjebNYxdJWWBGwoHYpLAD7DFZDIacawmMqDD/lGRyaa6CedLpZeeeimrhYLAGe87/m0Lw6LISUrOAmMRxWJdljzo8l6MZNyrnRpbf7u6MxDzCAM14GlytVta+kh66dz1j9746B6X3ES/V5+jndTNR0NVPC96gjzT6EzH7ynbbDt7aXe2/5MpWQ/axs3x07Tp74QblqJbOf1ttgdcC/jhLhflExIXxjPbyFj3rTUK/+7kZzLyMo0EOkyvdVoDTdaMzMz+KrcfKfEnybLHIlWXQXhdeYAq/vsOLcMng14sBTIqQShdPVFPo+1N3M+rfO115saKwlhlZSqFCEa313+OahvF/3fQ1U9kOfw3FSaabH/p2g6jAHVt/eVsGSybNXV9WTpoYby+z9wSZlia9n+GOwStQ43bE9XI3uVmYYzLxTKp6CbvWZQVOmig2QbHn4gxF7QguGN1apRbiva1hBp/zb3O8iWSIDht5QUVYYsTn1znLVxIf+N+wAR/bVZvNNvm5hzNxSLJ1/apQoeFHaAW643iXo8lZK8oH9eZSVlImDXs+ieHwHJE/fq7Gm1Y3wA/in5/fg0mtQ7tAPwu0hUzA0GYYzteAZHT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HVO copies the vmemmap head page before remapping it to a newly allocated
backing page. Memory failure can update the old head page after the copy
but before the remap's TLB invalidation completes:

CPU 0                            CPU 1
init_new_hugetlb_folio()
__hugetlb_vmemmap_optimize_folio()
  vmemmap_optimize_pte()
    copy_page(old_head, new_head)
                                 try_memory_failure_hugetlb()
                                   get_huge_page_for_hwpoison()
                                     hugetlb_update_hwpoison(old_head)
  set_pte_at(..., new_head)
  flush_tlb_all()
free_vmemmap_page_list(old_head)

The raw_hwp_page linked to the old head is then leaked and the folio's
HWPoison state is lost when the obsolete backing page is freed, allowing
the poisoned huge page to be allocated later.

Serialize HVO remapping against HWPoison updates. This ensures that an
update is either copied to the new vmemmap head page or applied after HVO
installs the new mapping and completes the TLB flush.

Fixes: 11aad2631bf7 ("mm/hugetlb_vmemmap: remap head page to newly allocated page")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
---
 mm/hugetlb_vmemmap.c | 10 ++++++++++
 mm/hugetlb_vmemmap.h | 24 ++++++++++++++++++++++++
 mm/memory-failure.c  |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba8e11e399b2..79ca68dff635 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -15,6 +15,7 @@
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
+#include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
 
 #include <asm/tlbflush.h>
@@ -41,6 +42,8 @@ struct vmemmap_remap_walk {
 	unsigned long		flags;
 };
 
+DECLARE_RWSEM(vmemmap_remap_rwsem);
+
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 			     struct vmemmap_remap_walk *walk)
 {
@@ -333,6 +336,9 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
  * responsible for freeing the pages left on the @vmemmap_pages list, even on
  * failure.
  *
+ * Note: The caller must hold vmemmap_remap_rwsem. If TLB flushing is deferred,
+ * the lock must remain held until the final TLB flush.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_optimize_folio(const struct folio *folio,
@@ -348,6 +354,8 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 		.flags		= flags,
 	};
 
+	rwsem_assert_held(&vmemmap_remap_rwsem);
+
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_optimizable_order(folio_order(folio)))
@@ -536,6 +544,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
@@ -588,6 +597,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 
 	flush_tlb_all();
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index d057e8b12bf1..8b28063d78cc 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,9 +9,12 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
+#include <linux/rwsem.h>
 #include <linux/vmemmap-optimization.h>
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+extern struct rw_semaphore vmemmap_remap_rwsem;
+
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
@@ -20,6 +23,16 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
+static inline void hugetlb_vmemmap_write_lock(void)
+{
+	down_write(&vmemmap_remap_rwsem);
+}
+
+static inline void hugetlb_vmemmap_write_unlock(void)
+{
+	up_write(&vmemmap_remap_rwsem);
+}
+
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
 	return pages_per_huge_page(h) * sizeof(struct page);
@@ -59,6 +72,14 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
 {
 }
 
+static inline void hugetlb_vmemmap_write_lock(void)
+{
+}
+
+static inline void hugetlb_vmemmap_write_unlock(void)
+{
+}
+
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
@@ -69,6 +90,9 @@ static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsi
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
 
+DEFINE_LOCK_GUARD_0(vmemmap_remap,
+		    hugetlb_vmemmap_write_lock(), hugetlb_vmemmap_write_unlock())
+
 static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
 	return hugetlb_vmemmap_optimizable_size(h) != 0;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 78f0a13349cb..164a02866fd5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -69,6 +69,7 @@
 #include "page_alloc.h"
 #include "internal.h"
 #include "memory-failure.h"
+#include "hugetlb_vmemmap.h"
 
 static int sysctl_memory_failure_early_kill __read_mostly;
 
@@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	bool count_increased = false;
 	int ret, rc;
 
+	guard(vmemmap_remap)();
 	spin_lock_irq(&hugetlb_lock);
 	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
-- 
2.54.0


