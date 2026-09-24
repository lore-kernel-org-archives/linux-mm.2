Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D19AC98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF9C6B008C; Thu, 24 Sep 2026 03:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14FDF6B0092; Thu, 24 Sep 2026 03:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011046B009D; Thu, 24 Sep 2026 03:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1C846B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:36:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BDDA140246
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:16 +0000 (UTC)
X-FDA: 85247847552.06.D321DDA
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55143140007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:36:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ONhULbsY;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790235374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eix0EmnHlcKPpRL88blWx7dbbcEZ9zSeXbIyhIkBRCg=;
	b=CTj24xrNSC/t/AUfihbR6QqbX9KHNp+gPmExEGJkKrlhSrpMTsUrAzoQR0NnQh2/CGaGJJ
	+hNl0ruGEGIoa51fAuT7/huW5UYb3AjPEglYGCRviBUr73pQEKYoFsFxypHJUAszFIJ6P6
	PvtqcGUaAaw/WOrvPsrOuLudweWUy7o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ONhULbsY;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of caixinchen1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=caixinchen1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790235374;
	b=Qzam281uAVXUUHX11rEtzZcW4Ct87+IBADSXbqUnUG0Ty5mIyTXnRywymq3B+5r1zlGXl2
	sQXTyGgOpmINVJny38D1TlPmMYHjvVuacReSFFssTWC3Y1tz+j6paLOJvwZfQJCek3GeQ/
	F2jg6m1FmcGH0nXHR52dS0Ke//6NS/4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Eix0EmnHlcKPpRL88blWx7dbbcEZ9zSeXbIyhIkBRCg=;
	b=ONhULbsYqqPaOUYOa3JDqZ/SY1mBLmqXQhAASrJE77l3Rsek/yi+TtxaDEQcSnH8v8qzMV3RR
	ot0cD71MFbm5YZfOYMq7Hm3xIOlH1n4V9bMqj5y7GskAeWnQjBrUKzqiAW2EYw+HcTkR06rPwku
	Fdz82nUPyla8BslzzZM10rQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hr51V4K6kz1T4Km;
	Thu, 24 Sep 2026 15:24:14 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 60CFB4058C;
	Thu, 24 Sep 2026 15:36:07 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:05 +0800
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
Subject: [PATCH RFC -next 2/5] tcp: sync memcg budget on protocol buffer updates
Date: Thu, 24 Sep 2026 16:02:16 +0800
Message-ID: <20260924080219.1036588-3-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.191]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)
X-Rspam-User: 
X-Stat-Signature: e3a53o6f7un3gywtcpxrhxfq1475o5xt
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55143140007
X-HE-Tag: 1790235373-208225
X-HE-Meta: U2FsdGVkX1+jLH7KzHKWNvYlNjEGEdx08xH3L6W+jqyMxf3AHn4MTGWHes7w6Axcnh0Gis+to+zWWI9LBCHl2sfbjGpykrjsyIUiN14Gr9eC6k7ZXv1gb+cw0y0/RdfWQXjvvW0zQcuIsAA7P2L1PdG/tRMdiTDPfvm7Qi1F5PigScIAaCjJFOggGGdZMYWPeDzkIpoXHUbhCqIvhvjJADMjRdjIkM11CldwQ2e80H9Lvja9CcBiRZuc4qeHf3YGnOH0sg82oZC0KgILWafdCWP6ikEAVVX62lZTgCFI0neadL7AW0OZIUhFtswAWlYD6diOqBRtkL1iRiBuRf+czfEqvKr3aXO93n4Ir1FVBSMSwIxP/rWPYjmHu1/68q0YlNf+ZcaE17Pi6k7SD5cvLGX3XD15aBmRi2cNughXR2UozHeeBvZ9R8kwotVoEmLCeMNmzfLiV3Ut/dnd+FclwOH5bN8fVZhypWz/TTA97HrCh9PrVJHqv1WtiyLK84SoHPQmruxnQGeEKQq6id2IeOn92+6MJZOMIgwxsZyeRdpQkpTbVEgflhHuKC2pSysEMnEcHwdP9HrFRvcA/QeiI8ysry0crjO7n60nvibWify2TcPSggc0Y9BIcXEKCwPgD6sJcgaq5jRmZEpE6nPebMmnVSXoi+1l0ORt0c4CfGdHX/92BeKWHTXoIDwSDtaFk+7gL0oZoUbPkfAxVr40S7kPml8WK5F8k1NGZqsZLGqhq7NO80FdJQkXrtDKeXSICrjIcW1xeiJlnCkgEuDZZQqnS2AACMFQTSe0/EsUqsxqvYgR8OzcdTolrVzCz9Brz3jKm/yaRQQQKz6M3vN32v1Vb3eKZ3nC3OYTWTI0Et4l5tK7a2k+0WGVeDUyb/SWAisgPk4e83E6yJEdpuo8AgL+miUmXVp4WqXCCXvNuoHU7Fh/+S27qySvt1Aj8j8Ov/01pLwVHCjwXN0+rO4
 W7zNaSPa
 4QoFaR0Na+wYU6iKeuKmxeQXzFPbu9580tsu/vxoqCTk3hH7/q+BS7A0sWCZ7m47JPB+YYTTJfIZlUV+pDu0An/jMQYj/ZrItUu3/c0AEIei5kwl8oOxGExqNlQ1WdOWerZpiHRRnb3Q6qm9s/kGetj5mB3iyfT1d7r96U9DieJNrWxBFaruoSf0dcOSJmWT8XZ7pOZreKRilRXh1QOcBQ1VBubIZjVMfbcM+mQUhyKQr7Bb/AlbfLLU/W8TRy+wYTAPfdEz38Lpl4YvR9tuCnuSH/27jrkBoo8x2+RkKyD4hOunJvpx4j5/r/QAsDBfBH4Klf/dvAlpF7fs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TCP rewrites the socket buffers after sock_init_data() already charged
