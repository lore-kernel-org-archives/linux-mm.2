Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22008EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83BDC6B00C8; Wed, 25 Feb 2026 02:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826846B00CA; Wed, 25 Feb 2026 02:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB966B00CB; Wed, 25 Feb 2026 02:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5997F6B00C8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:56:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 194171B6E89
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:11 +0000 (UTC)
X-FDA: 84482220942.08.98A09D9
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 631CB40010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L+YS4KV8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006169; a=rsa-sha256;
	cv=none;
	b=HKtMvICIpFJl9fWKIYbqsf0mAeW7QTtMxTMtPohtwz4HidNvp/AjSPfWPbPqh1FEXHl+FX
	T6VhsgcYI+eH6GIIpsnTKpPudXWZ0F3hdG8CM/0kIBWDlL4/uiQp125oQRRQ3VMyhwqTB3
	KTgFuGzbKhINkw/qy7sJmJ7Duchv1Qk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L+YS4KV8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AoaAnBbgsYhG9W1u4+1KzMV1vTbFtNuDB1KSaR3wOM=;
	b=yKAYVtQPqaFSdg+UFqITCfapJTr4s8sR9HSJGGGMvF2ljWALRO8b31ct5Gl2WkpqvlyBGI
	008jxqP8nkvJBaun/WrICCqOm1JUCULXxWjuyFhhYdUgeJVxwV0iF8ZItWH0+wcuPl+193
	yU6+Pz+bdp6AQwpD5B0qoViBlffRFoI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1AoaAnBbgsYhG9W1u4+1KzMV1vTbFtNuDB1KSaR3wOM=;
	b=L+YS4KV8J6CG30cbEUTbgZPtn2Qvmsnvy7e92wBxgBxOLws5u9CYgL2aMUjNpsbdCwodhE
	RHJydHzbA3e2oRsDbuEnsXDBM8Ly4lk0InbW93ldb3hPvoQP1d5TWsnIc+VzCU+iwmucAq
	IA4DuOx1dYoitp+SLdwYX/Ao0qemnGs=
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
Subject: [PATCH v5 28/32] mm: workingset: use lruvec_lru_size() to get the number of lru pages
Date: Wed, 25 Feb 2026 15:53:11 +0800
Message-ID: <b1d448c667a8fb377c3390d9aba43bdb7e4d5739.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: w317a6k8tcdywi1rpaj3hk3uapmudhip
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 631CB40010
X-HE-Tag: 1772006169-517239
X-HE-Meta: U2FsdGVkX1/P1U5z18vjbufKzS9JTVT9PFZYQpmiADQLmfkwoiARIRUXadz6BzEHPFojdkEMa2PemPGJkIkN9UV2elVVz/X5FoUgDA64EfSrI7V/2CDd5BFwn2f6EbQUt+EaMG6Qau32ct7ZllkbHi3QDXAISYVlQsfVckiofAKrHKdcCFece52gpI+qwsYaXqbrOlsSt0uMJozIhEkwSnJ2FFMPCgucxUvj9aACw9Nc2IhjyfjWR0onmaaBoIvyqm5JCZYXhwYUBVp/ExxWzsYAgELOf5t6NkXy/JCT4olxDNpgfJ8Dq+vKkd+03AxD/Y+tN4AfTlZEc+s8Cgw2K8Z6TwpV6A/Ed2gEHeQwO55D6K0/DtUzxTZIqqh3uQba+Cc/VG5V/hvKaa60+V35XcBs5NGCBe71H50fQRGAN6OXjpD/CP+C9AbgCmOsEtQn2tZrr8CrVZpwcaGtJedMbYvWrCCLR/fG6uQFotDFEQ1jYkujhBEyMWUut/2h9yFWXtKU2QmzisNh5AqfaUTmSOFIAPN4eRqTlcAVaxyRtY8xNnDdv/xxJB/nO57tGlRyzrI2gqeeryBGBnDGgodV2wIK76Pll40ixC8eV/PNqQ62gVubJ9cY7F8jzTW+5zR+Ej1Ky3guxdasVoUJIJmBEehhgK5tRKihlObAzwG4Mq84I/m8PZh1CQqyBmOK8TUq1kj4Bq5zTxwvGQztAJcTNcaRA8DyYKpNBQnlVZEJnnpALht8qN/0kj5WVDI0namhP2DAQDriW4EApJ0ojRCoNoIWHRJbcr6Bil8fHnluWd8er0QufvAri4Df16ZnsBckVAij08mhmh1ZxCr2toBVnaQ6U4vmB2AnxDQWEdFkB7xuEaRmePbYp+rl8pECUGXUTcFyAPOcKt7ebxKk+aYNJhm/efnLMR69ZevLNS/080233hogB9JZ6V6/XhybiNpwceq/CG8uiI3ODdy+E0l
 d+8UiPHQ
 NeEwdcix3Xv/2G9eO1foB+mD1nmJNWvk8AKQ+uUuYgnZiDQJpH0qQLZ7Nq1S4ejYi7Hc50yW5EvpzL4d2qfvEi3/MqDLXxtoj5AA142vH6/jQO2OKfDD7UU1r7IofmMD386AzAf2QNCirBFx1x4s2Xl+sZrT7P4Zhi7kZ5TtJBCzbopsGHoZeGyzxxuhQq1+cF9lSKG2dUjoREl/4xiD7EF0rD2lsNTFE5QuLDw2bwQJMgV5TkH9kZvMoLu2XMp3L6z+5m37iIvUhVP8=
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


