Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B8C5CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560866B0098; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4435B6B0093; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F97D6B009D; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E44ED6B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 572B51402CD
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.06.51DA80D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8FC20140004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BFGwV6Ot;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278437;
	b=y2/cSLu/mKWcqb4nb0NSl+NomL/2ZgxZGkV4rUNG0lLPS2JziHGvO0p6TC/G+VamqAx2ge
	JdiaHR0ikmNbbdIVwdVhAl8SbMPZ78x2yqOE7SVIsdhCFjwstAs3TNkqSz8Aqwuw5Sa74s
	x6KGW+pdxlzBGtFXl8z8iJuxsdQ/UMU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BFGwV6Ot;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziXSIFKy4iYBIXzefxPjJEejxh6eI0ypyw0gaU6vVJ4=;
	b=7qJB1pJ4XJWOkYVSIZ7S2EL10d+mHlq5XQmqFXUjZipg7Zg273Q3DUr5o0rI0cqBl5V8HK
	Pz2/R0q8d/aVqhgggcjbv07LEdFqgT4HiqUahb/+DC57WzObXV0AyP1rIO1X88Dx+QC2k0
	Ws4ZzMjkZY6H6Bra6spBNp02qPbHXtU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8627344787;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4841F008A4;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=ziXSIFKy4iYBIXzefxPjJEejxh6eI0ypyw0gaU6vVJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFGwV6Ot437+lLzZytDMcJMCEjlmOPmJZxOkahUbroKgnSRzvq2jm/55eOIG13LlI
	 QPrgWc8VKrKuJp+/FS8fxyKsXdhE9OvSuaYwxl3OBroTpN15iL/zqMT7oCx2r/pUDR
	 hec+OLdi1KCYAQVarNnGmp8pO505achrSEtnNqSDRuyv6AUYzkoYrUD2rxuj8wTGQd
	 w0tle1Uf7ZupVOVKzgRZTGcnytWNCSC0Zjv6qrxLC2h7wlMjx4/64mWERNVAd8VzQ7
	 1aMRuu/dUmO+C68iyyQO4KRk7GJ4qNBefA8shkoNHj3TpYUD6PcLBgvxqmpU3CNXqs
	 ah3u8MbFlFbZw==
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 4/8] mm/slab: Give bucket caches the alignment of the caches they mirror
Date: Tue,  6 Oct 2026 02:20:30 -0700
Message-ID: <20261006092035.166776-4-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2206; i=kees@kernel.org; h=from:subject; bh=VTBkNsJfqD4uSQDLJ95b9wi9U4gRgcj84wnPIW38sWc=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iaweZyuaA6b/rog9YrLkeA5r36Gnl56NuLzg13xn E1P11yt6yhlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZjI9iJGhlWezjx+4tOXzkp4 OPVPc8O0M8+2Cc+JZK4W2+BzdY0H+x9Ghtuc9yepvbvcsohJSCTt3JMj5uddw8/OLfgbMGf2pxk przgB
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8FC20140004
X-Rspam-User: 
X-Stat-Signature: we5posgsdwausknc9gegdb9dws8fzsqn
X-HE-Tag: 1791278437-512913
X-HE-Meta: U2FsdGVkX1/axRV7sDEBg5fcxzMyaXZJR0azd2B//6ocJbFvdZ+9ZD0HH0BbxvNo4o9kPXaF8ZRaG2R0vtctzOMcn+CpNq+YO/inMuAvx5df1P62lwyTlXQbALaWHXS1anoBTe3Lq9g9Xy+2/zbqUKYLtHC/ATRURBLBpW5UtfQVXZCPPXtcXrMXarDHKfEX006OFt8ahy/G5bl5vnE25jCl0fBstREqyzSjOx/5IwDKaDbMNlmnbxDAouXfaa5K7Og9hUqOrGV0O3QPBsp9H1M8AHFKylqNeZ/nJ/XGuNkbHDGNhmX7/Vs1ECAlWl2iGHFqY8oMqV2LpwLNm2V8QBd/4Hdujig4vjdfs1831jf8sWWnJ5DaXSyx9GUenTI/sN0Zk7LI2q6kqPsWB8ux/o5nQHy6tJOLtsDZ6tmdwgTPjpK1FmbjU/7UH7HtVbEyQGETvaXdODmEiGOx6DhzKqA6+AP9MYgslcbaNFJ9JSI69Xa0+jKtmG4Ioi9dDExBHIpwsX/kbYU+Eqx/Dl7UQpDsXC3MN7llkCZJWxY9uoWkHJaNASGsIJUSAVxoYqCkyxzCaq2UmiHF5urS2gKxxIApGPQW+0q3gOKoEMIMOojDyXCrB8lKiJrLWCz1a/sHvFVBBn7nQB0ajX1uAdVgcu2vNJmcljr497tfIlFE2p0780t4kgYNAJ9gbrzH7wzCV9uzWh8U3qsYJFGJhTyodezbmHjwmyVfJhjOTDrNs6oq/KDpOaLS6moKC68F9g3DFgOs7ZJOHEZLFb6HnFI3Mk2KHdkEHXpvjl3B/qmGjjGThBnGMzj262T/XUfkgqcVD64DEys/aYZYVNCD/uipR+QmRqzHVCTquoYCWVSTjn9as9SeMlqK1G8L6ls3KtY/aZlzMZNJwH1ICsOS3wuv+WWHfm+4BCCzxobZk+rFUM/g0SoOWYH5cMLnaL9yZllMndQvCBY9LhZQeaARkVD
 JtWAk1Sj
 +8btA8sIhg5JXZy2x1+q+vOt6O1HPq+ZhGsB8E7OUU1Nx2J+TjjST6mKwxFUARqLK456OtSsqPjGZL1mI+rCUBPx9xDqwZ7wQG/brjO94pvj4Vb5a1ibyHl+tbDREzGATSN6/wNHkPBJ7lT1qOgw0iqkoKKt+2TGGhcPTgdZAmzxUb+gnDWbkJxilcKCPJxj+Z+mRrCDTW4aI7vLQQhIwdKRuvsVlvVnVLY7KE+fOaKjRrMg=
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

Take the alignment from the kmalloc cache being mirrored, which is where
the size and the name suffix already come from, so a caller moving from
kmalloc() keeps the alignment it had.

Don't take an alignment from the caller instead. With
CONFIG_SLAB_BUCKETS=n, or when kmem_buckets_create() fails,
kmem_buckets_alloc() is served by the general kmalloc caches, which give
kmalloc()'s alignment and no other.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 mm/slab_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index f8bb70d76eb4..885aafa23da7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -481,7 +481,8 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
 			if (WARN_ON(!cache_name))
 				goto fail;
 			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
-					0, SLAB_NO_MERGE, cache_useroffset,
+					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
+					SLAB_NO_MERGE, cache_useroffset,
 					cache_usersize, NULL);
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
-- 
2.55.0


