Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E80CA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F09590001E; Tue, 12 Aug 2025 13:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8773D8E0151; Tue, 12 Aug 2025 13:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F1690001E; Tue, 12 Aug 2025 13:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 637668E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FD421351E8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:17 +0000 (UTC)
X-FDA: 83768867154.17.9B53716
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 52EA2100016
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gY0LcOi1;
	spf=pass (imf05.hostedemail.com: domain of 38oCbaAYKCK0XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=38oCbaAYKCK0XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12VsIRpu33AswUdPPRoU3ogIBZKRgH8+iMLaTz6mZnM=;
	b=pp8JdKcef794Cu8Ea1eYxShXndT3FtD1fFUM2ntSpBxYRAKiC9j9dsTH5OFD0aTLL74Uhz
	cG+kx44eQpN3bc66i4ol4K8Nqfq5h2BSx+fKu/WzznOR8Bd6PdNfwrs/VqYcOIVnF058Cj
	T5fOS0L3wXibjQyhnipqV9hF/FwgStQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021555; a=rsa-sha256;
	cv=none;
	b=WfrX6B/cS8BZDGMrTdw+20b8ZEYyV9QcefkmuL7v/2uE2R6DxgUpbhMc79Stk53C6+FGhn
	f6b/3dPi3wmGI45lQxN0VSR/3X2TSxXgmpKDi96F5ZBfpX83NC8nA/TLRbTENuBvuONU6N
	Aq0zbMIwl7ulwpAgTg74XXlKsgmLePw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gY0LcOi1;
	spf=pass (imf05.hostedemail.com: domain of 38oCbaAYKCK0XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=38oCbaAYKCK0XhaVlhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32147620790so6112183a91.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021554; x=1755626354; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=12VsIRpu33AswUdPPRoU3ogIBZKRgH8+iMLaTz6mZnM=;
        b=gY0LcOi1lSrhA7Ny1iUhekvI3mZbX41rd9SlNK5uuaGxZ86OpsENALLwZW6Zml8p5n
         5I8xolCJlQDgf2B/za/MoCbAGD996/+8U3HUNiwMioIZK5OD9gKcPlOJeNpMMvuEHZEq
         MQv6x3PosYTTkygtNwu7mCObC5mAthosk7cKTZCmkBDRnH5xga/8bKXUrs3lM5rfjVmB
         30AG0icntqju36yo/QBAaX8H8e56uyEfO8guQK27NgcF5eTExpXhOwkxeztWhBAO/THC
         pWtG+TnBHk80hFa64gzbujI0KRRq9U4rKAvV1BetlNC8HPgIRRGzdJOXY+vyVEOtTrQJ
         4VrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021554; x=1755626354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=12VsIRpu33AswUdPPRoU3ogIBZKRgH8+iMLaTz6mZnM=;
        b=Pezb7bBc9ncvGhsb4LuuzHhhwTrZ11fipioVVrKnxzxv5wesL+b9pC8H/nQlrwyFL1
         08g+qi4TwaGRuWqhHO/aGXAbu7R4SqOdA6i7lk/6bVoUWqpo2rIt0jSukid95an6iy6z
         pRVXxSEmdtV2sVY0sc1zBCb3VJrcw+Xy2YbrsNcoayjgNQCKH1wSBnQa67gan/m1khQH
         XBrjC5i/AA5LE//fIZG9xHBVVIL2WmHwcjyHAGziu00UOixp9yDkgsaa9jKJ0NhkNl3h
         rr+jogWpQ/rw3P7PjF2xaNVX/Czv0fNvvMSgrtrxgVqm448MjDJ9MhQazu2TO6GQt2yp
         HjWg==
X-Forwarded-Encrypted: i=1; AJvYcCXevCgpOgN+y2dHYWPBvBjGJF6Nqx9+7rc4kKWyT1LQt3GAiDDQVBbX+ZWzogSiRuatCV8lbx/DTA==@kvack.org
X-Gm-Message-State: AOJu0Yy5flp0WU36o6t+7ot1FRWD81DnprqhcxZ9J92/j3W35DQXhdti
	CuigwgspF98L8lU+RHFN308v8LwQCRGKxQq47U7dPHlNIWfGfePJafD82HaBcTtfdHppECPCd0r
	fTi7TSw==
X-Google-Smtp-Source: AGHT+IEyIJ3QxWoWnwCUmlvpvFc2sz3YPkZ2Y+XguPdyYnKCZK2UJq098iKz0gqOrCQQVUwpkBAfznuiPeg=
X-Received: from pjbsx8.prod.google.com ([2002:a17:90b:2cc8:b0:312:187d:382d])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a10:b0:321:38e0:d591
 with SMTP id 98e67ed59e1d1-321cf976681mr917108a91.17.1755021554281; Tue, 12
 Aug 2025 10:59:14 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:30 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-13-kuniyu@google.com>
Subject: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg from
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 52EA2100016
X-Stat-Signature: hnz84eubkh9zajsbqiiuz8nfjajjykc8
X-HE-Tag: 1755021555-443867
X-HE-Meta: U2FsdGVkX1+FE36h39Q/Q0DdfhAFcugdNT6rAcQdWy2VujrXpcWnujOMFUBidRYtsaMXiWXrjegG/5SxtOsTRP67nx/d4nIXYons6WZVVUW0bnOztN2cBjyqq/w3DVp+mDpy20glxrRaMpcjOMh9oH0ZyGRFRBs7vAomYHnmlYHtuwTjkT/9eCkKE65ToALcReVNPAJbjWb7sCgjTB/ZHUJ8X/2YmkjcO1LhDNaa1JMBoU5Sd+TJsVKQW3KRGd36oGQwxH9xZmUyFCM53yZ3nClIQ7RCzNuZdw2kZ1ne/V0mjptkyqMoEKej+DWuftc9gQy78oyqUkJL/CSagjNbLguoF/msXKa2wGCm9rwPahgSXeqpxQseYyWhJ9MtduD1lprRWrjkeJLwQah3wgmYo2Du9AS0HARKf9pD5R7Wi9zK1MUtcQNy/9p0Tw9qdGR/vGPg1eL4fqJMJMIft9CJ3G1WDdE48G7G9TJx3UvH49d5bICdYrH89mU0lK2j4rWLjReyibGBytoxdOzu2JZGZVufvk47/vdnC90lZNDAu02vB3jp3goVIu39eTWAs3d8Y5NsyItSTYhlY8PVbYPDfiL/sKgFuPaWVXUTY0aXszQ+KC34jY+bwTpPgURvGFANqz9LaZ+eOfsAyCCix9GPnPPUyGh+45Qncy2iGiR2v9ClWK7/o5igj0lO+Y5ukYVOjye6tsg12AAATuzEzpyvtc953OyVUQLPDR6VYGy8A6UkzR62VbmKG7MAVL/G7m9iGlQy1bfrs8cBLmaf+onRWrbcdj8cemY9Td4TOD40FqetgsNw2akAKKM1sqmyy5pOh9Ivrlg37jmlOBN1H8QvPZtSOiqG9Y2+8jH0eq+KAjjH3RVB+WebFXte8Sk0rOuiuiVBFfcnM2kozuepOqCqDDURtXfvjhH6w+E+/ceAkSbw5uydXf+VqoCwcjW2hTAr3Z2TiIvXv66i11+JeLB
 J3LPstZx
 s1CQndqDujWxLzDa+EZXrQTOBBVIhfQSG8j64cyA6BfAb8Gb2NsHA8WSHgsmgIx7vg/gZqyH1NpraBOR0byOD5hbahtTimW5CRhNEMeMOZWgEpy3x3NOe1A6mJgBF2cBS3m0dWMMTvNs55n7cfASHzQWPGsWkde2KPUv16VxOcT/+wuC8jTm935JUH1F81cUET5L/QzqrIb/YSxYaBtwkw6UTIEaC1N/5HTvAtV1xUAlIETmNX5/ZOAADTJlGRdKCNCWPpPF3uYOez/hsHIru32rsbm7v89+4k+z0zzl/4pDZDPCuczEcjdeaMf7vnkKNk0mzhLvtpF2fOZ29vexFyIqP1cDu/1Eu+Y1b57Jl+JeK7oAAa53YtCKfckhpjZLQy1PlQnu7vmCBHmIGMusCpv9FUJf5IT9wxPSvBpaBI5NA3G/D2bb0l+e/w4X4bFekxX7rAoSAv4kcyBbMx4co6CHTtDtN6QoxbKNQ933PmVMrzTcUvh2zmNcOM5kjROcR7JSGLIENwjGPNqv8oA3M14wqO7PNRaHdftH0m6713wRrDxo=
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
v3:
  * Fix build failure for kTLS

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
 net/tls/tls_device.c            |  4 ++-
 8 files changed, 94 insertions(+), 34 deletions(-)

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
index f672a62a9a52..6696ef837116 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -35,6 +35,7 @@
 #include <linux/netdevice.h>
 #include <net/dst.h>
 #include <net/inet_connection_sock.h>
+#include <net/proto_memory.h>
 #include <net/tcp.h>
 #include <net/tls.h>
 #include <linux/skbuff_ref.h>
@@ -371,7 +372,8 @@ static int tls_do_allocation(struct sock *sk,
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
2.51.0.rc0.205.g4a044479a3-goog


