Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B381D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861976B00AD; Mon,  1 Dec 2025 12:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812396B00B0; Mon,  1 Dec 2025 12:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727ED6B00B1; Mon,  1 Dec 2025 12:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 611376B00AD
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:50:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20C64C0359
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:50:04 +0000 (UTC)
X-FDA: 84171640728.09.76E53E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61666A0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:50:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LUyhE+tb;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KyY3F2h5viYktXEyQbxxB8FTjWseEzGu3VrOFxnIWI=;
	b=6osj68GqcKmMP1hLLh3f0DnmoLVvtphXwYgOOMZVcnBoHz5PKbKRcxKqlUnjbz+q9Rf2p+
	ZW7YSgXSRHjBeIl4uj/SDBLgDHqqoGOIwqVq/Rwxq4g2l2Pd8ALijK9rMftxLAjUAff5mf
	Avu6j+rWibyqXNL3lyJoNjYIP53RR6Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LUyhE+tb;
	spf=pass (imf25.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611402; a=rsa-sha256;
	cv=none;
	b=vfoQ8PqJlTmR58j0d0W3alxAoqDe63Ko0BSMACTTtqAVodMmMxt0QqMVB1DwAmdDYLxMWl
	LfsXGx6E5w2oHMOJm8tK00bJfcBeEPLNgUrmnfa1Qovt4LVeTJQ73IQyTDWra80z5MNE9L
	M3MhI5CqSvAlyPwyVM7STsH/MNMavs4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6KyY3F2h5viYktXEyQbxxB8FTjWseEzGu3VrOFxnIWI=;
	b=LUyhE+tbCAqHZWxjOTRSXtejDuc78XDTv7VsGnyDVYsycrltmy9XmSzcbTAReythy1SlZJ
	Jm2B/I8XmRCZw88ZXwcSUTuKcPvBmb2OBs4+N0nxnncWabG8BxE2Qdx3eM6bQW3DOxqILG
	/VpqMqkg43KHfCa2f+HNBppPTdIAodM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-j1lPLz7iPma3kaMrpWOQKg-1; Mon,
 01 Dec 2025 12:50:00 -0500
X-MC-Unique: j1lPLz7iPma3kaMrpWOQKg-1
X-Mimecast-MFC-AGG-ID: j1lPLz7iPma3kaMrpWOQKg_1764611395
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2216719560B1;
	Mon,  1 Dec 2025 17:49:55 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B3E11800361;
	Mon,  1 Dec 2025 17:49:45 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 15/16] khugepaged: run khugepaged for all orders
Date: Mon,  1 Dec 2025 10:46:26 -0700
Message-ID: <20251201174627.23295-16-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 61666A0010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hqnto7ynt9ygi89t9k7hq94su1j59qb6
X-HE-Tag: 1764611402-561655
X-HE-Meta: U2FsdGVkX19r9p0tjlRj9y82V2TPLJcj++nSSXyUprFIXkFkIt1ksQIqCwSWQruW2rQBfNkScFQJZFFa6lc1CyXeUx7LTbl/jKNsWgVk8sTaXFyN/F89fk0QPWqNwa2kmSYukIyggMHfAGjspJJeSVBDrNMJUJFI61IAhR1Mjn+boOXrXRXn5SjEe9R6puPrG03GG54ePH5ZdULq0oJrPGf+YUJvRJMJE8rsk1fYjyBdG6qnBSMGdvyzWf1WNcSWZU4k7F/6Rq+d3nhi1wJACey3cn45pWRcGmTrfaaL67TH1f+sHIBzi5nhghCJqDE8+IK2WSp7jnpj7KhodF77NuK71p1oJstRkzgQAB/zGFRvmTXsClR/vq+NwVFXQOzYB8BOZnmhyALYeztPkpCHz5kD2G0UTmSh0/5Xs4pj/iIyHR0yA6VpajAbR2FMydwjhD1HjKNe2mMi75Xs/KNzqPZrTkecWcAHHkoBsWCHVnQH9qB2mKhtIu03TbA3jccMgj0UQ6fK759cYYuFdMzOR4Gpw/NRrsRVdMmrK8kTVtceJyxlmvx6o8sc5wU/5pHs0SqT9OvmqcNwKsXllDpXY3wXL/iXiTGuML4FxpZ+lXQ2i+pENWKk+e/LwOAFJrW9n/VtFJZA/lqAIuzSq7NZs1vlnD+9RMufOgSzZL3cZRwNv8kGHcZbXFtU9jpJ42LehQaeyR2cpjQMAFhZVrJQd3F162AELjEbPXNAHiGZgxuPRZeDPOBVT4Pe6/6KVluyC2IdK0sbNy8gZ8H/wdQR8FQJ9dvVvUruiwGykFTHYKus+VueVkud2CppdVu0IUAntpf7o7MC9V8PMkCe1TXwldYsQipGbXb1qOmcLECcVVIJqDN6x7EHBySa1NcL4HCNcpHLMZmk1h78Pt4nnBV5YVtqXadILvID8ot39agb8WE5m3mQ6k/ARc59uiDuZT9Cky6j+XBulJH4OlEj2RT
 Dd5rQPaI
 nFuJUnCV7gjm/TZudbTntCmuASsrzyloo2CSbMktvUPdh+IpGcq6+nr7KdfxEwif5EWLQuPTzNht4NHjjbmrrzcbQzap77Bibndg19PJAOybnxq3DKiieruwjlYmlEYnwF1qYdBtohmkeoD/oe6SrEMBo33SsIyP/XXAQdRYAbaOZu1Y6se3mPocEdEyeopx3qliDYDRMEZL0C18nBWFd03QtqLJ+vffbqnkg1s5w40rVrOr9BohJFs0Dl0bG+N5xdDc1dDutSbOWtrHrhHOE0//LYn4MrPrY5kn0rylmMYxLPesz4gmA71YU1PngJHYhLrMHYi3Urhd0qsiO934tNYUesKkInVVLI1b5/OXH2av6bqgqLDYmZ1+TCzE6+fuTllo9DQ6sZL+NEdc=
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
index daf39aab7e86..ae524220304a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -441,23 +441,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -536,8 +536,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
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
@@ -546,7 +552,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2890,7 +2896,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2963,7 +2969,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2994,7 +3000,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3044,7 +3050,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3070,7 +3076,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.51.1


