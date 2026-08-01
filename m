Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96485C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE9B6B00A4; Sat,  1 Aug 2026 04:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6436B00A5; Sat,  1 Aug 2026 04:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E016B00A6; Sat,  1 Aug 2026 04:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 087BC6B00A4
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B89B1601CD
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:31 +0000 (UTC)
X-FDA: 85052076942.01.0DF07F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8DDD40007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYbcsQdp;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIP40ogFtBiVnUCuMm5h3Xm4LIuYWOirEQzH1R83Mew=;
	b=b1Cf+Em0HZfGUUxtyizKkNPaFdnRuW4W2xAVgMdkWT7g3UUiqVwZnyjAW4NUBOwqW4/SrI
	YYD9gZRQsRIuBg9PXRS1GmiLZcFtpjCiRTEyV/VMw0Fqs8qyhutHts7Ma3AoDfvRo3uIhA
	QCWmgLzfKBt5ugsYmTvPxFPSWWoBb14=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYbcsQdp;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574170;
	b=awDtXbXpHFaM7L9C5sK2w200mnZQGMLdPyDJwniVMSEhFiep8kQLHKB9z9JwUxqiPrgUi0
	i/1CirJVPBeEJApCIxxXXSYXw7sMq/6fnjE3PfgbMYATFKueRTe04AHnNTAs8HzSocbUD1
	wiIGXlexpF/KQ1ALTi63gFuwvWtSROE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AEE44529C;
	Sat,  1 Aug 2026 08:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09471F00ADF;
	Sat,  1 Aug 2026 08:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574159;
	bh=qIP40ogFtBiVnUCuMm5h3Xm4LIuYWOirEQzH1R83Mew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYbcsQdpPGh+2huXVDCcRwMp6Fu5lh3biUI41fTfLPX2V8yV5zvYxlXgf6NjueZzE
	 9T+5zCunRSXGJDmk2z+B61OjrHJ01KT4FZnQwShCshfMRs8wkOXIPPkqjkBcu4Gqsu
	 1WvyQ3G6Ds36kjcZIpzXUmgHVLFRT0e+P7h1EULlUA6aiTwhnmTlgQndsT8O5VVZlU
	 Q6ttTzKP2s5TJfyZTdY91EkOJD/o2SRm/KPqo7dh9WXDEtAEcsdgMKIi7qGPHkv2YY
	 g08jdCwyfxv7e4FhaKKWyfFpnlBCV2UwlaRDuOc0n+lEztHZ6KmPY5V/HfxIPeHOjn
	 l78TX1nEtlHNw==
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
Subject: [PATCH v6 11/22] kho: allow destroying KHO radix tree
Date: Sat,  1 Aug 2026 10:48:20 +0200
Message-ID: <20260801084833.1897543-12-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D8DDD40007
X-Stat-Signature: a4qi8s34xis7o5jdst4gr159x1ofaotc
X-HE-Tag: 1785574169-812543
X-HE-Meta: U2FsdGVkX1+bLipx9kf50HduAYJtZd88hr0G8qMj5IlZYeZCmEaAgpkKukkfce+ZwVUWRw1fx74OhPhJr+Rzl66qL45VqGqwR1R3HJMD4/5rKjBZhDwfaOTjcE+xuOsZh2yMHfnBBwpywOgmT5Grs29pEXGYoo+ctHob4+QGf+WpDmFvRDTedb0zv0KbpSPvkFoa3B06xWSSfJIJ1o63UR0fKc6PhVAH23xDbmGyJ2STJAlZuLYY8KRGBbjJw12lf8m8DDG56f0MFKwfpqPXtucw0z+6IBRMzelWvp+Vh0zE4y/uICZ/Bam9z/UZs8lbfdnbEVki4KLE9+c/TNY7YJ+uiVVjolYGysXeU140L7T3tpJ6hekimHutftJJX7fUVZueqjP/pD77QIeD4ne3eaWvGZiPtPaA+wAOlPWSWVTbRmVIBz75Mvok3s3WDDSB6BCDWCJ1njLoQhXKUgzOm6UjKoN3bE2od0/X31Cbme8uz1NpsBZI0Yob/NdYn32RTm+Gb/WJWTGRgJa1Unpk/rmmz9j+BGuSyk5zSvti7wFb5ITKHIM1fjo+y63ijragsw1z24zrbVYIi3PCOAHb+KlS5IRseP+tGNKwynIJEK/jimHp6iZ6v2MvTj8jo6on0Gkf3fMBlYzi7TGVnH6K9Kg7mtselsThGRTxA7xTtqie5GJOzMe5Z6DmHIoaG9G6ZNh7FhkqD85petN/fvEsqikSujkbTt1CRHrN4gsAttEZVp78gjh6mkyMfyXplkCku5y9evTmv52VYvypvVek0pAjtmAYyonBJVsqHbZVngR9TUyET1mDVc1kg09GUmUYqlrP15HsgE98DUBopVImB28rMD+2PYC4iDTUPMXUBaWcAKEAQ5TFRH9ZMcqOmB8kSnSVVnvrb4juXwqojSf9Mu07wvuCFUZP62+Sftx+DdXHUXBBw581K+0kUODcrCmjGwZgRWj5Unq5Ijg3xkE
 GkgUg8n9
 lOFlmKkMjJpL5DGYZtYBAt96/P9O2Yi1ifRevPc4bWTI4XyQZD9RWIuP8DhcVS8NGZSRjHAjB0/+VdVzDr0VwAOleCM0+3nYMmtcaJPqAoCiGZ60XBLdgXldi+ChL5XUbfOyB9HO7/nIqlTV0pPzdO35950B6rhdew8kxbC7oOSkUkP+Legq+/8sNaw+pV6Tvthn/kepaKchhT3WvdaHj6gP3/c4+IzmmL1uWRHRKYkV/3fmh4o10o1+cxgdgm9gKZfd1KYM/rU1Jv6HLz62V9S1dd6qd+TPw6gYV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Add kho_radix_destroy_tree() which allows destroying the radix tree and
freeing all its pages.

This is will be used by the upcoming scratch extension mechanism. It
creates a radix tree to track free blocks and then frees them after
telling memblock about them.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho_radix_tree.h     |  3 +++
 kernel/liveupdate/kexec_handover.c | 35 ++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 60c1246a9101..b7532aff35d8 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -58,6 +58,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			const struct kho_radix_walk_cb *cb, void *data);
+void kho_radix_destroy_tree(struct kho_radix_tree *tree);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
 
@@ -75,6 +76,8 @@ static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 	return -EOPNOTSUPP;
 }
 
+static inline void kho_radix_destroy_tree(struct kho_radix_tree *tree) { }
+
 #endif /* #ifdef CONFIG_KEXEC_HANDOVER */
 
 #endif	/* _LINUX_KHO_RADIX_TREE_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a5800b960cf6..105dc0f3e691 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -301,6 +301,41 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
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
+	tree->root = NULL;
+}
+EXPORT_SYMBOL_GPL(kho_radix_destroy_tree);
+
 static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
 			       const struct kho_radix_walk_cb *cb, void *data)
 {
-- 
2.55.0.571.g244d577d93-goog


