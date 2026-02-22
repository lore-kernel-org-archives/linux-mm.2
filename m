Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F37C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022676B00AC; Sun, 22 Feb 2026 03:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F389D6B00AE; Sun, 22 Feb 2026 03:49:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9C36B00AF; Sun, 22 Feb 2026 03:49:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C67E56B00AC
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B31959807
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:50 +0000 (UTC)
X-FDA: 84471469740.23.BA79D4A
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9194E1C0003
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uAqg6iU5;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zm28kvmD9iuWWLwvtJBamWBricaC3Bz050FlGsgvxtM=;
	b=5MqKito+ESpLkNXyRJm/zSabpVgEbBUH4INamguLxTBq128rekLxABNNYkn3DWzHGce5SD
	kLzHP0/1s3sHujl+6EwsATKWtQXKbF78zvCP8cWGHdfselZaDRpW98f8spZka8hDxF/ZBp
	2yIs43nJwVzcD6k9JB9BpX3JgOURI/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750188; a=rsa-sha256;
	cv=none;
	b=oI4mtX+lcPkvfuH9acgjOX5L5EgFs9ryfOkdie8HInSBY3y49FBLyPZNzTEjjnHSybqhLo
	FYKreHvQqvia561w0RCDK7lNoHUjTB0W/TJifUIE6rzx4xRtx313DMjxj7ryTFJJjWB31f
	xt9CWXhShpfkozI0rFiYIz4mAEM+EgU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uAqg6iU5;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5062fc5d86aso33209691cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750188; x=1772354988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zm28kvmD9iuWWLwvtJBamWBricaC3Bz050FlGsgvxtM=;
        b=uAqg6iU5Zlh1ikPvhsiAhyO1K/oFZxvzfX4WC0GOVXEIFNx8W+FniECixCLjN7LLkm
         53LUW8AIpVpZ/xkTFHpRLvFTqEt98CSNvV/XJCIeQF5cHhtOc9OVhizuNP+vj1kuWwrN
         yj6je+2HrHMdptu/RXKPe0cdzp+pgt5VJz7W4mzAo/2R2hEiklenWhjrJksqqrrkAlKK
         OA9JVht+xBVyNEhHkQZ8qvn4a8c6mnbbEEHrZ451agCtFeIzBO/dieqRnSjGHVbL1Mf/
         UE/Q6NESMWd8Sm0uMDpukCuggD+OkPMehyVQfY/1ChZrqEC2d6uOjDPQ7BJRO+VRo/gG
         qDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750188; x=1772354988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zm28kvmD9iuWWLwvtJBamWBricaC3Bz050FlGsgvxtM=;
        b=bJbunvpspiqx3BLEUYaG2+mpZcxRKCtE+SaqZk0oNhYE0eO2zgJpmeyixdNLPWCNVw
         MnJo60Nx4Gu6cAeL6/NT54tJDJ0JT5Y29ACYPkqU5SkmcSk9TfXWgQrPl5n851XIKofQ
         4NIEqgseoztpCnsmZ6nQ55xbsf3jlKkCZyk3FVlt4BMn7+LI7IA64AQRQuv+X6GOeWgJ
         amZp/ErFIVv9gezmMvcfknbAFhIiSggFG2bfUp0FNimzDTMBuYgC5OLup1ma2Rec5fSU
         lMiUXGgs0NbwpZNS2eNkA44dFGa59jYjpn6o1HeJpx96YVn3ekL3V9xEIwFQS1aZtit5
         jktg==
X-Forwarded-Encrypted: i=1; AJvYcCXaxglV2tL8gruAqWzak0om6Kpz7d4N8seaskk0wSLbVT1BFHz0AiK62im3XLA/tU4V4cr2zoF9hQ==@kvack.org
X-Gm-Message-State: AOJu0YxdQq06CUE7bfXR2pVPFM1b5U70NSLosLTpzDMqE69kKUrcIANd
	F/nWGe+K5L7Gkzr17h8xstUvaVm41eFs0b2lF+KArQnO5gMycW5Wl54E75HT3GFI22g=
