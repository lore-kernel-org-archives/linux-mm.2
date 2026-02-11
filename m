Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C63AFE9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653C96B008C; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3B86B0092; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4189A6B0093; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229326B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:23:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D389E89140
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:26 +0000 (UTC)
X-FDA: 84432544812.06.0A79C66
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id 067492000E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wx6om+dw;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770823405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piddMgk1JYD7fpCEJF5CHqiXyLYyeHfb+Th2n1GKhHM=;
	b=FxH3t7ZuMsWwOD0UrUMvSLj36tYbYWEZ2rucJWWy8+nxHg0lH4GyW6KVQU8JvVxELjS1AT
	FUR7ISu1Zg04AtBTrdGxqzAsLLye5skXngMVspL2jtj5rb9zVxvZwswbKDRGFIMWQOfJcI
	3/T2523mG4uU219QsPvqDR4Yk4mu3e4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=wx6om+dw;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770823405; a=rsa-sha256;
	cv=none;
	b=VAJUiNUJkdtQZ1PPgC0xoV5X1C2DIWg/XqmiXd8KAnVOnq3BvhEnvyh0UJl9tvKZM3N6nQ
	fvxRpNpuIOfm1OZkdZAGgDGBdsYtl2fNUc2ZllTzNyXfwDWWrPI8tZP9PeYp9tFEFVrdOT
	XvDuCDFLMCQkH/Fqr97v+yL6r3QBjzQ=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4B54EB258E;
	Wed, 11 Feb 2026 15:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1770823403;
	bh=piddMgk1JYD7fpCEJF5CHqiXyLYyeHfb+Th2n1GKhHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wx6om+dwpVOpcy47oGY15lz8YsL2U1kRYlPk5reCKHou4LGoZ9iItRPGL6CkHwusl
	 0BzxzVp0Ywtog+xhHlPPHn6QKIVegA343/0YUqAqefp2iOykkwe4ny0PsoFxRb2YOz
	 7kzpkg4q6nyLawSG1Mtrp19yC9ZUiI52GmkAp3qw=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 3/4] mm: convert compaction to zone lock wrappers
Date: Wed, 11 Feb 2026 15:22:15 +0000
Message-ID: <3462b7fd26123c69ccdd121a894da14bbfafdd9d.1770821420.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1770821420.git.d@ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 067492000E
X-Stat-Signature: fd6w68izhdmogch5pq6r9d4i7khpehhd
X-Rspam-User: 
X-HE-Tag: 1770823404-668964
X-HE-Meta: U2FsdGVkX1+WaZZh/v8HwKXyiRNPA1buQmbDJqXPIHpCRzEpH9fsel8lyOkIrQhilmHHVPqadNsnTAunhix6NnsYuk4ioYb2blHdV2/fiyFU1KxGLvy9MTXiBdPMWakGu1wxlTZ7oFTJJGAv/CJHrf5hvAYTLsP0+A3REJs45aPhzqkz3Zo7THsf3x8gcdaAhCqqDPPGQ9vlhle6LbfYG9OR0Y9kpSOpjvj4zWrGnV2DeqnYaHQEe99/6oxIVwOituvM9fWpVmtDQKIRMu4s1/p6lmmy74JAGMOZppcPMj+jX9RHfRNMQ7fR7JrGgsb7oAQnOtrX70u7S09QVDi8NQqtDQ10+PZJ5qo2CvnR1hol/gGOor/sq2BIAapggVJ5wx04GCuYWvYQPkOV6FsonTua3LT0t/PfR5PpmEbMOuY0MvYWNtNbguaeoJEpb8tNaVO1ZIULwKIgktHY5LG9lzTybFZnX76IQXfZ9ZmQCasIvimcdlWyv5iVVxqF1ywwyv+xpHtpU+N5S2+sSFCACkx5looQ6TTT2KOCnRIPNROqGxt2316yHovfRqWRSByXXfUjmRAhE5U9B8JKcy7XNsCJCLFtNdNRhwMNdoMdqldDge3cECRE+q7lGZauwpTLgYmxulOcZ1JLnUhCWJWXWb8HMlm4s7YX37bQWFWQEZDvCCs/eZPUzC0ue+h3+GsmmYOZf73pCBHirlPSclG/ZdarkgKgrZf7zdefgSd4KgEiShcKQhmEmZp/agLo3pG57P60LZRCzxogpscgGCzakGsahCr+1BWCO+phyiS/Ivfb1TPs1G1Sx2wdxXn9HmBL/UPZCyQm9KF0euaqVbucRjcK5JSeufetTO5TyEtT+lVAxXAqZYQitWDb8dJzsO+NgWvXk8GzmefBhD4u3FB6nj+g8LXL0aYkTYFiBN1OmvbB0aNhMLwuxQyNDupFTU1wvj6c2iar5p6MWkBGMBY
 +vzIJ+T2
 t7CnEZjipMITosvDbleAEBFa4ULFvAQXtkKQDmVFO+E0FQlaxsRVxbLoWDwEzzk9scpqhg3uScdKDLaE2gAv3KwwePy2R0SnAkL+U3oA3anLZDx7xLM+FiIPxdKqJYCHRcHprY8gxjo8D0F3vdIbGyvr+s/MAXC2f8ugKKPCIMG3bIwTeOneo7lrW6EDPvDEqmTu3hcdt7+9M1TcdsXcYpbiOTUIb04gKjmEoBu7h1E4WyYPaUrs+M4KHkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compaction uses compact_lock_irqsave(), which currently operates
