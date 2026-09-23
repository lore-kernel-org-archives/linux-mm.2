Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D27C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7250A6B0092; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6C96B0096; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBCF6B0093; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28C026B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D653EA3C3B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:49 +0000 (UTC)
X-FDA: 85246271418.28.187389E
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BC7A1A0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EtcL6ZKG;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPVSrxtSx9kDTub89+jb9IguuxzhfykwRy7ihRNBm8Q=;
	b=S+mCDubFjd+KGYKoAejaKMYd/dlNVHkB92OaDt7EWwW5y+Igh5ETdpFRJkmgRlFcEyAP4P
	hkogZtP1B9/nalMtHx5Y/sJq9W44e3aQ6MPTtuhSy1dD7XC1Lbc/v2kG3Br5tOtzX4UvKP
	oMogvU8sW6sf1nZpXlIm6m3GJ52hHiI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EtcL6ZKG;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197848;
	b=ZeFGYZTE1Lioq5aAi5n5FMrxCq3h4enN959wG3iz0L1xjX0FADkiqwIsrvP3/ys6AnxKdF
	6CqszbZEns/oCUwLjNy6RnTI7diCvaLoKsfBk38RadtaA+ZZ+fKloF7RhkvyzQcxVTtucJ
	gRD6mveciSFkh31vk93qixN+l1qEQ/0=
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93be29bb454so195654785a.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197847; x=1790802647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vPVSrxtSx9kDTub89+jb9IguuxzhfykwRy7ihRNBm8Q=;
        b=EtcL6ZKGCOv4L5HjLWAtJeSdZYFXFyoT13TkT+rl69D1reoSoWL+DryqkWL2+7vg73
         CyNvncPdmNHXvtOCPI3jhup9PDPPFJr6STHcumxMPLwTITUkolXmBJuZymvHXbm1o9vS
         rDHFXu68GFqkQBTrN2e6fxERjrVmxuhzycae4SwMv3uEbfwAX+IMfsSpM4pAB6srgESi
         Vu9RBIsm3n1txh98Gs7Jni+tQYayislqoi+JgX4PA69wXzKTnRYDR9fU4JAaFkVbxZ+Q
         4yVomyja7A3R2YhxhD65ZdjMoZrYsCsCsjuX97WIni9uBxwhqV3FyRW26AZxNRk5//q+
         nJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197847; x=1790802647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vPVSrxtSx9kDTub89+jb9IguuxzhfykwRy7ihRNBm8Q=;
        b=Iu+HPuxHNUn1muK9+GEX8aYJnIJwcYhBdWGqy43aVmXrFgQI7+sE7nCjgFkCw0/MaM
         9toht9xZrKDbwgRmIR+0ekcJs0K7NZtW5lMumaZmrIl2xDzHSnqefR32Oo5WnH/wu4Vm
         7tOJupDBi9Y57fIbAw+Yt+ybj+EgJu+96n1+JPdfFlcqU34YmzDZQYFHT8Zb8MdOsN7y
         ULStq3GT7zdXCMKPioAXlIufKRGk4aSx9hG+/KoCZfpUz9reZo/zCoZ9bpYrMQL9r+ET
         ANNSPpQtkvM+StGs3UHZf6ipQZXDTgB6kBRjiVGUZ9+jDlr7sQ5l0gTODcrNHVFZMluz
         8MnA==
X-Gm-Message-State: AFuF++nbyYIgcOtPOF5CqOz3jKnwX0fKZPnCxTtbKYaFX9bt5KtOJg0C
	eeGG8B9m7DDnXT2viEdtsPfitxc8tDX4W80bXY1FsQp1/rrnW1m5V8QIuFtDMLnMfgQxCcb4z04
	jfoP4ycc=
