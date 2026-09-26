Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01142C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 08:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B366B0088; Sat, 26 Sep 2026 04:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03086B008A; Sat, 26 Sep 2026 04:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4516B008C; Sat, 26 Sep 2026 04:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68E896B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:04:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2A5916087C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:04:57 +0000 (UTC)
X-FDA: 85255177434.07.8D5249A
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf10.hostedemail.com (Postfix) with ESMTP id F099BC0005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 08:04:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W84txjDY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790409895;
	b=08zwyPBUPVl4Ex1rfODXmovxZdLcRnbtjDOy8CrS1tHd0VhsB+iV++3yt/YZUA5mhNipun
	01gVd4phwd08J1iGEz7lw67HqMF4Pc6bF80ag3fJRSEOFvB2P0U78i9tugCFggBLvaaLFq
	icDSRksca+oGOtog8OIbbWpnA9piysc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W84txjDY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790409895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HZxt3zeKnEnrs8DVV8VtTUi6IgHEqmk5kCmbCMy8wo=;
	b=LPMQuEdJ8bxq1LRhF8ADDULZLiHAUMO0rLOK+qOutOIn7LyAMG8qFYhleuOyHHJGVLAht8
	fetxuJ10VIYEmgdTU1xHCXZLQUV+PNPY1DGnYGy8LPONGOZc25tO9UAeeaTFMe22LhGrVc
	jZ7IE/umuGJOYdLz/YGykRE9Y9Fz5L0=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccff31419so14194985e9.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790409894; x=1791014694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7HZxt3zeKnEnrs8DVV8VtTUi6IgHEqmk5kCmbCMy8wo=;
        b=W84txjDYfFEkbFsONaFfEv64QOwIFProrLbfAHqk4k+vctH4/MCri/StGoNET5J0Zi
         +Smk81APAPL5tcK+g7vwiO6SPOOaiA267vI8opAYGQTEHvvNJ3BXHyizBDpyiOIZOsuD
         lvVvwc+iJjDWXZYuykoHXtlRnKGOc6dFwSCJ81LJJmTuh2WKojy/8BfUTdbJabLhcn22
         Ikfrg2+kF+xv4ihi6op+svWNGRz2GYP/Us7ceJKR2CNNJZogvCirjBAC4OqyTA7WZn0u
         jGlMispBQRpsvOjMyOhvuhXNWzZR/MWMJsutiJMyip7Bd1iNF6whAolspd1R4/w2cgdm
         jRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790409894; x=1791014694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7HZxt3zeKnEnrs8DVV8VtTUi6IgHEqmk5kCmbCMy8wo=;
        b=WpONYpWbxab+RMUgWoWeiltWk15b7ftFMGOo0e1v+KCxCAikjAjApXQQHy7mAplt0s
         2yT/o8sScnQs6XG8CO1Y+uMLIZ5B76rhDxXsbTRdr01AT4E8GCVlPclvVGOnsKotNzKD
         j47gvpKWeci4pneCn/qIgY0+wVLzPrK5Gn0/AuJwtKajkLhbZX1v5D1HsPAIkQwhp/d3
         zFIqkLWMsS07UwfGS8H2adAHAm1PyTBsykx8Oz+HsbNTVueh3KelDHWMdVYFcuCBT9F2
         mgnTzU1XN/KkX8guvgEvKeBW5BzA4Zt8E4DerC8Z7Pu3hwa9THulCdnMO348aSO+rgGW
         4a4g==
X-Forwarded-Encrypted: i=1; AKwUvBxaEwf7AaAQ2lXhWv4zjayPySeMIsTJMqjU53Xcv6LlUDa3Dduh9SwmwnboZGsPCfR/QIIiSP3rmA==@kvack.org
X-Gm-Message-State: AFuF++nhGcBunEz75Y8hkbVGIF++gyQTMza3M2qZg7eUK+MHilGbiWm0
	38kvbx4e73ieqRsw0Tpl/WSAbzGijdvYQGR4ycsgiL6cNcN0dJP+G9Is
