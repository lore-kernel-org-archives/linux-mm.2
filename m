Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42115C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54C26B00AB; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04686B00AF; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949F56B00A7; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40FC96B00AA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6372120321
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:26 +0000 (UTC)
X-FDA: 84961031652.16.700D146
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf25.hostedemail.com (Postfix) with ESMTP id 66439A0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=W+rm16pI;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HAQWJ3pVwWfob9ODqC/Kr1JqfriaUqoCgw5Fb97ovc=;
	b=X5uaoXEThrcLaWWguIHQMqL6SCIJAEApeX9m5dEtEYglUMVLFCGtXm32eyO43DjNLHXQeq
	5ecCvx9G7EcmqPGsObISIAnafMgB+2MYrZEXBjfX3RiFOf30lYlzsfjZpFgWfUpcPBmRSj
	+UGcOfMqIovxxVI4xtcAC8HlejPpc1s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=W+rm16pI;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406424;
	b=7Vy8yKli0QH7qLq5UzO1BSS6oBHBSkDSEF9dgmjXGOvLgdykQrqvzU31U5DLkC3H3pg4iI
	8kUMvRZtef3GIFZLuhhVatLkfWFJDto4TO+W4k+uPXoPowe/pJkXd/IN1Wr8Kr8Ln7D1nu
	i2815MsuSPUWnzJFziwuDMYVKe+tgb0=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=2HAQWJ3pVwWfob9ODqC/Kr1JqfriaUqoCgw5Fb97ovc=;
	b=W+rm16pI01FqtDtqFMYMSfa+ApAyTpe0XPZq3wSew34VUomsQ5Z38SmDdLwIE9QlWhhEVdpcA
	893xUhztJ0YcExPDl1Ioi+xR5VoNJ4hPCJ9JRhKS/wLhu5pd8mtwlFTEF4t4fhjKTxFWhJgN+3y
	uVHrTwHvP35Hm0vNQ4FwpEM=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gvWnH0THRzYl1nh;
	Tue,  7 Jul 2026 14:40:19 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:18 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:40:18 +0800
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
Subject: [RFC PATCH v2 05/13] mm: implement anon_node_fork_with_prev for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:33:00 +0800
Message-ID: <20260707063308.29176-6-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 66439A0004
X-Stat-Signature: oznewqx9cef6e6fk5wygb9n97ye6fzgg
X-Rspam-User: 
X-HE-Tag: 1783406423-959036
X-HE-Meta: U2FsdGVkX1+BeAFOE6vE+7SOMwbGbavBUy1mqZU1Gu/P2lWDhaW4yvGYVGfUMifJxkuboIwJrfwkxmsGILFn0OSPiLg+pYm3K+Wrw2wlz1L5qk4E6qVHK42b/7VzifQ6AWNlmHG7mr8AMz6lOyfR7XLYKnrPIdLQwUJ+c3N/aLI9RJKo/Vi9e4+ONhXQdmHMVPC9uK+6QT0LEQ9MwOdjHV4GHGkOutF+1jP8GAJG3q+bycT2K2J5rehHKpq3jtjcaVFVR51ByzZJNQXbg3Saozt8dUibgKgE5HGRxXplumYRKZDCEZz65fskzsrXDsjfqUUSU/k1VbwjbzDayO+Ju46CeMXyJ4g/daPPScPs56oU17MJHVJKqKhHDxOPblKvEATl0tvSn6EJXREl1cdQO6BJwPF9PlgrXXjDcOPG/a6WxGJ3l9Jb97pPaaLQsGzbE2IUr6WIvfHNMRymzm2dXd0gmi5C0jJtYHCRabMS2YQ6N+FjONpngShz7FBRVT9+n+OTPBgZPfngEwAHF/ebwHziUrZl9DiGks6vk0Uw2Yhi+2HZ9YjQW2X42PEX0T4D2YGKxHhW7GDaSN02ZCWZKwkIZrvITuBIwIWPPXF2BSI2EkNKD+x6hbwwwowVNKhrcdEUS+GFPN0WA7wu/cUDG1M3qxbI1ZNLDrkIH0DO857EN2DSvhmPwd/Wl5oCYy1kZi/h3PhETzaw3FkDAsr8ODJfgIAfQ9+USVKf8k8dMcmIwCXesbPFUoiZs7f+kc4q/m4aXgpRQBow7J8kbrfOzS0o5LMsOLXoHjel0FXpJRyZHdT+iLSuNZS6jeoyCubi+seaOz43ayVNuL3IvilKDQb0QeSmap83qaRTeEpxf4cAY2g0nJWqhIzSg33tvYUrBowoGCLiDxO0jDXiElfCLWOTo3NwD2/Su/6QbdFXLGRo6dtg1u9zwDGIkBa7uzawJfbZLy4RLBVBKAT7YS5
 zVzfY74r
 1h3in8P/zGxyemHNbipv02Q20TvA9NUcBhNxFnQzYykQ5iC2UTqKgwqkEObhldctC9VMvVYPpk1yHrm4LtpDnhCTdC12dcB7xIYCIFeIoy9kLP5HhHQTmGU8GwnnXgrTq+VZJbdh8m39nWY8LxRz92YpZNaD6xWZNg3XRqCl0/aHHR4NJolmWj1Kmo56dfvWefNG8fU8zBgjvCdy8uzJEsDmsmyRdu03lKZTFqDo0UH7zs0AmYJW5Tk4obDpAA1ha0GhtDrsV2bdDvJdgQ8ZGV1ImNX0mO3hf+GSXYffXZ6PrM6s6scc0BBrXcEfnf86PFY0eToBJLlUD9KESdK28Wq/ZUrjA/fxQT0DoYa1Z4Z9EzaHXsEn9oUG9Yv1aAuju0wF9ZlCnF7sbiRSpgivgwUD+U6Y7Vo1rDQY+zDv9oIYCfvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fork handling introduces two additional parameters to help child VMAs
