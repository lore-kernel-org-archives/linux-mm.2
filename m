Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D398C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C1E6B00A3; Thu, 27 Aug 2026 12:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FD36B00AB; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B875E6B00A3; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 553FB6B00A6
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA9E114011D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.19.C2C24A2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf31.hostedemail.com (Postfix) with ESMTP id B12AB20009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GA3eVHRa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847883;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssuN6l1WxJ9Y104+n1a6EbIEvAWDLhzTTWp5ogAfBY4=;
	b=OYXUmzCExfb7YuBuJ9FLtTPanUm0/ETC/PxkLBc8vINQqwCdKNwDYfQsIbbY7zbjIAjP7L
	iYJtlyMxXTHkDJBdiHZDU0nk6fw3918NLhckzqaIB2Fve8zBoZKJZUo9PJ+D7iHxrJTOuY
	ezRx7iUp7Zhuw2Tw/yFYeHUH/SAMDic=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GA3eVHRa;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847883;
	b=OS0vepYY25457KlPFhaEHIuLhXL6v0iOaqlhT75MHAVqizvhkLxdW5XlT+ZTeB2i7u3p6b
	q5DSobSSE2hhAI2qhs0Gcb6XZPhGnLcen7Xv/R0X96VGnNHJkFaYc29v+0WseIddwRJlBG
	ZDqqhVuqCglw7ll1U/Wc+ev90yfycAI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ssuN6l1WxJ9Y104+n1a6EbIEvAWDLhzTTWp5ogAfBY4=;
	b=GA3eVHRaMB1sUAyee8x3oE8sFFq55hRTx1otDxbGFRORJ9LQh//eL8/dJQ9ws45KU0NRVm5kY
	3FRlm4C7LukM49ewJKJsxRUAo2VZJ4zTkmIvYphhh9aAJ5aukhsEoh+2QWgz6ozklCrbDu7Uyg3
	MMAYPYoCnAbFVUKjN1E/fHs=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KX6CxPzJ46ZW;
	Fri, 28 Aug 2026 00:24:16 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AA4840570;
	Fri, 28 Aug 2026 00:24:38 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:38 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 18/18] mm: introduce kernel cmdline option "kernel_replication="
Date: Fri, 28 Aug 2026 00:11:58 +0800
Message-ID: <20260827161158.3618409-19-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Stat-Signature: jg514rkrfr47bmzkkxgmek4j1ehe9p44
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B12AB20009
X-Rspam-User: 
X-HE-Tag: 1787847883-670188
X-HE-Meta: U2FsdGVkX1+WYlbzChEEBHNN/qfioAYROcCdTBCn4VsQSZIgIBzQWgrLRJwLua+3sX8UBhR/iATFn/igi+ibiIQX3ZK4SfzOxGjvaFBXcWg5dUigVp6oRMI+0LUqsQbMa8WkK9YWGIehFgLf2/6orEyXIWboKBvB5tsRaUspn2G0zJYjUPFGJIdhX0TgwkV9wikBn7AtE4JMfFHrAl3YKco7xVjdx00JjKF5h/tSf5ADpHjzeOYkH7KZKt8XJYJp2dgh7fd9VjDfV+gQcQlTCz9XmlLzvaBiCCzZqsZ9ItsbtuBSGZRxIqNStVW3eBGdiJ//Pddud8vRH4D/7hQZhpsUKZmp1BJr7eUfVdN3oh5qZQN5HyoTI14sQ4kNSxiZblKSbTLI3gvRsEZDfkHJ8jQOIev/o58DL0v+ABuhj0aJUFRqfWvTj4FA3tbAelqyr2ikoX+e+OwKdmQCKZxgRdBR0I97mbi38ioiEMtdi7d5/JrkC6HUmBF1r7onS2WmDVOL/SoNsexKnaclXhOnKQ1Cf0GrHjtPleriWs3mbfDEKDDJ+WNbCgddXDAmuXSMSg32bXg3eidlXIjKi6V3+FyAp0k8g+P5lQ7B4/nE+IoALuUkJXKBlgGrV153k5AcTe/GOw7WsYDySBFTYeGjPTlQAyoSGnPD5wKWAZXI1mCMOT5TvhUL/IYwgK+IhjDawL/0UP4Boe6Y8m8HKSqX7ZXJjRIMegXj8oaDCPTvIM9KuXnzpUXOB/th7h4/5+AUZmt2DJoH2zFStuuJ6EVoU0Kj5vySh9TbFI3TLkw4ucGTWzeMbeXIsX7XsJUNNkAP37RDfmab98lC6e3hUW4Cna8c9AsmhLs4I0bFRaV38lOargQRyFREiUgo2uj5aPP1AYW8I8bdRBUjle+f9zJBV6hyTB20k44NOqUARWMhYXmfeq1Q6Nq2/411jq2r0qOgfGdCDBdULANvy9NB7HW
 RZ1ZmZsw
 9OoYB212i3WuFRnQLeFRY+AK8UtcKJELmQNJznbQB46CTSmeRO72LDSucGr5aB4XqkZ2tDdLKhhb4j9/8TnjklUMf88Q0WM0lbj52uaaZoz7W6GNe/EAf8EUrAN7ZGCT36iiuN2al2IKKYbFLyeaNw769DVB9/Cjsuqq0g6FxN1xYAVO8udnur8kear/bn6S2gYbn8ew2YMqAHzOQw/h0gYoICT/bAQF8gfRTIFnOnnHOfDCK76rZtcXfUjEE5ji1yzQk7dATNb8uesjJ4Bpt2fvj9zOOo/awSfuyDjRmERkz5GzTIgN6QmMilGpciuBsgKPxfilzDf0y+uUyvgk76GPXtZGIJjSo+wJsKk2Og1ijk/46P/f//SD4hYKVo8+onoswEwy66ZlTD6caC2klJY3Z6F4mWrhylrkHMcKJ0qaOfNl5u3psMqLBlZItAw/Q4hNFQnU9b7rTTJ5bCqJRGX637N0kuk043FL4BwZ8neQVvr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new cmdline option allows enabling/disabling
