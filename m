Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3529FD7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBC76B009B; Fri, 19 Dec 2025 10:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C35B6B009D; Fri, 19 Dec 2025 10:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCDB6B009E; Fri, 19 Dec 2025 10:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7926B009B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46BA4B8147
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:53 +0000 (UTC)
X-FDA: 84236646186.30.79F8965
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 864D540013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2ly7KWj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3LXNFaQUKCHocjtcpemmejc.amkjglsv-kkitYai.mpe@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3LXNFaQUKCHocjtcpemmejc.amkjglsv-kkitYai.mpe@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159151; a=rsa-sha256;
	cv=none;
	b=wyp65HfNugny18rimrrn2eXkJKHMzB6fcKc/tfNhtm7P3V59DK9TH4aKmBdsmw+0W6nn9c
	50FjmvVPdVQW9txHGAZA8QXqXrrZvP5Dz/oEiMfFPFPfF2sDJmoUaGUJ4oG/7ULdQr17xA
	gyNkQfxzxUjIEjA69wRDNLx4MXY05BQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2ly7KWj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3LXNFaQUKCHocjtcpemmejc.amkjglsv-kkitYai.mpe@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3LXNFaQUKCHocjtcpemmejc.amkjglsv-kkitYai.mpe@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppEU3vt21POuxnmNi7TnVPUBkU2y1/pB0srZ9HoiLa4=;
	b=t2sjZLZEbMZ28dOgrPqbgcvLlllArpnIu/B9rAAN0+wBLs2Z63z3848bFqAc+cEAM8/FHC
	NqssK3Jv/EEdQh8eIU+pcjsQHcUpvFapTWIAIygzR2kJMhbQJ8scDb8f4tEM+bKSrXyDm+
	brp3uKbyadFdImzGJUqrXIRE0kubtdE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563a0c75so10562435e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159150; x=1766763950; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ppEU3vt21POuxnmNi7TnVPUBkU2y1/pB0srZ9HoiLa4=;
        b=G2ly7KWjRyeRYqcvIA5vtMYkHPeQPn1fVPNwyn1hgUG7j3Ulr/+Wvu8I4Eyfuc2yjG
         Cz8RTu1ohdzkKOJ6HwePU5M31uDSXQHs453xOyD+CdKPz18W1KkoQEwDB6lFGSg0el1n
         WDFIDtmFOGcLKKGDG8KE5niWZhVNynS7BIabtL0TRcroRO79IKwdOrmqHBpQcv+LF0XJ
         FwzMHeg1TOTPO0XKfJoaO5jDYtucT0xdBBx6k8SgheADOEbLWWnYwKyAmAdahdWz5o2V
         9rA1dmUjHNXc2w6XhT5t9Xq4Kh7QFioiBlwrxLHlkYZcOeyz6NJ3NJAvhw2SWGIusI4u
         mDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159150; x=1766763950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppEU3vt21POuxnmNi7TnVPUBkU2y1/pB0srZ9HoiLa4=;
        b=dR9QSqzsQmakme0fC/8yhvLDnHkQiV9jcuAdrYqF7Yn0a3g32UaVHTyj/RfCK8djT7
         jnVzwaucaLpANcNxMwPa6kZ1eIXeW6ZRpR7FWXHxqt2PQ3vdqJmoZgioy28/cPwvXbVg
         UdWZuyyiRf9eh3bUQThgruOEdCWbExyUX5ke6jC6sCi1w4BEYO3Zhb8BA3z5CIv20t20
         VPCyujp3hZ7f5qb/Ev6ZndHcTXW7N8FsfchwVrspGCJZIbzmwBeIRHkGSETYOtCl2qkC
         JEt+5SV6SrZgr0wOQ6wRL09W9RWRr6mRlgxGTajhXMqfPQ2AmF0IJof1K7X2fzEt1eW5
         SU4g==
X-Forwarded-Encrypted: i=1; AJvYcCVrZGruBxKvSpHG+/yPpvtRLwcy7UjBfmZsJNuDUgPmpVMGKmPA8FE2bh4BgeMsX6j7elL6E5PvPg==@kvack.org
X-Gm-Message-State: AOJu0YzaxOb18xnUrSzMokBuEjSFVfrpnE0Hljqjhsi8x0CDCwV20nnb
	F8sKrVJi8ehd/MjoI8oEd9G6qlXm9OcfSWV8EMxIr2qoihfZVh0yzhbZLcrqIQe7ojw9C86oJ2X
	YxQ==
X-Google-Smtp-Source: AGHT+IFAZFqR3CocsGFs4abVuEztgsgnPQaBN0RWDQEu/FHy3Bb3a0zFWcTgbAs09JYX5Sh2VgApfT61VQ==
X-Received: from wmcq18.prod.google.com ([2002:a05:600c:c112:b0:47b:e2a9:2bd3])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19c8:b0:475:de68:3c30
 with SMTP id 5b1f17b1804b1-47d1955797amr31569585e9.16.1766159149911; Fri, 19
 Dec 2025 07:45:49 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:56 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-8-elver@google.com>
