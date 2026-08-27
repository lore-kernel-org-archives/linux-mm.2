Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF07C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 03:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE226B0088; Wed, 26 Aug 2026 23:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6196B008A; Wed, 26 Aug 2026 23:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCD166B0092; Wed, 26 Aug 2026 23:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A60E56B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:54:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC0131602BF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:54:39 +0000 (UTC)
X-FDA: 85145682678.04.06FDC51
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id E100F20002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 03:54:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EjHd4BOq;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787802877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtJ7o6rD0VXMWfP6Cs3HMb+Jy7E3yT0ARf18rJvEe+Q=;
	b=32tofjiaeqstAas+/tSsC9PvqbYm9HpN0GOtJTBPBQD/CJF6lD+h2Orl80cBg5mr0dxj9a
	kpVp4f8Vncozn6XXXs5+qRfZlYFK7sgOjdzCVwB2DnTezOArdFpUGfnJtXmJby3IfOjUzU
	RsKvBTo+lF5Ksq3D3mxhgB33roBU17A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787802877;
	b=poqrpqeps6U6UWXRjSKUkqKOVW6IlAhg04n1S3PLFKfrlPsm7QamvMtN0rukzfr8w9F8TB
	Jd0nEDK1aHA6kC7m0J90XYYx3gSd9mOebwk7gsMDnBtcJlSqNg+VXmHXLX4PegXGnhBGV3
	MWy2wJwei/yhgJqEImD5110arrqYUoA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EjHd4BOq;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-384422b05b5so257285a91.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787802877; x=1788407677; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rtJ7o6rD0VXMWfP6Cs3HMb+Jy7E3yT0ARf18rJvEe+Q=;
        b=EjHd4BOqpmvyco4ko0F8dbj2U/b+vUIgi1kQSv8/gR1PBgYn1127mvi9huGwxRsZ3m
         4+9PH4ISg/asFOC8/AcSDjDbUthMan1GxZdqsndWmWL+2C9v1tEFUst/UdmcuuTRwqJr
         A2UoIzoNJCEyWngx6sgXHcYELAqSg2CUQEBmAEjEyHEhvquHqr3LYy1yeDw8DLAThdmq
         OIxf+9OvPEDkSLktkh4shPWdTscYmJAAJ7ipanH7Y4hzP8V6TvZlyDQ+G/iC/x0zGRtD
         B/q7GR61zno4bHx0go+6eKNEo2/GIGKqBVZHT4YwDeBo1EKuR6BL6PNo4wzEXkW/BfB8
         RvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787802877; x=1788407677;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rtJ7o6rD0VXMWfP6Cs3HMb+Jy7E3yT0ARf18rJvEe+Q=;
        b=b/ukce4tqyr6SWbZcx0T3jO9sYSa7QVsDOYPlY9zYrjaGicQG7hpFGQmnscYQvy/0r
         n3a5uuAg2r5cpwXr/XqnBCIFXQD2J2NlklbQtDqDtrglRARsESxlCH5QwwFglCOgZRLs
         L1xUaIBp9sNfPbvRGNgVMQP7Kyxcg2y+sIsABQvXnXW4z+vMqLLti2dNaISgW0OXqfFg
         96U7IdLroJECRG2rlEDASuNhAVuEgHQ8vEkMCGla1tmCMsawoNuxtmVe75mY6AR1ivzB
         3zwBAxcQMVZSkWBYcd3lUkICdLwmdgKxgOaVdernjwPkSTC+fiuecCGXw3s4g+NmUGGH
         wRcQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrua7UfBnpL50VW2+1oITqX0tY6+FqXaXT0OnToCJPELn/OqnpYfMzLPPwP+s9Nw6/omLFG38iDLg==@kvack.org
X-Gm-Message-State: AFuF++kRAlmGGddvwVNi9CFO6bmsnRLBE+jpAXUv0LCpsfcUyJJJdq/g
	8ppHfneM7987tbQV0MufgituC/UAW0SVkY4OxD9zMuAdh/m+tE92iYzG
