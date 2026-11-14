Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30B1560A382B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=QEjR9Zdw
Received: by kanga.kvack.org (Postfix)
	id AEB096B05B7; Sat, 14 Nov 2026 02:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE3E6B05B6; Sat, 14 Nov 2026 02:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0386B05B7; Sat, 14 Nov 2026 02:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF876B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB57A140377
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:13 +0000 (UTC)
X-FDA: 85432850706.09.6FBA4A3
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE538A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QEjR9Zdw;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640212;
	b=YJrXWMl5F9eG/W4sAm07KSnsig2JM8DHxSpVa16S9ke5JY929I2UgTh0Lg1ZFWeymEgXcd
	Oin21cZVPGbuv8/72VO//wJ1JsHT3JqmvX88aIP9vwYGDFcVcMUzTb1VRC6QJPDT9dInA2
	aGnzpGveMatdj2xZ2mcVp9TQGhpv84A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QEjR9Zdw;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lEa1LIQv4RtVFSRolNpT9VAJCtG2n7xXC0f3lXhF2k=;
	b=7RTbi9L19MQdNKovQD0WYmGbb8ceJeH0rR1k7Q8EVrcoYPb0Tf/T4XAE2ZUxRw/jy57tKo
	zQ0zbW0p5m3SEo7CzwOckNTZ6hzBEtpRXciBVHP3KE2QeeziqOo+Q4QDyY/Dt1ei0QgFj2
	MwWktCHK19pM9Tt0/r4rxkgzB9nv1Z0=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-53c4b82919fso37582431cf.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640211; x=1795245011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2lEa1LIQv4RtVFSRolNpT9VAJCtG2n7xXC0f3lXhF2k=;
        b=QEjR9ZdwPb9cHjFspxsLNSKudm51E1UYvMsI+vN2DUdVkVmnaaDraFH/GcUEcEQyKz
         LJGGvOn8L81Cl1clO3EQJcbh3ahL8rWpnEdFb7Bai1lnceUeEZ2HmN3UNZGgZG8DfPrQ
         xm07lObboUVCZ4IbYRx5dJwksHvVgFzcK0xCpDioxTT7zlexoqAfE9K/EZavLB6Hhz1o
         zY+B5Vy/e7fKcYmoj8DyGjlAcZri4yiC0H87xPmutKiGRI/sp3CiNVKAzEdC29mkB7ck
         Lm+b5iKBRgWxkeOIltX6v/T1JRdnI5ltFtG8DakrOq31lxmfeDnRQmN7D4j6a2IJFLSZ
         vBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640211; x=1795245011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2lEa1LIQv4RtVFSRolNpT9VAJCtG2n7xXC0f3lXhF2k=;
        b=hOvR3jDhP6CZR2PcWPynPW8VUEtz06JQFwVZNVKt8qqOtlcED81AtcTLJ8+i0UAV3f
         4zifwvWxTmdElhr3DbiNQw2wPPtbPjQMGDhK89149IqBh2Uk6cl/aofUGDlxCsIa5I1I
         utJ1JxJbIkZ/tqzPTyltdpc9mzSw7UHDh1MPx3uB1Xym3kAc4KEgZueXvwVNiGLYV94R
         ApEM6w3JB2Wq0vEW+i4sERyMda70keEo4NUCtMV9cUSkkqKdu1Jh5vKsSVtB8BQMR6Vo
         EdGN+r4ecqJnrHyTKtx4szVjp/I289jLZ1T9MusGv3NSNClqmyaq/ZpcGuP/vuxbnam4
         nGPQ==
X-Gm-Message-State: APuU4Z/QQcHlm0Pr1Z/42DxHsy63yN6tc0TjMRVPle9J/YoUY5GkNshv
	Pi6PIfTM+s/dT+5KsyZynn1zATB4s86PBYstyVEu3TmMEPw9OkYgXSTEZFzZDmnKt4c63MlrHB2
	tXSml
