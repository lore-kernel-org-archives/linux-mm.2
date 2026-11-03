Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36EB606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SCI0YPgc
Received: by kanga.kvack.org (Postfix)
	id 702C96B05B2; Tue,  3 Nov 2026 17:31:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD666B05B3; Tue,  3 Nov 2026 17:31:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527066B05B4; Tue,  3 Nov 2026 17:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D816F6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:31:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B5A4C0570
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:55 +0000 (UTC)
X-FDA: 85395256590.26.7B4C70D
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A55B18000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SCI0YPgc;
	spf=pass (imf06.hostedemail.com: domain of 312DqagcKCKANHUHUANGOOGLE.COMLINUX-MMKVACK.ORG@flex--nhuhuan.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=312DqagcKCKANHUHUANGOOGLE.COMLINUX-MMKVACK.ORG@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793745113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiLjmo0Ku8al3hMMt8KalpT5YKclAs+wJ9YFfzSDu7o=;
	b=NdLy/cjYgYVAH84mwWygp5VO5+xFqjoVIEoNZXZNnYzMGul8cHdb1t8vtYADi7EXLvC1nD
	JaZKRLWDT+InIOLOuZsUKo5zwfD/+lV3tDFEp9bU/Y0jlF7SbmYQ2XvoThP5cRisnxO0nr
	/SZ8a8CHYwNUHwXfrGnWdvJ+1SZ5fbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793745113;
	b=uL/Ak41qIygoCO9TL7JLXHBhSfHuc5Zc3JMaO9rViEmfXy3skg5yeA5GrZ4zLvpGw/uNEh
	9UwAyh+LFBZyYZGyXPDQ6UMoAunGdC4CPfQ6E31pwLBvMJeKfXRb0JiwFFbfV6dgXvAw9i
	zz8FtqISpiIJqguM20Kq/uZ8tzhS/sI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SCI0YPgc;
	spf=pass (imf06.hostedemail.com: domain of 312DqagcKCKANHUHUANGOOGLE.COMLINUX-MMKVACK.ORG@flex--nhuhuan.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=312DqagcKCKANHUHUANGOOGLE.COMLINUX-MMKVACK.ORG@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36ca254ca2cso57981eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793745112; x=1794349912; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yiLjmo0Ku8al3hMMt8KalpT5YKclAs+wJ9YFfzSDu7o=;
        b=SCI0YPgc5Rgi/NE74rcqgHXxmcRKcrqUVSp/riVJQAuN1TaViK565T9rjbhTE88F3R
         WbsqNOlxZ25bVzloO7W091pGPrv0eZQnbXWG8QTbCFJiQvE/SnvCuMW39jRm+ITNf/+o
         DKVCvGhR19zW/TD86dY/Ebr/TnNDZUkukbmbgzbMQ//4Q22vH/iAeq+axHVy5OfQKCUi
         M+S6kji+c5InbCQNeQj6r3W/JA13LF7JdWbkPGoxqRTMxdB8t5w75RKoOUOsRSfZwfza
         t33MmGSxGHehhIQIPMsJdattQT9bDP/OOHQ7h8mNaUByj2TuaaWxHa7f3RFdsj81fIlF
         MRmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745112; x=1794349912;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yiLjmo0Ku8al3hMMt8KalpT5YKclAs+wJ9YFfzSDu7o=;
        b=dCA0fQ1v9Vnozusl3s+DwKptnMfXXc9XWH28kJB22tGckhK/BTL7HzZFBPMtGoe/LO
         BE3K5H7/jpdS4shd9puq6E6v/gPgRyOBh3csP68u3gMGpbBy/OUHkrFEIFU2xHOa1Z/Q
         JThvBa6zb7xgIAgEQvXWl8BIlw+T7geT8Lw9+OvfghIrs3b2lgsde0mIYcDR+6KSCu9h
         NXgv8Z43darY8EKHmEPtG1hZ1zjG0G2AWGhVrGrBblHwbsAVdMxuy2t9UEdm/TwC8zqO
         TOGlUvxx55sxkQ9oAqdVwYsv/26geqKuo2kCR1nYq20MSwUyTsesmXLgPSzsSsNVtRq/
         5XgA==
X-Forwarded-Encrypted: i=1; AKwUvBwc1J6awkM3w5IYTe+XP4LGuXR88yDB2wsEn9Z6G08dMlHl+vOTZDCQ2DrYJKWToggeqiS2l0vzwg==@kvack.org
X-Gm-Message-State: APuU4Z/18WSMp+g/Ye//aSxbYMY7IXglneXM659/WpSXHufqhFDoJsww
	9vz1jlPb0piXsRMgxPi1LC5kP1E1LaK5eANn6eU8lkUpaT8/63GenPndqpm/afjLXXB+ksovFwJ
	h+wkA/2cmJg==
X-Received: from dlep20-n1.prod.google.com ([2002:a05:701b:4594:10b0:19c:1243:1e3d])
 (user=nhuhuan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:ea46:20b0:1a6:53cc:7454
 with SMTP id a92af1059eb24-1ac5d4b2ad9mr23818615c88.27.1793745111665; Tue, 03
 Nov 2026 14:31:51 -0800 (PST)
Date: Tue,  3 Nov 2026 14:30:24 -0800
In-Reply-To: <20261103223025.2482227-1-nhuhuan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com> <20261103223025.2482227-1-nhuhuan@google.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261103223025.2482227-3-nhuhuan@google.com>
Subject: [RFC PATCH v3 2/3] mm/migrate: introduce async non-temporal migration mode
From: Huan Nguyen <nhuhuan@google.com>
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, jackmanb@google.com, 
	hannes@cmpxchg.org, shivankg@amd.com
Cc: rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, 
	fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, 
	sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, 
	dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, 
	nhuhuan@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uutjnjbmzr5thhpko8ym81mxewb66kxb
X-Rspamd-Queue-Id: 5A55B18000C
X-Rspam-User: 
X-HE-Tag: 1793745113-702847
X-HE-Meta: U2FsdGVkX18WV5Buc17JQWKNL5cv3oGizfKNI64+eHCgMQMLgZ3eHSq0MB8SGU6BGjfvu3rWDwl2NUHqWLZESGFsPGbLBkKVgN32N0N2Hq6rGQQ8W10gCWBdixr2QUenZEJKTcGZJ7cBGR/Gs5svo6cQ9cySuQwlQybwJNWZlkZNDubV+lqgoFxJOHeK9Thp7BJYoYVvlJMHM8bhWEkrCbTRQvFLIAZAZ0vP3jxoExv80nhO/2ttCJfQY1Y4KiBCes3UzGG+/9SvRdOiIMfXfQNWjR2U0d65BHsx8mR4wPybFBz/+oc4Ak5nrhaK6hC2zAHAc/vuy2WJBiuq8E/Ln2vTdE9l4818PsFuqgzcX+3h5ulgHgjfWip8/m/ccoRCGtQgWhW3hcFINinRrmawoFbCNbEiKsNYL8ahYL+8BVPQmqrpmv2TZdvRVJNvEJMRQNoDEK5F7tSetA4e5NBtZLl1u1psmav9giG8uag6FmjiIvXUNHTTVZsPIfGpoLUUVWqToaIUAVWYRmTb0PuKssxH0j3z8M1JgLyMyflDhL0pHXRYTGO61pgPLDAq/a9cjTG6MKTWgGwCFbob6tZ8SsQqtooMM0kFzBbUI1Cxt6GK46skgvrj1JfJaGUqwyS3uq6MsPsR1eh5X+kbQfmktubyvj35OJMro5WP5j+DG5Qi9S2bFNZJrLiz3OzI9j5Em3B6cJZeqOyLIt92uC6QFlK9Kl4C55hcFM8RJdHN98KvchsU5bXauNvo2A7vR5AtBQy7PyGxU0cJdTdcVLfnlyCDEQBVRQs7iitNWD4tp7e5bTuiUHQOo6FxoA9CiYNfxkpDuvNvCdP5L0obPUI3nWoWreLjFUL/2dyyuyPt+h0+UHU2B6+NoEFOpWW5ZlrJe15pVUSCxInWkijsOjrrM+GDvgsYIN7303NyRYz9hDMc3Kji8pyBg7BIb1tKnJJAaDXp3UIOXuMHYOOd8tS
 8WSau1IY
 6jDKdr6EcdbngSVwFYVEXdmEI7ee8foT+UPk4BcBlQpjd2kRUFG9ghvpBQlXKL2RIpjXOF+AMKW2JgjMb+qyTJ9KMSaenwmKo/oDdvL9X/M3iKqr0Ecr88VHiA7EWijQfqnfjQneRUPUClW0U8YHT9b38I/1/wEZV/j3iQvG0CpN9b59eIjeLwFYX3ybHMv4AwFhAwH7zPnI9EB668pDB9pgLK7IIOvyr75fbWGk2G3fgAij2chzHWQcGRkRmW8gqe9RWRdc1ufGqECkhGS8xD+rTxWnZr7O88elBARYmobVKbKr94C5qTxLyAt7tGbfyo6e8fItQBbj3KcKRek61e+5nNAwHQuPro+a+tcXCuPNvy2nzsDTbGV0/W2cvpR6HGka1x6YfzL5sgDth4nXlytQiZksZNaX353MN3rQzTZ7gjRdIrjL83m2OKNR1MYf1Jf/DhcVuxNdA4SjER/+lJZlyn8lwejduHA2fUOlwUwO9bIhWm5o1KbruJwqxJ/ytdGUS9z4ZKWzWxR0OKfIGyWfdtKEseJRs6qCGri++zduHqVx0L9NQT9aHVvuTMOSIwMl9eeUA6EZ15yqE6ybGvnGvI+sJw1aIcbrelmfjGlHOyU6LzdVSfGc2xhD/wlZg6CtXYU/1dOO9TSlhKQDmq6W1w6aP0gUFiX1xtij1jFfmno9OdHLVNz5hog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Introduce MIGRATE_ASYNC_NONTEMPORAL to migrate cold folios using
non-temporal stores, avoiding CPU cache pollution.

Existing callers check "mode == MIGRATE_ASYNC" directly, which would
cause new asynchronous modes to fall back to synchronous handling.
Introduce migrate_is_async() and update callers across compaction,
NFS, and migration.

In __migrate_folio(), invoke folio_mc_copy_nt() when the migration
mode is MIGRATE_ASYNC_NONTEMPORAL.

Suggested-by: Alirad Malek <alirad.malek@zptcorp.com>
Suggested-by: Dimitrios Palyvos-Giannas <dimitrios.palyvos@zptcorp.com>
Signed-off-by: Huan Nguyen <nhuhuan@google.com>
---
 fs/nfs/write.c                 |  2 +-
 include/linux/migrate.h        |  5 +++++
 include/linux/migrate_mode.h   |  1 +
 include/trace/events/migrate.h |  1 +
 mm/compaction.c                | 18 +++++++++---------
 mm/migrate.c                   | 29 ++++++++++++++++++-----------
 6 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0b42d31f7a75..ad28ff48e541 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2128,7 +2128,7 @@ int nfs_migrate_folio(struct address_space *mapping, struct folio *dst,
 	}
 
 	if (folio_test_private_2(src)) { /* [DEPRECATED] */
-		if (mode == MIGRATE_ASYNC)
+		if (migrate_is_async(mode))
 			return -EBUSY;
 		folio_wait_private_2(src);
 	}
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 78424b3824c2..188f9d891a0a 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -51,6 +51,11 @@ struct movable_operations {
 /* Defined in mm/debug.c: */
 extern const char *migrate_reason_names[MR_TYPES];
 
+static inline bool migrate_is_async(enum migrate_mode mode)
+{
+	return mode == MIGRATE_ASYNC || mode == MIGRATE_ASYNC_NONTEMPORAL;
+}
+
 #ifdef CONFIG_MIGRATION
 
 void putback_movable_pages(struct list_head *l);
diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index 05102d4d2490..fd752fddc972 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -12,6 +12,7 @@ enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_ASYNC_NONTEMPORAL,
 };
 
 enum migrate_reason {
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 15ee2ef201b5..0bb2444211af 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -9,6 +9,7 @@
 
 #define MIGRATE_MODE						\
 	EM( MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
+	EM( MIGRATE_ASYNC_NONTEMPORAL, "MIGRATE_ASYNC_NONTEMPORAL") \
 	EM( MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT")		\
 	EMe(MIGRATE_SYNC,	"MIGRATE_SYNC")
 
diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb201..c11739e6891f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -445,7 +445,7 @@ static void update_cached_migrate(struct compact_control *cc, unsigned long pfn)
 	/* Update where async and sync compaction should restart */
 	if (pfn > zone->compact_cached_migrate_pfn[0])
 		zone->compact_cached_migrate_pfn[0] = pfn;
-	if (cc->mode != MIGRATE_ASYNC &&
+	if (!migrate_is_async(cc->mode) &&
 	    pfn > zone->compact_cached_migrate_pfn[1])
 		zone->compact_cached_migrate_pfn[1] = pfn;
 }
@@ -508,7 +508,7 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
 	__acquires(lock)
 {
 	/* Track if the lock is contended in async mode */
-	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
+	if (migrate_is_async(cc->mode) && !cc->contended) {
 		if (spin_trylock_irqsave(lock, *flags))
 			return true;
 
@@ -882,7 +882,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			return -EAGAIN;
 
 		/* async migration should just abort */
-		if (cc->mode == MIGRATE_ASYNC)
+		if (migrate_is_async(cc->mode))
 			return -EAGAIN;
 
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
@@ -893,7 +893,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 	cond_resched();
 
-	if (cc->direct_compaction && (cc->mode == MIGRATE_ASYNC)) {
+	if (cc->direct_compaction && migrate_is_async(cc->mode)) {
 		skip_on_failure = true;
 		next_skip_pfn = block_end_pfn(low_pfn, cc->order);
 	}
@@ -1409,7 +1409,7 @@ static bool suitable_migration_source(struct compact_control *cc,
 	 * allocator fallbacks. For non-movable requests, this helps a
 	 * lot, as they can finally scan movable blocks.
 	 */
-	if (cc->mode != MIGRATE_ASYNC)
+	if (!migrate_is_async(cc->mode))
 		return true;
 
 	/*
@@ -1514,7 +1514,7 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn)
 		return;
 
 	/* Minimise scanning during async compaction */
-	if (cc->direct_compaction && cc->mode == MIGRATE_ASYNC)
+	if (cc->direct_compaction && migrate_is_async(cc->mode))
 		return;
 
 	/* Pageblock boundaries */
@@ -1753,7 +1753,7 @@ static void isolate_freepages(struct compact_control *cc)
 	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
 						zone_end_pfn(zone));
 	low_pfn = pageblock_end_pfn(cc->migrate_pfn);
-	stride = cc->mode == MIGRATE_ASYNC ? COMPACT_CLUSTER_MAX : 1;
+	stride = migrate_is_async(cc->mode) ? COMPACT_CLUSTER_MAX : 1;
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -2565,7 +2565,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 	unsigned long start_pfn = cc->zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(cc->zone);
 	unsigned long last_migrated_pfn;
-	const bool sync = cc->mode != MIGRATE_ASYNC;
+	const bool sync = !migrate_is_async(cc->mode);
 	bool update_cached;
 	unsigned int nr_succeeded = 0, nr_migratepages;
 	int order;
@@ -2588,7 +2588,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
 						       cc->highest_zoneidx,
 						       cc->alloc_flags,
-						       cc->mode == MIGRATE_ASYNC,
+						       migrate_is_async(cc->mode),
 						       !cc->direct_compaction);
 		if (ret != COMPACT_CONTINUE)
 			return ret;
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..18470de10857 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -876,9 +876,15 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 	if (folio_ref_count(src) != expected_count)
 		return -EAGAIN;
 
-	rc = folio_mc_copy(dst, src);
-	if (unlikely(rc))
-		return rc;
+	if (mode == MIGRATE_ASYNC_NONTEMPORAL) {
+		rc = folio_mc_copy_nt(dst, src);
+		if (unlikely(rc))
+			return rc;
+	} else {
+		rc = folio_mc_copy(dst, src);
+		if (unlikely(rc))
+			return rc;
+	}
 
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
 	if (rc)
@@ -921,7 +927,7 @@ static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 
 	do {
 		if (!trylock_buffer(bh)) {
-			if (mode == MIGRATE_ASYNC)
+			if (migrate_is_async(mode))
 				goto unlock;
 			if (mode == MIGRATE_SYNC_LIGHT && !buffer_uptodate(bh))
 				goto unlock;
@@ -1229,7 +1235,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst->migrate_info = 0;
 
 	if (!folio_trylock(src)) {
-		if (mode == MIGRATE_ASYNC)
+		if (migrate_is_async(mode))
 			goto out;
 
 		/*
@@ -1334,7 +1340,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		try_to_migrate(src, migrate_is_async(mode) ? TTU_BATCH_FLUSH : 0);
 		old_folio_state |= FOLIO_WAS_MAPPED;
 	}
 
@@ -1592,7 +1598,7 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 {
 	int rc;
 
-	if (mode == MIGRATE_ASYNC) {
+	if (migrate_is_async(mode)) {
 		if (!folio_trylock(folio))
 			return -EAGAIN;
 	} else {
@@ -1826,7 +1832,7 @@ static int migrate_pages_batch(struct list_head *from,
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
-	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
+	VM_WARN_ON_ONCE(!migrate_is_async(mode) &&
 			!list_empty(from) && !list_is_singular(from));
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
@@ -2134,7 +2140,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		list_cut_before(&folios, from, &folio2->lru);
 	else
 		list_splice_init(from, &folios);
-	if (mode == MIGRATE_ASYNC)
+	if (migrate_is_async(mode))
 		rc = migrate_pages_batch(&folios, get_new_folio, put_new_folio,
 				private, mode, reason, &ret_folios,
 				&split_folios, &stats,
@@ -2156,8 +2162,9 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		 * with minimal effort, force MIGRATE_ASYNC mode and retry once.
 		 */
 		migrate_pages_batch(&split_folios, get_new_folio,
-				put_new_folio, private, MIGRATE_ASYNC, reason,
-				&ret_folios, NULL, &stats, 1);
+				put_new_folio, private,
+				migrate_is_async(mode) ? mode : MIGRATE_ASYNC,
+				reason, &ret_folios, NULL, &stats, 1);
 		list_splice_tail_init(&split_folios, &ret_folios);
 	}
 	rc_gather += rc;
-- 
2.56.0.398.g882cbad275-goog


