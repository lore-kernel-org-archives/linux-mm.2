Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E5ECD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512386B008C; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426FB6B0096; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251D46B0093; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0176B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B2761C2AFC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:41 +0000 (UTC)
X-FDA: 84863631762.05.0976929
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf21.hostedemail.com (Postfix) with ESMTP id 694421C000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YN0QmfBK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEB/1EhxVw7xHTTvXrEFTFQel1qTuMuF1xr/NGxBIHM=;
	b=0rWRRIatfcvhkE5CFXdecZWhVFjQALstktBDXiuSA6KCXIO+PDaqJecehZnF72dNO3576N
	bqt3paIgMk4is5A2u5OpYEj4l7RmCanFcQVJ5mJFx9CTxC0Qp3tteGRaiaQ4j55Fkqy3K2
	+OcL5gBdJz6Z8VSTRTbUj5ZWaAJ6Nk8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YN0QmfBK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087379;
	b=0E4Kkk2mJVYXEzK09CVTyus5ty/rNk3Pg/Ezv0XMluNNWi8/sURGuZ4fssflPZFNl+QtSp
	/pws6JKK3OrCwY66voZZ/3vYMzr6ltqe59h0dMECjOBEc2cjA4639t6dEplTLysVHsmRe+
	Sq743POBOff+IxxodMiNUKh5IiNoi2c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087374; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=qEB/1EhxVw7xHTTvXrEFTFQel1qTuMuF1xr/NGxBIHM=;
	b=YN0QmfBKn6bgn4KZhv5TI+T5oa83GjM6nGFacrYrk5QRLwsL8A0DN/xhFsQ4/H4Kocz39dCUPrUkd73z5gsjLEq9BxFRc9ht4vyphAUNdD0EW+3zpAW+A8l1hdI8B1+yM2sH+NfK+jOwuKRUo5MyxQOjvb76SsFF2sI+xo+pMdA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aI8Vv_1781087371;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aI8Vv_1781087371 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:31 +0800
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
Subject: [RFC PATCH v2 02/11] mm: khugepaged: generalize collapse_file() for shmem mTHP support
Date: Wed, 10 Jun 2026 18:29:10 +0800
Message-ID: <1274846e121e74f8db53950bec64f8f1938f2ec9.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6n5rui9td3wxstpx77bnhtt3owqksah5
X-Rspamd-Queue-Id: 694421C000A
X-HE-Tag: 1781087377-731160
X-HE-Meta: U2FsdGVkX1/bUGEgha3C4PAhodV6A/30BTmVa5kmVHpF+ZWDUh5+asMXv6tTHYSq+CL3HzY0SZCdqs0Nv3sSq6d0wIk4t94iQlEjIQYu6s++2KLVTJ0bY5UbOY4YYCGkAkF3loRQvNEOGKlw8Toh5dGoCXwj+MGSfhUwc6QmSoX8Xed8v6n5CbiVCXd2yCbdqiR0IGpdpd7cpT+/6vyIPg8ICOrsU2XaedPDBzy9Eo1yXwQKMt+dxBId9uLN7Y9E1gdeNQuwflYUqzBvc83885sJXaepsLppEB7BrmK3GmaZ+v+vl5wDY3CAB+WyTzi0Je+xjiN/pMBR7CEVzY2p8uBFKJl6QuOPHX5gSjCtf58sAHuyH76yEAhhbkVC8LQRnQPF8zdCsaCmImigI45psft2pBfQVYLaE8JalWiOkcC7xgcS4g4LN2Tc7iJYbWajGuBDJlP4hVN4rUKYaXwhIEy4kRnMb+YV/YZWGwGR7n7Or15p3QVdxLybHIaPM28emJREtgljQQ8/r6FyikLED7oB5qwgo3SgOzSXi/lQtS9Cgx5i6AYHgWeoixDccMS/OLBmZqKRCqy/05UA6/oYTtm2ZPtEf8EDgpvJ4hg0wRn+LJUi1EoxJ39JIOuL7wc6qxxt8Xn7IDA/w9AI3UAA+esfpwQbKevlbdZ/Ve7oVbKKcP7rcbLEQ4kDKZSX+Yp4R86eMhd5tNgx3ip2MaAn1d+hf5ipt+ZRjVWOWNQWg7yg5b1gv4QMPj4cy8TgvjXNae94mR2lYloB73MHndnEenM3g5yWudL33bUZmL2e2fS9GoHfIUd6odm6/KnS9K8gg+dWHOPcT19Syh7EUv71mV7lOucvJI0pbrm7KBgfpMt8vnrVAECGRf8KJC1oGmp0uU5Z/HutaVjHV0m1Mn4YlAGvgxmEv/J4nayhGkhy5uQWBuCTkjX1dHOctfzb6NZLUhsc3aFVevP/3qafqUk
 mQORMAcE
 dscmX4mV2SDPoT4hsPoK3XQZinE2GHARqPECIB7X5xayx6IdCgSBgsSGtq4DZQUxXJQTVmhqAuMsAM2dsuqvk36OZbBG30960+IqiBREPjiyFe8eRvfUp40aiPPN8+T3ss9RUuKKJAzSyR5bCbWw6G0QKNASRNrB5p2KEa+zIAeAsLJ67IClhvCSUZwDgFUBUfsCZzOIt/P9xr9hRqeoJrdFkvWyBBcUatt3+wUBWgcXtAB0oGxGjDg+LISfsOALGpncSGPMDZ6fQ5ctYbosZ1li0pb0FCUCH2fKO4ud6HfKbvSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize the order of the collapse_file() function to support future
