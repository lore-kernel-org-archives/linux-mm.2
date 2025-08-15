Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B4ECA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013346B0290; Fri, 15 Aug 2025 16:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25D46B0298; Fri, 15 Aug 2025 16:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED996B0291; Fri, 15 Aug 2025 16:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAF4C6B028F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 854A5C02A1
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:38 +0000 (UTC)
X-FDA: 83780102196.03.89536EA
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id B04BF40008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MSMXWNlI;
	spf=pass (imf12.hostedemail.com: domain of 335WfaAYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=335WfaAYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmaKJoKwHw82XyXX/d5iEOMfvSvHT9xY0QGibQUjsoM=;
	b=uSHjjT6Rm6XDOVx0mxdJ7Y2k9jDxJIX8/MFwsAeKCeyXKOTwQREdGx2in+uO7Px6JS4t4G
	jpsjJQdpzQF5aOt6hVdHNOWARP5pffxjfyuz/RUdh5/IM8o+ih5lFX1Aquht3HmFRF0lhT
	VcW6Q8LQMK7q1a12AB1EqmRUmHshqrU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MSMXWNlI;
	spf=pass (imf12.hostedemail.com: domain of 335WfaAYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=335WfaAYKCNQAKD8OK6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289056; a=rsa-sha256;
	cv=none;
	b=MmOt5iNyGg7GYLwn5Mdm8LRf2aLlm2gxoZaRogXlJARltnnhKr3DW7TBZHNMQXoQb5EwxS
	PXx9sVVdDsz7UbYJnULO54RJz2FEBZBM1Ou6IasKnuynhHXLvc7MIdcVyOl5fl3UP5cNGp
	s24ZQXGWmtxnc9cnqTS7Qt/S0U2GHKo=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e0c0baso2360530a91.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289055; x=1755893855; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QmaKJoKwHw82XyXX/d5iEOMfvSvHT9xY0QGibQUjsoM=;
        b=MSMXWNlI2HRV/q3fqxKQGRCO7JGR2WAHShPkLo15lGRvD9+E/gbymR54t3FbgaoTVx
         f5vMV1cP/u+QLB6vVQpAWdVq8v65Id0aO4PBS+EArIm8+F6wzmp6S5zcuCW21zLab1iZ
         nOvY4bUwSP6aEQm29E5m3JYvI1Dl9mc7z48BZdDu8o+L9Ad0d0x1aAJPCY6Gx2hvJi5k
         lnyWhnOG0A0AWEpP4gy4dWW45p4L5VVCiq5D/aIZVgBrNEW7fTJpPS4hRi2bWaSzR4gD
         dexAv+yKy2d5FTxmDYjR4VCXtZ8zWLpnqIWvhj9GM2BovsL0+gbN2xvxGOjegarY2V3T
         nEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289055; x=1755893855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QmaKJoKwHw82XyXX/d5iEOMfvSvHT9xY0QGibQUjsoM=;
        b=if1J6cNnkDUzh0OfCsDS6jiCuwV3JduiZ0O+QjI+3r9/srGlDLLicmgIODVn+M4bgg
         xObcGG8yWJa/q2x1TwSvc55DCtWzv0mkvhhg3W6zZo8BRtI9jfIUHUKhS+xy5cGIocJz
         Eazz3Z/1MZ4fIC91t5NsCZ2n+GENGJ02K4yyRiCLd8Ofvp25ZqKmSCFKi9BGOa6BM4l8
         Hv0NPmzfkGat5MNw5MUXbt+9YaqbSCmsfitQr9UX5AntdIZUSbgH6wNimx5JHP8HhuCV
         ZoZc2DDVULEKKzMRqiXlxlPHWrKa7YhZCLXmPyUYEm4DJFJzga5FuxwpbaQvZJY3NC70
         qGwg==
X-Forwarded-Encrypted: i=1; AJvYcCUJAIRWxzAOhprrChMSlEpK2/4NZZg3qXaJpWENmHeBo3H8EsjAkgPYZ7Eso/p+GyiumBOr6ZU08A==@kvack.org
X-Gm-Message-State: AOJu0YzvnzT3doD+qULsv5IiDdfhtBmRuISFwvkQQLugpUTbYtAvZ1NZ
	nqMxQckXJBKUx9jDVjxTjDeZHIV7ktzMPxrgDy0vRCah58EM5Z2DiwLD0Y4xPrtnPpBI3dvl+do
	o/xS80g==
X-Google-Smtp-Source: AGHT+IFGdAKK5lsJCVHw32dBU/IQeIjE5FuMNI2s+BoaP+r58/XH4MUq0ZbtlmMZS9ZWWTLlSD916PektfI=
X-Received: from pjbtd11.prod.google.com ([2002:a17:90b:544b:b0:31f:2a78:943])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55c7:b0:321:a2d4:11b6
 with SMTP id 98e67ed59e1d1-3234db8e481mr643458a91.12.1755289055548; Fri, 15
 Aug 2025 13:17:35 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:09 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-2-kuniyu@google.com>
Subject: [PATCH v5 net-next 01/10] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
X-Stat-Signature: ohit5bond4uya39ydhdsph4tay7ui9ew
X-Rspam-User: 
X-Rspamd-Queue-Id: B04BF40008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755289056-751890
X-HE-Meta: U2FsdGVkX1+Ki70w6Sn/KuntR0m9P2s1qWUJDbzpoWqXwNw0X8BITMD9TsqbkoZHq7alZOAsV9QnNQkVRg/+l5IYkjRQzHdIz2K7cN+e968lOLVCD93y7/tOy5Xvo9KEd6EuyfUS7lIQ8ILLa2YEirWiDgfguwdlyNysuWPk15MGqMXhebb8NE0RiiCS6eQLTy0OKrmqFk5qloetimtWHSvTbBwuQY8fyUs/OsiretrXrJJKRBGHqwp1m20lDR1HqlgvXLngtuAX/qLHsRR3oCcT6b55cxT715b5IBKwEUNQhkVJlTrvToKnFb7xfBiKfUJTo5T/F0I7rURAHu+KUw/eK/5mbAC1aIrbAjxyuQ9v/x/i8xOY+PT06ipQc+EzaG1MJs/5mPb9fs4a98/AILlbJqb/+vOirJ7EUrirlcYfFSJgGRFU2duFfeDI7nqwMsANM+f6DYhnDKnVpiueTN161Qv2L4/E/Jm3F3XD3+ucr3KoR6E1tgjOgSAmEZPQAgLegteaLO27j0ZImPsRNy4NxDQrZdL+UfFG6V/qbmX4kkamVfdRQqLiRDaRmPUywce0DjHai5fS9FzJRmKbnnEYOBOJKor8hlSFXUicqfUTmwl+QAilwCtq4SjRXoCbTcOc4vtvyNhL83YL+3CbZvCFMJY4/Hk+UAOgNFvQP/eVyy7XJZBdiRat2pT4DEEsQlD5CgUTfhqoJ024SSuRLv0RkgbAOvMfDoxHQorGS60xAVy29jYWUdcrxEwMHsZR2HJy66Q4oFJ4xt7JnxWMX5L7haABaZ1Yn+8c45gtIsNYc5qE/4lQsCB79eAX1gg3Q57KxUv48D1rFJZcx1SBETC99qTS98NvpIwGnOlTzHmGuvSUnHjBaRDDn8QK0SgVjcA7fg7+7pQW/PdXTrniCjJd/1qcm36M8tEdYCJyOgzy/wTvjP53PnZXYfn3fkqvGgSqrS5blAyDBX8Nub5
 s1gH9lf4
 vzE6TCGzsZM08kOskDVGwhMPql4aVTkTxkphdTx4YHYgZUtlSdSsBkFPHNluYc8mTk3oqhJJ/vi/AWXR1HM0sAG4CHWUztIDHCCLx9kmnrG6TAHbMqE8lBUaV4VBqHj9/hWV0yGouR/Itzo3axJbYDa673A1Cz3syTJ771FtqUc0zyhIMLSIOwEnzXGV5Z2oRvGYDKXCj+b3SfTjiyUQoBRHjuJuTZuN1UF7MRgkehAAf1sie2jznzc45MHr3dTBcFGL7lMQfbH5kFV41q+UWX/2zPQmfMlXdjohMeIXFTI/sPH71l0UdNuaOEODnUMPy8OonTpq/iQepbxe/HJ/8NPbowE5rWxasAszJG0dKNp1gR0m8aNjBbgIt/MdJbi0j/E6wYWKd6NJurz5llnxnu0fGO2xWRtqFi/HqgvQWjM/gSprnZ4LeUAeVua7XqMg1gJWP5GANbOVNKCAb7aKcIavLh+LS6rYcTMhlddk+jY2N0eiH6s7evZ+cBtmC5Rs4+GmBrvn3Gy9/N3INvp8c7wKB3/sgRRGjTQEusFasgeQCifusfofHz5+anoRHyNYAz4hP8dctcLFr8g/DzmNmh2u5BmtaDT72wpjdtBBL7TS/AZU=
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

Let's move the code out of the wrong ifdef guard.

Note that sk->sk_memcg is freed in sk_prot_free() and the parent
sk holds the refcnt of memcg->css here, so we don't need to use
css_tryget().

Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
 include/linux/memcontrol.h |  6 ++++++
 mm/memcontrol.c            | 13 +++++++++++++
 net/mptcp/subflow.c        | 11 +++--------
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 785173aa0739..25921fbec685 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1604,6 +1604,7 @@ extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
+void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk);
 
 #if BITS_PER_LONG < 64
 static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
@@ -1661,6 +1662,11 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
 static inline void mem_cgroup_sk_free(struct sock *sk) { };
+
+static inline void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
+{
+}
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..46713b9ece06 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5024,6 +5024,19 @@ void mem_cgroup_sk_free(struct sock *sk)
 		css_put(&sk->sk_memcg->css);
 }
 
