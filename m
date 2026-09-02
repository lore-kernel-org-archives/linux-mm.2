Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9C3C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249856B0088; Tue,  1 Sep 2026 22:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB5E6B008A; Tue,  1 Sep 2026 22:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5E56B008C; Tue,  1 Sep 2026 22:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C31066B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:06:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DA87A0695
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:06:59 +0000 (UTC)
X-FDA: 85167184158.13.DCE6112
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 54A5E20002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:06:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7w+hL4c;
	spf=pass (imf13.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788314817;
	b=Azukux/xoe/VH1nRu/3OVy1oZXYGPWzOxrOtyO+VajGQ/Hok/QpNytGyT0XV7vyTUTuQcW
	z7rzjRhHxAibd5/rFdLN9JhwBel5gomFEcskNfRaKb3SaSHFSKcBYIMwVusDVBatYWKIDK
	cRWOYN/C2a1kvdKX9Do5UmGZ/QVgb98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c7w+hL4c;
	spf=pass (imf13.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788314817;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J1JJ7wmygYc1d3vkS2FdVjeOWkfpe+02p5qo7IACeNU=;
	b=niG529z7Z90I/nM8qJoNvIDJUkCNqR5mr4kZXtXuicrLOvVyOpWQGUMqjiwHShadEvhf3o
	50o8x+e8dc5ZJlRA7PcXHsTGjSwmN5/o565XPG4w7jnJGgka6c0i8AxOyJt0KVZcbQiqWJ
	2IKdgdxxwOB0TUL/7b7+SPI4MOzhruk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77B7C600D9;
	Wed,  2 Sep 2026 02:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21A8CC2BCFA;
	Wed,  2 Sep 2026 02:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788314816;
	bh=W+UV8TiDB9hxCbUmT2Z+NnTHOSsKdjCuL9atiZ/pwTE=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=c7w+hL4crM7ahLXqISQQNg2oF7dv7MfiH0BjQg4I6dZc4a7X6l3apCW6x2C1srNR0
	 V96GCPjxMweYug1wmSo6OmqzcJCF5iWguiHSq2AUAptdEWEWYE5VaFCssINoNH8xrC
	 EE69A5SBp94UDyNCkGvq9WWA67Kr6az7c9MbdU9qcqwnbod5YYi5lzpf3HrZw2VcFn
	 m7c5eL6DDcGd8UjExzBlPFo+FZKKhONMO3Eqp5zureF5YTyUVGn7dTSy+0yqWYc4Nt
	 DX0R1TyzmSWG6487Jn1Jn/sKZUYxf8+KP7IumJAPUr+2An3iwnX3lZEflzS42p6sWx
	 06tLoA+LVEyQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3DEC624D0;
	Wed,  2 Sep 2026 02:06:55 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 10:06:46 +0800
Subject: [PATCH v3] mm/memcg: clear folio memcg after changing per memcg
 stats
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-memcg-swapcache-stats-fix-v3-1-795f5d455f7b@tencent.com>
X-B4-Tracking: v=1; b=H4sIALWEl2oC/33NTQrCMBAF4KtI1kbyoyVx5T3ERTKZtlk0LUmIS
 undTYsgbsqs3oP3zUwSRo+JXA8ziVh88mOoQR4PBHoTOqTe1UwEEw1TQtEBB+hoepoJDPRIUzY
 50da/KLeIrXQgTWtJ3U8Ra73Z90fNvU95jO/tVeFr+1Ul31ELp/WAKa7ROquaW8YAGPIJxoGsb
 hE/S7NdS1RLgzFOSna+aPtvLcvyARjIpw8QAQAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788314815; l=8591;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=2wL0CIVj+NumZ4jS21cH6aQlJclRk7X+OAm/clFB4c8=;
 b=fcHvD8Ml1Jpyd2jCE8ru20/mr66E0sgeh97kx0WqWyL3elbRz4LPQfUYPousj2Yc44IpoNrGC
 PBf/irpcQR3AAqRw4MxgkGay3OVc2OiZIytxK0zwy5z5Arco2INWCYq
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54A5E20002
X-Stat-Signature: mpx6j9umz99q5bkib3sktbqc7ybjb4kk
X-HE-Tag: 1788314817-420695
X-HE-Meta: U2FsdGVkX1+wWf+IT/ImcDXWyCd4NUKIwcqKo4XbPpuFrOmXRg3A4KiY/dxk8b0nnKhHDAHU+8ufaLkhj5k3UnuAvCK7yF0C/90ETIObYctIoGEiLrpAADFq5JGKVbAKfIzX9qA81umH0Ya3WdrkDeqENSftPDShV/Rs0A3pHonKmaGEu0DoYBGmheW2Pubv+i7Z922yiK32T7l/2hjqpheEMi8LSria2vUOvUD8My5JRArKTsEh9qzby2XIgRw+iKIAYH2z04T/IhgvDi0cuR1QHSMWoQKCGhH0LtgmP/jOLubYpIqOWSI0mCS8gS95ImPheRFsiRbuq5wxCUHG8hvkZIJy2Yg1eZhU6L1S9nxDuFiYJT0DNgi57zUk2Xd8xndqb2exYTcK9AwyjMzCJ9eQ3tYHsTSi3ao2wPpTSLyKev/lodej6cD86gHg18FsqoEqBOmyhf4g8FiEs7l/t0NDkyAHfL43ppi+9BOch1vJTkihy270Dh6GLw3uazCv8cNvfkdPxVrSxOCS+o+8VQvpSg+PL8/N1AP6dTWc5GEeMl4VzqjYw+bgHs1CriDYPTJh7QaxPtFaUqWVCFat0c21lFa83EJr85DsBL+hvcaVkzc6YIzaR4O8zX0kakLzBMOnlXhNLBN6q5Ua/in0JpRtRE8opZNJ2S6IeRLjrWEvzlNhd4oSBl63f+Ewtgo+Rux9ARYwXlYeuauBji6NL5KjC5SE8VXu/xsN1+xbrRqaSU3Slx6iE/BLxZoIOTFZvw0tVyo4aVQjcsPvWopTfE2YzPg7KUUWQ9JS0nVhnPyBbHWQNAbSMJ9yShL0w9503/QZ3mtmV8vnq3EL94mq4TtaZGSCw4ftFOJ8XKKs8XG6DEGkah3+lJI9sbLwYPvUGlfZjAtI8A/2EB2qwFaK1dn8Q8vRvlheFmYl317wE/ih+r14rAOKU8qeaSSXcCdwjCutkM9u4bmBAX1u2LX
 oU5uA5yv
 YDHFz0JY5ZnIo+f37sjnyfnu6C26nD90D5q1nLExI8k2rUflDimVGPPoN3XUQ4xWbFAkEGL7X2MJlipOXxppWlVJk/PsscRzT6dHXzhCNgkwDtwtTYR/AXcBcimEJVFkY7WbQrozAelI+SLxHQI6ynDgSuVbJ5+2GfFaAVWpKtkQd2VADQMS1VjeIp4+xkQdX7IrVlU3DmEwckmT1ZFm9lPzkibvjBki3uPqlz06q4rDd/3mo7/cHwxW9Qry/NXhi0gKFoVodJue2kEnE+Y+ANhdsY4TvKIKUcwdRSGKwDSs4s4ABj2JzQ2TXGyzpQolHkg8HkN6rJZfmSsIgNsgN7FbEdR4Rf+KFk+uK5+nYzsH/Do87qU38MJY8SfmJjxVTq16rHkI9mN4KwKoEb9SGriVhJp8NQTOpoRwXtOicQW+KHP2uL1LiiN1XRT7xNNVJBzbD
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
Changes in v3:
- Add doc for the new parameter.
- Link to v2: https://lore.kernel.org/r/20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com

Changes in v2:
- Update the commit message to describe the problem in the beginnning.
- Change function declaration for !CONFIG_SWAP as well.
- Link to v1: https://lore.kernel.org/r/20260831-memcg-swapcache-stats-fix-v1-1-1c0819ebdb86@tencent.com
---
 mm/swap.h       |  6 ++++--
 mm/swap_state.c | 11 ++++++++---
 mm/vmscan.c     |  3 +--
 3 files changed, 13 insertions(+), 7 deletions(-)

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
index 305877e1f4d7b..99985208b529b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -306,6 +306,7 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
  * @folio: The folio.
  * @entry: The first swap entry that the folio corresponds to.
  * @shadow: shadow value to be filled in the swap cache.
+ * @swapout: whether this operation swaps out the folio.
  *
  * Removes a folio from the swap cache and fills a shadow in place.
  * This won't put the folio's refcount. The caller has to do that.
@@ -314,13 +315,17 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
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
@@ -339,7 +344,7 @@ void swap_cache_del_folio(struct folio *folio)
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



