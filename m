Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7B2CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D296B00A2; Fri,  2 Oct 2026 21:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6E86B00A4; Fri,  2 Oct 2026 21:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7096B00A5; Fri,  2 Oct 2026 21:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 666616B00A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:00:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D29B71C3C0B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:03 +0000 (UTC)
X-FDA: 85279508286.01.5EC9685
Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE8ADC0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L53CDxlnlm4pAXHd235DOe/J5dhxOWi14EIGdGDYDtg=;
	b=YIyrvDiKFzjULcQWQcqNJcAv17wTF6Vl5AE6Sk2qFYw0MAQwn733LuatHgUAlHDyv4m9hR
	VywFBsb7nJ2h/XLETaSyNo5KD9akk1XJtkqtS8dhrIjQMooZ/2RUk4Yh7cvwlvNzjdnWjf
	wh6vDoc0lmxbH7ttZ8Y3oABSV6PgA3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989202;
	b=HZ67QIjn4IenGPQvckIQnPJsICiFAWVHoVX/YGuKnyYTOXXGQeGzDdRoqMpZVKciS/Y6nL
	/KDnWK6O3vp6H1JFVmIHwVui3Nnwu9r/6knDwB/cBqBSE6nYorYnIEMvqzTrOiC7UewKRh
	sz5QvIq7z84gRsW0qyQ86eVFaZ2CjCk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id fa46dd14b3501d09;
	Sat, 03 Oct 2026 01:00:00 +0000
X-Mizu-Trace-ID: fa46dd14b3501d09
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
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 07/12] mm, swap: support swapoff of an xswap physical backend
Date: Sat,  3 Oct 2026 08:58:55 +0800
Message-ID: <20261003005900.909710-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE8ADC0003
X-Stat-Signature: r7ddstay88kzwgx8xc5nyahmeuyufk53
X-Rspam-User: 
X-HE-Tag: 1790989201-274275
X-HE-Meta: U2FsdGVkX19+Am4IomvyH3UTPDv5Yx/Qs4MiPGd04/R6ddBiuEASDgvUZonZyiQMFdJEVN2cwxavFoAPJulI9E7Al38f+YHgfx69uruzVQdZ/ldbVXBstkMAHnSOMLZAK/aN3dkIOPIMUtlTTho+dqaeXgEXfdaJjx6A1xXFRl4SiSaJqOhS2Nr+t5MCcOy6rwOU9n1BgtcMMMv1EbBaggDKLs8+BJf4/M/rWfor7FaJivEgZz05gj1Y6OpUiiZp2m/jVXx+Fu4HDO5QCvfUhoAMStTJSMipWg9jf8hyrS2iach/ALn+VCmxFH+JM5fyYbV86F+CU8DcYiR6SJcOOP6z0cO3WAbd1/POpx4zRA/W2URjfiRZSMBUEnhNdCiHzndmTOez1KMZrLLNyTZ71e3dEs9P+z+X3w4WbfjVcayzQ70USLPFv8hyBOTJPXrbLhbxdJwq4M8uo/zwHrYD07P+NuhbdxPy+sc9EH1lmKq1gK5tiwzJyN1V2R1Rwf0XAPxkhneQqUEOAKoYMKFiLEAiEepdb7QdsA7N8jItxcaT+OmFHtPRtD2gPg/Gj7h0VfHV53G5BWuTgiTUOCehXcZ3AwaldYu19KPZIzAio+gfMWhDUx7toSaIasz9XuDHjlYmoPmSyxOaLQ37lDI+1VB+0eoy7IQtdiGKW1Mtavx3Pf+0HPZSqUFusukRvLYNnb1wKEEBuDLFIc3WDLtc4z67bU1WviJQ91uSJcHO9pGfW8qHW+3KZ0wdFgZELmDZOxwbtxSyUdyiYgeeFQLBtuCJaP8wqfm1RG0O8I7K47zE4tUi2xzy1yunSWZ9cFpzdOxq2gG3oWObjhMRCzS0IPz5aH9HyPoqXtEuyaledJIy2ZWgOCrfLtvhUsmz7VLX7v+TyQlPapV3v5WIF0FAWQnAq7Ku/z5xpPpMAKfgw57OBoCrjgRWcj0r1o938DkE5cPVjuM3nXwlaxkuMdc
 db5A9NXb
 5pxGg1kPoTdtnOa7KSF2pZKdyIuXuhPj4Ct6qV4pDcmR2nJJf2tB4s6BweTepeZh1bufdCnuTUq2Ce7+VxhCWLaIhrAAZKoAXMhLThqTClLlRi3oQ1tJ97avT5rT5Ay02bdzkhWVS4gBcXHiQJKxc5u3KZaVcXYI21YbCwsH6UZNW8BmYpPMgD7XBUrDC/c9aEtMsDr9s+qO5VBBLTgGHHtlji5m76mX4T0W7psFHm8+i8ezZXfk5SvwXqJ0nAG5ynt9OtuiCj1nTmSMaWyB+Eo2qWhT6XK3Ob8mKaow+hAnxsDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapoff of a real swap device iterates its slots through try_to_unuse()
and reads each one back into memory. A slot that was written back
from an xswap entry has no folio in the swap cache, so the loop
skips it and the slot is freed without ever reading the data. While
the xswap entry will keep pointing at a slot that no longer holds
anything.

Now change try_to_unuse() to analyze such a slot through its reverse
mapping: bring the folio back, mark it dirty so that reclaim stores it
into zswap again, and only then drop the backend.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 20a9192c39de..45a871eb7bc2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -44,6 +44,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/swap_ops.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -3262,6 +3263,138 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 		xswap_free_phys_slot(psi, entry, phys);
 }
 
