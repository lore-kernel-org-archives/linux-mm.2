Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11C8CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB038E0088; Mon, 11 Aug 2025 13:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AF08E0060; Mon, 11 Aug 2025 13:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752A28E0088; Mon, 11 Aug 2025 13:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7A38E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4A9EB72BE
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:47 +0000 (UTC)
X-FDA: 83765169054.01.D1B5BBA
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 295A140002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WfrZlwTN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3ACmaaAYKCAcr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ACmaaAYKCAcr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933506; a=rsa-sha256;
	cv=none;
	b=vvGHNIozFvIx+8PGGIWX2svHZihMJ6dnBJvnMc3uI1FFsYkR3oc/1Vt/81oPhMNHAaLoYQ
	5LgBDEGaKuNtRftb+9sZwdk1PNNYw3mOoyMnUkeDlUlrxNtH8AgakSeBA/ZfCTCYxNN6eR
	2Su0t5OlO4aSDKeQ+MhZ/cZo3MNNfjg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WfrZlwTN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3ACmaaAYKCAcr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ACmaaAYKCAcr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5aWSC3VweCjbJoCLklfizXMRwOKGjiP4PRbbUtyan4=;
	b=EkuT/MbByf/wxMMVrrLOcNAbotuoBXpk3FM1W9OcKJgIJhI4o6Ja02PMtlcAjO1Wxvpql6
	vfCmvVKGYUxKRdx+jqcLFIpc6KwVBpjNBKBQuH1yF7ETQ8BVnFtPmt4UKqbYled9NeCcqz
	VkKDJH3gRgX44bQtjCURLopjKMNCbCo=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23ff063d087so40360555ad.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933505; x=1755538305; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5aWSC3VweCjbJoCLklfizXMRwOKGjiP4PRbbUtyan4=;
        b=WfrZlwTN8rPBabqGtMKbJW65YpeVR6EiCNrBdXXPQ1f3qJDl9yflcp/eVQwOQUSv5G
         HDTWzZkVg2wqOvjeVSHUkLe3ilvV0y6PaHmkn2CpM5nb3mTyn7C3iMdh+tt5NnR8tBq0
         iDZcyPnMo7DoueUejRV0kb3T2RYODUMnhLPczrFTEbpYx1q/pOz2gK7E/msPT2X5/ED0
         KE5DtI6bxCuB/ZESvk9SKIPeT1F7HPkkTCOaSOtRqMNAhQON9z549HFhqH440EzCHtws
         IONul8lnX1t8Y9TT6WtnSr0P1w7xTpy6pig+F5tWgpXojotPwWHfKBPNrIczhVC+a/Zk
         h19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933505; x=1755538305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M5aWSC3VweCjbJoCLklfizXMRwOKGjiP4PRbbUtyan4=;
        b=olaU3o6wUen9VvuiFcEv42WhjTLf7i3vX9joiT5gX+Fa3GnmZwkMAv0gMW7i2jMEGQ
         Ie3AKMaW3w+phArSPPJC1Rr1QsP1wFtE+5CnGOyrkiKAmyPJTJRkj3FkaDqw3cQqor8U
         vm2oAhwSnRYDkUdAMbLEwAUynMVkdAvOr926qsgxrvm1O59QSwsPq9lRbWI8niZ3n5Sz
         S3J3l8YHfYAzXuZpGkoH7EeqEJEyqxFK0YOS5uZ1pRSR4gGg4oCICH9pQMzRpo58U6UC
         lAAK3z52nboFUja6veAwUgBB/L0GT9lmXXU9IrNKW0mJInfiLqXzMBKyfdFuuyasr13y
         OkIw==
X-Forwarded-Encrypted: i=1; AJvYcCVBx/MjycZ0D3/XgP11QQphX7NyB5s+vU2dBVUqLL1wd/tH2K3vv4DDEjTIDHCy9vIB9LH9nwhpDA==@kvack.org
X-Gm-Message-State: AOJu0YzJ/2oRJSkUCYe3ghuWzpTf0YPPzS7e2+pf6rsoGSuMRm+pdvqE
	gQ3fZE6hMnYmTDDPRRRKZoav5VkqbKg8i75AtVZkJtKTkvV4VHOGF8xOSKDOPocnxmGlQp0RPry
	dPJ2qaA==
X-Google-Smtp-Source: AGHT+IEtI0hZmQkLl6do9xR5bq6fk+hkwUvmFCZYReLtL0+PGPBf8SbdQd0pvNwlObuC5a18Dro3jK8mXEE=
X-Received: from plbmi15.prod.google.com ([2002:a17:902:fccf:b0:23f:cd4f:c45d])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecc2:b0:234:f4da:7eeb
 with SMTP id d9443c01a7336-242c1ffb1f7mr164182355ad.7.1754933504815; Mon, 11
 Aug 2025 10:31:44 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:37 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-10-kuniyu@google.com>
