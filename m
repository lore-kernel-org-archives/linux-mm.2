Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F79FD45F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADAA6B00A1; Wed, 25 Feb 2026 22:27:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681716B00A2; Wed, 25 Feb 2026 22:27:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584206B00A3; Wed, 25 Feb 2026 22:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1A16B00A1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:27:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E091F1B74C7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:27:13 +0000 (UTC)
X-FDA: 84485171946.02.2238C8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0457140007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:27:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OGSOrsIf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076432; a=rsa-sha256;
	cv=none;
	b=pSMq27AILNAV5NbI3CIgn2JqcLn/jBOqFEnnIwyGDnqEceeb5ptqBMJ/Q4igm0Csgs5Srg
	OHcNZnzTrVHid7+S6JXWS60i8DQF8iFlEgFCY0m5z6Wqc5+TIa2oxW1nC1wyb6R/5ii+0d
	3KKwMcYsLC7s17W9ckZR3l9Smz3xNws=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OGSOrsIf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LukqnOQ3nPLzH/gZ92bTPc+0laqCOwSyataIxT2ZV7U=;
	b=uLemI7tRRbqSTp6AnrTUE7Kc8QSIF3i25lDwvQL14xapCx1+jc+pJIRHlXqtOUcPS5cAow
	aRTYRgShl+rJWSBHrlaKq94Qc9op+pN3rRhwqdjO757mX0C08q8TUmHw7faWgq5iIoxwLZ
	C+1fSrNexDklhs0KbSGMSlDUvcNtwGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LukqnOQ3nPLzH/gZ92bTPc+0laqCOwSyataIxT2ZV7U=;
	b=OGSOrsIfykDtBk9GkirJ1BXgHei+rJYHqYKsbbNu9NKNOULcYdyEpTnm9QznAdHpV1iQ6I
	rqfAKkD71r6DUDOde71fVNp1FnUHLwWgwezD2MXQogYcbquXWPhqy+LtnHtKluovEp7LYx
	7uiJftLk6LLKGs0jZaRDK7ba1hVEErE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-EhYTM-N_PMSSJ563MXe9bA-1; Wed,
 25 Feb 2026 22:27:06 -0500
