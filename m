Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B78BCD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3E16B0093; Tue, 12 May 2026 06:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D7E6B0095; Tue, 12 May 2026 06:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25616B0096; Tue, 12 May 2026 06:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDECF6B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:42:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 629D94045E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:20 +0000 (UTC)
X-FDA: 84758428440.22.74DC91F
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D8E840007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/ghAxl2";
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3lf2RIQBzCBN9+5LnXZu2FjSHtByyMOG2IjSa32/uY=;
	b=pIcm1gzOx6LqX7//M6/Qutq4lu1LMtJ8eHvl2eXxih6bQN04QMnXKBQ2n0pxSR3xjCWSVT
	Cp7/6YIcJBooLaoA9u9rpYceQuuGE2nPI3PVggm0Pc8p/PvmiDW5qRTcyNLGdsiU0Mo9bE
	Pf39nsPHQIQZ7cowhWGshY56l2UqX9Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/ghAxl2";
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582538; a=rsa-sha256;
	cv=none;
	b=Rhw65WpZMSpjlpqU03dqWlO63BiO/O/evI4KuZbSHlPDfrQPcRvWLfBFzzkTe2xYj3e3Pd
	JcwPK0oz4guLU3qULAF8GynoyXh5ZOkx8dpEac6/O4akazdQwuy+2QdmASk+ZiA7jMcfOR
	dktXhp5uoAV4d79PrZQE3U/17g+xVCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778582536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m3lf2RIQBzCBN9+5LnXZu2FjSHtByyMOG2IjSa32/uY=;
	b=T/ghAxl26IJ5Y9Hz6rktTE7EgP0sqc7106o5MYtSEX/93cpAaaQcyUulVTHR49tgz4S0ze
	grNbQQnWIPc2hNNckZ2pUz/R9Ac2tCWbqP9Sr70cnsv8u/SVkLDpiESeUcO4tpEVjYq11F
	RL9YkUdGDcIxMo9DrrZ8kHM89FWArSk=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v6 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Date: Tue, 12 May 2026 18:41:59 +0800
Message-ID: <20260512104201.716213-2-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-1-baoquan.he@linux.dev>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3ufyisfpt18jf8zzcndxw14bi7p8jp5e
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D8E840007
X-Rspam-User: 
X-HE-Tag: 1778582538-809328
X-HE-Meta: U2FsdGVkX1/keQrbaAMMXFRz3eeHlnGfvPtR301Ld636bqA9jZNUN4c+7Yqp7mmldhdLkx0NHDZc3j0Ia5dokfjDGjyCa1aDmrVRHn2V+8UWb04C7co6kCJTFc5tAidoAXHOoLK0jWBGHqA/w8HbtXH10q33BfhnGnede+tbIoXzHHCFVKwFZD+0wlWjOe6AO9bU8fCEIPqvbjBSfhCKZBJIooiTShKxZCuQ5C22puOEMY9+PH4gJChCYhOb1AiruB74gbI8q5aMs9rujKIhV/D2532rXXYUEyTQ9j+5Bvxx+mjlqifUfGQ8D6pV5JuNktYN22jwg1C3+EKJqZEPCwv+zr491K8bPeY1oshMJRfNR58I84p27By4kgo+v0aIJHUOhi9XVkrruvX4ch2QY7VBPyx9X1xOuvJBKB65QDLzHbD0WF40uxBVK4UCcIrpZimtu7AkG4wt91Sw1/oZLMOfIna+THf0a+Uz0HvBFNwmAjSyVHtbvvh+Hn+zCl36mycB59mB80QqaX9gbyKloIYgkwJkCTyyKUzLQTGgatRUemluD+Fn5bj9ujfGfc4xdrHgvfMD615Z2u/AoXR+lF6PV89FxmTYPIyysnQh7xNHnNcuYWxb+33fdtrbQp2fq0z7w70e/Z588Qzu9M5rB3bIxcXQ/wS015yRHp9+/ZuzEHCfXvFmRJCeSIjzP+9kQ8Onc9NqBK/93KQ6mWNU6L1S63QyyFzFjPJtB4uL818O87Rlodt1Uo1I0iAdNo94huDETuzEP0G/L4vVxLnxWa5rYrcxWjZsGjXu5PxCNc+UqjjuBAnKo/jX7QytxK3LUL9gtrIs8x1M5LJLvKiKKhgIJjFqhWrltycu5sqaXBgVuRd6n2cLIU5nDzDtyxVSa/2z5oYlNIKbFSmoqBSbPOv6EoqbTfLmt7xu/547CtAynoLkC1p50xw3ZOGASJdW6KzL7jgYqCuFjtzO34o
 GgD+/L9Z
 8Gj1d6W8LaJoepIqmfeYrqMFxJLdAkqE/qo8q4cDUzMyaFUtW1EVJjmbHuBde9J/SbxLwfMNdcX6L0MEkpoUdh/OMv/9GXjpAcw86QQFQh8K5fIhSb/xhpuuSggbkiWDBJBsrUw+ruPM5s1O6Vz5qeKAfEqmEUt9+0/7keS86KeJyCa8hZRfPM65BOiMZLY1iDkqffenzAzc/6SrTyT3UjzccQNjDdK7tAnqMncaz+OMCv2mgUomKPM5XDb6IXhVii3Diz1bbjq8bZ3kHiW4Ogw0m0VKJwjkr8DTCPQXJJzmcvDCw1Vzun8BNSQ==
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
index 98d0a7a1c689..b7746b359471 100644
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
index 7ed76592e20d..7c1a3a3a53f8 100644
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


