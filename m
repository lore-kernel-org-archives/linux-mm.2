Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 970E0C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724126B011D; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651866B011F; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFCA6B0119; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1AA6B00EA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96AB31A004B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:57 +0000 (UTC)
X-FDA: 84984433674.30.A7244C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B005E1C0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hutX5raY;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963615;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xXlp3LSCmqeLKkJ9pLCunCj3Sv/06RfsfZ51UU6ozEM=;
	b=4A2ZQM400UH4qEiBlZePtJMAj0r/h+9CIADXwHVY7lV7osOi6uMbz4mhaHKOtTWaiHDcqO
	1IBAJQQ/wXrkJgC9KH4739VAr1xHFdu46xZmubniwwE5UaMNiK0c26WJzBTS+tu85Nty6b
	A91X139CFtOh87pV2jen45LOkB4gu4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963615;
	b=U7mFMn60EFbGz4PWCaNluKA3gdbdYT/w2F2XBZqhrQFx1aDfjqdMDQMArhscXW9nQ+4iJW
	oUpiT7rC3VurudrWei8+dmQEpfIj1Q5N2IC+kV22I7EpouNHnsd0sH3KkUnjfRm0IxVV+t
	n3LUuCvNl7UgJMJwEwxSg78ulKNFJ0Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hutX5raY;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0700A60008;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A565FC2BCB8;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963614;
	bh=Kx8G4hqmRXWTsJ6zc3SII4f1OYOrJ6E6dUx1yBEVJmE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=hutX5raYLXoUNgaqyUl85iYNUkJsain7/ZlwDzL0UOB4w9+Hu5phqyS1lrwt8ISOT
	 trgVIxuc67+USZ+KZmAm6/PlHW6/9ijhh8hxS72LL3cEHoDh1YfgUErFliYz3GApRP
	 hGsZU4P/gnGSnaeJGOhWWVjB93X3gvcy3ssBe1LpiNeEumJWwDpESfIUpytOc5akTr
	 WZnpaKEHCGqrhGNa3qtF1z1hpR02Wkosfhjjw8PsxicAyTxIE+A+t+PQlAJJJdlEJu
	 60ctff4Fp1Ng55N+MoLmmBS7ex53ccTd+caP4WSIHoLJhszYXFxAd9tYvQGZU0PhxO
	 2oAwvMaIiQzhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A12C44501;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC 00/13] mm/swap: introduce priority queue to remove
 global cluster cache and plist
Date: Tue, 14 Jul 2026 01:25:38 +0800
Message-Id: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDUyNL3eLyxALdgmQgLsos1DWzSDFOsTQyNTW3SFYC6ikoSk3LrACbF60
 U5OasFAsRLC5NykpNLgGZpFRbCwBgA1S8dgAAAA==
