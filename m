Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF1F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=oqkQmMI8
Received: by kanga.kvack.org (Postfix)
	id B09F46B00EF; Sun,  1 Nov 2026 22:33:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAC66B05B1; Sun,  1 Nov 2026 22:33:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D49F6B05C4; Sun,  1 Nov 2026 22:33:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75EC96B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:33:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE8011C4553
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:33:06 +0000 (UTC)
X-FDA: 85388757972.04.9DF3B38
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id D23F5100005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:33:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oqkQmMI8;
	spf=pass (imf05.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590384;
	b=eKkUmZANn087WkInL0a7KgfwRmUVdgyS3wN65sXOFUUWH/1+c2RLiR4oS4VttS8iiN1Btz
	1xlf/nfvX1y9HOCCFfT/Pl1w0pPKZm1osy8jwBbkF4Eo4YnvdEzCPDSp7A3gnX7N+Wl5jH
	WEJfYZlvQpckf2k5HEQyL9OdvrlzwpA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oqkQmMI8;
	spf=pass (imf05.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ay4NLRs2GpQhGyzo5kK5KQlCHuDrT2x/l3rjriX74B4=;
	b=tiUa9ktWYa+PcdVeOxH5O4DqJE3/zoE4jlHhBCUDAkSaE497LweALHS92VQvvnmejxBZBV
	+z+2UITuWaCjbyxnsCyxxSmlrC67nV953s5jqV44+kKn0Fi0lEPOLq2gdUsuuHS2ZEq+9X
	ieK3L985Xru/9NqNPcGUuPHGdG9BbMI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793590377; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ay4NLRs2GpQhGyzo5kK5KQlCHuDrT2x/l3rjriX74B4=;
 b=oqkQmMI8jETNMpaI1ju7VaV7JoGJuH/qouKu/SHnW5BBVYneKHHzKf0WfHeQzBOfb+LvW0
 tXrr0kOX1Z8nd919k6ejP5CgbTsmYWQt7IoIutkyJchbdmGsM24y4XBJ/D/cZ7gfi30I5P
 N6csXPBo0BRIgXXgjBk8WD93wuapQrb8++94qKlf/ASGJA/UE9yttApWGcCpgV+C6dUm/5
 k2SDd6h9AArDv/i7DYQWurEBe/WOs8+xH4Qkesgkn6fCB1SFAsOhbbpk3nwDp7NiDr8YHG
 sg1RSXhKbgDtnQHYaXNgW4w1FZ8k1XRO+SZZuKsXV+GJ4IIlIuI02XPMe0g17w==
X-Lms-Return-Path: <lba+26ae80467+1f39ce+kvack.org+zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	<akpm@linux-foundation.org>
Cc: <xu.xin@linux.dev>, <chengming.zhou@linux.dev>, <aarcange@redhat.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>, <riel@surriel.com>, 
	<ljs@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Message-Id: <9f09eebd-a8bb-4622-a307-1ba9e7478f26@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] mm/ksm: avoid anon_vma UAF during page merging
Date: Mon, 2 Nov 2026 11:32:38 +0800
User-Agent: Mozilla Thunderbird
References: <20261031182256.40205-1-zhaogongyi@bytedance.com> <79820b33-7e74-4e12-926f-1e03987d7bda@kernel.org>
In-Reply-To: <79820b33-7e74-4e12-926f-1e03987d7bda@kernel.org>
X-Stat-Signature: 3ehr3rxgxko7j1y8zkjm88kmbop1jxbk
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D23F5100005
X-Rspam-User: 
X-HE-Tag: 1793590383-407916
X-HE-Meta: U2FsdGVkX1+TLX4Fi4ZYEBvTos2xTa7Hz+FIX/gKopJnG2sOFdz1VrlQXLZdVUw8zjZdL2W6Zi+PJ3kEXahAojEA15zUDFgtWd+iqRdgeo8Czm19AQ6yQ8BRD66dR+0vi0bNCaWOCJ3fOS8lfB9rthqseSdaw9XCgVSdqPD4XbSFrqkJNI6kdd+xthcQNAh29wqnCvXBZLPZMqklFPEmq5Y2fQpxo++y2poHgO0nMKc7+SLp10nSKAFUUod/htvGwDDCMAvSwVKuq4wselnI43OUIxE8PK5ftw0xkUq96GbwIWcaaHq7rCTQzW42gkyhf8Cqlu7iUDha4KrgLJDwfzlHSFVaG/67Sq3RxUz8ROb0mQjqqq7K7zCGFQ/YMrgYKT0sP64jBMCRXrWuRzEqJEXseFQU0KG094yKruf5qDnNNrDo5EmOOqZ4qGbfICSbD5lkWQPAcYGILa9MgzkY8gjc0h//nkn+0r8f+pQBzXSt+QNB9YbTR6131aZmoe3Ip6Ar4V1HR2wDSy6jcSbVnCgeehSQ1BRml4e9bVyEnGcgupLjwYLwYyDE2Ao0GlnapKiTiMuCnXns8AZxlz6VlUFxnIhebCoGn/SSrQb9yF6lFpU0XvIGN5usVoclDuIkcM9Zuu2mZNOMoOta9joB6kztqMAM/UmgJUiNNnaJopxZZTJDQitXmOWf1QCnT0YI/Y7ytVNtnGts70umP/zrkl/szTO+6no8wgwb17HDiqoMXY23CLgILYcJT5DWqgH6uOuFjKOja3s1/fp1gSpuTnU74w6uS2DjG4lLyo4Doz3zjpzNHz9Sx56lV+zafl9MF43xihWDhcK29x1eHdYhDEKlnqr0kmkIxlxYeJsclfB1nCkTQLlTyYpAVLRYmfgjoYuTDid6nizAHD46MK/7HS/qmo68K5TTCccNkmABfrCbawCcTV2Fx5bC+RNJ+w5mdSK9sV6WUpT3HKw9xTa
 X4rjCdap
 9Xeaz5yjCzWcRUd9GE6AYe3aiiAg5TAQLmBa3LSw6r28gc/gqTw8QromNUZVBKmL1+fOSzpBvRmfzNNJwNC5HWLGWtf6vjju6TPY2VIFM5xlfg9hdWDmYLz4ab9YmZ/6klZH2euLzBmfK0KxtC/nT/o3/UaNe/1VNLyIe7evTIHHIRDp99hpAS1YFPrG+vLF94mnOmdL8djcSSVhSA6TU3ebJO0+OF7MuHMrlkrrnzBv73rGhUC8LTs/iuINADp63qzpwcTiffVtMDZGEUFl3ux11i4a2KVqISrwtZ6K3wgOqBsovj8gIiViOPeXpJ8UQwe5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

I don't have a public link for this report, but the KASAN splat is 
below, followed by the standalone reproducer I used.

The reproducer needs CONFIG_KSM and writes the KSM sysfs knobs, so I ran 
it as root in a throwaway KASAN VM. One invocation I used was:

	./ksm_mremap_dontunmap_repro 4 2048 1 100000 64

It keeps mergeable anonymous pages at stable addresses while repeatedly 
using mremap(MREMAP_FIXED | MREMAP_DONTUNMAP) over the destination VMAs, 
so ksmd can race with removal of the last anon mapping.

KASAN report:

==================================================================
BUG: KASAN: slab-use-after-free in page_address_in_vma+0x104/0x32c
Read of size 8 at addr ffff0000d0c24c80 by task ksmd/34

Call trace:
  show_stack+0x2c/0x3c (C)
  dump_stack_lvl+0x94/0xc0
  print_report+0x174/0x71c
  kasan_report+0xc8/0x124
  __asan_report_load8_noabort+0x20/0x2c
  page_address_in_vma+0x104/0x32c
  try_to_merge_one_page+0x304/0x14b0
  try_to_merge_with_ksm_page+0x138/0x2e0
  ksm_scan_thread+0x2f70/0x4ae8
  kthread+0x310/0x400
  ret_from_fork+0x10/0x20

Allocated by task 465110:
  kasan_save_track+0x40/0x78
  kasan_save_alloc_info+0x44/0x54
  __kasan_slab_alloc+0x58/0x70
  kmem_cache_alloc_noprof+0x144/0x39c
  __anon_vma_prepare+0xd8/0x370
  handle_mm_fault+0x3a74/0x43cc
  __get_user_pages+0x1228/0x1d50
  __mm_populate+0x284/0x388
  __arm64_sys_mlockall+0x2fc/0x378
  invoke_syscall+0x8c/0x1f8
  el0_svc_common+0xe8/0x23c
  do_el0_svc+0x48/0x58
  el0_svc+0x3c/0x98
  el0t_64_sync_handler+0x84/0x12c
  el0t_64_sync+0x198/0x19c

Freed by task 461050:
  kasan_save_track+0x40/0x78
  kasan_save_free_info+0x58/0x70
  __kasan_slab_free+0x5c/0x8c
  slab_free_after_rcu_debug+0xa8/0x1d8
  rcu_core+0x6bc/0xd8c
  rcu_core_si+0x10/0x1c
  handle_softirqs+0x1d4/0x55c
  __do_softirq+0x14/0x20

Last potentially related work creation:
  kasan_save_stack+0x40/0x6c
  kasan_record_aux_stack+0x90/0xa4
  kmem_cache_free+0x2f4/0x3b0
  __put_anon_vma+0xcc/0x1f8
  unlink_anon_vmas+0x350/0x444
  free_pgtables+0x254/0x5c0
  unmap_region+0x1e8/0x23c
  vms_complete_munmap_vmas+0x300/0x7e8
  do_vmi_align_munmap+0x2b8/0x360
  do_vmi_munmap+0x190/0x1dc
  do_munmap+0x7c/0xb0
  mremap_to+0x210/0x5dc
  __arm64_sys_mremap+0x850/0xc70
  invoke_syscall+0x8c/0x1f8
  el0_svc_common+0xe8/0x23c
  do_el0_svc+0x48/0x58
  el0_svc+0x3c/0x98
  el0t_64_sync_handler+0x84/0x12c
  el0t_64_sync+0x198/0x19c


C reproducer:

// SPDX-License-Identifier: GPL-2.0
// Fixed-address KSM + MREMAP_DONTUNMAP stressor for page_address_in_vma().
#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef MADV_MERGEABLE
#define MADV_MERGEABLE 12
#endif
#ifndef MREMAP_MAYMOVE
#define MREMAP_MAYMOVE 1
#endif
#ifndef MREMAP_FIXED
#define MREMAP_FIXED 2
#endif
#ifndef MREMAP_DONTUNMAP
#define MREMAP_DONTUNMAP 4
#endif

static size_t page_size;
static volatile sig_atomic_t stop;

static void on_signal(int sig)
{
	(void)sig;
	stop = 1;
}

static void write_file(const char *path, const char *val)
{
	int fd = open(path, O_WRONLY | O_CLOEXEC);

	if (fd < 0) {
		fprintf(stderr, "warn: open %s: %s\n", path, strerror(errno));
		return;
	}
	if (write(fd, val, strlen(val)) < 0)
		fprintf(stderr, "warn: write %s: %s\n", path, strerror(errno));
	close(fd);
}

static void tune_ksm(void)
{
	write_file("/sys/kernel/mm/ksm/run", "1\n");
	write_file("/sys/kernel/mm/ksm/pages_to_scan", "200000\n");
	write_file("/sys/kernel/mm/ksm/sleep_millisecs", "0\n");
}

static void fill_pattern(char *p, size_t len)
{
	size_t off;

	for (off = 0; off < len; off += page_size) {
		memset(p + off, 0x5a, page_size);
		memcpy(p + off, "ksm-fixed-pool", 14);
	}
}

static void *new_mergeable_area(size_t len)
{
	void *p;

	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (p == MAP_FAILED)
		return MAP_FAILED;
	if (madvise(p, len, MADV_MERGEABLE) < 0) {
		fprintf(stderr, "madvise(MADV_MERGEABLE): %s\n", strerror(errno));
		munmap(p, len);
		return MAP_FAILED;
	}
	fill_pattern(p, len);
	return p;
}

static void worker_loop(int id, int slots, int pages, int expose_us, int 
seed_mb)
{
	size_t len = (size_t)pages * page_size;
	void **src = calloc((size_t)slots, sizeof(*src));
	void **dst = calloc((size_t)slots, sizeof(*dst));
	void *seed = NULL;
	unsigned long iter = 0;
	int i;

	if (!src || !dst)
		_exit(1);

	if (seed_mb > 0) {
		seed = new_mergeable_area((size_t)seed_mb << 20);
		fprintf(stderr, "worker%d seed=%p seed_mb=%d\n", id, seed, seed_mb);
	}

	for (i = 0; i < slots; i++) {
		src[i] = new_mergeable_area(len);
		dst[i] = new_mergeable_area(len);
		if (src[i] == MAP_FAILED || dst[i] == MAP_FAILED) {
			fprintf(stderr, "worker%d initial mmap failed at slot %d\n", id, i);
			_exit(1);
		}
	}

	while (!stop) {
		/*
		 * Let ksmd observe stable virtual addresses and cache rmap_items.
		 * It may return holding a folio ref after dropping mmap_lock while
		 * this process proceeds to replace the destination mapping below.
		 */
		if (expose_us > 0)
			usleep(expose_us);

		for (i = 0; i < slots && !stop; i++) {
			void *ret;

			ret = (void *)syscall(SYS_mremap, src[i], len, len,
					      MREMAP_MAYMOVE | MREMAP_FIXED |
						      MREMAP_DONTUNMAP,
					      dst[i]);
			if (ret == MAP_FAILED) {
				if (errno == EINVAL)
					fprintf(stderr, "mremap DONTUNMAP EINVAL\n");
				continue;
			}

			/*
			 * Source VMA remains in place after DONTUNMAP, but its PTEs
			 * were zapped. Fault it back in so the next cycle can again
			 * replace the same destination address.
			 */
			fill_pattern(src[i], len);
			(void)madvise(src[i], len, MADV_MERGEABLE);
			(void)madvise(dst[i], len, MADV_MERGEABLE);
		}

		if (id == 0 && (++iter & 0x3f) == 0)
			fprintf(stderr, "iter=%lu slots=%d pages=%d expose_us=%d\n",
				iter, slots, pages, expose_us);
		else
			iter++;
	}

	(void)seed;
}

int main(int argc, char **argv)
{
	int workers = argc > 1 ? atoi(argv[1]) : 4;
	int slots = argc > 2 ? atoi(argv[2]) : 2048;
	int pages = argc > 3 ? atoi(argv[3]) : 1;
	int expose_us = argc > 4 ? atoi(argv[4]) : 100000;
	int seed_mb = argc > 5 ? atoi(argv[5]) : 64;
	int i;

	page_size = (size_t)sysconf(_SC_PAGESIZE);
	if (workers <= 0)
		workers = 1;
	if (slots <= 0)
		slots = 1;
	if (pages <= 0)
		pages = 1;

	signal(SIGINT, on_signal);
	signal(SIGTERM, on_signal);
	tune_ksm();

	fprintf(stderr, "workers=%d slots=%d pages=%d expose_us=%d seed_mb=%d\n",
		workers, slots, pages, expose_us, seed_mb);

	for (i = 0; i < workers; i++) {
		pid_t pid = fork();

		if (pid == 0)
			worker_loop(i, slots, pages, expose_us, seed_mb);
		if (pid < 0) {
			perror("fork");
			stop = 1;
			break;
		}
	}

	while (!stop)
		sleep(1);

	kill(0, SIGTERM);
	while (wait(NULL) > 0)
		;
	return 0;
}

Thanks,
Gongyi

