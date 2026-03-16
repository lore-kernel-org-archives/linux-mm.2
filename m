Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4A2D58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5EE6B011A; Mon, 16 Mar 2026 01:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA36A6B011B; Mon, 16 Mar 2026 01:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBE56B011C; Mon, 16 Mar 2026 01:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93EC06B011A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:13:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2912013BDC9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:19 +0000 (UTC)
X-FDA: 84550757718.05.A6B278D
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id E55138000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773637997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oSNBt34+XykAk1nFRKSIxxi9f4Ju0C01d4ZLsjK64KM=;
	b=cRv41MnjW+zC+OEmA1EIXoXri1oR3IZjH9lB4w0EZ3/YLncMTIVccDBQfx1L2JX5oL3tae
	lzIXWzoZ4o8OIUz4Q2KVLd80PQ1snzHOhj+ZyTZKdgpBrBWwEf2Ob7lQeYmOoPOBRDF5xy
	4uoEdwz43qexdV8JIurDk12eQb+2AK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773637997; a=rsa-sha256;
	cv=none;
	b=C5mY7wvFZVkUkXJcWKPBAGtgaltvWuggw6BBBvr1yFKwGswR50zoq+0FVS5xAnkcFoclEL
	d2HUfNH+usQDqfeT0Vh5uF3X6hNJTMDjnvXtP/fouevcMjOphMmje24ilS7YMWN2NDMM/B
	2IXzPkpenKaRMqXEamJDTk9bGde47Zg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-43-69b791662e0a
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [RFC PATCH 2/4] mm/memory-tiers: introduce socket-aware topology management for NUMA nodes
Date: Mon, 16 Mar 2026 14:12:50 +0900
Message-ID: <20260316051258.246-3-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
References: <20260316051258.246-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHeXfOzjkOR6cp+uqwYBBhkVkqvEWk4JcXi5ASgi7UcMe23KZs
	Xoty5rqopGaZtZlNA1FnjVY6lTLalroMJ1mikqaoOAlLLcXUMKdEfvvz+1+eDw9DiPrIYEah
	TuM0aqlSQglIwbRv9Z6kOzZFuLlJjCosDRQaGuuhUGt/Aiov6wGocyCXQuaBBoAmG5cA+j3U
	QaM3E5Mkqq/qo1BHYyWNbLoRGrkN70nU21pBoeGGVT5yGepItFAkRl+LYpDTYuOhux9NFDLm
	FgE0WNLOQ+YGOTK+G6ZjIG4xDNHYZE3HhTd6aax3TvPxk1dTPGytz6ewda6Uxp0PlkncMnoA
	3877TuHZiUESlxlzsOXlZxJ/MDlp/NO6LX7LKcEhGadUZHCavYfPC+QLtY/o1NlukNXa3ELp
	wP06UAAYBrKRsMihKgA+69LZPsb3YoqVwPbXZ7zYnw2BZX/cZAEQMARbx4du1zLhNfzYRHj9
	U9e6JtkdMF+vW9dCNgIONS+RG5uh8NnzQdK76bO232SK8GLRWqRyfIbeiG+Frofj6xGC3Qkt
	lSIvJtjtMK/RSHjPQjaXgZ7VEnpjMgi+re0nSwBr2FQ3/K8bNtVNgKgHIoU6QyVVKCPD5Nlq
	RVZYYorKCta+XXNl5XQzmOs5YQcsAyS+Qrm9SSHiSzO02So7gAwh8RfWONeQUCbNvsRpUs5p
	0pWc1g7EDCkJFO5fyJSJ2AvSNC6Z41I5zT+Xx/gE64A+3SG7GLIbB+i7C5KL5+MKu0aIwaTH
	X8o91779OGp0h47l2KKmggNvBsUiHmASwrW//MxzkBMvjjg8pdEn46NfxILJp5X85Cbxol+M
	60i3Osl1ts1R5XHp2jIj/FWmW3nF89rCqINXGV0bjBttvmdYCZiZOe48drnamWOWkFq5dN8u
	QqOV/gWscSed6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+XbOzjkOB8cpeNLMWpkYNQsNPsHKfvkR/bAwwpJy6akN59RN
	xRXiRLuoaV7LNrWJIE5Hq5FXFGut6SrUtCQXM81bJpaWSGm3TYn89/K8D++fl8IEQ7gPJZWn
	sQq5WCYkeDivKjB238XSNun+3094sNpoIKBjcpCAnW+jYX+FloB3KgcB7BvNIWDzqAHA2ZZV
	AH84ekn4bWYegz3TszhsqhshYG9LLQmf1ti4sE09TsIBzXMcDndWE3DM8IcLbRo9DleKfeH7
	4ghoHpnlQouxjQPLh3QE1OYUA2gvsXJgs0EC11obnejZGBnhhzo0DhLpTOmo8NowifIsC1xU
	3zXHQaamfAKZvpaRqK9qDUcdE2GoKPczgZam7ThaeYdQ/cdFDqrUZiPjozc4eqmzkFEeZ3jh
	CaxMmsEqgg/H8SQrjTVkylI/yOxs7yDU4LYeFAA3iqFDGYt1klsAKIqghYy1O9aFvWg/pvLX
	AF4AeBRG67nMgG0NcxWedDxz9fWL9YzTAUx+nno98+kQxtG+im9sBjH3H9px16abc79VF+LC
	AqdSO7VIbugejO3u1LqC0YGMsVbgwhjtz+S2aLESwNdssjT/Lc0mSwewJuAllWckiaWygyJl
	okQll2aK4pOTTMD5dEPWz9J2sDwcaQY0BYTufIm5VSrgijOUqiQzYChM6MVvsDgRP0Gsuswq
	ks8r0mWs0gx8KVzozT92mo0T0JfEaWwiy6awin8th3LzUYOj74lCOOHptyof0t+wRWxVUtnj
	J7Jv2fAMlSOr83tosD1s525OpvcVUaN/+SlOeEiPrmiXR9mSTmb9YJ2uO1QQ1JMaej1mkI3Z
	W9bQUTESvp1/xH4vQXjyXPSDOZEm8uaF5VepC11ROVuOLwbMhcxv+7KjBMsrnXEPPuvz6bG2
	W4grJeIDezCFUvwX9hS1iOUCAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: me6nn1cgqwnioqamaqxy6ujd3dcbgkhh
