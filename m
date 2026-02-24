Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC4EF4BB8E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 22:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08896B0005; Tue, 24 Feb 2026 17:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6296B0089; Tue, 24 Feb 2026 17:11:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5196B008A; Tue, 24 Feb 2026 17:11:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93BEE6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:11:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2085B16035F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:11:39 +0000 (UTC)
X-FDA: 84480747918.07.5739C6E
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A006A000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:11:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h+k/sJrW";
	spf=pass (imf25.hostedemail.com: domain of 3FyKeaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3FyKeaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771971097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qycKKgU6VgldoipiskPTW54PIVBltJjFeFRiKOAJQio=;
	b=QnbslEudfoKB9s7wpyqeCtVq5mbhwhLGgNYO/sOpsvejK8JVplDsHv5vLRdV+EkkOqaaFP
	BNTj7JtAHXi2+9zFgtFfiNzwLsEtsl5ECu79t5t6VBq9p+aba3nF0pYMeOUg9ZLE+wP6X/
	mjc/LCbuV811Z+LTvWF8REZsKZkmKj4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771971097; a=rsa-sha256;
	cv=none;
	b=jDSooD/fJb8ZRRx6O9V6FTcmNLOlv8l9Ek3wjp3Vw19qbG11zydlPlMjjBQZ08H0/1q5nS
	ioV94if1LPEDpoehSuuEUY/T2ks+1C9Zx6ko/CqTDhBHACv9T3YtKJl+O1A1J4aAggWraa
	XK8U6lKrCwMJUF1iGM+HVsY/CVxd0dc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h+k/sJrW";
	spf=pass (imf25.hostedemail.com: domain of 3FyKeaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3FyKeaQYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2bdc1b30ac8so1968631eec.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771971096; x=1772575896; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qycKKgU6VgldoipiskPTW54PIVBltJjFeFRiKOAJQio=;
        b=h+k/sJrWDTR9X2zlekyRXlaxevNGwK/V7RUkSntcCaYuNi/1SugMuSFUjFabrsVFpg
         J/odZbpHT7HP0LITIXGvlWwQkQ4KlBVrJlkZmMWUA1PPyAfw9wPiebOTKdXMLGcNTReQ
         bsBP+Ol9atebViiPAau0zoyDNZz8QpFM1neKZbUHaYYR1u50d5CC7lJZXYQ/VAi80vWb
         ii6P3gnyOkVOteTA50QgtacfrOHVgFWy34KNR/krWGjU9Re6scFIgRDymkinvEIqw9gq
         F2a2HMaeYwUzirYpTmYqrStxTpuON0MKvVLFrIVYqlrD+WSF5Zsf30gidRE4SNEc0aFn
         qa7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771971096; x=1772575896;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qycKKgU6VgldoipiskPTW54PIVBltJjFeFRiKOAJQio=;
        b=ZDVTqKoL2CqOYvzqhsh2dXJAvUxgfhMStmioCfOq+I0edNkAYEy3SYKYe/Q8xv6QGI
         VHY4v6OkLg6NpWBCNCP4zoObrUsiq/U8ftYfjTMDbuItD+s3NvmqpZyKGLn5++iqlln3
         ZP61Hyl2aoWikY65EOWBw/amD54pwpv6Pp8q/wAb7hWcBENMo7HLE46HWbG9PhZ359hn
         rTHQbRQQbrQirpK2Mk+9FAzBWcSypsuT5mq0xfH8vdcP77GQ+YyRGjiNtYGysXLtFDl3
         +ukaubyNVqi/oqvI7GZrQAYnRAMMmKKWvMkOkKYNcXkjGk0ULxKjoLLvt6Eqld0yeO7z
         AbMw==
X-Forwarded-Encrypted: i=1; AJvYcCU9eXoKTYEuWk1UcgdBXy7DJaIDISD1kXoPxZHbft9GqajyJ8a6bEgYNCfEnLAnX1D+3gthzy/RQQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9VZ29Stq1IOiOOV2E4vib1EM1NhIsBWW0ypJAHpu96xakpBZY
	eR1ry8IBMH5skTED6w9HiWRjNj0UzKyTTRltPFjPDAO/7t1NAMUWxz/w4J1t6VXrxyh8cBo+WOc
	I8o02mQ==
X-Received: from dybcy37.prod.google.com ([2002:a05:7300:b725:b0:2b8:6bda:d37d])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:6085:b0:2b7:f33:34e7
 with SMTP id 5a478bee46e88-2bd7bd711c0mr6268330eec.35.1771971095833; Tue, 24
 Feb 2026 14:11:35 -0800 (PST)
Date: Tue, 24 Feb 2026 14:11:32 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224221132.1702713-1-surenb@google.com>
Subject: [PATCH v2 1/1] mm/slab: mark alloc tags empty for sheafs allocated
 with __GFP_NO_OBJ_EXT
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, 00107082@163.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5A006A000B
X-Stat-Signature: jmenine9ciyhiudybz8jadx3dqw78qg7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771971097-510789
X-HE-Meta: U2FsdGVkX19dnTzRQlcTC0yaqavlxYs30Y3RlMvXEdpMVkTwg7pJ8aWwpFEMg6QijsTg70F/PmAcFxJD4te38MS9MdZoCddYv4NynrYMZkUPn8A35yXM/yK1Ti3Z3SoAiE4I7KDjIq4w880Uk6CMGT/d8GD2WmzF0ifql4g1ImBVF5X0mjJWiGXAadRmqp2dxKseKygF6z9/2zf8vG4nFPbx0F+GOVe7XT07U1ARbaBLoZqB3JEeow6KlWnX6gDB9bqOFbOrreRoCUBsvkN3Z72RNBuHSBnTy+PMZnxrradmfBjmDNwXKrmhwEWmxx6bAdNITDoTRXrMXhb3m4ELrN+qY5r9FUbPjvZUSLNl0tSSnwL+CtYyRri4JSdup1ZiI1bY1wHwqpXtlwJCHpfOks6xWkKx7X6yfIpRy2UUWAZjvvqdDCJJQ6viZB81TC2x3AgzxoU/1sUuPpbIDWUs9ilL7nKeoe5g4qKQ+SiP2DcWEHrBVipC0Xpg+NasLm01lW0b0Rmp8tYz1LePliutomSPLCe+wU6kaNCxRQExLIJEB/D+HdGzuktnRKZAmf5mgCdvEapi4GOctvRW+Ws2d6g+U2B/JIxQSCdocN/tb5KGPJH6yHPPnDDEUjOW5pSOYWXaCp0ZIobygl9R+MP17Bhao4CDsTDnofELGM6RWy6alZH+MpxyuNAA3+1KhQ/ZfL0yzFb9C7ohy7qOutGLjx0hZJCb0cQeBtxMJHJHWUqT3tYMIa3z2cNTlNkmnMGgNT8Iq/KQQjdPi/jjtjk9wepZPoRkSC0RUzvQZ1nQtX9yXpXyjd6LWM2pGjXs1HrmF4UH7AI1z8caorsFRFms8RK82Vo9OWmqQp0ONaawB+SXQkFqt6eKhb0LH8q1RTFFdzLRdsnOYpqfPs0ZjzP+k+K5q/780lYqBFcLlS/GB7cHjNj66HbF0nVZJA3cvuD4QosYRrpSI58qGl1Hycv
 WGRMgrzk
 HtPdzM7QA5albKf75pHXa9Sq3t824gWywROho402KicN8lObXeJWkZkfmUHuTH+V4b7Zpqs2idT9pMD72/mfOCx3y2RLFCwKI6Ds8b8rB5JL8Eh8CrzAvp+gfLq2CwH4K6QrlUC1MFwe1wQT4tNjHnjamT7f7J4rY0phLbvXx6qzcRCTLwPz5VyTyIAilR63nggLyx55otmuT+mcgIsWAA7EAOO36zCziGzA1Gftw5HbxuKYRl1zvWfZcuO/ttDecRriV1kTtZfJD/dZ+vmil2URfmiPFX8GVcIsJTNlUA76xP78ExzoqfLfjaoyejBR32n2B8V+X+z5PtUp7lqczOir4emJayEIDUsdF8qoSmnI7Vt/ZdbGId7svBDTXTxCIaae2exKZKTlwDzfKUOGsDZ3XOoRn9MFsHmT1NHBajZuj5iKiB3Yj6o9Xd4fEqcMJBjZ99mIIruTK/o8oQbRBVKzveVkfE6/ljLyQcMnWXTAUGkXk/046vKKn9BzxVS+wbn1NXR11gfvQ32N384dHHO+XGHeMuPOq4fxTD6juaVq+OCewvOOc9Di94YjXpqgXJALqqDkwvauwBUg2i95Eq43x6FeiJTh3bMMIag0n49XW5st361o9jwDWIQ7PMzxI81urBt5smLfcdiBjzmCwcjtoq9vgT9VAkj7jOe137riewZ6vOO6RdoUdFe4gKicQUHb5MOanScrjMLtA2NIf/vCnXd7E7iUgvzw1vKcTlvw7a54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_empty_sheaf() allocates sheafs from SLAB_KMALLOC caches using
__GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
allocation tags empty before freeing, which results in a warning when
CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
tags for such allocations as empty.

Reported-by: David Wang <00107082@163.com>
Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.com/
Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/slab.h |  4 ++--
 mm/slub.c | 23 +++++++++++++++--------
 2 files changed, 17 insertions(+), 10 deletions(-)

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
index 862642c165ed..5c76e55eee7d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2041,18 +2041,18 @@ static inline void dec_slabs_node(struct kmem_cache *s, int node,
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
 
-static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
+static inline void mark_objexts_empty(const void *obj)
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
+static inline void mark_objexts_empty(const void *obj) {}
 static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 			struct slabobj_ext *vec, unsigned int objects) {}
@@ -2312,6 +2312,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 
 #else /* CONFIG_SLAB_OBJ_EXT */
 
+static inline void mark_objexts_empty(const void *obj)
+{
+}
+
 static inline void init_slab_obj_exts(struct slab *slab)
 {
 }
@@ -2783,6 +2787,9 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
+	if (s->flags & SLAB_KMALLOC)
+		mark_objexts_empty(sheaf);
+
 	kfree(sheaf);
 
 	stat(s, SHEAF_FREE);

base-commit: 7dff99b354601dd01829e1511711846e04340a69
-- 
2.53.0.414.gf7e9f6c205-goog


