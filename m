Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5716E606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZfB2MLNo
Received: by kanga.kvack.org (Postfix)
	id 52D3F6B05B6; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B68B6B05B7; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E6C6B05B8; Wed, 28 Oct 2026 14:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFF776B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 576D34023C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:44 +0000 (UTC)
X-FDA: 85372926408.25.16E82F7
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9542F4000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:50:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZfB2MLNo;
	spf=pass (imf04.hostedemail.com: domain of 3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793213442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY3jLJiX/CdiZVg7kqP5WkxY/fjYB981acR8Lb4q8Ic=;
	b=EAM+LUk5pLI/ncw28MPPDTM+I1g/5yMQOi2GzaZpIKy/6t4LpxYTfJcE4lN3qRVsqLSCbJ
	jynSeqHYjA+MYQ5VWOHwAQKZlOiAJSLrnB5xqWqt5SwQsgVvN5G+1Rah4U0SMZ4X74UPLA
	keG2TOkI9NjJgWby1hxB2Cv+SAfh0Yo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZfB2MLNo;
	spf=pass (imf04.hostedemail.com: domain of 3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3AUTiagYKCHAYibWmiUccUZS.QcaZWbil-aaYjOQY.cfU@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793213442;
	b=tgeMwVc5jND+IpeqbwX4Nm0s9Tz3HkgoWzkK2b3C9SJE+2t6EVC1YzzNW+3taobuuLXoFw
	efo4vvW9H2DXgMWtQ/AtDYM0UqX+YD3wFpQxZswL3lGj6CYrcFKIoxu5oqSAxUqJt6L4FQ
	WUcjKHYdw9p8VP6Zc8OUtj8rpT6iUeo=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a0589ff620so1015125b3a.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213441; x=1793818241; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bY3jLJiX/CdiZVg7kqP5WkxY/fjYB981acR8Lb4q8Ic=;
        b=ZfB2MLNopEwrXogB8Qp/AO2KEtBTsu/h+NQ93gUz/IXym1njt+/eBH2Qa3MTVKdi1O
         9pLb2qfvV/kFOMSeWJMo3EaNXD65x4YZZHzLQeFbiLEdK8mEkpgOA8g0m34/l/2tJM/m
         zoDp22tL3e3lhdYH7vACO6cbYW9fX4dkj3CtZOIMG9OEvUfIYoqYpLfDYrEZ68TZJ5OU
         old1Qb4lNfK2lHML1wJ18xqJHA/PRn8RXpopjFxeaYIvuwGt/u37aUZfcVnC5KnucbZd
         Zr2aI0ozJwBZg1k+l8n3pLlvDBLJ3QusJLQgW2Ak9YsOCdjW2bzAzum7dWXxZZTOtngH
         5WBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213441; x=1793818241;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bY3jLJiX/CdiZVg7kqP5WkxY/fjYB981acR8Lb4q8Ic=;
        b=daECBNO3QBWKAstoMhxiQox78ewETASbE3JEaXnxu2tYGmOhqDEYC55wV4mGrQpiw7
         PP7+AwKmsThZJCJPP0dBArBRsQTzxUMWp5tu/Emzht7TRXjOelpM5VbYMGYRqSgDkJuk
         /DQzytOnYrdar6+HT1XbCS+rOvRheYHFeMlmCt9pyss1IKXQ3/Bygkjpfijm1LvLY6jO
         EKtGGkdJM2dBYxGQ+vBpgoFluyzMGb1ZggKdSOPcoY4rAY44sQnf0HAQ8WqDjsE0UnqT
         Rrr65x+xfudr5W5ocfU5Krr88H4alvbdkc8FXe34uhkDjIjAM0Ja8Gne5okQH1f+opg3
         750g==
X-Forwarded-Encrypted: i=1; AKwUvBzPue2iPKUYWyC/Q1NUYEtDhpo7ae3VhQegb4hWBJzQRL0dnEazPkAsgWlsHR1bJJlq9T7wPJIjcQ==@kvack.org
X-Gm-Message-State: AFq9FYJCPtkWLAXR28vwwlaw6TDPqalsnCBstJsMQEjSEb8SnIU09ZBF
	4RWyvHiMtk+xvYjRY3mt0mABIKNQkrvQXtQYz6NJIB6pOMZoyBwk+twB5553kd+YHVX9bpZwseJ
	hb1frZg==
X-Received: from pfm28.prod.google.com ([2002:a05:6a00:73c:b0:8a0:7440:ee03])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:f86:b0:880:ea3d:d70a
 with SMTP id d2e1a72fcca58-8a6e78cfed1mr2357885b3a.38.1793213441092; Wed, 28
 Oct 2026 11:50:41 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:17 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-6-kuniyu@google.com>
Subject: [PATCH v2 5/6] memcg: Uncharge pages outside memcg_stock.lock in __refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9542F4000E
X-Stat-Signature: ak4bx3t65p67ss4144o18dyywpq4maez
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793213442-499061
X-HE-Meta: U2FsdGVkX1+suyd0Lo0TkTSALTP0wfHg9Ndm7YUNrsuskx3HyqJVFMVFWwrYOJEq8UfHxGYYKNyJHkq2IyQ9He8Ybw+Ur/UQT+cqb/jKfJTTHtW5UiO39yPvw99xtfIwennfqc9FFL2FbS0VKGbfYlInIH/AjfJhMAuckTdzF7vH+uuk3imzbvkeSP0/kz1z/C/JVgQGVhi7r69YNXhExJS1okPlMwR6QK1QcSXeTF2zYWD8RdrW9wAwVgVHeRVnil0oh9aBK/8N0zi7l1yJwNTBJnlU6+Q/0uTFeFOPalwLLTTB3tVYeVXDCePNcdvFT84aU4EVq3ZvRY4yk6S0ABCZy/AaPfyHxs9I/07iMregIng74KyFawQARqtFlemRsYO3imgSxoW2/OqRwhm+UOTaPHELZLRI0wuI3U4BzzzLy52ovIDHsqwTyCGBAwuq2odOrAgJHhHNjYOnSV1Ckvl4GzQiU4WOyub6Nv729NqWxysGW8tQBfX9kWMwMNNpDnpunI9lCgl3b5yKCbpg4t9rMZzOT3z4uZ1uksLKdL7+zcdbzUdFIdbdnrqY0B0mQpUoMRAZOFXtEsuSs6Z3DfWwBP2oQetdZAFG0JYJFDXpWD/guXkyiFqF0U3QqaFCVS+i1n8FgonEVIWPvC6Qd05ytgSrYqwiP3Aw3+euuSf/xsaZm8S1X6mFgeBk//nOAkewYPKV+0Gj/T9aCB649J+y01DKiPazzg2cxS40SIq0ewqKlfPDN1mCdkttt0FiciiOogH3koBT8k9MXpSy8fpEdWrv7gqbCuHy0Ymw+SDlVEx24HQamRbd3s01My2KOks0l4sL1+JXj5OKY6SztugpVS4rnuUblAOFJb8jacOmS6qa7E4P7MBBRQVpE711eQM3sEQIcxLpDn1yNvdcmF2nBZrz+1V69mYPS0nueKkHOjAFVXEGke8ZKCRGCJlGAwEvCTYOpvNy6VPrffR
 vaikgnmx
 h22Ba9yFzK/DIvgwO6w+ruTfzTc9dw4D6eceugI9IyJWEKs5lVveUE5o/ZU+20WUVwt7EGhcO6oH1FlIb23XcbWmDIO1DU7u0QXGRcgTb+giQuwjHBYnnVAvhTdii9Xv0Jq8LNzlJDuNitwVqbvCwl1aBFqChyHjAv6EOiMOuIHEzllMKXtfiy+7EIcW2sfesWtILYAROdp6+3zLSL2wMjCButEyJ44zZ8uwiR2sFeiGI8Oo8rKKfaOzFeynlFAGkWgiSiRs/Wa/Q4AQai/USFJrEW1nK2wbKcnV5LB0BcV3Jo7/3838qbN957o/bYkXa9MOz5uWf49ULQkUWmNo17L92reco5zk7XCVxolLsiddfssx0v1d5fHs7Ecb6s31xmy/TYDoGCiMkzJrMEzFYiMRFWPvXpQMb/DZVT8Lak7oGSD40FTGfMNfSA4t3skCozeXdL3R40je62P23x9680nc1UKDpYh4Lv2zUFBSEncCvEgXkfTPsnMj+ksbkqO4MrGKidgV95OW9XTz52ODOef3DY4l46uQ6/tZHMLeNa86AgC9l6sKsIqVvx8hwIa/BG9/ZMcQoXysBeUDUrfzQ9wwX/vrMOe0wuutULTX9kPIn0ekVZHfVxrdBow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On host w/ AMD EPYC 9B45 128-Core Processor (Zen 5 Turin,
2 sockets, 512 vCPUs), tcp_rr w/ 20000 flows throughput often
degrades by ~50%, 32M -> 17M~27M.

In the bad case, the number of involuntary context switches
was extremely high by 12x (241733 -> 3093367).

In perf record, 96% samples had the same pattern, where the
thread was interrupted during page_counter_uncharge() by softirq,
and later ksoftirqd was woken up:

  # perf record -C 0-15 -e sched:sched_wakeup -g \
      -o /tmp/sched_wakeup.data -- sleep 1
  # perf report -i /tmp/sched_wakeup.data --stdio --no-children
    96.36%  tcp_rr   [kernel.kallsyms]  [k] wake_up_process
            |
            ---wake_up_process
               |
                --96.00%--irq_exit_rcu
                          |
                           --95.82%--sysvec_call_function_single
                                     asm_sysvec_call_function_single
                                     |
                                      --95.58%--page_counter_uncharge
                                                mem_cgroup_sk_uncharge
                                                sock_rfree
                                                tcp_recvmsg
                                                __x64_sys_recvfrom
                                                do_syscall_64
                                                entry_SYSCALL_64_after_hwframe

  # perf script -i /tmp/sched_wakeup.data | grep -A 20 "comm=ksoftirqd"
  tcp_rr  101952 [001]  9679.340985: sched:sched_wakeup: comm=ksoftirqd/1 pid=23 prio=120 target_cpu=001
  	ffffffffb64cd0cc wake_up_process+0xe6c ([kernel.kallsyms])
  	ffffffffb64cb034 irq_exit_rcu+0x264 ([kernel.kallsyms])
  	ffffffffb68ad31c sysvec_call_function_single+0xcc ([kernel.kallsyms])
  	ffffffffb560158a asm_sysvec_call_function_single+0x1a ([kernel.kallsyms])
  	ffffffffb653c4ce page_counter_uncharge+0x2e ([kernel.kallsyms])
  	ffffffffb6541b28 mem_cgroup_sk_uncharge+0x3c8 ([kernel.kallsyms])
  	ffffffffb6561383 sock_rfree+0x83 ([kernel.kallsyms])
  	ffffffffb6577faf tcp_recvmsg+0x2ff ([kernel.kallsyms])
  	ffffffffb65604d9 __x64_sys_recvfrom+0x159 ([kernel.kallsyms])

The problem is that when stock_pages exceeds MEMCG_STOCK_HIGH
or all slots in struct memcg_stock_pcp are full, __refill_stock()
calls memcg_uncharge() or drain_stock() while holding
memcg_stock.lock.

Because local_trylock() only disables preemption and leaves
interrupts and softirqs enabled, an RPS IPI arriving while
__refill_stock() stalls on page_counter_uncharge() invokes
NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
memcg_stock.lock is held.

Every incoming packet in process_backlog() then fails
local_trylock() in __consume_stock() and falls back to
try_charge_memcg() and __refill_stock(), hammering the global
page_counter atomic twice per packet, and slow processing
finally wakes up ksoftirqd.

Let's move memcg_uncharge(), mod_memcg_state(), and css_put()
outside local_unlock(&memcg_stock.lock) in __refill_stock().

With the change, tcp_rr w/ 20000 flows gains ~4% more throughput
and is stable around the highest value.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b92e952c076a..87b189aba07d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2331,13 +2331,13 @@ static __always_inline void __refill_stock(struct mem_cgroup *memcg,
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
 		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
-			memcg_uncharge(memcg,
-				       stock_pages - MEMCG_STOCK_LOW);
-			stock_pages = MEMCG_STOCK_LOW;
+			WRITE_ONCE(stock->nr_pages[i], MEMCG_STOCK_LOW);
+			stock_pages -= MEMCG_STOCK_LOW;
+		} else {
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			stock_pages = 0;
 		}
 
-		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-
 		if (nr_sock) {
 			stock_sock = stock->nr_sock[i] - nr_sock;
 
@@ -2353,16 +2353,25 @@ static __always_inline void __refill_stock(struct mem_cgroup *memcg,
 
 		if (unlikely(stock_sock))
 			mod_memcg_state(memcg, MEMCG_SOCK, stock_sock);
+		if (unlikely(stock_pages))
+			memcg_uncharge(memcg, stock_pages);
 
 		return;
 	}
 
+	cached = NULL;
+	stock_pages = 0;
+
 	i = empty_slot;
 	if (i == -1) {
 		i = stock->drain_idx++;
 		if (stock->drain_idx == NR_MEMCG_STOCK)
 			stock->drain_idx = 0;
-		drain_stock(stock, i);
+
+		cached = stock->cached[i];
+		stock_pages = stock->nr_pages[i];
+		stock_sock = stock->nr_sock[i];
+		WRITE_ONCE(stock->nr_sock[i], 0);
 	}
 
 	css_get(&memcg->css);
@@ -2371,6 +2380,14 @@ static __always_inline void __refill_stock(struct mem_cgroup *memcg,
 
 	local_unlock(&memcg_stock.lock);
 
+	if (unlikely(cached)) {
+		if (stock_pages)
+			memcg_uncharge(cached, stock_pages);
+		if (stock_sock)
+			mod_memcg_state(cached, MEMCG_SOCK, stock_sock);
+		css_put(&cached->css);
+	}
+
 update_sock:
 	if (nr_sock)
 		mod_memcg_state(memcg, MEMCG_SOCK, -nr_sock);
-- 
2.56.0.313.g2479322e68-goog


