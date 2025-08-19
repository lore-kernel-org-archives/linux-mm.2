Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0480CCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987A58E0008; Tue, 19 Aug 2025 09:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9387A8E0007; Tue, 19 Aug 2025 09:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8279E8E0008; Tue, 19 Aug 2025 09:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3FE8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:44:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 232531605FC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:03 +0000 (UTC)
X-FDA: 83793625566.02.18AE58C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D69C18000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:44:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bfUZ9+sU;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDpdJsewucpAnKWnmNVOjt/r9vNeFUjY9axce88FL7g=;
	b=YxgDk98vC4pEHwj6WjaMKvGRG4e9BliW8UVst4VzdRlirCQL7y8VY64IPGlrd5IKg+NYFy
	9KgDs62j7MAzWrW+6ja3E+v/uGKtZyoDOuI3cpMJ3pMvpBL5Q27HuzjPpBL601//uIe1T2
	4CVx37BsNZOemgcmHbP5e8dD2EuSERQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bfUZ9+sU;
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611041; a=rsa-sha256;
	cv=none;
	b=svisfKuOyoNgN7M5WPPr5T9t0Ek8eZut+is+Z3oFt41LYE491ePRjkvSR+8G8UVf77iUkB
	DhK7ovoXT14O1RtI+XVAcWC3Ygn92+oDkq7VJISftkUec2t0inXmvyFD234fKuf0t33ieF
	38KCWtU0zMDqZd6xj6z1NGvv/tehMlE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDpdJsewucpAnKWnmNVOjt/r9vNeFUjY9axce88FL7g=;
	b=bfUZ9+sURs47qvPLg6bPB0pylGb25aWmImtAbQ6Ch0nVxk5iGt+Y2xFUA8AENZlullYnb+
	b+cDbEpXgei45GSRX+LK48e10HtHl5+EYDILBtlsYQ6IripFr9PymV9yFKL5we3fZGGtjM
	UlcK25sDQnzsN46//FovXpyB6Gjzh/8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-T8nz2qPBMSSy7Z0JKuXeAA-1; Tue,
 19 Aug 2025 09:43:56 -0400
X-MC-Unique: T8nz2qPBMSSy7Z0JKuXeAA-1
X-Mimecast-MFC-AGG-ID: T8nz2qPBMSSy7Z0JKuXeAA_1755611032
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AAD71800294;
	Tue, 19 Aug 2025 13:43:52 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A709619560B0;
	Tue, 19 Aug 2025 13:43:32 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Tue, 19 Aug 2025 07:41:55 -0600
Message-ID: <20250819134205.622806-4-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: gem5y59y8it9aowddtqcwfebgiryyieb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D69C18000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1755611041-411632
X-HE-Meta: U2FsdGVkX1+yjYbTenSnMm7w6TJE30lNbfIrlJ9KsMvJWPQ+WoehowVr3Dzr+6/hBjeUZEwJdeqBwSwZekp+XLMsxwE0rv6i5Izll4QXSTaVyRYu5FtaB1qR+HKS8cEvqubf/A9eUiqGXKcGT0inrDes6/JGgylaqd1m9qIU9cVgBmfz0lrYF2o75xbIYmhWctB1r0SwNnuZCzjQfq6h2vJROLwKK9oelo31RVV+oYvlP0M8E9BsZenJB3kX0IovI7plfKjx5+4/vttmkrfodtYg1ZrbQhNT5vMZsZycrTLxt0qiOhkwUqC7a+aNKJ3bzCHtfDInWt8iBxrqxLmLXhIxFZ3lbqqNLMMfSrDBoe2HRmVbHUgqc7qq1trxPow1HXjhFNZDDHI/8deyZ0OCsJ+NkKilaWSQVnSOuXqghp5NJ/WRDTCr8kVOCpNn/clMabbu11leWu/R2fLttDGWXJTL9aZp39cKdxftSg4npMn0hGeDHI+FyyQHpbjNgur0Eez6u8cBcFxfH8/cTXhoDbydbyddGFpF5ts/xFfUjkQDkjPh8ynSGLqPVc4H+undr+dPaT62AVCvPK+she2XXfdBX9hjpJzo3VWS/mB2399/X4ZjizhKuangbatXGW4YfiRLURLNV7ETOhDX0KNwrLh4Qlg8otLyzIrI3OY/eI+FVPotDVzEr6YO4LtIg9jXLYx2TMDi4WOZu9hpPrve0Qq+6MQkR9mhGCRq8Jt6o/GGsvpsUib9U3EiQwMd36Mif4xuTQo6S1OMZN46PFLIYixE1vgh7Xt7j5Xs95wlC94vmjbRx2iSZwlrxvFlee5XhtcdE5DXVfy9nis92xItTUxRfBa/dAXcbx2WpQcKn5dyuDBUC8ULWdsHhdzYAH5owNAIlB7ys5CtMvrsgrAPTht0kY3zWUXfujW504rD1jSUK4SnJpWziIjyRVBAOhg7jTeeM5hvF0jgb/gTs0y
 m4gSZRWh
 R6S7uiLXauxvAH7jCQVNVK8qkiUG/EghTbpMkaEjq6rZUVHAfAIOrgB0NImReYJT+oX60tOLaMac4djXyQJ36gBevcrWWrFsCnrloSMfNwELnhpZ4+trwjnIBzur6xnvHCZlPzcjwUfTlDiI0WIqsuNvcOpoODiUeBJCp0as0QyOLpWfHS8Ofr0SvxzjLBaI+zwKm3ilC9w1nGlCftKGKoICR8Y2N52rkNI0kU7YB3iZiQ6VtpUAo8mn+67dpgAkLBe02KYPhw0oGXyCRvnwRZPQa1ArVSSKITaZSGiFXCsmesC2fBKbr8YwZod2/ighcxIU0qE7VgCvqm5F0AK+adlmEyNKyXb2gx3V/29q5O9UtKGQzOEVrXwprd1TQjlbOPEDZ8eZwM3yi0oXOMAev4EpxcQQcabPDK7i0zkNEcWWhWPEbmh6zjx4W6GJfCV3ECDi5L7jTDcaifBF/k3deGNAT2U8UouWPyrfld3CUAH7jtYNaptr961tnv80ZVqJYdjw+FU98auaZbLU1edI7y/wN/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For khugepaged to support different mTHP orders, we must generalize this
to check if the PMD is not shared by another VMA and the order is enabled.

To ensure madvise_collapse can support working on mTHP orders without the
PMD order enabled, we need to convert hugepage_vma_revalidate to take a
bitmap of orders.

No functional change in this patch.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b7b98aebb670..2d192ec961d2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -917,7 +917,7 @@ static int collapse_find_target_node(struct collapse_control *cc)
 static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 				   bool expect_anon,
 				   struct vm_area_struct **vmap,
-				   struct collapse_control *cc)
+				   struct collapse_control *cc, unsigned long orders)
 {
 	struct vm_area_struct *vma;
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
@@ -930,9 +930,10 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	if (!vma)
 		return SCAN_VMA_NULL;
 
+	/* Always check the PMD order to insure its not shared by another VMA */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 BIT(HPAGE_PMD_ORDER));
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 BIT(HPAGE_PMD_ORDER));
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_lock(mm);
 			mmap_locked = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, BIT(HPAGE_PMD_ORDER));
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
-- 
2.50.1


