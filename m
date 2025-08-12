Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FEECA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963EB900019; Tue, 12 Aug 2025 13:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912E88E0151; Tue, 12 Aug 2025 13:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803C0900019; Tue, 12 Aug 2025 13:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 690CB8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F112114DF6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:09 +0000 (UTC)
X-FDA: 83768866818.03.D644D6D
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 707B1C0006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rudI2V+0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 36oCbaAYKCKUPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36oCbaAYKCKUPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021547; a=rsa-sha256;
	cv=none;
	b=NK5ST/Ze0GN9RrisU1KEdWvvp+msSvM7n7KbnWQjVFnhJNLwvPgJlWm40tzPqZc43G/gQ5
	+lQBOBoQADMig/J7W1kTPmG4Q/IHaWCSUdtZ1CacZLYi1p/PfOIxR+RDBqvTPMrACqpfjE
	QdIOD9N4l2yrSH3TzlgYizhlEjctLEY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rudI2V+0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 36oCbaAYKCKUPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36oCbaAYKCKUPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmzqnAc1jsyellKSOYCRzvGhauBIubxeUGW9qtoYYWI=;
	b=ihGGrxpOEbPAbBDX8o0U1DN9xcslv+0G/XdjwAARg8fImVOf3qs1oNBs2BQgC6ZDkIil+o
	upoTGK4cHlRhb0dSx1QyTLkNBSPI6y0pIqFH4ceKucy8H/gLnJZu4BZrB8nQ5M5ZvRyi7S
	jNOnQTNNjjx86WhEnSRlp23yoeA1qu0=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bfc40bdceso3906413b3a.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021546; x=1755626346; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lmzqnAc1jsyellKSOYCRzvGhauBIubxeUGW9qtoYYWI=;
        b=rudI2V+0H6S7+GyEoojLH0fil/739/XZjHNyXEbsi+NNzyKITFCyMXJgbpID1MlVc3
         TFHe9tHD6zK3/J3WlGAm3ypQHtuARZJnO7C9NmJOM/uX04AlJkkMmROCdF0ONfMr/aK7
         nLlBFkb9+goDToXE2u/CCwv0Nes02GHYaGjo7quJcIhMvt8nPieUj0vRFi+CNFfaEuQv
         eftUDJqmbE1UBmjhVvNskyxFhPpifp+WV/6YpZvc71uLZYGA4nl2fARvTY4GlMVBFUgs
         Yx3uz63whHFNA/nuVDAHtU7MH1rPokZXkX98Tl8TBUvfJq8zZLXaPJWxJi3/WdFLWG5N
         Yf6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021546; x=1755626346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmzqnAc1jsyellKSOYCRzvGhauBIubxeUGW9qtoYYWI=;
        b=hyC18BqUJqUA8h7c1Y9AklxHLAMG7aH3MKvLf1WPjduOyuo2/pkaMF+7963HLpFoyc
         ADy7MuoshQOD8gFr40KI2TyvvP7kLtqVh0s7/kn2DEL9pTGMKRTUQRLy0z18xTtSgC82
         o4Ldkl1JUlq8LFBWDtodJa8ROY5NUmeTwFgenj5B8fFIptaS45oJb1ksfmk80AG1OOfF
         nKiixpTO+6yDQugKQWTbYl2pWHAYTGsBvCyp1KknEGZ2jZu+1kt3vdbJv9bJbO2X3mMG
         lrhC79r/VDrADW4G3YYD4KH9SP/qhA48EKgHn/j9xkVR+gXj3lrDyDME6TUjXTJOE3uQ
         pZVw==
X-Forwarded-Encrypted: i=1; AJvYcCWmRNAwwlTKE44EVfulLIW2R2P3Y5NX9RuBxF3BfKbrXLcNA/Doer9W9E96xzHTWXnvO2hTb1SFLw==@kvack.org
X-Gm-Message-State: AOJu0Yy1erK9HruhfEFz5oC3DQQR2GDg3h1LOGaMK7sUiAD9URD8cQtE
	5WObgiNBPeX3kozJVfDpkIiXX57l7hcS81QHHyZ+jIUqfnP7idirKRWMcl6ZNsgwBfAagz+cBbq
	MsqC+og==
X-Google-Smtp-Source: AGHT+IGdZk7MwPY5BeI43bceFVbz9bcwzyVjG/myi4TvBkOWcTUGeu9X1TXG1+jvSNdfiHL0s8PKRPjYYcg=
X-Received: from pfbcn7.prod.google.com ([2002:a05:6a00:3407:b0:739:8cd6:c16c])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:887:b0:76b:f9f0:bef2
 with SMTP id d2e1a72fcca58-76e20fb0e4emr135908b3a.14.1755021546076; Tue, 12
 Aug 2025 10:59:06 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:25 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-8-kuniyu@google.com>
