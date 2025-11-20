Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5027FCF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06166B008A; Thu, 20 Nov 2025 10:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6286B0098; Thu, 20 Nov 2025 10:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E5B6B00A6; Thu, 20 Nov 2025 10:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 811F26B008A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 397AA160184
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:03 +0000 (UTC)
X-FDA: 84131325726.09.20BDAA1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F33640009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=STceNfV0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3tC8faQUKCN8FMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tC8faQUKCN8FMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651521; a=rsa-sha256;
	cv=none;
	b=UsbF/9sQDGO+Oe95QPOlh+ZqQPeaXj0SGGjGhWb8Xtj86tKhZW2sbI9jmyyhM5WMBBNTwg
	w6kCiqBcFYX7h0gSSgTXdcLkYAdApQfctuFGiDXiWFFAFlnjsOcEGt6LqfMsXZcMpQDPi/
	eybX2b44StxExnhtYwwnT1bPPouVn4U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=STceNfV0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3tC8faQUKCN8FMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3tC8faQUKCN8FMWFSHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sW5aRQBUT1YS/p7X2M8vu94/jdaGEDQWZc189ONsN2k=;
	b=HKWRlgNUN9pVESTJM502aUVSObkYEfm08HSWsChgKJQV2oTMTBaEbqsYYSxZBQA9DMirqa
	hxcNUBF/2NwBwH2TC34aTPCnVFQLAzcR+5ajvpCdGPLNRETJSOQgRiYl9eeV2u05rFfolj
	eD8mVtgR+sGpoNxtfeG1/OTMfxj0CC0=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so4951205e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651520; x=1764256320; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sW5aRQBUT1YS/p7X2M8vu94/jdaGEDQWZc189ONsN2k=;
        b=STceNfV0toDV2MlN9Y6l5q5RFWB3rnvgUGaB4ilCNM22lcgHnJbFA1INSpiNNXZdT4
         XOHtVFhWT7IrD7yCnyhXU2J1FWxIn1v4nDJWywvzqowHfQLywaoFHkWyyu74LAqevcNy
         VwbnMlVInUoPxbDy99NSED5HdBeJx+QnBN1EKKmAvpub+4BG6t+NrWZyyckpMv1hdi2H
         0g28QNoUHFLRPcsStteG6XhCyNKvOgwGMaNCFFQr8XV+9NxUbv2fhgqy53tNjs0+k2dz
         xVm8HMw4HRwnjV4vmnrrIBqYngnNLUdEhuQ94/KbBDEykRi2HBW22Xf5UIOEcj8H4ByZ
         7dzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651520; x=1764256320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sW5aRQBUT1YS/p7X2M8vu94/jdaGEDQWZc189ONsN2k=;
        b=nRBybDHVKpGZYB5tXv1j+ycDDQDxb5Z/U2ftwhX36cZHdDNBnbHIHyqeSCe/Kqsajg
         tfP9pFsoxxvhQT86cMUOnANVsX56k938e+1O1uHee/rRLX6sR3+ahNfyr/iqHU8KksBT
         uYDQfbyJT5KExZevpBIQih1F8BVFao25gbuuXDE0Mn31M1A6vfKxdaf/F63CUgHtm0iS
         CpfqnCFb7v6TxnSAmagzOYwny6yDRW+TBIkIiqqLxoW6jAUVevRYNhfrXjKNFUBM/Frt
         gf2UIzCJVlG8gMwipDkSv+RUFOLlbSPW+wu+gUlKiFK3uf8M4AUqYTTPUa+W4+obAlG1
         6vKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJVvMpRb2jDyEExA5OECpnMWB6l+nB2gq2olzx+dd2lb6V7yy+Cwmnhmm4fT9yMHfWHwkcgEuWzg==@kvack.org
X-Gm-Message-State: AOJu0YzTcT92ldRWhU+azIe6WnqIL3Xgby7bwny2cpts4MVGXLX6AzTJ
	q59JBejMO2y1cthyj8Gp3WYgfmtYfgTDr8zfCF1u34McFzd00VJwmJXSr1gGOHfvQSlBwQRUxtP
	1QQ==
X-Google-Smtp-Source: AGHT+IER1f7gc9WQ7LnpbrPIA/y0BLZGbO4bUsdn+Ne1pOxE592x9Yu2PvTpMRh0Noc8+8JrQHGkxnvByA==
X-Received: from wrsz10.prod.google.com ([2002:a5d:4c8a:0:b0:42b:3a01:7808])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:adf:f290:0:b0:42b:3e0a:64b7
 with SMTP id ffacd0b85a97d-42cb9a560c2mr2413997f8f.53.1763651508025; Thu, 20
 Nov 2025 07:11:48 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:32 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-8-elver@google.com>
