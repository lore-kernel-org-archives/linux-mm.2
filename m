Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB81EE0AC8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 11:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC45D6B0089; Sat,  7 Feb 2026 06:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2DF6B0092; Sat,  7 Feb 2026 06:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA14A6B0093; Sat,  7 Feb 2026 06:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5E376B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 06:00:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 572211A0408
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 11:00:18 +0000 (UTC)
X-FDA: 84417366516.28.3CFAE8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 601D240015
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 11:00:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z8YMF7lX;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770462016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX0d67exb+AZ6leqopnxeLwbcjsvBuMxuY4RL9mmB2E=;
	b=l00visESyI+LA0slLsP89Xojin61YArGLutfc8J6Gl949bal7LlCQEygm8erfCYaiLbn+j
	YjaBE3MYzmVWuUdql1mY1LfqlEFQhw5olfcEtXcLKz4sh583JW1xixrVPA248wWDzbjEZL
	WsK7fkQhzEe+FUFZA3A+bPuLHlescl8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z8YMF7lX;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770462016; a=rsa-sha256;
	cv=none;
	b=vDPRPnFWq18nQTBN93VWagyQQlihievBzr0QB/n0R0SQz9M0jdpisUbqnxEWru9LOPXPER
	4NRIwchqR3zd3RsVWKMcbiY3u39jznkx9CkRUgHnSLr/dsFcMhDvJKkgU1gjOm5vyibvxO
	/GuDKslZTjXQWDqm+5K+RxA4OHo9J6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E6BE4064F;
	Sat,  7 Feb 2026 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C960C116D0;
	Sat,  7 Feb 2026 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770462015;
	bh=JR/vr35gWQK/eqvjEoWGX3aKmYc8KjUr0uV4fgg16NQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z8YMF7lXGqV3PRWaeyrrMuCWHofW7ufFSy8jb0sLNo+Z+0kaFzZGV9Tby6EqP0iD7
	 05snUkLCc+5gEq4dkj94ffqtSMNQyn/ljYmUvDdWDZe40GKQQkzdneemwZF3xUL/X9
	 CsHTD9F60rLgeaCF9wQTbeHRElMOxCnTdm/uS3nGQSfk478NcjfmOHGJKxwnqQyZrg
	 gHmjL2w/YauUoNaH24Z/pFhs6yQNFJriY2G+7g2I9Vp87CDZEJ86hQyU1s5/UF9hY0
	 kbwiPNYJ1Vif8gdVGe4W1Y+wYKQjjz60dKQnzMyiYiUI4Qwrpjy0viji55i5eojhvw
	 rwPY96hvTUteQ==
Message-ID: <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
Date: Sat, 7 Feb 2026 12:00:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260130163756.2674225-3-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 601D240015
X-Rspamd-Server: rspam07
X-Stat-Signature: cu1mjrc6q5jrbjswmfqzbggwwdkx79z1
X-HE-Tag: 1770462016-919868
X-HE-Meta: U2FsdGVkX18byEheiXdqOuIKb3LdpUlqdGQhNWLFzH7J2nwT3IcuryvIWpNXAYzJmjsKdYRvTdJejJgmeb5qbq4fjUQa70d8UBxg5c3u5fZcHtdTA0k5FWpCaEn1Ldas9v56mqVZGIXYY8wmMpRZPNfFaFEtpNaeJAG2QoQnSR4Ms1O8tzyuKAUxkjGsMrA5yxGqbNIxtQr1X7PCv3swiyL+UoCQmR7Mw42kK/Ur2xjFUnAwyy4o2lZMeLrb5/xePwtclUtNwFqY9k/Nf3tcEI/mIQEKPEn9uUnE4Zxxq2CY/vna6scXGavFuBuOUyTsBF78GVa5HZTX+GHi1bv/KuPvFngD6QRFR+p1rfeEbXAvb+wk5nkLmyCXh/DLy6+F4rvHxi4Axx2rjmNsflRdifTSU3CUwr3JIG9F5kuHVQ+pIvY/MCsMXevvQgdagXSsZpBYdJZnRI7lmEJYOiE2x7SheyPGjenI+7hqPJrOAHTL8dEdcLS1kO8vVHR/sAkJpxMeIyujN0+4+ukKu4YHgafyR542lpfeYSJHUiOZM+spRm+p0RZrz8AwTWqDIidd5DjN2em3oYHsn0gr8ZscGXJyXoi6V7PP4tvk6M8ikvZuRINZk7wvgHqjFGd5yomtKVipS0dWw/sHSta6SKRuTdW0wRaam+//HXGUU6YsdRMApjzRujuvIpIhkZEYwMAGW0ElGgF4HCXVHoTbYdcDsfkluYcPFoHr0dZDOigXb2UdvyPIlVggOgoNOM+4DsuuQCmOHRSLjD9CUf/F1mFSHejNH5SZuggQxjfJ3xSD8U8hYn5uD28874qI5jJdldpityvMKh0hPHuqU5MJafYSUlzo1iu/AJc/nBCfoWjaaENjhZaSU3SdSPC1qmuYYv41zSaNIDJhZ3TqEYn1uQf3c6DU8fLB0RwjUjbZ09pzWVI22rYbmDZnPI6zikDn4OsDvrZojb7bdsl/nB1Vjw7
 6uPriyrO
 +aCd1RqDBwbpPWS+yl+c+yXid1agYXmzP7VlM3G9RMVwXNKqFjU5V6sDyN8cUjDYsqok5ODPRV4haLrNh0ejJzT0/QVnSVfZr/RheLYb3XmCx1tPRiWmMgiulyk8eu+Tmke3BwibjE5IXYNRofLrLPcpm2GyTuPSf5tzVPrvisO7WIEJ0uDuFEP+aEw2j8EpNKnfYs1DOylzHEOpieczxsTwNrjdNZ8LN/kzeA/iknYvMpnq/AuLPkFsD1zaGcMWHPOjMXusQOTt1gvoYBglq3770cZ66y+6VElCSjjDQAUnQlR6ZumLGsjMDkoKuVBel1AU3BCTbAlAQLmjO9JqeMrlxe2igrb9AZq7GSM5zd34yUnyM7srxP3pyo//hPBGEyHpeHLiIFXJE71whLXBQERezUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 17:37, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
