Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 330D4D374B7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CE76B0327; Fri,  5 Dec 2025 18:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDCE6B032A; Fri,  5 Dec 2025 18:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA696B0327; Fri,  5 Dec 2025 18:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 818336B0327
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:32:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4758AB8878
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:26 +0000 (UTC)
X-FDA: 84187018692.12.DFCBC7F
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E9051C0013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7sEQ+ar;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764977544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1bp6D5JTy++9hCcdnJaW8sAeu8MFN04EOXKBwVmfQY=;
	b=kxEsyMiXpTSODrQa2xVP81+42YEgaR0gK59j7Pob/4JtEVZMV2w9bXcBhGEKXzt2EXOOK6
	dWlwml6+2Z9YzoMiyBlUSMl3HgC1T6XJ4d7dM/IPjzN6na6aaF9+O/oQ4l3d1/sllVumAZ
	bS0E+6RBRwwvGUiqoKa043L4Se+Am08=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G7sEQ+ar;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764977544; a=rsa-sha256;
	cv=none;
	b=RicNACYW8ps0B2Y5rXnmXlaUM/6IlGPqS59YQAzRv5SDN0Qc5N6OcDdajFQKCXocLW5THN
	p8uPVggWPZbWY94CIQFMpFuC4WpiDb1x8G4GhTUN/cMftFaaA07eLC2D0pQcbg9S76FNfH
	DjTnzZp/QPVV7eLkzT3c3L2gSPxw3u0=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6420c08f886so3073704d50.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 15:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764977543; x=1765582343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1bp6D5JTy++9hCcdnJaW8sAeu8MFN04EOXKBwVmfQY=;
        b=G7sEQ+aradIDMqk9Kv3z396qGci6HFM5KQcBjxMsYJ/K44NNYcdnA4nXIGXgxWmILJ
         OiQsvnA09a50iroswwlw06fpirrfWFy0lMjma2MKrCJLh1WajJqaeWzv46uw57oifXW2
         ZRBGjup+LnNa5mjx0d+UIatX5lYaC3r7FUK5s24QPlYDBJOmTctwVAzxp+BZSKIwGwJB
         8hlLzwF9BppZUDEpMdmWG0QNzupPtPNd2NWWKUwG4KyxSjw2q9Vr4Sp+Y1/bIblQk+QK
         dThxqYJzM265I5dJm2nnJmx0RFnouYb5a40iIKs0nNQ+FLPh3q/WwEdqZMigk8GY+ohF
         OLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977543; x=1765582343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q1bp6D5JTy++9hCcdnJaW8sAeu8MFN04EOXKBwVmfQY=;
        b=LsYAtYgRqTOYQLSGiKhU9rZcU9C74ZRv9HqIpclAGN8/3oGkQYmUVuHZJ+f0+TjL2N
         ZHUexF5gJFlTbhtWZznpsr6S7kgEZgAhtlJZkaOPPuiDUh+z9d9bJs6UbGmInQD9QqRH
         Y42zUfiG0/DbRgktFtFrVSLRc9avQnxDfXBX9gtmxLF+C2FNgc87JI0kd7e1/8/aM+ql
         gc0qWfAZu6Ws/7C7XhiTy35DdoVWGqDCGFHKgFq8wivZjgFH9Q2VWu3HO8KFay/aP42K
         4myR+tY+pyYX3nYlijXj86EsfEcgn1g0ZWLb7GVzfXDZElG14TKSDMTICmb+qnA2Nj/B
         9FRg==
X-Forwarded-Encrypted: i=1; AJvYcCV1kwi7fvVvUcL6buOBUsDcuw0jIjUyfPYn0pzJJZvxBhZsPItQeGUuD81rrouc91N4iU4dPvur7w==@kvack.org
X-Gm-Message-State: AOJu0YzPGlVyCNX3rGc6JDlyIepefRa+PE/nkMTByxY4iZHx7iHVEMzM
	zDx7bgDnuHTQP5KoLxYYLVBmmFdbirKySUFL6haMTNtueeR8bX3DspKA
