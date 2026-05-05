Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48641FF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7412B6B00A2; Tue,  5 May 2026 11:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3166B00A3; Tue,  5 May 2026 11:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C1F6B00A4; Tue,  5 May 2026 11:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 430336B00A2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:39:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3B644054F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:14 +0000 (UTC)
X-FDA: 84733775028.27.D001A79
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2BA7B80003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:39:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XWatN9P0;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlimKByHfZpD1p9OKEabB2ERI5Qs+G3kPUHC9/pb+w8=;
	b=r3KWypVU+fG6MgIXAI0OUV7wWxQlP2di42kmcJ0HnibfsC1u+WH9D1DUYpiIdEhdPlp0ja
	h7RLXPPveGFdsPspqp7AZ3+ycYtnGbhHQMG9Maf6AgTEeOsYDI4QRmxvA+rWltnW5UWN3y
	SjxcVL1XDHiOWFze9GGqHTTdyy534rQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XWatN9P0;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995553; a=rsa-sha256;
	cv=none;
	b=0Q4dthaAi6rvyPRYfmmr9mxhdToepc/GhDRjPDA4w+N+ZTDuoqx4oYxo58QEBQY7QF3DCR
	cyGTmgIFOVpHVEYpmsf4Zq8nncQLmOl72KISGxjwSjQE/iW4FRzVWO94aocmCKZSjsnj5A
	MEWu2APaPBx7yQJNaJ5/jZ00kvYLGT4=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7dcd689829eso4876024a34.3
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777995552; x=1778600352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NlimKByHfZpD1p9OKEabB2ERI5Qs+G3kPUHC9/pb+w8=;
        b=XWatN9P04PxgtWg/wmt8z80B0MfcIIO/asgtqD8MpwV0kAsMOaFGhqSETXYZwHmA8L
         PT4tOf80KsAAD6u8WObeZKgMUxukbR7648osgC1mLOXlDlb20j+aUN7xHhAgMiG/IL0W
         mmD02que8Q0toYfcG3cIKXB/5sXYCPQ+cxiS2CqjfvuY2XRMG7g5KZXMh57xEnA+8Q6Q
         4JxkwufJEbS4Yg0Nwuo7okn/g+DfJEk3P4pB3IMPPAPLgvr1P3uH+gCPbtsKbePFNda5
         nEla2n4Qi8zR09TkehRyDv7Xw1G9QGYKIkdFHsK0oraYBgMZKqav4HJHdA9qPsviaAfq
         OTQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995552; x=1778600352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NlimKByHfZpD1p9OKEabB2ERI5Qs+G3kPUHC9/pb+w8=;
        b=aGsxeyPM2/2/atYpOOL8ITc9fWmVZj4MGMvkz+kuekLvyrtMt4/m6uOCOn08lJN38z
         dU8kIqa/WvEydO9I5XoZGCeGCn3e+gbFrA4Duj3C2i+W98ldS2KVUIvJ8gMBbIZ5tLdO
         GJHrDcMNHAm6Ivg4J0nlrAq/3Og39QPNV/ghPQaUcHUwR3Vay7G4/Q0SsxqXkeEbmhs0
         Jb9oijldDpasXTKiVZILiFRMKbsoqGIbkltp5UzrILn83ifUq8U+PD5Rih0OA4YbzVqk
         P7MQnswHOFE9/eI53tghkUh+3XGhGZZznsBMlSlhMV1EThO5U7uEXFuKD84mU/NdD4Sm
         Sc0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+GAILVisvoNPIL1ajsRKEpWp4nLVgX9kC5AXsTR/F5+3KrpTyWGD+nl2gTXCoPuSDwGPyLWSpfIQ==@kvack.org
X-Gm-Message-State: AOJu0YyKgpAN4Tq2OMGur2rTCKZnYEDI0XzKeLy9fyy7l5OcS/4bgweO
	eZdnaBWkobpRiNEF7C8OwoqAJLqCz3Sc7BD39eKw96kf6daoUdPrBfOT
