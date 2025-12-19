Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB10DD78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503CB6B00C9; Fri, 19 Dec 2025 10:47:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7EC6B00CB; Fri, 19 Dec 2025 10:47:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39ABC6B00CC; Fri, 19 Dec 2025 10:47:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 210616B00C9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF5731402E4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:24 +0000 (UTC)
X-FDA: 84236650008.22.F707371
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 057C6C0008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=geG6KvXx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3iXNFaQUKCNY6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3iXNFaQUKCNY6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159243; a=rsa-sha256;
	cv=none;
	b=trjRii+I5YmT2uTd0mYsadqdKuHzR62+YPl22F7cGmeItfR62ke2vhW9g5TmiHdlNacJRw
	r7C59cbAmWKGxwvHCShahaXzjBJ4afudG9ER1YwD91KGRsYKdmvyRlXBNhNNto3j0Kkxkx
	iqmPPj6O+3LVvXnlUheuIebnQHacHkw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=geG6KvXx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3iXNFaQUKCNY6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3iXNFaQUKCNY6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIl6hRG6VWUZ3266tGTJDIxO3xjvOCdXIFgWS7XA8vA=;
	b=VM7Yf1MSF2fZYiza0ATJUZhbOBOnCpIlXsp2t/IiBOZT3pAwGyKI8L55TsCegklq194OUc
	J6P0gS36ndw7biw56NiqsvD5qbEqe84ouuE6a+/k4lmxGQoLOKZjxE/JYKMFiShDMNtbje
	4AehL/4Hn8Aic2m+Tkdv60lA2JU8qko=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-431026b6252so1818857f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159241; x=1766764041; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIl6hRG6VWUZ3266tGTJDIxO3xjvOCdXIFgWS7XA8vA=;
        b=geG6KvXx6CD5q8sW3zCIXDj4jVKJ9eHfIyUP1fXqfpgaBXdMLpDQa0bZUxnxd6k3Vz
         upBSDVW35rWPH63iyR8uKVDNE8PHcDIV1+5yXqjBN8SYm2Xb8esY7FzmEjIxxj2/P+k4
         JhW1lSYtemOexaXlkd+JMtUr37b9IFnvP643AakcbCFxwwzBPB7j7kz6C17P9deqzO2L
         xCgaqs0h/mRwjDMaNGlBgjTCLNtPc1Aw2tVYp30LSA1XLaH8d4wfGOFrORbUxqqdzrlw
         vpwe+T3y5/CspJr7Zx55Erg2+4Crxyk/7Msuy3cfBzEJNY3N45AaTg5gN+wcUWsEU6Pv
         DV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159241; x=1766764041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIl6hRG6VWUZ3266tGTJDIxO3xjvOCdXIFgWS7XA8vA=;
        b=toY17sicHvUCyjYr08bEGccLg/MZzFxRnQy+iQZ4ORkTDumFVCapa5vSz7BXjnX4Uj
         Ag+gPbm7uOjlHzFcyHgEMEXh5SmhLfA2knSsuYNejyoML3LSuU1Wyo3cO+G0khVByBFW
         FqEGNZBfPwn2VJDak3a/Llv7rYwOvw9bUkKja/WkS5h21PzqN+VvbS2aTIreeGVVYgUU
         RKvN9N7SU2onxvtHoMXT9wzgQFTDbsrgubQZAxxxu7uE5ON/pajnS9yS39vfwYRR1Qz6
         wKUeyFR4G6SKAkkh8z64CiL9IfjEciEWo+VhjFFxB8j6NmaN1Q3AsTVjOSyyutGIRFfJ
         qusQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWzIBXnEHTw3u+s4sZ0t8dR6pMrY1/4m8Omg9QAm3buOzG5tXG/2VdtPQLSF+rOYWAyfrSLhVgug==@kvack.org
X-Gm-Message-State: AOJu0YygK8a3ocKbTQLhy1DDqUBbXmjluwv3wvSXXAD+3278dTYwk+qf
	TRmXK0JA/zftuSqDgoNgySTDnLYKmKXO5m/IME9PbHW97xwlv1xE1HkJdUPRgLSfLI/7MBooBhJ
	aPw==
X-Google-Smtp-Source: AGHT+IHUYWBrpeCypfdMxgfNzjmtc9mmMvSwDnVKS4eDk2yh+EmJ7zT/5eTOcBjrkNmlHr6bTJLq31xqdQ==
X-Received: from wmxb5-n2.prod.google.com ([2002:a05:600d:8445:20b0:477:3fdf:4c24])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8484:b0:477:b642:9dbf
 with SMTP id 5b1f17b1804b1-47d195c1cebmr30959435e9.32.1766159241428; Fri, 19
 Dec 2025 07:47:21 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:18 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-30-elver@google.com>
