Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B897D58B37
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C1C6B0119; Mon, 16 Mar 2026 01:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E051E6B011A; Mon, 16 Mar 2026 01:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD016B011B; Mon, 16 Mar 2026 01:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBC096B0119
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:13:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A9E55D61E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:16 +0000 (UTC)
X-FDA: 84550757592.04.05C7FC2
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AC5280008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773637994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tHG9ZEa0kBzIOueCtVsXqLsKl7K37pcAQrk4DeIpVrs=;
	b=vgv1GV+0Rw1OPxEyYlsv6LPXeehSIoABHDLsJGLmLWYQEGezDF7oJ1Iiojt8L3hTJMkxE5
	e0PN/QVMnvl84VJ3X5senKf9/aRQHjFjapfGVgjmAL4BApjMb74IE5Wt4ahyvdtl1i4eO2
	pFVh1zDWwX3uawK4O7LjfpmYi1BiYqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773637994; a=rsa-sha256;
	cv=none;
	b=dJcpPPHezzHzFGM7qJ+jLBTI1wpZR/VVqYq0dTEwSBzjVs0XuFpJqe6Ouqw4z/8xoeOS76
	C3yod3U+tutdBdFpapwbXo9/waxJE88gAykuui6KO0hECG6BFKhhRZ2P60SMBOvvD6li9M
	+U5OXzs8ezFFNpI05mV98bWAoMHqt+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-33-69b791649d3e
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [RFC PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
Date: Mon, 16 Mar 2026 14:12:49 +0900
Message-ID: <20260316051258.246-2-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
References: <20260316051258.246-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsXC9ZZnkW7KxO2ZBhenclvMWb+GzeLu4wts
	FrtuhFhMn3qB0eLEzUY2i9U31zBaPN/6i9Hi593j7Bb7nz5nsVi18BqbxfGt89gttjc8YLc4
	P+sUi8XlXXPYLO6t+c9qcXLWShaLb33SFvf7HCyOrN/OZDH50gI2i9mNfYwWtyYcY7JYvSbD
	YvbRe+wOEh47Z91l91iwqdSju+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NKj
	t/kdm8fHp7dYPKbOrvdYv+Uqi8eZBUfYPT5vkgvgj+KySUnNySxLLdK3S+DK+H/9MFtBv2TF
	v/mfWBoY14t0MXJySAiYSGxZeJINxp46ZTJ7FyMHB5uAksSxvTEgYREBWYmpf8+zdDFycTAL
	rGSVOH/yNzNIQljAReJY33sWEJtFQFXi8Kt/TCA2r4CxxLG2XawQMzUl1m28xQIykxNo/rYF
	xiBhIaCSeU8+sEOUC0qcnPkEbAyzgLxE89bZzCC7JAQ+skvs2PcS6jZJiYMrbrBMYOSfhaRn
	FpKeBYxMqxiFMvPKchMzc0z0MirzMiv0kvNzNzECo3VZ7Z/oHYyfLgQfYhTgYFTi4c04tC1T
	iDWxrLgy9xCjBAezkgjvsiNAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rxG38pThATSE0tSs1NT
	C1KLYLJMHJxSDYwSHhcXnVurltbkesiZmWm27MNJf/+UVFYb7RE33Vv8P7vqlaXTkm8rN874
	VNB/3S3lh2nywxL27V8D7cLeNp8O3qD6S3ZacdmiY5lHNs9evGwKw7F7LXrCoY5p2VVGPhqf
	VZjE/b3WzpsZJqtl8njF6asP4q5rZXCmb9SMuGl1P5ep+mrPRDklluKMREMt5qLiRABKIb0y
	0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RX0hTYRiH/bazc47DwXGtOikWDSIy1MSEz5IQivqIqC5CRcQc7tCGc8qm
	pkU4MwWV5kxHujmdDCR1uBz+Scm0bU0tSU20VJyV2spKzUxIS9uSoLuX5/nx3Lwkm9+FBZBS
	eSajkItkQpyLcasOJ4aIyzulx74EwBqLGYczcyM47H5zBb6s1OPwvnYEwIHJfBw2T5oBdLdv
	APhzpp+A3z98ZsPeBTcGm+oncNjfXktAu2GQAztVbwk4rHuOwbHuGhy6zNscOKhrxOC6OhDO
	qmOgbcLNgQ5LJwtWvDLiUJ+vBnBK42TBZrMEbnY88KBnLiImCHXpZghktGah0qIxAt1xfOUg
	0+NPLGRtKsaRdfUegQaqNjHU9S4K3S1YwtG3hSkMrU8jZPq4wkJafR6ytI1jaMjoIC77J3Cj
	xYxMms0owk4lcyXbr+14Rtm+nK26VUwFLIIS4EvS1HFaW1lBlACSxCkh7exJ9GIBFURrfw9j
	JYBLsqlGDj08uMn2il3UGdqpXsa8N0Ydou2LWyzvzaMiaGdRN2eneYRuaZ3CvE1fT7/DGOHF
	fM+kdn6F2Jn704PV838zbOoAXdCuZ2uAn+4/pftPGQGrCQik8uw0kVQWGapMleTKpTmhKelp
	VuB5aMOtX+WPwNrYORugSCD040lsHVI+R5StzE2zAZpkCwW8BocH8cSi3BuMIv2qIkvGKG0g
	kMSEe3nn45hkPnVNlMmkMkwGo/hnWaRvgAo8Mc2HDbXtz7zeuvL0gsvQgEfVJ8Qm7UlPMqQQ
	PzTjUafD3nfEsyQHT/advRS/ZGjwC3GPxrmUkT51hkSlUa9oid7Iiw2eW5NHysyLk30LKvtC
	xIl2wW01ow93X5T0TPfKto4ux4kbd4sLfUzRZYZi7s2HL7T11Zrp0sLRWbEQU0pE4cFshVL0
	B4Tls83MAgAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 5px1pdyyjobz5psyeb4xce59q6p98p55
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AC5280008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773637994-435075
X-HE-Meta: U2FsdGVkX1/rx8mZyN6RhQtpeu05qghP0kxrXgQ6/CfryCJ+HAipVeS26vu+qGKCktCSHGH6Xu0Srg38BKnx/xDEDNCoKqvLHUua2g8I5zqR7sn4jA1Ri9+C/23xqy269F5Clngn4Xx21d1uuTucmuaHsUgbXGbLiz4LnlseDomWBAsirZ4WOIOE7hhcrlY1fKtYSLAN1Z6IipLE/TI4XubmgAJ8fGf7BcTCTiRlaLuxTFzVdqLOoxN/QhHSMSsLFG6VzFfHzs/wQO1CM0wjydR4fW1Skv4GcMvuxw5brHIQtdYnOokrwj0G4I8UY/KHkDdKQb2XGyWhVh9u0IXenuBtNVVr1gVsyjx0lqkfD5Dx2aXFJxUkG7Dgei+PAqNaue/+sZRMD2Z+injjF1K7gDru3HDJPs1lNyJqrxwNAJ4uwyVtrJX8L5N/ArSd/2fhlWNK5TOB8/IJ17fEvMsQsHF5HjUYIfy3H+WOQ942B6ZUn/rGNioSzI2TTI9THSIxfA5x7Cd+d5SZObg0NF/gOQVgGgO5DutlsAlWZ/VOvTAjz8JRU/NuoSoPjPTDHadXnkAG2O9AYvE95YyrNcrcdZvlKHQA+t35NMUo2AiPAeIQadoiRHuV3GZ19ZRpXjhJTnhEwVbXQmeop+5C5A3IqMfQi8qDjlepSDwqp5vSaOT6te4mavq/MZt7WOuUjkr1q8jzvqU2V/6VE505FaPsthJne4hRFRW7+/JiJx2QuZjaDEe2jomxBAJ8MXUTjpunXlRsiJ7hLsOka4a9fhEd3v7kovKqIqfNos6doAIdCc8k3o5XK2R/AAtg8PuVq5HMCKzaKdjhr3rE+XdcVqJ4WWZWbnrqmoXB0ciSuH3VCaZsaRu4lNyIngx+zOinRwUssUHx3/38vHf+cJuludin4X5BHKwExsP/fSsT9WxKnXP07x7Ey329QsjqSpTMeyWAS+bDdYdnX7i4mMJBCcQ
 iYQ9zrPl
 e4hMeP6tLMWGlvLukBf375OKBoYdmVlVFmBbr4S0g+YGV1tx6OJTBTM152dZ7eIKT/PfGOB4V0kJAyxaGtkVDezpxYq1d8JBTpW3NoZe03yzX8Lkbm9VtQZlCQyV0/EhUwFPbplDii7zgCth7sk1LvHg6SyxQ9Vie8gC4ROMtu+0jRjBVkN/bLzcb2zVUWa5obgfy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new NUMA helper, nearest_nodes_nodemask(), to find all nodes in a
given nodemask that are located at the minimum distance from a specified
source node.

Unlike nearest_node_nodemask(), which returns only a single node, this
function identifies all nodes that share the closest distance value. This
is useful when multiple nodes are equally near in the NUMA topology and
a complete set of nearest candidates is required.

The helper clears the output nodemask and sets all nodes that meet the
minimum distance condition. It returns 0 on success or -EINVAL if the
output argument is invalid.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 include/linux/numa.h |  8 ++++++++
 mm/mempolicy.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/numa.h b/include/linux/numa.h
index e6baaf6051bc..aa9526e9078b 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -33,6 +33,8 @@ int numa_nearest_node(int node, unsigned int state);
 
 int nearest_node_nodemask(int node, nodemask_t *mask);
 
+int nearest_nodes_nodemask(int node, const nodemask_t *mask, nodemask_t *out);
+
 #ifndef memory_add_physaddr_to_nid
 int memory_add_physaddr_to_nid(u64 start);
 #endif
@@ -54,6 +56,12 @@ static inline int nearest_node_nodemask(int node, nodemask_t *mask)
 	return NUMA_NO_NODE;
 }
 
