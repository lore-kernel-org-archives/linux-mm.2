Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9EFFC61DC2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3B66B008C; Tue, 25 Aug 2026 11:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55276B0092; Tue, 25 Aug 2026 11:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5176B0095; Tue, 25 Aug 2026 11:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6346E6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCDB7120498
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:45 +0000 (UTC)
X-FDA: 85140184290.10.84A8CF5
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id B110D8000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Xe/QmyBf";
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMGygkVCQST0F/zwz/Ue1uFqPHUtxjmJAwo4+G9sBQo=;
	b=qHjOLtRET0dU+PdoTbxS9b2rBmilORJGESA++fJUo7huCCTpFD4DQmjQKas3X0qWTgfjzo
	6F/fUi4LDabmY3EgjhtnMinu1gd39plAmz5ZRWOMk/AsgQk/SyEOkJOrZlYbfs3AlkrphE
	uGAzd9uedwBNWWwjpKDtpaGzPN3gkv8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671963;
	b=IvnXNQtd7cb7KwKPXmunfBFmglTNt5lt3UFyBS25YRoErk+wdE/VUkOHqxhxti/gDvZZgY
	a9I6ipHTxwMqCXO8J4OxuYd1oqiFzcvu5/jeaJ5oZhU89pnQI1fuciw0dT1BtDgzae37yC
	zStLyD93xF+u79pO2Vj2gi4ZOmdDc24=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Xe/QmyBf";
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-45171f2f608so4507422fac.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671963; x=1788276763; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xMGygkVCQST0F/zwz/Ue1uFqPHUtxjmJAwo4+G9sBQo=;
        b=Xe/QmyBf7GU1iKx2uuhH2ftik7nfyJe/l6YfBU+8T2a5hjMYYOc6xp9YzT2NVc/Dli
         AEki7PnafkiNmnXRDX19rBNQouuFaAFQBHkZU9kUTmG/ijIBW6VS2Ozv4A2KpMHc8/uq
         UiYBNESUMRhRoori5jRSCzHMRtAUqb/rw6EdPEhQpixwzsONX9XkVh96p5CGCpCOzWB8
         QFkuNEb04S1s7ohUbmbCv18xGwwwh/0675v6259AceP57pLmwx5jlm3woU+uFEhoniQQ
         zaxXeBD6E0ou5Y4n3yNbzMJn1bbFmceVRLvlSiBTgeKqwrB/yzwpI1KunFDltEGoyxAn
         gfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671963; x=1788276763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xMGygkVCQST0F/zwz/Ue1uFqPHUtxjmJAwo4+G9sBQo=;
        b=p3Y62MyUa9f86bggdAyXDkKIjfRa1cMEojBnuAg866e/pySbY0PGdjtGgJX3jPp8Fi
         i8GW4qD5M/hMvtAw6ilj0UYE/OzMa4h00kiG1zd9dpCJZlsgUB2CYzw9NmDphGKKAWq3
         Jgs+6PdDiAATzC4tlT4gKPuR9np5UkjLH9BZfVdLjx0poc/4cBRM6Tep6DRQ/Yt1wE0U
         1mhElxZHzWUM6YcndAPDtBqrEvm2NsugFVeUm8lLsiFFiDEndgh/fnN/0fIf/54i+gdc
         HC6eMUNKFKfBNg9jn4qsjl42x91PXu/g1Z8hwsP53nJFL8hBXV2Dh0RVE26izpsUKWii
         GAgg==
X-Forwarded-Encrypted: i=1; AHgh+Rpd7IUSwRW2kUJIOkcS8vSn4HOM47aZN59N9YoFrPLlwy65nF+eq+6dwB0FCh6cdE1tAF9th6/ZNw==@kvack.org
X-Gm-Message-State: AFuF++lZFNKX/htjIemfXMTr19dAb+hy6TChQzZgFJ3+xvEu2r3/OCjJ
	pNNN0Ul4oSuOA2L9UGjXs8DlVlbpWiG57Ppe/9/vjsLMTyqyB/3gJZKU
