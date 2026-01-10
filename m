Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC724D277C9
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 03:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB676B0088; Fri,  9 Jan 2026 22:23:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F086B0089; Fri,  9 Jan 2026 22:23:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202C06B008A; Fri,  9 Jan 2026 22:23:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4B76B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 22:23:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D08813C820
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:23:29 +0000 (UTC)
X-FDA: 84314608938.23.B1FFFA4
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8AC9F100004
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 03:23:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UeFns+Lq;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768015407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mq1TLJDe/+4ZL2ybMlQeyJEwr2YWMjzl9f+SS6lqEM=;
	b=M2lCaKoDxur6KID6EvE6ddK8pIQ9xfFiagNMJ7aLdlq/v4IRsyJlh8AO5TILCnq4/LEvEJ
	tM0QlGxfGf+UqolRTnki38LyFxMYgxZL8eeaN0+xl/x0IjY9N+qm9+im9lFsPzadu+Y8X9
	kiSCYlhfgDmKCPXeKrMVuss7XPnlVHY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UeFns+Lq;
	spf=pass (imf05.hostedemail.com: domain of elver@google.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768015407; a=rsa-sha256;
	cv=none;
	b=knzfO+e7P++ZlEPpgP+MSnvWtOfuAZNQ5C2ggacJnbw1CfLe8depwNMlSuM4K0JvT+f9K8
	KS/DpQYxqoCW1QZ873iwMD7pPOpCjuJX9EYacNLPEaqPlapsqRZ8UXnpl8PP2DrMAv5IIo
	t7bUVfN1g9pRI7J3XNHwPViM4LnqXko=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-4327790c4e9so2454173f8f.2
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 19:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768015406; x=1768620206; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mq1TLJDe/+4ZL2ybMlQeyJEwr2YWMjzl9f+SS6lqEM=;
        b=UeFns+LqAWz0Tu+uWZfpQX1kNPjucKUotkzS4XqOSxqKUhtuHTO4JOguHgLeztP+ZZ
         Um5j3Gojovsi8Z2NYHusLbeS5g49+YgT2PCqlpvQBj6pNQsoeZ1dag5w1Yt329mGVKu2
         oaZnIoKayfowZZWOd+jhVm4N+EuxoBBdPKU1nR8sIQxqBbls2fJJ3xn9BmevL3cp8PmF
         ZwcxKwlxlzgcoaTQAJLndqrdUMw2p/JBUXvf2W2dEdF73sCXWugkGxDGoZT71PjxPojy
         wbXEXT0C493RfrXZciqEU5hWVJBN86tk2WqR60cv1jQZ4erqQarPxXiiDoKlrpT1P/es
         kZPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768015406; x=1768620206;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8mq1TLJDe/+4ZL2ybMlQeyJEwr2YWMjzl9f+SS6lqEM=;
        b=OW7skXQQWvjExM4Vkk2K1Uo+I3orUVzCvZ2eGjHy6Axmxb78DV6AcJ9Pmup7ANXYL7
         XMnY/KgGcVwa4kxz9XH0ztdtm7zHXSrLXOGWC3muQyykOjjKPCZlE45aXQWtBHaz0L+v
         WSQgnOp1XGX9RCvS+MhKtqSBwvArFKdIuvov6EBu/jT8/FCM+QpccBoI+fdtFgzehyfI
         vn/MSYhHW05n2V4JxBvZF2R5UBkWaFAjeyPG+NOFhao9pviTFkw/rVk2pZ2WDPtx+6Ym
         qKGjxb1IvI3UuXHv3Ev1KnwhobZGCokpd6YdaHwxuVzrn0kEtTqqabOIvQhdvVI4fXHK
         GB2A==
X-Forwarded-Encrypted: i=1; AJvYcCWEL5g4SS66ziuc9vlnnhamrXOl56eRLK1bq6JJYZ2f+D7bv1vYQK6eNzbN6LP8ZBH5pIcTtE7w8g==@kvack.org
X-Gm-Message-State: AOJu0Yz/cY+Ear83/7VyltihayfLqK9c8pxV3zNGyps/xdhH2vJGXth5
	iPuXj5+PBjg0IWH4WeKfh4QHsawsGusPBy3xQttNb1zwREUIjOxnW0tLB7bEqrDgKg==
X-Gm-Gg: AY/fxX5JUaVKARCafem/5Cps5VUA3UDqR6Wh+A3PgFrB7IWBnJmGk+JG8vboTPZWoTs
	l3Tm+XZ/tLqh8V0YrlVmbs40jtOdRO8qKVNQzCN6H9Jl9loOvUuDosAvbTM9R1zzxne0Fz5+BfN
	UAg8wSC0Cy1ClaPQ3feLmETiW/T/9KI2SiPCBHwr4EtS+mzvShAiFWHS5s5LOBhwWtFtB2lZmrG
	WkyZIPxuZc7wi8bR70hranh+ZAeu9gXwX+sxpyp1DypKJFziUVQbh2MmMyKzyWizZhufjC1YCQR
	O2yKFMiJQyFk8cJQZ7kN8DuDsUbO9cqsD8zYyDgNu69qXCZx81xRLymWlL1+L/OU3Su1jvBQG+o
	GQ4oZKMzn0cqkwUDPsngaNMx30qSQKT/S6GvdqQqpeGMYLb58HTWUUgRdLYqaxqG6U1IYDmlMIY
	HGhZqFZ05aY32aMIOuM+MKfR87K6IOU8wMIzygngr4h0cKYefr
X-Google-Smtp-Source: AGHT+IG9MVcoXYErsfPeUV+H1nwvNcE/auehFYm8oxMSVuIuHSa0XoHmpfdrWmRqI4nV3F3yqmQGrg==
X-Received: by 2002:a05:6000:2909:b0:42f:bad9:20c9 with SMTP id ffacd0b85a97d-432c36329f9mr14528086f8f.19.1768015405505;
        Fri, 09 Jan 2026 19:23:25 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:2965:801e:e18a:cba1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee24esm25605099f8f.33.2026.01.09.19.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 19:23:24 -0800 (PST)
Date: Sat, 10 Jan 2026 04:23:16 +0100
From: Marco Elver <elver@google.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v5 10/36] locking/mutex: Support Clang's context analysis
Message-ID: <aWHGJA8imMgELQrA@elver.google.com>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-11-elver@google.com>
 <57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org>
 <aWA9P3_oI7JFTdkC@elver.google.com>
 <20260109060249.GA5259@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109060249.GA5259@lst.de>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Stat-Signature: n6aqus6n6epxepep55gegu1opq4xgeat
