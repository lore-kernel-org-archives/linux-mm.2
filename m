Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238BEC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87E86B0096; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A74026B0098; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968DE6B0092; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 715586B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6CAF12049E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:58 +0000 (UTC)
X-FDA: 85225527156.21.DA8C5EA
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22E8D16000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tHcGLHPZ;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703934;
	b=Y8rko85hdPGiCoIr5pfqFO2ZNYqM4g7Og43U15/ldBaZAY2H3VyG77RLaxqP1YjT7UCOiH
	MuJn9oMGL0fckNvJTGeuqQTgiHM+9M2hGaEZjyA9UHLeoy20sOeDNLkD+c+CBFh01W51Dl
	IkzNV0f8FTm7lli5Yrclnp2ZJK8mfdk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tHcGLHPZ;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gj7KZoF9VTbSXIKMoovF+7EFs6uTwEiek6buK+yA5uo=;
	b=hm7VSwkaN+TfWS9BlKlg6XpRR1ka1k8FwPNNuxFfezxF8JZ97fL3Krw4kFjIVVdH+p23aR
	uAcFfco5+zBhCVkM4ewG9oTrUPeJSGEyeQUrxTpDz1eFwXPwj1YNh+0vWFNL6eREUcmUGh
	BMS7O4+aTMo3dzJeptEsqXad8Ccbo8k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703931; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Gj7KZoF9VTbSXIKMoovF+7EFs6uTwEiek6buK+yA5uo=;
	b=tHcGLHPZTifGG/dIk72HfKDu2dQ6hugIvvnccpyT2u+zhTq2oVcdjjpYXo82mG66z3HM/xgD1N4Rxb/YzoJcBa/+UrXCA569xzWCbhwb0zlpjluRR1UvWF+uYE3hVdY4qrD2LwB3ze3qhf8xyaPVbaGOZKaPpCvnC/1hVzU+lW4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9o3aj_1789703928;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9o3aj_1789703928 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:49 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] mm: khugepaged: drop the hugepage_madvise()
