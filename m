Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C451BC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C59EA6B00A2; Wed,  2 Sep 2026 23:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C085C6B00A3; Wed,  2 Sep 2026 23:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9FB6B00A4; Wed,  2 Sep 2026 23:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1BD6B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:20:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12C8516017C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:20:45 +0000 (UTC)
X-FDA: 85170998850.16.7ACF794
Received: from mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1865E40004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:20:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nwy9m+3F;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.208 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788405643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfFpq7qi1E57z4KSH04cloLxFwYPqR5dZFBTt0eGSJA=;
	b=dyGH6i9Lt+QD97ASwYF8SznC4cSVb8u6C4qY26OgcmWivxzE8UAa3LwlTrUg9q4NGudlWP
	jtpwA2mTg8/A6vZX3RNWf8OA19it03rNymKd6OoH9o+o3nAJZQ37VnVOfngk7nF2knz71k
	AZUdtal8V6NEnocH+FE5DbTK6fLQtaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788405643;
	b=vhRUicg0ir/VXsYOqDFpvAFDju8yK+Brrz2XNNbuhNli9a7QtZqd/+551gEsTRwK4WdSJb
	MvhBwJ/N0N7r0uguxrnlLiRiCBn3/k7iBg3ylzLKt4/TKxDChedjjI2Jjs4a0uch2ycVLv
	Fq0bugvlmJhSSDoPzlp4fXR2TRymg0o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nwy9m+3F;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.208 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fEx4cyQIe7jbrV6zti+QPYuHP8t/WPfzOFNbVO2zmy4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788405641; v=1; x=1789010441;
 b=Nwy9m+3Fu0pF46evUpenRZPGoNHxzzoB716o49bnng/0oAZZn3eOOMDskOeJhoLWz43xjEkf
 o3VTUePWINOZSN8wqxi27J5p02XF43nTdUOMteKQ9dWL/cl/qTnkwRPtZT5v0h4oq6xTPFb9FUW
 G/LWM1soUgyNRdLnBQeC5iow=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 530d96b07d063574;
	Thu, 03 Sep 2026 03:20:41 +0000
