Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E05BCCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590826B0273; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A876B0275; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430776B0276; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6726B0273
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9274E140684
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:16:01 +0000 (UTC)
X-FDA: 85339574922.10.BFE39C4
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05277C0008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:15:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LXMceNcC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoreJwIbc9FMkcxPipG4faUYvfDzahKIM5OORCnCFbM=;
	b=eVb5V2UYi/c8wkLqkU4vVoEUvmXMacEHnBDuNT6GWzYn/hEj9sqzTiI2jV1qhnaFhN2NAT
	tYAUK8VyJaPZoGWG7DnmybGjf9o5PyRwgnRtyV0meW4w2A+r8OCX15QssgMPT/17Hh38YD
	Ql5n3B78uB+A8JZxS68fT60Uan1YjHc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LXMceNcC;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419359;
	b=DD4phT9mrFOSd4tni//StBFSuzrdK70p3UbAWnB+F/U7Rbb7XIq0yQGPtLw8asYesHs6BI
	rtCFrDlKs/vXYi8Q5Ol5UeHg3Yjzg10SuPFt7/qc290vBTQpZY7koEZmEn0YLqiyNOoOUP
	HYFKSV0qnqg87/IiSZIO20o2a08TsUo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792419352; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=xoreJwIbc9FMkcxPipG4faUYvfDzahKIM5OORCnCFbM=;
 b=LXMceNcCGzigzX0mF22ioTXqfXUYPoQjn3BxLQWgem6phcnaTx9GfHWjJZvEFm++8Fm5Jl
 MriCqpDq8qfaQb6BKsg2+Z17juZm3284EkiJnYjPbzZhRe3hBpWHI/GUPiShsoqK46/BK3
 KpQ3ucBYa0i2cFTyyh177/lnszmPVHVA55pLGUvTQ6FJwnahazFhTv3gJtFQEvaFJbMirO
 jE/ab2HqJOzqa03de9Fz0ujyb0mTXCRfp4Edrc7VXpbXRjHvuYkvGUZSEHySfevdb7RwF2
 bVcO9egQhXusqup2ChkMyP3nZMnpS/OLCWuJvLpdVVAqB1dnXhYc4WyVXcd++g==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC 2/2] mm: add tier source selector to memory.reclaim
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad62616+aaebf9+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 19 Oct 2026 22:14:01 +0800
Message-Id: <20261019141401.11927-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05277C0008
X-Stat-Signature: 9kdbz3k5qf57cfgheq6rmmzzkq7i1gty
X-Rspam-User: 
X-HE-Tag: 1792419356-188840
X-HE-Meta: U2FsdGVkX1/jkmxMjj0nPBBweBAqTJH4Jf4AEnUU6wIrviBWiLXeTHVEnbUCwOVVw2CfaOthc2/KhO/n7MFZ7ILnmvWcURdLHAqhYkcbyYNeeIpsx3O9ruUMt8E5CO1HjMC4YMANE+rePJJRdwGuDyT2XN8s+fBGBX/RbzGVQrpjUS4PNp55YezmGdrvlgJAhWeHa8LtjwXPTk2C4Wsv2PVqmfojBJDg3ny9puLjtEBA5wDRzqZR/+e6EvoHXEpqpzrB0Q+d3YAhyEKyrni8FOGNnv9lEpR8yhNCSaT68ni+kZBhM17tpVkGh2FHYZ05uj0DI8wOA0P5yClfYzn/Jw3oHAI3DxtlWHF1H4CnHGMOuT6gYy4ycdaXmM9tK3qeicsQoktuYtQnYf8wQsjZirBzkNzZnDjS822hoNaDfp7qecvG5RTrNP+qWYlyy4kucaLFmZiOH5UNu6L2XAFRpNQujHzWh2yGnbgx8rysWv+XjiWYqHKPQD6sccPYznag4GwScZ2jp4aoaqF7wz9hmeXxMkVXGTkz5X4m1Ly2c4kHCmhs5RqptP5GArGwr0mPSfT8Y7b0GdEKFbFQ+Np43Ypi08zUdqmo/K+pjLgc53hRWtXKhKMB0Z0IPWaD/WRDkWDFkdSRwzEjoOiZULfr0hpms6FJW1/9FWrXjrYnIeuQJLE7Fa7HwquOhgndCWACG3n7S1TF5fC0ItmOY4OD9lf4dReb653r3pbd2JMBxVboUP0YqbZMWviHT637s1nLnM3rTnqRyOpcY2B8QvTEaKaY29pu6Tq1XXbJ/nAIf51ONsnzbq13jdxnjtBrs8M2iHSNDxQkftqTFZEJUmIVBUGeGCFNsX1nRg+TbzMpVTHdH2bfK+dKzKfIo5B47K8kE8R0BdT3FDzVU1A5m6uFlL2kIhIcIKdt485sVFmuWEpTNTDxUXsAdl/0PdDSRCmuIyHwB57UyfGSx9aH13W
 /snWh5+G
 S1drN1A+QGfOnhaiL8hfNBl/Eo/CQRpwUO+HkwlSTjeoXgsUD9fxk3bmxwp/4B2esuPUQ2baH6h7oED4/89yDzkxioDmbVM0tdmp0XmYlr5CD5HvYK2YUCeqm35yXTpC9qVDlF7cgYGbU7aVe2LE59Zen2WdNtMMq/Hl2L3NvP+weXCGh36M3clAfXdkCVK3BAdr2JXcfyfmOruyAjIUMlLjkmgrjPhtYHADaxtLPXQpKhvwmSzdKRjFTld4BahYqjAcO8/ukUEMO7RSD//YtS1i8+4Zh5PyIiQ6VbANOYjHmcQMKV/Ttw22QyG/UsEb492LPVt7cS6cDMbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

