Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1C1606A6AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SB3XWdtX
Received: by kanga.kvack.org (Postfix)
	id AC1696B05B0; Sat, 21 Nov 2026 21:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71FC6B05B1; Sat, 21 Nov 2026 21:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AECC6B05B2; Sat, 21 Nov 2026 21:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBC66B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D585A160620
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:47:59 +0000 (UTC)
X-FDA: 85461220278.16.A08BB4B
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	by imf11.hostedemail.com (Postfix) with ESMTP id C9DB240005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:47:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SB3XWdtX;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315678;
	b=7TPMbwDbxy3XH/rYpNaNYbrT7krg7R7Bw+IwiienYVPtvmWssoKkLkFwKkpSOlXeQppmZp
	U0XFQio7soG5G6C1+qlio7U8dPwH0BN+vbN0tGCD2b1zgR8PG7vAquFO1QpdbJrdR0lKXR
	T4+hAhWLj4xfeYDb2chLUVj5XUMgLrI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXpp8sp/GRVRsUtSepKaptGcuvVFgYldxI029IWKwww=;
	b=D05czAYHkyDB144ZUivxn8qKdv6kTjyMCl1T3mYmEH/lbd8vDwfZC+GHe3cqW2vn3Gx7yk
	h4W4C5LsUlll5PRrm1bSA1ILRup4BYfo5+nV6e55mv2m6yqz7QdZKm11IgTsd5iFlz0Qzx
	Ee8RZY4hUYaNJffaxUphAU7wEtcvD2Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SB3XWdtX;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4VmPcRtrp5VsXyo2a9LQORInZeHKK19ZabzxdfHobDU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315676; v=1; x=1795920476;
 b=SB3XWdtX9vVAhV2yqIyXR+Z3FAT3/zOTjYraEr2dZNCwA6Bf6Tyn/9wM94ZqX1O3zQFQDyHK
 w+qv72ybnzH9+o2vqiQ+uVhC/3MoHj0fm0ZzoW+xl/oBGO1XZ8JfBvM2xoNMl5z7VKJu3Odj5Cv
 /kJz20WwIl4HstMbzIeJdiL0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6514b70c0cb31dcf;
	Sun, 22 Nov 2026 02:47:56 +0000
