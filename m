Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27AE606A90F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF036B05BF; Mon,  2 Nov 2026 09:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6456B05C0; Mon,  2 Nov 2026 09:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B134C6B05C1; Mon,  2 Nov 2026 09:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBA96B05BF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:48:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 741CB40154
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:48:45 +0000 (UTC)
X-FDA: 85390460610.23.7BCACC8
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7922520004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:48:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630923;
	b=bP6dbSQUxf7eU0u+RzPKtsOOY1sL0lPiQ4EgeC1iew1xYQtpYs9X+xQraymVbsQwf20INg
	7KTUcLJKQkIbXnZ7+5jHhCNh8y4hkg3km5/3g9dcM1dfMgJxA1FaGPu+/KX8q5m756i2tf
	yLaryUkxTC06FGx0dB/KxxQ/66FO2+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=A7RZxz/I0QQefvJdIeMSwQGON5LaCpoKNCQaVHVvIWI=;
	b=KXWxCc0554Gz4fNDOKM4kUGsJVCIydowMPDSDt2JE+x9jxyyPOBFGTIvcO69/cpU8ZYJLT
	kXilGVMoJG9WcGXvIwHF9IahKpnW1OlEpx6e2BqvGU6jUOreakx/PaVhHvKtVWnDH5OsAE
	kwQ8L7lUBu51mJweyCUWCHO0v3UprFs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8350E3E9B1;
	Mon,  2 Nov 2026 14:48:37 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	ryncsn@gmail.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v4] mm: bypass swap readahead for zswap
Date: Mon,  2 Nov 2026 15:48:22 +0100
Message-ID: <20261102144835.304017-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: dmFkZTEn/q8sunT7bW5dEEtI0bfp6C6rTfBoIVEjxCEHyQnVAxmMTuOAIrObB44eZJeesNyl0ks30kY2r3pvGySGGWMBRmEb8tey4fqQ1BhOxB4/IWQ2PVyPcF/B4x1dRySUj8USOUS4u0LeF4R9bzqQxyhzOwE99ylh/ARU30lm15V8ItjadwcmrqDcK59bSiB5mXUKro/kYfjW5Fbcn/yRJ7SBOA+OOzJJ1QvbbO5V8eZVbCNFOdhuzzYVZXH5CRSe6w3RqyWcNpL8zF6HnvnUXlQfENTuyq95sUWZud37HmwNw0zcOSeSDXhPLe664qZc4N/1S4vtq2SLPzfGoFCoL38UfmgD+egBa5sBO/lNw5zufRTe4/J2CUF1zqOEluHxDvrS2eDY4UfsT0oMD4q3WjeHGn7iY302qL9P5jT50msHE8xJ/60J35VokfqMcmVMN1vxYmQg6a5Yv0JtMq7WoHnxX0ttQHR2DV7QDJi8NQ1y9Zk2E+W/WNs7GaFwdZPRTi34n3CzW2xPBhdUHYbjgbbvhHTyTWeeTA+1VrMvGFLtYuM8J6gsFna3H6R2QLcg/GzDuRy4OQv1EGoZ38PDp5ZmJatq3GoLzBxX1behhKpr2PhgkoSnaSobOKygz1tZfxIxydsEKeBAVtO/iKMPFpaQENgUSnM2kzwsSnjfYHhW5g
X-GND-State: clean
X-Stat-Signature: r88tzbrdnbhbjt1fkuc7s7e1kzz4gxcr
X-Rspamd-Queue-Id: 7922520004
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793630923-353521
X-HE-Meta: U2FsdGVkX18UtiUGydq8J8oBpaw/1LQnhFWzy86dIjmPvAg+rSbjO0h6SvGoItYpvQSVuDkDEad8qtma8KBS2H9/eufB5nm+YfUqAlR52g1ve6b7xDIu4yIrwCFnVfarIAMANPROonMgOkE0CI1J48kJPVZ9osfguXW9ROWoon82yAnXS9iGGRfLs5ZKcFmR+TqVy+IPi+vCqSMr2pZSrz4gV1k1U2g2LepktOfiIxUlQFT+CAwoJcFITtbwNidcDQu1Wj2wdIXG8sG/2BwGcXeCIdM7GNMzpuVB5PrNGUI0b0KExK9NUZ/qhI+ltKPplFtaEnrFNcHFzDDWizJY2XDxgxaktNataxKhC9uwu4qA7PsfE/6K8KjzauAVuHp/qa2uiWp00fC+OfsW8sH/HJNJ5bpdCokOHnuq5yO92JWYRT6dQjXcsuYtz8neSsFZF0t6VdHcfxHJ5gi1B1yQxV9HC38aGD2a3deArufBa7wFFLEib6Poj6SZso5q8rW+nmJK1JBI9hCIopwnkxdXfat9svy7JlAamY7482/JUq1QPxK+orZh3Wre5VRB5C7ZZzr7SzKZ3lnPbCzorBUWAj8PkeUPTLs6/n78NUZgwe/kP5OTHYVCpKnmSPmhtdPi4Rmr/WWoZheLLDrqu8iZrhDmWR+q7mwC39Wf8VxVAU4ULNm/MkY25sDxsn9g8xxMa/s7G/Q/yJIWuPnuFkYRsb3vcGs5lhcyFsTuCQpiLnDS2M0llZRNgj/6L78wK31gXXj6M8hKOQttwJfii8poWaKajp1jHHEs60Ce3p2JXVAnDeaV3v58fiU0NChjehe9WB2K8lthA+uQy17lC+7qH85sceHJeMXJPaihLSO7lsV4RcUYiSYomRVvwUZRe18VtNiDKKa7qim97Kn7eu2CLTTd82t/yLVl0q+0UyZi7dps2bj8iXYkyP6NWkSz1FAIc/8YeFQMl0/kt176zEK
 9iIWm+CM
 y1dFN0NGnRmuCu6gdNPSA/Qy6/3MZ+Pq6vcfrvYAe1eAgmBHnBPMV0Z1IUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.

