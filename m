Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9174CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A81C8E0049; Tue, 19 Aug 2025 09:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FC88E0007; Tue, 19 Aug 2025 09:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F6B8E0049; Tue, 19 Aug 2025 09:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 408068E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:46:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0436A590AE
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:46:12 +0000 (UTC)
X-FDA: 83793631026.28.1497CD5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43343180014
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:46:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hwvimguo;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAoZXSzkkV5CAmqb9aRsF+eQRwNUz1x/zfG2eNwgvP0=;
	b=7Sd03ZRE5WzTEeBvvWbaqOmffBBCWTrRAzNjsFX9s/mXKiCW9VD4gaD2dkyEaVWtpIFRWd
	PGy9wPU05kUttqAADIENw0X4Lpx2u4JQePUqGFyGIDKlbbyFDRDqKcwD3DCjZu1YH1l+Aq
	a6MLBFnS7/nQ13dQUXAd/5oWY//SW7g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hwvimguo;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611171; a=rsa-sha256;
	cv=none;
	b=ETniiXZ/BVYxSXxTG6Kb7KUfGv6jBtywz5fd6xPPFpzE9QE1r2keckrNXsSjeh6FCvgZdT
	JWQTkGZL8XKr7Z8JiDN68jLbDUK+upEWm6elx6pjmszv9yqXz8ywT8vBQCAmFGOYNkeTw1
	VbRuQVQN1J48Dw/8WVal97DLcznp1fM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755611170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wAoZXSzkkV5CAmqb9aRsF+eQRwNUz1x/zfG2eNwgvP0=;
	b=hwvimguo4CvMSpc5dfMCPgXlTUzAaoc7YhUVyLnyfbIIHoOVd6FuLN+Axsg2DD7n3gMU3j
	nRavT2kO+7d+yZscKH7LnmZGjhXSXlud6N7U24kQgDyNhp00pWXNWGYPeD76ekH+VWp3Ky
	JYHYbNNuHdM5BzRN0I1fBJkk7BwE5xk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-U_3tR3dbMQ2wvlq4rTnUFA-1; Tue,
 19 Aug 2025 09:46:07 -0400
X-MC-Unique: U_3tR3dbMQ2wvlq4rTnUFA-1
X-Mimecast-MFC-AGG-ID: U_3tR3dbMQ2wvlq4rTnUFA_1755611163
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 443C619541B8;
	Tue, 19 Aug 2025 13:46:03 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.137])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFBB019560AB;
	Tue, 19 Aug 2025 13:45:45 +0000 (UTC)
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
	kirill.shutemov@linux.intel.com,
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
	hughd@google.com
Subject: [PATCH v10 10/13] khugepaged: kick khugepaged for enabling none-PMD-sized mTHPs
Date: Tue, 19 Aug 2025 07:42:02 -0600
Message-ID: <20250819134205.622806-11-npache@redhat.com>
In-Reply-To: <20250819134205.622806-1-npache@redhat.com>
References: <20250819134205.622806-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 43343180014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gw9z9fwj36dphr56jhf5eom5oyb3ohxr
X-HE-Tag: 1755611171-807964
X-HE-Meta: U2FsdGVkX18mhkv0OHYEiuplh2UpOJ0/wbmnGEgjhgOFCOVEmYMrbj6tDUQO8cLyKLC/FkWIfdbbBXkaMRPwBNEQYlNSFfqKIuj+8I+TkR1HVtKhxCWa5nbn3qQTcqZKtwVjeXRVq3sOqq/2tTbJgh3pDocPGlfXY3dpJT01W9zThmMmvdB3L5KWZ9ORfEIA6UO9pJHZ0bTpNbKlVL27FOlj31OZkfZhslmiyv/WFuFXTZjWncsSUuVjV4mPZlO79n2K935zlDxCfjTOwU8XKgMVkGwuDPhevUrteLD9Dfys4Z69TH7/+UxqnoQ9aOO/ODjai4MbOR9dayMh0HvvYhfiqWPF46FdEuC8JIxJHXfawdPwO2TClu8t0dXq0cbEADoLh0Qd2PbhC8jq7BO4570BUn2OC3+EfpYqvummw9iAX/qEEzLxdlCZHPWGQnWg82pLGYkG75Z8FQUFSFvRn/L1ApIbhXXISga2oZF7AYkIucHokPyosTzLQgwjWeORWi4E2fvoZ0OKt+aVvzlsof/KAla7H4R88pp6HhrlBOFm/dB2fF1rfTdhursr8UZh12SbhnojGE8siN1m9qqnoGT0z/CU5/ew3OZWFC9hxob+GS8zwegbR2zrSCqiuqJ3Jrj1WtJhwQPH2e2ABQhbgsJX+xhvisRsArTsRtDxopxgLPaFmQO0DkHhJjry/mMbPnx11FEBvbfvtxTBfOl+0Zkx3h2PK0RuQzkSWR78/jkpmxsVfAMe6gOPd+1TjdNGCl2V3Mw2N8aQRQZUqoD0ClBm/IgFD4tH3FF2i+HZEpGSVLxipm4qqQ7iG6NIg4niR/xiYxresbK4MJDaFDDBeGFWuiFg0rq56lMktmwuJA5cE/1RM+Umx57dXazcZuI7cgY3QcZAbskbF6PmlWF2TKq+3kLAgbeBB/T7NnerTPRJSvdUoJcJxrziNpprbqeiev795c+HXCJ5gcaw/Ln
 VnaXK4TE
 1QYLJkUUwqoLnGBl2FxOvx4dlxt/X5k7vDRu5Ju7TcqJOs/yDlY2orlO3Wq8Hhzm6LSXcLw738QWVa7qUdW+JXBU36XKh5fh4UI8VnZMqhW9d0e1kFfS9Kms1Ahx16d+KvT74PkX+Bsm3u5SvFECdWz7ZGqUVgojEGwKuRHmbOtHJYU9te5gKCNFjV1VdNIkd0btc2Jai+9BlrsLrku1xIQHAPZY58DK+eY8IamLrSednJhCMPa7uQ1vyF2nXYkYUo9GWpaoV93n6kynGPpwk28l0XrSGcSdidLAHzJe9Y3J3I7qgRxwSlzWMrZTxnlKhtryeOwRxoKNlG4qU5EKX0EU3X+cJU6iCV2qVD4cu1nrYfgl6EPdfUkUWZp6syrPvrn03WRkDL3OqSuiZfpiCQr802AdenTM3wSd7js77a+quFJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baolin Wang <baolin.wang@linux.alibaba.com>

When only non-PMD-sized mTHP is enabled (such as only 64K mTHP enabled),
we should also allow kicking khugepaged to attempt scanning and collapsing
64K mTHP. Modify hugepage_pmd_enabled() to support mTHP collapse, and
while we are at it, rename it to make the function name more clear.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2cadd07341de..81d2ffd56ab9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -430,7 +430,7 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-static bool hugepage_pmd_enabled(void)
+static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
@@ -442,11 +442,11 @@ static bool hugepage_pmd_enabled(void)
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
@@ -490,7 +490,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		unsigned long orders = vma_is_anonymous(vma) ?
 					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
 
@@ -2762,7 +2762,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -2835,7 +2835,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -2866,7 +2866,7 @@ static void set_recommended_min_free_kbytes(void)
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2916,7 +2916,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2942,7 +2942,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
-- 
2.50.1


