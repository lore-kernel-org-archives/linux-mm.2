Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DDAC83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B57B8E0006; Mon, 21 Jul 2025 16:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C218E0001; Mon, 21 Jul 2025 16:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA088E0006; Mon, 21 Jul 2025 16:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACCE8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBB8F140194
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:40 +0000 (UTC)
X-FDA: 83689430160.15.A2C978E
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1C83B40008
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mKIgCjwP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 31aR-aAYKCGQMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=31aR-aAYKCGQMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130199; a=rsa-sha256;
	cv=none;
	b=U1XdlvS0taDzd9jNuFN8/NRbcAkeCtmAIQJVuTJ0g+OhhM0lkjkVyGJmFWJwzBOcO/Oqpf
	plZE1ZGqwMH1yuu9W2scxoWwlhVkl+19Dor8t5k6IMhaxf5nUpPAX1fIMi9UPUdPHQobBU
	iLB6lHv6YzCUhtBzpKX5gXrnIrirRus=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mKIgCjwP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 31aR-aAYKCGQMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=31aR-aAYKCGQMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzkCcE7y2iiEKWHZNkTKmLOP5up72GHF++8nWGJ0fgE=;
	b=XuJRJ+xRlK62gs7bQh5eqlWDn+nQjXWedP8639eFAQFZna4GeNvaF/+Bpj2c99l1HkHgc/
	sBAOw7VW2CJMurCJPGJrHh8JrrrOcznNkIXARY2gu7bL+sRsDflF3fwjDRado00hSrR2BN
	u61Xhem+Yav2c7mMhRtk89id15+UUUc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312df02acf5so5585879a91.1
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130198; x=1753734998; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vzkCcE7y2iiEKWHZNkTKmLOP5up72GHF++8nWGJ0fgE=;
        b=mKIgCjwP7XmxGXKPBhVHcoU5UWi5gKmzDJSlJ+gRh1zJx8gDXzBZG7LK7tdVNca50C
         DYz2Mp0aO0oRBChvfvXcogmWxyzy388Lruh6L+OTCfo/Ss3D+xM3ZAWDdU4oj3pwiLRr
         ARGMWnKRTE5u9vb8/wfQT4IXxXggsRm6IPI2Zh8NAvBqdO/1QrAzdSz8Yr5na3zOxJv4
         MUzOqMys5w1yVX42UbWJJghlASk36rVPDW2dV0g5mGrp6GCsHsNybuL2t1e2fDvOBYhV
         f3LVJKK7c6uYhyO1/yJJSIXkJzOAgnY4zsShNOMmOWqU6D5N6yko3YeOe/HCfY+gLRLU
         4IjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130198; x=1753734998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vzkCcE7y2iiEKWHZNkTKmLOP5up72GHF++8nWGJ0fgE=;
        b=AR8iGgSDi/W+R6R8F1J4TMy4SOaJ4yGTMue1jJSCiloHlOHXLjCik5VdcQTVurMkup
         gNYIrndKZNUB+xh1eE7zaI3OsHzpigyFq3ISAu5WqIFFNpdK6we7eOJSHY6WyfcQAVIW
         AFUn15B8hjasY0trZx/81lim5GReJhWq64cuLTwlZJOhq5ug2Jhd6Qk44HSsS2ViLj3m
         ia4TGf0CLNZHAfkM3td2Yjg0EslWuT+2lOKbyyBydBimkjnBbi43CENzjuLXoYc7fDSk
         mcPS/AsAskDg/SUhvXbwI+5t/iL1OuQVqrhDSsciS4gcIt4vuJjULD5LFARLmlegb+mr
         UypA==
