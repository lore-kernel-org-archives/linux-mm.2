Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0CEF94CB3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C636B0005; Tue, 21 Apr 2026 18:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663E36B0088; Tue, 21 Apr 2026 18:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58376B0089; Tue, 21 Apr 2026 18:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A93256B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:01:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F3DA1613FE
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:18 +0000 (UTC)
X-FDA: 84683934636.09.D486779
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id EF7521C0007
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:01:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVZytC1h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808875; a=rsa-sha256;
	cv=none;
	b=o+mui7sgzUxwFecsLkwkVgYmGs3ppcUPoCSuk/RjesXMaA5ldrMG84qeBeZcgNPlTuDcRR
	rBIhGNbxpxEWdpH+8wiPG98VuSyTFx31O+MJr/eNoI49l4UgQ+xvCWekzpS+jNFbpiH3wR
	ZFNqL5CmNUjN4Lxn5LhWC1Wg8G3zsTo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVZytC1h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LTem+Ne5wb4+AyKa+wXcnOG+8NLe32di58x5iUp/NiY=;
	b=Wzd0lF+ypPQ7K/7YD3uEjlkg6j0UNRmd63KVw5G+xR4CSrge56TzXzk4USRv/DCPGaUYVM
	QvIBY//SNOlkWNUL28WMRh28fUThuaKKL2JqF1gslxLGxPNmzlZ4JMSAt8nRqxcqa52K5/
	xbW8mMJpx+3LUv5inKTb1f4fJNhnOE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=LTem+Ne5wb4+AyKa+wXcnOG+8NLe32di58x5iUp/NiY=;
	b=WVZytC1hCoUXEAEgYJasKaYqpyvhbw4RxWpOWMQmcJ5vM86VTn9fR6FnP5BCZuUe2TvwPR
	FEVHpOicaQeLxe6Squd9KXbL/cxJ2alxGAahDZmBQLK4BHHmPyBUDbec1lB7ld5K/rRV5n
	TFSy/D8B4tuzmzV6920SHrIoYdsmSBw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-DXP3oxrdMC6mAvk_BsWyGQ-1; Tue, 21 Apr 2026 18:01:13 -0400
X-MC-Unique: DXP3oxrdMC6mAvk_BsWyGQ-1
X-Mimecast-MFC-AGG-ID: DXP3oxrdMC6mAvk_BsWyGQ_1776808872
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4411a69f565so1982275f8f.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808872; x=1777413672;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LTem+Ne5wb4+AyKa+wXcnOG+8NLe32di58x5iUp/NiY=;
        b=cfdsERTBg4CN6J/x+IVd8pHcJqHzSl2Dl1POWj7/5FHKcW/4NMzy6MXplld3OdgWrG
         tznAlDSgg0PgOSjjOpYjMhErYSnfIgSamhZR6nCGznGyIIC6LeLB+aOeYxdFiQjIM7ss
         e0RPyDs53bBuI3tR5LcgZ2yfykDkTYabu/xfrvOXHNV34j4/ph5B4K3o9qWy6vZS65rv
         Mu3N/N5hTe4+/CLkV8C3cUQ2Eb8UgF9Y6FpUm/881emlZTiJcsh7v+pX5VWWVhyCBqpr
         6+45/3A7aZuVYlqyq6XewkpY/7vQbjly/HfJauO8uBWIoHGxXZPYzRQo2lTNLOPRDoVx
         X1UQ==
X-Forwarded-Encrypted: i=1; AFNElJ9cr2PNuOqB5dPoFbCUxTHa6X0T/BZjjP86utIpJtpJ/MSPUpfrLrx3lePGFy4ZFeliW3F4f0KPow==@kvack.org
X-Gm-Message-State: AOJu0YxcL1/nIfcnt/7p01opjtI2ZtFAECqLF6TfnxyUdWnE2nyPVJSe
	iJv1egwRl7P/LhnShez+tmzN0yQGX6dluglZ1Xbe87GQqMDEbyst3mccG7V+vyYZX8S6TNTlLsD
	f9KHedRRs1sLDS6dUgJkxvtY1S3/feSNidoYMageiD8cn76cqpDSJ