X-MC-Unique: EhYTM-N_PMSSJ563MXe9bA-1
X-Mimecast-MFC-AGG-ID: EhYTM-N_PMSSJ563MXe9bA_1772076421
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A54518002C1;
	Thu, 26 Feb 2026 03:27:01 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D50CE1800348;
	Thu, 26 Feb 2026 03:26:51 +0000 (UTC)
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
Subject: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for all orders
Date: Wed, 25 Feb 2026 20:26:50 -0700
Message-ID: <20260226032650.234386-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m_QlQUJZjTJ3RY2d6Ja5kxbDp5FnWTqHFJrEoKsoCMY_1772076421
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0457140007
X-Stat-Signature: yabut6c6b888guc1y1n7tt7bk8mhqx8z
X-HE-Tag: 1772076431-152327
X-HE-Meta: U2FsdGVkX1/ODtQ0KhNp5tYIHfD2vTXoo7O6b0lJE5R+nw0YomXgOyKF6mfu29gq+BJXZ7GBzGb5pYbo4B7WARuNlEatKY7ACwgH/Ji3vmhP94sLWqbMgPcRgmzw5xCOxEypJ9f6HAO+NFE/lw9r6UJEE5OfAc91ER6H2qbohdSQk8lf3AHFx3LnxwzJKESQ5aKDd7CEbaKqp/z3Hhkfz8al8ud0txrLFGmxTcmenf6B+i4Glfx0lDZiEK2F8MTebCv0V8xh+lOxZvGflpVKzNCjbyc1EwWcnyK8Hc75FB8oSTJh2yVIcMJyKf4PBmXQqBSCvUJC0I8DPOqbciXMKDVNgS1VwNVTF2d/LZx8j3gFz3k8pb9CMnzYZUpC4MbuOS97+QaKJEsS8RcJaorLfPa9v5oaIXtwPkzfTfZLa1KVjl4PtQ7AxVchubSipimslrHCY6fOmVsinLrF/PPZKWRVyrZDV+5b1pBS0M8L3xrT55lqV06HS4VFsnH7WBLIyFPKNiqKupoRJNwuMZ1eq7+6vTdJNOhSAlUKCjLN/aTgoJhEiI2rFtPgADWL4Sx0tDIoAvYuVDmf/m/q4oknEbp0rP9D0kaYqgX2qgr3ErKieGsHtKqgZ8Cy8naJX71wSVWgHvyORT4OycC1s1QaLyPmksa3tizfSJuDR74iL7y1S59RPx0jgl7XYwUwTnKx3TmbMtNrmnkLAQzpVGsuknuScUVLOSyqsSn+s3aLQLscL8+ULdKpv2A8bMPstmlnMikBfhS2/DCHlbsY+JqX1aJj1IO2rav+dtJoQgLKYhn41h1YceAWIYpfHOb3VzJk5qWJR1oiZoNGtN8G+Wt8MKd30bkeayzaiOyXCRX4k5ZXt4iyxy/k62U2eSw9El2OP3KeT06FJhyf23wMyjr4wDTyXAgAezeZ98lg+mrNdYps0WU8e55YoGmn7kMMILb0cj1iBxpnEJkmw0ZeRni
 wI50FI4C
 5xL9pz6sJVQzVkKxpdthNiN/31Ggy4DW+3M0xyh9H/fKDwdH0DMddCxcuv/GYDyZh6GmdGxmrO/zaFsJTt5IHC/tgO3T2jaz8zB4Dc1Fyfh6zZAxiD4fNP0F+q3Wh0yQrCpTl3CemkLgb/05SapAV1VVQG/N0wqEM0EYjZrGTi+aSe87NK97+QH8dHygnQ12Hi0RSWtyOrLchwjM/yh44Pw3kGBhZH9tehX6rqdXnZu2x6/wc4Qx2EHf61xCzCeXUc3qWEZvJzMlp73sbatiL8GSydc3ea7tu1K7f8t1GxRIuyuIvifek/f0VVFJbu+oYCkPR7xPccddNw2pvtyOwObxWa5AUKcNtUCUc3uiSPZ7kBWvNVTVqDqlG6656RbQotWkwKQZrN7Fjoo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baolin Wang <baolin.wang@linux.alibaba.com>

If any order (m)THP is enabled we should allow running khugepaged to
attempt scanning and collapsing mTHPs. In order for khugepaged to operate
when only mTHP sizes are specified in sysfs, we must modify the predicate
function that determines whether it ought to run to do so.

This function is currently called hugepage_pmd_enabled(), this patch
renames it to hugepage_enabled() and updates the logic to check to
determine whether any valid orders may exist which would justify
khugepaged running.

We must also update collapse_allowable_orders() to check all orders if
the vma is anonymous and the collapse is khugepaged.

After this patch khugepaged mTHP collapse is fully enabled.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 388d3f2537e2..e8bfcc1d0c9a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -434,23 +434,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-static bool hugepage_pmd_enabled(void)
+static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
 	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
+	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    hugepage_global_enabled())
 		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
+	if (READ_ONCE(huge_anon_orders_always))
 		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
+	if (READ_ONCE(huge_anon_orders_madvise))
 		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
+	if (READ_ONCE(huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
 	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
@@ -521,8 +521,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
 static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 			vm_flags_t vm_flags, bool is_khugepaged)
 {
+	unsigned long orders;
 	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	if (is_khugepaged && vma_is_anonymous(vma))
+		orders = THP_ORDERS_ALL_ANON;
+	else
+		orders = BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
@@ -531,7 +537,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2929,7 +2935,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -3002,7 +3008,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3033,7 +3039,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3083,7 +3089,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3109,7 +3115,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.53.0


