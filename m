Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E398CD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0108E0012; Wed, 12 Nov 2025 14:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A510F8E0002; Wed, 12 Nov 2025 14:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CACA8E0012; Wed, 12 Nov 2025 14:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7691D8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:03 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FE0513B838
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:03 +0000 (UTC)
X-FDA: 84102945486.08.2623BE8
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 33651140004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YNXeNMAm;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJ3STVw+04anWCoqtoEILU8J9sgMLUtAldTEWscHkZw=;
	b=UZB/MfbvUx7N96W34TL9onvsj+2yHNwQlyc/siOoEyy+aYCTDIfWUiFsixVKk9PWdDhWnT
	i3d0fNilRFLBR8Nx9+gbilIJ4xx8njtGAsQFZoNu7Ya2rCpyUJbuutEtKJlFu1G66ZvZv1
	Yfk1hCU6QdUfzR2vXsGyjuX78v7lG/4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YNXeNMAm;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975801; a=rsa-sha256;
	cv=none;
	b=twufK/TGHd+Tc+meHP5M63HxZ36U0MGjWg8POTuqZqEa9DP/FjCJyGy2yEj+p2yVI/d6wi
	CPe0npf43TG+AzuOrC2E+qhCrZU5XpPurCvTwbLmqAF4GFcIIl1jWuZVDpPFH0gPwfb7be
	yxJQPqfO5OMJfyKyQkiW3sce9NkXWTg=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b25dd7ab33so3190485a.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975800; x=1763580600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJ3STVw+04anWCoqtoEILU8J9sgMLUtAldTEWscHkZw=;
        b=YNXeNMAm0L0zZ8WiYrHgC+qBp+U+fGfOKBfuSA8xplRXlpelaVAcZN8Z+6zaV/3PTl
         lROBNUsn5OMWEBr36GfwKJ1JAC8gbYNfyF+InRM1POwRheTeOaYJaJ825j50eLT4wF0I
         IAsB1mOVkt/cYn/MZMfNxKVbBLNnvZg82Y8frt93K7IVmM3J8d+eyFdk0D5pnzwFKORX
         c1MN3oKJCwCqk5ih2Afj01EF5DJQ5SYM9AJvFLcqhq0KTXjRJi4siHeLg0va7XnRvSJv
         ANNlr2E8gNKDrN8qsJUVtjkNSl4fIn9JEWGjV26w5X69YaHKDQxxUveX+sVKKehbgsbj
         5rrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975800; x=1763580600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QJ3STVw+04anWCoqtoEILU8J9sgMLUtAldTEWscHkZw=;
        b=qGRdCADjc41vgp3fXczIsosDsoafqAg3wIfYRb2Oz5GlFilsavt1I4Y+gIlkfkv578
         JY15ndMXxH8bxgnsZEYxmAvvkoKsHGwvAt+HQchdpaq3VAmFFHBa+e5QzoHHIUo6Uzoj
         y8dSiXyq42mD4EvwKvcpsMyWkV2Mdk083BNERvdd1IdG7M0eaGliB/uFg3fOO8XfccDt
         hfIeVDkatpcPTAYGbg1c4XkgntzwZyDsrEh29YPtA1wPZ4dnFT0fzpTLPfHPj00JOZfo
         /gtnwF8oeNzeGyqK2dsADjmqKh1N21QKGnMYlYOhqe9HsCrcwSz1aO2re100E0Wvlhgm
         X+2g==
X-Gm-Message-State: AOJu0YxXUGc/r9HhDsj/OAUzdUlIJXLBFFRn5qBZt2rApLtVxLfLsy3e
	LLwALyXDdIcYS7yQ2ZVcz/bwiEU29ggrOvIMLncimN5FCFxSmV9TWriQd616Eubz4B3yOS+LCPF
	6IIqe
