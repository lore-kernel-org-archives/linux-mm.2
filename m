Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3440BCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7566B0098; Fri,  1 May 2026 15:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E686B0099; Fri,  1 May 2026 15:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB546B009B; Fri,  1 May 2026 15:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF0E6B0098
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20647A0204
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:24 +0000 (UTC)
X-FDA: 84719817168.02.7340CFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 269A2100003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kj5nUGqt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwTXplBP3/R1ua0FWXZ96Qds9nsahLlEWeI0/s59WsU=;
	b=SOs6ts6hrqfqwHzj0y+9KQpPW9p/HaM25cTdkbcORJKWsNK37oT4kvIZyCyGEDrXCHLEgX
	/Hd3LONzDlFm9oCO/JqG+pb70pi8hMEzRTLFS8A/PLY+NhGS3/EKpObL/acR2SEoUOQOSt
	+qefLbYcx+v1+i2yPORHniao42JLDTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663222; a=rsa-sha256;
	cv=none;
	b=tmSGdj3dTRswRDkBnMWzQv843e3HPcgV0hNrF6xWJNn3OwkRd8lxr/2ZZnOGFMei/Nr0rC
	NhN9IWVu91HFOVYw2Q2MyY7C9S1RPgnzE2a64jbvkQ/Aip0uar85BQpRhpzcPvsYdKFC7k
	6Dq2519Khkkr0pA47r+dFa5SyOyaJDk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kj5nUGqt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UwTXplBP3/R1ua0FWXZ96Qds9nsahLlEWeI0/s59WsU=;
	b=Kj5nUGqt2t424r97Fi8opNlfuX9c2u1GDWqovio73lslpm9iThkSS6duQpXq6Jk5ZMjEBJ
	cmrE29IQ9183FWUQH0g0L+K7OynQaHnDgs2QFZQFHYkteVPWpeqtEQKs/eLD9A24GzK4Ay
	FELkB4zAffNpeH3v6xiSp0Exn1wGXf0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-o-fzyAVKPtCX2m1Qjn9WWA-1; Fri,
 01 May 2026 15:20:17 -0400
X-MC-Unique: o-fzyAVKPtCX2m1Qjn9WWA-1
X-Mimecast-MFC-AGG-ID: o-fzyAVKPtCX2m1Qjn9WWA_1777663214
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17E731800352;
	Fri,  1 May 2026 19:20:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D69F1800906;
	Fri,  1 May 2026 19:20:11 +0000 (UTC)
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
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 5/9] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Fri,  1 May 2026 15:18:47 -0400
Message-ID: <3a360247fc636869c3f511cda52f3c4522418c06.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: jGriVsYLWJ8TxXJ8Nu-NBiu34ZmhFGeg45a60c_PGZI_1777663214
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 269A2100003
X-Rspamd-Server: rspam04
X-Stat-Signature: 43p1end6nxdzbne16kuohzy9k895a5fg
X-HE-Tag: 1777663221-815568
X-HE-Meta: U2FsdGVkX1+l/9zkr62YAjVhDgBdZ9EB9u/uMoWeCfoBU5iGvJDwbq4EwGkpZUhXpJocWFBoHwbeYl72F06jlFqAl3dHBgmR/7ngMCSqmZ5pCAniVTkl/A7tEwsXV8PbC8OADTR8VAWro3MRIgiQumAH3vOTOMPiarBWQ2RgRwuFu5REUDobS5WKDJZGmz9RpebXYOd0RLkzBoBI2RkPJbOcADk555mT03gmQ1qF+Cg+A8HOgl+NmR0r0ELEFCYNXIzE5yA514ui7p17dE1P7fF4mSdvNxw9jKHaUz1t7oV2FxmmfVJeOjGm3/P/XELpOVYLlXolL7eAeaRCccq1rsy35iNHq7oHlFjbujZ7aQrHLmOgiSdRWaPtb74t2IpSs3DQc3v+R5vNCpi8K4Jngq/Mt5oHHA7H4R52qcD3sO/kNPZcEx2/CWl1rJyqQhLQAiXCo4XN4KbrDKmm544UOJGXEJat9BfchPi+IewwOdoH2tw7yGeX3OrctzlYQ3Ytld3c6PbVDUpzEBrnOwzphwqL58XsOysu83JZbmg0irh52QuvucqEGTM1bLPOyLPHNwpEosc9Ahh78sQy2xGFtjpi5lNRFLD/nBnEtTxWLn6sGHDsnLioIMRLvuOBkvd2i2BXV8vW75eX6cLctJVbkE2WUNif033XqKssiwH8e2lD6Iu2tWQL2ykA/VmZ6BjHI7GHRr7hAKP3Gm5QFjQZiEBUOK14sIch1yFrSpvq+7UIeNcf0Z5OYfuowvqfMnwkh3xxXuq6TSeh7Vfa7gobyHqpl+3h8aVMQjXPf4GCPjOSME99fWmUeXtMmVk5RmzoLHAqZpdH1vQsf3x6t2+TPGZm6iAHx5QZvDW/c+KBb3uMBmKlBdzKXD7gi1kA5c8nihbaCQgYtbT0+gas1pr77Tq491rUDvdS9VWxaYNBDMnQDO218kDGlcoje1bGPUg2lfMp++SDXuQExzTrgvO
 pEMqgBha
 D4NQ0CY/wMZujPQ/EbTtiHS4EyAQ3p/mZHw0cFFkjopA5tYzbyF7QZon/gtR2Io7qDGp6Etr4ZE7UR2b9aFer5ZW9PYB63eIERRkVy7PRBhom47UbNXDAzvSB0mztc7lxX1nsJ1ytJ9BQi0cl5Y41S+SrT55hTocEBvM2te0FixPPFGzDXphIbUZLYNNqlmZOb9Kribqfuu8NzYAVnPsd9tErAI64xs8koR+KB8rWAJECeOmtfBsNzwrfbWUHhpaxmOxpEaL1rPoClLGnt3sUnuSRXgk9TiQW3C/hoeT/Q5yOsFBY/1VPlCXQ+NvwuH0uYTFb3K85hvexOnKeBL0uO/8gmT306JNZ67CP8WGY3wv4PuvEO5dymI4KL/RdfmaQqR9FAJw3Z1cER9CFyqDh5upAaa48xmUTW88t
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
2.53.0


