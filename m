Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B653FD004A
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BD06B0093; Sat, 28 Feb 2026 20:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8356B0095; Sat, 28 Feb 2026 20:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E3F6B0096; Sat, 28 Feb 2026 20:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE8E6B0093
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:45:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77CB61603D1
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:45:12 +0000 (UTC)
X-FDA: 84495801264.08.1DC9497
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0C184000B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:45:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BErxteEw;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5cocrvgZdptDaiTKY3pjNLW1lzlJrT2VS0KU07FTYUg=;
	b=qSs8Te4MKiMOHMrZx2KwRMGD13YxL40FngZY7nerWvBumUVaGuOTruheqIDbYYrnUC9RXj
	IC6dqjwd0TEMUfSg+MKxs/psW4yX+nCRUSvkw9jflvFVGuVM384veRFewxXY/t0TVYcvfI
	DQOz72UMbPJS9Ke6V5Du9JOVaAQbFno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329510; a=rsa-sha256;
	cv=none;
	b=uX1buhDj/cYHeDC2ER/qPC+vLznUX/K0mYYG2rbCopiU2gi9LlHrCV1qEMsb6gM/9fRig1
	s92OGmKXVHLCD6ZEEN7pGtyFKeA9gRqCTiE+7w6ZZzpu3e+RbEuJuyk4PMfD01pvGFavOI
	sJY15RR9V1B0fv7te5n9UenedWdA1d0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BErxteEw;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC7EA407CA;
	Sun,  1 Mar 2026 01:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A74C19424;
	Sun,  1 Mar 2026 01:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329509;
	bh=jg534zdcz6ZbicqVI0eVcQ15m42V1YwShpeGG92oE0M=;
	h=From:To:Cc:Subject:Date:From;
	b=BErxteEwzzkrex8wuy1zhG2nczeL7ajymk6euZne2zYp2rFR7dud1tfZbZ+4QXWV4
	 vTmH762E6a5qM2uRKE6tNkSF1Id0i5aDE1Ht0nM7PgP2VTt/oFzWvX+Ki74rZ2B16U
	 c7KCqW/t7GnuTiCSG6nTmujabk2ZE1rDq1rx3NehGLgVTHeYCSUrRNYWvzAnD+BQK3
	 5eDKijJLiKkUYe6H3NNzb7i7K6lonE/qBW8eyXN02yc/Fgyn4+rfvCkZOWSpMF3MSp
	 gBdg8etNlEoUFA/kJrJP3kGLD4C+ewpvgBGVRwWgBv1yHC1AU6bTt5ua/ucvRvGTQn
	 3HaoRrnZQgKfQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	harry.yoo@oracle.com
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/slab: use unsigned long for orig_size to ensure proper metadata align" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:45:07 -0500
Message-ID: <20260301014507.1707658-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4zfukxc4yex8qf9ad3w87qbb4qiwwk3q
X-Rspamd-Queue-Id: C0C184000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772329510-653562
X-HE-Meta: U2FsdGVkX1/pMnZ2zZxtZcZnIitTF9e+Em2tsueutLyVbTDd8FEmCRmSKilrvVLz7oFjy19a0IrAxvRI1VUM1Mez5evlymF9XE0ezKefmf6jasDgeE+ynqiquD/DssnvAdChxpb2CJUEQMpeakV5gGjfSLu+5b3ZdocnM92GoHjTEZu5zxwjDJEKPA1ZOk8EkAvmSdOZLjbjuUJUkFjrm41VM0P6jXEhEt9JJ9CTxaaXwEKqzuUvwSsFUCcWqmhHqjeZYyMqsnzPOpZQqPm7J0tdTzco3hPgjTSWx4HJKav+nZYX2/DNbZ3s8WKlLNfw8O6lRUqip2rqYboGXyQsmCU7S54+IpFQTKIME4nwjg5T2RjE/fUpcwjLDSZ5Cn0RhRZgdbiZj0rWOBDa66Ox9HqtOwlfzcZHFp8We5oD8roqvKV84yAzH4fr/7bWqQ1BNtJcD5ymO1ZsUSx9f9qzOv4ewlQ92moNgXxFq6lJ+Ak4o7SLovtMWzYxEyHvL5eSLCxcEFAusi6BDDACwm6KJAhclGTmwV9k4n9+mWEbtiZrL7bCHVSodipIxvO1SZx2P2zgqFWFonEN/xcGIxdcyiMswB8DRIfNIV35djSxzSSgjzVLz7PsRYpWPdqpIsSLYQEL7LBOinUnbW0DwgibONlDWjHiXLxQpNppih11eTZluqmcst8xd5jxbW+/hvDsiJw7ypHHv3mmpN+xcmbth5ziTZ2/0/E9y6zQioO6q5j71ApcprLxDKvaSJ4hhVuwt8RnRNETKWN/hMHyOZVA8HQSj6JyjmCZbMov+Lxbjh6IYHDan4Gxm/EiSxnn0dRjgV41Rooqn4xGCQ/2T9LC/2hrhnbv8bYZTGzBJD8oms4+LWBmwvW7pHXsQnMtkSzPAPF45R2g0j8DxmAJCqYvgnz6qSGx7umkMWvZQTTA4IXcKiyHPmRNYe/IfnaJfsmIfGCRn7m3WfCn0cipQbL
 E6fY1CJT
 pmvqZETD8T15vaXrwdxiMIuMArEZhRS76hI5CjvpMGHbJPncwN+DNmfR8uHKXReKgi7rxyjQHHtHqcm8KqCb7NgrjsCYY0iWbIw3iB7rJy9SK+JAGj6GpH/zEmFhkAQXCoPczowNw3t588YgXsZq0wt5BORkg3NlQBvNlrgaksQzGSZspH4jX5B//kmqshi6EXNQ7A3SFC4EWNVJ2wjlNNK9x52KG8WHRsvpfkoyMj/6n//KKEGUXO1bSdeBhBDTumPNSu7V0cuoW5mQEPFuxyElaSN0QivYqs/uMOIpFMuTdSjOz86nOBc5zDAMftEgSRnx2KKernYbu/0rG0RzZKJcgVbr9lGiEgXL9a2KZgYqrkR5G7dLxzTWPSxyyQD+krHvIvk24kpG8eqP9NoNJR5dtEMTTb3eEEpDi6QyhDBhWY+n+5RXbukSGWsffFVn4szG8uWt+nfOpKxFvsWoJ1yDNxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
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





