Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE2DE93807
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF736B0088; Sun, 12 Apr 2026 18:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780B96B0089; Sun, 12 Apr 2026 18:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F5E6B0092; Sun, 12 Apr 2026 18:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52D456B0088
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:50:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 843B1BD5A0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:46 +0000 (UTC)
X-FDA: 84651400092.07.F99CB0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id EA728180004
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:50:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g3Di8L2k;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0Dnj9NKff0KtA3p2PFW0ElNUpFQLHa2s5fam2oT6x2U=;
	b=20vOQIOu9rOSBfKKSM+XlpsWaTGI7V+jrivi/6gwY8Oui7RKBLrS2upd0AtPyrsylAJzS6
	ClHmb/stweiVNHOKFqbzp4Z7WYIgzuMGc9WO5HzBEJw5QyFCzZQN/ifszzwsngfIohbLUi
	5PplUHIvOmlM16tqI7DtDPl+lRoXee4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034244; a=rsa-sha256;
	cv=none;
	b=j4p7aoRpn4ySuDZ/r6/1+3MX4W46qKSxzHcRXUWpySzt9cSzBdlTwGfQVU8mcqQSubu5rN
	mG5x0W+Mrxidz3HnLVZwNpdAPI7eKRyZnL+/KI1ZtuOKFljthzCsdDwYKLM27I42uKsmZI
	SM7TkmAjFsxxD6k5TZSa6CP03K1UbX8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=g3Di8L2k;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0Dnj9NKff0KtA3p2PFW0ElNUpFQLHa2s5fam2oT6x2U=;
	b=g3Di8L2kDu6i8uTnS4FfJOSUqxYWTiBvQVGVkv9zoczv7540mVNEEfhwljavrZjyzn+F93
	KEJjZ0NTw0dtMHUHaQwZL17wYYYKtrQadbivcLN/HC6W0vzDLZJsreyYvFeLrRtK+UcwhH
	nl5fkxBHuPCszAjwIEPX3cDHnsjPyj0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-X15EJfKSPReunYvTJ_RC9w-1; Sun, 12 Apr 2026 18:50:41 -0400
X-MC-Unique: X15EJfKSPReunYvTJ_RC9w-1
X-Mimecast-MFC-AGG-ID: X15EJfKSPReunYvTJ_RC9w_1776034240
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488c74405ecso22497945e9.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034240; x=1776639040;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Dnj9NKff0KtA3p2PFW0ElNUpFQLHa2s5fam2oT6x2U=;
        b=BkKxPCR9V1o4383KK3ap1NPVT0gYJHs9x9juhezGm9+8NDbU+Nv1OVcNNrfYWXB6+/
         bDTwf/brt4lzflJ8X/oWMhQinAJCx6/bfHaKyWS9Iee2vPNvo6DVRVgBespTpqXMNX9N
         /q7s1taMppTG3JLYFB8sCms03ZSnFscEYzuH/ZvmXREmL1t70z5owFRIlkAi11dzQJRS
         gdXwTRdACHJBIo9iwXc2kGuO/s6AAsU+G8oF2GeReC4pArMQzmYr1EzcesZs4JjmA6So
         xtIARzdXYEIsnohiySmVG5Qv4mpG+QDlv3H8CUZ1EfsGX/pAL1khrLT1RGxgGIHCeoco
         UZ2g==
X-Forwarded-Encrypted: i=1; AJvYcCX/lyEkhR5QBuyau7zcLtJBzoIA2QXZsd3pQqCE17ig2ub0IyF0egz40HZFRP+c8ivYZO6+w3ptNg==@kvack.org
X-Gm-Message-State: AOJu0Yy1wsBVsHTPw+YykyhP2JPT1a9QhJSh8Foh4qkP0ZQvaq1PjFk5
	lEPwnclVGna3+zk9zxZW7khL905tVUZsfqBKT9gWf6lZgC5Ns4yTCgUp+ZehR/+QxaeDEtJa8Rm
	xxhueti5S3VRQQNiwsC92CWQoz9F9WZawiDuDk3ctkv8Gi+qsILQG
X-Gm-Gg: AeBDiev7wgdaGIc9tk5Iv1NjIaDtLgfBpLQJJOPFLjODjc8HY5Cf/k8jJIdc9Q2A+Tb
	kt5pJAdnjAH3t26gCPfZuNSaauUOl+aWX0ufRDUvn20X+5B2E+xUSa30e8KYLNld7j9zrZvIPfr
	PgGGpySj9m1EUG/H/LF8GYtEZyyfdYGs9GKMDwKiFjHOphvHc/8posrwA/mAhTN3ANilzyuOWF5
	dykQd2CJaU1CzQ4ffwoGkhfjFh0r/9Zx+iu7GF/4WtGaBfKA+oF+Ar+3DMBV2IBEz2WPeTSlg9F
	0R+4xjgAnyGncsNhgXjT6dtatIsSpiInEXUEgw3IEPICutw9G+k2e12pJEMUp3MtN9rphM5Rd3E
	zrjN4EA9n4c6pgkwM21XozhHavzFXMwyOJoGVejAVX0k=