X-Gm-Gg: AR+sD11Vc3Te6YDE+sTydTzh1PtU52Hr5NeqwW2R1iSFvulK5XHzlwNQSGCOE/uCzTK
	NrCyn7NZb5Gg9wRyT1r+O8eK7Bq4C/wOzuGerlqiANVXpQb/3EV0imhgCQQn5qYLdemp50UsoEh
	OeByNFM5qnm2r5fczeLSvdnjDo8OMyt6ZJcC+3g/5NTGzUkl1vS2feOkbNgL1Q+FLzvOJwdpCKs
	V2mxkjeclPkk/j8YQ9h0I6AkbwTpksCu93ILYAccLVQmzCr2UngNe8LtSZ1HZvNUZgWZsPza9dq
	ItNeVjmpRiYp48moJR4H58EsrD3M2st51KW1vS+12KWSUFpce31fQJ46PlNSzs6tGHPbfj8oeCV
	fQV4ggmadKj4xnr3Z/hWWSPoB4OLWez9m8+cs+2p5PzlGFpC5COoB6WJtC4hd52BjewCHWZ/L5v
	PL6F5LJ7jit1JkZkNKH4lUkw2OEeTtcP3iCOsWds660AR/UGnqtsBrjpjKohoPCh1m9u4jN1riW
	O46ohaAA0TzI3ymCB6OwB8uzm6LLWOoPVaZkFdf4i0K0ImHEoxLbGQiS4PfB/DCXELA/FH84trh
	ZxAO1yE=
X-Received: by 2002:a17:90b:4e8b:b0:390:af7c:fe5e with SMTP id 98e67ed59e1d1-3966d412b5bmr12628706a91.2.1787802876736;
        Wed, 26 Aug 2026 20:54:36 -0700 (PDT)
Received: from hz-11197422 ([132.147.97.39])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd55a4sm927412a91.7.2026.08.26.20.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 20:54:36 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: baohua@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	axelrasmussen@google.com,
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
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 0/6] mm/mglru: speed up inc_min_seq() and fix cold/hot inversions
Date: Thu, 27 Aug 2026 11:54:04 +0800
Message-ID: <20260827035416.3012015-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dyr1wteaxbazb9xzw6rr9ibns3qq4yij
X-Rspamd-Queue-Id: E100F20002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787802877-166034
X-HE-Meta: U2FsdGVkX18aCdpfM+sXeFAJ48dSXUtSk5k5+0tRU4XLhmoZIflkybD5IecyvQeJD97UqLCM6UB87eYR7bdvXqXGTn5dW6XBuieFtFJEb+r4MiM74lIhfZQLTYUQNHXwJs0AjYtix+8mfKADrqeVPKGVJsaCR/IgKGKCET0XuUnJXjuHgH7kem7WDSNkRDHF91A5FnSxhF+wGt1ihYabkxPe457SkpZ/bMwe5ozzABaF7lqt3W/yfH1X7nK6LY8FtkgHcD6E6/CNCTLOpsbPq/iMGs5mbrFrEVhPQtKMYzB3PvBSOBG8AR87AzJamMjGeLDS8GS+vRLgHidas1QxSGfgA7iYh5QQxg6mKVf6uHWjsxBXcMkQsvTNWrJUNKE7LFJtvhCB5ER42u8hwAEqSXoGz6T23VLVRZtBF+BBrjzasu+QuACNsXGy4cai7F24V5a4YkKFD2hmJbwci7CnVrMc/kXUoHpmoKGM2TGtJAbCC8m/ggBOIy7ORQjMMEZ9aeDSo/5+ABGQVhu1fg7xMpa9pgqiM6GfC9hW0vEUOVK8SVF51Y7RDXuLBJ4q7EfEDI+mPA+lGMGYlLjyBguzEa293E06uK3nqFTnnNh1XpHVE6KqVFBIttrSXa9CE8h9e7NPX6GMTUVXNc3BLeInEFtUrlzxOBvRx03ikbE0oexGuPA4hwMLGJ9H44FIGXUrLPO9O4JPi06gblc8DvCOPwtPGtgMaCMepDCXhXN3vOfkRMFFDJztvNSe0FyhnISm+T2iUSHDW+1bMOmfcE75BLG28wsXRjVX4WxDa1kwgMUJACLgdGc4oKqoJRmFYMkjvsEvIIKq3kwQ5Hk5t04ktcXz9YVFNoA1/kS8vsbZNhiK+dbAwI+mP7aLghBr9yTtYwRU7X/ZNnuvlfhDzWNEN2E/jDqyd9d8AGGJesQVIbRre6ai7ydRloVy5nnTPk9O/iuH/rfOLFhMy26aIsH
 3F/0K3oR
 oGewfVGtcKlnV3Kpu1IUQCQB1JpBRZVod1g4ck+snVtPoGXEhtniK58MmzlqgnNOBhrscjlnggd+6xRXzCuvf+gFc3n+xwgF2nwcr7HuPJuuQYF5y7kp0PjbfdwUgWITmR3GImeb/E10xoNT+hVt+eU4SEvfq/w+VFXfGAYlG/IviGVgLegZOpUA4IfA+6MqsqtI3cUP9Zb2rUBFs59wpFfEYwhisOAzFRIW8xofNHPzrl9MgbLMTFLuXeTYMoTWNNrP02mch3pkpa2PclZEWmYR9NrqumE1t7DrGSF4PnT94AN/bwFmpR5TREz7k4wg7Mf3QKW4snwMEUK4+cX8FSmL4y2wrLkKwW+GXduF+qLboSr2vDb0ggIF2Nk5h0bBJwfI7eo20OnCzTn+Ea2dsG5OXWtqVUHRU3znENva8Nw8Dbflgd/7N0JZPcQ+7szQGFj0abgBqTzucpxfbHJ13Tf+4lVs7iKhpnPGKCN/32Ky0LfiZkLaObKQA/uKHrj6cvX8IhVqRxlPkZ1WUA+lKnfPI5bus7ZNEZF+vloJPxtn4qdmP4aeUJr2V5DAkPvbQjSRyVL2qr4PNHys/Bh/QgtR/yzmk26k8ntDx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Aug 21, 2026 at 06:25:32PM +0800, Barry Song (Xiaomi) wrote:
