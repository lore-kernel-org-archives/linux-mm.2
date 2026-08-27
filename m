Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09315C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDEA6B0095; Thu, 27 Aug 2026 19:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF856B0096; Thu, 27 Aug 2026 19:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E376B0099; Thu, 27 Aug 2026 19:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9621B6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BE6A1A0220
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:14 +0000 (UTC)
X-FDA: 85148687988.18.F5514A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79FA4100004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpg8qKJI;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jwqj3UUlL63ppxWOJ9ELWriy7estMngu/j/CKSXTY/0=;
	b=VHw4VI90HQiK46elxk6kg/3a4GlmAmzCCLP/4i5KNwchfkzeoJPzdAMg4A3QxjvlO+92fA
	+qMWjAc8jJ3ERNLDIEe3q90yBuMkSwcMycg/pWAeiaYGUmEheUejjXRVDU/CwX/8nMcCq6
	hX77UOAqINVAy+XMb+RgIyyPv7U7sgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874432;
	b=bJZZzhfnVjZpbM2UZ25HG15KnShZDSe3ClWidYRjWHzR21uLHbz4cr4iongJls/WKWY1tL
	egWs1xtOf2tifKzZscnqQ2FF7hSADIRN7HKdLHaOmLK5CcwAkKBEV/xMMonHDk+DW+3FWL
	+NW/+pFkpGJzD8CVP+t5mpLcC6pxdiM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mpg8qKJI;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59E4E406AE;
	Thu, 27 Aug 2026 23:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928A81F000E9;
	Thu, 27 Aug 2026 23:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874431;
	bh=jwqj3UUlL63ppxWOJ9ELWriy7estMngu/j/CKSXTY/0=;
	h=From:To:Cc:Subject:Date;
	b=mpg8qKJISgIJh9ZXhfamcY0wiNT3vF+JPbP+6cP4gQa+NI2+V7OJQBCm3FuCufveZ
	 CGRaSW2fKUFDOUIthAZDSPwjU+ydyvjYdabRXSVAaG+x0wsaDn/UvDccW5mJ6uDgD1
	 FXcAIP0hkiuoKFowgjJ7fECteCDnKoONEWjxYSs6QqHqMdfWcIFkpHJNMV8PnIr85I
	 IsuKKpkyL9FTl7qH/pXTxHMPWHrtqS81xXB5h9mOXStH7xP3RWfP5PTeFuRh8ywqo0
	 FsOh9eQY5WQioqL3TUxGFaPCeIttuKVrdnlO6tvWOD1Jhk97QL0iJEYNDbeqM59YHR
	 4zxpHfsaO+QJg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 0/7] mm/mglru: speed up inc_min_seq() and fix cold/hot inversions
Date: Fri, 28 Aug 2026 07:46:57 +0800
Message-Id: <20260827234704.63163-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3janyecy3decxgnixuqu83m3mahmxrtq
X-Rspamd-Queue-Id: 79FA4100004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787874432-432884
X-HE-Meta: U2FsdGVkX19eFBA21tUV4EJfjJ1uhDohvTvSI0EHzUCzy4zlkibyGoXUkp4H4u3CIsIFfp7trnzsn6KF9GzRDLJtHBIjRTn/ZxiCS9Uj3k+2l49QRSTDeLyG4gb5bPLYcIfGNwoQkEfq31sCydhU6HjFf2hP/lAcxBW6V6iipMtuJsaQpmgy8UIa49IXBuXxL3x0bhJuEyNMh01TcfSwiirJjefZOuC9cIsvRLqQ4VfYc/84MlVEw0ihRNDnkYAEM2wne8Azt7rsPeVDhvsj92EgwYxl3WWDervwix9GR+HRvEx2t85E0+CZcNG6MlL7ocwbTuCB4Ym0EzilDgyanFAx9bUHSenpMj6V9utDGXaxLrDmPnMxJ+cWTgcyKZV28H4qW71okXh4XNpXeGB4B8TnHZUgNhWsf5qJvaisL8wSFt7d2mQpJoBHHxk0ZnY0lr/1azTTWb1wHA3iLT8PRXXS/XYF2eMqD5KKkZDIpJWOw8S2WXlmlDLCCBApmH59JYkRY//qTS5qHMXpDA5XyOmGosMng7krZ1mt9bS8FDvKAWNV1HuLLQSU9G0gag+Lx8Ja2heuUCzR52KUGUh/j+1h2upx7lR8YwYUMujoCfKk1XpWRe7DVmtqBs51jMV02UcI0O8vrOplzBzWYRxfHmd15OgXaNJCBM+dvm/f9JcKAUnHvNddGyjWWnBpnxUHMBbYnjZy2+Xl6Qcc21hSXmn+7mxveGFcA3ta8Fq+Ooy9CgzCOQA8Bzy04JPzd3zczSb21lPHir49c48XvoxOEJWaJRFZVeVpAEiLolVwJeaMYasE3IJr+NoStaUhgXOd7D6qgp2F3n+q7Ag2EUfrgmZARdofX5VF82HF4AJsxuHcY+ABXLP1BdyJ+c0CJ3B9YYr+kRo13/Zyc0YtXKddN4MUELE6970hOl1DGS41ZZblP4pI3P7Q+n2XbyjXwUVe+ay5TO1e5xQqKwhBn5z
 bjRpqEBy
 +gehQtQbQTRyLrp4ynF2S/24RwEr1Y8fGpMZ5i5my9vI4dpjRGvXED1FTOXOoxpoeHZYyzdJowGhS8fRONCAhlBBcCULYHPLsS3fx7PrtLxVS9DLCp9FRX6B2YfAGjBPH9MIMnn6VJ+LeZ885qq1Np4Wnr9d69JwGSt6FVTIPYhD5zhdrOIU+4UjjXV+L56CN6Ul1D+8ep97mfSc+3jM7Umv5oF2bmcl3BBhe28JYtq19KJ79ND/fBhHWVf+D869Vb6h7H3Fq65dNGtr12ZGe/W/KasIyQ4al2GibAuSqGqJEQ0028KIeeUkL96fb/dtTVAveVO7cwv3HOuhR5LG/w5enKq1JOnnS7A42du7FNsZsZk1puThQ5rW0TrjFC/uQP71EO6bRYbGqv1YI6oyI4umwZ0/K6fCl80kd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an aging speedup series split out from the MGLRU swappiness
