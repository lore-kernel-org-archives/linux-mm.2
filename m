Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A62EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492FF6B009B; Wed, 25 Feb 2026 02:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A8A6B009F; Wed, 25 Feb 2026 02:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D136B00AA; Wed, 25 Feb 2026 02:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22A4F6B009B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:53:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D456C1C574
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:53:51 +0000 (UTC)
X-FDA: 84482215062.29.4493DB1
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB5C6100004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:53:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bSzXDBjO;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006030; a=rsa-sha256;
	cv=none;
	b=4ubIJ29EOm73AUvrIUyfoaEoofTP2SyVh3u+wiak/Jz92VXneydZ0T7uOetZqHsFNXeJos
	2r1yS6HHYl5/NAA0AMZKXtkKOIghjR4iTbq6UUweWc1l3fOf47wCZqFdVkNNKseQ8qFtGV
	4nPGel0L+QVD2AAeYvTf9tBTp3P6W+4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bSzXDBjO;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50It2KWkplJCk5rfNOAinOMdF3qOxn822zHuSg5yVbw=;
	b=Inz7qi57xWhkRrv/jk/khQ/utjD1Aknx6Rj4Rlud49hJuZOTZc/jXP0ft5AO++5ZjLh7k4
	+mE8/Jb6Lc1C+N1oobvHNdF5meGoxkfM94Xl3qN3PCaVx7yxNnU3ZJ3Ja3KR/ARp8hOxzr
	qJ5VyoS/gfii+EMwWT3mnkQ8aYY5Yp4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=50It2KWkplJCk5rfNOAinOMdF3qOxn822zHuSg5yVbw=;
	b=bSzXDBjOYsTbN1IS1mijNvpCfRCrk1olS9/qHw+FBryEX++s7UM8isB9xcHpwhF6VwDQEe
	jXnMIKJEWAlzGLCQmSi0FoAbLf8IfIjxvB/op0aIFS4jDgEBElB04rtPXsRUCqBsatfXL6
	VW8kXnoCPfl0Fjd9LhrDshacXB7VDZk=
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
Subject: [PATCH v5 14/32] mm: mglru: prevent memory cgroup release in mglru
Date: Wed, 25 Feb 2026 15:52:57 +0800
Message-ID: <9d887662a9d39c425742dd8468e3123316bccfe3.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EB5C6100004
X-Stat-Signature: a59a9f5q41jtqypdfaheggou4gz5dszd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772006029-790189
X-HE-Meta: U2FsdGVkX18VmVYcOcvWX+YW+/CmeeBFUQXP2t0fIaImbAB5AdBkPJ9W9U/T/BUTB7rloUQIylHct2BYpQxyxyoqC7EsmNgemg7gEyucrfLq9hN0XtbC7JUrQey1ZE6D2t/95Raxva/njlFZV/Q8oetJFXi7QesXT9X6+W+9duYtHbgoAn9lpJgaONOwMssaxGdeWTJSXv05eqpIoDAe7KxxxZ3IKXUoVt0Igrlg6KSq6+aAYAmYYimcnOtP115nvYkTaIt6DJC1oFdrKG4duU4zMWeYP0rYmwpq4/z/okQ1Fj7H4GFPd+BJm9+rKXVhfNDRsy5r1LjmnQBrgLN+Iw27wUFSdXotAppHqooawe7ZR1+H9cY+/Vd27XRn9i+VTOjM+peq+IIChX5AnUmNhYIgwZESHG2SBPByJ73pvaX14vj0vDqokiPnburgwa/E4O+td2j7rRuCNfzbii74YSJ8UM8X+JpVa+lMpYlh2dwXl6nXOgxl+iHqB5PwsPFakAzc69Wj5t+jM8NVaYKwrQPtySO+dw34p/hq/iX4BrLQ7h/yVdo4QnTGUz5+t4VUp84GNWrrVDOEzSeNpqQeYzesAi4vcX6bR0JLDoHJvR6LrUa8Jar32yQz/dLmkvNZZhFfThIvfs1pbbZDC5hsju5py8i3iRrbDRbi9PyIOysLEvNBG//BmEUwCme/rgOwTYKTmQapdPDOZZb4gvo6Q6gzFJhI8oyjijpuB6ob712FBASMbF+3zva+/YXftu5ldxgRiy1Fie0dzuyuCoP60vIiMsplGv1EcsZmBNgT+R3F5NCpzXKQRMgn0AQipztxOxkoa038YIvQgAwkLshNSJ4Ineua+ByAcr/TDNC8Vy9hpjISNXTL7eGqh+/eGfcFG2E8mMgUkmOn8vxliKdW8wCLaFgWzhAtU80sqdM/ejktJUfOocPijB7FZQ4VrYeYbvdS7WNfXSV+YuVleCQ
 7zK3pQBX
 eBda92JXb4voLyXA1GzCjw8edRPcoz8fVLfwLEfS7E6VJU6KoWOQX81sIb2/jIJZS+npSK0Oh1SDaXdfKPVVAEuEwT3bptBBx0iQOmAwtIVKqbcbFacaeVliJNG7yuRCEaWGcjb+ye2h1sZBD6ljkujx83YJEHjHHZq3QXPatmRTHsbyRH/Im5TYzcxMsBx0vxYLp8Usxwy3qSBg=
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


