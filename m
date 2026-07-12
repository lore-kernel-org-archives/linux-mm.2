Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED2EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 12:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D236B0005; Sun, 12 Jul 2026 08:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E126B0088; Sun, 12 Jul 2026 08:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C736B008A; Sun, 12 Jul 2026 08:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7516B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:08:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B04EA08D5
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:08:52 +0000 (UTC)
X-FDA: 84980003304.19.5ABA44D
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id E0319C0009
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:08:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=INHUqvdl;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783858130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fPDvzFIiqCdivNjWyVBd/1diSMnrRTpEbgxd7LdADq4=;
	b=uPUkcQl/zV0pfQpBYrxIQBTJTBfnckl1YEFiHNSdJ7LY1McSqYSGZ7hV9Xzj6Dks498ekj
	nxL++ZAz9M2kh9a52Wd6W0rKTrfSibtTJ7OEIS8y4MR/D8l3g3Hfsjjj3hZqUkOu0JXLwN
	v+1a3C6t6AZV0t28GVK2YZNFw6J0sJs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=INHUqvdl;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783858130;
	b=yeSWU4KpmN69EXGY2jJoAHsObANel8QI/OxQ+z2ao9+0pHXfZrpg1JBCMLS7dsGB2AWF0J
	ISUGGq5OM9HIdPPvNeXuw/5K8gZrEpx8whqzVJ1VlPhKelSWSXH0bTUSaFa22vIyrZIMbv
	OZMMDJaZnLwAdoCOthgWfvd1ERFH6Ro=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493f60208a5so17851165e9.3
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783858129; x=1784462929; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fPDvzFIiqCdivNjWyVBd/1diSMnrRTpEbgxd7LdADq4=;
        b=INHUqvdlbkZN5U8gA4Sxn4Iekb/lQty62WVlo85pwfvIazmoXJzmGm5A2DPWNdXVQi
         n3vHEwmvEq8hBy3TGtMa2FqKVh68Trv5RaEkdUkIBqo77x3/Wdp5UNapHjjgkDFgaxc1
         wtn8jomRlJUw/JKxwIpFh3zh/qE7RhYNbZcntwV+YqBb4TPKJjEnkP3o67Z62OqqXOMs
         Con2nym2MGRW2dPYzBuk59J5YaRp548SmIvLSsqDIdf7QJDEfc/nfjNEuBORpbo52qcY
         rJ8TlAiQkm7qL2RNahCsZGoQoutGF0EABXl+SUrmQsos8galVrDgnzT4zDsVKz7qZEO6
         WXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783858129; x=1784462929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fPDvzFIiqCdivNjWyVBd/1diSMnrRTpEbgxd7LdADq4=;
        b=m+GcMa+GIPqbPz8tiKsuDxGz/QKU9T4fAd984vmauREz7w6oxSjOh8x8/XOhVoiT82
         qwTPNbphhwf9+a54EyP4tycC/KwgKQO+ItEJstgYkTY8Zi1LkrZMrrmDbII4YBDOsVO9
         zeaTxJ+Do52uW5GktNrLbkOfsdKEauA4OnGv3YbZ556csiMIwOiwTiksYCbod0GyNv8L
         KrdHBY8wJGKniWHVPiuWoWWskbNFvl4+Itp9nJhsDFiVg8126N08FVzHy8kTbYIN/ife
         k2v1p+GQO7wEymZrfvQbyfrCBEBbsHhWtpLOyLWSSjh6glYit57Y8m70+am2gxksEpTS
         Lr3g==
X-Forwarded-Encrypted: i=1; AHgh+RpUd6tc/hJKy1wp/5W50lFcXCdvYFZBUUNoIfCWvkEZxLtiKDC/qIizLJxh8ye6hMkhsC2MuqI27A==@kvack.org
X-Gm-Message-State: AOJu0YwrO7F6l32/5jAUK+6LuoyEso79djaSt1VHRTV/GZ8GaTXo4n2u
	3+VIEoCwBc2TImrW0Ng90hP0kJG9Pg+zwl8ewPihC8JqkIW1dDMlKRzw
X-Gm-Gg: AfdE7cmc11m+P3HULFpDb/KGS6V/nAvyMof2+NFwfhp8cxJADds7wujFoxFr9kSxKkh
	qjveQ7RYTPfPRNZRNhDGFkNp+9ipo37hSpoFaWYbJ5VjgtcktVC7vkrUZw88uVV8qZR7V580WPg
	9935eftYPiE98KkSIc9tZMDUCXw2XzufsQsxWwjQynZTFIoxo8ZbMhXvaOosOxZ9qhNnDriK48t
	EAKHduyNnqKO3Q9wlfQ/fx3fPqiSYWNp6o7PY8L/kjtuaxELbcpPdwNVLVWAoBokKoidOhV6A3o
	L+fWqhXnEoH49QTxN3CipYjnYNeMNFV+kIXHw4gVKgysnbUj2AqnIND5h1QiG+MjbxFaWLy6CGZ
	SF2VHjmEiR+3MMk/j/6zLo0xGqVUbjunaBUO/hJ2p/781kutoPQfcfV6cB8COeOndmqnGnJx/y+
	lT8XyowTnc+w/i6KLWAU2y+PJH1TnhuWGSyVc8JDHaHM5YPMeY/ZyynwBmnM7UHwXdGX3Vkqtlv
	iOu5jkah0bPCYDe+Gv1NStAgwT1ssY7J8qXBoWCl9uUJOCVqu55KCkj
