Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB1FCD1297
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFAB56B009F; Wed, 29 Apr 2026 09:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB276B00A0; Wed, 29 Apr 2026 09:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC10C6B00A1; Wed, 29 Apr 2026 09:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A62996B009F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F9FE1A0203
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:06 +0000 (UTC)
X-FDA: 84711702012.17.4C4EE37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40569140019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVvITovv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xb8++MFWWbutidJn3V0p20dgH6WcuZ7SlXr7qIYnqo=;
	b=FSL5s1HAB3mLr68NNIDnnOpzwBNM0pNZMMiJqyDmF0WpRBS/6RDJBe2sWtYa4+yGlzm0ra
	+2iIAghLwWkqpavHc5JAn9bTzW3+l6scFRqvgMXYPhBDybdLvKGMk8UUZlNJvxey6YsCUl
	GFejuvgVOZH1nWQTLEzix/z5bdRDGDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470004; a=rsa-sha256;
	cv=none;
	b=sH7pAW0EGMs/BITY5nBVgw7XGigBjnDp++Qi0pKm7y7MVba2v+LVJ0cvl0xOZe/NXAZMsO
	dSZNrUJ3Hsle0FpX2JamfTvvycU/AhErmhSuN07zkpke9YFtDGlw6RHXZwHELmvXehs4Rc
	zm30eBMZxMG9oGPFaPrY2klHLCp1K/c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CVvITovv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AD74442F9;
	Wed, 29 Apr 2026 13:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E45BC2BCB8;
	Wed, 29 Apr 2026 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777470003;
	bh=7g0JJiONXBOw45AyCeb07Wo1XFWVqN+yfQgV92Bji6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVvITovv0rPTsRIckne33fhWAqIvJ6CkT/vfyng+WOTzPKF2ue9p2YU9OD2nkxcFG
	 fth0V8NRUAtRGk8QRFXdp6fCF0L7vLSEBo0jOV3YoKh8HmxQfbxUNlrg1qmzWSRMat
	 4T6MZ03v7IWk6RQx8JLhpmMqvHA8ch14S6AuBok4JO/g0NKI3CacRHxV8AqZwp+160
	 mcyN3E3n4S4kbrcwE9RDz+/Mv0Ia/q2QMomCmePKcGpUTX6omL55T356NyAODrmIry
	 yVR+XcutobkssLARvkmMLlnPWEU7gDkM7fR6AqyiRkvGmHrGhyVX11rqttaKEc6k4Z
	 a07k8GPJUfwjQ==
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
Subject: [PATCH 08/12] kho: add kho_radix_init_tree()
Date: Wed, 29 Apr 2026 15:39:10 +0200
Message-ID: <20260429133928.850721-9-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 40569140019
X-Rspamd-Server: rspam04
X-Stat-Signature: qy6ynd6dyi3e7bw9cx73qshkn96wsr5h
X-HE-Tag: 1777470004-634709
X-HE-Meta: U2FsdGVkX18RLg1rdzlMQXVRyuI2b0o8u00Oz4Dm3IpJ6htl+md/yupLweJNoIg0Pf8PB7g7caRpJk2USNuI6e2E8ZUSyW76pooLgul7nPPLsXhXJAeQWamE4CkdqFaFNp2Qts4Hw6bJxGAejgtire55w6PjsHOANyqJ+HsAdL8akchG3fk5bKU2tcmwihcmalYu1S7bAwKniHKxZ2gBbB00fjKQFkWmPCE/I2/PkAYrAinpaiDaYfVDO2JEogK2DvV/bw5k5ZgW4azojWAITttxWxCPaYZ9ATw5PhoGx+7tvX/rCd/3iwesKkKd53uJcnuxmOh9eqnTHTHRfSgdoHd3mtfdnQW6IqKmi4Zfe7+P3vQJkOr0avTEGqnbTTdShtLOU3+FjFA6NvmSCkbOqb2Ss8LFvYLBJhyJ4N1yOjk0y536lOq+V/65DjVM+f4l6Q/8fG11pFRHzfrFdpJzRlzlSF6cxkHYo1QePhdYwGE+Ahp0SCzteo1iFkJkw6UPYnHBc2vL6uYo/rK9qqqTYU7SyQczMQ/YBtgWx/be0qGGakGhLf7MRCEnVQsUxPAfymNtJ7dlYhktX+W8wc5MNmESDDmyVDAfyRs0kUS6Jbs1Ae69exV4is3x7dBzkuK530bsP3r6mQW5cgtmaxpX0Eh877QmDsNQkj1Eb+JN7BVG7ysHXOniGac0gamg3jSIM8GHC/7E+VceljBePlea+Cu/fKW5adJxkRON5DQ3sV+QPYMdZrKITG+vbQvgJgcKeM6HEYTGX7u0hdsm2J9x+TwIkDD8z3cSNRnBQEsEc6HZkI/FBV4I7zp98TfmibpiXBo5GYU7tyAsZXoHDqKcr4Vm1lA3PwgWseu9tat+969MnrkDyc9IVBIf7HvMs77xZouicuBE/5OVExnzgmRUeXfFyt+wD/qQp8rF7QJ67SRe3EUtM/TL5xE5SxLU3p+zuPWF9GyJ1DzPTef5ZMz
 +zhNB1YL
 DsKtGyDbredpXz9pDTqSC7oMRiyALl4YbpaYPZE6k4QCSdMdhpEACf8MKTrRxDVlkhCI+b0J8xEpNUyOP9Y6XlHrhaF3inyTvYiuvtXHqPWegrox/9shWmiMwwqacBLu3OTJIgFqaiVn7MzKl/z8MsfeaCSdcpqSRoMMEDPtp3/n/2upwv9vDJVhYHiP5lGRrbx+ltgdiNRMm9fImS/v73ziXN/1EB5ruWCHStEDoREmpOn9jRQtMXb1ZPw==
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
index 29479534f65d..1a04e089f779 100644
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
@@ -1445,9 +1473,14 @@ static int __init kho_mem_retrieve(const void *fdt)
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
2.54.0.545.g6539524ca2-goog