X-Gm-Gg: ASbGncuuOgD3eKiu2xVhtqj7I/oB8dqVCuSo+wlb/7gpVRiaeLJ0IvEMM0ajEfdUsEk
	W0GjuklHrxTwX11j12DAV4tHXRwoVFPj7IVvSl22VYCSnTjjO93KrzDGzqYSPRpTpmlm2ga4soq
	tQKLfKpJgZUwqRknhh+XrT4wDofk0JBPwacze5oMWALwcwOa5DUfO91g2cpc30Th92C5V0fSoWF
	S7Meg6gyI38TLm9VxPokna73YrLXeLJIktlAvQzo9HWIVCQ8JG/KAF3KRa6ctbWzzJyO8KqbGY3
	HrtQh4Cg/epYWQ0u+2uBjsvFDocEsHQBm7BjYyznntjdrENT0Xv5uKrSfY/sMVpaW9tvweOfQ0z
	RLYypUkATuNsq8MGsJxS+96MpRXPvOXbp89sohpA+C0VJPQ5xUyXXwvcM+dJ6r3eYfJ6gWEB37p
	W6HHvdWYgFa02AYehqWs/Gk9S6v1qMFl1ZosiRjJ2lRriwLAu4JcznOJWtt9enL+HT
X-Google-Smtp-Source: AGHT+IFpnJx+AzJWivjhYu5iwBOCku4YiBEji1yF3XFF/JbCkfgSDAdwWhiHUxXnRZSwthPc0nD5rw==
X-Received: by 2002:a05:620a:40c1:b0:8b1:ac18:acc9 with SMTP id af79cd13be357-8b29b77ad4bmr554239985a.32.1762975799847;
        Wed, 12 Nov 2025 11:29:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:59 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
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
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 04/11] memory-tiers: Introduce SysRAM and Specific Purpose Memory Nodes
Date: Wed, 12 Nov 2025 14:29:20 -0500
Message-ID: <20251112192936.2574429-5-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33651140004
X-Stat-Signature: u84k43kgakeo6ig7m3d9onrdw5an7j6i
X-Rspam-User: 
X-HE-Tag: 1762975801-822496
X-HE-Meta: U2FsdGVkX19SJ3WXbqLqXPROy9u803WTqUZlwEKb/Q4L+IlKrYnXNHez/lb0Z76Zn1SASaFR0kAVvbmYu/8ZQhf8dBuOHy9BPNo55J/BZNltFCjF2X2rHW7lZbhBge0ZeUvTNlz4u/f0hgxkhkke+85zYBxXECBa3s8ZjoHr61gLISUZhudRpo236l5xO0UR/6loMyJn7ULNPSpAtSq1z7qAAooIXEMXqd66C/OlUhVhdjXUZpDYuQ/MkUsI6NpWWtREQxMe64g1bRi/DKBLZrCwzAxPK0iRCNymECpPJeUjTbXQ4MWwd6tIkWi+zelOpQCqUk5d7dqBobLwRnN0pNQIbXSp7hZOAPsg0PhIojgmiNFapQpsGxb1+VaYGeZNLaFP50/5vSjeqHc2U2jvI03YOyX/Zgnd928gzttjhiCYljBlm3JLU9L4t+/ef2c5mhRk4v4STK1Q3USzssp2BtNAbCeOrcMLZMgUPgpzrO19QwwKSjuUF/fuqhcGyYslzVd/tox37UyJ4tsynYfTP9pXDmj0Mee81Ze8I/7xYA4jUGnX84dPeMDVBUrHv+lvsPLC9XprkyOVjmVTwzS0FK02PHZOOyPl5tfaqyoTuYeOduM17ZgNxsG43n4FtW3kqjuZmk2msQVqPE1oRAEG4e3yrsXEoQaTIBDZOc3js6FJZvzoZ0j5SIS4cmLo9L/OiYBCDMeRBgvSzSTMoyPj1ju23Ql384c0ZBeoA8Sndnl1EA3PJYVjUlZNeExeYF/QmQyu+EJ/GuMyHsNJ086yEhrjTuhxf/yvFGwd2TmtDqFTJer8AZqKjsgE2u5wz8fSEr3h81fKs1/YYoHUmZiCdQVnKdGKh1skV+5ru+gDc3BQIngIBrrVUMfdg8G3qWDSkd84gekuILFKrt5dO+mVaKD8yye4gFFVYmlHViXH++qq1/iuliICAtljWc9qkIvBmHCGXY7kgsDPx/0BF95
 2VBx1TBP
 vztYJIUW0kNkPCWdfvoDWzMdzbrEWR6Y3t7inKu6+JZbkWdUpvf+kyXI5ObnaXIY18tBvj+y8/SmIXgpvsYv0SQPg3tzZymYr4+/p8MPl2Lv1xFfXjlcO6POMmiJXlWnogyxsCLrK/DdR2e8EHOhbRflwKD63Wm8AF9DHq7pl/mnYKM0710C6ZJ6gLB2fNj9Drr3sHwiM1pvvCSoQVIRs1LjovsISkKLczof+5JQ7IZl3qKyYLotzexARGcc0RltcbXUHO5PttVwN2CM40tcLbRd69sHTU6Iqq6kAXoFNzj2V7nHywJYFdVBnAeGNmwFO1ZvdaqxSNm7EbnSGpYW/GtZl1IMqqgUuWpCRHmOTqgM8df6iYv4VMkbPuTRbeBE07zJmsc2E7R/I05QWcv1/0AHMMC5GUf9pqgas
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create Memory Node "types" (SysRAM and Specific Purpose) which can be
set at memory hotplug time.