zswap is the same kind of in-memory, synchronous backend as zram, not a
swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
swapin_readahead().

Here are the results from bypassing readahead for zswap too: it was
measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
off, on Sapphire Rapids and 3 iterations.

  768M memcg (sustained swap thrash):
    metric                 mm-new    + bypass    delta
    build time (s)          405.0       341.7    -15.6%
    zswap-in (GB)            79.5        53.0     -33%
    zswap-out (GB)          144.8       115.6     -20%
    swap readahead (pages)  6.79M       0.45M     -93%
    swap_ra hit (%)          72.1        89.9     +18pp

  1G memcg (light pressure, build not memory-bound):
    metric                 mm-new    + bypass    delta
    build time (s)          177.7       176.0    ~same (no regression)
    zswap-in (GB)            10.2         7.5     -26%
    zswap-out (GB)           27.7        25.1      -9%
    swap readahead (pages)  1.07M       0.08M     -93%
    swap_ra hit (%)          68.6        87.2     +19pp

Similar gains were observed on an AMD EPYC 7D13 host.

All the results above use the default page-cluster=3 and
vma_ra_enabled=true. Setting page-cluster to 0 gives the same gain on a
zswap-only system, but page-cluster is global: it also disables readahead
for the asynchronous swap backends that other tenants of the same host
may use.

The gain is from no longer prefetching pages that are pointless for an
in-memory backend: readahead inflates anon residency and thrashes the
page cache (file pages get evicted and re-read), lengthens each fault by
synchronously (de)compressing a cluster of neighbours, and adds
compression traffic when those extra pages are reclaimed.

Bypassing swap readahead for zswap therefore makes sense.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---
Changes in v4:
- Mention page-cluster in the changelog (Barry)
- Add Barry's Reviewed-by and Yosry's Acked-by
- Rebase on mm-new

