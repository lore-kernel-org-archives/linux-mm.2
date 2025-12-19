Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19E5D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B8E6B00B5; Fri, 19 Dec 2025 10:46:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601E26B00B7; Fri, 19 Dec 2025 10:46:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9D26B00B8; Fri, 19 Dec 2025 10:46:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34AB46B00B5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 064AE1602C7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:44 +0000 (UTC)
X-FDA: 84236648328.30.10010F0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40661180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yXx1RXEz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3YHNFaQUKCK0RYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3YHNFaQUKCK0RYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159202; a=rsa-sha256;
	cv=none;
	b=00gaHWIcPnc3fzasTYuH25PSLixCkV+1A169/FAe9/YDxEWzYFriNEyKNB09uq32iqSxTL
	MAweZLjawcJwyJfvZkzqDYbP6ch2ZROXKXl9fAsqk8VUIdNTBO6e3tW/uDsvvE/ol2flHb
	Wf2C+k7214uxOYFHFU0+Nb28P91Wexg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yXx1RXEz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3YHNFaQUKCK0RYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3YHNFaQUKCK0RYiReTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmbIhVE6lrQtlGznaoJubWA1ZdiFv/Z/aaL1L4DndHU=;
	b=r4gd1cH3ii/J8zt15aJl7NjBP94A5El1wLV23m9ouj916fMdliqYO+ejCDV+N6/je+KGTu
	T2a8oHcFjjGY8t5WDFBPnARPC/5COzqXLcWbbyowdGvS463cLDGjzuPY2J2QKHQcSr69BB
	BGJzM6W1yqdPmvCF7YN5X8W4ws9FUb4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so19796065e9.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159201; x=1766764001; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OmbIhVE6lrQtlGznaoJubWA1ZdiFv/Z/aaL1L4DndHU=;
        b=yXx1RXEz+K2PpyN1s9IozKQYShqXcFCsZb3B+XcA+TYQzQKgWY6zoxQUfbBHhJGorF
         O3Bea8ESQEcdT/eHwI97P5KR5zjn3ZDSiNdzRN7GWS6Zrj7yfi/vwGVft4zDMbbbd/N6
         dXzdeVdKp+SYi62VTL1GO4uONkTG34Dh3xNDEff5q9jduO0y/5FAd9utC534aI2HA0hb
         LZ/Dfo3IDcPnf+W1lD6vQ/rrRi70/gbptgYM8BrbQfuKhcpfSJ25FD1VmlL+MQ4qfvye
         EvlT1Mg077oWORH5j7K1Sp/sq51DJjy6qcRbPbsnuS/NmVXX4J43ptsbc4jKVxuOg6Re
         +iAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159201; x=1766764001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmbIhVE6lrQtlGznaoJubWA1ZdiFv/Z/aaL1L4DndHU=;
        b=PR+EQ0ZWew9SOzH0n4FVlWG/EuO/qzmORUzMHK81rfGJIYZu+5QkmYS+EKEimFGsj0
         f3/XqwfV4uEwhMcdyU1Nt2w0kSlbZ0E0ObwwAlT5m+dXkx1ymHewGaM6E5LDdElXaiCC
         ClOXu4i5Nd+981DzP4br6AJzNc1/ZWNqBoGBU8hT2C4vjUrklBJZGxK6nyh8/KoYlKsL
         2S7D8xpZ4soc5IVvcYh+SmknbgLLnAXRtIISIQvFAAz5vemcIAqDn3NUzIBLeQfSSJu+
         I0b03Xcb4bx1X4SVjDOCLRA0CCG7S1ISZjsOFV3C+7YbbdgRQCQxLAFBE/2aciSTb2RP
         084Q==
X-Forwarded-Encrypted: i=1; AJvYcCW5tyHuKJm/dJjljzxz/fqKwi6QaFVsJkJkJmkovP9sd4xQ7v1UaJrPuzk30881z5hR6r/ueJC9UQ==@kvack.org
X-Gm-Message-State: AOJu0YxDd4tltQTud/Bc59Xs98CujPR8Dcrg2Ri+zqCvE7W97mqLPHuv
	ES7GhhHHYH++1Jvf0rUp5HWJJLOZz1Bji4yf4DMznczW7Zl6MD7a+f1SC6aqITyLrer/n906WNx
	nlg==
