Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0234B10F9968
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600566B0095; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0C16B0099; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6DB6B009B; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39C4D6B0095
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:25:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 124F3E0C8B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:25:08 +0000 (UTC)
X-FDA: 84636517896.02.D9D7D93
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E4B418000D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:25:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJdzU6PZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679906; a=rsa-sha256;
	cv=none;
	b=Nh1/uljTYyVgLulbNngBYi1cHnVTgUKcNogJpb1qkGI+DRj5zCtvfLNc96BZE1rydXsUgF
	NBU3lEn+zT1rWFqde8yMFVECBm7EpqmwYhrsKyHNXLfGnmfL9SURJqTR/XrWLiqrak5NFV
	2IDAUQsGwdptSo+Ro5fWRjG4fOdcdCI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJdzU6PZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ocXpUd1XebeFjlQJT4jQORXT8cqN1+0QrAJ22mdd8PQ=;
	b=s8/KKUbFsALCcBLZyTonmJm3fGqOL5Myq8eRsYYT4SOfMVGnPEeiv8PeKEafjr8CsLkheg
	EN9gyCL3SCWE8P/De6enxv3hdh145YMYwenmTUKkF2/yK2yN4UCNxYyGeaX3M/Q+oy2NoH
	S9Kuvz4XgeSUHc/3QMo28lDrrMTnY40=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ocXpUd1XebeFjlQJT4jQORXT8cqN1+0QrAJ22mdd8PQ=;
	b=OJdzU6PZC91hL66pulrs9dsUAOW1YnCfh2BwYc+rx6b6BtJixYpL3P1ckLwdkTrixx98uc
	SOpaPSkJUkOZ5VOIbg+kA9bo/Kerajn+JNUvNuih4vCMTOT3aZ7COa9N1U0wmPu1FPAoaC
	knDzQfyLhZBZIZLtF6dR9JIfrM/arsU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-W-6NM3x0Paa9CMaDurZEow-1; Wed,
 08 Apr 2026 16:23:25 -0400
X-MC-Unique: W-6NM3x0Paa9CMaDurZEow-1
X-Mimecast-MFC-AGG-ID: W-6NM3x0Paa9CMaDurZEow_1775679802
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C91E21800617;
	Wed,  8 Apr 2026 20:23:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ADDBA1800671;
	Wed,  8 Apr 2026 20:23:21 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 05/10] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Wed,  8 Apr 2026 16:23:00 -0400
Message-ID: <18d82575497d06a4d18605ae33f9c22e08a3209e.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: v4fNoSvCjfOw9QOMwRvoUIAv3cefu_SrrY4y9w3SldI_1775679802
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2E4B418000D
X-Stat-Signature: sh7ynoozboj1bji76gn1xebh7sxcmdfe
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775679906-98463
X-HE-Meta: U2FsdGVkX19T2KQ6zQA5TuyD3zH7bE3nbt5S36qNjGJo2Un0cUUKaZNQ5ddxvp4fRzzC8V7GNf4r/TErFo3omjcBXERiXlJ5KxyTJs7wpTgZzuLxhb4AW1eFo1/1USdeMd/tBWqHWRINRAojt3HvjZq6iyIv/9baOJcO4vt53aZhFvUVdhkq3lvpraX4FJy9vcDIpRYgffcB84qD/51i8FRkc4DsBUyV50nJozON24YdtOwJAPZDuQR/PJgt9fnZSYeUjvOApMWWK5NGn8Mxr58tkK2LinbJfpY8rWbkvsQfgfQgE2JQf64Kdqi4xsSKrhtLfd3CKkVguAedj0jFd8ILmGUevL8/HOaGzeuLTSKytvRFPqAwgofe642UpTRnLVoEmb1AmA5EibnAj4RKWIKCe4ND90vX5NrNuEhIkZMLiN4VdES6UNPpe8Q7EnQYYSHFPmatnfw6Nm8FLvbTbHq/frRpF/rvnnpuEULtEDFq3ggyk+IN1RGa45m7nDYtPiFY92ysidIZMlGQKuoVvN+8uS2EgBFnrRLYoVaIlfJgfdhbt/DKpIzF0amCl4e2VnCjhZ51P6HPf5CPdwU3IRd+kONnukfKDq4A6W0pKUgXbfMRIWGLB21vaWDE8WUQBHfwOdQUwxsxIa2Yc6q02VQ9pZ/XZLTG+5dku2B13qPjxAvhf8MFzFPynaGlkNd/Y5SMWjn7XNGuDf9dLlaDvAYg279A1VdJbQxBOeQx91ZQMk5uAQsFukvChOjXpUuitcWR5nepmTMS25vnd1rTWHwEd6omz4RNOEr2sNMDE+9WPDKQ49PtzMAcqRtadwOxYIVBV3YkoTw9/Fw2M1yCyTRT+T2nYMXtgO19PvWQbMeFuh3l+vthetgVS+fu0pYPdn+VYerk3DeMcFI8BhI9WObt4P61YyNsFIZRvzVi6CwwoIvxBpxGJOTix9d3DVVwN+TFBv57SLxrGbZzDQP
 JxiVxjQ7
 L58AMw/toaBgKi+/F5O8kQKvS4ltDK1Nv2vKOq5Aa676LyQIOgjRmeC+rBLLz6nGUD9TPmJDE8oWHgDUw/qgUf9AUVMla8iL8eIlle+bKIUlQ1Y1OU6pU2ZNO8oJoYeFdH3cfUtNAt/DCHb7w48/6pnX5rpoBAkJzkJeXhryXSCI4uEFQZn3C5Bg+FMt2WaCX4lBSX+qQXOVbxn6dhpTCnjVj8HG4/m2/O5i3Z3WxCAtAs4JcI5JG2eRq7RlKjrC5Q2/6399a5Rf2jswcPCY1/MXEU/ppP7ggUIvhSdaYU8mh9tffcrdv9zxBhSN4YhKkLvqN+mQvRxSB+BK39TSSWP4nawerptVHJCQZZnkwloSdthiOdypSzJrRwqu851tqKoK/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/debug_vm_pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 83cf07269f13..b3e30baaeceb 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -177,7 +177,7 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 	unsigned long val = idx, *ptr = &val;
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD basic (%pGv)\n", ptr);
@@ -222,7 +222,7 @@ static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 	pmd_t pmd;
 	unsigned long vaddr = args->vaddr;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	page = (args->pmd_pfn != ULONG_MAX) ? pfn_to_page(args->pmd_pfn) : NULL;
@@ -283,7 +283,7 @@ static void __init pmd_leaf_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD leaf\n");
@@ -688,7 +688,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD protnone\n");
@@ -737,7 +737,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 	if (!pgtable_supports_soft_dirty())
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD soft dirty\n");
@@ -754,7 +754,7 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
@@ -825,7 +825,7 @@ static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 	swp_entry_t arch_entry;
 	pmd_t pmd1, pmd2;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD swap\n");
@@ -906,7 +906,7 @@ static void __init pmd_thp_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD based THP\n");
@@ -997,7 +997,7 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage() &&
+	    pgtable_has_pmd_leaves() &&
 	    args->pmd_pfn != ULONG_MAX) {
 		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER);
 		args->pmd_pfn = ULONG_MAX;
@@ -1249,7 +1249,7 @@ static int __init init_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage()) {
+	    pgtable_has_pmd_leaves()) {
 		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PMD_ORDER);
 		if (page) {
 			args->pmd_pfn = page_to_pfn(page);
-- 
2.53.0


