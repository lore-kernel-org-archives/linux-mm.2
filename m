Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9FA0FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BEFD6B0088; Mon, 27 Apr 2026 11:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496746B008A; Mon, 27 Apr 2026 11:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3646B0096; Mon, 27 Apr 2026 11:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1B86B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:36:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC58B93B7B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:43 +0000 (UTC)
X-FDA: 84704735766.16.42D8133
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 540F81C0022
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pHbEkGn1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3S4LvaQgKCGQCTFD+IKVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3S4LvaQgKCGQCTFD+IKVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fih3i4e18PfvVXsOqO+51UGmMLaCoh2lR+Igb4mepcc=;
	b=VY/S4ZUvoql8I09XgVkAHHl7qNEbtQeZpkLEQ6kppd8SUNPK6MvXUsbba7owNtq6mkJyBS
	YzFGML/7chUlWyVIKawATCe6qMd5oZdN2ZGjY5F8UePuYTp1yhKzO84DdzeLwzbv6Q8EYm
	excoRMuJt7PkFOAYmW/QMVCegFcHUMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304141; a=rsa-sha256;
	cv=none;
	b=PndwlC0AaTlYvr/1h3ThylXhhhXmr+sdflBd1PtIYSKA32og34qJtKKFkrHiginBkMGNFy
	Y87ya8RYLnZfEdyUXd6F6pjXxZfU6S3eeDBwZbVhDlnQ68SoxC5eYJFR7So1+2KVb07dIA
	KE/MyDp4jsD6rZ6P75Ujbl0BOPZErAM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pHbEkGn1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3S4LvaQgKCGQCTFD+IKVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3S4LvaQgKCGQCTFD+IKVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ardb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488f973ddfeso76715095e9.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304139; x=1777908939; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fih3i4e18PfvVXsOqO+51UGmMLaCoh2lR+Igb4mepcc=;
        b=pHbEkGn18wNntwQT479EqxCZvhMkrZG1beVHCnOzm8s2AWWe8cVcsGw4uAv0/sGU0k
         pYie+aQStUfWerYThvRe3z6C9rd/Cmg84m4F+T5LKubpfWLXHPniAr6Ue8j9jeikjT1A
         9+52jRqcbzecZFMDFSB5cQFz5xHpbT0FsY/wFf5YZmxQdaracAW0wzvqAxmoPwt27K3N
         I0GHfhF54zjAz8uI9/iZz6mfWnsF/zDRe0uh6JTixM46hUAWezr2g4SGhbKYYLb19zGS
         rgXxnO1av5tHPDfPC/uY1oXrSEzdcEZzU2q/eYin2ejUISfxqS9hrGzKMHyEfXCciQiN
         OKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304139; x=1777908939;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fih3i4e18PfvVXsOqO+51UGmMLaCoh2lR+Igb4mepcc=;
        b=rvlvFaFgK1xYuviLAhrYbjSAyYiLkw+JQo9arB8WjK01OaZ1INLA1Lw4TwTryOwSoi
         FcnSv7L0xzD9p/Y5orFnEeuZerQks/9tzMd4Il+3PAmwOkm52hgc4FVGOBEKgTxR6QsV
         gylHaDZGp+cBiDt79ESyOlt+FIWj5QzYR68eRrj0QwW2v4WE+g33Q38tUy9p+Se3xVFv
         XKIOJdZqarWYJJvdz9owwm7zHZqvWrsKkhJn1vrEHdp4cCWCEoP2CUa1N0cUlB6bKNPf
         YdxU+qoycbGfJN45zBLnS49x7JmkX0uYVzmX2jRkYUoxxIlttJxtKMwHN1HbwVLrgQpl
         2H7Q==
X-Forwarded-Encrypted: i=1; AFNElJ9lOQ+pFp63vViTUU5iWjjjFRpSDu1UQruHHR0Z39q8rj/JzOfOBsKOptLDbGpHPsAqSfIMFJAvNw==@kvack.org
X-Gm-Message-State: AOJu0YyJQNYi5YgCYbH+XK4VWWWVWyZMWOTNJQ+jKKERRPNAWcZpsTw/
	VJS/E2ABkbpU7LoE20Wr/jrUhgPMf/yWnEIdLe/3bNPPziKfuwjTz9W4tXxf7czDV34UnOcdKA=
	=