X-Gm-Gg: AeBDiesIQN42PcHxcZFB1iOr+41HxggZw8jf2yq7Oo8GXmQ0UvXSorPi6MoP7iJVbjl
	H3+v66EoB8N5DMpC1FASeyt6wwreiU9ReI4S7cfQqE7XD41ZWspn08uYnrGaVLqohnL6spoX4cf
	I5OcOS4NYdpDlUcqASp2f0e1rU2OiWfctu2iL+6NG6/pFJst5u/srsTuv0NNeYbnHb8cdNCwWTk
	HtYUui/FpIu0mMbljDVpTO8Wr6s3/MP8sSaJENAK3EMkaPbGdcY6VvuiA1yBVD10tWxsJ9ewDLG
	QGH6MDNPRGnVZkyqDrlPZEgSZEOa+3EeKUrphurV2Ml9A3nsOWZ1Ktdc7+8vxoqzBLX2nROk9s9
	td7GNktlMOjSWl3cIqraP+9sqaZzwFMcXe98LPOfUCJqDrxDKCkDBZA==
X-Received: by 2002:a05:6000:18a6:b0:43d:1c59:2dc with SMTP id ffacd0b85a97d-43fe3e0dafemr32065200f8f.28.1776808871414;
        Tue, 21 Apr 2026 15:01:11 -0700 (PDT)
X-Received: by 2002:a05:6000:18a6:b0:43d:1c59:2dc with SMTP id ffacd0b85a97d-43fe3e0dafemr32065123f8f.28.1776808870786;
        Tue, 21 Apr 2026 15:01:10 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e46471sm39725991f8f.28.2026.04.21.15.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:01:10 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:01:07 -0400
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
Subject: [PATCH RFC v3 00/19] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H7JqC-a1YtYSOMiZRQcnM9jqiEybefvqfFZl-b9eujw_1776808872
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Stat-Signature: kkj87kwy14k8bg4i484u9uudmtjktnyx
X-Rspam-User: 
X-Rspamd-Queue-Id: EF7521C0007
X-HE-Tag: 1776808874-591757
X-HE-Meta: U2FsdGVkX1//060C45+xVSVtU15Q+ACxnWTUuKhtf7NkXWk3r0L3Br4G2621oToAfui2O6KMgryN9CwRgR7CXR+/CohMpOWhduonOIiHBgLH2vb9IiqXkRQBKEHEJU4OCtRUaGmhfNgGpce0Q0U2nH7cdiTrc4pupp9jzZlKtaWbqR2rOWJGFkkQRRbtSLxVaAVI7nHqzJZdL050hINUqn9mrkf2n1uEWkNLB/GGLGG8VZ670sCZHRGf33Yx7AG65DerXEBH7DPXUO7uR1LwHadPOl5F5LUZlUWdr/BYcNOvbLzwBtRS6w370xP9slNddCUXj7bRpvbIfvrn6UzW5BWehqVuT4VpiNtQeKOPLD4Xm1TMWyQL1xTDrLmAT5gTHDagtk2XMAXzgQHW+GqHA3ZTwxr/QJQ+JlHLhT/dpPArjJMkcX1z0Y2xxPtwE56F8vTBy8N7ABIh67YbT7rM2RPRG6yi1pWSjTwHeQchO9JeQdGJuRVDUO4HzMVJR4gcMfoG/sexCTZhQroudDCe7DBK4qn1MQWk5Ed/cfAx7rDRmoF5riiwODzwoqI73g0IplUaFMYAUCmJDpLGn84dM2MSjwcJSwCFNJHu5nuD/HD94/RY4935EcVf8s7ADlS05lcVyB5hBB1b7hT6Ho2u3htgT0Y4jMZmBJIGs5NKvG63fcUGVoau9NneHY59xoLcSjcQKpaAz+8TxYe/jp5iQZ94ymecsj3pF5QBQNUJspWhTGpxqOZzM2bxOqV1m/0oADWMzphp2YY1uZ6FvESvM7M229t78eQXjczJQHmF0j1TH33AaXE87Sl4b/DLmwQLyXT5hs8uRQtkZtaGjzPbP5qmnxLKW0KVFb9PziH2qwPv1t0GI01gBMYVTj86LbD003I1O/vuhOcjUmhnZs9D6A3Gags0AYiGF2Ock18PdwDAqibOHnkX/FLbNssIHtH87na+V4eOtIuYAoKVaN1
 EBMit+9c
 EtT21zFd+IaZdVm9Bxz7YipXe4YAgDPo2fm4bDPIhOsJO+++4wHHY5sv3q5ncKRiq8S2nVf02cCcHNkMz5G9s+SLGHEcSJtcUhlddk+UuhAmDlnHEEBXThBV/LR/WMgt23g8qaD4EUIy7v2EASJtya+Dxw3I+/ErQey4XrIRVNF8WLMNTgzk23fEZ5w12dfq6em2DlpUfEYnavg+RZJaVqge8NQbipQ2zAmhql+djfMzmpZGGdGnl6A9qgvfD8bwpIwyiVO2RpGD18+syLmoW2jQuvOOy5tACcVeQ4UPnkeHFm4U=
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
- first 10 patches, including the fix for init_on_alloc double zeroing
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
- The virtio_balloon module parameter (13/19) is a testing hack.
  A proper virtio feature flag is needed before merging.
