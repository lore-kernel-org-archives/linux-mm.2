Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03C9FD0655
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB046B0093; Wed, 11 Mar 2026 04:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60FE6B0095; Wed, 11 Mar 2026 04:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC796B0096; Wed, 11 Mar 2026 04:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F16B6B0093
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:26:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 023591391AA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:31 +0000 (UTC)
X-FDA: 84533100624.12.EB1C90D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4DD9414000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tVrbszXt;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKYqOmThISUuvmbvRutrRX7Tdp1JKiZGTlMciMR9WLY=;
	b=32FLBjpcZ6skxbq4/8nk14dZzUENNjY+Ur9P+QEwaUTcaP52MLmk7PP96dzLXRnYnPPY3n
	eNegvprIrEhXYU2jKM8GUp/EWdisfCSucR7B8hdbeFxDxAa6EbjK119KmMSfe+bsv20XGI
	yI82E+QTfZBg+xkOq8GZrEsVKUTlQ5o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tVrbszXt;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217590; a=rsa-sha256;
	cv=none;
	b=IBnWaZCe1PZXOCt+VA3dUFQZTXmL8J2anMe3jjPBDRUmaE+6o2egPTtR5mcjgyhp6hVvkg
	6pivq3eGOnKo1FGMfjyjXsyTQwXXyOthccuSF9BTMCItpnrkLf+r2HfwkIyHMIAlUd3eEW
	QK2Zv2q2vafqSWHjB0ZaAFoJyPZD1zU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B652C6013E;
	Wed, 11 Mar 2026 08:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729CEC2BCAF;
	Wed, 11 Mar 2026 08:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217589;
	bh=UP3yJUyJDW/TX5ELUeY/5xbOkxTwR1PYscwuXutUMbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tVrbszXtIWxzSx7nssq5H9vOP2XQE1atbb2q5iYKXTf3fiZYtqpRY1waLwrB2SA6b
	 aiK7aA5fz901sGCBYDtPL971qFSgDaRRlKhu8VICRAu2NzZxtr/tkfDKrCT1WGAAz3
	 XUVxXxVTGGMYvwp0zzm57C7niGg3mKcxQYaUo1LSpx6JlYb2XB2E+fHg01RwoP8r5q
	 xUHk6ALUhAp/8qlMoO2VGGMUsVCw1oXpLadKfpjOETBole/a+3swrGMYM08AfwTiL5
	 xLxEIwXPrD7cAidTO3Dh6/4hJJcoWvmim8V7y/MqW8IbQ/z8C5gr1OkzD6JSTzvJGJ
	 ZA2d4DzNqBlYw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 11 Mar 2026 09:25:57 +0100
Subject: [PATCH 3/3] slab: free remote objects to sheaves on memoryless
 nodes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-b4-slab-memoryless-barns-v1-3-70ab850be4ce@kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
To: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Stat-Signature: ak1ep9azm7f47mtfw41m77hkpa45toj6
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DD9414000F
X-HE-Tag: 1773217590-372489
X-HE-Meta: U2FsdGVkX18Cp5viQOjZzjj1Ok3yT0SqrmyunW67V6hfnuvBN6L42UgJQWRNmxGc6s2f24OYOxdYNxteocjoNh+NkzqM24mNmCPjGPsBxUbFSw9yxEs3Ipt4quCu2mucbsm9TdhkHbKaiM4+ZlobggcUYcOnJHiGbDUkrc+DPJ1q1M46iW+dS9KLWwq9Pgo6Hiqf3bmfMFL/u/L/bPaJ2k7AtrQgQFTa5rHJhoGw7miHEvdhc86Ocy5p+bXR942FDLWcSAzuVjP9+ldGW2D3tG7PWEvVv4/I70yfyInRbOZQbZQVRgcvsgw1IpUx0U+26mqtlMXx4OHKCwQwQsgONM44snOsjqRCVkIAc1a9PWNLpz/c36H2BDd6TP06Wx4peSx3cX+YC31iDzMmobLQ5u/Psk5dg7aOt+rsJEJHAEXkHcbTj7M0YiJU+L+g0u8ChymhOkef3dATUalIKbPWc1sqW5gZY2PunYzxiMDm17+lwylKl6H639P37A2Gsxbj+QSXgL0aZChA5ri03D5DvR5CPpW88iImeAcE7nGg3kWnlP5Y+fWQrWUX1fYUqlfXqS/bUtLkyFIt899QKsURnL3bEeUuDRRnYEaKRLRqQ00wLkoU7Ka6pkqQRQ/E5h2kN7w/lPdbKyzSei0nmkWt9B6TlZ7hDdOBEtFmWqj96cCnBDi7yKw5XxjvwY1L8QHmASMza9JjxYZ/RnTYmloZcbzdCh7GjyTI6lHCN4AgpcifsZjZWVALJaYUVCXCtW03/Gw3BhEkhUGcCkx39J6fTzPdlAdznR2C7QbJkrSm5kG07nJPo1vXxmo0X0oQ97JrY//BY1C/2kd6H1FrUY41VFV5XEFg91G+nW6lPoG+3dmx+vndODsdo2H22g+INlFpWjcX7hxPem0xw9+6aFmlL54pIl505R6x1VoCJT3IRERDZSXaA50cqQ1Cvi+7gHAaHz/LgriVGy+MdN0VzwI
 akdGE9ZU
 Rb5EnLzP1o4IWRlsBTJUCbKiwImbMlxxPpjEifwBe22rfB35xdj2U8YAKdacA9mdGrSWYBx2TxkjxKEGy1kvp43aFTW0sf2CbitE0oUpM3+93bwVqUMTJqI+cKNWffy+7HTPD5G4nsa0Hpqvqx504FXlvx4vuOHSs70G4NJK2X74sCHcnAyDZL/t8HYk8LSgqoYUjT8JZgzTBbL5efI4u1d+ZtRAT28cUPuYSZm7SCyxoHPT8CVBFhAQIkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On memoryless nodes we can now allocate from cpu sheaves and refill them
