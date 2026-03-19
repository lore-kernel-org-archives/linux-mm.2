Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C84BFB5EAA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB726B03C4; Wed, 18 Mar 2026 23:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA38D6B03C6; Wed, 18 Mar 2026 23:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91936B03C7; Wed, 18 Mar 2026 23:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 966186B03C4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:24:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47F0BC1781
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:30 +0000 (UTC)
X-FDA: 84561369900.17.8453340
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2578E180006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:24:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mKUk+6SK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jNODp3wp4DROUhBG8kpRzhyFycKpwSYO5gu6salJm0=;
	b=sJqy4yepngJqmIYGaIEgf+1mZeZPEMXUb4hyYWJ3nysvsZIB1mz91d4UKhk85xhMpvXO7I
	YS8rvLdStWlOeHNJjjZhXJUgl0+vTv9CaVXFo7wT89zwdNuWqcWguB8U3k4LQEjbjXrnGh
	IUxDAQr9+j3i+NEj6N/X/kR48n8ZL0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890668; a=rsa-sha256;
	cv=none;
	b=VO6muG1vc/DdPtYIMjZBaKZcoUKbLcsdVa18wADZTqKCJpcG/lgmyjZTO5MuXxhNUjjCBl
	YhfWlmtAgIagGy8uV/V76wNwxJDYmB4COuUfIaJh7q2JaAt/oiscwsaZ5wKY7UBhsc8tHM
	rfJUugxFslba1dTSDTSyk1juR3Ts+Og=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mKUk+6SK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773890664; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6jNODp3wp4DROUhBG8kpRzhyFycKpwSYO5gu6salJm0=;
	b=mKUk+6SKDCmmeY5Q7msKhu32EuxcZIg+i3WeXd1dfUG8kr7ct97KxQns/EDjbVrajl2/LKJK3Z1FADZhzCTMK2KFsjXg52lYG5n057qbg+QaBRIo9ivzWokvw+pX+rGG60vB/yO7xO2whPoCkCPGLUjMQP1vexIOMDkc2TGj8W8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.Gt-DE_1773890662;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.Gt-DE_1773890662 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 11:24:23 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org (open),
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] mm: change to return bool for pmdp_clear_flush_young()
Date: Thu, 19 Mar 2026 11:24:03 +0800
Message-ID: <eb513ed809685f78e0abdeb7f7b6ebdec0fcca18.1773890510.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2578E180006
X-Stat-Signature: 3oztpb33ip7ckfr6ptyezcqr4rj7afrb
X-Rspam-User: 
X-HE-Tag: 1773890667-79187
X-HE-Meta: U2FsdGVkX195cyhWskaC/ck0lW0Pp4yq4pOZJHTQyf1jYvrBmsWj8AGfbE98YZhS4WfPX7lUmVC4pS74WbTVIplhRPeb2JZAvm/Cst7+M8BkfpdSwD/UOUT4+jl/VwCoDj93O4RlGwrV0VtI45vfOP9jJjPuE+N8JmdjSp5ijuGSJfP93tR1kAu97pe40mDZL2Jw1eiGU8Kvt5p4Osec0zLKhHr6/mXRER0IjxA1JfsywFRs9tPgfH+1Dui5bF2FUbtTQRr5b7JeVKK2A+6sjrWDQPiz0lZErU+pQwYqJBhLXWue8BR6ylSPD+y6bHdQ3+bR1V8enGy3Y3Y9KbmFVaw+0GqAnrwfnzPPHjljBZDb/RhQ9IylPKMxQ3gLudkN9/TA/ZZ69UXlgAzdY5rQj9/9liQ3dFP6vFdLzdRsOD+b2T4iYbeUZ3D44nOhKhl3/JbYrpI8SVIpwubu0gqhahguSFjUfmMS946P4TibZV7fszSCthoNM1Cz0wzdv94QxxHIFmgi4NSGisghX2OZuhquLkid81jaFCvYyAH3Dn+wi4VxVHO2xA3ek6TA5SljF+Sceh+T8nEONl4wcxLpes96r0L018T/1tzrV6WL9Hu7HkEdMfkbzwWzlHMgtbH4dAZxjERIrBneXhlSq5avqVz0hML+1ND1y8NYoahSpWnUZtEZAiJdPcs6SrnCsvy1Vuw+844k9Hig37sJXdgGZKBdtABBge0EL56KMyGDmDcGpwmIrYR8/+jLtFbr8KYjKzmEeNXPUfhbnZQWcCJ2P9gjt1vkdUrzERCkXuqWn8nu18wiGw5dnrQn6jcHum6AxjqYOrPenrxyt/jt1q+P8Gq++s/LZL2XJ1cIn5faReiPcyR67V1UEdxWOmGIP/p/5zNkbqUA37Bs7WcZYOd19tYC5fTG9NNw2nx40pgz/Zvh2FAo2AHkncE7DSi5AIuZfwsDRhLgkvJinGuIEna
 iJJyP3pe
 lbxHNL4Q81scLEvdAVsMu7PA3C8zXYwkj1FfRe1YUxCoJMoPJRIQVv7ZNMgnpO/I4VYFpgngkjSRkpwQO4AE82Lk2DxKcS4bw0eBHrZ16jqEaQqqrOsNCkTt57lwPyd8g0iTZSQDe7jqRF92m5z5+88brFyDBvnZ0OLjIYpVcVvvNDjVofQeX9i9RYaKYzCorGaJJnXqr8gFuldNwcnlTpDsu7J8BzRCpkW4b0uZFakFyZsoQZmFR+4FLsn821oLovEVT2S3wEtxFAaNRgUoMH6Kp5CgdCVKqohcECFz9IVUJzVCrD95gaS6mV9Kkmby6WHx/P7JEvVMUeHqiwGY7rDaUqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pmdp_clear_flush_young() is used to clear the young flag and flush the
