Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F8BCA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10396B0093; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9499E6B009B; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A226B009B; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 440A96B009E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5AB6A05D0
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.03.9B4316C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA761A0002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQ4wYMkY;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278438;
	b=1qW95QwLLZqEo1b70GK0ODOi8HlyyCMCSZ/kxPem48NKn+tsHFzEfVY4KoRUnSWohpZEow
	wSVQ7RVzqikWkp5BXLd5xpilYwJZaMDwu+Lv6zQCk7aPOAn87tz3RmbDhJHLP19Nik443s
	gEMB7tUBVGHNCjmz+KZkiO34jDUF/FQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQ4wYMkY;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5SQ+2kIxztKujOxzR77oFFLlb4omNpweC880YzyU/s=;
	b=FlrWGehMcryI3g8CuNy6BMqu/x0cN+fgIzDMCj9ZuebxArVnuZXNvimIousb2qQCj9NgeT
	E7HFUkBg5y1tJKs6s2f5pgwj0XQzy7Tv/IEXfuupINfCpXMUY9VTlbDn39BTwrXY673i5U
	I9YQ7/1v9IMWniPIZzzIp8Rhp1Dt0K8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C924447A2;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1601F0089E;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=r5SQ+2kIxztKujOxzR77oFFLlb4omNpweC880YzyU/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQ4wYMkY00Ex9Qr8zNd8lCDm5MIFeTYX6K1i4Vz6QAO+bcS5+D7kuBRd62KxXTW5T
	 kC30EnTBpWG2xHCYvqhhoyIt0bEpyeC8Dk61mohcWYBb2MG0GLAknHPjE+iQxuK3pM
	 5TzQvQrWoEVu09lM4wS2A+NXCeIyhVKMfcSgDqQhUvv2dbdwncTScxlUwfpanfVuT2
	 4gxxTOTU44cQa4rPyyL4tKG7+VOO9Dcw1PXEaL9kQWKJnVBjQnvCxSc/VC4TpDWR4U
	 DZ5AToxXNDPR29+bLWHUemAy3paMXR45Tb8QilEZshgGXL22El9RTFs0AX4zVQPoew
	 mJR//XmSB97Zg==
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
Subject: [PATCH net-next v6 5/8] mm/slab: Add kmem_buckets_destroy()
Date: Tue,  6 Oct 2026 02:20:31 -0700
Message-ID: <20261006092035.166776-5-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4334; i=kees@kernel.org; h=from:subject; bh=AI556dgcmDFEiUNFpt0nE2tTt5VEwxJ8p0QOtjqe2Tg=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iZ8m1ofIzR7u/LerWfWr5YWdV6tbrPhdkrQv9yWP l+vX5MtO0pZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACby6CrDP5Pg1iuu6UEHd354 arCgxT3x4YIcq/StnE83aVh/MV2aPYvhf4BNx+dJXgZPD7jPTan8dHz9wWMOFo0Pt3YevJ5umrV sNT8A
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y4918t4p5xmifa5yokz3bsfq5p71fo5q
X-Rspamd-Queue-Id: EA761A0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791278437-430285
X-HE-Meta: U2FsdGVkX19sAGrzobY3yE/MCw51bgSCRTngQ3NoTVRdh+JqPUQj55W3PYTZ9DDkhQqmQrX3IxTi6aswDtzsVmGu4KGNCDpxr5iZmlqETMA46NoW5cfyfZAOu8TqI3djMjNbES3PjQ4uJcdN+My7QFWxgkQHsThntwQfZ1A3Crf4XJc9k6blhmuB9qu7hz/yjoXOxRNIP/tRCy3/9eoQEl3oZhUFPhUcKLR8xLzSLqz2LrjgW0AMducA1aeSje/2jGN1nOPXhG4nIkbM9o2B4hCbYEXcdiGFdtaecHtt96HwWA4aPXLcnLxCeAjx2F2SR/cgsUikMCr2LupvGDcYEeLer6xRZykuzObswWXfPCRTdAJVSTvYx4xzD/4hTlenAg/wkqStuUWWJ855544JAO/WtxInwQMgj+YYjVzVUMJbukAZkanU3sHA4f4Ti+JG0X8YllwXWyZAj/L4dLUqH7i2jBUehA56jPxJ1clJr3ibtWlMWRA/aGxqXFPQyL9Zu3nJTSbMhmhjp58A48EXVQ+F9ffujMHJog7P2H08ikn9Z1BV87w6CTck+3sYN3FkwOrc3pc/L0tdbGeJ0DHnQ8MVPLzoDerfYVxr+pYw9/3uuR95sPrZKzZPWXKWjXNc0+I2yCJofOSi4KiLbZSopvHphkaWjJnx0vid1xDWdnB29QHhckCiKSoSI11fr5zBG6xWwXRXdEqBRdcY6nqDwIkiI3VItff8mmYllvjKtdXR1E48mBaAgP1ebHzOuo49OLO1Io1vh+1iIjiFCHAtY6GbcXE1NkGbh6EYK/vlAQ8dclW9KwIEg7K+lcaFaiRMFEOr2UA7Uyy3YulDHL20Pc3H6tJtnC4ZjuLGi9vorhaQUUmkcO8Q5WkiryjDE3Cx5zy2HLSgewA62Bw1A1gyEgnWsEPlLY3T56Gb8LbmMn1DOyPdis8w8ps0BWdVDda4X4EyBPHS8z9altshi/o
 sHGkIZdG
 wHVMjkpv9n+za6Ycjrvfk4sj9clrRor78oeWsXP73ZGYzE3Ke6tcsgvZw4PFZjAxmLz4fA4dXVTtlSIaeLXHtN5qt65oEiJ0SPEh+mnlK6sj7UDkwCutI49g2Kvu5qIT4h9kPFESQeYeDGdArXjAZsE8r2+uG2FCzkyTZMrOY64672GvG0WfNmO+Cvr53Srrn8uK0bf2+oAU9gT0GJ/XxATpg754r9ooo+ZYRtvlxtwMeOMz3jdaEo3qDkjy3hz1WGNuESR29pGrAp70u2n3d3hao7xORAbJWYcSs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() intentionally had no "destroy" counterpart. Every
