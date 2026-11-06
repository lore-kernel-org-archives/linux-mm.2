Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A492E606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Ago+KLWk
Received: by kanga.kvack.org (Postfix)
	id A59236B05B8; Fri,  6 Nov 2026 12:05:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09BD6B05B9; Fri,  6 Nov 2026 12:05:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F846B05BA; Fri,  6 Nov 2026 12:05:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64E8F6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:05:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E83561C1F1B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:05:26 +0000 (UTC)
X-FDA: 85405320252.12.EA54CFE
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0BCEA40004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:05:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=Ago+KLWk;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf17.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793984725;
	b=e/VP5fUcAkYsLD6yFlFmF/8KI8HaNePljKknAPCLx4tGRZKIk8s1ib4nA/qPTdDMFNPHCw
	IKgzXjRzE6KrffixBdNdaDuOW5ZIh8hXHPW/oGjqR372/jeUFNuPYDX6+mBXnmVZ21eNVX
	4THi9pFCsHDvtSD5+OgumiruKv7zAcw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793984725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LqH9iMIGaGgfrltDU+0qHbUT1ie4g3kkbL58F1jr5Pc=;
	b=CJrSSKaIrDRWZ1Ma4WRcFTILf/AMKPFygSqyf0DW00maNE7H7PO7gre2MKEpLWdcaWnKCT
	rH0JqimlHvepoa75AcIig2yptXhThM6AYKI0ifQlCQDpv7rdbM3P1Eg1uc6XI6L4uRBQNs
	caDZcBwZIBW3hpBuSASxG9MrjrvaEzw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=Ago+KLWk;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf17.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=LqH9iMIGaGgfrltDU+0qHbUT1ie4g3kkbL58F1jr5Pc=; b=Ago+KLWko091EDuZeHQ
	xy4CpnbJrV3UtJFWa/DKDNjFPXScS1j02Z/HD+SIdAiU/sGojmXnMMdoBcpTl5UuNjnuPQcOBXYg5
	tdY8AVDg0m9ETwjl0V+ANAPL/LzlSk4ZmQ2K8pR2Yuaih6M0O+Ah42qtt3fMvd/rS5UEAZ0+gg8Wo
	aMQlfaunc7lyAcg0af9VGeEcgDBX6jaLKRBo80xp3fx8ndLNqW5kLe0tAAtJv+gscRrioHhxF1+9o
	nqS2GnBc+Eg06N4bD0KqJyWaq/er2+KCnhK4v3X3OgcUw45U6Rou8m7F54o6XhdJAq/pGuFUsVxO9
	LIn6HYM3b6a7Fnw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xPNJS-00F6fe-1u;
	Fri, 06 Nov 2026 18:05:18 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 06 Nov 2026 18:05:20 +0100
Subject: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
X-B4-Tracking: v=1; b=H4sIAM8I7moC/yXNQQ6CMBBA0auQWTtJB6UBr2IIgXakldg2LSUaw
 t2tunyb/3dIHC0nuFY7RN5sst4V0KkCZUY3M1pdDLWoJZGQuBgf2S0et7T6iNQQtWdUPrwHk2c
 eQtaoc8D4HAO2tRDdRTVy6gSUZIh8t6/f7tb/nfL0YLV+H3AcH7uGbvCQAAAA
X-Change-ID: 20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-820094c56b90
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3715;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=gxuw6LjVBrmV9639XN62UX0bOkR/j46xaDVTVYxMcMc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7gjRCymH1gaE3n+O11UPy5GKgSUYwmvmhhEug
 XGKykHU5QWJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCau4I0QAKCRBRlgpH+WFc
 KiAYEACov2BLVf6uA7xgliUWGHkOGWR3GCd3SE5HdxqeC9cfajx1YRp+3ZXchQbMMFjnjzeq/md
 y086jisNW1nF4Th1SH8pAXOWOwD4PwbOW/GVAZrQFJcUFW4g48vZW/aFDOqThcvg1R9QUfpkYAF
 MjRrB0i3xJzMEMaXtWt44wQeeRxJP9tq3yMqJAoXz15NTStwwvdCG8PAAZ6pqoh5PezLcf5m59g
 udW0MGwNMOrC/IukbEzvSb+KuwSeOk63FS4dpDr+nJd0oPHzKTzLpJ7Cmio9Ge+FIWlN2mh6cdr
 83SvhFTQG0GNCm0z8qTAe7TiJMEWcnTm6nIWA8B1jSCD7Zk9OTxe45GEdMmkfRZU+BYNIeq8jPU
 myeEL6Uyg5fzo9b0ch1ln9qXG0TIzs/LJ0dWkVsj5ikVLQjnIGSw3CarWo/3UQLsbGMFN03Yge4
 vi0mFfz8tplVJFzxHviraCZTnHqCVq/9K6gj9eOwdd1w78zjmmiKE7DGHcDQmlOisHbJoSnqS1W
 dvfXCimmSQITK9Sna9W7BJEDWzSZbw/QV+60OLvceSvmfqWEEpXiueADyXRHNHW8+95XSz+e/iD
 vFN2o92Y3OkOF2otlb9DeT6ZikMcAglhovQTQ+HyrYVdSo64RZTVFjNcCW8r4TnOaQOzr/BLhpW
 oJasVA+qM7v7wxw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Queue-Id: 0BCEA40004