series [1], with the inc_min_seq changes separated to make them
easier to review.

Currently, inc_min_seq performance is crucial to both the swappiness
fix and proactive aging. There are two problems with it:

1. It processes each folio one by one, while many operations can be
batched or skipped. For example, a batch of folios can be moved together
from the oldest generation to the second-oldest generation, and the
associated counting can also be done in batches.

2. It may cause potential cold/hot inversion by placing promoted folios
(which have been scanned and found to have young PTEs) behind
non-promoted folios. A similar inversion can also occur among
non-promoted folios, as tail folios from the oldest generation are
placed before head folios when moving them to the second-oldest
generation.

This series tries to batch operations as much as possible and fix the
potential cold/hot inversion by keeping promoted folios ahead of
non-promoted folios, while also preserving the order of non-promoted
folios when moving them from the oldest generation to the second-oldest
generation.

Minor issue: inc_min_seq() also counts protected folios
improperly, as promoted folios should be skipped, as in
sort_folio().

We need a stable workload with a stable number of folios to measure
aging and evaluate the speedup in inc_min_seq(). So I asked ChatGPT
to generate the microbenchmark below. It ages an LRU vec containing
512 MB of memory 100 times:

 #define _GNU_SOURCE
 
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdint.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <time.h>
 #include <sys/mman.h>
 
 #define SIZE		(512UL * 1024 * 1024)
 #define LRU_GEN		"/sys/kernel/debug/lru_gen"
 #define TARGET_CGROUP	"/system.slice/agetest.scope"
 #define START_GEN	3
 #define END_GEN	103
 
 static long long nsec_diff(const struct timespec *start,
 			   const struct timespec *end)
 {
 	return (end->tv_sec - start->tv_sec) * 1000000000LL +
 	       (end->tv_nsec - start->tv_nsec);
 }
 
 static int find_memcg_id(void)
 {
 	FILE *fp;
 	char line[4096];
 	int memcg_id;
 
 	fp = fopen(LRU_GEN, "r");
 	if (!fp) {
 		perror("fopen lru_gen");
 		return -1;
 	}
 
 	while (fgets(line, sizeof(line), fp)) {
 		char *p;
 
 		if (strncmp(line, "memcg ", 6))
 			continue;
 
 		p = line + 6;
 
 		if (sscanf(p, "%d", &memcg_id) != 1)
 			continue;
 
 		/*
 		 * The memcg path follows the numeric ID.
 		 */
 		p = strchr(p, ' ');
 		if (!p)
 			continue;
 
 		if (strstr(p, TARGET_CGROUP)) {
 			fclose(fp);
 			return memcg_id;
 		}
 	}
 
 	fclose(fp);
 
 	fprintf(stderr, "Cannot find %s\n", TARGET_CGROUP);
 	return -1;
 }
 
 int main(void)
 {
 	void *addr;
 	int memcg_id;
 	int fd;
 	long long total_ns = 0;
 
 	/*
 	 * mmap 512 MB and touch every page.
 	 */
 	addr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
 		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (addr == MAP_FAILED) {
 		perror("mmap");
 		return 1;
 	}
 
 	memset(addr, 0x55, SIZE);
 
 	printf("mmap: %p, size: %lu MB\n",
 	       addr, SIZE / 1024 / 1024);
 
 	/*
 	 * Find the memcg ID automatically.
 	 */
 	memcg_id = find_memcg_id();
 	if (memcg_id < 0)
 		return 1;
 
 	printf("memcg: %d (%s)\n", memcg_id, TARGET_CGROUP);
 	printf("aging generation %d -> %d\n",
 	       START_GEN, END_GEN);
 
 	fd = open(LRU_GEN, O_WRONLY);
 	if (fd < 0) {
 		perror("open lru_gen");
 		return 1;
 	}
 
 	for (int gen = START_GEN; gen <= END_GEN; gen++) {
 		char buf[128];
 		int len;
 		struct timespec start, end;
 		long long ns;
 
 		len = snprintf(buf, sizeof(buf),
 			       "+ %d 0 %d\n", memcg_id, gen);
 
 		clock_gettime(CLOCK_MONOTONIC, &start);
 
 		if (write(fd, buf, len) != len) {
 			perror("write lru_gen");
 			close(fd);
 			return 1;
 		}
 
 		clock_gettime(CLOCK_MONOTONIC, &end);
 
 		ns = nsec_diff(&start, &end);
 		total_ns += ns;
 
 		printf("gen %3d: %8.3f ms\n",
 		       gen, ns / 1000000.0);
 		fflush(stdout);
 	}
 
 	close(fd);
 
 	printf("\nTotal:   %.3f ms\n",
 	       total_ns / 1000000.0);
 	printf("Average: %.3f ms\n",
 	       total_ns / (double)(END_GEN - START_GEN + 1) /
 	       1000000.0);
 
 	while (1)
 		sleep(1);
 
 	return 0;
 }

