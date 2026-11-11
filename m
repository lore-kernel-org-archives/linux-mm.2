Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AFD606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=VibviTTQ
Received: by kanga.kvack.org (Postfix)
	id 4868C6B05BF; Wed, 11 Nov 2026 01:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465126B05C0; Wed, 11 Nov 2026 01:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1A26B05C1; Wed, 11 Nov 2026 01:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F285F6B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C342A7232
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:40 +0000 (UTC)
X-FDA: 85421907480.26.BCA3E54
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id C15CE140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VibviTTQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=danRQcnk3B280h/USGxRmGkCh5xva64LrrnpATvfP6o=;
	b=03eFCAdDzvgn/6sC0cq1Nq4EayzDsepKcwg8qLxRT1V3zI6zK1AGz09Vrwih8nsSYyY6h7
	8sIHFZ+iYbLQflXRpOTqYF4fmLGbkGOOYuict+wO0fsKD+0I14JF/dNBe6dMnjHGr8YaIV
	gCh/3StkaOkPZb/Y+/gJXxvzxuoQWqw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VibviTTQ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf23.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379658;
	b=Gw3Da/C3cSNwk3ejPtCevMhVMHE8WgwKJ5/1iLK7bC0UMKpBT81QMWFy0miGkbNbBF2f+1
	z6qcSSIEo6O3h3J9hTuqZHR18pxbCNa2gB+QhG8GBepahHbXKL3jGSOR2YIqUtWZJpaMsP
	CGD2fKIhh59pcE5M+wk480BxpOlBsbk=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso1219549a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794379657; x=1794984457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=danRQcnk3B280h/USGxRmGkCh5xva64LrrnpATvfP6o=;
        b=VibviTTQa4zMoOkZdvSE36l1tFpY1TDYt7V/+aWdLHdk6DMjWHnpFOjQE6NrccFDfm
         5E6Ps2XeZHI5TuY3ZSkqnRnHK7aoifBjmCjlqca4jWiDGpxZC37LXCZJY1G23YwtpC8w
         nxJPImFL+WYmBoY1zkZsmyzqnJEezdjtIWz7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794379657; x=1794984457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=danRQcnk3B280h/USGxRmGkCh5xva64LrrnpATvfP6o=;
        b=Q0zZ8aZvDrZWy+BRHG259X1LFRSzmQa7GcLYKM7wh6WpGhn0N9GEoVMc1qdrdY+ocz
         IjbZKpo/kxBeb/0SjNbFxFYq6DAJm6V47BXlmIE/w2/DCrAfzEMJyViI7G2Xir8npy78
         eeqR/910O9XJ8H+df9SG6onPuQ2qNHCq0WvFpe8cTJVRAeioI7R3n+jPvvsVfJ+pUeEM
         TM4gmFOGFba1VsemWH83+JJ/3R88IG85K/QiLKNjQxf4776NHnGx10qMJ/sSwSyU7k+n
         RAT6frVL0BsY7PHeF/xwx7dgG8iTUgccEVyCu8x3HZhw6UFfIzA7tckZBcj7upvkrv1h
         Exqw==
X-Forwarded-Encrypted: i=1; AL+hErFmfW3tRk8v/N8zzo0Gq7xh+2OKBQdXC2sOfTgWjRBeTAUswm6l+lToPgTC91MnSU/z30YJnZRT3g==@kvack.org
X-Gm-Message-State: APuU4Z/Xf7kZOkayhZ6yb9X2PwuBeoV/WiMUWGExNQkoQJbiawWTOIT5
	H50hgyrvDW8WP/9yPgzLdlcZtwFS4/zTX3Ybbl8agKGHqDZiD8+TsY6IhFmvHOjC7w==
