Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87BB2D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF83C6B0012; Mon, 15 Dec 2025 07:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA85D6B0023; Mon, 15 Dec 2025 07:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5666B0026; Mon, 15 Dec 2025 07:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD7406B0012
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 562D91401AC
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:38:49 +0000 (UTC)
X-FDA: 84221659578.15.2577612
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf21.hostedemail.com (Postfix) with ESMTP id 74A2F1C000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:38:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ozeGgroW;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765802327; a=rsa-sha256;
	cv=none;
	b=4wtNh+ZkBVxm2N7midJ7N5JTAGR84kuEWbu+4FyfbA23rdj4bTIp3aAc+jH279bgQ/+j7r
	iFTl7PHxyeCg1y2020UY0ATYwVGXvQiBsonJh9BazyiXhA8XA86qFsokmmtTKnTC27MbM7
	1FxiEbavhqCoiP8qxgcOV9EySB5KfYo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ozeGgroW;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765802327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AW0l/Uli7Z07C+DpVlWxg/EIyCazK8znY5p+Q6tLPn0=;
	b=sJKYUT3Fhe0jJztS3FgHRB8RUr4FoSsnrJxLDHBk6x+f0vV6oE8V6TM+iirsGyf/P6QqBA
	uDgxzi4VnceOz+wPOtZh5JmLXicaBTxqyiynhucy8DqlT81Hg83lJG1GImnk7TJIzJXYsg
	8mluw/pM8opNmvYfOcwo16of9tT1jdA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AW0l/Uli7Z07C+DpVlWxg/EIyCazK8znY5p+Q6tLPn0=;
	b=ozeGgroWgPskKUtF699HnhH+rj4mHe42UZ73V00jt0OMbDT1tWCo1K+9+9GSu/bCaWRDBIVNT
	wHk+RfvFSJFceTqwv32x+f+W5XvZUk4XFanapN7yf3VtMbWvznEaC6K5VM/9rSVRGWRZTDwiGNx
	3V0I9rHzxUAfSf4wb9J5OwE=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dVKLh3NBCz1K968;
	Mon, 15 Dec 2025 20:36:44 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 5ED061402C6;
	Mon, 15 Dec 2025 20:38:42 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 15 Dec
 2025 20:38:41 +0800
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
Subject: [PATCH next 2/2] mm/huge_memory: Add sysfs knob for executable THP COW
Date: Mon, 15 Dec 2025 20:34:07 +0800
Message-ID: <20251215123407.380813-3-zhangqilong3@huawei.com>
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
X-Rspamd-Queue-Id: 74A2F1C000C
X-Stat-Signature: g1joygo5i4cosnrqauq6in53zrry3rwe
X-Rspam-User: 
X-HE-Tag: 1765802326-544045
X-HE-Meta: U2FsdGVkX19RA0sMpslzKNEHIKuFbvdzz92Nj2DO6aIRk+R48r12TmrpHIrd0vnFOrsBxlNP/O7MdaeMX1bbyuHWMl3SsHNitGweol2GtiwDCEoj132Q0SuLSSLlJn2p9TkOmugW5/L5TXERKnVz0F5l63paTpiLApKClkPiABkG2pkAHhW1qCNEzXvIowd49eRt3CvcoKDOjHrwuNUe/8FnI1WNetZFiw9Skc087Oo+A5cYBgc9uwLdOYEEqNDOuwqkHKQTfXQxttkMk01Xski/mrG9gyii82TiHgOWI+zTS5e5i1K4oP8s5gyoPipYoqyZJzQrM7QykOtDOX7/8gxCuXHdozj/E1VHOZbHN+cXc6MVNrppHvlq3S2f8o/dkLtavnyLkmfgxFLgzVJiCQhXmbNbepmGJWNBfG1iRMoMH+gdzHErhmM3VhGTfwPBUFNf8xWShXWmK0mzRGPAMo8dztbCJeKdVF86QkWgf4VkS/R/6m84hmnu8hb8lJXL1EYb1U5X2iBgYycGoDFsCDpL2lKuvnsHkvkGURX6PrSkd1ZilfUbPn043ZDRIMvkyhHGHOrXqaj1FDmhatXZEHmD+I66Yk/tTEbFnmCSxltLE3ae4QBda/Ah0pdzag4eno6qhpcVDNFM5s1cZMyeCFjcyJ/XF0gMALklJ7VwPmaHyc6jgAZOX35oqUA0Q70q5OdakPYrRJzjBQfelsMWkvbxUwNiGgzBjJsDXgsYXpGe094fKz7/E6Q5sWT+BMpZCQ6uE630uSxTu5eU9h7rpwpr+a10EE3DceBvyQPzy8y2osoqDSgztTi2ZJAkzXnzSAyWpSbIKT7IpMiwgo7zKZwS72mSaWVc2LEumXhPi+Zte6mSJWZrO2H5c2ZDkgQXtDZw3IzppFO+dgi1BbDuxTA01cFawY5j5Es+LpppztiP78/TlmRM9p6UUf7vaKHbejIq6ISAfkhSXddbTXn
 KyJr8TOj
 /YtyqPzM5WMRWnKw0BZnvzLu/1TQbjojT10nVEr40fbKnasfpoVnvRtbKnrRox/ZBzXIU2FuMOqq8SNgB5Hn8+Xxq+2JGDGt0xpZW23oSOFLhqeVLhMihGyffzx3FsBIow/E/hL7O+MjHP8jvVLIscnYcAJEHG5YGpD+Abilj6t8BVCYb0xvy8snS/d28hx091fxyLI0QmV2BvloxjlEL38lc1Bx3In3L+JgzK0zwCTif3hyBFwoqwd5shFO1xP8a55J6pdKwTkbblXoO5HDuVDh1h8IH2egwlfgoNsExCNqRpbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Although THP-granularity exec COW can reduce the number of faults
