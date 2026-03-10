Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45BFEB1062
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326056B00C1; Tue, 10 Mar 2026 10:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307766B00C4; Tue, 10 Mar 2026 10:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230066B00C5; Tue, 10 Mar 2026 10:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 146D06B00C1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:56:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5F79B6B47
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:56:34 +0000 (UTC)
X-FDA: 84530454708.25.13B4F75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0D52D40006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:56:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AbuLZbtr;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXUq0XD9WP+4pg26/6VEE3ViOQnNkdyIR9z/RGUCnw0=;
	b=YGigtEDXeynSU9HNlgbTkjuuKo5IF8/8gSJI59IYFnMggCyosFXzQa1eEcxGIYykzgYSH3
	uUmOKscUs8hmDDL4Hn5oF7a696hF9qqoav34+L3O9hovEs/oPP0GS7Ba8ipgNeEVisGrzb
	IvxYeFcDBKqP+u2fdeYGcrsQXja9pNg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AbuLZbtr;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154593; a=rsa-sha256;
	cv=none;
	b=ItiNPEKMSWrnZK/Kjm5RB5fcQyNwYzHNQZet8PEtXZQidYtqYhN74tFcOgYOGpDHxCT7fH
	udTSQ53AvAt+MRSKcurdms4See5s7kxxPf9FB8A7hAi9EY7sS0r2NxffYVMalcqPR8sbZc
	TTBaXPPE7IROzOdmt2aWi6yHiLamm40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D5E3409E4;
	Tue, 10 Mar 2026 14:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A706AC19425;
	Tue, 10 Mar 2026 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773154592;
	bh=MHAAeqITSgAjja+L5nbHM5Kukkj1HvizJNSigDOYsIU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AbuLZbtrFQ2eEP/CSDfXv2VVj6ZTPsn2boPdFdefyNYGiud5pf1lZ/Yst30PPwQ8C
	 zp+cc2YsZjspEYtoVIqmH7ecAftlZqJNshugjq4aR+Vuidpx/mNiFf3OvSrsWQBJ2M
	 +XtPj6XHmk5Ut3BY373v9kmQbWN4HUrHZRna+omiYQwwb4+6ntjvWwiztidnpEWzrv
	 28P8AoDDbgXDe9Cxtdtmy8oByboNoYRIjEXWUXYoBVDUrvYUGa0ecVlqy5v9DQ5fOq
	 YDusNUQ57UiXoJ0P4H3Rn2YYwJf0lb8lqsjYvImYMQxkLuoWVE2yV+u16rQBh4lE5M
	 aVEsH7YsI8IKA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Mar 2026 15:56:09 +0100
Subject: [PATCH v2 1/2] kthread: remove kthread_exit()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-work-kernel-exit-v2-1-30711759d87b@kernel.org>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
In-Reply-To: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-nfs@vger.kernel.org, bpf@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 netfs@lists.linux.dev, io-uring@vger.kernel.org, audit@vger.kernel.org, 
 rcu@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, 
 Christian Loehle <christian.loehle@arm.com>, linux-fsdevel@vger.kernel.org, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-9fd7c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4676; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MHAAeqITSgAjja+L5nbHM5Kukkj1HvizJNSigDOYsIU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRuMBQrcElj2ixs13jGuG7pat+rn1Y5/+yRjs/VXcp0a
 OYEru1hHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABO50MbwP+zCA8Nk9krfpfwr
 n+ZP+c5VsObWkfmHl72MOF88Ka9gRRYjw96skCWv8g/2TvizTfh03I937t/W5H5bHhwvay23zEm
 hnwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D52D40006
