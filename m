Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB8C606D811
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aqOPHRez
Received: by kanga.kvack.org (Postfix)
	id 2D5AC6B05B9; Tue,  3 Nov 2026 06:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADC96B05BA; Tue,  3 Nov 2026 06:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2FA6B05BC; Tue,  3 Nov 2026 06:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E860C6B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:50:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7587D1C3AA3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:50:04 +0000 (UTC)
X-FDA: 85393639128.03.778AC37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8DBBC0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:50:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqOPHRez;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfTQknGJpSI2GICiIF+kAXKtTCGL4b3ApztibrZw2ss=;
	b=jvCFP/wvlLUOgoNNPWMBFPa0OTRHA5hMes1UB7UqOIDAAjLxNRSD4x8vsUz9zYJvo4okDT
	Nicfu193MxFAJ9hKStHdA4BiCZP7wL4WuCfw5SPH+tVn3yE+DZLpbkjTRrqnamGC220kMt
	cwSznDJOyovtuZT7wNvTFgPK8mdOUnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706602;
	b=CYQ0wStcGt8ammDfkZm5D9uiUA3S0LWNbDuCV8jYn5BjYLnMXXCxp64slwgJm29z385xrW
	bNJdbgsjF+Qzik3GM17hFpVF6NqCJRETHMbCZO3utRfFsiGf81Db7/0rOLADTVMuhyEpvp
	OL0SIqA1T4UYxXvQWVhqrscj0BHkZk8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqOPHRez;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1294943C68;
	Tue,  3 Nov 2026 11:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5092D1F00A1E;
	Tue,  3 Nov 2026 11:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706602;
	bh=FfTQknGJpSI2GICiIF+kAXKtTCGL4b3ApztibrZw2ss=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aqOPHRez7HNXUMU/E7nN4gHuptx/8+GgRVpmK73me7CuY054WSzDoHjTdaG2VE3wu
	 gB6Z/HAkRlwDuDx+TXxujjnY5IMaeFOjiO4WcpLDPm1YCnmg/pe7ZWM8i08/QtfwxF
	 pATBtmHmzKNnSSlanHTVwJdRbk5VaPL/eQEoLxUMepXrl0zpeN2BIX5SUOOOjUjy0O
	 NCHTBS4n7FB3nmGKoajrhIZfuIk4Qj3uZE2F1HvU2rUZ0rH56RTIikNDOkisk+NlJ5
	 K2whdi0pPpiOygQkIKKIxKEQIM62Wks29qQWzH9gQ7aJJFvJsiuDyQSp5UFy8kIpjH
	 e/bVcJVee77MQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 03 Nov 2026 13:49:50 +0200
