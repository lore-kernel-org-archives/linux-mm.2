Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D179C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFFAE6B008A; Fri, 18 Sep 2026 14:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89276B008C; Fri, 18 Sep 2026 14:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC876B0093; Fri, 18 Sep 2026 14:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 950106B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:02:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10B3214075B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:48 +0000 (UTC)
X-FDA: 85227653616.16.6F35C81
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0855480002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QI5ELnGU;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8Lc0jqpGY0qUf0efcamB1alDhLPge61ilYZq9DXRxo=;
	b=MRC8PYJJkE2EcMHSidyyQab3f0k5ByRwPvL7K33wvabBukmMJhN41ADIm1ggKLvhoiVOao
	dzDzYE7pyeE8XMOZgV2XiJ11VKcI+HOigfjoLxCkrlRgX0Q+qQJYPqLuUvADubY/QGq6Ln
	ZGHMdgXFfbUbHB1kC2nEgYuvup6hajI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754566;
	b=dSP+JUxuVQoLuTwNpPVeUgJSiBcCDeFzohCf5ZbBsxS12MbNrj9EweHR8Pz6H4oHsBGxzn
	pH2aWX2DIdc6cBE0/+YcXgDPPQS48yWSjme/pxELWj3NbdWl0c0diAs5BMDwrMowEYWksO
	oIaIAAan/WUCvQfu8UA9Ptq9Nx4jBsw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QI5ELnGU;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7f4f0d37f9dso419786a34.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754565; x=1790359365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y8Lc0jqpGY0qUf0efcamB1alDhLPge61ilYZq9DXRxo=;
        b=QI5ELnGUYAltNnK4GKHZiTvoxOwMU0a6CbkBIo0d042MSCqlvIOf5cDE4rbAACrO3H
         gVlykFj0kXqB4fjBEjrDoI6KZ4jYpb9oS5uM9euy+LNsPbKX32okLaRJ4yA3sQN1RiTI
         W1+zoHi79tl8DY4GNh8dc80s75IYzg+D41dVMfpeM1RPrN2zKrLj2i4eyeONeIE8W8G6
         lv+Rg2eDVuGHuz65uoTTgf3Fu2oWewUxLiTL3tkzd57ht9+16knIpj7r8x7Osf21HOBn
         hszZo8q9vioahPb2CVnDCxhvhvGm4h4rrZXcgnRpTE4sQhgrV/7hi6OlDNV1dy1uuU+3
         4rnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754565; x=1790359365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y8Lc0jqpGY0qUf0efcamB1alDhLPge61ilYZq9DXRxo=;
        b=onLVlKIrIXqhw6FFkpF55aUgnO3QB2vEKRv9zbdXocLReSuAKmxR6+jA7bzHTgsKYr
         TRVe6PxCpV42DMs74MzwLm00DqT7LHNJfQ1d8NTJoOkN2WEL7YU7JTcn992vt54recv/
         r2AYw1FEm4jgfz1e5gxYDLP05Q4NCoOcv2dYhAMxERs2wAWLZiPZMUUaouV8ZjRLLfQI
         WiSroPh9lLLiq5Eot1cKeIou839FXk5cGpdrrO7lAQLgYyj9kUoNL50Rocl9JGh0fJYQ
         SpGbT8WAhbkX5y9OIJxMxH9gg4oap4KL1U51HYV0gE3NcV9aVrJCC+i0hWSsd0N+x6zW
         jZjA==
X-Forwarded-Encrypted: i=1; AKwUvBwF3zkLR4BZx7QyHjuoVDQQM0VEurrRcW6VTs1BTxbOJRxrM8vnEU6GRk3ufp9rjtMM/kMQyWkjkQ==@kvack.org
X-Gm-Message-State: AFuF++nkALbL6k1ib+zbwQvxdWqAEZSA99CYEVkolMeutrOEWP3XqPsv
	uzHyVVVof2256Ww5vvT555Sj82i6ymu+cPKfZXqUPeMAKNNKfPc06uuK
X-Gm-Gg: AYBFou2l9oygZ8D/1rf9JWAgtB+JFX5WiGVn5acYtVhbyQxja3KVXF/Kbw9r9nMRbYi
	Acj7rWrFZxPoQxcqF/sjjPucBZLtIEYP9V1O75BGG22SkjuvRwWv4A68Av/NOrBy6ckVChRNR8t
	znLJLhVleIK4m+GSP1xDltm6Two3ldThN6WrT0qX+BJtQe7NANwznvp1MIFUNm76HwkBxDoHOxL
	BOkD0zO1hTx7r5SAKauCBAtkuJtf6rU09O953yNysSPawGONWvcbtAlqjggW0mMd+ir0QNEgsCR
	Tut95KQTwS6DyPOfCOTSelyxGcu5zxtwl6QX/OdDZSbfgTHlwEMPncK+osl+eULgAWa9xjKyjup
	3y6XkWv+URt7xnq9pyPwv6i5UXkdsZyAE2j2ZM9J+qVLHTfA5ZhAMJkxdp2uZdAr7HQpSatRhjE
	30SsbeWHhhkIuoXGlqlPM9HGKUI5qHSqmJfPbjgiVnVM8UPeHmJMZbeJGomVLb4DPrFzSk2ZA+w
	jUKgpjLjHVOzn7a/EU/2Q==
