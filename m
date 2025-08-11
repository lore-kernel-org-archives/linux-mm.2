Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A7BCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D2B8E0089; Mon, 11 Aug 2025 13:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D968E0060; Mon, 11 Aug 2025 13:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4D78E0089; Mon, 11 Aug 2025 13:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 916888E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 515A0C0278
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:49 +0000 (UTC)
X-FDA: 83765169138.06.2B41BB0
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D357C0008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UHV4HFNE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3AimaaAYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3AimaaAYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933507; a=rsa-sha256;
	cv=none;
	b=j+bneRrnAMVuZB4XTjn80ukGdGBarvkiEO8dkJ+NoNArvmNuXf7QApEwj6tKUwkRaSA+LR
	DggIpw6ReMZ3n0g7gmFCQVrjJ7s6sAOCVD91PyXKrD0nuYaDGe/vZh6MoNbzwsumprBIde
	BYcNrSM9XvhqLVh5ePVwsdzticLnHbI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UHV4HFNE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3AimaaAYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3AimaaAYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmnhomKCr3e2ahj1QMW8pKbPe/+04IGBoELpRw2IfXA=;
	b=8fZjsGsF+gmaTEqUAt+Vx4BN79WovO1ol5Z0mNYAPtgnw1u8v3xqz9p0kgOG6HddMzzx+a
	mowp17sigF5+Dmf5zvWMSe0/LE2NKXRsq7t/xb0fk/zV4fvCswvALeFRsXi9T5mBtwOsCM
	VgFblu7C/IHFlcOf6j3ARmvIT+GNMvM=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2403c86ff97so68654355ad.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933506; x=1755538306; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UmnhomKCr3e2ahj1QMW8pKbPe/+04IGBoELpRw2IfXA=;
        b=UHV4HFNEmWooJOst6Jgz9M3a+l/RajV5yfgz3m5Uh8CAbt+JFZ072TD8+RPcJvn/Xg
         s3+v+Knm1fZvtkSfZRLXJVEFHVPYe5ppQqsWMJP91uRy/vu0Nwm6teNEXtQS6pk+jPiz
         v0CZUAFaVLBqkd2iEZnpwRQtJ1ys8NBC4y+lSeF58rFWJ7p1z+FR0fr0PUg8eY0fP3r2
         gs4LE806Y4bp+6c7MsTh56My3p5gfDmfRGsJWtCw8PEoS8YIbjwjaRwQe+FELq+VOKP5
         QjDzIbEHPnNlGDX02R+1TNUNgxElOyaxoigsSZw/E2Kgxn/wvkgI2o5DAL68wYIOpVCd
         Yq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933506; x=1755538306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UmnhomKCr3e2ahj1QMW8pKbPe/+04IGBoELpRw2IfXA=;
        b=c2bzLWG/sF9mCZi+6LPQchsO0rvic87f1vUdcYmKKHR9bnrD7TnDjbHUVF+AfA2tdN
         dNxgSDvJFpfOoh5ZtyJ3ZvZT6rgdgC7JBhElFNaos50/KgcATOMyiGreCN1E7VMXmgAc
         4+Ge3n89Vg6tIpAIWrt81n9AyYUN6EGZ8GncVBhoSXhVMAX38ts0JOn4Wr6oAtKf3d9v
         aeVbDZMtlc+e2xZvpzOoSqHhbO96N2wKc4p3OqYTRqOS7Dp5XA0n+5x3EV2Mw4q+/Rf/
         81ZIfHMT8Go6GmCrmkMKtSvNDW8V47IPpDyf2zdSDdkO9O9PImfCugZ4CXnVKi6PoLfM
         +3xA==
X-Forwarded-Encrypted: i=1; AJvYcCXZwYdKPgSXvOjSnvm3bJl3WWex7nr6WNzNl8O2GY9n+jrvLVfjhra1Qkc/P/CLjtX+zuUhh+rNGg==@kvack.org
X-Gm-Message-State: AOJu0YyTWdNpOkv964NPW66SngugDpqgIiIo9DdRiD2iAbpbQBGkRqnt
	U77isiG61bTUxUDjqItmTjVa/23bNGBD2KugLnMUyPCGTMBGw9GqDjtUyP3XKA9P3cx2/m1Guy7
	+DIjXjQ==
