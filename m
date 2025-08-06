Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03512C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DDC6B0093; Wed,  6 Aug 2025 08:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EC26B0095; Wed,  6 Aug 2025 08:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834C96B0099; Wed,  6 Aug 2025 08:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70F066B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:41:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA2051A03F1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:24 +0000 (UTC)
X-FDA: 83746293288.08.C5BCBB0
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5F95A160013
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=cqmOrCzl;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=dHM6W3j3
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484083; a=rsa-sha256;
	cv=none;
	b=qrdpXiKHl9xXF9oNqdOkHGeNJ1dr9piM5BUTh5Iv7/YQxFMhpaV7lrg0lSTWE2+LfQlpJw
	dcgyGhuPo4bY11nGTDptgt/3FonKx1Ph3kRqq9VZmMmm6cp1rcC8SK04L7LMbfDh/yU9R4
	u/hzxFNo9wXcPREq4R70bXOjnK1pAgQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=cqmOrCzl;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=dHM6W3j3;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCMaEFvhO0WO86sv36Htm4+PajgStiRpxUBpMzicUeU=;
	b=mylYK0iasGLO3SzY2IuiVwIRzReOoYpzLhGxEuKQuOUyIuQYnT3snGHZU3J9qa6oMvOALo
	t6J6E2s35G1X2ITG+SBwQdUBgeg/KNpaMyw7RSI1w/ULNTjLgl+Dwr5DNxwq5nutBsibCZ
	jAAHwzFoMERZYm3AxJleLS/P6blbd2I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1754484081; x=1755088881;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=hCMaEFvhO0WO86sv36Htm4+PajgStiRpxUBpMzicUeU=;
	b=cqmOrCzltCdIPdKUAS0uxd3aS3UJgsLfvMom0GAfCxlpy/J7JK4j8ZmlxPBm16+c2DkyY0NRC3WH/
	 2tQZTLXDT5NJQRbMHsWOcOG9eE3OhDXZJioo5QCsK0mgTbHm9YBmpqQlUQr+IpZEKpo4W2Gs4C580K
	 YOxYfpFJmHk+h6KBgMQPHtUsI+0B2jRIxSnwW+wuS/2JBDocFg++nXwcMfJMPywH2kh5UOjC9dBKmr
	 wpr2m9GXAY9gAiBYewC9/+QTLlNN8dRm+d3+GCQwx0ohOQw6mutJ2OUmDgANzMb0J+D8CpqziNCE4J
	 rpPZhgWDhX4HBCI1aG20udYUc6b4iEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1754484081; x=1755088881;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=hCMaEFvhO0WO86sv36Htm4+PajgStiRpxUBpMzicUeU=;
	b=dHM6W3j3L332F1flNFt9fxsYwybSKwkt+3UoW/yJlz2idUUKYfOAzC+FzsfJOcx3x3LeC/NiMS+Dz
	 bBUJwO+CQ==
X-HalOne-ID: a7791ef9-72c2-11f0-a1bf-f78b1f841584
Received: from localhost.localdomain (c188-150-224-8.bredband.tele2.se [188.150.224.8])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id a7791ef9-72c2-11f0-a1bf-f78b1f841584;
	Wed, 06 Aug 2025 12:41:21 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	rust-for-linux@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	bpf@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v15 1/4] :mm/vmalloc: allow to set node and align in vrealloc
Date: Wed,  6 Aug 2025 14:41:08 +0200
Message-Id: <20250806124108.1724561-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
References: <20250806124034.1724515-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F95A160013
X-Stat-Signature: jhyfnw9as3opygxiqqie899a1iyhpae6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754484083-721623
X-HE-Meta: U2FsdGVkX1+XsZR7sc0L6Bnv/BmLPIditoEoxwXzreX46UpiJoduKGU6GQ4GWaNtN0pGYL5t4ZwIXx2u9Mb78fGkMKZuZZHphMJhwQYcTdjjHY8UJkP8Ty2ZLmfxooqmxPhYkffdVjHpWAoxVjzhzplDUVS9gyFnXGAWw7kNNjc0gxTnzN+vrSMJqpGcnHMmc8+7mEehBARlcFu88F7T0Nad834ELMxLtseJ2Ox0o6ocLEO9d2ZU/RPPPsa1EIeRp1eUrh6qcjMz2c7Lg44wqTGQ6m4S140la9F3z4YUmn32yFQk2ZWZE6/e+Hf6HK9U2KWc4364nI5/WEOaJG8lDiWMbYO1Kr9sfmEqEU0gL4sGycXIox4C4whWh39HnXWO+ZxVG+beQCeLI5W+9kFiKhWrvUu3zgOtvTDd4UneqWHyJgCp/9YFrS/P6ZZudnUerEeSyufeQ8hOSzz5p/JBz+sbRI93ZJE36D/58LD2K1s2oFI76VCkV5UFnEMbFTl5XM6tsj72r8ncusFOsRkH87zWk3KSUN6gw7vQ/BXCJa5ScUx4zogPULylUVoIMfrY+w4F4LYlvCJ5WcA9jZYAc5DQQV7SDwawCGi2wAsAVvGhg97/Lq016Rw3MmCVRndqp8V5wOadCz//8DJrY+VERgU9zSP5JgBd2mKtPhfth3x2PAapyP66tuwHrcBTboBZ1SXj+Pu6UqYR6ISOzQBeHNKA7PzErsN/hlWR8RVO898Z4UOoVi/U80/Itno8c1mMpnnDBX5Vyp8Xpu/KpoUZ07rZxRJlJMAi2KdlC074F59Pj1PxwYvJCU5OQU3yDNmMXmw9oY7AliFR2DAI05fV/2osx3QWBcI2xxGwxK1P7IF1V0YscwWNzkRvNr/UzcS61nDlUSuvoyRqUI6t31kuMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reimplement vrealloc() to be able to set node and alignment should
a user need to do so. Rename the function to vrealloc_node_align()
to better match what it actually does now and introduce macros for
vrealloc() and friends for backward compatibility.

