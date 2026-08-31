Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B61C4C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575D56B0096; Mon, 31 Aug 2026 12:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFF36B0098; Mon, 31 Aug 2026 12:38:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A406B0099; Mon, 31 Aug 2026 12:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 006856B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:38:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 618D5C01E3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:01 +0000 (UTC)
X-FDA: 85162121562.28.B8E300D
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8F143C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:37:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NrOlARJ7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXFNKbTdOrOMYaajm/HLCYSs/GSBNBi/73jyNLJmP+Y=;
	b=53hXxl7QQBO/LYmBFr5mw4s8kKugODPVgtgEG4hSCKesk3PWVPocYKqlez9DALSFeE2WtT
	BBMTQgscGt4FpxMCZO9kurKca8qLfBfaAsWt90AA0DFfXomqDmB/mkabef3IAgeUhr/vrN
	32hrU0sisEqPyGatTjIO6COMeqhfELk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NrOlARJ7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194279;
	b=ytAtBvYyi3GRDaVDul5qpn1Wg8gHyX1eg5RTm+FtlgkrE9ybtJX5twlRYqQhHZJYqaBq+u
	NrmLvjo9KTVJKAoR6cUemec0dDyDLGtPyZFYHX4FwOLjP5Yt5uD9bMCqKz1sAeHjoYMnxH
	T3Yy63lrIkHzxlFg0MqMXyIbePnKRio=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-46556b9e02cso64515fac.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194278; x=1788799078; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vXFNKbTdOrOMYaajm/HLCYSs/GSBNBi/73jyNLJmP+Y=;
        b=NrOlARJ7X9RBT6N8dJImMQXEfV9REFF5DgAUpnvZo3jN8cw2ckGGUg8wny0zQ3XoVE
         JV3Jba7m2aO9Wx1bGLFjvaWtMjZhXRoiUH9R70iACowXhCRh/hYECF6vCMZIhMDzBv2b
         KhJpbIg7YuCF3Jnol1LrG95v5N0Yl0unx8x+j/01QAFxb47PgLJQZ67jv3NPNXtDqs3t
         UfZ7J2f1Ih73aaHrB2fzNF3Ayo43dyAnW4zQunCA0SOJ/GvP1tJJ97OgnQb2c1gTnWTL
         LYCtrGZGTiHDZjxBgYNqLF98P0FkiVqgVSH/6qZRYRXbxgVWd7cY+XYBPRW/R4QC6wgt
         kJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194278; x=1788799078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vXFNKbTdOrOMYaajm/HLCYSs/GSBNBi/73jyNLJmP+Y=;
        b=mJQ+hXgzLjyw8RGI9/OpIfq2PU5jzixlOL/9URCWDqOI+lOrr4YnFeLggPkMv3SJDZ
         iziJQAiqM2dmtNR+tlM4SpHWPSmSAZYUlE3qb+Aw7Qh2zeVfdefJyxPKPckF45lvoo2m
         LME+JK9out6oF17G7Yea44CsYKP2xUvM6Yu1RFsL/gD7Vwjy4E6zSHOwkpouoJqU+Hvz
         xKvOs0pgi4H6ranyKwh/YPRX13U3HEukKmfjl9H6x1wKTn2guTZWzWHLnuYmg12G6BZA
         9Ui9In/ktnoN8cXc2I38Dgbp2d2wVDcT02a7X3FcMEnyxhka/Fn7olc69GmWWWza6ala
         eDaw==
X-Forwarded-Encrypted: i=1; AHgh+Rqnvu02v8SkSnbQfyaYGy3AFEgW5SUusskHwauWi/nDlsF3o4hBmOKSbVkIE0rGw3cI5LAebKyrvw==@kvack.org
X-Gm-Message-State: AFuF++ljLg65qGEB9M9i1EqTN6ShrLAvcSO5odJUcJFdj2bYZH82NiVN
	kq28wMVQFt4meNiqNRgEYR1QvzZxbmuovPy9OqKQneNX7PrnEskzfVRq
