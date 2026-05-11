Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8C7CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA546B00CE; Mon, 11 May 2026 05:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C15B6B00D0; Mon, 11 May 2026 05:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBFC6B00D1; Mon, 11 May 2026 05:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75C76B00CE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:01:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8AA42C23C7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:01:26 +0000 (UTC)
X-FDA: 84754545372.05.3BFCE8F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3116B20007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:01:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CSTdqwR8;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g7Xo9WdXWzHhNxVtIbR27tgEoT2pCWEwBYttTKCNTVc=;
	b=AnXqVEagmDFvpnHC2DbIGvxbSOBm84/QdSfNadZy+RKhHnTT8B3Unz0ROEs8wrjxDYf7ty
	xOhnGeV+hO41POekqVffJT199oc33FRBEhILnPlS8FZJRuiEwW6hBjVxDEi9dgQiPXMQBu
	oRIoywsxnGwi6jO+zZIapeVvlwAHQoE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CSTdqwR8;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490084; a=rsa-sha256;
	cv=none;
	b=MRhXrnD9bzVkcjHzhrB7JlHKUDk8dDD6gi84ZaSeQ+0siiLdJ2Iioqgczy7D5ssk0ezcU5
	4oYVkJ5lxqnUK2PQr9F2SH10afJHSZEvwRr2zd6MLyPOrL7k/SKFZEfTcrHpuulnWvRUfY
	j33TjB90Es+2qdQLKC+JqBtulalHkZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=g7Xo9WdXWzHhNxVtIbR27tgEoT2pCWEwBYttTKCNTVc=;
	b=CSTdqwR8Spaes6E2IUpWBcHgdKTN7IIe7Fou+3wSnwz8klDMfMobe2082Hd4AiCB3+9zRc
	B7HucI240I/bHkxYzzXeEws3DxJE2sOhtkgzRrdMbSyRDaN8y+hsb1Oe5vO13vwliIKpkT
	ic2ZOz04ih9KjBDycdzW1+vuW6Id2hI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-qpgTVjHDNLyxWKTC7qw9Xg-1; Mon, 11 May 2026 05:01:22 -0400
X-MC-Unique: qpgTVjHDNLyxWKTC7qw9Xg-1
X-Mimecast-MFC-AGG-ID: qpgTVjHDNLyxWKTC7qw9Xg_1778490081
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e51dc35a3so31861605e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490081; x=1779094881;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7Xo9WdXWzHhNxVtIbR27tgEoT2pCWEwBYttTKCNTVc=;
        b=Ll69lQFfScoL3yejzTASQzirBI7b/kLDZhbb4jYHJJxLYISW48nOXAUtgFlXag4N6P
         rFcxhELZ4yerGlwxbLX6ledsCvDDEFsg8a4pLmpcO3C99Dvz0CsjF0rYWsvAXjhlG3sv
         g8YYaGhmIExLFWoSmxlA1nqt/N2e5kG4vqK79ekgY4fNxIdQo2c59ORex06ZRuwaQVux
         1/tgx8dq3ZdDknGf0PkxWpBaJh2d24V7fSxCLg8/+j/+B42NwlDTcWc6e8+wgneY+DC8
         HPaNABy7cPaL9aT6EnOXJcqdLyly/vEQFKNq61GGb7fzgHU96tlNoHpZ1HrXW7ar/YnK
         dLTg==
X-Forwarded-Encrypted: i=1; AFNElJ9Iu8abpg5K755Pt83r338ND3Qmu8A1ioY8gS6+t8BPbdkwYMuVuz1sxG/jZhfpcMwZYFSWnRkP9Q==@kvack.org
X-Gm-Message-State: AOJu0YxdrkIvOPB5ovuGYBLYAJmVYdBzXX+wLUGbK6iiN+tRV/HoVPri
	vSaSUEDdYS4jy/z1BL/vqH4QrUr/WU2RMANKTtLunh5dBI8ehMHEv3c3sEtaaVcZjZ2z93uFVeq
	dbnZnkMJyx/g0FBREGEijpkxKBaS/wadHt6BlYezjPmCnqyiEyHSv
X-Gm-Gg: Acq92OHISY1RQLl18M4n//YMqUGXiMP2yunhQ8xvIbT+WgvKSC8wUHM34FBYszAnd2T
	YVP8dorjNLXRdXrSATFfXD8WxCCl5061snel1DW9JkpXl4SoNCetNRNJ6RLwy4RSENLBPfyjJWA
	ekMtoCrEeK7ONOdY4mqjj6/ISNAOZg1NIalHMbAvQRVVkjOwErH9Zf6MkJeW1fPO4QR7J2h5TBO
	sPyQ3mmIapqHVhhJMoWlgsduvvn/ZpgG+EdJGQJGrm4Mc83XMzl5lpo+ra4gGUTiwt9ijx/NiyP
	y2LdvKltXpL/rAJrHADf0lIwTZ06jtNLD08TsF5G34kzGV+7Ty7xxofs8a//1pWiQiN54zSFmSU
	c/T4fdEDNP/2Hy7WFSwPXG7YYXFZsYznQPzhHwzqS
