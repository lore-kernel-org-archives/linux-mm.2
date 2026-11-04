Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333306083631
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aeO4DMk9
Received: by kanga.kvack.org (Postfix)
	id 91A776B05D5; Wed,  4 Nov 2026 11:50:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4966B05D6; Wed,  4 Nov 2026 11:50:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794576B05D7; Wed,  4 Nov 2026 11:50:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51E2C6B05D5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E367F16052E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:28 +0000 (UTC)
X-FDA: 85398024936.09.0421EF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E86218000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeO4DMk9;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811027;
	b=g9bXJ3bZxttmE9MJ7bbZup6pLkvS8zY7x/On8dpVXv9uVfUlqA50M3U6eU4gyYCX/rtaWM
	dyM/sjKYwLhtjcPlZwhzWlmk9No3FlOkTb8QepKoHHGNUyPQW/Sc/rBA4phqnT8jKxHTSb
	cgsVz02afuzvKPZC/IbCIlWn7FYLnKw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeO4DMk9;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6GFZTwsk8K1yLnVIeqvPcsTES79RyAO3TzYi1kGa5Q=;
	b=lYzM3u/nFuWLvo96A2lPV9CVT2Q7t4us8DBLwQlGMlLB04sir+bdP8TMQFhoJOnGrdJt/s
	AJVjXFqi3ZnGeqgIXum2Q7r3UOoY3qipSmcRocKILPdS4zGyzgSpfV5dD7iUzBXNZVOfQS
	oIOqp1YdopxMiJ5tLC+FnVMgnEOJrUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D8C241800;
	Wed,  4 Nov 2026 16:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E91D1F00A16;
	Wed,  4 Nov 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811026;
	bh=/6GFZTwsk8K1yLnVIeqvPcsTES79RyAO3TzYi1kGa5Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aeO4DMk9XPtbQT+GYd1/yOejHvlEsWQ/UgzcpfDeOQ2e2s/9kc9FreNPXKPf6weAs
	 mL7bawIeFKrOcfYYBAyq776eTEnQkA9hB5rlksBtRq1l+00FbMs1zfoXsYh1HIphSW
	 wiH84CQNK4gWj7wdN6vOBM0EDiHrViUvk9ITZfz8zGAeoCygfV8MA9+YB2kO9Tm3HS
	 RF6A5gBQbHOlC8u80oz8VcqxFnq7Y4RXFqi/FyKnFAyfjERJGTip+25X8T+qZMo0WP
	 SRIHzUDKv83T7QmVADSycLJpwAVLMf1dbr4pTsDSztmaExcMyv0rhv7ArtQBAcxwr1
	 ncfYo2Cy1vNXg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 04 Nov 2026 18:50:11 +0200
