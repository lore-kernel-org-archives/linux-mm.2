Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0CE5C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8B56B00AA; Sun, 22 Feb 2026 03:49:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D1C6B00AC; Sun, 22 Feb 2026 03:49:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D0E6B00AD; Sun, 22 Feb 2026 03:49:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8EB96B00AA
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B43B1C5CC
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:46 +0000 (UTC)
X-FDA: 84471469572.04.8BC5537
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id C04184000A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BcTK63pt;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uf1ZWp0V25jDsi9L3Unk8bUddTMI7A2gwbgNKk4lUpk=;
	b=saX+NCsDY1VT6IPWLKIKQO9D4nS0l7zjYczVhrhijcsD5HOYItDZ2BCwyF7Dp4CxffAq29
	bqDrUQUr08Mbx9zgVsSfsuhQ/HSIy2txRdUaQcu5VkBplEixB/ZubiXiV4rUefhquA0Fj6
	wCvtSy/3Eby/BTKP1zNSCRKWq4Au5s0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750184; a=rsa-sha256;
	cv=none;
	b=2GrzOor1bzpe0SCsHsUlawY6gk+TsW+KayV4Stq07IalGrvhv0z+u2WOP8Kl86nE0NHYaI
	7T04omf4kM99s8DJVpYXl0Yl9Dwwy3EBYNAgtd992ax6yWQw42MIcFBGzqLJ24tWHrFXAs
	0oovSRBp96267Vi+/LBnCq/yNOyOiOs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BcTK63pt;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506251815a3so32512331cf.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750184; x=1772354984; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uf1ZWp0V25jDsi9L3Unk8bUddTMI7A2gwbgNKk4lUpk=;
        b=BcTK63ptQmc3/DYPxJuzKNZlR212BKFSEuNkM8ieFVtgvG0Lm9pTGJuD8MJOs+fleP
         TYfjiVrpgXB/3C14EV4I/a+n5IWl6ymUVCmn2E58XWus5eJ2BB2NnqpVQDR62Pe95c8l
         yK7vcipcRdIA0izKAFNuQBZKXwqNtDgDkwSdbh3T5YTELDY6UsEt7v3eMIu2/lNf8Ibz
         O56assA5DgIZWe9UcR6QOcgXox4HeLQXyvR2oRnMb5K+opbOFvvpFlr37tsk4UVD8CiK
         6ObF2NnUgitApcyQsTMfK7sb0riP2aDpEBLDTr9xTvdrEPgL5n0708IR/PCokDdJDq7V
         NVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750184; x=1772354984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uf1ZWp0V25jDsi9L3Unk8bUddTMI7A2gwbgNKk4lUpk=;
        b=jQYXBqxvjIK2LIwzEJpAEEcnOv/4Jo++fkmZnzpx1sEO6Rz4+PHM5w5TpAfst8N46a
         IhBg5I8B53SRLPpgkRZXTcV6uhdmvXzn4sNMWKqlAlrElHxl50WwkRI4A6rJNFlzNo6y
         ZMGq3cS+MPGSxDc4aGRjLURM1WKyyxmYmZmDPSJyVpWyx2yNvPqwp5k3be6EEdn6h//8
         xWqcrpNLj6zWdp5CYrDb0IZXI9TpPvwATZhAU60pO2CV7msgAFUZfhUcmSUwmulON8e0
         VHGPZKGa8gbYulpCfeJ1xIt/0fmDdXfkMpLCj+fZlFUGcxGXCBoPoNliJH8nSOAFk38z
         4TeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUf/HdaLeWQUPnFZ5VH2cSV5V5QkeWdgh4EjRynADrBxJZMd5hw2MJX+0g/lYj627MN4PEQbWQ7Q==@kvack.org
X-Gm-Message-State: AOJu0YxYXyqM1Kkxcm09/+S+WGpb7vtaD4OSapar1PKA2VeeJ0eYdbzI
	FBUAmklHKfTm21mE/bcB1JNTTiFNo555lhx+4fZWy302lgR7KFLNHQyb8tv13bO/2Aw=
