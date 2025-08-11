Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48D2CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B244B8E0087; Mon, 11 Aug 2025 13:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB728E0060; Mon, 11 Aug 2025 13:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15B78E0087; Mon, 11 Aug 2025 13:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 817848E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B1CC136CD1
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:46 +0000 (UTC)
X-FDA: 83765169012.11.FD1ED64
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F0298000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BfIG2eWQ;
	spf=pass (imf30.hostedemail.com: domain of 3_yiaaAYKCAYq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3_yiaaAYKCAYq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+1u6jMeY2ieN9JTNQfSbMa5Js54FEKg2f0HWf6b31A=;
	b=eqjo1HPbcyWPM7l3I2AMnQznCHgOhG6HEPMilSTRJ2rB9ohFSSZrAKXH/ln3D9UgTdFB+g
	Xpdb43OlXCo4DycRjLMMKEL0ksK5pMGB/m5O8JzWEA8MtRxOyZUmfdV09NlDgVezPx722T
	hgq+unvoDZo98IlnHxZC7vtnpLXmUNg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BfIG2eWQ;
	spf=pass (imf30.hostedemail.com: domain of 3_yiaaAYKCAYq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3_yiaaAYKCAYq0to40muumrk.iusrot03-ssq1giq.uxm@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933504; a=rsa-sha256;
	cv=none;
	b=07BsQlYdRZv/uiMbq25HruXhZOnbAAvHJQ9I8QZVQz3yrwdYWaKU3v0/pLjvZlQT/q4Jc/
	nvF5a7iFDwlZochsAfRYBEH7Oo6evYWfCtMDlxsZ7IE95wsMfR59X5+h0FYKiSW7L9JjKf
	LJDDAnhToSqlJgtEgCOPpdo/HJWZpiI=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b42218e4a59so3369506a12.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933503; x=1755538303; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c+1u6jMeY2ieN9JTNQfSbMa5Js54FEKg2f0HWf6b31A=;
        b=BfIG2eWQAmDJs9wBO3gAnq3/B5eJGjY5qXDrcg6lUcTmBPk2qnV8FWHLZuhX1zOBGi
         Ld//FwJOLIQCEDM2+YG4Fxr4wSYwXHrSydqo5jGP+IKveVrW0nZVhNig4LMbYWbSZQPJ
         cn6S+JWL3JSdtcJFcxt8wmvL03NGnfrDIaVMIhC0Zi9qG8VfQd97F/r2c/qgb3grofEr
         WidFI3KLvrH/6p5DZNX/4EvzRN1yUBWgrOdDrkbdtOCSbunGLrAPQR6iI4+HfeNpGM3a
         wJiY9qF1LAv3/KvscO6YrVgTobQAqmKUAVaukTHlZz+E6PkBjYorkKqpQS5BzKRyaDIi
         2RIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933503; x=1755538303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c+1u6jMeY2ieN9JTNQfSbMa5Js54FEKg2f0HWf6b31A=;
        b=YWrTqHZv4n51ov/cDZnRVdfbCbKXy0mT2UljnSWfd582mvW4k/kUEjUnQIl+B6oIKT
         gGVtbABWru6fgJLiIq98IziAhIoeSlpGunorg6LAkIfcOeup1c6Pr1sLSPYEkb4do6hG
         JI7wsYlzUVXKQcOi4oEEORQV7qsQWwjDLbrubF+nMOdKDpCFnbeKbYSYOQNxcwXYXM4g
         vTSUXio1uyQAS3zf8/+GNvRf6fA5V5RZW2ksE9Yx54Vi3CBWmmGHbgaJIiEy158eDruN
         2WhIUQKcfKDibrtGxg/8LOz0oe70Hh7fD8ps2Up9AkQ5M98cC6OGWJb8BS6exTpjbHXw
         aJEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXouqt06NekScXJg4OB5d/f4vjaG7HcoOubWPr7NpvyserQS3e5PnVC+Jp4IIEcvbskX7Z4FZaW/g==@kvack.org
X-Gm-Message-State: AOJu0YxuQ2F+oKFpf6Wbc/A/qeh9/vj4YU6gRVtGwePRCePdVIRapRJT
	fRW5Rtt2HZtYOpspXVxPAb7/ERTKin0Xd70r0DG4kvRg366StDRpKy+HK2USwZxGfHLARHpg2Nk
	xDWJ2ZA==
X-Google-Smtp-Source: AGHT+IF+332pvw2sB451OsHxyvelGplXYYulyN1CCJNVXmCoa3JJJxGz6VI5u5TgIIL1LHaViiMtLlcnWFI=
X-Received: from plnd3.prod.google.com ([2002:a17:903:1983:b0:23f:efa6:2e49])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32ca:b0:234:f4da:7eed
 with SMTP id d9443c01a7336-242fc3a34d1mr5329425ad.44.1754933503244; Mon, 11
 Aug 2025 10:31:43 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:36 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-9-kuniyu@google.com>
Subject: [PATCH v2 net-next 08/12] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
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
X-Stat-Signature: csrcjg18horri8ortb5dyny8bsxtmysm
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F0298000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1754933504-757578
X-HE-Meta: U2FsdGVkX1/lu5JmyCK0pBxf+O1F6U9JP2k9e547ckeildUGuZJm29jaCMKp576MRCOb87ypCvGoKrA6anq0pOPdcNPNBUJwp3D2HRIcpVoHpwO6AyiYz4Ph2CZxV8jJQ8gWnl8AmdV+eoQTLlMvHIVUh42DqUqg8bz3HSaFYIbNf5gI6KCJCdUssWU1c+SS95lmwRtiwJ892bTvw0CFb9J4G1DDTxr/HHTZkTEyFxpXBz9iP65KFHk7Bq74y9kf6dZ1EUhkGMcEJMu1QAhi6UXMpse9H1fYqukvQgR+QluukTLJSXbr5p30cFKU2UMF3qTO73Tkoi+ro2950d4/5i6K06fUAYqMeP7Pca1BfN2MkpKHqj+wwrq0QDqMHghX1WscmZgsNlL3t1k7QMhanlbbSm3zEmOA09P+uGmCzJITOEcxzB/+Zzfl1bELrXkV/4QrJip+sOOVwWTU2bJdkH4XtgNHW7D42TNKbDYrb0XtQa5IKVYkbsONerDoWmWdXUpJwUj5qGRL+1XbDy6ghChbNDA5JuOBIfTjGMuqWauvowNu1/IOdVowVgNThbNBOMzjgmf6K3XXnMOxRjnjuxpniAKaDZ1TmqHCZGRCuGugOlJt/uDmgF0D2WIZGsbNZurTvyCZEtlu0LjRHSvHYI0NiLPk/GEmlYHM4ElnMMUfCYn4pxnyMo4mRt45EAwVMLZMZKekE7yb90he3rl01amSieDpNPg21Woj8qLzG82x+VEc3lBskZNG8CKkN+A6tuTbwKFFrxHX98YVaYL2805NFUgAZg0niThSkjRo20z1kzmv5AcAYdMjG4nPKdy0Y94BseIt/kIBbmXQQKjDtQSRl5aP6mKoqoXyUf6rke2yCqLl/x8cmCPHHzNq/Qpt+vbiUT9eMzkzHfJ4EdPZlF/8YF1L02Ku1cRLoxFwEN5Q1Zx+0DzTnLDoYm/fFw+04Twr/uofGxO3Mrc8YVN
 YLnRLxOz
 h0w8BhTgj5fYIGli0hpwvUG8PqcfQZ10uudh1P5Wrum1mwZW57uNSVG3j4lyc9FjliTjgxuLAYf3S5OsKpgKl/+lxDksNIJCWIh/i0U7HQlbW3+yM2n8O1xVNbFkY8P57V5qI42SiYePzvpdY8CQDvfzazOIoF6XwTAqVA2VL8l04J09nE4GLjQ++gn06hZEncgubYggHGCByJSUjNMv/IwdaaGMBehgEwS66ujtxMZpE4wpWkO9x3KPc51UptONSVrkZASM0FW9VKkB/VbNvIW/BJPdwLmKG6zzNnruERhkqoi7jVRH0j2kEI1H3cRZtkedL4vHfyCyxc4bsDff0snT6AgdzAgeejardGvrIX+TS3e79E8LS0m20amY/SHBO9LRcQOxVPmJjWhIqbKVkN4A2iczR+EOuWPqydGXDzGsCssSuKt5h0b3FoDvQwzvyPOdWIXG7RJJ4nirCVZzJQ3Ey1ugza14JhkntBAmSd4v+/qTNdufpR2UirhJJqZHOLSknAeHCQpX2vwHkpglZMkHeefDlp9bhdUZ0SMlo4CuouBhbxJJ/2V2/6O/hXX+fFYSG/ik2XYOtjbdK33XYnMnl6NchFqmZZ1SNin1+YpcBttmivputU7b+QY+An6+7Z2KoR7jZ2vkKRWW5Xph9lx3O6RE6VnpT8/M1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will store a flag in the lowest bit of sk->sk_memcg.

Then, we cannot pass the raw pointer to mem_cgroup_charge_skmem()
and mem_cgroup_uncharge_skmem().

Let's pass struct sock to the functions.

While at it, they are renamed to match other functions starting
with mem_cgroup_sk_.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/memcontrol.h      | 29 ++++++++++++++++++++++++-----
 mm/memcontrol.c                 | 18 +++++++++++-------
 net/core/sock.c                 | 24 +++++++++++-------------
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/tcp_output.c           |  3 +--
 5 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 25921fbec685..0837d3de3a68 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1596,15 +1596,16 @@ static inline void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 struct sock;
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
-			     gfp_t gfp_mask);
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages);
 #ifdef CONFIG_MEMCG
 extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
