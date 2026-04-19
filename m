Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA31EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 18:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320716B0332; Sun, 19 Apr 2026 14:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7606B0335; Sun, 19 Apr 2026 14:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6F66B0337; Sun, 19 Apr 2026 14:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAAC6B0332
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:59:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94F981407FA
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:59:13 +0000 (UTC)
X-FDA: 84676218186.26.62D7469
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id AA07C120003
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:59:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XVWlTYOB;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LJaOyXdmI63cfNVNKc4jzTWWvQfAeh+OPxH5aN4fYk=;
	b=tk2rxCoHNN/ysqyzLmDZs+Fig7/oE64M3VlWyV1eIHu5pRYqFaO6YI45Bgj3KehIBRm64x
	Se4h0Xm+hqptk1OgHxG5bHUlGFFnhU4nHz+XTsN/zSjaSRf7nzgu4dJ+pszqT4RJgjDk+B
	qTjoY4YZOgbaIL1+S8WXTh/h9i8lekk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625151; a=rsa-sha256;
	cv=none;
	b=UZxy52rPfR+nGTjw1wCGtkFfhqs84xnAiVWTBgzWeqFJx6nMmKpPdsd3vrR8rM6Ju2q/Ab
	ethyIuadeyQMDP9QDqb9PU+Bl4Cd50n/B6vX6MeBGoBqf0xZbd47DfcRBubbncfoS5/zvv
	jH9o5I76IBEotU1VLMLRE1Tf/vD0iWM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XVWlTYOB;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1LJaOyXdmI63cfNVNKc4jzTWWvQfAeh+OPxH5aN4fYk=;
	b=XVWlTYOBLy9sIGU8324vhzMqoZci/34NUkB+yJSZ3hxf6Uo3Yi5VJ/sJR1Or3JzUlHBFS+
	WzgY7xMfSRGVQpMe2v4CL2XRLvgnG095VwE25dPr1Cbvr0DDpneeQznfMJt5HLh6jW16Kd
	wj3Yk5nFSk1sVyfHAThDe+06CCxNPYc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-yoXquriiP7OMkh2EYBEWMw-1; Sun,
 19 Apr 2026 14:59:03 -0400
X-MC-Unique: yoXquriiP7OMkh2EYBEWMw-1
X-Mimecast-MFC-AGG-ID: yoXquriiP7OMkh2EYBEWMw_1776625138
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53538195605F;
	Sun, 19 Apr 2026 18:58:56 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8235A19560AB;
	Sun, 19 Apr 2026 18:58:35 +0000 (UTC)
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
Subject: [PATCH 7.2 v16 01/13] mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Sun, 19 Apr 2026 12:57:38 -0600
Message-ID: <20260419185750.260784-2-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tPCZ-gqP0LhDuYYygjn4pCeYkThzigBZ0zvlPhgw-tQ_1776625138
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: AA07C120003
X-Rspamd-Server: rspam07
X-Stat-Signature: 3kqbjwd7qyfhzkse6mjsume8fxip6tzh
X-Rspam-User: 
X-HE-Tag: 1776625151-292846
X-HE-Meta: U2FsdGVkX18KgSK0wVSQEE8G4HQ3I0Dqf7cGw5+uppY61+Rf2bcKRdisXN/mTTbr5uBdhF+em10iMocHJF03cw1u1nuwLzuUce1fhoRffbGaEMdSZQXUgqd5euRKi5KUrsWXsbvHmIlEzM8bq7ebEC4lXGau/5loiUWg8IdDL65xUqT1nl7FWUF01XN9P1C45yzaC4NVv27BVVTZCDOj9EW+iXmS2hNIeqF/dDiOrJm2FVC4H04ymDpUYDc4DYCAJkqMgRj/GZmsYD5VAtTWBGoKrmrzwBENoPcIuhczCeRyk7a+RwIDmBqKzbgDUVjQMoCI8QMzTdtM2zQP6iRKLOCL/LF29HaG+dwT9I9E3mt2Fy+kKCHpN1Hnm0O5ouzXvjrC90cA1ITq758lD0iGIj9R8HIlUZ12hOFrsn9z/r1Ie964w9d+jPF5YxteM+CW5q9X1LJxtJ0mSPS248Y8l3DZ/60aMfqK9O4h406iSo3D4XZ+eKxhpJSZsS9sS9biRQvQLKySjHCPaNqgAY9fgGhoJSuYWumfEQhmS2DV4K5v4ja+Yod/CenxGwGYWKZuuJYbjETwW/jtQTb0F948C4qHvzKp2jlg6vOAk6R7knIOmhkGpJnf3bKvdZc1kjWtg7e66sIm7OZ77TGRSgY5ltYMAjbLcf7qA35goe4u1bE0yjrFN40Ml0mUrYYLHlP5o3aGBitw1zHG8Nl3bfzPFRji8XfE2oPX3F93KU9pEZJacCqyZmiVErNympcz5ydeWp33bbsxTNXohwD0H5AVHwsy2MjgvcTuSBj84Fw5IygfcniahT7SS1+DrXi9rUVl4FVHS/Z5YoArpaZa7/38B0wAOf5JBkRLsi+lhd8Lasevh0MsuJ2xPIx7FdwQbtb4bBcW05KVbEECTsn/jbA4mGzhRrBNqtADJWjmLLj698lkHGMuToUeKumJzMAOHu1NaAm5sikZk4oLhi2de9s
 Picpd5mA
 9eLgoqbNqadeKl3STgqlFtZpSF/0Mxv/RmwyXqG97JVb0/epJJ9OgVD1p7ViKKgzV5m1AVhid2C4xbtWnfg31ZL3wI4EzlS0dBqtgL3BbhzGMc7+jRBSZZjQoHld5pF6z5V9GeciNlakrfjv8cz3CXxPRncAdmx96xDtJ16iK73dp/+lHePfrrlYbPYKRinsLKWDgDZYkE8VPD+4+0usjX6fDv1K5HCCBYcJEjpWV0HHnQtTLc8nKH0sh9drVzH55I6Ah8y00MVz5Iiw2iNqHwsYB1becq3+dNpLHQNZ7pGlR6QADp/Tvvp97r/xCDadjbIYpJ1nsoFnUfJKn7zs8Xts4L4yyNKySQMhZ1B5MietmJULkchFvRZBoXUVZrJ6UWTrIxaLGIIi/4l8q7IyKGtu2shMkjp9hHN19jFgdvCJcXSkDbNv/ecVM2skvQ1uGj8Cy2q2Y55CChpxk0q4U+s/92lr9hssstWRi0SUpqWwgXs7ZdylMIf7GvnmR/uMZ0+y7n6yVOMwTAWhMsoOpm3loLnPubFE5+Tvd8TsJYSQe4011vbud1n92REraaUc9qpWJuK33JBJXsB09p6lSOqB8A1uu3kulBLjiQ7FHIeLX4fg=
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
functionality of the revalidation and fix a double space issues.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..53e7e4be172d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -902,12 +902,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
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
@@ -920,15 +921,16 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
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
@@ -1121,7 +1123,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1155,7 +1158,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2857,8 +2861,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_unlocked = false;
 			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
-			if (result  != SCAN_SUCCEED) {
+							 cc, HPAGE_PMD_ORDER);
+			if (result != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
 			}
-- 
2.53.0


