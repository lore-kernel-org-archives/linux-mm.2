Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F950C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB996B0095; Thu, 23 Jul 2026 21:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2C66B0096; Thu, 23 Jul 2026 21:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843D16B0099; Thu, 23 Jul 2026 21:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBAF6B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:35:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B336A160116
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:14 +0000 (UTC)
X-FDA: 85021952148.05.9C45FD7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id CAEC41C000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:35:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/2pNWvk";
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784856912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaZuFD7TaK5q+SRf/M6wNF+Sb+xKBaTWhSdcsCrRx7E=;
	b=ciD7VIe5h7IoH1KevnYyAlkRGooSHIeCxeERVXASb4ZmPB2mZ4ekz9vyILCPvYOflDY4sa
	pqyWVX2v3PUbzkX8jP6MY5SoJudUVkQYiJzpRiFLVbChLKjsYd3G20F0N9bFQeGMby5wW1
	5b+r8Zr/jxJ/WjhfNX12gMEcFgCQyD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784856912;
	b=VYPA+zFVTSz5sYNsqIS9FJlXDhkaBpohNDjqwmg7hL/t+pcm24n4WEBVyWE8b8dufN9512
	ywhk4arpA/XamCi2UfanMujccMWN3D/c6nCC5eoAXvBLfi+LyvrVbCZGhryfq1ewCCeNc3
	Pc/LrLQhWEwsgcV51PFZ//sd8dL6oYk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N/2pNWvk";
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784856912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaZuFD7TaK5q+SRf/M6wNF+Sb+xKBaTWhSdcsCrRx7E=;
	b=N/2pNWvk1P80DbnJSl66pzjOR4tclsDDlEUT9LmOgA0L6zgQw/7HwPolDSIO/5ZpWMkMmk
	vd8ra/MNU9cVDVcCVTd7GX/c2G7n0GJL4w7/OZNn/N0eBtFfgKM47ZjBdkl5TjcGsqZGhs
	aY3EM7j2dDgCCERcx89AoIiNrz7Gk1s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-qqWkX9JjOvmV6bXqg4KyxA-1; Thu,
 23 Jul 2026 21:35:06 -0400
X-MC-Unique: qqWkX9JjOvmV6bXqg4KyxA-1
X-Mimecast-MFC-AGG-ID: qqWkX9JjOvmV6bXqg4KyxA_1784856903
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A5601944EB1;
	Fri, 24 Jul 2026 01:35:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.238])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB501180059C;
	Fri, 24 Jul 2026 01:34:59 +0000 (UTC)
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
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org,
	dev.jain@arm.com
Subject: [PATCH v6 06/14] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Thu, 23 Jul 2026 21:34:10 -0400
Message-ID: <2bd3de77beffbc6130737ffc77a00cb080efcb8c.1784856856.git.luizcap@redhat.com>
In-Reply-To: <cover.1784856856.git.luizcap@redhat.com>
References: <cover.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: N_Kcv5XHFryXiLwL-cMK1ownDyM3p4f2YOohLjCA2D0_1784856903
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAEC41C000A
X-Stat-Signature: ucwwu67k6171ghqtzj4478zezyqdryne
X-HE-Tag: 1784856912-151014
X-HE-Meta: U2FsdGVkX19xxvjOHsaSbKRR7MaluBwCfd1yUdfrXHK+cPmQrM2XCIgd9s5cm9wVQt1oVT2MK4wU/1/by78DiouZLbQeHzbANJcHItpQ/K+ollpglPheLxigrJ0i+3IMh777g+cMc3a1I6FF1yDnp9mHd6hpkLmPRqqx8nU27akwcdrbzU8MYTXAHV7ObOGR38R6EjN8Vvi3kS13IuV0GF/TRy/6U2kJgRYINkrEvOgMPhbiMWBF8YHZFwBpsPAVgtWW3cpj2cOkEYYrHgNiZacZ5DlFNDPphqlE8K0fxVAioxzhX5CwJ3vqUf28KkJzJOAFCAjESMHoCbYTNWPlC+kDuImrwzNMG8Un9nEn6MzMmnr6kLJKM/4oEd9irDZufylzsyjNAWCyVCcci0/DCiWou/vuw0I1wlUnB/zj5J2GWbIMjvaw0moePZmyVfbbc+9z03wL6RUQpuNle09XZXC83CrHcFQUzjEF99Y9rcAmhWYd3YCkMtF3CP+g6HygGAjnCPQjz4f0rhAVeFU7y/lXNbwxu5OeV4SzUFsvdhuvZaG9hWRcit9zAFpCTb4ZKXO6i7I0YEkKdAnD6Db0W3q/Nf/H7aL2anek3mJfg+d6bA4YxCwYK3BD6bKZyJJPWNffliA4fm7yLLdIUMvGZTVnPOAasGf4GSJcqGcDqmgMap/IP+oVrD/ZejFkMzhRPk0Flmor4Wye0gxwtFQH5gZzn7B/Fr4KWCAYYmq6JVGWi0HLZyw5tyMv3zfzUCQj6i0KhDww6O7KmxndNFzr1lBADTJgpvE7sxtZU7fwLIQcQTuh74RPwfk/uOgdjymtSYKlG9ij43SjNb/BV9Yl2nSTf2HCpqt9FqurFyH9mi+RJhSqCc0RuP2xNyz5JsFwVFBGFA2hmf0ouXNvQvl8QgtYk45CDthEYYmJOAmF78pXsxxUnltPXIdeqRFLStC681jKM4fKYY8t43qPx5+
 p+md7h49
 yG+P4h9DGMls42CFX/+AlImI/nlO/sSfsKm90qgppHTKvCiz20Jo+RawND9DbkdfEKTbF/O/x2xASLuDjCmcpfn1k3153QVj6OQv2++QUxsqE81LpvtQLGwNfopSjnc1DQ+YlcaKeX358jEyumxl1gRjaTXK+al2S2W6OWK5KnaX602MFzQzj4xjX+5ftgrE1unyyKYA97K/E0Vdt+jno2pW//DmiHtllRgXwrDOQdOGG0oAbNg+CrVHssNuXqL5sAIrJ96PHjHnDjCoXvWFEkozFbgqSZlUyZsmalq9M8RsFwTeZXgt9vqsVpiaic78WOOPkEOGSy8KSuip1rW9ZGUh+L2oJF1L55DPtCB1I8GAtSjPwJLOw1Ynw8OB1oOE/0UGjQHr9u8vmEzw4yj0SqPJruIN5v+LJqK1Y
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


