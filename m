Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F6BCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8EF6B0301; Fri, 15 Aug 2025 16:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082796B0302; Fri, 15 Aug 2025 16:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1F96B0303; Fri, 15 Aug 2025 16:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D21BA6B0301
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAA061A0232
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:47 +0000 (UTC)
X-FDA: 83780102574.14.7C7CDC7
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id E1A1C1A0004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZXv0XpG2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 36JWfaAYKCN0JTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36JWfaAYKCN0JTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289066; a=rsa-sha256;
	cv=none;
	b=Y3uZdAwL6wSH/WxB5iCfsuYHarndvoZ3WFTU7AXJW7KdieBDyEck9EXbQCa3oYiWlN5soQ
	vPctZCbiPCsxScLX+JqgfDtYOqHMnXActpGRUBn4tXSq9pi0ZNwCNQwMaKrotZaeOel6Y3
	jrf4cIoR7zKMuGZ0z62tiJWYpgGMes8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZXv0XpG2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 36JWfaAYKCN0JTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36JWfaAYKCN0JTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Mp+7e2gfxyzJJta6x3bXxbo+4BlzrD3g7OeGza9E6Y=;
	b=ftVd66M1i8+aVx7wBJ6eL6vgh6mDcLlEAEsY+y9F70HUTpjIUvyyCRgfTBzbH14y/Z8HlB
	i4LfHXFnz/jykFFAHqpa7YLwFoW3Ov2zTAdP8moyil+d+HqkAEV6IrYxjeaCbETgei5jKL
	lapCC2CNY/yqRTsD0QfThYPuHoqBZ6Y=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso1943796b3a.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289065; x=1755893865; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mp+7e2gfxyzJJta6x3bXxbo+4BlzrD3g7OeGza9E6Y=;
        b=ZXv0XpG2Lcjb+fr/oY6SSOU09/5lLnII2T126+BuIhl2P/dlira1MBa1hwRdCzzapI
         l3w/3d7S1CVOcUsMBbZmvaBoEdaJ/vFl6jkZsabqISNG/8hteVN27+xRhVJTJc111wyG
         Cl615hxNhNvI2OPq985LYpBSfLw/6FgWiB8SMhGQz1KfwLjHPW3yXHUx3fesasFJKQMD
         JAMNgwyeSI/dTBKfTlnVdYv28kiL6NNN+PrU5H7eMFxl+qOPpG+0jmpVPzAlq86FsUIH
         DoFrx3SmtQAdyb/kVvaq43Y+Eb64q4jIO/b6JvgECmeqBycx/ItmPtnd6h7/hikMLOOD
         AaHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289065; x=1755893865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mp+7e2gfxyzJJta6x3bXxbo+4BlzrD3g7OeGza9E6Y=;
        b=u65ODDUDd2piTB2OJUOkxRo+/BESt7QRK9fqvKAIWrg5fFvOvRwi3B7b/o+QKaZMA1
         9V8T0uhvQIrfNfO4+laYNHztQLzghm/C7SJf+vrE/AHQgDd2CJgpupicH+S/cokfh/74
         2vL11Ly5uZP6IQ1wd6RJCgxuWj0Bjn3qKRjIByuCaei/3c313k4DUJBpFTYZ5X/zlw02
         pFPDf5EmX0X02bL1dAxVzrFZpmglMmxUoFTv/la6mIQmEnU3vC6hXw/34Q+W9f0+pzNK
         pmkl3HTd3xPhdBYhT7YWbiPy2EqKWtr4lQcpRwOTnxTrbou6/AHirXWgB6+fwk23PLJ2
         VFQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6LqMvxZSpluBIIBYSi2R4LNrUYBqVpJaCsO+4mG8UZiYa59SzNwvALZZ3g+3eA8V2Bcu3lOT1Ig==@kvack.org
X-Gm-Message-State: AOJu0Yzbp2MiIr5D+M3Pqk5v7nU26AtJXQqN3KwMYcqV+yZFgejXwgdm
	1/1rFZ84FFanI1RIlHXIL/dHsMQ9hd69TcU2i3VWKN2FMGuGfwzNqHKnxQ4gW/vIYZbO+EYMp7K
	ZzO0F2g==
X-Google-Smtp-Source: AGHT+IG5FBv3Dc0dvsUM0MYH02dugnLFfR8sX8Mh4NHngLs2eiGnFx+J6RBCbR3sas2sD1KA15Q90KlIGAA=
X-Received: from pfrj12.prod.google.com ([2002:aa7:8dcc:0:b0:76b:3822:35ea])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b42:b0:736:3979:369e
 with SMTP id d2e1a72fcca58-76e446ffb04mr3567357b3a.9.1755289064709; Fri, 15
 Aug 2025 13:17:44 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:15 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-8-kuniyu@google.com>
