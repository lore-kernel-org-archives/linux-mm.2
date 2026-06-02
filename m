Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAD1CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 01:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E3B6B04E9; Mon,  1 Jun 2026 21:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4B56B04EB; Mon,  1 Jun 2026 21:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A846B04EC; Mon,  1 Jun 2026 21:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0F926B04E9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 21:01:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99BC21C1091
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:42 +0000 (UTC)
X-FDA: 84833170044.25.A7717B3
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id A44DD40004
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Os/egDcH";
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780362100;
	b=VJfiLtgyzVivofkUWMSM2njPET3rZXx++MydxA7Rc3afkCmr5Kln6wT5xaBe16iQDIToPR
	Ibb9T8HGT4Vvm+L1T+OXpF46iO99igyHozR0qUhpVmlZBKdogGEglnfQ2Nti6NJFCwCi3x
	CBExG7H44tziYK1skvfc1j/J8sFlSis=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Os/egDcH";
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780362100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AW3A/Ls+0h2KLVTTYuDIxmHt+2dRNezfr2XaBLaOlas=;
	b=23EHOsaaFx8rnTcypYdcyOS6UdoMHGL/NgMfIa/7plAm5uBsNhwmX66kQ+eouefqEZQIxq
	RQ1QNB8PHhPqa3hRKed6x0oXB2MYnO+wgFbgps0oVL9IpDOF65oPOyf5bK2RpdArx8b1cn
	H2ph7XWTsZxKFf/P+lvmJxM8bkxVvYo=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c0bd02d97eso23155945ad.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 18:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780362099; x=1780966899; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AW3A/Ls+0h2KLVTTYuDIxmHt+2dRNezfr2XaBLaOlas=;
        b=Os/egDcHjXhcgbe1ZUZnqXfBVm+ZP0ZqKXpd/v9aLWm0QaZ3+kX8U1CoheQi9PIzrs
         YTJbhbJ0gx+WcYFy50mNbH4vLIMfUWdhxv0NeVMfXaeGRaIK657llWEJS7LuOObYIiTX
         4BJlJl8iAQyPhwXQMNJkWgPaOf1japhbF8D6N/MGcHYNOhKziRrZOJ2DAPNemH2ef5ki
         as20n+pk1U4i8KY+j4KdVabz+mHkIF6JTljMW002unmHOmVkrPw5+GYm2CBnZ4SNJort
         72UfQNJwZDVhcfx5KneMGVIeDQLlCKWIIFqmIBWG1Bz9r5Pscd+o99UvxA9bweTxjFEY
         FYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780362099; x=1780966899;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AW3A/Ls+0h2KLVTTYuDIxmHt+2dRNezfr2XaBLaOlas=;
        b=NqvPhmny7HaRLyDgHZSf7sMbwz5arVDmFTvkNQgzd+aNdNr3G9Lb4IGqxbsxKj8YBF
         B1cIslw/bGaBgk/s3mg0TE6GNHASn5kaEk/pVaoBgAX/+AACCANj/BoGqxf2c5Dp45+O
         TPTmd9WLVa4dBLBK+O1hdE9ihoYjN4yLbNoncretGbhPrsc3UD3PqdXX6UUBi12TkbK2
         j8ZE2Js+G4tTBFFmG+cCrJ2whcy2QdvKDLVLdXix3siE3QU7DvqpXh9KB5KflUKQb+dg
         amPa3GhKupYveOMmAEjzMxLrdnFMiT+5J1KYkVymsGqzx8OOq2/cbWYq7aaqGPzDNSuQ
         5egw==
X-Gm-Message-State: AOJu0Yxuh/mfL2i9pI5jcHLvudDfBIF1nGjcfL2e8pBOZlFMo3eSsziv
	83uH6gWBhNdRubK25sj1kKtZGZ8EUMGjwi27r+i2JhDxF5pEdpHL1iki
