Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B363C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649B36B00A4; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CD96B00AE; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46ECE6B00A4; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16056B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 735AD1C7E3D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.10.66BA737
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id 23F1740003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf27.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406424;
	b=w3ILgMnuNwS1F1kW0ZYa19rPG/mJs3yyGouksXaf/PSBeoPb05ZFeaOtUefDeCmQ57MdYW
	93bo5u/sUn0lHfDLH7MKSEqG1C39MmVkkVkVNOF/oBgGTTT0jGM99iC3V04glAOLZKcS9f
	LmTX5mpywdiWkjZZzd7GFEYmdRWFj0I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf27.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T+EB3Bs6Tc+TX0QDMHUKD9l3LyWUIYDVGvyqyXzKsrA=;
	b=SSozGbP+L9gnQrPpfeGlhw+pIK0/pvCbrrBaXryardAZRTScHdsrLXnCXRm/sV1XbuMB3f
	M90N/MPveliyc/lZSJRvtysrOBiM8OTdTdYf5PjdQaJr6+rYIXnUHuGmCLHtE4gVFHHKsu
	ewrsJjA9S/dyTEUjLVPBAtkQQA9p09M=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvWnH2XkwzYm5Zg;
	Tue,  7 Jul 2026 14:40:19 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:19 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:18 +0800
From: tao <tao.wangtao@honor.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>,
	<ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
	<baoquan.he@linux.dev>, <nao.horiguchi@gmail.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <damon@lists.linux.dev>, <shakeel.butt@linux.dev>,
	<ryncsn@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>, tao <tao.wangtao@honor.com>
Subject: [RFC PATCH v2 06/13] mm: implement unlink_anon_nodes for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:01 +0800
Message-ID: <20260707063308.29176-7-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspamd-Queue-Id: 23F1740003
X-Rspam-User: 
X-Stat-Signature: oio8becj7wctb1oiqxjgf7jcdj9ogcq4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783406423-703050
X-HE-Meta: U2FsdGVkX1/F6IN/JpuDKcqAmJl7n5saoIls2iFr7o19qhV54bl5M+85yan6NYV/nGG4d+E8TYFUaASJaUiw6NiZ7on8eNYwmXmDkGaiuB1hAiGi/zkJ1n6Oa2dW1/Ex7zzToGpLhTu4F8ZAx5V1UvT0O1LjTzV0vol7JuKTzJdzU09r/nJYFGbdkis0hQDu0fB4w9Mwg4zLbKO63ceavPtQInufNuWxGNfjHXMyqQK693Cy6Xuqpeb5jd7aTHi4gVdls0oRmY08PSCfp8LSr0RMd3OrNqL/H7MU3+BRZot4oniWANvViZ2IyNunyD8OmXHiJKAnmEmPAKnDfMB8nj3hPPPNr4tG6RXsSW0Q97RFZyDzpMQEOnht/iBOTdJP/lgdtlc3AwV/EEsNTqo05M9leCz8p6j12S5HL5R91BTpcb554vRHA1HOIj/aN+mGJIGyyhMcuDgUEu0UUmA4F1BF2i49NlGbgIV7U3vsxGYL7kB9W22tUl3eBy9vEx0CPYpNe1A5Xp1uHY79Fzrm9kYHeziBUmshAKEa63XGRR2iShhqxZHwXQJHJjzpcZEpI0rR7kLPorbFjjk2OiUEKyjIRDDKPoDbs8SjlBfKns/pkcqZDp4DLqBep7eCcW1bPDlZxpKXaEgEz3rWDgsyWrw53d9WZCQmQ+3mAluTeYujpHRohAXI1VYklfTcwQDLfkgADJ7UEnyP16KAq8gCBn+z9J3QfHBeHsoakF6fZMkzejZH67X9y2xDMniQOPzIjVIoVuXg53m/k0fw38hau7qGaUPxlUHO8Ryz0QrzCR7WHvfY16u/PBX3AWT29N9VD3P5Yc1bxTjgKngRPcuXRUwfjuNBeCeq8Oje/L4/rZ9A1F7HWHbaAP1/FsTDSKXdafvZQNftdsNZr+BSSwHAzm7zC6kYtpONT7VFzneOh8vI281txvoJYuBOrZ0wvsp4QgcG/j6gh06NLG+7I/j
 pJjqOqXA
 bhIKdB2yYT0Ky4IgVHji40QZm03QEMHoj94IlZ/D/O2PCJ0rmnlFw5RUfmkeRXIr5AH2EN/w1VyEz+hrkY7A+6G2oUOtR4j98/y4UxYrmYa/IX1fibptv9O4z/HBSsr6ScyHFO6fqoa5wqf/3uVmgZ1qEOw8rRGoHtkBqE7Roq2D9VkMAjzMsO/oCOYBThDPmg8op1XM4nZJ828N67mL+mRLIiHcbt03NVVHg4eLxwQrFapxXEJ77i04Q+uYqBOeKp3QscrgTLmCgUyzGB80cvJrGCAyzT57juYpHZEsZR5uqoiO/9ylapbge5HI3ZwTCODMwGVRSNG77qkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Detaching an anon_node may require traversing or removing it from the
