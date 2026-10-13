Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304BBCA9EDE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CAD6B0095; Mon, 12 Oct 2026 23:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4F96B0096; Mon, 12 Oct 2026 23:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4286B0098; Mon, 12 Oct 2026 23:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7965A6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:12:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB8941A0B2F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:36 +0000 (UTC)
X-FDA: 85316130312.06.6DAB05D
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C8AD180003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:12:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S5F0k88r;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861155;
	b=ps0XhlWQkqsFUQSG6XHRVOT50j4RQfYS+49efRnFih81qKm2y2lcr8Wek6DwViZ1qXw1vV
	UDFYTVBaSGfzN0YdFj5XvjmPiBqfXtZS2SmFYmtVvQORmLrXPoVcZLFHnFyc38SL3DMaBi
	men4Py3O4EOqnEENJNZEgVaqV4pWWLA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=S5F0k88r;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhdlXR8A75L7YeWWJ2AV4SzYhiaJarkmp87eHXPOcrA=;
	b=ZGf05IUh3GqlNIQE/Y6mAcjNvooZCDNJazqy3/ZGC4h9pKhj2NqJLqxecWDf/wzGHVJsPA
	lkc78cKekrtbyK7ufPLVVJ9fl3Q/qXA2buP/c7ICyRn5ae2JVWAzGdVJIcNvyo6yRs8L+J
	KgdLrYYrVaUBiWjgSZg2n5MUa5XGFl4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861151; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mhdlXR8A75L7YeWWJ2AV4SzYhiaJarkmp87eHXPOcrA=;
	b=S5F0k88rgBf+hdnM0/oGyAWVuzwn25NNh8uMVR2BlLkOyRPPcEIY8G+mj+BWq/2PZaM/wmjP++Ejmpe/edEYrjFAvrjbXl02O14qp8Ju2TTGgT0jwgEl0afL+94tqySRD0JYPCl5RbvMcm4GnPqyuE6pLNIrco0SSnYKytsKSro=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjdu_1791861148;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjdu_1791861148 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:29 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 4/5] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Tue, 13 Oct 2026 11:12:20 +0800
Message-ID: <20261013031221.1997194-5-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dqebxzjesazffdx5tem4wkt6johsqm5y
X-Rspamd-Queue-Id: 8C8AD180003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791861154-972417
X-HE-Meta: U2FsdGVkX18QJjKH4NLdUtJRtVqXp5f1txPI4wPbJUamfOKYxr0Dpvj+K4+2BzOMzO/z4rYmtpySK4EBCJnWIMGDydHRPs8pB2ftCBd/7xjW8yrPmacNhzaqQcc4Bv2lZc6al6ZiOkNDqTwK5BKPB9bfxPOcFRio/sIceOSYNyLMMAYHBjWBQjZfq6JRHa2A/dlQqJztilCuVJ0sfBR3MXQxtPcNcQsJOqgr2ZNW7IdiRJOb94hsaA0/opqpksp5ByEg77zVDZ0HPAdq0gVX1s81xknbZQo7KWgaWy2F3ESNdpQhFgEPXbhpA15lfXyZFPqBBDvm/drdwbSQq4rNxFQoEHJZmGj18b/ieKcMTaQxa+VMtEEUftgK6zF2Lz+7flsIFInVW4cu6FEL9ltMokehWNrlF2vcHyn1osA+yGwc9oj3XN16J+tUksaAhZloa+pzDzNK5pHxAbX1/gLM/ZC37aLWLi/ihRJM35Y0ySmXnyWSxyMsSFS6olvbOBoKs8OK173TFmarduaVBpw4SigkUaH3Jpa0Vs6D1GxQRywAvoCn9V9XnBJZbl5tkmTO4ZcYXvH9rcXEDZqL9TnFk7ZJf0WVT8m1Jj9LhbT3t9/dcAn1EaboUSEuLIA8hNQOYSXIuJPby+azP60V0VWOUvLMhebRqUcJykedi4j2krdLH9p/l7+zM/DE8nETuqlRTJBaiZNUee8q3cr3h8ZLvtqBnRrIvvHd13VWRnZT3efpGA30Bf4gNyVt18zn3e62OKlOIa6CbIkIJqqYLdvms8keXnyzI6J2wUzQdCPwWXjMvi/wANPN/AFuZpZ2+9bADQFzScdmu4v0RylMG5dprG8N1xVZWMjVH88S5nYGVmgVO73IvWtwhIfcCP/gIhktu12HLIgmxlL8BZKAQGwdFdHYIUG/RY7i6e2rc3mmKiBlTUwVgVe8dF8vpxwxQA8CCQseh566rxrbfdnEnaU
 M7K4Fz+M
 Xxe7AkW3wA5urKy6P+2zHb5/NGSELF9w1yeINyF9+C61pMk0wiPCOJL+fsBUf+d/VF+7rTILp7SEWS8/N9nm2ZrQhneUeWRs5PmWgd+4unyRes+nhDjba55pmIU0X2TySn7BP1e1v+rD1fSa7hT6giq6euaPL/NZvRD58RqDX/Y5laNiSROvODxOTjkElRAWZhqepHiK49NPT5EwJ3ZkavoWMdyDtIBg5Tuu3wNnyIvX7WOnu252eI0GMprZXuY7oFpMJqlsrref5SOmh9O7JaxM94KrazTRwGyO8EklYwukKNjul2tFGwry+Tztt+h2iMju+VQNcryOyMJIZK4rH4m8kSzkpeZl1DXgmgYSVcVMtL9U/bpHjpjTOVhc2W5/nl6I4P8SjRgZGkFa9TRqp+XTqFppmx4uqOigSrcbrOUsdRoIcUk+/UThRtnba1GyeTiUXrJEXDiEwN46vCZckvq6V0i+fs71Qbl0sX0Tmn8rr6WneCReLEC/KMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a system booted with cgroup.memory=nokmem, the deferred split
shrinker is demoted to a non-memcg-aware one.  As a result, partially
unmapped THPs are only split under global reclaim; memcg
(limit-induced) reclaim never splits them, so a cgroup under memory
pressure keeps its underused THPs intact.

The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32
("mm: shrinker: make shrinker not depend on memcg kmem") precisely
so it would keep working with kmem accounting disabled.  Commit
fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
dropped it knowingly: under nokmem the list_lru collapses into a
shared per-node list while __list_lru_add() still sets the shrinker
bit on whichever memcg happens to add the first item, and with the
flag set the shrinker would run twice per reclaim cycle.

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
the shrinker bit identifies the owning memcg again.  Restore the
flag.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers".

Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a62d6592af7e..4ddbbdbfcc2d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1059,7 +1059,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
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


