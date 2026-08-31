Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20449C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624C66B009B; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCE06B009D; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB4C6B009E; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECC96B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC26BA0141
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:07 +0000 (UTC)
X-FDA: 85161731214.28.B203ADF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E2BCA4000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJxpLDdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjxFgW2qNu2RQvNA0pBq7+cQKGiXodxnzF3g5CFurUE=;
	b=jzGsrQAU/YUPkAGMLVVwDf6xApweq9jNpO/HPDlZ4hEv2Zul7VfZv8u8YGV7CKobCtIewi
	g4AmrXkE/r/vbDRtpw37Tu66ODIIFZbmdO4+7UHzHgTvfCmNzMLnr0xZXNzpwTveoxuMTm
	eFkKUdvKr09/R6qlpJM9qQ6jYtxObhA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJxpLDdV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184986;
	b=5spyi+el61/BvTxXyRCFu/fMiNrd6w5TiCMsU9xWCQONhpc7vYrhWHohwleJcuvJSbQ7az
	QNI+w6tkQLYE+CGzWSMDHVGxVQSleLggAb2nGR8Keq+9wbl2Qugm9LSFFpQLdtbtXL+RTJ
	S5qcujNSSdbeny6ppDpLtyJj4CeTJCo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FBFC43B74;
	Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3581F000E9;
	Mon, 31 Aug 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184985;
	bh=wjxFgW2qNu2RQvNA0pBq7+cQKGiXodxnzF3g5CFurUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJxpLDdVlPHJRD4OBQA0YEmwv5RdeoyTODGHJk9zi6EAtfAJONJ12tMhjaLQE1cQS
	 K0bCOwsuKK8My/5RD8Dac+hvm0QNFuUtBB4m122d1FgrK+mIhgUwZosoipv0Vb+FDk
	 d83/CCEP66tbJ5ezQ6GmckTsnB7MUtDz+QoTH+HJwKTBoI0SJjnQFAMf+uBGViCT10
	 TFjkYPQk8HRnfu2IMh8OxjHkCxn4BQSV8vhx2rvvdORWLOJP9dSfrF+KTHkEJhsxnG
	 2ZpC9BBom8O8JJhlIWu462KRFCinaOzmClyX0wS8idLOa9EwGr2T4TW5XeOPHQn5di
	 DtyQk2vgwPyjg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 7/8] mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Mon, 31 Aug 2026 07:02:46 -0700
Message-ID: <20260831140254.72004-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2BCA4000C
X-Stat-Signature: togjknx41t483htkttemtk3mddkqb3af
X-Rspam-User: 
X-HE-Tag: 1788184985-880734
X-HE-Meta: U2FsdGVkX18+GEqQARkbgKdOsUfAWQBCgtI8yH7W5s4yJD+14AQp7RPYpCLsjkk8+ihZIwVpQgo5EJmsQUb+9jacTQPLjQpBc0oTfRRBtC+RN8aCqFPrtkZFYy8BCj0W7dnJfAlJwTocTl9IV3e+V0sFFsE97/yBLa0kv4GEs798Ylo6F7lJD0NSqZpB48fBGeYTgSxT8mRl9qdKR2sraeGCXa5hdSPbkNZgaUx4tC3Ywget6faJVNJH0LW/Tvq0hOEUNM9hIMJJwT6lECrRO2Wmet12PFT90R79DcQam+rtsoP00Ik4kR37XZwJZUUPC2AxP0OzAxJPRVAYfCYQkma838mqemCg6Wc45iw/D/csCet7VYztaFUnfNCsuNtctnhKEH6blQg/khn7R1hWpoifjaBHqNtKHKhbu0Khm87z7BzAS6wJ4quq8Wi2qB9U5T1/vCysxoKMcI9KJgPHZ28SFjyCSdtw45Jz1iwAfO/UtuhyFANw91TkiBvqc5aqA9cLGxUcx6FvZn6fMghgv4vCQHeJIblF49QgaFn0LPc5T+oXDcjt+4nnDGR7m69RQdDi9BK0u9xFcUKs1+lUcemHR3JNgGJDVYbIEUU7sJ9RH+do40zoLaDAkS2C/2nFRbnGKCpkYCC0IYeRPNRrxF1haTzmY5jOYwuMjOlExmt8Rj6s7atKZGpUjxT3t2Ton3FLDm6q4IMLHnlE6eUnsn0lIdqBY7zFabJCaIjHRWk7SBS+ss60Er4pP+uo/pdUgHlf2SVIo9NAQd6uix5pCcmKIiQwOK6FKCWkLEe30Xj7v/qZyWIR0foUADCiFM79kCnb6FSvbddTfVm89wf6CZEEjBYJW8s4jmrtRP7UAxZYZvE1gA0h2gXuaH/Y3RoJaWZesBhflCpjB36ugBQErU7T+uV1Px4JentgcUUi5hLYZbb3/25NeOi7J3+Tcm+JfNNIEfNRvPhdVqb5Hw8
 7CNdgrKc
 DfeC1znzfjCmUUtsOyagA55+EOrdVB2oU2FgYStSVOqsUUwaqCN/VWimw1UZLU2gLjgErifg7tguzC0XFnph68UrWSHxsBtNaIWZTbi5zmnB8s4S0dP1bsxEEKq8pHnVjq/O/RAWNY+cTJdRvRplLMAJPYNkv0K+eUwlKhnkunsb/wgHJO4rClFPrUdKWSsZU1POZ4lsd4EWd8TFUzkw47ziT3atmYwDH1Uuuy5ALZN3x2Evsv2+QEvQM3HevLZ29aW+gzFywQpqPsNMG1ZNSbj6AaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero,
or return underflowed value, respectively.  Handle the cases by
respectively returning 100% and 0% for used and free memory queries in
the corner cases.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 75d71ac09515e..3779a04753061 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2863,6 +2863,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < used_pages) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+			return 0;
+	}
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
 	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
-- 
2.47.3

