Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BC1CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CC26B009E; Wed, 29 Apr 2026 09:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D3E6B009F; Wed, 29 Apr 2026 09:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25E46B00A0; Wed, 29 Apr 2026 09:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 973436B009E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DF121B7949
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:03 +0000 (UTC)
X-FDA: 84711701886.10.985F045
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91CC480012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ibdizt7x;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+blxjhrsDzVQ4iNicwy10DCQOi4Qd3nXw1DYWinz3o=;
	b=JMiBMWqMqk2g7uehAYDZdTM/dcWPUzk+t7h3KbLWHV8+mdtjO8NbjF1HBDXw6YpHdx6R1J
	9JLf+QHwkkPcoa1wIrL7l9Cw9JpsAoC7dW8aafJhiVnn6n+S9GldlXxQ2O6PmgTyMCSiwt
	CoorhRu7uBhNeaCfmr87DQhONci+8K0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470001; a=rsa-sha256;
	cv=none;
	b=A5huU0fIHzcJ9dXAINcGX/Et5gPQBKEyGjM21Ju5pMOM1Vpy4AzlNY2p2kBfnkdYMCnIYS
	4nz8PVD0xaU7n0eTcLskYHTMn1Yf36SMV/t+miLV7rYMAu3a1XdDl1tGulMo90uakWfwLU
	4DUWr7c8rIAHAF3RieQKHsEYSNQyu5c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ibdizt7x;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1042761141;
	Wed, 29 Apr 2026 13:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC26DC4AF0C;
	Wed, 29 Apr 2026 13:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777470000;
	bh=HqMJ+mPvIVL4QAOFwn1zIYXnpFxqWfIvpXCdlh2p4qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibdizt7xQYLkjEzH1nGZoM2Q2T4NkpbCLjWvPZ9hNm2X5NsnDPnvpqQBJjTlbT9dL
	 QBe3QjWdKeP2QZTXoyeSAOChz4Ll1VBJkR2KJGURRTLWFjh52CBL46EvTTfoo/5JjE
	 HVRm5PcCxAWD8IelTrmisEN0L6+GjArxEV+FojzkVcdhW2/ufSpz/qsQmv+nFjnIrV
	 IbjcQXh8OhwLfVogeo1Tee4Iq9+WrlFVqFmMgxk+MJrbM1qNrRkLNTUtC8+WK+zFbV
	 ToH5+gctoY9A9KQcAadyk685ODGF7asEt9cK90AvI82wN7ScbyPoPxYTScE9/q41TQ
	 SoUy5n+oPnK6A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] kho: allow destroying KHO radix tree