X-Received: by 2002:a05:600c:c0c1:b0:48a:56de:d62a with SMTP id 5b1f17b1804b1-48e51e1ddb2mr273379565e9.11.1778490080463;
        Mon, 11 May 2026 02:01:20 -0700 (PDT)
X-Received: by 2002:a05:600c:c0c1:b0:48a:56de:d62a with SMTP id 5b1f17b1804b1-48e51e1ddb2mr273378905e9.11.1778490079421;
        Mon, 11 May 2026 02:01:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8d6988sm57954135e9.5.2026.05.11.02.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:01:18 -0700 (PDT)
Date: Mon, 11 May 2026 05:01:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH resend v6 00/30] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UR_zUJRZ_WQT9MipvMepXHQV_Df4Ey9p-Pcg3UHBLJE_1778490081
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3116B20007
X-Rspam-User: 
X-Stat-Signature: i3o1s3crwmwphejz9uffxukkxb7ojjr1
X-HE-Tag: 1778490084-736057
X-HE-Meta: U2FsdGVkX18T6hQIuhR6rrLpEO4Qv4m7v3Dw7D8dGuC0lj47ZmTMzMqc9EksSHLWdBcCPPn9Fn0xRyBYgrasPqZfETMy409CoLkHPC5EG2QuS4B2ayNZFttfQotSObaHoXR5yUz2L+MTGkuwx+5SqqVk2BHHY980uQC+El3rEUpR8IUT6G8zPobQ4HvE73xKUjutq40wpgtjJNQ0T77dEK/gIlYcBqwBwd/0kDAfR9ds3wjMfrOaEBdihvfr7wlF6LYXkaVdmYXOAPA0VaLxTf1DGHcTymeNJobttGBB4+3GGySDnkFGxY4rm+OLA77KB6XMb++wN6fBFOxvaM4Z4Si5cQDupOeUnHAje0Kj40bO1f0T5xn7TT6NXOpeKGl6cmBq139tVXKKYRoJ+Y8URrOBIbTFUpu4r+3ffF9NP5oBz6mv+GNcqTG56vffQmVRDXxb5bR10ed662ycpXipAPCfbrzv4PDCG0w29f0S0iFLI3Nt31dOysySXJ7F3HNjrMdjpzV010qmC0v1PkThkTOm7nFaYgkUXf0qprpyAo82m4usg8G2PCG0Fb3CCYQ7XWEpmdAjfn2bDSUi8bHGn3ga7SszFPfeFVUS63cYCXek2DPh4/3UU9Lpame8jWhLBsiSum+3iptxzyRnzMRdcYAsrXk9buWie1dEQb/q54l/xt2txxVA3P5DEhIpLuR3orYk3z79FRAMf4fekILQKzpNw9GDHg3RXdMfnE65cGzACUzgJGaSFgd3vSkLD4fst7mlT42wjZUGgyp82Ngu2tUzBArRKEUr5V92yy9xRZRVJmP2tODOYUry5gP9cDrDnaxMtTHVgKvU3YibH+yTeQf+jD7CApaG/mFgn4TiUTQe2phHLY0iqv+Mw/KN1BYL2VG18o1Qe25VbbkTbAN7OZ7CsXcUgEfXeACWE7JfbdyVj0Q5T+PI3OYg12f1e5cUgyyl/FieOgCLIUtExT+
 2SpMQ3+W
 LUKcj9xOL8WCFhV//cRpJ1Yr5YT8WHpUeaGYQXr6nqzJMXGa/7eStTGse9mxABO/C3tecjhy0A3EAPkQSlcBU0Hdxd5+fpMFZxAtYNRQGtVV2GxTcC1O3ljOIgi41ha3rOOcebXb03VIa1w+oxuzvym4IsJzYWIkhTz8IovMiDUVkxDgvd0Mh41sNZXU7Y+KMrvXmI37p2+SuZDIROv/m2FDd5gDtC+Fmd9uMdN3vB1Je0hJxSJMmuW/F6mItraLbuolat1yz7eo19KE/N093BO5P01wYnhCjAxLfmA6Ubn7uzWl9ihFS8mQFRr+3UVUQOQjB3DMhHBxGUpC9LBOE/oFvS2HV7trAV0EIbw2X4dEXb24WkGwv3QzJB8Stipik69hyn3BPNJ4MXplA4p5RZwvN7Y8qI5ndZWjN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resending with no changes after a botched send. Fingers crossed.

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

