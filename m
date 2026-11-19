Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAC9606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NkR1Zgr5
Received: by kanga.kvack.org (Postfix)
	id 95C826B05D9; Thu, 19 Nov 2026 03:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936236B05DA; Thu, 19 Nov 2026 03:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 870F16B05DB; Thu, 19 Nov 2026 03:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 64BB66B05D9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:52:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05060A09F0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:47 +0000 (UTC)
X-FDA: 85451253216.12.C57443E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 50AA4140003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:52:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NkR1Zgr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795078366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxs2QZyxzlyoNxD0Z5dwz7vh5ESfvCmKKELYHd8a2JM=;
	b=ZXUjnTvIt8Gpnu5mkr2yrYGL78Gs1gmAQ1jpp3kSplAmDtfOv8Uy6MSFQE48+58qbKOLpK
	Nf5BjmaCFiLDq2Yr21q+Xrua9xwnr1bGnwB92/3j383pyEYwHTcniqIaS7AYcnuZq6S48D
	lhvMP801obA1+TTZoCc3W888isV2RZU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NkR1Zgr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795078366;
	b=mYM0FbOD4qLiwT0AcuJOuwF+qkAiWIiNoAXz1U55w1UzyeflmJiLlYmC83QZT1xaHE2vGK
	6ITFw4yg8cW5RMDKMqSxk1Pu83LnqFYdMX2SlSKlL4zBltdzWn+PRemVLVvklTilzBzOn+
	xv3nDN4MMDq6ocQmxNCapIhJPes42rA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65B226203E;
	Thu, 19 Nov 2026 08:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1293E1F000C4;
	Thu, 19 Nov 2026 08:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795078365;
	bh=cxs2QZyxzlyoNxD0Z5dwz7vh5ESfvCmKKELYHd8a2JM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NkR1Zgr5CKS/Oj/KkYEh3nN4wVmW6VxPYpRt+PIQc1w5oiokAAnrUfNoX/Ek8Mmc0
	 ZjlfV2RzBQOVjAKToTfLu6hkzZ18AcADt9TpoSFaCN+3BRKzXIEasKc1AVpPsLahxk
	 MfxkxEVsjzosbMP2yWgI3gtk2p9IRw/QzSfvmAuT+E5wX9H96FL9bOtfFrUYte0Tac
	 Gl4eBZ4rRdRJCZ6IqYMppFnthKSCEIapRyXk7fTjhN74Yg25tDfviW7mXwu4KqtR6Q
	 5xRkxbdqXHISBJdT+P9AVNESfKdhV6B9mC5hZjkFnKn9OJyoFAuobYLVyExygb3BPq
	 CqzNrsqfFQoQA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 19 Nov 2026 09:52:21 +0100
Subject: [PATCH 2/3] mempool: fix missing alloc tagging in mempool_resize()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-alloc_tag-v1-2-efcccfd3a9c9@kernel.org>
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
Cc: linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2506; i=david@kernel.org;
 h=from:subject:message-id; bh=LeaZUZfX3+uSqdQ+Wwi7Y32TzshGWroq5Yv+RXN2CcA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+7ThfHWNsbFgoUqifY57/d/a7XuEypxdTdYSfuCvtO
 1xiFivQUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwETEXjP800oJU7/9temdAz+7
 ZbD1h3Dr+XfkOS10XGOCo/mtE5svMPx3U5nLxc1m/sNbKUt66bPA9fOS+g97x3mrWdfWnj0cqsc
 JAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 50AA4140003
