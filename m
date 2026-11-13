Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4D560A6F4F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I1kRu6x5
Received: by kanga.kvack.org (Postfix)
	id 5F38C6B05C5; Fri, 13 Nov 2026 13:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB1E6B05C6; Fri, 13 Nov 2026 13:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492F06B05C7; Fri, 13 Nov 2026 13:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25AD26B05C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B05A8022F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:32 +0000 (UTC)
X-FDA: 85431001824.20.10A7858
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 59D5B20009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I1kRu6x5;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g6Eh7AV/JKMXLoOZYMqKzMkw/bKKMbo74UOatYbLA9E=;
	b=VCQC2YkmfRcph02ahIFbU2RS+rDns1A8tWssRpsZBCGH6evtHgZBmnqb6OJaDs7x6mwsN+
	TRzTCLU8L+3jwOz44YT6kQAlrGDHdUr6rnBRcrU1+OdiHMzeuuAfzVTzF7KQaam9O1Yn9n
	U+3fqxRTg1WLe5lodYdU+kZnqbf/SsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596190;
	b=eOaPQWWMEKDH8ydWEY+QsNqw2nbU6EmAZFubwgp/WLA36/EIc5O30Qiv9gFsMjWxo8/zzx
	OFFuNtuSMb/nip2psVtSmeMsEhDbAlhXRYM+DtF5nFBIMbF1m2Dnue/sH0OZq8OBVe9T8N
	shCqJZl4onk+rlBH/iGoMIuXrqUs9DA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I1kRu6x5;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2D8D400CC;
	Fri, 13 Nov 2026 18:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B291F000C5;
	Fri, 13 Nov 2026 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596189;
	bh=g6Eh7AV/JKMXLoOZYMqKzMkw/bKKMbo74UOatYbLA9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1kRu6x5DS/oaFLvEsjQ8qb2eKA/xxW+Vm0JNZ0pKFc2IH3MVbojchyxDot6deHTO
	 wuUZNe0AbVzdLWbMscW9i+zzuJavWjcTOFdV1NBlCwtK9ACxXdyNhfFFc0ombsa7cy
	 ZMAfs2tc7AHwBoluCxpvhCHylkW7MHBzfIA2E5jiv5kYqj3dMg6+GrinpuGm+0wjaD
	 WllZFJ9QWePC05p7TDGtOmO7yzAoNanzKWoKMczLP7qIwl3tFESKF93VV4YxFPofGL
	 QiqISvU5U8poztYgdptbrlykgjWI3pz2rNBcDhs8rRf0W23jAH/6DtN4/raa9ZXnF8
	 ynQX6qly5SscA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v8 08/16] mm/mglru: lift youngest gen protection for higher priority