X-Forwarded-Encrypted: i=1; AJvYcCVapm+Qaeg6pqyqOZa0Myv4XASTImtTJ260mHZKa7uAnk1R/xtvYOACZA8e59GA62/ZI29JDN3DNQ==@kvack.org
X-Gm-Message-State: AOJu0YyfMlRQDwwqDLOKkFFB+Ax7kczwmZ0zfxNhIiXrQkXfwnKggJVu
	m85gsAClbulKq66ceIAbWu+wUK2D9i9xjhDheKRzKOoLeQisMMb1Oc58KQ0sW7aCFfpZI7PP6O3
	jcQy9sQ==
X-Google-Smtp-Source: AGHT+IE6OSr24etnKRAVeW0ucA3S4ktB5FCi5MdQH2kT6HggNuPbZhFVkCzC2ipGvzXe9c/IyTBVfm1pHvo=
X-Received: from pjbhk17.prod.google.com ([2002:a17:90b:2251:b0:31e:3c57:ffc8])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e8c:b0:310:c8ec:4192
 with SMTP id 98e67ed59e1d1-31e3e1cf38fmr1125302a91.10.1753130197825; Mon, 21
 Jul 2025 13:36:37 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:26 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-8-kuniyu@google.com>
Subject: [PATCH v1 net-next 07/13] net-memcg: Introduce mem_cgroup_sk_enabled().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C83B40008
X-Stat-Signature: amkaw3uim8w9mk3ospnfwttfcnfe19gi
X-HE-Tag: 1753130198-449267
X-HE-Meta: U2FsdGVkX19zI+nD1alqiUW5qNrImFpQgGHtkU9csYHD9z6YQWrSqWJHviyl8rLO8sfMW4xU5FCfcaRDgdJUgcQvO9RJTEyIX7PSFiRxciUVEyv96I9C3lWBQ48MSp8gzoJlWE1HHxrb6/SIbqIb341v6vXcD5vAX2iGAPaH7VZHJKlpFC1K+5gloDwuXFYx3X95c1GiplvjkNaWc52BRfnYb/Cl7hRoDk3s+h3wDXfhRS8Wn4yHGrwD2OxCvBENHGCw8pnCvRVzdzqD/zYM5WK5qgPeegWa9HQtXHkKYjApnLhfI3b3WalOqBhkg5jxWXxbgenap7eCrDsmS+DzX2Vz92PuMF+NNh5/+cUyt2dP6/NFI9hpKXj65DwVXXcKFHwBT38UTPM4P2wNsico1kf0ieJUwETEdYSDa1CeqML5w53on28RIiW4XxyUf4Scj3EEtJTnB17unS/A8vHEQkJ0j/bhpPLnGmIXCfK9cHt2KnpnGunPUrApzXxaF5n9Gz+oaoJpzEpbn6fMPIZSgfu9/HG1gz8dHNlA3TViuEOFHGhZNxHzHbvKp/5+cAMQIYetBamwZ2wXV4mtAkCKYLV95PN8zDohjfaC+a/NjHROCn2OS4vF5OjfCOrI4Rdh794013lmcWk4Sog+Etd17u/m8aPAt9w8aZIX7Q0c9Vw8FABMlMCp3DNZwd+J4eWc+XS3IoiqOaYicKEvqeUDFxMfE8jlUNL/wyH4LEgelv/sO0tqDV8xkeEsOlNwyRMPs3Qjos/T49zLSrQ6ldTVa6yJHYwSK0NkSKeVSlqK+jLMkUww0YpSkyfV1UsUFx56/Gg3savZmleOLS4GHsJ1g41yDD5kQQYD7uvu1LtjEMKc1QjEgHwaIb8HCX7KHoNr0jjcHZWFdIMCX5+A+wiXvzd/sqxcP6eCg34+8xWrr5vqkXW0SS6ztRlZaLLiZVBmvVRc+FZlKfe6j4ammWq
 6Q4+7pki
 n+chM+p3vh5rNvlDH84osaZaiWhFygXtxGsFOmXdU7LWvmmHzcpm2RdsTd8XL5/a0lDEiM2TGvFv5CiWVg0Gg5RiH2J/trUQfwaG+8cNd+UW+S0vDvpAISl4AFXk7+Qe4xDcUp/oZCfzPNZ65x0sae9L195BhUvSCMnN2H/mT/Rr10V2xY7LbmykMteQOw7XK8gseAAAoIIsIRCcELQ5q6j8oB0oioZlBYMmq4PQoxK1Dp3/yCsf2pKs17pvvyzzMYLcptOD7vKsLrUaLCUYl/YsrU7UYtvkma/bYRu4Kf2fyzIrEnqY4J5kzd+UbFl+VQ0m10hqyobDisTVXdYu19OqakBuTrZqL+1ZiPyAAng7JATf0A1futgu4fYyzWvE05ASX+fbp15k0ukAHUdWxUpfu3pfdeRD+0DYSONDce+OKAeKFLJkAp76W9I2ApvKbQZ/fuE4mOAzeNIWXF/qur1aYN/Dr6K8KgQwN8WkoyYvtlmRpiItNF+Wy6Laq6b63IQcQ2Lace7Lh/kYIKeDASaCbjrxFZ/FX4lwTC2jOlAj/bR+kwfy1VE/8cwHiT7NfR5/h7eE0XzIKNWsQF1FV8qFdTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The socket memcg feature is enabled by a static key and
