Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B14CCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 13:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9AFA8E0012; Fri,  5 Sep 2025 09:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72FB8E0009; Fri,  5 Sep 2025 09:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAFAF8E0012; Fri,  5 Sep 2025 09:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7FAF8E0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:21:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B704C01CB
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:21:29 +0000 (UTC)
X-FDA: 83855258298.17.251E343
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7185EA0004
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 13:21:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGeu3sbv;
	spf=pass (imf15.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757078487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+ErkcM5ydIShVlp/tyt/SXag8Ues3JjwXCCvd9mJD34=;
	b=Pdprm/hLrKJPUBkwnBaH3BOUz9VC9iz5BsIJzxpX1rYjhT8mp1J92ZHqVDCHOfLIT/fw5Z
	NYY8W/KRPIAUYyOBRQFyqd8rkftCOW6AjWGY/CKpo5BvKEbh4FvK99x9TZT2vmNjWyavQH
	KH0AhwjQEMCu+kpKmZ8d5/VwS7WI7fQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGeu3sbv;
	spf=pass (imf15.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757078487; a=rsa-sha256;
	cv=none;
	b=lpHRkt0ENMXfAOsSMS/k+nPvf5fFtxkrsGPfsfbi5+uPD3UqQZyxMLH5mpgUYc5rKC1s+8
	W+0GJVJymLBtmtIEk61aoCd7f+DRqgdsCClOFiDEVlzZwh38IhPmCTNRyAuLo6z1I/LevU
	FMCu7uRmKYYhNb4ZOYCah3hjXrzXLe4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757078485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+ErkcM5ydIShVlp/tyt/SXag8Ues3JjwXCCvd9mJD34=;
	b=qGeu3sbvk+L1QKKYBhlIRF/rq4VAH22HI9Bl+BusQN9C4CgQhqRvbK9EtlLMfJ9HnYNQKI
	8cjWc1ZxpTsLzOLIozlvtI3Wl0cd18Z+0Tq8GSD4MCSppQG+UxXdlX7k+PemCmImmhUECn
	qaUoPE9F+Vohqoptq22pqqVMSgPuxLQ=
From: Yajun Deng <yajun.deng@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] mm/rmap: make num_children and num_active_vmas update in internally
Date: Fri,  5 Sep 2025 13:20:19 +0000
Message-ID: <20250905132019.18915-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7185EA0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yyyyhpmu7kgatizz3114ky1c1m7aryw6
X-HE-Tag: 1757078487-378060
X-HE-Meta: U2FsdGVkX1+D+kPUjXq9PtpOenZ8ZLiR4C9WenC7fktO9pkPvN0JLB7LzIL2gl/wnDIxSpQaZ9zh8w3s3Ny1Yy14KKdmstnOSOhTFSHlUzXLFufoK7QQyNyvnRjYXsHQx53EzrxYNt6dK86hz00+IsCnkOKFx9AUluR0EabpAy3AR5VwnHhjOmUyvfEu4/XW1wcIqUdA9ZEO4vJi2klixQ4arqrsu/MlYwuCJUMHY2n3KLHsC9EOgNffJ61pzXP7zuCZLsyV/gCd+NtXSxeFtNOqmSLRs07DB5oo7vrJVSyNAES+UOvt+Tf5sW8wA1zCJU4IJtYUeEZmMIfWh9YBE1sqIvq23G78FhiobqcdqUAV9qRN2dDwp7mfeeMekC/EKZdmikGERdjRUpKS6DemfPoArsiBegYqFASMpnQoMfz2M0w455N6+PQaW/d+S2inpfbCpG2L4QCLYCEWah/St958Mr8/qSHhqNWg3Wr4BcpFxvaT/eV4xQvAQHUp03eGHxlDyPai6IDCPUPr7vrYZDlmtsP3aZrwm9aAAyxOL2bHLWIutCp+hhNe8ew1b7y6WIo+b4ItLhYOWbeEBR2K5q6MiIYyIIiQolJIhn9aZp70iiHGOiY+Vf/fru30ITd/GvmNEdcM9vAJCP1lxsmAcEPd0HEt4MPzy0OR8fFD/C+0elkuEmDUuwoYamRaf6rbE4xzIuiX5IHwxc6rTNp629QD9c4q1Kg+6w2PTRX0zcFUGtBA3v+Ayb/9zr+mm0QNhH/6KHYK9dYgc/ISEOx60WMDsTHGhHylZASJY7BsNencb/yaGn/BZNeYwkqYE0cZajLFVn9j0BTjxBZ82Tsxyq2YFCLIgzZfYe0VdgY+Vc2W3xj+RmLEX3gdSXMcbzhI4xhn1/2zqQtpSvBfMK/1XIbEZ5PCgGTOoNKCq+q7LN+nDB+FPXY534TPTP2LBbuPlKLb/7rangd5LM32hBp
 b77Qx+wm
 CZ1VT2DxqdX/v/ofONYeqBh5XaRneRosvd04IdY/YuSR5GptfUssID+QJ8rRMWGD62aHWevb5zJIVM+dvT2nryUKuMPWkLUrLMZTxfOADf4QdqNLxk4rQRHFg/BQM0XUTf9RTebCPZzHgrDFkDzyXx5BxfxdaFDc0VyQlU0HrTWVmba/bEIKGLjRfXx+r6MlIkUxpDXGyUdpXgopuAojRmwBIMZWBsH2qOhIvCxCiMvoMJoY0PjHfa5nVQ3Z3UgDsR4ayq1T5QVZPf+i+6BGHeO7AXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the anon_vma_alloc() is called, the num_children of the parent of
the anon_vma will be updated. But this operation occurs outside of
anon_vma_alloc().

The num_active_vmas are also updated outside of anon_vma.

Pass the parent of anon_vma to the anon_vma_alloc() and update the
num_children inside it.

Introduce anon_vma_attach() and anon_vma_detach() to update
num_active_vmas with the anon_vma.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 mm/rmap.c | 63 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 34333ae3bd80..2a28edfa5734 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -86,15 +86,21 @@
 static struct kmem_cache *anon_vma_cachep;
 static struct kmem_cache *anon_vma_chain_cachep;
 
-static inline struct anon_vma *anon_vma_alloc(void)
+static inline struct anon_vma *anon_vma_alloc(struct anon_vma *parent)
 {
 	struct anon_vma *anon_vma;
 
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
-	if (anon_vma) {
-		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->num_children = 0;
-		anon_vma->num_active_vmas = 0;
+	if (!anon_vma)
+		return NULL;
+
+	atomic_set(&anon_vma->refcount, 1);
+	anon_vma->num_children = 0;
+	anon_vma->num_active_vmas = 0;
+	if (parent) {
+		anon_vma->parent = parent;
+		anon_vma->root = parent->root;
+	} else {
 		anon_vma->parent = anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -102,6 +108,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
 		 */
 		anon_vma->root = anon_vma;
 	}
+	anon_vma->parent->num_children++;
 
 	return anon_vma;
 }
@@ -146,6 +153,19 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
+static inline void anon_vma_attach(struct vm_area_struct *vma,
+				   struct anon_vma *anon_vma)
+{
+	vma->anon_vma = anon_vma;
+	vma->anon_vma->num_active_vmas++;
+}
+
+static inline void anon_vma_detach(struct vm_area_struct *vma)
+{
+	vma->anon_vma->num_active_vmas--;
+	vma->anon_vma = NULL;
+}
+
 static void anon_vma_chain_link(struct vm_area_struct *vma,
 				struct anon_vma_chain *avc,
 				struct anon_vma *anon_vma)
@@ -198,10 +218,9 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	anon_vma = find_mergeable_anon_vma(vma);
 	allocated = NULL;
 	if (!anon_vma) {
-		anon_vma = anon_vma_alloc();
+		anon_vma = anon_vma_alloc(NULL);
 		if (unlikely(!anon_vma))
 			goto out_enomem_free_avc;
-		anon_vma->num_children++; /* self-parent link for new root */
 		allocated = anon_vma;
 	}
 
@@ -209,9 +228,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		anon_vma_attach(vma, anon_vma);
 		anon_vma_chain_link(vma, avc, anon_vma);
-		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
 	}
@@ -306,10 +324,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 		if (!dst->anon_vma && src->anon_vma &&
 		    anon_vma->num_children < 2 &&
 		    anon_vma->num_active_vmas == 0)
-			dst->anon_vma = anon_vma;
+			anon_vma_attach(dst, anon_vma);
 	}