X-Gm-Gg: AYBFou19aM0Pc76cKqoubw+PHkrUU9HQR5WquctHvg63Af7MD/zKTv13IMwJgi1kHjV
	FsKpIIVfke1i1c1fjUGw9J45GYYhMt1qWEUBeP62qzxN4Ja62PRi1uDduASGG03jgP25q6pYJJp
	6MMA0fzQ1faVlXIpoJ7xG7x2qYkbBccyJD/AawN/V9gSmKSo5ITeVcQlpiYJk4snNh36vXN0H2M
	i73jYjF4l6tOgPucZN7UT324V/JA389Mb1gULf6vuWPTATkxWv2JBef+r1iDVv30vSrG8pZxFX6
	8tF2TaQjDb8M1NmYfDHvdXdKmCCK6Mtu5nTaGNl628mcAsw/y/HMUsJwOpuvJBxeMSa3/AGgKFB
	qYTGQPduXfKp2eSe+YAbhrHs/H2wNwT1BLpo7uUcq1OYwlxPb7KTZARXfYUIprJtBVGp2aCFwB6
	VkMzs0Ec8u0rKsletRqID4Vbx+00rBUGmTv7mPP3tNyQz1fDBVrZprVfP2nwuoDJnXNnphF1EkV
	PVQn8GM5JqBaVeMDp12/f4INYwLsLYOyBNeTuHaQEUCJg3FlQyNnjBOr5pSwbrfSFJvEAld+xnz
	p/1/uI3uV0eaRAxkn+X5BCbtCl0PQLhUW5BsYOm/HGOfF9MkbLx8jGCmOWvGcLxWZDzlfOzub4S
	a3W4szLNN+SZuqAOp6qJ74g==
