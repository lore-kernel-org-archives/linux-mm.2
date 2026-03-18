Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D961088E43
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5C56B0356; Wed, 18 Mar 2026 18:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFD36B0358; Wed, 18 Mar 2026 18:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE176B0359; Wed, 18 Mar 2026 18:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6686B0356
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09C081C2E6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:10 +0000 (UTC)
X-FDA: 84560628180.07.B16D6B0
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 31D094000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZrcAtfmT;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uOXWFDfbhJT9tG5Yl+ef83GJnrWQ5V7qgRvvdgSeJQ=;
	b=iB1jzNDGdWt/13r2lGAGDqRNaRAtCStfO3Sq+GXOQt1Of1u9eS5VZYy8Lqk34cG2rFIy7w
	lU0Jic/WPkc6R3otBMLeQBPhvV2LrhmCumXrlwthhQuk09TS/e3QvAHyirgGsw8f0d+ivc
	XCnQHLse7B3M6UaF8PyRFO8bd1i6t1c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZrcAtfmT;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873008; a=rsa-sha256;
	cv=none;
	b=PuWj6jUujMrTmUoWvK1iBYfbHRbFWlB0TPcACUKTgzLrmEmyTlRojlU1jJvoQnn5PKqz05
	FNnabvQQJcSQUPqlD+hvrei/FmeKgQQ/Xnlh/V/f99hAd/urHeuXVn3zXSHBVXZauBUBbt
	G5hYXGTbp9cozAjTQPijg9RDKwmcXkc=
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40ea36b56b7so364100fac.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873007; x=1774477807; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0uOXWFDfbhJT9tG5Yl+ef83GJnrWQ5V7qgRvvdgSeJQ=;
        b=ZrcAtfmTRK9pXQhJSt3s9arPmosXDWK+qkvkaD5RZpX/WU9Fet7+ds2GcSdF7t9b+O
         WL3gAmCJqtLqwmAKYXGTYP+KXVnxBrvfZFokQcuXfsKKaZpYd1bfO+USFTM0VKuSTwB/
         4N/0Aa1Rb5Kig/tK+Ds+ytiwdYaZPZ2vJlxoLgfkh1Iv0ZyY5iuyxuf2ixUJ3uQIQyBR
         YwMcYxSw6EHtzkqMGXUEFh8xBAHpa+ef7TtxwAjzIa8S0ffqqTqRW74So3mbbB2Xx6NU
         wNz5fZd+paeIdLq/2L7rbZmWttXWnBxzwwamZlM259xR21McNbZOTXW3/6mbjjcfpoIJ
         w3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873007; x=1774477807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0uOXWFDfbhJT9tG5Yl+ef83GJnrWQ5V7qgRvvdgSeJQ=;
        b=q29dVL1tuEet45Wuif6ptUoxg/1rRVipqe59EOFVScJ1eXVUdjYCu5J6E9jzttRJUe
         XJFEtaN5tocCWa95xyTnWmA0afAJ036PteKe/1YGwO+FmmwyhKfskGKa6DhA7atb52cp
         Z86k0dWETQdnlYvwPxM4g7f00ohVA7zcAeuZ+4nWw5Rx8PosJMAyoRR6X0xU9jRIkz7L
         DpDTG/JBzqwKTMKfBHnCxKGP/l41NZU0M+4qfBb3QjgS9wy7N0Qmwm2/xH+Nm7XMHbdb
         guW5IUycXeUFS/dgDL0+NfnQSnqgGdbgH6G9grvSWtAMCBdPtfp6IWcA0gQttxre3qff
         GgKQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8upvUFqimn9z0rsfpU0SSrmeIZ/qkjHg82+aah8GFSGaG0zcUDCmEmIXqaP0wsrzalQ/o1TZUJg==@kvack.org
X-Gm-Message-State: AOJu0YyyoiiP+MFSoxtqyfVFkSfxPcuKnwCwGi8zAj3x9bT5FgG0Py9B
	UkUq86PxzjzzgXazE4batqm/PblNrErf87wB5DWwgTMiPuwh0P23gpAY
X-Gm-Gg: ATEYQzxTG+6fXzKQMXo+XGwD1asYZvxPGkeoV9ynMj0fJNmTa2+r7qPQNIgZi0ak0WQ
	EHm8dpcpwrjyAaYn/VUrmS2lAmvinZG6gaXx+zJwXUTpNLjveDMAaPBboAYvFtfYPHX4tfDQRUT
	MYq964MkgV/n2E5SSPzsupuJDBTxlDk0DFbLgRX+m2MX9/VcnrBZvwB3MNQs0kLrQ3v0wYfU/kh
	+ZXBoPEraiCU/6lrMzOp1RUFfLlg4USpb6Gf7Ys4fiHWFsa1giE2Z7iF9halgYi80v0t+l9mhdv
	UxnXAXlGVvdXy/GFpgVUPi89ZxMxXecEtBBWzy71BeidP9lrcDYcgnB/+hDi/18i9f47F/+AGkA
	bYHbEnpTNXsU1+ghu3nd6y2lkDKLtpCKAy4SJ+Km0WPCszdHMlXi/eQzv6vnLPxwVn9pMlb5Pj/
	mAJnu56rIo1ClFJasFn4Bo8z9OrIZERZcKyYDTG0tMBpQR3A==
