Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF516082BE2
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 11:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=KX/7Q0HA
Received: by kanga.kvack.org (Postfix)
	id E0EB16B00EF; Tue,  3 Nov 2026 06:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9DE6B05B7; Tue,  3 Nov 2026 06:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA8CE6B05B8; Tue,  3 Nov 2026 06:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95B7E6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:37:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EFB81603CF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:24 +0000 (UTC)
X-FDA: 85393607208.20.B7EDAF2
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 275411C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:37:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="KX/7Q0HA";
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793705842;
	b=1qOjjW4r7Upwg2oLR+dvMiSFOD/pV9sEJW80mTcbRtPBJkukFtN810rAnMbj2HPMruZxBo
	64MqKMCJBfgeWbM3iF3rfnRiNxqlgSBJD7KEMMenYIavhu743mhc5VLibzyQGZNbAwaueB
	ay/86b2KqiFSbBUq/8DEI9mT0Y2MqEk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="KX/7Q0HA";
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793705842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BHZ8wigQ+noV1zThe9Z+XoDY/JY+YdNhjpHWSzpgF40=;
	b=ONG8km1cS9ZV3LKaoKLR1IiYaArCfPYhg+iS8xd8DO47mY0OaJp4hza7PRYyCZnsvOPpge
	oKODhDprqtdm2R+qJUY6WDIIT0gm5hxSD/TE/FRenP4dCjezEDBQRZQu9YyVf/Kc1GEG9O
	jM4fxLtB7aRI2QYT8estr7vehEFL9gs=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c5358fc28so3318071f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 03:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1793705841; x=1794310641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BHZ8wigQ+noV1zThe9Z+XoDY/JY+YdNhjpHWSzpgF40=;
        b=KX/7Q0HAEAFP3nd5buUGaySa+ETcA00EvsqdQ9ReXA0hRf0DrGtpcbli2kJR9oWVr8
         qxDtYD39NA6IAm/j+y1ia+B0jfx923KtHdcRcvfCCeFQdXryn1UkLsln30xZJf1eVh4C
         ZClpKkIFBGEOdmqAYfyx85B9YoAmjfZNqlfDrZPfIUxMCWEEfNiEXPTuRTBPieQ/gsQ0
         3LHoDF3WdXmmOnVvNcu+9SHtTBynvo9y6ujsHTPrsN3LXmFuaAEqoSiBcTXdYjSdzzx+
         +jGTRS+emc7GHPjobj3MndFPOX96R/nSBK8u8BCd6BOCGWN0VEeGwLBKLpTezEZA4Z9d
         S2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793705841; x=1794310641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BHZ8wigQ+noV1zThe9Z+XoDY/JY+YdNhjpHWSzpgF40=;
        b=oITI3BHNbJ+pJENXXfx9+ag0olOWr9VRh43cRr9Zs1qm3vBlH3p+7SXN03um4Z0GsD
         wcUtbptNFimen/hPheiDMCMw2Ub5J7FyOPFCVRiMo7BAI7CXsLfjvcKRwB381V/mNYEY
         yY8o5uv3mzAxj0s0X+OU5nUz7XYyHyzQ1dflYutwIzwj4APhB8/WuNNkV5wQ2FfwNT45
         gT47ngWGT+JEWXwXRE7n/roMcYABReExfxzB8JNmUTr5kZ5W/J793ZgYVuLBp7futvQD
         mAxOWduQbChGMaM1DgSiSurh/pm1+Y2VUoXv6m0i1Nkn5KWoHdkJYGP1izGLvaT22ak/
         UcrQ==
X-Forwarded-Encrypted: i=1; AKwUvByMFMtTYH8vYx0Mx3+eDjHcFOYb7DUEZT/g1M2YVlvPLsZz9KVyUOdOed2n0oAIyhmIgCZ+yeU5Hg==@kvack.org
X-Gm-Message-State: APuU4Z/2KLQK2wOcwi4JxHazyOofIkhp5yTsQHQNyoR8nyu9dIQZAzet
	0zMHDCkLUNFn8YDmSEXkCqbELVYFaiGBx8xGnkKRvJmLfU3tU4V9AbBeWTOcboNs3Y4=
X-Gm-Gg: AYBFou1exbxasv4YnEMF4d7Sgmxo4eQEOza2zLIkGEC08URe7zz8sByO8T+B7VXupAd
	orrHd2Fu9eg7jlzUevVma/DQaoKzShWf+2xf9+hdFkCNki/4B5D8dNXXhN4iVKS45LBJ4OLt7Mu
	4y47EddxmqkoztaC+PkRO7VaOznCdi7feIh3x/pb6LrGC6lt4qQmsQpf07kTD7YisDWVZ2he4pW
	GQfH4n6snkfhBc6jT1umjlUFzMlBC66NdW7QDhpD8prqLA+HUbKx72AZ6LYbdp2VViawEzOfZ+9
	5qCcHQco9G4V3jbgbmXUqohjc2BNH1KGH/YuduLc0gIY+wAmclqCNUmyOS0NmekKDnzlbkFTtNf
	ZA0rnOIjF4S57Unjn0hs/Xis8xvGhDmVyRHeOkRyB7nDyqAj0abWPC47NPmIn35gO4BGHp5PYKB
	B0W4jcyE89uDdUsMHm0u83N+S0jYEsAGaaYGi8FtYBl7kq7PS/dZBaXI+UtvfG92fHLOz3uhiZE
	u3pmT3pBsR7eyMkCSTXIpv8I/A8o8Gvz7CGutQqyN78Xe0/XECrVN7h2qr8k+DVmcrqyXZWeqEO
	9JXqrt4qRZ2c5wjEioMZ3Nq8wR5icKaSqukgj4TkbyvSUFnIfJltpTXoY6YdaqlZbEWfJuzPcZj
	3IRWWY338X8noykiJQOoLuBGxuNbaM2McIBTK5Bo0BHUCJIK1f3s=