normally. But when a node is memoryless on a system without actual
CONFIG_HAVE_MEMORYLESS_NODES support, freeing always uses the slowpath
because all objects appear as remote. We could instead benefit from the
freeing fastpath, because the allocations can't obtain local objects
anyway if the node is memoryless.

Thus adapt the locality check when freeing, and move them to an inline
function can_free_to_pcs() for a single shared implementation.

On configurations with CONFIG_HAVE_MEMORYLESS_NODES=y continue using
numa_mem_id() so the percpu sheaves and barn on a memoryless node will
contain mostly objects from the closest memory node (returned by
numa_mem_id()). No change is thus intended for such configuration.

On systems with CONFIG_HAVE_MEMORYLESS_NODES=n use numa_node_id() (the
cpu's node) since numa_mem_id() just aliases it anyway. But if we are
freeing on a memoryless node, allow the freeing to use percpu sheaves
for objects from any node, since they are all remote anyway.

This way we avoid the slowpath and get more performant freeing. The
potential downside is that allocations will obtain objects with a larger
average distance. If we kept bypassing the sheaves on freeing, a refill
of sheaves from slabs would tend to get closer objects thanks to the
ordering of the zonelist. Architectures that allow de-facto memoryless
nodes without proper CONFIG_HAVE_MEMORYLESS_NODES support should perhaps
consider adding such support.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d8496b37e364..2e095ce76dd0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6009,6 +6009,56 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	return false;
 }
 
+static __always_inline bool can_free_to_pcs(struct slab *slab)
+{
+	int slab_node;
+	int numa_node;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		goto check_pfmemalloc;
+
+	slab_node = slab_nid(slab);
+
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+	/*
+	 * numa_mem_id() points to the closest node with memory so only allow
+	 * objects from that node to the percpu sheaves
+	 */
+	numa_node = numa_mem_id();
+
+	if (likely(slab_node == numa_node))
+		goto check_pfmemalloc;
+#else
+
+	/*
+	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
+	 * cpu belongs to, but it might be a memoryless node anyway. We don't
+	 * know what the closest node is.
+	 */
+	numa_node = numa_node_id();
+
+	/* freed object is from this cpu's node, proceed */
+	if (likely(slab_node == numa_node))
+		goto check_pfmemalloc;
+
+	/*
+	 * Freed object isn't from this cpu's node, but that node is memoryless.
+	 * Proceed as it's better to cache remote objects than falling back to
+	 * the slowpath for everything. The allocation side can never obtain
+	 * a local object anyway, if none exist. We don't have numa_mem_id() to
+	 * point to the closest node as we would on a proper memoryless node
+	 * setup.
+	 */
+	if (unlikely(!node_isset(numa_node, slab_nodes)))
+		goto check_pfmemalloc;
+#endif
+
+	return false;
+
+check_pfmemalloc:
+	return likely(!slab_test_pfmemalloc(slab));
+}
+
 /*
  * Bulk free objects to the percpu sheaves.
  * Unlike free_to_pcs() this includes the calls to all necessary hooks
@@ -6023,7 +6073,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	struct node_barn *barn;
 	void *remote_objects[PCS_BATCH_MAX];
 	unsigned int remote_nr = 0;
-	int node = numa_mem_id();
 
 next_remote_batch:
 	while (i < size) {
@@ -6037,8 +6086,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 			continue;
 		}
 
-		if (unlikely((IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != node)
-			     || slab_test_pfmemalloc(slab))) {
+		if (unlikely(!can_free_to_pcs(slab))) {
 			remote_objects[remote_nr] = p[i];
 			p[i] = p[--size];
 			if (++remote_nr >= PCS_BATCH_MAX)
@@ -6214,11 +6262,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		return;
 
-	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
-	    && likely(!slab_test_pfmemalloc(slab))) {
-		if (likely(free_to_pcs(s, object, true)))
-			return;
-	}
+	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
+		return;
 
 	__slab_free(s, slab, object, object, 1, addr);
 	stat(s, FREE_SLOWPATH);
@@ -6589,10 +6634,8 @@ void kfree_nolock(const void *object)
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
 
-	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())) {
-		if (likely(free_to_pcs(s, x, false)))
-			return;
-	}
+	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
+		return;
 
 	/*
 	 * __slab_free() can locklessly cmpxchg16 into a slab, but then it might

-- 
2.53.0


