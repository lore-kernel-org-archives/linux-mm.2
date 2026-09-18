Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9AB7C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FB66B00A1; Thu, 17 Sep 2026 21:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902156B00A2; Thu, 17 Sep 2026 21:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC956B00A3; Thu, 17 Sep 2026 21:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCB66B00A1
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8AFA1A0529
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:40 +0000 (UTC)
X-FDA: 85225193760.05.43E0A76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id AED714000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZxhwegC4;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695998;
	b=T5glA7C9aNBbsoUuMoCuwge2IjFvrOdxfAKq7f7DLWXwlRUMAb+2sEm6z1xf5lDy2uOUPX
	rMOuFi2rYlZS3nNsniUWzpz96OD6i5/zu2kDxp/miZdgcca8R4k4KlsKKBQ1urcl+UAaEW
	8Rq2xNQ8MVLTPQyrd8T9IWZue+GyjJI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZxhwegC4;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaZuFD7TaK5q+SRf/M6wNF+Sb+xKBaTWhSdcsCrRx7E=;
	b=Z6EVTNMy8XvI0+3Kr0IWVVEzcbUhtdM9VXXG4wf10Q1Wb+uBIJQBWox8/802pS8drd2imP
	WN2jnjmKw9XLHDsfERjsuvo30Ysyo6u43QJ7O/VkY2PJDRc1/R5wH60FJMz/bs471r/IQt
	0kzoebZXH3jqkagz/TqbuJVvwHXVBa0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaZuFD7TaK5q+SRf/M6wNF+Sb+xKBaTWhSdcsCrRx7E=;
	b=ZxhwegC4128wTAtP0KLbL7Kc6RQRrP7HLGIOh0dLmjxkQfjg2hZVbYeiQO7r1RqB5dqSwt
	uujiOiZx6c4K0ISbcVKQFIckcUD6soLomS5gnrrjN/EBBnET5irK2NX8tjmrOy3rGoLVqj
	n+62S0epqRZSu1u0WI5pSGo1E/K2LCA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-ExK_AzhUNJavZg2LaYM1mA-1; Thu,
 17 Sep 2026 21:46:33 -0400
X-MC-Unique: ExK_AzhUNJavZg2LaYM1mA-1
X-Mimecast-MFC-AGG-ID: ExK_AzhUNJavZg2LaYM1mA_1789695990
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EBD31805A2B;
	Fri, 18 Sep 2026 01:46:30 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3CF6180034C;
	Fri, 18 Sep 2026 01:46:25 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v8 06/14] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Thu, 17 Sep 2026 21:45:27 -0400
Message-ID: <e7edf7e42f88d361c177e1baa7e2138c193f0805.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: BPOwdbcY4O_afKAhuGQN5tpXMorO103MwUhE8xV0q7Q_1789695990
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AED714000A
X-Stat-Signature: pwexqpptwwtomskgwwasa7agfnbowq4j
X-HE-Tag: 1789695998-997914
X-HE-Meta: U2FsdGVkX19zmqcnT0lOj/SLNqy5/cxm+hghwI5maY7qDC31b5dYKS0y9lIptO5nXHOV3srCkRQp3fZYTW0EJPCBpivgtFAgUQ5uTZ4FqmJOE/UQYT6lQdS1s89AUZXuRioSSehy+iOTbgpSrL0Bd0NtQ+Tqm+32RxEJ/Eqzh9pZEdvQ3+6wtiKKfBMnB4bggIAmw2szDWWxN+ORWBr70WspvQ0tikq1upxuqD62fmz8x0rpdkp+tJ5rEnA6QwW2PnYrq24Hqv2wP5v/Duht/NI7CBuLoTwERi4thAKEKv9GuvKpWhLKG9jjsRGZDUsFSQK5caVQEegAlmQFfCpUE3jwIoBAKTMNILNPeL+CpYGBF1w3N5mUW6AznZoc9RzpUuarWzdQKM1HPR46zauAnEiEW+SCr8McpWCUNUqtTqgFag5QBW27pWPlHM+qSTqpbCV6nANkwGCZwbKeJGPMueAN7Z3sIgg7DxSBAm/mRWVqLW6hsiR7TNgXrUKQysW5WZrurB0pZ3pAKDUQ0CEz1oiChK+P8dRmKX+F64T4zh3NeGO1gPKyXR+75UIFPasvQKDEx8Phh90q3uaXMLJAs8EpGPJT+GvOJBmDEvx6oVlGAbDKGnR6wE4W6+syjRSITapLmzq2lS6K2mLT8F+Ko+QT7oFpc53RXazibYUepeTCAuuuratox+V/ZuwriTdyBGp+c5kVCqwSFrJQ6bGf9BJ2XzfghA8XTwXXgNwyDFKNYjmaeO7nxYbPcQ8/hMRhPva4N52cIG/5KiILDJCIO3AJm7gDAwNMFPhfYbvFRntNL0BlFzz0k3KmlnXF47NWwEObCVHD7+kP0wypxf/BEcvxscAPsma5SMi3c1OimJLk0SUQO8volDLGUIinW2kCVMCl5+hs0HsoNnTJhE170gxdr+HhHH3x4BUqXSgKvWMm7QbCO8WB2EqkiQM2cqx0w66rH0I6qO+9FevxI7W
 z1JjgG+f
 syHmN855um8QH4sG8wM7SLGSLX9G366AErWfrJ5UEuC++jlCLdb67y8ccfkue3CHrQyRPgt17ywSxZVCjte7+kZBou8fbfTSdUmGzbhFvaPS/TolPclzecU4F2FUzHSoFZ2Iu4OSQXXMo0z911burrWwjCNiSIHwSds4n6tv4UOT4u9qknG8NgdUhW4V/Ydz5EFn8/wjs47VNskrVyApYbMjgHZCb/gKVB05kh4cJCfmFxqf5ElmabE8sXsqtQhTbdcbQUYOigMZt0eB0pNPQy6u7Y4DzbvYZQadDq7Jj7X/t9zStufoIvWk330g09YRmNbzhz2hw3LnKrhLf6KTCbe6Jc1lyqsghLtQC1UXWJvkgizwpBh9hBt6EJb6pLUkQOCCUlOnjOgHIQ2/+jeZQkZ7a8NnZ2Xd/ZoEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
instead.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/debug_vm_pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 2875fd22d7bb..25038b74c7bc 100644
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
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
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
 	    !IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES))
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
2.55.0