X-Google-Smtp-Source: AGHT+IG8sG31wXc+Qczu/TlGtNtQXVUelf3E14dDPvkeumRAhR7hfNjKeviKIQMKw+eqk2KBY9GxLKpBwQ==
X-Received: from wmoo8-n2.prod.google.com ([2002:a05:600d:108:20b0:47b:daaa:51cf])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4fc6:b0:465:a51d:d4
 with SMTP id 5b1f17b1804b1-47d1953b768mr30732635e9.6.1766159200542; Fri, 19
 Dec 2025 07:46:40 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:08 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-20-elver@google.com>
Subject: [PATCH v5 19/36] locking/local_lock: Support Clang's context analysis
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
X-Rspamd-Queue-Id: 40661180002
X-Rspamd-Server: rspam03
X-Stat-Signature: wrrfbsrrixybctibfktz6istfr73bp8y
X-Rspam-User: 
X-HE-Tag: 1766159202-347744
X-HE-Meta: U2FsdGVkX18idDmVYcfWy/mclq7/U4877lqw2U+NTzIHOJw8hF1RYzamxlq4SmmDvyGC55nZSdEek+dWzfM8vGkOp6M/4MfJdtTHVR9rf5ikm1cekRCwDik5eZzuYwbd6EI/OFh/1ap7VDHaFnO+VKWgINezWw4yyaWPdtfnfhm1PREDvMND3xxT768kybc9SQVgg1kzKJ3OaMyrb8sUfAytUHIrfk3xjsdvURWSk9noYIAu8e4CT1SEU8auuU3P2dl4qBOMFM6zgcEMG8IpA5FdMgArfoOaesWrtacn1gojbq2PV0gkgZ4nR//MWYIsage22bNNakQSNv6GV8I9KkouP4n0++J93fWtaaShubhB6/VzMa44ln49ZxQ2L9sD5iIoPQRwe3hJgW/CUVBNlk3qHLzaYMSZB5ePqh1lMvi5/rnrML81CflP+j9iKk+wYFg1VTBQ6kXVkgvxVTOX+4wvlA3gSpvIpkGwF7h4zEnve7DVLPDgDc1kz9tUwc/Jgn7wHN+6hEdeoIW99c2dzojF3odQKQJ0vpmtVmJ9LpcPouw+07c7JLI+vJ/bEyDuFSqvJhP1RSXReW3TSRPQq6xtZ+9J5NVH95cfpz7f9IdDePDajks22VNA472MO0r/QEG7Y7VxcjX8qiVoCs2Fr3m5qrEpzac2/rCYeREZ9EIWo6fUa4Ilx98LXUZKIqiNUcFfApBGO3V9c0di2LND91TwuY1Hoa2yS87/s58PVoSkKo1SnPH2MImNXLjv/80PeRpkrwj3AylI2vocBJORhFkzr5WL8MiH+5oCxRz4xHgvjIiPUtDXmQr7sFNdCq1svAczX3FfQx0K59YNbdd6gRUb9QNNdtKgIveGCJsjAPNx1VjVyfB92PXXotLTCkmzzvQF+2Z+n7BTa/uJAYCL9atd8aW7CU6mrR114IWUR0LIFbe4VukM/BUf/tm7XLLvyqh49bnudXOyKS7x30V
 wLDwS8pY
 h5YTPm1XsjIpdjqlehE4amq/JUvckCD3EHZdsEg0MgCFJHxPI5ZUcC5iHRKN2nP7GBo98shZYctvA/wPOuMaa9DPMd47rIeL4kFAVKwju53Ux9AK+4rdCJ+yLN9qyeL7h2vnKQwchEL5ixyY+Gnr4uv+GbAoHusNeZvGBQnmz+hL7S7rlCSI7z7cCA5dDZvpvXXqP0oUtNnAe7sO+/Gk88oGRfujkLGx0mGocmlarLD0cpB7QvB1BTlbO4X3hdgkcb+AgQfJ5edygHGY6QEtUB2emO+F6uyRqSON+u9cmwJi0LRXl/xhHxMp4jxYUF/TNbVWbKXxpvhh3sLBjXXvBFROFyEW6xAmtQR21LqAyHF5FRu/XINReqYuGPyBU8qQosXGOjxpRtKrgajAM8HzmEsNQ3k1Tdkxq8xN/C5f1aWLVm9I2G9GWkBLPZD6LhaEluWIDbyyXzaXsVco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for local_lock_t and
