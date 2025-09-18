Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D46CFCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C9B8E0139; Thu, 18 Sep 2025 10:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DD98E0112; Thu, 18 Sep 2025 10:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72F678E0139; Thu, 18 Sep 2025 10:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 596008E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 317C2B6FFE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:46 +0000 (UTC)
X-FDA: 83902546812.19.3940772
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2CAA412000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HqGHSaGJ;
	spf=pass (imf29.hostedemail.com: domain of 38hHMaAUKCJM18I1E3BB381.zB985AHK-997Ixz7.BE3@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=38hHMaAUKCJM18I1E3BB381.zB985AHK-997Ixz7.BE3@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL1ZnB6W2nYw8Er8y4+6suuUwE88jyGa8xAgZKu8urI=;
	b=07+iWfmgWl/kgNVmvzbmyJWljAUB6MzC1HOZeMYpEWjWeTXHJ1Fn3dhV2/rmNwwFJkqy8J
	z1Ll2ex1h6lpm/5yhg9Vh3oPP2tXCVaSdNprbhyixwcY2Y7WiBfwQWHCLCDwnHI4X/MIjy
	vbBUbCXR83yyPn2EUQiL/6bNhzCbQto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204404; a=rsa-sha256;
	cv=none;
	b=iOD8kFnlCkWrqg8NwXJHefDtkFGEzLMQfDHD/fe38MTrw5PRNHgUcZEvSiqwcvrkIX/Wq9
	FrZV1OIH4Il7y2G3NGB4gAw6IT/E5dI9ulXRoI9s8GnMnjyEnfb9zz0SYeJUvjL7702wjM
	+cCxycjeDY6hg3EPYxkuoHPFYlfJokg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HqGHSaGJ;
	spf=pass (imf29.hostedemail.com: domain of 38hHMaAUKCJM18I1E3BB381.zB985AHK-997Ixz7.BE3@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=38hHMaAUKCJM18I1E3BB381.zB985AHK-997Ixz7.BE3@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ecdc9dbc5fso664878f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204403; x=1758809203; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sL1ZnB6W2nYw8Er8y4+6suuUwE88jyGa8xAgZKu8urI=;
        b=HqGHSaGJG/8nEHLpxmvQbWwL6cbHYnu8EemQkK4Rm8n74seFPQuYVGzidcHHxE/h3R
         0wABjWMNUDH2i3QEmm/mp6SDWsqyvc/2XYDk0NZIsirLSFQIBefkUOfa4p+A0+5veNZi
         GUw9YSbfpDJPtlU7GNq4UjOyfc9ExMkLGIdbD+NyHRFWyY6Fg6EnJlUMZ/LlKFhi+Sel
         0xtVsjQ9kpIupiSkk492p4mpC1yKE/3VaaQ2IwJ0JEWh6nN+VPXk4zlhLxyxryf8Qz7h
         aMKBlnc2+MxbH97NKrzzwW1WxHndygOIpQD7fk2jzPIsCI58ZvK95onYtiPirhITZO6d
         WX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204403; x=1758809203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sL1ZnB6W2nYw8Er8y4+6suuUwE88jyGa8xAgZKu8urI=;
        b=xGYtztx7f49gq6/YERyHnRiWlGF7KtuwXBnSDwddceegoIABdpq37WYdDAFKBJIJgx
         P8abT5sBxr2FTK43XOyxEqvLnMBZbk7gJPOY744jr20d8wCgLkLuVvdVszwz5VoN/TKl
         z53u9w96IAlZdbN7Ia8dtOGjpmUICClynNNcuJ0o+a+lG3I9b6aR+jeipyFltUGSlemA
         RQJtEzVR9EG3Z1qFP+IVIw8Td4c/aJU5OHpW0143FzU+nFKp1XTe9MmX5JPGVZ6t+MZc
         x1MnE+1vBmk116kb/pM+wu8NrkScQ8/MD6TjUFjlqKyw2AbHBh4itmO8DcjhhqbDOwkw
         OOIw==
X-Forwarded-Encrypted: i=1; AJvYcCVQsYVz75rowrnLytvGehMnLXDFL/7ALReu3SSR00YD5cDQg44L5UeTLewVyLVduHIm2Pbsu2xtBg==@kvack.org
X-Gm-Message-State: AOJu0Yzk7mfM5QNXTDpXhGzm4TZx+kssX53tBMfgctftmAQoZ4sYRRgp
	xmCsJY9sYbT5UaC14rY3bmXNbme3nqg5usDcup3fAdbbGgydnUlQinswDNRjc8d7aG8UFr2sfkt
	fZw==
X-Google-Smtp-Source: AGHT+IFq6l1CqjXgiNcBcWNKL6xEs9xR+qatYFXvzs00KaeAWl/w3hKbHi7xezdlgvdVg1z76xYInw8SeQ==
X-Received: from wmbec10.prod.google.com ([2002:a05:600c:610a:b0:45f:2d3b:d046])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:508f:0:b0:3ec:e226:d458
 with SMTP id ffacd0b85a97d-3ece226d48dmr3622785f8f.0.1758204402649; Thu, 18
 Sep 2025 07:06:42 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:39 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-29-elver@google.com>
Subject: [PATCH v3 28/35] kcov: Enable capability analysis
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
X-Stat-Signature: s4yodc3n4ki9ntca36x6ah9xrigsks61
X-Rspamd-Queue-Id: 2CAA412000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758204403-791100
X-HE-Meta: U2FsdGVkX187rlnerI0XC8mHuX0tfb+T67l78h1UBexdTbDp+DPyYyWZb2LhuVlPuj1o20zQbOGJyayseu6AaTEWFw2eKFFqu4g5pM9rDRUWEasZSkzli6BYMOZsoXpo5tR9/hporSfvW02GWcgauKfoRLH7DfhwwhmN7ZIe5QNLRtzmDNqImNAId1TQ1I1koeJtDH0ZkbnXgnRv8JJpy3JaVq15UowWAr2NVUvLAzcEfkS1MRwXomHRlSn3pK/rrM2t+nZMD8rKTIrdtmnD3m089ICDF4fdtnouHkD0WN/vdh4MSGIQ87l3mcSb0XZBA+dUUxBetMtlN/K1Mq1dN2Uotr4oqcrmaG3jfJqwsCR5HhFW5vsfskG1k3tEhN5tAN5x8Tnryf8ojLgTXrMQjMSgWOfL/90dEy1Alw+iOUrmRxqV7z0gpeqJ7QXBbkfEGAr/IPIY7TLAYN6tFYXmWs2W1WEfk0TCYLfUbGMS4TbJrsvryBsT7MfNshSZyH2FjKzcZZZpLrAQp1u/aE8U8X8ms7y2nsbgC/XX4TM/cX5KKX9i36Eg7dho5tz11U+r6G86o44XmxuboMyPpHcJKXE3XCNX0Vg3HJMj5ZEv8k92Mg348KtYELVKXR0yN8tyI//MobmB5zlaxfwBi8EtH65UvN0IQDod24JiIkcat7ERVSC0LqPxU/WZLPvPWsN/dFsAym+7e9D3hn8Li2iQP3unWXR2C2wgTtdvAzI05e/i7K+DERkRlFIkVyb8jHldewmEFo1h9GHzHhVh7QiwVVrO7WKsNG/NEZmyMySbqJSw2y4ctuD9FuABPLEDw7PlUljhTIBskW2qI3uBax4nmnIstiCcDr8RTp/RkTnIhF38Nejg42dT7kZBFvKUXEW9jaA5m8zBxQ94Xn2kw5dHNHygkv8O2x6D7RmOU/KW3vHOCFR6lksD0rVQxEGg6Liu50yc2q/ElQlNgr6nLYs
 HU3+vnBW
 KaKFcchRw3uxkB4ZcuzlIQtCiEMq3rL1OevW4W72xFm3pyHOArWlozHJfeW2p1UWMU4dL8r7gPu0PcP+LBHKQ41vJ4Yw7jx8waYJQHlE5ESL9YgRE4M64zHMrO+wMkiZWp5HDQ645IkPtgMsUmwdnkwVr3Gp3iKPpJ28JEiJSKiOuklNMPicpP7MS0bRR+Xiu/KtEwP1bJekarEhkLTVPDm0usB/NVmY9XnRlqkqCWvbIJ3cI07c+2TfPZTq0k0/GQStNlS5pSDMW3lchOnabk0uDcPLE1M+rfDu7QXuidWzlcyswd9q0LtS82q6WMZsxzQ+ZISKwNIGCGokJtlpkIXRb0fvY7VUy93Sq7Ny7JN+qyk4ADyNuP+n1qmSiJq2xbHEmXsJmQRW1l+AShcHXDnYNJtCs5gpFcsKl5HbBeUaFFxKx4ekJjq8qxD8boWLaUPtUcqy+9YimcwxeCvkLRu6N4B6ejUqVoA91fn/yGj8k1299Civn+odfejvuanlRCRa28g2i9thCzoRnQXsAp6nEXDjtKUgKMbiHMlzUfe0TIWsxRmPOc/oPDJ9lXkDe0jy8vnlI/UyaSUTasW8pSI6DMAwCECEIjPxPSIpqT08kqSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable capability analysis for the KCOV subsystem.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Remove disable/enable_capability_analysis() around headers.
---
 kernel/Makefile |  2 ++
 kernel/kcov.c   | 36 +++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index c60623448235..2a2a10c6a197 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,6 +43,8 @@ KASAN_SANITIZE_kcov.o := n
 KCSAN_SANITIZE_kcov.o := n
 UBSAN_SANITIZE_kcov.o := n
 KMSAN_SANITIZE_kcov.o := n
+
+CAPABILITY_ANALYSIS_kcov.o := y
 CFLAGS_kcov.o := $(call cc-option, -fno-conserve-stack) -fno-stack-protector
 
 obj-y += sched/
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1d85597057e1..1897c8ca6209 100644
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
+		/* Capability-safety: no references left, object being destroyed. */
+		capability_unsafe(
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
+	unsigned long *area;
 
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
+	mode = capability_unsafe(kcov->mode);
 	sequence = kcov->sequence;
 	if (in_task()) {
 		size = kcov->remote_size;
-- 
2.51.0.384.g4c02a37b29-goog