>This is an aging speedup series split out from the MGLRU swappiness
>series [1], with the inc_min_seq changes separated to make them
>easier to review.
>
>Currently, inc_min_seq performance is crucial to both the swappiness
>fix and proactive aging. There are two problems with it:
>
>1. It processes each folio one by one, while many operations can be
>batched or skipped. For example, a batch of folios can be moved together
>from the oldest generation to the second-oldest generation, and the
>associated counting can also be done in batches.
>
>2. It may cause potential cold/hot inversion by placing promoted folios
>(which have been scanned and found to have young PTEs) behind
>non-promoted folios. A similar inversion can also occur among
>non-promoted folios, as tail folios from the oldest generation are
>placed before head folios when moving them to the second-oldest
>generation.
>
>This series tries to batch operations as much as possible and fix the
>potential cold/hot inversion by keeping promoted folios ahead of
>non-promoted folios, while also preserving the order of non-promoted
>folios when moving them from the oldest generation to the second-oldest
>generation.
>
>Minor issue: inc_min_seq() also counts protected folios
>improperly, as promoted folios should be skipped, as in
>sort_folio().
>
>We need a stable workload with a stable number of folios to measure
>aging and evaluate the speedup in inc_min_seq(). So I asked ChatGPT
>to generate the microbenchmark below. It ages an LRU vec containing
>512 MB of memory 100 times:
>
> #define _GNU_SOURCE
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <stdint.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <errno.h>
> #include <time.h>
> #include <sys/mman.h>
> 
> #define SIZE		(512UL * 1024 * 1024)
> #define LRU_GEN		"/sys/kernel/debug/lru_gen"
> #define TARGET_CGROUP	"/system.slice/agetest.scope"
> #define START_GEN	3
> #define END_GEN	103
> 
> static long long nsec_diff(const struct timespec *start,
> 			   const struct timespec *end)
> {
> 	return (end->tv_sec - start->tv_sec) * 1000000000LL +
> 	       (end->tv_nsec - start->tv_nsec);
> }
> 
> static int find_memcg_id(void)
> {
> 	FILE *fp;
> 	char line[4096];
> 	int memcg_id;
> 
> 	fp = fopen(LRU_GEN, "r");
> 	if (!fp) {
> 		perror("fopen lru_gen");
> 		return -1;
> 	}
> 
> 	while (fgets(line, sizeof(line), fp)) {
> 		char *p;
> 
> 		if (strncmp(line, "memcg ", 6))
> 			continue;
> 
> 		p = line + 6;
> 
> 		if (sscanf(p, "%d", &memcg_id) != 1)
> 			continue;
> 
> 		/*
> 		 * The memcg path follows the numeric ID.
> 		 */
> 		p = strchr(p, ' ');
> 		if (!p)
> 			continue;
> 
> 		if (strstr(p, TARGET_CGROUP)) {
> 			fclose(fp);
> 			return memcg_id;
> 		}
> 	}
> 
> 	fclose(fp);
> 
> 	fprintf(stderr, "Cannot find %s\n", TARGET_CGROUP);
> 	return -1;
> }
> 
> int main(void)
> {
> 	void *addr;
> 	int memcg_id;
> 	int fd;
> 	long long total_ns = 0;
> 
> 	/*
> 	 * mmap 512 MB and touch every page.
> 	 */
> 	addr = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
> 		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	if (addr == MAP_FAILED) {
> 		perror("mmap");
> 		return 1;
> 	}
> 
> 	memset(addr, 0x55, SIZE);
> 
> 	printf("mmap: %p, size: %lu MB\n",
> 	       addr, SIZE / 1024 / 1024);
> 
> 	/*
> 	 * Find the memcg ID automatically.
> 	 */
> 	memcg_id = find_memcg_id();
> 	if (memcg_id < 0)
> 		return 1;
> 
> 	printf("memcg: %d (%s)\n", memcg_id, TARGET_CGROUP);
> 	printf("aging generation %d -> %d\n",
> 	       START_GEN, END_GEN);
> 
> 	fd = open(LRU_GEN, O_WRONLY);
> 	if (fd < 0) {
> 		perror("open lru_gen");
> 		return 1;
> 	}
> 
> 	for (int gen = START_GEN; gen <= END_GEN; gen++) {
> 		char buf[128];
> 		int len;
> 		struct timespec start, end;
> 		long long ns;
> 
> 		len = snprintf(buf, sizeof(buf),
> 			       "+ %d 0 %d\n", memcg_id, gen);
> 
> 		clock_gettime(CLOCK_MONOTONIC, &start);
> 
> 		if (write(fd, buf, len) != len) {
> 			perror("write lru_gen");
> 			close(fd);
> 			return 1;
> 		}
> 
> 		clock_gettime(CLOCK_MONOTONIC, &end);
> 
> 		ns = nsec_diff(&start, &end);
> 		total_ns += ns;
> 
> 		printf("gen %3d: %8.3f ms\n",
> 		       gen, ns / 1000000.0);
> 		fflush(stdout);
> 	}
> 
> 	close(fd);
> 
> 	printf("\nTotal:   %.3f ms\n",
> 	       total_ns / 1000000.0);
> 	printf("Average: %.3f ms\n",
> 	       total_ns / (double)(END_GEN - START_GEN + 1) /
> 	       1000000.0);
> 
> 	while (1)
> 		sleep(1);
> 
> 	return 0;
> }
>
>Run the above microbenchmark with:
>systemd-run --scope --unit=agetest -p MemoryMax=1024M ./agetest
>
>I’m seeing inc_min_seq() become significantly faster:
>
>W/o patch:
>
>Running scope as unit: agetest.scope
>mmap: 0x72c1b5a00000, size: 512 MB
>memcg: 12673 (/system.slice/agetest.scope)
>aging generation 3 -> 103
>gen   3:    7.433 ms
>gen   4:    0.949 ms
>gen   5:    2.535 ms
>gen   6:    5.043 ms
>gen   7:    5.041 ms
>gen   8:    5.027 ms
>...
>gen 100:    5.035 ms
>gen 101:    5.011 ms
>gen 102:    5.029 ms
>gen 103:    5.056 ms
>
>Total:   503.946 ms
>Average: 4.990 ms
>
>W/ patch:
>
>Running scope as unit: agetest.scope
>mmap: 0x7c4b1d200000, size: 512 MB
>memcg: 12893 (/system.slice/agetest.scope)
>aging generation 3 -> 103
>gen   3:    7.538 ms
>gen   4:    0.937 ms
>gen   5:    2.348 ms
>gen   6:    2.300 ms
>gen   7:    2.302 ms
>gen   8:    2.294 ms
>gen   9:    2.296 ms
>...
>gen 100:    2.292 ms
>gen 101:    2.307 ms
>gen 102:    2.293 ms
>gen 103:    2.293 ms
>
>Total:   235.718 ms
>Average: 2.334 ms
>
>The average aging time drops from 4.990 ms to 2.334 ms!

