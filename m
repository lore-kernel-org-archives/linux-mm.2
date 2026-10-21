Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFDCA606A336
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ocxiB7Bl
Received: by kanga.kvack.org (Postfix)
	id DDED76B01A7; Wed, 21 Oct 2026 02:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5556B01A9; Wed, 21 Oct 2026 02:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAE26B01AB; Wed, 21 Oct 2026 02:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE6E6B01A7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:18:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31741C047B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:18:47 +0000 (UTC)
X-FDA: 85345629894.13.85C72E7
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 69DE4C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:18:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ocxiB7Bl;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563525;
	b=HfFkxa1OuRD9cAFJYbGNacNg2IRSep8TQ5ulQWcnhpxOwPFuUIb/8jO2yrjSPhQska9mxi
	Mb7islCLANATmzM9VwoPdhyDqqJR1ewGhbXu9I4XkycaH7qA/jlD7+OU2Kkfp/kolRUMCS
	0HNoAiIzDRMnPHfX48G0FhZ1CYO+aMA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ocxiB7Bl;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58YpRd/cYSDDR/L9xMCDYI7HHr4Po+wYl+qR/bSF0HE=;
	b=m9/uBcSJtUGX09SJ800XfUc1RCCxUw5EBqqyBgkwb0+i94yaIzxC2/dcM0WWFejt8SVtZ5
	P9cXIPZuGSHuR5rQEobCXzkB+8QqVR0m4J9/eCK0KD6EKmSY+2LVfXUf4sfm+gDhvaebTe
	crB4BMibaZ+UOE449Y2V5yZOS3Cg27A=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67489c8202cso273228d50.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792563524; x=1793168324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=58YpRd/cYSDDR/L9xMCDYI7HHr4Po+wYl+qR/bSF0HE=;
        b=ocxiB7Bljy98RTfiY54n2u2MgwVK8K5A5RIXlOR5NB/X/Q1zsZ7b6lBqEff9XE6BEC
         dASNmZjS36Rd/Dc27rFKEKxu00oSkHCrdNQDDEDAm3p3qVuJ7hp2JQmXsaT9vaQ2SK+g
         57bzDKNyCVuHSqGDgMDw2Xky40citPcc0/RQ5HVJnfEYwhY07AaxW245LGnnqiKyiVx2
         edWpLCnAAVEiXU93FZfUnPnEzhYpi8CTHJjSSu70Oh6Vzcfp+f5vxGabwBIfcbIB6Zwm
         /LzeqI+n9GI3oRomZI6Pv2zVag3tZDvWEJwMvem/knb5ngfab4WH6u6ptJRNE7/UKDKe
         7dvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792563524; x=1793168324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=58YpRd/cYSDDR/L9xMCDYI7HHr4Po+wYl+qR/bSF0HE=;
        b=RPfhylurT33LHOePwTkHkKIXj3yz9X1KJ6uZZtGhq9Ur25XVRX3jKh2faBgfhxFF5t
         RS31bZctZ49wmnmg3BVqyGr9GOFwXpLtcPKhgNHnuZkyRmX3cjGtzWTFqEpXL6iOcdw6
         KWUBq9Ko1kP+XTdgtbdpnya9gXKAKQ4/6W5aGCWcXzduNmIJSK8HKmQ3ZndjH1YGIRuz
         EpObOF6NSrB1KG3D98SW0WQVrrXgYaGIoATQLIXzj7uIJY1XgDnkQQiFjACGWut4XofD
         eA6Af35Zpb8/2e1CnRqW4S+ly4tTz61OpWWBCp78ziF8fMhQ/YzB7uRhE72opKMOnj4y
         5rWA==
X-Forwarded-Encrypted: i=1; AKwUvBwC8L4sjnMp6FuAft/nbTfLDQ09w+/RTBhimy0Jgmlcp3vtB6zF7lmYtTSUeZzsERki597Z1E2U2Q==@kvack.org
X-Gm-Message-State: AFq9FYIh1g3Ri3tayXOP11r6437FsTKIJTkPVBxHSeFZqRdWveMcyOgh
	nv+NBs7imj8SZQGK7P0cM5vPLnca2BATqBhbZ83/J3dQTYQdhNoyD8U0
