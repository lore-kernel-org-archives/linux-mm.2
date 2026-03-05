Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF352F30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021BC6B00C7; Thu,  5 Mar 2026 06:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38016B00C9; Thu,  5 Mar 2026 06:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57596B00CA; Thu,  5 Mar 2026 06:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D45616B00C7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:59:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 940271CAD9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:12 +0000 (UTC)
X-FDA: 84511863744.19.74B894D
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE16540011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:59:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LgKIJi1D;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AoaAnBbgsYhG9W1u4+1KzMV1vTbFtNuDB1KSaR3wOM=;
	b=qepH/3S3mPAnc8bqFGToUo/lMLcMSrg0D8z1UiijzT3B7poBiUGyNtK1NXqfNugOElE5F5
	qwPxk3/yoReBDt3bXeF7mjHj1kYnRG1//jF+vTaA5rfI8krTrMMGv0x5siXbO2bY4qM/XM
	DwOabai8TPFTQp5GNcZScGa8BeOD4WQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LgKIJi1D;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711951; a=rsa-sha256;
	cv=none;
	b=IgWkIbw9NeUuhBftIH2jODgp8aNuhFJgtmZZimSDBibbI0+/ibMWvym3eLtCbYXsYdWRCT
	2pjr/txh+kqWo8R+/V8qeX0ShAxtkJZK6+s+8naDlXKmVbo0yyONoR6ZTSvT3G6rBG4ATj
	B6LCmBDu7GDQODTihr7xRVEgkdSQGC0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1AoaAnBbgsYhG9W1u4+1KzMV1vTbFtNuDB1KSaR3wOM=;
	b=LgKIJi1DWuIE/xjcn6z9kiBAWJ6togT5O+WwgW7ZnZ2O5s04jq3seB7SiC/hZozI4rml5D
	hg0OBDuPhSDbcZop5d/825FrUJwpKspB+z+CjqVjZWwH7/Obz5iSlQ69ZaY7JRLVXyUrNY
	n5mC+uHSvROGnoU/9AyCNzNaagktUG4=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 28/33] mm: workingset: use lruvec_lru_size() to get the number of lru pages
Date: Thu,  5 Mar 2026 19:52:46 +0800
Message-ID: <b1d448c667a8fb377c3390d9aba43bdb7e4d5739.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE16540011
X-Stat-Signature: cn15okqs4xiy8y489kdkz9hnhj65tsc4
X-Rspam-User: 
X-HE-Tag: 1772711950-684999
X-HE-Meta: U2FsdGVkX191RJA54XkDz1HwcE5BZvYIwS/R6G50+mTBe7jiY3vjnqwdzrcYwTqa9we00dWwd0pYw+Sj0N8YFRkCkupankp4M0MfPdrYH4c3WQ1nBb73JphvTd0CQAM27LkctHIaJ6iOQV+IJSNrniFJ/NxMx9n8gznaNSqE4RfQioaVQ8ffYiCsh3mRpbRWopemv4hX81RQGYmJxcZq3OCDh8ZeovI2rMRK0Uw8+2VkF26LVj6rjmauYVXSgojBvm6U2XY4STpEwWM7RxaJ3zHfu0a1FnfS9N6RYhpvxEakF0OGcb8CPYMmFfwFghu25NDH0f8TxpMKVwCdMjgqeBHmVJVIXUhb419OKWl49VegSMKVJWnn+p+L3ex4zqIxNBkaES/vb5u9xku1akv1AaQzCt6NHgrhYVz1rvdzzIopcuCtxGoCSo9iZL8SJEbRXTsDff0DjQ7iueuxv1Tv/0isQk495Me6+zxtQ9Vt0vT7gTnfcLVy1sF6M83ivdYZUS6TL2ui/0KHZfzEKXqA2KkBehUS8wmzW5MgUdl4Hi+u32ipKgGJOSpzaKecE/7VorT5pvrMkVaGan2ytteve3C0cuDRNEWOoNB/XGGVsn8w88gKJRYldoOqZ/BZttGX6t6CZTgtpf53SyXEJDC+OldCGP1hKxbXAUYkhn3niKn/a5BxwV4pJHnqiMv+7a6+MJJq9coVBGqwBEqot1+8VB4CZlNc1CPoze1d9A2TqkWQ2lRIfT7RlIlgZ3fpvC5jBoekHBpP9rQC+YmXHH7zVecvk+v02pBuazQQ+PJGAvlbSLpX4FnJux7EmuSY8uWdrv9kcuFlQfrxfZS8aqktczcCfQgtWRjBiILGeFPfBtl14OD8LoSqvFFrFIdAbIeWOPiMPfir3rEgqvkoPkEeo87ib4O1XKS47TA3LuEGKDrhjJ/IiNI4eOdJge5zs7Fcmtl5jzuX5xdcOnTyc0x
 7dKbaoh2
 yfpXXHeNEUvcooUedejnxDjgI21grOabMSt+W2Djdin7b/0044WT1YEGuadBapeu7mu1r7BxNrbX5oF9O4m6utOvSgv7fU134PPwZgHxeCsNZEN1JZ4xmT327HRe61ezAVVAynQ1v6CdRDlQA1O1qQC9w08tq51zL729sY10Jf04N0VcyNn+Y5WoQQ/4fifVcqK7EXOrXWs43SU0c49KRkP/1AULy7LaW/xOSVK9AkzEjEPOm3R1OccD/P11o9E/9Ek6dnWA//9y0LNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

For cgroup v2, count_shadow_nodes() is the only place to read
non-hierarchical stats (lruvec_stats->state_local). To avoid the need to
consider cgroup v2 during subsequent non-hierarchical stats reparenting,
use lruvec_lru_size() instead of lruvec_page_state_local() to get the
number of lru pages.

For NR_SLAB_RECLAIMABLE_B and NR_SLAB_UNRECLAIMABLE_B cases, it appears
that the statistics here have already been problematic for a while since
slab pages have been reparented. So just ignore it for now.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 include/linux/swap.h | 1 +
 mm/vmscan.c          | 3 +--
 mm/workingset.c      | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 64af9462ae8af..9d0e292875398 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -354,6 +354,7 @@ extern void swap_setup(void);
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fb81fb7985e2..7f9f66e0b40e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -390,8 +390,7 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
  * @lru: lru to use
  * @zone_idx: zones to consider (use MAX_NR_ZONES - 1 for the whole LRU list)
  */
-static unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				     int zone_idx)
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
 	unsigned long size = 0;
 	int zid;
diff --git a/mm/workingset.c b/mm/workingset.c
index 95d722a452e1c..07e6836d05020 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -691,9 +691,10 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
+
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_page_state_local(lruvec,
-							 NR_LRU_BASE + i);
+			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
+
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.20.1


