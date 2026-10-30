Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56206606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=e7ZtoHmT
Received: by kanga.kvack.org (Postfix)
	id 42BAF6B05B3; Fri, 30 Oct 2026 05:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBF26B05B4; Fri, 30 Oct 2026 05:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB166B05B5; Fri, 30 Oct 2026 05:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 095956B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:52:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 994181A0683
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:52:50 +0000 (UTC)
X-FDA: 85378828500.13.CFF523C
Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3CC31C0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:52:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e7ZtoHmT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5h34MN+qOPMphkpctmq7PgnicM+ioLs6tA1qYi+SyA=;
	b=Ax+ayHetrAz/P25j2j2zUNXm6XUUK2MhB4TI+dFUIVp8/5h2Rsjl/+gPE88m3QsFimKxMT
	y6j+DPGiR/xKbpP5y5e9CZ25kHnSBwE1hUcz3yPRHCpHmWWa9FxXTqSBhqGtuGH00gc9Hn
	IdnQFz7B7VKwUd51UlvW/8NnhJO4SwM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e7ZtoHmT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353968;
	b=kcgKa0CSxraD8NKIQq5+5pD3gKYnoak/fh8WeL9r8hDxN1jrQR+0XJ8FDEWN6+YfCJqPDa
	VM8yl6i8ZV7iyW6nJb6KwZ0Sv7Iw3bGC0nFQa7W6A+WKR9Z3Q6Zjgy26T+hAom/rRl5wy0
	HhK6F+8oqGusCv2/rhrIVChbmWA/y+0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=foVTesr/V5lJ4MJRpdzJaGLpzqZmZIMatmV4b2e35so=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793353967; v=1; x=1793958767;
 b=e7ZtoHmTO5KUTXLAQ+JZAKb7lcSrMohTBaA2G1mfILdQDyCAG7ETgPeUItwiTj8Y+UudbeeL
 gkOKM7+uoVfERNo66453F5aFgUchwU291ViOH8J2LgK1dppw+vfDwRV++VRNYcJDsiXdb+srAkV
 iAVrx+Vk1PP7MsTO9HvfVOio=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c362bb1e45826fc4;
	Fri, 30 Oct 2026 09:52:47 +0000
