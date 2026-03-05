Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EA2F30950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD356B00AD; Thu,  5 Mar 2026 06:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4946B00AF; Thu,  5 Mar 2026 06:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5646B00B0; Thu,  5 Mar 2026 06:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9A646B00AD
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:56:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E1251CC43
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:33 +0000 (UTC)
X-FDA: 84511857066.22.72B2AFE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB5158000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:56:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aYY6BFEh;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50It2KWkplJCk5rfNOAinOMdF3qOxn822zHuSg5yVbw=;
	b=1RBj3rxAe01Y1cDPUXngmM+m+CkzsKHsdgS6kXmPwZbpTsPmWthoa8fvhwt0GRFp2jDcO3
	mCT5Vm7VatlVqs8It8ecrexosVP9mNtC2LNZ9bB6JrBpJsiUGx0Oss9Ru/UgaAw7aQhQnJ
	FKbhUpj7srEH2NG0hcVe+tv6y2duIOM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aYY6BFEh;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711792; a=rsa-sha256;
	cv=none;
	b=NFe9l1SyNWUFzTLruBJQctOq0Urv+D7e5MmZ3Nd1tuH4HuX5vmfkDqSU5BYYUWmv36hVkV
	ObsonuTXnWQYW1a9XcI7kg2hUoTKmVt6GFd40WcsQhG33T8Amtgr5ROFkt9UH1Icp2kbGN
	O5/4CquUi8bF3gHjnz6B+n1Z+ZBNwA0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50It2KWkplJCk5rfNOAinOMdF3qOxn822zHuSg5yVbw=;
	b=aYY6BFEhf3mRI3VEazB541/h+Ze1kRL1T3Rkx2QrL6z4PUiW/zGnHy3PoFZBmvGLsO0m3n
	n1ulPJkbmUdk9NdpCNGrTnTk69ATRWXhf8K/4eKeCiyoxOVjm91Y6ghwuFwnSmjwthd/Iy
	kOTAGa1xFjCZIWPSMsCLoL0zwIKrHWI=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 14/33] mm: mglru: prevent memory cgroup release in mglru
Date: Thu,  5 Mar 2026 19:52:32 +0800
Message-ID: <9d887662a9d39c425742dd8468e3123316bccfe3.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CB5158000D
X-Rspamd-Server: rspam07
X-Stat-Signature: ktcigrwqk3g3h9hrc5t9w6m5xtx6bstg
X-Rspam-User: 
X-HE-Tag: 1772711791-531230
X-HE-Meta: U2FsdGVkX1/zUYIv5X/91j8O+nYRFNxnum2YNizaAwtvmlpIIKnoLQI4P0bHRq3MObvUfBLsYOwoOaHsgCRTRAy7T8tB0FP1VzB9jzoWMUelJ5qtvJkamS+sp46I+YLvGzopE2HaRhoi3aAE0IT2CHe4KPRtRJ3jDhp7mLSrwtVc+u4P9Bp6fBtm75GPnw5ErQcGOYUkXeITYH6omKGYw/FXPGHPi8kz7Ta5Zb5HbO75qhWxdKwHjqRtbCIU3J/2otv/tor+oLLftn6PtGIrzlu1wdgUbSNc68uhfao7bgUU0v0ADZNd1vk8hkLqXjvM6Y8C7lJIxtMNbnIAGG8yunpuUu0+G3sSaLUoPkd+BatBw2kBj7QoaKD/Uvbg/vgTa7Dh/rXQvtE64rfNNicCMWRCJEMHjRPnD1a4wdRciegPm1Evq5UdufOgVpxGLdvVKQQvGUi+2AIB1+Ulyp+utPFjpNC7rLsHWa1oyjVAHM3YREvzu8a0STqwVZ+VbQYaPgvshcvZ7FqEmUpaiG8FOXp1Byx/uK9fnRwpjZzuO+5N6KJmfYWdAY2AggKkXUu0bNSpAOiyRi4O93FGi6cYJLVCsMp/ykAi/5bNf18invGk+uW/jQjePKWkiE1oolmz6EC1wCe0/RsfselIxenc+G0P6ZPclfQtH8FzK7NY3QQsEHtr6iaZeAeIyNGQ26RzpuaLdPV6G4UnkYdlSQ26QE0p4v7E6a2XlH4HpPj+5HachMOnPK1nas5J6xGMu1U8qVQzDs5jYrTI71DY9W3PwemWWbvHfW1IGO5kx2Cd6caV592ir7ngb3bHVKPYEFkTN80bd1zT/4IwnGTqbgjM+m2Arrkd+L1/lFYQz864CL32G+I9Hs/64LNseUDmyw8+3YBnAuR6Hk+bPNbXPIFw4VCh76tnQ86xR7/BzfUr9dpcluLuhS5czWfm0K8CE4nJdAOJfgmaInz9vqQkxRa
 NiYqnpZU
 2yNnyF7l5A9AWaem+W0ZqsJq9RjqNGWC8FpiLVbxiLY7NxGLJRbbzkWQHEIbvp4euA8tmHe6zCfIRL+qIqAB+WI2NACJffrXr1kcdysFfXudfkNqHM2O6jKgXgrMlUTbVUUot8bwlq711QUNOmeH7OlURd8XLojvu0+dfjbMPDkXXKfAwED/Wjc1kHhUctSJgvhP+Wiv+cseXfz4=
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/vmscan.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 61303ec85d587..024ff870b1a03 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3443,8 +3443,10 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
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
@@ -4242,6 +4244,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		}
 	}
 
+	memcg = get_mem_cgroup_from_folio(folio);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
+	gen = lru_gen_from_seq(max_seq);
+	mm_state = get_mm_state(lruvec);
+
 	lazy_mmu_mode_enable();
 
 	pte -= (addr - start) / PAGE_SIZE;
@@ -4282,6 +4290,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
+	mem_cgroup_put(memcg);
+
 	return true;
 }
 
-- 
2.20.1