Subject: [PATCH v4 07/35] lockdep: Annotate lockdep assertions for context analysis
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F33640009
X-Stat-Signature: 3jx7qo57kpoz1gbk3ghkhe7h55rhbs9u
X-HE-Tag: 1763651521-572891
X-HE-Meta: U2FsdGVkX18CfPytwW03CUW+cGlXPLvNz+EtEB0bU4pN4MRMIgyx25tDJ/FTjioZ3r7dZiCFuIwvcH0NTEbzLd2gufsyEDKG4AD3X9xfzUmCnQwrybY0DSmzhPWs4KzvbgST49rPptDtSYAuXYPtevDuFWAH3QMQF+A+r7XyWXx+tLrUATscBUCedE9sJUtIA4i9tCSv/4GEXX+9DZe295qrwyrbjHL0KmtduKYr50mr9SOuGaqdN6Yks7Mt91fVfoppjzVE0ngXY4BDuwc9MzRZYkiS4IRP+ahbI2nKcZJtuU7CE/CA2nxMAeh4z8M22CiIjDT78wy+E9+b7gSQS/9CxCZg4DShBFXecm+8I00qW8XLd4oS+Rs7CBeaJmSOB3olHj/lZSLQc84l7fnNiJ/jTuvU/1zZLn7cFnM2zDNaPT//VT5PbFN4zX/6AxPchzYZy5r9LwKgXnsyMkg+Dtjn6w7K7Y5Lj1CwSCwMLluwkcAGHzU3xdz6bSM/BzjKrXD2ocuuj8oSSqlTEWja+u1OPUZXQDnqo/cbB3wyo2q7ns5+IJLkECF3vYdjiH5v6pfMlqtRHZRB8yD2E9vovSMJoS9bxdAkYAmtN09giJzToPb3r4/ZK+zC2OMjilElX4dkrEvZzY4MxmESY/vSXAHVZLs/zgsASW/6wZOc8pPMSnZNVBZWN/PzXscvKkeeDEkRi8qVG/aMYJ40O4tpXDN5QQP1y+pxXJuhx9jcZ5PpdPlidaYg7rn6aCe8QJ09g+XImC3xwcHh0R9fwXhHSq3FYglCkG4Y3bFWcXFboV16oXoh8eydwAkd/BeeV1IeP8am8bUwysH6OtF2uGsuAjP7cxeNSsBFXeVagu28jtZbdwYV/35OyTYAItObdz2O7Ok3V66zBbN5DmZzqTOGrMTL8gXAd34XTjiEDke/yU7vhp1MtFkZSt/dJ3RLdM/xuTFhBsEaerWLnL7c4An
 t5yJvydA
 HE3hP13UPqxUNzvfMJL0PK3IqsxaJK1fI/wQvu36jyNNWPY9KOXyRpPz25RPFLfmSWvOspjCYkErQY+7IPkkkusRZjy+yVWeVogNzW/Cr6xMaftHuYG5uCosBr9vlw8ZvGtDoUT2nzavIWYF1hP40s7Qo1siltE0UjPH5JglxBLD5fEQvjieo7vBCpBnLIS/3sivvSxWroYdMbw4iRivpKK9fEUS8eIWWTGUr4lNnelFoJVyscUbxxS2VP2lO2qukMYvbhgCDGmZKiRCGhblO97x7j4DLicxm8fCD5qDY91xxx8Ugd/171KiEmRO8eR1uJInrhn4fu1Lr7kVAM/PijmjblAqijoDmnLmIGv6flMNiJMFqDKwJTVvBgEqf2NTwAQOpZHwpzAy8ghZA5GnNIVwC95+lG1PffYwxOsggjd23vC5xCMnZREh47pXUBOczjl/2Aq25RKCh/jZCN0fwrVOowbxXF+4jezzl7XJL0opX36Lrg++60+PuGNNrhLYrnorNwamXS7QIgFoAIkfSJa3LW75coRG8KES2S7XdRgZKugJLH60YpCRZtVCzBwGgJmO2wrn/9sXAlYF/1wG/4oJxnMk6/v5BQem9RaV6pAnY2WEs7ulfSrVR4QoUIRVsW3gofW8O8MMqfrCO4qN/iCSlZSLunN8lufDhKZuSrVM45u2tQ1fG9HYi69InIGn+tU8m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clang's context analysis can be made aware of functions that assert that
locks are held.

Presence of these annotations causes the analysis to assume the context
guard is held after calls to the annotated function, and avoid false
positives with complex control-flow; for example, where not all
control-flow paths in a function require a held lock, and therefore
marking the function with __must_hold(..) is inappropriate.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* __assert -> __assume rename
---
 include/linux/lockdep.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 67964dc4db95..2c99a6823161 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
 
 #define lockdep_assert_held(l)		\
-	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
+	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assume_ctx_guard(l); } while (0)
 
 #define lockdep_assert_not_held(l)	\
 	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
 
 #define lockdep_assert_held_write(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 0))
+	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_guard(l); } while (0)
 
 #define lockdep_assert_held_read(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 1))
+	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assume_shared_ctx_guard(l); } while (0)
 
 #define lockdep_assert_held_once(l)		\
 	lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
@@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
 #define lockdep_assert(c)			do { } while (0)
 #define lockdep_assert_once(c)			do { } while (0)
 
-#define lockdep_assert_held(l)			do { (void)(l); } while (0)
+#define lockdep_assert_held(l)			__assume_ctx_guard(l)
 #define lockdep_assert_not_held(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_write(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
+#define lockdep_assert_held_write(l)		__assume_ctx_guard(l)
+#define lockdep_assert_held_read(l)		__assume_shared_ctx_guard(l)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 #define lockdep_assert_none_held_once()	do { } while (0)
 
-- 
2.52.0.rc1.455.g30608eb744-goog