SysRAM nodes present at __init time are added to the mt_sysram_nodelist
and memory hotplug will decide whether hotplugged nodes will be placed
in mt_sysram_nodelist or mt_spm_nodelist.

SPM nodes are not included in demotion targets.

Setting a node type is permanent and cannot be switched once set, this
prevents type-change race conditions on the global mt_sysram_nodelist.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h | 47 +++++++++++++++++++++++++
 mm/memory-tiers.c            | 66 ++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..59443cbfaec3 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -35,10 +35,44 @@ struct memory_dev_type {
 
 struct access_coordinate;
 
+enum {
+	MT_NODE_TYPE_SYSRAM,
+	MT_NODE_TYPE_SPM
+};
+
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
 extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
+extern nodemask_t mt_sysram_nodelist;
+extern nodemask_t mt_spm_nodelist;
+static inline nodemask_t *mt_sysram_nodemask(void)
+{
+	if (nodes_empty(mt_sysram_nodelist))
+		return NULL;
+	return &mt_sysram_nodelist;
+}
+static inline void mt_nodemask_sysram_mask(nodemask_t *dst, nodemask_t *mask)
+{
+	/* If the sysram filter isn't available, this allows all */
+	if (nodes_empty(mt_sysram_nodelist)) {
+		nodes_or(*dst, *mask, NODE_MASK_NONE);
+		return;
+	}
+	nodes_and(*dst, *mask, mt_sysram_nodelist);
+}
+static inline bool mt_node_is_sysram(int nid)
+{
+	/* if sysram filter isn't setup, this allows all */
+	return nodes_empty(mt_sysram_nodelist) ||
+	       node_isset(nid, mt_sysram_nodelist);
+}
+static inline bool mt_node_allowed(int nid, gfp_t gfp_mask)
+{
+	if (gfp_mask & __GFP_SPM_NODE)
+		return true;
+	return mt_node_is_sysram(nid);
+}
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
@@ -73,11 +107,19 @@ static inline bool node_is_toptier(int node)
 }
 #endif
 
+int mt_set_node_type(int node, int type);
+
 #else
 
 #define numa_demotion_enabled	false
 #define default_dram_type	NULL
 #define default_dram_nodes	NODE_MASK_NONE
+#define mt_sysram_nodelist	NODE_MASK_NONE
+#define mt_spm_nodelist		NODE_MASK_NONE
+static inline nodemask_t *mt_sysram_nodemask(void) { return NULL; }
+static inline void mt_nodemask_sysram_mask(nodemask_t *dst, nodemask_t *mask) {}
+static inline bool mt_node_is_sysram(int nid) { return true; }
+static inline bool mt_node_allowed(int nid, gfp_t gfp_mask) { return true; }
 /*
  * CONFIG_NUMA implementation returns non NULL error.
  */
