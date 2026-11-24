Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF1E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 05:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hohOI/O5
Received: by kanga.kvack.org (Postfix)
	id D04116B05F2; Tue, 24 Nov 2026 00:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC796B05F3; Tue, 24 Nov 2026 00:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1906B05F4; Tue, 24 Nov 2026 00:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7E46B05F2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:15:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D236140AB4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:15:41 +0000 (UTC)
X-FDA: 85468850082.17.15FE400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44F1D40002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:15:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hohOI/O5";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of jiebin.sun@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=jiebin.sun@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795497339;
	b=2cUGDkRtfDc3MOK+iIznmriED/xariaA0fZM2RG1aIL+ZSJynrSNHCBuCI/DpRh/kNJwFv
	I4jZnbGxl7/+0kpOog9KOJOulm16URMJytUgtl/wKqyGQigOwKbK9Q3BSntVoWPgjRMZAS
	TkOWWW+HBZbgHLgOOO4kIGagzlSUXWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795497339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7vHjvmD/PBQZO1TvMxOYcbhdY53Pzfcnl62FBgloeOM=;
	b=atsCKOlC9RENHYRy2QUGDdCZJvu3pGduS/GNfgSCu3ODRYCPgQEwVHxMtC4cfQK0Bhu+jR
	oAiKIg1AzI/gbkHuwFiy4caCUqjQFQqv6HR3vo4SIb3HosUu5IZWOi1M5MEjZ5gpScJrFK
	UtlTLgEj4eYBS2qT6VwJQWFDpqn9x3s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hohOI/O5";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of jiebin.sun@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=jiebin.sun@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795497338; x=1827033338;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YqOdD8uGwOjh3QOL1+7zMtLz55iOD5EU0eL7Q3rsA9U=;
  b=hohOI/O5tR5smnbkWeeir7vIEuek5cdMyGGNGeZLgzwnruLPoBYvDYaR
   JFBYj7/SliFCw2KgSN40Vnn0ES0CsbK10QUy/7+5vDmrkYZ9PDAgRbJ8o
   34pWApNMYSZV4IAfqfE2wpR9noMEHviy4sMXzQQ3LpCfVGO8JajFIJKv7
   yuczAoSbdSxiiL7Jgwc7r9N1DJFE75Yo+qw3u80/EpqK8SX/faSnDlV80
   K4VTOC7V4OcpepenENh+3XJMEGLfXSG7+9JiediNrkJlVWaHpBH1alcos
   GVzcAep8MICy6z+vOwSPb71X3ydS+0F7so95uDDm7TMfc7NgD049notDw
   w==;
X-CSE-ConnectionGUID: tho3IALLQVa3PW0zcpfu9w==
X-CSE-MsgGUID: 8f4HKQAtR2CBogoG2HnuUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11975"; a="4209945"
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="4209945"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2026 21:15:36 -0800
X-CSE-ConnectionGUID: csY2rVqoSoiH5F/p0ILSUg==
X-CSE-MsgGUID: jOkqv0guQdKI43BJpjnUBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,230,1787036400"; 
   d="scan'208";a="11809953"
Received: from linux-pnp-gnr-1.sh.intel.com ([10.239.83.186])
  by fmviesa007.fm.intel.com with ESMTP; 23 Nov 2026 21:15:33 -0800
From: Jiebin Sun <jiebin.sun@intel.com>
To: akpm@linux-foundation.org,
	bigeasy@linutronix.de
Cc: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	linux-rt-devel@lists.linux.dev,
	tim.c.chen@linux.intel.com,
	tianyou.li@intel.com,
	wangyang.guo@intel.com
