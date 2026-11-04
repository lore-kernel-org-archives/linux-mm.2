Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9736083616
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mn1ozcrf
Received: by kanga.kvack.org (Postfix)
	id 103916B05D4; Wed,  4 Nov 2026 11:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6C66B05D5; Wed,  4 Nov 2026 11:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFCB6B05D6; Wed,  4 Nov 2026 11:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD4576B05D4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:50:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 525CFC07A9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:25 +0000 (UTC)
X-FDA: 85398024810.11.CEA4303
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB8B5140003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:50:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mn1ozcrf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793811023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og6DL/XuMfc+HEcGtspUv6YSe8N3e770jx9UfiUFD4A=;
	b=EgcyJm9sGCypNXR15dbtfu8q0EObNUA35IUdbE7OK8FWlA5jbkiv6eXTmPnyDd+tUmeruA
	cThHWp8yT354MeSaXUc0aokKN0IVhDCkG0whqVi6e9sePV6S/kWEikhaH1lB0q9fgDSE/X
	u5bYUQI699MkU9eXRjPEBe9+lAhrJXA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mn1ozcrf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793811023;
	b=2O+WASsGbUc9+hLHmIUn9DzdtBVSt8YuXqX0cytcXhHkG0ESOawXUn3F5cU+vSsbSbWK3Z
	OpPGq47KxGOwqR/gabSfJlvk1vwxvs6sBQmj7SsxEALSlMPc1fsCZEMXjBZSvQx7UpeIPl
	FPdDx/u6ia49QGZKLC64H7bpd/I/veE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55DF160AAB;
	Wed,  4 Nov 2026 16:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A201F0093A;
	Wed,  4 Nov 2026 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793811023;
	bh=Og6DL/XuMfc+HEcGtspUv6YSe8N3e770jx9UfiUFD4A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mn1ozcrfbB74kUJLwIRXRLl6Q+s1pUFhT36GwRuOEzoCaZFwhSv+h+zuN5BDmf9qF
	 ZtGBf952ZuwVhX6OyaO1+Zj1L93iLrN5Nmd4+KJj27+BVwZWw8NsCucDMHEVb8Sb/S
	 1NiOGu7hTF/LbjwmmTNXWDhWQuN2Jipom1/nmo0c2puVYzTsNxwVcwpVW2La3BmsQw
	 oU8hqQwJJqibpZhabMTQoOMmFfm8SqBBR3+PE2bsO/cYB9pAStnoQv21IsN6F6GAiT
	 bw7Cj3PrxLNiG+/zGg6sSraBo7Hyvb+sKLIhSC5/AF1gSA67qfzYb2ts2Pk62lHTCj
	 ZzmedIlaafuEQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 04 Nov 2026 18:50:10 +0200
