Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7708ED7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF8C6B00D1; Fri, 19 Dec 2025 10:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1116B00D3; Fri, 19 Dec 2025 10:47:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5EE6B00D4; Fri, 19 Dec 2025 10:47:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7D26B00D1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54C75136BDF
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:40 +0000 (UTC)
X-FDA: 84236650680.04.50C8D9A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 694A918000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BVBFMVnJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3mHNFaQUKCOULScLYNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3mHNFaQUKCOULScLYNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159258; a=rsa-sha256;
	cv=none;
	b=lOMWq8bIOnufu3U6ZrzzUE76xeZmu3RjYN2Phn284AWio2H3ltZIwjRppNOG/cuq9hvPcc
	O49Qg2HQI9Rn1EAqgrCgWzDAvYsAYpC4vGoHkM1vf5vwzGUdwEDY3Vi8V1yVRwA12yGI+Y
	yToHGw58fJ3FQ0PD8KEzMAEEyQgtwX0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BVBFMVnJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3mHNFaQUKCOULScLYNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3mHNFaQUKCOULScLYNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=raJvaZBiGWdUURg4IuOfBi51C0gZUEAs+Zv74eOTMUU=;
	b=0u/UkEKHueaujrCnHB7F6djEv0q2b2NYMxK1NKROjlv8s+zTNWZnHQaYZ/lqkNKxs21gPU
	Z7ej30M0V+jp2jJZes123pmoIAY3biHltt4fnk7o/RJbvQqp/C7kbP8Ue1smK+IBZRyZPS
	EcbNcecDSQM0pOC6AZ1dnLWwpXjL++Q=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47910af0c8bso15827045e9.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159257; x=1766764057; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=raJvaZBiGWdUURg4IuOfBi51C0gZUEAs+Zv74eOTMUU=;
        b=BVBFMVnJh1j4oVImIlxFnEOMFvHDhi891F9LHYLqKzK+3hQlsFACCNv/+cApw0nIdU
         fh6TjLZtHFxGwRqg5o52qoQV/egLikUBogZzusEgFYTY/ZQ8JW5aucx2WemPza5bcGqh
         lbJ4fSGnGI07SXGpf1DMWg2vvdbb2i6cCCpWG0ufra2BBvdWpYhDbe2IslUtcSNTKuof
         cS9f8ByIMs86BeikahtJpbqMmOX9epwYOAT46Ta+N/po9Zsyga103K5PaxOFmq1RFVJc
         uz+TkHKymO2GKPwprRkIU3JYc9hW1QDNB4JYm2oSD4DJPNrpTgFrL/4mMzJyBsh2An+i
         Y4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159257; x=1766764057;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raJvaZBiGWdUURg4IuOfBi51C0gZUEAs+Zv74eOTMUU=;
        b=l/cZXBLh3GpXwcAz4eMxPpKln2NtbytmDT2+GKSKE/mMzpFfbI1k4fPJJ363Seewqx
         rwOSk5IG9lmfSMBSQNz3GufhcJzlSK+Y9aQbIiPzOWyfRcKTdLD++eb6aBRPoc1k5t0C
         RF9DZtg8Gr6U5OYsy53BGpp2mVDfVPyFJLlYYTzeGjXYyhWkxouwJVlEmPcRBKXf0QJg
         PhY3QS5KkGBjuX2ZvxwnymKyrFv3rzLHWTeUZ7M+jUohnpjwxdOpBHdVt7fx4NCvQfN7
         48XjxNP4pmBrJXt+gHhcJC9z+khCs1FoQ9yimw+C/NX5FIk5S9cw1xDN8bYTy3Pz0dlh
         eHTw==
X-Forwarded-Encrypted: i=1; AJvYcCXY31peNyfiGnGKl/QOcScs5bYmsGrEy9SSvqTW0pfu/a+xThFZW2cS8nD3Lldu99WcfZIhn33awg==@kvack.org
X-Gm-Message-State: AOJu0Yw1txQ878oOa5msDL9MPYTumIh3EIJCyYhpeJEQOAHLeBrqiqsy
	PKBaBAz+1tUyOzT7mS8PDjGzOfcsFInlRmumkrIdOQlo4Dukh0kvhpjMYzTU5FAgdG4mYZmZPkX
	29w==
X-Google-Smtp-Source: AGHT+IE0DEBcqLPgB304KpuFyDFpAT0dXyCoUrk6DMEYAY2UUiewWpU8NKx93qOTNkEiLpHlSHZUKGwdGA==
X-Received: from wmsm38.prod.google.com ([2002:a05:600c:3b26:b0:477:a1f9:138c])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f4a:b0:477:58:7cf4
 with SMTP id 5b1f17b1804b1-47d1953b79dmr33800655e9.4.1766159256728; Fri, 19
 Dec 2025 07:47:36 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:22 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-34-elver@google.com>
