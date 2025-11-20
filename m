Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94402CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD726B009E; Thu, 20 Nov 2025 10:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADF66B00A0; Thu, 20 Nov 2025 10:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E126B00AB; Thu, 20 Nov 2025 10:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1D356B009E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6402B5641D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:17 +0000 (UTC)
X-FDA: 84131326314.28.4F82F40
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57E5D4001D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=38DQ03BH;
	spf=pass (imf01.hostedemail.com: domain of 3zS8faQUKCPgjq0jwlttlqj.htrqnsz2-rrp0fhp.twl@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3zS8faQUKCPgjq0jwlttlqj.htrqnsz2-rrp0fhp.twl@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcdgfkZVjo+28iDEn5YG970J38eiF4zhn7KHxHB91wc=;
	b=EGljUO7wcxBpdgDNTRGnC70rCM5G2PGGoc996Mb0EbSMTwBreWw/zF+81Ld+ndoRDeGBBC
	8TvhL5Hroy9r0E7nQ22zQjak25MyYPly1Er6GC+VexkOzFxiKuMuslkNJiQcr+bJ+pdD6w
	HDuHAg2aDMwheiBRXwMAxXW/96BQKAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651535; a=rsa-sha256;
	cv=none;
	b=jWtljRAlJh4lK8x8OiXAChZOerywKS2wZopkl2VIJIlj0QgVu/WQLWuXBNx+SHQSgvqgaI
	LL9Wdp5zsfSoDvRgkeQDHUVNsUPceA0tZAVJx56KYdsuBjooMOmQY6O+EYBvt+NBP3DuE3
	8MnQIXhA+qikcjNX+dfhQUmfd5m/Koo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=38DQ03BH;
	spf=pass (imf01.hostedemail.com: domain of 3zS8faQUKCPgjq0jwlttlqj.htrqnsz2-rrp0fhp.twl@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3zS8faQUKCPgjq0jwlttlqj.htrqnsz2-rrp0fhp.twl@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779da35d27so12425495e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651534; x=1764256334; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TcdgfkZVjo+28iDEn5YG970J38eiF4zhn7KHxHB91wc=;
        b=38DQ03BHmnXwi5HwvAJyLXTuGQiwCHBZ7PcZUGp/UkToatq8savm5w27WzialfPkbx
         4jynR0BApH9lLHvifi7hayK47kKuhQYsuO9zapfzMfbXHVc9KCu8NVchymWZV9uLYt6i
         4hBkbrrYrZCru97KAGhselYCig4EITiAcpXEAAn6pOnBxG7QO0mYMNrtfEqmMQSUcjqT
         VBAjfAfxQfUe1GVzDg8CdBYUvekMd3GiLXIYvujJTnig+l538IcsmBLVfB08W1zaOsvV
         KGUt56gW+83LcLxrS6wHMK5gRM9IU/GDHvfJJueGdJoiva724ZPwn+Q8pZMDKjkFR+hG
         JFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651534; x=1764256334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TcdgfkZVjo+28iDEn5YG970J38eiF4zhn7KHxHB91wc=;
        b=AAVPVCTAD7pVDsqDOaHXmczJZ8y9IieylYdAWyBwm5UIFoV243icPJiIx9UyQ5psCA
         Cq8kjCLdddTmhmN6Ca2vtDD4FVtEc1MMtZ1q+A13CKHR+EP1j675LXPEi5bq2l29RSHz
         nT7WsfpbXktkIgfPiuREuafHlkPhoC78PN9xAL06wcImEcUX7jsJpYJ6SOqpbO6A8YvT
         vNF4ttY5Mk55j3xamf/jLQblrKtHUgk54MWBzRqnGKoykiM0hIXqlCRA5r6Of3HgD8bB
         gq0MTiGDmb1wU/yLlix+E3fedYjelje8DyXj1zWEYaobSCQ3nYe+DHyhOf6Qpt+X434M
         pn7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW4VeA15dWemQ4K8y02D7wAl6orf325L07WGinZsIhsfY+yUKH2jgOVz0ilIbj3naerw59o2kt1KA==@kvack.org
X-Gm-Message-State: AOJu0YwfMegS6ifkXfR0ph4CiJoMXqmaT7xVwDhVbfRxHHqIL6CC9erc
	2Ls6YCftISUHDC2Oa4drnyxquz71cbMIvxAQY7enO3Y6q407erI2+85qA0Ke23/MyKBTEd0SNPc
	Jkg==
X-Google-Smtp-Source: AGHT+IFdnThzYknUV1vCt7ZEvlRWYwztCHPUAp0IneVSOXI7YNi6Z3vbTkQU4anukpx8hznRZV3KEJvRzQ==
X-Received: from wmco18.prod.google.com ([2002:a05:600c:a312:b0:477:d21:4a92])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:450f:b0:477:557b:6917
 with SMTP id 5b1f17b1804b1-477b8a98d9dmr32529805e9.18.1763651533655; Thu, 20
 Nov 2025 07:12:13 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:35 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-11-elver@google.com>
Subject: [PATCH v4 10/35] locking/mutex: Support Clang's context analysis
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 57E5D4001D
X-Stat-Signature: u5npxja61jd6f55krt3dxx5fjjfotutb
X-Rspam-User: 
X-HE-Tag: 1763651535-190127
X-HE-Meta: U2FsdGVkX1+03tSgHeNlFvbSXlLL7sYsC7JfgavIsiSB+vbb4CvPTwjO6wHXU5nZLwhoFvYlHFy5UVWDNbDxvXGFiZnEmXaVJrxJoGOUwf2OFuNIKFd94SMRuk0+++McP5JM0SxRGNbbIHrbKHtc70nA5USHaFVKjcQoKO/cg9YJXC3XdSgmkrAO6aXIdnosf4JwFDA6OC9jmXfVak7r+JOYFIJu09MqeqmyNceQEjxoDm+yDcT8B41+0KeC/Ob401yLgkj5HAmiGQv+dSG4bttvXvG66lA5KRKurd5BX2lHEFBMnnT44Ty9TYPFkvqu3co/Y1hvqQEso8d6eOQ3qCGFsnAkSsicBgXngjPHc9fbe8eLXa0MnSfBZytq3MsauwOK6nFuA7f5k7fmHjb3jkZhpHmhlI2vZxXFyiIQcIGehHcLVr30zUbUa3vajHiEc0u73++griS39Md3GvqRKBzY6BJwdXfqsfyLgrYhYvPrDcWrCPrwkUmdR+Glzfsrh028y0RPjwyGqmjA1T+2n6iW7JW8RnsYwzoZZq4ERWngnpo604HKS6/99NiJnMOHkad6lHWg9uwdO9bzyYA8JEJU/OtDjEfd75ScsvpiIhFdQF2zz5tVqg/0s4faYRdbA3AwVmEAfv9tV1LpV5x9pZI5ufXUfhu95Xjm9/jgGtRHlEMOiwOeSvSAZtZWoosCppuew8RNKlcMrfykWG8+X1wsBZdtJFEoBHhJlqQWPE9Ml5lQdcXUyYNLYOMQojdVjXrem08cGwBtJ3ae5IiSvU2oL2YUD7tVB9ybCLTMKiFiOfN8mkF94ZKdAIv84iyXLyFtbd8lwY+8vT199kY831mmtSexDOPpQP9OPJLt8l1eiHh0npbtFxcxxYLlvJiBSAJyM/C+sZd8OKVQPME/h3ZBSBCmnkF3FsLh7QKwBNo4zg3Zi+W47TdMWY1sqW97VX8t7By5fEbTkBkGdy9
 UEaSG+O+
 HzXm6dBzaoXH7z/ttC8fYLzQxnx9DkgnuFalYlTSvb0Ye9RNx3a9Abk7fY/OMBNHJ3KDlsWaupnQue0+B1zYTAU4EGKD4uXCZ+W5A6NjSVvEqxVCtrId6EKIqMPZoMF6p8J8BFOh8NSH1kKxMSxNPcdmYBEy/pVpICYwLxrUOqkt1bN92MNGJCBfQXKQdVsMHHoPWH8Eez12sprsldCPCLnhGHPvjWTSd8epKAz6wdsl7CSAaE5/RmHBE4Gd0NPAybRhGGfPiAhLHcejhGgx4RwejZ/1+6q0xNaxbRBey1QMugJ3hu69q9lxrqEm45f97Iv5Eots6sNU1X8G5u/nOWaHZJ9P/LxjIG33bp0bdQEkjp2qEzvHismSSq+XGdoRTkRDaHU5V8e6mMTdHbh/WsxY/6J8m2IIoHs4Vz76OPu2SIH3XCxHU3Q1l77aqdd5w1J6Zh9QChC8fxFv51sEpQSEKBB8EuEsVHIp4AqNrmqVkTKbXBhG0GPzURJTs9VRlh/4y+9bOfaK3S0lGBhR34URR5XR8C8wEQZQAYi52zrLnZWtz20+JvyASb4/009YTwf4w+ZyXRaXAPRDy2kEzlg5YkwQ08lMWvU5ReY37k8gnKbWwcoFMy1yL5V1ErDfLJNgieVjYTQHWv4QqentCuJCNVyIVnc/8u/DCX+tDSkj5gELJN/g/oiH/OIaHg8eAZk+1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for mutex.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/mutex.h                        | 35 ++++++-----
 include/linux/mutex_types.h                  |  4 +-
 lib/test_context-analysis.c                  | 64 ++++++++++++++++++++
 4 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 50b57a1228ea..1f5d7c758219 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 847b81ca6436..be91f991a846 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,6 +62,7 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__mutex_init((mutex), #mutex, &__key);				\
+	__assume_ctx_guard(mutex);					\
 } while (0)
 
 /**
@@ -157,13 +158,13 @@ static inline int __must_check __devm_mutex_init(struct device *dev, struct mute
  * Also see Documentation/locking/mutex-design.rst.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
-					unsigned int subclass);
+					unsigned int subclass) __cond_acquires(0, lock);
 extern int __must_check _mutex_lock_killable(struct mutex *lock,
-		unsigned int subclass, struct lockdep_map *nest_lock);
-extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass);
+		unsigned int subclass, struct lockdep_map *nest_lock) __cond_acquires(0, lock);
+extern void mutex_lock_io_nested(struct mutex *lock, unsigned int subclass) __acquires(lock);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
@@ -186,10 +187,10 @@ do {									\
 	_mutex_lock_killable(lock, subclass, NULL)
 
 #else
-extern void mutex_lock(struct mutex *lock);
-extern int __must_check mutex_lock_interruptible(struct mutex *lock);
-extern int __must_check mutex_lock_killable(struct mutex *lock);
-extern void mutex_lock_io(struct mutex *lock);
+extern void mutex_lock(struct mutex *lock) __acquires(lock);
+extern int __must_check mutex_lock_interruptible(struct mutex *lock) __cond_acquires(0, lock);
+extern int __must_check mutex_lock_killable(struct mutex *lock) __cond_acquires(0, lock);
+extern void mutex_lock_io(struct mutex *lock) __acquires(lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
@@ -207,7 +208,7 @@ extern void mutex_lock_io(struct mutex *lock);
  */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock) __cond_acquires(true, lock);
 
 #define mutex_trylock_nest_lock(lock, nest_lock)		\
 (								\
@@ -217,17 +218,21 @@ extern int _mutex_trylock_nest_lock(struct mutex *lock, struct lockdep_map *nest
 
 #define mutex_trylock(lock) _mutex_trylock_nest_lock(lock, NULL)
 #else
-extern int mutex_trylock(struct mutex *lock);
+extern int mutex_trylock(struct mutex *lock) __cond_acquires(true, lock);
 #define mutex_trylock_nest_lock(lock, nest_lock) mutex_trylock(lock)
 #endif
 
-extern void mutex_unlock(struct mutex *lock);
+extern void mutex_unlock(struct mutex *lock) __releases(lock);
 
-extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock) __cond_acquires(true, lock);
 
-DEFINE_GUARD(mutex, struct mutex *, mutex_lock(_T), mutex_unlock(_T))
-DEFINE_GUARD_COND(mutex, _try, mutex_trylock(_T))
-DEFINE_GUARD_COND(mutex, _intr, mutex_lock_interruptible(_T), _RET == 0)
+DEFINE_LOCK_GUARD_1(mutex, struct mutex, mutex_lock(_T->lock), mutex_unlock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _try, mutex_trylock(_T->lock))
+DEFINE_LOCK_GUARD_1_COND(mutex, _intr, mutex_lock_interruptible(_T->lock), _RET == 0)
+
+DECLARE_LOCK_GUARD_1_ATTRS(mutex, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_try, __assumes_ctx_guard(_T), /* */)
+DECLARE_LOCK_GUARD_1_ATTRS(mutex_intr, __assumes_ctx_guard(_T), /* */)
 
 extern unsigned long mutex_get_owner(struct mutex *lock);
 
diff --git a/include/linux/mutex_types.h b/include/linux/mutex_types.h
index fdf7f515fde8..3a5efaa2da2d 100644
--- a/include/linux/mutex_types.h
+++ b/include/linux/mutex_types.h
@@ -38,7 +38,7 @@
  * - detects multi-task circular deadlocks and prints out all affected
  *   locks and tasks (and only those tasks)
  */
-struct mutex {
+context_guard_struct(mutex) {
 	atomic_long_t		owner;
 	raw_spinlock_t		wait_lock;
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -59,7 +59,7 @@ struct mutex {
  */
 #include <linux/rtmutex.h>
 
-struct mutex {
+context_guard_struct(mutex) {
 	struct rt_mutex_base	rtmutex;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 273fa9d34657..2b28d20c5f51 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/build_bug.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 /*
@@ -144,3 +145,66 @@ TEST_SPINLOCK_COMMON(read_lock,
 		     read_unlock,
 		     read_trylock,
 		     TEST_OP_RO);
+
+struct test_mutex_data {
+	struct mutex mtx;
+	int counter __guarded_by(&mtx);
+};
+
+static void __used test_mutex_init(struct test_mutex_data *d)
+{
+	mutex_init(&d->mtx);
+	d->counter = 0;
+}
+
+static void __used test_mutex_lock(struct test_mutex_data *d)
+{
+	mutex_lock(&d->mtx);
+	d->counter++;
+	mutex_unlock(&d->mtx);
+	mutex_lock_io(&d->mtx);
+	d->counter++;
+	mutex_unlock(&d->mtx);
+}
+
+static void __used test_mutex_trylock(struct test_mutex_data *d, atomic_t *a)
+{
+	if (!mutex_lock_interruptible(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (!mutex_lock_killable(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (mutex_trylock(&d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+	if (atomic_dec_and_mutex_lock(a, &d->mtx)) {
+		d->counter++;
+		mutex_unlock(&d->mtx);
+	}
+}
+
+static void __used test_mutex_assert(struct test_mutex_data *d)
+{
+	lockdep_assert_held(&d->mtx);
+	d->counter++;
+}
+
+static void __used test_mutex_guard(struct test_mutex_data *d)
+{
+	guard(mutex)(&d->mtx);
+	d->counter++;
+}
+
+static void __used test_mutex_cond_guard(struct test_mutex_data *d)
+{
+	scoped_cond_guard(mutex_try, return, &d->mtx) {
+		d->counter++;
+	}
+	scoped_cond_guard(mutex_intr, return, &d->mtx) {
+		d->counter++;
+	}
+}
-- 
2.52.0.rc1.455.g30608eb744-goog


