Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF99CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD2A6B0012; Thu, 20 Nov 2025 10:13:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4D16B00D4; Thu, 20 Nov 2025 10:13:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB6E6B00D6; Thu, 20 Nov 2025 10:13:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEFD6B0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68197C0191
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:51 +0000 (UTC)
X-FDA: 84131330262.02.1889279
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 825B340018
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vL+DxtMO;
	spf=pass (imf07.hostedemail.com: domain of 3KzAfaQUKCFg4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3KzAfaQUKCFg4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJMOXRb0WgY3NkQlI/hPCIKlELlXVsKWBZcrKDKyFiM=;
	b=55W6meEo8t7rD5dVfOxbcDZD49n/KmMrVqcQv1V8YZvsHB2fffcQw7zNPFzNGAZyjqZcve
	2s0Ezfe2pIc18555LOTD0eKNqQHizcJ4fPDMY2h6v+ZZQ1kXsWEK1sNWqib8aC/SLK6as5
	nxwiXrfMMgxbFyBEVJB7MXc7iuq48tQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vL+DxtMO;
	spf=pass (imf07.hostedemail.com: domain of 3KzAfaQUKCFg4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3KzAfaQUKCFg4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651629; a=rsa-sha256;
	cv=none;
	b=cdXtguRcbCOiFpKYt40ZwCwe8b7QuuNwcg8J6Ednnzfm1wXCyEgBFs3o8i26Pj8usEcm7g
	j7Zo1hchOgBMaEvFSiQV030Tvk6v6Sb6daXICPoh+xF0WWHJD3XwcpyXZQP8v3qMM/ZWoM
	BqRxKWojsOWEQEA1WfNmVl2bUxr/Efc=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775d110fabso9567665e9.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651628; x=1764256428; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aJMOXRb0WgY3NkQlI/hPCIKlELlXVsKWBZcrKDKyFiM=;
        b=vL+DxtMOkFEd1CMtncXFMGBsMtLdbDw9bXUHLIF4T5p4+Pc6z1+Ta+GvP31D+rUwdv
         46lyw77/r/kAEVsWeHfR8UUEFgzVa0QXdKr6qSTdlr248aZyWIJ0WEVzXvJaA4FG9o0O
         OaXNfVeAcr0ZI5sgUPhUuwuBn3ce2QFnASyKqoVquuzp9HsThJ+igXSoAmu1wBjXnwma
         yIw+y4QDHHSr7j5TEMtaDDwcpyGbBMmnCvu9I4WEuk4tWvtSGkokJG7jvH8X29Go9//5
         K5Px9EOc4LjCWu6YPJIWsg2rhKgF38MQQ4ctpnyJbTKf1oU9c0pAWbLuARIMnkELJuS/
         p3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651628; x=1764256428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aJMOXRb0WgY3NkQlI/hPCIKlELlXVsKWBZcrKDKyFiM=;
        b=eb/bM9/VlZCUOwGDi+doTtbfMoJC7wH8OPuF56Yl+vlhcLyS1tTKO5cPzrKUahWjcP
         Dd4lJwH87TVhmkY/0WzypkI4w1Eb8wQvyoTWVW122duEdfJHXvMNrH5LWkw/kj+9hrfb
         JYIrYZ35oiFyWZuc/XAJKn2XpDQht4utwxVDv+zSIOkOixP7vu/4PMRlZkybpUaAdAaR
         v+KQ3nZLSZHDlMcXwb7l9wnCsKjDDumgQtfVKwrmtg7QHMkONm79FbtoHn0Wg+kFmQow
         DkR/aiwM0ggwVeaE/sC5DZtIXQmZATnvPbcTK4NcmFmnzyEZRutIpSbZj7riJclEQWpL
         gdUw==
X-Forwarded-Encrypted: i=1; AJvYcCVpKP76ZSWu19exHbbxzOHsXtdNFgAp/qoimmhvVMgKbzf67fqxl4qv1kTQUmoHM482PaaYw6WX0w==@kvack.org
X-Gm-Message-State: AOJu0Yx+MN77w0CkwibE2XuvDxd56OhwAAzqY0ZEsi3mZutUS9JbINCJ
	krzVqIAhQrJQQ+SDbQsUEdr7SdQPzrBlcA2PmueIE0utBXSF4Prsmb08mPNt2K8jvaijFIIOoBf
	dRA==
X-Google-Smtp-Source: AGHT+IFOmV1c9L2LvdRR9E5a5WseLoVuoNabSykiYJeUUPoV60hKtqkuL5rUoQ3b9gFsGSgiTWOm153hKQ==
X-Received: from wmpi31.prod.google.com ([2002:a05:600c:4b1f:b0:477:55c0:6392])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f49:b0:477:7991:5d1e
 with SMTP id 5b1f17b1804b1-477b8a9fd96mr32224715e9.25.1763651627745; Thu, 20
 Nov 2025 07:13:47 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:55 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-31-elver@google.com>
Subject: [PATCH v4 30/35] stackdepot: Enable context analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 825B340018
X-Stat-Signature: f55e8nyukn6p5etdmes56a6kds5eotef
X-Rspam-User: 
X-HE-Tag: 1763651629-498129
X-HE-Meta: U2FsdGVkX1+J8Jpmo1kgXG00+3LmiyW1KTB5tiOVhxF+yb+kllOdBEjD4PKkktGUrK05ZdaS+Ndyev+4O+5S4ZpWvKiEJdxQz2T4OdXj+greR6BMBweGIOdgr0iKaUE+JV0mDgpUNV5w7I4cYSUYNHPOzgZmv8lgTDGTSC0yb/R7KNg4DA3xnm/l7jKY9BPq1zWhM5CbzU8km56uJvQQaeW+5QTRGf+yHCDCOZ6C2gagmMMXO2nYdI8EuFyftVVMHGbVScwHXljqg0e1fo54fHwatvmMOLuRqj2L2lGmKbw4DXv4m9Aa6KD2KcnvL948m6fU6QC42C6PqyXgrxy/Jyt89lArfVT6xSXyDTow7atpMyYg+p01hpGg8EIDI/M39iMPpcRDcMGdSFjr9EwLNW1PZrs/lNhjmf6/iGDQxmV3nkz4La+WjjIsT48UOMcENvZaoLgg/scXQs+iDSIFYeH00Tnd2dZ01Yndaf2jPXcpLJVcT7lvOOQKCHORNtks7gcXKfcox9svvGyeEbv2QEOYeIpkdBeMEsOVqVYfI/ZvGbCw11BXo8JntLvptb9xVJaId5/qBa1BCqjTcNP5MyRxU+GWwieLJiqFm715zrWxup1/nVCES3JTEVgGS13OgTfg4vEUDU17qWhfmMBXprqPaKC2La0LGdOhAQzZRc6xXB2+c2xFUgOGL66QVmsgaXqs2+48nu43+7woU453P0mPyRhqe+z01/w3NRjLtaA3gpkBbxOsRnr9CfS44KkJQ8AuVwVqxrXqEIJ8uJ2I+1C1CXwYTSi9DCLcxLy1VeKvFxU1se/vdcll1bVQmsiox8EGXYq4+jYQbxvOW+xqu8x57WnSdQ10QEYI/d9p9w0XGLm1VpIWA6J64TtAkHKPah8HyIwWqOid8+Y7K15FVLec5hGO45mp/3eXAL6DQxMmMhiL5D1nALAJhSg7G1iuzRvL+QxLl/uSUOiiA9k
 arlZ660j
 JEEOg6pPi1OYZsBoLYVvVc542I1+YCZzs5peOfbLhD0lX/EGYYzv3DrZe/NVSXc9AKA3yks6Z7SXeBcGYLNFwgEhvj7rptJq8poijHAbjRaaQO/vPpm3dqryByhjfFRSMbZ1jXpMwEKv/eZ4Lfvo7+X+CVMlKCQt8XmAOmxYw/exWmsByq+ODGqKno+Y4xzKhEuRnnSqHtbO4dZYZ1y//T6/nGIAKyT/kZ8mnI0VZKrMPPCxZoZE5hTC2LcRrwGLEKJtZyCYOg35T1ZEsSTmj2Vv0vBJg7KgoTBBubXgaZKxBplfA7zMirvDXyjDQSjeA7aY69hMEpjRwTf0MPBLDPn0myRziOsJMTkuetUVQjWqMrmevPF6l5LUyIYesCukqG6Jy51OenRCHbDvE0mIG+h7JE+N0As+DJ03EtUU2IVVQy5zoPkOLu7bur8K/IXl0s9BTwCPtmYbQ/zfznkujZeM68+1A7xIuE/wPPn+ZGEg7a8C7iaGItRIffubshZLGeIU13HIeKpuDoBwSFOngMLjLss50rmqInoio2c0x0pQnlY7GcSqKaeTMVZcLWwwENnVbnG4qAeY1cFd+G7tirQ1tFZU/6kikA7RaWQ9ze5dSUmm+Kb0FhTpI3Ja4Hxzi/4CLBK6LPdlcrvja8GLLdFBQmkMtW9Z0ZcrYGne4pDyqfO3RSgp66vHJwSVqeUcKoVJZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for stackdepot.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
---
 lib/Makefile     |  1 +
 lib/stackdepot.c | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 59ed5f881bcb..2e983f37d173 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -248,6 +248,7 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
 # Prevent the compiler from calling builtins like memcmp() or bcmp() from this
 # file.
 CFLAGS_stackdepot.o += -fno-builtin
+CONTEXT_ANALYSIS_stackdepot.o := y
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
 # In particular, instrumenting stackdepot.c with KMSAN will result in infinite
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b..166f50ad8391 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -61,18 +61,18 @@ static unsigned int stack_bucket_number_order;
 /* Hash mask for indexing the table. */
 static unsigned int stack_hash_mask;
 
+/* The lock must be held when performing pool or freelist modifications. */
+static DEFINE_RAW_SPINLOCK(pool_lock);
 /* Array of memory regions that store stack records. */
-static void **stack_pools;
+static void **stack_pools __pt_guarded_by(&pool_lock);
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
 /* Number of pools in stack_pools. */
 static int pools_num;
 /* Offset to the unused space in the currently used pool. */
-static size_t pool_offset = DEPOT_POOL_SIZE;
+static size_t pool_offset __guarded_by(&pool_lock) = DEPOT_POOL_SIZE;
 /* Freelist of stack records within stack_pools. */
-static LIST_HEAD(free_stacks);
-/* The lock must be held when performing pool or freelist modifications. */
-static DEFINE_RAW_SPINLOCK(pool_lock);
+static __guarded_by(&pool_lock) LIST_HEAD(free_stacks);
 
 /* Statistics counters for debugfs. */
 enum depot_counter_id {
@@ -291,6 +291,7 @@ EXPORT_SYMBOL_GPL(stack_depot_init);
  * Initializes new stack pool, and updates the list of pools.
  */
 static bool depot_init_pool(void **prealloc)
+	__must_hold(&pool_lock)
 {
 	lockdep_assert_held(&pool_lock);
 
@@ -338,6 +339,7 @@ static bool depot_init_pool(void **prealloc)
 
 /* Keeps the preallocated memory to be used for a new stack depot pool. */
 static void depot_keep_new_pool(void **prealloc)
+	__must_hold(&pool_lock)
 {
 	lockdep_assert_held(&pool_lock);
 
@@ -357,6 +359,7 @@ static void depot_keep_new_pool(void **prealloc)
  * the current pre-allocation.
  */
 static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack;
 	void *current_pool;
@@ -391,6 +394,7 @@ static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
 
 /* Try to find next free usable entry from the freelist. */
 static struct stack_record *depot_pop_free(void)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack;
 
@@ -428,6 +432,7 @@ static inline size_t depot_stack_record_size(struct stack_record *s, unsigned in
 /* Allocates a new stack in a stack depot pool. */
 static struct stack_record *
 depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, depot_flags_t flags, void **prealloc)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack = NULL;
 	size_t record_size;
@@ -486,6 +491,7 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 }
 
 static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
+	__must_not_hold(&pool_lock)
 {
 	const int pools_num_cached = READ_ONCE(pools_num);
 	union handle_parts parts = { .handle = handle };
@@ -502,7 +508,8 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 		return NULL;
 	}
 
-	pool = stack_pools[pool_index];
+	/* @pool_index either valid, or user passed in corrupted value. */
+	pool = context_unsafe(stack_pools[pool_index]);
 	if (WARN_ON(!pool))
 		return NULL;
 
@@ -515,6 +522,7 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 
 /* Links stack into the freelist. */
 static void depot_free_stack(struct stack_record *stack)
+	__must_not_hold(&pool_lock)
 {
 	unsigned long flags;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