Subject: [PATCH v5 33/36] printk: Move locking annotation to printk.c
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
X-Rspamd-Queue-Id: 694A918000D
X-Rspamd-Server: rspam10
X-Stat-Signature: qa4w178cqqf9scuydb4wcm1anfhu364k
X-HE-Tag: 1766159258-360492
X-HE-Meta: U2FsdGVkX1+J0lhDcrukNIMpJzt3Lm+J/J0XuQRYD7swrHLrTJoecNpvkXAlfvJdULTjXPoyWIITWu0VWSKMnJ5I+d44gLNXoPiIDr9xDuPor1Gg8v4D0lIqWcX70kntmW6BONNRe19qGthpqplstLL5sawh4D+GQY2Bkzn705nMStREWR5nvvQ6ZkpYfTBWc5MxFo8XZc0iUNG1A5kE9o45uhrHT494btDAp5szqtB3MZrEtE4rRd6OZtDpKMyZdP1EWxjdHJQFbom1fEqI2118CgG38zGtFXVT85GXnSomqbDmpHgg20g9NsnW24vS1bDI52IyoLlhn6+SiDpJOT0eJXDFeU0kud5d3rtsacgHMVOtaGvLDCN9iGsBKGvis3QSjFg1Hjz5zoXK5SSw8SxBN6s7li9tVim3ZOJlLssJ9iUulM8St/s2NfstdRjlyyV9M7KD27xmS7NMfWrs7BOmNWSpk2E063LRXFT+UXHD+rmvpwxtOdrvFRqs/4w5ag16JIDMHZIyfoG5p/92sfuPQyU7nJyY75v9f0VEhM0AgLR0c3XLeJ/iUUjNKDS35WboSzpDyAUe1mXCTXxj4Urf8x5rq/9/GgMNh0VllMw4sk3SBisCZuhxDukq0RpffuVNOPD44NgiHv6pd2sh4X/xnR2jwu6FdiIbx3Ncygqo6B1qHK1xMbKr9wkGKsmltfuOp3uJQ3jacgKZw9Po379vh3eoscZ97QlxGIEoLjceX2d+ALRZWqdU+h2XjrRC701B3hTIXYd6hoE1jxF9lbihUqtt96wfvdCwuOFdpiEaNshgEqljHIWG7Cg2HfF1wB9YL/EC11LcMUGqBkNKvLXDqSx9/zWJSFbKytGtITnx3aJilVEmrp2OSh+ewekmY9/NQN2zjJV7hjXlplSYMGNZRSwcwZJuKwh9tBCL7wMkPPcl65nrWC8tBDyZhDt8BGFJlWNzRGIkoU/ANsa
 YueL9zvB
 NgeigFMaDWYpmpNhOZ+m4lEmMmNhVDCkzScErNfqhaYmlMto9y3bFeV79z88YyF9E6apKNhKcS+qwN4b2tn7RMp79/CSKecMXKCvrtw6gov9lPmvNtsERwpB3F4Jrk96SclTWunUmFedYtK9oAA73LAlK19lAGqDo2h4c1vQOOtXkdVsIn5CDYPY9wTHVzZCFwSKZmyGdcylsX3PNEvvhfGOCU6uW/609btDCKqWWWvZxLe6t1aTJZidVcYQ+F6cOI4KbiURgawK72SdooJAVM4+atxLe16dBWJk05q86lXhF6qQkflHlN8iepO6BvxqkD72v61zWto8idQnoSYaXJbRRKlnDhDWaT79oMjfx+Z89pN/x3+puirb0Fq8QBFbHmPyTgKZXc2YXdmM4BGGOUdtU2mw0YyWkDQgj8eTEnijx2f9ukd+4NUzozfBLXnHlwZNmAWTNAvp4blVK9FGqlfLctTadZWgAG8WbkFuTdL7zSt7Cl9jQASSay2i+agOTAVA4x9DcyPqoIClhfss0D54pniXLGwbGfuyUkch3zR1UOZ6Jm7XOUBNR1XJ3jjisQSNwl0UI4mYn/6PmfvShMeITTLHDZ9LcolIUZWlWjSvaOQjCx0PgCtqIwYHWPv2unyh0KKSqtfRMFLdJHsX+3mlnBiMlkfOWR5Ym3NWqUqwVgQPPeI2aVKk6QLklpJbDBgt/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With Sparse support gone, Clang is a bit more strict and warns:

./include/linux/console.h:492:50: error: use of undeclared identifier 'console_mutex'
  492 | extern void console_list_unlock(void) __releases(console_mutex);

Since it does not make sense to make console_mutex itself global, move
the annotation to printk.c. Context analysis remains disabled for
printk.c.

This is needed to enable context analysis for modules that include
<linux/console.h>.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New patch.
---
 include/linux/console.h | 4 ++--
 kernel/printk/printk.c  | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index fc9f5c5c1b04..f882833bedf0 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -492,8 +492,8 @@ static inline bool console_srcu_read_lock_is_held(void)
 extern int console_srcu_read_lock(void);
 extern void console_srcu_read_unlock(int cookie);
 
-extern void console_list_lock(void) __acquires(console_mutex);
-extern void console_list_unlock(void) __releases(console_mutex);
+extern void console_list_lock(void);
+extern void console_list_unlock(void);
 
 extern struct hlist_head console_list;
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1d765ad242b8..37d16ef27f13 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -245,6 +245,7 @@ int devkmsg_sysctl_set_loglvl(const struct ctl_table *table, int write,
  * For console list or console->flags updates
  */
 void console_list_lock(void)
+	__acquires(&console_mutex)
 {
 	/*
 	 * In unregister_console() and console_force_preferred_locked(),
@@ -269,6 +270,7 @@ EXPORT_SYMBOL(console_list_lock);
  * Counterpart to console_list_lock()
  */
 void console_list_unlock(void)
+	__releases(&console_mutex)
 {
 	mutex_unlock(&console_mutex);
 }
-- 
2.52.0.322.g1dd061c0dc-goog


