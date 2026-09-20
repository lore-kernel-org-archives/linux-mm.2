Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCE30C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB3A6B00A5; Sun, 20 Sep 2026 03:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3086B00A6; Sun, 20 Sep 2026 03:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10176B00A7; Sun, 20 Sep 2026 03:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2A76B00A5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D535803C0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:07 +0000 (UTC)
X-FDA: 85233296694.01.9DE71F6
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf18.hostedemail.com (Postfix) with ESMTP id 05A691C0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888925;
	b=Z9pY9NQNipOffAXq059B0b+/FZ93LisYQeA63iY3W9qP2/LwN4JgkyDf7AxD8UigRSCK2g
	QMCgp0alTsY3K5rwcPDRdE0+HdOa9+rclRkU5CIWK4b83ENVEANyXeZGD2MEybQHanHAoZ
	jzG1J8R0/a7ZaRVZr/xVDLLiyZP1eLA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ppr5K1TzBNX/hknZeB+J1139z1lGDAdnxHztQRGf+Co=;
	b=8JIc/A1jcNR4bfbn5G0/TZ0ZfZElBkrD9YaE4VgmwxwZA0nW/gJR2/j4Uasgj5pefKXan7
	71kdG+461f1PdfT52sj5iFu3WZZW3vU5Ds9q/flnhNdMPkwd1a7YJFDH518BBQdE/CpaeW
	sft4ilV2mo/r5iQesfM4soOgXn2/QiI=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id ae177dc060930043;
	Sun, 20 Sep 2026 07:22:03 +0000
X-Mizu-Trace-ID: ae177dc060930043
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 11/17] mm, swap: drop swap_folio_sector()
Date: Sun, 20 Sep 2026 15:20:37 +0800
Message-ID: <20260920072043.430390-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05A691C0008
X-Rspam-User: 
X-Stat-Signature: cyesszn7e1f5ge5j1emmz3u1g9cq8jon
X-HE-Tag: 1789888924-493950
X-HE-Meta: U2FsdGVkX1/gXjnYnIYgSv+PTBW0D0VIbenrG9ZHQzbPCBOmBlwXEPIHwTy8oq4zPqCY1d/zon/c+sW+htrPil/ix0BVePsZTKg14KnPLhRh6pT/u/CGcUcifuSpwuq+O2aVNW7q2G9/XvsX8Y3MeopaH4SDSKAAWPtIS4q4tG58GW32p1WD7VRh9DNqVx0+5/745z+5C2zV++Ble79cfdCWk9uKTyxObobdDCFXnqDpz6wwLYGuTCqcBujgGYZ+Ft/6BRdyRFqKX+h0dTLcmph+D+Ec2vIPTdPAIRDCMui3FWh4hOGh7IRJoDTet9a48zjJDhVUMcIq0kIKWv2zbz7lZf0s/qjPBZL/uSmnbs2UYfYtRAbUbhAjw/PYR4Jg5/DfEgcNC3yXGl56bHnBwNB8rG0DWhuwzo7aEy5X6ZwIci7ugvvokR1M/G0UJ8dZTLenPpFDGThKGO+9Fw1EEVJFVO1aBVTPovnuOPrQNjxPYtlEJUYVGKSit9yQrD62v6L1EZVR1SfFwVbtUWTi07DR3wic733LkoolBaxfRsGJmoJuPKCT8QtCJwpqwkqq0cJ+9x4R6O+dgc6lTTLExJh3YO7Dn/14xG07RNhfhXP63d7aFIFX7pNJRM4U+Ywtz6geRi3S2n7cQtexhsJQ0LVfZ89yf50GS20q3u+SJP7mO6t0ZgdGupB0sv78IVKGinpY6uph9Z2ZPiP8fA0HGEsZl8Yt43jgwprIs6Spmhp16JOBvaRRwIHp3+mo2IQzEOVYRIY12KXCny8o6igTK88GmU67upwTiOYN73RSvH17Vovp4+2Ni+Jfm/W6GZK1lL8i9uawnpbN4iEdw59DqAlrfYa1yxleXigXISuH+mE05PIJBhMedUeC0ImEu6LvWjAYpiqn0o25IKIaZS8nXVY2qOQk8BEZ4NbuM2pO/n2v+TYCJlv4QonVsKtSXE15NnSyYQrnq6IyJ2UYfxK
 uGbu7F8T
 0OptCoYUFeyRQ6d8SoLrq8hsLn3evv9r81XuF4eOfD2i8gkypXSfQpSGEjzA6xn7XGFd7yT6DmMTU3TK5K4Ux26oBoUTAkRolcjd01AmmzSsZZ81+8vGQ5jmzSB6rUk9wY2fOCy8Tm3lcVCO4AcjZo7QWaZPY9gQpHqHR+feFLmGimcEWfvKkBYPtCfPX+/VirNQRpZGMcjpDUQY2FTQy4N11aRJ465FSpCD1y8R0RgvQ/S1yMyW4CNNIk++hzBKkQtEEbn1pU+oU740YbYc7yV4BwR0ijdQOwo3UmA0QDfmnI2DmkRqZk8dgTj2otjPTzsXO/kGPJjB7n8NvEpovVKalYB6PIZtJj5rr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No one uses it now.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 13 -------------
 2 files changed, 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index b9a9a02007cf..188821b24e51 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -418,7 +418,6 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
 sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 852f10642b99..70ec544acd6b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -449,19 +449,6 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
 	BUG();
 }
 
-sector_t swap_folio_sector(struct folio *folio)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-	struct swap_extent *se;
-	sector_t sector;
-	pgoff_t offset;
-
-	offset = swp_offset(folio->swap);
-	se = offset_to_swap_extent(sis, offset);
-	sector = se->start_block + (offset - se->start_page);
-	return sector << (PAGE_SHIFT - 9);
-}
-
 sector_t swap_entry_sector(swp_entry_t entry)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(entry);
-- 
2.54.0


