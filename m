Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4BDCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA9D8E0085; Mon, 11 Aug 2025 13:31:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84378E0060; Mon, 11 Aug 2025 13:31:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23AD8E0085; Mon, 11 Aug 2025 13:31:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA7C8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 617D857F20
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:43 +0000 (UTC)
X-FDA: 83765168886.15.1A41972
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9060A18000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P3I7I44E;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3-yiaaAYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3-yiaaAYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1evf9NP8gzujZSmc68LKGIYtEyxxeyxaSo7A1dSfcIM=;
	b=amNAIphtKEqJ8MgJja7+qehFMJwGXg6DKMdNr7Pu3BkQmDyoZ4dgHIFvspq44ulpWtsERm
	yRuzmGNQEmWTFza7+3c6urip74mVNRQ78RXeuAXIzT3BjAwa3hphoEmyogm4oVGk/w6GRT
	9RTCmsjqv/p8IGUU7QGNbsbhymgxvJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933501; a=rsa-sha256;
	cv=none;
	b=SPyD/rI3jLWoW+LSCOIGBiZ+YCnuMTVjFNPI7bhN4VavC2vs+ZZ5XGdUHCaLdYqHRbMooP
	qsDrG0RAxOk2Ir10X9C6X8zbjReGMaR2qVM5UBlmNgVet1ZdppaLx2DBf3l2NxW6xlN4Kh
	E6WnzETbS/BzHcQYeLlwLyy+DKna3r0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P3I7I44E;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3-yiaaAYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3-yiaaAYKCAImwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-242aa2e4887so100993015ad.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933500; x=1755538300; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1evf9NP8gzujZSmc68LKGIYtEyxxeyxaSo7A1dSfcIM=;
        b=P3I7I44EzK8OisOu8393jlHr54Zx7klCR+rubrXMevQ5Vw2hdteiNOiy9vDdXNcGRD
         wsrfaLJc4RmJN/cJ0IDHjj91JC6t31Lh+AOVL/RSetrToEaB65YLxHrjnTTKx/XrJZ2R
         dOLLgEAt6s2HrNOCouKmH+5zXBpWm45hJaaP19QrqnjzSt4D7yYp7XKUBb+UhOHpnBbM
         N5mCVkbZLCRS3PbmsYjdTyqH2WSWSMX+fGIk15D3EBNisK4tqIS1xKwGoBzT+yk/fMH2
         p4LNDMcED4woCHgC/l6TgQpavubANoDHP6YzhIB/2uITMGjDkb5fwWrwUKS1tkDxMIG+
         aa1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933500; x=1755538300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1evf9NP8gzujZSmc68LKGIYtEyxxeyxaSo7A1dSfcIM=;
        b=E4hhz0muSAxQZ8iO+TmILoaEJQwZ/owWTO8aPDHUuGm1Ri/mkyZ1qVaoDC1uVsxVJg
         +jK6axia+jM5D0kgNCfyzek1L1hwmSNKF2L+9+1Ybd1469qoIBWp9481Tv+xfLAXjDuU
         /fJLiTNz4Bc8EMlSxzE/rc1XAhTPMrZildStU9TQI6nnFYQaj1fuSosx/ls1ImV5FjQG
         QDR/0OVdQX6Vb0ewKVulZF8Cl00781DyenoF/5NS7ZUK0/eUh1xdsbtTYt6/1szo89Om
         94/8zoGoPFffeK8skojVVPPqQjIG4BM2w5+IRk1OpSjU0xdB5C0deqZSkPI0gKPl60h8
         kbPw==
X-Forwarded-Encrypted: i=1; AJvYcCVqIqRv0zquqYQbR9cZrdFG236nA7RtwnzpFgm/h0adUUrEuaUJHBO6WrvqGuKdZi3gBHEGQ9EAhA==@kvack.org
X-Gm-Message-State: AOJu0Yza2MfwoQ0DXHEaUG9YTIvvmwRs0f9C32czOqhnWVUXvNTl/223
	hIMWUo9a2SM7PsW/aiIdHxTGRS4fQTnOKG7VSDtWj7wobRZQuqeWEWnGfFN+7XpXrlYbQPl2EUl
	iFhbndg==
