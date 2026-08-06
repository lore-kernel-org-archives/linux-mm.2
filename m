Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F81AC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FE96B00AD; Thu,  6 Aug 2026 04:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150876B00AF; Thu,  6 Aug 2026 04:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F496B00B1; Thu,  6 Aug 2026 04:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8A0B6B00AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:56:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2236F1A06C4
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:56:56 +0000 (UTC)
X-FDA: 85070239632.26.5E30FA1
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CA70180003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:56:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VmkX/1OI";
	spf=pass (imf06.hostedemail.com: domain of 3VEx0agsKCBkHDJGzKEzC2z5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--souravpanda.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3VEx0agsKCBkHDJGzKEzC2z5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786006614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f2Kd5S4Tu7Fwb1K9owR83WOTCIf8JouRZAzl2QC9oZc=;
	b=dykCGyuB1YrrbIUUVm6HLw3wK+zKrPMlTJDqzTzEeU6lIm1Vh6IpF1nPve1JMqVCNzap/D
	lF6prt2OkUz7D6jWZVvYmsNs5dEuccUdxIqxFowR/NdILYK/FZ4AUQRp66PhUm7equABXZ
	lAcRATUThneHGCuZZ6p08cVvTU0iuUA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786006614;
	b=3j7sS+i5mPXuGAH0lzQRDeEcz9Grj+sEdKZ4G22+DA/Kh9SZ7bod8Z3exDuyhEih4H2IPv
	YIwGfEf+GBrc534yx1UFH9mWoQ8zXdE20g7VTRKP4mQUzGoB5s/QNj6PtoNOqZOsR/2r/r
	wBzl81H93FJVTLmrBWzJ1HY7r/92GMM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VmkX/1OI";
	spf=pass (imf06.hostedemail.com: domain of 3VEx0agsKCBkHDJGzKEzC2z5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--souravpanda.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3VEx0agsKCBkHDJGzKEzC2z5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e7621655eso3011122a91.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786006613; x=1786611413; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f2Kd5S4Tu7Fwb1K9owR83WOTCIf8JouRZAzl2QC9oZc=;
        b=VmkX/1OIID3GnOXr8VdXlX3IfGFQcrJvk/pz1CviBk/PY+0cY5XlSSeAqQdMrqwkKR
         vxEMXhsbzevdqg8fRFX+xobHKmen44vTOgTdHfod2jXq1qEBY7XS50IvdJZoFfZ+sJLm
         WCGRB6ThfSupZ6CIpAsrnXiVI85fkowmpE4haC4WGbPryYt0GRqzuQO2552XXZ7MazdY
         0g4Pcyculzt8uW7KbQgKb7FZQhKT96SyfyrVWrd/qlGNdy/skP8OxaBPeYg/pHAKk/gI
         Z7l1l/ltYETLPHqra+9v+kTao3OzGXG5CpeJgJvp/ln8Q7L2Rhih6zaz0hC26NBG3t44
         D4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786006613; x=1786611413;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f2Kd5S4Tu7Fwb1K9owR83WOTCIf8JouRZAzl2QC9oZc=;
        b=mvEUoWZlxQIv6mlqVXxm2LUnG+qKxvP7CS2kTG83LZ2L/iQh+EphsqZ31yTToDIsIk
         h9sBuUQQU4JeezXGmhcWbcfM41GwrIQ4khL0YIPKk4LXOg8lce95UoVdkn10hdzPRc5Z
         OCFftXHfg3KdjDX1By0AllwDWMR/MGS3+Y/rfGXqzifiQhecg01GUoin0cdK1jzgd/1O
         wTx9zCfoW65imuZk/eSwkxhSs2ufd9xnnDr5CR1KoEpjFi/71cf4H8pGmHz2nHBrD8Ha
         JZL+fanGx4k1qDHHJsaHpwDiNx9Tb1PoFIYTHzhmX+FKFzbeirRd2tRvm7h1ylaqJHmb
         1u6w==
X-Forwarded-Encrypted: i=1; AHgh+RqoC+LxoaoF3IAJMiLDY0LbDsmMAEx2pRgd+R0ONnMC2gRDptiEPRygQtpxDqjE+a6ey3ZfvfkviQ==@kvack.org
X-Gm-Message-State: AOJu0YwQIaqKiwaz/i/EvRQkM9aZoKP+1jlz9cWiuPmIEzL/Bb1yfk4/
	6VAp474viR0AEsZBe8zu+1TC2prTsavqhO92F/s7VyZfheQHO2l5ejXI1SQLBI5uSwMfaKhg/oV
	hcCyqp+KHwEtJ1cpbN9lRKqyApg==
X-Received: from pjyj17.prod.google.com ([2002:a17:90a:e611:b0:38e:3cd6:1866])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:53c5:b0:381:bc4c:da5b with SMTP id 98e67ed59e1d1-3903c61098cmr14798023a91.18.1786006612810;
 Thu, 06 Aug 2026 01:56:52 -0700 (PDT)
Date: Thu,  6 Aug 2026 08:56:51 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806085651.4068433-1-souravpanda@google.com>
Subject: [PATCH v4] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, usama.arif@linux.dev, surenb@google.com, fvdl@google.com, 
	gthelen@google.com, rientjes@google.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6CA70180003
X-Stat-Signature: jzjgm9ncfiwwspb7pjczdhym7xttq59p
X-Rspam-User: 
X-HE-Tag: 1786006614-695350
X-HE-Meta: U2FsdGVkX1/Gh7ONXfBMKonVmye+gYdCxAqsqAB0BU6EbwMaEIHU7u3wdGVa6WFIvijS8tK9iWz62oW5Mfn4Btkfa4X/dcjJpnuEunZGIZWrm0Cy8jOoBsdvHhddBxqtTB38okhVkJlNDyVhyJfIShnzT5Sy24XnFyA66oGToQqwOTgYVW5RqDzWtrfFzXKgG16Eykvk+5alGFLQku6SozpcIdojdwLC3jWkKGD/lxjsE8/UtsZesL+tJb1wdXQRGCekM4nsXhaBjsr57x/T4rv0SWNzaEysDUzqrbm1zy4F1drt0n1JFFc7GDoev4J57EZ2Sqyk5olCbGy7C3BR4SpS93EXnT2K+Vitl66qjaJnURVh8aFZDtxyJstJCBRlCOa/geELQ4nSQZ3ZNydeGpYwNLmRUxh+TY2hbOQi/UI5nHhqhvoCMvpQwoAubLVQLrKuRT5E5fCL87Vjki5/nYaG9xndEDd/0zZqWkJZDtwOwKgADRhpR79u6EjlUth+S27lXhzv2ae6Sh3AnpixYOfPreLizneMnXC2c2MiIS5q7JCY71eO5kLBOpHRqNQp2IBcEcQuTZDkx6Zl7L+2fu/3mUuOX+UDVOHTq21l9nZKO7y7KhKsJH86KHQ0lS41W2K9Y2E057LeB7+owEsWgOGoocqCG2QcFH9597m6udUTJff0jSQRPIzuXrmPSKKRl6V4WVC+1sGnwSbxtqolmVqpMNokhAISanEhYiZBMjeV9lMVPxVgStfaZCNMbdt9F5AOQNThB5Aztxx5d3/YBIMnRWh+K+o5WpXKcvQqjEnoI7tBqHlAhwrm4NatlSX1jZLXl4p0Yjv+yYgyHvnsxZoCFVh15vPgaQR6sdODnwTWp4fEbtHDMONo0lcsVjtbxr1Mem31xWJuf0pTmAuONDkd1Uo8R8aAw1QJRa6bLhyoIdRBD1TDGfGwTmn2rPWYswUbEWzQnf+7RXFXcAg
 PLLyY42T
 3M/GJ4Ty2VvBzzU7sxjBjxlkiLsgXFRQKEsyv+sGll0KjuzzoQLBJPLwGqTzEqi3LuyccrXcVsDuKiIjhe4oiyPh1irBaaDaNu6VUAYE3j/dsebj0/yFI7jlQN0pIkbec2AWN7Q5FBWkYdnsBiYMv9ZN+fSCvnVRCPVWTGyssXgaNGpCiXCxSDEcutwPhxm3bzhIS6Hq4VglTnnQztU5CzaaM9eEFpIA8BjK3sEs3Q2lhC7UsvfCHLGcbOJnx4HTTMRx/ef3LIzb3qhu0bIDu6rZV0yg1FsmO08zEsx97N/f50+Au4jrW5dBHYjfYQl+qANz914w/gnZC0R+xNd2LpBQnd81b+MK6vQ6Q92VDjYpVhL7qmEY0j6hoPj7dN99G8wl6qp9i7mE1NW8H0OpZP43+/jpiQC14mZshNJXzcvIU7d1D4MG+tw3wYvgU4fx1UC6pQwp+hkV4qX16pz+jkKWVMSbybV8UvQCG4YdDowo9ea/J97AUmrhTrXD8X5xi39gZ4JDj6L1Fzz01RspBdfRHIdQEZGTq3nU051oIwztaBz8oZ/2R1VnbVly+Stx3I4mGS0TLpo4o8oEbMhYK8Zq8rfOaJisM6aX8057jHhU0nq0D6fCnR/KSaIqkZ2DRmbmIugAKGsstEvNKw9OIBr1bx7EZQzrSfD+p8kGUWYgwpKJvmadbMjtoMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
hugetlb_cma=2G or hugetlb_cma=0:1G,1:1G). This can be restrictive in
heterogeneous environments or when deploying common kernel command lines
across machines with different memory capacities.

Add support for percentage-based hugetlb_cma reservation (e.g.,
hugetlb_cma=20% or hugetlb_cma=0:20%,1:10%).

The percentage is calculated against the total memory (for global
settings) or against the node-specific memory (for node-specific
settings) using memblock APIs during early boot.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
Link: https://lore.kernel.org/linux-mm/20260729163148.3271755-1-souravpanda@google.com/ [v3]
Link: https://lore.kernel.org/linux-mm/20260628190155.3655895-1-souravpanda@google.com/ [v2]
Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]

