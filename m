Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0168FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 05:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B156B0005; Wed, 29 Apr 2026 01:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC4C6B008A; Wed, 29 Apr 2026 01:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CC16B008C; Wed, 29 Apr 2026 01:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCF916B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 01:11:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3F1790BF9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:08:52 +0000 (UTC)
X-FDA: 84710413704.07.B621465
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id ECA8F100012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:08:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EcU93Xfp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777439331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ww2pUFS7rJW1E+vOJDp8g0tsuClfaGd6tB53Co4DkAw=;
	b=XZM3HVOshcUI/SOOdQBgKNzY6rBL65uGpY00fD/6FU/k9aBYwIWX+fbknYT1X1GXZ44YgF
	oc6hcYFAuB8DEwFfjUNQBBcn1ppKU0npmxy3vrPa7B8IR7fxTE2msbMfPLs+wXBwGBPQ6T
	XYVz3omZzAdHyl3+Xhoj33L4d7atUaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777439331; a=rsa-sha256;
	cv=none;
	b=SIoYuIPBrCYhxF+mBevrSyzTQ5DnTy9wDRyDZEQOLb3KFVH/ZqtOraqdNG6OZLGUoaQIvp
	2XyaFfcNVXdrbzVV0HPIQerwros0xzjtQdDILnIS2bBeXLlF2ZiCJ+Y025uTlYLxMtK57T
	yI6ZR8ef3pqJXnRdUYFbXao9PQ0bg0Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EcU93Xfp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79ab5fd969aso138003957b3.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777439330; x=1778044130; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ww2pUFS7rJW1E+vOJDp8g0tsuClfaGd6tB53Co4DkAw=;
        b=EcU93Xfp1YlaCPcgK/bXUMbRHlwHGzlIhm1q7YPhuBvJTYj7n6aFQL3D/3bfB+vWwZ
         tWkDWZyX0+bZLcpPRE9QRcsVekod6BrahfvlYPZnxbDoLQ9KFbGkBR5l5fHg2b1Wsb9h
         amtVBR6e5dAV3KrDTEhvgUNGcCVVMLSL0TNYMcAMtIvT983756vZErdddKsDNkXumIR4
         wsmiQxV9+F3FoFpWW37PJzP177Up+Xek805SXpDGWTsqxyFfLa2xLNBLfoNr00I6bDgl
         62R270+hef6mGOr1tFdhi/0iQgq4RZdYOGVM9IvynPavF+xszAp0ejAgxXtgaTPiyDzE
         pumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777439330; x=1778044130;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ww2pUFS7rJW1E+vOJDp8g0tsuClfaGd6tB53Co4DkAw=;
        b=Mgl3xHwSOmZFtvyl2DOzDWZv54EQBzyVInV4OIiuy/p0T5CBKPI8qyZuhtUGCQ2xbc
         SRwUjC0qJGMSOZTUxUMAgR2qpVy+Mwg1F++CW1ycgnB4a1+/HBmILFETPTXNAhDo0oFp
         LS76hFW2eunwk95ktEtWdPE2lsIinYMFHjVM4MTOxhsJHApkWLhvAgbUv4mn1pqfMXT5
         GtwrOzNNQRWc02PjBbelzREtV40dG1SuMSpN9KvEWKmcVKHhy7H2X3Egpmvrzg/kEbyT
         a8Ou0zR2f2XxIvMQ/4VPCKEP3nU1uhqtuHrUkr0Ux4hI1WkqbB412hpX7e96oNQSIDO9
         cfbw==
X-Forwarded-Encrypted: i=1; AFNElJ8X6tEIh+b4fGOeKCFA8/0FI6zV24glZKPAUvPnElRpB+BkOZxnDa/00zg5M/q1OGOWhosrwD3fXw==@kvack.org
X-Gm-Message-State: AOJu0Yyt8ktMXLLadu2Mkje/4J59hsqBi9FiYNeArTglm+Hh+pREol8c
	zQqu4cI2O0qKVW3vBveFZ6fFkpPfOebAI0B5BxZHyqc/LyyPQboiOapdMeVF6yya6A==
X-Gm-Gg: AeBDiet9yt7BRisEZAw5oUe3+pupQ/b3uiyygsvPU5xkJd6xEC/yPnqg6pBie/zO1cA
	FoD9Yv6U5n0PWX8Vu0OG19U5zCnYXnsnaeiqT/cBYdazu5GRCk8Vhr2kua84D/I0pgZg0w5kL9W
	02unpPCc8/RJEmHqvPUjm+9I3+qTNq3d1zGE6tQlyzBzgRFu9KWHPma+pSpwY/K3QKU79/ZqQNv
	otp4z+i43pnhPrq4ROWstLmxFhagpvXERwIz2TXKOw2uxknX0UiNvM3yuF7xIKlWXa+DKjhtEHU
	0Kx4Wt2bw7ecNySw+ybsoOCHeGCeslANdSOMWDgg/LnxNdRgtuin/85EQbmY4Rf3ShnSycvyix2
	gc3TSiHG34D2lIqAk08zdP9hGoURJCGPOZdOJDgM6xWGzOhRhSukXsyUZfHnkIceIJBmel+m/I4
	3umENh4Bm2xGem7Mo31hXwtUBeiTRQ+BM4go2xI5RqVZbvMqsT5xTD8peccyJQl1inKIytQ/Rue
	S2SThoqVdDiAZNvDXE+YOii6pZifI9C