Subject: [PATCH v2 3/3] kho: fix bootmem sizing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
To: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 11whm9grx6mxrgo7wp7nkisszrkyib96
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E86218000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793811026-669134
X-HE-Meta: U2FsdGVkX1/hjMi6GwMuLaUQP2biUJqbVUTHVGWtKlOnqsQHfhmzhgtiGmR8H+4rqeWQPYX4aunYWPyDPI7OdTq9mBNmT08HJAP2uOOu5hqzceBU1d0g9SZ765qvBAa3O3MQ8y+N53a9Q8CGEtihz+CY9yOqR6i9K4eNF/igny3tiVHJ+vfW49J1y1s70TIfuTMjdGp2zskOzWEhso9j9Q+d/6mUSrpmXZfzZKp5jYPJfOjM6v+LfulHe49rcc8TnRplSuqmDJufPZdqNQqt+pr8TwEOnvtvTepVqqlyFMBASE0AXELB1NY9vJMQSjANF4H63jAHWlz60vxKIZxdhrfvlQNqlWja6r/OJJ2+k2vFlpwRY8mt9KTPbj24ScyMofKhCsMqqsoaPWdUoWgr29DCxRRE2ydDo4sb9YywrYrj2ukggXJP+A8BZ/IzRFyTFn3G9HKTBgg7hlwPoGXSKvXbPrczyLwGXqOqLFmo+7hlnmvlnRQ+0N1cIlEiVmk/smGvQm18fUOPqt/P29njqD2pExAi8G9DUdH+v6xHSrGLtHFZtK5neDyhaK/9F1JFiOoIOv0WQ8IfyG4BIznRtWfU2kR93L+ueLe5knEIQ2vMHNo9VgEld8WaBwx5ymJ4tY/m7XkKGx+m9yzcWq9TiobHjy9qN2AMzJ1tA11TXGT8PfLS6z7iKD2/vKlsXkaEsxSAEtkct/3i6exx2vRSo4c3+7vKkc3cOi4Oqm260dD2b8ThHDJE3LHwwV5FX78QS85Zz17mnG18Hea4quGbyfIzj/1PS+KDgTC34mAH21BZvSsG2ULEhyaRWIxfvcHlQng1cmiWwV4ZPD7scqqcEvnmG/pLbtoUqVtuoRo6ypvufdOEIJxOJO2PP2B+GqgnAKfn1v3PC0XxyfmixZFV4NFwyWftzZzLVF8xktKH2lJZ8IMjsUgOcH7N9KmwNypj75wRRiFrX9ToFCnVL25
 4zoluaD9
 Ez/4RglJ9es+4rYUAUlaGgKLXFszWNJYeBHQ8XnFtZ8WY+u0TRImZk/X+S+FnzjEXV+ZW/5RIjcSMuDl5uJhYRfFEJrEaX5tRUt1gP4MKd8ZXxFWyqx6/K61Zj9MJ8IxCXzlZql8FSVRs5OfQ9lWx0s53oNFB/3lKw0CP97k/utevETgVO3cGjKv6WN9gBjUrAuufOWih6fBPmJ7DjBde95i5Ia167XTvLesIZYu7m4WmzOtQvirfdFKoLzJLW417j6Amv0DB0CTk0ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Bootmem areas are sized from overlapping views of the memory reserved in
memblock:

* the global area is sized from all reserved memory, including memory
  allocated on specific nodes, so on NUMA systems everything allocated
  on a node is accounted in both the global area and the area of that
  node.
* per-node sizes are calculated after the lowmem and the global areas
  are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
  so the lowmem and the global areas are accounted in the size of node 0
  area and scaled once again.

As a result, bootmem is about twice bigger than it should be on NUMA
systems and about four times bigger with CONFIG_NUMA=n. On small systems
reservation of the bootmem may fail and then KHO gets disabled.

Make the areas cover separate parts of the reserved memory: the lowmem
area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
cover allocations above it on each node and the global area covers
allocations that are not bound to any node. Calculate all sizes before
reserving any of the areas.

With CONFIG_NUMA=n the global area becomes empty and it is not reserved.

If ARCH_LOW_ADDRESS_LIMIT covers all memory, as may happen on arm64, any
area can serve lowmem allocations, so don't reserve the lowmem area.

Bootmem sizes in MiB in x86 QEMU VMs, before -> after:

                     CONFIG_NUMA=y     CONFIG_NUMA=n
  1G,  1 node         176 ->   92       320 ->   80
  4G,  1 node         508 ->  332      1264 ->  316
  16G, 2 nodes       1268 ->  704      2944 ->  736
  32G, 4 nodes       2296 -> 1224      5196 -> 1300
  64G, 4 nodes       4344 -> 2248      9664 -> 2420

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Reported-by: Kexin Liu <liukexin@kylinos.cn>
Reported-by: George Guo <guodongtai@kylinos.cn>
Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 93 ++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 39 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5b1797d1289c8..c4b697a612f67 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -685,6 +685,7 @@ static unsigned int bootmem_scale __initdata = 200;
 static phys_addr_t bootmem_size_global __initdata;
 static phys_addr_t bootmem_size_pernode __initdata;
 static phys_addr_t bootmem_size_lowmem __initdata;
+static phys_addr_t bootmem_size_node[MAX_NUMNODES] __initdata;
 
 static int __init kho_parse_bootmem_size(char *p)
 {
@@ -754,29 +755,58 @@ static int __init kho_parse_bootmem_size(char *p)
 }
 early_param("kho_bootmem", kho_parse_bootmem_size);
 