X-Stat-Signature: uyk73zbgt6wobwodikc4ohiemgctszy6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793984724-900387
X-HE-Meta: U2FsdGVkX182Y9BeuHFSm3EzZSVmjTq+iS0ZFhhSFEVFF4KFFtW7uMCiU5yjT8fKvKuXmzoiuX7zo4FKCODN1L0VfpfW/voS5j/W0qwwJXeWlvWXkvKa9HUrFveFCjmRn73uqeuVN/IReZR8YySp04+oDSOJDVLzJTVzfj2et3VSaGa6Cp/QMaaWnJQFK1zPbmR7gx2alOCFY9FAQH6YLygprJNQvQ2Mii2cqIAZIyyz8B1o7gYNLP3LTAfOwNcC27iZicCsXiWl3UhD/C7GVzXkQRKnMeqFiYDh3QaQN7jtWbXw7d2T4jxCcw3qr88x2wZypRdQIOkWTS1VLtXPq674rPwpr+CLSco2Od6YlKfvLiQqQlDsQhOZRNBSRGOB1x1eRBihH4Ice8xVohFn1n5vO4hRdlTQQ9nBW47Ijdq875XMk9c+s6ZTvDeXYSNNja3ss9NYJ6WBRs0WV+8f5jRZUvnNim3WMzlHB8JMzwbWsETug1UVoJmjHG7vLtPkt+9Tp8ua23jei4U0an7IwyMOKSr9keRICem+7ZjzaQcz+GTDjCFQF1fGKg37PytuqYWlXBdkA5HeZ2Zv1JHvJTzDvqs4kACz8tsGQq6gbmJGaNdfCQIl1Src4+NzxebmMPMRdFwsEaI5xhlpnylhsFDW3T6y+J/UAQs9prXxvDoL/PurGWVimV/9Jvixczp9Izm1B7K0sCQoSjqJjhhnq71yHIrqyOHMBImNLik4rs/BAwkFvpi1cEP+pkbC1brjQ4ZJkrQfM/POYTWtzxtLUuDJrHJ4n2qfNJhQv65l62OWcUpRqT14neoY1aQBaLEl4yce1Ma07Da7foHSksF8bYvCmy+yktt662N5Sw+0O08UA7EbLs47I76RuhBpIR277NPedwKFkGDDGgsCbZqWcFo7SK7zB70K5SLuKdqhSIuhi6t066cyLP9lZmJvtah/PZWFlTG/7w25DSy02PA
 alkuCN8T
 UGU1S3o9l01a0rF/3hDtuM31P4a+ZcZlmFLMUqLNX99HZDljI52iMPlfX6lbU1LfeUXumcRW/qsHQfYP0BZ0c8PcUpAC8B5G814/c8an/WiLDF1bEI06pzds8VeCh/8LeETZKQBn4XjMfGklzURBhKLzyuBG8dleYgTPNasDg4GvWpx2eJTKNECm9qvhG+Q+p7yK8d0hwF3b1R/M3ONPDZiFijhPHs6yHx/qdbdc5ByCQTtZbKnx/nCrnHk7vPu8q+9KPojSRkrt3jAGycF/wr+ENEGes6iT1MHyDjj/bizjCcPXWKIWueNE3GIzcEIFY5YJhqI/X9j6s/5mLhQb2NGU3CuBtNrWqmv3frfqCdGvqmXPLXGn/h5Ed96DrZtkSXmDJJpnE9oTmjQwAVG/ZXKMAjaeJhVYPKxhT3rfakDoIzy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_huge_pud() adds the child's rmap of a device DAX PUD with
folio_add_file_rmap_pud(). That helper maps a folio afresh: it updates
NR_FILE_MAPPED when the folio becomes mapped and mlocks it in a
VM_LOCKED VMA. Neither applies at fork: the parent keeps the folio mapped
under the page table lock, and dup_mmap() clears VM_LOCKED in the
child's VMA.

copy_present_ptes() duplicates the rmap of a PTE with
folio_dup_file_rmap_ptes(), which only raises the mapcounts. Add
folio_dup_file_rmap_pud() for the PUD level and use it in copy_huge_pud().

No functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
David's fix for the device DAX PUD fork bug, commit d90bdc02e36e
("mm/huge_memory: properly handle refcounted PUD mappings on fork"),
went in before v2 of my series for the same bug [1].

This is the follow-up David asked for [2].

The Reviewed-by tags are from v2 patch 1, whose rmap.h hunk and
copy_huge_pud() line this patch carries unchanged.

The selftest from v2 [3] is not included, as it needs a real devdax
device. It is there for anyone who wants to run it.

Based on thp-7.5.misc of the mm/core tree.

[1] https://lore.kernel.org/all/20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com/
[2] https://lore.kernel.org/all/6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org/
[3] https://lore.kernel.org/all/20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com/

Assisted-by: LLM
---
 include/linux/rmap.h | 22 ++++++++++++++++++++++
 mm/huge_memory.c     |  2 +-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..52fff8dc74213 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -564,6 +564,28 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 #endif
 }
 
+/**
+ * folio_dup_file_rmap_pud - duplicate a PUD mapping of a page range of a folio
+ * @folio:	The folio to duplicate the mapping of
+ * @page:	The first page to duplicate the mapping of
+ * @dst_vma:	The destination vm area
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+static inline void folio_dup_file_rmap_pud(struct folio *folio,
+		struct page *page, struct vm_area_struct *dst_vma)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_dup_file_rmap(folio, page, HPAGE_PUD_NR, dst_vma,
+			      PGTABLE_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, enum pgtable_level level)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d0e19d9e6b651..13caf81cb51af 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2100,7 +2100,7 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 		 * TODO: once we support anonymous pages, use
 		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 		 */
-		folio_add_file_rmap_pud(folio, page, dst_vma);
+		folio_dup_file_rmap_pud(folio, page, dst_vma);
 		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
 	}
 

---
base-commit: 31ea5515bf595046effc74a5bafdcc26320d2d86
change-id: 20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-820094c56b90

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