X-Gm-Gg: AYBFou0GS8XImK1BXeHyJup1r+5hrBKaOveqNOQb8HvxTYcwtlRzZ42X/xuYIjcpm39
	pE/eVbWdN55No38SImI0srMwnGn2mhjkPS04crtbQszDc+JfAFe9lD0PXpGz0SZVocGB6qm3T/C
	rJv2k+y4VvxVcUtbjuBT61jLFE32F5DgOrFbN1N2PJfucECcrZF0v7jX96Hennoz14q5nC39ylI
	TwKodvbdWTw4MOz6IpgruK2+WfVDyt+nI59d4r+4MA9IVzzYkh3H2u9N6K1Vv2VheSZ+kGgp2yL
	A/xJs/Y8SuplT+IRcqQU/4afwjk7c05FvakCLEnRoFP29/ebRilo0TRWEQKTDRBn2j4XWKz2/O6
	4LVLweSwLHMMJPJOiAsrFnQrtHP02Epc5xhvmgfEVAlMes53A9koMlBcX4k0/jC3IA90cbn4zpB
	pj07x+BnNbEXUTpnxF6BAp7R+vTQgI74/wRukkAKyPtsKPu6faMmVxCnhUjVcusb6Q6sS9XQWkr
	afspMlfJ4QB2mLdiabsODB7jagV9mpbaNDYl1eyAKLMAFxlpLwkRdnGJCydkw0UWLGu/38aFKaP
	3wyGJgrsTxHFY3rn9DqqwPNePJ7yjpKUAIZk0z9bCoaFcxoeCtHPDOMW5wPqnMzkJ/4xH/zM9wM
	obmBGQN+nCg==
X-Received: by 2002:a05:690e:1489:b0:677:bf19:f09b with SMTP id 956f58d0204a3-67a0e0331abmr712381d50.13.1792563524445;
        Tue, 20 Oct 2026 23:18:44 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e1851cfsm653829d50.1.2026.10.20.23.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:18:42 -0700 (PDT)
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
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 11/12] mm, swap: add vmstat and memcg counters for vswap
Date: Tue, 20 Oct 2026 23:18:36 -0700
Message-ID: <20261021061837.1569125-2-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ws19o67a39fqryzs5hdnqzmhdp883g3n
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69DE4C0004
X-Rspam-User: 
X-HE-Tag: 1792563525-56981
X-HE-Meta: U2FsdGVkX18Dgy4TtwbKLN0rwK51nQ/6c6jy4X/5i1/gyvs6M3AjmP+l/66nxuAtmarT/FgUrarINekuv5BxnXHMSupKUMQxwJLIjXSlFCp2RNz5xQGpyoSWreiTkK09lBud0mfTuYmuQPqaQydsH5IE4UMKKe362Bm6tP6W6HfnsTgHjkQLPKmY+Ba3AU+tTLA0k4pjDlgDzC2HMLFmwae6hfcy6BHShobs2OD4V/9DjTEgl/TnMrIah1Zwi9400gXljfeW1gDXmrBpddvYvP/f6N0tXRz/R1QS4dJMr4B9uZRZ9TNhhHh3vy9bgZufwATR40IOkZ8LDlQAg9eig2XkTbX7LsgCgVxpXgMcKNg5R+Y1rN5FW8X/ti0hzIXI6+2eZspILtivUS8o1mH0PhRQ7PhmbYnilvuSkuB7HcyxiKVWHjhz2u1idHKZE0tLZDg8jbmSFflp9LAz3xC2oG4r2u3xaEZahwXigPMOp8eR+rK10FoI8wCIVIbl8u2sTevlf2EwFe1p/iW4ZNhiwQWxhzMZTEu1+ZzJU1TG7m6fMnskFtGXp4vnjISLBnykoEkTbRG/cO6WUK6lmOMN28R3/qzFW7JfQRF9+RegWmK0JJw/EeDZo1nhbriHEkGJc/oxSMiKkR92RyDV3K/SdcCFifLJxb/YYW/4pbE9qaaWqWWksjtBx2CuHCo4mBPSl2kaosnjhEuntQrlMoXCOrz6GCdgnsNp+3MY90rBEZy1A5kVVsugENPs54Z0hR1nubCqC2qFa9If6wqjDGjjknk/+QOJe1AlqGK1Wwh1baGEglOfUHxm7se5wopQblaIcuLrpgP9X44dTzsgMM5Y3kEuklV7nVYBqqBjxLfWAg79oa1oWQho+c4MC+3qROat73gmfDRtGjK57QDdE6wJwLBIyjs8X5hbPT+HslYAkWvAh8HEpUJk//QjjfOGdzXKzbznVFAwDkS/YK++ULy
 frUFIahv
 +lDvV5q40bdglWHNDHPJykKUICj9UTVRsHSt6hVLk7L0JcAHx4QHx8wd9xdrH7Ginlp5uBoI3SpzpAi/wF5ztmuC7OU5v+or3PKJNj8nlxowLJXCX/tzDBnDzk6YsU6uudzq7fg3zkOsAz1/CFqazd+A45AQBgoqyAJ87kJ9q61K49wWLwZ4UxkSF8HSINI024CY4MT8NIpO83OMTXbRFiIOrK2OmSw3epdeaZCkkbeeJFsyRCgr/l7npCUq2cWmMDVHUbDmYez4TfnVA/zNGf1TnAh3PpPVgnvoVlaIkQZ12poh+Ux3sFDxwawex3Jm44iPsqcfc1eczqHu7kqtpiJGOab5SHghDHwojmCPYirgqCGesLFn+/avJ+5s26Ksvgh+LsjsQGjTFo8h88sOCINQUZuQmPpEExMHh+ChIwg0Mev1O4ICeyVc557FM/Pk+PKVfBIEuwuN9xZHWL2GOoSAGDGEUG8fXU+Swmo/29GpiIe5Nu41NQ/qBKhaOPUEL59Nsp5utCofZCIBrYDx3B4QRAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add nr_vswap to /proc/vmstat and vswap to cgroup's memory.stat to report
