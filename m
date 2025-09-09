Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A983ACAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3D18E000C; Mon,  8 Sep 2025 21:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B418E0002; Mon,  8 Sep 2025 21:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2DE8E000C; Mon,  8 Sep 2025 21:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAAFE8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:33:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 807771402B4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:33:44 +0000 (UTC)
X-FDA: 83867989968.25.2A82368
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id B85D740008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:33:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L8zBqe75;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757381623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nPrjw+yWiXA2jqCjKp2szrgMz+ikmLfEyUEqqnW3/tE=;
	b=rTrfgs1RhniyOcFeX0P9CNicrPuUXx9QvI9tzc+lbCNTxz76/1QGb5WD3h7sb6gtj1y30n
	4Vihrp29u3XVdwrqoa5MosEAA/CBhyUicVW815nr2flMJizuwXqC1+ST0uRih6mEGuSv+e
	Ss6wNpt/H4J5U9ynChn5dBm9ipHErpw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L8zBqe75;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757381623; a=rsa-sha256;
	cv=none;
	b=n8FRG2Gnd2RbPD8zEpct6diaGdkC8DH3CV1ZiYcmF56M0WUJ7R2id/EAawM8gMLvXfs8Iv
	H0c3bGbBVoFappzCicPmoNOTr/Hy2R/zJl+xx90lqiYQ5wUmcgVsqshgNfvYPOvfoM+ybk
	rOib2FZ5F/ohvOfNaJXC9BmqZ8qmVrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757381620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nPrjw+yWiXA2jqCjKp2szrgMz+ikmLfEyUEqqnW3/tE=;
	b=L8zBqe75u9e+H42HHeKY6T2Xwg7oPo48e7HJ+tmXqGyegccyNdeIUHbnv+c7e/lfv1NSl2
	0Iwpr81cLe1xbJNMZtZzOghSfPH7oZCicCS76tyQBpVa2UophFUmZzGsoNSZfu/7gAtk7M
	8cOeNjOQt7tBTLCpujbAllSc6PBSRjw=
From: Ye Liu <ye.liu@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Harry Yoo <harry.yoo@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/slub: Refactor note_cmpxchg_failure for better readability
Date: Tue,  9 Sep 2025 09:33:07 +0800
Message-ID: <20250909013307.1093853-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B85D740008
X-Stat-Signature: w9ddmhb1jd7o7z3z6kdst8ujzy9qkfku
X-HE-Tag: 1757381622-195841
X-HE-Meta: U2FsdGVkX1/YbjboidPbTfakCXhdh16kFdPEBKqo9tq1AU8uf73mjL+8ZVjZGnXQOMhAzB1bZWu8FOd95SYoknlidlw6i5clZFesY7SY4MB5XM6TlTmn5eVC8KbJRVtwoD3hchBVbUPyO4P5s6SeMNQkKa7wg5sdUWTlu8Ge6xvpYHf2OmAb1bfsglwd8C+zIivXNi/7fCJP4ERU4+FlV3rP1wKbrvLTEZ1tjOAbUEFPCSuyqMzgj8jJhqy3nq1zZ503f2y04n7DhbzggAuBzrTlOER2NAjQevtIV+DhLR9E40stJxm9z9yMSaWvpQwn0MoEy89y81BgMXezaVHVNw/xY9nXT03Gh/UKXtSUcYrlDAMpkpyG7u5vAVR/jI52AM6MtIHrmwFziZ9lcs58wtogYijBV9yOScY8Uv9/nWKa/CacOWC60/DQ1Q/ku7uTpESeDbV4jMEQhmcVpDUHjp5iP99rZzNiN6kY9Bq1993ZubaS9Cugim1QtztrzsQTi/f5q+iRFIjkgm9txOikpYg6BQ98NZtuTQaatMjANluqpYRhXjoprMwMgp26xsZa3cSAcWYDjJwLUVyPHVfKHEEL7YeQp5IQEaGir3d2OP/QOWGnkIycOKG5xhT0sg1N9iHAB85G0xPcNZMnPMBzBjxmgsQQzxYt6oRvdoFA5wKhlvSswUrmxpuGzmfuP0wueSA7+DRM2inTsWSI81F//Md1htyqv5Y8r9UlRMp4wUON9em+aCWYrITVZycf+TU/ohIaa0ajgShTWdlZS5zm68QOAhPsFU4wlbPry9Fc0LegkTC4Hkzjlo1lzI0SiBH3mikukxY2yzhdxrUlDUftCh9jkm1YakPq6TW5620fGIEo5H9GRxqSh92iwu0RkHigq9+nvxOyi11ZVVovLjcJsnDju/xskOqwNByQPbW6aFcnFD5gV+x5NB+NvnsS77EZizeLFNAkhZKLJquyJw4
 6fFLBYOj
 i5OG1YW96WnIkapc/22HFShPA0LFvSIJaVh/9KwQd4i9nn1Vh2ob65tr1uGvGP7DJEiS6yoeH7Hbr8QAbbQ84z11YP0kBTlf+u09tVTtq0mzyzOFEYyLy6EXEtxLGhkoQek064EXjfjl0CQrFWHrlF+2g3Kvgm9BIsDanmpouRVyrPy0gUpsNxl4NWjGr5GezzYpDGM8BUN3N97ZPinLIQnY7GeLW4pGaWzSfPISnIG1k8LHNSfSoOx0srbmdzwYBhvEIMGEzOo1zpbh1IIApfjZzM2zdLaamevpBuElm8ndbwx/9KKNLj5zdY27wWm34WYh1SMtBYh6lpJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use IS_ENABLED() and standard if-else to make the code clearer.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>

---
Changes in v3:
- Add "---" in front of the change log.
Changes in v2:
- Insert newline after && as it's more than 80 columns.
---
 mm/slub.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..5711d6d29a3f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3064,18 +3064,17 @@ static inline void note_cmpxchg_failure(const char *n,
 
 	pr_info("%s %s: cmpxchg redo ", n, s->name);
 
-#ifdef CONFIG_PREEMPTION
-	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
+	if (IS_ENABLED(CONFIG_PREEMPTION) &&
+	    tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
 		pr_warn("due to cpu change %d -> %d\n",
 			tid_to_cpu(tid), tid_to_cpu(actual_tid));
-	else
-#endif
-	if (tid_to_event(tid) != tid_to_event(actual_tid))
+	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
 		pr_warn("due to cpu running other code. Event %ld->%ld\n",
 			tid_to_event(tid), tid_to_event(actual_tid));
-	else
+	} else {
 		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
 			actual_tid, tid, next_tid(tid));
+	}
 #endif
 	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
 }
-- 
2.43.0


