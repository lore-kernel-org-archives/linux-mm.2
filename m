Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158D6CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056826B008A; Fri,  2 Oct 2026 20:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006F36B0099; Fri,  2 Oct 2026 20:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9CAA6B009B; Fri,  2 Oct 2026 20:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A81106B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:59:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 259F7A0892
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:38 +0000 (UTC)
X-FDA: 85279507236.02.F9B1EBA
Received: from mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3863B1C0005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:59:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h2dnfHRWDmuAoVgKCjwG9HzXFDTCJzwjLv0Hvl3U1Dc=;
	b=JLE/3WRcSpdKvEKNYvtgnZwpwyQs+pt5z5n/AH5G4dPTQB/Z7g+JQTrntCQTb97Vv2uPUb
	+x8pckEV7FpX+L8Ovgld6su6LwU4xQsG28TQfyZXGRc7RgBLFuayllN64n0dhSlRyM7H3+
	xMBZL6iUsWwtOostP5Y62TSEOwfrytk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989176;
	b=LpEMFL+pPcyIGdKD8WXhXsGgslvqMaA8mrAKk8QIHc4d2XPem4F4n6aCHFR4C/V2Bhuc9h
	leRLOGjLNjzRN9VN2T5M9IAAF44ZPWQSglCr13lVlH3rFllUhrTj/vBHHMEluo+5d0RD04
	a58oMOALi38Fe8jEyo4fI6F3t5ustjA=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 85f2d6abd0de90eb;
	Sat, 03 Oct 2026 00:59:34 +0000
X-Mizu-Trace-ID: 85f2d6abd0de90eb
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
Subject: [PATCH 03/12] mm, swap: prepare the folio-less allocation path for xswap
Date: Sat,  3 Oct 2026 08:58:51 +0800
Message-ID: <20261003005900.909710-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kh99khq87kxhyckdso4qa5qapr9wazsh
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3863B1C0005
X-HE-Tag: 1790989175-616811
X-HE-Meta: U2FsdGVkX19YRjRYlqr5sc0puBh95HF10jaHFS/qm1UXcS1/YLX0DfQb0hX+gkQ8O8V2p8hVnFBxmcb2vugJtGjZqPAg+qE9OHvpjiIQ7PxHrxbiL+2eNaLCUuy//kuYWG3h6u3sSZQ9jvYl8JdrM6aFaD12FoJXieh2nBbAe0d4uz4wDmFLpUzZUJ2Voe2HKa1JyMlIHGTDJ6TZV06wjbVD5xgkSNj3Z5sDSRv81AUDUUehEfzvSKyfTdqsKrORpUmC95yQsXOOBO1m1spNcyzk7IiC+NAaJKxtVvacJH4FTMkiT8B5eFZkemCWxE+x0VZFBZDl76OTPLYJOMCAQLI/Je6VghIxShxlDxmfmLlP7VQ0EXCYoIQIMgjz87BVYcZvhS8ozHHSNJG/0RZ8reZ0jzlh5ICb9n3nlhRhV6lc3S97/RQUaN6MJ0abc/SBdoIP/PFKPRLm7YkhF7ghPVNYXGXHP8JkVtaiztfy5yS+eXfywew7aoB15Cg59gEggddymukg91JlFxu2hXTZCcNXECEZGx+FOATfyUL6kbq0yyrNowqyTchFpIm01rAbQA3PzxFIONQfviHP5QuTawYlXwDPMMcPYEchPsJqdWqYt4ujnPZEjkJA0wVZe3eBX+IhX/EXiMNTZ98iVRY3Qm6Astn7CZvU+e1vXjxhbqtG4hj7xsndgifTofvrnU2tktJChsTV86lhyITpevS9rCZ1/LZRlNhinlg7ftNmcPVHJ5lnyLXg6PKaJjvnPROgA2MAk0kGfnhmriON9DJ2mhtiodrNYnhZbsxypeEBIozvxYGIV47qRi4oB8z9WmGN+XRsGfxlP8N2lZX9JqvTuHF5DPQIMkgdS3oM9eVsmzswTk5qtSsq1MIZYJJMseHd0FSQcWVy7pDb4EQmMmxjrLtmXXzMzVbOQr4LAwASrlgdPaiTwYD7G45qtbcb+ckIoOafV9GeqPyCoQMxeIW
 BSDX3XJ1
 ZXgRa+/YECiak34hikdMDmKAq6xCOYtA3fxF/vKYH7nrqr2ytQ/m3+Am3xxIUlIOhjhhIs6vhLGrR1Jsb7Y/WXBFX7ZNlUVfNOwYSajgRGTAL2DJLiuCIauVwXoVUdA7+duvFYo+khyVNkhaY015D3uPGOgIR7Z8hShcVz1GMpEJuTewfwsfDVHOrTATm/2csDgesn0PRa+lntsiVBRuBFUktGDAOtHywYaKPOaS4X8gMJU9KErzsRySINXNkjTdMH6+X7w3X4y9hA/ePZRXlwVcrYkiMKshLdSetexA5biHM/9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xswap backend writes data to a slot on a real swap device. That slot
