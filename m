Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1ACCCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B0C8E0010; Thu, 11 Sep 2025 23:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5727C8E0001; Thu, 11 Sep 2025 23:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 488A48E0010; Thu, 11 Sep 2025 23:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 366CA8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:31:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF8EC14065D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:47 +0000 (UTC)
X-FDA: 83879173854.12.D84FE80
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 644B24000C
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:31:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V/9URNdI";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McPCd1ejK8Ux8giNR86/ZxqFOIr38LPX9NFmMA++CIQ=;
	b=Wyetd+76iXyTF0alawWVi2AaInRioWGrBmozk0OkGgKJ6L7zv136Nzuc1hq+0BZz7kbgwL
	eMF8bChfoBe+jhP/Ww8mCgCX9psfu7yWCmp0p/9pq7kSwcV00gVvPY7WGImNELZ6/wBfyE
	AwUSCLwg4sV/97yAF6kTw3mzvBKHuhw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="V/9URNdI";
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647906; a=rsa-sha256;
	cv=none;
	b=7M9v2f6RNohKhz+diAWrnfypN58+xd/DPKO1rCGgfJjE7SGN59DBuGv1Q+XlvZD2xibkU2
	pKgMO/udAO+I2OXRQlvLBY05a6kDKK2pQiOtsTU1yN2HBTrd0OLsi18a/2Z2r5FWlbqoQV
	sWvS+FWlrQHJFFzupG6A1QWvVuZCiSg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McPCd1ejK8Ux8giNR86/ZxqFOIr38LPX9NFmMA++CIQ=;
	b=V/9URNdI5P2qxeHTDtAZ2HQ6ek/1yJL5FCvz+4oWtKqYu8f8avjL+YWBjN9LekVeCRoUnR
	eT/MoyZGWVx0AGABeBCoYODUZGyrsoO21/KrlF1kZkaVGYQxv2aExdaEsKRY4+/9A8QCy0
	sJKXRCdnwq2CW/gbjvHr3bMYpj6PDLU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-9sEW2LWYP1CUlwfpO2-YTw-1; Thu,
 11 Sep 2025 23:31:42 -0400
X-MC-Unique: 9sEW2LWYP1CUlwfpO2-YTw-1
X-Mimecast-MFC-AGG-ID: 9sEW2LWYP1CUlwfpO2-YTw_1757647897
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6556F1945102;
	Fri, 12 Sep 2025 03:31:37 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BBED71800452;
	Fri, 12 Sep 2025 03:31:27 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
Subject: [PATCH v11 14/15] khugepaged: run khugepaged for all orders
Date: Thu, 11 Sep 2025 21:28:09 -0600
Message-ID: <20250912032810.197475-15-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 644B24000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ffqwzwyesou1t3tmecxz7csuckyfhxho
X-HE-Tag: 1757647906-873541
X-HE-Meta: U2FsdGVkX19TJ7rBJuqNA285zYwDdDH+dD52mdONxKITef3/AX/DuCG4tVAP9wJwrzrJ3Zwvp725QfiRi6Gle6LnlzhWwt/+awTu9ZLeHgPVdfFvtFVJxezUOZP27T0NokmrG7piQDcXNpSM6jzD5WoPeCM6f6gv10BB9wzX4xZzpm8ZsSplhNvNof6JN5fw/XNAMifUti0eGSlmiv2T8ChY1HYu7jvXyUvLfC+Vh7gw+b+Ukggu2cc1FiT5vnUYalzOQUU63edEyraWGI/uK703mttGDklh/tjtNpfaNoa3w6lqVtSM2rWw+ZyAqr34shSb3X+rgyhEAGxR9aKz3i61ZQfwN1m1l/SJDyGfDNK+vlr0gJZHCo5N6JTNocDPPwRDfSp4GiSZ4lDFWO4UcEe4OJ5ldDtpFe6YkiOxZiMtfU+OLSdb2x77nZ96zYPb7naenKUf7N4WLnHhiT8QMwhJDZxoFv4BJYxLl7j6oNiYWD8L03aEnf0wMSp2z1Pc9I3S+3Sa7vkSw9JCONP+DqPdB7pzuIF7I2d5pBDIf/D8xju7IQVYi2PTDNVX89/Lka4YSFDYdalQuCj4qqElpAEVIQp09kUGq8kg098CniJByuqXNDCmqf7PtTcPSB78pyyMo3qwSoNMey07huUbj/APFGXylpGpG9BVsDP408CyAkEROviFHmTs5KW+WIGh7dGn2ETySIvwzpXAi+bl+YkhlRU5AtJuYlKmy+BuIx7PDPVrfagPTq7gdX2yzBw8lalvNf82pzIp9HayNSemWZSVjk7x6YGHtCHdqmwf8fdIIbg79XjJ97jFHpExIPVYBgHIHWJVLHie1fpYnFUdoF+ZL5MEuAxci5zjlwssg4ZqO3kKDlPUI15xTmVyNdnY7iS02+SuKwYQ6IezeBxNN17G5hSMajddngkK+DTCsBhDwRF6wx6T4KsG8hplKzbYWrrQa3jRaGOXHQgAnvn
 YrCN63jl
 KXriGAQTt66pjW45NM+I36oQevKTyM6fks9rUJxNLXLxDdeHV4uuBWIigAGxjDAjPTHTX/fP6bSPRQiYAghhPmqVWhU1jXErFyI3GkPNc/jNckTsbqiWNXZGI2G4jHhqUouXJ
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
index ead07ccac351..1c7f3224234e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -424,23 +424,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -504,7 +504,8 @@ static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 			vm_flags_t vm_flags, bool is_khugepaged)
 {
 	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+	unsigned long orders = is_khugepaged && vma_is_anonymous(vma) ?
+				THP_ORDERS_ALL_ANON : BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
@@ -513,7 +514,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, vm_flags, true))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2776,7 +2777,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2849,7 +2850,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2880,7 +2881,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2930,7 +2931,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2956,7 +2957,7 @@ int start_stop_khugepaged(void)
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


