Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E0ECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CAD9001CF; Thu, 14 Aug 2025 16:09:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5434900172; Thu, 14 Aug 2025 16:09:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFF79001CF; Thu, 14 Aug 2025 16:09:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4A49900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78A4913891A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:19 +0000 (UTC)
X-FDA: 83776452438.04.DFBE908
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0CD6180009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1pFD2dmN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3bEKeaAYKCLUfpidtpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3bEKeaAYKCLUfpidtpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+lbZziEhh3LGkLKxCxKqhss+KocSzVWnXytm6X5LtU=;
	b=tuQ+Y6QL/P3470X2hRJIsLTtxUHbK7ou/B5s2f1BRAyPi2qyz+ofEgTebPFClTdSiUdJ7V
	1dcN1tG1u3tBEevjyZ+2t98Tj/20xCLYYxVSrJAoZWbPnZFmSXsepkyFnghnPcZsyDZPIb
	q4hiYGKlMESA5eSYGULk1th6XQgtLEs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1pFD2dmN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3bEKeaAYKCLUfpidtpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3bEKeaAYKCLUfpidtpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202157; a=rsa-sha256;
	cv=none;
	b=dR5nHnXgwy4DoZm8+yMxwBxc6cdSt0crQpNXIOGw0UykTAESdajLKshdUN04/BLAQCt6Co
	4rqgrj4OfXP1H59vc97bsT6KXQrtyK1ik+ItVKmUlAq+8cb03tgkqrDb5COy4TECcoC0iH
	n0VlGxPp6wSgwQqOoDOz6uU4JbkOahY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445806b2beso28777255ad.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202156; x=1755806956; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t+lbZziEhh3LGkLKxCxKqhss+KocSzVWnXytm6X5LtU=;
        b=1pFD2dmNVddPItsGup8b6GWdl4QAdR4QwA+nH1z/QAQ3vItufAErQurd6srs+dfcUu
         JZZnuGt51cjOmbssNCj8nq3Yn4oF8sJFbTPJvVDq9T9hv9iSMWLmEpLHv984YazlVYLw
         47cRSeFp2IINEb8JRKeqMTObXQlmCRrnWUWcF4/yjDxVgpFxLdHhron6HX4yUNXZzBB1
         Q64YTFrAhym8JEFIaomMUciGWzanLEATwXg/CYkZeSLhkiY+Hcb9S4YkjHwAuPoNikrY
         h0jy6uAllqQHhM+TdkNtmD2O/Y8uscNjb9ALlwd67tNO0uW7LLeCoDLN42qmpxmsrGJd
         Qt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202156; x=1755806956;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t+lbZziEhh3LGkLKxCxKqhss+KocSzVWnXytm6X5LtU=;
        b=nQUmTiwuDjZqOoVkWy1cqVVI+rIq42C8URM9FH5NZ9mUYecdEJ8wnQd1OI3lKJSc16
         a/ZTH1pQLrS8PwWGnatDNgO8HFfByFsmH3EICd1Cbd+RBo9ArFKLRme3dIdb5T7loFdu
         ym54y7ZRcXjCHQXqoAJsDs4zLNqzvelzRx40UMZ/UjLEAfsuNjOc9oCVV/6c6eL0RWEI
         u+ru9ONSUN1rU+lr5iIiKZgLRN7/blohpRXVhHZDSU4nly3otw5TjwaP4RypP/gr2m+X
         uKgtrJSMddiAffX3Fx8ZnTzvkjbZbtoUNRqqiF2ejl7jGWAcf8siiZkDldq8Fx3ZAEBn
         DHSg==
X-Forwarded-Encrypted: i=1; AJvYcCXHUmYbVJBdhio/pz1Rr7AKDXPSV47xCsYrYZ1q6Q78pIchZ/C8xF1/mQ0SUjjIRenkNj1KaTr20Q==@kvack.org
X-Gm-Message-State: AOJu0YzXWnTbyCtbAEpIjKcvqVFseHZ0Jw2X1j0zcnyS4E/O3FqFzh59
	Ncyj4p88fO/1YreXm4zoXkFm4M1t8aLt/sFAHkb54drsF0Gc0GwFZ0oE/IcEzaetm57acVk0Y2m
	AUQ5KdQ==
X-Google-Smtp-Source: AGHT+IHNfSNaLlVBh8qJO1UdhldaL8UMFcUbGeFSWhTNIR6zr5rZyXQBo099O6LvTp4kIOMl2zLxqruoWs8=
X-Received: from pjbtd11.prod.google.com ([2002:a17:90b:544b:b0:31f:2a78:943])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e851:b0:235:ed01:18cd
 with SMTP id d9443c01a7336-2446a3c448emr3523915ad.44.1755202156412; Thu, 14
 Aug 2025 13:09:16 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:33 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-2-kuniyu@google.com>
