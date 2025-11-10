Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 330A7CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 23:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953618E000C; Mon, 10 Nov 2025 18:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929C38E0003; Mon, 10 Nov 2025 18:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868018E000C; Mon, 10 Nov 2025 18:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 764358E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:21:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36E1786D18
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:21:17 +0000 (UTC)
X-FDA: 84096270594.05.A5F692D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 841D114000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:21:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mmWY40qN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762816875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46TR/sEczQ+2endRnnVwUIJHB5dy7B94vjCFZXto+D4=;
	b=6ms7AkK6aHtjkWaE/ky2vbVb3+TmVlnWuyp2lymh4BPwDTV8O8LsFo4EcxTcfK3VSfDNOk
	CFpXV0FPXfb/okf7IpIxMU8MSAi2dlKFv784+dbQMPLov73lpanctcYQUMIZ6SAibp0k8M
	b1lZjwWwtkPKmwYhEuSa+/cw81Cg1VI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762816875; a=rsa-sha256;
	cv=none;
	b=D65lAdYogydYl+OQwY8NCiYNL7XQ5z2EFcMaf2x+vF/eR11s5rBOma9hXsq6rJ+xdzX62S
	4EG5u3ymv+8j4ZZQCvnLuMw3Gp+88rM+pFXflbI9wESGCfTCbTi98hfkvNKW4+qfrssApU
	TvSRhy6iVxVnli/7SJqMOkhfqjU4/wU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mmWY40qN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762816874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46TR/sEczQ+2endRnnVwUIJHB5dy7B94vjCFZXto+D4=;
	b=mmWY40qN6VIF9ZxDo3HqTObvI92nLXnIOdn9QVUEniqCl+Q/AcuqeInjI3fOW+Drh5TLpA
	amlVqxwCPeEVsVDwCDbuiPFQpFlv30CJHJtBjDcnshma286fhPwsh3aiYmvELvFdy2MXDd
	R9Mv7CVSiOawTROCn3U/VA4oK9rpYgE=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH 2/4] memcg: remove __mod_lruvec_kmem_state
Date: Mon, 10 Nov 2025 15:20:06 -0800
Message-ID: <20251110232008.1352063-3-shakeel.butt@linux.dev>
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jr5ampiyocz1rtajqqfau7x31ze5oftq
X-Rspam-User: 
X-Rspamd-Queue-Id: 841D114000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762816875-579802
X-HE-Meta: U2FsdGVkX1+wF2qqa4CFDLAQ2whW/SfFh+a8WUNOVnlmN4JwaGcIoolXlUm2n8rgU7l0gJeF2tAiSeNtRPXHMDfTeP+MSluzuOQhQnsORYOuO7zEKVdiOppo4u3vDONfirPSwGz8nLgboZonnBFnjqO3Q4RPh3SOvfadj1Ezvar2qOgnRmYkKR+gB6OGdQdp1D8Np1z4Vpy+vdNnHV3i7AjxC/P7jgqPY5vOve+gn2yd7Ty7yUY4eCjnKBB4RRbEzRDbxowzgD1Q936tlEz8P61gFIN0OIBvW+S64BPbfbvALL/Iatx7uK0Kn9IY4J1j01Z2yfXvCOHz+xfT12mjwaPW+2acdJvvab6/hvoFvIcGKIyEUfVLedJB9q1nSKNjwfExMHIO1eAQRIfgA5NZ/qvAO3IMRn63yAAA0KeHrAroHqXMBvlor4Cgylk2O/Z4RUui3ZUIP8C4sclDD2ZblCawPj0ZC7zQkRkmgceE26VD8tP0RpErCCAlB00itBJFpAikXpDF4CHYm+KedaZf+V++Wy+AJDByc7/CZAMVDd3vRtCu6SF0ifabY/tX8KBNxo8qLc21Mz92UzcTLZ8yOJMoK3hxSc1wQhNr48lOkd9SLEgvpwsQjwm14Tt3bay/c9TzqusY3WHSrY/F2KfMUOz+zZJ62t5DFuBPym66mjMWOuSibjQiMc7wGkoYciMCf0VGY9phVrsaMqPCZsji9bd+y3z3TFEDaujfS73yUVwI80JyyunBcGp08K8WBNB+2QWiyMRE0QblzolXoxuk5nh6d9mF4VqFdqaJutcIKoapsBcBktXuIJjD3FYMKJhmfODkHCixt4PPeNdbzhsCA5B8Ge8a133dk29NaQu6vLuT4lrn/pMJ+zxdmR9CKpVNj7phnsnvrH3cp2Fqk8ZI+FKUp6rfmUw3XjriH1kQ9R54pkNwMZ8i7kt6r41vhaRIrY8zzKdpKAvFpEWJwM5
 7aAsG0td
 wLapFlDro9MBcwiaMZVS/zHM5vGkHwmKSVFkwp52EjI89os1vd9ip9/lrueCKvDIoZUIGe7Z0mGh0VliVh9LbBpANRYdYg/fJKNinnEwy6so0zWEmXOSaQDfwHHhPqwMzQ+VnrPmLoOuJlc9jCYlTMI+a7cCG3u/Z+bUkQCi5n+nWEoAt0xvO+BnbHJv9VaVzsWgIEwAIFJeEOKrxWhSTHN1j1+hJkuzSq3/LKSjX15DhX4jMI8otRONwPQwpNg3avQVWY6cYvd1JksGiaUSkq/5mpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __mod_lruvec_kmem_state is already safe against irqs, so there is no
need to have a separate interface (i.e. mod_lruvec_kmem_state) which
wraps calls to it with irq disabling and reenabling. Let's rename
__mod_lruvec_kmem_state to mod_lruvec_kmem_state.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 28 +++++-----------------------
 mm/memcontrol.c            |  2 +-
 mm/workingset.c            |  2 +-
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f82fac2fd988..1384a9d305e1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -957,17 +957,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
-void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
-
-static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
-					 int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_lruvec_kmem_state(p, idx, val);
-	local_irq_restore(flags);
-}
+void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
@@ -1403,14 +1393,6 @@ static inline void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 }
 
-static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
-					   int val)
-{
-	struct page *page = virt_to_head_page(p);
-
-	mod_node_page_state(page_pgdat(page), idx, val);
-}
-
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					 int val)
 {
@@ -1470,14 +1452,14 @@ struct slabobj_ext {
 #endif
 } __aligned(8);
 
-static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
+static inline void inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_kmem_state(p, idx, 1);
+	mod_lruvec_kmem_state(p, idx, 1);
 }
 
-static inline void __dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
+static inline void dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_kmem_state(p, idx, -1);
+	mod_lruvec_kmem_state(p, idx, -1);
 }
 
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f4b8a6414ed3..3a59d3ee92a7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -799,7 +799,7 @@ void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 }
 EXPORT_SYMBOL(__lruvec_stat_mod_folio);
 
-void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
+void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
diff --git a/mm/workingset.c b/mm/workingset.c
index d32dc2e02a61..892f6fe94ea9 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -749,7 +749,7 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
 	if (WARN_ON_ONCE(node->count != node->nr_values))
 		goto out_invalid;
 	xa_delete_node(node, workingset_update_node);
-	__inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
+	inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
-- 
2.47.3


