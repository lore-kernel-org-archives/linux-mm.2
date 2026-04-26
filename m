Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4968FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223346B008C; Sun, 26 Apr 2026 17:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAB56B0092; Sun, 26 Apr 2026 17:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110FA6B0095; Sun, 26 Apr 2026 17:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF4676B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:47:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86120A05F5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:32 +0000 (UTC)
X-FDA: 84702043944.09.3D03B00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58818180009
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:47:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=StHQZoiu;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wUTZ8d2+nmZUz2JmwBmw760Ox8zWMl/D7BdSudbMLqQ=;
	b=8cGi7kt770/lUMFzEKHWOqk1EqGS4C4XM28gaY5YDZhT5sMCOqe8HUm+Zx3Hq07b6KD5OX
	sA3ET/lKsQrsuM3AQQmFjhP8UCIJUPDNknWH6ZKLQsNM6I8qQdoSZSVhOPKc5WKwOz/na8
	k5IdnmBpKZSE6Z8uNFoCZbTZB0lmOZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240050; a=rsa-sha256;
	cv=none;
	b=zvHezmuC+BsDiwsJREK/M1ewoI1H16vt4PlmVgyPQRNkrc9j96TtrRalxTq7o2AF5F/t2z
	HBGZARcwFoBIAR6Hn0EBVoOA06IO3+x9L0BhqsZkalS6yN2k0fP6mSYCOMEvSW1c8nRGp6
	69El5KLYDx/ydqgzX8AniLqUBSzIw/Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=StHQZoiu;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wUTZ8d2+nmZUz2JmwBmw760Ox8zWMl/D7BdSudbMLqQ=;
	b=StHQZoiuR0T2s0ngny6MZtE5g6iFKOQHklekLxV56AIMTyCr78/Tl7sGP3Dc/26iHjDfD0
	N67VcMjRRz7KKZS+ovY8aX1BuaG6x4htUizIuikpsbAnoFQxaat0qvK6K1en3ueM+OVip1
	lYp5onWkxdvQdZ5/FQArBz30/v6EPzM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-upGDmLaaOtm6NKS7I8yjjg-1; Sun, 26 Apr 2026 17:47:26 -0400
X-MC-Unique: upGDmLaaOtm6NKS7I8yjjg-1
X-Mimecast-MFC-AGG-ID: upGDmLaaOtm6NKS7I8yjjg_1777240045
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso15562f8f.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240045; x=1777844845;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wUTZ8d2+nmZUz2JmwBmw760Ox8zWMl/D7BdSudbMLqQ=;
        b=OlOs7ung1P87n1uX65Hxpvv13vdpvt6guDbSAzXZdJSKpV3Yqp5Ed0mV9wn4OHRO96
         QBxWy3S1Zrvk6V95PcDhc2cOFg8iOdq/tSxNVPK6zmyDHS1QFgWfTWWhGgtzYWsLDwV4
         dRjlmA0hIBTp9onkD37Kp9iZh68XPeSn0nrWj5LS+7jHLIgfP+hiv9Ha2NyV9dUFNINr
         lCQJr9uki6Yj/0XAg9tscSjWoPjetBfK9h76/sw9WxhyyaPFuJst65Y9MvlMwbCkul3Q
         VY8mRP28NERT085SFybsWGCz1+1e9ej+L5d7O0B05Yo8GmQLLqgyraw/gYE4Me5ELjP7
         BYmw==
X-Forwarded-Encrypted: i=1; AFNElJ/zQ6dOy1gbwaI7fvzjb4K9ZHtcYPcUwNIfI24Fk2kFQIEoW8s3RNqRgOZkpeObprxiFBYRcy5qeA==@kvack.org
X-Gm-Message-State: AOJu0YzrGHP32M/H+4yj2k//HccHyx0Tl7hKSobJ7Tvr1uBb5gS7/C2N
	tPMYxJlyV/jVmHN2x7iN85EPlYpNmNm1K2g8aIvaVlhBkX4MObqWTKrGjcnFMnBTMyYi3grbsf1
	umisrn+IHJYMdIgw+eN5rwYRoRJ1Xm1gJC48OBafPBvu63B6YUXhb
