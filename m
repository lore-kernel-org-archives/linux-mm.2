Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667B8CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6946B00C0; Tue,  2 Jun 2026 06:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86DA6B00C1; Tue,  2 Jun 2026 06:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76086B00C2; Tue,  2 Jun 2026 06:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A39916B00C0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CEC7A089E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:19 +0000 (UTC)
X-FDA: 84834555078.30.F7C2277
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id E6DE580011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ihu2xgC+;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Btf8iCCXb7pZCMHTCvc15KHxJTAr77nR7rRKFiPgBRM=;
	b=H82l1+4QWku6eL2KQYQJMRQh6C2BTfnWaMenyQlEbYO5YUXZeK/ZE2tv8237iFBVQLJ4iL
	tnSlA+vWE0FMPMs6WSh7eduO5FzqKcDhZfGYqVfaIcibG2GXfzAQ8bhETZaSaB1aVvEZHf
	p3hLS0/jnQlGYmTT4JSvHt3EUX0C3vc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ihu2xgC+;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395077;
	b=0Z+B/B0tQpHAC4pQ9fmxfV45gWy5/uRhjp9Ml89+N1s50pglsI/VyX9+W0tSJINE3vAB63
	Smjzg6f8XBGE4ecP9YfXKMjqy03RGFsAlQLgP8s7+Q9XrWWnasd+Lh1wF4ibjivWwyb5GQ
	Gi1Y3ABNkKA3ODEcGpmcWiemtwWsNPQ=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8423efd76c8so1439257b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395076; x=1780999876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Btf8iCCXb7pZCMHTCvc15KHxJTAr77nR7rRKFiPgBRM=;
        b=ihu2xgC+k4wyMSYYgYIJd3Dx5wKvn6np8lf4gpCu3y35rpXFVH3s5vsn3YUxTFCWrM
         fQWRLr8HHML7CwYM7q5vKu/W7okrabLXj2taz3D1Ott+zaLhLlnwilUiOZOplzZ0gEIE
         4zqEVLW+Lpoi/VU0BAC1jYRpQIxjWSovOoHK+0uJ+QwpdW7xLpOd28oL10sqhYZntSg1
         yALbt9AsPO7Epj+DwBcat/Rnto82tt4oVDq5IT0kiFOOD/MbNHCSTcK2wEqkSyX95+tL
         X+5OfBGQHyg75Kfi4aCAse02yRTxVpon8yehkdcyLcmw6t0ik4RLEzCSFeSwDWdxXtpS
         e5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395076; x=1780999876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Btf8iCCXb7pZCMHTCvc15KHxJTAr77nR7rRKFiPgBRM=;
        b=MuUInREH1eg1CywZ1rgRg/oNLw2P6WzEJw0LOPNQa+lEtg/JwajxFc7v2AATp5PzGc
         ZZvLUJtm2n61maNQxQO+88nAsu+qAWnCJEc+URvN2WB7VhciXLwPvEc8QoJUnkotD4uk
         2ht019VKIBhmif/34y7y/pKksJ52jR1+3OLgZUQFcf+GcEh2RigwzOGqkOPRfdZkfqka
         GB1qVwX4iGD8b4hLzwOvYvpO7bYoGFRP9MKrJnlSaxYh0iqmzTrK4+kv4RL0aK56soe9
         X74nKNEJlsoIczK/QKNYbsZz5j2dg1g1Hj8l2xjBEm8FFFUNjzIzh6rpU5EuGzn54uiP
         s3rw==
X-Forwarded-Encrypted: i=1; AFNElJ9XGgG8i498HMmC59b6Q15DJdqVJtQn3+qj60N9/j2pYrMsp3EwEbMSZGAuKddXvH/0P3MIL9wLKQ==@kvack.org
X-Gm-Message-State: AOJu0YwxzZRl0/IwekTnOhK/6rAiKfewFJI8Zw6AA288V2lnT1S8jyin
	0CUGoHpEuUCWe+SxX1UC4HEGjtboT+90xGl4xf63kAvrDfAZQl4+8+4UAw9jBihmF/w=
X-Gm-Gg: Acq92OG8cx3IqAHOBocsrNYYzG7SIM1Ob69agHG36X4Te8dRMzMFPik22b/fqKem1dW
	CKacaZiROrFsIJiRs1eQPNPRjyaQ4yPmswYtSL0o0meoMWXZKvRCayiDMecT6x4akH4o8ho3SWQ
	H/PghGgBywWtOwGvfByj9iQ2zTonpoDX77Ha3NggD2K8ExuKBCGG0WVnXxUj4tjk3sE9t2HSd7/
	vFf29NFt/JCguh5YYziAp8RyN08CPTjdQCx+6pdZFdtShETTAV7hoxcXsEtugBslKJsN9HJqiZ/
	LartLKBE8ddpMGfo9+BJ3mlYClkl7pqXFHSnR2q5qLwDjtfeGmRF4mObdQ3BBZwHLQveoCiUNNw
	IEs1B6oa+V3u7LBCnIdltQN5WTgHw1X8QDV1bkPyi1/xwJVVgErMslyE1DPaOmSjSbnPVC1QYD8
	qvrd6al6UMkPhHfFRgmYSnr11ouALbFW/mW7E+5TrTyZEoDvzEhRHUECg=
