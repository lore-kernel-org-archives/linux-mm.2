Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB6BC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47FDC6B0092; Thu, 24 Sep 2026 03:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EBC6B009D; Thu, 24 Sep 2026 03:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25ACD6B009E; Thu, 24 Sep 2026 03:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB48F6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:36:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 318A612024B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:17 +0000 (UTC)
X-FDA: 85247847594.20.4673E22
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE2E5140002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LY0tlaSG;
	spf=pass (imf26.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qi10NZuM2ME+TiMv17luLNhhaTKggBnB0E+h6d1MjY0=;
	b=S3KGPQFrlBO3cu1BFHezg7sBn9JnQSJwOzBA2TvCots95P5XWTwGSdajysTPMSEy8AkVri
	bv1WiYi55wWkqJ44mMmWQO16RZxX1VG2PCd0BoZJYlOg1qf/CgicNPSqqM506402nVJA0L
	IVYMILL3SNLw+5D1nC4BKxIWvw0igEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235375;
	b=6JzX6vgFadcNPG8utwFU+xwDHuwX/mtJqle4rda1uIkHtVMW5cCGoXRqKWsCE535lcX+gQ
	oHgNo9wP3hrWwPJPPLHRsnAvvcdSOCgpK4eFnPUpfkJjEj6EDnlX4Myc6ge3OSMtyOiKlO
	6532oVwI+RGYtAPK4hgpEh0pCtl/a+I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LY0tlaSG;
	spf=pass (imf26.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Qi10NZuM2ME+TiMv17luLNhhaTKggBnB0E+h6d1MjY0=;
	b=LY0tlaSGYXvws1q0otD8BVANdrb8tYDMX5CLx6AqJzXm845gKIzsFfieImadi4CdDjFO18Go7
	DCieD1D2RCvirKiWZnjxc/3oLLajb5rQ8SgoVhxn7JBdI1kR+pbNEJHsnopJCvqlyzuDvDQi49d
	s8fZ/UlG0tfCUIN3hsVZVfw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hr51J460DzLlX8;
	Thu, 24 Sep 2026 15:24:04 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 83D4940565;
	Thu, 24 Sep 2026 15:36:10 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:08 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 3/5] mptcp: sync memcg budget and drop backlog page compensation
Date: Thu, 24 Sep 2026 16:02:17 +0800
Message-ID: <20260924080219.1036588-4-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)
X-Rspam-User: 
X-Stat-Signature: cattejwxhd161cttgixdsatp5wrqmuan
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE2E5140002
X-HE-Tag: 1790235374-379391
X-HE-Meta: U2FsdGVkX1/nQL3L6P8M/YpIz1Z5ilFfazl1DAxXnbSs9hdMfmbdOFM78BGCaBFUIRA78k9ZVSoGv7wDqyhLUvp7/mT+/h8TuCqLQQp8bnbsxGwHoN/BzfdlkjjkBdCe1kkWVesPscebCU5GYM55xbxBs4NcJ6P88d96Ah6cvL4M5Jj4HRbUVCZ4bJ6Yh9qC3jYz4L+QKYTR3UB8wHRM0mGn2pOBjKmR1P7Iv6RrVIkxdJ0tx1uBYZH/FHkp1xr+yqyanoBfuAYZsRJzEClhRTFQ/UXcBxLVwzgPpL4/gcuAM+CKjw4W9AK/R+8VWGBlLPirnPS/apcZlWC7x4u/HslJvkdCywXDeMZoTZyjpgXNAAp1tTQeGCvln3ZCGjOPdOi9VM9cse2MRN7l/IpJb8PLamB4gmykJwg85/gF5dTRkHgrQ3Nd/joZePIvDnCB10N8FwdkAzOvfsb2uCZbOiJAJmVbx103zElZrdqUfsdVUHvFqR/WnI5cyMEiqAdXEIRuGKv4VDjJ2BScJvOJkgndc53xN7F8CdXt8KR65DCLOWcsFg8eCmkt+Qm33TNxvoBCqxF3cbePAwo5P1qPS0Z06JFGFP6NO4+8x1i5JjodUgR1IbJrDFnkbW1NW7xR97T3fPDkRKVkPUorHn/6zg1jwbkjfZs+5/hh+vFCiyhQTxViQlLy9+cWeYufIyOf+z9pIMZtdaR6jChHnZZBjXAW+CTB9IgbB3Raa7/BCnLzywXZGcpFZOD1L1mvf10NEgJsWr+9v3mjPW/QGqlb49RhLTpNpKX+IbGJZ+soGSc+6VFDkGpw3E3U5O96kJ1m0LwdTxkleQ9B2wZZLWTmAlbjGWEtXtIq0OJTodJ88OxW8AZT4WlIXJVf4jb5h+yz9CKS4Fg5O3WHmgc0UgowJzlOrYa6a2gd5ENJa4KE5qV3o+zjsk8p7RB38mwAWEHdi1ajHCM7vDrDMkR93vH
 Ne2m76+d
 axtIMboooZIy4VXmk364+e8Y/qLAuJsd89+kUf6NPtqUX5p+8ap80s3Mkz3CvaYu0eNzwNzkS9Dn3LTndtvhDFQ5C8gbUhYBa3tGVxsEL1AVUiIaBUhGmWKYEn7OuxodOOWJruXv+3LrGvx5m+Lnc+oj1WNFB82jAZwQ/jf4MhZDSTMpeRJvctTCrxz8qcXcjV3LDIvu63Af/0npqinZOYh1ABH9j9fy78E9luBG8kZMJgfqlCNiDFpn+lnCIjEHY9UlG6sjyatCBBMXc1SoFrU8/GNu6umbOqX0ob22rSKpYzbysgXpBYfCvi3r5xGfpQ+St
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sync the memcg budget tracker at the MPTCP budget writes:
mptcp_init_sock() (per-net rcvbuf default), mptcp_rcvbuf_grow(),
__mptcp_sync_sndbuf(), __mptcp_subflow_set_rcvbuf() and
mptcp_set_rcvlowat() (both on the msk and on each subflow).

