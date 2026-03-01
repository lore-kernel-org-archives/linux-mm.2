Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585F2FD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C265E6B0095; Sat, 28 Feb 2026 20:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9DE6B0096; Sat, 28 Feb 2026 20:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC936B0098; Sat, 28 Feb 2026 20:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC586B0095
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:36:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47249B8BF2
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:36:16 +0000 (UTC)
X-FDA: 84495778752.07.C5E877E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AEE91A000C
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ87Uxde;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4/WE8LuhNyQAkbHZwMvmCnp+GqT3C2Bb9oatgA3GaC8=;
	b=xT6sPVbtA2IIIiJxiHf6dikGMHC3Har2HpiaTeKyi8xTK3ZUUTKnKerm+ImB/3G3DRvmFs
	J9DGK637MJOhvtKZZLVS/LDdoJ9fj4U8apD3upQH+WZ5byDB5i2nzut8aaKvs5UIqD47l3
	L8nuEufzEpR4nWM/rVRXn5UerMAKVGw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ87Uxde;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328974; a=rsa-sha256;
	cv=none;
	b=D9JhcYKF6To4E+Q0COtBAMT6Rs3Ed9hXEbiniVb0QjRqsApJNrCdywfEa8fmy+oYwZobqa
	XncvvgxSIScDFTOwrOS5aPIZjmSlTD/pTSGDKngYsAPMdrkkqh02tWJtgLA7FjJDDEBZPN
	6RNfiz2iSrhXb1i8NRT3IjWwVmkCruM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FF0F6012A;
	Sun,  1 Mar 2026 01:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F187C2BC86;
	Sun,  1 Mar 2026 01:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328974;
	bh=ACsspPuUG8M6gMZ0NsHZ6NHTtvbKJsozobCJ4pMgmKg=;
	h=From:To:Cc:Subject:Date:From;
	b=LZ87UxdeDtVnTJZvmOBSt9ubBZpC8LMCG9zzoYp6t/ANRgjhufc7zcGiSt5Xhj2XB
	 0OqsHhP1LvhwojsA/ddlDHrQQ+fF+cwqNWaL9biGkd7yLTpWHClyrDJjTq8FEFjIyE
	 tp+xlELsmm83NQY0rjaoRISqV8uNFvo6KpazKToXKN3xARPFDaoBxITQAn8FdUwJy8
	 0zF8jimU14FWFwGYsK+uswKBCbFtJpTYI2wcuctZjQO5BZLmRcEiJ/eqmeH5TDtSte
	 cNF9SquRnhY7CJEgJq5akZOWnnQjbY9FH+aETG33H4IK2XlCHAeX26hFd5jXU4x63q
	 VLDp4yeezietA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	harry.yoo@oracle.com
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/slab: use unsigned long for orig_size to ensure proper metadata align" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:36:11 -0500
Message-ID: <20260301013612.1696087-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AEE91A000C
X-Stat-Signature: 3ei3ajm8xda8g1s4rtqfj4bamfiyob3u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772328974-441379
X-HE-Meta: U2FsdGVkX18fU4HJYAAc3aLGMdGF4Aq+H5Lc9YpvWcSbWWHr/TH6SElyBfSS5OZ5zuwVkg6/pDhQJ1liGwqOFlP8d5U7ARj/RlESEueVEh3+HDYCySTnhUwzHotCUncgAVVZLnRmKnswoAcOVyS+LBcI104V3JgdIN2Ewl2uLex7fWkEhoAf8JMf0TWPD10+h97MpH7AzIqPesiyHmQksRsF3qgLJ5qAlJoGcXPicljzIRIkxR9Mb9c2I2AkdDTWDPVF/x2yYFAPZVM/TNVd1XRXegOYrBbfp0TqSb+pYvM2mlqcI2MQ0d32A1aDZ6xxJaCUmZi8lbl4GoDzf9LYLtNnwLYfXAygrbMITV3W09BiFR4TCRTGTz6gbFkvKCyQr/++25E2w8JIwQ3yxSLjxhQqyQInQlsjdQObcrDuQlrKkkPR6X4hkUcNEUbgdA0o4M6Kj0YcREW81uCkKEwLMCjaKZo3KxwDJmUyKqRwjytMWpX3xCtb3MxVT+VBEDgFP50SucJRe5MFHx4fLhLWAOqS72ou1o/2/oROjGwhClq1ahT0kIB86AM59xVGzWx6TYRCkZV8kkzyS6gGPoN8vGt/D4tZVY7hUFzvT9LOBl6DyLNoMdj5Ygopll+2qXzU48FJsYVVArpSKGmpJzT6H7/zRATCEHSPMe5Ww0yq+Oz3auRUsxmAVlWCAY0NqA4+MiXRCsVdVCtni7xLwWCHnGLzAIAYmXk8d1ulnTmg3WvfFD+Cxd73knw/zyL/95WDb2Pk01SbMrNMgGMxW9znswttsiZ2hPELrE6v8r4yDljm8/ut3TpWzFqCjpRrWUpwYvOfHspCYM3e07zxzmJlFzWH8X6B3eU1Y0okIQ4J6B9LOGnCAFYAvouyoW52lYYggc8tv2DRDSrWVVa8pwsZbimVZ3osmwRnEbIS5c32ca77Lnv64UshqifiosXcztti9s3sVXpRRH7f2r3MsHz
 B6eKp2eF
 adizv25lWidnCa1rMljuxLBlVsHkVsUL4rGTWEMcpvrB5ABgQ4jfD4kcQdyojxnp8lbx48UMX6w791T1oFVnHTKoG3QJeUItTHcu4JuAK/7c+zNfvp6oFPClHH6oqUR+ppJClN9ZUh8hsb4vUX7+iH2SwDOubwx2xuUNTc8CmBqrjdUMHPmnUB80VKkP5CEJoxnaHYxw6gNZlJx8+H9rDUHeFmvOPt6QBNoHpEC9vRjA4ugLT7/rhO3G136HBh449Zy5izU9fz/Wrt5OPEFBfsiWaamM6u7LozyZEzFc50y5g848Se/hI5gml4T+oZ83Z0NE8iecNwzDdvkNlLMLv+uJvG/90uAF62JB8yo8zfNHoobERgkF9fy3PrUZQ+FYvHEZgHKuXzKWL6O2gdTo2A4NA7LIk6jdgr53m9I2BXqM0xBPq3U/C9PEDO7a6BIH+4gKpAcjS9jjSYIs3QTj36SwfHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
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





