Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5888F99342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC006B0099; Thu, 23 Apr 2026 03:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CDD6B009B; Thu, 23 Apr 2026 03:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C0E6B009D; Thu, 23 Apr 2026 03:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE6F96B0099
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 609911B818B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:55 +0000 (UTC)
X-FDA: 84688971150.02.D650F35
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 61695180005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bn1Fsfl2;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V18KNwF7QBH5+p7vjE1eHKkHO/d1EPWETOYBsNfjQo=;
	b=QbfpzwVHHiuYK8elMuPePYgjZGqoiZq0pPynVE4jo62eVhrQWzN5+vCl4wPtXg9fb8qhdK
	O7JPyLr04vhGHJnS/gpQBZ0NDC0FyjsX4HSkWPLdrCLpMVaU0FheD2KjbASkz6mnQOcVO+
	xIn8AwGObU1MIl8NDwA5D9CxlISc768=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928793; a=rsa-sha256;
	cv=none;
	b=Wn9n6GQXA7Nooe05eySvSEjX5lcJ81/vYzNOdLERX5RyibwNyhNaXKFSVxgQ5eAd6O4ei2
	QIIMb3bLisSSDs4GJpJpe76ONz8Nz50B5FKUG6+Yv5FxZu1HEWSABP4yXR1xsRo+B3xAou
	dklp/UTU17Jc/3MZvZE0CIsHcC69+Yo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bn1Fsfl2;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35fb7c1a455so2510361a91.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928792; x=1777533592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+V18KNwF7QBH5+p7vjE1eHKkHO/d1EPWETOYBsNfjQo=;
        b=Bn1Fsfl22SKMLdgBssJYcF3Xui45ixeJE/AQCTVkyb1/zg/byDHgSDnUvw7saKeDHz
         PXwZY+00JDRn7/aGN2ua4VYoRSLdBLOc+xD+voQUQuI8g3q1vTo0dzm8PT26BRRfae4z
         0I2b+VstYVMkTxmLYoEd+qJqlEHd100hDdQaB4L3lXazSxBDtYFisVl11O+o4joCLJyy
         /nKflFFl7WKlEE5VVqtNBSGoDgXB4nwTM2+YioK8/lRXs1tDWGrjnQWl58a8EAutSNxb
         jjVn+Di/O7gpO3mbHME8AwwXRAQhA96Z0ke+N/rUBcR2KSulbzDO43h9cuG4sO5iGadj
         7EoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928792; x=1777533592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+V18KNwF7QBH5+p7vjE1eHKkHO/d1EPWETOYBsNfjQo=;
        b=BM62viAujzxjkS5PeZr7NptmM/JVKqeONC8BvptSGur+VTV3QtJoT6BltYQqDv84Iz
         MCTgFFYHpymh3HE02uAp3eX1R8V6SZY5PNFfQZq408zzCCdw241BGKCRrCJKRIX3h4We
         BoiMZaCzMJ5qK3gdQRpxlRpRTHQF3yktpJdj3am65FyfjgG+nqNHgQ38/WOFkz6atYzW
         HafeErNTc6RA8OovXdUXetvBdsRBKPRANJ63zGeh+44Rp7jd0fURuxlvaEcrOpJBRO1J
         rxRcoZyBWKUgx/TUsIqE1+5EuTJ012clci2m7XXDz90Tr0MyhuQZGrVYIafD4Gvjlg4e
         APaA==
X-Forwarded-Encrypted: i=1; AFNElJ+AjXTg+tinI8FvvY1/hmErpbVgOyxMvHv/TL0p2q/QceamBXweRbLPSpo9ozOLJ+yJSt4epRh1fg==@kvack.org
X-Gm-Message-State: AOJu0Yz1MLHWMtbYA3dXa5iBO47qmKBkf1sTBBvmN571qWQBsOXm+siK
	yuzGNdpvHUiJPhRN+jZK8XrH3o+rNdYTFaQfSV7Z+CV/qhkNHmTDCFHcVOazZL8D8uk=
X-Gm-Gg: AeBDievn6LKPGwBKDKD6vPS6LFn3Tm46V6WeYjH/rhKdyy1Zv8Zb39nboaVpErpgtGh
	3iqtugV/9FF3L8H0r9akrsU4DoXR7+LeVjFYUHuD+KswXI4oQV3UP0avpSqDHR+QB7Ff/ZDOYnh
	1DgbYX3YdNJVrGSbhmp5+WbrTa3J9T3d5cR3+9spANoG0a+3FyBeECUgAwMc2ullBlWewqefU0w
	RbOyyaJ3RzGpIiqrFX5OSHHZLoVqzdxMQ7cqkOMl3EsKt0ckyJ0GakXcp7K++XcKqY912Kl/n06
	nAvM0ybI8ke29npQCYolVKl5wl8o+pB2cW1b1frTdc3S2V+Ow+nScPOD1ZwRzF1EUYSLyU5tPtc
	Muo9oJjbecUqkP5cYdkzS1Bs7XF73tPXhOXhxb6yyQaIyRGVNJl9LfZ5aSnHF3Vsr2AMxZSCn8n
	fSGuX7zba+eu2PWiDb/MG7gQPaaVWKRl1NSOW33BGf/2VeGXTGPd2k/Q==