__mptcp_inherit_memcg() moves a subflow to the msk's memcg: refund the
budget the subflow still holds in the old memcg with
sk_memcg_budget_release() before the switch; the new memcg side
re-charges it through __sk_charge().

With budgets charged upfront, the pages an MPTCP socket spooled into
its backlog before being accepted are covered by the full budget that
__sk_charge() charges at accept time, so the old per-page compensation
in mptcp_graft_subflows() (fed by mptcp_sock->backlog_unaccounted)
would now double-charge.  Remove the counter, its accumulation in
__mptcp_add_backlog() and the compensation charge.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 net/mptcp/protocol.c | 42 ++++++------------------------------------
 net/mptcp/protocol.h |  2 +-
 net/mptcp/sockopt.c  |  3 +++
 net/mptcp/subflow.c  |  5 +++++
 4 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0098e2830931..3c8b885d8298 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -238,6 +238,7 @@ static bool mptcp_rcvbuf_grow(struct sock *sk, u32 newval)
 	rcvbuf = min_t(u32, mptcp_space_from_win(sk, rcvwin), cap);
 	if (rcvbuf > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 		return true;
 	}
 	return false;
@@ -791,12 +792,6 @@ static void __mptcp_add_backlog(struct sock *sk,
 
 account:
 	WRITE_ONCE(msk->backlog_len, msk->backlog_len + delta);
-
-	/* Possibly not accept()ed yet, keep track of memory not CG
-	 * accounted, mptcp_graft_subflows() will handle it.
-	 */
-	if (!mem_cgroup_from_sk(ssk))
-		msk->backlog_unaccounted += delta;
 }
 
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
@@ -2315,12 +2310,6 @@ static bool mptcp_can_spool_backlog(struct sock *sk, struct list_head *skbs)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	/* After CG initialization, subflows should never add skb before
-	 * gaining the CG themself.
-	 */
-	DEBUG_NET_WARN_ON_ONCE(msk->backlog_unaccounted && sk->sk_socket &&
-			       mem_cgroup_from_sk(sk));
-
 	if (list_empty(&msk->backlog_list))
 		return false;
 
@@ -3252,6 +3241,10 @@ static int mptcp_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sk->sk_rcvbuf = READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]);
 	sk->sk_sndbuf = READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]);
