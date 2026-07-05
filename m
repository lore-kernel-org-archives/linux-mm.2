Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08244C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 14:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35CC6B00A2; Sun,  5 Jul 2026 10:13:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D4C6B00A4; Sun,  5 Jul 2026 10:13:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23A26B00A5; Sun,  5 Jul 2026 10:13:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 771C56B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 10:13:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06594A00FF
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:25 +0000 (UTC)
X-FDA: 84954915570.18.165B46F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28F6D180004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgd6A0hb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783260803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1aah+v1fwTFgbFWRTfwbYRHEyBQupbQOxJrOmO9ni0=;
	b=zVEJqdxDHSOYmIciJcDGieofnc3JcBAw4IKugwJ+vebvySJGIuz9mrQ9cEnqAoGv3Y4CwR
	hPJQHpwPmX0zgLYeL9gFqev5fDLsKVPxq5RqHm0/rC1y52g3dcOJqLTXtYPX1e0I3+fhwy
	kRuDiiWibOsS9QbJnFgUbZUqTQmdFJQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgd6A0hb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783260803;
	b=8rMinr5Jo1W6p63nQC0xcBpWe8vnHKnBP1gx4WtQcqgWrK4goz+sU29NQnIFGakw5YrltW
	U4kfNU9lP1Z3mfY+LwAcJTPA3uIBgmcpukK4naQkXQIuWHB/6vIPb7Y98G5jV2J1HvKT64
	Qh/2h6eG2jqC8EvMpBy8xcJHQ5nuk7s=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc61541f8cso12654035ad.0
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 07:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783260802; x=1783865602; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1aah+v1fwTFgbFWRTfwbYRHEyBQupbQOxJrOmO9ni0=;
        b=rgd6A0hb8uvJLFT6enCPv5tWR+gbbbBL6dvLHgAw6ILixCA8DGlfhkUTo6+BNnsXui
         95VQdCNeAmEHrFm0hJZl64ksS7G7KabyCksl5GWsPCyeS1cb4w7G69whyrkd7YzgHw9Z
         vtv/MNA5NYTjjGqoBmBQLSZDXHonTLnBO0k3p4dBkO5GDpNXlXUahjYF04hMYxhQA0Em
         NxPKgnSfwsapH6IdT+h1G8/P5L4B9AAp35zhYKZ2fMEwGMrqGDddip0L89KMPrPMOF5Q
         ZKC0yacwEUl4IhOopv4SUssopeaoPn6UbNss55iCwuzZ0ZbbJXCpT7OIH8INnp7YSmZy
         YIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783260802; x=1783865602;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e1aah+v1fwTFgbFWRTfwbYRHEyBQupbQOxJrOmO9ni0=;
        b=c8+ysFTZlcupQYsUU7zYKwSXIxRPpxdwUlJ87Hs7ne29S0AWr943JGy78kipAnAOL5
         UfA07sxHuczWqIclqnk4bRSWNEtk5rWMsvEWTNZAqpS051yND83JM3EhbK7fKCp15YtG
         PoA2s89Wi0mHrx72SAcnO2dLaVnJ/gxmkTCbfTBlcf3+7MKSTzgV3q03UTXBsZ/CGSka
         gBYeuxR+832P0qB5yFry2TYBKUPjdeFc46cd5G83a6+5/rqjbN08cumDkCqVuema4sfr
         UJzQeTL+PFrbWV/ppqGXQa0xhl6krityKYcuhXCDm+99i9jyUhwzFx6lg5zArahwmz9d
         eZSA==
X-Gm-Message-State: AOJu0YxNX3S4YBUuUUb0+eXEHWR7oBNJ/nlzOgqT4zDe3KkQ9OIhHpz/
	huecFZHv/hbaU+TklYf0k3Rw7EALeXL39KwXSX1iLsaNRup8Qg8FRTc/
