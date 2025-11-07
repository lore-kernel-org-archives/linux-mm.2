Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8A4CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB57F8E0025; Fri,  7 Nov 2025 17:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E638E8E0006; Fri,  7 Nov 2025 17:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07178E0025; Fri,  7 Nov 2025 17:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBC378E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E12413B7A0
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:15 +0000 (UTC)
X-FDA: 84085305990.14.7FC51D1
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 861B24000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qYRQaBDw;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R64FiI16+WP3yeCxBiatrBL599beZnZfURxXJrYPjuA=;
	b=2clTe0EHQW388QkjYVltdTLNmc8ra9NwsmWv7+L4tkgnAGZs/NiS9h7+zeJ2vyFftxQ4dh
	Q/wd8e1yE3n1/vqDFlHydwzzUQdBPIOY+KJ357pY7OxZaW2u7/elIVQKFGHajl4WoGiqmD
	nM93tsH8jwyM1DQkloF1cSyqQQZgVJE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qYRQaBDw;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555813; a=rsa-sha256;
	cv=none;
	b=pMdIx7Urmc9Hv7CWBg6O071SOMjR6VPo2SrPL/ikJMsRNgDIvxvEhZV2szjTsB7cTeW/aA
	g8lOK/k+65MprDU0C7agt+abbyIGHjfPl1php1eIZg1Mbi+PjeENo2kWDx+t9K1MpAEKXk
	JSYu7xsYMBY9X4Kr6miGvaLm9xynFo8=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8804f840579so18844346d6.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555812; x=1763160612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R64FiI16+WP3yeCxBiatrBL599beZnZfURxXJrYPjuA=;
        b=qYRQaBDwkTImu9+DSGAtfDdavazGwond90ImOp1PjOo09z0ND5gwK2VheIlZutAuuI
         W2xpI8l5mtXk2yjVDd0jl538m4CpRYlYTD4EjZhlUjrGgfOKbD1UjeSyvxkkcpD4qNdR
         u3FXGroB2bN3ZKCnpvgagL8anXdaOtTDI586IcX8CzzB9EPDcnGq5VIqXFzGlUUTYFCM
         Hf9T2ce1OiFHrj44BuZMMCzYQodD7IM46zzamxMgDePrpCaYdc8KnURjCnsjSZbiwerC
         5juQLplR+GiGothMgx1DhAlLgUUI2DzMgy04FA9ajmzKzdhCbscZGDbhyQT/Byn9F0nc
         q/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555812; x=1763160612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R64FiI16+WP3yeCxBiatrBL599beZnZfURxXJrYPjuA=;
        b=DB0dAmaLjVt/lGkpBC7+F/dYbee9neg9eZ8MZXLN9TqiXB3JC69vQrN2cemWQUlBYa
         1REmEgnfVS5g2X+PtXoZb1jjAFSfAqh9nyimVxqUhqxuxeFMWUGLPY2srsHfFu/hBQPR
         6T2TwyRpadjAKO72I+2SgElvZjGGf6EkMS+Y0TzH3wbU4VHpYJALVUuAXoVLw5+6CkUO
         ZKmRtQIiO2/yr7dNRx7M7S3EsTNLWID2Mios7ZxqYtdlH5g2JDRqoXpiidGOPumsgE/u
         hDdJJfw399wVhP3o68jCO3Pzrh93Kt64fu//RgzKeAxwfItImiwmCXqpi1782augPAyx
         6+8Q==
X-Gm-Message-State: AOJu0YyNJm1wiwbeqoI6TxJEGFkGJ8YjyCwjabna+uUbMB0ycAyg293i
	iMY1HDntqKnlqTllJ066fEgEl379KbM9b+D9MUyBu2RHrJi3zdT2fY8D1RCVbnaEVmoP5+JoLMi
	mXVol
