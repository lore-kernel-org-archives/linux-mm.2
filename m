Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD25CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9399000F6; Thu, 14 Aug 2025 02:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689B5900088; Thu, 14 Aug 2025 02:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579F59000F6; Thu, 14 Aug 2025 02:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42270900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:47:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD3B083087
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:47:58 +0000 (UTC)
X-FDA: 83774433036.14.B410926
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id F1FA840003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:47:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gyArAt7W;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZcBk9MwxaNuqr2vt/at3ZKHAG+m/Z6cGsV80XrjtvQ=;
	b=06XLOl6SIIzMB6qPSmN2BHL4+xyahsw56mOtb8vW5Wk7Dq4moFj/9m07MHTuEEilFqkykJ
	34BqvtsQ9V29zjlwbRrQYR/wXJmBIRx3l/BVXnbrEwFvcYpQugUS0HbPg3m5FEMZ0qvKKD
	AioVVS+SNROPCTXQPHKbbPJOcPtonCw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gyArAt7W;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154077; a=rsa-sha256;
	cv=none;
	b=I0FyggMDJvrOIEUDvAf5/fBCb2IjBmAYAILW14HjKtC16iNyLP733dfQNCdRWMFXTbUxki
	EeJ8OyfHb59Zfsp3QX8vMZf6hYeC73jiLnWF6uVXulT+Xg4mA5ERD6xd1fS53FTPwTW/4L
	JfVz7ftQ4/sU4CQd3qgsP4rj6hw/t08=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b47173a03ffso319639a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154075; x=1755758875; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZcBk9MwxaNuqr2vt/at3ZKHAG+m/Z6cGsV80XrjtvQ=;
        b=gyArAt7WeY3sd9S5PrIbGzQ4o+YB2rFOvsmUK273d09xjHz6HVoMXsGvH+k2xCUR13
         ByvcCWi+yU1oPxLWR53ou8SlZJQQZ9zroKcaLkwgU/eRksc0ZoP1KASUHkYR9Nle4FfJ
         jc7pgraXmviakthcEydZqfys3f1bV11xgRcymhWlh5KhbnTIU+tPW2o5J1T4KBLEL+uV
         3zsItfbHg8GQQkJgxQ+JbQB16igR7Kf+IDVW708z2jV2Oh68epxsesHfpgHNu5/vGm4A
         SjsSb1To29mB6AGmepIzgmPbykQb6xT8y5e1K7OD0Pj33GYawI3/pf3qsdvfY21X0p3w
         AzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154075; x=1755758875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bZcBk9MwxaNuqr2vt/at3ZKHAG+m/Z6cGsV80XrjtvQ=;
        b=P14AHzQ3vc8IqyYJosUlWCZf2DYU1Gwl0LJEJwB6ITOJDGkf6TzYa50gjik72q9M6Q
         Y/u9limX1ts3XGFikiKSzWR5tyQ73r298WjV94QzcnAIu6cJ3aTIpDcLN9omK61eDwF/
         o3rdpMzLgHvPRBSxxbQPICobK2n9gnGgVHPRLbUaXxoAkUyrdCc9Pj280nYRFtMqXqcm
         ei/k/QbKawK09kJ44LwQM0pv9F0OfMh+/jUB2SAE4js6lbQKYN4ucF1ngWq1jaZiAo4M
         eWBr3BAd3U9DDqSrINLYl6PSoFtLq2QvnZ/p5VOyzcb4RFe5JCy8eGC5spLeYdghmKS1
         SLCA==
X-Forwarded-Encrypted: i=1; AJvYcCXpf3xVas8VB5mJFAfzatDaB30x+kYDaFA4+3EhhPUmxnzrSfsHehKM7pvqVy/8sHHOv2jXSBSCxQ==@kvack.org
X-Gm-Message-State: AOJu0YzF1HNJ/25LtDJHRimbQEyK5pdf03Htr8OcRVHIycnNyuMyWOdp
	sXGF0EDuNjmgpXgymv1681D2fW/B9RqAlisHkTBPV9ED1le+tkv/oxEm16I+NmxuCvA=
X-Gm-Gg: ASbGncs1uwQTT1Qy4B0vw9ilkaed8Pep2vSyuSpLscpRRzVSsKtf4Hpjj2xOyWNE8fr
	7ofy2nmd0CbvD3hJEPdDctIIx2j3Op42tpv6JAGLonR1MCShGIRIHdSi/S8INYMUrmLaMB03CAJ
	VGhPC4Bs6Frf1Nw14BJJRZT4kM51MTAMKvSYL/ZjVxZvHHZy8dfTEjGQzbmgXhTsZQiCmWiJ/aG
	w5qg86tA347djNTcGc46R3IGHbqRdIvw0idEqX9VwjumE0cqnJy0arEvbXLsUEq3bm0p6hg0ZMz
	80sn/gQfm0m9RiLYboE843dYFK5L5KXCSOLrlu20mFGfvEzojhfWO1zZwemzAcCYq+o707Q7mFu
	4NCM72qKxPzRo6pqXaG6sc5qTDoZ6gDG/e3ODzJrykwv1eZCiDA==
