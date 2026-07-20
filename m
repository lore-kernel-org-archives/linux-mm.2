Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC95AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 10:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1466B00B4; Mon, 20 Jul 2026 06:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678216B00B5; Mon, 20 Jul 2026 06:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6356B00B6; Mon, 20 Jul 2026 06:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3495A6B00B4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:31:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C43591A010F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:31:20 +0000 (UTC)
X-FDA: 85008787920.21.70AA7FD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id D47304000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:31:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tn0rd8VY;
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784543479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7/4E30dWd/r9Ixwqv3bOIfleJOo9BQuuFU84ua4wovU=;
	b=SOT3r1VFx7gtdeGU9Y+v1vh7fTUV7iLdkBlDWcD5Vxz2bFKruhJniWI0ySsmopixzaoXHj
	BQoxCmReQnwnAnOLG69/bRe7yWBn3qyV1MgYw6VPKBynj4dVsqhQAC+1cOWsWa34ooFyDw
	t4Ty6URB6n/co3x4zvYTinhNhchQqKQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784543479;
	b=LLqCT52qXC95r2rRYrieU4DJzgn3CKuDsvtWpEhV5ZLseWHqHsBmiQjENWiYy0ZWzyoygO
	JDrxCBA/f6CAfMCFwHNc5bvWGfNCHnhHmZl8U//nmqbojT9At3VhQwvyCq/5PTk1TZm7f7
	iD54MAOhMgTE/SDv4UTru4/rcVEfnsM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Tn0rd8VY;
	spf=pass (imf11.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 757B72B;
	Mon, 20 Jul 2026 03:31:13 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E5E6B3F99C;
	Mon, 20 Jul 2026 03:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784543477; bh=vzn4MVwPB35KOU7txBTLgrtF1+3qwX9TWdwyqaeM1KE=;
	h=From:To:Cc:Subject:Date:From;
	b=Tn0rd8VYzBzf42E3UzcxH+qfA6Ssr4+b9iH9BWyM38kqdS4xHA4NVlaTuj7WnjRK3
	 5rSCThNE/EIwTQWRQ7PBORKDOVdaV/Kzs0+6b46h6QjiywVndUA806Xp7IoVd3zXTZ
	 U+uh1vsEXJL522Wct2++RfA5EjV1zBpYy4N30N5Q=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Aishwarya TCV <aishwarya.tcv@arm.com>
Subject: [PATCH] selftests/mm: transhuge-stress: check duration inside page loop
Date: Mon, 20 Jul 2026 16:01:05 +0530
Message-ID: <20260720103105.169955-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cd8hfd64zfbfmfuwtb6xbr69dtwtqod7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D47304000F
X-HE-Tag: 1784543478-971007
X-HE-Meta: U2FsdGVkX1/+1r63eDegk2GH1e6zOL8ggGSmVO15qnrT7QKC3oCikQV/ArVtUdFEvs/1ryl4SVqAEgPyq4XiuYsFMANy25LYiS3S9TYgtND8bF2BUYuvJ24a+NMIzqBvf688otlONIeajeRzs9wGQKbtGjEJasdcZcqRzSo7pXEdsiT8SsOwkwQslxwMlY2umJGawgnmSWbFXalYARtSWyXcviSQwGVOtmwAc/z6PiS1xWDaX4LZSfprHlht0RgvYlVJMl5eET3zGpkhHqWedSwcU4nshWgKX+FbHbreTjQkmilXcEDPrNBA58GNm3pUD0slGGrs8MV4A4YLOGIps4h+aW5nQCcdYGHO/9Wtgus9WYYvcZW6s+sycunVj5aTWrCThZBJ0QywOmwAVhduxWP0kHExDTTKGqaz8iq1A5bsSecaYzMPPHF0DSOqQafr8tYPCdZHK2dTCjbiurpUD5r1/CAGaupooBsIzmy0Yv5OubK+QNN/+Mg2GSRrd426pjoQMXEGJ+kycA916r+Z50EqBafUpi4APkwv7UWm+LOTS1uRk6oP44J4CFvAENG1FlaIeO2Zs3gmcCvfYCmunfnWhiHe9fo0UiVJ8rDnCrawaqTzORJ16TdeJVLfYPrlzFKYyge2Oy6gOo1zf7AB+WSZLYCsIIR5vU6cy6p5EJkO5fv5nAywM+IRiEps0OdHGxZHrJXMGxk0wjnZbjFSUqqDvIFSGlKRVlqQjNTGUl/xrEMoG6WbnQk80d1EFWQqfdKewpF+zYxsIC5hHD/tBA1w6c/EzZr0TbhkdMmD/gq52zICGWSffQtfv3zzkoJKXHBc8MzpFyp4xir/6QLGjHPBqzH41/lTtbDLdsnmMKQ1ARsiN1vdqbnzdv97ooEVcHuaNlxa+BTvcGVnDpxdoZ96OwAYRgnJnZ01L0NgzXDlXnMcezjQuCjgs5RJcwpJJxGWpPVSDre0r9SAXKr
 6XIec704
 oRhqglDTEMwTd4P1I1dKhPmt20L2l9hzKvNdXUJej3PAlzB8bYeuUA5Qur+Ev8yvBAQwNP/BJi+xS0dn5d+MCdAY4TnUlfmnqsfge9UAejMAh3xJO42bcWpCI+756wzJeXVxYgZbGuX+x39ndtHW85o7WWubaBp0QPmQsEo7iiKb9SUegbuu1xZGWtqB+BhLArduCJmeIftZTPdaDdFt4OXBADgIqzSRSYLUUSCCCX+tSuy7M+D+HPP0BjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

transhuge-stress.c currently scans memory equal to RAM by default,
in jumps of hugepage size, trying to allocate and split a THP at
each step. After the entire range is covered, it checks whether
elapsed time is greater than the duration. But it is possible
that the THP work it does takes time more than the duration itself,
causing the test to exceed the CI timeout.

Check the elapsed time after each THP operation. If the duration
has elapsed, break and end the test. Adjust the statistics
calculations to accommodate partially completed passes. Also,
reject sizes which are smaller than a huge page.

Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Tested with -d 5 on a machine with about 250 GiB RAM.

Time taken before the patch = 4m26.793s
Time taken after the patch = 0m5.198s
---
 tools/testing/selftests/mm/transhuge-stress.c | 30 ++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/transhuge-stress.c b/tools/testing/selftests/mm/transhuge-stress.c
index 8eb0c5630e7e..a0f9fc900360 100644
--- a/tools/testing/selftests/mm/transhuge-stress.c
+++ b/tools/testing/selftests/mm/transhuge-stress.c
@@ -35,6 +35,7 @@ int main(int argc, char **argv)
 	size_t map_len;
 	int pagemap_fd;
 	int duration = 0;
+	double elapsed = 0;
 
 	ksft_print_header();
 
@@ -60,8 +61,6 @@ int main(int argc, char **argv)
 			len = atoll(argv[i]) << 20;
 	}
 
