Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B69CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA188E0010; Mon,  8 Sep 2025 21:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA258E0002; Mon,  8 Sep 2025 21:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF838E0010; Mon,  8 Sep 2025 21:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0F68E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:00:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 091641DD55F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:16 +0000 (UTC)
X-FDA: 83867905632.28.F1C4F5A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 03176C0014
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:00:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ea8XsFki;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757379614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQaXiO7Rj6JeUoLNyDKccCslPjkrNZKqfhPqinjWMVs=;
	b=seUkv6JH2RsK63OXWIA34awxcga99RCYsMWnBWsYvLfpvGVmDwc7WSplBHn8QfnUms6jYr
	u5bU5HYggsQWQD9X0ohoXBxc5h9ugRTdD3V82ujg4u2M9gv6VtVExlBFNaVevDGiosqQ17
	yL2QHfKqvT99osp2lz5epBKSBqY2j7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ea8XsFki;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757379614; a=rsa-sha256;
	cv=none;
	b=BTd9hPGmzLcnbirqMjDzaNROCp4zpqFzMCNoGxu4J0YJqLMW8iMr0Ss/JSvLxFlZwNAhKV
	dO8hvK2yGK7SNylo7ErxUr88D1MfXcQ5RkM7oKspb8l+CWBoXAHV0XPB+MJ8qmYgkCt1Xl
	K/N7tMme2dJ0qk4wihqqVI+/ZNTgpD4=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-772488c78bcso4988838b3a.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 18:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757379613; x=1757984413; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQaXiO7Rj6JeUoLNyDKccCslPjkrNZKqfhPqinjWMVs=;
        b=Ea8XsFkiSj39meY3ZUIrhhra/ddUVEkJFxQzjr9RPYNEkHiHyzwFkAsGRdRgWTVXou
         jQOZ8IZVc9ylPjZSpo3rkQhVg3kbh+uskafeRfBDmWT6nmTBBNsoZq+D/BJIC8X5aWqt
         XPd+jLIAwIfMlzcSys65MyFZzH6MEqoTkxjdvtV3VPfrPZcoQlJ/nRww+I/KYbevwclR
         tfFBKCnOOylDyuvPP4khWBdltBB698KlQ5anlPlNsmhRwJB9v9hmljwS1ozYKQiDOsAN
         rAC0jktyf9Y8pk/rx2MWt5srR0jTT1TIdO6Wbmr9dDO/YUXmTgkdjxp+YHo2Vb5r2ulS
         b7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757379613; x=1757984413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQaXiO7Rj6JeUoLNyDKccCslPjkrNZKqfhPqinjWMVs=;
        b=tDGQ7D3aq9hSPRTy4mEhqvnhnlGtp+Vs+SLBsEdDLxzFaoY3AIfgpOnYuKt/8oK3xi
         8/IIWTsqHeqn3yBKNhV9V0LkVsWZOQd/9RWSefJZxsqR09p3Xc3M+88wA4pPdX9G8Xdv
         97ugC6eN5ecz+AULsxAwHb2m6b4kh8EqnRloXpS6iXRrS0x/rT0th7ycdctI1comRHeV
         VAO7EOAAhhp8v2ayVl0DeTW8X4O3vAiUM+S3oRTUzBCnBpkQYi2OCluwwraVEK9GReE6
         ueRHCzznVKwUcOrNv3SGBMlsik1zFfxscKH74WSzLNCVfiaK+t+8r648E09qmOt9qBgO
         Mymw==
X-Forwarded-Encrypted: i=1; AJvYcCU7MN7gx6uP08TcCTU+Ivq7Qd/D80vdSzPH8HV23En0J6aQF7Gs1SqlEvLCMSxSboFtP9jnSfPhug==@kvack.org
X-Gm-Message-State: AOJu0YyKHppkMLL+XTE9T1v21l/ZWBSrGqOJueNl/u1rNNPfQIB081Od
	cn4q3j97ibk+Dt0C5E4v86ic0COLQdK5eN6pOOerTGFdPg6j6oN73Yq4
