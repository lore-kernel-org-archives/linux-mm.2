Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC42FC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43926B067B; Tue, 18 Aug 2026 08:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4176B07CF; Tue, 18 Aug 2026 08:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930F76B07D2; Tue, 18 Aug 2026 08:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCA56B067B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:49:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09722160BCA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:54 +0000 (UTC)
X-FDA: 85114372308.16.BDCEA51
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf19.hostedemail.com (Postfix) with ESMTP id F04201A0005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MZRAhGIA;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787057392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdT6hPIOlo8wlaYjoKPpTRDYP8BOnS+NqBZEqoxx7AU=;
	b=KQpMTU9zqvzYrfnLZQKcu4SIXVE2PZMsI+PK/6cnmPc4rO2LoG/bLV9H1r7aTp01RNtKSG
	XFtcMBWI/qr97suXP6kKNmF/kIXmY3/kymlGmhcDiqon+sRYbyUyYjx1WlQGLD02RCgR1P
	Q8GBeCj9AwJCP/egC+Q0f8h427xLbuE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MZRAhGIA;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787057392;
	b=TVsnB8fu20FdsJ2B4eahNRFcGJxWS5fJ40bdC+UOvJJRO/Dr7S8rlQSr6Bg7qi9ag5mE4/
	JDnF23vA15BswW45gIuFqFtybWihg2LHFWR3fHJ4+nDCyw6IPk8YHeVdHMKU5zEnv3hmuc
	yRW1V5/2C9As1mzFv6qGBEfjJc5WsLw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+ZaGSzQvA67tttFmZkgVqyG/izCzwDTO3GPvWzOf9tU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787057390; v=1; x=1787662190;
 b=MZRAhGIA9plhsfxMA5xurbNG3zc0ex1U2g4d9BPNSbweFd9SE24u2738XehVtbLhh6wlf0FZ
 hfzR5qgztknQy5D8lstAs1HDBBp5t1EnjzWI/Ji6GHF+uuFVEwU/l3xduRQDqyG4/KwQzDmp4YQ
 O36Bt77UUnd49Puzpqz7qDiA=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 9ee484d082169ca3;
	Tue, 18 Aug 2026 12:49:50 +0000
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v3 2/2] mm/vmscan: apply too_many_isolated() throttling to MGLRU eviction
Date: Tue, 18 Aug 2026 20:48:57 +0800
Message-ID: <4b4d4e3065e36f1b60dd69e8276cb92082f393a6.1787056208.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787056208.git.zhuhui@kylinos.cn>
References: <cover.1787056208.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F04201A0005
X-Stat-Signature: fsswd7dqysiepzwhskf8fctaunwya4da
X-Rspam-User: 
X-HE-Tag: 1787057391-188482
X-HE-Meta: U2FsdGVkX19ikgiFOhdKrDlybt5ZbYPh0sHB/2wPew8WwihMyI/iA2PjB2Gxz9NfedTeJbnf4K7RIks3N+IPrDVS5ypVjm7sFepBisHe3DKPCbrIgaGvpJuRmSJt4u7VhkeJZiZ9n0m2rlAgjyFiKduX90UViZkBz+HvZiwIfNKZ5NW3NyyyBI4YSpLB5WWkKbVES+Z/idI6glOfwYhZfYakOLaoGkvresMiTogDH7/YfbrJpEq/hPJkAINj08X/4SvVVRJntECrx7Po0qZQ+HjZLbD1E8DSauaQSvI5isVC5mExHmENhmPPMJqNrAUubCNZU3Nh/3s2lt9P62+HHZQmy8GhrqUL3wtky12F+8pwGbS9DVtPt0x/1NnArOC6yzvcix5rcJAjInlN4uh6gidYN8II6ST6FVnOVLWj6wlWBClp3ksEJyAohmjay0LhoFdJQvEP6CZWcVLeBpier+f0etRzyijJPgF+x8LVPxsrhoaydk/poDS0c0PGNzmpT+yDcwVLsjjTcAdMnZaMLEM1TAkv1xUPqBRX+2dEuzlvo0vdr6sOPNLZ6a3lMVCTSKasl9OK/IIhmeJOLmXni/f8nfS/uLY2N6ttJFarNhi2QgLIOUvBfvWToGpcE8CD2MB58WOvv5C8fpkLqLpWOJxWoc4Ex/GQ7pWEDMXsXFUQuY2wkQpoteCMvZv4ASz/QI5YrpJ9dfob/jthjcaE7X9BXlcl5vdxgYR9G3TsgzwuHPWPpxlg/rPJ2Z29IeTlls6kGrH9COcrsYrrXVhuUWNttDF5jX1JJB/w3d73GrfkUZ9be3ECf6MylxebrO5x7DjsIIoWvQUU6iWFJ6xr9hN0PjoEjSX5MjrtdbhI/L8PQqBnLCvIG8QCQ06wG4tOJUu9mw1G3Wsz1jeAErDKL5dcOp/qrv1uZVuY+OqXI2iSAF01+vTf/odtEFMtQYTOCpQf3+TX2JcHwfgRL6X
 75sjLF+g
 yfAeDz+T3EjyaMGIBkSC/0XRFHvwOCk0NMCvEOqVWk7p8/019N4dG8j4io+IdBJD7GMYJm9c0Pv32HvLOE7oKOZyhDqgNVaxPlzJOmwB1SNOeyymJkJsV9n1cE/AnmXzMO44YR5vbb430rWHjjWBlqbT5IGnzz2Z+bBld/MWiW+ur6WJD+5ttBp3krjYj3h43sryCzluLwY51Gya6nuaW01NlA8lhYV4Y6Hx8MfSu4Qgku/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The legacy path throttles direct reclaim in shrink_inactive_list()