X-Gm-Gg: AR+sD131xwWm1LYslBRM77rYfHBLRwOhJ0/5Sgdd4vJZ2C8+rPZ9SCvFXIHC3wmvb+J
	yh/8fgC1MBtwVFDetGevkVeQhjq5NsGRjdfeEdt40FQrZIjCB8bTuVn1CIf9zb28ECmwyrcRY8n
	QMq2evl69OVu1Gcf4OGiSZOg6Va/iEdzAHrjShe19hrvXsJYGrUPvCdu/9LPfV8LmfaTsrzPi2q
	JpUUQmHCmXmoa7aND6lPoJ4qU/pnMOUeWDbC5E7yM5niiCXetrXSk6FrSKqvx3Nem3iuVQjb1My
	WaWzqD2wDoKfVzJ8ZJbhAGHUwPAL5j9kuF3U9V1CAkWuUMD02wWKdmzCu54A9cX9A3VSOYE2Lvz
	/aQXqzXqgQu7QdTPrvKkZwbrMeIQO0veVJatZJQE8qoUNTzMD24XDWzDua7yAYV32fxquTJYNiU
	mtC8QCluBGQ0td1H6IxO/YnIP9tQ8hoKsODdq+BlXKUOMtzblzZhH9ItkRAbVjcT13fpFb+HE10
	aRJkfFCBcPM0QPZ
X-Received: by 2002:a05:6820:150d:b0:6b0:e6d1:d5cf with SMTP id 006d021491bc7-6b19044726fmr6124417eaf.19.1787671962240;
        Tue, 25 Aug 2026 08:32:42 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fc8623esm7136078a34.22.2026.08.25.08.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:40 -0700 (PDT)
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
Subject: [PATCH v4 01/11] mm, swap: add virtual swap device infrastructure
Date: Tue, 25 Aug 2026 08:32:27 -0700
Message-ID: <20260825153238.2695446-2-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B110D8000B
X-Stat-Signature: yy56nw47nz3aq4677zh9qw1t9i8bfufx
X-HE-Tag: 1787671963-996034
X-HE-Meta: U2FsdGVkX18xdsDlGf9xvvIXltWbaICS0+1bM/1LtSEtbX9v6EkBT3qBCuCfltprGt4n9N4F7+4U7+ZNvXOk/0R3s7ArMrGtRFbBU7EYWTOxADGgqYcJZqtinVNoAJhrsQrnz9MyG8MVQSmOfGeGscypbaDkBlqZsQRoNAiNnCeR5dcGeokpop1gcBg8S7iYBmhZYzQd6tIEcZWD/CwZiruF5SgIgc/XX0J28mq8Rs1jFbex744NzmB+fVwbvn+psB5937da8JhyUFOMjQvbTz+i25MS/PPBsdkiNXEhZ2CKRbKWoEKoJ74cpMAd+8XoiXFoIY0mB9vgDM4TzYotAhhpdpkuyKlkluChv4XlVWwym+mo5EhTmciJUHJNtnM9yjQnUdpQlQjss4hFgBLAgQlhs37j7DcHsW3d1TelaZgC5Y9qYgorknz5ISbyCdAGN+eqqFroOck6YdbhXsAeBzzCWoJBdyDEAJMqhebwWP6hmhr0CIkR3JBxqvYcMIxwHq+/VruQMWd4IgqLCni3+nHWOhQYm4eGPxcivFUoik6+JXHOQjtubPJBDxQ37SQ5lfGbPyxwYw3uidPJKWpdTKjcSus4Ki/OYMk70djcjJ0wtyBgVRCn99u6ty0lC0CQR+XvD5wLRtDdWpDS5waY9GXvyy8r8V4OQ0/wcwS4as28ugHCSTQ0eSy2XO//VtqMNDn5YpXYALMwwmCrvNYrExQul6bd2xH7ftpg7X0zBErkTDFZr/VvYhEwMhkpV4s8bfbuc3o691jiMyf/kE1pdX/FgV0zdy441Jb8j+NqFvBnWpGaRD2Cy68i0nqGz4F9Qo846CsrGA/P3pEG9KmAPU4PaUIoyUZZ3+TruZmpWxSfft5FMot6WllwvQ135/VnLczc0hnSJIFU2Er/plEvq4BoLmP1Nplq+Iu1G68puqYmd4OVDLm3Pp7Lme7Z5t+S91bo5GfVMkQ5n0cUNIB
 x4TEOOL0
 1sGVAUebSxQ4jKF+DhDhKp06CVJtOOGH3wu2jmvPmgcae6l35J33VA7smjBGM2UGHtPO/IOB/todX4lRZQLViiF914uQ3rQ/lGf6cYSieEn5ky18g9JTxcyGvgSbKoQyEWnjRxFCXt3y97w6M9t9HeYEIfoI03rR20pqiSC9Rw3l5aRb/NnlucNToQjt9zeJmaezYPLD/KBiK/psZiMEHprlSdJ38pkhhsP3FnD53pKeoCjLxvQy3mxxXkEPw0kKtmZ20SYRxFq2Tl6wRlEtFtxDzZwrAEp9q6m/grFYv+PnsjkJYc+kC0GxS3mq5TSgYR+lULOZsEMC8WZbU3yfmntRvg3+16Kni98FOJ8lWL8hKSsqH7vYXg0Z9bovj4jHxSMAsRlg47n6FQJCgh+1PTkZMUP6MQbdix8ihlqCS4MM0wBsqTTmRK0no1b6EmsRPhS0BVB+MK5GtKI4fnGYFhOosJtJOC0JVEwnVNQ9K0he0Jv9tku0m+kmcTEtB1rDZqLryodseE+MZpY164JXB+lr9hfMgytqkz4gQZnlpsJicV7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create a virtual swap device (16 TB with 4 KB pages), along with the