X-Gm-Gg: ASbGncurVo5/ilTBaiH6J1AZEV7hvUv6DI4UG7FUjT6+jiXCg3/m8OlrbZE9IlmYQnu
	Qq0CICsVxO8cB8A8jpx7UrC07Svp1JIaMRomttlBl/bxNqY6lLFHx25ZIfggar4fV3hhx7JQJbX
	TdE1L1PH71BrlHPmhyqz6fM8ro1+IGh/zyANGBQ/On5R0e0MEkrs97uNUy5+KmEz4i/cwtk159w
	O+oKELWooeQ2JA3O0HUWHNhxOBfVjPrbMRPcm7LX2trXlRy8nEuf0GhatqLymBMkaN4nSrT3ocr
	bdgChXJg3r1V/kJyfyMUuA3Grn/7taaCI+G50ovKJOHZn9o5SBywoP7ellANJuXKt2I7ZR0UF2K
	eYzX/rhOXGsDoo8uTknnSo2qYA07qIuqFKVW64e4coPmXxgjLh404GNR7DBmlPAcR/x3P5NT5cG
	TqCl0EvRXaK2O5fcivmGuQWBuAtWoB/aXO5fqlcv7IZROrElaz3WfMKJX1ZIhsGwUeW6K3gYmor
	hLaNY126lteAg==
X-Google-Smtp-Source: AGHT+IG4CM60aE94hoVAm6WlLLrQN78GzB6+sZgYXWXWNkYKc0tId9Jl3T1QS1663TlSzExe8IcNow==
X-Received: by 2002:a05:6214:20eb:b0:882:36d3:2c60 with SMTP id 6a1803df08f44-88238616f43mr9660116d6.19.1762555812276;
        Fri, 07 Nov 2025 14:50:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:11 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH 3/9] mm: default slub, oom_kill, compaction, and page_alloc to sysram
Date: Fri,  7 Nov 2025 17:49:48 -0500
Message-ID: <20251107224956.477056-4-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 861B24000F
X-Stat-Signature: 9f9y9yrrg6zbjgbzugps7noqc4zitcf6
X-Rspam-User: 
X-HE-Tag: 1762555813-892361
X-HE-Meta: U2FsdGVkX1/URqXhwTsLaqPFc44ewph2tGZAVwlTed6xPis6VV0fa7o5UIEjpTsMosDQsBj1r0S7YmExxlll9EnnwD3I+r80JxZrayhCSwP7o/z0fPNUrcokV4kEhXlV2C5AS33tHZle3XKnzZUYtF5rt2kZ8HWJxoTbZ5XdpQEOH03c4aBFmioJZlWIai2whQyeS0Ig4WDkVXylEsLAUS4M1u3VT2oJbK2W3yLPiMDX7owGsIYWlIKg8abEBx51Zq37Nl9uFiffndBpiznd5iUjChwCGtYp1bGc7AyOdHRZS685MoeiJu0Be1OeAS8UdX8sWyqUzvrLb5xTNffYxn4pb2RNN5uPTjakrtHJ0Vg38TYh0viDCMRimzs6aWOuyLV4vCKEQ9b/reVe5u9x5s7wM/U9+gLvHT8njq02vK8kvpvswr+eH5iIm4zhs3bCQDPblT4ZI+RYYj6pocSjrwCLor+7D2gmFs7OP64RbK+DkxlXBDRM2a9pqZnJEaOp/yjqnJldW2VwlRRTaQBDNIFu1Wa1WhOtAwU1hGDTj5gMcaNpzwY7OJphOi5w4GqS5YwVBj3KaBCg60PS30pwmOsCIuykAL0VQHxFY+RZHZfTq+IJKpUYdpjTlchy33d4SnSW8TKOZNJZ2Lyi1ViPlzmkQh63j5+dwt2siG4pqx15iNBgYqhDZkEyur09EIXzsQvC9EQmrOnzeQcu6O2j13e/y3KWIbdt2FABwGitZFGaBEsK7Ps1ZroSDRG4kUgzPIiGx8hE5Fw2pex2CzviQ69RhrMhA/H0Y1p+YRVr0Gcc8/Yl9AuU81Ylghb7shqCEe+Jm+zvd/G/G+3GqG4PT/NbrkR0bXR6TNXaFfI900qiXMl+/Ga8tAOmWr+e4an9T5hJDcSw/Jg00KDJZew0ubOylSNi3EV5+AGE6X0J/LQW5MMIHrk8g4R5jBR6KDjGNUHtUAHIsu4XtdWFZYw
 0lhdHge/
 QaEJWignuTYE4Ki+Eef0oXMxsctRgeaSO7xqvBOgUkM4neIPd4LOEqjiSF+6pFfpVS0Ci7+2erxHdVry0qzmECXTiPsecq9H4tcxmXzq1G8SRYwDlF42QQ3zlN6ooTGKglBDaLOuIQ4D0w0QpFqjZ+EIYcVZq7FfpoAdq1uneO5+Zkplta7Ne+yFk/gfN8ABWzw3dO5TiTWgaSTgctYojqg5fgdpeY1DVqweTVgAUXK4KXKWk2fgMOi9rxCR92NZAFVpSL35jjJMTZAf84JLtwhTPzAANN8+QZo0AODMZXY7PrdycZAHJbaMyRH13YVOw3+wpfKwetPaMw0P+9xosgFEv2XEbZii718iSfkYSKlGiCrPq62iJP3TyvFF2G6/pbxIpHSkWrK/MuxQB/CoeP67644geOazlJzU/IslK8LfzwhR9tEsmLLof23/4HNdPnwkjlVw2Piqwjug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Constrain core users of nodemasks to the default_sysram_nodemask,
