Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0048CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0293C8E0130; Thu, 18 Sep 2025 10:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1BE08E0112; Thu, 18 Sep 2025 10:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4E38E0130; Thu, 18 Sep 2025 10:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5EF58E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8346B1601F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:22 +0000 (UTC)
X-FDA: 83902545804.10.A58A74B
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6AE601C0012
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zq1vwbXF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 32hHMaAUKCHsdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=32hHMaAUKCHsdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204380; a=rsa-sha256;
	cv=none;
	b=QEsgEyQLaOBfyjrRgUkcRcs9Cpn2xv06rCBp1eEQ3NtEA4ejz9FrR1TZngSVkRGdwhD93X
	Rfokd5Jabum4S85Ak1YR+gqH3e7UptfwvpbxJEyMgLbc02zniX2cz24s5n6xPnGup/7jOc
	5bT7MMD0N//e6emyQYzOQoevLT95r/s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zq1vwbXF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 32hHMaAUKCHsdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=32hHMaAUKCHsdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4us2nxi3JpTZDeL0scdeAdIw4lyPkneoFt53x8qoK8=;
	b=kyIrYYGfQNzwBHu4/HREIz9Unk31SkOL8mxNAqVf5Wp+mgUeaa4krNEY+FbGMbhg+MpAEK
	EmS3L6nw2//U/bzoAiLkzZX/jzzqUVb8/ApB51Ms+JuYgcAxlpxbTVhLgSCiFAq/1ZXvSL
	B2XPPQkXuq8YdCBuNYtx/i/ev4F9Fto=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ece0cb7c9cso670141f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204379; x=1758809179; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q4us2nxi3JpTZDeL0scdeAdIw4lyPkneoFt53x8qoK8=;
        b=zq1vwbXFWMV8vypZeN/NV+1irngl0EwCCgyWTnRTK70XPsvIqHchNZNQvjsPUSDusO
         Y80XT+4EL4R1mBv4GqayT98v5KXv/smrgylLYxKKKMD+gdRzP+YMjmTg+Iarb7s1Jmu+
         SwyNiNXxk5LnsSCgkXOrMsILbNf1OzwqUPeUmmiKs73RNZEfRAuUy4cJTRlTrP6136nn
         b58ylWdY2nKi8BGJpL36LxYsTCrWKyxApilX58bC9F/HM8Mw1TTu/VfEGtBoDD2x6j1l
         RHdetppQRAPpE00J/euFzCihec6RiakZqJm6AqcT29Ujh17MngWI3rYpXgrhumuhlnBO
         dZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204379; x=1758809179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4us2nxi3JpTZDeL0scdeAdIw4lyPkneoFt53x8qoK8=;
        b=Bf7OoEE2QQocbw2K8HPYzPE/HJiynWNOxb19KecBO0t/Bc9OQeiDUp046VjVnzBNlO
         ljE5V3rm4fjdX9AyWBNIXG4ZlhUFrGulc2R0WEs8hCsoNT30gb7E9UEM0jm65AgOZLlh
         riZJyZ+o+iNsEF79SiVReHcUYpB7n3lNlqEKE0t0ILTBkESgY4Ti+Y7HLLWPNsWhMsWM
         6/DnW8JwyDWrVpyIKpeUzJyhqXKtCVQ0huEHefpgVuDxRaDNv8xNLdQ/bU1Ntyp7sASt
         3j9+fWs4WpgrFSiPIwuZMJBFzJMBA0usKzNkW9PGGi5JmHnZWYA1ZQH4R49dRDIPoVLz
         WB+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUkXFzswkM2TaC8itpLoyY9u9a6W/20V3g1bxL2nmzCVIYx2lwLpnTuD2brz8hie7BlkwlJsLb0Cg==@kvack.org
X-Gm-Message-State: AOJu0YxxFpjzpaFYWLqmLEs960EQV/DwOuA0XYnay5pVL+7x5LQDujcc
	KC5gtxBMF8Ap6xUHBWYRDwJMGPXFHpiv6/XW50UzmVFjd3oOYkf53hW7dry079Hyy/YETexOleP
	Z4w==