X-Gm-Gg: AeBDieu4SKpHb0CE4kJYZuRG7Az6Qnyed/7QqzPo1698bMxYfg7nN6viKNcoTWZRdjL
	gHcPNGv1gX3hRpslHSnmJARKdd0OKt2GREKR27eZ3op3Kavu60cAvfsqmwUKaa3aHyH6UAoSxKT
	sbiu16nQTb0Q0GgBrYKL27iSxLjIBi0DZnQoCIhEW4X40DrfZ560BgHE6jloUoaYi2gbU8t8UCE
	LMgvTUiDPZOLlIPLeVt251EYZxPnOY0VeEWYv+PFZF7VNsZ99GXF941OJQA+fri1kKQOT68PH3n
	91/Jb6jTXtaGK2WuhtlLx3aCEbQrn8pskiTZuB2wJR8cVAXXxw/V2MvEYTBa2XMaiChd8DAgyLb
	nkLcLWDIaG2don6fB9/UufEeGG9r094OsSXpifySRPBfuPso1X+/kvIMQ
X-Received: by 2002:a05:600c:4714:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48a55743d05mr350679355e9.27.1777240044762;
        Sun, 26 Apr 2026 14:47:24 -0700 (PDT)
X-Received: by 2002:a05:600c:4714:b0:48a:5574:3a5b with SMTP id 5b1f17b1804b1-48a55743d05mr350678985e9.27.1777240044114;
        Sun, 26 Apr 2026 14:47:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f8193sm678381545e9.1.2026.04.26.14.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:47:23 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: [PATCH RFC v4 00/22] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1rtQzqcpf1ZrCdkY9Vgmmmb23NyppvjpkwTQ3HcTIaE_1777240045
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 58818180009
X-Rspam-User: 
X-Stat-Signature: r48u4bgnd9ok4jxrriis1o7h59au6frn
X-HE-Tag: 1777240050-576341
X-HE-Meta: U2FsdGVkX1/zdi7kcTbs/89K0WnIqPMkcPR+EQxxcHEBGug2xnotYpDNue9np10v47eFLwxP2MpCTF927YHtGPkbQkqT8dQFCplYzegdg/PHP5H5o81QYrHeOzxmB3scJJQrNMnPkLqfZ8ehHkO5gsLyU96YhpM/6Qt6oFzatY+TV3lKsho2qLWOMnx6AaZL/5vtvPoQiz1pLw08lg+Z9REyYpGLb/Xxep0+vKotX6qcaCzitASJSBOB40/CY/P9pf9m9uMcv+AucGGQLafxoa2aLf32h6aeo1WC9qIGqn6Vnl7fZExNR4CszW7NoJMl04dLW+3Tv7r2X4QimR29eIJSsahRC7wJ3omvh7h699nQD+K1rMwn2m9liN0nG2H3F9ZISENS7KcZFhwiEauLZ89eZt+k7SYY1WTufbF66brs0eNwfdjHnTUfAThnX8nxNv616pjXg2YnDbY4Gtk4sVm2q8t8ukiS6SRxOkJcgwRlyNR+J5i1AwaT+6erEeXMRBazJlmf2m+HQ8Kh5kHA1t4h1kkF/uRi/HGwG7WsbbfNIDqrFAgoHvr8I0qQ3BZdkoHunCDIkqkdZjdbHjrfBqM0kXmH9o3mlWxrw4JqAh1GPZh59shQPtPxqRv7efomERxR1FqCXNnfFvRU/pvPT4pepMsEEcCmCRwb6TuIQCet9t8k0DuiA9f047HBK7OC1mHzlgmk5fUZX8lSyDcX3tELd7o6x/f4xqu47nlpNCTbsX0vP4Pk9gxxmI9FSspjGJzBwdQ7xYuOuEB2A7V3I3To1dYF2sUI4QTCWpqTGKdDE7gkaeXceKfetx+ILW1Qr52vLybTSRteC5rKY+pD+sval2mHPhrdBesc2luLzDp0TExBJvz2RMgFPKhmwMWVRWGFUaefMjLSXF0Ipx3CQs/7QpmD13apjs49z+YErFjOIWOd3+dXspCYDCufGXYLoKfauDR39a32menUrtR
 6LwTUl6u
 AcO3yRAGbk8WSkqlTNjEdmAGNi4b66xVxfTFnjnnLmiRYE0vVo5g5nPaGEQ69JldmyZdwKvPtAYZfbFmYOnwXIpD1UFKdU4zPh4KHz2K2U9VTxGXnqPTWQYrI/FECkVZAoChvojS/U6p3cV8CEHn3ejL3GHdnmx03FJzrcufBKSWj6Isx2/7rz380lBCcm6M6hYKAw+BcwwQAxae+p0xhHCxvlY2v9lNQo9qu1L9H0hRhMzH+jB0qzSX0Yo5kX6+h158T4pgsC5LqOpFd3MO5fokxXrbSBE0mohcPrdvGohA6LccceL8X6Ehk4PHhBYbHDjYZ5TXsuX2zCD8xKXrV+X6GmixosmQ/bi8H
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
again, redundantly.

