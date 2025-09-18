Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6474ECA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AFA8E0124; Thu, 18 Sep 2025 10:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCD18E0112; Thu, 18 Sep 2025 10:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445808E0124; Thu, 18 Sep 2025 10:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30A968E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6090139BD0
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:48 +0000 (UTC)
X-FDA: 83902544376.15.0B48E5D
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 202BE140008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GRggl3K8;
	spf=pass (imf23.hostedemail.com: domain of 3uRHMaAUKCFo6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3uRHMaAUKCFo6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8a5df3Pjl9f6q04E+YVKjYiENmaUJ17VWF4NqYxrig=;
	b=UL5K8SapQAGzzYj314CeM8V0AJ1osnBRC9O/P/WkfU+StfV7eNhY1vy1HOs4xfuuiWWC5u
	/A6GaAYIC6dlWZGPsBohSuQy9hql/GDQhgvd5USWGT/MvQ0bq4pTgoH8pIGbS+lPZ825pX
	QrMJpWsl/GaVP7Vps0MxNPwjqTJqRJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204347; a=rsa-sha256;
	cv=none;
	b=yAccXuSGgzTm9PBmRP5kFWbI/8bkCG16BtC/C4zA22g4RkWR2lOezabMPGQ8EzByOACmCS
	670Z1HJaAE/4lbCX53QRdkpoPOm/PGaF+KgnbQ6bgwxUK/yGaoFu3Iox2lSaYGy0CklaXu
	gsJKbXEciZd0+N9i9RlR/VO8M8tkkMs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GRggl3K8;
	spf=pass (imf23.hostedemail.com: domain of 3uRHMaAUKCFo6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3uRHMaAUKCFo6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso5227775e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204346; x=1758809146; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8a5df3Pjl9f6q04E+YVKjYiENmaUJ17VWF4NqYxrig=;
        b=GRggl3K8lDli9wGCZC8u9hYbcaVKve6EgWH66JVBfabWS4IZJ2J2nn2zrcRIbfkXlw
         XIJlW5fbbHLctgl0C7T6HG8GP1SUEtFpQgZQE1J8DQqZqFhcewT9zHy48nJs0Jo63h4A
         U+sHyieptCf1YmRGReJHEYhP9hmpkD7F1F03IxKbVlHncTTWrCFmgxe36LHzcEQ1q/wq
         A7NiG84Tn/8ToUH8g5B2w+27ZiFKuoKaxolo7wgdTPDTzZtnyknns1tJlfEH1O7WEaUZ
         imMC6T3LXXmq3o0tfA2nWP6VVeIEFV20hPGW0pY3tjKd/crb3I+yDEHAGzwjMEmReahU
         HAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204346; x=1758809146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8a5df3Pjl9f6q04E+YVKjYiENmaUJ17VWF4NqYxrig=;
        b=CZ1LvJQ0BggeKLp+r2Uzy0VH2FglARU04B1SZo9mDj6TIHe3Kw9UrRbb/C2QExve74
         HF4oxX8wGOm1S2sQdgNDSd+JmJ+N54hj7F6psJFdxvbw2pSqmbQz2Gh6q3sUzDE1N2Zs
         gHWk2eFQWf3uBUU+Y9QtEwOvMbRpJC5Sc0q9cxiyt8UzU12V8WzjCoeTEGJNCpR3xymz
         x4CbEUjJxjBMDT9WxGFiFWzo4bHdG5mbtmvUazAxh1bb7nTkGzhHGmiAgJA5cKP1ix9t
         lIWnbNK2JnSrGhsnYEY7Lmz274+oYVfB+Q8oXcblGcvblf14HmkOngZaXdX7gHUC88wI
         Cn6A==
X-Forwarded-Encrypted: i=1; AJvYcCUtE3GwDNWIDNQw+UVfBADM5D1LzSqyo47DWEuwZa1hg4rNr8xRsnSr9ie53KrvJHx5rxQ3X2ig9w==@kvack.org
X-Gm-Message-State: AOJu0Yw+RNtShD1C1C14/txbBhNpCXxTF3IETovdDpV8qOaaZDokfHK4
	ZfIPVTNu/LHm8X9XyDbKvo14MOH2IqaqYmqQJ7nUTZXmAntNUzQdNrBZ6Dygat1MOkoFpiT1/wg
	vtg==
X-Google-Smtp-Source: AGHT+IFEiq4FEWWIzjiYKjnsdpYfxFd6yNadJ6YvqxXYjoCzs/skSdmVV05LRZuP59mbBWsmDTBBrQoRCA==
X-Received: from wmbdv20.prod.google.com ([2002:a05:600c:6214:b0:458:bdde:5c9b])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:314e:b0:45d:f7e4:8969
 with SMTP id 5b1f17b1804b1-46202bf788fmr56586255e9.4.1758204345502; Thu, 18
 Sep 2025 07:05:45 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:18 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-8-elver@google.com>
Subject: [PATCH v3 07/35] lockdep: Annotate lockdep assertions for capability analysis
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 202BE140008
X-Stat-Signature: 54pqfj1u185zzqsinmfssaze1cc8jbfq
X-Rspam-User: 
X-HE-Tag: 1758204346-867528
X-HE-Meta: U2FsdGVkX1+0J4qpHfTYOCoKaAYfxh/mQb2PUVHboFzUxAz2qz33+NE8qknywzD4vsFAIISUFsw1dUSH6/4i53oNcn6xLtIIPQKyWTCYhAu1EQfYuAEy59rqEOWRi6fzJtB647lkV4TNDNKdNNwWG8oNdX0DdGDLFIgLY/p08ksJ2rgChAPQRg1yEW8Y9oi4l2ZEUFKHQEI+TbrdGg0pz0OXo0O1/yMI36OecmUSVKof+xtLj6r8MyvMdjz4smMRXr7nnyjlolhtZWrKhbnfQgrCqhNiEFlhKOo54cY3VPBf6cvswQg4gEzdl2ki52GdniysVgVUTtQA9JfVBGMu00j0fH+t7XnWDHe0Bht+yWM6yBMUkob/i0uwyqB3BVUZAr6IS9hXjr4GGqxetojDRNYo01rwcypNI+m4r/QyyOkw5zLm8vsIcjRJue2SedRHXduZAx0rkqBwANB9gy/4/UhNNZHREX3qYl+LX+0SFiKiijH1ErNXZzeQoxLFiwz0Ghp4BBiHQOaglefJ+AFYxcHlhHuoE7OqLj0xl/z16pihCZF6o9D1Bd/ChB7aESBuqZFC6HjH9i6EbjZjiXICGwJF6DPXtKEvnbRy17bc7yRcZhk2lDCnaYCXklke8Ak/65O/yDUF+xfXfH87+y+wUOn+2pbHCwRqNn1eIywslOIjPV4l3iRxW3ZKCePEL8o+QQ1ErRHS18X8egaTRp/CSCP3nKZSEW+4YPdJBI/yj1PIiN3yppVdgdDqmbB1wfIm2LW6YAsmvmhwfh5LTZD6qnd6mMU9cpTa5E8I4LW4dH4qMsdyoebw7Yf/8UCVCj6k3VYMhUHzXU98w+QZUxqCZXneMiJXGi9dAeo4CTYcwIcLe9aZmsYDu7rns1gMRK0pe4g67w5w1ANSN3709Rf6zYDmxgQ890i9hm0Qct6pQYselckdwR3LmMty37vUuFBIawQTY7tA0iePfAlD67z
 vRKZlkUv
 Q6KU3EQ01WGvv3BxGeD5TKvvC8YA+sOxRCtw1nVe12qDr9KlKLbWL0nFOGaQm8pZ9eEin2FTV4Cuci3+BfrS/Lln20tc2uWiO7z0ihXyErks8712U/jSEUhydFNcqDlEPAEPk+G7s/Oosekie9CJbFIfmvqLasKJg3+VI0UjwplVmYvQGLUEbipy01cb4tuExf7eu7EKPgdjzKr0tBwC2rcEIjYXtiXFr+wjwKNuBfYe1jYEDbVPviLJegdyx4M2cNp1i7Z1hgqzQKzIvfoyxHkYsFWwaxjqtnYZwfuy8Fm56bu/d9NlnXD8zb7fa8R9niPL6O+USREv130jqq8SsZnXQ9r9LGsnktI4LrVmY4HNxdbfNFmlyvseHc1FLFlTIILx7DuMs5M0Tu+p+ISaLeV23ffC3LmwO8ZYe3F6a7UtX9SbG9mH/AliKHxseOZNkFPlIdsrCTVsc23CBMkmvLoOcVX5CwrqbAI7mibidm9jzg7lOJHyEno/TjgnMEp92IzGmAJP2XXImAEw6eI8A89QKSjSqZgchVEcKiuEUN92H9dBORq8Gztw6jIQKA0fOFjp7UP+JzFAXShr7qZ9oyOpshf2WsvrKpPvhZmdY3WcLU9zlVTQq/4zVncCWYmytx1lKTVK2noVpkZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clang's capability analysis can be made aware of functions that assert
that capabilities/locks are held.

Presence of these annotations causes the analysis to assume the
capability is held after calls to the annotated function, and avoid
false positives with complex control-flow; for example, where not all
control-flow paths in a function require a held lock, and therefore
marking the function with __must_hold(..) is inappropriate.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* __assert -> __assume rename
---
 include/linux/lockdep.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 67964dc4db95..11b3d22555ff 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -282,16 +282,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
 
 #define lockdep_assert_held(l)		\
-	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
+	do { lockdep_assert(lockdep_is_held(l) != LOCK_STATE_NOT_HELD); __assume_cap(l); } while (0)
 
 #define lockdep_assert_not_held(l)	\
 	lockdep_assert(lockdep_is_held(l) != LOCK_STATE_HELD)
 
 #define lockdep_assert_held_write(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 0))
+	do { lockdep_assert(lockdep_is_held_type(l, 0)); __assume_cap(l); } while (0)
 
 #define lockdep_assert_held_read(l)	\
-	lockdep_assert(lockdep_is_held_type(l, 1))
+	do { lockdep_assert(lockdep_is_held_type(l, 1)); __assume_shared_cap(l); } while (0)
 
 #define lockdep_assert_held_once(l)		\
 	lockdep_assert_once(lockdep_is_held(l) != LOCK_STATE_NOT_HELD)
@@ -389,10 +389,10 @@ extern int lockdep_is_held(const void *);
 #define lockdep_assert(c)			do { } while (0)
 #define lockdep_assert_once(c)			do { } while (0)
 
-#define lockdep_assert_held(l)			do { (void)(l); } while (0)
+#define lockdep_assert_held(l)			__assume_cap(l)
 #define lockdep_assert_not_held(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_write(l)		do { (void)(l); } while (0)
-#define lockdep_assert_held_read(l)		do { (void)(l); } while (0)
+#define lockdep_assert_held_write(l)		__assume_cap(l)
+#define lockdep_assert_held_read(l)		__assume_shared_cap(l)
 #define lockdep_assert_held_once(l)		do { (void)(l); } while (0)
 #define lockdep_assert_none_held_once()	do { } while (0)
 
-- 
2.51.0.384.g4c02a37b29-goog


