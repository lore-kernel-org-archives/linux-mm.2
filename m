Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90400C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8089900018; Tue, 12 Aug 2025 13:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57C98E0151; Tue, 12 Aug 2025 13:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E9A900018; Tue, 12 Aug 2025 13:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5CDD8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F3C9C014C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:07 +0000 (UTC)
X-FDA: 83768866734.25.F5379A5
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id B80F91C000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RJUDM+nY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 36ICbaAYKCKMNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36ICbaAYKCKMNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnEkA+52sI8esqmC0cNEqYlTXuIo2cbdOxRfbJLXess=;
	b=3dyGGEBMySso0K9e8UjAPbp2/KwuPyvVNweYDq7fdiRSIEaFollsEBb3ezcCL3eXf8woBg
	7iKcr1Of4Qlk1U716uifwbpfJiD4yXiusqean6ecLKLd23V/G/Amwz1H8imaXNxDheSF4e
	tUmbLVHI7WMoe05Qf5aUQnTBA8CCACU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RJUDM+nY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 36ICbaAYKCKMNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=36ICbaAYKCKMNXQLbXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021545; a=rsa-sha256;
	cv=none;
	b=TX+jesso4R0jvUJfgM8xeX216Zwphb+qjB075mReR+nwf0moEliLaHkOUH+YCOctpzzj5K
	apqhDI3gsy5NdBNLFjP3dYh+RQVSqidXmmwziBayyKInMyvSRdvoGS/Bz0s/nZxlNGg6HE
	Q8bsKAhoybd9ARjLX53Nae34cwsNsQY=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bc9259f63so5722980b3a.3
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021544; x=1755626344; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tnEkA+52sI8esqmC0cNEqYlTXuIo2cbdOxRfbJLXess=;
        b=RJUDM+nYzRTKRr0Zy8y0qMXqj8NoRrXt4+r3MzcqB2+7qaIj09fDSVEulx2gJYkHS/
         QkyXLJR+1quWMyRnlOJftLSkdZrMlcKlq/eZIVekFQQqulDMhTruVigTd4tMFBH5IoZW
         H3Wm+lT2dzYnAmtrwLiNlbzsbhkIcQcvwc6uKnxlIErqQsH8hX6vA+CdhI8ClkbM1TwU
         vZ9vK95//0I2gidbDRN0trbzwYW7Pm5tTBwDGvD63Q77SC0MGPT2tla0BTLp3OUwAk02
         Wni41zQ2J0cDovFEjI6SnckKix24Jh8RCnaFDuOOX9mcnxNnMEeJv2x/usTk2BWC1JIP
         bJMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021544; x=1755626344;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tnEkA+52sI8esqmC0cNEqYlTXuIo2cbdOxRfbJLXess=;
        b=cFRNcZZ9UxG37m/trNfBjCKrH9SWOjpLnk0FD2iLKglVp9A0Gd5T3bzyeibdT3tfag
         9zSmqz9tEnrMPEOzlfjDQFpLmqOID38W4GAayOqeKurLuVV2Iidc166Mm/egd29dw+R6
         UfkBFgKBbRDcarG8dHLCacnr9tdaQuUNYP82NytlOYWFlJViuY8XAXhCOXge8pkXVJ/e
         lpx9St7fw0Fic92Az/w/VH7izEoNF6YKSZ+7Zuw6pXUQP3LnTWj8eSc9LwRvWrGcs5Wa
         8BvR/4jzmP9sdwimwD7rjdHH/CvWfQzB2uFmtSOUDl3r8ZMP6f73aSYOH+KCw7qvll1U
         sSKw==
X-Forwarded-Encrypted: i=1; AJvYcCWW3XPbgS9NK5ufJzY3UyqR+nu2jCsmA6hjEQDxIZ0gMWT8Fv5k+BpYQF3NFWuFl8ii7jp4NuX2fg==@kvack.org
X-Gm-Message-State: AOJu0Yzgy0gP6cZRsNfjJqdpaF6a+Cz0bRboeWNfycjt1q5JhqI/Z/HL
	nh6Am2895lPQ6wRwVF1cOzxfh9iA06kzqVRB6AGiBX1LVBr/UHLP30A/daULtbuvuL+d6HoDarn
	5toJpcQ==
X-Google-Smtp-Source: AGHT+IGoBWtNHQB4gmu0I/l/gxdqVZ0w9YFTpuFgmmNNhALMQosyvo+/jCxMWRY+Nn4mDpLorfHvQa7+8R0=
X-Received: from pfoo14.prod.google.com ([2002:a05:6a00:1a0e:b0:76b:74b4:ed62])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:885:b0:73d:fa54:afb9
 with SMTP id d2e1a72fcca58-76e20cca950mr205362b3a.7.1755021544485; Tue, 12
 Aug 2025 10:59:04 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:24 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-7-kuniyu@google.com>