Subject: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0CD6180009
X-Stat-Signature: n979ksc6yygb6a1dgkbe1ab53xefzeoe
X-Rspam-User: 
X-HE-Tag: 1755202157-567241
X-HE-Meta: U2FsdGVkX19xp5cYyyCQgi6OxeDUV5YPyX34JFKg8qx6xxnW2ik5N+7a4MTCVQEOTN7bjq/ON98OmzW0STGbHCKPVHTFfATOXCdGJ/TYLeKvx8nAsvBzr+JwDjEwPE0GaGHgeP/UZUS3Dk/Wsy297DU3Hik8dop/vkktOutMLftoDfi35dKiRMuTLoMtNCXAwa9EQ87NzaG+pzIiVacdt6sIUbgfQW5rOaDnYimYcXs4aYJzsw/6IQGV5Tl4NN4dGFxaLF1IVfF2Y/GDDY36Re7aB4VTt+Wv282hwrRPQAc/k5DL/moUXg3ndhfNDMtMgBwnJgRR4+Ux9A1nCg+jk1Q9dW1nm6JHi/sZmJ266Is2dVcT1XUMPuBl4qYIi9ZI0XiCYOafm1/UpZj3cCVJii+uEq341P1eACiARfjrTbtx/h5qrwBoxD/6w//aUFhgPuA5dDcicDEAJ7anl55wCgZkHtXFyClzMOoT7sxq9bTUM2qg+hAWjIQeJepRzgIFa9LIY5Fola+FUz0B+z8BVTjuOcsxZPmzQcTWqed9S22y3By81rjmOlrjriLjK8w5v5EU2SC0n6V2T2wsqWMpoM1eJ9wdXEipLXtOZ7tjCNA17DX12oNp55sMwwr/tKMbGM6XKMyJcF7a+yrI9Q0ytUWDydwiQyxkUT6RsJW705lLbyVduAN9nXvAhJULwZZenirax5HmkFCcyf9eRDvPKYoEgTBFfotc9Jl7SG/ljmkOW4wTgBv4M3QMzJdCUhRNKjqz1Tgx9sUrp2fHE8oCK1iu0yTW3TqRMF9JqSqNMLzgS7P0iUUSeDg8MiNK+9BuaXPE7SGNjEhGWDkpXNkurU68ERRYLppZSXp1ah+8iT2XOPC4B6Zcu3ssLfswXZrUaHtTvqe+EI9xwjKXvFqtzK2Iti1tH5BAjmuCzp3Vjep75DLnTAPtE2sC7e2V44w6mEDqiYTJDzbJkpIPgGH
 LBFeKjFl
 3GbiGTM41IwTwi0sE74u/B8XiRAyHojiqmPAjhRg/is4j6lsqrtDo7YKCOx1XgM1cM6WuEEkAXgRIWQmip1kWG6jg0cD7kVrW7e8QJLmgShw4h+iSDWYGJHOSg/B8/0YTuokvH5E544RwWsl0EbwOxUzGce5HO94ua+Rwl631Irkf4pjAi9DSdmGXdO1IELUtJCcQcW3cJRfgQWteSllgRbD72uFgc6Jw2sJBI3yuVjw7/M+Efq0pXjdlvn+N17NKIRDoQ+JLbElwL+84t2O+5XsqOVWFftmrNS4vgDrEq1He6PHiFPwOleo0Avmhxcon34Jh1NTfFuXGJHZYOrIHbFCZ5nSJ3hFkTSYwMxuIDLRcr7P7i51MOVArtQbn+hIn0J3pJ3PUvmgw92/jMBCMaThwkG6RysBqcuIH+1aeutuUTBd3eX3V1woaR1OZ75uY4UzQip2YCQqy8aWvOqbBcsaP2+Jcpu9tLxYxD30cMaOWD+T7DhnFuQ2kc1hyCSFZOO310SODHyCbzzHZdjwDHOG05M1iOoQ3o/WnOu67hBvSQLTVS6eW0w0XAmj1FeO4LHqF6tt34Z04syNQ+nFs98IXEPI8cNUX/wotI1qvCNHp52zclYveM7OEUanO4xyc3O7yqt3AdSRLXWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
sk->sk_memcg based on the current task.

MPTCP subflow socket creation is triggered from userspace or
an in-kernel worker.

In the latter case, sk->sk_memcg is not what we want.  So, we fix
it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().

Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
under #ifdef CONFIG_SOCK_CGROUP_DATA.

The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
correctly.

Let's wrap sock_create_kern() for subflow with set_active_memcg()
using the parent sk->sk_memcg.

Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c     |  5 ++++-
 net/mptcp/subflow.c | 11 +++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..450862e7fd7a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 	if (!in_task())
 		return;
=20
+	memcg =3D current->active_memcg;
+
 	rcu_read_lock();
-	memcg =3D mem_cgroup_from_task(current);
+	if (likely(!memcg))
+		memcg =3D mem_cgroup_from_task(current);
 	if (mem_cgroup_is_root(memcg))
 		goto out;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(me=
mcg))
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3f1b62a9fe88..a4809054ea6c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1717,14 +1717,6 @@ static void mptcp_attach_cgroup(struct sock *parent,=
 struct sock *child)
 	/* only the additional subflows created by kworkers have to be modified *=
/
 	if (cgroup_id(sock_cgroup_ptr(parent_skcd)) !=3D
 	    cgroup_id(sock_cgroup_ptr(child_skcd))) {
-#ifdef CONFIG_MEMCG
-		struct mem_cgroup *memcg =3D parent->sk_memcg;
-
-		mem_cgroup_sk_free(child);
-		if (memcg && css_tryget(&memcg->css))
-			child->sk_memcg =3D memcg;
-#endif /* CONFIG_MEMCG */
-
 		cgroup_sk_free(child_skcd);
 		*child_skcd =3D *parent_skcd;
 		cgroup_sk_clone(child_skcd);
@@ -1757,6 +1749,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsi=
gned short family,
 {
 	struct mptcp_subflow_context *subflow;
 	struct net *net =3D sock_net(sk);
+	struct mem_cgroup *memcg;
 	struct socket *sf;
 	int err;
=20
@@ -1766,7 +1759,9 @@ int mptcp_subflow_create_socket(struct sock *sk, unsi=
gned short family,
 	if (unlikely(!sk->sk_socket))
 		return -EINVAL;
=20
+	memcg =3D set_active_memcg(sk->sk_memcg);
 	err =3D sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP, &sf);
+	set_active_memcg(memcg);
 	if (err)
 		return err;
=20
--=20
2.51.0.rc1.163.g2494970778-goog


