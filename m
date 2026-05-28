Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E68ACD6E48
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 00:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3D36B0098; Wed, 27 May 2026 20:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948596B0099; Wed, 27 May 2026 20:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E68D6B009B; Wed, 27 May 2026 20:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1A26B0098
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:42:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C3841C1D55
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:28 +0000 (UTC)
X-FDA: 84814977576.08.5589CCB
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 900B5C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 00:42:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=oHYJtC9j;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779928946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1L93umqkPl+CvKGjKmEBv2sARKxDSIySXQCy6TvTa9c=;
	b=R/6PGHXD9U8ibwaEHxGewV5piLsj737VAfKb0RfOKbhziKj/+Uio0uj3xYqVnfHOh+4Bjl
	x8tJz4mmoJwBlfUQXjiQvPeo6D2+FeZp9jkExr/uY5MGmO55j7ScGWOejMTmu9JLQe3ghE
	BH1B5JI2LDrqtDkTdUXAOa3hz7l/qDU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=oHYJtC9j;
	spf=pass (imf10.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779928946; a=rsa-sha256;
	cv=none;
	b=AgzgviPxqJZ12Ew1O5KkA0sWcNor6+5PsbM61F+2Y/4ICstizksIVMcgECqVCuBjJfPuh3
	iu+zHhfvCgyAfbILjHEXoMv1HfopWs1qMTc4smQynePtucKfXFWvd/pzOCIzAmPXhxJWjy
	+J+MBdCtlGXeNlCWTF5aB/VCj+kNrOY=
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 1DD2720B716B; Wed, 27 May 2026 17:42:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1DD2720B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779928935;
	bh=1L93umqkPl+CvKGjKmEBv2sARKxDSIySXQCy6TvTa9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHYJtC9jrZngMAAjetaMb5lQFLtjnUYRB29wAXfcEMfhH2Kh3jk0DC37nkFEJfS5z
	 iiqIf/bHIO1I6l+lSgMXEFCnMfTqDWowoLBmpz+7svYjWQIPT+GhIT6s4Bqmm65/uh
	 mYzKRjOqc9APJT0ULyBHP39i+I+hKEnNbJjk+k+E=
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
Subject: [RFC PATCH 06/20] kho: allow early-boot usage of the KHO radix tree
Date: Wed, 27 May 2026 17:41:48 -0700
Message-ID: <20260528004204.1484584-7-jloeser@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wz8krac37jxcyqr4i4q65b4pn77haknd
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 900B5C0002
X-HE-Tag: 1779928946-482136
X-HE-Meta: U2FsdGVkX183tRqZxzkT9gw5i+S+1ooETx8FLdXrAHiJysHDmZILhjA5lUpN7segiN5np1C1h/JVwHUBANKiVlJbqu8CQTqGKJSileBadfjdKdK7zyDzUG1EwrdWCPmfcBBNEjARieOCbHcGKh/8cmR40OT4KaTRRkrXlGGoE4dJcfjO7fqqWfgKZwKVmxfjXSQJ5fyLcVljt22YHm+MJQ172zr0pPJSmVz1Mb2pstJDzts24rBlHjXDydTY9G5At8can7nxp1USvnTBp/zJZy0APi+aZ35kvL6JnO92IxbFbTMBrlhG3hf99XnS3Qh2wpEZuw3dpL8Losw6ZGWVtVLAgsCWkyb1E9nU3z5E1xkbl6LAYZgm1BhKqB4qiqBtxCF2TJeYZyX+MZBvvnJ3HbsmbLAMPW+G4IuU+DQ959sHQ++mqo7iWiV0Nsa5IH3KGvWNRD/69akVY0S7dS4b9Qox/PA4dXGaAThFeQkhCLLT5OWr/1TsfNJm91ZkKiGVi25yT6kGnQ2dFHwN8x+r6Z68W+ve9+1PKflbH2sQMA1/XJCnqFHg5AFWqsTVKbAsKQfW6nnQ1smYRmOE4l2J87x8dqR597DGVoshE6FvLPOppdAC4/pJYebBnnws17vg6WB7t/jvjYQyWy9//P2kfei48wxTSfITop2ewdN9B58M8rWy4xlgGXU8Uq1hPqazbjwYt6av/X+zcJNDdv7bi8oIrN773jK2NkiBQfc3X/4vt+5fsSo4p2Ki8PaTYTxRk70RSJMpAa+VSQG8lypADGyAUJTWXTDxMe7Vqd2yF4AHKV0rGbw5scg3De6jNqyJt1TOJBYsgojRXC/6ZOVh8MxYAZlLQLI0dAkVCE9DPNnBnUU4muzOoE7/BhuLr8lA5YTKWk0VfCW4gDVUyz43/opLjbq/ZaEUaKxa7SOpZdBXU89SL3WHHYL/Bb/aU2SO83Y0Byoee6HM5IXrsSG
 DsFRTwfZ
 lHc3EAx/eTbx3Obura55dsVodaXREw55Riu+ddwocNi7JJ8Cjt5O0PN8unUZNVw7oZakZk7c1YU36FF2LvjEQA+1khzfMC482ehw4Xt+ny9442Erq8ZLj3nYhtUrjbFQXMCdXMnwLK28gXqO/rA3yuGWgjPWWtCBA6If7erYZiqyycH/QVAdjSiRl0ZEBmHcA/LlpzntUljJ3m7Cn2TaMDp+m4xxi1zgvro7wNGIx3zSKcOIbcMxy+i4BFoZH/w/sh34wmljlf3hw3g9kuAsWQI6rYIXGk1hn23HWL9CGp/jhfizc7ddUXZFQ3c1JkRXS7hAf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree allocates memory for table pages from the buddy
allocator using get_zeroed_page(). This is not available in early boot
when memblock is still active.

Using the radix tree in early boot is useful for KHO to track metadata
about its memory. One such example is for tracking free blocks for
memory allocation when scratch runs out of space. This feature will be
added in the following commits.

Add kho_radix_{alloc,free}_node() which allocate and free the table
pages. They use slab_is_available() to decide which allocator to use.
While slab_is_available() indicates availability of the slab allocator,
it gets initialized right before buddy so it serves the same practical
purpose.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Jork Loeser <jloeser@linux.microsoft.com>
---
 kernel/liveupdate/kexec_handover.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f6de6bf63226..5c201e605b96 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -143,6 +143,26 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
 	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
 }
 
+static void __ref *kho_radix_alloc_node(void)
+{
+	struct kho_radix_node *node;
+
+	if (slab_is_available())
+		node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+	else
+		node = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+
+	return node;
+}
+
+static void __ref kho_radix_free_node(struct kho_radix_node *node)
+{
+	if (slab_is_available())
+		free_page((unsigned long)node);
+	else
+		memblock_free(node, PAGE_SIZE);
+}
+
 /**
  * kho_radix_add_key - Add a key to the radix tree.
  * @tree: The KHO radix tree.
@@ -183,7 +203,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 		}
 
 		/* Next node is empty, create a new node for it */
-		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
+		new_node = kho_radix_alloc_node();
 		if (!new_node) {
 			err = -ENOMEM;
 			goto err_free_nodes;
@@ -214,7 +234,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 err_free_nodes:
 	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
 		if (intermediate_nodes[i])
-			free_page((unsigned long)intermediate_nodes[i]);
+			kho_radix_free_node(intermediate_nodes[i]);
 	}
 	if (anchor_node)
 		anchor_node->table[anchor_idx] = 0;
-- 
2.43.0