X-Gm-Gg: AeBDiesCw5fUn5EeyxYb5V5t7VUFb6FoyYdtDjOwA9iLGXVB61Y2YivaB02nYExt588
	wXVoaVGjFz8mSN6HqTF5FsZW3BU9jS4VFawzDVNcxU2TybQl7qdG4gNgnzZ03x+CFcqcBZXG7KT
	qb94bmLpu4+xOXAtcJ8xY4he4ghABZoKyd7ciFqR+uNicT2bKTli/7nVnz2qhDik97mBT70O9fe
	7f0YL7LZFT2PFLOdhfDCpiI8GRBrsD8W7QQytm+Lro35ox7BpikCx/REfikeOUSaj9ltcLN8DG1
	ZVq9AKqv2GjqIB3xHfBophHu6zsyot18WBkHK7TWSCqRXqffdS26RLn1XUPYGCl7pJ03+0z1ahT
	oGbN55R4PICcrBYFIeAdEOmQ71HLCmEAOHEhiejl/Y6ILAPIUzhDX/2t+Qhd6g2VYVp39n94EFr
	GTMDQHn4nBTb1KXwfmdFFFKs0wqAlNRcSImvUgbeV0r5VUMIeEzs41TaUK
X-Received: by 2002:a05:6830:8d1:b0:7dc:a256:5e2e with SMTP id 46e09a7af769-7dee121b678mr8066698a34.1.1777995552105;
        Tue, 05 May 2026 08:39:12 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deca7a9036sm9855829a34.4.2026.05.05.08.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:39:11 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [PATCH v6 07/22] mm: create scaffolds for the new virtual swap implementation
