Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB001C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5B96B00D0; Mon, 29 Jun 2026 10:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B295B6B00D6; Mon, 29 Jun 2026 10:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16A16B00D8; Mon, 29 Jun 2026 10:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73AE66B00D0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6658A0145
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:38 +0000 (UTC)
X-FDA: 84933216396.15.A7EA259
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD7CFA0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cHLZeesJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744157;
	b=siDHLW7B4mGZVdtlq4T/CxPPwo8d88jnSvCBQn3o39D8T5YVDYaIpAUGlb1LDX9d/asiA1
	HYl7OR7r+qILyUkRS8s47pcKeYGRUxdkmJQs9kVyI4eNgtfkmJdEFlmpA+eQwX640MvB86
	xb5nJa7AH5tEcyk/HGpZ6xmDEgyo17Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/A5qUQIw8r90x8zziiNLiNNeOCcUygdorKeGyY/vQ9w=;
	b=2sq0/T/Fj/lfAi3BdWWI6S9kwbn/8vK5MmNb8gtl/liDUosOpu+FwHlty6hUugZkUddwHJ
	6RdB3ZDiVTrRe1z6zBOMMZF1WfgEMMRvQdfyr3RUD65kc7AfEO4NbbyOmfqP7K6FOjV44k
	ZmQkbChOmLGnyWgS8Qe1CB/NBGVoOp0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cHLZeesJ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/A5qUQIw8r90x8zziiNLiNNeOCcUygdorKeGyY/vQ9w=; b=cHLZeesJ2LsDF63CwK90vGncyR
	pW/j+JKIR2sMX9HGswFPR3g593JfiE7PUeKi8gUcKFsXwtN13j4FPQqw8soj/P5OddLPCJTVlWKsZ
	nV+GQzt0x/Or5kcJiJMaDxpnr8PV/TqoMWjpUrxNlCUYpTOnubWbwO8IMttl0raRrzf/TCcxXf8Cx
	i4zsSCgsBTpGAX9ydteL7WQoDhkOeHeXfVdgmaQk1KeXrXuQzxPnkLf6f0R6GYuDxAnJpL5/xzOGX
	0c9UPXv7bKUbW8u+aWt+Qd8MurARJWF+6TV/9NI9gcnmdGcbtNTxS4CJj/R6FMeSh45kVu2KtVWqu
	JyLtTWbA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDBz-0000000EuWo-2y1V;
	Mon, 29 Jun 2026 14:42:35 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 02/18] locking/lockdep: Add sequence counter to held_lock
Date: Mon, 29 Jun 2026 10:41:29 -0400
Message-ID: <20260629144145.1572283-3-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD7CFA0003
X-Rspam-User: 
X-Stat-Signature: tm4dhhxhmrxqx7gybotkpwrfre6h94gj
X-HE-Tag: 1782744156-778806
X-HE-Meta: U2FsdGVkX1+ZsD1roLr1+gxmyvTAi1b3NV7S4QE9RzvujFbl3zokfJNHAH5A4raKhkCt+uxPKRlnXowaAXN7/x3alxMmUHJ1F0QVFX7xjeK6xzD64cvx+coK4IHJ7kUz1LJANKmdbRBt84WxZYK0dgwL3HObgssX5gM3Z+QbybQDzevmmx8MlRsSJ7JyzisZ5tTgYd5dftAKXrf2es4GuIeQZoUeWzh9uo56w1hauLFVsWDGibTy1SL08d6tWJL4sDy0OS3Abj63MDr8v8ka9wVNqwzqweowKnd/JSuUviMM4fipyCrbIUeiVEbHatWTZ5khKK+ejmQH3auujZ2jOa9IU5uS7M3m2pQ6jbTKvkgr4uAwiNwfwjoM2NNQMweLl6oAs4APzK5B4YyT6tlEtgLDVW3MCHjXnrXD+G3mOsaACN5yrWpXEeekIyA9dbcNFwQIVylJy/inhSoNp9CHg49JOUUiVdQd9VrkTJYvA5/mAs296p2Sr6SKQrzg/0eokaDNFaCpx0hLgnBHdu2GNeHuXpg6nfZKYCJIrRs9bnT86E1nfZvIFBpqIurlZLe9dkjK+5VGgHMoCp+ktYlg5mICbPFt3XtusUXuXA40lt/izAob6c+2BMExO6LcKknnalUJuTOxH5VJUte5xObWCTdbMa+epfVlIjozOpbTjx2ytCyRrNUI0Br+c3TEiWBBi/+b8OMAX1wyPGa0GXqjD/HbS+H8YGH/1CCMMw6bXU94rZg/DIFBBdblZx5cUXWlM0/NkPx35b29hy2fniR+1EBbg52bgCgrxZSpmz9f/evM8StyeA9L5a0yDLWU/bN9hrhWedYNtCTzmjmBbHF7cPCNcEYK8gaEHlJIvMRaK8m/L7FIxxzsQtx7ywe8pjbKiL2H2i+LVEkHoQ/dO7GNvgBrf4TL8VVtEl6A+qWV6gqV4es6R44cPWlbx5om/UXjff3jSNq73EM+XUDbVJB
 xEb4YZHl
 aMqL40YMuFsvK/aEIgeLN8aGfwxGET7PB/3l9TObHYMHxLkC2VYOFgMa33xuzyE5Stu1wxewrrRxvoNx/gAsNWjqFRupa4mtjkTkL3EEleXI1xFjT3HOJT+L/WLb5H6u5iYpy9kpC7ObLWuSn08xueUgzsSraWvTLB2Pk8Wilq8WgPJ+S/rTNTnY0Z8NwXtbuPlDQ9g3ICCSqGCm2wPEeIRBvOChcrWUd/jQn2/nXMuJH/Wmxaw6qVvtj2naERZEzN5XUcoNnNv1NVsyCQ6xW42iVweeumivgUwWpXuYT4WpvSD2ZFhqAT2W/XW9hlh8Z69C/eI+RZtPFJtG/l/to0k6jJz+lbexVE+GQNvEMbBRYq0c8wq+v/cM+ZPSDIVcULEvDCAZvsrnTIKWDzZBaKtkV4vPq/TQ7PMDtJQr+pQan4KEbHrFP/IcLC69E8xenEhVo9MvWFeo6wGsnhyAXyDEoz4j4ipvA8QW6LLK1thjg+z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an 8 bit small sequence counter to the held_lock struct to detect if
