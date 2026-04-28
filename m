Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A657FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C466B00CB; Tue, 28 Apr 2026 16:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D766B00CC; Tue, 28 Apr 2026 16:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52C56B00CD; Tue, 28 Apr 2026 16:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A64596B00CB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74B47A03E8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:11 +0000 (UTC)
X-FDA: 84709146942.26.EA57AEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC33C40016
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rr0hw0LU;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZEoU0IwQOpsi82G7gijaBWYu7kGWrJYGFpJPct+BF4=;
	b=lzFb4zQGx2OFd+1OLUhNpZJup38LcoZV6VsOqOuHYhB4NBju+LXKllxAea3LOhbtWEgl7x
	OjfCjyJyc3ToEg11I1Np3TudLLaiaOwE02nemITZIIRvZq3bpvFzWGcyfrY9H0hrWp+p4c
	D2UoMer2wMdIFAdm5tt4KjuKgfEpwG0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rr0hw0LU;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409169; a=rsa-sha256;
	cv=none;
	b=cYherlTZ8GR25iE7lao/lsh0/0x8k0FHaJYWBy2FR0vZmIjtPiW6nv5lxNwtB4I6qYLX14
	kz3M1cVA0aZ/npr6EUw76UACMKQFTtKHLayOifQt+i7mgijo6J9mi2IRoSC9RriTLJEL9d
	+DieSlE197IGw32vLF7gupMgQPQE53o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B9886132E;
	Tue, 28 Apr 2026 20:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E1CC2BCAF;
	Tue, 28 Apr 2026 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409168;
	bh=t2OQ6d8PPidPjQSh+RBxS6XeDUdzwdvT/+uZ5YR7P1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rr0hw0LUtKEvE2iGFOvQa01r4+uQhBZmgmlRCrcvNjFHvUYxNcgOXCjQg8cDxV+R3
	 GrkWXmjBKsDLBkYlxjqfML6Hw8vobXSCWks3yVeOGPMvzO8PRzsR7ilR4qeqsY1+84
	 kiaM95+umtOqNRdeiIXrpYhIjMoAQv3nMHJwTSCWbdVR9R1UV0UDzRQGCIid4SZfHY
	 3DrCVejINPDNVWPtRSxHTBInOLl6JmdDk00DjhEYUnd70EQ/4VW+Vq17OfcfCLHlMl
	 2YsWF+C+T2Oaz889Y4XNKMkBj0GonDmPT+vJt3yrnSTI7U4PqxZX8mnEaT1EdoAtcg
	 8bBLUlLZAN8dg==
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
Subject: [PATCH v3 30/54] selftests/mm: compaction_test: use HugeTLB helpers ...
Date: Tue, 28 Apr 2026 23:42:16 +0300
Message-ID: <20260428204240.1924129-31-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC33C40016
X-Stat-Signature: 9bas7rxnefrczbgoocpmz3qh5cu8hc3o
X-HE-Tag: 1777409169-453517
X-HE-Meta: U2FsdGVkX188FqIvEwSRv95tPBsjrAK0iuS82sbzE5CnBPkzCup3hIM4Jl8cp3Ww90ehG6endaPZwmIXfYahD4E+HQe9aepsitVj1IZQXKB4FKpHvmjC/0OOiRuAYVrzGOX+56N9GIEmbYgCHOALWDN2+bnw5FdfPrRY9nMkHbgdH849WsBaNgEecMapVxYTnP+erykCqhyt2nxWzQxLxcKEPzUfrvd5y1ySIhm1e6rULTZ4AycGHUIHDGXAT6JQmPm/w3F/Y3SXIQhYeE9u7VXutiJwVLHIH9UqTlN4Op2gQpSCE2sHQp5GWgfhP0GvUMD1eHC+EdGC2M877Wi+oiKNqPuvzxr+vocOKHaJoQOlCa2hnpvIIP+7TKlMpI9jwODs4nvXUQ/82ryv7uKqrqqkat5ZvS71igG2dkY21+3UDLjB8Uj2sYDK3vj5IuS+xRB6nGFtIctbM4h6znJ3EA2J/CK8zb2RruP7cF5fpa97F2I3bIMOtrVokgyKlt3bt35ffhpaHuHXNHyXpwIyiM+69+e3TQztSDV6iVp98YA+dKBFJLwuh7rupof2lgj4vI0znBzEYkGVulasMZBSMNU4iYS9zpNtOTF22RS16cEZp7iMFzzGGjZ8ecJfNcw6wY+LYbL5Uwvqkx84tmldHkcm1MxtFMAbyCPeVk//cy8QfmSU1S1W2B5vxSwgC0NPzub+DFjcMti9tRznqq0wCiGlZGpFM5dePAenk8dZIQ5eY7oINBL6ArBg7CSz2NUgw+S8z1SOrTE5dPhygMGUdLWehoU0TvDd4CvhlOuvpDifVS+8y/XYEJJ6aGg1CMA0sRkJPDJUnOTfjyCg5QEOd1u29+tZ/u2Sd1DyUtY9MEG3d0QG2TnoMC1PWv/PJb37V45SlPvjhmbqnBxC6+ygaQo3FIz5SiMS14D2kybfkrVIN9n5gUrdpCet8QGxYcLsJsvw65NKgk2YGGisanZ
 9khUKjp2
 /eZHdYLLe1AiiDvW0kGsPxBQFKfi1SqOV1CTM+SvvLxEqHAPpAwC/Vlir4WNpg0zXIKHnN+IM1dJLO110TlSU371iEOzLcO94O+UefMoZbvQtHutEECeeMLDjmjpQb39H7xxyG0krHBNPKYS3MCJLuH+oc8YHMYV5O30ruuHnSkSb4qPUd5hniOE0poJ6hMWZ+2LKO+NukphvX4TioxjY1sF6YgoS/g6w7TclyxnrWpL/aBp1fItQIbpaDfLnWz5Bd1YwOnl1t+dv9SxLZxcQTaMzhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of open coded access of HugeTLB parameters via /proc.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/compaction_test.c | 113 +++----------------
 1 file changed, 17 insertions(+), 96 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 30209c40b697..962a50c3d66f 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -17,6 +17,7 @@
 #include <string.h>
 
 #include "kselftest.h"
