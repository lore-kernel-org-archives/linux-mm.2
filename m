Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99674CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C480090001B; Tue, 12 Aug 2025 13:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9818E0151; Tue, 12 Aug 2025 13:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC10890001B; Tue, 12 Aug 2025 13:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97E308E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4AF8513433E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:12 +0000 (UTC)
X-FDA: 83768866944.24.7B22CC5
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6A09C14000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=meMBAnOE;
	spf=pass (imf23.hostedemail.com: domain of 37YCbaAYKCKgScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=37YCbaAYKCKgScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAQKiMCakkqwV95b2b8VWBJpRa3xearNZGx30z89mh4=;
	b=uYJ8odSpw1rH2Qa8d/p7rNAgzDbE18vHJCRf1Y6udPhD4qo7kPwBiAtsinJuL+hJ7gkvCT
	anfjVr51dV0FE+YghJWav4+ThVH7sz9R1zbN2JxdkBVoGPV9h8QMKJzzdZ0daSveAdcZnC
	IoltU+3s4DNZGmgTQYYWN+EzGVSpsb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021550; a=rsa-sha256;
	cv=none;
	b=rH0W6Xv8oy/r3hSsbmVoLGzql9N72y1oLp5X1XdvGSyHpsy2esR1dGlC8HgSjJuHpHq1O+
	LiE2xr+cPcZqMO+IHJrihw1onxnHzw4RMEmgwbLJ8IQqf05wulkb3DqYxJZVfJd2MPps9i
	LhDb9Tr1PqJKPhkZtwKNqkny+t4P6fM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=meMBAnOE;
	spf=pass (imf23.hostedemail.com: domain of 37YCbaAYKCKgScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=37YCbaAYKCKgScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31eec17b5acso6747613a91.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021549; x=1755626349; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PAQKiMCakkqwV95b2b8VWBJpRa3xearNZGx30z89mh4=;
        b=meMBAnOEC1VjL+zKWAO9ZBPrbb0C5tLHkLPbDFgSeY0ug2LMpoUmf7oxAXN5sWidVj
         3oazzRU8u4aFSb94XG7NDj6LaxMBS1g1j6dlva8hL10iHoaf02+zmSENsjQaxCCZc1zC
         nI9DbtBbRtVFsZxWuUeNr2a1nqX+ZF9uV8ZCnvvX94+fYMbtNnth4M4uynTCYTdm8H07
         t9iNbFhH5Cvk1tOJqPyCBmUSxpLrm7NBaEz0bfSlOfuCcbIzsnNJCMGuCbDdvGftg6el
         VBpUo5NdpvzOckRV4w8VmDGl033J98rRnaUFN7s6/YHI3Zu3fUeyiMB2dbar7Jq5e9zZ
         CFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021549; x=1755626349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAQKiMCakkqwV95b2b8VWBJpRa3xearNZGx30z89mh4=;
        b=NwOWSNBHvu7fHdLCjMPUcx1YqKIO0Hd/OmOwavy/AVq+YDMnxCs2Wp176o3DCHIbXD
         vZH//JjRYFvZSLbu4LqezmDdUG3I75WBKGqy1uX9K5/VZaBZBzx3JCSWzviQIjLrbIza
         tM13QLNj2eitCTMxQ71MXoMwfzvmow2NWbnnp/yje5Rvp14CzuewgDsyS9+nkAfEuYzN
         312DY4KEcSoa7+vbv69gSLDp+2bvlWO2cQ6P4THGfk8/4uBgPoCtlhmLzrE0IXHGEp/a
         7RbNyhCCJu+n/y4VztpkZ5wLf1O/8Y0UthtmTY9qWhaUzeMX5a5LG2H7AezvIrIIonDO
         /nKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXezi5iqUC+1C0zEqGdbkE8GQn15uRZSJ0OiMC/rWnF66XUeaI78LCy0OTjL9kdZJ3v8vZCPJT3mw==@kvack.org
X-Gm-Message-State: AOJu0Yzp70ovdwvhIplCaPJPj1PIjhJZf1cSGWs7RcCh7/gWB9O6Aabd
	k9rEKau0rwsrRpwy8E6Od394DxvNtWqQ1pMNzRlRvsW7FtzY8cKo8qMOIWYkK4L+kl8ebnPht+6
	oXrHkAA==
X-Google-Smtp-Source: AGHT+IFO4uc9EvAV7okCx9zQHxmIApDMA+yhfz+lGyPq4mF4kWTkx5Mc08aiDs0AG+bvf5xkZqRyMQpe5fQ=
X-Received: from pjbqi10.prod.google.com ([2002:a17:90b:274a:b0:311:c5d3:c7d0])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dd8f:b0:311:eb85:96df
 with SMTP id 98e67ed59e1d1-321cf97d624mr650175a91.17.1755021549334; Tue, 12
 Aug 2025 10:59:09 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:27 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-10-kuniyu@google.com>
Subject: [PATCH v3 net-next 09/12] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A09C14000A
X-Stat-Signature: e5axmb63h664psc4bp5uzwmeyrnc4apt
X-Rspam-User: 
X-HE-Tag: 1755021550-27840
X-HE-Meta: U2FsdGVkX19R1x2oplDw4E46beVfMwEBn7uHKPimIRyA6E6ML2mZs4TePh9m/M1ThCas2Tp5NqeixJUaVEpITkbV1eEjN4I4a2QhANMDYcE2M6XGhr9B5aO8arPPJOOEHvE9vodTScsZzbTG53FLjXwOzR5zUBAk5C+S6pKFbCUOH7QxymgBL510bXDINDQm69QScOQN1wh9kkSuXjn5d32wKG0ptBzdrDXdOSSOesnyEX633gyHdGeYM+TfKtNxM/IVvQfXZJA5ZTcPiKBCGyVQBkm85hwsWJDI+dif7KrRb9mt8BvncxVVTPxNRa8jwuqfH7q0LXn4/7oYAj/2IdDiZoeH2dfjN/CdHKGFvtA7YMMHLIXoUopnjg02TtUZiW5s5QfZAEXeXi+IL1iJsx7Lby02/EG5GSZBjUdEkGuPwyA2lgoEFcxIn5Brrs8zp97TTLe3wdx32qEHup6AUJF5aTr3Fex9tYw1YKkwEBVIzERwtaS/GAvpyUJie7Y12Gs4aqfgOQPKFKIADNW2saw1Mu6hX1Z0a8GMbCPcL0QzAP3F7E/xvRzyuF4S3rJov6se3ehb/U4/U2RZELmV6FjYg17w6b/Pc8RAT1cPefkROmaYe2gOaKKlD+xmIuKNa9NrZhr0xSIYgWFwgvmyJSPfXtN0tI3GK9N2Qjs5K6hQlJcwxOw2Gx8u2jol/pX+cfenGJKbdo5OFouTjhv4uaHgEZJksEH12DPb4HyKd/9NSHhWZDgt1W9F568tnqTLbbdjp1QcsZ0YpkeuMC0TniOlr658dFP5FQ9qdOXeJBm8ULV02nbX+nMbK1qVF1eDcyMdi6kxclwTBSB5+y7U/e1mbYcG4pxDbPaFZNl+4iMtiLau8my86ZIjbCXNtqdHqLfwdXHoaBprITZ8Fz4IMx0/CakzFWFNjUvWHFhMteXQJMtO1JhgnrjzcMZ/YNu/mbPIEgvtKgoDtk6jRUX
 dUv85BYc
 69OB5mrfVSSOhlU1GfP0wIHnH+m7L4mSM7QZWVhSMEs2xIeTT1xKF1f6r9HhRL2/GVxMrYX7dzXo8wB8aK+l3N+OUec6c4zs3Usmu/mE7GgGULPoxekkjMcQq/T/Wu68ppESGPjmf29NM7oAlm1G6jWSOQG0JS2YrM9qk2taPQVcjd1DnN2I+FK2BVah31+9o7kT0P9awxuyWrktHT8vKC8N/BPzaKfmINHxZPJf3KsqDaUvqnQSShuMpvf5gC/NrR5PatfRD771CX7Qtm7hpfIwyjznVTcgNY33gvBEkEiNZL/xQIdo2cCsrNehGHZmmvPd5JaxH3JzXcX3geRrSx86ZYCd37+lIBDIMzteP+R80SVoKcShHsXETFWIzXtXcRDNsYs8pk3DGkOLccvqsXDNZCjp+ZwEorFktiSPn3qbbEMQYFqh5LZGqfAkDlMhnTDeQnLGcqYgELIphvmJVZNOWvZRtEAqvMc5sSSB0fh+qmSuUosl9Sbp4e69ieduTCqzbjCY/swa28NOXpoyerjMsVAMN1AgH8bMeWLGDGoSwp+MvMG2W/KCshDhIIgijHVWyeXpLc2GNTwHqeMuMGLz/Ug==
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
2.51.0.rc0.205.g4a044479a3-goog