Run the above microbenchmark with:
systemd-run --scope --unit=agetest -p MemoryMax=1024M ./agetest

I’m seeing a significant speedup in inc_min_seq() on my x86 PC:

W/o patch:

Running scope as unit: agetest.scope
mmap: 0x72c1b5a00000, size: 512 MB
memcg: 12673 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.433 ms
gen   4:    0.949 ms
gen   5:    2.535 ms
gen   6:    5.043 ms
gen   7:    5.041 ms
gen   8:    5.027 ms
...
gen 100:    5.035 ms
gen 101:    5.011 ms
gen 102:    5.029 ms
gen 103:    5.056 ms

Total:   503.946 ms
Average: 4.990 ms

W/ patch:

Running scope as unit: agetest.scope
mmap: 0x775ec5200000, size: 512 MB
memcg: 12717 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.558 ms
gen   4:    0.916 ms
gen   5:    2.277 ms
gen   6:    2.328 ms
…
gen 100:    2.303 ms
gen 101:    2.297 ms
gen 102:    2.305 ms
gen 103:    2.312 ms

Total:   236.635 ms
Average: 2.343 ms

The average aging time drops from 4.990 ms to 2.343 ms!

Thanks, Xueyuan, for testing this on ARM[2]. It actually shows an even
larger improvement.
Xueyuan tested this series on his arm64 machine (24 cores, 4K base pages)
and reproduced the improvement:

THP=never (PTE):
  baseline: 7.644 ms
  patched:  2.964 ms (-61.2%)

THP=always (PMD):
  baseline: 0.0373 ms
  patched:  0.0292 ms (-21.8%)

[1] https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/
[2] https://lore.kernel.org/linux-mm/20260827035416.3012015-1-xueyuan.chen21@gmail.com/

-v2:
  * Collect tags from Kairui, Baoquan, and Xueyuan, thanks!
  * Split `__folio_inc_gen()` into a separate patch and add
    `VM_WARN_ON` checks for the generation and active state, per
    Baoquan and Kairui, thanks!
  * Make `delta` a `long` instead of `unsigned long`, per Lian Wang,
    thanks!
  * Fix checkpatch issues by converting macros to `static inline`
    functions, per Kairui, thanks!
  * Drop the batched protected update since it doesn't show a
    significant performance improvement, following Baoquan's comments.

-v1:
  https://lore.kernel.org/linux-mm/20260821102538.22642-1-baohua@kernel.org/

Barry Song (Xiaomi) (7):
  mm/mglru: separate folio generation update from LRU accounting
  mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
  mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
  mm/mglru: exclude folios promoted by aging from protected in
    inc_min_seq()
  mm/mglru: make LRU folio prefetch helper an inline function
  mm/mglru: move folios from oldest gen to second-oldest gen from head
    to tail
  mm/mglru: batch move folios to the second-oldest gen's LRU

 mm/vmscan.c | 129 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 100 insertions(+), 29 deletions(-)

-- 
2.34.1


