Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF033CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421E68E0086; Mon, 11 Aug 2025 13:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0C28E0060; Mon, 11 Aug 2025 13:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C09E8E0086; Mon, 11 Aug 2025 13:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11D7A8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD9AAC028D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:44 +0000 (UTC)
X-FDA: 83765168928.23.AD7C9E4
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0AD9E160013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RgvxVPtP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3_SiaaAYKCAQoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3_SiaaAYKCAQoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933503; a=rsa-sha256;
	cv=none;
	b=pXK/3rACpxPihcKhy4UCjF5iN7J6AI0+NlKr6yrjWFmtMxpGAp+9I3fpkWV854NzlXxuj5
	WNT3IWDis1ch5eHr569TqsMWV3WxjUPQOsES4j177IcTtV5dYi79Y9c8GUYBrqwsym29ox
	GNwONKGSW+Fyi7r/F/AG7W5DtPfdzdw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RgvxVPtP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3_SiaaAYKCAQoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3_SiaaAYKCAQoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1GHMwnAvIaqWLJyXzy2eGeZ3loP62R3df/KRW2nnvI=;
	b=zQtQFaYfWFJrudxbcArtl9uXc8vAm09o4jZbIRhrPa+jjMmx15PAjoQ2B7CJHwfrmPbaYw
	oEbTV991X9tWZ9wXdc5k0zrJ6VGxbHAa1mlq/PC38ZDqRpt41N3uXH3A5Wn9D89kB3zVZA
	2X55OBdtuq9SEcFcz3FJbnvUab6ztJU=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2403c86ff97so68653615ad.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933502; x=1755538302; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/1GHMwnAvIaqWLJyXzy2eGeZ3loP62R3df/KRW2nnvI=;
        b=RgvxVPtPB/VVlNzH+yC5w2qqx9OskDMPtZxWjvfT3Q7/60zZERC1qGsCXN/Q9hVaHF
         88o8iBfSIwqQVXJoPLJI89sQV80YoUjYwl+zHg5QK/UrSFrCt8zszmLNX6xCKTl4ylv3
         8cWHEZV8dyOi+btSrxCUmGHzeAgBt4KeZZzImPZGVwf7NW0HPiuOlMJwQ4nXsgeCASj6
         5vH50qJW0ljTcoplLd6pfzmbO0WyfR7a6xEr2+FWWI66GCyItiP/s35RFp4KVpF65UDK
         FSaMTUTMUnUFZnhoAIKQCoo1+j2P73M1+U9fvo9BNZ4+CD0Cqgg8QQZpVAVchH617Y7V
         FJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933502; x=1755538302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1GHMwnAvIaqWLJyXzy2eGeZ3loP62R3df/KRW2nnvI=;
        b=kA0QgBo4f3BM4RiPsx/Wp4/K2S0hfH70qEQVX/kXeTtEm+hfzlKLP2KFsLMUJN30nZ
         s0ZwhDMbcswcwJiNS/dWnggsGJK4kOTB5b4KOcoUdehzbmSXXzQTaBtBoecazjmzvIon
         eLumjef/WcJV9V+BF8JTrB/SY7kJfWZCVorjdvDgjt4XPByIfA8SbwvSWJJ1BV+kP4qc
         L+mn52mrOuqxSH0pJ6NvyPjGrXngYLMkCrEUoWrSUO95pRxz3qf7PxblUH9VfQ/UebeC
         yCvKtPotsLzhgpmOi0FobCiFHVuHI8qA4RvX2eBdFpQ7kbhIce9hM0Y11hs1y/q4HHN1
         wpLg==
X-Forwarded-Encrypted: i=1; AJvYcCWb0TmPtPZCxMNgLJLPZzmRtSHCOxUhnFCAmXoWodGcoVb8seUXO/ESa1OdM9yX6AEraD+6zDCY1w==@kvack.org
X-Gm-Message-State: AOJu0YxhT+z46rNndAvbMsiXq9t4aCLRZ6OYxiXmlER9vEkwSbkkdnAk
	RUjZGGBs7Hz+OKCb1+fLDJSnHMI8cHcby3F5U0PfCyimvURKuzFU8UEsBZMlJ4i9r/pRvS42Td6
	jmdeANQ==
X-Google-Smtp-Source: AGHT+IFMNgVf+Ayq9j3qMwMUXApKfzqqa1VJ0zOmoONCV2R4q5dCIl1lgeXBjm87U9qu7vPQAjok3apSCjM=
X-Received: from pjxx5.prod.google.com ([2002:a17:90b:58c5:b0:31f:b2f:aeed])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea08:b0:240:4faa:75cd
 with SMTP id d9443c01a7336-242c225554emr205010325ad.48.1754933501503; Mon, 11
 Aug 2025 10:31:41 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:35 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-8-kuniyu@google.com>