when too many isolated folios pile up, but MGLRU's evict_folios()
isolates folios without this check, which can lead to unnecessary
swapping, thrashing and OOM.

With the NR_ISOLATED counters now updated in evict_folios(), extract
the throttling loop from shrink_inactive_list() into
throttle_is_throttled() and reuse it in evict_folios(). Since the
type to isolate is unknown until isolation and isolate_folios() may
fall back to the other type, check all evictable types with
for_each_evictable_type() and throttle if any of them has too many
isolated folios.

If a fatal signal is pending, fake reclaim progress the same way the
legacy path does, so the dying task exits reclaim quickly instead of
being held in the throttle.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 71 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 98226bb021f3..6fe8824430ac 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1819,7 +1819,7 @@ bool folio_isolate_lru(struct folio *folio)
  * the LRU list will go small and be scanned faster than necessary, leading to
  * unnecessary swapping, thrashing and OOM.
  */
-static bool too_many_isolated(struct pglist_data *pgdat, int file,
+static bool too_many_isolated(struct pglist_data *pgdat, bool file,
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
@@ -1856,6 +1856,37 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
 	return too_many;
 }
 
+/*
+ * Throttle reclaim if too many isolated folios are piling up. If this makes
+ * no progress, the caller is probably looping on unevictable folios, so give
+ * up. Returns true to tell the caller to stop reclaiming, and sets @fatal
+ * if the task received a fatal signal while waiting, so that the caller can
+ * bail out faster.
+ */
+static bool throttle_is_throttled(struct pglist_data *pgdat, bool file,
+				  struct scan_control *sc, bool *fatal)
+{
+	bool stalled = false;
+
+	*fatal = false;
+	while (unlikely(too_many_isolated(pgdat, file, sc))) {
+		if (stalled)
+			return true;
+
+		/* wait a bit for the reclaimer. */
+		stalled = true;
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+
+		/* We are about to die and free our memory. Return now. */
+		if (fatal_signal_pending(current)) {
+			*fatal = true;
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
  *
@@ -1992,19 +2023,14 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	bool file = is_file_lru(lru);
 	enum node_stat_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	bool stalled = false;
-
-	while (unlikely(too_many_isolated(pgdat, file, sc))) {
-		if (stalled)
-			return 0;
-
-		/* wait a bit for the reclaimer. */
-		stalled = true;
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+	bool fatal;
 
+	if (throttle_is_throttled(pgdat, file, sc, &fatal)) {
 		/* We are about to die and free our memory. Return now. */
-		if (fatal_signal_pending(current))
+		if (fatal)
 			return SWAP_CLUSTER_MAX;
+
+		return 0;
 	}
 
 	lru_add_drain();
@@ -4877,12 +4903,33 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
-	int scanned, reclaimed;
+	int i, scanned, reclaimed;
 	int isolated = 0, nr_isolated = 0, type, type_scanned;
 	unsigned long total_reclaimed = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	bool fatal;
+
+	/*
+	 * The type to isolate is unknown until isolation, and
+	 * isolate_folios() may fall back to the other type. Throttle if
+	 * any evictable type has too many isolated folios.
+	 */
+	for_each_evictable_type(i, swappiness) {
+		if (throttle_is_throttled(pgdat, i, sc, &fatal)) {
+			/*
+			 * We are about to die and free our memory. Like the
+			 * legacy path, pretend some pages were reclaimed so
+			 * reclaim unwinds quickly instead of looping back
+			 * into the throttle.
+			 */
+			if (fatal)
+				sc->nr_reclaimed += SWAP_CLUSTER_MAX;
+
+			return 0;
+		}
+	}
 
 	lruvec_lock_irq(lruvec);
 
-- 
2.53.0