X-Received: by 2002:a05:6000:2501:b0:48d:ee35:b3fe with SMTP id ffacd0b85a97d-48e6e2b9c3emr28666535f8f.8.1793705840586;
        Tue, 03 Nov 2026 03:37:20 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78f95sm23000997f8f.28.2026.11.03.03.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 03:37:20 -0800 (PST)
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
Subject: [PATCH v2 0/5] mm: multi-gen LRU: reduce memcg rotation overhead
Date: Tue,  3 Nov 2026 12:37:05 +0100
Message-ID: <20261103113711.1832834-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 275411C0005
X-Stat-Signature: nxhpjm4ghdmu6j9upzncwsh4zsgzggeb
X-Rspam-User: 
X-HE-Tag: 1793705842-987851
X-HE-Meta: U2FsdGVkX1/yl34Qs54t438snWeqi20G+XsA1xKExZGzipXlfwY/KKhro+TAXVgF9Hs1S2CIszu2cftMZ7ih+7+hE6982b6E6LCYFOkDd9gNiRiz/87DMhBuQEtbcLIGqSx1M4lx2F9TCn3Uq2BGUS5sGP1tLbnQyz4Fg5bbXJWEyiPtAYzpHtYiC+vAd4WJJJ55GWgFNJzpeSfdw7tH+dIhg/9Oyyvf8iUtRmSyFalLACWOx0vcsDSXNqHYGvtpWMod0EDeEdLvP3hnLDLV9sCAwkf41YO61Wxgbw2mGYIos93SX7oQQnYu318liZNcHypTEFW4EjbcolsYVY25K+dj34325yS5Jo786FSrzsLSETpP1swJqhZaTmBNx8eTnGzo9UDBC89KiqN2jIni9WMbdhxInxzBITD3cya6Vx/YtzOjmGTNHGBp4d9ma+PfyWum3GHyd9KUsiglpsFduc/GzAMCw35Jy+/fTzKWgOle8ai6O3GPQXf02ikoNxLOkQbJqR3TQ35PC5IPHrrxi4mS4/jrc+TxU6HKmnL/DQm4O1qAQ4vUQpmUPxonVvKsN9ppQ+GCUD40i4nXXxZZ3wnG54rA9yW5uk3luL/7GvxGMHW8Rr5Ps3rq5SeZeHc+yKbS0X428OyzZZFLv4rCtVgj1bMS9ANFDjKcQQosnAlb4Vum2Vw61681WnVLFKqG4jl/JmE9ejEYEoSa1T6u+SC2qocP+bNUj/qwvsM9Bhc3KmC1ID6mlNwXs5taZM1MR3qx3DGTWb5QESwfR88iKGiuDSa8VXNzLPJHALKDcNnXpexP/lc8WDaf3irOc3zyzv41yx49ASxdLFm1oLYfnkfsvaL2AIqdTOh827v3Mx/TXBen2VmK2AU6IziPohoDnXssgiWvVObTSYWtdAZGYikshOtWTBt732baf2oxPIzjrb2eYN0VMzeN4aa5glG3rJ7k/OaZkso4CJ6Y1Yl
 TorfYkqA
 1YHFvmfHWcE7whjuME+2yExk8WVEqdo9Yj5favMFZWEAXgJOWuFURf6sfTUvY2baVvmDhA7EKnzjKI8cMW7+0pOiBcyzfC/FOGRsk8/xyraA3e8eDHcN4QkFZT3zooeUplstLTKA9p69gcKiViPqBk7aIKOhSfnSIdfboKEsU2AetES14RvnqUn36F4AKMDZpJw57UhTNyR1zWNZBo3OQgpOwaum3faTG59Jqc5P0mtsZ2XRNust5K+CkyBMvP0NS4sMrrLGWbF+sjQztzenA7FvLz8NHRqWBeB3Ae0BPjK2EN5HKwciJ4KoyMA==
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
---
v1->v2: rebase after MEMCG_LRU_HEAD was removed by d5d1712c5928
  ("memcg: remove lru_gen_soft_reclaim()")

Max Kellermann (5):
  include/linux/rculist_nulls: add hlist_nulls_add_behind_rcu()
  mm/vmscan: move code to lru_gen_{add,del}_memcg()
  mm/mglru: cache the last memcg node, make tail insertion constant time
  mm/mglru: avoid redundant rotations of young memcgs
  mm/mglru: reschedule between memcg reclaim attempts

 include/linux/mmzone.h        |  4 ++
 include/linux/rculist_nulls.h | 36 ++++++++++++++---
 mm/vmscan.c                   | 76 ++++++++++++++++++++++++++++++-----
 3 files changed, 101 insertions(+), 15 deletions(-)

-- 
2.53.0


