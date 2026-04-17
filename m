Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D696F8E499
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98206B0089; Thu, 16 Apr 2026 23:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47D66B008A; Thu, 16 Apr 2026 23:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DD16B008C; Thu, 16 Apr 2026 23:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 849006B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:40:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CA058CAFE
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:17 +0000 (UTC)
X-FDA: 84666644874.17.5282180
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 61488140002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKcV3wAV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776397215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HAo61uBKpFz6MK3WD95e+rqHXxilBo9frJ5Jqo/JHM=;
	b=ScOZeqLtvZ2eMgw88v02cuBI7Fqq16N6IO384RgBItMS4Mu5k2Vf3XwpAZnZRBxX5pwd79
	fPmueqxRd+rtdmwxzlpktWfh8LNCfa0G6zJ2HuWcC2tYnWqh1Ah+wXNsgF95hzSTR2HlcT
	2VVEHA2axwec5hXm100OXrDDGYIkl0w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKcV3wAV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776397215; a=rsa-sha256;
	cv=none;
	b=5GqvxJNmUUPH+DnKUkevJWlT3/Vu85ldMC0ED7X+n1PtR+6twjAehBRgoCmdfZfen/BMrv
	xBEjOKgHgJRDz3ZlBmtEqM+SwCFVjIeK67IATk1id9L7WNu7aTmzjvq5B/1BGX6UXdyUAl
	sp9z9pWJiEEyC1yW38qNRyejWi8jhOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776397213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HAo61uBKpFz6MK3WD95e+rqHXxilBo9frJ5Jqo/JHM=;
	b=pKcV3wAVNa2aMZsNf6QIOIGIeLvhbX5oaOMCbSNsF+DiEX1JOmeqYmXUsjBfP3bhu6Hp00
	3C74ji4TmR7Y04vTi/Ig0/oZ8Fvp98QDmfskN2QnlE2akNsNVNCj356Vz3E6G00IC+C0RN
	7TvpSzI/Nk7H+hsiSTefYjLcjCz3NLY=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v4 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Date: Fri, 17 Apr 2026 11:39:49 +0800
Message-ID: <20260417033951.1111038-2-baoquan.he@linux.dev>
In-Reply-To: <20260417033951.1111038-1-baoquan.he@linux.dev>
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61488140002
X-Stat-Signature: i794h5q1hcx69hujmfpc9r9h6w6jphms
X-Rspam-User: 
X-HE-Tag: 1776397215-328241
X-HE-Meta: U2FsdGVkX19cfN1+jMhZDDWiYBxCK0zxYNSqyYTOKPmeBDaQsbueoc2/0yC6PU6dJMTGSIx1om248md16Lg0Z5QNEMBgs6aV/RJzkPvu++Xcg6rOYrMcs5hfGqQhjTp1X21GH/z2/l+UD1TPDsKQbHPvkVyIR8FDDQLwIblx9AcAMqSmsERmUC4G3vn63IxwJcCooAYgJsb7KaXUrHYmAyc+0hscIA2mBUEXdh5yi3RK2VcHceOPLzENkHqNiz1RIIl/P7m3n7eMp7QwmMltdpRzniqbiPktDiTELErQZ+M4u/orCaLAdcPhX74AQg8MlfinMhurXTBrANdbD0QvH7uEvb11oAWPKEBGuDfJp3hcqT9yKh5B/nlTV/M0UWHwroIqnCb8FwaV180S9Z3yL1a0UiDyI28EO5CmF01Ay95oxWdpXyMrkK5893BRN5E88IkumEudM2eOKsMcnLMdLLj41aeip+KNZYdZcth3kfQX0rVx/hUotQJnNKy3LAwQOeLb+8c1bLOwDt6dusKd1jqvbLNDoUKde8dXPwSiRHGynCorKQlzHeDfklg4fgWeyGZ11zqjacuU0Hwtep0hxpSYgbFz20PQf1YHgCzchZX1mwsQI8J3M6XVmPTmYgP3530+sA2mwGUUS9PJpMTFx8sgh9qffPTyZ4NoO5PsQhhfeibVpKoCV7ZTwuutoFY8yJVbfUwA7mUMy+Urut26QarZdAJuGvvjG4KBnDkqQTD1qgFVzBZuZALTqBjgtAL+s9L2ntIrGtaITjyAUbXh16Dx+ziQqaLGWZslnNppIR3J3DhADRes2YiRqFJyQrNvBotSjGwyjhxdNspqcF9M1xlRJvwo5asOGbOsaRq3iTgE20yTnaklnuauHBovQZeM7nGzWOpsC99GIUp3Cz4G6FyYvG/hYfsU9XiOdMTJ1LbvgTzwPPpVc+rR74G8v09Gv4+QbojbdF5RW2qe1bW
 +eDcVtBg
 9vajk/uX73/e6/K2pdD/A1qjCn7dSzw9wUa7ano/LkbP2UOg9wYIMJOGeaC9rbEf5mglbgb9eUph5ALd+BiIkW0Eg69Ai+0x8EAHletmYcX11mF6QGcBZe3PznF2b9exzVvRM3fW48rxwJVA2jdNmF893PCf1OHGm4oUPdw7d0SSdeDRiwYkgyK9lQqHtSgQHVoMPu/TT9XLGz2cRkPmh8Ab2bqb1COvjk4+jop9d83f7mFVwII15krePZG7hmvTnt0gOXLo61CK0hcENECt+Q6Ze2vbt0BU7xSLrWczZgQ7jNjO2Ayzk4XUuL0OeDS2prYdj
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
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 MAINTAINERS                 | 2 +-
 mm/Makefile                 | 2 +-
 mm/swap.h                   | 2 +-
 mm/{page_io.c => swap_io.c} | 2 --
 4 files changed, 3 insertions(+), 5 deletions(-)
 rename mm/{page_io.c => swap_io.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 447189411512..c7b5b6f5fa50 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17002,7 +17002,7 @@ F:	Documentation/mm/swap-table.rst
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
index 330abc5ab7b4..a62c02ab0551 100644
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