Date: Fri, 18 Sep 2026 11:58:33 +0800
Message-ID: <e4d6918e2e420a2378e8f8c502ccfbad2a7bc2d1.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22E8D16000E
X-Rspam-User: 
X-Stat-Signature: dppuuk3zyazs7zb7mraqcum4bj9xajpx
X-HE-Tag: 1789703933-171611
X-HE-Meta: U2FsdGVkX19rNMRcPpLWXHNGgYhzFokk0bkuP/mAesugkKGmLWddGqWJnBeb+cBuBejVZupRAUeLI7G3ReF+4HXJJp2U5XEtm5b665tFAxmTQi9zLVqtkZjx3ew26b/Kjyb5OnXnm6r3CfwrsOfvIHFnGb7aa+aBkUiwoKnopex2Kf4k1KuwncUtKgguBVj1ZP0/jDgqh9G/YHEaalVexGX4efYhKiwDJoKdmgRwE1wUbbZ4TsTuBc7xq5KcNroHNJZkuEgGoUFzj/+vPKrtaT+vlyq/IX+E9j3Ep0TZ42AGDCyMYUkIUlLU/o2xromVWX9N1zpYq4i+dnWGHRPnbJLFRyiFGAv2Fe3DgkrS3g4zgyV+KjHaT0iZWmFCtoXD1pzv9NlB5USg6/7JhrW8xoUWnBZZizKYi8KQ8DB70DY483ovaHKMDAMS/Q9NOlai5YjhIzZmrXu4NvKWbvjGUy8p6a1zQWsDxiXY+5NyHC2ZR2Pntkc8GLo48aSjDJ0BmkVU9r+g1IISbM/8asF2z5ULYhbsRoTNkysO1j+fgx3S4iwjNWw2PxZcsW3adkst2UIl5Sjdnjkj6yD1JSiCCX/mYXahv4RVPvPdl4dylgoW16HNJs3GsRXsFwMOSwrRFk5mC3W6cGRsiGtAK/nqdZjTdZbZfiJAmYZ0uWq42VhjrABYXA6zDYErTFts3KCcUCiGyPVr0esDYkg75Ci85Fsvlbt4edk6wcruZIn+Y7NcB/RtniQXCg2HcXjP1eKsoReV2X+ezCnG8aIy4AX9nUjwUwi2xfp863g6htg/mL3TEDr2qtEBVFiYkcaUmdXpzKOFVpb6EzZfZL5a8f5OKTPjzn57uWKv73lNcKqN3YHW636oDbwtynMkwrsD9ruFe2mrmoSLpDQpgW4lPc+pianG2+iuAcWn12WE/HXt+VMxKHaq+w5MaPHUpkUAVaLiRdNHft3cbZeH+dWS1Qn
 ZegkAKjY
 F+WeF92lMT4DqO0qI1nHncNQRa/hKxgtop2hHOGleE1OxtcZuvb4FZshzXt1xfZQ1toi3NbT0APQvPrRecz+Uln+73T2EittCM0bhrNO3w3e/OZGBHQtcyu4p86/zghH400hyJZr1VVM0UkokYuFTHmAWKBxVPKZlalQSoYHumU+wnl0O/2eFtcCfj5FbDCS76jDMRVyVhVb3CsrrorXSTeWYKjuK4GNMBuDS0ZvQCwjHMyc+cRyWVdQQ4yQIdWVBviRg0BDxQGwEVcwqo+9lTqD4n/asXP97JS93ntM6bfCKgwf3gbi/vZhmhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 2fd4e7693674 ("mm: fix incorrect vm_flags usage when checking
allowable orders for tmpfs"), hugepage_madvise() no longer calls any
khugepaged related functions and only updates the VMA flags. So remove this
helper and update the VMA flags directly in madvise_update_vma(), which
simplifies the code.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/huge_mm.h |  8 --------
 mm/khugepaged.c         | 22 ----------------------
 mm/madvise.c            |  8 +++++---
 3 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8ca0fa3be2ac..334c387ad997 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -508,8 +508,6 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
-		     int advice);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 			   unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
@@ -707,12 +705,6 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
-static inline int hugepage_madvise(struct vm_area_struct *vma,
-				   vm_flags_t *vm_flags, int advice)
-{
-	return -EINVAL;
-}
-
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 21d75f5b4b4d..f81ecaaa4890 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -380,28 +380,6 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 	return cc->policy.max_ptes_swap;
 }
 
-int hugepage_madvise(struct vm_area_struct *vma,
-		     vm_flags_t *vm_flags, int advice)
-{
-	switch (advice) {
-	case MADV_HUGEPAGE:
-		*vm_flags &= ~VM_NOHUGEPAGE;
-		*vm_flags |= VM_HUGEPAGE;
-		break;
-	case MADV_NOHUGEPAGE:
-		*vm_flags &= ~VM_HUGEPAGE;
-		*vm_flags |= VM_NOHUGEPAGE;
-		/*
-		 * Setting VM_NOHUGEPAGE will prevent khugepaged from scanning
-		 * this vma even if we leave the mm registered in khugepaged if
-		 * it got registered before VM_NOHUGEPAGE was set.
-		 */
-		break;
-	}
-
-	return 0;
-}
-
 int __init khugepaged_init(void)
 {
 	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
diff --git a/mm/madvise.c b/mm/madvise.c
index eb491fa88325..4150f6a8cf64 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1598,10 +1598,12 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 			goto out;
 		break;
 	case MADV_HUGEPAGE:
+		new_flags &= ~VM_NOHUGEPAGE;
+		new_flags |= VM_HUGEPAGE;
+		break;
 	case MADV_NOHUGEPAGE:
-		error = hugepage_madvise(vma, &new_flags, behavior);
-		if (error)
-			goto out;
+		new_flags &= ~VM_HUGEPAGE;
+		new_flags |= VM_NOHUGEPAGE;
 		break;
 	case __MADV_SET_ANON_VMA_NAME:
 		/* Only anonymous mappings can be named */
-- 
2.47.3