- Patch 14/19 adds a sysfs flush trigger for deterministic testing
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
  (16/19) can be dropped and the balloon can call
  free_frozen_pages_zeroed directly.
- Use HPG_zeroed flag (in hugetlb folio->private) for hugetlb pool
  pages instead of PG_zeroed, since pool pages are zeroed long after
  buddy allocation and PG_zeroed is consumed at allocation time.
- syzbot CI found a PF_NO_COMPOUND BUG in the v2 pghint_t approach
  where __ClearPageZeroed was called on compound hugetlb pages in
  free_huge_folio.  The v3 HPG_zeroed approach avoids this.
- Remove redundant arch vma_alloc_zeroed_movable_folio overrides
  on x86, s390, m68k, and alpha (10/19). Suggested by David
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

Michael S. Tsirkin (19):
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
  virtio_balloon: a hack to enable host-zeroed page optimization
  mm: page_reporting: add flush parameter with page budget
  mm: add free_frozen_pages_zeroed
  mm: add put_page_zeroed and folio_put_zeroed
  mm: page_alloc: clear PG_zeroed on buddy merge if not both zero
  mm: page_alloc: preserve PG_zeroed in page_del_and_expand
  virtio_balloon: mark deflated pages as zeroed

 arch/alpha/include/asm/page.h   |   3 -
 arch/m68k/include/asm/page_no.h |   3 -
 arch/s390/include/asm/page.h    |   3 -
 arch/x86/include/asm/page.h     |   3 -
 drivers/virtio/virtio_balloon.c |  12 ++-
 fs/hugetlbfs/inode.c            |  10 ++-
 include/linux/gfp.h             |  26 ++++--
 include/linux/highmem.h         |   9 +-
 include/linux/hugetlb.h         |  14 ++-
 include/linux/mm.h              |  43 +++++++++
 include/linux/page-flags.h      |  12 ++-
 include/linux/page_reporting.h  |   3 +
 mm/compaction.c                 |   5 +-
 mm/filemap.c                    |   3 +-
 mm/huge_memory.c                |  12 +--
 mm/hugetlb.c                    | 101 +++++++++++++++-------
 mm/internal.h                   |   8 +-
 mm/khugepaged.c                 |   2 +-
 mm/memfd.c                      |  17 ++--
 mm/memory.c                     |  15 +---
 mm/mempolicy.c                  |  39 ++++++---
 mm/migrate.c                    |   2 +-
 mm/page_alloc.c                 | 149 ++++++++++++++++++++++++--------
 mm/page_frag_cache.c            |   4 +-
 mm/page_reporting.c             |  56 +++++++++++-
 mm/page_reporting.h             |  12 +++
 mm/shmem.c                      |   2 +-
 mm/slub.c                       |   4 +-
 mm/swap.c                       |  18 +++-
 mm/swap_state.c                 |   2 +-
 30 files changed, 433 insertions(+), 159 deletions(-)

-- 
MST


