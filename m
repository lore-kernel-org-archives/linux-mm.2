Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66EBFCC6B1F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871EB6B00AF; Wed, 14 Oct 2026 05:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8490F6B00B1; Wed, 14 Oct 2026 05:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786276B00B3; Wed, 14 Oct 2026 05:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7896B00AF
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:46:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3EC8120484
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:46:26 +0000 (UTC)
X-FDA: 85320751572.30.955AFCA
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf15.hostedemail.com (Postfix) with ESMTP id D40ECA0008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:46:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NmOPoufl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5g9Mw8eoznlsynpSJ6z9deMC+OBzAzCqHJiI3+n9U7c=;
	b=gxEnO2+VutMuosWQDYpCWGanLKYufnIl17zmPSSEPYqKoxJMJdzxxIO2pX/gCtert0JLWz
	2KxFDwyIGZg7x0vafOzmRZ29uVM3U5yubW2hPcls2KCM07uJfTa15QPhOaJSGJDyLyRC9u
	NR3QIvIjgU6AZwy+X1sybhhrlLFQa6c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NmOPoufl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971185;
	b=A0CFU4hmHdS4PrH6tLroaS5dSi0w1qohY92/e6yVnnRvGIqYvUbpXNLkmn0w8+aIgMv07E
	PRslImxMaDdkx7CJi3jVBk4ThCbf6ItdodlMlRlaP8LShYd/rsIc6SqzemNhAAvNut/NIj
	49Tpjij4anCP60qzcP2qoox4Eb2yvbc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971173; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=5g9Mw8eoznlsynpSJ6z9deMC+OBzAzCqHJiI3+n9U7c=;
 b=NmOPouflIqEqOH2cP2X61xIj0lD7N1IcWwvu9ZWYCWbEVxWJkKWHNVAcUivyBsCDWBraID
 gfIhKANvNLEeJyrIsOiOtqgZwHw2VYRJCTZJqahRE9GsTy89NAaJ85gWM29cHTRn20rQdS
 4KZjgfqBr6r2T4eDu9VKcwsk6ljqbi5WV37HJpzm3dIGFXVgbn8XeSBRPUHRM5NqJxeE88
 nobiGYrzgFqAAWP9S3li0Sq64nitxSilDh6mFaoyLQmayg6UowdnzTtATAohMr2KcocsKt
 Wvye9PH3L9IPP7Q6/ePdrzPJUe2Zgh+AvFuusSdx06FBHIvkmranlahIbxlIdg==
Date: Wed, 14 Oct 2026 17:43:45 +0800
Mime-Version: 1.0
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 4/6] sched/numa: make free-space tiering promotion bypass configurable
Message-Id: <20261014094347.99157-5-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26acf4f62+46966f+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: D40ECA0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: wr1r8i3wdjfqmns9jyee4ii9mt9snc16
X-HE-Tag: 1791971184-543297
X-HE-Meta: U2FsdGVkX1/yBX6t369h+5unAwglITOiEyJGqr/UQcFxeYgcXmxWdTdtGmALp7YgaBllA3NY984liq/zPd5E9zbQx6GnuZeKsmli/GLTrq1o8sRPYxFVd8I8BENhO6AWFbqjaxI1YO/NQ+k4/F2DtP2XhUqx6GiWKWJcHe7nYobH/5zpBIhlu4JQtjloIz4cWS9xrqvUZophqxou+LiQs35lxwz7v7boGD2fCNZkNaJ3yn9xe+YJZ6hghdoRvjTRspRdJCulGKfljmomgQksv57OQ26c6+Wr8lTr3GMD1EPHPzq3IghIWBNg0uPjqDof5ytXMUl9nAIzlYkvMHtZED3NynBdEA7GyvnA8mDjlOcH1qji5h9yaP9JVho6pyUOhkl46a3TdBrgeThhm/ogI5nN3OAwe43ebR1ryOWBFOxTNfqyB+KwASejy4fPY0W4QVpVF3jlOD5tpEBaJi7rGC3TBwFB6IBYq9m/3oh1R1OUH+8DleAMGxJetLdxRNe0nZ4BWzV97eL8EO6MQ1hJo+vgRMfjfrQW3feH4v8bVUO1xjmIn7+HfCo6kPW30S2D5HTrxl/4oH+z9bKYs3N6tfo4f5JPHCjY6gIuM6lBFZjZ69FU/r4DqYe7I54kyi30eKVOsaCLSbnYqC9QYn7HUWbsNSrDREmuDFql56Jb6Q8VB2BwgzctsL+xG8diVb8u3lEefc5MbjvIpfHHGutS6m9DFAijTqk30u2mQJsFJZO+1ygvliaEa/YevGP+o8nOTSnr4g9vQ66TlPRTvZMyDAyAx7CN6Jy/HR4VB2a22XL6b/5/b/rH29HPcUD/is0rpUVGKCjiSjxVn70cPDKm/+7WhvSWPJnlNBpiz/Ezy/7OOpoEMUpFQ5eXJOnk87jRzKNZo9s/2ic29EfREGPLBsAIbzQWN8FfUnkV0ugX0ISNWc9x7JhFKm/45DLqeAG4kGQ1wYcYO5gg2xTjjK3
 6PBEYB5t
 9OJj36TkL9imUNepuUTghmR7dJcNkr1laveF3ticLmoFooAYuOLn7Ao1pOfbNSkUBhU6OdpWqakJs8hrdB5IGzAScprzxwLYkUv3mpGK5KYH6V65R8W15t7XSbGnjs0bZ3g8pGL8kilOxrO21iK1StPE8UzqHeLkelBm+RxMccpmo10IFk0Qr90PrAnfyB3gf2vW07SPw4w+8ZHKF/nqtzG4qmFinijec7hWvZxKQFifeQaKDmyph32qXLlmuMJ4kjHvUy9gJzZl9zTGB0GSNlymJVW9uletB8FQp5FgG2lH40wOCjnWBiwPQ5JoQpaspcr1i7Zt8DCljrQNQnM/a3lv6TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory tiering normally promotes any recently accessed slow-tier page if
