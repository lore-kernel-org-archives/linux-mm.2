Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD993EA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8296B0346; Sun, 19 Apr 2026 15:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0E66B0348; Sun, 19 Apr 2026 15:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5646B0349; Sun, 19 Apr 2026 15:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E3EF6B0346
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:01:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAD58C2902
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:01:26 +0000 (UTC)
X-FDA: 84676223772.30.317C5A7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id A7FAB1C0005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:01:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dIC0Uslk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYI4SonfG+7QWZk1LR8FwdFbitigpjTH5dDffgzeyvU=;
	b=mPHybxXPqZBj/H2kKE5/y0RQiCBESkFuy2fcGDjbdwYs7BxpG89aS5/d5yEn4LURuoo0xo
	QaoEyRp831su+XyKYTzv7TLHe0qZHWyUX2f/UCKltxiGNtEbuYBXeBxdRG4IOUHD0Z55sz
	z9fWFDw1EZcPnHd5eYtBpquR1e+xbcc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dIC0Uslk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625284; a=rsa-sha256;
	cv=none;
	b=4E0NN13NRHrtVjc7JKEK8sPv+hJXdNkBlIVFupoKyE9jVZfzJY/yRHwUlHVvXjw9fnGamJ
	KS2pi+1vKZbUDIMeaIgELcxBdGPFNIGmeC5QKDWGMFmg7zr+jPL+Fk5OfhFowZC7CQ1E+1
	F9+YWDw58XcZnctVDb35qo4BElrna5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WYI4SonfG+7QWZk1LR8FwdFbitigpjTH5dDffgzeyvU=;
	b=dIC0UslkYWPGS0+Uk6v0X3VUsoJkbHTqPbQckuLOTh3PwmttgfMxwoliKwkB+FDZInnPh0
	9Y8P8bhPe8x68bHwS5PqGkR19KUPZJ+dD8FiJBz3ZzWC55H4PQ8KDNbtSms8prYp7GgiYA
	RGl10YQPYYG0tk/JvGbLCguMYYWjr+0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-31-u8FOaM8ZPWaZJ5mF34CacQ-1; Sun,
 19 Apr 2026 15:01:19 -0400
X-MC-Unique: u8FOaM8ZPWaZJ5mF34CacQ-1
X-Mimecast-MFC-AGG-ID: u8FOaM8ZPWaZJ5mF34CacQ_1776625274
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01FB718004A9;
	Sun, 19 Apr 2026 19:01:14 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29723195608E;
	Sun, 19 Apr 2026 19:00:57 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH 7.2 v16 09/13] mm/khugepaged: introduce collapse_allowable_orders helper function
