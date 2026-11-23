Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BD9606A6A0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=id76RmPg
Received: by kanga.kvack.org (Postfix)
	id 02DD06B05C2; Mon, 23 Nov 2026 08:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006516B05C3; Mon, 23 Nov 2026 08:52:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E372B6B05C4; Mon, 23 Nov 2026 08:52:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF5366B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:52:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 592464088F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:07 +0000 (UTC)
X-FDA: 85466522694.15.3BE8C98
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4095780006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:52:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=id76RmPg;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795441925;
	b=1ONNQG2FPLdULL9Gua/yOioVXH3E/Vvh2aPo33QhNrc3+fdk4iNbLihwIJyfkJqzqP1Ckf
	UKSacztZiuGJ99MzRSSQf3VEdFQqiJAaTg3wBuBg16luMJN8RgaYTSUlPZcJbV7PW0pIH3
	76CMRa219iDdNW8BGQuKnwS8Th3Ftr0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795441925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fPiZCMrGxeemf1W8hSc1ZOEaUK9xMjW2agUNdF2P2N4=;
	b=PhfPLIyq3UEFAS2czgGR5sGZkk7tt1UDK3x3bolYj4vZxm3xoFwf03bd9nYu/kMW7N3UfH
	NKipLBrRNSfXOmuwXOqy2H0vyxUG4DopUzNu0g1inwxEWiXKcK+TkTMXOQY5AZ5KJJDNnv
	vj2issdyTUS+dnvkgyJAHbO6rqcz7GM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=id76RmPg;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf02.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso40558455e9.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795441924; x=1796046724; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fPiZCMrGxeemf1W8hSc1ZOEaUK9xMjW2agUNdF2P2N4=;
        b=id76RmPgBo1MbvaMrl3TxqhFg6OZd40OkrKt7Sv6wfEQcy3YdsYdfGxVbyCHDSwsig
         Jg+pSJsAtQyQ+CE8Q/vilUx7qMgqoAjUhwRm/Qn3wPU5pn97UOR+AkfDQ8bhbaPA/scr
         aCf+PUVc3V/5tg7ySRARddnxyEjv0TFQj/yHIOFFSb8UfYA8JWjmbRnvq867VBleV4DW
         d0O8/QbhCeWwUev4o/HL/lAFSje+X9ZUUGId4Z8H0w75U4lKdfVIZT1axWk+r62bZkBL
         Y+vpm8kQ4DRhKF9TDmmPAPJzXQ6kH4ay+Y/ALLqsNQdkQgPQ1naFqEwYqTkQ3pHL2oKG
         Va6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795441924; x=1796046724;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fPiZCMrGxeemf1W8hSc1ZOEaUK9xMjW2agUNdF2P2N4=;
        b=ME26ptlCDQKGEGK3QiH56x0VGSPnO5WXKr1ySdlM+YnrzWDJSYq1astpmqTfJPq9WP
         4yl+lq7cvx7YUTRPi6OepBXNCyGFRTpEEUMrwq5qWZ61KhahUwSwr7pZvms0eYhYhVvr
         4MlxaXJQVA537x7lQMnapEi7ZxpMbDGaQWCuc2rsFmxN/FMvnl7C2iQbM7Jo/QlAUky5
         z5oXXpkqAFq00OJiKun5y3ie3yI9fg4YJsyXB3/xmM7E47gEzc5Rcc8e++hr5EI9PQBx
         SQAxsSnYZOUiw5i7p8K5JSTb203AULvOSl78Iq8B3/bvwAu5tT11H332hqkYQXIrNn62
         KXlw==
X-Forwarded-Encrypted: i=1; AL+hErFvJu0U/2qAfhUQ13GoO/UoTghVMtiAF3eIwTkzwx5o5eCeUvNofJVSOt4mdwJfDWHYL3bIXWEm2Q==@kvack.org
X-Gm-Message-State: APuU4Z/9r3TioEZki3UqNkj5h8VBk06xLm4BmIrCO2NTq6BNRVKB1mMb
	V/ChMp/ipnlvLQL+iMZQOgS2J3BNS+cXGAzfeeiC8jjPXz4WH/tN2US8Q5l7FDZmstA=
