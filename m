Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34BBEF06F7
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BF46B009B; Sun,  8 Feb 2026 16:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4256B009D; Sun,  8 Feb 2026 16:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7256B009E; Sun,  8 Feb 2026 16:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33A486B009B
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00D0C1B316E
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:00 +0000 (UTC)
X-FDA: 84422655198.06.84A7946
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 44B4280005
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:58:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R0nDCRXC;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAYGpIpTp87S2/ee6Fydv9Vv1Hcay3Vy8wBGMvAXEzA=;
	b=WEvISKebaIpmLptzna5R/Mc+f0UlbC6nhB7UaMg22LWXn4YDOeeL/bjrsOPp6G8qYTBWnK
	gIPiKfeHdutV3JhuIFqCJjL6Cn7Vi7qHtxn05HuZ2Qt/JABbLX2eR5iuQl4BEptVcgQ0KQ
	X1MswDbRkhGwnTcZUff3DohbWZDiqds=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R0nDCRXC;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587938; a=rsa-sha256;
	cv=none;
	b=n6IOi924H1fN6KycjkHhIfuk+5PRe/Spr3JuVo3iJp4LOXxWwKhZ04y/yGoPZouqkjwaNe
	NYkqhiUQAT/kb6ohKmYMR2yOjNjNP4PM/Xo1wZy2P+TWKJH/bvtqfqK4SxDrivIymQG2WT
	g1Mom/1V6GwLJ0Fj/t5Nta4GtWDUB9w=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-45c8b850f96so1670405b6e.0
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587937; x=1771192737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAYGpIpTp87S2/ee6Fydv9Vv1Hcay3Vy8wBGMvAXEzA=;
        b=R0nDCRXCZK+PweHgA3aO3L0qVGW9gB2vOCg7GiLxHCO17PSMUp1GedavFfuF388GrW
         O7lJfFOOmf9TFFJo+vWLG6deWJG7c0SVSIGLRTm3hBAxuSOGy6YioJxIcriomuBLSjA9
         2Csqq5Xn5PwmeaBPiT/E/d2+c286IZ2chgWt2aguxihqQm9J5qGBS3kd53NfIbNlw8T/
         5EDnyJyNdcKzFMe+Qf7IIhysdSNlIFd+eMtz8jyyJqJnjfHa6oA1kaNInvJLIOi5SsCA
         WF5eZUXu32Cpqke+NTMQVKSftq5yASRap5wAMj2YxGFv9jRPGXXpba8H3GZsIGaqZwz/
         UsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587937; x=1771192737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AAYGpIpTp87S2/ee6Fydv9Vv1Hcay3Vy8wBGMvAXEzA=;
        b=Vr6XEQUpqFblM4oPPTfhFAOWUCI/qpQetUxkLBqd28dLV7HvLtfqHp0jLO89a0kqny
         KLuZypjoC3/XjxdRU2rRFhnG0qU69mSh9d+w3iQbFJwlcf1Lhy1foh8EcMS8NHhmdvOD
         0oPFJuf1uUVmkAGyeLHNO1hm18HfF4gjNyPrA+oYIq3Y+2/366sAjBhpqbo4A7tHAvI1
         p/uHO7XBUwCOqP06cHWpE/yxZjn5Y2mpdWVGN/w129zft56/fosrZn6QyX8ZrTsBzoby
         tslLS1ofHpUuhrlyrrxjsN4fDkOXJxr9tjuR416RjC4OQ2P+D/SMIJcpD2yQ9Z626bX5
         1ncg==
X-Gm-Message-State: AOJu0YycScbYXPBk/scX9ppoIo6QAnvkMgdHw5hLxq1b7N+HFFNwj7F1
	Qug0LB5WIeb5eA2Y/uE4wjLhHWsduF5ex/mqnK7EJ1bhKsYYF2Mwv1t5Uy8DGBcOYXXwyA==
