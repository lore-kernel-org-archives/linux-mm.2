Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6791B60A3829
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TAi9VsZ0
Received: by kanga.kvack.org (Postfix)
	id 7AA086B05B3; Tue, 10 Nov 2026 00:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A5B6B05B4; Tue, 10 Nov 2026 00:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649926B05B5; Tue, 10 Nov 2026 00:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE266B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:33:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE414160880
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:37 +0000 (UTC)
X-FDA: 85418092074.02.A7F6CE0
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id 219AB20002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:33:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TAi9VsZ0;
	spf=pass (imf03.hostedemail.com: domain of 3rqzyaggKCDEWVNdVlNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jiaqiyan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3rqzyaggKCDEWVNdVlNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794288816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/D/X2RWqUWZEGqY5FvfeCmXbQ5GVi1wSyRCE6T+SpWY=;
	b=e6Yo96yO1NrT9Gpp3XOdUE1a/+W0LpE7oTlowVCAwnNtatcNgPvY578k3TsbqOfdJRvJcq
	L1/onNYpSV84f/iSJj2VE/5/kHz/DzfZRh1Unt7nyGmsKeRlMBbMd1hXBdzwKdW0jvjvpy
	XuKop7YX2FXBl8c3ar6rtjcWVo+8T8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794288816;
	b=0dqeA3b3JSqtpKQxUQ+rAHms6Z/7fPTdsgsHjecm8KFpXRz875msnwvC8Vh0wxQ6+nLsMC
	KstS8MDKJYuy07IawTtZibZ9at6VeXGQmjGBHIqMZiXOQ7IrIAXuIfdQuXHStPkAw36jX6
	lo3LRqK8SFYxNLSIzIyUmERdIrtFMrA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TAi9VsZ0;
	spf=pass (imf03.hostedemail.com: domain of 3rqzyaggKCDEWVNdVlNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jiaqiyan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3rqzyaggKCDEWVNdVlNaTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ed05900df7so15880945ad.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794288815; x=1794893615; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/D/X2RWqUWZEGqY5FvfeCmXbQ5GVi1wSyRCE6T+SpWY=;
        b=TAi9VsZ0E2aoaImrzjK8fT19TYvPFSlIc/+gzGOL2UF3dXuzOQFDs9rY6bIwh+7QK4
         qc8TYk7dgg8HE4QFG59aKh5n2mWuOCOYxopoRZMxdIPkgCUJqutiVpAu0mOrdZscoH8g
         Sw0583b5NXt7a9U3dMsH+19zgAjrMAhbVqlbtBvj52A/Lw1lpaGyUuj7dd1ZS2dQQMCA
         OUoc6YzYvBe3l1D3MVaQOJ8+bQewDDCN8SBoMw0mD7aJuoklEk12UssQP69FTXbm1SfN
         6fPk4JUkktEyoOQLkSu/5lg4Xxm3+OJCJ23fCXTgbd8ss5KtsUSNPjR0eGnyh4mWQYh3
         FU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794288815; x=1794893615;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/D/X2RWqUWZEGqY5FvfeCmXbQ5GVi1wSyRCE6T+SpWY=;
        b=n7EyEhTcSZ3tWkWTjexFDip2a7+MJjlUvUjP4P16IlNVXsS1IfYmFas9c6dH95/29U
         OJvVyU3f7YNeHy7cmuyXFo8/RNlM53buDqhdgUtK8qa8eUuFEAod5mC4Req7DZwn3Pil
         RViqJgEG1WZeXqzAeHVvPYCRPG9faDwqIS15H3wf/55BUgixhLZkpzOHkR3u8+JEYCrS
         wOHQwMh0xhTFFIKKFuNiEY9puYXijl/LwSS08Ps5ILhPb0rkciUX2rre26jn7SVhsvu2
         p4m2Feg56yrrQuoH7jtOrHnI3oTtrhS6eQtNL0HIR2WnhSnNBqg4+JJGBu2AW/Ys30iE
         yM3A==
X-Forwarded-Encrypted: i=1; AL+hErFYxc9lmXCDCIwiHyw51Bm//7fzbAZvMq34Fz9tq5GYwgclJmyA5NM100uPtV4Zl1uN0FVHtoQFPQ==@kvack.org
X-Gm-Message-State: APuU4Z+lhPJboIvSjnks9hCU10tg77SNR4mA3i2mbnKl1y75zD+OLOvO
	PgKRq/B1/BKTlEBq7n/hvCk0wMqrc/i/6Nx9nb7CVNdU7wJcj32u6aTANkOb3jAKIOlNMYMkypY
	HOyLxpNEAHYOUwQ==
X-Received: from plbma13.prod.google.com ([2002:a17:903:94d:b0:2ea:e1c7:d3a1])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3903:b0:2ea:192a:13b8 with SMTP id d9443c01a7336-2edb91f565emr13871085ad.20.1794288814617;
 Mon, 09 Nov 2026 21:33:34 -0800 (PST)
Date: Tue, 10 Nov 2026 05:33:28 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110053331.2708996-1-jiaqiyan@google.com>
Subject: [PATCH v7 0/3] Only free healthy pages in high-order folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: linmiaohe@huawei.com, vbabka@kernel.org
Cc: osalvador@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, osalvador@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5te5pjrc5kehjm8rkrxw9crip9b8gyhk
X-Rspamd-Queue-Id: 219AB20002
X-Rspam-User: 
X-HE-Tag: 1794288815-739462
X-HE-Meta: U2FsdGVkX182OS6CJvWGmkSFRbUi7hUIRqCiECGPZkCLyHgSrTZVQZEEmxJLyTEHyyOBkAwgQBTkNuySDXw3NItKp1m8TWHWqif2Fc8dbZib7FtYkIjcHRdwtzpcO+4NXqV0fYGdqIGnKInS0t0GS8a2Iy4yiY4jscuvpqKODliTVB6MN9WClk7E44aDnepJhvBk51pTOV0XOAlerzZIm2dAoMLXj3hu2rxslG0FGf6GXTw4ScfCAOZPECwXcqoY+VdgyVNq4Ni5pzT0tOsvGCfTeAYh7lHXVtOh/MXyTR5uVunEIasomd6D6jUt7h0yURoSvM201AzVmkOrO/PchGyVj/N0RYdCjVivT8V8oNOePKCCF7zjetocYlC50SpbpD/lDBmOfd2GHWwQZq/NT2vntApzzHiavP1Qe7tCaEZI1LcBk8tLDUTv+wJ8VFIWq5wzRSPIklK3Segn6wXGBAFfaWiJqo4bIFIB48jsqen+gUXx4X7V781XbywAwoRuqSaoHtbxVls62Xca4srdlGS0D6lJ6KfLNsCeKaEBOKOFN9onZPPPXs9d1kxJLq8IGytY4JN+i/qr0MD9f3mDoTCFcVJCX3EHC+oOaxV6F2+ESbHiWkHexyyKPo58OiMtRBmmXu8VPfSi452nqLA5HG6Q+MEb1ju8RFaoyPQEIMNxzqkBq3wjVs3t5ax8CD0KVIz0OszIXbcgJdU66e6xT2u1H+CkV6QidV8ZVCcGN0hVzRkdNZ0yBAUNqdkAMBtzcNWCTFvwiuL5AzCyUSi92K2AKgpjN/5s3WhqT33ktJzd1cWscR/pzpL4q4bqELOmm9T/ET4SDDxgwn92VHN7tynfhqAfTv5JgOKS+pynO24kBfBSQwmQGfJ7WjWHDTeKOhSOp2Zz2fmb1EBq3FK/HviDT5uN8OkKORTqEFxaK1K4+CsU61w0zJgaFE70AQNInY8xWyiiokuFjQfgHbj
 rNuKzYsS
 Z4vSSm4YEBl8I/U/aNP8HQ/wfyHb2NHdK4ZzLZcVHsUrRNymX7mxXwtaAiXt/SrCQ3jOv/t+4kSLaoJT8uy1BSxC94KjgyTA26w0nOw/cqr4IzZDcWhfYoOMtyosHzd6ugeVXXwKpAqOJOHX2ssybEercv0liFxQ4i6GQm5682l36Ag9f45vyO4hJrH0z1iDxlUTtg7TEsipIDEN5ZY/ZqPrJGdwCgX0Iy+RzZmWoqjJflRz7UAdhk71b6N0Qi6H+v+D0AB7+RLyNeCFzmIMEq+bmEF3m+tOX5GYzZ8VYTOLMhxYy6I8GZOvXBl4nFwKviYhOxiXcGGtkl9B2FkmfvNkLA0xjlU3sLFXq0Jhad/W2RsDqTX1aifx9xJ0RQ29pKf6vwmGLXRlMCUh3NVAI9OFRFDfjrhgeHg7HCLaA+xLcXDTb5M7LOQVpFynl+ZDE3ujLJ2ZT1dIBgg+BgPMDOUXA2VPAZMbPBYvMC9elVTrNy4ZB061g0CXRgA1plUtDUN5OZ3srTOkLa7EEi51fASuZ66tuHRMaVQewO9lkyq93YKCjs2lvMv89Q197REq88T6SQWkCt2xRrD2lj3VAjDj5XNy7rLt3IN9m6kOT45m5MxH7kBXtAUzK4Bgo0rX0Pvy2IjT3jR9I3NpERSFfmlsQJScxvTibePbihp4IM8kO2iQHsIg8Lc8C4BwsiX4ZbxCIo47qdJOK/FBQVniFQFXFB/BvfFQ4wiBmdZG4mT2lk1uFCk6wEQKgV3uR2GzEEbJssVAaaIZmJxiSQCHfI3hRsuAknU+xeDIuYFid5FxUR7MsHjOWq77eq7GLFcHGYFF2Xh3dsCn16dxU3YRxLDHzNQdf+xstPNWUMDAkIsSJDt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
folio becomes non-HugeTLB and is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) code (mm/memory-failure.c) does
attempt to take raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio(). However, there is always a time
window between dissolve_free_hugetlb_folio() frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator. Worse, a free HWPoison HugeTLB
folio can also be dissolved outside of MFR, e.g. when shrinking
the HugeTLB pool, and then nobody takes its HWPoison pages off
buddy allocator.

Another similar situation is when a transparent huge page (THP)
is handled by MFR but splitting failed. Such THP will eventually
be released to buddy allocator when owning userspace processes
are gone, but with certain subpages having HWPoison [9].

One obvious way to avoid these problems is to always check
PageHWPoison() when allocating pages, which check_new_pages()
only does if page sanity checks are enabled. However, it is
against the past efforts to reduce sanity check overhead [1,2,3].
As discussed in v6 [13], how HWPoison pages should be handled by
page allocator in general deserves a bigger rework; this patchset
only addresses the freeing side.

__free_pages_prepare() already walks through all tail pages of a
high-order folio to check and clear their flags, so counting
PageHWPoison() pages in that loop is cheap, as suggested by David
Hildenbrand [14]. If any HWPoison page is found, after all checks
and preparations in __free_pages_prepare() succeed, the newly
introduced free_has_hwpoisoned() only frees the healthy pages and
excludes the HWPoison ones in the high-order folio. Unlike
PG_has_hwpoisoned, which v6 relied on but is only maintained for
THP, this catches HWPoison pages in any high-order folio.

free_has_hwpoisoned() iterates through the sub-pages of the folio
to identify contiguous ranges of healthy pages. Instead of freeing
pages one by one, free_has_hwpoisoned() then re-uses
free_prepared_contig_range() [11] to decompose healthy ranges into
the largest possible chunks of different orders. Every chunk is
sanitized and then freed via __free_frozen_pages(). It stops
scanning once all HWPoison pages counted by __free_pages_prepare()
are found. Each excluded HWPoison page is marked HWPoisonTakenOff
with a refcount of 1, just like a page that memory_failure() takes
off buddy allocator, so that unpoison_memory() can put it back.

free_has_hwpoisoned() has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison() defines the
overall time complexity.

I tested with some test-only kernel code [4] and hugetlb-mfr [5],
and validated that HWPoison pages are excluded by free_has_hwpoisoned()
after dissolve_free_hugetlb_folio() a free 2M or 1G HugeTLB page that
contains 1~8 HWPoison raw pages.

To illustrate the latency free_has_hwpoisoned() adds to the memory
freeing path, I measured it on a 1G HugeTLB folio with 8 HWPoison
pages with instrument code [4, 5] for 20 sample runs, on a kernel
without KASAN and CONFIG_DEBUG_VM, and compared it with free_one_page()
of a healthy 1G folio:

- Last HWPoison page at the end of the folio (worst case):
  mean=767us, median=757us, stdev=29us (20 runs)

- free_one_page() of a healthy 1G folio:
  mean=50us, median=50us, stdev=3us

free_has_hwpoisoned() is in worst case around 15x the baseline. Its
cost is nontrivial, but still far from triggering soft lockup, and
fair for handling exceptional hardware memory errors.

Now that free_has_hwpoisoned() ensures HWPoison pages never make
it into buddy allocator, MFR doesn't need to take_page_off_buddy()
anymore after dissolving HWPoison hugepages. So the same patch
replaces __page_handle_poison() with new __hugepage_handle_poison()
at HugeTLB specific call sites. The two changes are in one patch
because neither works without the other. This patchset doesn't
affect the soft offline behavior in MFR, because soft offline marks
a page HWPoison only after taking it off buddy allocator.

To provide test coverage for the new __hugepage_handle_poison()
in me_huge_page(), the last commit adds a MADV_HARD test variant
for anonymous HugeTLB pages. It also covers the code path that
frees a HugeTLB page that contains 1 raw HWPoison page.

The commit message of patch 2 and this cover letter were reworded
with an AI assistant, which was also used to review the code; the
code changes are my own.

Based on commit 0ea6dc8c4a21 ("fs/proc/task_mmu: fix lost maps entries above 2^63")

Changelog

v6 [13] -> v7

- Rebase to recent akpm/mm-unstable.

- Patch 1: modify free_prepared_contig_range() to take fpi_t
  instead of adding a __free_prepared_contig_range() wrapper
  (Matthew Wilcox).

- Patch 2: count PageHWPoison() pages in the tail page loop of
  __free_pages_prepare() instead of relying on PG_has_hwpoisoned
  (David Hildenbrand [14]). Drop v6 patch 3/5 "mm/memory-failure:
  set has_hwpoisoned flags on dissolved HugeTLB folio" as it is no
  longer needed.

- Patch 2: pass the number of HWPoison pages to
  free_has_hwpoisoned(), which stops scanning once all of them are
  found.

- Patch 2: mark excluded HWPoison pages HWPoisonTakenOff with a
  refcount of 1, so that unpoison_memory() puts them back to buddy
  allocator instead of leaking them (Sashiko AI review).

- Patch 2: remove pr_info() in free_has_hwpoisoned() (Vlastimil
  Babka), and fix comments (Miaohe Lin).

- Fold v6 patch 4/5 "mm/memory-failure: skip take_page_off_buddy
  after dissolving HWPoison HugeTLB page" into patch 2, so that
  memory_failure() doesn't fail to recover HugeTLB folios between
  the two patches. Since free_has_hwpoisoned() already holds a
  refcount on the isolated page, callers of
  __hugepage_handle_poison() no longer page_ref_inc() it.

- Patch 2: __hugepage_handle_poison() no longer tests HugeTLB flags
  (e.g. raw_hwp_unreliable), because the folio may already be freed
  by folio_put() in me_huge_page() or by a concurrent dissolve.
  Instead, it tells success by whether the raw HWPoison page is
  HWPoisonTakenOff after dissolving. Since commit a363c62a653c
  ("mm/hugetlb: do not dissolve gigantic pages without runtime support"),
  dissolve_free_hugetlb_folio() also fails properly on gigantic folios
  without runtime support (Miaohe Lin).

- Patch 3: use HUGETLB_SETUP_DEFAULT_PAGES() so that HugeTLB
  settings are restored after the test (Sashiko AI review).

- Re-measure the performance cost of free_has_hwpoisoned() in v7.

- Drop Reviewed-by from Miaohe Lin and Vlastimil Babka on patch 2
  due to the substantial changes above.

v5 [12] -> v6

- Rebase to recent akpm/mm-unstable and address comments from Zi Yan,
  Miaohe Lin, Vlastimil Babka.

- Extract free_pages_sanitize() to avoid touching HWPoison page(s)
  at the end of __free_pages_prepare().

- Introduce FPI_SANITIZE and add a fpi_t argument to the freeing path
  free_has_hwpoisoned() -> __free_prepared_contig_range(), so that
  healthy page blocks are sanitized before __free_frozen_pages().

- Make free_has_hwpoisoned() be compatible with order==0.

- Repeat the previous test done on both X86 and ARM64 machines.
  CONFIG_KASAN + CONFIG_KASAN_SW_TAGS + kasan.fault=report are
  enabled on the ARM64 machine.

v4 [10] -> v5

- Rebase to very recent akpm/mm-unstable.

- Re-use free_prepared_contig_range() introduced by [11], and remove
  free_contiguous_pages() in v4.

- Instead of using struct page pointer, iterate over pfn in
  free_has_hwpoison().

- Re-tested and re-evaluated free_has_hwpoison()'s time cost.

- Add memory failure recovery test for anonymous 1G HugeTLB page to
  gain test coverage for __hugepage_handle_poison() and for freeing
  1G HugeTLB page that has 1 HWPoison page.

v3 [8] -> v4

- Address comments from Zi Yan, Miaohe Lin, Harry Yoo.

- Set has_hwpoisoned flag after introducing free_has_hwpoisoned().

- Unwrap free_pages_prepare_has_hwpoisoned() into free_pages_prepare().

- If folio has HWPoison, its healthy pages will be freed with FPI_NONE
  right in free_pages_prepare(), who returns false to indicate caller
  should not proceeding its own freeing action.

- Rework the commit on __page_handle_poison. Only change the handling
  for HWPoison HugeTLB page, leaving free buddy page and soft offline
  handling alone.

v2 [7] -> v3:

- Address comments from Mathew Wilcox, Harry Hoo, Miaohe Lin.

- Let free_has_hwpoisoned() happen after free_pages_prepare(),
  which help to deal with decomposing the original compound page,
  and with page metadata like alloc tag and page owner.

- Tested with "page_owner=on" and CONFIG_MEM_ALLOC_PROFILING*=y.

- Wrap checking PG_has_hwpoisoned and free_has_hwpoisoned() into
  free_pages_prepare_has_hwpoisoned(), which replaces
  free_pages_prepare() calls in free_frozen_pages().

- Rename free_has_hwpoison_page() to free_has_hwpoisoned().

- Measure latency added by free_has_hwpoisoned().

- Ensure struct page *end is only used for pointer arithmetic,
  instead of accessed as page.

- Refactor page_handl_poison instead of just __page_handle_poison().

v1 [6] -> v2:

- Total reimplementation based on discussions with Mathew Wilcox,
  Harry Hoo, Zi Yan etc

- hugetlb_free_hwpoison_folio() => free_has_hwpoison_pages().

- Utilize has_hwpoisoned flag to tell buddy allocator a high-order
  folio contains HWPoison.

- Simplify __page_handle_poison() given that the HWPoison page(s)
  won't be freed within high-order folio.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/view?usp=sharing
[5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com
[6] https://lore.kernel.org/linux-mm/20251116014721.1561456-1-jiaqiyan@google.com
[7] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@google.com
[8] https://lore.kernel.org/linux-mm/20260112004923.888429-1-jiaqiyan@google.com
[9] https://lore.kernel.org/linux-mm/20260113205441.506897-1-boudewijn@delta-utec.com
[10] https://lore.kernel.org/linux-mm/20260202194125.2191216-1-jiaqiyan@google.com
[11] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com
[12] https://lore.kernel.org/linux-mm/20260531055829.3636554-1-jiaqiyan@google.com
[13] https://lore.kernel.org/linux-mm/20260705180714.3708947-1-jiaqiyan@google.com
[14] https://lore.kernel.org/linux-mm/8e48c288-2183-4d58-b69d-5f78344b5da5@kernel.org

Jiaqi Yan (3):
  mm/page_alloc: free_prepared_contig_range() takes fpi_t
  mm/page_alloc: only free healthy pages in high-order folio
  selftests/mm: add hard memory failure anonymous HugeTLB test

 mm/internal.h                               |   3 +
 mm/memory-failure.c                         |  52 ++++--
 mm/page_alloc.c                             | 180 ++++++++++++++++----
 tools/testing/selftests/mm/memory-failure.c |  67 +++++++-
 4 files changed, 252 insertions(+), 50 deletions(-)

-- 
2.56.0.506.g506a7eabc5-goog


