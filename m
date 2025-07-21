Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA9C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56BE8E0008; Mon, 21 Jul 2025 16:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0718E0001; Mon, 21 Jul 2025 16:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5728E0008; Mon, 21 Jul 2025 16:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 960788E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 650C510FAB0
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:43 +0000 (UTC)
X-FDA: 83689430286.01.D86C1DE
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9BB9E20009
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fZ0MjshQ;
	spf=pass (imf03.hostedemail.com: domain of 32KR-aAYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=32KR-aAYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8n9gDKu0Z+DKg5LJ3hwVCmIJaGqgWwDHBafRHDkb0E=;
	b=5URXa/u+hnLZiSvbJV7K68hEEWY7KOjeWhCoRsy6X0uXnLaA6ZMTpnpWFQKRLtfEqwhxbJ
	4Zt6N33vtT39sZZHjNis61WpwXOMiR1ujghbmGSqd9F0egtZGWY/15xFNIMalc4XCPdj3G
	SevtKpRQM0GZRJsEGl5u+ZthHTabXX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130201; a=rsa-sha256;
	cv=none;
	b=4THOA3paNRRb95G7FySNz/TFTDK9zVm+iGxL4QNpD9mS8WHtRWHH23/7f8vT+Ykhatmvix
	tWb/hQFosKXaoIy0NHAl15NuWT3I2GY4uf+KWF2WHMUZml1usaVHPxFe8udpvAnts2UpuI
	dARpkAXqGQGz+rXNNjzd2puZ7t9xRao=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fZ0MjshQ;
	spf=pass (imf03.hostedemail.com: domain of 32KR-aAYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=32KR-aAYKCGcPZSNdZLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so4826823a91.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130200; x=1753735000; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y8n9gDKu0Z+DKg5LJ3hwVCmIJaGqgWwDHBafRHDkb0E=;
        b=fZ0MjshQsks1In+NUmROlWH/bOOfnbO0FUbfmPrNPmLw6fgJyodBDSQMqYB4wJyHeJ
         crpmrBLIcJuzmEhG39uBuOFXZsx+oXvxc8ieToZudT9LH2EXDH/w/85RmpPaSBWnCF+U
         wwov7SDN0szAAVm6ChI6+yMO7QEO+3+RNKrlqXQ3qdgW0eSQgCf/NHrxFrfJx4DgpJVv
         9BwP3pqYuKJkNCB85IFj/SUqQXA+8Eid9C4uoyp2nrh0EeOS6CGHudxADuy6icB4dfKB
         ZLZFI7iT/MQM+bVEeAH2Vr6iBfJLHXRsoiQn/jAM3NbY4KHr/LzmAa8A8pTHIvPe6lDN
         uHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130200; x=1753735000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y8n9gDKu0Z+DKg5LJ3hwVCmIJaGqgWwDHBafRHDkb0E=;
        b=q8XOP4eSpvhJ0jher2woy1OufFg4xWPQ+APHA+ETJj1NzgyJ1I2iuCKi38frObcs9V
         eAm8V43YU7SmxLo9yKpoFv9EkG+L1FsOdkukkN5vwT/q8T6hx/enxA8rUuAcr6BWkRDJ
         qz24QL6HgisGJpwzitjvdOrPBTDTtALdYSgBAnuPfQC61B9phXzQYQXIb75+x1qb4oI8
         rSSBgCcwKqYmJx4E3/lp3U/xS4ibav7i1ZK4v1E4TGgFf8i+4BOEqfL8r39hBAFKUBTM
         3YZ0TXIgRDoguAwr1j+v1ojQ1FrwmbHINUhiQR2fOMRxhe24R/64iOGxTZWvG9GjWNhQ
         5Ptw==
X-Forwarded-Encrypted: i=1; AJvYcCXe79Z0HyyKCofWz2/dWxCTH26JIPSPQdVKfeFFkkcDC8byftQW/sIwejOiN37Vd0+o520ufS+woQ==@kvack.org
X-Gm-Message-State: AOJu0YwNQqcE8FudeY788hnMrSZqdyG2DPmCn/aUTlBLh9ix7lle50p1
	LLZPRZgrrOJ0K3EDwWN3Npi0NUAf/U9zN6dAnLQWK595SsSYky4TxscFozo/UX73iwn4u+mgfF2
	ldnm8Uw==
X-Google-Smtp-Source: AGHT+IFqBDBMTU4J8DYFBRw9/E8jIm7feevzb9voFXceLD2erJ4yjibft5LsmkvUX4Te4RL5m3uzw1eIikw=
X-Received: from pjb8.prod.google.com ([2002:a17:90b:2f08:b0:311:a879:981f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:544f:b0:312:26d9:d5b2
 with SMTP id 98e67ed59e1d1-31c9f2b5292mr34202138a91.0.1753130200564; Mon, 21
 Jul 2025 13:36:40 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:28 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-10-kuniyu@google.com>
Subject: [PATCH v1 net-next 09/13] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
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
X-Rspamd-Queue-Id: 9BB9E20009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: j4ecsgfktdbbmxj36zzujmd6dms5pf6q
X-HE-Tag: 1753130201-285925
X-HE-Meta: U2FsdGVkX19Qm0Z7wivpri7oOO4LgoXcMyKM1ExjGxLbIaTFmRsPPBRwQIdqceo/MOBHCZziEdJ7kJhtbpXyJdMTU6e4Q7ijsVsBCxMgvXOXCdrcZOAVm0o9zSJoVVdyKMRkvA3eGBmcoavTs/VNxOHdjjeIXwzrE51ayzw+ajtqjP+acnTfwxIDPbXppllWXT2iiyBm/XuTylKCHg5f+jD2sGq3CKBBnOZiGTm2Yg1DDnQgo7bfGzHHsrxNxGUBJRybd1hE+IDsp01TNHA9zquU+FhQvEj4aix4VIvnDUe50oRRo0wb9vkeewJXvx4EHwZFbdsNQ5QskR7qgBxF4aS3AIw9AY6vQJzg4fEwdCJu79siv2oOKd453rDKuJtYXFPwIB8ZOT4/SNEIDli19zN75N/OO0fSHzPo2RQS2w+lW7nhGHnEK9N3UcNQOu4lyOJJMFpJTc1+Xl7RDQ1igoDa/6ulxtDBW66l/s1fAIm24pxvNJ5tQIDn7PCU80J7SuP+nAuKlE6yH9lnEPHICPOpAdPmHAjMTUt6NaLhGqLDpSDqgGDlSMpcVrapGpOein3bSg+mFmpulPx2DoIadu25RUj6LuxiAIAPMCdC28GQn5GOePd3EjzoXttB4pvqCaDvsKIprLaPwtsmu9N9i7+BSHEWewJ8qdoo2+EbZQm94AAwHEPwgKwotczPTZmSezpdIoql0/FbyDerP6USkzmPOOqt9v4Nkye01OeWCxN+0wMY3xv343MOvmRolrXh/eJ6eLehUdjI/yvuExbPNhZC67g9MilJkQhWkJRhemyJljsIG/ovbtK2sIfwKZEAr/HJr37JDHnPdjfFqy1GWMpRS+4Z3vUb5FKBdEtm32jItpch4CnxyLUUsSKbCS9wwDeKqkwC+EW7pNm9ua7xrbeTFCjVLl5SbjHAtYlLTebTQ7p4xaMvqxqQc/xO+XCEDCs+jFEd5NviZoJTktT
 3ziG/HiK
 S3T4teWcOcOHh6h6NbypUyKv1mNYpiAd7hz5FIMslRGqgxEjxwWHLsc8xwjUoMvPKZl8gcclwJbY1bAURFKN5q1hkHR+bGeGjbGuEtGj2sYhsRlzVfAMwmsQXL307phCeYjXG3Piny4sQZihPMNCnvKXtbz7rdNvHKDYqQHUjUs6P3olJvvHVA1J75g56t1ZgSigBP4zP9c8Rh41sVQwwA8NEEYRoKl2+dX7hV5QJM3DfjQzQNu1zohLmbmhHIsCPVXOz0kCoEDzLH+f3AZqF5YvfDRuedvTQg1sD1gcNNCf8wBY8165H3J1sQ2R7EA1ILYkAV8CR5oAdRFEL+1D9csLHi2dw2hpmsiNxzeK7Gswup7r4oim6l+zk/LpBTNgD4JxwwsfUX72s5/ImBNinqIYkNzejiqxCGL6LnyVu6W/IQhkSVTdHIBbK17BrKDs2aquuoc2lTuGyT5F66AHmIzFyBmN2jAmBEzVytvEoJiYEitbgr44Lzk7VbxrQPkm4JOVY+C7zzMcyWKYB4SackJoUgIz23nIHdKtggk850kxnpeaYIL4d7G2OePkef9dhOJNN+xH0fH7pqPpIiZvLgGyVMw==
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
---
 include/linux/memcontrol.h | 18 ------------------
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 21 +++++++++++++++++++++
 include/net/tcp.h          |  2 +-
 4 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9ccbcddbe3b8e..211712ec57d1a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1605,19 +1605,6 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
 			  gfp_t gfp_mask);
 void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages);
 
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
-{
-#ifdef CONFIG_MEMCG_V1
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return !!memcg->tcpmem_pressure;
-#endif /* CONFIG_MEMCG_V1 */
-	do {
-		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
-			return true;
-	} while ((memcg = parent_mem_cgroup(memcg)));
-	return false;
-}
-
 int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
@@ -1649,11 +1636,6 @@ static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
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
index 859e63de81c49..8e91a8fa31b52 100644
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
index 3efdf680401dd..efb2f659236d4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2604,6 +2604,22 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
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
+	do {
+		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
+			return true;
+	} while ((memcg = parent_mem_cgroup(memcg)));
+
+	return false;
+}
 #else
 static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
 {
@@ -2614,6 +2630,11 @@ static inline bool mem_cgroup_sk_enabled(const struct sock *sk)
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
index f9a0eb242e65c..9ffe971a1856b 100644
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
2.50.0.727.gbf7dc18ff4-goog