For page reporting, VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (bit 6)
is used. For the inflate/deflate path,
VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE (bit 7) is used.

Virtio spec: https://lore.kernel.org/all/cover.1778140241.git.mst@redhat.com

Based on v7.1-rc2.  When applying on mm-unstable, two conflicts
are expected:
- kernel_init_pages() was renamed to clear_highpages_kasan_tagged()
  in mm-unstable.  Use clear_highpages_kasan_tagged() in the
  post_alloc_hook else branch.
- FPI_PREPARED uses BIT(3) in mm-unstable.  Bump FPI_ZEROED to
  BIT(4).
Build-tested on mm-unstable at e9dd96806dbc:
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git zero-mm-unstable

The first 16 patches are independently mergeable cleanups + fixes:
- Patches 1-15: mm rework + cleanups + init_on_alloc double-zeroing fix.
- Patch 16: page_reporting capacity bugfix.
Patches 17-26: page reporting zeroing (DEVICE_INIT_REPORTED).
Patches 27-30: inflate/deflate zeroing (DEVICE_INIT_ON_INFLATE).

-------

Performance with THP enabled on a 2GB VM, 1 vCPU, allocating
256MB of anonymous pages:

  metric         baseline            optimized           delta
  task-clock     232 +- 20 ms        51 +- 26 ms         -78%
  cache-misses   1.20M +- 248K       288K +- 102K        -76%
  instructions   16.3M +- 1.2M       13.8M +- 1.0M       -15%

With hugetlb surplus pages:

  metric         baseline            optimized           delta
  task-clock     219 +- 23 ms        65 +- 34 ms         -70%
  cache-misses   1.17M +- 391K       263K +- 36K         -78%
  instructions   17.9M +- 1.2M       15.1M +- 724K       -16%

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

PG_zeroed lifecycle:

  Sets PG_zeroed:
  - page_reporting_drain: on reported pages when host zeroes them
  - __free_pages_ok / __free_frozen_pages: when FPI_ZEROED is set
    (balloon deflate path)
  - buddy merge: on merged page if both buddies were zeroed
  - expand(): propagate to split-off buddy sub-pages

  Clears PG_zeroed:
  - __free_pages_prepare: clears all PAGE_FLAGS_CHECK_AT_PREP flags
    (PG_zeroed included), preventing PG_private aliasing leaks
  - rmqueue_buddy / __rmqueue_pcplist: read-then-clear, passes
    zeroed hint to prep_new_page -> post_alloc_hook
  - __isolate_free_page: clear (compaction/page_reporting isolation)
  - compaction, alloc_contig, split_free_frozen: clear before use
  - buddy merge: clear both pages before merge, then conditionally
    re-set on merged head if both were zeroed

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

- PG_zeroed is aliased to PG_private.  __free_pages_prepare() clears it
  (preventing filesystem PG_private from leaking as false PG_zeroed).
  FPI_ZEROED re-sets it after prepare for balloon deflate pages.
  Is aliasing PG_private acceptable, or should a different bit be used?

- On architectures with aliasing caches, upstream with init_on_alloc
  double-zeros user pages: once via kernel_init_pages() in
  post_alloc_hook, and again via clear_user_highpage() at the
  callsite (because user_alloc_needs_zeroing() returns true).
  Our patches eliminate this by zeroing once via folio_zero_user()
  in post_alloc_hook.  Not a critical fix (people who set init_on_alloc
  know they are paying performance) but a nice cleanup anyway.


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

Changes since v5:
- Rebased onto v7.1-rc2.
- Split alloc_anon_folio and alloc_swap_folio raw fault address
  changes into separate patches.
- In virtio, move PAGE_POISON check for DEVICE_INIT_REPORTED
  from probe() to validate(), clearing the feature instead of
  just gating host_zeroes_pages.  Same for confidential
  computing check.
- Fix bisectability: FPI_ZEROED definition and usage now in
  the same patch.
- Lots of commit log tweaks.
- Reorder: REPORTED before ON_INFLATE.
- Kerneldoc fixes.

Changes since v4:
With virtio spec posted, update to latest spec:
- Add VIRTIO_BALLOON_F_DEVICE_INIT_REPORTED (bit 6) for reporting.
- Add VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE (bit 7) for inflate.
- Per-page virtqueue submission, per-page used_len feedback.
- Balloon migration preserves PageZeroed hint.
- Page_reporting capacity bugfix for small virtqueues.
- PG_zeroed propagation in split_large_buddy.
- Disable both features for confidential computing guests.
- Gate host_zeroes_pages on PAGE_POISON/poison_val: when PAGE_POISON
  is negotiated with non-zero poison_val, device fills with poison
  not zeros, so host_zeroes_pages must be false.