X-Gm-Gg: AZuq6aJ80cPQ8i+86s1htoQSIonEaAhet8d/C9fZlMUwhwKyKSek+rH7gboJYOKt2UK
	8r3N2G8k87Uvga/DPpck3+Pd7qtRK8A9QQKtdPbBHZXjMtTVcVp4zwkb5+/LJQm5d1MqddUoe82
	edQMKNZnozBaWqwG7O68rOEvou0UQRjNPZgDRSMsbs3gqjZTz1Zdj/oQcAakDkOzmUs7P+2k+8e
	soRCKG+9Pbl6TjvCBTUvAhl2p2/AK997egqA+JTL78lWvE/y5n7u9Ifb36LQ25VMmLWKz7jcGpL
	suSRWtRfbFsPB74JzwFlWSN6O4Gmup73JwLahDvzseT13WHu/yJAiW9N47DBt9MdLfZqYETI3Op
	ML3VtPbpu2vAcD81Wz+JqBsnYZTgl7pVUAfW/Imf6T8nZqFDP2u6aKNhiHWFebKvj/pv9HxdOW2
	s3Heyec0UGpFlDTpmXvYmHA7CHr9/MQbSPJPsIwC+6UwTBf8hFwZ99jp7+pSUkRPZYKuyffQsCu
	ru7K4gm920oSPRuPwaLvcfBJA==
X-Received: by 2002:ac8:5d43:0:b0:4ee:24e8:c9a1 with SMTP id d75a77b69052e-5070bc4bb77mr73824241cf.44.1771750187486;
        Sun, 22 Feb 2026 00:49:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:46 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 14/27] mm/memory-tiers: NP_OPS_DEMOTION - support private node demotion
Date: Sun, 22 Feb 2026 03:48:29 -0500
Message-ID: <20260222084842.1824063-15-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9194E1C0003
X-Stat-Signature: 3jthzp4d3xbyym7wibffkumdrdcohjhj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771750188-170340
X-HE-Meta: U2FsdGVkX188IL9DixKa4Y5Va09LLz6/ifo6TprjP2W5uZHiKLsQMCuiiXIotn5f3kJJ07SKBXF1CB59MLdtiisrn5rmtHLN5ihTLSo49aT42w19kapBeWVdr3arpN7Z+WaSVyAGWREwcZE8jPexnx7DYNBZ5X4vOBUv59qYHKl9sqM+vyzO3e/KqqXnlO26c2CRzQhbD3GnLTYW4uROqxAUdkPsMSbGdnS6DJ3xl7cX4KONS0IjIXpguHekMWlZfdK2lDGgAufrUNTLrJY379qkc2feY1Zbjp+dGJP/po+TILFqHjG63UR4YpZTvuZn4Tnp4XCfaduxGelqGmx5FvYnfosy79dav7UVJnygibYsHSUFjFIKQ6+1bHlkcIt3XPc/EM7YOqJMuLUUSdnRSm1bMp86EKGlvC0czncr7qf1AJCR0xwo1wY09Hqia+9vL/7Oj1DKBi+FaZjQSJ7OPseLhx6C3BjRpJNw4ILATawzfkog4pWC/QIufnAt0J4FWiKUZdVGSJtuh2irutmG7LvjZyrPfSWDfvuZXe2jx7Jatpv5LdskyhoC4k9hDYl5mMclheOTpyJSaM8P4m2T57DQiXs1AIpUwIy1x9AyFXgFkX3yBm3TIieckdAXHrPSj8lDXgWzQjCFLGxKiDCyND+UNPIyxStG1nRx01vVwU9qS8wmR5GbW6B8xa8Dlxnc4m4WCuV3NLzZxzGFhzt4I3G6FzP4oTCZOgohkJIBtqL1+qQvTTOe40N/61Ex3MbQcspqFQPLVtnias2lk/WNMx6W51rjB8Ecy6jZUm0demcu2eFhm4oS9keN09LEfIHtYSO1NGdr6671o7lhT8PFPtQH5v7GVbt/r8DJuoZFEpaHpTZfirNoeWF2yTR/1Obf6kVj5MWwEI49pOaF6/WsqkRGxMSmocfPO91Ketm1L9dzoIIHyO+fD+5eFsOosiLAoxJP3WcSdCRswPJ4y49
 NKT+akVt
 9jsuarGUCMHE3f+Oc+AzZfDO0iyIdf+r30udk1jSVgk1Dm+kRWUtvFcLqHBgTnnvcUDUOSKgs9PYWcXysDOPu7MhwREMfKSz8jqYx21k38BMy/EdbJ1G4QW3hrTyzVsNOZ5Y4V9tF2FuCnc+eu3sklAE3vKgaXM7Fky/XgO4dRzweOB8tbSy+X6jzTw8d1FoL4yRETFFhaqvB460vWW9DorZnBCJfNGzVG5dy59RkdhymzmGHh/UYhr9jbIsU/JD4NmBqDB90JwV9ip4EipsUSHxDDoVRrsayZCot1vW7nAU2Sl7RjZmnCzfeHq8V0asg3rUS9HqbUMF0IIhGEjRrLCCqNYnp7H4JTx5o6vrGlY82G+L7McpIdMBuNvJI/HhjrOjLLlCk6GBTSJE2CkHqV7fPO4EleoFXRGvDz3UBcn+VlSq7+TN5uvAPiw+aAcOH89pGcY4S4weBN7o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory-tier subsystem needs to know which private nodes should
