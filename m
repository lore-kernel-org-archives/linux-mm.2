Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D41E0C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A1D6B008C; Wed, 29 Jul 2026 12:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2A36B0093; Wed, 29 Jul 2026 12:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491776B0095; Wed, 29 Jul 2026 12:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12FE76B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:31:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4C7CA0757
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:31:53 +0000 (UTC)
X-FDA: 85042355706.03.B685E7C
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC08520009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:31:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ApwamvE5;
	spf=pass (imf13.hostedemail.com: domain of 39ipqagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=39ipqagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785342711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mKBWk7rMjo7Xb5Ef81dPQ400kcrxUsMUdTBRgElPKBE=;
	b=bN1iLBeMDFoZGEZSFTLBshl7fmNbw9ksjAAzJUyYgUxRlwJu6hSKQwEgJwoUL8BOmjjFLh
	N/LNOhEQPDoAxRDJn/h9et94/qQICiTc9f1mU+BitRQq42O5GHxohWoGx9Wz7OAUgKW7/F
	7j1HRuGIb4Z5dHsLtqChXHCXyiIGYg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785342711;
	b=O8rxj//4wAjx/DWW27blShfvVmLYeD2KVfNyle/NujbiucCqAIuh/ryb2SkGmclt3h4VdQ
	Jm7oTo+uifMolLB4ke/bRZaoAzZUUgD/v9xlNPdtKSVBMpTeJcouyKZUAK3vZUkpN6AHzO
	CoIw75XHU7su+XWSbL87LvZ2Xgocoo0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ApwamvE5;
	spf=pass (imf13.hostedemail.com: domain of 39ipqagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=39ipqagsKCE895B8rC6r4urx55x2v.t532z4BE-331Crt1.58x@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8488ac68185so2732905b3a.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785342711; x=1785947511; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mKBWk7rMjo7Xb5Ef81dPQ400kcrxUsMUdTBRgElPKBE=;
        b=ApwamvE5o47+edDtqr1NbBUaIbA7xc6Mik/A/a/s88mF9FFvZGaCxHCe455wEoNUI7
         LqHQzfdsO2aOQsVeirQIv2NtUyobz9266r8q44OUwp2P/x7So9VwV0TQn3Wfh2DdvsLf
         kBRH372B4x2gu6JmGWMV+0/fO9vZ0kkRHROcD/efNuA3RH+QPNsf6ZbG+BB0CiCo3Hc0
         unoAFbovKnSJXRauEYnIiGZhw+jqlo5hBQAuX4A/1aKtgxHld1KzfidnsLu3VJX32v/D
         1PqltZoBOk4+AfqJyI0GkPoA5ODQFVlRx6XJaq6s8kznuJkDc7V5rCmdEuHIlOafSNxo
         Pysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785342711; x=1785947511;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKBWk7rMjo7Xb5Ef81dPQ400kcrxUsMUdTBRgElPKBE=;
        b=Em+NjPbr8ssVdUQ248050sg5+QaAGcleD+u0WMM17okN050Qithu/QM63zEb6uHJ3Z
         mDHA7m6YxlPZhGudh+hSgVt77M4qeF2l6Lp3KbaF4ANYCW+BRMtLhK1ocYBUJQvK6gTF
         OhKe/pFCKzrimtV9KN03cyXwk2QUmtgKNG824nzYM1OCgsdZkIi1bpihQVBCXN4pptxT
         WY4d824mDVcG0HODAo6r0dBLWAwdFCZkPeA9s3kd+Z8n1lxDszg2IwAJL+my07uaF3yo
         VeHtQpoKikAU8xl3AuBrcFWr7tqAXyn0og8etTdpHH+X0lweHEeOp8USdCWEw2EdnLkX
         2V5w==
X-Forwarded-Encrypted: i=1; AHgh+Rpkx/RJcyAY6gd5L6ZSNsTEJeakCYihHqZGMdNmh8SKu4PsMTQ+vhUZ+V1BnxPoZ1dC+wKsZmx7+g==@kvack.org
X-Gm-Message-State: AOJu0YyrQkHJQZ10GYAxHDOwZs2XRH6dMDTpR+CcJr6OxSbwOLS43bxN
	NRhVWIclBz68PMQmQoZVKvzAa6zB91h77pskczeG0xU3nCP71ntN6jtsOnv5XZAlVee/y/NypPR
	zL4z9xayMVwjPxRpyguIerYpYfg==
X-Received: from pgmp19.prod.google.com ([2002:a63:1e53:0:b0:ca1:40df:1c8a])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:84e:b0:848:2f84:f427 with SMTP id d2e1a72fcca58-84e93338b86mr7855046b3a.64.1785342710351;
 Wed, 29 Jul 2026 09:31:50 -0700 (PDT)
Date: Wed, 29 Jul 2026 16:31:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260729163148.3271755-1-souravpanda@google.com>
Subject: [PATCH v3] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, usama.arif@linux.dev, surenb@google.com, fvdl@google.com, 
	gthelen@google.com, rientjes@google.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EC08520009
X-Stat-Signature: 3neckh5xs5bxtjes9cqk8qihz1qex4sj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785342711-59913
X-HE-Meta: U2FsdGVkX18Vr6o8SEu+LbQPyy3YowmEcwVWuMASEc4DBFF8mircjYEmPPsMqCGbHRE7WXAc7+ZUyZmveduY9PmV6wukmYcBLF3mkMeRfbsuwXtJHR+hCzLEQtY4lEEkX2yukL1zyCCUkl7wtfIR92CZXdwX4jad42UFu3dqXcdAZ1FsDDSIJj1mkMmrVX+4pFRrQ7hIQZ509Lyk41Lq43Bl3QchiJmSQAZPtQOo0tQ+RuVFRoNEh15IUwIlyGTeTNjYBtftVnU1TWS1xIofvWv6ZWY2tgp0IxcDbV5wKDU1uh0Df9zDIQZvoRIz8QNRPvTTW/0BX7Dq+Ols+bWjGUHTiwa3mrc7wcNieno4o1CDhjIc100x2pawYWK5wEzrAt8eBDPbpbgjPx6CzGpQ0DeeeT8W7AOfgNTmkA8qApnK3dOoh8Qy1bztPbZPCoG0Ol6sp1wihi275/gS1+R+Vh1SQBusx/f57jVRIK20NuWaAFCED9AqIszQPgDD9ogOEEfL/WPCI2mSBEcOhEThPqh02weDt9q+Ro0FBkPQ0ZqmnL/hSxj0LLicsPjgqYwycPk4cVppF6QR65tDCh/faP9wyqkdhOS2fHe/iQ2z8AWBQ8EMdv0ysFAIz2Ag4XJ+Tat2KjvJ21Nvte4LQhth3m1Kfoj0MEKr2M1uTWp8qQBZ6bMCYdPq53aH8cF+nWhxwy2PxBFwpVPN260vq2aAgkX6+HBtzl54i+ygx6B2Aw556IwYMLsEC6lI4AfLcvAWgPmYeCSXX+C6k76tlsx2HopDoE+4mF4TRvjZCzrmTdfgegvgOhFVVD3hYc9O3ch+C+2EkP+/IY2hlVRsrWNco2cvzO2whV+483oVXJDfs4k5nLS0Sx65Kcd5sYvvfBJGZcYG77Tl54BGdGvxc6zSr9tAuICkWF4NM7BwojJAEUcHmPV09o3XeqcTQ7QSiFJRT7/mb1WbMpVL85jNj7Y
 e/sEb+1A
 PtngDso5mER0pJKEisjt6bxCreEUrai6CDn9dIlSzkXbNXZzwU/V7c/zcyaaAF1L4g3VvEdUqW7jfsR8hupaKyxcsbel4gmnCvL+lB0B3JFXL7cBnJjTIKslJrNolHPPNMlSHNo6Pr5D0bbGYu6qWexhRrfdentOktM87ZqhY60UI38E4m/GJAcXHhsWE2sgcZiArzqnpMNkOfqAq1UqU1WEmBCeo/I1Qqz2SOkBrv/rXx0aiqsVrFxF+82b9427ZRXkgQT2ErC0llnO4BomsKSinsnQg/uJ+gxth3fDBsVI2c+nfSTcXiUEqCQqZeDM7ZyW3QT1dxQvUVT3zQf3i1eYdqAIPAQZzkGnEwtlQBDHbVbwX3J7y7UdHiZL0dKxVRRVOS0F3jLWD06XTGLdt6Zjro8W4prDqJVNbJd7ftlEqqbuXaX9xK3/1XnTHpKJfi/W3p6wYt+09CqDhcr3vbJfvnW5xgMpE+pxDxeL/6yO2zD+AoyNtI4yw6Zyjhoe3djm3Fl3wk+SMlhUlGsYd+ysTP6jSTje5gdmT3fMOrGY5Bm3azatP/YbgatX8SlVXuPh8wAQBsOjaP+dN0tFvz7mN58LZL5fW6kUu3YpiLjPSg7Y5nCJ1ksX/oYeauU/L1a5duuktSbcAzhU1hG6e5yiniL32uMjsN60r5sXSCCqx0w3zwiFnfF9Usg==
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
Link: https://lore.kernel.org/linux-mm/20260628190155.3655895-1-souravpanda@google.com/ [v2]
Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]

v3:
- Enhance pr_info logs to explicitly show percentage-derived sizes per Andrew Morton's suggestions.
- Explicitly align percentage-derived sizes down to the gigantic page size to prevent allocation failures (Usama Arif).

  .../admin-guide/kernel-parameters.txt         |   7 +-
 mm/hugetlb_cma.c                              | 126 ++++++++++++++++--
 2 files changed, 123 insertions(+), 10 deletions(-)

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
index 7693ccefd0c6..99d05eb82abc 100644
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
@@ -100,14 +125,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 			break;
 
 		if (s[count] == ':') {
+			char *next;
+
 			if (tmp >= MAX_NUMNODES)
 				break;
 			nid = array_index_nospec(tmp, MAX_NUMNODES);
 
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
@@ -118,7 +157,28 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
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
@@ -144,8 +204,36 @@ void __init hugetlb_cma_reserve(void)
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
 
@@ -163,6 +251,20 @@ void __init hugetlb_cma_reserve(void)
 	 */
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
 
+	if (hugetlb_cma_percent) {
+		hugetlb_cma_size = ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << order);
+	} else if (has_node_specific_param) {
+		hugetlb_cma_size = 0;
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				hugetlb_cma_size_in_node[nid] =
+					ALIGN_DOWN(hugetlb_cma_size_in_node[nid],
+						   PAGE_SIZE << order);
+			}
+			hugetlb_cma_size += hugetlb_cma_size_in_node[nid];
+		}
+	}
+
 	hugetlb_bootmem_set_nodes();
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
@@ -205,8 +307,12 @@ void __init hugetlb_cma_reserve(void)
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
@@ -241,8 +347,12 @@ void __init hugetlb_cma_reserve(void)
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
2.55.0.rc0.799.gd6f94ed593-goog


