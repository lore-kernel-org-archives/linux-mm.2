Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A14F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE186B0276; Sat, 18 Apr 2026 06:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F6A6B0278; Sat, 18 Apr 2026 06:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76DA86B0279; Sat, 18 Apr 2026 06:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 639EC6B0276
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36A4913ADB4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:14 +0000 (UTC)
X-FDA: 84671379828.05.6FEBE64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8385D180004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lzq8NG/U";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVtTqkI6dusp5pFUZZlnQFFDFO3DE9DYmkBuKDuGyfc=;
	b=u3MiACSQbki0E7rzaG/+qQyQhayNIseuN8+hwkDMhwZKkAE3WSFZnuPDh7BVs7WdVjM3dW
	0Z6M2tDr03iDpcSDRU0HnxZk8ixY2uMRkJsAvWInnLRW3nJOUL+0wojVB71pODAiactuQO
	8n5qLpDMEK6/ZSNEak25cyuaZ23mDGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509952; a=rsa-sha256;
	cv=none;
	b=LR7HU2cChBSEDZh7/1aOzU/urSlXvr6cP9vOhzic01PHHltH+ciYiQPSq7Rm3EXBc5aqnt
	qL50zIbQpBVR9Dn7K29VRck9TiqSGFk81/aoDy+dSsqkpZlohT6oJnXPapn7NZB9zbA9lo
	d6vjw+imLhspVsQcNneZAeNg2vWnVxA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lzq8NG/U";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9DCC406DA;
	Sat, 18 Apr 2026 10:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2532C2BCB5;
	Sat, 18 Apr 2026 10:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509951;
	bh=zjc7IuQI4jBq+AK4lBqRC09uA93LQf31iSBny8sfuNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzq8NG/UaViLU3r0FPCnq2lkTNEVDU8T5eq8gaKU5Tp0Q/4uzxlPLjtWnwVhssUer
	 skZpH0UdI0bCQfhigue9SDVDWKeMgc2SDwrU/Gr7VzbFimnanc3Jij8RraeWsY1ARw
	 +x1bKKr2ylMaC6zqkOUzqWWqFFJR/edPIwbLH6GPF/geBthBS1aa6qokEUReDHqR6i
	 EG1H0CtpY4oBx0THDrtcTPe8FNaIplD0Gqckt37tsgXk6C/HEhaTOJjhpD/So7AXHA
	 ymo1nX7k7515RkADayoJf7KDKLDLKuhhST6kr7SWoPQuVrAr0RCxykFpTNhwxv3Y1N
	 mqMtebUhWdqAA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 33/53] selftests/mm: hmm-tests: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:18 +0300
