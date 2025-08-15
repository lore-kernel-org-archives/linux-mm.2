Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E407CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AFE6B0303; Fri, 15 Aug 2025 16:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC1D6B0304; Fri, 15 Aug 2025 16:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A930F6B0305; Fri, 15 Aug 2025 16:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 953A06B0303
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 303C01DBFD4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:49 +0000 (UTC)
X-FDA: 83780102658.11.992E5C5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 47C9B80014
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qW5NyLso;
	spf=pass (imf30.hostedemail.com: domain of 36pWfaAYKCN8LVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36pWfaAYKCN8LVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfW0AKjgNSELXjjoDcEX6Y6n+0gVaLsZmB/XYkuwP9I=;
	b=8cyHUlzbxjCIp9wRFkYwG78S2bYU75yN71oz/alAfRSpq/zKAT/SyrQDyo4GUsRU6T7u3B
	nGsxQr5wMfWIDEBFjAKbBTYWit2VUUsm16IPlPn70yKDJXmNfv8941yCwu81Aw6jW1dC+C
	0HHrEYgFZSVmHZ5KiMvkDjKR52zw8BU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qW5NyLso;
	spf=pass (imf30.hostedemail.com: domain of 36pWfaAYKCN8LVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36pWfaAYKCN8LVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289067; a=rsa-sha256;
	cv=none;
	b=BGmVxCU1LwzNo6loQDway0pbACwAtZYUTYOzjGNYoM/qqymyDL8JiFRCqoV+FzKC7rrGK+
	e0wzRYGLjZpeDpJ2Gn8vrZh8ZMzWfIN7fUU6ir7rgd8Evj6C83tAEJYoRcX5vRfIq7bqh6
	lAc0L0PRlHkusBuRJVDJGmM0XXjFNOQ=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso1943816b3a.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289066; x=1755893866; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GfW0AKjgNSELXjjoDcEX6Y6n+0gVaLsZmB/XYkuwP9I=;
        b=qW5NyLsoWmqaRNQ3ymWnxV5IwjNJ13eqUe4Ic1ZA/IYK4ISHFsDlfPiNzHllhC5OdC
         dfNdlbALbJquHv3R0pZ1XXLm5aE6uVb670f9LfeJgfG/jGLOR+DrvGFUkzhEvljYLN7H
         azkWM0c/o6tJN2uOHrgR5XmRA8TmSqH0vQYgli2NbpP9K5McoFahX5M2YANGePCiwzxu
         7k77RcX3WXarCc7y7kHg/zx045l7vX+R0oMfjaSP3dGQjhRaR8a1UTf3p+hp7wR4bCqk
         cyeetUBVkO9ynp6CB2OiRvGxbTrGW5Wpi94jYkCz9y2+6UKxsFSojHfQNSQucUDfxn6H
         LwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289066; x=1755893866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GfW0AKjgNSELXjjoDcEX6Y6n+0gVaLsZmB/XYkuwP9I=;
        b=r3+7pjRQmW5Z9mF0oXeZkL5RfR3iCnyWFItWLKQyEyVFJTsiE9njFdCiVrEc2FDTpp
         d+0olE2wHsAGzUnm9mM9MY2YvfRHYWimR6piIiHhRO9Ws0RwpTuAoBra39pXSoC42/rV
         p9Bqv6UBAjjEak/7mfwqotAJzUAfTCL4kc8SOB5aCYIOxnU7VqryII8uH3QfZFvD4xrG
         BfdHnbq8O0EudCUSCgHG773SPyChMy14vXhLB1vNn4Vx09ImYynTa8LHbVPiBR+NqfP6
         FGWKnbTScON0Fg7MGCOin7hDmjumV9mBnjok3A/Udatc7yGkPJRf9WYvgQZG6OJT4B9E
         5dzg==
X-Forwarded-Encrypted: i=1; AJvYcCWvqxk9rAQsimK+Nn9tbSNtrkesC8LidU3b58dAUy5td3lj804zb6F7yAUABvSthalIRwr4WmjM1Q==@kvack.org
X-Gm-Message-State: AOJu0YygkshEpOPJPFDl+tp9ioJvSThOyRaNYQmmgOvNiIFYB/RlQSq9
	pseIU/pCUYiXcIp0+BcI//YCWqh2V//aZIcGPcLgd/yFy6tkdDofLFg8GF4fvlBijjwoL1U9crl
	/zHQbfg==
X-Google-Smtp-Source: AGHT+IElDnvoGmI5tD6Ho6R2PezWL3Vx1xKjyABAEM7ehtZ7uqynZz9sJvg0jdDpQOByEtsqMjA1ed/8pGE=
X-Received: from pgbeu24.prod.google.com ([2002:a05:6a02:4798:b0:b46:dae0:dfe8])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8a:b0:23e:19fd:e182
 with SMTP id adf61e73a8af0-240d302fdd7mr6071025637.13.1755289066069; Fri, 15
 Aug 2025 13:17:46 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:16 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-9-kuniyu@google.com>
Subject: [PATCH v5 net-next 08/10] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
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
X-Stat-Signature: 341iwr7cfk473oimxojumfpq4dia5tdp
X-Rspam-User: 
X-Rspamd-Queue-Id: 47C9B80014
X-Rspamd-Server: rspam05
X-HE-Tag: 1755289067-851957
X-HE-Meta: U2FsdGVkX1+VAr8Xj2ZJqZUe3Ikt0L2OU+fc2WXKkaFr5t2fODbpiRi7mYV+h4J0StM4S+Sxb6uFP+2E+T7GPy8LBJrIR2bPfw6Gv3AVgFmp1jxddXBxYItzWsTaEpTjdIRPdfSwzkNZ2GnrjeQ9iC8ErO6/SnizqYaHWycaaIHNqB85YV5up/BRNMsqpqKDiXgglexOtJlUlAsNOVi6v82sXi806mP2bak6h1qAL+TLGT1hjp2lc23RXubRfbLBO6mUkVHeJ7+WO+mrM7R/QomfkRtskUNkWVbKG2qQ5zS6szPle/mB6r1A9iuCTS+tlqCrSiEYxZQwSWi12p4989bfWOuv6G21oCakPaNyEPBZwSg60gNFsOrHXclZso+pKGUGGZPUN5Gaaz1OmRZK2aWKntGxHMWYzzXDwFChjCBknnuNXleVKWtgmlKAEgPIdEZiJAEmYQxrTAnwtD0fMenAsKWiAyYcGdsndeeHb26YVlNamqCeZRM6OPh0tXR2iD2BQsG5uURTlMGyAoPyKdXH4wSrSuxlCj+7TlSgFH/oCwFepvl0blo2KWekOMdt5kAcTgrxRY5cpp8+bnI4QMl0vu36PoYb/MeITSOsqWbob42HBO5kAAbLr2ViQoDHAfQImnznFwA4KqI3ykNQDhSS2FDimgmCVzkSpiVxELeEN8OSucyL8ar4WYCghk3LYXjOmhbDyrOfEdEOvg9sYsC32T1oMi3QR80GkcXc0pXcjREVu/7FSZKcJ3MD8Wz9aSiLg4ttfJbuROcey7FPjbauovDdcSfiAS8XG44NIEvWakAwBhisw0V54PcJA1If9YF5btULjyDpxVsiHAlb6Ll7O9RqrG6McXjsxPa8Lw8EXelkbkEBPFNqiZfMDcJIXU4Xf6gtUddg2ER8DGW6N1uwfNMAd6yomKGGjAp3Wk55vq6HaiejFDBnnPHVWU34u8E8blIJPc5GwBZE+q4
 nASc3owB
 d2kMVOp7ntZwK4W0uzKxHX65x9qnpp6tBeJi/6Ok5GVQpm3gl0iDIQs/BYJu9aVo4l3f2rB9J964BDpGDfwRE7cgiABmCO5XYNXAAPbFI+8wG09rEXmOlTMyZBmOBLg9CJCRXPEyJNkwXgFiX2RGJ0lMm52itMw6O4fP9mDBc+TjMsL/2Uscq4k0sQe9NqtNCbjQ2LZdC1mfaVTscGDYWEdsushUS/9d4Kn5v9tC7lxRx6txfKrtLtnxXwjx4pvOnh71V9AS9W+VXmj4UE5FYRoRYa3juF+KEebXvbyZ9TqgTl0H+HSBcJoqY8QvKrlgOE5KCEVv95cqbuRQydl7G+ZnZ0C8Q3S632FSppGRVRGJ5MOnfUEvb/JmjB7zzpP2rBbbpTFMYIMBNJKV/aewovszZ0cPuZB5PRTySYFkF/hxntxcXB0Dhx0uy7x3wpT/t2ulPFZ5F4p/OzV1G/SZCb6Cu81vt1FD/DTrvLzXePLKCCGXjXF2KrWUGS1mDg4HGi/KS2maQiUa7HRXZTsHq96X43WKAWHNBDrSjborjwcNLtZ5k4Xu/EQy0DjmQfHPllfCj8qw+UBWRxgA9qrHZLoP2I1RR6OyoxS5+NEr685aF8oczidYOSaBgzg0V6mgnjzacWMadwNV1aeEM44O8jbVBCN4BoxBXcB8v
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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
index d8a52d1d08fa..df3e9205c9e6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5043,17 +5043,19 @@ void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
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
 
@@ -5066,12 +5068,14 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
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


