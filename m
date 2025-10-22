Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39445CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922E48E0014; Wed, 22 Oct 2025 14:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D32B8E0010; Wed, 22 Oct 2025 14:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79AA88E0014; Wed, 22 Oct 2025 14:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 639688E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:38:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED29C160921
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:57 +0000 (UTC)
X-FDA: 84026611914.06.707C3A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F76AC0013
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:38:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3bPU9qO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158336; a=rsa-sha256;
	cv=none;
	b=4j2epfmv5Xh+SZkJxDk1LFj+yN1d5OjbtKnzYBBv9l923gqwK+SgX8MQ7n+ZagQvJg47MU
	dCnyzSO9zKVqIE0HA/bkZ04pe3ZnMtDmKRGHySM0Nhu04Z3fa36OHnJ6wPUQ+3fYswNNRG
	U7TJhFET16700qlVZMOa0/KzbTYYtZQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3bPU9qO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VB9dZuynB9+Ip4qi0rzf97k8qp+qo1UCZMO5JXQKp2c=;
	b=KNFTGX+bwjOoJBWolhyP65JULReXna+Q/Nrs6x9skyQbAQJsc3LuhRWwLUeBFMZMBEFr1p
	PiJpZeMxY6ZzCi+GFL2KS+OzrIVm/a5KNRbRGnCLvP/jJgNGfEjQRqUh/Y8x9OV8QTVL70
	UeWfh5FXnw5Tu3+RmKz4H/Pk5VtLeVk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VB9dZuynB9+Ip4qi0rzf97k8qp+qo1UCZMO5JXQKp2c=;
	b=O3bPU9qO4iWrurwpz7PvHVCUwL8I282bRhWOPIi0Ne6L97qQqNM70DddC1+eh2iiw+B/xH
	c8Odir9ZuQhC1b6Q1tMUQ63YKqsVSEPBn2O2t2QgpL6nYAHe+cTM4lYvamctjEPkxJhsxI
	pbR5bML4RS2jJdCSAvyUrwvIl1Pqdgs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-kD7hPSboMyCPaairwsmbVQ-1; Wed,
 22 Oct 2025 14:38:54 -0400
X-MC-Unique: kD7hPSboMyCPaairwsmbVQ-1
X-Mimecast-MFC-AGG-ID: kD7hPSboMyCPaairwsmbVQ_1761158329
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A16F19560A7;
	Wed, 22 Oct 2025 18:38:49 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7BCB19560B4;
	Wed, 22 Oct 2025 18:38:38 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v12 mm-new 03/15] khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Wed, 22 Oct 2025 12:37:05 -0600
Message-ID: <20251022183717.70829-4-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: i6mmwdqf3sq4urusupypyi53iajyg9zz
X-Rspamd-Queue-Id: 3F76AC0013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761158336-204851
X-HE-Meta: U2FsdGVkX1/f1P5QfLYJ0kmv+7RSuoZTv9oSFy6f8ydBwG7itgfwagRnnHvSPCe9xjDEmNAF26ZesI0dwaJ8o9DEd8aIWNW7Y9dHQt2ciR7Em9gectegbfwXGj2VqRk5o+iGNq9jJWN5Eh4+wS0YYvGplKXAWSa91lP3/zKpS7sbRsXAaH8yIl1D34t0ed9qLowYpgYufSJG+biIdrHFohgY1KKg5syZYJtqNFb1H+k90/G/XFaX9VlMRAHHAl6a+PO+EozavxDV9XdgUFtuPdgLwD6jSB5cwNYGEoWN3yBDr8UjbiBoaeB1sfdVtMaDGCgyh3oUiEIfI7xrdyh2ZwXpXN5usi3wc+ju8ww9bnTjpua4YX70q0QIHR69W2SwyerxSctUyf8SNNcEsg2E82DUm+hSbgPBjJYXHioGEZNEpN0e52FnOrwEZP4bI/jw2+1uQX5J+coI8+30/ff9d4GYTHTE8HnvzKda8JNh2aOac673KrxgEVJHakF0HkQI6YaFhZKlXBwIQpjNb2kKpPH4LIdG6kvqN8HuWR0EJlTsZOukiSyQ4zhtZ5zJkqT+oIH4vgMk4r/lsFV5+jcmAN3GwiQYSuJ7N2FLA9irA9gqCLSerqXMCqwyPwrNo8AGxrID0NoBOhvNHn8uSGxDCNDQSMA8qPtF1qpBHceuhdVrpLvwBHa+Lzk+h2TQA8cgh1PCldMsgfJrBlFRC4ZydG/nMSzCf0eZhdOXE6bfVn7Mmm3btnelhXfVwdOnOGLXxeX17AFe8d1BK6iSWfxdykoCoWq9vAYRGr5A47UYyk/0s0EcV6sV3K5MuM89h0zRf/+EGtPMiyMVx4tNy9oKM5GtNxR/faFpsRhtH6BQvJYnzpRS1kuqMnayxNL91l9+XJpD7TCS5m0TRmVzL5a6NAeW60xjfte9tGzbbD31PuOUciKKcaj8v0q6N706kK6sLWP+GVKDE1IDV+b+xYH
 kgJ2cpY+
 v0M2OvLbU6S//jAz2xRYpPa3zDuHLlqt7ZEKE1+5gyKUQ+es3NxcMzvAdkTnwGLfgGCzBR8ESygCf7k75aIsQwabLi1gQia4Dujm+Il0m6L5UEWqyrbHrmNKu7tzkjqaOyHV9F50S96hwEuXpv19oQra8IkLTw0ibREVHJyC6riA6gJoCSRbruPKr+0eD6Vv4+2QsqDwZh08ylyCDajHTgFu9fV3r6jBfGIUouN2aGLwiVX9Z8MCDp4DO+d086/j8wWJls+x4Xv8Atwr3djE6MdSCvA1DIapdGD2AY/8cGnQryIjSJHtiK0uOEyUZzGv4NinH1tbPcUUIFuEG5kM2xDNlTjmMXubhCThEa0Z2DxjMhFcZ+qY4zGEp/xyUYJMA87teKQgpUZn39atIKy5lX7XF/LFhhrU6LtZLXBcnoOVFasr5taRhk6se2hsryDT5S/5Yfd7OuELkc5+L3dSazSs4ZQ3lDzj75AaPHTkzDuk3B893PdOiWJNw4/aWvleBO8kQHB3Nt4bg8EgFUBLvnWMNo95xhrjL5Z8gxi5OzibnebRRCW1gffPYNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and that the order is
enabled.

No functional change in this patch. Also correct a comment about the
functionality of the revalidation.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 36e31d99e507..6cf8700823f9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -893,14 +893,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
- * before taking mmap_lock.
+ * after taking the mmap_lock again.
  * Returns enum scan_result value.
  */
 
 static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-				   bool expect_anon,
-				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap,
+		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -913,15 +912,16 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/* Always check the PMD order to ensure its not shared by another VMA */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
 	 * remapped to file after khugepaged reaquired the mmap_lock.
 	 *
-	 * thp_vma_allowable_order may return true for qualified file
+	 * thp_vma_allowable_orders may return true for qualified file
 	 * vmas.
 	 */
 	if (expect_anon && (!(*vmap)->anon_vma || !vma_is_anonymous(*vmap)))
@@ -1117,7 +1117,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1151,7 +1152,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2792,7 +2794,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_lock(mm);
 			mmap_locked = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, HPAGE_PMD_ORDER);
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
-- 
2.51.0


