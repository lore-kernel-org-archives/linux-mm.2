Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5415E105D99A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61746B0098; Tue,  7 Apr 2026 22:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39256B0099; Tue,  7 Apr 2026 22:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9761F6B009B; Tue,  7 Apr 2026 22:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 891C16B0098
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36AE7BB0B3
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:54 +0000 (UTC)
X-FDA: 84633863748.02.1911A78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC9134000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K+u/rD5a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616712; a=rsa-sha256;
	cv=none;
	b=LbcoFFbTkAWVJgdrNc6HxWo8ZBq2VRmnpvUy2W7ke3JcxFqjC4r8P2kPA5R//jMO6ofYQT
	y9tZ34qBM8Zh8V+eEtyEGAZ0AGPjKtvdIQ9ijPpSgBYPSa859kUSX4rjHOQ8ha8CSICFB1
	navDCzuF5BAehlO0LdL/gzpOwLEMh2A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K+u/rD5a";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3GOUPD44qg/7UajdPdeaivaRafFbx9Izl3BJI07ZEA=;
	b=EE23TELD0nCFN7RSgkr+TCfZxtp+0Tsl1+lE0yaSGmxaMRs2v0r3kZf4nBtigmCODYTeQP
	bPZevghPwKGVsSoNZPphIOuMDmQppDE1TVKphh7nO7V7F+Xz7MS43p+CXHslQLCPziESq5
	Z7esoMW6Ld1sOhAyckNDMYUHCwly1lc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A2656013C;
	Wed,  8 Apr 2026 02:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F42C19424;
	Wed,  8 Apr 2026 02:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616711;
	bh=PKtItPJH+nSfbPKiSnTVSIKouqPIOVzmyf2uKcpw7Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+u/rD5azpr8es305v/KMUlewCknD5c7RdCe2Nv1fnif5jdekzR5z72uB0XVvbhf8
	 559XCvpf2ujN+0v055UU2ailQuyIx4O6fsijGq5EdqomDTipii0OPoSxYhGpq83F5W
	 +rOF9PK/XyLmm5YdJdA/KzBtgDWtqgJajiWkLyeFGrWvjf/4uRD9T4CLtVAdP/j1HP
	 3mbPUWakkrUQrYOcK+XwBqka08Q9f0V3Wa3Y6fCFXD3rvsfAfFgLrhP8ONEC8QPSkO
	 6tC4+Bad8HvLf3ZLhkkMBega2S2viD1f4xf6bzgx5hAabqvbCniwxYN+CDTpaHsD4V
	 IuL2CUt5ClpWA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 6/8] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Wed,  8 Apr 2026 10:51:13 +0800
Message-Id: <20260408025115.27368-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5z8k33ced16x5g5zz9idhphx5s4qsiyf
X-Rspamd-Queue-Id: AC9134000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775616712-937229
X-HE-Meta: U2FsdGVkX19PUrCEBjNYSrrFyhY1dwL3HGIohYKypgREpNaAiJFapOsrBfExxvaSVMWRXrZAuXupuHvEPHaU1C/pc4XToII9++HvsCDtz4rCIQnZ8L/z4EdovbYNl+4LNMAJxMXjIhXIYgJj13JJGFe5NZRVV7btjrwfBCk/rP/3QlSsTTiWdoMcXdwZvrQ9wuvM3cyyd1wX968u0JMWdPiuDRb0dRfrKrgwRwncHpbx16fhdEJu8Dtk/QkUCtJuxQU4TfiqASuX7ZKannmMKRQ7RtkVNcga/cKHz6jhoT5gjYxe5hBQAv3bBQma8WA/lE/c+23x3Pnc788z+IVcq1E1+bAgfa6YxxKVDrrO+j1xFHMvgEmMbjxM3YfPb3jbtH2OMAzp1pH25C3gl+pCbUU2a+obIKTMXLsQ/5/Rzdpreormpckd1ImOyGhLR6gkG5IuJejUNDtMaqo+wBgwSOqpDt8ppe2Hdb3Ue6OZ7XH2Nr3m4LZqQ7VtYGTxIx7hdkpCBolbfme5dCj2AeuWX3S4LmR2hs80ISDtc4QJmDz5EQgKEzcMyb06TwPVehaqc3QOH1ml8EryBwJLuQPjbKboVF/WNu2wNm+On6KmpuOHrFnRruWfi6pUzwPKUwM/6rZwTE9vm0KOJnxV2EVHNPakYvgBzpzpZZPVF3ewcvylYl1bhOpFFBbY8OlgjRX1OouqfXzBdRHxWvpkiCU/0sPvPsciw3nJJaDxtH18GouB2DXmGSeaDcEQHMnDnyHrQsnkgDxb54Q5GLoCM/Jse4LAQF1Wez6b9wtyzQsTaC8f5ViPfgfBLETXx8sVhZbWb5w7i0GOcWTunHgEm2L+sfxncCqq+oMRmMneCkGnj8uQZyNc/iCc6A3sdAxLGjzymZhQTnkWu7S2HglkNDnfu2FykM7VyjBmFcvr9JfjElyjr14fUS7+6nxyv5Uxyw34UfRYzAu+iGtWDTVJfOM
 5vX3i5E2
 FncCOPOetSUd1zAK97kArVprG5007a2IDZa7rObCSPkEFfw3VfF/ctauKlFb5G2N1BWXBSIiI2y09beXwNLMRomboX7Dyh4rSLWqIfsjCsYd9PNdrKab0I3YgeE5S0bieM8J4fXhB1Lpskm8Kn2ayR80W5auqngdq7ZNWh4QI2fEicm+7W7y7ABliUb6AHd975mwSbd9YpAEgGSvNQ3byyI1t1pqpE+THJ/fYLe4J4gdsKOJ9A7dxhq25mSwB8+/OLrZV49zTjfQ2mbe1JiXlqxbesick8706Ul6Vro5h1vxLPgQbTRW0gNnFNNYWy1hYeyKjoNGWVVLCEixiJ8REALkJ4L+wKBBh+oOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmalloc.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e8dbfada42bc..6643ec0288cd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3576,6 +3576,35 @@ static int vmap_contig_pages_range(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *get_aligned_vm_area(unsigned long size, unsigned long flags)
+{
+	unsigned int shift = (size >= PMD_SIZE) ? PMD_SHIFT :
+				arch_vmap_pte_supported_shift(size);
+	struct vm_struct *vm_area = NULL;
+
+	/*
+	 * Try to allocate an aligned vm_area so contiguous pages can be
+	 * mapped in batches.
+	 */
+	while (1) {
+		unsigned long align = 1UL << shift;
+
+		vm_area =  __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				VMALLOC_START, VMALLOC_END,
+				NUMA_NO_NODE, GFP_KERNEL,
+				__builtin_return_address(0));
+		if (vm_area || shift <= PAGE_SHIFT)
+			goto out;
+		if (shift == PMD_SHIFT)
+			shift = arch_vmap_pte_supported_shift(size);
+		else if (shift > PAGE_SHIFT)
+			shift = PAGE_SHIFT;
+	}
+
+out:
+	return vm_area;
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3614,7 +3643,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = get_aligned_vm_area(size, flags);
 	if (!area)
 		return NULL;
 
-- 
2.39.3 (Apple Git-146)


