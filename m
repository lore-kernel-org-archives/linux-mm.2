Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AB2CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EA86B0317; Fri, 15 Aug 2025 16:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE5D6B0318; Fri, 15 Aug 2025 16:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676118E020B; Fri, 15 Aug 2025 16:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48BAD6B0313
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 178E51DC136
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:52 +0000 (UTC)
X-FDA: 83780102784.25.6CE0A46
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 55B371C0012
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Obqh1zKE;
	spf=pass (imf21.hostedemail.com: domain of 37ZWfaAYKCOIOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=37ZWfaAYKCOIOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kf92k/WXre/NA9XVBZNM2RHpUQnxne1oa7jt/AbjtmQ=;
	b=KAlgpZ2iMyis2ysrrRJkE5dRT0noTu5KopEFbgscUXXtEz4DEfQncSyk4GuYPJntu2izpa
	lOAKRKK76XM6Ofy8ROKlNEMC1sK9YHzUnmApWBKl9lOxpvK9mS9U1T4m2gfYC0lEa1z5LK
	KIzrPU5MJA+PtLGgjltlmtvfKI99LIQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Obqh1zKE;
	spf=pass (imf21.hostedemail.com: domain of 37ZWfaAYKCOIOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=37ZWfaAYKCOIOYRMcYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289070; a=rsa-sha256;
	cv=none;
	b=vz6tA50W85iHKYxxdHeNtbDU3H6odCaf1dR6iOiRdvBZTez2tomohXEGlXetuIPIv+rWxL
	Wyg6qzZTKxPgDH8bcACEK0nd0Al+7sQ2CVVMgZN04PbFfT4Y8PsoUpnrhalPZ+fffb1cQ5
	FFVq8sd6EqbEaZ5UhU9GRUMrWeqd1GQ=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e46a20so4334769a91.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289069; x=1755893869; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kf92k/WXre/NA9XVBZNM2RHpUQnxne1oa7jt/AbjtmQ=;
        b=Obqh1zKESvedPk5RfvAbsu8wJwAiaL440O5/LjnYJzJaRTfuJt9ogTNTMrB5Q4D4iQ
         sTJQveFL4erjmv3LfcR8K5WpYKPLjXqad6WImXA4ltJUKDkCkdS2heBstdlPH7qmAqDP
         q6Px+fERqDpOowCifsdbKo+FydWHZ1F7hptncKKPjCIHcFezUFg4tyBIeQY/v+sYbNK5
         fFLly4kjxL/4Ta6+SBZqYUt1+CBQjlAYWHky9OJ8bsDGt5ndIClD8ermP2kYsJxK7B2v
         DPdD4myvlDkSd6W2dy5I4VpqY2lvC4s4zWvU/ACFJhxIoRXmhQq2xIixlgd4iiN4F/U2
         6VlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289069; x=1755893869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kf92k/WXre/NA9XVBZNM2RHpUQnxne1oa7jt/AbjtmQ=;
        b=VW490L7IvX0V9jgCqTPVn0KShg9xQgH7wvS2hwRh1erj0JDQgCP+T05botKDdMye/Z
         usMDRSMsE2C+XCHZS07ubadgu7PmItc5iJyKu6te921EjbbR/EBlRniyyHoEMSl79U6V
         aBFYGqPAJB7Z9uKRIu5x3JCyrARqv2EdZr3f1BKrsXPZRuikhxTIdjbCypSwj32W464K
         1nSb6mlqBh1fHQ08KTggcV8o0PLZn2jGtLfgXYia7FjmoxMXapaAkPbR0kJXGFqFw05X
         1uGeACbYEclFOOFDvZCfBqPyCuSLeNJ2ixlzIuxT1N4lDfx24X4NbkxoYLaw9ZiCVV9/
         JstQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyzZuO2+lDdXrzBdQpX7FlN6Eze1ooe2kef0yUx1A+auvQCRQLTiqkaugqtGUTNzpOi2/LWnxhBA==@kvack.org
X-Gm-Message-State: AOJu0YzupfVxDgfMKo8qJssrKZjmwASK2Dz1JTTvpdCuWDvI3lMZdzjA
	La9WeAdpo8/PoTSfp2aqTq8vxwDlCtGRe6nYOms/rkMAUp+dh6uiIRYihIxMyy62DRX+CK/338D
	lJKw4SA==
X-Google-Smtp-Source: AGHT+IHqEnxA1uJzc0XPdj9fJKBo3wWRxP+lR/iywZBaE8USdSC80qtRAT2PdogMo7IxQ/C4U5ZzQhy0h2k=
X-Received: from pjbli13.prod.google.com ([2002:a17:90b:48cd:b0:31e:d9dc:605f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c06:b0:321:cfbf:cbd6
 with SMTP id 98e67ed59e1d1-32341e9b0abmr4796319a91.6.1755289069062; Fri, 15
 Aug 2025 13:17:49 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:18 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-11-kuniyu@google.com>
Subject: [PATCH v5 net-next 10/10] net: Define sk_memcg under CONFIG_MEMCG.
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
X-Rspamd-Queue-Id: 55B371C0012
X-Rspam-User: 
X-Stat-Signature: m3n9rn8g5eq875pqfe8bhw3mupwd199h
X-Rspamd-Server: rspam09
X-HE-Tag: 1755289070-904085
X-HE-Meta: U2FsdGVkX18e26W1CUDDNDhomIOJCMr95MgyGoAuQaulnluRi96OKj3QURU+P93som3KdmcJIoORVhfIUJimrZR2EEpmWKho164I3PhoiWsf+lkQliYCeMwbRSYOvxH6NA01JkyOORaXUqb3HdMRc4GLWi4s/G8tjyHyEGdjQQ0/RZMvFYBaoD++zOwtfbEa1DGH46S+ezX5buu/6a5aA1lRfuOfyv0/UqvV/UwEa5vCCivxi8TdA7nSTsXAEZoNgmG9pA/jbyr0qwb+qXPkUWQwp1pKp5inmRkCoMe0USehZ2/UUjE5csK2m1xl48LgP6KDQ6MwDwB37JPHUH0DSIPQ7HHZXkoe7zjh8fMDhufu62WXryDgHKS2JlrpaGbkktmgBjb2UaoMwCZiix3G86qoUze+b1uWK8WTzXrjvHI33AYGgWn4Pjnh+ZBcNC4jhcKjlVY+sIF8wPaAjJ/ichGfYbkVdMVm4PWtF1JxQgfG9peh+MT5Rnr6Pkm4NBBUYdSg81kKG8i1GCKDWOOBq0YIUXKSKq2seVEbf2kldYTJ9TvGexL3RoHwB+mH4BnXaC3CHQMp42z8PKhpoRVRKXXH3b/Bs6EyQTraeV4vBz6x0q5qiViWzafLuLTsOh6ulZmrWFH0EgdHEBhwHMwygUOV9o3vtgmZFZWp6uxagWP1c5ATFuxsDeNunoYJxga5IsH71OwITFcKBBCNsAE9CBnjOTHIUq0Wt0t6PfWWCWQ3oJ7B1ZDMIMYGhv8eDGRp+PrmTsJv+uDLgPHkyrSDxXDDKJ0WqnYiCEjBYA6dqwegEzOOiXIGiKHVgs4VGMZKOkIO64TL9urKiH9eY4nxFeUXxTa8RTLRxlTFx7LpSdfaT2WU/MZkpEiZxqDLH9sT5KUBpaPWSNJVuXogho0HSJdfbf6bYXTS903w7wbfYFQ3i47dh9R0/X7m3aKr+ptImrnVnnXEvN5ArkcUzzN
 x+SnFymE
 iv1BAKH6oFmcbiy7/eGIHMr1lqXDFjZR9k/yE2p76CjbvU7WkUVO/tSa/cAsYcvQhDufY4LDJoyBQQ++OUxdOR9hQrtqR/AXRIgsMvMmaC/xWE7MfovZNoNybPkkajlezxI0P/S5vx+zZgli7i0brHaVDnp6mYRKWP9gWyUNdOFy2Mn1WWiosqKWdssRL3WjbsCHqF2znHRMjTOdNT1NyKy6uuwSbgMCoOVMNQoeyA2n6dEFl1MnVqhr+dgikNZcZDhvzWFowceOv8q3ygTvPuxODjcTlYyXWaKcsLCmifUYLK3drY4BsG0H36j3hD4EPXiunNxKY3YSikpxCb4kOjVxDNOtfJ5Iho3ElvTGLwHkzzYAnF9AweFyFtUo6aWvTBlrFptE3+6O3FVHia+oG5iFHyz7/5LUBP6XOwxkRA64eL82QLuAAhEzRLcv0HmRQk+xt5uPCiGcYLRepk0piF1FxX9Wi1jkDijG5URWyEbsCV8+MJS1i8J98UebZRXeEXOxhNlIfZh3MeHrKLgw9+h8OO6hy0VRvLH6zTtUOkppQpm8qeODhfoX5f2jrBzU0mazMxZT5+1xD65r+xzOeBosllzPWq+biLbef9pPMuBSx6pzSMhFvBT07EA==
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
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
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
2.51.0.rc1.163.g2494970778-goog


