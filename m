Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43270C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555246B00AD; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501A76B00AC; Tue,  7 Jul 2026 02:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049C86B00AC; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85D6A6B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:40:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C82E8D0A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:27 +0000 (UTC)
X-FDA: 84961031694.13.1FFB770
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id EEC92120006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:40:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406425;
	b=Zw1FaWA0txBJMFRPmn0cZdYzwRBtL8jccjbjyqNS01dWLLcJh4Exy4sboLFq2qwNS6lqze
	ytGMrLPgJ0FD1dAq3aXdYzD+IpWNrOfToeFojj4hhc/UBXutmo0vwauMMaTIIeah+4EOVu
	HKotp6ck2kyqpdOBnsolfb0SLMA2y20=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FRRK4f/zrFSd1ApU2vFOxcUuzg8U4r+0vH08hhiwR48=;
	b=OmutA6hXeNjHUgPjZuRu/tTlJBluzA/eK1EuYM8jrqbRDrzuKIl7rhe+9uxLo87uErjRO8
	XNj2Rktkk8dyHxpS9/lhckUEs7kDmfLqE0WSIBz8wIlm/Yt5NUo9XiMg8CZFjfNpPVRAm0
	jo4ka1FkpF2iE3wqpRPlvgq+Ov6Dquo=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gvWnG5QqZzYmSQd;
	Tue,  7 Jul 2026 14:40:18 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 7 Jul
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
Subject: [RFC PATCH v2 04/13] mm: implement anon_node_clone for ANON_VMA_FRACTAL
Date: Tue, 7 Jul 2026 14:32:59 +0800
Message-ID: <20260707063308.29176-5-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260707063308.29176-1-tao.wangtao@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEC92120006
X-Stat-Signature: sy3u4mjzktti8t6ni6yj5494dsowezad
X-HE-Tag: 1783406424-456162
X-HE-Meta: U2FsdGVkX1+J/3K7vTPMcQVGUcm+yUoYhSl8L+FO1bMOQYKc5tr8n17wqei3kq50gfQTjhNu7eJw8z8GwFe/IF0gafzvBr+ygOrpbBv+uBbqAcMrqHfOMEx2CRjb5FZD5XEfMWb0wkkWwn9gYKDXETczjdvRT2T7NTRl2wTa4oRCFyIMSuZn8ewOtOnIUeO0BThHEveNsBS30Lol5OFlTffCSDo0BZup723Oz+VxR0t3HUc6rqE3XreUk0cbFoFDBe4tXXNNrvZUT0kkEQtuwHmKaPNrwKxMcxRFbvMzz7JmxbQhkv5NuM1H+s0EgOwG1Xr56SV7wE0bOCUjhR9yKd+o2XOO60dpihTNyofScsv2UNkd5yHdD51HZUY9HWgZoZs9Zz8/Kg+ZjRCBTnOcBzydak8sc/K98+wo2yyWVloR0sYYgSEmzgbkUNfP6TGJmDAbnvwUnr5Cn0DhzL78mrsWI3thav02SkXCvD+BagP6+XrSmAXTzuMrJlwr2pWmH/ExfjdpW2jxC4ZKW0d4gSOvE58rSxNhAxVKRm8ospD5elQ10M7nWCfCpU2lPky+B3OgFdCczSzFBQ3AXF63NhW69PDrGVcYEOtibCXMCmNTw2TNEUjdG0N0k6TlAZsKIMjzsJpW1t2CgYA4J9kcx5Qz3rwMgLRb0VUNYqtEbY0PmTItSbJZdEApQPfQYyh9+WmELATvUfKmIvlj0zYd4BJqsXXbfmbtfUuaMSiJT0PdjnLPY31TKcl0d/M2yB8Y1Gy39lcP9Jz0jWWg4cwFy35wfW/TBsDrC+aqfemITCR6GN4jRHpPDDaRHPUjA5kUk1krAoI3jveXVbrhACzPntZXzLu7+yVUT0YJEpPa4dSnnOBCDv5TCQyB8L90jijBBT647zLUyXVrXDPf4AjGdW0xcp+vB/ua1AsI1/vwXW5WgiJxyA3Ex7vtl2rZG99eqxs6rrN4/yziP77ViiG
 TjG6vpzR
 0mTcVyukbZZ1MW6GaNm8z+a4SSatsPLlxlZCDGq/sOtFfTxXIXWPgeXD5yL1bhOE/FjpwWfHs0xsHTcKzf48yet99aF6l930W8YPOfX481vwyCbrjfdLwquPFrJKAS8WFtuI9d3Nwsvc3PD9Z8xLxzwbuXraLss/vL1Dj1CK+ZOjKQICVoQMN0OGmJ3Nr9bJZm1qpY4STE6tpkgUSdyXDhR901QJh3mTGY7y7c0c5bGo7igXFIOf3v3hYT2mHYf7tyExLUGxSd9NFMpOQvpbrD82+F/0RgNJm/YN5sKJTLWm1Vfz/abaRi9JcIzGYJcEMKxBHbX99AKGnsSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using anon_node for tracking in anon_node_clone.