Further, on architectures with aliasing caches, upstream with init_on_alloc
double-zeros user pages: once via kernel_init_pages() in
post_alloc_hook, and again via clear_user_highpage() at the
callsite (because user_alloc_needs_zeroing() returns true).
This series eliminates that double-zeroing by moving the zeroing
into the post_alloc_hook + propagating the "host
already zeroed this page" information through the buddy allocator.

For the reporting part, I am working on virtio spec now, so sending this
out for early feedback. In particular:
- is the mm zeroing rework acceptable?
- is sysfs testing hook for flushing acceptable?
- first 12 patches, including the fix for init_on_alloc double zeroing
  are independently mergeable mm rework -
  are they deemed a desirable rework, and should I post them
  separately for inclusion?

Thanks in advance.

Still an RFC as virtio bits need work, but I would very much like
to get a general agreement on mm bits first, so we don't add
a spec for something we can't then use.

-------

Performance with THP enabled on a 2GB VM, 1 vCPU, allocating
256MB of anonymous pages:

  metric         baseline            optimized           delta
  task-clock     175 +- 10 ms        40 +- 9 ms          -77%
  cache-misses   924K +- 323K        287K +- 93K         -69%
  instructions   15.3M +- 634K       13.5M +- 337K       -12%

With hugetlb surplus pages:

  metric         baseline            optimized           delta
  task-clock     169 +- 9 ms         49 +- 19 ms         -71%
  cache-misses   1.24M +- 222K       316K +- 114K        -75%
  instructions   17.3M +- 1.23M      15.0M +- 604K       -13%

Notes:
- The virtio_balloon module parameter (18/22) is a testing hack.
  A proper virtio feature flag is needed before merging.
- Patch 19/22 adds a sysfs flush trigger for deterministic testing
  (avoids waiting for the 2-second reporting delay).
- When host_zeroes_pages is set, callers skip folio_zero_user() for
  pages known to be zeroed by the host. This is safe on all
  architectures because the hypervisor invalidates guest cache lines
  when reclaiming page backing (MADV_DONTNEED).

Two flags track known-zero pages:
  PG_zeroed (aliased to PG_private) marks buddy allocator pages that
  are known to contain all zeros -- either because the host zeroed
  them during page reporting, or because they were freed via the
  balloon deflate path.  It lives on free-list pages and is consumed
  by post_alloc_hook() on allocation.
  HPG_zeroed (stored in hugetlb folio->private bits) serves the same
  purpose for hugetlb pool pages, which are kept in a pool and may
  be zeroed long after buddy allocation, so PG_zeroed (consumed at
  allocation time) cannot track their state.

- PG_zeroed is aliased to PG_private. It is excluded from
  PAGE_FLAGS_CHECK_AT_PREP because it must survive on free-list pages
  until post_alloc_hook() consumes and clears it. Is this acceptable,
  or should a different bit be used?

- On architectures with aliasing caches, upstream with init_on_alloc
  double-zeros user pages: once via kernel_init_pages() in
  post_alloc_hook, and again via clear_user_highpage() at the
  callsite (because user_alloc_needs_zeroing() returns true).
  Our patches eliminate this by zeroing once via folio_zero_user()
  in post_alloc_hook.  Not yet performance-tested on aliasing
  hardware.

PG_zeroed lifecycle:

  Sets PG_zeroed:
  - page_reporting_drain: on reported pages when host zeroes them
  - __free_pages_ok / __free_frozen_pages: when FPI_ZEROED is set
    (balloon deflate path)
  - buddy merge: on merged page if both buddies were zeroed
  - expand(): propagate to split-off buddy sub-pages

  Clears PG_zeroed:
  - buddy merge: clear both pages before merge, then conditionally
    re-set on merged head if both were zeroed
  - post_alloc_hook: clear on head page after consuming the hint

