Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D133CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AABAF6B00A2; Mon, 15 Jun 2026 07:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84676B00A3; Mon, 15 Jun 2026 07:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0EE6B00A4; Mon, 15 Jun 2026 07:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E27B6B00A2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FCCB930B0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:26 +0000 (UTC)
X-FDA: 84881991852.20.1FB5B84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7F304140007
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k53SX+hd;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524524;
	b=dI5ke7rE/SaskrRBv4zZL1E4c36pZajvSBESPNM6bwiA/2OY+jSsrHqG4NDLMAMCyOgr2y
	lHM2/sWp3ReiI+UhxNXPUhL7eblBX5FLYdXsmy5spzmvKfJ+QM+CAwiOsjdhmvY/a/ykGb
	SuvJmqDRcSS6oL6y27aR6f41Ve+/eBE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k53SX+hd;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebzcFj5BKF/W8hw3xShUpyqxyWez0/CEroCTp+cjzdk=;
	b=3ItN1gDiooWvKtFhxAErs0rgAWItxUeE/CFyN7w9Nsl0fB1YASq5Svaf7W/sUDLNvXwQWE
	Kbposu0Idg5Xo/DYGP9Hu9XTIEdjEYmGSJxu/aDngUZjT8OdcMYuipmZzAf/YBvGwT+NfL
	kViH8hX4M3b9qZI+eHDahN3L3tozdMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA4F3441F8;
	Mon, 15 Jun 2026 11:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C20E1F00A3D;
	Mon, 15 Jun 2026 11:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524523;
	bh=ebzcFj5BKF/W8hw3xShUpyqxyWez0/CEroCTp+cjzdk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k53SX+hdNKSO4F+2QdGRewU07K+P4JkgXQWXn5mkCdLhn5MRVSmjAPyFQJLlFqOI6
	 6/h9nqvrzu9UK8w2e265TXGtJydhU2AKlSl/t4+8+EBhSXwQQhPQrEly4/idNyC0iz
	 xcFdsz7LdrfKUTktxP053HuNgOsvPlIu3HK+6zoYbVE+MyixgU8PcJnVvrfVZ+aheN
	 og4wmzoVBOhi7f8zA7a2/knEFVH3wHTvDpAoow3PzL3xHQCwhaBsHxuu9j9/QdgcnG
	 BGilDC/BybWyAL6ULwZRohrt8M0BAnLL8cXytktfBRqBxXALiY4m4cmqYgtI3xbMJD
	 DC/x0AHo67yiA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:43 +0200