Subject: [PATCH v2 net-next 07/12] net-memcg: Introduce mem_cgroup_sk_enabled().
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AD9E160013
X-Stat-Signature: 7exkzf8duz9saj9qqdd6r9yeu91ijc9p
X-HE-Tag: 1754933502-853188
X-HE-Meta: U2FsdGVkX19u7tBweXjcyiBkBdqrTx1uSat3naWhEAif0OAimvJP6gBINPiqelfH+BuaVdLnD6kPvrt3PboydoA3W4899uKmOjuOcud44nbETb9me9y2ktnx3htyHeezMn57kimSsYG4bVi7QVWMf/lQpphUaIntWuOxfrXf2ZeVX3LTNF7keN9yxYjkS95g8CPbg0InzV5yLV9iShlmg9WhlbfO8RexNg62hPUTwxX5BgQr0lxcOS3YeZO8qJ4myTXehQF9FXfQRoufikBngl+mVjKUCM36m9Bfc+w4fjB+aqnF//OMmbM5VcrNhGiutBKqWgXou9i93z2JZi1E/qDQzm9/fECQgQAlgqKafDlwrbzbnHlrcK+a6uGL4Lg9ysG3Hzjmgf9kQPmfZrGb9OtyPh7ExWQZ76y2FlixDKp76w0dbkr1q5ul3bUU99ios0HjybHfmQGxhQKPByRCDQ/i0BTwyZnqtSP1rxaKkGor5s7uuCZ96xoxK13GnlhEVrFp4nxmERcgjDUFk3gAy7FQuoM8S3YmwL9W5PPyrVgO8DvbiT11VYTo3wZHMAkGcbK5dLC4XJO38pvg4wtw8JwL5Ne/x2vjITqnwIVmcEM1sVF8clBy8QZlQpbKvJQXGcN5t1D+7VRObaGjEMq9zCdiD5/c59zHL2WBp7sL2SEYumcUjaYr7RQSzq6LNXEGpQYDemVIF26/URLwWmrg19+Oyb4Y0Z1oPKvzwmKshhJ17IDxXTJbDF78FusqSwKqHW58rVfj2pbwG+E+0Y/04QawNLtgPmrNqYy5zEUGD5n0SBSpZHw8WeRzV+UpEyjQH+Gt/mkfizsMXlowL7bSGhe8E29jtAMH6dN148CqN9xxDU3HCweER7zi6bhjFuyeLz05qFFb19BQP2y75zEv6NhF3dwuGF9nXsB/eQuDuhTTRlP19+u3cEwq0MF9vAMMooXiXQJRLiriy/ENQmg
 s6RHuaBP
 bPEsTfxCxIkW5S2w1ZyibuxmLm/+rFJSHDheKrm068Hf65tghxGhNEmEfdwKohWqMEtStvhSCGr2Ww8FIh5Ssi1Os/Cx4WyMDw3XtnNEc/CjpZSiwlzEdBB/hbRxrUixLcTNNJjKk7AI7j84eGvovrAub1nEI4vWfOBZZB2naoTLY1CkvJr8aO7XBn9rKGd/mJU9fyGtpAuBFoB4cHUkFTVt6q6dqLf3KR4neWTOHBbU/Tp0d6Yx+H6PTLKB3gBz5h03bc7IUEwDpiWEcZgdGTRS/lYYuc2fsx2e1jhHwGdBBxZHomO/2r8v/27ciQUo/brc01oUwOP07lzVPcRmCODB3uSj+3+cH2oX1ac3ZKGWjvhYdyf3yA9j8TknrBJMomjM8neRrOx3lypILZngxteYV4mAfQCjYvDDG0oh7Efw9vos7ymzWZFcVChwyrsYgSJGvw5mWBoMLmqwLYOiyr0f1scqRGB/xSWiz0ZWDroUZTZtcEcZlJaIjqlMpKn2Npn4pie8qI/c81NL68ktml4B3T7kOduRheKxKgUfjJnPJRv+fOeidI0jrJNruZmi2we5War72mqILoyLt3UpFE00MWQ==
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
---
 include/net/proto_memory.h |  2 +-
 include/net/sock.h         | 10 ++++++++++
 include/net/tcp.h          |  2 +-
 net/core/sock.c            |  6 +++---
 net/ipv4/tcp_output.c      |  2 +-
 net/mptcp/subflow.c        |  2 +-
 6 files changed, 17 insertions(+), 7 deletions(-)

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
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 6fb635a95baf..4874147e0b17 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1723,7 +1723,7 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
 	}
 #endif /* CONFIG_SOCK_CGROUP_DATA */
 
-	if (mem_cgroup_sockets_enabled && parent->sk_memcg)
+	if (mem_cgroup_sk_enabled(parent))
 		mem_cgroup_sk_inherit(parent, child);
 }
 
-- 
2.51.0.rc0.155.g4a0f42376b-goog