dynamic cluster infrastructure that the rest of the vswap layer is built
on. swap_cluster_info_dynamic keeps per-cluster info in an xarray, so a
device can be sized without a static cluster_info[] array. For now,
vswap requires a 64-bit architecture.

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

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 .../admin-guide/kernel-parameters.txt         |   7 +
 MAINTAINERS                                   |   1 +
 include/linux/swap.h                          |   9 +
 mm/Kconfig                                    |  20 ++
 mm/page_io.c                                  |  14 +
 mm/swap.h                                     |  67 ++++-
 mm/swap_state.c                               |  37 ++-
 mm/swap_table.h                               |   4 +
 mm/swapfile.c                                 | 271 ++++++++++++++++--
 mm/vswap.h                                    |  34 +++
 mm/zswap.c                                    |   6 +
 11 files changed, 437 insertions(+), 33 deletions(-)
 create mode 100644 mm/vswap.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 1af62cd16c9d..6612b5e0a055 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8364,6 +8364,13 @@ Kernel parameters
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
index 29236523cefb..8a5827d27177 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17251,6 +17251,7 @@ F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
 F:	mm/swapfile.c
+F:	mm/vswap.h
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5658a1634b85..5339323486d5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,6 +207,7 @@ enum {
 	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
+	SWP_VSWAP	= (1 << 14),	/* virtual swap device */
 					/* add others here before... */
 };
 
@@ -276,8 +277,14 @@ struct swap_info_struct {
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
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);
@@ -408,6 +415,8 @@ void swap_free_hibernation_slot(swp_entry_t entry);
 
 static inline void put_swap_device(struct swap_info_struct *si)
 {
+	if (swap_is_vswap(si))
+		return;
 	percpu_ref_put(&si->users);
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..08fdc7502c1d 100644
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
index 88962571cb93..3d0e78c17090 100644
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
 	__swap_writepage(ctx, folio);
 	return 0;
 out_unlock:
@@ -480,6 +489,11 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
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
index 90a551a88df6..f18385dc9c6e 100644
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
diff --git a/mm/swap_state.c b/mm/swap_state.c
index b76eb3d876fd..a800abebba38 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -96,8 +96,10 @@ struct folio *swap_cache_get_folio(swp_entry_t entry)
 	struct folio *folio;
 
 	for (;;) {
+		rcu_read_lock();
 		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 					swp_cluster_offset(entry));
+		rcu_read_unlock();
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
@@ -119,8 +121,10 @@ bool swap_cache_has_folio(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
+	rcu_read_lock();
 	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 				swp_cluster_offset(entry));
+	rcu_read_unlock();
 	return swp_tb_is_folio(swp_tb);
 }
 