the target fast-tier node has enough free space. This preserves the
existing policy of filling available fast memory before relying on
hotness and rate-limit control.

That is not always the desired policy. Some workloads may intentionally
place memory across CXL-attached memory and DRAM to use aggregate memory
bandwidth. With the free-space bypass, cold one-shot accesses and bursts
of hot accesses can refill the fast tier and pull the workload away from
that distribution whenever DRAM has free space.

Add kernel.numa_balancing_promote_free_space_bypass. It defaults to 1,
preserving the existing behavior. When cleared, enough free space in the
target fast-tier node no longer bypasses the normal hotness and
rate-limit controls.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/sysctl/kernel.rst | 16 ++++++++++++++
 include/linux/mmzone.h                      |  5 ++---
 kernel/sched/fair.c                         | 23 +++++++++++++++------
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index ffea61d448eb..4a035b18aff4 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -765,6 +765,22 @@ will be limited to be no more than the set value.
 A rule of thumb is to set this to less than 1/10 of the PMEM node
 write bandwidth.
 
+numa_balancing_promote_free_space_bypass
+========================================
+
+Controls whether memory tiering promotion may bypass the normal
+hint-fault hotness check and promotion rate limit when the target
+fast-tier node has enough free space.
+
+The default value is 1.  In this mode, if the fast tier has enough free
+space, recently accessed slow-tier pages can be promoted without the
+hotness check or the promotion rate limit, so the kernel can fill
+available fast-tier capacity.
+
+When set to 0, enough free space no longer bypasses these controls.
+A slow-tier page must pass the normal hotness and rate-limit checks before
+promotion.
+
 oops_all_cpu_backtrace
 ======================
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..5d583b17dfa2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -297,9 +297,8 @@ enum node_stat_item {
 	 */
 	PGPROMOTE_CANDIDATE,
 	/**
-	 * Not rate-limited (NRL) candidate pages for those can be promoted
-	 * without considering hot threshold because of enough free pages in
-	 * fast-tier node.  These promotions bypass the regular hotness checks
+	 * Not rate-limited (NRL) candidate pages that are promoted through the
+	 * free-space bypass. These promotions bypass the regular hotness checks
 	 * and do NOT influence the promotion rate-limiter or
 	 * threshold-adjustment logic.
 	 * This is for statistics/monitoring purposes.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ec8a6bfeb2c7..2e11107bf5ca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -134,6 +134,8 @@ static unsigned int sysctl_sched_cfs_bandwidth_slice		= 5000UL;
 #ifdef CONFIG_NUMA_BALANCING
 /* Restrict the NUMA promotion throughput (MB/s) for each target node. */
 static unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
+/* Preserve the existing default of using free fast-tier space eagerly. */
+static unsigned int sysctl_numa_balancing_promote_free_space_bypass = 1;
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -157,6 +159,15 @@ static const struct ctl_table sched_fair_sysctls[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 	},
+	{
+		.procname	= "numa_balancing_promote_free_space_bypass",
+		.data		= &sysctl_numa_balancing_promote_free_space_bypass,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 #endif /* CONFIG_NUMA_BALANCING */
 };
 
@@ -2816,11 +2827,10 @@ static inline bool cpupid_valid(int cpupid)
 }
 
 /*
- * For memory tiering mode, if there are enough free pages (more than
- * enough watermark defined here) in fast memory node, to take full
- * advantage of fast memory capacity, all recently accessed slow
- * memory pages will be migrated to fast memory node without
- * considering hot threshold.
+ * For memory tiering mode, if the target fast memory node has enough free
+ * pages, recently accessed slow memory pages can bypass the normal hotness
+ * check and rate limit so the fast tier can be filled. The bypass can be
+ * disabled by numa_balancing_promote_free_space_bypass.
  */
 static bool pgdat_free_space_enough(struct pglist_data *pgdat)
 {
@@ -2941,7 +2951,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
+		if (sysctl_numa_balancing_promote_free_space_bypass &&
+		    pgdat_free_space_enough(pgdat)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
 			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
-- 
2.20.1

