Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CDC606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FM7nupIb
Received: by kanga.kvack.org (Postfix)
	id 65E496B05C2; Thu, 12 Nov 2026 06:13:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6359B6B05C3; Thu, 12 Nov 2026 06:13:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572FF6B05C4; Thu, 12 Nov 2026 06:13:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34CA06B05C2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:13:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0CCB140531
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:13:07 +0000 (UTC)
X-FDA: 85426205214.04.05472A7
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 958061C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:13:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FM7nupIb;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O1ylWmglCLFhGDN08Z3QqHQULQGJeVg5Vw4Vd/T+a9I=;
	b=FIfAeQPJW8TBzyERErcUhp/IULf/fg54UE9vlvBmY5nhQJR1b+EP2dqk8iK+6MXBSWOl79
	bAfb4QybEW/BCFts2CM9SVJ/WSdSagX5zx2AWAuHp4BSpUj95Z2NklCOM6PfEhxynhGP+X
	HVDJHDnzV82/1cAdF5R653FLkP8px9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481985;
	b=L2fujct+wsZz8WeOcKmQwEq/TARrhjW0Q5tHnMf99ErMByByPkNSm5LTNNFou5hUMd052O
	zYv0uEwJpxMn9jW/ifwsMEH6NFy3AvuvBVKgArZ27/1pfickMQ62OSo0fhpI/ihPTHnxLD
	OR72Mgm/cP48//f3usMpSQWTczIE/Ck=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FM7nupIb;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794481980; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=O1ylWmglCLFhGDN08Z3QqHQULQGJeVg5Vw4Vd/T+a9I=;
	b=FM7nupIbxP4U6L7OXvL1srusoEdjIc6zCJBefwyQtZMYCShBW1UWdF/kb+eUTWjF0CbCHQnUEOxKm0mcftHxxV1zkoqInlPJ+zrzxuntMejRcXFuzq+y0c/BIBWeSEI0pR9o3Piyd94Z5IM6FfSrwXqCzuRPhHl8h1k68xZQTCg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEblyLP_1794481979;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEblyLP_1794481979 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 19:12:59 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com
Cc: baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: mglru: use pte_table_clamped_end() helper to calculate the end
Date: Thu, 12 Nov 2026 19:12:39 +0800
Message-ID: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1b5aws8a4a1hmbmw7giy5mea75n433rg
X-Rspamd-Queue-Id: 958061C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794481983-250066
X-HE-Meta: U2FsdGVkX1++9ZC1HHEUz0ySh6gJS/3QMBB2f6PbgPWnxXdxB1aM10FMMtlzuie6XiMfrURdDR15MbbiCvMj+TwE4W8bLQCtwTN7fMKkytGuBZLSSAANTl6D1TovrHrbahx1cE68kcoLI0CGcge1XFBXht0YPG3BvuaoyAlXkaIKosgLiNMDCHWDknR112cmgrD1yS5+1vJ1uUU2xmCD7V4PNzs6lTBkXKb+RVsenZvbPKWcs1n4WA6TAudzcaeTdQDNYbck3BlXrcUpZxkEBrGAhxWCqqjmPoDnR6To0YSSkbZg9l9LEBCKdJRM8iavKmsTEmzovkfeHK7ZKtF9bWlJT3T9zcxXJjEq//GcUPV89VUdCkd6KUytpht7fZre4xoHzr7uyP2X1YwjjF1Ty3g4t8DQLwIRfxRvLR57j1neHkkLSH9pFLavtl+orWiJlXyi6dHE5OUxFK/r7RDkw5WQNaCZYcrCDQWBI+YrKHmHOk19gHXM1hVrQPQDHHr1smvZfxwDI/3eOC/zLdoxRg3NkL2B4FbfqaV+OgywGUPay+OFEwJhEKt0+25WlsdhK1eFiU9MW0oBoAk+UU6W0bSGtwY6gWfE+ilgozsCmLtE8sJ0a7nZmGG55CdddgVUYC/QVlWPzDkHRWQA5ErvgU9IsJu4hRp9RSEMXBw+v4qcQapRlQy8yD/PpfiCYyWmYF9o6LzrWV4CQ/BBD3pndfOGKPfSl8apBSfI5m+HTS8wqQmbdXyx78zTBoQj/T0x7ZpTBShMfNzVytLwE2fUruBPJQ+uqD+2FDNh+mOFY/5lY4DkL3+x/d2c4KJs2GHYpiLFXG99QF1H9CD6+FZ6Jc6ke0pHFH5Q4qj2m33PhVs8WUDWW7UWzd7YmJ8pUYpM3CXdTfUq3/wed/DVVGg42D4361hyPz9Jb4tFILE9YP5/k9TxDiYtxzfk6vK7Q1GDtSQvSH5ULCazDQjL9v2
 2xEQn24r
 Ii8r7oPOkZwRi9+5fzaCl0l+SpMF0uIPJuIPFXLNCfWUvfr19YJw2OFW86rdC5wi7pIDTII1F3SG3woY9DLfOdFDqZ/s0jd5H6zHLKtfiAF2okV72mLN/TRIMIL3tuOFxqPskWyfD17zZbcVl7ULuIpzlbBvwMBqQnWOrxj7/epu9vEy5+1rsnyIuStTpVM62UhT7TlVv5DxEA5vz+lHhcnYi3esMihKyYXtMCcMiSXYVFHc9fn5qFP94ozag3gNGsh/hjA9rAeqKi6cErd9aYotclcV7+5GWF5swUCL5ZxrShvnW3nFgyNfVt+D1ALhH9/cRPxPv1OjWQrvM1+cL87zt8na2TquV5ZBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use pte_table_clamped_end() to clamp the range to the PTE table and VMA
boundaries when batch-checking young flags, making the code more readable.

No functional changes intended.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Based on mm/core.git for-next branch.

Note that this was found while reviewing David's series:
https://lore.kernel.org/all/c31cc8a0-c098-4784-a843-f13f51914094@linux.alibaba.com/
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5495d9be90e8..804d4188e7b4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4470,7 +4470,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
 	start = max(addr & PMD_MASK, vma->vm_start);
-	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
+	end = pte_table_clamped_end(addr, vma->vm_end);
 
 	if (end - start == PAGE_SIZE)
 		return true;
-- 
2.47.3


