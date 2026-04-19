Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C6ADEA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 19:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E426B033C; Sun, 19 Apr 2026 15:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0160A6B034B; Sun, 19 Apr 2026 15:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E556B034D; Sun, 19 Apr 2026 15:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D843E6B033C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:02:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66ECF8C089
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:02:14 +0000 (UTC)
X-FDA: 84676225788.22.E372CEE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6DB9B4000A
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 19:02:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VC795d26;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyeOJMKykrcVsdpKCbB17DZJ1LlgoGe0DTBMLcgdEIs=;
	b=PAfx4aZsHUHUMn05zHQFwNVeSeimNJ2QrPeg0og5KBagNcaEyZKrtD7ITQHXUdbsM9yyiA
	MptLYqgZPiGg9j9nPkmjTNWUrsAsyflbHeVTbcC3d6KBN78Kh3T2L1FqSvObl+jKaYeJfE
	SGi7Au5IEEMVt9PHMl5H6W9RTMLkQXc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VC795d26;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625332; a=rsa-sha256;
	cv=none;
	b=UAF4jVbioPVygLN+AsPT/Grru5pFtGUC/TBDxVP+VG2mvLQGVimNUy8hwIqFkl0ckQ/VgV
	JhkjqHgfTTEvMQSDLUrGI5TYeia7U3ZK1ETnkolWcC78z98NhxR0KemK/Dzurn3XXl9Vt4
	KFGrJYIq0AADHQevQugmoaQox43XBEI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776625331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gyeOJMKykrcVsdpKCbB17DZJ1LlgoGe0DTBMLcgdEIs=;
	b=VC795d26ihb0OzbEFsEhroixdkpy7c54z39J6ZLiFpRhkf9OnCHCENaH0AiHqWCOlUq8iW
	VhmnS1pJCP+G1QGzuKvLYLaFcUlFRIdkuRMj3kNHtv2y37novS4wSH4pvGxWkCcwo/Sji7
	zmSAFKY3P3EA/jKXgLNfwfUDvBsoJaU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-hnJ9yM6VPmyPUzvGJVDYaA-1; Sun,
 19 Apr 2026 15:02:07 -0400
X-MC-Unique: hnJ9yM6VPmyPUzvGJVDYaA-1
X-Mimecast-MFC-AGG-ID: hnJ9yM6VPmyPUzvGJVDYaA_1776625322
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B77091800352;
	Sun, 19 Apr 2026 19:02:01 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6317F1956095;
	Sun, 19 Apr 2026 19:01:46 +0000 (UTC)
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
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 7.2 v16 12/13] mm/khugepaged: run khugepaged for all orders
Date: Sun, 19 Apr 2026 12:57:49 -0600
Message-ID: <20260419185750.260784-13-npache@redhat.com>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GnkzRgzhoZxFWJXL02LnDNbPUu3rAsDZh5PmW4MH3HE_1776625322
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6DB9B4000A
X-Stat-Signature: ie57k3eqhfp7nq3xb6ezoy8rfhyqdket
X-Rspam-User: 
X-HE-Tag: 1776625332-800853
X-HE-Meta: U2FsdGVkX1/5+dh1Dsq7YBrBpmZk5LNvclABR37wmdhEyQWy4FScHbkHPfNicOL/S2Kdd9NDpTbmHeDP/Q/mMDHBpGR3TKoKfiuAWbi5WvuV95b4fEBHZ4KOimZN/x7ag6UTDD7C/RXMjy/66JE1HjxoIXbOPvnWrVUlGrwrubFNHMc8FqqWiVBlx7oe67SzFMKSr+ahtN2q2KnN5hkp3OSghCrj0lA9d5+H+pD8KFYr9q80yurJ7fXtAYn799UbZb1k+xeOBrHfVcNmcEyo8y7/hvGm8qKpTnjbP3xeF358axRzGMQMKXb8quqgQALmFilGxuGi7gcZ0P3wJ3sddmoYeKb4xrkOwvccM/02I1fm9JSTvVBCFLaDuVCyE+xWvEeipwZPLnz/yBt5eHxwdtN3cvspTjGS8WS52AVRmGoi5SDiE0IgkefntcF9IZ2ZwaW7KzliHooLJ3ctMaKBmaT9DzpyPrrTU3ugT36mSJFweJ2RAJuj4rPXSbT8JG+GHUYx5uNXduLnzLtF27nY7ocZiiAeE9FpYyNnwf3Opk8wKT3BLUJMJkk1KJABWKJmZSa5W8YMfEf2+F+u/cHBkLFu8982/wY4S5bqHh8vm92djv1ponuPgXDxxEUyWJT1x/N9i1xPwlFuoOH9qcf+8pUd/p4FOBgQFL8JOSR21jCvbKuW2qOB3WIW/CQqr3w0UVuCPOOJd/mCLkLZmNPaZW+7EaBceSmGeTetVmFiBjju6Gy/WtCYBT8Q9MPBfGiVzRDTRV/0uPICTlwKBOsXf96D+E+QIN6omv2fiUCNF+MXqKbPWF73b3gv0aYiMV4Jgr2HGCOyo038+RC1az4IaQb9sXMXh3Z9+FY5I/IiCLSZzta0HB01vDsMpYcyvsQN5QcEFK3G7qsfcEBBdf3HiE+V/E++0YeGEblefpy8N0NAvye7mFr+l5ow4I5SpPMCMH6kbESwGyNnx8a19oq
 veTBwHIk
 qRBrizvPPYPWnpXOiVqPyHCQ7KS0SyJdEE49yIWI2EGMnxxgltifO4U+MnhmqpM3uhwRLB5YPQoUGiUy8nzUWDa5AwVWzeOJ8DQWRQZo+X3tjoPrJTkVO4bWN4BzYnRhI4Ts3o1PpuAlUjDuCr6KIlaxlJaI1dh4NjngYRwFOrcMcaRZMFhPFEsmpQSth21VLMX8vwjoc4hHQSO6LDzLu1CwDcXwe+SX/gQPZPHsJLxvHYfaceFXAvgz5HmmHe1BxXWw/sk/bAFrdKHh9iNThgvwKjRHf1NG71ehVlWcyH7VHxqllpNPgKFa3BppQ9LLMTp10fyY2HVMnZmDh/YoJaohU9s7jOUIPwRKGr8y4GaYE+k9HN5wubZYazyfvZeGxX2GUIO/ylfPVmI6iHv1ht9IaJi2EyXnlQ4shymOFOhTc4iPdvl1ghF4L+J6+jIsizyPsV7Q/BSLhbKs=
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

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 13b05bbb08e7..7d48d4fbd5f3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -524,23 +524,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -581,7 +581,13 @@ void __khugepaged_enter(struct mm_struct *mm)
 static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 		enum tva_type tva_flags)
 {
-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+	unsigned long orders;
+
+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	if ((tva_flags & TVA_KHUGEPAGED) && vma_is_anonymous(vma))
+		orders = THP_ORDERS_ALL_ANON;
+	else
+		orders = BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vma->vm_flags, tva_flags, orders);
 }
@@ -589,7 +595,7 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2936,7 +2942,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -3009,7 +3015,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3040,7 +3046,7 @@ void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3090,7 +3096,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3116,7 +3122,7 @@ int start_stop_khugepaged(void)
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


