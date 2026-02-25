Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208B6FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1416B00BA; Wed, 25 Feb 2026 11:34:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F2F6B00BB; Wed, 25 Feb 2026 11:34:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A836B00BC; Wed, 25 Feb 2026 11:34:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD6D6B00BA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D77B787F27
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:14 +0000 (UTC)
X-FDA: 84483526428.08.26173B6
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3786020007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1rsPRTHU;
	spf=pass (imf13.hostedemail.com: domain of 3gySfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3gySfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6B7L7o41Oxea7KFZzUcBIICs8iJlEAxQhGkCpMBeOa4=;
	b=ikrk3qD+ot+FgUhPElCVLoyRuRo5KwF2PJyQumSmLLiI1AatXwIKVHb0mTfW9XlGG4M3IM
	4onmkunhKRCEFGS+ttEP1R1VXIKgq2PGnACX4zYpTy1nMfgqihChDy5PJHw22gEPfiibPF
	VAJz4uXC93F2GXkMV1xzE54gSXoZLFU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1rsPRTHU;
	spf=pass (imf13.hostedemail.com: domain of 3gySfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3gySfaQYKCJwOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037253; a=rsa-sha256;
	cv=none;
	b=5p+XtJvBtBjpzs6LYuHQgOB3hz3TgoMg4R1sHKY/x1flpQ5MTKx+U+Yrgr60355ZCAhJoU
	73Ne6aAueIk8KWxAiMD+ZuHWK3jEtYcKaU6A7mvROtpzLp7pd8p4OvEqE3WUUoKKPkZoYX
	+52WKdtAxO/YppSM1tOBfxSUA1hPVMs=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bd808454d6so40376784eec.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037252; x=1772642052; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6B7L7o41Oxea7KFZzUcBIICs8iJlEAxQhGkCpMBeOa4=;
        b=1rsPRTHU0/kK+M8HSiS3YituBDMePwlm19QXjfxsd02Iklbf/Hxut2vnRmiCmRS0pY
         7eSmHtuM1Qms4Nsxmu2uLfkjYj1fo/+c80WZIDtKZcBTRyHfFtzS/phxMpp56T5kLihV
         bdc9XL7eZh6dj4LfOZb/eSbI87ywNZSpHDJm0ACTBesj79yD3Hu/QJYqceHHd+q7+LNE
         te2brl9fhvlUDm3vL6Hd6DpbTQE+hExtvS+5cZegrb+C3a+dqx6yyn4kPohBN/XuOu4x
         f0wopVUGNUYc/H6ObsNy7yfhxMOpVzMH7TC5UOtYiwAmBnLX5zTcVSnb+RBgJ5DBiIme
         001w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037252; x=1772642052;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6B7L7o41Oxea7KFZzUcBIICs8iJlEAxQhGkCpMBeOa4=;
        b=bqBJH0TI+43xEajxvsVujXoZUxH3v6uwPEAzVnoOBliT22y1MaI0jCh0+pLnYwMcvX
         QR5tIwE0JpxeoANZ+yrVYfcDXy9uYi/ZhpUdrC2hPMzyRjYKPftOU1WRg9tvyM5yk4TI
         +2mLJ5W+MLnTV2Avu3n0B06beAzH3qi/e5ljJGIqJFaQwABfctzVB8S83OmU0zGit5Do
         0Gfw2+dZBQg2CYIzhQXr9WigD3jph5kFsMG6kV+2HK0NVR4MCxcrl/BfEhth+2ECTa4B
         jqRG7a/M8KkGueFJhTt6zBm08NLs94kN9yLHWwEVK2MS02PCf09IYPKhv5WO1GmxsQ3U
         sTCA==
X-Forwarded-Encrypted: i=1; AJvYcCUKTznhfWRgdI4DSvE9BLOSeudJt8Z+QjLLiPN9zVF/EO5qO9pQQepziuik7y9CWm2JhfZYV+kI/w==@kvack.org
X-Gm-Message-State: AOJu0YzUyvimiBP7jkOfBfQn1UR0MbkPfhVj6SxsSWifU2S0HHpmVPJN
	1owLRkB028HJdmujZPXPcSYXEwRKIePO/552uQdOlIYPRf+7L6XgbB2Wz7nZlxOUmyv1LJPT+PU
	yvQkLaQ==
X-Received: from dycqw12-n1.prod.google.com ([2002:a05:7300:c00c:10b0:2ba:b709:6d63])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:7492:b0:2b7:da6d:8e8e
 with SMTP id 5a478bee46e88-2bdcbf46311mr522707eec.4.1772037251637; Wed, 25
 Feb 2026 08:34:11 -0800 (PST)
Date: Wed, 25 Feb 2026 08:34:07 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225163407.2218712-1-surenb@google.com>
Subject: [PATCH v3 1/1] mm/slab: mark alloc tags empty for sheaves allocated
 with __GFP_NO_OBJ_EXT
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, 00107082@163.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: amdo589wc4khdxc51p7mw9cn95dxoits
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3786020007
X-HE-Tag: 1772037253-301652
X-HE-Meta: U2FsdGVkX19lARXmU+u1bfk6YDXq8+b6zuBTR9Yr4lbm1/Y2sWUzh6HQqTNCP9EvPn0NKQZr7f2x3ugX5W81fNQy5Fvy1z8ejJ2HS2TP88/eHj5SPxU8mEjTnc+zYZQ9jsBCcfPPlXuNSRucoogr1qiq27WiGv4L2taarYyC4ZPBq1dDm83OPo7dq8DeON8HVMlOtI+uX0iiYySzDobgAUeAuoFUiSALPYApTiS6SqENWwrcA9HZLA+jvb/oM/eMauTQVSskW12OcqlmA8sIewsajqHe/+5IyfoFm2fUvUueMb3ETs+3zCWv0Dbx9/4Al9DAPCtViRdMta2lHQpSS9fPujrMB07pohizP7acseh+pdqRywEiSrjYadh0rAT+ucQD9iixid7G7G5VmjxmCDGcqHnX4YqLNtldA7sTE4gNTqPjx9ug4/E6s5OC3whuWHTcHadmTT7rf1coteZXED9SzMY55ame0cy0oiLqpH1THulUP1YN10b39xBeRErdINinK2HeD3i+hLlDVb4OVwUQRpErI3hA5cIlD4h7hxpcW7j92GmafyPue9GLnfugWSfGqm6eNHQq/UK03DXREcyq8+1m8q3RRDImeJ4r77wr7iXVpP7T9QEJcVSX9ZA79NdxtnCbSdbo06wagewFRCzaUAFP5kk+3fwwisqc/uMiQEBXRDuWwXkRAekeOV9wI3TTakuPD0Obpg0/QUJJnbW/VzuyZNu+i9mMFZhI7NQJ06zhEr8+iEdCnRu9f5LGseVCjled2xYbXFR69EpOe7nG1RjV+YiBWZ7m9W5K1iWm/nGkiGvoRM0iiD4oXjCX37+zgufBA/v0QQeSu9cJSS2RMokP+08oKhhsni9vNoUJwiK+XxUYXUEB8i9Z6MLuFq1DIeNMaMnXI/QMPEQUO9h5o9PWL+YnCdZGBh4QizX1hwm6N3P/m7DH9YWv0KBbZvNe/ZfGFWhF78ceOI4
 tAW2czwi
 sMmkHTcVZEQ+ivAJ80O5RzS8dltCf8WLzKv0I00o5f7u5gQL29vFgBgdSFa7SqnSrNgppWD5VqBe2252lMuLiaCy7+B+TsR6lHjhdrsVYmuu1g4Sndo8TTphrtKevQP9TNV36pALgwpsO3VG8gfYpQ7EgyOQKQpZq2K9YCOAmgqmNKAHppCGoHTlqAoRkeJmq8S0tSttUH51nuVXhhnNfE0k5EA1+AZGNAgIjL2hm9lRQx1KSMVZ+OTd6EqWq1rxQQNCnb37AYSNaVhZ4J9M8tFIg402g3BPbNSNOptPxgUT0xA01QYWmd/U961E2ZZ8FCf4LFXXNZOL+CQdwdZaz0x6AnP9OWpWK3ytAMRQOp/dcFKjvQte43D6xxRom4HUodVeIUHP6N41uqj0oyZK7/CPxvgljA3NdIu31y7ReHLMJfYzG+hfDhDmY+RQq++GefYDztdoGF43C7lfGskHuz6G5hOVgWR+l5mRKm68NonrninS9UXdzE5u64fzReV7J1QYIX43Bgk6p2P/DX9zfn+kdV0BYOXSw5My7oYMawAkiaVHevDjy4Tr/uJdv9YUPSaB8kW2weJMSa+AyqgW5h63PYCzvz5jFQfyCHYLI2Zzv4qW3ZBH7CgCsOkUWTk2muT6jeDPhA35ecYY4x3D6sMlvPWnNhNtUmhgRyTcmA+I4KoCfjj3VvWgcA/8vsePVAwe7s3xMSZhHAl9R4C4bGIWlmz/aeWX+7peWEJg2iJNdXgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_empty_sheaf() allocates sheaves from SLAB_KMALLOC caches using
__GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
allocation tags empty before freeing, which results in a warning when
CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
tags for such sheaves as empty.

Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.com/
Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: David Wang <00107082@163.com>
---
 include/linux/gfp_types.h |  2 ++
 mm/slab.h                 |  4 ++--
 mm/slub.c                 | 33 +++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 814bb2892f99..6c75df30a281 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -139,6 +139,8 @@ enum {
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
  *
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
+ * mark_obj_codetag_empty() should be called upon freeing for objects allocated
+ * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
diff --git a/mm/slab.h b/mm/slab.h
index 71c7261bf822..f6ef862b60ef 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -290,14 +290,14 @@ static inline void *nearest_obj(struct kmem_cache *cache,
 
 /* Determine object index from a given position */
 static inline unsigned int __obj_to_index(const struct kmem_cache *cache,
-					  void *addr, void *obj)
+					  void *addr, const void *obj)
 {
 	return reciprocal_divide(kasan_reset_tag(obj) - addr,
 				 cache->reciprocal_size);
 }
 
 static inline unsigned int obj_to_index(const struct kmem_cache *cache,
-					const struct slab *slab, void *obj)
+					const struct slab *slab, const void *obj)
 {
 	if (is_kfence_address(obj))
 		return 0;
diff --git a/mm/slub.c b/mm/slub.c
index 862642c165ed..34c32749f091 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2041,18 +2041,18 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
 
-static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
+static inline void mark_obj_codetag_empty(const void *obj)
 {
-	struct slab *obj_exts_slab;
+	struct slab *obj_slab;
 	unsigned long slab_exts;
 
-	obj_exts_slab = virt_to_slab(obj_exts);
-	slab_exts = slab_obj_exts(obj_exts_slab);
+	obj_slab = virt_to_slab(obj);
+	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
 		get_slab_obj_exts(slab_exts);
-		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
-						 obj_exts_slab, obj_exts);
-		struct slabobj_ext *ext = slab_obj_ext(obj_exts_slab,
+		unsigned int offs = obj_to_index(obj_slab->slab_cache,
+						 obj_slab, obj);
+		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
 						       slab_exts, offs);
 
 		if (unlikely(is_codetag_empty(&ext->ref))) {
@@ -2090,7 +2090,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 
 #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
-static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
+static inline void mark_obj_codetag_empty(const void *obj) {}
 static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 			struct slabobj_ext *vec, unsigned int objects) {}
@@ -2211,7 +2211,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * assign slabobj_exts in parallel. In this case the existing
 		 * objcg vector should be reused.
 		 */
-		mark_objexts_empty(vec);
+		mark_obj_codetag_empty(vec);
 		if (unlikely(!allow_spin))
 			kfree_nolock(vec);
 		else
@@ -2254,7 +2254,7 @@ static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
 	 * the extension for obj_exts is expected to be NULL.
 	 */
-	mark_objexts_empty(obj_exts);
+	mark_obj_codetag_empty(obj_exts);
 	if (allow_spin)
 		kfree(obj_exts);
 	else
@@ -2312,6 +2312,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 
 #else /* CONFIG_SLAB_OBJ_EXT */
 
+static inline void mark_obj_codetag_empty(const void *obj)
+{
+}
+
 static inline void init_slab_obj_exts(struct slab *slab)
 {
 }
@@ -2783,6 +2787,15 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
+	/*
+	 * If the sheaf was created with __GFP_NO_OBJ_EXT flag then its
+	 * corresponding extension is NULL and alloc_tag_sub() will throw a
+	 * warning, therefore replace NULL with CODETAG_EMPTY to indicate
+	 * that the extension for this sheaf is expected to be NULL.
+	 */
+	if (s->flags & SLAB_KMALLOC)
+		mark_obj_codetag_empty(sheaf);
+
 	kfree(sheaf);
 
 	stat(s, SHEAF_FREE);

base-commit: 7dff99b354601dd01829e1511711846e04340a69
-- 
2.53.0.414.gf7e9f6c205-goog