fractal list, so the lock must be held.

Releasing an anon_node may propagate through the parent chain, while
the actual release can be performed outside the lock.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/rmap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index 93fa04c5a007..ea3557d3b56c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -859,6 +859,94 @@ int anon_node_fork_with_prev(struct vm_area_struct *vma,
 	return anon_node_add_child(parent, vma, true);
 }
 
+/* Returns true if untrack succeeds. */
+static bool anon_node_untrack_rmap_locked(struct anon_node *anon_nod,
+		struct vm_area_struct *vma, struct anon_node **release_node)
+{
+	struct anon_node *root = anon_nod->root;
+	struct anon_node *node = anon_nod;
+	struct anon_node *empty_nod = NULL;
+	bool test_empty = false;
+
+	do {
+		if (try_untrack_rmap(node, vma_rmap_base(vma), &test_empty))
+			break;
+		node = anon_node_next_rbc_child(anon_nod, node);
+	} while (node);
+
+	if (!test_empty) {
+		VM_BUG_ON_VMA(!node, vma);
+		return (bool)node;
+	}
+
+	if (node->nr_children == 0)
+		empty_nod = node;
+	else if (node == anon_nod) {
+		/* Replace an rbc child. */
+		node = anon_node_next_rbc_child(anon_nod, anon_nod);
+		if (node && try_reuse_anon_node(anon_nod,
+						atomic_long_read(&node->rbc))) {
+			atomic_long_set(&node->rbc, 0);
+			empty_nod = node;
+		}
+	}
+	/* may be released up the parent chain */
+	*release_node = empty_nod;
+	while (empty_nod && empty_nod != root) {
+		struct anon_node *parent = empty_nod->parent;
+
+		/* delete the empty_nod first, release later. */
+		list_del_init(&empty_nod->fractal_list);
+		empty_nod->mm = NULL;
+		if (--parent->nr_children == 0 && !anon_node_rmap_count(parent))
+			empty_nod = parent;
+		else {
+			empty_nod->parent = NULL;
+			break;
+		}
+	}
+	return true;
+}
+
+static void release_anon_nodes(struct anon_node *anon_nod)
+{
+	struct anon_node *root = anon_nod->root;
+
+	while (anon_nod) {
+		struct anon_node *parent = anon_nod->parent;
+
+		put_anon_node(anon_nod);
+		anon_nod = (anon_nod != root) ? parent : NULL;
+	}
+}
+
+/* Remove link between this VMA and its anon_node. */
+void unlink_anon_nodes(struct vm_area_struct *vma)
+{
+	struct anon_node *anon_nod = vma_anon_node(vma);
+	struct rw_semaphore *rmap_sem;
+	struct anon_node *release_node = NULL;
+
+	/* Always hold mmap lock, read-lock on unmap possibly. */
+	mmap_assert_locked(vma->vm_mm);
+
+	/* Unfaulted */
+	if (!anon_nod)
+		return;
+
+	rmap_sem = anon_node_rmap_sem(anon_nod->root);
+	down_write(rmap_sem);
+	anon_nod = vma_anon_node(vma); /* Recheck after locking. */
+	if (anon_nod) {
+		anon_node_untrack_rmap_locked(anon_nod, vma, &release_node);
+		vma->anon_vma = NULL;
+	}
+	up_write(rmap_sem);
+
+	if (release_node)
+		release_anon_nodes(release_node);
+}
+
 
 #endif
 
-- 
2.17.1


