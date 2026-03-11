Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12061105D26E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D5C6B0092; Wed, 11 Mar 2026 07:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403C16B0093; Wed, 11 Mar 2026 07:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B0F6B0095; Wed, 11 Mar 2026 07:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 132396B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:03:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 992951A074F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:56 +0000 (UTC)
X-FDA: 84533497272.12.D06DA87
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9C27B40011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YDOcdxayX2Dacmq8PCNMbYZCBcwJJYR/d2ycAVdR0Xc=;
	b=LldvFfmIqLEX4nMFrXfs/l9E46EMd6Bc9ojCtdLn9w80EIRmMcF7FIVQdKAearWJhJQngh
	iUhRfzHLCpN3lLXGKsEVtZsL1PbYV9VVNBftyXxisw+zj/6iay6ioq2dUdA6lSE7xWUpkO
	BzXmzxtk/Buzs72yItKuTnwZwY4BZmY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773227034; a=rsa-sha256;
	cv=none;
	b=63UsPc1BeAddGiZQ9MA/B1X43LL4+/uJ2MpNTjKVFB19PTN+xcOhG7oSR+TSHqRs9QsdAu
	kN9gJ6OCgrnRMCVa+MYUvTUPkVEFkstWlX6GuMMFqbNI2glpgSE7PTqbk9szyt7Ekf2jtF
	k1snYb8UYiwSDQbVcKa83FAFdTiLWBY=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 26B45432F5;
	Wed, 11 Mar 2026 11:03:49 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org
Cc: alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 2/4] mm: Rename node_get_allowed_targets() to make it more explicit
Date: Wed, 11 Mar 2026 12:02:41 +0100
Message-ID: <20260311110314.237315-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311110314.237315-1-alex@ghiti.fr>
References: <20260311110314.237315-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeefjeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpefhjeejtdelteefuedvffduheeifeeggeefudevfefhleduvdeutdeiteeukeegveenucfkphepvdeivddtmedutdgumegttdelvdemgedttdemmeehmeefrgeivgenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepihhnvghtpedviedvtdemuddtugemtgdtledvmeegtddtmeemheemfegriegvpdhhvghloheprghlvgigghhhihhtihdqfhgvughorhgrqdfrhfegofekiedvrfdrthhhvghfrggtvggsohhokhdrtghomhdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhqihgupedvieeugeehgeefvdfhhedpmhhouggvpehsmhhtphhouhhtpdhnsggprhgtphhtthhopedvkedprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvgigghhhihhtiheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhrtghpthhtoheprghkihhnohgsu
 hhmihhtr
 gesghhmrghilhdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C27B40011
X-Rspamd-Server: rspam08
X-Stat-Signature: rdm7r7jd7srjk75b71a56dwhsgza4416
X-HE-Tag: 1773227034-620385
X-HE-Meta: U2FsdGVkX1/VUuktU/mKgTW1JAYCQkLhc3szgdJ9iGjsaTKaeXEvWlGpFks2bnJLAEtl3wGo8w0P2vqCAmAS+IE3cGYUS01hpNAUTz4nB97yWeOs10MhNN0m0DC/MqpHoXoCi4TVsh3pcwkmNhhgX0nIFwQoFh167M7HwxBs+wfyA+rkOvMcFd9hKALm4YbbmVzFrjfUYSI79hgp88VAt5zuVyINY6sfm5SAjxv3l+PVWtGVOl40vg+lzKxVH4j1QvHRXvwthd6T8TIXdqKhcxPz2yuvRl3GhhtohyE2tnikm14+P/3++9LfzLEVLigfG34U2M31gNDxTXkERAAxu7/MAx9k9X7FQ70SB2491PkiglJexoteAAbmcuuOUogUFN8PbDYja20j6mpqiwOO0BabVUbZX7p6Ed4jdxeRBubR3TvArjgbb6BIc1oZ0WTAyBBZWf8Yi9nFaJYCmUeMgnIuwHjaByj96BoDpG2bH4xBp1lfNfzq3fV5EDyLtmjKeXncDZ7AJ3mdsJnkJ96nKOlWZe92mZfYNfjQ70qJtZ9ncmav3fGtxk7nUm5OpcQ8e5LsEG6O5k6gTeushwReFR7JeD8zqUuSzwxfFkJXR0ZGiBfebgTyhxUHc/NlTvZDuxEKUjKLGg3pm7zBW4pHDLZnkrMl+912Ubno5PcnafuivZ5waN2VIeuM9H/0yOtHg6oxRHUCUav3+kx6lbFxQ+t/GDVS2a8gacttsn7kt2RkK2CnG3O6WJW+neAbN9eKgioTdR86k4iBk4Y1wG9zUncYIFCXBFqdoSFQgs5Dk1Qo+Ku210RcWfeASX1FxjSjLtGPRICypUtWMe6ptsNSoozm1yjrFK2Wt5Vd895bhZZZ1v5wOSaM3UPLdFFldmsYK6epmrvT2x/hVC18uv8YWs137ri7pxCOlX/O2tRdQTaDcJf8UMT4WmmGMdBiid+wDIdiP3d85v7F553muKn
 yk7FlTNN
 tyPRNn//7+06IrWT0uIsBtNGQrhA5L0+4Thlrh95Jx1xTQveiJv0b2iEzsJgAZS9LfWyXWH+e2T9qVBdmvYlFtmuPxfZ7im+pnSZWQft9pg8ExMr++iVJaaVtw2lwPTvXI0tH8UB10g7oAFWXkDJHu2BFfr420juKNmOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function actually returns the tier nodes that are targeted during a
demotion, so rename it to be more explicit.

No functional change intended.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memory-tiers.h | 6 +++---
 mm/memory-tiers.c            | 4 ++--
 mm/vmscan.c                  | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 0bf0d002939e..ec39dc3c39e6 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -54,7 +54,7 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
-void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
+void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
 unsigned int mt_demote_folios(struct list_head *demote_folios,
 			      struct pglist_data *pgdat,
@@ -65,7 +65,7 @@ static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	return NUMA_NO_NODE;
 }
 
-static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
+static inline void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
 {
 	*targets = NODE_MASK_NONE;
 }
@@ -117,7 +117,7 @@ static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	return NUMA_NO_NODE;
 }
 
-static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
+static inline void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
 {
 	*targets = NODE_MASK_NONE;
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index afdf21738a54..19ecc9b6bbda 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -300,7 +300,7 @@ bool node_is_toptier(int node)
 	return toptier;
 }
 
-void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
+void node_get_allowed_demotion_targets(pg_data_t *pgdat, nodemask_t *targets)
 {
 	struct memory_tier *memtier;
 
@@ -428,7 +428,7 @@ unsigned int mt_demote_folios(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;
 
-	node_get_allowed_targets(pgdat, &allowed_mask);
+	node_get_allowed_demotion_targets(pgdat, &allowed_mask);
 	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
 	if (nodes_empty(allowed_mask))
 		return 0;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5e0138b94480..11a97ee8f583 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -351,7 +351,7 @@ static bool can_demote(int nid, struct scan_control *sc,
 	if (sc && sc->no_demotion)
 		return false;
 
-	node_get_allowed_targets(pgdat, &allowed_mask);
+	node_get_allowed_demotion_targets(pgdat, &allowed_mask);
 	if (nodes_empty(allowed_mask))
 		return false;
 
-- 
2.53.0