X-Stat-Signature: a5h4yfdx8fb9cfdh1u1oa4g9qrrme93d
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795078366-912549
X-HE-Meta: U2FsdGVkX1/0HocZp5a+FiltjDtyubQNWKhPLHt3PIbakgvSTIKotX0PavsAcJv1ZxBgtrHgGiNJisS/rC8Z5JvbHv/po4zfcppeogQrrIJbD8V3wUxJTlZI/qq7Qfkgvwb2BhXeNqfYMvRtDMhmsVLrFBOO4Eqb8ARaXTrVXKPUJACb8CDHyg/AmpfE3fCMTi4MBupEyYa0KEIufrtiWqnVEdaSMY9C0L+tcq5eSEyNFBEFmmmiF/Zv5ZB9xqF9Fub3+PNhuAVOGlIwgrlyQ3cWiALHZjYdRzAdq7lox17AT4ITf7kjMMyoT6v1gpq+FavIu++vkqaDh4Eav5FfzC59+NzSJyDlu8993mHPooAj69GoOtgNWUh1DOmmvkmtTWdh+uSdbi+UTbdkOVrojg858Dxwi3X+XnXIgQWSYoXQj4tqwlh7fdNQXB/yf4cbajS9DXFeYTvpztGWOsrgdv+mNKp432qJXQbznXwIMEfABv09CuVbQxdB9N8Ei8U2WS/DbOw1gGPz5KTOXyMYnIQYo27zmiTzLQeWsXSZQCSMCpmAJXzK7MoFgTumb1i0ZKXg5z0p18SFbnOm4BqIDii2ZHpQNLQ/xUO6Q2FkbiDcuQv8AyOhpOPhrtj/VFUb7dNtA8pxgAvbyMPhkFntjY+DFotSlngTAfNW2Xh67vfq3DEVAoi6mT025ylQoR2IbKaCLwg9ITjJoHCnYQQ5Z9PfcajgWl4zMyXhVNRcixHEdY5DrgFFkhDoP0TJYlDpmBRLf9SlNJ6xHo4JUVUa2tauacL/2KURNsFs5+n9uP+Ar38VYTN8Gef3ZzmEt2i1pTWSlytqI5PaRc9UKFYai/ydIZLRscooJ8NQnJ1xeJWBS53t/xbc0NBS+vcXiJdXTrQten2uZx5ZMQ6WNdKerLZ2IOb7dlBRx0eOZZgJJXfix79v6+AVadc9ZdstAqu81wKJhUp1w8SZBqev0Re
 FJfZT3kP
 woWlVVy9D01CSDpsqqhMMT4GXTPBq20joHNjwylLdhRqZ8mneQ2Mgky1cf/sq/kJSppi3kzl2trd1lxgPMrbLvc4pJ+ZuODmYwgsxUVhFZiVOVdIA00h61dDYncR24TvWF3qVj/poEltU/fYAD4X3N+YvoRGa/mTiS9kw4+LqzJzMxNJqzhNvsE+/3+58qtLhJI/Wu+9T52Wml+itIWIR3m9NGbRMMD2p4+Buj7MqavxJ6woP/ETPMfK7G2HEJ6puJXrzpF+mbL6KblDXZED+OmNPmvbB92iKIV6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With memory allocation profiling enabled, mempool_resize() allocates new
elements without an allocation tag: mempool_alloc_slab() and friends
use the _noprof allocators and rely on the caller to have set
current->alloc_tag.

Unlike mempool_init() or mempool_alloc(), mempool_resize() is not an
alloc_hooks() wrapper, though.

Therefore, the newly allocated elements are missing from /proc/allocinfo,
and with CONFIG_MEM_ALLOC_PROFILING_DEBUG=y we can trigger
"current->alloc_tag not set" and "alloc_tag was not set" warnings.

Fix it by turning mempool_resize() into an alloc_hooks() wrapper, just
like the other mempool functions that allocate elements.

This has low urgency.

Fixes: e26d8769da6d ("mempool: hook up to memory allocation profiling")
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust description, remove kmalloc_objs() change ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mempool.h | 4 +++-
 mm/mempool.c            | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 6da502aef2f71..5444dcb63efa8 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -59,7 +59,9 @@ struct mempool *mempool_create_node_noprof(int min_nr,
 	mempool_create_node(_min_nr, _alloc_fn, _free_fn, _pool_data,	\
 			    GFP_KERNEL, NUMA_NO_NODE)
 
-int mempool_resize(struct mempool *pool, int new_min_nr);
+int mempool_resize_noprof(struct mempool *pool, int new_min_nr);
+#define mempool_resize(...)						\
+	alloc_hooks(mempool_resize_noprof(__VA_ARGS__))
 void mempool_destroy(struct mempool *pool);
 
 void *mempool_alloc_noprof(struct mempool *pool, gfp_t gfp_mask) __malloc;
diff --git a/mm/mempool.c b/mm/mempool.c
index cb74e718b2c65..5e0ba516efdbf 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -361,7 +361,7 @@ EXPORT_SYMBOL(mempool_create_node_noprof);
  *
  * Return: %0 on success, negative error code otherwise.
  */
-int mempool_resize(struct mempool *pool, int new_min_nr)
+int mempool_resize_noprof(struct mempool *pool, int new_min_nr)
 {
 	void *element;
 	void **new_elements;
@@ -420,7 +420,7 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
 out:
 	return 0;
 }
-EXPORT_SYMBOL(mempool_resize);
+EXPORT_SYMBOL(mempool_resize_noprof);
 
 static unsigned int mempool_alloc_from_pool(struct mempool *pool, void **elems,
 		unsigned int count, unsigned int allocated,

-- 
2.56.1


