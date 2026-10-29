Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67587606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MOR3fC9x
Received: by kanga.kvack.org (Postfix)
	id 673FE6B05B8; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF5B6B05BA; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542576B05B9; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1546A6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:45:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A0F940544
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:45:00 +0000 (UTC)
X-FDA: 85376691960.30.BF4C3EF
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6C47180008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:44:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MOR3fC9x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3OaLjagYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3OaLjagYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFoNYJUi96cxZ7GAHijH9uanPv7mqKBvmKJStUGrtrk=;
	b=uNILwYg4jftgonBkcJ+sEsR/tTaJcEMdN3M1IgEZmc7O0Ka2Dvpq1KVt1JMvQMStGlclM9
	sd8QQbHMN/VxaHf543Aa0DyRau4L5NyMRT7+y1rIc7oVxDW7CpHm9C7aeoG7JnLTUfl5mO
	rcIkLn5TvMshhNOE8QIBocOh+fCymio=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MOR3fC9x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3OaLjagYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3OaLjagYKCGoScVQgcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303098;
	b=ov6awXGXDkQJUeoukYcsJ9IxCSeQ1K8VOmzks0B6juXPUJvikzjH3vjvqCCHiqCi+tP7xL
	VxISd/M9Z7nQQXtoT8yEhPmocHDxYZD3aQ6kWgDk8GgyAu9u1qmmhOmxCfZhUzHiZFaxl8
	DThOXOr41+GcuYCvB6lU6PgDspIuA+g=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d02df2bf09so46905ad.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303098; x=1793907898; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TFoNYJUi96cxZ7GAHijH9uanPv7mqKBvmKJStUGrtrk=;
        b=MOR3fC9xYmIegqfo1CnrllrSkluv5zt4XpDI4VYSvTyt7roDzk9box/K/9zSbyczFc
         9HGM4Atzzqwhc+7PyOUQEQuegiCJr9EXMXUYD7v4MwxM8Env2zR5oS0Oy+p/kML3Ja5T
         oQarJ9qzEs2eWKbupFmNt2M88QOF5S18U2xeV17NSz14KSVOvGdp78GCFYZ6BBkcAd2p
         yNDWID6q5Ny57CGeda/WGUXkwOMVwsloAW6gSZ7ycAAS5eR0nci1L647z/u0hPj4yrmW
         T90RIDPzdm3BPLDeFhW0PSV/42cE5UO2tBE5EFCPwqD+blSVqBh/P5CgRQUPZODUdT6B
         5v4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303098; x=1793907898;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TFoNYJUi96cxZ7GAHijH9uanPv7mqKBvmKJStUGrtrk=;
        b=GidgReyxQ6x/3X3hx3stY1oYrBsXWPKXd37eBmZc7Cthzzra88xcHmV62hZDoVTVh1
         rz1kpDMcP/+f6iuZZWCWjAxswdP5gByy5jjIxeREdhGOajFXF+7aRDHbRo+KfBTsp/yS
         dWVk6pxmoYPEBxXbOe9b3ZI2/80YbjZbeEHbNMPvh3epo9wXe6E6th23eLDLQy6lJHDY
         vXvsSqRKfmPTX/Go3UU5bVVKPhpCg/AcjK2Lm0V4DlZb01QuFDI4W6Fx6IadGafCYVjY
         lcp7GlEkynmAkL8LMlLZukWNhNLZctXPOQkfP6+qR28QkmFNy2Na/W5l2GV8fYHr7v8P
         rjdQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWFmQcvXg0nwUI6J3YNtHhcMUskWXwQVzgmYRGzGZ9Xy1J1YSoysShFRYk9G8KWkt7JR+yANTAPQ==@kvack.org
X-Gm-Message-State: AFq9FYIwZvyLgetmT5FKgn3VsxoXfcvVcn6wxJzFi31A4XBr7omB5DCt
	iFbpn6KmnmD/0v++nuICxI6BOl9ckh2z60zdUMiBhG96Y6t07PALUNS6iJ0a253Z058+jwQuAF6
	U1OE+fw==