X-Received: from wmok24.prod.google.com ([2002:a05:600c:4798:b0:485:3a48:d6c5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a30b:b0:487:4eb:d125
 with SMTP id 5b1f17b1804b1-488fb74dff1mr437765065e9.9.1777304139320; Mon, 27
 Apr 2026 08:35:39 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:22 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=973; i=ardb@kernel.org;
 h=from:subject; bh=h7ZYPXsk7x8qiYN5Bb4ArPGJm788B+DXEeUwDjC4Hlg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E2OMr//DSScOyewrtDKSTj2pNjs54uXG3/nW1/QLW
 jXW+t/rKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPxecnwP+a5BK/ZucVOeU81
 7jYvnbjm7Q/9FoVaDcW+23MP86w91sLwi+mK+4lU2YQl89dJGK4S/TllWwHHxeqs1PkRZyUC700 14gQA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-22-ardb+git@google.com>
Subject: [PATCH v4 05/15] arm64: mm: Remove bogus stop condition from
 map_mem() loop
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 540F81C0022
X-Stat-Signature: ybko5p6wnkzfezu93xjqdpnoryq8eof6
X-Rspam-User: 
X-HE-Tag: 1777304140-201927
X-HE-Meta: U2FsdGVkX18FYqhORLXYK+s1Ez0/XXkFkDb3H3l/ffeP/Iw4igUgpsN6TZYsuBA3ge5fHGt/z56T94JI58I55MfwX822kdH3uy5pbonzdMpyvQBTISkqvNSpxMVzJyW5Cl7dc6s5bAjq9vZBI1byX3z6bt3saz427P0g6mWLim8At3qTp3aKBjcx+R7SOKET5RGE8v+dKBNQNde6qDpgN6vmI55NY2mEhDruPl9gTimrNEl3FUMeEsGX7ATFf/rZD1u8ilyz0tAXBZ8YVDC/x23omdEcgFdYA9Q5lNhcnBAcvFIqTobIl78wVYkjpLOEdaj/ld4vVyXaO1IvTCGqcE98zApeOoBBL35mSXi+BApfzGkwPjGBYyj6dmetnL1/GZ/+VeX/mp/1yArcCPe+RqbXxpWFNPzKJEh85uiO3zm2RZR1IvbFL4EdASN69ZHcZU+JFKuPeuLYM+wqyEnwZXCOgHSX/RYM8ihA0OELeWJRdv3SACcfxJINLn9Ug3DTyCDJNwZuvfxFd7xIWCh20DfRbsFCXIHZMw6SMigALLkADbyHwMphAKlCT4ty8xE8ra35ONgPbFamXg3vPPuuqIWaPYAoOfQrB3zYsSH4tU/Gi+NXH/zsfctNWqEYrlKFSbRaFNGO4CLxmW/HP1g6GNGbL+AYq5A3fEM0I3EBrZFiHaJyF9M7PppmokGIFK0lcjzsIWosDxHooe6GoIrU9gts5tQJ5H4BuAZA1TNwJSVTZg6O8A0FduLwBPSumXY8V3VJbFeq05BPjnn9gBTVa1+ic3aiHobBnv4S5vcs/RQ048lOx6rqvl4dWL8A7GF4SK5xp4hLYUCr4atAP4JCTO2cKUzeBVFZ9A3PL/RCNqaHWqJhonzmEh7PqsL5b3gOvwV6uiHo29G2rcuTiMNOh3Yw3FEdnrjUS0Uw3dpsetqJcedpyelBakiWz7nOpGPGbk89AqFzvzXphvCg1nL
 cKgf74Vk
 /Z8prDqGD6nulQ0FRbADMTHfgfvbpny/DmN4oAGapjEJT4mALXIbL0z+nqw/bNizQZ7tNhZas4wwWBJbjvMjNsuPmA8So6UhtLDAnur6DhtlosQFxpUxt8db8eS+fSD0SQd/ISpw4Xt3gGV7TXH0yxa2MHKSEy2Tiw3fN+LMp4qTQuYsyiHqmlxXmkZgCpeyHABfzWojyRIi1sGXE7/ETP+MEWdBhLNt/Ei/fQk+iDIafB+QIORrn6asfFfidIrcnRvx1qmacTjntZgbgXqBJyyQa33Amhjv1Yc44x5dk4NoZjGJ3KwFz/LaH80tRHvRjRm2U6vsZ1s8S+beQCdnqQD304nU7Atp7PqFDVqev6Wh1mCA4JsZHz7NvgYsE++VCo+JSB8S1mO9UMdn4msW5Z4dT//1l7qct4dh7Rzk63PrSfhU6FJhLlE1ASpDHZXAy3yKKMzFfm/CATg4WFgBn2EC+Y3mtZA/27/J+ES0LB6uDa5/sPILEvoXq5c4nlhWyxyTkfaV+xjPQyrCLcvjNXJGzHwAbdSiaHzAF8Mq93U0zcgdZHTSFb42jqFCyvG2G9MOACsDem5QpTEuKHtfB8+2hnBAuAibu/2l784U93vElLFvHk7SdKNrXuTaHjqCAUbJrmQb+EIN8QbjgD7j/esI3hWjvGDh4zjJtWqfXxL3U8JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The memblock API guarantees that start is not greater than or equal to
end, so there is no need to test it. And if it were, it is doubtful that
breaking out of the loop would be a reasonable course of action here
(rather than attempting to map the remaining regions)

So let's drop this check.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 005844e521bd..bfbf3fe0d1be 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1177,8 +1177,6 @@ static void __init map_mem(pgd_t *pgdp)
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
-		if (start >= end)
-			break;
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


