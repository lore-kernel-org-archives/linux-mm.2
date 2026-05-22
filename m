Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD33CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66DD6B00BB; Fri, 22 May 2026 11:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E3E6B00BC; Fri, 22 May 2026 11:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954BF6B00BD; Fri, 22 May 2026 11:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88C786B00BB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:04:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 585B91C1BB7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:04:13 +0000 (UTC)
X-FDA: 84795376386.10.5AF6644
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B36B12001F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:04:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoRagEbE;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLLG77J6wZkVHS43IrXXalUy8dvMgmyLxeSAHVZyfWQ=;
	b=se2UiQzVo5yLtqqJg6DlKjHfARw9XGCWBm2OnSHfDpvoVmqdoQPUuqBgYD68FmFB13sNL1
	91sOwcrouxC6lvQcQyiUPNTfcALUNIbxqzYzE+/spQ0z1Dwas7d+8CIXrY1FWQVF5rWnai
	2WXz9Btf+AYbZPwzw8bOenBpnWyXa78=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DoRagEbE;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462251; a=rsa-sha256;
	cv=none;
	b=WaKVNxB+v4EYia5lYNme8Rp3WXVs0lSeEIy1BtYk8tve2vrQdG/UJQyJkiY48BDhEPKygl
	26atC7kbrDYmPkCb/qiXce8Ch4po9LLLy7Xd1uWLRddhAXgY6PvAflMXzooD2xtwpFxPCt
	gKNjoWAv5CmC7NMVLTrDWeeIGM8MktM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLLG77J6wZkVHS43IrXXalUy8dvMgmyLxeSAHVZyfWQ=;
	b=DoRagEbEBPMoR7WNS/hVJ8KAlMEVhzoCavOG/Jlx6Hdt+LsySibLKHkN2+/keeeJlMV6b0
	lhLH1bGaDASqFlzVeKDUuU64NyRIFXSUIncdEAaM4z6cTzqxbSNUarueRIcLZq5tm6THI3
	mbu+J8c3XgQMpG7XzegA5WEfRGqjAGQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-138-rYhZzS1wNmKQQWrup1ZYQA-1; Fri,
 22 May 2026 11:04:08 -0400
X-MC-Unique: rYhZzS1wNmKQQWrup1ZYQA-1
X-Mimecast-MFC-AGG-ID: rYhZzS1wNmKQQWrup1ZYQA_1779462243
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00FF919560A5;
	Fri, 22 May 2026 15:04:03 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF4461800576;
	Fri, 22 May 2026 15:03:44 +0000 (UTC)
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
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v18 13/14] mm/khugepaged: run khugepaged for all orders
Date: Fri, 22 May 2026 09:00:08 -0600
Message-ID: <20260522150009.121603-14-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q7dCmmmyMXtUKKEXyRQ-KTqsnBOnYYkMYJXggjqXnjc_1779462243
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B36B12001F
X-Stat-Signature: 5xpzt6nxoi8a5cc8bx9qg4ihsksfu51q
X-HE-Tag: 1779462251-578666
X-HE-Meta: U2FsdGVkX19xw4b9PgsIgW7AG3hXZMAKrLJms6tHxvC/dXUTRVKegSfAfI4F0UzprOEEjIzEw+ms0tSummZCLiY4OEneex/cTdaV8KxrLf9MdTAPRWkfHNbO41VDhlkAty2GGbwfvyjPPL21Ob+eAFqnWQ2K00srvvpI/Az+Cj3jii1AY4eEr016PWQYSBQkqc1yfJovamQFaLHG+OnK5fZsX1Bu8T61FMlJGM/obH5K+2snibTY1EIWZuhlDGfeHgrF8E2+sumujIPUblNUzHgApMtnnlBqxxc9FlOoEtg7T0AALf4a8DgWHMcKGE+LRHGtuRebMzamXNW8Oxqc2P2E8mqHwLld27bxKMhhKoqlMmKw/SwIpUhL9RBuqhllUlk387vRhK6rMmXznxU/bzliGrLkp3hSPw73p1uN+F1eqsp6IzxAuUW1nuW2G6dn0zyUVQ15A8B0XTfgRRwIK0EGtBsOXeXFfjfzSHermKkJGT1qcqpgXS2qRsLp0mNggJkfdCCSXNmIZyh3JlAHo58tdJuwEg0zE0ctXMg8Nj1689kjyqb5ZuBgPyuejaWnFRC4X+fgSDHsmi1FOLVGRMRinJkR/3uuR/PZQHDryATwFcrleRtCwkSX/LwWzNwWAvd0qV2qjUjrSfpFj477OiyqMim7F/wJpFcZShcZ/zkZ1BbEjZps13sxdB36Vv8N7XFETjjAgPMC1Y8hFYe4uAU+xsu8GOaPd1xulXlKYYG/SYHEgoHk7YDPJRCy5Gxt4lTwFZOi7/u22EvbgRTZDVwqyOptRyZx4RsfYPc8Pu7t+jflUykUs3uIAAncetG7YnZVptAkwqzFiQV76xaT4J2aKuFTbE78iIu5ti14UMYP2ewm0dB6OOGkbzcZhhPn4wJ5ni0aTnRz7Wvir9pWVHpvkhJzFktVjoPbDMBNSNku+wHSb/WuYTiIkqmtPmtQEelDQw/fO0BE4xWV/e7
 AVvLJYcj
 99yolyo+IOOXRHovh+pejxJ5w/2LIJefU6B6Q0GMBzcIAOMdB2PRZdP/LDIlksgRELknoCNKB2qKjcawMuAXeHY5hjbzUwRezIO64iJwFAXIqsCym0IRf6nWegutbfxkQV1UNFCh4ANUplY3sfUsDZdQcrMdo84GpAMh0d3qkR22m7UmqKNqpoIgl5NjLCFVY7NLsf+1b6phbYozfJSFoNW9TRNe7cnhKPjNkK/GRrsX3zrcFwH+hX5iIXhMfAJXWdvyftC9uZ0iU9jq7yc1FMX2hbrVBx7/8mXAFo8+K7AGLwRtWCi9ZsNgG5lbUxgfhxS2US3HN8GfbyaaDKKxkoLJxKJyqD1Rf4nvUGAgcZhJrpliJnSTN7hoTG+ODpQhpyAvk24tJY3zd4NDkczWVZPnpYQ2sBEMC5PwpyHw5bNbXE6lENMyCIaede1iAxV3mBA38AO7zUWt2gG8=
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
 mm/khugepaged.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 15b7298bc225..6d3f4ff6956a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -529,23 +529,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -586,7 +586,13 @@ void __khugepaged_enter(struct mm_struct *mm)
 static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+	unsigned long orders;
+
+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
+		orders = THP_ORDERS_ALL_ANON;
+	else
+		orders = BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
@@ -594,11 +600,9 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
-		if (collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
+	    && collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))
+		__khugepaged_enter(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
@@ -2949,7 +2953,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -3022,7 +3026,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3053,7 +3057,7 @@ void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3103,7 +3107,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3129,7 +3133,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.54.0


