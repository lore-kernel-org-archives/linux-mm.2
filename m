Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D967FCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DA98E0020; Wed, 22 Oct 2025 14:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5438E0010; Wed, 22 Oct 2025 14:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B758E0020; Wed, 22 Oct 2025 14:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 220BE8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:40:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEF3813BECF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:49 +0000 (UTC)
X-FDA: 84026616618.25.CD8A42F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23DE140002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:40:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aS1+A/D7";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpo4OOErIXDyCuGHV4XGlNq4YibnjiOhk8e0KAy/EpM=;
	b=SYvInvoDjW/7GXh/vubrxKFAh58WOVMLPW+yxDHfHnQLR/GCdheWQcK/ZUwWOB8OYTwwXT
	Fk7PfRNmivEK0jIhImg7L8rbxoyxTSIP2X8gtOUk9Z8fsnfaDmAB5IB7uCLF0kd1v/oujt
	U8kOSOIe3ihyOIK1ZrcKcR3Znxc403s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158448; a=rsa-sha256;
	cv=none;
	b=dx38Y0pnX3BIAhSFHraZJI9JVCYdFLSntfdcslvGo4OMUugAFieV1HW7Boca0B66mFmYri
	XELNYRMXekJ24MuB4xrIaZ4WAKrTD3+G30vf/+eEqMVKF4ymXebYlR6tfKrn3IzftbsHBu
	8s6xZ90f6PBhEeXtIY28aJRw3yzStt4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="aS1+A/D7";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dpo4OOErIXDyCuGHV4XGlNq4YibnjiOhk8e0KAy/EpM=;
	b=aS1+A/D7NRvdBezJrhYz/668aR24E7TSUC1y9JhATxes1U/U+jA6HHAleQoskD0OTEVeo+
	0meNWsMJNjLXgR+yVhu/zbl2iRWrMvMMsN9x2IiUB2O1ar4AXL9BAOw8OJp7mFAMXArEqx
	E8fuEd7TP/+5LZJ2FOnvjrFf1Ic39Rs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-lmfCQv3oM16wwZNJ6JgoEA-1; Wed,
 22 Oct 2025 14:40:45 -0400
X-MC-Unique: lmfCQv3oM16wwZNJ6JgoEA-1
X-Mimecast-MFC-AGG-ID: lmfCQv3oM16wwZNJ6JgoEA_1761158440
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C9D01956087;
	Wed, 22 Oct 2025 18:40:40 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00BD419560A2;
	Wed, 22 Oct 2025 18:40:30 +0000 (UTC)
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
Subject: [PATCH v12 mm-new 14/15] khugepaged: run khugepaged for all orders
Date: Wed, 22 Oct 2025 12:37:16 -0600
Message-ID: <20251022183717.70829-15-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam05
X-Stat-Signature: 49zn1um46g3m614e8psadbpqs6zsq176
X-Rspam-User: 
X-Rspamd-Queue-Id: 23DE140002
X-HE-Tag: 1761158447-293540
X-HE-Meta: U2FsdGVkX1+/y0GnrxTGXqOoUUT0QSt9g8hRpcde4BXPaafePl0heyXxnAdPV7iJf+VkkRsV8dxTbKDlYB1q8IUbZlL6Z/c+ZYliqt/2QNj+w9gsf1UGxuCcl+AJh6Uw2iz9S+ERpclot8pLvphK9p/4oHR4rE7AoDCKTXSJExv7H6sAF34tjwHg3NtIWj8UbiXRYbJFndUGlqSqJwSJtlnjPYpSjJFY3ZTRGav8v4OrJLCtuH4dD2ariU7YcaDLXDcUpOO5q5Uy6qadNjZ3AVUM8uKRiJgJml8qujIfDwnpeSNcxX9hoMM+NzKKhMtJn+3K5TEGvUDI/WZpkLSOTywdygiTaIAgJzMiTEvTlxdaHs+44bZfZabDSJ0dbVT2q00MnAfulVCseoATubec1vdNn1U7FY1/BzFhExH7bw5/uZm7wzoVlqdoS1EHIA4RJcyIU8y7mucA21en6sg2LWpsxaSB5LITBtF75tMg9to3o0GqUgw/jt7QAbjxm8E07vTORCFf1o/yJf6OPb/CVmQ24sSBeKN4r2Xe6A58SjvhvzWon1R5I74M6Mmkhk6O/daa2qAQ5nYDPJYEpwUvUOXOpPQm364MYaNzORGBhj4s//NaQb3zpcGcfvhLt3Mnt0yDQk4RIJNLkUECwtezcL+25NT5ICpkS6R7/aMZjaqm/C0TbZRsiMopfeubAQqsRjOe8MnN1PVh9pzEr8m3dyTz5y7ko2Sv6ORCL4OXWWkFfVqKEujiUw0BuDkB31BlWYPtr7dIoX5nFMJ3RG5hYxqeAHl3qXN+Ij0v78LHuXQFFVlzjUkXvRfMcCo4XpeBXgtzfP512bgaAcMEgrcLIEjQaJgUs+do++X0CPUYRbxS0mcfJZiBcnvOl3jl6LXUB6LEA8Zfhn4hWl5TiZ1H5DgnrbxMDsde5/DZx9zyBI/iGkX5U5q32xjgNDXCwpEogSrjIJciPWQJMP6gCXk
 IDyTWjk4
 yCvIC33buXLaMor5iLfQEDo3fZ0HsVcpdi2iE340Bm2dSjHJpM/THh/SOC3eKIbRC9QO8lTfaKSOmeEzfmrzsWK8mynAxrfgck+mlidGMIXzq3PNud3OlRQtObJZfEo2vFZ4bsmAXx8nY+HWQ1uw2PUj6PCLLX4ieuqY8MmaRxF8OD5AFUDGQ6WWaeupWkiL23lntyQJz6uwplc69bwflql9AGKK2y+DCdb9++U9237PR1ijcKRRrwZznyLZTlPhRr50s04kPVUvEbFUHm5vA4JNOhlfe04NJlAeBTmGHRskGZEq41oDIbVYd69SpJctDZ0FPVHylXSpoT9AKhievbDyJ2ba8FhZJfAAmMqBNhqs/xzTiTwB85BzSTT71WOzXzvpXYauolBtXRZ3YpEUK6HepDVLSYpXxmYSXNyVaXiwXrhE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 mm/khugepaged.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 54f5c7888e46..8ed9f8e2d376 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -418,23 +418,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -508,7 +508,8 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 			vm_flags_t vm_flags, bool is_khugepaged)
 {
 	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+	unsigned long orders = is_khugepaged && vma_is_anonymous(vma) ?
+				THP_ORDERS_ALL_ANON : BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
@@ -517,7 +518,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, vm_flags, true))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2791,7 +2792,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2864,7 +2865,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2895,7 +2896,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2945,7 +2946,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2971,7 +2972,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.51.0