X-Rspamd-Queue-Id: 8AC9F100004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768015407-282933
X-HE-Meta: U2FsdGVkX18CHcxKLIEcZ7ohW3trPM4LVqHfruxdkmS6ecDIKwoVZKLggFb/FC90ZmLEIgXiIMz7NweuZjFG0qL1bgvjE/CIVsAh7gq1E49QwnzUmg40mTCcJGcsmNuna91XppMuMlEj1J1nP6kmZBUekW4l8TAR8S/JDXw+RBo8ip2hAeXjOaAG/KVxwzJqxdhImBt4REKP8MBEt1Kd+38vO0hQMr6FraeN+N8bO9Z0ZBEAPB8fMGaQdJq9uDN+lJwIIxsa/WxxkmGvM1/21dXjh8CH66d/valgO9acUY2u1KhwjP0OUGk+xf6D3evlD4fxfG77T+eyb1tVWPhPl7ObQZxrCBXOw8INATZ4is1jUO3c0fFHjeCOPHYDKkYnHngB/SmRi1wyymNU+JwBxUa7m2B3+cuVz0wSDRZIqOCu5vaKmU9cEHyCfDMKF3UvAYnM8curM/ogfpg1Sw2X98yBcAl2b9qWTojsUXkjsyrTy/s6X/gH7aFuEpxpOueZqREUhwB1nlWCgKeL+kOOqq5/ol8IWs9UcOKvxI7LuVJ/PC/fCD5/CrEkm4CBBNVUChTrurN9zYAtqBbc0Z7MqGiKErtsokCFbeijhSihuZYQz/u5cxsDKPvbX3yxIDglXuObrJTuEj4L6hRX69VzvktQ4AHI+NDDYH+qxEMsGxxEgbVbkyW5qH8NyjqwVYM/MydP+Mg+4H+zcx0HKo7vqbD5r4qOMeM2XEjYV2OsNdVgE8ZcHkhgpoFrJz4XTTauy0vyZMp6BpyG/uhsv0zjtL0lJkPoKG3XBv+db/iEyBd0txQlknNZAH4Rvwm9858teXMy9vqFaH+t2RNuSF9r74gYt0XcwppgHAQTwI85KF3ly2aegOl5EmOGEgVoDkyJKEPluqxldYSEK4DkOBSPoqgE68A6H0T+C7V1gUne3j8oqBtLJbwxNFMFx07Uc+ciAMO57fm2Hiwwh3NSObv
 qkpO+je3
 N6fXFGTGKWDR3OUcl6f0SPvPDnIl7sbtiu3Wkp1fSNzpFZrwQ7KYA+a1uIZYYEJ7ngS+VqqERg966KFuE7jxWr8z3jpxOlFTdZNvQVIi4kehB/YMR+k/5723+xiD/XEn7/QrRhLcC+hLxsxHGizMU396FNpmwNV5uXgHR6rwdo+3+nwRWzNmALwVYeeRaaKsbYqcjLC/g0KYy9iVJZZrdLl1hfisJscQrh8xCh3qxzLTNuayqEmDByVkg+8/80oDmAmuMXpHUTcpLGjt1usrnBEM45SWY7wLKYs9VHzcMSO9B4iThIU0O0iGg2U/Gx0OtuRQZLsDJjkVv37XXjl4Aj06AIgKSyOoxzsuHWeR3puH2atGVx9WVaF4pXG6eawoRCtteylO20wVBY/QTN8PmI2HA0kgvmD5RoEjIq3AgX+vHSpTgxZAio9DsCkS1NzG868RSKDbFFTUI45gqhlXn0joZScfJnHYaXnWRGiBeboNnoei0OoF8uVvak4XA8BolGr8WUIVZBRk6d84w/G/LEvT5kSKF72tAzEXVjV03dcg8m5VnvYjnxQdnLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 07:02AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 09, 2026 at 12:26:55AM +0100, Marco Elver wrote:
