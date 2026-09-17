Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47533C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1209A6B008A; Thu, 17 Sep 2026 04:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1DF6B008C; Thu, 17 Sep 2026 04:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03936B0092; Thu, 17 Sep 2026 04:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B28646B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:37:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 235A51A029F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:37:56 +0000 (UTC)
X-FDA: 85222601352.24.B1956A3
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6A6A4100002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:37:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=svEpF0dn;
	spf=pass (imf14.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789634274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qjS555jszAWDoLRuNovKzuqNE3Rj5zKbnspdsPHPVgE=;
	b=gLmbTBAJg1O9KkJFcc1eEntRjWsiuJLLn71NSV99eZcVPiSyLV3Q4/oG/xNZ+sWoq+3l0R
	GnXy/4AHBpIhWbUpGMDZcFlf18AIqHR5yfyRHySswxvQVfauEsgK48M1/nP/D8rrbCsMzg
	2pdm3wRQTOKO1WYtWKBrsVuMXJmjhdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789634274;
	b=Aa0IMLjHTeYxS0+B5vkne+bUsVkRafTG1mKu0hSgOvtMsmErFcGNMRmaFzw4XXMHIIjw7o
	pooPD/8WIZZFb32gIrjQlSsYENdLpygT6zvpD1HoiwJ4E4fGsu5mR8vtyEXhZEYhH55+Pt
	u6QiE11J6Pims9wnAC2babLhJBdx7qA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=svEpF0dn;
	spf=pass (imf14.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-398beb616f5so193479a91.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789634273; x=1790239073; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qjS555jszAWDoLRuNovKzuqNE3Rj5zKbnspdsPHPVgE=;
        b=svEpF0dnPco7RimAabny4RWRVIv3WRx0lcy8pJkj2uAlGxM6Y0dsbhzJgm5Uu8rJtG
         ERzsNPpjoChP+H5aOnXVrDzVJ1RUon5fRSMr+QTsN4FXYvDfl5u/4r1EA66+EXRauA4U
         QQKlsMCGIv7wK9Ck/lfdkwKQo993X4VCB0OPMR0vn7TNLu9B31TcV70E6fnD2tROF9WP
         MqDkgxXr2Y/bIwMBtKO/XhUrtC87eWveCPhUX7CfrmyIwj7GeTzvKukBMT7TCMTqDlzW
         lHuFq2DlyFLKPXfBVIZiHaZTIObOFgBk3WGtxhpeKldUb+NYtct7eYPbkfXVIB/fkDqh
         /RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789634273; x=1790239073;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qjS555jszAWDoLRuNovKzuqNE3Rj5zKbnspdsPHPVgE=;
        b=N1Z5laFkhWDYbz+hZ9IG43iHmucMJ9JCkGQYkvxgEkFBJ8FQuvVRGoeCEBH28npEY4
         dtZ2njgeKTYuD26qbsvXLvkCG02Uo9uPhB+Tu2EljhsqEREazOprJeSANkacBQvvZOgD
         auZAZU7/2EXR/heqrOjfU/BNgoESx2XNwEFWW89yZxUFPiWkF0jR8vlrMZoILrjL7o2J
         m6f3O336YrXbbMJXJU80gGiFbDrEiHMy/6woJjWV1NKrRYeAfuBm3EYSk0VlR6KzCvSC
         xmfHKdfoz6NvW8ZUMSpuSrH7WuiaYk7td3kbl3g8hNZctHclakodjXT1KXKYXY6uFxFA
         jILg==
X-Forwarded-Encrypted: i=1; AKwUvBwKDQuCzz+A8/Czbx81xpoYq8EsSEehQAASb55TPizpJzMmzthod+TkxOBvonJxK76Qf5j5gBpNcw==@kvack.org
X-Gm-Message-State: AFuF++mfd1KMcJTysIti0cXBpMKnNCCL6aTB0PvDdXzV/fLxPprB9Ho8
	y7hwhRa1us69+7vruF2Y0Up3bzC05Sh/UaDUhi0vv1ZqEHKXL/HVzcZS
X-Gm-Gg: AYBFou0GpEd81R52hB4JixwwFdScYZeAQfvvWPQ3Oq1K75N1OZxV9uCQWPRbc+C6EmC
	dDEt1fyZLxaVV5hMe2crN1sY3xHLa4kBFZ8pNske0ELTja/OKhGBxAuUharaoFmhdcISe5WPt90
	U9EhAVJwZtZO/6zu+dgd9wzNKNVmB/2v5BzbWTV3f8F8DmySamalAFQYbvqgySLyhr20VMPDGHp
	+YZVXlF7hbz8e+g+654evCnhaiFhIqTu/JhGpcmveR29JoXyXEtl0BOGNiymcYO6gMZ+D2k5HFi
	wC0rYn8eYmaFxmoPtYUzMY6twUc4OLAlByXJ7VilLsWYcp01WkfL4UzoN8vouTtmCyfOdZoe994
	xCjfc6XAVMGkLaL/HpqjI0OdnvaYepzr9waGTFyKfH9qMyOvrM/wM3saop6WoBTcpi29whARpmT
	eaMwglYjKTm/BkYlkZhaEFkfj6kkAZXyDDCVlbo+Ahf+Opgthi95ZhAAsbVwzI/c/j7HuUpYZEu
	e2xiT9DxF5E2qIOlP2PbShXVTWL7KXrIWu22sIDDUImMR5qChxpI6m31qlTGrmmGFwGfqRZe0GZ
	HA4qxAqEBE0PMFkfaqRVmEHrMg==
X-Received: by 2002:a17:90b:3dd0:b0:39e:28db:b950 with SMTP id 98e67ed59e1d1-39e361aa313mr3835618a91.16.1789634273012;
        Thu, 17 Sep 2026 01:37:53 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-230-153.dynamic-ip.hinet.net. [36.232.230.153])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e362e9402sm3846928a91.15.2026.09.17.01.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 01:37:52 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Aristeu Rozanski <aris@ruivo.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/gup: batch PTE-mapped large folios in gup_fast_pte_range()
Date: Thu, 17 Sep 2026 16:37:47 +0800
Message-ID: <20260917083747.786-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A6A4100002
X-Stat-Signature: rzhs37377ouui6xin49bypmf8hdea8yr
X-Rspam-User: 
X-HE-Tag: 1789634274-603866
X-HE-Meta: U2FsdGVkX1/wWNhT9Vws32+DLVKyxJK+S+1Xna+pdLvn7hf+aFqgALh/GbMTU1kh12pFMMbKEXwOh9NHxT96xXbGSe3CHf6uo4cwjkxQuS+mer+RKlkMGwRbp1iqj8uiyWaqstKBXn54Ud/WVvfDFiAgL134F6F8kdwpk9F0VTdjrXeotSspGpQk2As74YDhQDsQM/u7iFvQ1hTtOmuP9BqlH4N9YEd0DZeiemO6qIjnkyUrayJQd9o41NeLmjPvziKNEhki7OX9JiaL426qticaS/Do06jXbWKONSVNwW584ni2DR5lHrfTgrBjoIcyUl+nuycPYjY3v38mVY65JkVIHVegCIwismouCrSmpR1/77ZpSetbSkGVlq8w73GVWtY5WVbbhUtKYh5GcQvQioCIlIAzWQk+zW0NWfGshWCc/zZr40V/WLncOAElimWrjE6tYNt9WuIufDkiBwQ5v+KTrmM6oetAJEmwsDESw0euZ72XFM1GksJ+wdHklo8E9XuixEdZpBlMyUrXBfHIChv5iHSjjLAiQvWHVPjF2ynvSrrNy+GkHb6vxgbjqAnx+vss6rBjZ4SuAO/0wLaYcJcGODas6Mdy1v28qsfJYMNUShvQISYiQifkx3AW6ZwHOI+AWgGrENamz2NkRyU36Ra7/r4gClL1UQS5kojlJn40huAte7kSJmxqwLE8BuRJyuhzYXAxRiNOvtF9fiiIoXVTe8gxbZUYrqJrIS7u2Q7/pxNFQEs4AMGiYmikEMmuu/bZ1QLVyQYGy4bRl/70MwTz+1DpuRYviGN2M1fkQCA2Q+n7nIgfwXB2woC7NrbEkhqVPPE2U8sJQFIIZfm/g4BZKHmqHPU4ep95+sIWMA2YARSaTApjd5d3hZO28Ikr6iwNAFQ4zWbPzc+XFjHo/NtkxwnzERTtTe5TiWLK++OYmUBp9yYFm81yn4+vki6jfwnc9zeHDR4OOetWGAQ
 cFhGKoGz
 Ng1c5R/VFWOgdlfXvWSolxe0Dt4XS0h+Vc9bYZkotkbJ3P53rrke7JFGok/lyFCQc/NfLnJg/6xmwRl4amBiropdRINCiEI3NeHh2U1qpX4YR6IQWf6RbBClpsA2sT/kRrSgn29hckB3XAjIfDvVSE0197O5u0TbuG7CzJ+AgmbaJQNKzHRrjoRs4AuPfPhaCOED0D07PWem5w5JH6PJoEGHzGiMZx2hkuTqRKKMLHgQslsr3AZOZ9YdP3ccSCnHDlI0wb03Bk15q/6p4lcswXhPAUPn2B9JQJ1/d/7AYCBc5bHOrsLiGxjNd0IAkyGN+k1+oFrSL1YiVHQ04ygDDVG2p8eWFaAvH0vKZvFcHYc44EfQOF4giCDJ+YZz233abfatuxu8LmiIobUNiISJmHbJ01BbMTTc8Iqws5A+ozpO2EUSAQ9t3s1x4WMdWFTFzJYX1EZcG81KfQ8D/7bptyp1VHtlETrWN2v4krvSDgQ8Ms6QetPG5MVO49SdVPjM8mr/Y2Cbw8SU+ieeMHB67R0nPysd4NXnIg+MR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
atomic, a full barrier and a node stat update for FOLL_PIN), a
gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
pays sixteen of each and a PTE-mapped 2 MB THP pays 512.  The PMD and
PUD leaf paths already take the whole range with one
try_grab_folio_fast() call, and the slow path is getting the same
treatment for PTEs in Rik's follow_page_mask() series.

