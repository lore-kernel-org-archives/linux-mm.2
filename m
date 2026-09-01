Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AF7C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0905F6B00C3; Tue,  1 Sep 2026 02:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0682F6B00C4; Tue,  1 Sep 2026 02:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98966B00C5; Tue,  1 Sep 2026 02:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4EE06B00C3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:49:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A358A80382
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:49:28 +0000 (UTC)
X-FDA: 85164267216.11.9202C4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id AC27F20004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:49:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OAGkSyH/";
	spf=pass (imf31.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245366;
	b=uNdX0JTGmw54GxNbyCq/24qsO3BIo3LEhaEMHRMa7R/LTjoCpsoAl8UbK5Wjs/AqvqziE1
	UktyEvqBC2GoM7zyZAYXbinnd75aCPwd8kIbpsm0iQCOCyhibCjDJgYVDsOR2bg05GaD9U
	40BQYd/BvidoEw+iYR2b/MornvA+nos=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OAGkSyH/";
	spf=pass (imf31.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245366;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zvS/be+64uMxEyOrOskhmjq8ojsYfk3FUYvLappCTi0=;
	b=p3M42GUmmdmQ2oh3onIpJQ2MDiKPs+++dMqPu5cjnpZOlCO/rKtYJU/SPgHWwhNOAiYbYb
	v066nLIK8VXGKCJmBrNq1t/ZD8ai1/7LbVTpKANnr0Az9FLE2x9TYAm8YBSZUlp1udAeFF
	IRTtcimOsgRI3vteuNh/Wlyt865nOK8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BB2040D74;
	Tue,  1 Sep 2026 06:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F080FC2BCF5;
	Tue,  1 Sep 2026 06:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788245365;
	bh=jQ0/pgiELTyKSv5BNA3IsrLBQ9kpwm2mvn3Md2YSgV8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=OAGkSyH/cHcRpa/rxlmPqLpBtqva002/BA2z/BEBxHKu3mkQO2g+ram0jL0aYLC3R
	 yeH+q5BnvPF3r0lJFKqxWtgQSn5DBnOLcIYvjBGxTi3Ldluyt4NDGPLoj5q0VV8k3D
	 4/03WIChjiro5qru6g/IQvmAs3a8Yaw3FEmdCeTvvf3ArZQoP6jZjYBfh66RNlATbX
	 Pxia50VPsp6YGcXEIyvCcuqlVjJ/vdOzY7OkcBt0i/TbM8SaXF4+qNk0oBYpocMXVt
	 Dcx/EFqbFihcNn1xLPxgSVyNXwLkF7PT4pQt+AHifNviDzFAZqIFZBiWvCwoD8qgi+
	 X6joIf2GGBwyQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F87C61DD3;
	Tue,  1 Sep 2026 06:49:24 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 14:49:11 +0800
Subject: [PATCH v2] mm/memcg: clear folio memcg after changing per memcg
 stats
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com>
X-B4-Tracking: v=1; b=H4sIAGZ1lmoC/32NwQqDMBBEf0X23C0mgqQ99T+Kh2RdNQejZENsE
 f+9qfRc5vQG5s0OwtGzwL3aIXL24pdQQF8qoMmGkdH3hUHXuq2NNjjzTCPKZleyNDFKsklw8C9
 Ujnloemrs4KDs18ilPt3PrvDkJS3xfV5l9W1/1kb9sWaFJVQbdWPXO9M+EgfikK60zNAdx/EBV
 /EG3cQAAAA=
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788245363; l=7992;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=4FztJIrokZHGN2SlXXzmWENVmLBTnEVTBI5yiE1+1VQ=;
 b=DiK5n7qAly2OitjlWEKUNrJhfm6FISgJap/2n5ed6BgAJEOSzjG6/k8IEIZJjx/oAnldr5O4V
 x50SbV7azrsAjXMbu4PFAlC5dzGpjQKLAuHd1zd5krNpG+4lwBUsy2h
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Stat-Signature: xnc1dgypxjn54bwhutqewabusa76sycx
X-Rspamd-Queue-Id: AC27F20004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788245366-605677
X-HE-Meta: U2FsdGVkX19Zf406pMq+I5aR4/uopoW2Ino/Sv9TKxhCTop/UMFRuXmjpfb7Sh4ZHEMa2zO4SVWwmSrfnmPZeoFDo9DBrZ0yu7yAXaETdET/1A+lykD+i1fVz7ktDwWS2tpyh1XIuKxEuPBcdP6SYH+2aqmyv8ZTcgGBd35ODDMfMbMp13PBa1twpKD2BiSyKchMH65DkEr7sD5Q5Ukyvn1OhW9Z1YcWQfYJBG1hTnPEab8SkkZ02F80FSHuEt5GNQ/UxA+7yNALU7e/EZl2po7zE35AoiNn+AMzlHtGVe/NL8JGd5gKVQl1aj+cCDOUEA7zJ3gnPhtJz+vz+uC569og0+QB86yr4QTQs72pGASPjafMHb9sRmY7IiT7hyT5VGfJCLbcZSJlGoxQB6vdd3H23aX3RYLWE/+6uGpQPkHs4mLzqILwFj4UXTfLhJejDf1QPDuIxDBcu/iC+NZrMKMg5Gw92H2MOSIwXq1E8knKHaM2CtDwt4dcg5YuKHkIiH4cSu7FZEnRaCFsCrhvf5auAiU4r5Zow89T+KVzaWFGrn6CNfFvKwddHkzSyBUsaRQ7zfaag9O8JYHA+1SL7mR1eKavAZXjGqNJ8sKIv5omxIkYrEo4njjjRrqBkgwgUfkbz2sYT4xfRbY7NvT8OKyu65WIIyXbKREpPpRJXusMvXktOKn8iirvv/qyPiQ9W83hA0oaIccTo5oJT/ACDIpNWiZhtcL+EkK4jpQsIBdyS7RNfkQA5Ro78r+Yb/zFg2jm/nWUtnj4ncGm3WZ7Jq9i3d81GJ1zBQVjICf/T5R99sYanLEF5NEL+oXK/twNjiJ4cvzjnGNXn+tAzovhXw2t9H8WCtWVrHlErVZvMX1MK0yfrYrRUoECFSbr6KGe1bgFFFWEtNRNKh8QF8iu5fE7LCmq/Bw5UuYQFVagKfBauDJM774VHBlbpXWvNfUTWhYfvy5CbJiZGJ0QwPG
 PAJAMBMG
 0g6j3lflRWQP49szT7Rx+eB7RoP166XbBcqgdzOxUT3B7ExSvN8e38qX0N2MYOdM8U/48YJcBb6R6PjrQ2+jsLQRMhCUzG7z/qBnWQYJUtSCZVUgkQR3oSjAhCXyBCjBwbdSLiUB1X2OehdkBaRn2dinXBwPjZOHJjGy2knghsQs1bWD0VXXXmRnLBRPycFQv/HvCPYqaBtsnlgDFhwc4b+1nqJKa7EM15cogPr7rLDaP1I61MxWrTZfW4NxQAJtQBFEqIBRUw1AXmQAp7KE7wiBOfBwEkOHbvKeV7iO3IhTeDFqmeCEFXor2ktMLzEfyR1R73rInh7FLsGB0P/u1xvf0rptJmwzVrx8F4ARzNqaVjnK4MXq9eaTAr2/hSAvlYXcL2kJDMjM6qvh8arh7DRz0sGodh2mak9D4KnoSisNSUCLEUAYYLNIgEoizHF5RlGiM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

I notice extremely high swapcached count in the per memcg level
memory.stat when running tests with cgroupv1 setup by swapping pages in
and out.  It seems that the counter never gets decreased so the value is
rather useless and confusing to users reading it. So I think fixing it
so that the value can reflect the actual swapcache usage correctly could
be helpful.

__memcg1_swapout() transfers the memsw charge of a folio to its swap
entry and clears folio->memcg_data as part of that.  In the vmscan
swapout path it runs before __swap_cache_del_folio(), which then
decrements the swapcache stats through lruvec_stat_mod_folio().  Since
folio->memcg_data has already been cleared, folio_memcg() returns NULL
and the NR_SWAPCACHE decrement only updates the node-level counter
instead of the memcg's lruvec, leaking the per-memcg swapcache count.

Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
the NR_FILE_PAGES and NR_SWAPCACHE updates but before
__swap_cache_do_del_folio() removes the folio from the swap cache.  This
keeps the stats attributed to the folio's memcg while still recording
the swap cgroup with a valid folio->swap.  Add a swapout parameter so
the plain swap_cache_del_folio() path is left unchanged.

Fixes: b197d41462c20 ("mm/memcg, swap: store cgroup id in cluster table directly")
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
The problem is reproducible using the following script and program:

```
#!/bin/bash
set -e

CG=/sys/fs/cgroup/memory/swapcache-leak-test
SIZE=$((256 * 1024 * 1024))   # 256 MiB of anon memory

[ "$(id -u)" -eq 0 ] || { echo "must run as root"; exit 1; }
grep -q . /proc/swaps <<<"$(tail -n +2 /proc/swaps)" || { echo "no swap active; run: swapon <dev>"; exit 1; }

cleanup() { rmdir "$CG" 2>/dev/null || true; }
trap cleanup EXIT

cc -O2 swapout.c -o swapout

mkdir -p "$CG"
echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true

echo "== before reclaim =="
grep -E '^(swapcached|anon) ' "$CG/memory.stat"

# Put ourselves in the cgroup, allocate & touch anon memory, then wait to be reclaimed.
(
        echo $BASHPID > "$CG/cgroup.procs"
        # Allocate and dirty SIZE bytes of anonymous memory.
        ./swapout
) &
WORKER=$!
sleep 2

echo "== after reclaim (swap cache should drain to ~0) =="
grep -E '^(swapcached|anon) ' "$CG/memory.stat"

SWAPCACHED=$(awk '/^swapcached /{print $2}' "$CG/memory.stat")
echo
if [ "$SWAPCACHED" -gt $((1024 * 1024)) ]; then
        echo "LEAK DETECTED: swapcached = $SWAPCACHED bytes (expected ~0)  [BUGGY kernel]"
        RC=1
else
        echo "OK: swapcached = $SWAPCACHED bytes  [FIXED kernel]"
        RC=0
fi

kill "$WORKER" 2>/dev/null || true
wait "$WORKER" 2>/dev/null || true
exit $RC
```

swapout.c:
```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

int main(int argc, char **argv)
{
        size_t mib = (argc > 1) ? strtoul(argv[1], NULL, 10) : 256;
        size_t size = mib * 1024UL * 1024UL;
        long page = sysconf(_SC_PAGESIZE);
        char *buf;
        size_t i;

        buf = mmap(NULL, size, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (buf == MAP_FAILED) {
                perror("mmap");
                return 1;
        }

        /* Fault in and dirty every page so it becomes reclaimable anon. */
        for (i = 0; i < size; i += page)
                buf[i] = 1;

        printf("allocated and dirtied %zu MiB, paging out...\n", mib);

        /* Force the whole range out to swap. */
        if (madvise(buf, size, MADV_PAGEOUT)) {
                perror("madvise(MADV_PAGEOUT)");
                return 1;
        }

        /* Give reclaim a moment, then stay alive so the cgroup can be inspected. */
        printf("paged out; sleeping so memory.stat can be read. pid=%d\n", getpid());
        sleep(30);

        munmap(buf, size);
        return 0;
}
```

Test result:

before:
```
== before reclaim ==
swapcached 0
allocated and dirtied 256 MiB, paging out...
paged out; sleeping so memory.stat can be read. pid=4778
== after reclaim (swap cache should drain to ~0) ==
swapcached 268435456

LEAK DETECTED: swapcached = 268435456 bytes (expected ~0)  [BUGGY kernel]
```

after the patch:
```
== before reclaim ==
swapcached 0
allocated and dirtied 256 MiB, paging out...
paged out; sleeping so memory.stat can be read. pid=2601
== after reclaim (swap cache should drain to ~0) ==
swapcached 0

OK: swapcached = 0 bytes  [FIXED kernel]
```
---
Changes in v2:
- Update the commit message to describe the problem in the beginnning.
- Change function declaration for !CONFIG_SWAP as well.
- Link to v1: https://lore.kernel.org/r/20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com
---
 mm/swap.h       |  6 ++++--
 mm/swap_state.c | 10 +++++++---
 mm/vmscan.c     |  3 +--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 0b5d507739bcb..b3b54c28929a1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -319,7 +319,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
 void __swap_cache_del_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, swp_entry_t entry, void *shadow);
+			    struct folio *folio, swp_entry_t entry, void *shadow,
+			    bool swapout);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
 
