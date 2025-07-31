Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EB7C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6816B00A0; Thu, 31 Jul 2025 08:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8772F6B00A1; Thu, 31 Jul 2025 08:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766306B00A2; Thu, 31 Jul 2025 08:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6149E6B00A0
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:25:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 191ED1A0285
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:25:15 +0000 (UTC)
X-FDA: 83724479790.30.EAC43FE
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id C202120005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:25:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=wtILuflVGKfqyHfKCO/nx606fmA1mgQb5EUCDXGU1oc=;
	b=I+/hzFAgVjeTauN2iTPCo9urtCpsmFrnSgoE7yzLjMAJtsNzszea34IwrzHG7yzw02q2FF
	Lq39Oxd+spP5acuWEU+8J2nu+Md4tKtdOrjMs0aAuzqnXKoiN71srBILzUZ87U2r6c6Wcj
	VT5mdQUrlcEPU+zCJVLdEJTy3j1E8JE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964713; a=rsa-sha256;
	cv=none;
	b=1Rpa7zJ+XtQiiJrZSF+mUX4SI1vj195Vbyu6NDaIY91Ttc5Y2znz+hty6L/zRB7Gt9YFb6
	vZJ71we5hKGZjFTsJhtMd02Bp0vvisZcHPDj1rteFID8c4XQj4/28OLM+yitIVTfpx6ZBK
	JCsg7pxLQUAlT1GPj6Pk6ja4wlfyI5c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bt7Td12hlzPtBZ;
	Thu, 31 Jul 2025 20:20:53 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 3400918007F;
	Thu, 31 Jul 2025 20:25:07 +0800 (CST)
Received: from huawei.com (10.175.124.71) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 31 Jul
 2025 20:25:06 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>, Zhang Qilong <zhangqilong3@huawei.com>, David
 Hildenbrand <david@redhat.com>
Subject: [PATCH v4] /dev/zero: try to align PMD_SIZE for private mapping
Date: Thu, 31 Jul 2025 20:23:05 +0800
Message-ID: <20250731122305.2669090-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C202120005
X-Stat-Signature: kikfirbdaoim3pstgjtzbnwojgf7fnes
X-Rspam-User: 
X-HE-Tag: 1753964711-909881
X-HE-Meta: U2FsdGVkX1+H5WMKIC2KXMrXmaSOy0XQiurXnJW49CY1LmiX4JVLWLtr/f4V5p6VZ0sHF0URmg6Xvmw373ZDTnrkLhARhVywPy/l1rMCgd+dRYO9aL66qZiOQoPHSQwjEFH5/tug4jgWdcAXTBwZ26Hc2aResBxF79m3OH1w/yXoXSKq81HgUQqV2/b7dnEQQd6z6609reTz5uUoP3swsAa15FEq1g8JESzxP2Z3HApli0SaKhv2HbkjWKtHcfO2d+IeJDXgw/Lv7za/Am746A3mtpbQOekVoP2gU/uOFQmGMDs7H1ZHEY9zlXFT0FoDk1NhFu6d9b/XM1gidYkxJgCZbwHn6XY8lmLG4AUT9NvwyMWeq6jTYG175xEW2QHABjNUcaBbo8K9CZHUsGugOdfWuzyN8OPJ9OGArf6rpB32AEC3vrKrDc7jlCHfk2Axsj2D/hD/gyiQr7bFE3768Nx97oq6UfJhP/W2z8XMl7qixtbX/XH4I5FnFn4nCWxtlL4I/cHD8sgxK+qZov/M2yTlizq6jfi+TovxMDZpVwjjjlgSIcLh9Aq2ok4CQnvAbTv3fpmA2+Q3Tu/xji72AgX32HJXYFAOPSsXXmZta7YUfw+0Uw/44kO0rI7qsVlBbh/+hU/7L2MyIXjEbUIOUStsPjUZeb1iOLhNzoiZOjyclFFV84a5fyXX/dnp0dwYqal3HF2MKAzuCTbCsfb8VRW+LQWKgUaMQPU6vGfnIv1+ksbJeLKjP+VwmQ7nqoRrRjJrKuTj6RpDrkmqfqYFaQ7PyeEMEsm4Mxtxf4QmN0X1V3CV2fYBzhl1uODjCHrIZwoFV1SKNcwYKKD0F9CVwzpEko98EFVbrG/RrURVof66Z6XvjlU1851fUavanxw3rUKO6FWgeKZEAcWquw84GULHRztDBNNJ0beBuQi5baq+cUhIRjGK3p6kdwHlvfeN+TfrBQkzkt0gDr7Wn8g
 u7p9C1RJ
 ge4SjrkJJuAuqzmfUueR1E4tvXHpzTL+GJw8T4AZmlmF5meuhB4YQVrph7Pu9Xg/HBVxfjarj3xzC1OUDcC1bepTp340lddnkSweki3sz5uEd+8+6bJbQ5xptxtIvn9hCi1DASx0OFf4lPoc9Id4PovBXOKPXHB+oUDi3nNRsS4JG25r0I0QLGtlnefHVgMLuAlx4TKTnxeSI9crdOvOsBt+YxsAIT3q/l/1NOQ22FA25rYGG2lU1iKXx9yo4BoxwazjSfrjgAX1aGG7Fd3nNVJLJartxFxvJIAn4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attempt to map aligned to huge page size for private mapping which
