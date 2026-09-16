Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16E2C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B035F6B009E; Wed, 16 Sep 2026 06:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADAE06B009F; Wed, 16 Sep 2026 06:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18646B00A0; Wed, 16 Sep 2026 06:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7426B009E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:20:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCB48C06BD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:43 +0000 (UTC)
X-FDA: 85219231566.27.92F7DDC
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf02.hostedemail.com (Postfix) with ESMTP id EAE5780007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TLckUyHFe33wPiqKM+WEyfjjATCHGkd4QqlCiS8xk/c=;
	b=3EHhzH3z0ILWmACAzb0DC4wrRFN/chOP5sJAR/PH9/OV949Uwjo0U263TiP23pChTX3+FH
	hLRRPa2bLu7louSZ9zpK3IFzimMqiiF9xupnE3RSpGt8UxW0KMhhtV3VOTeP6XRq8XHcWE
	qZZtB+zkLXlRiKZrp2pZgB6/+lUhVvI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554042;
	b=faJ+yxkbIOsWo8LNa4f11dk5HYjUpYCeFrzcTk9HB7fVeKEB8hxps8lk7SL3uKW/+ncJll
	pvd/+UXMEQtR88mA2qq7nbjUYQWNQotjVCmZpNbwnaiYkp5M41e4NZhHWe2Yxe1c9JNxu+
	VFl2GuLhhDIT0vJjxsqpUGKbTz/y2f0=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e285610b6a99b574;
	Wed, 16 Sep 2026 10:20:40 +0000
X-Mizu-Trace-ID: e285610b6a99b574
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 06/14] mm, swap: add xswap grow trigger on cluster allocation
Date: Wed, 16 Sep 2026 18:19:13 +0800
Message-ID: <20260916101929.149106-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EAE5780007
X-Stat-Signature: k5h6j4wkphmjs16o4xz7bpueky159yas
X-Rspam-User: 
X-HE-Tag: 1789554041-452693
X-HE-Meta: U2FsdGVkX18F564Vf1WbYHh95qRPruCZ5pp3Vjxr+RoS0SLsauQvCnjun62k45A47DhlrrY6vS+3ftPmvbZG4kPHmX7bRjjcrw82d7sEXjz0qnwO7zsJ0+qjvTUKA6XjnaIa4QwZRSvWsfua0MQBRyLtCaCQ1XTWIl1hopnfpjx+mmDmCzranujo0TXsfpntGHxu3T8Ak/OPAO1MBspbd0jg1k4sQ7LK0gWMbL6eo+q1cnGktyQ7Nvhe8NbuBfbGrChzbJj11HrO7MOZgbzb4vY1FWelqMWv9RuqCU7H1jNgOws26bZCwndAKx/yW0/3KGjuKqHXXu/kV/401qOcnrDYJjFqAIZpldEgwpEjgLWkw8Xb3qNTARl57jKT4PVcwgIJIUG590doFZ6It49ClU20YXbn0Es31lqQzuU5NgrFloRU69xRvyWEZixvbo0cLUO6ztVltaRwSyMUM7krb1fe6+o+wbKxNNcj3l0DBHMt5JOmgNF8J7vDRybzJNA4GUKZ9rNbZ5g8DxFVsWn/s4qNuW6mWUjLyK7as7XK+/8riwTuKqLP/ENeveQTQ8REF+M7ejgIQb+Pm0z17rCNRdItIp5rj1sfv38EiBgWVz4Tdru3UB11owT/xDXnCR0LduSSZ2e2CpPJlwiUy5PtwldtO+YOJzCeAGVTYI5CoD9hn//jfhkvUC0Mv7y4Hjoq+h+47FD+GnDPpatmWfQQzmHowi41LTgiTjl5bAC87kjNUI1IUXPsA8bsRBNn6HzmN/0w5n5ysRNWMMy7vkJCWgel2tJzvIodApFAiXV2+hW531TyLrmCvo5ZwmmsGplGyinpo7dQiPspT0dQII+TMFo8epaLj530QegQ0TQWo686huWGPhP4ZT9u8Wd9P4tDMIh2U2ADoJvKNiHv+oC9h1Zp+bVArNY9pcodsTz0sYsIHFL7lgM2oY5pdMEoD0i2AQLd1OJ6k1kUZaNJyv5
 nzNX8QAj
 Tv+GQcfo4A6FMJVS4lMz4vnMlMOaW3Kqa0lavBQk7Hzar0qfYN68h3jk6QGGamM9zJt59NX9tifpY9CYMcFs4WPfYOt1sfAX6eA/VeuO6ZSq91NIioqT5/arwzxuU7lQdTOhK2qkDnuMqh8fmTa8gCtr7/lH/wyVmQIVkRJS0AVmp0dAobbGSvEDewikne17URTeqFXBCBVHq9VVzNgK7hPKzNXjynhjSKhEBNnNHdHznkTem16tat/W/seZZwSEV6H5Ghrd+8kwmk7Cu8gKMYPUN1AGtQlk5gJxQoBfPu461OzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When cluster_alloc_swap_entry() fails to find a free cluster and
the xswap device still has room to grow, expand the mapped range
by XSWAP_GROW_CLUSTERS clusters.

Since xswap is always SWP_SOLIDSTATE, global_cluster_lock is never
held on this path.

This makes the xswap cluster space grow transparently as swap usage
increases, without any userspace intervention.

Growing maps pages into the VM_SPARSE area, which can sleep. The caller
holds local_lock(&percpu_swap_cluster.lock) across the whole slow path,
so drop it around xswap_map_clusters() and take it again afterwards; it
only protects the per-cpu cluster cache, which this path does not touch.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b0edf5421fc5..17e482059d32 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1273,6 +1273,47 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (found)
 			goto done;
 	}
+
+#ifdef CONFIG_XSWAP
+	/* For xswap: grow the cluster_info array, then retry. */
+	if (!found && (si->flags & SWP_XSWAP) &&
+	    READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters_max) &&
+	    list_empty(&si->free_clusters)) {
+		unsigned long nr_new = min(READ_ONCE(si->nr_clusters_max) -
+					  READ_ONCE(si->nr_clusters_mapped),
+					  XSWAP_GROW_CLUSTERS);
+		unsigned long start = READ_ONCE(si->nr_clusters_mapped);
+		unsigned long i;
+		int ret;
+
+		/*
+		 * Mapping pages can sleep.  The lock only guards the per-cpu
+		 * cluster cache, which this path does not touch.
+		 */
+		local_unlock(&percpu_swap_cluster.lock);
+		ret = xswap_map_clusters(si, start, nr_new);
+		local_lock(&percpu_swap_cluster.lock);
+
+		if (!ret) {
+			for (i = start; i < start + nr_new; i++) {
+				struct swap_cluster_info *ci = &si->cluster_info[i];
+
+				/*
+				 * A concurrent grower may have taken these already;
+				 * only add the off-list ones.
+				 */
+				spin_lock(&ci->lock);
+				if (ci->flags == CLUSTER_FLAG_NONE)
+					move_cluster(si, ci, &si->free_clusters,
+						     CLUSTER_FLAG_FREE);
+				spin_unlock(&ci->lock);
+			}
+
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