@@ -151,5 +193,10 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+int mt_set_node_type(int node, int type)
+{
+	return 0;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0ea5c13f10a2..dd6cfaa4c667 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -44,7 +44,15 @@ static LIST_HEAD(memory_tiers);
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
-nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
+
+/* default_dram_nodes is the list of nodes with both CPUs and RAM */
+nodemask_t default_dram_nodes = NODE_MASK_NONE;
+
+/* mt_sysram_nodelist is the list of nodes with SysramRAM */
+nodemask_t mt_sysram_nodelist = NODE_MASK_NONE;
+
+/* mt_spm_nodelist is the list of nodes with Specific Purpose Memory */
+nodemask_t mt_spm_nodelist = NODE_MASK_NONE;
 
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
@@ -427,6 +435,14 @@ static void establish_demotion_targets(void)
 	disable_all_demotion_targets();
 
 	for_each_node_state(node, N_MEMORY) {
+		/*
+		 * If this is not a sysram node, direct-demotion is not allowed
+		 * and must be managed by special logic that understands the
+		 * memory features of that particular node.
+		 */
+		if (!node_isset(node, mt_sysram_nodelist))
+			continue;
+
 		best_distance = -1;
 		nd = &node_demotion[node];
 
@@ -457,7 +473,8 @@ static void establish_demotion_targets(void)
 				break;
 
 			distance = node_distance(node, target);
-			if (distance == best_distance || best_distance == -1) {
+			if ((distance == best_distance || best_distance == -1) &&
+			    node_isset(target, mt_sysram_nodelist)) {
 				best_distance = distance;
 				node_set(target, nd->preferred);
 			} else {
@@ -689,6 +706,48 @@ void mt_put_memory_types(struct list_head *memory_types)
 }
 EXPORT_SYMBOL_GPL(mt_put_memory_types);
 
+/**
+ * mt_set_node_type() - Set a NUMA Node's Memory type.
+ * @node: The node type to set
+ * @type: The type to set
+ *
+ * This is a one-way setting, once a type is assigned it cannot be cleared
+ * without resetting the system.  This is to avoid race conditions associated
+ * with moving nodes from one type to another during memory hotplug.
+ *
+ * Once a node is added as a SysRAM node, it will be used by default in
+ * the page allocator as a valid target when the calling does not provide
+ * a node or nodemask.  This is safe as the page allocator iterates through
+ * zones and uses this nodemask to filter zones - if a node is present but
+ * has no zones the node is ignored.
+ *
+ * Return: 0 if the node type is set successfully (or it's already set)
+ *         -EBUSY if the node has a different type already
+ *         -ENODEV if the type is invalid
+ */
+int mt_set_node_type(int node, int type)
+{
+	int err;
+
+	mutex_lock(&memory_tier_lock);
+	if (type == MT_NODE_TYPE_SYSRAM)
+		err = node_isset(node, mt_spm_nodelist) ? -EBUSY : 0;
+	else if (type == MT_NODE_TYPE_SPM)
+		err = node_isset(node, mt_sysram_nodelist) ? -EBUSY : 0;
+	if (err)
+		goto out;
+
+	if (type == MT_NODE_TYPE_SYSRAM)
+		node_set(node, mt_sysram_nodelist);
+	else if (type == MT_NODE_TYPE_SPM)
+		node_set(node, mt_spm_nodelist);
+	else
+		err = -ENODEV;
+out:
+	mutex_unlock(&memory_tier_lock);
+	return err;
+}
+
 /*
  * This is invoked via `late_initcall()` to initialize memory tiers for
  * memory nodes, both with and without CPUs. After the initialization of
@@ -922,6 +981,9 @@ static int __init memory_tier_init(void)
 	nodes_and(default_dram_nodes, node_states[N_MEMORY],
 		  node_states[N_CPU]);
 
+	/* Record all nodes with non-hotplugged memory as default SYSRAM nodes */
+	mt_sysram_nodelist = node_states[N_MEMORY];
+
 	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
 }
-- 
2.51.1


