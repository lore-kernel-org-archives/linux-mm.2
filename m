Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131CDCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195E86B02D7; Fri, 15 Aug 2025 16:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081256B02DB; Fri, 15 Aug 2025 16:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D9E6B02D9; Fri, 15 Aug 2025 16:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D12386B02D7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 91F221A0282
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:44 +0000 (UTC)
X-FDA: 83780102448.18.AFD40CD
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id B38A640009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NKfduE79;
	spf=pass (imf04.hostedemail.com: domain of 35ZWfaAYKCNoGQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=35ZWfaAYKCNoGQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
	b=4lXWuap5kvuOWBDV0KFpOlPpQe4suJBsM0BcGiZ5zF4LVU3Vvuarmqp/fRHNnQ5EepWLtr
	SC0edYgEUVlDe1LCFwTHaDOuULOxHic/20gkMDX6UZ++cQt4EkMiMD3jfO07qhfMJZdHaV
	eKV/24F9wOtFSCJ4UiGt+YlpPxYPVkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289062; a=rsa-sha256;
	cv=none;
	b=pKSenNfpf7vfzcZ6i/rN673fDAQjaEBjbJY8abkLRC+bXosEYW1+g9SKGsXg0sxe59GaZ3
	OyhnaIDDubFdFOc7Ed78bEKZe6kQwqayGHEJWx3QilmUUndyFXVR33T4Y60P+4KKwcgZJD
	sgsTl9eOS8Y8dq51dS0qjG9XF9swes8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NKfduE79;
	spf=pass (imf04.hostedemail.com: domain of 35ZWfaAYKCNoGQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=35ZWfaAYKCNoGQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244581950a1so25982785ad.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289062; x=1755893862; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
        b=NKfduE79vJ6JPuoobhXEf2jaYXkJb9BD81vEyl2beDGgG3cugGkeNqT+9+Ren2ZlcC
         qafBKd9jOpV9ZTLnuF6iPhxB30c3GlVdMeVwTnt5B3aCmxL+UnTd9vQKIEByN1kAsS0t
         lXn8Gx0y1d5B4UL/pvMqERYILNeq0ZQpHbt8zPctFwgShnUZa1vRZ79NN2iFAkey926o
         o+zPWd2wMFCohr2GEH5+KptheyUX1+k7/N/4SQ+hrY2PSe3jMTg2RvT4DnttKNuCwXK8
         6MYlwphmWpNanAlDzXanr2hmLJY+liRCM2EiffYvBXi/lYOCVqwJkgjO2FJCFUuJBZy2
         cnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289062; x=1755893862;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jLtDPiqLV2EwRjVXqP4rO8+jmE13TnvcBQt499JidQE=;
        b=jgji669ylaQ2acGBfKbHlJVxGxGNaaWEd3wnF5aL5hTl2YtCjS80GlWi6wSvUY6kq1
         28sbhAkSLfarbOlNbV+ZJa5NIwn5BUbvwM9m3SASrPLYAi+idmNb+qF2xCBP4rZM/zW8
         aAN2o1UowUQPaN+Ex1xkYmp5mwc7wzU7eFQwRRcTLHZCT3JqV4R341L5YQc6q57r63Sh
         ZZHnNNTadSERVTgGdfJIIwRSBLnjNGs4lq31StgEuk2qXCpeRzTcryHMRRJxPjzxdZtm
         ifyPzGx8Gdp/FJANY5iMHYITBKPpoCcl98gapRlztGgYk4A1wiF3teaLPBW+wgkrcFOU
         3hWA==
X-Forwarded-Encrypted: i=1; AJvYcCXHGMFzgRV1d7YK05HpUxKhwVxC9jt+hmlDFJ8ddFVha0PVe7tsas5dRETrpLgU36C4GiQ5CtEpHg==@kvack.org
X-Gm-Message-State: AOJu0YyAoOLiEzEdBJEZErCwxfsOWqAPvmugrjGJ47XRvvT9kSxUMaS6
	bCLO/sZDn0h2O8+XJ/G7/poa25aFwZyhKzWm1/W9gtsf9HcLo285ctXboI4WwkLjJXC5puS5eOF
	0AidgkQ==
X-Google-Smtp-Source: AGHT+IGYcQH7/mF6y+bCQF+wvj8byumWi1k0Tu655xRzdfVqKzsBybbZLpijTnLaQewu7vlc+0MtmLwfX5c=
X-Received: from plbmn15.prod.google.com ([2002:a17:903:a4f:b0:243:5a:ee2a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c8:b0:240:3239:21c7
 with SMTP id d9443c01a7336-2446d89d237mr56657975ad.37.1755289061594; Fri, 15
 Aug 2025 13:17:41 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:13 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-6-kuniyu@google.com>
Subject: [PATCH v5 net-next 05/10] net: Clean up __sk_mem_raise_allocated().
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
X-Rspamd-Queue-Id: B38A640009
X-Stat-Signature: o31u3maeojog5nyq3fwxf9n3gja9rz1u
X-HE-Tag: 1755289062-814529
X-HE-Meta: U2FsdGVkX188istvuUKlRxaXfX0IhJ8J/2Kg8SbbJ71xTa3SRyGzXix5nnQfV9F6z/k7tlFSpZprCIHdVMgbqdtDd+GroqAz/sJD01KNsmWw64AGe66nqdlcv7RklD0uVr0gHx+n0IOtWBk+00nMvVfpYAwyh/Ad6eN8E8rOiS0VK37+8pU/2gTOXjgI3kF1DDXuKhrKCmr8KtEOWZx0lXC62wt4kqI8u0Bz32RUKBhWcxJmXGsl986vI/jx+yoGya2yQpGiLnSn1DdVglDHJ5598v88eIG3JYYy0L31R92VIdv/ULg0yhMFg9oLEr1CZi4BLyDB9LKPnEuKbGVymDxUKGVch2ZYFZMhO7zJoyiqXR4b3qLs9LNlXXFajF6Y+WTiVIRsSVYB0o+BPlIDjZuRVUBcE4mnswBt1knBSeRzdrrC6wCaTmTuXZJnkfxaGF91Ac6Z6eMSeUR//YU6rqvdsqj8Xw4MgtYRO+4U+nFjslDPokBtocRgBC3e+L8W9y+fhc1Gz1K6/zVzHx2iQHYGD4baFmD7QYZuqSMW2iIyS7B9z5MnBnQVkZzFgpqgu+lw4TLQ0BRoeyjw0uM/gBmFfLZ2UG5LmgbtlJqwrrSNFGr26fCG59hslbN1dBHwNlSGdHwhsLwg0ihNs3NFfMQUo2tp1hlWZk8K/P1Ta/N/m1P9yUJqgfkjYlpBq0zkJ/TsGsLKDZsVrn0X8xln5yHSFlnLO+xKoMDobhl6NuGcGe2gqqoz6fmQmkoTSNNSFl5sMJQuz18rbZ5rrtFie6fgXPP7LRKn0nxtVZFLcGeYcnmpuO7SdrOGh7w2VM295KgFPg/NidMVlCzsrpgqST4wHcn5aCZxEPYV0VoTlOCO+j5rlNcs5nJryR7iLyN8+riXIcGV9FYAMXziX9wLB4LzESQhg//JcXGS18BIVCOHFwIsNm1t1W1KN03b2DKaDHSHbq4Tgeg5JVqOe99
 IFoh6wZe
 OVksWFmonPjsB3DABeIMDSTYFJOI8VOfj8eWCGZ7mKqnvFYlHFk3rwoFx2rUq7aiBEzYghy6ahc57XG5/fNYkyj8+tGcjug0eP/jQGZoRVycvPbfUQOT6eJGGSXP0zv67f4pAqs0CQz68SJcPpnODFsPQ7tmAK04f6noWFBmwOv6eR7+ntNgxqjGZfi0IP0b6TzU2eFV/r1Xeiyuw7CjOXu3PIby/xYsK6tk3uoqqYoc84zWCwaq+A3zLLsQETxJo/LczN9DafNKgSesICRz3sej6rb/+8izvsmgoY7r17SNKGxYQCpHtbf3b1IpQ5NeLOmsdLxY35u0AcSmTL4Beq0c8C63ma8/jIDeZTRVIpC3IH0YQcCyKs6+B6OpeRZo6MmY+kdnexW6XPv7LyI5o2TTtTvDZ+p4GInuLg2HdJNx/QhGboXAHGaBrzVt2oV8HxUT0pBxTC6OigErJSSk9zis06RCSHj04irMmODb3KVwsYGqeJ2L4/ajo7zsIeK1BniMXFa2NTGTFfk9n5NjabjIQj/6tkC4atWcHV/d7Ht3Pk6DEqctrKB5WKR+xkee/5hvYlqWRh3d/KTkaT3mMNAZYRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __sk_mem_raise_allocated(), charged is initialised as true due
to the weird condition removed in the previous patch.

It makes the variable unreliable by itself, so we have to check
another variable, memcg, in advance.

Also, we will factorise the common check below for memcg later.

    if (mem_cgroup_sockets_enabled && sk->sk_memcg)

As a prep, let's initialise charged as false and memcg as NULL.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 380bc1aa6982..000940ecf360 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3263,15 +3263,16 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
-	struct mem_cgroup *memcg = mem_cgroup_sockets_enabled ? sk->sk_memcg : NULL;
 	struct proto *prot = sk->sk_prot;
-	bool charged = true;
+	struct mem_cgroup *memcg = NULL;
+	bool charged = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
-	if (memcg) {
+	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+		memcg = sk->sk_memcg;
 		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
 		if (!charged)
 			goto suppress_allocation;
@@ -3358,7 +3359,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (memcg && charged)
+	if (charged)
 		mem_cgroup_uncharge_skmem(memcg, amt);
 
 	return 0;
-- 
2.51.0.rc1.163.g2494970778-goog


