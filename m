Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E69CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B918E0024; Fri,  7 Nov 2025 17:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBC98E0006; Fri,  7 Nov 2025 17:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F298E0024; Fri,  7 Nov 2025 17:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 802E98E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12F6916061C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:12 +0000 (UTC)
X-FDA: 84085305864.30.841765C
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 679D0A000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rKZHjo73;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ia+a6MlTeonyCm8y2ltZ2UGJPZEO4eqXV9rDHC4VPW4=;
	b=wUss95pLJ+sJLMgJvIpeoibqAPZVVL+ryPEkicrm4BoxADiLy4RyeOuEoEKTsXAaKL/uR4
	JkPv4Bp89WaLYrHln1DeSC6bdv0fZWemVQ2SiQGJKe+Q33JYFCV/DzZu/a5SsKKP9NB1Ld
	mf3I1hok+/KzoKmQgNEkdDWcPK8/xyc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rKZHjo73;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555810; a=rsa-sha256;
	cv=none;
	b=mN1ms7iO+a035/75htY46+rEb3lx3EprbPPNgn2xExE0daxgUDmMhq2kHYSPxTMvAG3eKm
	ODysuTjXxacwzU6vA7PEAX/NcVt/+EPXqFmM+rBFgtlowGczvMNl7yh/Q7376rXeuYH22H
	xT0D5tZ4K3LB1jmUUqETHre90HfD51M=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed7a7ddc27so11641751cf.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555809; x=1763160609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ia+a6MlTeonyCm8y2ltZ2UGJPZEO4eqXV9rDHC4VPW4=;
        b=rKZHjo738J4krpF70mclFYvgI4s0rHfA5gF7mvIlncn7H7DqYFr/6Mw7I7U+DEmpX7
         DtQPhRqyLsnWtIDnHgA5zm5HkvVvYCSxw59aB/IltrmeGB4hAkNALZNO/LFCGUKupB6T
         bUEXKvakvKBckBQEgcowRROvWLOYLLeT7fv+CiLLJi563PSuXzPC7fOSZ6GJ9QmrPu3N
         AgPTzNdUcfp3DFK1uJRt+XKl7+sIJ32cSxmLfN3JbLASVQ09b4FpmhikZ4jc2J11GQmK
         6hIIYjEKJv8TQit3bjrSQ4iZxkcbeuaey0PP5ZZJ4vmyo9KNVO995UV4PczRfI15FkPI
         8LxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555809; x=1763160609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ia+a6MlTeonyCm8y2ltZ2UGJPZEO4eqXV9rDHC4VPW4=;
        b=wZGqrXKHGVUviHf628OlGVkENi4sAliN/I6+NEoj1WUX+JNjwxilBtXzBMKGS5s+UR
         3buMpe3n4pK2Av6dwjSwW8iFWWlG6qJmCW/Mdf9cWEdg49Eb3lFufbucMHLRhLdiex6I
         Fc3kWD1Q1jqnzF6aoZnR0ZPEVAp0RHP2hczGwpvGbKcapxb9RjUEH6H1PPfRmm0hpP5R
         PWmR/cAlzuEEFjGfbicuVLRtBQtTjHZrbhtyATA0EvUEIE3ljkyX3nTOA7ieanMjC3qY
         w+GlUtLJKUc4vZPBp47gXZrq5dhSCfcMn/mbxTE0LZdmVsPuqzb9dVOfQtxiR76wyk6A
         CvxA==
X-Gm-Message-State: AOJu0Yx7w4dXBQUhp7o0bD7TjeZfdtItifDBxHhUSElqu1ka6UwU1t6x
	3hvrzbcM5mwMhg50BtMs9KOEQFNrX4oDPsnlnl7uYw0Kwx5tlkyWTMoLdF++1OCSs9xSWfo8b3/
	UTnhl
X-Gm-Gg: ASbGncu54tKw9iLdYn+JIKq6HBwTE6pD5XmKej2nPhClbZxJJvo3un2qunbu9jHm7ZC
	jjIpLDx1Boovkj5BkY/EBSX7heFQbobugINI497asywFLSFvp7KcwAojvvGKJDt+PrjlSfAJdOx
	gTVNA0kL8FWh2puCZLw69yU3TsNvPaeYwQp0Qn7/dzZwEJtVwEKXLAOWIj8OkSxbyizcjaf59vH
	JTgFJxf4A0Ls/qQnDUtuLJLtlxLV729vIBZSimm8SemBah9SBpfKxiTdlwEQ7Y9+uA5n0ZuJQ/5
	nCds79j6Ux8Qo7wGm3WeaVll8fs5lSrBUFhxwCu64IBvmL2RrrujsLfCG3t9C8oenIMiP5WftaC
	CDR3zz1ExZNZtMbEkR9tpLlXxyZnQw5BcTnky7xJrUC4sKeZZoM/JWJISsCKm8z0u2/xfAegvtD
	huQf3HuVJQR7TxDNfdnqOZ+E5bZm6UY5miwTQZWVkZjMErjYQ3FpwaPzMnwGYNxc0a
X-Google-Smtp-Source: AGHT+IH86NSTDKP1XdsF31RYjR4tNihgD5BPq31D5+FTd6nH/ZnI3iDuVFCi3Tc0xbHdRJTu/D2ZGw==
X-Received: by 2002:ac8:7d49:0:b0:4ed:6139:8ea1 with SMTP id d75a77b69052e-4eda4e734a8mr9627481cf.10.1762555809152;
        Fri, 07 Nov 2025 14:50:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:08 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH 2/9] memory-tiers: create default_sysram_nodes
