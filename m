Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA5CC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1B06B0088; Sun, 20 Sep 2026 03:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2AE6B008A; Sun, 20 Sep 2026 03:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD736B008C; Sun, 20 Sep 2026 03:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C85B16B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:20:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AAB4C03E6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:20:54 +0000 (UTC)
X-FDA: 85233293628.28.302E579
Received: from mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	by imf27.hostedemail.com (Postfix) with ESMTP id A896A40007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:20:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.59 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=OqjL95nMyuialByOyNXSThRjLAvOedelr3p9CRfNR7U=;
	b=phbDTMyzCBCDR2WrQdxCpABTiydeZ38SV203yqvNW+hjFeQKDNWd7ns3cHo7BlnHfnttL9
	DQ5IW7yeOY6no+kbfbRfv3Fol3+GQue1wl9Pkcky7TEpb1WRoAIhDHHCY6W4JASiiTNVOp
	7C9dcGtCaZ7BMpABTfBgvDUCQhAOJe4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888852;
	b=q6ruZkRLpvU/vQyM2dsWxD+kC1s9i87A/RnxJ0j1HI14ZLPp+4+X3WxCbHCIkRek5pRpDK
	CBE9eeGQZciM1TFUgZl72sTPHsdvdCZrQRlp2qABKEtvj2/zBc14b61KRHSt6Aua2SJcfu
	OdL49WHYXzeefXWJzmkf+WWxb68P22A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.59 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0911e82e2ae6aa55;
	Sun, 20 Sep 2026 07:20:49 +0000
X-Mizu-Trace-ID: 0911e82e2ae6aa55
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 00/17] mm, swap: xswap writeback to a physical backend
Date: Sun, 20 Sep 2026 15:20:26 +0800
Message-ID: <20260920072043.430390-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ye9kd7mognisrieeyyim8itsimxqfai7
X-Rspamd-Queue-Id: A896A40007
X-HE-Tag: 1789888851-186416
X-HE-Meta: U2FsdGVkX19TyokXiIyLbzO53K8BG9R5XfTZMydrxyN3DQrdh2O/Ekbqu6dpB4HpKP8W6EzHRSrnt/PvdlHnsq/5SLZFs4/NHGUDE78NpoyFWWmM8h9LcgUdD97vT/wmoE7O4AkDeeKnI2XJwbmlt5VVcwheGxW6YQu3jLpM1CoY5L2sxQZqNOVg6A/j4FLRxJTiGtDPR87x+iS4zjicJvMxVry+hVSlN0o4d8nhIJ7xkN4vHNGkDs/KBHEw5poZWiZSR/9QfXN2W1M9I12sX5zvxYHSylEF5aZDG2zyoLz3gKPkE1LpQMM0rrJkxk76dH4z3q3l98k4EhYAt7tpAgGN4xCRC+yxgXUh3eD36HVQT3yO66pJvXvw7OKbSixS1CnVcpnbkbXK/Dqmk8tlQS72aZuXXidJcfopNYH282cvndIYoQHGv9mS/+H/EqJ2u7bgrrNuBR4y7CkRCkBnj2Ji0CSTSegMXpcx28vv98Nf+GP3bHuF1ZaFJ4VJzlPrydqacJCqtmR87yYXrabJuqwS8Ou7aC6Jnn70f8cjaUes1balm3rjjGFVq/ucGkzbcppIJosw49wvrNtmcoWMH/WoysORrChllWwzFcrFkyk1SLj0Nrw8+WPRDJPFfzOPbsg+HbsPqa8Lb0DWA5Q8lQGRkG5+FEMboMOKacWxS70H3Mft49PFp/4RSAGdcujd8IEWNgJV8KOILI0o2p0I4aoxyPSUHlb6CYHZcaIjaMbWhyy9W71SZ2cJFgYhazQaDufSsu5R2cx84Av7bupubIleHVCQCSRls+BpM03QdvzvKkLkk4h5CXS00SGh7Eqmcir9Kaxp23rKHh2WI0GH1Za+4hcyBqtmXCmOEfSb3UTicvxGPs6chRjvXXd04XbellBjaYtMBLC3/Vry2bABTF4aSOt8Z+rI/kwQrQfjrTTdnmJykkwzSkZ4TNMwne+bO0mD/CgqiMDL4HAHp4b
 BPayJsZE
 sgVTSIXtnFIyXpFbK7W2vSukYrWhbKB/DWmqyhc/WP1LnlE0kvMPWVs1HRDTjzu4k/WimqpKkKvY5R7nwlMlPwUjKgNP4RZyu4xK7Zue4A2g0V4h4wIVURjfiPdicvp/u90GTYyipIgvWmZP5nxGaXNtyeuw19xmJwtvmkC2oPflmglc6np0Boy8pCC6nLDOB1hPs3nl3cXJ4lc7DQJIVhHGNtjSKE6B97KfZbcDWYDjukkL3qcwvj5LW6Z5Ri3aJB98KQK5PyFlXcOSUDSzyRZZFfDPFI5+XqR6XQ8Y4i97ON5QCvsUjaYLfW9YClTyMp1Lv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the writeback layer for xswap, on top of the base series. Post it
