Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C5ECD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39116B008A; Fri, 29 May 2026 21:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D101A6B0092; Fri, 29 May 2026 21:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEC26B0093; Fri, 29 May 2026 21:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B08556B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:13:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16BA31C12F9
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:13:57 +0000 (UTC)
X-FDA: 84822314514.03.F10DEE1
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 336AB140009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:13:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O/j+Ecez";
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780103635; a=rsa-sha256;
	cv=none;
	b=SL2c/fw00mb4zkm5HlrgASeVbAhxHOc5s8Kt/nlDne4XT73mIHq3eJ/3XK9c5ckhLiAcT0
	Pph1LW3jmqqU/ip7gQ5MeCf/q2cO2HeP83pqm4SuRxKIZgrvx8dg05/CJY8z22jwdsbs+1
	9VrKfVJ6D8/Cy1fIOGoYcaomVZmZ5bU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O/j+Ecez";
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780103635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUCi6apnDaYquXe57OZzeZfrFZn6x9QqO0qDPXuYS0A=;
	b=67blyJI6px6b1J+breaSn5s9C+U2WJ48OmXiO+UKL7UZoaEKl+hmMDN1N3U8IFthEhSN29
	KaiWcF7NqBec9BsOGR6QAe4eUnl0528DxzG+dfYSSZh6lYR4HvS/Sh1mLU37jvzC1Ivap+
	hZFFcji+S2NGLqhohPyzPxd6rB/Bn7I=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36ba285e98bso1940881a91.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 18:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780103634; x=1780708434; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUCi6apnDaYquXe57OZzeZfrFZn6x9QqO0qDPXuYS0A=;
        b=O/j+EcezbY2J6u8FW9DysQAzJm0JqsvvZuH7PQMqQovds4LKfyhS1UEXD8VlK0/b9n
         kNtLG8fXXHsQ0A4bj6NakHVSQfSoszSfRH6gtMxfbAH5yIR7YPAOgXZ/DQIVR0PGzePW
         f7FpFeYUzhZb2CxoBjpOhHvhxpRxgXvteXW56cMw/kr8eISw1ryGs8WyfAAL3wN0monQ
         X/XmOKuIjuH7m8c07bZbboH9e9PfPpKv94HRD837nNPLbjZEJPhrz+BX/NdXUU4nr6Z7
         tbaxyDc8dP1RIfjE2s+d39JnqcXDw7rvgju04GV9/0At28oiR6YMB9ARiUB8bjSEVUuy
         QlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780103634; x=1780708434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rUCi6apnDaYquXe57OZzeZfrFZn6x9QqO0qDPXuYS0A=;
        b=dzyLlo3V2Fo9MxRofmEcMXNcjlaWXQUdBDJDeK/7jUoe5mroJlZJE/akEYJJ9yIfVO
         A6kDhngYNOoezGPxKgovwsk0Gjcd4qpm9rZpKRYVLM4Og9cZTdtgR9aivSZGd1/c+hkM
         HsmJaIphBVHcErfmIfKQjaqV5zxALpTKD/j1f/ZovkE3w7nSNnvI6vSlLzTAtnqjLuIO
         wW/KJIyP6rd2NMfeCJirAYXmVHuv8lqQotvT33+y9acRL6E89Gx+KobtX9RBR9NkUbqh
         b468ASKTKZE5Eoj5GbGHGEuRiLKkl5NyskZ3Xoq+FmFH9E7T2o3KWae4pCyITWumtAZO
         OAGw==
X-Forwarded-Encrypted: i=1; AFNElJ8Rh+4lJVdH6m0eXMiGRi5Y5F3EWeUOqMyqjrKl1JdqfyxqTMRK/fCtJzGTJpVwiwI+3uuCmOFPvQ==@kvack.org
X-Gm-Message-State: AOJu0YxIStBmlS9n6MbPC2jjvV3g9+1Ngc7asiFOmNJlauqVUfAG2q9l
	5gynGWuZKbd3A/cp4JJww/iX7WmPDJmOiyZ4/PB+HrUHfs6fLsqQpqGX
X-Gm-Gg: Acq92OHm0CSoPvXtMm1J1AZfZFIoX77zNdiyPMafk0zWbcLFHIS6iOTWaFt2zvx1pRK
	g6CYO0iAHOG1+sahJh5k3JOaYHOJ97Ookyrdml8862bP8SM9rENwwpRiMP3C0X38gGaCLXwuLWY
	rEwFDb4+n1Q4OdcZYI5Wx+4HnmEVuWDqLjiwwL+3kr0GE57/Mga+6dE1keIEAtvmhtLtGCysABv
	ML51vKgD/ywYEoBB/q+mKLUkATkNARuh1i1VK9wA3WOohfFoePvBGFF5WrbScnKQ8of8m266JT/
	dB5ibQOpLT9cgkXP5vzFvnPun+XMdD2q3PYz700ENmJ4jga1+25cR+Wu4x7Wpidrj0As8ELY+7i
	vflMBFWapZlm2sz9UR3oBqiIbgV5zZoYbKvWKXEjouE1JmsLNWis9t87oTYDDrAc/3fms+Y5VCF
	DmpDvruqZiwCkwUSVOcVaXDmsmxn3HShhc4bChNYiLmaLkIL9PvX69pEBynKR13UC9XXaAd/5pl
	xX/b4v0K1biHqlMKHWxgokLaLSHWlWZ+R/pbE42KwpKIRCNnkFzA6UGEyxVOdvVXzjnWicl
