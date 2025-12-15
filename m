Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BD3D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E846B000C; Mon, 15 Dec 2025 07:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335AF6B000E; Mon, 15 Dec 2025 07:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273086B0011; Mon, 15 Dec 2025 07:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1380D6B000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C91D91A01BA
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:38:45 +0000 (UTC)
X-FDA: 84221659410.05.096FD3A
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDC0114000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:38:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EiSq5tAN;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765802324; a=rsa-sha256;
	cv=none;
	b=Et+gtZXQJqllhMqTz/vUR3kFAluuHySkgdSQ6wETn+bLiiMT31cE2IrsEpKBQ3h+BIfA8Q
	Ib5ExuDS5N3oYwLHqZStF5N1iQHJdxA2VTiFupoNXq6fk8qpcvYW6rUJR62y0YWXM+Ty8x
	HfM9EiPs+U3EoD5Z0jQOZWe2DkreRag=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EiSq5tAN;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765802324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJmsIws2mLYC652kvn3o4ft4IK0jQqiU6SZLxP6Ytqo=;
	b=F093IWFO4uGamCvfJx3IA1JqZFLHreLQ+wtrDBgo5farhu8VKibQISEX2YiUsz+iydMVdG
	kj4O7j7GNegKq2uriNCYgpp0PnVgri1Nm5xwaI8EAdJ5uzlh9NdLVPgCSoGb/d+SV1Oruc
	ME3zpzE4Pkiopc8FS0edS4RtKQTIbEU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IJmsIws2mLYC652kvn3o4ft4IK0jQqiU6SZLxP6Ytqo=;
	b=EiSq5tAN8xJGoKtGeYhSE57XqFDqGACwNiGtuBJWFNPuoQhTT9mhwjUW8WumkSkME+FipFboe
	WSME+CqunWjgfjA/YSu1KwtIUVc2jCshk/sV41e3VzntzrLHpbkOvIbQof5XypWpcJ/1in3FfoV
	FJgAOLCg+cOxg91bWWbHB/Q=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dVKLd6Kn6z1K968;
	Mon, 15 Dec 2025 20:36:41 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id C3F291402C6;
	Mon, 15 Dec 2025 20:38:39 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 15 Dec
 2025 20:38:38 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <corbet@lwn.net>
CC: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Zhang Qilong
	<zhangqilong3@huawei.com>
Subject: [PATCH next 1/2] mm/huge_memory: Implementation of THP COW for executable file mmap
Date: Mon, 15 Dec 2025 20:34:06 +0800
Message-ID: <20251215123407.380813-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215123407.380813-1-zhangqilong3@huawei.com>
References: <20251215123407.380813-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DDC0114000F
X-Stat-Signature: qsq3516bsbk5w4yeoqhrrkz5ra1x89cq
X-Rspam-User: 
X-HE-Tag: 1765802322-121261
X-HE-Meta: U2FsdGVkX18t6jLyv9eiu7dJrVhxrCXsSMfibTd7FL9AQascC6AS6cXgH2uexe8I31CO5o9A3IYKYrEjqSjYbesGsMsqkWFcX85DHoJWakjuWJnl04Cc5vS5yAo6P/mNKeOyqGLFYD8NVVeFOaIcbW4BcrU2eMkI8Hmf+h+yZHQqCLFBmAdoXnAVm9/ybA2W7sijPQ+yU26m9a0z53NeTU47wY3qCo/QI9JwrvTSv322PhbCYkBGC3uUGcWmnrljWsf+slbcsAvvOGoW7PkrYq6A7MegjQLWbs0E3HwkSeEwaz94l2bPTAohcUMzXpiBM0Bs+lXh/2aBEDFKV5kZ/nym2Dxvd+eQLYk1RlX+zXkuqR4BQ90tfPV20n7ulzZqECp1q9f7Q1mV2eQLoheioBuSJ/ABTJaCxTS1a0IZh7zKfRafPefxHL28Z7YdmyVcuHBw3hFcdFlZT7MRtKRe1Ak8VFapDofHIHSLSINwqLtjcjBzzsE0GiEmXwGmFbHq7AOgp9RWg8wlBIa3GvtE4mTeVtmf/GHEDpzidL2+WQTCpB9TZ6+sXdgJ4CO7zEBOr6+JND/fRqYyGgTj8M9GBUSSVCFzrgaNLp+7Fs6cbjC03cT2GGGaPzkXGcyPEtgWxxg22YTs1KUckfAiWQXNAAKwRRSNCYlhuuGkzWhjXBDoCmKkSbch8ttERb4ljUJtG5bCJ2cfo+OS79BxVFLeU12wniWYocU2wrt6EyKuKkrdXEKDJJvEnbsJWkDHi1ET/0R2rJ5ab2lcXrCMLN162CJ5CwB1KdfIhBf/+P94OyLdt89ae3wuYz/1n1Axi4Aqu6l1mwG5NjkXcKpBfAe6RU9nz4drWgL1cUIOf3MWqqlPKiEZe77/T70ypY4m8CXB7RKHccovXZR/GT0bdrbHzePy9ALIpp0NEXAmRDxGSElehdl66ar9VzvMOe9ILYiCvEgXkhv43k3xo6YyzjY
 8U+vZRO1
 MyLEEJIqUUhwXWpaGovixzQF231Y9h3+lDcF5r4jiaL26fC4vj7VnOsXjsjC6BXnykf11rFZHmiYsBzoeE0RPWEq4obTg/kK2HJceP8mlqnaqGAPmxu9XxhFw3aj1qYEcC9WKdlHrOawETA0W8jQbsNzl08UatDoBIeRwae/oOMZt+Iv7uwTjlnmE8seNqBxAp2RIAhFFzn01cLD0nbZFxiOB5O2TYchWiaNBvyB1rXzObANMgZejp/bJIklNsD81PSEd+urLjkgcaYvwo79S6kxsam+duYpPDJhEETwWVvl8UUsG4ywWwISF35NtV26Jktn1fPTvAlgjl3yGurNNtaGbQ28rmY2OssPLlNkBM+9UA2V89qsFbmT1zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the user-space hot patching, the involved executable file
