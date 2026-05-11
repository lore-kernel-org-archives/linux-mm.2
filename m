Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4037CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52FF86B00E5; Mon, 11 May 2026 15:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506F86B00E6; Mon, 11 May 2026 15:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CFB6B00E7; Mon, 11 May 2026 15:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30F516B00E5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:01:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E70DEA022B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:39 +0000 (UTC)
X-FDA: 84756057918.06.473B7F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C9CC820019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:01:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RxJ4zVq/";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLKWzAXxuFdVII4Oi9prydKI/0UnwpubhRdfHJW3LZk=;
	b=BBHQrdSbJ1yKxTp3iuBF2Xkv5UNRMSgnLyDh/cyKiMeMKv7+2IwjtEHns7Hj2k9Cx1OFmT
	SxbSe4M3ggCSDBpZJ+pbop3uo5EXdYwYesm9V9dEK47zM47IjU4xQDggvlFp/74GB2dZoe
	5/JrBEaClDeJIjuVSD9qOUqvTzcN0C8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RxJ4zVq/";
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526097; a=rsa-sha256;
	cv=none;
	b=UIwwxCXrDDgifni7t34zPDgkKGVz4a70mn1pbI3507Lcc/jfiXb9LV98XI3+iaMTcgQdVs
	KZiapOdCEPSP01O7IxteRjHgu0IJPJSAhAY8n76EXsKfTmrLsjT8PxyAd288KR4/LT2if6
	s9KpF3p24qUk1j3BHf5QI3L+0U7dHDc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLKWzAXxuFdVII4Oi9prydKI/0UnwpubhRdfHJW3LZk=;
	b=RxJ4zVq/ioTxa23UXzsO/d9bcgpchmrC3yB7zRLNUhaZQ7cVGhca4CmjvZOuZ0DcS9B/Hj
	tgS0gvIALesM2zqVAOq1ds/KFVRdIDuf8PgOGTpPaZvaiKhjL5nbuySdy54g96eIuLuetx
	b+6MbJsD59rzDAxfXwhf08pQsMkWVMY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-_hJrsXkKOb-uHstKlrMaTA-1; Mon,
 11 May 2026 15:01:34 -0400
X-MC-Unique: _hJrsXkKOb-uHstKlrMaTA-1
X-Mimecast-MFC-AGG-ID: _hJrsXkKOb-uHstKlrMaTA_1778526087
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0528F180034E;
	Mon, 11 May 2026 19:01:27 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A09C30001BE;
	Mon, 11 May 2026 19:01:08 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 10/14] mm/khugepaged: introduce collapse_allowable_orders helper function
Date: Mon, 11 May 2026 12:58:10 -0600
Message-ID: <20260511185817.686831-11-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zjMMflbjEy3_qVuH8_U5sdmFfjsE53IZBncWxBoEyJI_1778526087
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: r97hm45fkygm8gs4kyrjnc1ci6g8yrtu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9CC820019
X-Rspam-User: 
X-HE-Tag: 1778526097-321144
X-HE-Meta: U2FsdGVkX180SgvxhBK8St3BbWEMq2hoswGfMr07R4ZslKIKBD94V53bngO3jV3epeZM2X570fpq/xx27k1rgb/KZVuyOPEh+Ft5q2jKHZMsjK7qH52sym3tVj76Io+LUWEBypDFHtEN8ZqRkyLdEQxdGluifI08sI9fWtXIE4T+o690Ha7tHYuFPuwiu3G7vQYdsTTtXPThBdkR0JS52gr1yT4Rd/ZDHX1Z7r35A0MoGX+Zj8o3nzxSs3LKOm8vHAXIgSwya3sOg3zWndXgifaA7Lp/CyqLjQ8UNY1io2YT6vYDdd3T1hlhS3/KljdrX9Y4JLbuPkWyByQH4pcefJ0HGNZEmLeCR+wzNF1ETF6LejRbT7c7MiTNM+XEdHyX/v+5/gNQapzSBxbD/QDviqIzJOacJFpoNcqR3hLTYiI0eStsY0pt4z4NmAyueFo5x4m5C/JnhaWzlkKjXBqIUbms2GLtz5D42OuQbYDDTMX4heV7GRx2sgHQFcIBNdkyhu34AThoCzH1Nz+ilqWuE+pPUdGjpB2nxO7DNjS8GXPya9nQY/ep6F0URkVBR0/5tpCnW920i2UlnEcpB/d5zu3ivuD8UmdLz+R/DdSAPnQFh6RM0fnDdGQplBBtPzFl4TuKP7PgxSFV+jgeZgoRhozEQKpK0cQpwmA7256n1w63NGZOuRDv2eEs+9ms/r7kN6TSGW3lrfpkBJKnKHEaqhtH2jDaqx7/J+fYXl4KB88owQCKZRwltR5Gfwglq8AIXTpcTnqeNdDcuY6HsGhN8hwZRTKsgLRSNl8lAZJ1PyPss8jBHUJ9cDHkhTxTPzjXRAY28ybAD1wGyV56l/vGiUN37Z7eWhYjJwzGtUci/Vx+DX12MtmzlJkFGspfxgzGqX9U3tiuC1Ni1sXUxS2t0bahsUtNxdELnA7Ux4jswyxEw69Zi3EmPK4NJRSf6l0fERWClnjsxJrC54rmz2a
 IZDFv5mS
 yXvGL3jHM+vpycwDXV80N1plptEnnVeJhIHaJ5dJfgg8+OUjACxxKgkDakoNiyyEoTEPLBe+HorGsPzQVi41xR35h3HEtiGT1S8MGvY4USlYD/Yhz/5XW4Kp0kda6a0EIf9Bpmif/JlmH9sI0azFXCrfetER6dJ8u5YEvhecJ6l6y3Qbl24Elu0IZF9d+sTuXQDc8WifLwbeVThCcpzHTIr2ZF/KOS9DbzePNV3tmNcZG/uCz3WeYS/ejsMxRXxTHPMCsEZ8odWb1JFoBZrQnuZvR3ZOR6oTPvlqs/c2lGV92I/fZDyadCsQB1XxNmVb03wDIUwxyq47eZJYarku+NCdQWE4vLM74Vsz9l8d9Oz+y3FGVrPfKYGxfhXwHN/65cOze/s8Ksh1TN8okdsNmvbC9TFSn5xV6BKRA4RRFgjM7kYeslQjuyf0gIwKvaiT0GUNI2RTd2Q7wlCyMwCbJFlxiBfKKcUpSONA2
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
index f28066069437..3492b135d667 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -545,12 +545,21 @@ void __khugepaged_enter(struct mm_struct *mm)
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
@@ -2673,7 +2682,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -2983,7 +2992,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
-- 
2.54.0


