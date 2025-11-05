Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3397CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271C18E0014; Wed,  5 Nov 2025 04:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228CD8E0002; Wed,  5 Nov 2025 04:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111218E0014; Wed,  5 Nov 2025 04:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED1988E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4BCEB771A
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:47 +0000 (UTC)
X-FDA: 84075970734.08.E07D715
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 837A91A0007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MDolg0SQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XoHMwYvX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MDolg0SQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XoHMwYvX;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bv7EzbHF/HHIgUO7NDMRC4WExXuoyCIClo0HWu7ZlNQ=;
	b=JKba0nFxXSrMYNcDzBB5x+h62f6p1qc1HUHhhUnmV5j21LxO7+4Lf8hSuFHPV/ldKM48EL
	6k7AJIupPnmL+hpYovaSmVBa5SW+cChmXvC4M1E1GGxVp+kIXFWxelHQ6tDHDqRPaT/l+B
	Lxazf5PKjVFW0tGpnwjfBxnV05uf3aQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MDolg0SQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XoHMwYvX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MDolg0SQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XoHMwYvX;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333545; a=rsa-sha256;
	cv=none;
	b=soJV1dLjR5GVWTwj5IFtBHD1A8rPQ7BH/U9KWK8DVLnPzJP2+ymP5ZGRGcrwZOgCrUyK02
	0Uu/rvhez6u1fAlFMELkv6VyohLVE/fMkCv4LXzVJ+5BewfUecCkXQkPVCTDNvZu9ZzHz2
	TJ6bSmXeC0iEdVnLJHuXQ0wunooYP3g=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0549E21195;
	Wed,  5 Nov 2025 09:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bv7EzbHF/HHIgUO7NDMRC4WExXuoyCIClo0HWu7ZlNQ=;
	b=MDolg0SQbwuDoM6mlTAPFBYki3+2lcZXpjza4oXFaO8af1dKPJD4zcsxEt1xLLuucYmzvz
	u4AMz3y9hvUQZxH2Xh4gSRTwWJVccP5gs+Q7vOPdj3pFAf3rqjG6/4Fld6BBb+s9dF74fN
	v+Runu7B4uBflwhYnlGrBgjaatb2Lrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bv7EzbHF/HHIgUO7NDMRC4WExXuoyCIClo0HWu7ZlNQ=;
	b=XoHMwYvXMYHg7Sxh7pcRF41N0mdzvf6rRdQtCPTObp8uh1WgNZDtGe8q50a/HrPNeK0KBE
	Vq3MS4TmXWfaYFBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bv7EzbHF/HHIgUO7NDMRC4WExXuoyCIClo0HWu7ZlNQ=;
	b=MDolg0SQbwuDoM6mlTAPFBYki3+2lcZXpjza4oXFaO8af1dKPJD4zcsxEt1xLLuucYmzvz
	u4AMz3y9hvUQZxH2Xh4gSRTwWJVccP5gs+Q7vOPdj3pFAf3rqjG6/4Fld6BBb+s9dF74fN
	v+Runu7B4uBflwhYnlGrBgjaatb2Lrs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bv7EzbHF/HHIgUO7NDMRC4WExXuoyCIClo0HWu7ZlNQ=;
	b=XoHMwYvXMYHg7Sxh7pcRF41N0mdzvf6rRdQtCPTObp8uh1WgNZDtGe8q50a/HrPNeK0KBE
	Vq3MS4TmXWfaYFBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDA6213C02;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iPalNVoTC2lSBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 09:05:30 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 05 Nov 2025 10:05:33 +0100
Subject: [PATCH 5/5] slab: prevent recursive kmalloc() in
 alloc_empty_sheaf()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-sheaves-cleanups-v1-5-b8218e1ac7ef@suse.cz>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
In-Reply-To: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 837A91A0007
X-Stat-Signature: cfxptce39o3pwh4m71s74fm9xj6capix
X-Rspam-User: 
X-HE-Tag: 1762333545-443725
X-HE-Meta: U2FsdGVkX185a0Q6dbcfUpn6cJVm7ByFTrigukQVY+9uN6yv4dg+3CBKpIYI07PD020+fvzT8ReALUpztfxXmVse5k+8mQ5xPsvgBInACTVm69sBOlmvXva6xFPMglZSrmrRdQh5krlZU5oTaGqVTF17jI7i+vbW6/K5M8kTbZz/U1TtvK6+M0eYEm4jRWLMspca057D17mqHdvcbvb63XVud59oletgrs1evqER8ZCvOmVkVf35T/H9zg/8/fTn5VeYyP6M0yMP9SfHOZTdzZpVGGNO0jugFP76vbXG7tnSgdMR1eN/aw+d3V8PlznihgpGDWTtN/Sc0xUnDzUmWNvIsdO0Ar7hCFjQ4qiF02zSVBrT6ocWM2lZ3dZtPmTy0VSWHHrhO/3VaUTWZNl7O8HF69QCrHIpNp83yYKFy4KHg/LDqpnzp+tj1MFf1tqrUY5OiYJl0KrCtrfntuUGn2v8GuSnuyKCNotrAdoL7uVykWr0VduPPaL1osSiurFIRHpdjR0YauoetF6R/WQo+Abm4O4M0kUxuNzi/otmsMGkiJws37k4nNIqC2yZGuOV8tsnuVKG6WgUYMPFUaTV69hmgjf3vwUvwWWW49VLAG9uDGmDv7Eu0E3SKp0xaR6A8noyT1YONu48bUOXeXvEcHVTWKU0Hwxn5W/Ec3ZozEtyXzH6JJbY6pncABF4zHoCH8/6Pazd48J4L9NA2ioJztQT223XAKaKVs7O/tEizaD06sVWcSj7a5Xdr1L/MQC0tZBd4E6w7CrJGjoZ9u/TujxoNxSB57el3sWC7x4vo5JcKe3GQoYoNJ1SX9PqfvUzxd62c8R0hgw2sMtYv88igH371aAyEyg2Nwbej7aqOhhpFZ2WneAOTiWDlgNQ2nHzp4v5Fw/wxWHZpedeLXNwt9pwniG0hS45hsgqMrZYIp/g/DD7YUyFawKDxwqybkAG7RFcyByBzrMA4/2TxUM
 gT7J4GHn
 Ta2ESWAytkfRg5B7iU/bZ7DNvs/AD0Jt8hJxH3jH71j5uNa24KGX2B1EkatRTBKsBSrx0Al1cszZOonwfkCq9+TlogEdPtAZ5DVEfB/eVP4z9VI8A8lxTbm6DnJpuT3mMS7VXjmdTZYFEejdzpQay1eq8Ez3M5rUjHGzbPxbD58a2dNuqT+bgpfJ/LAMexv19CchGaQ1uJvcfszc8TUdkT8JfIpSdjwnKcBdCsNWhoMgzJhKCeqeliCBdsSTsJ9WUoR0cOm5/anIFVxxZNwc7naerrkmfRSIPX+f5D+gFNtPRUs4I/HE6F9TRXmkOtuUH/rYTQpFCX4rHgIQ=
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
index a7c6d79154f8..f729c208965b 100644
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
@@ -2596,8 +2596,24 @@ static void *setup_object(struct kmem_cache *s, void *object)
 
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


