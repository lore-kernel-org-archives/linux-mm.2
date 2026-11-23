Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 917BE606A334
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NJBBIlCN
Received: by kanga.kvack.org (Postfix)
	id B2A096B05B3; Mon, 23 Nov 2026 05:41:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADAF16B05B4; Mon, 23 Nov 2026 05:41:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0F56B05B5; Mon, 23 Nov 2026 05:41:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 802346B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:41:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A55A1C41E8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:41:50 +0000 (UTC)
X-FDA: 85466043180.04.F57CC45
Received: from mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	by imf31.hostedemail.com (Postfix) with ESMTP id 004E720004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:41:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NJBBIlCN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.205 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795430508;
	b=ASxIGnvrryaAWBmKy1BKHH3mftwVk8ZTW+YpOk7tiGQzH7h3hyzhtAeKiMvPqEH2QDgAdV
	+q/A8PsJRB/DEPjT+Cuquup/9nhxc9DaBAEW5G4xzAG9ZUC2SA1k5ob5OZiKR/hHgUgvwI
	eMHEOqw8NxGu8FjgNll4CvIclctUn9w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795430508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MND2gXWBxhr8dXIEz1K7tu3YQTgZtUI14WVbyk/Hlmc=;
	b=lab36uOkc8lfRnxYy72zTTxjVrIxJR7R3DHkMz87obXcfiuFsIdn1OoP87XNqrLeIFkmfe
	QHCodZGHT7MNaxk18t2AFcvKkLRN0E/zC0OX80v/Y4m4xfOI6oJgf360TRBzutenG2sxD5
	3PwUnnlIbjerKtwTtngkyI51s2RxOKI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NJBBIlCN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.205 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y+2aFOJdNqO3B426W22gxsYpUvD57l9xFa8AYlK0V6o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795430506; v=1; x=1796035306;
 b=NJBBIlCN4zr5XONfKo8IG+8jqyMiCzgxWPvoKUa1N6AfhSYsLbmIJUcJk/pJ97xW5oq6biCU
 FM9kfFA16CndOiI2OYDD9ghqEWuWd9lgX1Srn4DC7aU0GPxvZyw2quv561fH0o6VD0M5R976BIp
 KlrLZNq5jHxCprmrD5A4nXnk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 100b1cd08c6c74a4;
	Mon, 23 Nov 2026 10:41:46 +0000
X-Mizu-Trace-ID: 100b1cd08c6c74a4
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Mon, 23 Nov 2026 05:41:38 -0500
Subject: [PATCH] mm/rmap: flush the TLB once per mapping in
 page_vma_mkclean_one()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev>