Subject: [PATCH v5 29/36] kcov: Enable context analysis
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 057C6C0008
X-Rspamd-Server: rspam10
X-Stat-Signature: ndt6jzuu1yeprhen1xkwx3tyjn5pgk5c
X-HE-Tag: 1766159242-665770
X-HE-Meta: U2FsdGVkX1868wMVodLzwj4IAUQTSBLUF59ug50liaDdHZVzxVhnHNk5GCLr62gl6sHloJs4dUlXNC1/pmHHICLXjqXgxZfttuze0aDzH+wQ6lEbkHW+7KuJycCEY44gAuX3sp1sZ33JyIHnRfuyExk5W2LT2lTEdBVrN3k8dq5b11GO6wlw3EP1de1bYQPuS8M9biMbbaRjoJWD0oct6PtVxKI5DJ1E29tNlDqfUvZKUuih9w6iaHcC/yCP/RiJKW5lfLcpVTOiyMahvDvXXQxwK9noGSnlI5I1kx/vlnLthNhWY3wx/oj9rvzKhgWmWwL7d/an+8NORU5ssLn7bkfUAf3LTsYSlGdNpgiGJt8h9i/DVkzPrOq0DApvKzZs8d1lccQUdF2hTUqtt+OvXym3ENfwNkIeK/tU/YrGpGLIM7TpPt0CM2JDRr+pGN21dMUlDBUd6hxKgeReiHVSu8xG+02aNC9NG6uLmKQEenGR7gxD85apIriZngzQuGoFWYY8RWDD8+buBmiufBkfaDYihas5HNiA7O/rOFM4uzR69PAAzOUEvnLGU49B5CVJijb7L3tOwEp5IGzl3AUARBSdWjnUM43azsEJLAIHKGmDTjc8pqmdqrk5mmxyGiXy1sFd9MOxc0ZUEDlMXm1kALrucgeRvq4Bm6VQBnlbA0Qvuk+CpGlUU1w53Ffa01tYUFgLZ65HThBNJdGLh1134pEiF2BefUEx/SCq8SNiv1It7Pw41/2kcCjR2JLAoDEjAEMNF4UnKkbZ70eQU8Fanqr/TD97gH7Uvc+NAa2kxUvhuMq66gHUYj4/IA3Q0qQidfFDQsUMvE5L+Rx8fRRmXbtHSxXjYKuq6mJ/bDwDnIDsXl8Vuqut1ZR/TdVOFo47ZoxF63WUbUPjxYzXo0yv+tvHkFDJ5imu/6WIhBBpt1+I1nfC87SG73sIQLeSWdExCvbJ++up7NZravPHkcs
 UJEURQjy
 /YX5cpkuO2BzK4JvBuKfQhL1zL2hxwyo8exMQANv+eVTVxBIXyKpfJCEYGil/D6iMtLBC45THLpKjRgy0oLNLdznnn/ZlyAh9okfvCQuTjOKYSLjCFbRMhHr4uMIkcACUkYbs2N3XtemT51FMlRw2sTWzTe5+Jgsopm2R+SFnVyuHFgnxR0Jvnt8ZnVDPeSx3nsJu1WmlkeGGraN3eY0ogi/gtWZw01YBf+dDpAMFvmjv3W3Et4TY04FaiseOOn5TeZFyR5y3r6XKglwq0qvCufaLiHqeM0QnvDaQXlU0obv9C8SrBb1YRQdXyru3qocQdfx2Ld9uQiiC7ZIpi45ldRjgH6fMQEEpVUHUyuhGcu/m69AeEK7hwQTaJKIqsmRTromP6R0368aqO0U66JQq7q11nZ9PzySe52XLXYlNAaRcWjN6A3eaOFC4quQThqCbMbgL0Hr2s6UbntoMkMhzrulNDiRxDFJQQic/KY51x+7bTzF+KhSm3Ekc+KtQV1kTps4XzDan6ktCYYC2GZcdzlz2r2dIvsyw1M0VqPBnoz6GSqtp7a5PcP9nL/ayy5VvjU5NChKvnvqzQRBYso3U49DA5d7II0yxdJyUUXb0BMBJXWVgTeOya2Jv8uTVBjSH4NRGV0j5UTV4Z8EHzN8/k8vG6s2GGXoGSfSLGg1hvd1tNM5uXEy7g5UQA8EnCVcRtYbw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for the KCOV subsystem.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Fix new temporary variable type.
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
---
 kernel/Makefile |  2 ++
 kernel/kcov.c   | 36 +++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index e83669841b8c..6785982013dc 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,6 +43,8 @@ KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
 UBSAN_SANITIZE_kcov.o := n
 KMSAN_SANITIZE_kcov.o := n
