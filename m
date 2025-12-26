Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B99DE8FDA8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 10:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47A56B0092; Fri, 26 Dec 2025 05:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5196B0093; Fri, 26 Dec 2025 05:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93186B0095; Fri, 26 Dec 2025 05:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3A986B0092
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 05:07:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A4245DE94
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:07:15 +0000 (UTC)
X-FDA: 84261194430.13.C6CB817
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id D48E44000A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:07:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bfevaC0V;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766743633; a=rsa-sha256;
	cv=none;
	b=Kb4SnWN5oj4sCMXIsRaoHVKwkGVy/eO3ICmzAtZtaoI07uEKMhNQyhhMSMuf4wKQk6Guj9
	db72TUnqj/vxdcAxupM/8LvAP5074CvdpgER8kwixRE4VOxlA69skJrIiTTldsWouoO5KP
	ExnlrqxuzvEvh3/L7Kfe5zwdrVx3j3I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bfevaC0V;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766743633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FelxkyErKwb1fCWEkQdWu7laREVOj//W6+ZNk547/w4=;
	b=evhkY6MXi21qBx5SiAIP4qXSyhVBz3MqCXyKcPY5kUsV7vK28FMEhjL/Ia0b+jOw04MYaB
	LwFJseV+SPtzYoOyT1KdFx63kFizfRFD3uhi/VkMJhRx3TVs69ZsZLVQ6gsGqMp9upcqNx
	prjhibxBahsFefrPqN1CKglSF+xpBWo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FelxkyErKwb1fCWEkQdWu7laREVOj//W6+ZNk547/w4=;
	b=bfevaC0VlaS9jhmmNkT/OUKQ5e1dnyVIixiQc3MalsmrXfjRi/FJDBe7GWMsJutkH/BeUJTT2
	V2z+v3UldI1KC9EQ95SQm1wpwW7xisylD/ixNMQDyOOxxQCIdqdamMSKvRG1+KO7Pq9PXbk15kO
	PTPDm2uQjzYepYME2C2qzVE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dd1RD2q5Kzcb1b;
	Fri, 26 Dec 2025 18:03:52 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 5596F4036C;
	Fri, 26 Dec 2025 18:07:02 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 26 Dec
 2025 18:07:01 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <corbet@lwn.net>
CC: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<willy@infradead.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lianux.mm@gmail.com>,
	<zhangqilong3@huawei.com>