X-Rspam-User: 
X-Rspamd-Queue-Id: E55138000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773637996-164680
X-HE-Meta: U2FsdGVkX18n1ON3YlcFbj7dbWlWYaHrGNHC23+RnocabqlDHsYrVcNyjp6orddPw5ILqkwOXT9cGRbxW8Grcqwt/WNuZz3e8ywk4ZDMQouM9t5azI13bXzomvBtZWS9nlETC+WZHyp/01NbKaxnaAXACm9Hr43JChBr9MWde8LevThBc6r8McogLQ67/RqPCvday1lZ26IcB4hs6Hd5ERNzPNe8OkAyw9SU/dVDgkvZIimoLDyJZI/PXe8K9Jbwv6e2lUH/Dro5TXPhuKi6G5By9vtXEgK0v7MKOF+viBof+7fngfBqRfnA0Vkp/At/0bUi4u3OujysZr3jMTa5EkNRIzm2P7qSk5yBxovQTzOMo2hPj5xAObYMU34TYFsXbafq2AEcf+ieUb29UnMpiGHp3ngk/LArHoy2DcehUiG58iNFC1p067Wk9iXsv4Nhv2biGXoW3DQYdureZZlYQbWFjYGlXaJAVmnTntRNdgiwAo2yf/wy+q70xOexqcThb2o3WF/wU+Ia9TN6ry1KhWxEJyxu4XfhMRqaMy7QzlM32rx54T+9RnV2JMlygj8mt/PoT70eYV0TGLkkOptkc93h2YSyUJBccRLuRv7cbhIXMHx0DQxeFbgF0W03N5yFQJYaahQKumpB/I3PYS3jbOuH8mDqIY3rNc1GmLY2MK/m0s/csy+RASSkIwDzc7EhJ9UM+d/fk1UUtxAidvL7TKAr4uMfJhXm92Svlbem8YYfz9T98WUzZd/ALcrKj0qxe27GBF7b+9MkrzB0E+36zqI84crtUjJOfDHr5W3sc/RXtj4h7mkL5kxIT+IpgIx+cCBtHySsp3LTQ55nbBv/nLkXEFzUXfS02omva9nM29vGG42khyg4TKQrBBEI71ui7SFvQLCHUnibAPaq7Co3iVKmiVYUQvENVDbY9qVDU1UU1dSfX43bbqkkBlgGNSgsq6w99uSQzUzzL+KM/vq
 YNnZr1oy
 xb/Bg9TqGB8CGIytHGOZN/MW+/jAxZeCWsV563cTNb3aN5CcYhjGTOSoHFWtId5keX5pTJjO15kY/VCsKPJw1s0BlKTpGlI1tecsl+oEFaZU4uBh6pf8RWMYTducIkKaRTT/RCMV+jbzyoldVzmklmH4EmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing NUMA distance model provides only relative latency values
between nodes and lacks any notion of structural grouping such as socket
or package boundaries. As a result, memory policies based solely on
distance cannot differentiate between nodes that are physically local
to the same socket and those that belong to different sockets. This
often leads to inefficient cross-socket demotion and suboptimal memory
placement.

