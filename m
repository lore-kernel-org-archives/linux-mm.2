Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B85E606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q7pQveaP
Received: by kanga.kvack.org (Postfix)
	id 76EFF6B05B8; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7626B05BE; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572E56B05B9; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB6B6B05BE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6A4E1A051A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
X-FDA: 85482336702.29.BDD95D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2674F1C0008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q7pQveaP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818450;
	b=dNxg3WeDR5aRMkILMULFNK3Epd5p9d4u2JN4oKf/rFwlcaDimyykj7x2g57RnolvaUAe9/
	pXYqz7GQn/dadErbku5Vs72rLCpvekthUw1NjcrLAEsdWiJ5yr5iaGwhvVjuzQ2SGIkItF
	CcKDN36tR6Hk6OG9dP56UG/3D7i+V4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9U9C62lmOkyzoqlQRfq1910+hM/DPzph/zq/GHK+ls0=;
	b=B1ICPEQlEbmPJd4g5TuQgBns2VIVpC3yI85T+d8rm3qIMvICYMXYyUVX2Mrj86nzGVQ1pN
	2C8keMacguJbIZrD7hLdlDn3r1c8rO5RQUpJCAgRSQzbGp8x1SzcgAVbkXflMkwGpWCCv5
	hvhpuTFtywL/8mpLluDUzB0EamhVVb8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q7pQveaP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DE2440788;
	Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4600C1F0089C;
	Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818449;
	bh=9U9C62lmOkyzoqlQRfq1910+hM/DPzph/zq/GHK+ls0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7pQveaPaBSfL9S6J+8BQmtrAmR86ZMcuZRcKjFcpv+QfeRUECO/QBJAQAFiu+Xz6
	 mLoNevfWWOOGHOt+pdreZxdi9bxO8U4BjBYnppQySDVp+MEFpZzzw+FJWERFb+VD8w
	 QRocZFnv3pWs3nwavMpzKvMDZK+spex291P6FDTKUr1VSXtz6KUZcnOtxBcWcTVpOS
	 PVGJM4BLTwWsgE7p822OGF0zqugfSc6M7G2pynZIUHucdgp7KWADcH9plMLk5ow7JE
	 A+pfzaO0f0Cruy4abZ72JySf+BVKwxVLbE/jOtMJs7x6PbhRDBno7Ve/n22Ntjwtcg
	 xneTEDjx1MhpA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 7/7] mm/damon: update file intro comments to call DAMON just DAMON