Changes in v3:
- Go back to the RFC's single patch: readahead windows that mix zswap
  and disk entries will be dealt with later, the priority is to merge the
  zswap readahead bypass
- Move the check into a swap helper, swap_entry_synchronous(), instead
  of open-coding it in do_swap_page() (David)
- Bail out early when zswap was never enabled or the tree is empty, so
  disk-only systems pay a static branch (Kairui, Nhat)
- Reuse zswap_is_present() rather than adding zswap_present_test()
  (Yosry)
- Rebase on mm-new

Changes in v2:
- Keep readahead, but overlap the decompression of zswap neighbours with
  the disk I/O of the window, and bypass it when the target needs no
  disk I/O (Yosry, Nhat, Barry)

v3: https://lore.kernel.org/all/20261007153915.53429-1-alex@ghiti.fr/
v2: https://lore.kernel.org/all/20260722163536.773166-1-alex@ghiti.fr/
RFC: https://lore.kernel.org/all/20260624075700.751467-1-alex@ghiti.fr/

 include/linux/zswap.h |  6 ++++++
 mm/memory.c           |  4 ++--
 mm/swap.h             | 25 +++++++++++++++++++++++++
 mm/zswap.c            |  5 ++++-
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index df6cafbe95dc..94746fb71bb6 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_is_present(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/memory.c b/mm/memory.c
index 5aec0dbc17be..0c9ed04528d8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5034,8 +5034,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
-		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
+		if (swap_entry_synchronous(si, entry))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..b8181bd056ee 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -94,6 +94,7 @@ static inline int mem_cgroup_swappiness(const struct mem_cgroup *memcg)
 
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
+#include <linux/zswap.h> /* for zswap_is_present */
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 static inline unsigned int swp_cluster_offset(swp_entry_t entry)
@@ -336,6 +337,24 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t flag, unsigned long orders,
 void swap_update_readahead(struct folio *folio, struct vm_area_struct *vma,
 			   unsigned long addr);
 
+/**
+ * swap_entry_synchronous - check if @entry is read synchronously
+ * @si: the swap device of @entry
+ * @entry: the swap entry
+ *
+ * SWP_SYNCHRONOUS_IO devices and zswap complete a read in the faulting
+ * context, so swap readahead has no asynchronous I/O to overlap.
+ *
+ * Context: The caller must hold a reference on @si. The answer is a hint: the
+ * entry can be written back from zswap or freed concurrently.
+ */
+static inline bool swap_entry_synchronous(struct swap_info_struct *si,
+					  swp_entry_t entry)
+{
+	return data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
+	       zswap_is_present(entry, 1);
+}
+
 #else /* CONFIG_SWAP */
 
 static inline struct swap_cluster_info *swap_cluster_get_and_lock(
@@ -423,6 +442,12 @@ static inline void swap_update_readahead(struct folio *folio,
 {
 }
 
+static inline bool swap_entry_synchronous(struct swap_info_struct *si,
+					  swp_entry_t entry)
+{
+	return false;
+}
+
 static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	return 0;
diff --git a/mm/zswap.c b/mm/zswap.c
index 7660f19ed5bf..37d217860a6b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1695,12 +1695,15 @@ bool zswap_store(struct folio *folio)
  * change under it.
  * Return: true if at least one slot in the range is in zswap.
  */
-static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+bool zswap_is_present(swp_entry_t entry, unsigned int nr)
 {
 	pgoff_t offset = swp_offset(entry);
 	struct xarray *tree = swap_zswap_tree(entry);
 	unsigned long index = offset;
 
+	if (zswap_never_enabled() || xa_empty(tree))
+		return false;
+
 	/*
 	 * A pinned range is at most SWAPFILE_CLUSTER slots and is aligned to
 	 * its own size, so one tree covers all of it and a single lookup is
-- 
2.53.0-Meta


