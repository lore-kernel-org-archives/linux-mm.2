Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37F5CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBCF6B00D7; Thu, 20 Nov 2025 10:13:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C5C6B00D9; Thu, 20 Nov 2025 10:13:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0347C6B00DA; Thu, 20 Nov 2025 10:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5A816B00D7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA2DD1DF1C4
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:58 +0000 (UTC)
X-FDA: 84131330556.18.6D2E0BD
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7115140014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TfiZnKX1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3MzAfaQUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3MzAfaQUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651637; a=rsa-sha256;
	cv=none;
	b=JnI1UBfNmM9Z55nAOkhNVOWKsACxiUI8yE7gTk7Zjvygryc9qxfHv+HEDNUztaE0aIEPr+
	lkYVybJarEyLND7+lQ5CwESQ4Idmt0V5ZdJbm7rl30GdkRN44LiSbIgcgdeuH/wqPW93QP
	fRh9SdqtA7r4hfCr1kBnthY2hPu7XgI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TfiZnKX1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3MzAfaQUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3MzAfaQUKCGACJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Im5hsj1DltxV90KwIidFCTn0DS8FZncDFP7kTqaMpC0=;
	b=pxv3r6e1Nf+ADclMVl+eWLrXEhtRDPz6yxgdXg+6InyLgysnNynhqsBZfu1intXja7/aDQ
	UnKwB7BrJUyd2ph7hoMnHVELqB0dgp09OG94ID08w/LL67iFiZWbaYSxATz5cPU3M8SZnN
	JJh1x80Wulz33JUtPy6EziUR2CN8uPA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47496b3c1dcso10733505e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651635; x=1764256435; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Im5hsj1DltxV90KwIidFCTn0DS8FZncDFP7kTqaMpC0=;
        b=TfiZnKX1FGfzPjsE41wowGRyvbiefOSA7NSspvkl+S2Wk6TCMUjqJ9PoR61wDJup7W
         Hqy6FIpdw1JSfkxhb+XTRbxFWg9C6IzlkX1NVy9HF1haGxU+cps87cdKXy971QNwmQht
         hBwaePn3jdYctVN+l5S+B4HJ9U4+WVkQKK4FJ1KeAy/8YM6GOC7wjH1JhiBdzPWdOrV7
         SNL51a+99++9ny38k/rn1OKb8SkAcSwcukTgHUmFUZAEhmVzWk1qoxoyokGFt7VsM28k
         1gVH4WR4PqMVNaoE4hNGUBr88tAujyeIIBa4cxcOGyt6rth8dgGFEny7l55sCxpSLeWt
         TMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651635; x=1764256435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Im5hsj1DltxV90KwIidFCTn0DS8FZncDFP7kTqaMpC0=;
        b=JLPzCd/2DxMP9RSgZO5eYl7/tAFIZscqv0w2YceGAQYRHtZ9ck8tyqydc9GLBhhU8N
         fQOJHjmUofcwaeE4m5ZI3ThhD6ynHrmMoYJE+w+o50hmgPu9srxZJVHDygvHAH2DHFdE
         vCmW4r6cP5xyjyAMlW5iYsy16S4T1AzYjutvxTZEQ3X4vDhDjL/ZdPnnmYZxF+hhtvhm
         jL7OEXupOYbyeKV9FN80mk67FhIViORb1imfk+xnCYCvN9LfpBeziA//MPG6m5Qp4dFk
         9EhnUH87FAYu3cVwAwVS8U2UTCfX9G9E/j6/F+nqECcdi3J+gztSVnCC8u66MnpzDGTI
         XSMA==
X-Forwarded-Encrypted: i=1; AJvYcCUnOXNGxQgFIVs/FmcSJJjsLm+du1ka+wAS/+1ghlAII7KgV9/HhkYAj0sUN4/V7SFfb18ZqpIotg==@kvack.org
X-Gm-Message-State: AOJu0YyVN50YgyX4Blf4TeMGVJiUlENngIPFacRUVRn2Otr6jBIlDAKg
	+JD7FPaM6Ewb9SWdnt+h/yg24LhYEvTWlb1ixdmpVrGWcbLXNgR4Wj7ESzi4qms1HW7hhPMn1jS
	4Fg==
