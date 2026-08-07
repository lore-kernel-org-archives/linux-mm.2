Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B660C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 04:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77236B0088; Fri,  7 Aug 2026 00:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E282B6B008A; Fri,  7 Aug 2026 00:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EEF6B0092; Fri,  7 Aug 2026 00:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB406B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:00:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02092A1687
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:00:07 +0000 (UTC)
X-FDA: 85073120496.17.E334B7F
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf13.hostedemail.com (Postfix) with ESMTP id 513062000D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:00:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U/mSdoaY";
	spf=pass (imf13.hostedemail.com: domain of 3RFh1agsKCCUTPVSBWQBOEBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--souravpanda.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3RFh1agsKCCUTPVSBWQBOEBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786075206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vtTQetELCW0NUYuImjfKHiXf/lqR62/Atju4/hLtEqA=;
	b=Z5wNf04R7JZyFt0B0MGbyLJvT2Xibrr77+BUARQ8yVwA2w3Ow+I4Ik26xvBUdTCgz+jscM
	eEeA+FdZNMFkd2PMqx5+8+VylbdItuDe2LY6wKnefvjiSWH0vZyKHzU69JTfTLAjwZZIWb
	A/Jq03Og0Wiy4qeXEKgazO7V6OmZckg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786075206;
	b=VWIH06X1EAQgokKD970puZSlpZSZ9oSFD7qobXsDz8ExNtB4ZHVGjF+qMYd7GXoCDbEDkl
	lkEiaJebokUkUOp9wTTe2pTiLqgC9t1RgrIVnK/nIjqnOcCRz5c/i4NKXNn/OBjrNSMPhe
	enFOOA5SmUNQEhi8rZ5U7Ij6S+fXkJA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="U/mSdoaY";
	spf=pass (imf13.hostedemail.com: domain of 3RFh1agsKCCUTPVSBWQBOEBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--souravpanda.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3RFh1agsKCCUTPVSBWQBOEBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so3698247a91.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 21:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786075205; x=1786680005; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vtTQetELCW0NUYuImjfKHiXf/lqR62/Atju4/hLtEqA=;
        b=U/mSdoaYAYDEA+Ui43qqwTzY3Cvv1XKdEoOf7WHB1bVOk2lrNl+ciSbnjxharJjrZH
         P2XnjTEVH2axl3IvkuCVXlINsVVOzOKPERfqcBA9j06Ua3/GAKEj6p2jp6VoZzFjrA4m
         w2jJjCWzabN/bCN7vpXl8+rIACo5FZ7XsOQN9IfY0jb/u0Ig1k/TkFHhufW7VZfAlUet
         8LBgf8ZnM5yS38RK/KqkNixfOdqE3x7f4hM2x4yn62js4YIH2XEmX/OUKlks/A8un4a0
         2Yz8gmPqUQOO05W10gDtok0ppK4kCIsmVaFH8VP3ovc0gAfxXrpYQIlKM+EB5e9yRcw1
         9I6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786075205; x=1786680005;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vtTQetELCW0NUYuImjfKHiXf/lqR62/Atju4/hLtEqA=;
        b=Qhxscim0JVzUdBqJt65LRw0zLS4rNMmRIXYh18tNAnumBeJuZ58oBP9J80EjDTJ7lb
         ZrkhwRQoVhB9GWvlK0qjTXo531fHl6+cAHJ+GcAumxFcJVjQNWQGX5Nklzn6MoC5IOl6
         FPw8fxr+z+lfDznmnF7n4TiIr757MGd/5sJPaIZRT9bdww1NdvGcugU9RzfxzDLcX5Po
         vfX55wGsrTbrK6OssgkGlOwb20TIODroh6xdcXw0osFUe7c0Wo7VDNsXHBYNElVFaOze
         ZftfXVyJ1QrrzsMqX/tc3UuLfe8cUU+QPNjTSnP7HTtVZHxuX0OIdpZf94QEMw0EVxG6
         FfXQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsGMQiYTpjNNBc8VFY6g0RLNiy4KydiaB5VH87YyLvESjsYwmsmcPCkcDBF/QTMpT1HMVuNuBFdA==@kvack.org
X-Gm-Message-State: AOJu0YzUofNKHfazFXvoGDORmhBkQ3uD/tfHvdWaLeuW2Vr+xC/4SkOV
	rTU7D4Ua97uGesN/UkouQ55KvG9Vwp/mks44vBb8uhvb/HcRASviTysGk6nr5T2qwA6cHu4klpR
	SaPYYCcyTe8gYBHtH6Ug2SwpnaA==
X-Received: from pjxx4.prod.google.com ([2002:a17:90b:58c4:b0:37d:f041:9678])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d64f:b0:38f:caa2:5721 with SMTP id 98e67ed59e1d1-3903c5dc500mr20296068a91.17.1786075204667;
 Thu, 06 Aug 2026 21:00:04 -0700 (PDT)
Date: Fri,  7 Aug 2026 04:00:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260807040003.2156630-1-souravpanda@google.com>
Subject: [PATCH v5] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, usama.arif@linux.dev, surenb@google.com, fvdl@google.com, 
	gthelen@google.com, rientjes@google.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 513062000D
X-Rspam-User: 
X-Stat-Signature: hmh6hkccmd9qphgqmxbipbqzc4xrd4sp
X-HE-Tag: 1786075206-892452
X-HE-Meta: U2FsdGVkX1/lGUY3j+I/d+z/rtx4vzG0GFL83kmJnjPuT/wisXzXFy7yODX9Ci+oAfuln/WmPVGjQ0KGEsypIE1ARkespcPHOMavMLarjGG9zBjTFHHo/niQ+nJF53hpCLOk7mPYoqGgp3Ps5mgxotgOGUQ/TQ7v5CSvRCScukXXZpVm+RCJasaG6i+9X1WzOs3s5IcYa+eU4XLUFOR3ED5nMiniywFDZ04EmMCNPopBTYo7PPwEN8wn0E24AuK10x4UCdJu4pzwk+7Lhg3oBMExr/h3VDtmGShYodXrnvh1fcnZPjmmlOfWm1iXI/og4Cl13EX9UxcBg1/QWArLAWP6lcLNPQ1xI3TOh6wQyge+VmK2lulGw79QbTfOi5EOwmFo1KfQaq83MQB/dC9S0xBuow6p1qIJse8Z4YG323hMQ6tJ5ZkHf4pcDQsdP1MNCb43+wu/TlftLDUu4dAZ1/5EmddwZV8VGSLoqBLlLXAVs81gC01UFVi2khGbvgbsPrbnbXn43px5bkx97KYK2F6VNUFC/WO33Y0o+kO3Fj6vAn0moyKNofUSVxvJHfMSnTfIVSlUX7Zt1Luxkqvj0D3Vs4LkYXBPUlRTak85UOaQRQ4xSMVhMOPxz/KyL28BReLnbN6PbjMTMDZ6FdipewbOdWu3HpTu01nRoxsRvCSTPrwO1Qx2f9WYDoYS32IFQVlOv4QlIg6PlHyjvH1YlpVYOunJh3Di9ueudV5rkGEd5axxAY2YcHTYWUyzus2NrdnpVCyij2AdUCAL6diiVJKLZtVKaxrqBV7UBRE2jz1qyai6uxSq5w9KJhq//kyWc5DbtZuVx4H9rXbEucqeBRtHms3TLJAekzLMV4lLVIDcb9wVHL/GS0/Oln1E+AWGrr5hoCeK9QGUj+4IFDx8s0fGzOJdYQWxDrs/4WlAkRGvvO03SO1ccpufVvb6LwHUIr8Ug/d41T20X3aL7Bg
 NJggcidx
 ovWnM4eBa01ygk72GP6UCzxJ+tFf+StXNAcmp2OCjEdLzT6HZLdXow8E09LHCIh99phNWDRqVhJQBMcPqAI3IJC8luDNYhohyGOvpSrZHRRi9WEROZdef3r+ivaQVwh9rRBv1ZiKBjAK6IkYxr/OoZGu8i+EkWsRuEpS3n+4O5KHtU7vLndPusMNpZRjaj6OwYZJYzTiyQdmmnAq34pNtaP9uXCWPF56Fxcww/bcmMWkhl3f85FVzlJJyCnyLR5C5Nk7t8t8Y97McsFGoeNxgNPjTmjD6UeCZPzvD+qNcQrIvVM91cb/G29pCdT12kgE57VbA5wryphYPiKCNvMbI2/792WvK+n8QIAWr7kctMKTU2IBjI4atySkt4booD8GFr19HCYwgV/TMa/xjZbQlk0WMOBv7hf6pKYWzltwX0rwfiVEBEmCfzZceMx8peecz7Wg7LQxikkOrwpcsHzgefkqF4u+uk5piDOxBcOsJnlsnaokUPQPnyLtxanINnRkY4GhYibfM4luCRVznphuJoVdZhKEZdF8oJqUjTIxlCvYAmCE4vPAfgb/nxBXJD4arfR+zlrL8Y/N36n2tbRVqGHhwJHmoqXzECWw/hYdYfF8iLAcAimyO1UoXh/fHR+l2qrbGSo5CunPyGhxQImXhNmqG9IyzlqlhVIh5VsLHZgF0WM3ywBdOtmqe0A==
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
Acked-by: Usama Arif <usama.arif@linux.dev>
---
Link: https://lore.kernel.org/linux-mm/20260806085651.4068433-1-souravpanda@google.com/ [v4]
Link: https://lore.kernel.org/linux-mm/20260729163148.3271755-1-souravpanda@google.com/ [v3]
Link: https://lore.kernel.org/linux-mm/20260628190155.3655895-1-souravpanda@google.com/ [v2]
Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravpanda@google.com/ [v1]

v5:
- Document in kernel-parameters.txt that percentage-derived sizes are rounded down to a multiple of the gigantic hugepage size and may become zero (Usama Arif).
- Add Acked-by: Usama Arif <usama.arif@linux.dev>.

v4:
- Clear global hugetlb_cma_percent and hugetlb_cma_size when node-specific parameters are parsed so the last command line configuration wins (Usama Arif).
- Warn when ALIGN_DOWN rounds down a non-zero percentage-derived reservation size to 0 MiB (Usama Arif).

v3:
- Enhance pr_info logs to explicitly show percentage-derived sizes per Andrew Morton's suggestions.
- Explicitly align percentage-derived sizes down to the gigantic page size to prevent allocation failures (Usama Arif).

 .../admin-guide/kernel-parameters.txt         |  10 +-
 mm/hugetlb_cma.c                              | 141 +++++++++++++++++-
 2 files changed, 141 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5a05b48d1684..160c414e0f30 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2064,8 +2064,14 @@ Kernel parameters
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
 			of gigantic hugepages. Or using node format, the size
 			of a CMA area per node can be specified.
-			Format: nn[KMGTPE] or (node format)
-				<node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
+			The size can be an absolute value (e.g., 2G) or a
+			percentage of the total memory or node memory (e.g., 20%).
+			Percentage-derived sizes are rounded down to a multiple of
+			the architecture's gigantic hugepage size and may become
+			zero.
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
2.55.0.679.g6767b8d81c-goog


