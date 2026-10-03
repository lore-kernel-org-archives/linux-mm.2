Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C003CA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F80F6B0088; Fri,  2 Oct 2026 21:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8946B008A; Fri,  2 Oct 2026 21:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE226B008C; Fri,  2 Oct 2026 21:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADD26B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:11:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3FAC1A0883
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:19 +0000 (UTC)
X-FDA: 85279536678.14.1969C24
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	by imf27.hostedemail.com (Postfix) with ESMTP id E955A40004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=NdFhe+3lPU99MaZo8XiPz9Oyx70QbjhFrYZaOYJvg50=;
	b=d8mQ1ENUFtzlILyaH4rlg8nDtCEsc17iP00PaJn5VuQ9SXfF7QvX52KJCLMWdtMghel9Hf
	3QT+cAa6hJUNE9/VGg0W98zCiNbN4ZIfi8rJwGgcb9NWN3bQl6QW1GzXgG4q+GJyzU9adf
	XYCwK3NX2ujBAORMs+2jjJysD51pXFw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989878;
	b=i573CWaI/r5SddpqQVCX3dQJWx5QgA8u1ixb82LMNmsMMPBHlqZ22J760J7mSJEfhcCpKT
	2c6OQLpHXIeTPppZf+V0yLotXNqKYYUmy/3LM+kzc1sEf6JRgbCddwkHCJA5jvzWNbMbGh
	K9M19o3ZPOsTaHqWIm5p4QGO2JnGzH8=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2a5d2434c84c6a24;
	Sat, 03 Oct 2026 01:11:16 +0000
X-Mizu-Trace-ID: 2a5d2434c84c6a24
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	tj@kernel.org,
	mkoutny@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 0/6] mm, swap: charge xswap for physical backing (xswap phase III)
Date: Sat,  3 Oct 2026 09:11:05 +0800
Message-ID: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E955A40004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hcnb3asz93ds9gqg36zf516p1h1a1dxw
X-HE-Tag: 1790989877-32168
X-HE-Meta: U2FsdGVkX18pskdRyqX1eIGxUwUPPxwNkyTKBweQHj0KCuVN+g5WCRvl5tnNRySTO8FhFZgF2BDRFGy2c0AYnd945l5Lm2O8n+o1le6sC2STQgOF/zKv1WFst+lDK782ZblsouviL3Zs8V5eQ/rHg9aZUp5rw+3lBovfsnEWzSuvy5866MTZDoCKWh2LKu96PyFS+Zkz3/eSGGkTHbmZP54zC8JEyDRvV3fkud65ExghuUgqqwDOAYTWP41C9i3o5D+YY7fjJKlvjonwYx26H9Y9cZRh8eeqGeShS6o+fEWpTbXJiSX+72at51yiTcFwEz4sO+6WbZSlO7st74xmM8SQJXoMg+4OUGQyq8a5yaG9izHfzWamozY77qQXvAp63IOPvGT+8X538CXYIy8ZTeQ3LSHXpIGQVPjd6YfhXxrMsXWQjuScMid8XA/zuGizlLkfNTdJ6UpMDq00qmACAZST7XYcZ8HpQELKywj/rNbgoXyU2DO/OxPlFeGtLGhnW2nAVuSfDZbXFtkQa8FEkq1ikrwTr2kZzto2vzORQvFNCHk/+7gGhfN2A5G1xM22ta1fv1lWW5CbMyQsbZ8HCZiPmaTis6MLPIAWoZbujNYxD1tLmTbpPcV4Pyjn1MUsCKnlUR4NZ3pwg+WS/pMbgPLayHjm0Zo7AAE7FXpcoFcJYAN81FrC7c74YhT0vfISjjc7GHOr1Yr8N1AZFcK4Feow7M3HnVydkJiSBHpCg6UppkKZ8FvjFSEFn2DjPRfagg2yjBooB1ZxZDVYfcNaVXO01C67LB1OUV0BLpkQmCwMOQFZI141ewnTnoUFxldgVcMczfQA0DNwycKatXJzv9J5w0iK5lCBSNt5K7EN5yIJ29sKQ5c/u0ZKKC8XIRK9m/Jmxib0Ca9tl7+Z7Z54IuG0PW8AlAWlp+4MzPORxW7JAYzQl5cryYuAeC6ayxJ7sGSVmu2Ahhbu5kUFKPc
 C/YKJFvK
 fHvlpiTp0OSiUNsACTViqvcmNmUD8A5HEKjaN3w9UHiVEam06xWEtQOTraS+MBiS7fTjwmHDBa0pc1gvZipJRqqiX+iguBzecNuwrOW8TfKKfbarGU29HkPVs1kH8WbjhdxfURoC1tBtIH6R3YIy8URL86ZJ3kH6Zvr0Zg+yYwmjjI8MGpnK5x91NikEStSZo/HjN4rY6ZxPKLCL9jHhzEL2ElTl33NfcpUEO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An xswap entry reserves no swap space: its page is in zswap, which costs