X-Gm-Gg: Acq92OHZTUH2I8+B6On7rAHFIuDEgiBxTDnxFYhbJeFpaxc+BzQlYFn7du2wG2rf8vj
	dYVID6BGnSXBxHc9ahkLFAX/F/OO391Am3saa0wlk2tb5cfW7f3+5ixVC6cRpns6KoF2H2YG1Vd
	H9Y7xLD8marabnfE2DfwYwjjQJepPWUZ7RX/Ug+bR9B4RbrkFEsBx88zqnT8R/ht9kMiTD5fwTj
	8VRbncPO+ZJl9P/inMBm0CL8qwYueJRyySIcNNLb6U3dTVg0b0ewgs97hD/eaKbF5aFraoiRSTS
	5ItCU7HFyxdOcEB/VHXBgqzPUY7ihhBQijRCNEIvxuzbUu+oHWRZNlYy0c/xI4TDDk0w0Aa0+8E
	9spN+AB1+aCXirr+aUC15eXxoUEz6pP+ph8Bpc1IM/93+dSJy4V1NC+9AN4dq4ApBex/c/o8LHb
	gKZWT+ApFBae7zxZnM2uVK4reMK4T09mgco07NMIDA7KAVHfoHUp+9iSNX8YDJVXcMGdTcxtUyH
	OjMuc1pgHqUR8i+q9zLbg==
X-Received: by 2002:a17:902:ecca:b0:2bc:f1ef:2e65 with SMTP id d9443c01a7336-2bf367dbbc6mr158885955ad.17.1780362099480;
        Mon, 01 Jun 2026 18:01:39 -0700 (PDT)
