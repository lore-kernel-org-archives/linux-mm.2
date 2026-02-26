Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05215FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3A36B0089; Wed, 25 Feb 2026 22:22:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C496B008A; Wed, 25 Feb 2026 22:22:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DB76B008C; Wed, 25 Feb 2026 22:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E62896B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:22:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AE6B1CAA0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:22:46 +0000 (UTC)
X-FDA: 84485160732.10.DEE7E26
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8EDA5100005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:22:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="P0te/bCi";
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QplWXsCS+OP1b1JuRTEIFcvHvm9p/WAnpPgPUjzFYJY=;
	b=HOtvIjQA5glOE1ULoZMrqDB9bQtY3KL13WWvRhpgwEAuGzuRkZiZYtuQ3zLyzPmpUOaob2
	0csXKRddScZ7vdKUlnpuauwTVU20OqUz8gxdLjkVUyiNIglKnBfiRnfnK/vHW6NuenzUtZ
	C8Z2Wf+M0XxibUfv5nk98J190jYD8XQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="P0te/bCi";
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076164; a=rsa-sha256;
	cv=none;
	b=ksOBUdWoSC7533ZYId83d4kGjR3ZXusY9MzznUV/57WeN2GTPqhty5cOqGs5v0dGbMAYfG
	B18pjdGNeZEbKH7J4LVz6oXiQAAk+QYjkYYJqFuLuKL1uh3z+0k57jM/mudc42Yy/IfnNg
	L3z9MiqW8lhJX6HdfGf/IVCM6H93QTk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QplWXsCS+OP1b1JuRTEIFcvHvm9p/WAnpPgPUjzFYJY=;
	b=P0te/bCi42/krhECawjgya/I5STqfPGPfwRxeyLBlEBqSZi+ZHNM1o566Q8V/+qza3c6cJ
	ljX920c7XJmsJIU0pqPauj6WD3nydK4yHT4B2DEMwU56ML+Sj9olSJtjbO7MUtwDZBITit
	KKOeMNk1FE9XhN9KUk8SudqYqy9PFsE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-332-dBtPLiJkNSGaVULPFgH6Gw-1; Wed,
 25 Feb 2026 22:22:39 -0500
X-MC-Unique: dBtPLiJkNSGaVULPFgH6Gw-1
X-Mimecast-MFC-AGG-ID: dBtPLiJkNSGaVULPFgH6Gw_1772076154
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1ECDF1955EB5;
	Thu, 26 Feb 2026 03:22:32 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 612E83003DA1;
	Thu, 26 Feb 2026 03:22:20 +0000 (UTC)
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
	lorenzo.stoakes@oracle.com,
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
Subject: [PATCH mm-unstable v15 01/13] mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Wed, 25 Feb 2026 20:22:17 -0700
Message-ID: <20260226032217.232353-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LJ8Ac6P2xUbsORvP_r1lzPTMXhdYvHZruERQMNjrvkc_1772076154
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: u8wm4me5ny41t8nr6qeoc3h44zn4syrw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8EDA5100005
X-Rspamd-Server: rspam01
X-HE-Tag: 1772076164-421365
X-HE-Meta: U2FsdGVkX1+iCbLJkJEDTs5WYT3gwCAXEQSnhmoQN6SGhNC3Jl7WVUfWZq3m96AGygXakDFtAFJc1TMzjcZ/ShOdZl9b8JaO4/3BHGpTUylZ5ew/A0NXaVXt7ZTlrjFVIcllyjKvnZn5Q1SpzXrKrQDDthRucECJuXUTB1bhsy6FSoYRbQdLvgFfwB3vKE7QsCbpYQhlE5jjC26VfCyq+l2L4y8oW10BcPQP15gK4XsXUSI17vaPGUhsTX9hp/CpOh5Gj5BssQpWXS12P7rNTszFRvdBPAfp5k6gXVnmOC//Fm+oUGtmi0brYece13Q8cpRSTwARHmafV8JZ5mxrGwybNxeBwysLMC9cxnyUi3qdLGyH+cH72kJKujA2lepntThJMCm52+7DeJDvtKgtpKj6zhbWUpg13Unq0Ag/FVumx+0p0rgDxzfJ41Wu2UinlVtbYfnCG/KoAcqvtzm87UXdU4hH9GBtzJvRWo4dh1/t6xSFgqZ/+1lh74GjAIoVzcqpkKktwVqRafV0vYCECWMoU3i9ZF6+yeRYIzbMtSufeI7xT3/GRdTpH0HcyJuQ8zTHNMTPKnUVWbIG93BfrtXBN8VoP1VjpLkevMjHGsEYhpe6/I3lSaVXqLpkMT0q+5+bDVDYuomIhvkxKsKIuJ1kKJ0cptlBOyobWI/2ht0dvgs5ocEiz7tEvTRAa5Mjib3dBZ8Netx5qwpUK7LTZj93vC1F+7stopA2bDp0e4AzRFyCTYvI/jHQZNN5xzOOMOeN7o6iZZSzAlh0FCW2GLOC7zfY8iwoRa0bUBaZ/hH/zzLWafWoIXypDfwuEGNCn3xs0w6Vl5Bb2ejcrP1q5uzlm3SgIvyfGKQ2Xky1btUjG2OwchPQx2XEdndj6CAnCH2BF5sumiisniZjvP9SGCRIM5pGFt1YSJg/3iCJDXKNFdWPViIDqYkc9gQOWJ3s0QLWgSeet2WvYcjiqDj
 lFi+Q49g
 zGXtQweGoZYV0hPinsNvoqtNmWbxIxYtkIsw1LA+V1kl+NUrZ/Qe6JjDCm/WmRTFTGVscjMxPMy1S8L6FR7ztCXjjPbmkMQURZiv048T9t6JFkWo9pSWcDtYlQnsTY0UQt3yXmmBJQ2HglGo=
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

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0058970d4579..c7f2c4a90910 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -895,12 +895,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
 /*
  * If mmap_lock temporarily dropped, revalidate vma
- * before taking mmap_lock.
+ * after taking the mmap_lock again.
  * Returns enum scan_result value.
  */
 
 static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
-		bool expect_anon, struct vm_area_struct **vmap, struct collapse_control *cc)
+		bool expect_anon, struct vm_area_struct **vmap,
+		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -913,15 +914,16 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
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
@@ -1114,7 +1116,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1148,7 +1151,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2863,7 +2867,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = true;
 			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, HPAGE_PMD_ORDER);
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
-- 
2.53.0