The users are the hot ones: iov_iter_extract_user_pages() pins every
O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
buffers through it, and so does RDMA memory registration.  With mTHP
those buffers are PTE-mapped large folios.

After the head page has been grabbed and verified as before, extend the
run to the following PTEs that map the next pages of the same folio
with the same protection bits, take the remaining references for the
run with try_grab_folio(), and fill pages[] from the run.  The PTEs of
the run are read while the reference on the folio is held, so the folio
can neither be freed nor split underneath the scan; a THP collapse can
still detach the page table, so the pmd is checked again after the run
is grabbed and the run is dropped if it changed, leaving the next
iteration to hit the existing pmd check and bail out.  A read-only run
of an anonymous folio stops at the first page that gup_must_unshare()
rejects, so the per-page exclusivity guarantee for FOLL_PIN is kept.

folio_pte_batch_flags() does the scan.  It reads the entries with
ptep_get(), which is not safe without the page table lock on
CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
site, so the other callers do not change.

The order-0 path keeps its instruction sequence.  The folio flags are
tested before folio_set_referenced() on purpose: a load of the flags
right after that locked instruction cost about 25% on order-0 pages in
the gup_test benchmark below, and reading them first brings that path
back to the baseline.

gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
per call, median of 15 runs, two baseline boots / one patched boot, on
an x86-64 VM:

                       get_user_pages_fast()   pin_user_pages_fast()
                       before       after      before       after
  4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
  64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
  1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
  2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
  2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us

fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
buffer in 64 kB mTHP, median of 15 five-second runs:

  bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
  bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
  bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s

IORING_REGISTER_BUFFERS of 1 GB, median of 15:

  64 kB mTHP           6179/5998 us  ->  1599 us
  1 MB mTHP            5790/5801 us  ->   893 us
  4 kB pages           7173/6741 us  ->  6763 us

Link: https://lore.kernel.org/r/20260811025157.1632867-1-riel@surriel.com/
Assisted-by: LLM sparse
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
---
 mm/gup.c      | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/internal.h | 15 +++++++++-
 2 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index eb898ea1ee22..1b4bbb525609 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2807,6 +2807,64 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
 }
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
+/*
+ * Extend the run of pages grabbed by gup_fast_pte_range() from @page, mapped
+ * by the PTE at @ptep, to the following PTEs that map the next pages of
+ * @folio with the same protection.  The caller holds one reference for @page
+ * and has verified @pte against the page table; this takes the references
+ * for the rest of the run and stores its pages in @pages.  Returns the
+ * number of pages in the run, including @page.
+ */
+static unsigned int gup_fast_pte_batch(struct folio *folio,
+		struct page *page, pmd_t pmd, pmd_t *pmdp, pte_t *ptep,
+		pte_t pte, unsigned int flags, unsigned int max_nr,
+		struct page **pages)
+{
+	unsigned int nr, i;
+
+	if (max_nr == 1)
+		return 1;
+
+	/*
+	 * The reference on @folio keeps folio_nr_pages() stable.  The PTEs
+	 * are read without the PTL, hence FPB_LOCKLESS.
+	 */
+	nr = folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr,
+				   FPB_RESPECT_WRITE | FPB_LOCKLESS);
+
+	/*
+	 * gup_must_unshare() is per page: a read-only run of an anonymous
+	 * folio ends at the first page that is not exclusive.
+	 */
+	if (!pte_write(pte)) {
+		for (i = 1; i < nr; i++) {
+			if (gup_must_unshare(NULL, flags, page + i))
+				break;
+		}
+		nr = i;
+	}
+	if (nr == 1)
+		return 1;
+
+	if (try_grab_folio(folio, nr - 1, flags))
+		return 1;
+
+	/*
+	 * The PTEs were read after the reference on @folio was taken, so the
+	 * pages cannot have been freed, but the page table could have been
+	 * detached by a THP collapse meanwhile, leaving stale PTEs.  Drop the
+	 * run and let the next iteration hit the pmd check and bail out.
+	 */
+	if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp)))) {
+		gup_put_folio(folio, nr - 1, flags);
+		return 1;
+	}
+
+	for (i = 1; i < nr; i++)
+		*pages++ = page + i;
+	return nr;
+}
+
 /*
  * GUP-fast relies on pte change detection to avoid concurrent pgtable
  * operations.
@@ -2830,6 +2888,8 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 		unsigned long end, unsigned int flags, struct page **pages,
 		int *nr)
 {
+	unsigned int nr_batch;
+	bool large;
 	int ret = 0;
 	pte_t *ptep, *ptem;
 
@@ -2891,9 +2951,25 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
+		/*
+		 * Read the folio flags before the atomic in
+		 * folio_set_referenced(); a load right after it has to wait for
+		 * it, which is measurable on the order-0 path.
+		 */
+		large = folio_test_large(folio);
 		folio_set_referenced(folio);
 		pages[*nr] = page;
 		(*nr)++;