Received: from NV-J4GCB44.localdomain (nat-hk.nvidia.com. [203.18.50.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm111693355ad.25.2026.06.01.18.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:01:38 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 02 Jun 2026 09:01:16 +0800
Subject: [PATCH v3 2/3] mm: move folio LRU code out of swap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
In-Reply-To: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780362076; l=3325;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=irV6tT2VkmAHwvkYIbqPFAWrBGcSQqdUJIymy1EVHjA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QK6wYNFc1kVFT8CN61Kwgpv/dbQuBJVp1aAvggsrFzWp3+LeCCovaR2gFPQrXpcS+mR85xiVhNn
 oSy79euxduAo=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: A44DD40004
X-Stat-Signature: ww11dhq8hwyke97r67o9d9fyjnqossen
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780362100-118633
X-HE-Meta: U2FsdGVkX19903YUzt3JshyywV9+PR52NkQiwz4QuP7S7PbSppzmlo44HGZhTlEh06RkueUlSlO/UXeyTME+CBnmkiV2d/gQdrgWEGMndxT0U/4TyeJALFu0KC1dXbyhK9Yt1mEsN70v2a2q6Q5WHTrJh06s7doKfYnhc3v9DepjPk2/VDjbRHVcEOQOmEV+5vB/LPbpG1yGWWaj/I0PU39pRHoy836x5vwefmQF2RXYQkKK0j/i/i1XSwxsxP9rJV2gqSDyGDhABY/S7vFFfybeTNaLmaFwIxqiya6IHc15ZX5iq5KfNwnuyO2HqecDmldxWtir2Bv2E2qUPHDXPMopftatoL6WNu7S4Kg0esauI7tEHdf3FINZIuf3tkQTgGRu8NkBFIClzm8MmIvUcXScnaI7BaM2VURiXF5QaMemv2C42QH7mgLZm94PePYD08w/jguKo7s9+QBXul9c1NA32ODJq23OSG4C+4aDHUhawmBn9EbNLgdAu74HKHBzcXao6Q1WEoFyXd6DkM6PvEcRu1zijoIOYvxMAke1H26ofRNuX9rJqhNe8O2n0CXU24EfTxhuLjeMvXlv1w95k7Ao2TSzWN91SCErBPosdtKWWuqsgFILov1ln+MDYbR2+R/v8Q6vsAj9PbdxAo3KC+Lz+PmvgTTBOpbyEywQ7GHmV9psf9TgjgnPakFgPg4PIoI18mWEwzXvsY2sX2Q1nIW2yf8//slVZ8CDQGiC6eifSCxiQoh2mOO6BdWca8X/HyOkahkRBZrZT+lnZGk7KfNKJ84aRTMzqf8y6qtFAYhnUQhIjpXp6IGaGK0BixSvOScwyrAsndY/ivI7DxBvmqhfewTuN/4VkmuFnqL25/hON3HE91to5B1Jf1GzddnBf1K/9ELYxH+NtKWfw2Aw8AYY2pH6CEPVfaYSzBS3zze9MYTBfbAREGCEFM02YQzlHG2ccK9awdqw8SbbE7a
 VvtOeSta
 Ah7n5JumTbAjgaMwlBU3NpgMkx/cRtkCByUt9cO+FEHC3u1pGkrSRkAzLty/QKwSNxs/vOkdGuiLxcJtHP0c9sypMz13np1VhZfwZZTT4EVRD7uMny9Kc4/XVkRZ+V1YJVp9VfVT9OIMmzidX+hd7Ss2K0qs2LvcB0z5wuOHCGwF6+N4ARleWByV/B7lTJhooyXJgb5I0+eMhaD46uQDKs58nnV0Pqf83zUIrBEDzaY8xLLhRK0erobei4n1ZwaEkLYPHpEYMug8iB4Eyc8OwjNOA6wPM6OCKAkO7g8rhSqz6EFpjbyqLnpXnlSYBm3Sofp4nwRZjeF3tE9HYyrKhLv2lSYIy7AH+JEJY0oDSbzPWZV6v9U00SKKCXREYd4IXteUGd2a40BQJr9M9IRynmeK+s6NBo0Hwt+l6DWBXUMHMgdvTUsxBmv5iHByQz9EiMJB5MyhaLgOuTvl0MGEhfpRyeyMqw0+uTP+PBRLIOWnCvuym7dqf/239kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename mm/swap.c to mm/folio_lru.c so the filename better matches
the code's main responsibility.

This keeps the implementation split from swap-specific code without
changing the published LRU helper interfaces.

Update MAINTAINERS and the remaining mm/swap.c documentation references
after the rename.

Suggested-by: Baoquan He <bhe@redhat.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 2 +-
 Documentation/core-api/mm-api.rst       | 2 +-
 MAINTAINERS                             | 3 +--
 mm/Makefile                             | 2 +-
 mm/{swap.c => folio_lru.c}              | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..31d135e107cb 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -20,7 +20,7 @@ of the virtual memory (VM) subsystem of the Linux kernel and
 the writeout of dirty data to disk.
 
 Default values and initialization routines for most of these
-files can be found in mm/swap.c.
+files can be found in mm/swap_state.c.
 
 Currently, these files are in /proc/sys/vm:
 
diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index aabdd3cba58e..d6d189b9a996 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -117,7 +117,7 @@ More Memory Management Functions
 .. #kernel-doc:: mm/hmm.c (build warnings)
 .. kernel-doc:: mm/memremap.c
 .. kernel-doc:: mm/hugetlb.c
-.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/folio_lru.c
 .. kernel-doc:: mm/memcontrol.c
 .. #kernel-doc:: mm/memory-tiers.c (build warnings)
 .. kernel-doc:: mm/shmem.c
diff --git a/MAINTAINERS b/MAINTAINERS
index e3ee97f5474e..6bd39e0afceb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16900,7 +16900,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/swap.c
+F:	mm/folio_lru.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17045,7 +17045,6 @@ F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
-F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..5f712f9bbe73 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -50,7 +50,7 @@ endif
 
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page-writeback.o folio-compat.o \
-			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
+			   readahead.o folio_lru.o truncate.o vmscan.o shrinker.o \
 			   shmem.o util.o mmzone.o vmstat.o backing-dev.o \
 			   mm_init.o percpu.o slab_common.o \
 			   compaction.o show_mem.o \
diff --git a/mm/swap.c b/mm/folio_lru.c
similarity index 99%
rename from mm/swap.c
rename to mm/folio_lru.c
index e4b3dadaa6dc..7dab6a544d94 100644
--- a/mm/swap.c
+++ b/mm/folio_lru.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/swap.c
+ *  linux/mm/folio_lru.c
  *
  *  Copyright (C) 1991, 1992, 1993, 1994  Linus Torvalds
  */

-- 
2.43.0


