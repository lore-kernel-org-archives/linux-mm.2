Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F32CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926239001D3; Thu, 14 Aug 2025 16:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FEAC900172; Thu, 14 Aug 2025 16:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDCB9001D3; Thu, 14 Aug 2025 16:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 69196900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02744117F70
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:26 +0000 (UTC)
X-FDA: 83776452774.07.23DBD8D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EA2C40008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oNdWJWhC;
	spf=pass (imf27.hostedemail.com: domain of 3c0KeaAYKCLwmwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3c0KeaAYKCLwmwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMWDRwJwZj6qLhFgWvOz68lXKSU0dd2mnEaog5fuH+Q=;
	b=1hirKycXtCEbkL3zpUMAPAqN8vQi5+A7ilUl5w09iWivbUK3tbsZqzftJ5fqF2Lgst1Mbf
	mTdSK1f0y5NKMOB8rte2JUuvLSKcMOzyGbhVXQe6msWDOKO5xV58kcV1V6almuewEpvSTc
	jmEOPp/8RFUEHZEElF3akGaxZGwlNK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202165; a=rsa-sha256;
	cv=none;
	b=4ffjMzau4UnypzkZp1hKVcf9kez2HkVjobeby9Rgg0X3Juh3gf42lWpD5Jr+3xr/VBWK01
	O6nCYT4gRtlyTsRnJWU1E0LepzvpSUBknCvUlyyaNGVRxJ8602qhFl2jkbgYCu7matmj9a
	+t1oNhsMiH7t8f3z7Ci8tvPe6p9wmis=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oNdWJWhC;
	spf=pass (imf27.hostedemail.com: domain of 3c0KeaAYKCLwmwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3c0KeaAYKCLwmwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24458121274so15659395ad.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202164; x=1755806964; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bMWDRwJwZj6qLhFgWvOz68lXKSU0dd2mnEaog5fuH+Q=;
        b=oNdWJWhCTMzh4WxGz7JSsgusWtCVVvRILplS117E2WwJjfQ/e5KCecQ/Y3kOlHnwu/
         sC95HMKRM/BLvwfW+C8ZwyKvLjrxynZy8MOTf4N8Gnm/Rj5+vBkIgBaqiRoopCtq4Teb
         ItUJDNZ2iFmuD3RkTXMiYwEegYS6uLmonRbCXZslECQu0TcfmMMm6y+7XNUgJhf3Am87
         6gXlf18Zt0/dem5Vw0GNw7CxU9frcCUJMYUX7KOHupwR/COMVvDSVTVEzli/aYIAx/ap
         7rpU51P9Fj//MearjwF1ZaVyDgUrY6L97G/js3RcNOjyImjFqbzhZzOMzlDbxzjBdYrc
         rlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202164; x=1755806964;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bMWDRwJwZj6qLhFgWvOz68lXKSU0dd2mnEaog5fuH+Q=;
        b=tgNo6dVCKuGFfEJHaC1HObi76BWQwU/2xwSFfHfRoc+PVvHadYAoHOys7jDB19k87P
         1ldbOTTs8x6kmeB8wP1oALIcnWErurdnCvl2UKNt4gXRDonWlevGxwFRGg+yURXQ1etF
         EbGC9kCYBEAfjQpfijiTbwgIG9gJv6CW6ouxhlRV9EuBG3VKIkG3RNyCUPw93GH0YscH
         4CQ3yCdczk6lJfXkJL1Gn0Tqlj9uMT3eCHNZPK+emadFfrXw6vxy7fJmplff3VoRdqPj
         vC2Ze6Ock09FzsSo45GQR1trJTlSLiBCBdCB3wOBBoGZEukkbiblBYX16aDfcS0ri2vQ
         GCnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGVF93Hjw4d9oo1dvikB0zMfVTJT14+ALCMe7ctbYtLtItghIjWQNVLIUtWAjLb4v8lUeZxwVeAw==@kvack.org
X-Gm-Message-State: AOJu0YxVKTWMbFEXRR3svdvMx/IPQxFef3rGMW2reKfr36bgd1vjI8bk
	AcugtekkJO4PtfL+4cGnW26yg196Iid0LCSidvBdJEx6PP4dJYS7Fu1BqyATgQC3+F2Z70ldGiH
	Lpf8vEw==
X-Google-Smtp-Source: AGHT+IFje8BoX0rFMQZYCLiSz6us/b9pp/B+IiT79+DebSAxtnCRFOhBlrxLa4L+ahHzlUigtDSR9HFZ8z0=
X-Received: from plhi8.prod.google.com ([2002:a17:903:2ec8:b0:23f:e59c:8c1f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f54b:b0:240:6766:ac01
 with SMTP id d9443c01a7336-244589fd923mr76041705ad.2.1755202163976; Thu, 14
 Aug 2025 13:09:23 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:38 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-7-kuniyu@google.com>
Subject: [PATCH v4 net-next 06/10] net-memcg: Introduce mem_cgroup_from_sk().
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EA2C40008
X-Stat-Signature: d3cupqxthoqm11ehbe6pnecdah19gfuo
X-Rspam-User: 
X-HE-Tag: 1755202164-786972
X-HE-Meta: U2FsdGVkX18RjcCFN2Q4NVxEPqLB4uOr8hIIKEGBHZsm6YLHJlY+18Me3UpG4YZllAfaIbTItobYUI0nHecSQ1FLsX3Fua6ge4ptlAXBG8AvJXvvco35IEDpw1M3t4JqIXTXI3DdUg7V6Y2sij/xfO0FCWsKFq17m/rq8wXYwP0to5PY0JVnm34nc+AaF4PamaWP+am2w9Yfgl7y/fe7HvhtUztrwp+VeQCN728FmKSz+KuJ6g8MU+T1Av33KiAkyDstCD0uKnVRh912jJn4SlDEHhBndHoD+FwS5jQmOIGHys3XEWsHVJamf47invXddpJq63AV6gqchAW56e6h1BibMtu67naE5Hzu0x5iLclEDBidIZ7tABMiPqNKc8uTwI1FAhka+KzjgCDXNr7wbzycGSBaUp9u26OpAv4kIO4PhKhIv38YSTKhHQ11miC922BxSacK0U2igKU7SHVzrPAUbPTaN1IG+APIECK5QF2k+GRe7ar868dRVnyLzavyqN64JlEFzHCwlzSeehM6AoM9FaHmYFmHGDFsDZGbDWeSh3bHDta2cFqDiUw4Omj4wS5DxIpVeVKcqBOmaRv4E8zdvhqstcxfziOB5DWRBYHurtBkTnNzRyMabyE3ehQIPrfMyXpMjvAbHCPQ8fVeiIQiLAFm71n+nujrL90VTIVV1EYhXVqHD8+ElMvkghy7TRuHkPDsZkK3si+BgAkVfflhe4bq61alMv3h41fIoUjGZNb2LeFPJ3MRJduKWH+C125EhaBN9ewuTuMdmzle2x9rQtdIwZUpWvfTYa+X6p7NnhT5UEG83Pn8Xt6I+5QuFuB0l3+lEUbfTHFPAltpVitiSC3Xp8EJq65I5roAwynSBU6a0uwlcwzQ5RRTjELTSuIbOib0penxhNKC01YysM/A/DFYyEw+ZZlJbDkt7XnrmGfue2T8ZjrITBxXjDUvnPoUgwr6DMY6hILVVkT
 eltQDEsY
 TlhjDCl2Hvq8KnE0KXv5CRZD9Dr7uYZYmwT6qgPdrL3HRHEwe0iCxx8Mu5oKZCsKfGJ7nIy7/zpzW9CubNmvqoV7INPgptGvw5Mh7RmWfYPjc9j39DC4TfQnNmk/hPuHKmAS62HoX0B5X36UvMY4iHp8K6vT59rgDYbFsFXF2sOkP4F5qxqJXb0+JM/bELGsQaV3cUeJp3Rk6H7PuwaBN9nMw5k+Dcp7YIO0RX4AC2cW36K+S9PHurNweTp7fhQI85FnWUYI+Y9DoQeuTSAWkcIWCH9OW0GBP6uPzN5nBeulVxXn32cnZk0U+ZilKOWKrZ8g2r/Ctj5x0rGjJUOWsB6TFF2/lBYO1W/uZ9bn7M+2BWCmQx3RARP0K7p9RwsMKLXbHYIc7Wm8JkIsa0/tWRmt1M5DBNF64I8I4nvKlnPrwYqh3bT1B8Y475VF4ApBegiiam+i/cHbje5Q9o4yLrxUoGJHlFQgdBmz63ph177wCMHwEkmRi0B+0Vr86Vgo0SJzCZICwlegQhCg6ezfEsJKcpIFE3L/QgvjRlSBaPtIP3nmFMzzLrALA7ax4F9onImW1nq8qI32uCMi29GSIQBMqmw==
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
---
 include/net/sock.h              | 12 ++++++++++++
 mm/memcontrol.c                 |  6 ++++--
 net/ipv4/inet_connection_sock.c |  2 +-
 net/mptcp/subflow.c             |  2 +-
 4 files changed, 18 insertions(+), 4 deletions(-)

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
index 450862e7fd7a..1717c3a50f66 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5023,8 +5023,10 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 
 void mem_cgroup_sk_free(struct sock *sk)
 {
-	if (sk->sk_memcg)
-		css_put(&sk->sk_memcg->css);
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
+	if (memcg)
+		css_put(&memcg->css);
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
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index a4809054ea6c..70c45c092d13 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1759,7 +1759,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	if (unlikely(!sk->sk_socket))
 		return -EINVAL;
 
-	memcg = set_active_memcg(sk->sk_memcg);
+	memcg = set_active_memcg(mem_cgroup_from_sk(sk));
 	err = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP, &sf);
 	set_active_memcg(memcg);
 	if (err)
-- 
2.51.0.rc1.163.g2494970778-goog