@@ -136,8 +140,10 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 {
 	unsigned long swp_tb;
 
+	rcu_read_lock();
 	swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 				swp_cluster_offset(entry));
+	rcu_read_unlock();
 	if (swp_tb_is_shadow(swp_tb))
 		return swp_tb_to_shadow(swp_tb);
 	return NULL;
@@ -406,14 +412,16 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
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
@@ -423,9 +431,12 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
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
 
@@ -446,10 +457,13 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
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
@@ -457,10 +471,11 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
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
@@ -517,9 +532,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 {
 	int order, err;
 	struct folio *ret;
-	struct swap_cluster_info *ci;
 
-	ci = __swap_entry_to_cluster(targ_entry);
 	order = highest_order(orders);
 
 	/* orders must be non-zero, and must not exceed cluster size. */
@@ -527,7 +540,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp,
 		return ERR_PTR(-EINVAL);
 
 	do {
-		ret = __swap_cache_alloc(ci, targ_entry, gfp, order,
+		ret = __swap_cache_alloc(targ_entry, gfp, order,
 					 vmf, mpol, ilx);
 		if (!IS_ERR(ret))
 			break;
diff --git a/mm/swap_table.h b/mm/swap_table.h
index e6613e62f8d0..868aae6c820f 100644
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
@@ -255,6 +257,8 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 	unsigned long swp_tb;
 
 	VM_WARN_ON_ONCE(off >= SWAPFILE_CLUSTER);
+	if (!ci)
+		return SWP_TB_NULL;
 
 	rcu_read_lock();
 	table = rcu_dereference(ci->table);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 53bf01d5f7f1..ae88b91c92a2 100644
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
 
@@ -401,6 +403,8 @@ static inline bool cluster_is_usable(struct swap_cluster_info *ci, int order)
 static inline unsigned int cluster_index(struct swap_info_struct *si,
 					 struct swap_cluster_info *ci)
 {
+	if (swap_is_vswap(si))
+		return container_of(ci, struct swap_cluster_info_dynamic, ci)->index;
 	return ci - si->cluster_info;
 }
 
@@ -586,10 +590,15 @@ static void move_cluster(struct swap_info_struct *si,
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
@@ -607,6 +616,18 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
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
@@ -843,6 +864,8 @@ static bool cluster_reclaim_range(struct swap_info_struct *si,
 	unsigned long offset = start, end = start + nr_pages;
 	unsigned long swp_tb;
 
+	VM_WARN_ON_ONCE(swap_is_vswap(si));
+
 	spin_unlock(&ci->lock);
 	do {
 		swp_tb = swap_table_get(ci, offset % SWAPFILE_CLUSTER);
@@ -1034,6 +1057,44 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
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
+	ci_dyn = kzalloc_obj(*ci_dyn, GFP_ATOMIC);
+	if (!ci_dyn)
+		return SWAP_ENTRY_INVALID;
+
+	spin_lock_init(&ci_dyn->ci.lock);
+	INIT_LIST_HEAD(&ci_dyn->ci.list);
+
+	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC)) {
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
+		     GFP_ATOMIC)) {
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
@@ -1056,7 +1117,9 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
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
@@ -1070,6 +1133,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
+next:
 		if (to_scan <= 0)
 			break;
 
@@ -1146,6 +1210,12 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
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
@@ -1282,8 +1352,10 @@ static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
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
@@ -1298,8 +1370,10 @@ static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
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
 
@@ -1346,6 +1420,10 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 
 static bool get_swap_device_info(struct swap_info_struct *si)
 {
+	/* The vswap device is always alive, so it needs no refcount. */
+	if (swap_is_vswap(si))
+		return true;
+
 	if (!percpu_ref_tryget_live(&si->users))
 		return false;
 	/*
@@ -1381,11 +1459,11 @@ static bool swap_alloc_fast(struct folio *folio)
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
 
@@ -1507,6 +1585,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 	if (!si)
 		return 0;
 
+	/* The source PTE pins the entry, so its cluster is alive. */
 	ci = __swap_offset_to_cluster(si, offset);
 	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
@@ -1904,7 +1983,7 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 	return NULL;
 put_out:
 	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	percpu_ref_put(&si->users);
+	put_swap_device(si);
 	return NULL;
 }
 
@@ -2036,6 +2115,7 @@ static bool folio_maybe_swapped(struct folio *folio)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	/* Folio is locked and in swap cache, so ci->count > 0: cluster is alive. */
 	ci = __swap_entry_to_cluster(entry);
 	ci_off = swp_cluster_offset(entry);
 	ci_end = ci_off + folio_nr_pages(folio);
@@ -2230,6 +2310,9 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* vswap has no bdev, so it is never a hibernation target. */
+		if (swap_is_vswap(sis))
+			continue;
 
 		if (device == sis->bdev->bd_dev) {
 			struct swap_extent *se = first_se(sis);
@@ -2356,6 +2439,9 @@ int find_first_swap(dev_t *device)
 
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
+		/* vswap has no bdev, so it is never a hibernation target. */
+		if (swap_is_vswap(sis))
+			continue;
 		*device = sis->bdev->bd_dev;
 		spin_unlock(&swap_lock);
 		return type;
@@ -2572,8 +2658,10 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 						&vmf);
 		}
 		if (!folio) {
+			rcu_read_lock();
 			swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
 						swp_cluster_offset(entry));
+			rcu_read_unlock();
 			if (swp_tb_get_count(swp_tb) <= 0)
 				continue;
 			return -ENOMEM;
@@ -2719,8 +2807,10 @@ static unsigned int find_next_to_unuse(struct swap_info_struct *si,
 	 * allocations from this area (while holding swap_lock).
 	 */
 	for (i = prev + 1; i < si->max; i++) {
+		rcu_read_lock();
 		swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
 					i % SWAPFILE_CLUSTER);
+		rcu_read_unlock();
 		if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
 			break;
 		if ((i % LATENCY_LIMIT) == 0)
@@ -2959,6 +3049,11 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	struct inode *inode = mapping->host;
 	int ret;
 
+	if (swap_is_vswap(sis)) {
+		*span = 0;
+		return 0;
+	}
+
 	ret = sio_pool_init();
 	if (ret)
 		return ret;
@@ -2984,15 +3079,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 
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
@@ -3036,12 +3140,31 @@ static void wait_for_allocation(struct swap_info_struct *si)
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
@@ -3188,7 +3311,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(p, cluster_info, maxpages);
 
 	inode = mapping->host;
 
@@ -3535,10 +3658,39 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
@@ -3582,6 +3734,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			goto err;
 	}
 
+setup_cluster_info:
 	INIT_LIST_HEAD(&si->free_clusters);
 	INIT_LIST_HEAD(&si->full_clusters);
 	INIT_LIST_HEAD(&si->discard_clusters);
@@ -3603,10 +3756,16 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
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
 
@@ -3825,7 +3984,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	free_swap_cluster_info(si->cluster_info, si->max);
+	free_swap_cluster_info(si, si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
@@ -3956,3 +4115,79 @@ static int __init swapfile_init(void)
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
+	maxpages = min(swapfile_maximum_size,
+		       ALIGN_DOWN((unsigned long)UINT_MAX, SWAPFILE_CLUSTER));
+	/*
+	 * SWP_WRITEOK enables slot allocation. SWP_SOLIDSTATE selects
+	 * per-CPU cluster allocation; vswap has no si->global_cluster.
+	 */
+	si->flags |= SWP_VSWAP | SWP_SOLIDSTATE | SWP_WRITEOK;
+	si->ops = &vswap_ops;
+	si->bdev = NULL;
+	si->max = maxpages;
+	si->pages = maxpages - 1;
+	si->prio = SHRT_MAX;
+	si->list.prio = -si->prio;
+	si->avail_list.prio = -si->prio;
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
index 37f34e406c8e..11643c52ea21 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1000,6 +1000,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
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


