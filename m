Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3B0CA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EB3900011; Tue, 12 Aug 2025 13:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDC88E0151; Tue, 12 Aug 2025 13:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA626900011; Tue, 12 Aug 2025 13:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7A118E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:58:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90049114EC1
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:59 +0000 (UTC)
X-FDA: 83768866398.11.1FD29C6
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4278140005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZQiLgsUU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 34ICbaAYKCJsFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=34ICbaAYKCJsFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5967b+D6n+JBP35k0TPK9w7l1JYggqKd+S8TzhqKYXE=;
	b=bxG5AS/Kn2T8WJb+c9cgaq9w5AnczuwAqEQwnFWgyZcKP5iEj80toQcMI11voMQavJAOKO
	iSiMsNo6CALx1wOjGzaG+GunJQeB0XbZml1CuggVwtwUXy2b927Zagt3KoYo2GrfB4YVln
	rwGXzEkIoJAwnYS/j4TPienJcpJ5U4Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZQiLgsUU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 34ICbaAYKCJsFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=34ICbaAYKCJsFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021537; a=rsa-sha256;
	cv=none;
	b=RjJozrH885c2yYTa6qISupLiuu9HBwNmBOBO0gaGM5R839W6TyZueOIo662LFj8l7LS6Ea
	qJ9boEwPzySecLSSvhjN8ou6WdoRIe4DHDe03UuC0JNVdtACVIKYWk6wWTMz+0AjIxTePF
	cNA+9JQoqLoaHqHNBlvux1wobNqH7gA=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f729bf733so9947190a91.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021536; x=1755626336; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5967b+D6n+JBP35k0TPK9w7l1JYggqKd+S8TzhqKYXE=;
        b=ZQiLgsUUAWf5zwhNm9znrnbTNJ0tx8VOg3gj1a38Q0cwG6yHxVH39oFhk2mCF6dj9Y
         zeTZnKJcXDbdA0W/VvjmYJpZOyMyPJ9SFBzRlTlW3O7kHfjbCqsNyb3gLdVLwELPECsI
         D9Py4YNZ6e9zaOLOl/r4qkV/wDy5BwNDKr2v5QT3iDHXeBTfTyJDVv3JdU1aP1xgQb5i
         3KOkg+fZRuCvSpz/XHnT1KOGv+zTKIEOkVc/gJpWKgxNGzvMdIsI/TpIWsmEnRcEbHJd
         epNPlJ+CSL57fzorAQpgG21xnqbeZmdcsZiRkfjtrOqOzRtmvGPZNQkqmJiPvsxpz4BO
         8FTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021536; x=1755626336;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5967b+D6n+JBP35k0TPK9w7l1JYggqKd+S8TzhqKYXE=;
        b=aRWK1obXsycQ05i1QH9qh1wEgnCByxamDRR0Vz6Rfcm2gLmcfMBhYTdwXSv8I4cBZC
         JG3UDCKpmBVbPg3PhWU+R7tQbTJ/i0d+B6T5Lc5Xq9o9Y0st6rflk0LuwdUFw5urdzbN
         dPlIOU4dGtaElKDdkFlISYucYV0ROZTWX7Ful6H8aXyKsS0wHxr1EMQu5WL13A4ZP52P
         FajuY3u3WniXmlIkhJHlZ7FtTQVo0aos85NmuFtv/wfKPAus2Vey0qMkvmj4AAJVO0yk
         Np1kMaGi9ADVokd9xtzwOempD9zzzz2TRoq5n0aSGj/YL3DvWLmbhiax5+S0NTv5pcl9
         Rjgw==
X-Forwarded-Encrypted: i=1; AJvYcCX4fa1js2Hzz6eEufXyEVthrSCY+oREq/b3Q3/op5CCHR5me0NqG6DV+sbL+ScDx4i8l7JCVTjDGg==@kvack.org
X-Gm-Message-State: AOJu0YyddDZ1cBL+9RdfIzOJWLhoeD7f7+tRffj9z43aDr4fvB93Ok/A
	9mOXFPyaTGEvcdSbfGKQ1Sb8LNr8LRxO9jGJ8qd4Bin5ZzRv+rmjFbaF/gxRcfUdIVjNKJF8mKP
	6fRboSg==
X-Google-Smtp-Source: AGHT+IEHywGL60FQFSS0J0vulVLgaUAf9Fyk68Q4f3QM+UdkI4p7EfgIk7dpwlIPEPt8UyX87u+Sce3emJ0=
X-Received: from pjbqb13.prod.google.com ([2002:a17:90b:280d:b0:31c:160d:e3be])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:de85:b0:31e:94d2:c36f
 with SMTP id 98e67ed59e1d1-321cf94cc50mr651519a91.8.1755021536592; Tue, 12
 Aug 2025 10:58:56 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:19 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-2-kuniyu@google.com>