Subject: [PATCH v5 net-next 07/10] net-memcg: Introduce mem_cgroup_sk_enabled().
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
X-Rspamd-Queue-Id: E1A1C1A0004
X-Stat-Signature: ontk8u5qca1efm76kqrrb4ekpn5qnb9q
X-HE-Tag: 1755289065-336494
X-HE-Meta: U2FsdGVkX1+SPgpUXUY9ROizM4HaUAht6ZwTC63n5ySQZSQ/FDHkjKTHR8wXqeNNa8+I8TNVxPbiUx4HF0YR3rPgz1ulaj+YtYBVbXrG7Z9RuSCIGPgNBjslwNVhG2mDqS35EEBMvD2JUE19ycZyjaclVKLfr/B0ee+uIz9JJ+99iUWKVuEexDz8PDf0ZXLCi/zpfeqrR7C35DCjJ2loJr1YFIjdtVrmzKpOjpzMANUK0+yXjA1phjNTs+oN96umTsE+xf58SfmY3iFaHlXfMHrO8/CxkPBxdDKdbABIuacgNBU9NgkgMIO1j/oXWEZZOllsgpa+4PNRYDXgb+mThYWM7kKZfzX6dV5BGev04ZOIeZnpEvyEXgTmNAcYjtMNlMAEzKPIX4Vsjo67uQo6fpJNR4bhDURI7Z1JJieEV27Vye5pEuFDQhA0Q2OlPfr0CfP4Z2eeuYe5Jd26bP/VifJD35fsQUHWmdyoziTOIABYRwFc3KghyOnv5OJuMEWCAlVWN3KjQbiE7mS0ovadwL/C1vwKTflPQ1hfnYTFgXihewvudioar7hcANZjoFOCxVnFXxHCvUh9QVF/gSbrJTbb2Bk63ZYWZ1zaZYuu3wxO7aKh2fgcgVDSIcslmoHbfon7tE2Isoy/AQdt1lx5cV21FeWBCbha4vf8ycapGv+HUz2+A9x8ixsCEaayC+ho6h3aplPKa7cVw0kpdLQg3eQCG9+hHg5UoM2eiJ6AOp96MveqkvUmPG2GSd04avQMFaX9q2EDI78ejz6SiRm5DSW0oXBIIFfoWKJi0OOiN+kXKr1jwIeJkZcPU3wT9js3+swZKApD5yqklzkmHuTCTxj5K1mNEtxoxR265eCNUsEsE5pvrE3dvkeLDz8iiNL9E36Ee55Nnt8evngVlD7H8Khkv8bfXbuCJQZzmvJTcneyLHJNmq7oCIsMwPgN4xXsB2+6pDZd4hGMynNMFQv
 5n8yRqNO
 2WXS8wB4V/vbXO+MsuYrCABUgExcusqTYJSo0TuqNo9pQvyRO3ItzP0UDzN28kG4B0qdNayur4P5ZicqYGHutxldCN7P6bahSwr8Kdnkue9/XkZhlJL+N2O/gnk11RhEOiHmzXFGnxKo/WzXQZs6/Ksd4AX18HU2OkCowZhS/Zmz/1jl8/dTRJXvh8i35a6Sx5AExcNyRN2AizbpbPnMoSlqGhRwEayDpa2RoQlhs1LLecvxaEHPt4ZtaRxB2N7WBJBC2Mwv82cM0AjV1qkTTVoA1aQs+qrWNoCLk+8pB2qYcDB9P8oumcqbJrxlanBZ768Zm4frK3EKwpe57EaAVwECPimvr2/VniWQ0OSz3oPJndEvZ+8Mu78UaU3n9i/nHrgNdwEVV5Qy15klEnyqEPGiuTduAYZsJXI9s2jDd+bGdBw4DVEV09g5Dl1ZHULs3+306rimYBwZX5daKnKV4Z+scPOZFSzM1VGAik4xdCmBne631SZ8trXPjpsH99XcGsT1Pn2/I66qgLazZ/E4yprTBsb2pQPDa0ysKtGx2JuGzKgTB+nEQ0R5P5114zehq3SS+wKz5com6gUPhQ3pOr0tCKQ==
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
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 10 ++++++++++
 include/net/tcp.h          |  2 +-
 net/core/sock.c            |  6 +++---
 net/ipv4/tcp_output.c      |  2 +-
 5 files changed, 16 insertions(+), 6 deletions(-)

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
-- 
2.51.0.rc1.163.g2494970778-goog


