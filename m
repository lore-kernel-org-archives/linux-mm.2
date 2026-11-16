Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83B3606A88E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=YOLetY/N
Received: by kanga.kvack.org (Postfix)
	id A4AB06B05B1; Mon, 16 Nov 2026 03:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC786B05B2; Mon, 16 Nov 2026 03:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA386B05B3; Mon, 16 Nov 2026 03:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 682A76B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:14:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBDC41C4253
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:16 +0000 (UTC)
X-FDA: 85440269712.09.927527A
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id CDE4DC0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:14:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="YOLetY/N";
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AnqFXuidLiaxByYIxjVtd9KzsEjAj9vwLIHGSb6bKLs=;
	b=03veQRdZRntlSv+bfH++f9n9mIQOSsP5e/IqSBNhyfO0qBPRQUyJ42lxcoIDpepss+ADEQ
	rR1VyhIoAxBREXNA4vmgXPvaQwi2IycHc85jCUE9cIcR9Fa0A4E/bsRaUfnMXfwAnHXXoM
	TcqddsTU0c183qr2DjbzpXMM3Lv6CQM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="YOLetY/N";
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794816855;
	b=lMDaDzL17lqv3z+UpT6mZnVwV88+6Y0+tNEndPrq6pcTYy2Yb6dSIV+vEWghAliwN4/QBY
	vY53A9hMrtYzorSAN5aF+k4q45voymI7zNt3BqWcBk3LpOuQeauobeUdhQ1ISsH3XJLfk7
	+LZfRBtW8MDK2SRjeR+LH8OEGJPWVeA=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490f38e9688so2156589f8f.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816853; x=1795421653; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AnqFXuidLiaxByYIxjVtd9KzsEjAj9vwLIHGSb6bKLs=;
        b=YOLetY/NBdw6EfahlBzLtYCjBj5Y3OiwRHOrCrDxVbuQYbBjz+8eaWdweuvz8B0zld
         cdgZxsrrllVzQT+r0k4OjAsm/W91V91zPqm/BVz6sXGbR2ooJdi3IcL/qnbT4cTiszVg
         SeSCXjRA8kYmHPnwY6VWgyWkwv5u65DCgWs06eAOLEqBa0VBV7WYL84PkaOLdoZYepUW
         T6jWKV0GaLUUI1CiL566mqV6RY7vKrfI7bzJ7mN+6qAx9EnpvjSNAEnApXFpoDZmJ7qQ
         rq4DMd/n2Eu7/VnL6CK/B2NJ+u4VcrnymcwUQYVVopn754nJ8PClXdG3j8ON16rJTDuG
         RMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816853; x=1795421653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AnqFXuidLiaxByYIxjVtd9KzsEjAj9vwLIHGSb6bKLs=;
        b=m8s+PFrV0ByInw9Hj/WaqLLwQObWVGN3wX5OAoHZpypUoDf/GoLMJ0/uHhkd9TlttU
         NsAk1+1lJsi8VZUrKR/HWnvhjS/+61YQW/MjaumndF4vlUcqoi5nbUzMIP9yOJFiGbW1
         F++I9djgMAOmMXXajAs9AWnOwFy+x1BLV40dvRHS4NwwxwahbHJf7yFOwv5b4BLP/LHz
         JRz+x2VnJdbpx1yWShlSU2BnISssEoyKfdKn38KNEti94whJVUgWU5W24AvTYYKU7vdz
         Fds9N/nBNsMwtPWuLFoXLeqgG/FitQYNr6tg8YsOQHRiw3697vPqePspBZ6NuzMDgANq
         kh+A==
X-Forwarded-Encrypted: i=1; AL+hErGGKkDtpmKPPOpLYP0RNn8K1ejKX/jCeFC9Cb5qp0QEtuCt4WP/SxQvesyGodGg9oZIVr9+NnIePQ==@kvack.org
X-Gm-Message-State: APuU4Z9aWHn7OCYSqBXaXrKe+LwFNted0b8oTrO26N9OdaSTjfqK9G9U
	NorrJDDQ9c/Q0zQlVfK7CygYB5HmswCyg+uEf+5WdkBAy3YyuGulBxJSP/x1nOZBgjU=
X-Gm-Gg: AZFdTZfx3vxs3Rw7+wRb8XmgDM4L0Za5bbgS7YDBNkxw8lDVIW4leaFrYySs+PlHfl8
	fIDReTyxilYv0AP9O+C6B+fpaVqJDiqqlZYYswz6LcpZk3k0nV0TNbxrybKmBym95WN0/5Ej87Y
	MgRJpXGMhfQwZXkTOWb6vvHF85+9uDsIw6aT/fF/opPn+MqjL868mHuOFrPT2lqyw5LCrQCgskk
	gIMZWIP7pAQoC2O54jX54FBuDdDlp6MHUU3X1MrL0VkyDcC5XRHLmKg6R2UoNgEN14CCdkSRvSu
	JpZVWnWHZAPKy5YQRayDwBcZtzU0nU2JGl2G3W2kHfM5pAqKywKsKXDtcPI0MGwRxFp9DYeExzi
	kETUmwfjvY4mBVUIQuuJMGZ+XKznirQ2WeQeKzXVYKnV1sYbfe3aJadzgteUgdg2vKwXDlw0o3l
	2YKM/T+5lWEyGw9xFHQU/PGSALyu5J22UdeMyQ0XUTotkbidDarrR7ZH+x0KrYJdiwuD1MfGIiW
	YoaEP0W0g1SastxmGD4JZpH97PY62kNg2QDXczkjimcTxpFHL2wI9bgqn7v1YDryZx+QbkKsuW5
	WlpyS/0suPpod7/12F/aTmXrFNZSKYstSIREu90vtICEt6+dbHacujwtZTisn8/I7NJHPBEZ9JT
	ypyrOLpbn2xVOlsFUMmdMo0BCP6zm66YjG5M3IM77vxyKrhQTyA==
X-Received: by 2002:a5d:5e07:0:b0:49b:b94c:e8e8 with SMTP id ffacd0b85a97d-49bb94ce98amr26317536f8f.8.1794816853264;
        Mon, 16 Nov 2026 00:14:13 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f4cbe00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f4c:be00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm22902289f8f.11.2026.11.16.00.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 00:14:12 -0800 (PST)
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
Subject: [PATCH v3 0/5] mm: multi-gen LRU: reduce memcg rotation overhead
Date: Mon, 16 Nov 2026 09:13:58 +0100
Message-ID: <20261116081403.216452-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CDE4DC0003
X-Stat-Signature: ftggzb4f8xm6hc3m8pyt8qikw4uznegd
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794816854-147349
X-HE-Meta: U2FsdGVkX1+WQBJ+twfDIh72wvZu0vPr7/u87cCKFpmdi9qa8rCPfaLtebj2+SY2ntFkNGZlN+F+qrjQhfYTroZdW+lOLqvzx5aV63VLXHsw1AVVEqe+md7Z1MHzqbbvMkRfjnU0Y35zh71F7fA8JBsLCjBlWor4iCadJJh/bGrP3Qe3hi+HrHWjC7l/uljjh4of/eiVN9iVZ75bbD9c3I4Ftcf9TyXulEUyRzf3IjSMMRbvQRpda/XelkkW/Fx9hxOmZW1AAJ81nbIbWxhBA3va5rKjma4wG5u0EJ/VwzI9etMLn3bmt0qgIKZRe44isTI3JqqMG6wRtBXkJyHSUKg8twNvImFZf/B+j6hXL94iUnQDTm+5CgNPRw9KPDqtUNGcRJWuBMz8aZygKmySmTBmcLtWgop+pxw+1+PD1lXNBM+a9iBdetbL+9l4kv7XnjUqX9iWErX3nMpHGW13aF1OztzH0dLKTXeeQ4v1E0azqpR2kvBKKYLBVkNHjGFzNWmwTHwzvcZ3W7VdRfHU8ZpXtKbTsIWtGGs4kXOVjKE5h/2qc7o/kRmnNjyj8B3Y01kjCYfEQIP/QOCxgdciB7yJ3O1oDnKLKPRh6Gw7gai4xIEmNqHiUmvES1NVf7a65UdG4EC0xGIi414ETUiHcTj5iJjuv3dxcHfu9XVv7mzkZxA6/3zKMxeBM7ISVqL6MoHvfqTodWfkaOwZuzU8YuMmhdBVuGuGLZmzAv4RpXODKKqUzl8rUQKBZl/KY3fY8ytDuPj5dXBurtRpw6Yjcprb7sZ0jHtooiEL5pIFktZg/L21xXPM5MwMI7tkn7kHSvNUIsT2G5c6dmAuBWAqXH6vUL2AD+CD4ib2GrUjHZpDOEhicio6wT7Oz2YfEG6ugcIJqkjO8W1vJqCexN7jwK+bIEg5nhJHQDqWD9XKa4fFc7GmagDE9yHsAvzFRwkLoFYkT850iXLHRfyOvEu
 bT1gLLbE
 sXTswtYNiOdz0iNwTUK5oJn386XyrFb4yxuADIo6dnO7aufiK7xEJD2Fvz+04R7eG0j9X3e4AMjxJSIfaA50ibGvgnBhPE0URqk1phLYxK/LMZ1KExkE3mkg6Mod7a1+DmaOkAR3NmC5NlwHiWU9r7ZSkxDE695Fc3aIStK0J9bN61IKSMbhBqA+AGsf0jJbCWQxkbwq44F2d8+UX3sT63wmbJifaG8olpLwfMfRX8J62rbwMPbPClBWsWL8RS4/0W4P2OvcmDp8Dc0WeSHcXZqQ3DcEU7ppp/a75jBsNbmx9ki6LJihWPkGQStQCmpl382w8tyyMe3TX0ca8Yb7oHTBWYPSqHcHvZT2QKCHRDpY3oL4=
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

Max Kellermann (5):
  include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
  mm/vmscan: move code to lru_gen_{add,del}_memcg()
  mm/mglru: cache the last memcg node, make tail insertion constant time
  mm/mglru: avoid redundant rotations of young memcgs
  mm/mglru: reschedule between memcg reclaim attempts

 include/linux/mmzone.h        |  4 ++
 include/linux/rculist_nulls.h | 36 +++++++++++++++---
 mm/vmscan.c                   | 71 ++++++++++++++++++++++++++++++++---
 3 files changed, 99 insertions(+), 12 deletions(-)

-- 
2.53.0


