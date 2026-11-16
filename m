Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB9E606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 01:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=M2cJoz3v
Received: by kanga.kvack.org (Postfix)
	id 0A6016B05B8; Sun, 15 Nov 2026 20:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056EA6B05B9; Sun, 15 Nov 2026 20:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E874C6B05BA; Sun, 15 Nov 2026 20:52:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C248F6B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:52:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38D821C3EFD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:52:26 +0000 (UTC)
X-FDA: 85439307492.07.AE80953
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf31.hostedemail.com (Postfix) with ESMTP id 791CF20008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:52:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M2cJoz3v;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of jiebin.sun@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=jiebin.sun@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794793944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q3p5Ny9n1tlQYJdeoUKM5vEG7oFiEldi5brekpSeVZA=;
	b=pMs/jmlcYbBam9hUuYzOpQxg4BZbwHbLG5xbjJw+j+B+UQWUK/JaJP7cxIKN3MBvS/FvRl
	efgGBdX5hh4MGVmmYnRvEQOesPlOyLyBPKs4/pgIEDBdXkARPqXFTJeToj4KNbUQHoyquR
	YAVgJ4gSxYvZXbMuX/kSVD7LY276ku8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M2cJoz3v;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of jiebin.sun@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=jiebin.sun@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794793944;
	b=1rbKG8u1lPlXyCxjQ7M6f+ZOQyvhrVACHbpchWsFkuY59bpfBauffnCstD9HWy5TNOkKUq
	Aewa2AC3hXpm3FQ555SHgLIL3VJbTTls84403dVCSnTYqPkyId4gZ/NbEUOZZA09ExlGIY
	IhD/SB2dVt+aa6L35s76FFEKP6Aeobc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794793944; x=1826329944;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3evvT5Cp+KVAXQKYLiXSnN/s+2IfMMah8AYUtGTRNDg=;
  b=M2cJoz3vfvHvax/5Y/2PDxr465aHeiMwNq7Up5SRytECZtbEJt3uWnBo
   a+08281w110GWxOCL2RiR1ft2fo5iLI+mtyZiGhQNZyw4bt29XX4NP8kE
   5uBYRM/03bIRzjghwCn4Yg8O1u0ZZkZjAkqclQ0mTS7pjsvj92X0i9hP2
   99cirTaa+2ZfoTED4OIYiPUppw7X13dbIzGOQqkb+xTdfF4KHNzaA+yjM
   +1My2YB0aOwXQPSQT8FhYkyQnALCnvRHZX8qCrE1kDgj5abgdP/nmh8VB
   xb8oQEpgXISt0hnOM5I+y6g5peByiEee/NiSEvEX29iEYSpekJg+PNWLd
   g==;
X-CSE-ConnectionGUID: kAw+VEMcRKKdKIA7PJS6pQ==
X-CSE-MsgGUID: B8npPT6ERcW7oCxkZGW+3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3561536"
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="3561536"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2026 17:52:23 -0800
X-CSE-ConnectionGUID: AiGtzromTC+xA+xdgiHFKw==
X-CSE-MsgGUID: r0t8OA5lRAaJVSRRofaizA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="9497022"
Received: from linux-pnp-gnr-1.sh.intel.com ([10.239.83.186])
  by fmviesa005.fm.intel.com with ESMTP; 15 Nov 2026 17:52:19 -0800
From: Jiebin Sun <jiebin.sun@intel.com>
To: akpm@linux-foundation.org
Cc: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	linux-rt-devel@lists.linux.dev,
	tim.c.chen@linux.intel.com,
	tianyou.li@intel.com,
	wangyang.guo@intel.com,
	jiebin.sun@intel.com