With that change we also provide the ability for the Rust part of
the kernel to set node and alignment in its allocations.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/vmalloc.h | 12 +++++++++---
 mm/nommu.c              |  3 ++-
 mm/vmalloc.c            | 29 ++++++++++++++++++++++++-----
 3 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index fdc9aeb74a44..68791f7cb3ba 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -197,9 +197,15 @@ extern void *__vcalloc_noprof(size_t n, size_t size, gfp_t flags) __alloc_size(1
 extern void *vcalloc_noprof(size_t n, size_t size) __alloc_size(1, 2);
 #define vcalloc(...)		alloc_hooks(vcalloc_noprof(__VA_ARGS__))
 
-void * __must_check vrealloc_noprof(const void *p, size_t size, gfp_t flags)
-		__realloc_size(2);
-#define vrealloc(...)		alloc_hooks(vrealloc_noprof(__VA_ARGS__))
+void *__must_check vrealloc_node_align_noprof(const void *p, size_t size,
+		unsigned long align, gfp_t flags, int nid) __realloc_size(2);
+#define vrealloc_node_noprof(_p, _s, _f, _nid)	\
+	vrealloc_node_align_noprof(_p, _s, 1, _f, _nid)
+#define vrealloc_noprof(_p, _s, _f)		\
+	vrealloc_node_align_noprof(_p, _s, 1, _f, NUMA_NO_NODE)
+#define vrealloc_node_align(...)		alloc_hooks(vrealloc_node_align_noprof(__VA_ARGS__))
+#define vrealloc_node(...)			alloc_hooks(vrealloc_node_noprof(__VA_ARGS__))
+#define vrealloc(...)				alloc_hooks(vrealloc_noprof(__VA_ARGS__))
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
diff --git a/mm/nommu.c b/mm/nommu.c
index 07504d666d6a..3bb62b779ef4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -119,7 +119,8 @@ void *__vmalloc_noprof(unsigned long size, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int node)
 {
 	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..e299b51bd922 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4089,19 +4089,29 @@ void *vzalloc_node_noprof(unsigned long size, int node)
 EXPORT_SYMBOL(vzalloc_node_noprof);
 
 /**
- * vrealloc - reallocate virtually contiguous memory; contents remain unchanged
+ * vrealloc_node_align_noprof - reallocate virtually contiguous memory; contents
+ * remain unchanged
  * @p: object to reallocate memory for
  * @size: the size to reallocate
+ * @align: requested alignment
  * @flags: the flags for the page level allocator
+ * @nid: node number of the target node
+ *
+ * If @p is %NULL, vrealloc_XXX() behaves exactly like vmalloc_XXX(). If @size
+ * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
  *
- * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
- * @p is not a %NULL pointer, the object pointed to is freed.
+ * If the caller wants the new memory to be on specific node *only*,
+ * __GFP_THISNODE flag should be set, otherwise the function will try to avoid
+ * reallocation and possibly disregard the specified @nid.
  *
  * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
  * initial memory allocation, every subsequent call to this API for the same
  * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
  * __GFP_ZERO is not fully honored by this API.
  *
+ * Requesting an alignment that is bigger than the alignment of the existing
+ * allocation will fail.
+ *
  * In any case, the contents of the object pointed to are preserved up to the
  * lesser of the new and old sizes.
  *
@@ -4111,7 +4121,8 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
  *         failure
  */
-void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
+				 gfp_t flags, int nid)
 {
 	struct vm_struct *vm = NULL;
 	size_t alloced_size = 0;
@@ -4135,6 +4146,12 @@ void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 		if (WARN(alloced_size < old_size,
 			 "vrealloc() has mismatched area vs requested sizes (%p)\n", p))
 			return NULL;
+		if (WARN(!IS_ALIGNED((unsigned long)p, align),
+			 "will not reallocate with a bigger alignment (0x%lx)\n", align))
+			return NULL;
+		if (unlikely(flags & __GFP_THISNODE) && nid != NUMA_NO_NODE &&
+			     nid != page_to_nid(vmalloc_to_page(p)))
+			goto need_realloc;
 	}
 
 	/*
@@ -4165,8 +4182,10 @@ void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 		return (void *)p;
 	}
 
+need_realloc:
 	/* TODO: Grow the vm_area, i.e. allocate and map additional pages. */
-	n = __vmalloc_noprof(size, flags);
+	n = __vmalloc_node_noprof(size, align, flags, nid, __builtin_return_address(0));
+
 	if (!n)
 		return NULL;
 
-- 
2.39.2


