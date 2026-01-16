Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7561EC982DE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91C16B0088; Fri, 16 Jan 2026 11:54:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69326B0089; Fri, 16 Jan 2026 11:54:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A986B008A; Fri, 16 Jan 2026 11:54:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B71216B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:54:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 199A016019E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:54:31 +0000 (UTC)
X-FDA: 84338425542.20.DB64B1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B3065180003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:54:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKf01sPk;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768582469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ORzddBrbw+D4uXnd0lt19gTnZVM9KpKMSRBPxVW3aSw=;
	b=wKaPWfuiAruV5dRtmmrGOFHtAI/1oncG9tlf7MxfE9MJcKZvKUfgAnCWX/TDcWVvVHhbrP
	qE/k2KROoW4AMHkCCjHfkmCgGiM632UMKlHtW42FQrebyzSd3W6OYMVBWDx0qz2MjtnB0o
	Vj/NIM7FWSrbBn5NbYKAQPeCkb9/dUk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BKf01sPk;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768582469; a=rsa-sha256;
	cv=none;
	b=2lI4opUiLUuiC15jwWSnDsLjPfHcJ0SgnSNYQtXVARCfSjIyzbceH2GUR+jo7Szk7rKxjd
	iTE0zCbfvmHRMu/mBqub9H672gXv2jaSAJpMfLVhqHoHGrZBC+JwoiKC1ntch9PX824UEj
	F4G2IADEZ/gTZL2rVAZtwZ5Mu8NoXhs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F10F60160;
	Fri, 16 Jan 2026 16:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2095C116C6;
	Fri, 16 Jan 2026 16:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768582468;
	bh=AgWf6hPAtL4GliApjS2EmEaZMLApvSCfTMtAOCyeuvI=;
	h=From:To:Cc:Subject:Date:From;
	b=BKf01sPkBRzCsFEmg4ZVDfpmZ90mayC3ZU/FN+ZHAo23vyeGtT+oXnjZyugbGuq74
	 FYKbltjY4O1OLBf2usHtyXNgg7hw6959Ax0Ue9Vz0pIKxmeSxV7l6eObGfrjVtXk9x
	 66r8Z0xoQo+DyIPpSDyqLgRQDiPuP2Ony+VxR5L2XjBO7tuuqUTT5njMafIOjTEn/u
	 8GCsJkk9Nm4+ey5dbbS3DGbC9Mr+2iyqzi+44UfU4bL1bhG/hK2M5i9Ai7qMherKUq
	 s1TiafCUSp5IqGC77jGfCGzpOdbeB+QxJ7qQRplDkh92leWgohrPGmUln2kY1vIOQ4
	 c154X1C7YSDrw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Samiullah Khawaja <skhawaja@google.com>,
	David Matlack <dmatlack@google.com>,
	Jason Miu <jasonmiu@google.com>
Subject: [PATCH] kho: print which scratch buffer failed to be reserved
Date: Fri, 16 Jan 2026 16:54:11 +0000
Message-ID: <20260116165416.1262531-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3065180003
X-Stat-Signature: yb15zf3kwgfw9ps7b9cyihoxkyw94xmy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768582469-456040
X-HE-Meta: U2FsdGVkX18cWF1rAwZqCipr/HGZETXivObke8XYMKpwmWyr8oEnufg4umMQFpC5ggm+WxOdvv91B/TEkMHYz33TtMOK+z1bWL2yllbWw8fI2XWEcP80bswCGgHgtJ9gb6LYcwtt6UffbtMmwBmwYQ7/vlapYrfh1jT3zwTsrcfcsgDCbtTaqTEkYMIp7icH841vH+SVYoKMOZPaWBQmB64a61VRI4au0nix1UfRAx8cdxgtaApQW2ZWirJBlAp0zSokgLfKRLbxibG8AK0PIMrJGwMLGgszHy4CQ0Syimx9UZVNfHo9oyDRUhuDC4WL08uMR7tw2w1LZRsPx4YbEzatnLrLnEoF5raczZAvGEKFPrmaBArzjnlqJgYU7JXtX0QAqIFeRc+4hSjgIp3vULPGn/xMZj+ViYcalZZlIBaBDHGUcYwwCU6Yk+jaY/Fyko437tEbuMQY0Ifqee90evOuMPWkfn2DN2VlvVZgIumIJak0KLII4M1Gti2YV7Gyecx458UsxeUSXVt88gacZkUIoeAI4zU5jT+5BK/SRjBRR3zoKe4SvaE5YDulkNB2a5IjDqE+LzBkX01pqtfmz1BNse3El297HrzW/axj10+c3FdHDGo7SjI+EQIVWvaeU8QjQKYbzvVHwfRzs6CGoGSDUnfZDsCHRqrr47oez3RBSlof5I1kitYE3imG7+PNna8ZNNAqryS7cmqCJJDor2V7B2wh1IJV0SMCIwuznRYREWbiATCbq3a/X8ALl7cf3xX0u6umhtDC0dkzw3sVuWHDbfZo66kv9xwvoe+mmUtp/bH6aE0WqFoEyAu7TYHAZA0/M3cS/ixXHRVYDRX2xP+fcDqr/fX8ctuC1jR2Ld/CkNrGECpoUYJCZFI3cCCmWCgtpsmiAcsJIfyK8E1RwM5O+ghaWPU4wKcbPzqs+QhFMY3MhutkeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When scratch area fails to reserve, KHO prints a message indicating
that. But it doesn't say which scratch failed to allocate. This can be
useful information for debugging. Even more so when the failure is hard
to reproduce.

Along with the current message, also print which exact scratch area
failed to be reserved.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 49bf2cecab12..636bd96780ae 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -651,8 +651,10 @@ static void __init kho_reserve_scratch(void)
 	kho_scratch_cnt = num_online_nodes() + 2;
 	size = kho_scratch_cnt * sizeof(*kho_scratch);
 	kho_scratch = memblock_alloc(size, PAGE_SIZE);
-	if (!kho_scratch)
+	if (!kho_scratch) {
+		pr_err("Failed to reserve scratch array\n");
 		goto err_disable_kho;
+	}
 
 	/*
 	 * reserve scratch area in low memory for lowmem allocations in the
@@ -661,8 +663,10 @@ static void __init kho_reserve_scratch(void)
 	size = scratch_size_lowmem;
 	addr = memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES, 0,
 					 ARCH_LOW_ADDRESS_LIMIT);
-	if (!addr)
+	if (!addr) {
+		pr_err("Failed to reserve lowmem scratch buffer\n");
 		goto err_free_scratch_desc;
+	}
 
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
@@ -671,8 +675,10 @@ static void __init kho_reserve_scratch(void)
 	/* reserve large contiguous area for allocations without nid */
 	size = scratch_size_global;
 	addr = memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
-	if (!addr)
+	if (!addr) {
+		pr_err("Failed to reserve global scratch buffer\n");
 		goto err_free_scratch_areas;
+	}
 
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
@@ -683,8 +689,10 @@ static void __init kho_reserve_scratch(void)
 		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
-		if (!addr)
+		if (!addr) {
+			pr_err("Failed to reserve nid %d scratch buffer\n", nid);
 			goto err_free_scratch_areas;
+		}
 
 		kho_scratch[i].addr = addr;
 		kho_scratch[i].size = size;

base-commit: c37fac0551448c68e36f14782acaf662c7a1775e
-- 
2.52.0.457.g6b5491de43-goog