-	ksft_set_plan(1);
-
 	if (name) {
 		backing_fd = open(name, O_RDWR);
 		if (backing_fd == -1)
@@ -78,6 +77,10 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("open pagemap\n");
 
 	len -= len % HPAGE_SIZE;
+	if (len == 0)
+		ksft_exit_fail_msg("len must be at least %d MiB\n",
+			HPAGE_SIZE >> 20);
+
 	ptr = mmap(NULL, len + HPAGE_SIZE, PROT_RW, mmap_flags, backing_fd, 0);
 	if (ptr == MAP_FAILED)
 		ksft_exit_fail_msg("initial mmap");
@@ -91,6 +94,7 @@ int main(int argc, char **argv)
 	if (!map)
 		ksft_exit_fail_msg("map malloc\n");
 
+	ksft_set_plan(1);
 	clock_gettime(CLOCK_MONOTONIC, &start);
 
 	while (1) {
@@ -125,16 +129,28 @@ int main(int argc, char **argv)
 			/* split transhuge page, keep last page */
 			if (madvise(p, HPAGE_SIZE - psize(), MADV_DONTNEED))
 				ksft_exit_fail_msg("MADV_DONTNEED");
+
+			if (duration > 0) {
+				clock_gettime(CLOCK_MONOTONIC, &b);
+				elapsed = b.tv_sec - start.tv_sec +
+					(b.tv_nsec - start.tv_nsec) / 1000000000.;
+				if (elapsed >= duration)
+					break;
+			}
 		}
 		clock_gettime(CLOCK_MONOTONIC, &b);
 		s = b.tv_sec - a.tv_sec + (b.tv_nsec - a.tv_nsec) / 1000000000.;
 
 		ksft_print_msg("%.3f s/loop, %.3f ms/page, %10.3f MiB/s\t"
-			       "%4d succeed, %4d failed, %4d different pages\n",
-			       s, s * 1000 / (len >> HPAGE_SHIFT), len / s / (1 << 20),
-			       nr_succeed, nr_failed, nr_pages);
-
-		if (duration > 0 && b.tv_sec - start.tv_sec >= duration) {
+				"%4d succeed, %4d failed, %4d different pages\n",
+				s, s * 1000 / (nr_failed + nr_succeed),
+				s > 0 ?
+					(double)(nr_failed + nr_succeed) *
+					(HPAGE_SIZE >> 20) / s :
+					0.0,
+				nr_succeed, nr_failed, nr_pages);
+
+		if (duration > 0 && elapsed >= duration) {
 			ksft_test_result_pass("Completed\n");
 			ksft_finished();
 		}

base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.39.5


