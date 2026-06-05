Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7831DCD8C83
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 18:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CE86B009E; Fri,  5 Jun 2026 14:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDEF6B009F; Fri,  5 Jun 2026 14:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5686B00A0; Fri,  5 Jun 2026 14:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC0666B009E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 14:35:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8841B140251
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:39 +0000 (UTC)
X-FDA: 84846712398.01.16823BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D90CA4000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 18:35:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ck4NKjcv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780684538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+ieLiROXsrjmcbXie0/1ghO8w8NO2+45uMA2SUyf88=;
	b=KyIY6L/s2kV8zOvo1+qfWsEgS7+cE1J/VDPzHZRCmY38pmwKtea1ozOspE4XFRtWKyLv/C
	ZGcFfTKjVRLF3kZCeVYgBnpCn95jQsnYOF+k2A7Srr000lq3mGvxgP/lOiyXm5DY66NNI/
	vqh3CguHBIksUmrMak50TNSq8Vml5Zg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ck4NKjcv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780684538;
	b=i1E77q/Kyl/15UYhBEwODTf8lvT7r2yRrB6LrUBZNY7KHts9L9zVX8ly1x+nJfAZq2O3qd
	buOMhNK+oULDHvlQnileT423I7kr/tVne5VT/Ag4s+wO0ymUlFB4c5Q5H7tFRiUQWG8swx
	hZDpItNaSlJi3jGuJfiH8i8aiJkPIwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A56B40E0A;
	Fri,  5 Jun 2026 18:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3EB1F00898;
	Fri,  5 Jun 2026 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780684537;
	bh=W+ieLiROXsrjmcbXie0/1ghO8w8NO2+45uMA2SUyf88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ck4NKjcv6KT67E4X0JZGiF3AgMSytQ+F9NG1+2UKCsfDerJ/WrWzB/nS8VfyWK2Hw
	 yFviIheKsUScGgvfY+ZYCjZUfgxyQZab2SzgqXHccaRDIwn/TlVb3uwq56Nf0Q5gWM
	 syPLIRi6Q+OMHb8FveP9D7hHXSdLQtDmTRY2Vdxh7oGq5x20RMa3oRtxe//x2RpbFa
	 YQHRhzgcHATS8y4uSmLtyimCqznQM++24sXBO1Q5wmbvG+J+8Ku/0XaAYJ8rovnvTS
	 lndZjmCbXaR0SodxcsI8bTiW93QerK8HEPpzgxpUQZTsfFs/m5BD+uOg5Zi4UF5A1T
	 0hbWpEPKoKMXw==
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
Subject: [PATCH v2 10/18] kho: allow destroying KHO radix tree
Date: Fri,  5 Jun 2026 20:34:43 +0200
Message-ID: <20260605183501.3884950-11-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
In-Reply-To: <20260605183501.3884950-1-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D90CA4000D
X-Rspam-User: 
X-Stat-Signature: qdgubbjtxaea9cicghifgamsd576sb7u
X-Rspamd-Server: rspam09
X-HE-Tag: 1780684537-37530
X-HE-Meta: U2FsdGVkX194S5BKLYF1Omx0QNCIG/u3aVfHmA3vXs9cg/PQJH62Juuh8iXqHKkVpLzTOBid3pqM9tw/SdFbAcjG0/yFGBE3q3L0H2uqje7lnTXKfmwQiULGmFDWoMr9gAImf7ySmvMRL82h31MxNLK07zkhkQqkbBcHHwtD6j01ELS7fzTD5gAPZZb2tNOVRI0eUZxuLViNo4Q5fhZQwDEIGyA1mA2BPD/OEOpaziKn68NsjKDJmF9WIPEOXKy09pi1etxkGlJQNAP3sLggeHQvSEbrf0E6DtyQJuW8hSCzgOshsetxaAUqdIht5/+fiYBIYFm0S+GqlhDGorLMueN+fTAVtNgyjzLlaOun9SSfl2rEexrFB88NoXvTg0QX0XAb/r9+1sV2gt40Wwmn+LYZC1GGZMRUREBJmoiDHsxGMAv2L/Qj6w5qJL9mHRMaNy7e0nFIoXbf1+CSVGXoVwFewQ/p9UCd3i35kxde6OQLezJQYAoYZ4Zjh6V/qy/4+TPoZCUXFa2Eoq/T6Tfs5iszVYfi45qZRYiBLK8S4f1gsZ5H50aaMSnX3X1DGhZECDCMkLcgiGW/6s//9dFaA8XSmzla5nGxCPWrtc9C6361PUUO2QuKLLqHxM6pUcRl1JrVdw71F/5VoTO8iHtGVgmS3ExYxHmwm0NM+f3zcRzJ4Gont/c7Urx7WFZuazXmRYdw4uvh67w7a/7rD46sIX5BSy8lTwu+Zof2P5faK4HjpErr00RE8f9WTcoSUMT3T43SutuJLSU/m+DK3NY7oS6rbtYKVOiVEYgmZkug1uiH4DbCIRehXyq6cG8JB8PiU9JVif8I1OLIvurMF9ILgKT6G4zC2Yl9A7GaaAUsLj7tdcIXBVU1kNl/EzQeWvcMhnc8DFoolXbguB5w+7uEaKxb4nKRceXvgrggeLt2putRshWqoOVhYtlhwb3stStHGNpZxxnXiPLOEjOwlrd
 W0d3tpp9
 EU89aAQg1WOlD/LuygGOgfXD5BQ6++FMKn74mPGBf7EcPmYZG1Jx49DzhJdbldqaGxpomkY7rfvs6BQLna/DS/+/TTut2R4kJe90u1Ui9hK5Expa6sZisYRMbmsQavOR1Pco1Be85PFUhHAPn8k1NnwF2AgzcDh1Wplfm/S/tPG3c2lHsJck9C1gv2jknSwxhgtD7ATKPrj0NsNcb6q+3Aty216BVFzE5Im4VRa9hP9tc5eMpMlCj9A2zBXuTr8Dv90Ny
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
index 4138621e0e87..66ca936b3f06 100644
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
index 452b4dcdf2d2..df3f5eb01bf1 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -298,6 +298,41 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
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
2.54.0.1032.g2f8565e1d1-goog


