Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91E0CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593E26B00A3; Fri, 29 May 2026 16:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543936B00A5; Fri, 29 May 2026 16:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432A66B00A6; Fri, 29 May 2026 16:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30E486B00A3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:24:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB9B514027A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:51 +0000 (UTC)
X-FDA: 84821585982.05.7DFA7C1
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id E062980013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sj5FxLc1;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evn50r5ng9H9NfR/F7shpk5eakICeNR87P7QydzAfto=;
	b=7cQku9O7WDrXWaM7/iSeqnlAmLXO+kbYeBSQKFhDm0JsZatO/3LTovLFJ/OAOYc3lTFJK6
	N2Cfv+N9IB2uiG6DXIQFcLRvL+lTdUn3q726UM/zAFCb9wsMMoLJi+NkHM8xFfyLhNLqtW
	QwUKhwGZWRbkSc75gt7+YBDynGMTqpk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sj5FxLc1;
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780086290; a=rsa-sha256;
	cv=none;
	b=5JcrQwjS/XswwKliZi851R864fra4WzQEebtK1kqESQCgQbvFs3vVQgr3DaCUjoj6LllB0
	H1EH2bUZg0IUmDlw6Ft1Det+tGWmNwaApjN599VGzL9rAkFa7CLEm5NUspt5dv9ai13IOA
	dhuZ6boMmqFkam8OE23/T5/SS5M+3/4=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf2e8ccca1so4550885ad.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086289; x=1780691089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evn50r5ng9H9NfR/F7shpk5eakICeNR87P7QydzAfto=;
        b=Sj5FxLc1ntKGg3L5ZUcJDZh2HRfU5Bi6n09NslbUuDcK5D9p6ZHRT6RpO817k2wgQ4
         q4omTfI/InSwePZfbjliB21XgwoHBWo3e8C+x7phtz9hq0+jtiJzMBF47Oax1oOppzt5
         4aLQG0rWieZmmfc/zGJNDu3PS0zjiKLqRa/LxSZ09s15MovtTU4WjfblLCJvU9hUhfDq
         DUdPF8CTMqBnN/Oh9IdTIBeyYPxIxXPzA3nHKxeqJKntBF+epIkNZNZqE5zvZu/EjUuc
         tT8JSAJ4iwZ2v2jA/ki3J98BkTQ58/pO+Tb1NOdUFafHTyVfPKLvnxnJIenwYEZcB+6u
         thCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086289; x=1780691089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=evn50r5ng9H9NfR/F7shpk5eakICeNR87P7QydzAfto=;
        b=GyBrW0PCK5xdGOQf6LDGnlN7rihxjoCpwsG9btiv6Mjjb3UUv/IkoDjHmSBKYzwedK
         PovjhP8LH2EnmR4xfObd25l0HAFaNBOC+WOh03fvtGmG59lS3izYX8IHNM5zltw3sg2w
         zxSBROAatleGSxy5YU/iPuS3IAD1Ms/AP89/r4zzw354+EYmGefB6RKiImtCoJ/eXK6U
         P2I10fl1IHZrrUwdCK0BKD4V7aZsLvPSh0Zh7oHxoGY5JnexvsIbiOKGw8wneqWAz29K
         WnwYOY7YcJUQ1+ICLJwOVnIl7LddIpaoMiGdFUWZI7LSyBbLsOWr47rdGT0cf9O/O0qq
         z1QQ==
X-Forwarded-Encrypted: i=1; AFNElJ+H6G5uVLLcVtRhYsKfulgGgWbUNJYwPYax0ieYRZqRQ/Q0GjhFvh5hO32EUmLOK9kpfzZ8vDOmQA==@kvack.org
X-Gm-Message-State: AOJu0YwdCxqHq56VZFDzAIL+/ynZPLpsh1bPJ9irztSZfjQtlhSpEn+Y
	NQrUbIs8Hy605qgLquLU6o+q9BdcahmxpgBGZGffZQTibjc6cxADuZSJ
X-Gm-Gg: Acq92OEElZCTNbPkUxITyYlWoYue1gReCIE8zpgblp6Kb/58i8f/KWonv4jL1bM1kQa
	E9YVhZAj/c/AVByDuR7/o6VIBi65O37J8V80KFM/mD/EChCrHp5Auowu8pohJ2nB4zrlXP3ml9u
	u4xAy0HkBcm4jZXIzV9jmg2LXESvNjMWYBBky9jkf4kjwdAMRGkmi/gErbjD71mKBOvz4nMj0vS
	YoZgYxsrYMaabhQiaj9RW28S0xlcz6TrDKlYJVbc+mwJRCGceKQXc/MVcBhPRgJhZsVNKhSFBCz
	sROcrV3la7Ol6jDq4cup97LGb4ADMsiwobFrlwLI5llK8ZuXN+0PwbzEqpcVQ9CPr88uRoylXB7
	qx/vu1tTsVoUgVQHuCzy7PxHYxFece8LGXsNMkZoQy3IVsNgqv4fvyUCDl8/vtzl6lqsEE1Y6pq
	1rOoSygH57VCZcAM6en4nQO1FSF1hLG1VjPqD0UU5RMB0SfoL1HLx3ZzdxL3Sh0qWwnVndKS3+C
	eTO2EguXp1qtOfnNmTr/WQAZLHQNnFmM5R603gXOROQcle4/TeDLfjBnvFY0fv3Y/e6lVWD
X-Received: by 2002:a17:902:f78b:b0:2bf:9760:b963 with SMTP id d9443c01a7336-2bf9760bc96mr8152055ad.26.1780086288619;
        Fri, 29 May 2026 13:24:48 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf23c4dd4csm28681335ad.78.2026.05.29.13.24.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 13:24:47 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	david@kernel.org,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	peterz@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH bpf-next 2/4] slub: Pass kmem_cache to alloc_slab_page()
