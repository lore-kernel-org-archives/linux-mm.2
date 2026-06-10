Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A9C4CD98CC
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D84C6B0096; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0BA6B0098; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252126B0099; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0981D6B0096
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFA981403BE
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:43 +0000 (UTC)
X-FDA: 84863631846.10.1A7BAE5
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id A20C61C0012
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZG9TAZzY;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBnURwRT3PtluzIttkapBTzpEpviWA0up/dk/97TMVA=;
	b=fWDQ7VaukgVVRBahsCjCTEY2+SYAcK9yf+/vuLV6FeB4/84hMVmtaYr/Pe1f9mLUCLZ+oZ
	JPooXlOcBbA3+cYQOLwwEqwW/RN60NbXQ9EbqbgQXA5ufil2fXycARYxMXLgoIqvm4uM/3
	CLmNQnD9RU/vg6carLy6rc9VbrZyigc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZG9TAZzY;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087382;
	b=HpuRByS3a2YPM6qhIFRxu1OQZOP2tx/bc6aiiBQ3I4SUAa1O/dcc3cLRySkc4ZLacGmT6o
	S+v6ijjlzUwoAc24UI+YrgOrCzw1j8ga8WkRP7zX/16haq3QXTZiJ9pt5iWpI9hRy6SdOk
	byhAVG0iH+EGFFQkla10wiGzPQv7HWc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087375; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WBnURwRT3PtluzIttkapBTzpEpviWA0up/dk/97TMVA=;
	b=ZG9TAZzYXCid/tgbR/iAL/dGLhZGLNXPaIfJ0S/EhvNDRpxjhf5HRePiFqg0qsLSSKDdhUH8dEAIWiK/MAxT6d+dGwcTFTdJH9jTwEJmQxr7+pJKfSk/d21uE7z4DKSSyqW+VWbjj0DVYL4fo2FTRAh5nArME9rzNKsB7DfKTpE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aI8Wb_1781087373;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aI8Wb_1781087373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:33 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 05/11] mm: shmem: run khugepaged for all shmem mTHP orders
Date: Wed, 10 Jun 2026 18:29:13 +0800
Message-ID: <593cc1b1a876dc0f89bb7e3585db7001b44c0061.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A20C61C0012
X-Stat-Signature: e5133q7kw7y47iamuy9aawi1k9bskoj5
X-Rspam-User: 
X-HE-Tag: 1781087379-963503
X-HE-Meta: U2FsdGVkX1/CrjrZkCYbTQ3fUxqJOfQnsMuGOGJnXf6ybhiYeuHdivnR3X4ezxYeC1Md8EPgKVIumVmFyTJh4M7IJ57EjAMtfjC699tQ8WqC6mEuu/PBG4HspIIVLidI53DXGsn7/oz2+JMosBrNNWHzWw5VUd+V7M9XeRNcxII7MLI99UcoU3vyFYbn+hSJ3GTktC+lH1wg6qG2EfMGcM+1Oi8mBqMxa7zp7R9az3uSIEkfQvhbYo5ShgwjZ0WpHLg2t58dAMR1L1GJeI4ngM5SCIOdFoS/yDac8yb4mHBH+DbMR0RM0ylpnyOrr79TMV4xx68APXP23avotu1rT9hAr86mwGNscn9uwPhiUl4OCpeP+QRessQZglI9k4D84mzAhmb/0Cv3FJpEXE2OsY4oMnm11+zbLj1uRA9PoXLBZYJj+2JAwuNe3XhtwsEro5AKO/+XciWEnkhYqqGybrHaaQwgUbiSikiCtzIVxu27/zpZFRbCyUMr/LPKtfgjD67Bh4DB87/wF9V+bwnU5YgK8V+zTKxqAt3KesJUuEdnngKTEe8OFC/QRkK0/TGablvSA9ThvC9OnKJH2RsUWCkBRD9ajh3kBvLlz2Jx8w91+GJCJlJDXCDJq62miIe/o7Bzj/88+v1O7BgYO9UEbAk3vK5lA0JANUOmnNPUkqnrLuJlJAL9dPIC3tWaLc51H2Amc7rknlKhwOwluP0BLD8cgqajOpy3XsrMVBPZ8MzeLG5BP3zX2d6UDbwinpRlzO+oCc3WZ8UXyrw/HKE+HS9TdribsBBGSznoYGL0tMbFu7Sdt+9m5rQJEps4GgF60obzGh8+MvgzsPihiLCY4/4kfYpm1UnE1fdkvBdxfeYoXOtJ69YaC/MOzBfaaEaK37mhDbchIxqFPJF9tzpmgqMoKdCnIljKJRGSZzrvbuFZXkeO3i8ehRQmqE+IAOoRyoND6pbD8rn5wGM6iRs
 SKDWHLO3
 86GuuQ1fNfY7/XdovcQAZ5M9hAhlPhMx7EeEL5Lf4rswrSss4lD7+3RI67CCgMZChi4ZK8RLFXjQZFuT9kZBnboykUde5sPAvX5p5BOHjUIcucak8ysZNonO27CR8nnrtozn8QlrubyFq1V1bQgahLmxl5qX2BeelpeGSu4AjfeXc0/DN6/kxfIoFWKB9UdsJjT7E6Coe2UCNCPmjc3nx3AaNdpJj4xiEl9PddLX76jHh9d3GDhYt7m4FMludQuccYbCL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When only non-PMD-sized mTHP is enabled (such as only 64K mTHP enabled),
we should also allow kicking khugepaged to attempt scanning and collapsing
64K shmem mTHP. Modify shmem_hpage_pmd_enabled() to support shmem mTHP
collapse, and while we are at it, rename it to make the function name
more clear.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/shmem_fs.h |  4 ++--
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index acb8dd961b45..1ec358b40c9b 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -131,7 +131,7 @@ int shmem_unuse(unsigned int type);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
-bool shmem_hpage_pmd_enabled(void);
+bool shmem_hpage_enabled(void);
 #else
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
@@ -140,7 +140,7 @@ static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	return 0;
 }
 
-static inline bool shmem_hpage_pmd_enabled(void)
+static inline bool shmem_hpage_enabled(void)
 {
 	return false;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 818d51915748..75b18ec4a6c3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -532,7 +532,7 @@ static bool hugepage_enabled(void)
 		return true;
 	if (anon_hpage_enabled())
 		return true;
-	if (shmem_hpage_pmd_enabled())
+	if (shmem_hpage_enabled())
 		return true;
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 56c23a7b15c7..a8d30a123b1f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1792,17 +1792,17 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-bool shmem_hpage_pmd_enabled(void)
+bool shmem_hpage_enabled(void)
 {
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_always))
+	if (READ_ONCE(huge_shmem_orders_always))
 		return true;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_madvise))
+	if (READ_ONCE(huge_shmem_orders_madvise))
 		return true;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_within_size))
+	if (READ_ONCE(huge_shmem_orders_within_size))
 		return true;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_inherit) &&
+	if (READ_ONCE(huge_shmem_orders_inherit) &&
 	    shmem_huge != SHMEM_HUGE_NEVER)
 		return true;
 
-- 
2.47.3


