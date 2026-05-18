Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51719CD4F57
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A5A6B0093; Mon, 18 May 2026 04:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B129B6B0095; Mon, 18 May 2026 04:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9AE6B0096; Mon, 18 May 2026 04:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE8A6B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:50:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DE4A408C6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:21 +0000 (UTC)
X-FDA: 84779919042.05.240F960
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf26.hostedemail.com (Postfix) with ESMTP id EEE60140009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GPmeX5k8;
	spf=pass (imf26.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfwkogOixf5GMwu+2dp6NmTbHKTViLblOsXgNerkr74=;
	b=JqKhwKOJ2/+Hn6SsU+/+SY1lGxzk1bOApvL1CgmiCY+NPuE57vKyxK18HjXiqyvGFD1YZt
	+THCJkTFOgwgF/4rXcV1ph8vVBcQYEhUcLhpE8K1pub4yzhSMYiB1ECwZWqPXwQXZjv8R8
	8gKmU4s8zkieAxAdWv0uX+SvOfkD/fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094219; a=rsa-sha256;
	cv=none;
	b=LxkZ0fB/L79pHDHsJJh8LQSianwPWF1oW2DPu1/LeKlajKXCv73xbmhXRAS/ALcuXV7Ugl
	nMkA1k/Az9srhfbxjcoCosk+RFvmlav4UIwtX1RCERATTruyyGfIVmBEWnOe4Z+U7zTx8W
	PMs7qk3nGAi0S9szZJknUbQhNj7BYz4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GPmeX5k8;
	spf=pass (imf26.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779094215; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=OfwkogOixf5GMwu+2dp6NmTbHKTViLblOsXgNerkr74=;
	b=GPmeX5k8pDe1ht6XjFINwYavbBn5tst+PB/SB0AbrSwals6C7T77wQ9ldQdLk8mn725Ymbu4SYLXax5DSKdCfIZjmG6IGodygCY7iJCzPBDLdE/tc9ONLsrMTyHVuWtN9aAOpMHpGQOdyDrpaxSo8T3szpsAhkw2UVtYiok3EV8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X3647Lr_1779094212;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X3647Lr_1779094212 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 16:50:13 +0800
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
Subject: [PATCH v14 4/8] mm/hwpoison: return -EFAULT when copy fail in copy_mc_[user]_highpage()
Date: Mon, 18 May 2026 16:49:48 +0800
Message-ID: <20260518084956.2538442-5-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EEE60140009
X-Rspam-User: 
X-Stat-Signature: ie6wimbh3umnrp9bpkyf4p4h8tmxjs3m
X-HE-Tag: 1779094218-376413
X-HE-Meta: U2FsdGVkX18kC3rLeWDWydtew18IxAIQ8HLPahewnRy4K4oCfCZRUSeOtmJ8adfjgHeI7x6cYQM7XF1BovqoMtbn+KJNV6/B4cA8HV/qmuOOUVMuw1eUBKJ0lzNOplT+Ku9fzteOpgXQYD/p/tVnAZk0HbmA6zUCNV1s1l2TBh/bl53tQWW/M0WAteJ7RFk37+Iiv1ZJEZlRHK/xH5cKaZDKlpw12piLz3WZTkEZJJB+GQ+WMh1M7sYNEDZ/5KTZ3ekYgD3aAY/wTSghOwr1KR4sQ8vgMDsfG9+E0pPyGrVgKBh8Ecn/TKxR8F1/sjLCe5Ecn9hxxCNIxj/YfLDbx/8paLbUru8M7Coikst7iiQEAjk5tnIuJvX3H1n7vSnynq3fAtN2VS1BPRgbHoM+t+ottXcJsDn380t4YviJxknPEBGW7kOCf04zwlslpj39rTiNMW9eFg8oMVSd37T51+BSQZV4e+ODSzeG1o5Scatycb6nFoMwf+EbkvDEnIwET1VkNXwTgy6qi0HL+Hy9UCeJ80GgtiY9KLFo9DY5ZzGaUavRtmsFD7XPtdF0TzQsbhgK8A6h/JdyNH144rF60E4+rXSQ5GbOdJ6pZUfBthGJU70YzLqBmdGy6nxNWe0c3n64zMqzggzdXbgKFMnCPwoQXYOiuJy9EFrWoj+VE7EnUhleHyib1CyDWGdK8dlU6t9cV5rV2o9YTgUI9wOWgynKsgAk7+AKGiu3zuEGW4eeQx2oTBMi8gktuRC4C20B6boCwkka/BMJraV0+k5xTxEylnJKg87B9Z+a5u2KCWNTjPzHPcVkzh8loGK2EKeStwUqJnNmQS+2m6JuaKWa5tRpIuy7Ie3oHg8G7iTycovN42Vwzr14KPQH2N/6FQodQZYHYX6TqFKkw1522CRTWcfkA/bCS7C+7T1wyEHWPXZT71LESllovuXbV6eeRTV4a/o6+qk301MfTT3DEYV
 KgIA1rpm
 8BhVskfI/Kjksu5h/yv8ZBtyojClxJXWgisMAL7gxFobzncRlQDBZD9EUnVvYshcDjBFUPs7WYWn5POC43hL4iL1YwebXo+0i458yKpsIpEbKF4jNXlpYhC3LVmaFyL5HNModYcCf6kyma+2tZpgYXnHHmj8moqJdoZXsAVzx/Z/XQH9B9E9oXRaZORfwrn9INukEF3QyXpPVsZvIWr+B1Ssh8kw8g9//GkeGnpqT+iY0oBMojmXc4GTBriMu8bGYZGT8wT0gnvXUlh1OVR/VYG09qLnslGrEWOYxbQmD2xLX6p4rOEC/ASbTWEsNPOXGtnD/8j3INWGlKFWjIMiWPAIHLs04zlWHSUNLONGWgV00gPjdwjPgGcOhm7zjnNRCn5zlYHDK7oBUORu4sZ7r+h8ChllBWWNJ693BYUR5xY9ytnP2pwqUAfIV3Q==
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


