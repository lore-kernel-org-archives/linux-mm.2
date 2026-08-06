Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6EFDC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0376B0099; Thu,  6 Aug 2026 04:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80B86B009D; Thu,  6 Aug 2026 04:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD33A6B0099; Thu,  6 Aug 2026 04:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5416B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:09:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DD888067C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:09:56 +0000 (UTC)
X-FDA: 85070121192.11.5313B39
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id B03A240008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:09:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf11.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786003794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ii2mFq2dFbjDz3lsN56S3iNSX4AkZhT4cwwjyE2uU2k=;
	b=XCgY4lTo/iC3wlQMKVZMggu3mIh+CihEyNR6i3uqUmN0JKQrCexTHctak2dnRTM7EJC5gh
	RlbVuPjLkE9hBP6vovMOFTxVW4fBsbp/AGj1tV0g/XTkHTJNhN3px3O0BvM6RMzAcTeKtf
	8OTzWyfImu9WnimPpY84fNjEIG0ntuA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf11.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786003794;
	b=bt3dgr32F75jMm03ITxnZZg9n9LZkkn7oCQ/jDPProUUHtCcraJiArGFC3Z1LPJaH/LZOs
	N66N/mH9HM3vkZYZ5pai7vPRnnIpS1pZBYyIkqpD8T4F+kVYQIkPt4lxMesb3iCImjVyfi
	z3MXFMPluEFympfIlhW7N6wB1sSneJY=
X-AuditID: a67dfc5b-c45ff70000001609-98-6a74414b2e1a
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
Date: Thu,  6 Aug 2026 17:09:32 +0900
Message-ID: <20260806080936.421-2-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
References: <20260806080936.421-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsXC9ZZnoa63Y0mWwdsvEhZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4Mjq2LmUu2CJZcXq5
	ZQPjBZEuRg4OCQETiYc9gV2MnGDmtSvdjCBhNgEliWN7Y0DCIgKyElP/nmfpYuTiYBZYxCpx
	4vNZVpCEsICDxNVHG5lBbBYBVYmnHw4xgti8AsYSXx/uZIGYqSmxbuMtMJsTaP73O4vAbCGg
	mj+/trFD1AtKnJz5BCzOLCAv0bx1NjPIMgmBr+wSVydNZIYYJClxcMUNlgmM/LOQ9MxC0rOA
	kWkVo1BmXlluYmaOiV5GZV5mhV5yfu4mRmCcLqv9E72D8dOF4EOMAhyMSjy8F4yLs4RYE8uK
	K3MPMUpwMCuJ8LIeLMoS4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmv0rTxFSCA9sSQ1OzW1ILUI
	JsvEwSnVwJig88x1h1aPwm5V1YZ81qmv2t3WcDqb10/QzF/izHNM75m19YLSXPP3M78IXmvi
	Z1i/cGWk54HrTTn/r/CfLjhW9zpEX2RCVsb9HebX1oUsPcmlftZ2rkJx/8nFd54dkt8dLDVl
	tfzKyvuMewMd/rw705t2cf31DtVvd15rXu89fSQ9qNDv4EklluKMREMt5qLiRAB1lAvwzwIA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+3bOzo5HB6e56KRlOAxJ8oYJn1Ax/WFfCtGVLIRceXLTOW1T
	USHyEuWFTEtBp4W4Lt5QnM7UDOnkPUrJ1DSveWclkuVtmjkl8N/D+7y8f14SEzXiNqRCFcWq
	VTKlhKBwKtcx0NnfOyrUbbrFEhZUlhNweKKbgA1fL8FP2fkEbB9IJGDZQDmAM4Y1AFeH2wSw
	f7AEwMVpIwabpmZwOJZUyoNthmcC+P5pBx9WdHIE7NJ24rCnoYCAI+WbfPhjwhcuZdjC0Qwp
	LFlZ50Oub4YPmytf8+CTz4UETJkbxeFgZisPlpXLoam2mID5LSMCqR2q1w4LUKE+GqXf7xGg
	6mInpGuc4yF9aSqB9L8eC1B7rglH9eNeaLY6D6CHyfMEWvqGkG52gYdy8u+iyppeHC3q7c7R
	16gTwaxSEcOqXU8FUfIUwwsssuZA7IdXXgmgW5wGLEiGPs70fUkHaYAkCVrCtL4NNMdi+hCT
	s9GFpwGKxOgiPtO++JFvFta0lOn9XoWZGaePMFMLHDCzkPZg/ozX4zubR5mKqsFtttjaXx4q
	2mbRVmd9rVaw09/LdORNbucYfZhJNuRjmcBKu0tpd6lCwCsFYoUqJlymUHq6aMLkcSpFrMvN
	iHA92Pr05Z31rDrwu+c0B2gSSKyE3R6aUBFfFqOJC+cAQ2ISsZD/Th0qEgbL4uJZdcR1dbSS
	1XDAlsQl+4V+V9ggER0ii2LDWDaSVf+3PNLCJgH4Uf0/67LcpUkOPngbcDLmHjzffmPfprj6
	3lBzn6+rvzM1uQrcYqW3dAb1cs2e+LVHG6Py1OqzV/Wm540nPWs6x4pTm6iyiogA6JuYnS0J
	CLF31TWYUiW3H7g61LWuWnZ2U47HvP9acxfm7NM4WTY3b3Ryf3NRZLx8hljxGZLgGrnM3QlT
	a2T/AOU56VXPAgAA
