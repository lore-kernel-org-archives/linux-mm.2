Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F161C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A016B00B7; Mon, 29 Jun 2026 21:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2026B00BA; Mon, 29 Jun 2026 21:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA016B00BC; Mon, 29 Jun 2026 21:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16E76B00B7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:08:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48BC71C640C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:43 +0000 (UTC)
X-FDA: 84934794126.21.75CEECC
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F9D840003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qt1iFXtU;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781721;
	b=PgX4m97qHO4MMKGgESH+JNot4Qw+MWjEWVkidFL/IdG8DXwtPvA4p7uO3RDvXAEtldqoum
	YGkXdLSC42GfDlZnzak0bBbPlRhl7KhEPB03AgIQVghuanZcX+nuPeBG0aEEKJGJZWeptQ
	Ni1d8jO8Y8Npstwa2FfEhYi8/O9zeoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4DnE15DF2Fu15LvNAiz/waMqRGmi/eFj/KwCw6VduY=;
	b=dll5O6cb2P07hApErChtgSAbyBqDkRJTxyRmx5MAE3dgMsquNSM9/rvPu+Id5PTSu77LnK
	jdeBk9X24+FFIBcrhy6f5fVWuJYBudhWPhKl8jd6PriAgBJ6ZtZwaZaZMnTkNfCrb76wFr
	Q4gpyd83NRKpt6yHJb9/eH8H7tPGmO8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qt1iFXtU;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-842358aaf36so1706207b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782781720; x=1783386520; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w4DnE15DF2Fu15LvNAiz/waMqRGmi/eFj/KwCw6VduY=;
        b=Qt1iFXtU+w3OjlfvYOS7L3g9qdRDY5X4WYb7lx0UIwd+bf/lpedaqL2qcQGUT4kiSj
         C/9xCiQYs2Cw3WAFLNZtgJVPJhu1WiwWAeuPn/tZshZ2b6a+Lxn71uBoYg8YQ36toCDf
         Ml70MHYkY0vJ2OtouEdt0M3K/3c8x3fv0Tf+ABgoRURPl1YEnJh2zuu4D2AyX1nuPioX
         yiWhEqiO/Ihe76tM39nA/3wr78IIqZl4N84AR9yI8bGzDK4Tz8YuxtUDeO7ctBnVwbCY
         glfEUqlfjQsDf66Vd/Q1hXBjbo+AdTQthHpCFc7sbgGVrWoDvCgFztRfkn2NbXGNa6gi
         yAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782781720; x=1783386520;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w4DnE15DF2Fu15LvNAiz/waMqRGmi/eFj/KwCw6VduY=;
        b=KS+fqeWPA2eCVvTOvKVRxdCSBZJSGwaWHp2dKTC4hQFXGVYvmk5pX7Lfgm4exOEvNw
         ZpwHZaahz0vKt8iWsIpktCh7LdEyNHy4s8fPC/f93pewaj2jed2ALZlXJGVyFXQttVyr
         CMhAVJq3H8K3KjBm8glp0caemAvrL285OFU9irCrVW5+05Sl1i2sNxJt1ppA337EgpU+
         TVjjDleCdqs3R0V0LUgJ+eI4nnhMDqs6Fz71AjJB74hNd/x5ip3I5hI7OsX63QuAbeFc
         LRl1XxTHMoA2ObboyZ9J+8AiD2Jmaby4lwFoi0gR15pW0IzWP/4uj3WGUGKnUBeR8FS6
         STfQ==
X-Gm-Message-State: AOJu0YzNdAHdYk2rxXRbkMfYLtuhmwjgEvhffDyWAmVLsOQXmveL/uvE
	3vfLxgecrRfn09PAPPsHjstsM0Zx0nkhD+LpuOuYQxPWyaetTzx+99lh
X-Gm-Gg: AfdE7cnWzoGXkmPVYx/OjVdqpU6VdcrePaXb9rIUmlfZOalBsZaWVnx8hCvjHZ7P/Nb
	WOB7m2N5aD0oj4kVj10TwjpFvI+U4Sh9y7OFbdzBmTymPSpaeTHy41v5bjyFA1p9S2Cfg+3tXvQ
	sPCk9ABGFbE1eAsk/kYdOPW0IJRY0EdbwX/hTOBH7DZn4KN3Yk3RYzOXmpYYnkHbP2owma3cPPW
	nKWt7HO29LsXVIRKmz9cJ+MezrvjMkoLlaxwFgIKXkZTqSQcpLFXPU8dzbwuUVYh0mYzOAp2U2L
	e3cDT/bW7c+wHlXqyTDrIqt/RS8Om8uB0gxFezU03MYFdv6ctMoEDKHMUi0QklY+OWgrE8I/lYf
	fsjyIGL+VIDfAnpaQpUjOIoISFbxQuRGawg6D6wbox8bQ/nuhNPeSl8Q+KyEGZpi3Q0jXikdtb8
	SAt8EHnrAtd+Vin9ngnkyjVOczbKiUnSNxa0p018vVboRlQiG3Z2MTCBRcQGw=
