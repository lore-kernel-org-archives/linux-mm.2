Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5CBCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF56B8E008B; Mon, 11 Aug 2025 13:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA58A8E0060; Mon, 11 Aug 2025 13:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46308E008B; Mon, 11 Aug 2025 13:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDBF28E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E0A157F37
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:52 +0000 (UTC)
X-FDA: 83765169264.14.26E077B
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id 887A280004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GVQs2JlO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3BSmaaAYKCAww6zuA6s00sxq.o0yxuz69-yyw7mow.03s@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3BSmaaAYKCAww6zuA6s00sxq.o0yxuz69-yyw7mow.03s@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933510; a=rsa-sha256;
	cv=none;
	b=JfmiS5XQmqtK8UEILqpTfNE5XbGWiM8O+UO5xdjMizruFc/OYI14k+U9sfeUh0GeB/3ACY
	QFQhDBg4JfR8BYKnSuJ8tJxzR3pv+8OynlPp91Mj3Gh8FYH9YHgENP8V90IM4P6ETXa3I3
	G8wOBiuy6xvC/i3tU3xNwAstx+RmGFs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GVQs2JlO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3BSmaaAYKCAww6zuA6s00sxq.o0yxuz69-yyw7mow.03s@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3BSmaaAYKCAww6zuA6s00sxq.o0yxuz69-yyw7mow.03s@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7SLf/b1TNrP6kPGA7P5mGSIp2EjjMSQCEcOICNla1I=;
	b=qknKjhmleYPBN/UXDK2xLbQSjCERopzgJEHD/VK3bb++7Pzyno656X/6TWStacvsaWVDfZ
	45y7JHNWCuJXtzqqg//OM8eb8814a3hGhQyVdJpjXyxRUW2q4V54/8Hpws7xKWu1Hjl6Xc
	c1U3Sw3WNvGlXpo0RK3Klxk8hHD5M/w=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b421b03d498so3543735a12.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933509; x=1755538309; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k7SLf/b1TNrP6kPGA7P5mGSIp2EjjMSQCEcOICNla1I=;
        b=GVQs2JlOhWISrNwDUPdirFbIdSyH3A51+H0Z3ZycYzEP9Kpvr78QhxXG85DXw4j1tl
         QhawO8c0n3ouYc3yjOZifXOSefk4Jv0gn1nPOy0/xXrpaXYJWS7dec08BdWPrarlnWpz
         jQwXABY0I7cOIpeJSzYXoGGNL2XtjVOQgd9p5zYydaLFw9bmTC0RMmTEB36SpDG+LQ8G
         ah3LIMgmriGhPEflH9gHiGW5wH1d6fjJCeYjb8opYwjAlSeFlSrWv5OUbmivR36KJRYy
         47a+uU2+3vUFCqMeFbVLFqrJ4lnwQ28dqZfgMWHR02fUno0ajZGWBJpB/MxxYZY0MuDo
         tU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933509; x=1755538309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7SLf/b1TNrP6kPGA7P5mGSIp2EjjMSQCEcOICNla1I=;
        b=KeXWTBhDZt6T8ns6392UpYnQKECniQ2atDSOIHGvGkcHGCyYNQcxZgtCaKVKB3VV+o
         L6m5nnio85Br1vpb7wDpnuDhuoUSbtK0QQn+P7SJg3lcks9+FAI1q7V9K3KaHHhC6neA
         8YSxShMbUm45IE+KhVXfnvDD/xC6pBmhWXOv9Cg7zBELujfGTxLYM/hQJBQ9TDWDN4p0
         wjp8gF8m0CkYQwQx6nIlvxQxyPARCbZNZXDNguCKkebDV5n92hWmz8uCUt3YeqnSzfnQ
         TqJmsIU4KI5J843anmd9OD4EQzBruuJcf4vOGA8pWvTbsJIDYAEweKABZw4H4CzhxiO0
         akZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFjqRFDBJlS2EOmmMlz+EwN/FHKwmG9vc2gLOSebZPo0TNzHl/CnD7lWomddB7UFvZIrpq0YiH1w==@kvack.org
X-Gm-Message-State: AOJu0YzXeGmOTyLsDei6mGYJp0kT2jS5vNVRvyKzwl89y7pXZRhrhrKM
	mXyGRoS+zsT9IpDUjFG/c9hNi2cfBIcw/gAwswufVMVE48Euc1OjlYeJ5u2uQcoEbc4CBdEbTw7
	d4FnCmw==
