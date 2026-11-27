Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847C0606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N3XW1xeQ
Received: by kanga.kvack.org (Postfix)
	id B677B6B05B9; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF756B05BD; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6EF6B05BE; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4F46B05BD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C2A3C054E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
X-FDA: 85482336702.05.F76CCC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C96B514000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N3XW1xeQ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818449;
	b=AfWdr2/lQC0b+8x5YeuE8g6Zw4rsRWZG83Xmv4ra4Rn7Z7tqaIfPyhIFG9zTR4YZ6J5UNT
	3YcF+j61i+82yhibQwdiFLRT+y7rrhVFtaNILWWikDcXiDaex2dq8lCCjPSLrMd4TMaWq3
	PqusYSWmANdXhj3PlZzIEuaykV7S0ag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7wpSeL6G0QpGcEme2lV9PTUvLXdPq2HjfhafRLkksA=;
	b=lo4JGH5Q0OwSEGiadc3hm7RNfhEfn0xuqZnFhV7GXb3ycfY6XF/hRBtFkv9PItq9w8zOBZ
	U9FbLYllpSxVV5FE4JILat1pzI49+rylJkc30TygYykPgq77s+vfbKEiLK0T4pYklKulDk
	XoqgbNK1Z2PElkp1Yjy40Ci839ZjKhw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N3XW1xeQ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68F9160E74
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC3C1F000C1;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818449;
	bh=o7wpSeL6G0QpGcEme2lV9PTUvLXdPq2HjfhafRLkksA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3XW1xeQJIu91zH9xJxXcHbsY8f6yJtA6RKUhKQB05gVInyO4c5F54h80kdIok9SQ
	 8OOxnFMh1zByumc3kY3O8XkLSf1VgacLKYUQZKFBtZB6JdlLlB7XOwBjXdodlKfTfe
	 4ddESz76Z9BEe2lGtMapwNXJKyWcqmM6m9WQbefre5kdM217u/NjM4yl/Y9nla7Fjx
	 LdRMJECxCLKu5MR0+SzHTNgoIwuGC+sZl/uX5nM22PNHvcYrzzWns5oGYb+QeYIxu5
	 dkmcF7DderJW99K/vNRGvbgZRswr4LgjE4i9w1xWHNjd5xvzvMxBHUexXPCBHYoeDe
	 vSRwr9ciJ98mg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 6/7] selftests/damon: remove unused imports of sys and time modules
Date: Fri, 27 Nov 2026 14:27:17 -0800
Message-ID: <20261127222719.105510-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: C96B514000C
X-Stat-Signature: romwg854ha751dimxmitmawphqosxxe6
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818449-760377
X-HE-Meta: U2FsdGVkX1+6wTKeiTI1ud9foUFtYmsPe7X3vaT76Rm3/rFQ1ddwfL5ImFGnAuN0/TpNrznY4qR9ZC2ZApWC3c7nJOcdh+LxjUrxZEOSpsKwMRKqIZH2xJ/tBzc3bM8dsilv5+QUNIP4UncB/CpbMZW/IuFNmjfOGKJMEwfV45YHpeztiq3qZx8QZOgIF/AX3RD8DO5MSP3viNkABW33ks3NRbZOAIGFp+iFnJ6ASAKYRXoGh2YLSbUd6PtQJ0GSx+OX54GcuqYg/G8Dq/bvPf5Sagj9Iohylk4918cramz3DePIEazQBYpX6GtioCCFEJPukah6T2OSeY415LSVMHXZCTWeeiuHuRCSV8Z7d1flJTdHQSVdGbhpNNG8EP5wCuSxEp2xGWTBOgxEk8+w5KDfbihTmFNjmMR7V+5pZ1k1GKdCJwM602/FJ8lRWPemSufcKSCR/jANd+RONBqph8plK/+Oqj879tjj7H8/K1n4Xsh87ZvbpUlCqbTE36Yo5lFch/b3UBZgD1R4fwSXUzZQazIXG2zWJTxnft7efO5Ac3WbweJSLYUzKvvwcWSn+8urxF180KhY3aAebzKPOeCh/vMFbKdJfWEOb2wf29reM80Q+EdolfJEhRhew/peYKq8e0U5fgJclhW99s7l6ldwI7JaiwftbR+WjIanwogHBWD4cj+1qN0x4e4/3ceZzKORcVCO3lebWjHPcfGe8YxCiEU7PlfrKEmKjO6SJTdLREuEujcit/TKLy++HGPlExSuOCZnVAPBopFWTSPFgxKmPR4B419WQ4vFvIFK07+wLLYLnbrVYqa3rHWAqdxP6EfbIt8k6CyQ4e9c9XtZ1PObc6nISSiLzglkdmOIJdWHJ9/omIwa2MNlckHLpxwkxvs8TkZ9xrBLLGqO8HweJMPma5elod5LeS9H5zDitkCaWTTftQtJmMwIdj1m6ySJHov3J2MEEc8mwcIGvcK
 dtnBH9JL
 surRVQ1GSnExM21OPyyMNYtYfOSO0AoDMAJCqYrbrqaivbvVVH4C5EnUKB7NQ3YIra/bZ0/CO/7tRIpmmkS6U9Sj1omAThTpk7WeuVRJ7q3dcSJAH3GOhIynU3xoMfYJs/RVgMgprYGqXqIQU/OSqJsS1Bn177n7inFrxZYsqdk7omHtl4bum71RhhTY4aB9XUCOFKpu9ZTZniWa+AaUpr37k+P0BNj4cjId8c6zkPszia9XCLA4OBbRevlgt4i5r7Xl0NxfZfKd8D7CjnPLbmT48tABR4yw3InXgG4mEQ2Lr1gWkk5YqNEcE5S/vBXICkmbtG/7HO8QDO/r5ARZ6lAOfHSzwUbYx7bfFR61ehobI9rDTgy7T4JA4xVjUaruYWxdrKYIsC8qYh/KSRf5Xhy7tGK9zNdmubvkZnN08r+vP5r5f8yYemMb5SqjanGFFbSwd73DfQtVpC2wWdC9TNMVYCv9g48x8r62NgySt6Lwc6gh0rKtpHq45y8yVyWQEr+CB7X6GBVEnpPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysfs_no_op_commit_break.py imports 'sys' module but never uses it.
sysfs_update_schemes_tried_regions_hang imports 'time' module but never
uses it.  Remove the unnecessary imports.

The issue is found using flake8.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs_no_op_commit_break.py        | 1 -
 .../selftests/damon/sysfs_update_schemes_tried_regions_hang.py   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index 81774ddc55ac..5664f75186ba 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -4,7 +4,6 @@
 import json
 import os
 import subprocess
-import sys
 
 import _damon_sysfs
 
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
index 625761c243b5..326a14f04053 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -4,7 +4,6 @@
 import os
 import subprocess
 import sys
-import time
 
 sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
-- 
2.47.3