X-CFilter-Loop: Reflected
X-Stat-Signature: 8sgdu87w5uzhz6quro9ot6h5c83drsf1
X-Rspamd-Queue-Id: B03A240008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786003793-841319
X-HE-Meta: U2FsdGVkX19Y5bHfN54HkqnuXjUZqTUjAHzFkJZisof4K8FpPwair4j5+SeEOFNtJ/83OWs0MMsVAnag63dBU/0/1FjwbcR7BLl1Zt0EoTatt7YvO1ct1qPS6wddOi+HISmeAtGXRYb1Evz0UCfLSXCmrrYcTZ3qjYlVZVf19sumqfBXADpGlrYkBefnLLwV1smlTcKZfc7mBMDIpU2Y4c9L+oTHG/iZcb5RiH5d7iAsuOtYdyT5xfKhNihAQo8lf0bsyCtzO/67iuP6ML/8nXthkw3k7PJ7FxOogAwMMBQyftmQj2bZd1ndt+cySkLxIubRhVRJWphyXi8K+B4xG8Aam1+2bRYmgxFbO1v/sGiIoFYoxTp6OqrScpZQZZOcx6nmkF0ZIY9V0f3lR3fYDw1BeUk0gJA/ed4KTIrCpUyCLg8RcWuWWdyswQ8uQW1egX53A9/VlT6ACeUnyCP0pESB3VXxtx/TxqOlnbybcjwoUqCWo0bSyR2G6R5VL/Nwt0sGdPKzZVAtaBUnId08GMozBaUcbUxDlUjFFVrXB5loBi00IqakdqhnDV4OGAfsxoGnNMpMxYfuw5Gr1AYCWf1ZvnP11/pxFAdc+1Yb3UHwTaNjHaV0syMTEpE5sIPFXfQzhiEDYD/W1/nupVtvXl65A/AwsN481bMPOReh02EzLLZeEEYQVd/1wukbDsfy5TYcu2QV4XTjDPsgMO+udG3hJK+I+kZq2fHKu3TWMSHQwQi6s39+GhnLrLTDZPsRbofBPHfiPfSlCqvWn0kYWMvYX5ofrS8gq9EIhPa1IXJPgombTMv2hUf+/uxt50QQ16J9UsrNB2Dz6KDAZEQ6HfddQ3jDC/bIsc/sj1kjz4tIitY0JVj43xQ596753PWkyGNwgADgCbQQGP5OOHpEmTdhezcSOyu9uXvI0YvQcNSMqwAwUs0VVEMGDOcHnZx8oHIUNQEzGuJkO4CqF+o
 cQJnwbtK
 wsQLAR+O5ztpGacrzxu092k067ksPvxnwDUdwEXfdW4beFDMOxlg7UqNR5UZf1pn+pqtpbIgr2Qqrafe5eV0q7/ZcZRq5RQHgAnkPBm37XKgvxho3nZTHvbLfgWwXIwKk8fTw5iU9YaToESaCwxrP2eDvHPquIT3GK6OR38PyOtP9ddYbKfZfX6g+86AEpaF4NOdhiUm3J1xLqPlo1ToYGJWNBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a NUMA helper, nearest_nodes_nodemask(), that returns every node in a
given nodemask located at the minimum distance from a source node.

Unlike nearest_node_nodemask(), which returns only a single node, this
helper reports the complete set of nodes that share the closest distance.
This is needed when several nodes are equally near and all of the nearest
candidates must be considered together.

The helper clears the output nodemask and sets every node that meets the
minimum-distance condition. It returns 0 on success, or -EINVAL when the
output argument is invalid.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 include/linux/numa.h | 11 +++++++++++
 mm/mempolicy.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/numa.h b/include/linux/numa.h
index e6baaf6051bc..4f2a0c344122 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -33,6 +33,8 @@ int numa_nearest_node(int node, unsigned int state);
 
 int nearest_node_nodemask(int node, nodemask_t *mask);
 
+int nearest_nodes_nodemask(int node, const nodemask_t *mask, nodemask_t *out);
+
 #ifndef memory_add_physaddr_to_nid
 int memory_add_physaddr_to_nid(u64 start);
 #endif
@@ -54,6 +56,15 @@ static inline int nearest_node_nodemask(int node, nodemask_t *mask)
 	return NUMA_NO_NODE;
 }
 
+static inline int nearest_nodes_nodemask(int node, const nodemask_t *mask,
+					 nodemask_t *out)
+{
+	if (!out)
+		return -EINVAL;
+	nodes_clear(*out);
+	return 0;
+}
+
 static inline int memory_add_physaddr_to_nid(u64 start)
 {
 	return 0;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59..19417b0afc30 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -337,6 +337,47 @@ int nearest_node_nodemask(int node, nodemask_t *mask)
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
2.25.1


