Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD29AC5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 02:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1276B0095; Sun, 23 Aug 2026 22:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82066B009B; Sun, 23 Aug 2026 22:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE856B009D; Sun, 23 Aug 2026 22:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9066B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 22:46:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 125E9A0438
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:46:43 +0000 (UTC)
X-FDA: 85134625086.12.F8450B6
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf16.hostedemail.com (Postfix) with ESMTP id 252F5180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:46:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=I2RdeO+i;
	spf=pass (imf16.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787539601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNZbPImN1HBVjw42D9IBO0B2LYorjmfZ4vM9pHSZXPA=;
	b=uV5iHVS4tRCCuOBVfeW+kuEe7WlLMD8ECulPDh+q758D9t8X71mM2UZmzffI0aW9kEsET/
	FBsnEUDviDTi8dR04guMVM8mN4sqzk/zLNzm5ZdM3Vb4AVAFxZItM0urqjx9CnBDzgdGsu
	2+gfa3dTAhzLiX2SsuGJ/kqO6Z5vK7g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=I2RdeO+i;
	spf=pass (imf16.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787539601;
	b=27gY5EgKGoVi0BbNJMoH6XVXz1MEVPb4DxDQRURBeqfZvj0SHRR8UYoYV1A9LuwoviBfZj
	NjGDzfnr2IT5XuC7a1nWFx2TWQgexfSJaeS3Px/Vcm6aXGXBgtXjnICJcXDX0dAPb2DDPK
	uHytOgdsOG2Zw6Og4zD5+Ix5gD1jXJk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pNZbPImN1HBVjw42D9IBO0B2LYorjmfZ4vM9pHSZXPA=;
	b=I2RdeO+iwb22nkG/IYlzNCm9HdhqW7GckDNeGGN/3EmcJ2TiP1syF4ThvRRNCX2uBpDHdCrdQ
	pRAiQ1xQ4S1Way6fXAwqUobXUv+IydhgMSqP8gaq3gVoEZbAap9p9+qYTpplARZNSyq6JrG6c5A
	9sIP94/YG/HyLTu3suFMpFk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hSw4f2rkYzpSvB;
	Mon, 24 Aug 2026 10:35:30 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id B608B40538;
	Mon, 24 Aug 2026 10:46:34 +0800 (CST)
Received: from huawei.com (10.50.159.234) by kwepemo200009.china.huawei.com
 (7.202.195.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 24 Aug
 2026 10:46:33 +0800
From: LongWei27 <longwei27@huawei.com>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>
CC: Pratyush Yadav <pratyush@kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH V2] kho: Convert error handling to immediate return pattern
Date: Mon, 24 Aug 2026 10:44:48 +0800
Message-ID: <20260824024448.550552-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <00c96a62-f783-497c-a7ac-1de495e4af06@huawei.com>
References: <00c96a62-f783-497c-a7ac-1de495e4af06@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.159.234]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Stat-Signature: izyj1t7ze9pyphcgrj5z1erk67upqb96
X-Rspamd-Queue-Id: 252F5180005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787539600-531093
X-HE-Meta: U2FsdGVkX1+tE4Lqc0I5kC5UcW9eaNQqA1x47EIqKglz8LOpQ112rdicxoKfQLKZTM8PbdLk98guJpPwwuVESg/v83Rz8s8PxxZqNphkhpl81r3FzzuOOKqoPp+hEhxwSIWcIpoSjilKtR4yFn7tNykQbko9tqqs65mu58Z/Dd1AxjImuc9IyRlIJq46+kcb/xe16zkzwTpT9trB8I+GOQujBAi+Omu+wXb+0SrvpydGnn0ug7MUBsIHiguYJOugkqC2NxtYik+MENVqrHzG4S1cyj9ahAyb9S8mXeAMcGf5+exuNwUKFSd9o63aZCGJiaxg4lMZM9nLhZWFI+jvcVcHJupEm4KeqLRwh8zDAU3LVHQnV/X/1kJEijzUbJCyw6ogUcF7uj/NEeXIpdO5v5sgjhrMq8KR+hJY7r1FmD2DQlrYRPp+ZBXBZi0+U5eK5k0ofMHX1AHnbQ9ulcMVei7t5XckBj10wP1bWIFl0w7UrO23T7FtBtg/6lukxeqNIWuCAg57SOyUN00Up2TC1fjbeYU8HlhM4mc9KL2LSeTVQqcUAE2OYoXYua9TDXaxyxp5uQKiBL/XwYZZ5gzbGFrPTRWoqFzdSIu7MmgiMVKC+j8vDAoveQvkCwrI+ybaxZR8RLMGMRnQijNbuo5cU8+W9dm/EQv2i6hZS9gMkjDa5G9qDoPNtgBogHcXM9ttIFzjhJRRN6saiWuw8JaWyAwhEFn2qCN8JC19nABwVggicL4Zn6De0DZhjp+M7af5bKJmm4X3yuzn3bdMpxeQBZZnncUId+0OsUnkYDP32JuSschPHeTsLm7HedqAckqtclxRt66mOqSqQYfzKkcga9KxKOCKKXndDZ+IYu4AsrfUZxsgPQx7MYIs8/5Jz1Z18x64ojJgpyd7C+XPHiGSVpJzUkJD20cdHbf5vxYY29NcgwO0wk3ZeHWvez+Dq4F1dKRLMH9Zm9uuBJ4t/X8
 WmWBlIDS
 ggkqwcK4fA4qLtJVDSAU9W98btxSomBPsJwIXc0/0pOgIPf4bcDDI2CCpLOTiEm0EH/7Tawyhtcao5i6WuxCehbFLH14jPrqHVfRJT9Q13U+Hx0LNobXc/L6tvk5K2gPi4wkNN9CQRbMA/XcjrCMCPhZlY70Z6LuXrdk4kYjZcnqZduIFqmKGtt22qBC4crJ3dvc1d1g711SHj7DugdaFB7WqIHaHdW6yG0S37YgwBRJkvzQGy3qyNCA+6cVTg57VmxzP7DJDZXLmi888/oQjpiPAOy5TagvIvcST
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Long Wei <longwei27@huawei.com>

Replace the chained error accumulation (err |= func()) with immediate
per-step error checking and early return in kho_out_fdt_setup().

Two problems with the current approach:
1. It continues executing FDT operations even after a failure, which
   is pointless and potentially unsafe on an invalid FDT context.
2. Bitwise OR of multiple negative error codes produces a result that
   may not represent any actual error, making debugging misleading.

Early return fails fast and preserves the original error code for
accurate diagnosis.

No functional change intended.

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 kernel/liveupdate/kexec_handover.c | 32 +++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 175c08a6e..93443ad84 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1438,20 +1438,34 @@ static __init int kho_out_fdt_setup(void)
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
-	err |= fdt_finish_reservemap(root);
-	err |= fdt_begin_node(root, "");
-	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	if (err)
+		return err;
+	err = fdt_finish_reservemap(root);
+	if (err)
+		return err;
+	err = fdt_begin_node(root, "");
+	if (err)
+		return err;
+	err = fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	if (err)
+		return err;
 
 	preserved_mem_tree_pa = virt_to_phys(tree->root);
 
-	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
-			    &preserved_mem_tree_pa,
-			    sizeof(preserved_mem_tree_pa));
+	err = fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
+			   &preserved_mem_tree_pa,
+			   sizeof(preserved_mem_tree_pa));
+	if (err)
+		return err;
 
-	err |= fdt_end_node(root);
-	err |= fdt_finish(root);
+	err = fdt_end_node(root);
+	if (err)
+		return err;
+	err = fdt_finish(root);
+	if (err)
+		return err;
 
-	return err;
+	return 0;
 }
 
 static void __init kho_in_kexec_metadata(void)
-- 
2.43.0