- Disable ON_INFLATE when PAGE_POISON with non-zero poison_val.
- Bound inflate bitmap reads by used_len from device.
- Move ON_INFLATE poison_val check to validate() for proper
  feature negotiation.
- Fix NUMA interleave index for unaligned VMA start (new patch 1).
- Drop vma_alloc_folio_user_addr: with the ilx fix, callers can
  pass raw fault address to vma_alloc_folio directly.
- Tested with DEBUG_VM, INIT_ON_ALLOC/FREE enabled.

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
- Deflate and hugetlb changes are much smaller now.  Still, the
  patchset can be merged gradually, if desired.

Changes since v2 (address review by Gregory Price and David Hildenbrand):
- v2 used pghint_t / vma_alloc_folio_hints API.  v3 switches to
  threading user_addr through the page allocator and using __GFP_ZERO,
  so post_alloc_hook() can use folio_zero_user() for cache-friendly
  zeroing when the user fault address is known.
- Use FPI_ZEROED to set PG_zeroed after __free_pages_prepare() instead
  of runtime masking in __free_one_page (further refined in v4).
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

Michael S. Tsirkin (30):
  mm: move vma_alloc_folio_noprof to page_alloc.c
  mm: mempolicy: fix interleave index for unaligned VMA start
  mm: thread user_addr through page allocator for cache-friendly zeroing
  mm: add folio_zero_user stub for configs without THP/HUGETLBFS
  mm: page_alloc: move prep_compound_page before post_alloc_hook
  mm: use folio_zero_user for user pages in post_alloc_hook
  mm: use __GFP_ZERO in vma_alloc_zeroed_movable_folio
  mm: remove arch vma_alloc_zeroed_movable_folio overrides
  mm: alloc_anon_folio: pass raw fault address to vma_alloc_folio
  mm: alloc_swap_folio: pass raw fault address to vma_alloc_folio
  mm: use __GFP_ZERO in alloc_anon_folio
  mm: vma_alloc_anon_folio_pmd: pass raw fault address to
    vma_alloc_folio
  mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
  mm: hugetlb: use __GFP_ZERO and skip zeroing for zeroed pages
  mm: memfd: skip zeroing for zeroed hugetlb pool pages
  mm: page_reporting: allow driver to set batch capacity
  mm: page_alloc: propagate PageReported flag across buddy splits
  mm: page_reporting: skip redundant zeroing of host-zeroed reported
    pages
  mm: page_reporting: add per-page zeroed bitmap for host feedback
  mm: page_alloc: clear PG_zeroed on buddy merge if not both zero
  mm: page_alloc: preserve PG_zeroed in page_del_and_expand
  virtio_balloon: submit reported pages as individual buffers
  mm: page_reporting: add flush parameter with page budget
  mm: page_alloc: propagate PG_zeroed in split_large_buddy
  virtio_balloon: skip zeroing for host-zeroed reported pages
  virtio_balloon: disable reporting zeroed optimization for confidential
    guests
  mm: add free_frozen_pages_zeroed
  mm: add put_page_zeroed and folio_put_zeroed
  virtio_balloon: implement VIRTIO_BALLOON_F_DEVICE_INIT_ON_INFLATE
  mm: balloon: use put_page_zeroed for zeroed balloon pages

 arch/alpha/include/asm/page.h       |   3 -
 arch/m68k/include/asm/page_no.h     |   3 -
 arch/s390/include/asm/page.h        |   3 -
 arch/x86/include/asm/page.h         |   3 -
 drivers/virtio/virtio_balloon.c     | 160 +++++++++++++++++----
 fs/hugetlbfs/inode.c                |  10 +-
 include/linux/gfp.h                 |  12 +-
 include/linux/highmem.h             |   9 +-
 include/linux/hugetlb.h             |  14 +-
 include/linux/mm.h                  |  15 ++
 include/linux/page-flags.h          |   9 ++
 include/linux/page_reporting.h      |  13 ++
 include/uapi/linux/virtio_balloon.h |   2 +
 mm/balloon.c                        |   7 +-
 mm/compaction.c                     |   7 +-
 mm/huge_memory.c                    |  12 +-
 mm/hugetlb.c                        |  99 +++++++++----
 mm/internal.h                       |  17 ++-
 mm/memfd.c                          |  14 +-
 mm/memory.c                         |  17 +--
 mm/mempolicy.c                      |  73 ++++------
 mm/page_alloc.c                     | 213 +++++++++++++++++++++++-----
 mm/page_reporting.c                 |  88 ++++++++++--
 mm/page_reporting.h                 |  12 ++
 mm/slub.c                           |   4 +-
 mm/swap.c                           |  18 ++-
 26 files changed, 615 insertions(+), 222 deletions(-)

-- 
MST