@@ -452,7 +453,8 @@ static inline void swap_cache_del_folio(struct folio *folio)
 }
 
 static inline void __swap_cache_del_folio(struct swap_cluster_info *ci,
-		struct folio *folio, swp_entry_t entry, void *shadow)
+		struct folio *folio, swp_entry_t entry, void *shadow,
+		bool swapout)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 305877e1f4d7b..9e0684166b78a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -314,13 +314,17 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
  * using the index of @entry, and lock the cluster that holds the entries.
  */
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
-			    swp_entry_t entry, void *shadow)
+			    swp_entry_t entry, void *shadow, bool swapout)
 {
 	unsigned long nr_pages = folio_nr_pages(folio);
 
-	__swap_cache_do_del_folio(ci, folio, entry, shadow);
 	node_stat_mod_folio(folio, NR_FILE_PAGES, -nr_pages);
 	lruvec_stat_mod_folio(folio, NR_SWAPCACHE, -nr_pages);
+
+	if (swapout)
+		__memcg1_swapout(folio, ci);
+
+	__swap_cache_do_del_folio(ci, folio, entry, shadow);
 }
 
 /**
@@ -339,7 +343,7 @@ void swap_cache_del_folio(struct folio *folio)
 	swp_entry_t entry = folio->swap;
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	__swap_cache_del_folio(ci, folio, entry, NULL);
+	__swap_cache_del_folio(ci, folio, entry, NULL, false);
 	swap_cluster_unlock(ci);
 
 	folio_ref_sub(folio, folio_nr_pages(folio));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b4c9b8f3dfe99..af7dfa905cb50 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -735,8 +735,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__memcg1_swapout(folio, ci);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
+		__swap_cache_del_folio(ci, folio, swap, shadow, true);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);

---
base-commit: 88297631d4d42f6004cb39c0ba3da7d2d10a616f
change-id: 20260828-memcg-swapcache-stats-fix-1beef3dc3afb

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



