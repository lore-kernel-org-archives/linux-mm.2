Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C923C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF966B0098; Fri, 11 Sep 2026 05:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880356B0099; Fri, 11 Sep 2026 05:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796016B009B; Fri, 11 Sep 2026 05:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5012F6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:12:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60B861C09CE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:12:24 +0000 (UTC)
X-FDA: 85200915408.14.4A259BA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA67FC000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:12:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789117942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5FtuPivaQKjr/EWT7fc5SeEAVoNIgcE/xQJ/JEzdxbk=;
	b=AAV/70UDx8qFnGLSK6CWdnRhq+7NQe0AcbKlQ55cI2vKbPr7ryfAV0F9C9l5fwFKmi/NCk
	nVVnm5ojwDruGPfmEv2SKWgzu6cxHgKcGpisewjiOiRDnvw/hBOvX+FMpXJ3dk5qb6zhM/
	iGqhVIL66D7YBFcjLbr2hXsehdlvzc8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789117942;
	b=k0NAQHvwp9Il3mEfOY8JMP/2NLezRgjujH/zAa/pvVwBko/sz+4xfOYN2C7U/T5Bp5Xc7u
	Sor+M7KShkSKysc8FaSNttkhzPzv2NbI8D2ffsLn3i2crNQWXR/RD/f2nTNVVUvVSgZtmY
	ax5WQ/g7gR9r2hXdSHUSGvd50lioX9o=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh82C0Fx6z5BNS0;
	Fri, 11 Sep 2026 17:12:19 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 68B9C461028715;
	Fri, 11 Sep 2026 17:12:04 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 17:12:06 +0800 (CST)
X-Zmail-TransId: 2afa6aa3c5e6859-237dc
X-Mailer: Zmail v1.0
Message-ID: <20260911171206334tMJBQdvGB6blX_uXxQx4Z@zte.com.cn>
In-Reply-To: <20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn
Date: Fri, 11 Sep 2026 17:12:06 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <ljs@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <liam@infradead.org>,
        <surenb@google.com>, <rppt@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <nico.pache@linux.dev>,
        <dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
        <chengming.zhou@linux.dev>, <usama.arif@linux.dev>,
        <gourry@gourry.net>, <harry@kernel.org>, <vbabka@kernel.org>,
        <peterz@infradead.org>, <borntraeger@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCA0LzRdIG1tL2tzbTogYWRkIGZpbmRfbWVyZ2VhYmxlX3ZtYV9sb2NrZWQoKSB0byB1c2UgcGVyLVZNQSBsb2NraW5n?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68B9C461028715
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 11 Sep 2026 17:12:19 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3C5F3.000/4hh82C0Fx6z5BNS0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA67FC000D
X-Stat-Signature: g8xx15xiywmsb5smor47nn5opi6614ne
X-Rspam-User: 
X-HE-Tag: 1789117941-174647
X-HE-Meta: U2FsdGVkX1+tEJ/dPDqI/X5crhyaFFI9TBL8Wf6bxRtgCw7L+ykA1g8aJLvVZFr2pPX/q4LcE2Fxmem4UiILOt/8wih1+Noe0DVpNOx+s2s09ffMrXNpPsc537G9mB0pCe04J034maQmeGBerdb7rw4QokPGb2GF29sxZh7G0OrsKSi9Oeby8CifDByTUYco5lpAxcF7eV+UDkRkXKafHc3iOT7SMjCRc/RbObGZyRaZjLluLlvM4Y0NsIM9HyRqEb87orPJ47rM4CW4xo+DJq0FzqpSxgTpP5cGZuRE/d6BaKmhcSy74c7rkHqc1XzoCpyV/HnCFUP/Ek2N4gEIM4zNE7D47OKLrtyC2v2y0vzPsAkC6MjxueBWv8D09aVcH4nenpKvc0fCIuHvzmnjEBKdy6vVDaqrdud4WabX9AAezdigMuoJezw3N6gX9OsnNw8u9VFe5fG7MouxaJc0NxXWx6u+s/flHRjWsNzM5dy7T+dZ8Fok5NbhPgYemFedLiYQAycthIxGFGHcDNACEFFpRaDi8ARWXxPynqvlS0KUVsJO1wIORJzV4LBPb88T3CGZb1wxR4G2L+Kw8+pAs6sAb7VYYSdcR43mt8eZlsUUFzJCmEdtCPd4MPOsKt96JjtVIefiJ8VKduniKcpd4Pv9U/sHfBYY60wtXmP3tgp3GT2zdoomc02tWEPeOzWpqJqD63mCEaYQCLFtJXrj83xf1dIvb4tU5BVDZQBW11ogPe0wMsyFrFHur1g0NEUyataoJXVhReCUI4Lxuy8fVyr6z+xLFPkW9pni73astD5RXDAC2mDcl2AxIAH8TPPrTIkEugrCHCwiFB62vTXgG1JSS0pbF5nZBFCt9sXpcdcPEC0q+zJuHlgHcvl6fJELP6meVVNe9PPt1Y37ianR7oqpn9g/jLWORONzSwgrgI9KOcZBgXCChG9Xm12igkBgWcIwnFStWljxHL+cFpP
 0+k228qb
 ZessrRiyAhl900Z1Gi9ZQiw/rhhuBY6I7i3EbUThAE7wHDfQyMDO0dAd9s1zstw52KqxvWpcXgtPc8MRvljxB8V1sBh1UzgGlAva3WeyzHKyUfrzRWnKUGsNBKbyIn+pVfqvxsAkl3KWpwUiNU67oHAtCf5O4id+HL7gnYSt+1//A/e3njzWVByxWh8gBJFm1a0Ptjqg3WGv2YdtsoBxh8oLFqJWhVub44QCCPcAwyIxaPUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC: Lorenzo Stoakes <ljs@kernel.org>
