Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB31C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA12A6B00C6; Tue, 30 Jun 2026 12:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E511A6B00CA; Tue, 30 Jun 2026 12:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19666B00CB; Tue, 30 Jun 2026 12:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD70A6B00C6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:28:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9ED104037D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:28:05 +0000 (UTC)
X-FDA: 84937110930.26.0362A00
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id A081E40011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:28:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eb6HmELq;
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836883;
	b=WzhRipXZ5vyt0eBIolt3lRzJ6r18ySwHAHTn6N54bErmQ++yNYzPWTTGY6TdyhESpSJEmD
	pFvEZqpl9rNf/bnOG4aiPmPXJGobwhHI2mL8t14kIu3u180aP2R63/MRZGjwejB4XnAHEE
	AVR/OZEeQRZj2FQEzcysH2smB4KkdPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZgrcX9Ksd+pEXazTowNu2E/DXILDGl1RE+rsoxUjNk=;
	b=qyLgIyuVnnIgjtCVLb3t0rjH0YP8SwHKAcW3jwn1OM1xPE32CNd35kB7fU152vLZoAgUXh
	+TaAjB4MVaKyiQ3HMT/9ZFACnymBL+zegx0nsjVIjE9xhoXwmwtoM+srhzqB6Zk9SgXV19
	2Jxxgv10BUNXkgzK7t1YSOPrnjt8FmQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eb6HmELq;
	spf=pass (imf12.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37fb17e1435so1751537a91.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782836882; x=1783441682; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZgrcX9Ksd+pEXazTowNu2E/DXILDGl1RE+rsoxUjNk=;
        b=Eb6HmELq2WJzEgTMUmNhlEzPKoMqpV1i4YWFKM5njbYxCvdWO5sHIDGqjjRyEJS060
         dsAFdM9sU2q+5n0ny5RbNpoCKITTdR4JIRCak2w4yXST0IQ/XsAs6BJSFXfYVOkyDfg5
         Gl4bZnLEeEdeL2a1rdskc0TfVAf6cjF8+vxC0RKGZ/Bs3H//8/oUFEs0itv0ShvDpJDf
         BcGLhx6xZXxFmYmJLLMmr6TkYY3Gc2EhupQZqeb0eZ25lDu08MZ+djBgraP6e5ERHbw1
         V6qUH81/TJJlqRIP8bDXHcrzX0WcYSt1fWSLAhi6shGBfkoFuorGYJbVXTzKHzUlnTcJ
         cSYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782836882; x=1783441682;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OZgrcX9Ksd+pEXazTowNu2E/DXILDGl1RE+rsoxUjNk=;
        b=d/+5SG12449u8NArzoTwRj2HTS6mbBpE8L8BoowwzHfvcyIscgH3q2gJmpevaUfCgu
         t57ZRSA+RBNu/4TzI7obOPYWR0N/Ggwlo2V+/UnQNDgPDBw/JcR6ViV8IGgpC8hQhFFX
         AkhQBeL57KisBsbvlN+lcnCyHCfumeE51VsmkwviIYE65SrfY0qrdCAexN0cscUGH/On
         pYL//zwHIx9yNWdnMZoU2g40SPHsPzFoRLnVThqXtvUFD229sa6ntC2g5f1bcKUANN8D
         wjHhOsxFIE8toYp7J3T3J7iDKjknvqCEl16/A1IDTYZFQNCUNMCm96ieHPXwq/CaF/Wt
         uXEw==
X-Gm-Message-State: AOJu0YwwJfgSBEEQEWu0mi/RSIJ0Sp30eP1W7AcavDtdVge2YnLVThxl
	ZvKnnlCJ9cJlvpt4zIP5AzKaydXMioZJ9cGFihTyS6srxhmM++x1ugfQ
X-Gm-Gg: AfdE7ckiFYBk6AHrNtWiLR2kb1jffZedOhkU+O5UwDxDKyLhQ2GyUgEs2bXkGFuyGEU
	Y7VdMXjYTH20b8WYryysVpanaCm00gewEKbxZyudnYqgFymLsOzp6mXP+dfShOvP3xv7TbQiHN3
	pVa3gWzBhyWQWCfOd1RDRjjeVr2DpBXwUxbhcBoLeSQq84AJ3EoSHUJ3u9QMyEbS77VcCgqL3y+
	T04Dd0riDj+9kCkV5kZzCOm5ov1NKKue7WMrKaLL8Gb01aZU1Or//v80kX3qnJExGjzxmJ0FIzB
	ozsg+8j/q7AA0+jk54KwERXRb68PHgeNsJxgzMZZKEy2beO4K9DggooX0iZ0s5jUS5Tp9bLQnqb
	JmMr9ApCCO2B3unCBppbzejgQB30pQhWW6GhSnRBXlyxfChwUEFADZNolzxH3lvy0B0d/QNNkyx
	zrBjOvf/JxdHllOZfPzxpzNpu23yx3KltsH0mrgUDxEg/XBGwJztA8zHDYN66fwQ==
X-Received: by 2002:a17:903:1a30:b0:2c9:aae1:a611 with SMTP id d9443c01a7336-2ca5a5eb883mr11552395ad.23.1782836882450;
        Tue, 30 Jun 2026 09:28:02 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c87bcesm17829375ad.29.2026.06.30.09.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:28:01 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 01 Jul 2026 00:27:33 +0800
Subject: [PATCH v6 2/3] mm: rename swap.c to folio.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-2-d4f648963382@gmail.com>
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
In-Reply-To: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
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
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1782836859; l=3978;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=FTvafjf4Npw/hqGNx/UkHTpH/v3A7Pg1RRq3orgcb4A=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QB2vgpugJ2P6MKxAU/vvMv+qIkH6SjUmjrKHAOLMUwih5vQG8q69bE0K8K9uQJxFx98f+L37KKM
 YA+C7jnZ5tQY=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: A081E40011
X-Stat-Signature: 9tghoussgfh1g5y5awquc65rsjh3q1jz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782836883-710505
X-HE-Meta: U2FsdGVkX1/zYjM4NDlaymd62kUlBLuzz/WY8mdkOh7mWGGZ0mxC63B4bmX6vD0jdVkWO+N3MRsH1aGJtZ3hlwWFmkHheutvrHGlGEO59EJyppB0HsoG74bp3yxdeD0p7y8Vy5otSQlsgtNYpoxdKFRYTYT0obDnKk6vanBgegfkZL4jpEY1tH8bV7gCPH5mIMbi8c4OHWpWF6ebVqioqQl72LqgW2edorEnJ6EdYVoiJOUkPlY2N3gR5nFr7V6gyT5p62mXorzvlo76Ey8ho8LHbao6RwDxDYdOgBZe+ZfhW6dgPduOhTxhnS/qo3j1g8V8n9Vr8kPAz+h8STeV3gtt35K7l1FdQeEubfEUks0Zr8uOIjO6j3HkKKB1SB6aop8vnB4XoMtzVWEruCk+YwbJNN0EDCjCsahU+kmtSnjug0Y8Fx4Jx+8zL55ILzsM1uOTXJulAmy7h5yq9xheDUDbacwYR/rAUHOpQh8Rl4GI1CGpr37YG5/1hBlbMWX3L3LcZ52+wF7AP8y/Ys0WxEOzGnnXm4+edW7HQKiuQLsfWrSe8p7IvSN/1z+YhfKdKgVCZxcvQQ+cvPJKbL1xJhkurRlkCf1Ha/NjNLTBYBP9t8SEt4dYJ+AORl5ex/L+Pu021Ho1Z89sMA+WSkKugJDhiNySBJZSijUHscRLbzx4XSAoUkpVg36LmKqcQDMFJLLZlzZlKsj6UP4N63Q87Pn1ktqSefXg/FUmpAzJKVPK9cRpRvk34Mqdgi86/dBDpTbWNW0rLBUvBYKa/tqmTQKagjT6RKzu2PqP78M3dsMbdYIyLjTk4cBITpj6rHgx9ZcPQsfLxKAIvhh6iNOctiPFh/+b0Bp45Ueb+B9u+peL2rnMZVfWxSGLGv64GuVoGPl5HJyilY2xEFdjumkTUkfI09ST+sAvldvXgwmWYPSnIIyy5UfTCH7SNKxBmJRvAZq39Lmvyv2v2K3cmkb
 si7oX+op
 enmC2JBifLAX0pWsn0otX6Gn8eD/SSpeIa6TDHavre/aMEvMrfCNGvTdA66rE5WddyTGpB6iZKrRRfRIOYzYZteH+sKzc1YpDqAGjwwVGOFNjUulitsjrSfGZdmS+SaKV6OH4k2yC71TpD+HsA+kpVHXj+bZaOmLopIOQB7+4YdQORLHQennI2L7vkDtsa/qwkuOjPPbOurnUfYEnF0n2B2O3Ebom0rQehp+wEY1K6TNJSnSJZlWTh+MXsIhoUl2bKTIIApfctuhDYG6wRsySXpCMGx30KtM5xT/OoF5rEX+wFQOTKVjPvEmugwr+PzY8yKUiF1XxPkAge+jS3q+tEMZmkMlhXH9gyxn5ZyVb9IleLp1Bl1zlOsctSFDiO+pPg3+ONVZuyGsEZ25xDlP/Aha5KC0q5A7+RoCB167/fioxxzs8nlMKWoNBwEGZUhM+Ollsf7EZNflusrjzdUUsbBfyzUaC3XtFsU6RDw6ez2XBXGj0d8A5xYTA7XIVsL9Yf8f5+qM/twlRhS7ONbo98F8ET4c3iG82AXcG1heK2krTNUeMkwaULIXtdw==
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
index b9b0c218bfb4..c84ebc62a218 100644
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
index aabdd3cba58e..9c3f75092b8e 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -117,7 +117,7 @@ More Memory Management Functions
 .. #kernel-doc:: mm/hmm.c (build warnings)
 .. kernel-doc:: mm/memremap.c
 .. kernel-doc:: mm/hugetlb.c
-.. kernel-doc:: mm/swap.c
+.. kernel-doc:: mm/folio.c
 .. kernel-doc:: mm/memcontrol.c
 .. #kernel-doc:: mm/memory-tiers.c (build warnings)
 .. kernel-doc:: mm/shmem.c
diff --git a/MAINTAINERS b/MAINTAINERS
index dd963b72c614..bc17b1958c99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16906,7 +16906,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/swap.c
+F:	mm/folio.c
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17057,7 +17057,6 @@ F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
-F:	mm/swap.c
 F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
diff --git a/mm/Makefile b/mm/Makefile
index eff9f9e7e061..889e7f9f9086 100644
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
index e4b3dadaa6dc..bcb621c26615 100644
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


