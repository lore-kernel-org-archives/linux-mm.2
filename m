Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403D0C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 07:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056706B0088; Sat, 26 Sep 2026 03:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0072B6B008A; Sat, 26 Sep 2026 03:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11756B008C; Sat, 26 Sep 2026 03:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF0456B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:44:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BECF16083B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:39:31 +0000 (UTC)
X-FDA: 85255113342.15.6CDB225
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0980C0007
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:39:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GZB9qXz8;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790408369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzNu4qsML/vUrmG56fm/uRslLdrHhJ56SN3Sn3YDpZg=;
	b=SV2rT0JwPuzzBP2PSLAy7aVMMatcUQQy5iLSpTu714tbIgcaH7DPlkDg/HN78noYoPMHry
	cPtZ2kC/mTwyxNai2yUQP7j/xfj3ABbRs/CaXCO7dJkD4pVX+ObHf260od5g2IZnM95bvQ
	6NlVMN8E0mRlg3cu9KHimMZHG0h2Qkw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GZB9qXz8;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790408369;
	b=aIJnDyqOVlW56zOQOvw297+F2bcsVJNKmhqvbWjUkOX15HXtxcvRvR7nIPqlX9SEhVrSHP
	uWCOMdK4HobsZ7dMGxI+yzLlSX7vO6Xx8m0BiYsmSdldTaGViuFjsbfd0OekOCDaq2BaRC
	WVaaN5cqmw8rdChGEZwUFlnSkpF4QNk=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso11406975e9.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790408368; x=1791013168; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UzNu4qsML/vUrmG56fm/uRslLdrHhJ56SN3Sn3YDpZg=;
        b=GZB9qXz8zGzgTjP2nQ8JxlkoDffpEKKnN9+L7RBTSUFqZWzN8xrTdrkj8Vy+fy+yaJ
         qErMkgnLuYgBGbt0fSMT/Xv0vnzi/snGzUPmk0Bi//S2k3CQB1F2pQiLWB1sfGcj01v5
         ymij7LA+m0hm2oUBO+91k7SU37TMsUtXog78529COaWbDpdoMEg7Eb8Pcd6LzBycgvAP
         YznmG2sRP+yQ1F1AHcrpIX3w2mOIBI1aO3fPM9mVYyrf0mm6HYxcA7EdiiftHC4zBGUD
         iQ+689fNwQ3S0UpXKd0oo8TIu1C3OKHDyU0Q6Wp9xgkN8bAnrdOzslNVk3kh2ywgvllK
         koLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790408368; x=1791013168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UzNu4qsML/vUrmG56fm/uRslLdrHhJ56SN3Sn3YDpZg=;
        b=B2yQBOGfg7meCqVJjUcXPH7lgIVxGr88yzF/SeimYZXPSTuJStn8pnuepILfbuTeuB
         zFUzVQoiGo8HFmxtKmBgvmxkUortdQGqXA9l0PVifLv0aFGqRDLeYTsYaUyGncYKOw8K
         FgXQAkTdZAuq4uafhTIfVH19DM4NNLxvqXveID/S5jp8ytDXKVN2De9FF+8Cg29Lvhn0
         6bDcEzaiqdrPWfYlULbmvWkma1xcd5k3M+I06glJ4dSCG/m4KvdWLfT2nVloBKsA3zLe
         RrVf+A+g0vpktUDEcpOzGGEajYFa7cc0NOADp8o3IXsxUcuLeB4LlQpW3qf6Plab/wO/
         wPhg==
X-Forwarded-Encrypted: i=1; AKwUvBzRRncXex793oA7npYMV8kIe897zEK2DkijLAuuzSMp9MW6oPK7qLo0E5OJ8JzHO/YmrGaWF9wuow==@kvack.org
X-Gm-Message-State: AFuF++mKG12CsMcyTmPCHvVKf2eyYSyQ8+cCJFk6b10yl1dHjdOpmlGO
	LCFmdaO0/+yWvErbRxPb7Pi1m9LOkMUGNOzWO5g8cBe1AGKMcKccZLm1