X-Received: by 2002:a05:6830:6819:b0:7fa:5c49:524b with SMTP id 46e09a7af769-80de2bd367fmr3986990a34.18.1789754564497;
        Fri, 18 Sep 2026 11:02:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8107e389850sm138395a34.10.2026.09.18.11.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:43 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
Date: Fri, 18 Sep 2026 11:02:31 -0700
Message-ID: <20260918180241.3424851-2-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: j9wbd3jy1cwsjh7c69hiq44mattpawqy
X-Rspamd-Queue-Id: 0855480002
X-HE-Tag: 1789754565-801530
X-HE-Meta: U2FsdGVkX19YUgyaQg1EGAho0vE1/a+l/0FhL7ZlP/BuxJCkPzKScGgt1V+u5lzPDPPQiy+3wwHww9LdcJu7GMYI78kDOLwfz0rZOSoHIsK4Vigf/Lv8vnu8liRUc+XCb/If8qs2Sgm+ZRUaxO1SZuq/BXoSkHcvrMJ3HpFmdOFnZaIr7aPJh3QTfOAxgO9jcSQF0b1JavZINUnTkxGXnffztDWp0jPKplMZrZqn7dadPUsEctF8fm+UDtsK5eZxu1pFR5EtMZMt5fFs+3XaLd0S9wvcee8iFcSJ+6OkGfZ+NXah3Uzw93fNE4Q1lLi83xu0oe7CyxfIDBnipQa8tjDx6hnwxqYGB0rmFBy3KbQzcIqgFL2zm5zdt+UNs0chhZBO7s0BAKr05PE1J3an0bCJt/q9VZcc2JBIT18+YMc+soRNYKDWnBJszOUwrdzov/+zfbvm0LhahwuiJnaS2RiV+s5b/9WPvJXlzFopPFHeAHJp74Q2+e+ngQhW2uFyyUempPUrmpGAwd6wAftQSUmHc5cIWGP+gboa5iIcTFspUUwEod/v2JYx6CcgvO6fjTy0LPgRp93ikDaYXpdL7sIoHP6WlUw6mEdfdDOp60SxA/ztWaPH4tagb48nXuUZdjgIfHyrgehdJzBL1Nw7rQnWxEQzQbxaWS28nYt8iSEFBA0cbArZ7BJoZzcegrodZCQZpWHay9u/xO7W7jb1zto4otWGg6AmFmSPo3rv6E7oNotIPBa08JK4JQlUM4Swe/OIqUJ5ZuoNzggfQiKCUsLsu17uwF8jAzAlEkRVcUu39AbfxrGqp0QA15e+0iYyPwt/lySAsuWqd+Kns4azDSQ5+eQ4Ust5oC0FWfRalUskJXgjGd8fgMR/PCdT0rCdGRSA3hpn6gasKgpJxkR52A4FfrPUOjzCrufxC3aT16cTR+CVJyrnEOROrcWYpbljQr7GWMl1zNlxuyc/Tgj
 RXJf5eJX
 j0F0IuqBP0/3mBvqUucBeoZXRfKy9Sa1XGhIJFXaEQhw9D3GW8OdjTBPRZqfhG0WwHlCr+USpqaHPE5Cs+xgnv/H0tTMKtJq7c6iMjHGDNRDsLDXQY6i+bQi3iQQjNJqIEkvLurGgmrW8yFU/5GyUGGnR6vYpda7r1146mLPIgx70khP6MFaS15hAcMX0sgLmMg/nYWfXICGGgC93/4cGrYUCIcKuf4cJlkWgKCRfFmitR/I/oIrfXrz0pcDS+yU4qfKxHcAZh8CaMGWjaGjDGHhfJF+4JpLW7YQJGRu0pL91JcCDK95XC2oKa9jbdjyDI/mhR2LyZVT8pI22nrpsqxbEHHNcK/XyKOCbxy/9/83MtBPAGbWJGfLlStuMgG3G0qOfHokOwXcVqixBzM4kt+BBrSOIVNhkzV4CHU5tb+byUJAe2BtDoOdHyFkJ82K4pf1CrB/AGMzOWjk4V3SG7dm2jHex1HAPl36/W4ceSrLVpdeBCjW+o5T63dA/pasVWYpUFNnDdZJ3s/vCtndxa9jtHcnlirQPKqqdjHD3/ssPwR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create a virtual swap device (just under 8 TiB with 4 KiB pages), along
with the dynamic cluster infrastructure that the rest of the vswap layer is
built on. swap_cluster_info_dynamic keeps per-cluster info in an xarray, so
a device can be sized without a static cluster_info[] array. For now, vswap
requires a 64-bit architecture.

swap_table_lookup() resolves a swap entry's cluster and reads its slot,
both under RCU. A vswap cluster is allocated on demand and freed by
kfree_rcu(), so an unpinned entry cannot have its cluster resolved
beforehand, and the lookup can return NULL. Callers holding a pinned
entry keep resolving it themselves: the pin holds ci->count above zero,
so the cluster cannot be destroyed. mm/workingset.c includes swap_table.h
with CONFIG_SWAP off, so the helpers swap_table_lookup() calls gain
!CONFIG_SWAP stubs.