source=nodes:<nodelist> lets userspace apply the existing
memory.reclaim aging pipeline to a specific set of NUMA nodes. Many
tiering controllers reason in terms of memory tiers rather than raw
node lists, and the memory tier core already exposes those tiers as
/sys/devices/virtual/memory_tiering/memory_tierN/nodelist.

Add source=tier:<N> as another typed source selector. The selector
uses the same N as memory_tierN and resolves it to the tier's current
memory-node mask at write time. The resulting mask is then passed to
the same source-scoped reclaim path used by source=nodes:<nodelist>.

This is only a selector convenience. It does not choose demotion
targets, does not introduce a demotion-only or eviction-only goal, and
does not change memory.reclaim completion accounting or reclaim policy.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 22 ++++++++-----
 include/linux/memory-tiers.h            |  6 ++++
 mm/memory-tiers.c                       | 24 ++++++++++++++
 mm/vmscan.c                             | 42 +++++++++++++++++--------
 4 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index a016575010ba..d6e9b275fcfd 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1467,18 +1467,24 @@ The following nested keys are defined.
 
 	The source key declares where the normal reclaim aging pipeline is
 	applied. It is a typed selector in the form source=<type>:<selector>.
-	Currently only source=nodes:<nodelist> is supported. For example::
+
+	Currently source=nodes:<nodelist> and source=tier:<N> are supported.
+	For example::
 
 	  echo "1G source=nodes:0-1" > memory.reclaim
+	  echo "1G source=tier:4" > memory.reclaim
 
 	This instructs the kernel to apply reclaim pressure to memory of target