X-Google-Smtp-Source: AGHT+IEbQbPObtr4lDb3C6IUSrTWzurWfQ/uCHMXicVSCI8UFHPyb3Vp4pwMwBuWD+yHcnEb6yN4kCs20/w=
X-Received: from pjsa15.prod.google.com ([2002:a17:90a:be0f:b0:31f:26b:cc66])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ace:b0:234:b123:b4ff
 with SMTP id d9443c01a7336-242c2011167mr203387105ad.21.1754933506388; Mon, 11
 Aug 2025 10:31:46 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:38 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-11-kuniyu@google.com>
Subject: [PATCH v2 net-next 10/12] net: Define sk_memcg under CONFIG_MEMCG.
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
X-Rspamd-Queue-Id: 7D357C0008
X-Stat-Signature: 8m6s8kbpbhhfhiq57zd84m9ji91eueua
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754933507-710285
X-HE-Meta: U2FsdGVkX1/2vEEiyf6aNOgIsn9ux6hNdja3vRpOpyEc6UfCxHwzpwUmd5CS9/+QnxMdQqpKpvJD6V7GGfd+jMYlVEqD5FZdSvz9A63BArLPcF+bxgKLk5sj4tcFrVuE/eCNeGb1NRWSuDhyh79EDlXjWVOEWSjnggSATQq90Za1N+lHqsPsirPZ2VJ1VUYPmdS9/byoh509X3IIultofWqY2wyKauHi471N5QEpmqn5rb8AzA+F3x+w8yl9D+l2XMCzyF+X8OXPMYojHwShnuC5BGC2i3FIXFA9MQOuihJTlSNko1/hool9r/tbWW4LFV0p4WBGO0vMfpTORtWU20NuJrvHwjBH2xvpu+eGdm2SYZcqjbidFj2524zuIe0crAkDjYmT2ApfZJpLVvcNSoz6TzSeuZvHi9vpRLo7LJgSx/wWcvz65fAsXJRAUYjjnU+9D/fbKewBd/hTV2UtmsKTMQsHWDiLBzwKHAMzvy3VBX5elyehnkVTiTYIam58HhlD7BkAnKR1J3wuOB61suUGS4sWe6Dvxzl4iiF1Xbr59RGyQ6W6HbxxKHju1nWjN+N9b6A9jbjE+0K3gBsHs39eVhW+sKjq7IP7FndwiEUYhnR4T7cpRYb6c8sZCfRgMUXEcQ7lT1UxKv+QBn5wm46q73JDMeFSq4WIiX8YibpG6xRIqiRsKkv3N5JLTTycIwwVJV1o3oxbqU0Xh5gF3agMTzJ6kYnZrIRH3HWPvBnJjJ6KO+64ULZwZzymp2lyDopI0Uq+Wx2eZezzXp7l2/TKHmYjgQdEs54wRpLNC/iwyCjcmY0SKHA4FFwc+Kw2fxxWamiXXE0o7782gsb2xjyiK13b8p+S3WMVHNc64s2XV2GNiC84BHGApDt46THnWY3KL8YK2xLgVsLURncNSH3lGTeUgI2n4eC+DgW7dqQMlRD6hkmJlRp1UWFArUQ9X7jQNj3qeZ78lPWL4/o
 3O7cmB7O
 2kyo5J6dGo9Rn+uAS0G8/HFoHZPYJ1mYIJ8Rv/TxB0ZlGvdm75HS7fD5SqmsLtPhOOm9+09z/3XIe1yaqYWVsBXLPS6wLF6UOa1eioC1e56BP0HN4uPgsIf1JoiixkTM0cmo1azxMfEIiBtM3jeosy5HEtCLrdGrBEOczsu7iDHlNgwkaj/fscsgD06TW78f0zUdV5zQhFieiKnf8QzptulWmx3uL41jMbv6ELC46HYP/6aD+DTrLEztIVD/ZX7YdGaEgCPoi3pqlPhz1Encuf9nklcNDFzxPimdYmDeNwMyNF4jz9X9VbiIsH+hhYts+Fy55I6D/VeNd314ezXR6djmWLUTpBwTJ3fgN3rDaoRmIZResXRrsclRc6UvcgA5JKBzcMYq0SuMBpR1ESqUkiruaFDkk+FNBsOdYnXykbSPQlpYYAzNLTEyiVOUEL3SWuLgRKDs0emKO5aSVYF9R3QCg5vJM/kfmfUxNCtflGWHjaA2XLh6sxgnsu2dAgo4Nikerdj6SX/aARzAZoHOIx766wZNKlYBBGD6vxqicbJ8gV0y2uiNP/CMjM3dgOSClFF6BAISWd3vIpVW8vqLaruBoIA==
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
2.51.0.rc0.155.g4a0f42376b-goog