Subject: [PATCH v3 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C4278140005
X-Stat-Signature: r64mrkcmdi8sbwm8ui18c5z6s65d1jkk
X-Rspam-User: 
X-HE-Tag: 1755021537-371174
X-HE-Meta: U2FsdGVkX1/1ygPwenFK4qmIv15kRdPdGhGyHd4F1Ty+3B0wrN13I8e65ODv38vDKU9EwtYa6F/KJko/2mt5kvLUcz3bZuxisT06Sg7vKyaTvPhJ/2oVw33tgt45C2u9MLYAAW4vHWKspwUZalAzSJ53e7yzwatxP2kJ1VQiSasK4G5mf6ek0ca1yhekI8XPaE8tJPnvCxQu9Ai7KrE07xf3PNQ1lMFYJ77RuKFvuFUa9i41UEcpGdzjwuE4A6ukeTsoFV+NXyuVyiAN4hjDA8oQEcDcG7VZUjg7639Jp6ZURJQTZ9Yf2nHaV31zmM+7db8WF0iy+fVfPZ7eyL1VaLv1IkIVIH0NDbRpvjljkVUG8LggLDGd3A08IwPF5rP/6ELLpSngfB4RdjYSh23VliG/Aa99IcoXbdTu+iW8a6zKMUK2JHmiU0P5Xk6AkLhaVW9skrGeXz+eWZNM70OrWAdDOEP9Mhs/nAWjqzpjraWNDmUTRxLtwwc+I6Z92NMcJAxZBZOvldn7gp1++oQ9tRePjcMljkebgWlDJJDvYX3ryKLieLUdKp1Hcau8B3bNCkm6AuGgnHaVFDw3gjfYtSzSR+h+gZx8n6gjnrkPRNPaTXkjiOdo9FWz6ihmAtOtD/Tk7UqLd7tLb7mg5e20qKidBCWuBtAWE4IR8REECacsRfJ5J5eAxqulL8Fd6YU8xQC6w2t1exIlP35L+MPapgOdzIcIHVzIjYvcgjQ2i+XvrEN0pW/ajm71Y84gm6CI1x3XAiQx1vQEQgWeD72L2Fl84x59mQUO0TTxUKJ8jcln1auzqcDDSMUx3WGU9O+4ZEZYwf0cmcbvBAs2Y/24fYAdkKH0Cfrpr/ar10poGzp/PyL+/Z++Ryaxcc1vUL2sqkawLvDagXkabf+7eSrMrU8zb83ZYqsZ7neDVPcA+MSLw53aXeJne+NBQTRTyecsC5zQn9c/NmJ9jgAc7lJ
 wn5ocPby
 4lPIV36ULV90ck4oXqgZCu80yFL4sc89rr2w4nVinBBhmwB9N/UrON7M+IieCI4cqKS0yIbEqDm6pYzqkBo27yV1H4EzPVkGi+kznSF4T5OegDA8QFPkBJhbnFfga12q1SqDBbS5hnlMsEPUMNZfqkLWsADq9SwKXN0sqJO2KnjrPbQIQ+JgGyVACTFNOo/6fdjRbR4gZwdsikAQPPErIp1+ZN2vf++WfCKSk4i1clLpPn+0moQ9U7CbBGrXKZ301X7NEncsYvHKNbW5U0hIR51mUL4i+O75M+ur9cOL9ogG9Qp8uxICNqDarwaLhFk+GdezyTFiILFy+mgD/W3YnYLn2UI4cCxnCrX+yAis9dJ7ziFCH1n6baP8QqIjzffsDBvZtAcwQvkeaFTrCrponyHWxlw7BGEDRQMX9kc6RZTOmApzd8Sio467sM24KCYqLm+5HiCUICVPJAQmIvvwIIuXzV3OFeLqjsxsIiJGjlVcviLVOdS2bsDS3yqPk4BKalXOMCFT/9AFAM7cHk8J8r9B1dguQAkUS3pW8etp6/5nXEoU=
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
---
 include/linux/memcontrol.h |  6 ++++++
 mm/memcontrol.c            | 10 ++++++++++
 net/mptcp/subflow.c        | 11 +++--------
 3 files changed, 19 insertions(+), 8 deletions(-)

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
index 8dd7fbed5a94..08c6e06750ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5024,6 +5024,16 @@ void mem_cgroup_sk_free(struct sock *sk)
 		css_put(&sk->sk_memcg->css);
 }
 
+void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
+{
+	if (sk->sk_memcg == newsk->sk_memcg)
+		return;
+
+	mem_cgroup_sk_free(newsk);
+	css_get(&sk->sk_memcg->css);
+	newsk->sk_memcg = sk->sk_memcg;
+}
+
 /**
  * mem_cgroup_charge_skmem - charge socket memory
  * @memcg: memcg to charge
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3f1b62a9fe88..6fb635a95baf 100644
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
+	if (mem_cgroup_sockets_enabled && parent->sk_memcg)
+		mem_cgroup_sk_inherit(parent, child);
 }
 
 static void mptcp_subflow_ops_override(struct sock *ssk)
-- 
2.51.0.rc0.205.g4a044479a3-goog


