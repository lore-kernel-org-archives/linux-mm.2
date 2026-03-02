Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E26AE9B34B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605246B0005; Mon,  2 Mar 2026 04:55:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A93A6B0089; Mon,  2 Mar 2026 04:55:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF1B6B008A; Mon,  2 Mar 2026 04:55:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37BEC6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:55:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA8E9C32C2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:55:54 +0000 (UTC)
X-FDA: 84500666628.28.9923D67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C191A000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:55:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kER6V9GK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SXhKVYL2T5Yn7wk0KnH6E/W+8PWZz/NIkWCZjNorJqM=;
	b=QGkdpjjU5mG6qT4PSO7W+9K5jpU6x9ZwyS05D8xEj0Dqceqko0za7xNv4XE6K3pgH9o7xq
	EjGep8kP5LC/4e1MP2KOJyqjA5aESG6XWJH3LR5a6mc1RhGj6AHbjHFzOdxsKNAPCS0Pq+
	dm7XdmVPoUlHBD2kkndw619IzZjDSy4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kER6V9GK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445353; a=rsa-sha256;
	cv=none;
	b=7OhhDcSNXXhnci/weiZFHTt+RQxNn/nA1GLi7n9psQkPYsRN4bFghe4g9HVoIiI9BDjoBN
	+18+lmZl3MSCyGkSKRbVSVAjNwdyAiQJQqK61BkIbF+rEkpDtToaiW6wQFE/Y9HBvnMskJ
	hOLcg0l6wmDMRFEz3HzV4NUsgPlzBaE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C18A660008;
	Mon,  2 Mar 2026 09:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53495C19423;
	Mon,  2 Mar 2026 09:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772445352;
	bh=baMHQ+epwV7528eqrCDXzQnEtKpJ0piYIDHEF8wqGvQ=;
	h=From:To:Cc:Subject:Date:From;
	b=kER6V9GKv2gWtuTlCGqhiEJO6jHnAn2bc761DfOsrxnkjFj0Tbk8h45aeIeCb4SZp
	 9PEkkeeaLilDKfDqioTLJpBQ1GSU3Bkjg9U5zqgBor992dYrkytXkarmFIApB3oLh/
	 SCASmQHA8Ja+ZipqZDgNBO8AXhfY9IDDDyWWeVAz84HzcmR26X1wb1aDRv0OLntU4R
	 hWBsiruMkKQz1BJEVPh8evSMxdf8j4XiYQW4Za3HHW/zXZGHU8ao33y6fL+Jt6r94b
	 vKegqlMBioJWx/Sy2XwO+tTogwgRPeAifcU9Vbb/RS9Py4/o7eU9oBnojVFAL2eIk6
	 O+8VhalSzt6aw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if blocking is not allowed