kernel replication feature.
By default, the replication feature is disabled.
This allows to set CONFIG_KERNEL_REPLICATION=y by default,
but enabling this feature is done via kernel cmdline.

Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 ++
 include/linux/numa_kernel_replication.h       | 27 ++++++-
 kernel/module/main.c                          |  3 +
 mm/numa_kernel_replication.c                  | 78 ++++++++++++++++++-
 mm/vmalloc.c                                  |  2 +-
 5 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index d55524e3b724..133afdd7dab5 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3039,6 +3039,13 @@ Kernel parameters
 			for Movable pages.  "nn[KMGTPE]", "nn%", and "mirror"
 			are exclusive, so you cannot specify multiple forms.
 
+	kernel_replication=
+			[ARM64]
+			Format: [on|off]
+			If CONFIG_KERNEL_REPLICATION is set, it allows
+			enabling/disabling the kernel replication feature
+			via cmdline. Default value is off.
+
 	kfence.burst=	[MM,KFENCE] The number of additional successive
 			allocations to be attempted through KFENCE for each
 			sample interval.
diff --git a/include/linux/numa_kernel_replication.h b/include/linux/numa_kernel_replication.h
index 34aa063d42e6..23069ca82fa8 100644
--- a/include/linux/numa_kernel_replication.h
+++ b/include/linux/numa_kernel_replication.h
@@ -18,8 +18,31 @@ extern nodemask_t replica_nodes;
 	     nid != MAX_NUMNODES;			\
 	     nid = next_node(nid, replica_nodes))
 
-#define this_node_pgd(mm) ((mm)->pgd_numa[numa_node_id()])
-#define per_node_pgd(mm, nid) ((mm)->pgd_numa[nid])
+bool is_text_replicated(void);
+
+static inline pgd_t *this_node_pgd(struct mm_struct *mm)
+{
+	if (is_text_replicated())
+		return mm->pgd_numa[numa_node_id()];
+	else
+		return mm->pgd;
+}
+
+static inline pgd_t *per_node_pgd(struct mm_struct *mm, int nid)
+{
+	if (is_text_replicated())
+		return mm->pgd_numa[nid];
+	else
+		return mm->pgd;
+}
+
+static inline pgd_t **per_node_pgd_ptr(struct mm_struct *mm, int nid)
+{
+	if (is_text_replicated())
+		return &mm->pgd_numa[nid];
+	else
+		return &mm->pgd;
+}
 
 static inline bool numa_addr_has_replica(const void *addr)
 {
diff --git a/kernel/module/main.c b/kernel/module/main.c
index d5c8f041be48..25c8816588ce 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1346,6 +1346,9 @@ static void module_replicate_sections(struct module *mod)
 {
 	int i;
 
+	if (!is_text_replicated())
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(sections_to_replicate); i++)
 		module_replicate(mod->mem[sections_to_replicate[i]].base);
 }
diff --git a/mm/numa_kernel_replication.c b/mm/numa_kernel_replication.c
index b1c5cd2a1fa1..c8c3424fa20c 100644
--- a/mm/numa_kernel_replication.c
+++ b/mm/numa_kernel_replication.c
@@ -64,6 +64,8 @@ static unsigned int master_node = INT_MAX;
  */
 static int node_to_memory_node[MAX_NUMNODES];
 
+static bool kernel_replication_enabled;
+
 static bool pgtables_extra;
 static DEFINE_SPINLOCK(debugfs_lock);
 