+#include "hugepage_settings.h"
 
 #define MAP_SIZE_MB	100
 #define MAP_SIZE	(MAP_SIZE_MB * 1024 * 1024)
@@ -82,75 +83,33 @@ int prereq(void)
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
 		goto close_fd;
 	}
-	compaction_index = mem_free/(nr_hugepages_ul * hugepage_size);
-
-	lseek(fd, 0, SEEK_SET);
-
-	if (write(fd, init_nr_hugepages, strlen(init_nr_hugepages))
-	    != strlen(init_nr_hugepages)) {
-		ksft_print_msg("Failed to write value to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
+	compaction_index = mem_free/(nr_hugepages * hugepage_size);
 
-	ksft_print_msg("Number of huge pages allocated = %lu\n",
-		       nr_hugepages_ul);
+	ksft_print_msg("Number of huge pages allocated = %lu\n", nr_hugepages);
 
 	if (compaction_index > 3) {
 		ksft_print_msg("ERROR: Less than 1/%d of memory is available\n"
@@ -161,48 +120,10 @@ int check_compaction(unsigned long mem_free, unsigned long hugepage_size,
 	ret = 0;
 
  close_fd:
-	close(fd);
- out:
 	ksft_test_result(ret == 0, "check_compaction\n");
 	return ret;
 }
 
-int set_zero_hugepages(unsigned long *initial_nr_hugepages)
-{
-	int fd, ret = -1;
-	char nr_hugepages[20] = {0};
-
-	fd = open("/proc/sys/vm/nr_hugepages", O_RDWR | O_NONBLOCK);
-	if (fd < 0) {
-		ksft_print_msg("Failed to open /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto out;
-	}
-	if (read(fd, nr_hugepages, sizeof(nr_hugepages)) <= 0) {
-		ksft_print_msg("Failed to read from /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	lseek(fd, 0, SEEK_SET);
-
-	/* Start with the initial condition of 0 huge pages */
-	if (write(fd, "0", sizeof(char)) != sizeof(char)) {
-		ksft_print_msg("Failed to write 0 to /proc/sys/vm/nr_hugepages: %s\n",
-			       strerror(errno));
-		goto close_fd;
-	}
-
-	*initial_nr_hugepages = strtoul(nr_hugepages, NULL, 10);
-	ret = 0;
-
- close_fd:
-	close(fd);
-
- out:
-	return ret;
-}
-
 int main(int argc, char **argv)
 {
 	struct rlimit lim;
@@ -212,18 +133,19 @@ int main(int argc, char **argv)
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
+	hugetlb_save_settings();
+	hugetlb_set_nr_default_pages(0);
+	if (hugetlb_nr_default_pages())
+		ksft_exit_skip("Could not reset nr_hugepages\n");
+
+	ksft_set_plan(1);
 
 	lim.rlim_cur = RLIM_INFINITY;
 	lim.rlim_max = RLIM_INFINITY;
@@ -268,8 +190,7 @@ int main(int argc, char **argv)
 		entry = entry->next;
 	}
 
-	if (check_compaction(mem_free, hugepage_size,
-			     initial_nr_hugepages) == 0)
+	if (check_compaction(mem_free, hugepage_size) == 0)
 		ksft_exit_pass();
 
 	ksft_exit_fail();
-- 
2.53.0


