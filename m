Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0315CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2C16B00E1; Thu, 18 Jun 2026 05:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A186B00E2; Thu, 18 Jun 2026 05:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915506B00E3; Thu, 18 Jun 2026 05:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBD26B00E1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:38:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D536D406FF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:03 +0000 (UTC)
X-FDA: 84892491726.28.98BF0FB
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8417C100011
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:22:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=L2pAxz97;
	spf=pass (imf05.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lp7IuTicfKn/jutgHJKaOpNy7+Kx5wxHCFNLAg35l8=;
	b=Dmsl0/xqbUU4GyyrRnstl46np6Gblcn49PkhesZQRNCAnNkjJGCT9kYDiIvOQuNF0SxOyE
	x0+cF3MKUgEo+K6gi/Vg9OfLf16kPvSmp0iXPi7rxWKBTyta3oMspMWLVxTwNRLu+NY87B
	UuEae6r3frlqDFJIGuV8x1p6xwyF/u0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=L2pAxz97;
	spf=pass (imf05.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774522;
	b=u0655euBFOAQw6HpNItsF2Bzj9FSqcvCCJvW7/p1ZsC7PHujbeydWH0pqUQX78nRgYjwTc
	IonKMdrnGvTPimtt3p/k3LSEtLs4yXOLMB8AEqsTSTDOaQD+1281gWYz2k7ZV6TS0Myjg2
	X3EQA7RhtiGKH1o8WpP8FnQPC0LTBEM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774519; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=+lp7IuTicfKn/jutgHJKaOpNy7+Kx5wxHCFNLAg35l8=;
	b=L2pAxz9700gJe1kc9i6aOaei+L3zCx0Mv6EXGcXPQLfoLnxO7xSge5mOQ1JW4GwVZJ60zXeDAnqWX0GOsAWWfef2rjUN2vl96B8uyUPNUZYGMKUpfG9F7ihB8S7L2T7yvFNUoss86C/U0Yvi6yA0VQW7kaPTsYPj95UFCd+gTTc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X56WGuf_1781774514;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56WGuf_1781774514 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:21:57 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH v15 5/9] mm/hwpoison: return -EFAULT when copy fail in copy_mc_[user]_highpage()
Date: Thu, 18 Jun 2026 17:21:19 +0800
Message-ID: <20260618092124.3901230-6-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8417C100011
X-Stat-Signature: 9dsdo3atcg7f6o1m9hcou4jjftdun8t4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781774521-890509
X-HE-Meta: U2FsdGVkX1/FwIALpLEvmviHd8yNgAtsXybOhHAVrpqrCqZS0hYCiVqYlm2YFzqX69Iz6OxJyp58Ijd4mAEQLx2Z0Em63Dc1zxzvVvgQ0gH7ZCTCOMGWx9kU9tiVjy8jvx1Q/Ys7untlOoS41KYZPuMlUB2TydGxQRh/V/zbYeT+voKNd0d9wtvdnZlJh2iWXohPafgV4MOzZFll3o7E7hhvPrqwCzcAqB6D/UyP4D4BTjNT63vJkt9s3jx/0O30l2HTKNki7uYzuc+jyfdJOh8aaTKs9/Tfoq/FpQ/8NiB4FXlA6SwpozyvGvtWgk7VkLVziRRx7KO0wwIAYjRJSnSdFOmcMz8n2laW8QOWBpzymlXFXkzIvpxfaCO3L2UpaaCL7Euz8c4i2cK3G212C0TNLJbanG2yPNwZWr7qdjy5ky1wvyQxAkfO+9wEVB2/DpFH8Hfpsvac0BONFW+GDLd6/XT56z1VMvKGu7j7050BX61NBA5aJVqolU150zcAEpl00qY/rQmpw99FWcSHnqaOoWbWQA7UZraqCjTOpAfMF8l0vttYp+doRWn8Jb11lgqH3knISzF/fCAaioRjDLHj3KRQxKXY+vmZ5eAXXBmcFqCE6VNgAfSbvkgoQNcL0xdljAPyKtRA9V2hm3AXcbLWTXUZ0+lNSGOWDd5npNsbBJdZr5KaV1vHQzK2mojLcwY9cLjl2Zw5oOcW8iDJi4N2Fu5nRc5Eh2ENIq6q85E/2RCLMZ2Lnko7AwavX5xzuk7VmI9IWRBSbTHxcZwSSD5Svv2T69iPBVxqc7asrdgdBiWiiySbN43wSTb41G6wnC5IzZJFLo/KQbmrd8ri+i5wGfc7njzGLbY9N0mJVjHtwfYQjHghhr5coarxJUx7y1l4beiRKUAg4BTaVD+9vjgn12Iyv7p+YsvIKe9Vlo7oBLSTmerfS+7D8W/Nsy5bdtLhGANAFhwfmd47nvx
 MWQAJYPs
 cTw+Ta+2hOamfcM2L1UdfNgZ8Go8T2nhFhUG1HA2nwF7qu24NzAZJ1bE9/9p1JB9APjtH9VM4+6rbfNLTkllPo3rHLwsd5EgqsqYo4m4xw8RzmtkDENclScIJaNbfnEwK22lERx1j/C+WEHPvXtwVc923oW0A468vYmedGPwY7JuXf4WohWLISsxtsVQapIB6OMr+TYVFZbWUiw0e9KRa5/q/GlWLWhYfIT3fFH4Ma7mKo9VtEUD35rwfGUnV3q2Drd6+fo2q8e7W2Lz+naJUfELSdstdP4lS9JDB6ybuDKtjVH0ztdjv7yLZAUuhLRVu0B9QCxieMuEVHB33PgR4q75uRxMFaFdnWaWPZdk4t6k5lucXhnNDgmcsGTptDpaRqnnUNmwHyP4pyDdji2ULgv+EzY9itnuxPEwsGMdIjnq8zMbxhjK6qiksflmiP+VJByZ4fCqNLgZzpwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tong Tiangen <tongtiangen@huawei.com>

Currently, copy_mc_[user]_highpage() returns zero on success, or in case
of failures, the number of bytes that weren't copied.

While tracking the number of not copied works fine for x86 and PPC, There
are some difficulties in doing the same thing on ARM64 because there is no
available caller-saved register in copy_page()(lib/copy_page.S) to save
"bytes not copied", and the following copy_mc_page() will also encounter
the same problem.

Consider the caller of copy_mc_[user]_highpage() cannot do any processing
on the remaining data(The page has hardware errors), they only check if
copy was succeeded or not, make the interface more generic by using an
error code when copy fails (-EFAULT) or return zero on success.

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
---
 include/linux/highmem.h | 8 ++++----
 mm/khugepaged.c         | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index af03db851a1d..18dc4aca4aa1 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -427,8 +427,8 @@ static inline void copy_highpage(struct page *to, struct page *from)
 /*
  * If architecture supports machine check exception handling, define the
  * #MC versions of copy_user_highpage and copy_highpage. They copy a memory
- * page with #MC in source page (@from) handled, and return the number
- * of bytes not copied if there was a #MC, otherwise 0 for success.
+ * page with #MC in source page (@from) handled, and return -EFAULT if there
+ * was a #MC, otherwise 0 for success.
  */
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
@@ -447,7 +447,7 @@ static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 	if (ret)
 		memory_failure_queue(page_to_pfn(from), 0);
 
-	return ret;
+	return ret ? -EFAULT : 0;
 }
 
 static inline int copy_mc_highpage(struct page *to, struct page *from)
@@ -466,7 +466,7 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 	if (ret)
 		memory_failure_queue(page_to_pfn(from), 0);
 
-	return ret;
+	return ret ? -EFAULT : 0;
 }
 #else
 static inline int copy_mc_user_highpage(struct page *to, struct page *from,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..cf1b78eed3c3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -810,7 +810,7 @@ static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *foli
 			continue;
 		}
 		src_page = pte_page(pteval);
-		if (copy_mc_user_highpage(page, src_page, src_addr, vma) > 0) {
+		if (copy_mc_user_highpage(page, src_page, src_addr, vma)) {
 			result = SCAN_COPY_MC;
 			break;
 		}
@@ -2143,7 +2143,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		}
 
 		for (i = 0; i < nr_pages; i++) {
-			if (copy_mc_highpage(dst, folio_page(folio, i)) > 0) {
+			if (copy_mc_highpage(dst, folio_page(folio, i))) {
 				result = SCAN_COPY_MC;
 				goto rollback;
 			}
-- 
2.39.3


