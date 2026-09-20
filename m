Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C7AC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA1F6B0095; Sun, 20 Sep 2026 03:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843276B0096; Sun, 20 Sep 2026 03:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FCB6B0098; Sun, 20 Sep 2026 03:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5023D6B0095
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FE771203FB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:11 +0000 (UTC)
X-FDA: 85233294342.25.DEE8514
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3CC3340005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888869;
	b=3P8NqLaEE89x8HU4dLg9c+LBacZF9cwWf0j7ueljvjwSm2UVFY1EUNDoFYRPdP0hDgEMCf
	2BPGb1aMYkalA139b03sUlrgXI8YB8wiYNJ0qDcLlg5apI8r7p69LhSZCcxgbdkX0RgY/t
	C2fsoviOsvUTVX+lQA20CQN68EPhFyI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eUcng2kRh6hp60bk0KhOm2drw2LRNoNaE/esk4gkwZU=;
	b=BuwcwS0SaaxNBOJQiUx9FuO7/ih4N5u0KWiPAepUZB+HoW0P43Cc2X8T6ZXw1gdQLPtZhg
	fyOn0Co+PqjrSKA9JhPGv8S2yqz4HXYH6ZUtDE9m91ikQXhb9F9R3gBcz/HS72M7tQcQZc
	CXVfr4JRdjAT3j55T1ALc2qwcoM07hc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 347834c4be70ea4c;
	Sun, 20 Sep 2026 07:21:08 +0000
X-Mizu-Trace-ID: 347834c4be70ea4c
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
Subject: [RFC PATCH 03/17] mm, swap: prepare the folio-less allocation path for xswap
Date: Sun, 20 Sep 2026 15:20:29 +0800
Message-ID: <20260920072043.430390-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3CC3340005
X-Stat-Signature: p111jwd9wbtwk1ww5hwi8twgr3gq4gdn
X-Rspam-User: 
X-HE-Tag: 1789888868-142894
X-HE-Meta: U2FsdGVkX1/bqKRdaT4MsVgbOn2H8LjrGLSQwcQt8+czn9NirWINcU1Nyw5zmPYcCPXacWx4hpkecpHLU30iqG3xnZVIybwmglTV3fzX2vwGuPhEUh/b/tkQXHThT2EKCBelmtSeOtkN0RcQ6jpSbmdEMfDTtX0Hk0skZwXzxtGi51yLDEezhbwE0YRbseTXgazn8HP8OP53/AXdQWogeRO+hsmt0TV9p6rFFCipxzEBWem8Ai1PoNrhd2eOjBsINFZW2U8woZwdBx5A0L2ATtt0B6B1GRAqi1LpniBYi7TLGVQ4lXQCqn0VF+WNgRLvw3aG71dzRRYgjyEQA6sSv2YLws9p5f8rNmvmhpZjvVLzWvFSmsDW2nDiimol5jLEKiLqE2MZ0DJmihIGi2HKbhxE9f226wGb/Ib6X06GeJJtRGSSL82sCFmJZJGWLgnhnU2sKlQ8uvLL0m5TrhFR82JgNQAXGFpoo8emn4tZ0i+FelzxR4Rj4dSeD3df5/SdSYoO+AsrLMUGt84wTODJdeDpnblji1dxDKnSf2/H6Ju4V5zgvksIq/Ao6zTo6VXZuLJ48cbV3Oj+KQhxxEDDH8rvwtT4kvREVJzn1Hju1j2W21Eqb2R0guLyiFn1dSNFJoEqZDbntQASgSObNwauS00nUACtGupKVXnxUeiWCqNT7YTlDhpIBfiYvVWy0p+cdjQiGD5Bjks9feJKGdyfYpz50zBtv5pFdqvgRL8oTXPVyCfg9K3+Z2Redh0MNAXUqYN1gDIdy8l2u4Pv/hDiojdybHpVYKF1dGofgGsxqMEBEAX/jihqfPyXYBMJhv2+OqcWOnqE7PkS7dOyfxgGp34gqGJRqg92mpuD2tMx8FTEqgG9ZNyf15OujX0OtLD4O79k+oxK5YRvqVtOm7vrMqgY9+oqOQi/EFas8Qhd0geZvX0XInDa6WIsdF6QQNPg7vmvRtktlwJ6dgvaFgV
 uz6/jeiw
 iV8EptxhOF+7crIRO9AkUris3IrNqjW5nnh1FU5vKdT2len4aGc59k1j/KeniFDwieDSg4XmaBvZv4sK02rMLEQUR/Y3ekSrBb3/PpLop4/0M3Dada3Or6fdefUE2YKdipBtwYhj07pHXnGWdTTZreR9diip+2Qu8CBlBAXt1hjmYbjls25yiylKnrvZzSvQwPej8IIEoI/Lts8qV4itOgI+ZU+ZMpvp9WINnx8yMAr/+BZTTYVPyLfMhE2C91rWK7SgMDveaK04ZmeKQPDKL1pAF3j4bPNY+dsLcfyM+wnv7bHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xswap backend writes to a slot with no folio of its own; only
hibernation allocated such slots before, so the NULL-folio case must be
allowed more widely.  The slot also comes from a lower-priority device,
so keep that cluster out of this CPU's swapout cache, or later swapouts
would follow the backend device.  Pack the slot into a used cluster
rather than a free one, which a large order may need.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ad6703aadd3d..69ffa9a7a646 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1068,8 +1068,10 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
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
@@ -1077,16 +1079,12 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
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
@@ -1149,8 +1147,15 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	swap_cluster_unlock(ci);
 	rcu_read_unlock();
 	if (si->flags & SWP_SOLIDSTATE) {
-		this_cpu_write(percpu_swap_cluster.offset[order], next);
-		this_cpu_write(percpu_swap_cluster.si[order], si);
+		/*
+		 * A NULL folio is a backend or hibernation allocation: it must
+		 * not displace the swapout cluster cached here, which
+		 * swap_alloc_fast() reuses without a device check.
+		 */
+		if (folio) {
+			this_cpu_write(percpu_swap_cluster.offset[order], next);
+			this_cpu_write(percpu_swap_cluster.si[order], si);
+		}
 	} else {
 		si->global_cluster->next[order] = next;
 	}
@@ -1279,6 +1284,16 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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


