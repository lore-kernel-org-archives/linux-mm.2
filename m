Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 045B7C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BDD6B00AA; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8614C6B00B0; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D8C6B00AF; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40F566B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A757E1A0327
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.25.852B653
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92507C0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf28.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s4ZVTpsUqlEoYqDe1sMhypLxORjnx7/nhjbpgiQ8tYc=;
	b=ztxTZ93yg3TwRZUPCFrhUuhd1JJtBMYdzdcOLOHcI4a1pY2Kac1EDG8qlfG8KFGeTmT1uz
	CUENGp0fmfF91SnYKv3IRPiQfH1LevyoFu853rwopXPzTn6aOI6xyy5eZWyh2YH+i9i2pF
	ffY8DalZjmOpemgNF6duJ3pw7ewHbGM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf28.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406424;
	b=b15fc+sex7oV5Ib7aaEsXo8EQoMYF9p2hLvhHtisGLZbQWdskWnrnNnfICks9ZgxiFVMRw
	Wf1eYJ/kV7Un27Ka9sCBHwSsAgPySWSDQ3+EKsMH2gd3iKUSGHt8cLuO7evovHhOM2YUZ/
	PGNvdesIIdSlngjhKh1G86IytqF1lY0=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gvWnG3lZLzYm43k;
	Tue,  7 Jul 2026 14:40:18 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
 2026 14:40:16 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:17 +0800
From: tao <tao.wangtao@honor.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>,
	<ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
	<baoquan.he@linux.dev>, <nao.horiguchi@gmail.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <damon@lists.linux.dev>, <shakeel.butt@linux.dev>,
	<ryncsn@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>, tao <tao.wangtao@honor.com>
Subject: [RFC PATCH v2 03/13] mm: implement __anon_node_prepare for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:32:58 +0800
Message-ID: <20260707063308.29176-4-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92507C0007
X-Stat-Signature: t6fh6fsx5o56kc56xq13wwesstd96tyt
X-HE-Tag: 1783406423-44585
X-HE-Meta: U2FsdGVkX1/bWi0qbtOEb1O2XdgHu6HAZKFovXNGamAPgFBqWwhbgAuqHd/EYLe1k7+1i39Y4R6ZaIeDibkK3BrQA3bGFUMgO1ZYpzmmJTiwbRN+7K+neBudgtDbkuEylULan2l4oBDI24C8Hf5xMOQnp5Q99sIQtIn0jq5JnNFqW0+Yc6M9qwiqpYuGHRsjjojpy4EdbLosQuuIjl8I6/8zwHLJSd/ZE0AGevgIh72uuNpyhFIDTwo0NHObjJXbwYgje5D3puk1cFLmVXrsfOMWVGupj+uNPHNpyUoEh7G6rpORDFTIxhOBPhWCeEvI67jRFYq2I5QD/bicXH31khprWFyGN5on9CwdZdVu5HzUUWWkiK9BRyBz6UJFgflEd5v6eik7cBVOcIAAPRacQWZByFPYeZuYmI0XADxW4/cAtUeX6VlAjH+F9f6tm4hKFrsvpTD4yEjpWT5DKM0MK6B8RkudZFBZmyHonnwn3FmoLjHHmo0VjhiPNNJBa/OfWMXTmocStEyRavsauLCeGt53GtoMMf4AXEPLrEpDopZjH91U+VhbBRQu31rCVD/ZFhfWX7rf3ozpQAVuk55ZVB8FkVhgCumGfeGvGTVID5kXbH7lK31N0DSytCnSFCYHbQcCjAQI5uHl4b22sFCI3wTg0p26aR+1rLojz0W3b7H85YNAxENI4tdi1j3mXhEM3Tek0r6wSCHM3wiZyZGHE5yrICTpjV3sHKgVWaC3DmLlHmrrmYsiWN8dnegH528rlmr4iimqff8fGy2ZZp8Htwx330SczNoj42IJwfCvfecveBdng57ag0HXtljMMZDnCOG53PaW5v56r1xcJd8OeSPmVxmzEd1RKmbOsM4J95HoV9pnKj6rEpB5ZT31zbcthMcbu+NCSkbhQe0lwtrkd151XC5OnzTt04ZNA1TCpvPuJflPqpA3thxLc11WgM7FmnZ9iiCIJjB2VrPC4TL
 VFp1wJ0w
 /o8AzyyLAa+9YdSpq4D5cD918gB1Ax5wzRaGnES1W1f4Rfw+zcmvd8QHhQGgcpyjND78byXldvkod9MBvtlHWXUMPgpqiWYJUEsgkdWWTROLtuyaO/65+uepGjWV/O0T3pB0ohiwsGd02njd9ZSgZ4rfINROt6QrpuH752FCSQeFn8mPls8ljtbsk/DywLPhbhKJ+h46It+NmlMxo7WxSaQxhSFPCVE2ikk4pPm1/G4o4wLm3ZAibmRqkeEZCkOsT73sc22RTRcgX23+dGmPl1JxRHhkB1xViZCajDCGer2+dwXK+S1fMQtEJ6qxAy0LynMCtB7mNP2SMwT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add anon_node APIs corresponding to existing anon_vma operations:

