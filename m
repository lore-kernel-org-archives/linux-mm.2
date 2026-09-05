Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD74DC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 19:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3806B008A; Sat,  5 Sep 2026 15:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9BE6B008C; Sat,  5 Sep 2026 15:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0016B0092; Sat,  5 Sep 2026 15:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 361666B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 15:31:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD798C0394
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:31:43 +0000 (UTC)
X-FDA: 85180703286.16.3B13471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id ABB5C40004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 19:31:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NKcCVNmX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788636701;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X3mOtorvzYwh7E7HNJfxA59JdcxmzIv9nXs97vBVwy0=;
	b=5Qbb+1PnXFTJRioud26sxYOISRcoRCKbTwtR0tqni1ooPoQT2kHd/b4jbiSXiEOO+Dw7ul
	adXuFPPHSRLR6VHqKetHiFPy60Vftf2DvXBf0DVr8551/wV2jgvxnaS2Bk3Hw0CKWu7AjQ
	CYVALF5OfhrwR5RhQV+SFcq9zNZbXa4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NKcCVNmX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788636701;
	b=HiI/02HqAXrald3+3IMAHtF8hoFpf9sCHDFtpPkx/eUopI/ldQpYeBSj3dNBEqVGkr27pi
	5aBAtlZbCphz/C1GyssKc4dQ8QT6y+F9a9K/XSJG2rYznKk5cSFLt6E+5vl5sWpfz2UFWa
	pyNSbfdo0eaEktq1SLEqTj5zuV3yeeg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9761143A74;
	Sat,  5 Sep 2026 19:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D4D9C2BCB3;
	Sat,  5 Sep 2026 19:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788636700;
	bh=81ogLEBruLFWfZs9XspWOevupF1WL2eVGLRg8ByszV0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=NKcCVNmXKmPrgCIDyAlYVabkdDUbalECKDbab6LUk1hy46eX4LK5nfGulq1TqegTN
	 6ipYMkaIw68q50GBsSt28iwRGm9ESGtzuwUW7l1BAWd4jUNCQZKerevUqm2cv5P6c0
	 Mw3hxCn1wX082JGY0uUt4cncCrfkJbrCqLedOl2MzKndlVNzJITiOvUR7e7EWk7uLM
	 zXs8KSXz5mi9EiuluzKzPzZh+ZQpA/p1S+joTsLT9G3a1TrIQx7e4ekjok2Iprj7UU
	 UyT/1iAOrlmiMzLiSDB/AFP5+/lPELS5SetPvVN8Hf6Cm8UizzWS8EDcvryClNjbeA
	 FFDtBnOjLyG9g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E58C79F8B;
	Sat,  5 Sep 2026 19:31:40 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Sat, 05 Sep 2026 19:31:04 +0000
Subject: [PATCH v4] mm/memcg: clear folio memcg after changing per memcg
 stats
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260905-memcg-swapcache-stats-fix-v4-1-d3626d305d4f@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33NywrCMBAF0F+RrI3k0dTGlf8hLpLJpM2iD5JQF
 em/G0VQFMqs7oV75k4SxoCJHDZ3EnEOKYxDCdV2Q6AzQ4s0uJKJYKJmjWhojz20NF3MBAY6pCm
 bnKgPV8otopcOpPGWlP0UsdQv+3QuuQspj/H2ejXzZ/tWJV9RZ07LAWu4RutsUx8zDoBD3sHYk
 6c7i4+l2aoliqXBGCclq5S2/5b8tsSaJYu118orVynl9z/WsiwPu/02W1wBAAA=