X-Google-Smtp-Source: AGHT+IForSgCnBdMYy4/yrbRoi3Bz0KlZrVTBci3S8BpGG4Qe7XF200pZ2l6iAG+7UNZ0b5azB0o4FG6fw==
X-Received: from wrml2.prod.google.com ([2002:adf:e582:0:b0:3ec:dab8:7d45])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2307:b0:3e4:bb5f:ee6d
 with SMTP id ffacd0b85a97d-3ecdf9bed46mr5359337f8f.15.1758204378633; Thu, 18
 Sep 2025 07:06:18 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:30 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-20-elver@google.com>
Subject: [PATCH v3 19/35] locking/local_lock: Support Clang's capability analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6AE601C0012
X-Stat-Signature: aojpa173a66y1rnhanh3xfn493gcrm88
X-Rspam-User: 
X-HE-Tag: 1758204380-869898
X-HE-Meta: U2FsdGVkX1/ca73ZD3tW7SSKDKehYJV9DMlLodyuOLlQZg8nLfXIRA6B/NkUj4A/u76wGgajYlhzqwIuy+lwOjsO44hV1n/YorxYCJ1tQcGiTFvOEQLch1gjWr5ZXKma+SDpkZCIjm4y5XslNX55sUs1nD5jJOF4Re+ZmhpewE1BOSH09oDyYxMH2qJm3ixkJaCbLqi/1TEWLmssznqLPAXC0XpeD0VdRwp2i7PBpn1zfhADjPfZ5SNn9NP2XpUKcW/qtRZ6V4cHn8zSkLzraCHRxeqlmAAFvCojTytqNF6/MpxVvSnq4e2t8o/Je1Dz98ND/jA7T28EPqeSnOBZWm63vDhtjgP6G1c3s3LKYKNl0iiEzciVxHWBs/rG9GRSP3XxusR0P2bWJ02lBcMNgbPauws7w/bOMS+3u1ZbrL5JebeMME6tFuwkizWuu7panox4XhWBSZKIAXu8xjDoX9SL6cOq8qStaGMNseUoLTafoYl/KF37rbdFA/+8WOVNDrQRJOxHPdZ/PYmE6xC4izntxIYqbJjLt41KD/SRWBXPwSzvpAECXMtBXgGeqIlmyhjGqByeshuS6urgArl7NLpXHNUViu3l76Hx4O4EkQ4Rovk9E9yYrIdthyjUCXEbdg9qXTVdbtIn4L3WLG+Zva+XzRJZqjEDUDS2ni2V01etO358FDovWtEEmDSWnTpSB+TtfUjNcXU0n4GapOuGdkP75PWZTZhxI8ZloYcpgWORzB6I9KEAkzXbwMGhoftIHBwn/azO0cK4InFNqYp6Il2aW0I9vV0FRFzQB8V8CZu1GcYzpMhXhVW2VZhPzUENuPESPwnMrLTfz6A2wcbyDPEqXoWnGWdY6tWz87+YIXmdL2Zdx2Am2N9hfeTk4F+IChVA8Ke2Jtaa6J3iZ7INBnTh8CJSzXB7qqaEHox2/Yu29Ooh/nxJjb2IbYUO1tcuCZIG0MTEjDWni54UjhI
 0gG0RrrS
 BAwfaDUHka8uhVvX3LLwz6O44g05mchIJhC7lkjAYLBLdEO/UxP2SWAhWCgL9lkBihNBpXEKS1Dpcn2TkkhkS7OZT6dg3mrh8dhKCfQidcw5tdKVPBEce3H5njI6c7jM4DXRSYbiqk/DvBpyA6k2N6S8jQTwKFnRKgLWJlCOUXdTgNCCc7dSVD+198fiPV8ROWB0jkY/HB7Z8b4Mg6SMkoMfxlk13SuDne68mhNjR0FE0u88MoEZuul0hxqbBSzfXsgkbfaeQa11EnTQpt1Q3E7z3EQZZg6VCzy8avXlTniJpSLd9CZsMhhk6JQb9iXrcqfLQw4IIvFA1cXKgSApC4Zf+/L3FZqoa3VAW+6QXZsTkcAp3Kh6lVNEoxsQOnJPFWqW3QsTF7fW1VayfxaPP4P2h4Aob5hw034a/4UdWkkIDgXQKs3imxT+Y7vSHvKw/Ai7BesPa1rmtYemxL1SNCYCrM5ZWdgkKRmd4Be3j47YFeHYv0TAwNO16P7lKAEXkvt0vhYr8z2KNWVcN5enQoXUG4ZPwfsM0ZV1oa4fGpWnG6KQKIxLtIcwOCzAr3DugK0peYbEuytuDtoyHpdXFwoOD5EPJJ7H/4HZBbh7BpP5sJuM/8hljoaKKUXqwc/zlOn8LMjGHR4DKg7HpgHQm5qC8VhlgK+jQU4QTKBteLiy6fXNWbJLn9HkHu/LVkusqrMT3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's capability analysis for local_lock_t and