The dynamic-cluster allocator is wired in, but nothing reaches it yet.
vswap_si is kept off the swap device lists, and no allocation path can
select it. Backends (zswap, zero, physical disk) and the vswap-aware
swap-out / swap-in / writeback paths arrive in subsequent patches.

Routing is controlled by the "vswap=" kernel parameter, defaulting to
CONFIG_VSWAP_DEFAULT_ON. When off, no device exists, every vswap path is
skipped, and swap behavior is unchanged. When on, vswap_init() creates
the device and enables a static key only after it is fully published, so
callers never observe a half-built device. The device lives for the
lifetime of the kernel and cannot be swapon'd or swapoff'd.

The device is capped at REFCOUNT_MAX pages, just under 8 TiB with 4 KiB
pages. Every swapped page takes a reference on its cgroup's
memcg->private_id_ref, a 32-bit refcount_t, so a cgroup that swaps past
that saturates it and leaks the memcg until reboot. The limit is not
specific to vswap, a physical swapfile that large hits it too, but vswap
is the first device that can reach it without provisioning the storage.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 .../admin-guide/kernel-parameters.txt         |   7 +
 MAINTAINERS                                   |   1 +
 include/linux/swap.h                          |   9 +
 mm/Kconfig                                    |  20 ++
 mm/page_io.c                                  |  14 +
 mm/swap.h                                     |  77 ++++-
 mm/swap_state.c                               |  40 +--
 mm/swap_table.h                               |  27 ++
 mm/swapfile.c                                 | 275 ++++++++++++++++--
 mm/vswap.h                                    |  34 +++
 mm/zswap.c                                    |   6 +
 11 files changed, 468 insertions(+), 42 deletions(-)
 create mode 100644 mm/vswap.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..646e689d9e80 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8431,6 +8431,13 @@ Kernel parameters
 			force		- force vulnerability detection even on
 					  unaffected processors
 
+	vswap=		[MM,EARLY]
+			Route swapouts through the virtual swap layer, which
+			allows zswap and zero-filled pages to be used without
+			a physical swap device. 64-bit only.
+			Format: { on | off }
+			Default: on if CONFIG_VSWAP_DEFAULT_ON=y, else off.
+
 	vsyscall=	[X86-64,EARLY]
 			Controls the behavior of vsyscalls (i.e. calls to
 			fixed addresses of 0xffffffffff600x00 from legacy
diff --git a/MAINTAINERS b/MAINTAINERS
index e4412c3d8d45..e49a3d4e332b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17411,6 +17411,7 @@ F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
 F:	mm/swapfile.c
+F:	mm/vswap.h
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 61005501888c..0b341301d8fa 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -201,6 +201,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_VSWAP	= (1 << 14),	/* virtual swap device */
 					/* add others here before... */
 };
 
@@ -270,8 +271,14 @@ struct swap_info_struct {
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
+	struct xarray cluster_info_pool; /* Xarray for vswap dynamic cluster info */
 };
 
+static inline bool swap_is_vswap(struct swap_info_struct *si)
+{
+	return si->flags & SWP_VSWAP;
+}
+
 /**
  * folio_swap_entry - Return the swap entry at a page index within a folio.
  * @folio: The folio.
@@ -427,6 +434,8 @@ void swap_free_hibernation_slot(swp_entry_t entry);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
+	if (swap_is_vswap(si))
+		return;
 	percpu_ref_put(&si->users);
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 30170a936f1f..beef56e870ce 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -19,6 +19,26 @@ menuconfig SWAP
 	  used to provide more virtual memory than the actual RAM present
 	  in your computer.  If unsure say Y.
 
+config VSWAP_DEFAULT_ON
+	bool "Route swapouts through virtual swap by default"
+	depends on SWAP && 64BIT
+	default n
+	help
+	  Virtual swap allows zswap and zero-filled pages to be used
+	  without swapping on a physical device first, and lets a page
+	  move between zswap and a swapfile without invalidating the page
+	  table entries that refer to it.
+
+	  Swap entries are handed out by a virtual swap device instead of
+	  naming a slot on a real one, so the backing can be chosen and
+	  changed after the entry exists.
+
+	  Say Y to make "vswap=on" the default, routing swapouts through
+	  the virtual swap layer from boot.
+
+	  Say N (default) to leave vswap off unless "vswap=on" is passed
+	  on the kernel command line.
+
 config ZSWAP
 	bool "Compressed cache for swap pages"
 	depends on SWAP
diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..5cd77bd1b12c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -28,6 +28,7 @@
 #include <linux/swap_ops.h>
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 
 int generic_swapfile_activate(struct swap_info_struct *sis,
 				struct file *swap_file,
@@ -248,6 +249,14 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
+	/*
+	 * A vswap folio has no physical slot to write to, so keep it dirty.
+	 */
+	if (is_vswap_entry(folio->swap)) {
+		folio_mark_dirty(folio);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
 	__swap_writeout(ctx, folio);
 	return 0;
 out_unlock:
@@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
 	if (zswap_load(folio) != -ENOENT)
 		goto finish;
 
+	if (unlikely(swap_is_vswap(sis))) {
+		folio_unlock(folio);
+		goto finish;
+	}
+
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 	swap_add_folio(ctx, folio, READ);
diff --git a/mm/swap.h b/mm/swap.h
index b3b54c28929a..528a27afb335 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -67,6 +67,12 @@ struct swap_cluster_info {
 	struct list_head list;
 };
 
+struct swap_cluster_info_dynamic {
+	struct swap_cluster_info ci;
+	unsigned int index;		/* for cluster_index() */
+	struct rcu_head rcu;
+};
+
 /* All on-list cluster must have a non-zero flag. */
 enum swap_cluster_flags {
 	CLUSTER_FLAG_NONE = 0, /* For temporary off-list cluster */
@@ -77,6 +83,7 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_USABLE = CLUSTER_FLAG_FRAG,
 	CLUSTER_FLAG_FULL,
 	CLUSTER_FLAG_DISCARD,
+	CLUSTER_FLAG_DEAD,	/* Vswap dynamic cluster pending kfree_rcu */
 	CLUSTER_FLAG_MAX,
 };
 
@@ -119,12 +126,33 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 	return __swap_type_to_info(swp_type(entry));
 }
 