- anon_node_clone() corresponds to anon_vma_clone()
- __anon_node_prepare() corresponds to __anon_vma_prepare()
- anon_node_fork_with_prev() corresponds to anon_vma_fork()
- unlink_anon_nodes() corresponds to unlink_anon_vmas()

Implement __anon_node_prepare() first to keep the patch small.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/internal.h | 11 ++++++++++
 mm/rmap.c     | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index c1b3961b9d3e..710baf02575b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -314,6 +314,17 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
 
+#ifdef CONFIG_ANON_VMA_FRACTAL
+int anon_node_clone(struct vm_area_struct *vma, struct vm_area_struct *src,
+	enum vma_operation operation);
+int anon_node_fork_with_prev(struct vm_area_struct *vma,
+	struct vm_area_struct *pvma, struct vm_area_struct *vma_prev,
+	struct vm_area_struct *pvma_prev);
+int __anon_node_prepare(struct vm_area_struct *vma);
+void unlink_anon_nodes(struct vm_area_struct *vma);
+
+#endif
+
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
 {
 	if (likely(vma->anon_vma))
diff --git a/mm/rmap.c b/mm/rmap.c
index fa9d82271005..b98ba6a83272 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -645,6 +645,64 @@ static inline struct anon_node *anon_node_alloc(struct vm_area_struct *vma,
 	return anon_nod;
 }
 
+static bool try_track_rmap(struct anon_node *anon_nod, unsigned long rmap_base)
+{
+	const unsigned long rbc_max = rmap_base + ANON_RMAP_BASE_COUNT_MAX;
+
+	return rmap_base == anon_node_rmap_base(anon_nod) &&
+		atomic_long_add_unless(&anon_nod->rbc, 1, rbc_max);
+}
+
+static inline bool try_untrack_rmap(struct anon_node *anon_nod,
+		unsigned long rmap_base, bool *test_empty)
+{
+	const unsigned long rbc_max = rmap_base + ANON_RMAP_BASE_COUNT_MAX;
+	unsigned long rbc = atomic_long_read(&anon_nod->rbc);
+
+	if (rbc > rmap_base && rbc <= rbc_max) {
+		rbc = atomic_long_dec_return(&anon_nod->rbc);
+		*test_empty = (rbc == rmap_base);
+		return true;
+	}
+	return false;
+}
+
+/* attach an anon_node to the VMA. */
+int __anon_node_prepare(struct vm_area_struct *vma)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long rmap_base = vma_rmap_base(vma);
+	struct anon_node *anon_nod;
+	struct anon_vma *anon_old = NULL, *anon_new;
+	bool test_empty = false;
+
+	mmap_assert_locked(mm);
+	might_sleep();
+
+	anon_nod = NULL; /* Fix find_mergeable_anon_vma(vma) later. */
+	if (anon_nod) {
+		anon_new = (struct anon_vma *)anon_nod;
+		if (try_track_rmap(anon_nod, rmap_base) &&
+		    !try_cmpxchg(&vma->anon_vma, &anon_old, anon_new))
+			try_untrack_rmap(anon_nod, rmap_base, &test_empty);
+		if (vma->anon_vma)
+			return 0;
+	}
+
+	anon_nod = anon_node_alloc(vma, NULL, false);
+	if (unlikely(!anon_nod))
+		return -ENOMEM;
+
+	anon_new = (struct anon_vma *)anon_nod;
+	/* maybe prepared by another thread */
+	if (!try_cmpxchg(&vma->anon_vma, &anon_old, anon_new)) {
+		try_untrack_rmap(anon_nod, rmap_base, &test_empty);
+		put_anon_node(anon_nod);
+	}
+
+	return 0;
+}
+
 #endif
 
 /*
-- 
2.17.1


