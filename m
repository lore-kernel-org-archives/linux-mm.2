Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F30D2CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5518E0030; Mon, 20 Oct 2025 10:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576318E0002; Mon, 20 Oct 2025 10:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465E48E0030; Mon, 20 Oct 2025 10:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30A958E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:31:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB615B6BD3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:31:20 +0000 (UTC)
X-FDA: 84018730320.08.66EF915
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id E35CE14000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:31:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OaowyAO4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Cu1lxXRqsntQuulBb4j3CU9k50o6nIiJRnZhUDMzUTc=;
	b=hf4WCgpb8RgicuNFXfCbRUuxYkebuqtvn0Dh4W2kO2Y2pq213l+le5Uhxuw+muB+fT0J77
	iatBuoQC5YSLv7MHJZxW5ckUInFAkPxu+yzK+OyJE9sSaqyhvnnlCbvMj5owkhUIc03htO
	7r4v8NEdFKjH5/QKtA+9cSZvXgabeBA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OaowyAO4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970679; a=rsa-sha256;
	cv=none;
	b=agKRJ4v5+o1UE/4DkQQoPFzACCtb3bylQmATx2XjzbbqzV6U+KB/mVLYrMDAgest0kHNsZ
	0n+nMgc80egIHgfadI6009UxXeC//Rd7GLRjC+F6klglrlOPrTxazX4ZnJoaMS9TOfb4pN
	Nqavmzy+MIx/ZonHxO5Sx+wsBUVxqk4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760970676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Cu1lxXRqsntQuulBb4j3CU9k50o6nIiJRnZhUDMzUTc=;
	b=OaowyAO4SWsFDbxJ7QhB2O654+fZkKi/20KhisPHooP3XS6WsetNcFUjchcJpjEcHIYB/4
	fGHf7LoNt+FVqkGPP9bGk5Eb/Szc7K5s90gtnQc3OaiPcgB8b1/6ipX/VCXzpCQ6Pp0Mej
	hcQBUW5wnBQHGtXlpxSuXqZ4XQ2jRe4=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH v2] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Date: Mon, 20 Oct 2025 22:30:11 +0800
Message-Id: <20251020143011.377004-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E35CE14000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 4ernqzrqnr6q86ep4oeq7tdg8xy7wrqk
X-HE-Tag: 1760970678-404706
X-HE-Meta: U2FsdGVkX1+qW+pk/MSrFZIx4UkwobjIxKO0cQMJC/9BsozC5KEMB80S+gFgjkNY4EZOx43uh8Q8wxPDla7orVskJ+272t7/T2cJxXoZ9l8bd4khJ1bsUOXfED9Gi506y6JTEj8hrUoi08AAKlLVcXh2pOhq33pqF3n3qeG46sT2H8ghiSa9va00bVFrNx4hO+8UMrvWOSrkig4ZdU/EunwrZThI7sVjh7UN+wQlLaBzbjGeTjvlrRURgxLDcqoteUraLDIDMxVbJOpXoOdzPmsAlnoRwg9XdrMlwEaP3IjSVsv7qAT0F4SRz1Che1lQrtAgTtPAoJmM99otEff3IISMvmlPm/pl3CCVvXpRVYmz/ip3H+xCL+sDlVlDIXUD+/iCUFsOvMeo9cjYS/8GBCIpRgqoylT+BHASXmzgPdyt+OowHd2XuXvIiYDRfa4wYc3UURczpFPHz4dl133WnhaMYw/zpypuHzNZsyy+QkR+Lgj29UJ3zIxafUgflDDgQeUxtOfupRwyZO7QtP0/M/xXFNcm+ZTOhIvg5jTftk/YgMFEzxwGKKCWadNuPWAGTVmm0aMLl7AusMQzyGJm6zLTZzbOs3Xu4ECsz11uaETDmZODCNVUxzBAg8OIF8A7GtKt1DTCm7D03O/R8TE3rDqQmExW0z3XyrCL8bAffXmIOCRwq9nyoSN6LokwZioIVeyme4HTXeTf30+TFHvvJtuOT/lJNF5HT2uCt+LN7fYe1yMph1ir+xHrsfDLJoJITFg1okAFHjLpe+kRcP7IwVz1O4pfMPd06ePEmM4hXfElSHsnXZLypH1SuB57Q1z6NfIkX+jCJu1xllDqR2p7o+HLkti4XD/6nI2T50q9w1A177CHHo6S+aFEtavpaw/YiiodfADna6FtR1aAxlsIK2znXt5BfhFF9TfTtR5MVIsaXRwPGiFs3/T90ozRSJypw4STRrZH4yYc8bbYQ91
 t7gvc2/2
 0tcrUlCsVd82rBmmjFcWjI5QQmp8Q013WfadTrkBh0bnpfvO7yBpLR0tQIy8Yzi0F6+upSVZsPW0LpMXIYME0TcWufufjP/9ZMwlJNtTfPg8d74gheS4/ZRdGUbK7IB4TjdmjI/VWUMbKfzlMNeVQl6c7oQ0IR6WTNOD8Cp+qyCpmtefPrrZdEI4mdQXdQtq1IZ60v3pPJYXsOvAAQ1DJZCX00Fv50cG4zKhwlYaENk5c/YNiipmP7NNtkvpwp7NVe39xGHOEUGbJ2cqtIW189/Xd9N5RK2ibED/tld5rqYQvzU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