+
+		if (likely(!large))
+			continue;
+
+		nr_batch = gup_fast_pte_batch(folio, page, pmd, pmdp, ptep, pte,
+					      flags, (end - addr) >> PAGE_SHIFT,
+					      pages + *nr);
+		*nr += nr_batch - 1;
+		ptep += nr_batch - 1;
+		addr += (nr_batch - 1) * PAGE_SIZE;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 
 	ret = 1;
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..783754a81960 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -368,6 +368,12 @@ typedef int __bitwise fpb_t;
  */
 #define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
 
+/*
+ * Read the page table entries with ptep_get_lockless(): the caller does not
+ * hold the page table lock (GUP-fast).
+ */
+#define FPB_LOCKLESS			((__force fpb_t)BIT(5))
+
 static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
 {
 	if (!(flags & FPB_RESPECT_DIRTY))
@@ -400,6 +406,10 @@ static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
  * must be limited by the caller so scanning cannot exceed a single VMA and
  * a single page table.
  *
+ * The caller must hold the page table lock, unless FPB_LOCKLESS is set: then
+ * the entries are read with ptep_get_lockless() and the caller has to make
+ * sure the folio cannot be freed or split, as GUP-fast does.
+ *
  * Depending on the FPB_MERGE_* flags, the pte stored at @ptentp will
  * be updated: it's crucial that a pointer to a COPY of the first
  * page table entry, obtained through ptep_get(), is provided as @ptentp.
@@ -436,7 +446,10 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 	ptep = ptep + nr;
 
 	while (nr < max_nr) {
-		pte = ptep_get(ptep);
+		if (flags & FPB_LOCKLESS)
+			pte = ptep_get_lockless(ptep);
+		else
+			pte = ptep_get(ptep);
 
 		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;

base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
-- 
2.43.0


