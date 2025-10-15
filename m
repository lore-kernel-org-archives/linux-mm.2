Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2DA6CCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBB98E0037; Wed, 15 Oct 2025 10:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC2E8E000A; Wed, 15 Oct 2025 10:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C2818E0037; Wed, 15 Oct 2025 10:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED0EE8E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:17:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A77F140198
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:39 +0000 (UTC)
X-FDA: 84000551838.15.68E519A
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE81218000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aKAVAArd;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iZ7BeMnzrU1e9+p4OjWR3YwwcPb56sImdhCODq6Rod8=;
	b=YRsPw7hmyR6RTRM7XiS399VQS6yaJeMXysOKr1tt1uPVH9094TvrSgP13I4JBEe6utctjx
	JVy2E8/4yWBgr5C1hgilCaIywLnq61ivJUfqfdX4DEEATUjwxfqndZSowJkb0qb2dcKMFm
	vg23iUZdO5gvPc47QnJO5siCioB1k1o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aKAVAArd;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537858; a=rsa-sha256;
	cv=none;
	b=4h2JoSb9ieTvCknWLxl0NXH9BqpvFwBC1fACiJLvh4mRbN9IeVkVRQipV02gTBqWUhpnrp
	00HsjFW89BaOuojsXcSA546EQHYtFXYqEowuPRBiNq6ssfkWelH82yaga2hyRRPXWPSI7P
	OSjgs4+YUYsCrOZy7zomtnHqrWm6bXQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760537855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iZ7BeMnzrU1e9+p4OjWR3YwwcPb56sImdhCODq6Rod8=;
	b=aKAVAArdnTOebIr735llMuE+KqnbeIRRZePSXO6WEsPij16j3n+adLYs8Lf0RJaFWDgy98
	yijWMXePYsvbjygkeBIHYryfgnj9sB/LA7wqUyrc5Ur02GGCT1UhYavH59HFxAT9XGy7pK
	5T5Slus3+jqN3MJQuq455YGX86m2aQY=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH v5] slab: reset obj_ext when it is not actually valid during freeing
Date: Wed, 15 Oct 2025 22:16:42 +0800
Message-Id: <20251015141642.700170-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: edxa6uw4x3t1i5adgkbnj8bx8emt1ng3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE81218000C
X-HE-Tag: 1760537857-187403
X-HE-Meta: U2FsdGVkX1+BC8JRyfARlfEBACJtzGIGy9n3kNKvON80EOoBbbVbnRT+Z3mlRT+sUFCpzGo6cldSszl+bSUWX1wjEXVazRegtndGOM8UAGGpt4+fmnPCCfUgOlBg7GOkaVNytah2SL5b9q9Sh1+t52aKJpJDEifqCLu6VLSt5dKHZPLHuX3L8QRbcZfVxJqaD6BRhKSl+7FUq0pypXXQppcwKSjIsGsrvkOOzLFlqtoTs35s45sOo9w5myPtk8HuDP1D5nMHW4LpG8iuX2hh942gFk3MVG+xyf6NxI7SCtvSIkX7F4/igWg3PeR2iBcn0dfmmhM8ltbpZ7B6W5nn344HjGXUrsLzEryywTBgMrnKN8aAI+L5FueyXt4mIyfuG0odFlG6/6xsZ1jmjw9mHDd6FvmpLu50pXtU1s0VcN/+fNDb+EJd2b7BAKllvfawNJE45R9BY22NmVTnEk6pwbXC1th+tA0X5mbvekye46uTdDauvKuIjbOknFsSyiHYZF5xZIisnpsx5SqRgjuJf+eCTmHi4+SeHHf1FxYWb34HCHlHB6FrnxN9WdJJoMypw4Dq/1Yr7RepJjqiYiIt6FuNlJP379C4cJ6cvEkCe1Q05v6ebq7G7EhydsPyyzPoXYcpM3ghxeQbF5xV8ri1XcrRW2tOqEeOeTYQC9FuhfKeLBazIMRZUQ0PIKDzl68UWtT3iY28J6A+LCypZkP+3Add0hSKNpXI+jvlCxPmxwGKR2AREAbvS/1HwZB98NWSJ154aSe66OQMWmD1hYpMWN9O3fT28UQfF8j5WGdaVI3pOvclyfWYOm4L+4zNYS+Wv43hzAijDGaPn1ztgzXMyBxxhoo/0F81kEa+o86Sc1qaY9UumlmiMxPl2jKya4Gfs23CXDjG0phTGQfzjv6qM42g7LIx42Vml4jv/+Njhf7TcT6xeX2haZd8r9QQFnzET8xQ0Pef4zI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
MEMCG_DATA_OBJEXTS currently share the same bit position, during the
release of the associated folio, a VM_BUG_ON_FOLIO() check in
folio_memcg_kmem() is triggered because it was mistakenly assumed that
a valid folio->memcg_data was not cleared before freeing the folio.

When freeing a slab, we clear slab->obj_exts and reset it to 0
if the obj_ext array has been successfully allocated.
So let's reset slab->obj_exts to 0 when freeing a slab if
the obj_ext array allocated fail to allow them to be returned
to the buddy system more smoothly.

Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v5: Adopt the simpler solution proposed by Vlastimil;
    Many thanks to him
---
 mm/slub.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index b1f15598fbfd..2e4340c75be2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2170,8 +2170,16 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	struct slabobj_ext *obj_exts;
 
 	obj_exts = slab_obj_exts(slab);
-	if (!obj_exts)
+	if (!obj_exts) {
+		/*
+		 * If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
+		 * In this case, we will end up here.
+		 * Therefore, we should clear the OBJEXTS_ALLOC_FAIL flag first when freeing a slab.
+		 * Then let's set it to 0 as below.
+		 */
+		slab->obj_exts = 0;
 		return;
+	}
 
 	/*
 	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
-- 
2.25.1