X-Google-Smtp-Source: AGHT+IHeBDKPPyqvP1rUR5CAMk5yyduE4pb1HwUuCqZE282C8A61+qQgO/7HcPgBMgw3doePxcL7KhLi5Vs=
X-Received: from pjbtb5.prod.google.com ([2002:a17:90b:53c5:b0:321:ab51:e32a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea08:b0:240:4faa:75cd
 with SMTP id d9443c01a7336-242c225554emr205009335ad.48.1754933499961; Mon, 11
 Aug 2025 10:31:39 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:34 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-7-kuniyu@google.com>
Subject: [PATCH v2 net-next 06/12] net-memcg: Introduce mem_cgroup_from_sk().
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
X-Rspamd-Queue-Id: 9060A18000A
X-Stat-Signature: 3urzuosaqmownohcua93nh8e3izyu46q
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754933501-71312
X-HE-Meta: U2FsdGVkX18l7QEKUFhq2kQl4a2TAchQkSlibscxJ9UtW/aGI4O736PdyTQ85vBQsSccqgFhwJpNxToMjX6KLSvj6kAX5UY7sm8n9stZdKN73pKYsEtlWlcgcswV4+qr3RgW4YeCxuxTYKD2cVwUqr7ZdonetAuU3nJ0s8hwN7KjHQHM3RArBXE7WSK67TtJ5YytYIZ8nAE/TFTNKXmfuz8o1RQEWrP8dhHBApnM8gU7wba+GLuyo88V4P3KuMvf296SrWSKSNQeOIlqJ5TPi1cVHrdsZIOLzaSkeosjzjAwgnb9n3YOFrMjA8tS4keztXbsrNCcXjvaZ7E6/AVArTWJ2Mh+Ssw6HohwJa1i+zpLA0qctsiJepbR6u6K+blrWxtkv+inMElOIe2yjiX8PL4AYlL4sO2GSGNUDiXhw5rXAv4KOUGSZCUe4dpMFG9F8DOO/HDfWsKLh6MhYnriIvUm3qFfWbZPwxILqkrrnDpqmlQxUQkz90RAlhcNeLu1QwDGMECewqRarwZMI9yRp5ZxdzAdRSeXe5E5wyeD1TEpdeimkjYjTkE6xumOE5lRQgKQD+hikwJPD4cY232TXPG2fUf66LmZS0Rpnrlmi0qyKpVCVhCmuHL/wcZwtgPVzvabFFYEBp2qdCvEwzJUPweP1I/Tjsez/Rf32+vjkuJXUcrnB7TIeu78HKiXUgyEWbKI/mslgSLtpLUylgV2u2JLcO589L9VmzFE05hI0j4AYkHm17sAzqghFThJSPG4QEL41gYQcRkRm2dmFtTi2GLjg5mum6v5nzRRXc9/+/C232YPevy4pfO6P46BMjLwcH56gcmoqKMixGr+iuDWyJYgbiFvxj0d4/ouZoTXgwhyyGDifn0uSL9XJRsLJCvWFJjA0X5Ztbi4731XGuxwKV4clENil5eZLCQc6oDGFIh2zYo4RW/4vQvc6CNH8pRMaXaloBOaRBK9H9Q4k02
 cWINOMoJ
 +T2V4KJiE2o/EXRKR/j/Ewx64fUAXg/i5eiSQiEYc4OnrvI31WsTC9QDUWBYdNniVQIOdNhztAwlshmlLjJXTLMfvidkKGI8O4JpU4fVlcnBO60qMtx8XBxH8/BrhW5aHfGAN8XUK76b4U/gOQagXTIBTC+wK1gCZNhnOvUmBOMW1Rx5Jp7G3bD9Y8+TSa5m1RkETPTU0HwL2w6BFErjG6ykwp68dfu25JrmHnDBbhGQK3HzcPwG3swnCAEuJBXGgxYN5utEuoY0G3TjHngKyHPXJuwiW+QyozIIaDr9Dfi+1GtlaSS7EclhKyIwDX/lLXda6o0ClhP0fU7us0V5vWV8qq5j/Vk1vuNmxkRhG39jzY+8TGeVwlecmeCfg9HipOmLd1LwGs0DLlEokymErkV5/iHH9FFQLb1frv025C//IU0aCYsw0fCd12xFw5vEhFSxbop6jQPNDNelESxxVd7ViPpdm3+RNm9aCNsvTfuFwR2f+v+ln/DboaUWyEaqdRXLWAULNUwS95QWjAdZrGr+0E2Gd65c1egGpyYLI3481YJCPv9b758ZIofh8CLNnw7VQlxEGZ3tIQy27kNTX/8+Cpw==
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
---
 include/net/sock.h              | 12 ++++++++++++
 mm/memcontrol.c                 | 14 +++++++++-----
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

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
index 08c6e06750ac..2db7df32fd7c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5020,18 +5020,22 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
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
-	if (sk->sk_memcg == newsk->sk_memcg)
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
+	if (memcg == mem_cgroup_from_sk(newsk))
 		return;
 
 	mem_cgroup_sk_free(newsk);
-	css_get(&sk->sk_memcg->css);
-	newsk->sk_memcg = sk->sk_memcg;
+	css_get(&memcg->css);
+	newsk->sk_memcg = memcg;
 }
 
 /**
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
2.51.0.rc0.155.g4a0f42376b-goog


