Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970F8C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076846B009E; Thu,  9 Jul 2026 13:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E396B009F; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD7B6B00A0; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA176B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D0E78C212
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:47 +0000 (UTC)
X-FDA: 84969948294.08.E06D63F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C82F2100010
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0iXjBTs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618725;
	b=w4AcjL2he2IT4vnU2Y5F1IZGAKP42qzMSLWKWeXR5sH684vHA/ohnkd7kkEwwucLDEM/QU
	5fXd1lLGeL+DYLsf+RQU5Ea5RZg6T2I+aBjxXxq1fuoxWn/Kuvj0eJzRRjfnVN9tZKWWrf
	eO9xBjf+uxcO9mO4UfMsPTKUK5T2FWY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0iXjBTs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riMC6FrAK6VElTWN873G6mpWEL50ijB4MWBDV4uQp84=;
	b=kZSkM5+VyjxpP5epkg+58Vau/t9yXtrfIrSoa7CaayOxN76kRJo+XrwQDJ2twqh3eaRrtn
	cO7+fTw+/nSUBgwdV08tqpOVmnAxQY5wZuAnX6WalB9ur7eL/+W6VZ/QUf8bCa1IDbX4g5
	Pediuyp5TuUYiZhN+Yuul/IMqdCCIWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CC706187C;
	Thu,  9 Jul 2026 17:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40011F00A3A;
	Thu,  9 Jul 2026 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618725;
	bh=riMC6FrAK6VElTWN873G6mpWEL50ijB4MWBDV4uQp84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0iXjBTsR5wGA5kMrETM5gowhRr8IaK972IkfXU+BAYfsmBwLm1jAl289uRYIkimL
	 D44uq7rbFJKKGGZLusa9ZCoECzyZTt5L2NWFQg7ob9XxUkE11vhslTk2W3FZTPU3MF
	 c9+yeiZUGiquBWzK0Awll6AZUSDJbeb2vRmQm7aj0f9Zyh1QV6GwOv9IJhqIKpSIql
	 H3uNUtVva3OLjtgvXjv6l+gqOufJp7vg5PesaUCcZLMvAjtOHNxhd9Mc7l3wiaL2Pz
	 1/+82Qg9Y9zkk2BO00T7zlDM13aWdeG3xWxW4b12MoXfOea3Q65A6lDijR34NycxMU
	 aiumvSM67xYOg==
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
Subject: [PATCH v3 05/21] kho: store incoming radix tree in kho_in
Date: Thu,  9 Jul 2026 19:37:54 +0200
Message-ID: <20260709173821.429921-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C82F2100010
X-Rspam-User: 
X-Stat-Signature: hyoyne4u1z69dsdxzxk95kay9fprx8th
X-Rspamd-Server: rspam03
X-HE-Tag: 1783618725-776419
X-HE-Meta: U2FsdGVkX1/kvZhmx/8n/nc6nLlvGUfUd1W+vEMDNRdOyfRy8aAuicMpfdU/eJy1lsGSDyxn5xtPdXHdK98m3jduTEOH2de2Aw4yhf/vuOZLAYTtwvY0I5FUcwiONCLLts/4Z9hmbCvEmAwHj1i0i/ZOIFblSEeZ/CE8qr+9VwwbF/Z/sBaJ+sSmI2rRZObdqpPYUXKzxRVA97wnCs4HN/spfGXaYdqN3Tr/jCKqm3ImD0C9wu01zDfeT7VAZMcQsl+F54rD/LuJXc/K9IJ3U6jS5VYjWGNR2nsoOkn07m14gbncgnVO9F9rWhzkQY9Mus5sTe5wb7RfYhFOu0KQabNrX2VEKVhQhENlZJH13tGqfX94H6WeMPyjcakvrFLB5GQHK+S9TSbY9FL2dhe4o2cFT3QEmFoX+vC2t9LWmZLJ1IV1Kqjep8bVce3ZS2m+++qK4gKp+yAf2OfB32Ecddf+ROZjwvUDgmJ8tZ53AGscd+WSPS3lH824IL5Xtc1+IlmwJy9GO04UYuQClWeXS/5HQLteQkDYUh1aeAyY6wnYwEPP+aVeaQqG+l6gWnHxd1f+2Di1yn5B2PKepH2QFu0G5eNEMddZPkI7TM2hh/QboCFYO/aKodTpgSBgS9fj5fLHCC1qbR74OK74RhnRTa1pyLFSUn1++f46mO5bC0qGIBY3B5DAoWrUB7e7we6u1fSOXtP3KfUuIoPnkb22jFJ7El6c7BHwHfaMK3P9yhLomLGCLh/gKuuEiiq5DCYQ5Pj0cx1y3Qwzv2mGQTtTqnuXnU2Pmynp/kIicP8WhrCiUJAFRp3+6Lq+24R/sgl+0eHzox1PayO+YVyQiWj0C/HSKFWzL/5UZOVQqUi/4ktm/BWkiFXtNoXxDrdvC6KZw3sRaWGaon/Fodbuw3H6lc4BpEk7/uAQ0lK7w8Xf7JDBv2BJPQ/Bj2aL1oPcVcJtJWVNGmk5DWCYlSgZs4y
 7lLK8X4V
 aZiHST+yRhXtH7mkDSCo6pVRh2FsbjO2hfLqJg30IaPk77p8x7psgoEvb8EeKHsGvIHcMj0xl26eEwemXJTyCf2frB6pmxXizlsFdqus4R7WyIPGM7FAy8UYKzZ9IOQFZVS4WdUtW9Ob19WUL5X+3nhOWj1bq/T82sT3RoxLoJq6THzy//CGafcHsJckVTqpwk+hdnKuQ2AtcubojJA4dFVkQTRV6sKn8Cx390B0D71d4KxkmntEcS1MpfkUrgP22Cbe5A2th2XfaqdMzSnehaXCcyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

This allows other functions to also use the radix tree. While at it,
also use kho_get_mem_map_phys() instead of duplicating the code to get
the radix tree root from the FDT.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 32 ++++++++++++------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5c35c11c273b..b53ae68ca087 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1337,6 +1337,7 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
 };
 
 static struct kho_in kho_in = {
@@ -1416,24 +1417,15 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static int __init kho_mem_retrieve(const void *fdt)
 {
-	struct kho_radix_tree tree;
-	const phys_addr_t *mem;
-	int len;
-
-	/* Retrieve the KHO radix tree from passed-in FDT. */
-	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
-
-	if (!mem || len != sizeof(*mem)) {
-		pr_err("failed to get preserved KHO memory tree\n");
-		return -ENOENT;
-	}
-
-	if (!*mem)
-		return -EINVAL;
-
-	tree.root = phys_to_virt(*mem);
-	mutex_init(&tree.lock);
-	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
+	/*
+	 * kho_get_mem_map() should always succeed. If it fails, kho_populate()
+	 * catches that and never sets kho_in.scratch_phys, which stops memory
+	 * retrieval.
+	 */
+	kho_in.radix_tree.root = kho_get_mem_map(fdt);
+	mutex_init(&kho_in.radix_tree.lock);
+	return kho_radix_walk_tree(&kho_in.radix_tree,
+				   kho_preserved_memory_reserve);
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1640,8 +1632,10 @@ void __init kho_memory_init(void)
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 
-		if (kho_mem_retrieve(kho_get_fdt()))
+		if (kho_mem_retrieve(kho_get_fdt())) {
 			kho_in.fdt_phys = 0;
+			kho_in.radix_tree.root = NULL;
+		}
 	} else {
 		kho_reserve_scratch();
 	}
-- 
2.55.0.141.g00534a21ce-goog