+static phys_addr_t __init reserved_mem_size(phys_addr_t limit, int nid)
+{
+	return memblock_reserved_kern_size(limit, nid) -
+	       memblock_reserved_hugetlb_size(limit, nid);
+}
+
+static phys_addr_t __init bootmem_scale_size(phys_addr_t size)
+{
+	return size * bootmem_scale / 100;
+}
+
+/*
+ * The lowmem area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node
+ * areas cover allocations above it on each node and the global area covers
+ * allocations that are not bound to any node.
+ *
+ * The reserved memory on a node and the total reserved memory include
+ * lowmem, so it is subtracted from both.
+ *
+ * If ARCH_LOW_ADDRESS_LIMIT covers all memory, any area can serve lowmem
+ * allocations and there is no lowmem area.
+ *
+ * All sizes must be calculated before any area is reserved, otherwise the
+ * areas reserved first will be accounted in the sizes of the others.
+ */
 static void __init bootmem_size_update(void)
 {
-	/*
-	 * If fixed sizes are not provided via command line, calculate them now.
-	 * Remove HugeTLB allocations from it because they never get allocated
-	 * from bootmem.
-	 */
+	int nid;
+
 	if (bootmem_scale) {
-		phys_addr_t size;
-
-		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
-						   NUMA_NO_NODE);
-		size -= memblock_reserved_hugetlb_size(ARCH_LOW_ADDRESS_LIMIT,
-						       NUMA_NO_NODE);
-		size = size * bootmem_scale / 100;
-		bootmem_size_lowmem = size;
-
-		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-						   NUMA_NO_NODE);
-		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
-						       NUMA_NO_NODE);
-		size = size * bootmem_scale / 100 - bootmem_size_lowmem;
-		bootmem_size_global = size;
+		phys_addr_t low_limit = ARCH_LOW_ADDRESS_LIMIT;
+		phys_addr_t lowmem, global, size;
+
+		if (low_limit >= memblock_end_of_DRAM() - 1)
+			low_limit = 0;
+
+		lowmem = reserved_mem_size(low_limit, NUMA_NO_NODE);
+		global = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE);
+		global -= lowmem;
+
+		for_each_node_state(nid, N_MEMORY) {
+			size = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, nid) -
+			       reserved_mem_size(low_limit, nid);
+			bootmem_size_node[nid] = bootmem_scale_size(size);
+			global -= size;
+		}
+
+		bootmem_size_lowmem = bootmem_scale_size(lowmem);
+		bootmem_size_global = bootmem_scale_size(global);
+	} else {
+		for_each_node_state(nid, N_MEMORY)
+			bootmem_size_node[nid] = bootmem_size_pernode;
 	}
 
 	/*
@@ -785,24 +815,9 @@ static void __init bootmem_size_update(void)
 	 */
 	bootmem_size_lowmem = round_up(bootmem_size_lowmem, BOOTMEM_ALIGNMENT_BYTES);
 	bootmem_size_global = round_up(bootmem_size_global, BOOTMEM_ALIGNMENT_BYTES);
-}
-
-static phys_addr_t __init bootmem_size_node(int nid)
-{
-	phys_addr_t size;
-
-	if (bootmem_scale) {
-		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-						   nid);
-		/* Do not count HugeTLB pages. */
-		size -= memblock_reserved_hugetlb_size(MEMBLOCK_ALLOC_ANYWHERE,
-						       nid);
-		size = size * bootmem_scale / 100;
-	} else {
-		size = bootmem_size_pernode;
-	}
-
-	return round_up(size, BOOTMEM_ALIGNMENT_BYTES);
+	for_each_node_state(nid, N_MEMORY)
+		bootmem_size_node[nid] = round_up(bootmem_size_node[nid],
+						  BOOTMEM_ALIGNMENT_BYTES);
 }
 
 bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
@@ -899,7 +914,7 @@ static void __init kho_reserve_bootmem(void)
 	 * memoryless nodes, as we can not allocate bootmem areas there.
 	 */
 	for_each_node_state(nid, N_MEMORY) {
-		if (kho_reserve_bootmem_area(bootmem_size_node(nid),
+		if (kho_reserve_bootmem_area(bootmem_size_node[nid],
 					     MEMBLOCK_ALLOC_ACCESSIBLE, nid)) {
 			pr_err("Failed to reserve nid %d bootmem\n", nid);
 			goto err_free_bootmem_areas;

-- 
2.53.0