Subject: [PATCH] lib/percpu_counter: allow concurrent sums with an rwlock
Date: Mon, 16 Nov 2026 09:56:55 +0800
Message-ID: <20261116015655.2744577-1-jiebin.sun@intel.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 791CF20008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: j99693d4ttbf8wcd1a7rpxih1gp5jm6t
X-HE-Tag: 1794793943-581296
X-HE-Meta: U2FsdGVkX1/fNQXR52y+q5bwQs19gqNEHPSHVBX2GMgYSAGoO4QKAx+XHSm11HfuJ7NJNaRULl9kTvAmMbgJ3XUbfxnUz7Tq71YlYe4zr0pYBHa7aJXU7h1sBvAAKV6G4lMkI9xPeUlYYwRDXcc7gA8qijNeAnLNIalDf9nzIuv4wh+RN0iqyfXibFKjPPFyv+bOokjlNAOfYBf61gEGkZse7h1PIU1N80kfl3A+ZxLBtd55+fZbIEzUnD1It5nsePY8NqV/IIOJqSULEPrSDFd5J/d3/iAe5f4l/ws/+6XfUGxTnUpUcEPHfYt4sisoDeti5WMbjECOnHT0TwnpH7AjXfuphxK99emqEfAAmNvegXAfSMWxH5N9t+6o+DtrQcs1UOCfe0TlKGFPTWbGegQ4DiFknYVtVkApntDX3WzTC7Y6hWLtR45yVEDKQCkBGS/zyrt6DrEdYvjMqgQeRT07wYJ1lIu/XFyRDnmllR3liuES/ocqSsuLE/RsHwbLefVBLwZGy4W+pgV4vCkkObCN85HGYupsNfDcK4WNQiZPVRVYJgwLmhAFSinGoJTsBtevwl5CsyToMA6BfzzvVKMQ5hs78aTIn0q21ndkxrMJRbI678ut2ftuKVsIImslcE3EtaZnt+Ub/DGaySS7IeW8j151J77d3bGDMcUpARQWqYjkUHYVYFLKhMvyAu/PcDBKgfDbDQkjtIE/cj9o8+Jt6/Bbr+juExtzO5uW9vfk9n/QPJys1J2dCb0ww6ql2lqmijaH3DKT4hxNXXGUlGu7wdSaQMtR9Hpu76oc9o5zaqWaHXIOGkVIbYx7+IuWzY1cCg10pBop8etOqF3cH/8zfF3UZxngKuyQFBfOylXjhh8AWjrJivTRaDPw9HGosidsKvezP/ZXS7Ww+MuPXd67W15W36Wy2KtesuZ7JZdudy95OYWj8vTwBi5Q4nzXylTOe5tsvjcc4dWvH5Y
 0jeqHCym
 tI5fY4MjZueLE5mG3BrT8mnAbUWUfv9luygERXh3TzA5QJi0I7hATCytqrQHz0qySA1JqljU6LpW1MPx5ikp4JkBgK1Jc3HRbuaVICBOIQ+lSo6N05F1D/pdzdwK/DDUKoGQMU1V/14HO2U6VY4hHsjzeZ7HOJwyeWfQe2ko53LotoCarXI12PrkgabNfSJo7qW2lUom2etVE2MLjenRUOcyVJCMW8T1SmtPn
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

Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
---
 include/linux/percpu_counter.h |  4 ++
 lib/percpu_counter.c           | 71 ++++++++++++++++++++++++++--------
 2 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 3a44dd1e33d2..7b28b0e22207 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -20,7 +20,11 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
+#ifdef CONFIG_PREEMPT_RT
 	raw_spinlock_t lock;
+#else
+	rwlock_t lock;		/* shared for sums, exclusive for updates */
+#endif
 	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 87b261b87b0b..ce0284bacf07 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -15,6 +15,46 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_SPINLOCK(percpu_counters_lock);
 #endif
 