X-Gm-Gg: AYBFou0xKUfiTaz809bwq/bTxak9BkjvIcCHK+hSzSovqOQyF+rRFz7999Gr84AcG1+
	f+0H73JKV/Y4d6g8pjH4hmUZl3kgIkHWkbysyZjs9sPLtLFPs4RR318Ed3W/a0A1NtLc7SbonGf
	ogEpJGqenhtDSoEXxQtWgJ5HIOuV4udVIkowsrK0HTOkbGJ2VbZRnWRZYTYxU+TajrqOd591pws
	HzNr9wnpgKRVrkXxY/DDAccz9C43tQnSz8wtzLynI5Zo4Vr6HZcIIW2Op/59oQBhcv6dhRC8i/C
	MUE/Jk+uuj44atxMHy8ExL6WT7E4S/8LNz78mxPvDgWC2TdU6CwZvS2Uymn1z4rN/+mDwUTqjTM
	Czr64Va9v4I3NFTBoae7fnANk8RQFB2cK1/ovsNYnl4UBHuaJiCLERPaFyrwb8wFy/TEYlZA/Pw
	EQv0ox1dJoMDgVt4tN0oqqMpKcMUiIHrbSoR9cq4JSbPceNYISp7ZvueoYw0dJzHVyH9wpDeZN/
	HO/5MK88O7sB8Z4PUQ=
X-Received: by 2002:a05:6870:2b11:b0:456:4c6b:773a with SMTP id 586e51a60fabf-46aca5a5f8amr7723915fac.9.1788194278410;
        Mon, 31 Aug 2026 09:37:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:30::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-468a4effb4dsm10497204fac.10.2026.08.31.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:37:58 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 4/7] mm/page_counter: use stock in page_counter_try_charge
Date: Mon, 31 Aug 2026 09:37:48 -0700
Message-ID: <20260831163752.2193337-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F143C0007
X-Stat-Signature: mhmbrd3dmwgmer9p7d8btqa1u8r1nbwx
X-Rspam-User: 
X-HE-Tag: 1788194279-813033
X-HE-Meta: U2FsdGVkX1+LeJLhJa+lj+yC9c9af4QVWd4wHc2wJWYlQiXkpqZIjyQwbcTILZfY/n39rpmLwveDFabavhmC/8thj/4rBUL4+YPZEmdOuE/ebEuLsRx1mHhkPJBZ1IT5t5o9UomNmH0ubDqibL3fzWbD1/K6LhffMvjiipPX/VTXO6oMOZvLOT49phh1DTMUlHe+JEbU5jz2Pr7EAfNddDFFDC/i0aJLipJ8evL3EtRQeFVvv0W7TPahICCs81lvsInNgo7VI6sxGy4xvJ2EBq+g+O9VXJ0+24B4XeQ4tdUTJafPDlTt74al/ZT6VGosO9tBfh+Q08j15R2TwQT5iYkcIwvbdUiOqjDbPgQNGWdtu2pEfYos+P9bW6Y8BnXBIrg+yK4tER8HwbSAjwizsUBTIl01k8mKEAMJlK9n7YAOFQhiYgbK8fXGekYbywaVHVaKM5+VbREMI72fNOe8nqBcgzMjH+aiBS85AsSFzy+BZqeGB3tI6ImtJc3B+uCuc9xdnagcchTH9824Tyq5dXS10rciCT0TXGonREeTEAxse/MP1wWJnmUF+S1A5Uekre0PcXfK0XSPgj9uINgsIAeWA3WPuoQDy1X7PaXBsT70NVWASstgfyjcwa1RQMILfDbEJLrnsh+DfanzkTRgwaJFCNHo99mlkx1kLKJiXWb248M30NfP8Pi10K01P9NC0oeO4/vRGrxhyBzOw4VXYKNo+0MGczp0fNuXrQuqv9dXV1c25VvqNgw2TRq9CWmBt9U3NVhOTnrH62YSTkjuKETKmlEPZJ7UKSb5JAUK+IsJRXSI1U3JQG8hszbqYKDxGa/6w01ZZLnfIT3/VOZTbMRi7Th4bGmfeGX6OBLl8N1NsDPcyPRpPAAclxmVxtylUyCIeyhhc20ol4LoSM3Y0UG30//yRJyBIuoUcu4vYUKQixkXDN9TBq6YDYzorD5pzqDuykARdy+DAIIJ6JN
 V0+rlAuc
 3aTvqGXyVZHLW1INZdqJz/wF/3cvnCIkiI9NvHHiooNufsZQaMA60bZ9HIVMj1fpKvVE2yJKSMB9cYblqagX80CRi6odlNDOc+CbB3NuxGdycEQmc+Rs4DotHTq9YX4APzvdHubx72dyf4b2Xuz05kL1phvjl9UhBrbdG84lbCUauPWclO1Ld52otJT66m85C7TjzDJp0skk6BggE1cm5zQ78Q3M3fAMo+cX1tbeSLy2ifq2/A1tKy/gdWvgtOzTyTLfhTSiulCnk4IzIRt5jqM8DTXcZT9sbbXLCSzSJ8SQEPhYM0DPJC18eDiz6d7PkJ204lrSZmWYcpSGJxY+PkwwQc58Fin92YvS/4sgLbYlhPmBPtYhBWX9xxoMgjJe98kkAsd6gtq7gO5QqiH869XxKOhIwtrV6L2D4ErHnmPtgAjP3wPPkwZRro8j6zMrDQmPyOR/bhK9TrAxJ0tdJxV3HWRRii4568cG7NsgSoGiGtce/8mY9LrV3lDGquFwx0tvg/G0bpI5EM973OybsQoPH884Wkr8qXr95F7B89Mh4IHeh0fjrZ8j2PqkJQi0GEKN7MhVgKNSnMyyzBAkdtLL7bIL+ayj3KdH3V6H6SgPnnz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Transparently make page_counter_try_charge attempt to service the charge
