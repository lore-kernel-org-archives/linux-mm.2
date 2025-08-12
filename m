Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F44CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F95590001D; Tue, 12 Aug 2025 13:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9D58E0151; Tue, 12 Aug 2025 13:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFE290001D; Tue, 12 Aug 2025 13:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBC428E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB59E80E4E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:15 +0000 (UTC)
X-FDA: 83768867070.01.E591E1B
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id E35D912000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R+3yovTb;
	spf=pass (imf29.hostedemail.com: domain of 38ICbaAYKCKsVfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=38ICbaAYKCKsVfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovBhq/8jpHlM6xqUqyu+IoeRpzyccIKyfTNMwGT0Gbo=;
	b=KF7uDOEvFddOhXEElswg9dtTO7WaKXXPWlq2gr5QYqmeggVBHjzNBJbZFfAYzV0JVDjqPn
	g8g+tGZaa5i+SCjusEjDV6GCgsm6vxQjls3pUD55oOqV8mejbngzOI4st6+kWHSDWQmVOI
	xBdupaDcwNGFsebZaFtSIwjV0xgcOjU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R+3yovTb;
	spf=pass (imf29.hostedemail.com: domain of 38ICbaAYKCKsVfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=38ICbaAYKCKsVfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021554; a=rsa-sha256;
	cv=none;
	b=CMcq2kzYjuoYJa1foHE30N3YDCCYfTjy6sksOp6LPFfTgecTJP/56D+cJNCuAYDnGI22sa
	+1FX93w+hldrb9hAhczvdPjMRNCDK533hbGX+lcRTAvrOUTmJCgIiae129UdA90ILp22jX
	8QZVTJ/CYKyRfe7JS8WBNsOxct7iC8s=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bc9259f63so5723086b3a.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021553; x=1755626353; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovBhq/8jpHlM6xqUqyu+IoeRpzyccIKyfTNMwGT0Gbo=;
        b=R+3yovTbNC2fPXeqe8ifTdzdvE6qTL4ejd7l1XCUw2/xw0aLQGJ76bksZpMv3cy8k0
         zhbeFziC0z8BovYu+pUTZtY9JGgIUXizxfQk2I2yOH7SQ5qHWuqjnYaGKFn7+bX1sBWm
         jGDbBw2Sa349NtMH2q8fhS4DsVR9mJVekXgWq/+pKHTv6zcB2iJOKyPGXFceIUgq3zeA
         4R6Q0o4WqdG0q2zwPSyuPsJhA9FAjWVMo93tUlusw9oRj+Vdr6EoKrEXYQMUUHUAPTb9
         Fr7k5sB6eGRi4RlRGseEHhTz5zw4bpMsTAZyNPOq6mcls0WQYRvXhjwWxNOL9II8ng5I
         Yc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021553; x=1755626353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovBhq/8jpHlM6xqUqyu+IoeRpzyccIKyfTNMwGT0Gbo=;
        b=gtgmqI9QeYZcPPWiOtqNSrqfxukHvb7/5F18U0QwMV+q+WzDTp/GfOjXkroHIaR9nt
         rou+VPR5GCYLKTtjczaskRy5YEAyMJPU9aPdghht4Tn2ydgiyWht/bryC9QwrawSqphe
         g1LLSWlFHb9AI4b6wPWa4y6A9ULoqz6WC7Q9Na9zD51o7z/As/MniYiKq+qbKA9wpqAq
         Ht10J4IjebwZPwNgDe6Bp54JvxMYDES9lFt4ywwFd/UDfgV+lTDpy/iR6z1AcjSo2tT3
         auspCyPHBA7tDs58IODWSOUqQa5JDmPpTykuWlze/Y3EPu2nVUOI45wH/9jNmQnepMiq
         rAtg==
X-Forwarded-Encrypted: i=1; AJvYcCXHdzgYObYYwEuRbIsgIfkahMcjPWP7k98qYIGhiVUP5dUzGN03JvMnjMDL7E7Hygv3i2ku+nus2w==@kvack.org
X-Gm-Message-State: AOJu0YyoOFit8FJcz508aHeooFLooMscJE1joURh/bWWljXEB4WiALtk
	iACrdVP32Iuc/3LD4VLweJrU8F/hHGI5tNnmLQC1l6sUefBY+XJZz/4AEqaogbETt1Y1xGYixkZ
	KlE0liQ==
X-Google-Smtp-Source: AGHT+IE5Mz+dp6VV6fNyX45tpzOfL0y24+xxBoFkDHbdJqD0bFXipR3WVQOWKJpZtMRbGnc0JSgega5q8zY=
X-Received: from pfmm3.prod.google.com ([2002:a05:6a00:2483:b0:76b:d2d1:119c])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a8e:b0:76b:e561:9e1b
 with SMTP id d2e1a72fcca58-76e20c9a3efmr172719b3a.1.1755021552359; Tue, 12
 Aug 2025 10:59:12 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:29 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-12-kuniyu@google.com>
Subject: [PATCH v3 net-next 11/12] net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_memcg.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E35D912000A
X-Rspamd-Server: rspam06
X-Stat-Signature: darqh7ex5bd53f8xaytnx1kw4m316z9e
X-HE-Tag: 1755021553-698957
X-HE-Meta: U2FsdGVkX1/Ah876zu1VAP0Jsu9ppdpiqwj4aJX2yWWr5RxLzXoFaED4RtJOHSJaCbCU/TENQOeqMb9AiijBl7X/EDE/HM6eBtdVyiL6iysw8Zlndp7bNpD/pum0ivxQ4QvLw5pWIj5d+8+4si4EHvz0J5YRbTXDdFiE2bSTFIvFmpegDjtiN3NwWUWyUMjip9FYA0+wdVp7tgISb1S0jToB7Y2nmFJCF4dopmYVJZiJezR0cKy2MxVnSAHoe6nBcNg3nN2Rqe9+53cTQ7uSsZDM5XIAgOqWaozhMvZ+oqFNfGUbIe+X6LaN1jSZkqHf/AKg7jOrAGvvdd6+jrQNuuo47WP2gJLv3Tl/vMFeygigaLQGmIZbr+kagblKMjS7WFfDVzdhe7V1Ln/qGvfFG3HAAiEtnKQaEvZVAkhBmUWghsgZzU4KimQILcn3zvtFv39g9zzTyboVPuU87bZVx3Y875Bihp4+iyEdwFmjI/9uVWH8NWvqCh/Y427k0vb07MmiJbs2EZKcO1htvI9IZfkrKRrJ2dGjR0itQH8oLXpPlOROPxEF0t6hi/kYiCRCzkQCnk1XKORaNBJrlEkNT6jP7WHnV6pdc2nQi+ZP3zCSdHoD+OGAzAuMJYHn+GRCQ4gfptu+A0pRhJ9HL9RBu5jGsMRL8/BgkRWwejys+XcruujlSBLOmC29yJRno1PTiZz0ZtdWpZQPbkzBSRnfYYfQP9V1iY4giR1/FS/fdOUbcP+u2N7ZeSYkUYJeFl/bsgPX7KjdH4LEsZjZppGGvCSk5E7yll/WnWri+yXAEWoa4vBtRs1wPak34QrrNSxHaFBpfFhbznzKcdTMbrIT7pARX7HNtINCWGRSgPOhVb77Y/MKrtzAVbP2+SVGm+iTvbAkyVFNhJMk81aHaxxfut6RsbK4+Dc/qiiiFodeLq/MOJMyLUiSbShoiYcTQhQ/6YI//RfccrUHYZknFMc
 DXAUQ2Ud
 qcTL6z51cPjOZRP12SJL5AWhfiKUQFqCC/7ULujVikq9950ikI5jFTui4fUxgRb+tRCKJnbo0ZCmSTXn89UYMKn3kPU3RqR8mq0C9sCTY7QoPMJ/ob/jj4Mi6WwHc0eadFGpJF9/hGsXRCK62Wr2+jWbjRaYOBdI3iVAMgqp8VOXHCQH7/+hIbY8BUc1ayk/FtGLpFPeq9A4EfQfljsgECiAxlimDeqQ4qpd5VQ0O8lfYb76fdfG8/JpKUa3lHcbWtMO7J11jtjWoLS9jg1g1S5lfmHCG/I1HqBrI/1cevGGKY0ut5jC9VoAhUV5Le4bPpwdOSNFoypqMiR1PUOIsCu7CX3YZx6xBIcgKXCliUeO/5LqYQMiTs+mCNEv6t47UGOt0SCSejRVKHHDg08DPZD4yzAObeiuOyoAWG8uPva5GcM+1DbZIR03mcweaw0CAAXCXDGdQm+mt+pqPSD8/jzIZqZSFdGpA1+fmqAWsmMO4rXSbMtWsUzEnEzvAQzOd7NHhQIlyVvZ9v+/mJEnOr/kUBtroTH7G9kkfmHLmCpgoTplx5uCW1yaGSO95g+TcbJc8Sznhm52iP8PUvwf0gdgdfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will decouple sockets from the global protocol memory accounting
if the cgroup's memory.max is not "max" (PAGE_COUNTER_MAX).

memory.max can change at any time, so we must snapshot the state
for each socket to ensure consistency.

Given sk->sk_memcg can be accessed in the fast path, it would
be preferable to place the flag field in the same cache line as
sk->sk_memcg.

However, struct sock does not have such a 1-byte hole.

Let's store the flag in the lowest bit of sk->sk_memcg and add
a helper to check the bit.

In the next patch, if mem_cgroup_sk_isolated() returns true,
the socket will not be charged to sk->sk_prot->memory_allocated.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v2:
  * Set MEMCG_SOCK_ISOLATED based on memory.max instead of
    a dedicated knob
---
 include/net/sock.h | 23 ++++++++++++++++++++++-
 mm/memcontrol.c    | 14 ++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1c49ea13af4a..29ba5fdaafd6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2597,9 +2597,18 @@ static inline gfp_t gfp_memcg_charge(void)
 }
 
 #ifdef CONFIG_MEMCG
+
+#define MEMCG_SOCK_ISOLATED	1UL
+#define MEMCG_SOCK_FLAG_MASK	MEMCG_SOCK_ISOLATED
+#define MEMCG_SOCK_PTR_MASK	~(MEMCG_SOCK_FLAG_MASK)
+
 static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
-	return sk->sk_memcg;
+	unsigned long val = (unsigned long)sk->sk_memcg;
+
+	val &= MEMCG_SOCK_PTR_MASK;
+
+	return (struct mem_cgroup *)val;
 }
 
 static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
