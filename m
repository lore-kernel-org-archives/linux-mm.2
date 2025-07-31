Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CFCC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 08:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54976B008A; Thu, 31 Jul 2025 04:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C6C6B008C; Thu, 31 Jul 2025 04:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969666B0092; Thu, 31 Jul 2025 04:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 821E06B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 04:38:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F312B5A283
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:38:23 +0000 (UTC)
X-FDA: 83723908086.22.558FA6E
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14284A0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:38:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753951102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=fgbKQXt0aTnTjACwPCtjF03PBrVGPY0jEJ7fUHExZz0=;
	b=nBRpbIkz7HFfIuzGhhglgx0+on28VHixqkGe4w0N0coT2jMIspP4VxXMGrXoGf1p3+x45Y
	JpqjfDl7Z7DW+4zd7gGPsB3CEFDzNjs09jb9v3Pq9J/Ve9Ay+vFhThiKk9XmhsybTsHpno
	2NurjzdW/nEETDc44J+TLL+7QVl5GKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753951102; a=rsa-sha256;
	cv=none;
	b=6fsLg5n2qEyNTv5vgk291Wc54LKCijsY0wGa839PWg1mS7+nMsUBPWzu/ImUOhy9KaBZSJ
	aNo8AeUg+MPEHEsRQIiA6VqeIjra2WPraE3mXVKsHfu7SLR97LlJ6dDc6Tk/ry89We9ynm
	1gSJLcZc++my9ad6jy67UJhIqK6uvI0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zhangqilong3@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bt2V15H6Gz23jd5;
	Thu, 31 Jul 2025 16:35:53 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id C78091A016C;
	Thu, 31 Jul 2025 16:38:16 +0800 (CST)
Received: from huawei.com (10.175.124.71) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 31 Jul
 2025 16:38:15 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>, Zhang Qilong <zhangqilong3@huawei.com>, David
 Hildenbrand <david@redhat.com>
Subject: [PATCH v3] /dev/zero: try to align PMD_SIZE for private mapping
Date: Thu, 31 Jul 2025 16:36:55 +0800
Message-ID: <20250731083655.1558076-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 14284A0006
X-Stat-Signature: wdrmdn19e4iua81w5xazkcatjszzngzc
X-Rspam-User: 
X-HE-Tag: 1753951100-523053
X-HE-Meta: U2FsdGVkX19ghaj8tscfWZSQrxw+AG+0E20Cv5cAo6HTKvsBgA3cdeysSxNmMvLrnfmzJdlnWBXaWgCzPUoGlUTw+AP4iTZmk2MqeVk/u2zhMXn6HvfrFex2ylpihtQCYeoKB0T98FbaHTRU7fY6uDFyif5l/SWpP116Bu0007Qnv99drM0n0lgixv29bLW1T3wmPenYwBifVNbNE9QGvUIwtA6Z3ZP7zuQFAJwO/S2MpwQ0hKp1V/HBFLGET34mejUM9jbAgn8Suume0ca9jbE66SiNkCOGqy2O3A1pLU9IaFJSC5IzMPsBROzSoY7mRAf67D+9t27c5ijkk7+ep+NTCsh66WMagBtsni0C+w5g1wtUVdL+Kzp2EeV/c9HXlgFmpI86o4Ql+eoHPiS5+ngfbt/dkUZh0xUDJVsHmnjRQ2wC4uNx96V9LMTnGu/6cOaRk8NT/iD566YHkvZRJAZKCfWtv/4kd71vzUFJSxJR65yLTXahK4dsercG5HwGk1DSn3p6b4sf94eVUsLpH+9A4+EQl5auGf9i+3MXPqg1Met75CAc2zV2edqSfB1iEMbGfSSJjJyYT6jXlFVumgalkew1v7zvHWkZhynYoA/4tNidwf+JVSA+0/oqbvT8/PhT+bU2rmGSrkSZhA7obJ15uFr2f3DXWjM0eXBdm3pqeM1oMkcg80CcNxAapjuOJcd8a9qo0M/I+/di3RPLqHvVVStaIaKbaW+M5tJUptqoH0XMWLMr6rH7uZ/gWNA+80Q2T+lfuCbwLBWrjx4bitCzRFaPqg/7dt1IgPUM5Esbr6/meic/VHrkQpRhSVyTJnMwAxndmvFanGBnRthJVgQKCqJAyjGj8khm4LNM7COpDgltyptW7RZwmHSvLuogwUbEsSfIKeqQAkw1O23+IF0voq1RJnQMjmYshNQ0bblldIV4kOzxrWUH8PLkFMh8TXetUcAqupqq2PzGt5G
 LzXHjkAv
 KAQkPLwUy7gqp1ytI+0zyTjzo4ygrx/FqvW6MObd8K+INfZDNZFCh0Dw0T+nNGrKUKZc3VjQCihkaHvAMi1i3GGwjPz0J3mCJ28x3LGHJgR9vaP0yUu9VVtvyIPACPOFe8MpwFNtKG4Iin3QnMnWGaeqeo9Rg1oa2MUj2eCAb1AsijqnrifdoSl49NT0z/GJNNjH0MFV6VXuPDRH8IZ28bFPFf9tIWAnU7EJVO7DVMxRZtbgNRt326GtlsJp0g8vRkhX5
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

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
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
index 48839958b0b1..b7c4dbe4d2c1 100644
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
+#endif
 
 static ssize_t write_full(struct file *file, const char __user *buf,
 			  size_t count, loff_t *ppos)
 {
 	return -ENOSPC;
-- 
2.43.0


