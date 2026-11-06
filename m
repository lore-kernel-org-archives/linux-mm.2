Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE20E606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=4cDnAf9X
Received: by kanga.kvack.org (Postfix)
	id 8D94A6B05B0; Thu,  5 Nov 2026 20:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889A26B05B1; Thu,  5 Nov 2026 20:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2206B05B2; Thu,  5 Nov 2026 20:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 496666B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:39:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BED1DA8C19
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:39:16 +0000 (UTC)
X-FDA: 85402986312.17.31606E1
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF73B140004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:39:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4cDnAf9X;
	spf=pass (imf26.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793929155;
	b=sfuiritir8hOQ9JB3/PnOJDArqwt9hGFQme53ivc/5Z+HKq5i9s4/JDFYz1YNYyLj7SN9E
	f7SbLblxesPvJCHHI4boPYn90jsQt/Mp+aRsDMjbNiRS4ITe7uxm1aI7SennrHR33bV09I
	Jd9BVinr0RMdEj2SWu37f2SIhX0vGxc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4cDnAf9X;
	spf=pass (imf26.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793929155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cCbxTUPPChxKnWhtqlld2Jnw8yL45tSd5lb6BGBKG4M=;
	b=aP0Z4ws5OmW9IQj8aI1ZKwXSLhal+H2AID0+TnmFNDgx8ii81+y6/R4AM9lT5dWEOcLsiz
	Nn2OhDZj0euEHavKTDNY1oTRA5jz4BobLaxZFxivZLZRdBPRmStKx31csIUz3X+FYoCow8
	EcpQM82wAhErmRfkqzR6MplpiczDWs0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cCbxTUPPChxKnWhtqlld2Jnw8yL45tSd5lb6BGBKG4M=;
	b=4cDnAf9XTpg+FNhFaYxxv2WSuIUk216fJTaYCT20EbMXpjeJ9M4Pt65hlPXP7/XM85GWIrl46
	XI1WpHli/qXzlpTQj1vA6m2jsJgRM8+pqIn3QYbuiBeFQ3hkDkp5LH+JkzMgMsFLHmAzoKSFo/B
	Q/8g49RbGEu1gMdWS5Lkm5w=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jLMKL0J5Pz1K9Xs;
	Fri,  6 Nov 2026 09:39:02 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 039034056C;
	Fri,  6 Nov 2026 09:39:08 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 6 Nov
 2026 09:39:07 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin@linux.dev>,
	<chengming.zhou@linux.dev>, <liam@infradead.org>, <ljs@kernel.org>,
	<vbabka@kernel.org>, <jannh@google.com>, <pfalcato@suse.de>,
	<kees@kernel.org>, <ziy@nvidia.com>, <gourry@gourry.net>,
	<anthony.yznaga@oracle.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
Date: Fri, 6 Nov 2026 09:39:06 +0800
Message-ID: <20261106013906.2229780-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: ksbahr51bkex84zfaquo4tw3t5xg4w63
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF73B140004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793929153-176860
X-HE-Meta: U2FsdGVkX1+VR55IF730t/kOP1+KJGvtYHbo+cG1v1YZJPPQqaNGFA/FWBVwefN55rC99qc8AbdaPAx2BAM0qk53jjCGPLEHSAGQktJrFR9zIC+OVEFpGkeL+ijfIZM3WbCQ1vti1bAfdXYhZkCs7PM/YSbHQYC1/jBFlNeahSh44w7+11NpTu4NqS1XW2+hwbTbt+ZNH1WwA4QRBmaE9tZgA+v7zEtX4cz3RzfEncZ7aTlFwrK8OvzPDy8YjvTSJ572WDn9k6MUmyH2lJQnwxkdKfx8+AlYtFQykDvKQh87JcImDL3Hv+4febwq6Cv45l/UM6HZZSCLyTV7lgbVoNrbYZPpAxuNxe1GOu6c9MAI2q8gbGZY922zqthRbafp47tKXrK/OUbIysZG69xy51qolLYAH3MJ75NtVo0aDgSUWApJCimkJwqjH1qUJ6Jl1bZfe4gx503Zm4wnT5lktCWQzxe0s9rebP86oAYuXR8ltEywxkn1UNKBSpp/xBDSjLLPmJ2jr0nQ52rlyJRgsPNTvD34XB0iZcqlDkCnprRyShp+SU9OhZ1WJhl52KEsB3VWM4xMfWszGBNNPdwyd51X1DgEBhA5DIl28nr+Us3Gs1kUK62Kav+e45/NCCNpqqVGzSN+T3K+GNjnxirApXpckKQiQa9wHRlaSLkgXtRlnsGyEZzgbu3/qpMU6XnGh7NsGuKYbjZOZsJKA/FktUbpPD0nM4mu5ZzeHdr5C7TWWFqpNLfU4a6fOjwoNt+4QnWBqdLXT3HWJaZ29Fi/yyWrRPqcoC0UwAqAoye+NQRBxXpUjYpFtkYUE0CUEEFA2M6jLFGpT8rzy6tyiKjmNDq8pLvifAznJOA4+GO34VURLsPuUnigQM26Sbi4rVWXUkX+xXGiscT54voZAwwEalqSmWUnfDilMjI/70gBLZfFOrSCep0Aulw3HfdZSC7GFevloQ2mUo6N6Mmp+ac
 IhuH1qB+
 9kSdsUHtcd1e/96tn95B0zxz/UoTOmBVSPz5x5eUBQb3Ow8SD3FLhQacvF2eKbw9ruuWQWFItIEVTpoZqoPH3RLuxnAyP/YyX6/xtzkShJof6wukea9LLBg4OJszJeVwMQRlY/9EePOps5dCoaxMCRBz02Ka5BrmmHGv51e/37u1b+AqATEqKFwMgc9bjs01odJvaG/dzkm/D0+FAaNgt28gvaY5m4ZkTKVW9SRlq1ly8mWuTMDkNtZyezXU/I9S1En+Tb7FWqyHkyUK9/ZLq8FB4ZN3n99H8mtG5LRAwnqy95bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
while holding mmap_write_lock(), and calls ksm_exit() before dropping the
lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
again when the mm is ksmd's current scan cursor, leading to deadlock.

The early registration is no longer needed after commit 590c03ca6a3f
("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()
calls __ksm_enter() when the first mergeable VMA is created. Remove
ksm_execve() and its stubs.

Tested with ksm_functional_tests, all tests pass.

Fixes: 3a9e567ca45f ("mm/ksm: fix ksm exec support for prctl")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 include/linux/ksm.h               | 13 -------------
 mm/ksm.c                          | 16 +++++++++-------
 mm/vma_exec.c                     | 10 ----------
 tools/testing/vma/include/stubs.h |  5 -----
 4 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index d39d0d5483a2..5e228935cede 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -66,14 +66,6 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 	}
 }
 
-static inline int ksm_execve(struct mm_struct *mm)
-{
-	if (mm_flags_test(MMF_VM_MERGE_ANY, mm))
-		return __ksm_enter(mm);
-
-	return 0;
-}
-
 static inline void ksm_exit(struct mm_struct *mm)
 {
 	if (mm_flags_test(MMF_VM_MERGEABLE, mm))
@@ -118,11 +110,6 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 }
 
-static inline int ksm_execve(struct mm_struct *mm)
-{
-	return 0;
-}
-
 static inline void ksm_exit(struct mm_struct *mm)
 {
 }
diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b189..2e0f894208d8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2777,11 +2777,11 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
 		mm_slot_free(mm_slot_cache, mm_slot);
 		/*
-		 * Only clear MMF_VM_MERGEABLE. We must not clear
-		 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
-		 * perhaps their mm_struct has just been added to ksm_mm_slot
-		 * list, and its process has not yet officially started running
-		 * or has not yet performed mmap/brk to allocate anonymous VMAS.
+		 * Only clear MMF_VM_MERGEABLE. MMF_VM_MERGE_ANY is the
+		 * per-process setting inherited across exec, so it must
+		 * stay set until userspace disables it with
+		 * prctl(PR_SET_MEMORY_MERGE, 0). A later mergeable VMA
+		 * re-registers the mm through ksm_vma_flags().
 		 */
 		mm_flags_clear(MMF_VM_MERGEABLE, mm);
 		mmap_read_unlock(mm);
@@ -2909,8 +2909,10 @@ vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 		vma_flags_set(&vma_flags, VMA_MERGEABLE_BIT);
 		/*
 		 * Generally, the flags here always include MMF_VM_MERGEABLE.
-		 * However, in rare cases, this flag may be cleared by ksmd who
-		 * scans a cycle without finding any mergeable vma.
+		 * However, a newly execed process has not been added to
+		 * ksm_mm_slot. The first mergeable VMA registers the mm
+		 * with ksmd here. ksmd can also clear it after a full scan
+		 * cycle without finding any mergeable VMA.
 		 */
 		if (unlikely(!mm_flags_test(MMF_VM_MERGEABLE, mm)))
 			__ksm_enter(mm);
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 586c52155942..2c644e18b55d 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -128,14 +128,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 		goto err_free;
 	}
 
-	/*
-	 * Need to be called with mmap write lock
-	 * held, to avoid race with ksmd.
-	 */
-	err = ksm_execve(mm);
-	if (err)
-		goto err_ksm;
-
 	vma_flags_set_mask(&flags, VMA_STACK_FLAGS);
 	vma_set_anonymous(vma);
 
@@ -163,8 +155,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	return 0;
 
 err:
-	ksm_exit(mm);
-err_ksm:
 	mmap_write_unlock(mm);
 err_free:
 	*vmap = NULL;
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index f786a585caf0..9ab4e524f78e 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -55,11 +55,6 @@ static inline void free_pgd_range(struct mmu_gather *tlb,
 {
 }
 
-static inline int ksm_execve(struct mm_struct *mm)
-{
-	return 0;
-}
-
 static inline void ksm_exit(struct mm_struct *mm)
 {
 }
-- 
2.54.0


