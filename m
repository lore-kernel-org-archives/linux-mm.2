Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11BD606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QbK412AB
Received: by kanga.kvack.org (Postfix)
	id 08A386B05DC; Thu, 19 Nov 2026 03:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01D86B05DD; Thu, 19 Nov 2026 03:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16C76B05DE; Thu, 19 Nov 2026 03:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A72F26B05DC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:52:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2133809F1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:51 +0000 (UTC)
X-FDA: 85451253342.23.650868A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3347B100002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbK412AB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795078370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRCXp02kcUK6DNM+tm338xbPECYGukPXZVxi5qU2kcU=;
	b=VSoHDE64/PXq6OD5khn8/oUsVQD535IWlt+E5v8PXAF3NQc4Nvkj+4fcR+kuKMBJMKBsiV
	yUHaZEI9/3wtvEh2Ki7N35QZIpEPjE1J7mo1jOKPsfqsWuq8w2tvV0jWUypepIlZO+Sp/0
	3RqvO/dWrEX67BXLbGH5RgjSXKx5nRA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QbK412AB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795078370;
	b=Zb1kiu001byLzLrKc+41fDiCom9Dk8V7WtxGLrs5MakhZz1/JOe/XzY6HKBSvfr4Gx08C0
	0htVf5HypYzWUM9TYL67xricITDO8t/6XGejgIA18PRJoPI/Rb+KRPyR6/2OUB6ST7JCt5
	rSd14VK5Z5J/ozrxDyHCmy/6F+WiXD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C002861F89;
	Thu, 19 Nov 2026 08:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B6C1F000C4;
	Thu, 19 Nov 2026 08:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795078369;
	bh=YRCXp02kcUK6DNM+tm338xbPECYGukPXZVxi5qU2kcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QbK412AB/XFBTq9M9gnw+Yp32Uso9bLF29U5bYxHtNoDALmtPH6QOzjpdGsYGZABL
	 6i2bTvLVB2mUtcCnXTcU6aHfKig8qkWHwerr34A3mDqQlMtRgCitPaiJGxljEzXvyM
	 4/8GeH5T6IsHn3QB1f5GRWguavy41cNOSZcfev/vSVFnhhjA6eHMb8xeP95qryugiO
	 AbdE/GoN6OchVqCgHzp76n7W4ijldTlBTClYBU9BiQxmaOtTuSI4hTzvLKxfIaf+WR
	 ABfP/xpvfXuRjwpms1ok8/DFTOjrre55u8eUP+PN84RE1SVt1ML8IWsmsguWDH1VKA
	 PBtsNFJf84Y5A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Nov 2026 09:52:22 +0100
Subject: [PATCH 3/3] mempool: account the element array to the caller
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-alloc_tag-v1-3-efcccfd3a9c9@kernel.org>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
In-Reply-To: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3789; i=david@kernel.org;
 h=from:subject:message-id; bh=zfhueWCzByuHDxfTVQ1jokBSIKP6BHVVn67sNHvoZtI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+7Tgvfb7EyUDYbMeXf0wfdHdPuH/1rqrt9LXaKxOOS
 n/ZvdnGvKOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJVBgyMkyf/n1tG+Nv40fT
 W4Vceo9XcbquvvvhaA/3xAJxdvN35ssZGd4vOzDhV9WZndmLnoV9Yq6ffPBl8d5oz9Dy6u4/AZX
 R1iwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 3347B100002
X-Stat-Signature: 7xaopofr4obgd3ugn7ja1pm3e9hqwoj5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795078370-564614
X-HE-Meta: U2FsdGVkX191YkRlImFy5AIcmi8Uy1HsO8Bd097jnpCHQzGi5lMMYxIWIgV0TGOsRwFXJrT4ndSf4lNUsNeh+Y7RrlcxIsrhjbo6rXok+VrTyR9aIcnkmaLej6ytu0UB2qVgEIYSNIYnu90+paHMf6k/3PrSHJubqNRSEGbd4iex9EXhaszqExkCQ/YFCR7O+sTFkqcCqeG4gNzjGcKuPAeA+agXTeAJXhdzsOAXOr/gSSLVfM7fzpOZCTeoMZ+a4d21g3Q2hEsT0VALIRyETIstj07oXMly0TCFAiotBrQev7k5hJrKcZn0RpNeD8qb5Ma4RD5kzrwAwg245urw5HqU3cPcVJp/2TfWAOd1q3X1jocd/AsEqn2WK3mu8+JVXA+B1owOqf8wjnmT54fVNUByP1qH3LWsxiYeCfIxMvvowrinyGBtxhkc5DEIycT/M0BGNHQaGa7OrfW9TJRWtnZpjRYF4m/vlNqeqq/SfB5vW/7je+kpIyJuV9fQVsOgE9bOxRsiD8InPnpQzofnuGGu+ob64gBJtAfpWKtNiDHE6pr5ZLr85Grpzi7+GbYASycFEngUTAn1V3o9sA81VITXPqAUJciKByWGSTLDQxzHBzoDWBuj9nXI56mnKGqSFVlkU81560+Ng65fY88o6XxWx7xQO4HIDriDUM0NeOfhEyLFJ9WNUt65jUzD7T/seqRMhVT0O2ba0l1FRhRPJO2zGPVpKTzkkno4Q9mQcEafxzteRCMR4FavHqBZnMmWQFDelZr9KJ+eLs7Xn0PBDsv6yIQ8NdOCiJUWVoTnxmRszTw16shpXnKOhEFJ5upCk3TqRaEafJPYMk0lSETn7r/Jr3lRxuSONsV0+YdqaPP5/+MQ6vlMTSzmkJfw6ZXt/hzgNVMO1YvS1+15w2FNGm4sjxazgJytDqMmtEXHXGTg+O6Uehn4znuSsu7WYVVNERUGE8YxmlOxaEHLB61
 0XlvB1/v
 +g+F8PHui75zC6eQ1AjWy5QSUeCKdMzFH9O7ObshWQYaM6RVEj4WsmN+zjT6WkKOlbygAzEwmOBc4oF6cnkbfRVIso84AI9moGgKE60MUeunVoNMdMRyBRH+8X4ePOYsOcFU4oWkUOKvs9EvhINii9b765m3IrYIkkopTrDqRWYXVmpAGjr/615SL3VuxmufjKQBx3jPjTNwuFjzcFtRECqdGT7G68R9vKfqVFntMDIGlnbVcMbRLTO1n9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mempool_create_node() accounts the struct mempool and all elements to