X-Change-ID: 20260529-swap-pcp-priq-68d3d925578c
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Baoquan He <baoquan.he@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=7745;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Kx8G4hqmRXWTsJ6zc3SII4f1OYOrJ6E6dUx1yBEVJmE=;
 b=c+w0tFeESadMAszrv3sx20936HsyfVQ7Hc+brIbOgFuU2E+yGJRfqeo4EUJAmxiX9Tf7VKPif
 v3jUiio/AdmCNj+0/oNQb7yHSBR8vomFy26HHHvVztfvR0NyhQchvw1
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B005E1C0007
X-Stat-Signature: m69y9qsupcyxbondoyssh8fsmofqjmis
X-HE-Tag: 1783963615-195925
X-HE-Meta: U2FsdGVkX18OuXYf0uaRXVsUHaJDzv+TcpehY8oESMu0zF/F27dzYe19PeP1piIo8tCv9xHsWWpaBjhCgeFbViivGx69icBNigY2OO0JZkvUrodk4AGJOgLVC4pWx0UfVxzRQQT/2Xghwr4q5GHqREvElF3dHuTXddJXCAjS/8lIEsKGHyu/2BnGMyL0HR0HfcVk9B1/Ii9DpFs+GqNIhnb6Txqd9UQlupgNnvmeHrb2FbPXo5c67Isic81G6L5Av9kNUjjf3/iZOZi6u+pejgGFaLv8IX5NMHjb/hQdRBf+4YzCi7tuKgdNM4gdWDKhICQYKodv7RgoDQ2ZtnZYQ9rT4NMG4a/Kz7GtdURQjXj1bRLSrUFnPVE4FalvgxR7LSfFC3s3mh4+FOwTzcWfHxxeQacRI0/pBzh2lq/lK7SFmtdvtO2FCzL9QP3QW5Oxr4WCmEEiZ94U+9Ue3sspo9UKhKb3Mf1BlW4HMKkkOYz+W4h2IXKEjOoZUW/YC7fIL8xG/gb+iDqGWVoL1LmIPadPQkCQcU4aoBOI07ERtQnsQmuxEPU0rGpXuiGqF2cU/2NHhhE5z7ES1drCidowhbMOpNPmzvcm+H8+tEMAk6WR0MVXXl+sVLwjUhFxD1bX2szi5OlffNHQpEBh2xAhhlGCMQezyyVCeWopPTGWzmrBvXBvjCxGYoc8eWTXw1ft9R5qrJWGidtx3qk7od9MLz4filzHoXyx3XkIx8BFKZZD19i6C949BXBg+aeUavovwF0tE3l6tzG2UVBsAIv94/GCKOQdJ7HFr+7yR9rQqcEHXon+PDr7ZXlo+jDqywmBjCY8GvCv9O16JbY+2DDJlfbpOWbO93OZ5tk9O03eNOIkWLr5wHmPnClFUXdHMDdp9iIQRksBeYd9BixQh8fQKTnG607g1R554GvyKmb4dC81cPxQthZNPpuvjBXCUD8WpWxVpfQIEDH8aAWB+RJ
 dnaV/mAp
 /ONC0OpeLMsBv8dOd2JoRCWYA49b+xiO51G+b9BSGHwL+JiibSIM7ws40y24jaENxsgBYPnnf1IjNmNIDHKVl2easBZWb+e1GQ9GNjhs8TpDLvkoV8fxN46MsAo9oK3vF+j6d/EbDDzKpqcg9vKWT4JjYLJxMjczViVJmHRI2N9H2kksSjrnKnfgOu93Lm2NfEgpyW+Q29uMAUxhmSeTsED54pE32IvxW54v2NXTb9GA2f3bDVGu2+IBo9fg4+IBnfHryW6AP45rBQ0L84UfpWHNXh7o8dxY4ByrGWinORQ1VSPvC8vyfN2+ZrgIODLk0miIeBi4SV8uwtYL8FNCrg7QorE+DNW8gMpbknsAP1AlhrpwoetuSHIwqEby1iimb/e6/VXt0EPm/X3UfCLdPSJO8eful4jbqIa0f0EknwodW9d3uwsQ0DEaQA+Chne7iejYsukjTYLEWo8ne5w7OrIXXzCF8lxfivW6i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series introduces a new way to fairly distribute the IO to multiple
swap devices, completely gets rid of the mutable plist and global lock,
hence removes the global cluster cache and allows allocation and
rotation to happen more freely. This is especially helpful for swap
tiering or layered swap. Sending as RFC for review first as tiering
should land first, this can rebase and join later as an optimization,
and there are a few items that can still be improved based on this
series. I specifically kept the tiering and layered ideas in mind to
make the new design friendly for new ideas like these and tested a
few different appraoches locally.

As a dependency, this also cleanup and rework the locking pattern for swap
device management. All swap devices and the newly introduced percpu reader
priority queue are now guarded by a percpu rwsem for better scalability
and a more future-proof design.

Previously, each swap device had its own percpu cluster cache. To improve
performance, commit 1b7e90020eb7 ("mm, swap: use percpu cluster as
allocation fast path") moved the cluster cache to a global scope and let
every device share the same global cache, so we don't need to always
touch the plist. Fast swap allocation will just use each CPU's cluster
cache. Device rotation is still always handled by the plist when one
cluster is drained in the cluster cache, which bundled cluster allocation
with rotation. It works, but this whole design caused several
long-standing issues:

1) The global percpu cluster cache sitting above device selection
   fundamentally conflicts with concepts like swap tiering and layered
   swap allocation. We need to bypass certain swap devices, so we have
   to bypass the cache as well because the cache doesn't have stable
   ownership. That would result in very poor performance. And there
   are other problems like priority inversion and device rotation.
   These are described in more detail in the swap tier series [1].

2) The plist itself requires plist_requeue() to rotate devices for
   round-robin, which needs swap_avail_lock held. Allocators must
   cycle: lock -> pick -> unlock -> allocate -> lock -> rotate. All
   CPUs contend on the same global list head, and the design is
   neither flexible nor robust.

3) Rotation is considered the slow path. The fast / slow path design to
   avoid touching the plist has caused workarounds like commit
   9fb749cd15078 ("mm, swap: do not perform synchronous discard during
   allocation"), we can't stably grab an actual device before touching
   the plist, so the design is suboptimal and has many constraints.

4) We don't have a clear rule of how rotation works. The round-robin
   rotation is strongly bundled to the cluster allocation algorithm,
   and cluster drain is unpredictable. We will have a roughly 2M
   rotation block size but that varies from time to time.

