Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2B81075274
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58386B0430; Thu, 19 Mar 2026 04:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F776B0432; Thu, 19 Mar 2026 04:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945F16B0433; Thu, 19 Mar 2026 04:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 844436B0430
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:20:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E4A313AB6A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:20:43 +0000 (UTC)
X-FDA: 84562116366.18.1C1800E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77391C0006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:20:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=siMioE97;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773908441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ezpg7w5q4XnNfDvDAitPA6Fnpfes/ZiPnx45JraZYPo=;
	b=SerkXuPSe2Sqst2L9UFWSgPcmJbE0nJBKCnJtPNgNeuB5vCTL9v7icn8ob1mmyl8BTngnB
	fz7ilwSaKZxvA81P7csnTziiloxyQh0cTM3PEIVAOU3SIVugOEo9fYfj39G7ygYAN9IgPi
	yECThb0usJiWtYLAYBiLfHrpfQN0I0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773908441; a=rsa-sha256;
	cv=none;
	b=pWwvyzXqVFXU/fWySrZV2RUwjR+TJKBCfUANvOXcV6OZ+ln7hT2X4/LUdGNmprbk/snX7V
	srReTjO4uslDqZzsNJWqdfiNWkS95OWVjfXLIi8lepd6MVF4BR3XvyNfp+l2czqDILWrcm
	fsm6mhL/y/CxpqVuA4aX/ayGtN8v0U0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=siMioE97;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D558E6011F;
	Thu, 19 Mar 2026 08:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B22C19425;
	Thu, 19 Mar 2026 08:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773908440;
	bh=XZSmlU5qQZSk3ikAK6msWkB0C1hCUr2T8dbTi52alcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=siMioE97YWmWg3dsdee3PkKgH+n8pqPcHCbnc6EAggNIaenWaU7afq+6ydhGwa1BV
	 A1iG9LJmU8Lw5Tyz4SQpmVDsf+kP8nwdPtOu2fYoKB7hmSN+p6wqjYPSjuRjkpCvAu
	 yuoo5OzG1ERSTgAj2PzV7QqiSHxS6taM56a0Cg+9bqTj6qeXnvjSmxGHAZ4tkb/Wtw
	 X265+BTIO1cRd7v9TnTwUz5dk9/alFXI0lrS9w9uSVwU17/ghw21lOa64OHs+SuJQc
	 0lM+E29w+qg+o9jxGyY/qD2fpzZewxKBhdYf2j2PJ3cWdle21nX3QEdot45buM5NqD
	 +/zAc5cFalR8A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Mar 2026 09:19:41 +0100
Subject: [PATCH 2/2] mm: introduce CONFIG_NUMA_MIGRATION and simplify
 CONFIG_MIGRATION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260319-config_migration-v1-2-42270124966f@kernel.org>
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
In-Reply-To: <20260319-config_migration-v1-0-42270124966f@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-mm@kvack.org, 
 linux-rt-devel@lists.linux.dev, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77391C0006
