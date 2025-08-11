Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8B2CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE7E8E0084; Mon, 11 Aug 2025 13:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D118E0060; Mon, 11 Aug 2025 13:31:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E548E0084; Mon, 11 Aug 2025 13:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D479D8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91E7A1DB192
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:41 +0000 (UTC)
X-FDA: 83765168802.29.E44C76D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8A34140004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4K2n2/j+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3-iiaaAYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-iiaaAYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzfVGGcr+sVaGRRL1v88D9i+PBN94epKYHJgJ64bEQY=;
	b=534xLNNiTVB147iPw0yq/CQAni8T3oqoN42kLOkbE4C6lo4+2BbjI/Xgzpaj7LLw8irTNH
	6YYVASWoeKw/X1EUF0iKbu99ZSXXfabZLTR3VHm3SeMQmbNa/wyQQ73bYVtsqwmYKrxbfr
	XrAC+5W8AU8Li1SbQDf5QkEfAVhpWsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933499; a=rsa-sha256;
	cv=none;
	b=dBsrBrU44PR19oA+D0BTEgVkI2BjfqZesyAp14nBZiqWkkGV9xMgvo77DVVDZj3aY5+IOP
	anzOEjLRkVJ+aw67ns0EfJ+9chhXGML3bquBB+B89TocOwMsfrWPEXrDdwV9p7hzyOpUex
	NJZ1WuSAwelqemyZiRIQlHQJZAluvOI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4K2n2/j+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3-iiaaAYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-iiaaAYKCAElvojzvhpphmf.dpnmjovy-nnlwbdl.psh@flex--kuniyu.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-240012b74dfso34013295ad.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933498; x=1755538298; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzfVGGcr+sVaGRRL1v88D9i+PBN94epKYHJgJ64bEQY=;
        b=4K2n2/j+f5K0DdWTGERcCjGzs6O438lBT4ylGRWpmM+CyfjhtzK6vP/9MmC1+OSnAO
         mu1n6DYrnF3eapxjNqgqul1h+MEPKF8A0wu6SoWtU/Jgn3R1jpecQZuu4Z/ISeIBk0x6
         41byKGysMOeHUKQlyocLPnGaf1U1l83MDRA73WjK/gWxi2/i+79Ss3bF+0CF4aAxm1Tz
         bKkp0jPV7CZjHFuaeHeF+jbTYZhnmEROI0vlP0vZAGiYXnqqTfYxgcUQrP/n0uBn5iXr
         0fmQIDuG3msF7QwWgQ8t+U5baimtIKzXWh0fi88NtErzP9x2qJWi+qhXeYuwGXhKSbw0
         h5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933498; x=1755538298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uzfVGGcr+sVaGRRL1v88D9i+PBN94epKYHJgJ64bEQY=;
        b=RSYEEIB1UlREmq9uNHSGBKNq39+8R8ZfEsnjSOMF6vSxQP3EOoS28ygGJyt3VvfFhO
         8lFKpUHy6n7ZJ2lrqKB9VLEp0ihliLNwOHsdZRiQ0eoIr0EfrPzuWylvyu3HioC8Una/
         t92W7dRW7wQbwvsCpX9FqPq9VX9vhyLceORmOhO8+WEIDyproGJDRXire12ukEDCb+Br
         kiPuIv+Xi/sZcRISi69BRMUppxf8Z4RM4YlL55ADCsAqkLVZHDJ9n3iyAiAPx2fYoJxG
         ul4zz9dC4Vs4EBRHIABAtjAQzXAFApdq3bJzz6k6D9kcn0AW3fIkm5APUl5Paf/a1ZK5
         Bl4g==
X-Forwarded-Encrypted: i=1; AJvYcCWs3EDU0xgQkjGxoU29m6hNBVKurUNUVAw4kS0NH3xr3pe8d2UznT/C5h7q8HB1w79pPrXZ4XrFAg==@kvack.org
X-Gm-Message-State: AOJu0YyAPCwKod2kBlgOJ/mrQKX5xLlHBMPZ5kE5/j548cHazMFkLNI6
	M7Za0ghK8unJDfpFoGzmzM2G4YFlDF20e3n14hetTW9afDEjk00tPL/KIP7p5RgC3lqgS7xkxdJ
	Eg7M1Sw==
