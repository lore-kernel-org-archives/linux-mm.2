Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9950FC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EBE6B0096; Mon, 10 Aug 2026 22:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06466B0098; Mon, 10 Aug 2026 22:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D976B0099; Mon, 10 Aug 2026 22:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9E7D6B0096
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:53:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D05C120344
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:53:28 +0000 (UTC)
X-FDA: 85087467696.10.8C2829A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id BAB9B40003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:53:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=DVcvSo+4;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786416806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LGXcCPY7kG2CVFlPckufNlkx0xRe8qRFiK0PwEOL4G4=;
	b=OvRA0v3eF8TduwRPDYdn4cmZmaApjuQXHOmZlvrdgP3t0aymkLWa+mYlkAd4eX3nwCltuF
	fhRC0nfscrotBWRfrlSftIUa5iEbSz+a6O/vcCOATN4/OQY1n169f1BaEOscvQ3aV7DlrX
	lwLJKIjCG7tMhv24uoudPIrRjJzfdEU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=DVcvSo+4;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786416806;
	b=CjQPuIEDty4Jb5/SKTQpdG+Pw9pRqhiIdsvII4A5E4q+HBVgAF4rD/rN0yS1PWzQ2P0fXU
	bDJueSNa5AX4zdHLzfsyFOKyoRbVak1KzUrLiA7Gd4Y+X4BjmmRpz7PuSrSLYbfBm3Mdh0
	6SVjf7XeaRz1Jf7uS4BMDbB36EhLqtQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LGXcCPY7kG2CVFlPckufNlkx0xRe8qRFiK0PwEOL4G4=; b=DVcvSo+4a22PxOsL4f2RdSb5p+
	PXzLlheA1AKKk5NvLrHrl+lgRhdkPTM/bSTa3WM1eD/W/vA5PXBYNKSz4sho7mUcLsMnI03RxWBPV
	iCFJ5QiutVi7UsF/T91Lgc1OiX8+jOj5domYrTkhGkw7c0i7zjP9d/dEtj5y5Wsb9RyVBt/6KpCBo
	Q4wkBHy6vs58emxRVJ2A+aCBeAVxZC0RTFwAaaAURjtfICLemOqrvMmKkMiOc8seIgWeo+izo6PJa
	9D5BLli/svS2BXr0zxuByLCbwVNGgPmoW3CI/8hsc+PpXEeD7QtZUAwpMTcyBV71VYccbElfF24xQ
	GVgNVN2Q==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-2Cpo;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
Date: Mon, 10 Aug 2026 22:51:49 -0400
Message-ID: <20260811025157.1632867-1-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BAB9B40003
X-Stat-Signature: 9xgdsfxhyjz4q7nop811hqn7n8ph6qnh
X-Rspam-User: 
X-HE-Tag: 1786416806-919862
X-HE-Meta: U2FsdGVkX19gjWJBJaRRCsHHQ/cWkjk9SboCHSuEQoQnoI0pwo5i+AoHMlSHwaFcIEY6gLxreJR2ktlKAZmc4nU88BFa5HBBrKl5eMt8jKPYT7VcIPDE5NK0h3yGNorSmpu+JE4ZfOHKgq9OkBy4uHBLu85PAWaOoje/E3uK+VxK9X3C9wORq05wTEvXWrx+UCqr0a4U4ncllbJbeqcWHP3N22yyG4BgYvjPIUEhcDJeLzGXG4t2ODvmauzSSkTHqAEYLcg2NVDt8bapIYqVFaK5fiCGO6ILlN1R4UIyTRdWmeFF6brqwHwBmVhIp81OswV1RBKuK55y03OWNYYSO3xwK0Ry+jmX74buEklL0p0yWspVNHzIltWgBAi0Epz2PFNp3LYpcvlU6MhXW1CiTH8/JDAiIavdjWcWAmOoWPuYybB7wHgiSZiyIwWIzoaXbcZUPNINr1iQLdJl4YK7FsX0uCE93snf6+vzGYW27ZJNFkPLVhz2+WMfI4tSDFdhszrZuwjaDqkAaB/3vV8kwl6Hk7ylRn1l41u2oZMGp2KfdnEkg2kU83xUokOc8+m5Y98U5KAtpuzvFWbEbQVjTi2bldmtVA2veT1+aKy+8a5CxWwBU8yRJS6eVEGAqHcMaZhNc/ih8EBPlI7CMOMTY4D2P/iZNBaVkwC+n1H3WcnM7Iyb7xxKQjt0r60O0u+WbldXEMLGhemz/tum6KsW3I6igEDvYf1qBpNcrh70Jp2bZl4ZX5GHnRQahhHLIkttb+cEhFPFXxbX9p5TVt1r21+YfWSZ3VpqqbAxsgklk7loLIcR3MPMWfVEWW1ol3JlITteC9F1EFRKbRiHwSRD1u/S0Ss9vP+9ZgSIf/Vc42A2SCFuYVhOTv6iRSBJxGPqnVy2fuSt+lXdi11Os5Na+p9HMvkyHPcJSXpZSUdHXGh769yaSoiBftL/XQudyHA6P9dAzitODMbXV4BzKGP
 Jiv8k9lX
 9qY1ZKK4ar2l+7vbLe9tCdTcPmS5LOOrIhjF9fYxyXaidwCQuOOrkq/pG2nu9TBE7mT3PUVvM1gqqo1e0m2+JxY10fxiXBycTiCrkZxC1X74J9eDOg0F7Ty1eCU0bc3e+JgtodYtB6Kk4OHlnU/fGJvnkZ21rjuxMT5gNnUe1elsWjjieZFlVt+GB0Gz3Uje4796/C9iUZ/bWMNDdMKYoBGLCeE5aevmNbANprNgQO5BvJmw6mUo5NUieQdX5/3Z15Xu0UuY9AbSvgj78DRtJN175PKAmrXrK3LU+sMlte+SJacOUCbvQkn2xjOGc/Ljvri4x+X+Mm+eSR5vzL58QrBKTZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() walks the page tables one page at a time, even when the
