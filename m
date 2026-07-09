Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1A2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD35B6B00A1; Thu,  9 Jul 2026 13:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83DA6B00A2; Thu,  9 Jul 2026 13:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1636B00A3; Thu,  9 Jul 2026 13:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058EE6B00A1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:39:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD07D8CBFB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:02 +0000 (UTC)
X-FDA: 84969948924.15.84D6AB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 35C884000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IyZn+n4o;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618741;
	b=AjLDm4zlzBzBO/H6RSoXwMTwcD80XBsaiWl6C3UmdPfql6dBGy5FOEoPLYln23Isbvn5Y8
	M2mN+ZULMSPZ9qoK6OBSLWsGXjh5fJ4DG1o7uP6UYFSFpIRGU95BL538YrnaY11y42zVAG
	esO0K7kMrFcsK+GDOiM2bVMoocmpeS8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IyZn+n4o;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sn5jxIlLMIau4GifCV8YOHeAp5/QttEGk8CccgmzI9U=;
	b=j9tYUYGcjgN8mzwVAgKDMwyf7fCXatT9BKSjl11FZT/PNNEk696BlqO3d4z03UKiAAxxP9
	M6u3yiYllVWInugZPR8SDzSVGEYiRSOn0gspxlnWr9+3MlfaWDNev6z9QxEUN21bXh0ca5
	yX4K8R4qkWyiVIZXi9ZnMmmKhNXVCJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81E6F4169D;
	Thu,  9 Jul 2026 17:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1871F00A3D;
	Thu,  9 Jul 2026 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618740;
	bh=sn5jxIlLMIau4GifCV8YOHeAp5/QttEGk8CccgmzI9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyZn+n4oTykDT3NuNnSd0oHZSsVb13m5OHh6NioPTijvXAL53mRdYeaX/yrzRLmVU
	 ycoXx4A+uUZmtZeUN5+brNVYDg7mTz1lu+riWs5zf2PP1TZ6pYcWysWH/jPVe0WVOM
	 h/TkpOmD3r70Rzw3hthOVTegCejxjF+vNmJsqcsmN358OoO1k/jHPq+/DnKaZwyILk
	 RRGhPH7SYYVrgFV81UlTehoIAMgMgikZpMfWji1V5kvmxj+0GsTjQAKaIqDH+8/8Kp
	 jfVmqMkiFYcMBN8S+EQSJDUGMYhy6I32GWZDdsd+Pm0DVU1+35gyZxtAFbx5K5GI+e
	 1A/Ied3hRG1MQ==
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
Subject: [PATCH v3 11/21] kho: allow destroying KHO radix tree
Date: Thu,  9 Jul 2026 19:38:00 +0200
Message-ID: <20260709173821.429921-12-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35C884000A
X-Stat-Signature: edkoi1cajh9k5ssc445gs83p6zx9a6uj
X-HE-Tag: 1783618741-706197
X-HE-Meta: U2FsdGVkX1/nmwU5BWYY3V3XbymnX9xMxxo6ge0tEHXFniKVgHe/ooz4L656xOREL8R7k0h8oEKYCigJ/tTkPUd/Q69TDMP9nKmRWF7BlaaK6pKLhXkAoOEuyyUtGdNkveah2LQpt2mEw3NmBkm0ozW7N+lmn5Ddo3YJknsaw6joOSKhxKop00rlEOX+lRnrMx23klVXt4EvL/Z3LpyeoeoEvefVPGtZEblquEXMQ6eFwMQojwo3Y8vj4XgVnrdbsEXa2nvoTTE/9slbmmaNOF+r6OaxO92dRPfugEAUzJzp7xalzdWDH4X0jJheOZYtGTGIyWMikjnlUHqqZfGMbMc1GjFteg7rIF/U9eGLEBKFZRJ13Rey1ykFKy1biXt4Zi/eqXXqCQ8G1sOcvJSHhq9IlId8GFq4AeIfTppR7fOIr7T9q9AaQH6rrwFDXTxdNA4F9dUEQrwOuKlrkFy+T6a96M4llPKeK0CM+0xWCLAj78IeqOt8aeweUSmQsB20Gke0ZoZuE5HCPkDCr6Hp1I6Zm69waS/MvG8srOfrRUyFRidR+iQC5rEiXwmTHpYZEG/EgsgRIrAWzG+XDmKxhbG4YRIuT7Kz1knWdClb+X0Bz1qK6g6oHCU1EpTIsaX3KckDlLYuxqH9Y3vSREjP1T29uO3J/IlWv/ffJ/4TCgRIOCGJW9MigaT2Px/+wJnwyzLjvLrQSAlagtU7cu2ypk8kJlKnGGZ0EzjdIAMvU0WJyCfJyK5aJWcUQBbBAJobnixTvhJJnUXlHEjn8WmY+miwJJBgtvQ/khR7nPeHUvbHcYh/cdc3+HufBhWB7fVCtTrQxt7NLNzZLw2ban2MhfzEiNplRlR44XJ25jGxKZbEUcs0S0zE+Sy5P/pjMPHnQlE/vAFi+Vrc2NRa34lP2NJrp8NpHgiv/mS9aMTOpkQZz5RLrtDS/s4amu4RdvlHT690TpAYCI6vGVzQYgY
 gK1QhoZc
 122+jfj6VSy7D6T+43TZFgL1I9zs2lKrvFPFAcA3leIWH8WjqIS+MCFq6dqLSuSeHuMduHuvrFjQpCOhgkjdOKTLQ40e8cF/CWUFLLfhVO9Abv7kTnu3x1Pzp25hhNX1tc/LkkhLz/Pxt0XrvpGkhrFs+udNQuXr/5pz+fReBF3AVJqPvhrSeI6bHuXVVgrqkzr/euelc0rD/zKBBGM78yoluewm+ocszlt+hlGUOM9+/2VB4O/0uCj2xrL3+FL4cZEsNGaoBu31J/oy9PAr7uPw5SRnDTGaP9C7H
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
2.55.0.141.g00534a21ce-goog