> > Probably the most idiomatic option is to just factor out construction.
> > Clearly separating complex object construction from use also helps
> > readability regardless, esp. where concurrency is involved. We could
> > document such advice somewhere.
> 
> Initializing and locking a mutex (or spinlock, or other primitive) is a
> not too unusual pattern, often used when inserting an object into a
> hash table or other lookup data structure.  So supporting it without
> creating pointless wrapper functions would be really useful.  One thing
> that would be nice to have and probably help here is to have lock
> initializers that create the lock in a held state.

Fair point. Without new APIs, we can fix it with the below patch;
essentially "promoting" the context lock to "reentrant" during
initialization scope. It's not exactly well documented on the Clang
side, but is a side-effect of how reentrancy works in the analysis:
https://github.com/llvm/llvm-project/pull/175267

------ >8 ------

From 9c9b521b286f241f849dcc4f9efbd9582dabd3cc Mon Sep 17 00:00:00 2001
From: Marco Elver <elver@google.com>
Date: Sat, 10 Jan 2026 00:47:35 +0100
Subject: [PATCH] compiler-context-analysis: Support immediate acquisition
 after initialization

When a lock is initialized (e.g. mutex_init()), we assume/assert that
the context lock is held to allow initialization of guarded members
within the same scope.

However, this previously prevented actually acquiring the lock within
that same scope, as the analyzer would report a double-lock warning:

  mutex_init(&mtx);
  ...
  mutex_lock(&mtx); // acquiring mutex 'mtx' that is already held

To fix (without new init+lock APIs), we can tell the analysis to treat
the "held" context lock resulting from initialization as reentrant,
allowing subsequent acquisitions to succeed.

To do so *only* within the initialization scope, we can cast the lock
pointer to any reentrant type for the init assume/assert. Introduce a
generic reentrant context lock type `struct __ctx_lock_init` and add
`__inits_ctx_lock()` that casts the lock pointer to this type before
assuming/asserting it.

This ensures that the initial "held" state is reentrant, allowing
patterns like:

  mutex_init(&lock);
  ...
  mutex_lock(&lock);

to compile without false positives, and avoids having to make all
context lock types reentrant outside an initialization scope.

The caveat here is missing real double-lock bugs right after init scope.
However, this is a classic trade-off of avoiding false positives against
(unlikely) false negatives.

