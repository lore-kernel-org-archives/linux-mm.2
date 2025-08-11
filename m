Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C88CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3168E008A; Mon, 11 Aug 2025 13:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88ABC8E0060; Mon, 11 Aug 2025 13:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BDB8E008A; Mon, 11 Aug 2025 13:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBDA8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEBAD57ECF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:50 +0000 (UTC)
X-FDA: 83765169180.25.1192FD2
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0CA3D180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lbYch8Zh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3AymaaAYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3AymaaAYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvflH4mEPAWQ6li4TrYWNHfiAFRxuWfsFRk3VY+0HGw=;
	b=7d4TnCdLB6bxGCtyzYIKW+sufKBMDw/GapHD2ZOdlwlgjbRV+lzrn4hRKKwl5/+aNPfDP5
	+Itxb3UNElpUPclaKEEVhV9GX2Ww6/tnRW8vfuoNEWiydUG9kAV6kz/RAFQInKqPfSKVv4
	ldjiuOQtX8O04OyMrjw5fnlAjaERWeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933509; a=rsa-sha256;
	cv=none;
	b=WhdCx7Fy10pXqYztNFYg8NlOfQJ+0u7R7d/7NrZOBDpOM/8txhYF8fOKujXQdL4yckrC35
	35udWOlYP3mRtseO2rRsHSQJ5rF7gXwb2BH5/Wv4FkxC+UrPuotFrhGvsTc3pj24cjasl8
	3a+VAts+7yb/4UuYiaOpJsUaRjz3q1g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lbYch8Zh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3AymaaAYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3AymaaAYKCAou4xs84qyyqvo.mywvsx47-wwu5kmu.y1q@flex--kuniyu.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b42a54b7812so2521763a12.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933508; x=1755538308; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wvflH4mEPAWQ6li4TrYWNHfiAFRxuWfsFRk3VY+0HGw=;
        b=lbYch8ZhTe/xaT6CfpPTM7oW+hKgmo7cFsJ4dxbk2BwYeoADv+AGOeExcC1kgqRKVc
         3z/r6Vy8HR+BRZlfQ5cU1GmGjBJ0ZtLLqiQ/yC5KO/LMXba4/adaZM1WE2e0R/3JvliO
         BIVGeKY3rg9MSEJl+J/ZxGD0mcdaoBrzLO2RnAzekA3CO6hfNba9n4Bs1PhLH/yXKK5r
         kFa7EbT3qpYkvR1yKtI+D3Z9yBfbFimRlY6C3nYKtTwGzpBt2zyG2/+NlBSBlTr9LmbX
         XWmpPYtKL+Zd1XOxj+q1DLCzHVCOZht7LzroGEL9/WwAHqoufL6RQ2fyP2rth4XI2lFD
         eSeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933508; x=1755538308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wvflH4mEPAWQ6li4TrYWNHfiAFRxuWfsFRk3VY+0HGw=;
        b=NvM3h8XtGDcraR78DSOOMHZGTEreW+3FXpJxe2xknwkb53I729NdNQiXuXJZGkBWat
         ObSbvxMf+2l0M+L0tm0by/nCms5tL3Q1f/0/II7CRoJBbNRIDcRaMgHMUSsyTGEp2nbh
         I0tt1zDo2Hv5FeVVqEcbWnHZYYcuR5gYP1o/KaMRyL1m+GOL/sPvjej6l/AoYUaGY736
         OpxkI7s81M/UGPgRbUf+v9jMNJrL1+P549z8MuDgJ0BpYtNb7tY03AGndNhNoA9lagll
         qAZhDgoG1WA5lAjcVNwv9v/M8wz4HEknFNu727lBeaJy2BhP/423PT9Q4t61NQgxY0q8
         S1Ww==
X-Forwarded-Encrypted: i=1; AJvYcCVO7HCyn0LLAYaxY97zns74ZAIgvLn3lrk3AQHvQ9UhIlO+he7fAkm3eYqX8/LpwxBs7uzcGoqfKQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1qKmb14wcXPIfYFTSOUgmZ1MUQpEOg6AzUMIg9a8G9AKOvV5p
	lPPuQzf4QbOwqGFqYB+i1hH4WVNDZQAHt+06V8LbwqQQ6QI56j0dfLKx/lG0F8yuS5ZXG8FT+V4
	TaTgy+w==