X-Gm-Gg: AfdE7cma5kF3AICF0h4qqgBxQxRifqCBoG5PESKI+R5Z449mWnmjYGFQEem9taEXNHM
	8vGnPlTkwUG8Gkqi9fJh45o07Rjllkz11X0cT9aCf5F1X788lGNd2y441Eq0Al/y+KxVtvVYHRt
	N6nBy/l1skRy4OcWJBmFHZN4uJbXRlBDHCGXkOxVCr0ElnCAiWmGBRQgTeLEaZU5kvEpt9SaJnZ
	K/MPJqqJ/z8s4LS3XT25cA5HQTnfhx3MGZJSO9FPxO0sV7IZFGLR1nxJjfGu6CO1bqx4IFNdD/O
	vMOn5L0syr9dShWOtJXRT9ayDyoDv5YrPODzfoNfGMUPYEzV4hkTAuu4qMP2g4OpYS8uO1Fz5VD
	rFpWfV/SJ5yCQTelOX4En8EOoiNLI66rmlcQtDfETrgN+SK6HnxhT1m7nNdPxI0OlmQPjMp8A14
	wV7LO9mJrKsUbdDhUnJzlgoqPpzxeKWfAE9Pck1eUab8wh6VW5j9tXTsjAVcwo+ty7Xznni6/EA
	Q==
X-Received: by 2002:a17:903:943:b0:2c9:97a7:3283 with SMTP id d9443c01a7336-2cc0b241bfdmr47850655ad.23.1783260802010;
        Sun, 05 Jul 2026 07:13:22 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6f260basm34169155ad.16.2026.07.05.07.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 07:13:21 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 05 Jul 2026 22:12:32 +0800
Subject: [PATCH v7 2/3] mm: rename swap.c to folio.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-2-a028e8b5fc3d@gmail.com>
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783260776; l=4030;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=gZdtwf9QOc/tBmuNw32enXCtInpJnxCz76ZA5ZAemXA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNRqFSXfwbK9+JX7YECaRc8sMpjCXwvoabrB1f6fYYyNqfm8TAK6hO4MmqqaT6fNBJktyFHSgMt
 AzhPH0rK9Kwc=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: i9s3frbe93icdnmrxx9up9en5ifjikua
X-Rspamd-Queue-Id: 28F6D180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783260803-402526
X-HE-Meta: U2FsdGVkX1/gqIyqYUG2SobAvxahsyqvAEV71rrF/2PDjZU1Fb9Ubl5SiCOcYhlReji0kgWl4NM6NG5TEWGMtc2ajTQ4nes9Sae0bbF5FdleWmBDgkD8oW8n8Q6riabJq5gt84ewK3vT6/egwuBqv6KEn6m6ASU9DbmFlNsc3ESOmUlHpmqofrOp5+UkB0cSp6d0VJiBX0xgss0Yi56OzQzxAooUikxeeXaziqmkdNNfNONCrS6YvpLEDmyh40iNJrcB44GOyu6impu6tqBYp2SJrexMfw8p97bqQ+A3119C7IUepEg3eixINk4R6H1IDdakD4BTa/zQ91xNi7c2+vHU1iQ1TpHw4FzGYdbDQ7u/PUffqJ0CDpfKqkDNRXQmu/glgp47p991TdNNQdSlN1DMuR+/h1z01zifBJaDcYeVrobqXhQwIH5D+eaZ0g7loB8y7X4Wtp6CyvSv36lPBm2mB/WjN+G652jPqwmVh9ihZiAxOX7j1UR3pwjXdAqh1m/vqUYPNiGHb+d+F3/RgLM2O6OKLscmkCAHjYZpEGOx7aNXBZGPI+2pRUhaGLQJhaiMwrsHaTR0L18F55+L/clI59/HphBl5lOGTAMeQntUOhXs9NASl2ui4jOQb/yGyFERHeikGROj58h+Tg1oQq9/xrBriiRI0DcFPW/ifIn/rTiRg4awISIEbakoCPI6/J77TtisRZ9zKQIJ/f3XWqMhOZXDlbjZHydOufDnI5FVP97DNRCT/DfNJfSryi/3DFz78fXSVF9ykGyaSv2ogYZI7nLIUcmQxhk2fEel7wY0C+tbLP9pDKWGjMKUs2ukLNDMvtaLyPZE+GVYZ2WApjbwmJd+pr7qWN6XtSBnU7A84iZ/+XNFuzoWFc6/jPf+tvw+SvH2Ni6QOjm+T9ORKKEwg3t35D5OcGbImKCljh0nRfII3e3IV1k0UgYI8wBmwcZlX7zhFFtgB4Osx2n
 WCSM2Njq
 cckzImkOWSMYLeI/MRmQBtI6HOvgTWLEToATl/xCkPzZJ2tN1Gdq4LAW2RDorC+M8DYTC1wESXWIF9x6NNjDoyYDsQoJAgBtPwcdV6EslW09L0TUQP1Yrck2R8Na9CxvtFu2Bwh14eCrCucQh2cRpDKBGxrAhnF4ZoJ+XrdrJn5nBX7IdxJyrajLa8+Fr6mH4CgicCYmN3FL5UbOJU4g3R0pbkcAoGVh0y+w4nyJgWyfvk9h8X1w+3hIXeVtZUlQ+fF1V6FAGh9na//FjrCnC2BeZw+HAvhvAG45c8gFWsddhZkjU6sh/zO74oORCds26CkIq6ZcAeopaFC7yBovtcupx6W2TJV5n44aLAuu4nX9NPCNRgnVxygpbH/mXy5dmgUsgvMaqmdI0AozrTbTyHwjJTZvk00IqZTxUHCStzB+hsB2sm5bDMFQx0XLKzqanb0Sk4wRDEMFEciMh/pi26xdyxBG7np95VcoCc6GIngXmexqebDI1cutzx8+Z4+IXsyXoFGw7lSxtE5Qerw7lKo8S+xiKDRa8VaDmm0Re45+3zL5gPsmFK8zNCldIcWlQz5GJXMBkTbw50cDY1qgrOR2aVBrNYMcEPiptyPqg0cNnujI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename mm/swap.c to mm/folio.c so the filename better matches