local_trylock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
* Rework __this_cpu_local_lock helper
* Support local_trylock_t
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/local_lock.h                    | 45 +++++++-----
 include/linux/local_lock_internal.h           | 71 ++++++++++++++----
 lib/test_capability-analysis.c                | 73 +++++++++++++++++++
 4 files changed, 156 insertions(+), 35 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 7a4c2238c910..9fb964e94920 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -82,7 +82,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index 2ba846419524..cfdca5bee89e 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -13,13 +13,13 @@
  * local_lock - Acquire a per CPU local lock
  * @lock:	The lock variable
  */
-#define local_lock(lock)		__local_lock(this_cpu_ptr(lock))
+#define local_lock(lock)		__local_lock(__this_cpu_local_lock(lock))
 
 /**
  * local_lock_irq - Acquire a per CPU local lock and disable interrupts
  * @lock:	The lock variable
  */
-#define local_lock_irq(lock)		__local_lock_irq(this_cpu_ptr(lock))
+#define local_lock_irq(lock)		__local_lock_irq(__this_cpu_local_lock(lock))
 
 /**
  * local_lock_irqsave - Acquire a per CPU local lock, save and disable
@@ -28,19 +28,19 @@
  * @flags:	Storage for interrupt flags
  */
 #define local_lock_irqsave(lock, flags)				\
