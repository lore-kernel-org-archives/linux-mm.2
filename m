Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47028C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DC96B00A7; Wed,  8 Jul 2026 07:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDF86B00AD; Wed,  8 Jul 2026 07:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4BE6B00AE; Wed,  8 Jul 2026 07:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7DA36B00A7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:37:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 704E2120785
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:29 +0000 (UTC)
X-FDA: 84965409018.21.94A5491
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8CDD21C0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FJt+Gv2/";
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783510647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz/wglSNwwdj3pp8/wV9b1HdpJVBsVZyoCTNB/KAx7Q=;
	b=sYIFOLUO11cyU+5pwYKkb22nVRvnWb9Ox/TUo1xfThCIQbGeYk5cvgVYu8fvFbl4v/9TBm
	5UrXsjwNlKFGBo1b2wFQ85DCEAfPxj/52yatwClAINhpZaXuJW62mzDh5TbyeuxoIqupxS
	dUfzZppcZWMmm3lYEERpUsbeUO8zBEs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FJt+Gv2/";
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783510647;
	b=68LWRjjVzowde9bfEPrgp/eoYUwo7xocsB4cEaYJSPuV0tZQd5Nx+W5zDBY9qOEdaPr9GJ
	b8kmsm8v0SZBPv1RfhpI9QcqWjqA6z2QZTTszr5OlnUsQsmsAT16Gy5fYH9+3BLOQ7qrsJ
	6vyHWaUUeat73gfWqCiDMObtUWs6TL8=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84830c774a0so529452b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783510646; x=1784115446; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fz/wglSNwwdj3pp8/wV9b1HdpJVBsVZyoCTNB/KAx7Q=;
        b=FJt+Gv2/YKc73Vsj70o48LUYb1+AG/yeOSf10+es7VWx3MExmbzUGwTLedfZLFYsIe
         jdMcbwByGv6ivN97TGcLmBC0PKevM+WOLsN2Nhn5iA0sd/bankKBUmmnUZyw7GUA1tqP
         J+fo6FO/EdedOFY27Ww8CcfxuNPrpQqrfYsgWTs3ak8Xrx0wSif7sB24QZVfHUccfXX/
         Q9piXYY8KMmNJLOIowXF3hD3x457eafZv2ulWN1TqfAdUKdHJzS4iLRia3vkcHkCBIxR
         +RFDov5C5UwCflqS6I/EhGg3aUzR/foCAjghBHP/NCvj+X0bJyrUbIVxg8D7n84wHftt
         ABaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783510646; x=1784115446;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fz/wglSNwwdj3pp8/wV9b1HdpJVBsVZyoCTNB/KAx7Q=;
        b=p/OCgNcpXIIzCiht8V/9kUCz/M0r4BPBtTgUd4baztbWmahkld7N7n/B5LssPXegyv
         CPQELJTmt89YJZtI05tnVdDI6Wdwipe4z3SAXZQY99Gy9xIr68DOQI26ZQP5phI8eSUe
         zaYZxIUQZcWaHT3jd8N84F01Cm96Fym4u009WdLdlnf7XVV3TTx3LjBs0N2Bq3Ab6cAI
         7BuRukbNgiO689nRA7XEWv4wpZsa2/roqg/oRyErHZxkxVlXl8NE335qo0HlEjFm1XUY
         Ea5UymJC/v8y/C82vCrnW+VNahb8c7eTFJ9Tc3fIlb5AZoPE6AtwWctY3ol4HLlyhg5w
         /NJA==
X-Gm-Message-State: AOJu0YxBVKwDt8jG00/VojlbOpD5OMiZhKm9PJC1LQVs0W86LLn1zeDo
	cT1ffYFGVDMjtIIS8+Q8xbTplyDz+/W8+lhNvMk8UBiqcLriKFcb0FPV
X-Gm-Gg: AfdE7cmjWwyvEkrQXt2AYWqZP3G63f2v1rYODgJUN5nUxlF/SeJVEO7mKQURkT0dvCH
	ceqrg7TNiNKP5MIa/61v83Ik2eZTRRiQIn9P+e2BEhcIPSr/fFBd8zlB7L9uZ9S4LfmaWrG0SGI
	IosshT9X7/0rro+Yb/HlL7oTvM4rdKMRFM9rnuVeTEoPGRDeqNJSWKpWd+h/1t4ywj2FzYLbX4t
	l/Wc3Z33AwAbmNEW77Hr257g0qS+7CgVTswIQI5NKNHpkJOAOQzXfNCmcKf64NL40wzeW/6k1cp
	M0IM0gkgc42/lpeibCA7Rc0H4Xn3L2Or41oSYDfEGVqWfFVnaqDnuxa5+K2RqrOZqTi9crN6YBh
	n29Rqxxv8B/Mmxb/EOFGmAXJn0mKa96qnhyA3falFL//lTOA5/dkLhCapNedmwQfwBRxLDnAr6b
	ul230cdZduftjXCDkFoLlU08wu1ziZFYvuyUQlZIJMZLFP/OijFEsR51sQs/tbFQv1xAfRHA==
