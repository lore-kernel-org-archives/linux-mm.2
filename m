Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8815CCA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D22C90001C; Tue, 12 Aug 2025 13:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284258E0151; Tue, 12 Aug 2025 13:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1744E90001C; Tue, 12 Aug 2025 13:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F748E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C00AB160131
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:13 +0000 (UTC)
X-FDA: 83768866986.06.5DBC4B3
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02DD31C000A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oJnFJemy;
	spf=pass (imf18.hostedemail.com: domain of 37oCbaAYKCKkTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=37oCbaAYKCKkTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KhRu3fyzeIM1cEVseI3UE0mtgEXOJWM2aq0opP5CZE=;
	b=CVX831x/HKz8wYLlPmyOvXBadyHLZSvRtJtPl2Te1vB9ZiEavuR1Frmi4pXc3IVEzdJmmu
	dZZqojkNobwF1FauxWYqOs3Lmjb6LBrhF1MULuio8kW4BrmrV60KW+kpViMP60QdKYYc+a
	kzwAX1byaYu2E/MNwpSRpjoIl10VilQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oJnFJemy;
	spf=pass (imf18.hostedemail.com: domain of 37oCbaAYKCKkTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=37oCbaAYKCKkTdWRhdPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021552; a=rsa-sha256;
	cv=none;
	b=ZrrGQKpGrkeWwjRvMWayZ7kKNFlgf0cRliFprJopD4M9+Y4D7JKpUOIW6GiINczslVxBDa
	EZ8cSHI47rl8nc9Dc+9RZSYQm+K7w3meWbF+x6PW9W8/t0O+5VzpjxxY7k9JmPZO+jW7zr
	IcFfAa+rxxp7li3SUL2Oj49UTg5Ndjg=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-75ab147e0a3so11746896b3a.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021551; x=1755626351; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1KhRu3fyzeIM1cEVseI3UE0mtgEXOJWM2aq0opP5CZE=;
        b=oJnFJemyDshrNxrhoNtBMOY3LrfDvp02eFMVGBxN5LnaK/NMk2+bt+tUeRzHf7fXFz
         4vd+o55pfBtpqAWNQCbM7Egk8w6kmOcp1Ddg7LNzHlm87qo1u8SIHEOWU90tGFVFJzBi
         +maP4JNAQBrWB59jC5kkiWzZX3RrWUGk2ooI2Mo9dvAxdlPYzBF/bXoFf5KXqClWyRHR
         ALXASDrO3ymG9XJOgp0Z5aL2R5x1jr25iXIp6nY6mojyhBcSGPWlbEtyLhqrJQ9lq87y
         YaPBODJGOEvhmrv8rEB45VuvFzY5wcw9pXX1kQOjKA2JjsV01bkA1pVTKiMl3pM4Y86c
         y2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021551; x=1755626351;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1KhRu3fyzeIM1cEVseI3UE0mtgEXOJWM2aq0opP5CZE=;
        b=aIk41NRU/uwdFIpYBCloyAQOe0b7QEfIX1SE22x4RtXnKHLXnZmy6ZJiyzCoQsAu3O
         t6JzpRb3Y+4ImP5WKTv4tAQ6uVjAFimsbl4TIpRjeTUv5j2lwSGND+AoaZiz7guNIOY9
         orHRHouctXMX84XEkdMTvdthADPLReZib0UhXETA7rJ0OAq1bfRvzA8/i0/fJK9hyunI
         jSu91nNl1ZB1Vf3V8+wTmWGZidlrUff8IHE+m/I40WW2u6QIlCdeRSxF9lcVvXZYMV5y
         UA/xPbMRxBITJ9O2qt1SxnPIB9rADFXO6S0yVlK9ALhBkvGqDrDqbwtYS3jBgQUgGcwY
         xEFg==
X-Forwarded-Encrypted: i=1; AJvYcCW/G9U70tnFQxa9d3YeBIRD5jHc/5Ctz5kBl4Rcvx3TMbeGVV8Odlo+vDrl4eeY6UTmLs3VXQXemQ==@kvack.org
X-Gm-Message-State: AOJu0Ywg13EAcMxPziMu8lpuailB4w/1PeThHNj7I0WSvnfVQjM7YXPI
	XnpymAQjX3INwmgl4oq7aEmrKCCXd3WfsipWEwtJQgoB/V7YBAw76DorQNFrFawnesJ/YX6AAvC
	QY2MTzQ==
X-Google-Smtp-Source: AGHT+IF63iH6Z4gy1nQZqVIq3G/a8abCEtoljmxhNBcGHE63GfGOSxTYCt4U1CIor9EBnSEyEuEehfcKfyo=
X-Received: from pfblu26.prod.google.com ([2002:a05:6a00:749a:b0:76b:ca57:9538])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:66d6:b0:746:24c9:c92e
 with SMTP id d2e1a72fcca58-76e20e2515emr199538b3a.8.1755021550862; Tue, 12
 Aug 2025 10:59:10 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:28 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-11-kuniyu@google.com>
Subject: [PATCH v3 net-next 10/12] net: Define sk_memcg under CONFIG_MEMCG.
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
X-Rspamd-Queue-Id: 02DD31C000A
X-Stat-Signature: sri4makrqa3qdebb5tbgd9zs6oq946ks
X-Rspam-User: 
X-HE-Tag: 1755021551-24364
X-HE-Meta: U2FsdGVkX19ZW3pyw60o9b1xS2ZCbuf0bMlF6Cvh18y5Jl/Jiqa80rTQ/fceoZcvcNuUBodLK93UqSsmmyFRBsYnetkCjnnHm1jS8Epaz9IVzmjZM6cPaz8VO+WDf0gD5c9vwbHIwl4Zc+pLRcC2qagUlYPeVuSmrha6zFA/aINGdr5eaLHBCwWPj40Xw7W8zfP2aIm+s1UkgnYbJ774Sw6NDG4BOCZuwiyusv9kqYZIZRh+FN2BvQjWnB8/6rrsPaTB/U74xGT51W8z/TgCBb84YRu5YBXpoF1c3qYNZPUBhMjMa7cqgzvLpNb1GBCH0+mpWOOI2F3h2Zef1ALv8KQOybVnZifsA5f4MUduLAGvnEsPVTsscgynWAHuJ4mtLnjdAGyOEw7OX+8RkruXy/4r7iesIJrRjA8Jxw3+MwI6APUdENpSCByVKDVj7Vg0B5cl9WEg+L3NvI0TZG7NBlbZgF3yxW7ikujGHPBlgQmM01kpslVj6BS5oft1aWbm35b4pKaUJvMknaDpRu8aI4vZTuPsQKsIyhjGBikVCaJBVJs26xBZrXZmRWyh+zzwNnPX945rrYJ323GpY8b4V2amu2r2MWGSpDIIWbQI+qUwZsKa9OCh2Q9JAS6M2QeB5rONwnR9wxCL9dIRFetA3GcIw9tTF+MkVi8MneVAb+a44wMt0AVu0vaUb7ZEMxSCSdBq9IcyXdPqgC4XkHOtgtY5+RMT212v3kMeMmeHkwwQ7x5q37wSjnuU8meAPYD/bVeDkcrtquru6lTzAPFlUh3goQvXnKnxrQ0M6cfj18hR7CbwMxuAR2n40/DBR17L3pwhdrk4lopV5FfyZ7BlZw6BTs3si0zR9VWLvikJBhDxE19aPf81w+hzUjMOnEaxiZjRfIeicHtglID1vCmB25+vBU4z9tmUAerqZcmR5i0Ct7D3SnyK5I1ancETeKnzqmIWPUT7EFpZwN68iow
 dGTfgl9n
 GSh46V4FQC/pHN6r5jz0J/33p558TDMa6oz76DegmiJC3PHO/wS881otnfDu3JAG359eU0UmCo1koTu7KNiS7WfhtqdrIgBM8Y1y3FHF9iatDLD/9/JLByL5pqwz2vdZvVxU5NXIXvEPm3dcPlnE7+2Xf/pZOr4mypHuQrfae0AGTQzoLHnFB8rNvVouyz3VxtVPnI8UByB1AOiEUzkFJjmaaYAzr7AnVt5d7Zmq8yo2P0ayOMcmmgxusjHQgFPsPNi3GVDG6GbdpKHylUHKTOrYHXZ3owmt+aOyVIZHew1CHhT7wMo0knBe3aZdeq++O9EEabkq8BUr9+VUU3IIoscsZ4Y7z83wmt9y4gUNKxrUykZj8nXGF7xKo8fHfB4BV+JLfi8WBgySsU9Z0VH95kddq25vbDcVKFCYHBOmh89R2H0bi5IpPEZ9542cqgeYjzlxVM4krsJb9Ie58OBfEkc81E9oEOv4cLROcqmRr3MQWbTEzsDvYfqr7xPSsubvN8C4EfZW/NfG3QDWoNxtbbWyZrU6MagyH0vOOvvaWGRVAdYKTHftNio+uwV3Y0f2SL7LEFbt1o5WAdL7qigR99aan+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Except for sk_clone_lock(), all accesses to sk->sk_memcg
is done under CONFIG_MEMCG.

As a bonus, let's define sk->sk_memcg under CONFIG_MEMCG.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3bc4d566f7d0..1c49ea13af4a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -443,7 +443,9 @@ struct sock {
 	__cacheline_group_begin(sock_read_rxtx);
 	int			sk_err;
 	struct socket		*sk_socket;
+#ifdef CONFIG_MEMCG
 	struct mem_cgroup	*sk_memcg;
+#endif
 #ifdef CONFIG_XFRM
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
diff --git a/net/core/sock.c b/net/core/sock.c
index 5537ca263858..ab6953d295df 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2512,8 +2512,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	sock_reset_flag(newsk, SOCK_DONE);
 
+#ifdef CONFIG_MEMCG
 	/* sk->sk_memcg will be populated at accept() time */
 	newsk->sk_memcg = NULL;
+#endif
 
 	cgroup_sk_clone(&newsk->sk_cgrp_data);
 
@@ -4452,7 +4454,9 @@ static int __init sock_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_err);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_socket);
+#ifdef CONFIG_MEMCG
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_memcg);
+#endif
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_write_rxtx, sk_lock);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_write_rxtx, sk_reserved_mem);
-- 
2.51.0.rc0.205.g4a044479a3-goog


