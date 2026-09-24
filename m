Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D285C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721236B008A; Thu, 24 Sep 2026 02:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F91A6B008C; Thu, 24 Sep 2026 02:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1F86B0092; Thu, 24 Sep 2026 02:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2297F6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:18:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FA70A02AE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:18:52 +0000 (UTC)
X-FDA: 85247652504.14.003A823
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id B1B2D4000D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:18:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=LAdZCHxz;
	spf=pass (imf11.hostedemail.com: domain of ayushr@modal.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790230730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B5AtUb4a1oAHMSq5rmzd2HgfG+8wDisV0MJ3d9oqwKk=;
	b=2+28pnvD+oOeDUwfsu/LTQ3wzL27s/mpGm0VJLJ3Bo8Yt7lJ8KrEP2XdW+Ukj51hbtiCAD
	Sl3UROYzfuWtnozZ5H20Dk8Qzp7oKDDQhB0DLyxokH5ZzbJoUVjM5rpnSfv3zR9E2n4I/p
	/U1jC35i9vN0f0QF04D7rAylgpa/BH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790230730;
	b=G/LGgmvLkMaTVvC10pb8E8VRT5q9VsL8uTQRAgBEjdnJl6M5LtTNTBgAEu8yLacvD7W+t6
	dhvMLnGxJEcRls8eBdyMb+wRRXKNR87w5R42RSgYBnrxkl32mwyYqCqJK+Sk5sFP3KwgZF
	HAEwJNZQsD3bphm0D7kG4Pmhw1RNWDY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=LAdZCHxz;
	spf=pass (imf11.hostedemail.com: domain of ayushr@modal.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469e25400so868445b3a.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1790230729; x=1790835529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B5AtUb4a1oAHMSq5rmzd2HgfG+8wDisV0MJ3d9oqwKk=;
        b=LAdZCHxzMUJcDDH3ChE/SV+4OS67XEScgkZm524mXFbiLn/t6spiNF/7vQZqiT+IvY
         Ky0/2cQyir35dcyD5z2IYOwN0JH01eMwwwjqJEWlUj3DmXr4lg8JQU91lPJIjH0I1i52
         ZEYmvVWA+jdbVHZWenOcAYJfA5OYRMu5m6CUybgkX7xOpRFi9E0qXY+grc1JWDbWKFAH
         Ph3h9Bn9h4xFLhAkuQfecXGLevelTPBObAO4vmFj3ubp34CJ6W40q1heuTU883iIzfXf
         6cF4dnhzb9MV9i7twO8t8jU9P/1vOH1nF/Tl3eZVq7llDFLnGOp1TvWI+KS52X0fUlQi
         GNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790230729; x=1790835529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B5AtUb4a1oAHMSq5rmzd2HgfG+8wDisV0MJ3d9oqwKk=;
        b=mJW9VzP2AWIjhQ/QJ+5zPkdelSgP8zLm1dGQ+n73/Yu/qzF+fNMs1YTIu1/uBde6/h
         8BWP/X4gk02221tig3ykyk52/nlDY1q/10OEBkoNv3zP6AH88rW6fd9iO4sUtGyIFzeF
         tDCjJ8wVgMxt/aMP7JsWTauzl++9DjKQFfRCslKpLlGh54xa+MKsY8SmcyUXZwz2PJd8
         UMJNHlaQYS0DHWdrUKSu35IZ8Iyw2I7w1VXVdyQUHXJK2FLEMC4LT5Yz9LcGN7+O7m2q
         Q5BdZ4UA/XJ9/piKd8LKPTg0RKoKkvLAaT/uQwOGRsXyjtgwSHv5P94qOlKQlbOQXdMe
         OGZw==
X-Forwarded-Encrypted: i=1; AKwUvBzBehhd7OvzSf0XD6CxOoam3wrgSRH7XxUUXmt6T/AtMVlDuqkWmjQy8oe5TxI9k9XD/Ha5IRlF8Q==@kvack.org
X-Gm-Message-State: AFuF++mMUNsqplzeGF9vuqYNBlebeD3tUueflXrnN5zWs2jCPhLmw3Cb
	nMue5GhlbgTDIM7fGZ/vR34PwNWecBhPzyKAQunlTp3u+E5hHDuS9+3Mvz5q010dpnE=
X-Gm-Gg: AYBFou1hh71VlXotCevN6lVjIb3CtgNmyWjxwCnbkuIx7yNUWWYP8uaQUe5hxR+LhS0
	LuGAzCBiCm8gu72oaHx83e9xdQk0eoX6n2WQ5Auck0yevCSPeiYKReN7w7K2futC+SUgirlrA+W
	C91OYiwFtCqmD+Ze1nFeCMi+VQ5VtE0tgpAgiMgOq0g4CrBEKki6ipawYD9se8Sx1HSPkyjThUC
	Fiabeshc0tFT9Z8dPlGo/pOCzJysr2O8AJywXQkKD5/LoTSV5rJTNE1eUmp2o6xp0EJcr9iZobO
	BL7jlGSRtWcFjEnp1JKvDIHJ7OdD38KVlH2rVemkNbBhAPEpmnQtunBsv2mphFR8tgcIgubxPzz
	GsYARCFb4hz4U80EK+tl3zWEoSdaceYJwhALAQpA0Orhds4CWOsw5Ta0E4QN8kUxtJlnlkRdsZi
	omiwTS/JugYHf8CVFj5e9net0KIYAMAqyf+nCw3+eGM7qqUReXnyScCk0j33/INovnr632fM7WU
	nRc9666r6aSmMp7cItRfwTI2wkBC9gHZ6zGBp99txR8GqIvBtvTTg5w/VkuTy4KxADag2IWHN8f
	FWkyG1c+hJSAV9WmKigErB+i6Flbe+Vhz1LYNA==
X-Received: by 2002:a05:6a00:1da5:b0:85f:ae00:9e68 with SMTP id d2e1a72fcca58-87e99e414c3mr1186530b3a.26.1790230729239;
        Wed, 23 Sep 2026 23:18:49 -0700 (PDT)
Received: from devbox-ayushr-01ed.tail5292b.ts.net (ec2-44-242-192-44.us-west-2.compute.amazonaws.com. [44.242.192.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1dff9778sm2333101b3a.49.2026.09.23.23.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:18:48 -0700 (PDT)
From: Ayush Ranjan <ayushr@modal.com>
To: Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
Cc: Ayush Ranjan <ayushr@modal.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Pedro Falcato <pedro.falcato@gmail.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts page cache / rss counters
Date: Thu, 24 Sep 2026 06:16:21 +0000
Message-ID: <20260924061708.1645968-1-ayushr@modal.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1B2D4000D
X-Stat-Signature: gzcwx859ttppe7xb66kfzuquzmiuyowu
X-Rspam-User: 
X-HE-Tag: 1790230730-760055
X-HE-Meta: U2FsdGVkX18QI+lrr/+lPCkW5NhlZ9vtWqbSPb2D1YXNDf8ATb4t2cdwVvj0DNt2mHZxttylHINjXoy9ouN7cHTyuAbxLvJNOg6IOHGNjnItsEi9anUL4BmgbKfhB1oI2Umhjx+CHYM+pLwXINmIb1MyMCU/iFTp3JJwpaR8CvlVs2kCxh2DyIfAP/xoEoh6sfIqLunGoBwAATLmuc0feA+Zysj9YtcU1hcGT0MsPLkUT9+dfLSGslD8x6z39nEo07UKfJwWv0yWvGcPxdnUQZmLtnK1HODrPS/ZrSlfLqEXTLcrvLjnhOHZ6QVRTAiLOuZm4KAAjfJjr/UPuFOW8dh1FX/pdC0DJcx6jScFF/JpFWdwLGbgb7pormMP630TFOkTrbeo2eM5jQnphb6Vj2EcgU0Rn9FcHni/CEZw9sIVN+jbmnSO30bWIkTiO0VbLZHxQFzjQstQwUZU4/JDKbp1HoYptAo/rGtOug+M/NruXHY7ynJwO6gdxjqppWGyrqdkIbg6ugwUdmrNqpObb0ugDZLqyW7R3Gi12ldoHBm3okdwLyK7MSYJJWQZzBb/9HVTixdShL4AkKt1HyvKBmNavtyid4B+4iXqj0tuJanLWLaebWnnbtpa4osWnVVbArKQyY5XoJPIhDEA+uGO4rDFl8XkeXGKg9AjzOCGSdQC8yDz6/I4PlAlYT7cXywaBbCUpfAaTqSoXMNSE5Qa5DZixkaCD6VDwwWFXlkCVInGHpBlVfnzFsy2AWWhr3o7w+EHmeRGm7d7s+4s0wDgA1fTTW6LdjFOrFP+uEn1AECu3ar2vIU6802ysG6TPN958xqiSvl3YNQnFRa+RPjVd6/DoJlM1rHxoJyySvMgMGL/L5Ih/57TAGvfGLMv1cU5CF1I+T23eosVCz8Xa3nsxiJSVi89CBBpbXJ/qDtpZaio2um65znIdtQwffEcalQKvsh1v7Q8oNeCUHSGljP
 baCMhOrN
 fovziZhocnYI7LoItBCiky1wa99YZNSlN3HAmwoPxPAR2fbzxM5xYcC5zENSUkrL9ESs/zWSMue2oQHHCTrZJ/j/P3sn2V3gNd+zIx3zUQfgeMYSCMDov2FTy/EAu6ZjFIznle8K+xDRt8zBW1XoU6ywFrkhPJikp1+TOLWkfp+K8VQ+bpFabRbBzFtq00h2UsgIGqL7H/cS8fEODHsA6BjxgvRk87WPetZva9UI6yOwyOEMdxe9TwyVbQU+eUWMM2FcdTAaQaaSl2M20G6dcCgMSbuukB440n1lcTjeBpgWWoGd8XbI6eQrGhvXySIBoOJ5DrB2M7hX3NljImuLySdDYyamP0Nmxd3cgfbqox1gOOkDefLoejCCtgkmdjgJerFxZA1nqUgpOhB43TnivWnOYXuHLOixCcp0TddLTpZx7S6Xor/smNEs2OzpeHKl38f0Amcw8O78Urb50tAEIMBJeLG1vyE78c1y4L6hYZR1bTDPNEU2KH3NxcM0F+XPGjtYmHRuuT6FufxDTbTKRMkA3rk9Y9SYCQuVbJEOZ4XVPEBKWE/FAnNgM9cgItuztpA9l0JhWEHzt3ZzqBBxggH8tdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

We are seeing shmem/tmpfs page cache corruption on production hosts
running a workload that punches holes in a memfd (hole-punch based
memory reclaim) while other threads and forked children fault the
same MAP_SHARED mapping. The kernel taints but does not oops:

  BUG: Bad page cache in process ...  pfn:...
  page dumped because: still mapped when deleted
  ...
  dentry name(?): "memfd:..."

and, more frequently, a paired rss-counter imbalance when the mm is
torn down, always exactly one PMD-order folio (512 pages):

  BUG: Bad rss-counter state mm:... type:MM_FILEPAGES  val:-512
  BUG: Bad rss-counter state mm:... type:MM_SHMEMPAGES val:512

Seen on 6.12 and 6.18, x86_64, bare metal and VM, with
/sys/kernel/mm/transparent_hugepage/shmem_enabled = always.

This looks like the same corruption Gregory reported in March, which
as far as I can tell stalled without a fix; that report needed ~100
ballooning VMs to reproduce:

  https://patchew.org/linux/20260326162611.693539-1-gourry@gourry.net/

The reproducer at the end of this mail trips it with a single memfd,
no VMs or ballooning, within a few minutes on a large machine, so
hopefully it makes the race easier to confirm (and to test a fix
against).

Here is my best understanding of the race -- corrections welcome:

shmem guards faults against an in-progress hole punch with
inode->i_private: shmem_fault() -> shmem_falloc_wait() waits while
shmem_fallocate(PUNCH_HOLE) holds i_private. But shmem's .map_pages
is the generic filemap_map_pages() (shmem_vm_ops /
shmem_anon_vm_ops), which does not consult i_private and does not
take invalidate_lock, and shmem does not use invalidate_lock to
serialize faults against truncation the way regular filesystems do --
the i_private + waitq scheme stands in for it, but only shmem_fault()
participates in that scheme.

So while shmem_fallocate(PUNCH_HOLE) is between
unmap_mapping_range() and shmem_truncate_range(), a concurrent
fault-around can (re-)install PTEs for folios that are about to be
truncated:

  - filemap_map_pages() samples mm_counter_file(folio) once per batch
    and applies it with add_mm_counter() after mapping; if the
    folio's swapbacked state changes while it is concurrently torn
    down, the map-time counter (MM_FILEPAGES) and the zap-time
    counter (MM_SHMEMPAGES) disagree by exactly one folio -- the
    +/-512 imbalance above.

  - a folio re-mapped in this window (by fault-around directly, or
    via a child VMA whose PTEs copy_page_range() installs after
    unmap_mapping_range() has already walked the i_mmap tree -- the
    dup_mmap() variant discussed in the earlier thread) can be
    deleted from the page cache while still mapped -> "still mapped
    when deleted".

Reproducer
----------

The race is on PMD-order folios, so khugepaged needs to scan
aggressively (with the default 10s scan interval the punched ranges
are not re-collapsed fast enough to reproduce quickly):

  echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
  cd /sys/kernel/mm/transparent_hugepage/khugepaged
  echo 1    > scan_sleep_millisecs
  echo 4096 > pages_to_scan
  echo 511  > max_ptes_none

  cc -O2 -pthread -o repro repro_shmem_punch_race.c
  for i in $(seq $(( $(nproc) / 3 ))); do ./repro 60 & done; wait
  # watch: dmesg -w

On a 112-CPU host this trips within ~2-5 minutes; this capture is
from 6.12.0-204.92.4.4.3.el9uek.x86_64:

  BUG: Bad rss-counter state mm:0000000078314ee0 type:MM_FILEPAGES  val:-512
  BUG: Bad rss-counter state mm:0000000078314ee0 type:MM_SHMEMPAGES val:512

The rss-counter form is the most frequent. The "still mapped when
deleted" form is what we mostly see in production but is rarer under
the reproducer (as in the earlier thread); I do not have a fresh
capture of it to paste here and will follow up with a full splat if I
catch one.

For background: we originally hit this under a memfd-backed sandbox
runtime (gVisor), which reclaims memory by punching holes in a
MAP_SHARED memfd while it is being faulted -- hence the "memfd:..."
dentry in the splats. The reproducer below has no such dependency: it
only uses memfd_create + mmap(MAP_SHARED) + fallocate(PUNCH_HOLE) +
madvise, so this appears to be a plain shmem issue rather than
anything specific to our setup.

Thanks,
Ayush

---- repro_shmem_punch_race.c ----

/*
 * Race FALLOC_FL_PUNCH_HOLE against fault-around on a MAP_SHARED
 * memfd mapping.
 *
 * One memfd is mapped MAP_SHARED into the main process and several
 * forked peer processes. All of them fault (and MADV_DONTNEED,
 * forcing re-fault via fault-around) random windows of the file while
 * the main process punches holes at random offsets. Short-lived
 * fork() children exercise the dup_mmap()/copy_page_range() variant.
 *
 * Usage: ./repro [seconds] [file_MiB] [peers]
 */

#define _GNU_SOURCE
#include <errno.h>
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

#define PAGE 4096UL
#define HPAGE (2UL << 20)        /* PMD-order folio */

static unsigned char *map;
static int fd;
static size_t file_sz;
static volatile int stop;
static _Atomic long n_punch;

static inline uint64_t xorshift(uint64_t *s) {
	*s ^= *s << 13; *s ^= *s >> 7; *s ^= *s << 17; return *s;
}
static uint64_t seed(void) {
	struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t);
	return (t.tv_nsec ^ ((uint64_t)getpid() << 20) ^ (uint64_t)pthread_self()) | 1;
}

/* Read a random ~128 KiB span (spanning several fault-around batches), then drop
 * it so the next touch faults again through filemap_map_pages(). */
static void *faulter(void *arg) {
	uint64_t s = seed();
	size_t span = 32 * PAGE;
	while (!stop) {
		size_t off = (xorshift(&s) % ((file_sz - span) / PAGE)) * PAGE;
		volatile unsigned char sink = 0;
		for (size_t o = 0; o < span; o += PAGE)
			sink += map[off + o];
		if (xorshift(&s) & 1)
			madvise(map + off, span, MADV_DONTNEED);
	}
	return NULL;
}

/* Keep folios present for the puncher to race against. */
static void *writer(void *arg) {
	uint64_t s = seed();
	size_t span = 64 * PAGE;
	while (!stop) {
		size_t off = (xorshift(&s) % ((file_sz - span) / PAGE)) * PAGE;
		memset(map + off, 0x5a, span);
	}
	return NULL;
}

/* Punch holes at random offsets, mixing PMD-aligned and unaligned/sub-PMD
 * ranges. */
static void *puncher(void *arg) {
	uint64_t s = seed();
	while (!stop) {
		size_t len, off;
		if (xorshift(&s) & 1) {                    /* unaligned, 4K..2M */
			len = ((xorshift(&s) % 512) + 1) * PAGE;
			off = (xorshift(&s) % ((file_sz - len) / PAGE)) * PAGE;
		} else {                                   /* PMD-aligned, 2M/4M */
			len = ((xorshift(&s) % 2) + 1) * HPAGE;
			off = (xorshift(&s) % ((file_sz - len) / HPAGE)) * HPAGE;
		}
		fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
			  (off_t)off, (off_t)len);
		atomic_fetch_add(&n_punch, 1);
	}
	return NULL;
}

/* dup_mmap()/copy_page_range() variant; bounded to one child per thread. */
static void *forker(void *arg) {
	uint64_t s = seed();
	size_t pages = file_sz / PAGE;
	while (!stop) {
		pid_t p = fork();
		if (p == 0) {
			volatile unsigned char sink = 0;
			for (int i = 0; i < 16; i++)
				sink += map[(xorshift(&s) % pages) * PAGE];
			_exit(0);
		}
		if (p > 0) waitpid(p, NULL, 0);
		else usleep(200);
	}
	return NULL;
}

/* A peer process: maps the same memfd and faults/forks it concurrently. */
static void peer(int secs) {
	pthread_t th[4];
	pthread_create(&th[0], NULL, faulter, NULL);
	pthread_create(&th[1], NULL, faulter, NULL);
	pthread_create(&th[2], NULL, writer,  NULL);
	pthread_create(&th[3], NULL, forker,  NULL);
	sleep(secs + 2);
	_exit(0);
}

int main(int argc, char **argv) {
	int secs  = argc > 1 ? atoi(argv[1]) : 60;
	file_sz   = (argc > 2 ? (size_t)atol(argv[2]) : 64) << 20;
	int peers = argc > 3 ? atoi(argv[3]) : 2;

	fd = memfd_create("repro", MFD_CLOEXEC);
	if (fd < 0) { perror("memfd_create"); return 1; }
	if (ftruncate(fd, file_sz)) { perror("ftruncate"); return 1; }
	map = mmap(NULL, file_sz, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED) { perror("mmap"); return 1; }
	madvise(map, file_sz, MADV_HUGEPAGE);   /* request PMD-order folios */
	memset(map, 1, file_sz);

	pid_t pid[64];
	if (peers > 64) peers = 64;
	for (int i = 0; i < peers; i++) {
		pid[i] = fork();
		if (pid[i] == 0) peer(secs);    /* child shares the memfd + mapping */
	}

	enum { NFAULT = 3, NFORK = 1 };
	pthread_t th[NFAULT + NFORK + 2];
	int n = 0;
	for (int i = 0; i < NFAULT; i++) pthread_create(&th[n++], NULL, faulter, NULL);
	for (int i = 0; i < NFORK;  i++) pthread_create(&th[n++], NULL, forker,  NULL);
	pthread_create(&th[n++], NULL, writer,  NULL);
	pthread_create(&th[n++], NULL, puncher, NULL);

	sleep(secs);
	stop = 1;
	for (int i = 0; i < n; i++) pthread_join(th[i], NULL);
	for (int i = 0; i < peers; i++) { kill(pid[i], SIGKILL); waitpid(pid[i], NULL, 0); }
	while (waitpid(-1, NULL, WNOHANG) > 0) {}

	fprintf(stderr, "pid %d: punches=%ld\n", getpid(), atomic_load(&n_punch));
	munmap(map, file_sz);
	close(fd);
	return 0;
}

