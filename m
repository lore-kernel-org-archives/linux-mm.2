Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D96D1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0E16B0089; Thu,  8 Jan 2026 15:38:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B316B0092; Thu,  8 Jan 2026 15:38:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5437D6B0093; Thu,  8 Jan 2026 15:38:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 416AD6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:38:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B84531A0157
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:43 +0000 (UTC)
X-FDA: 84309960126.29.B9119D4
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB377100003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dPmqEr9K;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904722; a=rsa-sha256;
	cv=none;
	b=7riDJMD2E2BpZy76yirE9nhiM64nd2XvmXW+ZGeF6tIdmOCBkWpU9DHtGoIA4NzP+PKuTn
	taRyCTPdfIR0mP1CmWrhERluTcVRDMyE7VYFveU8V6Y0xcj2yRTtPTmOm/MILjSS/ImmhE
	uBQdKYflGVynGygZnelZd3iOiU8Lyac=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dPmqEr9K;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOrL3864bJGfwtl8UioEmR5rhRGdyu2H2uXt3HWEC2Y=;
	b=JzylnKI2aeiCKQe/pAemhAaYB290t+iLCIVvgu6vpKnq8WBZxRFJOpIKWGKuC29UxzUt6a
	s2m0O8qQ0zLmIpOAUHMC9q987lo26MuvEMbwm7So26IJSfRXC6okwMUIOXsLhzgQaW+Xit
	g4DUJIyHfa6wIfjyAm1pK7RKvzDCL+g=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8bc53dae8c2so496705285a.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904721; x=1768509521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yOrL3864bJGfwtl8UioEmR5rhRGdyu2H2uXt3HWEC2Y=;
        b=dPmqEr9KvkBteavGjnseNXL+3D1N9isXbWucPdiNLOBJEhp6fQNOcLdWKC+e1rLAHO
         zH0Lo9aH9xfToGSdOrHvHouWsGuVB5DjbuW+BxdbgAJoXpduva7YmHU07rXu1G6kecgG
         V1Gg4Idgk+R8zsMDDWCb+wxdw2DLgE/sc9mC2NT1jdoBY0N8GRlV2t5fopHoUyQR2u0K
         tlZATzuYOkuaTnnbCnUHoI/ulm8FKBULHPRFWwbRxzECyGaHj+uIatHmc5cJZ2I4r5Uv
         MmQWAv7a9vRBi7Zz2Wbz7bTlTb7ukMq9mhxU+m/aYeixBFfkAYnXyfG49vC0nADThfqj
         u1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904721; x=1768509521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yOrL3864bJGfwtl8UioEmR5rhRGdyu2H2uXt3HWEC2Y=;
        b=nnDS5MbRiolTFPk532q5uPc7EfyZqO41ciAFlSorUGyE4X/g0uY+rfjQDJRuyRl+HK
         nWviFeeMf7MI2V4Jo3BR9Emfk7vi56tBK2g/vRchRAtmiXdSDM4uX2JQr6YPidCWzz7X
         P+tl2J+4XGW00VVuDJA3vvEJpwGz98Zuh5HXkz/Fwpa+9f0t5lpMhjDs42gq1PcrYFwj
         YsHyPMfZ2kg31bPXSklI9Jf3QVhZwtn5GRYPqigoyaDAZBI0O/E+P8jpVHVl6Sg3LHAh
         Vh8Qkkzhqi69FRMW92kz5RChPMPo7uUMSBxZw3eiua2YAiq5B4bDBYOfhbjeekVwdWZ9
         Wtcw==
X-Gm-Message-State: AOJu0YxZbaJMvVKuz/nnijHpfLtrJWlB/goJxEK6HqsvcbvBPyH2A2/D
	QQMONABBcIvQjXm/aBCjF0dIZJHgaeC56kfZaPJkkKjb6EvBJE0b9lJQe373Ur7Y+IuxFyLIUkf
	YjRgE