Subject: [PATCH next v2 1/2] mm/huge_memory: Implementation of THP COW for executable file mmap
Date: Fri, 26 Dec 2025 18:03:36 +0800
Message-ID: <20251226100337.4171191-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251226100337.4171191-1-zhangqilong3@huawei.com>
References: <20251226100337.4171191-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D48E44000A
X-Stat-Signature: nptre8g1yckaw7h36z9jrof1c459pyc1
X-Rspam-User: 
X-HE-Tag: 1766743632-998829
X-HE-Meta: U2FsdGVkX18vrZVoApF+z+g4tpjqmz0+O8wbRHW1KOFXyPhKxCxvfOzkoYdBBCCLqy658Cqd2OOPBFEyzOFGKmY0q08Fsz8reeN1hx0ZZmH/hA9ak0R3/tUBiieix18nfKENXXMBGm+2jWxzCmutxNplhoMKRL1SAyb14pS+/++OiLAhZzEQr72Cim/5oCW0P/KtDpGkNR4iAOfHZQVAmtUVWKBoXQ3MftQylW2pWb2IRK9Rk45U1A7V2SmaMspQc33wE+ew+GFEB4C7e+v+IoLnCdgciR1/q3pWAA1B4ZBU6sbl3VMB4JFcjE8XFgmh4f0V0fq58WMJZr9T0+sLp6YQu/bwypxL1dHCQBNMC68yysDDuHYqze9CZMHvXdRAW2VjnrzVnTuOMZCq6NKFxwGQOTvWb7z1Fd74JkmT+NDZrtBwTMF4NwDrK1DSfbzzH5e2SKueazJrcqjLvuImM4NhHueQ44uY32xJKgzJx6MmNsDRe2dHxQLCj1AvfneX9X7Ri2Gdhxocn5I6Hptmz1Fuj/kOUGjqGYVVhTlhVN3pbMw2DQJC+TXuxpei6pklhX+avlp2xdGvrx4DBbNyXJk/QA04aRIdwkBmuLnpbD1RaES5109FCcc9IJixjUsfPcWhKNLbKNufFO0zWkxezRCyGid3JaFZoj4i/pOSCOrQRdKdDv4YbLGKNizGV2CtBifB/0HD7J8rDcu0O1d3olTl1K7Dgnidmf2XGuGj49trQcl3R5reCxLz1qFBXn6RdCOCVMZFp2FssQ+bj9VkJmsB4Ly10gsrkadwiAi+mAIKQb+nERdNOkQ47fs6oarctcpK3JYO/WabXULzUqqR0CiVlJyQBt62/N9Qt1cqsv+viAQhaBxSqiJNynwsVEUj+xyH8rz4YIN+j47O4q68gJcOzf5nrb9bBtDpGYy/4Movxm9A/qR1XaxzxoLEDUYw+6Nq0Q+jKxiXlEYF1Go
 XqS3CBIx
 gVeGVqtOlZi/Y+dLgKl7FEBi/ihhLY9B+L6T2wsr+Cj84WB0uGlSjvP2oZpBue/b83ssrsF6BbwR712bmDvGTT/pYbYdgS/QAvXfM/L5Ylwbl9eYTQerYVdcnx9P/gu8Nl8JdHG3+uv4crHBDVVyu+F9TRAUDY8jJRR1c4YIgaod+pM4VkJfdkgtNgVKrPykepz2FieXPrnOic6zKn1YJpLueMLOTBi3Gqn0ipO7PWwk79sTmMEDy9XEulk9O2Gvwdj9iZRwl9g8AQWDQZ9fLLuQe4AouYf8soOvQoMCSkyK5sXjADVNKV6Yw3eJ3005oYXKLTjyr2bDP3hsPtRhIvhSvP0l6P3chq6RnIe5Cch3tAH1nNJ8zbRWhjqO6I+Bo6naG+FVW9qSy0NTlPp3ntmUpKTe+cZqcNwPN8+EPHITsX/n/+czX1dG8XgKD4DC0tYebZ06yZY7dX7bOo3w27G+ydg==
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
performance due to lower iTLB cache hit rate compared with the
original THP mapping.

For user-space hot patching, we introduce THP COW support for the
executable mapping. If the exec COW meets THP mapping, it will
allocate a anonymous THP and map it to remain PMD mapping.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Tested-by: wang lian <lianux.mm@gmail.com>
---
v2:
- Fix linux-next build error (call to undeclared function
  vma_is_special_huge()), move it to do_huge_pmd_exec_cow()
- Add a variable 'vm_flags' in wp_huge_pmd()

---
 include/linux/huge_mm.h |  1 +
 mm/huge_memory.c        | 91 +++++++++++++++++++++++++++++++++++++++++
 mm/memory.c             |  8 ++++
 3 files changed, 100 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..8b710751d1e2 100644
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
index 40cf59301c21..ae599431989d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2146,10 +2146,101 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
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
+	/* Skip special and shmem */
+	if (vma_is_special_huge(vma) || vma_is_shmem(vma))
+		return VM_FAULT_FALLBACK;
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
index ee15303c4041..691e3ca38cc6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6104,10 +6104,11 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 
 /* `inline' is required to avoid gcc 4.1.2 build error */
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	const vm_flags_t vm_flags = vma->vm_flags;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	vm_fault_t ret;
 
 	if (vma_is_anonymous(vma)) {
 		if (likely(!unshare) &&
@@ -6125,10 +6126,17 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
 	}
 
+	if (is_exec_mapping(vm_flags) &&
+	    is_cow_mapping(vm_flags)) {
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