-	cgroup that are currently resident on nodes 0 and 1. Reclaim then
-	follows the normal reclaim path for selected folios. The source
-	selector does not choose a demotion or eviction policy. On tiered
-	memory systems, a source node in a non-terminal tier will usually make
-	progress through demotion when an allowed demotion target exists. A
-	source node in the terminal tier has no demotion target, so successful
-	reclaim progress from that source is eviction.
+	cgroup that are currently resident on the selected source. The nodes
+	form selects nodes directly. The tier form selects the nodes currently
+	in /sys/devices/virtual/memory_tiering/memory_tierN/nodelist, where N
+	is the memory tier id. Reclaim then follows the normal reclaim path
+	for selected folios. The source selector does not choose a demotion or
+	eviction policy. On tiered memory systems, a source node in a
+	non-terminal tier will usually make progress through demotion when an
+	allowed demotion target exists. A source node in the terminal tier has
+	no demotion target, so successful reclaim progress from that source is
+	eviction.
 
 	The source selector is a source constraint only. It does not select or
 	limit demotion targets; those are still chosen by the kernel's memory
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629ee..71fa51ba317d 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -49,6 +49,7 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+int mt_get_memory_tier_nodemask(int tier, nodemask_t *nodes);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
@@ -142,6 +143,11 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 	return -EIO;
 }
 
+static inline int mt_get_memory_tier_nodemask(int tier, nodemask_t *nodes)
+{
+	return -EINVAL;
+}
+
 static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 								struct list_head *memory_types)
 {
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..75ec73b224a3 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -180,6 +180,30 @@ static ssize_t nodelist_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(nodelist);
 
+int mt_get_memory_tier_nodemask(int tier, nodemask_t *nodes)
+{
+	struct memory_tier *memtier;
+	int ret = -EINVAL;
+
+	if (tier < 0)
+		return -EINVAL;
+
+	mutex_lock(&memory_tier_lock);
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		if (memtier->dev.id != tier)
+			continue;
+
+		*nodes = get_memtier_nodemask(memtier);
+		nodes_and(*nodes, *nodes, node_states[N_MEMORY]);
+		if (!nodes_empty(*nodes))
+			ret = 0;
+		break;
+	}
+	mutex_unlock(&memory_tier_lock);
+
+	return ret;
+}
+
 static struct attribute *memtier_dev_attrs[] = {
 	&dev_attr_nodelist.attr,
 	NULL
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 155d0ef82b48..2abbce265af6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7961,29 +7961,45 @@ static const match_table_t tokens = {
 };
 
 #define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
+#define MEMORY_RECLAIM_SOURCE_TIER	"tier:"
 
 static int parse_memory_reclaim_source(const char *source,
 				       nodemask_t *source_nodes)
 {
 	const char *nodes;
+	const char *tier;
+	int tier_id;
 
-	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
-		    strlen(MEMORY_RECLAIM_SOURCE_NODES)))
-		return -EINVAL;
+	if (!strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
+		     strlen(MEMORY_RECLAIM_SOURCE_NODES))) {
+		nodes = source + strlen(MEMORY_RECLAIM_SOURCE_NODES);
+		if (!*nodes)
+			return -EINVAL;
 
-	nodes = source + strlen(MEMORY_RECLAIM_SOURCE_NODES);
-	if (!*nodes)
-		return -EINVAL;
+		nodes_clear(*source_nodes);
+		if (nodelist_parse(nodes, *source_nodes))
+			return -EINVAL;
 
-	nodes_clear(*source_nodes);
-	if (nodelist_parse(nodes, *source_nodes))
-		return -EINVAL;
+		nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
+		if (nodes_empty(*source_nodes))
+			return -EINVAL;
 
-	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
-	if (nodes_empty(*source_nodes))
-		return -EINVAL;
+		return 0;
+	}
 
-	return 0;
+	if (!strncmp(source, MEMORY_RECLAIM_SOURCE_TIER,
+		     strlen(MEMORY_RECLAIM_SOURCE_TIER))) {
+		tier = source + strlen(MEMORY_RECLAIM_SOURCE_TIER);
+		if (!*tier)
+			return -EINVAL;
+
+		if (kstrtoint(tier, 10, &tier_id))
+			return -EINVAL;
+
+		return mt_get_memory_tier_nodemask(tier_id, source_nodes);
+	}
+
+	return -EINVAL;
 }
 
 int user_proactive_reclaim(char *buf,
-- 
2.20.1