X-Gm-Gg: AZuq6aKJ876SHT4UWX0fuAxExk9qy0fqkj1At8WJ3OwOOAqUjvPFStPgjcZY/07mdr5
	GglorSeacxyB6/9WjgQf6lSHC34yeKRhWudjK4Y2u8nBhXPh3/oKpj7oHo9pCFeaIIfN6U8X1Zw
	/vLMsyGDpSrBKQhokJm6eKeuG0wpwHE+P9lXuOT3Kvbi0JqcoRzAzO3mpqqvtyNql5Ff7UvwOUV
	3NKZnp/jtN99dsq7K4eB6IQ/scbNDH9lQ0rrfUBdJCruYNCVBpd+o2OJBouDrwrTo70jxys2m2i
	HfJ5dyleIiINnKKhAdhK3RteAwrTYb7dB0cH24/0ilTv2ZjKhF7mDrhVAF4/0lGhTAvIj5c4Hn8
	e76/mX/8XI0BHLvUcKf//paZTU21Cs5+NtUnHMlQewADI89bRjAYUFcbBb+a/oURG3GNDNe88m+
	Cjemqy0hgCnQR5Zbke6Oe+FVpfM365jTQF
X-Received: by 2002:a05:6808:6a83:b0:45e:84ec:f163 with SMTP id 5614622812f47-462fcbf61f5mr5120530b6e.64.1770587937297;
        Sun, 08 Feb 2026 13:58:57 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d464785674sm6238015a34.19.2026.02.08.13.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:58:56 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 07/20] mm: create scaffolds for the new virtual swap implementation
Date: Sun,  8 Feb 2026 13:58:20 -0800
Message-ID: <20260208215839.87595-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 89i38w8emur1bw9kkysoj66bu1m1dcgw
X-Rspamd-Queue-Id: 44B4280005
X-Rspam-User: 
X-HE-Tag: 1770587938-48540
X-HE-Meta: U2FsdGVkX1/BjTWESpxUpheAU8dWeCHdcKz8F2hmXgkrVhkXIWTLbrHRQlMEanvYcXPbPDMqFNyJCdEKn/6Qb8C7vQI2f6xo7hWFfgzymEiSBZczkMIwAjJbkLmJNSz0f8EkOGrB6RbZLgX+9A+Ojj+hYLKQERfPD0x6rG9mD5OskZthyS4EPgUg11i//rHURKG/cBG0LxnInsdzQWF/5twApOST3HqZZQQplkGoQtFmzrysIGvYYhoK9wlTSrAqz0gK2zCvk6apvSHEM1pgHd6+qsW0GKBnREmfm0oKAJhh5NW8NbHXhST6e8zMQaXVc3Rvj40w1JwiTp9kay/T1kJ0YBwQ7BeyopGK10WV8TvJfjv4dkV7Tq5Nm9IW61CLD4uuLR2oaYv79exYbqykepqrtfy/NHKYVFEBMtPfoVXdP1/cDLgNcSyJa8FuMsaJDTKD09UE4A/QHPsjCxcKcKJKCXLihq2oT4RlXYzS1XvGj+zbB11QC10hMshnhlCRoQyznSrLXRIwUlI5mUZRqERWP1SYZuCrDtrXgJ2cLbf74xPwAG1FP8lrFOc7pr8tkRSHSSdto2pHP0bJwpyPV0z6QsvKXhd9p2uPh7ijrSu1FgsqNhfkKZfTVLR8p5bjKcusZC182O+jAgaI6Jus/ayECt5brwwZ/9SqC/o84mjbKdLsmJLweCwThf+h+AYk6WNCXk0Mktvcf8ZsZluQ0LzwH8EebpOTX4PY8fdsUKeTyftc0YN7XpQY2YbrAEDChucSnXjhnkvsM59e2lyleKbPrb3qWBqZVabBBf37GvfQsJs4P1PHlLjpe4JRWVIsCuNKfbXGc0yjwoHhfN67zPCo4PB0WjIQOMnm9iHaEXQSB5IqlyKzcj6l77qDqI7GbJFq6vJzpWou6ZgufVkhxPY3LmNpapTt8y64jVxxuvzj+uwBhEOiOtIbqtMeI21P1r/z1EWmZIU2zrjcceJ
 cKenKrdH
 IJC1Y203TX8drk5CYToLSutAPU+RJo440k4slP9hv8h/qSqXsb2SxiB51U5yI94rB2ifh8hWA5LsmQaPC1DSUvnGOSN8Z41v7uN3IWFGKkzjppk69TglixvUKwxjxuQ+Kn7652zi9OHwfKhuHtsaZ25i1LC5Dby6IJrpPOKUOWhDxq7yBm7Ihy47Mrz93WNBMfT2FTbLg7cQG2oFv5KZHbD6IawvF8ee4JFfN/UDvO8bYnQBQraZBrBCkVAXtomtE2cptcuI0dOgn6kVgKE1Zsa9Y3eDkDcYVLVYREg1wO5CaKXn2K+MjJzVh/7pPFBqfLFHPpVT9RYUMOmQpUMiD+Iwdd/rWN6yV44E2KRT+gcmh8B4zcXz52P9+WzSzp352Quy5MWq61Oin+HkJgyYCP4CMEVUShggbMxWa2Lzb1DIBsAGuvVR+lJhilYUvvCvNwKLpfE/qQ3yljNS4pJfz6T1h/lNIEN7bbsTyo0mVph4Z66jr+/5t9hMP4iTA6ZNpb2sAvJwhhafZKc2QRMLu3mBE8nOl/b3vd3wVlVDm9fZwI5euPoIavBy+oLR0h/KhCI74+PBaJWYtfqTug904wHi3sIp76Cs4I73VDy5PMQwPZXEl74gbopyRMzLlzWSTrFcTrO4bmVxwjdHoZc8DkyB1a1/bD+SDKVMkB4O0zL1ETv7ADktClBFUNaPJLDU/OUCBOXNUICmq3w2VZGRWW1+Xu+RAxuH1FXM2Pmtrwk6GN57+M3KleEc8grOwtdtf6rfnD4I/I8ZiNzy0vL5EihnTKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In prepration for the implementation of swap virtualization, add new