memory, not disk. It was still charged against memcg->swap at allocation,
so memory.swap.current counted pages that never reached a disk, and a
cgroup with memory.swap.max at 0 could not reclaim its anon memory at all.

The charge belongs where the backing is taken. Record the owner at
allocation; charge only when the entry takes a backend slot, and release
the charge with the slot.

Phase III of three, posted separately because the charging semantics are
still under discussion. This series makes memory.swap.current count only
the pages that hold a backend slot; it used to count every swap entry, and
an entry always held a slot until xswap separated the two.

Design notes
------------

Patch 1 splits __mem_cgroup_try_charge_swap() into get / charge / record /
uncharge / put, with no behaviour change, so the record and the charge can
happen at different times. The owner is a private ID, not a pinned memcg:
an ID is what the swap table holds, and the uncharge path resolves it back
under RCU. Patch 4 stops mem_cgroup_get_nr_swap_pages() from gating on the
physical margin for a cgroup that can zswap.

The patches
-----------

 1 split the swap memcg charge helpers
 2 do not charge zswap-backed xswap entries
 3 charge an xswap entry when it gets physical backing
 4 don't gate xswap on the physical swap free count
 5 do not retake the cluster lock when uncharging an xswap slot
 6 drop a refused xswap backend run directly

5 and 6 fix bugs in 3: a spinlock taken twice, and a refused run given back
through a reverse mapping that is not installed yet.

Testing
-------

qemu KVM guest, 8G RAM, xswap.max=10G, zram as the backend. memhog faults
<total_gb> of anon, fills it with a fixed pattern, and holds it. The
invariant through all of it:

    memory.swap.current / 4096  ==  backend Used / 4

Both count pages holding a backend slot, so over-charge, under-charge and a
missed uncharge all show up here.

  # echo 1 > /sys/module/zswap/parameters/enabled
  # echo 100 > /sys/kernel/mm/xswap/create
  # mkswap /dev/zram0; swapon -p 0 /dev/zram0
  # mkdir -p /sys/fs/cgroup/xswap_limit
  # echo 2G > .../memory.max; echo max > .../memory.swap.max
  # echo max > .../memory.zswap.max
  # ( echo $BASHPID > .../cgroup.procs
  #   exec env MEMHOG_FILL=pattern numactl --cpunodebind=0 ./memhog 4 600 ) &

With zswap on nothing reaches the backend and nothing is charged. With
zswap off the two sides agree (526429 == 526429). memory.swap.max is
enforced at the backend: at 0, a device-less cgroup is killed, but with an
xswap device the pages go to zswap, cost no swap space, and reclaim keeps
making progress. Destroying the device returns the charge and the backend
Used with it, workload alive, over ten cycles. Also exercised: the same
invariant on an ordinary swap device with no xswap device.

Changelog
=========
RFC -> v1:

- Taken out of the RFC as a series of its own. The direction for charging
  is still under discussion, and the writeback series should not wait on
  it.

Baoquan He (2):
  mm, swap: do not retake the cluster lock when uncharging an xswap slot
  mm, swap: drop a refused xswap backend run directly

Nhat Pham (4):
  mm, swap: split the swap memcg charge helpers
  mm, swap: do not charge zswap-backed xswap entries
  mm, swap: charge an xswap entry when it gets physical backing
  mm, swap: don't gate xswap on the physical swap free count

 .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
 include/linux/memcontrol.h                    |   6 +
 include/linux/swap.h                          |  66 ++++++-
 mm/memcontrol-v1.c                            |   3 +-
 mm/memcontrol.c                               | 164 +++++++++++++-----
 mm/swapfile.c                                 | 138 ++++++++++++++-
 6 files changed, 318 insertions(+), 61 deletions(-)


base-commit: 456d37694d1e05a1b9ddbd1e493bcd6cf2016b4f
-- 
2.54.0