X-Mizu-Trace-ID: 6514b70c0cb31dcf
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/7] memcg: add helpers to handle memory.high overage in long operations
Date: Sat, 21 Nov 2026 18:47:31 -0800
Message-ID: <20261122024737.2741569-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C9DB240005
X-Stat-Signature: sh1n4m7oscws1m4p4iie1tzbpeuanu71
X-Rspam-User:
X-HE-Tag: 1795315677-625143
X-HE-Meta: U2FsdGVkX193rYnBuGVELopqcTYnxS/kY10PuL/Rxhm640OhfFoO1Qf1dSVAUnpCl8sCwhwd4U9uOStMDZKhftV7/KjDXNNQoQZn1YUady0uy9KHxOoeUfNevYPrCkbeHUCn+ik6aVz63vOK5dIG2lpkfNmpHpqF3IDmKHTNehF8o+PlBp3jy3grCzTcs0kz+ZTAVknA7LrNs0KlKGh9kTCwcJsG1TXxXJ6prf6t6ZVv8CYH+dhHooDxNGP/VEFnBJdlGdonv4MhS3GdGO0ZxvrKkcaKu5exP0ZjBrCfmc9mUgaU2ATdYYMgbwHW/mvCIMAGizo2UnVzmqmkmikKweFOjkllWt/fFLKIR2yoH8hlmuZqToZ+1R2mLl5wZTbt8rYs6b5d2GNkwoFpUzNevNL8zvR8/BSK5baA8F1m2d3DUKGwlOqsBL1Oi6HXf3vcyXhr/wDTysU7SVPw5lebSsTZ4yQOrvcA6VoMrnhne82JqDGxZknkPLqFay2MtQ6Lp2OoM+HlupxCPiaGOPjM1JFVz0HJEPAUIfijj5bdSdjMZVNs+Hlh4mYEGEMy2Wx8knrNJha39NQoJPyRQzul0DB2dy3s6Jmm8MAqrYyeFjC58P9ETNbdyBjYNxvm2Tiq/eI27Iaqt869vP4lAIQMKCECPE8VdTKC5ICtARSslSSx2tKN0t/ykXBJwuiD5VLJm+ZqPFXufELj1STygOct8nAdPtrVtn7SpSTIC5Si+wUw+fHhhy7wDtEOMhxoWcXbn+P4TTxHLZa9N8m4NA1aWXav5kqcjRw4GkQSoxxqmAoc+so+TtEfrqH6lTrSUYQNVw1cwMtNJTlce8WGRpIwuaBYshmhiXwnP7FctMBr6UztjubZnBxN/DXooZB/HQ54snZr7q4pZPssYkhH4qpyEWlLZ9Le4Xw2CKhTK34loJNTdKxZYtdSVerH7oUmjVyimniskhHVxaoACKLIbkc
 OdpiaL08
 5XvNkIH+OR4spjHmDJ5g3sN2TtonhSbguTXLV/p0I2aw2GWvJsKi+UQN0YzaeSREf22xb97eAfN2lBBTuTQcfkaPoEKvqKym0HrmFEAyl/F5s3sCVI09C+OR94MMePDpmRphyskPJ79FHBbcJWfN0N58ThNtR78J53LAl73hC8opd0+u4tPz7oO+sekVq/zURnEBLX638JxnivG9zVhBpXJTz1xH3yMkukvcOEnTkyiorRALLlPjAelAGykIb9WB95/Ri/mlk9ib/I87zYStLX5ecZt5JrT5O/gprOjmmDO0jGrQWc4PgA7F/vOcxywv7U5mVIFNhhs5zRF+IrHQBhfbBBJTrZD6leObFeDXdiluHGEuTz/Uzg0rI05bo3ZPo4ddoIa0uo/4ilBKeYFuCt4KchjsNd0fA4CbVjPBhJoltbr6EJMz/CXGG5lcydEJMAeaE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit c9afe31ec443 ("memcg: synchronously enforce memory.high
for large overcharges"), a charge that can block handles memory.high
overage right away once more than a batch is pending. It reclaims and
sleeps with whatever locks the caller holds, so tasks in other cgroups
that need those locks wait too.

A later patch removes that step. Operations that can charge a lot in
one call then need another place to handle the overage: a point in
their loop where they hold no locks, or only the locks of their file.

Add two helpers for them. mem_cgroup_over_high_pending() says whether
more than a batch is pending, the threshold the synchronous step uses.
mem_cgroup_over_high_throttle() handles the overage if so; its comment
says where to call it and which gfp mask to pass. Export
__mem_cgroup_handle_over_high() for filesystems built as modules.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 34 ++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |  1 +
 2 files changed, 35 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..77115fe1873e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -942,6 +942,31 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 		__mem_cgroup_handle_over_high(gfp_mask);
 }
 
+/*
+ * True if the current task has more than a batch of memory.high or
+ * memory.swap.high overage pending. Each charge that finds overage
+ * counts at least a batch.
+ */
+static inline bool mem_cgroup_over_high_pending(void)
+{
+	return unlikely(current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH);
+}
+
+/*
+ * Handle the current task's memory.high overage if more than a batch is
+ * pending, for operations that can charge a lot before they return to
+ * userspace. The task may reclaim and sleep here, so call it only where
+ * other tasks won't wait for it: with no locks held anywhere up the call
+ * chain, or only the locks of the file being worked on. Pass GFP_KERNEL
+ * if no filesystem locks are held, and mapping_gfp_constraint() in file
+ * read and write paths.
+ */
+static inline void mem_cgroup_over_high_throttle(gfp_t gfp_mask)
+{
+	if (mem_cgroup_over_high_pending())
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
+
 unsigned long mem_cgroup_get_max(const struct mem_cgroup *memcg);
 
 void mem_cgroup_print_oom_context(const struct mem_cgroup *memcg,
@@ -1376,6 +1401,15 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 }
 
+static inline bool mem_cgroup_over_high_pending(void)
+{
+	return false;
+}
+
+static inline void mem_cgroup_over_high_throttle(gfp_t gfp_mask)
+{
+}
+
 static inline struct mem_cgroup *mem_cgroup_get_oom_group(
 	struct task_struct *victim, struct mem_cgroup *oom_domain)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 091401cecf39..6d147153bd06 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2707,6 +2707,7 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 out:
 	css_put(&memcg->css);
 }
+EXPORT_SYMBOL_GPL(__mem_cgroup_handle_over_high);
 
 /*
  * Called after @nr_pages were charged to @memcg. If @memcg or one of its
-- 
2.53.1-Meta