Message-ID: <20260418105539.1261536-34-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8385D180004
X-Rspamd-Server: rspam07
X-Stat-Signature: ngss1tngtprysamjhgx7w4gew1tndcbe
X-Rspam-User: 
X-HE-Tag: 1776509952-596052
X-HE-Meta: U2FsdGVkX19jGyHOpM6Al083ehkt1OjBnTD25PF9hSowRkns4I7fThpiKBRaKE8kVHg+9wU+/UEiGkd/aRg04JW5IrDw58sVnu7m5zEOrbVEyfBMiNGpr6HURwx3BIVPLzH30ILL4Pc+7a+tVwVmTY/E0iH5+/PxPKOsRTzMwd9Xi5Lk85kdzfLWRtxeQDylXrZKrrRylpcgMmKCAibHAjq65NVxSLHqbhURIfLY2Ml36kRqgqFL0Vihs50j1Ya+NBHw77eeOKSXeEDJoMqt3OZgR1hnAieG1P4SsSzdSO/mvzcfSDURR8ppy62eY8haR1KMhuhW4AQAMWAebKC7XQFKVdAOqBjy/5oQz826tAXIyem+Ib20lKPNgahzzuJ8UtgkfH9/T5ExlqYhF2GLxEcl0Me7yUfc1EwW4lUBbNqZB+sUQbrCVcovDFvSwy5M0EdpK4zCn/br+P5JvqyN46fEfI+J/78eI/qjx7cEusMgS3dkZCQVEiRiUn+B3Q16xcagT3/J8HoLsOqy5yN6pAmx2Vb+85XJqZB20QV3ltjJV04Eguk036fdX/BDDjcQc8z3bqNQmqU0qKfRsmFLFvn+f7ZzEGzGZdMgNgV0nbR6xYM1L8pNMXz9u6pjqTlKfbhi28VOLnv0L3xqOCBHEqivsZCO3zESXSuktn/A/Tsvoajv8slUp+ylNQrHcFafDF0sZthsR9Mk18ll61eRr/BQYg0SdFo/PEFsoFOCFilTjXT0v9LjZhmGgy5L0OKSyuZPKyOz7RTypKtvT1js30XMFfPNqW4dmXEv6uKMNubhV1fcWbzNYc6G4BJl0xA7XX0hgqmy9aASPuoIN5TbXIuUGdHKwts0sksAgpZ/nDktZnv9rYg8h9AaWsFdvrZvCACv0K5ySEgtKlyfdMmRPa5xXFsxP1M2x7E5/er02whEkzghq6K6v2ZlH/+xvcPgxhVW0lMHQ9q0sRrzptL
 5dBSs/aE
 HW1eWdGdxYkS/II8m/n3AgWuRUrf9Yo8faoXuitGXCzhbNqQoo5df9fSqs1W5VrjbAKEIjaFMWbmbHU3kXK/ePKra/sMK8zeW5GArvb4617gSnkk8xOusVJ2B7n4byMBR6DNEVcnNI7idE+XU7k3uqTmC9zjRwGY75heXEVu+MfWf0DfUZKwMfjiJ0yNbzh9yZD3u9uCtvCM5JaP0zjhHcmhL7DpWUerYLPCd25Y7ozm76yw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hmm-tests skips HugeTLB tests if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Since kselftest_harness runs fixture setup and the tests in child
processes, use HUGETLB_SETUP_DEFAULT_PAGES() that defines a constructor
that runs in the main process and add verification that there are enough
free huge pages to the tests that use them.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test and use SIGLILL to kill a child process in
hmm_cow_in_device test to avoid interference with signal handlers in
hugepage_restore_settings().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 409b11cad4bc..70c7ae989c01 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -69,6 +69,9 @@ enum {
 #ifndef FOLL_LONGTERM
 #define FOLL_LONGTERM   0x100 /* mapping lifetime is indefinite */
 #endif
+
+HUGETLB_SETUP_DEFAULT_PAGES(1)
+
 FIXTURE(hmm)
 {
 	int		fd;
@@ -632,7 +635,7 @@ TEST_F(hmm, anon_write_child)
 			}
 
 			close(child_fd);
-			exit(0);
+			_exit(0);
 		}
 	}
 }
@@ -712,7 +715,7 @@ TEST_F(hmm, anon_write_child_shared)
 		ASSERT_EQ(ptr[i], -i);
 
 	close(child_fd);
-	exit(0);
+	_exit(0);
 }
 
 /*
@@ -784,8 +787,9 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	int *ptr;
 	int ret;
 
-	if (!default_hsize)
-		SKIP(return, "Huge page size could not be determined");
+	if (!hugetlb_free_default_pages())
+		SKIP(return, "Not enough huge pages");
+	default_hsize = default_huge_page_size();
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -1564,9 +1568,9 @@ TEST_F(hmm, compound)
 	unsigned long i;
 
 	/* Skip test if we can't allocate a hugetlbfs page. */
-
-	if (!default_hsize)
-		SKIP(return, "Huge page size could not be determined");
+	if (!hugetlb_free_default_pages())
+		SKIP(return, "Not enough huge pages");
+	default_hsize = default_huge_page_size();
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -2025,10 +2029,10 @@ TEST_F(hmm, hmm_cow_in_device)
 		ptr[i] = i;
 
 	/* Terminate child and wait */
-	EXPECT_EQ(0, kill(pid, SIGTERM));
+	EXPECT_EQ(0, kill(pid, SIGKILL));
 	EXPECT_EQ(pid, waitpid(pid, &status, 0));
 	EXPECT_NE(0, WIFSIGNALED(status));
-	EXPECT_EQ(SIGTERM, WTERMSIG(status));
+	EXPECT_EQ(SIGKILL, WTERMSIG(status));
 
 	/* Take snapshot to CPU pagetables */
 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
-- 
2.53.0


