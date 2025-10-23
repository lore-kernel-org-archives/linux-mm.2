Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB604CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256EF8E0037; Thu, 23 Oct 2025 09:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230518E0002; Thu, 23 Oct 2025 09:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11DC28E0037; Thu, 23 Oct 2025 09:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F23C28E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7D4A1297B7
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:35 +0000 (UTC)
X-FDA: 84029521590.23.FDCB484
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1AC5140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MOGWAwma;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r0KxwQdA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mOq003rK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G2xmdjNN;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227613; a=rsa-sha256;
	cv=none;
	b=LTeh6ELEzD0ToYi2UGv1Yfu1Fxs1sehATl5SSiAxAU8uIfZftR058AelQzXPnbN+Fnirss
	k/snwS6ggLwumeMtiqKss3e4/rhCVIhu1KvLHzlfhjPThN+Xyjv/ouY22TEUV2olDuKoNu
	x9+zGBUOBSJ+m+xolYHDa2apXniXi3k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MOGWAwma;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=r0KxwQdA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mOq003rK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G2xmdjNN;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDkwJ98STTAq4ia+HrB8vgXHgqJB0sa+3LSjpxlnzDw=;
	b=6ql/EeMmFJGcrP1+wmRVUTTqvvix4OMFTglR4hRScJDiN088XJc3sGjFZJr3dtpT7grjLi
	/PrhPP6zVl8dzXsihijW0QfSi+DySDC5iZzxNI5U3HFp7LTr+L6Jh2MiqsLUqpW8HD5OHI
	LgfmQLJDGdm2/wn2nj0d4qsDKA3JWfg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7F26121254;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDkwJ98STTAq4ia+HrB8vgXHgqJB0sa+3LSjpxlnzDw=;
	b=MOGWAwmaoxKEnh8vs74Hcm4pw0oIiAYpsXZriSfUVqTO/TTa8aNIVXta266scg2cOMd8Qv
	t0qZZ1IcDUG8vgfvKosfoeXzmGfX2CYXEvSHE8e0Li/jkQWECrSx8AwJAlNCCVznLZgFvm
	x/lEzypTjtiF6PJSDGm4mtligfLvMgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDkwJ98STTAq4ia+HrB8vgXHgqJB0sa+3LSjpxlnzDw=;
	b=r0KxwQdAaUdUL4Xo2aWfDNJ8mH2RKeMubLYcyQhUHULjZ+J+e0eb5HEK0MXimGt8QpDGSr
	B+knkOqEOuW2NXDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDkwJ98STTAq4ia+HrB8vgXHgqJB0sa+3LSjpxlnzDw=;
	b=mOq003rKXktTSzUTadRVLVn+t7Jn4gCK9rN8teDDA5fd73LlacqNoctDMLg0dFwi71e3qd
	J9RHX5su+pP2opVCJ2x9Hu6RYb4+HFHiTIdXgd4LYOONkTfEJcFE4wHb8dzkLFYTn+okwI
	mBJLCh5CGmyCJBOkIVIPfuixg8XbQ5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDkwJ98STTAq4ia+HrB8vgXHgqJB0sa+3LSjpxlnzDw=;
	b=G2xmdjNN0GsWMJ3Iha/JmZA9J9YOZT7o/B2QC0VLw6OCrLfwqlMPo5Dbd8VJ7+qsYZj41S
	UN/NXM8hjUDvw8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61FE713AE7;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aBahFzUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:26 +0200
Subject: [PATCH RFC 04/19] slab: prevent recursive kmalloc() in
 alloc_empty_sheaf()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-4-6ffa2c9941c0@suse.cz>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: etidxfsdoz8sx4sncejkocftwzt8mwcc
