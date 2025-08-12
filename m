Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E47BCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2376490001A; Tue, 12 Aug 2025 13:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E94C8E0151; Tue, 12 Aug 2025 13:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D73690001A; Tue, 12 Aug 2025 13:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E40E48E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC9B316012F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:10 +0000 (UTC)
X-FDA: 83768866860.13.EFE889D
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01F704000F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sFs36Zo5;
	spf=pass (imf27.hostedemail.com: domain of 364CbaAYKCKYQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=364CbaAYKCKYQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDZvQnGZVydzNfrMcaRsTt38V2PhbthdXRjE/tVTQMY=;
	b=GET+6vlfTXHXCkgrtVcQvC3RPzEZsWnMBixEmWnDTb7EVsNz05Jgqv4NSQNngGlbjG4MV6
	cshYKjobM9EjIVrmsEnxYwNqeQ5ohjN6jz39mBrpwny3kEZVs6lHlne0q3zppvPkFJISZS
	tG/7tKpN6SHML1EhTSDzu4IY0IApJjM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sFs36Zo5;
	spf=pass (imf27.hostedemail.com: domain of 364CbaAYKCKYQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=364CbaAYKCKYQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021549; a=rsa-sha256;
	cv=none;
	b=QyF/W/z2jB1VbE3GuL9i1tTy6CKSWN1/SKwCH9i/bMijEz7ZWrxh3TQsFhmpJ4JjVcTzY6
	ou7ML8W4f/C0HhIi9z6KcGD+CKP4XzWKprPu2A6OMAjIPm4exJKRruSZifyhidZgDNwhfC
	C7yjV60Er6Drqo5km1Ks9vVl6zNj5v8=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bca6c73f3so10707437b3a.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021548; x=1755626348; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDZvQnGZVydzNfrMcaRsTt38V2PhbthdXRjE/tVTQMY=;
        b=sFs36Zo57GPeMPer6BLp8GN9a05WF+KXv+dnBpK7f7a9LCrr+YvMp4rwYL+zEKJk8N
         s6yn8GDMCRBnSCmhrDlT+KODzIvXZIoFU7xhmebx69JsjE84GsG9+0oNzxJ8L+hajadp
         azra5P9M4/O5t1NJC3Zu7A6lisKKBY2/u6au1rdT3dUMJdRbgSXa1MW19uE5F8HS1Nky
         JsNE0bv7MT1BTJnRfmvByLbTKgM9leSzd+LOq+IFstyfFaSHI5cO2QOJE4c+xKM1dg+y
         le3LO4eY3da77LgNPobwv9n/ubTbeAbpMy1hywbaYzSP3nu/939VphaOV5Ie3lfdYMeS
         YGcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021548; x=1755626348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDZvQnGZVydzNfrMcaRsTt38V2PhbthdXRjE/tVTQMY=;
        b=pqERivbWmnBP2NS+lMr4XW2V/qqg7Ce4zeDPeSzJwXgPJEFrXClJA+Mdciyfu5lQAP
         6RlS+5DVupUoJfKwmdCi3KQgkXxHg6yil15TqRQJwgcVsrehcIwA9DlAka3x+BiBolMp
         SUxzNQ2InlnaibuN8z06zxQmVpiAWBIHmfImOcGQqMGdXlGce/s68d7BqNy9saFChH5k
         pqIH2mEh7PDLQFp5b7bL3RfpxQ3LAPP6R0PeUU5bNEgULvNlPIBUvzlJHN1V4e8XBkrC
         HNI5YSR+mfcsBOwIAbhFeTLQhKB4i2Rb7v7OkYQuYcWr0efIPwCkNBAT+SuqkBFxC8dY
         yExw==
X-Forwarded-Encrypted: i=1; AJvYcCVuManODDyZbAronoDsNZafhTMk4R6cOgUL17m5ojoADOfkilN/vabBmVH04gPCLWwhfdtu1PlGHQ==@kvack.org
X-Gm-Message-State: AOJu0YzyGw7T/rPElPniEL9Mi9RcFmANRix1QqKZsewfEmVlJPmuqr7b
	8kThZ/iqDWYOeJgKaqqFFlZexiUHRNUTXrpO9WN+EGRlLwiSRXDpI6gpP8XlgOXHgiImGnG4XoG
	NLyaoKA==
X-Google-Smtp-Source: AGHT+IFn1xb1XsW3+iyKZmwfn+yKngA2QHtbjTYPgvZVH+wir3cF1vej6qQjtTIA+51A1YmNi6bxeEKS5P0=
X-Received: from pfbhr18-n2.prod.google.com ([2002:a05:6a00:6b92:20b0:748:fa5b:4163])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1142:b0:76b:caa2:5bd8
 with SMTP id d2e1a72fcca58-76e20f9de63mr127689b3a.13.1755021547780; Tue, 12
 Aug 2025 10:59:07 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:26 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-9-kuniyu@google.com>
Subject: [PATCH v3 net-next 08/12] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
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
X-Rspamd-Queue-Id: 01F704000F
X-Rspamd-Server: rspam06
X-Stat-Signature: digkxd733zwx8i6j5esj74ub14qhkn6m
X-HE-Tag: 1755021548-969311
X-HE-Meta: U2FsdGVkX1+BEBK2Zxa8MHlNHvrunn0THDWJcfx4ounnmDrtn5XSFVfYC3UaMhfkQHqDG2bEKf9i2S+Lo2Z8Xx5FXwg3nTQ3aLehBA6A0jN1KRZBArng+d4R9q2CzaU61/vCRSoxZ3nTskgkWloV5+W9aoqfKMCG04yn65r08pkC8G8rXaxpDZ5UK0fkbJhRytHVbQCZTYS+joL2eaLIq39nOB8t9vJId4u3t9Gm3gI+8877l6KOknqCv2mxffQlwRekExuZsLQdV2rQxeStrAdXJoaMjozzshbtV64m8qHStp61oo9tABkkwijtsLVuzjq/Ae6nHff72gPnlkuwhiGDsD3cAjiIWN6uYaDoCe8awYzr2iKVXCY8CcWixVLsp/0oGqhLVwsvWHLaKUlP7g3nQlgih9qS6ImjsNZlIu/B3OrEXO5eOJm4ZtAL/hFH2JPP1mtw3+gH6r6XfwG7OVCUHWw1uI/esx6wlD4O/yLpqgkoV0Dn8B1siPnR0ECDh6AnhpPFXPkcXtDnJb0ywhvwSbdODKgnr1G0/brdlJ9h5PBdmhIj4tF0uSs+CZV0g6NKTl41Bt3Piuc2XFE5aTBsWanOKPuWJr5ni17Gw8ATwXoS0l0dsHfPPC6WyWsphv39JvuGSoOKred+9wQTyuNd2RDefi7FTce98qycUH9szVWjH9kRsknNexCROXNFFpJ8iSuneEKzln5M3ue/8OomHzvcEwvG/S9cXtElS3Bfq8Gf5oX1lCTQcte9UuZwpkOfUVxWKGODNTTGLMGJAfaM36WZBo/l+amivB5CqqBkqPuaELnc6xNnvmVN+sAfDjRTmywb46suGLK94wGje18Wiw/T+AVZYB9/PzWTJhvMjuvgd+iZjowZVcwm5/MatlT/WdyTNB67IZIYO7+LzI2P0W2XmGh4y07sPiMqeJ1FgxgXHJbs/eXTTbeSu4eu8av0ZkY5ptyvU3Embis
 zwfK3fBp
 ADR009TdNbxS6aqdN1DMP/Oxqhxk3KJL9Ksh3RtqyO3/bHd++lUJtL2iHH/sprIf9wrgYL7GSGBzIDNrI0AfTe71CQXBhPI+KhLYhmmajYBHWqLekgFIRVAr7YUSxQCXF5he6h7ehTMPGEpkXlv8Deo6sQz/Caa7LpHQkZIJwfRp/PqwSYMcSxaldkrz06zoYcyizKGRKdWGu6lw2arEmvRj0ZLqlUax/GQDcDDBjWs5rhp6bu/EQgbK9wZhE+TSAC6Yhuw05rs2k7TcHneWoyu2doB35PCSjiP/Ig8mQoEhwZePfCHCQR1xPuNHf45z+tpBg8CPD3Jogv6V2beuhmgVjv5ODuZQBPsvd6KP6AOibEPE2HgunMFmzbnUCYfwGgs9oGXRuRafnl72ASRjxbeDhoKhQwiMcl6mBGvc8dKFpZ28F2XIYCsF37FrkT3ymTpMSSm/aU1gwhsee4VwJKOvOyt0HL5geTrhZT4OdMNJt4VVJwW6f2jPn/jGVtDQSyoucqYFjHYie/rumDHHzRkUxBSS2H327GxPbCwg/4AVpNP5lnJIMVUhCRoUFSNl3lGbY+wL8pLBgTsK9ui6vWwXV4c5fTwffchO009umkl3QwmWvLr6jstCnGrgm3SQex4ALNpZA2cyHREsRkKesgyg99y2SAWC3Vb/+XMtrER+Sbb0=
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
---
 include/linux/memcontrol.h      | 29 ++++++++++++++++++++++++-----
 mm/memcontrol.c                 | 18 +++++++++++-------
 net/core/sock.c                 | 24 +++++++++++-------------
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/tcp_output.c           |  3 +--
 5 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 25921fbec685..0837d3de3a68 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1596,15 +1596,16 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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
 void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk);
+bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
+			  gfp_t gfp_mask);
+void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages);
 
 #if BITS_PER_LONG < 64
 static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
@@ -1660,13 +1661,31 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #else
 #define mem_cgroup_sockets_enabled 0
-static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
-static inline void mem_cgroup_sk_free(struct sock *sk) { };
+
+static inline void mem_cgroup_sk_alloc(struct sock *sk)
+{
+}
+
+static inline void mem_cgroup_sk_free(struct sock *sk)
+{
+}
 
 static inline void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 {
 }
 
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
index 2db7df32fd7c..d32b7a547f42 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5039,17 +5039,19 @@ void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
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
 
@@ -5062,12 +5064,14 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
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
2.51.0.rc0.205.g4a044479a3-goog