X-Gm-Gg: AYBFou3xcf5Mu4pvLrO5fgQ6bfvPmQ+HhQGUB3prii2YEhhY4S7epbFWP5zCtNWkW6G
	nUdQ5+njatiZrfokVbrfiI3O+MO5/M6Ax/LY20GoiZ8nkhCzKVjrNQ8RGP0lTFOuQroI1UhxfH/
	04rGVYlx+Tl7Bra706ZUdjD8/QqAbqLmuREZm5EDuf448JtkaVo6HI0uJiiejz1Jgn83vdDyVsO
	5znfnbdsOIFX3ZtrJiPX13crq5SMixX5atrsz/QziNHWEF0b7vIojKS8KCyXLFeIfMBOSKCgE/Q
	/maSp66nISCS7r2yHZK5mvarMRfq2eAq0FN1ukAwV8ghBEUdF09o78OblBDEAiQKk4Lndx/4VZ/
	6o8Jt5G0BYLfrOEvjXxAdq5+v2zuMhKMMes7a/3Ysvrix7UratxPCDWZDsZr5XUI8WJvDZKRgkH
	rYXQPEJPqFS4OKFlQwCmW5sJd5oYVhCYJs5/Pkav3FsTpozeRSaOMTZK5BWpKgy1vfGopOI3Lua
	vvQ2of9Dj8a+DTCbdo/JAwDpVVlTXjsBCX9EJYmlRrw7WjWZ0JDnCyf2cX5BN6sof1GhBcR5LZV
	Y2+xjUS6f6tCJYani1V8LdnNrqhneVkTT9FcJ9XDGIgB3m8ijXqVk0zlMha+s502JRSSCdk3jHS
	BnsEugj3wdAhIsgmNkmD0ppDXTc0kCSanFr44
X-Received: by 2002:a05:622a:355:b0:535:f9dd:cb9b with SMTP id d75a77b69052e-55ac817ffbemr80325101cf.26.1794640211080;
        Fri, 13 Nov 2026 23:10:11 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:10 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 03/22] mm: introduce the common-memory node state
Date: Sat, 14 Nov 2026 02:09:40 -0500
Message-ID: <20261114070959.3490008-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ps1wdcjb13fdspr5bhaayx1rbb6d4ynx
X-Rspamd-Queue-Id: EE538A0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640211-474704
X-HE-Meta: U2FsdGVkX1/GN9GeHjIrvPNRySeZHWAY5If0esEokl4wGbHA9PjezHnn3QzML1BHpQD9+SWY3N7mCm1QlBngi/biYuC+qswUOmi9Q2bRgcaIqK6AooKcg6uO5/5EoK7hz4m8KPThZ064BxywYGSZIYST71CFpJwi9Sun/Uk3z1KWvkLP9DXAZkbFwn40sWUU7mgzHVlaP9oeFDQ1wb0lIH73xo7da09QI4S0tAOwiZhuxbpc/l0eHZTZPDwnQL67phCnasv5nipN6ffdfV00ilGstQaVFWYiqc2HKb7T8P1v6eQVE1ipoRfn3/ppwOMSW6Ih3jJ0Y00xUothHd7yJ/+bo5/tjD/Jt1v5++JwLu8xSubhjjAsmnH4QD4M021HV/k2iLvlL7lgolFcZtRh6yVLAdOgco6DaFAd3Xriy/DCdNFg4JsLyXy24eCt/iG1V2/C6f17iY4fStHG37YC+uOU9K0UilvoPVp1xPyB3XbP7QP4q57i3rWKVUc2wvr80mNyXyr8LsEuEBaZYFUql/fLo9z3WSDUKD7nLq/GMH/JhOT7Xv59oHAyl3e9WqqQfTwWgIF8EUw9jAxlLKQTT8lqYUBYRTER36QHLXO6wXEDukevYTEXEtBbelNA+rl3QYLMBSsYQqth5hHsJRVqyrDeipPB3wmXufNUjz9+/QU6xrWJbN4ayVyG5o9a7cXyC61E9Y0FwSOcjFxCr/xtJSgof/av/EdWoKmK19K69MzaRL0G5A+GbTp9UShiVIw3/D/TomQDQtTt2+YKaA8X6I6Uly4GBovZ+25ez06EG7NuUygHY57A/YE5lOpmSQaUq46HazD1F1wnfbIhpnTLIfDrTIGBVBoUGcn+3MPly+pgm39N+j+Fca65Mb1NopEeFtE3xbumfhsy4c4F9TVJDFMEs60w433RSBfjcsgEkY8/FJJ28RP5qSIKb1L4UgMll1soLk5762oR9zXuVa5
 BHKHdeMd
 ZrMtNOW0yVsY18FNyWX4TJvWGHBoj0pLkF4FmuxDvtlTgMop/2TUJTYpdCkJP/wJvWW3Y5bvy9pNFl+o9luX5QyQNB+pQv14pr+b2stNp+9D30XI86Y8xLZOKmBr79ZdfKLxSt3z3B1UInh/u8CYh+xb0JHoZuMaoHmjAMsfT1adfkQEB1ET3+Q27v5Alx1sugMZEoaJDlXyG+XRvxtSTG6hTJ7u9bC/+SnnZCUEw+VDgEvrJ3MRhlUTkwfKAF0U0tgeoH2mlocGbxFvD9wwaMmUlpFZvuSMmZabSY3BicXXJCgw2CxTe3pcvfEirY+anvNEGpn3YjJV90HYl6yniLbCl2jdDVGxu5F2dr7YqWW9X4Ti5gmrrcNv4gETox+lqdRKS+Gjq949zk7jZlsw/feE0yIJyZhgsNPWw07DuCqzawk1biZlyESY2NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

