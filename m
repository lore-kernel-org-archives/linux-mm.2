Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC95606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 09:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hNaqP8RF
Received: by kanga.kvack.org (Postfix)
	id 867236B033E; Fri, 23 Oct 2026 05:44:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83ED96B0341; Fri, 23 Oct 2026 05:44:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7562D6B0343; Fri, 23 Oct 2026 05:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4307E6B033E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:44:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E272AA0363
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:44:39 +0000 (UTC)
X-FDA: 85353406278.06.9F41B9D
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35D2E1C0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:44:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hNaqP8RF;
	spf=pass (imf18.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792748678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6eHpkzruNMWM7nEd9yLSMJY9dIBghjETsUAxANFqYe8=;
	b=E3YNnmb0LNBKW4sukHAGZOBEL9fu9j01IB9v7DCqUAFcbBX1QHY/oiFMmDZJ2JcjGKiVhk
	ZqEY0uAqoCe/6O2whNkl3AmvTZEXI+twU8vQfPpdNAF13ieOcd9Aenl0USkLDS2KCexdgb
	sn0vzl9EBLQdk6GN9PdjY65ugfUfgDg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hNaqP8RF;
	spf=pass (imf18.hostedemail.com: domain of wangqing7171@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792748678;
	b=V9LEEAucHy4PauM5OKE4Fp7SpdeqmLWMvTtBQsrZt3pPTEbB1EOOci5sgGAh7N9KR+lLxA
	tx7YD1duiPjFT1Yytrbx18ztDNnPSns3s1m0ZYMvGcnUN6pKPYnZvUrYy7FzWZ/umuNhJY
	EnSUbKGjM6swm2cNdwGOnFtCINLVAdc=
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2e7c8213b09so1371085ad.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792748677; x=1793353477; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6eHpkzruNMWM7nEd9yLSMJY9dIBghjETsUAxANFqYe8=;
        b=hNaqP8RFtIQ8p/IgA83WePQJYkMG5+YJwYZzjcZK+8rTC1WXNpLus2yRYJtBBVsMof
         Ngf6UCbVpeJ0iDg7CeRdyn2mEHlIWc3xVpLAiwDCH6PjDId5340DkGLGsIb95axXNFZg
         7o4RbVPsJoG32zv8KgBABhDKRyzOhR6y168Bg4gGC8GDPZcsDpvgM4cj921IfZin7lqT
         KRmc5DrXzjzLZoRT9BcYLDvbokAABqm/7h3BVIPD5tc4v6cQqbAoec1MoGWCvVo35Kb3
         b7fpgQ/9AOftFuW6ATrNFxWHgZ75oX5I2+4v3PCgU/tyTIvOl00Wl8kJ/WcKaI1UEom6
         aqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792748677; x=1793353477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6eHpkzruNMWM7nEd9yLSMJY9dIBghjETsUAxANFqYe8=;
        b=wuWMFQVRHMCo4jFQ4pZx3rghv1FCPOWlQbz9kBzgsSt9QF+joWUNmNYq/XZEw8cvIs
         /KWBu2VXX5W8SMzjq4kH+WfyNHTDeAECEPW2zESN92Mymav2//jtmbPh63EVO9lY/XPK
         /sI5Dq3aoc3d3h0XgcFp01t39RoP0bWQ3FTzbpqpTDaKjSHz9LHl6PuyK2hhq/n1so9F
         /tZQnMhUWQ0kX5nZwAxgH2CggY16d9RRawPBeESJscQPFE+uIba8afOFwnxR26e+ilBj
         QHf9LljTR3ZqK0uywAewaZrk+OqT8KlobQTMCTEgpXY+dd697kiPevZHhPWzEWAM77WD
         C2rg==
X-Gm-Message-State: AFq9FYI2dRey22BBfOlMNSenlwiF3haeaLsaEnYHMnULCbAWsL//MLWS
	8WzZFg2QsCTFLU1CjRjiAYW3Ap9Wb0UFCN6hAbugE+DZrkPgKLLAmsbM
X-Gm-Gg: AYBFou3dQ3+P9Fs0bkznZyhJoFql14PJ0i17AJFV9drMrraxJK1j1v+LSvke2CSG+CM
	gcn7WaMITxzH4GhPVdXf5yjMSW+mLUj959bpESglEQowEoaMfq994mywbxGHchLW+sIXsPs/7GY
	4FFtOArNObhsZnlQMylwmFKnTYwEJvO5ISTFxFQ+zMupK7S2T5JF3cZlLDpvIZJp98uQT53ddwU
	llEM3oEmJZ8NtyLwn8kksCqc0J0KzuEifj2ElsXTLsp0nJ8AqGUmw7Xs8Xdji0fBsqgC+mWrNUX
	/keItwbIAteA5ANJldCUDLBImAGkgDUDw67Zbuh/6I5U7A5FccMAN13gsme7TngpvF0LP2UELSf
	rX3WeFBioemf8LIp+AlkK44Ok/kVM/I3ufW6GbOeZnwGld4LnKy4gvLsVgMYriclP42KtQD8l6p
	SSGJ0kYV+fuSdlyygqIuHnK3QMvdLdMIY2xqRBLtyMHjs/9hzDo87+Yrl085Td72jj5T6yhsMDE
	XBjXwDOXGndeb2UfgAvEPme1H9KguNc9g4A6t1R5IR2xzwkZkw/uVOfNR4r2jn8GFkO2t8EKCvt
	UwtCaPg=
X-Received: by 2002:a17:902:db02:b0:2d9:464f:d45f with SMTP id d9443c01a7336-2ea7c169dfcmr18345425ad.5.1792748676866;
        Fri, 23 Oct 2026 02:44:36 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.209])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea7af680a9sm8381185ad.5.2026.10.23.02.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 02:44:35 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qing Wang <wangqing7171@gmail.com>