only works for non-root cgroup.

We check both conditions in many places.

Let's factorise it as a helper function.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 10 ++++++++++
 include/net/tcp.h          |  2 +-
 net/core/sock.c            |  6 +++---
 net/ipv4/tcp_output.c      |  2 +-
 net/mptcp/subflow.c        |  2 +-
 6 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/net/proto_memory.h b/include/net/proto_memory.h
index a6ab2f4f5e28a..859e63de81c49 100644
--- a/include/net/proto_memory.h
+++ b/include/net/proto_memory.h
@@ -31,7 +31,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
+	if (mem_cgroup_sk_enabled(sk) &&
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 811f95ea8d00c..3efdf680401dd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2599,11 +2599,21 @@ static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
 	return sk->sk_memcg;
 }
+
+static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
+{
+	return mem_cgroup_sockets_enabled && mem_cgroup_from_sk(sk);
+}
 #else
 static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
 	return NULL;
 }
+
+static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
+{
+	return false;
+}
 #endif
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index b3815d1043400..f9a0eb242e65c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -275,7 +275,7 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
+	if (mem_cgroup_sk_enabled(sk) &&
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 000940ecf360e..ab658fe23e1e6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1032,7 +1032,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	bool charged;
 	int pages;
 
-	if (!mem_cgroup_sockets_enabled || !sk->sk_memcg || !sk_has_account(sk))
+	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
 		return -EOPNOTSUPP;
 
 	if (!bytes)
@@ -3271,7 +3271,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+	if (mem_cgroup_sk_enabled(sk)) {
 		memcg = sk->sk_memcg;
 		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
 		if (!charged)
@@ -3398,7 +3398,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 {
 	sk_memory_allocated_sub(sk, amount);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
+	if (mem_cgroup_sk_enabled(sk))
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
 
 	if (sk_under_global_memory_pressure(sk) &&
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b616776e3354c..4e0af5c824c1a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3566,7 +3566,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
 	sk_memory_allocated_add(sk, amt);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
+	if (mem_cgroup_sk_enabled(sk))
 		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
 					gfp_memcg_charge() | __GFP_NOFAIL);
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index f21d90fb1a19d..5325642bcbbce 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1722,7 +1722,7 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
 	}
 #endif /* CONFIG_SOCK_CGROUP_DATA */
 
-	if (mem_cgroup_sockets_enabled && parent->sk_memcg)
+	if (mem_cgroup_sk_enabled(parent))
 		mem_cgroup_sk_inherit(parent, child);
 }
 
-- 
2.50.0.727.gbf7dc18ff4-goog


