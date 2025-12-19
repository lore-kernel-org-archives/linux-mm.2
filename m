Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E3ED7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459C56B00BB; Fri, 19 Dec 2025 10:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413BF6B00BD; Fri, 19 Dec 2025 10:46:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBF16B00BE; Fri, 19 Dec 2025 10:46:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BECD6B00BB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC479B7E73
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:55 +0000 (UTC)
X-FDA: 84236648790.17.9DFEA34
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 073E540007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nz1D/VIv";
	spf=pass (imf17.hostedemail.com: domain of 3bHNFaQUKCLkdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3bHNFaQUKCLkdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPiD3KqRf4YAgh6EJvt9JR+cuwWr4Dg7H+dSvPnSAFc=;
	b=hjhsQXeJYVp19R1sLXMac/sFB83ZxFFHlU05ONyJTYv4UA3cuhWECFpiGqV8DSbpsw3O+H
	tL2eW50yJVzTjmW0tCnPpd4ae1u8eOyFtixh0OKWqH1gj1oZe1uHQyMX6okeRvd69eO57i
	JA0uCVXQ7AsTAYznqwllCWHh3ixI0hQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="nz1D/VIv";
	spf=pass (imf17.hostedemail.com: domain of 3bHNFaQUKCLkdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3bHNFaQUKCLkdkudqfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159214; a=rsa-sha256;
	cv=none;
	b=mXtNPXZGW2VKhOzP93Bp1Jt7fO8aTMNPQ4WAagXTqMCvmbuWWfMlG3nvTmOxAXczPuCriq
	WWgUMoH+bHLDtvqkumYMttqDHa1wrW9mlnsUN70vja579ZMZ+QeA4rygPiQVSoDlK4Xrkn
	mIoBxoJ3sLXeJVflich+xbR35xQZslY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477563e531cso12949165e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159212; x=1766764012; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BPiD3KqRf4YAgh6EJvt9JR+cuwWr4Dg7H+dSvPnSAFc=;
        b=nz1D/VIvcjaYD7klpK97P90H/DVHqEsECGQi20++igkMXeHle1ieVkpxecGPQ+Ch1+
         qLKyb2nBdyKyH4uFM2xnxHiOwafDOo0tFv9Cio5maTYwf5Ah+7ymNqZ4WoMEYfhPeKi7
         nyB+RCJ3HyYRp2988/jJJW7D/2G1VLrU7eu/iE4MdjdcGBeZKSbQmxlsjVC5PwP9+N1t
         6/VE5XgZML6OkU41ZTcxlj31z4NCFpcxat/doz4eL6R7NuCAr6Le1N3zFvHVnFvI8/pt
         5Q1wMUCF4ddDweI7S0z31ViZD74DqdZ9a5cbpqIZH8Njo69QUO4NLZvUu71FjArpjZwR
         FdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159212; x=1766764012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BPiD3KqRf4YAgh6EJvt9JR+cuwWr4Dg7H+dSvPnSAFc=;
        b=rcpsTmwIRPcTcUE/d5eledCjJTelQIk21ey0ABZzYa8Une+SZnT7RMzpdcaw1+EUVZ
         Cq6Dg4IMGr6ZjHXZmmaZl2smS2QcV3hm94EFt/gaVm8m2vukfFHPzKlbbKHblpFBUIbc
         pMJhVuJS26aAqkrzw1Gz1TaFmfrRL2sagCrcCWFuvo/h7R1FutfAe5tdJfxV5ddzn9AC
         hmqFXfAxJUEdXEUb0e2uOKKaQklC24SxETqk5Ra5sLT0z25fcpUD1ZtOvv2f0i5H2fwu
         NTNZr3jknc7kDszbl3bV0BGLZfKjrS/8YtBCfyDyvf0U9P6AGKVu7WFEiFfpYmfkkqM9
         uSNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtSGvCQ2LiovUuFV7eSMhaM2g233rprpePLUukmT7Kejzzp4kUZ/EDnjU7YDbv6nQFnT2QT/dTVw==@kvack.org
X-Gm-Message-State: AOJu0YwmnYx5x4SA7Mj+4KmAgz96slIe7dGjVxSL4BcYIYEpwFONeurh
	ZUrlPEtPfas5SQcA4zEsJCtZSgKgbqQF5nqa1NAmuel9wylumnZrGdnvidl46g7hKPCGI2Vdu5v
	HXg==
X-Google-Smtp-Source: AGHT+IGhAhPmou604sSjPj23AvOGmEtACeK8/O1HXfeBpY2WmsP8AIbWuFkf2cEj+zrFEmw2cUXjp49BYQ==
X-Received: from wmco23.prod.google.com ([2002:a05:600c:a317:b0:477:93dd:bbb1])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:108:20b0:477:214f:bd95
 with SMTP id 5b1f17b1804b1-47d1c036d6cmr18724405e9.23.1766159212483; Fri, 19
 Dec 2025 07:46:52 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:11 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-23-elver@google.com>
Subject: [PATCH v5 22/36] um: Fix incorrect __acquires/__releases annotations
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
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org, 
	kernel test robot <lkp@intel.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Tiwei Bie <tiwei.btw@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: hmub5ueyzd8jf5o44uf7ztxds1yue5cn
X-Rspam-User: 
X-Rspamd-Queue-Id: 073E540007
X-HE-Tag: 1766159213-590955
X-HE-Meta: U2FsdGVkX19wgC8UrLka1dKJRmbVTzuWQ59q4P39TvF3cjLR5oyENtroykzdBv2o9KAfD6wOFrkeQSl2ctq8b3kh1Yv+Hhj4yrkAFSU4xYoiqG9VzPEUieVPTKixtF5Gp8MzbySVB6aKY33drAcmVgrTn7WSFFsgGpmhdQwW8iJKagQAJeY2zE2YNRL41Vwxx3vicw4pZ72HY4ogxK3tQPhcmqDbHfP4+LQudYpvJAtww7zjxul194TcPQjPFtpqwptwYVFzNQD2IG7XS9gOoKq/SZD2JEdMhFNhIngzzukXz1EGejVsOfITQCF62j2GKpqwFC2XxoPUJHiVr6TCE77zKhRgGGTLeLqeRFK9vDxwY3wkYz/fLgb9PYB15T+xxBnIhsMti/zHtWgqHl16AQiZ4JUgK+oHXuQSH5pRXa1enVR6gJZSPpvLVIXLbJ+Jx55w9HZFnF0+1I2UGvMOJrvLUBGsf+qaJ5iVPTB+gArRq61uy3BcwQR6U6jt+6CmT5zgHZDnr55JMqc4rwqMP3aFB5KIybY95faAzrJdL8P3iCgVcviJT+fFdBAEL4v/4CnVZEEL1DV/Z3P7zx3344RdJaCH14QJSy2ReqNBYgb8+7O9I8M1qEayyTDQkOEkSflIK/X+Cj3A3XcSX+2PHC0JacmLQIqvuExZe3WrIVuaQOFMTzI72bRbd/dKXmVmbHpzJND0F+hj/sd6TNiNMSYu6/TR1dEOLQQGOIuW5IPEVMBxi8uGp8kpDlvHTH0PLS5UOOiRhD4HV49P8xmstcD3Mw4ohaP3tLwo6aBXIe3kF/G1s2Ph/F5K04AMnSWa0yRe+jvSq5/UnODyVbl7zpfsvACsblbp1jK46PUHux62preAMBa22WVFMh0yiMjHMh4XsrM80YFyfkSs9EsK4sng2a0k79AkzHe3aEHJxwE8YTSF+0Q3viqRnWx30FNZTlhCzqO8EDcQvDYSDPk
 SIkQEk7V
 ABVpPPQdUymcPWhgIQvGv8/IlHkb6bePUOsFPuCZCOJgpKhwWzjyr3QH9faMHcA1dogJypIsqInnwzZb6FqaHzMJe8aMlvLFCBseyAEnbsBpNa/zYzbkXjHhw9SEh01tbMSV8LNxKjuQXpznkFcuS/ZdAPAsSMNUqGIsC4dtHuwiqy7ubDaxUfwT0Xq4lHtLvkgzOVVeX1WkEOs88TOi2nfvBFoeWNBmdmaJ/iUDtpsRl9X0t97LtVlcp6MnG0LK+NfuWnzACabS3KVbDa3oOAhPtLqe00sgytacBfNvH5zTLn/qoOq6j8xo/JaW9meohRNMzvTqpPQvsu0tTVly2642YRrVzkKp33C3EsyobuN6LK5gLGj0lkphiItGOjz16w7AZigFglNoRmea6YFRpLd68ejY/YNWCbB6gyhCeOkhRp4eTeDndbsl12JvWpSFVsoQaJoobmeGzN5uO4Y4Zrtuo8vr3G4vHpT8ExRqLbYdgk4iRDjhAZik/JGKrPY+9mGoghQJKg22WZ9LvO8ueV3KHEEoIm9nDHgQYK113uHo+mA9Xh/w7HH4pnNsvxjLzqZsM5c/T/6K1dYxRs/mHuw0HYRjyuCIQm9XelHNqemv2UuKQFlzN3ajO14ER8B8ehpwcr1k8Q0GOrUoI21vHP5sryE3vzu6CJLw+sZDFv7j8ipVWTg14Q41D7emUCzKrOCkSCFzZchuER1IViD5bwZ3qT8zTlzWjR1Hz9TNA/8itCmsRZyPCspTxUUNx3kghCcPReylulUwU+A64XczwXKYlAe0FSUqh3dZyb7ogNBmawNQiCRHqCDSYF1Qp6OdxAVKj1a6Geb9BayFVyoy3UebcPRbzAUmwgLeP2pEMJf3UY1Wyh474So4GPJNMhh3doRUKDI+Rb7YxJNgt9e6iRlRJeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With Clang's context analysis, the compiler is a bit more strict about
what goes into the __acquires/__releases annotations and can't refer to
non-existent variables.

On an UM build, mm_id.h is transitively included into mm_types.h, and we
can observe the following error (if context analysis is enabled in e.g.
stackdepot.c):

   In file included from lib/stackdepot.c:17:
   In file included from include/linux/debugfs.h:15:
   In file included from include/linux/fs.h:5:
   In file included from include/linux/fs/super.h:5:
   In file included from include/linux/fs/super_types.h:7:
   In file included from include/linux/list_lru.h:14:
   In file included from include/linux/xarray.h:16:
   In file included from include/linux/gfp.h:7:
   In file included from include/linux/mmzone.h:22:
   In file included from include/linux/mm_types.h:26:
   In file included from arch/um/include/asm/mmu.h:12:
>> arch/um/include/shared/skas/mm_id.h:24:54: error: use of undeclared identifier 'turnstile'
      24 | void enter_turnstile(struct mm_id *mm_id) __acquires(turnstile);
         |                                                      ^~~~~~~~~
   arch/um/include/shared/skas/mm_id.h:25:53: error: use of undeclared identifier 'turnstile'
      25 | void exit_turnstile(struct mm_id *mm_id) __releases(turnstile);
         |                                                     ^~~~~~~~~

One (discarded) option was to use token_context_lock(turnstile) to just
define a token with the already used name, but that would not allow the
compiler to distinguish between different mm_id-dependent instances.

Another constraint is that struct mm_id is only declared and incomplete
in the header, so even if we tried to construct an expression to get to
the mutex instance, this would fail (including more headers transitively
everywhere should also be avoided).

Instead, just declare an mm_id-dependent helper to return the mutex, and
use the mm_id-dependent call expression in the __acquires/__releases
attributes; the compiler will consider the identity of the mutex to be
the call expression. Then using __get_turnstile() in the lock/unlock
wrappers (with context analysis enabled for mmu.c) the compiler will be
able to verify the implementation of the wrappers as-is.

We leave context analysis disabled in arch/um/kernel/skas/ for now. This
change is a preparatory change to allow enabling context analysis in
subsystems that include any of the above headers.

No functional change intended.

Closes: https://lore.kernel.org/oe-kbuild-all/202512171220.vHlvhpCr-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Marco Elver <elver@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Tiwei Bie <tiwei.btw@antgroup.com>
---
 arch/um/include/shared/skas/mm_id.h |  5 +++--
 arch/um/kernel/skas/mmu.c           | 13 ++++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/um/include/shared/skas/mm_id.h b/arch/um/include/shared/skas/mm_id.h
index fb96c0bd8222..18c0621430d2 100644
--- a/arch/um/include/shared/skas/mm_id.h
+++ b/arch/um/include/shared/skas/mm_id.h
@@ -21,8 +21,9 @@ struct mm_id {
 	int syscall_fd_map[STUB_MAX_FDS];
 };
 
-void enter_turnstile(struct mm_id *mm_id) __acquires(turnstile);
-void exit_turnstile(struct mm_id *mm_id) __releases(turnstile);
+struct mutex *__get_turnstile(struct mm_id *mm_id);
+void enter_turnstile(struct mm_id *mm_id) __acquires(__get_turnstile(mm_id));
+void exit_turnstile(struct mm_id *mm_id) __releases(__get_turnstile(mm_id));
 
 void notify_mm_kill(int pid);
 
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index 00957788591b..b5017096028b 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -23,18 +23,21 @@ static_assert(sizeof(struct stub_data) == STUB_DATA_PAGES * UM_KERN_PAGE_SIZE);
 static spinlock_t mm_list_lock;
 static struct list_head mm_list;
 
-void enter_turnstile(struct mm_id *mm_id) __acquires(turnstile)
+struct mutex *__get_turnstile(struct mm_id *mm_id)
 {
 	struct mm_context *ctx = container_of(mm_id, struct mm_context, id);
 
-	mutex_lock(&ctx->turnstile);
+	return &ctx->turnstile;
 }
 
-void exit_turnstile(struct mm_id *mm_id) __releases(turnstile)
+void enter_turnstile(struct mm_id *mm_id)
 {
-	struct mm_context *ctx = container_of(mm_id, struct mm_context, id);
+	mutex_lock(__get_turnstile(mm_id));
+}
 
-	mutex_unlock(&ctx->turnstile);
+void exit_turnstile(struct mm_id *mm_id)
+{
+	mutex_unlock(__get_turnstile(mm_id));
 }
 
 int init_new_context(struct task_struct *task, struct mm_struct *mm)
-- 
2.52.0.322.g1dd061c0dc-goog