TLB, returning whether the young flag was set for this PMD entry. Change
the return type to bool to make the intention clearer.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/s390/include/asm/pgtable.h |  4 ++--
 arch/x86/include/asm/pgtable.h  |  4 ++--
 arch/x86/mm/pgtable.c           |  6 +++---
 include/linux/pgtable.h         | 10 +++++-----
 mm/pgtable-generic.c            |  7 ++++---
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 1f5efb7be71d..90bba85ca4b8 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1693,8 +1693,8 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 }
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long addr, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+					  unsigned long addr, pmd_t *pmdp)
 {
 	VM_BUG_ON(addr & ~HPAGE_MASK);
 	return pmdp_test_and_clear_young(vma, addr, pmdp);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index bd02ee730a23..f9439449c9bd 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1301,8 +1301,8 @@ extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+extern bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+				   unsigned long address, pmd_t *pmdp);
 
 
 #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 10a5e0b2be36..8c336edf0e65 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -503,10 +503,10 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+			    unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e53220b0a9a3..8b8838f19af3 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -536,18 +536,18 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
-				  unsigned long address, pmd_t *pmdp);
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp);
 #else
 /*
  * Despite relevant to THP only, this API is called from generic rmap code
  * under PageTransHuge(), hence needs a dummy implementation for !THP
  */
-static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
-					 unsigned long address, pmd_t *pmdp)
+static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
 	BUILD_BUG();
-	return 0;
+	return false;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index db0ee918b08a..b91b1a98029c 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -124,10 +124,11 @@ int pmdp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
-int pmdp_clear_flush_young(struct vm_area_struct *vma,
-			   unsigned long address, pmd_t *pmdp)
+bool pmdp_clear_flush_young(struct vm_area_struct *vma,
+		unsigned long address, pmd_t *pmdp)
 {
-	int young;
+	bool young;
+
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	young = pmdp_test_and_clear_young(vma, address, pmdp);
 	if (young)
-- 
2.47.3


