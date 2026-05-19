Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E526CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13ED6B0092; Tue, 19 May 2026 12:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4B86B0098; Tue, 19 May 2026 12:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAF46B0099; Tue, 19 May 2026 12:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88D616B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:06:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C73A1406B2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:06:07 +0000 (UTC)
X-FDA: 84784645974.16.D38CC7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A35A6140014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:06:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qY9x92Pr;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779206765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9QW5SgZY12q+CtgpE3Pdsd4CEZVaIO577Em6GvO5TO8=;
	b=NfokxI+WVlZ26JdiOYM1OKUC7M/uS27xyh4aBxPfy+0zQewH9CZbVFMZDKy4IxOSOPyTR6
	EOXDdmTWgovZ865wySPGW8ydLVKUAUCBpEoUai/wSfGd3+MkDr7ZU6ujQ1B0R84YdIf5kE
	qCQd0DTodLQbePnpZflohC968FPzUng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779206765; a=rsa-sha256;
	cv=none;
	b=6IRnKtoN3/WZaXcA921VrGHL9n2sJZe+r9XW+7XEI8w3LVIri4ffPBtDsEMgIkCgPWfkC5
	5ZzPMAaWIW/nXqlGjNFT9CnCRSSAXUPGRCfbbGA91CrjZHartru1pI9QarmEx+gfl9l/zb
	7GHaHeHamO+RPgoqBxuWPArk3zkqWGQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qY9x92Pr;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3884660145;
	Tue, 19 May 2026 16:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C34C2BCB3;
	Tue, 19 May 2026 16:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779206764;
	bh=3G28d0TOyfNRinSp659QFq62b49e9yvwWyjT8rXN4fw=;
	h=From:To:Cc:Subject:Date:From;
	b=qY9x92PrTGloGMB4sUwDGgLF5j6PDvzeOQDKL4aKnBN+UdjLDRJLp8M4OhkH0o0f/
	 v34wNqWmM/VimJEDe5e1axaWRWXocyGKR6cWpMAs+hfake/ZMolhuYIdXauXdv6Z43
	 C9Lf46v9wMzUX2HBhfo4vkdIRUEcBwCmzArpc0DXnR9W5Ehv07QpSAfM7VSHqFlGmC
	 6gZ8RmjgSn5/KzNcnP/8Ov/aRKVGkBBrQNTHa2OnMgj78lNa1N1uF/WMyVaoX0d7Ac
	 atazB59bpZ1DxNW8juJScVZDXLqjM3PRxw1QOQ1HwEMYzwriQ8HkQ4WwF9X/1pLTuQ
	 KFtCIzvbMnZCg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Changyuan Lyu <changyuanl@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: make sure scratch size is always aligned by CMA_MIN_ALIGNMENT_BYTES