local_trylock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".
* Use new cleanup.h helpers to properly support scoped lock guards.

v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* __assert -> __assume rename
* Rework __this_cpu_local_lock helper
* Support local_trylock_t
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/local_lock.h                   | 51 ++++++++------
 include/linux/local_lock_internal.h          | 71 +++++++++++++++----
 lib/test_context-analysis.c                  | 73 ++++++++++++++++++++
 4 files changed, 161 insertions(+), 36 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 7b660c3003a0..a48b75f45e79 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`), `rw_semaphore`, `local_lock_t`.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index b0e6ab329b00..99c06e499375 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -14,13 +14,13 @@
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
@@ -29,19 +29,19 @@
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
@@ -50,7 +50,7 @@
  * @flags:      Interrupt flags to restore
  */
 #define local_unlock_irqrestore(lock, flags)			\
-	__local_unlock_irqrestore(this_cpu_ptr(lock), flags)
+	__local_unlock_irqrestore(__this_cpu_local_lock(lock), flags)
 
 /**
  * local_trylock_init - Runtime initialize a lock instance
@@ -66,7 +66,7 @@
  * locking constrains it will _always_ fail to acquire the lock in NMI or
  * HARDIRQ context on PREEMPT_RT.
  */
-#define local_trylock(lock)		__local_trylock(this_cpu_ptr(lock))
+#define local_trylock(lock)		__local_trylock(__this_cpu_local_lock(lock))
 
 #define local_lock_is_locked(lock)	__local_lock_is_locked(lock)
 
@@ -81,27 +81,36 @@
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
-
-DEFINE_GUARD(local_lock_nested_bh, local_lock_t __percpu*,
-	     local_lock_nested_bh(_T),
-	     local_unlock_nested_bh(_T))
+	__local_unlock_nested_bh(__this_cpu_local_lock(_lock))
+
+DEFINE_LOCK_GUARD_1(local_lock_nested_bh, local_lock_t __percpu,
+		    local_lock_nested_bh(_T->lock),
+		    local_unlock_nested_bh(_T->lock))
+
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
+#define class_local_lock_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irq, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
+#define class_local_lock_irq_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock_irq, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_irqsave, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
+#define class_local_lock_irqsave_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock_irqsave, _T)
+DECLARE_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, __acquires(_T), __releases(*(local_lock_t __percpu **)_T))
+#define class_local_lock_nested_bh_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(local_lock_nested_bh, _T)
 
 #endif
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 1a1ea1232add..e8c4803d8db4 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -10,21 +10,23 @@
 
 #ifndef CONFIG_PREEMPT_RT
 
-typedef struct {
+context_lock_struct(local_lock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
-} local_lock_t;
+};
+typedef struct local_lock local_lock_t;
 
 /* local_trylock() and local_trylock_irqsave() only work with local_trylock_t */
-typedef struct {
+context_lock_struct(local_trylock) {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 	struct task_struct	*owner;
 #endif
 	u8		acquired;
-} local_trylock_t;
+};
+typedef struct local_trylock local_trylock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define LOCAL_LOCK_DEBUG_INIT(lockname)		\
@@ -84,9 +86,14 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
+	__assume_ctx_lock(lock);				\
 } while (0)
 
-#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)lock)
+#define __local_trylock_init(lock)				\
+do {								\
+	__local_lock_init((local_lock_t *)lock);		\
+	__assume_ctx_lock(lock);				\
+} while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
 do {								\
@@ -97,6 +104,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_NORMAL);			\
 	local_lock_debug_init(lock);				\
+	__assume_ctx_lock(lock);				\
 } while (0)
 
 #define __local_lock_acquire(lock)					\
@@ -119,22 +127,25 @@ do {								\
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
+	__try_acquire_ctx_lock(lock, ({				\
 		local_trylock_t *__tl;				\
 								\
 		preempt_disable();				\
@@ -148,10 +159,10 @@ do {								\
 				(local_lock_t *)__tl);		\
 		}						\
 		!!__tl;						\
-	})
+	}))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_ctx_lock(lock, ({				\
 		local_trylock_t *__tl;				\
 								\
 		local_irq_save(flags);				\
@@ -165,7 +176,7 @@ do {								\
 				(local_lock_t *)__tl);		\
 		}						\
 		!!__tl;						\
-	})
+	}))
 
 /* preemption or migration must be disabled before calling __local_lock_is_locked */
 #define __local_lock_is_locked(lock) READ_ONCE(this_cpu_ptr(lock)->acquired)
@@ -188,18 +199,21 @@ do {								\
 
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
@@ -208,13 +222,19 @@ do {								\
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
@@ -269,7 +289,7 @@ do {								\
 } while (0)
 
 #define __local_trylock(lock)					\
-	({							\
+	__try_acquire_ctx_lock(lock, context_unsafe(({		\
 		int __locked;					\
 								\
 		if (in_nmi() | in_hardirq()) {			\
@@ -281,17 +301,40 @@ do {								\
 				migrate_enable();		\
 		}						\
 		__locked;					\
-	})
+	})))
 
 #define __local_trylock_irqsave(lock, flags)			\
-	({							\
+	__try_acquire_ctx_lock(lock, ({				\
 		typecheck(unsigned long, flags);		\
 		flags = 0;					\
 		__local_trylock(lock);				\
-	})
+	}))
 
 /* migration must be disabled before calling __local_lock_is_locked */
 #define __local_lock_is_locked(__lock)					\
 	(rt_mutex_owner(&this_cpu_ptr(__lock)->lock) == current)
 
 #endif /* CONFIG_PREEMPT_RT */
+
+#if defined(WARN_CONTEXT_ANALYSIS)
+/*
+ * Because the compiler only knows about the base per-CPU variable, use this
+ * helper function to make the compiler think we lock/unlock the @base variable,
+ * and hide the fact we actually pass the per-CPU instance to lock/unlock
+ * functions.
+ */
+static __always_inline local_lock_t *__this_cpu_local_lock(local_lock_t __percpu *base)
+	__returns_ctx_lock(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#ifndef CONFIG_PREEMPT_RT
+static __always_inline local_trylock_t *__this_cpu_local_lock(local_trylock_t __percpu *base)
+	__returns_ctx_lock(base) __attribute__((overloadable))
+{
+	return this_cpu_ptr(base);
+}
+#endif /* CONFIG_PREEMPT_RT */
+#else  /* WARN_CONTEXT_ANALYSIS */
+#define __this_cpu_local_lock(base) this_cpu_ptr(base)
+#endif /* WARN_CONTEXT_ANALYSIS */
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 1c96c56cf873..003e64cac540 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -6,7 +6,9 @@
 
 #include <linux/bit_spinlock.h>
 #include <linux/build_bug.h>
+#include <linux/local_lock.h>
 #include <linux/mutex.h>
+#include <linux/percpu.h>
 #include <linux/rcupdate.h>
 #include <linux/rwsem.h>
 #include <linux/seqlock.h>
@@ -458,3 +460,74 @@ static void __used test_srcu_guard(struct test_srcu_data *d)
 	{ guard(srcu_fast)(&d->srcu); (void)srcu_dereference(d->data, &d->srcu); }
 	{ guard(srcu_fast_notrace)(&d->srcu); (void)srcu_dereference(d->data, &d->srcu); }
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
2.52.0.322.g1dd061c0dc-goog


