Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F67D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A489B6B033E; Thu, 22 Jan 2026 14:32:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13136B0340; Thu, 22 Jan 2026 14:32:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9088A6B0341; Thu, 22 Jan 2026 14:32:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE8E6B033E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B8FEBC717
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:40 +0000 (UTC)
X-FDA: 84360596880.24.E53E9F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 28884C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lyrpzyy1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBXdyfOtvY73N7Pr0542csSKEtdYLbSLAWLeREL1S8U=;
	b=tZR/1+qgxlxHEogMxXtlK57HFKpu2Nzhc3K1OumkVL+a2G2cbaoxS9xv7YBDrW/gXRBmQw
	NErqwZLIPJg9c9qBt9kMwAhTss1M/VM4328j/ImFNJz/D4pZSXpkPk7hIZA7i3spLN3B/b
	2q4xD6XuGZDOFgmUzgRy4VInCNz/+3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110358; a=rsa-sha256;
	cv=none;
	b=6oavSxbf2SrPXJjLWeCW05KCR069Q27ng8onIHrxKiwaUR5gN0QlC1D6ZJWK+ceLNx1yP1
	36RON2K9kAuf3ohZBZF4//TuXHUaBuFQJS1gebl2HvtPy12q1tCSB7q0o0ibNuEb6Tfth5
	ZXQuaIdtCEqA2bE32vV+PkUYtiBgWSI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lyrpzyy1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JBXdyfOtvY73N7Pr0542csSKEtdYLbSLAWLeREL1S8U=;
	b=Lyrpzyy13uKy1Pbh7qfaa2uBze1+/P/j5tXs465E44rpcaJ5JJ8gGATlrE5ZpzhmjDwrMo
	kectarB1VvCERVUVxFV2oZNkzdhmKPd9H8JJS+NoscwMi1sQa+LG/kh+xuSiEB2RFc/kRD
	gS5WoYhIYNruRl02WNZdJ91ObfW3RMc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-BBg-OS6xOyODo2YWNCddnw-1; Thu,
 22 Jan 2026 14:32:35 -0500
X-MC-Unique: BBg-OS6xOyODo2YWNCddnw-1
X-Mimecast-MFC-AGG-ID: BBg-OS6xOyODo2YWNCddnw_1769110349
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB00E18005B2;
	Thu, 22 Jan 2026 19:32:29 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A34271958DC1;
	Thu, 22 Jan 2026 19:32:20 +0000 (UTC)
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
Subject: [PATCH mm-unstable v14 15/16] khugepaged: run khugepaged for all orders
Date: Thu, 22 Jan 2026 12:28:40 -0700
Message-ID: <20260122192841.128719-16-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6RbLHUs9bJK3_HttVNtSNUNu8HP7vVkFZaK6UUbjwWs_1769110349
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 28884C0004
X-Stat-Signature: 9zdngjan4cegj4mun8cqo4h63oyyp548
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769110358-646653
X-HE-Meta: U2FsdGVkX18snK8RctqtY4vRow+wbO9irEtDrFVLoiqbvMFAt1F7xQ5xKtgm44AmXzDB4RkqNHipHV7+NQkyKURVD1Ts7tOwzHgeRWTuRmK4lV8z4TYPtMU7BUjkhLPZ6k5rTvcGBx8tikr8OZUhm5O3Ne5iqdKYHOoM4OXRHTzc93GCQTOSXbzdqzS+OjXmZ9HMAQ7ydO5Ah67sU6wqKIoD1kdL0M3Wo3YAfGFBwp9xy5r2VnEkrFswKFdjnHculwgnkPBxPVjI0iMDNDtLnBbhJttj+BW6V0Ka/U1iYYZzTiBCyPPev1+W314aKUYLejZW8HNlg7cK0GQrfeJn3V0tdAhJO03Nk2NJZbCt3LwEJaAF2SwjWJO0kLDbAz0aPK2k3gaXoUPQ1g1XpnTDswROGN4SDC2NvyZyP8z9Y66EZXpfEZ2NoGZZejxAKFh88M6hITClEp7PfnFsS/PQgWl5aLX/MOqDVm97lSXdngT18YhVY84aJSXxh2BQ3OMYS9eB7DOI8L3oU673fpoIaDynxMTtZ8dcx+UFwzbqbodhD8LWqJ5LLfH6QNXYf6LqNlReED1K9k6a5BCdH2Yd+MJJGa3ojpZD5Is3IBzHfQb657knYLmaAkAL0qczPflE9oBjWbvPUFGv5guhKB9LNUUO8X2PSmS/pIPF+BTr+2zy0Nq65Zm6J5bmcAUj88m8XUUmhWNI+iHlDZ6S/qse3dhFbflYH2b1UWZ1B2S/G2MJ7GF6Yqzj062rfA1pExOGUXRAfQqNQWSsdzk5vsRt3uivGWxHEFv+NawTsuBnSDD0UTZE59LIL2pkVI7qs+FA385DuD5iHwEil7ydfBmNSMJq6fwW2jpLf1gwpdqdY9AB6Agc1LDdeniu3omddDImUEl5GMG/gaXtyoxHG6qQ48pGFqb6kQc/b5PPJNCz0wPbU15FtaBEXdz9ZmU15RoJunIVmGDMl7XNbDI15v/
 ksX3AXsP
 b2+LhYjjvcyGgFkYD8JOLwkoUDJeT7zivFeVEfjPBfiRWvlnKDQw3by0Unyf8BNw4bFLuSVyc8nnc0aOG5/gIy1nQoTmCeRxntVeYtk30vwdxfELrmgfghZ/PJW4l71NMWuL03LhKwEJhNmFlLulGdND3v35E/KEHLSgXrZl/UTHVBc3gu8aN3JEKReeZj96wfuyKKf7HYbQ2Q2kb+ONlBTcplv3MFknyPP3NgifnS1VKDXuCg1Ll2k81Pf5m1HQBq+A0qvcTbeb+g7X6s607Lo2X7TgUDuZyokYpug6WFZ7GyEB1x2eCaaq5A1g51i2c0zEUZeb4FvRUd8WT2lFaq94j67iaZbEVzV/rd1ogrAW9HnOEvyUgA7+/2otBhmxl44XUMnrACdsBCXU=
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
 mm/khugepaged.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 344f7cec55b4..482c4b27dec0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -438,23 +438,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -533,8 +533,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
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
@@ -543,7 +549,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2896,7 +2902,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, enum scan_result *
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2969,7 +2975,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3000,7 +3006,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3050,7 +3056,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3076,7 +3082,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.52.0