X-Gm-Gg: AZuq6aJsRMSx1NO5QFFSAWH7vlscOIxmLj/samULxj0h/2ZRS23kbxxJzbeHvckrcTH
	kaLRzyMgaJ/TpvxE8Xb1i/540a2nflDpMDgBxXZxMOCbo34Bp8GNCFbh96Rzpx+kO0RdaQ/zDfA
	V+NXvGmpolzhdezjlxbDwC5GgabH7LAInSZrmspeTpr+izzG9YRSpqYqyz8JwQ7/UR05bfWnjR1
	C1HjsL71zbiwGY3hzQtKMhruIRuwVrWG18ZkVQ/z5qH7WGw0a4PxUcijSlK1aWM/k9Iwj9CtcZl
	B7holRb2+WQFMl0K/ruLJdzWm4MTGr9q++zOR/JX4GJEgc9osyUaN9P6s+WmszAewSwcM2RkJcc
	5RBB21DvtK430OpNJ5sHZbXQbNZmH9VTwOA/6UQ6Y+cN5XTZSbff4W00YXlsHJRi6xYyS518kW3
	8Mzb98vtfXXt2pvkcn65fU73DM2FKLPSlqABmsBhsPPUuYu/Aa4G9LmPAYpIkIxmMKI5xiqdiRM
	82/VMrnKvG5VIc=
X-Received: by 2002:a05:622a:14d1:b0:506:6e65:2325 with SMTP id d75a77b69052e-5070bba2239mr73493701cf.8.1771750183726;
        Sun, 22 Feb 2026 00:49:43 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:43 -0800 (PST)
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
Subject: [RFC PATCH v4 13/27] mm/mempolicy: NP_OPS_MEMPOLICY - support private node mempolicy
Date: Sun, 22 Feb 2026 03:48:28 -0500
Message-ID: <20260222084842.1824063-14-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 59yehq4jei3eh3jd9tbckmp1bpefmron
X-Rspamd-Queue-Id: C04184000A
X-Rspam-User: 
X-HE-Tag: 1771750184-174231
X-HE-Meta: U2FsdGVkX194WYsghIayeDpbs0KyCNDyyzkWI/HizBjVuKgtYap8WBYbM55nl6f3isbHTVdWSYiRdD3jWyMF/frIz8yqPc1HRAwYuOrE0fDP8VncvhFfYhms13lfj9pLMUdnA3cH8oyhT8tVqO6n8JMKNzc/3K+76+fEmSPnTsoHpDbE+l0GNBkQeP6vnGSU+umcnG+qmJv3RXb0bPBLYp0O6Nclue6QZW7EYP7UOSa4go5csqUMP+ICoVcK6M+QkiTbyO5agmXqRCRpOQedc2BylixTEW2v5c9riQ9p/kOMoZdhYwLRbUl6lBp11bS5KdGjrSh1e2PBH4rVyg0cOSeGN+tQ1EFQUjSRfaCDHnWcMlExFIi8X2fIfhYvPz4gOHQvctZ+BC2mW7jfbxQIla9AXUWTI2LjijdaVKvKid8EIzL2X21qQk8DOSKYHTewvX1gWSqXWBAlCzTYf0dwIRk9sLCE7hzeig50nBGJ1+DhXv5u0JCktz1MxDAl069blWEJje+WGkrfUIVb7gR5D8Tgl/xbH0A7GQwwxcrRmSqdnclkJ1ZXcPm9b/c6mMz7Jc4uG/g4OeLQR/cTXvKmqb820fgilsQOmuDS0Vo80T5U1KBpCI+kuZb7a/t3e636YLKBjexLGAY1nzl7tu7hiry8mGr95qN40LLMvBdO104nUSxgxkiJ73ntzaKj3R3PIvrpzvb+TL9MJ0/Hn4b2woBQ4V3OOZrjCrxcYNunil9ciIJ1twSY5Dn3qt/m3qQ/uvmPclHFmPL30+GZR0juibbMe57dj1WM4NgqjquAtxpUuIniJyBGTdX3vdXH0fb9SO4FUZH0mUo3kRWXIqU2TyDIVBseHXZkA7fpqaQZViNB1wnYwehUxHC+awGEAdz2VB05pfK4Ld65uvdAlJn524TGo/Fl94H/tFZWRSVDTE+SOpY4K3AAqFv9XHcV9/iMCFYph8uimbqIFkSrFsR
 /LfJMsEy
 TU6DiFbut+iz+HmBWW1rh+lhUo+myI2yf6WOtcYX6eL3LyCJrgNxrU8pmjajA1YCXeqgKXrjrmsHi/cVsHRDvFQzjmU11eRga6B47BtVvhpBjEHgasTldadhAsf8h5hFyygiJZYfqpNsAABgLD9QKrH9ryHm9/PuIp3QT/gPROM7xBvHgWWuowTBcVKTTOUTjIHib+LpCShxoO90sjYMrE//YxIty8zTClsK4HS/T+6GCb0j7BNdNXMDQ6k/FcMjo6meyAnHJs0QeqIBR7r/rzDTTx1VfsspdxCYFp2Qw26uJA+vuNAYhbTAi9cpcMdBqQ/HG9Ff7Cf6dvNDUQQhohJPXdhMZt0HBf2OKviaUseEq/y5tq2BCAtejyaeP3bC19+cOXD/CmkMvOKoOLq8NOAVK0ChYTkGpXs//eqmR8/Q/h7s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some private nodes want userland to directly allocate from the node