X-Gm-Gg: ASbGnctlt3V6HKHqo80b7A3921UFhrXcRFYPXqN75NZ2FRb+CML7LKvMcaykWCQa+DY
	0LvP9gqJKz5BmHK3ppGT9ObPdK+v1H2aOfvdPPOR94o+T1+p5x0gTejEuvRDUhZCN3su9jhjFA9
	NFqxXE9W8EtpPxdLNTqtmh8oVFtHu4BH+Pm/6YtsQPv+4T6ybd6RojVE4GsmnJ8Oiil5rGhdllh
	3z+uNG5z/e6/TMdV3SgkkSWrtpIGi/m7UE1BQTl37Jw+RSsg8w6ThddqoDCTvIkNBVUwK0m7QEp
	0aa5UowAUxvV0XJehfgq2mEe/WfR24zxNcyyfGOum0UpXkn9tA8LyJufVN6uM4VxSMRydB95PuT
	xbS3PKPX7DtDm36lIRS72nhTLVORJQ3M6tMK2G7kAQWXsLtjKBNs3WMCFraOa5ep/t4qycmES0d
	8+ZSCz0j35ih0kKp748weyOg==
X-Google-Smtp-Source: AGHT+IHuiF3W+0+y+RHRuFqEDswx1eZLikuL04SAxFeBYl2SfNCvqWtSQJuYZ+6A9jLmPwXhNw08/g==
X-Received: by 2002:a05:690e:2554:b0:641:f5bc:68e5 with SMTP id 956f58d0204a3-6444e804d45mr461456d50.82.1764977543310;
        Fri, 05 Dec 2025 15:32:23 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4c::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6443f2b80casm2356687d50.9.2025.12.05.15.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:32:22 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: 
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org
Subject: [RFC LPC2025 PATCH 4/4] mm/vmscan: Deprecate zone_reclaim_mode
Date: Fri,  5 Dec 2025 15:32:15 -0800
Message-ID: <20251205233217.3344186-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
References: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7hhf5oouj93noowdh95y7hmj7x8ibjbo
X-Rspamd-Queue-Id: 5E9051C0013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764977544-376340
X-HE-Meta: U2FsdGVkX19jz5OejiacMf6wmPU/Ok34gdrpHaY5dNuNAWjqbCu7hPZN73pHZ29oUchDzk8kSMW2IBh1RspyJcP0s58aMfwwcjMe30Dx80pp7L7Irz35+GSCN0qD/ndS8uwuIfl6oTdl1Yt4mRtRKLnhuTjqwksu9gI9IW5yCrekUai14/amswhJZxEZM9wpwmUGQONCRoHu3muanTuPITK3y7W2F2xa8OrY/dCL8jzAaAkXfaATHoCnIKWQ/HYUew1pqK3/CUhdDQRfxAanzIX8NfOmWaieoXoe3IHXf5tQTNiRyJhBDEbdeqPhtz04zTlZ8PLHnK31/lZ2/nDKO02sWXDLJHVJIAKysUx+LVMTWE7hxKWVf1525J/yUko+J8adtJwaJwQ/Rt1G2fXPOaPWyUSRuxQe5I9EufHGnZfAtNuZysfIdC/HGDO3P7V6U3WsBCXj+U3AuF/1JhQ1qMVjpj85UkQ63LS10MG9btFF7LENxvVtV2DGNIkYjfCls2QH4iwcsfP4tbZP2TPwgmPx8xx48h/tKS0S1uH1EbK9PelQL2hjxVK2pDgyGIeB+1X5p3UtNcxn4XUZEUgnzvc7eIAH0jYhBQ/JILUSr//locEcucnDJSF8y+SX0rM2gGef6G6cAHOzHfiEnq3OOm97n7CN7GktdvKnDrRx55LCPRrJc7yMog3qAToCUaskFGEigpoRz8KfoKqJT4/BRCJmIYCdXiNNuNtwJcXe3maS/27AW7PWLuapkQazLbDaHliOImSZSzUgWiBVh/KtPYuLZGeBZ5SD4eoz5yxFOFAxWhTIUBZg06AIURmNbAMijCxBXzMzdZMhtV3/CcaI6iHA0vrCNvBnAhAh+M9UNhS3CxGecQlBnLKBM0ajqdY30Himks2NYmkG21Nhf6l0gJIY/gtquw7gDskplJDiPaXs4osm3TTuuDT6Wl6S0991IhkH7rKXjKlqRXCPEsU
 +bj1NRcS
 QFhKsDG3ZRX9reGQTLY2zJ3axD8bbo2OLnoN/ksSPZHUC8OOD2zrDBfbQXjZ11yxmGTFOlaGuGUw9TTVx7TjUGIDhauYRjop1rJ6K1+Sxt6Z+mtPQaHTsHYpVw1nObHS5d6ez8oglQ76dLWTOnJyflBMtR03F8OcehSN+Sm5wewC47xBTDaH00ZqZa89NWpTFzLQUraN9vt+K4/7Qi+rAMMYmtsEwjocWrMpdSLEhNZoGN2s/kMDKzfkFajjvCRMVKKg6d/JDnA2T04gVTLhmbPQTsdR3xK3X13vCKxD3C0YR13gPpOLznQeC/rUVVk2/WsYlvzOjLTHYRKT08Pb78Ap+79H5U0xlhTY0Vz3K32HmdvfwOqDwZGqMzUuzjSpph65EXTI4CfpdYpE+dzgEVgfm51PTqkG1iSBhOGDPaZ8nPkU4m9r4CCjDjOXT5spmILTZCD65LirvUG29xm0dInwOWFWRHBUPslW+UWzLvuZCk3mXijUsgSrMIcF97PJVGHuF/EvOaLnAnFnBc/tDjrBIMLOeq749EBQYUYmPRHaed1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zone_reclaim_mode was introduced in 2005 to work around the NUMA