X-Gm-Gg: AZFdTZe3iViMj4CMxdyQH6rkY1nYZl0KjuITNjtUoWWpLDyGs7tbEokSO8xVoNFTCzT
	WpFDsV+uAl5WD6CfLVUlzvSBSmgnz7ll08XsZIO+juAm3/ZQQmFKbW2dKLOyd8yN7Xfw6HAeVeA
	6/LwvrslZ9HhBelG73UuQ493Oy1hCWXtyAgqEIzFNISQIWWgcXwl52zNw6aMyqFkZSqAh/n3Rqu
	VEmDtLUl+q4YacPVuhikbnprISgZJX0Ph36syslNml6GdaOXnjVN2sgYmOcsUj1UPZoeUB4jlkc
	6c8czJKCAnEwcOHJepaxl9pZKEsB62IwKM4/DQU2mpSNngJOw3rLwvhPJhPYfZRoNdefi9/o/qP
	5o+fBr1L8hj+w7njgKLdX645OxGOijO10AVF29xIVlRXTgST3u6IztgG6ave8aYJFnLcHuGG8SO
	GkSl76vD1quPTkFVysgrqQjC7654flxhvvK3OH6LIWmDQa0SN0STwQ5Hu3Z5Ua9ptc4W+6owDE9
	BkG3DU9Gn06yzbs5ZFs8XkMLwjdw62Gb/5T3olZfwqhqtMUH3J2L3YbWL+16aEm0US/wXpMnSQI
	fz+h2YEs3i4w/AgeJUksvMrAJ95flhmKfmkCx193FjWMevHU0/kIxNRWkOfQi05GlSW3Y380jrW
	y47OcaukJadY57WZhzDSriwcqpK7ObQ==
X-Received: by 2002:a05:600c:64c6:b0:4a3:598e:e7a8 with SMTP id 5b1f17b1804b1-4bb887c2c98mr222234725e9.4.1795441923736;
        Mon, 23 Nov 2026 05:52:03 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f1b7800023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1b:7800:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906817ccsm169279215e9.5.2026.11.23.05.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:52:03 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v4 0/5] mm: multi-gen LRU: reduce memcg rotation overhead
Date: Mon, 23 Nov 2026 14:51:55 +0100
Message-ID: <20261123135200.4086519-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o4o7hx1yu498gwcsq5pd667zw17hcuoa
X-Rspamd-Queue-Id: 4095780006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795441925-98795
X-HE-Meta: U2FsdGVkX1/VE4ZYL1UJDzmuATWuhAXXAUKOP6AL085aCnnBWX24FiXV90fLiyn1x8V/KI/iu8itsyLZc7AI1rHn7JgPe0OH9byB1SGQI1iERLYV4hVJncecMWSOZIoQBdJpVhqFQmiE/UXjr0ncu9Su/Dt0dq0D4wtGkhubhqvFGSGi6SsN/ObXOViW07AXHdEzWOA86mkLTN7Hf39vj1iXNVaSV5Akcmb1m0SAKSzb0sK1lAW6+SEzMVvJ6wWhTMpX51dLGU2FgfJY2h7zWS1Cnqu07XPofEIb19ZiXhbpa2x+hSV/oon0BG4ef7/0R0r/2gOttIqL16EMJOfJHk2SOc9ZrzPYaG15HsxQpqW8vulVFF0wgw21LICASWntay3kwLy0RlWyJzpWw23+yBrKT8aK3NwFqRYb5iJuEcj5oUwaA9LKszd3RQzeb944OdKLDergkAfbPL1YRJQOx3RtVRPaa0pXsTRNISzX45RFjRBFkGwCUSZLJC6bO1OsZ25nA/6UUHFmQsauJpiEQXbvvI26jKeo4cr9SYInBoHcy0Ior+rLrSvbu+8LC0G7u/s8AezlYbgcCybW10F6jTUs3kEyAB95mBCrXSanxX+LKn7vsrlzwETzMmhHxLRGX8FM4GEwxkK7v8Z2xXa09/Ml7AS7nMalAQUyWi8gNKjzOJH/Ma4xtCmNoyKTI7D32+mN6rfjulBKieUJgYWfKaNCVxDuoc2KkjijThRfXQThw3GoOmVQ6JggqLIUqqM4KU8hUL8r61Yrlv/xTkV5m0Z9mgZiDHtfR57iklVtthHx3iieDENzTniSo2wlEMpxnED6g6JlE0/sL2am2UWPhvUwY9dMkzR9gWxJyog7QPKBdbuZYZY0CznY0QAdcBNw6lcpfu+M1Betyw0vUhfV5vdlXgKZmB8/Z3oRVmfpbDe2sQKPDqDJ/lFjV2oS+Yf+cNIE6YFP2292UvQGICh
 iRe9kllI
 mmoO/g/5TBh76p8DCZuICjSD5NpBrxI6QnFmQvq4rTjTyJ9BJ/GS9SpH7mCAN67VJEw1eHsS0qPSpFuUyuSHuWB/I8lrKsQ/zpJf8zlr0YVe4CPZ99Y/c448fxYq2zw6fkf0XdSFT8775KYkXnzZTYkUMlFaWvmQ+xsTcirHy586SI3xu1dAhZrOzYFCOEjcrdeW2a8qiEGn4xVyty0vhDpuFRzhF8TrDhGWTyMNi3Xxlhu2gaX/irafh7XocOdioZAeOrRP2Da50ZGqxQeT/y2cwN7b2Bbd7cNBcymQ1HvhiyYYxEFzzvQrP5j4tvMxABvpNC5Hn4R9q7rDwLwxDs2+C1/I/Mqa7sS/ezNWKkTNtNOmAc7VKG0A1ksuasilE4UYtzo7iChapTRaOEwDRXZaukVM0masqDBmOZyL911l9oi4MFOOSoBnGbJpuvq96k4xv4O8XujUTz2jrs5tnbb4SPU7qWy9ZZxCGgPvUcBIuLuTfq/SoN0L8rA09jtQPSSSeKS34eYG5S0kZPxvqRDf3Kqo9TuzKw8YVQCRQ12P8Tls1JqN5YVSV6M6hczxZCDIIQ8OgA30qkcM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series addresses excessive time spent rotating memcgs during