X-Gm-Gg: AYBFou3ctzt3W0jfd6wDK6EPXBqRdmd+YaV4jq6eWYmHtE3SIIEJBqw6nqSHB+HM8nz
	NfKPeLfuRJWFWoejlqiyHcbYtTB/0zdcbtC5n+Zh069UVSw1DWCBKe6r8AlhJzki5EWZcMQdCrw
	hf67Z3t1ZPEFewv3pkXJ66BRK7+ZJsgAnoW+Eu4BJnnC39vqdEkkVELjTyCla09of/1HQlqd/mO
	ZQQulegyz0rN1ojJANDNam4zQc2rzkyy9/Gt1p7Lg18tr5eY7GxE8r6CVbepZpRW9L+ZmElYedo
	PVDu/BWSnbR53MCjiaVMQS2UX4mxsXJAohWFLhzhud3p2FDJZDgKDTS3/xklzQ3/Kr91wwThiuA
	GiK+b4oM9Inf1WdtByRTkFwYLDKwTthjAORcysTzCDROrJufKQwiyY16vpVTSnO+ZvmH4XD5rJX
	aFA6Az2qZmr70+MtrgdPJU9K4BXp0WkI6EUrWQPwZQ2T0XHAoVcxAyzyRl6JtzRxNfEs/xCAMaZ
	/CKyy6UppOqNySGnSfdtsUZFvXWGaVHYnu7j4DDQ9aaxJU0JY9sbd0QpgWIG4YZ00BZtngMwCpo
	YcK/uJCjswkFXDVNGuMOLVrvEhDGhHbJPKFjqUxRPF9FT/RC8/S+FS4xeRGcE1aFETY0GdwyWl1
	v9zRYT18=
X-Received: by 2002:a05:600c:6990:b0:493:c47f:3c55 with SMTP id 5b1f17b1804b1-49fe7b52fd1mr130966035e9.5.1790408367344;
        Sat, 26 Sep 2026 00:39:27 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b162-c701-4960-a998-3de8-2fce.310.pool.telefonica.de. [2a02:3100:b162:c701:4960:a998:3de8:2fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff06b4d45sm118038915e9.7.2026.09.26.00.39.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 00:39:26 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Breno Leitao <leitao@debian.org>,
	Muchun Song <muchun.song@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH 5.15.y] mm/hugetlb: fix avoid_reserve to allow taking folio from subpool
Date: Sat, 26 Sep 2026 09:39:16 +0200
Message-Id: <20260926073916.78450-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <2025021025-deflector-judge-df07@gregkh>
References: <2025021025-deflector-judge-df07@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0980C0007
X-Rspam-User: 
X-Stat-Signature: dc6kxp43cfmu5f86jedgokdtn7eybsra
X-HE-Tag: 1790408369-912286
X-HE-Meta: U2FsdGVkX1/H+XBBBkdnYzZEf/7eypioZKfRkkWkXR9pvwHZiphf1VL0oYt68vV5bFFjBS/PyMqvKxdnLAVcXaWcBBMWNUEYXZBbjmJUmfIz3asr4vz8LAXe1T+mApnBahCrNouWTTWimp0nHC2ZQiINVgsW2DGmiv/77Z3ce4WMtZA153lexM8cmDcYfhLtgWFR/obx/0+TaPZCpaFw3WS5Wolkn8r0InOEUOuf4+iMxXB9sxCNgRoye1KsE5jJqIrVMCW/A/wUJjj5wtvqIoJqlbCpoZGtBc1MSMmWw6mkjiGIMrzGU++voG+8vw9xqSE3xDLnXZ16kfnBpMjf80i+Cv/5HKKz7uYGPoYirAuxjaZct+zoq30N5DbN+5ME3EHPqRzG7Wh7y+8tHkHRo8RFD+1sIQNLGeeu9XJnj6aq/zDsPDtmFkLrM8CcjSBwqCfzf+JN4SpR+rnRVo5VwXrVS7bdmqAxCy7r50jcSKxj+J5LZc7bEL/b7ZMVN88YqM/xUojzaq4YKmKO1B21UJa+KwYwpDZVYEgF6ojDFpAVvz88kcLdJIJfE8/GbY8m+gU0sMDMNOhT11pqEKTf7DdLnsfarIxTRrRRvKVOVpKqo0smvZxbCbHRA4vTrSy7O4Op9md9Pwbdwsqp/i1lSdPfOFZM31Z1eM2QYmyr2aejH1NbDMXYJa07RqQIm2xGt2kF1CFlkLS+ZRbniG7Yy3i0+9BINcOigNvrNi5LEG96HsCnE3DPW1u2zoBqS7E293r3lkSYB4zkhe42OB9uJ5Yk8gLqxVd2HXlHy3HuXnShQy02zput2+BLtGE/UNu2DGuGLrnyiZC3f6cd5Uizfodtho/NVX/rKIRwfjVxhWxReOLcjqYydTnzITngIqeF/J7LidBQjAWPddECsGVBQtQdEuRNLs7wsFs4xmlX0YbzCd31ylJUADTRdOWtwd/XjcbxWYVAyFT4zmsfWD7
 VO9aFqse
 ++IGP2lhGu923k9B7B+PyiNHkjjqFiO/vNjygLcREVZ5XAUgqQB8IUcdAZkSnB4i7aao9QU0Qw+Ng3AOTESghQu68SpMQ8He37Tj7d44ymwCgVTnWT4rFFR63vSU+ZnK/jPlQ/a5EAvw988m97FTsYp+AtUzeernGSDSVpQoMqD2kMzPfXPdSJbZW7guzU+yFMm29PrHPRhML9TiejgT96aT666M4SEqBzu/hVK2C8+uAu9D8DG/oCMyGYHTNwbPXqwGtPiecrWaWRG+dg/sKmEDbrp1YwFUPefiRp4Pe55XqLCg4Mx+LW6fN+gNyIBkEWV0hCAYoB7mwh5lLRr5hrhW1qtSD9lrD21DT3eoJaGftbRv9Q1Zlk0RMdu7eqgZ7YwvpFMTaOKNMsW7jHG8idOJv3NXU4WHL55hP+/ZwlE/TInBb1aeAuY4xGO/PaMBjo40KvaouY5w5tsOUHYsLiwFrnxCFlXjcLPFi3Fa5OTwCwnmZJah9EQehM/OX2BYK8axbrgwm4QpltYrejFpprarsqsN9NTuuGt/86gJZ3xkgUZk1JFoIB4mZU2qKNc//qdCFBfjGeXRnSTGdfGu6RMvYd90Kl0LXJNpfMAFSWqRRyrEUVkw1/8U1GoO8JO5iMaH+s2WzxZkfddZ9LSCGJugRPCDGnFMQAFgso61jaArCTpbadhZp3NbS8esi1flyEHUcH3MbRRyipoyeYYMMMYny1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Peter Xu <peterx@redhat.com>