Subject: [PATCH v2 net-next 09/12] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 295A140002
X-Stat-Signature: 9e39bdh3x6mxoxw734m9bwubbge7pwbq
X-Rspam-User: 
X-HE-Tag: 1754933505-886625
X-HE-Meta: U2FsdGVkX19h798OK7sy24XOCviv9Y66y3UecJVw6fpimbNIpG3M5Uq/Yjmg4/lyoXoUNIrkd3oNklspS/NoiYmBAaZwbyzt/X9dswyayEuozGaYnrId7s4DZx1TNntbF6RzwnjddVyIqvGCZIUnbu/pyY1CuVvCfF7k2P8j4tGLA5OPJ0JX/1v05gdUYZTG6N41o1kVPkMyk9AqSohgFxfvv07FTHOYd9AM2ZGUZqzxj+mWbIavAhMBcCASka6BvfTrH2fPjDpY/yjBkcIal3eJzM8DcPFUL5PKh8bITvikC/konLEYfBGxyBnNPisftumLp5hTBn1BCL0NPGeWtTWW3sWl3HocTYiLjB/MZQQki0Eeof/FWbrL4SHQRvvBa3E0Z5gwxp4u324jJBFlUTWkJwjhGOuzkRxbCjofyx7OKwIx/Q+G1HvN2gBmpuoG/dYbXloXztYorSkleQ7CIGeP1fnKF7MO3uvpwX2VX2ejZBOXVzRVZ5vSTEVoRq+tboLLq2HIWKzlpXQ/YMHVEiy1+TT9VJz3o0fyH0BC6N4aFChCWUFs8Ky5W7+Fuj/t7UieiXUxJPFhY5BwBZKQGPqc2dwy2eip5xyzIKG3hZ/TNJB6PypsekUqf4Hh3k6AVzx1t8ZCrDnV44vDfqNZd9AFoGzdz4fOfll3ntpOI/OY/mxmS6J885aePjdaFlPO8hg6iSv4//eJ6OqBe7k5PCbfvuzm1MGidMMfKR9hXRVRXM87bsQhGeijjZ5wXD9lGbbTFwFYkM6wwDqS0LpXxgwJhyEsDkIov1KxkProUVZXhqDqikLj/MmvgjcMUlCp3bNRCbIJ7tCd9wIims9UReAIGX0NoSkLQWyKbQPLs84jgzwS7WW6WdCuz8CDqxDmFll1L4m0BuXzA7kp6D+n3Iml2C9cjEXy2DqvHOaAJ++hoGWhJhQnUbv6eiYAjAFPa+kItY72f7LGYTGuzHX
 lGyK8RjJ
 UazsKJPUAoEPdB1mtAnzpMPn4fSC/lzBYLcbITsC0vCNcWQjRNlAzLiEQjoMO1qiwKVsTWFWSfeC/fN/rPMtkKbA+LfzNCIJI4FJUu1CSskYjeng98PGz2YI5RvKhKENenFZK7lBAJ6Qte7n4FOE0BoWsmOxKZBgpXht5hQWh6zbcHVLThQTjk524LARFYnFu+ONMRyme/ugYnKHDI0fnWJewvgO3DQ1jNh+UyIqNLerb30+ELk179yfyoV8Ljav/Ggg+0lVmINC8RNh/aBD2EQcTXz20C+yz6o7a9BAJmU4vNnNotn7/MHiTfb1M2xrrNJLuwaOdUFg2eEezsO8ON+MfIk6fIfene53hirjeMBZhnpr1Kd+dsS9/NmEAVY8P+1tyap7ViozOUclmXNBGFJYlRJj6xG22SksMzXk48tMj9Dz7aXlRlsCSA0OUuEVFlcd7fHkico3ao1Ai7s/qK+850nkef1PJPptCnAU2uWeRQItVH50JAkeQ/pkxOxPZPUmQCcPj5sU//M9uu+kF9mfGO/yMxMo1ycI6pZkoizl4qegx6Zk+TJge8HUb/Em+EoZpfnrRNGBiFM6+Ujpf48oUsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will store a flag in the lowest bit of sk->sk_memcg.

Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().

Let's pass struct sock to it and rename the function to match other
functions starting with mem_cgroup_sk_.

Note that the helper is moved to sock.h to use mem_cgroup_from_sk().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/memcontrol.h | 18 ------------------
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 22 ++++++++++++++++++++++
 include/net/tcp.h          |  2 +-
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0837d3de3a68..fb27e3d2fdac 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1642,19 +1642,6 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
 }
 #endif
 
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
-{
-#ifdef CONFIG_MEMCG_V1
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return !!memcg->tcpmem_pressure;
-#endif /* CONFIG_MEMCG_V1 */
-	do {
-		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
-			return true;
-	} while ((memcg = parent_mem_cgroup(memcg)));
-	return false;
-}
-
 int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
@@ -1686,11 +1673,6 @@ static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
 {
 }
 
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
-{
-	return false;
-}
-
 static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 				    int nid, int shrinker_id)
 {
diff --git a/include/net/proto_memory.h b/include/net/proto_memory.h
index 859e63de81c4..8e91a8fa31b5 100644
--- a/include/net/proto_memory.h
+++ b/include/net/proto_memory.h
@@ -32,7 +32,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 		return false;
 
 	if (mem_cgroup_sk_enabled(sk) &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	    mem_cgroup_sk_under_memory_pressure(sk))
 		return true;
 
 	return !!READ_ONCE(*sk->sk_prot->memory_pressure);
diff --git a/include/net/sock.h b/include/net/sock.h
index 3efdf680401d..3bc4d566f7d0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2604,6 +2604,23 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
 {
 	return mem_cgroup_sockets_enabled && mem_cgroup_from_sk(sk);
 }
+
+static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return !!memcg->tcpmem_pressure;
+#endif /* CONFIG_MEMCG_V1 */
+
+	do {
+		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
+			return true;
+	} while ((memcg = parent_mem_cgroup(memcg)));
+
+	return false;
+}
 #else
 static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
@@ -2614,6 +2631,11 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
 {
 	return false;
 }
+
+static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
+{
+	return false;
+}
 #endif
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9f01b6be6444..2936b8175950 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -276,7 +276,7 @@ extern unsigned long tcp_memory_pressure;
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
 	if (mem_cgroup_sk_enabled(sk) &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	    mem_cgroup_sk_under_memory_pressure(sk))
 		return true;
 
 	return READ_ONCE(tcp_memory_pressure);
-- 
2.51.0.rc0.155.g4a0f42376b-goog