Subject: [PATCH] mm/slab: only require the requested size when refilling prefilled sheaves
Date: Fri, 23 Oct 2026 17:44:01 +0800
Message-Id: <20261023094401.2042862-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35D2E1C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4bxtjcufsq3jhs55m75ws1sems4xaib4
X-HE-Tag: 1792748678-777934
X-HE-Meta: U2FsdGVkX1/5yJPEzyE6QqlJbPxqPK5KZJwcmhMgKipHbD9prh0eKYcwZ+0aaGHyj8Okn9BVcTXFcF9AkrFd7DyZt5yuAkmvmTYmoXXG2nXbGDGi7yq+u1DpYX3e9LjdyJ0MaBvOj8TxVd+PkBaxU4sdjkQR/Fw1hCq2zs/2H4o9bi01oJfXXtdVScQSEB/Dxl3TZNk2wAXnnV8aiGLt4B2v4xS1Pm21ZhEaIfrC+M7pSp62WinV+Zf3JBC7LovNpUaLdBnVKrc6RMLOv1MXYSJw2s47wC9I0OWPEZI42XISnONwjpxszaLo5n8fFAi8LxatCMNFAz9tCHC2Xfr9knczbK+ssJG74ILNI9qT1je4KZ7exSyulZ1YdPcVyK0mhrDZPHtzGwujxwAQKLh3L7CQuBimlKdC7SkIbBa1QZFu13oEVokgtVFXcA9guU/3Q7UOE3lpM6YewmGL13O9yE+rtSJYBCnphk+n8SuixqhSNPoQGHiUGiwukrq2Mws9KpLi0SWKGOxz7SdyFIfjPN4AsJO622u3xxqGjPFtOgvKjrsW3VAY0uNU7OVsqpdvyq9FlPtCXNQaqNHEGN8pvbkIA/T3Ms/tBkF0C9Q+OyDULkcL4/pboaOC3VWAGB9hITK8Rvq217TkCLI4pJpNoWGdHAsvSkGREVARE/QyUQrnzznRGtInJcgzWoa5V9WhvDpjFzcUV/b9pNvjLjq7gKsPZEtcWe3Jy3rT55k13KdWE3zpZlS19kmur05YCT0kZIKIVZsB+EpTh2aoigYoLVpHzxIPYnx7on1hf96Dc0xI2E3ezluq0QSuD3AhD09jnffjxrsPDpeczOePaGoXTx8bkEjOc9+C3dy+o3MDqkOlEq/O67GPgaA6W6LKBiBq/GBgLYnqlr8YAwcym+7NxduCARzAdmiYRD5pyOD4U3ruWLqeqRqtUCtxsQKDEMQfYkybMlfP74KkCoNnXm4
 0B3FZ4mn
 2AqgpbVAPQPHFXf1Anmlq9zvwRk9CPMUCR/Ip/ESR4biECY0ikTI/O9tV9728FBZ8QDn9KCjYPhlXiPKpWd7ASu/5qAwstwrRHOb5BHyq6bykucYWC85aXp4twSMw41KMkRS+wLrc/N6F4/xPgFbp7CJkzxZ7T9bbsWnFwAOX9vJILhehlEuHCoBZ4kuSwQ0bi/4WeNFwnf+2B3EIbXQbr251gcb3ePSQ5tlp4NiHUVYWYS2RjQ5ogiIGBaZYqtE05L32URQKM34hODp+Dv5Ea6dzNL3UMlMkW3FPGKNHA27H0FSOc9O3FoDQB+fiq4hPycANA2JS0LfkP+eaAYKCvTXTy5NpyF7d9SVsG2NQq3dsCkh4UfWmlSR8A9/OWEwv4ZFjJ1/eWBZjxks7EoUpiA6mIxCJ5Tn5zqM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kmem_cache_prefill_sheaf() and kmem_cache_refill_sheaf() only guarantee