X-Received: by 2002:a05:6a00:6f0d:b0:848:438d:3665 with SMTP id d2e1a72fcca58-848438d3bb1mr1976271b3a.41.1783510646291;
        Wed, 08 Jul 2026 04:37:26 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3a2e42bsm2260788a12.30.2026.07.08.04.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:37:25 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 08 Jul 2026 19:35:44 +0800
Subject: [PATCH v9 2/3] mm: rename swap.c to folio.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-2-2bc72b4f8730@gmail.com>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, Baoquan He <baoquan.he@linux.dev>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783510625; l=4030;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=K79N77ymBE96cKlxeMxOGPW8IV82mvdJP8Cyahphp3g=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBu1Q6XYzv2szD4iwDNl+m4CtzNdIuGsnX3rdmoMwfThCclJc82d8b7MtaTqgG70f2w8SMv1ECd
 ZHhFCYHFJ2As=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CDD21C0007
X-Stat-Signature: hxwsmdxrq1fmwyeu4k3ecwtgneby6ra7
X-HE-Tag: 1783510647-672118
X-HE-Meta: U2FsdGVkX1+B2sqNpoGQqTlAa7BSuZ7wvKmZ2ByMQMrHEuKzXdcfXMDDMMKKhAWLxv6RPxzDQ9zxmHCEpPcXbgON+5N/0P73+1p0AB4Nx4sKHFbxS1pwD2Q6MZWD7d9P62XBtclIEFgyGQdbK0PVcKgaY6nXQKULwPNv7Af+P4XxVngxNk1hWBtXOmebJsvjFnBfRWrzCvbUFUzc7GDfrDPHapnJC2WRP5udnRfStq8SEhgXCjPJFdfNmd1zPz+AbDBhhl3f03n1hLuO3NHXVqRLRmC/sMs/8NPe/pcQ6Pd9QRsTDlGUrkuK7b6TF3ATHE4FsdwKiW5yDdXbRX4VS7zVHGNkzRN6lTu9o4DYEilSJoPvxDBDYfwOnr/sGRQ6VIJNPy38mE187tnegTom82JwmTI+oWJ0wD6Ud9lh5u1MzkvY+bC7tMC/7f0K2K9TCOdtrmfEpXDvwSdvS4hRbI6ZnrFcQoHPuJfrNdmA1cGBF22UZJj0SnNBQ5vJy9aryCGlHu3glJFSrsC0W9uUS+/puF7dTzEcxX0LyBkl81NL52KiNwP05njdDYNjAtFGqfYweh+VP7pOSJItDlhZYtzcQLORD2SrCOoeFAkVOaA+1xm590eSuQ68AnUVptMlSvHnaG8i7Qeqq8vTnanuACSbuOVqrzWEEP2/J3+uamLILtJhDUPdk/EimFKLs30a7J6/ibkThEHBjus9UagfTCZIo0M6EhmGZnzhTR4bYC/SjSzPu0f136kVUEXPAI396lbTkwmXqfA/7+gRhjUTf3ShJxiFIH6pBCcOGeIupobmM8tL2ZFjZRVyERhxnzpTOZQ4GoGBeBT17YCeahmbnF6iDCfuY7RYCoFTGY2b+MRxJyhVefOAZA/b33yAT952ymEKfSp1I+c/dI14DzmAT1unqmeuisy9yxk6bpyFCrh0Ga3hpIiour5Mwti/ODRGwuNUDmGLwR9lN8NZVkx
 9tBppfUV
 LbqTsnbZcmMWnWoAZ/VyKUEB5TmsoF/YVfAbFQwnoAZjNKeESktU0wk2GuOYZNjDg8KBXV4rJRqmU1itPemK+yG1HNtzAYCpw0uamxvOwXSmgPlg3Ydk169/aRp2EFH/cKbqEjIT/+HJ4w+WfYp8SCRgEnrQ8OS4GVzH/CrMyN0z0p5FXpwoNLMNy8fFqNfObB4zsKJ0FlN0shsG5C0MhzZqAukCzsRsbETwkrjiJTd7qx0ODOb/w8VaYCMkh/N6YAVq8Jqd3sW4OK3lulz/da+8isjtz7rB/AHIg1E6YktzotKGO6n9Im3fQhCptnmC0YxF+/AtaBh3UDbXkdMkBfkpAsA2F7554b6+cNAd9r360wJ7lCenMzFGwuCaguglgnFVLw2rAqs+Js++o50BuJs0QLLCCbSOZI0WAeNp28M14HCyhWY9d34xK1EqNlyb9wBIYCny2emUugLschmeD66pSxwJPVIHpjF+yR+Alawc6oMPgfBYzcJZ/gvnlVudZeg4YVBZmnNP/5HPLkmw1jUsYYkwvpi4Yt7hKmU4Z6GSUm+jDMZG3HfJMuG3+PFtjXQynn4bCEQ2spQP1+U+MTDFVT8+xNVL5AZHMwcvYoY4VDRs=
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
index d19822d574fd..c3e535ca4bef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17085,7 +17085,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
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
index c88643e56af7..d2937600cf72 100644
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