virtual swap usage.

These counters help diagnose swapping issues. Userspace can also use
vswap as a component of a workload's logical memory footprint when
making policy decisions.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 .../admin-guide/cgroup-v1/memory.rst          |  1 +
 Documentation/admin-guide/cgroup-v2.rst       |  3 +++
 include/linux/memcontrol.h                    |  1 +
 include/linux/swap.h                          |  1 +
 include/linux/vmstat.h                        |  3 +++
 mm/memcontrol-v1.c                            |  6 +++++-
 mm/memcontrol.c                               | 20 +++++++++++++++----
 mm/swapfile.c                                 | 10 +++++++---
 mm/vmstat.c                                   |  6 ++++++
 9 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 2a67356d25a0..8ca9ef2bca9f 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -555,6 +555,7 @@ memory.stat file includes following statistics:
                     cgroup.
     swap            # of bytes of physical swap usage
     swapcached      # of bytes of swap cached in memory
+    vswap           # of bytes of virtual swap usage
     dirty           # of bytes that are waiting to get written back to the disk.
     writeback       # of bytes of file/anon cache that are queued for syncing to
                     disk.
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 623d29ea8c41..b1f97a61a1dc 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1633,6 +1633,9 @@ The following nested keys are defined.
 		against memory usage, and against swap usage when the swap
 		entry has physical backing.
 
+	  vswap
+		Amount of virtual swap usage.
+
 	  anon_thp
 		Amount of memory used in anonymous mappings backed by
 		transparent hugepages
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b9072a3c9a2a..99beb676d8e7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -41,6 +41,7 @@ enum memcg_stat_item {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_VSWAP,
 	MEMCG_NR_STAT,
 };
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index a05189c92dae..891442264ca9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -371,6 +371,7 @@ bool current_is_kswapd(void);
 
 #ifdef CONFIG_SWAP
 bool mem_cgroup_can_vswap(struct mem_cgroup *memcg);
+unsigned long vswap_usage_in_pages(void);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 		unsigned long nr_pages, sector_t start_block);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 5b31d8e7ae40..37aff1ffac08 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -33,6 +33,9 @@ enum vm_stat_item {
 	NR_DIRTY_BG_THRESHOLD,
 	NR_MEMMAP_PAGES,	/* page metadata allocated through buddy allocator */
 	NR_MEMMAP_BOOT_PAGES,	/* page metadata allocated through boot allocator */
+#ifdef CONFIG_SWAP
+	NR_VSWAP,		/* pages occupying a virtual swap slot */
+#endif
 	NR_VM_STAT_ITEMS,
 };
 
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 4e4946728db5..8fa7b2fb109d 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -300,7 +300,9 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	 */
 	nr_entries = folio_nr_pages(folio);
 	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
-	if (!is_vswap_entry(folio->swap))
+	if (is_vswap_entry(folio->swap))
+		mod_memcg_state(memcg, MEMCG_VSWAP, nr_entries);
+	else
 		mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
@@ -1842,6 +1844,7 @@ static const unsigned int memcg1_stats[] = {
 #ifdef CONFIG_SWAP
 	MEMCG_SWAP,
 	NR_SWAPCACHE,
+	MEMCG_VSWAP,
 #endif
 };
 
