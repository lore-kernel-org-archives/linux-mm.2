Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABF8CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDCD80159; Tue, 28 Oct 2025 10:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD9F8013F; Tue, 28 Oct 2025 10:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C5680159; Tue, 28 Oct 2025 10:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B15218013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F6E0140472
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:42 +0000 (UTC)
X-FDA: 84047691084.04.0B2951D
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf12.hostedemail.com (Postfix) with ESMTP id D30F440009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fhoHKTrq;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkLnu/O9q4xdyqjaFOUvki0UTYleR0McbTd1ETEhnKE=;
	b=nZ3VFDIad7s9p5lGgSSFpo3Hyhw/47mEg6e9IT/cQIW4Oj4u9D5Bcc7Sof7knpukcwmtwd
	hPgO0bOcKfc+V0dAA3LtGKYAAb+ZSTZZQNFaYSuZrlIqCuf2fzFu7YkYlaR5BjSjeay0tz
	1jLO4cw9+bCuFGyCYycDplmkvbkYcc8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fhoHKTrq;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660221; a=rsa-sha256;
	cv=none;
	b=O8vMb+zFhz0lFEQu7GXteANWfVd6XmL1X+jed4bHFHcsNLieb7vo0cYwv14ax5SHPLv9Hh
	tNyE7HrP+YR1+GTy2/BmAm+5xVMdhIOvqepkuh8PmQIgtw6P4w5s5vbOKkGjsPycR44ACk
	6Sel3NQPoPYdrA4N51aUGEwlncgVzm0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wkLnu/O9q4xdyqjaFOUvki0UTYleR0McbTd1ETEhnKE=;
	b=fhoHKTrqeVk6EZTuFAS26dH7KFQqARavNeR76iE73qBaEIWQbclTIzwrgj8JSL8qtfhWPz
	Prin+M4U0nQHEyZAfPOwRr6LzXUBd1RKMclEfqJMc+oKdYk9NayqXqvzChMmpi6ZmtuPOL
	IHh2SSrRo7IPh5r1+4Fh+biiYMfo3io=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 13/26] mm: mglru: prevent memory cgroup release in mglru
Date: Tue, 28 Oct 2025 21:58:26 +0800
Message-ID: <da4182d4f912a00e0cbe377f424f1e94afd3e5c3.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 6zfhuaugpmxfga6jgfo77ft9emhx5w5k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D30F440009
X-HE-Tag: 1761660220-884425
X-HE-Meta: U2FsdGVkX18ZkUEhDyKb6SoMVBmlI0Ny/ueFxv1v7ruKYTr2B8rZYhsZE2A+osN09xsHwTOd3qv1mSy87xtQxuib2wnEeUwaZ/ZT+PkUClfipSv+NOxAv8rBITWRnwAR0bq/EmMpD1kJCISKTMzyglBFt0YYDcw/GxOnZ7l1XFlKrnxsmRmV8jbRLIZTixgzgdk6Q/HalMUsd3p5JFDXqwDOfjLVy7TJqThmi+Qk7gHekviNyWE/Jy+uoPVf+QwUlw8iyUuC8zhyymOoE+DyOFH86GyIQDU/R6JqpLhZ0a3iIp0MbTtt2moHlKTFQLiPeXyU6SeCPmbNJXBvzxvOP8irEHoB5fTePldxzhIbUNsZgrv2sWdI61jImowaiy4Hb9Lt/Mj922hET970NIUVZS4nsbw/4BovdnjNJkhLCDzlyzNkglncCCPf8lcmtlUG6tWERmUyA8Palr2tkL2hx34tEAs9RMo9DkAw4/pFnpYgQRrrajqgrgMAWkUdBIZPAEmkiU1j1J8Me5db12SqGdiJI20CRhUPZ9UYgNrkrV22nX828WaBYzJUPOiHhWG9wgqrq8xjqlas6Pl0b7Sl2MjM5O6qM4ga19DTyphDQ4uwM1N+NL1CIcR1VWwjb/nucknGAKdWyH8NtVa+MTdQow6hiGBpx/uE+gcodnJOxggfLiC/muz00a2pL4MtRowZOWJAiZKoCrJidL3aQf7NnXKyHixtqciWPShDoLbJ1oitDbDQmbSIqMQlntBUScoHFd4UNq57uo9vaIK4Eawcwq5EDmAW1j/mtu8O5zGh10MJHH8KcvLdwNDq0/ukiHNFxnu7CJa1Qv8=
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
index 660cd40cfddd4..676e6270e5b45 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3445,8 +3445,10 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
+	rcu_read_lock();
 	if (folio_memcg(folio) != memcg)
-		return NULL;
+		folio = NULL;
+	rcu_read_unlock();
 
 	return folio;
 }
@@ -4203,12 +4205,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4243,6 +4245,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4279,6 +4288,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	arch_leave_lazy_mmu_mode();
 
+	rcu_read_unlock();
+
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
-- 
2.20.1


