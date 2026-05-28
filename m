Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE31CD6E48
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84F66B009B; Wed, 27 May 2026 20:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AF46B009D; Wed, 27 May 2026 20:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAE26B009E; Wed, 27 May 2026 20:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 761176B009B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A5651C1D9D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:29 +0000 (UTC)
X-FDA: 84814977618.15.E75F179
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id A8B0E4000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=CZTqfsUm;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVWiM4xIUXWQ8VX4lQw/ZW4DJ6yNUs4CT4NEYGNtMTc=;
	b=kDL5no+VFvI4XWB+YGRD8Zz9sbqRRzZekNxmxUnYFp6Z7HtQ0/NwraCIVPea+8ydhkGTdD
	K+jr7xZ+UsbWk4L55hJTkFN/oh9lVpwx82nZZMOTg/wEktB2eCIP2vV9TIc5c0AGCsH6uG
	ORxreO26oOy/uUTX2qOZ9Pido3TGHh0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=CZTqfsUm;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928947; a=rsa-sha256;
	cv=none;
	b=ebIOhPAfIX8lYKwfB7cWbvowbmYu99gB6OxxWPZSQuQqIJ2bYZRHnq0PqdAYMEOQWQnnfy
	cREW4+DWghqnSLAQElGJ3FoINrUe5HUiau31zo+GkcF/ooJ85zP1m0CI8x+Vgg89uMkQhv
	M8b07EPijneIdPuTWtN9tr5h+F7CiiI=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id D9FB720B716A; Wed, 27 May 2026 17:42:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9FB720B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928936;
	bh=UVWiM4xIUXWQ8VX4lQw/ZW4DJ6yNUs4CT4NEYGNtMTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZTqfsUmcLLXJT7YbU5UN7KLqaA6BUVha/oeK47UmZZXNYo/M9YmHZPL+JhzXFPDl
	 RWF8g92V93FnpwT+SmnnZeHh/vF+yOyFDUxwz1pmiBwtOYjGVvrjhDig9SvmrS9iOD
	 5izCOplWYR99E1vx1VZ1orE4q8bJcRWFlJ9ijylo=
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
Subject: [RFC PATCH 08/20] kho: add kho_radix_init_tree()
Date: Wed, 27 May 2026 17:41:50 -0700
Message-ID: <20260528004204.1484584-9-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8B0E4000D
X-Stat-Signature: 5ufxski1g7m4kbm3kh16r1osxb1x6hjg
X-Rspam-User: 
X-HE-Tag: 1779928947-636702
X-HE-Meta: U2FsdGVkX19NwxcZ1PqNO05ObaUCmaOy+yqFV51QhACRlIymv6wCpuRVaEzqx/DvpzE8M1ru2TpfPjItLCqmA9A2qVLWzl1tr/OTEIB9ahf98wxi2EmTHlwcO3ss1uTmgGCX9aN8epIE32A2VUx6ccg0j7QYwS9B+hj68F8uX/+ZsPywyp73a7c5AHhVqe6p71M/g9m2i/zFiL4EHjQU1iJms+JP/KDww+nY7fIq/+sV2RR5DuCS+MFFz5NLPi2JGfAI5/8bsFs8gHrA+mHW8SduDjIGXzdOLzd33I7nSbjpR9e9Yn3bQ1L884mcFjR2lrI0m3al3NLcPNQle819kvHFvxaylsBhomxkPOWWuXaWV7kMkezNA0OnY5wqyvaqbsz28XdygqPfqAs8Teanph1XD97EENzQZEg0+L2JFLSEN4EClM68e6E8Rck5khnYirHPly1RbLAPwYM4mUcLgqML8syCQqwRvqkGtB6b+4ZqJs20HHKOWz7zT7Rclkq4PC/7QfFLoESe4hY/5iIIlr6g7WvRAJeE02qmDoOq2lAMb8EtYHc7clYmC6v20APgrwt2meF4Ezcam87jhx3UXtxa9UJxpPIjm+IwXa9FLR29HVu1cLGGhkBEmx7Sc8+Oc8LyqBi3w1ohGuHWfmn1dNIdP8BuHCqqCWka4d0Ntlw0784r+ajDDab1Phv4+T/I3lg18MUbd1pmkW35gjfKKVoCMG+DCtd6vttrwu8B0R2DU/EvqtAcs1Xypsar+ICOqcKISbXvwUVlQD9xVvgjtgxksssId/+LKJYbojHNVXx0Aq24IeBtdSPnd0Cx3vP+xtUxWdS5wvUJ08YIV/9RF3DhLVDemLBpr3+exa1jo+8Hp1Eoh3MpE6XBXTvRRvtIydXeyKRLI8/Yq0YOrbCNuzPmzja7Cr7wGuotyomIA1QCrI6nesm+oX6roxH1Qg7rAtLs/XPFprU7dyiwzEy
 GF1X355p
 XBQQHiJTECquc6LyOAtkqKBM67Zn/GMmjguVUdLVcmQEQaZ3bLfuBPJOm5taCJ+aUFwgjNY9F6yQ4JD0716IBh77sP1FS0mAA2gKW0LabElSAJT+KnMuuuZl9JJNW0HzgMlXuH1eYoXunsF+kTGr4yoOmJQp4rvTSRLc9I9aLMIbasZBRcQWtKOthIpuD9rHz6Z+T50fLYttdtBwqA+dOE7d/6wsSYL03OSQIAGLpbOdKGJdyV7xtCqKp9igwHEepXgs2iSvy2cnWhRZF+Jkj5IxNLPqCVqqRTCB+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Move the initialization logic of the radix tree into
