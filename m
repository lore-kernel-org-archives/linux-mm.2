Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCCFCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDDD6B0093; Mon,  5 Oct 2026 03:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A941D6B0098; Mon,  5 Oct 2026 03:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934A16B0099; Mon,  5 Oct 2026 03:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 672F66B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:06:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4B81A0169
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:06:39 +0000 (UTC)
X-FDA: 85287689718.05.E576C87
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E5F6120004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:06:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RSVtOnhi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791183998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jo7S1SVJIVFyNaxR02icLv8UsKmGCeJaeAs0M/mr6sE=;
	b=HaEl+cgKkN8dtNNQUNOQln/J0Oz4eSwS+C1KZptjy2bmEoIbwkdNfBoa2Ktl+R6rIKChh2
	O9PkUMQuPZizQbNXF5uK3BV5D9FH/uTId0uCm83LcjSd87TnZ/PGSu7+Hcm7WR7DI8L8Ok
	rPmY2kCGyP3JSxNA0CHgL9O75e7LtxI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RSVtOnhi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791183998;
	b=hs4mRF1oflUqlOlkhQ2x9zJXHvfCrqWrS2wMXPlls04wP5gMxg1fNq1ysBZhUHbyW5jxlI
	C+nJyFRGG8T4FatTmQyChPwyokS1RtuKRzmHGFw2HrUj8jv4oC2JObHF0oW9gtHX0Rtnx/
	90jG6G+8nRl1YMQxKXZKVZecIfZptkk=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a1706a2b24so4526965e9.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 00:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183997; x=1791788797; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jo7S1SVJIVFyNaxR02icLv8UsKmGCeJaeAs0M/mr6sE=;
        b=RSVtOnhi5M22wFjncjTcaDmzwDG64jWHp6r1EXDUOVCAi5agcNle8Q6e87yo0A8c3l
         jGNcG7jv51V5KaEFKDgCSrC2eTk0WPxbCzTnkTVcfsAkeYcYi4DuJf286Mh4SBTh53E3
         z0Dlw+AoyVB6cIbHWUiNkvEbMyrSu6BaQvJlp19AEdXTzICcyowEdViNq1Ib/fG0z89l
         51J6A3DOwsJj912YOVmsPAfgURieximm7sdSFeeRC6WxEixHoXh4cJfPfbU0M8bWecN+
         wgMy8MZaxXI2JX37TmuzhiUFpBnQkoOw8Pp0qB7uVu0h0wxJUkogIrDRhg8xgyzlmJ2t
         7s6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183997; x=1791788797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jo7S1SVJIVFyNaxR02icLv8UsKmGCeJaeAs0M/mr6sE=;
        b=iWWUFpgk27zS9MlQflCBVW6ZHyllRSQmjksaDCWi8o5S2qOfyUc0qQ9ZniGoWyioGn
         k5gjtq0VNYmEYBt3pX84ve95gbFX0HkCDgUr5r0KLjOMPDCt+by7ptm1cx9ARnk7XZcs
         AJDxeIZ/C0Fl+RAB3V+UdoDivXsZrg14nmH5fXQaommAr0fCsUJLLfbqfrnLma8GR+Nt
         zbZR/r2ek15hEXIFu7bEKayIN8SVnaIFxTONTUGDAnwlVEJTj37s1LqDMyoioS05mkC0
         3cgfobsIcR+/wrQ9LIX4dULstMfWiMtZLxFva6LKVGrh02TEg6lIvnHmTxKCSqwdtn0q
         v8Bg==
X-Forwarded-Encrypted: i=1; AKwUvBwG195jkorKorxk22HZy1V0oW6RB8pcKqgQ44vGzYu1ohgyiwYdYihfKP1T/w+T9g2T032vZJrKvw==@kvack.org
X-Gm-Message-State: AFuF++nYBK4vEul/4p7/kttwXxgp3kEMpR9NCMBU3atORYi3OczIbH2i
	V8COZUjJynpe9lHvDFHZJ7eXnClZ0KDT5iRWMr7CIKG417bX3ZZ/1wrM
