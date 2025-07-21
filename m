Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEEFC83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DBE8E0005; Mon, 21 Jul 2025 16:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5F68E0001; Mon, 21 Jul 2025 16:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32A58E0005; Mon, 21 Jul 2025 16:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3768E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C1AE1D8765
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:39 +0000 (UTC)
X-FDA: 83689430118.10.2D49BAC
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C65F4000B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WWiFfFak;
	spf=pass (imf12.hostedemail.com: domain of 31KR-aAYKCGMLVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=31KR-aAYKCGMLVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrGASm3CxvureKJlvs5onpPMiZoMQw1GHMHnORXuhuQ=;
	b=bjyWvJhXlaod7r4AuZPo5rtyVnl+trt5843OxNHmo70Kz8VqUhSFjv9VrAv2aNFrGNLG5b
	Qlx1f3WEpN8p6Tgzq7mIBmoovtSWtg7WkREF4a2Ukizn9atlNeRfgiWCS530ECoS+NgjRI
	9Ei3VmVaG7jkOienkZlmBrXqjqOEdjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130197; a=rsa-sha256;
	cv=none;
	b=2Xk4H8fmJ3qkuhZM1PSOzEUv5XLUe9rLnwe/4c+QfrqUbIWCImuVT1aFSYTgDIz0XiisWg
	4L9DzzVgti18NIeRxUPXf870A7y2kLiiVGkDiiRt2+KsTTTvrirdtr93AYtKsoxXD2byv6
	kEMXGPHYyUv/NEV/4RFdFkoQZrjj7EA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WWiFfFak;
	spf=pass (imf12.hostedemail.com: domain of 31KR-aAYKCGMLVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=31KR-aAYKCGMLVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748f13ef248so4352324b3a.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130196; x=1753734996; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mrGASm3CxvureKJlvs5onpPMiZoMQw1GHMHnORXuhuQ=;
        b=WWiFfFakGRweN8dweefEcMBIMCImWo92gsFEVmZFBiRp4ZJ8ZBzsmrEpWkOOb5/AC+
         SuRephrBi3RWPQ8j1EgSNkBkki3KlLosWxLMK+Kq5QIFb+5F1zuVsyaBxT1ahNbFNEVt
         dhUZDV3pHVBK0tTPwmtWTXNpMTe4vkqsJiWzTOVZDO8wnRnY1szHiZt8NDHvwIZKIALL
         p/vMRxoySZJgRuVdgdloTzFxcJTgMX+qaWTLx00F8Gs7qFvm/2hKKSyilce5GfwDZUDB
         ow9i8UNfdoil6tiDXNx9zIl13serZteZYYoKICGYTHSCxAXqbRtQTqTgswTM/cFsEtLI
         o1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130196; x=1753734996;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mrGASm3CxvureKJlvs5onpPMiZoMQw1GHMHnORXuhuQ=;
        b=gL1N5WSZBH+801o60RDdaEznNjmedcka+wjLsH7vQ2Tbb6AOCeS652I50cPty7HZj9
         OUoRkvIxywzaTXdPLgI31RWKvOP1zTF+pT7f0rf3pwgJ8thOM41F2s0ogy6dN+GN1MRx
         msC4zQhc04h3GM8jk4XZKIdz3auoCQ+ssz5wE7OFGjn1HRGSw+4PoIIn/gDSLduieExZ
         lcT0RdQNPUBbuorW9QODWO6b1IXeBX5tyJoCb51dkMQhNmnX1h+4Uc4c/pvCh14ZkhYx
         z3BWyzrRe66rk5Zhx6bc2nRdtvaqEF0IPL0jgmRawBbEtm5IG9r8QFSoIjj3pALEP5rP
         KbtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVOAy3cFAWcf3BlJJ/UyDxAFhujQwGf5zlWoxCqZ/1Z8ryCuMUmR73xv7k6f5wDjnyou4pTC7Ihg==@kvack.org
X-Gm-Message-State: AOJu0YwWvQehYhAvgEQvaiGaZza4cZ5MC/FzYGMeDhUbPWLhxP/2VqTB
	a1Oqxz/ul7kqZbI+oyOj1ES0psvp+Ex/PgxTUxW/5cgN4X8cS1uH+NwkB31luGu3we6pvz4WC3e
	XUJvsbw==
X-Google-Smtp-Source: AGHT+IFThfJRCKKDOR0Nefiu/tzdT/WdSWlskFFKFs1Y1mRRZJXgb5GsFfKf6cD/RAM/mAjuTqVBtl3aIvc=
X-Received: from pfbcw5.prod.google.com ([2002:a05:6a00:4505:b0:748:f4a1:ae2e])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2189:b0:748:68dd:eb8c
 with SMTP id d2e1a72fcca58-7572487561emr30325627b3a.23.1753130196319; Mon, 21
 Jul 2025 13:36:36 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:25 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-7-kuniyu@google.com>
Subject: [PATCH v1 net-next 06/13] net-memcg: Introduce mem_cgroup_from_sk().
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
X-Rspamd-Queue-Id: 7C65F4000B
X-Stat-Signature: uxaeotof7mprpamo8nfo65os98wc4dqb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753130197-49872
X-HE-Meta: U2FsdGVkX196pYzFxs2qm07VXOKvXZKZ0Yq7dQl2yLBasoXtwXRaM3oeA/ggihWKcHfY4csarmzJobtUFKtMCD0NK0+YsUjHIcABCfstjOAwzOO0lbGTstB/Lx2vS+V8eiP1XDIMAd6jMUwRbTVopRg+1TTn1+w12cIqF3BcVA1+lSvmOQaBqHV+0Vd6eoz3n08bf76TWTRib9ol97ncNNCmjtoUK3YhTohIIVV9c6iSljNckwdqfV3dLduOTkVgjWqfGDuYdxKjxorvgCO1kqOX8y89+u8GVcgRgVczTrjFuA0bUdjBcTu10UBDVe6F8yU/PhF5kSLL8JZWgEzlQlO5wM4zRUzp+ltRM9BpBkib4QcED6vGQsGehk+YX/aLDQQ6bAdmO2GZuHwPiCjHBr0cHAyxMbJIqgrgzEuf3tzWBI2/FsI6CtFT34F1G5qfY/Ov3/I3gBy0qH417vJSaQfrpHY6Sf6Mqz5Z7vd8IY0UoDY+uoojwfzI1aEVLQsBGpiMwv+jFK7oYYwtQQVEVMsd2C2IzGOM8adqzQi76JFmaJV/cuAIEgLj1CHK5C8bK8MPjwMJqtzuur2RPgQTxL62mUzr4DC1PybUxIsOAouZYG30WDA7uCPTfqFi137IyeFQOLMASLbmQabUhjn8VQkwVEhJn7txTpsfVtneTMnO9kVmI2EN/sVF6s1g6csLPHBtcor87SHSd5egUHuCBcnP98yp0mxNVCZkt/R30rMrxpHUfGLNzwfOqECkoSYaEo73GlTpzF/921+XV9PL4vqyzddz2ddqNNSJ351gOBTITa61WFwxS1n7ALe/keT572K96/NMIYQQzr9zBf11/UYEjRUKXl6EBCGiizgHFd+MskvUkdllmXBU22Ayhd+JJp7nOypB3QNpiOZM7nUswgL3yMK+E07QRcPuiftkJIAxVKhREcZjJLiX3valfhVbNYOtdRW/gaJz4GNHvQy
 Ebb4yYGA
 /3jdSZ4sIrQC2dRdrteZlwRzSQ6QS9CfsYlExUop5tOXc2tIYF8d+gCkjNpL5HIbUl/ZICNoByg5DvCXi1jqdoKyU2oedx1XfKqMTfee7cHwD8udB0dVNuzINuNPfOtf51ixDl9BkoroC4+Hfvz7pM4F3ZSPN3y73WKWY0VncxOFloVwEYC5eL4Bdh7UbZRPUy6lx4qWyvojpuBfaCIhukxa7f6LdnjFy+nqM2nPydXgZOMLTk6l312AlFf5I7J9efGvHaHfG3WEDob1p9pSDeGsKGZI9+cI0cnGyFX+MOxjkHGZjug+b6MvPzs/fVGr9Wpgg8Y9/fLvrFwEVM2etCdSHqee8GJB1MugWJRNXlu9ENDvukHDGIgpgKMQ8vgVwWsu0TLJyXISxBnCOS6hyC6j6CNZIK7sKlZYVurw6n/s7DIyZpHL7qO6j0f8ZROXlQ1t7kbGfg1xZnTdCpQIIyC+gv7BxN/I5h/qOveZMX/pFwm81vti6tQXl5IWleoUtj04KBdPtgeZyd88RDbEPf9FCpT6vHS5i4Q+O0nsJMCB5N4TUQA1lxtw2mSOOEGHbnweQg4dzyVTwUQjAlnYOUXXjyQ==
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
---
 include/net/sock.h              | 12 ++++++++++++
 mm/memcontrol.c                 | 14 +++++++++-----
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c8a4b283df6fc..811f95ea8d00c 100644
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
index 54eb25d8d555c..89b33e635cf89 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5086,18 +5086,22 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
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
index 724bd9ed6cd48..93569bbe00f44 100644
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
2.50.0.727.gbf7dc18ff4-goog


