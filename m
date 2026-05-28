Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B73FCD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3541A6B0099; Wed, 27 May 2026 20:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304B56B009B; Wed, 27 May 2026 20:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E29D6B009D; Wed, 27 May 2026 20:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F26AA6B0099
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95D551C0574
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:28 +0000 (UTC)
X-FDA: 84814977576.07.0FED30B
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0060A20002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=TV6WzaN2;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928947; a=rsa-sha256;
	cv=none;
	b=b6rQyvAlPVgcyfuuX8dS3Wk4yGbp0yhjgcW6TR9OK3zNbAtx/5cjppEay3S//KZpLnZlyt
	3urIc0FU73dPF0BQgEeDC5CiYzc8X2A8pq2V6x/nz0SBZyabSMaPBlG4FqHNr7nA5I7Cor
	q0sKFyO143Uh46W5oruO7YeWslESaqU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=TV6WzaN2;
	spf=pass (imf31.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvHZ8tn8eh+lJU0aR4E9nRrlcjViE16wdOefk57RvS4=;
	b=C+BBKJAkrs8m53AqUHiqVvBo6XvAOXDmNKK+fcuelnH44GClBbgedpe9ooKLSMG+9XDJBZ
	estCGD0GFAD1gQ7F9gQYN+HHtTRSnw5bN9LMp0araKb9Ov29Oo58B5Ae2ltTQFP5kawahd
	uhCpzmetSFp1H+OPERCcTwyqbJ8Ziio=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 0ACAF20B716E; Wed, 27 May 2026 17:42:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0ACAF20B716E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928936;
	bh=gvHZ8tn8eh+lJU0aR4E9nRrlcjViE16wdOefk57RvS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TV6WzaN24cVxEuQ8e/TKSD3uD6nPrBZJ6iIBnnmVdVPZl/5J08zp1HVqbHbwFjoFK
	 BznCKm85oKXL/JOJVUClWked59v39RpkbulIFmAU/+ig5C25ZXvVXHRwoNio4fybo+
	 peh+vetrfdv9qXzIW8L6XPWeLUc7VZq1gt49zymc=
From: Jork Loeser <jloeser@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Kelley <mhklinux@outlook.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Subject: [RFC PATCH 07/20] kho: allow destroying KHO radix tree
Date: Wed, 27 May 2026 17:41:49 -0700
Message-ID: <20260528004204.1484584-8-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0060A20002
X-Stat-Signature: kb1ahp6ctg6zydhyedetmui4c7pnnd56
X-HE-Tag: 1779928946-801061
X-HE-Meta: U2FsdGVkX19w20JrXhrMYhvHHHH+0nYgtnCzgniUEJale9+iitAF5ImLKhq7uCE6BP+PUiiGysC5WSTiEh6zDOkWfRU05Ci5xrfl/k/3a/SNBM2rznVlDxLDIwc5iL7LeAUtFutK0miYSIAd+q3HbuLWjEAM/c5aTC0gDndWkx7T+1gDGEmIl5LkLlv0gxNj88xc9xk7kdM8Nq/O651I8pq++BwKoLmFNoNpQn+DastpoR9mH/+kQiSS0m8JYoQdHTRI+KxU0qsoVK/gU8juHvbdfAyNAKE4ok/dq2tbDdLRlQAMPU5PMKbvFTZF+V1pqoMT2IExkS4v/X0sHMI8jH5zZWFSWpj+aQVLOeRqLwZo6od6mp3JYOK8GwankjSHr3G/ES8K5cV3PHEXEXKjij4m002ljs8obr1UWAjiGmcziB1QtC8M8L7lA+5aF9SqDDfG+zWnswl0Q6X3YXcI34XCN1Lr6pvFll2qumxjo9KJsrGBp81g9x+Q9OBf3eDagd31q2AwGeffeGzLevPxhRaDZmrFii3n3nJc8LnnVqisc1Bj296e3Y8bd1uxx8BZzofTuEwl+Jp7yGqijElfm8KTHwypNqf2wDEHGrBepdgL3cSXrw8vKk7+592BjiDvzz4JiaWLNiRxII0vag6uuvmplmJyqqRyCcHLARs14adVMkqe9V4S+oypCn1xBQv3lKCSIGwtR26gyl6SNQGRMM3ZC/k3ValhtYOKzp3pi8TZpA9DBFAmBeXcWSzaCZtGwm5hPR729OtsFgf2lKaTus9tost6Hc/f45InHHwpLndXH5UxaQMquXH3M2yB0/rj7+GNJx3yuvkX+wok7Keur5yT7ub9tC30V30pWwe74mc5RAtXKyczZkmiblwTBd4cfsQIdVGH4kh9NvOnzS3QAxcwwmu8z2R8lNpjBAtbptBhK/TDJA+t/fIG1xgpnuAHsE4QwrbSNtEo5jWvc31
 TW6GfsUp
 e0HF0g+YUSOoP69FXGW/GBMXhIHS8fbajav1aUxiSCZrswhAthYjrS2gIB45u0nySxgl5WdEf8t+fx1SFuL36vTz5dj7FBe2nCYLjjxLga7+cLWEQHleaDH2xrRgZuUTl+S2t2KWx/slnay3VPtERlmtlT1H8X9XrIJyoTThUK9xxb0APYrdhQ7kfhYRud4nCTRxLSDHi/4vQXmYFCROMYE6Xga4aPuPVw2yu7v6qD/fowVuCTW1Dgo4BePvzaoXfchQSbRvSX9msofMNXY6Yvn2+SjIbhAKu/cVj3OxpfLlcoi7apw8N/2XY4Q==
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
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
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
index 5c201e605b96..3f3ea71baa1a 100644
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
2.43.0


