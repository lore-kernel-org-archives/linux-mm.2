Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C4FC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6996B00A4; Mon, 14 Sep 2026 08:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FCC6B00A5; Mon, 14 Sep 2026 08:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6276B00A6; Mon, 14 Sep 2026 08:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA7E6B00A4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E8BC1403D5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:21 +0000 (UTC)
X-FDA: 85212303162.10.BE57D52
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 63D324001B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I+bc+CII;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQ9afrGeblbRrHz7qzJG86JE5X9fHIQg3/CX2+ca3RQ=;
	b=f1jm83On86qKYARH+QbcrZrkMu6UbAsMO4GdKbFs1eN8/irM7VE0BxG2gt55umjQ0uu6gZ
	Hb7Bq40zI53A23JUx8Zyzoqfeee3HC1rKciANhY4d2o3YMgOTrGhQ3WIwnA2qwmyx2lKvg
	WebCzWThnDkNBrTnXVSOqwI/q4HbDn0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389079;
	b=pMH+/tYRPy75zTsDD+a83MSNehBmGd6515tICTx1UfR60S3O0BhYQTPayvkTqkkR23KKA1
	vbHmuofmX2XALh+cZDQqiPmvv/5CWkNkuCEs10fNiavGD8Wso0HghyJ+Ecr2EJ4ejzql+v
	HCW/hDHqC6HZYgN38kg7N4A90D0dkdE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I+bc+CII;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9WXF5SfkPGIzLBw1Y4CC+Epd6KLA6VeaEGUz3MVaYfc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389078; v=1; x=1789993878;
 b=I+bc+CIIOmoLhHSDqxqajR21J1BpzQ1rEwFoAsC6RfZhPblFk9rXgPkOKWNs5naVzcDLjEa7
 fsZHcGW8XVYAa9umoE197PRNT/sXuSJByFW/4XCfW/l2pNshpRs+Vlgq6T275i4kUHtUkU3LQqx
 guUK7gr5EcjQhk2dIs4zF3Go=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 60a161468f8d634e;
	Mon, 14 Sep 2026 12:31:17 +0000
X-Mizu-Trace-ID: 60a161468f8d634e
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
Subject: [RESEND v7 09/29] mm/debug_vm_pgtable: test PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:59 -0700
Message-ID: <20260914122950.3283997-10-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63D324001B
X-Stat-Signature: gcjceisjarpztdttg489pidmmfewbone
X-HE-Tag: 1789389079-625097
X-HE-Meta: U2FsdGVkX19Cq/OH2IF2U7fXYnfoKk6JibHFS5lx1+K5i6nYJZnBI1q1vfHOuTvRrlqN3ZpnuJwM1ZJMXR62QDKYIpkJ7DnVTmQlNSL2xZ3JGqdy572bJDJdmbVSzOFw/jZx1SpWsQv6GexpretHLlqj130MQDCfpn++Lg4I/fFsdzLwe4nhtr8if25RORsdSf1zxLbb3juy5zm5xriNMaq8Sk9kEyPMYCwvKA81sTMaUfFxcIxZdaoJEh23np9OcvWSu71WzoRjD4bCnaIOKQKJgiLweoPFcLMp7O9QoagmKiymzZdSBELVehhHcbIIAzcWNvSfSuJqDamiYb/0tYFaKGI5314j2VAY50gMDlbl5LLB8UvY6pIzmp+kcZVm6FpCPNJYxlkzC2Gw/VBsfodQhaO2NoqwPwit1jfuPc6A7X9NpzRYk+rAL9pEgmg9HyCocqdlEIctb0lmIdiGyZ7fkHmL+vFvb92y2GFoH5uxorznAi7yCCGC2tRLGMLwKubWb83jU3BKFQUCL2s3hm/JZBRNepIBad8q1atxj7TFa+6cQzAThG1eJQd1mvBstFeJG3lhvahUuyrAIId0/lpgMnbpmDM+smNGxW8KNtOSNPJFM6Z0ymQeWlkgT+ae4WA8Kr0yQ4lbVv+gg8iN2qEwQgXtnznWA+3ATeNoouNWarRBACta9cFgEPFcf++uuthq5QcydguxmhW9r4R4wqxFqShTyrB+FvlJjW2pcrqiQdPtf0uzcjSWJFbEhB7urTs9/W+cUIANsTv8aY7AlD7xi3OazGl5w+kFgD966qXdaCWct4nqwFhdaQKNdWhCK2E+Z5nR7bHDdTmlKQz5X1JSpipMAjxqLWVwy0SRpP63WJbr7Z/TxUIs3knb8OSAvKDHQ8HYPGSg6JccjJO7ZoVmQzROpub+XCG0eq8N0lYQO3OB4AfUj05kAJU1T/wuIN9vsPrejTGqQ6QCav7
 ZZWw8L3U
 r4X5GG9N/PT6CEeWkBqQNVy+VMm3Gn0PUHsMm3BEmHaUjyOuZ/vvY7JQY1KeThQpVL6NknqbYKc/4bFVWxHbgRc1qfStH0/YD5ze9IjHiDHx9gEj0len3TQiU/meN2i0xi7EBlipXctXG7qgBIqgP7LMGIhVGsINhygcxwpuhTvU/gLbXJFXI1VdcZk1xlEnoUbN//QIEBbtbvwmy7U09Fyg/0Sds8oP+VB8IV+89qtOJcyWBhEv5lLRzlT9JuJk11l8WsSDikgcYVlqdzwJ00LVQxX6dcecVwNzu9Vp/ZohV2UM=
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