+/**
+ * __swap_offset_to_cluster - look up the cluster holding a swap offset
+ * @si: the swap device
+ * @offset: the swap entry offset
+ *
+ * Context: A vswap cluster is freed by kfree_rcu(). Callers must hold the
+ * RCU read lock, or know the cluster is pinned by an in-use entry.
+ *
+ * Return: the cluster, or NULL if @si is a vswap device with no cluster
+ * allocated at @offset.
+ */
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
+	unsigned int cluster_idx = offset / SWAPFILE_CLUSTER;
+
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
 	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
-	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
+
+	if (swap_is_vswap(si)) {
+		struct swap_cluster_info_dynamic *ci_dyn;
+
+		ci_dyn = xa_load(&si->cluster_info_pool, cluster_idx);
+		return ci_dyn ? &ci_dyn->ci : NULL;
+	}
+
+	return &si->cluster_info[cluster_idx];
 }
 
 static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entry)
@@ -133,10 +161,36 @@ static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entr
 					swp_offset(entry));
 }
 
+static inline struct swap_cluster_info *__vswap_cluster_lock(
+		struct swap_info_struct *si, unsigned long offset, bool irq)
+{
+	struct swap_cluster_info *ci;
+
+	rcu_read_lock();
+	ci = __swap_offset_to_cluster(si, offset);
+	if (ci) {
+		if (irq)
+			spin_lock_irq(&ci->lock);
+		else
+			spin_lock(&ci->lock);
+
+		/* The cluster can be torn down while we wait for the lock. */
+		if (ci->flags == CLUSTER_FLAG_DEAD) {
+			if (irq)
+				spin_unlock_irq(&ci->lock);
+			else
+				spin_unlock(&ci->lock);
+			ci = NULL;
+		}
+	}
+	rcu_read_unlock();
+	return ci;
+}
+
 static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset, bool irq)
 {
-	struct swap_cluster_info *ci = __swap_offset_to_cluster(si, offset);
+	struct swap_cluster_info *ci;
 
 	/*
 	 * Nothing modifies swap cache in an IRQ context. All access to
@@ -149,6 +203,11 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 	 */
 	VM_WARN_ON_ONCE(!in_task());
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+
+	if (swap_is_vswap(si))
+		return __vswap_cluster_lock(si, offset, irq);
+
+	ci = __swap_offset_to_cluster(si, offset);
 	if (irq)
 		spin_lock_irq(&ci->lock);
 	else
@@ -159,10 +218,12 @@ static __always_inline struct swap_cluster_info *__swap_cluster_lock(
 /**
  * swap_cluster_lock - Lock and return the swap cluster of given offset.
  * @si: swap device the cluster belongs to.
- * @offset: the swap entry offset, pointing to a valid slot.
+ * @offset: the swap entry offset.
  *
  * Context: The caller must ensure the offset is in the valid range and
  * protect the swap device with reference count or locks.
+ * Return: the locked cluster, or NULL if it is gone. Only a vswap device
+ * can return NULL, as its clusters are allocated and freed on demand.
  */
 static inline struct swap_cluster_info *swap_cluster_lock(
 		struct swap_info_struct *si, unsigned long offset)
@@ -363,6 +424,16 @@ static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 	return NULL;
 }
 
+static inline struct swap_cluster_info *__swap_entry_to_cluster(swp_entry_t entry)
+{
+	return NULL;
+}
+
+static inline unsigned int swp_cluster_offset(swp_entry_t entry)
+{
+	return 0;
+}
+
 static inline int folio_alloc_swap(struct folio *folio)
 {
 	return -EINVAL;
diff --git a/mm/swap_state.c b/mm/swap_state.c
index cef44aadee61..424a0040b4b8 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -96,8 +96,7 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-					swp_cluster_offset(entry));
+		swp_tb = swap_table_lookup(entry);
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -119,8 +118,7 @@ bool swap_cache_has_folio(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
-	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-				swp_cluster_offset(entry));
+	swp_tb = swap_table_lookup(entry);
 	return swp_tb_is_folio(swp_tb);
 }
 
