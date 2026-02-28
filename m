Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FDA3FEE4CB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA166B0005; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DAE6B0088; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6FB6B0089; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38CED6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:15:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7C0E140ACD
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:28 +0000 (UTC)
X-FDA: 84493004736.04.8C66669
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8B95A0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=R2hHTXWA;
	spf=pass (imf15.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772262927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vKnFbDy7FB6sF7REDl1Rwe0wUQPquhjGlWDfeFYqFE=;
	b=StS3JMezcmDw1vbN/0eKzWTGCtXYcWycvyCIrnn5ZQdpuyzyump8bZAQyC6bcypz/+3EmA
	twGChs9jDyyO/WPejKsKErJnfSTjckHHF13ME1jXyNMj/6UDD2l5GKjv8hpm8Y1UQoavED
	aENnr+YIkRWbyBRfXyQApqN5WaagvuU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=R2hHTXWA;
	spf=pass (imf15.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772262927; a=rsa-sha256;
	cv=none;
	b=twzI+Wik0guUWi3iSnl0kb3mdkEufstj7ujppDL4SjgVO+xbrHLnUIwBNd6PQzEujPelJw
	roN6OxsXAcGdCvmmUyVzxd3X3EbTLCtGyagfQ+kLAsW9md6FBruOEattPVwAi6Q79FCjY7
	OWs6yYdxaUYazOrOFuOmsjdGcVBmHcE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+vKnFbDy7FB6sF7REDl1Rwe0wUQPquhjGlWDfeFYqFE=;
	b=R2hHTXWA18ZhrxOkzNZLndRDgNWvHTt+4DcHZrJf/rsTQ5W2EDWOF0cxB/RCoS2dA7df9cByL
	8xnULNpZcgD71u+b36aCNilavhq6qOStTB4fDjckgq+oJm/h4yJIZPZzoYFBaja2Rnmzsy3r2Su
	MGv9qdoOdNwtKwG+o0Tz61c=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fNGYr3FQxz12LDx;
	Sat, 28 Feb 2026 15:10:40 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 4796C4056A;
	Sat, 28 Feb 2026 15:15:19 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 28 Feb
 2026 15:15:18 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC v3 1/4] x86/mm: Use proper page table helpers for huge page generation
Date: Sat, 28 Feb 2026 15:09:03 +0800
Message-ID: <20260228070906.1418911-2-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260228070906.1418911-1-yintirui@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: B8B95A0005
X-Rspamd-Server: rspam08
X-Stat-Signature: yqbhkmn5zichnrwcpasdsc1uytt75kq8
X-HE-Tag: 1772262925-265418
X-HE-Meta: U2FsdGVkX1/e1Rb4lm8OLCshXtKWw6APW2Kt0P8s0geyVgu1xqZ0wbB6E+k702K/qn1tEfxmuHZQT/OCeEERT5GD/LK5oELNN1iV4iSJ6Axmw4aIMTm/BdVMiPzfbKdtYAF+HMxuUa9YXSdAbpmnEcs55z03Y+PcddKqcVz7YHbXwNQTsQnrkFcfgsbjAqUHOF/d4p9JLJM3xa/2nigSKGJPlNFSJh8YDGBbUeCMu7AeL6wL4r2fz1uev0k7m1tUUcN7b9hqQN4nHkUWlXmteypgYdMUCa4Da17GLkPVKE0nfWv7ZXvsydXQ8irsfXhlI2DTYnkAt/6cTNJiDfWdSc/2Q59JNNk9lgbxQKnLi8+Pg42E0sGzmW9sMv8/YTU9BKOSjZ8Nwv6c48kCXcFZuW9owE2Qw4wTrYt82Yhb85gBA3vu1C/JEMMe6/dzkKXeouDrZ+zr7Mlqt9LhMYn06bRXTlnz6+KGi8WIvsF8iqGTb1+alPxwLDeYnFkHBoqfAHbOY4fOPcpkrOrBmmRIwSXdab54qsmQRvbKcPjlQKdcNUjyCC1BDeO9k0ZERGp0Om0HS4KZEa3wy2NAXE80SZpr2QHoIZU7bsltjWz/12ncZaG4LNR/tbBfMKMshM0eTmIDsqF9AVlEM/kUe2Muf5/Eo224Sl/Tfwvz/6mSckTIcPv7KWx67xx36ZWzIGqakm+EdDRXsAGRNOOOunZuTIgbGzTZoyBiszdUjKv3TU6VBNleBY6Maz/7S0Hfa1pZZoYHJW2xWp4R3eeyv7KPIET2zMYzln4cf3pFxVmijuAH/PQqts5IS6/sWYvpwAp5IQqi4+G1c9jk/FN1+3Dd/YHdnoVLQgJt+MU6w/ETaoapgy5ZSCG7hxMEabP2Jzq9X6y6SiEsORLSDT3+Aj3gNj2sGFYJrFJYZqQgrQjI+AVw3sMESV60Mqd2yEmZfCxNRR8ltgJu18KP2/yyw/K
 GZ4NUiWm
 ErIG+gP2VG5PA6EU0df10fXZb9bqDzbvX7LICTUEvuaLlnez0O//bgCQzCN1bC7kYti3fQIiPEhb0NfwZm05Tr6NVTVMj2dNid3VKeratOKfs1NlknHDvf3nxzajjWw8rTiUwxM18otOhhiSiB/RvIercmuj4/wsZQ7l+tB2oZdRwrY97lAQV8r2vYnCzXQVX/FLPMtW6+JcTugw97ISsR2HHWgACX7oUiajv96ozuFw55oHNsK7+PiNz+M6bFBQle51TLOjUWTBXLtwPAAMnknHW6M1sjg5I/Uzw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically, several core x86 mm subsystems (vmemmap, vmalloc, and CPA)
have abused `pfn_pte()` to generate PMD and PUD entries by passing
pgprot values containing the _PAGE_PSE flag, and then casting the
resulting pte_t to a pmd_t or pud_t.

This violates strict type safety and prevents us from enforcing the rule
that `pfn_pte()` should strictly generate pte without huge page attributes.

Fix these abuses by explicitly using the correct level-specific helpers
(`pfn_pmd()` and `pfn_pud()`) and their corresponding setters
(`set_pmd()`, `set_pud()`).

For the CPA (Change Page Attribute) code, which uses `pte_t` as a generic
container for page table entries across all levels in
__should_split_large_page(), pack the correctly generated PMD/PUD values
into the pte_t container.

This cleanup prepares the ground for making `pfn_pte()` strictly filter
out huge page attributes.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/x86/mm/init_64.c        | 6 +++---
 arch/x86/mm/pat/set_memory.c | 6 +++++-
 arch/x86/mm/pgtable.c        | 4 ++--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..d65f3d05c66f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1518,11 +1518,11 @@ static int __meminitdata node_start;
 void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 			       unsigned long addr, unsigned long next)
 {
-	pte_t entry;
+	pmd_t entry;
 
-	entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
+	entry = pfn_pmd(__pa(p) >> PAGE_SHIFT,
 			PAGE_KERNEL_LARGE);
-	set_pmd(pmd, __pmd(pte_val(entry)));
+	set_pmd(pmd, entry);
 
 	/* check to see if we have contiguous blocks */
 	if (p_end != p || node_start != node) {
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 40581a720fe8..87aa0e9a8f82 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1059,7 +1059,11 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 		return 1;
 
 	/* All checks passed. Update the large page mapping. */
-	new_pte = pfn_pte(old_pfn, new_prot);
+	if (level == PG_LEVEL_2M)
+		new_pte = __pte(pmd_val(pfn_pmd(old_pfn, new_prot)));
+	else
+		new_pte = __pte(pud_val(pfn_pud(old_pfn, new_prot)));
+
 	__set_pmd_pte(kpte, address, new_pte);
 	cpa->flags |= CPA_FLUSHTLB;
 	cpa_inc_lp_preserved(level);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 2e5ecfdce73c..61320fd44e16 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -644,7 +644,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 	if (pud_present(*pud) && !pud_leaf(*pud))
 		return 0;
 
-	set_pte((pte_t *)pud, pfn_pte(
+	set_pud(pud, pfn_pud(
 		(u64)addr >> PAGE_SHIFT,
 		__pgprot(protval_4k_2_large(pgprot_val(prot)) | _PAGE_PSE)));
 
@@ -676,7 +676,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 	if (pmd_present(*pmd) && !pmd_leaf(*pmd))
 		return 0;
 
-	set_pte((pte_t *)pmd, pfn_pte(
+	set_pmd(pmd, pfn_pmd(
 		(u64)addr >> PAGE_SHIFT,
 		__pgprot(protval_4k_2_large(pgprot_val(prot)) | _PAGE_PSE)));
 
-- 
2.22.0


