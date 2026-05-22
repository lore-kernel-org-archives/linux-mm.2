Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD1ACCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200F36B00B5; Fri, 22 May 2026 11:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D92F6B00B7; Fri, 22 May 2026 11:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE266B00B8; Fri, 22 May 2026 11:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01A8A6B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:03:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBB1292D39
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:03:17 +0000 (UTC)
X-FDA: 84795374034.04.67D8340
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id B223B140016
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:03:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F5SgfsKh;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWfwFFjl6Lb4dHrdy8ub/C3enhHFGrLhYF9NHuqt4M4=;
	b=6RPtKGrMOS7d8pGPent1Wz3ejt6OlP8wmdxHAgW0TFmSusMVs2x0TEi4L99h+Js1suepvO
	3cOkT3YrXA9FaQPwVi6JKFmXdviQeW2H58kHQ5cGpyqQeyDogrARjjO59uQU0klmGp9oi8
	F5xoSKfZ0uY43NGZT5qGvO6v0T6ubQc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F5SgfsKh;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462195; a=rsa-sha256;
	cv=none;
	b=5Dpkog+hbn+LWpW8ZElZKnjn672x0dbpikMINXYuBhTBlwUmtw02F448XNTysy9YCAeH6P
	B+TDQ06W+1BGkvWoivz8tp4/j/45Fa06E+ZEF9/GOEcIoPkKDY3pKy4eNnuNqyaEzIit+p
	7fxlrTviMWPezPGFErJEM+uwEKbfpKY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wWfwFFjl6Lb4dHrdy8ub/C3enhHFGrLhYF9NHuqt4M4=;
	b=F5SgfsKhB0B1VGmxwWKrPxyZ2AUs1furmXz4Uu/saDk/Ndk5GoVYeUajKpQeoXvqyN0YU1
	QmhFmiyODgL7GSKuHGPJqfh4nTJQuLMSHHPgnYeWOKlGMTgjMjP1Y67FwsNZFPW9ggnJU4
	bS1pKnNLG8vfLVkeYpiHoYMnSj37rdc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-QDwcTRlwNYaulxbrmgrmCg-1; Fri,
 22 May 2026 11:03:11 -0400
X-MC-Unique: QDwcTRlwNYaulxbrmgrmCg-1
X-Mimecast-MFC-AGG-ID: QDwcTRlwNYaulxbrmgrmCg_1779462186
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1577818005B2;
	Fri, 22 May 2026 15:03:06 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4B9471800576;
	Fri, 22 May 2026 15:02:48 +0000 (UTC)
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
	liam@infradead.org,
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
Subject: [PATCH mm-unstable v18 10/14] mm/khugepaged: introduce collapse_allowable_orders helper function
Date: Fri, 22 May 2026 09:00:05 -0600
Message-ID: <20260522150009.121603-11-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yXdAzGrAgfnndcJdicf5YPXzyOL3nYmyWDzeWZmQx7c_1779462186
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B223B140016
X-Rspam-User: 
X-Stat-Signature: 6gnpzmeihid5nhkq81hhoufx1jja5o9q
X-HE-Tag: 1779462195-888155
X-HE-Meta: U2FsdGVkX1/+Mb+r70KED2VKHPxQ2E1v0uymRibokYbThXBvV6plgp2N7kMTKFJ4/JMnkatqc9pbE/XTXW2h6dETq2d4DVtWdLF8qPIPiyIfdnEmxfuql+LGHYavDbz2sNP98mZeaStMyvJx06D8SCO1eHAr5O+Maizm6oTSArFqhPGWU7832ucLHc6QSuh12jRhpsUf5KtiDKTwfdQSo37X0wXIj812WnQVJRBueUN1jwupqjGQlXS+HyrHsaHwLWWoVgZJinjv75bhTwvpNMDUDpF24F3Dq7Y4JlM1r5YP7cVdE73f37TK3UkswbUMfqGtEIZq6rf0wAysscUxTn9A14LE357ZsiK3eMA4mIj/2mG62KAbxMteQlYSRvTZ93fPvPklHYyDiT70PdREg2dLH9ey0GEXf8hKmVzPauZNg+ZE/ZymN0M6xIfPoxC5YtEs4MVi6rPzV/BEMe848135b2DTAtewTmSRDMPb2x4dRX/6lFLj5vDEEYkDKxA/t/sQ0miHARxZ4CYpcl9xjpjhv7pOINXEIuOxORErDBqqHEY0UqdldZ5XwMYQMCjFzi7/wseRqzs9KQ9LYzqxA9pIsaehgMINQU4vLW1tsc5nKzQmOfOra2AEb9IrR+PGd25jI9yd8qZFSLvUKeMAQBCydry4tiKazvIMByLcHFBK3+qZm7zyJQabfMgO0c/h+FBNvs9ocKLmiq5g0PQCusGIqzLAmT3/5vMW0UiszvqCRvWsa9gDNy+P4I4JBSmVEpDRI6B4YgM6jqnxdhS3lEONMzsriV6erHdG0nCCMp46KvKf0mJ5+I7UZbcre8ffI3b+cgAWIH8Xw5rIqMIY/SAP1G6pssvIlCq4rZzEBy5OROASvrycu8Ke+h3t+PdvXU6ldL8tNDVbxZWXvgBRrmGEP1QFB4LqTJk3/hcP4YEihAzBDxEAPpGftocPnEUc/QDayQg/N4Nn0mTyX/1
 PMcMGvfs
 xXimfhlsJx8ArDmTp0YHMa8Wn2qxCDu0jzArqKPFWXhKWAiCGQy+vX/qRC1m+l7RpTO7b76cWAjGmKwgQoYboC7jVszVzEAyIGC3RfW3gYDRrTxIfEEDYTBbv9o7UANZMWo13HvPHEGCy2HvAOn6JkEYOItH7mejsifxPVuroQDt7C3fkvYd6H7hqKcVLosb0+IdNsPmSgH+DsFVHKV3+nHDjbrq9774+Eh5W1OMsr9xoKTsjLyaKfVIHCH0o71jZldthEhL/9Jfj3gBOwa85gH4+Sa8rB2fbOOplfubBMCWulF/EHMH1tnywCsc8VP+ow5id4Cp2GOaAXW10Ef+AMByU6cxImxWa8QpU0OnFt7gNZAJSn+bRb5yW8pjtG8CQ2b7OuTFdq3OoijuzgEynMA4J8irjeZXFzOkRhAwBi7OjexlcV/qkac41a0pCp1YC/0Ft3UN7mXvUCo8/NHvtx24S12nfexSLlOp4
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
 mm/khugepaged.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4534025bc81d..64ceebc9d8a7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -552,12 +552,21 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/* Check what orders are allowed based on the vma and collapse type */
+static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
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
+		if (collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2680,7 +2689,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -2989,7 +2998,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
-- 
2.54.0


