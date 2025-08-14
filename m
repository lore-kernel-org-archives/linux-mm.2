Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF78CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88AC19001D6; Thu, 14 Aug 2025 16:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DF59001D5; Thu, 14 Aug 2025 16:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FC89001D6; Thu, 14 Aug 2025 16:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBC99001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1657B83695
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:30 +0000 (UTC)
X-FDA: 83776452900.02.0E3B345
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 44C3B1A000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e+fM2Q0+;
	spf=pass (imf19.hostedemail.com: domain of 3d0KeaAYKCMAq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3d0KeaAYKCMAq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqwQko3rlUblyrU4VKeLR8maNWxKsVT32Pjp/b8BmK4=;
	b=Z2oWLZNms9D1cSGndCtM7qVZY5VnaQK2xrGih8Rt289I1p4SNSJb/m3Fb+SKR9v8QMipN8
	K6jjRZuzr2onvzFq/tmCVNhC2ZJubYWLLQH7E2ifVdvsHsTOEHAd+cOl6zSs9aUWCjlzP5
	pgq2lvN2AeuJc88XhqygsQDfA8YvqYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202168; a=rsa-sha256;
	cv=none;
	b=1VdsJkTx7gP4chd1SJ6vmgCWNE+wY30xZEAzgl53qUhmm/vTJZxRY+YzBc/dUrVA6xDQFP
	4FK/BozkwAZWFqZEKRke6e6JiXs5rTz921XlZTO3WRTJvNOHQ5h7pXap6UKqrAAJwlPeDN
	J2Kn5RrLVuTarwbacw+bqzCmjwV1LOM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e+fM2Q0+;
	spf=pass (imf19.hostedemail.com: domain of 3d0KeaAYKCMAq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3d0KeaAYKCMAq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4716fa1e59so962020a12.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202167; x=1755806967; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JqwQko3rlUblyrU4VKeLR8maNWxKsVT32Pjp/b8BmK4=;
        b=e+fM2Q0+bo19POIWkfotA2xqBnCLbFQTyIuINiLDq4TIpfgSnhwQrjCK9qqPMNFcp2
         HjALV2Px1WRo5JbHHksDTg1iO2etJkQvXAZY4X6VhrkfuxNDtzR9Lc0hWqnyQv9qIT2m
         LQTw/q4BqVZ3MYqdwdnw3JVpGcHjYivPe7FNeyjPZz7F7blu4/YotHq21w68Lk4o67Xj
         Xa+Tjs/SlxtQ07wddswKvvqCOWRXf/8CqFkw3v7GB7s4VZAGUVkeXS4JlBiTOnWcsEZq
         wMDeJVDs2dQwrlrAYO5AIliksx/gPZnR0UmqSP8vNmZizSng1gVKzfIpuys+D/bZ0qC4
         3qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202167; x=1755806967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JqwQko3rlUblyrU4VKeLR8maNWxKsVT32Pjp/b8BmK4=;
        b=N4D6Cj8k4gjHpLIJNphlbql+IY0BOfMUHDWvrovkmfQHhOzvP3y+GMYnJtvgfnT+RH
         tJxknEa/vTyW4lKjSQKcqjnnoRIDtU0nRfTtHBpPFIRWSNB/6wRAQhMpsySrM6IvSSN7
         cy4+S7Jn4nl2Aj8btrfzx5VizosUZVTZ2bG74fLJebJf/0QJSc4p05DeGxli1QjRquXB
         UkbAA2Tq3smR8JHkxDA2Y/kA1CzPqd46D9qtaTjNE3hSFTsX4EEIwx3aWkhUNhNelPwa
         8tlifxXDsqenKu3LRGL17fo2p2ZX5ZCJYwdANtQqDzQPAJjAq6L4RJ+FVJBhKpIEnk8P
         HqkA==
X-Forwarded-Encrypted: i=1; AJvYcCWpmP4Kijo9v5T1aU4zoTTE91udLiUJasJk7qw76aYTQaOb8I2Ifq6F5jGl28asqyL/QoHYuRWzJg==@kvack.org
X-Gm-Message-State: AOJu0YyLtzcmf7TviWzAnjKzH2TgkjpFPcADbLfxRwDTEUnP6/LKTFSL
	eTdyIA9++q+vOxKrRYOgbU2Utt5/6Q/1ruqeveRw6YC72aqAiQAl83zXerEsfMce3otQk4agnAI
	Kj5JaLg==
X-Google-Smtp-Source: AGHT+IFpk9GsZzJtad1xWRq/jKEfmD5Hu2g99Bbrw9g4nsIfbB0KESQYa2J63MdiGdBZTWW3/moD48VO1k8=
X-Received: from plbmv14.prod.google.com ([2002:a17:903:b8e:b0:240:3ef8:c304])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f550:b0:242:9bc4:f1c7
 with SMTP id d9443c01a7336-244586e0821mr67776325ad.54.1755202167115; Thu, 14
 Aug 2025 13:09:27 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:40 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-9-kuniyu@google.com>
Subject: [PATCH v4 net-next 08/10] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44C3B1A000C
X-Stat-Signature: w7p1pjdxyjmhuz4d3gqusmc5s759myar
X-Rspam-User: 
X-HE-Tag: 1755202168-401996
X-HE-Meta: U2FsdGVkX1/e2ltPFiI+9YOp1StId2QiJZ/yrYW8Ihb3PaQUeiVmCRfk4juoh8HjA1btEOp9d6LeSGoX5PwRpLDNu3wgeZNOyYnOdCoI8jUFFmjSJUC0FC/S3wR+/mm747KT9XnUhu+9QquPLofMb1lJ/vGqYlRhv/bBNDYsFZEvK9QOGzhMuvoZNYm0KNVLEkYZzm/4QJz+0wt1ANoDRYqgcdTaZQA0yFr1ymOUwtDeo3dXhgwsm3jjcm7v4A27QifRV64EGYuBzkAX1s++jkl4Xjv5lLZJV34/v9s2q+NrvLXn7M1JdV9Ok6/TC1hWozN89hT/jxeMWuG5eLq6j4hg7cXZOIazs9HaoomlL3Hmi3RLILF9f2u9qoMn6LQWdgDkwsCunW6M5v3FRz4GW5l1FCsho0GjnzJfg743WGsZEFABaPWXuaG1m1tfSZRaSgQ9MsHTIx7jZegT0TpwySfc064bfAtCA3KY453TKl6P4mzLj3xf5WtxsRlt43Np7x95BAX+CJrx6+b2xi7Mt+C/daP6SOGFD5fk+puJdbs2+OZJzGI4hb3FKh/6xgk9JgJWoBGQXclqE2AVmGWRJoaHKp7cjmhhm7FBrSgXzLEKkhGBg3rYYU9uMtYQrnz1Kpj4Ydcenh32qHZsaHUJT3imK4XUguO5IehiKiBH8YwfQV2co9J5M8cqbs5D2fdRHUOD9053pUtuc62Vs2Ip1+B3WL+WiIka76fEQbkYjJrOwrkDR86O76tDlbQcyptAgFHXflElAOSpDOqocRhYKWjDje/TvAWt2QaaRPLCgHXtvnBmRxJH5WYuyuIk4WIcFEfrEJm6bpxDySm+UuFX1vfb0p7waivkgED2sEN5C5sBHvRWKzwOdgeyvbpshHXfz7KPwixf9bEl7DEtUkMnm3gIWcU9MEPGZpqjOLNXoBTdoQihFv6unZ9cvJaNobTevx2njNf8GC9RV4nQs/3
 PfpIoBU9
 IwbhVpzCrOONc3HCRpxCTxh8jvzvKObCem8HK9/2LFm+/P48IYboqc8+FdIjs3RdHyliZPqeMTZtUD1D6dUDLI8cl0GgrZvnPNwOz4FHATP4txCMAwLcE7gZGwKza2mcV5Q7eHDUNP8ML+hn2JNiNcB0Hr7C7lEfon2/ypvjMcIEKbk8uU75Cx2XwdUnmZnoRqe+hUWMDIed5l1NH8mBKTY9LzomG75Rx+KPnI8wAoZ7Gc35GFvLxaLIlr0FfZeQZkAcqtAms6y1qTZz+ZbSUA6YpnNSNTT/FShS8au4bqUvLQCkmLXtmUhb5zdAF+AFfWFhEzTakI3WZbCQzqo9wiJGkeo7bVFj6e1FEO5inxK6EN07Vpm2igV0xVSFs3ySovGKOyuWON0v/AyYMJBT0xj7z+a10/bzpRHNZh8qvQkH6swrydS2PHfVFLQ4PHGnTZvu8XaBHj0qApIqseN49K27huWbT9j1P/IUMDxU1SjQhNZY5zhfRcI94NEGh4UMxxyxkpZONP24KONGjlbo2emiXhWIZB2W/NW8vsAZCD/r9t//G9rrIENW+Qbv65U9QpyWkBJyTyNwZnS79te52RdXXCsfrHyrBObYKIpxIa/dX8MUzGrvhX+LKCFM1m7GlyX4heXMRWrmO7cteN9jzDkUdGo5vUr+SDQ3+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will store a flag in the lowest bit of sk->sk_memcg.

Then, we cannot pass the raw pointer to mem_cgroup_charge_skmem()
and mem_cgroup_uncharge_skmem().

Let's pass struct sock to the functions.

While at it, they are renamed to match other functions starting
with mem_cgroup_sk_.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/memcontrol.h      | 29 ++++++++++++++++++++++++-----
 mm/memcontrol.c                 | 18 +++++++++++-------
 net/core/sock.c                 | 24 +++++++++++-------------
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/tcp_output.c           |  3 +--
 5 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..ff008a345ce7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1596,14 +1596,15 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
-			     gfp_t gfp_mask);
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
 extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
+
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
+bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
+			  gfp_t gfp_mask);
+void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages);
 
 #if BITS_PER_LONG < 64
 static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
