Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D658D39013
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFF66B008A; Wed, 14 Jan 2026 15:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE2A6B008C; Wed, 14 Jan 2026 15:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7916B0092; Wed, 14 Jan 2026 15:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABA9A6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:53:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6142413B310
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:53:12 +0000 (UTC)
X-FDA: 84331769424.16.6088A13
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92503C000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:53:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BWc3ldmV;
	spf=pass (imf22.hostedemail.com: domain of 3NQJoaQgKCCwJQVORQIWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3NQJoaQgKCCwJQVORQIWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768423990; a=rsa-sha256;
	cv=none;
	b=cRgCX7DJd55gTLZ2lBVqD7MQGtEYLMjz2jul0RrSGdrXRD+29YSSutpZGTF6RzMb1finJ5
	VhvJMKAw3CU6nKxCY9qV5zmTJcj7yuHKfXiKc7CTGiw9clKeXig44dGYrA3L54cnDTaN9s
	+IHNl3rTDVmI9yUCdUEFjA/lMWwdeXI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BWc3ldmV;
	spf=pass (imf22.hostedemail.com: domain of 3NQJoaQgKCCwJQVORQIWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--bingjiao.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3NQJoaQgKCCwJQVORQIWOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768423990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCsRJ41+Ggq8G+xRjLn+/BFhG0UFmGF8M8WZhyAL+Ls=;
	b=BZN9FRJ8YkoYBfDRWBEBu3s3dzY35xZwMBTLTMPpJqZR309StzJUJJaRogtrMZa5LtRu2O
	885IWhQM85EfX+rKWsRKWCGL+8f1oySJD8dxnTch0puKFu9I+x2XuA4yWTgiyx/gRVWXV7
	k5xo0SUsygQssb4R7SK/aT3B43i8yXE=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12338749ea9so319248c88.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768423989; x=1769028789; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCsRJ41+Ggq8G+xRjLn+/BFhG0UFmGF8M8WZhyAL+Ls=;
        b=BWc3ldmVHXkMIg194z2FaAEpouq7WPCpjeKu8+4cNq2lRiM7JUkWHE364zVt+27J5E
         8PTRKTLMD+Rxji+Du1e/rI+HCh7pz4dLyMFW+Gl6M26VOa1HbHH8HWm7JTyxOjqE3zap
         6Np0kJ1Oae6pPdebzr9nRFaI7B34BPUdonV/S4nhboSAE/Vt9mXOqZxfwc2nSlX3o5NM
         Iyn4gMvwpq+I/EcOrUuqhl9+tlY2/iXk/hiwDWNJawqKurkL5pTXPjo2NIss8mCAqay6
         sDxb/eDDbPzt7zdwSVMqAss1gfBZzs7vBD1QhPGP3aHej/+XrzRiBcTyeamDeb1QnSLR
         YJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768423989; x=1769028789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCsRJ41+Ggq8G+xRjLn+/BFhG0UFmGF8M8WZhyAL+Ls=;
        b=AZLl+a64duuo8rvZYVfOKAAofWANvWJMXfe+TAPbS9Gu1NeVOcELRtiqSRcPVPCZg6
         8bRFmRh6bHqpGkgopph9rEXYksRu1HSZryol2NlEjty5+muURbk0ACNy/8kgjfC0hPe9
         yQmBWDlFsqFpI28DzxUZ12Sp2I0WdcdHJzXtCYjuK4wE1WU6Dn6c16927CukdPrNcMkd
         y8onCY1zzqvLJm+I1qbI1OF27fG9zRUD3Hf2G/ulDC9l+vYuedXSGoPdW1txhm4Ds5wq
         p5jzsMitWoMz1VVz03u9ZtyFfffdSThwBk/8Yw6MG0T9sFx6q3dbOJVpamk8Lrl9xuOf
         6qzA==
X-Forwarded-Encrypted: i=1; AJvYcCWvInCtuIxMSYpqW6MzvFvW9RX625Y4MlREBZBSPM8AGYX0Z3SpAopq4+uvs3m8CBY9BrXOvYZgdA==@kvack.org
X-Gm-Message-State: AOJu0Yx4W66EbHLNUj/TdlTrlgV96f/KuyhQhurXwdNaCYloiTKzz+YZ
	UrlwVqtpxEYFjzoSy5GHVNrgfmDcbh9LMCe+o6SVGz/8wSrre2Rh5h1PveAaIbTRQ6ihx86SnNo
	t9ZU95hJCE6DqkA==
X-Received: from dybic39.prod.google.com ([2002:a05:7300:c727:b0:2a4:612e:b41f])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701a:ca03:b0:11b:923d:7753 with SMTP id a92af1059eb24-12336a12704mr4017500c88.3.1768423989308;
 Wed, 14 Jan 2026 12:53:09 -0800 (PST)
Date: Wed, 14 Jan 2026 20:53:03 +0000
In-Reply-To: <20260114205305.2869796-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260114070053.2446770-1-bingjiao@google.com> <20260114205305.2869796-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114205305.2869796-3-bingjiao@google.com>
Subject: [PATCH v9 2/2] mm/vmscan: select the closest perferred node in demote_folio_list()
From: Bing Jiao <bingjiao@google.com>
To: bingjiao@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	tj@kernel.org, longman@redhat.com, chenridong@huaweicloud.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 92503C000B
X-Stat-Signature: mcxjmkj8de1rdd1qasshfnm1n515ninw
X-Rspam-User: 
X-HE-Tag: 1768423990-398865
X-HE-Meta: U2FsdGVkX1+CKl/KjnDTDUHGqW9PJ6hlb7PgwUYMFhbdKBXipji37nOQRFVFkxNBLmOCBYdHqOfq4lmfetqOav3Zi0P8MFFhOKmVmxFO8dioXXhzl9M2ccCy+xOb3c10WjCsfA3tda0At7e88DSF4YaCaYRREPApXUDIwa7xYEubNOJvTF0LS1+XbhhvAU5kjTyv8XT0JGKnIXKS5Bi+0G64dEX0HaDO06VfRA0tPUBpDI7cKkV4vbWYACupFkxNTauabC194QWOqQv/mvdFhLFjy+NW/QFSqmtOgQ+F3CxkOzHpoQ0n63gDeFahtuQ4Wszp0gWvNFTyiGD1qZfUpQDOdVHLVZBiySQqkc3fPX3+pPTFdQPbx0zbijrBt8XINY9Ovuzu15rp8oEPQD7XI/mg/AowvWB3J3vcgzKfI44mNfKsA9QcwB+wPP7E/wpjKhhTtov44p353Jmri7CXoOxXctyZ9Xt9UfXlp9qlYnthlUKnmzoPJBZZ0D1iNJY1U1Q8BfM/O2oEjxjPpBbXtN/mwsGRiPopmz+7PlbYBBbvYglyQUwZpQi9bYG9NI5T+nzuK6uTkHn6ipawsCBxCCDQdsLflBh2nh91gq62O4AIn5Tt4S5+Qaxr0DQeOycej75bE2OzQCQDDBzYJAJH00RDoKAxw3KKq5dAwWWjKQys86UXewxqah5rFMwkaIX3jeAcwDXX7ubLivRWzdNO0sycrSNBCX+uBUN37hHRNASOPebGwz2LDCVhSIo0XPyVS0T2Of1vQhm/ooFugEli14Dz4ZwAKa+/nWm64eg9J8SNGOFFQdnxKiTC0Gu6DjjXSqZghGebbhm8Whj4ICFETeYir8LzzydeEw2lg7JqJXHrS9U5x1DqFKl9TDHjlJjvrP0c9+DBFnF4I5Oe+Jrykznb5glamo1SXZWT6U0C91EG804afkgYQYAH1PV7z+9sRHwLs/hwk+K2wwb3EhU
 goBg4GtD
 +6smyYzetdHt7tPm2OwdEXgt+QN3mYkSEZf7F29PUssW2kwNZxZOp7EMF1nBpizndcEu62+juViRXWvrAxPdeJMHgzDMF8LlIgOlGIG2+/VGamnpgCbMmnwikvQTFoHfLJ5zE4CDResOw5v6BZulQY2m2AUCMD1DSEDGxYux04Vko0KgMaRUtduM5bvoWcDC1OdTkY1mBaH2ZcvXTfAkBIaM1ms+mKncwduh4rbBAblwx7DcI4/QftvHl6eFWy8k1yhThjkKNFjffImoOhY5uV6Q0Byj2bR5kMng9jZC1N2FP6j37CuEKO67dYyevXu8Ar9l0R3F61n2g9DU0EQfptR3mVA2OZxovJMWYQ9F2oJq+/8ZRgNkXlY1NFyepNnTVFUcOcyub8cCdx5lsekKlIZAEqD1pBVL6K1DVC41fOyAnr5nFGkXMvpvUFWXdJ5K2WIO0ibFjKTNkQSkVsqXMa1I52mtfAAwUHL6NsU1pBriNqXQNGVlTNd0qskptryJ1dYq3kvbxDCTSQSt+15Kp6pzht2bmHcAnf/i2QJhvTL12IXERpp1mJXd7OKsuVOdq9hVPr5uJ/bnbUSV4YX31AU1n9f+02+oma5G9cz+Ey8dL0wa+F2/G4S2699hyiPlETwupPey6lRS78GfOoeVEfvsMkM5smGLQMjM6TfnazUA11ApcAq2qYQezcJLr1ZhAJ23ESXHTNhk99JA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The preferred demotion node (migration_target_control.nid) should be the
one closest to the source node to minimize migration latency.  Currently,
a discrepancy exists where demote_folio_list() randomly selects an allowed
node if the preferred node from next_demotion_node() is not set in
mems_effective.

To address it, update next_demotion_node() to select a preferred target
against allowed nodes; and to return the closest demotion target if all
preferred nodes are not in mems_effective via next_demotion_node().

It ensures that the preferred demotion target is consistently the closest
available node to the source node.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
v7 -> v8:
Fix bugs in v7.
Remove the while loop of getting the preferred node via
next_demotion_node().
Use find_next_best_node() to find the closest demotion target.

v8 -> v9:
Move allowed node checks and identification of the closest demotion
target into next_demotion_node() for better function splitting.

 include/linux/memory-tiers.h |  6 +++---
 mm/memory-tiers.c            | 21 ++++++++++++++++-----
 mm/vmscan.c                  |  5 ++---
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..96987d9d95a8 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -53,11 +53,11 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
-int next_demotion_node(int node);
+int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
 #else
-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	return NUMA_NO_NODE;
 }
@@ -101,7 +101,7 @@ static inline void clear_node_memory_type(int node, struct memory_dev_type *memt

 }

-static inline int next_demotion_node(int node)
+static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	return NUMA_NO_NODE;
 }
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..2d6c3754e6a8 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -320,16 +320,17 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
+ * @allowed_mask: The pointer to allowed node mask
  *
  * Return: node id for next memory node in the demotion path hierarchy
  * from @node; NUMA_NO_NODE if @node is terminal.  This does not keep
  * @node online or guarantee that it *continues* to be the next demotion
  * target.
  */