scaffolds for the new code: a new mm/vswap.c source file, which
currently only holds the logic to set up the (for now, empty) vswap
debugfs directory. Hook this up in the swap setup step in
mm/swap_state.c, and set up vswap compilation in the Makefile.

Other than the debugfs directory, no behavioral change intended.

Finally, make Johannes a swap reviewer, given that he has contributed
majorly to the developments of virtual swap.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 MAINTAINERS          |  2 ++
 include/linux/swap.h |  2 ++
 mm/Makefile          |  2 +-
 mm/swap_state.c      |  6 ++++++
 mm/vswap.c           | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 1 deletion(-)
 create mode 100644 mm/vswap.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e087673237636..b21038b160a07 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16728,6 +16728,7 @@ R:	Kemeng Shi <shikemeng@huaweicloud.com>
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Johannes Weiner <hannes@cmpxchg.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/swap-table.rst
@@ -16740,6 +16741,7 @@ F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
 F:	mm/swapfile.c
+F:	mm/vswap.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 918b47da55f44..1ff463fb3a966 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -669,6 +669,8 @@ static inline bool mem_cgroup_swap_full(struct folio *folio)
 }
 #endif
 
+int vswap_init(void);
+
 /**
  * swp_entry_to_swp_slot - look up the physical swap slot corresponding to a
  *                         virtual swap slot.
diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5be..67fa4586e7e18 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -75,7 +75,7 @@ ifdef CONFIG_MMU
 	obj-$(CONFIG_ADVISE_SYSCALLS)	+= madvise.o
 endif
 
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
+obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o vswap.o
 obj-$(CONFIG_ZSWAP)	+= zswap.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o hugetlb_sysfs.o hugetlb_sysctl.o
diff --git a/mm/swap_state.c b/mm/swap_state.c
index e2e9f55bea3bb..29ec666be4204 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -882,6 +882,12 @@ static int __init swap_init(void)
 	int err;
 	struct kobject *swap_kobj;
 
+	err = vswap_init();
+	if (err) {
+		pr_err("failed to initialize virtual swap space\n");
+		return err;
+	}
+
 	swap_kobj = kobject_create_and_add("swap", mm_kobj);
 	if (!swap_kobj) {
 		pr_err("failed to create swap kobject\n");
diff --git a/mm/vswap.c b/mm/vswap.c
new file mode 100644
index 0000000000000..e68234f053fc9
--- /dev/null
+++ b/mm/vswap.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Virtual swap space
+ *
+ * Copyright (C) 2024 Meta Platforms, Inc., Nhat Pham
+ */
+#include <linux/swap.h>
+
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static struct dentry *vswap_debugfs_root;
+
+static int vswap_debug_fs_init(void)
+{
+	if (!debugfs_initialized())
+		return -ENODEV;
+
+	vswap_debugfs_root = debugfs_create_dir("vswap", NULL);
+	return 0;
+}
+#else
+static int vswap_debug_fs_init(void)
+{
+	return 0;
+}
+#endif
+
+int vswap_init(void)
+{
+	if (vswap_debug_fs_init())
+		pr_warn("Failed to initialize vswap debugfs\n");
+
+	return 0;
+}
-- 
2.47.3


