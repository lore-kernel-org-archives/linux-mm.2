Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6390EC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342EB6B00C9; Wed, 22 Jul 2026 13:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B9A6B00CB; Wed, 22 Jul 2026 13:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231406B00CC; Wed, 22 Jul 2026 13:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDD766B00C9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:05:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75AC3120240
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:05:58 +0000 (UTC)
X-FDA: 85017039996.30.DC8E3E2
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B7102000A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:05:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EuMllM3vOHcPjpIi3CrXNW1tj/Frzk28Kwn201RDq1E=;
	b=3do6YzDIDGxeZVQFVMVjWbrl5KQmhwHzW8PEenJT0t6UpYcIo5F9PDThsa/8eH4fikbZ79
	pi93ue4ejwCjt1+02SbnvTH/Zb9d7pFk61lE8i69EqaF0YjRnQ6MdgOsVzvzW6lpTHDq8A
	1o+ZoOHw8dkKBxleOMiYi0k/8tatHQQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739956;
	b=fB1hD3iw2cEhxui9iQkOOtkRXPEG0hpCjtCR0Mz6HMS593afo2/mnYKWEYGDuvwbzuh6+u
	wHC+d5Dv5FEGpWIz1zuxIyeA6cwjLvpB8S0kgsJVwbrlf6QNHtrJu+XhaUNp4D6VS63pdD
	shcDjDY+Bt1F5Ui83w6LFtRQXmHNeDo=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 154453ED1B;
	Wed, 22 Jul 2026 17:05:49 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
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
Subject: [PATCH v2 3/3] mm: swap: treat SWP_SYNCHRONOUS_IO devices as synchronous in readahead
Date: Wed, 22 Jul 2026 19:04:32 +0200
Message-ID: <20260722170441.787023-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722170441.787023-1-alex@ghiti.fr>
References: <20260722163536.773166-1-alex@ghiti.fr>
 <20260722170441.787023-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: dmFkZTGM5F8wY08aD+bdn//dSNq5rNfsPeQUyFAFW8wpt+cqIzvcAwWc+Sl0lPl1c4GTIxJhscvsEQ4+yUiFDiftsv6pHqnVM4jMD5EjvZN8luacJQBNLj2BOMXQFEDNNFFiqrQTFHWz0+aJmIvxa88WkxoJFCSZ9z6u/Ql2+KTSQbfi+z4WnkinEmDRbvNxW4DkzKOsMq+bxo1T1srMSGdqXqmfRm2bGmjsJTxtAI5ZAa3Ut5acSVEPuv57U1D/+wA0I6fUGY/cbXnuBT+xpQcsRTsMsbd5BrcDD9kEHB3MKCta79PN8/H9/aDpcZR5IoID5HZ3ZoVA36jbeeFcIIOTOE5NTG7btcvb8TMGTGCkEANT/IdP6cMi/3yYO838qgkJW00EQ2IqGc2/qQivjjCUatcBpEMip8z758SAAKp0OZGby5rWrqreg1CjmSwd4k8z4q9PidIfQ+8y4tqdjo/NR11KYTPxU6Pz0R6Xb9QSlBSI5vwlCVi4MnO8IITq5fOkppx331TFh1IfUBPxzX7kufZ/qhO1OtTPH6XPbLlqBXi2liFhRJdvB8p8x6tQWl/LvYDC83RBAH4c4xsRlN8Aur+0o7pvN3Z9RyN3uBpS1z4IdglFGJBfT8omfuBQfCBEvARBgvil8roHncn386dc1qJb3DrjbdiPdh60xrRl2lWrpQ
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B7102000A
X-Rspamd-Server: rspam01
X-Stat-Signature: gu1ijhsnx98jg89pkiswugj4wo6oky8e
X-HE-Tag: 1784739956-28707
X-HE-Meta: U2FsdGVkX1/sp33YRAAndv9aGowJqgcNjIZv4+NyW9+kzWvh2eoNFW7SGe1LpHaHs3HCSJnf9bcDFRh2hc4QNHdhUuX9KXF8WDdNeliwQhOQDuZ+snaZ4mVzd1oWq7T6pVkSUWFwERfS+sLm5/2LlRoMv6uHugH6SVnv63sQutmZY0ESFBLXlUuTTGMWJuwGyYrByfZZeq90yO/acwOT10PQ/AhkVPzgPxYs98IgRtb+gDFLUG4A64QRR7T0Le1RG6JSM9y+K2P/0Jv2C4t8lyGaQp73n3RAeAjPOrLPxhn4CpQg1yftzcgDnC47A/+Atslmz/l8psq7zyyjMwQiK/zBiF72mtzYob4c2hkTvwTxGc/3ETLzENh9ZykOs2uwXcifLPuLWd1Nt/rpQSZ5pv4+QS7Stxnx5LLXLplYrs/5N1JQeHg1Wxl0RPXHNNTdy2X+LReTPyH46/UanC3+c5JXUIBRtP0UpoZtU3meC+d5rzUnvba1Y/u4zZ4UboSCRDDbhQOC5hbkPaqxpn6okfDVeW2nGDlIDbdJm2tqJqGOR9ZzsqVR7WzVlWKIpxU1/b2mi9nTrXsd/YONqm6wHwt4jK8InWvnivTyLGn/vCnmyrEr0bZgJPX+uM87F4grHttvUEwsC9iG/9TK7SZB9REMK5vSQeb+bCbtrD4JyEKWY9L34Rfxr4WycFNMYkbBUWgwJ5rgcthUwBj/s6W3atnMMOd0cf2NUWkAClcsTrW6efYAp+o2be9t6LP8HIr2Sa2akPiqr4nNNsf8oYsuqeq04snvH0BG20+R7xh6c4ybq3IHUSIZvJ0OdXg+aADDHVPmDK8BdsJd/0g/yc2boyy8zhG5zT8vVZicIfCR+9rpGHOdvKEu5gfaliz7JU65bUyRXpJgJRiENQJYbCQWGcQz3dkv45J08meaveI0062QDukh1cqWS9iY3lZI1V04kS5ka6ge18EhgrJtm++
 0i3QG3ku
 KovsEcMkcCFs/ppzYcmrANQq6IAeynqZG8nxA8szJjnHZfVdwzw40alzLdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A readahead neighbour on an SWP_SYNCHRONOUS_IO device (zram) has no
