Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B42DBCDE00E
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 21:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75ADD6B009B; Thu, 25 Jun 2026 17:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70CFD6B009D; Thu, 25 Jun 2026 17:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB4F6B009E; Thu, 25 Jun 2026 17:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 211516B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:59:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C2E8402E1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:59:05 +0000 (UTC)
X-FDA: 84919801050.05.310698C
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 934544000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:59:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OdHe15fi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3pqQ9agsKCD8tpvsbwqboebhpphmf.dpnmjovy-nnlwbdl.psh@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3pqQ9agsKCD8tpvsbwqboebhpphmf.dpnmjovy-nnlwbdl.psh@flex--souravpanda.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782424743;
	b=s7U7JMmXZPxfwrbu/mbqwz4+6zEzz0Sq1BuAr8E6zpFe+YluX2jy7c+IrqM9MtHKxQ5ikp
	azM4mOc4hs+PhxvVk4tf3LGGggwIcs3XkszF9R8yTjOHHsE/hGKtFVb9eqUvShm+pTC23T
	BBesIaxjYm85hekVkeXYbrnkqfQThdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782424743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d2PbcE6YHaWKPSTOJuBDMS6/xM75stA7GMJ8h7+fVys=;
	b=dhwYM+XduMKU9JlvwYCSW1wtEXGf5kkNoJXe0+HcFUO0+V7D84RKneZfCVv8SSlaPNQZQy
	yva7Nt5vhj1D0S5+JrIaA/4r9NHlazX9yajTGbbiO2mjCj8rduT0RVhpR9/EE1euODq9aT
	QJG8FQ48Us+IxzGwiDPL5Wn2TH8zqsk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OdHe15fi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3pqQ9agsKCD8tpvsbwqboebhpphmf.dpnmjovy-nnlwbdl.psh@flex--souravpanda.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3pqQ9agsKCD8tpvsbwqboebhpphmf.dpnmjovy-nnlwbdl.psh@flex--souravpanda.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-84531eaf8a8so308993b3a.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782424742; x=1783029542; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d2PbcE6YHaWKPSTOJuBDMS6/xM75stA7GMJ8h7+fVys=;
        b=OdHe15fit5I4OsQGeRuiJC/xdtfJIbvDDziLl+ydwoI8S0/bp6xN4OxiwGYoB7hqHH
         ltH8D6a06X5G2SGzlwuBVb/MsExjoDwKjL5H3Oxj7TExJSRUYc/f7sej+1dUSgM3Fl+Q
         qtdH3J5ZvUkRU9iTg3mBq7vuQvUtZaRy/5mNkkV6SWClcyVg6klvT4qy8xw5tUaYpgxx
         C9ZrEXIMMBOiaFSi+pXL33jODUWDx+XqHj2myZe00zvMDbFlEgMznsvd/A11VRf1HB5X
         E3J7n1LTcFmruM3X8ZOUUwAAv2rPkEx+qDhzUmQF1PKZcIhx9+6WVkVtWobM4xj4YaGo
         +6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782424742; x=1783029542;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2PbcE6YHaWKPSTOJuBDMS6/xM75stA7GMJ8h7+fVys=;
        b=fxtgOdT1VKohyOZifNxJOSx0qzy+VwY86IvvZVKmhhiQ8WEjdUjTc7In8KhdmoiOh/
         hebL7WooDDeIjrVAIS6OSi+PHUxM56gAfMlYpft++4GIugR1aHzph/bUH5pe1lnEw0kN
         kiBwTg2Lb5bwRqruOUkg9cAuAaRGEtD8QjipAILsdS/u/ErFF3Os2nbHVCUBT5/9sZcr
         CLH1gly2HmCq9fBzcwKYDvgmxtbfpgALh7Jp7lckAdqGj0llUXfV8+NWbBEtXaGfibzM
         A+KlZpoEeWKEFpR2GBibFef6UYKOKDyt8ZSHRohu8D2b+zt45D1YaMcF82TnCDOfdLK4
         mD+A==