X-Google-Smtp-Source: AGHT+IH9qrcfN2simXDC/Z63ef3bhTYTOIKfZnDbd2f4Qsyxb3uglYIKUxcaUW+tnmMMPP5XmPrYhQ==
X-Received: by 2002:a17:902:f54b:b0:240:6766:ac01 with SMTP id d9443c01a7336-244589fd923mr33944065ad.2.1755154075409;
        Wed, 13 Aug 2025 23:47:55 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:55 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:11 +0800
Message-ID: <20250814064714.56485-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qogybfjs3a8i5h8cacyspmtgnbpnqtnw
X-Rspam-User: 
X-Rspamd-Queue-Id: F1FA840003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755154076-125412
X-HE-Meta: U2FsdGVkX1/HL0p59ZUK/oaU1MlOnEJ7JNuxfgAeYuOglwvoLDhXV112zJUSN4IwWnlzJZf+PUAWC3/LbTHO9BqqJJT269/hRRFrOCWVTd/LvybfYcCpdI2uZxiw1XxRGo6V/dd9M7uP2TfTyqAhOAJ+zisWkefc6rpKpCN2ViPZ2wnzvGSWevIO5aXM4sqrLdsRgiTBjDCMiluaVQsBTeth3D9U9xKXjLqDx1nJpB2RYkmZ8pNks20wbFb9cfwwC57Vs9RalurqZkVCOZE1oUigVM4wBzPlbP0loqoEJ32blT6wS6Ff0wDe015Dhg/3MeuEiZX3pKwFVWHkjxljGgWcPcFQMqO/yz4wb9xRgqIu9dhY6kkaNLz4tACeTDMYHNivpqDSimPDa6/SFs0tgNz3wUNrC8CjzzakCbP0ybevPSFHA1xj2Hze7tn57queo5BjMvqywr4PUAy8mlKxIsFgHUL/VYlJvnRU8FD/XP7J/ud82nP5njNTM5Vh6JvqU3/2Ln0ZICLwQjEA213AmA42vKwm5yw1Uix43zGuuXGHCQiJ8KwbJNzWjGu8u+Swofh+aO/4PT1QFQxGiJBigmRRPevHjRyRlknoAlsOF60T1eGfhMWv7o1IuhtwLANow1nq8/amjtXOyX+OYElPZE+1hP+ogg3tcX2yg8gemig+OgZpdvGBCprwQwuAZqV45mB0z9NMGa2KmxSoTrOlKAlB1yFA3xHHCfoypkXjt9jE3dYXq8sTa3meHSLp6qd+Jtj/EmsXMNvB3tTbRYPWZ6a4ocPT0IXbBZCDTPWj+JraTdGovnQro9FJ0VuMy1oITHBdlAncRoAaY6pqGcmktzRWdliDwHizL/uNC4GkW/DRdFtfyWxy4X8vzojGBREZygjhST5s9OMnaMZ65jCT8wdwl59l5MpoyoRcmmLN1cdVIMTwUXT/qEl3iH+udBkdhEUF9rhi7DH9aPeklfA
 g/RYELrx
 D0NABV7+fYShAimmPGH7cSupSqdFsOaurRWwuLL9Uf/IslVA/oC/OKYLsSzTokHeUHTDF8ZAUA/NrZGgNnTS4AuydXBR5YHMLR8kwj3S7WVUDpR1XLpNcHZ4X7WQxvv+kGkpY5UmGuGnmsRHkrVUan8e9pQWEKLVQ9MBmBy4QvLMkd+gUvXo4Pfi+yBQ7LkJ+f6EUcnkIhzVSVaJl1VVnM6XEdOJxM7bJge9HvMm0TVsWnM5iRZ8gXVFBhfH4dDuVPK8r3W23N6vZcfIKotuacPBIP00BNpdJ961dwW/R01DZbx1paPi1eJSY2LhwQ3OX/MaDjAgY0okwfKDTRF/LSQfiLy0FsWug7q3+Upi734br0Anbyu9aZeNyaHjIxu62rujEVvKyHEmiCXi55ceDJl2+tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

When vfio_pin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.
Batch processing of statistical counting operations can effectively enhance
performance.