-int next_demotion_node(int node)
+int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
 	struct demotion_nodes *nd;
-	int target;
+	nodemask_t mask;

 	if (!node_demotion)
 		return NUMA_NO_NODE;
@@ -344,6 +345,10 @@ int next_demotion_node(int node)
 	 * node_demotion[] reads need to be consistent.
 	 */
 	rcu_read_lock();
+	/* Filter out nodes that are not in allowed_mask. */
+	nodes_and(mask, nd->preferred, *allowed_mask);
+	rcu_read_unlock();
+
 	/*
 	 * If there are multiple target nodes, just select one
 	 * target node randomly.
@@ -356,10 +361,16 @@ int next_demotion_node(int node)
 	 * caching issue, which seems more complicated. So selecting
 	 * target node randomly seems better until now.
 	 */
-	target = node_random(&nd->preferred);
-	rcu_read_unlock();
+	if (!nodes_empty(mask))
+		return node_random(&mask);

-	return target;
+	/*
+	 * Preferred nodes are not in allowed_mask. Filp bits in
+	 * allowed_mask as used node mask. Then, use it to get the
+	 * closest demotion target.
+	 */
+	nodes_complement(mask, *allowed_mask);
+	return find_next_best_node(node, &mask);
 }

 static void disable_all_demotion_targets(void)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ea1dd2b8cce..7a631de46064 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1048,12 +1048,11 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (nodes_empty(allowed_mask))
 		return 0;

-	target_nid = next_demotion_node(pgdat->node_id);
+	target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
 	if (target_nid == NUMA_NO_NODE)
 		/* No lower-tier nodes or nodes were hot-unplugged. */
 		return 0;
-	if (!node_isset(target_nid, allowed_mask))
-		target_nid = node_random(&allowed_mask);
+
 	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
--
2.52.0.457.g6b5491de43-goog