X-Mizu-Trace-ID: 530d96b07d063574
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in effective_protection()
Date: Thu,  3 Sep 2026 11:19:51 +0800
Message-Id: <20260903031952.1120321-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260903031952.1120321-1-ridong.chen@linux.dev>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1865E40004
X-Stat-Signature: 3qnk8ekhtxmgichxuyjwcduwpc4f8jjk
X-HE-Tag: 1788405642-600202
X-HE-Meta: U2FsdGVkX19QEHCN9bkpAZwTETJJ/+L86mvfq3WuUyjRt3NLzSwNvL2TYiNu21uImLtDW9aho0t1LausEFU6tpA0JFGiPHNsqNUbhR2tbd3CnRGX3t84cdQyApYldZ2TvwIsqIBr+ub5wIq13e6gxN0SQ3bSDg+tas4ne3Hn9VYg3W2SyZnGEiWh9WjKo19ILUhrUZePgEr97sZ1kdQBAEM02sVdkWkpXoMoU9anh7RApY9SdKrUp4JNLf2zII2WMn8oqU14SdbR2W1my5u5mkCJvx1Ppvii8pnj5LZ8HqoOvWcEvbtjpNIOI2wC6/N5efZ4183Jg+Kf8g8+Xs6m1UQpMpg4u3mAFjO27O6PxtQdT3oU9k8zQfMGCyVeAvB64lroNfECEoQY4VB+ggH8bgwHF7xGOZM+49eyQNv2TAhSpr5QrK1WS0HN0w6nzQgz7G65IWwtNIuhaYYd6EYD3/EtmXgV+/8P4fTw/LYRU+QPfUv9R1D9SwwxRhBNZzdJKCRcFrBc6KPeGjIEqtKfKU1kU+mYwW0QleF8YLJZ/N2MFysgKA3OthPN1dclb7yyhqzw5EVxZ0P8eKrzSyZatn6U0XnTpjnb4469SOFTzHQcrPVfr9mXZJSAUtQEj0IU420pfmGZ0eid5Cc+402Ky8RrH7YBlsOGfqilay8j9RIKw1Kp5at/tJke8UaYsBzrmefA7hD4IRH3l6gtGOUi7RJDBSF6W+wWTD7JsSKg+kxJPYEpvF4QpSdrVMO8R8PbgNnj3BMVVonTvpGqHPGNx8+6RPZShkTRTUoqkp4nRBDiTWLE6fp9Fr/Veujysct091lSqZc7ZDKfz/p01rqj74r29S2tYlubPX7oiE9ySpZ/6FqloS0iJfDs06zi2SXhRwx4N2J9yPh/m63seirHMSw5xshFveECTPhQtzrQ23Uyhj+OegQFBhJe9XkD6J5g23LKNYH+l8Jr45AfnOU
 TFP4Kjns
 iwPRseCkpRxox8FoU5pSDOWVJ2T/2dFd7GasGNjBzP0qAE8n+j8Zex9UYzs/myd5jUCazwsVjWLuvSgomzW0OHXAT9aIPUl0uhYltMT5Hpl7jEBlo30ymlpLywSUKxSmV9jVXXwAl1zak+/TjYT/JRFQLBgWMnRNvYUZMxCU3crfvNszrRNCh2/8+Tunm9sYaIy95l8FiZhLgYo9XJ0Tm10m9S+rBV8LcYkyts1XmVuvkc7/0LpvR3wAp/UXcAooP6NZziYMEspaz5T0IL0Een1ka9ILTnCzDOFXl+Fw+KCnHHx1I+sct0jb7RTfjiZOuNiUqw2l696O9iU39hTSAdOQbhWfR8dX1PLtMmH9bRuY/iKKaruAtKpQZg7SkuPRW22k/KGV8sBKSydEwDAxu5MD99v7UQDqawj5cCrsK9yDMJnOCcQ9K7+cHQtyTQEk8knVLoUYKdLvNeZcHqnZGFM3PiYM4aXNw/waSEF98bhFsNnBvk561LdsLowRvQsxrQuBSadjsIe5C7d2rhNpVm+odZUcgVHBh0tWAVs9+g45iFGhYsZNcJGvKyMR+F7jRlAtuHGz0UO0OW+GQ0qi6YvE+vNX+WhvSccslux7Lr07H8EhPLt3heBm4brHOfjKevQCmecudgWFhGY3kkacO5ZhM9DKP4BzIlC1ikTtM9n4my2kM4lnxaJEEAUgyIcb2cNRhCXlESLEXy0idCjFzMmjkkT/VcU0o0ob/+nBQ5qzsuq6JFyt6FrhN4//2EHfptkRCqa/O1ZMc7UmGtT1ad/zELA84rWbZw21E3YhHrWiQKkxhwqyIv3JDM8Yc5itQ7+3Z1BL4Gk77K2+qhYjw5Kao01irM5VcZMmeRQuUS6Fek+6vsfXMYiZifzlo4pVLG8c+d+J8EcqkZ1jVYGUYxqatX1Blzbi5jCHV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

effective_protection() scales a parent's protection by a ratio of page
counts, e.g. for recursive protection:

	(parent_effective - siblings_protected) * (usage - protected)
		/ (parent_usage - siblings_protected)

The multiply is done at unsigned long width before dividing. On systems
with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
protection value and silently breaking memory.min/low enforcement.

Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
usage and parent_usage are not read atomically (a child is charged
before its parent), usage - protected can briefly exceed the divisor,
making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
the ratio stays <= 1.

Reported by the sashiko review tool [1].

[1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1

Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/page_counter.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..e8bd512069c5 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -8,6 +8,7 @@
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
@@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
 	 * otherwise get a smaller chunk than what they claimed.
 	 */
 	if (siblings_protected > parent_effective)
-		return protected * parent_effective / siblings_protected;
+		return mul_u64_u64_div_u64(protected, parent_effective,
+					   siblings_protected);
 
 	/*
 	 * Ok, utilized protection of all children is within what the
@@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
 	if (parent_effective > siblings_protected &&
 	    parent_usage > siblings_protected &&
 	    usage > protected) {
-		unsigned long unclaimed;
+		unsigned long unclaimed = parent_effective - siblings_protected;
+		unsigned long unprotected = usage - protected;
+		unsigned long parent_unprotected = parent_usage - siblings_protected;
 
-		unclaimed = parent_effective - siblings_protected;
-		unclaimed *= usage - protected;
-		unclaimed /= parent_usage - siblings_protected;
+		/*
+		 * The usages aren't read atomically, so a child can transiently
+		 * appear to use more than its parent, making the ratio exceed 1
+		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
+		 */
+		unprotected = min(unprotected, parent_unprotected);
 
-		ep += unclaimed;
+		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);
 	}
 
 	return ep;
-- 
2.34.1


