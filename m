Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D7CC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9D18E000B; Mon, 21 Jul 2025 16:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A188E0001; Mon, 21 Jul 2025 16:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158ED8E000B; Mon, 21 Jul 2025 16:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01C378E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBE92801C3
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:47 +0000 (UTC)
X-FDA: 83689430454.23.FFA6873
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id F307280004
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pa0KdPVK;
	spf=pass (imf30.hostedemail.com: domain of 33KR-aAYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=33KR-aAYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdQJmy4blGtPG7gm97FaKmrzo1iYWfvkpp5t2qCAUbc=;
	b=ZH4N6jdOU4OAPGLY/cyib7vu5H6gCOSHlC11b9m3sudaxgi+V2Y7ohti9HcYX5CfaJT+v0
	mOEFvtfkw9i5VRlifArosSOcJpQnkTbpHOsdIqTRGP1JSH5Gh9AxxoxtAvWGnkEPXMBTap
	bFh6+C4Cb5Lx/3frJSM+AODumpkHQzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130206; a=rsa-sha256;
	cv=none;
	b=Fha01maOVzqCla6xS4kLncKooB7bXXjbMxyUtTcv+yhOosDHcaZsiQIz6T3phb0epj5TpU
	F/49I7XNzuPNsf8kimBMpN90zvC04xhgpzYJY+xEkMZ+pqTo6GRsDm2yByMevsR2+/2fkI
	BJ0pb+4CY2RrwP3JS5D9y68Gd7AUZoA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pa0KdPVK;
	spf=pass (imf30.hostedemail.com: domain of 33KR-aAYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=33KR-aAYKCGsTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748f3613e6aso2293732b3a.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130205; x=1753735005; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xdQJmy4blGtPG7gm97FaKmrzo1iYWfvkpp5t2qCAUbc=;
        b=pa0KdPVKxWBoJIcgpkgOnZJAXbsMAq9fiOMN9A82/pdUOSgtyqaNivmY13JpSY2V0y
         vhfBoNoxJPDrAq2UzKJo/O5nlVReuGorNL9djjt/yD8+zhnY/hZNe6FjXk26t8Luge7K
         QVMMLTsaifwsaOZD3gMPOeBJqmCGr/GOjvVuorAW88JfeUurT4fVH77cwpLLYLYwgfia
         ddjhi5G7bQD/KNuxn680vWkX3ePB1ZzOnKvncajIdarRYJrTaquPj16pvZ27GEIoJ1vR
         Det4jwhKBb+FDfgGMRTDX7ZXEADlZ+JKTGBITRU3oKwwU0PLMpxKfc2gzGsNoAyw/J4v
         yZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130205; x=1753735005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xdQJmy4blGtPG7gm97FaKmrzo1iYWfvkpp5t2qCAUbc=;
        b=sWH9Uw09i8neTTTRwFIazwlmpCylVA3nHkxF3G+fNvb9Dk4/U/6fSeqQM5ObGa2AtT
         GA0ZwuSGXHMe+efkEgkttimz8g29Pk6fGPwZw7j68YsMzcoORt7TRMhWWLWXKKRuZzfI
         0kW+FeoTnC7AOn1UDRBoy2HDeE+t+iMXxNv38tX8Ves/T/MFYQvysXOijW/QwBIu07/K
         vs07/oBvlj38Hl9PFjUoE5tLZdePY/wT95ejGQpoYzAECS31pxCbdZaBbIXj44GU8g7P
         4nUWb9wPngEk6faCur1LRT3D+ekZhbpWdsedl8KOhX/NJACADUkciogC6HNfP/kus/R4
         /lhA==
X-Forwarded-Encrypted: i=1; AJvYcCXW/8tGTcT+UKgDq6lvCeW5B0rHHXLGOFNtvg5XGzccDwZY1ZE9qB3YnsW7zclcBohQhREFzElnXg==@kvack.org
X-Gm-Message-State: AOJu0YxFLQpEdWy83tg3mNRBciIVDaL+Agf/9K0n9wiW7UBkMNXyhcnt
	PhfUKXH/IQqRkc0xt6PiFCQ2AYUQNC/VyMzyIzMndOwBnNzQcBXwDWnNxOFpw9M/IXr/QFXa7WA
	pYhn+Mg==
X-Google-Smtp-Source: AGHT+IH3cVl1mpYtpoQ+O+03muSwme2Q/Ci4haqA3DdzxtA/Bzy9F6BXAV1IYuYuGpbybBp0dJL0GcI6AFY=
X-Received: from pfoo21.prod.google.com ([2002:a05:6a00:1a15:b0:747:a97f:513f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c88:b0:742:a77b:8c4
 with SMTP id d2e1a72fcca58-7572267b30cmr34198928b3a.3.1753130204945; Mon, 21
 Jul 2025 13:36:44 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:31 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-13-kuniyu@google.com>
Subject: [PATCH v1 net-next 12/13] net-memcg: Store memcg->socket_isolated in sk->sk_memcg.
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
X-Rspamd-Queue-Id: F307280004
X-Stat-Signature: 8aeur9nitsfonjyiu1mxnagtzxud9bkz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753130205-653881
X-HE-Meta: U2FsdGVkX18wxrk+WHNfoNqj6wsDQNBNX0q1t8L4ZH8nDCc6l6LeMmvy+BahxH87cod5QyKsi8hsarBxF8pZ8lJQ1scXz0oDXB6pXDLRGyJurwLHgH5L/QycIlUoFSBgLiXoE4iVeTXGZkVuK1sUEmKGKMjCPL/LCmok8iJN1wMaQo8PcTcje3CTsX1ufFIpgP0OZe13zSwPsc2S77j7uomH1Xrw9+BN3p2K2cDANQXgnsAay2ShZ171P8aJZoY4lG6mPRXwb8T/5095gPr06lFZtv9qaVvdEwafaHcR9fQVX5dznvyjf6nbiYPKOcsKVMnOD1aWYvvJcVLEeTUFoglHwHLKSgWg71vzqDfE34Si6gJzUuwdEPvn84f1rXdBC77HvyulRTkQZD001sb7XTpbjXdBtIgVi0dl1d6MIwleCtA/QzHFxbBlN6fF74IlFYl+ad0GukUiYArwwFRaVT5Jui8++u4Pixi2emE0tH8A9LsX6ahr06zo2sA4u00vmntprbj4YWY6jjTFCpoZ2WbgOFMGMo1zocLoyFpMHnjQH2doFSQRxn2cqLEkUOMfkPXz/H9Wm8kkuPDulOD+2NfKbZjv83ExOBtV0jKhxW/Ky6JmVvMPobCLhefOhjSNmfYWg+PxyM+hNdcKOsZPdivgaHZA2euF+JiZxdYv/XJx6Kbdi4aCkTzLbuoYmFpjHX/wxEXR3kqHhfB15NIUaGAucl4yJs1sEOIPdqvtn9MHpv6WGLBfju11vOvMhhd2k6pL6Y3ZI20v/MOmdx9SziO7uPls6tw/hOKBrAnjTAq2POG/xIkKdCsQQayCHFB7DYN1ZGxY5eNa/N0EBbPbj2OVY88GXvJyaEkopqf16OBXXkzJnVkZE70eiMB4pOmuGFCckQj5O7mZ2Ihgh7CBQgm2cvwwVfb4Pb0R1qHIHQWlZ8zcE4ds1RHtDadm2lam3nz2H/OS1VjT8aEHquD
 yLbQ+Z9c
 xkbIGH/9DYTqOOEPSlJJgYUblFWS5JpgJe2VooDL86XEyFOmZ5O2Jk8IFfXUbdJ6gI8T3++BVCPejB+CmRyGDeTrZib7Td6J+NJJ7IXV08bEgmX6m/CfOftjiRfh8TUfyhLfKkLMZfb71Ie+ebPvMx4zUQhy4N9sQ5NmZlz07OFE6uDr4AxWHZtfL+lhrJmT6S3y6+C35C3meq4YJcfUWP0u7aHqQ5ZE00WyhEyhk61+ulbZlDR5UhmAy6Zy9CmEER0ffky7xIZWtix6A1M6JsWnTKddS0GGsQN1Q6x0yRJ66DE1dc0aS8MwZCfbi/M2TDrUxNF3jAfr02MTvQZXiDkwQ25fN4FIlB122EREn1WbY9fMTSEms1Uqj7PQY7HLbggzr9kMOyBLgdSNRvTpLaKxl0cCao+WmLPJ3WH3zX12ynujuYg6EkT7YUvb79jMrbPg9D5KaPXKQ5rxG7Pdy14DGAhliQPIidxSrihO0zstRcagDD5oIdNB/HVqegCU0SQOli5ei28KRyIgIlxnQTECMpRinlGJNXS9RbyQLdCaDtW+GChvgXs7pNvI8UN7F81xgv2YilCUBJIgzj7zZEMU7Ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memcg->socket_isolated can change at any time, so we must
snapshot the value for each socket to ensure consistency.

Given sk->sk_memcg can be accessed in the fast path, it would
be preferable to place the flag field in the same cache line
as sk->sk_memcg.

However, struct sock does not have such a 1-byte hole.

Let's store the flag in the lowest bit of sk->sk_memcg and
add a helper to check the bit.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 include/net/sock.h | 20 +++++++++++++++++++-
 mm/memcontrol.c    | 13 +++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5e8c73731531c..2e9d76fc2bf38 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2599,10 +2599,16 @@ static inline gfp_t gfp_memcg_charge(void)
 #ifdef CONFIG_MEMCG
 
 #define MEMCG_SOCK_ISOLATED	1UL
+#define MEMCG_SOCK_FLAG_MASK	MEMCG_SOCK_ISOLATED
+#define MEMCG_SOCK_PTR_MASK	~(MEMCG_SOCK_FLAG_MASK)
 
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
@@ -2610,6 +2616,13 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
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
@@ -2636,6 +2649,11 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
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
index 0a55c12a6679b..85decc4319f96 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5098,6 +5098,15 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
 EXPORT_SYMBOL(memcg_sockets_enabled_key);
 
+static void mem_cgroup_sk_set(struct sock *sk, const struct mem_cgroup *memcg)
+{
+	unsigned long val = (unsigned long)memcg;
+
+	val |= READ_ONCE(memcg->socket_isolated);
+
+	sk->sk_memcg = (struct mem_cgroup *)val;
+}
+
 void mem_cgroup_sk_alloc(struct sock *sk)
 {
 	struct mem_cgroup *memcg;
@@ -5116,7 +5125,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(memcg))
 		goto out;
 	if (css_tryget(&memcg->css))
-		sk->sk_memcg = memcg;
+		mem_cgroup_sk_set(sk, memcg);
 out:
 	rcu_read_unlock();
 }
@@ -5138,7 +5147,7 @@ void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 
 	mem_cgroup_sk_free(newsk);
 	css_get(&memcg->css);
-	newsk->sk_memcg = memcg;
+	mem_cgroup_sk_set(newsk, memcg);
 }
 
 /**
-- 
2.50.0.727.gbf7dc18ff4-goog


