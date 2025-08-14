Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF21BCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666529001CE; Thu, 14 Aug 2025 16:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D93900172; Thu, 14 Aug 2025 16:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57ACE9001CE; Thu, 14 Aug 2025 16:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44A45900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1F7B140775
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:17 +0000 (UTC)
X-FDA: 83776452354.24.13F3BDD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id F1D6214000B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="H/nR5hBn";
	spf=pass (imf09.hostedemail.com: domain of 3akKeaAYKCLMdngbrnZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3akKeaAYKCLMdngbrnZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HPx3oS3D/U5/Z6SJp4+G98+eGPb8Zkxs9lelPKWCUiM=;
	b=D+NLGGt3HpuWcjEDTnKM5/fN9jjmDXvyHm8WIOKa09Pyd/OuT6DX8+snXWUfQfoNVebUL5
	LV9QiHkT3t6JcLV8XndB3WY0p+LRWpnbTompCRpMeW6bMIZ4Lj9gPlkTMdGkHV0HHy/TF9
	mUEDKOcasFEzquAVm7l+J9ZaXHUNG20=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="H/nR5hBn";
	spf=pass (imf09.hostedemail.com: domain of 3akKeaAYKCLMdngbrnZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kuniyu.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3akKeaAYKCLMdngbrnZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202156; a=rsa-sha256;
	cv=none;
	b=CE6Ez847dXqi3czi50SaCPAkvFX15M7cerXsgaJwXi2QAuET9GKyOBb90rd+7ZtXijDYGe
	S5knnEUp9dEooJs0mRulDpHtRF1KBK+MtVesEcMpMGjhurSrZ8PAnpPmiCuVjuvEdNpn1D
	duWUAFuZurY/Q6r5+TubOr2ZeueBHkA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3232669f95eso1305915a91.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202155; x=1755806955; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HPx3oS3D/U5/Z6SJp4+G98+eGPb8Zkxs9lelPKWCUiM=;
        b=H/nR5hBnfB/t9894LvAAy/3iOFYq5cOqTeq8VjducqTLJJfHSN4N0m0x2jaQPXs27O
         6ra+eeibWZ+Iki0UOIFJMXLCsie/JtYFRYTpsHcMrOn+GkA7TGkohwq8KMj9hd8EpzuF
         7j8XyQn6n+gnPgkbpo0SlNvMALXMpN5LlND3dkEP4XNFvslnQ04XCB+jTmKOXQMLcnAw
         VUXVydesZI8PCg1O6kDU4JHWyDawSJi3ib4zk2jAE5x0pd1n5+SNYjC5dFhr7CZWVAwT
         4uIwIlu0RbqD4IjJ7OMHq0LsIi243bB32Uvn5ScNGgqaKsE1dLDwTxOma3sd/AVd5w3+
         z4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202155; x=1755806955;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HPx3oS3D/U5/Z6SJp4+G98+eGPb8Zkxs9lelPKWCUiM=;
        b=BugEJwTRA8lVOQP0z9QVboD4LRxVqBdbXgabtp6F6BuRJCPKd+KHZ9yhW/654cS9Qw
         zlGkbpH/fe92wPABrOPV06LJkMSCJ886G1xw7GDnE/mlKGolY/hOz1ejcs4vJh06VANN
         aciNcwNDQg99tRbIbqmvUegSbKJCdmecDUtWGxqBlDQkdSOOCBctKUcbruGWVJUkHPHq
         HtrrY/km1E8Y8BDvHfVI4e+NAiP9e38LT9kKhtjqwEor7h7U8u2M0UJNNnac4usQliOW
         65Gc7ZrGccWGRXG1fsGeDQ9n72JSr2asEO2EtPTtRSMgp6ArOCTVpIBSgZdF0rsw1eBG
         D8xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtI5gyEVnVvC0+bFP4+lP/DkNAyE/HIgV2OoEdNDmXPAYWBqEDGdqYQMeUg255kkJGBkp9VsFA1A==@kvack.org
X-Gm-Message-State: AOJu0YyCrEmtA1KZ1GPTw6rT4gwXFIs3IB3F+twxYImXkCUYPJKSHygK
	39goY0hXz0c0nx7E7kZAGat561H0kViVrmi8YytzM5McNMty/ZeMIXAM0P1s/KNR91QNWoUCEvV
	43Utj7A==
X-Google-Smtp-Source: AGHT+IHoeO4kZujSsChFOwaTNJ8uA4UdHGwa9a1sAiH+eAKhd1r6y1himci0q94O8Kz1fkx16/6OM5R2r0A=
X-Received: from pjbsy14.prod.google.com ([2002:a17:90b:2d0e:b0:31e:c1fb:dbb2])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48c2:b0:31f:6d6b:b453
 with SMTP id 98e67ed59e1d1-3232b7b76damr5551630a91.30.1755202154816; Thu, 14
 Aug 2025 13:09:14 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-1-kuniyu@google.com>
Subject: [PATCH v4 net-next 00/10] net-memcg: Gather memcg code under CONFIG_MEMCG.
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
X-Rspamd-Queue-Id: F1D6214000B
X-Rspam-User: 
X-Stat-Signature: d78xpwepdktg48d7bfsqhdmb9akouscq
X-Rspamd-Server: rspam09
X-HE-Tag: 1755202155-649287
X-HE-Meta: U2FsdGVkX1+4T95tGyCYO8SLpWylBRauvLKyDXrZ6WXlVKG7248mQWyMpDjIHif1da7XzkRZcQFVHTSVFFmdco7U482M+SakdRvTFsQZZtYniERmYouu/PIFco7OYuUmjNgxtl1/kC5gPGeXDyqZHNNNyctm8WZNiemYn9YLu2DG83qf1XkmhrhSCaE9SQcpnTMZRu+cMymmZ04DssY6yV65tg8kpv8+DguSennx0bKvIzOUSLfkbO6oclL+388WLCKy+4JNN/WUCuCVQAIHwT0IWxi4QSaxRSD01MMSVALua/95cQLNdTvIOAs3KPmebq4WMbMP9JJUBdYOZF/p12wsrae2/M1ROASg02KJ71CiCVKxQsAE06+lWUFg/DGlFEumIkviC9nKTItkD9fz0qsl/aKesIbE92nHDy9zUngkvIx4IhP0kObPo3rrGJDnzqwDAM1zzCwVhwpr8qK9kc2W3ZnBKyN3abV1LFP9lMe1nTIwf6n4RNhZ2WqqjeenNkMbzs6vImCu+Y9talyAU1hZ2j9XdwsPIFfhv6fImeVbYu8azfcofsAGG5qFW4AN6xTUwAK/PfFradk/xsOEsimcJcYV8cU/R/GXwlQNL/GAENs4m4EAzWdwTq2SosCaRtKcpGKp99S6WJGNUohvTLzzhTpVUPHJaFFrUr6Udhbg85YbG/grtkIZTwKG7X++B6pES2c1qxeAfQnWmPzb0m0ANVF9fpipNYPvW+hWVsM3LxeNx+7TuPG3gMuzfE1evaOxmWgKS2ao3hAC3Rg0chmouX14MqSHdHxNMcFa7tU5ZuvhH3aPcCeVrf9/Alvxpxy6qZdKWxg5L75ZjwRiRWpc8pqNdSL7rkcVBywL/X+TfHOCH/1AoDwUdgKQ81HI+oA4UnEn27mAxYa4rtOmJG9znKJsZoodFB+Cq8xBiDGLY8F6wz1l6bsFt5gXPgeDYT6Jxw2o+H7k4n27XK+
 mNKKETxN
 Nanjmg8GULXTadboMRjFegRmym7y3s4zsbzUIl+6jWSntnzXR2uDx6K0MDqEv3UP6cldM5w8iAmKLu5tBULEGG42j9eXnPm3fbZ1pjXQgsY/M63iWJcBcL4H60Lu4i/xIrwTqa6NC+2dHvBJo+JK48+1sSXohFIyiblKI4fOatMRE6TYbHsepyQEhDaMxHqXRECcLvs9X8a5Y0iMA2t9zrlrp3jl6Qf4zbBGkIT+sQ5c+7vN8wn52Uo3dKt3/CqwjTtMsszzugp8CWSFdcGraIZEoOlaNO1o4BK4LvzfgQe5OBx/AfKwBLlD3KbVthYGg/UPhBOFT1zXbOXj64fGWMKehiXGxi1bGtiqcS9DsNOUc2DTvGyR9eMrfYRAgmUorn4uf7fudixjyNG6tNQbZtkeikk0BlBVOPjhFacZvwKIhvGTn1D+p5u+Q71YE1zkP0YV4m77+9smB3zEjts8Kxoe+anvhqOZ7MTyF22PhfcRNNBqpEgSDRp9ZZ7ABOWpNa/qt37CucG5HpPl7RN+oHH8gReVmUbK1Fwaex8KQHDha405iiFwXghcyJChTZa8xxPTh0SPs2CAttnh4OBpeZC8nDlE1B5z1FiUBW6/wExdp6ic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series converts most sk->sk_memcg access to helper functions
under CONFIG_MEMCG and finally defines sk_memcg under CONFIG_MEMCG.

This is v4 of the series linked below but without core changes
that decoupled memcg and global socket memory accounting.

I will defer the changes to a follow-up series that will use BPF
to store a flag in sk->sk_memcg.


Overview of the series:

  patch 1 is a bug fix for MPTCP
  patch 2 ~ 9 move sk->sk_memcg accesses to a single place
  patch 10 moves sk_memcg under CONFIG_MEMCG


Changes:
  v4:
    * Patch 1
      * Use set_active_memcg()

  v3: https://lore.kernel.org/netdev/20250812175848.512446-1-kuniyu@google.com/
    * Patch 12
      * Fix build failrue for kTLS (include <net/proto_memory.h>)

  v2: https://lore.kernel.org/netdev/20250811173116.2829786-1-kuniyu@google.com/
    * Remove per-memcg knob
    * Patch 11
      * Set flag on sk_memcg based on memory.max
    * Patch 12
      * Add sk_should_enter_memory_pressure() and cover
        tcp_enter_memory_pressure() calls
      * Update examples in changelog

  v1: https://lore.kernel.org/netdev/20250721203624.3807041-1-kuniyu@google.com/


Kuniyuki Iwashima (10):
  mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
  mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
  tcp: Simplify error path in inet_csk_accept().
  net: Call trace_sock_exceed_buf_limit() for memcg failure with
    SK_MEM_RECV.
  net: Clean up __sk_mem_raise_allocated().
  net-memcg: Introduce mem_cgroup_from_sk().
  net-memcg: Introduce mem_cgroup_sk_enabled().
  net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
  net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
  net: Define sk_memcg under CONFIG_MEMCG.

 include/linux/memcontrol.h      | 39 ++++++++++++++--------------
 include/net/proto_memory.h      |  4 +--
 include/net/sock.h              | 46 +++++++++++++++++++++++++++++++++
 include/net/tcp.h               |  4 +--
 mm/memcontrol.c                 | 29 ++++++++++++++-------
 net/core/sock.c                 | 38 ++++++++++++++-------------
 net/ipv4/inet_connection_sock.c | 19 +++++++-------
 net/ipv4/tcp_output.c           |  5 ++--
 net/mptcp/protocol.h            |  4 +--
 net/mptcp/subflow.c             | 11 +++-----
 10 files changed, 124 insertions(+), 75 deletions(-)

-- 
2.51.0.rc1.163.g2494970778-goog