the lock as been dropped and reacquired.  This is useful when a data
structure depends on a constant locking context, but is not able to
detect locking and unlocking of the lock through its own API.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/all/h3tpnj5kzcrxms5picmimtkpg4aypcpip5wbd6bt2rpdj5k7eb@nhtzs3lefrkq/
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/lockdep.h       |  3 +++
 include/linux/lockdep_types.h |  3 ++-
 include/linux/sched.h         |  1 +
 kernel/locking/lockdep.c      | 49 ++++++++++++++++++++++++++++++++---
 4 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 621566345406d..a6451ecbbe9a0 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -273,6 +273,9 @@ extern struct pin_cookie lock_pin_lock(struct lockdep_map *lock);
 extern void lock_repin_lock(struct lockdep_map *lock, struct pin_cookie);
 extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 
+extern u32 lock_sequence(struct lockdep_map *lock);
+#define lockdep_sequence(lock)	lock_sequence(&(lock)->dep_map)
+
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
 #define lockdep_assert(cond)		\
diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index eae115a264885..55c4b152fedf7 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -253,7 +253,8 @@ struct held_lock {
 	unsigned int hardirqs_off:1;
 	unsigned int sync:1;
 	unsigned int references:11;					/* 32 bits */
-	unsigned int pin_count;
+	unsigned int pin_count:24;
+	unsigned int seq_count:8;
 };
 
 #else /* !CONFIG_LOCKDEP */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d10..14d5ce8dd6136 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1288,6 +1288,7 @@ struct task_struct {
 	u64				curr_chain_key;
 	int				lockdep_depth;
 	unsigned int			lockdep_recursion;
+	unsigned int			lockdep_seq;
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 2d4c5bab5af88..b2b0a506960b1 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5077,7 +5077,7 @@ static int __lock_is_held(const struct lockdep_map *lock, int read);
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
 			  struct lockdep_map *nest_lock, unsigned long ip,
-			  int references, int pin_count, int sync)
+			  int references, int pin_count, int sync, int seq)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -5183,6 +5183,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->holdtime_stamp = lockstat_clock();
 #endif
 	hlock->pin_count = pin_count;
+	hlock->seq_count = seq;
 
 	if (check_wait_context(curr, hlock))
 		return 0;
@@ -5388,7 +5389,7 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
 				    hlock->read, hlock->check,
 				    hlock->hardirqs_off,
 				    hlock->nest_lock, hlock->acquire_ip,
-				    hlock->references, hlock->pin_count, 0)) {
+				    hlock->references, hlock->pin_count, 0, hlock->seq_count)) {
 		case 0:
 			return 1;
 		case 1:
@@ -5684,6 +5685,24 @@ static void __lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie
 	WARN(1, "unpinning an unheld lock\n");
 }
 
+static u32 __lock_sequence(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	int i;
+
+	if (unlikely(!debug_locks))
+		return ~0;
+
+	for (i = 0; i < curr->lockdep_depth; i++) {
+		struct held_lock *hlock = curr->held_locks + i;
+
+		if (match_held_lock(hlock, lock))
+			return hlock->seq_count;
+	}
+
+	return ~0;
+}
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -5866,7 +5885,8 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0,
+		       ++current->lockdep_seq);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
@@ -5914,7 +5934,8 @@ void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, 0, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1,
+		       ++current->lockdep_seq);
 	check_chain_key(current);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -6000,6 +6021,26 @@ void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie)
 }
 EXPORT_SYMBOL_GPL(lock_unpin_lock);
 
+u32 lock_sequence(struct lockdep_map *lock)
+{
+	unsigned long flags;
+	u32 seq = ~0;
+
+	if (unlikely(!lockdep_enabled()))
+		return seq;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	lockdep_recursion_inc();
+	seq = __lock_sequence(lock);
+	lockdep_recursion_finish();
+	raw_local_irq_restore(flags);
+
+	return seq;
+}
+EXPORT_SYMBOL_GPL(lock_sequence);
+
 #ifdef CONFIG_LOCK_STAT
 static void print_lock_contention_bug(struct task_struct *curr,
 				      struct lockdep_map *lock,
-- 
2.47.3


