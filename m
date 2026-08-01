Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E02C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2020F6B0096; Sat,  1 Aug 2026 04:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C3E6B0098; Sat,  1 Aug 2026 04:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C96A6B0099; Sat,  1 Aug 2026 04:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD6AC6B0096
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63EA34027E
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:09 +0000 (UTC)
X-FDA: 85052076018.26.503FFE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C7D1E8000B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OhXqkXdt;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+DZv5O3y5NnEgeX2qKFyTmcPLYk4xvi9rQcOd074n8=;
	b=OM9HtvklwOjoprr0bXbB0oLupbyj3ItkUHuz8fW8Er7mHV4A5rSsx4skU6cq13lm6JxpCK
	RFtxaSWEsPhdv8QmkPNi2NT+ej4w2bTSBzYUdf0VZMTll8unZmWG5hXXv6JD3qRq7dhvQS
	JfRvTCHybpEArsASG0vcbdgLi+0Qee8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OhXqkXdt;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574147;
	b=v8LSJhbhP2vbJszv36x3P425QqmCgMezxfwoA+qDyPQVqnzYQukfT2IrdGHriJCmwJvoiT
	KaXEF3OqWVAM99Zs4rYMY7oi4HuMDIJtZRVHJCieP2LtvJmmN6/JzeEW5BuxrexwleOCB2
	ROU8YNcdpbRY/mzNrRZl52FgpXzG3yo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 597D960AAD;
	Sat,  1 Aug 2026 08:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060361F00ACA;
	Sat,  1 Aug 2026 08:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574147;
	bh=W+DZv5O3y5NnEgeX2qKFyTmcPLYk4xvi9rQcOd074n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhXqkXdtf/qGCpwbtSdDnWbV2wKwD8MWHWKkhrruGTMO8Ym2K0xMs9bowsWda8ygh
	 mtmdF2YGLGnXBezEYsM3exCChKzG0WsDxJf9EZLAeA0FG7LTbN5tQKdQO7qLzl8eLt
	 bJgEaxtIkPn4IQNHwdK2RShieBpN3VFZtkkViPsAVEEHmerLdz7XXD+WPi4pVWoyE2
	 aDb4xc6BDXSe26JYjEwBDHr0jS6W141z18d9GQEX2ePgMMO1BJdYY4L9IBUyOdjjs1
	 7aucco5zCmCIARZp4SRcG3DYbz2lluvvHwvDyIEPR3HuYCv/EA3cCIFfZf03GbNSW8
	 nW2zZqgNbfyTQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/22] kho: move all memory retrieval logic to kho_mem_retrieve()
Date: Sat,  1 Aug 2026 10:48:15 +0200
Message-ID: <20260801084833.1897543-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C7D1E8000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 68yn3dgcr837y8kr1odoppuiaeuz4u98
X-HE-Tag: 1785574147-773600
X-HE-Meta: U2FsdGVkX18kvKnFFn+18OahylDn0NrlRPKXHYadvOojhmBt4ydtW3cnDH2PJBocf8ta0Ra37KjDtbSY9lnyGZw8CunvF33YctIQODwvMcDin+9qgnVKwdVULYdI+rYTMmxkJF4GIcs23u2/5cu+NU3RvxF46Xp/FV69MMldBrOUcIjFQtBTs+Nx0Yi0s6qt+KUrBkSV0BW3nB5NsDP4lQFEaRN4mfh9o5jYpESueimR4c7W5/QCNGQHzeGvtx7JT2iAOlK/lUG2eQfo9poqaklsiIBhnekxMNw8Toh12+1Gt45Ri6cs6Il68Sz6K+RBC6alNzq/dym3y/xEV/2bM2oVMCqy0L/LaX+IJfXfebU9kWTdUML1JiaYyiCAZCvpJG4tcR1dcJoc6ClWYxf8CObPksm38lHHC7/5eeHHYznXRGtyzmbGKKb2JVlV7hdHv/2TkHlXDR3OPjaLdgFosNNJifLhZ/AadaxyG6/R0I9hYiwLST9g4BcNAg/BUmP6+ceDu7ieqDdqV0pDoZzD4Vq4ax723oj+eN76118etSnO4/q4qg98y1Vzq6eeIqARRwVoXWy0WUIZSCUUUaJ9gMljdnQZeIPEsxFK3HYXQW3ajc8v31/fJSajAezHXIQm325+M/W6Hfxj1Rp26vhJipdIr5S0r3uzb+uB/NOdk329aothzwUR/95Tg5AZhxa9V1ZHJ4eEJMLdUd3QwV3+Kvki9IPegTO3kia25ygPEs1OOoFN0cjCx8ylAgYMG7qEPbtA41YLo+dTXAPJvBTC4mPXhRI7rQpSlyT3xXZ+vUQNsv+hRIiD6CqftiI8Y4GI1o90mtS1B+lpBkmCeMG+jgIj5HFGncPznI8l3cw3bAZk9r7GGrUVpOdWA+d3ZcJ1Bkqgq+YDLCRdTpJGQb7+PlL8XQSuasVz6Aud/7byXGtgkWfgLesiA7+TWgAGKXjT9nOWqNFQKk/J8E3vU3+
 FG1kUHas
 kdL7OOMjovVsfCBE8xgNcDQVsJm/feXfC8sQzzw1aRDCTtIFxDQ3QjV6FU1w7Iz5cUiQLZPCve4BWIHUo6szcx0/O2OOXh0N6EUNeHmIUMXtFiWCGMo98/1uPaF46LBulfW/j9aobxlDAt4c+NVC3e1JfynVkRaR2ZffXhfOLlWd38f5mroB242xaWtFVyI5rpcxeuASxDt4CptHSjBeDToG/EOIzxUYpJRG/pfUxd3JsUCqghBlhcDQ0o7XU6iV3xoGovHMSApoxrDH5LZ5fm4PH2r0UZKLE4ZsV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The memory retrieval logic is spread out across kho_mem_retrieve() and
kho_memory_init(). The incoming scratch area is initialized at
kho_memory_init(), and the error handling is done there too.

Consolidate all this logic into kho_mem_retrieve() to make the code
cleaner.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 31 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b53ae68ca087..e3408e1844dc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1415,8 +1415,13 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
-static int __init kho_mem_retrieve(const void *fdt)
+static void __init kho_mem_retrieve(void)
 {
+	const void *fdt = kho_get_fdt();
+	int err;
+
+	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
 	/*
 	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
 	 * catches that and never sets kho_in.scratch_phys, which stops memory
@@ -1424,8 +1429,16 @@ static int __init kho_mem_retrieve(const void *fdt)
 	 */
 	kho_in.radix_tree.root = kho_get_mem_map(fdt);
 	mutex_init(&kho_in.radix_tree.lock);
-	return kho_radix_walk_tree(&kho_in.radix_tree,
-				   kho_preserved_memory_reserve);
+
+	err = kho_radix_walk_tree(&kho_in.radix_tree, kho_preserved_memory_reserve);
+	if (err) {
+		/*
+		 * Failed to initialize preserved memory. Clear FDT and radix
+		 * so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.radix_tree.root = NULL;
+	}
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1629,16 +1642,10 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
-		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-
-		if (kho_mem_retrieve(kho_get_fdt())) {
-			kho_in.fdt_phys = 0;
-			kho_in.radix_tree.root = NULL;
-		}
-	} else {
+	if (kho_in.scratch_phys)
+		kho_mem_retrieve();
+	else
 		kho_reserve_scratch();
-	}
 }
 
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-- 
2.55.0.571.g244d577d93-goog