+/*
+ * A written-back slot has no folio of its own here, so the unuse loop would
+ * skip it. Resolve it through the reverse mapping and free both sides.
+ */
+static int xswap_unuse_rmap(struct swap_info_struct *si, unsigned long offset)
+{
+	struct swap_cluster_info *pci, *xci;
+	struct swap_info_struct *xsi;
+	struct swap_io_ctx ctx = {};
+	struct mempolicy *mpol;
+	struct folio *folio;
+	unsigned int noreclaim_flags;
+	unsigned long swp_tb, xoff;
+	swp_entry_t xentry, phys;
+	bool fresh = false;
+	bool drop = false;
+	int ret = 0;
+
+	phys = swp_entry(si->type, offset);
+
+	pci = swap_cluster_lock(si, offset);
+	if (!pci)
+		return 0;
+	/*
+	 * The cluster can have emptied since find_next_to_unuse() read its
+	 * count without the lock, and freeing a cluster clears its table.
+	 */
+	if (!cluster_table_is_alloced(pci)) {
+		swap_cluster_unlock(pci);
+		return 0;
+	}
+	swp_tb = __swap_table_get(pci, offset % SWAPFILE_CLUSTER);
+	if (!swp_tb_is_pointer(swp_tb)) {
+		swap_cluster_unlock(pci);
+		return 0;
+	}
+	xentry = xswap_rmap_to_entry(swp_tb);
+	swap_cluster_unlock(pci);
+
+	xoff = swp_offset(xentry);
+
+	/*
+	 * Pin the owner before reading its cluster_info:
+	 * free_swap_cluster_info() only unmaps that after killing si->users.
+	 * No owner left means the slot is dropped below.
+	 */
+	xsi = swap_type_to_info(swp_type(xentry));
+	if (!xsi || !(xsi->flags & SWP_XSWAP) || !get_swap_device_info(xsi))
+		goto out_free;
+
+	/* Keeps the shrink, and a reclaim below, off xsi->cluster_info. */
+	noreclaim_flags = memalloc_noreclaim_save();
+	mutex_lock(&xsi->xswap_lock);
+
+	/* The shrink lowers this under the lock, so check it here. */
+	if (xoff >= READ_ONCE(xsi->nr_clusters_mapped) * SWAPFILE_CLUSTER) {
+		/* Owner gone, so the slot is an orphan and has to go. */
+		drop = true;
+		goto out_unlock;
+	}
+
+	/*
+	 * Bring the data back before the slot goes. A dirty folio is what
+	 * reclaim stores into zswap next time.
+	 */
+	folio = swap_cache_get_folio(xentry);
+	if (!folio) {
+		mpol = get_task_policy(current);
+		folio = __swap_cache_alloc_folio(xentry, GFP_HIGHUSER_MOVABLE,
+						 BIT(0), NULL, mpol,
+						 NO_INTERLEAVE_INDEX);
+		if (IS_ERR(folio)) {
+			ret = PTR_ERR(folio) == -ENOMEM ? -ENOMEM : -EAGAIN;
+			goto out_unlock;
+		}
+		swap_read_folio(&ctx, folio);
+		swap_read_submit(&ctx);
+		folio_lock(folio);
+		fresh = true;
+	} else {
+		folio_lock(folio);
+	}
+
+	if (folio_matches_swap_entry(folio, xentry)) {
+		folio_wait_writeback(folio);
+		if (unlikely(!folio_test_uptodate(folio))) {
+			/* Drop the folio so a later read can try again. */
+			swap_cache_del_folio(folio);
+			ret = -EAGAIN;
+		} else {
+			folio_mark_dirty(folio);
+			/* Reclaim cannot find a folio that is not on the LRU. */
+			if (fresh)
+				folio_add_lru(folio);
+			drop = true;
+		}
+	} else {
+		/* Taken from under us, so nothing was read back either. */
+		VM_WARN_ON_ONCE(1);
+		ret = -EAGAIN;
+	}
+	folio_unlock(folio);
+	folio_put(folio);
+
+	/* The slot is going away, so drop the record that names it. */
+	if (drop) {
+		xci = swap_cluster_lock(xsi, xoff);
+		if (xci) {
+			if (xswap_slot_backend(xci, xoff % SWAPFILE_CLUSTER).val ==
+			    phys.val)
+				WRITE_ONCE(xci->xs_table[xoff % SWAPFILE_CLUSTER],
+					   0);
+			swap_cluster_unlock(xci);
+		}
+	}
+out_unlock:
+	mutex_unlock(&xsi->xswap_lock);
+	memalloc_noreclaim_restore(noreclaim_flags);
+	put_swap_device(xsi);
+	if (!drop)
+		return ret;
+out_free:
+	/* Leaving the mapping in place would make the unuse loop spin. */
+	xswap_free_phys_slot(si, xentry, phys);
+	return 0;
+}
+#else
+static inline int xswap_unuse_rmap(struct swap_info_struct *si,
+				   unsigned long offset)
+{
+	return 0;
+}
 #endif /* CONFIG_XSWAP */
 static int try_to_unuse(unsigned int type)
 {
@@ -3321,8 +3454,20 @@ static int try_to_unuse(unsigned int type)
 
 		entry = swp_entry(type, i);
 		folio = swap_cache_get_folio(entry);
-		if (!folio)
+		if (!folio) {
+			/*
+			 * Only a physical backend holds pointer entries. An
+			 * xswap device's slots are shadows, and its
+			 * cluster_info is what find_next_to_unuse() reads
+			 * without the lock.
+			 */
+			if (!(si->flags & SWP_XSWAP)) {
+				retval = xswap_unuse_rmap(si, i);
+				if (retval)
+					return retval;
+			}
 			continue;
+		}
 
 		/*
 		 * It is conceivable that a racing task removed this folio from
-- 
2.54.0


