Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82AAFC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB7C900012; Tue, 12 Aug 2025 13:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E148E0151; Tue, 12 Aug 2025 13:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB8E900012; Tue, 12 Aug 2025 13:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5818E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1972656081
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:01 +0000 (UTC)
X-FDA: 83768866482.21.B860AF6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53E51A0009
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qU+NewXZ;
	spf=pass (imf25.hostedemail.com: domain of 34oCbaAYKCJ0HRKFVRDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=34oCbaAYKCJ0HRKFVRDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nBs0EYqfbWl9UFV+H52iOxDMUVB4Qqo6amOw5/a/xOY=;
	b=VdTtmSom8qAJgnwzg4LtNFZ1k+wpIFeQvp/2l6p9nEpUJyLjbHvaHLznMqvZZMkv8nnwS0
	5owdoupxb/6iQlBl+XdLUXL//HcFBo15ZHXH4G2ddG84NmwHlCzqVDYz53N4NE8ne2Bwro
	BsxlBwl4rkKu32aSWFFwAnEDdAZtcR4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qU+NewXZ;
	spf=pass (imf25.hostedemail.com: domain of 34oCbaAYKCJ0HRKFVRDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=34oCbaAYKCJ0HRKFVRDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021539; a=rsa-sha256;
	cv=none;
	b=0JnW9e8xtqpJIaA306qMXU5P5ljIKWrVeEkLUJUpnEkMOVyuUr+/6bZ7PrkKhARB9GwoZC
	hkgtXtsUyA5PhkKLmu0CfaNx1fEJ1i23Nc+iQYwJ7Kd7Bz2zm8hV1xmvyPQV29gWLPCv/d
	alFnjpvhTWGDLc07Hq2+1oI1x3Lnq14=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76be6f0bbfdso7663865b3a.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021538; x=1755626338; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nBs0EYqfbWl9UFV+H52iOxDMUVB4Qqo6amOw5/a/xOY=;
        b=qU+NewXZLS5SzYO5GPPhPf0hSRunSnH2C9cSgLxUN1/Eg4igJSEBZd75e5c3gKnnu3
         H59lXRa+9Diwz5iFV2zRHccjl+sAbuV/obKaAqh0Kmu+Zm4h+PdsndjmJw5h9JBoNC7d
         HEfkWn9uAUcsgZck68275OOcHUZEsL6m7fsXBSzuePCt0icKwWV3C4mSXDx6dkeY8r5X
         4uF+ucZamQesSO60Y+dwWpxZCJklzpfaxygW3S3eJWUvQnCdOFcU70fz2erOuiDIrtxa
         ++VqhSBGnf/YvJP5J+B3kv7bl+tcg4XDA1Y4+3Ct1+flCar/cxyIjlCSj57P+zFWoiq/
         fNUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021538; x=1755626338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nBs0EYqfbWl9UFV+H52iOxDMUVB4Qqo6amOw5/a/xOY=;
        b=swWnF5m88E9+vjaJwpc28i5glK7ueT6llCOX26gZ2O4+j5ylDUyFgmz6SgOyqkjnoJ
         hpJnQVhdcvs8b/xcHi74KIf0+2/gBgTjg/RBeW/5nY1j15Dupw3eQY4MFYIthFrLjNXZ
         XpfVxo9yu878WiOnVIGmOsodv8WFKu+CHUIR7vc8UP0G8ng+u2vTcFj0A4cw82yYInTd
         ewLozFLTVDGprnOlD0np3ELFNsy8JAQ1Xv8sJFWR9xKZ4ZmUQX16byj/pYRgfpmus8Qa
         0TQH8JRhVwptjK349Sp5KRF+YkS+hRfBzieDzNjD4qMHcy7JEoaMFpf7eAGWCyDyC2pc
         h07w==
X-Forwarded-Encrypted: i=1; AJvYcCU0Z36lzLzjWLxffXAZ51N0UvDWuwoz0QG4SOhkTSrXNAF8/jeTSHpLIVJH3tBUFTsDrraL0L/f+Q==@kvack.org
X-Gm-Message-State: AOJu0YySOHQ5qKtzt8Wz6h+dyIKXZZmyzvf9LN6ffpyMe8hB2GjDwK7v
	PwdnL9ENb7oHfS+FPpq04iIDvLS+rB/8KePVij4zyli6OOnyZt9PKtkwMjkpnN9KIR1Hp+YPC94
	1d6j6bQ==
X-Google-Smtp-Source: AGHT+IFYsGjbaobi8vNz9wbDh44fnvU9qpjmhcBJj3ep2W5xNnuwjJPdvlexzH+8pKUpV2yp3JlpFVyM3a8=
X-Received: from pfblu20.prod.google.com ([2002:a05:6a00:7494:b0:746:18ec:d11a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9985:b0:23d:d612:3dfa
 with SMTP id adf61e73a8af0-240a8bc1fe5mr267608637.40.1755021538144; Tue, 12
 Aug 2025 10:58:58 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:20 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-3-kuniyu@google.com>
Subject: [PATCH v3 net-next 02/12] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 53E51A0009
X-Rspamd-Server: rspam06
X-Stat-Signature: s9epj7rm5t1re1g1bhuhmonwmb961ebk
X-HE-Tag: 1755021539-655521
X-HE-Meta: U2FsdGVkX1+w1bDnxzxiDsclT7GHet6H4Si77F6OwBwPShgGGdrm/FLf6H35T+Be5vfxqZzNK2QAjPcpuu1qbWpcCb43nP0YmE/93WADS2fTPq8Q4aHO2kk/MinWhFM9JVFOFYqz7jGl9ATu7xkHJanT3TIyL6t/eROHo+XZ3LO2UpB5TofEdhHRBhdvnwrNS5MBJoNjePWCTOWCfjRxa1eftVsFh7t76ToVCr/C5BgSszUkXl+6iQ50erhacj4oDx0k/D6rfGNXDKYsdqQjYWPa1puUdy8YfqIKTOyZnDNDa0VvkRbUPF+0YTev6op7oPvznp7qpxhMKqxV6bOa9O8NiFkhkmKi5TwOlipaVL3bLzkQP/2TW+FP17s2ye/4yTp5yq93Tn4gDZE45E7bZko07pERUu1o6Y82FDG7tU16EBOpMxyXf2TOS6jFZ7uUaagAK3JRfYHyqPRgPiyWHQ+qQaZFPPTPw5ztOMaZ8b+fM3XD6MRoqandh8+1NKEpOdRZ9PPNjuMAslKatd4qn1FCTLhTKcKd+i4anGF/8XA7g0ktG05LEtRQPeG7n4BY3CLVXoPfLhQ2sYgAg/XPw5YQMLm5vxZwUW/+aGZnVG7Tzf00FF+GKWfIyHQzZhEAGXpC3hresxN2jRoxm9/Z+JbWXvFTBb8Di9lJfMaAioX42dWD4sFu5UYw62makMDYlDkkE/edgUqXgCv8NPhYrDanagBn9r3K+QlCzrBOWaOMHJ+I3Bo23okCkgf/Lhpext1h61CHsO30D043CnokYTzuQvCrovR5mJdYcBle1Qz0WFy3x+K1kXgN0KNm70btht0XWMToRhJeuZwR7A1P5zvhkZLDIg7bdAAzDpJDkFiKqQ4VPK4Xx9zPAbvjjf8L6NvV4SoNIKTubSQzqU9iLAxBsbDmleOoutM1q2takKOuPXhWruxnoN544sE6JODqJkTktIh2GlzcCFaoM5C
 BbkF6t9X
 PYi8iS7lMtWopMcImHuBqHjFnfRSoagEitiuC+RTIcP8TxPUqA2CGHVdYGUq2ftmEyuT8pLIRHYyFWYVx+CPZyJDPSFKhYeDoxB2J4kg/z8gGQW3qqkSWIUxi/MAQA9SuIkET6SwtqGFWl+guJfyyjNxPOA584zbDGii4VqfPF+ZYpGhUUscZVb2du3W7RPTE1Or7rA4ePhs7W0DWAVzASTb7eEQecDn/kn6jBOexKc+MmFJf752Mmo/X1wbkDKYccZQOg5wrLrz8WmDrjYmNbtKvSLS8i9AbbKxNpBXB4gyLu2l1qOFEiIuz+p9vEmePlu2e9MVkJOepArGJaT7HpFSouHFtghO1anwz9jG5SGlqnguNvAwH/0LTSZiGrCufwln/W4IMhQ5RoC9V8omcFi29tGJBT8pyqV9+r/u+QoY19GKta97pRVh2SIt3el6X/8vYegTtsCF2av0AJWwzM5kKf9CBcPA615wLUUJ2nw9NRjewl+ChkG9c4JKNPTEwRojzyEnb3Q+zc3gt+EqnoJVXhwc/YF7NT0NtNVFJmNwpEelGt1Qte103xOqBpJGnJI1TcPuOtriAvArKq7dWSe+d5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some conditions used in mptcp_epollin_ready() are the same as
tcp_under_memory_pressure().

We will modify tcp_under_memory_pressure() in the later patch.

Let's use tcp_under_memory_pressure() instead.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/mptcp/protocol.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b15d7fab5c4b..a1787a1344ac 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -788,9 +788,7 @@ static inline bool mptcp_epollin_ready(const struct sock *sk)
 	 * as it can always coalesce them
 	 */
 	return (data_avail >= sk->sk_rcvlowat) ||
-	       (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-		mem_cgroup_under_socket_pressure(sk->sk_memcg)) ||
-	       READ_ONCE(tcp_memory_pressure);
+		tcp_under_memory_pressure(sk);
 }
 
 int mptcp_set_rcvlowat(struct sock *sk, int val);
-- 
2.51.0.rc0.205.g4a044479a3-goog


