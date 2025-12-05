Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0778D374BC
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C096B0325; Fri,  5 Dec 2025 18:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D076B0327; Fri,  5 Dec 2025 18:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B335C6B0328; Fri,  5 Dec 2025 18:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 953F66B0325
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:32:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C815587F9
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:25 +0000 (UTC)
X-FDA: 84187018650.19.F6C5F17
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B0231A000F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fCvPQdRs;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764977543; a=rsa-sha256;
	cv=none;
	b=iemwsVjNAs+vk5CKfTc7fw8pSbuVwpxYVixzDXykxYbd1uUESfbNHC00WRVcviBspIlS2g
	QPj0mtdnB2GocJ+YxEo7gZuY4owvPJuwLgIe2yTrvx9yz97+/sENFHKnjupFDoTFZEStwL
	SBQs7v7GeB6Ur8zUmXNMJQx5PxXOzR8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fCvPQdRs;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764977543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dNzBA/KM3TzCUjw+cH+YJCV/4vpqJc2N6ZuhjsZcyw=;
	b=gnxhJM5cZBuKbSEuQM8WkwOrJqBpZRjdTI66oEd8rm9JCFFcygp+9sQz1Wozhs1RM8epzg
	USXMdMiReAlr4BW2FvIy/yo4OVKJk65PLmBxwINiOJj4WmDTUB6G7IE78zTJKAB7big3xN
	3dcyJPRxg2VKedYQOd8P/LJL4tX2z98=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7815092cd0bso24396377b3.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 15:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764977542; x=1765582342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dNzBA/KM3TzCUjw+cH+YJCV/4vpqJc2N6ZuhjsZcyw=;
        b=fCvPQdRsmrK5vGPK16Ag7IHmy/3sA/IEDobKPDvLjJRZZzqq2fkmU6LYG91MATWhMo
         7QlUILBTlnlZ6bgYyy1HAahioBsqwIAFmXYziuXpXDXFKJ7bADw/H4NjBzwQnySozSxo
         UYK0r3DrKN9XIWdtOgE9gbb+qXi7zuXCQSsI84f697DqP/0jeAWkME52ybYXovgdKhR4
         RfHOBHS92hl+HeV2WzzR5JbXfOAjm5QG9khaeXsHi/OlNz/tCY2e0pBbpXFa9+5Ma0XW
         hRt12I8TruFvD0qjRbfv0vIjhMHI3J2hA285lrETN9EeOFS34OCJ902ZckN91dWK/7S2
         qO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977542; x=1765582342;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0dNzBA/KM3TzCUjw+cH+YJCV/4vpqJc2N6ZuhjsZcyw=;
        b=qTkMAAsmHVkS54DT7f+nrek6hH/K6ecsGH5dZgtvA1J3YgYs2y0XiSA15BmO+1oyVy
         TZCLKGbzdFvt9IK3n44HOxHd6gFFw7COCkTJiDs7MHKmlfpqSlCXBMF6mxieW80SejVR
         ezKp6SYetYH/DmeT1mTAwbX2bjBJptxBgKVwrHghngxRNqzX/xpB6+JxsR5z0EO90ya7
         P0mir7DRXYw9v0x4wqulYQI35cDjBuRj4sByr/ieHwgeKEofoE9EHMoepi1oCB/fNvAy
         M4ocyIGhxIVMFRZfN8uekzsB7eUtlyLdOYfCVhPerkELfVPboEd3zTM4+rykop/aRBrF
         i0oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkC6I54wwjIddxvRANh3JkNa2thLQv+BKzGZw05tGZpVTllekFhbmaHZqxU0HWGRM3i7/NmxxLXg==@kvack.org
X-Gm-Message-State: AOJu0YzHTUB6AeWB+CuB88/yuvU1F7svYs7ou4sPsWySeXBqF+Ed49fh
	QTKJHk6lR1Rz14rEd4oJZBkWR7KTnA/IpN1V+vlDqfRmsseYEXgWLDZs