Date: Wed, 29 Apr 2026 15:39:09 +0200
Message-ID: <20260429133928.850721-8-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91CC480012
X-Stat-Signature: gifqxst7ff1c6xyxwofw6qwx73irhyja
X-Rspam-User: 
X-HE-Tag: 1777470001-900102
X-HE-Meta: U2FsdGVkX1+JjhgEQQ0phF0RTdPZxqibU6N1q2muilU4UmLWRbmlw2CZXSht3WxqthZXdjfVp5OdY0pGn6aLE8OmALFn54iaq5n0T+FUaoKqYRiFM12OKO9ps0JH6v2u9GoyqsVfDVwqRQqtJPXk3VA88fByf1+3uKO9bWd9v4cajQl4JqG47XgQL2AB4zv1aWqJBB6khCqqV2iync03/0Ig/nuReDRxeAD2QvD/l56GddSne9/ein6g3J5ODlgkrdy/O8SDQzYrxqRtk7hHexqkiEV+Xlw4Du4R1wV1X/VPR5lX/mjXaMeyihF/g5GMQh5TjwXGoJIpjj14gatGaAJxDCW9ajUiMwAuok44z2ELwIfFRMesiF2NcucCQ62MhBYtZ7CtZbHl6zBTK3vYBiU+yuKxX68KS5/FEEMVZVWmyajeZMovP0i6bi7CUO/my8Bi2qQZTVRsaZpCh4ZZC2t/NffA4qwL07Qud0CSP0D5laz+WlzvqG0RFa0GVA8qS747i39Yh/52Zzas0t5cPOOqbCLTZcmzVpbi1YZyja0GupOBfbhYeFmOYbFZOw1vmJagpi1PgG/vdV/izuZtEZ/sNDpZ3xIatzt0rP1pcMqTNLV/P0a7ZWF++4ZLqWKwRvXGockYOBud2z5E4RGN7THwgRKGHlnVeqU5qFqcSfeQLIYDhCo8FYFMinkqUD//x10LK0Aiz6k3Klpbgk+lBbE9/VIxfN8kXujH7SkYSHwVvZnLQtBoPdxOE0/7jlAtlPS98pF7KBTOw0M8KGtBoGf6jJ7pvdG4L966KHOFFMnyNtXSdLjPGAKo9Qt4E39KtJYJvTlb1hNtIBMQEBb3GKEcDgCmY3mG1v0YFVxxvYn5L357x9kxKXgcH2E+EvZ/Vva0FngnBOO60RU4yFoRi5ebcDNmrboGsZDly9FZlkUeUEgAjUoHBbhpRhG4k6djhGqF7+e1zUZV3+taBib
 cAVCOlbP
 uQwQkBJutyElT+BHKDAfttT7c88jnr6BHCziTGV8s6oevGw5wwDubUlX8YMBx05nv0aF+Euw51Y3Vjh+Bl2DCYP+pbZjsUnTARK/44zy4XqTgwG50S7yEkg1mSDZBQGJRDOzCV2zAG86F6lU2sZWFHMMRP/kzKtn3yBifVwk49WzyaLiRUaoBYy7UV1M6ZFbFSr1vIu6EZYl30x3EtPcSQ3Wtcaoihyu9Vg9tbyjlTwBLSlP7JCKdBnMHWaqJAapyOStCxba+Imo0fWukkAKOQ/uRytbAEZp6S5V7zGbRxJAQWGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add kho_radix_destroy_tree() which allows destroying the radix tree and
freeing all its pages.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 34 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 6c0f7d82716b..617395a6647a 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -54,6 +54,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			const struct kho_radix_walk_cb *cb, void *data);
+void kho_radix_destroy_tree(struct kho_radix_tree *tree);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
@@ -71,6 +72,8 @@ static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 	return -EOPNOTSUPP;
 }
 
+static inline void kho_radix_destroy_tree(struct kho_radix_tree *tree) { }
+
 #endif /* #ifdef CONFIG_KEXEC_HANDOVER */
 
 #endif	/* _LINUX_KHO_RADIX_TREE_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 47f7c4a2865e..29479534f65d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -286,6 +286,40 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 }
 EXPORT_SYMBOL_GPL(kho_radix_del_key);
 
+static void __kho_radix_destroy_tree(struct kho_radix_node *root,
+				     unsigned int level)
+{
+	unsigned long i;
+
+	if (level == 0) {
+		kho_radix_free_node(root);
+		return;
+	}
+
+	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
+		if (root->table[i])
+			__kho_radix_destroy_tree(phys_to_virt(root->table[i]),
+						 level - 1);
+	}
+
+	kho_radix_free_node(root);
+}
+
+/**
+ * kho_radix_destroy_tree - Destroy the radix tree
+ * @tree: The radix tree to destroy
+ *
+ * Walk @tree and free all its nodes.
+ */
+void kho_radix_destroy_tree(struct kho_radix_tree *tree)
+{
+	if (!tree->root)
+		return;
+
+	__kho_radix_destroy_tree(tree->root, KHO_TREE_MAX_DEPTH - 1);
+}
+EXPORT_SYMBOL_GPL(kho_radix_destroy_tree);
+
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 			       const struct kho_radix_walk_cb *cb, void *data)
 {
-- 
2.54.0.545.g6539524ca2-goog