X-Received: by 2002:a05:600c:a408:b0:488:8b99:54a1 with SMTP id 5b1f17b1804b1-488d68865f6mr117254785e9.28.1776034240475;
        Sun, 12 Apr 2026 15:50:40 -0700 (PDT)
X-Received: by 2002:a05:600c:a408:b0:488:8b99:54a1 with SMTP id 5b1f17b1804b1-488d68865f6mr117254615e9.28.1776034239992;
        Sun, 12 Apr 2026 15:50:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67ced32sm109922655e9.7.2026.04.12.15.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:50:38 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:50:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: [PATCH RFC 0/9] mm/virtio: skip redundant zeroing of host-zeroed
 reported pages
Message-ID: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fZsk2KsyFWZJ8CfVK4bsz7YtQSq7PAM2Ltud0EoGWIg_1776034240
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: EA728180004
X-Stat-Signature: ccronio34dya8rpxuj9z7exxaw6cytxk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776034243-902087
X-HE-Meta: U2FsdGVkX1/ss/tsLxJloWYg3zpsP3yCKpgaFrRyWP4oC9hYgjMxbxl8mj7OJAjo7F9MrIJLlE8E7s0pXYQpoKz+k8k2pi8Fdw5LZN46CVjS1+Bbxs7VJjpo1Z3x/rXORzLjGSPffTMbYDuYU0DSwocbfdke1Mwn4iFs5YxY9dbWYGSH988+cUnJ+SVFW7a1nGagQSmJJArn/ZrdCHsGL9bKSRTY8sTEWL62R13bkBxt8fwiiFVvIuKzh74g637LzbrbHtlCZ/+s7kV93EcX+J5rT/rc2wLpm/DECqAgstOOrWCo9fjogH36phqD8PL+60/Fgjbb2Eat83B3FptBKo87x5RVZzcGdaDqc1FdwLeo5f2ruoLEPVdP28jUmAW1+Mo2E3TV7T2FJ0SVOjYmzooOjNtlieM/HI2MOmSKOiW+XeH0e8uhDNOSWR8RVCJ6bDEdtyeyuW/yQMMsh1Qx7uHZlygSBqV2UbOTUTxWMSd04RXRnGr52Bq+iLRaIH00J2xE5/KH7Nf7FynaMIRI0SwKUAE0beKODFNRTmQn6Jxwu+QU/gpdGQtIEFo98fTOcDwtIlPCkXhoSnMnSeMmtyJ9EbUDfMIaRt5MlihaQXsHmkP5yRPhU4LOFUJPgy2PcsALfTuOIAhgk+KUXO29GXsEKiEE++t8UzaS4hL68T+VlxzzEEaGqZOVYzYqcskghJ+AYp8Pb3hsksw8mgGxwnEv24yjjKFW0NPKHti2fNo8ND9IL6dOSehKNOsYcfts00gjNOgx6MUoI/ff0o+PIRK4WHq/ag5jpiX0qGSPSbADkUa9oUDpkAgdekxEBjDO6YKlIODhNjTriEzAWX8H/RZYFm+fMv3NHXeUENeck72WCGP/5qugY5htL+XghD7TlsxynUWEp95Teu44RZMVxC+BkpgCr2x/UTDxit0QXAacr4DLJnS/GhcC2Sz1E1r6ZQNm+yAPoW2CDcSE8WU
 Jq8sEAq2
 0QMMetg8h5ofTqHO0TCYogXTXs2n1xzEd/jJVxqbZMNJ9RUp7Y12AeTvgwVxqOTZ/37pFXjheJPXMpLHV+aEltGgqyCc4nlNmnXtzL//3BiAdECLqooVU8qWjoe4iUHGAIteHerxyyTE/socRQTizpJQNBwlCjdYhPBufNazBpYbSCSGkYSHCtUT0l26EtSg6gVQuKodqAI3zbT+AxCRpHYNEHTH12X6LKLTl47yjoiwampeFSWdZMJlU58ajutN0S9BBfxQyD5neWRLgVGLN1gYWkfeBJGJZN1Umtm988FTf8iE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a guest reports free pages to the hypervisor via virtio-balloon's
free page reporting, the host typically zeros those pages when reclaiming
their backing memory (e.g., via MADV_DONTNEED on anonymous mappings).
When the guest later reallocates those pages, the kernel zeros them
again -- redundantly.

This series eliminates that double-zeroing by propagating the "host
already zeroed this page" information through the buddy allocator and
into the page fault path.

Performance with THP enabled on a 2GB VM, 1 vCPU, allocating
256MB of anonymous pages:

  metric         baseline    optimized   delta
  task-clock     179ms       99ms        -45%
  cache-misses   1.22M       287K        -76%
  instructions   15.1M       13.9M       -8%

With hugetlb surplus pages:

  metric         baseline    optimized   delta
  task-clock     322ms       9.9ms       -97%
  cache-misses   659K        88K         -87%
  instructions   18.3M       10.6M       -42%