This patch introduces a socket-aware topology management layer that
groups NUMA nodes according to their physical package (socket)
association. Each group forms a "memory package" that explicitly links
CPU and memory-only nodes (such as CXL or HBM) under the same socket.
This structure allows the kernel to interpret NUMA topology in a way
that reflects real hardware locality rather than relying solely on
flat distance values.

By maintaining socket-level grouping, the kernel can:
 - Enforce demotion and promotion policies that stay within the same
   socket.
 - Avoid unintended cross-socket migrations that degrade performance.
 - Provide a structural abstraction for future policy and tiering logic.

Unlike ACPI-provided distance tables, which offer static and symmetric
relationships, this socket-aware model captures the true hardware
hierarchy and provides a flexible foundation for systems where the
distance matrix alone cannot accurately express socket boundaries or
asymmetric topologies.

This establishes a topology-aware basis for more predictable and
performance-consistent NUMA memory management.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 include/linux/memory-tiers.h |  93 +++++
 mm/memory-tiers.c            | 766 +++++++++++++++++++++++++++++++++++
 2 files changed, 859 insertions(+)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..406b50ac7d88 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -52,10 +52,24 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+
+int register_mp_package_notifier(struct notifier_block *notifier);
+void unregister_mp_package_notifier(struct notifier_block *notifier);
+int mp_probe_package_id(int nid);
+int mp_add_package_node_by_initiator(int nid, int initiator_nid);
+int mp_add_package_node(int nid);
+int mp_get_package_nodes(int nid, nodemask_t *out);
+int mp_get_package_cpu_nodes(int nid, nodemask_t *out);
+int mp_get_package_memory_only_nodes(int nid, nodemask_t *out);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
+
+int mp_next_demotion_nodemask(int nid, nodemask_t *out);
+int mp_next_demotion_node(int nid);
+int mp_next_promotion_nodemask(int nid, nodemask_t *out);
+int mp_next_promotion_node(int nid);
 #else
 static inline int next_demotion_node(int node)
 {
@@ -71,6 +85,26 @@ static inline bool node_is_toptier(int node)
 {
 	return true;
 }
+
+static inline int mp_next_demotion_nodemask(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_next_demotion_node(int nid)
+{
+	return 0;
+}
+
+static inline int mp_next_promotion_nodemask(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_next_promotion_node(int nid)
+{
+	return 0;
+}
 #endif
 
 #else
@@ -151,5 +185,64 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline int register_mp_package_notifier(struct notifier_block *notifier)
+{
+	return 0;
+}
+
+static inline void unregister_mp_package_notifier(struct notifier_block *notifier)
+{
+}
+
+static inline int mp_probe_package_id(int nid)
+{
+	return NOTIFY_DONE;
+}
+
+static inline int mp_add_package_node_by_initiator(int nid, int initiator_nid)
+{
+	return 0;
+}
+
+static inline int mp_add_package_node(int nid)
+{
+	return 0;
+}
+
+static inline int mp_get_package_nodes(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_get_package_cpu_nodes(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_get_package_memory_only_nodes(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_next_demotion_nodemask(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_next_demotion_node(int nid)
+{
+	return 0;
+}
+
+static inline int mp_next_promotion_nodemask(int nid, nodemask_t *out)
+{
+	return 0;
+}
+
+static inline int mp_next_promotion_node(int nid)
+{
+	return 0;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 864811fff409..47d323e5466e 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -998,3 +998,769 @@ static int __init numa_init_sysfs(void)
 subsys_initcall(numa_init_sysfs);
 #endif /* CONFIG_SYSFS */
 #endif
+
+/**
+ * enum mp_nodes_type - Selector for which subset of a package to return
+ * @MP_NODES_ALL:       All NUMA nodes that belong to the package.
+ * @MP_NODES_CPU:       Only CPU nodes in the package.
+ * @MP_NODES_MEM_ONLY:  Only memory-only nodes (e.g. CXL/HBM) in the package.
+ *
+ * Used internally to choose which nodemask to expose for a given package.
+ */
+enum mp_nodes_type {
+	MP_NODES_ALL,
+	MP_NODES_CPU,
+	MP_NODES_MEM_ONLY
+};
+
+/**
+ * struct memory_package - Per-socket (physical package) container
+ * @package_id:          Physical socket/package id (from topology).
+ * @nodes:               Nodemask of all member nodes in this package.
+ * @cpu_nodes:           Nodemask of CPU nodes in this package.
+ * @memory_only_nodes:   Nodemask of memory-only nodes in this package.
+ * @cpu_list:            List head of CPU-type members.
+ * @memory_only_list:    List head of memory-only members.
+ * @list:                Linkage on the global @memory_packages list.
+ *
+ * A memory_package groups NUMA nodes that share the same physical CPU package.
+ * The masks are used to implement socket-local placement/demotion/promotion.
+ */
+struct memory_package {
+	int package_id;
+	nodemask_t nodes;
+	nodemask_t cpu_nodes;
+	nodemask_t memory_only_nodes;
+	struct list_head cpu_list;
+	struct list_head memory_only_list;
+	struct list_head list;
+};
+
+/**
+ * enum mpn_source_flags - Source used to resolve a node's package membership
+ * @MPN_SRC_UNKNOWN:     Unknown/unspecified.
+ * @MPN_SRC_CPU:         Directly resolved from a CPU node (1:1).
+ * @MPN_SRC_INITIATOR:   Resolved via an initiator CPU node provided by a driver.
+ * @MPN_SRC_SLIT:        Resolved via SLIT/nearest-node.
+ *
+ * These flags are informational; they describe how a given node was bound to
+ * its package and help with policy decisions later.
+ */
+enum mpn_source_flags {
+	MPN_SRC_UNKNOWN		= 0,
+	MPN_SRC_CPU		= BIT(1),
+	MPN_SRC_INITIATOR	= BIT(2),
+	MPN_SRC_SLIT		= BIT(3)
+};
+
+/**
+ * struct memory_package_node - Per-node membership and preferences
+ * @nid:              NUMA node id for this entry.
+ * @initiator_nid:    CPU nid that served as the initiator when resolving @nid.
+ * @package_id:       Resolved package id that @nid belongs to.
+ * @source_flags:     One of &enum mpn_source_flags describing the resolution.
+ * @preferred:        Opposite-type nearest candidates inside the same package.
+ * @package:          Pointer to the owning &struct memory_package (NULL until bound).
+ * @package_entry:    Linkage on the owning package's type list.
+ *
+ * Each NUMA node that participates in socket-aware policy gets a wrapper entry
+ * that caches package membership and the precomputed set of preferred targets.
+ */
+struct memory_package_node {
+	int nid;
+	int initiator_nid;
+	int package_id;
+	int source_flags;
+	nodemask_t preferred;
+	struct memory_package *package;
+	struct list_head package_entry;
+};
+
+#define node_is_memory_only(_nid) \
+	(node_state((_nid), N_MEMORY) && !node_state((_nid), N_CPU))
+
+static BLOCKING_NOTIFIER_HEAD(mp_package_algorithms);
+
+static LIST_HEAD(memory_packages);
+static struct memory_package_node *mpns[MAX_NUMNODES];
+static DEFINE_MUTEX(memory_package_lock);
+
+/**
+ * register_mp_package_notifier - Register a package resolution algorithm
+ * @notifier: Notifier called with the nid to resolve (see mp_probe_package_id()).
+ *
+ * Drivers (e.g., CXL region/decoder code) register here to supply a package
+ * hint for newly appearing nodes. The notifier is invoked during nid->package
+ * resolution.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int register_mp_package_notifier(struct notifier_block *notifier)
+{
+	return blocking_notifier_chain_register(&mp_package_algorithms, notifier);
+}
+EXPORT_SYMBOL_GPL(register_mp_package_notifier);
+
+/**
+ * unregister_mp_package_notifier - Unregister a package resolution algorithm
+ * @notifier: Notifier previously registered with register_mp_package_notifier().
+ */
+void unregister_mp_package_notifier(struct notifier_block *notifier)
+{
+	blocking_notifier_chain_unregister(&mp_package_algorithms, notifier);
+}
+EXPORT_SYMBOL_GPL(unregister_mp_package_notifier);
+
+/**
+ * mp_probe_package_id - Invoke registered notifiers to resolve a node's package
+ * @nid: NUMA node id to resolve.
+ *
+ * Calls the blocking notifier chain to let subsystems provide an initiator or
+ * package id for @nid.
+ *
+ * Return: Notifier return code (>=0 typically); negative errno on failure.
+ */
+int mp_probe_package_id(int nid)
+{
+	return blocking_notifier_call_chain(&mp_package_algorithms, nid, NULL);
+}
+EXPORT_SYMBOL_GPL(mp_probe_package_id);
+
+static int mp_node_to_package_id(int nid)
+{
+	int package_id = -EINVAL;
+	unsigned int first_cpu;
+	const struct cpumask *cpu_mask;
+
+	if (!node_state(nid, N_CPU))
+		goto out;
+
+	cpu_mask = cpumask_of_node(nid);
+	if (cpumask_empty(cpu_mask)) {
+		pr_err("node%d: CPU mask is empty\n", nid);
+		goto out;
+	}
+
+	first_cpu = cpumask_first(cpu_mask);
+	if (first_cpu >= nr_cpu_ids) {
+		pr_err("node%d: CPU (%d) out of range\n", nid, first_cpu);
+		goto out;
+	}
+
+	/*
+	 * Map the first CPU in this node’s cpumask to its physical package id.
+	 * This ties the NUMA node to a socket (package) using topology info.
+	 */
+	package_id = topology_physical_package_id(first_cpu);
+	if (package_id < 0) {
+		pr_err("node%d: failed to resolve package id (%d)\n", nid, package_id);
+		package_id = -EINVAL;
+		goto out;
+	}
+
+out:
+	return package_id;
+}
+
+static void update_package_preferred(struct memory_package *mp)
+{
+	struct memory_package_node *mpn;
+
+	lockdep_assert_held(&memory_package_lock);
+
+	/*
+	 * For each CPU node, compute its preferred set as the nearest
+	 * memory-only node(s) within the same package. If the package has
+	 * no memory-only nodes, fall back to a self-reference so callers
+	 * never see an empty preferred set.
+	 */
+	list_for_each_entry(mpn, &mp->cpu_list, package_entry) {
+		nodes_clear(mpn->preferred);
+		if (!nodes_empty(mp->memory_only_nodes))
+			nearest_nodes_nodemask(mpn->nid, &mp->memory_only_nodes,
+					       &mpn->preferred);
+		else
+			node_set(mpn->nid, mpn->preferred);
+	}
+
+	/*
+	 * Symmetrically, for each memory-only node, compute its preferred set
+	 * as the nearest CPU node(s) within the same package. If the package
+	 * has no CPU nodes, fall back to a self-reference.
+	 */
+	list_for_each_entry(mpn, &mp->memory_only_list, package_entry) {
+		nodes_clear(mpn->preferred);
+		if (!nodes_empty(mp->cpu_nodes))
+			nearest_nodes_nodemask(mpn->nid, &mp->cpu_nodes,
+					       &mpn->preferred);
+		else
+			node_set(mpn->nid, mpn->preferred);
+	}
+}
+
+static inline bool memory_package_is_empty(struct memory_package *mp)
+{
+	lockdep_assert_held(&memory_package_lock);
+
+	return (nodes_empty(mp->cpu_nodes) && nodes_empty(mp->memory_only_nodes));
+}
+
+static inline bool package_node_is_valid(int nid)
+{
+	if (!mpns[nid]) {
+		pr_err("mpns[%d] is NULL\n", nid);
+		return false;
+	}
+
+	if (nodes_empty(mpns[nid]->preferred) || (mpns[nid]->package == NULL)) {
+		pr_err("nid %d: package or preferred mask not initialized\n", nid);
+		return false;
+	}
+
+	return true;
+}
+
+static struct memory_package *create_memory_package(int package_id)
+{
+	struct memory_package *mempackage;
+
+	mempackage = kzalloc(sizeof(*mempackage), GFP_KERNEL);
+	if (!mempackage)
+		return ERR_PTR(-ENOMEM);
+
+	mempackage->package_id = package_id;
+	mempackage->nodes = NODE_MASK_NONE;
+	mempackage->cpu_nodes = NODE_MASK_NONE;
+	mempackage->memory_only_nodes = NODE_MASK_NONE;
+	INIT_LIST_HEAD(&mempackage->cpu_list);
+	INIT_LIST_HEAD(&mempackage->memory_only_list);
+	INIT_LIST_HEAD(&mempackage->list);
+
+	return mempackage;
+}
+
+static void destroy_memory_package(struct memory_package *mp)
+{
+	lockdep_assert_held(&memory_package_lock);
+
+	if (memory_package_is_empty(mp)) {
+		list_del(&mp->list);
+		kfree(mp);
+	}
+}
+
+static struct memory_package *find_create_memory_package(int package_id)
+{
+	struct memory_package *mempackage;
+
+	mutex_lock(&memory_package_lock);
+	list_for_each_entry(mempackage, &memory_packages, list) {
+		/*
+		 * If a package for this package_id already exists, reuse it
+		 * instead of allocating a new one.
+		 */
+		if (mempackage->package_id == package_id) {
+			mutex_unlock(&memory_package_lock);
+			return mempackage;
+		}
+	}
+	mutex_unlock(&memory_package_lock);
+
+	mempackage = create_memory_package(package_id);
+	if (IS_ERR(mempackage))
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&memory_package_lock);
+	list_add(&mempackage->list, &memory_packages);
+	mutex_unlock(&memory_package_lock);
+
+	return mempackage;
+}
+
+static int bind_node_to_package(int nid)
+{
+	int ret = 0, package_id;
+	struct memory_package *mp;
+
+	mutex_lock(&memory_package_lock);
+	if (!mpns[nid]) {
+		ret = -EINVAL;
+		goto unlock_out;
+	}
+	package_id = mpns[nid]->package_id;
+	mutex_unlock(&memory_package_lock);
+
+	mp = find_create_memory_package(package_id);
+	if (IS_ERR(mp)) {
+		ret = PTR_ERR(mp);
+		goto out;
+	}
+
+	mutex_lock(&memory_package_lock);
+	mpns[nid]->package = mp;
+	node_set(mpns[nid]->nid, mp->nodes);
+	if (node_is_memory_only(mpns[nid]->nid)) {
+		node_set(mpns[nid]->nid, mp->memory_only_nodes);
+		list_add(&mpns[nid]->package_entry, &mp->memory_only_list);
+	} else {
+		node_set(mpns[nid]->nid, mp->cpu_nodes);
+		list_add(&mpns[nid]->package_entry, &mp->cpu_list);
+	}
+	update_package_preferred(mp);
+
+unlock_out:
+	mutex_unlock(&memory_package_lock);
+out:
+	pr_info("memory_package %d: nodes=%*pbl cpu=%*pbl memery_only=%*pbl\n",
+		mp->package_id,
+		nodemask_pr_args(&mp->nodes),
+		nodemask_pr_args(&mp->cpu_nodes),
+		nodemask_pr_args(&mp->memory_only_nodes));
+
+	return ret;
+}
+
+static void unbind_node_to_package(struct memory_package *mp, int nid)
+{
+	lockdep_assert_held(&memory_package_lock);
+
+	node_clear(nid, mp->nodes);
+	if (node_state(nid, N_CPU))
+		node_clear(nid, mp->cpu_nodes);
+	else
+		node_clear(nid, mp->memory_only_nodes);
+
+	if (mpns[nid])
+		list_del(&mpns[nid]->package_entry);
+
+	update_package_preferred(mp);
+}
+
+static struct memory_package_node *create_package_node(int nid, int initiator_nid)
+{
+	int cpu_nid, package_id;
+	int source_flags;
+	struct memory_package_node *mpn;
+
+	if (node_state(nid, N_CPU)) {
+		cpu_nid = nid;
+		source_flags = MPN_SRC_CPU;
+	} else {
+		if (initiator_nid >= 0) {
+			cpu_nid = initiator_nid;
+			source_flags = MPN_SRC_INITIATOR;
+		} else {
+			/*
+			 * No driver-supplied initiator: fall back to the
+			 * nearest CPU node (via SLIT/numa_distance).
+			 */
+			cpu_nid = numa_nearest_node(nid, N_CPU);
+			source_flags = MPN_SRC_SLIT;
+		}
+	}
+
+	package_id = mp_node_to_package_id(cpu_nid);
+	if (package_id < 0)
+		return ERR_PTR(-EINVAL);
+
+	mpn = kzalloc(sizeof(*mpn), GFP_KERNEL);
+	if (!mpn)
+		return ERR_PTR(-ENOMEM);
+
+	mpn->nid = nid;
+	mpn->initiator_nid = cpu_nid;
+	mpn->package_id = package_id;
+	mpn->source_flags = source_flags;
+	mpn->preferred = NODE_MASK_NONE;
+	mpn->package = NULL;
+	INIT_LIST_HEAD(&mpn->package_entry);
+
+	return mpn;
+}
+
+static void __destroy_package_node(int nid)
+{
+	struct memory_package_node *mpn;
+	struct memory_package *mp;
+
+	lockdep_assert_held(&memory_package_lock);
+
+	mpn = mpns[nid];
+	if (!mpn)
+		return;
+
+	mp = mpn->package;
+	if (mp) {
+		unbind_node_to_package(mp, nid);
+		mpn->package = NULL;
+
+		if (memory_package_is_empty(mp))
+			destroy_memory_package(mp);
+	}
+
+	mpns[nid] = NULL;
+	kfree(mpn);
+}
+
+static void destroy_package_node(int nid)
+{
+	mutex_lock(&memory_package_lock);
+	__destroy_package_node(nid);
+	mutex_unlock(&memory_package_lock);
+}
+
+static int find_package_node(int nid, int initiator_nid)
+{
+	int mpn_nid = NUMA_NO_NODE;
+
+	mutex_lock(&memory_package_lock);
+	if (mpns[nid]) {
+		/*
+		 * SLIT-derived entries are provisional; if a driver later
+		 * provides an explicit initiator, drop the provisional
+		 * entry and rebuild with the stronger hint.
+		 */
+		if (mpns[nid]->source_flags == MPN_SRC_SLIT && initiator_nid >= 0)
+			__destroy_package_node(nid);
+		else
+			mpn_nid = nid;
+	}
+	mutex_unlock(&memory_package_lock);
+
+	return mpn_nid;
+}
+
+static int find_create_package_node(int nid, int initiator_nid)
+{
+	int mpn_nid;
+	struct memory_package_node *mpn;
+
+	mpn_nid = find_package_node(nid, initiator_nid);
+	if (mpn_nid != NUMA_NO_NODE)
+		return mpn_nid;
+
+	mpn = create_package_node(nid, initiator_nid);
+	if (IS_ERR(mpn))
+		return PTR_ERR(mpn);
+
+	mutex_lock(&memory_package_lock);
+	mpns[nid] = mpn;
+	mutex_unlock(&memory_package_lock);
+
+	return nid;
+}
+
+static int create_node_with_package(int nid)
+{
+	int ret;
+
+	ret = find_create_package_node(nid, NUMA_NO_NODE);
+	if (ret < 0) {
+		pr_err("package_node(%d) failed: %d\n", nid, ret);
+		return ret;
+	}
+
+	ret = bind_node_to_package(nid);
+	if (ret) {
+		pr_err("bind_node_to_package(%d) failed: %d\n", nid, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * mp_add_package_node_by_initiator - Add a node with an initiator
+ * @nid:            Target NUMA node to add.
+ * @initiator_nid:  CPU nid used to resolve @nid's package (>=0).
+ *
+ * Ensures that a &struct memory_package_node exists for @nid and that its
+ * package_id is determined using @initiator_nid when provided. Binding to the
+ * package is not performed here.
+ *
+ * Return: 0 on success; negative errno on failure.
+ */
+int mp_add_package_node_by_initiator(int nid, int initiator_nid)
+{
+	int ret;
+
+	ret = find_create_package_node(nid, initiator_nid);
+	if (ret < 0) {
+		pr_err("find_create_package_node(nid=%d, initiator=%d) failed: %d\n",
+		       nid, initiator_nid, ret);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mp_add_package_node_by_initiator);
+
+/**
+ * mp_add_package_node - Add a node, resolving package automatically
+ * @nid: Target NUMA node to add.
+ *
+ * Wrapper over mp_add_package_node_by_initiator() that requests automatic
+ * initiator resolution (e.g., nearest CPU).
+ *
+ * Return: 0 on success; negative errno on failure.
+ */
+int mp_add_package_node(int nid)
+{
+	return mp_add_package_node_by_initiator(nid, NUMA_NO_NODE);
+}
+EXPORT_SYMBOL_GPL(mp_add_package_node);
+
+static int __mp_get_preferred_nodemask(int nid, enum mp_nodes_type node_type,
+				    nodemask_t *out)
+{
+	int ret = 0;
+
+	if (!out) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	nodes_clear(*out);
+
+	if (nid < 0 || nid >= MAX_NUMNODES) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (node_type == MP_NODES_CPU) {
+		if (node_is_memory_only(nid)) {
+			pr_err("nid %d is a memory-only node\n", nid);
+			ret = -EINVAL;
+			goto out;
+		}
+	} else if (node_type == MP_NODES_MEM_ONLY) {
+		if (!node_is_memory_only(nid)) {
+			pr_err("nid %d is a CPU node\n", nid);
+			ret = -EINVAL;
+			goto out;
+		}
+	} else {
+		pr_err("invalid node type: %d\n", (int)node_type);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!package_node_is_valid(nid)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	nodes_copy(*out, mpns[nid]->preferred);
+
+out:
+	return ret;
+}
+
+static int __mp_get_package_nodemask(int nid, enum mp_nodes_type node_type,
+				     nodemask_t *out)
+{
+	int ret = 0;
+
+	if (!out) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	nodes_clear(*out);
+
+	if (nid < 0 || nid >= MAX_NUMNODES) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!package_node_is_valid(nid)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	switch (node_type) {
+	case MP_NODES_ALL:
+		nodes_copy(*out, mpns[nid]->package->nodes);
+		break;
+	case MP_NODES_CPU:
+		nodes_copy(*out, mpns[nid]->package->cpu_nodes);
+		break;
+	case MP_NODES_MEM_ONLY:
+		nodes_copy(*out, mpns[nid]->package->memory_only_nodes);
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+#if CONFIG_MIGRATION
+/**
+ * mp_next_demotion_nodemask - Demotion candidates within a package
+ * @nid: CPU node from which memory would be demoted.
+ * @out: Output nodemask of nearest memory-only targets in the same package.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_next_demotion_nodemask(int nid, nodemask_t *out)
+{
+	return __mp_get_preferred_nodemask(nid, MP_NODES_CPU, out);
+}
+EXPORT_SYMBOL_GPL(mp_next_demotion_nodemask);
+
+/**
+ * mp_next_demotion_node - Pick one demotion target
+ * @nid: CPU node from which memory would be demoted.
+ *
+ * Picks one target (random among the nearest) from mp_next_demotion_nodemask().
+ *
+ * Return: target nid on success, or NUMA_NO_NODE if no candidate is available.
+ */
+int mp_next_demotion_node(int nid)
+{
+	int target_nid;
+	nodemask_t target_nodemask;
+
+	if (mp_next_demotion_nodemask(nid, &target_nodemask))
+		return NUMA_NO_NODE;
+	if (nodes_empty(target_nodemask))
+		return NUMA_NO_NODE;
+
+	target_nid = node_random(&target_nodemask);
+
+	return target_nid;
+}
+EXPORT_SYMBOL_GPL(mp_next_demotion_node);
+
+/**
+ * mp_next_promotion_nodemask - Promotion candidates within a package
+ * @nid: Memory-only node towards which promotion seeks CPU locality.
+ * @out: Output nodemask of nearest CPU targets in the same package.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_next_promotion_nodemask(int nid, nodemask_t *out)
+{
+	return __mp_get_preferred_nodemask(nid, MP_NODES_MEM_ONLY, out);
+}
+EXPORT_SYMBOL_GPL(mp_next_promotion_nodemask);
+
+/**
+ * mp_next_promotion_node - Pick one promotion target
+ * @nid: Memory-only node to be promoted towards CPUs.
+ *
+ * Picks one target (random among the nearest) from mp_next_promotion_nodemask().
+ *
+ * Return: target nid on success, or NUMA_NO_NODE if no candidate is available.
+ */
+int mp_next_promotion_node(int nid)
+{
+	int target_nid;
+	nodemask_t target_nodemask;
+
+	if (mp_next_promotion_nodemask(nid, &target_nodemask))
+		return NUMA_NO_NODE;
+	if (nodes_empty(target_nodemask))
+		return NUMA_NO_NODE;
+
+	target_nid = node_random(&target_nodemask);
+
+	return target_nid;
+}
+EXPORT_SYMBOL_GPL(mp_next_promotion_node);
+#endif /* CONFIG_MIGRATION */
+
+/**
+ * mp_get_package_nodes - Return all members of @nid's package
+ * @nid: Any NUMA node in the package.
+ * @out: Output nodemask to receive all members.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_get_package_nodes(int nid, nodemask_t *out)
+{
+	return __mp_get_package_nodemask(nid, MP_NODES_ALL, out);
+}
+EXPORT_SYMBOL_GPL(mp_get_package_nodes);
+
+/**
+ * mp_get_package_cpu_nodes - Return CPU members of @nid's package
+ * @nid: Any NUMA node in the package.
+ * @out: Output nodemask to receive CPU members.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+int mp_get_package_cpu_nodes(int nid, nodemask_t *out)
+{
+	return __mp_get_package_nodemask(nid, MP_NODES_CPU, out);
+}
+EXPORT_SYMBOL_GPL(mp_get_package_cpu_nodes);
+
+int mp_get_package_memory_only_nodes(int nid, nodemask_t *out)
+{
+	return __mp_get_package_nodemask(nid, MP_NODES_MEM_ONLY, out);
+}
+EXPORT_SYMBOL_GPL(mp_get_package_memory_only_nodes);
+
+/**
+ * mp_get_package_memory_only_nodes - Return memory-only members of @nid's package
+ * @nid: Any NUMA node in the package.
+ * @out: Output nodemask to receive memory-only members.
+ *
+ * Return: 0 on success; negative errno if @nid is invalid or not initialized.
+ */
+static int __meminit mp_hotplug_callback(struct notifier_block *nb,
+		unsigned long action, void *_arg)
+{
+	int nid;
+	struct node_notify *nn = _arg;
+
+	nid = nn->nid;
+	if (nid < 0)
+		return notifier_from_errno(0);
+
+	switch (action) {
+	case NODE_REMOVED_LAST_MEMORY:
+		destroy_package_node(nid);
+		break;
+
+	case NODE_ADDED_FIRST_MEMORY:
+		create_node_with_package(nid);
+		break;
+
+	default:
+		break;
+	}
+
+	return notifier_from_errno(0);
+}
+
+static int __init memory_package_init(void)
+{
+	int ret = 0, nid;
+
+	for_each_online_node(nid) {
+		if (!node_state(nid, N_MEMORY))
+			continue;
+
+		/*
+		 * On boot, enumerate already-present NUMA nodes and build the
+		 * initial package topology. CPU nodes are the common case,
+		 * but memory-only nodes are handled as well.
+		 */
+		ret = create_node_with_package(nid);
+		if (ret) {
+			pr_err("create nid(%d) failed: %d\n", nid, ret);
+			goto out;
+		}
+	}
+
+	hotplug_node_notifier(mp_hotplug_callback, MEMTIER_HOTPLUG_PRI);
+
+out:
+	return ret;
+}
+late_initcall(memory_package_init);
-- 
2.34.1