X-Forwarded-Encrypted: i=1; AFNElJ/T12wGGkweFxtoHB4QyxFcHg1gCD0jeZJcnH8t2ZYEFsBrT6330kywI2Aehmx9nVJA0/Ur8AgE1Q==@kvack.org
X-Gm-Message-State: AOJu0Yxzb0rEj+hQ+l/RncpDowMy2IkkU6iodIYH0RG81IESvDq0vqsB
	1pfE+JMsPtXyePbhWax/S3mBl6dRmIWV4EHIQuhhcO515h3xOtPQre0JxF5FiY4p5KxixS9Vyh4
	vw3IevTCc4Bo3SWy0Ee39tDLvfw==
X-Received: from pfwz36.prod.google.com ([2002:a05:6a00:1da4:b0:845:aa6d:92ea])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2989:b0:842:708f:39a0 with SMTP id d2e1a72fcca58-845b39e15ecmr4983540b3a.8.1782424742033;
 Thu, 25 Jun 2026 14:59:02 -0700 (PDT)
Date: Thu, 25 Jun 2026 21:59:00 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260625215900.2151690-1-souravpanda@google.com>
Subject: [PATCH v1] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 934544000B
X-Rspam-User: 
X-Stat-Signature: zx33a7bcybq45fqoobffm593sdmcyzjk
X-HE-Tag: 1782424743-145384
X-HE-Meta: U2FsdGVkX1/nwGAL5cCdA8oA4yAaVPieb9AYqu4G0lMXPmDvStEl6T2WIH9+FBJdGx06faT0c8hbpa1InQbKzPRcVvPr5A6/U7SGC/uNfIRAu5vNK8cLSuTWHs2E/JaS8EFiVt1RdjQWM4vqXg+TkQmp9k1PKYBr3ROkpwc+Ce1zyIOK75iMtBKuYqzwrwThmpYthdp2e4ZSaqJEXOwFEFY3uC3kCow0MXhpfXxSXie6v5lAZeX2DGGqr7YUOWvh02l7hBzFlsYjfvQoBvX6SIvIMVTFIpghxh9l0NLh8j4QCR1WjIRYqWw1/ugggq4FDFgOpvPqMkEV4H6/9+TM/OCMFNMQv4WKXqLXBHBCinXB5L+pNZt5Y6FNWxl4H5T+qnCqECm6skWYmFOExqU1FJFqBqA2g6aBHlfq8foBnOXf+DUAKSh5dIGoIROsV2536hAEFOgwPTJ3RSF6i4hdUkPfSUNM1qjF6c608AfghVOhVkTFOmEi7L0XZuCN5bqDIJQtcl7dSfK50UirsR0KU1xDPxNwTOGrpO9Zs1FkTT3l+TV0FHTD1/siVqHBlBk4eSYgJ/neATGt6TPu9pKprVa0GV+dIRXeXZ59YtIbY7I27V7Vz4f1iBYWChzpYfwGJFIxcjrX9Xmnx0KuMalWLKmsWPt9g78nypzWz+pbWCe/M1XoRYX27QWxe5qeSrcxfgBVvHvA+7wSlexUxPcztvQh/t7TXmRFjKZsq5Gj+T57HZYulAYxIMwnpkRmd9q84JzVex5INKHR+slqd3vdVN3yzgcs1/wpJDibQtyWY9vHrVw+7kPBIOjghBaP3tHJR9TcMy20uZz5vtaPYdUjUWJfYm22x1Jy4X+pKHO2tZlbmmjGcnUkwwejJABdefLHJJt/ROQ6GFT/4PptYWpa4roxkR3b6hUoXHpM0ZGqK1Q25YJdwcQqPsIZAUnG2S+dE6PM4n49IaRmvOU0QQv
 N93u4Fba
 COnqe2D+s7R3d0tnuwuVREp+wmdDDyesL7u4w0tS1Jej6TDXQZ83N7tAKvGApuamo9Gq7WvHlru2Rhq9Ev4DSGOZ2eFaSl8BpeL89DX35rXDnSC8ifCKyq1WY1SRZl9zQEJqEQiPk5iWX8XMbMhNXHXQBBrM1qll6jStgNClOrr3MnxXVPfyWMqtJeSk2J5rDBA3S/idG++lbdSnzqRpvIJ86l75cX3Jmf24Jht/q4lQ/R6jHxz9ruGFPLBJMyf4WIGKlcuKRjjP5q2cK66HZCdEEHMriLPrHyWTLIvK6H3VKZjZ8n9hFeSbg/eflvzBy0I0WNf1iXLcPS0kAV1h+U/+9kPEsg9lGRxvrMzQvlWkd1q9E8F1aOmQMqPs4IEFIGvSqBDU+70G9jqrUhLswjgcVJBn67qfjFgydyPA95q8YSBluUp1euZIgNNEtL00eh1Sx6zwXjLMbZ39/S2hMOBA2R9podomgM+YTrbEgRuZdbbwHqNbd49xqxd7pKgOM9vMRnnFi7nWsxUMlLIFVBhP4Ee+k3PQS3+C0NcLDDOnW0622spL26CmrAiCHZuduiNK0gyQqVNqSPTEFmz0q9yiBpvhCG1joXNUAJmlbHE7QYOl0oy+3ZORmbgMV4XslS1gz
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
 .../admin-guide/kernel-parameters.txt         |  7 +-
 mm/hugetlb_cma.c                              | 81 ++++++++++++++++++-
 2 files changed, 82 insertions(+), 6 deletions(-)

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
index 7693ccefd0c6..b4f8bbe4c62d 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -9,6 +9,8 @@
 #include <asm/setup.h>
 
 #include <linux/hugetlb.h>