X-Received: by 2002:a05:600d:644e:10b0:49f:e3d4:4c1f with SMTP id 5b1f17b1804b1-49fe7b62d1bmr99568365e9.8.1790409894114;
        Sat, 26 Sep 2026 01:04:54 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-b162-c701-4960-a998-3de8-2fce.310.pool.telefonica.de. [2a02:3100:b162:c701:4960:a998:3de8:2fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm326651415e9.12.2026.09.26.01.04.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 01:04:53 -0700 (PDT)
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
Subject: [PATCH 5.10.y] mm/hugetlb: fix avoid_reserve to allow taking folio from subpool
Date: Sat, 26 Sep 2026 10:04:49 +0200
Message-Id: <20260926080449.80322-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <2025021033-cupcake-spud-c04d@gregkh>
References: <2025021033-cupcake-spud-c04d@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: h5kjyi5c6oa6gb39t1utu1mi6heqiayq
X-Rspam-User: 
X-Rspamd-Queue-Id: F099BC0005
X-HE-Tag: 1790409895-382178
X-HE-Meta: U2FsdGVkX19KkhFiUHNA3AaHzE+gI/ks89v9ThaDTh8UI63zhYsmoszN2LffSGPj/LREm9Cb9FuVl3ONbfihX+K4CYoPWbvJekTv341DuqxineYGLMi/WCISgXTn4vG6cGVgOiQXPaoro37XAP7C1iEaPjhhEiLGaHRjukpFttuEsqTRkfmN7LI2gVQPOp9tJ5VaClRkXXwZMjH5hESUo7HY9q+FOZmSF9rIrLK5PtWnx2Jz+OQUL8nsrgoPwDj7A1gF9cZkOzsGoFpl2djzzdTd/wpDMlBjlh8nOqmviVFj5/sq1509BXA9rxCSlYW6fVZ99TPtnRz4IcbC7A2BPMMizt+TvIukORZvGT3Bl9I6MTRB99fdlzGcfpOjPLNXOKIT+1NWkgU8SzG3iIFD+7Fez6ICCJhZ2UyUP2yKQ3myA17I62WAIScFIZeJ/wlGYxjmlIeP31xZNVvjygTbPNada9GONafHR6/uPVKFCNJPunAknMnWp8nYCNrcmap1QveC5bDAre6mO6JmRp145CZOcHgtuH+e54t9vL38Vf54WATk1eI0vgaFuWn2KTlFXqXr4hKlGDpElj3XlVB+WeFU2zJ8UfcKy0tkTGPXCblNDybzvY8zoxztxHIEvz8OHztqoltr+2kreYH4O2KceJJzLT0+reIlz2L8QSpzWriYKEsdrEGMUIRqFC2HMb5sGBJ61oxbAlHNKMj/nGAt98qf96WDxoswqbGsiaW1kK6Lt64oeJPTEBhtmIeTnprlYgn5t911TWbMONr01eu/ry9ctxNr8LVnB870NjapOKKcm8VSk28rghMgHnfdHd8v/aAOncfI2P6eySLFltkYB+ZzHb3bCdTRT8oOG9CYpCH8sZq3SuIAXIWDIntwAFrJMLqP6/fgDqm6yUzG5ZQytH/fzuvx9cHVYrjXCGrXb3iRjW5skXwZpiSKYE0FhSyZN6cVtdH/vGP8HpQLLYz
 0jNcjlR2
 0o/ehAHsRdLrlyuURxNNE/e1l7vKViea8rw0jhw35hP8YR4oOaEn6B0hLV2AWw7JLAiCxom3QrTHs8j2VwuDfC+pukwjl3AoM7q9JZxUqgBDHHCpKAZjC9qxDNJ7O/302+dQFAHX7dUS+3QcpL2ugkEuI3HV3TazjD689jeWhfcxNAzN5DTW8uQH7na5jcVqAGntkq1w2UAW1CtFO9j2RlN0ap62+/sMP/eGPoCbtiEsPL5HBKaN7JTn70n4bf/15N7mVkLHBPI9beAe8n839N7oDGSsXK0ik6lYc1JmZQd1rw8T1KYlWHBZmC2wN8EOHcbWXzjxghhDkNAuB+CFzoKxg9E3Pk5pAOYv7BjPnD0oreI13ijGPXSkm+6kyedmOxj89SIC8Zr+KaujPzLXqrobOcUIN5Jhh1TDDVR0X0S2sHv+Ce1ymSqawd5OLYW5zXJB+7hE2TS+9eQvu3nNjEYu46fVqn4+NWQ64mQtk9AoX5GwodUZOFc0cbgjHR31YmiRF9xxq0/COlesXpzvxLqQzixx8PJzPz78gVzNYOM5FMapA0mTIc9iE4wdJX5ls8TXg8cxp/Co0XtidBHDLjYfrhY4eCoZYdRpzWGZmFHxiBrJrivSCoIa9Rp0o4G08/SMVgsPVIK9GrYGVjVgyOVou4JfXHwYrKzdfku1ElZamnNA97vHMV/c15ayHgILN4FuX+rNjdXhOpoMyDQXFKXnw/w==
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
  older page-based HugeTLB API. The backport retains this stable tree's
  SetPagePrivate() reserve marker, plain hugetlb_lock calls and direct
  -ENOSPC return; the functional changes otherwise match upstream. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Tested against the current linux-5.10.y tip, 5.10.270:

- x86-64 QEMU, 2 MiB HugeTLB pages, at 1 and 4 vCPUs
- compared with the unpatched kernel, an extended version of the commit's
  fork/COW reproducer kept the child mapping alive during the parent write
  and changed HugePages_Rsvd after program cleanup from 5 to 4 and after
  unmount from 1 to 0
- parent/child data isolation passed and no kernel diagnostic was observed

 mm/hugetlb.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 70fe6a11daba0..b23c8b2699b58 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1137,8 +1137,7 @@ static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask,
 
 static struct page *dequeue_huge_page_vma(struct hstate *h,
 				struct vm_area_struct *vma,
-				unsigned long address, int avoid_reserve,
-				long chg)
+				unsigned long address, long chg)
 {
 	struct page *page;
 	struct mempolicy *mpol;
@@ -1155,14 +1154,10 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 			h->free_huge_pages - h->resv_huge_pages == 0)
 		goto err;
 
-	/* If reserves cannot be used, ensure enough pages are in the pool */
-	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
-		goto err;
-
 	gfp_mask = htlb_alloc_mask(h);
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
-	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
+	if (page && vma_has_reserves(vma, chg)) {
 		SetPagePrivate(page);
 		h->resv_huge_pages--;
 	}
@@ -2350,17 +2345,6 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
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
@@ -2383,7 +2367,7 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 * from the global free pool (global change).  gbl_chg == 0 indicates
 	 * a reservation exists for the allocation.
 	 */
-	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, gbl_chg);
+	page = dequeue_huge_page_vma(h, vma, addr, gbl_chg);
 	if (!page) {
 		spin_unlock(&hugetlb_lock);
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
-- 
2.53.0