@@ -1659,8 +1660,26 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #else
 #define mem_cgroup_sockets_enabled 0
-static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
-static inline void mem_cgroup_sk_free(struct sock *sk) { };
+static inline void mem_cgroup_sk_alloc(struct sock *sk)
+{
+}
+
+static inline void mem_cgroup_sk_free(struct sock *sk)
+{
+}
+
+static inline bool mem_cgroup_sk_charge(const struct sock *sk,
+					unsigned int nr_pages,
+					gfp_t gfp_mask)
+{
+	return false;
+}
+
+static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
+					  unsigned int nr_pages)
+{
+}
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1717c3a50f66..02f5e574fea0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5030,17 +5030,19 @@ void mem_cgroup_sk_free(struct sock *sk)
 }
 
 /**
- * mem_cgroup_charge_skmem - charge socket memory
- * @memcg: memcg to charge
+ * mem_cgroup_sk_charge - charge socket memory
+ * @sk: socket in memcg to charge
  * @nr_pages: number of pages to charge
  * @gfp_mask: reclaim mode
  *
  * Charges @nr_pages to @memcg. Returns %true if the charge fit within
  * @memcg's configured limit, %false if it doesn't.
  */
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
-			     gfp_t gfp_mask)
+bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
+			  gfp_t gfp_mask)
 {
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
@@ -5053,12 +5055,14 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 }
 
 /**
- * mem_cgroup_uncharge_skmem - uncharge socket memory
- * @memcg: memcg to uncharge
+ * mem_cgroup_sk_uncharge - uncharge socket memory
+ * @sk: socket in memcg to uncharge
  * @nr_pages: number of pages to uncharge
  */
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 {
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		memcg1_uncharge_skmem(memcg, nr_pages);
 		return;
diff --git a/net/core/sock.c b/net/core/sock.c
index ab658fe23e1e..5537ca263858 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1041,8 +1041,8 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	pages = sk_mem_pages(bytes);
 
 	/* pre-charge to memcg */
-	charged = mem_cgroup_charge_skmem(sk->sk_memcg, pages,
-					  GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	charged = mem_cgroup_sk_charge(sk, pages,
+				       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!charged)
 		return -ENOMEM;
 
@@ -1054,7 +1054,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	 */
 	if (allocated > sk_prot_mem_limits(sk, 1)) {
 		sk_memory_allocated_sub(sk, pages);
-		mem_cgroup_uncharge_skmem(sk->sk_memcg, pages);
+		mem_cgroup_sk_uncharge(sk, pages);
 		return -ENOMEM;
 	}
 	sk_forward_alloc_add(sk, pages << PAGE_SHIFT);
@@ -3263,17 +3263,16 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
+	bool memcg_enabled = false, charged = false;
 	struct proto *prot = sk->sk_prot;
-	struct mem_cgroup *memcg = NULL;
-	bool charged = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
 	if (mem_cgroup_sk_enabled(sk)) {
-		memcg = sk->sk_memcg;
-		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
+		memcg_enabled = true;
+		charged = mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge());
 		if (!charged)
 			goto suppress_allocation;
 	}
@@ -3347,10 +3346,9 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		 */
 		if (sk->sk_wmem_queued + size >= sk->sk_sndbuf) {
 			/* Force charge with __GFP_NOFAIL */
-			if (memcg && !charged) {
-				mem_cgroup_charge_skmem(memcg, amt,
-					gfp_memcg_charge() | __GFP_NOFAIL);
-			}
+			if (memcg_enabled && !charged)
+				mem_cgroup_sk_charge(sk, amt,
+						     gfp_memcg_charge() | __GFP_NOFAIL);
 			return 1;
 		}
 	}
@@ -3360,7 +3358,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	sk_memory_allocated_sub(sk, amt);
 
 	if (charged)
-		mem_cgroup_uncharge_skmem(memcg, amt);
+		mem_cgroup_sk_uncharge(sk, amt);
 
 	return 0;
 }
@@ -3399,7 +3397,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 	sk_memory_allocated_sub(sk, amount);
 
 	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
+		mem_cgroup_sk_uncharge(sk, amount);
 
 	if (sk_under_global_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 93569bbe00f4..0ef1eacd539d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -727,7 +727,7 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 		}
 
 		if (amt)
-			mem_cgroup_charge_skmem(newsk->sk_memcg, amt, gfp);
+			mem_cgroup_sk_charge(newsk, amt, gfp);
 		kmem_cache_charge(newsk, gfp);
 
 		release_sock(newsk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 37fb320e6f70..dfbac0876d96 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3579,8 +3579,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_memory_allocated_add(sk, amt);
 
 	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
-					gfp_memcg_charge() | __GFP_NOFAIL);
+		mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge() | __GFP_NOFAIL);
 }
 
 /* Send a FIN. The caller locks the socket for us.
-- 
2.51.0.rc1.163.g2494970778-goog


