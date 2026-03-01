Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575EFFD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7576B0089; Sat, 28 Feb 2026 20:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C786B008C; Sat, 28 Feb 2026 20:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7B06B0092; Sat, 28 Feb 2026 20:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC8B6B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:25:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EAA013AB40
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:25:39 +0000 (UTC)
X-FDA: 84495751998.06.3AE32C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E28CB140008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:25:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XAFZQuNk;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vzp3auVDNgj7uevn8KnpWLnIr6tc4sN96FFSXtcGxhQ=;
	b=WFYRkO7ptPMNFJWKDV1TVNexg7aHrCXd4JSXxp4QZqJl8fvOa9BngBcoOzskgPZAhKJyuh
	0u+y1oy5U1WkDF08x6nQIODeL1WzIUlqnhRcpBdzZ0XZCcXKFFzXzriKxalitTghxuqjAV
	XoSua/+iqcXLpNgndBGEoIDuC+ipVus=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XAFZQuNk;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328337; a=rsa-sha256;
	cv=none;
	b=n/XKtGF5aPuZZ+i3VkJdJe1wtPD+wl5iyLCjZOQjlsuV5U8tDToXn6UFvMVKxmstauJT6V
	CvaMUo8+X31jXWrXSYhtWe9qrNuHqk3FdYIYJatOGR9zR+vJ0wHm/5eUVCe3GvVdP1keWY
	m/YB6Ltof7yf4jHUXgtAOVAX4fBor68=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DB9060008;
	Sun,  1 Mar 2026 01:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585E4C2BC86;
	Sun,  1 Mar 2026 01:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328336;
	bh=h4f6NUiTciRfF25reCbPbywyOfmuauV3XR2ctqJTaxA=;
	h=From:To:Cc:Subject:Date:From;
	b=XAFZQuNkh7Qt45+lgRhbvzGmkJDOZ+5rWHtS2BdyoXseQR07Uhda+a87ZnOG4tSWQ
	 LxgB0qLOmeZdH8uLlSQZHDffHBYIzWmv/tuRj7zIXA9Rx2QulHwEfBELR6tJM3woAB
	 55dMEMYinaoBlg2uLay50zMTb37bI1fphid1un3vg3nXwOJHB5lZwLSYXpuEVuTtWz
	 1eEmbP3n6jM5YPjaLAuhBpebV/v3fiB6fyrKhsFmsR12YnfynqGQLYGN/ObiwOSQ5R
	 laapsue+LLc376D3/coRDOR9PPoG+XA+anEsEYslLWrjTtvZjRZJAOrvRU1Ib35+yG
	 aNyyenCCJiUig==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	harry.yoo@oracle.com
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/slab: use unsigned long for orig_size to ensure proper metadata align" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:25:34 -0500
Message-ID: <20260301012535.1682729-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E28CB140008
X-Rspamd-Server: rspam08
X-Stat-Signature: uiq9tozehsssf899gurougtnjckqbbce
X-HE-Tag: 1772328337-992447
X-HE-Meta: U2FsdGVkX199W5Vi+yLFEW5ZkJSk1W2dspGhnBmbhJpJpbwFf4AGYMLvrGWtMH3lgvrgP3JkwcxTH9cI3mDXavN6x53SBdKQXT4WCr/4hVBs27c6OzbeW4ZIaAN5YCEUtbnoMG/QTh15YBZF1D24/VzgEzEnFVHC4xowactR3t1nOSpppbvqSYoaFMiGT8lyXLghJaUlQJj0/aEBDV2qqNKctQFF+D9+zC0oM1jpsN4M7bNao2te4vvp8v6M9DbokDZPBLQvB6eTIlbfCeMwAD9DBBjJPy4HD2AvQdYkV9q4Ji+fIYD3RKfT92GubxrJcUr86Miy+/u/suDHXC2GQtl403BJv2PkEmQbRCZzoNvSF1F1sS44zf7o1HzMxph2DGatLQDnEbC3iWkbZ7nCr+4cNCjx0MK/a5kaYhveuY9HhAv3xDZ9Vb2Xw2h+FA4r0dMeBeqNlozarNds1VMHdun4c0Us4FP1TnFzcCTaFF5/HZncxGrAV7NqRrOw7t24hrVVwJNjEWtk5sMp0/2FDytoM3g0lIvsxv218w/XHaaEPDbWKauf+hESFDI483z28p+A8KCker2zyCuQ2WaExmMamveNcCnPomcYkieoCKJtZQOw2gy4TNoOR6T3/AxTlVfh8k0OMVI6cSP+YF2wBZDQzh0Pj4WBzM/Z6bFVEd46V/ZDChNpY4DMEvncE77So5M1FiAuGyp/YQwZ7f1vmdIp+QMs0TiAB6G84B65VdJ7akixm94mwZ7fQvmvBuJ9dPZL12MeEBsJ1WbHT+CdktWIxySQSO/Uvrb78w64ZUNYh5C6SxFskDu6p3ea9EfMx7RjmHgr6rUDhDFl8pS/FxmHrnO8lVZRUju87sLUk3cJGFXgW59QED3PkfFBV+UifvjyJwAZpyH6/FsITgitjetZBs9M2A/hpkQGDT2h2/GhD2ORzInZxxy9r8cK0Q1xaZ0/MJX8EWYrIsuw+QN
 U0iWnsxP
 pNU1OuSja0+70Sgh+zvbksuGmZXwPVhmVN88w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From b85f369b81aed457acbea4ad3314218254a72fd2 Mon Sep 17 00:00:00 2001
