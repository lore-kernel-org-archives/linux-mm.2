Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EF5CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B1E6B0099; Wed, 27 May 2026 07:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F796B009D; Wed, 27 May 2026 07:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654AF6B009E; Wed, 27 May 2026 07:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58E266B0099
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F9381C1C76
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:08 +0000 (UTC)
X-FDA: 84812925456.20.A39F23A
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id DDB3C14000E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=j6PuxmT0;
	spf=pass (imf26.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/D3Hq7FcaguQsGLfZNTY7RVE4zbG/cH9UzpMbWmWQk=;
	b=FMWgYfPemwafYJHtg5xQ/elyF6Eeu2uiAi9Yug4prv0QXEA+o5jqy+a2VHqsXL9iAMUPjD
	niTyHPprDkD9CTgVck6t8Ol6QrXn+6opkhTAgiqMilc4ZNg2O/mjTIYlkhxim0/F6HK68F
	jNFFfoXfIiaOdcSS2aoVCqfnVP8e61g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=j6PuxmT0;
	spf=pass (imf26.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880086; a=rsa-sha256;
	cv=none;
	b=td4QmQ7A9GqK/Zp+k5MWu+yK6nC9U/s3jjopk4LKk5NxDWKQ6uuYKO+GMTDKTzIbYXmbb1
	zdgeqinY01x0O13xdi1+LNcbd2HqNMeSoo2OWBRdfIP6wvGbj7F5HKHLT6XTzUEISyXH0Z
	y2uQaOBj6cQ0DgNeG5pviIR1b266W3o=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=B/D3Hq7FcaguQsGLfZNTY7RVE4zbG/cH9UzpMbWmWQk=;
	b=j6PuxmT0nB/SvuBB1nifbsqSH66ihs0KrqETIo5mxMj7mFxKHZ1P+hYlUtEehfjRZ1u1tCRq/
	jHjTRLa2cHvCdDJ3NvQz5ky5jztpwpx4WwiI4DyXSArFCA6y5DVIHkv7EAavcWiCFcfQ8I7t9a/
	MpcdBKwc4Aif1G4/JDZDpeQ=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdg003JzYl1Gk;
	Wed, 27 May 2026 19:06:46 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:58 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:01 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 11/15] mm: handle ANON_VMA_LAZY in huge page operations
Date: Wed, 27 May 2026 19:01:43 +0800
Message-ID: <20260527110147.17815-12-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDB3C14000E
X-Stat-Signature: z644dof66m4igf71c9nysb6yn8jpy6u3
X-HE-Tag: 1779880085-64410
X-HE-Meta: U2FsdGVkX1/OPCIaGwiFypQkg2EuFoQMxhSx8oPF1qo++INiSnNgWRPyozXAPRV0gocqLTd8YL7hh59TSq4FLj4v0TQehJTigR4FYQ2qcfOIc5vsZC41BnMM9JqjskoDbPvUem0GkRJFORqBroTz90o+sIN8dIFHbt1X1ECoh90CB6hhn4kPM0jGijLYlfgDvOX3k+efAFYmiIXGoL4qm8XrGCOC8PNVyCRn0ic9DawvOJebsJ8twZJpH5L19Dwmxfika5YWGpy52PT1jfuqR697wNHw+mqwZSpiBxs8uZDyb1DsdUYQ1/x5QZuTxcLi0Syk0RgAwr/6Ydh+lKbVSownwwsYsrZUmLDXhxoHzMh18c65ZsqiGN+4XBqNWfmn8AiBTXxg7iyYpwaXbvZg30TTMmphuKsW0dFktDtel8LLYY3WU5fHssCVkl83svs3pFQqg5izTxH5WCfwdfkgmPk89mxe05XkHrccS38I38LMu2/+n6CPPp5jHbUYYLxSdvGxOsE3GEguzyKEWxZumKyAEF3PZLt/WCIVYRo9X6QBJ5+aZWZ02JwQ/UGSxErMtJHl/nxNVR6DpQVJJiAeysoyz6IlNFzTgaic6G9BUVtP3RVeoKGYRdD16nvPeO4ncVu6F0U5kXhDuP3zzyIvjnFplkU70e5SUnJsRhZGSDS001QVAQxBQBHRNwenpeyncsr01qNNKPwFJVbBGg6aGDJ+7gHQbd8h6F4VZb9N5a2JlmDMUhyJebXBh2lYMRSZdNRrfxkfVVEkm76JO7zfXPFrdOGdUfKFkpkFIosAh0uNbwe8X/W9B6De7dOstADWfNoLjgTw2FyT0bVXYoqcqa4hIDXo1rv/dvwMYLSNXoJguzOqPecAyW3vXt5w6otrdPv5fTdXHwntGCMgqrdmf6YWhbhen7i6YQBSYry+z5wMZgX6TMf+emi5xLSiTQjc5FOA6Mt/AwBc8bqefKR
 EGL53AiO
 rWUTfXWKPggn1uEQH6MLg8Wy7Ky8WRsjC6NGGiqBjoyMnbrUMuIUv1h+2kFWpF9Q9uZKfHYxcnOZ6u9mF2pgFFNpFCQ1G7CZhZb65sHNxF0KcxoR0aXbjnPACyUdjednZdGyOS8cbuCgzx5CvZZk0vXrreB12p05u1JD560oONFZzA8f4L2e6wcXYpBRwdX7wmz0gMDObxSQNga8aCOOypj3a0eAm6pB90asqgJkWmCuXzhhBuAkmjH+021w7aezv3og19BkYTqVIqf23O+pArJr8137692cNpMo9WTzki3o9E1YfL7l4RxsyU30b5S+FzP7BiT9RgqHpJkZP2GQz6K8Rn/JVb3yannXS45xTIV21x1WWFeHBJpEfTL+cFj3V7xtnVM82ajKulL52ZEc/3SPz81z1gkJecdxgtipzpHMPBVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When splitting a huge page, the folio needs to be converted into multiple
subpages. Holding only folio_lock(folio) cannot guarantee that the split
operation completes atomically.

Check and upgrade anon_vma during huge page allocation and collapse to
ensure the anon_vma is properly protected.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h   |  5 +++++
 mm/khugepaged.c |  5 +++++
 mm/memory.c     | 17 +++++++++++++----
 mm/rmap.c       | 15 +++++++++++----
 4 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0a36eba3f63c..a746f5272aa6 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -419,6 +419,11 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
 /* Called on first anon fault or from anon_vma_prepare(). */
 void vma_prepare_anon_vma_lazy(struct vm_area_struct *vma);
+/*
+ * Upgrade VMA ANON_VMA_LAZY to a regular anon_vma during fork, or when
+ * cloning ANON_VMA_TREE_PARENT or a hugepage VMA.
+ */
+int vma_upgrade_anon_vma_lazy(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
 
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 747748eace91..a33cda026be7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1164,6 +1164,11 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
+	/* Upgrade anon_vma_lazy to protect the anon_vma. */
+	if (vma_upgrade_anon_vma_lazy(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	anon_vma_tree_lock_write(vma->anon_vma);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
diff --git a/mm/memory.c b/mm/memory.c
index 8fd3877f69fb..26d116b3393c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3819,19 +3819,28 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
+	bool maybe_huge = pmd_none(*vmf->pmd);
 
-	if (likely(vma->anon_vma))
-		return 0;
-	if (anon_vma_lazy_enabled()) {
+	if (likely(vma->anon_vma)) {
+		if (!vma_is_anon_vma_lazy(vma) || !maybe_huge)
+			return 0;
+	}
+#ifdef CONFIG_ANON_VMA_LAZY
+	if (anon_vma_lazy_enabled() && !maybe_huge) {
 		vma_prepare_anon_vma_lazy(vma);
 		return 0;
 	}
+#endif
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
 		if (!mmap_read_trylock(vma->vm_mm))
 			return VM_FAULT_RETRY;
 	}
-	if (__anon_vma_prepare(vma))
+	if (!vma->anon_vma  && __anon_vma_prepare(vma))
+		ret = VM_FAULT_OOM;
+#ifdef CONFIG_ANON_VMA_LAZY
+	if (vma->anon_vma && maybe_huge && vma_upgrade_anon_vma_lazy(vma))
 		ret = VM_FAULT_OOM;
+#endif
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
 		mmap_read_unlock(vma->vm_mm);
 	return ret;
diff --git a/mm/rmap.c b/mm/rmap.c
index d9424f4eb6d0..57cd85efc50a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -452,13 +452,20 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	return vma_prepare_anon_vma(vma, false, NULL);
 }
 
-static int vma_upgrade_anon_vma_lazy(struct vm_area_struct *vma)
+/**
+ * vma_upgrade_anon_vma_lazy - upgrade a VMA's lazy anon_vma to a regular one
+ * @vma: the VMA whose anon_vma_lazy is being upgraded
+ */
+int vma_upgrade_anon_vma_lazy(struct vm_area_struct *vma)
 {
-	anon_vma_tree_t vma_tree = vma->anon_vma;
+	anon_vma_tree_t anon_tree = READ_ONCE(vma->anon_vma);
 	struct anon_vma *parent_anon_vma = NULL;
 
-	if (anon_vma_tree_is_parent(vma_tree))
-		parent_anon_vma = anon_vma_tree_anon_vma(vma_tree);
+	VM_BUG_ON_VMA(!anon_tree, vma);
+	if (!anon_vma_tree_type(anon_tree))
+		return 0;
+	if (anon_vma_tree_is_parent(anon_tree))
+		parent_anon_vma = anon_vma_tree_anon_vma(anon_tree);
 	return vma_prepare_anon_vma(vma, true, parent_anon_vma);
 }
 
-- 
2.17.1


