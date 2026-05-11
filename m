Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A89ECD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C4A6B008A; Mon, 11 May 2026 03:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13CE6B008C; Mon, 11 May 2026 03:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50976B0092; Mon, 11 May 2026 03:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 968926B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:34:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F4DAA060B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:34:01 +0000 (UTC)
X-FDA: 84754325082.09.68D0051
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F27D100014
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:33:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L7XDCiAn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778484839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwxQWuscuSlOvfIaVW/y5JOMgvwD0lTwKLJaPKj4Tz0=;
	b=sDO9htDC/RD5sBQ/F3Mz+09Qot6IkD/05AiCTJaqhm09EscCMs0jvuR33HfQoB0kbEHahQ
	Ov/oN6wOffTmnTO/YSwBHOynz/ke0nc9jLt4jk9SFGJS/4merri+iEPus64HC/lcrhRUxG
	Ru4eNQJ5m3VPcFURAJ/z5A6GMkF07rI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778484839; a=rsa-sha256;
	cv=none;
	b=pilXVQwHBNjsxsTpQXziNdWhHtBQRJ0V5rJLMR2scaX//iejp788Y265yX4MvwC2AeE3Xk
	hhlAPbDNfAVdEmvYVwfj4fZDMathbGz3PqMSi5SsPK0dvAOPAFNXs8qBLgl9uYGrjAL8K2
	sNkC0OMrkSk/NbM2/dL8sRoGTXaY6pg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L7XDCiAn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778484837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QwxQWuscuSlOvfIaVW/y5JOMgvwD0lTwKLJaPKj4Tz0=;
	b=L7XDCiAn9cGkovp0tHRtBEkpbAkPsTafknLBru4J53shHav/HwmG2+SHIMsLLVVK06xBrs
	b4094Eg1cV8oyOVqiurdLGQqgTPqGH6+yIzFHzjHQqoKIf8VqxmzCA6URKv5cLoqjQES/5
	ABCShgdefJGM49WTxOsRC76JIqhJ+QI=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	chrisl@kernel.org,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v5 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Date: Mon, 11 May 2026 15:33:32 +0800
Message-ID: <20260511073334.635682-2-baoquan.he@linux.dev>
In-Reply-To: <20260511073334.635682-1-baoquan.he@linux.dev>
References: <20260511073334.635682-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F27D100014
X-Stat-Signature: qsrdjdwun4h9wowh11xqfzj5soruaboj
X-Rspam-User: 
X-HE-Tag: 1778484839-752745
X-HE-Meta: U2FsdGVkX18xmzuTfuf+9Oks2bmrVy5AskHWhlxJircd03amfDXVdAeAxVDvAWiTFuZCMMLQd8O31eE0cydgpOreXYcns1TFc90HUM/r/kO441Qxgqv7FzM8gGqYbuIw3QjOhjjy5NObCqT//Ma8t7eCVOt7wK03MOcPfbpvdbMRinEAk8NvUr4TsqBXHO4cOw1etuMLj/P0GsYgUI+oR+v5mfZ2SKWyWADiyrkgc/p8agfxqVuJeLZb32PuzkRkrE0ArNdcCVQpSdLv0021ZwJR/CjJdLgv5SZfdARWcOcrEtheAW//k3YrYMFVpkUyzOkzcPeD1ll1ZdpdXitvQyF9qiowCSZ6EHXqtmLhPqyIsY9GFzwXESqdVEWyvTQ5LrhqJYlebd+K23/2kwogGamaFcwcuTfWSkvEe0H+MMfVYlE8CFTg3IKZ84QyLoWU6y5STFB0p9fbOOaeXyUB0hgFV5XvFlOEoLB1tKe3PdjsVYsaNPOmZU6BTrofml7/DCmnKulhGUrlqVNcwxvM6EOl6FwxTV96hvESKirBbp9CaI3h3u3Lck0xeVjQCNpBfWaOjWMCB7kkFFt9AsLlI+uVwgBX75AdIU/lIOPHvI82+dPg7f+siXRou4fRDjAMoF1rl8knkPLPVv9q5DuTAKYlxTwirfSAoQTUKuMVYnrgmuB4ppUBZirJNE2wkftNpjXct76Tyhoj43DuuoIi4TySbMy/NTyOCLvefpxs3MiEzRyMWcfzUJbfqW1jrfEs3yQTjpdC4uF5+jnm+g70YtjFdEM/ob/fd+ljwrg9lc6MmKkEovAh2MV6TiHGsUrnhOqfweAN8DNAfauIdolY0Ah5ldtBdtqt4pKBcMG6f0PxCnDsxXxvn5Kyd+7cxydxXutoCr5R/yxQ3CQBhlIUA+22WHX0jwFMqQ9sa13KmB7La66AHgtDZZtwSg1+Hiir0MfXDj1aP63cFru5Wbm
 0txmcskU
 9zvOIdrf6ASMhuBFPGP8u7fKOQ82cAkBLiWG2cewwIRXtmdLb8iwWse5D9ygDs8Y1KZveaDgjPeBAxxKbaKAxJ1txNalPZrsuXr3Z6uDIbfUzhp7LBiZsBeY6IZiD5EDSG+ZJLXq6yWckf5NzB5rI3gvwQHzRkzqt48t5QrmZNDnnRLWUBzF55u+2swKcSpMrpWsEXB2Ax8+SziK5tf/d1YaKI+81jlhPKqFToglucjL2+IMDZMGonnZW3Qkzd/g4X419EKqP08dKPpgRkJRFODCc7KKyoOaKAI+7H/wsel0oBG9nrzZP1RrXDCyAnQvedLHR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Codes in mm/page_io.c are only related to swap io, it has
nothing to do with other page io.

Rename it to avoid confusion.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 MAINTAINERS                 | 2 +-
 mm/Makefile                 | 2 +-
 mm/swap.h                   | 2 +-
 mm/{page_io.c => swap_io.c} | 2 --
 4 files changed, 3 insertions(+), 5 deletions(-)
 rename mm/{page_io.c => swap_io.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index b2040011a386..4cc5fad4446f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17033,7 +17033,7 @@ F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
-F:	mm/page_io.c
+F:	mm/swap_io.c
 F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..a65ac900096a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -75,7 +75,7 @@ ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= swap_io.o swap_state.o swapfile.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b..161185057993 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -214,7 +214,7 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 					struct swap_cluster_info *ci,
 					unsigned int ci_off, unsigned int nr_pages);
 
-/* linux/mm/page_io.c */
+/* linux/mm/swap_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
diff --git a/mm/page_io.c b/mm/swap_io.c
similarity index 99%
rename from mm/page_io.c
rename to mm/swap_io.c
index 70cea9e24d2f..91b33d955e63 100644
--- a/mm/page_io.c
+++ b/mm/swap_io.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/mm/page_io.c
- *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  *
  *  Swap reorganised 29.12.95, 
-- 
2.52.0