X-Stat-Signature: 5fbhxpm7pqihwk6ap5hdub8mna13n8gq
X-HE-Tag: 1773908441-38796
X-HE-Meta: U2FsdGVkX19Iq+9E1rPlrHiXUc1rc24e4Fd/OMEvoO76XGXNTjh/SgXNEuRrhM5n6yZSLTAhCdJDU5pf/7oLYcgsZONe3m4lUhlc58ynUAj57ZUIDwg9l6b4W2KMaYXpDbwyBubCqckW0aXwHB7VHiSQiqMTlT/dpukb+LYUoax+wsIdzWIBSshg+/MfavYjWt2ymZ4Nl9j1Pmdf1L6XZOfw6wUg98T5FxgDrqV5ySJifC6UG8EZ3IADYFVI7hKRQyGDWEZPv8AZEgj1et4YHWf38vLoJVC5x1o0tVD9tRhbJ/GPHgt5Dxa7n/e4INyfe2RD4n8WMfs4pdUnqyQfdDevzLoIJJfblHaOu8A9M5kTP318QWjjHG1As2bQ20+c8cZQI0paw5AKG86/NZb2EYkZsVdYeVhCaI30jUs7X85ciNVPpqjBGSeVguXqVc/mRUz6gotVhz+xJSDPg1cOiTSLaMba4W/H2aX9KFgbMOeQ1uMebuROy3906wX+sonlIH5F/IQUkmiV1Vv0keSB1T5qVyAwdvZw+aGiLq2EloHTUVlokUTdFVFSu/pa2YiOjMYY1+1QQu8jObEXSqajdqSPbpDJSwXvJMw6ql1JFga8bh+JrrD+JH7jR7OZWfBEFNBWPiwg/5+sdvYgZS9X7zZn3QpwgdYPRGDDF6uJpawvSVOQyqah/l7L4b6SrkpMRc339txHkV7k+UaNcXdd5X7dq0XPoexzb2hx12pv793WcPSXW5isnoi3NYJjcdDM+OvTT4DDqMgtVJm0bGpQruf3FIrYlA/CscnCqhFA30bM/Px1q2XH71feT0hfr12szPs0EpUshgZKHJ8NsJ7bkfBLEe6m9H5Gcchka8LcdycKSQvqtQ8N/jXtmLDtCJwEaZ/sBjbe3b/mU/YNCzn5UPVIszTzSBQDeLSi/DBSzJQUGZmc3bB7wT+EovdLc+OLyh0dU8qTAu8odNowAnC
 3be3Smcf
 g2SfvxtJBtd+ZdQus3dUA/4Lgw7deaYEj6tm6MRQ3MUZ44QBjABGyeLIPrO9W2q2+BknvznnAzyOeiMXhp4Nr2+CRJMwhhiJXJcv/Syz+fFP7hKWgoe7dq59gBNMY+3q6af2MBepBE+C/oc++91UXYkLfLEzfrdqBY/GSXBMEanQSK/jqDDIt9DqhDLmCrUsy7AnXTtYXk51WVqkvPOVs7fxerCo+HggEH3ICkzfNnj3al7kbvnKXWf94rblR7xV6BFPHQWOMZjaly17ziy0UxSSD2UFOedL/gOrU4ARFEjMnKuKgCHVyWooogQHIRxMo9dBd+Ol4GfpN0EuLqsDgHcsPiL5WIHbn/DoCTm5Pm5ScXLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_MEMORY_HOTREMOVE, CONFIG_COMPACTION and CONFIG_CMA all select
CONFIG_MIGRATION, because they require it to work (users).

Only CONFIG_NUMA_BALANCING and CONFIG_BALLOON_MIGRATION depend on
CONFIG_MIGRATION. CONFIG_BALLOON_MIGRATION is not an actual user, but
an implementation of migration support, so the dependency is correct
(CONFIG_BALLOON_MIGRATION does not make any sense without
CONFIG_MIGRATION).

However, kconfig-language.rst  clearly states "In general use select only
for non-visible symbols". So far CONFIG_MIGRATION is user-visible ...
and the dependencies rather confusing.

The whole reason why CONFIG_MIGRATION is user-visible is because of
CONFIG_NUMA: some users might want CONFIG_NUMA but not page migration
support.

Let's clean all that up by introducing a dedicated CONFIG_NUMA_MIGRATION
config option for that purpose only. Make CONFIG_NUMA_BALANCING that so
far depended on CONFIG_NUMA && CONFIG_MIGRATION to depend on
CONFIG_MIGRATION instead. CONFIG_NUMA_MIGRATION will depend on
CONFIG_NUMA && CONFIG_MMU.

CONFIG_NUMA_MIGRATION is user-visible and will default to "y". We
use that default so new configs will automatically enable it, just
like it was the case with CONFIG_MIGRATION. The downside is that
some configs that used to have CONFIG_MIGRATION=n might get it
re-enabled by CONFIG_NUMA_MIGRATION=y, which shouldn't be a problem.

CONFIG_MIGRATION is now a non-visible config option. Any code that
select CONFIG_MIGRATION (as before) must depend directly or indirectly
on CONFIG_MMU.

CONFIG_NUMA_MIGRATION is responsible for any NUMA migration code, which is
mempolicy migration code, memory-tiering code, and move_pages() code in
migrate.c. CONFIG_NUMA_BALANCING uses its functionality.

Note that this implies that with CONFIG_NUMA_MIGRATION=n, move_pages() will
not be available even though CONFIG_MIGRATION=y, which is an expected
change.

In migrate.c, we can remove the CONFIG_NUMA check as both
CONFIG_NUMA_MIGRATION and CONFIG_NUMA_BALANCING depend on it.

With this change, CONFIG_MIGRATION is an internal config, all users of
migration selects CONFIG_MIGRATION, and only CONFIG_BALLOON_MIGRATION
depends on it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory-tiers.h |  2 +-
 init/Kconfig                 |  2 +-
 mm/Kconfig                   | 26 +++++++++++++-------------
 mm/memory-tiers.c            | 12 ++++++------
 mm/mempolicy.c               |  2 +-
 mm/migrate.c                 |  5 ++---
 6 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 96987d9d95a8..7999c58629ee 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -52,7 +52,7 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
