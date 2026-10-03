Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E2CCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62336B00A9; Fri,  2 Oct 2026 21:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAC86B00AA; Fri,  2 Oct 2026 21:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBC16B00AB; Fri,  2 Oct 2026 21:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABB3C6B00A9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:00:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 321591208D0
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:41 +0000 (UTC)
X-FDA: 85279509882.02.2E4D1D4
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 47921180005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:00:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MS0BMKdWnYTCkKa1oauqX83Io7EV+orNelaoPPBUCpo=;
	b=cxEMOVFqs+VikslXXrquL7zknmn38iPM/irpnlyS83btcTrNMcapvVm/MX4Nm+m+krWHjY
	xCuSGLKm9vwNvZLTkuj8h4yDSYtj/f1tj729c4+ODZsO1vsSrPiN6jQ8Oc4XMmaZ6e40DW
	MO4UkYZOtUulwYH/Fu0QuR5qlUnvTp0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989239;
	b=cD5nPjATDVoxn7YpnBb9vMLOq6g4KIC7jkuz9cOEkWoWQaqOHTfDjawKdRPr/BR7tECvdK
	9oixPERbOOkqi0mP8bwGRa1tRbc+tbgtYowhbIxwIm3nNMZB0jEYjBsiO/lQrKujiuXFgq
	KsRMfO7DDJg4ZV9zzzdSK5r83enKrQI=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bf248e880b12112f;
	Sat, 03 Oct 2026 01:00:37 +0000
X-Mizu-Trace-ID: bf248e880b12112f
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
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 11/12] mm, swap: drop swap_folio_sector()
Date: Sat,  3 Oct 2026 08:58:59 +0800
Message-ID: <20261003005900.909710-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ax3e157zehqyum13npjybtpic1ygaip
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47921180005
X-HE-Tag: 1790989239-277595
X-HE-Meta: U2FsdGVkX1/K3Bv1YOSsMwFapXbb54fvaGvJJfy6sD+Ktx0GaJ6j3wyt/TvCS1hhVSdXBZM5u3Ce2lwe3y+Cgxkcd+JCSIl3l54qvI/ryXIx4HHNz86EYALpwPtZuEfGWsjrRzxJVZ0kLAcC5lumRyffDK6hF+fef7rm14Xb7VomcFUwP04w5L7C9GeeJCWIql3UTMQH/nBFILlu9hCUH8MfgykSYl4pCTa4wR0wvC3U3kPgx9OIQP2CVVqKw/yrQ4GVOqHOl1j2EhVXquT60Ub/pCDbPTtcgwYkRYCtowv7jJZTZAiswHQrhqbPYTvSL/SQEgNIazotd7FruaUCO9i7czCF4XKgtTLKjI1qSvYE/kYsHuhPpNz05ya5qS3gZhwOoACzR31FC+Bec5YZSFbSPPki7PlrznkOQjZbgW6F4BnXYbNXqwbkEUGoKQDvosrgKE/bPsD3QlJBAF6OUKAGO+KOpGa0Izl6vwgRFqYAm8/TpaCysSEpSvo3eZj8KlhPaloEqUM/WF/5PahY1ur4iCDlOkFTR0Z+RcAAvX9Mn7QmXxkUEU24Hwov5Irz9AkrwZAZ8T9zpzckAIgpVkAchuGNtRCNvPrIiwIMjDHfNaetPFGlMj5MoarSiNPlqBcqwbFfAI5wcMb7LDBzS3jFMU26/likA3cdJA2YXeV1ys6bQ4U1Pki0AzGR4BRozemdbstfZJTIwGmzaHBfCAbjPUAe9pYKwKwF22yeIw3bNRQBGkKZGIcqjULZWkTi88hOnoXcDeqK1xZ1syP2o1KTR0BNlQ0gW3pmm4tLgf7jyNHJUJ3SUwLnlVzlsq1qXC+P62Tzmn88SVB0Anv8QX3zzNhEVY1BfikwV2rMLGtvIOM27s6C+NdiAnfRtR+ZNUVfyqb8qEw1ifhnd9jdj5/f66IosCv0Tek+IDA15Zc9N3jJdOo0LHtGIe14c7xZB7wEZ+sjQJwGEzKv0a5
 tFgk79mO
 GlOu11tgG5uhXS8tfsVeVWz/i949QGW730DxzK95oSMIoPjtR38dSnt/lSljYs1Q+sWhHFQBhUAt6YH3Oy32mhyPuoNIGOG7jt5RB01ilaTW/JXEURMd8dXCZVkT+yA58PgqGhFztsr0Z9IW8QD/CpNm8/64Kk+DJCnvbJyWPECCeX87vAah96eIFWRYM04hY7fIY/QkfRoNi3K+kvMvenq7j498ZhsRh3PYu7x6gMB6REu3plkOxiJM4Vah92ii1ofVgti1DuWqK+04ymL3Gurgj/YC6zKS24W5pGWmB1DZ8NqFdo6cvbLkKM84Cxii7mOFLyuiMC/HVOuOZUGjrLzzA0g==
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
index 2080540c6e39..e78717327126 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -417,7 +417,6 @@ extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
-sector_t swap_folio_sector(struct folio *folio);
 sector_t swap_entry_sector(swp_entry_t entry);
 
 /*
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8e6b0cb899e5..c63f1c641035 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -541,19 +541,6 @@ offset_to_swap_extent(struct swap_info_struct *sis, unsigned long offset)
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