X-Gm-Gg: AYBFou0XZbwT/0cTnEFvO7f2OWNhLG0qkvlAN8idNbQm56VljFGjzAaLJywG8VStMvw
	vpkokU1dxhTkhsfwhNcmDXW6d2m93z93sCyEAbTZeQnOWuo2oJuhsD4Dv+fwB9DIvwtgYv8TKed
	lXnFo91pWwmO00dnMmin0sJCNZQ5ZNUB1AggcjewZx4DcndJ4v4cvPTcYJrAvdo1Mqhl+SO333l
	woKCk/wxvIEvprSriqxXYeOCEtemY7rD98kxv2u6GLYc+4LRkCPxcefRUzrQn1Ww3H021Bzjq++
	viWqNckPqGu3Y8fUkEAOsh9Ydia9AxCGWFlR+GeSGmkb/oUONTOCL86C/cYzvQ0f2xCL1mQIK2q
	rAmt/abUwFDXumFPUzk0TV14P25OCJnY2tM71KL640YrSBGK+ceeiXWuoWR3Jiy/HiYJHXdzcNz
	eMTNA+eIROQE+tEEvDRvAgI9NyaTfyKLTZXrHTeBR+EmZNSaqSA2OHDq2J6wDgT7HQuPXffGA1o
	LWq6HyQpodwFHEeL5Dxe2VzeGiGI5QUOjKingEzvRt35K9uTk6Mhlv3ThnFfZZCbGuexMKliqd3
	zP8lQmhWpjzUNX3b/yKlMl/fboi3Hc0XRS4+FHzit+AheQhPOGIgTiNapi86SU7ICMki9awYQ64
	8usg=
X-Received: by 2002:a05:600c:c165:b0:4a0:108:3b54 with SMTP id 5b1f17b1804b1-4a02758e674mr172507215e9.32.1791183996516;
        Mon, 05 Oct 2026 00:06:36 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm283461465e9.10.2026.10.05.00.06.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 05 Oct 2026 00:06:36 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 2/3] mm: use atomic RT trylocks for no-lock allocation
Date: Mon,  5 Oct 2026 09:06:24 +0200
Message-Id: <20261005070625.8871-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E5F6120004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: iomrmsbhr5uhnsx4ciq94j4pp9eundch
X-HE-Tag: 1791183997-577219
X-HE-Meta: U2FsdGVkX18aeGRIE2LSUYylCauPaBPxdcdKO0M1IjUy4NI6FnGArGkzbr9x0Mt7myA30NMSMaMOUmSNnDGhzBML3bF4xUxjsuiuFhcOTOUwJDwvUQAF+MfEg96BUHKLglE8a+HLoeFM4n34Kt4ddW8U8nT92lZL61SWgFvuS1VQ68V7OrWO8Ri8hmMc/WTo0qIR1VP0ZkmIOrJrTAKh2hGFyADM8bWxjsY3w7X/Cf9LNOWN/Mg3F3rTVlA++8X9InEWX+zf6oybRY7latkBuFowF5XDjFsmTaqTkEgS7EQdB1NWHqNUt2nXq+/E0JDWW7qj3nu3cHccO7MjD5FUQiFSOe6tg/3Fu1WMhtzirzI2FSNPkJ2ELS3CjK6eeFZOZ3WcvntGGDtT1x+Zhus5EtSxyjDTHYBQSt9ZGPEq4jYYhkGAzr7koNKNWUg0VWTKiCuL9hYMF1bWWq38Fo3CHEMwCCrG6/8sPdinnMKwJ8+4D4ucDRvzaiqt7vofxrMzsq/0+OGS10Bhcs4+PQBwgWZD6gxpOpznrCjHKHxSjNmv1jhvmBHWb/Z5TpreXqTYrlacgj/R2iNgpNzpWoVIQFM7hhdSKOezVZYXP9SlcKB4dqvCWLyFDQ24moc5AsEcgwmZHorOJsBfcHWQmdeE9VCQm8nP3Ra3tSs6GszgF4+SuW55jXsmz0SSJJYzZDBocySydiRp63kdTFNbkALqp1FdxBXfG3bT9xf2dg1RR0+2JKIA2jXd/bR1S/TiMHSCrnJVniJBIxZqrHc533/2YZVCO7YiRbR9yCE0tVzxZwCnJp2rDkb5YIuuVgNczm1OCNGijXmgL8IamtEkfUsOVAstlZjqTXXf+T5OwlG4IZFy7b+lynQikTLUYBur02wTCeGSVQZMukVgo8MMuYe1filjCIPJildxVULAQ0wDWPhBfejP6xK3Dymn1lpHN6L0m+pOF+hcJjhtNMKc8Dq
 LsQlqLB5
 Izcebg9O22GPQF286IkQDIJygxCaILdeEZvMQzEGJoZkW0O44nSIdCOyOy91wqjQQ4ugIKUOSGVPGTCK2K0GsyEhwVq+DjfAQH6w+pSVMQSYaAFvyAy0YVcyXS0Ne8rylW1w2K/bEjheV63S4PbHxBmeHlsbMzl4A24Aaolw+el3aLlL2mjbbPQ150CO0ylwt9J6P6IS469cGzjbII7O0X3YEs4rYkquuuDmYYR6Uxx1oLL1DUNfV869WzSq0bvfA+E8UueeJprRS3L6ypNPA0WdqEF4/3XBkV7E0ss54Ccm9SZZXT8bWWNTY1ezwfm+T53FAiIegNjx68aX4iY5YqdIpXnbYtr0UlWm4w5tTAcbBCd82A/OzUrWLJGnHVDm2nCkKPmqFgXGnghlKlDT9QePVbvcgW4oWThNoWqc98Z2BbBZ5soXhdVwsWhyHXTsz9xFYC3+rjPBOi7zVd7ncvFT1dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 073d5f156292 ("slab: simplify kmalloc_nolock()") allowed no-lock
