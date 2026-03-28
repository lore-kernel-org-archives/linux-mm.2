Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FF310BA421
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 07:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98CF6B0095; Sat, 28 Mar 2026 03:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46FC6B0096; Sat, 28 Mar 2026 03:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E856B0098; Sat, 28 Mar 2026 03:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBF706B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:58:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4436E8ACE1
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:35 +0000 (UTC)
X-FDA: 84594719790.07.C3C2C9E
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 631CE180002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BebTtUlf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774684713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKpGcstS/0r6pcN7g7yDWWC+rizREJIM53YHk6Swx4o=;
	b=ieNxqudH+GV5SOWcT+dye4PXaXkoYHNtKFHyX52Kv0PcXXMgzzSWIH/JGYq9fM6q1Yealv
	efxSl9+50h+LHXO6bXdNor7o4dO4PaTawzskrkV7rHsEw/bMB7WB5E5sQRJuHh+wacGINL
	Tr/PTr1gYGnIICsWijHCVG5ugrdFBxY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774684713; a=rsa-sha256;
	cv=none;
	b=7UOIEm5fo630nCQTb3QcnscA8BQLh6unkbPRQAASelJddwwQK1OqbqCewW5THnAu0LUGEe
	+Vx6qZ+jYQhl7TWiTQIj29hXw5dIkBSoPj19xxuHFOYX6TDX36ZPvCQ8lKcCaivntPaQFl
	QDLoI5S5UTcy9EVX3IWiZe+9PyR8LjM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BebTtUlf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82c20b9fb15so1349632b3a.3
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774684712; x=1775289512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKpGcstS/0r6pcN7g7yDWWC+rizREJIM53YHk6Swx4o=;
        b=BebTtUlfZJO4/uZP6X37azXLkp/sVUcQc+/tFGk/fT7SR1Wqpn2jKUqiWC+3a/w3cE
         U0jqFXQB53C8PmEFF4sVUNCSvjWL16J0F/RjPwtofpotbKIMk5GKFW/zkzEzCsQKJ7Qa
         1K1QjpQbQFGpGRuuc8LgPALnspfC+1Py98MiAguY+aKOjJoiZNOewjtrcrhOJiKXNh0a
         N5ctXVKpG44sL+oQNhXaR4wDF+lm+iGqHgWbdySHY3OTY1liUAX080+xxVLzqauIa1Wz
         070XYCoaavs7+sUS7X7mKMc+kYh/t6rWolfz2YO+KT9BD+V+XkQ2yxyLckUutx9h6uB+
         Hiyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774684712; x=1775289512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zKpGcstS/0r6pcN7g7yDWWC+rizREJIM53YHk6Swx4o=;
        b=pg6HDo0G3g3X7ApsuYjgDgc5voLheDogsHd1POyfE7GeaCBya8VHIbGHiyELN3lr9p
         21dgh6vq23+EOcxt3Mp3JZqMPnSgkRowB5gtqjqKzRHFpFBJqrQiae+sgKc8xaWq4ZNv
         ib4mC51t6vQK1H1Ji0C7f9BlqOaeNiL8iOgGg5igBcPL8ZmKISmghl3hCoxRiqIS5x6+
         eKoYi2IzEmDB5mTyWEjldUOLXmF+XZ99gI9TkLJCYNpw9ncc9MVJ1+9wFMtuz0rEwFDv
         3EuyticzQgjXTzopBSDyXQg4YZUDGIqJhGLBdAePWmUJRNEOqV8Zzs5+wTB0r7W4nwO4
         BjjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUwzcnNJhh+0Gfk77oHB9nzLitkUwQOrwoBRuiPFcdUoEH2hQWzXw3x9B7XvHkM4o6KmoZci9slw==@kvack.org
X-Gm-Message-State: AOJu0YwFey1rL+atl8ZJB9YrnBha9jf852t3hSrru8hHGtjSA29s4fnd
	VB18BE5matvBfy+wLCNxJG9fGhAnfoqkaWsD/iwDmSDECSvg34FB92hO
X-Gm-Gg: ATEYQzw0bA/UVtDqz/rhnNnk4eoRGEKqLoIusjg3kFCITDTx3j3ZUf3aGX1MHF2s4kX
	K+JmRAr2yRB/wxHmV17VDHZvWVFGCSy0EAxZjAih+WczVtpXBvOnqDgpsoz7tMHbcftxvIgAElN
	PXDjJg4yNBx6x4g2ARDd0tnv6RZMWd40kKVlU/M778RP1MWCTDdpYVTGzVvmAdU/O59NMXUR9wM
	6341EfN8xvDMXiH+1i0WPobIFqO8FYzZKm+Ot1YBhFTHx9KuyceNaowdh/i0uUbytUz/oBK+16f
	w1Zr4Y9ghSZMdLOB0s8vYGQVNYaHvc3+hvlFFTxtNmymwb9Ni5ZtyIq+c3h6DghadJrEzAWff2X
	aWlPclFP0Nq84quSJxQDtMeKxFSvflIQvevVhU6+++WhAvGgOa5JSGbDTcBPcsBlqIYFkvx3MYj
	iAZgDZxKoblP44Z4eBh40qdSNARP29nWPPRMEs2f0FSnHnZj0Zs/MIpcZK+QYT91TAO9XYaoA31
	h4n+czweb/uNe9J
