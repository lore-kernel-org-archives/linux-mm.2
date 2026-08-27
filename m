Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E16ECC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDDC6B0095; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4C16B0096; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B89C6B0098; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7943C6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:44:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 033CDA0438
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:39 +0000 (UTC)
X-FDA: 85147169520.28.01F1097
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5291410000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:44:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c2ZK4nv7;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787838278;
	b=tsrFl2czobj6EYSYRu23efTlv8e+7EfxjoDCW/6Jly/c+IZHfVcd78cVVvw0w903fp5NMw
	SxrEC8xlugt5UitNFIe0km+5Sdcs3AR+s4+lnQvewfxMplQwANJQtGcvQPvrgvjn+oKJ2w
	YZ4WLk2xM0aaxpJmncC3rd0CC0J60O0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c2ZK4nv7;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787838278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNodYGFJor5NpRAwFjGvSAle8qKkp2eKVQXo5mh31SE=;
	b=XObICxs/kvPSMcX4jJc9OkwRQQ9qdd5Q5hR+6FKaBP5uNQ0yS/cgBBiTow0xFlgkAZJa6y
	dWxiWgSZiOjNEcQ3XBiUShKIe9U7to+GM2KeD6t8iNGACl4/CRMLnZARbB0xhtZqH+c9cU
	Fn1AJWlWE3iJ3PZnB449ZCGpZ0f7D0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98F9243A06;
	Thu, 27 Aug 2026 13:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3591F000E9;
	Thu, 27 Aug 2026 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787838277;
	bh=MNodYGFJor5NpRAwFjGvSAle8qKkp2eKVQXo5mh31SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2ZK4nv7SvHz1jwrCjfNf5ADTUUHq0mPFWo2aZbBBW+4Dhu+dIMawjlNlqEftD2uQ
	 RsT8M3xY0rSCT7nNWhkucLnCmoedxp/We4n3ZzMOBUv2X2wymWeofbCEflds4A3Wre
	 EcaKVi1uGra13UlcTUhe3P736azkwdAVRYFG0waKkwhg7AY+Be/8O1+7EAwcUzAcSe
	 m2F7AX8vBQXq3WdJo4m45h79C2ChapBJWjFeHmvsGQOALoeHQ+VOevIz0wVYMYj4FO
	 n2nfLplU0q5l+5YE1InCjx4VjIk1+fbZvqI6X6qXJNF1I9c7c1hx/7uvW7771R2FVN
	 +JZY2zMmyDrlQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/3] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Thu, 27 Aug 2026 06:44:27 -0700
Message-ID: <20260827134429.123023-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827134429.123023-1-sj@kernel.org>
References: <20260827134429.123023-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5291410000C
X-Stat-Signature: r1yns4uz3kkms4pp1bash7zm1er1nxde
X-Rspam-User: 
X-HE-Tag: 1787838278-462153
X-HE-Meta: U2FsdGVkX18U/srxZOot9OIPEvCYfOrd3aWVk4KDQMLJ8NZCj6v3Bwsz7pfBFYWUWg5NemnTMCjUk979N76BCfTq4L6QNPKWWlOzsPe+Gj19y83ijX3HgxF2HI7NqorekuoJ91oJDqSnd7oTRmZScdDOXdwvTgv2d3y8vmE/bqhtJz0DmnRfUg/IG6nDwxt3jsrOXCz6JhxZWKxS5UETxg2wTvpaiHcfPYytiz6ZKPF8+pMWb9KVhK6pm4wEYoUeGG3sRv4jX2aHZdDpGE1xvW7QhUYFjhPZZaIF6P1IyoxOnmSRbX7/480U9h+EB1D4U4PjRP76Tf9aJ7uX6XmdDrisUFSFIGJm0WUwMrAcJsVVfUONtU3Fb2HCgGf5fIDcObzHAXJz2BH4z+oEPcv269Sk/1WZ+p9lUY2KP7LjUAqcT+Qsh3VYTqJjiit9dJQbYfxlza0KgtJf3fLT48o18culQLz+0yVZ43i4Qq6vtLZyrLoqkd7nvSFofr/lixQdTJwAf3plpIxeZ7+SzJcJq/tGitAXaqdzrNBZ2xzOJRaz5kfCAgoVoJVU72E/U6eM0xxhosXqMWfEhD5H80T+kyoK+xguV0QcQFjMAefpUmClhQ/LIOyA7breZoHKTOx/ndL19a4YvisTEMNs/MlQtr/AHQ/LBEhrlP5XhGw4vVTp7/1xJD4nHEitSLhDR46GtqOm8culKhzMJt5DgZd/bUHCgM9JXr94q6bkDxqT6HhMwCAg6cZs9eDFkJ+BiGzEJStyqnMGKOQSk/RbZ9obXQmIyKFWe7+ar607yHnIYwyaHogOApRaazGJgT8/XJsEyjVMX3GP9s1Vhcqs7q5VZAe00tw+f4JqHr75hQfNjdkN84JeOVg5BeUnFbM+OgSk624RY7zAOB17e4KII9HKv/imDqXIOfIlp/DUauEj48hGKnHmTOHGdDhOcTUlrjlYsKItcAc0lrpJgH1SHjp
 7ZxwcRx4
 EwUbnagXe4LPN+B9ctdT0GHLwhCABXViTopr3QpqStpza+TsPV2dQq6imHS37HuqfnaoaDleagZarNZ8MHNSLe3Rv4hsDWl+N5bsP4+wtFnLypdFX7Dpb9Gztooq2Gsfx2TWGwzebj5pTDbN5pqB+CK9khMFcD+i2UjoRJizY/fuuQMpFGLbMnY/o1WU1dA4+7UZcsH0Rknd6/wtOz/0ukRBWyXBVwVlCwmPU2MomgtMZtfirt31vQwXMHkLJmMfCGMb5XAq+CIiXVnEy6TxfV/ghu4ULKXNLJyYtLa/zrWlJ/zQqA+nka0m4775Gw0UlD3Yo1+Yfq6Km0yFYxfD+5Ije1OM97qUljyBxMeJkLkS4UGpEG4wLIlxWaNMEF4IuOkZ1e001djowd2u/dw/Jrh9qTkEFrLaK6dhe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_quota_goal_union() is not updating the ->nid union field
when the goal metric is DAMOS_QUITA_NODE_ELIGIBLE_MEM_BP.  Hence, if a
DAMOS quota goal of the type is online committed in a way that it will
reuse other quota goal's memory space, the new goal will work with a
garbage nid value.  As a result, the DAMOS scheme can show unexpected
aggressiveness.  Do the update.

The user impact is not catastrophic.  No leak or crash happens.  Doing
the quota goal online commit that can reproduce the issue is expected to
be not common.  This issue was not found by real users but the AI
review.  That said, the issue can reliably be reproduced.

This issue was discovered [1] by Sashiko.

[1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org

Fixes: 9138e27a3bc3 ("mm/damon: add node_eligible_mem_bp goal metric")
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e5b6b1c6bb7b2..11b20a4a726f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1136,6 +1136,9 @@ static void damos_commit_quota_goal_union(
 		dst->nid = src->nid;
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
+		dst->nid = src->nid;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

