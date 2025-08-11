Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FE9CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4453E8E007F; Mon, 11 Aug 2025 13:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D638E0060; Mon, 11 Aug 2025 13:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333548E007F; Mon, 11 Aug 2025 13:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED708E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC8AE57E2B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:33 +0000 (UTC)
X-FDA: 83765168466.22.DF4683F
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01EAA18000E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rtg+weeW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 38iiaaAYKCPcjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=38iiaaAYKCPcjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZTb4ZYMYPpk1ACseddHrcz3FiaeJvW+qXE8HO8bxlXA=;
	b=2ubDz/KxvsVqfXTgaDLGo5V2OpfL3VKERnUISrljAkvvxozmpUVtTyzmdIWydxraE4EvIp
	iBTI0+tG7ocHOGUGIj4ty/hIe5hWXZZZTm7RnB9EYyIWAikgQstuv0/aH5wmTE7VKO6USM
	ffwJMe46DUuPCyo2nlmz0VXeMIcW7wg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933492; a=rsa-sha256;
	cv=none;
	b=BYES9WWkeHbwTA9mfFIEth6UbsRmWMih/TLWqOCP0qcW0ofxyNUOSS55OZOilicOTOHvLP
	5+3jmcbnkoz1fj5uHqAw8Q/TAmoNESSRbOZChVLS7emSCVEzZFS2Yzryngx7x5+Q9bITVR
	3wreu9rYEpH8iVpAUUD6ToUeL8/nJRA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Rtg+weeW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 38iiaaAYKCPcjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=38iiaaAYKCPcjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b38d8ee46a5so4448034a12.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933491; x=1755538291; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZTb4ZYMYPpk1ACseddHrcz3FiaeJvW+qXE8HO8bxlXA=;
        b=Rtg+weeWUp1o1vcAWcjnY4a3LVT7L8DAbgP/6Ol5r9ZiZCNkLGTimAJrWs0EM2TSBv
         JzNRqwB9fasCo95E3AeSQ7IIfcmlkdTB5xYSvZyx0OdB9I7J0b1DkXfOtFILRN3qWnCe
         GE2UHr9iCAhh2UY0qVMo8KWmmKM7qiVThNk5gG5skSC7/kQKAzMG8c6otHC3ERLpp+C2
         ZtdeTPxpU0zdy7ALU8HrSRvG7KTLqiApJwrm93PbVlHbUyAUQrnhHd8zhIEyTVvNAtcK
         kxjomlzOvkqlEIpQQjkS6C6HA/rDShs0wAYm/MbgImPoDLB8sK1R88VAa76n9zPeoAUZ
         RMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933491; x=1755538291;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZTb4ZYMYPpk1ACseddHrcz3FiaeJvW+qXE8HO8bxlXA=;
        b=Ibrn72/umSG2NdMHiG1oNf+DmHwmj/2J05TcT12tXJJLQgHUbz6nXz9R/NGIOlTVeC
         4H6ygQpGu/RWOb+H84FkIsGc03Q6TbJROjn24C37GABSD6RTv1mjFJcXoXd+t34qFlrt
         dI/2/0TLlSrv/Admp+KRBLK2tT2zVYKU6NhKQJlSJ2OYE2TOmQ9rZA0M5fJB6Fvjb27e
         Cj9L2eEJ7YCpf3hpzKfbW7LoPqtnk1C1xwvKP5I3V3ub9zZJuL3GJKVTCACMKw4TguWs
         TfsQcVNO1H5iDDqyR6yyE8IPmF0VuLZ1xYOYY9GjzIu7rw2UCU4v9lIQfuaqj5REE91w
         LqIw==
