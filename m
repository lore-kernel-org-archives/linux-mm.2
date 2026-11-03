Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B4A606A339
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GfdTNGFn
Received: by kanga.kvack.org (Postfix)
	id D84916B05B7; Tue,  3 Nov 2026 06:50:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33F76B05B8; Tue,  3 Nov 2026 06:50:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71F66B05B9; Tue,  3 Nov 2026 06:50:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0CC6B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:50:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3843D1C3AAA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:50:01 +0000 (UTC)
X-FDA: 85393639002.10.EE9B06B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9340C40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:49:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfdTNGFn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793706599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWGTnd8ZidzEdipCYzKE95gvRo3h3EOL4P9sMK0ko0A=;
	b=olenrdbnDHHny+jKcx5QCPN/nl51AGxN4nK1d1WzXH5U9DmfUpbYS/lGRByU7F2Zr+1NIm
	0Y+6/Otf0sUo+eFkPkZ776SQ0o7618qK22CFDz2FEcEg4/kZn7SgBAWNLUB2BEKJEEIJnV
	liupf8oSgGBcXFJLQ35OTjVKT+xdqsI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GfdTNGFn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793706599;
	b=vg264vtTV4LMHpA3piMgh7IKBSmPbuD0HUnQXWOQr5zX4O+BAG2P0MCzWwphX9Su1AIiRB
	9+GQaz10p4dkKY6l1D+jw5/tJcD5IWfrMXfktd2K4gW3bY8kMzEc755dr9X2J+0PPu7hyT
	YDiDZw6cxo/CZdTYO9ThSBmqKQ3t3U4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EEAC60008;
	Tue,  3 Nov 2026 11:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AA61F00A02;
	Tue,  3 Nov 2026 11:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793706598;
	bh=RWGTnd8ZidzEdipCYzKE95gvRo3h3EOL4P9sMK0ko0A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GfdTNGFn0HMpOe8AvhCd2j1aZaNVz68H5nNKxBveUcdY9soH3f+JDh52AHmXHom6W
	 PuimrJhvNrrYP0LNSX+uwodX/q3H5aLF1SQ5SR7HoJBzInc424buwd+htB5fxjsfKP
	 h0m/6Xs1nv1blG5kAfyD20FtoIP5R6I4qJS3f6p8dOcm2Dx06RICbcndZIF7lvkZSn
	 uZhjwPsgeG/2yP29FpLGebEvzUuYgViPZA3POGPmlP7tR8dGtVEMYSLnKC1UzDLap1
	 6QjqF3kkuGDzQs63Zs4RQ+I1qytybEp/QaYs4mKO5OVEvuLUnIPDVTTj5hJQzpoGCx
	 ef3ZcMvr9pMVg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 03 Nov 2026 13:49:49 +0200
Subject: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9340C40004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: ogd5p8ks3t15cdxd6h65q6acff3o7tym
X-HE-Tag: 1793706599-976864
X-HE-Meta: U2FsdGVkX1/IYaiCNq64O//h6qwQTz1H4mOCCZbd8BDRK2qpw2C1WI9vLhFhZyX+tubxxAuej4hytUewb9F/JVdS93kNNK58jher8aQoxlBvRApZmJi+G1qJQ1akxddu6SqHCKvOQh54gLO3aQR11A1BDGWCNoDHv2JQTAmwrEEfN3/PMuwnJAIABjaCan1y8dG4ie8vS81+9/ti/XBMLiGRrF71HQPg9UdBCx3MVm+r92T3WrfWW3xEWaGuTOm20yBLWnNwzLrxoGfv4WMOAb6NIxDTuCowt3sjBcWYcajoZ9+xx+X73OA3CUOx226AUJuWbx7T7j1FHTSgODD/HRfdxVCuk4TUBx9HT9cwiZtcrNRiilzrH1cziEIYJmyYh1AOysVOKSY14HPRvX/zXx2+hk8iNZuyhgveIqLZxEg5YaUmkaWuSokW4Dyb7iFG+1Safm36PSQqXHc2+Exez92KQfL0xijCEWfBTz5QL3Ht4xg3fMERLEzEWxUIkh77dtZhkGDpZZN+qc9vGEA3hX5ldtwcghAjhwgdP5a6IJQPVt5SsdtEJrVagxEg+wpa/xRrFtdqmRGeJAUkXGMqcSAjxE7p+bPtaa4ryyW0zElB/46IQY+3MPPnyA/dsbJY+DiZjXRLgRTrRIoUykBfqcbll+k7jP5CbIZJIzuERiAQzEYBkfL8LI8sh/1S4Pq6V4ceHBWSz/5O1cyqVbxnH1HimkZAP0dHe4aOfVhGEnc7GE16vuWJP4nFtGfWmLYgZO5hAgKn7XBUcRzKZzdbpBLebqQwsTnX4czKdvkAsbRUz/YoCbsImeEi4lnSJVtS4fEpFl7zkwulW3MvurBrTmlJeVHbh3FLu6UwstMZhul0u76nipZ+eeR6VKbBt5gPtCYNQ6cmwLD3KmgEtZnHLv6IK2OPvME+2artJ8D0MZk+1amFRivT+jL++3+AtjtHYOu/lcJnFlmpYM3hDq6
 QEq5KF5D
 8mgmzPUEXOTfn+i4zGfzWIVYWEwjhb4b9YmPC4Hk76YJi0/eBJ3NHOc1oUQVUjdNyck1FLA5KtwI5Gm8WCke6ltw67Q6aadNrtwroQQojlc9kR/7ObZ31HzigviGbQYmtpFBGpgzSNuuDTNsy4y8/rXdbnSm0ZteWmBrZELBXz+VhAh0CYT/lrX1xbjt1G6rw1ofMi3KUg4Q8iHfMNHNgMwGrz8RWJBH2xsTVIaANgnDYMWokOeRtNjVIfdR12Wc/3T+KlffHVkBbAVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The lowmem and the global bootmem areas can have zero size, for example