@@ -136,8 +134,7 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
-	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-				swp_cluster_offset(entry));
+	swp_tb = swap_table_lookup(entry);
 	if (swp_tb_is_shadow(swp_tb))
 		return swp_tb_to_shadow(swp_tb);
 	return NULL;
@@ -414,14 +411,16 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
  * -ENOENT / -EEXIST: Target swap entry is unavailable or cached, the caller
  *                    should abort or try to use the cached folio instead
  */
-static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
-					swp_entry_t targ_entry, gfp_t gfp,
+static struct folio *__swap_cache_alloc(swp_entry_t targ_entry, gfp_t gfp,
 					unsigned int order, struct vm_fault *vmf,
 					struct mempolicy *mpol, pgoff_t ilx)
 {
 	int err;
 	swp_entry_t entry;
 	struct folio *folio;
+	struct swap_cluster_info *ci;
+	struct swap_info_struct *si = __swap_entry_to_info(targ_entry);
+	unsigned long offset = swp_offset(targ_entry);
 	void *shadow = NULL;
 	unsigned short memcg_id;
 	unsigned long address, nr_pages = 1UL << order;
@@ -431,9 +430,12 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	entry.val = round_down(targ_entry.val, nr_pages);
 
 	/* Check if the slot and range are available, skip allocation if not */
-	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
-	spin_unlock(&ci->lock);
+	err = -ENOENT;
+	ci = swap_cluster_lock(si, offset);
+	if (ci) {
+		err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
+		swap_cluster_unlock(ci);
+	}
 	if (unlikely(err))
 		return ERR_PTR(err);
 
@@ -454,10 +456,13 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 		return ERR_PTR(-ENOMEM);
 
 	/* Double check the range is still not in conflict */
-	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
+	err = -ENOENT;
+	ci = swap_cluster_lock(si, offset);
+	if (ci)
+		err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
 	if (unlikely(err)) {
-		spin_unlock(&ci->lock);
+		if (ci)
+			swap_cluster_unlock(ci);
 		folio_put(folio);
 		return ERR_PTR(err);
 	}
@@ -465,10 +470,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 	__swap_cache_do_add_folio(ci, folio, entry);
-	spin_unlock(&ci->lock);
+	swap_cluster_unlock(ci);
 
 	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
 					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
+		/* The folio pins the cluster */
 		spin_lock(&ci->lock);
 		__swap_cache_do_del_folio(ci, folio, entry, shadow);
 		spin_unlock(&ci->lock);
@@ -525,9 +531,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 {
 	int order, err;
 	struct folio *ret;
-	struct swap_cluster_info *ci;
 
-	ci = __swap_entry_to_cluster(targ_entry);
 	order = highest_order(orders);
 
 	/* orders must be non-zero, and must not exceed cluster size. */
@@ -535,7 +539,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 		return ERR_PTR(-EINVAL);
 
 	do {
-		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
+		ret = __swap_cache_alloc(targ_entry, gfp, order,
 					 vmf, mpol, ilx);
 		if (!IS_ERR(ret))
 			break;
diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..3d64d1629882 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -6,6 +6,8 @@
 #include <linux/atomic.h>
 #include "swap.h"
 
+extern struct swap_info_struct *vswap_si;
+
 /* A typical flat array in each cluster as swap table */
 struct swap_table {
 	atomic_long_t entries[SWAPFILE_CLUSTER];
@@ -264,6 +266,31 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	return swp_tb;
 }
 
+/*
+ * Resolve @entry's cluster and read its slot, both under RCU. A vswap
+ * cluster is allocated on demand and freed by kfree_rcu(), so a caller
+ * starting from an entry cannot resolve it beforehand.
+ */
+static inline unsigned long swap_table_lookup(swp_entry_t entry)
+{
+	struct swap_cluster_info *ci;
+	atomic_long_t *table;
+	unsigned long swp_tb;
+
+	rcu_read_lock();
+	ci = __swap_entry_to_cluster(entry);
+	if (!ci) {
+		rcu_read_unlock();
+		return null_to_swp_tb();
+	}
+	table = rcu_dereference(ci->table);
+	swp_tb = table ? atomic_long_read(&table[swp_cluster_offset(entry)])
+		       : null_to_swp_tb();
+	rcu_read_unlock();
+
+	return swp_tb;
+}
+
 static inline void __swap_table_set_zero(struct swap_cluster_info *ci,
 					 unsigned int ci_off)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c1c5fbb3c909..edd7bddf7ff9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -36,6 +36,7 @@
 #include <linux/poll.h>
 #include <linux/oom.h>
 #include <linux/swapfile.h>
+#include <linux/swap_ops.h>
 #include <linux/export.h>
 #include <linux/sort.h>
 #include <linux/completion.h>
@@ -46,6 +47,7 @@
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
 #include "swap_table.h"
+#include "vswap.h"
 #include "internal.h"
 #include "swap.h"
 
@@ -399,6 +401,8 @@ static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 static inline unsigned int cluster_index(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci)
 {
+	if (swap_is_vswap(si))
+		return container_of(ci, struct swap_cluster_info_dynamic, ci)->index;
 	return ci - si->cluster_info;
 }
 
@@ -594,10 +598,15 @@ static void move_cluster(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 
 	spin_lock(&si->lock);
-	if (ci->flags == CLUSTER_FLAG_NONE)
+	if (!list) {
+		/* Going away. An isolated cluster is already off its list. */
+		if (ci->flags != CLUSTER_FLAG_NONE)
+			list_del(&ci->list);
+	} else if (ci->flags == CLUSTER_FLAG_NONE) {
 		list_add_tail(&ci->list, list);
-	else
+	} else {
 		list_move_tail(&ci->list, list);
+	}
 	spin_unlock(&si->lock);
 	ci->flags = new_flags;
 }
@@ -615,6 +624,18 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 {
 	swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, false);
 	swap_cluster_free_table(ci);
+
+	if (swap_is_vswap(si)) {
+		struct swap_cluster_info_dynamic *ci_dyn;
+
+		/* vswap clusters are destroyed, not returned to free_clusters. */
+		ci_dyn = container_of(ci, struct swap_cluster_info_dynamic, ci);
+		xa_erase(&si->cluster_info_pool, ci_dyn->index);
+		move_cluster(si, ci, NULL, CLUSTER_FLAG_DEAD);
+		kfree_rcu(ci_dyn, rcu);
+		return;
+	}
+
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 }
@@ -851,6 +872,8 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	unsigned long offset = start, end = start + nr_pages;
 	unsigned long swp_tb;
 
+	VM_WARN_ON_ONCE(swap_is_vswap(si));
+
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
@@ -1042,6 +1065,44 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 	return found;
 }
 
+static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
+					struct folio *folio)
+{
+	struct swap_cluster_info_dynamic *ci_dyn;
+	struct swap_cluster_info *ci;
+	unsigned long offset;
+
+	VM_WARN_ON(!swap_is_vswap(si));
+
+	ci_dyn = kzalloc_obj(*ci_dyn, GFP_ATOMIC | __GFP_NOWARN);
+	if (!ci_dyn)
+		return SWAP_ENTRY_INVALID;
+
+	spin_lock_init(&ci_dyn->ci.lock);
+	INIT_LIST_HEAD(&ci_dyn->ci.list);
+
+	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC | __GFP_NOWARN)) {
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
+	/* Lock before publishing: xa_alloc makes the cluster findable by offset. */
+	ci = &ci_dyn->ci;
+	spin_lock(&ci->lock);
+
+	if (xa_alloc(&si->cluster_info_pool, &ci_dyn->index, ci_dyn,
+		     XA_LIMIT(1, DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER) - 1),
+		     GFP_ATOMIC | __GFP_NOWARN)) {
+		spin_unlock(&ci->lock);
+		swap_cluster_free_table(&ci_dyn->ci);
+		kfree(ci_dyn);
+		return SWAP_ENTRY_INVALID;
+	}
+
+	offset = cluster_offset(si, ci);
+	return alloc_swap_scan_cluster(si, ci, folio, offset);
+}
+
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 {
 	long to_scan = 1;
@@ -1064,7 +1125,9 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 				spin_unlock(&ci->lock);
 				nr_reclaim = __try_to_reclaim_swap(si, offset,
 								   TTRS_ANYWAY);
-				spin_lock(&ci->lock);
+				ci = swap_cluster_lock(si, offset);
+				if (!ci)
+					goto next;
 				if (nr_reclaim) {
 					offset += abs(nr_reclaim);
 					continue;
@@ -1078,6 +1141,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
+next:
 		if (to_scan <= 0)
 			break;
 
@@ -1154,6 +1218,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
+	if (swap_is_vswap(si)) {
+		found = vswap_alloc_cluster(si, folio);
+		if (found)
+			goto done;
+	}
+
 	if (!(si->flags & SWP_PAGE_DISCARD)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
@@ -1290,8 +1360,10 @@ static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
 	/*
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
 	 * remove it from the plist.
+	 *
+	 * Vswap is never on the avail list, so skip it.
 	 */
-	if (unlikely(val == si->pages)) {
+	if (unlikely(val == si->pages) && !swap_is_vswap(si)) {
 		del_from_avail_list(si, false);
 		return true;
 	}
@@ -1306,8 +1378,10 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
 	/*
 	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
 	 * add it to the plist.
+	 *
+	 * Vswap is never on the avail list, so skip it.
 	 */
-	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
+	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT) && !swap_is_vswap(si))
 		add_to_avail_list(si, false);
 }
 
@@ -1352,6 +1426,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 
 static bool get_swap_device_info(struct swap_info_struct *si)
 {
+	/* The vswap device is always alive, so it needs no refcount. */
+	if (swap_is_vswap(si))
+		return true;
+
 	if (!percpu_ref_tryget_live(&si->users))
 		return false;
 	/*
@@ -1387,11 +1465,11 @@ static bool swap_alloc_fast(struct folio *folio)
 		return false;
 
 	ci = swap_cluster_lock(si, offset);
-	if (cluster_is_usable(ci, order)) {
+	if (ci && cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
 		alloc_swap_scan_cluster(si, ci, folio, offset);
-	} else {
+	} else if (ci) {
 		swap_cluster_unlock(ci);
 	}
 
@@ -1513,6 +1591,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	if (IS_ERR_OR_NULL(si))
 		return 0;
 
+	/* The source PTE pins the entry, so its cluster is alive. */
 	ci = __swap_offset_to_cluster(si, offset);
 	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
@@ -1923,7 +2002,7 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 put_out:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	percpu_ref_put(&si->users);
+	put_swap_device(si);
 	return ERR_PTR(-EIO);
 }
 
@@ -2002,7 +2081,7 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	unsigned long swp_tb;
 
 	ci = swap_cluster_lock(si, offset);
-	swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
+	swp_tb = __swap_table_get(ci, swp_cluster_offset(entry));
 	swap_cluster_unlock(ci);
 
 	return swp_tb_get_count(swp_tb) > 0;
@@ -2055,6 +2134,7 @@ static bool folio_maybe_swapped(struct folio *folio)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	/* Folio is locked and in swap cache, so ci->count > 0: cluster is alive. */
 	ci = __swap_entry_to_cluster(entry);
 	ci_off = swp_cluster_offset(entry);
 	ci_end = ci_off + folio_nr_pages(folio);
@@ -2249,6 +2329,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* vswap has no bdev, so it is never a hibernation target. */
+		if (swap_is_vswap(sis))
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2375,6 +2458,9 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* vswap has no bdev, so it is never a hibernation target. */
+		if (swap_is_vswap(sis))
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -2591,8 +2677,7 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 						&vmf);
 		}
 		if (!folio) {
-			swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-						swp_cluster_offset(entry));
+			swp_tb = swap_table_lookup(entry);
 			if (swp_tb_get_count(swp_tb) <= 0)
 				continue;
 			return -ENOMEM;