X-Gm-Gg: AYBFou16Zufeh4Jv6YZY8GIOqopCqa30FV/+DCMninte69bZ6QPdPvj+kmyn7xkaP6d
	CPcrAbeOnEjKzrdVQAZCZInn8WyScm0yExAglyZRKnmzjzYB65+h92Rz2MzpHXG9i3pIrTWXOn0
	0FsTKZ5Yly/qK6/H+PEtIKtjz02cKSEPOuyHfRW6FCPLxQEiMxnI49mDEle7BaJmgVtRWmTz4Z0
	ch+oqVqkHi7+zlHOW0ZEaTOJOIqCvOhzC3h6Y5MEmNyx7c53T3bDrgm52Emt5ev1Q9S16FHd1ij
	UaiBHDp2VoZ3T5WIshk6cjZ3L3J5WfJiV+uRypB7PheLVk+8IGqzDuThv/dafzswA5cMaAIWcNX
	4sqMei1+MO+jvHWSI+ie93mgY9iotw+ya4PT0Y0Ona6kvn1eJjJ3PO8m+OU6pTvQMCzsnedFQmk
	wIMMcWYCilweUxO1gMyeUuOpBBnZ1/YktqVxxah/DNyuJvMvveunbm0uGdwIhbWhJt1qS/NSgGD
	25xoLj2osMuAaYFgvchsdyoJUoX5/RjAPqLgrpUMmFXTcHR4DgmEvbiqmm8hIWOXJpT4LMUjBog
	XC0ebLmVwP3UOgO+9lnq7MwpnLbnzPhAdPbQZOzhJ235nPAp4/O/86DDGsGp+AFMY5QYObdC8fb
	GzjjwMa4pwrIjIqfaT8CPGv9ZiepyLI2UZx2ILL9b
X-Received: by 2002:a17:90b:4c02:b0:3ac:450a:fa22 with SMTP id 98e67ed59e1d1-3b182e02b4cmr1701761a91.2.1794379657428;
        Tue, 10 Nov 2026 22:47:37 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db85a9bsm3268666a91.14.2026.11.10.22.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:47:36 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 08/11] zsmalloc: encode 1-based obj_idx so valid obj is never 0
Date: Wed, 11 Nov 2026 15:46:31 +0900
Message-ID: <20261111064707.2568433-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261111064707.2568433-1-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C15CE140009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b1zywb1odcf76copoosi8dhejbfwxh33
X-HE-Tag: 1794379658-937601
X-HE-Meta: U2FsdGVkX1/CtqbVJanZe4Dw1KJLE1XlgTxMLddXsOOAXcnfGd8Int5eiqf6QwI7GcrCGZxD8sEGO2WmSoKO59T3p6PWPY5UdhmIdgXePT/O3mBH9osNEGYg0pMZq/NUUEM9IO1ktgtVLqt6HfQivfGCw+YLCQ2srIWTnqw4Z5CvrTQNdeq4pSTBhCcWzoLZ241fbyIlc0l138eS9Da5anb7gzjoKfrDGTEEt4j2asQgkQ3yHLjiYPRmlVWf8ALo5qB+jD0ohNSCGbC+Xn8deZQTyLcyolAceKL0n81LtGiewjyimE6CbIJ4OemQc7afKhmWz99k2YfrehhUsNkMIWnH7CHWOoeKxTf48Zi6Mp7cwaJA/MRo9I7Y2V3Vu0xyE0MLIkQLkmmlM3mpI4v9rMFUjiNAe2z3aCK5ic5iVpzeNabKS6wDgOA5ip7DrwzyhWBVH/QE8mmvCicAHbjG/63RTOT92bS3lwGNAM9drKI+BtayKBz2Qj/qlb8RqmtN9W3srlXnjh3OtngrJQSGp6GrUueQ+y9thOkyfMlRM0qtkVB6tyNNVeZtRsaSae7NWGPBX7hjbMU/f1xa8on3ubyen1eDeDe6frj1HXVMs5pPoKXtV22ADX8SkXQo1l1xH0h1ohlxpOZr+ucsxw4bmieLs/dpHelm3XzK8+RoY/78Ld4RZ7/Tj/19Q/YkO3oVnVpKRqb61jDobyoWiE9WA98CBj4ARq+DdfmoH75r69Y1I/ktvyHQ46XC1eicB+C4mzuaTXox3Pn74Am5WBpGt+uDKOlZP7EyPZYmRSS0PxDnS363w41YNfyetfnYFbLH0GY05PLENHZm/KhG10w5tMPlREa6idcqOj8+qtr7mSentgeiLZLD01iUW5uUGtKYhaj4/LLMjGzH0gIayPSSZWZujh3CjPEx01x23rvq/NFmJEAmP/oNbmVT3pqEJ2Alqae8JbXZmBrlMXfAR6C
 f9MsSs0w
 CVQQcGVIwKxqJTP1RkncGryWUCB2U3t55NYCfkW4kaTeh2CYSsGEuFiMISigCfE3AMiATE8QosDi9AyrD+IAQnf1sNPhRS8njECcXpfYjjdpDeai3JKMQV5LOaLgI4yZocwK7dLoHPv6chROpL1OEfJ3pHdVyxD2tMJ/3FfvqTDQmqMoe9Kyt7gpEM57wPIUn287rGZdSrdl7swWxY76tCmij8fzpM7gwn/SX5/lwdRUnV5Mote5cPcEIqe38u6GHkNtjL6KGD7pACHtPM91+wxHHd/fPgUAClkY0wudI+r0uD1kMtH1+JQmykeZzi1sKrmfmzWNNd2nQVxhp3ogpox9QVhIKUDZ4bx9+SME2YhweE16SJF0o+0QOiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The next patch embeds struct zs_handle into zram and zswap entries,