slab allocation from preempt-disabled sections again on PREEMPT_RT. The
remaining global allocator locks are backed by rtmutexes. Releasing one
after a successful trylock can enter the rtmutex priority inheritance and
wakeup paths.

BPF task storage from sched_waking can reach this while try_to_wake_up()
holds p->pi_lock:

  try_to_wake_up()
    raw_spin_lock_irqsave(&p->pi_lock)
      bpf_task_storage_get()
        kmalloc_nolock()
          spin_trylock_irqsave(&n->list_lock)
          spin_unlock_irqrestore(&n->list_lock)
            rtmutex wakeup paths

The wakeup from the allocator unlock can re-enter scheduler locking and
deadlock.

Use spin_trylock_nolock_irqsave() for the global SLUB and page allocator
locks. Its atomic owner state avoids the rtmutex slow path for
non-preemptible RT callers. Preemptible callers keep regular RT spinlock
semantics.

Skip per-CPU allocator and memcg caches for non-preemptible RT callers.
Their regular RT local-lock slow paths can take current->pi_lock.

Skipping the per-CPU objcg stock on every accounted no-lock allocation
would otherwise charge a full page each time. Matching frees add prepaid
bytes to objcg->nr_charged_bytes, but the next allocation did not consume
them. Reuse and refill those centralized bytes with cmpxchg when the local
stock cannot be used, and return complete pages once the retained credit
crosses the existing thresholds.

The page allocator has accepted the same contexts since its no-lock
interface was introduced, so apply the atomic trylock rule to both slab
and page no-lock paths. The prerequisite page-free fix keeps successful
no-lock frees out of allocator shuffling and page-reporting notification.

Bypassing the local objcg stock can make a no-lock charge reach
memory.high handling more often. Apply this after David Stevens's pending
change which defers memory.high work from contexts where spinning is not
allowed. Otherwise the existing schedule_work() hazard remains. There is
no build dependency between the changes.

Fixes: 073d5f156292 ("slab: simplify kmalloc_nolock()")
Link: https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com
Link: https://lore.kernel.org/r/20260904173145.2028377-1-stevensd@google.com
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/internal.h   | 27 ++++++++++-----
 mm/memcontrol.c | 90 +++++++++++++++++++++++++++++++++++++++----------
 mm/page_alloc.c | 33 +++++++++++++++---
 mm/slub.c       | 36 +++++++++++++-------
 4 files changed, 142 insertions(+), 44 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..5b8cabaf86df 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1631,18 +1631,27 @@ static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
 	}
 }
 
