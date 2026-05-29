Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A46CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDDB6B00A2; Fri, 29 May 2026 10:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4512B6B00A3; Fri, 29 May 2026 10:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E886B00A4; Fri, 29 May 2026 10:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 223106B00A2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB08E1A017A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:38 +0000 (UTC)
X-FDA: 84820758876.13.59D920C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D73C4C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VEra/nnu";
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Buvsai7eu/rChI+FG2P3bORJyOvdzNeuwOi5N0sOvqM=;
	b=B/my8b5bjURZmuerb4eBOwzRdc8m9Uhm/HM1rUang0yuVC2V/yM3sFgBJnfqSHDnG0Eh4c
	yZC24tifdjtYT2dKiTGD31vDagmM1w0kSsfT0msk6zAaflZXsFfv+jNR6jbcHbmA0y/DVF
	oQ+8OGH477E4RtsXx3Maus/lD1MdNQs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VEra/nnu";
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066597; a=rsa-sha256;
	cv=none;
	b=lEWTdNWyzSrznDE9+fvoBJ/rntzhhaQzJlPDWyg0Rm4klejhDwNyzQNJl0JBDf5AetUDBV
	gaFONY0a6PEyaVsoGjIJwfxm2w+ErjIY1I2BjSlxGJ3SKM0vSB82E0A6YPbB7Fo+N03ee9
	SaZy0LXZuuXt/AWVDazuPkRi7yHqD0A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Buvsai7eu/rChI+FG2P3bORJyOvdzNeuwOi5N0sOvqM=;
	b=VEra/nnu3sj+djkK4fi9W+b/KH5xuBxzxMMaqtdFvyOHCTPo4SPX04542PXNsfzVOSDQ/A
	wzgLf5ZGGZwtLqjzdd3s2IJlOtB048vK68KZG0qpkvRM1Jido9YjRLmBv5UkPdgR3mQEMF
	slGZKOUdRaGY4dbS5oHutsk/GBUgNvE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-AwKQGMDjMeqwUZfARLXH8Q-1; Fri,
 29 May 2026 10:56:32 -0400
X-MC-Unique: AwKQGMDjMeqwUZfARLXH8Q-1
X-Mimecast-MFC-AGG-ID: AwKQGMDjMeqwUZfARLXH8Q_1780066589
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04AE41956061;
	Fri, 29 May 2026 14:56:29 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F0C630001BB;
	Fri, 29 May 2026 14:56:24 +0000 (UTC)
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
	ljs@kernel.org
Subject: [PATCH v5 06/14] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Fri, 29 May 2026 10:55:24 -0400
Message-ID: <49be9542b2fdc505297ac1bd945dc6348ec237b6.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: c4puTDvfHKmDHeTQyPuLRWHHILTgpr10Qouip3jK9ag_1780066589
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: x1egqotkstkkbjo4byny6e4xipwr4ige
X-Rspamd-Queue-Id: D73C4C000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780066596-953744
X-HE-Meta: U2FsdGVkX18nxZZh/2EAXF2fw97gHfDVeKUzvEHmQn4nbJfJ8LiGjaOMQRTby56ZRJgF9qhW//uLu7n0pM/yDCuuPBUhAvYaSLsfzJBdejj2G5rYv1ZBE1sMVNFJl/zx5e9Lfs8TKv7K9Xt9v5TZlDzRgEBZeJcAIYZyiWxQnPUtvjZy32Php6WY0oxpmYA+bw/vTa8jCL0JoFyehYsFRvL13OTCZ56JZyNKbrq7PUmqtB/WAK+dMG4/IEQgY4ApJsEq2l1Btnmp4hFiRWOYdk+uIw2EQR/HGnI3uCboOKBJEhFoD5FdzLaSze4lO2sPnhhkSPXY/X+j/hteW9L72HF80F76nCi8fanFGZoXUxSjtw3FPWzhvE1cLtC6Bd5wCnDENfc54N3Et/Ma18QVsq7iQAnkNLYQpxat+AGGG5rAwyrgSuk1uIBV/nM9yPgraYFhc57HTC0WLrqCQsL0XFFT3h/EQgmngGo0eNHWaXKoIbXPyeE+ghBInHXEL6e+rc3cn6a0ul4kW1l/nTP5IEfuQWj+ak/8nh4zxr/wK0aJ3pEAIcZ7mXmracrrD0IAFwak4EvAiVWJggizR/ernxJzrBZW3vBBhGa384UE5HfAq5y03xo70BbDNVUrs1u5OBSV7UGxmx6QqxtTCQQCA/AaSJNWgcux5QvQPQKaIMNnCaELwMK+55aqRTeh4ipl4XKnAHQnV9ESVEj9Piw1oIQTihFA03E5ykEUWyvzEDI7aByYvVJWXTNnkm1uPcng7lBsxkRpPglU0piTeDAZVlHvLWjFYshlJ+zv3R3PAV6nFCMXC9VzVjV7STvs4Y+kh7JhW7NzN2dUGVah7BVOvCKfLpjFXbhvnBfwrRdc7eNjJYHcyWv7GO38Q/2hnakMqGmciy8/8Tj2BQ7BSIOMrmdOrOzU4hV2OfaqC150BZMvH/i6rbVbJuWf5LvoNJJndtcyTb4hfb6ONSPqgZ7
 GWbD+6D4
 PA5Dw06OX2qKXMYvfIrMJ/FU6ZcbHLos6vz4nqNEKqLHHhOFz4vTchK1xaNRq+vphc83+37sY1ahDbSGOagdEumiE+szgm7Jk83I/22nmT5Rnt6pyrC+0qPzYnkXW+9J0HKXLt4/LTKSgAw2ZlRvWQ5+KD4QLWiR29+n555JBgobSTiOjOkEnthjavo5vg9cDYbNqpVnTzvImfPrOtDjFM4a729jiE9LBKcCo9xoijwkcpxQbfQa/7hdk7eZc4VwRH7reLYYleMM5AdY2cdnO9iPqYGr75jOk1ntd7DHUQkjCfqhlF0GVnelOavjwAow89B7I+PeFUzW+d+rFJaeKuBQ75+QG9/TgJuTAlCdQw0+OhowZ072SC5S5j98owTHowYmNWr1mv9Kp0fslqYv4kGlYCOO9yToBhRcG
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
index 23dc3ee09561..bd53417dde2f 100644
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
2.54.0