commit 58db7c5fbe7daa42098d4965133a864f98ba90ba upstream.

Patch series "mm/hugetlb: Refactor hugetlb allocation resv accounting",
v2.

This is a follow up on Ackerley's series here as replacement:

https://lore.kernel.org/r/cover.1728684491.git.ackerleytng@google.com

The goal of this series is to cleanup hugetlb resv accounting, especially
during folio allocation, to decouple a few things:

  - Hugetlb folios v.s. Hugetlbfs: IOW, the hope is in the future hugetlb
    folios can be allocated completely without hugetlbfs.

  - Decouple VMA v.s. hugetlb folio allocations: allocating a hugetlb folio
    should not always require a hugetlbfs VMA.  For example, either it got
    allocated from the inode level (see hugetlbfs_fallocate() where it used
    a pesudo VMA for allocation), or it can be allocated by other kernel
    subsystems.

It paves way for other users to allocate hugetlb folios out of either
system reservations, or subpools (instead of hugetlbfs, as a file system).
For longer term, this prepares hugetlb as a separate concept versus
hugetlbfs, so that hugetlb folios can be allocated by not only hugetlbfs
and other things.

Tests I've done:

- I had a reproducer in patch 1 for the bug I found, this will start to
  work after patch 1 or the whole set applied.