Date: Fri,  7 Nov 2025 17:49:47 -0500
Message-ID: <20251107224956.477056-3-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 679D0A000B
X-Stat-Signature: zrx84s5ox4yr4pho1ugepmxzy6ja8dec
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762555810-351527
X-HE-Meta: U2FsdGVkX19vTjIRUI420MXqpcXTmAc1Acc9fNf5fMo1HKCyn24Lu9eWNprpXBlyk6DnfqWDHelhEmL1SaUF0AwqSr5fUQqElTUt9Xzwru8BveRVfo6Wc1wFusvlIgVuoCQdywFMsE4coVJjzYKIBruVA1+gs6KvoDkTBF22Zc+9Ygt8Lph5pOQLj75V3gVJWBdlXvpsha0jqyaJRMOUbIUPppXAwmDOnlW0NceMM127vPTr56iVNoC31HtgXnFJMuWjxzHGcxb0zziNG9oDGCFFOYrSDbFUCn3+v1huRW2ZjGaEvy9woP7QDgGreRla/eJbCsq+EpCynBsbx14jSUaMs93L6EgJBAZ8XesM2bhLfX+PrwBgLexMaHp6yZi8O9wzxILOqO1N7WL44WKCe0E+OYzc7Uaz+gmO9wd122TpGROl0cuvcMBQIevXM2t9WjcO+sJu1qKTsnU4WMvYkxRlc3OAMfOkzFqIH8EBMx+L3zMXB31mHE5N2sr/kb2OisingUCr/ghMjt7fkpxQIunugJjemCExfN2TlCSZR2TjDv8QERAzu3nHUo3TQNJKuhna5nCIaX/LYkONO887hwHonT9ldW3MQezwEpV8HHs5VXUSGw+02gJfYwGFrFCVLQOzb7WTXnTrfYdCvA6O+f3ufYjfPX2C08xRqPQydR32AUJRCYucGEazoJLfrWkyI2gMQWs82GuwivJDLUFqEqzjuFJglJmXaExub+Neq655c4dNxw7Hg5W+xqxPIVCaSqi9RLrmD4uk1hcdashHiR06igfH7737+YlVjWpuKlZeQl+YUkq957dvsgwkCUpL0laMLAfLe9GBix5h9efZsRqJtWdS78ByD7li3YfEdKMBRhbPc9mcpv6zg+Opsnqh/NtfeYJaxh85foFLD5AmsVl9eAefxGOY2q7+CT2VpVlyfB6+dZZDYBiCZKRkjZaRcRD1VTODcZsOdveC6sV
 0tApc2Cm
 arlCDFI+FfAGbyhIzSp+cMwIH+NcXJMTu1faucLbl2x/hPVv87u77qzxPj2uRdQ2RK9LlStU+7XsmAvqP+NejQf92qjsK/vSqWqATZMGfm/llgnCT4xjJ6j0+38vuTsi05ZC/wjqPXxAuo1+lTwv26XxTJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Record the set of memory nodes present at __init time, so that hotplug
memory nodes can choose whether to expose themselves to the page
allocator at hotplug time.

Do not included non-sysram nodes in demotion targets.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory-tiers.h |  3 +++
 mm/memory-tiers.c            | 22 ++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7a805796fcfd..3d3f3687d134 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -39,6 +39,9 @@ struct access_coordinate;
 extern bool numa_demotion_enabled;
 extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
+extern nodemask_t default_sysram_nodelist;
+#define default_sysram_nodes (nodes_empty(default_sysram_nodelist) ? NULL : \
+			      &default_sysram_nodelist)
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 0ea5c13f10a2..b2ee4f73ad54 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -44,7 +44,12 @@ static LIST_HEAD(memory_tiers);
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
-nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
+
+/* default_dram_nodes is the list of nodes with both CPUs and RAM */
+nodemask_t default_dram_nodes = NODE_MASK_NONE;
+
+/* default_sysram_nodelist is the list of nodes with RAM at __init time */
+nodemask_t default_sysram_nodelist = NODE_MASK_NONE;
 
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
@@ -427,6 +432,14 @@ static void establish_demotion_targets(void)
 	disable_all_demotion_targets();
 
 	for_each_node_state(node, N_MEMORY) {
+		/*
+		 * If this is not a sysram node, direct-demotion is not allowed
+		 * and must be managed by special logic that understands the
+		 * memory features of that particular node.
+		 */
+		if (!node_isset(node, default_sysram_nodelist))
+			continue;
+
 		best_distance = -1;
 		nd = &node_demotion[node];
 
@@ -457,7 +470,8 @@ static void establish_demotion_targets(void)
 				break;
 
 			distance = node_distance(node, target);
-			if (distance == best_distance || best_distance == -1) {
+			if ((distance == best_distance || best_distance == -1) &&
+			    node_isset(target, default_sysram_nodelist)) {
 				best_distance = distance;
 				node_set(target, nd->preferred);
 			} else {
@@ -812,6 +826,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 }
 EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
 
+
 /**
  * register_mt_adistance_algorithm() - Register memory tiering abstract distance algorithm
  * @nb: The notifier block which describe the algorithm
@@ -922,6 +937,9 @@ static int __init memory_tier_init(void)
 	nodes_and(default_dram_nodes, node_states[N_MEMORY],
 		  node_states[N_CPU]);
 
+	/* Record all nodes with non-hotplugged memory as default SYSRAM nodes */
+	default_sysram_nodelist = node_states[N_MEMORY];
+
 	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
 }
-- 
2.51.1


