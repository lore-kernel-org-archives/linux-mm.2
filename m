Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EF5C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287496B0277; Thu, 13 Aug 2026 06:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 237826B0278; Thu, 13 Aug 2026 06:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174AF6B0279; Thu, 13 Aug 2026 06:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFCB06B0277
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 265DD1A05FA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:02 +0000 (UTC)
X-FDA: 85095926244.25.C057836
Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D8E6120003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=faMNGLWL03btGKuw2C410rhKCVD3i3tvXvzpp5vAcbo=;
	b=Fx2bR5V3E9bNk383vRKrwXZyBHyyrcRpRt5GDwUNB9e4fUpA8WATgH+Xej5R65Z/FDtgRS
	hUkUsXBewEWa2QIEylgfVsOKOkA34Wy8qNAx00G2NfHebYNECniRU15iG/ZXxLTSI2zTJA
	GQEWmaYAdiZT/XW9QOVx610W+teShuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618200;
	b=c4kNItyVH6N2E/waSGrdo3ofItQ9VW9c1Ufz5VRRdWkC22glgw+r28Ov0WAK5dZNMe5otY
	dmJhHOIV2IKPb0Gr9WYvl0o4eOdlJpG1vLaKk/jORbNn/SNtPfudfw630eRmZSSXA0eDYC
	5o0PIYa7ZRPjUkKzFvsB22/Bl51UG4o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 1a51a7640160dacb;
	Thu, 13 Aug 2026 10:49:59 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 07/15] mm, swap: add xswap grow trigger on cluster allocation
Date: Thu, 13 Aug 2026 18:48:46 +0800
Message-ID: <20260813104857.3450386-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ynxjyezmzx94mimfocp6y94pjny9ejr5
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D8E6120003
X-HE-Tag: 1786618200-675263
X-HE-Meta: U2FsdGVkX1+osKr+Spc9RkviuhOkPJgwGxAfax7G7GdX2ZiaiR2fzotSkjxNi5TZ4KmJZZhcBc0g5oc1h85qWrd6o4LPQ+rDKI+hjN13mPAatG0OZiEURuhzo5aRpGJ5RxR2RpZqdUmPi0SbXlDqQXY9BpKDEXlwAv68LXxUwkTmPmU3628qCxhXuf/Ai3QyJQIukSuGltPmDB62IizTJZHhknsBVJFDjL4g2/8vHDYnYXQbwnJJTYyXV4fc+77p6GF3uEqbWvtmKrP0V5BlkmlpcOjXknyu8JhG4Tir5//T59hvzYIX5dmG1u0bhHET8ylvIm3SBTqgdIZNuXjJoRvCcl19zSsh5N+LHdfR+vSiwveudgyeGSGc6w9xLT0TaN+NLrP4E/af2n56LpAIVWW8t0eKsF+qpBPm8MLJxHsYMiegPvmxreZU9X8l8N5pgQZCEwp2L0uQQKrlUryk9FcJK2a3t/WKGQDpPDE2ivR4FWrJVNDnSSskqy4xlH1k0Q2Oaue7KGP/U6IliSPlXVLi1E6/caMcD2QeZwU9u70Y6Fqh4N0gv8ZJQ4LsuV/NyAKryf0FaVRE5vDRzY+Kt0umuOlAJRFCPnILMjk5E0jkpXZtT2lIPKPl7WTFUFBHjnf2PsUw/YvYd3XlSh4kHliYvLdJ/ZPzLOAsQGixBCI0d/61BGJnZ2+ypsxoY4iIEL4Vy5ZmMlffmy9dR5Mjcj2l984cEjyBGiBWfvK9mYX/WJDSlB1g8sGTnuPAv0dPvY7JuN59Q+HFF5uH8mN78aAAZPJ3THyvSrSg/OW21HatDgAsAAhE5PaGpo1KbCl+nGIG+qSvuG9t/+ZbiC+ZVCdVvOKBiS5qYab3bQq6oUIWyh2V7yVGzmJ3PsF45fK2PBpRiaZxLU7eLUPgAZPAUYJ4Mv3IraTtf0+i3L7GOZX1ZDhyi+h4ielRA+tyJXrnAik5jtQPRhEEsxScpgY
 F7YX1g35
 vay8up0mduJS2osIXrZvTWE6elDF6n7xiC+4Y5Ry3ypL/48XN0Oav5NgVBNiWWp6iLCeLgtuiROoNs56aU6d+rfWjpVXHYd1MIoMrJYpMcPbhCIgHUE5nv4fNd2yiipaN4rckUIs0OE2IkAhvnPa3ehQR7ebQxlh3hArhpMYkNx8vk80fmN1u5eYSYBDRG77lGKJ3wlxlklo4/5Fe8cUUpSb1VoXYWMDaPTAFipqGMKEiZ5iZGxoFIizIhvhIKJRkYAa1AtIrTdn4/4rx88lPbjTIfBasoc8d/KQ3EOaa6mIYLELClsFTm4cjn7qwttcumZoxOFIkSXsuQHp4RI02zN10F+JgaiHcTcpDEG5k3MImmhZRWmSHJQgBEPdmuJsNiqeP2SiW/C8a86SUoQmchAdNXjGyj1QJXkdxYw6+pf/7rS+/9OOBVGVvoLsLJaf+iDaO7pdyFAIiqnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cluster_alloc_swap_entry() fails to find a free cluster and