If the VMA is remapped or the VMA count exceeds
ANON_RMAP_BASE_COUNT_MAX, create a child anon_node.

Newly created anon_node are inserted at the tail of the rbc children.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/rmap.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index b98ba6a83272..74817876107a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -703,6 +703,91 @@ int __anon_node_prepare(struct vm_area_struct *vma)
 	return 0;
 }
 
+static inline struct anon_node *vma_anon_node(struct vm_area_struct *vma)
+{
+	return vma ? (struct anon_node *)vma->anon_vma : NULL;
+}
+
+static inline void vma_set_anon_node(struct vm_area_struct *vma,
+		struct anon_node *anon_nod, bool is_locked)
+{
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
+
+	if (is_locked) {
+		vma->anon_vma = (struct anon_vma *)anon_nod;
+		return;
+	}
+	down_write(rmap_sem);
+	vma->anon_vma = (struct anon_vma *)anon_nod;
+	up_write(rmap_sem);
+}
+
+static int anon_node_add_child(struct anon_node *anon_nod,
+	struct vm_area_struct *vma, bool is_fork)
+{
+	struct anon_node *child;
+	struct anon_node *root = anon_nod->root;
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(root);
+	struct anon_node *rbc_ch = anon_nod, *next;
+
+	if (root->depth == 0)
+		root->depth = 1;
+	child = anon_node_alloc(vma, anon_nod, is_fork);
+	if (!child)
+		return -ENOMEM;
+
+	rmap_sem = anon_node_rmap_sem(root);
+	down_write(rmap_sem);
+	/* Add new child to the tail of rbc children. */
+	while ((next = anon_node_next_rbc_child(anon_nod, rbc_ch)) != NULL) {
+		rbc_ch = next;
+	}
+	list_add(&child->fractal_list, &rbc_ch->fractal_list);
+	++anon_nod->nr_children;
+
+	if (is_fork)
+		vma_set_anon_node(vma, child, true);
+	up_write(rmap_sem);
+	return 0;
+}
+
+/* Returns 0 on success, non-zero on failure. */
+static int anon_node_track_rmap(struct anon_node *anon_nod,
+		struct vm_area_struct *vma)
+{
+	struct rw_semaphore *rmap_sem = anon_node_rmap_sem(anon_nod);
+	unsigned long rmap_base = vma_rmap_base(vma);
+	struct anon_node *rbc_ch = anon_nod;
+
+	if (try_track_rmap(anon_nod, rmap_base))
+		return 0;
+
+	down_read(rmap_sem);
+	while ((rbc_ch = anon_node_next_rbc_child(anon_nod, rbc_ch)) != NULL) {
+		if (try_track_rmap(rbc_ch, rmap_base))
+			break;
+	}
+	up_read(rmap_sem);
+	if (rbc_ch)
+		return 0;
+
+	return anon_node_add_child(anon_nod, vma, false);
+}
+
+/* vma clones src anon_node and increments the count. */
+int anon_node_clone(struct vm_area_struct *vma,  struct vm_area_struct *src,
+	enum vma_operation operation)
+{
+	struct anon_node *anon_nod = vma_anon_node(src);
+
+	mmap_assert_write_locked(vma->vm_mm);
+	if (!anon_nod)
+		return 0;
+
+	VM_BUG_ON_VMA(vma->anon_vma != (void *)anon_nod, vma);
+	return anon_node_track_rmap(anon_nod, vma);
+}
+
 #endif
 
 /*
-- 
2.17.1