diff --git a/init/Kconfig b/init/Kconfig
index 444ce811ea67..3648e401b78b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -997,7 +997,7 @@ config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
-	depends on SMP && NUMA && MIGRATION && !PREEMPT_RT
+	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
 	  This option adds support for automatic NUMA aware memory/task placement.
 	  The mechanism is quite primitive and is based on migrating memory when
diff --git a/mm/Kconfig b/mm/Kconfig
index b2e21d873d3f..bd283958d675 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -627,20 +627,20 @@ config PAGE_REPORTING
 	  those pages to another entity, such as a hypervisor, so that the
 	  memory can be freed within the host for other uses.
 
-#
-# support for page migration
-#
-config MIGRATION
-	bool "Page migration"
+config NUMA_MIGRATION
+	bool "NUMA page migration"
 	default y
-	depends on (NUMA || MEMORY_HOTREMOVE || COMPACTION || CMA) && MMU
-	help
-	  Allows the migration of the physical location of pages of processes
-	  while the virtual addresses are not changed. This is useful in
-	  two situations. The first is on NUMA systems to put pages nearer
-	  to the processors accessing. The second is when allocating huge
-	  pages as migration can relocate pages to satisfy a huge page
-	  allocation instead of reclaiming.
+	depends on NUMA && MMU
+	select MIGRATION
+	help
+	  Support the migration of pages to other NUMA nodes, available to
+	  user space through interfaces like migrate_pages(), move_pages(),
+	  and mbind(). Selecting this option also enables support for page
+	  demotion for memory tiering.
+
+config MIGRATION
+	bool
+	depends on MMU
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 986f809376eb..54851d8a195b 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -69,7 +69,7 @@ bool folio_use_access_time(struct folio *folio)
 }
 #endif
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 static int top_tier_adistance;
 /*
  * node_demotion[] examples:
@@ -129,7 +129,7 @@ static int top_tier_adistance;
  *
  */
 static struct demotion_nodes *node_demotion __read_mostly;
-#endif /* CONFIG_MIGRATION */
+#endif /* CONFIG_NUMA_MIGRATION */
 
 static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
 
@@ -273,7 +273,7 @@ static struct memory_tier *__node_get_memory_tier(int node)
 				     lockdep_is_held(&memory_tier_lock));
 }
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 bool node_is_toptier(int node)
 {
 	bool toptier;
@@ -519,7 +519,7 @@ static void establish_demotion_targets(void)
 
 #else
 static inline void establish_demotion_targets(void) {}
-#endif /* CONFIG_MIGRATION */
+#endif /* CONFIG_NUMA_MIGRATION */
 
 static inline void __init_node_memory_type(int node, struct memory_dev_type *memtype)
 {
@@ -911,7 +911,7 @@ static int __init memory_tier_init(void)
 	if (ret)
 		panic("%s() failed to register memory tier subsystem\n", __func__);
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 	node_demotion = kzalloc_objs(struct demotion_nodes, nr_node_ids);
 	WARN_ON(!node_demotion);
 #endif
@@ -938,7 +938,7 @@ subsys_initcall(memory_tier_init);
 
 bool numa_demotion_enabled = false;
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 #ifdef CONFIG_SYSFS
 static ssize_t demotion_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e5528c35bbb8..fd08771e2057 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1239,7 +1239,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
 	return err;
 }
 
-#ifdef CONFIG_MIGRATION
+#ifdef CONFIG_NUMA_MIGRATION
 static bool migrate_folio_add(struct folio *folio, struct list_head *foliolist,
 				unsigned long flags)
 {
diff --git a/mm/migrate.c b/mm/migrate.c
index fdbb20163f66..05cb408846f2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2224,8 +2224,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
 }
 
-#ifdef CONFIG_NUMA
-
+#ifdef CONFIG_NUMA_MIGRATION
 static int store_status(int __user *status, int start, int value, int nr)
 {
 	while (nr-- > 0) {
@@ -2624,6 +2623,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
 {
 	return kernel_move_pages(pid, nr_pages, pages, nodes, status, flags);
 }
+#endif /* CONFIG_NUMA_MIGRATION */
 
 #ifdef CONFIG_NUMA_BALANCING
 /*
@@ -2766,4 +2766,3 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	return nr_remaining ? -EAGAIN : 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
-#endif /* CONFIG_NUMA */

-- 
2.43.0


