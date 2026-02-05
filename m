Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F60BE91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B6D6B00A6; Thu,  5 Feb 2026 04:03:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A461A6B00AA; Thu,  5 Feb 2026 04:03:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 965C96B00AB; Thu,  5 Feb 2026 04:03:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84AA76B00A6
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:03:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45086B97FC
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:06 +0000 (UTC)
X-FDA: 84409813572.20.07ABE48
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88EE7A0009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:03:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tSjJRYH8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282184; a=rsa-sha256;
	cv=none;
	b=nOzTwwb8I3wXUq9oRMx+7Q3YfwN75mGa2zn5gZVmBbWopJSkjc8ogC43tH9tGT0cYVfC7L
	DRnLWEnBp5s/mrSsofSsXRB0CTqdrx+NGcyDkoFORCPuhbZHeK3O/nGWXJfXFZPedo+msN
	lfbKF7Gt+ovaf2xAgVFMNq6VHRxB0n8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tSjJRYH8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J628NvVCX1ADaXWvBnIXUo0oeiXoWRHWWgu66rJ1mAA=;
	b=bBS8/eyMmSZ6+uvKGTxlkxksjOXx82VG8kiYEca4uxY/onto/O5ohhC6G8pN9WYQkSA6zr
	MStnsAK2MOSqCkiJmd1RDDHCnNSAjsA0AQo+nB93bWJSvTqDwnEnK1WHMjKPZSBsNiTYZ0
	KRt2cvOHMueoYYGTWzGOFCFZkXIO7gM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J628NvVCX1ADaXWvBnIXUo0oeiXoWRHWWgu66rJ1mAA=;
	b=tSjJRYH8XwIGi6IfN+owvz08VcSRLJD8CJusIhfEQb46DUmYBA6mXAfRJZYUHi1U+WcuxB
	4PzZmP1kKLqXEhO6FoRyERJiO/0xafqYhZZsNrAlMVGB+cP1p3OowGntAo4fYwauLKNh4A
	ZaubGhliPHZZRq9Bi5EVPYj/Ci3rvB4=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 14/31] mm: mglru: prevent memory cgroup release in mglru
Date: Thu,  5 Feb 2026 17:01:33 +0800
Message-ID: <d660370c9e1d5a104bce93c057071b87a2333d3d.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88EE7A0009
X-Stat-Signature: xyyfwo8bscpcdoxjt6ertt1fo5mf3ph8
X-HE-Tag: 1770282184-843692
X-HE-Meta: U2FsdGVkX1+PKjoex8SHNWSWumRIbDXV/kpGSgJQ5feAYxciUMJI67rQaNXQ7NpTDnRG9BSpFi3inFK4HNlTjsCO9KO3CV+/sLDnwWfYlVaPlG9/ZS72WxEHlCRcU5rmmRC68rmXUGNU6wB3Epg0YNcG+8IzwM0M6FnmpjGeYxGNKWLd798fndC8CoiSTWjttB4BnPwmKhMQa3DZFwjuF9a8h+XcL/irG/EPOiYEb/zzUQniZmI4ot+48D9bvdsHsLrpyv8NPNMfbDqkiB/tI0y2kRPovpiXNjd5QlKXfjZQJGY0fqjGWcwsvGL17vFV0dVouoVN3IrLgfb4t1zz4csrkvVQpaU2Wx0uBs+NpgNF1nowBjQOB6xUtA4Eicm9PBvoo5HXaXoguIQeo+AkvQtl0pZ/YjBQCU5O2kEqPkOMb1PYVaxn9SVwmdXnDqy6wZTt71A+fPWx8zL4sNFU/4KnXYiaPRfeJRTLcq3Fh3cU355sYZnTCaQfuRQNBRZB6Adgx322grfO9ZeGEHaHnDyxRztTvIm0Bv9cHsWnHRWXhNz1OxlJSut0GRqaOVOKMaLgRIDLEDcs522/XwV7Z288hds2qd2Do8GOafPIK1gFIZx043tLfdSWP+/F783rb3xMp7A52kEHOSON/TZBDRzXO1CAqkfDB4yxfm7poctA6kNTT/0OEcCrZ35iplEvnBcUroQKXpinuqAzBCXjh1NjjwJpXsEVlh4Kc1y8JZh6yWSyRAJ3/AIMQpJrfVeuoxS72kGbls9v3Z48edLd7S5cO2KOsuSytXG2P7SkhdYtpNIBpS7YztJjIOMkF4/1pvZTMEwmro4yz6aThCpiVKGDXkX/LTlF4K3BashpiS2RGJ8j2t/9JWGt6ZeB/vy9noC1s1eOWXva2OlTTp4aDZqjbyVdp01wcZ8eJTl7aykdJrHgglAqGaKKyTzFPspDX8Bt7X7WO4zMU99tx5S
 426qSp/k
 +3Xwl5UXXfpGjksdtiVVoyFcz/+oBrXYPeN+3ckgwlUfw9QVLNHm5c1mq8LELMvwQcYLTqF1irwvnLy3Gjrp58lGp+kkx9PMYINM3MOJLfFzRDul4Hcl5EB7RHIlU4O71FJM0WDcM9IWX9mzw8+bQcVJdSiFfJqXwO/YmVNBLScLTHv844A9vtoRcRP4ykisHay0l6pCPOmDv/BE=
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
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/vmscan.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8039df1c9fca5..6a7eacd39bc5f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3450,8 +3450,10 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
+	rcu_read_lock();
 	if (folio_memcg(folio) != memcg)
-		return NULL;
+		folio = NULL;
+	rcu_read_unlock();
 
 	return folio;
 }
@@ -4208,12 +4210,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4248,6 +4250,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
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
@@ -4288,6 +4296,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	if (mm_state && suitable_to_scan(i, young))
 		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
 
+	mem_cgroup_put(memcg);
+
 	return true;
 }
 
-- 
2.20.1


