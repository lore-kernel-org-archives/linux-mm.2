Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43AB0F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7B56B0098; Mon,  6 Apr 2026 10:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD02D6B00D2; Mon,  6 Apr 2026 10:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C8A6B00D3; Mon,  6 Apr 2026 10:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91DE66B0098
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D35758E3B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:00 +0000 (UTC)
X-FDA: 84628342680.21.1E6F1EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7D000180004
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nk0df+6D;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVtTqkI6dusp5pFUZZlnQFFDFO3DE9DYmkBuKDuGyfc=;
	b=iOZNrPv3V8U6X15CpDNrHJdMT7FynxVfO50Y2zQhueMBrgsJ3UCpPp7CJYNUDdTY7RVb2Z
	yQzaXpqu94AeGuKRlF+7HP+XLMCqK4t0VHWFgAXjeQKh00Y8XxCgnDLTzNMbgb7yZSE4Rs
	SvKkblORSzht5/GXscPcEQQnQ4q9lyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nk0df+6D;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485258; a=rsa-sha256;
	cv=none;
	b=DFusfuCrgHnypmuhEqYrtMUzUyjBdcflcsjyAznOg+oLOPHBa3VNI2MRfrljRB53M3KO6m
	p4JgABW+rNuBxQviuDQFOy57JDcYnsJVsyBtr0eDe/9X1zDC6V6xjfh6Ff5ROIW83SRdcU
	Tt/AzReuQx2vXGiKMX5XA0eW5X5aWYo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DEDB4025A;
	Mon,  6 Apr 2026 14:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC8EC2BCAF;
	Mon,  6 Apr 2026 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485257;
	bh=zjc7IuQI4jBq+AK4lBqRC09uA93LQf31iSBny8sfuNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nk0df+6DRvm0XyAzJZa6Qznd9ixi9Lz1FzkU+gAZD/0iAwwhJiYkK4p+YP75K4aRm
	 E6fFkN2smeLgPSN8s6Zfzsc0NvtBFYowEof0XK/J90oCkUFndn9GwAWrDRR4+dE6HL
	 riJrn9JGiOQcCDk8HOo7EqM99znhSXQuVJv9exqw20bMK9Hddc8dsVdwYZgzbSxD4l
	 6woQvHzwwcI1mtvBHJ9kznx6P/CKQOpB8Gh/ITaubuujgoFDFfUI6DnCY2cUNCCR70
	 0H+TrWF6DVBrFvNIQdy0F0icJrxkkagSij7b3xriIHbkRJwJuIiRB2MfrnhoKuCcFV
	 L7eYJa6cc73Yg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 33/53] selftests/mm: hmm-tests: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:15 +0300
Message-ID: <20260406141735.2179309-34-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D000180004
X-Stat-Signature: jk7fppqg9yac4tqtp9esykoeygf481zh
X-Rspamd-Server: rspam06
X-HE-Tag: 1775485258-443012
X-HE-Meta: U2FsdGVkX1/sN/3k1guT4LpqeeTM6/ypZuNwGMZ2etAs8+COUSS1li4irZl7U7iNeliSYdFvZ7tcbSJm5jqcXWpjwUkfRTo20LMh/g6NodL6JA5KpsaEyoCgkds1/6rpkgtjmuugtyNQme5qjTZuGyk7s21hT4uXfyTfdCrV37WtqUdccrVdvHDxfvLNCF2fUc4POk9N3yWiUbMB9ZQLj7NuV53G+mnucXitM+HES4fwA4mO1MV/S0pDBBHZaP7kiz8YgGDGeIV880PdRJhn65lrhdzgpdj+hOrQ3ucdz7IR445OG6pMONQD3grip/fFEBEtCKyu5z91wkgEfbQ/c2o14aOUmGhuwHKzSM0g4GDRr7L/X7e0VKPl70pZMXTep1xJPyPsf9HwiSUOg2k0gcOyhNJ6kDatV1puF1I0n1jNpKK1/u+c+UwoLs4wzTkqtwEHj5phLrZ0bG1jtP4gxFVY1ulJa23tF0evhBJyt1fvUx0nr9CX5UIwWAukjHFXjUCwXgWSLyjKrZ5awisYOuVKYO4445Qc6WgPHBo8HJv7fURN6mTYkvuPIzCuNDg2l1yNiC1hUsZUwDPlvCVCX1kF6ccHuHh8ctjRXNE+DqeMrJg3UoShKUPqCziX5n4RLOptjCY5Hhxwiiq57NvFCx05KPm321j/wFG2Oj1o6mzrbC8H2ifMIiONaJjofG9JyNiA2mYberrmCMab/J2cmOtrHvHjJHar0nFP8m5yl/IPiJkuIAGYE51q/3fZNKWDlLPlDBP7ncdMAqpgiF3XcS3CBxWD/wVfXNpp7aXR3DQ7ABT1pURqod2TQ8y6PbWN8jcK3BfHq+OEbfeC0uztywjDblIhTz+IoYhLo8BVyZKL+TgzUYI+UPHHW4nAp5UEQHk1ZhZ5mFb0clQz0RLn3+2lo03iby8juCwCawg9RtsXFcvh5v1JAoy2r5D1qF4kmqC88b/kVRDUZLP9Cy8
 qVAFBLqc
 JO43OoQVogKTFFrgzasUaV6m8/UUy2If+cebqgKAJjUYkVS66FnVCZcwLNVI9W6UAmmx1eCPSv2wybi0G7+gap1q/z8unyPyHL/08Jesk+aqAiDG3rUDNOBQbNH2xJLnxoDV5dX3kZeLl6Hd9ayF96wk3TA0GnMKCKvFtcQQDANoxuVnMNOAlYZZ6f7cvRZIbf+0Q1dWwM+3kDdGxjlHNFHtxJjQYpW4x2o8MdpkZukd2Xf8=
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


