Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E5B5C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824756B007B; Wed,  5 Aug 2026 08:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D52D6B0088; Wed,  5 Aug 2026 08:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5956B008A; Wed,  5 Aug 2026 08:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4023C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:50:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFA00140489
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:50:36 +0000 (UTC)
X-FDA: 85067199672.28.DC82DDD
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 43B3540012
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:50:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OFugndUx;
	spf=pass (imf01.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785934235;
	b=e59ezroJ4SLA4Fi7wh5UuC4RK9ysQOqUQUvs+lCV4b12f2t9TED4qqyxGRgcoCkbGxuxvL
	Q0QXIcF625dJrGXHdQKvgTvvHSd8g0i9QU0pMq/RqRcnrXma5IDcBapD0xYd1O71oJjCGl
	VCeN6ewma7SgFX3MZtygzOb/aDb0IXI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OFugndUx;
	spf=pass (imf01.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785934235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BVNKoUyYIF3h0gmseuybz7+MdTC/satf3XbsBQnLJSI=;
	b=poqnW4SHDvMMET+JQVNlFXN/mYLaxd/14IDM5gpE2RsQI64vR+YjAoW4yD9Bz+gwB91HfW
	rVRnv1l0/uau1Yhn6gpibdeOLsnZsrCZDPfgT5bBDJ2hsLxY4OGABUiuDrMXMhT1OAPsg/
	Kz+EGgWxtf9a9hNU8EwUujBb7HFg8m0=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e04df8c46so1123350b3a.2
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 05:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785934233; x=1786539033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BVNKoUyYIF3h0gmseuybz7+MdTC/satf3XbsBQnLJSI=;
        b=OFugndUxxG5G13gjhOmDPkeSHQ4XZBbAiStBjm3GTsWlWca2tSp78+FeudJJDnUUQa
         eDwAJP+1tfMraeH58N+W3/llYISWGVtxnFOG+Q2l8t+1cMeKQMtQZgDQ2T9NU7g/h0Qs
         8W+B9XEaucWayVWaAhfMnVKS80rA03lhO197tKt+ZveP5FBVJrqHAmtLkHtBuR0DDHl5
         0bgEdKCdj6QG+ifmv2NRvKnG4j9pVkYD/Ie61JlF6JT3/5xBnKoX9cXp1sHdCnFK345D
         KOMBNLtPv4gm90Lm1q08/Ukhcbc1aMvOazZ7nihOOolcSI2wNJkAydc5cUCFRZcLhao7
         dH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785934233; x=1786539033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BVNKoUyYIF3h0gmseuybz7+MdTC/satf3XbsBQnLJSI=;
        b=GupewFypwlECXEh4hm9Rc99L+OgALv6ZpFgsddZ4nCnwPmC0tN3kdPong2n1KguQ58
         59MHxvw4aCrUXSL083pGO+qTkvJMS1E0qfsAJ70C92nTqn7DjfwgH/IK0QQludfU3t0Q
         81SAfn2mjOxbGyWm82JdjdEiAAVdMzI//u+hYoXyJ+eHboi+5Bd3KBQUeEfEgh9v7kwR
         RuN3E8t3lp+avJzLUl7BboYsGzpbZTnCCFBU98f5HAz1VbBWHe3jZVnZCQRuBaUX/LA6
         rpExfDH5k/o8VbAJ4uwfppc8K/wepjt0fQpKriJ/+x1RT5rm+F0x41hXFwN+WClz/faC
         q1GA==
X-Forwarded-Encrypted: i=1; AHgh+RqAefYVQOQ5f6vwQu3PbFJTBf9aGVq6ucOYSrKFF5BohlPYWT4tUHmFxJKVw7PKx/OOuTfKhK3+Nw==@kvack.org
X-Gm-Message-State: AOJu0YzIbjAjTBtNgZ7X1ABz5AVy9oftfcarKcx87GOI3yrSiN/rkpDS
	AdLK8ak04vJcOsnJrE0KtB2vNMsIFXxkyOevFiBSzP4ZDcypE5dl5K/PvQddY37xelU=
X-Gm-Gg: AR+sD12OMH0L2k+v4dr7vAdkdUvJrdLwRI0YNdQPGk93mkkzI8r+54yNp7Zujzc+k0Y
	t5wMU1st+W4Zbt4gnl/xmFMvfmWsqs5o/J8Lof2wJUMz6h+F8zPPahLTV3SSl1FtgwBBdX10ita
	vsKXJbkEms1LG3U/vzduBshZPkbP1YI/f9NhmwzfXyojNUAu8Kf/o3zUd5LvaM7fcyMu/kadRIc
	20cxxclDfh24nDV0kdyE+xGlf+zBIYLbPMyOzr3F4vsFsDsmgKlyKqgIevszZaICWseAJfDbEGs
	ajwlf+52Spk9HUcc9+PJQl2VQ8mNSMflTIsKJJJD60uJHCaK4gySByNBcv6kXdPpFxkI8J83e+y
	+v+JOLZUGQuyNvKwbZRmlfpxRrClB6Eu5IKC4iRdi6Uw19qKwEfdANVtNNu2G7fZWgaxYnfE6G9
	JxOLe4oAEoCoAf/ONQXMEWh0OdMnrGbATCINd8/A5hguCtga+R0mOz/s5cVuWqw71fsJXkuwQBh
	KQmhzBJdAyOuwaJ7yTLYM7gCg8=
X-Received: by 2002:a05:6a00:298d:b0:84e:7ec:aa42 with SMTP id d2e1a72fcca58-84f2dfb511emr8027091b3a.10.1785934232776;
        Wed, 05 Aug 2026 05:50:32 -0700 (PDT)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f2e2e3089sm794446b3a.19.2026.08.05.05.50.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Aug 2026 05:50:32 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	00moses.alexander00@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Yunhui Cui <cuiyunhui@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/madvise: avoid skipping pages after splitting large folios
Date: Wed,  5 Aug 2026 20:49:57 +0800
Message-Id: <20260805124957.91325-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43B3540012
X-Stat-Signature: z7w147g1d46n1meozb4r8w16q3rg6mxs
X-Rspam-User: 
X-HE-Tag: 1785934234-355728
X-HE-Meta: U2FsdGVkX19bHZWZTvZHXYp5E3v/YDauwGFr2ToQ5IwxxQV+24pKqdddQdVULQ3GdrIaem3828Jia3cfdZuneHCDnfAxraDj4ecM6cofA5j6cQ7hduLHUbfQv9/l5Kjgv/+2tL58kWya1y3jZ/BoN7vVCluGLXgIGaFKoPMPi9WKrbaAs2bzo+hUhILlN2A5GdGWQuW8yAKR36h1a5MIeyinOjAQNCqN5Y3db249cvb/4nsPbj4YFZiFH+l5feFBa6B4k0il9sI6DgKFw8aBF8bFODt/4LlKYV6FA7+Z1WbAk/OnwfLSe8pdZQ/mk+qTGTHrja+QpcxF66CiBpR40RUBlkBnaz4QkP8MHltXuJEDeNiWtrA0oMfBj82BkgOzQaDCHUJAFGwOVTa0v0h6lmiMCmtuPBZg1zAwlLQCyqoVAqAh1VwYktC4TGDH0A08fhOgKsPbCcRIBtpTjQEurMXYX+kVhQWAioeJmFoCQnxUZ9JEjE4y3+qjkMe5zk0E1KcZHzlyrrA+EBkGpx19k8jA9AGxaTxpYP9PccO89SxP6DAH5ulEhW5JV3pPTh9RXCFcrzDQtfUMA5qFqvXvLttwcSf0pij18le3d/OpMhkbCrIkhkwQjDu+ZXCycBAQb0rQD4dZ+21EErjFndT8+jdiz0W3zEdq5DsHeco9zkTW2bhGscW5PNOcmyuqY+I1CI0oT0a1LpZOBZ1gnQfGlV8l/NOUay1KIbpxrYP5A1t19KmCtxh1TN5Gg0GJhOUBKfhwdIRex9lPBwTztH3PuQ4J4jqPvVyGN2WiFpQ+BdINOS+IZHWy4i3GGLrrI5Scv7ebzMhzQjinvSvxamnc9pWDvrjZR/5uPJdvBlwkNP/MczjiB+pu90e7da15hHmWqxhVrbvbrYxjJLUct+Dzlr/FtHteRHcMsJzpmbZ87C1s4PL35FLeawJH13MQj4znKSVdKogB0NsTzzyQD+R
 UZBe9kdk
 fLJKWf1MqZ8aLjMcwl/YN1OYOgpZ5URz6xT4KMILqx0j9DokcGwTpfkDVs4L0L1kFA9hLL9+cbBteX1L9gdlR5Eqrs6/SXmNBgERaZxBgdqwRpzGwHdEFFBNTNxEnSugIj5dixwMejppoARcUfFJMu2PMNIxeJXuc3Arv9m+/z7h4LkzhQvW7cgHrgQZVyEXj78XBzplp7lg5bvDtQwA1btTkLgK3DJAUk0qzXcnzDP8agPhutFUK+8nO9UjB9AYUtyVTXgt5idKb1Msn2jQoD1GDGnyVfK/w6QfFug2xNYsUa397r9YEWa3t+KTK5SbbJeatE++07ilgvOsgg2ms7iY0dUbkFdsjk+QbpVhex+2vW7M9dxNrze54zWtgf6hk3phvfzsVveoD1z6m8rYQCK8CIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_inject_error() advances through the requested range using the
size of the page returned by get_user_pages_fast(). Saving the size
before error injection is required for hugetlb pages because successful
soft offlining can dissolve the source huge page.

That stride is incorrect for non-hugetlb large folios. The memory
failure handlers split such a folio and handle only the base page for
the supplied PFN. Advancing by the pre-split folio size then skips the
remaining pages in the requested range while madvise() still reports
success.

Advance by PAGE_SIZE for non-hugetlb pages and retain the whole-page
stride for hugetlb pages.

Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page order before page migration")
Cc: stable@vger.kernel.org
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 mm/madvise.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad4..f37abed29445b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1464,11 +1464,12 @@ static int madvise_inject_error(struct madvise_behavior *madv_behavior)
 		pfn = page_to_pfn(page);
 
 		/*
-		 * When soft offlining hugepages, after migrating the page
-		 * we dissolve it, therefore in the second loop "page" will
-		 * no longer be a compound page.
+		 * Non-hugetlb large folios are split and only the addressed
+		 * base page is handled. Hugetlb folios are handled as a
+		 * whole and may be dissolved, so save their size beforehand.
 		 */
-		size = page_size(compound_head(page));
+		size = PageHuge(page) ?
+			page_size(compound_head(page)) : PAGE_SIZE;
 
 		if (madv_behavior->behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
-- 
2.39.5


