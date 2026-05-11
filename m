Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11420CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732AA6B010E; Mon, 11 May 2026 12:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3026B0110; Mon, 11 May 2026 12:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1B06B0111; Mon, 11 May 2026 12:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 465AC6B010E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 100701C0487
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:15 +0000 (UTC)
X-FDA: 84755681430.01.8B0BC87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5BDDA20010
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppZelRiX;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIAnVQpQc3Ys1uY8F8q5D/yOgEhQYhnkaUuEsdL/CYk=;
	b=v5Sq+zOT/w4FsoF870FMO95TemwljAIF4Z1tiNNCA4vG64rhXyk49DAPeICDbY0RwA3bFL
	EH14+OvQm2ZgAM3iaIdgDg3cGUGWX3xGzM1pDvPFZnEfH95bdgODqXeOIzXJKUHWpyQjk1
	8B3o76g9QIkDL2ZYwFpw1xQqOtZxCkk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppZelRiX;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517133; a=rsa-sha256;
	cv=none;
	b=jmfeUSHgdTbiU7gHSIcZpskOOmlRp3dJnH74drJ/7xAsCBdMeJhWfqs2SFPIxvlDwiyNyf
	UvHatoV6wA5bZ7JeAozahQq7B76YRIcnE4HpbiyMh5WuXjODfUAD+SjRTI/p/ZW111+/NC
	hQy6MWWotaSEdDlP4LvGt5m4kYHX6Jo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1B8560103;
	Mon, 11 May 2026 16:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96481C2BCC9;
	Mon, 11 May 2026 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517132;
	bh=Sc3/HZdbbpAivY6gQjbOjD+kZQ8Xfjlg7JF0XBxxTps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppZelRiXhpW9/ntaEZXT/rpmV06hR/phhAnv0yPy5oImA+hogX/p6iSN/nSZmFVqE
	 lnhbQyX5scVe93Mqr22iA0Vt6fVqdpJBGaGSTo4j95smaTa5z3NHUC9iAyUY5d93/S
	 6aK7KEXnuiHW+vdOEMt7QmzUBERgQh6+dlNEGo1glr+MoKNUZRgLLTDI1ucckDjPct
	 cq4zMm3lvAcQyLr6thpn6m+oPtiLB1rVSUa69sLrjxuH1R2Wifapg7/XcVCCEDTl/v
	 p8rgfDVX/RyHowgjWZtUzVt8z1ULr+GxavVOsLSYrKIsUJLao30k3/mjWdUrjqg3Rp
	 tZ4L7yaMF6MZQ==
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
Subject: [PATCH v4 31/55] selftests/mm: compaction_test: use HugeTLB helpers ...
Date: Mon, 11 May 2026 19:28:15 +0300
Message-ID: <20260511162840.375890-32-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BDDA20010
X-Stat-Signature: khy7p6wg6dkn9jbg9am7n6pwd6g9tddu
X-HE-Tag: 1778517133-242577
X-HE-Meta: U2FsdGVkX1+tQkrlNwqIlqBHoimOK2PfcIjViyq5DXZE/KLEpM0HhdhtGFHWBSx95PhacFes3zfR0YG7CGE2RzmEZrFHDxShPkuwfzZfNmqn47nGNowWLbz9ha8yKM1BtlHhRZS0HF6IUfrfXCJtkub/OTxCz/xYo2rJtQygaUaSin9FXLw5QYKCUXPUjOXRplnHnjdaosXmiQI42vR8092ssEMQYEY+/X3NGrzcinlJLig/v99lq1Ey369rvJ6vQEqdzoM+a9wQ3BTQwVt67vqT93wQ8KLR9koIiQpXWnTLQSPjZoLVieRguBpOKJi+5ScIdN2Wbq3Txq7QvjDNXwsr0GBfCzrdfbtAZR9O65KsN7OfHqpUiPRxX11ihNe+KdagLy9Uvl0zCV3JVLx18cByjRqbD35jPJUHcIvhn7WsPlYONg80iZKWpsXN2bSFJpKjh46fLJ/Dkh3LOtWk35Umlvi2H2mexQyvmK7PdRZkvakawRw9HgGF/hDEzsL22SBDne3vbdfPaBt8DM9AeRRa1AjlQdhcH3VQSf6b8jFgzbzh5n4ddIHQ+3LmWMOE/et2Hl9O8Q0aKPheYHhyV3V9/nrzmQ0MrGABVaa3ZGbCXQAJjPb8FnXHtb1ZJJ1KyFITN9K3XRs1Rwt2U0g6tg6FE/1f9LotEV3waWnXVF5LcxQ9RXoCHXVh/O5IANXINTr/IkhOQQraa/l+t0u9CCvzzPGcrVJWE01QUd/WbmFrnmTP1i6KuAIXO+sIfC/dRTzPVLP6zcrT9MOgqqmHb7M17rL9V4yyVicTJtAIpqSJ0CNaLz8gIHllii2AH46DMMq7WoweR+Rrzi/gxohCb5dlHkQY9OToJRT5tk9K/N19fMOM6qKj3sXQF6TqE11/qxeSY6jM5vKBNQNrHwtcF9PdIMZsAwIRC7QsurjHSSxcMaNCR9c7j1/R5RukiYH1iWBbWujH00IEouaUxFQ
 n6iCqSOp
 nFqtjuv7fopqXIxkvDvcBOJdxYgKm/P+jCsUQrartDzsvBOgOg4F08Ko+Kp63ds81tgvsqNSAdL3M+6I3LmOREiVAQLomUSPUnP0BIOaE2enlbvAAeQTLb865zWB1fduaPGbXqMXvxjE7QQONAYkYGWXBdGWb9Qw8rX5i8Rptanh1qyIfCWEIQEExgcdLj/KV1FunhN5FmoYbuONhmqLOwV8pAKwLktQJfXtVx+RuU+3/fKEFdQgVUPF7zyTk8ebqkMwDFEYlTdRqFz22wGsWfi0WwcqE78QmCOMGX3R7YlNSicANuWNHlnXIN6h4TZ0pXfiM/4yGL9ZYrTXhpJ+zajgxBeObdikB4yjKBOAqVej7vSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of open coded access of HugeTLB parameters via /proc.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c | 115 +++----------------
 1 file changed, 17 insertions(+), 98 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b697..de0633f9a7e5 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -17,6 +17,7 @@
 #include <string.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MAP_SIZE_MB	100
 #define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