clone anon_node. The logic follows three cases:
1) Fast path: clone the anon_node with the previous VMA.
2) Reuse an empty anon_node from an ancestor.
3) Allocate a new anon_node and insert it into fractal_list.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/rmap.c | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index 74817876107a..93fa04c5a007 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -667,6 +667,17 @@ static inline bool try_untrack_rmap(struct anon_node *anon_nod,
 	return false;
 }
 
+static bool try_reuse_anon_node(struct anon_node *anon_nod,
+		unsigned long new_rbc)
+{
+	long old_rbase;
+
+	if (anon_node_rmap_count(anon_nod))
+		return false;
+	old_rbase = anon_node_rmap_base(anon_nod);
+	return atomic_long_try_cmpxchg(&anon_nod->rbc, &old_rbase, new_rbc);
+}
+
 /* attach an anon_node to the VMA. */
 int __anon_node_prepare(struct vm_area_struct *vma)
 {
@@ -788,6 +799,67 @@ int anon_node_clone(struct vm_area_struct *vma,  struct vm_area_struct *src,
 	return anon_node_track_rmap(anon_nod, vma);
 }
 
+static struct anon_node *fork_reuse_ancestor(struct anon_node *parent,
+		struct vm_area_struct *vma)
+{
+	struct anon_node *root = parent->root;
+	struct anon_node *node;
+	unsigned long new_rbc = vma_rmap_base(vma) + 1;
+	/* At least N anon_nodes between parent and root: P -> a1 .. aN -> R */
+	const unsigned int ANON_DEPTH_REUSE_THRESHOLD = 1 + (5 << 1);
+
+	if (parent->depth < ANON_DEPTH_REUSE_THRESHOLD)
+		return NULL;
+
+	/* Release from leaf only; parent is stable, no lock needed. */
+	for (node = parent; node != root; node = node->parent) {
+		if (READ_ONCE(node->nr_children) > 1)
+			continue;
+		/* Replace with the new_rbc atomically. */
+		if (!try_reuse_anon_node(node, new_rbc))
+			continue;
+
+		node->mm = vma->vm_mm;
+		vma_set_anon_node(vma, node, false);
+		return node;
+	}
+
+	return NULL;
+}
+
+/* Clone an anon_node from prev or fork one from the parent pvma. */
+int anon_node_fork_with_prev(struct vm_area_struct *vma,
+	struct vm_area_struct *pvma, struct vm_area_struct *prev,
+	struct vm_area_struct *pvma_prev)
+{
+	struct anon_node *parent = vma_anon_node(pvma);
+	struct anon_node *anon_nod = vma_anon_node(prev);
+	unsigned long rmap_base = vma_rmap_base(vma);
+
+	if (!parent)
+		return 0;
+
+	/* Drop inherited anon_nod. */
+	vma->anon_vma = NULL;
+
+	/* 1) Fast path: clone the anon_node with the previous VMA. */
+	if (anon_nod && pvma_prev && parent == vma_anon_node(pvma_prev)) {
+		if (try_track_rmap(anon_nod, rmap_base)) {
+			vma_set_anon_node(vma, anon_nod, false);
+			return 0;
+		}
+	}
+
+	/* 2) Reuse an existing anon_node. */
+	anon_nod = fork_reuse_ancestor(parent, vma);
+	if (anon_nod)
+		return 0;
+
+	/* 3) Fork a new anon_node. */
+	return anon_node_add_child(parent, vma, true);
+}
+
+
 #endif
 
 /*
-- 
2.17.1