the xswap device still has room to grow, expand the mapped range
by XSWAP_GROW_CLUSTERS clusters.

Since xswap is always SWP_SOLIDSTATE, no locks need to be dropped
before calling xswap_map_clusters() — global_cluster_lock is never
held on this path.

The grow sequence:
1. Check nr_clusters_mapped < nr_clusters and free list empty
2. Call xswap_map_clusters() to allocate and map more physical pages
3. Add newly mapped clusters to si->free_clusters under si->lock
4. Retry allocation from the fresh free clusters

This makes the xswap cluster space grow transparently as swap usage
increases, without any userspace intervention.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 006241558128..324d873b5f01 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1273,6 +1273,51 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (found)
 			goto done;
 	}
+
+#ifdef CONFIG_XSWAP
+	/*
+	 * For xswap: if no free cluster was found and more clusters
+	 * can be mapped, grow the cluster_info array and retry.
+	 */
+	if (!found && (si->flags & SWP_XSWAP) &&
+	    READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters) &&
+	    list_empty(&si->free_clusters)) {
+		unsigned long nr_new = min(READ_ONCE(si->nr_clusters) -
+					  READ_ONCE(si->nr_clusters_mapped),
+					  XSWAP_GROW_CLUSTERS);
+		unsigned long start = READ_ONCE(si->nr_clusters_mapped);
+		unsigned long i;
+
+		if (!xswap_map_clusters(si, start, nr_new)) {
+			unsigned long added = 0;
+
+			for (i = start; i < start + nr_new; i++) {
+				struct swap_cluster_info *ci = &si->cluster_info[i];
+
+				/*
+				 * A concurrent grower may have already added
+				 * these clusters to the free list.  Only add
+				 * clusters that are still off-list (NONE).
+				 * Lock ci->lock first: move_cluster() takes
+				 * si->lock internally.
+				 */
+				spin_lock(&ci->lock);
+				if (ci->flags == CLUSTER_FLAG_NONE) {
+					move_cluster(si, ci, &si->free_clusters,
+						     CLUSTER_FLAG_FREE);
+					added++;
+				}
+				spin_unlock(&ci->lock);
+			}
+			WRITE_ONCE(si->nr_free_tail,
+				   READ_ONCE(si->nr_free_tail) + added);
+
+			/* Retry allocation from the free list */
+			found = alloc_swap_scan_list(si, &si->free_clusters,
+						    folio, false);
+		}
+	}
+#endif
 done:
 	if (!(si->flags & SWP_SOLIDSTATE))
 		spin_unlock(&si->global_cluster_lock);
-- 
2.54.0


