Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8276C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D8D6B00E1; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754AE6B00E2; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D2B6B00E3; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4345B6B00E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 514EF405BB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:23 +0000 (UTC)
X-FDA: 85237016886.10.74F984E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8C3FC40007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdL0Rct0;
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LrV5HlUofGQHQ/kNdAFIhT1ZS3PTpyWCIefSybl8wfs=;
	b=z8n9muPFzxkVl3KJ7I3EiCpPmcK9yo6UAgPRYtgZLuilYmpLWraOGqatRdaMi6faaYp+sU
	Th+JtwSrK8sEVnoZNRVGlbIHeqbi6sXsKNL7HdAx7R3JudUCDxVvHemRhI0l1ZAU2ehkxY
	QDj67NH59s03HJS55wQxfmapq3Kcf14=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977501;
	b=XjYIcM80t7EFqwvSJJzdZy6yBLWDNEtWpbxfeIW05ae6BrU8MByT3MahovGo2sgLKOtoFA
	CKPxSP8m7Ymzhs3RcZOYF48NBPHdgYcMf+HzDF92t1oqUJy6mGz6QGxp6RvS654k+VuPkV
	Gq+E2R6Yvn44na2azlk4Sqb9pm87HTc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FdL0Rct0;
	spf=pass (imf17.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A598943BC6;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C4D1F00893;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=LrV5HlUofGQHQ/kNdAFIhT1ZS3PTpyWCIefSybl8wfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdL0Rct0o8D1RMzCLiAIR3g8WKsP5grYoTTdBh0dDgSKhqumLJ/MVuJYKSBgsSsbW
	 gCgPDkx1tfK8qP+AWxKq9B+0hy69AL55t1FnlywiLjI10GviMm1hUZ1CPRoDpylmwY
	 Nd7BHaHp6WU0lv3/93R+xhNIDwJo07svjVpMcL0e4qRmDpkaRBbXLGEHiHwiX83wT4
	 qs87VMBFZjX9Th97lNW1bMRg6ahQV4kXTYfxHMEU61iupQpMvjzw8izbcklS6qa0t9
	 UJ2M0R+to0SeDtu36W5k4VJYtSbwZmlZjaZEa/w9GyGjueJPlfUcN+Nb7z4xYPZXNr
	 tGXfalSsm70wg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v4 2/7] mm/slab: Give bucket caches the alignment of the caches they mirror