segments of private mapping will be modified. If the modification
meets THP mapping, the PMD entry will be cleared at first and do
page COW fault handle.

Currently, khugepaged may attempt to merge scattered file pages
into THP. However, due to the single page COW, the modified
executable segments can not be mapped in THP once again for hot
patched process. Hence it can not benefit form khugepaged efforts.
The executable segment mapped in page granularity may reduce the
iTLB cache hit rate compared with the original THP mapping.

For user-space hot patching, we introduce THP COW support for the
executable mapping. If the exec COW meets THP mapping, it will
allocate a anonymous THP and map it to remain PMD mapping.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 include/linux/huge_mm.h |  1 +
 mm/huge_memory.c        | 87 +++++++++++++++++++++++++++++++++++++++++
 mm/memory.c             | 12 ++++++
 3 files changed, 100 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f381339842fa..bae856a53e1f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -23,10 +23,11 @@ static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 {
 }
 #endif
 
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
+vm_fault_t do_huge_pmd_exec_cow(struct vm_fault *vmf);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
 		 unsigned long addr);
 int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aae283b00857..35ecd62f64c4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2137,10 +2137,97 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 fallback:
 	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
 	return VM_FAULT_FALLBACK;
 }
 
+vm_fault_t do_huge_pmd_exec_cow(struct vm_fault *vmf)
+{
+	vm_fault_t ret;
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio, *src_folio;
+	pmd_t orig_pmd = vmf->orig_pmd;
+	unsigned long haddr = vmf->address & PMD_MASK;
+	struct mmu_notifier_range range;
+	pgtable_t pgtable = NULL;
+
+	ret = vmf_anon_prepare(vmf);
+	if (ret)
+		return ret;
+
+	folio = vma_alloc_anon_folio_pmd(vma, haddr);
+	if (!folio)
+		return VM_FAULT_FALLBACK;
+
+	if (!arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable) {
+			ret = VM_FAULT_OOM;
+			goto release;
+		}
+	}
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				haddr, haddr + HPAGE_PMD_SIZE);
+	mmu_notifier_invalidate_range_start(&range);
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), orig_pmd)))
+		goto unlock_ptl;
+
+	ret = check_stable_address_space(vma->vm_mm);
+	if (ret)
+		goto unlock_ptl;
+
+	src_folio = pmd_folio(orig_pmd);
+	if (!folio_trylock(src_folio)) {
+		ret = VM_FAULT_FALLBACK;
+		goto unlock_ptl;
+	}
+
+	/*
+	 * If uptodate bit is not set, it means this source folio is
+	 * stale or invalid now, this memory data in it is not
+	 * untrustworthy. So we just avoid copying it and fallback.
+	 */
+	if (!folio_test_uptodate(src_folio)) {
+		ret = VM_FAULT_FALLBACK;
+		goto unlock_folio;
+	}
+
+	if (copy_user_large_folio(folio, src_folio, haddr, vma)) {
+		ret = VM_FAULT_HWPOISON;
+		goto unlock_folio;
+	}
+	folio_mark_uptodate(folio);
+
+	folio_unlock(src_folio);
+	pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
+	folio_remove_rmap_pmd(src_folio, folio_page(src_folio, 0), vma);
+	add_mm_counter(vma->vm_mm, mm_counter_file(src_folio), -HPAGE_PMD_NR);
+	folio_put(src_folio);
+
+	map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
+	if (pgtable)
+		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
+	mm_inc_nr_ptes(vma->vm_mm);
+	spin_unlock(vmf->ptl);
+	mmu_notifier_invalidate_range_end(&range);
+
+	return ret;
+
+unlock_folio:
+	folio_unlock(src_folio);
+unlock_ptl:
+	spin_unlock(vmf->ptl);
+	mmu_notifier_invalidate_range_end(&range);
+release:
+	if (pgtable)
+		pte_free(vma->vm_mm, pgtable);
+	folio_put(folio);
+
+	return ret;
+}
+
 static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 					   unsigned long addr, pmd_t pmd)
 {
 	struct page *page;
 
diff --git a/mm/memory.c b/mm/memory.c
index 1c66ee83a7ab..e282adec9165 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6133,10 +6133,22 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
 	}
 
+
+	if (is_exec_mapping(vma->vm_flags) &&
+	    is_cow_mapping(vma->vm_flags)) {
+		/* Skip special and shmem */
+		if (vma_is_special_huge(vma) || vma_is_shmem(vma))
+			goto split;
+
+		ret = do_huge_pmd_exec_cow(vmf);
+		if (!(ret & VM_FAULT_FALLBACK))
+			return ret;
+	}
+
 split:
 	/* COW or write-notify handled on pte level: split pmd. */
 	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
 
 	return VM_FAULT_FALLBACK;
-- 
2.43.0