appear as demotion targets.

Add NP_OPS_DEMOTION (BIT(2)):
   Node can be added as a demotion target by memory-tiers.

Add demotion backpressure support so private nodes can reject
new demotions cleanly, allowing vmscan to fall back to swap.

In the demotion path, try demotion to private nodes invididually,
then clear private nodes from the demotion target mask until a
non-private node is found, then fall back to the remaining mask.
This prevents LRU inversion while still allowing forward progress.

This is the closest match to the current behavior without making
private nodes inaccessible or preventing forward progress. We
should probably completely re-do the demotion logic to allow less
fallback and kick kswapd instead - right now we induce LRU
inversions by simply falling back to any node in the demotion list.

Add memory_tier_refresh_demotion() export for services to trigger
re-evaluation of demotion targets after changing their flags.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h |  9 +++++++
 include/linux/node_private.h | 22 +++++++++++++++++
 mm/internal.h                |  7 ++++++
 mm/memory-tiers.c            | 46 ++++++++++++++++++++++++++++++++----
 mm/page_alloc.c              | 12 +++++++---
 mm/vmscan.c                  | 30 ++++++++++++++++++++++-
 6 files changed, 117 insertions(+), 9 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 3e1159f6762c..e1476432e359 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -58,6 +58,7 @@ struct memory_dev_type *mt_get_memory_type(int adist);
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
+void memory_tier_refresh_demotion(void);
 #else
 static inline int next_demotion_node(int node)
 {
@@ -73,6 +74,10 @@ static inline bool node_is_toptier(int node)
 {
 	return true;
 }
+
+static inline void memory_tier_refresh_demotion(void)
+{
+}
 #endif
 
 #else
@@ -106,6 +111,10 @@ static inline bool node_is_toptier(int node)
 	return true;
 }
 
+static inline void memory_tier_refresh_demotion(void)
+{
+}
+
 static inline int register_mt_adistance_algorithm(struct notifier_block *nb)
 {
 	return 0;
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index e9b58afa366b..e254e36056cd 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -88,6 +88,8 @@ struct node_private_ops {
 #define NP_OPS_MIGRATION		BIT(0)
 /* Allow mempolicy-directed allocation and mbind migration to this node */
 #define NP_OPS_MEMPOLICY		BIT(1)
+/* Node participates as a demotion target in memory-tiers */
+#define NP_OPS_DEMOTION			BIT(2)
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -101,12 +103,14 @@ struct node_private_ops {
  *		callbacks that may sleep; 0 = fully released)
  * @released: Signaled when refcount drops to 0; unregister waits on this
  * @ops: Service callbacks and exclusion flags (NULL until service registers)
+ * @migration_blocked: Service signals migrations should pause
  */
 struct node_private {
 	void *owner;
 	refcount_t refcount;
 	struct completion released;
 	const struct node_private_ops *ops;
+	bool migration_blocked;
 };
 
 #ifdef CONFIG_NUMA
@@ -306,6 +310,19 @@ static inline bool nodes_private_mpol_allowed(const nodemask_t *nodes)
 	}
 	return eligible;
 }
+
+static inline bool node_private_migration_blocked(int nid)
+{
+	struct node_private *np;
+	bool blocked;
+
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	blocked = np && READ_ONCE(np->migration_blocked);
+	rcu_read_unlock();
+
+	return blocked;
+}
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #else /* !CONFIG_NUMA */
@@ -404,6 +421,11 @@ static inline bool nodes_private_mpol_allowed(const nodemask_t *nodes)
 	return false;
 }
 
