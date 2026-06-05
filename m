Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA4ACD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EA76B00AE; Fri,  5 Jun 2026 12:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF096B00B0; Fri,  5 Jun 2026 12:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0206B00B1; Fri,  5 Jun 2026 12:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67696B00AE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:18:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EF008C212
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:18:08 +0000 (UTC)
X-FDA: 84846365856.13.EF2AF80
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7362440010
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:18:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NwJ1uJM8;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKoUumy80dG3dvE69RmnQuAtKZgih6bAKNwqy+L8dfs=;
	b=GGEV1l3qf2vPeXWwLMTlKCnYduQ3M2LbgiMJxvZkiZ4FPvw047T2ZbKRHtVgpHVFvtHxHz
	Vrzu2tmp/a6+O4BALmBZnZlOShi1lzeU13UZAM1qIdalOeSEUzx8bOEJGVp1O3o76jZ6OR
	PbGkBZc8Dn2kZAOdeQjpsbfml1BtXm0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NwJ1uJM8;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676286;
	b=qubIiU3B1VXZEQ1+jR04kKVxsFZPzBe4sbYTReURaTXjUPnVAsF76KRrunZ+J9w4q313hq
	UL/ZQ7xhzbE0f7HLnWjjbG8tbIm8/vw9DXIbt+e2ua8Nw598Rqr/Q7yiOmoelaXP5fMymP
	P8vrBAzld8CyDbR6J/nY8gI4TTZG0z4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780676285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lKoUumy80dG3dvE69RmnQuAtKZgih6bAKNwqy+L8dfs=;
	b=NwJ1uJM8LIID760UjWX+V3eAxWYEcZQtc7vRpqK86tNhY5zy4sH5fm2OmRv3a4lfgLWM8P
	T8hZ24FcAZQTKNN+63uNhknRHLIcvIgAIfOG31mwEAvMAvyG6rLQR1XNihWF8RG9aMI03I
	fJPn4XWoZpKILpKxOu1O8qT1ZaQ/+zo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-Q9ScVVauPBiNqlw2Hv-Anw-1; Fri,
 05 Jun 2026 12:18:03 -0400
X-MC-Unique: Q9ScVVauPBiNqlw2Hv-Anw-1
X-Mimecast-MFC-AGG-ID: Q9ScVVauPBiNqlw2Hv-Anw_1780676271
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4022E195C260;
	Fri,  5 Jun 2026 16:17:50 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.9])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 94CF1180049F;
	Fri,  5 Jun 2026 16:17:30 +0000 (UTC)
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
Subject: [PATCH mm-unstable v19 13/14] mm/khugepaged: run khugepaged for all orders
Date: Fri,  5 Jun 2026 10:14:20 -0600
Message-ID: <20260605161422.213817-14-npache@redhat.com>
In-Reply-To: <20260605161422.213817-1-npache@redhat.com>
References: <20260605161422.213817-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UGvTFzMkagRjXG1cqQOhlX4o__GB94pKk19C82ZJ6lY_1780676271
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7362440010
X-Stat-Signature: ztppem68ugcpdyuat5r4boi1nnk96jda
X-Rspam-User: 
X-HE-Tag: 1780676286-201918
X-HE-Meta: U2FsdGVkX1+gC9pL2BfNd7KKM5i6WFGkAF/p8CidU0PgxdW2eq7EOCdB3Fvz5qx5TVyYJZVcmfyYXkWe5Q/lilJL9f1duUSFcpiG2EbUrDPyPt7rPaM7mxns8Km867/98bU4GlfRIV2ix24nGOy8uBsOu4Yu0bYbm3v22E7sGlHpyeHZ5MNe5jPDHX98JOmwXlweJ2CKOzqBEpt71RxbsiB7YJuqip/9D+Xcfra3lKeMomgRwLS+x03scqgScxUBUrnUuEXnx2nIt9Ox4oe1xEV4DPJq6YsQDv7XAwd1rHULIpVk1jm0VPTj2IXkyU+Q+Fa5C+l/OcEb66GIvU37ZvV9j9WatxINDrgSslJh8iSH2mf5HSrN1B4+AQEDmkdyf53i+Iy7jdGAkMaiqygYhy7Z6DfzKmBMj9mMicPZn9xuiLEJ6h3K6MDiDBzaPbQ32S9VrO6CuAsIh7P7S+mAEpUHgAA7uGSWw9dn64pJV8827Iov3LYz/1cX77C6cxh6c4hStHolFAPbAgjhvNKNHbZQn5NQXIi5ECPBGfjpXFqLOkSxnxUTkH4W1f12kvQ2szEhQOp5TkRcWPkRmN4gyBaJE80g/C7LnaSDUwFQiDsLlI6sGg1H11oX7JOhOE2zcYOlY6veZ18CDwOHO/UiZ+CD7GO5SiKregwmNK/8V+AMd1v8Obfk+St7lEm1iJvfQKjcRdNLU9ElXVepa7laIFaMDRmUOC1Hdl8zs40jlZMR07oXuHfGUKxaTjPn3DwpwhE1n7rmDq3bIiMNDvTze3//pgBDc3obpYnF/2NshzOF3ltuFjz+24CsnILbal89wqkhkSMb7V3u7HE+GxlcFejqcf4ETMjF71x10RXKJt/UyrPel8JUcY9jeKzq70TEtEhYRRRqJN0WYdHJi/lh7S9NO1D7rTcfi+XaUVVa2w9Sakq6ZW+52YHkDnn/LT80TLUKSNEuHqEX1uaKsEC
 lRGdU38n
 fiNyElsybhc3iEyMs2kP6GKkcryCfg8JzgLdiH6Hbe62ixz8dguTTtSiOgax2i4EZc/lZP1yWNZ3dKZPVdPygecaFuLVtiCBTMqR0TDejZdAXaAweX2F/a/lz0ACbZFIkAbLNhsGUya4oMJzS4tJGRc0dxByIJbcgqJ4ErDd6kVL68qTMh/ilP9/phjwRjBeJvrPElosFM8y1PRcAD5h9zCc5efIVEk5HGwuFPTrc51fwc+Jkk6QhUio/JWmlhgO9Q7qAOgRz6XRmht54MBIgc+YBqiLu8KyYyRts7BOqDtC/BUa+s7nJCuXKMo/TYqMjZxxIdVFqUEAD6ARvZk4GGkvGJagHR8UUwD30coLXxRhZE8gCOC3vTyjYSOtaeo7YZvO2t9xNkw2UkQuz1xtYD1+dPSwhvupjXB2pa7PC0hW99DOj4sjRal28tMNqPO66x1XVxbW1vnrV5MK4k5dIEpZqLw==
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

We must also update collapse_possible_orders() to check all orders if
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
index 7de92b28dd30..996e014a03d3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -503,23 +503,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -566,7 +566,13 @@ void __khugepaged_enter(struct mm_struct *mm)
 static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
-	const unsigned long orders = BIT(HPAGE_PMD_ORDER);
+	unsigned long orders;
+
+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
+		orders = THP_ORDERS_ALL_ANON;
+	else
+		orders = BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
@@ -580,11 +586,9 @@ static bool collapse_possible(struct vm_area_struct *vma,
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
-	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
-		if (collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) && hugepage_enabled()
+	    && collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
+		__khugepaged_enter(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
@@ -2936,7 +2940,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -3009,7 +3013,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3040,7 +3044,7 @@ void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3090,7 +3094,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3116,7 +3120,7 @@ int start_stop_khugepaged(void)
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


