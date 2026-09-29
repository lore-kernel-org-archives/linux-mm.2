Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5696CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752C46B0088; Tue, 29 Sep 2026 17:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703B46B008A; Tue, 29 Sep 2026 17:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F13D6B008C; Tue, 29 Sep 2026 17:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 323A56B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B29784063F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:14 +0000 (UTC)
X-FDA: 85268151108.10.D346B4C
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16D9440009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g7QZfmqS;
	spf=pass (imf27.hostedemail.com: domain of 3RzO8agoKCPopknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3RzO8agoKCPopknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CyTriPACuulD8PSeUOBZRvdda3vwGDvZO2NnK49TgBc=;
	b=n3COjRXIexTIzSJV9WDI67BKrHVZCmC/JLULMc/K2pn7Y08XUhkv/D1mdtYdajUjcIDRE9
	8Spd8igFoi0TRJFLx7QfTkhvOnt0O24QDYRJpjB5AAYWlVAU7yAh/UQU/M+qmuuskKvwrT
	rkYPqEAj/NdBbZ9SQFp4OrQhgUygBHY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g7QZfmqS;
	spf=pass (imf27.hostedemail.com: domain of 3RzO8agoKCPopknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3RzO8agoKCPopknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718793;
	b=FpQAKtwXGAJPdVyQpTwZkD+jCy4IFYrf6I5nhibt0JhYtv5gBFwGzirMFNCQkAIIipHE7q
	7r8jd0rfXLM2WU7N5Tf7I60DH5UFG9s6mMr4yu1SYpy6Mm5IrbzA6+Up5Kg7Poy/KKoykm
	p3kTsC151LIgjC5bocHWhsTczab1sDQ=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30f1b904861so6404721eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718792; x=1791323592; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CyTriPACuulD8PSeUOBZRvdda3vwGDvZO2NnK49TgBc=;
        b=g7QZfmqSMVWjaOXoy4oSxaMt97cfeMioixTgzshKnbkVihmqTg7s68RfofFwOoXjG8
         F8YzI+vIRuBqgKLkThvp1JqAHinafDxAoLvA2mLY1FDUbA2ShqW7MQDKcfLSyeanSxdy
         RMY05NOhwujM/XDVb5pjHoRmdI+475h2+tFnJKUg85cgwAkqDgocWyG1JDFUcWtMGBxS
         iKZUMJixGhPBywCk2r6IIeI0TvIwUuMy+0RmBCmFeXQL5aJ22/8c6xVX0prTte6GfTbG
         tA0okP53Su0JDZP7bcLbg0cCExFIb2yA6HuYvDIydJXFu4YoHjDqEAMpKpMEMvBnb36D
         MdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718792; x=1791323592;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CyTriPACuulD8PSeUOBZRvdda3vwGDvZO2NnK49TgBc=;
        b=EGAvg5YvGmRo9gTkE8aNqGA4G0scR6/nIVJStB5kZDFYYvay6Dfe39LTGBDTq0W4pQ
         +TowNCMPGypeOAEbnSbP+r+Bb0GY8bpPHWUpIpYCXuPhtCMEhkKdkyIThQKkh6/cls82
         phv8wc++9DT5XYGlsxQnpbPCEOarN1hmzSRuC2+6aeJn3UJHocUGqzL5cFT4WL2EholH
         xEePr3eCtFIEX+IqSlYx5h22is+RQLoYsAyI1l2gKbgS634xV8Eroa6fdDhjU3dmUQNI
         gDJzc1m46/1gq4TjZIRJHm0C1g7kZImu+SIW0s3rpijBqF/IZ/7PtiTKnXmhQ+bbDRei
         Hy6w==
X-Forwarded-Encrypted: i=1; AKwUvBwow21oG/Kj02E0X64OAqEjh85tZib/jMBNuzufhn8i79S6pHMwjHYJwd4gq+Iy6GGtnNv1E1uhcg==@kvack.org
X-Gm-Message-State: AFuF++moR0vsfOpuCboBP5+iUyNq151EETZ84x6MzvpKngVVstb6mOsL
	pgSRD4DkuAOUB151mwXelR4EQreFaxfSEvR2g3zExAoIJqwcX/asjR4EKVnSoZRUmp/HfSi87DN
	gtnSE7U0J1yLNi0J+W1Cj+Q==
X-Received: from dlbuu7.prod.google.com ([2002:a05:7022:7e87:b0:13f:c1b7:470])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:b889:b0:14a:c6cf:1449 with SMTP id a92af1059eb24-14c9dccf066mr568034c88.32.1790718791005;
 Tue, 29 Sep 2026 14:53:11 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-1-nilayvaish@google.com>
Subject: [PATCH 00/15] mm: eliminate &folio->page references in mm/
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16D9440009
X-Stat-Signature: nix7pdzospdmgkbk99u3iu15ycepbdrm
X-Rspam-User: 
X-HE-Tag: 1790718792-640643
X-HE-Meta: U2FsdGVkX1/yB2EqrxahVWSRmP0U3WUbERcXZl2IF4JM1iqVQdU4oh7kDqrf5rb0tFy2CQ8olzSNsudlD+l1RHWj7QeKkRPfVIvnbxCUI2CscrYOJX8JvCs13rs5tIMfGLGPlYDYR3cs8O0TTbe53Z6RUpU8DogvpKJXS2P/HKy5cFGqiJK9kbUoYQo+kjASBf7MJ6/SAwN4nfoXAB4DAWjaqWB28SHYxMtGSghm/0rgURo3LNs6DTdevvUcxXxiY5ombt5+p8BSRTtZVjtgxv+sx08yxMDfCc70wQYQyL8udiQGghF1HyIAc+ijK59tIxSkFDTKSqoiGYHYX9VLJe605WgAnQcf/YdFNq721GcqvufKImNSXb9iCuimwkkUAgS5FtIIgsN99BisWyt6OCxjU694j0ZWjpTz31S6zipvca7Pt94qs0XKo/jAhBNcygeyWDWXpamHiub/TMJmcLqxVVc8cEJWpTKi6MLSXdtRjfDbCf8A46eg1YMtKPP16Q7aNhnW3PsURecQDWZxIXwYDzF0P1EkapInYp+cvzwmSJFHmT0VmMM+LeYlw1AaQ4ne4CVvpvkdAAPKcMZcq9aydy/XurI4ChazjDfDTa7+hwYacus7sMtI1wXkjlFd/R1qzVsVvkArs03UuA17yn0cn8WR5gcrGL+2ZdxdarO1QouV4c9gaDEhL0ky9gOxpsuGo2rOBDsm3FERxyxxJeuYYRq4NeHyYK46Zbm11bR1L/s0yu8n9wEsGF8NP26AyeBKc+BiJrWuUJtITTdY40aogu/teuc50OJLll7xSj9cRxTwXXGulH3wSkvto967Z+aGhwQK7HteUlLXgoJUsQu41ZJBOc8+LNet3eZzQtBsQoMCM7LHrgzVxd/Aky+K/Tnl3nY65nAAeZ3mabeFsjblfHNKDlXcwXIJqExS11HUq6PSKC7iSk6IY4kKQsmKbc42DOct+BL+iI0iFcp
 e1m+JpQ6
 l2wDObnQUf8nJbXiuC0D/2kQe5+3SHYzWC58v4GVYyeltNIE+IQy+kAsx4AwVAowW09X2GLV4xFwkU3P5aT9oPBqyZ48xLRWX67fhkajXKOdzOc6+gYqs26wkHwC0Zieom5vsCvq4BNwZqtcJO4X+ufEPu7yQyiV4ZvSHS4EHkHsyUHqPq3s5skZJZT6UAdrGSeFtA+5S6pmdurX5CPyhdUSvQMIfZtrv5b+/Pi35ca0/Xm6RvjTLXrqQHr175HBjdCqUeKTD6ZX3q8EQL5x4iwyAL+O6jZ6ftgNwiNzA1rVpGExgcV5fg0T5WC9A+92hy8nNyygAwIcl5ZuJ5O+X++8WuhoBbfcVcbZ0p6dh5/8KP5jKuR6B4HtNhjMaHuxE4tOcb/kjsGs7DkU2oK8d4+uWZJ3zK7BUgY36c2J3wvfiPJ2jxnTVGgtJfNnT44TuSvGBmX0PWpInDjUs80i7TkjdnWQAV7zAlhTlbV7Rgqrv9rvDXgEjUBnEDNQKXjFF0ZYvAapkA94Inw41MBo3DnhdMpskBThlFh+4qvM1xpU/MOSkpiEVj0DX3MXEaYEd3IWbPD0Wm0qLNZSOkcZ7yqtNMbze2IhADtyk9Z64kQ2Xlm7foAplW2s5Q/HZ0POEycPnkKD3XrLnO1RtRBPnl8/JwauajOCSKoJMGxEzx8E5Nd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort to separate struct folio from struct page
and allocate struct folio dynamically [1], struct folio will no longer
embed a struct page member (folio->page), and the address of a struct
folio will no longer equal the address of its head struct page in
vmemmap.

This series eliminates all but one of the remaining &folio->page
references across mm/*.c (25 files) by converting them to:

- folio_page(folio, 0) (or folio_page(folio, i) where indexing a
  subpage) when passing a folio's head/subpage struct page * to
  page-based helpers (PageAnonExclusive, SetPageAnonExclusive,
  rmap/split helpers, movable_ops helpers, HugeTLB Vmemmap Optimization
  (HVO) address calculations, page_ext, alloc_tag, etc.);
- VM_BUG_ON_FOLIO(..., old_folio) in place of
  VM_BUG_ON_PAGE(..., &old_folio->page) in hugetlb_wp(), and
  folio_set_hwpoison(folio) in place of SetPageHWPoison(&folio->page) in
  mf_generic_kill_procs();
- ERR_CAST(folio) in place of returning &folio->page on IS_ERR(folio)
  paths in do_read_cache_page() and shmem_read_mapping_page_gfp();
- Operating on struct page * directly in compaction_alloc_noprof()
  before calling page_rmappable_folio(), and adding &page->lru to
  cc->freepages[order] in compaction_free().

The remaining folio->page uses in mm/debug.c (__dump_folio(), which has
three lines: page_has_type(&folio->page) and two reads of
folio->page.page_type) are intentionally left untouched because
__dump_folio() operates on a stack snapshot (&ps.folio_snapshot) rather
than a live struct folio.  Those are the only folio->page uses left in
mm/*.c after this series.

This series is based on the mm-unstable branch of Andrew Morton's mm
tree.  It has been build- and boot-tested on x86_64 under KVM with
CONFIG_TRANSPARENT_HUGEPAGE, CONFIG_HUGETLBFS,
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, CONFIG_CMA, CONFIG_KSM,
CONFIG_USERFAULTFD, CONFIG_MEMORY_FAILURE, CONFIG_PAGE_OWNER,
CONFIG_MEM_ALLOC_PROFILING, and CONFIG_DEBUG_VM enabled.

No functional change is intended while struct folio overlays struct
page.

[1] https://kernelnewbies.org/MatthewWilcox/Memdescs

Nilay Vaish (15):
  mm/khugepaged: drop redundant page parameter from set_huge_pmd()
  mm/huge_memory: use folio_page() in PMD/PUD rmap, zap, and migration
  mm/huge_memory: use folio_page() in THP split paths
  mm/hugetlb_vmemmap: use folio_page() for vmemmap address arithmetic
  mm/hugetlb_cma: use folio_page() in hugetlb_cma_free_frozen_folio()
  mm/hugetlb: replace &folio->page with folio_page() and
    VM_BUG_ON_FOLIO()
  mm/page_isolation: use folio_page() in page_is_unmovable()
  mm/compaction: stop casting free pages to struct folio
  mm/migrate, vmscan: use folio_page() for movable_ops helpers
  mm/memory: use folio_page() in fault and CoW paths
  mm/rmap, gup: use folio_page() for PageAnonExclusive and
    gup_must_unshare
  mm/ksm, userfaultfd: replace &folio->page with folio_page()
  mm/page_alloc, folio: use folio_page() when freeing folios
  mm/page_owner, alloc_tag: use folio_page() for page_ext and codetag
  mm: replace remaining &folio->page uses with folio_page() and helpers

 mm/alloc_tag.c       | 10 +++++-----
 mm/compaction.c      | 15 ++++++---------
 mm/filemap.c         |  6 +++---
 mm/folio.c           |  2 +-
 mm/gup.c             | 11 +++++++----
 mm/gup_test.c        |  6 ++++--
 mm/huge_memory.c     | 37 ++++++++++++++++++++-----------------
 mm/hugetlb.c         | 21 +++++++++++----------
 mm/hugetlb_cma.c     |  3 ++-
 mm/hugetlb_vmemmap.c | 10 +++++-----
 mm/hwpoison-inject.c |  2 +-
 mm/khugepaged.c      |  6 +++---
 mm/ksm.c             | 16 ++++++++++------
 mm/memory-failure.c  |  8 ++++----
 mm/memory.c          | 16 +++++++++-------
 mm/memory_hotplug.c  |  2 +-
 mm/memremap.c        |  2 +-
 mm/migrate.c         | 20 +++++++++++---------
 mm/page_alloc.c      | 18 ++++++++++--------
 mm/page_isolation.c  |  2 +-
 mm/page_owner.c      | 15 +++++++++------
 mm/rmap.c            | 10 +++++-----
 mm/shmem.c           |  2 +-
 mm/userfaultfd.c     | 14 ++++++++------
 mm/vmscan.c          |  2 +-
 25 files changed, 139 insertions(+), 117 deletions(-)


base-commit: 90ddfbd1963659ca4a5d3d7f20717a4222682a8e
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