v4:
- Clear global hugetlb_cma_percent and hugetlb_cma_size when node-specific parameters are parsed so the last command line configuration wins (Usama Arif).
- Warn when ALIGN_DOWN rounds down a non-zero percentage-derived reservation size to 0 MiB (Usama Arif).

v3:
- Enhance pr_info logs to explicitly show percentage-derived sizes per Andrew Morton"s suggestions.
- Explicitly align percentage-derived sizes down to the gigantic page size to prevent allocation failures (Usama Arif).

 .../admin-guide/kernel-parameters.txt         |   7 +-
 mm/hugetlb_cma.c                              | 141 +++++++++++++++++-
 2 files changed, 138 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5a05b48d1684..846940ce2858 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2064,8 +2064,11 @@ Kernel parameters
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
 			of gigantic hugepages. Or using node format, the size
 			of a CMA area per node can be specified.
-			Format: nn[KMGTPE] or (node format)
-				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
+			The size can be an absolute value (e.g., 2G) or a
+			percentage of the total memory or node memory (e.g., 20%).
+			Format: nn[KMGTPE] or nn% or (node format)
+				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
+				<node>:nn%[,<node>:nn%]
 
 			Reserve a CMA area of given size and allocate gigantic
 			hugepages using the CMA allocator. If enabled, the
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..2ca014a0a3b8 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -9,6 +9,9 @@
 #include <asm/setup.h>
 
 #include <linux/hugetlb.h>
