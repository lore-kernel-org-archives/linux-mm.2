Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB29CD13DF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C976B0092; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FA86B0093; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133A56B008A; Thu, 30 Apr 2026 16:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D95CE6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9660C1C0549
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
X-FDA: 84716345952.21.AB41313
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id CB178140014
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=k7PKv6x4;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg5Weu69G+wviDv5W5A2GzRuTYUa3VhIg/DY7vTfulA=;
	b=bF12AOkeZ34K+0lvK9H7M4H49N2PCC9uNVJzy4uXAQfqSKYaObf+ge931lNLhe29GUHdOj
	Ur93zRcn3p4c+egku9EXeA9sfBxlJ8H7uvhD4EIsoAatnM10bPPp1CXSaViBbLY3G09GTB
	pMXE2MEPAtpLhkoB0pT4N/zLQz7fYxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580574; a=rsa-sha256;
	cv=none;
	b=01V6Ue3nnYmlR0E5sDNxkeJHSEWk+ONFJ3eunitQ1UD3mWyXEkuGuL+d2QibMZlDRXfaYY
	8UDwf/WXyOqjCdmiOvdhJWmbW7bLm9PVjeMbqjBNmcPO5602UkaQOLqJcTb1NzpFU8eeEj
	GCxn8C9fVW82XvpQJDB0IEgO6Faxpko=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=k7PKv6x4;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tg5Weu69G+wviDv5W5A2GzRuTYUa3VhIg/DY7vTfulA=; b=k7PKv6x4HjrjzXohd+rNODZ6fu
	zAsURVDXP+bNr7g6LgNjS3AqK4rLIAeHXiTEznc2tKz4A1zgl8SYJwUpvhglHeL+prHiaF9ruPssK
	OX/zqbbKNVDeeGRraseqKh7AFn0d8Tny6NSmLRlU8f71ZRWjWgOTUe7hixUKWFvFFRctwuS3oQCet
	hAszdT/aPbQ9v4D+uhvX/7saRhm//BGwKqF+s8PsM4NcucqaFv8rwqXkgjHXldw+Ew7khbmvqIupS
	J1bDyvscaBe7Jr3qKYxWLRn2cUoveNLx/7ye5hRxhJ5CP5uaavUmBV9W9Ab+GqL7F6SXzytXhTLmn
	Wi3bJJlw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2Ghu;
	Thu, 30 Apr 2026 16:22:40 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 05/45] mm: vmstat: restore per-migratetype free counts in /proc/pagetypeinfo
Date: Thu, 30 Apr 2026 16:20:34 -0400
Message-ID: <20260430202233.111010-6-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB178140014
X-Stat-Signature: qxog4bp91wdeuogx3i6ar8ak3fxtjo1p
X-Rspam-User: 
X-HE-Tag: 1777580574-804341
X-HE-Meta: U2FsdGVkX18NPMC5wf0D+ki9YcpHdjeHjTAqbYuBViXuVDlJIHsKUalwApSA1m6BKAeyP/wBBMO8UHUnV+C/UczyxVvfTrIy+LPgHpKeYKuXuS2K3LOBBsycbIJX6Y9Fh7PVwNEDPeRKbjPxkWIyJklG3QQ5E7QyKsZY31rfrKl/mXJr+SxH78medn4XPY+0NqSrnw5Li0JDELlT0344/4tTVtHO/wOzfWaLBDH7NnBwplBkAjZO4jba8oL4Yh3ya66/Zyui8wkzbnX/Gl+nrSHM+B1cAs7LRleOS8BZ7gzFzaYDDqFw/g4QxKxV+e/c0bk0SDSGjgj7K7mqW9uThx/M2JiS6i8mTWR9fljrY2lmeAm1P5GMTYgX6pSJoGO2Ea6gR4IiqttLd1gGyQrGy6lH8GhE1X8HDpMFJWyAjeM59+BwNOiCdNNWW9ouWsGMNb7J/lENs2N41IdGKMoGzmY2GS72F3YuhKID8bLPrfeE14TEacjMJVXrFOUork1I9YyMDswVxsgPPya/bK7RUvM6ywmmrWxSM1ImdsSDEDjQG+tBo1kkdZa7GnBXIYWXiYU+SmLfseWdsdiKRqH9tgysdw9JFroPsoV38RcRAZtqcYE4W5ef1kxahXPAV0wk4qDx2MZO4FsZWCTdzSooGtuDybe2zX5vgiEc8FlJG6x4ok7AcOKamPpmLFyZqYmTlJSimJ6ke49JO5ixb7abOJVx0CqbsIbiF13RVUKKdqRpyzbf5+ZRqM0gPdaTLhVS79YR4jblKxc8YRyqflivysDclJ7Ihkv6J+5xE7u7ccB4S9s7tfQt12RZprYa+el3wzFRbBWbh7Kra3dyUd4Ad+BraFRtmDkxo8XtOxjVLUtn//iCSyN09N+yjiqtQvKtNyD9R6RaB82vL6+K8Pw0xOoQnLJ9pHLl7ZhoBZkYvLKtAciExeBjOmjfwt+8kQAfY8wlYIi9aKUePnHLxCy
 EAd5L2lE
 gYielNrKSK1FQBBz91ANUmxFfE6a1zvhMhhhIlVdHD5y2cjV0yvmltz5PTai98aZQ94Y4xGzKN77qL9rwKmZhRPiQpausdV2j+H3QdfSqM3rmsZM+SxNg+WV+g3vtvR01d86bYpkuy5rlMqlIquy7uEWucqja6YOx9pMvIys4lNUHFCiyWsWEHu8TTWFRCgRfVsE0byxLBqqNpekUNdknYhzQRilKMM8zk0yml2H89kaNDw9HCj4oKidm/SrH3jIVo4wH2outsjldlsm0BBIaR/73M36lNDmFD6e4qP6LY0m+YQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The SPB rework moved free pages off zone->free_area[] and onto the