HPG_zeroed lifecycle (hugetlb pool pages, stored in folio->private):

  Sets HPG_zeroed:
  - alloc_surplus_hugetlb_folio: after buddy allocation with
    __GFP_ZERO, mark pool page as known-zero

  Clears HPG_zeroed:
  - free_huge_folio: page was mapped to userspace, no longer
    known-zero when it returns to the pool
  - alloc_hugetlb_folio / alloc_hugetlb_folio_reserve: clear
    after reporting to caller via bool *zeroed output (consumed)

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
  PERF_DATA=/tmp/perf-$MODE.csv
  rmmod virtio_balloon 2>/dev/null
  insmod virtio_balloon.ko host_zeroes_pages=$MODE
  echo 512 > $FLUSH
  [ "$HUGE" = "huge" ] && echo $((SZ/2)) > /proc/sys/vm/nr_overcommit_hugepages
  rm -f $PERF_DATA
  echo "=== sz=${SZ}MB mode=$MODE iter=$ITER $HUGE ==="
  for i in $(seq 1 $ITER); do
      echo 3 > /proc/sys/vm/drop_caches
      echo 512 > $FLUSH
      perf stat -e task-clock,instructions,cache-misses \
          -x, -o $PERF_DATA --append -- ./alloc_once $SZ $HUGE
  done
  [ "$HUGE" = "huge" ] && echo 0 > /proc/sys/vm/nr_overcommit_hugepages
  rmmod virtio_balloon
  awk -F, '/^#/||/^$/{next}{v=$1+0;e=$3;gsub(/ /,"",e);s[e]+=v;ss[e]+=v*v;n[e]++}
  END{for(e in s){a=s[e]/n[e];d=sqrt(ss[e]/n[e]-a*a);printf "  %-16s %10.0f +- %8.0f (n=%d)\n",e,a,d,n[e]}}' $PERF_DATA

Compile and run:
  gcc -static -O2 -o alloc_once alloc_once.c
  bash bench.sh 256 0 10          # baseline (regular pages)
  bash bench.sh 256 1 10          # optimized (regular pages)
  bash bench.sh 256 0 10 huge     # baseline (hugetlb surplus)
  bash bench.sh 256 1 10 huge     # optimized (hugetlb surplus)

Changes since v3 (address review by Gregory Price and David Hildenbrand):
- Keep user_addr threading internal: public APIs (__alloc_pages,
  __folio_alloc, folio_alloc_mpol) are unchanged.  Only internal
  functions (__alloc_frozen_pages_noprof, __alloc_pages_mpol) carry
  user_addr.  This eliminates all API churn for external callers.
- Add vma_alloc_folio_user_addr() (2/22) to separate NUMA policy
  address from the zeroing hint address.  Fixes NUMA interleave
  index corruption when passing unaligned fault address for
  higher-order allocations.
- Add per-page zeroed_bitmap to page_reporting_dev_info (17/22).
  The driver's report() callback manages the bitmap.  Drain
  checks it gated by the host_zeroes_pages static key.  This
  matches the proposed virtio balloon extension at
  https://lore.kernel.org/all/cover.1776874126.git.mst@redhat.com/
- Clear PG_zeroed in __isolate_free_page() to prevent the aliased
  PG_private flag from leaking to compaction/alloc_contig paths.
- Do not exclude PG_zeroed from PAGE_FLAGS_CHECK_AT_PREP macro.
  Instead, __free_pages_prepare() clears it (preventing filesystem
  PG_private leaking as false PG_zeroed), and FPI_ZEROED sets it
  after prepare.  Only buddy merge assertion is relaxed.
- Initialize alloc_context.user_addr in alloc_pages_bulk_noprof.

Changes since v2 (address review by Gregory Price and David Hildenbrand):
- v2 used pghint_t / vma_alloc_folio_hints API.  v3 switches to
  threading user_addr through the page allocator and using __GFP_ZERO,
  so post_alloc_hook() can use folio_zero_user() for cache-friendly
  zeroing when the user fault address is known.
- Exclude __PG_ZEROED from PAGE_FLAGS_CHECK_AT_PREP macro definition
  instead of runtime masking in __free_one_page.
- Drop redundant page_poisoning_enabled() check from mm core free
  path -- already guarded at feature negotiation time in
  virtio_balloon_validate.  The balloon driver keeps its own
  page_poisoning_enabled_static() check as defense in depth.