when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
either of those areas is explicitly set to zero with kho_bootmem=.

For a zero-sized allocation memblock returns an address without reserving
anything, and that empty area is recorded in kho_bootmem. If there is no
memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
fails and KHO gets disabled.

Extract a helper that checks for zero size and allocates memory from
memblock, and use it to skip empty areas the same way as empty per-node
areas are skipped.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Reported-by: Chen Pei <cp0613@linux.alibaba.com>
Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe31819..f268c57413a7e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 	return false;
 }
 
+static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
+					   phys_addr_t end, int nid)
+{
+	phys_addr_t addr;
+	int i = *idx;
+
+	if (!size)
+		return 0;
+
+	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
+					nid, true);
+	if (!addr)
+		return -ENOMEM;
+
+	kho_bootmem[i].addr = addr;
+	kho_bootmem[i].size = size;
+	*idx = i + 1;
+
+	return 0;
+}
+
 /**
  * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
  *
@@ -832,7 +853,7 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 static void __init kho_reserve_bootmem(void)
 {
 	int nid, i = 0, max_nr_bootmem;
-	phys_addr_t addr, size;
+	phys_addr_t size;
 
 	if (!kho_enable)
 		return;
@@ -852,56 +873,32 @@ static void __init kho_reserve_bootmem(void)
 	 * reserve bootmem area in low memory for lowmem allocations in the
 	 * next kernel
 	 */
-	size = bootmem_size_lowmem;
-	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
-					 ARCH_LOW_ADDRESS_LIMIT);
-	if (!addr) {
+	if (kho_reserve_bootmem_area(&i, bootmem_size_lowmem,
+				     ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE)) {
 		pr_err("Failed to reserve lowmem bootmem\n");
 		goto err_free_bootmem_desc;
 	}
 
-	kho_bootmem[i].addr = addr;
-	kho_bootmem[i].size = size;
-	i++;
-
 	/* reserve large contiguous area for allocations without nid */
-	size = bootmem_size_global;
-	addr = memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
-	if (!addr) {
+	if (kho_reserve_bootmem_area(&i, bootmem_size_global,
+				     MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE)) {
 		pr_err("Failed to reserve global bootmem\n");
 		goto err_free_bootmem_areas;
 	}
 
-	kho_bootmem[i].addr = addr;
-	kho_bootmem[i].size = size;
-	i++;
-
 	/*
 	 * Loop over nodes that have both memory and are online. Skip
 	 * memoryless nodes, as we can not allocate bootmem areas there.
 	 */
 	for_each_node_state(nid, N_MEMORY) {
-		size = bootmem_size_node(nid);
-		if (!size)
-			continue;
-
-		addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES,
-						0, MEMBLOCK_ALLOC_ACCESSIBLE,
-						nid, true);
-		if (!addr) {
+		if (kho_reserve_bootmem_area(&i, bootmem_size_node(nid),
+					     MEMBLOCK_ALLOC_ACCESSIBLE, nid)) {
 			pr_err("Failed to reserve nid %d bootmem\n", nid);
 			goto err_free_bootmem_areas;
 		}
-
-		kho_bootmem[i].addr = addr;
-		kho_bootmem[i].size = size;
-		i++;
 	}
 
-	/*
-	 * Nodes that needed no bootmem were skipped, so fewer areas than
-	 * initially estimated may have been reserved.
-	 */
+	/* Areas with zero size were skipped */
 	kho_bootmem_cnt = i;
 
 	return;

-- 
2.53.0


