Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09544D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EF06B000A; Mon,  8 Dec 2025 09:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2486B000C; Mon,  8 Dec 2025 09:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C12D6B000D; Mon,  8 Dec 2025 09:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49D8E6B000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D4C513902C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:38 +0000 (UTC)
X-FDA: 84196554876.18.91F6F47
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77301C0002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PpuF6bzp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204596; a=rsa-sha256;
	cv=none;
	b=1yjCw6g5KjKjYhnYXO3sA4IaM+MJsZHpvrrovntCS/DpZ1rr8cb4uvxtl+VitMWxTwJS7U
	Ml7oWI7oVqTxB9Rs0kZzsI5XYORn1o4hebPZFbaV83z0GEL1D7PGgs0C14gZsWcP7blNKe
	Eis5yfoPkRKNpYB1rXZ/md8yhgfdeHI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PpuF6bzp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2riR/R2dhYMo+ThQ6rHTrvgCjpnBZbesiQOLOdzo0MM=;
	b=El/7VS4iqtlXSm8babXo5rOh23Fb3zeQD5OWPIcPZF1eyvr2vm/YjZdWCVomtrXDsqhk/W
	4Al0P2r3tOdKc749mrDKaIGv1xu/SIv0nvGiM2EvpXpviiglu4WZ/EcoE/8g1/0Atx5Qgf
	Lf+n1HFW0RKiBb9I02wxOJmUJPIXSW4=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so8320246a12.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204595; x=1765809395; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2riR/R2dhYMo+ThQ6rHTrvgCjpnBZbesiQOLOdzo0MM=;
        b=PpuF6bzpbDpwqw1RcbnGUREXQEDhJQ4h5mz5t+FLIcVU3cf5ujO67QhWnz/ttdOq0Z
         7J23vk35hu4IZAX1PGE6oPR1iLalZWq15HOI/FdHD8rsH5CFpp7CE4YCLmj1v7hvbc7j
         XDdY2cg5D3K7+rhLtAzepgjBSBvDDL1DqK+JzSrfyPTevx/Cf9ZEEG7+KAPT8oNe2uE/
         CU7xgVZPdJCrQkxfaj80Lcqg2PedHr7akndg2/M1w4K5DIxqEItyTTzN8ULbpW1sqXKF
         KQFjw47DoJVEHVzHpxF8NLGoA1ib2E868ALZC1GQr15Sep+z1ukD8msN/CKWnWq1+tT1
         jcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204595; x=1765809395;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2riR/R2dhYMo+ThQ6rHTrvgCjpnBZbesiQOLOdzo0MM=;
        b=TYxJK20ILEAXTOHH9KOxef4xKiFICNLnmBr00HnP3GxD/HaVJeJND70I6wLYHRjLUy
         W9js5f+4xIm0Dt/7wSLg1b6937Tw9cTwSZcNyXH19qZLY4dzIyzFa7AOp56qmLLQZ+Ua
         2g2VxloL/b9l6gObempc2K4G9o6pdH1oNpw/avwmTe28qxncxhS5AWiCfyxE+46MqKTU
         NSqKXHaGKM6qgBBKvA8VzQvf35/CU9uBjFSlfNfbOiiVvu8Q7u24IuffREVaMBRAJts2
         VV19oQkfNy5u118pSfSnw4hycD/1lVGYizPa6LpY/3AEjvIEAt+Zp+kixTX/gzaL7Yzo
         KD0g==
X-Gm-Message-State: AOJu0Ywstc1/x2M2+PFqNFcUc5caTjGLimu7+O8GAhH4BIQ6iUX1w3OQ
	6wrvv80DtWfC7bLqa0jNBSnsOhLU2MSyGhmoDavm+UFf3cxX363hf42S
X-Gm-Gg: ASbGnctvnVLAoTAseZKhyf2VlBEZYRXQ2u50lx/dGfvSJFbP9pzZbdZ3fjrxf/V+cBJ
	szyT7I3l1dEJxmtIiV7xTvKp/1/5VSda3bv6qTs0EpA0xg5Yuio2xSGj/krlTq7lafbzCeTTilp
	IpTJo8uAllylrTw7gScf+0CzivXBfoatG1ljy2p3xdwMaqOhTHE/38YrYG6wuSuNLwvOwtxRAqa
	zc09OdPD7i7nEjestxxzhlIl5b4Q41NBOu0ZT68Txnu8QJK/dQ5pzDAUA1q7n4uqAOfpp2PTst4
	09uMcLQuTVL2yH5IbaxAMAWwkicv8RkITxzeQ/4pT4dpx7l+dp1ltIjulm/nIpsP65AloaU5FaS
	/xrlaNzZcdEAVbYswSL4t1cY5e9y++c8IiPjOm0v/YReptHOswmFNpp95iyFweSuFr3siCIz9Jb
	FvMz1oNcr0Nt+FcZ+Eku41