X-Google-Smtp-Source: AGHT+IEkxOxyR4soNgLW4++VFX6C582L+cnGEVtxtVwkEQ3Ypcq86ke6b4X42kPLmM6zLuE6ldq4TTZy3Ic=
X-Received: from pgbee13.prod.google.com ([2002:a05:6a02:458d:b0:b42:c17:47ac])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:892f:b0:240:9af2:71cb
 with SMTP id adf61e73a8af0-2409af27360mr180384637.20.1754933509378; Mon, 11
 Aug 2025 10:31:49 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:40 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-13-kuniyu@google.com>
Subject: [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg from
 global protocol memory accounting.
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 887A280004
X-Stat-Signature: 53kd5mtiduj1jmrtym7zsp5jjeyw6xx9
X-Rspam-User: 
X-HE-Tag: 1754933510-190136
X-HE-Meta: U2FsdGVkX18F86ARadl69upMu95j0TEE69xlwfFRY565nwEhFIMri3UP2zmzcSGM+07aK8FGpjkWsKIa6PWLC6ztYAyEq92lLcOAcS/e5+0shtbvc+wZQyF7XF6wBfPy3g8/U8MS5zbtxPfmI3cBaYZH7tiK6IIqQtrhNLhMicKCNH41iVzGxuWYBcwD0BTJwGhpaGJhPzBBKuLlyHHzypjZqqRyxIzPCiN3MeQnOPxFrcm88dzXxqzaOTg1JHsvo1XqG0MC7pbUuBwpBThqv1whJLERScqqmOkBS4uzPtyIQPG+mPGJ5BMH75z9Du5P/zDe1tvDR1lNAneJ6EKDoESD/snBCj2T7pZUXgEO197qRUa+6oozdz5fNX1ztTtpK0Fbl56gbAASO72DVNSG/F2AzLS2xzXiPnEUbrHLl+DGoEwGqhLRlRSbPaGIG1EBPJ8FqVJ3J+EUIaAclYMCpEFzSXsjlPCxRr7XADGaYrKtTc7yi0zA4aQCI8y0FX6yzD8pVg3O51p22E1DWMDpEyx4gjq9QJi6EV/iGrC/97aFPx5LbQSePfI/6vPilPBNKJzbGi//iIYBJA1Mum9CIsoAolzlsDca5rhzOEdrHFo3NXUNMhfMEo41hWhmTjPZb08ZRmqV4rh6PCuvyRAvltIX0KBaGeMO/8FHoLYUFosxjZbcY/I99xFsz2Ej5H/9oCr5e20CD7xYC2ReaFIoDH9xGiJyG7dzBD/6sAIubUcNM5zIBtZquY0kV0xsiTzzyQywf/Q9bcw58A/jTcALA6ONKF089c/CEBwUiRraXmbY9+Lka+ak+/Dafm4Zg776aM7naG7gSLibPC5CW4AyYIfnHOZfG/JDkxfBp9MMkFPhvGf4N5OrHK/R/t7mR0PpGdkkBTLp0foc2ivdPgpDHWJBWgIDZ8OzkaJSWlbtlYSyKxHaPYtgN9glyIRAAyJ234xtQMQlKNGNiBSMt/G
 EctCK4O2
 vGxavcUoYKtVx9h9+sunxrjS7P6+UATnvLH91MROYSmQXtTh6dRkK5VCLYXSRFQAaO1NvdsOprazKbuW3AyJJptXULPQ6Po16AvmX9/c1b69WJ8psvBj9Crn4LbDd+q7UCcdyYuhpvxM1vR6MSwrMWcbhHFylXNku9rme+CcACWuy22w7W/wdwki+iNQxaTZUU39+mOW/hlqGUxMyC6eLHyiWFirOLfkWQfe0EKLpiYU7qpnuLtwEn+ID54zjgViTyF7+EJyilat5M6pm4eqcyU4sIUhqUPZtskK8oXv2Thn3ikClUn9ghkYbU7TfzSu4Bj89TR1hpV4P3BZmw1bNv59IT0NIGrcSZm/6aMIVcXYM4kkR2N0LHUPlo/vQoBha2T+b3PzvUdpuvaf9hy7MiHFmjDnRORFJFbFx4OHN/WbeReEQBPHmNqmyRtJnC31GAq6LqPl4Zn1KY16UY3HR/VyXMUynCwB+GDiqR1ZnD2ni+czxBDL0CD14DWVrnv3ZM6PDZa9nbOviDnbLFZ6JGjgG5KNJfI6pFE1UU9yTAOMpdkc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some protocols (e.g., TCP, UDP) implement memory accounting for socket
buffers and charge memory to per-protocol global counters pointed to by
sk->sk_proto->memory_allocated.

When running under a non-root cgroup, this memory is also charged to the
memcg as "sock" in memory.stat.

Even when a memcg controls memory usage, sockets of such protocols are
still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).