X-Gm-Gg: ASbGncvMBSv4blm8lmY7FUUbebXTBHct8Mc/deVOAYmL7+VhNuxNNaCUp9xtxQTXtoi
	zeilfihfJsC1Ys1N1gwwhiawopH9HjfnDHFD23/+RFTNgE/kN0qK7ignhCW5sdLZowR2M7ftsci
	9leVgL0dQ2WVPXjRH8OGscLKcdShKlZ27GNmy+KgrceWDkB5D/0niNd6qyAHZOdYbJRcDtQI+ff
	tC7i9bYuU1/dPKcvnRhB7fpcn7RTdYOcMIFELnogU2KIDcmenNAA26odqyYwRK/IlOUL9SemiFd
	WJepp7CFocfKW4k8t8Pe7wQWq1p3/9nVvI4NvGCvzBFlohdgQHxiYkaXmfsKoHZscEhpc5hhxy3
	xgE8bi6TaoX1IEfIlHoJrUExAUlHiWRnoe0lwrG+i7z/JRctiELIOGyGfy50hlaQ=
X-Google-Smtp-Source: AGHT+IEyyyLEKg31IihQi/ou94RxqHeZu017zfwcJX6SGzpwddIuJtEgCWvNWfw0XBs7sZ8NiG6v/g==
X-Received: by 2002:a05:6a00:1394:b0:771:ef79:9338 with SMTP id d2e1a72fcca58-7742def5d1emr11646157b3a.21.1757379612566;
        Mon, 08 Sep 2025 18:00:12 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628fca0sm205235b3a.56.2025.09.08.18.00.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 08 Sep 2025 18:00:12 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab v5 1/6] locking/local_lock: Introduce local_lock_is_locked().
Date: Mon,  8 Sep 2025 18:00:02 -0700
Message-Id: <20250909010007.1660-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03176C0014
X-Stat-Signature: bqfeqb35h744cu8196kqmfqge56yyyzr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757379613-504065
X-HE-Meta: U2FsdGVkX18YghlJMXy94GWZlsKhkniGeOHe4MrPqvq6I/ED2vJPPbgtk/rju8V0WS3yAf0st1uihrnbKDdzIvL5NAtqiV3ohYIwM5iMrnZco+M+YL2n6V9R/0xVE9iEQBs+XGiw/THPoCT3OiX5sqaYaJbh+JyTMNxt5yVnDHx5aJ6pzRVowvtGE3PGXeGCwJr8/sZe2XAhyJzj8X/sbLpnqIO24WiThqHFNlxjmYQAtpdcIyvQ+e7Tb60YnkDhWSXX6S0HOTOqIjUKODjk40KXEzOlXbiRUhq0Mex43MiY3mo6W0yS5jm1oZLyO5sukCzu9N19h1wmbFzQzLePl67g5vtn1Nj02nZsPoub1rar2hWvPfj0LUoVaAybS4dNblSWwyUfMxPgKQ9BuosFsAUtFiP2Gj8WYrQVyei8KQh2s3aI31/h0tB60AYNon2LOO79li7x7LH0V/zksK5miptzaYQ/0UnOOtzGkEHm2BULGEzLqJcjy/chwN5sKOm9EStZEhGD8ZOX6ow4Vh67m6ZwgDXvRruB+NNXw+v/H3zHfk2L5pf+Vb6zIwNiPYvpEsXGTqFqzyaHmSMFRn/61iFMT417ADtczheabCEC/OonJgIj2CWEtKqFJAP+tOSuacCMzNJ+5apgt1QcIVfuUZ4BXjIp9bXb/rcw3RDy2QlxGMZUxeEFrf+MH08M9s2GnrqjbW1y7eyjOTLR17Ltw/yqLWC4f6mYidGMx9UBmLKqr2asXjFOUMZUVpILxvDM9W2nPGqMlQXuMzW7zKg6Hq43JHuJgROmnb3MvqzkRWTZlmr7dAM1CtlK/X202gTl7XfybrK+9rCGSLwLxA7LyKkJD+MtN+zsq//WJMmv5L51iu9n1Bnkpv2O6O3U8QAt86sGJvZCY5ZFtVlxf58sjXneD43D4rlY7TdiQ6RttHxa/ZEPw2/RfJuPDxF3wJYmcCSJYOFbx2vR/PnyyYj
 D27GmO3V
 gwt4rm8KUt3GgPQXSs8tGxaz5DOgVMjv/QBQhULIXRRfq8Z2ACYmuhuN3pcnL5f+TiaUkTv4O4Yr6zpAV9kLyBD6vW01bxyGwi0j71jALoSc08iBS7zY9LXkogVIEJWw4Ds3OdmXOIRY4NK9eVUhVRhlct/qmQNNsJq94F0jqqRjRZGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Introduce local_lock_is_locked() that returns true when