Date: Sat, 14 Nov 2026 02:55:33 +0800
Message-Id: <20261113185541.70203-9-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: bt1rcnnk6afho54iihbpe4ndmdjdw7o9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 59D5B20009
X-Rspam-User: 
X-HE-Tag: 1794596190-104950
X-HE-Meta: U2FsdGVkX1/xo9GVtThbcL02fA8nTJz+ViEQNlfJTGntyraS9NVoYZazLr8+TyawExtC4meIRdlBDTIUTQRVJvBzQP25B9AnLJb10YqfI/+LZ53G7bqznMHmUJ2w8ue/aqjw64mN/pfAqfFcuAe25vF/K+5n+mGSsifqFlmPrQuR/LESwwlKoy8tra/jJHyahvHDc+ZKwaEpqwDT/SVjINS2ijfchayedcFhslHFrXgi+f4PsLZWxTHt9j+U1IKpi1vY+nJzDJ2xzhiz7y3pt0o0aOgudWOt8fW91VBHh4WNlqUKIpxdo7nvhsT72FJqZHrG3JfY1we2CmL9J0bgasKxbtnr98AzpH1OdaZ9NXnmJIRk7GNQEwrp/+mwQY/rQs+XKdEbi2GkwttqAu8JmZ+U10WVmU7V7wj6FLLmGdoTi5bOBZOk5XrR5ic/TO+eVmWT6COanFXsCDbmiT/F6JXfs6L4q7v8XuQEENs4qHzbvmdJgguNTLUZbF4Th1E/4i+EvhJqfZUjzd0PYmlXJVAePKernxMJyZ2Crfmd/1Ndj8anBz3fJn+e6XARkKqbIJ0aCVn2IgJyr8+7V9hi03WQKOySKc11sgdNUlLGhrM+s4ps0UzSNzV6vSFHdYhnpMQ2L3Om8HJbEPCZL7KDeC/FBGBLrrDm1JBekY8zDLCGjwR8dXTJIxHrH4EVX03DRz8NfKAorpdp250G+IGrG3NZf2qWA5dQgvbj8hdJmcFcWG6Kn0rYtuoGBYFZfF+zr2XGpopintuuzqK/KFJHaAjHpoLVQUxukfFiiBhjwTOgJ0WdIrB+ZJNKAaqXg7lOBqPizJ0jF1bPFwZ/UDEjlat4Rb7ZFedksZxKyJxmtK6WPUtTpm9CjC4ZT+uRZixbYuL+BSluyRVhz44ybIOrn+TdEh38f0YJ0acnl/lRyrt8i5aNTFFk+qib5i5uBB61OjfIUI9JuZw1Zd+KgH0
 EH/Mm9Ff
 EmVnmc2MI0o7YBkK5kJ23N5bSpCBTYKcaoH6Lb40IwM9nUld+B8L/V21aD7J0xh2dCZE2jKgyVJGcOj9wWWSHU3iWmsbTzi2H8/qRk2u6ylkW+0udHD5CH6EhSIHRDOf13jpnT+yfGMpY8kJxjgA7yuMyk9W1abm6mwWvnKgz2IoMpUDyQYAAXevqlEjT8QAyW9Y9D4hkD4uzUql3XLGxKw+lu3IsDNv/ew/E/qcNQqMlFbHYM3y1XTnnQjjoCyOamI3IYRHf94WdeKBQFjj4ukmcRcHTJ6pl6CTVs2hiNB8ylb2y2iKhR4ZlfBmosIkDFwDfHkph94CyntaIFL6HLe+qAv8JXybhKijo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The forced protection of younger generations contradicts the
goal of minimizing the I/O cost of reclaim. Under high memory
pressure, MGLRU can repeatedly trigger premature OOMs, while
the classic LRU does not.
The problem is that aging may fail to keep up with reclaim.
When this happens, reclaimers may all abort prematurely
because they see only empty generations or just two
generations remaining.
Proactive aging does not solve this problem either. The
number of threads performing proactive aging is limited,
while the number of concurrent reclaimers can be much
larger. This is a fundamental limitation of MGLRU. One
possible solution is to use an aging lock. However, the
aging lock introduces significant jitter under heavy memory
pressure and has been reported to cause noticeable lags
on Android.
Furthermore, the generation-based reclaim model can
conflict with the goal of swappiness, which is to minimize
I/O cost rather than blindly follow folio hotness.
The previous commit allowed reclaimers running at
non-default priorities to reclaim up to `lrugen->max_seq`,
while reclaimers at the default priority could reclaim only
up to `lrugen->min_seq`.
This patch further refines generation protection based on
reclaim priority. At the default priority, reclaimers can
reclaim generations down to `lrugen->max_seq - MIN_NR_GENS`.
As reclaim priority increases, reclaimers are progressively
allowed to reclaim younger generations.
With this graduated protection, premature OOMs are no
longer observed, while swappiness is also respected.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8a74e01c2390..8e0972db35da 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4772,12 +4772,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	/*
-	 * Respect the gen hotness distribution at low priority to avoid
-	 * aging and scan cost, but prefer to satisfy the reclaimers request
-	 * when under pressure to respect swappiness more and reduce IO cost.
+	 * Respect hotness at default priority, and only reach into the
+	 * newest generation when under severe pressure, so hot folios are
+	 * not evicted as soon as priority is raised.
 	 */
 	if (sc->priority == DEF_PRIORITY)
-		seq = lrugen->min_seq[type];
+		seq = lrugen->max_seq - MIN_NR_GENS;
+	else if (sc->priority > DEF_PRIORITY / 2)
+		seq = lrugen->max_seq - 1;
 	else
 		seq = lrugen->max_seq;
 
-- 
2.39.3 (Apple Git-146)