Subject: [PATCH v5 07/36] lockdep: Annotate lockdep assertions for context analysis
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
X-Rspamd-Queue-Id: 864D540013
X-Rspamd-Server: rspam03
X-Stat-Signature: 1us7tic9u89o4jtu6mbnsxj3kkbjnx5z
X-Rspam-User: 
X-HE-Tag: 1766159151-622019
X-HE-Meta: U2FsdGVkX1+hfsPT2Hndp40AFiYlnj/8FkCAN6RXbtLk3hS/o+dwuvS6Vn8hhXvlwAPjPLdzEJHEhNpvWs4AmeJzFjPGeYEcQZCsufFb2aPlfQRb9qzsz+yEoffKq6CKrpZ8ug0aAJiMdO3ZxiycYawbC+klYp547gILXBRbSfmXyio4RXpczKYnsF4OoJOb0bTba9M7o2i7DBnQHzF9039f2SpA41tIonbXo2tLYQJXhF5oztv8EBflE66aokKqK0TfbFY4C87Ar6mD8iRdb21/dc3JWkFeZZcJ6lhXlCk42iuWNOBZZtium8dOJISrUUlI5F/Ux6L+dqBd1ThZ3nyf/aDaXj5iLiK6n6VVw/LuwH3D54hqnyRvcZvgmxy5Cg7dBV7UK8TA+Fc0eITOgKUlZujaJEMoxO9OKGCo8WwB/qJxhGno9Jsh86OwsVKxmxrH/zOejUIbxWnY7klUh3qcQqEvv0kSnksOZvy2t2RqjKhdFktH2Ewc567FPUcM/50el0bcgjNE33WQIuWZSyHw3cwO7D1FmsXAtKfhv05+oibfZooHOjGZVTpbruUOCudX7ud84lgLM88+/hhD6USHKxMhF5VaCcJhW3LoX9qGrYbrNrSVpqsc52qFH8ZsMoUutLQb34j7WbA0uf7o9zxVucb5XzjI68FRO58MPdsyK32IvPkI2TONhxecyUYXwZE+XQR9xgZ3t3EMm6gzlv66/f7esiLY1FwtZuMd/sU4Tf0G+aXWDrRGJxpBqHqTfQiJhpLzFmoYW9zAa9DNpfl9QY/MljZNBtjYy7RCxZ0C7S4gu9jlIWMmg10G04ABMRFtyNpZ1gexk1oGLh0CNGrLCLt0y/Oyz8nxZMSrAVsRH6xLhG8d7OZTuoIdZRL2E1ERvRqW9mG8BcmAworxdv33HDjS9ZDbg8twoq7a8HlUFl2aZ+e3MwJmbC1VAk+KDhrgQZ5yP62yCulP9r2
 ZLCIDEIU
 8nP6LWmu3OMZLAzVEJuxMxn351kAFoJ3/kD/DJmIdB6+Sk0KOE5GST0AVTNKPjD7DNkqxB6K3ycdLw9bYR9NKa0hPSl+kkXevATEYEtjDuXTNVktt1cVtNRe81JQ4OzZS1Pr2ej0s9HI8BmzLND5W23ULTF+V5UCQHQxEPwNz66bByf53rge4NtynBw4MHejlS5xYZX9SWFJSAFP3NYUoBVLkrRwiR3AroCAI3nnutQmvK4nTfW/Ast+06z8mj5rzuNHmpsc4kQ93ZVo2aplA7gVP4yTZBtoK+Ne7seBlGE/CzRbxxotMU8+BXsKL6p8zRnizSZjucE0D9m8j1Hy0WCqQj+sC5E0w2WJBGKHhiGdmQwL3s+90W8Y1nmSXsbzUkJzBgxD/3VfHcKH4RFmZntR5KB2cY6W5EA2p
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
lock is held after calls to the annotated function, and avoid false
positives with complex control-flow; for example, where not all
control-flow paths in a function require a held lock, and therefore
marking the function with __must_hold(..) is inappropriate.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.

v3:
* __assert -> __assume rename
---
 include/linux/lockdep.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index dd634103b014..621566345406 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
 
 #define lockdep_assert_held(l)		\
-	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
+	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assume_ctx_lock(l); } while (0)
 
 #define lockdep_assert_not_held(l)	\
 	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
 
 #define lockdep_assert_held_write(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 0))
+	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_ctx_lock(l); } while (0)
 
 #define lockdep_assert_held_read(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 1))
+	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assume_shared_ctx_lock(l); } while (0)
 
 #define lockdep_assert_held_once(l)		\
 	lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
@@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
 #define lockdep_assert(c)			do { } while (0)
 #define lockdep_assert_once(c)			do { } while (0)
 
-#define lockdep_assert_held(l)			do { (void)(l); } while (0)
+#define lockdep_assert_held(l)			__assume_ctx_lock(l)
 #define lockdep_assert_not_held(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_write(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
+#define lockdep_assert_held_write(l)		__assume_ctx_lock(l)
+#define lockdep_assert_held_read(l)		__assume_shared_ctx_lock(l)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 #define lockdep_assert_none_held_once()	do { } while (0)
 
-- 
2.52.0.322.g1dd061c0dc-goog