@@ -1860,6 +1863,7 @@ static const char *const memcg1_stat_names[] = {
 #ifdef CONFIG_SWAP
 	"swap",
 	"swapcached",
+	"vswap",
 #endif
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2aa75a292ed..eedaa094a867 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -66,6 +66,7 @@
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
+#include "vswap.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include "slab.h"
@@ -459,6 +460,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
 	MEMCG_ZSWAP_INCOMP,
+	MEMCG_VSWAP,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1628,6 +1630,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "file_writeback",		NR_WRITEBACK			},
 #ifdef CONFIG_SWAP
 	{ "swapcached",			NR_SWAPCACHE			},
+	{ "vswap",			MEMCG_VSWAP			},
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{ "anon_thp",			NR_ANON_THPS			},
@@ -6004,6 +6007,7 @@ unsigned short __mem_cgroup_swap_get(struct folio *folio)
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short id;
 
 	if (do_memsw_account())
 		return 0;
@@ -6020,7 +6024,12 @@ unsigned short __mem_cgroup_swap_get(struct folio *folio)
 		return 0;
 	}
 
-	return mem_cgroup_private_id_get(memcg, nr_pages);
+	id = mem_cgroup_private_id_get(memcg, nr_pages);
+	if (is_vswap_entry(folio->swap)) {
+		memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
+		mod_memcg_state(memcg, MEMCG_VSWAP, nr_pages);
+	}
+	return id;
 }
 
 /**
@@ -6109,7 +6118,7 @@ void __mem_cgroup_swap_uncharge(unsigned short id, unsigned int nr_pages)
  * __mem_cgroup_swap_put - drop the private ID refs taken for swap slots
  * @id: the pinned private ID
  * @nr_pages: number of refs to drop
- * @is_vswap: whether the released swap slots are virtual
+ * @is_vswap: release virtual-swap accounting along with the refs
  */
 void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages,
 			   bool is_vswap)
@@ -6117,9 +6126,12 @@ void __mem_cgroup_swap_put(unsigned short id, unsigned int nr_pages,
 	struct mem_cgroup *memcg;
 
 	guard(rcu)();
-	if (do_memsw_account() && !is_vswap) {
+	if (is_vswap || do_memsw_account()) {
 		memcg = obj_cgroup_memcg(obj_cgroup_from_private_id(id));
-		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+		if (is_vswap)
+			mod_memcg_state(memcg, MEMCG_VSWAP, -nr_pages);
+		else
+			mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
 	}
 	mem_cgroup_private_id_put(id, nr_pages);
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index e95f2441fdd7..fe5460d15f55 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2612,9 +2612,8 @@ static void __swap_cluster_free_phys_backing(struct swap_info_struct *psi,
 }
 
 /*
- * Release the cgroup accounting of a batch of freed slots. For vswap the
- * physical swap was already uncharged by __vswap_release_backing(), so only
- * the ID ref is left to drop.
+ * Release cgroup accounting for freed swap slots. Physical backing of
+ * vswap entries was already uncharged by __vswap_release_backing().
  */
 static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_vswap)
 {
@@ -4922,6 +4921,11 @@ early_param("vswap", early_vswap);
 /* vswap does no IO on its own. */
 static const struct swap_ops vswap_ops = { };
 
+unsigned long vswap_usage_in_pages(void)
+{
+	return vswap_is_enabled() ? swap_usage_in_pages(vswap_si) : 0;
+}
+
 static int vswap_used_get(void *data, u64 *val)
 {
 	*val = swap_usage_in_pages(vswap_si);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a3e809c57f29..b7077a6f244d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1320,6 +1320,9 @@ const char * const vmstat_text[] = {
 	[I(NR_DIRTY_BG_THRESHOLD)]		= "nr_dirty_background_threshold",
 	[I(NR_MEMMAP_PAGES)]			= "nr_memmap_pages",
 	[I(NR_MEMMAP_BOOT_PAGES)]		= "nr_memmap_boot_pages",
+#ifdef CONFIG_SWAP
+	[I(NR_VSWAP)]				= "nr_vswap",
+#endif
 #undef I
 
 #if defined(CONFIG_VM_EVENT_COUNTERS)
@@ -1936,6 +1939,9 @@ static void *vmstat_start(struct seq_file *m, loff_t *pos)
 			    v + NR_DIRTY_THRESHOLD);
 	v[NR_MEMMAP_PAGES] = atomic_long_read(&nr_memmap_pages);
 	v[NR_MEMMAP_BOOT_PAGES] = atomic_long_read(&nr_memmap_boot_pages);
+#ifdef CONFIG_SWAP
+	v[NR_VSWAP] = vswap_usage_in_pages();
+#endif
 	v += NR_VM_STAT_ITEMS;
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
-- 
2.53.0-Meta


