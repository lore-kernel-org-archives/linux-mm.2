Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84D6F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5966B00E5; Mon,  6 Apr 2026 10:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F866B00E7; Mon,  6 Apr 2026 10:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D106B00E8; Mon,  6 Apr 2026 10:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1556C6B00E5
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAF96C1C83
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:45 +0000 (UTC)
X-FDA: 84628344570.24.A2CCF3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 51A412000E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJrwcWLh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RJVgzxK2skC7c8wV5E2gTZKDloQXvOWYd5xOn2lzzo=;
	b=qaeG42xSXrD2JfC7LM8ljOlBC8HE5I8loAQ0WE6UwiDVnQAW2W0Ii5n+wRKJPAvhjsGfVp
	5b+DlQnpcQEUgoQWWpSvmmwJDuL8X1EXAPzyBmBxLWhfhDkKKKowdSHmU+mIaUYtbL5Ihk
	rqhPgNVO4u33d7/eCOPBC2BXStSyPXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485304; a=rsa-sha256;
	cv=none;
	b=CJ54ONXgYz8sia12DNfWy9CV2Mh0c7295Wk+BYBgtvsCiZrjbKgneTiKi+zCww52X8HMRS
	IsilGDfkwgzxNJgncZa833GoPPcR7riJH6eNXjaPJknbvh/mNvWQwnqxu8vC0lICy7J6Y2
	3rRSnqHYJR0xEc/L0mXfbjts43d726o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJrwcWLh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D70146012A;
	Mon,  6 Apr 2026 14:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F74AC2BCB6;
	Mon,  6 Apr 2026 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485303;
	bh=Ebag/OZwcEEdNBOTVBqp4Cs1aPruonU0XrgpI45ideI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJrwcWLh6aojOINmg2AOvSNrDBrN+C9q+lorsQOCSJABN9LWXZ1WXP6HawdGEhnA8
	 DkRbaAl0X3oOs2q4IDIBKkq5AdfV6J/aLTBgM+xXL5w0xWKtCcIVBBPEDXs1RfiUuH
	 28NS4x3noVe6rcurS3wQIlJ+JMpeR2bsUsr4YUSkn3Ti0bJPMBek5Jd8UGhdBBfLSV
	 b3ZDzjiMVtWQ+RtQR5/P3Y/4qbERfLl+88czbtDA9us2qqGklXHNvv4hecQQAyIJoG
	 6Ubm9FVKJZbzZBzqnwUoCi4rDiBR62fxrSBvytmruY3OIBE9QE8hNYdsp/wIwOv11Q
	 Onkf4mLTVHUzQ==
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
Subject: [PATCH 41/53] selftests/mm: hugetlb-soft-online: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:23 +0300
Message-ID: <20260406141735.2179309-42-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51A412000E
X-Stat-Signature: iynsz6ut3qrbecsjmjqk8du4q8xgbtmu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775485304-787776
X-HE-Meta: U2FsdGVkX193jNtQ6D1TVjiLzfEHDU8ES832JR0jPJP42wrJQthp1fBR4EeoZ0FZgCgUJxG929ktfjTaLmFDk+nswuJ4dsHuqUr62ElsWKgICwOH/8UghoqKg3PnGve6qgIkbjMbt8otb5G6n9LuaAcWk7kuoDdbxcv69cc2gigwPH564kg3r7J36i2/WTFiOTh1/+ycaw3cFmgvn3c72kjqt/ogB6xIiaMP5kOGvoGZh67noM4EwsHLn0vTDdrJd3lequG2MJfW9YT1y/F9c+VIc6esJ2ovl8X6QisBk57uNNvIERIt2aQ4tNYRm/99x9TT6nBhbtXZ8GSuOE44Y+O9VlOnAdHkeI6CX1cGV8AUJ2L8iMINaIbTW3lPbnTJ60cIjYGaGB/GRLIee2Zx+OHzkcc5PClNq7fDGFN1g/6DgsDuKjmy5OZiJHl3SC/2F/F817/Jv2X3m1g4rLrt1K/eIZT9Ky7PHETd+hRIvpNiEumpjc06R39aJwCpTQ3aiL+1PmBGmj5Z336xw1uqnBoMiClfEg8A/9ivEhaXVillzyW9jcMwq/t97qr8rfe/QBNjlhL02u5y7S+CbJvaSRoB/xlhTNUHZwcQc2uo23N9vJGoYtR2IdycDevlkmzntk9+faJPYlBXeU8zJc0HwcjlBLOAlEja9dAVlqwOFochIwa2FP264yVO8roxauNmRkfSpVtZiQ9KT8YxTgdQluCOH8VAolY7Gtl0LQ3dIkiK4zVtS+O+X9odzoCsogP2ABE+743FGaWaoq4bZeS0E2/c2VZiftCNVQcX7Ww1JYEnqZJVq1WGpbqXoVi9Ewh2WCPQxmtNxRx6KwlqZqUQk2BuZ3YA2+gnGmjcZGgEjZCGSOJQIR+5uAxXTLsiGs1RYsdxAsZBEOlRWYwp0tleClfIDOlFRfAWcmXX3s4BWlV2RcJDgSrLcA==
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