caller has lived in core kernel code and creates its set once at boot,
so nothing has needed to take one down. However, KUnit tests may be
built module, so we need it now to support the coming tests.

Some caches have size aliases, so the same pointer is stored at more
then one index, so we have to save it, clear all matching instances, and
then free the saved cache pointer. (This is what the bitmap was tracking
before in the "allocation failed" error path.)

When CONFIG_SLAB_BUCKETS=n the whole body compiles away, matching the
ZERO_SIZE_PTR that kmem_buckets_create() hands back in that configuration.

Link: https://lore.kernel.org/all/20240809073309.2134488-1-kees@kernel.org/
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h |  1 +
 mm/slab_common.c     | 50 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 31f97e2579a7..034d4d0ece00 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -892,6 +892,7 @@ void kmem_cache_free(struct kmem_cache *s, void *objp);
 
 kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
 				  unsigned int usersize);
+void kmem_buckets_destroy(kmem_buckets *bucket);
 
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 885aafa23da7..fb1dd15953a7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -430,12 +430,9 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
 kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
 				  unsigned int usersize)
 {
-	unsigned long mask = 0;
 	unsigned int idx;
 	kmem_buckets *b;
 
-	BUILD_BUG_ON(ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]) > BITS_PER_LONG);
-
 	/*
 	 * When the separate buckets API is not built in, just return
 	 * a non-NULL value for the kmem_buckets pointer, which will be
@@ -487,7 +484,6 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
 				goto fail;
-			set_bit(aligned_idx, &mask);
 		}
 		if (idx != aligned_idx)
 			(*b)[idx] = (*b)[aligned_idx];
@@ -496,14 +492,54 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int useroffset,
 	return b;
 
 fail:
-	for_each_set_bit(idx, &mask, ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]))
-		kmem_cache_destroy((*b)[idx]);
-	kmem_cache_free(kmem_buckets_cache, b);
+	kmem_buckets_destroy(b);
 
 	return NULL;
 }
 EXPORT_SYMBOL(kmem_buckets_create);
 
+/**
+ * kmem_buckets_destroy - Destroy a set of caches made by kmem_buckets_create()
+ * @bucket: The set to destroy, which may be NULL.
+ *
+ * Destroys each cache in @bucket and then frees @bucket itself. As for
+ * kmem_cache_destroy(), every object allocated from @bucket must have been
+ * freed beforehand, and @bucket must not be used afterwards.
+ *
+ * Context: Process context. May sleep, as kmem_cache_destroy() takes the
+ *	    slab mutex and can wait on RCU callbacks for each cache.
+ */
+void kmem_buckets_destroy(kmem_buckets *bucket)
+{
+	unsigned int idx, i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
+		return;
+
+	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
+		struct kmem_cache *cache = (*bucket)[idx];
+
+		if (!cache)
+			continue;
+
+		/*
+		 * Sizes that kmalloc rounds up to a larger size class share
+		 * that class's cache, which kmem_buckets_create() then stores
+		 * at each of their indices.
+		 * Drop every reference to it before destroying it, so that no
+		 * later pass reads a pointer to a cache that is already gone.
+		 */
+		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
+			if ((*bucket)[i] == cache)
+				(*bucket)[i] = NULL;
+
+		kmem_cache_destroy(cache);
+	}
+
+	kmem_cache_free(kmem_buckets_cache, bucket);
+}
+EXPORT_SYMBOL(kmem_buckets_destroy);
+
 /*
  * For a given kmem_cache, kmem_cache_destroy() should only be called
  * once or there will be a use-after-free problem. The actual deletion
-- 
2.55.0