> 
> Add fast paths to quickly detect cases where zone is definitely not
> contiguous without scanning the new zone. The cases are: when the new range
> did not overlap with previous range, the contiguous should be false; if the
> new range adjacent with the previous range, just need to check the new
> range; if the new added pages could not fill the hole of previous zone, the
> contiguous should be false.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      6s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      34s      |      6s      |       82%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>      object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 256G/512G (Plug Memory)
>      qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>      Guest Kernel : v6.18-rc2
>      Qemu         : v9.0.0
> 
>      Launch VM    :
>      qemu-system-x86_64 -accel kvm -cpu host \
>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>      -drive file=./seed.img,format=raw,if=virtio \
>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>      -m 2G,slots=10,maxmem=2052472M \
>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>      -nographic -machine q35 \
>      -nic user,hostfwd=tcp::3000-:22
> 
>      Guest kernel auto-onlines newly added memory blocks:
>      echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>      memory is recognized.
> 
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---

Thanks for all your work on this and sorry for being slower with
review the last month.

While I was in the shower I was thinking about how much I hate
zone->contiguous + the pageblock walking, and how we could just get
rid of it.

You know, just what you do while having a relaxing shower.


And I was wondering:

(a) in which case would we have zone_spanned_pages == zone_present_pages
and the zone *not* being contiguous? I assume this just cannot happen,
otherwise BUG.

(b) in which case would we have zone_spanned_pages != zone_present_pages
and the zone *being* contiguous? I assume in some cases where we have small
holes within a pageblock?


Reading the doc of __pageblock_pfn_to_page(), there are some weird
scenarios with holes in pageblocks.



I.e., on my notebook I have

$ cat /proc/zoneinfo  | grep -E "Node|spanned|present"
Node 0, zone      DMA
         spanned  4095
         present  3999
Node 0, zone    DMA32
         spanned  1044480
         present  439600
Node 0, zone   Normal
         spanned  7798784
         present  7798784
Node 0, zone  Movable
         spanned  0
         present  0
Node 0, zone   Device
         spanned  0
         present  0


For the most important zone regarding compaction, ZONE_NORMAL, it would be good enough.

We certainly don't care about detecting contigous for the DMA zone. For DMA32, I would suspect
that it is not detected as contigous either way, because the holes are just way too large?


So we could maybe do (completely untested):


 From 69093e5811b532812fde52b55a42dcb24d6e09dd Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 7 Feb 2026 11:45:21 +0100
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
  include/linux/mmzone.h | 25 +++++++++++++++++++++++--
  mm/internal.h          |  8 +-------
  mm/memory_hotplug.c    | 11 +----------
  mm/mm_init.c           | 25 -------------------------
  4 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fc5d6c88d2f0..7c80df343cfd 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1051,8 +1051,6 @@ struct zone {
  	bool			compact_blockskip_flush;
  #endif
  
-	bool			contiguous;
-
  	CACHELINE_PADDING(_pad3_);
  	/* Zone statistics */
  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
@@ -1124,6 +1122,29 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
  	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
  }
  