X-Received: by 2002:a05:6870:1405:b0:417:14d1:9671 with SMTP id 586e51a60fabf-41bd3f7d47cmr3526021fac.34.1773873006867;
        Wed, 18 Mar 2026 15:30:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd22dee78sm4108849fac.0.2026.03.18.15.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:06 -0700 (PDT)
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
	riel@surriel.com
Subject: [PATCH v4 07/21] mm: create scaffolds for the new virtual swap implementation
Date: Wed, 18 Mar 2026 15:29:38 -0700
Message-ID: <20260318222953.441758-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31D094000B
X-Stat-Signature: cyibbcszbpm7yn3mwix83bhxqcexqryo
X-Rspam-User: 
X-HE-Tag: 1773873007-188292
X-HE-Meta: U2FsdGVkX1/UQ9BXdcZNCaX7JN1EFx/cvihVJys4ZpeOal8ZuCJM6pwcJmKd20OvbjsDHlCGAi0kp2X4wcxEVm2ftRBnGZEqIWENRUzzQel7hwnn/FePhhVXfT9WftTo+eShxfSPfeGa2lZV2SQw/Wg6wzWVqYeDRThq/juiHAgZlcggNdZLl0i9VA1OGGaToobWo+l5M78noXkHwLutDLG8vi1n2OGRhyW3bINRuZ5J9nwCR2DibXUzoxf1LyUeip3/ii6ZCAP+kIywT1BmXde0uqqvZ1aEg3B4WvlVxWksF5v379gExa1tJOUE+Vxl1latuGRCe3ecRWkYKScVWZqzc1raqMVhHXwLsU9tRGag97WboRi9/e4fStt3iFTI21rjO3AyllIgJ2Cc8JSVsNQAmvgkvwmaMJpMJ/92hFvmi84Tyd0zbcst73qoYJIJYeSiH1o5eylVRJgZM6t5pLCXEjNEi2sHc0E2mZTF0+1nXeUD5BsRXWRETaOR23gEcV9zc/UT8sawRmfLzxpY/ISk/JF5u1nshDrUnakl79ibGcVJDzgNvz9U6k7XpuheJ8Y9oZ8T5njKfD1mGFUnrNLoFTNfqYGOM0TmH3WRZqDCLfFaufYIr2uwHpG6XBdGsM3OIE+IXn5DuYvlb2Gnck9OLNKHOYF/RLvXt4o6K/l4a5BLyZ1WFRW5sOqfH5ZfHkJy64reM64KipZ7tQekEj17OaTPPuxaohcW6gwT+Sf13QOf0zfOB5zW9s2eCqYVpJFJBN9tvZPLK0p8leLZ1H5hbB0ZUpsn96O+mS22pGHI4OOTLTW6l8uQNkMHSHQPdjNAu32BxZ6pmRYaCa/+DOPKTf5H5SI8x/KcVF/VI6QmbwQh/5AZRMQyMDCKu1bLAJEAg58okqktQfnVmgGx8u2UOyORdWRnQMUIGYv1/aolM8LqpsS2ITXJgol0xgv3unTEtcIBK0t7j+Sklo2
 RtBBhTq/
 CQJXpMvunpp/59buENytO0l/gZU2d1i475B1L0bvQnpO//lNXa1bhvjCKZzPOgadejDNyWpZXIm0i7BHJSH2VUhkpYQipRYlsLOkqp2pS+ZSIU7bCj4mq5oAcHuy36vZmrh+7zGRET1pf+N1n8qfAjFS03bWMXsZ5gW2C6kZ+sR0sJ7fgbcKse7AHn2Bvi7zjFesWo7K7jTdImz3YOJwgvN9fy5KQxoQ8D/NjaOg4CLRDpGV6elmnjdi+B28Wn5YEZmJZmDNAEjA4Ygag+9y+uOHxINnnxFdyY/XyUZe5lRL9AyONnK0dh0cdM1bpXBpxzWQRbGbk314rfjfWCzwA19S4x8kpO4iZ3c3v835NoMkzAdHUqxy+28eb9H1Ip20fk4NrWfZfLzCaMk48TunJKgTGeBzXaXuXY0roUorv7z1qpiw14WfJMZitj1Mb4CrmGyJ3uwJR268lM7KI3Yrv7XB7TipwXYHeksk8e03+FfJcaI8FBKkxiDwRFBaBRI9/hLXEN3z7woWMMIpmJPpR4vajuf6+xPPvffxL9X1gjUE4cVzDxXBwL7xYeuhE/7iMijH+Dtn+XOE7iGxrLY5Sbv96ejNP9JibohZ8WorVRW3/CgdRfhTmuTrwr+bBIxnunruG9WJi5mvH3p6flZWuD5JOZc+08peDNwR9NwnvCFsRkl90B0OeNdKpXsj+JBXlmq/rLnNyw7Pg335JTeh/qmDd9XjV+ZKya54ESXOKWRqmrE2GvfuEWc9IQha3JjGsLMCQLc701PwGrp6t3OQWsdZDwA==
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
index 918b47da55f44..df0771903a952 100644
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
2.52.0


