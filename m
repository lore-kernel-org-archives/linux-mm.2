Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF68CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706D18E0036; Mon, 10 Nov 2025 11:08:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC9D8E0003; Mon, 10 Nov 2025 11:08:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46DEB8E0036; Mon, 10 Nov 2025 11:08:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30A228E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:08:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 017C51298E4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:33 +0000 (UTC)
X-FDA: 84095180148.08.BC7B782
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 484271C0016
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TU6wlo/f";
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+nV/jZ5/FDcvQE4dxxEIUjR2wXP7vVmGSVjfrNRBXs=;
	b=5mbQs9MQsU3pwUu8ogxByZVCAFwtEqj1GSYGAgawKmBATk24tqEA8YrF7C8GH5MGE9/QhC
	EobmRUQF7D+6JbAyigNdKLlATn8OMKGjxaWYFU9NlZuvb7JLdbv5efgPSJw0jBMLHUmxze
	S2scQ5QEkxqy0DiUYcR2OWs0gvVxW9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790912; a=rsa-sha256;
	cv=none;
	b=nSqCo8deLYmq4IEDWuJ70IVOFqYM2ltC1Yrizq1unfNTRgNpPPB3nSdhDoZNLSj5ZC7EHB
	Mt4E4Lw7/C0Ic4Ld9nTka3ptPRue0ZFdhEAswBMRL7S+G7njtFvYb5umG2D5CLBu9e9atu
	E384o3Wh5ly9wAt0AaUmr1Bmj1hmoZM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TU6wlo/f";
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3418ac74bffso2258417a91.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762790911; x=1763395711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+nV/jZ5/FDcvQE4dxxEIUjR2wXP7vVmGSVjfrNRBXs=;
        b=TU6wlo/f3xqpELMnUpVW/0cVrnPSIqVZKQgfruabzMQbk6qDVYfxFhruXlKHiHMi+A
         eycB5G2ErhyiEJTWwQDHzq2FNnEmAKfKudYnpNQE0Z4ou6+vviqimbhwXUmdWajoF5PG
         j+hyHKxek8e+hCuDKLGFV6PJDZ1DRm28jdDR9ZTQkJ2MH8IO7c3rNzwRxAEh8Ok8wwQZ
         ly1T3a4Nuc+PFxZNdnK58a+7BjEmyVlEMTx1cNllTlBHg0ITjFp/WxJMD9UYvgRAjuQP
         r7GWJAZOn9mOOIflSo3Xe4eXLgMu6TMD/xceNXgqKjrqQA938A+dgMPci1vfbu1EShMJ
         m9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762790911; x=1763395711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e+nV/jZ5/FDcvQE4dxxEIUjR2wXP7vVmGSVjfrNRBXs=;
        b=azhNn1Co39FmgtvSpIl/6lEOf9Y3FrLhO5+lV2DQBzdTmDGYCLYMT+MsngoQlTLvcL
         L680xUjUAZq76AA8r8Do7yvSryJqEOG0oW6sitC11twiw9qfMPetxZCsgeD0s8nuEQzC
         6Gz/cizILfGzbYdv3n8kpN4QXIE9f5qN9AnlZra9mwqQqc/rqScPxf+9UG+lR3G7ybbQ
         Ue/UY3+8V4jR8ASboPs2gA/msbn0L/ToNAwoS7B1fQ6K/e5D2UGXrZA9/NFW8R3w8MNT
         o/uRmFoEEmmbu0dwQbre9EubewuWM39/TMU71f/P79fqK+wGEI4DfC3Eq/w5jac1ARqY
         pRSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEbUkxVZP/bNYGG8FXKvbyYkDdV4mYe3ja04lk9dxTkN/g3SD3I8L+IKumjXqx5i3vAJqfsSLCqA==@kvack.org
X-Gm-Message-State: AOJu0YzSuDCIbG2T7HxFECingTB7+5Ao7D6ZJc9/O6aQ3MBUrD/PAQZJ
	KrPc+xpWTWI0cF21aUzsMJIgye1MUWDMJD4vdxXOmTRQhbvZGkAlSWHx
