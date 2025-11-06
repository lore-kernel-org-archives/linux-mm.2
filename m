Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3896CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776358E0009; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7017B8E0002; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52BEF8E0009; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB278E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04E1112BF86
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:27 +0000 (UTC)
X-FDA: 84081473616.28.91F1F0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5FB9DA0011
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ch2UKgVq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Q/SGZoDMzCFiE+HfvZvclHk/fNK+yt1scbMDujY49o=;
	b=To2P32A/fp0fOFTjuCejwruyKFZLB1SNBjM8CY4+9g7WCCRE+NwUTi3wCc6JDtKiZLwTLp
	d83QNUvAqn8v6EtoqFw1Fpgpt1kNWUHc2LE6U9b0GBjXcl6FTbsdqHTO9AUkcTnsqpb2ec
	mBMeka3Sg5XMrO9774QCVwD9CNPGJrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464566; a=rsa-sha256;
	cv=none;
	b=STWBbQyh/kO/uFsGASEwtJyMMUo9k/z3F57gLygLizizLydg8L/0mStQ5k3dztf/NjuIlz
	UVzuG0+wJpB4m5PZO8S/6RuWaV+wg5wObJOxRI1X7JuUWLkudnGj2XAjDPIJV8ZOyiP+Bw
	yM23rgY67zDVSxRlDD5+PnzwMJ2kwVw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ch2UKgVq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Q/SGZoDMzCFiE+HfvZvclHk/fNK+yt1scbMDujY49o=;
	b=ch2UKgVq8KNiNqnmyrtwZS1S0SzSQupdUGdRJ1sYVyBuItBbQvDhkfMkN+crLsaxpMvqi+
	yBYyJqNPtY/8vwkaXKAtU5sKwhZ3los0QCpkvMHSDxSNXwcEMLfDnkKNFxiN6YDe8pHATi
	iJQAhe6lqU2WnGOMYqA19ZwEkcZgo+A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-nUk9SCG5NVKVdyycDf4y2Q-1; Thu,
 06 Nov 2025 16:29:24 -0500
X-MC-Unique: nUk9SCG5NVKVdyycDf4y2Q-1
X-Mimecast-MFC-AGG-ID: nUk9SCG5NVKVdyycDf4y2Q_1762464563
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 501C81800357;
	Thu,  6 Nov 2025 21:29:23 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29FAE19560B2;
	Thu,  6 Nov 2025 21:29:22 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 06/10] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Thu,  6 Nov 2025 16:28:53 -0500
Message-ID: <237bcb7f3d832457322210cc7f8d1272c4ac88ef.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 6nj4m9ox359zsoz1ymupuf531jnpjbbg
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FB9DA0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1762464566-901329
X-HE-Meta: U2FsdGVkX18yv7Kbn6W2egVmBRp3XcMp+cU+V0OqKLkq28oSJeLdYIPZt7PKbfjqdqP4SR2Bk8TcSj2Zh0Ge+63LPdNSAnVgR0r7iDwOaWC4Z4UgxyR7timb7SmLyk1J7LNdI5PqA8Y6Zk5LDXpfE0QAZmol9ISZ67CdYf8K+gXFzyF1OKquVnLoVNFYlZBnRihWeYCAZhszBfy1+cxH4USTdwN1Kyyt4MkLzRrb1w2AEBRowKPHCOAsavTLBrk2ZeKd2zSVyJgVltu7sPmpuIy9ek3kXw7D4FWEfqWO9PFjc+A+mfvI0NRwLnEIWY0oCe8GiD3/2L3OcuDU4HgccTVCXOCLEoHlX22wkilEw0VaQk4B2bd/vwikzZOJ9d2iJPfJra2u4C8srkwQkc3ys1qI8PTxqhnnVRecI4UgGqpVWsIgjvQUusm35nRXUWZjYDT31WfTtDjgM+N8gSt0YfXqTWwWSdavOx7Hik1eLTNyaHiedXWBt+zP1/xjv++hJz/ZsNpUE83Qj7v4aJgNlWd9RmVTbZSOFiNYLdueWm181A3Ds8pHZgrDG8t5c+IUSTD6Qj2O2TNE+s+9qBpZ1fqBCX7aRu4uUlXjxMZQsa4+WWzH8GCTRNoVBRLCUrFKWNKnRXhHmrmNL2VSimUjI4pPvoDJWSdgELn4eYAKvV4exsCvghssdjcQYHTzzpuIIVj9gf4GNm6l0MEy0NmGgHsBbubDg7l3VqyV2vHhBOmwcFswEZgOSZAVZXyXrOEAdwfrvJ/4HTIgz/qsDgd4Vfv4FqAfu3GzAgU1D86IswlCXqSEdsWueq9fPLkJLbfUbmhquB99C097eZjY6hIpfxNY/HCySP2l1AXkr6J6+W3GF31xmq0WITx71fFChY1BoKYo2kwInxjC1RzMsBS35b387OWirRLOiUXHOpl1gt2IiKZPha7DpH6hSZ1ilvOUWA7FrXSSQtF1r26IZFW
 mhiiak4J
 Z8Brj8UcgTBip9qXbynn+zFttcQk8QFuhns3uPNfmgp9BsBRUQNlPKIDBCRDiUaz9VIDCeLbxJnTGF+Y5/Qfg4Gak5iHBKGzT3kNNn5uNtamKmsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 830107b6dd08..241b36c78ac9 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -170,7 +170,7 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 	unsigned long val = idx, *ptr = &val;
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD basic (%pGv)\n", ptr);
@@ -208,7 +208,7 @@ static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 	pmd_t pmd;
 	unsigned long vaddr = args->vaddr;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	page = (args->pmd_pfn != ULONG_MAX) ? pfn_to_page(args->pmd_pfn) : NULL;
@@ -269,7 +269,7 @@ static void __init pmd_leaf_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD leaf\n");
@@ -674,7 +674,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD protnone\n");
@@ -721,7 +721,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD soft dirty\n");
@@ -738,7 +738,7 @@ static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
@@ -801,7 +801,7 @@ static void __init pmd_swap_tests(struct pgtable_debug_args *args)
 	swp_entry_t arch_entry;
 	pmd_t pmd1, pmd2;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD swap\n");
@@ -881,7 +881,7 @@ static void __init pmd_thp_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD based THP\n");
@@ -968,7 +968,7 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage() &&
+	    pgtable_has_pmd_leaves() &&
 	    args->pmd_pfn != ULONG_MAX) {
 		if (args->is_contiguous_page) {
 			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
@@ -1226,7 +1226,7 @@ static int __init init_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage()) {
+	    pgtable_has_pmd_leaves()) {
 		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PMD_ORDER);
 		if (page) {
 			args->pmd_pfn = page_to_pfn(page);
-- 
2.51.1


