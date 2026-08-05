Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D03C561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7C96B00A1; Wed,  5 Aug 2026 12:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21D66B00A0; Wed,  5 Aug 2026 12:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FBE6B00A0; Wed,  5 Aug 2026 12:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70A216B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:29:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E8A940501
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:29:55 +0000 (UTC)
X-FDA: 85067752350.17.9766183
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A975180011
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:29:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GKySmNby;
	spf=pass (imf06.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngQccyP8H4V8ozRsqq5pX92pyP8jrNPIZDv0jYhOODE=;
	b=XHiCHzoUGjdPFouG1C9yaiTi3hmLVkISOMK6y6+epfPqkf85MZ2roQG5bO+CK3qIfl+wXg
	INtD7kkUDrcEw3AkhZIj/84RrSpYkrtcGpv1oC9A7sxwwpiV2u/s7VebkUNjjL7ZRgZWQQ
	J/kEe2Pi0HAR8FwEAmOfsNUmb+Aoqo8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947393;
	b=55RIxeVYd6iq3oWlLCBYKGbqgcwQ4A6WzupqkuVC90NVYa6kT5g7mw14wjyHTWG+MweTt1
	2wknu1ze2kidbhwLxIGhA3h9YBspp3cEtnywG7h1YzxzoklypqpzddqriHkHB4MM0diGh/
	i1UYlSacHoeUVUv/aTghpuhjONnn26k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GKySmNby;
	spf=pass (imf06.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ng
	QccyP8H4V8ozRsqq5pX92pyP8jrNPIZDv0jYhOODE=; b=GKySmNbyu3HTEwuTA6
	xnvhEJhbicGxSoRripWkRC9JkyzXEey5OYOQvhrNZh8pJKcm2Wr1QxHy8NIXVw5P
	dS5IaqAgxGgB4CF46lDsfXw+6bg94Bgi39JAzWuFJ1qLyceYKv78HfBXLr+ALgGK
	4H8CD1UcsGHegfOr4BNU3G/9I=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wA3PsvyZHNq3_HpNQ--.23754S2;
	Thu, 06 Aug 2026 00:29:39 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: akpm@linux-foundation.org,
	ljs@kernel.org
Cc: david@kernel.org,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH v2] mm/ksm: validate KSM rmap items before hwpoison kill
Date: Thu,  6 Aug 2026 00:29:37 +0800
Message-ID: <20260805162937.1795310-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803151151.3472893-1-xialonglong2025@163.com>
References: <20260803151151.3472893-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3PsvyZHNq3_HpNQ--.23754S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArW7GFW5tw45Gr4kJw1DZFb_yoWrZF15pa
	n5Gas5JrW8tw1a9r9rXw4q9r15Zwn5Ja1jyF4xAa4a93WYqw43AF4UJ3Z3Zay5Ka48Ja93
	tw42vr45CFyUJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j53ktUUUUU=
X-Originating-IP: [240e:46c:1000:421:34db:efe:597b:d439]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xPMxWpzZPPpcwAA35
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xz318mimun3wjcggechbcqydh19pg7a7
X-Rspamd-Queue-Id: 2A975180011
X-HE-Tag: 1785947391-927515
X-HE-Meta: U2FsdGVkX18LBGRLXraNNb4sadNVy8Z/O4fuQazqKzhY//2NdsIiijujfAe3/wUj1mMtK5HXZqYrx+xeV3yEisjgkmq47KkQfDruWRRQj1krsjWyuphoT2qpTDXcoWeUIyX0puyblL80mBhY8PPr/sM4JwK3wusdsgycEt1MjWGmhAzVRtsS9iM6tbPQ2OnnSWZIUmXd8bUCVd8ii4pG40gozfXpzwfyabf+Jcul7piS6cQpTfLOmAHzLcBqf0xGLuYgIr7aRyUdZ07BNqao1CON44BcibL0eeBVpIUY62lyUQVPKXwstgq79CWGVmHkaprdQZQYE40osDu51lFiESYUCDQaLmGARtjrnXeTVVfuXke7tW44ddAI3qMHK//jYmoZHetGnMVLFQn0SF1TwrFYmvKrvCQJanE1y37kdwwhXOcTImNT0XnEf1fwiv1cpaApSqO3d2KoeNpkDKunoxncOkwTh0pstwrdOR2C0lG8H2C/mBRJl37PqiIacuTkF87SyiehvrCooj6A7tiNXFSe/FMZCJ+0SCYuv7nhVXy8PBwTzoUiT8sxbBC5wA6Asc/lm4u4JRNlFWOdUpxPaV+WAw/jYFG6RREDB3y9UKxICFh/H0xcwESVi5DV68a/PR+gw3ojWpo2G7/sxRC9L3il7e1MbFqOBFLulLYowDhSD7ooG7TrXyAWQe9XBvMsU3weORBcIgrS+3UQrHh7fd2U+U0RuFVCF+oTQNUUl39ylMVOP4J29uK6cp2fue5MNo7GISQV1pxCOMBX52nLlawHOGk0qriF6585q7G9hmZmVTOzsxCp8hokxTFUNOnvNYPreXyTMLQOi0rpMYcb6Zz9mKy66Gz0O1QoYxf7Yc7YGJUQ8+AhVQW3isUi65oRzlz/QIcjvU+8VyLdTu9+TkykOSgWVIENZl0wYMKzb3rJKXPAz9Ad/gooXDzWO7D4QyJVgUYO/zV0GwWdSiM
 wXdApJLU
 VlMULnBiVwPAlwa0ShWUZFCbUuxXXAitDfa/6OiUB3xfIxOemEB0y0DEHriZwRLMsTajIcPUVFfZfi9O8nf6ToCXum12sD+ZxmEMcYrn3wsxmsaSS4oo/vkpz6NMLRHR7rya+Ukh7kaRPm1Bl+qt2ec0N4Am73ZbR+l5Ik/4keEq6d70xofW8zDky28eEuEN+nfPnzKsZgb/fo2PNleOCMpOcO208u/tGhVR6X8jW87tPO0drZBvSi4UWzw29GLv9UEA2Igis19PMK0Rz1uwd5HwUDFBX7XeOH2kyaEwm6k/JuLdrOhguVix52UTBLCWjZi1WlL5sLmBXmrJU1KFjXOotWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

collect_procs_ksm() walks the stable-node rmap list and queues an
early kill for every task whose mm appears on the anon_vma chain.

That rmap item can be stale by the time memory failure handles the
poisoned KSM page. A VMA may have been split, unmapped or remapped
after the rmap item was recorded, so matching only vma->vm_mm can send
SIGBUS with an address that no longer maps the poisoned page.

Factor page_mapped_in_vma_at_address() out of page_mapped_in_vma() so
callers that already know the virtual address can validate it directly.
This avoids deriving the address from page_pgoff(), which is invalid
for KSM pages. Use the address saved in the KSM rmap item to check that
it still belongs to the VMA and that page_vma_mapped_walk() still finds
the poisoned page before adding the task to the kill list.

Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/internal.h        |  2 ++
 mm/ksm.c             | 10 +++++++---
 mm/page_vma_mapped.c | 36 +++++++++++++++++++++++-------------
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..4c9e601b2d95 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1424,6 +1424,8 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
 		     unsigned long ksm_addr);
 unsigned long page_mapped_in_vma(const struct page *page,
 		struct vm_area_struct *vma);