+void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
+{
+	if (sk->sk_memcg == newsk->sk_memcg)
+		return;
+
+	mem_cgroup_sk_free(newsk);
+
+	if (sk->sk_memcg)
+		css_get(&sk->sk_memcg->css);
+
+	newsk->sk_memcg = sk->sk_memcg;
+}
+
 /**
  * mem_cgroup_charge_skmem - charge socket memory
  * @memcg: memcg to charge
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3f1b62a9fe88..c8a7e4b59db1 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1717,19 +1717,14 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
 	/* only the additional subflows created by kworkers have to be modified */
 	if (cgroup_id(sock_cgroup_ptr(parent_skcd)) !=
 	    cgroup_id(sock_cgroup_ptr(child_skcd))) {
-#ifdef CONFIG_MEMCG
-		struct mem_cgroup *memcg = parent->sk_memcg;
-
-		mem_cgroup_sk_free(child);
-		if (memcg && css_tryget(&memcg->css))
-			child->sk_memcg = memcg;
-#endif /* CONFIG_MEMCG */
-
 		cgroup_sk_free(child_skcd);
 		*child_skcd = *parent_skcd;
 		cgroup_sk_clone(child_skcd);
 	}
 #endif /* CONFIG_SOCK_CGROUP_DATA */
+
+	if (mem_cgroup_sockets_enabled)
+		mem_cgroup_sk_inherit(parent, child);
 }
 
 static void mptcp_subflow_ops_override(struct sock *ssk)
-- 
2.51.0.rc1.163.g2494970778-goog


