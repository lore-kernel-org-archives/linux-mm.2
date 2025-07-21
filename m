Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E98DC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B9F8E0007; Mon, 21 Jul 2025 16:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B758E0001; Mon, 21 Jul 2025 16:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6617B8E0007; Mon, 21 Jul 2025 16:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5314C8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 207B9C01AB
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:42 +0000 (UTC)
X-FDA: 83689430244.14.555111B
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4E109180006
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="s/9en2Oo";
	spf=pass (imf24.hostedemail.com: domain of 316R-aAYKCGYOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=316R-aAYKCGYOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoUvWeKsVeVx1EY4fRbQ+6aQfQTe9Vq1LkXAKDABLBI=;
	b=fy7d0h7eJoiviuJQxSeSYM/jp20y6h9O8lcJop/y6eVRPTZHQ4esGYIlclahZJT3fyAa2W
	Qa3Kq6uMRhuztSKgRBQRbODkMDfRhN7nVpzLEyvfmNvNTZ7u6nLZWDFgrQFnI1quPqlqbk
	VIUd2HD1VW/73HTE/vchOkBwUmzLCQE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="s/9en2Oo";
	spf=pass (imf24.hostedemail.com: domain of 316R-aAYKCGYOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=316R-aAYKCGYOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130200; a=rsa-sha256;
	cv=none;
	b=HdfPnCntDw9wEYIFiHl9Izsw+2uwV2k034g6iRHuoTxFj7ucG9E9BLiflEkRbXA9SIbd6/
	MNcxJdL4sEdEYHN96lul7TjkEapxhQQ2UKqCO5sXGQisG858zKQITTH+hEN7xrA/YAHaRV
	VBb8JgkKskMx+ZyFWULsyfZ7uKqwbTI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-315af0857f2so4350423a91.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130199; x=1753734999; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AoUvWeKsVeVx1EY4fRbQ+6aQfQTe9Vq1LkXAKDABLBI=;
        b=s/9en2OoSCZul7PKuNXes/ZrfOo4h5Kdc1NIxcn9Nbj3psI5rEZEbMYCsfFbkeUmpO
         GXMjlSdpg6Mr9PXY28Q8fUVKFVBClJ+OFa82jZMcWCEiPyEdSffrYfdAFn/YXF42wq8S
         yz1XLn261/pqSTl4uIi6wAqcgXPUK9CO9ZeNF0NmOwVP0hxpjTR9BKw/dEoU8X7L4jTb
         lpvm7929PpHH8JxZlmn4ivHd8VC3Ir1bseAoMm8LOeFT47FGvpLXQCT16Noz1yIGdT9n
         l5b/+KYDPqBN5reZk3FZLbWTFMGHGhWmL4jzBofhpDiee0O4gUX5HW6hTtY+uL/iGGNW
         YvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130199; x=1753734999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AoUvWeKsVeVx1EY4fRbQ+6aQfQTe9Vq1LkXAKDABLBI=;
        b=rlZP8g0TUvTbemkiknS53je5SdW88FLmkYAWdRvoAA3VslDoGdiR9E+NGvOVZ64S0c
         OyQO2T4OswzMgAd+MUrU2jE/Mj5bvMw/8Ro+gEnztfUiG6T4GAZVGNV5KaVa8wp/LYHL
         gpvwjTnhdzzUCymhOT8wRG6yeM8T/R8W3Nv2r+vUfd4eVgfrcO5STtYmqtfIBcFydMYs
         2R54RFozoTpApNfNlZfYEGn1CnYp1ynGlROHIrseNj2MyploTZsKlcPW1yKmuU9P9CrX
         EBn6mOBeMqOuVmTzEWW6sUt2y3VrbkLjsUR8+/viCPp1o+GjNZ49C45H+Z9eQ7B+Ci7K
         3mVw==
X-Forwarded-Encrypted: i=1; AJvYcCU8W8iu0rp1J0/XkLOtafu2opUQuAJ+VgkTh8nkB+uBL/fSoV2YA4fpsbeZ9QtYQdmmLo2XUOOCfg==@kvack.org
X-Gm-Message-State: AOJu0YxySIYcAUwitOIuW6cR7D0oMVPYOODb08+316HUapXX5jMhtet5
	FL8fUCPOVqv9H5oZCacyYJ5jnBnA+B8nsHt4VFhH3AhgTPbF+eakz+aTdEp83yA3mfJ7Tk4VmGT
	vT2xHKQ==
X-Google-Smtp-Source: AGHT+IF0GEZfGU8amzJJ0YhldecloQOnsxr/9oopxqYyUHJO4PqIqFZMmRr7D3sidRtGioBbSwED02P8YQM=
X-Received: from pjzz15.prod.google.com ([2002:a17:90b:58ef:b0:311:ef56:7694])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5385:b0:313:d343:4e09
 with SMTP id 98e67ed59e1d1-31c9f45e1a3mr25469971a91.3.1753130199131; Mon, 21
 Jul 2025 13:36:39 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:27 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-9-kuniyu@google.com>
Subject: [PATCH v1 net-next 08/13] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
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
X-Stat-Signature: 4ewcaf7krz3nfx9e9ihm11p3g4tg631j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E109180006
X-Rspam-User: 
X-HE-Tag: 1753130200-310015
X-HE-Meta: U2FsdGVkX19vaSWwdfe5P3W8zsuc5C52WDzSNfVCEw34wPNVEKqY8zAMPXtLi2eVArd8lzdOe3Dv0RzHPI2j67QgDPIYQKLDl+m7vyjWaV0m2oK4OpID/QiblAHlKIyOpRpwH8WQ5lUtc/I2PdzmETei3hccBCTGJvpB8LU6L/XzSICb4j8CnY8LPGoNqYu1tWpJTi7h/HWG43d9FrumsEMpVbaqIKjSUi9t9t2hznPYSTuRdhaP8NQQ0ELnEG6XbndoErdV+M1BWPOMdymvuuPYTZ2srjeL41RjSsTMpX5nxXQotRvgIxGFQoAqJlUrK0AciIIIHYR8c0ofs5K6z7bxZY3CsDqubVx8vm8u05RmiuAZ8zrD6IWvjQudBwfGhI8sxoqh2at8IWfr7dZhli1DjobFe+cFl+aKv1MNNXpw+HNngImN/XIGB694NPjIUa4KGiVUZd7RUZsPk6sZ8cVKfJLpDIh9m2MbLiyor7BcNfpIAFJsCRVe652lU6P0SQft2gpVByrTcra1lB4V7WkFpoYp23tvk98vF5xYn6Ctl8hix1VGSdzOvsJulGTMEMgzjlkhDE63cmHgaC7IxXuRBrk1d/xzKHmzZ5WZ9CeKjTOzFNyMLGUthvPbrO9aU/mrMe6Y+aOPx+aZ+QuPk0/uuwIlDv1o8YKhH6bcgtvH7JlkDuhs/AmdPHLzW5PgrZy2BuyXKm04JB9MrrFhX6y9EQh6b1jsmjy8ufebuYyqdnSI2c6Qcc9WRXNhAryEvtfTNQzIj3ycCkfB1kyYD40ejTrHLK5MJg7b7NE8Y0tgYvK9ZCkusY66OWJUBBtOqMzCih1/GtlBr97FzuWpAYuBkPehnGOLP7IriRDeXX4F7MhHWIb5co/uiEbWt/Y084oBFVzTfLrjnFFf45CkfGlhumr/mOxc/yR9gNyrygLSlBNCEEmyH9FFTyJD9dVKBut+e0Ruvqer2rYiRs+
 I6LGMpGg
 BkzDALxJxQYyebWzDIH9lbo+RFko/9UcksaCk29L5zCAo5qS5XT7yJXYQPokRVY8ubjJ02Ikjtg0cjuH+34oDXiigHoGxSkr/SHkFN6oovXp8tg7XEnKu2e9q+udkcAo4kq5pPiI+9b6OKIUTGnGgTrQ/Ak2pMyDAcx2eAIlqPE3oRhXBdRyoariK7U9pHZmgrQ/19o2xoMiO0vHPw7wUnaKsrlAAI9DJwm4qg/FwSJwFitRsmbikYJbuhi3oleCtyTz80lH4UrrBGpHWOqb5aZrRsCtZZCwQXZAlLRc8ndo7PceqAeiMY5+kVfgCHwFFCEop2OMxQKYj5QfY3xPtnx+EaiQCk86vXABiWHuautciRxMe+PXAl6eE3Rvw6X/n9NyyKTjmYWCPlSJegw/WcAgBaA/LURw+C7wst4reDrXktH+VuOzW3slV1Xcp4AJw3oqLom2LxAhJzM2K2odXpd5zKB5BPU2ORRi9KiWQmcS5pBZupSWgndEVJZ/Q4lIBAEpeaArcwIxpvDAzaO0317a+yIzsw9jkjSDOZ0WRsy5EBTZwn/p6IY6OtwO71K7+S1nebbiEVuQGGsWE0649jRqfb2oX6BjVu6wMlDzX7vnL5yiERUwkHt8ldslVLA820M7eX3WRv7tCPWnzjUu1wHU3r7fmeFLZDGGs1MbLac/9o40=
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
---
 include/linux/memcontrol.h      | 29 ++++++++++++++++++++++++-----
 mm/memcontrol.c                 | 18 +++++++++++-------
 net/core/sock.c                 | 24 +++++++++++-------------
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/tcp_output.c           |  3 +--
 5 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d8319ad5e8ea7..9ccbcddbe3b8e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1594,15 +1594,16 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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
 
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
@@ -1623,13 +1624,31 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
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
index 89b33e635cf89..d7f4e31f4e625 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5105,17 +5105,19 @@ void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
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
 
@@ -5128,12 +5130,14 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
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
index ab658fe23e1e6..5537ca2638588 100644
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
index 93569bbe00f44..0ef1eacd539d1 100644
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
index 4e0af5c824c1a..09f0802f36afa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3567,8 +3567,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_memory_allocated_add(sk, amt);
 
 	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
-					gfp_memcg_charge() | __GFP_NOFAIL);
+		mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge() | __GFP_NOFAIL);
 }
 
 /* Send a FIN. The caller locks the socket for us.
-- 
2.50.0.727.gbf7dc18ff4-goog


