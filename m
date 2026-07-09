Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC8EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB3C6B0088; Thu,  9 Jul 2026 13:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2C76B00BD; Thu,  9 Jul 2026 13:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FEB6B00BF; Thu,  9 Jul 2026 13:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C63766B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:45:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D64061C8179
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:12 +0000 (UTC)
X-FDA: 84969949344.15.4FFF2CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47735A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RlW3SLa/";
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618751;
	b=XvuAST1Hc/rL4HRWtwHFQhIfQqF5HXFdXOxgc2c+WLVp64IMPjVyYBxC1/wdbkSIFmm4Ny
	62SlqlNIFPJi4ZWmv98PrBFxZOSqdVHgGKi5MkyYkWkfwxNIsor0qVYFckFUMWdFWcQQyk
	c3DmDRP8KU/1HyjsgwyALNeoYeyCB7A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="RlW3SLa/";
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgB2xMhCheXYxaDaTXd3qxlc7A2ly9v83pGoMbOAmws=;
	b=pa4/13DsugY+JUOy6rrGvN6N8NWWi6DQTz3txFClgB8LBays6IIUbt9UWBl/6TJfafrgEh
	jABhHF2ebIlpwo2K40X7pB98HQ26+3bo+R/LpEZ/7mEi/C1bR3uPSPNkSJsWRg6nwM0KoQ
	ah3ZPDGRRb8D3yPdlmSfNb1I5tu9OrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6B8461836;
	Thu,  9 Jul 2026 17:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0CA1F00A3D;
	Thu,  9 Jul 2026 17:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618750;
	bh=dgB2xMhCheXYxaDaTXd3qxlc7A2ly9v83pGoMbOAmws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlW3SLa/7ACatTt0jZ2TGxgUhFDYqGkZzFlokYqAgVzHR7YUv5fO80oyI3obRxQma
	 E+1avjG09445a841Dj7dNYSogNub6lOhJTHMC9mPHYPl65v550aLUdqn8h1m+SmXIX
	 uMuaYw+QI7uJCIqBt/M9vGyfHzOhSlUgtsC3VbsWmXAcFrd4HIUWK3CpQ4RJrwh4xO
	 EiFs2M0Spe454LDUALw3E2Gg4hPnKzlpyTBhpY6ipyr4vef5NlHbyveaO5bbT+RVP8
	 MdWJe7FbzAc5dinNreJF58+0w+cIDnutUn3dCZD3OwlqrXaqVGoXXCmBDf5furhlgr
	 OotBLs7sBSajQ==
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
Subject: [PATCH v3 15/21] kho: initialize preserved memory map radix tree earlier
Date: Thu,  9 Jul 2026 19:38:04 +0200
Message-ID: <20260709173821.429921-16-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47735A0004
X-Stat-Signature: 9rtjtoo76jrc1nqj7heg8c9eyjjk7ybh
X-HE-Tag: 1783618751-620556
X-HE-Meta: U2FsdGVkX18rr9e2gTQBujRPpnRv9EXh2kEEVN403kweX0IznkH2b75AgUszzqr2p9wRlHezMBwhObnjcPflydrIswGwDK6ieTQ8Eks/BPvqS4kvBxFERncJHN+CGPMyVeB/nbVL3LLlCNWg2JOEFxktZOiY8zgiVIEarOgxjZl036cwJx8xvmm6rEtuzZUjZh5N094eQWGQUJSps2k1I5dhDbm58xvO1Nz1oZgv04+g9EXuLMZokYVBNzf8H8q0WXhCKLU3RStnSN+KS3cuZniWgu619WoFOxSCQZQjlvVd27PJ+U986VOejw+J2DQQXGbSL40igyK2BG+vGeoUxjh5GypnBnJNrqhHvSkmbh8XBB+Ft3s14Zy6FgDz2eAr39qBVvBkuw9U8HfAj9FWW1S1l/W0VPjYtI+LW4xUrC8dV5kCxOcPXLbCjqXu7Gg0XJjPRjdfdkahwLFP9HIt2e5KPsAYP0xH1Ip2iC8NIyqQr3sOSOEMJ53kynx0A3fjdP30chtCdmGizq4d45Kg00j9mZNjtBifN2fSmD5cA0tYFCYu1kG0sykj4wvbCQXZwgTBhmxeIeOaKE22c7bvNUw94nw3HS9pVgyByM/ndAxJ7ef40jDq4mfsxvs2k+wTf5VAgdiRKaWj3wFv4Mdfs9glqY6Pghy+h18Rmeguy7uKS4l56hY9k0jj0oye6/lRtzC81bTtyGvnPXyGMkQOSvXlzM9EQIQ0zoAxpaNPHfI22yPtn7OtiXYw2pF7vmPGo/ooj72PWooFaijmrtHUNTwfM8I+YW0E+Q60Vy9egdwuwkcw+/Zj+U2YXILR5vterAIw2ewJIEXSesbTbWle5dSzgSwYFj17okAnG6QROdPERqH+a9Nh7pwOIE4eYfOdiL6li97zBJ7oe6oAqMhwMTuQUhAsBKf4lAEz9Fvf6feelyarsLYbgVHbIrE74kr7TmG5OXy53c/JnGhWs3H
 y//piUeT
 GC3K6rPugOnVDlwC0OOpUxeFRPRH23YiGye1Qjpsh3fHyO+QetA9IXqz5pxR50R7X4X8fG7pgPQfOeZfif8mf+RKcaKb1Y3C//AjaCeUAaBV0noNlNvic7CHvURmaENweazEASthsBxlP1v4gh1wGwQDvb6pBaC0XpK2HPZYgy8rnChGy5ESyUYUMKrWkNzNTVnAvqW65tpGWfolAPQzeQijfLBRw5tyXwKszWIefeqv0Ulc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently the preserved memory radix tree is initialized from
