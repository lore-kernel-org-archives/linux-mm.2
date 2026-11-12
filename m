Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26DA9606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acKLejRj
Received: by kanga.kvack.org (Postfix)
	id DE81D6B05BB; Thu, 12 Nov 2026 05:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF9C6B05BC; Thu, 12 Nov 2026 05:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5336B05BD; Thu, 12 Nov 2026 05:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91CDA6B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:39:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C157C0527
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:23 +0000 (UTC)
X-FDA: 85426120206.01.FC5948E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6996740009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acKLejRj;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajyrEiwf6H5409PUsnOKabsSDBay2mJauseGK/YVr4g=;
	b=yOwOcucw0aDwIXE3jgfywtjpcSEKHnDBUfd/XO4CO5JibxHUfLMXfss5SSU7H8IzhofQr+
	iOOcHCKlhC43aXxkwhqKiBcReyxWDNVnjRTg4gb2towyPE3BWl/ReNEX26gRGksF9RLOgO
	DqMirEFiRVUx2x2CPUZRqE9D7GHi//8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479961;
	b=z2RPHt0vZ8PmF2Ah/J+9fIMWwMMHPjK5KSghaYT9vQk40dCgWsOu1zNKdYNRywZH41TDAV
	Ebe/g7JMGKOW6+zKOT8I6YpgdW7/VNAf7ljNVJN8/dEUsE4F74ychCeZ6td8NlKa/HmIZr
	ByKWfI1nwXmfpYoxqotqeKDJ9b7LLws=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acKLejRj;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00B8C656E5;
	Thu, 12 Nov 2026 10:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71081F00A05;
	Thu, 12 Nov 2026 10:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479960;
	bh=ajyrEiwf6H5409PUsnOKabsSDBay2mJauseGK/YVr4g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=acKLejRjKHzZpGXehTjroNWz7OSm/RDok9tQ6JeCy4clnmS39scEhM3NJqDBR4c1G
	 /9CqECnzjjW9yG5sRRg4WjnpebCuoK5dcH5kfMYSunGvqi1dHTwEeu8keUWObmMPUx
	 QS9jaxK3ppkWHarktYytg8jMcnkOoOCKAIkgy61kDAYYEsh0NMduPIb7jeg/+Xa7lo
	 FMN7Bmslf5mDJfBPNOvu0vaMyLhx6W1fqbpsc37Io4ajwaXaruOz1t46sxq9x+hJ/X
	 Cq/4j06UJGKwBbJdFF0gv/u26JU7vZIbdL+zlqnptiMZE3069uwTcGna0Gdl5rL+qg
	 qwTNq+vG79kCw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 12 Nov 2026 12:38:56 +0200
Subject: [PATCH v3 4/5] kho: fix bootmem sizing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kho-bootmem-sizing-v3-4-f0c8d00295d5@kernel.org>
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Mukesh Pilaniya <mpilaniy@redhat.com>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6996740009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: xzezi7ga3dgg8rzew6zfbuwxzp48m8ie
X-Rspam-User: 
X-HE-Tag: 1794479961-23950
X-HE-Meta: U2FsdGVkX18dEHhSDXK7l1tc1YIJxrvvceY0LP5M4Es4i1uvImvy++6+OUIRXObMYHyKGbY/Wvw3o+oww1McdcyKfADeaxhELrmc5J/qUtZ4IDQAyZmkNnjobbLcUWZM6nZWJ+xv1zS44PoDl4SCNWMtNjhUbrHzjbmVL4XJZT102Ts70qeDd+arRDNU+UzQnjdoCtyPy3pHNdb4GOpe12EnChWwZtgyNdR/xxH9dB/+SJAugwfY8zhfZXWvoq+GuTvI3mN19AAnrQmN5ui/cKnkvpA4Iwel7zNBKd23N0ci09sdMSkmm5uPQVQVBKfXje2t2+2p0qWQ/14Bav1Cs9tIuUsezWco5mtD37UKmeRr6jMmCcnLuJq1FYEFWEoHjiC379qF+eZX9wtIXsjqwA8Z2FXBfw+j+nVmmgqKaGmFkh3+yQeNLhHGr8/PXl9q9mrZi0LU1Lz/OOW7V+5zubKbHHjO8afb8mo0Td/RjCdFCCqe6nWLSMXk0nQRe+kBqu9fit/bPwXotkNbDoq0MB9d8PsCtxCeSO9uvDe3QOKmLmcR8OSOqmDH0TZbb0i4e07YJwvkJblUs8TNkF8LX7c9oCfcQAUSmdQCoucBER1xJpDS4NiDIHHqeSC1UMZ9l2v50cGYq4q9pzb8UHD+jDP1yMWWMFM6dqh+lO36OYNqDF59eF6d9MXrFuXGjALGRXCiQ97THUkBEgVK7y6VWzkWg/ZeQovKh9Cj2TvBBbFtnkUGsP06U0OKDyG6vSQY1kvyZTU7vmh0dY+6Lm3Q+eBnKq5t30K8DjxR9A1O9cb2dhh9+OEwutSZty7Z8DgMeRDRHinZeH9zP0acYSeHPtShZroDwXgDw4ZsZnNVMznX/C7MOkb/vQilzMEKcYPed5XYCfqagw/54PM20495EqqWS8Rln5I2BFUuXn3xOioEf8ozCqIRcxQSIohzlm90ND/dP2vlKP7hl4ZwNW/
 tcjsxinS
 dVluwhK5LwCvaAZIcac5gU5nGKmtqI11CV2a5D+iOtWhQi9kFYue7WS5N+jnqoRNI+TPpgCOGjQEMKf2sIovuuAEvi2fijbFfqxLyuhPtUWSPMT8u9emiI14LAk6SO4wd9fkVEOvzcUj4CIax0bPKKnFgRrq+R5aaedHsBUZCoUWwEXznzD3WVAcib1eLJJxWvbqjYvki4TNn3qLEughDzM17JUSaRZNd+ESrRjJ2442+HOabHJ9/qgi3N4DzNGblNUD3RQicCgh71ID4QcTk5UFxpGtrQKMSPLRbsKoEQzFxm7Qj5IOsV+uBMg+8ZxxvJp/x8yw4ereZmRDKgZzk3ikbFYdNLB+VmwwdPQLUbIKZJdLIQmfok9g5qA==
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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 92 ++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 38 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index bbc9e644addc9..e9cefe22a6e6f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -685,6 +685,7 @@ static unsigned int bootmem_scale __initdata = 200;
 static phys_addr_t bootmem_size_global __initdata;
 static phys_addr_t bootmem_size_pernode __initdata;
 static phys_addr_t bootmem_size_lowmem __initdata;
+static phys_addr_t bootmem_size_node[MAX_NUMNODES] __initdata;
 
 static int __init kho_parse_bootmem_size(char *p)
 {
@@ -760,29 +761,58 @@ static int __init kho_parse_bootmem_size(char *p)
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
@@ -791,24 +821,10 @@ static void __init bootmem_size_update(void)
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
+	for_each_node_state(nid, N_MEMORY) {
+		bootmem_size_node[nid] = round_up(bootmem_size_node[nid],
+						  BOOTMEM_ALIGNMENT_BYTES);
 	}
-
-	return round_up(size, BOOTMEM_ALIGNMENT_BYTES);
 }
 
 bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
@@ -905,7 +921,7 @@ static void __init kho_reserve_bootmem(void)
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