the code's main responsibility.

This keeps the implementation split from swap-specific code without
changing the published LRU helper interfaces.

Update MAINTAINERS and the remaining mm/swap.c documentation references
after the rename.

Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst |  3 ---
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +--
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio.c}                  | 10 +++-------
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 22cc54cac3b2..5b318d17aa4b 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -19,9 +19,6 @@ The files in this directory can be used to tune the operation
 of the virtual memory (VM) subsystem of the Linux kernel and
 the writeout of dirty data to disk.
 
-Default values and initialization routines for most of these
-files can be found in mm/swap.c.
-
 Currently, these files are in /proc/sys/vm:
 
 - admin_reserve_kbytes
diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index 4df7d5edbee5..c1d03a5a2a19 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -118,7 +118,7 @@ More Memory Management Functions
 .. #kernel-doc:: mm/hmm.c (build warnings)
 .. kernel-doc:: mm/memremap.c
 .. kernel-doc:: mm/hugetlb.c
-.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/folio.c
 .. kernel-doc:: mm/memcontrol.c
 .. #kernel-doc:: mm/memory-tiers.c (build warnings)
 .. kernel-doc:: mm/shmem.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 29c302e9c17b..e853622a9b96 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17086,7 +17086,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/swap.c
+F:	mm/folio.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17237,7 +17237,6 @@ F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
-F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
diff --git a/mm/Makefile b/mm/Makefile
index 4fc713867b9b..8e7e964b99a4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -50,7 +50,7 @@ endif
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page-writeback.o folio-compat.o \
-			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
+			   readahead.o folio.o truncate.o vmscan.o shrinker.o \
 			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
diff --git a/mm/swap.c b/mm/folio.c
similarity index 99%
rename from mm/swap.c
rename to mm/folio.c
index b3ea30edbaad..4acad3e94cbd 100644
--- a/mm/swap.c
+++ b/mm/folio.c
@@ -1,17 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/swap.c
+ *  linux/mm/folio.c
  *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  */
 
 /*
- * This file contains the default values for the operation of the
- * Linux VM subsystem. Fine-tuning documentation can be found in
- * Documentation/admin-guide/sysctl/vm.rst.
- * Started 18.12.91
- * Swap aging added 23.2.95, Stephen Tweedie.
- * Buffermem limits added 12.3.98, Rik van Riel.
+ * Folio LRU helpers: add/remove folios from LRU lists, batching,
+ * activation/deactivation, and page cache release paths.
  */
 
 #include <linux/mm.h>

-- 
2.43.0


