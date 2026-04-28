Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F815FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0598B6B00E7; Tue, 28 Apr 2026 16:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031336B00EA; Tue, 28 Apr 2026 16:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6176B00E7; Tue, 28 Apr 2026 16:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D65056B00E7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EC448BA6B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:30 +0000 (UTC)
X-FDA: 84709150260.14.F1D7638
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C900E4000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hTSKErDk;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RJVgzxK2skC7c8wV5E2gTZKDloQXvOWYd5xOn2lzzo=;
	b=kuGHiIjdfZyg+B+7Qs8geuZlhz/q3eGdXv07dQQdnmdLgd0Ecq9EyXhFzzx7uLrHzgWCWR
	f0SPXn92vQ286FF0u7KiDknJQaLAMA3zPF8gXRJnt0CnRubDPvNvjaBPFraJaNPE765qGn
	nR2gwkKXsfhUbSyIzadXs2/8/k2Sfs8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hTSKErDk;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409248; a=rsa-sha256;
	cv=none;
	b=7zGxFHgkuKsnQZUWiKJzEz2MpmjeotGSFJDgVAEBwUaeTPPuCazf2E4Gcl0/T5Js03cyVQ
	QhSbMO400w4A5Cl6NYwgJ+NlUfimXI1PWFzjoU2UzBtjQAzT1hajoDFoJhtQC2vH/iFskp
	lBusNV+KI7R5NW0tEzoNl2igF1/J8fM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 400DE6111B;
	Tue, 28 Apr 2026 20:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC85C2BCAF;
	Tue, 28 Apr 2026 20:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409247;
	bh=Ebag/OZwcEEdNBOTVBqp4Cs1aPruonU0XrgpI45ideI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTSKErDkybfCmLqI5oiKe46Ogfo/Y09QcaiEPkLkkehXIETqPunPVRIRgvXEYiguP
	 2ArwVKUZiz44sK667Yh55r3q/rQoRx+NvAILknozgaKiPEziz+setvnb9pD85Hm4W6
	 FMpGTpoQyv42luUMlmkVEnyjQ4NvvJg0H5DvtOURoqmYZU5d9QF3SwmsxDKz0aRYYF
	 byi54caBi362T1N03+DtxoirSiSHBwY0Vrp4tt7A2Iq/ESFGT6ZWuWorDEY3pYrQin
	 qFig5BZ5odFLdQm1Wm+BtZaMJzSbZ/7dFW5idmRLtNSIvoc3uBePn0qhbnIdIfxLBO
	 12z1PteHCCiIg==
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
Subject: [PATCH v3 42/54] selftests/mm: hugetlb-soft-online: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:28 +0300
Message-ID: <20260428204240.1924129-43-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C900E4000E
X-Rspamd-Server: rspam06
X-Stat-Signature: tcq4g5jbzmrij9sgyryd9cdtkmgjy4q5
X-HE-Tag: 1777409248-693278
X-HE-Meta: U2FsdGVkX182U9QXz3iKu8YrKIjIGZM8/PmWlYMTIvEjePCQqEoa6Ai3K+x1PwEwB9wkAxBwH8paAHY+wsWoKO6WL8C3iq52eh2gdAmV0qZEyDxJrp+QTALVCk8u8y8lpurOvs8lo0PmRflifq3zmKUA1AJ3htTiwov17cqdql2nxMkOjLg2HXdP3hwyxIbD88BAYWt6GzvSiA4Pns41gYjeRAIoPEgzOIMjtyX3OTQgPlLfwvwRyvRyFfjyGRgW69CmWYR3XifkootSIUif7aX2KHL6zfgLQYMK1T2N6rDW885KMmRsxaQeoeUGqH+G/IZta1A6srOjDKgSF513VaYiPSfFPwwSRPFaheJx10rttheQzxzJud+Kh7ZlEUzMZAebYvYg0E2VUptapTnwXZYsMSTpoZFx5W708xCC0SwLPgjFsfAerwdEYow7W0p8NR5ch/OBDneVuFU3xtuwe1ips1NB0svO6NxKh/i5CvXPgGq4/v/vRxXLJ6aNnEDAtcJnHI6U9PkwN82tPC7rMLjPJgzWL1tU7gFHHxIl1547Uuo+4gwj6hfXmGecL0CKd/oBbdNpyKNneW2BrtPt3bpGms2MnCNXoPrZSRw9ULg6REAFYr+MavUxRk0zsf7hr609XgaGffU78MA93hE696OxTdi5GMcMl2icfQvVnxAef8XOkuhbddtVB2S725SexZLt4WX6V06ndfv+45LuwzzOCYAmPGCFYTL0pDbwYeYxCQrXN+nTIp8jzMfQGhxkLgQoJPL5fbvUIltcHEoL3CH77QYEB92ZalLjpClNyv7elXbnaQZN4QT/kQ1DMdEwtsHlNJY+RH7d10eEl4vItAaJzxLvr5RfXTBNyncdfJp0cGtnMcBl08DQwd6ipEGgp2ynAPHY2j0jKE/3wk7OU7tfYNSWAkJxauk8FEaqJa7WfcylfWf9AXgYkqHKIoe4/Xz1kpqjI5vm4Gr5I8E
 Nc8rKMGJ
 OqDj154pl52rCowHLCLuY7nyvE9m3NGJjrXPsQK21hKTn/ptPZkiZsfIJGGArHkc9uQ0283QbRk8V4qQl5zaMAWPxaXJCgevelYFq9UwfYK0qOQLHxydeXJJagOLGSDPfWQh4fHXLP2pklKJMWmMUr0E6kkFMQWUdWVwJkyuxiFR1Mqg4GjK+MjBjBGQ56WXBtz8ShUM34UCPrQBTQrJBXE+A5cVb6uOQUmZwd0FpvC/bO50=
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