from its stock. We preserve the same semantics as the existing stock
management in try_charge_memcg:

1. Limit-check against the stock. If there is enough, then skip the
   hierarchy walk and charge to the stock.
2. Greedily attempt to fulfill the charge request and refill the stock
   simultaneously to the hierarchy.
3. If this fails, retry the stock and charge without trying to refill
   the stock, i.e. with the number of pages requested.
4. If the greedy attempt succeeds, return excess pages to the stock.

page_counter_refill_stock() falls back to a hierarchical uncharge when
there is no stock, in NMI contexts, on lock contention, or for a refill
larger than the batch.

The greedy charge is also skipped in NMI where both stock helpers bail
out since the batch charge would be undone again.

No functional change intended, since no page_counter enables stock yet
and counter->batch is left at 0.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |   2 +
 mm/page_counter.c            | 135 +++++++++++++++++++++++++++++++----
 2 files changed, 125 insertions(+), 12 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c1fe331f34e7e..428ca8e7b2da5 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -82,6 +82,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
+unsigned long page_counter_refill_stock(struct page_counter *counter,
+					unsigned long overage);
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages, struct page_counter **fail,
 			     unsigned long *nr_charged);
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 3f61eba695518..a76949abf04e7 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -113,25 +113,126 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
 	}
 }
 