N_MEMORY is overloaded with two meanings:
  1) a node has memory.
  2) a node's memory is reachable via ordinary allocation or
     an arbitrary MM service may use that memory.

Allow N_MEMORY to mean #1, and introduce N_MEMORY_COMMON to mean #2.

N_MEMORY_COMMON nodes contain "common memory" capable of being managed
arbitrarily by the kernel MM based solely on zone membership. Following
commits convert relevant N_MEMORY users to N_MEMORY_COMMON.

Add folio_is_common_memory() and page_is_common_memory() for MM services
that walk folios. Following commits convert folio_is_zone_device() and
page_is_zone_device() callers accordingly.

Expose the state via `has_common_memory` so userspace can identify
the memory available to ordinary allocations and common MM services.

Add has_memory to the docs while we're here.

Every node with memory is common, so N_MEMORY_COMMON equals N_MEMORY
and there is no behavioral change.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/ABI/stable/sysfs-devices-node | 16 ++++++++++++++++
 Documentation/mm/physical_memory.rst        |  8 +++++++-
 drivers/base/node.c                         |  2 ++
 include/linux/nodemask.h                    |  9 ++++++++-
 mm/internal.h                               | 15 +++++++++++++++
 mm/page_alloc.c                             |  3 +++
 6 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 2d0e023f22a71..a93de328f8fe8 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -10,6 +10,15 @@ Contact:	Linux Memory Management list <linux-mm@kvack.org>
 Description:
 		Nodes that are online.
 
+What:		/sys/devices/system/node/has_memory
+Date:		December 2012
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have memory.
+
+		This memory may or may not be reachable via standard
+		allocations, see has_common_memory for details.
+
 What:		/sys/devices/system/node/has_normal_memory
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
@@ -29,6 +38,13 @@ Description:
 		Nodes that have regular or high memory.
 		Depends on CONFIG_HIGHMEM.
 
+What:		/sys/devices/system/node/has_common_memory
+Date:		November 2026
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes whose memory ordinary allocations may use without
+		requesting the node explicitly.
+
 What:		/sys/devices/system/node/nodeX
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 2e67e8b23a994..fd5c5d136180f 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -168,7 +168,12 @@ nodes with particular properties as defined by ``enum node_states``:
   The node has regular or high memory. When ``CONFIG_HIGHMEM`` is disabled
   aliased to ``N_NORMAL_MEMORY``.
 ``N_MEMORY``
-  The node has memory(regular, high, movable)
+  The node has online memory (regular, high, movable).  This is a topology and
+  accounting state. Presence in this mask does not mean ordinary allocations
+  can use the node's memory; see ``N_MEMORY_COMMON``.
+``N_MEMORY_COMMON``
+  The node is on the page allocator's fallback zonelists, so an allocation
+  that named no node can be satisfied from it.
 ``N_CPU``
   The node has one or more CPUs
 ``N_GENERIC_INITIATOR``