on a raw spinlock_t pointer so that it can be used for both
zone->lock and lru_lock. Since zone lock operations are now wrapped,
compact_lock_irqsave() can no longer operate directly on a spinlock_t
when the lock belongs to a zone.

Introduce struct compact_lock to abstract the underlying lock type. The
structure carries a lock type enum and a union holding either a zone
pointer or a raw spinlock_t pointer, and dispatches to the appropriate
lock/unlock helper.

No functional change intended.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/compaction.c | 108 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 89 insertions(+), 19 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..1b000d2b95b2 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/zone_lock.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -493,6 +494,65 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
 }
 #endif /* CONFIG_COMPACTION */
 
+enum compact_lock_type {
+	COMPACT_LOCK_ZONE,
+	COMPACT_LOCK_RAW_SPINLOCK,
+};
+
+struct compact_lock {
+	enum compact_lock_type type;
+	union {
+		struct zone *zone;
+		spinlock_t *lock; /* Reference to lru lock */
+	};
+};
+
+static bool compact_do_zone_trylock_irqsave(struct zone *zone,
+					    unsigned long *flags)
+{
+	return zone_trylock_irqsave(zone, *flags);
+}
+
+static bool compact_do_raw_trylock_irqsave(spinlock_t *lock,
+					   unsigned long *flags)
+{
+	return spin_trylock_irqsave(lock, *flags);
+}
+
+static bool compact_do_trylock_irqsave(struct compact_lock lock,
+				       unsigned long *flags)
+{
+	if (lock.type == COMPACT_LOCK_ZONE)
+		return compact_do_zone_trylock_irqsave(lock.zone, flags);
+
+	return compact_do_raw_trylock_irqsave(lock.lock, flags);
+}
+
+static void compact_do_zone_lock_irqsave(struct zone *zone,
+					 unsigned long *flags)
+__acquires(zone->lock)
+{
+	zone_lock_irqsave(zone, *flags);
+}
+
+static void compact_do_raw_lock_irqsave(spinlock_t *lock,
+					unsigned long *flags)
+__acquires(lock)
+{
+	spin_lock_irqsave(lock, *flags);
+}
+
+static void compact_do_lock_irqsave(struct compact_lock lock,
+				    unsigned long *flags)
+{
+	if (lock.type == COMPACT_LOCK_ZONE) {
+		compact_do_zone_lock_irqsave(lock.zone, flags);
+		return;
+	}
+
+	return compact_do_raw_lock_irqsave(lock.lock, flags);
+}
+
 /*
  * Compaction requires the taking of some coarse locks that are potentially
  * very heavily contended. For async compaction, trylock and record if the
@@ -502,19 +562,19 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
  *
  * Always returns true which makes it easier to track lock state in callers.
  */
