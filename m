Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E966CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FA58E002B; Wed,  8 Oct 2025 21:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F90B8E0002; Wed,  8 Oct 2025 21:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7E58E002B; Wed,  8 Oct 2025 21:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5628E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E14813BEB9
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:46 +0000 (UTC)
X-FDA: 83976917052.25.586C744
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63C8420002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=XhIW7I8o;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf03.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975124; a=rsa-sha256;
	cv=none;
	b=fN7npLZDKzb8ysT3sCOG9FyJLNQ+KaKXY4SIz9YlYcYnXaKSxEZ39d6w0vfTRaaBc4DlC5
	xKc+ttOj9k2RB6ehv0Un6oBF6YKOHbfxoRj5d1koxGuZOBhpZ5kFIWycMSvebO0I7lmDz+
	ajmTmdCFc/Y/GMOeSE/hxHuySyDMG+w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=XhIW7I8o;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf03.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdiVfcIiYEtPdSKu0CqenqZ/5C3LyfHi/KY36+7mBoA=;
	b=x6mAvXeRF9KOT5xy6bTaNBBL5X/7WaJimBpXFhMWkwRB8gh0Gtvs5CeBFg0A8+N8ml1WoB
	uLgQFpQRnb7ZMgggT5i1HjajhE2hqOrrQS7kTHnaYRucqWy9xx7har1gfHnwbPCK7EwkJd
	k12HtpaVaNTW1lyfAbiC3aBlSWfJlfE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27eec33b737so7024415ad.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975123; x=1760579923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdiVfcIiYEtPdSKu0CqenqZ/5C3LyfHi/KY36+7mBoA=;
        b=XhIW7I8opBUN3WOKnBB7YpQ8SgY8GYlkagYpOMCziGLF1nUpmbt44gEFruTRjpEFM9
         aNikmyEDz0XhDW4vI9/OPt0Mc9gqUeyu7zWSQouo58Ox/2Agc1OqwPN48xQhZpjnFJ4W
         YqW31Eqc4mRDMH9F/ogNZgjZavnSa3g1YtlAtiT+5nZDJI3AzeDR0T2c4muQ+Rretg7O
         F1dUtmVEyBlkdeMdVOtEdV3mMyMaBIuG2gSO3MlE3z8frWWZAc0CZsC4q1GHyG65m5Gv
         HeOWDQSlos1FASZpF0Acwu0WSoWGgRONRtnnrlq+i8jSSY/vktFu0sPrMQUk6i6LGcBi
         l6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975123; x=1760579923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mdiVfcIiYEtPdSKu0CqenqZ/5C3LyfHi/KY36+7mBoA=;
        b=jRVQeqxEqfa2LaWLtmlWCuf69vOS+py5M/JE0M9DAb+0Of9OaEurrH0/iG52aOp/Aw
         jt1q2etuL8X24LZ2Sdadr5G66ZjZh5X299CFvj75GpfdS+fJBpKMNfDqDwmORMVZ+Z+U
         X2YKAh6sUjB3zJ7gsndQMCHNLVUMLNTGX+uQ1ggIpoztN7vzdWzDZZGZyyubNaqwocKd
         R2aLAwK1KnDYY9FR02y9nhtu2BCHUcym+Fhq/4evHl6f99mUbuV3HX3Q2qDUJ0lff+q5
         PQcqNHd9cEtW/zxItNBavS3bpqmIE+vqHmCR1YZeVOt2I5zcGwMGtHgPy9RMLCdAdpLv
         nvDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLVZkJpDs3DQpl7QNs1t2aBxL/VVGhZzvcTGLz5rB7HC/4miUGkhvh/F8bOK0iozflw2QHIEpycg==@kvack.org
X-Gm-Message-State: AOJu0YyjhBVETnzqKo2HBIL3AovjqIzD5YXelvipF08fvSERGhc0QLLC
	99xkea54l41byM/0UlESPFcW5Fb32xyKMC38hdLhtCeuj9nfn1Xme+/f8RoeLvgtVME=
X-Gm-Gg: ASbGncsxDF1vzV+h/s6EvgMYGbp/jlqzErhkmT6110IERmH5XuQrvNZPf6XTtxJ0Nv/
	QqGwSNxy6JnBzv3DpE0rKvsMtffZcOr0JcJzs13lZ6dt3ZGIXRq46UQSW2ch8e99XIIA1wx50tT
	5l5XZ/jF/r8NKM6OMZL6B0lyCRZXbnmXeQe41nVLNkrKRzWTMkN07X7T/RTVL2D/IGBf1wXJo7N
	jgPUpi+4rBUOtuBXS0QvF5t4oagH64sekucu5slQwy7PBVHxQI3YUNByzwG1ahAas/GSsHaX8E6
	svzaO7yqz4RA/Zcf5ysDAgKHhiBpnGgEG3n3eiGIHacz+KJKHalMzhcnHoyPaeTmZOXnyClKFOk
	VR/ceS6zlPrJrJ4eXeoVXHDOhCuf1DEvph02Q5SMvVAmtBfbDUNaGHFLBbZBheP7JWTtYjyg1r0
	zMTUM=