shmem mTHP collapse.

No functional changes in this patch.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 631459172e19..4adc8c6de062 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2214,6 +2214,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  * @file: file that collapse on
  * @start: collapse start address
  * @cc: collapse context and scratchpad
+ * @order: folio order being collapsed to
  *
  * Basic scheme is simple, details are more complex:
  *  - allocate and lock a new huge page;
@@ -2232,15 +2233,17 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
  *    + unlock and free huge page;
  */
 static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
-		struct file *file, pgoff_t start, struct collapse_control *cc)
+		struct file *file, pgoff_t start, struct collapse_control *cc,
+		int order)
 {
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
 	struct address_space *mapping = file->f_mapping;
+	const unsigned long nr_pages = 1UL << order;
 	struct page *dst;
 	struct folio *folio, *tmp, *new_folio;
-	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
+	pgoff_t index = 0, end = start + nr_pages;
 	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
+	XA_STATE_ORDER(xas, &mapping->i_pages, start, order);
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
@@ -2252,9 +2255,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 * mapping, the shmem check can be removed.
 	 */
 	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
-	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
+	VM_WARN_ON_ONCE(start & (nr_pages - 1));
 
-	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
+	result = alloc_charge_folio(&new_folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out;
 
@@ -2591,12 +2594,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	}
 
 	if (is_shmem) {
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_pages);
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	} else {
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 	}
-	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_pages);
 
 	/*
 	 * Mark new_folio as uptodate before inserting it into the
@@ -2604,14 +2607,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 * unwritten page.
 	 */
 	folio_mark_uptodate(new_folio);
-	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
+	folio_ref_add(new_folio, nr_pages - 1);
 
 	if (is_shmem)
 		folio_mark_dirty(new_folio);
 	folio_add_lru(new_folio);
 
 	/* Join all the small entries into a single multi-index entry. */
-	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_set_order(&xas, start, order);
 	xas_store(&xas, new_folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
@@ -2666,7 +2669,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, nr_pages, result);
 	return result;
 }
 
@@ -2769,7 +2772,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			result = SCAN_EXCEED_NONE_PTE;
 			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 		} else {
-			result = collapse_file(mm, addr, file, start, cc);
+			result = collapse_file(mm, addr, file, start, cc, HPAGE_PMD_ORDER);
 		}
 	}
 
-- 
2.47.3