@size objects, but for standard capacity sheaves
__prefill_sheaf_pfmemalloc() uses refill_sheaf(), which actually fills
the sheaf up to s->sheaf_capacity. The call thus fails with -ENOMEM
whenever the sheaf cannot be filled completely, even when @size objects
were already obtained. This leads to needless flushing of the partially
filled sheaf in kmem_cache_prefill_sheaf(), and may use pfmemalloc
reserves to fill the sheaf beyond what was requested.

Pass the @size from kmem_cache_prefill_sheaf() and
kmem_cache_refill_sheaf() down to __prefill_sheaf_pfmemalloc(), and have
it use the newly added refill_sheaf_min(), which returns success once
the sheaf holds @min_size objects while still trying to fill it up to
s->sheaf_capacity.

refill_sheaf() remains the full-capacity variant for
__pcs_replace_empty_main() and kmem_cache_return_sheaf(), because sheaves
on the barn's full list must be full.

Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
 mm/slub.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 544cff39762c..4f92b3e30d84 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2873,28 +2873,39 @@ static unsigned int
 refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	       unsigned int max);
 
-static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
-			 gfp_t gfp)
+/*
+ * Refill a sheaf with at least min_size objects, up to the sheaf's capacity.
+ * Returns 0 on success, -ENOMEM if the sheaf could not be filled to min_size.
+ */
+static int refill_sheaf_min(struct kmem_cache *s, struct slab_sheaf *sheaf,
+			    gfp_t gfp, unsigned int min_size)
 {
-	int to_fill = s->sheaf_capacity - sheaf->size;
+	int min_fill = min_size - sheaf->size;
+	int max_fill = s->sheaf_capacity - sheaf->size;
 	int filled;
 
-	if (!to_fill)
+	if (!min_fill)
 		return 0;
 
-	filled = refill_objects(s, &sheaf->objects[sheaf->size], gfp, to_fill,
-				to_fill);
+	filled = refill_objects(s, &sheaf->objects[sheaf->size], gfp, min_fill,
+				max_fill);
 
 	sheaf->size += filled;
 
 	stat_add(s, SHEAF_REFILL, filled);
 
-	if (filled < to_fill)
+	if (filled < min_fill)
 		return -ENOMEM;
 
 	return 0;
 }
 
+static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
+			 gfp_t gfp)
+{
+	return refill_sheaf_min(s, sheaf, gfp, s->sheaf_capacity);
+}
+
 /*
  * Maximum number of objects freed during a single flush of main pcs sheaf.
  * Translates directly to an on-stack array size.
@@ -5074,7 +5085,8 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
-				      struct slab_sheaf *sheaf, gfp_t gfp)
+				      struct slab_sheaf *sheaf, gfp_t gfp,
+				      unsigned int size)
 {
 	gfp_t gfp_nomemalloc;
 	int ret;
@@ -5083,7 +5095,7 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 	if (gfp_pfmemalloc_allowed(gfp))
 		gfp_nomemalloc |= __GFP_NOWARN;
 
-	ret = refill_sheaf(s, sheaf, gfp_nomemalloc);
+	ret = refill_sheaf_min(s, sheaf, gfp_nomemalloc, size);
 
 	if (likely(!ret || !gfp_pfmemalloc_allowed(gfp)))
 		return ret;
@@ -5092,7 +5104,7 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 	 * if we are allowed to, refill sheaf with pfmemalloc but then remember
 	 * it for when it's returned
 	 */
-	ret = refill_sheaf(s, sheaf, gfp);
+	ret = refill_sheaf_min(s, sheaf, gfp, size);
 	sheaf->pfmemalloc = true;
 
 	return ret;
@@ -5171,7 +5183,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		sheaf->pfmemalloc = false;
 
 		if (sheaf->size < size &&
-		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
+		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp, size)) {
 			sheaf_flush_unused(s, sheaf);
 			free_empty_sheaf(s, sheaf);
 			sheaf = NULL;
@@ -5267,7 +5279,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 	if (likely(sheaf->capacity >= size)) {
 		if (likely(sheaf->capacity == s->sheaf_capacity))
-			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
+			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp, size);
 
 		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
 					     &sheaf->objects[sheaf->size]))
-- 
2.34.1


