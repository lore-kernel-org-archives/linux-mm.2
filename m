Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BDCC83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CE1D6B008C; Mon, 21 Jul 2025 16:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6246B0092; Mon, 21 Jul 2025 16:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2CA6B0093; Mon, 21 Jul 2025 16:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01C6D6B008C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3497B6C13
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:31 +0000 (UTC)
X-FDA: 83689429782.12.8427E62
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id C873780004
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AOgsIVfo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3zKR-aAYKCFsDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3zKR-aAYKCFsDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130189; a=rsa-sha256;
	cv=none;
	b=2nGhgR3ZUHCXYXXzWd5013+lQLh1zYryG/+IibCpPIx4BWu9BnVH3lbP8xG8tY7ISyG8OJ
	AD1PGYJ7gCIOhZj1Y4nG1jcj8AGTneijtAvhPU664EMduHIhK+trQM1OA2ANbygwb91zTi
	LwfXmS0avuLERvQ3WdattPYlIHahAWc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AOgsIVfo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3zKR-aAYKCFsDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3zKR-aAYKCFsDNGBRN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P67Y4nPe97i+SWJPpvtux7JQJ2xYIXeLm24bM5pwnME=;
	b=8AO5veNZEucG54KQaYyhft4rlCEbCoVSCmPS9+NYN0GCqE/w8enwoZHWUm2osePp0MyDBu
	tYV3ED41kKAneIwQGOgdV4ga4F+xY0NA9Y91M6Ib+B3LI+rP/FkBlKw88b+dmrE1NoHfrq
	LT+shcVTXZhbzV1RXxEbDrADpeuBoWg=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c36951518so5326636a12.2
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130188; x=1753734988; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P67Y4nPe97i+SWJPpvtux7JQJ2xYIXeLm24bM5pwnME=;
        b=AOgsIVfowZSFScFyyp8a+OxmXGW9LXU2WDE4IFDyziDAWOfh7vP30rokU7RjQaPX2/
         q71aE/RoIXEEg4tIMn2yC/HS/OaOb0Iypy7cykNgMlO4qmMxRx4HBXV2YOS0THp6trJW
         gERzOtytwu9o2CNdwj3901UKyJtdwlPU/Y3cUUYHMrGYSonod92hk+qKLyynFTIngoal
         WMbNuhBCcjo2iUyNRq3vJXXN9cw4bd/aGxOMbF2gr7mJVc8IcWc6Kr/0QC05AGeRk7XP
         0oj/Nua/5tM91XjEaJvec6Z9GNSow1I7jBmzqoMgKw9GQuBT98N5umnS1THSZDz6YJuW
         Tmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130189; x=1753734989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P67Y4nPe97i+SWJPpvtux7JQJ2xYIXeLm24bM5pwnME=;
        b=hr3Lt/va052s6uf/vpuOZrd2eb0qdrU5p9WnWA4CXc1aosnxS4SAmbaXnI/nQFZe7r
         BQ8Ot2oEL8e5QuGR0liN+j+6FX1YZWWynDSR5YtxUdI1we8yOur3hmFGhcFZwZMePrG8
         VIHVWREnw4iqSoeO00zyViPyluH8n3yADnW1gh7H1TjWEl2BX8tgYFB/QpkntIPg4Ukk
         Q6u9Dpj6+6Wo7Fmu9jw73ny/lp32R+7qlWPeiF5NMHmO0aEl96knzRrpkofbC+Xdxovt
         cZlAgmz7ruccDCTPtEMzAQFtm3Qy6t4aJ1nPJ7L/kmJqH8fS33uL7mZwvtSiSLVgn677
         1WnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzOiY2QY1QHLiiDHrx/YDEeUjjD0oxHFJ1gYEfqDHX049yYsMVO5Wctj8voXcS5GybiTyDT86Q6A==@kvack.org
X-Gm-Message-State: AOJu0Ywnv66GAs/rseOiF59daARl2qeVb+dtf4+66dDXVlOSSOYmQhLA
	kONq3JF9Gscorin8lSzQuZ9oVxZJo+JxuxdVHWlzDHV5OVe27Qny0dCqvY1eQDXat0aT5JbHb6l
	RtmC9ZQ==
X-Google-Smtp-Source: AGHT+IGq5a7mBT9K4l6RJAVl9SuPJnfEZ/pSiUesxpLyMFOJ6g+rCdlI3WLMNPagI5cWYxYgX95XYihYFQ4=
X-Received: from pfbhb8.prod.google.com ([2002:a05:6a00:8588:b0:748:55b9:ffbe])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e613:b0:21f:4631:811c
 with SMTP id adf61e73a8af0-2390dba61fbmr26139263637.19.1753130188582; Mon, 21
 Jul 2025 13:36:28 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:20 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-2-kuniyu@google.com>