This makes it difficult to accurately estimate and configure appropriate
global limits, especially in multi-tenant environments.

If all workloads were guaranteed to be controlled under memcg, the issue
could be worked around by setting tcp_mem[0~2] to UINT_MAX.

In reality, this assumption does not always hold, and processes that
belong to the root cgroup or opt out of memcg can consume memory up to
the global limit, becoming a noisy neighbour.

Let's decouple memcg from the global per-protocol memory accounting if
it has a finite memory.max (!= "max").

We still keep charging memory to memcg and protocol duplicately if
memcg has "max" in memory.max because TCP allows only 10% of physical
memory by default.

This simplifies memcg configuration while keeping the global limits
within a reasonable range.

If mem_cgroup_sk_isolated(sk) returns true, the per-protocol memory
accounting is skipped.

In inet_csk_accept(), we need to reclaim counts that are already charged
for child sockets because we do not allocate sk->sk_memcg until accept().

Note that trace_sock_exceed_buf_limit() will always show 0 as accounted
for the isolated sockets, but this can be obtained via memory.stat.

Tested with a script that creates local socket pairs and send()s a
bunch of data without recv()ing.

Setup:

  # mkdir /sys/fs/cgroup/test
  # echo $$ >> /sys/fs/cgroup/test/cgroup.procs
  # sysctl -q net.ipv4.tcp_mem="1000 1000 1000"

Without setting memory.max:

  # prlimit -n=524288:524288 bash -c "python3 pressure.py" &
  # cat /sys/fs/cgroup/test/memory.stat | grep sock
  sock 22642688
  # ss -tn | head -n 5
  State Recv-Q Send-Q Local Address:Port  Peer Address:Port
  ESTAB 2000   0          127.0.0.1:34479    127.0.0.1:53188
  ESTAB 2000   0          127.0.0.1:34479    127.0.0.1:49972
  ESTAB 2000   0          127.0.0.1:34479    127.0.0.1:53868
  ESTAB 2000   0          127.0.0.1:34479    127.0.0.1:53554
  # nstat | grep Pressure || echo no pressure
  TcpExtTCPMemoryPressures        1                  0.0

With memory.max:

  # echo $((64 * 1024 ** 3)) > /sys/fs/cgroup/test/memory.max
  # prlimit -n=524288:524288 bash -c "python3 pressure.py" &
  # cat /sys/fs/cgroup/test/memory.stat | grep sock
  sock 2757468160
  # ss -tn | head -n 5
  State Recv-Q Send-Q  Local Address:Port  Peer Address:Port
  ESTAB 111000 0           127.0.0.1:36019    127.0.0.1:49026
  ESTAB 110000 0           127.0.0.1:36019    127.0.0.1:45630
  ESTAB 110000 0           127.0.0.1:36019    127.0.0.1:44870
  ESTAB 111000 0           127.0.0.1:36019    127.0.0.1:45274
  # nstat | grep Pressure || echo no pressure
  no pressure

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v2:
  * Add sk_should_enter_memory_pressure() for
    tcp_enter_memory_pressure() calls not in core
  * Update example in changelog
---
 include/net/proto_memory.h      | 15 ++++++--
 include/net/tcp.h               | 10 ++++--
 net/core/sock.c                 | 64 ++++++++++++++++++++++-----------
 net/ipv4/inet_connection_sock.c | 18 ++++++++--
 net/ipv4/tcp.c                  |  3 +-
 net/ipv4/tcp_output.c           | 10 ++++--
 net/mptcp/protocol.c            |  4 ++-
 net/tls/tls_device.c            |  3 +-
 8 files changed, 93 insertions(+), 34 deletions(-)

