Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AF5CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC0B900172; Thu, 14 Aug 2025 16:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183CA9001D5; Thu, 14 Aug 2025 16:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A6A900172; Thu, 14 Aug 2025 16:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54859001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9090EC07B1
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:28 +0000 (UTC)
X-FDA: 83776452816.29.03FC0EB
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB4CE140007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=viNbWrey;
	spf=pass (imf09.hostedemail.com: domain of 3dUKeaAYKCL4oyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dUKeaAYKCL4oyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RN4H8OhMESZggI/pZXAKf5UmJPFi9rM002XSMoc6emQ=;
	b=gEe/1lBhtJDAlnJvhwW2zinIs/LRg80NOl/K4IQjEAYgGOgMGbtOZ4S5d9rP7D95MoXjnr
	kfIv70+ejhSp2TRQeaYLKAecnU3HPlF0QPdV2JjwfcMF8BbUPclTgHCVhQrg+Lo5fikmVt
	fi2jzgHm1rW4K3IHL1s4pJtwSkWxweg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=viNbWrey;
	spf=pass (imf09.hostedemail.com: domain of 3dUKeaAYKCL4oyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dUKeaAYKCL4oyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202166; a=rsa-sha256;
	cv=none;
	b=gB4mMepFMmdhgbLDMwAOgT1hSWKCb8RESCqwbHuck7p3POkwp3yeIuzhxerU/4TaEuDKBZ
	O1+VSHQ24j1XWtiTXbS2M5mcVus1eoWOiqIJ72QGyx1iZuAPAong2CikwEMSvvaHvemFNd
	SuhFr8htzKMKF5xl1Q3ymiAE/jojXPw=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457efb475so15483885ad.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202165; x=1755806965; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RN4H8OhMESZggI/pZXAKf5UmJPFi9rM002XSMoc6emQ=;
        b=viNbWreysOG1AYmm6rG6GO9MdDSs2dji+AudW9p0x/pXZyOwqpxWswaQD4uykfM7wp
         x67EDZ2+OsWjcgLWxmnCPPB6lFuf2tqtoLvXXOjytJGk8+lxBNtd1QE97ULl9o1dGMn0
         iqI2Fr0wm3ACVVqXTchudjq8fMGSKTfqnB9r5LzBD6kzPv6owyQuZOSO/q0HVzziAUh3
         /fEJRbgCylwp79BOJxRaAKTjtsbkMmSuF+s+jBsw5riwiN9IdE4KdnBcC+wiAgKfd7tY
         BgxI6aQv0KpLjl4SHDJ+pn6Tmot8ESoJMoQiKwVBNKdHgpMJHMIldQRtojkft2GW4P3k
         CvJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202165; x=1755806965;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RN4H8OhMESZggI/pZXAKf5UmJPFi9rM002XSMoc6emQ=;
        b=LmzYCDczZF61FWhmAQrKkmitYyFTDv9nAnTdvMNvXXAvx0I5nadD94S/9UcNkni+qk
         cSMShDaWdZgSsFZAtthS4Hex7nuka2L/EZXTcmzIPtUBy88qhKri7qOCd7tMBAGcoxkF
         enDPbWM1Qt7lBq9V/ER1edDrZN8iWxkZ2BmRMzksHfCBZ4g3qYM1KWKDyPcdnGUfZKTl
         Ihjly8SLLrg7rGomGiJYO09cSaQXglc7GZvXap+vKtf1v1gW5B1Ms0S68RpcXHKVeEti
         toEASHOJR9QSyEoGig5ZvnKErvGsCqUDbOPkkvO/MVattoN+7A+ZuwjZyZkBDIdglMLK
         jMvg==
X-Forwarded-Encrypted: i=1; AJvYcCXjxQEL0TfQ6UfoFr195swVW9srIlLzRsYOAo9RkQ/rc62nZsQBsyd4SX7wOo8EVOOZIopDYWtB2Q==@kvack.org
X-Gm-Message-State: AOJu0YzlbIgAAOJrAtPoybkY7g+ugB4pfBgIECWeM4qA9vnG1isqWRBV
	aIqSZgN4qUyJmNDfG+9qyU3tr/2PvBDziQFbBnuxliumV1iofVes0z47H8mQ7hL3tGCoGqkWtHK
	sx/ESog==
X-Google-Smtp-Source: AGHT+IGjybKWRKb8eGBGrIqhLAFzL1Ig08nwLcmkE6zoBHcD3GY1TtW/rYf6Ml05cqJS44L2U3FStQ7jMm0=
X-Received: from pjbnc16.prod.google.com ([2002:a17:90b:37d0:b0:312:dbc:f731])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32d2:b0:234:8ef1:aa7b
 with SMTP id d9443c01a7336-24458a4c885mr60555155ad.20.1755202165500; Thu, 14
 Aug 2025 13:09:25 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:39 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-8-kuniyu@google.com>
Subject: [PATCH v4 net-next 07/10] net-memcg: Introduce mem_cgroup_sk_enabled().
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
X-Rspamd-Queue-Id: BB4CE140007
X-Rspam-User: 
X-Stat-Signature: ushcqc3rtk6q9iyeujst93a9hefpmuy5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755202166-243831
X-HE-Meta: U2FsdGVkX19N7GBVbFRBXmjA6g8RSPlHZT/AZNUkqFxVrbceIriT+o2yEkVPDcpq1TpGQZKDJz/6EV2uyorwboE4/4EPcgUZBPnjHvcOVdmMxE+KO+qDj6MCELEHlVL9MUrx9AveZXGy1iAtc0tVEAULhGvHQRYpGZI8OeDhdxc0bmN6+N4HKWdKhdEJJGPO32LgpspO31cNwsM20EQBvvby2SQhp01Hz3lxahgp7T6N6r4RofvHVRaOZa8HlLOyqcn3YAcv0rIqyrTVH+vEDIhB91KInbvK8Ly0r3WFq10wZeBQHj0i+nbUXNIzNQCpqHzdN2M4Olpc7jzI9K0m9JYpWSVB4Xrwts1KNdUkMR2GsEWSsV8OP4fUG4Ew1ofjk+CJMUzSiYlNFavnTNzbvJ2Tbc+XSFzCxW1jmJVcV8tP9WjrvAoTz7/dJ72yxxFpd3w7QGPQgYKT8z6pn9SDRbBPv5l98zdF/mM28l5/JWgFvmRnLV34e1+DuDn62xXSh/U5b6pSziUYTs5bWjflSyKaWhDDqDi4oztWuHj35Ni1k/6wF10sO0k+rpwPgk+uy9mib4bAjZ7n7dyl6zOF5kKEVIibApRECdWlCoSZf9kMzDHwSSxmsWUiS2j62/gcXhuHeok9vpm/4eN7qHK6ghF64UeBmmpviHdxZl+9pnGMP5ne9shIJ9JfNEPRxbApt/LB294NQv5Oy2DK6pnLsEiKUkD6Wp0nec2RNTCwGu/ukF1M3oUesJK7gGcHzAhDpUzuL2aqs9u+zpPrVzERUP4zmWDXR6fs/zhuaffgB1LdNoT+VohrihPBLOfawEfbsLLrRVOVKOXDTe/dXEF0m4F4XCXHgp1WXXiu5CojjLc3Km9jXeIDhZFb/gmyXV8I2gxFHQHezJARrrwi9DgTcORnHNCq36apEmAmCIYPPjuZEDCZQ7sPwhreibMomF0EU4Uq5huMGbLWRYUbmfU
 E3MyuRUS
 8v4Cp90LFxRhxVmVYNTOuwaEzV5EVu8uJTxEWNHSvDivVLnDfqym+4y9DI3RJ+NbfGl1y2z+shS4U1rfQTKeVHW/ffoE/zNnZUY273vyX+Bjs2iSpkcPMCXXBxK159bTVySGSH9JW+IjBhCNEFVjpR3wbFMBq/lDElvWUUMeTBwX+YdesdDc7mLe9afAcsDMFvs6+tbl9dYxB2avJyC2+WJ4Dc4Xu0gvopls2aL7qZ3nWmEyDvjNQOHFRmPRvDx6mCCbwFKwXwn9GhFDkGoKmQ84C7weN7pFDlS40w5pZZMs8e31RRlQSW56w2V5MjP/CsphesYwAmLcNmTRplJFHz1yJVm2q8LHXTthv4/JXCLhu4Ogdnyss1yvN0uoHd6+wqvCT2IsrE1Np3I3xkADymsSqiAMc9wiVMNp67KMQO96YCmgejIeeqq6gQwIqYJWkg83YbINUN1cbqXkY+P44HrWYIoEqdz2ZBzZOyLbkH+vILClwy98T+x3E//XB1VeWIym9ulvFuTTPjyXo1lUysroUyU1fopwhHTbp+E9Z8dZlY+aRHig8JXDvoohoVEz2cTNIt8m647CEZ/NDKZktJI2Vfg==
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