-	__local_lock_irqsave(this_cpu_ptr(lock), flags)
+	__local_lock_irqsave(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_unlock - Release a per CPU local lock
  * @lock:	The lock variable
  */
-#define local_unlock(lock)		__local_unlock(this_cpu_ptr(lock))
+#define local_unlock(lock)		__local_unlock(__this_cpu_local_lock(lock))
 
 /**
  * local_unlock_irq - Release a per CPU local lock and enable interrupts
  * @lock:	The lock variable
  */
-#define local_unlock_irq(lock)		__local_unlock_irq(this_cpu_ptr(lock))
+#define local_unlock_irq(lock)		__local_unlock_irq(__this_cpu_local_lock(lock))
 
 /**
  * local_unlock_irqrestore - Release a per CPU local lock and restore
@@ -49,7 +49,7 @@
  * @flags:      Interrupt flags to restore
  */
 #define local_unlock_irqrestore(lock, flags)			\
-	__local_unlock_irqrestore(this_cpu_ptr(lock), flags)
+	__local_unlock_irqrestore(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_lock_init - Runtime initialize a lock instance
@@ -64,7 +64,7 @@
  * locking constrains it will _always_ fail to acquire the lock in NMI or
  * HARDIRQ context on PREEMPT_RT.
  */
-#define local_trylock(lock)		__local_trylock(this_cpu_ptr(lock))
+#define local_trylock(lock)		__local_trylock(__this_cpu_local_lock(lock))
 
 /**
  * local_trylock_irqsave - Try to acquire a per CPU local lock, save and disable
@@ -77,27 +77,32 @@
  * HARDIRQ context on PREEMPT_RT.
  */
 #define local_trylock_irqsave(lock, flags)			\
-	__local_trylock_irqsave(this_cpu_ptr(lock), flags)
-
-DEFINE_GUARD(local_lock, local_lock_t __percpu*,
-	     local_lock(_T),
-	     local_unlock(_T))
-DEFINE_GUARD(local_lock_irq, local_lock_t __percpu*,
-	     local_lock_irq(_T),
-	     local_unlock_irq(_T))
+	__local_trylock_irqsave(__this_cpu_local_lock(lock), flags)
+
+DEFINE_LOCK_GUARD_1(local_lock, local_lock_t __percpu,
+		    local_lock(_T->lock),
+		    local_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1(local_lock_irq, local_lock_t __percpu,
+		    local_lock_irq(_T->lock),
+		    local_unlock_irq(_T->lock))
 DEFINE_LOCK_GUARD_1(local_lock_irqsave, local_lock_t __percpu,
 		    local_lock_irqsave(_T->lock, _T->flags),
 		    local_unlock_irqrestore(_T->lock, _T->flags),
 		    unsigned long flags)
 
 #define local_lock_nested_bh(_lock)				\
-	__local_lock_nested_bh(this_cpu_ptr(_lock))
+	__local_lock_nested_bh(__this_cpu_local_lock(_lock))
 
 #define local_unlock_nested_bh(_lock)				\
-	__local_unlock_nested_bh(this_cpu_ptr(_lock))
+	__local_unlock_nested_bh(__this_cpu_local_lock(_lock))
 
-DEFINE_GUARD(local_lock_nested_bh, local_lock_t __percpu*,
-	     local_lock_nested_bh(_T),
-	     local_unlock_nested_bh(_T))
+DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
+		    local_lock_nested_bh(_T->lock),
+		    local_unlock_nested_bh(_T->lock))
+
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irq, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irqsave, __assumes_cap(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, __assumes_cap(_T), /* */)
 
 #endif
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 4c0e117d2d08..22ffaf06d9eb 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -10,18 +10,20 @@
 
 #ifndef CONFIG_PREEMPT_RT
 
-typedef struct {
+struct_with_capability(local_lock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
-} local_lock_t;
+};
+typedef struct local_lock local_lock_t;
 
 /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
-typedef struct {
+struct_with_capability(local_trylock) {
 	local_lock_t	llock;
 	u8		acquired;
-} local_trylock_t;
+};
+typedef struct local_trylock local_trylock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define LOCAL_LOCK_DEBUG_INIT(lockname)		\
@@ -81,9 +83,14 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
+	__assume_cap(lock);					\
 } while (0)
 
-#define __local_trylock_init(lock) __local_lock_init(lock.llock)
+#define __local_trylock_init(lock)				\
+do {								\
+	__local_lock_init(lock.llock);				\
+	__assume_cap(lock);					\
+} while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
 do {								\
@@ -94,6 +101,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_NORMAL);			\
 	local_lock_debug_init(lock);				\
+	__assume_cap(lock);					\
 } while (0)
 
 #define __local_lock_acquire(lock)					\
@@ -116,22 +124,25 @@ do {								\
 	do {							\
 		preempt_disable();				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irq(lock)					\
 	do {							\
 		local_irq_disable();				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_lock_irqsave(lock, flags)			\
 	do {							\
 		local_irq_save(flags);				\
 		__local_lock_acquire(lock);			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_cap(lock, ({				\
 		local_trylock_t *tl;				\
 								\
 		preempt_disable();				\
@@ -145,10 +156,10 @@ do {								\
 				(local_lock_t *)tl);		\
 		}						\
 		!!tl;						\
-	})
+	}))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_cap(lock, ({				\
 		local_trylock_t *tl;				\
 								\
 		local_irq_save(flags);				\
@@ -162,7 +173,7 @@ do {								\
 				(local_lock_t *)tl);		\
 		}						\
 		!!tl;						\
-	})
+	}))
 
 #define __local_lock_release(lock)					\
 	do {								\
@@ -182,18 +193,21 @@ do {								\
 
 #define __local_unlock(lock)					\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		preempt_enable();				\
 	} while (0)
 
 #define __local_unlock_irq(lock)				\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		local_irq_enable();				\
 	} while (0)
 
 #define __local_unlock_irqrestore(lock, flags)			\
 	do {							\
+		__release(lock);				\
 		__local_lock_release(lock);			\
 		local_irq_restore(flags);			\
 	} while (0)
