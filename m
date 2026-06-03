Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDE6CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85916B0096; Wed,  3 Jun 2026 09:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36236B0098; Wed,  3 Jun 2026 09:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25B96B0099; Wed,  3 Jun 2026 09:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9DBC6B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:06:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80DDA40343
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:06:02 +0000 (UTC)
X-FDA: 84838624164.12.A03C308
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C4C84000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:06:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RHOxsLze;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780491960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0z7POWPxUcFIdIcrd03eVKzZ+Q9s/sXeL4bwE5y/l2Q=;
	b=HFtzzTvcb2uZY3ffG+hJqI5nJEzPX83lCkcOstv0XZHtKmhl+cfjmokaG7xdrkmjjfFUse
	msSku90yoaH95RuKsoN0DikI3irOUoSysd7LaOx25fm/gSo1T8Z932mLdbm/SqltNRvX4v
	MVGoANP9MqY1SKdUTuFR6RHv5nbHGKQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RHOxsLze;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780491960;
	b=ZlF6nNww6I+6B+yiNUviVTJWEH4ve73wZurQFyFwTlGIAwH/QOWBL6JvA6trYULe9FK+CE
	7hUzhaOnyjyQmONwTQvPJBQ5O6ShxOVV4LWINRXbqsuO5kJCFMdZRDqWSe3GJcrKBPZM+U
	4APbNgdOXJZ18MwpFHwBO09FmnT6RXs=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-842338c18e0so2482064b3a.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 06:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780491959; x=1781096759; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0z7POWPxUcFIdIcrd03eVKzZ+Q9s/sXeL4bwE5y/l2Q=;
        b=RHOxsLze8Vnc0A5mw0gqaBfReb5i1bLxvyrsWxIXZoZsHIBJ3mFGKU/0lo8MSyyhj9
         P2GQEb6XKdm9fLMdiGFM5XG3joZvp37W3IEcO8A7q7eiAciSIXWcRfkmiU7Vleqlqd80
         Dns8VADRePK4h7XxF8F0EKhVSnVuTWAnyG8iR4szehDMeWd/asl3b5I0RPClU0bxmibM
         r0F8t1ojYPzW/g73Pf5smCxGdVAHK/3hBrl3tdK4sdqtobInfq6EeL0FwqpeQh4mytAn
         JkmdQKWGIFPN2zc7VusY01oKmbnm210qY3D280W4JEmz4JE4ZdTtBvTzxTIRHTLsNLSi
         UrYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780491959; x=1781096759;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0z7POWPxUcFIdIcrd03eVKzZ+Q9s/sXeL4bwE5y/l2Q=;
        b=PzLont9HaqcMJs8YCbhTyzYEK5FPnuuA67M2n/3xdFe661iK54Ogj2L74fmMLcPclq
         bLQtQJxIzoO8mOWqGKSkU45BggbaGCB6rD1mWrOCYmNDMYekf56R+hPbAdIgySWS7tL+
         4b6Yv8A9YNULdToXXQp38XmCB9lje/sQiSMXjw+CuHAVW6V+dk+GLyku//EbRlvz9icD
         iy0jyfxRv3CbJJmCspyamFQTbic61eKuVYV5b1PNOivDfGdq1dZSqs9+PmRANI9/h5bW
         uBrOLQI6tYnnTwET0R8sNeAKaCgMgrXoyIc9RtSqpZ7C6nGRNm6ChG+Zg/0LDwht8udG
         EUwg==
X-Gm-Message-State: AOJu0YzHccvmqyhIJINToiEZZdjP1ZMTxWNkeO59JupvWrw6WIlFh7Jd
	FexK98akUVQm2BfFQv2XfJN8oojhI6stS9ws4AjacwVTuIjWL15vtv8i
X-Gm-Gg: Acq92OFZUReEKXM6KNaBFBM9EIf5kZYIf6wcyDNepptJPhE1MccBD2XRY7pbTcQ8b/v
	PRXjMzSE5tZYQD31iPYlSrNfY0K4Ri3ehF/PaJsOxtgmBHj9DQXKns6p2oqdIwFxC2RgpjjD8xI
	gyvvx4kA4zQjnxC272MZHBPxKA02Icbamkd1g8k960WGJDRfRHiyAexEhiLQysTj4ar3vMwkDhE
	jHv5d2v5BwNS1S/rdnd1JRcXrc5BgEK1IBTsBEDIT4ZFG2W622WVGLlM2k21+evzaIZj74R2eiF
	EzInpBHssUA/4w6BS4SHe13yJsIcEEEWOZnc7rn7LyUetPNBb3vlbRgSOreDK75SEENAmbVrQQI
	n3tHO1lpEsjCcyCUanpsL9ax0xLQetTuLF+D1XlmPmcXd1vgVmRnX7zfXu1y4R1FZyQs75JdDHI
	wZCXuz/k9bhdES/5jz4tXn5tWSDsEn8VFvFnapqaUfFfidEZmF4+AW/4L6ueHTDX3aNIOl+p97e
	i7oAJvtCDg=