Date: Mon,  2 Mar 2026 10:55:37 +0100
Message-ID: <20260302095536.34062-2-vbabka@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C191A000E
X-Stat-Signature: y45umq4qj1smf3hw4u9yhbb5x5i1p8h8
X-Rspam-User: 
X-HE-Tag: 1772445353-192139
X-HE-Meta: U2FsdGVkX1+UvNNGQIUEja5MbT8Z/DJ/GIVY2fJUyLSGFmTbGxErYYH1iVBpRn9GpOuhh3vV/Xpqj/fPEhYsm/IA0cUdcDQ/j4TXCCLqeEfubpfSPmE9VemaN0zJ3YTMNmW9xeJYDyVWh5lWvJtnR48/1BO3JAOwBzfOW2trcfiJeWOnDRmEfOD5XeHaVBZy/W6fqQfedjhf3NxQ+ZTXXxYfDhymdYROdImcURwby16MJdp2Xz55Y1mglZeqvaHMgETV75M+fsJQ7/eBO/uVsua4HYbDRU3rUVPaHyp+6a1pk2kTfRwkn7UbOKwIciG+A5I9YX2SKsLFhXhkxbtHs+GoUriAuW75kqxzeLQuLG5YWwH+iNxeDxscGM5eMUb9GnYZMtbtokhhs7MyhEFWVo1QmPczxnQa74aP0N5tB5tSZaUAEmf3Fz9pJqbVvqtl2ZMHAK9gI5iLelJV5TmCWZVPXSE3u8Oc7CF9Z8BcgwuOIVZ/bRhVmlrB8YvvCFqlNlDuhj32LpBQ8Dt1KFy6hFciqkx9V1vEStVyB5YzFu2m9c3Iqqp087y4SZs9zw0CR8eNM0P68iMX3eYayzzuA/rglUMS9DHN9eB67bNczxw7v+T+AqZITlUD/4K92bG2QusnJnmURQT3Y9eyD07BYfaHrAzqc2cwemjeAc8fZLJ2C41KwipRpWBRsr5Pb7GXJU1Rb+SyptKFrDhRo2FBdy3P758oRYq0n3VdELUG+fkUV9od89WhZ7Wq/osZ9dVKewPqr67CMpXMdwJJYHxp/TpuuSW7vsetaen+R71IuJt8764ZupGtzbNCgnefdtEegL2fG+kYi6WN7SpZIWM4cTeo2AvUe1LVMNW6VXyJr4AktkDIwdApAHYUr9erqNDvvnnm6eNOrY7uuGCt9YbA8jGCKPJ8Tg/J+BeyZeSUUG1x//5DRmEUgHM2d0gtkgSzpjQqPvKUOYQZ7ZyncgL
 nP8EDBNq
 nkhoiyXBZdigd2hAvzMo4QS5j5kJ0WKKNn6jUFuxHXf1w7pPWjDIj7BaIcu+8dFfsbQNV7te97ePgs2H+NauksrXl9axQTugtvmQ7xCqsATUe1u9aE2vUZxgPuz79OXDQMYFC1qgaPtWs6Z0SCq1p4VXZE8j7F20WNVY1uNFPf5QyE3wdkaQ9SXmBE64A7vsgHm81UtwScoobfyVsY/UUVAuRcB0vnbi9Sq0T9Jy+70Li5HWd6BEtulIP4VkEmyvJeiWZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ming Lei reported [1] a regression in the ublk null target benchmark due
to sheaves. The profile shows that the alloc_from_pcs() fastpath fails
and allocations fall back to ___slab_alloc(). It also shows the
allocations happen through mempool_alloc().

The strategy of mempool_alloc() is to call the underlying allocator
(here slab) without __GFP_DIRECT_RECLAIM first. This does not play well
with __pcs_replace_empty_main() checking for gfpflags_allow_blocking()
to decide if it should refill an empty sheaf or fallback to the
slowpath, so we end up falling back.

We could change the mempool strategy but there might be other paths
doing the same ting. So instead allow sheaf refill when blocking is not
allowed, changing the condition to gfpflags_allow_spinning(). The
original condition was unnecessarily restrictive.

Note this doesn't fully resolve the regression [1] as another component
of that are memoryless nodes, which is to be addressed separately.

Reported-by: Ming Lei <ming.lei@redhat.com>
Fixes: e47c897a2949 ("slab: add sheaves to most caches")
Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b1e9f16ba435..17b200695e9b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4567,7 +4567,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4588,8 +4588,9 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	allow_spin = gfpflags_allow_spinning(gfp);
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
@@ -4599,9 +4600,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	stat(s, BARN_GET_FAIL);
 
-	can_alloc = gfpflags_allow_blocking(gfp);
-
-	if (can_alloc) {
+	if (allow_spin) {
 		if (pcs->spare) {
 			empty = pcs->spare;
 			pcs->spare = NULL;
@@ -4612,7 +4611,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-	if (!can_alloc)
+	if (!allow_spin)
 		return NULL;
 
 	if (empty) {
@@ -4632,11 +4631,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!full)
 		return NULL;
 
-	/*
-	 * we can reach here only when gfpflags_allow_blocking
-	 * so this must not be an irq
-	 */
-	local_lock(&s->cpu_sheaves->lock);
+	if (!local_trylock(&s->cpu_sheaves->lock))
+		goto barn_put;
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
@@ -4667,6 +4663,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return pcs;
 	}
 
+barn_put:
 	barn_put_full_sheaf(barn, full);
 	stat(s, BARN_PUT);
 
-- 
2.53.0