diff --git a/include/net/proto_memory.h b/include/net/proto_memory.h
index 8e91a8fa31b5..8e8432b13515 100644
--- a/include/net/proto_memory.h
+++ b/include/net/proto_memory.h
@@ -31,13 +31,22 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sk_enabled(sk) &&
-	    mem_cgroup_sk_under_memory_pressure(sk))
-		return true;
+	if (mem_cgroup_sk_enabled(sk)) {
+		if (mem_cgroup_sk_under_memory_pressure(sk))
+			return true;
+
+		if (mem_cgroup_sk_isolated(sk))
+			return false;
+	}
 
 	return !!READ_ONCE(*sk->sk_prot->memory_pressure);
 }
 
+static inline bool sk_should_enter_memory_pressure(struct sock *sk)
+{
+	return !mem_cgroup_sk_enabled(sk) || !mem_cgroup_sk_isolated(sk);
+}
+
 static inline long
 proto_memory_allocated(const struct proto *prot)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 2936b8175950..0191a4585bba 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -275,9 +275,13 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sk_enabled(sk) &&
-	    mem_cgroup_sk_under_memory_pressure(sk))
-		return true;
+	if (mem_cgroup_sk_enabled(sk)) {
+		if (mem_cgroup_sk_under_memory_pressure(sk))
+			return true;
+
+		if (mem_cgroup_sk_isolated(sk))
+			return false;
+	}
 
 	return READ_ONCE(tcp_memory_pressure);
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index ab6953d295df..755540215570 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1046,17 +1046,21 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	if (!charged)
 		return -ENOMEM;
 
-	/* pre-charge to forward_alloc */
-	sk_memory_allocated_add(sk, pages);
-	allocated = sk_memory_allocated(sk);
-	/* If the system goes into memory pressure with this
-	 * precharge, give up and return error.
-	 */
-	if (allocated > sk_prot_mem_limits(sk, 1)) {
-		sk_memory_allocated_sub(sk, pages);
-		mem_cgroup_sk_uncharge(sk, pages);
-		return -ENOMEM;
+	if (!mem_cgroup_sk_isolated(sk)) {
+		/* pre-charge to forward_alloc */
+		sk_memory_allocated_add(sk, pages);
+		allocated = sk_memory_allocated(sk);
+
+		/* If the system goes into memory pressure with this
+		 * precharge, give up and return error.
+		 */
+		if (allocated > sk_prot_mem_limits(sk, 1)) {
+			sk_memory_allocated_sub(sk, pages);
+			mem_cgroup_sk_uncharge(sk, pages);
+			return -ENOMEM;
+		}
 	}
+
 	sk_forward_alloc_add(sk, pages << PAGE_SHIFT);
 
 	WRITE_ONCE(sk->sk_reserved_mem,
@@ -3153,8 +3157,11 @@ bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 	if (likely(skb_page_frag_refill(32U, pfrag, sk->sk_allocation)))
 		return true;
 
-	sk_enter_memory_pressure(sk);
+	if (sk_should_enter_memory_pressure(sk))
+		sk_enter_memory_pressure(sk);
+
 	sk_stream_moderate_sndbuf(sk);
+
 	return false;
 }
 EXPORT_SYMBOL(sk_page_frag_refill);
@@ -3267,18 +3274,30 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	bool memcg_enabled = false, charged = false;
 	struct proto *prot = sk->sk_prot;
-	long allocated;
-
-	sk_memory_allocated_add(sk, amt);
-	allocated = sk_memory_allocated(sk);
+	long allocated = 0;
 
 	if (mem_cgroup_sk_enabled(sk)) {
+		bool isolated = mem_cgroup_sk_isolated(sk);
+
 		memcg_enabled = true;
 		charged = mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge());
-		if (!charged)
+
+		if (isolated && charged)
+			return 1;
+
+		if (!charged) {
+			if (!isolated) {
+				sk_memory_allocated_add(sk, amt);
+				allocated = sk_memory_allocated(sk);
+			}
+
 			goto suppress_allocation;
+		}
 	}
 