@@ -202,13 +216,19 @@ do {								\
 	do {							\
 		lockdep_assert_in_softirq();			\
 		local_lock_acquire((lock));			\
+		__acquire(lock);				\
 	} while (0)
 
 #define __local_unlock_nested_bh(lock)				\
-	local_lock_release((lock))
+	do {							\
+		__release(lock);				\
+		local_lock_release((lock));			\
+	} while (0)
 
 #else /* !CONFIG_PREEMPT_RT */
 
+#include <linux/spinlock.h>
+
 /*
  * On PREEMPT_RT local_lock maps to a per CPU spinlock, which protects the
  * critical section while staying preemptible.
@@ -263,7 +283,7 @@ do {								\
 } while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_cap(lock, capability_unsafe(({		\
 		int __locked;					\
 								\
 		if (in_nmi() | in_hardirq()) {			\
@@ -275,13 +295,36 @@ do {								\
 				migrate_enable();		\
 		}						\
 		__locked;					\
-	})
+	})))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_cap(lock, ({				\
 		typecheck(unsigned long, flags);		\
 		flags = 0;					\
 		__local_trylock(lock);				\
-	})
+	}))
+
+#endif /* CONFIG_PREEMPT_RT */
 
+#if defined(WARN_CAPABILITY_ANALYSIS)
+/*
+ * Because the compiler only knows about the base per-CPU variable, use this
+ * helper function to make the compiler think we lock/unlock the @base variable,
+ * and hide the fact we actually pass the per-CPU instance to lock/unlock
+ * functions.
+ */
+static __always_inline local_lock_t *__this_cpu_local_lock(local_lock_t __percpu *base)
+	__returns_cap(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#ifndef CONFIG_PREEMPT_RT
+static __always_inline local_trylock_t *__this_cpu_local_lock(local_trylock_t __percpu *base)
+	__returns_cap(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
 #endif /* CONFIG_PREEMPT_RT */
+#else  /* WARN_CAPABILITY_ANALYSIS */
+#define __this_cpu_local_lock(base) this_cpu_ptr(base)
+#endif /* WARN_CAPABILITY_ANALYSIS */
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 3c6dad0ba065..e506dadb3933 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -6,7 +6,9 @@
 
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
+#include <linux/local_lock.h>
 #include <linux/mutex.h>
+#include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/rwsem.h>
 #include <linux/seqlock.h>
@@ -450,3 +452,74 @@ static void __used test_srcu_guard(struct test_srcu_data *d)
 	guard(srcu)(&d->srcu);
 	(void)srcu_dereference(d->data, &d->srcu);
 }
+
+struct test_local_lock_data {
+	local_lock_t lock;
+	int counter __guarded_by(&lock);
+};
+
+static DEFINE_PER_CPU(struct test_local_lock_data, test_local_lock_data) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+static void __used test_local_lock_init(struct test_local_lock_data *d)
+{
+	local_lock_init(&d->lock);
+	d->counter = 0;
+}
+
+static void __used test_local_lock(void)
+{
+	unsigned long flags;
+
+	local_lock(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock(&test_local_lock_data.lock);
+
+	local_lock_irq(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_irq(&test_local_lock_data.lock);
+
+	local_lock_irqsave(&test_local_lock_data.lock, flags);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_irqrestore(&test_local_lock_data.lock, flags);
+
+	local_lock_nested_bh(&test_local_lock_data.lock);
+	this_cpu_add(test_local_lock_data.counter, 1);
+	local_unlock_nested_bh(&test_local_lock_data.lock);
+}
+
+static void __used test_local_lock_guard(void)
+{
+	{ guard(local_lock)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_irq)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_irqsave)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+	{ guard(local_lock_nested_bh)(&test_local_lock_data.lock); this_cpu_add(test_local_lock_data.counter, 1); }
+}
+
+struct test_local_trylock_data {
+	local_trylock_t lock;
+	int counter __guarded_by(&lock);
+};
+
+static DEFINE_PER_CPU(struct test_local_trylock_data, test_local_trylock_data) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+};
+
+static void __used test_local_trylock_init(struct test_local_trylock_data *d)
+{
+	local_trylock_init(&d->lock);
+	d->counter = 0;
+}
+
+static void __used test_local_trylock(void)
+{
+	local_lock(&test_local_trylock_data.lock);
+	this_cpu_add(test_local_trylock_data.counter, 1);
+	local_unlock(&test_local_trylock_data.lock);
+
+	if (local_trylock(&test_local_trylock_data.lock)) {
+		this_cpu_add(test_local_trylock_data.counter, 1);
+		local_unlock(&test_local_trylock_data.lock);
+	}
+}
-- 
2.51.0.384.g4c02a37b29-goog