the generic defaults, and keeps rewriting them during autotuning:

  - tcp_init_sock() overrides sk_sndbuf/sk_rcvbuf with the per-net
    tcp_wmem/tcp_rmem sysctl defaults,
  - tcp_set_rcvlowat() raises sk_rcvbuf from the requested rcv window,
  - tcp_sndbuf_expand(), tcp_clamp_window() and tcp_rcvbuf_grow()
    grow the buffers during autotuning, and
  - tcp_should_expand_sndbuf() caps sk_sndbuf under memory pressure.

Sync the memcg budget tracker with sk_memcg_budget_sync() at each of
these writes so the charged amount follows the actual budget: growth
is charged to the memcg, shrink is refunded.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 net/ipv4/tcp.c       |  5 +++++
 net/ipv4/tcp_input.c | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3c9e1a88a6bd..0d2a39672aa0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -471,6 +471,10 @@ void tcp_init_sock(struct sock *sk)
 
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
+	/* The default buffers grew from the generic sock_init_data()
+	 * values: charge the difference to the memcg.
+	 */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	tcp_scaling_ratio_init(sk);
 
 	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
@@ -1847,6 +1851,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	space = tcp_space_from_win(sk, val);
 	if (space > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, space);
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 
 		if (tp->window_clamp && tp->window_clamp < val)
 			WRITE_ONCE(tp->window_clamp, val);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0f60a1dbf927..8abec8ebf916 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -629,9 +629,11 @@ static void tcp_sndbuf_expand(struct sock *sk)
 	sndmem = ca_ops->sndbuf_expand ? ca_ops->sndbuf_expand(sk) : 2;
 	sndmem *= nr_segs * per_mss;
 
-	if (sk->sk_sndbuf < sndmem)
+	if (sk->sk_sndbuf < sndmem) {
 		WRITE_ONCE(sk->sk_sndbuf,
 			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
+	}
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -791,6 +793,7 @@ static void tcp_clamp_window(struct sock *sk)
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
 		WRITE_ONCE(sk->sk_rcvbuf,
 			   min(atomic_read(&sk->sk_rmem_alloc), rmem2));
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -948,6 +951,7 @@ void tcp_rcvbuf_grow(struct sock *sk, u32 newval)
 	rcvbuf = min_t(u32, tcp_space_from_win(sk, rcvwin), cap);
 	if (rcvbuf > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 		/* Make the window clamp follow along.  */
 		WRITE_ONCE(tp->window_clamp,
 			   tcp_win_from_space(sk, rcvbuf));
@@ -6055,8 +6059,10 @@ static bool tcp_should_expand_sndbuf(struct sock *sk)
 		 * it never goes below SOCK_MIN_SNDBUF.
 		 * See sk_stream_moderate_sndbuf() for more details.
 		 */
-		if (unused_mem > SOCK_MIN_SNDBUF)
+		if (unused_mem > SOCK_MIN_SNDBUF) {
 			WRITE_ONCE(sk->sk_sndbuf, unused_mem);
+			sk_memcg_budget_sync(sk, gfp_memcg_charge());
+		}
 
 		return false;
 	}
-- 
2.18.0.huawei.25