---
From: Xu Xin (ZTE) <xu.xin@linux.dev>

Purpose
=======
Let's add find_mergeable_vma_locked(), which is similar to find_tcp_vma(),
using the universal per-VMA locking helper, so that we can avoid
mmap_read_lock() to reduce contention.

To be used in KSM code to replace find_mergeable_vma() with
mmap_read_lock(), the helper find_mergeable_vma_locked() uses the
universal per-VMA locking allowing us to lock a struct vm_area_struct
without taking the process-wide mmap lock in read mode.

Performance
===========
As a test, I construct a testcase which follows the approach: Create
one victim and several churner threads sharing one mm_struct; The
victim registers a 32 MiB anonymous VM_MERGEABLE region containing
8192 pages totally:churners hammer mmap_lock via mmap/munmap
repeatedly; ksmd merges the victim's pages; Compare latency baseline
VS this per-VMA patch.

               Before patched         After Patched
0 churner:     1.627 seconds          1.426 seconds
4 churners:    72.45 seconds          36.61 seconds

In conclusion, when no mmap_lock contention (0 churner), there is little
difference between the baseline kernel and the per-VMA optimized kernel;
But under interference from 4 churner threads, the merge time of the
per-VMA KSM-optimized kernel is significantly reduced by 50%.

Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>
---
 mm/ksm.c | 64 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index dda105681d7f..1d85769ec7db 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -765,15 +765,36 @@ static bool vma_ksm_compatible(struct vm_area_struct *vma)
 	return ksm_compatible(vma->vm_file, vma->flags);
 }

-static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
-		unsigned long addr)
+/**
+ * find_mergeable_vma_locked() - Find the VMA covering 'address' which is
+ * VM_MERGEABLE and read-lock it by per-VMA locks. Please use vma_end_read()
+ * to unlock vma after finishing reading the VMA (non-NULL).
+ *
+ * Return: If a VMA exists which spans @address, return that VMA, read-locked.
+ * If no VMA is mapped there or, very unlikely, a reference count overflow
+ * occurred, return NULL, and no read-locked.
+ *
+ * IMPORTANT: If a VMA exists but is not VM_MERGEABLE or has no anon_vma,
+ * this function releases the per-VMA read lock before returning NULL.
+ * Callers must NOT call vma_end_read() on a NULL return value.
+ */
+static struct vm_area_struct *find_mergeable_vma_locked(struct mm_struct *mm,
+		unsigned long address)
 {
 	struct vm_area_struct *vma;
+
 	if (ksm_test_exit(mm))
 		return NULL;
-	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
+
+	vma = vma_start_read_unlocked(mm, address);
+	if (!vma)
+		return NULL;
+
+	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma) {
+		vma_end_read(vma);
 		return NULL;
+	}
+
 	return vma;
 }

@@ -799,11 +820,12 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 */
 	rmap_item->linear_page_index = 0;

-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, addr);
-	if (vma)
-		break_ksm(vma, addr, addr + PAGE_SIZE, PGWALK_RDLOCK);
-	mmap_read_unlock(mm);
+	vma = find_mergeable_vma_locked(mm, addr);
+	if (!vma)
+		return;
+
+	break_ksm(vma, addr, addr + PAGE_SIZE, PGWALK_VMA_RDLOCK_VERIFY);
+	vma_end_read(vma);
 }

 static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
@@ -814,13 +836,12 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 	struct page *page = NULL;
 	struct folio *folio;
 	struct folio_walk fw = {
-		.walk_lock  = PGWALK_RDLOCK,
+		.walk_lock  = PGWALK_VMA_RDLOCK_VERIFY,
 	};

-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, addr);
+	vma = find_mergeable_vma_locked(mm, addr);
 	if (!vma)
-		goto out;
+		return NULL;

 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
@@ -831,12 +852,12 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 		}
 		folio_walk_end(&fw, vma);
 	}
-out:
+
 	if (page) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	}
-	mmap_read_unlock(mm);
+	vma_end_read(vma);
 	return page;
 }

@@ -1568,14 +1589,14 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 	if (ksm_use_zero_pages && (rmap_item->oldchecksum == zero_checksum)) {
 		struct vm_area_struct *vma;

-		mmap_read_lock(mm);
-		vma = find_mergeable_vma(mm, rmap_item->address);
+		vma = find_mergeable_vma_locked(mm, rmap_item->address);
 		if (vma) {
 			err = try_to_merge_one_page(vma, page,
 					ZERO_PAGE(rmap_item->address));
 			trace_ksm_merge_one_page(
 				page_to_pfn(ZERO_PAGE(rmap_item->address)),
 				rmap_item, mm, err);
+			vma_end_read(vma);
 		} else {
 			/*
 			 * If the vma is out of date, we do not need to
@@ -1583,7 +1604,6 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 			 */
 			err = 0;
 		}
-		mmap_read_unlock(mm);
 	}

 	return err;
@@ -1602,10 +1622,9 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	struct vm_area_struct *vma;
 	int err = -EFAULT;

-	mmap_read_lock(mm);
-	vma = find_mergeable_vma(mm, rmap_item->address);
+	vma = find_mergeable_vma_locked(mm, rmap_item->address);
 	if (!vma)
-		goto out;
+		goto out_trace;

 	err = try_to_merge_one_page(vma, page, kpage);
 	if (err)
@@ -1625,7 +1644,8 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	rmap_item->linear_page_index = linear_anon_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
-	mmap_read_unlock(mm);
+	vma_end_read(vma);
+out_trace:
 	trace_ksm_merge_with_ksm_page(kpage, page_to_pfn(kpage ? kpage : page),
 				rmap_item, mm, err);
 	return err;
-- 
2.25.1

