Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CCAC61DF0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 03:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70FDC6B0088; Sun, 30 Aug 2026 23:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0CA6B008A; Sun, 30 Aug 2026 23:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6E36B008C; Sun, 30 Aug 2026 23:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 353CC6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 23:32:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1210B1603A0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:32:49 +0000 (UTC)
X-FDA: 85160142858.06.1CF3CDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 30161C0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:32:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qLMvd7cr;
	spf=pass (imf22.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788147167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uZbhmM3oXHp+jBIdSTpOmw10YpuieVCyF9nOk8yLmJ0=;
	b=M8MSe9t8eEtTqRNIxjiOrmqAh4N5zDb1P3QDZSz1C/0KK0b+ca1X682vlNtidqiSkMnBLo
	LbxyIyBg9oefiXTLD/IZK22tjOaRbX04DbZh+u0Nf5Gkx0hULnajPIjqpTqPcwGBqmmvOG
	4IL5TlDFx1AUO7u+vLkHfgl4S5Lw5dE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qLMvd7cr;
	spf=pass (imf22.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788147167;
	b=YdVTE3R8qCXCTjWGd7hGMnvwhPuL/nbxyiHvOeEmP8t3ATBytQc4FYDNXuM1GMl3YHxMK2
	/Fl2+5YzStxx7NwgRJZ3YY10V9v4HSzqsteXjQ7qze7JQT4WP8omttUSdcu5IxRGPGoFWr
	BxGGPchbLrWZCvc/u5Fx+uPeqCAMhyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D5FB6013A;
	Mon, 31 Aug 2026 03:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0C5DC2BCC7;
	Mon, 31 Aug 2026 03:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788147166;
	bh=z8L+pV/hH2yzx87WKF0Uixgwy89GfPxkJ+wXv8SsqmY=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=qLMvd7cre985k+4NvgElFw9zA5qTUZ3gJ7OOxBpQzN79J8OqUhnwaMTAGQT+i1ZeK
	 q8mm+1oPOmHuy0UAFXpnv2SQQ7KCTZ7/toc6iyf25q+kgaTV/oR5MG2udV8wz1N0Ys
	 MASAPJYS4Y+umr5x3VKTE+OBRR7025TiZXNMLyHY0GreB1lt2Ebvt2RjF8DEyOeMim
	 +6qv7ywNf+PviTZEb16OgjGYCGZ2IUf2CkrjM8FSezxAZG/TThVv4BIDWUGitd7EmU
	 dGt3k/8THQoy6gXffEGME5jtGYfDz08kjLD7r6e5UxKOMXQpZ1EHhJz1oYuLjU2VLF
	 9iFgLnaP1/mKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA745C61DF0;
	Mon, 31 Aug 2026 03:32:45 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 11:32:43 +0800
Subject: [PATCH] mm/memcg: clear folio memcg after changing per memcg stats
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com>
X-B4-Tracking: v=1; b=H4sIANr1lGoC/x2MQQqEQAwEvyI5G9ARRPzK4iHGHs1BVyaigvj3H
 fZYBVUPOZLBqS8eSjjN7btlqMuCdJFtBtuUmUIV2qoLHa9YdWa/ZFfRBeyHHM7Rbq5HIDaTNhJ
 Hyv2ekPX//Rne9we/XHqtawAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788147164; l=7052;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=DPpRbQF86jYJoz6ub5OV8sLTgDaDKPnnRudDq0rAReQ=;
 b=zdD0Y+JBfYx/Li1nXRK9QYFn2esdFWxR2b4tKB6Ehp1OZUhY7RVBNUJhFflzjvNUonSp1jdqU
 amyjT2ckU8pALozhOYwFSqG6RkdKQbYqJAxnHvwTbAKcGihbMDLjsmy
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Stat-Signature: f13tx1ap866ws94qcbj4f5ydjsh84axe
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 30161C0004
X-Rspam-User: 
X-HE-Tag: 1788147167-700427
X-HE-Meta: U2FsdGVkX18hXvEYHHDupvKgxuxxrxtUdpGLXHJs9XGC2KY02d59vpzLpf9sQcrAxNJsVEj9yxaEotem0vclV5nIhP7F2e659aJK/suI8LjuIObOtZJEIDfJkZUCSrw6Ow6p4xzJ2gJnMxQKwJVh+0r1mO/FkW02zMFtyTW2Ikl5NT0irfmOek1ZOLpdrZBeST7+Odn37YXRjznK6XYeJ5DuVYkyxVmZZb72V7kO3yQeDLAQvNxh0FOO1qVnyyyG7gRdd6rmWdTmzCLCrCDoleh3mNEo/c6gbi8sccAMnBeNMUc4slR7FxMpvr7Yr2LrHu6o5Q3j287mUX8t3CEYjNUpqIfRJtRrhZldoo5rYV0ZDr3Cwhbqw7EJ8IeGjtgEVAtIwjLnJYFvdO6QpzNLEm+AXf9l1D/gkgDXp7NHWzhPmqUk8Oq+9t8opz4XmUfaLxz6CV/7wrS1mrJw7hib7MuY+ql4sb+4HJLEjPP61K2QFbPMfOvEI7PLIOZmRAH0J4J6jIhtLLykHUC0Y+9FE5k+Kfj3SlCepT8/WDC0RDmm93gSSIgxxOjH3C1J2alBxV12iIvw7eiAar5r8iIH8fjC+KM/NUiXdU3mGfw3r0aUNWhw3dqLyTM/36Irbjq/GixQfjByGQ9Tgmla5EGwdAhc/Iy/Ch2i27bBWGdauphfozL8a3wG8eycHixm86vxlo53XlTSdaZI1lVrGOuNsYptawiGx3zSHe/ZEMoLMqnA2rP0GK1+9j2G9CYBFK4rtx5/NQTAIovYKY8IwmR2yF4K6XsksiVuEyCwHTEGBGBIBG1IrU+3glYwpMToqI7et/UKy9QuUigYwx4Cyh2/JbIQ1+u5aFuRaLuAXkQYYodfUUdYg+hsbysHirLo5f33+d+O57Hup8RL/HT/N9Hv7YnFZNNEXGxJumUzm8SMzFPJKAC6t8HJeBHhp9+kCOmW6W2u3LU+Rsy6DDLoYqd
 EAdMxijI
 WfaYxe55GTaIQcXxOERN9aIXZwnndNkCvpuy6XAjmerWJi/pv/AM3ja1LlmblFuU/au1FhPd+keMOqcUY0aZEt6UD5k/A0cieHd7Ezo4xynSMRyCjrITMuL5v8HcnyJovSFy6gqX2OkZi9L39NEsmZt275Xew/kYh1mf3EQ8ClcD+vHf8jenIXJvgcLThIaaRC1XE93+/VuMUcSPgyCK+Sd5iaKQF8uV+HVgX0+O9kB3vAvBD4Bs52XUIf+qoFdUcRqiXvhkHggOB6yXpswNUiDeN0sguMYpd5CCTFKl5FWKw5tnG70J2CnJ2as3bd+T7U9RYuXY384W32GTwZvlteL1Wi0+8IshTMfk8E8ebR92rsbIF2tuXca2bUyWkGc+VVzgCYevev3i5nCYpO/bTNtzCY+tRTB68qFW4bdUw/A0Vy7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

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
 mm/swap.h       |  3 ++-
 mm/swap_state.c | 10 +++++++---
 mm/vmscan.c     |  3 +--
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 90a551a88df63..c5a49b0ed3430 100644
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
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index f3961fdd857dc..825e623b03d16 100644
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
index f11491ee9ed5c..17ab01693ae8d 100644
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
base-commit: 42d64d4fef83a241c919c8693fdf0a21b2cb6061
change-id: 20260828-memcg-swapcache-stats-fix-1beef3dc3afb

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