X-Gm-Gg: ASbGncvhNz01+n4TurSxwrIVpnTvaMpnTkqO54VZ+j7igFFFiuJOSvaKh4+8XX6tmfY
	oFbPv8Nr0Az8Hz3sCBew2PuUEU67CxEYg6u4Hv8tmOOvEauvfJNilPFFST6Fj6/XXV875thtoPH
	vc34GkyuDFo7Tiu68URMUWn6oBry0byspriBA4yK9dYmlksjF4fSKsYBt+Nedij2a1Fdtya1y/N
	BUDUzjFH2FFH/l9g8vwHAbPfaWngf51o61pBJj9p4d3XIHjutxtm+cvs2x8MR39pn+K5GCA+5Rf
	UGyeIbbTZV+D/MJjCs+RmGzkYq/VB3khXXaeq6xlvZSF7q4qXSJxyuxuFIzbo5MQmjUwhCWKLlc
	MPn2+Ul5Zsj6t6swSzUens43nXmx/h+BI9fQK7TMS51kekm3fBq4vOGjzrm37S2uL7vJL0oK1Nk
	hEAFQ37GJjRU3Y5MTfijJjdWu83+4j1P90
X-Google-Smtp-Source: AGHT+IGiGpXb5t1syDzIJ+ZneRXYGIQwIEFnb4stWo4+PFBpOfXR7tAoh7nWQDaILvEgym3o0OPTcQ==
X-Received: by 2002:a17:90b:3512:b0:341:3ea2:b625 with SMTP id 98e67ed59e1d1-3436cb91984mr13954572a91.12.1762790911074;
        Mon, 10 Nov 2025 08:08:31 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34362f1f231sm9308893a91.10.2025.11.10.08.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:08:30 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
Date: Mon, 10 Nov 2025 08:04:55 -0800
Message-ID: <20251110160457.61791-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251110160457.61791-1-vishal.moola@gmail.com>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 484271C0016
X-Stat-Signature: bd5dt5myp7mgco61cbhkzsziq3uhr57g
X-HE-Tag: 1762790912-10229
X-HE-Meta: U2FsdGVkX189ir5RpWEg2gYjlf/kuonf0rTGISJBmVTNCfsERpIDQfD2Z51X0x/Jj65lJTTxKYWej/zqzpskQn/SrQ4+TNs7aTd9utMz+x50W63BxAMAQqJW9kRciWs1pNN0HCzmY38rcs3NjziIxXb1cuPPZdpFmjKtQMRvBiH0hMFjWylFz8lAmkj6xVuOAnIqZuZdITn2z3LvBKOK6c7iOt8yHP8195O38VRs6TyjoA6xr3fnUSSMOgfLVQKkgGGIOAWEOYpcF4k2gdmt8hPEtBKV3bzoBvq21RSIXkxyX254OYlOK8EsqhBOibV/mUDqIPJ80Yfpu6CooZoiQUAtISnuVEkhISXJoNXRY8nWLuv/ob4+mQr1ZZlBpbQku61EeXfgEjdWenp0Nk1oK94cQTZMiElPe6QhtgUvourH22SUEMnGSXWECMa/QfMzOwO4VawMnST4eQUXYWHuOpiXOnL44xIfTcqEGtVGy7Iu0xRkQJMZMvrkvSYZ8Ejys1q7LeFDgHz4SOhirJ+rXxJzpdOq9XLVl/621fVOmUrrXa78YaQIS0pvwKx6woxVxb9hVuuIG3FRobRhXO0hRKWTzV5hPaxIZuiV7zY+ILgNYs5Awf4pvczMk+szqzcsOJgtNzLadAU0eUNcgmFRKBFpHE60YKGiCXn8FnIkebXxbQy07MlBe8AXzkAfyIA1tMYaCYA3yt6rdtd4vBk6/QR4dUCmmVDXaLSm6xzAkZbOWi0cZ/5WNRassUHenVIWsxJ1QHsPdO58C/sMgD2fh4S6b9nTfYZvTIXx85VLuuP2bCIQwd/Liq08C8s492QJBBtXW0TW16OL6YBhqMWPDbcUg8BRCzF5PZqw9w0cn7qgtBLfnNBHtt6Y53IJ3VE9J9lqnC2OD548PhkjtaDjziwZxwa0tcTHMOTPkmWRxHZ57ieO7tvJ0u3h34owI5HNhw7NiHK4ytBhieo+imF
 UqvIgcxP
 D7OJDVg/Xq+gOYGD77VsJpTAxASLPfvbm8J51VIYNqOACvn5Z3CQ5ivYi8diB9oVc4sgDVbpag5oPw2ZiFfbZC17usDcsX9ZnMe7D4Mv1/HOoZT/f4r+2FP0M0IxOo3usM5yZWhnm9UjfbUyMGGBhn0abWTAv3sHKobMFFTUh3++/+e2c2UWEZIiD1uoGKuzd+g1d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() attempts to use different gfp flags as a way
to optimize allocations. This has been done inline which makes things
harder to read.

Add a helper function to make the code more readable.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 40d4bdcadb6d..8fbf78e8eb67 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
-- 
2.51.1