This series gets rid of all these issues step by step:

Patches 1-4: Cleanups and infrastructure
Patches 5-7: Lock and accounting consolidation
Patch 8: Revert the global percpu cluster by YoungJun
Patch 9: This is the core change: percpu reader swap queue
Patch 10: Remove the old swap_avail_head plist (no longer needed)
Patch 11: Drop the global sync discard workaround
Patches 12-13: Drop plist entirely

The design is described in Patch 9. In general, devices of the same
priority are arranged in the same static ring. The ring itself is mostly
read only, but each CPU's reader of the ring rotates, with a counter
built into each reader. The counter is adjustable and controls the
rotation pace. The priority ring design should fit well with the current
tiering design.

The performance is looking on par with the old global cluster cache
design, while it enables more potential features like weighted
interleave or adjustable shard value for device rotation of same
priority (by simply adjusting the counter value, SWAP_ROUND_ROBIN_QUOTA).

Testing with 8 ZRAM devices, running a typical build linux kernel test,
with make -j96 in a 2G memcg (Using 8 ZRAM, might not be a very common
setup but there are such configs to avoid lock contention inside each
ZRAM device, and this also simulates having multiple high speed block
devices as SWAP), measure average system time for 12 testruns:

Before:          6633.09s
After patch  8: 12294.74s (Move the global cluster cache back to device scope)
After patch 13:  6551.27s (Introduce the percpu queue to avoid device contention)

And doing the workload in a 3G memcg, avg sys time of 12 testrun:

Before:          3312.63s
After patch  8:  6450.35s
After patch 13:  3311.38s

Using 12 brd, testing with: usemem --init-time -O -y -x -n 32 1536M
Before:         4347.58 MB/s
After patch  8: 2773.39 MB/s
After patch 13: 4345.04 MB/s

Patch 8 removed the global percpu cluster cache, so we are touching the
plist before accessing the cache, and it's very clear that the performance
is really bad. Then with the new percpu reader queue design, we got rid
of the plist, performance is on-par or better, while there is no more
slow / fast path design, and cache stays inside each device. We can
always select a device based on priority before accessing the cache.

And the shard size is adjustable through SWAP_ROUND_ROBIN_QUOTA which is
hardcoded for now to 2M, changing that effect the performance in
different ways too.

And the distributions are fair among devices during the test (similiar
with brd):

NAME       TYPE      SIZE   USED PRIO
/dev/zram0 partition   8G 692.4M   -1
/dev/zram1 partition   8G 693.2M   -1
/dev/zram2 partition   8G 694.9M   -1
/dev/zram3 partition   8G 694.1M   -1
/dev/zram4 partition   8G 695.5M   -1
/dev/zram5 partition   8G 695.1M   -1
/dev/zram6 partition   8G 694.3M   -1
/dev/zram7 partition   8G 693.6M   -1

This work was discussed several times on the mailing list [2] and
rebased and reworked to leave room for future tiering, optimization,
e.g. by assigning separate iterators per priority ring.

One patch from YoungJun is included as well [3].

Link: https://lore.kernel.org/linux-mm/20260713025644.170839-1-youngjun.park@lge.com/ [1]
Link: https://lore.kernel.org/linux-mm/CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/20260126065242.1221862-5-youngjun.park@lge.com/ [3]

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (12):
      mm/swap: remove unused parameter for reading swap header
      mm/swap: slightly cleanup the code for hibernation error handling
      mm/swap: cleanup and document swap device availability flag usage
      mm/swap: introduce swap device iteration helper
      mm/swap: change the swapon lock into a percpu rwsem
      mm/swap: remove swapon mutex and update proc reader
      mm/swap: consolidate swap inuse accounting helpers
      mm/swap: add priority queue for swap device allocation
      mm/swap: remove available list
      mm/swap: perform sync discard on single device more proactively
      mm/swap: drop swap active plist
      lib/plist.c: remove requeue function

Youngjun Park (1):
      mm/swap: change back to use each swap device's percpu cluster

 include/linux/plist.h |    2 -
 include/linux/swap.h  |   42 +-
 lib/plist.c           |   64 ---
 mm/swap.h             |   12 +-
 mm/swapfile.c         | 1165 +++++++++++++++++++++++++++++--------------------
 5 files changed, 718 insertions(+), 567 deletions(-)
---
base-commit: bdc38bfc1262e3d1432afadd2aa2ffd83d139dbb
change-id: 20260529-swap-pcp-priq-68d3d925578c

Best regards,
--  
Kairui Song <kasong@tencent.com>