Subject: [PATCH v3 10/15] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 7F304140007
X-Stat-Signature: m7acgxkcuihnsiitr599hyz9hd675ch7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781524524-445244
X-HE-Meta: U2FsdGVkX19XXzTRIphMD3XoUPtq3YSs/LqFLpvz99zeYQFnMa56mo4QnwOfAK/8y8Shl1lc9ENhhALIwkSLKPjy3cjcqxELzkZZ4sM4EWk+97Vb+iYfmjN+xWltRVzUNOVGX5vQdTfv5GYkSqk6YlqXVSKdT+pD0EvFPCu/MlaAIu7ZSl4WllpBEZsiv4p6DUO160CEEDLQHfCGKWYFJ4hdJ73YibhfPKL7WF6nDb3bJ3lyNhIgwHFtOSqcawvjNmkP20P058sfRBKAnYL9aZsIrSmggl9v3nh7nPKpC11YOp3LducBDy9iG1L5rzE5gEdapskNEE+SeDlZ08ZQDRFNgbJOH4Gc2b60EuUVrWew9rjYRVsUfxgmYkbqkQExdRgfswWLGp8Em3xCkt4eXgFXRTVZLqun3bxIe0DNTWAZbCpF8Bk9trKecubQfTOITEY/r2PHRlwCt0E9n5wkW9GhltGgYfiw3pyXBV2tVi7hO1BBKK0UQ5u2MpcweTe5h1X9NklQxleBtIh/K+OtEuHCw/9yxj6BLD3fIFtoZd1S+Jk5Kci9j7UOzpd1pyLvT5QT+cH4yEE+alr0YZF2pGTPQTBb6WT5PnA1WapFncv7E/eXegzvVdf5/AAu8dQxHOB59UjDJ6m37iKtwgzl6cVWGu1bqRVV9FnxvNjfq9re6U/rZZ0gJtFMEPmgeIDSqNf1lArts618vwfWpUNb9mLLsKiA4Th0cVmdQ3LdEDeN1P7cGkKzmAe16LEKniwx4wWLFVrYMVRb9h8vUmsTSutypgorDBTz81djSrBzA0tt9ejuW907uRbGkO44ywR4DoyyZUyoaRaoMcTKKZf3LRLkZRVZOZGMHYYevbEuD2ULAT2SQuI0+brqfk8TP8QmTSO/JMaZ4ngtk6DfRW/ITEWNilQOQAyn5eYbjc+QV1g/KUiS95Fs+j/AlTpKLd4Fgaaq0sy6tTrFYnn/Jce
 0MYzagqu
 xIrj/loaVyP/UakSo5KLf4G7pHgiWvnN4UzsldDP6UGMNcLGYIs58XmNAtT1lGfCwdTILnwH625IjrZjFl3jB3xbQ+1vqR2uj5GYEpa0HL1VZp21/i9RITtQ+/8FEx+ZrUX3sxh7hGf5Z6V3+LfwW0lyZ0IhpX8sulSfXx6kI7a9AZE7onMB5oTOFu+7L3GJ7G3JYTTP88TpwPQKbWztAAd1gMSsw38b8NqKu+Qb3Kf2lB3nI24XozuoRz1riTqaVV3HGcbwEfDI5t/PZKaayMjz/S3iAzMozJZWt/YCZjZQp85fA1r35Xuu27lXctJkPigua0Sl2KIX+uHt7VUihLUQwTgUk7JSvFTorBSpu5xBo8otnjhDXZHu+yCzEv+1ds/z+wAHWryy68oEKKbqAYEQL5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last user of gfpflags_allow_spinning() in slab is
alloc_from_pcs_bulk(), which is only called from
kmem_cache_alloc_bulk().

It turns out that gfpflags_allow_spinning() is not necessary, because
kmem_cache_alloc_bulk() is only expected to be called from context that
does allow spinning, so simply replace it with 'true'. This means we can
also drop the gfp parameter from alloc_from_pcs_bulk().

With that, we can remove the "@flags must allow spinning" part of the
kernel doc, as there is no more connection to the gfp flags in the slab
implementation.

Also remove a comment in alloc_slab_obj_exts() because there should be
no more false positives possible due to gfp_allowed_mask during early
boot.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 562495b80d74..81938774098b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2171,12 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
 
-	/*
-	 * Note that allow_spin may be false during early boot and its
-	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
-	 * architectures with cmpxchg16b, early obj_exts will be missing for
-	 * very early allocations on those.
-	 */
 	if (unlikely(!allow_spin))
 		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
 				     slab_nid(slab));
@@ -4830,8 +4824,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags,
 }
 
 static __fastpath_inline
-unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
-				 void **p)
+unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *main;
@@ -4866,7 +4859,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 		}
 
 		full = barn_replace_empty_sheaf(barn, pcs->main,
-						gfpflags_allow_spinning(gfp));
+						/* allow_spin = */ true);
 
 		if (full) {
 			stat(s, BARN_GET);
@@ -7331,8 +7324,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
  * Allocate @size objects from @s and places them into @p.  @size must be larger
  * than 0.
  *
- * Interrupts must be enabled when calling this function and @flags must allow
- * spinning.
+ * Interrupts must be enabled when calling this function.
  *
  * Unlike alloc_pages_bulk(), this function does not check for already allocated
  * objects in @p, and thus the caller does not need to zero it.
@@ -7370,7 +7362,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 		size--;
 	}
 
-	i = alloc_from_pcs_bulk(s, flags, size, p);
+	i = alloc_from_pcs_bulk(s, size, p);
 	if (i < size) {
 		/*
 		 * If we ran out of memory, don't bother with freeing back to

-- 
2.54.0