X-Received: by 2002:a05:6a00:2d27:b0:82a:1337:493c with SMTP id d2e1a72fcca58-82c95e9559amr5362098b3a.14.1774684711943;
        Sat, 28 Mar 2026 00:58:31 -0700 (PDT)
Received: from Barrys-MBP.bbrouter ([2409:8a1e:2e90:6fa0:903d:bf86:180e:c711])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca84644d9sm1448312b3a.13.2026.03.28.00.58.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Mar 2026 00:58:31 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Date: Sat, 28 Mar 2026 15:58:10 +0800
Message-Id: <20260328075812.11060-2-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260328075812.11060-1-21cnbao@gmail.com>
References: <20260328075812.11060-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 631CE180002
X-Stat-Signature: kp7t8dg1bnn7iqhu4chnsqxfiy5dwodn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774684713-140353
X-HE-Meta: U2FsdGVkX19otXeSGEGFsl73+tKd3bArC2+7GTfcFCJ35wSYG6pfsFs32eajxn5EGbSpZ9Wm/dUV9vtWlKQPI3wptdIylWwu8wAkvT+ueHhdXmaenLpGpycAm+gtQ9qeG+7ML9bQQjZlTsFMB1duxZ/JU6SS2SS3wDJRvJrFTgl4tWIw7Z0i99jpFhLDnqTvTHx/6cR4iUsZ6d3kwJNFawoHkfpzlteZceZ/h8Qn57GzAwb/PzlXeYoZedyu1S2+zFIAhNauK8vefy9o7pejWNMi9B6k/bliU4TKEjAynfNWvtOPS+EZ/F6WuNNxXUFoMTK4aZzDQUBDB2slRSpasn4uDlzRHWIUImbZfJ3eDn1KI+2iI20b6rA6VMx1+xxzmktS65FKcZ7zS/ULxleJWNIkz/tlwZzxu9SmOooS3lzpb0rniMw/n4ErV8LBrVKnxksPsfCmr3MqirCF2w9WVWdh1xboozNLYybaoNE3C+v6cUJ7jGBnXN2LBDOZgnAjwYXTfIS69m6OeVEgAfjcR7DeSAcILSp6E8w2EGYkaLbBz4Q30ERE9eqj73UIPJacOcWzYc4DqGS1T86vJ/sltFWiXeYpZn019w1T8YHc3iNqjXsoWja7v9qer8bjWa/YN75L0rcg2kK3FBCyMOnVowmoQF2FOFXc/V8GGFjeiNSPWdpN2suYfm4S4Xq/HGkGODKAJGCGLusmSlG00/5ExPLviI8Q1xgM26vOaD3QwdQLHE4pTMCF9wQbmrF9FJ2upplfiopyxy1wTjrKih8Tjb9xtzSL6wqZW97Kpzh4LdKb/H3iybIeWp1CSzlFAkqoN0AHREyipnL2EGI8Nn7qifM/MP2D6pTAQZuYEQj4pXGy5OKvmMLi1zvTRORO86WTcbMObAFRISMofu4UQMRTJDdK4gYC3KFCZB0gZreKmqOMo5gGNrNoPXEkcxwMaFeWjn3Rk+C7Hmba6g7bxb/
 +4Uvhtad
 fR8lwgRdDsY0GjzuMP2rH6UIf3/VolVIhQAk8drh0lNGqVjvHniyztxY1Vm7EwfHYoCUiMp5N2SAp1Qdc1kyi1nUsEE3YYOwuFfQT3u8g59bKH8gAkyOm1NgWEgc19Kw288mpYjrhVM9e6JpLwhJpNPBrXyYoogbO1mJBp/MyG3qxLQtzcXnfKcM6I0pn9i0QdO7gmIua0fSB4JDAjMRIFMv7zeF9bnODo0Wzmlelhzw1dDAoWt2tbHK1GXMo9x3ucBySLDJaOGZzOsKgHHx5KN43pN7FdWAJC/xOGnjkdFYeD6+cX4HdsZz3lRRUOnV9N17pmJ6+OCbwMDDP6iAVodC1l31bi/0Qnh0rTvLbJ2NSxcPH81dFrPSZ88qeVSagjB1gYfoflSngzP/S93JFngpGDrE5emxHLSqZRnrqP7O4hWVqZA+y0PifbbMN3RtIfLzkod0l2XBeI47ibHaGjoUV2fPwT9vdS6GoZRf5xPOYG/uTxUdls3bmMYNedlDoUe5rLBJ/UbTN/UZOQN2EAsxiSaV9okjmMnKION955Pu7tUO24akCdEx0RK5xJ3ePIbQB3c2ZN+Gh/Wi7Yirvl87reKsqhF3sJemuokOGojm8wbrW+OcL8Bpf2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baoquan He <bhe@redhat.com>

Codes in mm/page_io.c are only related to swap io, it has
nothing to do with other page io.

Rename it to avoid confusion.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 MAINTAINERS                 | 2 +-
 mm/Makefile                 | 2 +-
 mm/swap.h                   | 2 +-
 mm/{page_io.c => swap_io.c} | 2 --
 4 files changed, 3 insertions(+), 5 deletions(-)
 rename mm/{page_io.c => swap_io.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 16874c32e288..bb7c1031886d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16915,7 +16915,7 @@ F:	Documentation/mm/swap-table.rst
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
2.39.3 (Apple Git-146)