Subject: [PATCH v3 net-next 06/12] net-memcg: Introduce mem_cgroup_from_sk().
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
X-Rspamd-Queue-Id: B80F91C000E
X-Stat-Signature: ee6b3j76888jqohitgxb6k5cudgxrwgn
X-Rspam-User: 
X-HE-Tag: 1755021545-270141
X-HE-Meta: U2FsdGVkX1+VdjdXW81HtsNRaoC3ZhFuhR/5dvo2UUzo5OQE3F/Zl4PhnxwLLfdV2ysqHGQ1LnB8RFMHGVp0x7GlmTiWLVx6saCO4TE+DzUOYv0NiqfBIR5hWcCNIEmRzcuOf7J9+1LqKrxJH9X3VlKqQbR6lkf6rem2H7SCSN7G5eApP7UjuhwdPtoD+PwdAxu4CAnDrYlm49Y2uuFgQKChcHvPSdNwrBA0JUXig5GYmYGy+O4ceFKQI7a4FZJCa/CzXe00H0BoztSgrzJBDgDUuhHZ7FNhbK/EczfPofJRUik9sA7C4BsIqbVFscAnPu2Dbt8cJPdZM4aVRbm+dAwKNd2uk7abWOQIqqo0qfFd7t8+iXDQIljH+67bJf94DwS5X3NuUc1z7VldcZPw3QnE9mNXNvFG2bXg2+sAWQ+BheoaTF0rbco3+cboAj0pcfxjW5jBcpItQuh9hJLYqeFu1TdWA8ZKQs0Sx9LQXdlLAkfzWNOnQzceRWRYxOYiNH3EBWzR1tfb35kchwwALWGwoX6kn0kGm+6FQ+lDHpruXpOzKRPVimx2XuFiYHv+EPTEfufQq+gnOF2cL1+fsuH3/G4Yxgy9bcJkoZrD4hGo7TrYW5km3A2zEf7AEVEk9sqiBs9RQrJKyqhaw1VXLHpTWVV51zufLcXA+BtOwi+CjPz7Rtc8kWpqbhaZ5iw9RaYqYjycG8brNrmB+Ke3GQPC71Ey+ctPYRcZRWuDMdUX+Gtc4+3FQuYxldb46vJ86+XQURhWher7+ngeSzmIp4qhb0Qyofyw7zAbjpFb9qdm8d96XaWJEXag9AINPnWZnZ6S6sZm+N4HP7aQPeU1MeCMdzCzKp80AfWGMpe8uSKLXv8t0gGLCCbOxUrz9p7soTRdithxcVU6eknRegE1DrzN4ppEKg57Nywn6/OwLEaI5UjCrnGeSqTPUQEn794HJYNcK0W/LEhMj4DQQ/F
 R/4XPEv0
 b9KlSDRkLl8FQzd/iTj4hgNfSyU3uakUtcllIq+Z9DJJTLTYQB/or2odgcxHfZDFskgF5MAAgM0QKLCLRPV5pcXp/bec+zoCxM6NJmRUke2XQ3Rt5FUOIfiOH44PVNm9AM1MkGzP0tei8kaX4oj/SVkm2vvYGot0Eq8kEY5AoSCvmThkp0uCsQrbi7qm0jdrtx3typ+KIOcCS1cHfo8u+Yq1UdIAZqhd1mT1lB3l4GhH0oGH/jpMbPI/pgOCsyR/TP4SZJqHz5tf/X4dtv0OIy2+xh8J5HUTwo+paL7N2ZtdfxAyeXDwVeMO64JQbQtmuN4VEIoJXEAGcBnIqI3WV8diaASNFMzqUzqDtIDtlE2pKyU93OYyaZOgwJovufEL6mu1a0Dw1YEDW/Pz58J9TGrCJxiUxHNXpUtbpIlX6ZwkDACOPy5ZaBwhr+ubsETKBWWEX9YauyCoDt/RSuNx3NOfKoRTTSu/PtzIEiqeqHvBIgb3HRob0i0yfX8tvlsKrjWgR+TBqb1UBlDfaywUxGxWy+PWv7ZT0tBTGu/E6FtonEE7I1a1rhyd/HUu3P5SFrJmpRfXpV1Bug0/CkCiAxL5PbA==
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
2.51.0.rc0.205.g4a044479a3-goog