@@ -3022,15 +3107,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 
 static void _enable_swap_info(struct swap_info_struct *si)
 {
-	atomic_long_add(si->pages, &nr_swap_pages);
-	total_swap_pages += si->pages;
+	if (!swap_is_vswap(si)) {
+		atomic_long_add(si->pages, &nr_swap_pages);
+		total_swap_pages += si->pages;
+	}
 
 	assert_spin_locked(&swap_lock);
 
-	plist_add(&si->list, &swap_active_head);
+	/*
+	 * Vswap has no backing file and no swapoff support, so keep it
+	 * off swap_active_head (used by swapoff filename lookup and
+	 * swap_sync_discard) and swap_avail_head (physical allocator).
+	 */
+	if (!swap_is_vswap(si)) {
+		plist_add(&si->list, &swap_active_head);
 
-	/* Add back to available list */
-	add_to_avail_list(si, true);
+		/* Add back to available list */
+		add_to_avail_list(si, true);
+	}
 }
 
 /*
@@ -3074,12 +3168,31 @@ static void wait_for_allocation(struct swap_info_struct *si)
 	}
 }
 
-static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
+static void free_swap_cluster_info(struct swap_info_struct *si,
+				   struct swap_cluster_info *cluster_info,
 				   unsigned long maxpages)
 {
+	struct swap_cluster_info_dynamic *ci_dyn;
 	struct swap_cluster_info *ci;
+	unsigned long idx;
 	int i, nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
+	if (swap_is_vswap(si)) {
+		xa_for_each(&si->cluster_info_pool, idx, ci_dyn) {
+			ci = &ci_dyn->ci;
+			spin_lock(&ci->lock);
+			if (cluster_table_is_alloced(ci)) {
+				swap_cluster_assert_empty(ci, 0,
+							  SWAPFILE_CLUSTER, true);
+				swap_cluster_free_table(ci);
+			}
+			spin_unlock(&ci->lock);
+			kfree(ci_dyn);
+		}
+		xa_destroy(&si->cluster_info_pool);
+		return;
+	}
+
 	if (!cluster_info)
 		return;
 	for (i = 0; i < nr_clusters; i++) {
@@ -3226,7 +3339,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p, cluster_info, maxpages);
 
 	inode = mapping->host;
 
@@ -3573,10 +3686,39 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 				    unsigned long maxpages)
 {
 	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
-	struct swap_cluster_info *cluster_info;
+	struct swap_cluster_info *cluster_info = NULL;
+	struct swap_cluster_info_dynamic *ci_dyn = NULL;
 	int err = -ENOMEM;
 	unsigned long i;
 
+	/* A vswap device uses an xarray pool instead of a static array. */
+	if (swap_is_vswap(si)) {
+		nr_clusters = 0;
+		xa_init_flags(&si->cluster_info_pool, XA_FLAGS_ALLOC);
+
+		/*
+		 * Pre-allocate cluster 0 and mark slot 0 (header page)
+		 * as bad so the allocator never hands out page offset 0.
+		 */
+		ci_dyn = kzalloc_obj(*ci_dyn, GFP_KERNEL);
+		if (!ci_dyn)
+			goto err;
+		spin_lock_init(&ci_dyn->ci.lock);
+		INIT_LIST_HEAD(&ci_dyn->ci.list);
+
+		err = xa_insert(&si->cluster_info_pool, 0, ci_dyn, GFP_KERNEL);
+		if (err) {
+			kfree(ci_dyn);
+			goto err;
+		}
+
+		err = swap_cluster_setup_bad_slot(si, &ci_dyn->ci, 0, false);
+		if (err)
+			goto err;
+
+		goto setup_cluster_info;
+	}
+
 	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
 	if (!cluster_info)
 		goto err;