X-Received: from pgfd10-n1.prod.google.com ([2002:a05:6a02:654a:10b0:cd8:ba74:813f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6b8c:b0:3dd:85a8:cad3
 with SMTP id adf61e73a8af0-3e9289ce7c5mr283305637.42.1793303097365; Thu, 29
 Oct 2026 12:44:57 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:15 +0000
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-5-kuniyu@google.com>
Subject: [PATCH v3 4/4] memcg: Uncharge pages outside memcg_stock.lock in refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6C47180008
X-Stat-Signature: 58gikr3aupchu71974977ti6wk64ozi4
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793303098-110751
X-HE-Meta: U2FsdGVkX1/yv8IBDaBCv7Rkc9k+JkJqDvatjOIu2FT4U+d638AYrc86eKDseIKW0mQKLeC73Ih38Q8S/WpJhrVCi2SRYbcVL7wkPo1BYQKtTYmhfqtA2HTEXHTpeW3YcAGzemVeTNy/vb+pv0Zjn+kMcCjPuPEQVlnq3ThUpm3yZs1YjlGUIENQXGtYkbwFT7IOP3o8SKq0ojyA+THKoHGOrv9raqFkUXiuzMlDXjSGj3rS8eK11K+z5vMYx6V12TiFyaPGhNYSaS+myHPwN25PgFCyAaG8klLiCWK5udkH9WdmWyjNw+6Gw4AEZkxEIhBA4eWX4lvg+EvleclTzP2xNN74+3aK8Dxv4vzwZMCEeTwy0w0k/VkCL1wZ+NNhI8WiKBioDz+eJhNcUF+tnD/tKlj+49uihYasuqJXoXoTW3dFAUTPpbc4zdfJ3BbIxJr3S2V2YV99A+5oAq1/ZD/D26xVy/BNghBg6VQb5eTGW+xtTYVeYd39NJ0ZRYd/bOCXYGFlrANyt35Rv/nWF2TkEo2uQDLtdcJmKQ12I0EVdK7YlypzNjA1Dnbs+ZCO+sCzyvqzAsnsOTU/wAT6XTg/rg8B4h9CZDFSClieaXhazlATOApSqJVtKt8HzfSJsoXf0YT5pm0S/u1ag7lowU/r17tpwTIm2omLAQJwSpBmNVEbOSmN0ymRFiHgcQEThi1jVvvvHYgopv3oV+BXcgtX2bD2YPWQ8gAEit7CLyee6nD8ybg5I4OJB+Hpdlf1OgzGok+bJjE4TaKjht9NyA5gIedsV0OYZuJfAMPAQR9nkpUMn/EM+OrWK4dMy53nzprHNuq9KOrqI4cLfWMCvkk08ADwQutv5+cczErzooZ6eAp3/5BIt5PWx4TnwODgX2RIiSyonNvHAEixZEOqs1Ks0HFrhNWjfOPl+sEYyqclLu5XkzKQfYSkMWLY8NXH+JkY8oG9BJuZyExO8uZ
 eoW2nI4t
 wa8iYfnOSsbSeVG/a/43bMOZ3Y9vI8z5jMsnSl8dMJUWJBOfZrfXSfSqCQ3nNaLEuOxQfCZm+Da3O+xi7zXMgxUERt4Ln7Bo50DcUT27Q/UGuLyJMXdPPs5JMi9k5wmc/RU0NuYJ73JXGW4StdRA0I6ifpQ4FzzQQ48HbePR3pEs9Zb4fji1URIk6RkaOTWaOK/u9IIpFxKgQeGAvdd6w8EzYCCW+TqXvgd0cmDa1z+SqLVgZ4YwEjT2oEsurlSls/Ym3e6sNeBjjEYS+9uCFYmDfnkGe7dSj1uj9EPHoWXD13ZgYMyMi+aUFGfZDde/INytPUXCrcGRbg6Fu447zf8IoMqMo7z3Pahvmffw5TSe1c3J/RN28pf8Cp+0oEm+kTWM0oLGM0blCJ7gJQHms0FEVEGuJQIJFY/EjPYS98FDg1WZVQnt3HE0+oB6ye1r9jtnQaJBUSoz/e18bcWDZHB1QuV9Pd9ZKeqkvyqE/gAQm0g7LeoFwB230kQuiNg2zmCLG/S3F+HWpmy2LFllImKFZbbCsMxFiVjMkt00HLLZYokaVRjOlbNuHThfn/eJTef3flyHA92McAX9OJDX1KrdOmFql2SfYHK7rB/f4kO9YS8xO5LY8aA7jTA==
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
or all slots in struct memcg_stock_pcp are full, refill_stock()
calls memcg_uncharge() or drain_stock() while holding
memcg_stock.lock.

Because local_trylock() only disables preemption and leaves
interrupts and softirqs enabled, an RPS IPI arriving while
refill_stock() stalls on page_counter_uncharge() invokes
NET_RX_SOFTIRQ (process_backlog()) on the same CPU while
memcg_stock.lock is held.

Every incoming packet in process_backlog() then fails
local_trylock() in consume_stock() and falls back to
try_charge_memcg() and refill_stock(), hammering the global
page_counter atomic twice per packet, and slow processing
finally wakes up ksoftirqd.

Let's move memcg_uncharge() and css_put() outside
local_unlock(&memcg_stock.lock) in refill_stock().

With the change, the flakiness disappeared on the 512 vCPU platform.

In addition, on machine w/ AMD EPYC 7B12 64-Core Processor (Zen 2
Rome, 2 sockets, 256 vCPU), tcp_rr w/ 10000 flows achieves 36% more
throughput with lower latency.

  tcp_rr (10000 flows, 128 threads, 60s, average of 3 runs):

  Metric                     |       Baseline |    Patched |    Diff
  ---------------------------+----------------+------------+--------
  Throughput (RPS)           |     20,884,499 | 28,453,051 | +36.24%
  Latency Mean (us)          |         478.46 |     351.07 | -26.63%
  Latency p50 (us)           |         453.96 |     343.04 | -24.43%
  Latency p90 (us)           |         669.00 |     479.57 | -28.32%
  Latency p99 (us)           |         969.38 |     593.92 | -38.73%

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v3: Add a new benchmark result without batching stats patch.
---
 mm/memcontrol.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a04b44656b38..ac43c895490a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2294,23 +2294,31 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
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
 		local_unlock(&memcg_stock.lock);
+
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
 	}
 
 	css_get(&memcg->css);
@@ -2318,6 +2326,13 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	WRITE_ONCE(stock->nr_pages[i], nr_pages);
 
 	local_unlock(&memcg_stock.lock);
+
+	if (unlikely(cached)) {
+		if (stock_pages)
+			memcg_uncharge(cached, stock_pages);
+
+		css_put(&cached->css);
+	}
 }
 
 static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
-- 
2.56.0.317.g454f8302e1-goog