X-Gm-Gg: AY/fxX4vEUWv5k/bXtssi0Oz8uh331HC+21vAklyTuwnvor3Fxhqqi/HLvhowcRiGtI
	/XjkddFXEvL5+z5US8zneH8K3xHK/6E6JLP0XlcOWm5zREi/YciqlXhm4qKcv23WQ82QnFWiCh1
	hfVYlq7hicGOUjQEylFhMILDSSJnBb5r6na6bfd1CwOrr2sZ0Gh1Zyjyet6Ofc0/HWl4Qldqqzy
	RQeJbe6YnVa3+Y2MkggWi1dW2o3irPAF2rfAet9DelZWdA0lBKRmd4t1c7Qe5bKArsT8G5DEXhr
	UMeWXNXTls/jl6FuJJge39JO54RaZU4xsoDa4BUqeO69Bh/gnNSwdpguz4hgRATced7W6TUDThU
	Pd61H91GPEn/L5tEFF3Nl8YLTnBesaQL1JnMn3ztW+oNDxzmkgjGP0liQwVwwAbU7FrOJBa8Ife
	Tk5Blm2l6Uou789Sdb6s3Yf0kOZ2ezZz1kt9h5n9Dla4M/g6D9zXp68sdS6dYPRxJF9V4OGnRfv
	20=
X-Google-Smtp-Source: AGHT+IErusoCASFUMJ5xblQXCL2hFphAjRCx8AogbVf/OleyczW51nyjXSqkJjk86aDTspqXYukd7w==
X-Received: by 2002:a05:620a:6ccd:b0:8b2:e17a:37 with SMTP id af79cd13be357-8c3893f239bmr1013342785a.43.1767904720528;
        Thu, 08 Jan 2026 12:38:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:38:40 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
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
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com,
	Balbir Singh <bsingharora@gmail.com>
Subject: [RFC PATCH v3 1/8] numa,memory_hotplug: create N_PRIVATE (Private Nodes)
Date: Thu,  8 Jan 2026 15:37:48 -0500
Message-ID: <20260108203755.1163107-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB377100003
X-Stat-Signature: 5xf4ayewqo45rst8kptr6sdmxkzb33h8
X-Rspam-User: 
X-HE-Tag: 1767904721-673359
X-HE-Meta: U2FsdGVkX1+wUUHHTRqObC5nqDti58EwqZGS7heNyNzEUy3h+inmKHms6DR8IaPRxtzWQJ3SDm9kFRn/JxIh8ooOPNelA0Atse1tVoEO6W2OpwrDhTpdtUAKF+lTz8qlysJZ76i7Pf8wwGNPyZCnTqoTjj/wwgdD/ZxhG+aq22FtAnfKr8Lsr5GzaR7bLoTYlQy4y8Ho7/C/GmbA0aU5zLi1jPZqYeO/d3yLC3QPxOv+0W7vHCl6UDoOs54F0Fbr5I6UMSLFW9guI0ocLhxMtNG/HA8sjZMDioSOuQmW586R4pmXyCOFk3P0nVTpSHZgmAPSu1bQgoZJcVGpiARgA0JpHHu4CErPOw1O3+RSqrN2UeowBq+OI50LiELBmqPKeYTWiWdlLn0AnyrXuXwxll0ATAyx2ae8XbBCIX0QQcw3ffLCZlD9JBNHpM9sAAEwJh5SI79H9mxMLYt8LsdGfAEg0AMy67zcxo014jggl+CqK6K6btvk8OeCLfCDO9rZtlPU4xDAmgASzzVbrMk9p6Z1+BX9HqVtYNZyIy4IixiKpGR4fw7gZkiV/T4G/dwhuZx/ULcI1pf4QrcneWvXxcVPeXkOZkdM6W3AFSkw5RWuvUbUgsRPvkzYU6Ba8y/KND12a0FtzzvOHcFpOHEqSQaIN0SsIB5kg0HtTp2LV+C8W/Rt/Pin3BINfLPXN7SfvfHdmzS+Dht5etZ5+PlStlnn3Uj26ruWmuhjT+30fZLrOk7/5haioAntgf3Pd85tJhjHKssM4qYFJGGr2E4UDHAb60efGbgr2V1jEqWMpbb4j7TNB8s2UBbZHvUmtXEbuciYvZPql1qChij3AuPrRFL/W8nGuSoSD3gDuEa6KuglpiIr6acQ9vQLxiqnLLkVMoVydyoY4MU9ocE+YbEtK28yWHWl1UcV7HDjXlBkLP4tEhbu8pT5bhHvW4wUh4/b4HmQrivlBr9hCjhBJk1
 npc4fyoi
 x+8euAkChSUXhi6k1XilukfikFRYxkyEESGIXRE4bPdqbg3vBfou8DSqHIxJfEh2o0OAYlST4wc94dHxudo7czz/J0vzLHreE2Js/RvPAb2mgcN94EAiwIKnerNFTXRDA0w5wR7vapwSdmOtENZ5p9GO/sSbwOuH2XezNeqZXmdiz/GqWn1WkzcpCnE2K2XGUVltDQosdNYfJZlFSNLXrnNOmDfNb5QOTfueTiY8U3y6kriFwnq7m1esFuG/e5+heuiOXK7BCX+J0JLdnrlSayUZvlgs0Sxo7aDtEivO6befkPCC5ptKL002mrHeTmfOq74BAJ2m01OX4QrzQcTv66c8Zl5kWLkKSyB0vLatlHm2Utzyd3RBBJValH/a4tGbiQRcEMcC4LSoJjrUUj/tRHFGju5Cn/HRaTsBIL2rTxjMwqTOZ2gIDPaWQJGm62N+zihYpB+pzJMQKKU8PB2J24gybjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_MEMORY nodes are intended to contain general System RAM.  Today, some