X-Change-ID: 20260828-memcg-swapcache-stats-fix-1beef3dc3afb
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
 stable@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788636698; l=8951;
 i=bingfangguo@tencent.com; s=20260905; h=from:subject:message-id;
 bh=DIpah5Yww/+rqsuzrwiWNQ5MGJz3CjI/NOy+g9af3+g=;
 b=N5a8+npxnrKNoEA/KwCjmvCf7Mb0YkYF1HiU8MOq3f11phm3y9GTdVBp+KhU0LYbYOFwPmVOw
 fS7PzHv12D/CChOWVjFxD+rr6TqT/nPfpHScEbviB2sCzq6BwcnxIOF
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=7YoBtD5pTW/XZHfmJ9x+FaHVq1TstMOvF31LTY3F+0w=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260905 with
 auth_id=1006
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABB5C40004
X-Stat-Signature: ydr47nof714hi9wmhi5iz38wycpbawm8
X-Rspam-User: 
X-HE-Tag: 1788636701-90831
X-HE-Meta: U2FsdGVkX18F3aPYKxSP70t6+Avx2A0XDIadGYZVZ3HoPZ0Stgb+mXTdSn13ZTqR/2oknojz6C7CQWzUyhMYA8v0aeLmj0pUW9d5IUQkoAe4gXcvdMtJl6NEc3aK/VUue/aFI3N/49/Lp9OD3kpMV9yBoUeTC9v6ZwPXsIrjXKX4tUWfmPmNUhOzss8zv8zQHKLksGRW5QtFVHlWvE2sXUdgEd7Bjc4bNkSGVmkblVYwr/WZxsaOm1fgFDfBcohoCxObja2FSHKh3DmInNMUtZKNLp0JUA3u4U6dEVd03RYggxPheEeB5sMVisXdvpbUdAba7DZKNOnyyrcwyNgr+2BKa73HqgvgftC7wJtB/EFJzFUTVoIatH2qcSSxeFxRMU8K0K9itxfL9mlIF56nRDfeUvWf8K1RWEfpglmEGDA6O9muFTom/HpDKNLvVadLPIXiSYRp31CmLIL4meHKrWEmjYz4PNJU4XjSpKmVMOqD7B5/8fKRPstj4L9iRyvSMJRWjrmmvddy2Hl5ehZqRtuIQJzrtMaUHfy7B2dAmZiRf5KdpNvqz/FoClLLlJXBAtUVhSQS63jDwvH7BdR0ztYoXDI1HcOAwQ9f1WHkj2lkhM1hNrkfOOro+PlOBpgU2o2Cbv4Up8yzHllo5P3dxflB7p6XvpMbdvowmoDGM/AGEdj9Xt57gw8y8R/u6f6mZXTiiCae5+c77IetM34ytF11I/F4zsHftgOFnOe2tcGXBas5imuVqQaT5p4AvEIfWyg6uDCD+6CZIvuTvEzzIFaLANSZz8z/Yj2US0zV1NAc+8SB5uIG049tphowlYrWdLhF6f8OklHCL0L9MJ7h9ZJkw6zl8FPgAT447M4NvcJEpkygNJzoXeZwSajqwq4DMaxyUSmARr1cfnET6KEpq2C269W9Y1OvMTnM7KRzZgFE4mqpwUXKS0xHMXe6wFqjAcuctWeSlS7m2yYxxT6
 MdTOcpUG
 RJOSewc8hl5Ol1nWqlc5p5SRa2Qe2dI+0g/SlclP4KuFR8s9rVI6bNpFk+UzoA7V/hiKOqIzSMm/Fbw+GejeG5673su3PBAR/QRzKHHy4l23Tid2zVfTgocTh7FVRsXM71U+rtAhoNvgtllZ55zBiG+p/6r0M1YsFNJiCKW/UGGRW9DQ1MKKKT0PQXdGhS7hAq1xn2mgadF5htuFPYJ5gtKYZgOBSjWuMSQLpm7jdXWrSAdj9kr5w8ur5IfjVDY4N4H/RQCESrfzH4NoAQ6Nuk0jzzAlivHDGaOR77U8MRgUkU8eMKrGK1NQfpgaCxubzBVLjNPfP3P7HyNvLrhX5MPIqh5nVs04NI666ZE3+w6QS8ZGrB6k7Jlq64lK2+sned5HUze7JZQNlW8+CfmGIZU3rstRe8LP+GVCEJYugJue6ZPZdhwnN+cdSWThZyy1YyB0y
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

Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize layer")
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
Changes in v4:
- Update and use the correct fixes tag. (Kairui)
- Briefly describe the context for @swapout param in the kdoc. (Kairui)
- Cc the stable list. (Kairui)
- Link to v3: https://lore.kernel.org/r/20260902-memcg-swapcache-stats-fix-v3-1-795f5d455f7b@tencent.com

Changes in v3:
- Add doc for the new parameter.
- Link to v2: https://lore.kernel.org/r/20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com

Changes in v2:
- Update the commit message to describe the problem in the beginnning.
- Change function declaration for !CONFIG_SWAP as well.
- Link to v1: https://lore.kernel.org/r/20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com
---
 mm/swap.h       |  6 ++++--
 mm/swap_state.c | 13 ++++++++++---
 mm/vmscan.c     |  3 +--
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 0b5d507739bc..b3b54c28929a 100644
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
index 305877e1f4d7..38916ea96ac5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -306,21 +306,28 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
  * @folio: The folio.
  * @entry: The first swap entry that the folio corresponds to.
  * @shadow: shadow value to be filled in the swap cache.
+ * @swapout: whether this operation swaps out the folio.
  *
  * Removes a folio from the swap cache and fills a shadow in place.
  * This won't put the folio's refcount. The caller has to do that.
  *
  * Context: Caller must ensure the folio is locked and in the swap cache
  * using the index of @entry, and lock the cluster that holds the entries.
+ * If @swapout is set, the folio should be in reclaim path and IRQs
+ * should be disabled.
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
@@ -339,7 +346,7 @@ void swap_cache_del_folio(struct folio *folio)
 	swp_entry_t entry = folio->swap;
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
-	__swap_cache_del_folio(ci, folio, entry, NULL);
+	__swap_cache_del_folio(ci, folio, entry, NULL, false);
 	swap_cluster_unlock(ci);
 
 	folio_ref_sub(folio, folio_nr_pages(folio));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 245f68c75b28..29bced43b0ce 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -755,8 +755,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 
 		if (reclaimed && !mapping_exiting(mapping))
 			shadow = workingset_eviction(folio, target_memcg);
-		__memcg1_swapout(folio, ci);
-		__swap_cache_del_folio(ci, folio, swap, shadow);
+		__swap_cache_del_folio(ci, folio, swap, shadow, true);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);

---
base-commit: b5529903123d9535bcf74386c1f4e185e8632dd9
change-id: 20260828-memcg-swapcache-stats-fix-1beef3dc3afb

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