Date: Tue,  5 May 2026 08:38:36 -0700
Message-ID: <20260505153854.1612033-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260505153854.1612033-1-nphamcs@gmail.com>
References: <20260505153854.1612033-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BA7B80003
X-Stat-Signature: oe5ijetjtmzqobfry7fwhu1rsmqz81cc
X-HE-Tag: 1777995552-622714
X-HE-Meta: U2FsdGVkX18mCgpZfwo00jTzAtFZyXWXF5oSl/5vI0vBsVxeTVtNHiO8JaSpmQRM4AqaVAoJ+t/mgJgyHqmw8401DAvEjEGAbrfJRucAKJY6kvf/1ScCFf8AAWH/N05kcK605L/4jA2U6zGmZ3cxHPmX2EnUhN6reRRSSQJiChpSdJleiVOlWpl3aRrjW0Tjdy56x0G3hUsQ0coOTQawvYHZmp+Q+bzgFV892S64xxwp1sO1vY+wRLcrJdk7KsIiTHi321JPcgaAz5AkymNhP6QS3a2yQyUzqNwgpRn+EGiRhdzc00h3fQikSWNdG+WLlWxm7enyXVtrcvTJBToCi5+8qHie+U4dJClxB15T7nZMadCavx5ZMd+3ozNvL3uFGWOnXnVG/nRP9Pt4dIA6VRA3ODmL7oUGGguhSqXiemo4VHw8e/YoaQo+3zk0kfLTPKIdHfF3/Xcqtc17akPifBf2xm02NM+vvhLhuLPFudopaMPj3b5LV+KJVBKkyCruDafbLnT/2LkMozPDjXDvL5NuTcQ/clM1KLduo2SWnXSyw+Cvv/6gzusyWDfTSZOPElX33CyqpTxkeDn6pwiBPYSjh9h5tI4/jVxZTZgbGvXazkNSSnwxZUdlY//7Ahf8FrsikbAyjHJtQerUfd0uaXrcJnj18jMupcuxWQrcp+CNC0etRb06EzHj7GJBB5rbrcU43w4Ln6PSq04zSV+aN9L/nOSGB2LWm1V6KRyG00z/B7RypWIPcxCM5/zRnOzx5sITJEei53YuhYGgz9VR25gro1Q6gyqKjC21rxqTjnhaKSe2RhCC+MZ/xYWnGNKN94pK9DV0aQhXNmvkNKQsg4Hzk5xbfDddDHXfKeVEDxp5Rcv2RsdXJs7Aotzu4swGBly5LgL1XPInvqbkkm6WGKbfZUlLW7pZNY3vcNvHOPK3yhW9GePOCCU5z6n7gU8vwztfkVv/3wmlJQ0dP47
 9WqVIRom
 PdCda8M5rrIleIOHFihDqYYdgM9ylNE4GbwnLMBZ+/pF2yN0DZq7/JqRlvzFZOPqC+bR0XIDEVyy7Fn53tEcB7EoacU+8uK6DpTQFrlznyCbuATj3rUYsQMPIPYNH+DhK53aivGtWE8RaGXNFQ0ouFM/58jg7Uk3OwGTn4Bp2O9QhegelCoeVwstEVNQb2M+JEuXp61dzYzfC+Rwly1oOXpuvF+gn21LMb/59f8/BTCOT6c3PNTzX8+3Z6eB4oZMdO336bfmGFSnmQl2Ac+bhbAaGc5CP3EPrad25mcMsiDQaEMEOLdYBoPKfyGn1OfIc4YrCIFGQmEhgr3w6/n3KbOB7qukk0/IC1ZvrzxixXZimfWWroZiI9m2u7v98SKkB+uUH44fanlC4a6JQ1DFclTLpirZnrXinJ5H+yHARq6CqEMqwT/D261bVbjBWu9WRxQv3b3rl3zmN/EKdeX6sreLTAy7Gzrn9vCSESDSibRpFbBAH79cQmeaGLjvY5FnBPgyx4q34mxKqCxaZGx0dlvMAonS7WUdf5i8WQ9SUTZCDIM484tlCkIb/LWn+J2Q/nE19AXv30kyeeUdxycHjqYZnsKqWJF0uczRqyQnkaFepB+Ah7oy2NLIKKEhAuiJpsHrNZehCYj8Z6/2/DhPF6zBVX+o68vnp4KZ3aP13rDeUzhQZeGObRPf6Mzl63hMpdW9N3We35DAotjO6fWfU73ZLSFmaz1OvZdFfe2mslqdH5zeSCr/WW2uCxWqYyTRYwY7Z037lKVnlhaSYQA/7MgTg6w==
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
 include/linux/swap.h |  3 +++
 mm/Makefile          |  2 +-
 mm/swap_state.c      |  6 ++++++
 mm/vswap.c           | 35 +++++++++++++++++++++++++++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)
 create mode 100644 mm/vswap.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d3780bb33037..042dbc06c3d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16728,6 +16728,7 @@ R:	Kemeng Shi <shikemeng@huaweicloud.com>
 R:	Nhat Pham <nphamcs@gmail.com>
 R:	Baoquan He <bhe@redhat.com>
 R:	Barry Song <baohua@kernel.org>
+R:	Johannes Weiner <hannes@cmpxchg.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/swap.h
@@ -16739,6 +16740,7 @@ F:	mm/swap.h
 F:	mm/swap_table.h
 F:	mm/swap_state.c
 F:	mm/swapfile.c
+F:	mm/vswap.c
 
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 918b47da55f4..df0771903a95 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -423,6 +423,9 @@ extern void __meminit kswapd_stop(int nid);
 
 #ifdef CONFIG_SWAP
 
+/* Virtual swap space API (mm/vswap.c) */
+int vswap_init(void);
+
 /* Lifecycle swap API (mm/swapfile.c) */
 int folio_alloc_swap(struct folio *folio);
 bool folio_free_swap(struct folio *folio);
diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5b..67fa4586e7e1 100644
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
index 6714d59fb108..fca17e7e7ae6 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -883,6 +883,12 @@ static int __init swap_init(void)
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
index 000000000000..e68234f053fc
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
2.52.0


