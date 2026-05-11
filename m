Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B82BCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844796B0116; Mon, 11 May 2026 12:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F49E6B0118; Mon, 11 May 2026 12:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF3C6B0119; Mon, 11 May 2026 12:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 526D66B0116
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22E4616020D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:41 +0000 (UTC)
X-FDA: 84755682522.22.ECAA9F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83457A0011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NqAZfkN4;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQkPGkQqLroMFZF5cgDLxT47mt9sveEDUj+VkXOg+nQ=;
	b=ylX6BS2nF1r29dZvh70tCVVt7U80JL3GFX7VCpiTauU7bzI6C3qGDwxe47ccj4FFFdDPjG
	3XCy077xQAgHgbkAytos3UkbEyiJIQWW/HnyC25PRDdQVHpAli+R93s8AqmohdBLyC+D45
	7pAY4PZVTCItMaZYPajI1PMEWhnCxtY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NqAZfkN4;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517159; a=rsa-sha256;
	cv=none;
	b=z+Fhcr/TdJ5t/ivr/fQZx/8+uXVQ9pUAaDuOfGfBCqyKN4SckuyhYvoE9eBhfSfJXy79qm
	SUyfQ3iVlrWKlJV6o/sAAuyn+N8bjOhISEjor+dAoqev70rgWUqbiyKw061p7ORrF9Y/zR
	1DIHuqXrUkW/p68x4TLVAPQuwp9ca3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4193402D6;
	Mon, 11 May 2026 16:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23B6C2BCB0;
	Mon, 11 May 2026 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517158;
	bh=Dzes96NgP4eefa7fZjmjaW5lEI/jwqGlyYjUaxKbtSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqAZfkN4TjFl9aVd0um/0idmB5dUz1fUm1WzXod39cPjLaGCwKF6LIkteRx4gSvXq
	 uRJnR5bvVuXW0QLsMN+7G+yULDror6vtoGRBIHmCpzYLbCCft336XQ0YdcIInaXCcB
	 efaQ2wqoA4C0UEV7P+h2Tw/apPCKT/SuxEkn1J9NQ9QUoJHaIK6B5j1Nt8vx0T+T9d
	 m7RfVDSoHlhumWovmghcgDgC8VR10dPliqrX/YVa35x+sGqY72IratPh0sg9Dox3Wz
	 6fEanirCVdZbbEfhZxN6SIxRplHxBh7WnEup60DEVDgusdSdFVZ8rb1XoN5PvTyjKD
	 gNl2DkBASANkA==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 35/55] selftests/mm: hmm-tests: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:19 +0300
Message-ID: <20260511162840.375890-36-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5gq1zhe5hjafwgmsqqyxffnspwqwzibd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83457A0011
X-Rspam-User: 
X-HE-Tag: 1778517159-784724
X-HE-Meta: U2FsdGVkX181JZLhbbRpXg4BzNngqPOPcfhdzR2IEJSNkeFFCLFoCHizNko36h47+PslnFKi5vIxx26bH8icDXbCRBxHB7G4CGKjg4iOR/L+DqhMIaG1JH6LRlaYV3pHPQ0WFXrNsGb0HMEj5or+2V/HGwZcsKTBQmcdyQSqkadKBw5OdE+tzKOR8+TErTUOrGIOC0FEDOn6+5GvhXvq4sn8fwNrlPqd86423O+WZTGtGBbAV9aEUqbMGzzx6uvHOWatx2wPdov3B84GHDAewdiLb7EEgbenj/dFYSvbT6zxYhUP2p67pD4KVS5GAERlvxMsosDW073vrOK9/+BjiAtKePz83K3ozNH6W9EbnCuVVx9rFOxv+2vUmKSWhvrk7ik8BdGsJjbNdjg6bRBgBHEo45iOqbY2g6Xzp+RQTtqke5rMpI1IJq/PGpYddTOVJakgoG0crLmn+qEIuCLsqwonpS/Zs/6MyoK7IU8eyKYz4/TWyL1XawayMLfe4GYERoNOwmc2L8/WsMaViybhjgGz3UIDMnKvzpt2BNiMDVW0QDD9ManwgOqe4apGRAyyfCK86JJGOPIh2JJOZLGdpJijyIcQOqvyfl/NaMDOmUfurGymzcPH6oaTPR47aQBA8lrnoR6UauW78vtQ3uKV+rYtWvxNCyNrL67pQz1+jLZzOxw4CMnIGyyejUy1RR/C68FtJl33jKp3hAB+9h+bqcZ0hSfRRclFq4AA7FTZt5lU5uM5ONDGMoRI2ZHwIKMlxWoh+zAzM/+YFJKyCIBcVZe1xio7yq+GLoqYkTwDAmYBVPRPMOoKoRsZlKYEV7Xs5quVP89yHHI/Pt15h/a9gboduUDtnJdou1cof7D/3Cljedo3TsQH+Pd9LZKiGTpf2993S0tKsE0jf51iMpjpX4soS/BgUGsf43/lkRK+gqDYLZneUzHEUy1euyGItaF/CqGNbrmEy8rZZvJUsVl
 iXC9IbbQ
 rQTNaYY3Mtx/Zj92NdU7UIDJ0G2mkFsRYIvFPn+aMcjcUDEoQ+8BzbiQ+0NaJRvC5o7kCMjqcQmEhgibd5aECKnqA98sYGUWbpJ6Wq2Z2vD+awpDydFlek1nIa5lac4xKYJCV9UL14zw1B1cIBGUKpowhAj8FNHT8IdX5S2UrhzDVdZEfl5JYNR2eJmqZUy5uHmR11ksMNScg5d0T8rnunuu+FkExSPBESJhVXKJ9FuRv1ff9xXnsRG4aU/Mkn2rV248PzTHaFyBXBE1ZhIMzhHOh3opFckZnIPqAYqtCkhwGPfglukqrbZ5bVD/MLbJUxV67
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
the middle of test and use SIGKILL to kill a child process in
hmm_cow_in_device test to avoid interference with signal handlers in
hugepage_restore_settings().

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hmm-tests.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 409b11cad4bc..4f4912dcfc81 100644
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
@@ -784,8 +787,8 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	int *ptr;
 	int ret;
 
-	if (!default_hsize)
-		SKIP(return, "Huge page size could not be determined");
+	if (!hugetlb_free_default_pages())
+		SKIP(return, "Not enough huge pages");
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -1564,9 +1567,8 @@ TEST_F(hmm, compound)
 	unsigned long i;
 
 	/* Skip test if we can't allocate a hugetlbfs page. */
-
-	if (!default_hsize)
-		SKIP(return, "Huge page size could not be determined");
+	if (!hugetlb_free_default_pages())
+		SKIP(return, "Not enough huge pages");
 
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
@@ -2012,7 +2014,7 @@ TEST_F(hmm, hmm_cow_in_device)
 	if (pid == -1)
 		ASSERT_EQ(pid, 0);
 	if (!pid) {
-		/* Child process waits for SIGTERM from the parent. */
+		/* Child process waits for SIGKILL from the parent. */
 		while (1) {
 		}
 		/* Should not reach this */
@@ -2025,10 +2027,10 @@ TEST_F(hmm, hmm_cow_in_device)
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


