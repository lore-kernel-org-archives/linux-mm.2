Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DE4CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282C36B0092; Wed, 27 May 2026 07:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236016B0093; Wed, 27 May 2026 07:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF8F6B0095; Wed, 27 May 2026 07:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1E4F6B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B697405A1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:04 +0000 (UTC)
X-FDA: 84812925288.06.4D27F9B
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id BBE39180014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880082; a=rsa-sha256;
	cv=none;
	b=TjUgYGarAx/ut93nqgTatfBaDvIWna22GwsMIYgPvaeKf6/o+Lxra29Arn/Bar2JSO3+rI
	7BHWajw+llv5Y4x5YBW7/adithMOZ4ZwyyEu8Y8pb/q4fdR/Q+9Ii6UU/y9x7pMenVOl1P
	KM8Q+i9vMPaEUVHxS3aQMWk+7mhgf8o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DckKz+F9uoxLnbdrHermkpnAMaLEVg+FcDEWTb33Czg=;
	b=pi4jiYy/UHi1QPplCI23nXBoqLf5qzqfF8AUHzKFBZ7fEnuosNLos5mMWe5AAqwPeWe9hL
	XvoUqrykk91mOCAlxHDjVY+wK8ou7fJQeUsGR6DifM/aHM/e+LJUjMkMhfv+0i86D4UrrM
	wpn4b0RbVdGUR1VgWfVOKAAM5JqueRM=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdL5rLWzYkxQN;
	Wed, 27 May 2026 19:06:30 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:57 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:56 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 03/15] mm: introduce anon_vma_tree_t for multiple anon_vma topologies
Date: Wed, 27 May 2026 19:01:35 +0800
Message-ID: <20260527110147.17815-4-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Queue-Id: BBE39180014
X-Rspamd-Server: rspam03
X-Stat-Signature: ns76e67pwjjdy8trwoqk5ssb8d78hru1
X-HE-Tag: 1779880081-396270
X-HE-Meta: U2FsdGVkX1966BaRlJ1hc/tKDkjR7VlMqMPcmnVoBIOdbgnT8DKIw6YsL0NLUYRk97rNZpCLNxJJbkmI9jvmbEvVSiPDOIn8ciPIHslj/5z1KfjMQYlKJ6YESqXnJPZG2ujOSLFUQWkoZvbFNVMFfOcyXxQBcPR3MIs/BsUGPSwGGWil+sbiWuIaiGdAeY1xan6fJdcscHAAJN5Aj9pRO0u8QldIIHqhe2SwNnthFChd1j6yki+TpjU0cUUi6JiMUBmsJMtvRwrQ/rl7AZFdWUtMk1RE31J/PTiXmQoPW+49wPTzkwD3KnzqampFdR6hUHP/JV85We0XJ6wEx14XhtrHvEwqSChvMuO4fiFLXU1L1FylFiF7a7+J9FxGjIRlAGgOTj6qcRazRyz1N7tDE/Cyw7OsDqjeudWZgLVNT0oCVJ0rsV8R7C3YxK9xFRp+bkiqmfU09Ps8TWtWsGVZ8Ju1+tjsD88J3JgYyTVmI/8knxQrRDMMDuzE05qc0E5PkM1HdW1OdZbfjAndBSe3EpUzvX5zvSbwgaBwnhvVeQNxLCWadFEfpiehnq04mDJVFFmS1uY5rMDWzjsh0+aFsaprqZdlsV4EK2Yv6pRO/l5aN09bVNSaVKc1URGV5yV7AciIuXdWHsLA7evwa6aA7kKptFtmZ+ZV2WqNIZHaqxIEFpdx8V6R3zqDBS1ptK7I3VU89XKPG8ay6+M63sPiXvAo8GxFbGxWb7w6Dwg20jpKnUMa5c3vdRrQq1GRlzgDLHARe+qWCWxouWbmyjluzebbiqSsb3gG8tfQeXjpkNsFt5B8mR6m3XIxhRqFGWcuoOR8QfXKp1FOvCtJTtZ8OUcAc64+iXoVAqmfHF+RE/0RHgLVklRjtSFq7pB0LQXvivL9Ya1zE2sq6LV2WGZQypJ7CWvip9WNp1LgbdJOeo9ug3qoNpZpttt1raJe3FhGycJDiI+xS7JCdLSFMmI
 4fxRsbhv
 oBqvGoXSYkRtqT3zuFETYtowKpwmISFWxxPEeyHwjnaaIG+cm0EsfocmNpkQHywrzo2PNkmu8TvCnM6Y4Cwg8LcO3kaXA1ulYqZOJZAkwWMMLlWatRFC2pRDLnRa0x1sSsa78zB+Kv6TnZ73clL7mSZuuSomCIc300Po0Myb9dL6FJ5exyI6dKDfzIwL4ekRXDcZ4azZRqarwi0os+sYQDXXNkxy4Ui7hem9kgI7Z9FFKm6ZXlhCFG1nHCokZl6D5XK/Mxtg4bd9a/dAG1/+M/b/+4vXuUfmznnfkIB7VHqHqwc64jtKEiBvf8LcdTvZqcVi5FhID/iva76Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for upcoming ANON_VMA_LAZY support and RCU-based lockless rmap