and improve iTLB hit rates, but after enabling it, the THP folio
allocating and copying operations may introduce higher latency,
and it consumes more memory compared to page COW handling. These
side effects may be unacceptable in certain scenarios.

Therefore, we add use_exec_cow sysfs knob for THP COW of executable
private file mmap. It's enabled by default, kernel will try to
allocate PMD page and map it. If it's disabled, it will fallback to
split PMD mapping and do pte fault handle.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
 include/linux/huge_mm.h                    |  4 ++++
 mm/huge_memory.c                           | 18 +++++++++++++++++-
 mm/memory.c                                |  3 ++-
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 5fbc3d89bb07..c6d7ca045c03 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -201,10 +201,18 @@ page fault to anonymous mapping. It's possible to disable huge zero
 page by writing 0 or enable it back by writing 1::
 
 	echo 0 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 	echo 1 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 
+By default kernel tries to use huge, PMD-mappable page on private
+executable file THP mmap fault handle. It's possible to disable
+THP COW of private executable mmap by writing 0 or enable it back
+by writing 1::
+
+	echo 0 >/sys/kernel/mm/transparent_hugepage/use_exec_cow
+	echo 1 >/sys/kernel/mm/transparent_hugepage/use_exec_cow
+
 Some userspace (such as a test program, or an optimized memory
 allocation library) may want to know the size (in bytes) of a
 PMD-mappable transparent hugepage::
 
 	cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bae856a53e1f..d86215f06ac9 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -55,10 +55,11 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_USE_EXEC_COW_FLAG,
 };
 
 struct kobject;
 struct kobj_attribute;
 
@@ -323,10 +324,13 @@ struct thpsize {
 
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 
+#define transparent_hugepage_use_exec_cow()				\
+	(transparent_hugepage_flags &					\
+	 (1<<TRANSPARENT_HUGEPAGE_USE_EXEC_COW_FLAG))
 /*
  * Check whether THPs are explicitly disabled for this VMA, for example,
  * through madvise or prctl.
  */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 35ecd62f64c4..430b80318aae 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -63,11 +63,12 @@ unsigned long transparent_hugepage_flags __read_mostly =
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
 	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
 #endif
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
-	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
+	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG)|
+	(1<<TRANSPARENT_HUGEPAGE_USE_EXEC_COW_FLAG);
 
 static struct shrinker *deferred_split_shrinker;
 static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
 static unsigned long deferred_split_scan(struct shrinker *shrink,
@@ -442,10 +443,24 @@ static ssize_t use_zero_page_store(struct kobject *kobj,
 	return single_hugepage_flag_store(kobj, attr, buf, count,
 				 TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 }
 static struct kobj_attribute use_zero_page_attr = __ATTR_RW(use_zero_page);
 
+static ssize_t use_exec_cow_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	return single_hugepage_flag_show(kobj, attr, buf,
+					 TRANSPARENT_HUGEPAGE_USE_EXEC_COW_FLAG);
+}
+static ssize_t use_exec_cow_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	return single_hugepage_flag_store(kobj, attr, buf, count,
+				 TRANSPARENT_HUGEPAGE_USE_EXEC_COW_FLAG);
+}
+static struct kobj_attribute use_exec_cow_attr = __ATTR_RW(use_exec_cow);
+
 static ssize_t hpage_pmd_size_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%lu\n", HPAGE_PMD_SIZE);
 }
@@ -475,10 +490,11 @@ static struct kobj_attribute split_underused_thp_attr = __ATTR(
 
 static struct attribute *hugepage_attr[] = {
 	&enabled_attr.attr,
 	&defrag_attr.attr,
 	&use_zero_page_attr.attr,
+	&use_exec_cow_attr.attr,
 	&hpage_pmd_size_attr.attr,
 #ifdef CONFIG_SHMEM
 	&shmem_enabled_attr.attr,
 #endif
 	&split_underused_thp_attr.attr,
diff --git a/mm/memory.c b/mm/memory.c
index e282adec9165..5e3354e16b32 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6134,11 +6134,12 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 				return ret;
 		}
 	}
 
 
-	if (is_exec_mapping(vma->vm_flags) &&
+	if (transparent_hugepage_use_exec_cow() &&
+	    is_exec_mapping(vma->vm_flags) &&
 	    is_cow_mapping(vma->vm_flags)) {
 		/* Skip special and shmem */
 		if (vma_is_special_huge(vma) || vma_is_shmem(vma))
 			goto split;
 
-- 
2.43.0