Notes:
- The virtio_balloon patch (9/9) is a testing hack with a module
  parameter.  A proper virtio feature flag is needed before merging.
- Patch 8/9 adds a sysfs flush trigger for deterministic testing
  (avoids waiting for the 2-second reporting delay).
- The optimization is most effective with THP, where entire 2MB
  pages are allocated directly from reported order-9+ buddy pages.
  Without THP, only ~21% of order-0 allocations come from reported
  pages due to low-order fragmentation.
- Persistent hugetlb pool pages are not covered: when freed by
  userspace they return to the hugetlb free pool, not the buddy
  allocator, so they are never reported to the host.  Surplus
  hugetlb pages are allocated from buddy and do benefit.

Test program:

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/mman.h>

  #ifndef MADV_POPULATE_WRITE
  #define MADV_POPULATE_WRITE 23
  #endif
  #ifndef MAP_HUGETLB
  #define MAP_HUGETLB 0x40000
  #endif

  int main(int argc, char **argv)
  {
      unsigned long size;
      int flags = MAP_PRIVATE | MAP_ANONYMOUS;
      void *p;
      int r;

      if (argc < 2) {
          fprintf(stderr, "usage: %s <size_mb> [huge]\n", argv[0]);
          return 1;
      }
      size = atol(argv[1]) * 1024UL * 1024;
      if (argc >= 3 && strcmp(argv[2], "huge") == 0)
          flags |= MAP_HUGETLB;
      p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
      if (p == MAP_FAILED) {
          perror("mmap");
          return 1;
      }
      r = madvise(p, size, MADV_POPULATE_WRITE);
      if (r) {
          perror("madvise");
          return 1;
      }
      munmap(p, size);
      return 0;
  }

Test script (bench.sh):

  #!/bin/bash
  # Usage: bench.sh <size_mb> <mode> <iterations> [huge]
  # mode 0 = baseline, mode 1 = skip zeroing
  SZ=${1:-256}; MODE=${2:-0}; ITER=${3:-10}; HUGE=${4:-}
  FLUSH=/sys/module/page_reporting/parameters/flush
  PERF_DATA=/tmp/perf-$MODE.data
  rmmod virtio_balloon 2>/dev/null
  insmod virtio_balloon.ko host_zeroes_pages=$MODE
  echo 1 > $FLUSH
  [ "$HUGE" = "huge" ] && echo $((SZ/2)) > /proc/sys/vm/nr_overcommit_hugepages
  rm -f $PERF_DATA
  echo "=== sz=${SZ}MB mode=$MODE iter=$ITER $HUGE ==="
  for i in $(seq 1 $ITER); do
      echo 3 > /proc/sys/vm/drop_caches
      echo 1 > $FLUSH
      perf stat record -e task-clock,instructions,cache-misses \
          -o $PERF_DATA --append -- ./alloc_once $SZ $HUGE
  done
  [ "$HUGE" = "huge" ] && echo 0 > /proc/sys/vm/nr_overcommit_hugepages
  rmmod virtio_balloon
  perf stat report -i $PERF_DATA

Compile and run:
  gcc -static -O2 -o alloc_once alloc_once.c
  bash bench.sh 256 0 10          # baseline (regular pages)
  bash bench.sh 256 1 10          # optimized (regular pages)
  bash bench.sh 256 0 10 huge     # baseline (hugetlb surplus)
  bash bench.sh 256 1 10 huge     # optimized (hugetlb surplus)

Written with assistance from claude. Everything manually read, patchset
split and commit logs edited manually.

Michael S. Tsirkin (9):
  mm: page_alloc: propagate PageReported flag across buddy splits
  mm: page_reporting: skip redundant zeroing of host-zeroed reported
    pages
  mm: add __GFP_PREZEROED flag and folio_test_clear_prezeroed()
  mm: skip zeroing in vma_alloc_zeroed_movable_folio for pre-zeroed
    pages
  mm: skip zeroing in alloc_anon_folio for pre-zeroed pages
  mm: skip zeroing in vma_alloc_anon_folio_pmd for pre-zeroed pages
  mm: hugetlb: skip zeroing of pre-zeroed hugetlb pages
  mm: page_reporting: add flush parameter to trigger immediate reporting
  virtio_balloon: a hack to enable host-zeroed page optimization

 drivers/virtio/virtio_balloon.c |  7 +++++
 fs/hugetlbfs/inode.c            |  3 ++-
 include/linux/gfp_types.h       |  5 ++++
 include/linux/highmem.h         |  6 +++--
 include/linux/hugetlb.h         |  2 +-
 include/linux/mm.h              | 22 ++++++++++++++++
 include/linux/page_reporting.h  |  3 +++
 mm/huge_memory.c                |  4 +--
 mm/hugetlb.c                    |  3 ++-
 mm/memory.c                     |  5 ++--
 mm/page_alloc.c                 | 46 ++++++++++++++++++++++++++++++---
 mm/page_reporting.c             | 34 ++++++++++++++++++++++++
 mm/page_reporting.h             |  2 ++
 13 files changed, 129 insertions(+), 13 deletions(-)

-- 
MST