MGLRU reclaim on systems with a large number of memcgs.

On some servers with tens of thousands of cgroups, we had repeated
soft lockups and RCU stalls:

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:         60-...!: (1118 ticks this GP) idle=ca74/1/0x4000000000000000 softirq=140067260/140067260 fqs=10
 rcu:         (t=2101 jiffies g=180256409 q=94266 ncpus=96)
 rcu: rcu_sched kthread starved for 2073 jiffies! g180256409 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=53
 rcu:         Unless rcu_sched kthread gets sufficient CPU time, OOM is now expected behavior.
 rcu: RCU grace-period kthread stack dump:
 task:rcu_sched       state:R  running task     stack:0     pid:15    tgid:15    ppid:2      task_flags:0x208040 flags:0x00000010
 Call trace:
  __switch_to+0xc4/0x108 (T)
  __schedule+0x2b4/0x978
  schedule+0x2c/0xc0
  schedule_timeout+0x7c/0x110
  rcu_gp_fqs_loop+0xec/0x4e8
  rcu_gp_kthread+0x12c/0x160
  kthread+0x118/0x1e0
  ret_from_fork+0x10/0x20
 rcu: Stack dump where RCU GP kthread last ran:
 Sending NMI from CPU 60 to CPUs 53:
 NMI backtrace for cpu 53
 CPU: 53 UID: 3758108211 PID: 4052395 Comm: php-cgi8.3 Tainted: G        W    L      6.18.52-i1-ampere #1203 NONE
 Tainted: [W]=WARN, [L]=SOFTLOCKUP
 Hardware name: Supermicro ARS-110M-NR/R12SPD-A, BIOS 1.1b 10/17/2023
 pstate: 40400009 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : handle_softirqs+0xa4/0x2e8
 lr : __do_softirq+0x18/0x20
 [...]
 Call trace:
  handle_softirqs+0xa4/0x2e8 (P)
  __do_softirq+0x18/0x20
  ____do_softirq+0x14/0x28
  call_on_irq_stack+0x30/0x48
  do_softirq_own_stack+0x20/0x38
  __irq_exit_rcu+0xc0/0x100
  irq_exit_rcu+0x14/0x28
  el1_interrupt+0x3c/0x58
  el1h_64_irq_handler+0x14/0x20
  el1h_64_irq+0x6c/0x70
  lru_gen_rotate_memcg+0x210/0x280 (P)
  shrink_node+0xb14/0xcc8
  do_try_to_free_pages+0xd0/0x508
  try_to_free_pages+0x11c/0x230
  __alloc_frozen_pages_noprof+0x4f8/0xe00
  get_free_pages_noprof+0x20/0x60
  ceph_alloc_readdir_reply_buffer+0xa4/0x160
  ceph_readdir+0x248/0xeb0
  wrap_directory_iterator+0x54/0x88
  shared_ceph_readdir+0x1c/0x28