+/**
+ * zone_is_contiguous - test whether a zone is contiguous
+ * @zone: the zone to test.
+ *
+ * In a contigous zone, it is valid to call pfn_to_page() on any pfn in the
+ * spanned zone without requiting pfn_valid() or pfn_to_online_page() checks.
+ *
+ * Returns: true if contiguous, otherwise false.
+ */
+static inline bool zone_is_contiguous(const struct zone *zone)
+{
+	/*
+	 * TODO: do we care about weird races? We could protect using a
+	 * seqcount or sth. like that (zone_span_seqbegin etc).
+	 *
+	 * Concurrent hotplug is not an issue. But likely the caller must
+	 * protect against concurrent hotunplug already? We should definitely
+	 * read these values through READ_ONCE and update them through
+	 * WRITE_ONCE().
+	 */
+	return zone->spanned_pages == zone->present_pages;
+}
+
  static inline bool zone_is_initialized(const struct zone *zone)
  {
  	return zone->initialized;
diff --git a/mm/internal.h b/mm/internal.h
index f35dbcf99a86..6062f9b8ee62 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -716,21 +716,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
  				unsigned long end_pfn, struct zone *zone)
  {
-	if (zone->contiguous)
+	if (zone_is_contiguous(zone))
  		return pfn_to_page(start_pfn);
  
  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
  }
  
-void set_zone_contiguous(struct zone *zone);
  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
  			   unsigned long nr_pages);
  
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
  extern int __isolate_free_page(struct page *page, unsigned int order);
  extern void __putback_isolated_page(struct page *page, unsigned int order,
  				    int mt);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..790a8839b5d8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
  
  	/*
  	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
-	 * we will not try to shrink the zones - which is okay as
-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 * we will not try to shrink the zones.
  	 */
  	if (zone_is_zone_device(zone))
  		return;
  
-	clear_zone_contiguous(zone);
-
  	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
  	update_pgdat_span(pgdat);
-
-	set_zone_contiguous(zone);
  }
  
  /**
@@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
  	struct pglist_data *pgdat = zone->zone_pgdat;
  	int nid = pgdat->node_id;
  
-	clear_zone_contiguous(zone);
-
  	if (zone_is_empty(zone))
  		init_currently_empty_zone(zone, start_pfn, nr_pages);
  	resize_zone_range(zone, start_pfn, nr_pages);
@@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
  			 MEMINIT_HOTPLUG, altmap, migratetype,
  			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
  }
  
  struct auto_movable_stats {
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2a809cd8e7fa..78115fb5808b 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2263,28 +2263,6 @@ void __init init_cma_pageblock(struct page *page)
  }
  #endif
  
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-
-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
-			block_start_pfn = block_end_pfn,
-			 block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					     block_end_pfn, zone))
-			return;
-		cond_resched();
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
  /*
   * Check if a PFN range intersects multiple zones on one or more
   * NUMA nodes. Specify the @nid argument if it is known that this
@@ -2347,9 +2325,6 @@ void __init page_alloc_init_late(void)
  	for_each_node_state(nid, N_MEMORY)
  		shuffle_free_memory(NODE_DATA(nid));
  
-	for_each_populated_zone(zone)
-		set_zone_contiguous(zone);
-
  	/* Initialize page ext after all struct pages are initialized. */
  	if (deferred_struct_pages)
  		page_ext_init();
-- 
2.43.0



If we would want to cover the cases with "holes in zone, but there is a struct page and it's
assigned to the zone", all we would have to do is manually track them (during boot only,
cannot happen during memory hotplug) in zone->absent pages. That value would never change.

Then we would have instead:

static inline bool zone_is_contiguous(const struct zone *zone)
{
	return zone->spanned_pages == zone->present_pages + zone->absent_pages;
}


I don't think we could just use "absent" as calculated in calculate_node_totalpages,
because I assume it could include "too many" things, not just these holes in pageblocks.


At least reading zone_absent_pages_in_node(), likely the value could return
* Pages that will not have a struct page in case of larger holes
* mirrored_kernelcore oddities

We'd need a reliably "absent pages that have a struct page that belongs to this zone".

Maybe Mike knows how to easily obtain that there to just set zone->absent_pages.

If we really need that optimization for these cases.

-- 
Cheers,

David