Link: https://lore.kernel.org/all/57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org/
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/compiler-context-analysis.h | 12 ++++++++++++
 include/linux/local_lock_internal.h       |  6 +++---
 include/linux/mutex.h                     |  2 +-
 include/linux/rwlock.h                    |  4 ++--
 include/linux/rwlock_rt.h                 |  2 +-
 include/linux/rwsem.h                     |  4 ++--
 include/linux/seqlock.h                   |  2 +-
 include/linux/spinlock.h                  |  8 ++++----
 include/linux/spinlock_rt.h               |  2 +-
 include/linux/ww_mutex.h                  |  2 +-
 lib/test_context-analysis.c               |  3 +++
 11 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
index db7e0d48d8f2..e056cd6e8aaa 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -43,6 +43,14 @@
 # define __assumes_ctx_lock(...)		__attribute__((assert_capability(__VA_ARGS__)))
 # define __assumes_shared_ctx_lock(...)	__attribute__((assert_shared_capability(__VA_ARGS__)))
 
+/*
+ * Generic reentrant context lock type that we cast to when initializing context
+ * locks with __assumes_ctx_lock(), so that we can support guarded member
+ * initialization, but also immediate use after initialization.
+ */
+struct __ctx_lock_type(init_generic) __reentrant_ctx_lock __ctx_lock_init;
+# define __inits_ctx_lock(var) __assumes_ctx_lock((const struct __ctx_lock_init *)(var))
+
 /**
  * __guarded_by - struct member and globals attribute, declares variable
  *                only accessible within active context
@@ -120,6 +128,8 @@
 		__attribute__((overloadable)) __assumes_ctx_lock(var) { }				\
 	static __always_inline void __assume_shared_ctx_lock(const struct name *var)			\
 		__attribute__((overloadable)) __assumes_shared_ctx_lock(var) { }			\
+	static __always_inline void __init_ctx_lock(const struct name *var)				\
+		__attribute__((overloadable)) __inits_ctx_lock(var) { }					\
 	struct name
 
 /**
@@ -162,6 +172,7 @@
 # define __releases_shared_ctx_lock(...)
 # define __assumes_ctx_lock(...)
 # define __assumes_shared_ctx_lock(...)
+# define __inits_ctx_lock(var)
 # define __returns_ctx_lock(var)
 # define __guarded_by(...)
 # define __pt_guarded_by(...)
@@ -176,6 +187,7 @@
 # define __release_shared_ctx_lock(var)		do { } while (0)
 # define __assume_ctx_lock(var)			do { (void)(var); } while (0)
 # define __assume_shared_ctx_lock(var)			do { (void)(var); } while (0)
+# define __init_ctx_lock(var)			do { (void)(var); } while (0)
 # define context_lock_struct(name, ...)		struct __VA_ARGS__ name
 # define disable_context_analysis()
 # define enable_context_analysis()
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index e8c4803d8db4..36b8628d09fd 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -86,13 +86,13 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_PERCPU);			\
 	local_lock_debug_init(lock);				\
-	__assume_ctx_lock(lock);				\
+	__init_ctx_lock(lock);					\
 } while (0)
 
 #define __local_trylock_init(lock)				\
 do {								\
 	__local_lock_init((local_lock_t *)lock);		\
-	__assume_ctx_lock(lock);				\
+	__init_ctx_lock(lock);					\
 } while (0)
 
 #define __spinlock_nested_bh_init(lock)				\
@@ -104,7 +104,7 @@ do {								\
 			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
 			      LD_LOCK_NORMAL);			\
 	local_lock_debug_init(lock);				\
-	__assume_ctx_lock(lock);				\
+	__init_ctx_lock(lock);					\
 } while (0)
 
 #define __local_lock_acquire(lock)					\
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 89977c215cbd..5d2ef75c4fdb 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,7 +62,7 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__mutex_init((mutex), #mutex, &__key);				\
-	__assume_ctx_lock(mutex);					\
+	__init_ctx_lock(mutex);						\
 } while (0)
 
 /**
diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index 65a5b55e1bcd..7e171634d2c4 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -22,11 +22,11 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__rwlock_init((lock), #lock, &__key);			\
-	__assume_ctx_lock(lock);				\
+	__init_ctx_lock(lock);					\
 } while (0)
 #else
 # define rwlock_init(lock)					\
-	do { *(lock) = __RW_LOCK_UNLOCKED(lock); __assume_ctx_lock(lock); } while (0)
+	do { *(lock) = __RW_LOCK_UNLOCKED(lock); __init_ctx_lock(lock); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 37b387dcab21..1e087a6ce2cf 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -22,7 +22,7 @@ do {							\
 							\
 	init_rwbase_rt(&(rwl)->rwbase);			\
 	__rt_rwlock_init(rwl, #rwl, &__key);		\
-	__assume_ctx_lock(rwl);				\
+	__init_ctx_lock(rwl);				\
 } while (0)
 
 extern void rt_read_lock(rwlock_t *rwlock)	__acquires_shared(rwlock);
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8da14a08a4e1..6ea7d2a23580 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -121,7 +121,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
-	__assume_ctx_lock(sem);					\
+	__init_ctx_lock(sem);					\
 } while (0)
 
 /*
@@ -175,7 +175,7 @@ do {								\
 	static struct lock_class_key __key;			\
 								\
 	__init_rwsem((sem), #sem, &__key);			\
-	__assume_ctx_lock(sem);					\
+	__init_ctx_lock(sem);					\
 } while (0)
 
 static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 113320911a09..a0670adb4b6e 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -816,7 +816,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
 	do {								\
 		spin_lock_init(&(sl)->lock);				\
 		seqcount_spinlock_init(&(sl)->seqcount, &(sl)->lock);	\
-		__assume_ctx_lock(sl);					\
+		__init_ctx_lock(sl);					\
 	} while (0)
 
 /**
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 396b8c5d6c1b..e50372a5f7d1 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -106,12 +106,12 @@ do {									\
 	static struct lock_class_key __key;				\
 									\
 	__raw_spin_lock_init((lock), #lock, &__key, LD_WAIT_SPIN);	\
-	__assume_ctx_lock(lock);					\
+	__init_ctx_lock(lock);						\
 } while (0)
 
 #else
 # define raw_spin_lock_init(lock)				\
-	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); __assume_ctx_lock(lock); } while (0)
+	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); __init_ctx_lock(lock); } while (0)
 #endif
 
 #define raw_spin_is_locked(lock)	arch_spin_is_locked(&(lock)->raw_lock)
@@ -324,7 +324,7 @@ do {								\
 								\
 	__raw_spin_lock_init(spinlock_check(lock),		\
 			     #lock, &__key, LD_WAIT_CONFIG);	\
-	__assume_ctx_lock(lock);				\
+	__init_ctx_lock(lock);					\
 } while (0)
 
 #else
@@ -333,7 +333,7 @@ do {								\
 do {						\
 	spinlock_check(_lock);			\
 	*(_lock) = __SPIN_LOCK_UNLOCKED(_lock);	\
-	__assume_ctx_lock(_lock);		\
+	__init_ctx_lock(_lock);			\
 } while (0)
 
 #endif
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index 0a585768358f..154d7290bd99 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -20,7 +20,7 @@ static inline void __rt_spin_lock_init(spinlock_t *lock, const char *name,
 do {								\
 	rt_mutex_base_init(&(slock)->lock);			\
 	__rt_spin_lock_init(slock, name, key, percpu);		\
-	__assume_ctx_lock(slock);				\
+	__init_ctx_lock(slock);					\
 } while (0)
 
 #define _spin_lock_init(slock, percpu)				\
diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 58e959ee10e9..ecb5564ee70d 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -107,7 +107,7 @@ context_lock_struct(ww_acquire_ctx) {
  */
 static inline void ww_mutex_init(struct ww_mutex *lock,
 				 struct ww_class *ww_class)
-	__assumes_ctx_lock(lock)
+	__inits_ctx_lock(lock)
 {
 	ww_mutex_base_init(&lock->base, ww_class->mutex_name, &ww_class->mutex_key);
 	lock->ctx = NULL;
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 1c5a381461fc..2f733b5cc650 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -165,6 +165,9 @@ static void __used test_mutex_init(struct test_mutex_data *d)
 {
 	mutex_init(&d->mtx);
 	d->counter = 0;
+
+	mutex_lock(&d->mtx);
+	mutex_unlock(&d->mtx);
 }
 
 static void __used test_mutex_lock(struct test_mutex_data *d)
-- 
2.52.0.457.g6b5491de43-goog