X-Google-Smtp-Source: AGHT+IEIVEvBLaTGs7HM25ugPjY62/77tggOBXl0rGMkItwXqCGT0zRg5dzMYE2I8LwM25I4VZn1ow==
X-Received: by 2002:a05:6402:a244:20b0:649:3ec5:5685 with SMTP id 4fb4d7f45d1cf-6493ec556dbmr2409715a12.0.1765204594926;
        Mon, 08 Dec 2025 06:36:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b413b590sm11054218a12.35.2025.12.08.06.36.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:34 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  03/11] mm/huge_memory: convert try_folio_split_to_order() to use split_folio_to_order()
Date: Mon,  8 Dec 2025 14:36:08 +0000
Message-Id: <20251208143616.20797-4-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77301C0002
X-Stat-Signature: 19ggymjshncyotn95wgjohjp69jayhxd
X-Rspam-User: 
X-HE-Tag: 1765204596-973054
X-HE-Meta: U2FsdGVkX1965FsM03vSoFquK+b3ACwBMfEjZGzk9QZ8CzzmiRaIeLptGf+8P+GQ3eqQkBzRZA05ImPO6dw2fi5RfPshKcQoyTecAhaa0SXc/NE8Pri9js/l35f4DifYcrh90++uT7l+n1ptXeVftNhvYvo8wO8yzMbeJ+hgVgGH8mPHh70wJG15oEyWGhMee4oqy5i1No42AsWjdLiNTWnECoWJx8BCNpNb/21PI65hINptPIHufJUkgItAClUfLrreul12//Ccl5IolMyzSJPf8zaIRXIxqdPWtRYV9MMT60xlUPed4Wh/WVD/GkdBYy4Qfn0dGgy7D9XiHIo/EplDrt7793JppsOmTumWj8eNdd/pK/9J0V792sB2r0c+cesxj/IwwQ9kxkDJ0e1xLbaQyvUb2nw4NSHlkPdh4irzEq9hqSFmzA9fQVvospIbYsqYV4UnSXlNEnOxshuUPmt4JrKsBK7xl7yflsdcH5yalg/3+Ah5r+/G524/V8vmdp8crjcyzaFn3iT+3rMCHp2hVVECIoaf5FD1tziA+K8JpXxvF7XaNSiGnpwZ8D0K5aAnKD5wkVQakP/SFouyNhAoWxCXoLmWiTx18f15FxaT+qS71s1SQaRC9v+BNn1wqn0SPU2fzEHc+4jw4cpTaNlGGsg97pZXL1xrF2cxi6dyN56jD+sdpRfyPbmxrPSSOirFMFhrhpCVSVilWCkMfSbmgKseFE7jdagp6PJP2n+zm5hutWGoT4Z5GwxH7P39m/GaQF5spVzLqHag6kQbxXoeGZfq9EyrkI5NS+56qTh2Jgew8Io1AQjjYkaXvKj0bc3EKgDfMubenSCDSBYSUXlDMm95kDLvxnwGFgUjvcp+SW/P7RI4CaNzjm803ROgsPcvneR1erm8fjX2o7ZB7nsu6LHAFlq5oeKpC5kPalr35dSvp8GbOAh+KFTJzDRIQ5s/bEz7i/rpMr/SEm9
 3K1N8LwT
 c6+Aa+cN3XfYyAOQDDzuI6eho/cM9IH9q/oRIfsuMUqndScYa/wdHXXSAgKUEOVWD5oh662ZyDOZ8bCC5dmAc5YbTxqYH5oa4FD3CqDxHXezgmLw21stydoDC4MZYbZc87fu932mVCnsrraFU78ZX9g1ZHa1XlEwpxs9cWky9AE0tH50VQawRoYQuTXlFPwYTWmTznMrBxNpKKzvu1bF/27UyDe3Jw1J2ai+Bhb6/5GRX7OndU4nNQxgIuQoTkxQsB4+n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function try_folio_split_to_order() currently calls
split_huge_page_to_order() to split a large folio.

The behavior of split_huge_page_to_order() in this
context -- splitting a large folio and returning the first resulting
page locked -- is functionally identical to the folio-style helper
split_folio_to_order().

This commit converts the call to use the split_folio_to_order() helper
instead. This adopts the modern folio-style API, improving consistency
and reducing reliance on the older page-centric interface.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 977e513feed7..3e01184cf274 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -389,6 +389,11 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
+static inline int split_folio_to_order(struct folio *folio, int new_order)
+{
+	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
+}
+
 /**
  * try_folio_split_to_order() - try to split a @folio at @page to @new_order
  * using non uniform split.
@@ -407,7 +412,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
 	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
+		return split_folio_to_order(folio, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
 static inline int split_huge_page(struct page *page)
@@ -771,11 +776,6 @@ static inline bool pmd_is_huge(pmd_t pmd)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline int split_folio_to_order(struct folio *folio, int new_order)
-{
-	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
-}
-
 /**
  * largest_zero_folio - Get the largest zero size folio available
  *
-- 
2.34.1