kho_memory_init(), which happens relatively late in MM init. In a coming
patch, the tree will be used from kho_memory_init_early(). Move the tree
initialization there.

Simplify some of the code in kho_mem_retrieve() by getting rid of the
err variable and jumping to err directly.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 2ddfc804cdf7..6e8682469bd7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1531,20 +1531,8 @@ static void __init kho_mem_retrieve(void)
 	const struct kho_radix_walk_cb cb = {
 		.leaf = kho_preserved_memory_reserve,
 	};
-	const void *fdt = kho_get_fdt();
-	int err;
 
-	/*
-	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
-	 * catches that and never sets kho_in.scratch_phys, which stops memory
-	 * retrieval.
-	 */
-	err = kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt));
-	if (err)
-		goto err;
-
-	err = kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
-	if (err)
+	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL))
 		goto err;
 
 	return;
@@ -1756,6 +1744,8 @@ fs_initcall(kho_init);
 
 void __init kho_memory_init_early(void)
 {
+	const void *fdt = kho_get_fdt();
+
 	if (!is_kho_boot())
 		return;
 
@@ -1765,6 +1755,20 @@ void __init kho_memory_init_early(void)
 	 * early.
 	 */
 	kho_scratch = phys_to_virt(kho_in.scratch_phys);
+
+	/*
+	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
+	 * catches that and never sets kho_in.fdt_phys.
+	 */
+	if (kho_radix_init_tree(&kho_in.radix_tree, kho_get_mem_map(fdt))) {
+		/*
+		 * Failed to initialize preserved memory radix tree. Clear FDT
+		 * and scratch so KHO users don't treat it as a KHO boot.
+		 */
+		kho_in.fdt_phys = 0;
+		kho_in.scratch_phys = 0;
+		return;
+	}
 }
 
 void __init kho_memory_init(void)
-- 
2.55.0.141.g00534a21ce-goog


