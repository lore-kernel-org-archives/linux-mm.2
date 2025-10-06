Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B973BCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2D88E0024; Mon,  6 Oct 2025 16:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1258B8E0002; Mon,  6 Oct 2025 16:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07F28E0024; Mon,  6 Oct 2025 16:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA9F38E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:03:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A25F140708
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:24 +0000 (UTC)
X-FDA: 83968763928.15.3DE25AB
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E330A0020
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ll6DHhj6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759781002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tT3gHG08BkG90c6MiUPgy6uFcKswLyMsm2cO/8LgJ2w=;
	b=FNsi7OM50RyuiP7g4D8Se1hryooU0W8ECK/NlHz738qGpXtGQEJgJmy5jljF2E6mwT//Vv
	6Fs1sxUQRp5LL40Bf+lVwCC2tNcWFGF2OSXgDoa2LoBJXNDBQWeJk5HEmipAU0oSOgGh0T
	98VKUP90GHnOslzmMH/HTma5KD9zssA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759781002; a=rsa-sha256;
	cv=none;
	b=IfU+NuU/pf7GBfSy0Qhw7DSoYkLDpSGKriIFLKnFRSNTagxUiKjzcJt0rLbd8pVEUCv9GK
	AxHRarC4dziKalN9v56/Ss5CooYiFIeLtrlBeVptPQLhko9wZSlxGGWyVzSaVh/23w3dL3
	87kSeMumGoCdTAX3QyskFJYy2Gh9cv8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ll6DHhj6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-330631e534eso5912085a91.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759781001; x=1760385801; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tT3gHG08BkG90c6MiUPgy6uFcKswLyMsm2cO/8LgJ2w=;
        b=ll6DHhj6THaRocBe/H2pmkUw7r/oaNDsfOJp30bp5A8wGpKvKTfoM8vodCM/JOQaBR
         ha7AL7imeUIXAwLU9lM9nyOM5Kgbr1O58qqL4iqllzhGtHj1Kz7tbgZWiYtBMchFrIZ8
         3EOk46VGH5g2+VZ9kASvRGuhtoMgs16v0vtYVXnziYcvuUsI+yr9DUA0/sNmintQlbZx
         egBx6RLlvu5yC0sJ2s2CJKi3uVtBZvFzRtQJh1NO65w7ANK3oJQy2nmEXPf/uHgY7SJn
         FEOnFEZJ93pJGuPzf5x9uJ17bFHdUqoeT8Cyy8hiwjANfyXO4ME5alhHE00nDn2scHZ0
         w/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759781001; x=1760385801;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tT3gHG08BkG90c6MiUPgy6uFcKswLyMsm2cO/8LgJ2w=;
        b=hvhBvfK3kh6QF9+zrfGY4+maMilMfOF5JkdqxrJJA2tpYUqt/ySgtCD8AnchSdYo3O
         WNCm00wzrc8JjQSgAuDwGN/udeqLR3Fl/XYmsSRYcPu4rq/Qii5wmUa5kXjFIhEZZvwa
         yIfhML2ySJ6I9WbYDB0sZep13JRgZRcBxbyvgvUmlxGkuRNx5zKyX8b/pEj4cwaZK3od
         48uBN1K35+jEH5iLnO2UqucaxqSjSXTCG72AU01V3l0rSbLBAyD3SYQVPaMbbBfuzvKL
         230Pn+rMVnwLWU6O2vyPFhunoX3a3yhYQCVeUA33xNUYIVuvaK3sjQN5VKu2IzmwNwU1
         ktAw==
X-Gm-Message-State: AOJu0YxxZoRa0DdVpJ8Or8I5q+xIIbaZdDDbpIUpAL1gyKSLgg8H48VN
	pdyrB2EefdutNzEuagD76NNpNN2fQpAdRXtEWxNLw5Hy7Wv4aNSvJQC70KCn06LG
X-Gm-Gg: ASbGnct7jFe0qiI0zrSZ7oWqeXtH5//dOIdRYeCfPygD6ekapW7CPE9NYaW4W1qGlOR
	UIGv/qh0nJ3154sv6iLWBAjkfFh0r9o31tnPBJAte5PU7fnaOzv7tmcPFx2yxUn1Yn3nD3sAB28
	AIUf7eeTraoSStcxdHfu3p2rlNHba64ijte8VtFUI1oHCUIvH5ZJbwS2L4099iJpcP1pYhG/bRK
	HS65JBDFMIISmBoJNGylpN7TK3jvjGqUYL6+vQEOPmKrg1BOsKfHLKxAPDprTt34M+82+o6NLp/
	Aj0SeID235vdrqyUeMj6uhkvevbL0lLsenqJI123SzpXcc7471kOreSp/NHTmdKFPAu2OPVJk94
	dFpQRHMaSjV06Iscb4qSa0yp5Hfe38xWd2PviI6Q2r+pDUk6wXZDm
X-Google-Smtp-Source: AGHT+IHDTaQdL9Cg+WLyZqqSRaiz6Hdnze5SC5rU4ka3LeHNo2UnGttYWx4/NzTemH9+GPk3hGm4Ew==
X-Received: by 2002:a17:90b:17c3:b0:32e:7bbc:bf13 with SMTP id 98e67ed59e1d1-339c27d306fmr16089364a91.34.1759781001066;
        Mon, 06 Oct 2025 13:03:21 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339ee0ba20asm163148a91.4.2025.10.06.13.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:03:20 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 07 Oct 2025 04:02:36 +0800
