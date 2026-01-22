Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD88D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CE96B0337; Thu, 22 Jan 2026 14:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021326B0338; Thu, 22 Jan 2026 14:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4ED86B0339; Thu, 22 Jan 2026 14:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D17466B0337
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3EAC1B05F3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:11 +0000 (UTC)
X-FDA: 84360595662.22.2D06504
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B1A9E4000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I+TSzgsQ;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhNYD18mHUxoOlYpRtufX5ZWTVzzqP6thRPGOk33sQs=;
	b=Unp/CXucFGGFXhxLK84feAQU+6bV9xM44GEmeM4e1RSgzJyci7eZf32/P5H0v6uq6xNHJ1
	mXedoDsTHhkG4EqgvFjn+uGoBwTR3VzPKDJ2pbXueIPX98u1wklgXXYjmBC89og2a6eSq7
	UE0Xw0IGKTGOCYIeX22YRrXFE5TuyXg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I+TSzgsQ;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110329; a=rsa-sha256;
	cv=none;
	b=sWMnpcXv4t7JaIsMY4NNlu37W+559ofUhivONOHXZ7RTHk0aC0G1IlI2Dzwqe6xYfSsMuN
	nHgecRAlZo3Bk+rPfCYHu9MIpGojjmTtE8Ow5EeYuMleW/YGIGAu4FKfKZdhZQPGU8pCvk
	JpNvywHc5x/WE1l0HUx1oWDIcqXQe/c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DhNYD18mHUxoOlYpRtufX5ZWTVzzqP6thRPGOk33sQs=;
	b=I+TSzgsQ/GEd9EDenWsrMeoriil9gaqF8Ya9d/Etx2soIqmGSQwRsi1O+yLzpIDT/S0BMo
	hVL+v+dcj6MGdSYow0UWpQNZnQUyuTy6+X7UX8LgybaYGrzxOx2VqYxeU+LBpxYqiaA1ju
	GWQSs6XmAPmn97Nk8/AHgAUfvhpF9Zw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-ghfvs0r2PgGrR2wepNFIaQ-1; Thu,
 22 Jan 2026 14:32:06 -0500
X-MC-Unique: ghfvs0r2PgGrR2wepNFIaQ-1
X-Mimecast-MFC-AGG-ID: ghfvs0r2PgGrR2wepNFIaQ_1769110321
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9566E1944E45;
	Thu, 22 Jan 2026 19:32:01 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 872C61958DC1;
	Thu, 22 Jan 2026 19:31:51 +0000 (UTC)
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
	richard.weiyang@gmail.com
Subject: [PATCH mm-unstable v14 12/16] khugepaged: introduce collapse_allowable_orders helper function
Date: Thu, 22 Jan 2026 12:28:37 -0700
Message-ID: <20260122192841.128719-13-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qzL1ixGrdvj7fm8wu5vbwYlSOZEWitPs5yukGgnaUPI_1769110321
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B1A9E4000B
X-Stat-Signature: gqtrjjghe6st9jo83dn1i9cnfmfqw9cn
X-Rspam-User: 
X-HE-Tag: 1769110329-362068
X-HE-Meta: U2FsdGVkX1/RjNih0DlCrN3pWn8hd+iEP+0Jh61NF1EXT8NkQJ0fmmHPRh/MC2Th/IZ1of8E2OMwpiT3YgGah6qHhV/2bRWc9XjXeieFx179D6WxcrpXrVJ86V13VVhoJ2Zek1gMaqTjslPM7MHcHCwvy7TlkSDvSTIVfw9viZPX+4CFHJ7h8NLNBVpmeL2ioEPqmtmLnVGLo2UaLj/UDzkHFcVG7x1KnblpTyJmeTYFuygU3TM79xqecUNVol24m9dx0LVQS5Jt0YUfysNZFFV7rBg9ONBV/B7DWuZJTMHJB4QqMLL2RqCCmsaJNRU/UgkmIIMpOlAKYgB3FblTYVSjbMvGvV67JHrq9ZlouHg5J/EvRl5nSEGAWvUVUHuhJG5Mywhkn9zVw2fh4SQhFI9Lgn6eWtKyUOllNZ2drU2s4WOsX6GDrbQdx3lisw6riUO8M3wDe4cJsMopvRZWgD/06wg1YNmBkELwFOegQDjyOL6ABLuR45l86KZEVHGUbrJflOYf+uUZvRXVC4w0z237jg2eF3jkzRsppAksBmFI/XnvqmCJKGUyA2vWtWNw2ifiYZBdv5WnPrL/0q1Bfy30yznHOyzqBTCW+2zVE+4u0jje3AEnoHTIO0i1LiBF5r6kN8BXOZpSnSCNggaZynH2yZHd4R0bJ7Jbk2ajFSchcGX3roM6zSDVDmQ1EEqbOZcxTywun0SXrowSOuAqViCOGIUet7161Qs4Y+IWQ4lFuCnPz6IicAtBA9ErB9KoCdhZ5QpIFn+LbNuCBU3A8G+aM9HVwvX+Ey7/GMmdrdFBbVzsVDlEK8U8x30+tvoUnWmN+wK5OXtZKA6fWE8vShdU4WdMnDM5/IpYxE+4YdvNhevvWsmgKgkqwrqhuJyDs993FIO9XVBWnvWxQj6ESarszPc4J+Hpud7tuUGjXO5U0cu+BDe7tDrc13bqA2HIXbIciaRlZIjPGHfz1lb
 wocaPVSG
 H8MZrzHx5SU3iwWgZ3uDRSmpYtLk0MJ2r26GUISGHz9HShaAuW17azrqcIr8QbIFj3CcbKwymovZ5C2wVO0Abuy4DVUIlbmk0sF/mQN2l/A9YBA6Wnh0nv4B/9Zj5NwFR4IR2wcy+4JCfsdxP2sbww/Rj83ERSHNb+B4Mq/qDZZANlEjSWRFUUe2+hWwR/CT7yk71PdUN4ZFsMEVtBYu1Rv6aXWtC2U8x6ww/HtelEwtY3T8fyZ6AREn8umwY/7hI0+XlkJKikeRLAvZjyRsR5kJ77y0X69R59BHefYmeBevgmZmPtP/2Ig08Fv3/1Y0U16YQmeERp7G/fhJYDrBxB/ZvHseR0S4hXDW5LP12t3UIjJ1myEKZwbS2sWtiurrSi9qakQJDviGw5MEYH3O4OgnBRvw3KQ5h6LeI7lD9DW8jqwlS49tDr7l6LBOvI0ztlRwdLG1/ZCjKaXmTygG20yw1+ehRh+z14x6l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 mm/khugepaged.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e33b2594949d..11eedd261285 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -498,12 +498,22 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
 	return -EINVAL;
 }
 
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+			vm_flags_t vm_flags, bool is_khugepaged)
+{
+	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2610,7 +2620,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/true)) {
 			progress++;
 			continue;
 		}
@@ -2920,7 +2930,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, /*is_khugepaged=*/false))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
-- 
2.52.0


