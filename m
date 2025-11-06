Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6B8CCFA18
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97628E0011; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B728E000F; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC708E0010; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63AC88E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BDE8140278
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:35 +0000 (UTC)
X-FDA: 84081473910.24.C40FCA3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 79C654000E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bPlBOxsJ;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/LNaSNalss2cwlG3Ezg158HR0y6d2DV+kb4sHUe3rY=;
	b=5WDbIFm4XWzgFN2pzsddV/ae6iyja4KQoXihWORiXNSCnpKAr8KoH5ltGjKb0HpwVfAc0U
	RSkiqu2PMIl6xtiEGbnfpH0FzK97aWq+EvVdp1GVyzZ+gog2tc8ERQb4XlNd6izXBhNEDd
	lKbIPuJ2Ch5CCHWiKWD4RYBPoO0Ohqc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bPlBOxsJ;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464573; a=rsa-sha256;
	cv=none;
	b=UtYOqAinYR85w8s4rWkeltKBx7edG1GYc+i55zokuTBlUt+kPbdREZxvt+XE0WSR0YWk/V
	7FbDdYDRNNaDpj0nA7ycgu8GWnkjtoNqNUC3ag8jw9EhmOLqD6bU66fPk1AouGSS1Ka6sf
	x2cR+6eq9cuYxV09NsoCjCH+puSAF04=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/LNaSNalss2cwlG3Ezg158HR0y6d2DV+kb4sHUe3rY=;
	b=bPlBOxsJCqaK7/jlnxnLXMl/NfVogYVFyFAvMAbjP7u6ZV2Ho27zyZWz5zgBFt+DoIB5Lw
	mA64dSFP/tNLdGmCsxEeOZxWODzjQf81RARwe9mOfotzC6zDfdOGFxmTraBeCW+UBFd1Ao
	AK2zfhLaAriD1zfvp0OYwyIKWcC9PCQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-392-R36kOmdkMjmfZ5rrC7oMwA-1; Thu,
 06 Nov 2025 16:29:28 -0500
X-MC-Unique: R36kOmdkMjmfZ5rrC7oMwA-1
X-Mimecast-MFC-AGG-ID: R36kOmdkMjmfZ5rrC7oMwA_1762464567
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0208D195608F;
	Thu,  6 Nov 2025 21:29:27 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0C17819560A7;
	Thu,  6 Nov 2025 21:29:25 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 09/10] mm: thp: always enable mTHP support
Date: Thu,  6 Nov 2025 16:28:56 -0500
Message-ID: <e9a6a123a03a122010cc10708391db901b11c7a7.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 79C654000E
X-Stat-Signature: mnsfbg8pogfr6ekbxhjo4hfhx3ygut1r
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762464573-145085
X-HE-Meta: U2FsdGVkX1/zB4iA88Y3aZbV+v5t0MtGmKwMYtPn7uaBWeM3IVva9qTvqFAp8UN3bJYQs13zrGBfJHC45qzaOUht+oAJe9ZubUfZqBKXOneKX2Lv4Tl0NBYiaiBjm8YoX+9yqaDjgSLSQr/+jrSn22/newDViLQokWupowEOgXetQVSvgRtwXpxEdkiREBXyGDRDXfJYDX/jc0aJbBhpLTOcT3IzMbFusZlJYkbsufS7mwaAPjIj7BDp66Pc4OVJZzIXDaWJUqgzJLLtJja1NIn4u0aGSaUtbEbDrJUtkUMy8D8Jsh+wyhZhSpzHHJH8yqtbZgBrJfACccvsuT4/9ATD52wympbZ5nTv9yszh+vIWtDKA/iwpRkpLnHlynYgkH8RQmjP7TiOWSrW+onbobJltNWGqJiNLsdP8EtidzRRUmFTZ/A/12vjFSVD1Wzbl2bu6QkfD4siLEQBjDEJcACtir/VamF1wcKlhqoSQ7U/YvqaoJuuVG3nAr60i4PSeOLZ2abLwH0i6T5lnAeb7JA6vmHREOgbpPPBp3Jm7gJYcmwwMHILT/R8EQU4vKjrrES/FAMV3aSdQhh1GjrQOxKN7dH6JH3XUAfHoPwAwqvI9G5kI31zDhJ8rr9dkRMQ5mQWomBeZ+AosehojQRmjTY1/NZoYn1SJYy4gjaTr4+wXmd/iwDqdJ7APux2v4v+8XV49QpYmjQVx5qtbKuiC6lRb1LjNa5u6czSyE8Pgq0B0wFDilhkIbewhKXDRPEwWHjE+EEGiAvwSu0KfiLvmA173xhklhIDTt+7nf3CADnPyK+YSkxy4AUnkV82gBf0nMwkdUGgmBL1QyfVVIRdIqVLe+xG5Fd9akTnxhJTGDruNSjd8gxUvR20R/GUivj/QN0mg2kBN2m1c5Yu6+OwqR+k45aeja3pfldutnpUJJGI+lpNZCvvYqg2Ixa5el/unOLSoLBiiJn+GTU3+c1
 Vh6Rq/gw
 007JOyFy7Cl+A3NdG+XApgsDCru3X+c4D5yFyStibHBssT/xpsZTlwfXehSU2yZMsHBZb37uFePXdM3t6XcpLvx74UGjga1QoNbLN53l6D0ARf0GAvTD4iSP9fdoKozLdbQ/AjXvwg82ZtOUB+vMcywutmMAkZ7KVRsxMG3Vk3lGleYOLp2ppZSi4sbIXeb0bhFldYK9IJHfa8xkFfJ13d7qyBRqgQVXUeQ+lmsdnw3h3D4kkoGzzpTCV8v4W5UmOuvGCtK2UIwiejEvl92Qxz7nmRqdxLk3K+U4dAxPsUCysgCRo3ADYSnYU4i9jM4skgpssjBVNs3+qzyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If PMD-sized pages are not supported on an architecture (ie. the
arch implements arch_has_pmd_leaves() and it returns false) then the
current code disables all THP, including mTHP.

This commit fixes this by allowing mTHP to be always enabled for all
archs. When PMD-sized pages are not supported, its sysfs entry won't be
created and their mapping will be disallowed at page-fault time.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0f016ea7082d..4117833c53ef 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -115,6 +115,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves())
+		supported_orders &= ~BIT(PMD_ORDER);
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -122,7 +125,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -805,6 +808,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~BIT(PMD_ORDER);
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -904,9 +910,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
-- 
2.51.1