caller asked for a whole run of contiguous pages. Every page of a large folio
re-enters the pmd/pud/pte walk and re-takes the page table lock.

This series changes follow_page_mask() to return a page count and a fill an
array of pages, instead of a single struct page, so a walker can hand back
more than one page per call.

Patches 1 to 4 are preparation, no functional change:

  1: move __get_user_pages()'s open-coded pages[] fill and cache flush into a
     gup_fill_pages() helper, which the rest of the series reuses.
  2: convert the follow_page_mask()/follow_p4d_mask()/follow_pud_mask()/
     follow_pmd_mask()/follow_page_pte() call chain to return a long instead of
     a struct page pointer or ERR_PTR(). Every path still handles one page.
  3: split the "commit to a resolved page" tail of follow_page_pte() into
     follow_page_pte_commit().
  4: split the "work out which page this PTE maps" half of follow_page_pte()
     into follow_one_pte(), leaving one unlock and one exit.

Patch 5 has the huge page paths store the page and leave the array fill to
follow_pud_mask()/follow_pmd_mask() after they unlock, so the cache flushes
happen outside the pud/pmd critical section.

Patch 6 has follow_huge_pud()/follow_huge_pmd() report the huge page's real
subpage count instead of a separate *page_mask output, and retires *page_mask
and __get_user_pages()'s try_grab_folio() call and subpage loop.

Patch 7 walks every PTE in a page table in one follow_page_pte() call instead
of one per page.

Patch 8 adds follow_pte_batch() so a contiguous same-folio run is committed
with one refcount grab. This is the only patch whose benefit depends on folio
size; patch 7 alone covers plain base pages.

Patches 7 and 8 carry their own benchmark tables, both measured against the
base of the series, so the split between the two mechanisms is visible: the
single-call walk is worth 2.3x on base pages and 2.2x on 64 kB mTHP, and
refcount batching adds a further 5.9x on the mTHP case.

v3:
 - split up the series into 8 much smaller patches (David & Lorenzo)
 - shorten changelogs where they were too long (Lorenzo)
 - fix FOLL_WRITE folio dirtying by gathering dirty bits from all PTEs

Link: https://lore.kernel.org/r/20260730035350.1fc95dd8@fangorn/ [RFC]
Link: https://lore.kernel.org/r/20260801031540.2742891-1-riel@surriel.com/ [RFC v2]
Suggested-by: David Hildenbrand <david@kernel.org>

Rik van Riel (8):
  mm/gup: break out gup_fill_pages() helper
  mm/gup: convert follow_page_mask() to return a long
  mm/gup: split follow_page_pte_commit() out of follow_page_pte()
  mm/gup: break out follow_one_pte() helper
  mm/gup: fill the pages array outside the pud/pmd lock
  mm/gup: return a huge page's full count from follow_page_mask()
  mm/gup: walk multiple PTEs per follow_page_pte() call
  mm/gup: batch contiguous same-folio PTEs into one refcount grab

 mm/gup.c | 515 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 308 insertions(+), 207 deletions(-)

-- 
2.55.0

