Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BFDEF5862
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7186B0088; Tue, 24 Feb 2026 11:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777B86B008A; Tue, 24 Feb 2026 11:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687EC6B008C; Tue, 24 Feb 2026 11:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B766B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:52:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 043C5C0A39
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:52:55 +0000 (UTC)
X-FDA: 84479944752.24.CCB0A83
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F8A340011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:52:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Fzil1/5x";
	spf=pass (imf11.hostedemail.com: domain of 3ZNedaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3ZNedaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RMuxXmIqP2+dssDx1Vj46Iwohxm9R1VZEsldkCoK/jY=;
	b=HhAPDIiHsDhKxHQpVLZ582j8/iJqjlTxpko1Zjd/TrjfuP8jrkc/x+8pYMY7UqpkPZ0+uT
	ceUnUl0ylrsMu6aTZFAWeMZiMXo0PYROAyaObh/YEC0c1ObuWnHEWAxrRKAjvOA2SKrJpA
	MaGei6U6wgNPx/pSYJsT3CA1U8eg16o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Fzil1/5x";
	spf=pass (imf11.hostedemail.com: domain of 3ZNedaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3ZNedaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771951974; a=rsa-sha256;
	cv=none;
	b=LqqcWCbVhsIWvDyieyhV7X+Kl0xdMTdUxP8EYy07caS0xbPbnF8LQjBYrEp+xFQnL6E5Bu
	O7XCMasmtQn5yLS9pC8WNSzKGF7ch1qxHy/l8CdF4cKviWAl1ZPvokeIV2rUtLa8f/jWMI
	KpMSKzD4ruqo1zWYKTamsROAlu6s/dI=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12711967e0eso7989107c88.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771951973; x=1772556773; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RMuxXmIqP2+dssDx1Vj46Iwohxm9R1VZEsldkCoK/jY=;
        b=Fzil1/5x6S+z3F4Xrdfb86UBXUmlUCbEhSOpyRs0YQMP3ebp2JXOlLm59y+XLwGqGH
         KzGc6nPsUJYQv+HJwy35ew9g/faaIxaF1Q/kAX47NIE4D2Mm8t7+KwUsP5RjD5cAzXFJ
         eTtbe1QPMFDTrxI4UsdCocvpBsaiiW1uVu3Z02NK9EyxVq9vzrg/bfYlhN1WPJZ8aDKC
         7ricB0MEO6ksVqh47ui0L3eZZzv8CvTR6Wqwmf3rMEcOP/cEjwgRxeyRsqvgedIvlE8o
         +1xkYAaNKvcdhK427gVRIg8+4eSdqG4MRfYPnpY6jcpL7w4WRC6aXmjmVUMVzg2ye8xm
         Xphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771951973; x=1772556773;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RMuxXmIqP2+dssDx1Vj46Iwohxm9R1VZEsldkCoK/jY=;
        b=qJaMeE/jQMfrdE7ZdiNPc7LY5Pfi8esqLu+OQo7JNoizPQlS/y1jyaBaD2diKHMCCL
         15UFsZ5DrESdFJ8u9ateSIyzb6iFv1AFkFkCn5JWh4VMZJ1X9GpgnA0o2slLP7DzKniB
         GpH9/qpUyk0PggYv++MDbP9ep0rB0zX8oYTR/7aS+zXuWHmj+jHMWH1IP2VZTafiVlGS
         qbDdAUWbCQakx7K+8GYsKQMOivKLy50K+mEvkhbFJ1+cGwRWZu99/8hhM4NYhLsBxP+N
         qH1HMxEneOiAX/pS/eL1Y8D6/9ucrWMYCzAyVYZ+hWuiwqH8nXVd692vuOWaxQk85Q8t
         +kvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLictaxKeiRGbuFxuA4swBdFwX45kamfSWxsf/T/KPNweI2G0F6P+IWrP3cvHQYWIzb5Gi/51/qA==@kvack.org
X-Gm-Message-State: AOJu0YyQX7gUt3pyReXiGpQHUgboKkuPv5rQx2IyI9MC1NTpO8TzgkLw
	lFdCn1fSViehuBmXCUtHP/gwBi267KOTv6HSu7j8QDda/ckvdzfqzJ8UCB0O+d+k/NHk7zPEscb
	wxYOMZg==
X-Received: from dlbcy2.prod.google.com ([2002:a05:7022:b82:b0:124:7188:93da])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6291:b0:126:fddf:3d86
 with SMTP id a92af1059eb24-1276ad511e1mr5280312c88.39.1771951972810; Tue, 24
 Feb 2026 08:52:52 -0800 (PST)
Date: Tue, 24 Feb 2026 08:52:50 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224165250.1322946-1-surenb@google.com>
Subject: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allocated with __GFP_NO_OBJ_EXT
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, 00107082@163.com, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F8A340011
X-Stat-Signature: 4c155gz95btwpnjfziwzg8i5gjmkd679
X-Rspam-User: 
X-HE-Tag: 1771951974-191240
X-HE-Meta: U2FsdGVkX1/h7XxVwXXcoF0kSu2gA1c3dNCaeiHPwi7ZqeAxuH5N5v/H7lHzFbBH52vCy0k4d9ossKDvbE64PML1WhtrYCwE18rqckPDhyJT8Wb+OFg0dZAcVevogrptzHde3lQJjsPvHnnd4luCtp/j5YhyoNXKTjlylTkN61vqrF29GsiTfZd9HlRw+XvNG6pgDeW5iSTKPaPtrW1zueS2TZgP+SA5jVnv7TSL1bkQLucn5wWY2nc8SFULQ5hWvxl1KCWSJCiEfeFT0s0ZsvjXDh0mIz8gND14xGcWXj5dT+xu7+ZDRNKBZTWlT6ra/PdxeK7btOyzkb7UVdDCzvV0IwFda4Z5hVhDl7RTbljRw0dhD2vgrDldr5Oy17AiF1Srt1wXaYec5Rt1XKgxo0iUPfaPGX37xHVg1f6ZWMeF8HOtjG1RDhTJLr+FVcilGEAe01FRqNvzOiBXP5t8ilRD7SIDKV8yPKtkiNuYqsC144dDPxRQm/h6xajwboF/pzSkKNfj/4L49ONBQv32DSdsSazY+L2t4XUPMaAFNA70fxOVTwBLCQs4T7j2bx5sYM1uK7LNsJOXSn6q64Kou4c9BUxYB6h6wqaqC+dFXYd/BqURSv2O0gdKa01YRE4bcGIrsGd14lHGCm40xD/38pOBivLTVQBBxT7zJFO4yXT04xAnEbk/F+BFw5t6qTMZ6gQsqJ+Q8WOBLnBp4ITFbDOR6h+IhdGuQIiAK+/UmXXQkxKebnU5ezXUntVlZSV9FlPHZ9QYtStd3S14qaUuwlXcYOPLfRkuG6IsUcSCxHKKwzyDD+rNYNh7VklrsnRWRKzodn74Wn5uFcu0IBYy7Q1VIzQiQV7QMMOZarHML7J87qD4oJYkDnOhGyfYgpoYzG3jV0MUpA/982RPgVC4vVEyGWcdIYIhPmonzYQM2hSRCpcImnl2nRdKpe8txsqpLYSdZrVyZ++jIyc+j7x
 VUlv4kLL
 v8EkrVqvwtV7WVbMXYMh/RHVYXLGqAA96VyzPalhDRlAZ8hEw5z+oIOBcPaDdymZfPr/v/rTXADzgftu81eSnyR3RRpaHVllNoEmBGTa4OPc8vByQKcReXJmjArrGzXsvT7G/A/NDfCwjp7cxbW9YZhU+Bu+53CSFomlAqg81j1worXYj0tj1GzP875SRivqNGBMbU1HPFWkrhxSQqZ+xVDAc2bxCn33Qub566o693zTWX6eE+TaK0RWeD+eTU18WYt7j62YTS+3dlMcR+0nkUDA96H8qbVgh+6neU+onDZa0HNj7tBP2vYBowF1RRkRuO24ZrrIscfqYyt22G8+2EAbOo9Fq+KIUUkgw1NXogTJ/0FQzD+Qnix5OE4h3lw2PUq1ZLhLlODft7CRldgewFyHRGrP+53Myfx8uRGDRr2bftBqTyx7sNHdyv8ZwJQScl/STXGp0E46dHo3E5vJ4j5AmavnAk0dtHlXB8T3r9szSZKqBCh67vwV3g/pZhiNj7zbZPW8DRLpDFsXxW9v/AfqdH5BAr3NR0cX74EnEljipP2qgI5R1X2K65ZTpYYrPevsPx1j951A2fkzgC6fRdbRmMXwcFe3EKFQlplIMeO/8/Cq9sHCtbZ2Af5mm6NSPD3EWN7FvGSVj8vHeiaPqOTrOlsxAdSRRfhGe6snB5b3fJzWbLql0liEWjb0aveCOBnjTkO4clhdlsSOukxUNYixW+66stKYaDDtEdrzdb/zi/7Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 mm/slub.c | 17 ++++++++++-------
 2 files changed, 12 insertions(+), 9 deletions(-)

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
index 862642c165ed..3ddbe654cd56 100644
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
@@ -2783,6 +2783,9 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
+	if (s->flags & SLAB_KMALLOC)
+		mark_objexts_empty(sheaf);
+
 	kfree(sheaf);
 
 	stat(s, SHEAF_FREE);

base-commit: 7dff99b354601dd01829e1511711846e04340a69
-- 
2.53.0.371.g1d285c8824-goog


