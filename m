Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A899AC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63E26B00A0; Fri, 21 Aug 2026 15:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15586B00A1; Fri, 21 Aug 2026 15:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A9B6B00A2; Fri, 21 Aug 2026 15:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3AE6B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65FDB160237
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:46 +0000 (UTC)
X-FDA: 85126258812.01.65E5B91
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 73EE04000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UfQis+QH;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340404;
	b=gOcbRRqhOJnZNmtqkZV4kh3kWnnKq5TKWrNbz+xeihS4LydPzK549tyytRA/Uu/N8fvEXB
	GcnElV6OE5G8eAtJbr6ySgR1NUGappH1lrFbj42jkxcmWd+AKhoh+g1eCnl8/gYx5drIUA
	ogv+BgT6P+5xd4M1/rUbKA4EMX4tYUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UfQis+QH;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4S/rOt0mQDvJh08Ktp/PKJyybrhsHg85P0NQ476Smw=;
	b=Wxsm+dyesHIPHF2Vx7gtWv6BqKcQ2+5xbgJTyA0aHCXR/609LhCFPHBHjgIrLylEGqZuf/
	bsn3yFjwPUqdeFCUHE638QmWiIkLTTutPrPPAfMC/qgawYo7K0OB+flKwEKCVyQcDB26A+
	yT38XuDqSqlRHQq8f0J9sqlRV65XtlA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=O4S/rOt0mQDvJh08Ktp/PKJyybrhsHg85P0NQ476Smw=; b=UfQis+QHg+fplNIjHjjLL8k/B4
	U5+RrmWAZYfBcOyZKIhgZMPSyGzEuPZN9CmsxG6853PjMDVEXEG3JJAeDxAGhHNqHEJqSFokgBI1C
	q3mXWuUK+xYkdwegJbsih+56fVa80ZpqKo9Hmj7rQt6rXg86Jxb/UnkUDkJ+u4ySrgyhHZYASUc6f
	zb+qrRx5inOaR5slZhmvpm/zhCBCn+ny+6p3wWvoAwr1Pkt42KGX9SWPtNo7yyXBGkoS0aQy7l2h+
	AJZ0tGeUtQCOZYY8hoEoGlUZVlAtVFGjS2LXosMzSiIoqjOOiR5FfNJbOtgXvN3Xu05Gz4dpTAqWU
	dK1aJcTw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUt1-0000000E0gr-04gn;
	Fri, 21 Aug 2026 19:26:43 +0000
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
Subject: [PATCH v3 02/19] locking/lockdep: Add sequence counter to held_lock
Date: Fri, 21 Aug 2026 15:26:10 -0400
Message-ID: <20260821192627.4085470-3-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73EE04000C
X-Stat-Signature: aok9wzt7pgfn5dbbmh8fkupogbhgnby1
X-HE-Tag: 1787340404-649798
X-HE-Meta: U2FsdGVkX18VTWkuXg+roaWCMFkzNL2qayOwnVAMCDCYgXtm94Orub1J+gZkVpcaX35YIhfrfQF/TXiw6rBA1/Cs+E7WFa9BC98hgppTM57WiOQarKXFFihb0vj/JGQw9NwLu7nqPAisqwP2MDu7lsy93snBEchGcyKR0/R7kJLehMSd61UMlQCM9Ep/VQxZr+M5BHAbosgH5aSu6Qu4nOTk/p8RVJ0S8heNmxMIjT2NixFYVjrx/QOlcxKD40beO2X93kwR898QwQfn+tF7UQnQ0rEti9yRlQxnL/7VX4rUK/2QeJPC84aj8cHAt+ifAr1ZjsGJi+7Lp38hRSbjnpi2m7/5Mh7V8ucVs+oh2OOAJcWDheSa2laoiVxJ7JsQlM7LKZr9EGzpUQrTWS7P8izvHOAeaoyc/39kL0G2XroEOQMu7zwopeA6/qqnOOAWP7jZ6Y2ISWQCA2cDdbb/4iv3jL9/ZXmHMh38y4mOzYof2TiZx1Z1EaT1alH1tj0frTHA5hbn0qYL80Um0T1plYLRx4R24CoSN6kCMzW9n3aqhAtH0E922GGsbftdMvZFBbJPJtW134mUsme08WihadnF0+l5A0/dH5Jn6bjUp5U2pK6XCOQH4qkFsSiHMNt6u8WSEe3sk0gia+nKSPfNjClJXd3XZ9HaZQ/d2bwwNfzFYl9QYWYBL36WQKjJzSRrC8ORY46pixWJKgLvaCAvJsAueHF1tre1Fi+uirAz/LnV+FS0ghJx1fZV1KpHLOfZCg/T38KsoSSXEXCEmix4eORxGrsybLtmXebHLT6U0h44+8I/ws4JaLkW4HTpe9XByItHF61EUilQAPSKDC6ujgSqOtHQYOJBYZawW3cOLeqUUt+tf4buW2pfCZGSTA/Ee9At+ttZeqx0c1qOMqoPLWDOgUEMmW++Hv3s+VawGoa9cHTX/+jgzf1PmIA7emUpqHoronXbxYh0agtzF7k
 pMNqJAYm
 fFCPtjBb7Xnd2XoNNBTGzrSNMPGSx2NKuvu9ixiR/836IuJA8J5JroCNW/KZBO/IIX2xWC4NgICyuFNxRC5NMYxbfqf+SnKZ0RZ2IxBcj5KILDos2fmoN8lH0kYxI9N0yY7suuAi39fknFTKFaBZqAO2DS/4o4QekfVVG8CzyHC3FsJa0E+n3N+ss6P6Dzi3Q5GPKp3W3Cg22pvHp+Fd5PcD8HZTUJO/3Nm54JFRomU9lpPy1opAng0dwpqzVCJoZP8CvKSAarnv7b70cIMlpdZmYuR+czFeZJ4eRcIomsZwq+fmIizIjL1iruPxRkXn4tZUNdaTlUO1QvE3XoQe2du7Uvg/eg5o65neWA2E/U/ip7wRga+0EvBdLqAarCn57sGkPlOEUxqogPDVshNVop0+b2v54Cs2vQQWAoHky9TWSK8qOcTZL68O613nSVuybD0k04XTE5XhB23oW7Oo74vEJgdk9x9EMkZ9DGPN9JhuwopI=
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