via set_mempolicy() and mbind() - but don't want that node as normal
allocable system memory in the fallback lists.

Add NP_OPS_MEMPOLICY flag requiring NP_OPS_MIGRATION (since mbind can
drive migrations).  Only allow private nodes in policy nodemasks if
all private nodes in the mask support NP_OPS_MEMPOLICY. This prevents
__GFP_PRIVATE from unlocking nodes without NP_OPS_MEMPOLICY support.

Add __GFP_PRIVATE to mempolicy migration sites so moves to opted-in
private nodes succeed.

Update the sysfs "has_memory" attribute to include N_MEMORY_PRIVATE
nodes with NP_OPS_MEMPOLICY set, allowing existing numactl userland
tools to work without modification.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/node.c            | 22 +++++++++++++-
 include/linux/node_private.h   | 40 +++++++++++++++++++++++++
 include/uapi/linux/mempolicy.h |  1 +
 mm/mempolicy.c                 | 54 ++++++++++++++++++++++++++++++----
 mm/page_alloc.c                |  5 ++++
 5 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index e587f5781135..c08b5a948779 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -953,6 +953,10 @@ int node_private_set_ops(int nid, const struct node_private_ops *ops)
 	    (!ops->migrate_to || !ops->folio_migrate))
 		return -EINVAL;
 
+	if ((ops->flags & NP_OPS_MEMPOLICY) &&
+	    !(ops->flags & NP_OPS_MIGRATION))
+		return -EINVAL;
+
 	mutex_lock(&node_private_lock);
 	np = rcu_dereference_protected(NODE_DATA(nid)->node_private,
 				       lockdep_is_held(&node_private_lock));
@@ -1145,6 +1149,21 @@ static ssize_t show_node_state(struct device *dev,
 			  nodemask_pr_args(&node_states[na->state]));
 }
 
+/* has_memory includes N_MEMORY + N_MEMORY_PRIVATE that support mempolicy. */
+static ssize_t show_has_memory(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	nodemask_t mask = node_states[N_MEMORY];
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		if (node_private_has_flag(nid, NP_OPS_MEMPOLICY))
+			node_set(nid, mask);
+	}
+
+	return sysfs_emit(buf, "%*pbl\n", nodemask_pr_args(&mask));
+}
+
 #define _NODE_ATTR(name, state) \
 	{ __ATTR(name, 0444, show_node_state, NULL), state }
 