X-Received: by 2002:a17:90a:d40d:b0:35b:e5ce:73bb with SMTP id 98e67ed59e1d1-361403d61d5mr25963174a91.1.1776928792148;
        Thu, 23 Apr 2026 00:19:52 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:51 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 v5 6/6] mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
Date: Thu, 23 Apr 2026 15:19:11 +0800
Message-Id: <20260423071911.1962859-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260423071911.1962859-1-songmuchun@bytedance.com>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nomfjwiddu99ahqcgiswrj3466jb4fn1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61695180005
X-Rspam-User: 
X-HE-Tag: 1776928793-36224
X-HE-Meta: U2FsdGVkX19eyjo38qWymVL03AsmAyOj4DzL2aR9PwzvRtYGtbPSjWAsTNwIBf0C1qEE9KH06aCPamXvklpS2xTfM5ocxE2V4P5WJEZtCP1Us1XQ5ySIjn0/ezE1z1K27ZCfC+HC6mk+99hfQUdd0YsrOv7ktP+GF/oKzj2qlqlSrG7RkQ6V3+U87aqZqYoCZL28dalYDtcyiYKw0FaupOmATySd9eEyJjB/OLyFUBnjiCy1TYWWzBqmUv9Nvb30FYiQ1rVZ0Sups88HmqB4Rl2D99P5CqWJIvqJEMrFvWMrOpW55m4KBAb+E0mqErgmkH9EBV2UryeWQ/wuIJ99KqhM5L1zSsgdBeCxKR/knOL4Wj2XsCyFqGqhsJvAS+XD5LNJoQdC5zGpycVli51Ca9fOGkvbqxj5v2j1wjc8/BuVC2HGuQO8Uka1OqXxIJ7nhQrBfSySI7KhyZpd8siJV/2EIJoMszaNmNswUDKGVrOC3EPdkQDP2IkiAeu5Pax4uGIj1pNIT1GfhtcSWMmZ+18sB/zwpAbKfh/VPec3y+oJP6e+Wm4b/egZrDyGoS2qQKIB3oytkn4TmDCmUmU1Zz4J+yVYRvjJ6VB1CfUZ52m5iEGD4RjBEDQuWYnIZ58xc4JvJAh1B2LzEWfMKI3Y4catKa/nLN8koUaeLFZl3XGTyeDyThv9qWR3vO4WstzIv0Bnv15I5fdROnonzZ87NwhZYkNdwWyl4twzDv7DQ13p2oL4IjgI+/Zn0cXyWrxNcYBILe7f3kp+wiU+ZJcvK5aP9tcl/RC+DfwXDBdSQZZbQ3dZwAVfXXP5KyTQ/hnRCQ4ufXtXyXtyf6R2qIIdyViE2/jNCuRnLlWGZFqb9fiUBEHIGAsFEV8Ghz2JEBHtWMbiUdvW5a34R6igiFs5MgUb+6pJl1uy2Yju46Z5T+7LH4pxDR65Hlj5gIQhEWfNx6BHTtORZHVw3rZpxSX
 rkHDlT3/
 zNFevkawE7ode3LdzYgqiLfUMl80NqNAXvCI9mVZyWkFuoBpNscv++VMS5VwrP7/bmqA2id83yrR5xi7WnP0IIoaUisB638w+NIwCEXfmiDZVbUCzCIyguz8RUTGFqUrKWQ+7DO9f6m/Jpi3/I3lx+QsxwQcyxiEsMnJoi7qmyd2MGhqDxKDUK2bw0NjQjtRgrrHePNrfHg5EbNKvlCjaiyYViMbcH8yWlpAEOr26SGliKMoqhhKUi2/o1YbREhSKRzDnfOcFpLdkCxD1DY/EASwry7ZlIAeLPxECJeVcRthD6za1MdJbhBpenGgvEGpOTzDlntdYDYPXAZlXubd5SGPkAhxtPWytXVvSW29sRTqn6pu0tkXQf+WxqXOp4qtSbi+1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mm_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index cfc76953e249..bd466a3c10c8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1


