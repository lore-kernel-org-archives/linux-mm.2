Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDF8D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CACF6B0324; Thu, 22 Jan 2026 14:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892386B0326; Thu, 22 Jan 2026 14:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E186B0327; Thu, 22 Jan 2026 14:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 641396B0324
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E8D5C0D0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:59 +0000 (UTC)
X-FDA: 84360592638.01.D3C07C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 05BFE1A0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HAy6z6qu;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+LDRi+0uvS2YguMTQW96g1SLO7avojWU0TNOgHstrY=;
	b=dNkX05WSRq7eK9odT4Qqql8mkEs/H6izx5NXRQGCJuHcFPOeRLijEtIzwfqJ1ySs/lHfqw
	3H7Jvhl1vnECuF5ZsT1Y7x3L+W4kBWGAxKN5KrSl3IipUNgbiJ8lf4vJPxX84RmwES1979
	aqo2vxTfLcIjhLxnAk7pdILqA3oJ8fM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HAy6z6qu;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110258; a=rsa-sha256;
	cv=none;
	b=sKia6wT3RieTLr55PEHAoUjnhc8lS/Mt4Mb0U3lBiBTDa4gINHN8H0BrnddJDksPIOO2M2
	xTeA5Gn2lSqZe2hGVwCWJlLersZsccPWvwXfO6ihywTCPJ00s33PwZQaF427mUoxkfo0J6
	VI8+O8xVOMPwxHtj2Kb/PPl8mx2zKlo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+LDRi+0uvS2YguMTQW96g1SLO7avojWU0TNOgHstrY=;
	b=HAy6z6quL3WXu6VhfoNTTGX97o46LxOny5jP5OYYqQvRtbNP0Ie6z1W7kLVJXoISvy9ZYY
	CgzLDmoAMP/66l1QWE5Xi19pr5O8uNukqIDI40CI04FDXyINlJojvaUtx1bcmJi2jJ/ero
	c3DItXwsfA0dqiww3MW/N3HYiNyjCiE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-wDJm2H9aOzONNAhcxmd0cA-1; Thu,
 22 Jan 2026 14:30:53 -0500
X-MC-Unique: wDJm2H9aOzONNAhcxmd0cA-1
X-Mimecast-MFC-AGG-ID: wDJm2H9aOzONNAhcxmd0cA_1769110244
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1DA618002DD;
	Thu, 22 Jan 2026 19:30:43 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CB6FD1958DC4;
	Thu, 22 Jan 2026 19:30:33 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
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
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH mm-unstable v14 04/16] khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Thu, 22 Jan 2026 12:28:29 -0700
Message-ID: <20260122192841.128719-5-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eqBJsEj2_DMD6GNGyYrJdc3WHulqGMXnUq3ywHPDmwo_1769110244
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 05BFE1A0005
X-Stat-Signature: u689x5mfftagnyzqt3tisrxdersm6os7
X-Rspam-User: 
X-HE-Tag: 1769110257-353004
X-HE-Meta: U2FsdGVkX1/R+p4q0xvC0z4Zd3GLvJ0WwFVOlIZV5PUSpuoQhCDPFZ6axvvUrP1O6nUrgHgQLTsu6lXZ8FSNZPo5tIpZZ0O0VvJSQMswFcW+sjEEg2ok2YNwC88ZLw6xBJfFPQWPMEd4ZoTYXFuGlkZ2OmKcjqZfbiVxm9I5FHRSbd0iS0MFG67rPMKcpD0YXildpYmyrtQcn4zLh1gDSD37oyP/zwJ29zPyMTQ1Fw/rv0RGfYYU1o/R4thaOpbAsOkNGrOHRGJ23/0e+6U4YR6dtUTis02Sh9hl1YPASM5T9ftcnkbLgpXjYDa4tsgXMQNau6rY9+zOdXEfAdkJcAMTYWWlOGniuIFRD9JyuxUkp/BjsKOulhX75fL/3yHfTnRt5uro9fymHCZmlkI0kChQrB1c2VFwMOx3xEY18UHAk4ksG2g5hQVDYO9RXFFmyZLoQ6urOMBADUIl2W69wO9p+6rHWETNIY2Izk5vblJaXz/fXor/uBGeoE0tkCsejKOF/RngF1zLcCV5nnBUOkwS9JWbySo4TwOL8TSbjENxZWwgBTb+CnUn2V026vWLn8b+SatP8030Do/9A0sjeGdaggocGg3+UcmA3rZH76KggHXNRqn3VEowr8av0+6CUDA2AevRWeV1+LGsZC5ndiwAS4iK07s6FyQMPjY/Bg6COuf+/7tU5Cb5131cKNYHxWb5gIcZ1Cb+GN7GGhjaXkz7dtq0a/H40T+4NQksQwNnVHtglXFxyJQsTgZy4Q4sDC3KP71FB9hAP5/ntsem9Fur0dUhZTXxEuZhCg2ivLJBbLRKhzQFKZsWp1aMzLWfb6zuXSFHuZtRw+YE0c/GhKWcDfd8UH9DcaTv8OdrwTtawLpsajVRhFV8S+99BHHYmzECImIGcYUZpCKrZlPv0JsfYTDLEXfhwXbD+NdLLU07dksUW8qJQJx3epZ+et6TDtSMxKqutYhTb7vOfpA
 n+CC3I2C
 1kD/hs32UWEnntWjJpGNk2nfswopBvTIpxML5njH5UQEMoNsizsYmALXJ+7psRkF+uUlpsLXDdfX/mPTtDQ9m+LozdhjYZvlasIsRsXV9t7YKK7Fk7cgLnbUCqFO/jQ/2oGDxfWHwa6RkC2tsBjHKxzOcQclwky1TrZZxxbzFH7LWMAGqqjWWaZOMmO8XxbF8hU6GhNKtcBsMFUONkf1Ws4YIeMQZpOCPBBKkqHP2ZOYFfgmWLKOhe586nDdaoFBlvD1Ts1Qc11W+7eaE46vXH1zawBSHA/qL2Z5mLmTtnw8B4X+/CvLB1RM7jtbBy1QT/aGyox/pRD77tIOh1BeySeFUvqHyB2WteaHEtAQkz2/Iu1MS4Qk4V/+u76KA/EIuML8XjyCeSvw5ZTWPb3C6kapPjeEiTitcKgAYAPnyFKmEW4flSQYjJz+cmuzNJJ6rsTBKsQUoBH/izIvHIP1b30//PD9xyqgX5MGCVEDMI6zMtv3Zdko+3ToktFq+Gf6m1G2x5Ty7mPvk9l+6y/5nvJqRKleiRZ+qyB+4iNtLvL2Vc54clVwWJxEcKwa8kOgm4AuzVpo2rRLHMyIdOoWYlJ0JHPqStPMAU5J6BQ/muGbcYWc=
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

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 59e5a5588d85..59b6b89394a8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -893,12 +893,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
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
@@ -911,15 +912,16 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
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
@@ -1112,7 +1114,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 		goto out_nolock;
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
 		goto out_nolock;
@@ -1146,7 +1149,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
+	result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
+					 HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
@@ -2824,7 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_locked = true;
 			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, HPAGE_PMD_ORDER);
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
-- 
2.52.0