+static bool page_counter_consume_stock(struct page_counter *counter,
+				       unsigned long nr_pages)
+{
+	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock *pcp_stock;
+	unsigned long flags;
+	bool charged = false;
+
+	if (!stock || nr_pages > counter->batch)
+		return false;
+
+	/* raw_spin_trylock isn't enough to protect against nested NMI in UP */
+	if (in_nmi())
+		return false;
+
+	/* It's OK to migrate here, since stock is fungible within a counter. */
+	pcp_stock = raw_cpu_ptr(stock);
+
+	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))
+		return false;
+
+	if (pcp_stock->nr_pages >= nr_pages) {
+		pcp_stock->nr_pages -= nr_pages;
+		charged = true;
+	}
+
+	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
+	return charged;
+}
+
+/**
+ * page_counter_refill_stock - return pages to a page_counter's stock
+ * @counter: counter to return the pages to
+ * @overage: number of pages to return
+ *
+ * Return: how many of @overage went to the hierarchy rather than the stock.
+ * The flush itself can be larger, since it also returns what earlier callers
+ * stocked.
+ */
+unsigned long page_counter_refill_stock(struct page_counter *counter,
+					unsigned long overage)
+{
+	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
+	struct page_counter_stock *pcp_stock;
+	unsigned long high = counter->batch;
+	unsigned long low = high / 2;
+	unsigned long to_flush = overage;
+	unsigned long stocked;
+	unsigned long flags;
+
+	if (!stock || overage > high)
+		goto uncharge_counter;
+
+	/* See page_counter_consume_stock() for why NMI skips the stock. */
+	if (in_nmi())
+		goto uncharge_counter;
+
+	/* It's OK to migrate here, since stock is fungible within a counter. */
+	pcp_stock = raw_cpu_ptr(stock);
+	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))
+		goto uncharge_counter;
+
+	/*
+	 * Use a high/low watermark here, in the spirit of pcp->{batch, high}.
+	 * If the stock would exceed counter->batch, stock is trimmed to the low
+	 * watermark of counter->batch / 2 so that sequential uncharges don't
+	 * all trigger a hierarchy walk.
+	 */
+	stocked = pcp_stock->nr_pages + overage;
+	if (stocked > high) {
+		pcp_stock->nr_pages = low;
+		to_flush = stocked - low;
+	} else {
+		pcp_stock->nr_pages = stocked;
+		to_flush = 0;
+	}
+	raw_spin_unlock_irqrestore(&pcp_stock->lock, flags);
+
+	if (!to_flush)
+		return 0;
+
+uncharge_counter:
+	page_counter_uncharge(counter, to_flush);
+	return min(overage, to_flush);
+}
+
 /**
  * page_counter_try_charge - try to hierarchically charge pages
  * @counter: counter
  * @nr_pages: number of pages to charge
- * @fail: points first counter to hit its limit, if any
+ * @fail: only written on failure; the first counter to hit its limit
  * @nr_charged: optional; on success, set to the number of pages actually
- *		charged to the hierarchy
+ *		charged to the hierarchy. Set to 0 if stock was served.
+ *
+ * A successful charge may still have bumped failcnt on @counter or an
+ * ancestor, since the greedy attempt is retried at the requested size.
  *
- * Returns %true on success, or %false and @fail if the counter or one
- * of its ancestors has hit its configured limit.
+ * Returns %true on success, or %false and sets @fail if the counter or
+ * one of its ancestors has hit its configured limit.
  */
 bool page_counter_try_charge(struct page_counter *counter,
 			     unsigned long nr_pages, struct page_counter **fail,
 			     unsigned long *nr_charged)
 {
-	struct page_counter *c;
+	struct page_counter *c, *failed_at;
+	unsigned long charge = nr_pages;
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	/* The stock is skipped in NMI; a greedy charge would just be undone */
+	if (!in_nmi())
+		charge = max(counter->batch, nr_pages);
+
+retry:
+	if (page_counter_consume_stock(counter, nr_pages)) {
+		if (nr_charged)
+			*nr_charged = 0;
+		return true;
+	}
+
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -148,9 +249,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -158,7 +259,7 @@ bool page_counter_try_charge(struct page_counter *counter,
 			 */
 			if (track_failcnt)
 				data_race(c->failcnt++);
-			*fail = c;
+			failed_at = c;
 			goto failed;
 		}
 		if (protection)
@@ -172,15 +273,25 @@ bool page_counter_try_charge(struct page_counter *counter,
 		}
 	}
 
+	if (charge > nr_pages)
+		charge -= page_counter_refill_stock(counter, charge - nr_pages);
+
 	if (nr_charged)
-		*nr_charged = nr_pages;
+		*nr_charged = charge;
 
 	return true;
 
 failed:
-	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+	for (c = counter; c != failed_at; c = c->parent)
+		page_counter_cancel(c, charge);
+
+	/* Retry the stock & charge with the exact number of pages requested */
+	if (charge > nr_pages) {
+		charge = nr_pages;
+		goto retry;
+	}
 
+	*fail = failed_at;
 	return false;
 }
 
@@ -330,7 +441,7 @@ void page_counter_drain_cpu_stock(struct page_counter *counter, int cpu)
 /**
  * page_counter_alloc_stock - allocate the percpu stock for a page_counter
  * @counter: counter to allocate percpu stock for
- * @batch: maximum number of pages a CPU may cache
+ * @batch: number of pages to precharge and the stock's high watermark
  *
  * Failure to allocate is not fatal; @counter falls back to hierarchy charges.
  * The caller must not (un)charge @counter concurrently with this call, and this
-- 
2.53.0-Meta