+static inline bool node_private_migration_blocked(int nid)
+{
+	return false;
+}
+
 static inline int node_private_register(int nid, struct node_private *np)
 {
 	return -ENODEV;
diff --git a/mm/internal.h b/mm/internal.h
index 6ab4679fe943..5950e20d4023 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1206,6 +1206,8 @@ extern int node_reclaim_mode;
 
 extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
+extern int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+				  const nodemask_t *candidates);
 extern bool numa_zone_alloc_allowed(int alloc_flags, struct zone *zone,
 			      gfp_t gfp_mask);
 #else
@@ -1220,6 +1222,11 @@ static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
 	return NUMA_NO_NODE;
 }
+static inline int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+					 const nodemask_t *candidates)
+{
+	return NUMA_NO_NODE;
+}
 static inline bool numa_zone_alloc_allowed(int alloc_flags, struct zone *zone,
 				     gfp_t gfp_mask)
 {
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 9c742e18e48f..434190fdc078 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -3,6 +3,7 @@
 #include <linux/lockdep.h>
 #include <linux/sysfs.h>
 #include <linux/kobject.h>
+#include <linux/node_private.h>
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
@@ -380,6 +381,8 @@ static void disable_all_demotion_targets(void)
 		if (memtier)
 			memtier->lower_tier_mask = NODE_MASK_NONE;
 	}