X-Forwarded-Encrypted: i=1; AJvYcCUXPhFj2SLbqf//SFaiz5+IfVPw6UC7A2Jeqx/f911vANnh8D/wjyqEGYkozWVOYSeaJ+agyzO5Ig==@kvack.org
X-Gm-Message-State: AOJu0Ywz4s0VrSHpwG7HiZskZMrrWo/mIy7k3w5nK91vvuZ2MQfbni3R
	+ECo0o2ATb5JF8Cu/eVuStySydzr7CkeXXXDM5SgmclZ6JuPeoAlQAiNsfYKI5qT3OQGVC74Pjg
	iiwvTxQ==
X-Google-Smtp-Source: AGHT+IGKr6oqVCjBFIQc4hDZq54MhrQz3SYGcbPyQOfRTd5efyFcfkryP7IWXH22Nn+DBiaaLRdr8LG3oKg=
X-Received: from pfll28.prod.google.com ([2002:a05:6a00:159c:b0:740:5196:b63a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:401f:b0:238:351a:f960
 with SMTP id adf61e73a8af0-2409a4ab650mr442290637.23.1754933490717; Mon, 11
 Aug 2025 10:31:30 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-1-kuniyu@google.com>
Subject: [PATCH v2 net-next 00/12] net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
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
X-Rspamd-Queue-Id: 01EAA18000E
X-Stat-Signature: p8wihgctp61m6mwjhkd9epyk7aogd3za
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754933491-870280
X-HE-Meta: U2FsdGVkX197FdLTbjpgoGQVophLaJO1YUsSkos/cI/6zHt8qrTU1pgoP5BN69ecJN9eJ1+awpe3SpD31KHnOU+Tby9up1yVsa09bHrlg2OUSVVPnezFQGWIi9uuouuwS1byRhqBnBwk7earoRCCQmlDm5AekaoWr6jCUiiSUDahjd/1sF1ujcSTjI/617CjNHJB2pLgMN8zl/PJGpsxweAWi5YYPvoOGzaPK6B/NMqU7tRiLtYPVgcjoelw3HMq1q+NdrAM8ZUcyXUIhlh+dzwEicAT/eGiGAkVPkoK8OQxUpECZxXhaOSuNwf3oKF1I/qSeKxIFqrMs7QV05p6CvsLmpAAtFbWj1hgjeTWm9EvHBAdvb56FwBKEt4WodiVC0gOc+uLpy44JcpT3K+4Eqwj92VcCO6WdIVoopDMxrXhvNxCReLZAas3kqzbZlEbpxKzr7Uacr78BwVycps4pOH65r/qmVk+TS3n0U69ovmoFFqoG5zKsRip1YEs7kVg1BHqTkex4F3XxSvDAh2chTLZNIwxl/pLFknMw7EdEhZZc315TFhRP/t0BvUssOTbaV5Jd+28tZUjfjv3EuHcrcT2iZQJsLM3jB/0nzSJXnZMHjDpnv05HuDWPcy1FRbq2tLtMvue4Aq/zsmzamsgd1clRQp+szXNmCWvauu8OZEbwa0DNziL1fYt3icCzOTRuDFfjVjbMya+dSvpd0w119Y/sYdGF/q0DbIlgiF9o/cdRcmRA+qDteJB/A9J3DX06NT5W7kS8UYg1yK3MklTgTM5sj8i8jEGmNs9fPFa/l9gtGQ5qn9FjfUQhDT0TtC2jrMbY2qgAHm1HG1oKWx9pIycXdjFGe/1lQT6OE/mNBB/6ztGU8xaq5Waa1zUhhymO9+U3iIGZz4Gyc3NljNV/n+mUrJb7jTNFIwbcZ2Vxj7YR6r6K/BoU8Dd5ReUxJgek3UMy40zgZxhZS+rGvC
 FZMSl23i
 3RZNfnBzPBKxpIRJameLFPS1t7Tuuue5w+SOEQsWy6vg0w7KVWRroCnq7r+d/V1g64incT/SuIZbXUdBm+ZhQq8y/xMXbDq0DX4PBRywHJxGXolKqg5B786WeIDjJ3gJgMup17dVgLWaPLrzsczjJOpeBbr66lCiEqSQFyspyX+Xp5dIScWU0vZw6X4UwYPSH4vahLH9UqccmyO5IIKllrRBZ6RkGlICgAn6V/xvTRtEgtdCqet1vsK6M1FA6xRkzTNain5YyGKFd5rbEu/6k2XoFqTYrV47vvtj/7SFOYCS5Eiz5fS/Cb/HjBilhtwg2mjfoMkSOFPzHAfhBvdwLz+SMJ3LYSIcWnA0hZQqYKhdVl0wnXoc8S3rLikkdLKBVIdiXui8MLHf6D1hQxinSfwMdnr7W+cRfqiARTO5xZhnKl/Yr+LyDzbpn0rfLSwXbN349y4D1VN23NysPtb/7o5hgDqvFKh9w7PPyewc7A5tHvh2R5nwJ1ZG8I5DUhS/uSX5a5D/zL9A6/BfWtP9LoVlasQNnN1RlKYMuFYcyAD7CobpQZO9hQ40AKo65ZDainxfQTSn2G5P5S7sHkdkgSRyAEfO+GWjUYwfYpwHHLmdZVkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some protocols (e.g., TCP, UDP) have their own memory accounting for
socket buffers and charge memory to global per-protocol counters such
as /proc/net/ipv4/tcp_mem.

When running under a non-root cgroup, this memory is also charged to
the memcg as sock in memory.stat.

Sockets of such protocols are still subject to the global limits,
thus affected by a noisy neighbour outside cgroup.

This makes it difficult to accurately estimate and configure appropriate
global limits.

If all workloads were guaranteed to be controlled under memcg, the issue
can be worked around by setting tcp_mem[0~2] to UINT_MAX.

However, this assumption does not always hold, and processes that belong
to the root cgroup or opt out of memcg can consume memory up to the global
limit, which is problematic.

This series decouples memcg from the global memory accounting if its
memory.max is not "max".  This simplifies the memcg configuration while
keeping the global limits within a reasonable range, which is only 10% of
the physical memory by default.

Overview of the series:

  patch 1 is a bug fix for MPTCP
  patch 2 ~ 9 move sk->sk_memcg accesses to a single place
  patch 10 moves sk_memcg under CONFIG_MEMCG
  patch 11 stores a flag in the lowest bit of sk->sk_memcg
  patch 12 decouples memcg from sk_prot->memory_allocated based on the flag


Changes:
  v2:
    * Remove per-memcg knob
    * Patch 11
      * Set flag on sk_memcg based on memory.max
    * Patch 12
      * Add sk_should_enter_memory_pressure() and cover
        tcp_enter_memory_pressure() calls
      * Update examples in changelog

  v1: https://lore.kernel.org/netdev/20250721203624.3807041-1-kuniyu@google.com/


Kuniyuki Iwashima (12):
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
  net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_memcg.
  net-memcg: Decouple controlled memcg from global protocol memory
    accounting.

 include/linux/memcontrol.h      | 45 +++++++++-------
 include/net/proto_memory.h      | 15 ++++--
 include/net/sock.h              | 67 +++++++++++++++++++++++
 include/net/tcp.h               | 10 ++--
 mm/memcontrol.c                 | 48 +++++++++++++----
 net/core/sock.c                 | 94 +++++++++++++++++++++------------
 net/ipv4/inet_connection_sock.c | 35 +++++++-----
 net/ipv4/tcp.c                  |  3 +-
 net/ipv4/tcp_output.c           | 13 +++--
 net/mptcp/protocol.c            |  4 +-
 net/mptcp/protocol.h            |  4 +-
 net/mptcp/subflow.c             | 11 ++--
 net/tls/tls_device.c            |  3 +-
 13 files changed, 253 insertions(+), 99 deletions(-)

-- 
2.51.0.rc0.155.g4a0f42376b-goog