+	/* The default buffers grew from the generic sock_init_data()
+	 * values: charge the difference to the memcg.
+	 */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	sk->sk_write_space = sk_stream_write_space;
 
 	return 0;
@@ -4329,10 +4322,7 @@ static void mptcp_graft_subflows(struct sock *sk)
 		LIST_HEAD(join_list);
 
 		/* Subflows joining after __inet_accept() will get the
-		 * mem CG properly initialized at mptcp_finish_join() time,
-		 * but subflows pending in join_list need explicit
-		 * initialization before flushing `backlog_unaccounted`
-		 * or MPTCP can later unexpectedly observe unaccounted memory.
+		 * mem CG properly initialized at mptcp_finish_join() time.
 		 */
 		mptcp_data_lock(sk);
 		list_splice_init(&msk->join_list, &join_list);
@@ -4361,26 +4351,6 @@ static void mptcp_graft_subflows(struct sock *sk)
 unlock:
 		release_sock(ssk);
 	}
-
-	if (mem_cgroup_sk_enabled(sk)) {
-		gfp_t gfp = GFP_KERNEL | __GFP_NOFAIL;
-		int amt;
-
-		/* Account the backlog memory; prior accept() is aware of
-		 * fwd and rmem only.
-		 */
-		mptcp_data_lock(sk);
-		amt = sk_mem_pages(sk->sk_forward_alloc +
-				   msk->backlog_unaccounted +
-				   atomic_read(&sk->sk_rmem_alloc)) -
-		      sk_mem_pages(sk->sk_forward_alloc +
-				   atomic_read(&sk->sk_rmem_alloc));
-		msk->backlog_unaccounted = 0;
-		mptcp_data_unlock(sk);
-
-		if (amt)
-			mem_cgroup_sk_charge(sk, amt, gfp);
-	}
 }
 
 static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2b4c27426477..aa34be38cf14 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -377,7 +377,6 @@ struct mptcp_sock {
 
 	struct list_head backlog_list;	/* protected by the data lock */
 	u32		backlog_len;
-	u32		backlog_unaccounted;
 };
 
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
@@ -1040,6 +1039,7 @@ static inline void __mptcp_sync_sndbuf(struct sock *sk)
 
 	/* the msk max wmem limit is <nr_subflows> * tcp wmem[2] */
 	WRITE_ONCE(sk->sk_sndbuf, new_sndbuf);
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	mptcp_write_space(sk);
 }
 
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index fcf6feb2a9eb..05d9dafa8c07 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -70,6 +70,7 @@ static int mptcp_get_int_option(struct mptcp_sock *msk, sockptr_t optval,
 static void __mptcp_subflow_set_rcvbuf(struct sock *ssk, int val)
 {
 	WRITE_ONCE(ssk->sk_rcvbuf, val);
+	sk_memcg_budget_sync(ssk, gfp_memcg_charge());
 	tcp_set_rcvbuf(ssk, val);
 }
 
@@ -1656,12 +1657,14 @@ int mptcp_set_rcvlowat(struct sock *sk, int val)
 
 	/* propagate the rcvbuf changes to all the subflows */
 	WRITE_ONCE(sk->sk_rcvbuf, space);
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	mptcp_for_each_subflow(mptcp_sk(sk), subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow;
 
 		slow = lock_sock_fast(ssk);
 		WRITE_ONCE(ssk->sk_rcvbuf, space);
+		sk_memcg_budget_sync(ssk, gfp_memcg_charge());
 		WRITE_ONCE(tcp_sk(ssk)->window_clamp, val);
 		unlock_sock_fast(ssk, slow);
 	}
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 01db7edce18a..817a98b5f40f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1731,6 +1731,11 @@ void __mptcp_inherit_memcg(struct sock *sk, struct sock *ssk, gfp_t gfp)
 	if (!mem_cgroup_sockets_enabled || !sk->sk_socket)
 		return;
 
+	/* The subflow's budget charge went to its previous memcg: return
+	 * it before the memcg association moves to the msk's one, the
+	 * __sk_charge() below re-charges the budget there.
+	 */
+	sk_memcg_budget_release(ssk);
 	mem_cgroup_sk_inherit(sk, ssk);
 	__sk_charge(ssk, gfp);
 }
-- 
2.18.0.huawei.25