+	for_each_node_state(node, N_MEMORY_PRIVATE)
+		node_demotion[node].preferred = NODE_MASK_NONE;
 	/*
 	 * Ensure that the "disable" is visible across the system.
 	 * Readers will see either a combination of before+disable
@@ -421,6 +424,7 @@ static void establish_demotion_targets(void)
 	int target = NUMA_NO_NODE, node;
 	int distance, best_distance;
 	nodemask_t tier_nodes, lower_tier;
+	nodemask_t all_memory;
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
@@ -429,6 +433,13 @@ static void establish_demotion_targets(void)
 
 	disable_all_demotion_targets();
 
+	/* Include private nodes that have opted in to demotion. */
+	all_memory = node_states[N_MEMORY];
+	for_each_node_state(node, N_MEMORY_PRIVATE) {
+		if (node_private_has_flag(node, NP_OPS_DEMOTION))
+			node_set(node, all_memory);
+	}
+
 	for_each_node_state(node, N_MEMORY) {
 		best_distance = -1;
 		nd = &node_demotion[node];
@@ -442,12 +453,12 @@ static void establish_demotion_targets(void)
 		memtier = list_next_entry(memtier, list);
 		tier_nodes = get_memtier_nodemask(memtier);
 		/*
-		 * find_next_best_node, use 'used' nodemask as a skip list.
+		 * find_next_best_node_in, use 'used' nodemask as a skip list.
 		 * Add all memory nodes except the selected memory tier
 		 * nodelist to skip list so that we find the best node from the
 		 * memtier nodelist.
 		 */
-		nodes_andnot(tier_nodes, node_states[N_MEMORY], tier_nodes);
+		nodes_andnot(tier_nodes, all_memory, tier_nodes);
 
 		/*
 		 * Find all the nodes in the memory tier node list of same best distance.
@@ -455,7 +466,8 @@ static void establish_demotion_targets(void)
 		 * in the preferred mask when allocating pages during demotion.
 		 */
 		do {
-			target = find_next_best_node(node, &tier_nodes);
+			target = find_next_best_node_in(node, &tier_nodes,
+							&all_memory);
 			if (target == NUMA_NO_NODE)
 				break;
 
@@ -495,7 +507,7 @@ static void establish_demotion_targets(void)
 	 * allocation to a set of nodes that is closer the above selected
 	 * preferred node.
 	 */
-	lower_tier = node_states[N_MEMORY];
+	lower_tier = all_memory;
 	list_for_each_entry(memtier, &memory_tiers, list) {
 		/*
 		 * Keep removing current tier from lower_tier nodes,
@@ -542,7 +554,7 @@ static struct memory_tier *set_node_memory_tier(int node)
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	if (!node_state(node, N_MEMORY))
+	if (!node_state(node, N_MEMORY) && !node_state(node, N_MEMORY_PRIVATE))
 		return ERR_PTR(-EINVAL);
 
 	mt_calc_adistance(node, &adist);
@@ -865,6 +877,30 @@ int mt_calc_adistance(int node, int *adist)
 }
 EXPORT_SYMBOL_GPL(mt_calc_adistance);
 
+/**
+ * memory_tier_refresh_demotion() - Re-establish demotion targets
+ *
+ * Called by services after registering or unregistering ops->migrate_to on
+ * a private node, so that establish_demotion_targets() picks up the change.
+ */
+void memory_tier_refresh_demotion(void)
+{
+	int nid;
+
+	mutex_lock(&memory_tier_lock);
+	/*
+	 * Ensure private nodes are registered with a tier, otherwise
+	 * they won't show up in any node's demotion targets nodemask.
+	 */
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		if (!__node_get_memory_tier(nid))
+			set_node_memory_tier(nid);
+	}
+	establish_demotion_targets();
+	mutex_unlock(&memory_tier_lock);
+}
+EXPORT_SYMBOL_GPL(memory_tier_refresh_demotion);
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ec6c1f8e85d8..e272dfdc6b00 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5589,7 +5589,8 @@ static int node_load[MAX_NUMNODES];
  *
  * Return: node id of the found node or %NUMA_NO_NODE if no node is found.
  */
-int find_next_best_node(int node, nodemask_t *used_node_mask)
+int find_next_best_node_in(int node, nodemask_t *used_node_mask,
+			   const nodemask_t *candidates)
 {
 	int n, val;
 	int min_val = INT_MAX;
@@ -5599,12 +5600,12 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
 	 * Use the local node if we haven't already, but for memoryless local
 	 * node, we should skip it and fall back to other nodes.
 	 */
-	if (!node_isset(node, *used_node_mask) && node_state(node, N_MEMORY)) {
+	if (!node_isset(node, *used_node_mask) && node_isset(node, *candidates)) {
 		node_set(node, *used_node_mask);
 		return node;
 	}
 
-	for_each_node_state(n, N_MEMORY) {
+	for_each_node_mask(n, *candidates) {
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -5636,6 +5637,11 @@ int find_next_best_node(int node, nodemask_t *used_node_mask)
 	return best_node;
 }
 
+int find_next_best_node(int node, nodemask_t *used_node_mask)
+{
+	return find_next_best_node_in(node, used_node_mask,
+				      &node_states[N_MEMORY]);
+}
 
 /*
  * Build zonelists ordered by node and zones within node.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6113be4d3519..0f534428ea88 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/node_private.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -355,6 +356,10 @@ static bool can_demote(int nid, struct scan_control *sc,
 	if (demotion_nid == NUMA_NO_NODE)
 		return false;
 
+	/* Don't demote when the target's service signals backpressure */
+	if (node_private_migration_blocked(demotion_nid))
+		return false;
+
 	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
 	return mem_cgroup_node_allowed(memcg, demotion_nid);
 }
@@ -1022,8 +1027,10 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 				     struct pglist_data *pgdat)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
-	unsigned int nr_succeeded;
+	int first_nid = target_nid;
+	unsigned int nr_succeeded = 0;
 	nodemask_t allowed_mask;
+	int ret;
 
 	struct migration_target_control mtc = {
 		/*
@@ -1046,6 +1053,27 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 
 	node_get_allowed_targets(pgdat, &allowed_mask);
 
+	/* Try private node targets until we find non-private node */
+	while (node_state(target_nid, N_MEMORY_PRIVATE)) {
+		unsigned int nr = 0;
+
+		ret = node_private_migrate_to(demote_folios, target_nid,
+					      MIGRATE_ASYNC, MR_DEMOTION,
+					      &nr);
+		nr_succeeded += nr;
+		if (ret == 0 || list_empty(demote_folios))
+			return nr_succeeded;
+
+		target_nid = next_node_in(target_nid, allowed_mask);
+		if (target_nid == first_nid)
+			return nr_succeeded;
+		if (!node_state(target_nid, N_MEMORY_PRIVATE))
+			break;
+	}
+
+	/* target_nid is a non-private node; use standard migration */
+	mtc.nid = target_nid;
+
 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
 		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
-- 
2.53.0