X-Gm-Gg: ASbGncuheGWV08t8Spi2oq26FwDcdNwOOZSztGwMYcsOTO/ULFffZFW5a6WHAa0iP41
	MDMgKINxY2wAtV4TWu2hhpEUbFszXEf5DUE44jxiigl9ympCsicNOOLFp558fGtdmQj1fSx/U5B
	OFXPbsEy8diLbY22KStKM9ua4cOZvNtGJ5OV1seXYZYDgsVoXAgXAerAPgzYAPyV/+A1kjfK9XA
	lf35Qgl4R7RMpChmKVS+dTQ612WPEqy+4/o4mqcL/ngSP6rI4owog8/VmWhpmce5CPXkp0rty98
	OJ20Er3fjFw3k6lTQ9aUMVBUcModbEYEUR+mUaZUwP5Vm1K0XZ1luPLTLSm3tcx1O9S71bkVHdm
	3L7TPgsQoDM3tno+ZEx8YQYDz9+LwFIpQ0wGXSrWDErCi3WWmRgeArcxkpS2Z6vlcgHrRKCLFIv
	y7H8peK+6KbQbEa3lY4JKq
X-Google-Smtp-Source: AGHT+IGDMUjSj5eZNlS8p7+TuSppjTK9shhyWb4cNaH9Kyj+wS4thzK9tHU/IzcAApEIw14tqpAafQ==
X-Received: by 2002:a05:690c:4b87:b0:789:61ca:88f6 with SMTP id 00721157ae682-78c33b19cedmr14020287b3.4.1764977542151;
        Fri, 05 Dec 2025 15:32:22 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:1::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6443f5b0c2fsm2331650d50.19.2025.12.05.15.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:32:21 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: 
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wei Xu <weixugc@google.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC LPC2025 PATCH 3/4] mm/vmscan/page_alloc: Deprecate min_{slab, unmapped}_ratio
Date: Fri,  5 Dec 2025 15:32:14 -0800
Message-ID: <20251205233217.3344186-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
References: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B0231A000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: xyag9c7k83hsmyro8zhkmh6g48w8p655
X-HE-Tag: 1764977543-745270
X-HE-Meta: U2FsdGVkX1/+RYJYTTRxyhcHIltybNfPd1YVSuEKxvniYTdeg4mp/5MUF+YLfxEXNAlx/7FCcLb6V+QUpVZ0ul5mldJJquRJ7yJHyQkjIYwCcWhx9u3aUaRgoIsTUEOYQJkk3SBwAx/9XCiTk5PwzKFRSAkMq7jioxFXsR8MBBaqPVcgmRl3+BVR1aNaMMtM3ydfIUK3zG1oDKO+xZu+ZwGGUf0Xyk6Cp5CJYAmiPuGmU0cmSfT3s19zgbMPicdvvLn7M1wBUS6GZQQibmMVfiFN3TnNcNaU6bToMrwqbdGxHcDBVDMr/GeK/5qTyvcXGAW5pM0rHqjb9fE4w15ASByHF1ytbqF0YC2lElAuMnj8JkkMWp3ouEX7mzGqeL9SSuH/pnHdNqS9G/Mord2mxXI4VGS8600wUemc2s+GeyCCwyChgotfuV0zZbgfOxfsfMmweMvh5nNZaCYdILuBh+uyRbmINDoZ7k8hcPuAiMqyMz9xKebG5onVTbgB8id4mtUdN0dsCzbADtcmln6Ra5ocWqbHUZ7owVEwJ9k1Ku1wG5XLsZ5Rh6pLxojcCp/tp3R6bec89AexhAB5Q4rV1s0scQOkNbT9ItHoLSFS5Wwm5MAJJIzvHJxqD9uBGshYksMFQs7963bU9jXh6cI69oJIjtuKQ/NYZBdX7WkNTpHPwcICirt6bHXRVB/LMMtEFuMbtysAIyc2UHlyYMI6MGUaExRp5m6EH7Ttf/Rd2afcCKulFI6gSJ6Lb/Kokd4F247sPMawdhOzUABWsddi7klo5Mi9NfGCDqEeNVZpj17A7P2cGxxSKm/pR/Rd55snghtvnAAOKd1LFogqVnv01BnNJmg2R9p1KShaSfCLYywU+04w1YAJAi/7JeVlYq2dCJ2w3ikXOsfZo+HRTL84NRiK9TPh91ZoxjVfJMuJ+4FLlZ2p/actcneUEQQD8Kxi5KU+ikQqn3669caeU5p
 vdELlL5D
 GHo6jaxfUKE+epZ8VsvubatRL4Jpdvsx1AjNBpmQM+9O1vLDvDoROhSSv4BvcEirOhgLVFcnBoCkV5kToCxHZYhK2P8dZsnwfAQivPYaENB8NFPegq28heSzEfwgR/p4N9tQxG63MyfeVIZQLr4shS2XmEIGYruO2Sgyg2vO/glkc4no6saFW/VckoaHa9EMpmIEZJcnRixMU2FCY5BWhYN2FSkdEne01FfooD2HKGIgwXw/jFGoAjutdoQ4s3K+sXYEYPko9GPzfPV0H0bLCn1BfeFJgy63toUxE3JWXDSr3Zx/TkiQg78SxFaYbv30jqiwoqMsRyoSxbd9k1OLm40WWSrROyxnqrzXa2FI6An5NDVqEcLVZZfHtb4QAOXA9CdmJFDM5OqSMd4x8rSwOj2nVMkPjEasi9poXSEDSme8Nx+72SXvPcCXTalxU3ocSjuuspQvpcpfccgOHmWMO6VqUn2a6asL7bSV0O7WN8loFvyy2w7ahzgXIk+nBFZ6UK4KeFH9UDsNyoeTzoWyq8uL0DR8R6xP5wmyX4sSfDKbC8xdWyV6uArXa1Pxao7yzPOjMKOf6BNzG+XU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The min_slab_ratio and min_unmapped_ratio sysctls allow the user to tune
