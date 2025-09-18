Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB14CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE828E013D; Thu, 18 Sep 2025 10:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5DB58E013A; Thu, 18 Sep 2025 10:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CDD8E013D; Thu, 18 Sep 2025 10:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A005F8E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 685661401E0
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:56 +0000 (UTC)
X-FDA: 83902547232.10.E4CB667
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 850C21C001E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=taZpsKl5;
	spf=pass (imf21.hostedemail.com: domain of 3_RHMaAUKCJ4CJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3_RHMaAUKCJ4CJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6Ln8CuHzwdFEdgMDhrRww1RTgWw9IPMarfKDLj88go=;
	b=pLVwkTxXLiZJn1U9bMB/TyAhbcyXRfDnpFCnlOg/ptARXaG5cb3g7KliZ72+H0I/v11Akz
	w3sgxnLiREud4gMFG8PY6IyVKtDn6d7cEAFbzkOE781VoCFRRDgKRa4G21yu8S5YoHW0iy
	dFosgXpMHRLZQObrPgK2nzXlsefvr1A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=taZpsKl5;
	spf=pass (imf21.hostedemail.com: domain of 3_RHMaAUKCJ4CJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3_RHMaAUKCJ4CJTCPEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204414; a=rsa-sha256;
	cv=none;
	b=bS+ZrJYYOxQ5GmATm/hZ/3+KCL3vTzntNqZog+7MSSozQzgEukGBuuW45srN3Tqs8BiLnA
	gI8nS6z7T7+mfE5/BbForkrn3KWRfMWDdmYktU3h07+PIv5dcXX9v4b5f5ungIsJJLt/iq
	rc/KROEE0vIfdKqd610kLf5ChrgDpJM=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so13311165e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204413; x=1758809213; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m6Ln8CuHzwdFEdgMDhrRww1RTgWw9IPMarfKDLj88go=;
        b=taZpsKl5WB8INKb85XNdb0BlYSNsb1zOD772P2sY7AfRElOr5rISZUvz6W8AFE5O6k
         E4nptbXgz8HUUxlvjNwROkhYM6lTijOFN0uTxYo6YKY2gE6jjDA37di/NNoB9neBtlLi
         w6Z8gAUzBVhsVbd+wKPy6r4GPBQoWAbCOdbH4y7M7lFJBIKKC7wIWZXQ1Vn9eE5lYrmE
         exhDO7UjR/pEFwy/dP4VAsazaraiFJpZhwM3uUSHpRz2bn187cHErggtHrYodgJZDjk2
         GoZaKUPwUVB7Q292zPF+oDZ46ceO0SwO6AdEkOtGLobzM83VqzMjWL5SZ7cnH/yct6Bx
         +z8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204413; x=1758809213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m6Ln8CuHzwdFEdgMDhrRww1RTgWw9IPMarfKDLj88go=;
        b=V2S/cYC4t5hFGcsHBpz9rW5zeo8GbemM6f0GyLDacO2QZvcv5bMCmydVHsbU6/nTnV
         HFABjBOlRabhfiQZO6i8V07SrsFLSafyhZ7D++H4I+8eSDsk2CNPJ892JNdKrmTEp1RQ
         NN4ZOOEDS7mDBaLzehLM3Hnfwbp+UjzrFq2m7HgUZfsb3v8V4sBCKtqEPlH+H2u5WCxB
         vgDEnGwbcWCNgjIS0ft/bpN6KSAWPrATVac+CDIYgxwMxddyfO9HGwkTfueWByWsjWa7
         D1o5sQivHT3ra9b4DbJEgTLy/Dv0XNqzhuGfsJNf2Tuu7sAMFkZKrAET+5PCtbegz496
         p7tQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8WbuAJM8IJ7aDKQ/c1XVqEZ70RIjwqbXEL4ulRMZ1W5OEx//2Y/31QNy1tS7JQXcxjmWp5xtklw==@kvack.org
X-Gm-Message-State: AOJu0YxYhQHmHUXCKRpnguXAOJ1IOeHbwgnmKXYW/SSub5ab+sVcosvm
	D4g4Z/S1Smi8MFcCDxYHGJ2C8midzOcGG1JAPFiTU0jKkgreBI9SgJYiXkfHbzivK6+7C3pL+uu
	Ukg==
X-Google-Smtp-Source: AGHT+IGP0WbxoqdPlneUX2xKJu9++ZlvQ/e8NDERumQ6O0subVDhFhk6LjXgg12JZHvhR56srQ1YmvrO2Q==
X-Received: from wmbhc26.prod.google.com ([2002:a05:600c:871a:b0:45f:2859:5428])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a7b:cbd6:0:b0:45b:47e1:ef7b
 with SMTP id 5b1f17b1804b1-46506364ce0mr25439175e9.17.1758204413172; Thu, 18
 Sep 2025 07:06:53 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:43 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-33-elver@google.com>
Subject: [PATCH v3 32/35] printk: Move locking annotation to printk.c
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
X-Rspamd-Queue-Id: 850C21C001E
X-Rspamd-Server: rspam05
X-Stat-Signature: nuuoo8s89msphcpjyfpu3oua3papo6y1
X-Rspam-User: 
X-HE-Tag: 1758204414-96485
X-HE-Meta: U2FsdGVkX18ENEe99UfW3/31kgLDFh3t7cUSQHzZIBHvPSHgKMpZRqxlIjff44o/8SFApuNyT49eHkWcBrELJHrujkBHlpjTuECCdnGCxQv8Q7LktQfdftSY634AwA0lQE1UaYIDSk7XBeC8mj0MTf6XdOUCDShsk9HaQYgovC/WAUV/IheKfKzh3K9EQ/b2ump+cMBM4hWitfl3VELB5wUxGd5vhSqcFLmZ5C6kuTe+YuUuv5PUoXET8YrgLPm4uPXruUHzXt2NbCrMKSTpbQbYnnbtkdB2XXAhjdHobQd9PJJYP9lLw2TWNlE8ZBRLjgL4w7PXxTzTrdgmKr0Uo0e+gkOevxurkc0ftTI95/QrDgobmX9OIfXYb8UjmSQvvmsqbB5IV40L73NkQ0P2cuZDXdg2Fbkk7OQp21FV9/PMKREmbsr8ftMypdb1cUYnSFwPcQS+PU7ZVv/DyNuxZdl27kVBxABbqAIAJUhRljBC5cmDgHwYcDW8huCUXC2B1U0iZuOcJWhI2NWSAIYJW52ekqMZhpp1WPcGPBki1aYK7/SPI/llAmJJtMVoWiL6d7m2SLReEeEeLwHb41e++jxCPQWhWETvJSNQ/fIkNPryGhJd+4K+2s7BrOYSP2GlHt9KRZXWZ/B1TyJZTXhEMjAINr5TsC8INYtSoUvtZ+Uw0OdX8vGxjEJtCjzRbdWLSGXQAmsMbJx5R1XgDlo575B26R/qib5nXenIimaYK8H81mYCF47NV8ltYIza5kX7O4JLBQmMaU/guBFE5iWR946/pFnyU7XIWlo9b23McTXIHEeVuBOwdeDmsrhyJNppsdYGsMUNT7Vhc4Cz/8NbR/Yk0+4BhUpk/wyUXqyxDJfVdmGn2S3V5IcVkmvLAZE0Ow/IOSQvBUGnEv1GN5o9vbWrUpcKYZ4ia0N/mR7fdISr+4EcodJpBdc3JcOS6zjOzQVHNXGBs3xsJvpS0ZP
 FsLpji5V
 RgnOrJHgVU7UXK97lDGxKAaQtpyrrPRPpUBSCmX8pe0TzFh3glprYX5/dmek7+sGCG60xnfYfzm1hdyYbuNIZAQujBFffmcYoIKuN+QRWukmgrK3Ihf+HeLA/S6p12N/SbCccxibcnw5tkuVsgTLfnMhG3FjNIYSG3mAXLj9rmldvRr18a2Y5DIefmvCWTT6eFzzDRHFNDjPHNw9a39GHJILnWC4X4ud/aPyrnzuB175pVyYtJqct3na4b3/yJmLOXccE8ZVVvFbdCH9Xd6jUKP/ee0SiBCj5TKF5RP5vVA9QSxKBQSBpyNWyNj7pRxfzV+iSBAOxBxu0xCuKHEsVRtvz90oyI4sPrL1EOjVELHDU46v7SgnwY5aIlyoZi4bi5iGrseBST8RbKhLiEte5GP4jpYO8bsiuYf5Sg5MjQEPX23rnPaoGAIpHALBifi5dwIcrCCI4Ly5cICFnxrgjbdvh45GqtjivzK2ZuFd8wNcg3FpknfEunZsgUTDY0pCC6GTv1KZBDfSfqaddPRfekt64GwK0+wny000y2LAzl5F8cqbT3jeE1+wMsn3pfdfLO29XNPigBWZF8Ibs1C3Z1oT71V8QCDnOLXE2mfz2UgDvVl+1vfjs8SxYzWdek1h62SoVkITCSkdSqYc=
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
the annotation to printk.c. Capability analysis remains disabled for
printk.c.

This is needed to enable capability analysis for modules that include
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
index 8f10d0a85bb4..6bc0a42e118c 100644
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
index 0efbcdda9aab..e0bfc66152aa 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -244,6 +244,7 @@ int devkmsg_sysctl_set_loglvl(const struct ctl_table *table, int write,
  * For console list or console->flags updates
  */
 void console_list_lock(void)
+	__acquires(&console_mutex)
 {
 	/*
 	 * In unregister_console() and console_force_preferred_locked(),
@@ -268,6 +269,7 @@ EXPORT_SYMBOL(console_list_lock);
  * Counterpart to console_list_lock()
  */
 void console_list_unlock(void)
+	__releases(&console_mutex)
 {
 	mutex_unlock(&console_mutex);
 }
-- 
2.51.0.384.g4c02a37b29-goog