X-Gm-Gg: AYBFou3SfVe2ZlFfFVsRhNBq2ooRcvlUyOicjz87PHyZKdLPEVLpLl/bprZvxwuFQT7
	8MLhsDShb8Kg4vBoJP6JSREAJrqn0dwtwQAf0LxyhLLW3rLp7a/MsrHkKwmMgcg3/qKClWj1UGr
	shAA9zsx1BK1bh8+LfRg0Nkfi/K61xmK4ocIZ/dMJoJ1jMybvTzvLqETg2b2/Oj9dcVU5Mcaxhg
	JOmHeLVfgWqVyUCTWtPoe2VYxSQzEPa9FOEowgfsxTZpuktOkw/XDxKOvjodTaeTTX5Bt0/DaV7
	r4MAlx0rUC56CJ2eLlZ6syZ0Bzu7mB9Cw5fO5CgBb1O7e2HM4uivASEkKk4jaztHLLzg25xT7nA
	2j8r8YodVMe792It/35jcImW6raSSujn2BWdtNv9inmvr4+4xib4SJgrpxYtW2db+pxqqohyphb
	wqwSVVixBykHRIvLJxR97IFZXENxyJmsQCAdbtpbePDtndhd/4SFqF/f/oy2AIAfHmh2ZRz0mKZ
	Y5hyI6vgZMI8D+2oM5UGCCkkc+00nSKk0Rf5LBJOfJfh7zHlT4mPZhyXYJa
X-Received: by 2002:a05:620a:2586:b0:939:9bcf:8d35 with SMTP id af79cd13be357-93c348aee16mr64595285a.35.1790197847255;
        Wed, 23 Sep 2026 14:10:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:46 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org
Subject: [RFC PATCH 2/6] mm/page_alloc: refactor alloc_flags preparation
Date: Wed, 23 Sep 2026 17:10:36 -0400
Message-ID: <20260923211041.3127588-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BC7A1A0003
X-Rspam-User: 
X-Stat-Signature: o4pm5sfkicep9woyz6jsy8a48gcmbqgx
X-HE-Tag: 1790197847-851327
X-HE-Meta: U2FsdGVkX18RZtGau5bOD7ZQM6/wBUTAX/iAk1qsSLTumfwH74pvRL8MEMIlfQTIbjdU9sI2CmQl7i9McEPkqKnANsVZC+ThprIpsRntn/2Wz16HKcrT/+FeC6a7ait/MkK+vggiSZ4yjKaOijdvxwRx3YpAj6WZym7t+P+8W/iKmJPZASLap4QFEtmnMAYRbR0fAwCTdkyoALJizK4M7AxXrRgKozwjiLLxXVRDfk4OMx3EMSvhI1rKwLRp+355Mzk6t4fOHDig8/T14m21AzmytEbeYJjPobuv4RT0LeX/7br1DZoEGtnGRJ4+CkyToenB62SdNB/zzKSIx+r2OgPb2au2pE8jeojjxD5qDwovIFyMWMbzeFzhgfvV++HEM6v2ru9MRi3TwB6paC05Mcf/ikk2IVGFq/R2lQ99UpYjE5uUy/frOpIji4dM1CUrVW62lKIde47HkSpzNH1gCky5i92fhc+YVwdG3yq9yDj1ywZ0lZN00udPSF6iquD/zyI8Pc0typCp8+OmiLJ/fqKfP1kMPn6GOn7vetHYM/T8Unvge1m+R6f6gPYv1HUBsfRVcAxbxdjSW3N0kL7pZAn4N97rHk4+TvagHZIG3wIiB0gQxuuaklavhvZ0792HWnq3eePeNZM4HnmAOKHc7cGjUPK1HuucvPsk5B40U8Igrm4whCJTE9FMy/N8O+1VVKIGZMYQwsFSY5eS9Yp6XgWFi+DlL/jgLz4+Og3z14PJymuwJAqfmf2d1nITW5DImVMNRqIcWG5nLez1L5h0G4hH6WskbBiels4htizAuBONaa5JPNodbwuVZ3NvJuDL9IrDZXV8VR1dvBjcKJUSlDzQsHey1LhE3X0+2eH7Ba5sucoizy0WbHrA4MDYSxoi74Aof7s6e/t117+f6Xa0PV62sELmbqGMUAyPckue+CLGtaLW99O+mleb5iKDJnmY/oe9G5ZFaO9HrhnZJt4
 9T3N4bIV
 Ggd/2HSXUz3g+RGy1bBCf+QuW9tV4tkPOMKtwMpAeGjRmpgFefAX/cl/SofnxZ8GEwJTvxu1qR1VDZtAkp1ZH23lujx9JBcgQ9v3imkRdmGZoV70F7Dis2mrzJxU7C4pCz033rByJrSkhtSHq+gPT44RlZFwwkPOEsd26CGAko6DV69AOkapgxPhoBXSoH+cmg/IEUg4NsMe7Uz2rCBrln1zstarp02rJvWnbSlTL7p/Pr0visfx26CB3160kFM+GZ0/YhnZScDuKZbSiOzBDYohUbgvRTdge385p8kP8Ze8d8mpVO/RWN4hDragVpDWG0MzXfvJPg+YstUtG3KgJYxbv7/Mj1e7q7yItL/kwaE9N95ks5gqSAieC3Q/ow/s+PUAJiSefA5faV0CVRqEDYRBt9Nwimf68uVZ8kpHdFarHa6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__alloc_frozen_pages_noprof() validates allocation flags, checks the