X-Rspamd-Queue-Id: A1AC5140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761227613-871366
X-HE-Meta: U2FsdGVkX1+FyPEjTGMk8u8HPW8JBQafrtuG3YJhWiFDZYPo2/3+40CkIDZ08XB5pDd3fi54pXhqfwg0ZQpnZvKHuaxE0syUzuIEJ99B+C8gTK2L2oPderATBY/Pt8tTD+aJFLjoFMiJ9WWDeDTGpF7cuVKTOKmJ4sMnnsYRexh2IEqYZvNv9afULRGSBMl0uDm3kgv8AQ0neDNxTQE0BOPwJobPbEaZLsaAyZcoQtOU8MegBxeEvAh4OPRNfVpk/sJ4k4iNvoFk48uFKa7JjacyDVQxxogM2uitBKRWhZSpUHJ2s1Jy+gQVyVfUBR5NwjYvAZf65g1EJFxV9AUARg1q83n5lb9T4olsz3u4aUwAGCQ+yIyZHCL6pQ9KwFFvrzEI3WpGscfUqVkHfrpBnMkGHNzp9DERJQPiu29pI55p2KxtBmvQD0jyx4AYljwOI/4oE8bGi2RJsYp0XlMAMx86mkP9q00IXWXpZax9mvmwBxpwvR9CIGPdaH13ppP/u/9C8JD91WfDjLoRYAvMiCJWYXTsuPHgXBC9g/M6AWcUxipVArS4MxhfpY5y9Zz1AfJuBJAEAYNwfPrqm8Yv0YkLzZ964Srql6Vi9f/givqZhanDZfS7Fy9A2h0xcluYVZVMEd5AnA+6T/UxBsHW54xIqude6HVoYnWcpny4JVOvxOTSPGQiVQqF5WmlVfYp3NBeTpN2oRabrjdELip58hjcNJ4oCrsswUTcwM1pzWrnuWSBEZccza+ESUHF8x+txiCja7Bv8NsS1hpq95gxKwD35UmVt1aMBGDA4HoNM4pLzg0e0u7mrK98QYx/PHcCqxrQZSPIPlCiGnBE2XRcPzJdxgdX3mFWt9saD9yervsRHo9JpArTQWGwRKNopGKrYmc/ooXBMWpHxq0puAxE9tSOlPli2DnioPi4CILYQ7pPh4GezDUwPH2IX2OzOxlw44LTAGBSpOC0J1C3u7x
 ZEbSNvR3
 vW/LKA97+PMLB2M8vhWODzcf+izYwySvuEUVal5v4YCd/2/yuIq83UzI3T4GKggRmX3CVGDrJlSGTiYsVOtV8hoCV7xDO62MqAbE5c7bzMdeIP5/qCMzYiLFm+s6DM6z7H//CkeXKxz4QwsF0aJF9DdfnDK1kYzoJjsLRqSiMTD8t4iOlrdPT6rDqzyYtV9EfXcYA5ZJM7KdUHOFvPsMGdXbIUXcvkGrSRhAJmwAqPIzkGjLWF7vP1eBCt7hrDt8+knVJGrV2XFkh3m0mE3yGmtsSywJk5gu1hPNOBLunPaxERKeJBNj1iyyRmoB+JMvP7bgcHe8HsFyi7r4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to expand usage of sheaves to all non-boot caches, including
kmalloc caches. Since sheaves themselves are also allocated by
kmalloc(), we need to prevent excessive or infinite recursion -
depending on sheaf size, the sheaf can be allocated from smaller, same
or larger kmalloc size bucket, there's no particular constraint.

This is similar to allocating the objext arrays so let's just reuse the
existing mechanisms for those. __GFP_NO_OBJ_EXT in alloc_empty_sheaf()
will prevent a nested kmalloc() from allocating a sheaf itself - it will
either have sheaves already, or fallback to a non-sheaf-cached
allocation (so bootstrap of sheaves in a kmalloc cache that allocates
sheaves from its own size bucket is possible). Additionally, reuse
OBJCGS_CLEAR_MASK to clear unwanted gfp flags from the nested
allocation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/gfp_types.h |  6 ------
 mm/slub.c                 | 36 ++++++++++++++++++++++++++----------
 2 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f905..3de43b12209e 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -55,9 +55,7 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-#ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
-#endif
 	___GFP_LAST_BIT
 };
 
@@ -98,11 +96,7 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#ifdef CONFIG_SLAB_OBJ_EXT
 #define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
-#else
-#define ___GFP_NO_OBJ_EXT       0
-#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
diff --git a/mm/slub.c b/mm/slub.c
index 68867cd52c4f..f2b2a6180759 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2031,6 +2031,14 @@ static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
 }
 #endif /* CONFIG_SLUB_DEBUG */
 
+/*
+ * The allocated objcg pointers array is not accounted directly.
+ * Moreover, it should not come from DMA buffer and is not readily
+ * reclaimable. So those GFP bits should be masked off.
+ */
+#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
+				__GFP_ACCOUNT | __GFP_NOFAIL)
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
@@ -2081,14 +2089,6 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
-/*
- * The allocated objcg pointers array is not accounted directly.
- * Moreover, it should not come from DMA buffer and is not readily
- * reclaimable. So those GFP bits should be masked off.
- */
-#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
-				__GFP_ACCOUNT | __GFP_NOFAIL)
-
 static inline void init_slab_obj_exts(struct slab *slab)
 {
 	slab->obj_exts = 0;
@@ -2590,8 +2590,24 @@ static void *setup_object(struct kmem_cache *s, void *object)
 
 static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 {
-	struct slab_sheaf *sheaf = kzalloc(struct_size(sheaf, objects,
-					s->sheaf_capacity), gfp);
+	struct slab_sheaf *sheaf;
+	size_t sheaf_size;
+
+	if (gfp & __GFP_NO_OBJ_EXT)
+		return NULL;
+
+	gfp &= ~OBJCGS_CLEAR_MASK;
+
+	/*
+	 * Prevent recursion to the same cache, or a deep stack of kmallocs of
+	 * varying sizes (sheaf capacity might differ for each kmalloc size
+	 * bucket)
+	 */
+	if (s->flags & SLAB_KMALLOC)
+		gfp |= __GFP_NO_OBJ_EXT;
+
+	sheaf_size = struct_size(sheaf, objects, s->sheaf_capacity);
+	sheaf = kzalloc(sheaf_size, gfp);
 
 	if (unlikely(!sheaf))
 		return NULL;

-- 
2.51.1