X-Received: by 2002:a05:600c:4fca:b0:492:437a:a653 with SMTP id 5b1f17b1804b1-493f8826c59mr54375365e9.26.1783858128965;
        Sun, 12 Jul 2026 05:08:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-112-249.95.117.pool.telefonica.de. [95.117.112.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm287633135e9.13.2026.07.12.05.08.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 12 Jul 2026 05:08:48 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [RFC PATCH] slab: don't assume alignment on allocators that may return ZERO_SIZE_PTR
Date: Sun, 12 Jul 2026 14:07:28 +0200
Message-Id: <20260712120728.96628-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0319C0009
X-Stat-Signature: 4j975fn191iouz38e85wk6w5cptyrpes
X-HE-Tag: 1783858130-589342
X-HE-Meta: U2FsdGVkX1/ksYQZACVoJBmN4ufDSKD4YD7kf1eUGbRBTZKCGzMLAcTOYeMbtopY9HHO7nY2n7CB6ksuiW8OKthRQ9Qv78myflIzD5I41F8aZKGAY9GU6Aj8vKuxxmgzW+G3Qrn36b2OeTf37yy4dnHj7mK/IV4abYxT8G0G7ztXthKXXlKSXHLux7RFhga8YslTdQCk71K8f0qgN2PNSTjGrlEViDAgLHpwTbYnc5GTHffarpUyqrf58oTpcOqrfltgH6QxU9TEHCUvgsua/OFywOgK3XqZeYwgTh0VdOuBn8UgpL52TvE7QkRYKHM0+T0muqrgWmgW3Vm1TlazsBYP4V9CQxbAwG04MEy4mM1qVH7RlN4pm8VGyd5Yj97b+TxiZd5ax4lebI40bL4NtEhWqa+hVQZdgCKWbkFcQ37YIVv2uVAdsKygR+j2g5/DAsblizwHhZZKJe4x1VshlmaWe1qegfiIjuNMco8G3GoXn/fJMS42oKYEXwe/WbZ9O5jp5esOsYZiHBLXjaH6xmMsJ+JymlsOHrU9EyCgZfbczB6oTA1j9XLP3xFN/4aB0fm62FPAjgVkrFtlFqXNCOkxK/LWIKRC64SVy33Jk78WhqY4L8Y+KR3e5BC+b8B9f225aw6hd7isGear4y24jsCi42PZXkHBvFRoCtaKUIq9Bib8ZKt5A3wU1cNXHkR6v2YVJLErdj1CZyF7O5i6OUrMnNyD5IiKvwX8mCaA3zUxx2tIfbtuwR27wtwpbvToefTG1/2bGnAvGrhl2r1kY2pQ1hKaexzOLPtZGEYy3K3UWfNxt6dEaoqE4t7x/1np9/UHPL2ypznmhxog0xEmkp/CchTBupeETff4OpCfHFblJ4k0zHV8BDfKQrWeWkpffmV24QYd+KCEHPp/Y6Nkf0aIk6xPpSz/JGmrwf4WDsntnuvbVt/CoVUaKarZx2Hv04KCsGN8rZpampWwVcI
 wBpxoXtE
 1SIeehzgGlsM8v4io+FQ+4WM5iPogM6iovy2BtZzXXo4lsAhWo9KeRrCtSKAchZp/rZOPPOlc+lYObqoUGdfKP3PLRpF5NOJAevPtBo10hqSff8BnCaplPEdvKocuaWBbebA7Go53iwMqMC540bFK/MGQd5CmqAg6voRCNzr3s/3oBOi4Bnx+ASPGlxJVjIfN/HBVYByYHXejDI/NMMYwPMVZCczpqsv0Tfj+1TL+a1/dlXRhGhaq/4Vky8/grIG0615OTYK1s0BVyzQjoFxLlX3ZfhoElcE3trO8XnJ8vHtDc0vwL7xPGsSvK0Eg9AKEnWix3yaGcdLXhUELCQbI3vKAfyiLjeNuZbQyBQ4qSa3ipCkrC9oA9s2vyDr+to7a+79JX3TscdRCMUxsvBOkisr80bssY9F5i+BltQwLPAPR0BP7Wgbsv0xnNthTQepzl0WRiOea9LCDAVbLnWUcB/5XDiC5ZNR6NrxJ8pYddo09Qe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__kmalloc_noprof(), __kmalloc_node_noprof(), and __kmalloc_flags_noprof()
are annotated with __assume_kmalloc_alignment, which expands to
__assume_aligned(ARCH_KMALLOC_MINALIGN). All three can return
ZERO_SIZE_PTR, currently (void *)16, for zero-sized requests. When
ARCH_KMALLOC_MINALIGN exceeds 16, this contradicts the annotation.

Compilers may use this false assumption to reduce ZERO_OR_NULL_PTR() to a
NULL check, losing recognition of ZERO_SIZE_PTR. Current GCC and Clang
retain the existing range check through kmalloc's inline wrapper, so no
functional miscompile was reproduced with the current source form. However,
both eliminate an exact ZERO_SIZE_PTR comparison on the same return value.
With Clang, UBSAN also reports the invalid alignment assumption at boot.

Changing ZERO_SIZE_PTR to satisfy the annotation would make its value and
the range accepted by ZERO_OR_NULL_PTR() architecture-dependent. Avoid that
semantic change by dropping the annotation from the general kmalloc entry
points. Retain it on the cache helpers, which cannot return the sentinel.
Allocation behavior is unchanged.

Kernels before v7.2 do not have __kmalloc_flags_noprof().
Backports to those kernels only need the include/linux/slab.h change.

Fixes: 94a58c360a45 ("slab.h: sprinkle __assume_aligned attributes")
Fixes: f6d50ab29afd ("mm/slab: introduce kmalloc_flags()")
Cc: <stable@vger.kernel.org> # needs adjustment before v7.2
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---

Notes:
    This is RFC because the alignment contract can be corrected in three ways:
    
      1. Remove the annotation from entry points that can return ZERO_SIZE_PTR
         (this patch). On armv5 this increases .text by 1120 bytes (0.02%);
         no measurable change was seen on arm64.
    
      2. Cap the assumed alignment at 16. This preserves some alignment
         information but couples the annotation to the current sentinel value.
    
      3. Change ZERO_SIZE_PTR to satisfy ARCH_KMALLOC_MINALIGN. This makes the
         long-standing sentinel architecture-dependent and either expands the
         range accepted by ZERO_OR_NULL_PTR() or requires changing that macro.
    
    On armv5, Clang UBSAN reports the invalid alignment assumption during boot;
    the report disappears with this patch.
    
    Clang 22 and GCC 13 retain ZERO_OR_NULL_PTR()'s existing range check through
    _kmalloc_noprof(), so no functional miscompile was reproduced in current
    code. This is an optimizer limitation, not a guarantee. For a kmalloc return
    value, writing the check as "!p || p == ZERO_SIZE_PTR" causes both compilers
    to remove the ZERO_SIZE_PTR comparison. Built into an armv5 kernel with that
    form, a zero-size allocation is then no longer recognised and is dereferenced:
    
      Unable to handle kernel NULL pointer dereference at virtual address 00000010
      Internal error: Oops: 805 [#1] ARM
      PC is at __fc_init+0x3c/0x60
      Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
    
    Without the annotation the comparison is retained and the kernel boots.
    
    Would the slab maintainers prefer removing the annotation or retaining a
    weaker, valid alignment guarantee?

 include/linux/slab.h | 12 ++++++++----
 mm/slab.h            |  3 ++-
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 51f03f18c9a7..1c63048f6467 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -632,8 +632,12 @@ static inline unsigned int arch_slab_minalign(void)
 
 /*
  * kmem_cache_alloc and friends return pointers aligned to ARCH_SLAB_MINALIGN.
- * kmalloc and friends return pointers aligned to both ARCH_KMALLOC_MINALIGN
- * and ARCH_SLAB_MINALIGN, but here we only assume the former alignment.
+ * Objects allocated by kmalloc and friends are aligned to both
+ * ARCH_KMALLOC_MINALIGN and ARCH_SLAB_MINALIGN, but here we only assume the
+ * former alignment.
+ *
+ * This guarantee does not apply to ZERO_SIZE_PTR, which is not an allocated
+ * object.
  */
 #define __assume_kmalloc_alignment __assume_aligned(ARCH_KMALLOC_MINALIGN)
 #define __assume_slab_alignment __assume_aligned(ARCH_SLAB_MINALIGN)
@@ -939,10 +943,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
  */
 
 void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
-				__assume_kmalloc_alignment __alloc_size(1);
+				__alloc_size(1);
 
 void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
-				__assume_kmalloc_alignment __alloc_size(1);
+				__alloc_size(1);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)
 				__assume_kmalloc_alignment __alloc_size(3);
diff --git a/mm/slab.h b/mm/slab.h
index 281a65233795..aea1373c7f83 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -28,9 +28,10 @@ static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
 }
 
+/* Can return ZERO_SIZE_PTR, so not tagged __assume_kmalloc_alignment. */
 void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
 				  unsigned int alloc_flags, int node)
-				  __assume_kmalloc_alignment __alloc_size(1);
+				  __alloc_size(1);
 
 static __always_inline __alloc_size(1) void *_kmalloc_flags_noprof(size_t size,
 		gfp_t flags, unsigned int alloc_flags, int node, kmalloc_token_t token)
-- 
2.39.5 (Apple Git-154)