+
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk);
+bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
+			  gfp_t gfp_mask);
+void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages);
 
 #if BITS_PER_LONG < 64
 static inline void mem_cgroup_set_socket_pressure(struct mem_cgroup *memcg)
@@ -1660,13 +1661,31 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #else
 #define mem_cgroup_sockets_enabled 0
-static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
-static inline void mem_cgroup_sk_free(struct sock *sk) { };
+
+static inline void mem_cgroup_sk_alloc(struct sock *sk)
+{
+}
+
+static inline void mem_cgroup_sk_free(struct sock *sk)
+{
+}
 
 static inline void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 {
 }
 
+static inline bool mem_cgroup_sk_charge(const struct sock *sk,
+					unsigned int nr_pages,
+					gfp_t gfp_mask)
+{
+	return false;
+}
+
+static inline void mem_cgroup_sk_uncharge(const struct sock *sk,
+					  unsigned int nr_pages)
+{
+}
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2db7df32fd7c..d32b7a547f42 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5039,17 +5039,19 @@ void mem_cgroup_sk_inherit(const struct sock *sk, struct sock *newsk)
 }
 
 /**
- * mem_cgroup_charge_skmem - charge socket memory
- * @memcg: memcg to charge
+ * mem_cgroup_sk_charge - charge socket memory
+ * @sk: socket in memcg to charge
  * @nr_pages: number of pages to charge
  * @gfp_mask: reclaim mode
  *
  * Charges @nr_pages to @memcg. Returns %true if the charge fit within
  * @memcg's configured limit, %false if it doesn't.
  */
-bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
-			     gfp_t gfp_mask)
+bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
+			  gfp_t gfp_mask)
 {
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
@@ -5062,12 +5064,14 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 }
 
 /**
- * mem_cgroup_uncharge_skmem - uncharge socket memory
- * @memcg: memcg to uncharge
+ * mem_cgroup_sk_uncharge - uncharge socket memory
+ * @sk: socket in memcg to uncharge
  * @nr_pages: number of pages to uncharge
  */
-void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
+void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 {
+	struct mem_cgroup *memcg = mem_cgroup_from_sk(sk);
+
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		memcg1_uncharge_skmem(memcg, nr_pages);
 		return;
diff --git a/net/core/sock.c b/net/core/sock.c
index ab658fe23e1e..5537ca263858 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1041,8 +1041,8 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	pages = sk_mem_pages(bytes);
 
 	/* pre-charge to memcg */
-	charged = mem_cgroup_charge_skmem(sk->sk_memcg, pages,
-					  GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	charged = mem_cgroup_sk_charge(sk, pages,
+				       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!charged)
 		return -ENOMEM;
 
@@ -1054,7 +1054,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	 */
 	if (allocated > sk_prot_mem_limits(sk, 1)) {
 		sk_memory_allocated_sub(sk, pages);
-		mem_cgroup_uncharge_skmem(sk->sk_memcg, pages);
+		mem_cgroup_sk_uncharge(sk, pages);
 		return -ENOMEM;
 	}
 	sk_forward_alloc_add(sk, pages << PAGE_SHIFT);
@@ -3263,17 +3263,16 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
+	bool memcg_enabled = false, charged = false;
 	struct proto *prot = sk->sk_prot;
-	struct mem_cgroup *memcg = NULL;
-	bool charged = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
 	if (mem_cgroup_sk_enabled(sk)) {
-		memcg = sk->sk_memcg;
-		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
+		memcg_enabled = true;
+		charged = mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge());
 		if (!charged)
 			goto suppress_allocation;
 	}
@@ -3347,10 +3346,9 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		 */
 		if (sk->sk_wmem_queued + size >= sk->sk_sndbuf) {
 			/* Force charge with __GFP_NOFAIL */
-			if (memcg && !charged) {
-				mem_cgroup_charge_skmem(memcg, amt,
-					gfp_memcg_charge() | __GFP_NOFAIL);
-			}
+			if (memcg_enabled && !charged)
+				mem_cgroup_sk_charge(sk, amt,
+						     gfp_memcg_charge() | __GFP_NOFAIL);
 			return 1;
 		}
 	}
@@ -3360,7 +3358,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	sk_memory_allocated_sub(sk, amt);
 
 	if (charged)
-		mem_cgroup_uncharge_skmem(memcg, amt);
+		mem_cgroup_sk_uncharge(sk, amt);
 
 	return 0;
 }
@@ -3399,7 +3397,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 	sk_memory_allocated_sub(sk, amount);
 
 	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
+		mem_cgroup_sk_uncharge(sk, amount);
 
 	if (sk_under_global_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 93569bbe00f4..0ef1eacd539d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -727,7 +727,7 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 		}
 
 		if (amt)
-			mem_cgroup_charge_skmem(newsk->sk_memcg, amt, gfp);
+			mem_cgroup_sk_charge(newsk, amt, gfp);
 		kmem_cache_charge(newsk, gfp);
 
 		release_sock(newsk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 37fb320e6f70..dfbac0876d96 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3579,8 +3579,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	sk_memory_allocated_add(sk, amt);
 
 	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_charge_skmem(sk->sk_memcg, amt,
-					gfp_memcg_charge() | __GFP_NOFAIL);
+		mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge() | __GFP_NOFAIL);
 }
 
 /* Send a FIN. The caller locks the socket for us.
-- 
2.51.0.rc0.155.g4a0f42376b-goog