From: Harry Yoo <harry.yoo@oracle.com>
Date: Tue, 13 Jan 2026 15:18:37 +0900
Subject: [PATCH] mm/slab: use unsigned long for orig_size to ensure proper
 metadata align

When both KASAN and SLAB_STORE_USER are enabled, accesses to
struct kasan_alloc_meta fields can be misaligned on 64-bit architectures.
This occurs because orig_size is currently defined as unsigned int,
which only guarantees 4-byte alignment. When struct kasan_alloc_meta is
placed after orig_size, it may end up at a 4-byte boundary rather than
the required 8-byte boundary on 64-bit systems.

Note that 64-bit architectures without HAVE_EFFICIENT_UNALIGNED_ACCESS
are assumed to require 64-bit accesses to be 64-bit aligned.
See HAVE_64BIT_ALIGNED_ACCESS and commit adab66b71abf ("Revert:
"ring-buffer: Remove HAVE_64BIT_ALIGNED_ACCESS"") for more details.

Change orig_size from unsigned int to unsigned long to ensure proper
alignment for any subsequent metadata. This should not waste additional
memory because kmalloc objects are already aligned to at least
ARCH_KMALLOC_MINALIGN.

Closes: https://lore.kernel.org/all/aPrLF0OUK651M4dk@hyeyoo
Suggested-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Closes: https://lore.kernel.org/all/aPrLF0OUK651M4dk@hyeyoo/
Link: https://patch.msgid.link/20260113061845.159790-2-harry.yoo@oracle.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 152fe53d0fb5a..2c000dddcf74f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -854,7 +854,7 @@ static inline bool slab_update_freelist(struct kmem_cache *s, struct slab *slab,
  * request size in the meta data area, for better debug and sanity check.
  */
 static inline void set_orig_size(struct kmem_cache *s,
-				void *object, unsigned int orig_size)
+				void *object, unsigned long orig_size)
 {
 	void *p = kasan_reset_tag(object);
 
@@ -864,10 +864,10 @@ static inline void set_orig_size(struct kmem_cache *s,
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
-	*(unsigned int *)p = orig_size;
+	*(unsigned long *)p = orig_size;
 }
 
-static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
+static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
 {
 	void *p = kasan_reset_tag(object);
 
@@ -880,7 +880,7 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
 
-	return *(unsigned int *)p;
+	return *(unsigned long *)p;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -1195,7 +1195,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 	if (slub_debug_orig_size(s))
-		off += sizeof(unsigned int);
+		off += sizeof(unsigned long);
 
 	off += kasan_metadata_size(s, false);
 
@@ -1407,7 +1407,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 		off += 2 * sizeof(struct track);
 
 		if (s->flags & SLAB_KMALLOC)
-			off += sizeof(unsigned int);
+			off += sizeof(unsigned long);
 	}
 
 	off += kasan_metadata_size(s, false);
@@ -8040,7 +8040,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 
 		/* Save the original kmalloc request size */
 		if (flags & SLAB_KMALLOC)
-			size += sizeof(unsigned int);
+			size += sizeof(unsigned long);
 	}
 #endif
 
-- 
2.51.0





