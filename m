Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC90F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7D736B0286; Sat, 18 Apr 2026 07:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D8B6B0288; Sat, 18 Apr 2026 07:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943106B0289; Sat, 18 Apr 2026 07:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82C606B0286
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50BE0E414A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:03 +0000 (UTC)
X-FDA: 84671381886.29.6931FD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9A1731A0007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g5Qsm5ZR;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RJVgzxK2skC7c8wV5E2gTZKDloQXvOWYd5xOn2lzzo=;
	b=MX+OlZrpBVHJ01DuSkQzpbpSILbpnsovoUgKlquaWBSkTLvJI1yCwes+jkPpiCKOPTivX7
	/Gw2uThaB6M8VBSLfTdMQOPsMxj0JUPvlFGWC8l2WX9lh4rUiv4Hx5B1AghW4NNVRK1TP+
	O+vlnBovsHXTCL0vHfaKVXa2dUNFfKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510001; a=rsa-sha256;
	cv=none;
	b=pXALPRigrW8tcS2Y9h5l5Aa9HGtBa3jbliz2VrX0LPov6Qh3prQozRaa/ZDhnzICSQdj9x
	IL2pKqawrACIwK4CVtSBsiACPrVWcqNeLgKrafkrpBtABT8PZfsP2U3Tl69ecRu6tUs/Wz
	JYpGHvw1AP81QGPG4n645jw30/J0ACg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g5Qsm5ZR;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBBA7416AE;
	Sat, 18 Apr 2026 11:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC87C19424;
	Sat, 18 Apr 2026 10:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510000;
	bh=Ebag/OZwcEEdNBOTVBqp4Cs1aPruonU0XrgpI45ideI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5Qsm5ZRYZkR8vT0O6qXBJYKxPtN9LCLGFBTm/38emLtpVsU65WEDEE4mlEPfWKAQ
	 gaX26k4k/Jz0BRP9/dah8MenVCNiWda59BIXAwJNl3OwVu5tM7sSWYrx+rXaLcSCej
	 02YgfscC+z0UWO5gTmXAHLlNufamqaJt4VhEvDr8H6NZcg6KHDq86ESue9Ea5ekd1W
	 4rfwmUWgaC4rXahBX8nUo/xMuq3USg54PxNnKmQDzv8Uu5aYw44H112BfpI+0+cGZs
	 9xQrgb/wFS6CwajMq5Rj3A57PcKF1oqTLKsuWABhTYfdpbYCjkIE4rpujmcIcZEC5t
	 wgs/qDpFSxTBA==
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
Subject: [PATCH v2 41/53] selftests/mm: hugetlb-soft-online: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:26 +0300
Message-ID: <20260418105539.1261536-42-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9A1731A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: dyzq4a6biuq9m7y53o885wjp7ykqpncf
X-Rspam-User: 
X-HE-Tag: 1776510001-12566
X-HE-Meta: U2FsdGVkX1+9ff3GpTazDNkZnOVJW6YDL5GOKaAw1jkpnOeFza7rPpkB2F08bT4/Gk0cLqVAMQ9i6NfIGvorBrmpDVl8R2hnctVbsZKMvrxYi0E+hqC85KubJv0gryOm4xqEGHHOTdfsTnuPN5aOm3+8aPM2CvL0v6gvzxgDrtekwVvjxVdG1tKFPLLTpyTsFVMynLlgZQ5mlLkwmSebfg12xfgPtoTpDPjKLXlgwJR9yJ06BE6qW5c/U8h7650vbActdZM+N5u8ANJqxX95VrpY1zo6xu+uI7jHUaJW1c7sUuFRdW6ZGAA4n9IUWsyWCjC1d1xvhd/oUr6pkqGAcj4EfYQATzWtiMC4fRf753U1EyTTiG53pQRCz4fTjFzIasCkJO48eU2YEC5td1vvikJ61FwYl2TtvjNuZjM6ECxkrH1xObUQCMGAW40Kqau5SjcHC20DtPosutsws8XmPH55XDr/MlTKI8rdHz5bOdSSjeFTqrtU+mW/9LGR+vUvwHqIwoblpSm9isCPO3YAZGoMswCEXbnT08mU+n56jEfjDyHIM2uv6RX9t7UfpVXAbmkheLug++pmDRHHZx3/JfXjktSsKuzsZm/EmjF9AxHNJDwFzBxLKJQSnf6Uf/DDQG/zti40HWPb/sNxluBFOg0QbIMDKjYZx4XXgf15Dpjh0X49Lod36hes0mA5RsKH2SVLLmTQVIkah20K0W8iomS4UFPfOQfHHGeFgWEKBC8SM+fD4LGJjw+KIzF7Fava2vTl1avzQoHGRIVISDwScro1RAb7NTdi1hqIKABEih4euWKR6d0KVJfXHtkOC3hzOd/ezyln3ASJFku5Q9jUdxvNvAUQKrPnEzrSdE7FkhDTYBdFIvlM9sG2EiJqnz+p3pYq3jlNtz2aDWrD5IfAjwxOuWUTNEnwqlxXbQPbiZufFR26GckXyNboei0ls2ezNRQsK9y8hLit781+k/a
 acuD8XF0
 IxISLmZNoCDA9mGyZQ+G5IacITRN6rE9fIidd56SVP+4nPlSIXwHjYbOQubhC1olaIISsTOxzjFcxmrbauEc5J3zBjbSCwh+xcqqpY19MZQwI3RpB6U5fZItjdmRRCVdpu4sGrTj4cITeUMxqhVVPGfAUZcB/r20A5k+wa2rcEADghwPjKe8oflFPtmAFepOoo/AWuxBfxh5dBuWAb+q/0Jp2ZPQn80lEwIwRB952bwWOjLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-soft-online test uses open coded access to /proc to determine
availability of huge pages and fails if there are no enough free huget
pages..

Replace open coded access to /proc with hugepage helpers and add setup
of HugeTLB pages to the test and make sure that the original settings
are restored on the test exit.

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