@@ -2607,6 +2616,13 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
 	return mem_cgroup_sockets_enabled && mem_cgroup_from_sk(sk);
 }
 
+static inline bool mem_cgroup_sk_isolated(const struct sock *sk)
+{
+	struct mem_cgroup *memcg = sk->sk_memcg;
+
+	return (unsigned long)memcg & MEMCG_SOCK_ISOLATED;
+}
+
 static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
@@ -2634,6 +2650,11 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
 	return false;
 }
 
+static inline bool mem_cgroup_sk_isolated(const struct sock *sk)
+{
+	return false;
+}
+
 static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d32b7a547f42..cb5b8a9d21db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4995,6 +4995,16 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
+static void mem_cgroup_sk_set(struct sock *sk, const struct mem_cgroup *memcg)
+{
+	unsigned long val = (unsigned long)memcg;
+
+	if (READ_ONCE(memcg->memory.max) != PAGE_COUNTER_MAX)
+		val |= MEMCG_SOCK_ISOLATED;
+
+	sk->sk_memcg = (struct mem_cgroup *)val;
+}
+
 void mem_cgroup_sk_alloc(struct sock *sk)
 {
 	struct mem_cgroup *memcg;
@@ -5013,7 +5023,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(memcg))
 		goto out;
 	if (css_tryget(&memcg->css))
-		sk->sk_memcg = memcg;
+		mem_cgroup_sk_set(sk, memcg);
 out:
 	rcu_read_unlock();
 }
@@ -5035,7 +5045,7 @@ void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 
 	mem_cgroup_sk_free(newsk);
 	css_get(&memcg->css);
-	newsk->sk_memcg = memcg;
+	mem_cgroup_sk_set(newsk, memcg);
 }
 
 /**
-- 
2.51.0.rc0.205.g4a044479a3-goog