@@ -1155,7 +1174,8 @@ static struct node_attr node_state_attr[] = {
 #ifdef CONFIG_HIGHMEM
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
-	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+	[N_MEMORY] = { __ATTR(has_memory, 0444, show_has_memory, NULL),
+		       N_MEMORY },
 	[N_MEMORY_PRIVATE] = _NODE_ATTR(has_private_memory, N_MEMORY_PRIVATE),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 0c5be1ee6e60..e9b58afa366b 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -86,6 +86,8 @@ struct node_private_ops {
 
 /* Allow user/kernel migration; requires migrate_to and folio_migrate */
 #define NP_OPS_MIGRATION		BIT(0)
+/* Allow mempolicy-directed allocation and mbind migration to this node */
+#define NP_OPS_MEMPOLICY		BIT(1)
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -276,6 +278,34 @@ static inline int node_private_migrate_to(struct list_head *folios, int nid,
 
 	return ret;
 }
+
+static inline bool node_mpol_eligible(int nid)
+{
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return node_state(nid, N_MEMORY);
+
+	rcu_read_lock();
+	ret = node_private_has_flag(nid, NP_OPS_MEMPOLICY);
+	rcu_read_unlock();
+	return ret;
+}
+
+static inline bool nodes_private_mpol_allowed(const nodemask_t *nodes)
+{
+	int nid;
+	bool eligible = false;
+
+	for_each_node_mask(nid, *nodes) {
+		if (!node_state(nid, N_MEMORY_PRIVATE))
+			continue;
+		if (!node_mpol_eligible(nid))
+			return false;
+		eligible = true;
+	}
+	return eligible;
+}
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #else /* !CONFIG_NUMA */
@@ -364,6 +394,16 @@ static inline int node_private_migrate_to(struct list_head *folios, int nid,
 	return -ENODEV;
 }
 
+static inline bool node_mpol_eligible(int nid)
+{
+	return false;
+}
+
+static inline bool nodes_private_mpol_allowed(const nodemask_t *nodes)
+{
+	return false;
+}
+
 static inline int node_private_register(int nid, struct node_private *np)
 {
 	return -ENODEV;
diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..b606eae983c8 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -64,6 +64,7 @@ enum {
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
+#define MPOL_F_PRIVATE	(1 << 5) /* policy targets private node; use __GFP_PRIVATE */
 
 /*
  * Enabling zone reclaim means the page allocator will attempt to fulfill
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2b0f9762d171..8ac014950e88 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -406,8 +406,6 @@ static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 static int mpol_set_nodemask(struct mempolicy *pol,
 		     const nodemask_t *nodes, struct nodemask_scratch *nsc)
 {
-	int ret;
-
 	/*
 	 * Default (pol==NULL) resp. local memory policies are not a
 	 * subject of any remapping. They also do not need any special
@@ -416,9 +414,12 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	if (!pol || pol->mode == MPOL_LOCAL)
 		return 0;
 
-	/* Check N_MEMORY */
+	/* Check N_MEMORY and N_MEMORY_PRIVATE*/
 	nodes_and(nsc->mask1,
 		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
+	nodes_and(nsc->mask2, cpuset_current_mems_allowed,
+		  node_states[N_MEMORY_PRIVATE]);
+	nodes_or(nsc->mask1, nsc->mask1, nsc->mask2);
 
 	VM_BUG_ON(!nodes);
 
@@ -432,8 +433,13 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	else
 		pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
 
-	ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
-	return ret;
+	/* All private nodes in the mask must have NP_OPS_MEMPOLICY. */
+	if (nodes_private_mpol_allowed(&nsc->mask2))
+		pol->flags |= MPOL_F_PRIVATE;
+	else if (nodes_intersects(nsc->mask2, node_states[N_MEMORY_PRIVATE]))
+		return -EINVAL;
+
+	return mpol_ops[pol->mode].create(pol, &nsc->mask2);
 }
 
 /*
@@ -500,6 +506,7 @@ static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 {
 	nodemask_t tmp;
+	int nid;
 
 	if (pol->flags & MPOL_F_STATIC_NODES)
 		nodes_and(tmp, pol->w.user_nodemask, *nodes);
@@ -514,6 +521,21 @@ static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 	if (nodes_empty(tmp))
 		tmp = *nodes;
 
+	/*
+	 * Drop private nodes that don't have mempolicy support.
+	 * cpusets guarantees at least one N_MEMORY node in effective_mems
+	 * and mems_allowed, so dropping private nodes here is safe.
+	 */
+	for_each_node_mask(nid, tmp) {
+		if (node_state(nid, N_MEMORY_PRIVATE) &&
+		    !node_private_has_flag(nid, NP_OPS_MEMPOLICY))
+			node_clear(nid, tmp);
+	}
+	if (nodes_intersects(tmp, node_states[N_MEMORY_PRIVATE]))
+		pol->flags |= MPOL_F_PRIVATE;
+	else
+		pol->flags &= ~MPOL_F_PRIVATE;
+
 	pol->nodes = tmp;
 }
 
@@ -661,6 +683,9 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 	}
 	if (!queue_folio_required(folio, qp))
 		return;
+	if (folio_is_private_node(folio) &&
+	    !folio_private_flags(folio, NP_OPS_MIGRATION))
+		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
 	    !vma_migratable(walk->vma) ||
 	    !migrate_folio_add(folio, qp->pagelist, qp->flags))
@@ -717,6 +742,9 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 		folio = vm_normal_folio(vma, addr, ptent);
 		if (!folio || folio_is_zone_device(folio))
 			continue;
+		if (folio_is_private_node(folio) &&
+		    !folio_private_flags(folio, NP_OPS_MIGRATION))
+			continue;
 		if (folio_test_large(folio) && max_nr != 1)
 			nr = folio_pte_batch(folio, pte, ptent, max_nr);
 		/*
@@ -1451,6 +1479,9 @@ static struct folio *alloc_migration_target_by_mpol(struct folio *src,
 	else
 		gfp = GFP_HIGHUSER_MOVABLE | __GFP_RETRY_MAYFAIL | __GFP_COMP;
 
+	if (pol->flags & MPOL_F_PRIVATE)
+		gfp |= __GFP_PRIVATE;
+
 	return folio_alloc_mpol(gfp, order, pol, ilx, nid);
 }
 #else
@@ -2280,6 +2311,15 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *pol,
 			nodemask = &pol->nodes;
 		if (pol->home_node != NUMA_NO_NODE)
 			*nid = pol->home_node;
+		else if ((pol->flags & MPOL_F_PRIVATE) &&
+			 !node_isset(*nid, pol->nodes)) {
+			/*
+			 * Private nodes are not in N_MEMORY nodes' zonelists.
+			 * When the preferred nid (usually numa_node_id()) can't
+			 * reach the policy nodes, start from a policy node.
+			 */
+			*nid = first_node(pol->nodes);
+		}
 		/*
 		 * __GFP_THISNODE shouldn't even be used with the bind policy
 		 * because we might easily break the expectation to stay on the
@@ -2533,6 +2573,10 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
+
+	if (pol->flags & MPOL_F_PRIVATE)
+		gfp |= __GFP_PRIVATE;
+
 	folio = folio_alloc_mpol_noprof(gfp, order, pol, ilx, numa_node_id());
 	mpol_cond_put(pol);
 	return folio;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5a1b35421d78..ec6c1f8e85d8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3849,8 +3849,13 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		 * if another process has NUMA bindings and is causing
 		 * kswapd wakeups on only some nodes. Avoid accidental
 		 * "node_reclaim_mode"-like behavior in this case.
+		 *
+		 * Nodes without kswapd (some private nodes) are never
+		 * skipped - this causes some mempolicies to silently
+		 * fall back to DRAM even if the node is eligible.
 		 */
 		if (skip_kswapd_nodes &&
+		    zone->zone_pgdat->kswapd &&
 		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
 			skipped_kswapd_nodes = true;
 			continue;
-- 
2.53.0