how much reclaimable slab or reclaimable pagecache a node has before
deciding to shrink it in __node_reclaim. Prior to this series, there
were two ways these checks were done:
  1. When zone_reclaim_mode is enabled, the local node is full, and
     node_reclaim is called to shrink the current node
  2. When the user directly asks to shrink a node by writing to the
     memory.reclaim file (i.e. proactive reclaim)

In the first scenario, the two parameters ensures that node reclaim is
only performed when the cost to reclaim is overcome by the amount of
memory that can easily be freed. In other words, it acts to throttle
node reclaim when the local node runs out of memory, and instead resorts
to fallback allocations on a remote node.

With the zone_reclaim_mode sysctl being deprecated later in the series,
only the second scenario remains in the system. The implications here
are slightly different. Now, node_reclaim is only called when the user
explicitly asks for it. In this case, it might make less sense to try
and throttle this behavior. In fact, it might feel counterintuitive from
the user's perspective if triggering direct reclaim leads to no memory
reclaimed, even if there is reclaimable memory (albeit small).

Deprecate the min_{slab, unmapped}_ratio sysctls now that node_reclaim
no longer needs to be throttled. This leads to less sysctls needing to
be maintained, and a more intuitive __node_reclaim.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst       | 37 ---------
 Documentation/mm/physical_memory.rst          |  9 --
 .../translations/zh_CN/mm/physical_memory.rst |  8 --
 include/linux/mmzone.h                        |  8 --
 include/linux/swap.h                          |  5 --
 mm/page_alloc.c                               | 82 -------------------
 mm/vmscan.c                                   | 73 ++---------------
 7 files changed, 7 insertions(+), 215 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..ea2fd3feb9c6 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -49,8 +49,6 @@ Currently, these files are in /proc/sys/vm:
 - memory_failure_early_kill
 - memory_failure_recovery
 - min_free_kbytes
-- min_slab_ratio
-- min_unmapped_ratio
 - mmap_min_addr
 - mmap_rnd_bits
 - mmap_rnd_compat_bits
@@ -549,41 +547,6 @@ become subtly broken, and prone to deadlock under high loads.
 Setting this too high will OOM your machine instantly.
 
 
-min_slab_ratio
-==============
-
-This is available only on NUMA kernels.
-
-A percentage of the total pages in each zone.  On Zone reclaim
-(fallback from the local zone occurs) slabs will be reclaimed if more
-than this percentage of pages in a zone are reclaimable slab pages.
-This insures that the slab growth stays under control even in NUMA
-systems that rarely perform global reclaim.
-
-The default is 5 percent.
-
-Note that slab reclaim is triggered in a per zone / node fashion.
-The process of reclaiming slab memory is currently not node specific
-and may not be fast.
-
-
-min_unmapped_ratio
-==================
-
-This is available only on NUMA kernels.
-
-This is a percentage of the total pages in each zone. Zone reclaim will
-only occur if more than this percentage of pages are in a state that
-zone_reclaim_mode allows to be reclaimed.
-
-If zone_reclaim_mode has the value 4 OR'd, then the percentage is compared
-against all file-backed unmapped pages including swapcache pages and tmpfs
-files. Otherwise, only unmapped pages backed by normal files but not tmpfs
-files and similar are considered.
-
-The default is 1 percent.
-
-
 mmap_min_addr
 =============
 
diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..ee8fd939020d 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -296,15 +296,6 @@ See also Documentation/mm/page_reclaim.rst.
 ``kswapd_failures``
   Number of runs kswapd was unable to reclaim any pages
 
-``min_unmapped_pages``
-  Minimal number of unmapped file backed pages that cannot be reclaimed.
-  Determined by ``vm.min_unmapped_ratio`` sysctl. Only defined when
-  ``CONFIG_NUMA`` is enabled.
-
-``min_slab_pages``
-  Minimal number of SLAB pages that cannot be reclaimed. Determined by
-  ``vm.min_slab_ratio sysctl``. Only defined when ``CONFIG_NUMA`` is enabled
-
 ``flags``
   Flags controlling reclaim behavior.
 
diff --git a/Documentation/translations/zh_CN/mm/physical_memory.rst b/Documentation/translations/zh_CN/mm/physical_memory.rst
index 4594d15cefec..670bd8103c3b 100644
--- a/Documentation/translations/zh_CN/mm/physical_memory.rst
+++ b/Documentation/translations/zh_CN/mm/physical_memory.rst
@@ -280,14 +280,6 @@ kswapd线程可以回收的最高区域索引。
 ``kswapd_failures``
 kswapd无法回收任何页面的运行次数。
 
-``min_unmapped_pages``
-无法回收的未映射文件支持的最小页面数量。由 ``vm.min_unmapped_ratio``
-系统控制台（sysctl）参数决定。在开启 ``CONFIG_NUMA`` 配置时定义。
-
-``min_slab_pages``
-无法回收的SLAB页面的最少数量。由 ``vm.min_slab_ratio`` 系统控制台
-（sysctl）参数决定。在开启 ``CONFIG_NUMA`` 时定义。
-
 ``flags``
 控制回收行为的标志位。
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..4be84764d097 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1451,14 +1451,6 @@ typedef struct pglist_data {
 	 */
 	unsigned long		totalreserve_pages;
 
-#ifdef CONFIG_NUMA
-	/*
-	 * node reclaim becomes active if more unmapped pages exist.
-	 */
-	unsigned long		min_unmapped_pages;
-	unsigned long		min_slab_pages;
-#endif /* CONFIG_NUMA */
-
 	/* Write-intensive fields used by page reclaim */
 	CACHELINE_PADDING(_pad1_);
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..c5915d787852 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -411,11 +411,6 @@ static inline void reclaim_unregister_node(struct node *node)
 }
 #endif /* CONFIG_SYSFS && CONFIG_NUMA */
 
-#ifdef CONFIG_NUMA
-extern int sysctl_min_unmapped_ratio;
-extern int sysctl_min_slab_ratio;
-#endif
-
 void check_move_unevictable_folios(struct folio_batch *fbatch);
 
 extern void __meminit kswapd_run(int nid);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 010a035e81bd..9524713c81b7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5676,8 +5676,6 @@ int local_memory_node(int node)
 }
 #endif
 
-static void setup_min_unmapped_ratio(void);
-static void setup_min_slab_ratio(void);
 #else	/* CONFIG_NUMA */
 
 static void build_zonelists(pg_data_t *pgdat)
@@ -6487,11 +6485,6 @@ int __meminit init_per_zone_wmark_min(void)
 	refresh_zone_stat_thresholds();
 	setup_per_zone_lowmem_reserve();
 
-#ifdef CONFIG_NUMA
-	setup_min_unmapped_ratio();
-	setup_min_slab_ratio();
-#endif
-
 	khugepaged_min_free_kbytes_update();
 
 	return 0;
@@ -6534,63 +6527,6 @@ static int watermark_scale_factor_sysctl_handler(const struct ctl_table *table,
 	return 0;
 }
 
