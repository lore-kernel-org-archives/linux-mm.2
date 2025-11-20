Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952A4CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA186B00D0; Thu, 20 Nov 2025 10:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8AC36B00D2; Thu, 20 Nov 2025 10:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79AA6B00D3; Thu, 20 Nov 2025 10:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C21D56B00D0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89A6B566E1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:43 +0000 (UTC)
X-FDA: 84131329926.30.E0D7905
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id B517C4001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ALP8XJec;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3IzAfaQUKCFAw3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3IzAfaQUKCFAw3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651621; a=rsa-sha256;
	cv=none;
	b=SP6MZkJgvDFcZCYTudBu2p/s/SFaCqtljjOvOmxpFAXPgUXVigEHqCHo87yx7Sje+J7LCG
	PxKN7ECTI31EX5E9mdWB5Sy9HbT7gnkMM6GrUvQwntEWxfS3hiIj46itl4comajtHsnAiC
	OMsSpGiBoVwGNoqErgFbpoKv6ndCi4A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ALP8XJec;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3IzAfaQUKCFAw3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3IzAfaQUKCFAw3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcD6uieBoqcsyDkA1zkurf5hLc/pXwP1OAaVy3DV1GQ=;
	b=VniCaLmG1yx6euzu/OHld9S124yAq99nKYPfJabEklZ6XKEKOn3GCO+3kPj3OaGUgR6ovq
	kHTX/ce4z/6WjkNSNPFwMbryW73oad5efCGxsDgcopybQDXKgPPrfptGZ9qClcA6SwVm03
	yqSFLp4nj2m/WYP3kjO7RWKJSmgp49I=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42b3c965ce5so789099f8f.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651620; x=1764256420; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pcD6uieBoqcsyDkA1zkurf5hLc/pXwP1OAaVy3DV1GQ=;
        b=ALP8XJecoDvwJ17tulVOFlFwnalKztm3Skr4KfqJVp/1YbNPxyOzh+PhEY1QzI86iz
         700YT3GOJpf45N9YiJjULO9FglMtb+TP6tjaaTJwC7NdYyYu+d7uo1sbNRCvuiloWfth
         hgsKeInHkgOcxGcHHPDHrye6zuzZgqq+0ygpArv6OYpb+yz6XYzTmQQGwrQSBfxU4MS6
         dTJFPogRJLRfH/zhGJgjteyCpOeGZ3qmVhAq6WIteL6hUomRPINKDi5VKdZhLV1nWUBU
         sz5QqyI95OTEzQBeGSj77Z4UOgk5qCmZnOqoe+vDve3f3/b9joQP8tSjO/2WE2J1soAT
         DUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651620; x=1764256420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pcD6uieBoqcsyDkA1zkurf5hLc/pXwP1OAaVy3DV1GQ=;
        b=XlFvRaKr5eZEgkxm8g+l0+6Kym7VVXuTimv1KK4SoUjg1K9p/33LZfPo9FZC4dnVJB
         iVhwZyfDPtEOc/m0ypqsIecBRlMlfdH2ElXZ4fsRCEnRirS3lAB28Hntae+kSPkj/cRo
         HZVG0DJ6NII1FQ4vA8AHOcP6VCrOO/cGIU8bEh93RtCn/sIme1HGhiwMZULyE+Aqdvzq
         09gO1n7kFM7dgKiACy4dHLBzhWvpPnYkIg11qO8E+T2T/3nL81GyB1m495c7yoTtsGoy
         1DFoY8KV0JLK16Ji3Ny/+3Q+SWkLJB+Rw21jSjTr8qw7TBCAxw/VCFXLEJBBtzfvDi5m
         G1mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDVL7d+9PlIbMEOPcgtGx/Yh84K8I2XOH2K5hcht0jsS6TWG+bGDmUYpQOl+BnUTBtSPqtRhDrHA==@kvack.org
X-Gm-Message-State: AOJu0YxmetIVwQ/yuw6QLc5yhPDlPjhP7lRCttOYLgeMWqfRLB7VocAp
	tLvu9yPMiuGpqGFPcINVEGUVixruqBM6jIzqUnF42cCF+kQ2pj2QzeGI9lkF1zIZi2FSqoUs/Pn
	6QA==