+#include <linux/memblock.h>
+#include <linux/math.h>
 #include "internal.h"
 #include "hugetlb_cma.h"
 
@@ -18,6 +20,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
+static unsigned int hugetlb_cma_percent __initdata;
+static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
+
+#ifdef CONFIG_NUMA
+static unsigned long __init memblock_node_memory_size(int nid)
+{
+	struct memblock_region *reg;
+	unsigned long size = 0;
+
+	for_each_mem_region(reg) {
+		if (reg->nid == nid)
+			size += reg->size;
+	}
+	return size;
+}
+#else
+static unsigned long __init memblock_node_memory_size(int nid)
+{
+	return memblock_phys_mem_size();
+}
+#endif
+
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
@@ -100,14 +124,27 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
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
+				s = next + 1;
+			} else {
+				hugetlb_cma_size_in_node[nid] = tmp;
+				hugetlb_cma_size += tmp;
+				s = next;
+			}
 
 			/*
 			 * Skip the separator if have one, otherwise
@@ -118,7 +155,17 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 			else
 				break;
 		} else {
-			hugetlb_cma_size = memparse(p, &p);
+			char *next;
+
+			tmp = memparse(p, &next);
+			if (*next == '%') {
+				if (tmp > 100)
+					pr_warn("hugetlb_cma: invalid percentage %lu\n", tmp);
+				else
+					hugetlb_cma_percent = tmp;
+			} else {
+				hugetlb_cma_size = tmp;
+			}
 			break;
 		}
 	}
@@ -144,8 +191,34 @@ void __init hugetlb_cma_reserve(void)
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
+		for (nid = 0; nid < MAX_NUMNODES; nid++) {
+			if (hugetlb_cma_percent_in_node[nid]) {
+				unsigned long node_gfp_mem = memblock_node_memory_size(nid);
+				unsigned long s;
+
+				s = mult_frac(node_gfp_mem,
+					      hugetlb_cma_percent_in_node[nid],
+					      100);
+
+				hugetlb_cma_size_in_node[nid] = s;
+				hugetlb_cma_size += s;
+			}
+		}
+	} else if (hugetlb_cma_percent) {
+		hugetlb_cma_size = mult_frac(memblock_phys_mem_size(), hugetlb_cma_percent, 100);
+	}
+
 	if (!hugetlb_cma_size)
 		return;
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog


