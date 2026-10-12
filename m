Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB3DCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798716B0088; Mon, 12 Oct 2026 16:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748CF6B008A; Mon, 12 Oct 2026 16:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636016B008C; Mon, 12 Oct 2026 16:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2765B6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:55:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1069A120B7E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:09 +0000 (UTC)
X-FDA: 85315179138.09.2D4CF40
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0CA9AC0004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:55:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ewW+8VN6;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791838507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bb8VrY2RstmYtS1K9jrAWH7oBDyhwk1ph8H2PIO6csc=;
	b=WsDz+3SGgiO1KIBA3ktyDDD2pG3cKlTqa6WzF9v6f7acc7dEJlQrH9gBmRLbIPcRJmlU2c
	bOFZrC6E5CibISOce4oS06x5ux67izJzTgnOPgs1GsOCk+w1FlzFEjvXZFfPV5CUNNLN0L
	OBPRorgwNOt873tCbHLoX+Mm7DSL0GA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ewW+8VN6;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791838507;
	b=2wI52SVEuvdsPoINKs4fVlikjWyUVpz+fbeCcx52ZXqs7Ag8DsNZZkKgHK30F0CYwn/dUY
	cApHZxVZT3/zLJnsPq4kHWkgZQK/txZQ6iiSkUCazRmIJOMZW3qD+CsAV0YBNUnlDVFnbr
	l3+YB7ler9dHZYuREGZVWZrny9ui1OM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48c4be28b82so2204085f8f.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791838505; x=1792443305; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bb8VrY2RstmYtS1K9jrAWH7oBDyhwk1ph8H2PIO6csc=;
        b=ewW+8VN6e+wuo7yy79urzsGdc7ZNKKRf/Dm9wG6/O2T+PWON2hWzWH1NuzvOWcCRwF
         ajXMokmNi7ja7ObKwUqEkkGFDm+PeLA4l0A9iEAfkYk7XSK6nERgufzYn7i390G+qh0B
         BwPq39U1ZyoCrl/h01MpNvz4ajC8saDxxzvW7E+AowA6M/nzYujs9cejEaKjyOVm4du3
         iYRmmrmA48CK3akgncKvcgsO2tqORi1hoshVjb6MRxAMEpBB+4BxnBcxZK/1Be8KXFud
         r4TvyKaQXc7hRUOcx2q3DR+KWZMIyZ8yEe2NC2m6oxB28ocDaHhV1m9+8UAJP5W2aGhu
         7K2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791838505; x=1792443305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bb8VrY2RstmYtS1K9jrAWH7oBDyhwk1ph8H2PIO6csc=;
        b=ITxp+0HaZn+1qxojSe7fb8Hj8FL2TfkxsxGtltoyGtvh3rL3teOTsqJ7aCkgaGciOZ
         0mDR8Hgj2FQcGO+LURhvHDU1xaAkUL/homv7zjDgo0qKXKX4V1i+vMF7m+369/OJ9xqd
         QJDTmmFeq2OPUu4OLhPuC54ZmcimLiWMlc1oEaY7FE2bshh21tsG6e2qpBfTpDQK/6b5
         vIlTvvWWbMpkVZpi7R/eRFG0NrySXyzWg4SeZBXOCayecFoPHw9ohOwdPQqjdyuVihZe
         zNf8f5tdTxSj8FSXoYXsF1UGgz9dXv5mi6D3MH2ibjBnHYceS3BPCwhM6WyHnBB5b4UI
         UrRQ==
X-Forwarded-Encrypted: i=1; AKwUvBxV+Dvtl6b+GgU8uN5rfVrLmV72HzO9j5SGivOMUsNiTtE0287N7kx3EytHZsP/imCIJ6i6jOEgUg==@kvack.org
X-Gm-Message-State: AFq9FYLI6tMggHzVMedbNI7KOwwQyrgkj1YdvweEABvdlHDJC31fgPQY
	J9yqOajWVC5munAlw1lyh+ZEt3lPi9SK8BoOi+uM6BRGLdPA91+TODwoLoilCq9ivXI=
X-Gm-Gg: AYBFou3hg7cVorivyBBir3X+h/qgyp+bUTujYrBh9CsBueTenhM5O2pDFkM6UCHwptN
	5hNsxO6iIL5zKxsaeBot17O4fd3+T8PV4b9wBToRs3MLfGSarRwpCWnkrZ+PmJHYFyb3F+EYcLh
	fxt9CiV+BMXbLFkGZNjG1/oQrfFTZH1Q3Zrc9z26Y+D1sjvDpyPHOsISmOG1VoxPWZbaC9w+9t2
	kXP6l5aYSn+o2EX/6LWTvJYg3/chJZFwwqlnkzZCEKzs9bZAZQn+uLyeUN8AeTWftX3VfGe+Wc2
	xjaRkAMDizZ8LPLJe5hkhunLNC4XFQC7iZrsKjsthYDFLJzG2o5aF0+B9YTsvU+C2uURsFzfQu0
	nSWNNBSSyFAVju5Ayc7fKI5ZAxAoTJGDR7yTI7irPbXSdnUwIZraVkPbLGBQ0SBMZU1QiAT0Rar
	KPHWzAxFr/k5Ye6faTt7TEvitavBEgGSLxmRGWIGPJVW5jTryko8GA0DaNdLcZ9x2fh+A4oDLo5
	blVj7fs4VghKDzQvNWFDc80IWTN20IEvbw0F7rvYvOncPsgJsgHNOf8bM4V0AaTq4ajnjCunogn
	j+1hYrQDrg==
X-Received: by 2002:a05:6000:2907:b0:48d:c18b:d644 with SMTP id ffacd0b85a97d-48dc18bd66dmr16906977f8f.26.1791838505418;
        Mon, 12 Oct 2026 13:55:05 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f04b700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f04:b700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0514ab1sm1895744f8f.0.2026.10.12.13.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 13:55:05 -0700 (PDT)
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
Subject: [PATCH 0/5] mm: multi-gen LRU: reduce memcg rotation overhead
Date: Mon, 12 Oct 2026 22:54:42 +0200
Message-ID: <20261012205447.2717801-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CA9AC0004
X-Stat-Signature: jqkzqe8sf1863t44rkyiozhok3agj5co
X-HE-Tag: 1791838506-332831
X-HE-Meta: U2FsdGVkX19CLW9bdj8zRuYBLSzCrHOtYXM+aZiWOKmuk8clP1LpwWgl48XKVnuHeNfFu+ZpXX3r2F+35D0GSICa0s04K2rmUD9apLnx6fuR0JuLrtGu/4cYcCJHf0xGEmc7s7h5eMEXOb8ZXn62d6Y5UTrbABkVCM+cdIjcFMbKG4pzzWT03YbU2mEaCqDDYQtPZ0zOUL4PNL6rzhHPBw+VvTaYMaeKqZ/J4eFwyq7DyG/4kGNHve4525zKJFkNZBENfygLv2bBxVDnpQD0q3CZ8E7SI395TCpMlEKZBblJodF2pKYFFgsvmyotLyedGqHgqg2SEndcRCkKHDIZD6zdrm/Ao9DK4/aLI5INd4T/5F+EwPys7V0kkcvkGsfvGxkKrBqE1qOdLkWpgJswsyepS/1l1cO93N/6jalr3Bb2CJQDVrXiBpmhit1BENTHVZD8OQO+moPDXG8c0bUI88BlsIGq7sbau4Z0WUK0lGQcg8kKn3U1/F1ThfuTkNCizdNLZQw5YiszMvSd87Ri8WP2nyeUzJzeye1IEMs+/duC2N9YwYpCHYWIuiT5y5v9cGnfRiKJlzRtpiDyW0AKJczdJrDy3frr3HTSD1XiDr+ooIXj0V4sY0BexqbmdUvfKkq6ZCUDZmyQyyhbKPPgusiLlIwDX5CTcwtX0bJUAn/Zi7TeIBUpzHtVy/2HYa9LQqCFu7J3YPCi4nhbJC3X59SJTmIcwkUa8a/4ZQD7ggXLIJ0qlL14/0qec0TLdwxEqrD+Wt900bCQHzAUXd1Me5QBqxCO+9jxcEC5N31ilC9iUk0Bgqf54yCxUjQxSTX1iHnCfa/iBbjBAsobc8mvdnGf0b2AwTafP8YNpi0Aa4VsE3+p+HkYfqIut0etbnULldpgsawYvxzUgGNMHrWnXCCKdovGqMk6Ak0Qj5Xy+7rKwEaA3QptLR2FhTkNRYanTsLmnK/37dIuxCM+H3B
 3KTJFdBf
 LJGr7SfnaAeD3u8X2PzhuwraXCm+ZmzPmAcC2eRSXbd7Pl/+eCeFNnf5eG71aLvOBwfb7z+1Q28xV09Rec5yOWUhWd7Bl8+Vo+manWUoKyWEdS2wCx8bct/XfhDm0iuqNuO7zBd0PdBSch5vUXwwbMKcA8rHRZNBTjZRbs+M7ILK89e0p5caC4mRDZ9Xy706GToHemw9UVAC+iyo44YrCcT1ePJXzco+spht03717nVVHReYkNuWyWxKxIaWalhnyOxy/VRgYbHEB07VixulNaQ3UDmk82ZcZkksSNHnZz15Vrf7zcK/j03YY/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.47.3