In the alloc_slab_obj_exts function, there is a race condition
between the successful allocation of slab->obj_exts and its
setting to OBJEXTS_ALLOC_FAIL due to allocation failure.

When two threads are both allocating objects from the same slab,
they both end up entering the alloc_slab_obj_exts function because
the slab has no obj_exts (allocated yet).

And One call succeeds in allocation, but the racing one overwrites
our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
allocated will have prepare_slab_obj_exts_hook() return
slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
on the zero address.

And then it will call alloc_tag_add, where the member codetag_ref *ref
of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
leading to a panic.

In order to avoid that, for the case of allocation failure where
OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.

Conversely, in a race condition, if mark_failed_objexts_alloc wins the
race, the other process (that previously succeeded in allocation) will
lose the race. A null pointer dereference may occur in the following
scenario:

Thread1                                                 Thead2

alloc_slab_obj_exts                               alloc_slab_obj_exts

old_exts = READ_ONCE(slab->obj_exts) = 0

						  mark_failed_objexts_alloc(slab);

cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts

kfree and return 0;

alloc_tag_add -> a panic occurs.

To fix this, introduce a retry mechanism for the cmpxchg() operation:
1. Add a 'retry' label at the point where READ_ONCE(slab->obj_exts) is
   invoked, ensuring the latest value is fetched during subsequent retries.
2. if cmpxchg() fails (indicating a concurrent update), jump back to
   "retry" to re-read old_exts and recheck the validity of the obj_exts
   allocated in this operation.

Thanks for Vlastimil and Suren's help with debugging.

Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v2: Incorporate handling for the scenario where, if mark_failed_objexts_alloc wins the race,
    the other process (that previously succeeded in allocation) will lose the race, based on Suren's suggestion.
    Add Suggested-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/slub.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2e4340c75be2..fd1b5dda3863 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 
 static inline void mark_failed_objexts_alloc(struct slab *slab)
 {
-	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
+	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
@@ -2136,6 +2136,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
+retry:
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 	if (new_slab) {
@@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * be simply assigned.
 		 */
 		slab->obj_exts = new_exts;
-	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
-		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+	} else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
 		/*
 		 * If the slab is already in use, somebody can allocate and
 		 * assign slabobj_exts in parallel. In this case the existing
@@ -2158,6 +2158,20 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		else
 			kfree(vec);
 		return 0;
+	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+		/*
+		 * There are some abnormal scenarios caused by race conditions:
+		 *
+		 *	Thread1				Thead2
+		 *   alloc_slab_obj_exts		alloc_slab_obj_exts
+		 *   old_exts = READ_ONCE(slab->obj_exts) = 0
+		 *					mark_failed_objexts_alloc(slab);
+		 *   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts
+		 *
+		 * We should retry to ensure the validity of the slab_ext
+		 * allocated in this operation.
+		 */
+		goto retry;
 	}
 
 	if (allow_spin)
-- 
2.25.1