The problem was lru_gen_rotate_memcg().  Its memcg tail insertion
walked the destination bin while holding the per-node `memcg_lru.lock`
with interrupts disabled.  With so many cgroups, the lock duration
grew too long and thousands of concurrent reclaimers were contending
for the spinlock all the time.

Reclaim can also repeatedly promote memcgs that are already in the
young generation, and scans of empty or protected memcgs can bypass
the rescheduling points in page reclaim.

This patch set contains three parts:

The first 3 patches add a cache for each bin's tail to make tail
insertion constant time.

The fourth patch skips redundant YOUNG rotations when the memcg is
already in the default segment of the current young generation.

The last patch adds rescheduling points between memcg reclaim attempts
and at bin/retry boundaries to avoid potential remaining soft lockups
under extreme pressure.

I ran a micro benchmark on branch 6.18 on a 12-core Xeon 5118: 8
concurrent workers repeatedly write `1024M swappiness=0` to the root
cgroup's `memory.reclaim` for 60 seconds, against a previously
prepared set of 1500 memory cgroups.  Each worker issues its next
request when the previous one returns. The test measures request
throughput and latency under concurrent MGLRU reclaim.  All requests
returned EAGAIN, indicating that the requested reclaim target was not
met; the reported throughput counts completed reclaim attempts, not
reclaimed bytes.

Results:

                  Requests/sec  Mean latency  Maximum latency
 Unpatched               4.56     1739.85 ms       4083.55 ms
 Patches 1-3            43.42      183.53 ms        393.15 ms
 Patches 1-4            59.22      134.03 ms        393.44 ms
 Patches 1-5            57.80      137.63 ms        412.72 ms

Constant-time insertion increases request throughput by 9.5x.
Avoiding redundant YOUNG rotations adds another 36.4%.  The full patch
series improves the unpatched throughput by a factor of 12.7.

All requests returned EAGAIN.  These results measure reclaim attempts
that did not meet their requested target.

I did not measure scheduling-latency improvements of the last patch.

This series is very similar to an earlier patch by Chen Ridong which I
was not aware of at the time of writing:

 https://lore.kernel.org/all/20251119083722.1365680-1-chenridong@huaweicloud.com/
---
v1->v2: rebase after MEMCG_LRU_HEAD was removed by d5d1712c5928
  ("memcg: remove lru_gen_soft_reclaim()")
v2->v3:
  - rebase on mm-new (MEMCG_LRU_OLD removed, too)
  - mention Chen Ridong's earlier patch
  - defer the get_random_u32_below() call until it's really needed
    (suggested by Barry Song)
  - rename hlist_nulls_add_behind_rcu() to
    hlist_nulls_add_behind_last_rcu() to avoid confusion about the
    function semantics
v3->v4:
  - fix hlist_nulls_add_behind_last_rcu() function name in [1/5] patch
    description
  - move get_random_u32_below() back to before the spinlock is
    acquired (performance regression)
  - added VM_WARN_ON_ONCE() to [3/5] (suggested by Barry Song)

Max Kellermann (5):
  include/linux/rculist_nulls: add hlist_nulls_add_behind_last_rcu()
  mm/vmscan: move code to lru_gen_{add,del}_memcg()
  mm/mglru: cache the last memcg node, make tail insertion constant time
  mm/mglru: avoid redundant rotations of young memcgs
  mm/mglru: reschedule between memcg reclaim attempts

 include/linux/mmzone.h        |  4 ++
 include/linux/rculist_nulls.h | 36 +++++++++++++++---
 mm/vmscan.c                   | 72 ++++++++++++++++++++++++++++++++---
 3 files changed, 101 insertions(+), 11 deletions(-)

-- 
2.53.0