Subject: [PATCH v2 2/3] kho: skip zero-sized lowmem and global bootmem
 areas
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB8B5140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: kgihxqbme6x99t6r8fzb7uumy147bt6h
X-HE-Tag: 1793811023-17942
X-HE-Meta: U2FsdGVkX19lBfB8W1HnDI17VkYs+26gTQ95IeIGGMZH5yQChi3LfCxJJFNRtTIrF8jGaP5oLljWm7hMTAu88Knyxebmu3/LQZ3yzmSrJ/PJT77pGzyeRbp5RwSqVNK9l5MusbIz/uV/L+nmmmcVpP+++sh1TTa4n9cLv7DUoNvNmcTCSCi+p991vHWQjrEq5O5fAFtesJFdqscG7PupM520R/qDxN8XxGCugVHmYrigkPCYBXgwJaPsDKWET55arZRBXelnGYAE5AXDmvkY1r4e0As8aa8WSDpNpcUNLIf20UcQ2qt/CCWzYDykMd8fMCy7RIMAsIaIwRVK/l0gcziYxtnu6Me5mfeFlhfXMCa3YAUYUe8QdnF7c/BtZiZtWxlGTgh6mYReUIAHhmIWiFr/BVB4Rrk/o/CbQB+oxGnNRYzeVEZWRrtjUxzz5QSzmLLna8YPVqGqfau3Vt90iespAqhBOGb9mt0ORDEyI1+VkhJfV0av+++aOxG2JBWjI19nvquWQjKgWujULekUwDEssMqNDO7dT84lL5SagAQvM/A30deWiRbRy/+D2TSeme/kOE0eoc4bUZIYblhOhX0l7KWQu7of/AKfZGXyl3QUFJtgaqMZ7J0Q1AKhCFGpRK7Vo5f30yLHhXhDTU+mvasLVUrhslaSxBASTKir7q+AyXX7+uDQDWoa6OCGDlu/tz0NJXFzym1a8vce7UDFpxYHJSWOd2PefNGr1pXWccB7TCtgN0NNWXNE3YAT1UcGnZ6h4ny+GwdNHmpWflUliDnJ1fqswORfvdaLDOij9EDe+NFbuH+SzAxiXf0ifMhz2TDmYQ1i+F73NIgMHSOLDv+aegQIgkzy5HEcXKtwSw/ZFWJ2qhWb4M+fmQb6VFa8hvbvqvIQHKK5VrrrsQqniuYPkzsrsdzOV2NVQ0YafIhyHCfloG0gK5Mj2PO/KbIOB/ET61DjdkaViktPQpc
 23Yv0+OH
 hPzUx4icGxqTUbog35Y7xq3SXHG91w4Udfdz/7xkbvVAjm88JMbn/qZHh6Ge2aCwqpHBOBjs7FpoyJSRsJrNAjTF5gvPnYBdke1WZSy+TQJ1qSqx/9i32klngx0yO66mnPCtJtqpal54X53O0bZl22usp+1DcbW5DAmSw2q5VCjRzr9XWOIFCHOtIUKRoqzKhmEH66UY/HNgPQZNsHvfyqwz3Ght8eqnbgaje3kGe/dumpu58JgVfaRAs1ASgrAWhOUgUEjQi1vZmxl4=
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
 kernel/liveupdate/kexec_handover.c | 66 +++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2ac5d94f33fd4..5b1797d1289c8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -829,6 +829,26 @@ static int __init kho_bootmem_cmp(const void *_a, const void *_b)
 	return cmp_int(a->addr, b->addr);
 }
 
+static int __init kho_reserve_bootmem_area(phys_addr_t size, phys_addr_t end,
+					   int nid)
+{
+	phys_addr_t addr;
+
+	if (!size)
+		return 0;
+
+	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
+					nid, true);
+	if (!addr)
+		return -ENOMEM;
+
+	kho_bootmem[kho_bootmem_cnt].addr = addr;
+	kho_bootmem[kho_bootmem_cnt].size = size;
+	kho_bootmem_cnt++;
+
+	return 0;
+}
+
 /**
  * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
  *
@@ -840,8 +860,8 @@ static int __init kho_bootmem_cmp(const void *_a, const void *_b)
  */
 static void __init kho_reserve_bootmem(void)
 {
-	int nid, i = 0, max_nr_bootmem;
-	phys_addr_t addr, size;
+	int nid, max_nr_bootmem;
+	phys_addr_t size;
 
 	if (!kho_enable)
 		return;
@@ -861,66 +881,40 @@ static void __init kho_reserve_bootmem(void)
 	 * reserve bootmem area in low memory for lowmem allocations in the
 	 * next kernel
 	 */
-	size = bootmem_size_lowmem;
-	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
-					 ARCH_LOW_ADDRESS_LIMIT);
-	if (!addr) {
+	if (kho_reserve_bootmem_area(bootmem_size_lowmem, ARCH_LOW_ADDRESS_LIMIT,
+				     NUMA_NO_NODE)) {
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
+	if (kho_reserve_bootmem_area(bootmem_size_global,
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
+		if (kho_reserve_bootmem_area(bootmem_size_node(nid),
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
-	kho_bootmem_cnt = i;
-
 	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
 	     kho_bootmem_cmp, NULL);
 
 	return;
 
 err_free_bootmem_areas:
-	for (i--; i >= 0; i--)
+	for (int i = kho_bootmem_cnt - 1; i >= 0; i--)
 		memblock_phys_free(kho_bootmem[i].addr, kho_bootmem[i].size);
+	kho_bootmem_cnt = 0;
 err_free_bootmem_desc:
 	memblock_free(kho_bootmem, max_nr_bootmem * sizeof(*kho_bootmem));
 err_disable_kho:

-- 
2.53.0


