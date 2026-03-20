Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDCF1099B3A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8EC6B0155; Fri, 20 Mar 2026 15:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B10A6B0158; Fri, 20 Mar 2026 15:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD6B6B0159; Fri, 20 Mar 2026 15:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC4546B0155
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:27:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EEB2C132D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:49 +0000 (UTC)
X-FDA: 84567426258.24.E7F5683
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id A22E61C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:27:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hRzWcnGm;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774034867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=augNyOBtiYJ0dgm3cOulQaqdWfbdzgL3KEY1IT/V5Xs=;
	b=yVq4NT67yvAM5QDCK/eIYPBA2LyC+pIlfid1ppq7G3HD6O+YFOx1fAf1nri0rP8yPm/NHU
	CmdNHMZydjOO5AgghWUZLMpeMHR3wGDsHhf/RKpr2fCE5V/x2ffGl3zfE1trBUx1r0pkLG
	U3LOjNb0nB7lffM3rP0f5TRP18B6r9I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hRzWcnGm;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774034867; a=rsa-sha256;
	cv=none;
	b=kUiOuVt1V5MHPUgS+Y160B+4DJyhrGiQJM7ECibPKYlwWKSbUmgE/WOmumV29vJ1rTDS+s
	QDgrtcZaiOL21sauAbvy3E0lW75+eZVkz11aRX/19TlAvW8872bnJnuqQjIVsdqMF2quQO
	L6nuC9/CdFro+VBlMDghy8edWD0xCRk=
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-467e044082dso352316b6e.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034867; x=1774639667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=augNyOBtiYJ0dgm3cOulQaqdWfbdzgL3KEY1IT/V5Xs=;
        b=hRzWcnGmespPHXcpUP7rrrJMebrE3O3TYVZVJjhpD13NASby+F+cQD4iqmdu+OLXOj
         t0eY2pdEJvr/+eybdplOzhBMGmlMdsgqGHYTpSJ2lmkA88/ZP7qT1VkP+OGc65eyV6QW
         quYuxyKeM30cO+hfjD9KmVEqAJlKlDcSAheOxz4MZEZyO7dSTeaOH72CTcxWSIfLKyjv
         XnZD8h4Iy0Pe+M9EG78XBS1ATYPoPgEQW7VOwurNYUm5M2U0w4R+F7m1Evsb1iVaUV0p
         cHwKxpHcqYFuGr9/dUoGFvmKPYsbRQdN4WBJxXD/bYp+samA1lZM7w26KwhdIVjoNzSL
         xf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034867; x=1774639667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=augNyOBtiYJ0dgm3cOulQaqdWfbdzgL3KEY1IT/V5Xs=;
        b=YvWGBwVt9c8dKZVFNUzyh5XEi3LgDPT9LVR++qTegjYYzDlgHKRk8bisfspTpcAVES
         Mp6GZCG8IgaRY64YJFwQ1Gs+SJ4n1dfK0DYsCIgkrp9mcWacFiJANl/lMfNL7Df4a+DL
         K0DTdp5lbFr2d0vIbpv9HND4gEFe6knUC56NHP8w7kJnv3/t6ruqNgwCRSryux+nYvCH
         U8SIAxyjhDpNYWu6V1tnCeWzlVrbEZk47MW3jfHbjGJtT6nJenI6rPdEgerspxRK6ldm
         YtbN1w2jel+H2mqLi+N2kekFIoyqwV9qB7LfOjFFpxrM7p3Y7/1g5xtn9MmjR/zBORSI
         jpRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW88PtjogipNFF4tCd96E49++DJSpSbgXO58ZPFkdaVqaqM4u070qPZgQC1UIRHDW0nNo7QbAG+Q==@kvack.org
X-Gm-Message-State: AOJu0YxNVbBeJdaYD/Q+thiiEQ+MN3FIgnvm3bJ108GbyaaEhuYeYAtl
	zPt/nLmCLdmzQa3WG4Lqvaoc8cnBBwQczXQQcxmfV30ma4cP9ac+JTKi
X-Gm-Gg: ATEYQzxuDqsL3CsuhkCQt150+eBDclGb+XQURCB0d86NOrtW0TQK4UZ4KVQjbLd3GWC
	iHOBbJgpsScjAsEEoCcPOZTqYx5JG8U7DwUaSV+TTo70LcbjYq2PzU4LTStBeqErvm0DQH60u8O
	1hHb68ZdJuaa5zuDaIqWTVbVp2QFZDRoqVAuDHi9B/gGv945EZGwi7hQNpaM8es7+k2g//td55+
	BjYF7Ku0SuwPXdnhU0gZm1b7wlcJH0DWtGS5Cswvmbrz/+nEvQFFqgnOGN+djfBIjKGjxVOuo3W
	w/nkD8UAHwnJLLF150MRmlkF44nLhVhwiCCAMFP2hL9+8XPgCOOdw0M59Y9+N0/OVQ85+bkRzQR
	M2npHk+Kr7TPIMzdHvDUxtrL5avwduUoJJ/sqLO6jZ9bQY2GDGOFAkpBlOUYOmh1K7yhl6FVT8e
	cKPo1HVl6i9TK3aKathmR/jXO/q/8o7Y75uzr8DVGRnG+OeA==