@@ -82,124 +83,44 @@ int prereq(void)
 	return -1;
 }
 
-int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
-		     unsigned long initial_nr_hugepages)
+int check_compaction(unsigned long mem_free, unsigned long hugepage_size)
 {
-	unsigned long nr_hugepages_ul;
-	int fd, ret = -1;
+	unsigned long nr_hugepages;
 	int compaction_index = 0;
-	char nr_hugepages[20] = {0};
-	char init_nr_hugepages[24] = {0};
-	char target_nr_hugepages[24] = {0};
-	int slen;
-
-	snprintf(init_nr_hugepages, sizeof(init_nr_hugepages),
-		 "%lu", initial_nr_hugepages);
+	int ret = -1;
 
 	/* We want to test with 80% of available memory. Else, OOM killer comes
 	   in to play */
 	mem_free = mem_free * 0.8;
 
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		ret = -1;
-		goto out;
-	}
-
 	/*
 	 * Request huge pages for about half of the free memory. The Kernel
 	 * will allocate as much as it can, and we expect it will get at least 1/3
 	 */
-	nr_hugepages_ul = mem_free / hugepage_size / 2;
-	snprintf(target_nr_hugepages, sizeof(target_nr_hugepages),
-		 "%lu", nr_hugepages_ul);
-
-	slen = strlen(target_nr_hugepages);
-	if (write(fd, target_nr_hugepages, slen) != slen) {
-		ksft_print_msg("Failed to write %lu to /proc/sys/vm/nr_hugepages: %s\n",
-			       nr_hugepages_ul, strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to re-read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	nr_hugepages = mem_free / hugepage_size / 2;
+	hugetlb_set_nr_default_pages(nr_hugepages);
 
 	/* We should have been able to request at least 1/3 rd of the memory in
 	   huge pages */
-	nr_hugepages_ul = strtoul(nr_hugepages, NULL, 10);
-	if (!nr_hugepages_ul) {
+	nr_hugepages = hugetlb_nr_default_pages();
+	if (!nr_hugepages) {
 		ksft_print_msg("ERROR: No memory is available as huge pages\n");
-		goto close_fd;
-	}
-	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
-	    != strlen(init_nr_hugepages)) {
-		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
+		goto out;
 	}
+	compaction_index = mem_free/(nr_hugepages * hugepage_size);
 
-	ksft_print_msg("Number of huge pages allocated = %lu\n",
-		       nr_hugepages_ul);
+	ksft_print_msg("Number of huge pages allocated = %lu\n", nr_hugepages);
 
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
 			       "as huge pages\n", compaction_index);
-		goto close_fd;
-	}
-
-	ret = 0;
-
- close_fd:
-	close(fd);
- out:
-	ksft_test_result(ret == 0, "check_compaction\n");
-	return ret;
-}
-
-int set_zero_hugepages(unsigned long *initial_nr_hugepages)
-{
-	int fd, ret = -1;
-	char nr_hugepages[20] = {0};
-
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
 		goto out;
 	}
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
 
-	/* Start with the initial condition of 0 huge pages */
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
 	ret = 0;
 
- close_fd:
-	close(fd);
-
  out:
+	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
@@ -212,18 +133,17 @@ int main(int argc, char **argv)
 	unsigned long mem_free = 0;
 	unsigned long hugepage_size = 0;
 	long mem_fragmentable_MB = 0;
-	unsigned long initial_nr_hugepages;
 
 	ksft_print_header();
 
 	if (prereq() || geteuid())
 		ksft_exit_skip("Prerequisites unsatisfied\n");
 
-	ksft_set_plan(1);
-
 	/* Start the test without hugepages reducing mem_free */
-	if (set_zero_hugepages(&initial_nr_hugepages))
-		ksft_exit_fail();
+	if (!hugetlb_setup_default_exact(0))
+		ksft_exit_skip("Could not reset nr_hugepages\n");
+
+	ksft_set_plan(1);
 
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
@@ -268,8 +188,7 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size,
-			     initial_nr_hugepages) == 0)
+	if (check_compaction(mem_free, hugepage_size) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
-- 
2.53.0