@@ -184,6 +189,7 @@ For example, for node 2 with normal memory and CPUs, bit 2 will be set in ::
   node_states[N_NORMAL_MEMORY]
   node_states[N_HIGH_MEMORY]
   node_states[N_MEMORY]
+  node_states[N_MEMORY_COMMON]
   node_states[N_CPU]
 
 For various operations possible with nodemasks please refer to
diff --git a/drivers/base/node.c b/drivers/base/node.c
index dcdc8626627a8..cc6696d1390f3 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -965,6 +965,7 @@ static struct node_attr node_state_attr[] = {
 	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
 #endif
 	[N_MEMORY] = _NODE_ATTR(has_memory, N_MEMORY),
+	[N_MEMORY_COMMON] = _NODE_ATTR(has_common_memory, N_MEMORY_COMMON),
 	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
 	[N_GENERIC_INITIATOR] = _NODE_ATTR(has_generic_initiator,
 					   N_GENERIC_INITIATOR),
@@ -978,6 +979,7 @@ static struct attribute *node_state_attrs[] = {
 	&node_state_attr[N_HIGH_MEMORY].attr.attr,
 #endif
 	&node_state_attr[N_MEMORY].attr.attr,
+	&node_state_attr[N_MEMORY_COMMON].attr.attr,
 	&node_state_attr[N_CPU].attr.attr,
 	&node_state_attr[N_GENERIC_INITIATOR].attr.attr,
 	NULL
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 28a456c3f5964..7ace610bdd654 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -402,7 +402,14 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
-	N_MEMORY,		/* The node has memory(regular, high, movable) */
+	/*
+	 * N_MEMORY indicates online memory exists on the node - it is used
+	 * to manage per-node meta-data and topology decisions.
+	 * N_MEMORY_COMMON indicates whether the node can satisfy arbitrary
+	 * allocations and whether a service should manage that node's folios.
+	 */
+	N_MEMORY,		/* the node has memory */
+	N_MEMORY_COMMON,	/* common pool (fallback zonelist) */
 	N_CPU,		/* The node has one or more cpus */
 	N_GENERIC_INITIATOR,	/* The node has one or more Generic Initiators */
 	NR_NODE_STATES
diff --git a/mm/internal.h b/mm/internal.h
index 608a83c34c224..af6fc27a9fc98 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -65,6 +65,21 @@ void folio_mark_lazyfree(struct folio *folio);
 void node_set_memory_state(int nid, bool high, bool normal);
 void node_clear_memory_state(int nid);
 
+/*
+ * Common memory is available to generic MM services. ZONE_DEVICE folios do
+ * not qualify even when their NUMA node is common.
+ */
+static inline bool folio_is_common_memory(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_state(folio_nid(folio), N_MEMORY_COMMON);
+}
+
+static inline bool page_is_common_memory(struct page *page)
+{
+	return folio_is_common_memory(page_folio(page));
+}
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 834d199ff8429..6ffa972811462 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -203,6 +203,7 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 	[N_HIGH_MEMORY] = { { [0] = 1UL } },
 #endif
 	[N_MEMORY] = { { [0] = 1UL } },
+	[N_MEMORY_COMMON] = { { [0] = 1UL } },
 	[N_CPU] = { { [0] = 1UL } },
 #endif	/* NUMA */
 };
@@ -215,10 +216,12 @@ void __meminit node_set_memory_state(int nid, bool high, bool normal)
 		node_set_state(nid, N_HIGH_MEMORY);
 	if (normal)
 		node_set_state(nid, N_NORMAL_MEMORY);
+	node_set_state(nid, N_MEMORY_COMMON);
 }
 
 void __meminit node_clear_memory_state(int nid)
 {
+	node_clear_state(nid, N_MEMORY_COMMON);
 	node_clear_state(nid, N_NORMAL_MEMORY);
 	node_clear_state(nid, N_MEMORY);
 }
-- 
2.53.1-Meta


