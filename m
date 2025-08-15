Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB76CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB036B02F1; Fri, 15 Aug 2025 16:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674A36B02F4; Fri, 15 Aug 2025 16:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED8C6B02F5; Fri, 15 Aug 2025 16:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 319436B02F1
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED6D958438
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:45 +0000 (UTC)
X-FDA: 83780102490.25.237FDA1
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33B2FC0005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AVyQK0N4;
	spf=pass (imf10.hostedemail.com: domain of 355WfaAYKCNwISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=355WfaAYKCNwISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEvnK6Pj3gN8OdhZL7LCF5Umn99zHVRI3UVJuWX8S7Q=;
	b=UD6NE4Doz6trJXGSp8W7T2iDouQ30LntZDd/TkppSpQ0Qk99/FfL1o/ASkm1hdvz1Ynmbk
	jMQImW0LsOXg/wasPOPHWJFNlNTC4rGdiDUwT0VYWn4wxvR8CM8G8EONQp/745HXXqQ8QE
	B9yRWP0+W8LxEip9CXrlUkNaDI07taM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AVyQK0N4;
	spf=pass (imf10.hostedemail.com: domain of 355WfaAYKCNwISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=355WfaAYKCNwISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289064; a=rsa-sha256;
	cv=none;
	b=llDBiFPGAjjjDNhY7B8+5wmd9XeM5uU0tGti+37q8iVRobEZSPwUcakWUViMIsnwAhSzwC
	wFqILDJVFafXqwn052J1BYSKNvId+bugTpEJ4EuknXMqaGWz75QoqQ+p0xsfG+xKSA4pcB
	QHGNTSm5iTwYyEHugUWBQiCQ8vcVG1I=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2e614889so2160213b3a.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289063; x=1755893863; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NEvnK6Pj3gN8OdhZL7LCF5Umn99zHVRI3UVJuWX8S7Q=;
        b=AVyQK0N4y1HPWpXYtAg74PLwLQD9zMDRRE4eik6zfpps+iHLFevl2izaiRjZ0mmTYa
         4o9Sl82cl65RE3ScJBYq0jDXta5LkF50Ix1HFic1L+qfBWyD/vqMzHUzcDaFGsk6gbn0
         vrvUYR2DMvIfBgFF07BwTtY3w8UeF5cR8G6BK8kl0P+5fhcXXaYVUNEoWxtn/PYjD2P+
         GP9V208JkF2YLfo3yQoL5OeFWJ7kEQb6fKILoDtTS0heKAU0iANv3vGLwaNSUnwJDDcB
         nLAC65F/Fg2Lr+tLLBHSYRUgOrPo4IqO35qgyZorCntWLqzC4ANQE5NGKXPHATDsnFud
         nORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289063; x=1755893863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEvnK6Pj3gN8OdhZL7LCF5Umn99zHVRI3UVJuWX8S7Q=;
        b=qT6EwIxmQvHdsCMihgHAXrta1NL0MbJH1i+sqfC4dVruJxlSNMtd7qchLkwJvJObJW
         buGYsxjMDiDPzyb6j85J8LddI8fsDzxyQn6/h4mlO12FQpxyIjPQNDMkzXaeR21ce3no
         SF+g+TVhARlABCnCL3kF5QXhFkOTz06EAkH+WY8V8m6jQ482Gy8344tIUxRFOwy8Ybja
         cyV12K17vlp6JAmo1QAqGS+7+5UOM3NK6Rt+mpbNKorPdGDVxyjZGsFyFkL2dpYHtYbV
         2jAsSF5iNNjGtbbq8rrasw5rJ14TSZZ7YoGgHZX7myJAEWJ4f8IGKzUrqnE8pjXKru5b
         l1Ng==
X-Forwarded-Encrypted: i=1; AJvYcCXQmIvxvZEPtBCsrsAlDPZPTYuFbwpU3Q8dvzPpyZTWTZzWlTyVPVB1jgy+Xa6uygyUjOlxlhO2DA==@kvack.org
X-Gm-Message-State: AOJu0YxGwTINHpAZEBOgG9Vk6G5xvTQ421U7lUtkXpKfSqizy8p92vBr
	dTr095EF/qII+8qOyYob9nPIFQ1npddJQbTq0+vVAE7Lvnmht2nVxXLiC2Ba4ZGTRLqO76KVFsK
	gICE3NQ==
X-Google-Smtp-Source: AGHT+IGxIv0S/KYNNnJUfMwOQqTXy3ZcIqfpFjU2Pag6qHi+6din+ir3U6VMwmjnJzZZKWJVJdk8nIATIm8=
X-Received: from pfblg21.prod.google.com ([2002:a05:6a00:7095:b0:76b:d868:8052])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1391:b0:748:323f:ba21
 with SMTP id d2e1a72fcca58-76e516e9174mr461779b3a.1.1755289063124; Fri, 15
 Aug 2025 13:17:43 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:14 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-7-kuniyu@google.com>
Subject: [PATCH v5 net-next 06/10] net-memcg: Introduce mem_cgroup_from_sk().
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
X-Rspamd-Queue-Id: 33B2FC0005
X-Rspam-User: 
X-Stat-Signature: fajz6wgk1h55hs4q1wq1qoybatssuxza
X-Rspamd-Server: rspam09
X-HE-Tag: 1755289064-487999
X-HE-Meta: U2FsdGVkX18vW2f0w4yH7+itSLfmnzWNMSp3O42Ywgcwm8PcZDz8dXHc0HPJ2QBxNg4Wn2IIgaQHtLm6wLxqK8qAIN3mEQfWKj4AwsMAHaHtr9qipkDWbgadrK+bVkDFjT0/RgoqAQZpcQj7jvYPq3yNlOqdpkpxeUeAts4xsJA3r492Q9rGXtGNuhA9xsia3DrflLVmuQek5wJyhhPqlZUSjALNXxkP1CTL1DgtuaPT+xsHR5kyTZuhO/pWFGc0Bw+3ZF74n1ZFkho0CCqt3a8IVcu9rvtkM9Fr86UZVOCBHoDCMyjkXzxweL1SC0znX6MMTvb6sOjk1EOWhTxkLL3Nmv8pOJ5fQK5kd8NE7zDAVbwp7//xBnEaBJ47BOChuAi6XldSt3BiLoZkEDjvyHEsPH4mLicVanvuITGCgO/mjVd//XSw3LqjYbuoL7q/veR7JrCppsnK/LCOGH/mMuP5GM8UNaRtqryRwnvOWm8eM9EX2EyENGa3YwwPk3PJGKOU0KvlvgWmq6DJeuaDXMb5yDph+HUiaig08X35oNnkWXTvVnaa1ptGbVoPwe1T67Ag1acijniMJMt9v6PFkLTdtfi9M6mBKhjHHkotYJYbQ2xINinzzIkIkRD38K66QRxyqid7VkEWYB44JlxD5ayT9+68NPRpjr62UT9DQhz9q0EWONGE9W4uR9LuoleDQaIryo03CXT0Hku7DYxV725ST3bRpglPQem6r5cutexK2IqYbhfYZewRmmVr1Yl2CN2ppSpJlsCFAdUcU6Ng18R42zpom3BMSi/GO4lTsyIHo4r31dl/30FIiIMk2BtK+IuhWKcND7O2Q0PTlILqzkL4LphwzIJszmLLtiLVN3yHuWQF+g2GmZ6XbdpPgvp+5NJal+vL8ZmnuQYv267vjaKQcRFDNXuYTNfbKZ2qzLNIP8oJlAgR09mabotUd2iUSBnDL47gAwu37Oh606E
 Z4vF6pVo
 DXXcrhqlyAaEMF9YMLJ/iMMkwkh8hc3NnfUlq7qMO17u2S1yl7YB6PWISI3heypVoYnmD69KNnIoW2XcwnZDgVYvNQCac8T/t6iumGwE/D/zqELA+kOL+mFNGzKo6xsuKub/G3r/l38I1yoEUs9gV4URxtCccjQTl66nct9ksRDjU/f4hWhV8GE+Oitn3wLtxqyFEMaQpqr0LvFvMKfQTIUfQjBQHwkbDrtqDw4IS4fv7nbTNHvN2VRCwwGe0ak5Fl6EDsFzJPSskUz3C9MLKgKi9vrucs9uGuO6ztUJGYdHbFr9/VB+4mdhzyAbkfNZCn+OjJmprz0mxZahyrLmBvJYRya54B+thCZ5MhVma/mp+y3+GO5OMYJNBGB5TEWlGZSCYaOmq2L8GWH+qy5CSdNCv4+5e7Ivumc0mUsI204p0rZiMcQl+YLIpZb2ecXryrK6JmLiWny7Cu8j6/UC8B7A3EYNDfCUj+i3m+czUP1UTSaTobXLH2iUP5UO4VeCOn5zw7BogAKKnZJavqcl/vYllZ0s6Mmg8PNPY4ytOIVRLG939p6RhHfhMPFd4kCMHXX1LByyxBLb0Y4E6KFsig5tHho/BbG0sFVYsa7er+/QHMlhvkxpX/a/fUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will store a flag in the lowest bit of sk->sk_memcg.

Then, directly dereferencing sk->sk_memcg will be illegal, and we
do not want to allow touching the raw sk->sk_memcg in many places.

Let's introduce mem_cgroup_from_sk().

Other places accessing the raw sk->sk_memcg will be converted later.

Note that we cannot define the helper as an inline function in
memcontrol.h as we cannot access any fields of struct sock there
due to circular dependency, so it is placed in sock.h.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/net/sock.h              | 12 ++++++++++++
 mm/memcontrol.c                 | 13 +++++++++----
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c8a4b283df6f..811f95ea8d00 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2594,6 +2594,18 @@ static inline gfp_t gfp_memcg_charge(void)
 	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
+#ifdef CONFIG_MEMCG
+static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
+{
+	return sk->sk_memcg;
+}
+#else
+static inline struct mem_cgroup *mem_cgroup_from_sk(const struct sock *sk)
+{
+	return NULL;
+}
+#endif
+
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
 {
 	return noblock ? 0 : READ_ONCE(sk->sk_rcvtimeo);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 46713b9ece06..d8a52d1d08fa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5020,19 +5020,24 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
 void mem_cgroup_sk_free(struct sock *sk)
 {
-	if (sk->sk_memcg)
-		css_put(&sk->sk_memcg->css);
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
+	if (memcg)
+		css_put(&memcg->css);
 }
 
 void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 {
+	struct mem_cgroup *memcg;
+
 	if (sk->sk_memcg == newsk->sk_memcg)
 		return;
 
 	mem_cgroup_sk_free(newsk);
 
-	if (sk->sk_memcg)
-		css_get(&sk->sk_memcg->css);
+	memcg = mem_cgroup_from_sk(sk);
+	if (memcg)
+		css_get(&memcg->css);
 
 	newsk->sk_memcg = sk->sk_memcg;
 }
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 724bd9ed6cd4..93569bbe00f4 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -718,7 +718,7 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 		lock_sock(newsk);
 
 		mem_cgroup_sk_alloc(newsk);
-		if (newsk->sk_memcg) {
+		if (mem_cgroup_from_sk(newsk)) {
 			/* The socket has not been accepted yet, no need
 			 * to look at newsk->sk_wmem_queued.
 			 */
-- 
2.51.0.rc1.163.g2494970778-goog