per-superpageblock free lists at zone->superpageblocks[i].free_area[].
pagetypeinfo_showfree_print() was still walking the now-empty zone-level
free lists, so /proc/pagetypeinfo's "Free pages count per migrate type
at order" table read as all zeros.

Walk every SPB in the zone, accumulating counts per (migratetype, order)
into stack-allocated 2-D arrays, then emit one line per migratetype.
zone->lock is dropped between SPBs (matching the original printer's
unlock/cond_resched/lock pattern) to bound time under the lock. The
100000-per-cell cap is retained -- it is now cumulative across all SPBs
in the zone, which is the same effective semantic as before since the
old free_area was already per-zone.

Concurrent memory hotplug can swap zone->superpageblocks under us during
a lock drop; the counts may then be inconsistent, but no UAF is possible
since sb is re-derefed each iteration. Acceptable for a debug-only
interface.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/vmstat.c | 66 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 86b14b0f77b5..7de08ab61b9d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1572,41 +1572,51 @@ static int frag_show(struct seq_file *m, void *arg)
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
+	unsigned long counts[MIGRATE_TYPES][NR_PAGE_ORDERS] = { };
+	bool overflow[MIGRATE_TYPES][NR_PAGE_ORDERS] = { };
+	unsigned long sb_idx, nr_sbs = zone->nr_superpageblocks;
 	int order, mtype;
 
+	/*
+	 * Free pages live on per-superpageblock free lists. Walk the SPBs,
+	 * accumulating per (migratetype, order) counts. The 100000 cap per
+	 * cell limits time under zone->lock; this is a debugging interface,
+	 * knowing there is "a lot" of one size is sufficient. zone->lock is
+	 * dropped between SPBs, so concurrent memory hotplug may produce
+	 * inconsistent counts -- acceptable for a debug-only interface.
+	 */
+	for (sb_idx = 0; sb_idx < nr_sbs; sb_idx++) {
+		struct superpageblock *sb = &zone->superpageblocks[sb_idx];
+
+		for (order = 0; order < NR_PAGE_ORDERS; order++) {
+			struct free_area *area = &sb->free_area[order];
+			struct list_head *curr;
+
+			for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+				if (overflow[mtype][order])
+					continue;
+				list_for_each(curr, &area->free_list[mtype]) {
+					if (++counts[mtype][order] >= 100000) {
+						overflow[mtype][order] = true;
+						break;
+					}
+				}
+			}
+		}
+		spin_unlock_irq(&zone->lock);
+		cond_resched();
+		spin_lock_irq(&zone->lock);
+	}
+
 	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
 		seq_printf(m, "Node %4d, zone %8s, type %12s ",
 					pgdat->node_id,
 					zone->name,
 					migratetype_names[mtype]);
-		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
-			unsigned long freecount = 0;
-			struct free_area *area;
-			struct list_head *curr;
-			bool overflow = false;
-
-			area = &(zone->free_area[order]);
-
-			list_for_each(curr, &area->free_list[mtype]) {
-				/*
-				 * Cap the free_list iteration because it might
-				 * be really large and we are under a spinlock
-				 * so a long time spent here could trigger a
-				 * hard lockup detector. Anyway this is a
-				 * debugging tool so knowing there is a handful
-				 * of pages of this order should be more than
-				 * sufficient.
-				 */
-				if (++freecount >= 100000) {
-					overflow = true;
-					break;
-				}
-			}
-			seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
-			spin_unlock_irq(&zone->lock);
-			cond_resched();
-			spin_lock_irq(&zone->lock);
-		}
+		for (order = 0; order < NR_PAGE_ORDERS; order++)
+			seq_printf(m, "%s%6lu ",
+				   overflow[mtype][order] ? ">" : "",
+				   counts[mtype][order]);
 		seq_putc(m, '\n');
 	}
 }
-- 
2.52.0


