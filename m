Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9B0C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3E48E000C; Mon, 21 Jul 2025 16:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54B08E0001; Mon, 21 Jul 2025 16:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C678E000C; Mon, 21 Jul 2025 16:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF2B8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65E7C10FA9E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:49 +0000 (UTC)
X-FDA: 83689430538.04.EBE95D6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 95CF5140005
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xvMmxAp0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 33qR-aAYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=33qR-aAYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130207; a=rsa-sha256;
	cv=none;
	b=65LGxmq3tpecDfS9CInZgMKzF8uMLnNSbFePp3Op9Pixtl5lHPuR/DckkoK0OildHU5Dti
	0gYTuX/zZxdXizLmVyGzC51XD8kxzUrqpuwgkxp/s+n5sX+bh3LYCJ27Ssp3m9dgaDx9v1
	8dQvt7GHZr5L045oKOBiqTzsZrAhO2A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xvMmxAp0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 33qR-aAYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=33qR-aAYKCG0VfYTjfRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUinzOTBmFzGlPRyqzH40paksGVV4+5eLWcmsRYDtpk=;
	b=qHb74YbEmaxcB9xdOPAv+uOVfFTmGpnLDpSINPiVW55xcpAn2PIumPNfA9ZoazL00kiHPT
	eh0S72p6I1t7uO85wicd7rRwI/EmDWiGWRpKgeBSdJqhYWt6i8NYAIH+YRKc6JW6xQGaMu
	fz8tkW1YnfPeSLVTtTxZYIF6/rAAiQE=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74b4d2f67d5so4071755b3a.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130206; x=1753735006; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nUinzOTBmFzGlPRyqzH40paksGVV4+5eLWcmsRYDtpk=;
        b=xvMmxAp0k2g8cGQWEJZJvE71rbek+TDAK+53Oeoq2JbTnNtuvfxgzn3yUHVs38/ccL
         gZwxOrDtLQQJ6roEKd6jof7WX/wkcaasPJXuTirKwPMJmsY4D7CJ9IsbKS4oGeijATyB
         JbRvdwXcuKr/9VUJaWYv6CZ3QS9aFpDP5uDQbUoON0aAJDKUL9sHILQzHEOQ/Nt6M6NZ
         gJ+JQeQ+js9yvIBn6+vznRNolyIRpzcG/PHMKSdWlsQnqraC3WnXHdHyJ0OPXMWe824x
         puvRTK9Lh2IciMXEj7Z1w1PIVtcwyQJxPjvzRg1sTyyJ41GvstDBO2SabjmnbcpZK8Mt
         hRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130206; x=1753735006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nUinzOTBmFzGlPRyqzH40paksGVV4+5eLWcmsRYDtpk=;
        b=RbUpCQl5qf9nJaNJD2uCx2atsur6w+03y2sXtxc2SVGXvhxgTQ6QJquSg7I26RgdbI
         VuCgfcHL87FyULCNKcA0srxl484J9+wt11AdNGvaIfN23+9vmeWhE681zK5+1NK58Kmk
         9HN0AzYTWqVJLdCIlk+M6JEgfdSQwE2MEDteaP6eNUz1+BRLlzcsesSwWRg4wfOxrykk
         nppQqlfOmFGn+IQRJoRQ18I+NF73I6mZBRZPpar8TgClVPTWoH+v8kT9pCDveSYZlXUg
         AHNiV7X/v8E0hbDlvuD7l4E7voQqpy13wLNsOr5JLaD7uXrebMgq69xSr04Lyg96qLXV
         UnpA==
X-Forwarded-Encrypted: i=1; AJvYcCUYhHHTVbajFSkxqg2ZosTQC5dhYnv4bPxdqe9Fw7TIXHiNYRZ4T7d2sKah2lc/cuhB5oF+45NyZA==@kvack.org
X-Gm-Message-State: AOJu0YzkhVqyXK5PM6oKxmBpD+WkrTF5DuquFy4TuM0IcXEgjP/RBOO2
	b6Tev8ZN0m2jy1gUesRZyllJcnSg/GzDOVEFdoIgH3W/EDejSS1MLrUdSnC5aGrU/w3ZcPL3ugh
	/AMcQ2A==
