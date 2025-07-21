Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8310C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466106B0089; Mon, 21 Jul 2025 16:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416C56B008C; Mon, 21 Jul 2025 16:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354996B0092; Mon, 21 Jul 2025 16:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 267E76B0089
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA7851D870F
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:29 +0000 (UTC)
X-FDA: 83689429698.13.CCB5105
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2562B100005
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zRxvKcXe;
	spf=pass (imf05.hostedemail.com: domain of 3y6R-aAYKCFoCMFAQM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3y6R-aAYKCFoCMFAQM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130188; a=rsa-sha256;
	cv=none;
	b=bGjQKJ7n9Bs3WzQ1NSK7St1H6aLqTou6Ew489rTixP3ebxqOqZMVW0OwSjn8dpOUG14gaV
	1E375xfd18ZOdKBMgZ7XcwbiVVw0QVQENzHQkL9rmNI6kPdZhWsCVP/bMRvpeI+bma+ISP
	H3P3ZnQFntdzgIupPTiTyVvVG4aVrS8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zRxvKcXe;
	spf=pass (imf05.hostedemail.com: domain of 3y6R-aAYKCFoCMFAQM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3y6R-aAYKCFoCMFAQM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=51pOOLX0fQOfAGdnQSkiq2EVyVpnq9ZJH4RYM8SkY+0=;
	b=Nq+l7iXx5s9gUTDSkIyIJpNnSMzl4BZoSQWwCzZmvQXaBu4m0mY2SIj/B9RJd/hS5PJsL6
	oxO+94A1a6rd2WcmU2qz2JZOnR4vCfFb9YNllGBd87FXR0Uw6Wxqmvy8RtQk2LvYjdHDJb
	uzJMBTC+K0Coe5ehd1ID4LfFMoK5Q7Q=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747ddba7c90so3943186b3a.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130187; x=1753734987; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=51pOOLX0fQOfAGdnQSkiq2EVyVpnq9ZJH4RYM8SkY+0=;
        b=zRxvKcXeJ7xCoJw32n0Iw3/8Y2enIOfKgS0/xQXN0nipF1TcqvH9gYpne6Mkrf8xUE
         M96aDQcN7A3vYgsDtOl68hCg+TNfWS/KA4f37ofy3nBv8wgi9oJ6ppkrFwWRWXmtwopH
         Y6zk3Iw2zfQNV/Kn2s74PTmjli89XZZFOTA+BJUn0kGqnglHoS+yz9ESGjauIYi42s+3
         nHSyB7QOaI/2ggoKMcA+kiUC0nKOBMLkptODfnX3dKHL/4T4yG/Nh/MX3oIJvD/oZZ/2
         sJPTwdElgQujh5IkSZ8rEqfGZGlEGbUzRDsnbaZ3dzyu4vRseVAUhmwMSX5ogQ/vPLrt
         VOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130187; x=1753734987;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=51pOOLX0fQOfAGdnQSkiq2EVyVpnq9ZJH4RYM8SkY+0=;
        b=v2G60uvLsU/UTcvpForEAU5qNhLEtA39Mzwm36+WxpNQp+Y5Arp/Dfb8yj4xItOm0R
         4OLYG9+U7wMCz5Wt/Tnx1Fflpso9GLpGwgxmYO/dpZDYCyKhc/ZPBP38rQBlmTcqcVLK
         7rKgUutCnUvXYoKHEXxO7LEpYqkseHvVNmWNN2L0XpzL+I1qdvItLRwrAaEl0MZsRXa+
         gqMX1sI2PFRrp4Y/H681cDDpVnHHDXSSCQ76FDQEot+khk6g2dRYKgfvHrwKKP5fj4Vu
         /RBdN3U6WUGZe/E1D+qH878SfQ6X74sviGj57woFSN6lZAR2enC1NdCFeUh0xZFFC5hp
         k/wA==
X-Forwarded-Encrypted: i=1; AJvYcCUhP4PX3QpmcJL76x0CRGxd09Sj0fxl9xk2HZTbKO3/vddEwtdjRhLA+GpNWBpAYNiknVbMJFUkmQ==@kvack.org
X-Gm-Message-State: AOJu0YykMIq3jAi7udXIh3ipkTetKgyZUWVbzPtx4z07ZaKsDfMKviYC
	KUBOdhPd5lS8dNB+oKXJ5Ib+O2t4l7wkmuN9sEdzmuyiuk4BSLZ3H0vHZgMcr5KLgvDFlD0slVC
	A79botw==
X-Google-Smtp-Source: AGHT+IGVZNNr93fPRWqdHxWab0gu7wbq9VcEZmziUgmJKmb9TSvPtgxLvPeY0lMsvl6TgzUysEMGklwL2vA=
X-Received: from pfbjc22.prod.google.com ([2002:a05:6a00:6c96:b0:747:b6ba:35b6])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:ae0a:b0:238:f875:6261
 with SMTP id adf61e73a8af0-238f875633dmr23007475637.23.1753130187000; Mon, 21
 Jul 2025 13:36:27 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:19 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-1-kuniyu@google.com>
Subject: [PATCH v1 net-next 00/13] net-memcg: Allow decoupling memcg from sk->sk_prot->memory_allocated.
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2562B100005
X-Stat-Signature: k691byj49gi15p3hykfw5qju8wpiotgm
X-HE-Tag: 1753130187-244639
X-HE-Meta: U2FsdGVkX191yM6p402S3NBSghchPwSLXLHufm+/p/ku4Cqp28GTUwyqKObMh/JgkOWCXLnXeJYdkVx5N4BzyM+mjby57IHTans3qsJ1DTA98j3+rp5xvCMNbxem9MepmgdplSEt6WRq7Z7rE7GYpAF+YQXGetnQc+0YEhxwun90z7HwpjLBOpN4TS8Afijim8BLC0xVah5+X4YCHzDGuawEgQbMjxpqZ8OhtcKSYEHfOhB8dbL2iPNXnEHQZdinU/ClKPEg+MOzNrjN+kJCLvtCDLOe0io9ujG/V75qtFIdPiiyPpMfdJoKN/Xk7scr4PqkfvsKGdEEq7zahlTivtaeuD8kQvGYJ0NRde8PP0GIyHWPA8qM5zuDHwuN/CKUFOGyJSuuJI2ke10wVRchQFIqQqphPpOVmiZJAMEF4VnB4zWf8M4e0UCGqzqpECeP0VSOxBHQpA6l7kY4S4kl0uqONq49lOyOBJ37VD6SfbFEyy9by04f/TW1Ik4/NcfeexwP4D3zvIOtMNayTerBIPLCfWYVLkEKtRSRaVMG6d3JiKcV5kXCLtMAiRHVXQb4v82s+CuMajKz1xlSOiOpS8KxAyYBYFvDT8Tje63dHevZzw5ktWH/GY9aPo6Uc+Y0JQI30bZ80LG7sWzKrhgJhIEdTQK+9mtjMJU15vXfeoJ2FwjSEnmN6w4A+wH8nvygkRJWHeJTi3sBUyynDsrSXHXIIFcyakDzlQxQxfWdlbgsshf21lWEqtkx+1kg1rwATCnnl4k4ocO9yxou7GiNl8UI6WFP92B+Lr/oV/l+Wg9BMTMqwyUyJdyo0y3dwSOGfrxHQIw2QFg51vtP6+J9VeZLLZUdkOPUoR9nsr+5G+J4YTNZ8vgCLbgwlJHMDg3VFPaloIwkSPZsT0TOfg3/sT0vQG88WZppa+c2y7XlaFWNvShZ5zgT9RCUABhicvA0No6zeQNM3Hhz+6rFEj3
 jidv+JCB
 QUQvUCIw62Y/BGQFposzHeEjqhtaLelMIJDpH4gRWtVIgzuC/0m//v0K9tlzFTqT9hix+yR2yBkeKU5F/ph0EHespHDQjMlsurwzJ5xmQtb/KXZqRAbOzHgOIbO2pvKsM0BBMwA+WW4a2V2kjKc+rEquRKISaT4GLORmPruue9rA6lo3M6DEO4lEjCv9W4Si5nITtK6Zi5YFZMRtp4C8WIqUSQVqRno+I83wO7r6Z0zomLKz13JMN/66WO4izukzFoh75ZueDtmWCI8owEyRmji04saZYIDcEC01k3wExzWFAEnH2y9P2X1gKs7icInOy7uaCCj1LqU0ZRvEJUnJ6spuqCbzjEqXjH8liRZEXZHI3Yv5S4hlIk0Uj4YQVReTXiCTRqShbTVJF9QuryHFYgzComTLOCRGt3whKDnuRDJPmtA87IFNWyILpsUGtoFLW0LpdR3cNHFm/DBVKxk0Wn4JRFKmNcAFtS5LrnpxvdXEPJcfxWTae2auxKoJL2V90NfVZ4ka96Z0PDsDT7DSGFmBUrKAwPKAuKyJvhLkYPiZL7w3j9xwqYgYBtKp0VCk6QPM2ij/LzbG4ye7cMISJXPTCKw1kVvCZ9SR/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some protocols (e.g., TCP, UDP) has their own memory accounting for
socket buffers and charge memory to global per-protocol counters such
as /proc/net/ipv4/tcp_mem.

When running under a non-root cgroup, this memory is also charged to
the memcg as sock in memory.stat.

Sockets using such protocols are still subject to the global limits,
thus affected by a noisy neighbour outside cgroup.

This makes it difficult to accurately estimate and configure appropriate
global limits.

If all workloads were guaranteed to be controlled under memcg, the issue
can be worked around by setting tcp_mem[0~2] to UINT_MAX.

However, this assumption does not always hold, and a single workload that
opts out of memcg can consume memory up to the global limit, which is
problematic.

This series introduces a new per-memcg know to allow decoupling memcg
from the global memory accounting, which simplifies the memcg
configuration while keeping the global limits within a reasonable range.

Overview of the series:

  patch 1 is a bug fix for MPTCP
  patch 2 ~ 9 move sk->sk_memcg accesses to a single place
  patch 10 moves sk_memcg under CONFIG_MEMCG
  patch 11 & 12 introduces a flag and stores it to the lowest bit of sk->sk_memcg
  patch 13 decouples memcg from sk_prot->memory_allocated based on the flag


Kuniyuki Iwashima (13):
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
  net-memcg: Add memory.socket_isolated knob.
  net-memcg: Store memcg->socket_isolated in sk->sk_memcg.
  net-memcg: Allow decoupling memcg from global protocol memory
    accounting.

 Documentation/admin-guide/cgroup-v2.rst | 16 +++++
 include/linux/memcontrol.h              | 50 ++++++++-----
 include/net/proto_memory.h              | 10 ++-
 include/net/sock.h                      | 66 +++++++++++++++++
 include/net/tcp.h                       | 10 ++-
 mm/memcontrol.c                         | 84 +++++++++++++++++++---
 net/core/sock.c                         | 95 ++++++++++++++++---------
 net/ipv4/inet_connection_sock.c         | 35 +++++----
 net/ipv4/tcp_output.c                   | 13 ++--
 net/mptcp/protocol.h                    |  4 +-
 net/mptcp/subflow.c                     | 11 +--
 11 files changed, 299 insertions(+), 95 deletions(-)

-- 
2.50.0.727.gbf7dc18ff4-goog