Date: Fri, 29 May 2026 13:24:35 -0700
Message-ID: <20260529202438.16408-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
References: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ycmceq4ahm1ikpdyx144hfkm6k7349xe
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E062980013
X-HE-Tag: 1780086289-560852
X-HE-Meta: U2FsdGVkX1/wjQLplrRXxfuRRB79e3RnvTAz5xLSPNB/9czZDROS8hmylyuwMow+Zm6KI8h50fJT4A3WelbmBsj2OG5hRA87BaPDXU1aaQUCjjZqerirLey1pQ+L6cvJn4yIYy5CXgcqxBaISjYHEqv1bjfWtYMbTVGlVxGKYYsbwiditRttVA2wQwO96SQKZER/y+y4Hm2tVLy4fZPp0IR7PMwC2Bp/r1R4kymXum4dXBr4aJYxaFhPV0dvjD1xD81iosjy/47lZcdLQ/lz146qWK5l8i5xHs/l9inSIReMePwHYvmiW+RD0+nEXWj6NlL7KoYQ1UB8wmxNpre2kdomQZ6HZHVaQN2mB6xx41vnCIO98lYZLYmhlNLUS/+zEBgy96e/idVn/p62CgkY0SwD6Clht2mFOlFCX/t3dmvC7y8Qz+UkSjlMz+KHV3PHxLz5aLBv77bkK84cX8zSxTwpDWB8bghSdyn45VDo6L7auzCL/mKTlcsj8/pQUPzDY5b5eGzvZyNAV+zgOl+KXHrStkd1AAcfII6cJViXqmG/1Y6Ll+zNGuvq67mDaownj/moy7O0dZP9UmIbXlyTd7btp/BUb6ba/uk2UK0k9sx1koKWnB+CztZ9mTm1GdfsbgNTVhQXcGT/NeX776VPikmk8w24XG86eu3B/sVBXdYWCFPkNEvnrOEs4GX77HVYIx98LubyQsb+zPaewoczTUroq0V+HCWiwBpA7P68jKQQnyovueV4MpDcaZKNSEV0j/gseOP9wJ1jONn2v0RwCKgQOciox8dmC6WwjJ6/KfpoDh0enfF/M+xe+TIzKm52tIVrmPXiF4TlbGeD3pDQ07LAR39r9Tm0i2sSM8x2iebtA3twmAOOsvvEftPOy/8eJoUg8jQ1CFIbjTl3UbUQRDhlYRoS5IzrOZyv1DoxpoD+alXg4JVCEPzsIVKE+g7Vy7maW+TsFvR3CXUvbCC
 +WRi+QHP
 XwxoCcPkaMW6VBrC6BQZYObcsyRyCdxz2+riyqVyKJDaFCPkoVuFFfhK9x0jxeoZDFcXwek6ZrnDlO7kZIY1TcJydMa3lGEk0dAE8SUSSvr7wxtMmHUDQXvjCKiz+JOsu1Ll9VwJ8TAo7bGXHf6ze9c+NRe/uRyxnnNhUn924RXUeiwsLIX71TBsk1r/VOn7qiuO+69Xf2iLJBqQf7Uldq2Qr7irgBUIKUtv7cRfqwOEALFhVNmv+Tl4XamgGMEAVwO/DcV8nprs63RfdcLyMtK1viO53kHdAv+jZKqDIpuRF1aOCk5Hl+7K5e44DFUjOYkp2Kn1p3q8yOuEoJJ7Y+yLgYcFK+TOCggLXDEEUz2zyAnxpd1qbOezC1+eCg6Rmv02AcG0762mxbBNLHb9YGrGHpxQNYe2j804+0ohkFrAciiIcfq/KfZUL9/eL/vbyj4BLfgSqlmrswCpwBKYNhpMg46jKcljZb/Lp52wf/UzaLrL2BVlr9WXmkDTbil+4jv+bO9Ske007CSY4F6lDXJoFWiSOwaox6kL+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Add a struct kmem_cache *s parameter to alloc_slab_page() and update
the two call sites in allocate_slab(). No functional change.

This is a preparatory step for the upcoming SLAB_BPF_ARENA support,
where alloc_slab_page() needs to consult cache-specific state to route
arena caches through bpf_arena_alloc_slab_page() instead of the page
allocator.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 601986aaebdf..1daa89105e04 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3261,7 +3261,8 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 /*
  * Slab allocation and freeing
  */
-static inline struct slab *alloc_slab_page(gfp_t flags, int node,
+static inline struct slab *alloc_slab_page(struct kmem_cache *s, gfp_t flags,
+					   int node,
 					   struct kmem_cache_order_objects oo,
 					   bool allow_spin)
 {
@@ -3464,7 +3465,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	 * __GFP_RECLAIM could be cleared on the first allocation attempt,
 	 * so pass allow_spin flag directly.
 	 */
-	slab = alloc_slab_page(alloc_gfp, node, oo, allow_spin);
+	slab = alloc_slab_page(s, alloc_gfp, node, oo, allow_spin);
 	if (unlikely(!slab)) {
 		oo = s->min;
 		alloc_gfp = flags;
@@ -3472,7 +3473,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 		 * Allocation may have failed due to fragmentation.
 		 * Try a lower order alloc if possible
 		 */
-		slab = alloc_slab_page(alloc_gfp, node, oo, allow_spin);
+		slab = alloc_slab_page(s, alloc_gfp, node, oo, allow_spin);
 		if (unlikely(!slab))
 			return NULL;
 		stat(s, ORDER_FALLBACK);
-- 
2.53.0-Meta