the caller, but the array of element pointers allocated by
mempool_init_node() and mempool_resize() ends up being accounted to
mm/mempool.c in /proc/allocinfo.

Let's consistently account all mempool allocations to the caller, like
ptr_ring_init() and ptr_ring_resize() do, by using the _noprof variants.

mempool_init_node() is only called from mempool_init_noprof() and
mempool_create_node_noprof(), which already set the allocation tag.

While at it, make mempool_init_node() static and rename it to
mempool_init_node_noprof(): it is not used outside of mm/mempool.c, and
calling it without an allocation tag would be wrong.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mempool.h |  3 ---
 mm/mempool.c            | 19 ++++++++++---------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 5444dcb63efa8..7f8e257017c01 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -38,9 +38,6 @@ static inline bool mempool_is_saturated(struct mempool *pool)
 }
 
 void mempool_exit(struct mempool *pool);
-int mempool_init_node(struct mempool *pool, int min_nr,
-		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
-		void *pool_data, gfp_t gfp_mask, int node_id);
 int mempool_init_noprof(struct mempool *pool, int min_nr,
 		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
 		void *pool_data);
diff --git a/mm/mempool.c b/mm/mempool.c
index 5e0ba516efdbf..30cbe44d464b3 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -243,7 +243,7 @@ void mempool_destroy(struct mempool *pool)
 }
 EXPORT_SYMBOL(mempool_destroy);
 
-int mempool_init_node(struct mempool *pool, int min_nr,
+static int mempool_init_node_noprof(struct mempool *pool, int min_nr,
 		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
 		void *pool_data, gfp_t gfp_mask, int node_id)
 {
@@ -257,8 +257,9 @@ int mempool_init_node(struct mempool *pool, int min_nr,
 	 * max() used here to ensure storage for at least 1 element to support
 	 * zero minimum pool
 	 */
-	pool->elements = kmalloc_array_node(max(1, min_nr), sizeof(void *),
-					    gfp_mask, node_id);
+	pool->elements = kmalloc_array_node_noprof(max(1, min_nr),
+						   sizeof(void *), gfp_mask,
+						   node_id);
 	if (!pool->elements)
 		return -ENOMEM;
 
@@ -279,7 +280,6 @@ int mempool_init_node(struct mempool *pool, int min_nr,
 
 	return 0;
 }
-EXPORT_SYMBOL(mempool_init_node);
 
 /**
  * mempool_init - initialize a memory pool
@@ -299,8 +299,8 @@ int mempool_init_noprof(struct mempool *pool, int min_nr,
 		mempool_alloc_t *alloc_fn, mempool_free_t *free_fn,
 		void *pool_data)
 {
-	return mempool_init_node(pool, min_nr, alloc_fn, free_fn,
-				 pool_data, GFP_KERNEL, NUMA_NO_NODE);
+	return mempool_init_node_noprof(pool, min_nr, alloc_fn, free_fn,
+					pool_data, GFP_KERNEL, NUMA_NO_NODE);
 
 }
 EXPORT_SYMBOL(mempool_init_noprof);
@@ -333,8 +333,8 @@ struct mempool *mempool_create_node_noprof(int min_nr,
 	if (!pool)
 		return NULL;
 
-	if (mempool_init_node(pool, min_nr, alloc_fn, free_fn, pool_data,
-			      gfp_mask, node_id)) {
+	if (mempool_init_node_noprof(pool, min_nr, alloc_fn, free_fn,
+				     pool_data, gfp_mask, node_id)) {
 		kfree(pool);
 		return NULL;
 	}
@@ -384,7 +384,8 @@ int mempool_resize_noprof(struct mempool *pool, int new_min_nr)
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* Grow the pool */
-	new_elements = kmalloc_objs(*new_elements, new_min_nr);
+	new_elements = kmalloc_array_noprof(new_min_nr, sizeof(*new_elements),
+					    GFP_KERNEL);
 	if (!new_elements)
 		return -ENOMEM;
 

-- 
2.56.1