+	sk_memory_allocated_add(sk, amt);
+	allocated = sk_memory_allocated(sk);
+
 	/* Under limit. */
 	if (allocated <= sk_prot_mem_limits(sk, 0)) {
 		sk_leave_memory_pressure(sk);
@@ -3357,7 +3376,8 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
-	sk_memory_allocated_sub(sk, amt);
+	if (allocated)
+		sk_memory_allocated_sub(sk, amt);
 
 	if (charged)
 		mem_cgroup_sk_uncharge(sk, amt);
@@ -3396,11 +3416,15 @@ EXPORT_SYMBOL(__sk_mem_schedule);
  */
 void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 {
-	sk_memory_allocated_sub(sk, amount);
-
-	if (mem_cgroup_sk_enabled(sk))
+	if (mem_cgroup_sk_enabled(sk)) {
 		mem_cgroup_sk_uncharge(sk, amount);
 
+		if (mem_cgroup_sk_isolated(sk))
+			return;
+	}
+
+	sk_memory_allocated_sub(sk, amount);
+
 	if (sk_under_global_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
 		sk_leave_memory_pressure(sk);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0ef1eacd539d..9d56085f7f54 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -22,6 +22,7 @@
 #include <net/tcp.h>
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
+#include <net/proto_memory.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
 /* match_sk*_wildcard == true:  IPV6_ADDR_ANY equals to any IPv6 addresses
@@ -710,7 +711,6 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 
 	if (mem_cgroup_sockets_enabled) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOFAIL;
-		int amt = 0;
 
 		/* atomically get the memory usage, set and charge the
 		 * newsk->sk_memcg.
@@ -719,15 +719,27 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 
 		mem_cgroup_sk_alloc(newsk);
 		if (mem_cgroup_from_sk(newsk)) {
+			int amt;
+
 			/* The socket has not been accepted yet, no need
 			 * to look at newsk->sk_wmem_queued.
 			 */
 			amt = sk_mem_pages(newsk->sk_forward_alloc +
 					   atomic_read(&newsk->sk_rmem_alloc));
+			if (amt) {
+				/* This amt is already charged globally to
+				 * sk_prot->memory_allocated due to lack of
+				 * sk_memcg until accept(), thus we need to
+				 * reclaim it here if newsk is isolated.
+				 */
+				if (mem_cgroup_sk_isolated(newsk))
+					sk_memory_allocated_sub(newsk, amt);
+
+				mem_cgroup_sk_charge(newsk, amt, gfp);
+			}
+
 		}
 
-		if (amt)
-			mem_cgroup_sk_charge(newsk, amt, gfp);
 		kmem_cache_charge(newsk, gfp);
 
 		release_sock(newsk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 71a956fbfc55..dcbd49e2f8af 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -908,7 +908,8 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, gfp_t gfp,
 		}
 		__kfree_skb(skb);
 	} else {
-		sk->sk_prot->enter_memory_pressure(sk);
+		if (sk_should_enter_memory_pressure(sk))
+			tcp_enter_memory_pressure(sk);
 		sk_stream_moderate_sndbuf(sk);
 	}
 	return NULL;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index dfbac0876d96..f7aa86661219 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3574,12 +3574,18 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	delta = size - sk->sk_forward_alloc;
 	if (delta <= 0)
 		return;
+
 	amt = sk_mem_pages(delta);
 	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
-	sk_memory_allocated_add(sk, amt);
 
-	if (mem_cgroup_sk_enabled(sk))
+	if (mem_cgroup_sk_enabled(sk)) {
 		mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge() | __GFP_NOFAIL);
+
+		if (mem_cgroup_sk_isolated(sk))
+			return;
+	}
+
+	sk_memory_allocated_add(sk, amt);
 }
 
 /* Send a FIN. The caller locks the socket for us.
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9a287b75c1b3..1a4089b05a16 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -16,6 +16,7 @@
 #include <net/inet_common.h>
 #include <net/inet_hashtables.h>
 #include <net/protocol.h>
+#include <net/proto_memory.h>
 #include <net/tcp_states.h>
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 #include <net/transp_v6.h>
@@ -1016,8 +1017,9 @@ static void mptcp_enter_memory_pressure(struct sock *sk)
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		if (first)
+		if (first && sk_should_enter_memory_pressure(sk))
 			tcp_enter_memory_pressure(ssk);
+
 		sk_stream_moderate_sndbuf(ssk);
 
 		first = false;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index f672a62a9a52..92a4c16b904a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -371,7 +371,8 @@ static int tls_do_allocation(struct sock *sk,
 	if (!offload_ctx->open_record) {
 		if (unlikely(!skb_page_frag_refill(prepend_size, pfrag,
 						   sk->sk_allocation))) {
-			READ_ONCE(sk->sk_prot)->enter_memory_pressure(sk);
+			if (sk_should_enter_memory_pressure(sk))
+				READ_ONCE(sk->sk_prot)->enter_memory_pressure(sk);
 			sk_stream_moderate_sndbuf(sk);
 			return -ENOMEM;
 		}
-- 
2.51.0.rc0.155.g4a0f42376b-goog


