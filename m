Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B2CCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1A46B0304; Fri, 15 Aug 2025 16:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53946B0305; Fri, 15 Aug 2025 16:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AF36B0306; Fri, 15 Aug 2025 16:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7F736B0304
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E321137ADC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:50 +0000 (UTC)
X-FDA: 83780102700.09.DBEB42A
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id A334B14000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=epMuWRII;
	spf=pass (imf09.hostedemail.com: domain of 365WfaAYKCOAMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=365WfaAYKCOAMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQG0GMWGg0EW29pjW9cSPQlAKpK49JIR3c7s4HvSqPM=;
	b=lOfclxDicSgdiWoNl9OIU4WkRmm1MI8rLyjGYRwLTb+grbqcT1mC/m14vIB2Tx9C+lowps
	onp6hq+lzLtAtY8BRwSFT2EfeanNsmIajdfGePb5orLrKBgrQ9dD0R7zKVnsvVpHPx3DFX
	k2dc7NpJgCUwrDgaq0jQMK1j6ZTlOVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289068; a=rsa-sha256;
	cv=none;
	b=28FgKbteoanGpj0n1NV3Alu4HyHvRr0E7PK1yRzvteOhWIRAw7VbmPFf3sUvkhBZNSZz6Z
	IeCBLyS/CEc0ssHOImJ2JEnNwM9U5O9IL9LFT2b6HkPEv2CVnmVq0ns4VIYzqbQ6QRW4qJ
	7+46baf7uX1XTfzW/qDpdYbGQo6+SCs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=epMuWRII;
	spf=pass (imf09.hostedemail.com: domain of 365WfaAYKCOAMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=365WfaAYKCOAMWPKaWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76e2e60c3e7so3681300b3a.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289067; x=1755893867; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQG0GMWGg0EW29pjW9cSPQlAKpK49JIR3c7s4HvSqPM=;
        b=epMuWRIIGnPXgF68rCUbjVi48RqTOLRD4vatvJyynkKhaFKI986UX2eHxNqm/9unr3
         dM4bVGGVwDWZe3bOQwA5tqC4F782PqxnNOtW1gBXP2W7tRPUSeZj6eFMU2Phx/npgD5N
         6o1TzKF15Fp3MgAs58F0/AbFHWQhmpc+vpbxWw81sh/NikPUOv36NQctuadK9s+K9EWa
         avr4tMhenpURYaP6gBvKZG03hWPlJseh80JmUFDOtIUqufC9aUuVnyh2mbj/dBG9uXWg
         aO4vAJ/BS4k1YIaLwKhqcMzhsCKJsQccTipHnMIeQ0/MMlkv8X/EG60d2cnls8+oCliJ
         gAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289067; x=1755893867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yQG0GMWGg0EW29pjW9cSPQlAKpK49JIR3c7s4HvSqPM=;
        b=Ei/bsGktZ5YjoXaPxMlfLc/Xl/V3lJHMh1K7aAhLYbRHCXx+Yl0ZZ/0al0Vw+BEaxU
         I7tb/hqm4Bwv/rMaQlfiHmwFIRzmftmmWNMeaz/udb63J2LlOQ+JW47Yc7uidFQq+tUa
         zeukdoZA19ZjCyZ2CfN2gLcEStKxwZ9H7JUlFCCcvE09vlRQPoVgu3HQON8ib2x70qdE
         QN2WvODJQufdNn9UyvuWbpmG8dmXvSbYXNYv5UAD5RDlFlrz/mVzU35Cub2tIW7VGp3d
         oqIm8TiiSmHS3IAecQKL5ifKP7tujoMJBKkVG8iEClpTd9YupNL+T48JRzsk5HIztBvT
         rwlA==
X-Forwarded-Encrypted: i=1; AJvYcCXSly5skqMqQQpOzgN0xoSo7sdsVcSr2wgdRD4zB8mkkuIihFJLcvYnuRaGidQsvmb6d1A9HdIxEw==@kvack.org
X-Gm-Message-State: AOJu0Yz8XB+M8ckm6Rkosi+URTa2lEy65aivMcdr04KH3M8CJSH3Pv4C
	G4fHoc3kz9HmoFfVdO9CBpHxkSrd582ayhbyRGxuMmeECOUV6HEFy2zoBpTDwI6jKqzXPLejaqo
	VU+cs5Q==
X-Google-Smtp-Source: AGHT+IFp46sq2D48DZO0gUoHI4Uo8szEk8EClj8DpiFjSc+NkMZfkRfKF8J0RyyXgIbY22ezjmDiUSSBttE=
X-Received: from pfbfb7.prod.google.com ([2002:a05:6a00:2d87:b0:76b:b0c5:347c])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:88d0:0:b0:748:2ac2:f8c3
 with SMTP id d2e1a72fcca58-76e448632b2mr5380061b3a.24.1755289067566; Fri, 15
 Aug 2025 13:17:47 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:17 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-10-kuniyu@google.com>
Subject: [PATCH v5 net-next 09/10] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A334B14000F
X-Stat-Signature: 4zpnwymkrdu6o6dksz5s5ommhoszt5p9
X-HE-Tag: 1755289068-304476
X-HE-Meta: U2FsdGVkX1/LxuAIiluVvVCPTcNdvOwQBvSeU4w1ulzz96xQpzYKN1njY9vN3VSNh/oKVDBpErXp5/d0ClF+dFjaQ+LQKnYeRGEIbTLRPEPu0Rxo79SPAZt5uehCWaMzu6Pe3ris8AXIiNRj1cVxxyW5x+mX1LRNM0oZ+SKkLj4DwqwHO0JCn3kyzy8IhE/e/YYqRgTg+v1NcJd3tyDaSsLEkixQTacJoc3fe8MIr4W0RvrME/nKi9KzdQUcJKx9GCV4JIIhzbKh9NpiwIEJLd+QBKlCG6/wnGkZEvybJ/MAMnTDwRI+jE26V6UjSqvmF11kEZTnnfXkyyImF4hTUbPPUV4SKNLbAtIMTns6euOefBPj29xCavKuZCnQyG8ba1xtTDMRo780adYLc7Pw5CJMYokrQbsFseymvGRP8HNZIKOH+UNFwMRElWm1mgFYKSzNhXWnLvGTwkr2FdhroA/XVvhMAQGFcxHMLgcCg8/p3XfKCDVtZZ0FMKQAjhNvRwL81VJdthXgienPCvo6HGgcmhH818K3YA+16jckNQLQn0yTfeAyid+7/oQWHsyLX+ojgNlqbwNKmXgiQmvaaGEVRUGnjvCbox+CgGPfLzG5YZtMknAt016ZgVwkEf+FGVDu4YrtgDZ2fwUVIdxOB+On0kHHT2YZfU7xPZo1uSauDCd6b/8mF4j8LkKsAsqVKUS8TQLzFLPWr6DO//NaPc3YemR0fQADz6iV4VEum3D7wRiuF4x9523+VTnHAtC4qWdtoDif6fDcQ7/fb2AKi3FefwSFNXLKWBxVqwoBbMlpa/EmOUpSl6PeRXfzFqobkwz0tMqZHETOQUrT4FhDmV7lPR+VEr/7KX3MGIenAmBHqGHzZrwtBwGDYAW9mk/jQg+YXiE5SDwKXEo9OzZ9eplbx9jp05WbKLT5MMITS320aIc4Wk9mpz5Bfx7rSDl36ISRj9kvKlYzE2Ue87B
 3Czr03PX
 DGOdiQwAmKoFekJqM21C0pSQEbKXVmFkWyolA+3zJXW7+f9d+pwci2GA7Q+cQXW2kie7RIDQybwu6xljGLhqopg8H8OW0aF5DG4Zyr9RMSaF4AaMzJZiBRrSNnd7ewaJvVd1Meo45Af+PYfBSEbfPLdwfilSFPDmNgK+zUleoKFVRUi2I6aQJwUVcGGK4pTq2SHJv1HDy519cpGU4mbi88CsWTkilYXj8T5wvUEDlqQlepboaRtCHDvHQIXsJpV1lPbJ7jd3nJwYYpDJvTf7iC0nVatHXDSmdRZM/w5c/omeekBpfz0p36KA0FES3Th29e8myPz4lrhn9DCpHXNfrYHRvPgvEGBzb7/49L4kTG1ojhnYvJSsEPh8VEXCw9xVvRf6D1vg4COk2HXvEf+/hfQOZdP2bVflEHWBzUZ1dyd+XiQr8zIxScTx+pKL9RWWR5VqNcVMAqWV6VxPMkBB4pJQwwFI0G+l8U2c4jYsSjn4kPKGeLvgjLSXUQXklw5aEXa9SHQfxKDeWfocoYa8zIqJMPZUdlTGMT4gKGLOzfFCLFuDTfZEPIM2FyuKm98wDfzdgyiFs9JGguCtlu+1U0PHT5w==
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
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
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
2.51.0.rc1.163.g2494970778-goog


