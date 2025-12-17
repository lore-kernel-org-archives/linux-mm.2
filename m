Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17077D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4246B00A7; Wed, 17 Dec 2025 02:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACFF6B00A9; Wed, 17 Dec 2025 02:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE796B00AA; Wed, 17 Dec 2025 02:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 571716B00A7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:31:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F939140929
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:46 +0000 (UTC)
X-FDA: 84228143412.22.1222485
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7575040013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:31:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rcM1irid;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956704; a=rsa-sha256;
	cv=none;
	b=DFjl2O3pWP2ZE/QcM1Rb/AJDikaLPIQ39J8khDv9N/+kWgy4QL5fzzpgX+KWLOzn6qiQhG
	G2f7RWW90dwDIyfNLyXnHDAiLC+EQ/7SnfIoJYNpcdFVfLI0fv3cKUrFttOZBxN6DlKipt
	vBIbe+fnC//BjdKI7DddSyU8YJOpm3c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rcM1irid;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/RC2JaZfQWnRGhHEhR7EU7DG2VrpSmCFoSBZ0fAAxk=;
	b=2all9+Y9J9rahgdLMQOpMNI0Lfl49JYQa/Fo+uvwmb3Y0nnEzHWD0GtQKTEFzQhx5L1TUA
	PMnqnHL/i070L1p32k820NN21dGafIIxejwGxeNPrOKYySVwOGr2wAA+QUIVibhvvAhpSf
	gzd/EU6/B5csMYu2/URHFcbn1tkmvjQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/RC2JaZfQWnRGhHEhR7EU7DG2VrpSmCFoSBZ0fAAxk=;
	b=rcM1irid7iZhLEiyC31dWf7GEZg2x6QnaCq8514+s+TRHJjJRBt5XX0VjwPoXWf4b870kM
	gF5CmOgkGe+CAHQ+l47v+XRNjSHJHKl4eleD+t4cE2jzU/bol8kuSG/q/eFSE/KS5KSEvx
	XfQohA5II8VscYDtO1EgTJmoLnFVmII=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 14/28] mm: mglru: prevent memory cgroup release in mglru
Date: Wed, 17 Dec 2025 15:27:38 +0800
Message-ID: <ab60b720d6aef1069038bc4c52d371fb57eaa6e8.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7575040013
X-Stat-Signature: a8jnf577yt1oifwbc3n8374ydwuuazf7
X-HE-Tag: 1765956704-678893
X-HE-Meta: U2FsdGVkX19e6ZrkjFKp1R+zO4xwMmKlvH1vwug9I013aGgjGWDIGtxdVjJozLUDgYTNi2LQWtnrynJGLyWSWmxJd2itu59A1uCdV/1LQO/q+eX3obq59b6lazfdA9SjjuSWCVlCXV3x8VLng3+h5+TsZQZNXke0K8oSHrbhG6Y0YNwefLMotPmAEpU3KbmrGdoJGisGcxr4QxgYn/oFgNB8PPVzazNQQ7rB0b5zqD48YVVhQwu7ZTOODuCNVKLSFMh7s3B00d4zei2EdpQXA+Yj2MeKdAvVr+6Fv9xJRqBrDqCEYe6rnPkrse4YtbLd4z4ZmG+zh+UvqKElyE2DucSXJvNhGt2kUYzeb/Ms1YBKsW9B2UZzSeTPCOCPJNGTyvq1ftgbEE8YELyWBqWa0xfutuLxOb3j7/nS8m3kMdoTufyYN4gsGlt34SyMf7I4slPCOxonoJ5iudeEvtpC+vdtu720VzRsA83x7ldq47NQoJ0Uibz4BtECAHReWhJe3X8kLJvTrS0MkMxIXBTer+GpvVP093Hyyqny4obT7fv7jV8RbLFHzJCT5WDL+IYvOWc9USyFPbgzQCYj55XsTnNZa7i1A05pl6yegDYPA6KSPlWIa6LIamt9Bu4SOvaGRLiJL+2Dtw6cg8aDOp52FdEb7ZWRZ4nakv6roo5Tu/SSNOixplOmluLOayzmNCZLL9qm9i1AJHOX0CtyxiKRm1Bp8oaJll9PF+9zkroKV0/CAigcKD5pdguGOrv3sQNV2b4eNwgTUkBtcdhMaypX6/TUcZnhMblM91D9OI0XYrungh5T4Do9O3Zzze3pt+7A6FlgsEKC95LIoz4IdR+ab5jilrYxzuPT64f718PV+UwH+7DDyQOY5OgDVmEfi/TPEJMOd8AvK1PqgkJMUYbzi3frZPOwxAVqkP0zA/XSH1rPG52hdZzInoFddoW//5dxHGSXxS1JGZVwb6GeKol
 q+hNZali
 KbOl9b9bd/MIJ6ZZHCFMn2rrDPxuh8oVHh9E+sx8K7MK6iE64+QpWl/jrJjO2goZWCuqw/PZjjKDgDSsWTOawPPjqxCmpuXk/0YAjvyxDlMrWqfrNAGQSfoYrGYlQ/NUewpYrL3GsR62+3fbQ2Cdj8qOJNqz7o4LhrEDy3REX5V/c3YB4znL/9YQ5nkE/FKnNuGWPfzEuhgHXSV13yuZABTXm4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in mglru.

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmscan.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 354b19f7365d4..814498a2c1bd6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3444,8 +3444,10 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
+	rcu_read_lock();
 	if (folio_memcg(folio) != memcg)
-		return NULL;
+		folio = NULL;
+	rcu_read_unlock();
 
 	return folio;
 }
@@ -4202,12 +4204,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
 	struct folio *folio = pfn_folio(pvmw->pfn);
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
-	int gen = lru_gen_from_seq(max_seq);
+	struct lruvec *lruvec;
+	struct lru_gen_mm_state *mm_state;
+	unsigned long max_seq;
+	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4242,6 +4244,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		}
 	}
 
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
+	gen = lru_gen_from_seq(max_seq);
+	mm_state = get_mm_state(lruvec);
+
 	arch_enter_lazy_mmu_mode();
 
 	pte -= (addr - start) / PAGE_SIZE;
@@ -4282,6 +4291,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
+	rcu_read_unlock();
+
 	return true;
 }
 
-- 
2.20.1