could achieve performance gains, the mprot_tw4m in libMicro average
execution time on arm64:
  - Test case:        mprot_tw4m
  - Before the patch:   22 us
  - After the patch:    17 us

If THP config is not set, we fall back to system page size mappings.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
v4:
- collect Tested-by and Reviewed-by
- add comment for CONFIG_MMU #endif

v3:
- collect Acked-by
- factor out the #ifdef CONFIG_MMU in get_unmapped_area_zero(), per Lorenzo
- explicitly use #ifdef CONFIG_TRANSPARENT_HUGEPAGE, per Lorenzo and Matthew

v2:
- add comments on code suggested by Lorenzo
- use IS_ENABLED to check THP config

 drivers/char/mem.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 48839958b0b1..34b815901b20 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -510,31 +510,44 @@ static int mmap_zero(struct file *file, struct vm_area_struct *vma)
 		return shmem_zero_setup(vma);
 	vma_set_anonymous(vma);
 	return 0;
 }
 
+#ifndef CONFIG_MMU
+static unsigned long get_unmapped_area_zero(struct file *file,
+				unsigned long addr, unsigned long len,
+				unsigned long pgoff, unsigned long flags)
+{
+	return -ENOSYS;
+}
+#else
 static unsigned long get_unmapped_area_zero(struct file *file,
 				unsigned long addr, unsigned long len,
 				unsigned long pgoff, unsigned long flags)
 {
-#ifdef CONFIG_MMU
 	if (flags & MAP_SHARED) {
 		/*
 		 * mmap_zero() will call shmem_zero_setup() to create a file,
 		 * so use shmem's get_unmapped_area in case it can be huge;
 		 * and pass NULL for file as in mmap.c's get_unmapped_area(),
 		 * so as not to confuse shmem with our handle on "/dev/zero".
 		 */
 		return shmem_get_unmapped_area(NULL, addr, len, pgoff, flags);
 	}
 
-	/* Otherwise flags & MAP_PRIVATE: with no shmem object beneath it */
-	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
+	/*
+	 * Otherwise flags & MAP_PRIVATE: with no shmem object beneath it,
+	 * attempt to map aligned to huge page size if possible, otherwise we
+	 * fall back to system page size mappings.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return thp_get_unmapped_area(file, addr, len, pgoff, flags);
 #else
-	return -ENOSYS;
+	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
 #endif
 }
+#endif /* CONFIG_MMU */
 
 static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	return -ENOSPC;
-- 
2.43.0


