Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DFACF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340746B00C1; Thu, 20 Nov 2025 10:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0F76B00C3; Thu, 20 Nov 2025 10:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B92C6B00C4; Thu, 20 Nov 2025 10:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0301B6B00C1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:15 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B26E756139
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:15 +0000 (UTC)
X-FDA: 84131328750.11.2FE5718
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1927180014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NrLBzN6q;
	spf=pass (imf16.hostedemail.com: domain of 3CDAfaQUKCDUVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3CDAfaQUKCDUVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8aLbx9Sl47RYxftyEseQjhVT7SfF+KyN6wsDyYV/tA=;
	b=dK+aClP/nKMH55ImWokzIOQABmr13LneimL3DeDZgv58HIoQ8mljU35P4kbhhQaGbJgwUN
	cFtNGPIPVvSZTrWkcA4mz+xlzDYp8xcij6TyR3idvcYWWfERobJvfRkahFt6th7ML65ww0
	cBaHMfs4YgWGwFPyVeSC4XrsBCw+iDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651593; a=rsa-sha256;
	cv=none;
	b=LuKk/4byP2zE1MM3bhq4d073+ZIc6TkJcGJd1ryDUSOIE/MXsefUfIeqsx1oVEA3h1gx/I
	uiEkoDAjvRxQHAS2PzLQV0NCECMBRthDA1gkBTM49jENweut1opV+Fvh3eb4EsSgQn09wj
	1CO0mvfSsjarYbDMxOHNU1qsPwSYgyU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NrLBzN6q;
	spf=pass (imf16.hostedemail.com: domain of 3CDAfaQUKCDUVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3CDAfaQUKCDUVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477939321e6so5994855e9.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651592; x=1764256392; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8aLbx9Sl47RYxftyEseQjhVT7SfF+KyN6wsDyYV/tA=;
        b=NrLBzN6qlCK5c4UxhgstZo0WNOYDF0tw7vq2T1NIr5u7rSuVx7aq0dnvVOy5vhRS0w
         MpzyVfjjbzWCCERaN67/mvMfZ5ieJgKq51HeWFeZA5xP3xvaG21fi/vtpj3GATawbp5a
         IuvxmcgfsISpalto5QbhXxauuW51C+WC+xMKqZgNVqfJHbJWLIEZUm59mItCEkI2rgxv
         CQJy8A2wD0qh99k5VpwOZ/e/GXWjJeoeMbtr3L9WYwn7A5QiJDCF9Ce4J5aqTEVzhegR
         0DfwdU5Hkx67FFt7p2ehXqjgOEo9GrHKkQDC/jm/im0hVGrI2VR9kov3Oih2T0SUYpQ9
         OYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651592; x=1764256392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8aLbx9Sl47RYxftyEseQjhVT7SfF+KyN6wsDyYV/tA=;
        b=Ij5EO1F9OOUaGrGnuHaTWTcbIXlNXhQey88GhkG8dKE+G7rHA1nT44jeZbEvYjvKHa
         v9WM5KeQLjhR6owQ9nIKjT5W8slsuDCIXGlRgKVGubRp4idr30dkqpKchTuDF4Or2Hg+
         UkwU0TS06U3GcxQoghZ1v9fNGef+J8nM+M8SOGAEImIgQKdnjeRAnpLm2i26pDwKkYuM
         vNVV6AVCRXAqp/VZnCKVApSGEeJn10dVuoNhoOhgcB8ttXJtjWZHVs1bhSakUwM0AIM9
         /sTedmzFU6pST61V9PfCCONjt18CSnRJsmO2hM/8dFutflbNQ/yaLJd8wW5RvOvyvd8k
         Qshg==
X-Forwarded-Encrypted: i=1; AJvYcCWKnAh9WZyB6zHmJoY/Kj9GwDQGfH58LZv+fwdzpsYy8po92ut4qZDl1HSjdGgd/+HvTMzowscEwA==@kvack.org
X-Gm-Message-State: AOJu0YwxtVCSMb0pRBKlKpu2OKyQcvHr+hCUMozsaPXWYRBbGPgmCqia
	lz6ogUjiTJjYvT8FDiKkZ3fOIUlotxTdpyZ4S9wWKpWBmAu62HBpYA2jQ7MragmOfaE8ISJN6zH
	SYA==
X-Google-Smtp-Source: AGHT+IFjAbTy0j0ap6YuUuYLwX6mC93Q/ee200zfIzNbmIifUkyrBIOtI3LFwq1L7M4ens6voO/IZCXXTQ==
X-Received: from wmco22.prod.google.com ([2002:a05:600c:a316:b0:477:b15:2ccc])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1987:b0:45d:d97c:236c
 with SMTP id 5b1f17b1804b1-477b8a8a5damr33384125e9.21.1763651592065; Thu, 20
 Nov 2025 07:13:12 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:46 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-22-elver@google.com>
Subject: [PATCH v4 21/35] debugfs: Make debugfs_cancellation a context guard struct
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
X-Rspamd-Queue-Id: D1927180014
X-Stat-Signature: hqo8j747xk7yk7mq33ijt8k5emzhzug4
X-Rspam-User: 
X-HE-Tag: 1763651593-377606
X-HE-Meta: U2FsdGVkX19izP+ICKvhQM311B9toyNlfLQffHkW1Msr8JxSvriG82TwqWbJzitK0leYW0lOECZRYKLWHy1VaI/2cjj/pZrTMKBPq6yQaDXsHTxLt4T+T0cmf0aqpMr4t67RDA7ayEVcidx0/0qvFmJt1OhysMOfLxMmTMurkLZ+RBSxsB5vaGQjXetV3li8sCerdIGqxAMW0AybJRUHQgFq13vFJ2dGU3I4+HyICK4UTtG8CsNs+KH6w+E1LbY3begm65h7xleJvAVpRVFrbtkUgNgIqio9piwwH5UMWmkYSgz8yAJKIB+gnbK99LIODW1+j1eQhUUyN0oBj+66AMjUN44GqwLdeUX1EmvaECGOWHP2OT2joOpoI/AVs929+QhiQBLapkdzDtC/SpKo2FT/ls2f4ZU0UQzDkc9jC3N2XW28CoN2UeBT/QOC65+jiG34JoSwFmuBPQmdeW0pNsp5VbYzIdg8I1vTAa80jHbF/woIgyCZClU1Iwzs8xrV8ltQF43GtrjW2mAHn+y+dxeZr8lHvuI1rWH9kYshUUXqNgFvL8+sShmj8IhS/eGSU+XZwSjiZTSqpCioUN/hbAhZ/wwU6edGOgN+FiHHBJQdX5Ch2Mfeizc1lPQJUtT/hkKjH5pVnHIBqH8oW2rdXXunCZwhlKcJCsuYE9B7pfmJJRVYH5JtCJj4Dl1SRzn/M80VgAOiO7Tj83BZbMHqrLNpmEKHAyJ09aCZ+bko/93BWtNWxTggI8N2dUKHQ+yay8RPsSX2RETNfu9AdRpktWfZIxzCqREBG/RuQQF1HpyAsoxVzvG/8DG5XCKuhzwNa50W9+zUoJYjBWGRKUeKFqITXj3gnqQ1iYBuumtDAtIYBkxOiOM5cgrSIxUAcDdWcRQwgNvYyibyTi55FPqLZIn85DE3dXW3WBG8vIiQYFBhm+6l3G0DK4sXOc9a+lS2Pl+7iZGne/Yf8WrrFEE
 1pmSlZ03
 CMiaMScIMsDg4S+m0RPM3HWvYhBKcnp6KHEyB2MVJv16fwALj6yXYrpd8yuLMxyBcARb+Mv2urzGuR3Rei7h1+3Ifp+RZen7dcWowLc+iJvsZckTkvi1AGZT1hD3VYilnDkkiO47NJYOWkfXST7jtm4KPMOnF3uCa/mATkhJpzLD87tg0l0pLYJNe62NLO6uqJErIdZ8ZVYKqGD62gfCCJFPEgxpmdZ7NYnQaheHDjUREhmCSMRjj+IDVW/Mid7GotQC7pH973E85rXEUYioSfDe2givWDuPtNulq8fKQgTs1MB62hkXg53oDVHQQuN5v9KxxhVoyqwH+G+nvT40sStVJgecqYA/5dzJxvJGYVPpUs5nGvACAr9HPB7A7omMzdg5Z3hc99XBUn/xp4qqdliks0sTeaytzoAUgo9Nq2Q2OcIuSjj8dLk8nxzfkMU/bezdtZtfavJOxgd+4TYQF4qk8IEALkOOOELf7CR4ri+tguzrDylEGWxhAPlCj1UYnNzAecqHy4YAadncOaRufBIfw5zzf48W/YnU2TmSRGTa2d9xCNgfJfyY4RjzswBQ7mLFUul/CfmiZFvWogp7dLYN+hgRzGRp1QBxU1Fj8bu7E9eReuaAJsbzrohdir4k4J2R7aibfM9SFtH4tBwKZEP/fenrMeDqhV1EY6+WAY4exf30T549sSW3dpw8XhAWyIbjdB2KzHaRbIyAyI7vXNopOAVItXRCQwO1TW4uMRB2kU48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When compiling include/linux/debugfs.h with CONTEXT_ANALYSIS enabled, we
can see this error:

./include/linux/debugfs.h:239:17: error: use of undeclared identifier 'cancellation'
  239 | void __acquires(cancellation)

Move the __acquires(..) attribute after the declaration, so that the
compiler can see the cancellation function argument, as well as making
struct debugfs_cancellation a real context guard to benefit from Clang's
context analysis.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
---
 include/linux/debugfs.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 7cecda29447e..43f49bfc9e25 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -239,18 +239,16 @@ ssize_t debugfs_read_file_str(struct file *file, char __user *user_buf,
  * @cancel: callback to call
  * @cancel_data: extra data for the callback to call
  */
-struct debugfs_cancellation {
+context_guard_struct(debugfs_cancellation) {
 	struct list_head list;
 	void (*cancel)(struct dentry *, void *);
 	void *cancel_data;
 };
 
-void __acquires(cancellation)
-debugfs_enter_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
-void __releases(cancellation)
-debugfs_leave_cancellation(struct file *file,
-			   struct debugfs_cancellation *cancellation);
+void debugfs_enter_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __acquires(cancellation);
+void debugfs_leave_cancellation(struct file *file,
+				struct debugfs_cancellation *cancellation) __releases(cancellation);
 
 #else
 
-- 
2.52.0.rc1.455.g30608eb744-goog