Subject: [PATCH 2/2] kho: fix bootmem sizing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kho-bootmem-sizing-v1-2-45aa74098f34@kernel.org>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
In-Reply-To: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
To: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8DBBC0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: d6s4gsdkrmdeh45t37oeo5fc3yui7tk5
X-Rspam-User: 
X-HE-Tag: 1793706602-533657
X-HE-Meta: U2FsdGVkX1948vid5io5ymtcNPiyg+zZ8iMtR1hJzeP39FTRy0+7xw3GRTQMrJITRNmgnfXq7hvyemG87/2X1U0IjR9mRoQOZOMKXoqKS3TcYVgNdnYWT9pZPGKUWsCEVFLIen13wz6q8LbD6p3gVDVavwuxXdPzvRMEfo4VtxCiR/oA9ljC8958A+Q4E13lxV3+hhNV7mG75dXntUns5qywsZyj4tdSl52Gjzp5NfJquIk/w/1nCgchvkEzuGqQXM4PsX4EDKm7SdphcMc7FLLFER5OiisOdlaaBm3NM1Oh4kuRjzROVC44ax8DhlIqZ1PrIrdr8NwZPjECW6lsxrh/1VfMzxoKCRpE3pSOhkC/HgqHXqx1+OmyR/ZcJdm4Gy0TIYjxtaFgpX/FnKi7WDbMbhe0hKjdqgRBqf/M8B9zZMvzW8XWIfGdGQOR3II+Ha3/w7Yp7wCyMimZvyq7V84sms8ruVWAL0NS5oEv7cwDSpg3sosRdapHjrc7D9jmcg4P5POZ/bIdIWjNtiXRCsXvcQbIBRzqvomACoAEwo9A5jNdcGcBuOHjOHBzU3MO1S46fj5ozg3V6ltliEliOUkrFEpDTKuAuXzBE9CLYh4zmwypk47EDYpJAWuL58mQZ0IHSA+nwW2vARj5ijUkZ1eyGfldqBXmr9fb4MJQkgONqSfnIsMLVzuvOcjnaKpf7iKXwTJV9YYbWKoiHbR/BkECgySgWvsijlXeX6UckwXl3E2zdTDlhsXCmkkIh1JE+4kv1xInTPLJHIBBfgB4cCs9x+f71ZXXiySkMIw2KIkpSg3mpojWt9H6kjrfM7q8svth4CeOQM8PL+jMW7Y3B0ETtnB2HnkACCQmoTYWZ6i2ALYjjA1Fxp+RPmxKOAgg9X8LIP4mw+BySO1eChxf3RvOhkhxoUwCGRO9oYVjQyP9rptR1Gehdw/RCAZHqI+Rk81KjFsumkdIRsXYHMD
 0zF4rR+v
 qqkr6LIXx4t+Tu913mL1ZGFd3yUAG5mvx5D2Nl6zherIglD3iAVo1nsEbbilUMFUhaWZ4Y3khQMPJme3FPmvVbIRPPUKCPwya+VqOj8eQkvpXBHGkuz03ww7meQz9UFMJDbPu8xvETy9Zyt9q/Z9qWhq4fmvUj4wHff8sW8r/PV3osnJEpk3JGy5yKYgY7PdclR4dLamM7+iIX44A31lNh7dttyKA2/Fa2uALO9acLD36zjoF3CmbYMsAQynJMoiVGOAXoOo+hC4uhYM=
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
 kernel/liveupdate/kexec_handover.c | 83 ++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f268c57413a7e..eaeb895bb7595 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -684,6 +684,7 @@ static unsigned int bootmem_scale __initdata = 200;
 static phys_addr_t bootmem_size_global __initdata;
 static phys_addr_t bootmem_size_pernode __initdata;
 static phys_addr_t bootmem_size_lowmem __initdata;
+static phys_addr_t bootmem_size_node[MAX_NUMNODES] __initdata;
 
 static int __init kho_parse_bootmem_size(char *p)
 {
@@ -753,29 +754,48 @@ static int __init kho_parse_bootmem_size(char *p)
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
+		phys_addr_t lowmem, global, size;
+
+		lowmem = reserved_mem_size(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE);
+		global = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE);
+		global -= lowmem;
+
+		for_each_node_state(nid, N_MEMORY) {
+			size = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, nid) -
+			       reserved_mem_size(ARCH_LOW_ADDRESS_LIMIT, nid);
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
@@ -784,24 +804,9 @@ static void __init bootmem_size_update(void)
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
@@ -891,7 +896,7 @@ static void __init kho_reserve_bootmem(void)
 	 * memoryless nodes, as we can not allocate bootmem areas there.
 	 */
 	for_each_node_state(nid, N_MEMORY) {
-		if (kho_reserve_bootmem_area(&i, bootmem_size_node(nid),
+		if (kho_reserve_bootmem_area(&i, bootmem_size_node[nid],
 					     MEMBLOCK_ALLOC_ACCESSIBLE, nid)) {
 			pr_err("Failed to reserve nid %d bootmem\n", nid);
 			goto err_free_bootmem_areas;

-- 
2.53.0