has no folio of its own, a case only hibernation used before, so the NULL
folio path is no longer limited to hibernation.

The backend takes its slots from a lower-priority device. The cluster it
fills must not go into this CPU's swapout cache: swap_alloc_fast() reuses
that cache without checking the device, so one backend allocation would
send every later swapout there and xswap would never be picked again.

A folio-less slot packs into a cluster already in use instead of taking a
free cluster. Only a free cluster can serve a large order, so the free
ones are kept for large folios.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index af7a7524fc4d..dd18aad7cfd9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1156,8 +1156,10 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	 * Such swap slots starts with count == 0 and will be increased
 	 * upon folio unmap.
 	 *
-	 * Else, it's a exclusive order 0 allocation for hibernation.
-	 * The slot starts with count == 1 and never increases.
+	 * Else, it's an exclusive order 0 allocation for a slot that has
+	 * no folio of its own: hibernation, and the physical slot that
+	 * backs an xswap entry. The slot starts with count == 1 and
+	 * never increases.
 	 */
 	if (likely(folio)) {
 		order = folio_order(folio);
@@ -1165,16 +1167,12 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 		swap_cluster_assert_empty(ci, ci_off, nr_pages, false);
 		__swap_cache_add_folio(ci, folio, swp_entry(si->type,
 							    ci_off + cluster_offset(si, ci)));
-	} else if (IS_ENABLED(CONFIG_HIBERNATION)) {
+	} else {
 		order = 0;
 		nr_pages = 1;
 		swap_cluster_assert_empty(ci, ci_off, 1, false);
-		/* Fake shadow placeholder with no flag, hibernation does not use the zeromap */
+		/* Fake shadow placeholder with no flag; no zeromap is used. */
 		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
-	} else {
-		/* Allocation without folio is only possible with hibernation */
-		WARN_ON_ONCE(1);
-		return false;
 	}
 
 	/*
@@ -1238,8 +1236,15 @@ static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
 	swap_cluster_unlock(ci);
 	rcu_read_unlock();
 	if (si->flags & SWP_SOLIDSTATE) {
-		this_cpu_write(percpu_swap_cluster.offset[order], next);
-		this_cpu_write(percpu_swap_cluster.si[order], si);
+		/*
+		 * A NULL folio is a backend or hibernation allocation: it must
+		 * not displace the swapout cluster cached here, which
+		 * swap_alloc_fast() reuses without picking a device again.
+		 */
+		if (folio) {
+			this_cpu_write(percpu_swap_cluster.offset[order], next);
+			this_cpu_write(percpu_swap_cluster.si[order], si);
+		}
 	} else {
 		si->global_cluster->next[order] = next;
 	}
@@ -1379,6 +1384,16 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	}
 
 new_cluster:
+	/*
+	 * A slot with no folio packs into a cluster already in use: a free
+	 * cluster is the only thing a large order can allocate from.
+	 */
+	if (!folio && order < PMD_ORDER) {
+		found = alloc_swap_scan_list(si, &si->frag_clusters[order], folio, false);
+		if (found)
+			goto done;
+	}
+
 	/*
 	 * If the device need discard, prefer new cluster over nonfull
 	 * to spread out the writes.
-- 
2.54.0


