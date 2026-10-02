Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C563BCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6D96B00A5; Fri,  2 Oct 2026 05:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731866B00A6; Fri,  2 Oct 2026 05:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9206B00A7; Fri,  2 Oct 2026 05:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E31A46B00A5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78155C06CF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:26 +0000 (UTC)
X-FDA: 85277231172.07.665BAC5
Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8DDF7140003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P3cgA1ar;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.30 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934984;
	b=FSF2OpzXyRb1kYZ8trRbkRe56d6amHZzzSTEJuTFEqQr0DvMazKUxvHtkjCBfRmJfhwLAC
	1m8oX6p+HBZbZs9ApR0ejxY76xO3N4eAkW5CBF9nUWmSv93kCp9NeowbDZ2lgf7qDW4sZi
	LhSVLNoDVs949Gi7iw0isSw2ORn74zI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P3cgA1ar;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.30 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVI2mNaozUsXDWMCJlkDl2YfSrrOkfxGKzzVdW8FJhs=;
	b=dOUUZIQvYkm+O4ZwSv4QnDeirXaEcoUBXeFIvNKLo0wD5h/0RbudoHmJanZ9xw4x8TZT4K
	hRgRuGwDBI/mkzmmdUrhIqVM+yRXc6ZKuprWXrWG6i2h7okxS6NIHEAoDbWxM62zOhwxxD
	ZBkBNRMOIx1vaSNgv7lz5PSEBix0r7U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tZ9+wDL6rWNTsZNFf4VIK3WwHrcNDZjVqDRCGrUUBnU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934983; v=1; x=1791539783;
 b=P3cgA1arufy0XFSaVdY3EeZqsSQWwCVF9/2rCfXFQMLW9SKHf3b6zbcE5lL+oqj+eEs7egAG
 YL3vlwkznYQm61fA/eTRWV+vlX0fLp6LWomEGqoh8d3dHXPxsiB5k7ZtTMoxkmG2xrkU4N76eIC
 jwtek618cHbMJIeoXnyNOMZc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6322d5cd786ef910;
	Fri, 02 Oct 2026 09:56:23 +0000
X-Mizu-Trace-ID: 6322d5cd786ef910
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 09/30] mm/debug_vm_pgtable: test PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:23 -0700
Message-ID: <20261002095503.3585565-10-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: xh643mh766unbcy3brh1daw9x4bxzzo8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DDF7140003
X-HE-Tag: 1790934984-899541
X-HE-Meta: U2FsdGVkX185Ah6MT1VuMbRlf/eHN9qH6eIoPkh+P7neM45CUQlsy8j1zpaJzmBUKrqz0ltYEQIup4YA4E5R+64UBFsVxQWdxXNF8v2KfP5NkkQesga1kW5qagl2K2xAQKWD14NW2wNW6Ei6Ic4OduxXQs2tlxJrgaFq18HFyBmtBq6LSl8HEaXipnM6iqW1CHs3jMB1LnCA7HGU9D7j57E8+gzH+c9t1AbpeXK6aFSF0vcufuSQ7pFKDq7hRhIOhn0zoPOWUWwHA9hSiWjmfqPR0B1xQi5G3hFk474I0LbNkIQm1DSm5ED3O6W4h6JoPq4Tk/h2Y9JhYDkGo1zWZg4vXj+dXa1knw036avOXGEuWX/HzUM3ArbcgspklqVESnco8KSk9ufsaIIeZnrafYOQEm5jFdnLq8NunrtKv6zEsH3xVCWnHrB6pvKUoc9ZRC0zDSFSoFyZpEU3nibWc9r1zyPruXEdfh5jJrd+hVrnUlmJWbipK3JbcPhgJh3br0qYoFnd4cLNnq5eYNleoMLm5h+NQFmLB5nC55sMpElNQjQ48BIXtGpU9AaeGG/0zBYAoEtWpsc9O+8TOcEDWVDgVolKm2/OfUGt/x4hqi6yLDF9rEZTE1rkJvzeHSFhaCNITwyowdPgHs7jdI2tKpguo+cSF1+VNhmtRjDLr207LzF64NWykDKMF2C0FYv7MLg0N76Nxrg/t2NBfEW1bNkMVgJ9DHSAeSUTimWpT1XUsPcleeVfG08cVfF5QFvIBLKBQdfHgkafXPxdGeECBA+chzH2pGar+nHLVVifcS3OpWbM+nk0zFEa+PuTDCcACxJ3cZfwVUNjO+uqOmoJqZY3r90iSIMQ5KhLSAlQQxsJa8j6hALYM1veCnnC4Ijxc52of73V8z37tVeF/pWYetdFezsEgR/qmtJm9/eUABdJ3mTyiK0P8A45AICDmMSfnycVdtK9rCF7J/VcUzq
 CZj2iSJp
 jDQIrEtOwjLLFsJ8s22qw9TtB5sv/3aTU6Lch2/VJrnrryOIfhcVTg93apNfXbb+lJ+TnjTMALHjonvW/P4oih5sLejvihcg/rM8Fv++GBPPOA3UNf8p05/RPeN3S3UKnyzNAd9CtNcWjzr79qGASwVCoLFmTU+x6m54Jxq7ouEyyoo9eRFuBkgHqORhjt9Ze2JE8oldGFyjnm9ReSrNrBF4QtQIdGEW5X6CbvqlIbVBaVS8QwlyIn6dJxXR5T2DO4nqxa292GsajxD9RM+apBOgtIMvKtFe1BCiZy0EY1dSaKtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An architecture that picked a PMD exclusive bit overlapping the swap type
or offset field would otherwise only be caught by data corruption at
runtime. Mirror pte_swap_exclusive_tests() at PMD level.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/debug_vm_pgtable.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 2875fd22d7bb0..863111c6d4eb3 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -802,6 +802,45 @@ static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
 	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static void __init pmd_swap_exclusive_tests(struct pgtable_debug_args *args)
+{
+	swp_entry_t entry;
+	softleaf_t softleaf;
+	pmd_t pmd;
+
+	if (!has_transparent_hugepage())
+		return;
+
+	pr_debug("Validating PMD swap exclusive\n");
+	entry = args->swp_entry;
+
+	pmd = softleaf_to_pmd(entry);
+	softleaf = softleaf_from_pmd(pmd);
+
+	WARN_ON(pmd_swp_exclusive(pmd));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
+
+	pmd = pmd_swp_mkexclusive(pmd);
+	softleaf = softleaf_from_pmd(pmd);
+
+	WARN_ON(!pmd_swp_exclusive(pmd));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(pmd_swp_soft_dirty(pmd));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
+
+	pmd = pmd_swp_clear_exclusive(pmd);
+	softleaf = softleaf_from_pmd(pmd);
+
+	WARN_ON(pmd_swp_exclusive(pmd));
+	WARN_ON(!softleaf_is_swap(softleaf));
+	WARN_ON(memcmp(&entry, &softleaf, sizeof(entry)));
+}
+#else  /* !CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
+static void __init pmd_swap_exclusive_tests(struct pgtable_debug_args *args) { }
+#endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
+
 static void __init pte_swap_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
@@ -1322,6 +1361,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_leaf_soft_dirty_tests(&args);
 
 	pte_swap_exclusive_tests(&args);
+	pmd_swap_exclusive_tests(&args);
 
 	pte_swap_tests(&args);
 	pmd_softleaf_tests(&args);
-- 
2.53.0-Meta