Subject: [PATCH v2] lib/percpu_counter: allow concurrent sums with an rwlock
Date: Tue, 24 Nov 2026 13:19:52 +0800
Message-ID: <20261124051952.1059282-1-jiebin.sun@intel.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q7uh81tsynbt48mhdj6g8isss11bmo3t
X-Rspamd-Queue-Id: 44F1D40002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795497337-859589
X-HE-Meta: U2FsdGVkX18nQXK4cmsCZzGXiYc5fCaoUkiM67UB0O9Qn9jcbsnde5KJPmNwMdApgORVnTpqZjccS+RR9ZZgrgPMWl2F9X0DjcUjcen0xGlhZ9l932EM7RlSxr0Y2ALckD9+VmrdBcPSHVIKjj36f+3QdcVdMtxwprWvxqh6wikowS0ekBjsCKsfhWg8xN5M9ZhQ3wQqMaE6NL/bGoQm+4roPAsy956fPWRXSqWqOkUph3f0KaUXdFt19lhZlV+dUFUyl4j87+an2X2t2Rcue3on4udAzx9RFKp+st+YzKzBldh1GB6wyLdXZz57BQsDz8qLsvTC89QC5RUqxlJCP46AtlGhNaGv9oCRUGvURLYlFsF+JZ3KSc3U03xsShYQlsMBP98+/mhffO85rUOhvB+cLjq7SGH/GTZbR/Z1pyVi7CtYJFQq6XQdbtjghDBDFlFqun47mskC4SCICWAGiUU6gDkbY3DDEFRzOwG0aV+6LwJoF453M9byYrk9fZJzG4LV0iGgsWJNm1Vp3EXiakkNLw+1LIjxHWgm1zXNja9upQ1cxTvZ6k19gpaD7ahQB8mLnj9jQs2i3RZ7s16opP7yDEE5cq8lExVq6zKvW9IGSNHBsTyJqJ60w+A+APIck9g73Z2wq62S5byyKZkzqKcmGXWSjTsykZ72mLa2v+puQYD+k3LiD4D0s4huZW5V13EebUxnocJjZILysZZh4h16/rg7hoOocDEefivjAMKsMfnegyeS+alAGyiGGIB8K8PNdJcV9uYc9+4Bc/DdMu1dViev9weBj3QBufNsySOXcoOvNmjjS0ZeuYd6Azhh1AAQwME6D+ila6EUCZ59UMYaIcwnhPa9H5ce7Cyc2mDRubVv1oh+HZ34zF2mUMTDMbTcqLW+oGd+4re49/UvEGyQQ7qOda7SW4XL+ePUuHqLzzjGraDPS4k/AI2GQnTYgWd9IviT3vspl8+jhyX
 rcTkucZ2
 Ox0hkCBXCEcdyr3fN3Pnfk4WEBN1qerOMgd41MSOfHHEx23zuhRstQhXTmo7SfLksRCk6gOxiiz6KBbV5R0EdE4xiYC7puXQImG8KKreQud864338xpy04fKrb+Qasm8Qbx4jnnnw/7tv7Uico42RaS96U5EWa+ySaX6Vleh+IEvqp5R7AjNAvwa9838BIOY8+g608WJI4xugdU4r/f6ocYF1KyMjUTmjVplBqFkvl1uWMBt/URs3by8Jck8syQvTSG2islj6XQF+VtbFXZzr1P4nylM9uBsSyH0nTurC02ZkPTgpzyxj3s0VGA7UbPkFWHNReR9z4hU82W8MKKzSkcFqN4SD2S0VLUn9lGoNkbQx+qtJvIUDtecWkQGH+WurNmZzzwrVxV9umoOJLrdeMnu+wUfM7r7YxZfdbARnwjyQxcJOootUq6nSa4Zy73Xz6IN9gX4sRrQ4UJJ7i/JgVo43dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__percpu_counter_sum() holds a raw spinlock while reading the global
count and per-CPU deltas, serializing concurrent sums of the same
counter. Since a sum changes neither the global count nor the per-CPU
deltas, use rwlock_t on !PREEMPT_RT to allow concurrent sums with a
read lock. Global updates take the write lock. The per-CPU fast path
remains lockless, so sums keep their existing snapshot semantics.

stress-ng dentry reaches this path through ext4_statfs():

  statfs -> ext4_statfs -> __percpu_counter_sum
         -> native_queued_spin_lock_slowpath

ext4_statfs() uses percpu_counter_sum_positive(), which calls
__percpu_counter_sum(). At low writeback thresholds, dirty throttling
also reaches percpu_counter_sum_positive() through wb_stat_sum().
Buffered writers sharing a writeback instance can sum the same page
counters concurrently.

Keep the raw spinlock on PREEMPT_RT, where rwlock_t can sleep.
Global counter updates can run in atomic context and must not sleep.

stress-ng dentry test average throughput change:

  +------------------------+------------+--------------------+
  | Case                   | Unit       | Average change (%) |
  +------------------------+------------+--------------------+
  | Dentry, 64 workers     | bogo ops/s |             +47.34 |
  +------------------------+------------+--------------------+