+static inline int nearest_nodes_nodemask(int node, const nodemask_t *mask,
+					 nodemask_t *out)
+{
+	return 0;
+}
+
 static inline int memory_add_physaddr_to_nid(u64 start)
 {
 	return 0;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..a3f0fde6c626 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -338,6 +338,47 @@ int nearest_node_nodemask(int node, nodemask_t *mask)
 }
 EXPORT_SYMBOL_GPL(nearest_node_nodemask);
 
+/**
+ * nearest_nodes_nodemask - Find all nodes in @mask that are nearest to @node
+ * @node: The reference node ID to measure distance from
+ * @mask: The set of candidate nodes to compare against
+ * @out:  Pointer to a nodemask that will store the nearest node(s)
+ *
+ * This function iterates over all nodes in @mask and measures the distance
+ * between each candidate node and the given @node using node_distance().
+ * It finds the minimum distance and then records all nodes in @mask that
+ * share that same minimum distance into the output mask @out.
+ *
+ * For example, if multiple nodes have equal minimal distance to @node, all
+ * of them are included in @out.
+ *
+ * Return: 0 on success, or -EINVAL if @out is NULL.
+ */
+int nearest_nodes_nodemask(int node, const nodemask_t *mask, nodemask_t *out)
+{
+	int dist, n, min_dist = INT_MAX;
+
+	if (!out)
+		return -EINVAL;
+
+	nodes_clear(*out);
+
+	for_each_node_mask(n, *mask) {
+		dist = node_distance(node, n);
+
+		if (dist < min_dist) {
+			min_dist = dist;
+			nodes_clear(*out);
+			node_set(n, *out);
+		} else if (dist == min_dist) {
+			node_set(n, *out);
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nearest_nodes_nodemask);
+
 struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
-- 
2.34.1