penalties associated with allocating memory on remote nodes. It changed
the page allocator's behavior to prefer stalling and performing direct
reclaim locally over allocating on a remote node.

In 2014, zone_reclaim_mode was disabled by default, as it was deemed as
unsuitable for most workloads [1]. Since then, and especially since
2005, a lot has changed. NUMA penalties are lower than they used to
before, and we now have much more extensive infrastructure to control
NUMA spillage (NUMA balancing, memory.reclaim, tiering / promotion /
demotion). Together, these changes make remote memory access a much more
appealing alternative compared to stalling the system, when there might
be free memory in other nodes.

This is not to say that there are no workloads that perform better with
NUMA locality. However, zone_reclaim_mode is a system-wide setting that
makes this bet for all running workloads on the machine. Today, we have
many more alternatives that can provide more fine-grained control over
allocation strategy, such as mbind or set_mempolicy.

Deprecate zone_reclaim_mode in favor of modern alternatives, such as
NUMA balancing, membinding, and promotion/demotion mechanisms. This
improves code readability and maintainability, especially in the page
allocation code.

[1] Commit 4f9b16a64753 ("mm: disable zone_reclaim_mode by default")

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 41 -------------------------
 arch/powerpc/include/asm/topology.h     |  4 ---
 include/linux/topology.h                |  6 ----
 include/uapi/linux/mempolicy.h          | 14 ---------
 mm/internal.h                           | 11 -------
 mm/page_alloc.c                         |  4 +--
 mm/vmscan.c                             | 18 -----------
 7 files changed, 2 insertions(+), 96 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index ea2fd3feb9c6..635b16c1867e 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -76,7 +76,6 @@ Currently, these files are in /proc/sys/vm:
 - vfs_cache_pressure_denom
 - watermark_boost_factor
 - watermark_scale_factor
-- zone_reclaim_mode
 
 
 admin_reserve_kbytes
@@ -1046,43 +1045,3 @@ going to sleep prematurely (kswapd_low_wmark_hit_quickly) can indicate
 that the number of free pages kswapd maintains for latency reasons is
 too small for the allocation bursts occurring in the system. This knob
 can then be used to tune kswapd aggressiveness accordingly.
-
-
-zone_reclaim_mode
-=================
-
-Zone_reclaim_mode allows someone to set more or less aggressive approaches to
-reclaim memory when a zone runs out of memory. If it is set to zero then no
-zone reclaim occurs. Allocations will be satisfied from other zones / nodes
-in the system.
-
-This is value OR'ed together of
-
-=	===================================
-1	Zone reclaim on
-2	Zone reclaim writes dirty pages out
-4	Zone reclaim swaps pages
-=	===================================
-
-zone_reclaim_mode is disabled by default.  For file servers or workloads
-that benefit from having their data cached, zone_reclaim_mode should be
-left disabled as the caching effect is likely to be more important than
-data locality.
-
-Consider enabling one or more zone_reclaim mode bits if it's known that the
-workload is partitioned such that each partition fits within a NUMA node
-and that accessing remote memory would cause a measurable performance
-reduction.  The page allocator will take additional actions before
-allocating off node pages.
-
-Allowing zone reclaim to write out pages stops processes that are
-writing large amounts of data from dirtying pages on other nodes. Zone
-reclaim will write out dirty pages if a zone fills up and so effectively
-throttle the process. This may decrease the performance of a single process
-since it cannot use all of system memory to buffer the outgoing writes
-anymore but it preserve the memory on other nodes so that the performance
-of other processes running on other nodes will not be affected.
-
-Allowing regular swap effectively restricts allocations to the local
-node unless explicitly overridden by memory policies or cpuset
-configurations.
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index f19ca44512d1..49015b2b0d8d 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -10,10 +10,6 @@ struct drmem_lmb;
 
 #ifdef CONFIG_NUMA
 