+/*
+ * On PREEMPT_RT, local_trylock() uses a regular rtmutex-backed spinlock.
+ * Its slow path can take current->pi_lock. Skip these caches when a no-lock
+ * caller is already non-preemptible.
+ */
+#define mm_local_trylock_nolock(lock)					\
+({									\
+	bool __locked = false;						\
+									\
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())		\
+		__locked = local_trylock(lock);				\
+	__locked;							\
+})
+
 static inline bool can_spin_trylock(void)
 {
 	/*
-	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
-	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
-	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
-	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called from hard IRQ or
-	 * NMI.
-	 *
-	 * Note, irqs_disabled() case is ok. spin_trylock() can be called
-	 * from raw_spin_lock_irqsave region.
+	 * PREEMPT_RT no-lock allocation has not been validated in NMI or hard
+	 * IRQ context. Other atomic contexts use
+	 * spin_trylock_nolock_irqsave(), which does not enter the rtmutex PI
+	 * machinery.
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..03a83664f99b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2129,7 +2129,7 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	int i;
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	    !mm_local_trylock_nolock(&memcg_stock.lock))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2243,7 +2243,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	    !mm_local_trylock_nolock(&memcg_stock.lock)) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -3232,7 +3232,7 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 
 static struct obj_stock_pcp *trylock_stock(void)
 {
-	if (local_trylock(&obj_stock.lock))
+	if (mm_local_trylock_nolock(&obj_stock.lock))
 		return this_cpu_ptr(&obj_stock);
 
 	return NULL;
@@ -3336,14 +3336,64 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 	return false;
 }
 
-static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+/*
+ * A failed per-CPU stock trylock normally falls back to charging another
+ * page. No-lock callers can fail that trylock on every allocation, so reuse
+ * the centralized prepaid bytes before charging again. Paired frees return
+ * the bytes here and keep the retained charge bounded instead of adding one
+ * page per allocation.
+ */
+static bool consume_obj_stock_shared(struct obj_cgroup *objcg,
+				     unsigned int nr_bytes)
+{
+	int old = atomic_read(&objcg->nr_charged_bytes);
+
+	do {
+		if (old < 0 || (unsigned int)old < nr_bytes)
+			return false;
+	} while (!atomic_try_cmpxchg(&objcg->nr_charged_bytes, &old,
+				     old - nr_bytes));
+
+	return true;
+}
+
+static unsigned int refill_obj_stock_shared(struct obj_cgroup *objcg,
+					    unsigned int nr_bytes,
+					    bool allow_uncharge)
+{
+	int old = atomic_read(&objcg->nr_charged_bytes);
+	unsigned int new, nr_pages;
+	u64 total;
+
+	do {
+		if (WARN_ON_ONCE(old < 0))
+			return 0;
+
+		total = (unsigned int)old + (u64)nr_bytes;
+		nr_pages = 0;
+		if ((allow_uncharge && total > PAGE_SIZE) || total > U16_MAX) {
+			nr_pages = total >> PAGE_SHIFT;
+			new = total & (PAGE_SIZE - 1);
+		} else {
+			new = total;
+		}
+	} while (!atomic_try_cmpxchg(&objcg->nr_charged_bytes, &old, new));
+
+	return nr_pages;
+}
+
+static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
+			      gfp_t gfp)
 {
 	struct obj_stock_pcp *stock;
 	bool ret = false;
 
 	stock = trylock_stock();
-	if (!stock)
+	if (!stock) {
+		if (!gfpflags_allow_spinning(gfp))
+			ret = consume_obj_stock_shared(objcg, nr_bytes);
 		return ret;
+	}
 
 	ret = __consume_obj_stock(objcg, stock, nr_bytes);
 	unlock_stock(stock);
@@ -3462,9 +3512,8 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
-		nr_pages = nr_bytes >> PAGE_SHIFT;
-		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
-		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
+		nr_pages = refill_obj_stock_shared(objcg, nr_bytes,
+						   allow_uncharge);
 		goto out;
 	}
 
