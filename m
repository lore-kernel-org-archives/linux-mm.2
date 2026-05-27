Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A398CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF786B0096; Wed, 27 May 2026 07:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8016B0098; Wed, 27 May 2026 07:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7346B0099; Wed, 27 May 2026 07:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E596B0096
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40F1F14055E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:06 +0000 (UTC)
X-FDA: 84812925372.26.92F660B
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E6DF40004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=FMgslGyV;
	spf=pass (imf12.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0GLFq8C9nPPiYhXgw5zAUxPFjuLn1gqka+weNMFags=;
	b=fUL5zCaoKvjaStL20OQQw9al+/LQtuLuMVW1AgukYnjdwoxcAEzV0Z7JFuspCH2DQsCUgz
	cipzqZoLmraW7Xqm83V+BLV7UtUoezCGLTWO/TPmHIk+5rHioIr/yD8dTrA9cUgQhjN+nV
	6wFW47mNxMtpoxd2OHE1l6L2M1iMTcU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=FMgslGyV;
	spf=pass (imf12.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880084; a=rsa-sha256;
	cv=none;
	b=rsUZhfv7F7uBHRFgzOhjNQ7Lg/sHVQjpaFXINu1akTGixik7wsG4VQxoUjvLCBHThWuoze
	sjftoCZecKrpc9og8UurPoaPQALFQfqYEgDCB1puzKaHOikeVtHM4RYBh5FNi2diRVXWB9
	Trd9m7Nb9tnwEAV5td4baJB/5IsU1gU=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=H0GLFq8C9nPPiYhXgw5zAUxPFjuLn1gqka+weNMFags=;
	b=FMgslGyVg0RRYZZQlKDK6VfD2gw8hIqaisjkqVL+vKFJb23PxpvExqtX3zbNjKbOwPDDGV62E
	TyTVyMMIq2R7BuO+Y3t7cBIxf7zuJCin764atMWjJ2AwlV96KxgUhdIiU29bHfzaWpqmZ+ltkjE
	1bG2dGP2IaEG/Rif6aUkHaQ=
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdd4vMfzYl1Gk;
	Wed, 27 May 2026 19:06:45 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:00 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:00 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 09/15] mm: implement ANON_VMA_LAZY rmap semantics
Date: Wed, 27 May 2026 19:01:41 +0800
Message-ID: <20260527110147.17815-10-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E6DF40004
X-Stat-Signature: bdgh6a3x3dh4qmtzu68c7d8fwctfqkyd
X-HE-Tag: 1779880083-480815
X-HE-Meta: U2FsdGVkX1+s287n7zPBeiPz5V9VFgVBHlIi6WqPsQVdzt0Qrs8sJok4ze+gA6yPF93ebx7Tx2fH8GlRaeyQBSv1xbkYaetsJ5HT4Ldxx1zw4ClFC6Mh3Up+R8ksozLSZJAVhHNR+kSMgQz9d9IhwfDpKre23plHaJNv54W0aSb/ylhudqx1G9AhjCqdMbE8xGDdpfdZpFk6b5DNVNV6sS8bNLqRigFwEIoGJ9XZVBrGLNMZcf0lc4yCVnD/t+sY/HO9OQQsGB06ofMwN1ySo5kJFhpRydk8+YiBDRnv0h53KtC1d8XyI0MtRMza7IJEEucg6A44ul09rAVDsj5keriF160fye48GH2A5UCH7RfadJS5d7EzAEfaLwCWu5aeL3D+S+GxWijXVeoJ+htoLX1/pukURG0a36sMPqsIewJ8IJLhryHyMAXAvKmTOflquYwcSgFcxd2GiAFdIN/r14ww2a1+4D14RJM9HnQJNKTdXBLqenw/saoTvUeYf74cY81Kf1vzk/AqrPIHAEr1ND/bH/we3zQKhY6YF0h69HCKXJJ4LHM+RPk9NW9cWQTSDO2/XResrSBPzgDCjoYzZm/4N5it6vnJTVQ1lMRxLNFafdDPXFWFgI+LiRrM65uuKjos1Y9FUiZWV8KeCvkuCsjyRlON8alK/4xCjkQ9droi3rNMojdPXMSU2LTuVBhEqkCi1IQT3Jp7fHkG9mXa+Gdo6EerBwSKErC5jvOJGwHOyG0hd5u+NItUZXsIE1kt/waUOL7chVpEICYbAbQG2KCKX2RLGceQsAnHCEjPkZ2HTZ2zPMznZIiYue6vs2k22joJW33H9s6C8dMDDVB7KXW9SSFccq4B2z4E40XEg1+sGKbN+UglEWa5lij7lZUaUYWpoJlVstk7y8VQUf6YFBpoU9oj/sqzQZuwd0Spke2hA9wEMKFCZstpl7CPu7UzgQcI/1tPV2/SQO5SSlg
 nBTmin1R
 3mdGzIgY1mH5Jieyll/c8fcmgUgQ2+9Y1k8IQsD7UWUZZX3vXe8IFJEwqDYbfxeSd06lXB8rfS8S1FSApLkKVUTiZGA07D4BOZRt0+bDcfAqKwbHp0/vWSP944v13HM+Xqp5gdtFgWgR7vNHbdWN+5m591op+Yrao/UsafGLvCrp/+/r47JSciqyMDjzVqF1u2RF3ZdaNRVvV9xRzupTDP2ntniCjwWFJX+q/ucbwN+qtsi0vGfbSLe59wXkH1yZzkPRMvcujUKCX5hyjdcDlMU5TCgJjdRnozs5iGeD4rL8QdQBz/r13/FZWszsC7VDqQqsVK3cc/1Xgh7D3lZredJZHi6S/lzSYHT0D/r9WpaBHuOXSTA2BCHCjbkFn7nXCpBWgap8126jSGJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement ANON_VMA_LAZY anon_rmap semantics by updating
folio_anon_rmap(), folio_maybe_same_anon_vma(), folio_get_anon_rmap(),
and folio_lock_anon_rmap_read().

ANON_VMA_LAZY VMAs resolve the target VMA via root_vma. As this path
does not involve anon_vma topology, vma_get() is sufficient to ensure
that the VMA still exists.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/rmap.c | 126 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 120 insertions(+), 6 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 001c44570df8..f70e3cb9812e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -875,9 +875,97 @@ void anon_rmap_unlock_read(anon_rmap_t anon_rmap)
 	anon_vma_unlock_read(anon_rmap_to_anon_vma(anon_rmap));
 }
 
