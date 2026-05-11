Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23EC6CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846046B0127; Mon, 11 May 2026 12:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5C96B0129; Mon, 11 May 2026 12:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5D76B012A; Mon, 11 May 2026 12:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 598B86B0127
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 207CDC0C80
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:34 +0000 (UTC)
X-FDA: 84755684748.12.0FDFA3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46DA318001B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iEjUfK3t;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1rbjhWvQP9WBXd8FNW+PeI1c0uEcnkcTRQOQUehmz8=;
	b=a5B5Ucb55kzox3ljkfjTarfqedjyWWx5OWcT48DpFVKQh0/HmYtAhsZ2y80JWkIXAmt97p
	j4jA/+vbN6pFaPWcLmUnmEfvEYcxO6yOgOrXafxw/vmd9al6mnG8Ek3PAWQ3pZL3+PxL+Q
	OitpT7a4+x2+kT7L4P1ewatrU024XeE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iEjUfK3t;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517212; a=rsa-sha256;
	cv=none;
	b=1u9SXUrBJtMpcnNaHlcNyWz6a6s4ZdKYT+cwLoaRvT+pDVFCA/sLMvqzhPJUgUgwQplnpr
	4XLy6DP9LRQMJbfdU5f/dei6wfVmFOtxl+0g2/tgF0wJmfUr8S6cj5A5iXctO8j0y/SC9R
	jRbeTG+cFlZ46wk6+5es+Up5D1qHI2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B9D943657;
	Mon, 11 May 2026 16:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC6BC2BCC9;
	Mon, 11 May 2026 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517211;
	bh=c1ZxEmNU3A9YeW1tzV//yrEW/Ruonx/h28f70wUwjpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEjUfK3tQmG6jLjIdKDyGB2iuDamJLmeNZIHemS3b0oie9NswUcT4JLxag8yA2SlH
	 PNQDI2wnpzd6dQiL2CWPTxr/QRGsshCf1Esydhf1awV5gvoJi4DZBbHNJi2zn3cnIr
	 n1zGfabcqCPFpBuNzijh9wsyaATfX77XKKVigpNCtC7rYcamubLkSpYRidU6TsSJuE
	 94hbUYfp08suC7ezzWkwwMGIbYbu/eH/1OiU8v0AbOSFIYzosG2nG6ryxgBgR40+W7
	 oQ3QMb5tqz33/sqXJZEwKgCb5Pw4gLPu5fckJIUONE39q3SgXH8pf4iY7NV2mSBOIw
	 KL6elhJtsYfVQ==
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
Subject: [PATCH v4 43/55] selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:27 +0300
Message-ID: <20260511162840.375890-44-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h1w4cpqxk974h6femzam8krwk7c17cd6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 46DA318001B
X-Rspam-User: 
X-HE-Tag: 1778517212-981868
X-HE-Meta: U2FsdGVkX1+yUIcUtcxHWVVJe4J4ICvANfYWv2W9sHVk+6uMqvnclQclrtSMGw6OGDe4AILCfAFb+cUZwRCZi60bsnn7BpNIxi5mSHb8C46NUDIBpUSQd2BLcR/rt+cxyrJNr/ZOsDoulbJqCyDrZPmcC5Em3lIuX0XRWO/YV4cEiuVquAisWZ9qpsJaXEJF4DySKLbNLySX9wpYQ9FKFMlMoMafSWH+fwhXYW7f1zq7NVA6qsyXSNwqkUM9qEmWwEjhFdbL9BblxVOE85PlhNjQ2tsghb1Z+NRZvVV83XIFou24L9/jfUsIYp52JmkeEva4BNyq4rgBJsfjC3fB7vPBvsv7UZqVouRXtkg2bv6qzrZQRb2XcoP+vSXcDsidANgwhdFB4ZhikkG4eXW0WteaS14u9hNjcgWZEjzQuQ2S2OrnP/D5tBQ8L/bTxOnPLJhpF/LlmWegrPfm90lJuc1QyUhhGUPetYLjw5CaNnO/nvYnSi6MYl/MqSnOhyYYEECS4z2edESpVyYycABfW7MRjkU5DH7KL1pD+N758cHxSNhRrmxWAC+rOReUoDHpRk2V1ZNjYB2fqHZuhMOiNZqvxA43TqmckPplCIacRRFnOoLDg+dK7g4FjUUicIJuOrxsfe1XGtTvzBLDKD0Wf5lC1SlvOJTMLt+34n3/KGemu+xCwuAknNNdUE+QtjEXouTBz3BY/j+hM1HKV/ocn9J76wDG1No8+b7mC79x9bk6qvC999rxIkvC2TXLyt+rS15aXmuXo+FMAbcyNSoeRUKiB1nIRidJPKltG2SE1MFYv2R/0zUFHiLPBUJL06jvcway/f0/H1ARlEREIS24SdZC60STZX2ILY7WVZ3v6kVt//hn8yHvSo0sKsdLmzW7YwG+awpwi9Fh4HuvSuYWTtXG3OpLGKUw2AGhZWSRP6a/5oXDxpZh7c0UjRt72eVtOsEcUOEg6e0qomDT6k8
 rAhaeNww
 nibmwfbGydilum2YPimYelSTNsMnh0xcLQo8fontwEgqrqX6qK6zT/3ZiAs5w9cuEdaMh+u6D+GKNqX2VJLHLVX0l1bkrVIAodO80aV5ss/AV7wbJyILLVWsMr2mnwB4Kh38R7wjPAvnOQnYNHX5eShby5mznwG5MKKS/xNTabTrEEkr+btZ1KHaKCBifUvzmSqQQDnqgGUsSEOFpBEYCgyeGRKPqedGBSxy9Qi+fSkMTLzRafazRqUU69xEeWkUJ5LhAvgR2c+wVm5vdu8pObfjwkc+nCfdEQ/IDfabxIFUCyuIs3rokf+jOdHgM88SlYo6s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-soft-offline test uses open coded access to /proc to determine