+#include <linux/memblock.h>
+#include <linux/math.h>
+#include <linux/math64.h>
 #include "internal.h"
 #include "hugetlb_cma.h"
 
@@ -18,6 +21,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
+static unsigned int hugetlb_cma_percent __initdata;
+static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
+
+#ifdef CONFIG_NUMA
+static phys_addr_t __init memblock_node_memory_size(int nid)
+{
+	struct memblock_region *reg;
+	phys_addr_t size = 0;
+
+	for_each_mem_region(reg) {
+		if (reg->nid == nid)
+			size += reg->size;
+	}
+	return size;
+}
+#else
+static phys_addr_t __init memblock_node_memory_size(int nid)
+{
+	return memblock_phys_mem_size();
+}
+#endif
+
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
@@ -100,14 +125,31 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 			break;
 
 		if (s[count] == ':') {
+			char *next;
+
 			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
+			hugetlb_cma_size = 0;
+			hugetlb_cma_percent = 0;
+
 			s += count + 1;
-			tmp = memparse(s, &s);
-			hugetlb_cma_size_in_node[nid] = tmp;
-			hugetlb_cma_size += tmp;
+			tmp = memparse(s, &next);
+			if (*next == '%') {
+				if (tmp > 100) {
+					pr_warn("hugetlb_cma: invalid percentage %lu for node %d\n",
+						tmp, nid);
+					break;
+				}
+				hugetlb_cma_percent_in_node[nid] = tmp;
+				hugetlb_cma_size_in_node[nid] = 0;
+				s = next + 1;
+			} else {
+				hugetlb_cma_size_in_node[nid] = tmp;
+				hugetlb_cma_percent_in_node[nid] = 0;
+				s = next;
+			}
 
 			/*
 			 * Skip the separator if have one, otherwise
@@ -118,7 +160,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 			else
 				break;
 		} else {
-			hugetlb_cma_size = memparse(p, &p);
+			char *next;
+
+			tmp = memparse(p, &next);
+			if (*next == '%') {
+				if (tmp > 100) {
+					pr_warn("hugetlb_cma: invalid percentage %lu\n", tmp);
+				} else {
+					hugetlb_cma_percent = tmp;
+					hugetlb_cma_size = 0;
+					for (nid = 0; nid < MAX_NUMNODES; nid++) {
+						hugetlb_cma_size_in_node[nid] = 0;
+						hugetlb_cma_percent_in_node[nid] = 0;
+					}
+				}
+			} else {
+				hugetlb_cma_size = tmp;
+				hugetlb_cma_percent = 0;
+				for (nid = 0; nid < MAX_NUMNODES; nid++) {
+					hugetlb_cma_size_in_node[nid] = 0;
+					hugetlb_cma_percent_in_node[nid] = 0;
+				}
+			}
 			break;
 		}
 	}
@@ -144,8 +207,36 @@ void __init hugetlb_cma_reserve(void)
 {
 	unsigned long size, reserved, per_node, order;
 	bool node_specific_cma_alloc = false;
+	bool has_node_specific_param = false;
 	int nid;
 
+	for (nid = 0; nid < MAX_NUMNODES; nid++) {
+		if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
+			has_node_specific_param = true;
+			break;
+		}
+	}
+
+	if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				phys_addr_t node_gfp_mem = memblock_node_memory_size(nid);
+				u64 s;
+
+				s = mul_u64_u32_div((u64)node_gfp_mem,
+						    hugetlb_cma_percent_in_node[nid],
+						    100);
+
+				hugetlb_cma_size_in_node[nid] = s;
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	} else if (hugetlb_cma_percent) {
+		hugetlb_cma_size = mul_u64_u32_div((u64)memblock_phys_mem_size(),
+						   hugetlb_cma_percent, 100);
+	}
+
 	if (!hugetlb_cma_size)
 		return;
 
@@ -163,6 +254,32 @@ void __init hugetlb_cma_reserve(void)
 	 */
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 
+	if (hugetlb_cma_percent) {
+		unsigned long orig_size = hugetlb_cma_size;
+
+		hugetlb_cma_size = ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << order);
+		if (orig_size && !hugetlb_cma_size)
+			pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%)\n",
+				orig_size / SZ_1M, hugetlb_cma_percent);
+	} else if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				unsigned long orig_size = hugetlb_cma_size_in_node[nid];
+
+				hugetlb_cma_size_in_node[nid] =
+					ALIGN_DOWN(hugetlb_cma_size_in_node[nid],
+						   PAGE_SIZE << order);
+				if (orig_size && !hugetlb_cma_size_in_node[nid])
+					pr_warn("hugetlb_cma: reservation size rounded down to 0 from %lu MiB (%u%%) on node %d\n",
+						orig_size / SZ_1M,
+						hugetlb_cma_percent_in_node[nid],
+						nid);
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	}
+
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
@@ -205,8 +322,12 @@ void __init hugetlb_cma_reserve(void)
 		per_node = DIV_ROUND_UP(hugetlb_cma_size,
 					nodes_weight(hugetlb_bootmem_nodes));
 		per_node = round_up(per_node, PAGE_SIZE << order);
-		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
-			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
+		if (hugetlb_cma_percent)
+			pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up to %lu MiB per node\n",
+				hugetlb_cma_size / SZ_1M, hugetlb_cma_percent, per_node / SZ_1M);
+		else
+			pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per node\n",
+				hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
 	}
 
 	reserved = 0;
@@ -241,8 +362,12 @@ void __init hugetlb_cma_reserve(void)
 		}
 
 		reserved += size;
-		pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
-			size / SZ_1M, nid);
+		if (hugetlb_cma_percent_in_node[nid])
+			pr_info("hugetlb_cma: reserved %lu MiB (%u%%) on node %d\n",
+				size / SZ_1M, hugetlb_cma_percent_in_node[nid], nid);
+		else
+			pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
+				size / SZ_1M, nid);
 
 		if (reserved >= hugetlb_cma_size)
 			break;
-- 
2.55.0.571.g244d577d93-goog