Subject: [PATCH v1 net-next 01/13] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cgdeu4zwwp6p8ibg6z5tfg5apbm4o4q5
X-Rspam-User: 
X-Rspamd-Queue-Id: C873780004
X-Rspamd-Server: rspam02
X-HE-Tag: 1753130189-629099
X-HE-Meta: U2FsdGVkX18jBXwvSQfdl6Z9GxpYhU/H8zNXzYZodsdy/qWeUMHJ99e2q4DJQ2IH6B6awBj26AV5xsJ+7TQkuIn4JMHrtyT0pIY7wIrkhQwOisAQyDkFiiCRtByeSe49DFL4h9SYuJm75SV+EJ3tbwodsq7fCXZD+cvvWY6V5XYJV0ER8gE8+BORKMFKvC3KOh7/Pi320wO/W/gTQUDk9y+BASx4h3ZVIAZc3hyvYolxGssA82EEF0bdIyAcb3uE7VHMmP1lFvBG71oE2MAV0SpTHWZ6fUSLKk5tNFYDycUwoZ3yO8dhg5hUYwmOTzTjPqWd9lwPX+WjcreoVOXLXp/omXnpczzQW9QmwRWC0s7MwIwwPFGRjL3L+sjIx4g3x2ixoC3c9Vf46TOMKBwFquZhvNRWXa1KWJi5voijsJCdAUfMjefcmRv8gS/bnOzuIAjavcqtI1e5jA3syruwSMsE36B6FW8LzImPK1z0Us0evlve/hYj7jSYVUFTqi9MCfLNQ6bhlNoSu3cL5eREdCzHIyM+dUQgHYXyfZ0A5GWeuQDFqF0ROUf5FJ6+qqGnSUGp18EQhXIL9cOlz0YJGDRzJajb8S4a1Ieqo1NT7DYqnMKwuLeeB3i5Jcq9gyE8jFnEw0c7ZWSEmtPz+rypZ+XZk8Q4pvtzKaeD1T1m6Gqn7xIi4JAu+Hz7vFrMBl/11pQe3h20P1EirVVKt23syPIjV47PeLsrHsw0dI/QYBAAvz6usMnjfZp2PpSQO7GAV1gr9hMuX4IQT7UH2MDXq3yEQ3trUz3KRytWIiTFegkA4T7QAkhrMDjr4YXKiI7DfQeJhTFYjkFWjlTAJNw6RCpEZoJl3I+ygi0xRJzrI+HhbpDe8Dh9SbjO7p8mFMroO0lfYZ7/qWS2eWLPso3KG7068f+2ytOfbyc1dVmhDHRvhevT4itRBF/UaXFpenZWU6doR1A0GNQjrrV/t+J
 NNS8iHdg
 pE9GiBIynOV7/465H1iN3FLlTkJa0I21PYU2f+EWdvsXPR02m1sGG6IVYWRrjuxlEhNOOHmUahxh8/c10j+cgw67FGonD7fnH6Jdnr+Bg55JwDG/Q8gquQtzs6PM6dks3REY4myWK6bmCbV42TnR+36BARMJtHZ8dk7LVm4JHqoHvI9CnQnr4wqKBHa1b+mv/mWFxBvbkjjlumrB8IHiPno5NSXYhmlxQqVBIlX6GLkqM0hjUXx9rsISBgQCk+89X5vFUA8fiJ+12qkNRQfeVJAsNdfZ9+TocqmD8CO+R7E+hpV5bAdoXIyXjk1oorG3gEI3nnPNJM5MK1WeXlZnsvYfsa4ARldqJxXUnDFysB8rHFGfdbBXmBFzL4oZ/6CxSNmMD2ZhDKVi1F1wFH/Q5ORECFwQ4LTj0ikymEHN5KpfoHlhJbNShSZw76mIRQHYGWoABggiiCOqWKDNCL8tw2k6de7ZWc8VjNHzhNv3HGPrdTcgTdlantjvAj+hOhOh16oGK4Ptthr8b9bEvGfDsk6ugcpxR7NI4FsnUsGuBTFncYiM1OQq95e/FaH7snWXs7NEAu2ClgZCrGSLPVkhZMjwMZQpC8cFoafESsaQOR3YycCWmynswrqbnoA==
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
---
 include/linux/memcontrol.h |  7 +++++++
 mm/memcontrol.c            | 10 ++++++++++
 net/mptcp/subflow.c        | 11 +++--------
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 87b6688f124a7..d8319ad5e8ea7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1602,6 +1602,8 @@ extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
+void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk);
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 #ifdef CONFIG_MEMCG_V1
@@ -1623,6 +1625,11 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
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
index 70fdeda1120b3..54eb25d8d555c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5090,6 +5090,16 @@ void mem_cgroup_sk_free(struct sock *sk)
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
index 1802bc5435a1a..f21d90fb1a19d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1716,19 +1716,14 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
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
2.50.0.727.gbf7dc18ff4-goog


