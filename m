Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A667CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24248E0080; Mon, 11 Aug 2025 13:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4748E0060; Mon, 11 Aug 2025 13:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C648E0080; Mon, 11 Aug 2025 13:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87F5C8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50DAB57AA3
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:35 +0000 (UTC)
X-FDA: 83765168550.24.D91D367
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80C69A000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="HP9t/FN1";
	spf=pass (imf15.hostedemail.com: domain of 39CiaaAYKCPklvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39CiaaAYKCPklvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zi8XD71jgjXMWJD0GQyZXVIV2qpgVtIymKBEzG9L4F4=;
	b=auBkFCCqgItdm682uFesTZ8qr9IhEUvh4cMAwUuB8nlhuaTtTKbRAlXMWfC75JNvZ5aMNF
	msFBFDWzsDnmgnU5pmS1GVNbdlpipd8r4lEWeoqmE9AJiQpq7TTbuqJ9TmxMRZY9nHzAyI
	NOLJ3m0WYW87lE4PhSfC8fASSGYo8tI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="HP9t/FN1";
	spf=pass (imf15.hostedemail.com: domain of 39CiaaAYKCPklvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39CiaaAYKCPklvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933493; a=rsa-sha256;
	cv=none;
	b=MPCkOsdM/ClWL/24xW1atPSd2LXOqnsUkitLGXUM5EbeBOBfWHXGTjrCcxBzfQtjuWFo3h
	iiO7zRFB8/11JYgPI+w5+9zoDJCNXK8Qf9wKnsdPaUOLmpCLZv18K2lKh69MGX+wFyEVrL
	QX0RVFrhHexgwYHwAiZsgIyR6ytszxA=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74b29ee4f8bso4695639b3a.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933492; x=1755538292; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zi8XD71jgjXMWJD0GQyZXVIV2qpgVtIymKBEzG9L4F4=;
        b=HP9t/FN1XgIG0BjrU+Yd1a9DKRHxeScLbD/Ao3rbaXZgERQg98hAsZ8tPPyWFLTmip
         YseQNXdQ5Q8ZkidjJ2R5JzaqPDUR+m31Q6Mv82wivppbkRqTzYVC/VzR1Q+Qyn4Sro4w
         4CEZlVLiWI8jIuzIvraQw9rkfdL51TaOzDv/yu/MzuTF2to4AkuB0VPqdO6xKnb2+3ua
         4j62eBlLXJQNQyKhq1FKr5I4i6qn7WmQyPSqXOdQNufVWJxOgBTVMCn06MFdTfCcbVtq
         KPUem4oMFxy6+R1uQyuk94XTTQsiWX947H/TD+kHe9VxeQ3wsGjk4hj1fsoni+Rlt0/F
         ukKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933492; x=1755538292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zi8XD71jgjXMWJD0GQyZXVIV2qpgVtIymKBEzG9L4F4=;
        b=VDTrGNZD6j+CAcY7T6hv7mgomPoUbbaBkHTLMEeSo/FRduFeEo3nAvXbkm8AeMV8Mj
         OeX/CRRyYLqMU0EwoB4M2Jan5KlGu9pJc5t8tPGJbEwr+1cdwRbW92botmL2JAZi1PGE
         9WPFcCv9TZdBzD0RJAXVvKF2GainiWW693V7BGMZmwuVm0lmkHcV89qXXCDOEe/v6QHe
         oX9Zqh1BTSHj4deCRTOyNQf8YlaHNN8j4fIAwtB4jIsrD4bZTrmt380OwL7dKbGqfExb
         hHPS7Rrwp6gjssS4OO/CpH6upLia0uXRDE1fERIHTQ3JZdh2RxfioAimevjqYkG8qgj+
         QX8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX2Gc8P5tPrhBuqystz2PhNpuz7QEVW+vanNq37TakAwEr3X/IektXa7loT9fCm4QUFoxbXXNr6Nw==@kvack.org
X-Gm-Message-State: AOJu0Yxxqe6eGs12iMrK2jIH+tXxP49WZ/GLrTziuFf5i8688ojyMECZ
	7PwUrE/0hjZq+392MDfMCPuJJymbvmZZVXjuIRdDhe1XqhrNWslcloL7O4gak1c00dXVj0fIWue
	0PEKgVg==
X-Google-Smtp-Source: AGHT+IHo2yNLTeCJQnssS8cRVh9LBZumUnUBfB6vxpMn5hTdAQ6pUphTOW3txkt3Suq2A0M516UNLF041yo=
X-Received: from pftb15.prod.google.com ([2002:a05:6a00:2cf:b0:76b:ca57:9538])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d1b:b0:748:ffaf:9b53
 with SMTP id d2e1a72fcca58-76c461af0ebmr17005996b3a.16.1754933492214; Mon, 11
 Aug 2025 10:31:32 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:29 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-2-kuniyu@google.com>
Subject: [PATCH v2 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
X-Rspamd-Queue-Id: 80C69A000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: njih5dfge6cqjae4we97ipgu6peoxb15
X-HE-Tag: 1754933493-843467
X-HE-Meta: U2FsdGVkX19rDYiKzs04ZEo26jOXdBBqHtRrrc3uLlbC03vqLyg6goodr9pbw3bC543deXvBfgXQ9zk9Py1kCK1oJnplYwRoNBH6VDQVuuQzPbDB+450ll46MOnTBi1qCTmwtDdiHEo2V0y+4X+1wcaa0wIYCdmN0yJGkVeVcuDTXMH/esb86D+RFd/4C+pqymcY77q/JoW2JYO4s2j7Y/b6brMmNWuQMZNeVPfbrJq9A5A2f8jr1ycdf39OIrNVcwS6uFjLawUkRMFL4lYZY5t1YX1VmAglqZGf2Pl0YlVwnHbcBe9NlLTHQKWa0hUhqo1AN6mIo6m9ViYAXtDHCQhxKiH/wIWqSQtk2a6yUIhXMio51UkIrSiXQeA160v8O21PBQw0p0Tyoquwj5Y/Zldvbn2P/T+jAZ5f2XJqN/j79F31ZFOrJI/+5mnWpIVovK2GgLvfcvQ363w4POWFXuQWFWJN6TfZOHh2NAOrRZ2G/J/J+lbnYNNFKrHvdxCZroK/XA/M4Ozx4RTzsUMzWuQ4dcnCQxNkYi+P8EV4qQMcU867K0Iplx6b7wUUelD0sBo346MDCv9BZhKYN+62O2MNzum8Na/iDaq7qSirrKjvrCW+YMgn60RCVbbGDRw1ciFPC5oSGMWl9pdNYuTzL2dkkTLlZZ1Xb6/Rs7QiRtitshDKgOY5wnlq5CvyW04/01VeIuq8IcAoqsMgx9HOdWWt0H1By/gWH875miAdcKX04McySN9qlzrz1B0EqctdK2+xFwZkxUhoCGv1nWJYOTWrw/61UZAQBgKsL58Gyxdor0f0S4k8bF7x7Bl+8bZ49YJNEGF9WkFdqoMAhq1jyLSLYjlmDheMuC9DxL+eds+tz0acQIBYqBF6EZ9Lmgoz4W+IlOdxEUmU8wHQ3h3SeePK91fMEjNVzh5mRFs+oWgzEAQSHq6yobWi/khQyt2ID6cKSGhPcYNu2SviKvd
 uGG2300m
 ItPTTeOBgOxYvI56x80pE2lR+lQUllLW51bXSiz9MftsmMu5nYIiY8E5cYJXjrc9lLiymHlNz0GRonhsFEkm9n5AHN5YjsqaO2UEzbU5JBcmK8MkTcqxlU3SCUqtrqiM6HjvPVMbNtOBUd/ruXEB56Z6CMCMvXEFrHaX8caGBcy7OqvCH9ZViX7GO+e4rErf1jLAh7fkQMgmYEeRKm+fQYSwGXvNve9NfjnSr/cOyzAYVfWNTqiciGfhQ6TUXpkAGJEJ/02t662jYVZojde6fEoQFGahfVTs/GFii94RifqJTQsXDEDr8lfFZJCyj74+mJfxQdbhT3mO5MKXZHhdpZ3lBx85z1O5WqtfFFnbPY+vXpl/hxmSlrdh09QPT1KOpU27oGpuxpyB0E8zr9ScKPHGcKLpgTZQzh47LjDmaXHUmOaOQlelKgacNnBz2dGK4XgkL1/KyQ6jtmT4bvm5/BouQZRxPYbYm0knV3REIT24R2uBfzXkY7G7p9njlrXnDRe5XuLwcdAgX4/zpjv5gDiTRR6Ss1rEB9JHbTfDjj3/WUUY=
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
2.51.0.rc0.155.g4a0f42376b-goog