availability of huge pages and fails if there are no enough free huget
pages..

Replace open coded access to /proc with hugepage helpers and add setup
of HugeTLB pages to the test and make sure that the original settings
are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/hugetlb-soft-offline.c       | 45 ++++---------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index a8bc02688085..bc202e4ed2bd 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -6,9 +6,7 @@
  * - if enable_soft_offline = 1, a hugepage should be dissolved and
  *   nr_hugepages/free_hugepages should be reduced by 1.
  *
- * Before running, make sure more than 2 hugepages of default_hugepagesz
- * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
- *   echo 8 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+ * The test allocates 8 default hugepages
  */
 
 #define _GNU_SOURCE
@@ -25,6 +23,7 @@
 #include <sys/types.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
 #define MADV_SOFT_OFFLINE 101
@@ -100,32 +99,6 @@ static int set_enable_soft_offline(int value)
 	return 0;
 }
 
-static int read_nr_hugepages(unsigned long hugepage_size,
-			     unsigned long *nr_hugepages)
-{
-	char buffer[256] = {0};
-	char cmd[256] = {0};
-
-	sprintf(cmd, "cat /sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages",
-		hugepage_size);
-	FILE *cmdfile = popen(cmd, "r");
-
-	if (cmdfile == NULL) {
-		ksft_perror(EPREFIX "failed to popen nr_hugepages");
-		return -1;
-	}
-
-	if (!fgets(buffer, sizeof(buffer), cmdfile)) {
-		ksft_perror(EPREFIX "failed to read nr_hugepages");
-		pclose(cmdfile);
-		return -1;
-	}
-
-	*nr_hugepages = atoll(buffer);
-	pclose(cmdfile);
-	return 0;
-}
-
 static int create_hugetlbfs_file(struct statfs *file_stat)
 {
 	int fd;
@@ -177,20 +150,14 @@ static void test_soft_offline_common(int enable_soft_offline)
 		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
 	}
 
-	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_before) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
-	}
+	nr_hugepages_before = hugetlb_nr_default_pages();
 
 	ksft_print_msg("Before MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
 		       nr_hugepages_before);
 
 	ret = do_soft_offline(fd, 2 * file_stat.f_bsize, expect_errno);
 
-	if (read_nr_hugepages(hugepagesize_kb, &nr_hugepages_after) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to read nr_hugepages\n");
-	}
+	nr_hugepages_after = hugetlb_nr_default_pages();
 
 	ksft_print_msg("After MADV_SOFT_OFFLINE nr_hugepages=%ld\n",
 		nr_hugepages_after);
@@ -219,6 +186,10 @@ static void test_soft_offline_common(int enable_soft_offline)
 int main(int argc, char **argv)
 {
 	ksft_print_header();
+
+	if (!hugetlb_setup_default(8))
+		ksft_exit_skip("not enough hugetlb pages\n");
+
 	ksft_set_plan(2);
 
 	test_soft_offline_common(1);
-- 
2.53.0


