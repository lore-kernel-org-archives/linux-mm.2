Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35280606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sqGxzC5V
Received: by kanga.kvack.org (Postfix)
	id 620126B05C2; Thu,  5 Nov 2026 13:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582796B05C3; Thu,  5 Nov 2026 13:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470DE6B05C4; Thu,  5 Nov 2026 13:40:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21F3A6B05C2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9608240C32
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:57 +0000 (UTC)
X-FDA: 85401932154.30.1D20CEF
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	by imf27.hostedemail.com (Postfix) with ESMTP id A82F440009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sqGxzC5V;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904055;
	b=V6bQ8gkLFkAaDeO0wlYoXIN8C7ytmNnYJMuikyKTIvme59r1GS07n+pkjHNzqdM4eYZ5FE
	/YtegBNHJFQROjNPJMSvReOY6EV9MleJWHULipzfW0hWQyvnDm9DtVVuHQXrd/ZbG1cd9f
	0czHAgn3XigopAj8aJD58syYoHtKTE8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sqGxzC5V;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.92 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvTGmyE44d4TGcIZqimy1jlaInJo0SJ57S1SRdbg5dY=;
	b=3SKm1ufMDQt3qPPf1xDnWjxEopSD+QwuOdepwwIUN0LubbL0ZJzjWGE2tqWJPCQoUzMDZy
	6slCAZSCYMxjrRgB+jNALK2K7rKJoGpPMm9n4XMIbNh0U+gENJ4z2U74F5QELqJSEfI+8r
	al0gZut/RLH4kkLaNfe4jsvr9iV/alI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eEH8jln6expy/CyMNQ1Q/mpIEWoqGKF30ttnWbqCltU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904054; v=1; x=1794508854;
 b=sqGxzC5VOTfoz4+eM8517Y1xjefjoK6Ewv8793PeAlkH6xtnaau2x79ByZQJIZd7LOhJSleG
 2gV/6kRMb4g446hWkUROXgPTyQK7FV2jRomB7cc7AcT2BCgCOTWx5tDUsVkG5qLFvpKzruASKRv
 +C6slP/PG8RG5JUz+xXUi5eA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3feb19a193c6dd22;
	Thu, 05 Nov 2026 18:40:54 +0000
X-Mizu-Trace-ID: 3feb19a193c6dd22
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 09/32] mm/debug_vm_pgtable: test PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:53 -0800
Message-ID: <20261105183940.2236717-10-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i19wp3ekm4x4tky5cj7c53s9e481om5g
X-Rspamd-Queue-Id: A82F440009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904055-830003
X-HE-Meta: U2FsdGVkX1+CN3Eblzl+mLY/4wr4FvspWV48VBJv0l0Y9oP9tBKh9f6C74qDjpacqO2sJeZrLY/LxxxeTva+OqOCiagYiyNLDM+s5XX8SVEyBcSOxEoDlnuURNyBYYZUaN77sWEFFM2WpxNPMLKpcKwFyqVMCkyyMPgh5RxkKJv5Kn0r54PAVWwl/EWoEB3rsuXu8y/AWj8gWWo6bw0qNyyR4anxO70Y0R4Lh06LT2VuJxSeW+kTPYXRFpe9eTnUc0Q4Je+fpxniZAKqJVSinoU0eIXzWSt6zRMJiwtlgCKKd5hH8kAzzTSnI1yTFV53PiwlNyond/D4C4/Pdy6y5myTNlIuAuB6EsNDX3K/mJrGbTf60D9PoFERAd4qRNIcMUp/ZzKGKEP8xeMAVsvQAYDvq1lfTteW15eAhxGr5RVbDOEXQTnVupvWmJCcU9RszfaFgx/6kIMmVhyfgfHlCd04G0FerhsBUyh4HR6yVy5m73I114F1kamd+HoPnukyRzQ1ROUOw7EOTqopTVC1abQQ1YVmGOQ1BLDC5IzBywPayrAFKK1JEcexqllKRZeNAswOXxxh82CSthh79kEW3kTpZxVuqyyoTJ099xC8NOLklGwQHfVFv8jlvj9DAeUZpMKnQGUUzYVM7v/saDG9OuKEXE9F1OWLu3lW193c2zklc5tfX1ExeyPaWX6Ou2FyIP28o0+WsmG16CgZWh3R7nsad8QHtdeDuNPV2YsBHXmlZ1GDjmz12TgTielzCMrCxIrlGZvPVHrNPUfvyzJiTYhTuI/BzFQsG2/iw1z8WJHAqHkBuBGaunQ/JNuBsJMlziUO1hpPX7rIlJrjsfuyjoz4/fZccXgKwM2K4Nrj/isoFf63KNz1ZOr1Y78e01a9KpCJJwQsZBwtEdfdNzdOsJsCTziyErnFjrYns7CFG7Ik/cGPf9Dla5hSXTUM0leKd0/CD6BfUnRKxTiDZ7O
 Xbo8X4ij
 JIYeycXZLb+XPdnddU/Wp/op6ytnJ61dfUqvvAPRtaf26arjY6HMJ9lrxy5gVJGnT/WddxIHX1ieZ4sPJ6tSEjUs97oFkEKG1igLm0lWwwyyXMPFuE8c1KvfM/8Hdfk41ZKs+I7g2IA/dIGV46o5Wgs7sglvWuXWGBWLStSJG0RTKrPbe64Vvvyaedwm/3utvhbAauPkDl8OOYtz+6FI6H7Pr5LGU7FZhRdzhU6czKe/etWY8j3DKi4GBeb+rF+/sO4nVLLweaM6GgzTVmOwueyra6RvwtAPwJ8X7oJfCCYtyPuF6NZLXwYwgbLPR8qGSH6Aw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An architecture that picked a PMD exclusive bit overlapping the swap type
or offset field would otherwise only be caught by data corruption at
runtime. Mirror pte_swap_exclusive_tests() at PMD level.

Also check that setting swap soft-dirty leaves the PMD non-present.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 mm/debug_vm_pgtable.c | 44 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 2875fd22d7bb0..80686e2baaa14 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -762,7 +762,9 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 	WARN_ON(!pmd_is_huge(pmd));
 	WARN_ON(!pmd_is_valid_softleaf(pmd));
 
-	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
+	pmd = pmd_swp_mksoft_dirty(pmd);
+	WARN_ON(!pmd_swp_soft_dirty(pmd));
+	WARN_ON(pmd_present(pmd));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
@@ -802,6 +804,45 @@ static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
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
@@ -1322,6 +1363,7 @@ static int __init debug_vm_pgtable(void)
 	pmd_leaf_soft_dirty_tests(&args);
 
 	pte_swap_exclusive_tests(&args);
+	pmd_swap_exclusive_tests(&args);
 
 	pte_swap_tests(&args);
 	pmd_softleaf_tests(&args);
-- 
2.53.0-Meta


