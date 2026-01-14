Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15048D29FF1
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7766B00A3; Wed, 14 Jan 2026 06:34:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF126B00A4; Wed, 14 Jan 2026 06:34:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2146B00A5; Wed, 14 Jan 2026 06:34:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C02C6B00A3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:34:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21E971BB6F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:18 +0000 (UTC)
X-FDA: 84330360996.12.05464CA
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 775E412000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:34:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KmDvj3Gd;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JlAZQzRN5bDs3qiAHWl4rWTV4PeQocYNGSREH21AX0=;
	b=h2EDe1JO9DXVifvwvbh8/HAa3VbphSP1wcnCiLd01f0NoV2eRPTTJ3SSQ2UCKVrPmybl8E
	4oomxtk4lXTnNv1kODmA7nRxDf/2rfUmcfmfRi7zLnmhpGsCoQTAs8EcgyBynZmg7u/5qJ
	yUN+4xLbh79y6BLXBNgib1e4GTbZn/A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KmDvj3Gd;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390456; a=rsa-sha256;
	cv=none;
	b=RkRj0FPRgRCMXJaOGpVVF2zTR5lV34p/Er0Kvu6YOyK5iss/xE/ucS8mIZ67AKON3J3ncU
	R9RFAdaAEV9bQO+h/e1+wCS85p0Jdztu2s7s0OxJ1w1qCsSul+TAYUEZBgA0upyzAvFaSg
	1mNqrJajEaZj8ZZ1izRMOHCysGrf15E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2JlAZQzRN5bDs3qiAHWl4rWTV4PeQocYNGSREH21AX0=;
	b=KmDvj3GdhPZVoqp8eC9pasVuk9TdYg3eQpn308+RW0JPRapnnho1n3PcJ7C09UbRdZ6cl+
	dgs8UTs8ZxmghI7oxFWkqBtV0wFvTOg52Yt6jTxq0JVS1pyoTU/xx5hxyDJwFtMsxolMyf
	IVGl59Th2CkCBHW5Taqq03chB5G5zJg=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in mglru
Date: Wed, 14 Jan 2026 19:32:41 +0800
Message-ID: <2a42effe148a31d308075f9fe72bd76d126b96b8.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: rk1dyeiwrcchcmewcrjc5hentub3h6bs
X-Rspamd-Queue-Id: 775E412000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768390456-864892
X-HE-Meta: U2FsdGVkX18TcEpfFKgXkKv2r7Fx6m/AlRd0VKiJmdsNasbLgVuvSSJmol4A1nJXvTxnNG91DKbPOBw75Is6yTE7XmxAcOEE6sWNBFL3egscM3wMz4i8h0R9oXIQRIpnWAnCejse6V2TZgo50+0jXZFE/b1nrq6YyIuwX/VFxW3n//aurAEtQhgCx1AnyRlnfBZnnURmpC7DhzL3N9pZAhuRB/Rt6SqgdJOgmKW9/rnt4GM+gsbXM38NRdH2A/PdbTyF48M9fVpGg+/ufAxsbSzFTYx81GZmuNzFdH/EZp+jyN41CoE0XtpA83NCg3DjjX+5lwgTbG0Xk8MULiy9v4LHzej6YIk1nvXnDnzVxXIjZAIOuiITCHlRiHsirXDhHk5wP5C3971xM5AzEoTr5H0ewO5/7OA4MFrkbKGyKIyWxSwmZsOqvxph7mBVrrPgVrYJYeTGwTCY4onVxsNqKR/eTr3MEhwpEg+Ku9uiVZE3DsCgpBXUGlCWlhqh25fkNKphnmejFbvDMVchuUuJF0PhvYATDQtyt1/BaOgyZqV/xj1N4Ou/8529n+khR0Z24/vvYL5RRgorrm9CqkvNA0KRcqtBBUdOEsV1WwxWDieKBsrfOEK7uXZFBDoPSZ9IO9ucTp4XmMmN+sD4801hRcKqqq7KgGNn4jT7tm3ht56C70UZHLnUKveZo38gwpgxBHnKBnabjmwyyiSI5oLOJ2Im49jVoFUPqCNsumpICz8Iw8iQK0L28wYj4vz+fkacbKLT16CLOqPBeTt9JdPbzo8ohbOuA8yuCyJXE20GjjqGkEuWTEDM+VUNqiXWJdLeUUoI615ACOfYauWEbX71FSDmn2+gA4wnwth9YDrE6C4Floe5PlM5lT0FMoCWS8389gCPh/oae709g8vApOUY1+rxoCuWeqAXt8znsZ0EDZ4au0rY86GzGR0m8+mwSqbOXrMA3jMUEBmZSgN3Dj8
 LSkb5ajB
 Rtdl178hZLHfFnuylvDHfJG0rIf6UQJ77mgYakQgHMEO43uzrQyYUXRQWTGA1GR1nZDw4G50+Mo5zqYHioBTtyHWk5FnQw69HE1IESarVLSnkrv+5r4lWbxJPl2/EbOewalva80WviM8QCDEOxHeUyC1i0Ul4+bY41Mg2rGV912nr4f/NyULfUWahL8iZhBUpZy8hcrEjVuOq88HaX/TEeLgqqA==
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
 mm/vmscan.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 20cd54c5cbc79..f206d4dac9e77 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3481,8 +3481,10 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
+	rcu_read_lock();
 	if (folio_memcg(folio) != memcg)
-		return NULL;
+		folio = NULL;
+	rcu_read_unlock();
 
 	return folio;
 }
@@ -4239,12 +4241,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4279,6 +4281,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4319,6 +4327,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
+	mem_cgroup_put(memcg);
+
 	return true;
 }
 
-- 
2.20.1