which is guaranteed to either be NULL or contain the set of nodes
with sysram memory blocks.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/oom_kill.c   |  5 ++++-
 mm/page_alloc.c | 12 ++++++++----
 mm/slub.c       |  4 +++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c145b0feecc1..e0b6137835b2 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -34,6 +34,7 @@
 #include <linux/export.h>
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
+#include <linux/memory-tiers.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
@@ -1118,6 +1119,8 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
+	if (!oc->nodemask)
+		oc->nodemask = default_sysram_nodes;
 
 	if (oom_killer_disabled)
 		return false;
@@ -1154,7 +1157,7 @@ bool out_of_memory(struct oom_control *oc)
 	 */
 	oc->constraint = constrained_alloc(oc);
 	if (oc->constraint != CONSTRAINT_MEMORY_POLICY)
-		oc->nodemask = NULL;
+		oc->nodemask = default_sysram_nodes;
 	check_panic_on_oom(oc);
 
 	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fd5401fb5e00..18213eacf974 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -34,6 +34,7 @@
 #include <linux/cpuset.h>
 #include <linux/pagevec.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memory-tiers.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
@@ -4610,7 +4611,7 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	 */
 	if (cpusets_enabled() && ac->nodemask &&
 			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
-		ac->nodemask = NULL;
+		ac->nodemask = default_sysram_nodes;
 		return true;
 	}
 
@@ -4794,7 +4795,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * user oriented.
 	 */
 	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
-		ac->nodemask = NULL;
+		ac->nodemask = default_sysram_nodes;
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
 	}
@@ -4946,7 +4947,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
-	}
+	} else if (!ac->nodemask) /* sysram_nodes may be NULL during __init */
+		ac->nodemask = default_sysram_nodes;
 
 	might_alloc(gfp_mask);
 
@@ -5190,8 +5192,10 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	/*
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
+	 *
+	 * If not set, default to sysram nodes.
 	 */
-	ac.nodemask = nodemask;
+	ac.nodemask = nodemask ? nodemask : default_sysram_nodes;
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
diff --git a/mm/slub.c b/mm/slub.c
index d4367f25b20d..b8358a961c4c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
+#include <linux/memory-tiers.h>
 #include <linux/ctype.h>
 #include <linux/stackdepot.h>
 #include <linux/debugobjects.h>
@@ -3570,7 +3571,8 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
 		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
-		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+		for_each_zone_zonelist_nodemask(zone, z, zonelist, highest_zoneidx,
+						default_sysram_nodes) {
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
-- 
2.51.1


