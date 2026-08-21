Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD849C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BF46B009F; Fri, 21 Aug 2026 06:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E032A6B00A0; Fri, 21 Aug 2026 06:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D402C6B00A3; Fri, 21 Aug 2026 06:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9DB66B009F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B041B1403F2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:20 +0000 (UTC)
X-FDA: 85124896920.15.CF7CE8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20BC1100004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fbq0d4vM;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DImEcDtOKUY2rAhijhJNaWF8FQiu+X6BoqAJgd4cEOM=;
	b=yC6duTS3g6Y19RwzKTjtRGWg5C7mZGU3YDVyvzS5Z57U+upnLIWzlKaumup9H2DFF92ASb
	RTHTxQct28TeA1Ew2IBxfuMUfLVFAL4xKZTwTRlVXW5tLM7WWneJijHYfBB1Il3doYid2b
	65zebO7KxIzz4sUMsEdz9TxBvY6sQ74=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fbq0d4vM;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307979;
	b=Q8PjvjDvlHgOC5y0OjQptHOJPhIGDrEgVqVe5XNWiGmJREjhiwnLzga8uC+zWbuJkzryl2
	EqGV9DxPo0OHqEKQjzuWSg9jJuNVepAlM574gTOpe1zxjuVPW/kDj/cjgVbLN9UlhvvDcQ
	YZV4zmTYpBJIl/KROt8w2lbvaLcziHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53E37406F6;
	Fri, 21 Aug 2026 10:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCF51F000E9;
	Fri, 21 Aug 2026 10:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307978;
	bh=DImEcDtOKUY2rAhijhJNaWF8FQiu+X6BoqAJgd4cEOM=;
	h=From:To:Cc:Subject:Date;
	b=Fbq0d4vMNd3d7+s+DE1ZJPxLzlbTpOctIuZyaxcizV+27mCifm8+4C1vLznc8JEZF
	 uq0NQ/BfbbNBz/mi/TW5tUmntUeoOlINBy/VGirTKLHIYdnXwtbA2VsBjMTWlGBQpK
	 7tDkfkP5PNREGldA/fAlm/LfpEU4EmUfLFzlzCTzieWSxICz9Xo5XIaMnESYdAbKcW
	 lfA8FCIAZ0J4N+FKE9gAterklHs1TXsG+BMvthUZ0keL94EQj4A0opRoq75Vz6mEfX
	 6wHUG/FFYaTeH67kOJZGJkw4i9j8HpIC/dO26VcFUlvNb5gZ2BRlKC14ZOg0FMCbBR
	 TlFwunhkT59Sg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
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
Subject: [PATCH 0/6] mm/mglru: speed up inc_min_seq() and fix cold/hot inversions
Date: Fri, 21 Aug 2026 18:25:32 +0800
Message-Id: <20260821102538.22642-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20BC1100004
X-Stat-Signature: tbbit7yp4fmn36ku1f35qw8d68i1hbc4
X-Rspam-User: 
X-HE-Tag: 1787307978-694384
X-HE-Meta: U2FsdGVkX1+DXDB4kfwLoRuqzESNambXYTwOJg3HpvtdGmul2kL4JqUff8suPP3D49oM324AGzHagN/9jICVW3hPgZJmEOrf03eyJyvG4hysgFRdJhnFW3TYxKiOzoskz55nAikEf9m7TYezmyL8W+RAaErbRXgH5XwZz+Ns8lAh/Tsw1BnyvtA0+c/MqpX2ETOuiL05MtSAtVWX+N7C01GVwpeDdwy38x89wLPPWzoCofDnAxrBiKlg1gsQw1jwuU9QuwCWFO60oiufqv9KW8h5beiFc48P8lvlKQjVDWihbjhlnQYdvVQBsIeUMsjSuz1ESlScwYiV+MuJNec01srRRJyukiaveLqP3aLfzKZI2IML3lnNy/N7+Uy2fME9C0NDnjtqD6dLxInzQd9HvLaRCsXZrJfONNiyFAXyJbYJt7E0o1yhKnAERPG/E5luY9E6MQ2qjUtKayHomIQWuc3FaaqdxhEGDzDas6XII8NucWv4Jk/VBwaHpc2rI1N606QOvw8s4+awWd2izDhOzH2z8FBf/nKVO5bzcxW+FJyx05U69gVMyLzQmvtNQvhpla5u4TUvOeNzhoelum4O+EGr1it+eowtcIg2wVCKvsjOhfernm7gWk9HZT3AA0b+wZT+SM2pFtGIxpJDiV2fm9K4K38yeJmbAuX9+6DrnArGBg2pPk1/njsh6ofNaL2ZbHrx+oPFaSA5CahNjB6+D8+Kwi6IwheWm23D8R8wzOYLx1xqFyGwGyE3EvmQavrm+3r4y3gsZiB1bgo16xZHrPeh+/JKlm1LjmMYpvKXlZGMUQvIV8yjBlzjs0toLS23bjk8VTBAGCIAybrSAX8heGyu9BdIU46ZVde2akQIUA5IcAdvfEJ/oOHS+xzVe3x0+tNUZUiKR9CC4n2yllMYzm7kalVRLNAF87cQMb2Z9h6BJNLVrkk4/AnWB03rcfA5AFTQ6XNCQP2yKm8pCwp
 3DnXCz7q
 lyCHjpywuU88+QyV49jEufgnoMmhwPNAyuaD2VCXelu6Gn4ouD4QKlx2nuvJTrJwzOiFHpWcuiQaP3ughGqoX5eXhq/juoSN1xZNg/0URe4UiGe+r+Wc3bwr2UJk6vHM0KcsB+lFq2SL4w1lizmr8M70ch/rhKnNDsdow83RUMMtOnpCt/jAbEo/qblM6kWsB2H6EcNqN0fox597UoOMmVF4ojLQvmlG1iE660wWfrk7HFoerkFbH2Lzlki0bcsoCdAkMkj9LBz3Z3fpAJVJE1KMoawHE7+rk4drKspuV58gIxT5Aj/jAs8WGcalsJ+Cz3Nb1t/E8G1CY3qSrlSzF0tD840no9cbnIXOUI7VqjCNu29tR8s5bCE5iSAhGfN6x+fAfqU9DGQTdlxU=
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

I’m seeing inc_min_seq() become significantly faster:

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
mmap: 0x7c4b1d200000, size: 512 MB
memcg: 12893 (/system.slice/agetest.scope)
aging generation 3 -> 103
gen   3:    7.538 ms
gen   4:    0.937 ms
gen   5:    2.348 ms
gen   6:    2.300 ms
gen   7:    2.302 ms
gen   8:    2.294 ms
gen   9:    2.296 ms
...
gen 100:    2.292 ms
gen 101:    2.307 ms
gen 102:    2.293 ms
gen 103:    2.293 ms

Total:   235.718 ms
Average: 2.334 ms

The average aging time drops from 4.990 ms to 2.334 ms!

[1] https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/

Barry Song (Xiaomi) (6):
  mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
  mm/mglru: batch update lrugen->protected in inc_min_seq()
  mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
  mm/mglru: exclude folios promoted by aging from protected in
    inc_min_seq()
  mm/mglru: move folios from oldest gen to second-oldest gen from head
    to tail
  mm/mglru: batch move folios to the second-oldest gen's LRU

 mm/vmscan.c | 98 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 80 insertions(+), 18 deletions(-)

-- 
2.34.1