X-Google-Smtp-Source: AGHT+IF55Tasmzf40vI7WdvTmtciM9z/zourqwpEu8s96++APVGs+R76gSIW5Yf92/sZUKZ1BwWIx+Puq2c=
X-Received: from pfoo15.prod.google.com ([2002:a05:6a00:1a0f:b0:746:683a:6104])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d1a:b0:230:f120:f7f3
 with SMTP id adf61e73a8af0-2391c92c40bmr23246374637.8.1753130206377; Mon, 21
 Jul 2025 13:36:46 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:32 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-14-kuniyu@google.com>
Subject: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95CF5140005
X-Stat-Signature: feuxs5k95fzf3xauypwgb7hpeusa7he4
X-HE-Tag: 1753130207-990731
X-HE-Meta: U2FsdGVkX19T77LSBWbGU2VlCYOG6nTbIotbr4gMpxBVt233WZE6rz7xk1a7WKVsfavnW/V8LTMyHXdvovaZErAkD5ewJOeGsNGyEavCs5yISH0wZ89iDm974G+sv+ajQpLHBf462+g0VSsVlcVRV+Ddc8SeK++fZZ94o1LLyv169uIGmvIIYYlzdv/8GqxAMEkx2OwqRexpeplWBkPVZr6rQwgOT+CmG9ChM1tCPIZHUFbKe4nSptNJLNlvD4n2mnyrwM5pGbU6YrbXL3z9IV8yuGaWVFKqAikf38Tifh9od7NAC3y+hr2oedJy4u5+px9k634MOqp+dq/isydsuxxz5HQA8OAVUw5DxmzyAQoa3+g0JsQXdgH+hcHDkdRk7eqSq6lL5JPCSjdrErBLtnaaLq1lqrJEeGq11d0TLzX0fM62Gc0QuBv4uVSE2geKIyKyp+WYb3uSadWXYr0Vg8uC8fdxt2wD9+1CgDBS6Czfh80dwF/+N0GIQrC3cYF406Ts4gI0q0Vv4g0MF+i/MIidlow0K16gE+9wNnZ7M1lnKDD1fiM4kwuri/knWWY5n8Dk2V60WHwNtbrXyKpvwfmJXHo4BNHPDsWYawcaAgGkBYcoLFmkgj0iyhDnjUAPtXG8VFv6m1UzlVlNzxDW5tT4Bti5uaj3kUY68FYEBr0xEi6FI5s7ifcXdgLxXPxRFSDBg3rr5F4amKF1oXG7Z4q+z9KptcqHt6NW1RiG5JzZWDOIcrq3RQERE7OVf6TEEN4sn9U1FtbX22SXRVlrdnSPewOD0EMVqOj8EZbP40zx1nW+cC3Tgk41PAsJfguz032SsqVpNlm8ILL/Tv30u0PSi2wzkoE+pbVrH+4aEn+5wLtXnAlzMVALPlUv5onKgKMAaMHC7OJM+ZnPa+7kkk1rqmo50vLMHG9M+iSZcOPiJwrQjMvCs5C4O5Y8KF7kl0ewnNJPzwXpKkJzcq9
 1LivBJL/
 wjRIL1eQutqtKbaHykxJtFjCT5SUXG/w9/FbxrD7auGPTFIf/E/HXx7HkGyvQiE0AFWNebwJelxOttL87XAfFGWz+q4lO+AbG/2cFE6J/uvLS1BYX8lwwBSKiW6T1M2VqBZpH21NxVC7f7vwvnJpM61sYtGzb6CaAfWD1oKC1dFTqsZ3LgH8Ps7Ckt/jaVj6Nc+wFQSLgW2lwCY8QYyoy5jXgVBR0lWNu1n9+VGegk5snAo5BCD8pIMxg+K6kuZ1hY6etGkFvxtDy11c4WkTs4DBGfAAVMAghouwQkaDznU6ARQg/T5kg8xs9n6hKleP17s0Ei89bcdFURGWm0kNKHW71mthl0XoxgtWWyI5br0/KcnzmFmFtl0khE8+8bKeXCZgdsif3rpxKEiKRCCgwNGrH/dPU2yn+Z/EAOy7nl/fWLGdWvuEd3l0/sBAbuWl+8SGXTRv7WdEWP521KtOJwAJSGJCHZWp/bzsojeKeC4doeOts21Z9T85YoLxSxwQo/Y5KFZSEYLxd8i2/3qun1jmeheiEse4CiAQyMr8D1vlmMis=
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
memcg as sock in memory.stat.