In addition, the pages obtained through longterm GUP are neither invalid
nor reserved. Therefore, we can reduce the overhead associated with some
calls to function is_invalid_reserved_pfn().

The performance test results for completing the 16G VFIO IOMMU DMA mapping
are as follows.

Base(v6.16):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.049 s (328.5 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.268 s (59.6 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.051 s (310.9 GB/s)

With this patch:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.025 s (629.8 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.253 s (63.1 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.030 s (530.5 GB/s)

For large folio, we achieve an over 40% performance improvement.
For small folios, the performance test results indicate a
slight improvement.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 84 ++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f8d68fe77b41..7829b5e268c2 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -37,6 +37,7 @@
 #include <linux/vfio.h>
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
+#include <linux/mm_inline.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION  "0.2"
@@ -318,7 +319,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
 /*
  * Helper Functions for host iova-pfn list
  */
-static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+
+/*
+ * Find the highest vfio_pfn that overlapping the range
+ * [iova_start, iova_end) in rb tree.
+ */
+static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
+		dma_addr_t iova_start, dma_addr_t iova_end)
 {
 	struct vfio_pfn *vpfn;
 	struct rb_node *node = dma->pfn_list.rb_node;
@@ -326,9 +333,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	while (node) {
 		vpfn = rb_entry(node, struct vfio_pfn, node);
 
-		if (iova < vpfn->iova)
+		if (iova_end <= vpfn->iova)
 			node = node->rb_left;
-		else if (iova > vpfn->iova)
+		else if (iova_start > vpfn->iova)
 			node = node->rb_right;
 		else
 			return vpfn;
@@ -336,6 +343,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 	return NULL;
 }
 
+static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
+{
+	return vfio_find_vpfn_range(dma, iova, iova + 1);
+}
+
 static void vfio_link_pfn(struct vfio_dma *dma,
 			  struct vfio_pfn *new)
 {
@@ -614,6 +626,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	return ret;
 }
 
+
+static long vpfn_pages(struct vfio_dma *dma,
+		dma_addr_t iova_start, long nr_pages)
+{
+	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
+	struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
+	long ret = 1;
+	struct vfio_pfn *vpfn;
+	struct rb_node *prev;
+	struct rb_node *next;
+
+	if (likely(!top))
+		return 0;
+
+	prev = next = &top->node;
+
+	while ((prev = rb_prev(prev))) {
+		vpfn = rb_entry(prev, struct vfio_pfn, node);
+		if (vpfn->iova < iova_start)
+			break;
+		ret++;
+	}
+
+	while ((next = rb_next(next))) {
+		vpfn = rb_entry(next, struct vfio_pfn, node);
+		if (vpfn->iova >= iova_end)
+			break;
+		ret++;
+	}
+
+	return ret;
+}
+
 /*
  * Attempt to pin pages.  We really don't want to track all the pfns and
  * the iommu can only map chunks of consecutive pfns anyway, so get the
@@ -687,32 +732,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 		 * and rsvd here, and therefore continues to use the batch.
 		 */
 		while (true) {
+			long nr_pages, acct_pages = 0;
+
 			if (pfn != *pfn_base + pinned ||
 			    rsvd != is_invalid_reserved_pfn(pfn))
 				goto out;
 
+			/*
+			 * Using GUP with the FOLL_LONGTERM in
+			 * vaddr_get_pfns() will not return invalid
+			 * or reserved pages.
+			 */
+			nr_pages = num_pages_contiguous(
+					&batch->pages[batch->offset],
+					batch->size);
+			if (!rsvd) {
+				acct_pages = nr_pages;
+				acct_pages -= vpfn_pages(dma, iova, nr_pages);
+			}
+
 			/*
 			 * Reserved pages aren't counted against the user,
 			 * externally pinned pages are already counted against
 			 * the user.
 			 */
-			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
+			if (acct_pages) {
 				if (!dma->lock_cap &&
-				    mm->locked_vm + lock_acct + 1 > limit) {
+				    mm->locked_vm + lock_acct + acct_pages > limit) {
 					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 						__func__, limit << PAGE_SHIFT);
 					ret = -ENOMEM;
 					goto unpin_out;
 				}
-				lock_acct++;
+				lock_acct += acct_pages;
 			}
 
-			pinned++;
-			npage--;
-			vaddr += PAGE_SIZE;
-			iova += PAGE_SIZE;
-			batch->offset++;
-			batch->size--;
+			pinned += nr_pages;
+			npage -= nr_pages;
+			vaddr += PAGE_SIZE * nr_pages;
+			iova += PAGE_SIZE * nr_pages;
+			batch->offset += nr_pages;
+			batch->size -= nr_pages;
 
 			if (!batch->size)
 				break;
-- 
2.20.1