@@ -3620,6 +3762,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			goto err;
 	}
 
+setup_cluster_info:
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);
@@ -3641,10 +3784,16 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		}
 	}
 
+	/* Slot 0 is bad, so cluster 0 never empties. The rest of it is usable. */
+	if (swap_is_vswap(si)) {
+		ci_dyn->ci.flags = CLUSTER_FLAG_NONFULL;
+		list_add_tail(&ci_dyn->ci.list, &si->nonfull_clusters[0]);
+	}
+
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(si, cluster_info, maxpages);
 	return err;
 }
 
@@ -3866,7 +4015,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	free_swap_cluster_info(si->cluster_info, si->max);
+	free_swap_cluster_info(si, si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
@@ -3997,3 +4146,87 @@ static int __init swapfile_init(void)
 	return 0;
 }
 subsys_initcall(swapfile_init);
+
+struct swap_info_struct *vswap_si;
+DEFINE_STATIC_KEY_FALSE(vswap_key);
+
+static bool vswap_enabled_early __initdata = IS_ENABLED(CONFIG_VSWAP_DEFAULT_ON);
+
+static int __init early_vswap(char *buf)
+{
+	return kstrtobool(buf, &vswap_enabled_early);
+}
+early_param("vswap", early_vswap);
+
+/* vswap does no IO on its own. */
+static const struct swap_ops vswap_ops = { };
+
+static int __init vswap_init(void)
+{
+	struct swap_info_struct *si;
+	unsigned long maxpages;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_64BIT)) {
+		if (vswap_enabled_early)
+			pr_warn("vswap: requires 64-bit architecture; vswap disabled, swapout falls back to direct physical swap\n");
+		return 0;
+	}
+
+	if (!vswap_enabled_early)
+		return 0;
+
+	si = alloc_swap_info();
+	if (IS_ERR(si)) {
+		pr_warn("vswap: alloc_swap_info failed (%ld); vswap disabled, swapout falls back to direct physical swap\n",
+			PTR_ERR(si));
+		return 0;
+	}
+
+	/*
+	 * Each swapped page holds a reference on its cgroup's
+	 * memcg->private_id_ref, a 32-bit refcount_t, so a cgroup that swaps
+	 * REFCOUNT_MAX pages saturates it and leaks the memcg until reboot.
+	 * Cap the device there; that also keeps page counts inside si->max's
+	 * unsigned int. Lifting it needs the memcg refcount widened, which a
+	 * physical swapfile of this size needs too.
+	 */
+	maxpages = min(swapfile_maximum_size,
+		       ALIGN_DOWN((unsigned long)REFCOUNT_MAX, SWAPFILE_CLUSTER));
+	/*
+	 * SWP_WRITEOK enables slot allocation. SWP_SOLIDSTATE selects
+	 * per-CPU cluster allocation; vswap has no si->global_cluster.
+	 */
+	si->flags |= SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;
+	si->ops = &vswap_ops;
+	si->bdev = NULL;
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+
+	INIT_WORK(&si->discard_work, swap_discard_work);
+	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
+
+	err = setup_swap_clusters_info(si, NULL, maxpages);
+	if (err)
+		goto fail;
+
+	mutex_lock(&swapon_mutex);
+	enable_swap_info(si);
+	mutex_unlock(&swapon_mutex);
+
+	vswap_si = si;
+	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
+
+	/* Last: everything above must be visible before routing starts. */
+	static_branch_enable(&vswap_key);
+	return 0;
+
+fail:
+	pr_warn("vswap: setup_swap_clusters_info failed (%d); vswap disabled, swapout falls back to direct physical swap\n",
+		err);
+	spin_lock(&swap_lock);
+	si->flags = 0;
+	spin_unlock(&swap_lock);
+	return 0;
+}
+late_initcall(vswap_init);
diff --git a/mm/vswap.h b/mm/vswap.h
new file mode 100644
index 000000000000..16395f357955
--- /dev/null
+++ b/mm/vswap.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Virtual swap space
+ *
+ * Copyright (C) 2026 Nhat Pham
+ */
+#ifndef _MM_VSWAP_H
+#define _MM_VSWAP_H
+
+#include <linux/jump_label.h>
+#include <linux/swap.h>
+#include "swap.h"
+
+#ifdef CONFIG_SWAP
+
+DECLARE_STATIC_KEY_FALSE(vswap_key);
+
+/*
+ * Only true once vswap_init() has published vswap_si, so callers never
+ * see the device half built.
+ */
+static inline bool vswap_is_enabled(void)
+{
+	return static_branch_unlikely(&vswap_key);
+}
+
+static inline bool is_vswap_entry(swp_entry_t entry)
+{
+	return swap_is_vswap(__swap_entry_to_info(entry));
+}
+
+#endif /* CONFIG_SWAP */
+
+#endif /* _MM_VSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index 507f2d19fd2a..73728b510ff6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1018,6 +1018,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
+	/* Vswap entries have no physical backing to write to. */
+	if (swap_is_vswap(si)) {
+		put_swap_device(si);
+		return -EINVAL;
+	}
+
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
-- 
2.53.0-Meta


