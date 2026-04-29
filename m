Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6865CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA8C6B0095; Wed, 29 Apr 2026 09:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1586B0096; Wed, 29 Apr 2026 09:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98D96B0098; Wed, 29 Apr 2026 09:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A127E6B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:39:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 335FAC0339
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:52 +0000 (UTC)
X-FDA: 84711701424.10.8D1A12F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6AC431C0007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:39:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hF0BgQZh;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777469990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YS6t+2Nob30CSU4tZTpVZ3UGaAlozkF+AcURmj9cnPc=;
	b=oujUOpN0kmzJckaWdkxy2T2W0In6eh1w5DfTDhUxz9Z9GqA+YioCjRh21cNYCfFjUYekeI
	v+mC9/ADIbowwv6GGfB88TtHDzThKBfevki0JYkce6DolXoWCR8HP0LG8RhXeE2GuVSFAS
	ETkW2cPAxbfGMzJBWwnO+MeO69rraTI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hF0BgQZh;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777469990; a=rsa-sha256;
	cv=none;
	b=gF05q48ldbRdUisbRzvemklWR4s0yDIONp6gVqHHA32PdK0m6E8+1em7lGjaT6Qk+/fb3c
	DzMqZiiJ7ffUlfn81JtjBQ15+q0lVwBR3TUAn5zAw3ItqRCeMV5oXXX82uHPLH3XrAPCGT
	3XqQXvqRA+fk7sT1hkOgHWHAhWrPIJw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FB3A440FB;
	Wed, 29 Apr 2026 13:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B8BC2BCB8;
	Wed, 29 Apr 2026 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777469989;
	bh=YXAWpdZ3W51xhQU3+WJdhbI9oKC26cOKjbvk+teZUO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hF0BgQZheuBbHrIBASmeG6IKFi6/IfNNPeQo4/p0QxH4XIWw4txR06lG8lRig2e7h
	 A7KyoQyT45WLHHJE/4PHYo447I6CmnxKf3qOeDaEHmCjwoixY8PKhtRkiFyJ5H6sy8
	 iXMRxEkO/wfImxBhD3iJK1QcnZ122+C46VH4sgF2lFM/eBTFxMI1T15wCj0THO3F+9
	 QUvhJl4+uG+NgnPVwSKSXv6IICHD3xHivOTewplC4HtnPjwNajpBJlycdIDmCde1Vn
	 ii53ZdcSSQPrjnHo1cUt16ll9JZx4kAntipfObI5T/NpEoxJMH+wiV75qujnqHSWT0
	 Z1nuxlnaTUmQQ==
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
Subject: [PATCH 02/12] kho: store incoming radix tree in kho_in
Date: Wed, 29 Apr 2026 15:39:04 +0200
Message-ID: <20260429133928.850721-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17t88ccnq81ukf1778iigidufrkhwfjb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AC431C0007
X-Rspam-User: 
X-HE-Tag: 1777469990-749089
X-HE-Meta: U2FsdGVkX1/2mABbVkV1YfLYtFetxrC99ggTULO+/oO9zmmXJB9ih7onAz0Gt5UK+OD64MnzJRmxLW0qB0muRkNnFLhM9PtcfeYPW4aRhB5hSN3iiN9rv6pvYwFBoSAZW3TxbBxhS3KOHORNDhrRob5GEw8oFyQhU1T76azN5ZU8jDEW81Yq9dC9NhHR0Fgmjhoz39l19aqVwophPObMej7K0GDx2JqPinfQgKGxRSKFsEPwyyFooLi+Gzi4WjnAmYPK4sCyW3eO7TY+woirceNtKayacwNQ1it8+fMo4Gb6tYp7nGDg+LIuh0Nvl1j5D6dS/vMYJvK+5j/kkKYdu2tT1bP94ctTqcn5sQ5qAqmY1WvaAJI0oZ7Uu1SICT+azoSI4dnCD9mAPM57DOCjRuN1FPG9D3RWV70O7+soiVXIbyyzVJlRgGR3R4F0YVLqL2W91EwBK8mcVJ4wGHLZ3pg+xNeL9jRYjCU8FQmx08moU1QSk3nIwJQbI0wUvF877fjX8vYpfQnHcdxfWAn+dg9VMJfIWZdovFk6ckYXx9LhVyLTN0vRpXcqA5xjyh2rqjCqSWd5c+RUb7HM5hAod7m5xB61YCNIp6VPhzrXtIpxoGi0fomtioFC9WO7LR3uxDrfi7/eZt0CteMabSl/Rn+tfKrBy7pMahqCCT/78U6tzjI81v72u4U59pF09YwC08qs3mI8YilnJt0sW2/cDX2mu02NbEXcbsj/i0vD8glSsepXtgtTVnDgSXxcEIus54p59CAtnoCfnHa3crcpmCTHMmcrP3mUyxLmNVjSelHXEwE3JdqzTdwN9InRpafVZQp9594Ronll0db+SNywWXB6JNPGuT7fJifCqO5L1NXxsnDLRn9nmQ6Ed1ITMwt5YgB5j4LL8zmojeVsR8J7qjC/FFhSqIFk7YMEtRDOn7ZKSyAY9knrh1iAefN2O8U8ztcLIotWSvvj6LhbW+I
 QCziCDnc
 FjLNtNM0tXBNJNDUV4z9qiA0L9oGz0bk4UFIdd3EMuMA7a+BRfQx0pBiMadTINau0+/AvZ/bj5Xcty834R0/OqadTQE4Gn5UUdxcyzY9vY3ozgoTIYyZSp0RYjLmL5QHdrN74OtkdrLP0BkbsyfGbxjFFs6HvLQpBVMab5NfOa2RY9pNm4jLFd/Suw+ITGMVkGdWoc3l/RAiVHvYiaxjb7NAEqAt3RM6EIQyrr83BG/9E5kl7Et50OOXzBx5ODnCV4AhdY8/ZbvXrddvL6aj7iKQxzw==
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
 kernel/liveupdate/kexec_handover.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ba568d34c5b4..5758dc6fab5d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1294,6 +1294,7 @@ struct kho_in {
 	char previous_release[__NEW_UTS_LEN + 1];
 	u32 kexec_count;
 	struct kho_debugfs dbg;
+	struct kho_radix_tree radix_tree;
 };
 
 static struct kho_in kho_in = {
@@ -1373,24 +1374,10 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
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
+	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
+	mutex_init(&kho_in.radix_tree.lock);
+	return kho_radix_walk_tree(&kho_in.radix_tree,
+				   kho_preserved_memory_reserve);
 }
 
 static __init int kho_out_fdt_setup(void)
@@ -1597,8 +1584,10 @@ void __init kho_memory_init(void)
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
2.54.0.545.g6539524ca2-goog