X-Rspamd-Server: rspam08
X-Stat-Signature: pju5djeda7rde41fakgmk14f85xh63d8
X-HE-Tag: 1773154592-232913
X-HE-Meta: U2FsdGVkX18ekvTnEGyizwslFhAm/+0wMLP7jtFkX/maI3+D/GPel54vo+c58bV06z+iYx1Ho+4fNoczU9YvMTIqNUeLJp3JGlD/exLRbefhb2i1vWWY7/Vnxa7HQCWb1xhGjyuHKKPG6UfTfrTlPSFf0/19gh/CzUJ4X/My87WLgcczX0QqclfnDK/mE2+/3HNSOCnP2EJsegVOTQk7znBM9SwX47cR2oDCyurPHtVj8+UHDkJk/iTbr15euV147lHSc2pNGCVkOe7dNb0/OzE1DPue6QBkP+H1ZM9bdYbyu4LWP2cJi/1jzUV1l02w9V1ZEQLwhRFNK6dYGvUIr4Za9Gaf9eQyOOM3xhO1MWg3TV96bYKqssAaxii0wEEjlVWYrKuEPmnJI7Y27Q8CkheCNep4oAe4FSUmemd7QZEKsFYtcBo3KRU9SEm8vja+t+6KJwosRrw9mKEs530MavoRbfMltZ5kQXK6zmNL2njNCOKqj53Eiz3yg+fbhGLi7DnfSUn+vXQoCkKlqYz3EZhv9+rl3NVul3WB8WJPJlnMIKn0woSoDUrBF1DS63SDmqt5Os1eOwyRPLfFb8eRJRgxr98uwkBSoaGGZPP5w8g2p+Gp+1+8JvZLbHV+its8PoIhN9U8AeHqlF7r5c8bV/+OqotQoxEd7N1kc2vZSCXPSc0Jw5BhK5sJ0wFAHEgoFeHp0IOOv3v617WiMjSOxLOOVxJCkhfB+gDv5BHh4afStqojvwGAVo4lZKcHytIz0BY3ayGmASCNgSBrX7AmY19ESdnijZMJFvSTPl0qqr6lB+U+L9CWDEOaR2ynfNGCVdEI47mre6kfqbwwUiexZ5RuQrlS0J2QEk3HUNwXVjLh+xlUUt7RKV70SdghktPy7BLfB2sOzcMw9gmD0sAM276eyJd4FSrLhvSTL64ayvEVD65XncUcK9e9t19ZROqvO/J3gZA7fe82eCjRrEN
 t+h81E8n
 QI9cs0RJFDfeTj/Y/wF7xH7C+g8K26jCgzxbSwJjJI0gC7WkExZm9DPAnfDiTWGeG6yGjpZ8odHitypfcgkhtyRSXbsb7LmQtB6t3FwJT4ddu5QJsUvNCYqflIyKUJ4jtDnU2lLxv2V4jEUs0vJY9G80O3SB5i/SGXEYObOWJT7EVX0xeIXYyz/uUMrFH+jL4uUrNPphNA3OaeanHZgx8h9mY2O0pUikxu9jlIrlGw1qH/l5va5kzB3PWH9lo0IV57cV9aaJYAOnqiB9Xmzt5NHxFeu+8+24vgBfYgbr4y+tdQ+f2tr9Y0ucPnpe6qNsQaR/L7shw0xMeTw+WUxzw3eQYk9LtQUimHoZXllj89DxzojtdjrbWgpWAKbMasbOI49ST
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In 28aaa9c39945 ("kthread: consolidate kthread exit paths to prevent use-after-free")
we folded kthread_exit() into do_exit() when we fixed a nasty UAF bug.
We left kthread_exit() around as an alias to do_exit(). Remove it
completely.

Reported-by: Christian Loehle <christian.loehle@arm.com>
Link: https://lore.kernel.org/1ff1bce2-8bb4-463c-a631-16e14f4ea7e2@arm.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/linux/kthread.h    | 1 -
 include/linux/module.h     | 2 +-
 include/linux/sunrpc/svc.h | 2 +-
 kernel/kthread.c           | 8 ++++----
 kernel/module/main.c       | 2 +-
 lib/kunit/try-catch.c      | 2 +-
 tools/objtool/noreturns.h  | 1 -
 7 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index a01a474719a7..37982eca94f1 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -116,7 +116,6 @@ void *kthread_probe_data(struct task_struct *k);
 int kthread_park(struct task_struct *k);
 void kthread_unpark(struct task_struct *k);
 void kthread_parkme(void);