+/*
+ * Non-RT sums share the lock; global updates take it exclusively.
+ * Keep raw spinlocks on RT: rwlocks may sleep and their irqsave variants
+ * do not disable interrupts. Updates run in atomic contexts and need
+ * IRQ exclusion for CPU-local read-modify-write sequences.
+ */
+#ifdef CONFIG_PREEMPT_RT
+#define fbc_lock(fbc)			raw_spin_lock(&(fbc)->lock)
+#define fbc_unlock(fbc)			raw_spin_unlock(&(fbc)->lock)
+#define fbc_lock_irqsave(fbc, f)		raw_spin_lock_irqsave(&(fbc)->lock, f)
+#define fbc_unlock_irqrestore(fbc, f)	raw_spin_unlock_irqrestore(&(fbc)->lock, f)
+#define fbc_read_lock_irqsave		fbc_lock_irqsave
+#define fbc_read_unlock_irqrestore	fbc_unlock_irqrestore
+#else
+#define fbc_lock(fbc)			write_lock(&(fbc)->lock)
+#define fbc_unlock(fbc)			write_unlock(&(fbc)->lock)
+#define fbc_lock_irqsave(fbc, f)		write_lock_irqsave(&(fbc)->lock, f)
+#define fbc_unlock_irqrestore(fbc, f)	write_unlock_irqrestore(&(fbc)->lock, f)
+#define fbc_read_lock_irqsave(fbc, f)	read_lock_irqsave(&(fbc)->lock, f)
+#define fbc_read_unlock_irqrestore(fbc, f) read_unlock_irqrestore(&(fbc)->lock, f)
+#endif
+
+static void fbc_lock_init(struct percpu_counter *fbc,
+			  struct lock_class_key *key)
+{
+#ifdef CONFIG_PREEMPT_RT
+	raw_spin_lock_init(&fbc->lock);
+	lockdep_set_class(&fbc->lock, key);
+#else
+	rwlock_init(&fbc->lock);
+	/*
+	 * rwlock_t normally uses LD_WAIT_CONFIG because it sleeps on RT.
+	 * This counter uses a raw spinlock on RT, so it can be taken under
+	 * raw spinlocks or with IRQs off on every configuration.
+	 */
+	lockdep_init_map_wait(&fbc->lock.dep_map, "&fbc->lock", key, 0,
+			      LD_WAIT_SPIN);
+#endif
+}
+
 #ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
 
 static const struct debug_obj_descr percpu_counter_debug_descr;
@@ -62,13 +102,13 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 	int cpu;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&fbc->lock, flags);
+	fbc_lock_irqsave(fbc, flags);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
 	fbc->count = amount;
-	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+	fbc_unlock_irqrestore(fbc, flags);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -98,7 +138,7 @@ void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 	count = this_cpu_read(*fbc->counters);
 	do {
 		if (unlikely(abs(count + amount) >= batch)) {
-			raw_spin_lock_irqsave(&fbc->lock, flags);
+			fbc_lock_irqsave(fbc, flags);
 			/*
 			 * Note: by now we might have migrated to another CPU
 			 * or the value might have changed.
@@ -106,7 +146,7 @@ void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
 			count = __this_cpu_read(*fbc->counters);
 			fbc->count += count + amount;
 			__this_cpu_sub(*fbc->counters, count);
-			raw_spin_unlock_irqrestore(&fbc->lock, flags);
+			fbc_unlock_irqrestore(fbc, flags);
 			return;
 		}
 	} while (!this_cpu_try_cmpxchg(*fbc->counters, &count, count + amount));
@@ -125,10 +165,10 @@ void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s32 batch)
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
@@ -148,11 +188,11 @@ void percpu_counter_sync(struct percpu_counter *fbc)
 	unsigned long flags;
 	s64 count;
 
-	raw_spin_lock_irqsave(&fbc->lock, flags);
+	fbc_lock_irqsave(fbc, flags);
 	count = __this_cpu_read(*fbc->counters);
 	fbc->count += count;
 	__this_cpu_sub(*fbc->counters, count);
-	raw_spin_unlock_irqrestore(&fbc->lock, flags);
+	fbc_unlock_irqrestore(fbc, flags);
 }
 EXPORT_SYMBOL(percpu_counter_sync);
 
@@ -174,13 +214,13 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 	int cpu;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&fbc->lock, flags);
+	fbc_read_lock_irqsave(fbc, flags);
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
@@ -203,8 +243,7 @@ int __percpu_counter_init_many(struct percpu_counter *fbc, s64 amount,
 	}
 
 	for (i = 0; i < nr_counters; i++) {
-		raw_spin_lock_init(&fbc[i].lock);
-		lockdep_set_class(&fbc[i].lock, key);
+		fbc_lock_init(&fbc[i], key);
 #ifdef CONFIG_HOTPLUG_CPU
 		INIT_LIST_HEAD(&fbc[i].list);
 #endif
@@ -274,11 +313,11 @@ static int percpu_counter_cpu_dead(unsigned int cpu)
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
@@ -354,7 +393,7 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 		return true;
 	}
 
-	raw_spin_lock(&fbc->lock);
+	fbc_lock(fbc);
 	count = fbc->count + amount;
 
 	/* Skip percpu_counter_sum() when safe */
@@ -392,7 +431,7 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 	fbc->count += count + amount;
 	__this_cpu_sub(*fbc->counters, count);
 out:
-	raw_spin_unlock(&fbc->lock);
+	fbc_unlock(fbc);
 	local_irq_restore(flags);
 	return good;
 }
-- 
2.52.0