- Hugetlb regression tests (on x86_64 2MBs), includes:

  - All vmtests on hugetlbfs

  - libhugetlbfs test suite (which may fail some tests, but no new failures
    will be introduced by this series, so all such failures happen before
    this series so shouldn't be relevant).

This patch (of 7):

Since commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a
process that called mmap(MAP_PRIVATE) on hugetlbfs will succeed"),
avoid_reserve was introduced for a special case of CoW on hugetlb private
mappings, and only if the owner VMA is trying to allocate yet another
hugetlb folio that is not reserved within the private vma reserved map.

Later on, in commit d85f69b0b533 ("mm/hugetlb: alloc_huge_page handle
areas hole punched by fallocate"), alloc_huge_page() enforced to not
consume any global reservation as long as avoid_reserve=true.  This
operation doesn't look correct, because even if it will enforce the
allocation to not use global reservation at all, it will still try to take
one reservation from the spool (if the subpool existed).  Then since the
spool reserved pages take from global reservation, it'll also take one
reservation globally.

Logically it can cause global reservation to go wrong.

I wrote a reproducer below, trigger this special path, and every run of
such program will cause global reservation count to increment by one, until
it hits the number of free pages:

  #define _GNU_SOURCE             /* See feature_test_macros(7) */
  #include <stdio.h>
  #include <fcntl.h>
  #include <errno.h>
  #include <unistd.h>
  #include <stdlib.h>
  #include <sys/mman.h>

  #define  MSIZE  (2UL << 20)

  int main(int argc, char *argv[])
  {
      const char *path;
      int *buf;
      int fd, ret;
      pid_t child;

      if (argc < 2) {
          printf("usage: %s <hugetlb_file>\n", argv[0]);
          return -1;
      }

      path = argv[1];

      fd = open(path, O_RDWR | O_CREAT, 0666);
      if (fd < 0) {
          perror("open failed");
          return -1;
      }

      ret = fallocate(fd, 0, 0, MSIZE);
      if (ret != 0) {
          perror("fallocate");
          return -1;
      }

      buf = mmap(NULL, MSIZE, PROT_READ|PROT_WRITE,
                 MAP_PRIVATE, fd, 0);

      if (buf == MAP_FAILED) {
          perror("mmap() failed");
          return -1;
      }

      /* Allocate a page */
      *buf = 1;

      child = fork();
      if (child == 0) {
          /* child doesn't need to do anything */
          exit(0);
      }

      /* Trigger CoW from owner */
      *buf = 2;

      munmap(buf, MSIZE);
      close(fd);
      unlink(path);

      return 0;
  }

It can only reproduce with a sub-mount when there're reserved pages on the
spool, like:

  # sysctl vm.nr_hugepages=128
  # mkdir ./hugetlb-pool
  # mount -t hugetlbfs -o min_size=8M,pagesize=2M none ./hugetlb-pool

Then run the reproducer on the mountpoint:

  # ./reproducer ./hugetlb-pool/test

Fix it by taking the reservation from spool if available.  In general,
avoid_reserve is IMHO more about "avoid vma resv map", not spool's.

I copied stable, however I have no intention for backporting if it's not a
clean cherry-pick, because private hugetlb mapping, and then fork() on top
is too rare to hit.

Link: https://lkml.kernel.org/r/20250107204002.2683356-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20250107204002.2683356-2-peterx@redhat.com
Fixes: d85f69b0b533 ("mm/hugetlb: alloc_huge_page handle areas hole punched by fallocate")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Karl Mehltretter: The upstream changes map directly to this stable tree's
  page-based HugeTLB API. The backport retains this stable tree's inline
  free-minus-reserved calculation and direct -ENOSPC return; the functional
  changes otherwise match upstream. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Tested against the current linux-5.15.y tip, 5.15.221:

- x86-64 QEMU, 2 MiB HugeTLB pages, at 1 and 4 vCPUs
- compared with the unpatched kernel, an extended version of the commit's
  fork/COW reproducer kept the child mapping alive during the parent write
  and changed HugePages_Rsvd after program cleanup from 5 to 4 and after
  unmount from 1 to 0
- parent/child data isolation passed and no kernel diagnostic was observed

 mm/hugetlb.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e0908e491065d..947610e37a33c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1144,8 +1144,7 @@ static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask,
 
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, int avoid_reserve,
-				long chg)
+				unsigned long address, long chg)
 {
 	struct page *page = NULL;
 	struct mempolicy *mpol;
@@ -1162,10 +1161,6 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 			h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
-	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
@@ -1179,7 +1174,7 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 	if (!page)
 		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
 
-	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
+	if (page && vma_has_reserves(vma, chg)) {
 		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
 	}
@@ -2775,17 +2770,6 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 			vma_end_reservation(h, vma, addr);
 			return ERR_PTR(-ENOSPC);
 		}
-
-		/*
-		 * Even though there was no reservation in the region/reserve
-		 * map, there could be reservations associated with the
-		 * subpool that can be used.  This would be indicated if the
-		 * return value of hugepage_subpool_get_pages() is zero.
-		 * However, if avoid_reserve is specified we still avoid even
-		 * the subpool reservations.
-		 */
-		if (avoid_reserve)
-			gbl_chg = 1;
 	}
 
 	/* If this allocation is not consuming a reservation, charge it now.
@@ -2808,7 +2792,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 * from the global free pool (global change).  gbl_chg == 0 indicates
 	 * a reservation exists for the allocation.
 	 */
-	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
+	page = dequeue_huge_page_vma(h, vma, addr, gbl_chg);
 	if (!page) {
 		spin_unlock_irq(&hugetlb_lock);
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
-- 
2.53.0

