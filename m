Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D42CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C147C6B00A1; Tue,  9 Jun 2026 05:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5476B00A8; Tue,  9 Jun 2026 05:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB796B00A9; Tue,  9 Jun 2026 05:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1476B00A1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52FCA1C1DEB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:36 +0000 (UTC)
X-FDA: 84859823832.30.FDF738A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A87A340004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VHTWhGwP;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZczlrzStgvNUrq+xcJH6QzjOF3uagfFkpBMhQ14riTI=;
	b=2VUhe/ocBcur525KWVDT66SXi6LjX+o4WSLx6RYRuCbaUCxtU+Kyg5NKGwbQjr0egr2Ddg
	OyNlc+BHYr4vw1+W/zv6dtUrWsKXUx5KaY5GDOFDOrOSdp131aGfTND58mtW43ibAyJylA
	Jgo4SFi9v7FGEPqlUSPADFbWMS7bnhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996714;
	b=ljZ+zNjZ5hlpxDGIf1UmzXU/8jgCE7DXv23dhrPbh4UzDY7dX62nMdU1kjUc/R2RCUWz7n
	O94RhI2lMVvm+kpLY+gpHBWbjWCF5NgdhqU2fxHv0ovi2BJPv7lIsBbZwA8QA5nO0F0+SA
	cYJWSI8n+PRa0wmmtkDvoysqOqantsk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VHTWhGwP;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44994601DC;
	Tue,  9 Jun 2026 09:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9931F00898;
	Tue,  9 Jun 2026 09:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996714;
	bh=ZczlrzStgvNUrq+xcJH6QzjOF3uagfFkpBMhQ14riTI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VHTWhGwP6KzULqoJFDnEfw8r+gua+LReQ5BjDbuxlv1tLnr+2OcROBjdWutK33N25
	 hQ8J2kPvJV/UHss0XJnoNlQ+dMSoyJJoyHJjotpf2X3//5yRTg9xa1Y9Tm1ur3JvAY
	 qrPTq8wPA/Va9C0fmetv8KXzvpRRHPfnRhdWZwckDMdkHiOra3gslWJgok5ew3uZK7
	 Tez3U/cMR3ZyIDTwVOEu8oFMlk5ouiz8unoGf7nMNRl020Wo91vobGPOKAYAYHpoka
	 gkrN1iMMk4iKtv4UhsWLbmbUDiSzlvPfP9qIQWoYbSVTFhtE7CyewqCphH+efZlkY7
	 ePbPhuncpaujQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:55 +0200
Subject: [PATCH RFC 10/15] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-10-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A87A340004
X-Stat-Signature: onxst5rdxxnsecdejhmum9g6iuefy1oz
X-HE-Tag: 1780996714-340616
X-HE-Meta: U2FsdGVkX1/bPkKlgHNbE3pP3gVddww516VOdUtQd9yn389yKWCbuRh/mtSPCFFoaCM0BVnD09lwC2joqZKQ3hKPm8nWfLYrkxpm8rjaYADchiO+zrEL+ZdqsO4FHRH/8Uwxc5F6jWGkzv9CJpAilUg0p09lJxlnE4cNrUotExLLKe18ld825i4Vqf5YoWLY/5Az8dOg4lKlICaBYrrjdkAd9AB74S5Nmuoc0FfTY9bdyBHjou4SEzUIYpqCh4bS9ZOJFEAEEqcKwD9B2NSy63b9QjEGEZ+l3rtRtgoudiqblJlpefpC5ZOIPqussveNBuJgmGl5/itTeGZflphhY4rq6+7rg0leneWr6A71Vcx8DKoA0enU7c2dAxjC5pzYoZbx1A9NN7Wekl1rZbFuKFiAbr5GZXKTyt0+ej5Y1Xat/+NsEQuAM3wfyqF9A21RErOvySk4wwWh89F3DCiUH/ncEk1PchnHev5DqW/u0k+Z4eqb7SkMrdycVHusH1XxjD1JOcBaFhSNAOd/MhinM3CzxXuKepjqFwGpok4LVNBMkBPz4OS4IoUc1iAAWsQqPLSLT+RKvOdzsiBafmkbnZ6GPHtyPo2VVL5Tw5oXB/By5wPADEthW10MHP0S/sKvIvrQBVVHLpe/8jiaeBALWSSqXrG2535pHscAEZMwJ+PXe7jGV2z/K6rIjhuUum+H5oVzuzGTC9WU1Dwy36wR5ffPeOWlRdMpkDglR9jYFnEVvX77C877510VriQlQWhKczc/VV2/8QsG5zMxlqKcb8GIaN2AOdmEZzh/T9WBQwHOP0V4NSlWiUdisQzldFL9QbNcMW1ED7WRhSMDVlwv+pzUp68yyzKCIse5jOwdU9lwktIqLoIYicHqkkJ+o1+54kfRPdVpRoMxqWF2/JEiEkcqovxGnx6+Prx7G8C4hP0S5KZ1TGJ2aZIxqCwGLq7Za2BvDvU5SvFY8zTIXrR
 RWK3fnrn
 bOnNhl0rIDV9aMlXj9SFd7L8wY1tOTvSw/99CcB4qo0p2Ye6/Q//wp4hxPHbPsAgfE9OfifSpYLRVnVBHaDhFVwQ6y3cyFsUGr/AN0aFyeFMi1NPSywpGdW4pTX9XDInxg32um33ziODjic5XWjWEn4pkCEDbnrXqTt77DBEA3i+J+6K1q+s8F62NjBsHVkLrr1GHqCabUhWiJnXfK8FIRHzbcOyet4AoAIFrOy1ZIWt0lhkr0eRIc6TTlltaZP4cbg1CA1r/s8aXmCHu9Mlej7BOjCDyd9x57XDB
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
does allow spinning, so simply replace it with 'true'.

With that, we can remove the "@flags must allow spinning" part of the
kernel doc, as there is no more connection to the gfp flags in the slab
implementation.

Also remove a comment in alloc_slab_obj_exts() because there should be
no more false positives possible due to gfp_allowed_mask during early
boot.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b511d768e9b6..dee69e0b7780 100644
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
@@ -4851,7 +4845,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 		}
 
 		full = barn_replace_empty_sheaf(barn, pcs->main,
-						gfpflags_allow_spinning(gfp));
+						/* allow_spin = */ true);
 
 		if (full) {
 			stat(s, BARN_GET);
@@ -7317,8 +7311,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
  * Allocate @size objects from @s and places them into @p.  @size must be larger
  * than 0.
  *
- * Interrupts must be enabled when calling this function and @flags must allow
- * spinning.
+ * Interrupts must be enabled when calling this function.
  *
  * Unlike alloc_pages_bulk(), this function does not check for already allocated
  * objects in @p, and thus the caller does not need to zero it.

-- 
2.54.0