@@ -253,6 +255,9 @@ static void dump_pgtables(struct mm_struct *mm,
 	start = start & PAGE_MASK;
 	end = (end & PAGE_MASK) - 1 + PAGE_SIZE;
 
+	if (!mm->pgd_numa)
+		return;
+
 	replication_log(data,
 			"----PER-NUMA NODE KERNEL REPLICATION ENABLED----\n");
 
@@ -619,6 +624,18 @@ static void replicate_pgtables(void)
 	}
 }
 
+static void __init numa_replicate_kernel_text_disabled(void)
+{
+	int nid;
+
+	init_mm.pgd_numa = (pgd_t **)kmalloc(sizeof(pgd_t *) * MAX_NUMNODES, GFP_PGTABLE_KERNEL);
+	BUG_ON(!init_mm.pgd_numa);
+	for_each_online_node(nid) {
+		init_mm.pgd_numa[nid] = init_mm.pgd;
+	}
+}
+
+
 /*
  * Kernel text replication includes two steps:
  * 1. page tables replication for init_mm
@@ -636,6 +653,11 @@ void __init numa_replicate_kernel_text(void)
 {
 	int nid;
 
+	if (!kernel_replication_enabled) {
+		numa_replicate_kernel_text_disabled();
+		return;
+	}
+
 	replicate_pgtables();
 
 	for_each_memory_node(nid) {
@@ -653,6 +675,10 @@ void numa_replicate_kernel_rodata(void)
 {
 	int nid;
 
+	if (!kernel_replication_enabled) {
+		return;
+	}
+
 	for_each_memory_node(nid) {
 		if (nid == master_node)
 			continue;
@@ -664,7 +690,7 @@ void numa_replicate_kernel_rodata(void)
 
 void numa_setup_pgd(void)
 {
-	numa_load_replicated_pgd(init_mm.pgd_numa[numa_node_id()]);
+	numa_load_replicated_pgd(this_node_pgd(&init_mm));
 }
 
 void __init_or_module *numa_get_replica(void *vaddr, int nid)
@@ -679,8 +705,48 @@ void __init_or_module *numa_get_replica(void *vaddr, int nid)
 	return node_desc[nid].text_vaddr + offset;
 }
 
+static int __init setup_kernel_replication(char *str)
+{
+	int ret = 0;
+
+	if (!str)
+		goto out;
+	if (!strcmp(str, "on")) {
+		kernel_replication_enabled = true;
+		pr_info("Kernel replication enabled via cmdline\n");
+		ret = 1;
+	} else if (!strcmp(str, "off")) {
+		kernel_replication_enabled = false;
+		pr_info("Kernel replication disabled via cmdline\n");
+		ret = 1;
+	}
+out:
+	if (!ret)
+		pr_warn("kernel_replication= cannot parse, ignored\n");
+	return ret;
+}
+__setup("kernel_replication=", setup_kernel_replication);
+
+
 nodemask_t __ro_after_init replica_nodes = { { [0] = 1UL } };
 
+/*
+ * Let us pretend, that we have only single node fore replicas.
+ * Do not replicate anything.
+ */
+static void __init numa_replication_init_disabled(void)
+{
+	int nid;
+
+	__node_set(0, &replica_nodes);
+	for_each_online_node(nid) {
+		node_to_memory_node[nid] = 0;
+	}
+
+	node_desc[0].text_vaddr = lm_alias((void *)KERNEL_TEXT_START);
+	node_desc[0].rodata_vaddr = lm_alias((void *)KERNEL_RODATA_START);
+}
+
 void __init numa_replication_init(void)
 {
 	int nid;
@@ -693,6 +759,16 @@ void __init numa_replication_init(void)
 #endif
 	nodes_clear(replica_nodes);
 
+	if (kernel_replication_enabled)
+		pr_info("WARNING! WARNING! WARNING! Kernel replication enabled WARNING! WARNING! WARNING!\n");
+	else
+		pr_info("Kernel replication disabled\n");
+
+	if (!kernel_replication_enabled) {
+		numa_replication_init_disabled();
+		return;
+	}
+
 	for_each_node_state(nid, N_MEMORY) {
 		__node_set(nid, &replica_nodes);
 	}
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index da6facf64db8..532298ab4263 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4422,7 +4422,7 @@ int __vmalloc_node_replicate_range(const void *addr, gfp_t gfp_mask,
 		for (i = 0; i < area->nr_pages; i++)
 			list_add(&pages[i]->lru, &area->pages[i]->lru);
 
-		__vunmap_range_noflush_pgd(init_mm.pgd_numa[node],
+		__vunmap_range_noflush_pgd(per_node_pgd(&init_mm, node),
 					 area_start, area_end);
 
 		/*
-- 
2.34.1