Date: Mon, 21 Sep 2026 00:58:13 -0700
Message-Id: <20260921075820.1718334-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921075811.too.775-kees@kernel.org>
References: <20260921075811.too.775-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2387; i=kees@kernel.org; h=from:subject; bh=U4cVv3SUTzhH/lrc/2fcsnidFcJazCsEDw7sFYGmqdg=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs/4sDlPq9X8gb7/bpsnB7XWCMtlbF5fMs+qiOlbz eQtvnwsHaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABNR+Mbw33d+keP64y2Zywy3 Z9Va3Y0Ud5otrZGsueeRMpODbe3tYkaG5r37+zvfr/z2PVUhSt9uNvN1w5vbrnNfUql6WeVyIP0 oKwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3yp99k49moc314apqzs7rdmc64g6ay4x
X-Rspamd-Queue-Id: 8C3FC40007
X-HE-Tag: 1789977501-873939
X-HE-Meta: U2FsdGVkX19tqLkZW/dLDM3vQPzEACknV811WS5FPHDCvHNLbCDBPseE8sqEcXnE+1shwzhIdMhJ1SIq4Fnr6tU2BYRCTkNSw+OJG2hmlVYXqei1LLwpjZSLIhyf0+QU5qPP1juykOAADoX3SSPBcbW47v80wNaaUMZiQ6OZ0bOL6NW/xvHCTIkYKuuo5ZPN9DV6e2u0Hul0PyaYcbIum56ejtAQvRRKJ1C2Nw2c3TN72in4BW0rcgZtRbWsOR4jIzqjlXl1TDBtAV+N/Ht0HORWiM8sbvonvrevI3zjVL7dPRMO6G45vf7PrDhlb6JRLIS5SzWcNU5C238hNUkFSYT6hS0Yfdc8ks8WrlrsTbSm2e14ANL60wcTCnoDl9sdUggkEEgheMKcX6K6c2VGsv3PTBA3SpdeCZtGtIZ4KuBnS7R3TPuqQJlBw7L5WRsG0PxlHu2/dzAgWPDs5YAt9842s8Nh9Y2uj6vWnqUAeXl/vcw48RG17kXebB6lipeemnSo2Fx8eZkrcfi1KAihhlAwzjq9RxJ24E5ev/FcDtNXCEEWwww/nz1INmH3lJuGgyL6Q87lMuIihSySXr/5xrcPIX3UiZ80Ia4tOVs9d6HQfuc+JN+aWKSDQ0Ru3Lxgc3brt3f5AGz1apBqdB7uB2ZwCOZsGxerqYoQOjJt8p+h6C3gzplPOmbwpmJhLtDJgNv3I1E96lUNl7Zj87hCW55z/ymlEXniJDGqQ+SMrklcAhCuNhCIDt+FA6qrsV+cin208XitNtHW50dXLW2J0zKT5UL6yM/o/RpgsvmRIPMZgKPvEPGecS40MjAIExgY/eFF1mUUzizMZTNIqyKaolK7O/d5mN7LMza8SnKdBHw37B8iAfDS77BCpXIV9KWPMqJySZ316bl+gehChJ+WlA8m0StoeIlDOsCEfkz0C//htp9sXNmmOQWqAtkmlemc4zZe5/U999am+/0nKOc
 npioOUTF
 GpKWKoMr6r/Ul2W9683nhYQSzGMaE7IL8XPJ4XnTpjE8qXRl+SA9m0oVT2gbNKBs+aobDET/I0jQKWBPtGrk1WpszNEGAKM+R8WZFl2WkSFWQUyUSehkMxKWeB1cNG+++ZSwLzKbbym2DGTSz4H6LOHzHni7WOie2PP7zHeLTRAjzf3tPvpPQ8GiUEPLekTBNWWiAr9ihFxVcj+vWeC0Ohnrzf/P622KV15skXjkrzO25c6o/aY9353IsH5Xhvu8R5T163DSI3M+IU/W+MiLtfjcIDI8WN5fkEKqv3Hvxt7e/ZU8HUetlOGEN7+VdukP24xPl1zdWqCd8lI74PN23wY8DsL5+FFpfQ2/hVQV82atnpFYrTU8rEYGQbc/p4aEAz6DtCyzCmibxvKKm/CN3EI/3pb46Sq+t1zxcn8lsQj7IOoQr1rno9kH8MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A bucket set is created with kmem_cache_create_usercopy(..., align = 0),
so calculate_alignment() falls back to arch_slab_minalign(), typically 8
bytes. The general kmalloc caches it stands in for are created through
create_boot_cache(), which starts from ARCH_KMALLOC_MINALIGN and raises
it to the largest power-of-two divisor of the size:

	if (flags & SLAB_KMALLOC)
		align = max(align, 1U << (ffs(size) - 1));

This is only a problem when slab metadata is enabled with
CONFIG_KASAN=y, CONFIG_SLUB_DEBUG_ON=y, or "slab_debug=...", because
metadata changes the stride size off a power of two, for example:

	size 128:  bucket align=8 size=224  | kmalloc align=128  size=384
	size 512:  bucket align=8 size=608  | kmalloc align=512  size=1536
	size 2048: bucket align=8 size=2144 | kmalloc align=2048 size=6144

So bucket allocations will fail the IS_ALIGNED(p, ARCH_DMA_MINALIGN)
check, potentially creating problems for non-coherent DMA situation.

Take the alignment from the cache being mirrored, which is where the
size and the name suffix already come from. Nothing changes where the
alignment was already implied by the size.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <linux-mm@kvack.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: <linux-hardening@vger.kernel.org>
---
 mm/slab_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 270408ce5a9d..cc58f192f349 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -487,7 +487,8 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 			if (WARN_ON(!cache_name))
 				goto fail;
 			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
-					0, flags, cache_useroffset,
+					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
+					flags, cache_useroffset,
 					cache_usersize, ctor);
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
-- 
2.34.1


