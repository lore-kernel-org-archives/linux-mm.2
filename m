Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBE1C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E116B0096; Fri, 24 Jul 2026 06:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5C66B0098; Fri, 24 Jul 2026 06:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FEB66B0099; Fri, 24 Jul 2026 06:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035096B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:06:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4E98A1041
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:06:03 +0000 (UTC)
X-FDA: 85023239406.30.9D17971
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03DF618000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:06:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YRj2o3Zk;
	spf=pass (imf16.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=uqbarz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o0x9J44qVBxsbkEywzSNqZdp3EOTpYHRk69RjXAekuw=;
	b=1gg92PnMc2l0EEUOzzXTQHXrSCyxMFJU7RPta+2JOl9qh8WeStzsUwcKfafy91mOxUsvKl
	W+MART27czt7iBmamIa61E48QxBUJTQ9FCuU8t/tEM2TbXFo0Pe6Drvh6YtgAhzu3bMb0b
	huHLvYp251oKHeuQDWbTnI1XqtpgptM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887562;
	b=4KcqVLGwOQsGEvepdfYxecdoZNRjVy+Dgco3rqfSTy/UDL3zgtB4/PlHfSubNTpkpZQhoY
	0L3fIvJoOTjvpcsJR2Gzt3GUYs8dRGcaq/iMxeL0tlzb/hu2c5u7njqtQWlpHfwq7Z6LyV
	LYXPy3QkeduOlxix2rtoo1ZosnOkp4U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YRj2o3Zk;
	spf=pass (imf16.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=uqbarz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cf52d15d88so2719035ad.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784887561; x=1785492361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o0x9J44qVBxsbkEywzSNqZdp3EOTpYHRk69RjXAekuw=;
        b=YRj2o3ZkJHKCEhLcl++JpIk9FqGQqiY+JQreuPIi5Qobn82+kSlkZGoRD4ughCJ19C
         fiKVEgVdcjjitaNWeJ07lH+pm5FPAqm52ZPNifOXdJp2g69IyxgACskfH3ACShD6kI0h
         V34F7E+JHM8dUUUcI+fPM2dh/3gck7KMVFXdZNPqWi9CFD9wJII9lQ5qp1Edi/8lLgWv
         mQrABuGCyo8oeNZBVoNXIK3UC9kDXCLTAFB4DIynYxmsi8In4pDD+HHXvYXNH1a96oNM
         mpii04M6WpjI7EMSpal8SGsZUy3Fvd7HYK9nGNn6lUmUE3YmdhGIkG9WTOquVzarse28
         p4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784887561; x=1785492361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o0x9J44qVBxsbkEywzSNqZdp3EOTpYHRk69RjXAekuw=;
        b=JaWR7gjQc1IGm/4bYGgKQGeMq+V8Ou/onRmE4hAaN8gEjleG8JggW9mtlajXA4u2pp
         uXa6szlpFXP+PPez7q8ANSw56qrSV75IoBlkxpVJQCfIrKLHTekzRh9AwgKXMwX32CEg
         G17yKWAZG0G5n3mhPODpIagpdaPKwUjbNrxUWrG4Q2VN7f6PrcBaQM/2+1on4MT6iI6h
         002WPUQt4arG/kK/aSoR3DtmAefQjul+HZF0AvkHOcR7LS5Y8CioUg190bxoi36nWegZ
         ELByac2SosQJLR2rt3K01+FB6q3JPV4aHEkJNSMOeYnarBa4oYdvDsqTm+zbPEiKq/NK
         UKZQ==
X-Gm-Message-State: AOJu0YxjP+82+ZYzjoz961RaRxlB0UUZDC8yp9oXJIAH8aWcDBi5JUsW
	M6O06Q9RlYaEwD+26gJ/oZS6wvswYu1wWCYqZBrUdO0h3Wfiz2XhK6ySfQS94mxWzAzOXVgM
X-Gm-Gg: AR+sD10lcUTYSWsWVIP5WU3ICvWx2buCG8aaz9JV5oimUUj/mrrFSNSPYdUF5juuWtZ
	pGhLUFckZcQgZnjNkgYKarkSneaSZfO5zhd6bwMrcfT+JlYGOWvZaMIfH8NAWbv0M6bdjOA1k5c
	aBTb0L1qkMVD2/q6KGeXTEIk0cV33vruelRIiRaouvaVIQYXLqc71/XdaY/I+GhukggIMpddGrL
	gMSSl8mXf3WmUlIgW5gLSmqIS7AfiYEqb4jfCG4OU73D+ORJ7Y2bEe28aOJBtC0aXZKjfjeGFNq
	haPcye/Faf+DwJa7aUNndzmf1LcD4CKo/cLp/Lp37AIyMgkzCf+bzHNcqU4b/nHfhNlUjvdW63B
	CCn3OHsTRvv01B9ElBxvlNtL3GeJkXzNoUqtyctGlmJHr2hMV7n6gB1b3mbKFJKnMs9AgmwN5K2
	Olfo7w01GQeWA8vDigRDND
X-Received: by 2002:a17:903:22c7:b0:2c9:ed16:8d8d with SMTP id d9443c01a7336-2cfa6d8797bmr76515745ad.38.1784887560837;
        Fri, 24 Jul 2026 03:06:00 -0700 (PDT)
Received: from spr1.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa2cd0sm48600405ad.4.2026.07.24.03.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:06:00 -0700 (PDT)
From: Hengbin Zhang <uqbarz@gmail.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	Hengbin Zhang <uqbarz@gmail.com>
Subject: [RFC PATCH] mm/thp: order huge zero folio PFN invalidation before removal
Date: Fri, 24 Jul 2026 10:05:09 +0000
Message-Id: <20260724100509.2300200-1-uqbarz@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03DF618000A
X-Stat-Signature: e7dbozc53fzjrt9j6rwzazczoa9eskeq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784887561-121506
X-HE-Meta: U2FsdGVkX1+eZacT38up+FhrcQ92LmmQiiYNIcfvRJos+ND7Am1xcwud6APqa22B03V1OSSoxrPyvoO5LH7XgEVOEspRVZ9Fb2HcW0s+XGMoaJW1MDPmBt7dr6JD440cClOe8jKr9wde8/CaQ6R8+GCZOPSx0rRiz/K535Ojs95IALccX/C073N+kWUtSaoe8UeBRCxGklt/YOC29sfdPjaIc9JgI9kMpE5g5YmtAopEed2LM7UzPw7G7OLhWvaLAxCVKdB3Qhreg+NnlavqsuNbNVH2D3y89YwfmXT76PjOdexEANwhwKumk32kt9ddRy8cpfsZY09S3bFY/R0SUYkK+oGnxYzT/suvPGoYa+N8ktV3PyjEgmTYtcLE8u+PnSNDmNhw/yJSfV0p3jgvuw7pT+KXvaIDGz8+w4DZhKbgpYhV4HiiExsphY6zlLf7tTy3FmIm/4Ofs7Hy4R/yRnIK9w0avIgGA4TpT5cWYTMJFnx8GIb5x2kIwrZJlV2Kqwk12oNIAGcGs/SPoC0MsUOuKuN46ZOwjBKLBfC7Xz4eit/OsZqgrIGxqCTmZ3+inmG98UDNajeLr88Kv2tewzt99PrHK/+qiOAK4zbPyJAGwqcGlLUwNu+VkW57wXUk08fFgMHrAugiP0hLqNpybhKDLf3tIlNM8DG+H4nIrAt0tg3KeVtzp6Bfo/XuVtHUbHHgRpF4i0mmuFPYDQdzoZDe9cjiMByViWK34vR5mVQrP4jV7k9dgKDT3VoH30VAXQb4D9D24ngyryZIkJkZUnW/19te35C4Y81TxTmO+mWu+zXtBPmaQ1nAxNioTAOO5C8eIKM08DORDCfZz7tw0T6vKjSHaVHihPbeDavdS7duHonJhFp8kNia25u7gjnfogBh9lXMMHMAhs6ZehdlZ6T1Rn0WAgqeDKqvnIvhvi9EO6OpHBC05foN5sAA8ReT4g1/tLYJxsPYz303+Ca
 Nk8fYTuM
 Fb0DDsOLhVvsFu93m9Tm1tlghCpSb9LG4MKBaL99k2DvByI2VQ3QuHxCotFvPX/yxRQKQiL8OGUa6QjcCmf56xD1dKssLVOAz4Agm19VD3q3jQv7ra2G6H+0qMeYZiWgIMqnUCFg1XnDlDNUJiVz9+Tb52qbidt0BAcfB8IazRT2RC8lmhhPq40zZZ8ASd40GyCzS0F5mJVctmoGNCCA0tEKifkYOLOZU11TQDawzh2qJWu2jSFAdsi+K4/UJj+yDHWutFvqviGLMPa7FybL29Na9MH/Ri0gkbAjr0Dk+fPq9QvfRjw8/MrbFcT9p6b8Dg880Er1+giRkDPo4dIGfB0xB/VXkfOVF+jsrvL4zlIymOa+z2ozDYKEVPqh1LvBIb48FZXq5Fb9XcbxSfd6xV6QkKJKy9w04K2JL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nonpersistent huge-zero shrinker removes huge_zero_folio with
xchg() and then invalidates huge_zero_pfn. A concurrent fault can
publish a new folio and its PFN between these operations, after which
the old shrinker invalidates the new generation's PFN identity.

A later partial mprotect() can misclassify the live special PMD and
enter the ordinary anonymous THP split path.

Invalidate huge_zero_pfn before making huge_zero_folio NULL. A getter
which observes a zero refcount while the old pointer is still present
cannot publish a new folio: its cmpxchg() fails and it retries. A
getter which succeeds does so after the invalidation and publishes the
new PFN afterwards.

Fixes: 3b77e8c8cde5 ("mm/thp: make is_huge_zero_pmd() safe and quicker")

Signed-off-by: Hengbin Zhang <uqbarz@gmail.com>
---
 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b5d1e9d4463d..fcc492368160 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -298,9 +298,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
 						 struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
-		BUG_ON(zero_folio == NULL);
+		struct folio *zero_folio;
+
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		zero_folio = xchg(&huge_zero_folio, NULL);
+		BUG_ON(zero_folio == NULL);
 		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
-- 
2.34.1