-static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
-						struct compact_control *cc)
-	__acquires(lock)
+static bool compact_lock_irqsave(struct compact_lock lock,
+				 unsigned long *flags,
+				 struct compact_control *cc)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
-		if (spin_trylock_irqsave(lock, *flags))
+		if (compact_do_trylock_irqsave(lock, flags))
 			return true;
 
 		cc->contended = true;
 	}
 
-	spin_lock_irqsave(lock, *flags);
+	compact_do_lock_irqsave(lock, flags);
 	return true;
 }
 
@@ -530,11 +590,13 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
  * Returns true if compaction should abort due to fatal signal pending.
  * Returns false when compaction can continue.
  */
-static bool compact_unlock_should_abort(spinlock_t *lock,
-		unsigned long flags, bool *locked, struct compact_control *cc)
+static bool compact_unlock_should_abort(struct zone *zone,
+					unsigned long flags,
+					bool *locked,
+					struct compact_control *cc)
 {
 	if (*locked) {
-		spin_unlock_irqrestore(lock, flags);
+		zone_unlock_irqrestore(zone, flags);
 		*locked = false;
 	}
 
@@ -582,9 +644,8 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		 * contention, to give chance to IRQs. Abort if fatal signal
 		 * pending.
 		 */
-		if (!(blockpfn % COMPACT_CLUSTER_MAX)
-		    && compact_unlock_should_abort(&cc->zone->lock, flags,
-								&locked, cc))
+		if (!(blockpfn % COMPACT_CLUSTER_MAX) &&
+		    compact_unlock_should_abort(cc->zone, flags, &locked, cc))
 			break;
 
 		nr_scanned++;
@@ -613,8 +674,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 		/* If we already hold the lock, we can skip some rechecking. */
 		if (!locked) {
-			locked = compact_lock_irqsave(&cc->zone->lock,
-								&flags, cc);
+			struct compact_lock zol = {
+				.type = COMPACT_LOCK_ZONE,
+				.zone = cc->zone,
+			};
+
+			locked = compact_lock_irqsave(zol, &flags, cc);
 
 			/* Recheck this is a buddy page under lock */
 			if (!PageBuddy(page))
@@ -649,7 +714,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	}
 
 	if (locked)
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
+		zone_unlock_irqrestore(cc->zone, flags);
 
 	/*
 	 * Be careful to not go outside of the pageblock.
@@ -1157,10 +1222,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
+			struct compact_lock zol = {
+				.type = COMPACT_LOCK_RAW_SPINLOCK,
+				.lock = &lruvec->lru_lock,
+			};
+
 			if (locked)
 				unlock_page_lruvec_irqrestore(locked, flags);
 
-			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			compact_lock_irqsave(zol, &flags, cc);
 			locked = lruvec;
 
 			lruvec_memcg_debug(lruvec, folio);
@@ -1555,7 +1625,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		if (!area->nr_free)
 			continue;
 
-		spin_lock_irqsave(&cc->zone->lock, flags);
+		zone_lock_irqsave(cc->zone, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
 		list_for_each_entry_reverse(freepage, freelist, buddy_list) {
 			unsigned long pfn;
@@ -1614,7 +1684,7 @@ static void fast_isolate_freepages(struct compact_control *cc)
 			}
 		}
 
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
+		zone_unlock_irqrestore(cc->zone, flags);
 
 		/* Skip fast search if enough freepages isolated */
 		if (cc->nr_freepages >= cc->nr_migratepages)
@@ -1988,7 +2058,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		if (!area->nr_free)
 			continue;
 
-		spin_lock_irqsave(&cc->zone->lock, flags);
+		zone_lock_irqsave(cc->zone, flags);
 		freelist = &area->free_list[MIGRATE_MOVABLE];
 		list_for_each_entry(freepage, freelist, buddy_list) {
 			unsigned long free_pfn;
@@ -2021,7 +2091,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&cc->zone->lock, flags);
+		zone_unlock_irqrestore(cc->zone, flags);
 	}
 
 	cc->total_migrate_scanned += nr_scanned;
-- 
2.47.3