X-Received: by 2002:a05:690c:e3ed:b0:7b8:4438:f005 with SMTP id 00721157ae682-7bcf547ee4amr59622067b3.23.1777439329411;
        Tue, 28 Apr 2026 22:08:49 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd258a30cdsm10740717b3.23.2026.04.28.22.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 22:08:48 -0700 (PDT)
Date: Tue, 28 Apr 2026 22:08:37 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>, 
    Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
    Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
    Nico Pache <npache@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, 
    Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-mm@kvack.org
Subject: [PATCH hotfix] mm: fix pmd_special() fallback to observe huge_zero
Message-ID: <74a75b59-2e13-3985-ee99-d5521f39df2a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ECA8F100012
X-Stat-Signature: qg485xyzy99p478e93jwhod7n167bj7i
X-Rspam-User: 
X-HE-Tag: 1777439330-558045
X-HE-Meta: U2FsdGVkX1+s9swJFOIS+i7qjs+nlgI+qwBmq4EPTATikid95zCRKlvTMh/WX3pWz81HrVGUTPdm1VauKuipjR7jL8DI0BQEqoD+KxL8LucUaTYIy6VhRAIhwu63tQUpLYEHMrXfzoymNZIiYvNm3s0xv8bRlDx3FnPe2udHIPtrSvTy5qc0/eoOOtzkFNcl1xuFz4wk7pMMALc9VZ5umOk/ugI7WcqiIiJzBJh4TpmCHwuQr6fnaPve6uSqDoVkU2w5CRS5soCGUPfCHjFXfNzPGEwpFqfv5KeWNRLcjHMk8kvPAbs7U1z7NTJf+we1xo1kSghh3/9lB0ejPDYgPeqtMIvUqzF4LRdAXi9rpfDiquCAH3htg6OOPU3mhk2w2WM9mR/WeZdGA/ulK8ytnc2gKMN0xgagUjpfxKJEYff7aIDYMyfXwGKLb2VzFc452i0iGSab+uBPILnlGZNdc6qoOj4xzyZ2IadeLeF1t78hnTPsi7h2kWHZbBQUy1l3rxFOyatzlwUKK4mMr7dc/2e6T6xC8W2+BjWZttPx14O5bK5X8GBFdBWofEplrmiQn+YFr0RgJ51+uW780BvuZPd7xj5f1uwEE+sQdLg2mm1zm2Lubfdo6w8aERhSZkWRcEeXVVK+T8BqCBPQjWuuzr9LPqFS/sPVSlvXHRjFHlNnkweOL0rpx2oXoL1TOv8tigvPamINLbZ32HEzv40lxdkPTpM7drQh49KxaOuF/sbAlODnTOc3qddF6nzeeIHfn8JfZkJQhTEnoEBqdNpgAlKT19DZ+Ckw6DOQvCf/AopnYQKVHYNqxwL26lVpi0PG+IgdI/yomZ9+917/jDG+UT2LJl9gJPcu3xlA8/ZI4a+XAsIDE6y0DPJngS37WS/+hqTPeQFaFJD/D856kIJEu5zpw7P8MYOzRzrxoyAQhHlFI5jNWnQc0kG6xnhs5rBCzOduc1uBGJ/vuWaMGHF
 9YW4ac9+
 I358Ra4c6do9ORAg7EeXstlXlqKgkHP1y9PduvFiZsNAoxiD3C8BqvwA5juTQ2JM1p5oZ7oLO7WWDwnwOLmOWza85oqEIhEb9p7UTM7DuVRYuGOMCIzGHwGFAwxEc36/DjUOD0Sr66PA2EXeDk8JuTsEgVYpORacxXEIenl2+w9yM34+fR2dZe54ORI2zmmwmFgh4QN4tEach9+J1QkcqQzIkb79MhTGwv/24Ym7lhagR9zclWCTCc6jlEILE7oVguaLCJvgF1HOJHhYYoxvoCa6aZel8YNAsdzNuYttxMLXEPJ+ymNTYuyDEipdW2clYlif8aZQGMMB9Oi4fqib4eST1+Td5ygqTcP43khp3s4PsbA+n+x4tgtQ/5OEmKSWqIuizEQE7yvlccZWKJixI+J1WVRzzz/wQrn5bJ4B0AHHsAdRUzSigC/BEEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
"WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
when reclaim gets to call shrink_huge_zero_folio_scan().

It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
and indeed, whereas pte_special() and pte_mkspecial() are subject to a
dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
on any 32-bit architecture.

Add CONFIG_ARCH_HAS_PMD_SPECIAL?  Perhaps; but I think it's better just
to observe the huge_zero pmd in the fallback version of pmd_special().

Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..3b02ac43bcb7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3422,7 +3422,7 @@ static inline pte_t pte_mkspecial(pte_t pte)
 #ifndef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 static inline bool pmd_special(pmd_t pmd)
 {
-	return false;
+	return is_huge_zero_pmd(pmd);
 }
 
 static inline pmd_t pmd_mkspecial(pmd_t pmd)
-- 
2.51.0