Subject: [PATCH v3 net-next 07/12] net-memcg: Introduce mem_cgroup_sk_enabled().
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 707B1C0006
X-Stat-Signature: x1d5xqzfpkjrreuuqmpnx6yzsq5kj6b3
X-HE-Tag: 1755021547-644266
X-HE-Meta: U2FsdGVkX18scHDWx2NmNt1zAscDE2Tmd4M0+lHsqoOReZB75RojJT8U+4AwPz3YnyyGmmh3A8o9lU/zMnoEZV5IDwYUZu+r0hgc/se0qfc82uVeAjlMo3fUj/qPbcF7CKYHp8NgfKNvKFqLyW22ZZlt9iabB1RRxYkZyqdlfjXv+dGYwyTuOXMoBlgS4Y+XC/Hir3Hjem7g1Nx3SoxKTEt4RAUSOAZ8HUUBa5SRsBTBNdiyWENESAejziROhHhHIoqfVZHOHCOOgcjgZs5QIT0hCOimUe69zoY5XSUfY1hZmhjS8FwYju2XURWNUzpzLLIvzKTVMgMhr+OfpBQKkR8+5SHbijV827k4PUPMKSxreLl4XgzkBke9hEJClrPtmy6BGw0usoL8XahYIouf9Lv8mltzM0CDwxOWL/wa/+mAX0lktShto/mhRS2t5VomvO/oFpc7yBZ+LJdIy7Kd/fl1PC81d4lxsVrbEVlJ36L3/3l6Xzufd5R+SruB2tgQOAIAQkVNO/3TNEWAqMO2FoS9PO6mRGFOeg7sHQzXUNZXo8shFOIjGZyap7aPY8q8q9E+WzcwFjbZTRA/H2JyxmN01CoH7J6E0XNrBu6mPmKWc4p4G8RYXJH1hOkaScYls4xr5Gb+5+dwUkD8xv8OqCIAdjXH4kOcY6N7Q72UTMGXEZz3JChK1/qbeyCoQVtrSIIqYbl+F4m5PgVPaoHMPeRxI3LZ7nZCCPr7orApd/YAaPYIeDN8JWqIvFav5hOwQs8wiIf3LFawCDUEoy+TIlg8aRtKNbOpDEbvNk1y96RObtJgC4G7xngq1ZqqWbKEe2RelUNrXSEVDO0HRk4L1cODbV0Ccj+nXEVv7iy7V3vcWBF4QtVoL6gPocCM02rUJL6dZ3QXCaVhp05SI2r9pp5dIWNtEI5+YG2R5OyqCbluWvD+QWGhaAyqxNC3Zhx/VkYYuNNSUnt1akjotK/
 IRL4qBPA
 Fdga6kAccq+Sy9O7Re6Ohpg4uj3RUDsU48BCsgNBxvRpN9ZFYDUdQD7m4rl0rewow7pTXRG9I7awWKxEfsjgv8jgzCoayNukkdAYcQ9MoxydCZq90mZUtqnXLGYLQHXdv/ewMu416t/mRCnbG437mQ961myLYKXCdq3gmbdjNlklBTh85Osu4WjIgu8uG4eQvGcEgflbgqqvL8Urb8DfbYkHjXLOJPsSHVwm4EmxwJVADJTk774KEc8FWPJ4c2Q4DpiewsJxUEMCUJ/cCPhL4cpffAyB9KPZ8Wh3UeoDnMOsRb06tDGGIO9yx7o9p/PCThzR0rxgRXii11b9PQtZlMnEblyHJMXJ1YzyhystAq1Ct/Ec0/tCAc81cBOrjymVcoN6uZgRNPnCGxwuX2nmevA7wtOIYd0WLGEg7X9XXUA+NmoXcSQJH728vmTmgPM00sbbTIbe86oLhSelpU/ouAYcPXBp9+S0Fn5sz1s9WoHf0Qp2OjsoRVFa+jl3JJsG9SjEqnJibGx2h0wEbZC6B7oGL1OZirSXMSd6/ByeaN0ub7ZcQ8DZsTi6jecFlc9Zh4p5IlVtlrBNESyxIfzu6V+WmYw==
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 10 ++++++++++
 include/net/tcp.h          |  2 +-
 net/core/sock.c            |  6 +++---
 net/ipv4/tcp_output.c      |  2 +-
 net/mptcp/subflow.c        |  2 +-
 6 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/net/proto_memory.h b/include/net/proto_memory.h
index a6ab2f4f5e28..859e63de81c4 100644
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
index 811f95ea8d00..3efdf680401d 100644
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
index 526a26e7a150..9f01b6be6444 100644
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
index 000940ecf360..ab658fe23e1e 100644
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
index caf11920a878..37fb320e6f70 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3578,7 +3578,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
 	sk_memory_allocated_add(sk, amt);
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
+	if (mem_cgroup_sk_enabled(sk))
 		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
 					gfp_memcg_charge() | __GFP_NOFAIL);
 }
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6fb635a95baf..4874147e0b17 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1723,7 +1723,7 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
 	}
 #endif /* CONFIG_SOCK_CGROUP_DATA */
 
-	if (mem_cgroup_sockets_enabled && parent->sk_memcg)
+	if (mem_cgroup_sk_enabled(parent))
 		mem_cgroup_sk_inherit(parent, child);
 }
 
-- 
2.51.0.rc0.205.g4a044479a3-goog