X-Received: by 2002:a05:6a00:3e0f:b0:842:4f49:71bc with SMTP id d2e1a72fcca58-8424f4972femr8017729b3a.46.1780395075647;
        Tue, 02 Jun 2026 03:11:15 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:15 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 05/19] mm/mm_init: Simplify deferred_free_pages() migratetype init
Date: Tue,  2 Jun 2026 18:10:25 +0800
Message-ID: <20260602101039.1867613-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E6DE580011
X-Stat-Signature: yt6bqu8dpy5kqq7zw5yjjsomupq4bh1y
X-Rspam-User: 
X-HE-Tag: 1780395076-940235
X-HE-Meta: U2FsdGVkX19i1pLYhSa1s/S6Ke/gCbqV7djzkeidCscsR16HvW/GpbdYC4cOg53CqzcgMyiRy12MPTpV7j7ersfvg6HtH8wtUOlhQuKL2nuu/gPJvcUiQGziY2PJKO+CLcKOBrfAj+d+vvPfXt2tJcCrMVpEFpU2/3stfPzkBReICP8VfgOq0ux8tjpD7esapwT3gLTopPLLleYXTTjRCBbYBd4Ap3IhCTwT1996OgJaQeZPhojk3nH368+ojXaV4UDlwNYFR/64kjaoCM1jaNZIsazd1VaZVeu+iiuhYB6hwFqUJuPwV9gSXNEBt0fcYzFL/G/MvoHK+VPeX84p4Y1x2gr0LMNdAzN7+4cwyQUn9hNpDJQR+V5QluEhZNlvJUiyjL2CWEqL774wgkr8rtrgI1nr9uq25d83AcZ3EeUDAqsWmkAUyPPNiHh4nItEC3OQzaSBF6WDQC/v4UbJZnToAwWByYse6No1OkehWr2HGXBL6Rh3I2rlCsuEb0LocgHP0wbkqFObjcbcXg+tLTi/bsY9eXea1pSuiqWpalAiUOQoJ0KEYTF5dW6h0G2G+yA+R34vWZSuoxjQwuXjF0Io02VOCh5L4pxXQCi5OigxmfXsyHgjOleQ4H12OmMtjvJQusd/ifXFIiCD9KzFS3D9z43LGQAzUyIwcxV6n9M1gv68SpZDryfxcEEDe3uaTLTp//MZiFpBVb2iAv/q7R7AS+ZxEJOxGFa3v2f48inYJjRaI0vk6rBgPzr5g1vdllx/EqoXvgWRM3iGpj2w+63s/6+1R8cNvQVM/mVw3jYkcETDK0JtHZ0z4OLsnOWN10IhtZwpjxowngDl0RJK285RcakeRVCrGvuKKjNngjc8EqLcY1XanQD6xqqfoeqxDZuEb+yo+Fa7uIjKanAzA+XNe8hYfgJYO5c6uurhWnHMhAOpLYBURFCAK1sxl3chUJF4Tco5wITD8PgspU2
 +RTuqH+/
 PUKO/7wtTVd4lSvxvtMOM/NsI5FTY1VKOxk0kWLAHZ+IhQ0BLG7gDUz1syNGXBIsUd7nbeCzOmc3AbDgTIAO8OTaluWH5JaBHIt0gnbPANUg+ba9nBF4MKGibYa6MHIoVQ4S/xEj4mdKZxld9Z7EVnYxuDNpUdI8ckOdOKADUSt4YXHct3UpGYbvgGfef+kKC3ev2tnI0RGVsPdxvUdSjorU7oUVLgAEQa7vyUnKXeMEIJ9FWmpglvGUrWVNfGbLlF5GsEdp06wiRnYBwq628te1aw3yZ11q+8t/pTxSIHaSNPI5Ub0+vFZLqd5mkv1CPk36D0QWp7E/P1q79I42olw4byO7KI5rWndYiXhWip9zAipkANT0VujN5Xaek49m5d/xcNhJprz1kctYqcGpM/u3ghsKfCnh2UJDzzITrfxos/Tsh1jUV/sEN0iALk1Oq2SZJNJ3lC0ooDeDYGSw206o1Fkx60jCxE7EjfC3HpdDH+hcQ/rySMGJCh6z1TGFVWUwbJPg5RgVqaRpGpomObB6Ek7xF8qij/GpW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

deferred_free_pages() open-codes two loops to initialize the pageblock
migratetype for a range of pages.

Replace them with pageblock_migratetype_init_range() to remove the
duplication and make the code clearer (Note that deferred_free_pages()
may be called from atomic context).

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- collect Acked-by from Oscar Salvador
---
 mm/mm_init.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1890bda948b8..be652b6990a2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,15 +674,15 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_ZONE_DEVICE
+#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype)
+		unsigned long nr_pages, int migratetype, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
@@ -1142,7 +1142,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1996,12 +1996,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2009,11 +2009,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
-- 
2.54.0