- Split free_frozen_pages_zeroed and put_page_zeroed into separate
  patches.  David Hildenbrand indicated he intends to rework balloon
  pages to be frozen (no refcount), at which point put_page_zeroed
  (21/22) can be dropped and the balloon can call
  free_frozen_pages_zeroed directly.
- Use HPG_zeroed flag (in hugetlb folio->private) for hugetlb pool
  pages instead of PG_zeroed, since pool pages are zeroed long after
  buddy allocation and PG_zeroed is consumed at allocation time.
- syzbot CI found a PF_NO_COMPOUND BUG in the v2 pghint_t approach
  where __ClearPageZeroed was called on compound hugetlb pages in
  free_huge_folio.  The v3 HPG_zeroed approach avoids this.
- Remove redundant arch vma_alloc_zeroed_movable_folio overrides
  on x86, s390, m68k, and alpha (12/22). Suggested by David
  Hildenbrand.
- Updated benchmarking script to compute per-run avg +- stddev
  via awk on CSV output.

Changes v1->v2:
- Replaced __GFP_PREZEROED with PG_zeroed page flag (aliased PG_private)
- Added pghint_t type and vma_alloc_folio_hints() API
- Track PG_zeroed across buddy merges and splits
- Added post_alloc_hook integration (single consume/clear point)
- Added hugetlb support (pool pages + memfd)
- Added page_reporting flush parameter for deterministic testing
- Added free_frozen_pages_hint/put_page_hint for balloon deflate path
- Added try_to_claim_block PG_zeroed preservation
- Updated perf numbers with per-iteration flush methodology

Written with assistance from Claude (claude-opus-4-6).
Reviewed by cursor-agent (GPT-5.4-xhigh).
Everything manually read, patchset split and commit logs edited manually.

Michael S. Tsirkin (22):
  mm: move vma_alloc_folio to page_alloc.c
  mm: add vma_alloc_folio_user_addr
  mm: thread user_addr through page allocator for cache-friendly zeroing
  mm: add folio_zero_user stub for configs without THP/HUGETLBFS
  mm: page_alloc: move prep_compound_page before post_alloc_hook
  mm: use folio_zero_user for user pages in post_alloc_hook
  mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
  mm: use __GFP_ZERO in alloc_anon_folio
  mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
  mm: hugetlb: use __GFP_ZERO and skip zeroing for zeroed pages
  mm: memfd: skip zeroing for zeroed hugetlb pool pages
  mm: remove arch vma_alloc_zeroed_movable_folio overrides
  mm: page_alloc: propagate PageReported flag across buddy splits
  mm: page_reporting: skip redundant zeroing of host-zeroed reported
    pages
  mm: page_alloc: clear PG_zeroed on buddy merge if not both zero
  mm: page_alloc: preserve PG_zeroed in page_del_and_expand
  mm: page_reporting: add per-page zeroed bitmap for host feedback
  virtio_balloon: a hack to enable host-zeroed page optimization
  mm: page_reporting: add flush parameter with page budget
  mm: add free_frozen_pages_zeroed
  mm: add put_page_zeroed and folio_put_zeroed
  virtio_balloon: mark deflated pages as zeroed

 arch/alpha/include/asm/page.h   |   3 -
 arch/m68k/include/asm/page_no.h |   3 -
 arch/s390/include/asm/page.h    |   3 -
 arch/x86/include/asm/page.h     |   3 -
 drivers/virtio/virtio_balloon.c |  17 ++-
 fs/hugetlbfs/inode.c            |  10 +-
 include/linux/gfp.h             |  22 ++--
 include/linux/highmem.h         |   9 +-
 include/linux/hugetlb.h         |  14 ++-
 include/linux/mm.h              |  15 +++
 include/linux/page-flags.h      |   9 ++
 include/linux/page_reporting.h  |  10 ++
 mm/compaction.c                 |   7 +-
 mm/huge_memory.c                |  18 +--
 mm/hugetlb.c                    | 101 +++++++++++-----
 mm/internal.h                   |  11 +-
 mm/memfd.c                      |  17 ++-
 mm/memory.c                     |  17 +--
 mm/mempolicy.c                  |  59 ++++-----
 mm/page_alloc.c                 | 204 ++++++++++++++++++++++++++------
 mm/page_reporting.c             |  62 +++++++++-
 mm/page_reporting.h             |  12 ++
 mm/slub.c                       |   4 +-
 mm/swap.c                       |  18 ++-
 24 files changed, 479 insertions(+), 169 deletions(-)

-- 
MST


