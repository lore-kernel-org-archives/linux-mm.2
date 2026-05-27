Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CC43CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E846B0005; Wed, 27 May 2026 07:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36006B008A; Wed, 27 May 2026 07:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72E76B008C; Wed, 27 May 2026 07:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99DC06B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E38EA05A5
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:01 +0000 (UTC)
X-FDA: 84812925162.07.0795725
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 357F180004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:07:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="HV/NdIPY";
	spf=pass (imf30.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880079; a=rsa-sha256;
	cv=none;
	b=QIMkis9X55bFZPzamyeerurdc4ZJUu/haaqBQcq5bxzny8JsPuVHM56I74IoTGg8sw7cxX
	g+dQ/T3CMUarbFt0P2mACvu1tUQxDXn+U3KwhNNNmOPmZR1LLbOpHBOlZjeb3iJwd/pQtF
	oxHd5deBvgUTqn+ghg8MnO4Cv/JeuP4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="HV/NdIPY";
	spf=pass (imf30.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4K1pyVwRMRi3Tdr5Z8KBrwSA1NH7W9DE8pnYNwT+wLc=;
	b=ezWGJT+3+ojkqDFA829uGJ5yCN/OTzSROUEyhKRyzQab7BtypzRkCC5zDcdbkGHCbtv+Fk
	CMNEA0slgE0VHrBpSg8A0KYvehCFPkUNNVxXWD2EXDO8xVapYNvyZI8Y+1tRc4czaCFDqG
	P929G6QeU2zF639zIj5q85OXhY3a6vA=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=4K1pyVwRMRi3Tdr5Z8KBrwSA1NH7W9DE8pnYNwT+wLc=;
	b=HV/NdIPYYiqXFPYqUUK1wrPzxBTWY0GpF9z3107mXb1Gim0j7Zzn+iqUoW4YHQqZCn32kLQsG
	iEV14jXbmsDMlpKJoeP8BOSnu0H1NblvE3u+XZa0p1VjmUfcJm62M3lFRKZIpnS7kCaxyVQjmB7
	Tq+TS9O2SsSJwwZtL7X8Vnk=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdX5CZ7zYkxX9;
	Wed, 27 May 2026 19:06:40 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:55 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:55 +0800
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
Subject: [PATCH 01/15] mm/rmap: introduce anon_rmap APIs for anonymous folios
Date: Wed, 27 May 2026 19:01:33 +0800
Message-ID: <20260527110147.17815-2-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 357F180004
X-Stat-Signature: q9xsopm5s7yw8bhx6d9hoqtgy6ddmmte
X-HE-Tag: 1779880079-855888
X-HE-Meta: U2FsdGVkX18bQvkoA1PsjpKMdLdkwHLxR58532PgURRdP1V2kkhSLYn0Nomph8SKcfbRmr/jIEuPSu5Y9CUvl2Dr0J2ZlB4T//JWTaYOT208kI5SU9V4CniClHrNY4Zw3ZWn4AH3b3MAWHvYZ4K9DjjdAgrqqa1h5GPMh+A2wz54+9MetADta+qLU7melx1ivqrgdfdjWlVFxcLsTvHIXt2JfZEKMuGabPhUF16x2O0O6sJwogupAJmADQIbf8j5Wk4yc5OCWTF9VGyFJWSdMTXk0LXEYIHxgQhPikZwIgckVTiHY1dQj5IhQDwMqBwvw0IMmcYA/KXWBEDWkm+/vUNuSmHdRUjf8FDt6kRHP0DLVCTjBEeLjWrdNbpzpxzAXJMCNMWwTLLWRQD9t2UBF8kVVE02RnqSL36BYysQjdO+8le+D9K2tHvbMwueTrk22Yvzk0uQNqmah3ttg9/xuZe8zNWPvO2y0F5FUZt0k8KoKrnVByHXFzh2EwDNywW39b8QHaN/0URBO+R34fUC0I/If5LMr/6sQsbkqd9MMb20Pm3XA7dSaISzjQBca8o9SGS9SpU5DSoCWlP/qQaGWMLjHl5dSxIfWvXFlK68/2WA12DvC9Br8hn7TBvsPj7mPSIBSmH1lvNGx3iafzGoGLA2KqmAAx/5WbQbX7JjWf9uXFMZNnHCBREzSpa58eRxv0N3b/oFYK21wJCI/tq7laXLr5HSvsIcNyeMoQcA+QEMb0V+UCkTxtIG7bR5A6aEVOArvgeAsFnPJRgQsBmG3A0KN6u5fNukHqZXFouLUUP95CbgBZF4LaIfIMYgfO92dAUnygmvjePLRNy6aJHP9YK2IGa3X28rB3ygcTTxRCy2UVVvLM/lyItzYricTspKeR+PtQpPVGVbJkrP/3ApVZRJZsvspJRMugZ5wkkVDORM6MAoksEvJtLFNx+LqPigSn8sGUn4bPGjOdc1v0P
 Toz94JGN
 5BJqAwjdzwK/h05RRiyuTUF4KuXdwerzQw7NU+UIx537SnjoaUtxpOWWXEMOnz8zkbXk06MTNQfDUHkV7TsMQcuw/K6axtsGTMdXWa1YewV6qMn+eXMk8JbOg//03Nzj9WW6HYQaH0e4w+Ltkd2Nd/CtfpYEHrwtmNvQbVjoLSXGNEDE37kjknOHv4z3H4YdKA2giAhCVV+HlJTlGR5XDKsuP0z1y3+Dfo8qSJq9nTEVMX+KwTBrW4kDl5HEyqrmN4eJVOGAJaktkX6XdCGH+l7rEzeRBWKNYyjB6voHCeFxd0+xLTKpOR/G19C0qCJDFsKun1LdNZcX28IHevqHGYvVKQAtyiT5CtgEL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a set of anon_rmap APIs to operate on the reverse mappings of
anonymous folios.

Introduce anon_rmap_for_each_vma() as a wrapper around
vma_interval_tree_foreach(), so callers no longer access the
interval tree directly.

This prepares the rmap code for upcoming ANON_VMA_LAZY support and
RCU-based lockless rmap traversal.

No functional change intended.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/rmap.h | 68 +++++++++++++++++++++++++++++++++++++++++
 mm/rmap.c            | 73 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..c42314ea4362 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -937,6 +937,44 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 void remove_migration_ptes(struct folio *src, struct folio *dst,
 		enum ttu_flags flags);
 
+/* Reverse mapping handle for anonymous folio rmap helpers. */
+typedef struct anon_rmap {
+	unsigned long rmap;
+} anon_rmap_t;
+
+#define ANON_RMAP_NULL make_anon_rmap(0)
+
+static inline anon_rmap_t make_anon_rmap(const void *anon_mapping)
+{
+	return (anon_rmap_t){ .rmap = (unsigned long)anon_mapping, };
+}
+
+static inline unsigned long anon_rmap_value(anon_rmap_t anon_rmap)
+{
+	return anon_rmap.rmap;
+}
+
+static inline anon_rmap_t anon_vma_to_anon_rmap(const struct anon_vma *anon_vma)
+{
+	return make_anon_rmap(anon_vma);
+}
+
+static inline struct anon_vma *anon_rmap_to_anon_vma(anon_rmap_t anon_rmap)
+{
+	unsigned long rmap = anon_rmap_value(anon_rmap);
+
+	return (struct anon_vma *)rmap;
+}
+
+anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma);
+void put_anon_rmap(anon_rmap_t anon_rmap);
+void anon_rmap_lock_write(anon_rmap_t anon_rmap);
+int anon_rmap_trylock_write(anon_rmap_t anon_rmap);
+void anon_rmap_unlock_write(anon_rmap_t anon_rmap);
+void anon_rmap_lock_read(anon_rmap_t anon_rmap);
+int anon_rmap_trylock_read(anon_rmap_t anon_rmap);
+void anon_rmap_unlock_read(anon_rmap_t anon_rmap);
+
 /*
  * rmap_walk_control: To control rmap traversing for specific needs
  *
@@ -969,6 +1007,36 @@ void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
 struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 					  struct rmap_walk_control *rwc);
 
+bool folio_maybe_same_anon_vma(const struct folio *folio,
+	const struct vm_area_struct *vma);
+anon_rmap_t folio_get_anon_rmap(const struct folio *folio);
+anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
+	struct rmap_walk_control *rwc);
+
+static inline struct vm_area_struct *anon_rmap_iter_first_vma(
+	anon_rmap_t anon_rmap, unsigned long start, unsigned long last,
+	struct anon_vma_chain **avc)
+{
+	struct anon_vma *anon_vma = anon_rmap_to_anon_vma(anon_rmap);
+
+	*avc = anon_vma_interval_tree_iter_first(&anon_vma->rb_root, start, last);
+	return *avc ? (*avc)->vma : NULL;
+}
+
+static inline struct vm_area_struct *anon_rmap_iter_next_vma(
+	anon_rmap_t anon_rmap, unsigned long start, unsigned long last,
+	struct anon_vma_chain **avc)
+{
+	if (!*avc)
+		return NULL;
+	*avc = anon_vma_interval_tree_iter_next(*avc, start, last);
+	return *avc ? (*avc)->vma : NULL;
+}
+
+#define anon_rmap_foreach_vma(vma, avc, anon_rmap, start, last) 	   \
+	for (vma = anon_rmap_iter_first_vma(anon_rmap, start, last, &avc); \
+	     vma; vma = anon_rmap_iter_next_vma(anon_rmap, start, last, &avc))
+
 #else	/* !CONFIG_MMU */
 
 #define anon_vma_init()		do {} while (0)
diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367c..1b2dada71778 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -701,6 +701,79 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
 	return anon_vma;
 }
 
+anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma)
+{
+	mmap_assert_locked(vma->vm_mm);
+	VM_BUG_ON(!vma->anon_vma);
+	get_anon_vma(vma->anon_vma);
+	return anon_vma_to_anon_rmap(vma->anon_vma);
+}
+
+void put_anon_rmap(anon_rmap_t anon_rmap)
+{
+	put_anon_vma(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+void anon_rmap_lock_write(anon_rmap_t anon_rmap)
+{
+	anon_vma_lock_write(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+int anon_rmap_trylock_write(anon_rmap_t anon_rmap)
+{
+	return anon_vma_trylock_write(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+void anon_rmap_unlock_write(anon_rmap_t anon_rmap)
+{
+	anon_vma_unlock_write(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+void anon_rmap_lock_read(anon_rmap_t anon_rmap)
+{
+	anon_vma_lock_read(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+int anon_rmap_trylock_read(anon_rmap_t anon_rmap)
+{
+	return anon_vma_trylock_read(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+void anon_rmap_unlock_read(anon_rmap_t anon_rmap)
+{
+	anon_vma_unlock_read(anon_rmap_to_anon_vma(anon_rmap));
+}
+
+bool folio_maybe_same_anon_vma(const struct folio *folio,
+	const struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma;
+	struct anon_vma *tgt_anon_vma = vma->anon_vma;
+	bool same = false;
+
+	rcu_read_lock();
+	anon_vma = folio_anon_vma(folio);
+	if (anon_vma && tgt_anon_vma)
+		same = anon_vma->root == tgt_anon_vma->root;
+	rcu_read_unlock();
+	return same;
+}
+
+anon_rmap_t folio_get_anon_rmap(const struct folio *folio)
+{
+	struct anon_vma *anon_vma = folio_get_anon_vma(folio);
+
+	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
+}
+
+anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
+				      struct rmap_walk_control *rwc)
+{
+	struct anon_vma *anon_vma = folio_lock_anon_vma_read(folio, rwc);
+
+	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
+}
+
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 /*
  * Flush TLB entries for recently unmapped pages from remote CPUs. It is
-- 
2.17.1


