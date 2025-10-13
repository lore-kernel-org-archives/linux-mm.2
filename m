Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D9CBCCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6C98E000C; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7BE8E0002; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDB08E000C; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1775D8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:21:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9BE8866F9
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:21:32 +0000 (UTC)
X-FDA: 83992548024.03.F172767
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59B2210000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:21:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AtrNoBa3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760347291; a=rsa-sha256;
	cv=none;
	b=3KmkdAZ8Ok7vI0q11MSjjxrTMFyby9Ujtlzo2hAN3d5gPO0eHvMJEGfR3xj8gzbbOS6buB
	y2dt/4Uct6rzprNkMr+aft/GZoUc/puaQvO/aijzT4DEQWi/jimCCQY060vke2nX5+D+7E
	QUzQz2D3Dpj8nB0cJKVINVxPmerad2k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AtrNoBa3;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760347291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWm1WdWttrhOYiXiJuOMK69KNjE6Idu3TEdWrDwmXPQ=;
	b=04I2XDELR9vRP9fzWyAIX3AttpW1HCNxCjrnktDTS61FWESkfTMJPgQDqH1DoHWp2L+hhr
	cleLc1GPRiv6gcBDUfQ2MCblzJLVRrk2zpOt6IBiOS5hq5vQuEsl3KuRz8mtHgFhP1QXGb
	E9xYZzNfzdA4qu6BfOkIsORtpRa9UE0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760347287; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=aWm1WdWttrhOYiXiJuOMK69KNjE6Idu3TEdWrDwmXPQ=;
	b=AtrNoBa3F3m0Ly+Wx3DPDNc4Ir7xn8lVA6ZzhDRVd0wBEb5C3DXNfkEgcT0J52HwyMzDDDppRdaGQac0KiJdfi1+8LVSFPig0gXMDEwIdR0xHHIiQMaLyiSmp7JZVgNtNetz0PeYfP+sstghG6tOtoJcHc5Iu7GlKvQAGpnS0Ro=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wq1nigk_1760347285 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Oct 2025 17:21:25 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge pmd
Date: Mon, 13 Oct 2025 17:20:37 +0800
Message-Id: <20251013092038.6963-2-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ei5w6fxq8f5re5q68y35ix383roa6ngb
X-Rspamd-Queue-Id: 59B2210000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760347289-527031
X-HE-Meta: U2FsdGVkX1/qd5Mp5Q2/YgLcqw/LZ+ViTnhXAX/2Ule09wD0onEvXgDWIDDpJT/KUd6tI6nmwGuZ8KSDw5C1rZ3gMvG7GVLVOxnY+78eCP5v6sn+AoBsbXXbRDncwObKuBqk97x79e7XxEs+oX58ID/S9ZQkQ/s3sk8EgKVpLRzI1yzFUDqsWuvXtRfEp8i/0vzr30WoaQ9Y1Bh+dj00xN3J0QdRYKCQmkSvACul7Am66psMPsXlKrphVA1c7E6RuKyOQ9P9MuJHdTmtf4NwQYsPmEqkF1dNVBuKs9IUmzC2ohol3y/E9wnSe3tRpKn6MaP1NXFmCC/uEcvKrKom3KAE0X59ryEg0IXF27qJfImvsSPvrojpLaIW/IHLW/7c0Teis2Vn9BzF9Y1H5dAPjSf/I+eQrdfapaz6qGraGc3nM7kZWppB9LjbGSvn/dpUdFISweD0S7eLNTHornYUdCriesbY3DkH/+DwLbVmO24JqL/+1SIc6Re4gdwMyT1egXs6R8CR9DVBJ192BBfD7A3BNTidrbpkrrUF8PW+azXKkKTr4m+SnY3AWIFgE+amtLlnIAVsg2iLr9Og2G6D9+GzxBw11uTiO55yDOi7JYaSqx6LE9wotyb/CRmFR0nuSmRZIrPAAoqLwatyMlaMyTe4Wc1LCf8KpmsIzH5k6PqrmofZAakQYrlO+FE881NxZlMH/PRzTePWkhNoJbMRd4ECXV8dIcB4mczQf1fOK0QnbJsLcZs1UT6s8YKV+UnCJEyn6XFoxf/Wg+mwjbSZenkByyLDaG1BBb0PRNuEYQXzpCZxf55UqXfSufgSgFQbiJaoYWuvadunLY8kVzQxl6Kut5wnUVegCF5IYicIg/mwZxuZ7Px1phjwR6i6xIIXX3bBG85qM+y3tISAHNcNYQWC3zFxJb/FMzTTiQggADCG0c1HNeG0UfGLG7V/mPeMfUlNlDUncuaSOW2oCB3
 BVl9Bc//
 yzIC+P2m0QTjv4TVPut5vtq4SrWriEOR/Oue9yBr+qVd0IYuXdHYO+rFFY7UFXSwBkMDrvhJJDTBEp/u1NEXlh9K2OQeatgHuFZXO6p5WOAL4ViT3/MMr3dpJxFAcpjP6X3hHtpiagJUlBjICuuTzOvX/uNhfpKXakLOwsv2Vn/QBC1NHyCFhFmTV2vrSeBicT2mYKEjW6AQZb0wx5G4yaNNwYjQRroEN+umGoQ00Jn2ZoaNawGH/8oGJhcG0UnTJRlwMEr/EZQcJepTm2alO9reCoJCvL62q7GUeDAFwT/bF8avCIMQkKpy7xoupDmO9Em4G+NR1C3+eUVbwJxT6esqd8QgkuYkzeLt7bYUnPTlkr0BXotOwmSjuLPouRyUtB+PBBu1AXer36J9Qoh5VOoQRUzJ9TLIxpJ+lmRUnygzLHhzVfurUH1ZvQSKC6cA3CqoYP4ZY0KE8AYP5RqzzZspzSjrVUB5jLCP0F0aE1gK2oGm1Q/Hh1odE5gf2xLSQmGozMHDcsmaa8LVY2k4o86FVn+rcchRk9sJAw3JR1A9Zcu3DvduUJOzUrmuUlpy+lp7VSGkjGI2TntWF65f+twoxbraOgUilSL11ILA/8LvYDiREaJpuxHF33g/WY39ulqJ9Nm1wt5dcVW3wEVLy5X5+jYMXY3un6YS5dHiDvPoCjxDZW8ImxBtft+AVozCxPfiDCp8XdTDnPAVB8kMHguK+eJKspBF6kjtW6NwsDVcnE/XDdaRfuySjXd7CGSLt86yzMTFNyl3KVrT3pjyqhN6LIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current kernel, there is spurious fault fixing support for pte,