as RFC for discussion.

The base series keeps every swapped-out page in zswap. So the pool must
refuse new pages once it's full. This series gives an xswap slot a
backend to go, and charge it only when it really goes to real disk
space.

Design                                                                                                
------                                                                                                
- Backend: when zswap refuses a page, take a slot on the real swap                                    
  device with the highest priority and write the page there. One IO per                               
  slot.                                                                                               
- Ownership: that slot has no swap cache folio, so record its owner in                                
  the swap table entry. 0b100 in the low bits marks a backend slot, and                               
  the xswap type/offset go above. The physical side then does not treat                               
  it as free, and readahead skips it.                                                                 
- Per-slot record: ci->xs_table[], one unsigned long per slot, allocated                              
  the first time a cluster takes a backend. Zero means no backend.                                    
- Read: a written-out slot has no zswap copy, so swap_read_folio()                                    
  follows the pointer and reads from the backend.                                                     
- Release: verify the slot still points back to the xswap entry first;                                
  the record can go stale.                                                                            
- swapoff: try_to_unuse() used to skip these slots. It now reads them                                 
  back, marks the folio dirty so reclaim re-stores it in zswap, then                                  
  drops the backend.                                                                                  
- Reclaim: an xswap entry's count can reach 0 while its folio is still                                
  in the swap cache; the physical scanner reclaims the redundant slot                                 
  through __try_to_reclaim_swap().                                                                    
- Large folios: a read starts at the first physical slot, so the run is                               
  reserved whole and must be backed contiguously; otherwise the fault                                 
  retries at a smaller order. xswap is SWP_SYNCHRONOUS_IO, which also                                 
  skips readahead.                                                                                    
- Charging: Record the owner at allocation but do not charge. Take the
  charge when the entry gets a physical backend slot, and give it back
  with that slot.memory.swap.current then counts only real on-disk swap
  usage, and a cgroup with memory.swap.max at 0 can still swap out through
  zswap.

Note                                                                                                  
----                                                                                                  
The base series is sereis of xswap foundation. This one depends on it.
So if anyone wants to apply this patchset, the order is base-commit
as below, then xswap foundation, finally this patchset.

[PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
https://lore.kernel.org/all/20260916101929.149106-1-hebaoquan@kylinos.cn/T/#u

base-commit: baa8de2f3448d1466a888a805c18d01c998fe052

This partially refers to Nhat's vswap-v4 series. E.g patch 1 is
consistent with his patch 3, patch 12/13/14/15 are from his patch 8.

And the last 2 patches are fixing bugs when charging patches are added.
Since the charging of xswap is still under discussion, I dind't merge
them into commits. Will squash them or take them off once decision is
made.

Testing
-------
qemu KVM guest, 8G RAM.    
   
A 4G swap disk /dev/vdb is added as the physical backend, and zswap is
turned off so that every page has to reach a backend slot. Note that it
need create xswap device firstly then disable zswap, so every page has
to reach backend slot.

The workload is memhog, as in the base series. Every page is filled with
a fixed pattern, so the data can be checked after a readback.

  # echo 1 > /sys/module/zswap/parameters/enabled                                                     
  # echo 100 > /sys/kernel/mm/xswap/create                                                            
  # mkswap /dev/vdb && swapon -p 0 /dev/vdb                                                           
  # echo 0 > /sys/module/zswap/parameters/enabled                                                     
  # mkdir -p /sys/fs/cgroup/xswap_limit                                                               
  # echo max > /sys/fs/cgroup/xswap_limit/memory.swap.max                                             
  # MEMHOG_FILL=pattern numactl --cpunodebind=0 --membind=0 ./memhog

1. Swapout to the backend

   Run the workload with 5G of memory in a cgroup capped at 4G:

   # awk 'NR == 1 || $1 ~ /xswap|vdb/' /proc/swaps
   Filename                Type        Size      Used      Priority
   xswap0                  xswap       8155132   2392176   100
   /dev/vdb                partition   4194300   2392176   0

   The two Used values are equal, so the pages reached the backend and
   the xswap side accounted for them.

2. Pages are read back from the device

   Lifting memory.max and touching the pages again reads them back. The
   pages-swapped-in counter went up by 265642, so the read did reach the
   device. 1010 of the folios read back were 1M, each read with one IO:

   # echo max > /sys/fs/cgroup/xswap_limit/memory.max
   # cat /sys/kernel/mm/transparent_hugepage/hugepages-1024kB/stats/swpin
   1010

   hugepages-2048kB/stats/swpin stays at 0, because the swapin order is
   capped below the PMD order.

3. verifies data correctness

   After the readback the data is compared byte for byte against the
   pattern, one time with zswap on and one time with zswap off, so the
   pages come from zswap in one time and from the backend in the other
   time.  All bytes matched.

4. Destroying a device returns its backend slots

   The device was filled, then destroyed with no readback first:

   # awk '$1 == "/dev/vdb" { print $4 }' /proc/swaps
   3157220
   # echo 0 > /sys/kernel/mm/xswap/destroy
   # awk '$1 == "/dev/vdb" { print $4 }' /proc/swaps
   0

5. verifies the charge is correct

   An xswap entry is charged only when it holds a backend slot, so the
   two counters have to show the same number of pages:

   # echo $(( $(cat /sys/fs/cgroup/xswap_limit/memory.swap.current) / 4096 ))
   526852
   # awk '$1 == "/dev/vdb" { print $4 / 4 }' /proc/swaps
   526852

   Nothing is charged while the pages stay in zswap: with the pool holding
   them and the backend untouched, memory.swap.current stays 0.

6. A cgroup with no swap room can still reclaim its anon memory

   With memory.swap.max at 0 and no xswap device, the cgroup ran out of
   room and the workload was killed. With an xswap device and zswap on,
   it swapped out through zswap, was charged nothing, and was not killed.

   E.g if memory.swap.max is set at 100M, the cgroup will be killed when
   the cap was reached.

Baoquan He (12):
  mm, swap: tag a swap table entry with its owning xswap entry
  mm, swap: prepare the folio-less allocation path for xswap
  mm, swap: add a physical backend for xswap slots
  mm, swap: use the xswap physical backend
  mm, swap: fall back to disk when zswap refuses an xswap page
  mm, swap: support swapoff of an xswap physical backend
  mm, swap: reclaim physical slots backing cache-only xswap entries
  mm, swap: back a large xswap folio with a contiguous physical run
  mm, swap: enable THP swapin for xswap entries
  mm, swap: drop swap_folio_sector()
  mm, swap: do not retake the cluster lock when uncharging an xswap slot
  mm, swap: drop a refused xswap backend run directly

Nhat Pham (5):
  mm, swap: prepare the swap IO path for xswap backends
  mm, swap: split the swap memcg charge helpers
  mm, swap: do not charge zswap-backed xswap entries
  mm, swap: charge an xswap entry when it gets physical backing
  mm, swap: don't gate xswap on the physical swap free count

 .../admin-guide/cgroup-v1/memcg_test.rst      |   2 +-
 include/linux/memcontrol.h                    |   6 +
 include/linux/swap.h                          |  69 +-
 include/linux/swap_ops.h                      |   9 +-
 mm/memcontrol-v1.c                            |  10 +-
 mm/memcontrol.c                               | 147 ++--
 mm/memory.c                                   |   7 +-
 mm/page_io.c                                  |  95 ++-
 mm/swap.h                                     |  35 +-
 mm/swap_state.c                               |  12 +-
 mm/swap_table.h                               |  53 ++
 mm/swapfile.c                                 | 742 ++++++++++++++++--
 mm/zswap.c                                    |  20 +-
 13 files changed, 1026 insertions(+), 181 deletions(-)

-- 
2.54.0