Hi Barry,

I tested this series on my arm64 machine (24 cores, 4K base pages)
and reproduced the improvement with the microbenchmark from the
cover letter.

THP=never (PTE):
  baseline: 7.644 ms
  patched:  2.964 ms (-61.2%)

THP=always (PMD):
  baseline: 0.0373 ms
  patched:  0.0292 ms (-21.8%)

The PTE-level gain is larger than your x86 numbers (-61.2% vs
-53.2%). I suspect the per-folio cost of inc_min_seq() is higher
on my arm64 machine (or on arm64 in general).

The gain is also larger at the PTE level than at the PMD level
(-61.2% vs -21.8%), matching the much higher folio count
(131072 vs 256).

Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

thanks,
Xueyuan

>[1] https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/
>
>Barry Song (Xiaomi) (6):
>  mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
>  mm/mglru: batch update lrugen->protected in inc_min_seq()
>  mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
>  mm/mglru: exclude folios promoted by aging from protected in
>    inc_min_seq()
>  mm/mglru: move folios from oldest gen to second-oldest gen from head
>    to tail
>  mm/mglru: batch move folios to the second-oldest gen's LRU
>
> mm/vmscan.c | 98 +++++++++++++++++++++++++++++++++++++++++++----------
> 1 file changed, 80 insertions(+), 18 deletions(-)
>
>-- 
>2.34.1
>
>