+unsigned long page_mapped_in_vma_at_address(const struct page *page,
+		struct vm_area_struct *vma, unsigned long addr);
 
 #else
 static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill)
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..5104e442fcb2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3237,13 +3237,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 	if (!stable_node)
 		return;
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
 		struct anon_vma *av = rmap_item->anon_vma;
 
 		anon_vma_lock_read(av);
 		rcu_read_lock();
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
-			unsigned long addr;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
@@ -3253,9 +3253,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
-					addr = rmap_item->address & PAGE_MASK;
+					const unsigned long mapped_addr =
+						page_mapped_in_vma_at_address(page, vma, addr);
+
+					if (mapped_addr == -EFAULT)
+						continue;
 					add_to_kill_ksm(t, page, vma, to_kill,
-							addr);
+							mapped_addr);
 				}
 			}
 		}
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index bac2eb5de63d..f7c5dc9248bc 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -336,6 +336,26 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 }
 
 #ifdef CONFIG_MEMORY_FAILURE
+unsigned long page_mapped_in_vma_at_address(const struct page *page,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct page_vma_mapped_walk pvmw = {
+		.pfn = page_to_pfn(page),
+		.nr_pages = 1,
+		.vma = vma,
+		.address = addr,
+		.flags = PVMW_SYNC,
+	};
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return -EFAULT;
+	if (!page_vma_mapped_walk(&pvmw))
+		return -EFAULT;
+	page_vma_mapped_walk_done(&pvmw);
+
+	return pvmw.address;
+}
+
 /**
  * page_mapped_in_vma - check whether a page is really mapped in a VMA
  * @page: the page to test
@@ -350,20 +370,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		struct vm_area_struct *vma)
 {
 	const struct folio *folio = page_folio(page);
-	struct page_vma_mapped_walk pvmw = {
-		.pfn = page_to_pfn(page),
-		.nr_pages = 1,
-		.vma = vma,
-		.flags = PVMW_SYNC,
-	};
+	const unsigned long addr = vma_address(vma, page_pgoff(folio, page), 1);
 
-	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
-	if (pvmw.address == -EFAULT)
-		goto out;
-	if (!page_vma_mapped_walk(&pvmw))
+	if (addr == -EFAULT)
 		return -EFAULT;
-	page_vma_mapped_walk_done(&pvmw);
-out:
-	return pvmw.address;
+	return page_mapped_in_vma_at_address(page, vma, addr);
 }
 #endif
-- 
2.43.0


