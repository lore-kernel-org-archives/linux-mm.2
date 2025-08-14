Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E02BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D3A9001D7; Thu, 14 Aug 2025 16:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CECB9001D5; Thu, 14 Aug 2025 16:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247AC9001D7; Thu, 14 Aug 2025 16:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06D059001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 891241A07CB
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:31 +0000 (UTC)
X-FDA: 83776452942.12.7735EEC
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id C09F21C0003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H02mkL6z;
	spf=pass (imf18.hostedemail.com: domain of 3eEKeaAYKCMEr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3eEKeaAYKCMEr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YO6ZjmNOtKlWEF8G8K+b4WUo0jZB94+FQ/E9TVkGFI8=;
	b=I5GMKl/MliIN0JYCfYpuWKgof/lHzBz1bePwOBHZvEwP4QqO11vOb+1j2RY0S4I5hqK68g
	Xay4c6Gbd4tOHE27D+67wKMDbOer36T5TA/9xhRoOXCSpPfWnt+8BU4O2VDlWkN+kupndg
	Ol78DfU53dWBKhhG0p8D0kQyEYNTU+8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H02mkL6z;
	spf=pass (imf18.hostedemail.com: domain of 3eEKeaAYKCMEr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3eEKeaAYKCMEr1up51nvvnsl.jvtspu14-ttr2hjr.vyn@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202169; a=rsa-sha256;
	cv=none;
	b=i6OEhE33Dm/7K+TL8fL43LTlTslqESEJECCfHfXpUjbPNfwn5ou5TSK11N93oJMIhjTOhd
	xrRrvgcN0ISvL33ySmEhvCtCvDJZ2u0SAubAUjDaS2HszIWWzsUuDCmLdNIJhXav9NuYvp
	IfyjWv9e710goiXHwR3Fob/iT8ZyvVI=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244582bc5e4so14678825ad.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202169; x=1755806969; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YO6ZjmNOtKlWEF8G8K+b4WUo0jZB94+FQ/E9TVkGFI8=;
        b=H02mkL6znTHUwZ7qhp4E5gMVvDIX+DVn7q+tqRXm3+t3R4mD6V454pPvaQ+VdIxquu
         Q9AXeCEt8750XnEdjK6QyQphKVhTKuxwEwMR+QYia2sswZHBz8gTcK9f09CN5bgrHndQ
         TirNiPvxFut5UML+XKNFXvci6G/4kO5VZn4muTbwi0kYpIUoN6WZGeFruQaMLdqPGQua
         s2jxcFVPkvdPLX7LTAi88n+r5MLwU0+RR/1CLzS5A9dMLq2+5WHro4/A4Ah2HxdhuD4t
         PN4YE7OVMsI9EiFQ/wVPD/40Ew4xSGKcuzDJ4+JBJQjsgkpcG3/vlJvvoXUnkd1+QR7O
         CvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202169; x=1755806969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YO6ZjmNOtKlWEF8G8K+b4WUo0jZB94+FQ/E9TVkGFI8=;
        b=hwuObiNACqd9lwAhkTN2yaEdeGZABORX3oO3Q5GwRGXdRbCzGMV0Dy7RC+2D9ILic5
         dso5oi7hfEDJrqdxvfGS1yvb6Yomi6y4zqoMxyT4VyH1jzOi6JGAnDNYwejTH5qub5f3
         LMicV1FRaQsfJWNT28vWnIoorg1NhFRGgfKXFrl9B4OPwX8SCx9os1kG0wB3DbCx5fiV
         iA8NC3iMs26n8+vFQ1/U0sQcqlAusIWxAILVEETmnfyN+Q8YVQKm7RChcwlvb2QryHsa
         /MW0TzGqaoS2I7Kb+K3uUIVvjkQiAgLPFDWYQUepTEUQbAggJi97/5jvxaj/Ohqoflpq
         QBlw==
X-Forwarded-Encrypted: i=1; AJvYcCXUlyy2BlIeIRSx5FpXGNxdD9MxndMnQnRIEdWvvP4nHSeZWVlpCZ+Ked/vx/Cs9yGl1dmCtWCSLw==@kvack.org
X-Gm-Message-State: AOJu0Yz7OsoC9+6LAUlYc48gFOifebRqI1SayZvABWtElETEwyOABH7U
	+rvEdLmOz94SZyRyT//lF6+H4dBbDOEOJs7JElFS6XiaCNwNZdfyWTMhZ8ShZQddr0njLTgaWlR
	bwu2izw==
X-Google-Smtp-Source: AGHT+IGw0N92d+X4yz4oc9MBEew+9vy8e7l67AOxNN5kdBHZQOpNiXDNq1+p3W0QI0ndx+Xd9tnK9OUDOCE=
X-Received: from plbnb3.prod.google.com ([2002:a17:903:15c3:b0:234:c104:43f1])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aac:b0:240:2efe:c384
 with SMTP id d9443c01a7336-244584eab3dmr62286625ad.19.1755202168661; Thu, 14
 Aug 2025 13:09:28 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:41 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-10-kuniyu@google.com>
Subject: [PATCH v4 net-next 09/10] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
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
X-Rspamd-Queue-Id: C09F21C0003
X-Rspam-User: 
X-Stat-Signature: xkdcy58p89ufbmjuxkr9aj1wpehcpd8d
X-Rspamd-Server: rspam09
X-HE-Tag: 1755202169-206172
X-HE-Meta: U2FsdGVkX19htWPjEJBmJhumnU1VMoH5ewojbQnmTiDSzs+XnhYuaqUyV6aBI0hIihCP0PByScxfsffDxqfPiC5Pv+tHFoDz2cseBJmZwEwnWWiiywAbZFclyIka3tw01WOz7DAX6CRAGHZbhaAHzuvy1fYOHtqFYYfyK+Aw0Nwcc4IWS+BLCTEGMYMmj6auYRmEW0iSMoEgJ3Zzlk7OXmyy/c1XeQtC3rU6FK7woc5nhhBxeSH1l8gnxdJWyKXxPfP/48suj2aHs3Wt33Ny25B8iYsLqunGSk/84NpXJW2t2rsI0ibDU6ZfLOX8OlFkFVURXwWD2cnFA2U7AfrgrMzuPZjFbJouVVrZfkwB/NieGdYOIo1fHqAXTlpupvfdBZRYrSlBa3HBLbQroJhgDrx3RarmGdJGpjxivWJdZtRytioxTZIAa5kAUWkPxvJJCLASfWaGvMVxb3sT+XtEw+M4Uqk9qkEJQrOtJeigu/Y3qqnITGToJlyY/w36JpuOvM1nT90P6OoeSY9YlL+7XNgEoTMBUua+1bkUUYKR0r4SickY0mVQ54JdreiKKmBg1dMRiUIbBXzKEN+Yd2Ax8O5t0EDRLaEse9C1rYfk4hFOaPLn6dWrlnH7zAKTrhhTQBAzNDM9hO6WBf781pTdAjKTq83yqZ4A8vgPVHe2yCcCQib4hqoBr4WRBWADYBBVP+T26C5Ls+l4IHGfJQspJ7J3OrxhDt0WKoKgS/1KrVCJqg6lv2kwBVOgLWe2zptEGKMx5svZk+8yzLNRhnLAaOKuDqjksql3U3DkO7wpHQ8N3MiWnbD6pj3Ojy84UHnwEOXiWYFTwMTJCQVMCnJiql5G57CbQ4+QOIGGOEjL533vbXU4i9EzHzBBZnbrljyKi9O5EgCK7bOwfzodbCFCs5v7zgfmhANZLoudfrW4cCocdsvgCOjJwTAduw1xtndI7Ke/cDarzWOXkvlUivA
 BquSM1ak
 V9iHkxFSmn5LWnbuwmB2FBeHZ1RhvwCVNIl4etjMceOYTlGeeFXSQPpJEnWAKL090wjJlrb4utPr/dJ+B8wqiduFYtQu5UeYdoNYGQQqVWayqU45Vf6m8F7i6HBKvIlIJ7IubhGsPl7cc/Ufsa+CvuyDjYlSdRFGLq1T6zlfi9l0A22FusF5HrzyWBxy8ZdXTkmip3/hcKbcY5q/PZY7CsHWvzNlraTyh7r994i+ik3oJIs6iPS1wWeo2XkK5Tej6/Zm8hQCaNBJOyer6bunba/o9qjHRGKHC0AsOn3NuCakkwdupdy/nNw1Kqtrq/13zPbvjT+K+d4WRhSekh0xMBuM7vCudwKGpIlvkigjgwiOSsvBOu5OVHaVpLLe2DMzZMVOYZH3LVt8VPIVlzTNPOon9Wx6N4uKOupC1q/3RcoWtzxZ1PP3yxSPganv/rTeDdcePsOPNSxj1bZiZ36Ex9C9gXXVyuP+D8BPjBnaTnUzvYDhGeHGrR3TbgNxKYCB9//GTR5D0ztJQkZhlRrVlYMlwYTtIVIcoDOjF2MxMSLYyWuBTYZllvOgDtEK6Gg8vMLIC41oXJF2Xn9b5a95LxXp+mg==
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
index ff008a345ce7..723cc61410ae 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1641,19 +1641,6 @@ static inline u64 mem_cgroup_get_socket_pressure(struct mem_cgroup *memcg)
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
@@ -1680,11 +1667,6 @@ static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
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