@@ -3548,18 +3597,18 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	size_t remainder;
 	int ret;
 
-	if (likely(consume_obj_stock(objcg, size)))
+	if (likely(consume_obj_stock(objcg, size, gfp)))
 		return 0;
 
 	/*
-	 * In theory, objcg->nr_charged_bytes can have enough
-	 * pre-charged bytes to satisfy the allocation. However,
+	 * For callers which allow spinning, objcg->nr_charged_bytes can have
+	 * enough pre-charged bytes to satisfy the allocation. However,
 	 * flushing objcg->nr_charged_bytes requires two atomic
 	 * operations, and objcg->nr_charged_bytes can't be big.
 	 * The shared objcg->nr_charged_bytes can also become a
 	 * performance bottleneck if all tasks of the same memcg are
-	 * trying to update it. So it's better to ignore it and try
-	 * grab some new pages. The stock's nr_bytes will be flushed to
+	 * trying to update it. So it's better for those callers to ignore it
+	 * and try to grab some new pages. The stock's nr_bytes will be flushed to
 	 * objcg->nr_charged_bytes later on when objcg changes.
 	 *
 	 * The stock's nr_bytes may contain enough pre-charged bytes
@@ -3570,9 +3619,9 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * page uncharge right after a page charge, we set the
 	 * allow_uncharge flag to false when calling refill_obj_stock()
 	 * to temporarily allow the pre-charged bytes to exceed the page
-	 * size limit. The maximum reachable value of the pre-charged
-	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
-	 * race.
+	 * size limit. No-lock callers already tried the centralized bytes
+	 * above. The maximum reachable value of the pre-charged bytes is
+	 * (sizeof(object) + PAGE_SIZE - 2) if there is no data race.
 	 */
 	ret = __obj_cgroup_charge(objcg, gfp, size, &remainder);
 	if (!ret && remainder)
@@ -3640,6 +3689,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		bool consumed;
 
 		slab = virt_to_slab(p[i]);
 
@@ -3662,7 +3712,13 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		 * between iterations, with a more complicated undo
 		 */
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (stock)
+			consumed = __consume_obj_stock(objcg, stock, obj_size);
+		else
+			consumed = !gfpflags_allow_spinning(flags) &&
+				   consume_obj_stock_shared(objcg, obj_size);
+
+		if (!consumed) {
 			size_t remainder;
 
 			unlock_stock(stock);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3e21dc90b858..617997ed40ba 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -142,6 +142,15 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 	pcpu_task_unpin();						\
 })
 
