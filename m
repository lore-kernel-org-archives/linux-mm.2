Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736FDC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093336B0098; Thu,  3 Sep 2026 23:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0B76B009D; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDDA6B0098; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99D5C6B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FADE1C2615
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:35:17 +0000 (UTC)
X-FDA: 85174664274.08.BCEA7B9
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0F25140008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:35:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bBqSUasH;
	spf=pass (imf23.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788492915;
	b=7P2sIcZAJTRSquKeuAiFnSL4Ieqse5Z+FU//weXuEud6FG8HBs+9awdozn7iU6pMUMkKQO
	UwpB1AqL5/x8HBTIKmqsGe5AVmZdxynZBCZfkDVb5Wxu6pDgJuhoYOe+f/nbFC6LMmn/0G
	NBJnnj7A93m0O4stgBq2G1m9i3re+sk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bBqSUasH;
	spf=pass (imf23.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uxu22xj995mFVQr2+Ydau7ylOTci62Lzzj4k69xScho=;
	b=6vhtowBTb79yXG8v3sy1KWICmJHF9hX/amGVmujea9d6FoJdlQy2Bu3OQrfJoYFdbzACL/
	7czb88kvXtDNtmmm9TfMhNAy47E24GM+JNWV1OHvOjicjf1CI+4dPtz20CnpGybKYcadUo
	WaUvofuYprxy2dHgCs8tWZEtnjt2978=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788492910; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=Uxu22xj995mFVQr2+Ydau7ylOTci62Lzzj4k69xScho=;
	b=bBqSUasHjOYLFKUuhEm6an8pN+L389Ez9CdZsO9qnNZitJJwuRQ8X5Px5aApRHE0NENNL9G0BmIsS+CcI5k8H5iZp1p+QWHcavMhKNNQoaS/lJYF3druZU59gTj2+VJSq+Q6rIZsgbs96aqjmwMYN5DEHVp+ck16d41BadROwkM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XAHQrJe_1788492907;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHQrJe_1788492907 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:35:08 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH 1/2] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Fri,  4 Sep 2026 11:35:02 +0800
Message-ID: <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0F25140008
X-Stat-Signature: b18ufaa9r43niyq4ywf3ck15a7sii1nf
X-Rspam-User: 
X-HE-Tag: 1788492913-699734
X-HE-Meta: U2FsdGVkX1/hJFh3jW64wnYS4OMMfe53sg+Y/bwp8uq81jgzdVIAY1ibVlrRk0S6ASdK6ak1xiV/Zj21L6FF6kN94uo36uRUGRPZDVluR4QWvd2hS/gZohN+fvcLS1zis0/kXbVkjCR/1bK6E3SiadYcJR1GjcAJIzde+p/fLW6st7bw3kcFExSsIkcKs1IFElWWVTb01T5t7Fi5R9e0vuOJGj+0y+x4Uucr6e0Mix8WVRGaNM65CEq5Afzr9XpQeBVcXA1MA/ucZ6LgwIzA0iwa+ovO8YbwROXF8/cefzufOVjjkeHvzx657BrPLEIF1/m6+bZvO+PZ5/OCHryp4XWUl84SH691O4v+Yg8QZWovlIwlsEB3jnCaMvHVlMkJm88iNJhd2d6gtKiM8K3CLX2um6cDYRfZaORP3uslhjjaNktc44p2TB1QbTLM6J1OlMR0Kuduc7shXdbmfoVij33r4DteC7uMdyV2LXBdXWq9VsW2sJd/EfTictNJgxl+pTwvY7sg8qZb8Vt1OeTgAnFI7fs39lkTf8k2f6DXtnGg4et9U1pZtZwQ89to5mk3005vT29+oVVeoDuwD1j5HoZs4LUanog5idSWcKT/rhgNnr90FgTNCPp2aJwGHZl4maIhZNKtiIuNK58Y8a6MpXfLUo8oazlA09kXjLDITTZ4jQ5gBFzNU+rOQa0YwVXi6t1cfH+vvlbnGK+8Cte1YDAMK0/zJ1VmNP1cqAwpRs71zsclHkMHYJAC0gZIFiRuRiphIIXeXPXv9c3faw7gtl/YQevJEYzbnlgCkn2xXHcJk865Wl14FKvfxw96avABnQxGguXKJkhUet6u0CFv4zlFfq5qeLC5B271uNqDG6777qrrf8de1IOAeCJTAGpzabMJer8Hwzo1eDqszLgE68kVmrHP23CjG0TVgbIptQD1ZvE+sNSvEWMj9jZCULbSDl0Z7pj4ue2VPc8FkgX
 2rwA+UC5
 GfFh7YGcJXfGnhQLembpCxML3uUWiU9UyFhxW2ma91BvjQu98B0RfO1kgO8SJ0Pn3wh+kLkMClC7SiwscQSk/X+qZJkHPvTf3pxNSsffsiya5HT/WC8/MMod4tZpdi6vr8mJygpwtFzqUDYDnwqBKwvT2d6QTR+dCsdChrdnHvVLNgqHB/3fYHE/T+w9PpgSZpEyJXyWBT4C+IBTikTObgS80YzL6XIK0I+fho2Yi+V769Y0fv61EqqcOKq3xnQA+TK3NX/zQvNzMXgrLoRbLC829OwrGaS8HmX1QdofimnfqpHVsNWkhBHVDsyy4hSyovVK7Cmxsy2h74apIWZqb8ivAxQetzWG23wWanURcsz37aG6J/SxN8LwG5MTZwfknxIKb8R4H5EGqv1717KywxJC3Yq1d4mXGnd+8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a system booted with cgroup.memory=nokmem, the deferred split
shrinker is quietly demoted to a non-memcg-aware one.  As a result,
partially unmapped THPs are only split under global reclaim; memcg
(limit-induced) reclaim never splits them, so a cgroup under memory
pressure keeps its underused THPs intact.

This is a regression from commit fafaeceb89a5 ("mm: switch deferred
split shrinker to list_lru"), which re-registered the shrinker without
SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
precisely so it would keep working with kmem accounting disabled.
Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
nokmem and the shrinker loses its memcg awareness.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [1].

Restore the flag.

[1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 644d6905b49cc..16f9aa5b2d077 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1022,7 +1022,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE,
+						 SHRINKER_MEMCG_AWARE |
+						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
-- 
2.43.7