-#define kthread_exit(result) do_exit(result)
 void kthread_complete_and_exit(struct completion *, long) __noreturn;
 int kthreads_update_housekeeping(void);
 void kthread_do_exit(struct kthread *, long);
diff --git a/include/linux/module.h b/include/linux/module.h
index 14f391b186c6..79ac4a700b39 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -855,7 +855,7 @@ static inline int unregister_module_notifier(struct notifier_block *nb)
 	return 0;
 }
 
-#define module_put_and_kthread_exit(code) kthread_exit(code)
+#define module_put_and_kthread_exit(code) do_exit(code)
 
 static inline void print_modules(void)
 {
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 4dc14c7a711b..c86fc8a87eae 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -338,7 +338,7 @@ static inline void svc_thread_init_status(struct svc_rqst *rqstp, int err)
 {
 	store_release_wake_up(&rqstp->rq_err, err);
 	if (err)
-		kthread_exit(1);
+		do_exit(1);
 }
 
 struct svc_deferred_req {
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 791210daf8b4..1447c14c8540 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -323,7 +323,7 @@ void __noreturn kthread_complete_and_exit(struct completion *comp, long code)
 	if (comp)
 		complete(comp);
 
-	kthread_exit(code);
+	do_exit(code);
 }
 EXPORT_SYMBOL(kthread_complete_and_exit);
 
@@ -395,7 +395,7 @@ static int kthread(void *_create)
 	if (!done) {
 		kfree(create->full_name);
 		kfree(create);
-		kthread_exit(-EINTR);
+		do_exit(-EINTR);
 	}
 
 	self->full_name = create->full_name;
@@ -435,7 +435,7 @@ static int kthread(void *_create)
 		__kthread_parkme(self);
 		ret = threadfn(data);
 	}
-	kthread_exit(ret);
+	do_exit(ret);
 }
 
 /* called from kernel_clone() to get node information for about to be created task */
@@ -738,7 +738,7 @@ EXPORT_SYMBOL_GPL(kthread_park);
  * instead of calling wake_up_process(): the thread will exit without
  * calling threadfn().
  *
- * If threadfn() may call kthread_exit() itself, the caller must ensure
+ * If threadfn() may call do_exit() itself, the caller must ensure
  * task_struct can't go away.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c3ce106c70af..340b4dc5c692 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -228,7 +228,7 @@ static int mod_strncmp(const char *str_a, const char *str_b, size_t n)
 void __noreturn __module_put_and_kthread_exit(struct module *mod, long code)
 {
 	module_put(mod);
-	kthread_exit(code);
+	do_exit(code);
 }
 EXPORT_SYMBOL(__module_put_and_kthread_exit);
 
diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
index d84a879f0a78..99d9603a2cfd 100644
--- a/lib/kunit/try-catch.c
+++ b/lib/kunit/try-catch.c
@@ -18,7 +18,7 @@
 void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
 {
 	try_catch->try_result = -EFAULT;
-	kthread_exit(0);
+	do_exit(0);
 }
 EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
 
diff --git a/tools/objtool/noreturns.h b/tools/objtool/noreturns.h
index 14f8ab653449..40c0b05c6726 100644
--- a/tools/objtool/noreturns.h
+++ b/tools/objtool/noreturns.h
@@ -30,7 +30,6 @@ NORETURN(ex_handler_msr_mce)
 NORETURN(hlt_play_dead)
 NORETURN(hv_ghcb_terminate)
 NORETURN(kthread_complete_and_exit)
-NORETURN(kthread_exit)
 NORETURN(kunit_try_catch_throw)
 NORETURN(machine_real_restart)
 NORETURN(make_task_dead)

-- 
2.47.3