Dentry ran on ext4 with 64 workers pinned to physical CPUs:

  stress-ng --dentry 64 --dentries 4096 --timeout 20s

fio results from the review thread (3 x 60 s per batch, vs. mean baseline):

  +------+------------+-----------------+---------+
  | Test | Throughput | CPU utilization | Cycles  |
  +------+------------+-----------------+---------+
  | fio  |     +6.91% |         -40.41% | -40.80% |
  +------+------------+-----------------+---------+

fio ran on ext4 with 64 buffered jobs, 64 KiB sequential writes,
a 32 GiB memory limit, and 64/32 MiB dirty/background limits.

Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
---
Changes in v2:
- Replace the locking macros with static inline functions.
- Explain the RT lock choice in struct percpu_counter.
- Describe the percpu_counter_sum_positive() and dirty-throttling callers.

v1: https://lore.kernel.org/linux-mm/20261116015655.2744577-1-jiebin.sun@intel.com/

 include/linux/percpu_counter.h |   5 ++
 lib/percpu_counter.c           | 126 ++++++++++++++++++++++++++++-----
 2 files changed, 115 insertions(+), 16 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 3a44dd1e33d2..b3bdae27ece9 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -20,7 +20,12 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
+#ifdef CONFIG_PREEMPT_RT
+	/* Updates can run in atomic context, where an RT rwlock may sleep. */
 	raw_spinlock_t lock;
+#else
+	rwlock_t lock;		/* shared for sums, exclusive for updates */
+#endif
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 87b261b87b0b..a91d20d73a0b 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -15,6 +15,101 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_SPINLOCK(percpu_counters_lock);
 #endif
 
+#ifdef CONFIG_PREEMPT_RT
+static inline void fbc_lock(struct percpu_counter *fbc)
+{
+	raw_spin_lock(&fbc->lock);
+}
+
+static inline void fbc_unlock(struct percpu_counter *fbc)
+{
+	raw_spin_unlock(&fbc->lock);
+}
+
+static inline unsigned long fbc_lock_irqsave(struct percpu_counter *fbc)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&fbc->lock, flags);
+	return flags;
+}
+
+static inline void fbc_unlock_irqrestore(struct percpu_counter *fbc,
+					 unsigned long flags)
+{
+	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+}
+
+static inline unsigned long fbc_read_lock_irqsave(struct percpu_counter *fbc)
+{
+	return fbc_lock_irqsave(fbc);
+}
+
+static inline void fbc_read_unlock_irqrestore(struct percpu_counter *fbc,
+					      unsigned long flags)
+{
+	fbc_unlock_irqrestore(fbc, flags);
+}
+
+static inline void fbc_lock_init(struct percpu_counter *fbc,
+				 struct lock_class_key *key)
+{
+	raw_spin_lock_init(&fbc->lock);
+	lockdep_set_class(&fbc->lock, key);
+}
+#else
+static inline void fbc_lock(struct percpu_counter *fbc)
+{
+	write_lock(&fbc->lock);
+}
+
+static inline void fbc_unlock(struct percpu_counter *fbc)
+{
+	write_unlock(&fbc->lock);
+}
+
+static inline unsigned long fbc_lock_irqsave(struct percpu_counter *fbc)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&fbc->lock, flags);
+	return flags;
+}
+
+static inline void fbc_unlock_irqrestore(struct percpu_counter *fbc,
+					 unsigned long flags)
+{
+	write_unlock_irqrestore(&fbc->lock, flags);
+}
+
+static inline unsigned long fbc_read_lock_irqsave(struct percpu_counter *fbc)
+{
+	unsigned long flags;
+
+	read_lock_irqsave(&fbc->lock, flags);
+	return flags;
+}
+
+static inline void fbc_read_unlock_irqrestore(struct percpu_counter *fbc,
+					      unsigned long flags)
+{
+	read_unlock_irqrestore(&fbc->lock, flags);
+}
+
+static inline void fbc_lock_init(struct percpu_counter *fbc,
+				 struct lock_class_key *key)
+{
+	rwlock_init(&fbc->lock);
+	/*
+	 * rwlock_t normally uses LD_WAIT_CONFIG because it sleeps on RT.
+	 * This counter uses a raw spinlock on RT, so it can be taken under
+	 * raw spinlocks or with IRQs off on every configuration.
+	 */
+	lockdep_init_map_wait(&fbc->lock.dep_map, "&fbc->lock", key, 0,
+			      LD_WAIT_SPIN);
+}
+#endif
+
 #ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
 
 static const struct debug_obj_descr percpu_counter_debug_descr;