X-Received: by 2002:a17:902:f60d:b0:2b0:6a22:5165 with SMTP id d9443c01a7336-2bf36793657mr23140475ad.7.1780103633930;
        Fri, 29 May 2026 18:13:53 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf369c790esm10775925ad.56.2026.05.29.18.13.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 18:13:53 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 2/4] slub: Pass kmem_cache to alloc_slab_page()
Date: Fri, 29 May 2026 18:13:42 -0700
Message-ID: <20260530011345.99342-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 336AB140009
X-Rspamd-Server: rspam03
X-Stat-Signature: iyybuuxmtqak1pzbymqhtrodpm4rgjtk
X-HE-Tag: 1780103634-948436
X-HE-Meta: U2FsdGVkX19cdKUtNSZUtErIov7Vfl0DF4YxwTcVRCQj6eG5yrm9W0bwaKy7VFLRN7cky4iFSr56cbllZymbFMAg/AWTWbf0QYK47bgRyQr7YttMzLcnbQxCp2bU5rgg+QAgT37H6clRa51JQBKATY4CJhSxbBXp942LhXsV5P39tVxS+mWugCGc02LX/vH0dhRgR0Z/dFM3Bq6LgVHPI9eTmU2mt/7Qp4fp1ue6o1Hj8DsVI3XrqliS7dY39c9KqjYzjiE2NzSlOqLVDpZBMVsMuYThwcGy/40fIbbcd/mprSQAFOBivGI6fi9zxykqwAbGmsISUcn7j+7nO+bD2Qv0d0eF+Otc/mJ9jC2asIR6h4VmP4AbHSPmP+yg/tTCm6waJQ0pSdS/F+GR8uHkeVXPvJaYOgHkzA5JXRZdkeV9BxN7y+F+Awk1V9GJMCnK1BdJTLqOGP+dK97EyD3dLi4e81xN3BTLvRif71PX0XeZQ5iRwKU/ww9yIHskv1yXJWionNIUFrCOsQVZGr5brIWs8cfK6l/6j8jpScXnVGl5NlRGfUNr03wpdGXW4PDzxIcI/HUt/NDxq3RCIyeWR9EdLUgpSkrqGB0aDPOf4zi+qPE3pPsnFK2XwLYC3KKXnt3xPBSonVyV+O6KTGRGlPPUcviGAKEM1WlOy3BuSXqI8yacv4zBJ6P7/j1woPiny9vYh/ML7R5G17VZ3L9ouNmZAf+WemZUJA/NxbLlrD6u6bx95r0H71tCppj4YKt0nYxLaOOMS3meyCwsctsjDPnnAjSmRjnyzHumUuN1q2I7VXlhYfhDqTHfbhbMaPziudNJLzsxtfGkPMZzGotvKw4GGYQVMmG/CMqhDhEchAx2CXsNuXYaE+5h0O2ixx7+4ZWwTQnD1LTTZHOErrbOB+BqJhfIYqB3ShmmUDmN7yBaQWdv4jSBRPZqbTjOXhk60jYo/lEfJafqeJjC0pC
 l+C7vJCb
 w6Qban8XOxs7h/LYq2p6dYxRAe6OireW7mynMaSKbVWkIUCCmjEfu4xK60KrFgHe9fyrvG6S7xclB+0vWVFTnCJYKGAAS0lFeco+aqDmQEhVzH0m0GFAgCttGOXjCtgvRvcscOZt97DQ5LfUw4zK1E4TY56rNcv+GEedqe07wRFCWUARAEoUNFB3C4XI+v5GzuDS4zfsTVX3oG20Y5JvanmdouCrWKQKuYSN4GkPF0ZEUp/cOJ+dXLASGQGBkVlOzR3BPLE4PxLlF1//YWKXkGGkAkccX5O1q0iHvAG+im2Xkc0iwAnRK8IMaKZSjXo7Ge/xBN5k2t+3VGo6ndQDDoTCCWxHBvpvciUG7A1kqn0nCKBAe4qMHtQPPSARnRbByHwfUqO41IQtw7bp+6aEwGigHHKfj+WdeNnFX79Ls6PZn/3fgYvvHxwB8hG6At91vvHb+CsrbQIcQQYIyvbziyP8shAinQxaZ3BwXPSwGvzzAvqd5cviYaRUIhaPS38K1lsC6guKMXYN36cQbmZctg1oJ1Q3K9idnfl7R
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
index c3899cc1dd1d..82862d57c0cd 100644
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