X-B4-Tracking: v=1; b=H4sIAGEYBGsC/x3M3QoCIRBA4VeRuW4gjZXqVaILf8Z1SC10i0B89
 5W9/OBwOjSqTA3uokOlHzd+lwl5EuCiKSsh+2lQZ6WlVBcMZDbMGfPLJTIFrdlcxJC+LaK+aj9
 DebOLgnn4VAr8P+6P5xg7LR5e6m0AAAA=
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 004E720004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fxj5wmyxbka6aqdychi4h1ahzzxm65k7
X-HE-Tag: 1795430507-584780
X-HE-Meta: U2FsdGVkX1/yxFAsEsqAH0HBBnTtDPnDlcV/HqQNU9PAc5loKISkbj7mGsETutsKvhanh0sB+zBWKKvS3oog5Mv0zUZPOreYy0y7oEbFLPNn2uAh55e4hMCiNCpbHVJxMENtUcFUz9qmnOvTtou4KQNTjW/KwXsIV4qKb8ZABWUWLtbHLu4qJMH8lXGqBx5+tO0x1XjZPL49V376W3lmc7kklJBt66vb14udDdmdwjvrB3wunx9gmteXBL46GqTtgfRkWSwrnnBulBFlSp2bdSSnN3MOIiGXHKbtcmoePASXicspsCzy+yWExnKJTxdvLUmV1G02XljRm+tQ5Knkd2Ri69vXZOyx2UMfcjnKYWs5S7zjNvlIBKLlerubS3la7Q+/Snlu4mWbrK5mOizW1YjnCqLoPht+SIsJioeaNEXFhylvK/SGUa7uHurE485w7Bfje/5jEaXn19OGMBLsdHFPLz78fQ82sOtPbNDRJGckwdwBfLjNekxy8tyeraLjGcqplLhnOAvwGUazo5aGR2pb73bKQjyBsd2jsS+zwhiuhvlZC6dXWaVLGtAdx63COq7l/wEc0e7qlvgQk6eYOTQceB2vz1NnHp6UkXo+kO184HF5A5jSnRjTTosn/kw/9Vh8o6GQGNOJmo74PQeaCTirQQtMy86sMeOtmBtLqhOU6nINUM2NcUBosZnOXS3KTFsbqc0BekISyHSOXQA7zNm5nDssu+y/tMAAMMdBTMTIXQ32j4yLJQlOkpt8gkOPMN2pkbGeyRzIBT/cg82j5ULzjJuAMwiEh2TpgapJ4KHbKOA/T3qvuAX5QVCBqtcWGQmpgckVPkrxA3/rx1KCzlnsH8T+6BSpkHRoZil3zazoWoIajcvGvEtcvl9QUqV9ci3Itl2Dr9ZHTG7GGKkMgjUTX20KqGzG6jMlf/7I9ZezXUogTrYeKUiehgF4/E7IFCK7ol7QZXzwMmPSHZO
 7W6/4kly
 dy12YS1W7DduxFOIgwSzvEOFHi7D1qkPlUmHc/YMH+4yDI8QN/p0qPM43b5OQmMX9eC/dIZKPiQFFFQUpATN9lWYYtLne+D9dKCmjiTulzaoqt0d4ce5OTa9+pS1Vk14x+e0uE8RRZaIyFg0VrS+/YEqK2DcIUuNrvPdv5ph1aRCpwwr6Re4baKiMmVVu7xkwCk6dnppDe1JFqsOTohIIWMAF2oUqKZEhZGR5OYfSWHOIAP6R6YPlvsz3wHiAyhuEXzkpcaTuwkjTzSJrbtbB1JlQFz1TS571oDuj634RlJwGLyMF+xjDMgYTf6iCVNPxglBJm1yWgFZwdHGyxQKAMIZvV5HpGD8yHjNmzru1yfj6pkgyJRVlQ0B7w2K4KC+AhPQrSssJpE5Y/2yAF/Zf3IhwL91ldLiEsKXBOz+tjVMsCofme3ZE3iqzGaW3A8Mlo0zPcSdJg8im8NS2nDM6kjIsvCJsOEwqmlXB8931nAp3uOyqoTD7JdOvLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Writeback calls folio_mkclean() on every folio it writes, which
write-protects and cleans each PTE that maps the folio, so that the
next store through the mapping faults and redirties it.

page_vma_mkclean_one() does this with ptep_clear_flush(), one TLB flush
per PTE. A large folio mapped by PTEs thus costs as many flushes as it
has pages, each an IPI to the other CPUs the mm runs on. Writing an
8 GiB file through a shared mapping on xfs flushes the TLB 2,097,152
times for 65,575 folios, and the writer spends about half of its time
in the IPIs and flushes.

Write-protect and clean the PTEs with ptep_modify_prot_start() and
ptep_modify_prot_commit(), as change_protection() does, and flush the
range they cover once after the walk. The flush still happens before
folio_mkclean() returns: stores through a stale TLB entry complete
before writeback reads the folio, and later stores fault.

Writing an 8 GiB checkpoint to brd through a shared mapping, one file
per writer, then msync(), median of 6 runs:

  fs     writers   before (s)   after (s)   change
  xfs          1         5.57        2.98     -46%
  xfs          8         5.37        2.10     -61%
  ext4         1         7.88        3.90     -50%
  ext4         8         5.10        2.02     -60%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 mm/rmap.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 65646ed6fc453..4c3d9cb47e550 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1127,6 +1127,7 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mmu_notifier_range range;
 	unsigned long address = pvmw->address;
+	unsigned long flush_start = ULONG_MAX, flush_end = 0;
 
 	/*
 	 * We have to assume the worse case ie pmd for invalidation. Note that
@@ -1156,10 +1157,11 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 				continue;
 
 			flush_cache_page(vma, address, pte_pfn(entry));
-			entry = ptep_clear_flush(vma, address, pte);
-			entry = pte_wrprotect(entry);
-			entry = pte_mkclean(entry);
-			set_pte_at(vma->vm_mm, address, pte, entry);
+			entry = ptep_modify_prot_start(vma, address, pte);
+			ptep_modify_prot_commit(vma, address, pte, entry,
+						pte_mkclean(pte_wrprotect(entry)));
+			flush_start = min(flush_start, address);
+			flush_end = max(flush_end, address + PAGE_SIZE);
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -1193,6 +1195,12 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 			cleaned++;
 	}
 
+	/*
+	 * Flush the write-protected PTEs once rather than one by one, before
+	 * the caller writes the folio back, as change_protection() does.
+	 */
+	if (flush_end)
+		flush_tlb_range(vma, flush_start, flush_end);
 	mmu_notifier_invalidate_range_end(&range);
 
 	return cleaned;

---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20261123-feat-mm-mkclean-batch-flush-686d20219b52

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>