X-Received: by 2002:a05:6a00:a588:b0:82c:6b46:271d with SMTP id d2e1a72fcca58-84284f2ab8dmr3244777b3a.48.1780491959261;
        Wed, 03 Jun 2026 06:05:59 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828821d0sm3018661b3a.28.2026.06.03.06.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:05:58 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 03 Jun 2026 21:05:33 +0800
Subject: [PATCH v4 2/3] mm: rename swap.c to folio_lru.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-2-ce0219e100d9@gmail.com>
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
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
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1780491936; l=3861;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=fe/ffXXpEMnAu0iQ+HjGa5E0GG/1Zp1/KxR6Zcf8GxY=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFMGdSY7BAbK8+cAIhTQmlj4XbCHh0sKNvEnlqBKWenwp5XcnSXEtNnzgQ5T5Q5dW+PSUXUNHaL
 Meb9KsDapkQs=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C4C84000C
X-Stat-Signature: dcxe9hpnr8uuiycwgs7xoc61iie8s6ph
X-Rspam-User: 
X-HE-Tag: 1780491960-936885
X-HE-Meta: U2FsdGVkX1+Gymx6FmxbzEP1uGI5GNGEe0XcnFrKDDW4Kib8NJFBS3PiIK8BqYeaqaQaZ3P6aXNYww8MnW5XYjn6NYjYnwYfnl0si+hr2TxvF0Qd090SHy758uOP+fijlbp9p5GBuh863j6tVoeW8Ji8ykzXaeojogs9QCZKZMDxsNWiOsyysXqD5DojOzvJJsPyLa1qvtkkyhra8qdQeIQCkTrEPXlNKsIxfF8aZpQVoBRbQSLL4qniO4iXCejI2oQkXtBNZqEqO0Ntsr2JX+xBFfuWrqihzwnin2a7FctWSyh5Oxl1nh7gf6QV0AFmRAiUnFxo+kHXH1kOtL4GI5oYO5ZUtCP/5PeafNYrt1UIZSZnFm7OAK3/jboCR3fvTdxtjMD1Miwax0IPdMIZ4XGnzBADOxWhXaFJCFow7bS/ooMdRChd39sD+p0h0SIx+hafqJ3UbvB19Q9U486QznJOJQ6lCUzkgLynunKjFqGRo3xDDjdZTW3gg9KtW65OaZbbRXKSW37hNP9CmwBdebQE32Gj7uOl1/d9QJ80Ier5qoMNdlLYc8hLWG8Ymz+YEpwevnBBULwt6pm8xrNkYjrRE/GfbVYIbP2PY1cjQx/qwm8qxwYOCVFtKeZ3zUiEt6thLm+kps3f1sN1nu41IfQ60BONsVyn7edwwuuPUSmpNyBs488kxbPRJnbLdt/sw73RoonIa4cn4AIqjaKfI0sTHwyrMD1rbh/5M4GS4j1ytWLd8psWOawoow5yftAZuoUbWNuemNJDytiLuZUv+D+JOmvhtTMxPF4U5rE1hs9J262g4vyp2veaejyyWffplKu1JQMpMxPPJnRtt68F836+D8+ubBmludvcl2QWXX5b9N61HR90Uaoxr13waJVhVavWapTXjbHupI3Ay1JVxT6kHiBEqH9mCV3SZM0FzBRl/96v2/HEtzUtxqbpV36eltRlaCxer7Ik68CSj9X
 ZCJBy3mt
 2qUgwiN4uYXWc+lfApQMFTaLXJ3rcwzqqe3OWYcdkwJA3+1tHxuToFbYEaq+COLTwM2gl0SaLv3Wk1OiM6CiP1eZsLDb79Gj4XROV3Utw6JXV48+9eAfBmN19dVtDTmiktqyQSzElwNrqGwgjCAyatKcmzUvrqMQ6eY0RzpJngGIvyUVQ6ETqipQQlM9JvSOYhvXQV9ZiFHUCw9dXpVEzoeNHU5KsFc41Wdzg+ShhZ7r5BcIEMdtO7wIeV3hK4xPTDPKmMCiDvJXBUaX65AeoHlXR9lPSElcOPBrfE+h0Suw9zPoQmmW3WIVuuyQRcNx+mEwcieXFNn2KUVvzX5cqm0RZ1qmC435nsw82dxvAE5dj8eSyW/9mCYcDM9dNWDE1Qz6xxQVthiwn+KpXzE6Qa2Ko0FCR/Jg7dGYUSoe/2ZKmmja44dB2LhBQiXN1CPKB3bYX2KNTkWrUnzS7ag5Ih5dqTwR91xQN9m9yqMKbW8tzUdCHU5vHtyXpIxYvZIDCZh2DeUUMV7F/BKrwLwF+Yq0Cyv9jim/Fiiif8+28gDADibU=
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
 Documentation/admin-guide/sysctl/vm.rst |  3 ---
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +--
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio_lru.c}              | 10 +++-------
 5 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..2b9513371324 100644
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
index e4b3dadaa6dc..46924a797ead 100644
--- a/mm/swap.c
+++ b/mm/folio_lru.c
@@ -1,17 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/swap.c
+ *  linux/mm/folio_lru.c
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


