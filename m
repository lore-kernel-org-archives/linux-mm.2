Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31462C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3902A6B009D; Fri, 25 Sep 2026 02:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341146B009E; Fri, 25 Sep 2026 02:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F9A6B009F; Fri, 25 Sep 2026 02:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC4FC6B009D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:50:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DD3FA05A7
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:50:21 +0000 (UTC)
X-FDA: 85251360642.27.E7051DF
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5A271C0007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:50:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=Z4X9ZS2r;
	dmarc=pass (policy=reject) header.from=modal.com;
	spf=pass (imf28.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ayushr@modal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2MOlqC3CqQeIkJJQSE5ZBko91IuDQ76O2zDmJDbjzA=;
	b=qsS/PE4+Qvz9lok2GJWwOTihpFVVG368po+pT2ANX4pZ98eo2ocGP3+8pn9ppO9C33K/3/
	Sr/wLfcxrOBjV71iS8mHZaovQo7egd5xHKagTs3aAOV4hj2TPK8Hc3ja2WughddrQhuWaj
	Lr3Xc7jEnmf2bNq+apELMiS6+NrVyR4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=Z4X9ZS2r;
	dmarc=pass (policy=reject) header.from=modal.com;
	spf=pass (imf28.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ayushr@modal.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319019;
	b=2i8pyoZYge8+m0Qi8kyYr1w4Gy/CJXxu5mOlfqN1s/1iwQoCDq98oPBkE5Em/CD7lRVXUo
	Jn4FVd/qN0xIK1Op0Arh2eTMuvKZK7RujucKGH7KfLDu1nISOOwBgLYwaW6cM1D3K1CWpW
	kUAO2aiuOtcfCs/P6BeScB/tdcDmiQc=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398beb616f5so294615a91.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 23:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1790319018; x=1790923818; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o2MOlqC3CqQeIkJJQSE5ZBko91IuDQ76O2zDmJDbjzA=;
        b=Z4X9ZS2rRXXFbyk4lPAOwibsm9BwthTIMXR/gFWDvMfTwaT5vBDzc3XcK+wFU6JKb2
         Lz17ebIexVYkowyLe9w6M8F8CATW150mi4VQU6NsMp41HE5atMbHNXhPEvkS5XWmRmTf
         KQWjlDyjV9xnCUd/58Pov4VA10WDfJtV20a2cbhHzZzdqAFGnMcf3zWvgj6N1z+08f/l
         QOJQJu92NpIvcGc1CBLaM71MnXuBsWEYdcv1ek5xpuiXXqI6u7+MUbMpZZc/Q61m0/qS
         K4fzV20gRtdEaErXJwoyVYjZzy5TPjP20gn5lQfTAS16HuJF+TBEG9jROVOnmttKzIYO
         A28g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790319018; x=1790923818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o2MOlqC3CqQeIkJJQSE5ZBko91IuDQ76O2zDmJDbjzA=;
        b=Yl/HYcra6fNzvUy1BOqDUUS2wr2G6wGUCnaKqUs1ufthqi1fims6Ot5ag5oep1oE8+
         qmlpvuzeS+/cj348RLWMLpC9FTEU86s3aEGvRI0S7EGXLn3NzKdloFX36XNzKrOMCPSi
         Ip2GPnd4Z8aQdKHRPfGHghsLFr+cPZTWb15JaTS8yjFKBKhNqJnCgiM0HHxVBmeMczWb
         aI9hjSZt6bDd82lZaXY5MfItFLPOrdLAofnTJ2VvomI+6zb3WKUJxAaAqCveo84xNlcL
         OVm9fEmjFgZxNn3E1Qtat+gMI1Z8bIePahbvKta14cLeXXtB1WqcSuLVC+YW1dEbKRvI
         Fl+g==
X-Forwarded-Encrypted: i=1; AKwUvBxzIUY5UBA9Ezj33rkFQJgSFxZ0KyVzbO9yIU/T3hsagIRJjikwxVa6QCCJoL23BNAWOTolWf09Qg==@kvack.org
X-Gm-Message-State: AFuF++k5D8LmW+o/bP1MyDSj+3uXxcgtLzrTtSDcmBjUf7wYc1olIF7V
	7Xr8gqDuKm2+TLBi7nZJh6kbJcCiQRkJngLXJ2R5MFliJvjsDDn9++fCOj1gnA7dH8U=
X-Gm-Gg: AYBFou3NyijBQBWIQKC6KQuXD8nY+8U2ASHhjV++GkckUxs1J6i2mco2wYHDdjQ3hS9
	3lLrzHuoTmtmtc3r1PuzmVpZkKFloXceVhvAcG2E2BJ0B+r34qV5YxhZ2mUa+BW+TngRFw3Ps1d
	1w7sgyPVXBPTdcb32/zbdNnquIc3J38AHzrRhtw/3i643NJZuIkzRKL4V8prZ+UYYcgbpl0ynyc
	bGLxY/n6s8AXTJ7szWadm5Fqcm7GFyXDOa1vyvaIq/4gLvWYcJSkNLekoAZz6jzMs9AmdbuOhVO
	nj1ugT6HX2wSAA/d6KKj3lIS6lyoNXoG6r3Sl6C99973T4DaalgW0uVFDyAuAdhyxlULxqVpJmg
	ofL9fgjOuXAmB0lEGD7A5jLXK++LCm3Hjb/8aMasfKoZmoHAoBhj0YxS4ZImdmJdGoDy33k9DHG
	McUPY4BbcVl0khIZrfq73UFBiY8T5LgZmdo1NtYsVw4nnYrjZXcbWpOHeI6K5tpEPWxlpNQmOc3
	/5gyAC4Xh+ML0RwyWQEso0x7f9XXT0eJgYrB0+mOQcXUEnRPMLketpMWaNwfz+XD3nbnaKGJrgn
	JFLhQlruRlxO2bYdPvH6cdILyEBiBsF9cTMb0eUctu7DcSto
X-Received: by 2002:a17:90a:da8e:b0:3a0:34a4:187e with SMTP id 98e67ed59e1d1-3a09865216bmr2874283a91.15.1790319017911;
        Thu, 24 Sep 2026 23:50:17 -0700 (PDT)
Received: from devbox-ayushr-01ed.tail5292b.ts.net (ec2-44-242-192-44.us-west-2.compute.amazonaws.com. [44.242.192.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm2713563a91.0.2026.09.24.23.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:50:17 -0700 (PDT)
From: Ayush Ranjan <ayushr@modal.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Ayush Ranjan <ayushr@modal.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts page cache / rss counters
Date: Fri, 25 Sep 2026 06:50:10 +0000
Message-ID: <20260925065013.3682431-1-ayushr@modal.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260925053027.1998394-1-ayushr@modal.com>
References: <20260924061708.1645968-1-ayushr@modal.com> <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net> <20260925053027.1998394-1-ayushr@modal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7tf73y4asti4r5gpjkspij6r94ipc747
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A271C0007
X-HE-Tag: 1790319019-373228
X-HE-Meta: U2FsdGVkX1+QPJ7wk82RwYY/oR6qaSLCd2p7lWD+7cd/4FWrfHKlmMMj+yUc+QpHeTRcioak5NTkfnojJfrR5GaecqhGrURWPnZWXqYuOXnYEVLEqfaa2+UKoBio/ZlYZAgOwxI9fJ8VrLCpBGt2ka05eLxiv8xRWCRAwyK21GObh8IY7eyvIeJHrbEezh3iEpr1NYyO2Zsdf7mUX0csitLu2HDR9NCMtfXNt/a9RKNMBmHfkQ+Lu1lEEvQndeLdGf+tGEmHsCs6Jlt3IH1ebXKy1Uh2Oclh1qKSsaVLNxg9F5Qd+UrnmSXyDBEN14utlPmrigZYVyZxRTW/yV0Br/4Nb840DfJ+QDuD7Z8cGfq7UXAjbOwDq/yoHwPLdSzZIbU/sTwk9LvU44eASvJHse7VYr4q8DIvrLo+Ewus5+XTmnLCJQILOz/YHQFXbIJbplDRi0Ylo2h5ORtVbIAlSA9hHI2uGZyOkYqgEcrQfPtOCMJMFTKUtfZ/AZYAd1QppwWzhTRNqT5krQYlm4LmQfept/T6ELHpZa7Gt9T/RyVpDeOHhaoChpvC0nTkuMauMVjLuJmYQOs0cAatlCDpbw6r6+Zau1dnfkRQtf7RA1aU4XcwaJC+qPaN1sTLINMP6j/GhDmagGUj4uknIaPVKz56HHQ4mpAsfnT8ihOFetjCjdnldNvmvjkZXliQUk1r0yitOtCxwryzqJIISPMjR3McP0YBOmh0r0BNxo4i7043+KC/NrWD0Au9rHQygTQ0tuqEusFybGyqoMgbIb5ahWx5u7fCXy1Zr59eGuVm3n1jDIJy3p7BZJhgg/gL106ON8+AC8jw9wh7XKhmAsT/aU1vcwpLNhznhWxebJhKg3ma4IMwwElgGIJ30IuoUtkPwKnhaqP+xnKzJDyIrNCHrCvpT7QMw4NRIj6y+DoCvweZ7eUtSm9sKO/YfDIBEEsl6EQ+yuYuO2a6S/cB5F+
 f6Md8mDa
 CIXsgfouf4q0aCgva47QC/xp0jRSvAJ7K2LdqghXWkCz2ntolm2K1bVlZA1vDnJT+U569V0x49jmcRjEpAa6NLCuIHmKW8ihN6DTKn8p3BYn/SX9vhe/ns6PKFzmHVJpZ4AXwUxQYvTXDpHtj7GUr8f6kRlG8NU4Td+hoNOV5iJZnq+5w24da98QeTqR9oiz7h9SnwPTOlI5kRdzWFBfF+GMw3Zg8YQ6+Exd5NBr4XpRolfD3tLUiS5uX/qwIdUKSnHAvIcnCPdiSY+KnLZnvZZu43uOnLeXFg8kwRroKz31H4OijCZiXw6F+K1nnM/J9zzFncjHHdx0sTxdww9AV6QjmCEkpIRR+vRSqoox7dINqGw4vcwsQFnqz8bTjbwo1tkVwv7V6mwaTknvueS/sZcv7Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 05:30 +0000, I wrote:
> The standalone reproducer, however, has so far only triggered the
> rss-counter one, and only on the UEK8 kernel. Not on our 6.18.46
> hosts, and it has never triggered the "Bad page cache" one for me.
> So it clearly does not capture everything the production workload
> does.

Following up: a reworked reproducer (at the end of this mail) now
triggers the "Bad page cache ... still mapped when deleted" bug on
6.18.46 (plus 31c1d19ead2c "writeback: use a per-sb counter to drain
inode wb switches at umount"). The new reproducer typically works
within 2 minutes on a 128-CPU box. It also still produces the
rss-counter imbalance when the process exits.

Two changes over the previous version made the difference:

  1. Every punch now forces a partial-folio split: it punches
     [pmd_start, pmd_start + k * PAGE) with 1 <= k < 512 (PMD-aligned
     start, mid-PMD end), which sends the straddling huge folio
     through truncate_inode_partial_folio() and a folio split.

  2. Fault-around is steered at just-punched ranges: the punching
     thread publishes the PMD index it just punched into a small
     shared ring, and the faulting threads preferentially read across
     those PMDs, so filemap_map_pages() keeps re-installing PTEs over
     the range being torn down.

Two data points from this version:

  - fork() is not needed: a single-process variant (one memfd, one
    MAP_SHARED mapping, faulting threads plus one punching thread)
    trips it as well, so the dup_mmap() angle can be ruled out
    entirely.

  - it still strictly requires shmem_enabled=always plus aggressive
    khugepaged (scan_sleep_millisecs=1, pages_to_scan=4096,
    max_ptes_none=511); with default khugepaged settings it does not
    trip within 150s. The constant re-collapse of punched ranges back
    into PMD folios is essential.

Pedro: I think this is consistent with your folio-lock point. Both
mapping and truncation do hold the folio lock, but not across the
whole punch: on a partial punch, truncate_inode_partial_folio()
splits the straddling folio, and the sub-folios inside the hole are
only removed by shmem_undo_range()'s subsequent lookup pass. In
between, they sit unlocked in the page cache, where
filemap_map_pages() -- which, unlike shmem_fault(), knows nothing of
the shmem_falloc guard -- can lock and map them; the later removal
then finds them mapped.

Baolin: given the above, this version may be worth another try on
v7.3-rc1 with the khugepaged settings applied; I would expect the
same behaviour there but have only verified 6.18 so far.

Run recipe (same as before, plus alloc_sleep_millisecs):

  echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
  cd /sys/kernel/mm/transparent_hugepage/khugepaged
  echo 1    > scan_sleep_millisecs
  echo 1    > alloc_sleep_millisecs
  echo 4096 > pages_to_scan
  echo 511  > max_ptes_none

  cc -O2 -pthread -o repro shmem_punch_fault_race.c
  for i in $(seq $(( $(nproc) / 4 ))); do ./repro 120 & done
  # watch: dmesg -w

Thanks,
Ayush

---- shmem_punch_fault_race.c ----

// SPDX-License-Identifier: GPL-2.0
/*
 * Reproducer: shmem/tmpfs hole-punch vs fault-around race on huge
 * folios ("BUG: Bad page cache ... still mapped when deleted").
 *
 * One memfd, mapped MAP_SHARED. The punching thread punches
 * [pmd_start, pmd_start + k * PAGE), 1 <= k < 512, to force a split
 * of the straddling huge folio, and publishes the punched PMD index
 * to a shared ring; faulting threads read across recently punched
 * PMDs so fault-around re-populates them. Peer processes only
 * accelerate the race: a single process suffices.
 *
 * Usage: ./shmem_punch_fault_race [seconds] [file_MiB] [peer_procs]
 */
#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>
#include <linux/falloc.h>
#include <linux/memfd.h>

#define PAGE		4096UL
#define HPAGE		(2UL << 20)		/* PMD-order folio */
#define PMD_PAGES	(HPAGE / PAGE)		/* 512 */

/* Shared across all peer processes; steers faulters onto just-punched PMDs. */
struct ctl {
	_Atomic uint64_t hot[64];		/* recently punched PMD indices */
	_Atomic uint64_t seq;
	_Atomic long n_punch;
	volatile int stop;
};

static unsigned char *map;
static int fd;
static size_t file_sz, n_pmd;
static struct ctl *ctl;

static inline uint64_t xs(uint64_t *s)
{
	*s ^= *s << 13; *s ^= *s >> 7; *s ^= *s << 17; return *s;
}
static uint64_t seed(void)
{
	struct timespec t;
	clock_gettime(CLOCK_MONOTONIC, &t);
	return (t.tv_nsec ^ ((uint64_t)getpid() << 20) ^
		(uint64_t)pthread_self()) | 1;
}
static void push_hot(uint64_t pmd)
{
	uint64_t i = atomic_fetch_add(&ctl->seq, 1) & 63;
	atomic_store(&ctl->hot[i], pmd + 1);		/* 0 == empty */
}
static uint64_t pick_hot(uint64_t *s)
{
	uint64_t v = atomic_load(&ctl->hot[xs(s) & 63]);
	return v ? v - 1 : (xs(s) % n_pmd);
}

/* Read across a (recently punched) PMD so fault-around re-populates it, then
 * drop it to force the next touch to fault in again through map_pages. */
static void *faulter(void *a)
{
	uint64_t s = seed();
	while (!ctl->stop) {
		uint64_t p = pick_hot(&s);
		size_t base = p * HPAGE;
		volatile unsigned char sink = 0;
		for (size_t o = 0; o < HPAGE; o += PAGE)
			sink += map[base + o];
		(void)sink;
		if (xs(&s) & 1)
			madvise(map + base, HPAGE, MADV_DONTNEED);
	}
	return NULL;
}

/* Keep PMD folios present and dirty so the puncher always has one to split. */
static void *writer(void *a)
{
	uint64_t s = seed();
	while (!ctl->stop) {
		uint64_t p = xs(&s) % n_pmd;
		memset(map + p * HPAGE, 0x5a, HPAGE);
	}
	return NULL;
}

/* Punch [pmd_start, pmd_start + k*PAGE), 1 <= k < 512: forces a folio_split()
 * of the trailing partial PMD folio. Occasionally drop a whole PMD to keep the
 * allocator/khugepaged churning fresh huge folios. */
static void *puncher(void *a)
{
	uint64_t s = seed();
	while (!ctl->stop) {
		uint64_t p = xs(&s) % n_pmd;
		size_t off = p * HPAGE, len;
		if (xs(&s) % 4 == 0)
			len = HPAGE;
		else
			len = (1 + (xs(&s) % (PMD_PAGES - 1))) * PAGE;
		fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
			  (off_t)off, (off_t)len);
		push_hot(p);
		atomic_fetch_add(&ctl->n_punch, 1);
	}
	return NULL;
}

static void peer(int secs)
{
	pthread_t t[4];
	pthread_create(&t[0], NULL, faulter, NULL);
	pthread_create(&t[1], NULL, faulter, NULL);
	pthread_create(&t[2], NULL, faulter, NULL);
	pthread_create(&t[3], NULL, writer,  NULL);
	sleep(secs + 2);
	_exit(0);
}

int main(int argc, char **argv)
{
	int secs   = argc > 1 ? atoi(argv[1]) : 120;
	file_sz    = (argc > 2 ? (size_t)atol(argv[2]) : 256) << 20;
	int peers  = argc > 3 ? atoi(argv[3]) : 3;

	file_sz = (file_sz / HPAGE) * HPAGE;
	n_pmd = file_sz / HPAGE;

	ctl = mmap(NULL, sizeof(*ctl), PROT_READ | PROT_WRITE,
		   MAP_SHARED | MAP_ANONYMOUS, -1, 0);

	fd = memfd_create("runsc-memory", MFD_CLOEXEC);
	if (fd < 0) { perror("memfd_create"); return 1; }
	if (ftruncate(fd, file_sz)) { perror("ftruncate"); return 1; }
	map = mmap(NULL, file_sz, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED) { perror("mmap"); return 1; }
	madvise(map, file_sz, MADV_HUGEPAGE);
	memset(map, 1, file_sz);

	pid_t pid[64];
	if (peers > 64) peers = 64;
	for (int i = 0; i < peers; i++) {
		pid[i] = fork();
		if (pid[i] == 0) peer(secs);
	}

	pthread_t t[5];
	int n = 0;
	pthread_create(&t[n++], NULL, faulter, NULL);
	pthread_create(&t[n++], NULL, faulter, NULL);
	pthread_create(&t[n++], NULL, faulter, NULL);
	pthread_create(&t[n++], NULL, writer,  NULL);
	pthread_create(&t[n++], NULL, puncher, NULL);

	sleep(secs);
	ctl->stop = 1;
	for (int i = 0; i < n; i++) pthread_join(t[i], NULL);
	for (int i = 0; i < peers; i++) { kill(pid[i], SIGKILL); waitpid(pid[i], NULL, 0); }
	while (waitpid(-1, NULL, WNOHANG) > 0) {}

	fprintf(stderr, "pid %d: punches=%ld\n", getpid(),
		atomic_load(&ctl->n_punch));
	return 0;
}

