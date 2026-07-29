Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE8AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5486B016A; Wed, 29 Jul 2026 10:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A406B0168; Wed, 29 Jul 2026 10:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB546B0168; Wed, 29 Jul 2026 10:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA7156B0168
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:56:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 526491C0F5C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:53 +0000 (UTC)
X-FDA: 85042116306.14.74D8712
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B10ED20009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:56:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmcDkLrd;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eB8c193KoCNkyC5Nboc/hf64d3uhVb8xp38FM/W9Qug=;
	b=RzhMx72hURrJQoD29+5V9fKpB9HWhRokZc6vURI+dfTWW4lW0G3hBL/jYmIRHm5c6M/Te9
	nuMkFyHfwcV8xcerYGY1Kow8KES116Z9SM3RJaVTEIedTMAPnPSaYCgeYGp1lYS5dqylOI
	9xe/FMDb/VrBqX9lPHtZqxlyeoXVlJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337011;
	b=TqVYRZLLK0R0un+VmtR4gyiC4y29QYR5tN/HV1W6AdpOU5SeQld7zP6K0Scj81pLTOZ/YZ
	8fqVcxQWTB0bAy8z7aSPixXGbDykMLGBXTX+ACKinAezBrBVF0uApM1epKfpktkCX0UVD1
	qNlWCMhFz/o0pf1StWWOj2vkTcS5v54=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmcDkLrd;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B0A940DB7;
	Wed, 29 Jul 2026 14:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B837A1F00A3D;
	Wed, 29 Jul 2026 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337010;
	bh=eB8c193KoCNkyC5Nboc/hf64d3uhVb8xp38FM/W9Qug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmcDkLrd/1MzkczVxXfn8+N7BEZgaGnoK2Qul8jd38HbrcPnqqNA2scwqgczjzfqP
	 n2B3FvU1/BUI9Ng5WsXvZw58vm2gZf0aUM5+yHts+hJvDl47TZbDONnf0r0wXopNDF
	 kve/+Nk99KMzpl42bjjygebEvlKfnZ4inHN2Q/t25n2BEClogWCUT3caAa0gIhBZFU
	 T0hMFANNLSdB61yH98EOw0SVcnqGKuv9M/MgEdJAfp9xJnnulqeOgJ4oF9YjTh1swA
	 YZG0MOy/oYa354qkSNLXnCG8vHcFrFzUuM/qZ8u7ZRGWi7SRxNZ3BtWeeKKPyYR12g
	 LvEfCJvOqpC0w==
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
Subject: [PATCH v5 11/22] kho: allow destroying KHO radix tree
Date: Wed, 29 Jul 2026 16:55:56 +0200
Message-ID: <20260729145610.2827231-12-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B10ED20009
X-Stat-Signature: z9ttb7hhp3s89mxwwdw4j1n56ayb94cb
X-Rspam-User: 
X-HE-Tag: 1785337011-420437
X-HE-Meta: U2FsdGVkX197KbJNjREB6Uh9TQEcgRzeEseQVhMBfOOVDHFWODkzSi08ANvkXYyh34x8uAt37T8epyoW83mkZrIdM6tQy32vH1gTvWVAEkzvrLQ+GTXL6RsEAPXd2XIUhxQn5tn5CYfiNepyeU5JseHqQbMXm8gyGTOtYA6XtT0mZJUt3nqqTBoCBfTMCe0ryPE8jhEzzsivmOcvd8AgrtKnMqxuZDSxApEhsMy1h68R+O1zuZ85Lxejg21CdDpFpBTJOT8sbUADxqtIpJCLxxGYfpqsntFbry27h6xOcW+7qTlV9Hm3DAXZ5b8MSBzEL3e7qh7/xYpBl4Gm5cWHlqzpGGz9lN+fmyXN2Mhubw/F0d9AEyRlAaQPJ/Av8EteLY2vkD10wFOTbRCbx77Ou9j5lGTcoZgAMd7m4I2JO/LkyXKkB/4ggLzIP3YnhFz6f8nmBHqxiQSnSv2ouIxpnZ2Or1QpStYC6RgUYP1kLC33RWcFDkdBPDnTQjP5S6+3KqOGDToEF7S64RMjXPFWoSZVi7DqkhVmS6ODzyXuPCmPlU7gv0S/r3UO2mf1Hhq7IutX4yWnkch8Tjb2H3S3jkc0WTnRN2gfwj7EQ8ugjae3qD9XOxc+cRVlmCAX83TVF4TDG7gZT5m18LPMVQkF34IZe4JfwDM6lZm8baCW9Tg6R1TPdo88vpV/iENcPCT7NZsRTTZ4aQ6JlcBz+NWAYVtC42Cfn+5X/Tvl067MSQQGCwrOWyLYUkubXgUt3aaRgHR7NGnPQwT6i/rxBy4njFppwSKEde/tqvoImZ+iI1j7CFaREGlzNnlR1MTtoKg4E2XDYkRAo+INixew9hQmfRZN8N85/04XMbngsHrJW1sxcBKDsEl70FiiG6kj9xzOHRRbluJwV6hZPH4Ud1EXNqU4RVEYE0pwJoIDAe/vgNT/nrdGmdZAaernguFgrS31S/dkkqm6D+VZlBP9tbC
 ppmkDZK7
 V2reKpIhKpLhUVgwpY66lIW/EhrMXnJtbkahwP0rK8UJafJ30pSexHfZKJkv347gPJ8QwkQ4taWWRpJA2VojSZRmOTKgUccbC49mXtf6wDy6eWgC8U3PjVO+AtillW4uTRPB2gBk/0kRVCTFJIo2hp90ACnUpL0djepTZA/uEnWLT2wkDE79iJZ1F0g8IW2f1ytOyVE8XVV80yhGmJiOhXlSeckQAx8u72v0mfwV4Oq6SujZBKEKpnBzyW+46Vu/eUTPEoN9rqquRSoy0mPIvy97KIIm5YiyVdYE3
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
2.55.0.508.g3f0d502094-goog