-/*
- * If zone_reclaim_mode is enabled, a RECLAIM_DISTANCE of 10 will mean that
- * all zones on all nodes will be eligible for zone_reclaim().
- */
 #define RECLAIM_DISTANCE 10
 
 #include <asm/mmzone.h>
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 6575af39fd10..37018264ca1e 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -50,12 +50,6 @@ int arch_update_cpu_topology(void);
 #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
 #endif
 #ifndef RECLAIM_DISTANCE
-/*
- * If the distance between nodes in a system is larger than RECLAIM_DISTANCE
- * (in whatever arch specific measurement units returned by node_distance())
- * and node_reclaim_mode is enabled then the VM will only call node_reclaim()
- * on nodes within this distance.
- */
 #define RECLAIM_DISTANCE 30
 #endif
 
diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..194f922dad9b 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -65,18 +65,4 @@ enum {
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
-/*
- * Enabling zone reclaim means the page allocator will attempt to fulfill
- * the allocation request on the current node by triggering reclaim and
- * trying to shrink the current node.
- * Fallback allocations on the next candidates in the zonelist are considered
- * when reclaim fails to free up enough memory in the current node/zone.
- *
- * These bit locations are exposed in the vm.zone_reclaim_mode sysctl.
- * New bits are OK, but existing bits should not be changed.
- */
-#define RECLAIM_ZONE	(1<<0)	/* Enable zone reclaim */
-#define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
-#define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
-
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
diff --git a/mm/internal.h b/mm/internal.h
index 743fcebe53a8..a2df0bf3f458 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1197,24 +1197,13 @@ static inline void mminit_verify_zonelist(void)
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
 #ifdef CONFIG_NUMA
-extern int node_reclaim_mode;
-
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
-#define node_reclaim_mode 0
-
 static inline int find_next_best_node(int node, nodemask_t *used_node_mask)
 {
 	return NUMA_NO_NODE;
 }
 #endif
-
-static inline bool node_reclaim_enabled(void)
-{
-	/* Is any node_reclaim_mode bit set? */
-	return node_reclaim_mode & (RECLAIM_ZONE|RECLAIM_WRITE|RECLAIM_UNMAP);
-}
-
 /*
  * mm/memory-failure.c
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9524713c81b7..bf4faec4ebe6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3823,8 +3823,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		 * If kswapd is already active on a node, keep looking
 		 * for other nodes that might be idle. This can happen
 		 * if another process has NUMA bindings and is causing
-		 * kswapd wakeups on only some nodes. Avoid accidental
-		 * "node_reclaim_mode"-like behavior in this case.
+		 * kswapd wakeups on only some nodes. Avoid accidentally
+		 * overpressuring the local node when remote nodes are free.
 		 */
 		if (skip_kswapd_nodes &&
 		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4e23289efba4..f480a395df65 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7503,16 +7503,6 @@ static const struct ctl_table vmscan_sysctl_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO_HUNDRED,
 	},
-#ifdef CONFIG_NUMA
-	{
-		.procname	= "zone_reclaim_mode",
-		.data		= &node_reclaim_mode,
-		.maxlen		= sizeof(node_reclaim_mode),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	}
-#endif
 };
 
 static int __init kswapd_init(void)
@@ -7529,14 +7519,6 @@ static int __init kswapd_init(void)
 module_init(kswapd_init)
 
 #ifdef CONFIG_NUMA
-/*
- * Node reclaim mode
- *
- * If non-zero call node_reclaim when the number of free pages falls below
- * the watermarks.
- */
-int node_reclaim_mode __read_mostly;
-
 /*
  * Try to free up some pages from this node through reclaim.
  */
-- 
2.47.3