+static inline bool test_folio_unmapped(const struct folio *folio, bool test)
+{
+	return test && !folio_mapped(folio);
+}
+
+/*
+ * Must be called under rcu_read_lock().
+ *
+ * For FOLIO_MAPPING_ANON_VMA_LAZY, first obtain the VMA recorded in the
+ * lazy mapping and take a reference with vma_get() so its fields can be
+ * safely accessed. If the folio is no longer mapped in that VMA, resolve
+ * and look up the actual VMA covering the folio.
+ */
+static struct vm_area_struct *folio_resolve_anon_vma_lazy(
+	const struct folio *folio, bool tryget, bool test_map)
+{
+	struct vm_area_struct *vma, *anon_lazy_root;
+	struct mm_struct *mm;
+	unsigned long anon_mapping;
+	pgoff_t pgoff;
+	unsigned long addr;
+
+	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
+	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON_VMA_LAZY)
+		return NULL;
+	if (test_folio_unmapped(folio, test_map))
+		return NULL;
+
+	anon_lazy_root = vma = (struct vm_area_struct *)(anon_mapping -
+		FOLIO_MAPPING_ANON_VMA_LAZY);
+	mm = vma->vm_mm;
+	if (!mm || !vma->anon_vma || !vma_get(anon_lazy_root))
+		return NULL;
+	pgoff = folio->index;
+	if (vma_address(vma, pgoff, folio_nr_pages(folio)) == -EFAULT) {
+		addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		vma = vma_lookup(mm, addr);
+		if (vma && tryget && !vma_get(vma))
+			vma = NULL;
+	}
+	if (!tryget || anon_lazy_root != vma)
+		vma_put(anon_lazy_root);
+	if (test_folio_unmapped(folio, test_map) && vma) {
+		vma_put(vma);
+		vma = NULL;
+	}
+	return vma;
+}
+
+/* Like folio_get_anon_vma(), but for ANON_VMA_LAZY VMAs. */
+static struct vm_area_struct *folio_get_anon_vma_lazy(const struct folio *folio)
+{
+	struct vm_area_struct *vma = NULL;
+
+	rcu_read_lock();
+	vma = folio_resolve_anon_vma_lazy(folio, true, true);
+	rcu_read_unlock();
+	return vma;
+}
+
+/*
+ * For ANON_VMA_LAZY VMAs, similar to folio_get_anon_lazy_vma().
+ *
+ * These VMAs do not have an anon_vma or anon_vma_chain and correspond
+ * to only a single VMA. Therefore, reverse mapping can be performed
+ * without taking the anon_vma lock, providing a faster rmap path for
+ * this common case.
+ */
+static struct vm_area_struct *folio_lock_anon_vma_lazy_read(
+	const struct folio *folio, struct rmap_walk_control *rwc, bool test_map)
+{
+	struct vm_area_struct *vma = NULL;
+
+	rcu_read_lock();
+	vma = folio_resolve_anon_vma_lazy(folio, true, test_map);
+	rcu_read_unlock();
+	return vma;
+}
+
 static anon_rmap_t folio_anon_rmap(const struct folio *folio)
 {
 	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+
+	if (folio_test_anon_vma_lazy(folio)) {
+		rcu_read_lock();
+		vma = folio_resolve_anon_vma_lazy(folio, false, false);
+		rcu_read_unlock();
+		if (vma)
+			return vma_to_anon_rmap(vma);
+	}
 
 	anon_vma = folio_anon_vma(folio);
 	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
@@ -887,29 +975,49 @@ bool folio_maybe_same_anon_vma(const struct folio *folio,
 	const struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma;
-	struct anon_vma *tgt_anon_vma = vma_anon_vma(vma);
+	struct anon_vma *tgt_anon_vma = anon_vma_tree_anon_vma(vma->anon_vma);
 	bool same = false;
 
 	rcu_read_lock();
-	anon_vma = folio_anon_vma(folio);
-	if (anon_vma && tgt_anon_vma)
-		same = anon_vma->root == tgt_anon_vma->root;
+	if (folio_test_anon_vma_lazy(folio)) {
+		same = vma == folio_resolve_anon_vma_lazy(folio, false, false);
+	} else {
+		anon_vma = folio_anon_vma(folio);
+		if (anon_vma && tgt_anon_vma)
+			same = anon_vma->root == tgt_anon_vma->root;
+	}
 	rcu_read_unlock();
 	return same;
 }
 
 anon_rmap_t folio_get_anon_rmap(const struct folio *folio)
 {
-	struct anon_vma *anon_vma = folio_get_anon_vma(folio);
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+
+	if (folio_test_anon_vma_lazy(folio)) {
+		vma = folio_get_anon_vma_lazy(folio);
+		if (vma)
+			return vma_to_anon_rmap(vma);
+	}
 
+	anon_vma = folio_get_anon_vma(folio);
 	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
 }
 
 anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
 				      struct rmap_walk_control *rwc)
 {
-	struct anon_vma *anon_vma = folio_lock_anon_vma_read(folio, rwc);
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+
+	if (folio_test_anon_vma_lazy(folio)) {
+		vma = folio_lock_anon_vma_lazy_read(folio, rwc, true);
+		if (vma)
+			return vma_to_anon_rmap(vma);
+	}
 
+	anon_vma = folio_lock_anon_vma_read(folio, rwc);
 	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
 }
 
@@ -3140,6 +3248,12 @@ static anon_rmap_t rmap_walk_anon_lock(const struct folio *folio,
 	 * are holding mmap_lock. Users without mmap_lock are required to
 	 * take a reference count to prevent the anon_vma disappearing
 	 */
+	if (folio_test_anon_vma_lazy(folio)) {
+		struct vm_area_struct *vma;
+
+		vma = folio_lock_anon_vma_lazy_read(folio, rwc, false);
+		return vma ? vma_to_anon_rmap(vma) : ANON_RMAP_NULL;
+	}
 	anon_vma = folio_anon_vma(folio);
 	if (!anon_vma)
 		return ANON_RMAP_NULL;
-- 
2.17.1