-	if (dst->anon_vma)
-		dst->anon_vma->num_active_vmas++;
 	unlock_anon_vma_root(root);
 	return 0;
 
@@ -356,31 +372,22 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 		return 0;
 
 	/* Then add our own anon_vma. */
-	anon_vma = anon_vma_alloc();
+	anon_vma = anon_vma_alloc(pvma->anon_vma);
 	if (!anon_vma)
 		goto out_error;
-	anon_vma->num_active_vmas++;
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
 		goto out_error_free_anon_vma;
 
-	/*
-	 * The root anon_vma's rwsem is the lock actually used when we
-	 * lock any of the anon_vmas in this anon_vma tree.
-	 */
-	anon_vma->root = pvma->anon_vma->root;
-	anon_vma->parent = pvma->anon_vma;
 	/*
 	 * With refcounts, an anon_vma can stay around longer than the
 	 * process it belongs to. The root anon_vma needs to be pinned until
 	 * this anon_vma is freed, because the lock lives in the root.
 	 */
 	get_anon_vma(anon_vma->root);
-	/* Mark this anon_vma as the one where our new (COWed) pages go. */
-	vma->anon_vma = anon_vma;
+	anon_vma_attach(vma, anon_vma);
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
@@ -419,15 +426,9 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma) {
-		vma->anon_vma->num_active_vmas--;
+	if (vma->anon_vma)
+		anon_vma_detach(vma);
 
-		/*
-		 * vma would still be needed after unlink, and anon_vma will be prepared
-		 * when handle fault.
-		 */
-		vma->anon_vma = NULL;
-	}
 	unlock_anon_vma_root(root);
 
 	/*
-- 
2.25.1


