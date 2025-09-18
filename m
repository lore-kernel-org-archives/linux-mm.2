Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC719CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4DC8E0134; Thu, 18 Sep 2025 10:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494FC8E0112; Thu, 18 Sep 2025 10:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2498E0134; Thu, 18 Sep 2025 10:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B49A8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFE5E57156
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:35 +0000 (UTC)
X-FDA: 83902546350.01.4DB5E76
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 204D32000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0uQo91zS;
	spf=pass (imf13.hostedemail.com: domain of 36BHMaAUKCIkry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=36BHMaAUKCIkry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8w2QAEoYIuf5bb1DymlH6d9mwXwlVHoZjcMp7ct6B4=;
	b=Ynttoigw3Q4dR58jIcNZKqejwJlMGqKUufOcc29hViWdi8Meg4I+AOLwmXk7nPdRq7Fnhb
	ZnFEqq3eiYJi5DLXjyPt/6WXNNUbpb2BFE5x48h5euB5Atied8AMUwItKURTxg0E9sUp4T
	QHsH1Zdx+OSfmcUduneRSbwiRkUa4E0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0uQo91zS;
	spf=pass (imf13.hostedemail.com: domain of 36BHMaAUKCIkry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=36BHMaAUKCIkry8r4t11tyr.p1zyv07A-zzx8npx.14t@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204394; a=rsa-sha256;
	cv=none;
	b=z3xtwcp4kX8GHDykYne8YXBHP6l6D1FanU5lf8bfVGnu0TWn5DxeICqg2mZpwVrEF7n2j0
	lWYug/F2h/9fdI3YpjvPiJz5sS0hOW+iElFAab0yTWSTHDOWw8VFOWTphRj5CBfBECUONS
	ZRJFfaRcaTgdNUTKOxkCtGHd8tQzzvo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45ddbdb92dfso4707425e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204393; x=1758809193; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i8w2QAEoYIuf5bb1DymlH6d9mwXwlVHoZjcMp7ct6B4=;
        b=0uQo91zSehAbgxg9fCvTyTvTXnwoAHS2UGb0esQFyC0/0/IGIcZ8e1hSiMmw+b4Tje
         BnecJp8uCFq6iDI/uPlo7LC8jxgnOUF8aMNCf5Kt6I8COkKc5I/t6kDqWjiz+VxRw3Fl
         m0kKZZ3HD9lN7u4nABnWs0OClLMInTEDoROAsIKuAKPFzVy6XhA+GS9gOZmu4rFnAGZY
         Ze9VSxAwQSuKfFfUCFf00wvV/olGs1IgEoGeQfSYW8h+RrNN0saAsX1p2TXsMUpYQhmX
         NTxe5JbiKjZmcf7fOL9obgFKPxZD0OS9VDkdNmkV7UEdY8v36WuHk2b5KwxQ8JZCdWpP
         rBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204393; x=1758809193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i8w2QAEoYIuf5bb1DymlH6d9mwXwlVHoZjcMp7ct6B4=;
        b=Pz/MaZS7UEayS4Xg4AUnJ2v4US3ZimpJqBQOdu3Fg53GFx/NKQSte7wdC4gAupUpcY
         x+jrvx/Yo4CfDNv+i1eqruokhm7AxaQnFKzUDtOA/+OKDpIvdSs679f8hfzZoW/SCOuw
         PEblmC8NqDpJI4CojwdW/NPebuQWgjoOMgHVEILmx0XSlqEX/zUwuh+8mvdTzsw8FH+1
         ARKXol5rum16q0pH5ir+CjEg5lcUyUsG1ndbak4ml5mGlEBJf8d6+v/riJd47AykgSep
         dUz6brLv3tEKHQly2fUVOY0WuTtKpC1jrtqpFmCbBM6QU0CYrwsdRBm1ZBhEkldtSwBY
         HZhg==
X-Forwarded-Encrypted: i=1; AJvYcCWQDbdAjayyAfjKBYtwyKBxamx3kle/9fyXfMvq/vaYHvga/quWgUODPzkGGo+dUbjd0A8/9uhDWg==@kvack.org
X-Gm-Message-State: AOJu0YzWc8gNHuXgJCh1ID2pKnMpISSZEB7kj4huCInYvuIMbWcHGq2A
	v46AQQrJeMV+NZUVRL2YDTzOkZSYDzITnmtYlTxaf4GwYZ1uUlMGN/tXrddxZY3Bc9fr/mI690/
	aTw==
X-Google-Smtp-Source: AGHT+IHWNzp66JVSJfWTxCRHilc0nDbHIqmddDpVoeLyiEVjC/MpaqVSH0JrUfOsI8FVYQkmBD96f8iDCw==
X-Received: from wrbfr7.prod.google.com ([2002:a05:6000:2a87:b0:3e7:6467:c475])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2506:b0:3da:27c2:f51d
 with SMTP id ffacd0b85a97d-3ecdfa5f1bamr5332225f8f.45.1758204392094; Thu, 18
 Sep 2025 07:06:32 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:35 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-25-elver@google.com>
Subject: [PATCH v3 24/35] compiler-capability-analysis: Introduce header suppressions
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
X-Rspamd-Queue-Id: 204D32000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: s3xkpezmikft7udyisoyeb7x7r4onspi
X-HE-Tag: 1758204393-127663
X-HE-Meta: U2FsdGVkX1+Qv59xmM+VWbfBaIjY93g7nDy+2XImxz1/qST5czGWyLCfG87TMdWzznOTmdPgjcpaQcimWM4YGOBPoGk6rbtr/A2JT37HUBPyKEmY+hKpS1EzipOavovNkz6Y3d4lFPtOFOnK8Rdi1L6QSlv7b10BlkebTWS9TiMp8W9n999jqPzZQF71dq5s55MdBQ+OCHO2PIKo4j1nkZh3l3d/YStHaux5wqxRLGNIRmDpPNcktoRshVqxrrodbTNpcrGtOnJFQA0xEueXenOXgdJkJBKb/sXxUffy7aHQNh6JYZQOjc0lwZxKalMGcy9WF7FkNtwgVmfpn9GYJji3Z/BoPfSDrII3XVGQkRfhUdv5YMl6D8Kauy8UBlHsJyLGiVb+p9lNad+2AzguXEEqwUlHe75LUCw/uYTU9kD/poz7RKN3aDrCCIOx7agDR11iLPCbHNYrywN6bMcsDD1SoSF7TcyiYIcSPpu1byBwqCoqcLn+NaD9lON9vF8LQshTna6jWGAJfjq1g9RNo/l/zIuMq7ZBM3VAK+fizuu7SyHvFQ0nXxYFZMVM7IyZkdNSlhouG0ZDmcSlTwF3E+GFdL26JyStBYHXZLlUv7GS7jbNXS6nya0I1b9CsCFHn0pGsaOcRDyq3cIAIFjFnEKZ0Z8JFLcsj2smaHZPx/jKsN0g9T28tvptCeD7kvMpYIdxCHLLifpctMx6sf+dBTY/P5gXtDzGU+3GdMIQ8R/u6Xjui4ei33qZnO0WRX3voyG/rJ1gJ/NdEWf4h0W7VWWiIhXXYqb4R8DxWC1JbqM/oNsqWiaXh/X069wYxYnO2MgJwtesUec03UwjAu20zdX6725nyq5IeWKXohhGSVMRQqAvJhjcn4kwku/1qeloL8b2ivsqBau9sAaZt0zgZ6/Z+kAyGnXUfCVuux36gG/UaWMPsZKMwkLEHb59njqBoBYSYvSBUtMP68x1kba
 k74GCC5f
 oWXcDcViNvsylf+A9APS5rgKW7fVQ74erDWsmvxkPHd2QzpzylzMkoigLAiYNnW/W1DnJTGV0yg2hG9KAQV5QiyACNQwgvVRtUJ+ieccewEnKZ6/jBiEBAhu8gLwk6LHGExaLNZ9Hkfv0DGI3HDOTEahD5FfVJ0sbtckE2KQpEVEpNphJQYcS+XQfMR9EziwM7LLv82bfD8SLTz/X7O7QSM9ip+1NFLEvx2TmZjkwOo1hV9uiEpp8+qyWpnIFj1Fc9cGCI8qcscer9tFDuJiajWq2v2dHZ3wXBwUrY0DBl8v3Gjn5avRM4hJT7sNpbhL2j9w2VGsgG/hsQHepxU8MkDLeNUNJr1ne6+PTMPWXnD65oBlYZyFySYjXuP/YoPYbL+pRbZvuQo/ptuJVPkrb8bGvnDT+YeD+BiIiwOaH5l1mAWnAO2JrP7lwz61bJV9MBOVD19FySGct3Qy9kUiuMDYqeZvpl7vOlA59PLeETGKotko9velNDYreSDdwPMrfUQ62CLlkEGgv5qvkgjIaKULjiMQxvLTevDfel3Ow+TGvsqT9gjqBHzA9Mz6KaNCjRmbA0E9IUcYj+Odmg3LbQ4s5bvNoNsxvutt002hupQpJ2KYr5EnryHviRv5UtEQxhuEiYiMTf6+/odM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While we can opt in individual subsystems which add the required
annotations, such subsystems inevitably include headers from other
subsystems which may not yet have the right annotations, which then
result in false positive warnings.

Making compatible by adding annotations across all common headers
currently requires an excessive number of __no_capability_analysis
annotations, or carefully analyzing non-trivial cases to add the correct
annotations. While this is desirable long-term, providing an incremental
path causes less churn and headaches for maintainers not yet interested
in dealing with such warnings.

Rather than clutter headers unnecessary and mandate all subsystem
maintainers to keep their headers working with capability analysis,
suppress all -Wthread-safety warnings in headers. Explicitly opt in
headers with capability-enabled primitives.

With this in place, we can start enabling the analysis on more complex
subsystems in subsequent changes.

Signed-off-by: Marco Elver <elver@google.com>
---
 scripts/Makefile.capability-analysis        |  4 +++
 scripts/capability-analysis-suppression.txt | 32 +++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 scripts/capability-analysis-suppression.txt

diff --git a/scripts/Makefile.capability-analysis b/scripts/Makefile.capability-analysis
index e137751a4c9a..76ef93ce2466 100644
--- a/scripts/Makefile.capability-analysis
+++ b/scripts/Makefile.capability-analysis
@@ -4,4 +4,8 @@ capability-analysis-cflags := -DWARN_CAPABILITY_ANALYSIS	\
 	-fexperimental-late-parse-attributes -Wthread-safety	\
 	-Wthread-safety-pointer -Wthread-safety-beta
 
+ifndef CONFIG_WARN_CAPABILITY_ANALYSIS_ALL
+capability-analysis-cflags += --warning-suppression-mappings=$(srctree)/scripts/capability-analysis-suppression.txt
+endif
+
 export CFLAGS_CAPABILITY_ANALYSIS := $(capability-analysis-cflags)
diff --git a/scripts/capability-analysis-suppression.txt b/scripts/capability-analysis-suppression.txt
new file mode 100644
index 000000000000..95fb0b65a8e6
--- /dev/null
+++ b/scripts/capability-analysis-suppression.txt
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# The suppressions file should only match common paths such as header files.
+# For individual subsytems use Makefile directive CAPABILITY_ANALYSIS := [yn].
+#
+# The suppressions are ignored when CONFIG_WARN_CAPABILITY_ANALYSIS_ALL is
+# selected.
+
+[thread-safety]
+src:*arch/*/include/*
+src:*include/acpi/*
+src:*include/asm-generic/*
+src:*include/linux/*
+src:*include/net/*
+
+# Opt-in headers:
+src:*include/linux/bit_spinlock.h=emit
+src:*include/linux/cleanup.h=emit
+src:*include/linux/kref.h=emit
+src:*include/linux/list*.h=emit
+src:*include/linux/local_lock*.h=emit
+src:*include/linux/lockdep.h=emit
+src:*include/linux/mutex*.h=emit
+src:*include/linux/rcupdate.h=emit
+src:*include/linux/refcount.h=emit
+src:*include/linux/rhashtable.h=emit
+src:*include/linux/rwlock*.h=emit
+src:*include/linux/rwsem.h=emit
+src:*include/linux/seqlock*.h=emit
+src:*include/linux/spinlock*.h=emit
+src:*include/linux/srcu*.h=emit
+src:*include/linux/ww_mutex.h=emit
-- 
2.51.0.384.g4c02a37b29-goog


