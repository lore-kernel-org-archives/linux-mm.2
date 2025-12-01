Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E54D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A74C6B0011; Mon,  1 Dec 2025 12:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158E06B008A; Mon,  1 Dec 2025 12:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01FED6B0092; Mon,  1 Dec 2025 12:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E35C16B008A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:48:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97DBB131DD9
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:05 +0000 (UTC)
X-FDA: 84171635730.25.05481B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0DEF21C0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:48:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bJT19dzA;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2Pphoi9ZTWqgTEO9H99byGsdLt6OJtzUVAK74/kkMI=;
	b=GhkVdKjS1n08Er+MDuHhizkM7liA4fdSOKlHLyU8gkq1QsRcmYYrk8WU0/YVgGPhCDAAEw
	O+tAFbAw0NHZgPfh1RC5FwlUTlokaRfdsJwSGs26i6IdCODJrPGva6BvTGQNs4PlcV6pwW
	Tyk6NdRDJuItscTpJO6rS9pVRA16ja4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bJT19dzA;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611284; a=rsa-sha256;
	cv=none;
	b=47JpdPV+Os02JMfksrVqhKYrp7+qE9Efh+7xKuDlR2MCIfVVk6rvz1kX8MbExHyn2ckXoH
	aKDJPjymQNC/Pj9pZ6L6XnXJ03i6x+MWj0tq9SzypYYiqn1Gs2LmLn2gEXE1pwqLu+LfAd
	dWtb4lLFxgSpCJ5zOxE4tO+BwPi3g/4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2Pphoi9ZTWqgTEO9H99byGsdLt6OJtzUVAK74/kkMI=;
	b=bJT19dzAwp8cGQCTDaUgZnquowK7NhFq5dwmu+SirFOxoP/9CII/+Hnv5cbwvxdork2Vb+
	4433jTHmUSHaMN3cIxDpntRNfPu4ravVw9kGt6hj6swByQnAKfx5uiWgEgLy3i9A6QgTal
	uD7l0beCeSti/cK6A9m3vU7NatdKldo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605--ZPPVAOeNCenUj3dFzdp5Q-1; Mon,
 01 Dec 2025 12:47:59 -0500
X-MC-Unique: -ZPPVAOeNCenUj3dFzdp5Q-1
X-Mimecast-MFC-AGG-ID: -ZPPVAOeNCenUj3dFzdp5Q_1764611275
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3019118001FE;
	Mon,  1 Dec 2025 17:47:54 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9F162180057F;
	Mon,  1 Dec 2025 17:47:44 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 03/16] khugepaged: generalize hugepage_vma_revalidate for mTHP support
Date: Mon,  1 Dec 2025 10:46:14 -0700
Message-ID: <20251201174627.23295-4-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DEF21C0011
X-Stat-Signature: 8h1tkowbpygbrx13uoykwxyboy7ksr7x
X-Rspam-User: 
X-HE-Tag: 1764611283-941362
X-HE-Meta: U2FsdGVkX18EIj16JEaadAqzs4ut9QBrvCkEKEoQ4I6dJiURs5xMC/drxRUtT//0RBHoooFlsCsxIULX5tjCU3YkD9tbnaE/zbyQIA3F23Da1DYWt7njXDSouHPE0sgwMkErRuuTt7Qd/S/eur5lUM24DyVvPWPYlks4WQUnTALow4px+rP8U7q8TYusCGIwmTBXgdUrz+hvujI98GxMfMnLMz5ztscE+llOAIhuXrjZuT4BQOqEM+LlFAwKwx6Xb1V+l5r8bwnIDxBSakzQ4Oi22gDHX/3dtkIcLicqYXC60jZuraklvUfdWDnvcz2a5AiFCUIJXvrGx87kXk3tCzpoJV/JfK9qqJUMoxDYjdakFs8bFN0RyfW0G/cifNLNyfzrAPYDOmSLrxu8rH2aiI8xPdDjs+V6EUa6xK1ohFt1yimDFk1vfw3dySeq9tJwAQp6n0XR3ZNqUzQgMy/bFVs1l34pCpSTA83B9IKXzfWDV6ilM4OSXESyYQV6gFcArx6ZjVui8BCEYxMUPnnetVIBhim/SSmP3WcTYcrhWQ2rscY5IH4v1Sqh32wDVsLFCWEFbCppUxibu0uNDozj0gL41xtThAZg7vSjxB+YDgY/mA29FXuyb9yC6+ET7GZSswmnE8FpOXis9Sxpx/gVj3RvvkDOfNYyH3aNAu950wPZfk0UBpRlqkHFKD/TW2V2x43asQG5NIS6jQoTDurg3NSU2S0ADsDcNql4UtzgdLKuEz2+NadEqjbkPPQcf1suw7aJcgweJ7HvxhctUSVD4zjQ+z14vnIaE1HN2y1PgtTfu056nefYbx7Q47/yzdGvcpFVE68QXWDrSSDh4mkXYICnXJ9EmqlDueNPjERoqTYTtX7pMmbxeHhr2ya3DPWpC2M2OBwxuT7cvTKZts/mhAcHNg/gnrO7imCUGaOhRSFoMEt5aWMq5ebH3ritrWWvAUs/EY2q2cFBd2OalpX
 xlTi3XML
 4aoiaGzSI5kCULlGazdRFy9qD6N9TAWc0Ed7/8DngGW5ZEIjTLMOczcaPn3mXCpNqwsqIJfA01JMeYq2jTWN/7+BSuknHW14V0CnPIKKlnG5XSbrMRusLRhcfUw5TsQe7H/vaLHOMkHATP8zmT37Qaa3f7/xQtM9VxHX6/hgwzDKz7dVen/Scm6w1hQ==
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
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 433ea7283488..69fc6b41f010 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -892,14 +892,13 @@ static int collapse_find_target_node(struct collapse_control *cc)
 
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
@@ -912,15 +911,16 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
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
@@ -2814,7 +2816,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_lock(mm);
 			mmap_locked = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
-							 cc);
+							 cc, HPAGE_PMD_ORDER);
 			if (result  != SCAN_SUCCEED) {
 				last_fail = result;
 				goto out_nolock;
-- 
2.51.1