@@ -62,13 +157,13 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 	int cpu;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&fbc->lock, flags);
+	flags = fbc_lock_irqsave(fbc);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
-	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+	fbc_unlock_irqrestore(fbc, flags);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -98,7 +193,7 @@ void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 	count = this_cpu_read(*fbc->counters);
 	do {
 		if (unlikely(abs(count + amount) >= batch)) {
-			raw_spin_lock_irqsave(&fbc->lock, flags);
+			flags = fbc_lock_irqsave(fbc);
 			/*
 			 * Note: by now we might have migrated to another CPU
 			 * or the value might have changed.
@@ -106,7 +201,7 @@ void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 			count = __this_cpu_read(*fbc->counters);
 			fbc->count += count + amount;
 			__this_cpu_sub(*fbc->counters, count);
-			raw_spin_unlock_irqrestore(&fbc->lock, flags);
+			fbc_unlock_irqrestore(fbc, flags);
 			return;
 		}
 	} while (!this_cpu_try_cmpxchg(*fbc->counters, &count, count + amount));
@@ -125,10 +220,10 @@ void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 	local_irq_save(flags);
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (abs(count) >= batch) {
-		raw_spin_lock(&fbc->lock);
+		fbc_lock(fbc);
 		fbc->count += count;
 		__this_cpu_sub(*fbc->counters, count - amount);
-		raw_spin_unlock(&fbc->lock);
+		fbc_unlock(fbc);
 	} else {
 		this_cpu_add(*fbc->counters, amount);
 	}
@@ -148,11 +243,11 @@ void percpu_counter_sync(struct percpu_counter *fbc)
 	unsigned long flags;
 	s64 count;
 
-	raw_spin_lock_irqsave(&fbc->lock, flags);
+	flags = fbc_lock_irqsave(fbc);
 	count = __this_cpu_read(*fbc->counters);
 	fbc->count += count;
 	__this_cpu_sub(*fbc->counters, count);
-	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+	fbc_unlock_irqrestore(fbc, flags);
 }
 EXPORT_SYMBOL(percpu_counter_sync);
 
@@ -174,13 +269,13 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	int cpu;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&fbc->lock, flags);
+	flags = fbc_read_lock_irqsave(fbc);
 	ret = fbc->count;
 	for_each_cpu_or(cpu, cpu_online_mask, cpu_dying_mask) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
-	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+	fbc_read_unlock_irqrestore(fbc, flags);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -203,8 +298,7 @@ int __percpu_counter_init_many(struct percpu_counter *fbc, s64 amount,
 	}
 
 	for (i = 0; i < nr_counters; i++) {
-		raw_spin_lock_init(&fbc[i].lock);
-		lockdep_set_class(&fbc[i].lock, key);
+		fbc_lock_init(&fbc[i], key);
 #ifdef CONFIG_HOTPLUG_CPU
 		INIT_LIST_HEAD(&fbc[i].list);
 #endif
@@ -274,11 +368,11 @@ static int percpu_counter_cpu_dead(unsigned int cpu)
 	list_for_each_entry(fbc, &percpu_counters, list) {
 		s32 *pcount;
 
-		raw_spin_lock(&fbc->lock);
+		fbc_lock(fbc);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
 		fbc->count += *pcount;
 		*pcount = 0;
-		raw_spin_unlock(&fbc->lock);
+		fbc_unlock(fbc);
 	}
 	spin_unlock_irq(&percpu_counters_lock);
 #endif
@@ -354,7 +448,7 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 		return true;
 	}
 
-	raw_spin_lock(&fbc->lock);
+	fbc_lock(fbc);
 	count = fbc->count + amount;
 
 	/* Skip percpu_counter_sum() when safe */
@@ -392,7 +486,7 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 	fbc->count += count + amount;
 	__this_cpu_sub(*fbc->counters, count);
 out:
-	raw_spin_unlock(&fbc->lock);
+	fbc_unlock(fbc);
 	local_irq_restore(flags);
 	return good;
 }

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.52.0