-#ifdef CONFIG_NUMA
-static void setup_min_unmapped_ratio(void)
-{
-	pg_data_t *pgdat;
-	struct zone *zone;
-
-	for_each_online_pgdat(pgdat)
-		pgdat->min_unmapped_pages = 0;
-
-	for_each_zone(zone)
-		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
-						         sysctl_min_unmapped_ratio) / 100;
-}
-
-
-static int sysctl_min_unmapped_ratio_sysctl_handler(const struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos)
-{
-	int rc;
-
-	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (rc)
-		return rc;
-
-	setup_min_unmapped_ratio();
-
-	return 0;
-}
-
-static void setup_min_slab_ratio(void)
-{
-	pg_data_t *pgdat;
-	struct zone *zone;
-
-	for_each_online_pgdat(pgdat)
-		pgdat->min_slab_pages = 0;
-
-	for_each_zone(zone)
-		zone->zone_pgdat->min_slab_pages += (zone_managed_pages(zone) *
-						     sysctl_min_slab_ratio) / 100;
-}
-
-static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, int write,
-		void *buffer, size_t *length, loff_t *ppos)
-{
-	int rc;
-
-	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (rc)
-		return rc;
-
-	setup_min_slab_ratio();
-
-	return 0;
-}
-#endif
-
 /*
  * lowmem_reserve_ratio_sysctl_handler - just a wrapper around
  *	proc_dointvec() so that we can call setup_per_zone_lowmem_reserve()
@@ -6720,24 +6656,6 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= numa_zonelist_order_handler,
 	},
-	{
-		.procname	= "min_unmapped_ratio",
-		.data		= &sysctl_min_unmapped_ratio,
-		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
-		.mode		= 0644,
-		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE_HUNDRED,
-	},
-	{
-		.procname	= "min_slab_ratio",
-		.data		= &sysctl_min_slab_ratio,
-		.maxlen		= sizeof(sysctl_min_slab_ratio),
-		.mode		= 0644,
-		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE_HUNDRED,
-	},
 #endif
 };
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d07acd76fdea..4e23289efba4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7537,62 +7537,6 @@ module_init(kswapd_init)
  */
 int node_reclaim_mode __read_mostly;
 
-/*
- * Percentage of pages in a zone that must be unmapped for node_reclaim to
- * occur.
- */
-int sysctl_min_unmapped_ratio = 1;
-
-/*
- * If the number of slab pages in a zone grows beyond this percentage then
- * slab reclaim needs to occur.
- */
-int sysctl_min_slab_ratio = 5;
-
-static inline unsigned long node_unmapped_file_pages(struct pglist_data *pgdat)
-{
-	unsigned long file_mapped = node_page_state(pgdat, NR_FILE_MAPPED);
-	unsigned long file_lru = node_page_state(pgdat, NR_INACTIVE_FILE) +
-		node_page_state(pgdat, NR_ACTIVE_FILE);
-
-	/*
-	 * It's possible for there to be more file mapped pages than
-	 * accounted for by the pages on the file LRU lists because
-	 * tmpfs pages accounted for as ANON can also be FILE_MAPPED
-	 */
-	return (file_lru > file_mapped) ? (file_lru - file_mapped) : 0;
-}
-
-/* Work out how many page cache pages we can reclaim in this reclaim_mode */
-static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
-{
-	unsigned long nr_pagecache_reclaimable;
-	unsigned long delta = 0;
-
-	/*
-	 * If RECLAIM_UNMAP is set, then all file pages are considered
-	 * potentially reclaimable. Otherwise, we have to worry about
-	 * pages like swapcache and node_unmapped_file_pages() provides
-	 * a better estimate
-	 */
-	if (node_reclaim_mode & RECLAIM_UNMAP)
-		nr_pagecache_reclaimable = node_page_state(pgdat, NR_FILE_PAGES);
-	else
-		nr_pagecache_reclaimable = node_unmapped_file_pages(pgdat);
-
-	/*
-	 * Since we can't clean folios through reclaim, remove dirty file
-	 * folios from consideration.
-	 */
-	delta += node_page_state(pgdat, NR_FILE_DIRTY);
-
-	/* Watch for any possible underflows due to delta */
-	if (unlikely(delta > nr_pagecache_reclaimable))
-		delta = nr_pagecache_reclaimable;
-
-	return nr_pagecache_reclaimable - delta;
-}
-
 /*
  * Try to free up some pages from this node through reclaim.
  */
@@ -7617,16 +7561,13 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	noreclaim_flag = memalloc_noreclaim_save();
 	set_task_reclaim_state(p, &sc->reclaim_state);
 
-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
-		/*
-		 * Free memory by calling shrink node with increasing
-		 * priorities until we have enough memory freed.
-		 */
-		do {
-			shrink_node(pgdat, sc);
-		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
-	}
+	/*
+	 * Free memory by calling shrink node with increasing priorities until
+	 * we have enough memory freed.
+	 */
+	do {
+		shrink_node(pgdat, sc);
+	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
 
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
-- 
2.47.3