Subject: [PATCH 4/4] mm/migrate, swap: drop usage of folio_index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251007-swap-clean-after-swap-table-p1-v1-4-74860ef8ba74@tencent.com>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam01
X-Stat-Signature: tri66p7obenuq19gy5hq7ffjf8hxbbps
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E330A0020
X-HE-Tag: 1759781002-558105
X-HE-Meta: U2FsdGVkX19Cu2znLgfLdIf8jLoiBkUKdyCixhYRCngnvtYCDD5mRxXNS7Zttx582l4LpCEsEXlRl469SQZt6UoU/zXE2mZ8sxbPP0zdSxKE612MU52C7HIF05QRTCLcZZTehx2uWtbfO2MDE9LZlE6Ybp3qoLhHkfEwMtTrW03jzpcqa65xPGJyOx0WBtPA5rGDbgrR35JsnxvLp3WCW14pbZ+IdVd4FtdqatW/+5no6gMind/+Hz9fcA1LcRNM1ZjL0nHZTBEnU7YCVEz+dQRPqdJq98mvqh7gPPqHoKpvBwgGxdCqz1ra9h1p1dYMnx1kYjTsk0BzkmeordjZsiWhYjazrhu9WCbT9bm+y8qU3FvdpNvhqo0YWA5fQJR+VjQtyonanRYi6HsxoSV1bPrzokR6Z2+0mzK+qEvgFYCc6Lzm2FWZIQY1JopZmvM6UZumC0OSmgijZQaiOpzHciBhz21PCliVt/5j5h0MuHQX2zIA8eFrxOkx50qF9TjKjsGW5kPmr8D++b0uX9PVv+4Rk6WS0e7q4Ju7jp3dIGbLvtBNUIh5yCdBGVHXUpONcOQwnH3HsQPznNmanlAq7HKbmRDIVjA0jDHGI8p/6pQ2p93Z3tzm9/W+Z1FHzBhpBm8kAZ+wFEyMnD5CUmEonzekqSnyVKNyLnH/QQqlyXiityQ5EB0vvAt8QSTEj20JTEVvamn5cd7CB2UPHEuDUXyu1xFg28I88D7sZG866Z81krvyIQViNoflDUTjU2w2UZf/LUeg9Lbu0WdEuX82kTcbb8vgffFRo7jP8wBkReRvP0+S5jc4lC/uyDkv/M1wXgB7hzEb/TrtgZxD49cCbRO0/2O9Tk+tkSxU/LjkxGiIP6X+PhpEn4G8iHLG/BOhf8k79G8tJLAkXDteu71ma9HAm9spnlmyoFnf7MkW7lHQBjkOp3qWYT8n/wHakoI5yDsGyS4jEZUAOPZmCIg
 dyitZHkw
 Zvp6luP0xMvTnVrfMggDB6rawfraXTKlBu0LPNQi7iyKpg28oBI+fQ1VJNfveCw5oL0BjtDlhcW0oTrnhYSH5tJO/DnCSaxyMdquag/KJdtplyQg6/UYiS4W3BfYK63rv6/LlhJ/ManvzbfB5HQmox0+DCOrtJR/RKsf4hjyErZRpOzdu1It+Q/hqCdAvQk1dNZsT8kJ+gCysV5eZMQT6ykOAdpREsTBd55sc61Tf4Dj+/qjTQnmeWr1VUU2qURU0jFT1rzzh+Ll6G77ruBXWrN5NjSQPoxtdds0vWvmCxSD6Gsob8pFhXJTuFd6ltXImauTz0XFXXgLsPYfNNWH/hOAtiiycMSbBaTVmxAFM/ilKwa6/R8POwlCB9pHh++Ima3Jk9Q26AHUKShmxU9+/qk8cm0vOeM+UvgnFQvXCIfExIePCI0ut621thbhVYl6+ASFe94g9IAu2y2SFTusKdl2jHcb8kakNeLxFkw7F8ETCr+J5MQ8vochDSlu9168tNbmO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This helper was used when swap cache was mixed with swap cache. Now they
are completely separate from each other, access to the swap cache is all
wrapped by the swap_cache_* helpers, which expect the folio's swap entry
as a parameter.

This helper is no longer used, remove the last redundant user and drop it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/migrate.c |  4 ++--
 mm/swap.h    | 21 ---------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index e3065c9edb55..97c931b31940 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -561,7 +561,7 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
 static int __folio_migrate_mapping(struct address_space *mapping,
 		struct folio *newfolio, struct folio *folio, int expected_count)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(folio));
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct swap_cluster_info *ci = NULL;
 	struct zone *oldzone, *newzone;
 	int dirty;
@@ -714,7 +714,7 @@ EXPORT_SYMBOL(folio_migrate_mapping);
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 				   struct folio *dst, struct folio *src)
 {
-	XA_STATE(xas, &mapping->i_pages, folio_index(src));
+	XA_STATE(xas, &mapping->i_pages, src->index);
 	int rc, expected_count = folio_expected_ref_count(src) + 1;
 
 	if (folio_ref_count(src) != expected_count)
diff --git a/mm/swap.h b/mm/swap.h
index 8d8efdf1297a..d034c13d8dd2 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -445,25 +445,4 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
 	return 0;
 }
 #endif /* CONFIG_SWAP */
-
-/**
- * folio_index - File index of a folio.
- * @folio: The folio.
- *
- * For a folio which is either in the page cache or the swap cache,
- * return its index within the address_space it belongs to.  If you know
- * the folio is definitely in the page cache, you can look at the folio's
- * index directly.
- *
- * Return: The index (offset in units of pages) of a folio in its file.
- */
-static inline pgoff_t folio_index(struct folio *folio)
-{
-#ifdef CONFIG_SWAP
-	if (unlikely(folio_test_swapcache(folio)))
-		return swp_offset(folio->swap);
-#endif
-	return folio->index;
-}
-
 #endif /* _MM_SWAP_H */

-- 
2.51.0


