Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB91606A888
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YiiROZ3c
Received: by kanga.kvack.org (Postfix)
	id 842AE6B05B9; Thu, 12 Nov 2026 05:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819A26B05BA; Thu, 12 Nov 2026 05:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBC26B05BB; Thu, 12 Nov 2026 05:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38DCF6B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:39:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7E9D16047F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:18 +0000 (UTC)
X-FDA: 85426119996.23.9DCFB27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EEA66180009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiiROZ3c;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWRG9mq5c0zudy8yzUdur6pFFwDbg0IZ+6kaZgluVLQ=;
	b=tRJc6y4jfC06++pO5dZxwzsOfeBA4PqScHdFUwDGEWha9Ohijrg3W2cgl2rqJ1lWHdiEAM
	bk3KBulDr4IP4aPwt0rU7jpmqludp1L7GWuaUdQwJ9dZqg5Z/61kpgf84BlYSVwMCQngjX
	61ibvRa7Ic0b93LmDxDl2Nt2ncxLDxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479957;
	b=w8GoU8JLHQmFr/lYtJyxEXvHROZHbdW3C/augbOlcWohJJ5M1z2L+3Zf1RzLGN21DJIhTG
	AK7+J+PmqnB8WVNeVegvZ2vn5j0Bo5TKhse43OodegNXcN37Extei+zzRmCpZMOiCPsesx
	XImpTIk6rbK5eOn1yLJX3E/Vu+X8X4k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YiiROZ3c;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 952CD63A5A;
	Thu, 12 Nov 2026 10:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C061F00A05;
	Thu, 12 Nov 2026 10:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479956;
	bh=bWRG9mq5c0zudy8yzUdur6pFFwDbg0IZ+6kaZgluVLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YiiROZ3cKFwEsmv/gaH+0ZzA+ApxCkE8LSgohRoc7zn2sawnCN40m+wmKbMhtJW+L
	 prDkmksozAzOpV+vtBhenY31ISzHgT3ZecPebQXQPbINiS5S+0RFXEV8ZYpPExIAvv
	 bSo7f/aSMTDacB3UwsQivWCoQRjvWpxqqnGC5NrZD5Jmw3PCTy69/qdjHGdIEJZOia
	 9F07LE+lVOBP9RBWHXNeNRrbaX45LTJp6mdI6lvw+n43VlNjzeU+7UEWBu1NfqyUYj
	 5VNa3SGPrgd6M88pnXeh98m2BO+9THUqVRGuoD/gnxO+2DDyQm5vPEQwGjnxDE7Vlh
	 juAuFAxk2t6HA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 12 Nov 2026 12:38:55 +0200
Subject: [PATCH v3 3/5] kho: skip zero-sized lowmem and global bootmem
 areas
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kho-bootmem-sizing-v3-3-f0c8d00295d5@kernel.org>
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
X-Rspamd-Queue-Id: EEA66180009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: rdoymbepjnwcajp4hkhbhp35m5uyfjdw
X-Rspam-User: 
X-HE-Tag: 1794479956-929784
X-HE-Meta: U2FsdGVkX1/2VDJKyOimzpgVrfYaOO2rh9xxj/BBTyQXuttobbkNC4b566aL4APw4zYWLa+vg8YeMPEofUrwPzMdhkVTyamc9jJ6hMOptoCsAFgs5Uv5mjiUwPzaz/Y5m+1F+G40dYIHnJrHaeoYdWD5hJ7XygPYz/GKg16+azHa28xnlKiaSz1jZ7EdYow35jqRGoXH45dNhbIXsVTZz9Mp3EKtS53SasAC1BYhYG35yzh/OSRlN0ONk4kDuT1bUBLpDVJvvN9pK6h8KojnPmyUz7EcYhQXVE3pdRiCsbYGcdzunwEgXKP8XmQpaS0BFxyBSCccP/Q3/tvCzRQKIWhaAT+pEfKiygDqzqHoNAYRRKnvnWWeBOMgEXYYQ3+zEdfIJ1Xx77LAt0winy1GaKE3eI22ZTwa0YidPFYjHNCsOXixPMD5hJCnQ6jlmRZFPdJ+n+SfPJiXe/T2S0jkTGynJ85bvYIkW1xxeSXzSZV57/tVy739uiTbJE+5N4ID0CxENkMItN9bsIlszVX+8MCsQCNKhHxlhjoRBTRBx6tJqa159W1/yFxuZ4lENPIdMaCRMb6a5Qkpr0He6MxsnbcXYHT7/ParOpvryDW9W2iJOnuj5pzkhmP8P0/MSWHjVbjzAdgVCpqMsIKH+boVuMi4GaCDASdiRLfj+IRm3rjzt6MPZhXW48c4+Z1lVhuvIkdpIBf13oqdUUjBh93ww0XfYNEsxAjU3cy794TeaZ9f2kbuNdd+6s8YSxrR/5HryQta6EMleGHvxRfcz0S3jz6kd/6y0eoEyoMksVBhkaIrLedjpsHs6mE3jp99RoVq4CYJabH/7KZjFoY8jIazutNkbFd4MjnQBtfyAQ8Ae2oUBn4O4Hgtki5q3aA1Btjm+lFEAwONURrQ9qJHTiS7A3Gi7YDuZYgt+BLHCG78k01EnPL1TgkKlF9pxYEX43KWjav/wYCYXXdiP1tmITy
 Cenz/bM1
 u4z9+Q9YXEuJhA2hZkxCKX/E1JsLLld/gBKEywuAby+LWTt14avy0J6x6Lj239TK9fbrFQ1DdkVMFIMs0mA6jAkFjURSoHPD4JKz+uX0st9u1KFdpKGFIySQL/XhYqhO0QgaoCJEAiKcXe7fdTCdObepDIja1Y3upWYMliWGG8jM0thNSqZPnj1Bmx1x6+6iEJmjDGAYTnRAgh1dAR1LE/cduGyFXpxRO61qxGuIE1FSNp2RSypgFMzCKoUstQ+1UGXCwevIGKnyuCFX+LfPbLG6SpuseKDCoPImFVYsnJzDMhWGKY/1u9VHe+sQaHWzAozJp3j3fpzFIDZCXE6sZQtMoRT4IaqUkSJVGD8IRI+A4evd1krpep7c7RQ==
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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 66 +++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index df4a972a860da..bbc9e644addc9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -835,6 +835,26 @@ static int __init kho_bootmem_cmp(const void *_a, const void *_b)
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
+					nid, numa_valid_node(nid));
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
@@ -846,8 +866,8 @@ static int __init kho_bootmem_cmp(const void *_a, const void *_b)
  */
 static void __init kho_reserve_bootmem(void)
 {
-	int nid, i = 0, max_nr_bootmem;
-	phys_addr_t addr, size;
+	int nid, max_nr_bootmem;
+	phys_addr_t size;
 
 	if (!kho_enable)
 		return;
@@ -867,66 +887,40 @@ static void __init kho_reserve_bootmem(void)
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
+	for (int i = 0; i < kho_bootmem_cnt; i++)
 		memblock_phys_free(kho_bootmem[i].addr, kho_bootmem[i].size);
+	kho_bootmem_cnt = 0;
 err_free_bootmem_desc:
 	memblock_free(kho_bootmem, max_nr_bootmem * sizeof(*kho_bootmem));
 err_disable_kho:

-- 
2.53.0