X-Google-Smtp-Source: AGHT+IE0txFyfqWr7t8p06ZvcBdzNhQeJVfQ06tB7yPqhvYYx4yW0lw4v6t9Cn2mD+Uk9FOLbPP2gAnnVA==
X-Received: from wmd10.prod.google.com ([2002:a05:600c:604a:b0:477:9c68:bd6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c1b:b0:471:c72:c7f8
 with SMTP id 5b1f17b1804b1-477b9e1cbfbmr31262875e9.21.1763651635197; Thu, 20
 Nov 2025 07:13:55 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:57 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-33-elver@google.com>
Subject: [PATCH v4 32/35] printk: Move locking annotation to printk.c
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7115140014
X-Stat-Signature: zzmfozza8tde8pnqim3j5me1xsqz8obs
X-HE-Tag: 1763651636-869804
X-HE-Meta: U2FsdGVkX183c9zU7KjEKwFQbk8SBS/AJtXlsLLvy/rIDZnjuMh71c8I/ezr7eU1eM0CDZ3mTqWom4PR2PTP+DDuln6a3GLsQHN5uGdygyZd3YSUR7vvdOaTCDIyY8dbnIySZEMIJTI1moCEr5ITQq9rfPzCJfLa/gF4aJ5SAPdBYQH7ebXiNz1oXO6nEdwKdvNX608WHvaPNI/tHS71YeDjjBHnHP55wjDiit7+iTjRlcc58WPMCeHq7/0+V/y6b0yn440vez9xH3T+izDLMrh/t6J1XTNWovKwZKxpxBFWa/tkX40t8IPRpvU3zmiKZ6eDvkprJwVKMXfGohBWDZDCXOs9R+rNYflrw67lYiwNHGDlOZRL6srkFyBoTOD9/BiQqpLaK/tU/5dbjHY4Y2HGlXTtf0dem/E+0pKL5rSU51snyX0634HAMk5eoNwquQElKIehJPGtYrIa4bz0kVDn+GGSjgmWhss3scK7vpI0e5gp2HiCA+sec8K91hMlvVUPB/sYBmk++NygmCATN7muOi2RW4YLSADfhtp1k6qqtrRfVawnIYcu8FD5ShH4tueVCfpY6oGulgRhIRnHN7yq5T0d6Bw6PcTwU43MAznaTGXyGD1+aQwCuz1Sg440CJgeum4rjZ0Y0sWQL8MKTUc6cUaZLnl3BLGUKGsaXctx8rbs2gSTHZt7mVr2gBjHc+SI/g/DDmCvlPPedbxAT530QRlQ0gnUSAa1EeZNEAsb8sIKqjfs57scKnGUhmETaVDP8cfEDdDV+LpiqhcN05io2h6CRF+DG9m8B3kaWCDObJIz1JOw5WcObNAJiwcwVFTff05TD/9JYEmN3nOnd9O78aY2ECzU2sWdG4JVPdB0F3USDOhSLYOdxphCIQbmiFz6HzqfHKa5gcMxmBCHosbpgu6Sz0FRQbW3t+DXyq8nvL37p9YA4NJbRhyFJa6hRE1chNhzOqm/JcmI+Hp
 O0DaXv8R
 QP/cLJbo4m5roIoTIG/o6h+1qLJCnAxV4TYbVJteiUHquSyPow1KGd0apA0hkQAmtU4jsPlQGTg0YsgZIMdowbeOj5I7FX7uU403blbDdoWqQs9hho+os8sXzDEL4U0Ksix1QDuYtFnQ4R9Wt1NgyTgvWwK8isslWDe740pPzKb+p4Of48zTEK6Jk8YzUutU6w9qIR2eVR6cwcLLAVlFDL2DoKxpiXbgTJHcGa4OeeL1PWK1xrmsIgC2iyzsYTaZw3ppPvsA0t+Z+63eQJeLoXioOcKHPGt939YYzGou7fRE8XuK1v9nfpypyQLyg33am0bREZ6YQMavc9wEig5IEqTuwv0qPxOFe0amvmx/EnjdGvRJJn08uBH7iiLvIr9btCIkRMCJJQQyHw3QAHuUFI+epR484Dzs8hUXu8+YmM2pbNPb4DMHetk1GAlw9C0EvLx3dQYEmCm9xE8xbIN8jJBqoJjgMRg2g9y0XYMTBOOg0EboKQQwthcNX6c+ImBcbtnr2uMAlGCneUjuAk4OBFaa02gNwsGrVRSLCNhSOeDcqTyJbBWrlLfRjmT3dvjB8abbtGKoZM0EL22T/i6Iqc0wsFUrCCgHXwKPv5sPku9nkMW5PKJ8xCNazw5v9Eo7SRKw6FeUC6tHOZkYikmwcssrgdeShfX+U14k0
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
index 031a58dc2b91..1eb3c9d9d6ae 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -488,8 +488,8 @@ static inline bool console_srcu_read_lock_is_held(void)
 extern int console_srcu_read_lock(void);
 extern void console_srcu_read_unlock(int cookie);
 
-extern void console_list_lock(void) __acquires(console_mutex);
-extern void console_list_unlock(void) __releases(console_mutex);
+extern void console_list_lock(void);
+extern void console_list_unlock(void);
 
 extern struct hlist_head console_list;
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5aee9ffb16b9..7646952a92f1 100644
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
2.52.0.rc1.455.g30608eb744-goog


