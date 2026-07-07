Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F80C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8246B00A2; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467E76B00A5; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CF46B00A2; Tue,  7 Jul 2026 02:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 046A96B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 849C11C33F6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:24 +0000 (UTC)
X-FDA: 84961031568.20.D6CA64A
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id 416C5140003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=iasSZFKR;
	spf=pass (imf23.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4P7InBYaG4rmwPlF5sL6FgR3mPgxPHfvBAsEBV5dVQ=;
	b=PGUGp5bRejy1Ln7QY3JAgMuXr2B6i8+7rUeN0pWQqOr44kkdIh0zxpP/X5sOvIrEnt5Aog
	G+rbW+Wa7DbX7DANoeixR2a+avodmBwtcqQBEWRY6GhdRZSBTp0g3FqYEyDHapMQVCclsg
	m7+WoQmMZGnsYOo/X2sMULw1IFxYBNg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=iasSZFKR;
	spf=pass (imf23.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406422;
	b=zj147C0n7fdmpdyLyOv0mw1tWk/cpfpfAL5Li3lmB11Jm+44vi2uaJSgXcKL+WY1HcW2Np
	Wg0/YhBFQPLpz2zujJnmaZGfwd2pyDqLLuQK3mshAdswN6a0smMtWtWIx08/7ShDyUZq+X
	of8fxkg3nyVNvx361y39dKR0mxsBM6I=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=O4P7InBYaG4rmwPlF5sL6FgR3mPgxPHfvBAsEBV5dVQ=;
	b=iasSZFKRAL1e27RLlbdaqxBrk0RdlshKlJHzamh6aX7qZRA7go3a55bxpUovpbC87MTgiZ2Aj
	oFkGbCMbmT+6obXaXwRkkyKa24hF+U4iQU2O/TDA9g5161vl/QfSvAXtLnIgRfQazWda1bogdIi
	GAuFp9YVDvHPkgkc/gya1ao=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gvWnF61KPzYl1nh;
	Tue,  7 Jul 2026 14:40:17 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:17 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:17 +0800
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
Subject: [RFC PATCH v2 01/13] mm: add CONFIG_ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:32:56 +0800
Message-ID: <20260707063308.29176-2-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 416C5140003
X-Stat-Signature: 1rddn79jpgenm5gc7tesr669ecmm3jee
X-HE-Tag: 1783406421-742595
X-HE-Meta: U2FsdGVkX19VecNKB1QPiqsHaSt+m4FAGwYOpnJs0Bg3qak4TXvRq0broc3PMY+N2N+zhPIGEQ9F/ZHsioORuKkkcN8vOHdjc6t1xGAVBW8t+M44357xHNMdlcBzzELhFZ1Dv4WgHQ2CjmXoHdRa58V6shjBW1I0njfvnBG1/3jlhT1SuxxjeM528rFdMsyxX8mZI4kIrF4Wu+Veu62WrXpPl2RekGRDJrEGCyiPJZXQ+2xmDFaKWh3lkPHNCmiblKptN7IYu/96sPedHc827gj9krF2ytwKnSrsiRKZcw8z3DwSIsUOXbxw41MTViYvJpF6oV+tFKQRMSM8RXpW2PN1cFhZ4JLx4/lTppS0reX3GYj/8nju5+dSOgFZ6wVe0tUNruGG6YIx97TzyGAv6UcpczO/nUAgxWWMG+4TeTEEgy17UEE9I6G3GYLsMqtQOlkpKX2NyT6Wre5FdiHtZDizxWAzkDPENQ7SFsmEs8EuNEdsbvnMDfW2Gr+0wxoqTF/AvtyeOdxwOmrNRusNhy9axAxtfJI2yxB50pQMzjLRFA4j0UIiytYGcWaUg7lI3s7IVeAujJfCFzOawWqnZQ252L6aSq0T3CRhJtUv+SX+JB3jSu36ctqCnK6unsgndsAZZSpu827Uaqm8EREeb41r5jR4smHA+hpvK3niw/n7JnDEf+iFpoxtXrqcdx1desquJaYoO/ZCWzTLIbE0/3dQGo2sJi2ImZq5iYBrMWIr9zhdb014HrjOsz3pppwLzljNtoM0iwqGJk8YxrWg6fbnHmGuCt8kTW4WdBlSXzKGCl29BS36F5aSJGP9Zpy5+n+IYRxrERJzf8jmg3STpR04Eas1T2bKIeXWCZktnDWnt+SVBCTP5WZr6uPrOOuLSPgfcpN/lFLiQhn6pO8slGcYA7a3qWGZlSal2kTOKDQRrq9AFWgfweyHwC/Cgxh5+ToaLkSGo27StATIMu4
 J/N1PQ7B
 m4W+eyBH+P4+n1vJ1Cdlz/nV9+VQfbL+fG4DJwn4r+tWqIcPXIVNJMY4VwImkOVObdHtviIvxZ/Mdth03ncJcLpm4lh02PiYfbr86oOyg+v6fHg1z6bUBINyUrf6zcrYXUouN+99DYmomSEkgVivdSBREtBvxo5hVE/m51pSRZdJBfmIeGwbdC3dnwVLLgQWdhkHmaVr9Wqk6s7fyhcs2a4bj6JlyCnV7U06fF9qiMcqbX8H0nu+TSgBGaucT1ZtOcTdDaGvr2B20Nheu57z2Q9/E5frxQN2XeK88aHchrzpsStPuv5OUmUq5WYAgfcbG+NcWX3zfYyPIJBJUqJHYawfKUY6smlgF/x0EmIB9omneC6ufy4xYwrC7DKcegs4JMJJaZ3byPvPfQD3FR62LdO2hvbMFhEJcZwWX3ffpUYw26OeVhGNYWZBzkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use vma_rmap_base(vma) to compute page addresses during rmap and
look up the corresponding VMA in mm_mt. Since vma_rmap_base(vma)
remains invariant across VMA merge and split, VMA operations only
need to adjust the VMA count of the corresponding anon_vma,
eliminating anon_vma_chain.

Fork creates derived anon_vmas in a fractal-like structure. A list
tracks anon_vmas, while fork depth is used to locate descendant
anon_vmas during rmap traversal.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h | 48 ++++++++++++++++++++++++++++++++++++++++++++
 mm/Kconfig           | 28 ++++++++++++++++++++++++++
 mm/internal.h        | 28 ++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..75738f4ede1f 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -67,6 +67,54 @@ struct anon_vma {
 	struct rb_root_cached rb_root;
 };
 
+#ifdef CONFIG_ANON_VMA_FRACTAL
+
+/* struct anon_node - Replace anon_vma for anonymous page reverse mapping. */
+struct anon_node {
+	struct anon_node *root;		/* Root of this anon_node fractal tree */
+	struct rw_semaphore rwsem;
+	atomic_t vm_lock_ref;		/* for vm_lock_anon_vma */
+	atomic_t refcount;
+
+	struct anon_node *parent;	/* NULL if created by a page fault */
+
+	/*
+	 * depth is initialized to 0. When a child is added, depth is set to 1.
+	 * An rbc child has depth = parent->depth + 1,
+	 * and fork child has depth = parent->depth + 2.
+	 *
+	 * A forks B and C; B remaps D and forks E and F; C forks G.
+	 * The fractal_list is as follows:
+	 *                  (1A)--------------o
+	 *                 /                   \
+	 *               (3B)      (3C)         o
+	 *               /         /  \        /
+	 *             (4D)       /    \      /
+	 *             /         /      \    /
+	 *           (5E)----(5F)        (5G)
+	 */
+	unsigned int depth;
+	unsigned int nr_children;	/* < PID_MAX_LIMIT + max_map_count. */
+	struct list_head fractal_list;
+
+	/* mm and rmap_base can be used to find the VMA a page belongs to. */
+	struct mm_struct *mm;
+	/* rmap_base with VMA count in the low PAGE_SHIFT bits. */
+	atomic_long_t rbc;
+};
+
+/* Create rbc child anon_node on VMA remap or when count exceeds MAX. */
+#define ANON_RMAP_BASE_COUNT_MASK	(PAGE_SIZE - 1)
+#define ANON_RMAP_BASE_COUNT_MAX	(ANON_RMAP_BASE_COUNT_MASK)
+
+/*
+ * Allow VMAs to share an anon_node only if the number of VMAs attached
+ * is below this limit; keep it small to reduce lock contention.
+ */
+#define ANON_NODE_SHARE_LIMIT	(ANON_RMAP_BASE_COUNT_MAX / 1000)
+
+#endif
+
 /*
  * The copy-on-write semantics of fork mean that an anon_vma
  * can become associated with multiple processes. Furthermore,
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..c4c6d3e52d72 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1451,6 +1451,34 @@ config LOCK_MM_AND_FIND_VMA
 	bool
 	depends on !STACK_GROWSUP
 
+config ANON_VMA_FRACTAL
+	bool "anon_vma fractal list"
+	def_bool n
+	depends on MMU
+	help
+	  This option uses vma_rmap_base(vma) during rmap to compute the page
+	  address and look up the corresponding VMA in mm_mt.
+
+	    vma_rmap_base(vma) = vma->vm_start - vma->vm_pgoff * PAGE_SIZE
+
+	    page_address(vma, pgoff)
+	     = vma->vm_start + (pgoff - vma->vm_pgoff) * PAGE_SIZE
+	     = vma->vm_start - vma->vm_pgoff * PAGE_SIZE + pgoff * PAGE_SIZE
+	     = vma_rmap_base(vma) + pgoff * PAGE_SIZE
+
+	  Since vma_rmap_base(vma) remains invariant across VMA merge and
+	  split, VMA operations only need to adjust the VMA count of the
+	  corresponding anon_vma, eliminating the need for anon_vma_chain.
+
+	  Process fork behaves like a fractal expansion of both tasks and
+	  anon_vmas. A list records forked anon_vmas, and descendant anon_vmas
+	  are derived from fork depth for rmap handling.
+
+	  The fractal list remains unchanged during VMA merge or split. It
+	  is only updated when anon_vmas are created or removed, and traversed
+	  during rmap walks. Since rmap_one operations may switch tasks,
+	  semaphores are still required instead of spinlock_t protection.
+
 config IOMMU_MM_DATA
 	bool
 
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..a33ed1a30f09 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -202,6 +202,16 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
 
 #ifdef CONFIG_MMU
 
+static inline unsigned long rmap_base(unsigned long vm_start, pgoff_t pgoff)
+{
+	return vm_start - (pgoff << PAGE_SHIFT);
+}
+
+static inline unsigned long vma_rmap_base(const struct vm_area_struct *vma)
+{
+	return rmap_base(vma->vm_start, vma->vm_pgoff);
+}
+
 static inline void get_anon_vma(struct anon_vma *anon_vma)
 {
 	atomic_inc(&anon_vma->refcount);
@@ -245,6 +255,24 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 	up_read(&anon_vma->root->rwsem);
 }
 
+#ifdef CONFIG_ANON_VMA_FRACTAL
+
+static inline struct anon_node *anon_node_next_rbc_child(
+		struct anon_node *anon_nod, struct anon_node *node)
+{
+	node = list_next_entry(node, fractal_list);
+	return node->depth == anon_nod->depth + 1 ? node : NULL;
+}
+
+static inline struct anon_node *anon_node_next_descendant(
+		struct anon_node *anon_nod, struct anon_node *node)
+{
+	node = list_next_entry(node, fractal_list);
+	return node->depth > anon_nod->depth ? node : NULL;
+}
+
+#endif
+
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 /* Operations which modify VMAs. */
-- 
2.17.1


