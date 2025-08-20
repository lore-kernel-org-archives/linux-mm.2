Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E77CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE79D8E0042; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A985E8E003E; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A0A8E0042; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4698E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22AD21178C4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:48 +0000 (UTC)
X-FDA: 83796558216.15.685BF20
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id 214FEC0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rSszCfJ7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680866; a=rsa-sha256;
	cv=none;
	b=m7+5oyn9ImvP3ltAoiQtmXgnWrZuzIiQY5oge0uqHvwHomQV2x2rABeMIAyHip1V0rtX8m
	MgMTl0mvTE5iINoegqarcs9x0W7MMj/QJ8DTwBnNlnad8Gb8+8JVGltdUyb3ijpXK04ldT
	8ykGsu2QU4e+TNXL02NxIeONC+CHIWA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rSszCfJ7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaAWoBis1OZYy09ndtQ4e2rlen5KUPlGbetwvB7igCU=;
	b=fc4Pi/pzicgQSyCq38UMOgP1fhPvJtUafnoHwl0+tb3TvehILXopttTvZAQ40NeGhRW8Vm
	GkLTzptDevEhXSOjdGxwM3/6PYATrlRMX6AGdjwLBUwIKORaVCsYtuaqRpJUDtezbhv4uy
	GXvy7PIJVfhhniItEWmLBZumY2NkRHY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680862; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kaAWoBis1OZYy09ndtQ4e2rlen5KUPlGbetwvB7igCU=;
	b=rSszCfJ7w1qr54KhnJDBYzPRhFg46idvrmPZHnCGp7gMZMzncCJVCm/4vKD+YqarD4hww44IfQflnCog9UhXu0+r9zrgrWblUsrE7wnV/+7Ot7QTfCIPGzADII8jkzwqJkSLpHatsvcsEIZmrQARByUZ9VNXhBGmLDqpOqEQOVw=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBY56L_1755680859 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:39 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/11] mm: shmem: kick khugepaged for enabling none-PMD-sized shmem mTHPs
Date: Wed, 20 Aug 2025 17:07:16 +0800
Message-ID: <7c8ee99eb146a9e8abd20d110cb591d33fa1ebae.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 214FEC0006
X-Stat-Signature: k5d7bq387h6dhsq973mrnm58cdo1m58u
X-HE-Tag: 1755680865-862390
X-HE-Meta: U2FsdGVkX18Wc2coBXhrpXLhs7aJa7uN8BTVky6Ae01Dn5VvNQ9JLcsKPxxb0mpXfhfqHzvl/fCVdDbMr7zFiu9ACuRZrcilbyUQK8oMvKd4Nj4BBNutih+F8eEVREGxWHoOIY1MNQ1nBcgjh7Pq+DH0yXbOdByrcWwWAVWUv6q50hi1MDp9o3STfUFIRUUyIwwnRHiBMeocVmeeW7wEW4UVdrP0gty6cr1xqrift167F+Zbd6mxBUm3cFjdwSexGTJQLeQkiYXHQMyjh//6sN2rs7EwsfXC6mLioXA1M9RdRdLCqjtav5UwmZPCRKY6ELl9lmF414VYsPjQq2veN3IMRM3dD9lHDwLDK3u9YkmNIWArbtVWdJX8BquTrh4DfeduLjBpr1oh8EExr0Q1Nx3tVan0II/PhqkUbh+Umf62V1CoYSW7biGmYd8yFsfA3TMB/dBOfsirpHrrd0KDHgVgja0Nk+tXxxdk9tfZ8OYRiRipSnghqeqqEjSP5IxZ3kqUKpQR6JfepgCahq8pes4crZlGjSLmvRyRmH2y0GFZPS8iKb5I2cyL9KCvOD2ojXtf+xoaqnC8FjPt2IBufSGe5pVoj7sEfbLXoYZR6hQvJqlCVhOTgb4a3CqE9mMnmBH33GJJypsZThovmd2d5G2BGEV0AqSyyXOm02Nmrb0QXAcrxL1GHU+DJ71xiy0qK7d3wMEJxfLS0m0sZ1g0xDWzDQWA/XNwDju4HyhAlcJXXDF2md3iUuQmyyCLMaSSpg6GUVJZsHAlGr5Q5sgPKV2zWEI2wW3flwhNsvpYwk+k+9GiC0Is/2Hid2z5u0rSG5+qu2cO0CFqGlrvxMumcPMpVI/yWrHynqtvmOFxTACwllgRMyFIsMuM4BpVXiNSuY2HQ1zKT9MIJUoDL/4fppPM94Oluy8cPkhhARdSnnTj6NZUSxzWJ9y3tJ/OntZG+FvKn+WptTKp5F/tpO1
 OVzniK77
 9/pbdbf96cVCHg1nE7rPS4S0gTUQ5sZo/w0QOeFKOG/7p3kG52Pdd4dzKnl/U1bM/V8stAIY0Bmv7JACvttHBpLikddNkOMgUws0IcGjfHqWr94RLw6K90QhASos6r+sZm3LDaPIlXNvaWInKVPxzZeXwyaongOioIyjew4D5kD+yz1ccguYBidYxT/LasUsg8y+nmVzcScD5+XWjfTlP6SpTd8L0VxeqfHo4P+qS0AyVeb7MUge62yp2vyi+4VYGOCIrlw0zyyouLza0wkBsEwY+Bte6zlCJ7Tpz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 6d0f9c599ff7..cbe46e0c8bce 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -118,7 +118,7 @@ int shmem_unuse(unsigned int type);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
-bool shmem_hpage_pmd_enabled(void);
+bool shmem_hpage_enabled(void);
 #else
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
@@ -127,7 +127,7 @@ static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	return 0;
 }
 
-static inline bool shmem_hpage_pmd_enabled(void)
+static inline bool shmem_hpage_enabled(void)
 {
 	return false;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 53ca7bb72fbc..eb0b433d6ccb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -453,7 +453,7 @@ static bool hugepage_enabled(void)
 	if (READ_ONCE(huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_enabled())
 		return true;
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 13cc51df3893..a360738ab732 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1791,17 +1791,17 @@ static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
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
2.43.5