X-Google-Smtp-Source: AGHT+IH2phiGswjRxahv1kYcFFnsn5EpFBG5GTvKLIn0Gw3adW5QmNBoQt0gQRrs7c/SRmL4IrpsGmOf6A==
X-Received: from wrwn2.prod.google.com ([2002:a5d:67c2:0:b0:42b:349a:10f6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2002:b0:42b:3746:3b84
 with SMTP id ffacd0b85a97d-42cb9a6acd7mr3408354f8f.55.1763651619825; Thu, 20
 Nov 2025 07:13:39 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:53 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-29-elver@google.com>
Subject: [PATCH v4 28/35] kcov: Enable context analysis
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B517C4001E
X-Stat-Signature: twtakp7715xyof7xyc5uezbg9w5masy8
X-Rspam-User: 
X-HE-Tag: 1763651621-853846
X-HE-Meta: U2FsdGVkX19RoLaJZXSwanlB/DdqdTeYtNNwykZLm/aClPh+Hr+JNdMKPEXZGYZDU6uQXgL6Sgq4aIJMkKeaSDkul012VTOXD4bF/YGf8SfyVgFXlzxjTJbQz1zsAUJwx1bJHk6vz8NraE5cyGOA2CH3PxFfs8p2AMr8c5vLbYMXN766iOGEBrvE0ktWMbmMIUwbyBhuvWNrxfE4Zx119agYnO7sE4ULVHcUDNE960ZrdwhSy8q0TMGUdeGg+/1ODMB7KmzohemHyIKmL+GQbIhFIluwtVPAlouA1oYvyQvDOedZ6uK/OB3fihNpbsmkqbJVQh0PWwUSXM6OsLBe5Sm9n5NwJDyyGufoIej2nVX7SP0/XzozY5mWctQ3wUzZxEjWSZP6X0oURU5qHFYe3NgQHnFQp5DhsXALamNYFCH+T/Xag0Hj/ID1XUIsuc+nSG9szlugbEOh3cLm3CvRIYhqTLzsdjhW7dWQWqHIj9tjLgF6RtxMvMMeCCVp1YLpJc4tDUOp/05uGRbmp8Qn5KZPVBZze1/3PTuhgkJ3J0Yq45pKqgbSX8ZZ8IVdGgyNL2baxmTe4FGEjVpx1YbTUyka6fpsu47Q8vNbxbbXL2Nq+2yqWXIcETf8tLeBdQo2Hv5nTu7L9PERq6c4sXd4vPXJjHsDdK2vtgmXTD1vrSj9FCGp8SruVQR03IGp6hpu395Uh1wrJuL+VoxothJjL8soydX4k+2isqFBPx8wTYZ6dxTl9lUDxT9BYXfNmOAnhZWAFE2/YuK3yv7AvUO75dFg/kpGy1qksCFdlnWT7i07uSNXmA2SnhoI7hvtpCWlB2Yr0Zj5w2aQE8AH/ZAG1X1EnU6vElPCAxZnhNsj43wsx5RIRAY2dC8qt5mopdb676lNX/A/cyriHZs4S5gM5FnAzeoAfm70ZmriP0StfimQoyloMjrRaw/vvAYcC930mFmmsbiaeqqh/wbnotL
 rZ1Y7gKT
 6mPKpjaI8cjnrb3ZzSTAqHtKUTjOuw/jBqGU/sOU/o14Hw0eDtsDPhLkLo55JOrPxs8k/FWrtQbIieA6OvKXyGRKiT4Ljje+HJJKz189Xxh+brv6dBwFSCzTPb1GST+0nHShGMOsh9AhfwnXomgiJF6aDgdJdsc6/mDvr1cBGejB74G9xKwVGF8NdHkkM9gv6TVyA3Xp0MCIrJfb6pe2nVLSfi69rl0Fu0wHw+FPFnYjn6dvfhtN0K+D9WR1cM1JMVKHq2anqvb75A1AQPcwGl3FWPVh2XitQ7qRNBAOvYn7MuCG62XrhWkZBzjdTBEq2fBSuVW867lqVZZqXcXbP1uHv/zJZJiRfvTookc1JCSxofeJwWYL4WAe85pjXAatJDHDjRuULyH7mHLFrinozeKOzcVyKY4Yk0cMW
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
index 9fe722305c9b..82d49723904d 100644
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
2.52.0.rc1.455.g30608eb744-goog