X-Mizu-Trace-ID: c362bb1e45826fc4
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-new v1 1/2] mm: memcontrol: split mem_cgroup_may_zswap() out of obj_cgroup_may_zswap()
Date: Fri, 30 Oct 2026 17:52:17 +0800
Message-ID: <20261030095223.325309-2-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030095223.325309-1-jiayuan.chen@linux.dev>
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3CC31C0006
X-Stat-Signature: mhpe9myx5rd4pdu3bmsj6thss4bspysu
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793353968-932557
X-HE-Meta: U2FsdGVkX1/xJZJLScU+aSK61pUPCQSd21RTL7luz9zzC/wZW4LCKMwP1DyOFPmrUJgcQmb1q3wdNb7Lscb882DNV+eSRH0097dmTGiHgYoDtk0+JsVnfuv9nByV6npiqQrMNP8w64wcHPfqXpXdH6dRhGCslXvwkrhdID6Xpg80xXeQk+rg+KgwWbDL2mdkx60edgJyckUg/iS50Ppk92VVcpSDkRcKhJczp+MpG0CVlAXK7PBLzeiwTnfH/PaVyoQy7H37DM0Cy77Opts4Um6ih9EdqHGX7RkgGBCZlBZoRr/ssUFlL/mnBjjPZGMOS0eSLhP3140CYIwdYSihWkv4Mmi7I9Z/ne9P9DZjlrK/eZIWBC1DJCQwk9cqt113gUzBgdPpfGLWA4BAGi1yaaYVeXywtcb7Bx/H7mtBZ8NxWFsIaYXYhwJAabu8Bb6f7InLN0gJGoevW68cMHwBmBJW87YFaaPzf/K3rJoBpJJvo78PagpPYgT0tDC/AtGDJYv7fwwkgGHlkMgTQxVqgPVOc+xAg1P/wh4qvLGo2yZ/WFdBV33xBNNFSca5LCjGtCG4iJ1+f2HKRKt5uSIKCuHV3aW484XnaSdZ1NBQHUOhLlYt5LTlyDhGr6krw1d5X+3fJp7Fcya4WQdFvbkGEBsrX59pJjFqhqy2RkpuLoPbTC4/nSj4tDVdkV8H3UuzAE0zlgyHqfE/qEjDiUDluoICctkFNWWh0MKhiSE07ewwHwxp1Jk1AfZBJ0VLm8T6c0nJJqtNLXnqGbp9X6L65fTrsndcoITb9zNxdnC/Q8PCRNQI6nEkAUD4SvHodZip/vCJBglMlL4hVw9ZzCZBJpjXoY5ILB5jptuirzjuOyLLNyH1WlGB/OAatoDUgsQOyhsu3q1P6vrS+s3p8P/mcVSGx1QXM+Q/UVf9B5sUA7ifcMBYsK76Vfd4GgY4oLIiiCPDBXJ1H+gnfoqaCwT
 EJL1WEYo
 o87jFO62gTUeiU/Pu3HwF0JilgnT6in1h40vDF3i0m2BDjro4chWSiLrpgyatfuPHkk6bi4wTfsDhjxvK+JCwTCgmj+M/j5duzuL+eyF1s1Jq3MolDsBG3NYUCabqLQebC7mqMVB2HAqQq4bFcKA4jvU0BvBwOh5yN0rpgNkROn45DFkN4pliWLxprlkO/Y1IX72mn5szd+piVCqSAaDjE6IZ+hvDV81aDP/tm14Q7DAwiaa3jteZVzZxvoz384G9yR6NjI/kUN/mASqLEED3Wj405Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zswap_store() asks obj_cgroup_may_zswap() whether the memcg is under
its zswap limit. The next patch wants to ask the same question from
reclaim, where it has a memcg but no objcg.

Move the walk into mem_cgroup_may_zswap() taking a memcg and make
obj_cgroup_may_zswap() a wrapper around it. Either way the answer is
the one zswap_store() gets.

No functional change.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/linux/memcontrol.h |  5 +++++
 mm/memcontrol.c            | 26 ++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..dab15db2c61a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1943,11 +1943,16 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg);
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
+static inline bool mem_cgroup_may_zswap(struct mem_cgroup *memcg)
+{
+	return true;
+}
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..f32105a08a91 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6261,8 +6261,8 @@ static struct cftype swap_files[] = {
 
 #ifdef CONFIG_ZSWAP
 /**
- * obj_cgroup_may_zswap - check if this cgroup can zswap
- * @objcg: the object cgroup
+ * mem_cgroup_may_zswap - check if this cgroup can zswap
+ * @memcg: the memory cgroup
  *
  * Check if the hierarchical zswap limit has been reached.
  *
@@ -6272,17 +6272,14 @@ static struct cftype swap_files[] = {
  * spending cycles on compression when there is already no room left
  * or zswap is disabled altogether somewhere in the hierarchy.
  */
-bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+bool mem_cgroup_may_zswap(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg, *original_memcg;
 	bool ret = true;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return true;
 
-	original_memcg = get_mem_cgroup_from_objcg(objcg);
-	for (memcg = original_memcg; !mem_cgroup_is_root(memcg);
-	     memcg = parent_mem_cgroup(memcg)) {
+	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long max = READ_ONCE(memcg->zswap_max);
 		unsigned long pages;
 
@@ -6301,7 +6298,20 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 		ret = false;
 		break;
 	}
-	mem_cgroup_put(original_memcg);
+	return ret;
+}
+
+bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+	bool ret;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return true;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = mem_cgroup_may_zswap(memcg);
+	mem_cgroup_put(memcg);
 	return ret;
 }
 
-- 
2.43.0