X-Google-Smtp-Source: AGHT+IHWru/esDMIorV9KwapH35BgNKYXxj+gZBO2aUFirZsNJPkvzOa2N5vDdIDqP57DTCGbEd9T+ROCI0=
X-Received: from pjbgf4.prod.google.com ([2002:a17:90a:c7c4:b0:312:ea08:fa64])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d85:b0:206:a9bd:a3a3
 with SMTP id adf61e73a8af0-2409a968d13mr468882637.24.1754933507942; Mon, 11
 Aug 2025 10:31:47 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:39 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-12-kuniyu@google.com>
Subject: [PATCH v2 net-next 11/12] net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_memcg.
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
X-Stat-Signature: g3jku8xo6jwhz6bctd3t75y9hj8kjq53
X-Rspamd-Queue-Id: 0CA3D180006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754933508-568600
X-HE-Meta: U2FsdGVkX18adqvmJjg9QT124R4QiGcXPayGKD1sMsA9EEtjvKm3IdaU5FAd0dZOLfjQPLHHK1UPt9jtWTda+wDqmfBe70QAu9gBe3o0jkb5m5efwPIAcza8rwFQwZjlVtervBaBUrF2jHPugdQEmDxY9Be5uJuCNPbBUzGWvUPkHwhr7BGfoPbnxSw9UiFPAj9nPegoPutJfXH1m9fhcoPtNStsO2lPYR4WB6C2FuKRNg9IZGDKnilsN81kUeoTJtKdOKz0VdeuEfJpUMWhPgKlkWo5IsIu3HNDRDm9GDUJ3kff8dOc6LshRG91UImUq3SWAyBYXfZPr1J9h53d5yhI0I/tk149SNDscMrn2O9YgjK558LFRadOeBjHwqjCmnOY03tKDs53WfHsK/k+PeLUmIwCbpFYyBSJuxr+OoroTQQD7j9eKBufYqfaP02HpJWNXGauGBaQvEeeyFTUIcV3dwkmkQR6Eq2nP1/CrgnGesweRHiUZ2R8YnxmRjgRre0LchVuwg0yGNgrRK7H3zxiPF3yR2G0Tfrh9F2Hk5r5x3hBe0JfFIi9YJ//BBRnrapUKhQx37NhqifAt948DqWhqtc8zHBOLDsvaEJ4KSkbevD0qJoh/tJWW8vc3/pZRIChvR0SUfPLoSJjfsqHwnmJvfydIlmh9NmOXUgyn/qOeT2i4Wh7pwJXKjBLRYJVMttXicCSIQBTS9nA4S7zwVkfiYzFXvmvvjiJGMY33bo92FysA3RxqFdUmOI8kkwAUiwUPy2El5lK3fjJXqbngPs4lFamArlVWh6ItxmcMqJ/GwWAOZ4qa4MxFNmGrAdXWpWDxOal763+w+LIM7iQ0RkCPrQSOY4g/q/qvT1du1ObB9MsqfFCYCaTLxcn5sYpvKTGV4Q5Na1Fycx601c/5oqOKNWd5E/MctvZCiEWhz7KteBM89BV9Cvwini8doHQDbmimAcxxoYHVW2atsS
 B8UjCFy7
 o3iS2nTunXkCPZQ0fYW3xIpsnnO/DLwSqGtJ39GjTgcl4MuHAvC1RzhOLGV280J9dJexL4oGf57kKjHqK92sTon0qZRSV0gA9vqyHAC4F63V7XzTEa7HBvEbsVWzo1tBuIQMBKxZ21naiSph2SbCdocmylNahHAYQEQkEy7s5d86jl51pJ6p8yk9amwiNegYQXIZ8fQOBGFa++FJOJ4aV0BYkhXwsaVpWHbNgHlRW9+VaoEMe23q93tyh5MvoNlou7O2efBnzvx162tg7AK9XDmT4e3/+zdoGBjpZ0sbiePqHIIgM8oQh2+fu4HhgfO7gyEBRhc0hvn83RvxJloaN936jucHga3wlhwXlEVJsMqrUsm1jkCjedvapMosd4Y1H7a59jiTZRQvCGIlsdy+Sx51geUy28GpKZgvyigqQk1ceBvsB4fMUUO6vKPXMYrssaWWyu4onrdWlP/FJXjQdQYVjWTia4KKaeQeWzY5kIA1rEiYizC4hxwW3UqrbY7+QRVu4qRzMLomPdOChEZpTHJO8ui+r1sSySius6kcPeMUB7fqBcchc05zpDZhn50kbEheScC1tU5gMTz0e4NpJIDp2Sg==
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
2.51.0.rc0.155.g4a0f42376b-goog