X-Google-Smtp-Source: AGHT+IG9Zlocy4eDqCS5oKFJ6Lh7wIqM9jd+N5Kyl95s+RAxxPEZ9AxG7sDpQwLNd7KdpVUzfZOq2F2IpGg=
X-Received: from plbmv15.prod.google.com ([2002:a17:903:b8f:b0:240:3c5f:99d8])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0f:b0:240:9ff:d546
 with SMTP id d9443c01a7336-242c1ecb9c1mr190995095ad.6.1754933498485; Mon, 11
 Aug 2025 10:31:38 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:33 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-6-kuniyu@google.com>
Subject: [PATCH v2 net-next 05/12] net: Clean up __sk_mem_raise_allocated().
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
X-Stat-Signature: nsm36ictjiqeg5xr6bo8o4b13saxnw5u
X-Rspamd-Queue-Id: A8A34140004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754933499-831414
X-HE-Meta: U2FsdGVkX18llsLqJBHsfIBkIjZJWxcBGR8NJo0pMhTnzbj+Y7F7fc3Q7mlA7xXTAkNYbvRVhz1WpnrKy69WogH6cUqtOxi5BfUxHKaPpgajWsch/JRzrPTmfiQ8R9k/e2VSME7Z5PntquhGlAirccowhWcCIaDGEYzaKSGC5oeUE7LeFefZVC4UQwwNVO1a62b/0ebgKOQc2frCTT76A87fL94igM9V/XHCZ3a0EQzcJyhX/91Sk8sQ1dKuP4xhP8Mzpsgn7zKRGC/SihQETutFfDllGvx1vTq9XwmTuBG4HcF0rj7R6vFxYakflsC45SnwXO2HeYMs46VSZdapnnq04punvtB9EXZml8SRMD1vj9TvFxmeN6RCgHtPWlARVdFR2UYRAe2vF9P6Tml0SX0U3aW35174P8HGZZgJvc91lb2tgSwAfkR1Fuck28oy0el3mNbaE43n3qYE4OKoITcuGI3xOYNKYr50urqA7sFB2Tc/DopJtzcg+cvUGOkVletTevcz48Js0eIeVoTiueDKSREG7CynbboJFVARFtSWCifZ7avul2g8UU8KKlQ2RK5TMjgxK9o80nJoV4cf5iJ18xfbl0XvS4OhEUMxtieRSVGVqohUVBT7eHKdSsamv+rEhQTxrP2A/SVRTA1TbhNaht1pkEGcSvIaNTpZeDDNxV6Qhc060qnxAbn00qEwpMcsmrVFuzDWwyQ4oY09ch8e1YD+rfpNFm+oV3QbMaXCM3W2DWuC4nOE+BQkJe7HyaonJ8iPwT1sUGRxXd03Lgtas2F5n4PI5yYurh0AM1Y3vhVRQ7i+c1NA1h1MutqrP4GkNLDdHiOsIkPSWyW/tf/ulISqhKT4pWsqHTgEKdDSUPSMwoRSo8aZrstXmS7iAUTxQ8N1pzxR0z3QRYc3OIDtkBAVLPaI8tSF/h4jXhT1KbJx27HmqYsPwQfUKYvmkrSjiWwz5lk3NcvODgm
 oM3L2Qgi
 Z0yyurhrOTLXcTGyZ3O9lrULz7LT/OEY7e56DT/pQxPT4Bd57s1MrIValPxVArqRdj6WERnqR4WCFKK99QPLOO4lhRlO2i5g1PgQx+5lXEHZQphGOMkEVTTDmAVKG3bylt1I6BJsiaXYCKS4fA4Y8N9BW3QG9LN1oSzl6FMfj1PwHrlJlcpcZekSmpiO7UODU6lr8k1YiYWdekUeEoAiNbacuaem7BVgpUsBeYizHsYEfdpJlKrSMfuhqJ4djZhXoEEZA6rjXVZC+1TquwqoXW3XPLsu3wK6d5PE9G1EujFZr8ze7tDKrY6LUx68joy2sfZ9ytJgdMA8DNv1Sia3IRYtebeH7SquoNclR7M6l4S8zxYV4u5EF+6zofUhH/KEcpvuQ4SAp6NqRr8+IEHcKnra9ubMT48vkcUnIswV1WaBGFL82X8n7uaoIife3kRbZ56ceDE+EPFWgM0+7E2/feVWwPbxexM0HmrE/psSlvuaXcAL5IAbhKZ1oT2VFJki+k9iB6T4S0TtqcAtB1K9+QwAeGVdSBl6IxIC+uQGzf9m4q+0z/wuX6iClzjcFzkGkNIoUq3GAp0SIs4RUvSjIpuUiHg==
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
2.51.0.rc0.155.g4a0f42376b-goog