order, prepares ALLOC_NOLOCK, and selects its initial watermark.

alloc_pages_bulk_noprof() separately initializes its allocation context
and low-watermark flags.

Move this setup into prepare_alloc_flags() and call it from both paths.
The bulk allocator continues to pass ALLOC_DEFAULT.

No change in functionality.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 158 ++++++++++++++++++++++++++----------------------
 1 file changed, 87 insertions(+), 71 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 728dd1a36f0f..b4a021fad183 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5138,6 +5138,84 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	return true;
 }
 
+static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
+				       unsigned int alloc_flags)
+{
+	if (alloc_flags & ALLOC_NOLOCK)
+		return pcp_allowed_order(order);
+
+	/*
+	 * There are several places where we assume that the order value is sane
+	 * so bail out early if the request is out of bound.
+	 */
+	return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
+}
+
+static inline bool alloc_nolock_allowed(void)
+{
+	if (!can_spin_trylock())
+		return false;
+
+	/* Bailout, since _deferred_grow_zone() needs to take a lock */
+	if (deferred_pages_enabled())
+		return false;
+
+	return true;
+}
+
+/*
+ * GFP flags to set for ALLOC_NOLOCK i.e. alloc_pages_nolock().
+ *
+ * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
+ * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
+ * is not safe in arbitrary context.
+ *
+ * These two are the conditions for gfpflags_allow_spinning() being true.
+ *
+ * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
+ * to warn. Also warn would trigger printk() which is unsafe from
+ * various contexts. We cannot use printk_deferred_enter() to mitigate,
+ * since the running context is unknown.
+ *
+ * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
+ * is safe in any context. Also zeroing the page is mandatory for
+ * BPF use cases.
+ *
+ * Though __GFP_NOMEMALLOC is not checked in the code path below,
+ * specify it here to highlight that alloc_pages_nolock()
+ * doesn't want to deplete reserves.
+ */
+static const gfp_t gfp_nolock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
+				__GFP_COMP;
+
+static __always_inline bool prepare_alloc_flags(gfp_t *gfp, unsigned int order,
+		unsigned int alloc_flags, unsigned int *prepared_alloc_flags,
+		unsigned int *fastpath_alloc_flags)
+{
+	/* Other flags could be supported later if needed. */
+	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
+		return false;
+
+	if (!alloc_order_allowed(*gfp, order, alloc_flags))
+		return false;
+
+	*prepared_alloc_flags = alloc_flags;
+	*fastpath_alloc_flags = alloc_flags;
+
+	if (alloc_flags & ALLOC_NOLOCK) {
+		/* Certain other flags could be supported later if needed. */
+		VM_WARN_ON_ONCE(*gfp & ~(__GFP_ACCOUNT | gfp_nolock));
+		if (!alloc_nolock_allowed())
+			return false;
+		*gfp |= gfp_nolock;
+		*fastpath_alloc_flags |= ALLOC_WMARK_MIN;
+	} else {
+		*fastpath_alloc_flags |= ALLOC_WMARK_LOW;
+	}
+
+	return true;
+}
+
 /*
  * __alloc_pages_bulk - Allocate a number of order-0 pages to an array
  * @gfp: GFP flags for the allocation
@@ -5169,7 +5247,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
 	struct alloc_context ac;
-	unsigned int fastpath_alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int fastpath_alloc_flags;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5207,6 +5285,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 #endif
 
+	if (!prepare_alloc_flags(&gfp, 0, ALLOC_DEFAULT, &ac.alloc_flags,
+				 &fastpath_alloc_flags))
+		goto out;
+
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	gfp = current_gfp_context(gfp);
@@ -5335,56 +5417,6 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
 	}
 }
 
-static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
-				       unsigned int alloc_flags)
-{
-	if (alloc_flags & ALLOC_NOLOCK)
-		return pcp_allowed_order(order);
-
-	/*
-	 * There are several places where we assume that the order value is sane
-	 * so bail out early if the request is out of bound.
-	 */
-	return !(WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp));
-}
-
-static inline bool alloc_nolock_allowed(void)
-{
-	if (!can_spin_trylock())
-		return false;
-
-	/* Bailout, since _deferred_grow_zone() needs to take a lock */
-	if (deferred_pages_enabled())
-		return false;
-
-	return true;
-}
-
-/*
- * GFP flags to set for ALLOC_NOLOCK i.e. alloc_pages_nolock().
- *
- * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
- * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
- * is not safe in arbitrary context.
- *
- * These two are the conditions for gfpflags_allow_spinning() being true.
- *
- * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
- * to warn. Also warn would trigger printk() which is unsafe from
- * various contexts. We cannot use printk_deferred_enter() to mitigate,
- * since the running context is unknown.
- *
- * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
- * is safe in any context. Also zeroing the page is mandatory for
- * BPF use cases.
- *
- * Though __GFP_NOMEMALLOC is not checked in the code path below,
- * specify it here to highlight that alloc_pages_nolock()
- * doesn't want to deplete reserves.
- */
-static const gfp_t gfp_nolock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
-				__GFP_COMP;
-
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
@@ -5393,29 +5425,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 {
 	struct page *page;
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
-	struct alloc_context ac = {
-		.alloc_flags = alloc_flags,
-	};
-	unsigned int fastpath_alloc_flags = alloc_flags;
-
-	/* Other flags could be supported later if needed. */
-	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
-		return NULL;
+	struct alloc_context ac;
+	unsigned int fastpath_alloc_flags;
 
-	if (!alloc_order_allowed(gfp, order, alloc_flags))
+	if (!prepare_alloc_flags(&gfp, order, alloc_flags, &ac.alloc_flags,
+				 &fastpath_alloc_flags))
 		return NULL;
 
-	if (alloc_flags & ALLOC_NOLOCK) {
-		/* Certain other flags could be supported later if needed. */
-		VM_WARN_ON_ONCE(gfp & ~(__GFP_ACCOUNT | gfp_nolock));
-		if (!alloc_nolock_allowed())
-			return NULL;
-		gfp |= gfp_nolock;
-		fastpath_alloc_flags |= ALLOC_WMARK_MIN;
-	} else {
-		fastpath_alloc_flags |= ALLOC_WMARK_LOW;
-	}
-
 	gfp &= gfp_allowed_mask;
 	/*
 	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
-- 
2.55.0