X-Received: by 2002:a05:6a00:3c93:b0:847:86d3:9326 with SMTP id d2e1a72fcca58-8479f1c72c4mr1252456b3a.26.1782781720328;
        Mon, 29 Jun 2026 18:08:40 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a005afbfsm653310b3a.27.2026.06.29.18.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 18:08:39 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 30 Jun 2026 09:08:18 +0800
Subject: [PATCH v5 2/3] mm: rename swap.c to folio_lru.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-2-4627aba8ed1e@gmail.com>
References: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
In-Reply-To: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1782781697; l=4010;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=Ta+8IM8MGp8fjCoDYDkz/MpytL00oWVPxPoeXHHrRZs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QFAB3a8tJm+Ghq7mj2TMZxy9z8XOhuYkMAYrzIej6rWZLSS9EZLfLyasUPt3qY6Q3VjKr9KO7FO
 6ZJ1UEuVXVAQ=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: 5F9D840003
X-Stat-Signature: ribfu3oirmkio7mcxoucc3r4xy5srfmn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782781721-797818
X-HE-Meta: U2FsdGVkX19xEU2mJlFIuEl82vEmxCiSqPgTb+5PLtI28Lbq8Fsvj4pkfwhP3Af3YPilj6t7w1wsCeUjt1Z0FuYfWGXOM7PpAXp2DR2WiClj7AdEF+JdaNNmoRuyGQq4VfaGbUwZMq4pqIb/qFlWGvkUyIjyRa0gO4KhTxULWuehR+TJihFbYI8dQtRJG0qJMTpbZC2rJU2lne+8yEQUOo85LCdUsVK09/VpXN8fb6w22zt75XEovE6gU6S68vKMEc1jCquVN0gAq4mv4pEv6JU7qj4sOgU2N9xffXNkZeVS0AYjUeExPJG0O/ptZcRXzQtltl83zGWeIXvOLioUzIrGKb5pkSe+41uk6yn0kbaI2ejyE60h7rmft9Bf5zgpg+imxE0JispVx67Zzet0emGzCBVYp5i4fimbrfBpW1jn4pHvjbai1lsjFKqA5PGSGU0UR7i7qkc0JoKUnBmBWqErB8HHa48AIc3be6Eeh6CaDBZYjfun3AwyvMMDeuEwaEZx2DLjXDCvD07buN8DQfPuIGPcV7K0PSzH47XnO3zHt2iWpmBDxDk6D1wl0m1XTNQ9EwRRUJ3pNO2Y/XbS9dq/lGbXnLE/PX8eMMippjtuO1bVzrFKvK+H1RpTV4MSBxyczogNcZ5r49/1AK/NUaTildT80/QF5WJ4ExJGJmVGxkgvCMWbb9p589YR20o/OOq0BPl7RiN6wYcXLweK1kCTxDPk7XDZp/douwGjCLpRh+TB+/WFU7Ha1ZW05/0ShU7WvLnzzLxQuEEBSE3xt59smFm3ktaIIajnElV61IhNvwktMEt+6pZEc19NP3EROwO4j5mZ+Vk0JFOzhR5kH7+8Xq9WrN0CpEcRT7coI4DYg9p+kNhfquurp7Qv5Hvhnr//iMupYNn+0l/cAHMSvcurCavoux0aHXlsk7P3OY0LIDPFjuUqxpGzKN6V5fhkKTB2WIdeE0vSc1SHROg
 1G3pueAz
 VEKmCywi3P4CVBECIuOe7D/MbEIBgFCSvtLdd+jEPCcrvwBp+YEZNBqcIQBIvUm7JchdehAqyDvCEBDSnl6lUIB9yNNdzWgAkftj469vrewOG4243FwXarMNQBElY0o0OVcB4C+kqYyvNQWywRSWCyIyGg+or3dT4mqJE6uQ1tnFZOVbiHyQshuG8yNuJU08aPEZF0zj4N25uUP2AHXM7iUr/wLdCvp/VvvbL4DRIfajRZeD0/VL3AwczdDIPQWG0AzZCRfS+hVkd4TP1zqgQWtwR0j+QQZMCME6bmEcovvJSVbO5Oj6sx2cRMfBLnQ6OVJaLRDdk2UHf+kvE9uwYYroAumtoN7zK94xn+z4W+fv6gqJFJoN0I3Q6MCZdbNDngovzeHAl54eMhDI3sepphjMTFjzEHT5r8PKwmSrv4cdhuKwcIWrQL7YQP8S34djGqsx2SLNuvkMVLuHe/gHapF66fXFCo++H5YPZKAWvYi3QCWPSRbccK9396fb73aVFJQtrZS5N2bKxjB0ChkK39vpyzEvhRh1rL7uq9ATcn4ww6MRlnXq2csgCuXOeuUJ+cSnhx0n4KZdNguZ9iDLtbLkeuHNWKEtHBbX8
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
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst |  3 ---
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +--
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio_lru.c}              | 10 +++-------
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
index dd963b72c614..b92bd62dbe17 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16906,7 +16906,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
-F:	mm/swap.c
+F:	mm/folio_lru.c
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