asynchronous I/O to overlap either, exactly like a zswap-resident one.
Extend swap_entry_synchronous() to take the swap device and also return
true for such an entry, so it is deferred to the second pass too. A
same-type neighbour shares the target's device, which cannot be
SWP_SYNCHRONOUS_IO here (do_swap_page() routes synchronous-device
targets through swapin_sync()), so @si is only non-NULL for cross-device
neighbours, which is exactly where it matters.

This helps a mixed zram+disk workload when the faulting target is on
disk: that fault now overlaps its zram neighbours' reads behind its own
disk I/O, exactly as patch 1 does for zswap neighbours.

Results [vm-scalability mix-rw-seq, 1G zram (SWP_SYNCHRONOUS_IO, high
prio) + NVMe disk swap (~76% of swap-in from disk), zram=zstd, zswap
off, 4G memcg / 8G region, unthrottled NVMe, n=3]. With zswap off
patches 1-2 are inert, so the delta isolates this patch:

  metric                  mm-new    +patch    delta
  swap-in tput (KB/s)    171226    182046     +6.3%
  major faults           431904    432657     +0.2%
  swap-in pswpin (pages) 1778579   1778473     ~0%
  swap_ra (pages)        1349299   1348382     -0.1%

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/swap.h |  4 ++--
 mm/swap_state.c      | 10 +++++-----
 mm/swapfile.c        |  6 ++++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6bb35c093d77..e6e0d07a4f19 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -441,7 +441,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
-extern bool swap_entry_synchronous(swp_entry_t entry);
+extern bool swap_entry_synchronous(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
@@ -520,7 +520,7 @@ static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t e
 	return false;
 }
 
-static inline bool swap_entry_synchronous(swp_entry_t entry)
+static inline bool swap_entry_synchronous(struct swap_info_struct *si, swp_entry_t entry)
 {
 	return false;
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 23137714d7cb..12fe86218557 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -829,7 +829,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		ra_entry = swp_entry(swp_type(entry), offset);
-		if (swap_entry_synchronous(ra_entry)) {
+		if (swap_entry_synchronous(si, ra_entry)) {
 			has_sync = true;
 			continue;
 		}
@@ -844,13 +844,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
 
-	if (!has_sync || swap_entry_synchronous(entry))
+	if (!has_sync || swap_entry_synchronous(si, entry))
 		goto drain;
 
 	/* Overlap the in flight IOs with the synchronous neighbours reads */
 	for (offset = start_offset; offset <= end_offset; offset++) {
 		ra_entry = swp_entry(swp_type(entry), offset);
-		if (!swap_entry_synchronous(ra_entry))
+		if (!swap_entry_synchronous(si, ra_entry))
 			continue;
 
 		folio = swap_cache_read_folio(ra_entry, gfp_mask, mpol, ilx,
@@ -968,7 +968,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 				continue;
 		}
 
-		if (swap_entry_synchronous(entry)) {
+		if (swap_entry_synchronous(si, entry)) {
 			sync_entries[nr_sync] = entry;
 			sync_ilx[nr_sync] = ilx;
 			nr_sync++;
@@ -990,7 +990,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
 
-	if (!nr_sync || swap_entry_synchronous(targ_entry))
+	if (!nr_sync || swap_entry_synchronous(NULL, targ_entry))
 		goto drain;
 
 	/* Overlap the in flight IOs with the synchronous neighbours reads */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ee2bbfdfc988..e8f88156b767 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1985,11 +1985,13 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 
 /**
  * swap_entry_synchronous - Check if @entry is served by a synchronous source.
+ * @si: the swap device of @entry, or NULL if it is not needed/held.
  * @entry: the swap entry.
  */
-bool swap_entry_synchronous(swp_entry_t entry)
+bool swap_entry_synchronous(struct swap_info_struct *si, swp_entry_t entry)
 {
-	return zswap_is_present(entry, 1);
+	return zswap_is_present(entry, 1) ||
+	       (si && data_race(si->flags & SWP_SYNCHRONOUS_IO));
 }
 
 /*
-- 
2.53.0-Meta