device drivers hotplug their memory (marked Specific Purpose or Reserved)
to get access to mm/ services, but don't intend it for general consumption.

This creates reliability issues as there are no isolation guarantees.

Create N_PRIVATE for memory nodes whose memory is not intended for
general consumption.  This state is mutually exclusive with N_MEMORY.

This will allow existing service code (like page_alloc.c) to manage
N_PRIVATE nodes without exposing N_MEMORY users to that memory.

Add `node_mark_private()` for device drivers to call to mark a node
as private prior to hotplugging memory.  This fails if the node is
already online or already has N_MEMORY.

Private nodes must have a memory types so that multiple drivers
trying to online private memory onto the same node are warned
when a conflict occurs.

Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c      | 199 +++++++++++++++++++++++++++++++++++++++
 include/linux/node.h     |  60 ++++++++++++
 include/linux/nodemask.h |   1 +
 mm/memory_hotplug.c      |   2 +-
 4 files changed, 261 insertions(+), 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 00cf4532f121..b503782ea109 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -861,6 +861,193 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
 			   (void *)&nid, register_mem_block_under_node_hotplug);
 	return;
 }
+
+static enum private_memtype *private_nodes;
+/* Per-node list of private node operations callbacks */
+static struct list_head private_node_ops_list[MAX_NUMNODES];
+static DEFINE_MUTEX(private_node_ops_lock);
+static bool private_node_ops_initialized;
+
+/*
+ * Note: private_node_ops_list is initialized in node_dev_init() before
+ * any calls to node_register_private() can occur.
+ */
+
+/**
+ * node_register_private - Mark a node as private and register ops
+ * @nid: Node identifier
+ * @ops: Callback operations structure (required, but callbacks may be NULL)
+ *
+ * Mark a node as private and register the given ops structure. The ops
+ * structure must have res_start and res_end set to the physical address
+ * range covered by this registration, and memtype set to the private
+ * memory type. Multiple registrations for the same node are allowed as
+ * long as they have the same memtype.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int node_register_private(int nid, struct private_node_ops *ops)
+{
+	int rc = 0;
+	enum private_memtype ctype;
+	enum private_memtype type;
+
+	if (!ops)
+		return -EINVAL;
+
+	type = ops->memtype;
+
+	if (!node_possible(nid) || !private_nodes || type >= NODE_MAX_MEMTYPE)
+		return -EINVAL;
+
+	/* Validate resource bounds */
+	if (ops->res_start > ops->res_end)
+		return -EINVAL;
+
+	mutex_lock(&private_node_ops_lock);
+
+	/* hotplug lock must be held while checking online/node state */
+	mem_hotplug_begin();
+
+	/*
+	 * N_PRIVATE and N_MEMORY are mutually exclusive. Fail if the node
+	 * already has N_MEMORY set, regardless of online state.
+	 */
+	if (node_state(nid, N_MEMORY)) {
+		rc = -EBUSY;
+		goto out;
+	}
+
+	ctype = private_nodes[nid];
+	if (ctype > NODE_MEM_NOTYPE && ctype != type) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* Initialize the ops list entry and add to the node's list */
+	INIT_LIST_HEAD(&ops->list);
+	list_add_tail_rcu(&ops->list, &private_node_ops_list[nid]);
+
+	private_nodes[nid] = type;
+	node_set_state(nid, N_PRIVATE);
+out:
+	mem_hotplug_done();
+	mutex_unlock(&private_node_ops_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(node_register_private);
+
+/**
+ * node_unregister_private - Unregister ops and potentially unmark node as private
+ * @nid: Node identifier
+ * @ops: Callback operations structure to remove
+ *
+ * Remove the given ops structure from the node's ops list. If this is
+ * the last ops structure for the node and the node is offline, the
+ * node is unmarked as private.
+ */
+void node_unregister_private(int nid, struct private_node_ops *ops)
+{
+	if (!node_possible(nid) || !private_nodes || !ops)
+		return;
+
+	mutex_lock(&private_node_ops_lock);
+	mem_hotplug_begin();
+
+	list_del_rcu(&ops->list);
+	/* If list is now empty, clear private state */
+	if (list_empty(&private_node_ops_list[nid])) {
+		private_nodes[nid] = NODE_MEM_NOTYPE;
+		node_clear_state(nid, N_PRIVATE);
+	}
+
+	mem_hotplug_done();
+	mutex_unlock(&private_node_ops_lock);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(node_unregister_private);
+
+/**
+ * node_private_allocated - Validate a page allocation from a private node
+ * @page: The allocated page
+ *
+ * Find the ops structure whose region contains the page's physical address
+ * and call its page_allocated callback if one is registered.
+ *
+ * Returns:
+ *   0 if the callback succeeds or no callback is registered for this region
+ *   -ENXIO if the page is not found in any registered region
+ *   Other negative error code if the callback indicates the page is not safe
+ */
+int node_private_allocated(struct page *page)
+{
+	struct private_node_ops *ops;
+	phys_addr_t page_phys;
+	int nid = page_to_nid(page);
+	int ret = -ENXIO;
+
+	if (!node_possible(nid) || nid >= MAX_NUMNODES)
+		return -ENXIO;
+
+	if (!private_node_ops_initialized)
+		return -ENXIO;
+
+	page_phys = page_to_phys(page);
+
+	/*
+	 * Use RCU to safely traverse the list without holding locks.
+	 * Writers use list_add_tail_rcu/list_del_rcu with synchronize_rcu()
+	 * to ensure safe concurrent access.
+	 */
+	rcu_read_lock();
+	list_for_each_entry_rcu(ops, &private_node_ops_list[nid], list) {
+		if (page_phys >= ops->res_start && page_phys <= ops->res_end) {
+			if (ops->page_allocated)
+				ret = ops->page_allocated(page, ops->data);
+			else
+				ret = 0;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(node_private_allocated);
+
+/**
+ * node_private_freed - Notify that a page from a private node is being freed
+ * @page: The page being freed
+ *
+ * Find the ops structure whose region contains the page's physical address
+ * and call its page_freed callback if one is registered.
+ */
+void node_private_freed(struct page *page)
+{
+	struct private_node_ops *ops;
+	phys_addr_t page_phys;
+	int nid = page_to_nid(page);
+
+	if (!node_possible(nid) || nid >= MAX_NUMNODES)
+		return;
+
+	if (!private_node_ops_initialized)
+		return;
+
+	page_phys = page_to_phys(page);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ops, &private_node_ops_list[nid], list) {
+		if (page_phys >= ops->res_start && page_phys <= ops->res_end) {
+			if (ops->page_freed)
+				ops->page_freed(page, ops->data);
+			break;
+		}
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(node_private_freed);
+
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 /**
@@ -959,6 +1146,7 @@ static struct node_attr node_state_attr[] = {
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+	[N_PRIVATE] = _NODE_ATTR(has_private_memory, N_PRIVATE),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
 					   N_GENERIC_INITIATOR),
@@ -972,6 +1160,7 @@ static struct attribute *node_state_attrs[] = {
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
 	&node_state_attr[N_MEMORY].attr.attr,
+	&node_state_attr[N_PRIVATE].attr.attr,
 	&node_state_attr[N_CPU].attr.attr,
 	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
 	NULL
@@ -1007,5 +1196,15 @@ void __init node_dev_init(void)
 			panic("%s() failed to add node: %d\n", __func__, ret);
 	}
 
+	private_nodes = kzalloc(sizeof(enum private_memtype) * MAX_NUMNODES,
+				GFP_KERNEL);
+	if (!private_nodes)
+		pr_warn("Failed to allocate private_nodes, private node support disabled\n");
+
+	/* Initialize private node ops lists */
+	for (i = 0; i < MAX_NUMNODES; i++)
+		INIT_LIST_HEAD(&private_node_ops_list[i]);
+	private_node_ops_initialized = true;
+
 	register_memory_blocks_under_nodes();
 }
diff --git a/include/linux/node.h b/include/linux/node.h
index 0269b064ba65..53a9fb63b60e 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -62,6 +62,47 @@ enum cache_mode {
 	NODE_CACHE_ADDR_MODE_EXTENDED_LINEAR,
 };
 
+enum private_memtype {
+	NODE_MEM_NOTYPE,
+	NODE_MEM_ZSWAP,
+	NODE_MEM_COMPRESSED,
+	NODE_MEM_ACCELERATOR,
+	NODE_MEM_DEMOTE_ONLY,
+	NODE_MAX_MEMTYPE,
+};
+
+/**
+ * struct private_node_ops - Callbacks for private node operations
+ * @list: List node for per-node ops list
+ * @res_start: Start physical address of the memory region
+ * @res_end: End physical address of the memory region (inclusive)
+ * @memtype: Private node memory type for this region
+ * @page_allocated: Called after a page is allocated from this region
+ *                  to validate that the page is safe to use. Returns 0
+ *                  on success, negative error code on failure. If this
+ *                  returns an error, the caller should free the page
+ *                  and try another node. May be NULL if no validation
+ *                  is needed.
+ * @page_freed: Called when a page from this region is being freed.
+ *              Allows the driver to update its internal tracking.
+ *              May be NULL if no notification is needed.
+ * @data: Driver-private data passed to callbacks
+ *
+ * Multiple drivers may register ops for a single private node. Each
+ * registration covers a specific physical memory region. When a page
+ * is allocated, the appropriate ops structure is found by matching
+ * the page's physical address against the registered regions.
+ */
+struct private_node_ops {
+	struct list_head list;
+	resource_size_t res_start;
+	resource_size_t res_end;
+	enum private_memtype memtype;
+	int (*page_allocated)(struct page *page, void *data);
+	void (*page_freed)(struct page *page, void *data);
+	void *data;
+};
+
 /**
  * struct node_cache_attrs - system memory caching attributes
  *
@@ -121,6 +162,10 @@ extern struct node *node_devices[];
 #if defined(CONFIG_MEMORY_HOTPLUG) && defined(CONFIG_NUMA)
 void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
 					       unsigned long end_pfn);
+int node_register_private(int nid, struct private_node_ops *ops);
+void node_unregister_private(int nid, struct private_node_ops *ops);
+int node_private_allocated(struct page *page);
+void node_private_freed(struct page *page);
 #else
 static inline void register_memory_blocks_under_node_hotplug(int nid,
 							     unsigned long start_pfn,
@@ -130,6 +175,21 @@ static inline void register_memory_blocks_under_node_hotplug(int nid,
 static inline void register_memory_blocks_under_nodes(void)
 {
 }
+static inline int node_register_private(int nid, struct private_node_ops *ops)
+{
+	return -ENODEV;
+}
+static inline void node_unregister_private(int nid,
+					   struct private_node_ops *ops)
+{
+}
+static inline int node_private_allocated(struct page *page)
+{
+	return -ENXIO;
+}
+static inline void node_private_freed(struct page *page)
+{
+}
 #endif
 
 struct node_notify {
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index bd38648c998d..dac250c6f1a9 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -391,6 +391,7 @@ enum node_states {
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
 	N_MEMORY,		/* The node has memory(regular, high, movable) */
+	N_PRIVATE,		/* The node's memory is private */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	NR_NODE_STATES
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 389989a28abe..57463fcb4021 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1207,7 +1207,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	online_pages_range(pfn, nr_pages);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
-	if (node_arg.nid >= 0)
+	if (node_arg.nid >= 0 && !node_state(nid, N_PRIVATE))
 		node_set_state(nid, N_MEMORY);
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
-- 
2.52.0