given local_lock is locked by current cpu (in !PREEMPT_RT) or
by current task (in PREEMPT_RT).
The goal is to detect a deadlock by the caller.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/local_lock.h          |  2 ++
 include/linux/local_lock_internal.h |  7 +++++++
 include/linux/rtmutex.h             | 10 ++++++++++
 kernel/locking/rtmutex_common.h     |  9 ---------
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/local_lock.h b/include/linux/local_lock.h
index 2ba846419524..0d91d060e3e9 100644
--- a/include/linux/local_lock.h
+++ b/include/linux/local_lock.h
@@ -66,6 +66,8 @@
  */
 #define local_trylock(lock)		__local_trylock(this_cpu_ptr(lock))
 
+#define local_lock_is_locked(lock)	__local_lock_is_locked(lock)
+
 /**
  * local_trylock_irqsave - Try to acquire a per CPU local lock, save and disable
  *			   interrupts if acquired
diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index 949de37700db..a4dc479157b5 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -165,6 +165,9 @@ do {								\
 		!!tl;						\
 	})
 
+/* preemption or migration must be disabled before calling __local_lock_is_locked */
+#define __local_lock_is_locked(lock) READ_ONCE(this_cpu_ptr(lock)->acquired)
+
 #define __local_lock_release(lock)					\
 	do {								\
 		local_trylock_t *tl;					\
@@ -285,4 +288,8 @@ do {								\
 		__local_trylock(lock);				\
 	})
 
+/* migration must be disabled before calling __local_lock_is_locked */
+#define __local_lock_is_locked(__lock)					\
+	(rt_mutex_owner(&this_cpu_ptr(__lock)->lock) == current)
+
 #endif /* CONFIG_PREEMPT_RT */
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index fa9f1021541e..ede4c6bf6f22 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -44,6 +44,16 @@ static inline bool rt_mutex_base_is_locked(struct rt_mutex_base *lock)
 	return READ_ONCE(lock->owner) != NULL;
 }
 
+#ifdef CONFIG_RT_MUTEXES
+#define RT_MUTEX_HAS_WAITERS	1UL
+
+static inline struct task_struct *rt_mutex_owner(struct rt_mutex_base *lock)
+{
+	unsigned long owner = (unsigned long) READ_ONCE(lock->owner);
+
+	return (struct task_struct *) (owner & ~RT_MUTEX_HAS_WAITERS);
+}
+#endif
 extern void rt_mutex_base_init(struct rt_mutex_base *rtb);
 
 /**
diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 78dd3d8c6554..cf6ddd1b23a2 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -153,15 +153,6 @@ static inline struct rt_mutex_waiter *task_top_pi_waiter(struct task_struct *p)
 			pi_tree.entry);
 }
 
-#define RT_MUTEX_HAS_WAITERS	1UL
-
-static inline struct task_struct *rt_mutex_owner(struct rt_mutex_base *lock)
-{
-	unsigned long owner = (unsigned long) READ_ONCE(lock->owner);
-
-	return (struct task_struct *) (owner & ~RT_MUTEX_HAS_WAITERS);
-}
-
 /*
  * Constants for rt mutex functions which have a selectable deadlock
  * detection.
-- 
2.47.3


