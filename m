Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007DEC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18CE76B009F; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164376B00A0; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1E36B00A1; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3F096B009F
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:51:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9A02405D6
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:56 +0000 (UTC)
X-FDA: 85207967712.04.715D64C
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8441100002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285855;
	b=8NO2NQN9x2rE9U8ukO8Dct/dNDDBWkRkdV8iMK2Hbo1XxpWGQ6ktztPmypfeRhzXlDnhpU
	Z2J0uvsC2pIPBgm0aUTFpdwJj46oaKMaFsN+XZyioV22oiSjOuDfFn/9wzTUVADfMjJU35
	Amo4mSKNM8y7j83w0sjxbdRgSc+mb6w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dG8hqIB6JRAU3dTKG2ZJX+uWzPZnygvl/xWkAZYn6n8=;
	b=OTjUZkbRc1uU7qkCLQ/NxUZj1MPPSexr9lLUO2GcaXIQujNrFyhTkV4iaBkf8XnfoHq9lR
	Her74M7YttdNyTdnGmo1OdLkRnoQ+/9sz77pIzTzKvRToWlHQPTNLPfPVtMkISCfhUaTcO
	gt+z+BGFPbtkWA2TSBMen4Yjf4aYEzk=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 59fb4a7e4ef5c624;
	Sun, 13 Sep 2026 07:50:53 +0000
X-Mizu-Trace-ID: 59fb4a7e4ef5c624
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
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 06/12] mm, swap: add xswap grow trigger on cluster allocation
Date: Sun, 13 Sep 2026 15:50:08 +0800
Message-ID: <20260913075014.1732524-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8441100002
X-Rspam-User: 
X-Stat-Signature: jgzwkadgdbux6wrx3syoxu567kiabjsy
X-HE-Tag: 1789285854-730048
X-HE-Meta: U2FsdGVkX1/jlESZCykVP4tBL82a34jWSkg0bNX62OISq4v4K+NBMowqOktu1L3v0VuPehnEJdIN25T2h5BJd7WHZSQ1PmBRe3tT6RokfRviJSU3zJ3Gf78uLZ+UEDobNmxPgmadORuF5O2nJkOwjZ7vO9wqvgsvY2z4cHGyhPZsjnbAbVdDSP9akIxn59fuUkAuSXllrknmefEsij+F3kxvz6qqLo/gvamQKi5uEIH9XRn2hrGOBKCDydm+htv+OKUBKNWQgojTplVStgZvUY8o/RYZIGiOwhaMdW9iy08H39aK2RQCSsDmlWbP1VOU44j1MkuhXK/tpiJgw84h7brjpGJlvJh7tHaQUWN4LujTqnGKl0CDY1iYOqssjNqvwuZtpY+7ShrC/dbR2/h28jlG5l3rxx0QCDD1j9Y9JojleYlMU8luR2OWujIvkaHUnA0NKBAkVjBpGmIVAhWbTcFflUo9vVNgaAKV0OQFwGFrVWInExOiMs92Kp/Wffn4ezUGwZeH1TYV4smcm//EQI4HuN0qkI1Src2KSNC0C+2tux00hrTcE0YxudWC521CihHcRT5yjg1xAwExU6ysYvbcyebifXC3nLULw1iHh6ndxto2bhpu/4yennPtOQUxUO4ACqvUKs8L0rAesf4LBhHijuGzyKyjFVkt607N+nCv9gJ3FdN0UZkTSbWudJSXTErpM++6Wycenta7Vr1pvM8rS3+/nSFUV0JIHRUhJMbfdnJNDMqcEGvVzb/OmC+OlEdFYPst6GCAH1B1nnf4eC77Egvsf9R66en+ISZzZ9AbTnnnAE2XijB5LdxOAU6u70KUadH8dVGG45Lod1qKU+6VqwYedooLAyacBNoAm3E21Nlr4F/IxqBFWgXHD1AYOMU/3sDEIlGELcGDF+qRX3aNEU2rN67tw9jikuWJ1AuoXZrfaAtGuueaZYvBDbmf5LPE6b3UGtio2OY0Vly
 zg6JvZaP
 tir8kHxRqsI3LLPtGOZKoPhW074T0SXY8ey4x+o4yJU7IxPq/RDaCxt1ovCk7Dx7hz2dKywEbsHGqdETi6uR1jfuRv3v+d9n1QG/YVuvjYE7vHX20u9ljylu2XolKpkURgx/0gF4WJ470NdfYFJcXB+l9m4DoQkZgIBZ7kbzDm6LPFTs6Dhb6tduhm0cmXGHxOH3xgyCOzrpjmuqSespZkvBSMgcr4J1TSyV0
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
 mm/swapfile.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4861e2d49e36..f603f8c4b599 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1270,6 +1270,56 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
+		 * Mapping pages into the VM_SPARSE area can sleep, which is
+		 * not allowed under local_lock.  The lock only protects the
+		 * per-cpu cluster cache, which this path does not touch, so
+		 * it can be dropped across the call.
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
+				 * A concurrent grower may have already added
+				 * these clusters to the free list.  Only add
+				 * clusters that are still off-list (NONE).
+				 * Lock ci->lock first: move_cluster() takes
+				 * si->lock internally.
+				 */
+				spin_lock(&ci->lock);
+				if (ci->flags == CLUSTER_FLAG_NONE)
+					move_cluster(si, ci, &si->free_clusters,
+						     CLUSTER_FLAG_FREE);
+				spin_unlock(&ci->lock);
+			}
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


