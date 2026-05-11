Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5A1CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB3B6B00DD; Mon, 11 May 2026 15:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493286B00EE; Mon, 11 May 2026 15:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382966B00F0; Mon, 11 May 2026 15:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24D816B00DD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:02:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1B3EC0BEF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:02:38 +0000 (UTC)
X-FDA: 84756060396.23.8EC99F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id EAD10180002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:02:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=al3+CY1s;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcIsBkvpgdnNq3E3JSrfLEznaBAzIQ/TOuUYoY7MXoc=;
	b=HTf5Apmx6hoerKlUMpcK+/epb9/D8K92e9PCEnS+2M4THsJh++vuk6/7ZU5dACj8HO5qhT
	G0EhqENtudW7jaAgp+fSkINL/NfZ7uGgIrNjuz0iOrqCXAb8edKsT4joHiwAi5wpKsu85E
	3yinxAb68eeFsbPoRBmelpe549YC1BE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=al3+CY1s;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526157; a=rsa-sha256;
	cv=none;
	b=6HMUogQoGoxfkfzOSq6oIdPRHbLhHwrszmc6q5slctHx/xm4F3T0nSeEeCi+D7UeuQpSC2
	Lx/MLqmIfE1UJcTwxAvk+O3wK8OoUnxXKw5FUwvBM1lYLiwdMLQvsGN8pymP2OXqvod2Ov
	NELN4RKnUx4U+agQou0+sfCfK0zG/X8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcIsBkvpgdnNq3E3JSrfLEznaBAzIQ/TOuUYoY7MXoc=;
	b=al3+CY1sAe0njgymI5oIIsE24KQba+rBTL9afmnnn6oF3ReVxTlBJvBdLGNinDwPEUBNq9
	pVbUAmv+tF3UjDFEkBpFCdbuJovEtRf+EnOhXi0BxOKJEU+2JSCA83O3Rdn9BdSwmITRrs
	qqtz6vsvAJ7ODEwN8N2LeET0feXBcVY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-sJVdtW4SOAC2rX_dzTEToA-1; Mon,
 11 May 2026 15:02:31 -0400
X-MC-Unique: sJVdtW4SOAC2rX_dzTEToA-1
X-Mimecast-MFC-AGG-ID: sJVdtW4SOAC2rX_dzTEToA_1778526145
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67FB71956066;
	Mon, 11 May 2026 19:02:25 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E4D5130001BE;
	Mon, 11 May 2026 19:02:06 +0000 (UTC)
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
Subject: [PATCH mm-unstable v17 13/14] mm/khugepaged: run khugepaged for all orders
Date: Mon, 11 May 2026 12:58:13 -0600
Message-ID: <20260511185817.686831-14-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S5aUOgoFMkU04G6He-Fi56t6iFNWYB-K-wHUT4lRjmI_1778526145
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: jxikj44tcenqearaz5fi3c39ggb89s5s
X-Rspamd-Queue-Id: EAD10180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778526156-784885
X-HE-Meta: U2FsdGVkX19PFvp1u9jLAl4177RclqYBsUjv/AmjGsQc5ZToLOc+iFqwXlF0h4GCUeC0JPITwgCyOuRI2sl8620hR9NXsfLd206DNPF8PcdJZmJ/x1nhYlE3cR2JwEyqlqLbFcDQ9/xJCEv1HyXaCPTMR7gj2uFbatjszvL97v+Mlp7khgHXdznQaAt/7zr0Um0WjoNVk7JmmZwk1Ud4WXpKRlKuyLzPt/tGoQIHStkN2xwQlS95lIKbCN0uyGDFLV5m4aZlHDOiR+jOHo6cD8L+qZ6J/y2gexNF/tjt4JcfxH8znwKc1NZCZRhgd2M+MHCoITCFRPyGVVzLzVCnhQDLsc1dhadl9mYxj3PnJSHxGqsLGhFVsGsSRdt31BdBWTDrjTldJ1HRvolqqPwQAKf0XLJS5rpg56+azXrf4w2663X89N8OT9mYMDL0mEP2IBTaUgEOzkwCapgQff0HDh+J3VoQ6DnP/UHV3R1E+++oo+uAhv4kq7YV/nbaZ0be8uF/NA6XhLivHQfHIBgXq68mZvCu4vxstei2SWn2opgqjtRB6kjk9lroCGeA/MTofSFJcHFZQzlUDz6zS5NdeyqY0t0IVVqcmRSGnA69SKlgdbcrmoLY/7BLg8CAcLnxlLx0/K9AIcF5gfNBD0fZAbZlJ61JLzlaHmElx/Ca7mdd4+lY82owozEYZ0FUNrwZ2UF8Hnb6g4OguYQ7t3Cyo7TL5FrjONTWJwRYaNxo9CeDr29AXKsOm9WdiEOIzLxf9VHkhVKq+2XG1zWMTBHW/+LdyR9r1npwyXnlV6pxnfhRkVHK/Gj9ywKUXWlJYnpbLkrDWIqJpDu7IL+PK2umxMVr8MIhL6G21eH+0E3mTTdfCKlCLWOfDRMai3bakaYQTnl7g2fQIL7fQfVsAukrOvh7OLz0yj7vNCf2NqiEwTK5eRuISdTF7PsIXz29O/WtFqs1fW85HARENrBOff6
 fr3NnXQl
 NkJHpiB1PnPTctP1F0VffEU8GtpuqMUJeB4icW3MnaONSL2Og4SPHphpCG/XxKAmmKWEMB84erK2ZeV60qBNLZrTy1TL6yqgkSm3Zgq+GfrcxQD49Gg9E0DY7oikNKflSzYfGZihUYzdPDl42AwmMOSP4psPGGaGeWCiBefXugMjP1eRucveo+kgLSWjzjUmO4ao4F2bvRa5OaIrdING6QRH6o7KzN7aLIdxkMUEhWV71lv1c6GcFy17638OVKw9T5yd+vjDvZVsaZ8+6f5DBzDZo5xiolDEsJHJ7Y020ok2z/hMnaHYTwyz3V1m07yeUh1ChOYhfTlY5GIV3/hnBdV4jbNOyNGXYqfqWMAO5nXNxfpts9SHlS7Uss6rfX0kosoKVuC/mNnva792mCgtNO5ldWXq4qjVOewfS6fTyzUaq7Lp4cem3Ru5XC9FrIihKNs2dTUrAMXdd3qg=
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
 mm/khugepaged.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f0ae02936638..5ba298d420b7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -522,23 +522,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
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
@@ -579,7 +579,13 @@ void __khugepaged_enter(struct mm_struct *mm)
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
@@ -588,10 +594,9 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
-		if (collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	    collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED) &&
+	    hugepage_enabled())
+		__khugepaged_enter(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
@@ -2945,7 +2950,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -3018,7 +3023,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3049,7 +3054,7 @@ void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3099,7 +3104,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3125,7 +3130,7 @@ int start_stop_khugepaged(void)
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