Date: Sun, 19 Apr 2026 12:57:46 -0600
Message-ID: <20260419185750.260784-10-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dMlHMP9cOSZvswYbmSfR1_Ozs1R8MgNRBWOChOwPa6k_1776625274
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7FAB1C0005
X-Stat-Signature: n4pmj9wsqhetx6zw689g44po9ygoncqr
X-Rspam-User: 
X-HE-Tag: 1776625284-987878
X-HE-Meta: U2FsdGVkX18IS0ty6kc3he+pCmHloM8+LCPsYf1ckxoeaDUQs0RhdmIzTcx+Z1BlRfK/wiDgiPdKHs0X0mYZJ8ufsKwnRNu4XQlLnCPX9A/dLlWdsSrFYbQnOt15+A0XgzZTW5Pw1M1VOjwm4D81PXl7CHtEOLTSugKUAWcUXFIO9n0JOYTmJkWZcDzEC3/4aOv3Ui7cwjHtj7gWovNvHtalU6U/fP/R7bS1+oE3Dj2KhEOPd4I1ryHxp3m2suO6b9tQ/zmHObCbJVmvSKRFel5YFi//M7uuH9h3UNwUHlD2mSaGWax7BWhVm/MUgauW+30H84YZiCmf9a3KR+RrDdBOWJmQjXJGGGRMX5pBNGcPVWSqMPQpCseeyumuXTUGb0+ENPAOZyIJYX+KPZzV5OmnSHyHN/yI5XNNSdyWFbfQjQI9bqrKUi4CWInAfUaejipuOEaQ+BqR/HKKk4yDsgMZcNpzaloUbCIkRTUDb31JoP50iv72ANYXRJrJ17a+dLbkUC32R3wxVFeC+efSRUKcQM2KekNdtRgNSpCgD2h1crG8r72mlpsxqU6ZQj4r/Fe+0+zi2V6IcbGjyr1I21M8fGn73Zd+w0SXfbVo5XhPDbSsEpN71aUxHHclh2fVmvZIATopDSKC/P5fyDUnB5TjuGRvB8oaqiWeMoT7sXrfF2ZXj4GUb9iqdmz2CtSwo5aEnLNd06Io541nQjDAixRvvAkV2g4kWMCqczT2ggxHYwlQlcjFKAExnw05w7k9ajyQQwsJYZcKayiS6oXXdOk+38oOVZb+q5/UuPMKHDG7wbUFYH7b9eTqFb6x1/5cUikmgglDs1dc3G7bSE427pnjvUbAbY2E+A6ZBaktwH5fLxe5OeA+5d8J3xWsf2zKBI7ubmFTfxFxYG3RyldYOqiFL28jCLRI3gh+Kva8DLrn6cCXplPY1bOxY+j3lu5HRYs2kJim82dcM65/4AU
 SAbAONXl
 ibLew4OAvIRJKWS0/3EBiWGLseaxC9Qzp7cR/QpZ5n/Nz6aAtQX5yPfIYbjPozxTCJQ4jcA63CK5T9aiEE7VgRBoZUS4rzWn53qooG+9SYIIzqSF9yVHvk0hY2zivA8TwC9YXxH89h3xGZU3pcz9eMJJ0iCw3zhiRCg9dADTxYPO2W+qLvrYdUtviZ4UCmNSIqJjajhc8fM1IvFwH21sYQg8ZLOqaeCg2r5sYzMbM8ylY+y0Qwd0AY/uLGILaY4HGdbD/FW0BrX1RQ82XCvznLo8V9H4JG/NEyRESykU0jWCvh0m86rj+tXwdfH47WNrYuEJGjv+pFtGJEZgFOfBTl/E7j3wHTIeSbAszL5xRPACK9lRxtmJIHkTp1I7xc/tRbbq4DteS3RZs9AVlxha1vtYC4+uzB3fh5GSwX4b0ueykEbp1vJa+ZmEdSxA48C4lrPvUWMnf/92CpvRQtrArJbAqRYC1lhAdyRWK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add collapse_allowable_orders() to generalize THP order eligibility. The
function determines which THP orders are permitted based on collapse
context (khugepaged vs madv_collapse).

This consolidates collapse configuration logic and provides a clean
interface for future mTHP collapse support where the orders may be
different.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/khugepaged.h        |  6 ++----
 mm/huge_memory.c                  |  2 +-
 mm/khugepaged.c                   | 20 ++++++++++++++------
 mm/vma.c                          |  6 +++---
 tools/testing/vma/include/stubs.h |  3 +--
 5 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index d7a9053ff4fe..e87df2fa6931 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -13,8 +13,7 @@ extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma(struct vm_area_struct *vma,
-				 vm_flags_t vm_flags);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
@@ -38,8 +37,7 @@ static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
-					vm_flags_t vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5c128cdec810..1023698a8b96 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1557,7 +1557,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma, vma->vm_flags);
+	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a4f1c570b69b..fdbdc1a1cdd9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -447,7 +447,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		khugepaged_enter_vma(vma, *vm_flags);
+		khugepaged_enter_vma(vma);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
@@ -546,12 +546,20 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+		enum tva_type tva_flags)
+{
+	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vma->vm_flags, tva_flags, orders);
+}
+
+void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_allowable_orders(vma, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2664,7 +2672,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -2973,7 +2981,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
diff --git a/mm/vma.c b/mm/vma.c
index 377321b48734..c0398fb597b3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -989,7 +989,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		goto abort;
 
 	vma_set_flags_mask(vmg->target, sticky_flags);
-	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+	khugepaged_enter_vma(vmg->target);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
 
@@ -1110,7 +1110,7 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	 * following VMA if we have VMAs on both sides.
 	 */
 	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
+		khugepaged_enter_vma(vmg->target);
 		vmg->state = VMA_MERGE_SUCCESS;
 		return vmg->target;
 	}
@@ -2589,7 +2589,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	 * call covers the non-merge case.
 	 */
 	if (!vma_is_anonymous(vma))
-		khugepaged_enter_vma(vma, map->vm_flags);
+		khugepaged_enter_vma(vma);
 	*vmap = vma;
 	return 0;
 
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index a30b8bc84955..3d9a2daa2712 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -182,8 +182,7 @@ static inline bool mpol_equal(struct mempolicy *a, struct mempolicy *b)
 	return true;
 }
 
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
-			  vm_flags_t vm_flags)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 }
 
-- 
2.53.0