Since the __lock_unpin_lock() will no longer detect underflow by casting
the unsigned int to a signed int, update the casting code to use a temp
variable for calculations using a signed int.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/all/h3tpnj5kzcrxms5picmimtkpg4aypcpip5wbd6bt2rpdj5k7eb@nhtzs3lefrkq/
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/lockdep.h       |  3 ++
 include/linux/lockdep_types.h |  3 +-
 include/linux/sched.h         |  1 +
 kernel/locking/lockdep.c      | 58 ++++++++++++++++++++++++++++++-----
 4 files changed, 57 insertions(+), 8 deletions(-)

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
index 2d4c5bab5af88..a69567bdd7912 100644
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
@@ -5669,14 +5670,17 @@ static void __lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie
 		struct held_lock *hlock = curr->held_locks + i;
 
 		if (match_held_lock(hlock, lock)) {
+			int pin_count;
+
 			if (WARN(!hlock->pin_count, "unpinning an unpinned lock\n"))
 				return;
 
-			hlock->pin_count -= cookie.val;
+			pin_count = hlock->pin_count - cookie.val;
 
-			if (WARN((int)hlock->pin_count < 0, "pin count corrupted\n"))
-				hlock->pin_count = 0;
+			if (WARN(pin_count < 0, "pin count corrupted\n"))
+				pin_count = 0;
 
+			hlock->pin_count = pin_count;
 			return;
 		}
 	}
@@ -5684,6 +5688,24 @@ static void __lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie
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
@@ -5866,7 +5888,8 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0,
+		       ++current->lockdep_seq);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
@@ -5914,7 +5937,8 @@ void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, 0, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1,
+		       ++current->lockdep_seq);
 	check_chain_key(current);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
@@ -6000,6 +6024,26 @@ void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie cookie)
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