X-Google-Smtp-Source: AGHT+IEAHeuoGA0XLStPTncgvhvYEundXEr0shvSlmxf+pcjXId4G/S6mKP+GMbaTviYedqoip+3mg==
X-Received: by 2002:a17:903:b4f:b0:288:e2ec:edfd with SMTP id d9443c01a7336-290272154a4mr64152045ad.10.1759975123319;
        Wed, 08 Oct 2025 18:58:43 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:43 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 02/18] perf/core: Replace READ_ONCE() with standard page table accessors
Date: Wed,  8 Oct 2025 18:57:38 -0700
Message-ID: <20251009015839.3460231-3-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6xw8iahe8idoarbc9zyde7ro3hraacmg
X-Rspamd-Queue-Id: 63C8420002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759975124-89776
X-HE-Meta: U2FsdGVkX18baAsPvryW0nWfpxyx5u01O/J12JLZ/7iZdVWg2OiN6BxvFSg3mU0b9B/KNpcTNHkXSgHIAnMVbzuCGjnNR7tY5N6udDdr8zPtf4xzPw7U4nN9I38+rJGKs7Bn3wsK0uHORPP2fQ8Qexye7srKMEGhBMTJ7urjMhaJPT3uBkFLx/DJXx+M40Vxkbw2t/X95HhtDBYF5Ghf2hEk1h7cr8UXII1Dj1aVKTfUHAOcO0IMTOwoaweSNZ28o8xHjrN5DT/P4pTS0+PpHeLuGMviLps5FP45oFCq22+BgW0gfK02t3dBgZxc/0u5XIQgUjPHsNMS8d6I1Jm/N2d97vij+7UcBdYrV/8JwZKQ3FacBruCQ7tNKUcQy1D6laYkX43dd+A4ZD825s+gbCi0D1BCgpkT37oUergV6ohLjZKs/nFgtqLdSvritWtE/LLnvnvVBrmBEpRWzEQ5b3L38v21vyDOe7F1alMyBiLnUfi38EbRbxFLzHHSaATrPuhPissRINvLzPqS3Sq7KhnG79h2onr/0TI1NqXo0NCVWOPLUM86VngS+tO3+apABUL5ksXXDrISP7RPfuWpazYbx3rEQRIycMwi1B2gHqvT2dOoB+oG/jwASusazqGCV9W47mtfCkCO0uL+vS54Ul1uEjXkLIttI9/sTELivBfVONspfhSydYAGHixNNOk7hQgmWCuAwOE+X0Fy4CxXCrZ8VASQ7cCbRZRcS8eacPXoFdSFPy6ZjGE6qgcjw80K4k5lFP1Qt3Ys3B/hiBUdYBqEXnXrlHnsIDJJwoUYv1/5W/bl8tBugpO5XmIwE7Z/uHCzM/EWUdQw4+SRC7nH767xjLbMcQbHCW+xSLr6AexE6LfuJygIAuBhjZknEPxFa5JgPmIBLL7kRBN14XEjU6oaSuytx9cOSeV/vRrgS09M3KAO+iDDPbdQCF/a5tfWXXiKLEbm3gFlZLWPYJ2
 QOmyxU0u
 flbc+/oLEOEGkqB9ZHH9iJVEwe2LzGP406AuqgSGAVL8ALyvjDnsSACNfBI/uPHUMOktm1Z98OgRQotJTVOCepfz7bIjD6+FexyQRWbjYa4XuAtjj3H7YIhL5cy3wmmX9DMCkIHT6nuI5aieuCPYg2UJeT5gE4JXerZuP5zF+yEAsj/yp949YxCiYlWqKs9nGrOWqFnGwsn+uNWKEq4UcoMk/dLw3f4IvdpaUQFgpBB7PcvqHCwgfzvpD4HQS0XLfVlXVseb+/cJ2qdmrOdc2xcU0gHXEGMn8FvzauijIfl7shReCPUawYiNniQXhTrBt1P4u9G8zW3oD9OdOQBTI5OUwVkzDiqeKWJ7sSy0nVf5q7H8aD0yLC9XMhQPzvBE5iEUQIgCDEhjp5MRXc9bSdS8VRYlG2mv+oH7Ez/W0rYJdBhxkvMMady5qhJ2o/0tyykmA4VjsEzg8i6HR07panCNsboyeED+WzhcuveYC5DeBAuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with standard page table accessors, i.e. pXXp_get(),
which have a default implementation of READ_ONCE() if the architecture
does not override them.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 820127536e62b..952ba4e3d8815 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8110,7 +8110,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep, pte;
 
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		return 0;
 
@@ -8118,7 +8118,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return pgd_leaf_size(pgd);
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (!p4d_present(p4d))
 		return 0;
 
@@ -8126,7 +8126,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return p4d_leaf_size(p4d);
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return 0;
 
-- 
2.47.2


