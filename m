Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A7FD730B5
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 07:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FDC6B0005; Fri,  3 Apr 2026 03:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38036B0089; Fri,  3 Apr 2026 03:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74896B008A; Fri,  3 Apr 2026 03:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8D9D6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:40:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DCC6E07DE
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:40:42 +0000 (UTC)
X-FDA: 84616447524.09.EF5949D
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E2C7A000D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:40:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vrmH/sJ1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775202041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ln5XzWMFyTginHCaMgw8DBIoTgwuT8dHU7rE/Vwl3Rg=;
	b=8T2rL9oVIpfX8sQPKalOfOgmx9i3Fcc5aG8QRoU0l1ISEdi+EyS8L43ObIlr7zqYh+OEpg
	Vc0uLQOCdsqJiJzpbsoAFBYu3abBLr4pleXjwUY+Syl7Wt4hQsvUDJFVwl/Aa45Tg8AQOV
	S6l0ukD08EYazx7z/od8ILeZqIqmPBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775202041; a=rsa-sha256;
	cv=none;
	b=aabj28P6qql1ITGnc6uLf2NHdptUvx6MgLcrLe8PGSvM9vxMu1WhnpNoLAX4AANVpOEpYe
	iEcff4fH2K51Wo5AFN0CHc6WsTc5ppik18ykdTi2Vi41ao2GCU2tuvEgye1rW3finX7oMf
	s/QMPNNr+WhWAhifJei+DTCSTvIxFEQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vrmH/sJ1";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775202038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ln5XzWMFyTginHCaMgw8DBIoTgwuT8dHU7rE/Vwl3Rg=;
	b=vrmH/sJ195nnxnWxwc5peq/lAcTBTfLjp7Pra4SR4+bkQWxopN7e2Koq7r6wRcIZGaZKN4
	6COnGKYwqHEyKqbgf7PmI+K2zOGAc68s/Fjcg+ZRrvGZshZbjS37udLq8dSKZEkvF7G1ly
	93BRL71+pjphdSe2J2TKup50yvZtkHA=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry.yoo@oracle.com,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle remote frees
Date: Fri,  3 Apr 2026 15:37:36 +0800
Message-ID: <20260403073958.8722-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7E2C7A000D
X-Stat-Signature: tn1ug1psmgm6fhr7dwfdon4bcw1xk8nk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775202040-566500
X-HE-Meta: U2FsdGVkX18qhze0f3k91LJslBglHnrH+vfmRhIwAI2kSar5SeCpJvry4ohDE7Tr1DshE7mbu1ZnmDdQwSNY9k18JL/mUC+hjK113zAPioOs0XOPCoHmcQ1ESw7wSThTgDDevVfLVIX8T1ORPo+NWcZyQ/OS9qYEHMe6vG4FCKfBbPeVe+4sZ57IHj8bwXyYsIIgvbeIDPGOG0c7TYeShmgQwSh93uMJlXk1oEIlnGFiRr1VYh/5yqxorojHhYk6I7KcxKzafJssDR2rrfn1cNcMOgUhqyEBXTpBiXyzcwkGVapaPBICwau+u8bD5Dcs8u3qe/qRVYlVJB059g8UogbuCGxlOUEI8qL0JhvfsOaW5YX0EAo8HC/k+5t+umNnqHeg7XlQvKjXOdx7/Tx17Juq9TNh+Rph/KkFGtJBkoIrHpPeQOzJTk098/10Z0xwebVcrAJKskziAAsIyZ26Wy/70whwlMJCWLmTArjC6G52VBXkOWENvfJ6uuCoRequyRBdtMRBPhJRXDvB6/T7xRumSQtpPjCgiVhXQKHbkev72cABIMeORJa8teB63nVn2bQXnrE2XCvoEKof8mS9uvJ7qZJ2Vu1M+C9MLf8hvjZtS4tFBXk2oZcYSvTMmqDwKnWhBZbsduU3fWwhdKWCbtHJGJOT20P3BBNeL+bIwtqhIK6ugkjopIdUWbyH6HOrqCoupR6lsQnvOofkuFH/75jifrWHd75AqavxpkYwVo86pvTTEvARoIqCaFqAl4BvJ7is0mVJ8skg9d8Nj27JkeWAQIl00oWUazbt7sOBryYjwkpoaG0xXlpXtYANT6Ttq2a60if5SrqlAv6oPXH8NviOnKTTEZlvU3zPwDTsO86VX6r0Ia0iEhLQ4ZAELaxwkrN2y7+tvvkdIaa48N1IfzQm4J/isCUz6yLoY0XyquXsT2khgiErlnrn57tQvJ4RxMDgs30F7if7pETqqpq
 TekWT4Mm
 GSELInnY1QC/+/tHC/KapZcpVK/Zd+AIEphmuE2WHHQ0MtzOdUfn3mlgQyi7c0JZ88dZRsFclfy0ZzcHw9BGxZX9dl72xNrXSbyRdGEy3bNiB6B2mW1UFwY+nkWe+nAEYMsqIaM4Hw3c4lqXWqilUWOjko/0xztNnH0z7ARjtPZnfYF3dHfLIYKCzF5AVMHab7BSNVi+fCz9DbUni6nwWF84+EvOmXE+VaYrldjKeSw823i0BBunsNbZ09f9zmG2fAC5tzrcPRDpm/0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hotplug now keeps N_NORMAL_MEMORY up to date correctly, so make
can_free_to_pcs() use it.

As a result, when freeing objects on memoryless nodes, or on nodes that
have memory but only in ZONE_MOVABLE, the objects can be freed to the
sheaf instead of going through the slow path.

Signed-off-by: Hao Li <hao.li@linux.dev>
---

Hi Vlastimil, this patch depends on a prerequisite patch[1] from a few days
ago. I'm not sure how this should be handled. I wonder if Andrew might put them
in the same tree.

[1] https://lore.kernel.org/linux-mm/20260330035941.518186-1-hao.li@linux.dev/

---
 mm/slub.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fb2c5c57bc4e..4927407c9699 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6022,14 +6022,15 @@ static __always_inline bool can_free_to_pcs(struct slab *slab)
 		goto check_pfmemalloc;
 
 	/*
-	 * Freed object isn't from this cpu's node, but that node is memoryless.
+	 * Freed object isn't from this cpu's node, but that node is memoryless
+	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
 	 * Proceed as it's better to cache remote objects than falling back to
 	 * the slowpath for everything. The allocation side can never obtain
 	 * a local object anyway, if none exist. We don't have numa_mem_id() to
 	 * point to the closest node as we would on a proper memoryless node
 	 * setup.
 	 */
-	if (unlikely(!node_state(numa_node, N_MEMORY)))
+	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
 		goto check_pfmemalloc;
 #endif
 
-- 
2.50.1