Even when memory usage is controlled by memcg, sockets using such protocols
are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).

This makes it difficult to accurately estimate and configure appropriate
global limits, especially in multi-tenant environments.

If all workloads were guaranteed to be controlled under memcg, the issue
could be worked around by setting tcp_mem[0~2] to UINT_MAX.

In reality, this assumption does not always hold, and a single workload
that opts out of memcg can consume memory up to the global limit,
becoming a noisy neighbour.

Let's decouple memcg from the global per-protocol memory accounting.

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

Without memory.socket_isolated:

  # echo 0 > /sys/fs/cgroup/test/memory.socket_isolated
  # prlimit -n=524288:524288 bash -c "python3 pressure.py" &
  # cat /sys/fs/cgroup/test/memory.stat | grep sock
  sock 24682496
  #  ss -tn | head -n 5
  State Recv-Q Send-Q Local Address:Port  Peer Address:Port
  ESTAB 2000   0          127.0.0.1:54997    127.0.0.1:37738
  ESTAB 2000   0          127.0.0.1:54997    127.0.0.1:60122
  ESTAB 2000   0          127.0.0.1:54997    127.0.0.1:33622
  ESTAB 2000   0          127.0.0.1:54997    127.0.0.1:35042
  # nstat | grep Pressure || echo no pressure
  TcpExtTCPMemoryPressures        1                  0.0

With memory.socket_isolated:

  # echo 1 > /sys/fs/cgroup/test/memory.socket_isolated
  # prlimit -n=524288:524288 bash -c "python3 pressure.py" &
  # cat /sys/fs/cgroup/test/memory.stat | grep sock
  sock 2766671872
  # ss -tn | head -n 5
  State Recv-Q Send-Q  Local Address:Port  Peer Address:Port
  ESTAB 112000 0           127.0.0.1:41729    127.0.0.1:35062
  ESTAB 110000 0           127.0.0.1:41729    127.0.0.1:36288
  ESTAB 112000 0           127.0.0.1:41729    127.0.0.1:37560
  ESTAB 112000 0           127.0.0.1:41729    127.0.0.1:37096
  # nstat | grep Pressure || echo no pressure
  no pressure

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 include/net/proto_memory.h      | 10 +++--
 include/net/tcp.h               | 10 +++--
 net/core/sock.c                 | 65 +++++++++++++++++++++++----------
 net/ipv4/inet_connection_sock.c | 18 +++++++--
 net/ipv4/tcp_output.c           | 10 ++++-
 5 files changed, 82 insertions(+), 31 deletions(-)

diff --git a/include/net/proto_memory.h b/include/net/proto_memory.h
index 8e91a8fa31b52..3c2e92f5a6866 100644
--- a/include/net/proto_memory.h
+++ b/include/net/proto_memory.h
@@ -31,9 +31,13 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
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
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9ffe971a1856b..a5ff82a59867b 100644
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
index ab6953d295dfa..e1ae6d03b8227 100644
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
@@ -3153,8 +3157,12 @@ bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 	if (likely(skb_page_frag_refill(32U, pfrag, sk->sk_allocation)))
 		return true;
 
-	sk_enter_memory_pressure(sk);
 	sk_stream_moderate_sndbuf(sk);
+
+	if (mem_cgroup_sk_enabled(sk) && mem_cgroup_sk_isolated(sk))
+		return false;
+
+	sk_enter_memory_pressure(sk);
 	return false;
 }
 EXPORT_SYMBOL(sk_page_frag_refill);
@@ -3267,18 +3275,30 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
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
@@ -3357,7 +3377,8 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
-	sk_memory_allocated_sub(sk, amt);
+	if (allocated)
+		sk_memory_allocated_sub(sk, amt);
 
 	if (charged)
 		mem_cgroup_sk_uncharge(sk, amt);
@@ -3396,11 +3417,15 @@ EXPORT_SYMBOL(__sk_mem_schedule);
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
index 0ef1eacd539d1..9d56085f7f54b 100644
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
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 09f0802f36afa..79e705fca8b67 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3562,12 +3562,18 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
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
-- 
2.50.0.727.gbf7dc18ff4-goog