traversal by clearly separating anon_vma topology handling from the
anon_rmap semantics.

Prepare for supporting multiple anon_vma topologies by introducing
lightweight abstractions used by the VMA and rmap code.

Introduce anon_vma_tree_t as the type stored in vma->anon_vma:

    typedef unsigned long anon_vma_tree_t;

It represents a tagged pointer encoding a reference to the anon_vma
topology. The low bits are reserved as type tags to distinguish
different implementations (e.g. regular anon_vma and lazy anon_vma).
This keeps the VMA representation compact while allowing the topology
to evolve without changing the VMA layout.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/mm_types.h |  3 +++
 mm/internal.h            | 54 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..5f4961ea1572 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -917,6 +917,9 @@ struct vm_area_desc {
 	struct mmap_action action;
 };
 
+/* Tagged pointer stored in vma->anon_vma. Low bits encode anon_vma type. */
+typedef unsigned long anon_vma_tree_t;
+
 /*
  * This struct describes a virtual memory area. There is one of these
  * per VM-area/task. A VM area is any part of the process virtual memory
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..76544ad44ff0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -246,6 +246,60 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 	up_read(&anon_vma->root->rwsem);
 }
 
+/* anon_vma_tree_t APIs */
+
+static inline anon_vma_tree_t make_anon_vma_tree(struct anon_vma *anon_vma)
+{
+	return (anon_vma_tree_t)anon_vma;
+}
+
+static inline struct anon_vma *anon_vma_tree_anon_vma(anon_vma_tree_t anon_tree)
+{
+	return (struct anon_vma *)anon_tree;
+}
+
+static inline void anon_vma_tree_lock_write(anon_vma_tree_t anon_tree)
+{
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	anon_vma_lock_write(anon_vma);
+}
+
+static inline int anon_vma_tree_trylock_write(anon_vma_tree_t anon_tree)
+{
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	return anon_vma_trylock_write(anon_vma);
+}
+
+static inline void anon_vma_tree_unlock_write(anon_vma_tree_t anon_tree)
+{
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	anon_vma_unlock_write(anon_vma);
+}
+
+static inline void anon_vma_tree_lock_read(anon_vma_tree_t anon_tree)
+{
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	anon_vma_lock_read(anon_vma);
+}
+
+static inline int anon_vma_tree_trylock_read(anon_vma_tree_t anon_tree)
+{
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	return anon_vma_trylock_read(anon_vma);
+}
+
+static inline void anon_vma_tree_unlock_read(anon_vma_tree_t anon_tree)
+{
+	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
+
+	anon_vma_unlock_read(anon_vma);
+}
+
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 /* Operations which modify VMAs. */
-- 
2.17.1