kho_radix_init_tree() instead of having users open-code it. Makes the
boundaries cleaner and reduces code duplication when a new user of the
radix tree will be added in a future commit.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 include/linux/kho_radix_tree.h     |  7 ++++++
 kernel/liveupdate/kexec_handover.c | 37 ++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
index 617395a6647a..c0840ecb230c 100644
--- a/include/linux/kho_radix_tree.h
+++ b/include/linux/kho_radix_tree.h
@@ -54,6 +54,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
 void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
 int kho_radix_walk_tree(struct kho_radix_tree *tree,
 			const struct kho_radix_walk_cb *cb, void *data);
+int kho_radix_init_tree(struct kho_radix_tree *tree, struct kho_radix_node *root);
 void kho_radix_destroy_tree(struct kho_radix_tree *tree);
 
 #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
@@ -72,6 +73,12 @@ static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_radix_init_tree(struct kho_radix_tree *tree,
+				      struct kho_radix_node *root)
+{
+	return 0;
+}
+
 static inline void kho_radix_destroy_tree(struct kho_radix_tree *tree) { }
 
 #endif /* #ifdef CONFIG_KEXEC_HANDOVER */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3f3ea71baa1a..b2d1572808eb 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -305,6 +305,34 @@ static void __kho_radix_destroy_tree(struct kho_radix_node *root,
 	kho_radix_free_node(root);
 }
 
+/**
+ * kho_radix_init_tree - initialize the radix tree.
+ * @tree:   the tree to initialize.
+ * @root:   root table of the radix tree.
+ *
+ * Initialize the radix tree with the given root node. If root is %NULL, an
+ * empty root table is allocated. If root is not %NULL, it is the caller's
+ * responsibility to make sure the root is valid and in the correct format.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int kho_radix_init_tree(struct kho_radix_tree *tree, struct kho_radix_node *root)
+{
+	/* Already initialized. */
+	if (tree->root)
+		return 0;
+
+	if (!root)
+		root = kho_radix_alloc_node();
+	if (!root)
+		return -ENOMEM;
+
+	tree->root = root;
+	mutex_init(&tree->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kho_radix_init_tree);
+
 /**
  * kho_radix_destroy_tree - Destroy the radix tree
  * @tree: The radix tree to destroy
@@ -1467,9 +1495,14 @@ static int __init kho_mem_retrieve(const void *fdt)
 	const struct kho_radix_walk_cb cb = {
 		.key = kho_preserved_memory_reserve,
 	};
+	phys_addr_t mem_map_phys;
+	int err;
+
+	mem_map_phys = kho_get_mem_map_phys(fdt);
+	err = kho_radix_init_tree(&kho_in.radix_tree, phys_to_virt(mem_map_phys));
+	if (err)
+		return err;
 
-	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
-	mutex_init(&kho_in.radix_tree.lock);
 	return kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
 }
 
-- 
2.43.0