+#define pcp_spin_trylock_nolock(ptr)					\
+({									\
+	struct per_cpu_pages *_ret = NULL;				\
+									\
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())		\
+		_ret = pcp_spin_trylock(ptr);				\
+	_ret;								\
+})
+
 /*
  * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
  * is not compatible with our locking scheme. However we do not need pcp for
@@ -154,6 +163,13 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 
 #define pcp_spin_unlock(ptr)		\
 		BUG_ON(1)
+
+#define pcp_spin_trylock_nolock(ptr)		\
+({						\
+	(void)(ptr);				\
+	NULL;					\
+})
+
 #endif
 
 /*
@@ -1562,7 +1578,8 @@ static void free_one_page(struct zone *zone, struct page *page,
 	unsigned long flags;
 
 	if (unlikely(fpi_flags & FPI_NOLOCK)) {
-		if (!can_spin_trylock() || !spin_trylock_irqsave(&zone->lock, flags)) {
+		if (!can_spin_trylock() ||
+		    !spin_trylock_nolock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
@@ -2544,7 +2561,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	int i;
 
 	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags))
+		if (!spin_trylock_nolock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
@@ -2986,7 +3003,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	if (unlikely(fpi_flags & FPI_NOLOCK))
+		pcp = pcp_spin_trylock_nolock(zone->per_cpu_pageset);
+	else
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
 						order, fpi_flags))
@@ -3231,7 +3251,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	do {
 		page = NULL;
 		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
-			if (!spin_trylock_irqsave(&zone->lock, flags))
+			if (!spin_trylock_nolock_irqsave(&zone->lock, flags))
 				return NULL;
 		} else {
 			spin_lock_irqsave(&zone->lock, flags);
@@ -3380,7 +3400,10 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct page *page;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	if (unlikely(alloc_flags & ALLOC_NOLOCK))
+		pcp = pcp_spin_trylock_nolock(zone->per_cpu_pageset);
+	else
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		return NULL;
 
diff --git a/mm/slub.c b/mm/slub.c
index 544cff39762c..5281f13f210b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3149,7 +3149,7 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 
 	if (likely(allow_spin))
 		spin_lock_irqsave(&barn->lock, flags);
-	else if (!spin_trylock_irqsave(&barn->lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&barn->lock, flags))
 		return NULL;
 
 	if (likely(barn->nr_empty)) {
@@ -3238,7 +3238,7 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
 
 	if (likely(allow_spin))
 		spin_lock_irqsave(&barn->lock, flags);
-	else if (!spin_trylock_irqsave(&barn->lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&barn->lock, flags))
 		return NULL;
 
 	if (likely(barn->nr_full)) {
@@ -3274,7 +3274,7 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
 
 	if (likely(allow_spin))
 		spin_lock_irqsave(&barn->lock, flags);
-	else if (!spin_trylock_irqsave(&barn->lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&barn->lock, flags))
 		return ERR_PTR(-EBUSY);
 
 	if (likely(barn->nr_empty)) {
@@ -3784,7 +3784,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	n = get_node(s, slab_nid(slab));
 	if (allow_spin) {
 		spin_lock_irqsave(&n->list_lock, flags);
-	} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+	} else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags)) {
 		/*
 		 * Unlucky, discard newly allocated slab.
 		 * The slab is not fully free, but it's fine as
@@ -3829,7 +3829,7 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 
 	if (allow_spin)
 		spin_lock_irqsave(&n->list_lock, flags);
-	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags))
 		return false;
 
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
@@ -3902,7 +3902,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 
 	if (alloc_flags_allow_spinning(ac->alloc_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
-	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags))
 		return NULL;
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 
@@ -4506,7 +4506,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 		if (allow_spin) {
 			spin_lock_irqsave(&n->list_lock, flags);
-		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+		} else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags)) {
 			/*
 			 * Unlucky, discard newly allocated slab.
 			 * The slab is not fully free, but it's fine as
@@ -4702,6 +4702,15 @@ bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
 	return memcg_slab_post_alloc_hook(s, flags, size, p, ac);
 }
 
+static __always_inline bool
+cpu_sheaves_trylock(struct kmem_cache *s, bool allow_spin)
+{
+	if (allow_spin)
+		return local_trylock(&s->cpu_sheaves->lock);
+
+	return mm_local_trylock_nolock(&s->cpu_sheaves->lock);
+}
+
 /*
  * Replace the empty main sheaf with a (at least partially) full sheaf.
  *
@@ -4827,6 +4836,7 @@ static __fastpath_inline
 void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags, int node)
 {
 	struct slub_percpu_sheaves *pcs;
+	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	bool node_requested;
 	void *object;
 
@@ -4841,7 +4851,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags,
 		return NULL;
 	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5477,7 +5487,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 		 * But debug caches don't use that and only rely on
 		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
 		 * to allocate from debug caches by
-		 * spin_trylock_irqsave(&n->list_lock, ...)
+		 * spin_trylock_nolock_irqsave(&n->list_lock, ...)
 		 */
 		return NULL;
 
@@ -5980,7 +5990,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!sheaf_try_flush_main(s))
 		return NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6016,7 +6026,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		return false;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6120,7 +6130,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		goto fail;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6163,7 +6173,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 		if (!empty)
 			goto fail;
 
-		if (!local_trylock(&s->cpu_sheaves->lock)) {
+		if (!cpu_sheaves_trylock(s, allow_spin)) {
 			__free_empty_sheaf(s, empty, free_flags);
 			goto fail;
 		}
-- 
2.53.0