and a handle is considered allocated when its obj is not 0.  But obj
can be 0: object 0 of a zspage whose first page is PFN 0 encodes to
0, and some platforms do give PFN 0 to the page allocator.

Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a
separate tag bit, this doesn't take any bits from obj.  zsmalloc did
the same before handles moved to handle_cachep, see commit 67296874eb1c
("staging: zsmalloc: Ensure handle is never 0 on success").

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2385c1951ca7..9be538d0be22 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -61,7 +61,8 @@
  * Object location (<PFN>, <obj_idx>) is encoded as
  * a single (unsigned long) handle value.
  *
- * Note that object index <obj_idx> starts from 0.
+ * Note that object index <obj_idx> starts from 0, and is encoded as
+ * <obj_idx> + 1 so that a valid encoded obj value is never 0.
  *
  * This is made more complicated by various memory models and PAE.
  */
@@ -169,9 +170,6 @@
 static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
 	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
 
-/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
-#define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -189,6 +187,11 @@ static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
+#define _ZS_MIN_ALLOC_RAW \
+	DIV_ROUND_UP(ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT, ZS_OBJ_IDX_MASK)
+#define ZS_MIN_ALLOC_SIZE \
+	MIN(ZS_MAX_ALLOC_SIZE, \
+	    MAX(32UL, ALIGN(_ZS_MIN_ALLOC_RAW, ZS_ALIGN)))
 #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
 				      ZS_SIZE_CLASS_DELTA) + 1)
 
@@ -794,8 +797,10 @@ static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 static void obj_to_location(unsigned long obj, struct zpdesc **zpdesc,
 				unsigned int *obj_idx)
 {
+	VM_WARN_ON_ONCE(!(obj & ZS_OBJ_IDX_MASK));
+
 	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
-	*obj_idx = (obj & ZS_OBJ_IDX_MASK);
+	*obj_idx = (obj & ZS_OBJ_IDX_MASK) - 1;
 }
 
 static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
@@ -814,9 +819,11 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 {
 	unsigned long obj;
 
+	VM_WARN_ON_ONCE(obj_idx + 1 > ZS_OBJ_IDX_MASK);
+
 	obj  = zpdesc_pfn(zpdesc) << ZS_OBJ_PFN_SHIFT;
 	obj |= (unsigned long)(class_idx & ZS_OBJ_CLASS_MASK) << ZS_OBJ_IDX_BITS;
-	obj |= obj_idx & ZS_OBJ_IDX_MASK;
+	obj |= (obj_idx + 1) & ZS_OBJ_IDX_MASK;
 
 	return obj;
 }
-- 
2.56.0.542.g3ef89b7020-goog