Date: Tue, 19 May 2026 18:05:49 +0200
Message-ID: <20260519160554.2713361-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A35A6140014
X-Stat-Signature: wqp3pahejgecsb9jqz6ubky7pmdquqk8
X-Rspam-User: 
X-HE-Tag: 1779206765-670701
X-HE-Meta: U2FsdGVkX183zzyEFsSZm48osApafLPYxE84lFG4nQ2gdeGVIxLTtRQNzAwHsWAVMqcltMD639POPwz8peV7aoPfbgdhcBTJKlegispl8zcylf712xVp/a3vNRhbB64cxhklOnfFj1Z/hqK8sMkpk+zLqsgppT52hbYgbngcDIZeH+KS7GlYqIzTCQCmjnn2pv5vePYeBI1TQqHugAZ+GvT7yjjorj0oceO7Ta1cfHyfwJonYXRVfEfPTDTWjnZnFcFEseCGNJzmZeqN6uoPyjbQ/a0/W6eTJm2/8pZ8taE6Rsy54WW9XyNz9061gZdY0whpQ8+55N2eK1HkR0pFcdumBs1KhrLJK9H67qS1h98o8vC9cBXQzLtZDUssSA8XRc/6OrDJQSetfPsrkknFXOsDOcxeNHRJOsQjpbRQ6+kTPytW3Rfr2jZxxPVssugtO+tE/WlO2J0OvXBHX/gkYS/EmPcQo/2AklVpJYE/4eNTPIPnaP5FFqObtwUync+q5FwBg2DNiH+uveQ3LveLXULCJrQ7QsBWV1lwG6SnnWLraB7s23VTv5KyCwEoRSM85pal0sO5y2dpOnd3PV1xE84+/uKY6g7a6+VS7V5bxE8b+5uiQebn/oVx/LqEmCCkMU5ly/d3Hn9xr8Oo/eQLeRpn8rFTI1190t5k9w/LNhhb+WR7IXigWkRIk1uj3cUNyPBkYrsahiyMpjfbtaDdN002Za4M6eb+eOuZcYEPKIeZ4FdCVSr2o2qgqteACNvebRf1VTHsq3koDp0COs7Ydwvs5U6E+IntKVLaoISQzRn1L3C93L0cembdaxb/VIh2EcpvPBOtF0DsCXgzaHOWHt4WiVfRzyyS7xIeDsupifVPQEmt4+3cY94og0bVWgz5Owb7c8h/oMI7E8JYOinQvkC0NCtw6mfOF+ydrHgJWkjLQiv9dFhFmYwa9qSfAgpThPZrppaNHCUc3q+qtBM
 dfyIh484
 QzKnZLiliZ1q4Z8by9EW1PJjMaKujty+UBG7mGUquf7/qYvB/5S6ycWh4DMMo9AwX/x8IsawAOAjDpxokgNtfgIICCYSEfIUz44yNb5n5YINwpjmRyBoOTpiuyxz2FA7DMu19sG+32I3Pol7YFFRDaj6SC1Ps3QI2M81jcZOOz1l63lQenVXW93WyH1L4u997zM2I8EwM24PT/JRKesCokhgxuQow3vu3u7ODQq+9v9Y+Fjh3PhKB+HCuY17ubMEADFYErejwpyQGPtC8HFIWwhrHgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When using scratch_scale, the scratch sizes are rounded up to
CMA_MIN_ALIGNMENT_BYTES since they will be released as MIGRATE_CMA. This
is not done when using fixed scratch sizes via command line. This can
result in user specifying a size which is not aligned, and thus kernel
releasing a pageblock that is only partially scratch.

Do the rounding up for both cases in scratch_size_update().

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 32 ++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4fde8325c49f..c26e4df37479 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -607,20 +607,30 @@ early_param("kho_scratch", kho_parse_scratch_size);
 
 static void __init scratch_size_update(void)
 {
-	phys_addr_t size;
+	/*
+	 * If fixed sizes are not provided via command line, calculate them
+	 * now.
+	 */
+	if (scratch_scale) {
+		phys_addr_t size;
 
-	if (!scratch_scale)
-		return;
+		size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
+						   NUMA_NO_NODE);
+		size = size * scratch_scale / 100;
+		scratch_size_lowmem = size;
 
-	size = memblock_reserved_kern_size(ARCH_LOW_ADDRESS_LIMIT,
-					   NUMA_NO_NODE);
-	size = size * scratch_scale / 100;
-	scratch_size_lowmem = round_up(size, CMA_MIN_ALIGNMENT_BYTES);
+		size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
+						   NUMA_NO_NODE);
+		size = size * scratch_scale / 100 - scratch_size_lowmem;
+		scratch_size_global = size;
+	}
 
-	size = memblock_reserved_kern_size(MEMBLOCK_ALLOC_ANYWHERE,
-					   NUMA_NO_NODE);
-	size = size * scratch_scale / 100 - scratch_size_lowmem;
-	scratch_size_global = round_up(size, CMA_MIN_ALIGNMENT_BYTES);
+	/*
+	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
+	 * size.
+	 */
+	scratch_size_lowmem = round_up(scratch_size_lowmem, CMA_MIN_ALIGNMENT_BYTES);
+	scratch_size_global = round_up(scratch_size_global, CMA_MIN_ALIGNMENT_BYTES);
 }
 
 static phys_addr_t __init scratch_size_node(int nid)

base-commit: b1378127003b61930ce30064328640503ad3ef6d
-- 
2.54.0.563.g4f69b47b94-goog