but not for huge pmd because no architectures need it. But in the
next patch in the series, we will change the write protection fault
handling logic on arm64, so that some stale huge pmd entries may
remain in the TLB. These entries need to be flushed via the huge pmd
spurious fault fixing mechanism.

Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/pgtable.h |  4 ++++
 mm/huge_memory.c        | 22 +++++++++++++++++-----
 mm/internal.h           |  4 ++--
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 32e8457ad535..341622ec80e4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
 #endif
 
+#ifndef flush_tlb_fix_spurious_fault_pmd
+#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
+#endif
+
 /*
  * When walking page tables, get the address of the next boundary,
  * or the end address of the range if that comes earlier.  Although no
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..8533457c52b7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1641,17 +1641,22 @@ vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
-	       pmd_t *pmd, bool write)
+/* Returns whether the PMD entry is changed */
+int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+	      pmd_t *pmd, bool write)
 {
+	int changed;
 	pmd_t _pmd;
 
 	_pmd = pmd_mkyoung(*pmd);
 	if (write)
 		_pmd = pmd_mkdirty(_pmd);
-	if (pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
-				  pmd, _pmd, write))
+	changed = pmdp_set_access_flags(vma, addr & HPAGE_PMD_MASK,
+					pmd, _pmd, write);
+	if (changed)
 		update_mmu_cache_pmd(vma, addr, pmd);
+
+	return changed;
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -1849,7 +1854,14 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
 	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
 		goto unlock;
 
-	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
+	if (!touch_pmd(vmf->vma, vmf->address, vmf->pmd, write)) {
+		/* See corresponding comments in handle_pte_fault(). */
+		if (vmf->flags & FAULT_FLAG_TRIED)
+			goto unlock;
+		if (vmf->flags & FAULT_FLAG_WRITE)
+			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
+							 vmf->pmd);
+	}
 
 unlock:
 	spin_unlock(vmf->ptl);
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..8b58ab00a7cd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1402,8 +1402,8 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
  */
 void touch_pud(struct vm_area_struct *vma, unsigned long addr,
 	       pud_t *pud, bool write);
-void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
-	       pmd_t *pmd, bool write);
+int touch_pmd(struct vm_area_struct *vma, unsigned long addr,
+	      pmd_t *pmd, bool write);
 
 /*
  * Parses a string with mem suffixes into its order. Useful to parse kernel
-- 
2.39.5