Date: Fri, 27 Nov 2026 14:27:18 -0800
Message-ID: <20261127222719.105510-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2674F1C0008
X-Stat-Signature: fceukswwketsqh4kpnz7ocpqr36co8ix
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795818449-921280
X-HE-Meta: U2FsdGVkX1+wDA8Cch696bgWBaidG17qNtN6I4ZYs6cRkMOUeDDBk3xTtNkAm8xWxOGhXdn7jjZyt7YeQsV5rA7tKHLRIZGVzwgWOZKdibA9o8lb5d4+hNkLvlZWz65iFdwovDfy38gRLjlCEZ7PN0Nz/jYb1c6FpNVHKih2tQfsCimNM7y12ndVmEQwn7xafBJm6MgQ+CfqcM6DvNBayT+Fn3geKNDBTchCsKQLsRmWIoxDXcJY6ORUebjyvT+ZBa+GgGSxKiYSpVc+HX1/FnhTP5H+1D5zIuuY/Myxk2wrxnTm0z6neUQzSaoIYREWifDAT58qiQteqKSD1wiHalV49O8ZiaM1ZISW48l92q/TDoUWon6TiHNgJu3d1ppkf4P+LwaTXCZZYLkowLMmu0Ds841VZczfng0Uw9qtTJiTaVdSoizEXs8Fg/b505ODT3ygv/dQdhAMTFb+tNWLq+172G3zS5vb/dkd4mN9tHlGr1XUBzkHhnt+M14SMjyRVjXoQOBgbAjuiuLuLUPkooYFP9s7JrivZdKg4ZjUpQFOe6zhlkhQa1rlkBr1GVSGu6IA/kt17d5RK5lkJtfl8mGnvivJ6Ino466KeLr/pgN84pZ3jTvuynubzlYxcqZuBNkts3XH/ILmdf/eHdpFtl8mQoNaDj1lYw96lPrxYxvxIqqDf+2xGzVlztdxZwp7li6ZwtQyIi3WZ5j7B5a93bejWF7HxnjM1hKu+Z8v+36lpRvW/OkvBbZeByBo9JlYN5x765Cl7fPp2MH+36aOaZTq+Z3vlxPL36HK07VVny9bdkfCt3l8FYs+j1+5/y99XlKEFHNERaB+RKvXuk6o9ZajRhtSyF3f5gCWAHhIpEDmJacQ3XSnPquRBLoYXOhUj8HygoEOvPGDB8Zv//UxO3mrKYGHGXQyVY9aYvQ3qZ2ZZ5ougb3V0P7GEy8pHC+kPgL5XyQSPk6aNpnAJlP
 oEKndB/X
 56Ektj0e0rS1ylMcJKHldd0bvDhIkj3lTu4RFye1GW9zO8lUu41a3pYr4k70oNs6lS356RXllmTYXzH5UpPGhkbtZn9wF80OFSe6ck2spCGU49wL9M+a/R8PwgR2soKytTH1yVKQ/ZPNbNwckAcfiOPzLy+m/Tc/jMfDNqcdl9dsjK66SnSTXkX9QLglRhhUjDZpyulgVKOsroeta5rt0HSvD9xz+WL1CBg0GwNDFw8y91BLCssbbRQ7XCz5//FW8wJ0WOYu0lauWvvytHYn7VRp6SRpsua+1oAuD3LPZG7mN1dLuo9tTsIP4R1RaFTf5CKAIbPTx9wP14h+1DV4xYScZO2tLHotstRVgtsUuqqMRyR7yJ9aJPsHKBf+19axZGLWiUsAhfna8gsfSx09r1GKoP0913FitvP+RCUFWiLSEdfbDvlz7J9XOpdVAhshKv51urFeMu1Da2nI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON source file intro comments call DAMON as Data Access Monitor.
Since the introduction of DAMOS, DAMON has been somewhat more than a
Data Access Monitor.  Update the comments to call it just DAMON.  Also
some of the comments are not appropriate.  Update those together.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c              | 2 +-
 mm/damon/ops-common.c        | 2 +-
 mm/damon/ops-common.h        | 2 +-
 mm/damon/tests/core-kunit.h  | 2 +-
 mm/damon/tests/paddr-kunit.h | 2 +-
 mm/damon/tests/sysfs-kunit.h | 2 +-
 mm/damon/tests/vaddr-kunit.h | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b791a2621bd6..fa32ebf7ad09 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Data Access Monitor
+ * DAMON Core
  */
 
 #define pr_fmt(fmt) "damon: " fmt
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2216a0023154..38720794c9fc 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Common Code for Data Access Monitoring
+ * Common Code for DAMON Operation Set
  */
 
 #include <linux/hugetlb.h>
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index ee2705825100..aabcf09ff501 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Common Code for Data Access Monitoring
+ * Common Code for DAMON Operation Set
  */
 
 #include <linux/damon.h>
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4446574a3565..73c3bd6a9612 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Data Access Monitor Unit Tests
+ * DAMON Core Unit Tests
  */
 
 #ifdef CONFIG_DAMON_KUNIT_TEST
diff --git a/mm/damon/tests/paddr-kunit.h b/mm/damon/tests/paddr-kunit.h
index 2b11f0e67a12..547e1b3c989f 100644
--- a/mm/damon/tests/paddr-kunit.h
+++ b/mm/damon/tests/paddr-kunit.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Data Access Monitor Unit Tests
+ * DAMON Physical Address Space Operation Set Unit Tests
  */
 
 #ifdef CONFIG_DAMON_PADDR_KUNIT_TEST
diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
index 16373ba751db..c2bba2e01301 100644
--- a/mm/damon/tests/sysfs-kunit.h
+++ b/mm/damon/tests/sysfs-kunit.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Data Access Monitor Unit Tests
+ * DAMON sysfs Interface Unit Tests
  */
 
 #ifdef CONFIG_DAMON_SYSFS_KUNIT_TEST
diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index d61b503e319a..979e459327bf 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Data Access Monitor Unit Tests
+ * DAMON Virtual Address Space Operation Set Unit Tests
  */
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
-- 
2.47.3