X-Received: by 2002:a05:6808:190d:b0:466:f054:c3b6 with SMTP id 5614622812f47-467e5fe7105mr2485514b6e.59.1774034866661;
        Fri, 20 Mar 2026 12:27:46 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-467e7d19abfsm1824746b6e.2.2026.03.20.12.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 12:27:46 -0700 (PDT)
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
Subject: [PATCH v5 07/21] mm: create scaffolds for the new virtual swap implementation
Date: Fri, 20 Mar 2026 12:27:21 -0700
Message-ID: <20260320192735.748051-8-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260320192735.748051-1-nphamcs@gmail.com>
References: <20260320192735.748051-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A22E61C0004
X-Stat-Signature: rpxxs9cpqo3qridye53srbpoxbi5j678
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774034867-723695
X-HE-Meta: U2FsdGVkX18FRkvEdHw1NQixjZJV4WRC6BCoDV2aOSHxMxtzdr3IbhOTl8LyRWHkfemxZgiLkFZc3s4DoCVG/b2e/vfqMdLbtDIHwWbsjRO+ZcTC9iERktkxOp7CD1bjuIYf2heX8mAyanlvFNxF1FluYlFSlfOKNTztWqkgNj/mokpq8U3myaHv+7UGPGuvsFNcgDkrpeJoY/ScnBW/omVnzdT4tgygydWHbRPucruniezKSVbiqt1ggTt6Y+aAg0H7zA1eLzvQ6BNhpwZfW1IuHPQqGfa8wpZPMwlU65OLkhvBaoIb9jS1MfHfepSMta7rNK1++kKkusQabg47KM+a8rIDvBQp8fETs/uk9L/nl9PsXreu7dg1X10mK0IZ7dJ7rqsR06a6iMYmb++wY/N/WPjUBfaNhHMjoyuqXn0u5Sqbw2M0H6Cux85+wEchl2ijJWt2d3ahxF3NP7FPQghkHS9GWAng7RmClQnt+Bvp5FA5AEIfaElQUPOZNwl+t1kctlF92mW/Yrsc4nV//G/lSwh/13WXSOPeYGMu//bpVSZcxse7BCP/Fo/4IcyUo5G96AIouMgq0G3vvF+xTghTgbUox7+crlOJDJ0ObcProSTMNrdOkLGOQ98wiwq/I+2b6bDx3dVm1yDXusrqvh/ho32kteUgxAFO9pdwjAm4lF40H2K9UE3A8Hu2igOUcXQl52tqq79mPbE44P8lmx3C5QHMrfVktCnQG0NTE5Y7/E+6wce4IfDezWOFYu1zNQDheNvGIpI/T7U77YdQEE2eNaW0tbk6+IXlvPakek5FLWTxyWiZ4Z3bOn2LsCzjKEap7TssEQazWC22tHLkjB16nIBNM424FOnyQgKTjZ0FsbkKHbWGxDunstx3dvlwD5PyhRkThdfnCMa6a72XhAvQH6i02Gd27x2T0O64BygE02doLSHLoMxN9E6u2sAQuhxbhL6AaHs+k1TTTDB
 lbsNcWcu
 r2x7Y2jeB/0uJuSx5vp8Ya8Y5fSYX9WMVhSVdPhBj76zNJlk5OJ7VxoZS2+TAFLXeb5wEKRyhvL2OVkFeTxb+J1IEwklbS/xxJRmYEzsijL+c/zAQh+YnroC3/DvOUs0XA0GAj4wYkV/RzBEvxqPmiL0IXj6JMnyv4llGVvWol3gqAHA+pwtMeikraWhO2G2kCRf5H/9h3RNUM4w9maMqaFDxZfdIX0mezKoMrAgo9rOKYvr6LN5n6InOXkbWvDzBvhA5qhPKcnZEImqJlDBUJGSokn4hhgetDxlExKrtqePcDGIWw7qXbSNRTelrW8fa0UHQipcDGvslUxLQpk6b5YNbpIlVCxz3jEA5sGti9oaewcL1bzS8xiPS++0IWMFm7AR7ywYgqAwKitYhZo8jKYt0TEUyBRZUS++/rpgHJDJffSCZYXzBz/pk+r8qhcQDf3UJ1kwHJNIvdLl9VG8tz9gmxBZZ+Gh/Uff8my05WGeoJoWBzIU67V/fCUggeUYqF7h7C1OJzudhE4frLIv9p14ZY8MWDiRwZ2OLAUpv+C7Avjmv4eZkHk2bQEcO/CY+DTqhPPq/fdoli3ZjxvLuArpqWye+2yciT7N9mVuyEJsB1Pg9d+zikKkkd8dmB6fB2X1zTQ4wBvDO8/CZa2quvIgmKYBa8GWS3fa/444DCSAjKmUCJPJ+utwmPHDK397yhbXgrwvg2kv3Kc9O7k+Xt4zhV82cvBs6/tECIbby9iWdGxmCQUUR+plP54Fw5PfIfWH4M5T3NygKQ77FXgTbYS6GuA==
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
index d3780bb330378..042dbc06c3d3c 100644
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