+
+CONTEXT_ANALYSIS_kcov.o := y
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 obj-y += sched/
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 6563141f5de9..6cbc6e2d8aee 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -55,13 +55,13 @@ struct kcov {
 	refcount_t		refcount;
 	/* The lock protects mode, size, area and t. */
 	spinlock_t		lock;
-	enum kcov_mode		mode;
+	enum kcov_mode		mode __guarded_by(&lock);
 	/* Size of arena (in long's). */
-	unsigned int		size;
+	unsigned int		size __guarded_by(&lock);
 	/* Coverage buffer shared with user space. */
-	void			*area;
+	void			*area __guarded_by(&lock);
 	/* Task for which we collect coverage, or NULL. */
-	struct task_struct	*t;
+	struct task_struct	*t __guarded_by(&lock);
 	/* Collecting coverage from remote (background) threads. */
 	bool			remote;
 	/* Size of remote area (in long's). */
@@ -391,6 +391,7 @@ void kcov_task_init(struct task_struct *t)
 }
 
 static void kcov_reset(struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	kcov->t = NULL;
 	kcov->mode = KCOV_MODE_INIT;
@@ -400,6 +401,7 @@ static void kcov_reset(struct kcov *kcov)
 }
 
 static void kcov_remote_reset(struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	int bkt;
 	struct kcov_remote *remote;
@@ -419,6 +421,7 @@ static void kcov_remote_reset(struct kcov *kcov)
 }
 
 static void kcov_disable(struct task_struct *t, struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	kcov_task_reset(t);
 	if (kcov->remote)
@@ -435,8 +438,11 @@ static void kcov_get(struct kcov *kcov)
 static void kcov_put(struct kcov *kcov)
 {
 	if (refcount_dec_and_test(&kcov->refcount)) {
-		kcov_remote_reset(kcov);
-		vfree(kcov->area);
+		/* Context-safety: no references left, object being destroyed. */
+		context_unsafe(
+			kcov_remote_reset(kcov);
+			vfree(kcov->area);
+		);
 		kfree(kcov);
 	}
 }
@@ -491,6 +497,7 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 	unsigned long size, off;
 	struct page *page;
 	unsigned long flags;
+	void *area;
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
@@ -499,10 +506,11 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 		res = -EINVAL;
 		goto exit;
 	}
+	area = kcov->area;
 	spin_unlock_irqrestore(&kcov->lock, flags);
 	vm_flags_set(vma, VM_DONTEXPAND);
 	for (off = 0; off < size; off += PAGE_SIZE) {
-		page = vmalloc_to_page(kcov->area + off);
+		page = vmalloc_to_page(area + off);
 		res = vm_insert_page(vma, vma->vm_start + off, page);
 		if (res) {
 			pr_warn_once("kcov: vm_insert_page() failed\n");
@@ -522,10 +530,10 @@ static int kcov_open(struct inode *inode, struct file *filep)
 	kcov = kzalloc(sizeof(*kcov), GFP_KERNEL);
 	if (!kcov)
 		return -ENOMEM;
+	spin_lock_init(&kcov->lock);
 	kcov->mode = KCOV_MODE_DISABLED;
 	kcov->sequence = 1;
 	refcount_set(&kcov->refcount, 1);
-	spin_lock_init(&kcov->lock);
 	filep->private_data = kcov;
 	return nonseekable_open(inode, filep);
 }
@@ -556,6 +564,7 @@ static int kcov_get_mode(unsigned long arg)
  * vmalloc fault handling path is instrumented.
  */
 static void kcov_fault_in_area(struct kcov *kcov)
+	__must_hold(&kcov->lock)
 {
 	unsigned long stride = PAGE_SIZE / sizeof(unsigned long);
 	unsigned long *area = kcov->area;
@@ -584,6 +593,7 @@ static inline bool kcov_check_handle(u64 handle, bool common_valid,
 
 static int kcov_ioctl_locked(struct kcov *kcov, unsigned int cmd,
 			     unsigned long arg)
+	__must_hold(&kcov->lock)
 {
 	struct task_struct *t;
 	unsigned long flags, unused;
@@ -814,6 +824,7 @@ static inline bool kcov_mode_enabled(unsigned int mode)
 }
 
 static void kcov_remote_softirq_start(struct task_struct *t)
+	__must_hold(&kcov_percpu_data.lock)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 	unsigned int mode;
@@ -831,6 +842,7 @@ static void kcov_remote_softirq_start(struct task_struct *t)
 }
 
 static void kcov_remote_softirq_stop(struct task_struct *t)
+	__must_hold(&kcov_percpu_data.lock)
 {
 	struct kcov_percpu_data *data = this_cpu_ptr(&kcov_percpu_data);
 
@@ -896,10 +908,12 @@ void kcov_remote_start(u64 handle)
 	/* Put in kcov_remote_stop(). */
 	kcov_get(kcov);
 	/*
-	 * Read kcov fields before unlock to prevent races with
-	 * KCOV_DISABLE / kcov_remote_reset().
+	 * Read kcov fields before unlocking kcov_remote_lock to prevent races
+	 * with KCOV_DISABLE and kcov_remote_reset(); cannot acquire kcov->lock
+	 * here, because it might lead to deadlock given kcov_remote_lock is
+	 * acquired _after_ kcov->lock elsewhere.
 	 */
-	mode = kcov->mode;
+	mode = context_unsafe(kcov->mode);
 	sequence = kcov->sequence;
 	if (in_task()) {
 		size = kcov->remote_size;
-- 
2.52.0.322.g1dd061c0dc-goog


