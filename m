Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B406ACD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17BAF6B0128; Sun, 31 May 2026 05:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CF66B012A; Sun, 31 May 2026 05:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0423B6B012B; Sun, 31 May 2026 05:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E60D56B0128
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:50:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EAB44041E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:45 +0000 (UTC)
X-FDA: 84827245650.05.2D59946
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C3AC4000C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+nnqXUd;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780221043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYJjTakWZ9sz9GAtKp2FZMaIOD3c7y309pQDk163j98=;
	b=M/HV3PXC91U7pqOXLUO9n7jwzSHrsTb+y3/aJEn6Lmp7E4di2K5WYFZ5NiPYDlhWhsI2xV
	K8nl8QJklE6BY/prJHpIaR58vbFH6ePuMMpRYbwxT9ukL7g52ihdXq/dntBtnX8kEv2v9h
	uvWAcpvLkzOOhm7cmCg4cow+aeKCiME=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+nnqXUd;
	spf=pass (imf01.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780221043; a=rsa-sha256;
	cv=none;
	b=ORj9b/0gBf+thSmv27nVNH7ACQAJhTlEC0s65h7XKJ9sw8q55WtLEpM5fETlYDbuUAQtOB
	DUOwAnmbC5XB69ehljsPE4oXeMT/9y5/AlG2sQj8FNwGwFuhtdAJwlDR8sMteqdDSM2wsL
	R4tmNxibeBa6gTdjeQl4jlY3GRNbq3U=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36dac5d5d05so33018a91.2
        for <linux-mm@kvack.org>; Sun, 31 May 2026 02:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780221042; x=1780825842; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MYJjTakWZ9sz9GAtKp2FZMaIOD3c7y309pQDk163j98=;
        b=n+nnqXUdFT+KLRwIH9LMhBLwhpc2Z9H/wgif4YCe7apEgYr4yV5J/lLL6FoD5sCAcm
         rNvIDw+C3bCBHmq+3gQmiMu7YtyZ8c32saShjisRAfDMcbnAAbFX2UW+fapTubBHST8J
         CGosZHrT17NslncE/6LYNmuna3t09JdHRbX8IJASzpoKgLjcAyHNnYWo+JylLb4AMphk
         zWemHiIECrcULykO9gkRPLrvf0IRN43Wk/zeNvpWAQn9e5lptLRyb/LW7FntkHzmsovj
         J9uuQRjVI+YbzYCrQXVyHFwLHAi+rNj0Vg66IT+d4aA7Vs3zTo5kIZ/ZcKNVGZx5HeyQ
         AmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780221042; x=1780825842;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MYJjTakWZ9sz9GAtKp2FZMaIOD3c7y309pQDk163j98=;
        b=qDqf6ttkf6loknNuA70i66iXfVv+SHpiuJlUwbFE2C4T/gKjRmm+e7a/nZ2lR+5lpN
         pChxn0n1zZBPaVgdKVMdpMczxdSmsG2WxX4U6tBfveY/jk+6o9pRKTWJxANRsCF7cPfB
         TwN6ZSY7hJ+mcvp5fVrQIHNQuM5DfKiJbOL/NJ50732A98UbT2n/MnvB5aNiEgCn+eoc
         mkcPcctF20C8cmWokoO1DJBJAsP1fe4zhs4OzNJcfVl1foA4kM/EHYihRNCwts1XEZAc
         WFB5RKmFF9D6kq9dy/Nba0E35Uvn/xuRsHgetOQkgnwekdJ+5uLzl/a/tLKq8WMdF6lC
         pK7Q==
X-Gm-Message-State: AOJu0YyWHcX82vtNuLQGkEHFRzWoyVyBiHzHIYD8IaRb3zdSNJsEvlcq
	Fmc0zmavog0QbmjHvh+7ETawpfKZVyzDNZ6GBUlrpuB8YZsh2KoZJRUy
X-Gm-Gg: Acq92OHFSNmGcD5vGruKR2tMACRJCKhAwBNu8kIYNwM1hwIug8AYdbhaBYwAw0IncPH
	BuEBR+sIf77UGuQST962HOrVcaQEzFZHl/ZFtKclcMIKCYb1FOcxEL5KK4RToCB2RXyiqTIuFTq
	io38iuiAeagZKR9rbkxPlDfYCUlo+w3mCXOXuDCSqLqc4yTivg81plXpu0U78z8B4GOKqSHHE3q
	asfpNdFyQQD2HPXPjlKUkbbKXn9zhr08VCLp0OqvS4z7o8/uA0WLzqzlqVK2ZTH/XzKO+Gpr/jN
	gHsITlNFSMD4xeyJMzF7Egw0iNWCuhOW/CdPyMXUyEwZkBDzRsd0njKGEo7oUG4o87Aa2t2I3wP
	/nTAB9yP/UsinY1lyFJz8YozSfFQ7khuK7dEdheUAYRtAM9m4mn7MOuNlbKw7Oy40sbzJXoiOFK
	FVdPbFfsrgXBcHvvoLrpn8J6ToApD1gEEzHBcObebzJ83pStCKHW4LGLJZ4k/5PlFuzt2hPMvGs
	YXDMS+XPw==
X-Received: by 2002:a17:90b:1881:b0:368:6a6e:94dd with SMTP id 98e67ed59e1d1-36c681958f3mr4345464a91.24.1780221042546;
        Sun, 31 May 2026 02:50:42 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdb5c91bsm4372219a91.1.2026.05.31.02.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 02:50:42 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 31 May 2026 17:50:14 +0800
Subject: [PATCH v2 2/3] mm: move folio LRU code out of swap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-2-1b9a4ac255b4@gmail.com>
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
In-Reply-To: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
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
X-Stat-Signature: cxz1n6ju44x9qhad9q6utb66upyg4ncf
X-Rspamd-Queue-Id: 9C3AC4000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780221043-873338
X-HE-Meta: U2FsdGVkX18UXeq9lP+AKrTgLo34fSJxypGN2qvZ67N12RhvaCtGtg398V+CTtYfHodIb2jhey5FtStwT7o5V6v4TITny4ZpxUiyZQ91IN0YkJdP3YWY/02LULxpS6HTBeOEoAKvLO6Lbj2Q64v0wSRfhmdKZNmB9GQoQEdaHfgvWS7d8+TGPY67KsKdouiCHHKGQ+Wmrylh0c75kDzcRGeiQvRXhPbebauK4TjMToy1NBFExXNcKQwDWxCFJ/jG1jc5z99WURM+5SJSSbH4nNvUWWEYujwTBSsFOh7qprRZYLU4klqNsJEJ8wQ5js5UIhwY520LaoDa4Kksn3rV6g64wAuqsTAnp0awH3pWUZM7KeZABRLa9B4PoVOugKbYpZojsgv3z7YwIW22uwzWnIVfWHjT01RdPTPq8aeAcC0osREl3sd3E8QRoK9KnR23Cqhh7UCywbCteQRKAA9Z1p6LS7dHL3QJ6FIyxOmUHZ10k0Z+ymYZ4ylJA+y+yHfmAwrgYjmmnH2oMTDiH/VjIa28lpXyUGL6Vs2VBYzx1/SVBQycwMPVN+xr0BIaXkm/V+CKEMo7DxVd1sCxTuvodGTj53WYiD+SdgXUnFdaS1KNRToVbCP/dg0fyUqVeH9TMn/6yfbQxTD/MaUvcT+d/i+yjkLFglWYM3wuLkRriG8fEdO9OK4NJOabmTfx4Zi475bekL28J1EHoyBzKezqVSnet9fU0A8eFUKn+PlXxcXOCO+FdvLHVlOkE9+Dli3ytelnJ8VOF40C09QMwfkvWVKOIsVFRZMRuilqmtsZTUbDbE2Vb7qmsY0OTFmc01k1PvnTzaWAK+geiLBnBfTP7M5jAy02iTdd3EDCx41tck3MRTM7Od7DjIjJSeNyoSB0mFhQsMfB+hFUiCoxM9tU6DRBRbnqTNs0L7CnZ+c/UGfH8C/ctIWmzdhkeIR7nRqsDm/sKLwq/jlkyrsDrFN
 +vCfOpBl
 VKP4HbFeR69MH4movBTUtu1+jq2tu6yIu7i+94JUdW0H2VSx9rPmXofNrSmkC7E/qEZCaPQOfgQm6lYduwxIGty/Kt7t2S1XqDvUIWsXkgrn+YSruLXkE7fjlIJcPAiiw1+LyYUiOvQQc12Cm8eU2ovTS+m0/g/sfsRmgDDCx6tjsZMCXwzj3nLpFRiEw7yJO0CE21DMJCyBcLG42tvcnnhaKTNUnGdWqD6FlEdF/aOCePwygo0XRCGWQUI01u0FGT9X352ChCzRTCQ6qDf8NhXTaxJLlmN9RFa53FEZFQOvFDZHyGjWutjiIzB7TyH32ATl9FQzPYv7RQLY/FR7pY/3U+zUe5CZYyifUpk6AaYPfPVhsCO+oMy291EWO8n9C1pkDNAqtHowypaaWOcPml5tiSMWBTySPnOWepUMWRK6jfiutOkP5Lcd07YB6J2Tw36ZY
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

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/Makefile                | 2 +-
 mm/{swap.c => folio_lru.c} | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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


